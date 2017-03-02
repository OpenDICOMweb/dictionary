// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/ascii.dart';
import 'package:dictionary/src/person_name.dart';

import 'vr.dart';

typedef bool Tester<String>(String value, int min, int max);
typedef String ErrorMsg<String>(String value, int min, int max);
typedef E Parser<E>(String s, int min, int max);
typedef E Fixer<E>(String s, int min, int max);

abstract class VRString extends VR<String> {
  final int min;
  final int max;
//  final Tester tester;
//  final ErrorMsg errorMsg;
//  final Parser parser;
//  final Fixer fixer;
//  final BytesToValues fromBytes;

  /// Create an integer VR.
  const VRString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, this.min, this.max
//      this.tester, this.errorMsg, this.parser, this.fixer,this.fromBytes
      )
      : super(index, code, id, 1, vfLengthSize, maxVFLength, keyword);

  bool get isAscii => true;

  @override
  bool isValid(String s);

  @override
  String check(String s) => (isValid(s)) ? s : null;

  @override
  String issue(String s);

  /// Default [String] parser.  If the [String] [isValid] just returns it;
  @override
  dynamic parse(String s) => check(s);

  /// Fix
  //TODO: doc
  @override
  String fix(String s);

  /// Returns [true] if [min] <= [length] <= [max].
  bool isValidLength(String s) {
    assert(s != null);
    return _isValidLength(s.length);
  }

  bool _isValidLength(int length) => min <= length && length <= max;

  /// Returns [true] if length is NOT valid.
  bool isNotValidLength(String s) {
    assert(s != null);
    return !_isValidLength(s.length);
  }

  /// Returns [true] if all characters pass the filter.
  bool _filteredTest(String s, bool filter(int c)) {
    if (!_isValidLength(s.length)) return false;
    for (int i = 0; i < s.length; i++) {
      if (!filter(s.codeUnitAt(i))) return false;
    }
    return true;
  }

  /// The filter for DICOM String characters.
  /// Visible ASCII characters, except Backslash.
  bool _isDcmChar(int c) =>
      (c >= kSpace && c < kBackslash || c > kBackslash && c < kDelete);

  //TODO: this currently returns only the first error -
  //      Should it return all errors?
  /// Returns an error [String] if some character in [s] does not pass
  /// the filter; otherwise, returns the empty [String]("").
  String _getFilteredError(String s, bool filter(int c)) {
    String msg = _getLengthError(s.length);
    if (msg == null) return msg;
    for (int i = 0; i < s.length; i++)
      if (filter(s.codeUnitAt(i))) _invalidChar(s, i);
    return "";
  }

  /// Returns a [String] containing an invalid length error message,
  /// or [null] if there are no errors.
  String _getLengthError(int length) {
    if (length == null) return 'Invalid length(Null)';
    if (length == 0) return 'Invalid length(0)';
    return (length < min || max < length)
        ? 'Length Error: min($min) <= Value($length) <= max($max)'
        : null;
  }

  /// Returns a [String] containing an invalid character error message.
  String _invalidChar(String s, int pos) =>
      'Invalid character(${s.codeUnitAt(pos)}) at position($pos) in: $s';
}

/// DICOM DCR Strings -  AE, LO, SH, UC.
class VRDcmString extends VRString {
  const VRDcmString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool get isAscii => (this == kAE) ? true : false;

  @override
  bool isValid(String s) => _filteredTest(s, _isDcmChar);

  @override
  String issue(String s) => _getFilteredError(s, _isDcmChar);

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    /// If too long truncate
    /// if illegal chars replace with '?'
    return s;
  }

  //index, code, id, vfLengthSize, maxVFLength, keyword, min, max
  static const VRDcmString kAE =
      const VRDcmString._(1, 0x4541, "AE", 2, kMaxShortVF, "AETitle", 0, 16);
  static const VRDcmString kLO = const VRDcmString._(
      12, 0x4f4c, "LO", 2, kMaxShortVF, "LongString", 0, 64);
  static const VRDcmString kSH = const VRDcmString._(
      20, 0x4853, "SH", 2, kMaxShortVF, "ShortString", 0, 16);
  static const VRDcmString kUC = const VRDcmString._(
      26, 0x4355, "UC", 4, kMaxLongVF, "UnlimitedCharacters", 0, kMaxLongVF);
}

