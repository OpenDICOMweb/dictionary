// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

// Maximum Value Field length for different Float VRs.
const int kMaxOD = kUint32Max - 8;
const int kMaxOF = kUint32Max - 4;
const int kMaxOL = kUint32Max - 4;
const int kMaxOW = kUint32Max - 2;

//TODO: doc
class VRFloat extends VR<double> {
  @override
  final int _eSize;
  @override
  final int _maxVF;

  /// Create a VR with a Short (16-bit) Value Field length.
  const VRFloat._(int index, int code, String id, String desc, this._eSize, this._maxVF)
      : super._(index, code, id, desc);

  // Floats
  //                                          index, code, id, desc, eSize, maxVFLength,
  static const VRFloat kFD =
      const VRFloat._(11, 0x4644, "FD", "Float Double", 8, kMaxShortVF);
  static const VRFloat kFL =
      const VRFloat._(12, 0x464c, "FL", "Float Single", 4, kMaxShortVF);
  static const VRFloat kOD = const VRFloat._(13, 0x4f44, "OD", "Other Double", 8, kMaxOD);
  static const VRFloat kOF = const VRFloat._(14, 0x4f46, "OF", "Other Float", 4, kMaxOF);

  @override
  String toString() => 'VRFloat.k$id';
}
