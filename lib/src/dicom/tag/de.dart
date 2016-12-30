// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


import 'dart:typed_data';

const int tagOffset = 0;
const int groupOffset = 0;
const int eltOffset = 0;

const List<int> foo = const [0x00080005, 1, 2, 3];
//const ByteData foo1 = const ByteData.view();

class Foo {
  final List<int> bytes;

  const Foo(this.bytes) ; // : const ByteData(def);

  static const x = const Foo(const [0x0008, 0x0005, 1, 2, 3]);

  int get a => bytes[0];
  int get b => bytes[1];

  //...
}

const List<int> fooList = const [0x00, 0x08, 0x00, 0x05, 1, 2, 3];
class Bar {
  final Uint8List bytes;

  const Bar(this.bytes);

  static final x =  new Bar(new Uint8List.fromList(fooList));

  int get a => bytes.buffer.asByteData(0).getUint16(0);
  int get b => bytes.buffer.asByteData(0).getUint16(2);

//...
}


class Baz {
  final ByteData bytes;

  const Baz(this.bytes);

  //TODO: fix
  //static final x =  const Baz(const <int>[0x00, 0x08, 0x00, 0x05, 1, 2, 3]);

  int get a => bytes.getUint16(0);
  int get b => bytes.getUint16(2);

//...
}