class VRDcmText extends VRString {
  const VRDcmText._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool get isAscii => false;

  @override
  bool isValid(String s) => _filteredTest(s, _isTextChar);

  @override
  String issue(String s) => _getFilteredError(s, _isTextChar);

  /// Fix
  @override
  String fix(String s) {
    //TODO
    //If too long truncate
    // if illegal chars replace with ???
    return s;
  }

  /// The filter for DICOM Text characters. All visible ASCII characters
  /// are legal including Backslash.  These [VR]s
  /// must have a VM of VM.k1, i.e. only one value.
  bool _isTextChar(int c) => !(c < kSpace || c == kDelete);

  //index, code, id, vfLengthSize, maxVFLength, keyword, min, max
  static const VRDcmText kLT =
      const VRDcmText._(13, 0x544c, "LT", 2, kMaxShortVF, "LongText", 0, 10240);
  static const VRDcmText kST =
      const VRDcmText._(24, 0x5453, "ST", 2, kMaxShortVF, "ShortText", 0, 1024);
  static const VRDcmText kUT = const VRDcmText._(
      32, 0x5455, "UT", 4, kMaxLongVF, "UnlimitedText", 0, kMaxLongVF);
}

/// DICOM DCR Strings -  AE, LO, SH, UC.
class VRCodeString extends VRString {
  const VRCodeString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => _filteredTest(s, _isCodeStringChar);

  @override
  String issue(String s) => _getFilteredError(s, _isCodeStringChar);

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // If too long truncate
    // if illegal chars replace with " "
    // if lowercase convert to with uppercase
    if (!_isValidLength(s.length)) return null;
    return s.toUpperCase();
  }

  /// The filter for DICOM Code String(CS) characters.
  /// Visible ASCII characters, except Backslash.
  bool _isCodeStringChar(int c) =>
      isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore;

  //index, code, id, vfLengthSize, maxVFLength, keyword, min, max
  static const VRCodeString kCS = const VRCodeString._(
      5, 0x5343, "CS", 2, kMaxShortVF, "CodeString", 0, 16);
}

class VRDcmAge extends VRString {
  const VRDcmAge._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override

  /// Returns [true] if [s] is a valid DICOM Age String (AS).
  bool isValid(String s) {
    assert(s != null);
    if (s.length != 4) return false;
    for (int i = 0; i < 3; i++) if (!isDigitChar(s.codeUnitAt(i))) return false;
    return _isAgeMarker(s.codeUnitAt(3)) ? true : false;
  }

  /// Returns an error [String] if [s] is invalid; otherwise, "".
  @override
  String issue(String s) {
    assert(s != null);
    String error = _getLengthError(s.length);
    if (error != null) return error;
    for (int i = 0; i < 3; i++)
      if (!isDigitChar(s.codeUnitAt(i))) _invalidChar(s, i);
    return (!_isAgeMarker(s.codeUnitAt(3))) ? _invalidChar(s, 3) : "";
  }

  @override
  Duration parse(String s) {
    assert(s != null);
    int n = _getCount(s);
    if (n == null) return null;
    int nDays;
    switch (s[4]) {
      case "D":
        nDays = 1;
        break;
      case "W":
        nDays = 7;
        break;
      case "M":
        nDays = 30;
        break;
      case "Y":
        nDays = 365;
        break;
      default:
        return null;
    }
    return new Duration(days: n * nDays);
  }

  int _getCount(String s) => int.parse(s.substring(0, 3), onError: (s) => null);

  /// Fix
  @override
  String fix(String s) {
    if (_isLowercaseAgeMarker(s.codeUnitAt(4))) return s.toUpperCase();
    //TODO
    // If count is not valid replace with ""
    // If marker is lowercase make uppercase

    return s;
  }

  bool _isAgeMarker(int c) =>
      (c == kD || c == kW || c == kM || c == kY) ? true : false;

