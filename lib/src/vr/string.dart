// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

typedef bool _StringTest<String>(String value, int min, int max);
typedef String _StringErrorMsg<String>(String value, int min, int max);
typedef E _Parser<E>(String s, int min, int max);
typedef E _Fixer<E>(String s, int min, int max);

/// DICOM Strings with short (16-bit) Value Field Lengths.
class VRShortString extends VR<String> {
  @override
  final int _maxVF = kMaxShortVF;
  @override
  final int min;
  @override
  final int max;
  final _StringTest _isValid;
  final _StringErrorMsg _getError;
  final _Parser _parser;
  final _Fixer _fixer;

  /// Create an integer VR.
  const VRShortString._(int index, int code, String id, String desc, this.min, this.max,
      this._isValid, this._getError,
      [this._parser, this._fixer])
      : super._(index, code, id, desc);

  bool isValidLength(String s) => _isValidLength(s.length, min, max);

  bool isValidValue(String s) => _isValid(s, min, max);

  String check(String s) => (_isValid(s, min, max)) ? s : null;

  String getValueIssue(String s) => _getError(s, min, max);

  E parse<E>(String s) => (_parser != null) ? _parser(s, min, max) : check(s);

  // String.dicom (without backslash)
  static const VR kAE = const VRShortString._(
      17, 0x4145, "AE", "AE Title", 1, 16, _isDcmString, _dcmStringError);
  static const VR kCS = const VRShortString._(
      18, 0x4353, "CS", "Code String", 1, 16, _isDcmString, _dcmStringError,
      _checkDcmString, _csFixer);
  static const VR kLO = const VRShortString._(
      19, 0x4c4f, "LO", "Long String", 1, 64, _isDcmString, _dcmStringError);
  static const VR kPN = const VRShortString._(
      28, 0x504e, "PN", "Person Name", 1, 5 * 64 * 3, _isDcmString, _dcmStringError);
  static const VR kSH = const VRShortString._(
      20, 0x5348, "SH", "Short String", 1, 16, _isDcmString, _dcmStringError);

  // String.Text (includes backslash)
  static const VR kST = const VRShortString._(
      22, 0x5354, "ST", "Short Text", 1, 1024, _isDcmText, _dcmTextError);
  static const VR kLT = const VRShortString._(
      23, 0x4c54, "LT", "Long Text", 1, 10240, _isDcmText, _dcmTextError);

  // String.DateTime
  static const VR kDA = const VRShortString._(
      25, 0x4441, "DA", "Date", 8, 8, _isDcmDateString, _dcmDateError, _parseDcmDate);
  static const VR kDT = const VRShortString._(
      26, 0x4454, "DT", "DateTime", 4, 26, _isDcmDateTimeString, _dcmDateTimeError,
      _parseDcmDateTime);
  static const VR kTM = const VRShortString._(
      27, 0x544d, "TM", "Time", 2, 14, _isDcmTimeString, _dcmTimeError, _parseDcmTime);

  static const VR kUI =
      const VRShortString._(29, 0x5549, "UI", "Unique Id", 8, 64, _isUid, _uidError);
  static const VR kAS = const VRShortString._(
      31, 0x4153, "AS", "Age String", 4, 4, _isDcmAge, _dcmAgeError, _dcmAgeParse);

  // String.integer
  static const VR kIS = const VRShortString._(
      15, 0x4953, "IS", "Integer String", 1, 12, _isIntegerString, _integerStringError, _parseIntegerString);

  // String.float
  static const VR kDS = const VRShortString._(
      16, 0x4453, "DS", "Decimal String", 1, 16, _isDecimalString, _decimalStringError, _parseDecimalString);
}

class VRLongString extends VR {
  @override
  final int min = 1;
  @override
  final int max = kMaxLongVF;
  @override
  final int _maxVF = kMaxLongVF;
  final _StringTest _isValid;
  final _StringErrorMsg _getError;
  final _Parser _parser;

  /// Create an integer VR.
  const VRLongString._(
      int index, int code, String id, String desc, this._isValid, this._getError,
      [this._parser])
      : super._(index, code, id, desc);

  bool isValidLength(String s) => min <= s.length && s.length <= max;

  //@override
  bool isValid(String s) => _isValid(s, min, max);

  bool isNotValid(String s) => !isValid(s);

  String getValueIssue(String s) => _getError(s, min, max);

  String check<String>(String s) => (isValidValue(s)) ? s : null;

  E parse<E>(String s) => (_parser != null) ? _parser(s, min, max) : null;

  static const VRLongString kUC = const VRLongString._(
      21, 0x5543, "UC", "Unlimited Characters", _isDcmString, _dcmStringError);

  static const VRLongString kUR =
      const VRLongString._(30, 0x5552, "UR", "URI", _isUri, _uriError);

  static const VRLongString kUT =
      const VRLongString._(24, 0x5554, "UT", "Unlimited Text", _isDcmText, _dcmTextError);
}

