// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/reader/string_reader.dart';
import 'package:test/test.dart';

main() {
  simpleReadTest();
}

simpleReadTest() {
  test("Empty Buffer Test", () {
    String s0 = "";
    StringReader buf = new StringReader(s0);
    int length = s0.length;

    // check length, index, and simple read error
    expect(buf.length, equals(length));
    expect(buf.index, equals(0));
    expect(buf.read, equals(null));
    expect(buf.index, equals(0));

    // check skip on 0 length buffer
    expect(buf.skip(1), equals(null));
    expect(buf.skip(-1), equals(null));
    expect(buf.index, equals(0));
  });

  test("Simple String Read Test", () {
    String s1 = "abcdefg";
    StringReader buf = new StringReader(s1);
    int length = s1.length;

    expect(buf.length, equals(length));
    // read one character at a time
    expect(buf.read, equals("a".codeUnitAt(0)));
    expect(buf.read, equals("b".codeUnitAt(0)));
    expect(buf.read, equals("c".codeUnitAt(0)));
    expect(buf.read, equals("d".codeUnitAt(0)));
    expect(buf.read, equals("e".codeUnitAt(0)));
    expect(buf.read, equals("f".codeUnitAt(0)));
    expect(buf.read, equals("g".codeUnitAt(0)));
    expect(buf.read, equals(null));
    buf.skip(-2);
    expect(buf.read, equals("f".codeUnitAt(0)));
    expect(buf.read, equals("g".codeUnitAt(0)));

    buf.skip(-length);
    expect(buf.read, equals("a".codeUnitAt(0)));
    expect(buf.read, equals("b".codeUnitAt(0)));
  });

  test("Uint Read Test", () {
    String s;
    int length;
    StringReader buf;

    s = "000";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("0".codeUnitAt(0)));
    expect(buf.readUintOfLength(2), equals(0));
    expect(buf.readUintOfLength(3), equals(0));
    expect(buf.readUintOfLength(4), equals(null));

    s = "123";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("1".codeUnitAt(0)));
    expect(buf.readUintOfLength(1), equals(1));
    expect(buf.readUintOfLength(2), equals(12));
    expect(buf.readUintOfLength(3), equals(123));
    expect(buf.readUintOfLength(4), equals(null));

    s = "12a3";
    buf = new StringReader(s);
    expect(buf.readUintOfLength(2), equals(12));
    expect(buf.readUintOfLength(3), equals(null));
  });

  test("VUint Read Test", () {
    String s;
    int length;
    StringReader buf;

    s = "00000";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("0".codeUnitAt(0)));
    expect(buf.readUint(5), equals(0));
    expect(buf.readUint(6), equals(null));

    s = "123456";
    buf = new StringReader(s);
    expect(buf.readUintOfLength(1), equals(1));
    expect(buf.readUintOfLength(2), equals(12));
    expect(buf.readUintOfLength(3), equals(123));
    expect(buf.readUintOfLength(4), equals(1234));
    expect(buf.readUintOfLength(5), equals(12345));
    expect(buf.readUintOfLength(6), equals(123456));
    expect(buf.readUintOfLength(7), equals(null));

    s = "12a3";
    buf = new StringReader(s);
    expect(buf.readUint(-1), equals(null));
    expect(buf.readUint(0), equals(null));
    expect(buf.readUint(2), equals(12));
    expect(buf.readUint(3), equals(12));
    expect(buf.readUint(4), equals(12));
  });

  test("Int Read Test", () {
    String s;
    int length;
    StringReader buf;

    s = "+1";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("+".codeUnitAt(0)));
    expect(buf.read, equals("1".codeUnitAt(0)));
    buf.reset;
    expect(buf.index, equals(0));
    print('index: ${buf.index}');
    print('x: ${buf.readInt(1)}');
    buf.reset;
    expect(buf.readInt(1), equals(1));

    s = "-1";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("-".codeUnitAt(0)));
    buf.reset;
    expect(buf.readInt(1), equals(-1));

    s = "1";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.read, equals("1".codeUnitAt(0)));
    buf.reset;
    expect(buf.readInt(1), equals(1));
  });

  test("Hex Read Test", () {
    String s;
    int length;
    StringReader buf;

    s = "0a";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    // expect(buf.read, equals("0".codeUnitAt(0)));
    expect(buf.hex, equals(0));
    expect(buf.hex, equals(10));
    buf.reset;
    expect(buf.readHex(2), equals(0xa));

    s = "abcdef";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.readHex(0), equals(null));
    expect(buf.readHex(1), equals(0xa));
    buf.reset;
    expect(buf.readHex(2), equals(0xab));
    buf.reset;
    expect(buf.readHex(3), equals(0xabc));
    buf.reset;
    expect(buf.readHex(4), equals(0xabcd));
    buf.reset;
    expect(buf.readHex(5), equals(0xabcde));
    buf.reset;
    expect(buf.readHex(6), equals(0xabcdef));
    buf.reset;
    expect(buf.readHex(7), equals(null));

    s = "0a1b2c3d4e5f";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.readHex(0), equals(null));
    expect(buf.readHex(2), equals(0x0a));
    buf.reset;
    expect(buf.readHex(4), equals(0x0a1b));
    buf.reset;
    expect(buf.readHex(6), equals(0x0a1b2c));
    buf.reset;
    expect(buf.readHex(8), equals(0x0a1b2c3d));
    buf.reset;
    expect(buf.readHex(10), equals(0x0a1b2c3d4e));
    buf.reset;
    expect(buf.readHex(12), equals(0x0a1b2c3d4e5f));
    buf.reset;
    expect(buf.readHex(14), equals(null));

    s = "0a1b2c3d4e5f";
    length = s.length;
    buf = new StringReader(s);
    expect(buf.length, equals(length));
    expect(buf.readVHex(0), equals(null));
    buf.reset;
    expect(buf.readVHex(2), equals(0x0a));
    buf.reset;
    expect(buf.readVHex(3), equals(0x0a1));
    buf.reset;
    expect(buf.readVHex(5), equals(0x0a1b2));
    buf.reset;
    expect(buf.readVHex(6), equals(0x0a1b2c));
    buf.reset;
    expect(buf.readVHex(8), equals(0x0a1b2c3d));
    buf.reset;
    expect(buf.readVHex(9), equals(0x0a1b2c3d4));
    buf.reset;
    expect(buf.readVHex(14), equals(0x0a1b2c3d4e5f));

  });
}

readVUintTest() {
  test("Read VUint Test", () {
    String s0 = "";
    StringReader buf = new StringReader(s0);
    int length = s0.length;

    // check length, index, and simple read error
    expect(buf.length, equals(length));
    expect(buf.index, equals(0));
    expect(buf.read, equals(null));
    expect(buf.index, equals(0));

    // check skip on 0 length buffer
    expect(buf.skip(1), equals(null));
    expect(buf.skip(-1), equals(null));
    expect(buf.index, equals(0));
  });
}