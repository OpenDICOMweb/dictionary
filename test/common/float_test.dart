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
}

final List<double> data_0 = const <double>[.0, .1, .2, .3, .4];
final Float32List float32_0 = new Float32List.fromList(data_0);
final Float32List float64_0 = new Float32List.fromList(data_0);

float32Eq(a, b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for(int i = 0; i < a.length; i++)
    if (a[i] != b[i]) return false;
  return true;
}

void float32Test() {

//  print('data0: $data_0');
  Float32List data0Float32 = new Float32List.fromList(data_0);
//  print('data0Float32 length(${data0Float32.length}), lengthIB(${data0Float32.lengthInBytes})');
//  print('data0AsFloat32: $data0Float32');

  ByteData newBD = new ByteData(data0Float32.lengthInBytes + 2);
//  print('newBD lengthIB(${newBD.lengthInBytes})');

  ByteData data0AsBD = data0Float32.buffer.asByteData();
//  print('data0AsBD lengthIB(${data0AsBD.lengthInBytes})');

  for (int i = 0; i < data0AsBD.lengthInBytes; i += 4) {
    double d0 = data0AsBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
    // print('d0: $d0');
    newBD.setFloat32(i + 2, d0, Endianness.HOST_ENDIAN);
    double d1 = newBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
  //  print('d0: $d0 d1: $d0');
  }

  Uint8List uint8 = newBD.buffer.asUint8List(2);
  Float32List fl = uint8.buffer.asFloat32List();
  print('fl as Float32: $fl');


  Uint8List bytes = newBD.buffer.asUint8List();
  Float32List view = Float32.viewOfBytes(bytes, 2, data_0.length);
  for (int i = 0; i < view.length; i++) {
    print('$i, data0(${data_0[i]}), view(${view[i]}}');
  }
  print('data0: $data_0');
  print('view: $view');

  test('Float32.viewOfBytes Aligned', () {
    bool v = identical(float32_0, float32_0);
    print('v: $v');
    expect(v, true);
    v = Float32.equal(float32_0, float32_0);
    print('v: $v');
    expect(v, true);
    Float32List f0 = new Float32List.fromList(float32_0);
    v = Float32.equal(float32_0, f0);
    print('v: $v');
    expect(v, true);
    Uint8List b0 = f0.buffer.asUint8List();
    Float32List view0 = Float32.viewOfBytes(b0);
    v = Float32.equal(float32_0, view0);
    print('v: $v');
    expect(v, true);
    v = identical(float32_0.buffer, view0.buffer);
    print('v: $v - ${float32_0.buffer}, ${view0.buffer}');
    expect(v, true);

  });

  test('Float32 positive fraction', (){
    print('data0: $data_0');
    Float32List data0Float32 = new Float32List.fromList(data_0);
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
    Float32List view = Float32.viewOfBytes(bytes, 2, data_0.length);
    for (int i = 0; i < view.length; i++) {
      print('$i, data0(${data_0[i]}), view(${view[i]}}');
    }
    print('data0: $data0Float32');
    print('view: $view');

    expect(float32Eq(data0Float32, view), true);
});

}