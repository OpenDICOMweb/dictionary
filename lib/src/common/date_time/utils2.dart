// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/ascii/constants.dart';

import 'date.dart';
import 'time.dart';
import 'time_zone.dart';

// DICOM DateTime 422222.6+22
//                422222.6-22
//                422222.6
//                422222.
//                422222
//                42222
//                4222D
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

int _checkRange(int min, int v, int max) => _inRange(v, min, max) ? v : null;

String _InvalidCharacterError(String s, int i) =>
    'Invalid Character("${s[i]}") in String: $s';

/// Return the [limit], which is max or end w
int _getLimit(int start, int min, int max, int end) {
  int limit = start + max;
  if (limit > end) {
    if (start + min > end) {
      return null;
    } else {
      return end - start;
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

/// Parses a base 10 [int] from [start] to [limit], and returns its
/// corresponding value. If an error is encountered returns [null].
int _parseUint(String s, int start, int limit) {
  //print('_readUint s: $s');
  int n = 0;
  for (int i = start; i < limit; i++) {
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) return null;
    int v = c - k0;
    n = (n * 10) + v;
  }
  return n;
}

bool isSignMark(int c) => c == kPlusSign || c == kMinusSign;

int checkSignMark(int c) => (isSignMark(c)) ? c : null;

bool isSign(int sign) =>sign == 1 ||sign == -1;

int checkSign(int sign) => (isSign(sign)) ? sign : null;

/// Parses a sign code unit (+, -) and returns +1 or -1.
/// If the next code unit is a digit then return 1, but does not
/// advance the [_rIndex].
int parseSign(String s, int offset) {
  int sign;
  int c = s.codeUnitAt(offset);
  if (c == kMinusSign) sign = -1;
  if (c == kPlusSign) sign = 1;
  return sign;
}

//int _parseInt(String s, [int offset]) =>
//    int.parse((offset == 0) ? s : s.substring(offset), onError: (s) => null);

int parseInt(String s, [int offset = 0, int min = 0, int max]) {
  if (s == null || s == "") return null;
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) return null;
  int sign = parseSign(s, offset);
  if (sign == null) return null;
  int n = _parseUint(s, offset, limit);
  return sign * n;
}

int parseDecimal(String s, [int offset = 0, int min = 0, int max]) {
  //TODO
  return offset;
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

/// Returns a valid month or [null];
int parseYear(String s, [int start = 0]) {
  if (s.length - start < 4) return null;
  int y =_parseUint(s, start, start + 4);
  return checkYear(y);
}

bool isYearString(String s, [int start = 0]) =>
    (parseYear(s, start) == null) ? false : true;

//TODO: implement
List<String> yearHasError(String s, [int start = 0, int length]) {
  List<String> msgs = [];
  if (length != 4 || length != 2) msgs.add("Invalid Year length($length)");
  int limit = _getLimit(start, length, length, s.length);
  for (int i = start; i < length; i++) {
    int c = s.codeUnitAt(i);
    if (c < k0 || k9 < c) msgs.add(_InvalidCharacterError(s, i));
    return msgs;
  }
  int y = parseInt(s.substring(start, limit));
  if (checkYear == null) msgs.add('Invalid year: min($minYear) <= year($y) <= max($maxYear');
  return msgs;
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

bool isValidMonth(String s, [int start = 0]) {
  if (s.length - start < 2) return false;
  int m = _parseUint(s, start, start + 2);
  return isMonth(m);
}
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


Date parseDicomDate(String s, [int start = 0]) {
  int limit = _getLimit(start, 8, 8, s.length);
  if (limit == null) return null;
  int y = parseYear(s, start);
  int m = parseMonth(s, start+ 4);
  int d = parseDay(y, m, s, start + 6);
  return new Date(y, m, d);
}


String dcmDateError(String s, [int start = 0]) {
  if (s.length - start < 8)
    return 'Invalid String($s) length(${s.length - start}';
  int y = parseYear(s, start);
  if (y == null)
    return 'Invalid year(${s.substring(start, start + 4)})';
  int m = parseMonth(s, start+ 4);
  if (m == null)
    return 'Invalid month(${s.substring(start + 4, start + 6)})';
  int d = parseDay(y, m, s, start + 6);
  if (d == null)
    return 'Invalid day(${s.substring(start + 6, start + 8)})';
  return "";
}

Date parseInternetDate(String s, [int start = 0]) {
  int limit = _getLimit(start, 10, 10, s.length);
  if (limit == null) return null;
  int y = parseYear(s, start);
  if (! _parseChar(s, kDash, start + 3)) return null;
  int m = parseMonth(s, start+ 5);
  if (! _parseChar(s, kDash, start + 3)) return null;
  int d = parseDay(y, m, s, start + 8);
  return new Date(y, m, d);
}

Date parseDate(String s, [int start = 0, isInternet = false]) =>
    (isInternet) ? parseInternetDate(s, start) : parseDicomDate(s, start);


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
int parseSecond(String s, [int start = 0]) => checkSecond(_parseUint(s, start, start + 2));

/// Returns [true] if [fraction] is between 0 and 999999.
bool isFraction(int f) => _inRange(f, 0, 999999);

/// Returns an [int] between 0 and 60 (allowing for leap seconds), or [null].
int checkFraction(int f) => _checkRange(0, f, 999999);

const int fractionMark = kDot;

//TODO: create unit test/
/// Returns a integer that is 1,000,000 times the fractional value.
int parseFraction(String s, [int start = 0, int end]) {
  if (s[start] != fractionMark) return null;
  end = (end == null) ? start + 7 : end;
  return parseUint(s, start + 1, end);
}

int fractionToMilliseconds(String fraction) => int.parse(fraction.substring(0, 3));

int fractionToMicroseconds(String fraction) => int.parse(fraction.substring(3, 6));

// ** Millisecond **
/// Returns [true] if [millisecond] is between 0 and 999.
bool isMillisecond(int ms) => _inRange(ms, 0, 999);

/// Returns an [int] between 0 and 999, or [null].
int checkMillisecond(int ms) => (isMillisecond(ms)) ? ms : null;

/// Returns a valid [minute] or [null];
int parseMillisecond(String s, [int start = 0]) =>
    checkMillisecond(_parseUint(s, start, start + 3));

// ** Microsecond **
/// Returns [true] if [microsecond] is between 0 and 999.
bool isMicrosecond(int us) => isMillisecond(us);

/// Returns an [int] between 0 and 999, or [null].
int checkMicrosecond(int us) => checkMillisecond(us);

/// Returns a valid [second] or [null];
int parseMicrosecond(String s, [int start = 0]) => checkMillisecond(parseMillisecond(s, start));

/// Returns [true] if all arguments are valid.
bool isTime(int h, [int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    isHour(h) && isMinute(m) && isSecond(s) && isMillisecond(ms) &&
    isMicrosecond(u);

/// Returns a new DateTime if all arguments are valid.
DateTime checkTime(int h, int m, int s, int ms, int us) {
  h = checkHour(h);
  if (h == null) return null;
  m = checkMinute(m);
  if (m == null) return null;
  s = checkSecond(s);
  if (s == null) return null;
  ms = checkMillisecond(ms);
  if (s == null) return null;
  us = checkMicrosecond(us);
  if (s == null) return null;
  return new DateTime(0, 1, 1, h, m, s, ms, us);
}

Time parseDicomTime(String s, [int start = 0]) {
  int h, m, ss, f;
  int limit = _getLimit(start, 2, 14, s.length);
  int index = start;
  if (limit >= index + 2) {
    h = parseHour(s, index);
    if (h == null) return null;
  } else {
    return null;
  }
  index += 2;
  if (limit >= index + 2) {
    m = parseMinute(s, index);
    if (m == null) return new Time(h, 0, 0);
  }
  index += 2;
  if (limit >= index + 2) {
    ss = parseSecond(s, index);
    if (ss == null) return new Time(h, m, 0);
  }
  index += 2;
  if (limit >= index + 2) {
    int f = parseFraction(s, index);
    if (f == null) return new Time(h, m, ss);
  }
  return new Time(h, m, ss, f);
}

bool isDcmTimeString(String s, int min, int max) {
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
    if (parseFraction(s, index) == null) return false;
  }
  return true;
}



//TODO: parseInternetTime, parseTime

bool isColon(String s, int start) => s[start] == ":";

//**** Time Zone ****

// ** Sign or InternetSign **

/// Returns [true] if sign is +, -, Z, or z.
bool isTZMark(int c) => c == kPlusSign || c == kMinusSign || c == kZ || c == kz;

int checkTZMark(int c) => (isTZMark(c)) ? c : null;

bool isTZSign(int sign) =>-1 <= sign && sign <= 1;

/// Returns [c] if [c] is +, -, Z, or z; otherwise, [null].
int checkTZSign(int sign) => (isTZSign(sign)) ? sign : null;

/// parses a legal Time Zone [sign]
int parseTZSign(String s, [int start = 0]) {
  int c = s.codeUnitAt(start);
  int sign;
  if (c == kMinusSign) sign = -1;
  if (c == kPlusSign) sign = 1;
  if (c == kZ || c == kz) sign = 0;
  return sign;
}

// ** TZ Hours **
/// The minimum value for [TimeZoneOffset] hours.
const int tzMinHours = -12;

/// The maximum value for [TimeZoneOffset] hours.
const int tzMaxHours = 14;

/// Returns [true] if [h] is a valid Time Zone Offset hour.
bool isTZHour(int h) => _inRange(tzMinHours, h, tzMaxHours);

/// Returns the Time Zone Offset hour, if valid; otherwise [null].
int checkTZHour(int h) => isTZHour(h) ? h : null;

/// Returns the hours value of the Time Zone Offset, if valid; otherwise [null].
int parseTZHour(String s, [int start = 0]) => checkHour(parseHour(s, start));

// ** TZ Minutes
/// A list containing the valued values for [TimeZoneOffset] minutes.
const List<int> tzMinutes = const [00, 15, 30, 45];

/// Returns [true] if [m] is a valid Time Zone Minute value.
bool isTZMinute(int m) => tzMinutes.contains(m);

/// /// Returns a valid Time Zone Minute value or [null]..
int checkTZMinute(int m) => isTZMinute(m) ? m : null;

/// Returns a valid Time Zone Minute value or [null].
int parseTZMinute(String s, [int start = 0]) =>
    checkMinute(parseMinute(s.substring(start, start + 2)));

/// Returns the [TimeZone] parse from a [String] if valid; otherwise [null].
TimeZone parseDicomTZ(String s, [int start = 0]) {
  int end = _getLimit(start, 5, 5, s.length);
  if (end == null) return null;
  int sign = parseSign(s, start);
  if (sign == null) return null;
  int h = parseHour(s, start + 1);
  if (h == null) return null;
  int m = checkMinute(parseMinute(s, start + 3));
  if (m == null) return null;
  if ((m % 15) != 0) throw 'Time Zone minutes must be in 15 minute increments';
  return new TimeZone.fromOffset(sign, h, m);
}

//TODO: this only handles full TimeZones (e.g. +05:00 or Z).
//TODO: It doesn't handle short TZs like +5 or+05.
TimeZone parseInternetTZ(String s, [int start = 0]) {
  int end = _getLimit(start, 2, 6, s.length);
  if (end == null) return null;
  int sign = parseTZSign(s, start);
  if (sign == 0) return new TimeZone.fromMinutes(0); // UTC
  if (sign == null) return null;
  int h = parseHour(s, start + 1);
  if (h == null) return null;
  if (! _parseChar(s, kColon, start + 3)) return null;
  int m = parseMinute(s, start + 4);
  if (m == null) return null;
  if ((m % 15) != 0) throw 'Time Zone minutes must be in 15 minute increments';
  return new TimeZone.fromOffset(sign, h, m);
}

TimeZone parseTimeZone(String s, [int start = 0, internet = false]) =>
    (internet) ? parseInternetTZ(s, start) : parseDicomTZ(s, start);
// ** DateTime **
bool isDateTime(int y,
                [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) =>
    isDate(y, mm, d) && isTime(h, m, s, ms, u);

DateTime checkDateTime(int y,
                       [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0]) {
  assert(isDate(y, mm, d));
  assert(isTime(h, m, s, ms, u));
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


