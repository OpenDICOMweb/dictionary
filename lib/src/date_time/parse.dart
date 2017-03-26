// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/errors.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/issues/parse_issues.dart';

import 'time.dart';

// TODO: remove logging before version 0.9.0
final Logger _log =
    new Logger('date_time/utils_old.dart', watermark: Severity.debug2);

//TODO: for performance make every function that can be internal
//TODO: redo doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
/// Note: All error checking is don in checkArgs

/*
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
*/
int parseDcmDate(String s, {int start = 0, int end, int min = 0, int max}) {
  int epochDay;
  try {
    epochDay = _parseDcmDate(s, start, end, min, max);
  } on ParseError {
    return null;
  }
  return epochDay;
}

bool isValidDcmDate(String s, {int start = 0, int end, int min = 0, int max}) {
  try {
    int epochDay = _parseDcmDate(s, start, end, min, max);
    if (epochDay == null) return false;
  } on ParseError {
    return false;
  }
  return true;
}

void getDcmDateIssues(String s,
    {int start = 0, int end, int min = 0, int max, ParseIssues issues}) {
  try {
    _parseDcmDate(s, start, end, min, max, issues);
  } on ParseError {
    return;
  }
}

/*
dynamic parseDcmDate_(
    String s, int start, int end, int min, int max, ParseIssues issues) {
  int y, m, d;
  if (end == null) end = s.length;
  checkArgs(s, start, end, min, max);
  int index = start;
  y = parseYear(s, index);
  if ((index += 4) < end) {
    m = parseMonth(s, index);
    if ((index += 2) < end) d = parseDay(y, m, s, index);
  }
  _log.debug('y: $y, m: $m, d: $d');
  return epochDay(y, m, d);
}
*/

// TODO: doc
//TODO: add ability to parse seperator ':'
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
/// Note: All error checking is don in checkArgs
dynamic _parseDcmDate(String s, int start, int end, int min, int max,
    [ParseIssues issues]) {
  int y, m, d;
  if (end == null) end = s.length;
  _log.debug('_parseDcmDate: "$s", $start, $end, $min, $max');
  if (!checkArgs(s, start, end, min, max, issues)) return null;
  int index = start;
  y = parseYear(s, index, issues);
  _log.debug('_parseDcmDate: y: $y');
  if ((index += 4) < end) {
    m = parseMonth(s, index, issues);
    _log.debug('_parseDcmDate: m: $m');
    if ((index += 2) < end) {
      d = parseDay(y, m, s, index, issues);
      _log.debug('_parseDcmDate: d: $d');
    }
  }
  _log.debug('y: $y, m: $m, d: $d');
  if (y == null || m == null || d == null) {
    _log.debug1('    null');
    return null;
  }
  return epochDay(y, m, d);
}

int parseDcmTime(String s, {int start = 0, int end, int min = 0, int max}) {
  int us;
  try {
    us = _parseDcmTime(s, start, end, min, max);
  } on ParseError {
    return null;
  }
  return us;
}

bool isValidDcmTime(String s, {int start = 0, int end, int min = 0, int max}) {
  try {
    int us = _parseDcmTime(s, start, end, min, max);
    _log.debug('isValidDcmTime: us: $us');
    if (us == null) return false;
  } on ParseError {
    return false;
  }
  return true;
}

void getDcmTimeIssues(String s,
    {int start = 0, int end, int min = 0, int max, ParseIssues issues}) {
  try {
    _parseDcmTime(s, start, end, min, max, issues);
  } on ParseError {
    return;
  }
}

// valid lengths: 2 4 6 8-13
//TODO: add ability to parse seperator ':'
dynamic _parseDcmTime(String s, int start, int end, int min, int max,
    [ParseIssues issues]) {
  int h = -1, m = -1, ss = -1, f = -1;
  if (end == null) end = s.length;
  //Note: max is 13 because padding should have been removed.
  _log.debug('_parseDcmTime: "${s.substring(start, end)}", '
      '$start, $end, $min, $max');
  _log.debug('_parseDcmTime: "$s", $start, $end, $min, $max');
  if (!checkArgs(s, start, end, min, max, issues)) return null;
  int index = start;
  h = parseHour(s, index, issues);
  _log.debug('_parseDcmTime: h: $h');
  if ((index += 2) < end) {
    m = parseMinute(s, index, issues);
    _log.debug('_parseDcmTime: m: $m');
    if ((index += 2) < end) {
      ss = parseSecond(s, index, issues);
      _log.debug('_parseDcmTime: ss: $ss');
      if ((index += 2) < end) {
        f = parseTimeFraction(s, start: index, end: end, issues: issues);
        _log.debug('_parseDcmTime: f: $f');
      }
    }
  }
  _log.debug2('h: $h, m: $m, ss: $ss, f: $f');
  if (h == null || m == null ||ss == null || f == null) {
    _log.debug1('    null');
    return null;
  } else {
    if (h == -1) h = 0;
    if (m == -1) m = 0;
    if (ss == -1) ss = 0;
    if (f == -1) f = 0;
    _log.debug1('    h: $h, m: $m, ss: $ss, f: $f\n'
        '    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');
    return toMicroseconds(h, m, ss, f ~/ 1000, f % 1000);
  }
}

