// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/ascii.dart';
import 'package:dictionary/src/person_name.dart';
import 'package:dictionary/src/uid/uid.dart';
import 'package:dictionary/src/uid/uid_utils.dart' as uid;

import 'vr.dart';

typedef bool Tester<String>(String value, int min, int max);
typedef String ErrorMsg<String>(String value, int min, int max);
typedef E Parser<E>(String s, int min, int max);
typedef E Fixer<E>(String s, int min, int max);

abstract class VRString extends VR<String> {
  @override
  final int minValue;
  @override
  final int maxValue;
//  final Tester tester;
//  final ErrorMsg errorMsg;
//  final Parser parser;
//  final Fixer fixer;
//  final BytesToValues fromBytes;

  /// Create an integer VR.
  const VRString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, this.minValue, this.maxValue)
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

  /// Returns [true] if [minValue] <= [length] <= [maxValue].
  @override
  bool isValidLength(String s) {
    assert(s != null);
    return _isValidLength(s.length);
  }

  /// Returns [true] if length is NOT valid.
  bool isNotValidLength(String s) => !isValidLength(s);

  bool _isValidLength(int length) => minValue <= length && length <= maxValue;

  /// Returns [true] if all characters pass the filter.
  bool _filteredTest(String s, bool filter(int c)) {
    if (s == null || !_isValidLength(s.length)) return false;
    for (int i = 0; i < s.length; i++) {
      if (!filter(s.codeUnitAt(i))) return false;
    }
    return true;
  }

  /// The filter for DICOM String characters.
  /// Visible ASCII characters, except Backslash.
  bool _isDcmChar(int c) => c >= kSpace && c < kDelete && c != kBackslash;

  //TODO: this currently returns only the first error -
  //      Should it return all errors?
  /// Returns an error [String] if some character in [s] does not pass
  /// the filter; otherwise, returns the empty [String]("").
  String _getFilteredError(String s, bool filter(int c)) {
    var issues = _getLengthError(s.length);
    for (int i = 0; i < s.length; i++)
      if (!filter(s.codeUnitAt(i))) issues += '${_invalidChar(s, i)}\n';
    return issues;
  }

  /// Returns a [String] containing an invalid length error message,
  /// or [null] if there are no errors.
  String _getLengthError(int length) {
    if (length == null) return 'Invalid length(Null)';
    if (length == 0) return 'Invalid length(0)';
    return (length < minValue || maxValue < length)
        ? 'Length Error: min($minValue) <= value($length) <= max($maxValue)\n'
        : "";
  }

  /// Returns a [String] containing an invalid character error message.
  String _invalidChar(String s, int pos) =>
      'Invalid character(${s.codeUnitAt(pos)}) at position($pos) in: $s';
}

/// DICOM DCR Strings -  AE, LO, SH, UC.
class VRDcmString extends VRString {
  const VRDcmString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      const VRDcmString._(1, 0x4541, "AE", 2, kMaxShortVF, "AETitle", 1, 16);
  static const VRDcmString kLO = const VRDcmString._(
      12, 0x4f4c, "LO", 2, kMaxShortVF, "LongString", 1, 64);
  static const VRDcmString kSH = const VRDcmString._(
      20, 0x4853, "SH", 2, kMaxShortVF, "ShortString", 1, 16);
  static const VRDcmString kUC = const VRDcmString._(
      26, 0x4355, "UC", 4, kMaxLongVF, "UnlimitedCharacters", 1, kMaxLongVF);
}

class VRDcmText extends VRString {
  const VRDcmText._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      const VRDcmText._(13, 0x544c, "LT", 2, kMaxShortVF, "LongText", 1, 10240);
  static const VRDcmText kST =
      const VRDcmText._(24, 0x5453, "ST", 2, kMaxShortVF, "ShortText", 1, 1024);
  static const VRDcmText kUT = const VRDcmText._(
      32, 0x5455, "UT", 4, kMaxLongVF, "UnlimitedText", 1, kMaxLongVF);
}

/// DICOM DCR Strings -  AE, LO, SH, UC.
class VRCodeString extends VRString {
  const VRCodeString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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

  //index, code, id, vfLengthSize, maxVFLength, keyword, minValueLength, max
  static const VRCodeString kCS = const VRCodeString._(
      5, 0x5343, "CS", 2, kMaxShortVF, "CodeString", 1, 16);
}

class VRDcmAge extends VRString {
  const VRDcmAge._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
    var issues = _getLengthError(s.length);
    for (int i = 0; i < 3; i++)
      if (!isDigitChar(s.codeUnitAt(i))) issues += '${_invalidChar(s, i)}\n';
    if (!_isAgeMarker(s.codeUnitAt(3))) issues += '${_invalidChar(s, 3)}\n';
    return issues;
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
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      print('dt: $dt');
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
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      7, 0x5344, "DS", 2, kMaxShortVF, "DecimalString", 1, 16);
}

class VRDcmDateTime extends VRString {
  const VRDcmDateTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

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
      11, 0x5349, "IS", 2, kMaxShortVF, "IntegerString", 1, 12);
}

/// Person Name (PN).
/// Note: Does not support
class VRPersonName extends VRString {
  static int maxComponentGroupLength = 64;

  const VRPersonName._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

