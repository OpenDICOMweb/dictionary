// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

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

  bool isValidLength(String s) => min <= s.length && s.length <= max;

  @override
  bool isValid(String s) => isValidLength(s) && tester(s);

  @override
  String check(String s) => (isValid(s)) ? s : null;

//String issue(String s) => errorMsg(s);

  @override
  dynamic parse(String s) => check(s);

// String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);
}

/// DICOM Strings.
class VRDcmString extends VRString {
  const VRDcmString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => isValidLength(s) && _isDcmString(s);

  String issue(String s) => _dcmErrorMsg(s);

  /// Fix
  /// If too long truncate
  /// if illegal chars replace with ???
  String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);

  //index, code, id, vfLengthSize, maxVFLength, keyword, min, max
  static const VRDcmString kAE =
      const VRDcmString._(1, 0x4541, "AE", 2, kMaxShortVF, "AETitle", 0, 16);
  static const VRDcmString kCS =
      const VRDcmString._(5, 0x5343, "CS", 2, kMaxShortVF, "CodeString", 0, 16);
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
  bool isValid(String s) => isValidLength(s) && _isDcmString(s);

  String issue(String s) => _dcmErrorMsg(s);

  /// Fix
  /// If too long truncate
  /// if illegal chars replace with ???
  String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);

  //index, code, id, vfLengthSize, maxVFLength, keyword, min, max
  static const VRDcmText kLT =
      const VRDcmText._(13, 0x544c, "LT", 2, kMaxShortVF, "LongText", 0, 10240);
  static const VRDcmText kST =
      const VRDcmText._(24, 0x5453, "ST", 2, kMaxShortVF, "ShortText", 0, 1024);
  static const VRDcmText kUT = const VRDcmText._(
      32, 0x5455, "UT", 4, kMaxLongVF, "UnlimitedText", 0, kMaxLongVF);
}

class VRDcmAge extends VRString {
  const VRDcmAge._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => isValidLength(s) && _isDcmAge(s);

  String issue(String s) => _dcmErrorMsg(s);

  /// Fix
  /// if d,w,m,y lowercase make uppercase
  /// Replace with empty field
  String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);

  static const VRDcmAge kAS =
      const VRDcmAge._(2, 0x5341, "AS", 2, kMaxShortVF, "AgeString", 4, 4);
}

class VRDcmDate extends VRString {
  const VRDcmDate._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  @override
  bool isValid(String s) => isValidLength(s) && _isDcmAge(s);

  DateTime parse(String s) => DateTime.parse(s);

//  String issue(String s) => _dcmErrorMsg(s);

  /// Fix
  /// if d,w,m,y lowercase make uppercase
  /// Replace with empty field
//  String fix(String s) => (_fixer != null) ? _fixer(s, min, max) : check(s);

  static const VRDcmDate kDA =
      const VRDcmDate._(6, 0x4144, "DA", 2, kMaxShortVF, "DateString", 8, 8);
}

class VRFloatString extends VRString {
  const VRFloatString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRFloatString kDS = const VRFloatString._(
      7, 0x5344, "DS", 2, kMaxShortVF, "DecimalString", 0, 16);
}

class VRDcmDateTime extends VRString {
  const VRDcmDateTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRDcmDateTime kDT = const VRDcmDateTime._(
      8, 0x5444, "DT", 2, kMaxShortVF, "DateTimeString", 4, 26);
}

class VRIntString extends VRString {
  const VRIntString._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRIntString kIS = const VRIntString._(
      11, 0x5349, "IS", 2, kMaxShortVF, "IntegerString", 0, 12);
}

class VRPersonName extends VRString {
  const VRPersonName._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VR kPN = const VRPersonName._(
      19, 0x4e50, "PN", 2, kMaxShortVF, "PersonName", 0, 5 * 64 * 3);
}

class VRDcmTime extends VRString {
  const VRDcmTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRDcmTime kTM =
      const VRDcmTime._(25, 0x4d54, "TM", 2, kMaxShortVF, "TimeString", 2, 14);
}

class VRUid extends VRString {
  const VRUid._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRUid kUI =
      const VRUid._(27, 0x4955, "UI", 2, kMaxShortVF, "UniqueID", 0, 64);
}

class VRUri extends VRString {
  const VRUri._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int min, int max)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword, min, max);

  static const VRUri kUR =
      const VRUri._(30, 0x5255, "UR", 2, kMaxLongVF, "URI", 0, kMaxLongVF);
}
