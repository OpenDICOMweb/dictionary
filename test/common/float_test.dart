// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';
import 'dart:math';

import 'package:dictionary/src/common/float.dart';
import 'package:dictionary/src/common/utils.dart';
import 'package:test/test.dart';

//TODO: add more data - negative numbers, integers, large fractions
List<double> dList0 = <double>[.0, .1, .2, .3, .4];

// dynamically changing the data for each test
Random refLength = new Random();

Uint8List getOffsetFloat32List(List<double> vList, int offsetAt) {
  Float32List f32 = (vList is Float32List) ? vList : new Float32List.fromList(dList0);
  ByteData unalignedBD = new ByteData(f32.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < f32.length; i++, oib += Float32.sizeInBytes) {
    unalignedBD.setFloat32(oib + offsetAt, f32[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

Uint8List getOffsetFloat64List(List<double> vList, int offsetAt) {
  Float64List f64 = (vList is Float64List) ? vList : new Float64List.fromList(dList0);
  ByteData unalignedBD = new ByteData(f64.lengthInBytes + offsetAt);
  for (int i = 0, oib = 0; i < f64.length; i++, oib += Float64.sizeInBytes) {
    unalignedBD.setFloat64(oib + offsetAt, f64[i], Endianness.HOST_ENDIAN);
  }
  return unalignedBD.buffer.asUint8List();
}

bool haveSharedBuffer(TypedData a, TypedData b) => a.buffer == b.buffer;

void float32Test() {
  test('Float32List-ViewOfBytes Aligned Test', () {
    //TODO: why 246 and 7.6457?
    for (int i = 0; i < refLength.nextInt(10); i++) {
      dList0.add(refLength.nextInt(246) * 7.6457);
    }

    print('dList0: $dList0');
    Float32List f32 = new Float32List.fromList(dList0);
    Float32List vList;
    print('f32: $f32');

    int loopCount = dList0.length + refLength.nextInt(10);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += Float32.sizeInBytes) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetFloat32List(f32, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Float32.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(f32, vList);
      print('identical: $v');
      expect(v, false);

      v = Float32.equal(f32, vList);
      print('length: a: ${f32.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList0.removeRange((dList0.length / 9).round(), (dList0.length / 7).round());
  });

  test('Float32List-ViewOfBytes Unaligned Test', () {
    Float32List f32, list0, list1;
    print('\ndList_0: $dList0');
    f32 = new Float32List.fromList(dList0);
    print('f32: $f32');

    for (int offset = 1;
        offset < dList0.length + refLength.nextInt(12);
        offset += Float32.sizeInBytes) {
      print('$offset: offset: $offset');
      // create a Uint32List containing f32, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetFloat32List(f32, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to f32
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Float32 alignment
      bool v = Float32.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % 4 == 0) ? true : false);

      list0 = Float32.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(f32, list0);
      print('identical: $v');
      expect(v, false);

      v = Float32.equal(f32, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Float32.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Float32.equal(list0, list1);
      expect(v, false);
    }
  });
}

void float64Test() {
  test('Float64List-ViewOfBytes Aligned Test', () {
    for (int i = 0; i < refLength.nextInt(10); i++) {
      dList0.add(refLength.nextInt(246) * 754.4278);
    }

    print('dList0: $dList0');
    Float32List f32 = new Float32List.fromList(dList0);
    Float32List vList;
    print('f32: $f32');

    int loopCount = dList0.length + refLength.nextInt(10);
    for (int i = 0, offset = 0; i < loopCount; i++, offset += 4) {
      print('$i: offset: $offset');
      Uint8List aligned = getOffsetFloat32List(f32, offset);
      print('aligned: $aligned');
      print('aligned oIB: ${aligned.offsetInBytes}');
      Uint8List bytes = aligned.buffer.asUint8List(offset);
      print('bytes: $bytes');

      bool v = isAligned(bytes);
      print('bytes isAligned: $v');
      expect(v, true);

      vList = Float32.viewOfBytes(bytes);
      print('vList: $vList');

      v = haveSharedBuffer(bytes, vList);
      print('hasSharedBuffer: $v');
      expect(v, true);

      v = identical(f32, vList);
      print('identical: $v');
      expect(v, false);

      v = Float32.equal(f32, vList);
      print('length: a: ${f32.length}, b: ${vList.length}');
      print('equal: $v');
      expect(v, true);
    }
    dList0.removeRange((dList0.length / 9).round(), (dList0.length / 7).round());
  });

  test('Float64List-ViewOfBytes Unaligned Test', () {
    Float64List f64, list0, list1;
    print('\ndList_0: $dList0');
    f64 = new Float64List.fromList(dList0);
    print('f64: $f64');

    for (int offset = 1; offset < dList0.length + refLength.nextInt(12); offset += 2) {
      print('$offset: offset: $offset');
      // create a Uint64List containing f64, but offset by [offset] bytes.
      Uint8List unaligned = getOffsetFloat64List(f64, offset);
      print('unaligned: $unaligned');
      // create Uint8List corresponding to f64
      Uint8List bytes = unaligned.buffer.asUint8List(offset);
      print('unaligned.offset(${unaligned.offsetInBytes}), bytes.offset(${bytes.offsetInBytes})');
      print('bytes: $bytes');

      // check Float64 alignment
      bool v = Float64.isAligned(bytes);
      print('isAligned: $v');
      expect(v, (offset % 4 == 0) ? true : false);

      list0 = Float64.viewOfBytes(bytes);
      print('vList0: $list0');
      v = identical(f64, list0);
      print('identical: $v');
      expect(v, false);

      v = Float64.equal(f64, list0);
      print('equal: $v');
      expect(v, true);

      list1 = Float64.viewOfBytes(unaligned);
      print('vList1: $list1');
      v = Float64.equal(list0, list1);
      expect(v, false);
    }
  });
}

void main() {
  float32Test();
  float64Test();
}
