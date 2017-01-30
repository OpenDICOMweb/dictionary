// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';
import 'package:dictionary/tag.dart';

typedef bool _VPredicate(E value);
/// Validating Value Field
///
/// The maximum length of a Value Field is:
///     `vr.max * vm.max`
///
//TODO: decide if this should be extended to Parsers

/// The interface for value validators and checkers.
///
/// The following must be implemented:
///   - isValid
///   - check
///
typedef bool _Predicate(E value);
typedef E _Checker(E value);
typedef String _Errors(E value);
abstract class VRCheckerBase<E> {
  _Predicate valid;
  /// Returns a [List<String>] containing error message.
   _Errors errors;

  E check(E value) => (test(value)) ? value : null;
}

class StringChecker extends VRCheckerBase<String> {
  final _Predicate isValid;
  final _Errors errors;_

  StringChecker(this.isValid, this.check)
}
class ValuesChecker<E> {
  // The value of [vm] should be a constant from vm.dart.
  final VM vm;
  // The value of [vr] should be a constant from vr.dart.
  final VR vr;

  final _VPredicate isValid;

  const ValuesChecker(this.vm, this.vr, this.isValid);

  static const kUnknown = const ValuesChecker(VM.kUnknown, VR.kUnknown, _invalid);
  static const kSQ = const ValuesChecker(VM.k1, VR.kSQ, _invalid);
  static const kSS = const ValuesChecker(VM.k1, VR.kSQ, _invalid);

  EType get type;

  int get elementSize => vr.elementSizeInBytes;

  /// Returns the minimum Value Field length in bytes for the given
  /// [VR] and [VM], if the Value Field contains at least 1 value.
  int get minVFLength => vm.min * vr.min;

  /// Returns the maximum Value Field length in bytes for the given [VR] and [VM].
  int get maxVFLength => (vm.max == -1) ? vr.maxVFLength : vm.max * vr.max;

  //TODO: should be modified when DEType info is available.
  // Returns [true] the [lengthInBytes] is valid for the [VR] & [VR].
  bool isValidVFLength(int lengthInBytes) =>
      minVFLength <= lengthInBytes && lengthInBytes <= maxVFLength;

  /// Returns the required minimum number of values for this [VM].
  int get minValues => vm.min;

  //TODO: is optimization for case where vr.sizeInBytes == 1 worth it?
  /// Returns the maximum number of values allowed in the Value Field
  /// for this [VM] and [VR].
  int get maxValues => (vm.max == -1) ? maxVFLength ~/ vr.elementSize : vm.max;

  /// Returns [true] if [values] satisfies the [vr].
  // bool isValid(E value);

  bool isNotValid(E value) => !isValid(value);

  /// Returns [true] if all [values] are valid for the [vm] and [vr].
  bool areValid(List<E> values) {
    if (isNotValidLength(values.length)) for (E v in values) if (isNotValid(v)) return false;
    return true;
  }

  bool areNotValid(List<E> values) => !areValid(values);

  E check(E value) => (isValid(value)) ? value : null;

  List<E> checkList(List<E> values) => (areValid(values)) ? values : null;
  ///
  /// [min]: The minimum number of values.
  /// [max]: The maximum number of values. If -1 then max length of Value Field; otherwise, must
  ///     be greater than or equal to [min].
  /// [width]: The [width] of the matrix of values. If [width == 0 then singleton;
  ///     otherwise must be greater than 0;

  //TODO: should be modified when DEType info is available.
  /// Returns True if the [length], i.e. the number of values, is valid for this [VM] and [VR].
  ///
  /// Note: A [length] of zero is always valid.
  bool isValidValuesLength(int length) =>
     (length == 0 || (length == 1 && vm.width == 0)) ||
     ((length % vm.width) == 0) && _inVMRange(length);

  /// Internal helper for isValidValuesLength
  bool _inVMRange(int length) => (minValues <= length && length <= maxValues);

  bool isNotValidLength(int length) => !isValidValuesLength(length);


  /// Returns a [List<String>] of Error messages for a single value.
  ///
  /// Each [String] should have the format:
  ///     `'$i: $s`
  /// where [i] is then index of [value] in the values List,
  /// and `s` is a [String] describing the error.
  List<String> valueErrors(int i, E value);

  ///
  List<String> allErrors(List<E> values) {
    List<String> msgs = <String>[];
    for (int i = 0; i < values.length; i++) {
      List<String> list = valueErrors(i, values[i]);
      if (list.length > 0) msgs.addAll(list);
    }
    return msgs;
  }
}

bool _invalid(dynamic value) =>
    throw new ArgumentError('This Checker.isValid should never be called');

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

// **** String Checkers
bool _inRange(int length, int min, int max) => length < min || max < length;

int _checkLength(int length, int min, int max) => _intCheckRange(length, min, max);

String _hasLengthError(int length, int min, int max) => (length < min || max < length)
                                                        ? 'Invalid Length for min($min) <= value($length) <= max($max)'
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
bool _stringFilter(int c) => (c < kSpace || c == kBackslash || c == kDelete);
List<String> checkAE(String s) => _stringErrors(s, 16, _stringFilter);
List<String> checkCS(String s) => _stringErrors(s, 16, _stringFilter);
List<String> checkPN(String s) => _stringErrors(s, 5 * 64, _stringFilter);
List<String> checkSH(String s) => _stringErrors(s, 16, _stringFilter);
List<String> checkLO(String s) => _stringErrors(s, 64, _stringFilter);
List<String> checkUC(String s) => _stringErrors(s, kMaxLongLengthInBytes, _stringFilter);

// DICOM Texts
bool _textFilter(int c) => (c < kSpace || c == kDelete);
List<String> checkST(String s) => _stringErrors(s, 1024, _textFilter);
List<String> checkLT(String s) => _stringErrors(s, 10240, _textFilter);
List<String> checkUT(String s) => _stringErrors(s, kMaxLongLengthInBytes, _textFilter);

List<String> checkIS(String s) {
  String lengthMsg = _intRangeError(s.length, 0, 12);
  int v = int.parse(s, onError: (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in IS String: "$s"' : "";
  return [lengthMsg + valueMsg];
}

List<String> checkDS(String s) {
  String msg0 = _intRangeError(s.length, 0, 16);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> checkDA(String s) {
  var msg0 = _intRangeError(s.length, 8, 8);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> checkDT(String s) {
  String msg0 = _intRangeError(s.length, 8, 8);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

List<String> checkTM(String s) {
  String msg0 = _intRangeError(s.length, 0, 16);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}



List<String> checkUI(String s) {
  String msg0 = _intRangeError(s.length, 8, 64);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

//TODO: do something more efficient
//UR - Universal Resource Identifier (URI)
List<String> checkUR(String s) {
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

List<String> checkAS(String s) {
  String msg0 = _intRangeError(s.length, 4, 4);
  int v = num.parse(s, (s) => null);
  String valueMsg = (v == null) ? 'Invalid Character in DS String: "$s"' : "";
  return [msg0, valueMsg];
}

/// Return the limit, which is [max] or [end].
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

int readYear(String s, [int offset = 0, int minLength = 4]) {
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
