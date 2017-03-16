// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/date_time.dart';

bool isDcmDateString(String s) {
  int start = 0;
  if (s.length != 8) return false;
  int y = parseYear(s, start);
  if (y == null) return false;
  int m = parseMonth(s, start + 4);
  if (m == null) return false;
  int d = parseDay(y, m, s, start + 6);
  return (d == null) ? false : true;
}

/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
String dcmDateError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
  int start = 0;
  int y = parseYear(s, start);
  if (y == null) return 'Invalid year(${s.substring(start, start + 4)})';
  int m = parseMonth(s, start + 4);
  if (m == null) return 'Invalid month(${s.substring(start + 4, start + 6)})';
  int d = parseDay(y, m, s, start + 6);
  if (d == null) return 'Invalid day(${s.substring(start + 6, start + 8)})';
  return "";
}

/// Returns a [String] containing an invalid length error message,
/// or [null] if there are no errors.
String _getLengthError(int length, int min, int max) {
  if (length == null) return 'Invalid length(Null)';
  if (length == 0) return 'Invalid length(0)';
  return (length < min || max < length)
      ? 'Length Error: min($min) <= Value($length) <= max($max)'
      : null;
}

bool _isDcmDateTimeString(String s, int min, int max) {
  if (_isNotValidLength(s.length, 4, 26)) return false;

  int h, m, ss, f;
  int index = 0;
  int limit = s.length;

  if (limit < index + 2) return false;
  h = parseHour(s, index);
  if (h == null) return false;
  index += 2;
  if (limit >= index + 2) {
    m = parseMinute(s, index);
    if (m == null) return false;
  }
  index += 2;
  if (limit >= index + 2) {
    ss = parseSecond(s, index);
    if (ss == null) return false;
  }
  index += 2;
  if (limit >= index + 2) {
    f = parseFraction(s, index);
    if (f == null) return false;
  }
  return true;
}

/// Returns [true] if [min] <= [length] <= [max].
bool _isValidLength(int length, int min, int max) {
  if (length == null || length == 0) return null;
  return (min <= length && length <= max);
}

/// Returns [true] if length is NOT valid.
bool _isNotValidLength(int length, int min, int max) =>
    !_isValidLength(length, min, max);

String _dcmDateTimeError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg != null) return msg;
  //Urgent: this is not specific enough
  return 'Error in DcmDateTime String: $s';
}

DcmDateTime _parseDcmDateTime(String s, int min, int max) =>
    DcmDateTime.dcmParse(s);

// **** Time
