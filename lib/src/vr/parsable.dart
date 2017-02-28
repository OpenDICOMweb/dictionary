// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

/// DICOM Date, Time and DateTime [String]s.
/// These all have short (16-bit) Value Field Lengths.
class VRParsable extends VRString {
  @override
  final int _maxVF = kMaxShortVF;

  /// Create a short String VR.
  const VRParsable._(int index, int code, String id, String desc, int min,
      int max, _StringTest isValid, _StringErrorMsg getError,
      [_Parser parser, _Fixer fixer])
      : super._(
            index, code, id, desc, min, max, isValid, getError, parser, fixer);

  @override
  bool get isAscii => true;

  @override
  bool isValidLength(String s) => _isValidLength(s.length, min, max);

  // String.VRParsable
  static const VRParsable kDA = const VRParsable._(25, 0x4441, "DA", "Date", 8,
      8, _isDcmDateString, _dcmDateError, _parseDcmDate);

  static const VRParsable kDT = const VRParsable._(26, 0x4454, "DT", "DateTime",
      4, 26, _isDcmDateTimeString, _dcmDateTimeError, _parseDcmDateTime);

  static const VRParsable kTM = const VRParsable._(27, 0x544d, "TM", "Time", 2,
      14, _isDcmTimeString, _dcmTimeError, _parseDcmTime);

  // String.integer
  static const VR kIS = const VRParsable._(15, 0x4953, "IS", "Integer String",
      1, 12, _isIntegerString, _integerStringError, _parseIntegerString);

  // String.float
  static const VR kDS = const VRParsable._(16, 0x4453, "DS", "Decimal String",
      1, 16, _isDecimalString, _decimalStringError, _parseDecimalString);

  static const VR kUI = const VRParsable._(
      29, 0x5549, "UI", "Unique Id", 8, 64, _isUid, _uidError);
  static const VR kAS = const VRParsable._(31, 0x4153, "AS", "Age String", 4, 4,
      _isDcmAge, _dcmAgeError, _dcmAgeParse);

  static const VRParsable kUR = const VRParsable._(
      30, 0x5552, "UR", "URI", 1, kMaxLongVF, _isUri, _uriError);
}
