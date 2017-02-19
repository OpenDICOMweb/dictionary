// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

class VRInt extends VR<int> {
  @override
  final int _eSize;
  @override
  final int min;
  @override
  final int max;
  @override
  final int _maxVF;
  @override
  final bool _undefinedOK;

  /// Create an integer VR.
  const VRInt._(
      int index, int code, String id, String desc, this._eSize, this.min, this.max,
      [this._maxVF = kMaxShortVF, this._undefinedOK = false])
      : super._(index, code, id, desc);

  @override
  bool isValidValue(int n) {
    return (min <= n) && (n <= max);
  }

  @override
  String getValueError(int n) => (isNotValidValue(n))
      ? 'Range Error: min($min) <= value($n) <= max($max)'
      : null;

  // Integers (Int first, then Uint)
  //                 index, code, id, desc, _eSize, isValid, getError  _maxVF, _hasUndefined,
  static const VRInt kSS =
      const VRInt._(02, 0x5353, "SS", "Signed Short", 2, Int16.min, Int16.max);
  static const VRInt kSL =
      const VRInt._(03, 0x534c, "SL", "Signed Long", 4, Int32.min, Int32.max);
  static const VRInt kOB = const VRInt._(
      04, 0x4f42, "OB", "Other Bytes", 1, Uint8.min, Uint8.max, kMaxLongVF, true);
  static const VRInt kUN = const VRInt._(
      05, 0x554e, "UN", "Unknown VR", 1, Uint8.min, Uint8.max, kMaxLongVF, true);
  static const VRInt kOW = const VRInt._(
      06, 0x4f57, "OW", "Other Bytes", 2, Uint16.min, Uint16.max, kMaxOW, true);
  static const VRInt kUS =
      const VRInt._(07, 0x5553, "US", "Unsigned Short", 2, Uint16.min, Uint16.max);
  static const VRInt kUL =
      const VRInt._(08, 0x554c, "UL", "Unsigned Long", 4, Uint32.min, Uint32.max);
  static const VRInt kAT =
      const VRInt._(09, 0x4154, "AT", "Attribute Tag", 4, Uint32.min, Uint32.max);
  static const VRInt kOL = const VRInt._(
      10, 0x4f4c, "OL", "Other Long", 4, Uint32.min, Uint32.max, kMaxLongVF);

  @override
  String toString() => 'VRFloat.k$id';
}

/// This class is used by the Tag class.  It is NOT used for parsing, etc.
class VRIntSpecial extends VR {
  @override
  final int _eSize = 0;
  @override
  final int _maxVF = 0;
  @override
  final int min = 0;
  @override
  final int max = 0;

  /// Create an integer VR.
  const VRIntSpecial._(int index, int code, String id, String desc)
      : super._(index, code, id, desc);

  // Special constants only used in Tag class
  static const VRIntSpecial kOBOW = const VRIntSpecial._(34, 0x0001, "OBOW", "OB or OW");
  static const VRIntSpecial kUSSS = const VRIntSpecial._(35, 0x0003, "USSS", "US or SS");
  static const VRIntSpecial kUSSSOW =
      const VRIntSpecial._(36, 0x0003, "USSSOW", "US or SS or OW");
  static const VRIntSpecial kUSOW = const VRIntSpecial._(37, 0x0003, "USOW", "US or OW");
  static const VRIntSpecial kUSOW1 =
      const VRIntSpecial._(38, 0x0003, "USOW1", "US or OW1");

  @override
  String toString() => 'VRFloat.k$id';
}