int parseTimeFraction(String s, {int start = 0, int end, ParseIssues issues}) {
  _log.debug1('  $s: range: $start - $end');
  int f = parseFraction(s,
      start: start, end: end, min: 2, max: 7, issues: issues);
  _log.debug1('  f: $f');
  if (f == null) return null;
  int us = _fractionToUSeconds(f);
  _log.debug1(' us: $us');
  return _checkFraction(us, issues);
}


List<int> parseDcmDateTime(String s, {int start = 0, int end, int min = 0, int
max}) {
  List<int> dt;
  try {
    _log.debug('parseDcmDateTime: "$s", $start, $end, $min, $max');
    dt = _parseDcmDateTime(s, start, end, min, max);
    if (dt == null) return null;
    _log.debug('parseDcmDateTime: $dt');
  } on ParseError {
    return null;
  }
  return dt;
}

bool isValidDcmDateTime(String s, {int start = 0, int end, int min = 0, int
max}) {
  try {
    _log.debug('isValidDcmTime: "$s", $start, $end, $min, $max');
    List<int> dt = _parseDcmDateTime(s, start, end, min, max);
    _log.debug('isValidDcmTime: $dt');
    if (dt == null) return false;
  } on ParseError {
    return false;
  }
  return true;
}

void getDcmDateTimeIssues(
    String s, {int start = 0, int end, int min = 0, int max, ParseIssues
    issues}) {
  try {
    _log.debug('getDcmDateTimeIssues: "$s", $start, $end, $min, $max');
    List<int> dt = _parseDcmDateTime(s, start, end, min, max);
    _log.debug('getDcmDateTimeIssues: $dt');
  } on ParseError {
    return;
  }
}

//TODO: move min, max back to DcmDateTIme?
List<int> _parseDcmDateTime(String s, int start, int end, int min, int max,
    [ParseIssues issues]) {
  int epochDay = -1,
      us = -1,
      tzm = -1,
      index = start;
  if (end == null) end = s.length;
  if (!checkArgs(s, start, end, 4, 26, issues)) return null;
  _log.debug('_parseDcmDateTime: "$s", $start, $end, $min, $max');
  int dateEnd = (end < 8) ? end : 8;
  _log.debug('_parseDcmDateTime: index($index), end($end)');
  epochDay = _parseDcmDate(s, index, dateEnd, 4, 8);
  _log.debug('_parseDcmDateTime: epochDay: $epochDay');
  if ((index += 8) < end) {
    int timeEnd = (end < 21) ? end : 21;
    _log.debug('_parseDcmDateTime: index($index), end($end)');
    us = _parseDcmTime(s, index, timeEnd, 2, 13);
    _log.debug('_parseDcmDateTime: index($index), end($end)');
    index = s.indexOf("+-", index);
    _log.debug('_parseDcmDateTime: index($index), end($end)');
    if ((index += 6) < end) {
      _log.debug('_parseDcmDateTime: index($index), end($end)');
      tzm = parseTimeZone(s, index);
    }
  }
  _log.debug2('eDay: $epochDay, us: $us, tzm: $tzm');
  if (epochDay == null || us == null || tzm == null) {
    _log.debug1('    null');
    return null;
  } else {
    if (epochDay == -1) throw new ParseError('epochDay == 0');
    if (us == -1) us = 0;
    if (tzm == -1) tzm = 0;
    _log.debug1('    epochDay: $epochDay, us: $us, tzm: $tzm');
    return <int>[epochDay, us, tzm];
  }
}

int parseTimeZone(String s, [int start = 0]) {
  int tzm;
  try {
    _log.debug('_parseTimeZone: "$s", $start');
    tzm = _parseTimeZone(s, start: start);
    _log.debug('_parseTimeZone: $tzm');
    if (tzm == null) return null;
  } on ParseError {
    return null;
  }
  return tzm;
}

bool isValidTimeZone(String s, [int start = 0]) {
  try {
    _log.debug('_parseTimeZone: "$s", $start');
    int tzm = _parseTimeZone(s, start: start);
    _log.debug('_parseTimeZone: $tzm');
    if (tzm == null) return false;
  } on ParseError {
    return false;
  }
  return true;
}

