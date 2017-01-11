// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';

List<String> invalid(value) => throw "Invalid value checker";

// **** Integer (Int & Uint) Checkers

/// Returns [true] if [v] is between [min] and [max] inclusive.
bool _intInRange(int v, int min, int max) => (min <= v && v <= max);

int _intCheckRange(int v, int min, int max) => (min <= v && v <= max) ? v : null;

String _intRangeError(int v, int min, int max) =>
    (_intInRange(v, min, max)) ? null : 'RangeError: min($min) <= Value($v) <= max($max)';

List<String> _intRangeErrors(int v, int min, int max) {
  String s = _intRangeError(v, min, max);
  return (s == null) ? null : [s];
}

List<String> getErrorsSS(int v) => _intRangeErrors(v, Int16.min, Int16.max);
List<String> getErrorsSL(int v) => _intRangeErrors(v, Int32.min, Int32.max);
List<String> getErrorsOB(int v) => _intRangeErrors(v, Uint8.min, Uint8.max);
List<String> getErrorsUN(int v) => _intRangeErrors(v, Uint8.min, Uint8.max);
List<String> getErrorsOW(int v) => _intRangeErrors(v, Uint16.min, Uint16.max);
List<String> getErrorsUS(int v) => _intRangeErrors(v, Uint16.min, Uint16.max);
List<String> getErrorsUL(int v) => _intRangeErrors(v, Uint32.min, Uint32.max);
List<String> getErrorsAT(int v) => _intRangeErrors(v, Uint32.min, Uint32.max);
List<String> getErrorsOL(int v) => _intRangeErrors(v, Uint32.min, Uint32.max);

// **** Floating Point (Float32 & FLoat54) Checkers

/// Returns [true] if [value] is between [min] and [max] inclusive.
bool _floatInRange(double min, double value, double max) => (min <= value && value <= max);

List<String> _checkFloat(double value, double min, double max) => (_floatInRange(value, min, max))
    ? null
    : ['RangeError: min($min) <= Value($value) <= max($max)'];

List<String> getErrorsFD(double v) => null; // all doubles ok
List<String> getErrorsFL(double v) => _checkFloat(v, Float32.min, Float32.max);
List<String> getErrorsOD(double v) => null; // all doubles ok
List<String> getErrorsOF(double v) => _checkFloat(v, Float32.min, Float32.max);

// **** String Checkers
bool _inRange(int length, int min, int max) => length < min || max < length;

int _checkLength(int length, int min, int max) => _intCheckRange(length, min, max);

String _hasLengthError(int length, int min, int max) => (length < min || max < length)
    ? 'Invalid Length for min($min) <= value(${length}) <= max($max)'
    : "";

String _invalidChar(int c, int pos) => 'Value has invalid character($c) at position($pos)';

//TODO: this does not handle escape sequences
bool _isValidString(String s, int min, int max, bool filter(int c)) {
  if (_inRange(s.length, 0, max)) return false;
  for (int index = 0; index < s.length; index++) if (filter(s.codeUnitAt(index))) return false;
  return true;
}

//TODO: this does not handle escape sequences
String _checkString(String s, int min, int max, bool filter(int c)) {
  if (!_inRange(s.length, 0, max)) return null;
  for (int index = 0; index < s.length; index++) if (filter(s.codeUnitAt(index))) return null;
  return s;
}

List<String> _hasErrors(String s, int max, bool filter(int c)) {
  String msg0 = _hasLengthError(s.length, 0, max);
  for (int index = 0; index < s.length; index++) {
    int c = s.codeUnitAt(index);
    if (filter(c)) return [msg0, _invalidChar(c, index)];
  }
  // Success
  return null;
}

//TODO: this does not handle escape sequences
List<String> _hasError(String s, int max, bool filter(int c)) {
  String msg0 = _intRangeError(s.length, 0, max);
  for (int index = 0; index < s.length; index++) {
    int c = s.codeUnitAt(index);
    if (filter(c)) return [msg0, _invalidChar(c, index)];
  }
  // Success
  return null;
}

//TODO: this does not handle escape sequences
List<String> _stringErrors(String s, int max, bool filter(int c)) {
  String msg0 = _intRangeError(s.length, 0, max);
  for (int index = 0; index < s.length; index++) {
    int c = s.codeUnitAt(index);
    if (filter(c)) return [msg0, _invalidChar(c, index)];
  }
  return null; // Success
}

// DICOM Strings
bool _StringFilter(int c) => (c < kSpace || c == kBackslash || c == kDelete);
List<String> getErrorsAE(String s) => _stringErrors(s, 16, _StringFilter);
List<String> getErrorsCS(String s) => _stringErrors(s, 16, _StringFilter);
List<String> getErrorsPN(String s) => _stringErrors(s, 5 * 64, _StringFilter);
List<String> getErrorsSH(String s) => _stringErrors(s, 16, _StringFilter);
List<String> getErrorsLO(String s) => _stringErrors(s, 64, _StringFilter);
List<String> getErrorsUC(String s) => _stringErrors(s, kMaxLongLengthInBytes, _StringFilter);

