// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/ascii.dart';
import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/string/parse_error.dart';
import 'package:dictionary/src/string/parse_issues.dart';

import 'time.dart';

// TODO: remove logging before version 0.9.0
final Logger _log =
    new Logger('date_time/utils_old.dart', watermark: Severity.debug1);

//TODO: redo doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
/// Note: All error checking is don in checkArgs
dynamic parseDcmDate(
    String s, int start, int end, int min, int max, bool isValidOnly) {
  int y, m, d;
  if (end == null) end = s.length;
  try {
    checkArgs(s, start, end, min, max);
    int index = start;
    y = parseYear(s, index);
    if ((index += 4) < end) {
      m = parseMonth(s, index);
      if ((index += 2) < end) d = parseDay(y, m, s, index);
    }
    _log.debug('y: $y, m: $m, d: $d');
  } catch (e) {
    _log.debug('Caught: $e');
    return (isValidOnly) ? false : null;
  }
  return (isValidOnly) ? true : epochDay(y, m, d);
}

/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
/// Note: All error checking is don in checkArgs
dynamic getDcmDateIssues(
    String s, int start, int end, int min, int max, ParseIssues issues) {
  int y, m, d;
  if (end == null) end = s.length;
  checkArgs(s, start, end, min, max, issues);
  int index = start;
  parseYear(s, index, issues);
  if ((index += 4) < end) {
    parseMonth(s, index, issues);
    if ((index += 2) < end) parseDay(y, m, s, index, issues);
  }
  _log.debug('y: $y, m: $m, d: $d');
  return issues;
}

// valid lengths: 2 4 6 8-13
dynamic parseDcmTime(
    String s, int start, int end, int min, int max, bool isValidOnly) {
  int h, m = 0, ss = 0, f = 0;
  end = (end == null) ? s.length : end;
  try {
    //Note: max is 13 because padding should have been removed.
    checkArgs(s, start, end, min, max);
    _log.debug1('after checkArgs');
    int index = start;
    h = parseHour(s, index);
    if ((index += 2) < end) {
      m = parseMinute(s, index);
      if ((index += 2) < end) {
        ss = parseSecond(s, index);
        if ((index += 2) < end) {
          f = parseFraction(s, index, end);
        }
      }
    }
    _log.debug1('    h: $h, m: $m, s: $ss, f: $f\n'
        '    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');
  } on ParseError catch (e) {
    _log.debug1('parseDcmTimeString caught:\n $e');
    return (isValidOnly) ? false : null;
  }
  return (isValidOnly)
      ? true
      : Time.toMicroseconds(h, m, ss, f ~/ 1000, f % 1000);
}

// valid lengths: 2 4 6 8-13
dynamic getDcmTimeIssues(
    String s, int start, int end, int min, int max, ParseIssues issues) {
  int h, m = 0, ss = 0, f = 0;
  end = (end == null) ? s.length : end;
  _log.debug('getDcmTimeIssues: $issues');
  //Note: max is 13 because padding should have been removed.
  issues = checkArgs(s, start, end, min, max, issues);
  _log.debug1('after checkArgs');
  int index = start;
  parseHour(s, index, issues);
  if ((index += 2) < end) {
    parseMinute(s, index, issues);
    if ((index += 2) < end) {
      parseSecond(s, index, issues);
      if ((index += 2) < end) {
        parseFraction(s, index, end, issues);
      }
    }
  }
  _log.debug1('    h: $h, m: $m, s: $ss, f: $f\n'
      '    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');

  return issues;
}

/// Parses a base 10 [int] from [offset] to [limit], and returns
/// its corresponding value. If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: Assumes [offset] and [limit] are valid values.
/// Note: all the parsers might throw so callers should use try catch.
/// Returns a valid [year] or [null].  The [year] must be 4 characters.
int parseYear(String s, [int start = 0, ParseIssues issues]) =>
    _checkYear(uintParser(s, start, start + 4, issues), issues);