  bool _isLowercaseAgeMarker(int c) =>
      (c == kd || c == kw || c == km || c == ky) ? true : false;

  static const VRDcmAge kAS =
      const VRDcmAge._(2, 0x5341, "AS", 2, kMaxShortVF, "AgeString", 4, 4);
}

class VRDcmDate extends VRString {
  const VRDcmDate._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => parse(s) != null;

  @override
  String issue(String s) => (isNotValid(s)) ? 'Invalid Date $s' : "";

  @override
  DateTime parse(String s) {
    assert(s != null);
    if (!_isValidLength(s.length)) return null;
    DateTime dt;
    try {
      dt = DateTime.parse(s);
    } on FormatException {
      return null;
    }
    return dt;
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // trucate on error
    // what other fixes?
    return s;
  }

  static const VRDcmDate kDA =
      const VRDcmDate._(6, 0x4144, "DA", 2, kMaxShortVF, "DateString", 8, 8);
}

class VRFloatString extends VRString {
  const VRFloatString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => parse(s) != null;

  @override
  String issue(String s) => (isNotValid(s)) ? 'Invalid Decimal value $s' : "";

  @override
  num parse(String s) {
    assert(s != null);
    if (!_isValidLength(s.length)) return null;
    return num.parse(s, (s) => null);
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // how to fix? replace with no-value;
    return s;
  }

  static const VRFloatString kDS = const VRFloatString._(
      7, 0x5344, "DS", 2, kMaxShortVF, "DecimalString", 0, 16);
}

class VRDcmDateTime extends VRString {
  const VRDcmDateTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String dateTimeString) => parse(dateTimeString) != null;

  @override
  String issue(String dateTimeString) =>
      (isNotValid(dateTimeString)) ? 'Invalid DateTime: $dateTimeString' : "";

  @override
  DateTime parse(String dateTimeString) {
    assert(dateTimeString != null);
    if (!_isValidLength(dateTimeString.length) ||
        !_isValidString(dateTimeString)) return null;
    String s;
    int length = dateTimeString.length;
    if (length.isOdd && length < 6) return null;
    if (length == 4) s = dateTimeString + '0000';
    if (length == 6) s = dateTimeString + '00';
    DateTime dt;
    try {
      dt = DateTime.parse(s);
    } on FormatException {
      return null;
    }
    return dt;
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // truncate on error
    // what other fixes?
    return s;
  }

  bool _isValidString(String s) => _filteredTest(s, _isDcmTimeChar);

  bool _isDcmTimeChar(int c) => isDigitChar(c) || isDotChar(c) || isSignChar(c);

  static const VRDcmDateTime kDT = const VRDcmDateTime._(
      8, 0x5444, "DT", 2, kMaxShortVF, "DateTimeString", 4, 26);
}

class VRIntString extends VRString {
  const VRIntString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => parse(s) != null;

  @override
  String issue(String s) {
    assert(s != null);
    return (isNotValid(s)) ? 'Invalid Integer String (IS) value: $s' : "";
  }

  @override
  int parse(String s) {
    assert(s != null);
    if (!_isValidLength(s.length)) return null;
    return int.parse(s, onError: (s) => null);
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // how to fix? replace with no-value;
    return s;
  }

  static const VRIntString kIS = const VRIntString._(
      11, 0x5349, "IS", 2, kMaxShortVF, "IntegerString", 0, 12);
}

/// Person Name (PN).
/// Note: Does not support
class VRPersonName extends VRString {
  const VRPersonName._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool get isAscii => false;

  @override
  bool isValid(String s) {
    var groups = s.split('=');
    for (String group in groups) {
      if (group.length > 64 || !_filteredTest(s, _isDcmChar)) return false;
    }
    return true;
  }

  @override
  String issue(String s) {
    assert(s != null);
    return (isNotValid(s)) ? 'Invalid Integer String (IS) value: $s' : "";
  }

  @override
  PersonName parse(String s) {
    assert(s != null);
    return PersonName.parse(s);
  }

  /// Fix
  @override
  String fix(String s) {
    assert(s != null);
    //TODO:
    // how to fix? replace with no-value;
    return s;
  }