void getTimeZoneIssues(String s, int start, ParseIssues issues) {
  try {
    issues = (issues == null) ? new ParseIssues('Time Zone Issues', s) : issues;
    _log.debug('_parseTimeZone: "$s", $start, $issues');
    int tzm = _parseTimeZone(s, start: start, issues: issues);
    _log.debug('_parseTimeZone: $tzm');
  } on ParseError {
    return;
  }
}

/// Returns a valid Time Zone Offset in Minutes.  The [String] must have the
/// format [-+]hhmm', where 'hh' is a valid hour and 'mm' is a valid Time Zone
/// Offset minute value, i.e. 0, 30, or 45.
int _parseTimeZone(String s, {start = 0, ParseIssues issues}) {
  int sign = 1, h = 0, m = 0, tzm;
  _log.debug('_parseDcmDate: "$s", $start, $issues');
  if (!checkArgs(s, start, start + 5, 5, 5, issues)) return null;
  sign = parseSign(s, start);
  h = parseTZHour(s, start + 1, sign, issues);
  m = parseMinute(s, start + 3, issues);
  if (sign == null || h == null || m == null) return null;
  tzm = sign * (h * 60 + m);
  return tzm;
}

int _checkFraction(int f, ParseIssues issues) =>
    _checkRange(f, 0, 999999, issues);

int _fractionToUSeconds(int f) {
  if (f < 10) return f *= 100000;
  if (f < 100) return f *= 10000;
  if (f < 1000) return f *= 1000;
  if (f < 10000) return f *= 100;
  if (f < 100000) return f *= 10;
  if (f < 1000000) return f;
  throw new ParseError('Fraction too large');
}

int toMicroseconds(int h, int m, int s, int ms, int us) =>
    kMicrosecondsPerHour * _checkHour(h, null) +
    kMicrosecondsPerMinute * _checkMinute(m, null) +
    kMicrosecondsPerSecond * _checkSecond(s, null) +
    kMicrosecondsPerMillisecond * _checkMilliSecond(ms, null) +
    _checkMicrosecond(us, null);

const int kMicrosecondsPerMillisecond = 1000;
const int kMillisecondsPerSecond = 1000;
const int kSecondsPerMinute = 60;
const int kMinutesPerHour = 60;
const int kHoursPerDay = 24;
const int kMicrosecondsPerSecond =
    kMillisecondsPerSecond * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerMinute =
    kMillisecondsPerMinute * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerHour =
    kMillisecondsPerHour * kMicrosecondsPerMillisecond;
const int kMicrosecondsPerDay =
    kMillisecondsPerDay * kMicrosecondsPerMillisecond;
const int kMillisecondsPerMinute = kSecondsPerMinute * kMillisecondsPerSecond;
const int kMillisecondsPerHour = kSecondsPerHour * kMillisecondsPerSecond;
const int kMillisecondsPerDay = kSecondsPerDay * kMillisecondsPerSecond;
const int kSecondsPerHour = kMinutesPerHour * kSecondsPerMinute;
const int kSecondsPerDay = kMinutesPerDay * kSecondsPerMinute;
const int kMinutesPerDay = kHoursPerDay * kMinutesPerHour;
const Time kMidnight = const Time.fromMicroseconds(0);

const int kUSEastTZO = -5 * kMinutesPerHour;
const int kUSCentralTZO = -6 * kMinutesPerHour;
const int kUSMountainTZO = -7 * kMinutesPerHour;
const int kUSPacificTZO = -8 * kMinutesPerHour;

/*
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
*/

/// Parses a base 10 [int] of the specified size, starting from [start],
/// and returns its corresponding value. If an error is encountered
/// a [ParseError] is thrown.
///
/// Note: all the parsers might throw so callers should use try/catch.

/// Returns a valid year or [null].  The year must be 4 characters.
int parseYear(String s, [int start = 0, ParseIssues issues]) =>
    _checkYear(uintParser(s, start, start + 4, issues), issues);

