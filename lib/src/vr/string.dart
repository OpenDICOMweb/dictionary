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

abstract class VRString extends VR<String> {
  @override
  final int min;
  @override
  final int max;
  final _StringTest _isValid;
  final _StringErrorMsg _getError;
  final _Parser _parser;
  final _Fixer _fixer;

  /// Create an integer VR.
  const VRString._(int index, int code, String id, String desc, this.min,
      this.max, this._isValid, this._getError,
      [this._parser, this._fixer])
      : super._(index, code, id, desc);

  bool get isAscii => true;

  bool isValidLength(String s);

  @override
  bool isValid(String s) => _isValid(s, min, max);

  @override
  String check(String s) => (_isValid(s, min, max)) ? s : null;

  String getIssue(String s) => _getError(s, min, max);

  @override
  String parse(String s) => (_parser != null) ? _parser(s, min, max) : check(s);

  String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);
}

/// DICOM Strings with short (16-bit) Value Field Lengths.
class VRShortString extends VRString {
  @override
  final int _maxVF = kMaxShortVF;

  /// Create a short String VR.
  const VRShortString._(int index, int code, String id, String desc, int min,
      int max, _StringTest isValid, _StringErrorMsg getError,
      [_Parser parser, _Fixer fixer])
      : super._(
            index, code, id, desc, min, max, isValid, getError, parser, fixer);

  @override
  bool get isAscii => false;

  @override
  bool isValidLength(String s) => _isValidLength(s.length, min, max);

  // String.dicom (without backslash)
  static const VR kAE = const VRShortString._(17, 0x4145, "AE", "AE Title", 1,
      16, _isDcmString, _dcmStringError, _checkDcmString);
  static const VR kCS = const VRShortString._(
      18,
      0x4353,
      "CS",
      "Code String",
      1,
      16,
      _isDcmCodeString,
      _dcmCodeStringError,
      _checkDcmCodeString,
      _csFixer);
  static const VR kLO = const VRShortString._(
      19, 0x4c4f, "LO", "Long String", 1, 64, _isDcmString, _dcmStringError);
  static const VR kPN = const VRShortString._(28, 0x504e, "PN", "Person Name",
      1, 5 * 64 * 3, _isDcmString, _dcmStringError);
  static const VR kSH = const VRShortString._(
      20, 0x5348, "SH", "Short String", 1, 16, _isDcmString, _dcmStringError);
  // String.Text (includes backslash)
  static const VR kST = const VRShortString._(
      22, 0x5354, "ST", "Short Text", 1, 1024, _isDcmText, _dcmTextError);
  static const VR kLT = const VRShortString._(
      23, 0x4c54, "LT", "Long Text", 1, 10240, _isDcmText, _dcmTextError);
}

class VRLongString extends VRString {
  @override
  final int _maxVF = kMaxLongVF;

  /// Create an integer VR.
  const VRLongString._(int index, int code, String id, String desc,
      _StringTest isValid, _StringErrorMsg getError,
      [_Parser parser, _Fixer fixer])
      : super._(index, code, id, desc, 1, kMaxLongVF, isValid, getError, parser,
            fixer);

  /// All [VRLongString]s have a default character set of UTF-8.
  @override
  bool get isAscii => false;

  @override
  bool isValidLength(String s) => true;

  static const VRLongString kUC = const VRLongString._(
      21, 0x5543, "UC", "Unlimited Characters", _isDcmString, _dcmStringError);

  static const VRLongString kUT = const VRLongString._(
      24, 0x5554, "UT", "Unlimited Text", _isDcmText, _dcmTextError);
}
