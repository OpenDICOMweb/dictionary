// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

final List<double> data_0 = const <double>[.0, .1, .2, .3, .4];
final Float32List float32_0 = new Float32List.fromList(data_0);
final Float32List float64_0 = new Float32List.fromList(data_0);

Uint8List createUnalignedFloat32List(List<double> vList, int offsetAt) {
  Float32List fl32Data = (vList is Float32List) ? vList : new Float32List.fromList(data_0);
  ByteData fl32AsBD = fl32Data.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(fl32Data.lengthInBytes + offsetAt);

  for (int i = 0; i < fl32AsBD.lengthInBytes; i += 4) {
    double d0 = fl32AsBD.getFloat32(i, Endianness.LITTLE_ENDIAN);
    // print('d0: $d0');
    unalignedUint8.setFloat32(i + offsetAt, d0, Endianness.LITTLE_ENDIAN);
    double d1 = unalignedUint8.getFloat32(i, Endianness.LITTLE_ENDIAN);
    //  print('d0: $d0 d1: $d0');
  }
  return unalignedUint8.buffer.asUint8List();
}

void main () {
  List<double> data = [78665.478];
  print('data: $data');
  Float32List f32 = new Float32List.fromList(data);
  print('f32: $f32');
  String b64 = BASE64.encode(f32.buffer.asUint8List());
  print('b64: $b64');
  Uint8List out = BASE64.decode(b64);
  Float32List result = out.buffer.asFloat32List();
  print('result: $result');

}
