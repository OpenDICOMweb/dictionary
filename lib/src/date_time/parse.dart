// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/ascii.dart';
import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/string/parse_error.dart';
import 'package:dictionary/src/string/parse_issues.dart';
import 'package:dictionary/src/string/utils.dart';

import 'time.dart';

// TODO: remove logging before version 0.9.0
final Logger _log =
    new Logger('date_time/utils_old.dart', watermark: Severity.debug1);

// *** Note: end isn't strictly necessary, but makes all
// data/time parsers have the same interface.

//TODO: redo doc
/*
/// if [s] is a valid DICOM date (DA), returns a new Dart [Date];
/// otherwise, null.
int parseDcmDate(String s,
    [int start = 0, int end, int min = 0, int max, ParseIssues issues]) {
  _parseDcmDate(s, start, end, min, max, null, false);
}

/// Returns [true] if [s] is a valid DICOM date [String] (DA).
bool isValidDcmDate(String s,
        [int start = 0, int end, int min = 0, int max, ParseIssues issues]) =>
    _parseDcmDate(s, start, end, min, max, null, true);

/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
ParseIssues getDcmDateIssues(String s,
        [int start = 0, int end, int min = 0, int max, ParseIssues issues]) {
  _parseDcmDate(s, start, end, min, max, issues, false);
}
*/

/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
/// Note: All error checking is don in checkArgs
dynamic parseDcmDate(String s, int start, int end, int min, int max,
    ParseIssues issues, bool isValidOnly) {
  int y, m, d;
  if (end == null) end = s.length;
  try {
    issues = checkArgs(s, start, end, min, max, issues);
    int index = start;
    y = parseYear(s, index, issues);
    if ((index += 4) < end) {
      m = parseMonth(s, index, issues);
      if ((index += 2) < end) d = parseDay(y, m, s, index, issues);
    }
    _log.debug('y: $y, m: $m, d: $d');
  } catch (e) {
    _log.debug('Caught: $e');
    return (isValidOnly) ? false : null;
  }
  if (issues != null) return issues;
  return (isValidOnly) ? true : epochDay(y, m, d);
}
/*
/// if [s] is a valid DICOM time [String] (DA), returns a new
/// Dart [Duration]; otherwise, null.
int parseDcmTime(String s,
        [int start = 0, int end, int min = 0, int max]) =>
    _parseDcmTime(s, start, end, min, max, null, false);

/// Returns [true] if [s] is a valid DICOM time [String] (DA).
bool isValidDcmTime(String s,
        [int start = 0, int end, int min = 0, int max]) =>
    _parseDcmTime(s, start, end, min, max, null, true);

ParseIssues getDcmTimeIssues(String s,
        [int start = 0, int end, int min = 0, int max]) {
  var issues = new ParseIssues('Time', s, start, end);
  return _parseDcmTime(s, start, end, min, max, issues, false);
}
*/

// valid lengths: 2 4 6 8-13
dynamic parseDcmTime(String s, int start, int end, int min, int max,
    ParseIssues issues, bool isValidOnly) {
  int h, m = 0, ss = 0, f = 0;
  end = (end == null) ? s.length : end;
  try {
    //Note: max is 13 because padding should have been removed.
    issues = checkArgs(s, start, end, min, max, issues);
    _log.debug1('after checkArgs');
    int index = start;
    h = parseHour(s, index, issues);
    if ((index += 2) < end) {
      m = parseMinute(s, index, issues);
      if ((index += 2) < end) {
        ss = parseSecond(s, index, issues);
        if ((index += 2) < end) {
          f = parseFraction(s, index, end, issues);
        }
      }
    }
    _log.debug1('    h: $h, m: $m, s: $ss, f: $f\n'
        '    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');
  } on ParseError catch (e) {
    _log.debug1('parseDcmTimeString caught:\n $e');
    return (isValidOnly) ? false : null;
  }
  if (issues != null) return issues;
  return (isValidOnly)
      ? true
      : Time.toMicroseconds(h, m, ss, f ~/ 1000, f % 1000);
}

