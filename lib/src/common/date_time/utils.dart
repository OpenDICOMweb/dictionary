// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';

import 'package:dictionary/src/common/ascii/constants.dart';
import 'package:dictionary/src/common/buffer/byte_buf.dart';

import 'date.dart';
import 'time.dart';

// DICOM DateTime 422222.6+22
//                422222.6-22
//                422222.6
//                422222.
//                422222
//                42222
//                4222
//                422
//                42
//                4
// Inet DateTime 4-2-2T2:2:2.6+2:2
// Inet DateTime 4-2-2T2:2:2.6Z

/// Functions for converting [DateTime]s to DICOM Format.
/// See [DICOM PS3.5](http://dicom.nema.org/medical/dicom/current/output/html/part05.html).

/// Returns a [String] of [length] containing the [value] left padded with "0".
String pad(int value, int length) => value.toString().padLeft(length, "0");

// Private helper functions
//String dtString(int value, int length) => (value == 0) ? "" : pad(value, length);

/// Returns an [true] if [value] is in the range inclusively.
bool _inRange(int min, int value, int max) => ((min <= value) && (value <= max));

int _checkRange(int min, int v, int max) => _inRange(v, min, max) ? v : null;

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

int parseUint(String s, [int offset = 0, int min = 0, int max]) {
  if (s == null || s == "") return null;
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) return null;
  return _parseUint(s, offset, limit);
}

/// Parses a base 10 [int] from [offset] to [limit], and returns its corresponding value.
/// If an error is encountered returns [null].
int _parseUint(String s, int offset, int limit) {
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

/// Parses a sign code unit (+, -) and returns +1 or -1.
/// If the next code unit is a digit then return 1, but does not
/// advance the [_rIndex].
int _parseSign(String s, int offset) {
  int c = s.codeUnitAt(offset);
  if (c == kMinusSign) return -1;
  if (c == kPlusSign) return 1;
  return null;
}

//int _parseInt(String s, [int offset]) =>
//    int.parse((offset == 0) ? s : s.substring(offset), onError: (s) => null);

int parseInt(String s, [int offset = 0, int min = 0, int max]) {
  if (s == null || s == "") return null;
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) return null;
  int sign = _parseSign(s, offset);
  if (sign != null) {
    offset++;
  } else {
    sign = 1;
  }
  int n = _parseUint(s, offset, limit);
  return sign * n;
}


bool _parseChar(String s, int char, int offset) => s.codeUnitAt(offset) == char;

//**** Date Utilities ****

// ** Year **

int minYear = 0;
int maxYear = 2050;

bool yearInRange(int y, int min, int max) => _inRange(y, min, max);

bool isYear(int y) => yearInRange(y, minYear, maxYear);

/// Returns the year, if valid; otherwise, [null]
int checkYear(int y) => (yearInRange(y, minYear, maxYear)) ? y : null;

int parseYear(String s, [int start = 0]) =>
    checkYear(_parseInt(s.substring(start, start + 4)));

String yearHasError(String s, [int start = 0, end]) {
  var v = _parseInt(s, start);
}

