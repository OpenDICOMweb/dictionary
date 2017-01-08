// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/common/utils.dart';
import 'package:test/test.dart';


bool haveSharedBuffer(TypedData a, TypedData b) => a.buffer == b.buffer;

//TODO: create more data for testing
final List<int> dList_0 = const <int>[1, 2, 3, 4, 5];


Uint8List getOffsetInt8List(List<int> vList, int offsetAt) {
  Int8List i8 = (vList is Int8List) ? vList : new Int8List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(i8.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < i8.length; i++, oib += Int8.sizeInBytes) {
    unalignedBD.setInt8(oib + offsetAt, i8[i]);
  }
  return unalignedBD.buffer.asUint8List();
}

void int8Test() {
  test('ViewOfBytes Aligned Test', () {
    print('dList0: $dList_0');
    Int8List i8 = new Int8List.fromList(dList_0);
    Int8List vList;
    print('i8: $i8');

    int loopCount = 3;
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Int8.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetInt8List(i8, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Int8.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(i8, vList);
      print('identical: $v');
      expect(v, false);

      v = Int8.equal(i8, vList);
      print('length: a: ${i8.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
  });

  test('ViewOfBytes Unaligned Test', () {
    Int8List i8, list0, list1;
    print('\ndList_0: $dList_0');
    i8 = new Int8List.fromList(dList_0);
    print('i8: $i8');

    for (int offset = 1; offset < 4; offset += Int8.sizeInBytes) {
      print('\n$offset: offset: $offset');
      // create a Uint32List containing i8, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetInt8List(i8, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to i8
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Int8 alignment
      bool v = Int8.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Int8.sizeInBytes == 0) ? true : false);

      list0 = Int8.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(i8, list0);
      print('identical: $v');
      expect(v, false);

      v = Int8.equal(i8, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Int8.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Int8.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetInt16List(List<int> vList, int offsetAt) {
  Int16List i16 = (vList is Int16List) ? vList : new Int16List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(i16.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < i16.length; i++, oib += Int16.sizeInBytes) {
    unalignedBD.setInt16(oib + offsetAt, i16[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void int16Test() {
  test('ViewOfBytes Aligned Test', () {
    print('dList0: $dList_0');
    Int16List i16 = new Int16List.fromList(dList_0);
    Int16List vList;
    print('i16: $i16');

    int loopCount = 3;
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Int16.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetInt16List(i16, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Int16.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(i16, vList);
      print('identical: $v');
      expect(v, false);

      v = Int16.equal(i16, vList);
      print('length: a: ${i16.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
  });

  test('ViewOfBytes Unaligned Test', () {
    Int16List i16, list0, list1;
    print('\ndList_0: $dList_0');
    i16 = new Int16List.fromList(dList_0);
    print('i16: $i16');

    for (int offset = 1; offset < 9; offset += Int16.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing i16, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetInt16List(i16, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to i16
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Int16 alignment
      bool v = Int16.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Int16.sizeInBytes == 0) ? true : false);

      list0 = Int16.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(i16, list0);
      print('identical: $v');
      expect(v, false);

      v = Int16.equal(i16, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Int16.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Int16.equal(list0, list1);
      expect(v, false);
    }
  });
}


void main() {
  int8Test();
  int16Test();
  //int32Test();
  //int64Test();
  //uint8Test();
  //int16Test();
  //int32Test();
  //int64Test();
}