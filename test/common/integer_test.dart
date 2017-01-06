// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';


Uint8List createUnalignedInt16List(List<int> vList, int offsetAt) {
  Int16List i32 = (vList is Int16List) ? vList : new Int16List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getInt16(i, Endianness.LITTLE_ENDIAN);
    // print('i0: $i0');
    unalignedUint8.setInt16(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
    // int i1 = unalignedUint8.getInt16(i, Endianness.LITTLE_ENDIAN);
    //  print('i0: $i0 i1: $i0');
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedInt32List(List<int> vList, int offsetAt) {
  Int32List i32 = (vList is Int32List) ? vList : new Int32List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getInt32(i, Endianness.LITTLE_ENDIAN);
    unalignedUint8.setInt32(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedInt64List(List<int> vList, int offsetAt) {
  Int64List i32 = (vList is Int64List) ? vList : new Int64List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getInt64(i, Endianness.LITTLE_ENDIAN);
    unalignedUint8.setInt64(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedUint16List(List<int> vList, int offsetAt) {
  Int16List i32 = (vList is Int16List) ? vList : new Int16List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getInt16(i, Endianness.LITTLE_ENDIAN);
    unalignedUint8.setInt16(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedUint32List(List<int> vList, int offsetAt) {
  Uint32List i32 = (vList is Uint32List) ? vList : new Uint32List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getUint32(i, Endianness.LITTLE_ENDIAN);
    unalignedUint8.setUint32(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
  }
  return unalignedUint8.buffer.asUint8List();
}

Uint8List createUnalignedUint64List(List<int> vList, int offsetAt) {
  Uint64List i32 = (vList is Uint64List) ? vList : new Uint64List.fromList(vList);
  ByteData i32BD = i32.buffer.asByteData();
  ByteData unalignedUint8 = new ByteData(i32.lengthInBytes + offsetAt);

  for (int i = 0; i < i32BD.lengthInBytes; i += 4) {
    int i0 = i32BD.getUint64(i, Endianness.LITTLE_ENDIAN);
    unalignedUint8.setUint64(i + offsetAt, i0, Endianness.LITTLE_ENDIAN);
  }
  return unalignedUint8.buffer.asUint8List();
}