  static const VR kPN = const VRPersonName._(
      19, 0x4e50, "PN", 2, kMaxShortVF, "PersonName", 0, 64 * 3);
}

class VRDcmTime extends VRString {
  const VRDcmTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String timeString) => parse(timeString) != null;

  @override
  String issue(String timeString) {
    String s = _getFilteredError(timeString, _isDcmTimeChar);
    if (s != "") return s;
    return (isNotValid(timeString)) ? 'Invalid DateTime: $timeString' : "";
  }

  // Parse DICOM Time.
  @override
  DateTime parse(String timeString) {
    assert(timeString != null);
    if (!_isValidLength(timeString.length)) return null;
    String s;
    int length = timeString.length;
    if ((length.isOdd && length < 6) || !_isValidString(timeString))
      return null;
    if (length == 2) s = timeString + '0000';
    if (length == 4) s = timeString + '00';
    DateTime dt;
    try {
      dt = DateTime.parse(s);
    } on FormatException {
      return null;
    }
    return dt;
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // trucate on error
    // what other fixes?
    // if separator (:) present - remove.
    // if time zone marker present??
    return s;
  }

  bool _isValidString(String s) => _filteredTest(s, _isDcmTimeChar);

  bool _isDcmTimeChar(int c) => isDigitChar(c) || isDotChar(c);

  static const VRDcmTime kTM =
      const VRDcmTime._(25, 0x4d54, "TM", 2, kMaxShortVF, "TimeString", 2, 14);
}

/// _UI_: A DICOM UID (aka OSI OID).
class VRUid extends VRString {
  const VRUid._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  //Urgent: This is not doing complete validation, e.g. it doesn't test
  //        for segments that begin with zero, but have more than 1 character.
  //        There are probably other errors to check.
  @override
  bool isValid(String uidString) => (uidString == null ||
          !isValidLength(uidString) ||
          !hasValidRoot(uidString) ||
          !_filteredTest(uidString, _isUidChar))
      ? false
      : true;

  static const List<int> uidRoots = const [k1, k2, k3];
  //TODO: should be able to check 2nd component
  bool hasValidRoot(String uidString) =>
      (uidRoots.contains(uidString.codeUnitAt(0)) &&
              uidString.codeUnitAt(1) == kDot)
          ? true
          : false;

  static const String dicomRoot = '1.2.840.10008';
  bool hasDicomRoot(String uidString) => uidString.startsWith(dicomRoot);

  //TODO: this need to return beter messages
  @override
  String issue(String uidString) {
    String s = _getFilteredError(uidString, _isUidChar);
    if (s != "") return s;
    return (isNotValid(uidString)) ? 'Invalid DateTime: $uidString' : "";
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // truncate on error
    // what other fixes?
    // if separator (:) present - remove.
    // if time zone marker present??
    return s;
  }

  bool _isUidChar(int c) => !(isHexChar(c) || c == kDot);

  //TODO: what should the minimum length be?
  static const VRUid kUI =
      const VRUid._(27, 0x4955, "UI", 2, kMaxShortVF, "UniqueID", 6, 64);
}

class VRUri extends VRString {
  const VRUri._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String uriString) => parse(uriString) != null;

  @override
  String issue(String uriString) {
    assert(uriString != null);
    var err = _getLengthError(uriString.length);
    if (err != null) return err;
    try {
      Uri.parse(uriString);
    } on FormatException catch (e) {
      return e.toString();
    }
    return "";
  }

  // Parse DICOM Time.
  @override
  Uri parse(String uriString) {
    assert(uriString != null);
    if (!_isValidLength(uriString.length)) return null;
    Uri uri;
    try {
      uri = Uri.parse(uriString);
    } on FormatException {
      return null;
    }
    return uri;
  }

  /// Fix
  @override
  String fix(String s) {
    //TODO:
    // trucate on error
    // what other fixes?
    // if separator (:) present - remove.
    // if time zone marker present??
    return s;
  }

  static const VRUri kUR =
      const VRUri._(30, 0x5255, "UR", 2, kMaxLongVF, "URI", 0, kMaxLongVF);
}