/// Returns a valid [month] or [null].  The [month] must be 2 characters.
int parseMonth(String s, [int start = 0, ParseIssues issues]) =>
    _checkMonth(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [day] or [null].  The [day] must be 2 characters.
int parseDay(int year, int month, String s, [int start = 0, ParseIssues
issues]) =>
    _checkDay(year, month, uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseHour(String s, [int start = 0, ParseIssues issues]) =>
    checkHour(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseMinute(String s, [int start = 0, ParseIssues issues]) =>
    checkMinute(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseSecond(String s, [int start = 0, ParseIssues issues]) =>
    checkSecond(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseFraction(String s, [int start = 0, int end, ParseIssues issues]) {
  if (end == null) end = s.length;
  _log.debug2('s: ${s.substring(start, end)}, start: $start, end: $end');
  int c = s.codeUnitAt(start);
  _log.debug2('    c: ${s[start]}');
  if (c != kDot) throw new ParseError('Missing decimal point (".")');
  int f = uintParser(s, start + 1, end, issues);
  _log.debug2('    f.uint: $f');
  f = toMicroseconds(f);
  _log.debug2('    f: $f');
  return checkFraction(f, issues);
}

/// Returns a valid Time Zone Offset in Minutes.  The [String] must have the
/// format [-+]hhmm', where 'hh' is a valid hour and 'mm' is a valid Time Zone
/// Offset minutes value.
int parseTimeZone(String s, int start, ParseIssues issues) {
  int sign = 1;
  _log.debug2('s: ${s.substring(start, start + 5)}');
  _log.debug2('    end: $start + 5');
  int c = s.codeUnitAt(start);
  if (c == kMinusSign) {
    sign = -1;
  } else if (c != kPlusSign) {
    throw new ParseError('No Time Zone present at index($start) in "$s"');
  }
  int h = parseHour(s, start + 1, issues);
  _log.debug2('    tz hour: $h');
  int m = parseMinute(s, start + 3, issues);
  _log.debug2('    tz minute: $m');
  return _checkTimeZone(sign, h, m, issues);
}

int toMicroseconds(int f) {
  if (f < 10) return f *= 100000;
  if (f < 100) return f *= 10000;
  if (f < 1000) return f *= 1000;
  if (f < 10000) return f *= 100;
  if (f < 100000) return f *= 10;
  if (f < 1000000) return f;
  throw new ParseError('Fraction too large');
}

// ********* private functions after this line **********

// Note: _checkRange throws so all the other _check* might also throw.
bool _inRange(int v, int min, int max, ParseIssues issues) {
  if (v == null && issues != null) return false;
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (issues == null) throw new ParseError(msg);
    issues += msg;
    return false;
  }
  return true;
}

int _checkRange(int v, int min, int max, ParseIssues issues) =>
    (_inRange(v, min, max, issues)) ? v : null;

bool isValidHour(int h, ParseIssues issues) => _inRange(h, 0, 23, issues);
bool isValidMinute(int m, ParseIssues issues) => _inRange(m, 0, 59, issues);
bool isValidSecond(int s, ParseIssues issues) =>
    _inRange(s, 0, 59, issues); //leap second???
bool isValidFraction(int f, ParseIssues issues) =>
    _inRange(f, 0, 999999, issues);
int tzOffsetMin = -12;
int tzOffsetMax = 14;
bool isValidTZOffsetInMinutes(int tzo, ParseIssues issues) =>
    _inRange(tzo, tzOffsetMin, tzOffsetMax, issues);

int _checkYear(int y, ParseIssues issues) => _checkRange(y, 0, 9999, issues);
int _checkMonth(int m, ParseIssues issues) => _checkRange(m, 1, 12, issues);
int checkHour(int h, ParseIssues issues) => _checkRange(h, 0, 23, issues);
int checkMinute(int mm, ParseIssues issues) => _checkRange(mm, 0, 59, issues);
int checkSecond(int s, ParseIssues issues) => _checkRange(s, 0, 59, issues);
int checkMilliSecond(int s, ParseIssues issues) =>
    _checkRange(s, 0, 999, issues);
int checkMicrosecond(int s, ParseIssues issues) => checkMilliSecond(s, issues);
int checkFraction(int f, ParseIssues issues) =>
    _checkRange(f, 0, 999999, issues);

int _checkDay(int y, int m, int d, ParseIssues issues) {
  const List<int> _daysPerMonth = const <int>[
    0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 //keep
  ];
  //TODO: Test leap year handling
  _log.debug('_checkDay: $y-$m-$d');
  int maxDay = (m != 9) ? _daysPerMonth[m] : (_isLeapYear(y)) ? 29 : 28;
  _log.debug('_checkDay: day: $d');
  return _checkRange(d, 1, maxDay, issues);
}

/// if (year is not divisible by 4) then (it is a common year)
/// else if (year is not divisible by 100) then (it is a leap year)
/// else if (year is not ivisible by 400) then (it is a common year)
/// else (it is a leap year)
///
/// Note: error checking for year value is done by caller.
bool _isLeapYear(int year) => !_isCommonYear(year);

bool _isCommonYear(int year) =>
    (year % 4 != 0) || !(year % 100 == 0) || (year % 400 == 0);

int _checkTimeZone(int sign, int hour, int minute, ParseIssues issues) {
  int h = sign * hour;
  _checkRange(h, -12, 14, issues);
  if (minute % 15 != 0) {
    var msg = 'Invalid Time Zone minute offset($minute)';
    if (issues != null) {
      throw new ParseError(msg);
    } else {
      return null;
    }
  }
  return ((hour * 60) + minute) * sign;
}