// valid lengths: 2 4 6 8-13
dynamic getDcmTimeIssues(String s, int start, int end, int min, int max,
    ParseIssues issues) {
  int h,
      m = 0,
      ss = 0,
      f = 0;
  end = (end == null) ? s.length : end;
  _log.debug('getDcmTimeIssues: $issues');
  //Note: max is 13 because padding should have been removed.
  issues = checkArgs(s, start, end, min, max, issues);
  _log.debug1('after checkArgs');
  int index = start;
  h = parseHour(s, index, issues);
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

/*
// **** This section contains private top level parsers for Date, and Time

/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
ParseIssues getDcmDateIssues(String s, int start, int end, int min, int max,
    {bool isValidOnly}) {
  int y, m, d;
  if ((s == null) || (s.length == 0 || (s.length < 8 && s.length.isOdd)))
    return null;
  if (end == null) end = s.length;
  ParseIssues issues;

  var problems = _checkArgs(s, start, end, min, max, false);
  if (problems != "") issues = new ParseIssues("Date", s);
  int index = start;
  y = parseYear(s, index, false);
  if ((index += 4) < end) {
    m = parseMonth(s, index, false);
    if ((index += 2) < end) d = parseDay(y, m, s, index, false);
  }
  log.debug('y: $y, m: $m, d: $d');
  return (isValidOnly) ? true : new DateTime(y, m, d);
}

/// Returns an [issues] [String] if [s] is not a valid DICOM [Time];
/// otherwise, "".
ParseIssues _getDcmTimeIssues(String s,
    [int start = 0, int end, bool isValidOnly = false, ParseIssues issues]) {
  int h, m = 0, ss = 0, f = 0; // time components
  if (s == null) return null;
  if (s.length == 0 || (s.length < 8 && s.length.isOdd)) return null;
  if (issues == null) issues = new ParseIssues("Time", s);
  if (end == null) end = s.length;
  String problems = _checkArgs(s, start, end, 2, 14, false);
  if (problems != "") issues = new ParseIssues("Time", s, problems);
  int index = start;
  if (parseHour(s, index, false) == null) {
    issues += 'Invalid Hour(${s.substring(start, start + 2)})\n';
    _log.debug1('    h: $h');
    if ((index += 2) < end) {
      if (parseMinute(s, index, false) == null)
        issues += 'Invalid Minute(${s.substring(start + 2, start + 4)})';
      _log.debug1('    m: $m');
      if ((index += 2) < end) {
        if (parseSecond(s, index, false) == null)
          issues += 'Invalid Second(${s.substring(start + 4, start + 6)})';
        _log.debug1('    ss: $ss');
        if ((index += 2) < end) {
          if (parseFraction(s, index, end, false) == null)
            issues += 'Invalid Second Fraction(${s.substring(start + 6,
                start + 13)})';
          _log.debug1('    f: $f');
        }
      }
    }
  }
  _log.debug1('    h: $h, m: $m, s: $ss, f: $f');
  _log.debug2('    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');
  return issues;
}
*/
// **** Functions below this line should become private at Version 0.8.0 for
// **** performance reasons.

/*
/// if [s] is a valid DICOM date/time [String] (DT), returns a new
/// corresponding Dart [DateTime]; otherwise, null.
DateTime parseDcmDateTimeString(String dt, int start, int end) =>
    parseDcmDateTimePart(dt, start, end, true, false);

/// Returns [true] if [s] is a valid DICOM date/time [String] (DA).
bool isValidDcmDateTimeString(String dt, int start, int end) =>
    parseDcmDateTimePart(dt, start, end, true, true);

/// Returns [true] if [s] is a valid DICOM date/time [String] (DA).
String getDcmDateTimeIssues(String dt, int start, int end) =>
    parseDcmDateTimePart(dt, start, end, false, false);

//               y  m  d  h   m   s     f    tz
// Legal lengths 4, 6, 8, 10, 12, 14  16-21, 26
dynamic parseDcmDateTimePart(
    String dt, int start, int end, bool throwOnError, bool isValidOnly) {
  int y, m = 0, d = 0, h = 0, mm = 0, s = 0, f = 0, tz = 0;
  if (dt == null) return null;
  int length = end - start;
  if (length == 0 || (length < 16 && length.isOdd)) return null;
  try {
    var msg = _checkArgs(dt, start, end, 4, 26, throwOnError);
    if (end < 16 && (end - start).isOdd) return null;

    int index = start;

    // Parse the year
    y = parseYear(dt, index, throwOnError);
    _log.debug1('    y: $y');
    if (y == null) msg += 'Invalid Year(${dt.substring(index, index + 4)})\n';

    if ((index += 4) < end) {
      // Parse the month
      m = parseMonth(dt, index, true);
      _log.debug1('    m: $m');
      if (m == null)
        msg += 'Invalid month(${dt.substring(index, index + 2)})\n';

      if ((index += 2) < end) {
        // Parse the day
        d = parseDay(y, m, dt, index, true);
        _log.debug1('    d: $d');
        if (d == null)
          msg += 'Invalid day(${dt.substring(index, index + 2)})\n';

        if ((index += 2) < end) {
          // Parse the hour
          h = parseHour(dt, index, true);
          _log.debug1('    h: $h');
          if (h == null)
            msg += 'Invalid Hour(${dt.substring(index, index + 2)})\n';

          if ((index += 2) < end) {
            // Parse the minute
            mm = parseMinute(dt, index, true);
            _log.debug1('    mm: $mm');
            if (mm == null)
              msg += 'Invalid Minute(${dt.substring(index, index + 2)})';

            if ((index += 2) < end) {
              // Parse the second
              s = parseSecond(dt, index, true);
              _log.debug1('    s: $s');
              if (m == null)
                msg += 'Invalid Second(${dt.substring(index, index + 2)})';

              if ((index += 2) < end) {
                // Parse the fraction part
                if (dt.codeUnitAt(index) != kDot) {
                  // Fraction must start with "."
                  var s = 'Invalid Fraction Delimiter: '
                      '"${dt[index]}" = ${dt.codeUnitAt(index)}\n';
                  if (throwOnError) {
                    throw new ParseError(s);
                  } else {
                    return msg += s;
                  }
                }
                // Find end of Fraction
                do {
                  if (index < end) index++;
                } while (isDigitChar(dt.codeUnitAt(index)));
                _log.debug1('    fraction: $index');

                if (index < end) {
                  // Parse the Fraction Uint
                  f = parseFraction(dt, index, end, throwOnError);
                  _log.debug1('    f: $f');
                  index = end;
                }
                if (f == null)
                  msg += 'Invalid Fraction(${dt.substring(index, end)})';

                if (index < end) {
                  // Parse the Time Zone
                  int c = dt.codeUnitAt(index);
                  if (c != kMinusSign || c != kPlusSign) {
                    // Time Zone must start with "-/+"
                    var eMsg = 'Invalid Fraction Delimiter: '
                        '"${dt[index]}" = ${dt.codeUnitAt(index)}\n';
                    if (throwOnError) {
                      throw new ParseError(eMsg);
                    } else {
                      return msg += eMsg;
                    }
                  }

                  // Parse Time Zone
                  _log.debug1('    Time Zone: $index');
                  tz = parseTimeZone(dt, index, true);
                  _log.debug1('    tz: $tz');
                  if (tz == null)
                    msg += 'Invalid Time Zone(${dt.substring(start + 14,
                        start + 20)})';
                  index += 2;
                }
              }
            }
          }
        }
      }
    }
    _log.debug1('    y: $y, m:$m, d: $d, h: $h, m: $m, s: $s, f: $f');
    return new DateTime(y, m, d, h, mm, s, f ~/ 1000, f % 1000);
  } catch (e) {
    return null;
  }
}
*/
/*
/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
//               y  m  d  h   m   s     f    tz
// Legal lengths 4, 6, 8, 10, 12, 14  16-21, 26
dynamic getDcmDateTimeIssues(String dt, int start, int end) {
  int y, m = 0, d = 0, h = 0, mm = 0, s = 0, f = 0, tz = 0;
  if (dt == null) return null;
  int length = end - start;
  if (length == 0 || (length < 16 && length.isOdd)) return null;
  try {
    var msg = _checkArgs(dt, start, end, 4, 26, false);
    if (end < 16 && (end - start).isOdd) return null;

    int index = start;
    y = parseYear(dt, index);
    _log.debug1('    y: $y');
    if (y == null) msg += 'Invalid Year(${dt.substring(start, start + 4)})\n';
    if ((index += 4) < end) {
      m = parseMonth(dt, index);
      _log.debug1('    m: $m');
      if (m == null)
        msg += 'Invalid month(${dt.substring(start + 4, start + 6)})\n';
      d = parseDay(y, m, dt, start + 6);
      if ((index += 6) < end) {
        d = parseDay(y, m, dt, index += 2);
        _log.debug1('    d: $d');
        if (d == null)
          msg += 'Invalid day(${dt.substring(start + 6, start + 8)})\n';
        if ((index += 8) < end) {
          h = parseHour(dt, index);
          _log.debug1('    h: $h');
          if (h == null)
            msg += 'Invalid Hour(${dt.substring(start, start + 10)})\n';
          if ((index += 10) < end) {
            mm = parseMinute(dt, index);
            _log.debug1('    mm: $mm');
            if (mm == null)
              msg += 'Invalid Minute(${dt.substring(start + 2, start + 4)})';
            if ((index += 12) < end) {
              s = parseSecond(dt, index);
              _log.debug1('    s: $s');
              if (s == null)
                msg += 'Invalid Second(${dt.substring(start + 4, start + 6)})';
              if ((index += 14) < end) {
                _log.debug1('    fraction: $index');
                if (dt.codeUnitAt(index) != kDot) return msg;
                f = parseFraction(dt, index, end);
                _log.debug1('    f: $f');
                if (f == null)
                  msg += 'Invalid Second Fraction(${dt.substring(start + 14,
                      start + 20)})';
                do {
                  if (index < end) index++;
                } while (isDigitChar(dt.codeUnitAt(index)));
                if (index < end) int c = dt.codeUnitAt(index);
                if (c != kMinusSign || c != kPlusSign) return msg;
                _log.debug1('    Time Zone: $index');
                tz = parseTimeZone(dt, index);
                _log.debug1('    tz: $tz');
                if (tz == null)
                  msg += 'Invalid Time Zone(${dt.substring(start + 14,
                        start + 20)})';
                index += 2;
              }
            }
          }
        }
      }
    }
    _log.debug1('    y: $y, m:$m, d: $d, h: $h, m: $m, s: $s, f: $f');
    return msg;
  } catch (e) {
    _log.debug('Error: caught $e');
    rethrow;
  }
}
*/

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

/// Returns a [String] containing an invalid length error message,
/// or [null] if there are no errors.
String _getLengthError(int length, int min, int max) {
  if (length == null) return 'Invalid length(Null)';
  if (length == 0) return 'Invalid length(0)';
  return (length < min || max < length)
      ? 'Length Error: min($min) <= Value($length) <= max($max)'
      : null;
}

/// Parses a base 10 [int] from [offset] to [limit], and returns
/// its corresponding value. If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: Assumes [offset] and [limit] are valid values.
/// Note: all the parsers might throw so callers should use try catch.
/// Returns a valid [year] or [null].  The [year] must be 4 characters.
int parseYear(String s, int start, [ParseIssues issues]) =>
    _checkYear(uintParser(s, start, start + 4, issues), issues);

/// Returns a valid [month] or [null].  The [month] must be 2 characters.
int parseMonth(String s, int start, [ParseIssues issues]) =>
    _checkMonth(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [day] or [null].  The [day] must be 2 characters.
int parseDay(int year, int month, String s, int start, [ParseIssues issues]) =>
    _checkDay(year, month, uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseHour(String s, int start, [ParseIssues issues]) =>
    checkHour(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseMinute(String s, int start, [ParseIssues issues]) =>
    checkMinute(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseSecond(String s, int start, [ParseIssues issues]) =>
    checkSecond(uintParser(s, start, start + 2, issues), issues);

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseFraction(String s, int start, int end, [ParseIssues issues]) {
  _log.debug2('s: ${s.substring(start, end)}');
  _log.debug2('    end: $end');
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
/*
/// Returns a [String] containing issues with the Date part of the [String],
/// if any; otherwise, the empty string.
ParseIssues dateIssues(String s, int start, int end, [ParseIssues issues]) {
  issues = (issues == null)
      ? new ParseIssues('Date', s.substring(start, end))
      : issues;
  issues.checkLength(s.length, 8, 8);
  int index = start;
  try {
    yearIssues(s, index, index + 4, issues);
    if ((index += 4) < end) {
      monthIssues(s, index, index + 2, issues);
      if ((index += 2) < end) {
        dayIssues(s, index, index + 2, issues);
      }
    }
  } on ParseError {
    return issues;
  }
  return issues;
}

ParseIssues timeIssues(String s, int start, int end, [ParseIssues issues]) {
  issues = (issues == null)
      ? new ParseIssues('Time', s.substring(start, end))
      : issues;
  issues.checkLength(s.length, 2, 14);
  int index = start;
  try {
    hourIssues(s, index, index + 2, issues);
    if ((index += 2) < end) {
      minuteIssues(s, index, index + 2, issues);
      if ((index += 2) < end) secondIssues(s, index, index + 2, issues);
    }
  } on ParseError {
    return issues;
  }
  return issues;
}

ParseIssues dateTimeIssues(String s, int start, int end) {
  ParseIssues issues = new ParseIssues('DcmDateTime', s.substring(start, end));
  issues.checkLength(s.length, 4, 26);
  int length = end - start;
  int index = start;
  try {
    int end0 = (length < 8) ? end : 8;
    dateIssues(s, index, end0, issues);
    if (length > 8) timeIssues(s, index += 8, length, issues);
  } on ParseError {
    return issues;
  }
  return issues;
}
*/
// **** Functions below this line should become private at Version 0.8.0 for
// **** performance reasons.
/*
ParseIssues yearIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 4, 4, issues, 'year');

ParseIssues monthIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'month');

ParseIssues dayIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'day');

ParseIssues hourIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'hour');

ParseIssues minuteIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'minute');

ParseIssues secondIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'second');

ParseIssues fractionIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 6, issues, 'fraction');

void tzSign(String s, int start, ParseIssues issues) {
  int c = s.codeUnitAt(start);
  if (c != kMinusSign || c != kPlusSign)
    issues.add('TZ Offset: Invalid TZ Sign char: "${s[start]}", code($c). '
        'The TZSign must be "+" or "-".');
}

ParseIssues tzHourIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'TZHour');

ParseIssues tzMinuteIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 6, issues, 'TZMinutes');

ParseIssues timeZoneIssues(String s, int start, int end, ParseIssues issues) {
  issues.checkLength(end - start, 5, 5, 'TZ Offset');
  int index = start;
  tzSign(s, index, issues);
  tzHourIssues(s, index++, index + 2, issues);
  tzMinuteIssues(s, index++, index + 2, issues);
  return issues;
}

String _checkLengthIssue(int length, int min, int max, ParseIssues issues,
        [String type = ""]) =>
    (length < min || length > max)
        ? '$type: Invalid length: min($min) <= length($length) <= max($max)'
        : "";
*/
/*
ParseIssues _dateTimeIssues(String s, int start, int end, int min, int max,
    ParseIssues issues, String subtype) {
  issues.checkLength(end - start, min, max, subtype);
  _checkIssueArgs(s, start, end, min, max, issues);
  for (int i = start; i < end; i++) {
    //Issue: return first bad char or all bad characters?
    int c = s.codeUnitAt(i);
    //  print('c: $c');
    if (!isDigitChar(c)) {
      issues.add('$subtype: Invalid char "${s[i]}" code($c) at index $i.');
    }
  }
  return issues;
}
*/
/*
/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid and [throwOnError]
/// is [true] it throws an error message; otherwise, is returns
/// a [String] describing any errors encountered.
///
/// For the arguments to be valid:
///   1. end >= start + min && end <= start + max
///   2. end < s.length
///
///                | end < length
///     0  start  min   max
///     |....|. ...|.....|....|
///
/// Assumption: non of the arguments are null.
String _checkIssueArgs(String s, int start, int end, int min, int max,
    ParseIssues issues) {
  _log.debug1('_checkArgs: (${s.length})"$s"\n'
      '    start: $start, end: $end, min: $min, max: $max');
  String issues = "";
  if (s == null) {
    issues += 'Invalid null String';
    if (issues != null) throw new ParseError(issues);
    _log.debug2('issues 2: "$issues"');
    return issues;
  }
  if (end == null) {
    end = s.length;
  } else {
    if (s.length < end) {
      issues += 'end($end)is greater than the length of s(${s.length})"$s".\n';
      _log.debug2('issues 3: "$issues"');
      if (issues != null) throw new ParseError(issues);
    }
  }
  if (end < start + min) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"';
    _log.debug2('issues 4: "$issues"');
    if (issues != null) throw new ParseError(issues);
  }
  if (end > start + max) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"';
    _log.debug2('issues 5: "$issues"');
    if (issues != null) throw new ParseError(issues);
  }
  _log.debug2('_checkArgs issues: $issues');
  return issues;
}
*/
