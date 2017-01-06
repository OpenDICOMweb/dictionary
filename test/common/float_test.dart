// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/common/float.dart';
import 'package:test/test.dart';

void main() {

  float32Test();
  //float64Test();
}

final List<double> dList_0 = const <double>[.0, .1, .2, .3, .4];
final List<double> dList_1 = const <double>[1.0, 1.1, 1.2, 1.3, 1.4];
final List<double> dList_2 = const <double>[-1.0, -1.1, -1.2, -1.3, -1.4];

final Float32List f32_0 = new Float32List.fromList(dList_0);
final Float32List f32_1 = new Float32List.fromList(dList_0);
final Float32List f32_2 = new Float32List.fromList(dList_0);

final Float64List f64_0 = new Float64List.fromList(dList_0);
final Float64List f64_1 = new Float64List.fromList(dList_0);
final Float64List f64_2 = new Float64List.fromList(dList_0);




Uint8List createUnalignedFloat32List(List<double> vList, int offsetAt) {
  Float32List fl32Data = (vList is Float32List) ? vList : new Float32List.fromList(dList_0);
  ByteData fl32AsBD = fl32Data.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(fl32Data.lengthInBytes + offsetAt);

  print('unalignedUint8.offset: ${unalignedUint8.offsetInBytes}');

  for (int i = 0; i < fl32AsBD.lengthInBytes; i += Float32.sizeInBytes) {
    double d0 = fl32AsBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
    print('d0: $d0');
    unalignedUint8.setFloat32(i + offsetAt, d0, Endianness.LITTLE_ENDIAN);
    double d1 = unalignedUint8.getFloat32(i, Endianness.LITTLE_ENDIAN);
    print('d0: $d0 d1: $d0');
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedFloat64List(List<double> vList, int offsetAt) {
  Float64List fl64Data = (vList is Float64List) ? vList : new Float64List.fromList(dList_0);
  ByteData fl64AsBD = fl64Data.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(fl64Data.lengthInBytes + offsetAt);

  for (int i = 0; i < fl64AsBD.lengthInBytes; i += 4) {
    double d0 = fl64AsBD.getFloat64(i, Endianness.LITTLE_ENDIAN);
    // print('d0: $d0');
    unalignedUint8.setFloat64(i + offsetAt, d0, Endianness.LITTLE_ENDIAN);
    double d1 = unalignedUint8.getFloat64(i, Endianness.LITTLE_ENDIAN);
    //  print('d0: $d0 d1: $d0');
  }
  return unalignedUint8.buffer.asUint8List();
}


void float32Test() {

  test('Create Unaligned Test', () {
    print('dList0: $dList_0');
    Float32List f32 = new Float32List.fromList(dList_0);
    Float32List vList;
    for(int offset = 0; offset < 8; offset++) {
      Uint8List unaligned = createUnalignedFloat32List(f32, offset);
      Float32List f = unaligned.buffer.asFloat32List();

      bool v = Float32.isAlignedOffset(f.offsetInBytes);
      print('aligned: $v');
      expect(v, true);
      vList = Float32.viewOfBytes(unaligned, offset);
      print('vList: $vList');
      v =  identical(f32, vList);
      print('identical: $v');
      expect(v, false);
      v =  Float32.equal(f32, vList);
      print('equal: $v');
      expect(v, true);
      v =  Float32.isAligned(vList);
      print('aligned: $v');
     // expect(v, true);
    }
  });

  test('Float32.viewOfBytes Aligned', () {
    bool v = identical(f32_0, f32_0);
    print('v: $v');
    expect(v, true);
    v = Float32.equal(f32_0, f32_0);
    print('v: $v');
    expect(v, true);
    print('isAligned: ${Float32.isAligned(f32_0.offsetInBytes)}');
    expect(Float32.isAligned(f32_0.offsetInBytes), true);
    Float32List f0 = new Float32List.fromList(f32_0);
    v = Float32.equal(f32_0, f0);
    print('v: $v');
    expect(v, true);
    Uint8List b0 = f0.buffer.asUint8List();
    Float32List view0 = Float32.viewOfBytes(b0);
    v = Float32.equal(f32_0, view0);
    print('v: $v');
    expect(v, true);
    v = identical(f32_0.buffer, view0.buffer);
    print('v: $v - ${f32_0.buffer}, ${view0.buffer}');
    expect(v, true);

  });

  test('Float32.viewOfBytes Unaligned', () {
    Uint8List buf = createUnalignedFloat32List(f32_0, 3);
    Float32List f32Test= buf.buffer.asFloat32List();
    print('F32_0: $f32Test');
    print('f32Text: $f32Test');
    bool v = identical(f32_0, f32Test);
    print('Identical: $v');
    expect(v, false);
    v = Float32.equal(f32_0, f32Test);
    print('Equal: $v');
    expect(v, true);
    print('isAligned: ${Float32.isAligned(f32Test.offsetInBytes)}');
    expect(Float32.isAligned(f32Test.offsetInBytes), false);
    Float32List f0 = new Float32List.fromList(f32Test);
    v = Float32.equal(f32Test, f0);
    print('v: $v');
    expect(v, true);
    Uint8List b0 = f0.buffer.asUint8List();
    Float32List view0 = Float32.viewOfBytes(b0);
    v = Float32.equal(f0, view0);
    print('v: $v');
    expect(v, true);
    v = identical(f0.buffer, view0.buffer);
    print('v: $v - ${f0.buffer}, ${view0.buffer}');
    //TODO: why isn't buffer shared?
   // expect(v, true);

  });

  test('Float32 Positive Fraction', (){
    print('dList0: $dList_0');
    Float32List data0Float32 = new Float32List.fromList(dList_0);
    print('data0Float32 length(${data0Float32.length}), lengthIB(${data0Float32.lengthInBytes})');
    print('data0AsFloat32: $data0Float32');

    ByteData newBD = new ByteData(data0Float32.lengthInBytes + 2);
    print('newBD lengthIB(${newBD.lengthInBytes})');

    ByteData data0AsBD = data0Float32.buffer.asByteData();
    print('data0AsBD lengthIB(${data0AsBD.lengthInBytes})');

    for (int i = 0; i < data0AsBD.lengthInBytes; i += 4) {
      double d0 = data0AsBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
      // print('d0: $d0');
      newBD.setFloat32(i + 2, d0, Endianness.HOST_ENDIAN);
      double d1 = newBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
      print('d0: $d0 d1: $d0');
    }

    Uint8List uint8 = newBD.buffer.asUint8List(2);
    Float32List fl = uint8.buffer.asFloat32List();
    print('fl as Float32: $fl');


    Uint8List bytes = newBD.buffer.asUint8List();
    Float32List view = Float32.viewOfBytes(bytes, 2, dList_0.length);
    for (int i = 0; i < view.length; i++) {
      print('$i, dList0(${dList_0[i]}), view(${view[i]}}');
    }
    print('dList0: $dList_0');
    print('view: $view');

    expect(Float32.equal(dList_0, view), true);
});

}