// ** Month **
/// A [List] (starting a 1) of the number of days per month;
///
/// Note: This array doesn't handle non leap years
//Fix: handle leap years
const List<int> kDaysPerMonth = const <int>[0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

int maxMonthDay(int y, int m) {
  int mm = checkMonth(m);
  int ds = kDaysPerMonth[mm];
  return ds;
}

/// Returns [true] if [month] is between 1 and 12 inclusive or [null].
bool isMonth(int m) => _inRange(m, 1, 12);

/// Returns an [int] between 1 and 12, or [null].
int checkMonth(int m) => (isMonth(m)) ? m : null;

/// Returns a valid month or [null];
int parseMonth(String s, [int start = 0, end = 2]) =>
    checkMonth(_parseUint(s, start, end));

// ** Day **
/// Returns [true] if [day] is a valid [day] of [month] and [year]; otherwise, [false].
bool isDay(int y, int m, int d) => _inRange(d, 1, maxMonthDay(y, m));

/// Returns an [int] between 1 and 31, or [null].
bool isSimpleDay(int d) => (_inRange(d, d, 31));

/// Returns an [int] between 1 and 31, or [null].
int checkDay(int y, int m, int d) => (isDay(y, m, d)) ? d : null;

/// Returns an [int] between 1 and 31, or [null].
int checkSimpleDay(int d) => (isSimpleDay(d)) ? d : null;

/// Returns a valid [day] or [null].
int parseDay(int y, int m, String s, [int start = 0]) =>
    checkDay(y, m, _parseUint(s, start, start + 2));

bool isDate(int y, int m, int d) => isYear(y) && isMonth(m) && isDay(y, m, d);

// ** Date **
DateTime checkDate(int y, int m, int d) {
  y = checkYear(y);
  if (y == null) return null;
  m = checkMonth(m);
  if (m == null) return null;
  d = checkDay(y, m, d);
  if (d == null) return null;
  return new DateTime(y, m, d);
}

Date parseDicomDate(String s, [int start = 0, isInternet = true]) {
  int index = start;
  int y = parseYear(s, start);
  int m = parseMonth(s, start+ 4);
  int d = parseDay(y, m, s, start + 6);
  return new Date(y, m, d);
}

Date parseInternetDate(String s, [int start = 0, isInternet = true]) {
  int y = parseYear(s, start);
  if (isInternet) _parseChar(s, kDash, start + 3);
  int m = parseMonth(s, start+ 5);
  if (isInternet) _parseChar(s, kDash, start + 6);
  int d = parseDay(y, m, s, start + 8);
  return new Date(y, m, d);
}

bool checkDateString(String s, [int start = 0]) {
  int y = parseYear(s, start);
  int m = parseMonth(s, start+ 4);
  int d = (parseDay(y, m, s, start + 6));
  return (y != null && m != null && d != null);
}

//**** Time Utilities ****

/// Returns [true] if [hour] is between 0 and 23.
bool isHour(int h) => _inRange(h, 0, 23);

/// Returns an [int] between 0 and 23, or [null].
int checkHour(int h) => _checkRange(0, h, 23);

/// Returns a valid [hour] or [null];
int parseHour(String s, [int start = 0]) => checkHour(_parseUint(s, start, start + 2));

/// Returns [true] if [m] is between 0 and 59; otherwise [false].
bool isMinute(int m) => _inRange(m, 0, 59);

/// Returns an [int] between 0 and 59; otherwise [null].
int checkMinute(int m) => _checkRange(0, m, 59);

/// Returns a valid [minute] or [null];
int parseMinute(String s, [int start = 0]) => checkMinute(_parseUint(s, start, start + 2));

/// Returns [true] if [second] is between 0 and 60.
///
/// The upper limit is 60 to allows leap seconds but doesn't check correctness.
bool isSecond(int s) => _inRange(s, 0, 60);

/// Returns an [int] between 0 and 60 (allowing for leap seconds), or [null].
int checkSecond(int s) => _checkRange(0, s, 60);

/// Returns a valid [second] or [null];
//TODO: Needs year, month, day to handle leap seconds.
int parseSecond(String s, [int start = 0]) => checkSecond(_parseUint(s, start, start + 2)));

/// Returns [true] if [fraction] is between 0 and 999999.
bool isFraction(int f) => _inRange(f, 0, 999999);

/// Returns an [int] between 0 and 60 (allowing for leap seconds), or [null].
int checkFraction(int f) => _checkRange(0, f, 999999);

const int fractionMark = kDot;
String tzMarks = "-+Zz";

bool isTXMark(int c) => c == kPlusSign || c == kMinusSign || c == kZ || c == kz;

//TODO: create unit test/
/// Returns a integer that is 1,000,000 times the fractional value.
int parseFraction(String s, [int start = 0]) {
  if (s[start] != fractionMark) return 0;
  start++;
  int end = s.indexOf(tzMarks);
  //log.debug('end: $end');
  end = (end == -1) ? end = s.length : end;
  // There is a fractionMark but no following digits
  if (end == start) return 0;
  // Fraction too long
  // log.debug('end: $end');
  if ((end - start) > 6) return null;
  s = s.substring(start, end);
  // log.debug('index of last digit: $end');
  int v = _parseInt(s);
  // log.debug('v: $v. s.length: ${s.length}');
  if (s.length < 6) v = v * pow(10, 6 - s.length);
  return checkFraction(v);
}

int fractionToMilliseconds(String fraction) => int.parse(fraction.substring(0, 3));

int fractionToMicroseconds(String fraction) => int.parse(fraction.substring(3, 6));

// ** Millisecond **
/// Returns [true] if [millisecond] is between 0 and 999.
bool millisecondInRange(int ms) => _inRange(ms, 0, 999);

/// _Deprecated_: Used [checkMillisecond] instead.
@deprecated
int validateMillisecond(int ms) => (millisecondInRange(ms)) ? ms : null;

/// Returns an [int] between 0 and 999, or [null].
int checkMillisecond(int ms) => (millisecondInRange(ms)) ? ms : null;

/// Returns a valid [minute] or [null];
int parseMillisecond(String s, [int start = 0]) =>
    checkMillisecond(_parseUint(s, start, start + 3)));

// ** Microsecond **
/// Returns [true] if [microsecond] is between 0 and 999.
bool checkMicrosecond(int us) => millisecondInRange(us);

