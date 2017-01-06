// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dictionary/src/common/float.dart';

final List<double> data_0 = const <double>[.0, .1, .2, .3, .4];
final Float32List float32_0 = new Float32List.fromList(data_0);
final Float32List float64_0 = new Float32List.fromList(data_0);

Uint8List createUnalignedFloat32List(List<double> vList, int offsetAt) {
  Float32List fl32Data = (vList is Float32List) ? vList : new Float32List.fromList(data_0);
  ByteData fl32AsBD = fl32Data.buffer.asByteData();
  ByteData unalignedBD = new ByteData(fl32Data.lengthInBytes + offsetAt);

  for (int i = 0; i < fl32AsBD.lengthInBytes; i += Float32.sizeInBytes) {
    double d0 = fl32AsBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
    // print('d0: $d0');
    unalignedBD.setFloat32(i + offsetAt, d0, Endianness.LITTLE_ENDIAN);
    double d1 = unalignedBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
    //  print('d0: $d0 d1: $d0');
  }
  return unalignedBD.buffer.asUint8List();
}

Uint8List createUnalignedFloat64List(List<double> vList, int offsetAt) {
  Float64List fl64Data = (vList is Float64List) ? vList : new Float64List.fromList(data_0);
  ByteData fl64AsBD = fl64Data.buffer.asByteData();
  ByteData unalignedBD = new ByteData(fl64Data.lengthInBytes + offsetAt);

  for (int i = 0; i < fl64AsBD.lengthInBytes; i += Float64.sizeInBytes) {
    double d0 = fl64AsBD.getFloat64(i, Endianness.LITTLE_ENDIAN);
    // print('d0: $d0');
    unalignedBD.setFloat64(i + offsetAt, d0, Endianness.LITTLE_ENDIAN);
    double d1 = unalignedBD.getFloat64(i, Endianness.LITTLE_ENDIAN);
    //  print('d0: $d0 d1: $d0');
  }
  return unalignedBD.buffer.asUint8List();
}

List<double> data0 = [78665.478];
List<double> data1 = [0.9, 0.8, 0.7, 0.6];

void main () {
  List<double> data0 = [78665.478];
  print('data0: $data0');
  Float32List f32 = new Float32List.fromList(data0);
  print('f32: $f32');
  String b64 = BASE64.encode(f32.buffer.asUint8List());
  print('b64: $b64');
  Uint8List out = BASE64.decode(b64);
  Float32List result = out.buffer.asFloat32List();
  print('result: $result');

  print('data1: $data1');
  f32 = new Float32List.fromList(data1);
  print('f32: $f32');
  b64 = BASE64.encode(f32.buffer.asUint8List());
  print('b64: $b64');
  out = BASE64.decode(b64);
  result = out.buffer.asFloat32List();
  print('result: $result');

  //  print('data0: $data_0');
  Float32List float32_0 = new Float32List.fromList(data1);
  for(int offset = 0; offset < 5; offset++) {
    print('offset: $offset');
    Uint8List unaligned = createUnalignedFloat32List(float32_0, offset);
    print('unaligned: $unaligned');
    b64 = BASE64.encode(unaligned);
    print('b64: $b64');
    out = BASE64.decode(b64);
    print('out: out');
    Float32List vList = Float32.viewOfBytes(out, offset);
    print('vList: $vList');
  }

  Float64List float64_0 = new Float64List.fromList(data1);
  for(int offset = 0; offset < 5; offset++) {
    print('offset: $offset');
    Uint8List unaligned = createUnalignedFloat64List(float64_0, offset);
    print('unaligned: $unaligned');
    b64 = BASE64.encode(unaligned);
    print('b64: $b64');
    out = BASE64.decode(b64);
    print('out: out');
    Float64List vList = Float64.viewOfBytes(out, offset);
    print('vList: $vList');
  }

  double fd = 78665.478;
  print('fd: $fd');
  String fString = fd.toStringAsPrecision(8);
  print('fString: $fString');
  b64 = BASE64.encode(UTF8.encode(fString));
  print('b64: $b64');
  String s = UTF8.decode(BASE64.decode(b64));
  print('s: $s');
  double fOut = double.parse(s);
  print('fOut: $fOut');
  print('fd($fd) == fOut($fOut): ${fd == fOut}');


  //  print('data0: $data_0');
  float32_0 = new Float32List.fromList(data1);
  for(int offset = 0; offset < 5; offset++) {
    print('offset: $offset');
    Uint8List unaligned = createUnalignedFloat32List(float32_0, offset);
    print('unaligned: $unaligned');
    b64 = BASE64.encode(unaligned);
    print('b64: $b64');
    out = BASE64.decode(b64);
    print('out: out');
    Float32List vList = Float32.viewOfBytes(out, offset);
    print('vList: $vList');
  }

  float64_0 = new Float64List.fromList(data1);
  for(int offset = 0; offset < 5; offset++) {
    print('offset: $offset');
    Uint8List unaligned = createUnalignedFloat64List(float64_0, offset);
    print('unaligned: $unaligned');
    b64 = BASE64.encode(unaligned);
    print('b64: $b64');
    out = BASE64.decode(b64);
    print('out: out');
    Float64List vList = Float64.viewOfBytes(out, offset);
    print('vList: $vList');
  }

}