/// Returns a valid month or [null].  The month must be 2 characters.
int parseMonth(String s, [int start = 0, ParseIssues issues]) =>
    _checkMonth(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid day or [null].  The day must be 2 characters.
int parseDay(int year, int month, String s,
        [int start = 0, ParseIssues issues]) =>
    _checkDay(year, month, uintParser(s, start, start + 2, issues), issues);

/// Returns a valid hour or [null].  The hour must be 2 characters.
int parseHour(String s, [int start = 0, ParseIssues issues]) =>
    _checkHour(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid minute or [null].  The minute must be 2 characters.
int parseMinute(String s, [int start = 0, ParseIssues issues]) =>
    _checkMinute(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid second or [null].  The second must be 2 characters.
int parseSecond(String s, [int start = 0, ParseIssues issues]) =>
    _checkSecond(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid hour or [null].  The hour must be 2 characters.
int parseTZHour(String s, [int start = 0, int sign = 1, ParseIssues issues]) {
  int v = uintParser(s, start, start + 2, issues);
  return (v == null) ? null : checkTZHour(sign * v, issues);
}

/// Returns a valid minute or [null].  The minute must be 2 characters.
int parseTZMinute(String s, [int start = 0, ParseIssues issues]) =>
    checkTZMinute(uintParser(s, start, start + 2, issues), issues);

/*
int parseSign(String s, [int start = 0, ParseIssues issues]) {
  int sign;
  int c = s.codeUnitAt(start);
  if (c == kMinusSign) return -1;
  if (c == kPlusSign) return 1;
  var msg = invalidChar(s, start, "sign");
  if (issues == null) throw new ParseError(msg);
  issues += msg;
  return null;
}
*/

/*
dynamic getTimeZoneIssues(String s, [int start = 0, ParseIssues issues]) {
  int sign, h, m, tzm;
  issues = checkArgs(s, start, start + 5, 5, 5, issues);
  checkArgs(s, start, start + 5, 5, 5, issues);
  parseSign(s, start, issues);
  parseTZHour(s, start + 1, sign, issues);
  parseMinute(s, start + 3, issues);
  tzm = sign * (h * 60 + m);
  sign = 1;
  _log.debug2('  s: ${s.substring(start, start + 5)}\n'
      '    start: $start, end: $start + 5');
  int c = s.codeUnitAt(start);
  if (c == kMinusSign) sign = -1;
  if (c != kPlusSign)
    throw new ParseError('Invalid sign char "${s[start]} at pos($start).');
  h = parseHour(s, start + 1, null);
  _inRange(sign * h, -12, 14, null);
  _log.debug2('    tz hour: $h');
  m = parseMinute(s, start + 3, null);
  if (m != 00 || m != 30 || m != 45)
    throw new ParseError('Invalid Time Zone minutes($m) at pos(${start + 3})');
  _log.debug2('    tz minute: $m');
  tzm = sign * (h * 60 + m);

  return issues;
}
*/

// ********* private functions after this line **********

bool inRange(int v, int min, int max, [ParseIssues issues]) =>
    _inRange(v, min, max, issues);

int checkRange(int v, int min, int max, [ParseIssues issues]) =>
    _checkRange(v, min, max, issues);

// Note: _checkRange throws so all the other _check* might also throw.
bool _inRange(int v, int min, int max, ParseIssues issues) {
  if (v == null && issues != null) return false;
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (issues == null) throw new ParseError(msg);
    issues += msg;
    _log.debug2('_inRange: ${issues.info}');
    return false;
  }
  return true;
}

int _checkRange(int v, int min, int max, ParseIssues issues) =>
    (_inRange(v, min, max, issues)) ? v : null;

//bool _isValidHour(int h, ParseIssues issues) => _inRange(h, 0, 23, issues);
//bool _isValidMinute(int m, ParseIssues issues) => _inRange(m, 0, 59, issues);
//bool _isValidSecond(int s, ParseIssues issues) =>
//    _inRange(s, 0, 59, issues); //leap second???
//bool isValidFraction(int f, ParseIssues issues) =>
//    _inRange(f, 0, 999999, issues);

int tzOffsetMin = -12;
int tzOffsetMax = 14;

/* flush if not needed
bool _isValidTZOffsetInMinutes(int tzo, ParseIssues issues) =>
    _inRange(tzo, tzOffsetMin, tzOffsetMax, issues);
*/

int _checkYear(int y, ParseIssues issues) => _checkRange(y, 0, 9999, issues);
int _checkMonth(int m, ParseIssues issues) => _checkRange(m, 1, 12, issues);
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

int _checkHour(int h, ParseIssues issues) => _checkRange(h, 0, 23, issues);
int _checkMinute(int mm, ParseIssues issues) => _checkRange(mm, 0, 59, issues);
int _checkSecond(int s, ParseIssues issues) => _checkRange(s, 0, 59, issues);

int _checkMilliSecond(int s, ParseIssues issues) =>
    _checkRange(s, 0, 999, issues);

int _checkMicrosecond(int s, ParseIssues issues) =>
    _checkMilliSecond(s, issues);

int checkTZHour(int tzHour, ParseIssues issues) {
  if (!_inRange(tzHour, -12, 14, issues))
    throw new ParseError('Invalid Time Zone Hour: $tzHour');
  return tzHour;
}

//Urgent: get right number of hours:
int checkTZMinute(int tzm, ParseIssues issues) {
  if (!(tzm == 0 || tzm == 30 || tzm == 45 || tzm == 15))
    throw new ParseError('Invalid Time Zone Minute: $tzm');
  return tzm;
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