/// Returns an [int] between 0 and 999, or [null].
int validateMicrosecond(int us) => checkMillisecond(us);

/// Returns a valid [second] or [null];
int parseMicrosecond(String s, [int start = 0]) => parseMillisecond(s, start);

/// Returns [true] if all arguments are valid.
bool checkTime(int h, [int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    checkHour(h) &&
    checkMinute(m) &&
    secondInRange(s) &&
    millisecondInRange(ms) &&
    checkMicrosecond(u);

/// Returns a new DateTime if all arguments are valid.
DateTime validateTime(int h, int m, int s, int ms, int us) {
  h = validateHour(h);
  if (h == null) return null;
  m = checkMinute(m);
  if (m == null) return null;
  s = checkSecond(s);
  if (s == null) return null;
  ms = checkMillisecond(ms);
  if (s == null) return null;
  us = validateMicrosecond(us);
  if (s == null) return null;
  return new DateTime(0, 1, 1, h, m, s, ms, us);
}

bool checkTimeString(String time, [int start = 0, int end]) {
  var sb = new StringReader(time, start, end);
  if (sb.time == null) return false;
  return true;
}
bool isColon(String s, int start) => s[start] == ":";

//**** Time Zone ****

// ** Sign **
/// Returns [true] if sign is +1 or -1.
bool checkSign(int sign) => (sign == 1) || (sign == -1);

/// _Deprecated_: Use [checkSign] instead.
int validateSign(int sign) => checkSign(sign);

/// Returns +1 or -1 if [sign] is valid; otherwise [null].
int checkSign(int sign) => (checkSign(sign)) ? sign : null;

/// parses a legal Time Zone [sign]
int parseTZSign(String s, [int start = 0]) {
  if (!("+-Zz".contains(s[start]))) return null;
  return (s[0] == "-") ? -1 : 1;
}

// ** TZ Hours **
/// The minimum value for [TimeZoneOffset] hours.
const int tzMinHours = -12;

/// The maximum value for [TimeZoneOffset] hours.
const int tzMaxHours = 14;

/// Returns [true] if [h] is a valid Time Zone Offset hour.
bool checkTZHour(int h) => _inRange(tzMinHours, h, tzMaxHours);

/// Returns the Time Zone Offset hour, if valid; otherwise [null].
int validateTZHour(int h) => checkTZHour(h) ? h : null;

/// Returns the hours value of the Time Zone Offset, if valid; otherwise [null].
int parseTZHour(String s, [int start = 0]) => validateTZHour(parseHour(s, start));

// ** TZ Minutes
/// A list containing the valued values for [TimeZoneOffset] minutes.
const List<int> tzMinutes = const [00, 15, 30, 45];

/// Returns [true] if [m] is a valid Time Zone Minute value.
bool checkTZMinute(int m) => tzMinutes.contains(m);

/// /// Returns a valid Time Zone Minute value or [null]..
int validateTZMinute(int m) => checkTZMinute(m) ? m : null;

/// Returns a valid Time Zone Minute value or [null].
int parseTZMinute(String s, [int start = 0]) =>
    validateTZMinute(parseMinute(s.substring(start, start + 2)));

/// Returns the [TimeZone] parse from a [String] if valid; otherwise [null].
TimeZone parseTimeZone(String tzo, [int start = 0, int inc = 0, int end]) {
  if (tzo.length < start + 5 + inc) return null;
  var sb = new StringReader(tzo, start, end);
  try {
    int sign = sb.tzSign;
    int hours = sb.tzHour;
    int minutes = sb.tzMinute;
    int offsetInMinutes = (sign * (hours * 60)) + minutes;
    return new TimeZone.fromMinutes(offsetInMinutes);
  } on FormatException catch (e) {
    print('Exception: ${e.message} at ${e.offset}');
    return null;
  }
}

// ** DateTime **
bool checkDateTime(int y,
                     [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    checkDate(y, mm, d) && checkTime(h, m, s, ms, u);

DateTime validateDateTime(int y,
                          [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) {
  assert(checkDate(y, mm, d));
  assert(checkTime(h, m, s, ms, u));
  return new DateTime(y, mm, d, h, m, s, ms, u);
}

/// Returns the [TimeZone] parse from a [String] if valid; otherwise [null].
bool checkTimeZoneString(String tzo, [int start = 0, int inc = 0]) {
  if (tzo.length < start + 5 + inc) throw 'Invalid Time Zone String: ${tzo.substring(start)}';
  int sign = parseTZSign(tzo, start);
  int hour = parseTZHour(tzo, start + 1);
  int minute = parseTZMinute(tzo, start + 3 + inc);
  return sign != null && hour != null && minute != null;
}