  @override
  bool get isAscii => false;

  @override
  bool isValid(String s) {
    var groups = s.split('=');
    for (String group in groups)
      if (group.length > 64 || !_filteredTest(group, _isDcmChar)) return false;
    return true;
  }

  @override
  String issue(String s) {
    assert(s != null);
    var issues = '';
    var groups = s.split('=');
    if (groups.length < 1 || groups.length > 3)
      issues += 'Invalid number of ComponentGroups: min(1) '
          '<= value(${groups.length}) <= max(3)\n';
    for (String group in groups) {
      if (group.length > 64)
        issues += 'Invalid Component Group Length: min(1) '
            '<= value(${group.length} <= max(64)\n';
      issues += '{_getFilteredError(s, _isDcmChar)}';
    }
    return issues;
  }

  /// Parses a PN String, but does not change it.
  @override
  List<String> parse(String s) {
    if (s == null || s == "") return null;
    var values = s.split('\\');
    for (String pn in values) {
      var cGroups = splitTrim(pn, '=');
      if (cGroups == null) return null;
      for (String cg in cGroups)
        if (cg.length > 64 || !_filteredTest(cg, _isDcmChar)) return null;
    }
    return values;
  }

  /// Fix
  /// Note: Currently only removed leading and trailing whitespace.
  @override
  String fix(String s) {
    if (s == null || s == "") return null;
    var values = s.split('\\');
    List<String> newPN = [];
    for (String pn in values) {
      var cGroups = splitTrim(pn, '=');
      if (cGroups == null) return null;
      List<String> newCG = [];
      for (String cg in cGroups) {
        if (cg.length > 64 || !_filteredTest(cg, _isDcmChar)) return null;
        newCG.add(splitTrim(cg, '^').join('^'));
      }
      newPN.add(newCG.join('='));
    } //TODO:
    // how to fix? replace with no-value;
    return newPN.join('\\');
  }

  static const VRPersonName kPN = const VRPersonName._(
      19, 0x4e50, "PN", 2, kMaxShortVF, "PersonName", 1, 64 * 3);

  /*Flush if not needed.
  /// The filter for DICOM PersonName characters.  Visible ASCII
  /// characters, except Backslash(\) and Equal Sign(=).
  static bool _isPNComponentGroupChar(int c) =>
      c >= kSpace && c < kDelete && (c != kBackslash && c != kCircumflex);
  */
}

const String baseYear = '19700101';
const String prefix = '19700101T';

class VRDcmTime extends VRString {
  static final DateTime baseDate = new DateTime(1970, 01, 01);

  const VRDcmTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

  @override
  bool isValid(String timeString) => parse(timeString) != null;

  @override
  String issue(String timeString) =>
      (isNotValid(timeString)) ? 'Invalid DateTime: $timeString' : "";

  /// Parse DICOM Time and if valid return a [Duration]; otherwise, [null].
  @override
  Duration parse(String timeString) {
    String t = timeString;
    var length = t.length;
    if (length < 6) {
      if (length == 0 || length.isOdd) return null;
      if (length == 2) t += '0000';
      if (length == 4) t += '00';
    }
    var dts = prefix + t;
    DateTime dt;
    Duration time;
    try {
      dt = DateTime.parse(dts);
    } on FormatException catch (e) {
      print('Format Error($dts): $e');
      return null;
    }
    time = dt.difference(baseDate);
    return time;
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

  bool _isValidString(String s) => _filteredTest(s, _isDcmTimeChar);

  bool _isDcmTimeChar(int c) => isDigitChar(c) || isDotChar(c);

  static const VRDcmTime kTM =
      const VRDcmTime._(25, 0x4d54, "TM", 2, kMaxShortVF, "TimeString", 2, 14);
}

/// _UI_: A DICOM UID (aka OSI OID).
class VRUid extends VRString {
  const VRUid._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

  @override
  bool isValid(String uidString) => uid.isValidUidString(uidString);

  /// Returns [true] if [uidString] starts with the DICOM UID root.
  bool hasDicomRoot(String uidString) => uidString.startsWith(Uid.dicomRoot);

  //TODO: this need to return beter messages
  @override
  String issue(String uidString) =>
      (isValid(uidString)) ? "" : 'Invalid Uid: $uidString';

  /// Fix
  @override
  String fix(String s) {
    //TODO: truncate on error, what other fixes?
    return "";
  }

  //TODO: what should the minimum length be?
  /// Minimum length is based on '1.2.804.xx'.
  static const VRUid kUI =
      const VRUid._(27, 0x4955, "UI", 2, kMaxShortVF, "UniqueID", 10, 64);
}

class VRUri extends VRString {
  const VRUri._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
            minValueLength, maxValueLength);

  @override
  bool isValid(String uriString) => parse(uriString) != null;

  @override
  String issue(String uriString) {
    assert(uriString != null);
    var issues = _getLengthError(uriString.length);
    try {
      Uri.parse(uriString);
    } on FormatException catch (e) {
      issues += e.toString();
    }
    return issues;
  }

  // Parse DICOM Time.
  @override
  Uri parse(String uriString) {
    assert(uriString != null && uriString != "");
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
      const VRUri._(30, 0x5255, "UR", 2, kMaxLongVF, "URI", 1, kMaxLongVF);
}
