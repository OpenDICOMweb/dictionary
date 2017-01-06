// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:math';

import 'package:dictionary/src/common/reader/reader.dart';

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
String dtString(int value, int length) => (value == 0) ? "" : pad(value, length);

/// Returns an [true] if [value] is in the range inclusively.
bool _inRange(int min, int value, int max) => ((min <= value) && (value <= max));

int _checkRange(int min, int v, int max) => _inRange(min, v, max) ? v : null;

int _parseInt(String s) => int.parse(s, onError: (s) => null);

//**** Date Utilities ****

// ** Year **
bool isValidYear(int y, [int start = 0, int end = 2050]) =>
    _inRange(start, y, end);

/// _Deprecated_: Use checkYear instead.
@deprecated
int validateYear(int y) => checkYear(y);

/// Returns the year, if valid; otherwise, [null]
int checkYear(int y) => (isValidYear(y)) ? y : null;

int readYear(String s, [int start = 0]) =>
    checkYear(_parseInt(s.substring(start, start + 4)));

// ** Month **
/// A [List] (starting a 1) of the number of days per month;
///
/// Note: This array doesn't handle non leap years
//Fix: handle leap years
const List<int> kDaysPerMonth = const <int>[0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

int maxMonthDay(int y, int m) {
  int mm = validateMonth(m);
  int ds = kDaysPerMonth[mm];
  return ds;
}

/// Returns [true] if [month] is between 1 and 12 inclusive or [null].
bool isValidMonth(int m) => _inRange(1, m, 12);

/// _Deprecated_: Use checkMonth instead.
@deprecated
int validateMonth(int m) => checkMonth(m);

/// Returns an [int] between 1 and 12, or [null].
int checkMonth(int m) => (isValidMonth(m)) ? m : null;

/// Returns a valid month or [null];
int readMonth(String s, [int start = 0]) =>
    checkMonth(_parseInt(s.substring(start, start + 2)));

// ** Day **
/// Returns [true] if [day] is a valid [day] of [month] and [year]; otherwise, [false].
bool isValidDay(int y, int m, int d) => _inRange(1, d, maxMonthDay(y, m));

/// _Deprecated_: Use checkMonth instead.
@deprecated
int validateDay(int y, int m, int d) => checkDay(y, m, d);

/// Returns an [int] between 1 and 31, or [null].
int checkSimpleDay(int d) => (_inRange(1, d, 31)) ? d : null;

/// Returns an [int] between 1 and 31, or [null].
int checkDay(int y, int m, int d) => (isValidDay(y, m, d)) ? d : null;

/// Returns a valid [day] or [null].
int readDay(int y, int m, String s, [int start = 0]) =>
    checkDay(y, m, _parseInt(s.substring(start, start + 2)));

bool isValidDate(int y, int m, int d) => isValidYear(y) && isValidMonth(m) && isValidDay(y, m, d);

/// _Deprecated_: Use [checkDate] instead;
@deprecated
DateTime validateDate(int y, int m, int d) => checkDate(y, m, d);
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

Date readDate(String s, [int start = 0]) {
  int y = readYear(s, start);
  int m = readMonth(s, start+ 4);
  int d = readDay(y, m, s, start + 6);
  return new Date(y, m, d);
}

bool isValidDateString(String s, [int start = 0]) {
  int y = readYear(s, start);
  int m = readMonth(s, start+ 4);
  int d = (readDay(y, m, s, start + 6));
  return (y != null && m != null && d != null);
}

bool isDash(String s, [int start = 0]) => s[start] == "-";

//**** Time Utilities ****

/// Returns [true] if [hour] is between 0 and 23.
bool isValidHour(int h) => _inRange(0, h, 23);

/// _Deprecated_: Use [checkHour].
int validateHour(int h) => checkHour(h);

/// Returns an [int] between 0 and 23, or [null].
int checkHour(int h) => _checkRange(0, h, 23);

/// Returns a valid [hour] or [null];
int readHour(String s, [int start = 0]) =>
    validateHour(_parseInt(s.substring(start, start + 2)));

/// Returns [true] if [m] is between 0 and 59; otherwise [false].
bool isValidMinute(int m) => _inRange(0, m, 59);

/// _Deprecated_: Use [checkMinute] instead.
@deprecated
int validateMinute(int m) => checkMinute(m);

/// Returns an [int] between 0 and 59; otherwise [null].
int checkMinute(int m) => _checkRange(0, m, 59);

/// Returns a valid [minute] or [null];
int readMinute(String s, [int start = 0]) =>
    validateMinute(_parseInt(s.substring(start, start + 2)));

/// Returns [true] if [second] is between 0 and 60.
///
/// The upper limit is 60 to allows leap seconds but doesn't check correctness.
bool isValidSecond(int s) => _inRange(0, s, 60);

/// _Deprecated_: Use [checkSecond] instead.
@deprecated
int validateSecond(int s) => checkSecond(s);

/// Returns an [int] between 0 and 60 (allowing for leap seconds), or [null].
int checkSecond(int s) => _checkRange(0, s, 60);

/// Returns a valid [second] or [null];
//TODO: Needs year, month, day to handle leap seconds.
int readSecond(String s, [int start = 0]) =>
    validateSecond(_parseInt(s.substring(start, start + 2)));

/// Returns [true] if [fraction] is between 0 and 999999.
bool isValidFraction(int f) => _inRange(0, f, 999999);

/// _Deprecated_: Use [checkFraction] instead.
@deprecated
int validateFraction(int f) => checkFraction(f);

/// Returns an [int] between 0 and 60 (allowing for leap seconds), or [null].
int checkFraction(int f) => _checkRange(0, f, 999999);

const String fractionMark = '.';
final digits = new RegExp('[0-9]');
final tzMarks = new RegExp('[-+Zz]');

//TODO: create unit test/
/// Returns a integer that is 1,000,000 times the fractional value.
int readFraction(String s, [int start = 0]) {
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
  return validateFraction(v);
}

int fractionToMilliseconds(String fraction) => int.parse(fraction.substring(0, 3));

int fractionToMicroseconds(String fraction) => int.parse(fraction.substring(3, 6));

// ** Millisecond **
/// Returns [true] if [millisecond] is between 0 and 999.
bool isValidMillisecond(int ms) => _inRange(0, ms, 999);

/// Returns an [int] between 0 and 999, or [null].
int validateMillisecond(int ms) => (isValidMillisecond(ms)) ? ms : null;

/// Returns a valid [minute] or [null];
int readMillisecond(String s, [int start = 0]) =>
    validateMillisecond(_parseInt(s.substring(start, start + 3)));

// ** Microsecond **
/// Returns [true] if [microsecond] is between 0 and 999.
bool isValidMicrosecond(int us) => isValidMillisecond(us);

/// Returns an [int] between 0 and 999, or [null].
int validateMicrosecond(int us) => validateMillisecond(us);

/// Returns a valid [second] or [null];
int readMicrosecond(String s, [int start = 0]) => readMillisecond(s, start);

/// Returns [true] if all arguments are valid.
bool isValidTime(int h, [int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    isValidHour(h) &&
    isValidMinute(m) &&
    isValidSecond(s) &&
    isValidMillisecond(ms) &&
    isValidMicrosecond(u);

/// Returns a new DateTime if all arguments are valid.
DateTime validateTime(int h, int m, int s, int ms, int us) {
  h = validateHour(h);
  if (h == null) return null;
  m = validateMinute(m);
  if (m == null) return null;
  s = validateSecond(s);
  if (s == null) return null;
  ms = validateMillisecond(ms);
  if (s == null) return null;
  us = validateMicrosecond(us);
  if (s == null) return null;
  return new DateTime(0, 1, 1, h, m, s, ms, us);
}

bool isValidTimeString(String time, [int start = 0, int end]) {
  var sb = new StringReader(time, start, end);
  if (sb.readTime(time, start) == null) return false;
  return true;
}
bool isColon(String s, int start) => s[start] == ":";

//**** Time Zone ****

// ** Sign **
/// Returns [true] if sign is +1 or -1.
bool isValidSign(int sign) => (sign == 1) || (sign == -1);

/// _Deprecated_: Use [checkSign] instead.
int validateSign(int sign) => checkSign(sign);

/// Returns +1 or -1 if [sign] is valid; otherwise [null].
int checkSign(int sign) => (isValidSign(sign)) ? sign : null;

/// Reads a legal Time Zone [sign]
int readTZSign(String s, [int start = 0]) {
  if (!("+-Zz".contains(s[start]))) return null;
  return (s[0] == "-") ? -1 : 1;
}

// ** TZ Hours **
/// The minimum value for [TimeZoneOffset] hours.
const int tzMinHours = -12;

/// The maximum value for [TimeZoneOffset] hours.
const int tzMaxHours = 14;

/// Returns [true] if [h] is a valid Time Zone Offset hour.
bool isValidTZHour(int h) => _inRange(tzMinHours, h, tzMaxHours);

/// Returns the Time Zone Offset hour, if valid; otherwise [null].
int validateTZHour(int h) => isValidTZHour(h) ? h : null;

/// Returns the hours value of the Time Zone Offset, if valid; otherwise [null].
int readTZHour(String s, [int start = 0]) => validateTZHour(readHour(s, start));

// ** TZ Minutes
/// A list containing the valued values for [TimeZoneOffset] minutes.
const List<int> tzMinutes = const [00, 15, 30, 45];

/// Returns [true] if [m] is a valid Time Zone Minute value.
bool isValidTZMinute(int m) => tzMinutes.contains(m);

/// /// Returns a valid Time Zone Minute value or [null]..
int validateTZMinute(int m) => isValidTZMinute(m) ? m : null;

/// Returns a valid Time Zone Minute value or [null].
int readTZMinute(String s, [int start = 0]) =>
    validateTZMinute(readMinute(s.substring(start, start + 2)));

/// Returns the [TimeZone] read from a [String] if valid; otherwise [null].
TimeZone readTimeZone(String tzo, [int start = 0, int inc = 0, int end]) {
  if (tzo.length < start + 5 + inc) return null;
  var sb = new StringReader(tzo, start, end);
  try {
    int sign = sb.readTZSign(tzo, start);
    int hours = sb.readTZHour(tzo, start + 1);
    int minutes = sb.readTZMinute(tzo, start + 3 + inc);
    int offsetInMinutes = (sign * (hours * 60)) + minutes;
    return new TimeZone.fromMinutes(offsetInMinutes);
  } on FormatException catch (e) {
    print('Exception: ${e.message} at ${e.offset}');
    return null;
  }
}

// ** DateTime **
bool isValidDateTime(int y,
                     [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    isValidDate(y, mm, d) && isValidTime(h, m, s, ms, u);

DateTime validateDateTime(int y,
                          [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) {
  assert(isValidDate(y, mm, d));
  assert(isValidTime(h, m, s, ms, u));
  return new DateTime(y, mm, d, h, m, s, ms, u);
}

/// Returns the [TimeZone] read from a [String] if valid; otherwise [null].
bool isValidTimeZoneString(String tzo, [int start = 0, int inc = 0]) {
  if (tzo.length < start + 5 + inc) throw 'Invalid Time Zone String: ${tzo.substring(start)}';
  int sign = readTZSign(tzo, start);
  int hour = readTZHour(tzo, start + 1);
  int minute = readTZMinute(tzo, start + 3 + inc);
  return sign != null && hour != null && minute != null;
}


