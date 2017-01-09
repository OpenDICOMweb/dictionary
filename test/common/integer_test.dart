// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';
import 'dart:math';

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/common/utils.dart';
import 'package:test/test.dart';


bool haveSharedBuffer(TypedData a, TypedData b) => a.buffer == b.buffer;

//TODO: create more data for testing
List<int> dList_0 = <int>[1, 2, 3, 4, 5]; // dynamically changing the data for each test
var reflength = new Random();

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

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }

    print('dList0: $dList_0');
    Int8List i8 = new Int8List.fromList(dList_0);
    Int8List vList;
    print('i8: $i8');

    int loopCount = dList_0.length+ reflength.nextInt(10);
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
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Int8List i8, list0, list1;
    print('\ndList_0: $dList_0');
    i8 = new Int8List.fromList(dList_0);
    print('i8: $i8');

    for (int offset = 1; offset < dList_0.length+reflength.nextInt(12); offset += Int8.sizeInBytes) {
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

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }
    print('dList0: $dList_0');
    Int16List i16 = new Int16List.fromList(dList_0);
    Int16List vList;
    print('i16: $i16');

    int loopCount = dList_0.length + reflength.nextInt(10);
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
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Int16List i16, list0, list1;
    print('\ndList_0: $dList_0');
    i16 = new Int16List.fromList(dList_0);
    print('i16: $i16');

    for (int offset = 1; offset < dList_0.length+ reflength.nextInt(13); offset += Int16.sizeInBytes) {
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

Uint8List getOffsetInt32List(List<int> vList, int offsetAt) {
  Int32List i32 = (vList is Int32List) ? vList : new Int32List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(i32.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < i32.length; i++, oib += Int32.sizeInBytes) {
    unalignedBD.setInt32(oib + offsetAt, i32[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void int32Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }

    print('dList0: $dList_0');
    Int32List i32 = new Int32List.fromList(dList_0);
    Int32List vList;
    print('i32: $i32');

    int loopCount = dList_0.length+ reflength.nextInt(10);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Int32.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetInt32List(i32, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Int32.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(i32, vList);
      print('identical: $v');
      expect(v, false);

      v = Int32.equal(i32, vList);
      print('length: a: ${i32.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Int32List i32, list0, list1;
    print('\ndList_0: $dList_0');
    i32 = new Int32List.fromList(dList_0);
    print('i16: $i32');

    for (int offset = 1; offset <  dList_0.length+ reflength.nextInt(10); offset += Int32.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint8List containing i32, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetInt32List(i32, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to i32
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Int32 alignment
      bool v = Int32.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Int32.sizeInBytes == 0) ? true : false);

      list0 = Int32.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(i32, list0);
      print('identical: $v');
      expect(v, false);

      v = Int32.equal(i32, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Int32.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Int32.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetInt64List(List<int> vList, int offsetAt) {
  Int64List i64 = (vList is Int64List) ? vList : new Int64List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(i64.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < i64.length; i++, oib += Int64.sizeInBytes) {
    unalignedBD.setUint64(oib + offsetAt, i64[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void int64Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }

    print('dList0: $dList_0');
    Int64List i64 = new Int64List.fromList(dList_0);
    Int64List vList;
    print('i64: $i64');

    int loopCount = dList_0.length+ reflength.nextInt(10);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Int64.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetInt64List(i64, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Int64.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(i64, vList);
      print('identical: $v');
      expect(v, false);

      v = Int64.equal(i64, vList);
      print('length: a: ${i64.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Int64List i64, list0, list1;
    print('\ndList_0: $dList_0');
    i64 = new Int64List.fromList(dList_0);
    print('i16: $i64');

    for (int offset = 1; offset <  dList_0.length+ reflength.nextInt(10); offset += Int64.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint8List containing i64, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetInt64List(i64, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to i64
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Int64 alignment
      bool v = Int64.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Int64.sizeInBytes == 0) ? true : false);

      list0 = Int64.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(i64, list0);
      print('identical: $v');
      expect(v, false);

      v = Int64.equal(i64, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Int64.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Int64.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetUint8List(List<int> vList, int offsetAt) {
  Uint8List uI8 = (vList is Uint8List) ? vList : new Uint8List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(uI8.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < uI8.length; i++, oib += Uint8.sizeInBytes) {
    unalignedBD.setUint8(oib + offsetAt, uI8[i]);
  }
  return unalignedBD.buffer.asUint8List();
}

void uInt8Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }

    print('dList0: $dList_0');
    Uint8List uI8 = new Uint8List.fromList(dList_0);
    Uint8List vList;
    print('uI8: $uI8');

    int loopCount = dList_0.length+ reflength.nextInt(15);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Uint8.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetUint8List(uI8, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Uint8.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(uI8, vList);
      print('identical: $v');
      expect(v, false);

      v = Uint8.equal(uI8, vList);
      print('length: a: ${uI8.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Uint8List uI8, list0, list1;
    print('\ndList_0: $dList_0');
    uI8 = new Uint8List.fromList(dList_0);
    print('uI8: $uI8');

    for (int offset = 1; offset <  dList_0.length+reflength.nextInt(17); offset += Uint8.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing uI8, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetUint8List(uI8, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to uI8
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Uint8 alignment
      bool v = Uint8.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Uint8.sizeInBytes == 0) ? true : false);

      list0 = Uint8.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(uI8, list0);
      print('identical: $v');
      expect(v, false);

      v = Uint8.equal(uI8, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Uint8.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Uint8.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetUint16List(List<int> vList, int offsetAt) {
  Uint16List uI16 = (vList is Uint16List) ? vList : new Uint16List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(uI16.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < uI16.length; i++, oib += Uint16.sizeInBytes) {
    unalignedBD.setUint16(oib + offsetAt, uI16[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void uInt16Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }

    print('dList0: $dList_0');
    Uint16List uI16 = new Uint16List.fromList(dList_0);
    Uint16List vList;
    print('uI16: $uI16');

    int loopCount = dList_0.length+ reflength.nextInt(18);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Uint16.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetUint16List(uI16, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Uint16.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(uI16, vList);
      print('identical: $v');
      expect(v, false);

      v = Uint16.equal(uI16, vList);
      print('length: a: ${uI16.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
  });

  test('ViewOfBytes Unaligned Test', () {
    Uint16List uI16, list0, list1;
    print('\ndList_0: $dList_0');
    uI16 = new Uint16List.fromList(dList_0);
    print('uI8: $uI16');

    for (int offset = 1; offset <  dList_0.length+ reflength.nextInt(30); offset += Uint8.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing uI8, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetUint16List(uI16, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to uI8
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Uint8 alignment
      bool v = Uint16.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Uint16.sizeInBytes == 0) ? true : false);

      list0 = Uint16.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(uI16, list0);
      print('identical: $v');
      expect(v, false);

      v = Uint16.equal(uI16, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Uint16.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Uint16.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetUint32List(List<int> vList, int offsetAt) {
  Uint32List uI32 = (vList is Uint32List) ? vList : new Uint32List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(uI32.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < uI32.length; i++, oib += Uint32.sizeInBytes) {
    unalignedBD.setUint16(oib + offsetAt, uI32[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void uInt32Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }
    print('dList0: $dList_0');
    Uint32List uI32 = new Uint32List.fromList(dList_0);
    Uint32List vList;
    print('uI32: $uI32');

    int loopCount = dList_0.length+ reflength.nextInt(10);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Uint32.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetUint32List(uI32, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Uint32.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(uI32, vList);
      print('identical: $v');
      expect(v, false);

      v = Uint32.equal(uI32, vList);
      print('length: a: ${uI32.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Uint32List uI32, list0, list1;
    print('\ndList_0: $dList_0');
    uI32 = new Uint32List.fromList(dList_0);
    print('uI32: $uI32');

    for (int offset = 1; offset <  dList_0.length + reflength.nextInt(14); offset += Uint32.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing uI8, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetUint32List(uI32, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to uI8
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Uint8 alignment
      bool v = Uint32.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Uint32.sizeInBytes == 0) ? true : false);

      list0 = Uint32.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(uI32, list0);
      print('identical: $v');
      expect(v, false);

      v = Uint32.equal(uI32, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Uint32.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Uint32.equal(list0, list1);
      expect(v, false);
    }
  });
}

Uint8List getOffsetUint64List(List<int> vList, int offsetAt) {
  Uint64List uI64 = (vList is Uint64List) ? vList : new Uint64List.fromList(dList_0);
  ByteData unalignedBD = new ByteData(uI64.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < uI64.length; i++, oib += Uint64.sizeInBytes) {
    unalignedBD.setUint16(oib + offsetAt, uI64[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

void uInt64Test() {
  test('ViewOfBytes Aligned Test', () {

    for(int i=0; i< reflength.nextInt(10); i++){
      dList_0.add(reflength.nextInt(246));
    }
    print('dList0: $dList_0');
    Uint64List uI64 = new Uint64List.fromList(dList_0);
    Uint64List vList;
    print('uI64: $uI64');

    int loopCount = dList_0.length+ reflength.nextInt(26);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Uint64.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetUint64List(uI64, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Uint64.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(uI64, vList);
      print('identical: $v');
      expect(v, false);

      v = Uint64.equal(uI64, vList);
      print('length: a: ${uI64.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList_0.removeRange((dList_0.length/9).round(),(dList_0.length/7).round());
  });

  test('ViewOfBytes Unaligned Test', () {
    Uint64List uI64, list0, list1;
    print('\ndList_0: $dList_0');
    uI64 = new Uint64List.fromList(dList_0);
    print('uI64: $uI64');

    for (int offset = 1; offset < dList_0.length+ reflength.nextInt(25); offset += Uint64.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing uI8, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetUint64List(uI64, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to uI8
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Uint8 alignment
      bool v = Uint64.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % Uint64.sizeInBytes == 0) ? true : false);

      list0 = Uint64.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(uI64, list0);
      print('identical: $v');
      expect(v, false);

      v = Uint64.equal(uI64, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Uint64.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Uint64.equal(list0, list1);
      expect(v, false);
    }
  });
}

void main() {
  int8Test();
  int16Test();
  int32Test();
  int64Test();
  uInt8Test();
  uInt16Test();
  uInt32Test();
  uInt64Test();
}