// DICOM Texts
bool _textFilter(int c) => (c < kSpace || c == kDelete);
List<String> getErrorsST(String s) => _stringErrors(s, 1024, _textFilter);
List<String> getErrorsLT(String s) => _stringErrors(s, 10240, _textFilter);
List<String> getErrorsUT(String s) => _stringErrors(s, kMaxLongLengthInBytes, _textFilter);

List<String> getErrorsIS(String s) {
  String lengthMsg = _intRangeError(s.length, 0, 12);
  int v = int.parse(s, onError: (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in IS String: "$s"' : "";
  return [lengthMsg + valueMsg];
}

List<String> getErrorsDS(String s) {
  String msg0 = _intRangeError(s.length, 0, 16);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> getErrorsDA(String s) {
  var msg0 = _intRangeError(s.length, 8, 8);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> getErrorsDT(String s) {
  String msg0 = _intRangeError(s.length, 8, 8);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> getErrorsTM(String s) {
  String msg0 = _intRangeError(s.length, 0, 16);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}



List<String> getErrorsUI(String s) {
  String msg0 = _intRangeError(s.length, 8, 64);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

//TODO: do something more efficient
//UR - Universal Resource Identifier (URI)
List<String> getErrorsUR(String s) {
  String msg0 = _intRangeError(s.length, 0, kMaxLongLengthInBytes);
  Uri uri;
  try {
    uri = Uri.parse(s);
  } on FormatException catch (e) {
    return [msg0, 'Invalid URI($uri) - error at offset(${e.offset}'];
  }
  // Success
  return null;
}

List<String> getErrorsAS(String s) {
  String msg0 = _intRangeError(s.length, 4, 4);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

/// Return the [limit], which is max or end w
int _getLimit(int offset, int min, int max, int end) {
  int limit = offset + max;
  if (limit > end) {
    if (offset + min > end) {
      return null;
    } else {
      return end - offset;
    }
  } else {
    return limit;
  }
}

/*
int _getFixedLimit(int offset, int length, int end) {
  int limit = offset + length;
  return (limit > end) ? null : limit;
}


int _readFixedUint(String s, [int offset = 0, int length]) {
  int limit = _getLimit(offset, length, length, s.length);
  print('_readUint: limit($limit), @$offset');
  if (limit == null) return null;
  _readUintInternal(s, offset, length, length)

}
*/

int _uintNull(s, i) => null;
int _uintThrow(s, i) => throw 'Invalid character(${s[i] } at position $i of $s';
String _charError(s, i) => 'Invalid character(${s[i] } at position $i of $s';

int _uintSuccess(int n) => n;
String _uintNullValue(int n) => null;

List<String> uintErrors(String s, int offset, int min, int max) {
  List<String> msgs = <String>[];
  if (s == null || s == "") msgs.add('Bad integer String: "$s"');
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) msgs.add(
      'Invalid Length "$s": min($min) <= length($limit) <= max($max)');

  print('_readUint s: $s');
  int n = 0;
  for (int i = offset; i < limit; i++) {
    //    print('i:$i, ${s[i]}');
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) {
      msgs.add(_charError(s, i));
      break;
    }
    int v = c - k0;
    //    print('v: $v');
    n = (n * 10) + v;
    //    print('N: $n');
  }
  print('n=$n');
  return msgs;
}



int readUint(String s, [int offset = 0, int min = 0, int max]) {
  if (s == null || s == "") return null;
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) return null;
  return _readUint(s, offset, limit);
}

/// Parses a base 10 [int] from [offset] to [limit], and returns its corresponding value.
/// If an error is encountered returns [null].
int _readUint(String s, int offset, int limit) {
  print('_readUint s: $s');
  int n = 0;
  for (int i = offset; i < limit; i++) {
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) return null;
    int v = c - k0;
    n = (n * 10) + v;
  }
  return n;
}

int minYear = 0;
int maxYear = 2050;

bool yearInRange(int year) => _intInRange(year, minYear, maxYear);

int readYear(String s, [int offset = 0, minLength = 4]) {
  int year = readUint(s, offset, minLength, 4);
  if (year != null && _intInRange(year, minYear, maxYear))
    return year;
  return null;
}

List<String> yearHasError(String s, [int offset = 0]) {
  var msgs = <String>[];
  int limit = _getLimit(offset, 4, 4, s.length);
  if (limit == null || limit != 4) msgs.add("Insufficient length(4) for year");
  int y = readUint(s, offset, 4, 4);
  if (y == null) {
    msgs.add(_intRangeError(y, minYear, maxYear));
    return msgs;
  }
  return msgs;
}
