// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.dictionary.vr;


import 'package:dictionary/common.dart';
import 'package:dictionary/src/dicom/constants.dart';

part 'utils.dart';

typedef bool Test<E>(E value);
typedef String ErrorMsg<E>(E value);

// Abbreviation used to shorten constant definitions so they line up.
const int _kMaxLong = kMaxLongLengthInBytes;
List<String> _invalid(dynamic value) => throw "Invalid value checker";

abstract class VRBase<E> {
  final int index;
  final int code;
  final bool isShort;
  final String id;
  final String name;

  const VRBase(this.index, this.code, this.isShort, this.id, this.name);

  int get maxLengthInBytes => (isShort) ? kMaxShortLengthInBytes : kMaxLongLengthInBytes;

  String get typeName => "";

  bool isValid(E value);

  bool isNotValid(E value) => !isValid(value);

  int checkLength(int v, int min, int max) {
    if (v < min || v > max) throw '$typeName RangeError: min($min) <= Value($v) <= max($max)';
    return v;
  }

  bool areValid(List<E> values) {
    for (E v in values) if (isNotValid(v)) return false;
    return true;
  }

  E check(E value) => (isValid(value)) ? value : null;

  List<E> checkList(List<E> values) => (areValid(values)) ? values : null;

  String getError(E value) => (isValid(value)) ? null : 'Invalid Value: $value';
}

// *** String utilities

/// A character predicate that returns [true] if [c] passes the [Filter]; otherwise, false.
typedef bool Filter(int c);
typedef Object Parser(String s);
typedef Object _ParseError(String s);

class VRString extends VRBase<String> {
  final int min;
  final int max;
  final Parser parser;
  final ErrorMsg getErrors;

  const VRString._(int index, int code, bool isShort, String id, String name, this.min, this.max,
      [this.parser = _defaultParser, this.getErrors])
      : super(index, code, isShort, id, name);

  @override
  String get typeName => "String";

  bool isValidLength(String s) => (s == null || s.length < min || s.length > max) ? false : true;

  bool isNotValidLength(String s) => !isValidLength(s);

  //TODO: this does not handle escape sequences
  @override
  bool isValid(String s) {
    if (isNotValidLength(s)) return false;
    return (parser(s) == null) ? false : true;
  }

  String check(String s) => (isValid(s)) ? s : null;

  String _lengthError(int length) => 'Length Error: min(0) <= Value($length) <= max($max)';

  String errorMsg(String s, Test test) {
    if (s == null) return "Invalid Null String";
    if (isNotValidLength(s)) return _lengthError(s.length);
    for (int i = 0; i < max; i++) {
      if (!test(s.codeUnitAt(i))) return _invalidChar(s, i);
    }
    return "";
  }

  Object parse(String s, {Object onError(String s)}) {
    if (isNotValidLength(s)) return _lengthError(s.length);
    return parser(s);
  }

  // Integer & String.integer
  static const VRString kIS =
      const VRString._(15, 0x4953, true, "IS", "Integer String", 0, 12, _parseIS, _getISErrors);

  // Float & String.float
  static const VRString kDS =
      const VRString._(16, 0x4453, true, "DS", "Decimal String", 0, 16, _isDSString, _getDSErrors);

  // String.array

  static const VRString kAE = const VRString._(
      17, 0x4145, true, "AE", "Application Entity Title", 0, 16, _parseDcmString, _getDcmErrors);
  static const VRString kCS = const VRString._(
      18, 0x4353, true, "CS", "Code String", 0, 16, _parseDcmString, _getDcmErrors);
  static const VRString kLO = const VRString._(
      19, 0x4c4f, true, "LO", "Long String", 1, 64, _parseDcmString, _getDcmErrors);
  static const VRString kSH = const VRString._(
      20, 0x5348, true, "SH", "Short String", 1, 16, _parseDcmString, _getDcmErrors);
  static const VRString kUC = const VRString._(21, 0x5543, false, "UC", "Unlimited Characters", 1,
      _kMaxLong, _parseDcmString, _getDcmErrors);

  // String.Text
  static bool _isTextChar(int c) => !(c < kSpace || c == kDelete);

  static const VRString kST = const VRString._(
      22, 0x5354, true, "ST", "Short Text", 1, 1024, _parseTextString, _getTextError);
  static const VRString kLT = const VRString._(
      23, 0x4c54, true, "LT", "Long Text", 1, 10240, _parseTextString, _getTextError);
  static const VRString kUT = const VRString._(
      24, 0x5554, false, "UT", "Unlimited Text", 1, _kMaxLong, _parseTextString, _getTextError);

  // String.DateTime
  static const VRString kDA = const VRString._(25, 0x4441, true, "DA", "Date", 8, 8,
                                                   _parseDate, _getDateError);
  static const VRString kDT = const VRString._(26, 0x4454, true, "DT", "DateTime", 4, 26,
                                                   _parseDateTime, _getDataTimeError);
  static const VRString kTM = const VRString._(27, 0x544d, true, "TM", "Time", 2, 14,
                                                   _parseTime, _getTimeError);

  // String.Other
  static const VRString kPN =
      const VRString._(28, 0x504e, true, "PN", "Person Name", 0, 5 * 64, _isPN);
  static const VRString kUI =
  const VRString._(29, 0x5549, true, "UI", "Unique Id", 8, 64, _parseUI, _getUIError);
  static const VRString kUR =
      const VRString._(30, 0x5552, false, "UR", "URI", 1, _kMaxLong, _parseUR, _getURError);
  static const VRString kAS =
  const VRString._(31, 0x4153, true, "AS", "Age String", 4, 4, _parseAge, _getAgeError);

}

class VRInteger extends VRBase<int> {
  final int sizeInBytes;
  final int min;
  final int max;

  const VRInteger._(int index, int code, bool isShort, String id, String name, Test test,
      this.sizeInBytes, this.min, this.max)
      : super(index, code, isShort, id, name);

  @override
  String get typeName => "Integer";

  @override
  bool isValid(int v) => Int.inRange(v, min, max);

  String errorMsg(int v) => Int.rangeError(v, min, max);

  static const VRInteger kSS = const VRInteger._(02, 0x5353, true, "SS", "Signed Short",
      Int16.inRange, Int16.sizeInBytes, Int16.min, Int16.max);
  static const VRInteger kSL = const VRInteger._(03, 0x534c, true, "SL", "Signed Long",
      Int32.inRange, Int32.sizeInBytes, Int32.min, Int32.max);
  static const VRInteger kOB = const VRInteger._(04, 0x4f42, false, "OB", "Other Bytes",
      Uint8.inRange, Uint8.sizeInBytes, Uint8.min, Uint8.max);
  static const VRInteger kUN = const VRInteger._(05, 0x554e, false, "UN", "Unknown VR",
      Uint8.inRange, Uint8.sizeInBytes, Uint8.min, Uint8.max);
  static const VRInteger kOW = const VRInteger._(06, 0x4f57, false, "OW", "Other Bytes",
      Uint16.inRange, Uint16.sizeInBytes, Uint16.min, Uint16.max);
  static const VRInteger kUS = const VRInteger._(07, 0x5553, true, "US", "Unsigned Short",
      Uint16.inRange, Uint16.sizeInBytes, Uint16.min, Uint16.max);
  static const VRInteger kUL = const VRInteger._(08, 0x554c, true, "UL", "Unsigned Long",
      Uint32.inRange, Uint32.sizeInBytes, Uint32.min, Uint32.max);
  //TODO: this should do a lookup to validate the Public or Private Tag
  static const VRInteger kAT = const VRInteger._(09, 0x4154, true, "AT", "Attribute Tag",
      Uint32.inRange, Uint32.sizeInBytes, Uint32.min, Uint32.max);
  static const VRInteger kOL = const VRInteger._(10, 0x4f4c, false, "OL", "Other Long",
      Uint32.inRange, Uint32.sizeInBytes, Uint32.min, Uint32.max);
}

bool alwaysTrue(dynamic value) => true;

class VRFloat extends VRBase<double> {
  final int sizeInBytes;

  const VRFloat._(int index, int code, bool isShort, String id, String name, this.sizeInBytes)
      : super(index, code, isShort, id, name, alwaysTrue);

  @override
  String get typeName => "Float";

  @override
  bool isValid(double v) => true;

  static const VRFloat kFD =
      const VRFloat._(11, 0x4644, true, "FD", "Float Double", Float64.sizeInBytes);
  static const VRFloat kFL =
      const VRFloat._(12, 0x464c, true, "FL", "Float Single", Float32.sizeInBytes);
  static const VRFloat kOD =
      const VRFloat._(13, 0x4f44, false, "OD", "Other Double", Float64.sizeInBytes);
  static const VRFloat kOF =
      const VRFloat._(14, 0x4f46, false, "OF", "Other Float", Float32.sizeInBytes);
}
