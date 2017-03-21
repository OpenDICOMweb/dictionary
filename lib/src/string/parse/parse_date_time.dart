// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.string.parse;

// *** Note: end isn't strictly necessary, but makes all
// data/time parsers have the same interface.

/// if [s] is a valid DICOM date (DA), returns a new Dart [DateTime] at
/// midnight on the specified date (i.e. with time parts all being 0);
/// otherwise, null.
DateTime parseDcmDateString(String s, int start, int end) =>
    _parseDcmDatePart(s, start, end, 8, 8, true);

/// Returns [true] if [s] is a valid DICOM date [String] (DA).
bool isValidDcmDateString(String s, int start, int end) =>
    _parseDcmDatePart(s, start, end, 8, 8, true);

/// if [s] is a valid DICOM time [String] (DA), returns a new
/// Dart [Duration]; otherwise, null.
Duration parseDcmTimeString(String s, [int start = 0, int end]) =>
    _parseDcmTimePart(s, start, end, false);

/// Returns [true] if [s] is a valid DICOM time [String] (DA).
bool isValidDcmTimeString(String s, [int start = 0, int end]) =>
    _parseDcmTimePart(s, start, end, true);

// **** This section contains private top level parsers for Date, Time,
// **** and DateTime.

/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
dynamic _parseDcmDatePart(
    String dp, int start, int end, int min, int max, bool isValidOnly) {
  int y, m, d;
  try {
    _checkArgs(dp, start, end, min, max);
    int index = start;

    y = parseYear(dp, index, true);
    if ((index += 4) < end) {
      m = parseMonth(dp, index, true);
      if ((index += 2) < end) d = parseDay(y, m, dp, index, true);
    }
    log.debug('y: $y, m: $m, d: $d');
  } catch (e) {
    log.debug('Caught: $e');
    return (isValidOnly) ? false : null;
  }
  return (isValidOnly) ? true : new DateTime(y, m, d);
}

// valid lengths: 2 4 6 8-13
dynamic _parseDcmTimePart(String s, int start, int end, [bool isValidOnly]) {
  int h, m = 0, ss = 0, f = 0;
  try {
    //Note: max is 13 because padding should have been removed.
    _checkArgs(s, start, end, 2, 13);
    log.debug1('after _checkArgs');

    int index = start;
    h = parseHour(s, index, true);
    if ((index += 2) < end) {
      m = parseMinute(s, index, true);
      if ((index += 2) < end) {
        ss = parseSecond(s, index, true);
        if ((index += 2) < end) {
          f = parseFraction(s, index, end, true);
        }
      }
    }
    log.debug1('    h: $h, m: $m, s: $ss, f: $f');
    log.debug2('    f: $f, ms: ${f~/1000}, us: ${f%1000}');
  } on ParseError catch (e) {
    log.debug1('parseDcmTimeString caught:\n $e');
    return (isValidOnly) ? false : null;
  }
  return (isValidOnly)
      ? true
      : new Duration(
          hours: h,
          minutes: m,
          seconds: ss,
          milliseconds: f ~/ 1000,
          microseconds: f % 1000);
}

final dtVector = new List<int>(8);
///
/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
dynamic _parseDcmDateTimePart(String dt, int start, int end,
    [bool isValidOnly = false]) {
  int y, m, d, tzOffset;
  int microsecondsSinceEpoch;
  int timeInMicroseconds;
  try {
    _checkArgs(dt, start, end, 4, 26);
    int index = start;

    ///
    int microsecondsSinceEpoch = _parseDcmDatePart(dt, index, end, 4, 8, true);
    if ((index += 8) < end) {
      timeInMicroseconds = _parseDcmTimePart(dt, index, end, true);
      index = _charAt(dt, index, end, "-+");
      if (index < end)
        tzOffset = parseTimeZone(dt, index, true);
    }
    log.debug('date: $microsecondsSinceEpoch, time: $timeInMicroseconds, tz: $tzOffset');
  } catch (e) {
    log.debug('Caught: $e');
    return (isValidOnly) ? false : null;
  }

  return (isValidOnly) ? true : new DateTime.fromMicrosecondsSinceEpoch(y, m, d);
}

// **** Functions below this line should become private at Version 0.8.0 for
// **** performance reasons.

int _charAt(String s, int start, int end, String target) {
  for(int i = 0; i < end; i++) {
    int c = s.codeUnitAt(i);
    for (int j = 0; j < s.length; j++)
      if (target.codeUnitAt(j) == c) return i;
  }
}

String _dtError(String s, int start, int end, String msg, String type) {
  String s0 = 'Invalid $type (${s.substring(start, end)})\n';
  log.debug('$type Error: "$s"');
  return (msg == null) ? s0 : msg += '\n' + s0;
}

String _yearError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'year');

String _monthError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'month');

String _dayError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'day');

String _hourError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'hour');

String _minuteError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'minute');

String _secondError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'second');

String _fractionError(String s, int start, int end, [String msg]) =>
    _dtError(s, start, end, msg, 'fraction');

/// Returns an [issues] [String] if [s] is not a valid DICOM [Time];
/// otherwise, "".
String getDcmTimeStringIssues(String s,
    [int start = 0, int end, bool isValidOnly = false]) {
  int h, m = 0, ss = 0, f = 0; // time components
  String issues;
  if (s == null) return null;
  if (s.length == 0 || (s.length < 8 && s.length.isOdd)) return null;
  if (end == null) end = s.length;
  try {
    issues = _checkArgs(s, start, end, 2, 14, false);

    int index = start;
    if (parseHour(s, index, true) == null) {
      issues += 'Invalid Hour(${s.substring(start, start + 2)})\n';
      log.debug1('    h: $h');
      if ((index += 2) < end) {
        if (parseMinute(s, index, true) == null)
          issues += 'Invalid Minute(${s.substring(start + 2, start + 4)})';
        log.debug1('    m: $m');
        if ((index += 2) < end) {
          if (parseSecond(s, index, true) == null)
            issues += 'Invalid Second(${s.substring(start + 4, start + 6)})';
          log.debug1('    ss: $ss');
          if ((index += 2) < end) {
            if (parseFraction(s, index, end, true) == null)
              issues += 'Invalid Second Fraction(${s.substring(start + 6,
                  start + 13)})';
            log.debug1('    f: $f');
          }
        }
      }
    }
    log.debug1('    h: $h, m: $m, s: $ss, f: $f');
    log.debug2('    f: $f, ms: ${f ~/ 1000}, us: ${f % 1000}');
  } on ParseError catch (e) {
    log.debug1('dcmTimeString Issues caught: $e');
  }
  return issues;
}

/// if [s] is a valid DICOM date/time [String] (DT), returns a new
/// corresponding Dart [DateTime]; otherwise, null.
DateTime parseDcmDateTimeString(String dt, int start, int end) =>
    parseDcmDateTimePart(dt, start, end, true, false);

/// Returns [true] if [s] is a valid DICOM date/time [String] (DA).
bool isValidDcmDateTimeString(String dt, int start, int end) {
  bool date = parseDcmDateTimePart(dt, start, end, true, true);
}

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
    log.debug1('    y: $y');
    if (y == null) msg += 'Invalid Year(${dt.substring(index, index + 4)})\n';

    if ((index += 4) < end) {
      // Parse the month
      m = parseMonth(dt, index, true);
      log.debug1('    m: $m');
      if (m == null)
        msg += 'Invalid month(${dt.substring(index, index + 2)})\n';

      if ((index += 2) < end) {
        // Parse the day
        d = parseDay(y, m, dt, index, true);
        log.debug1('    d: $d');
        if (d == null)
          msg += 'Invalid day(${dt.substring(index, index + 2)})\n';

        if ((index += 2) < end) {
          // Parse the hour
          h = parseHour(dt, index, true);
          log.debug1('    h: $h');
          if (h == null)
            msg += 'Invalid Hour(${dt.substring(index, index + 2)})\n';

          if ((index += 2) < end) {
            // Parse the minute
            mm = parseMinute(dt, index, true);
            log.debug1('    mm: $mm');
            if (mm == null)
              msg += 'Invalid Minute(${dt.substring(index, index + 2)})';

            if ((index += 2) < end) {
              // Parse the second
              s = parseSecond(dt, index, true);
              log.debug1('    s: $s');
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
                log.debug1('    fraction: $index');

                if (index < end) {
                  // Parse the Fraction Uint
                  f = parseFraction(dt, index, end, throwOnError);
                  log.debug1('    f: $f');
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
                  log.debug1('    Time Zone: $index');
                  tz = parseTimeZone(dt, index, true);
                  log.debug1('    tz: $tz');
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
    log.debug1('    y: $y, m:$m, d: $d, h: $h, m: $m, s: $s, f: $f');
    return new DateTime(y, m, d, h, mm, s, f ~/ 1000, f % 1000);
  } catch (e) {
    return null;
  }
}

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
    log.debug1('    y: $y');
    if (y == null) msg += 'Invalid Year(${dt.substring(start, start + 4)})\n';
    if ((index += 4) < end) {
      m = parseMonth(dt, index);
      log.debug1('    m: $m');
      if (m == null)
        msg += 'Invalid month(${dt.substring(start + 4, start + 6)})\n';
      d = parseDay(y, m, dt, start + 6);
      if ((index += 6) < end) {
        d = parseDay(y, m, dt, index += 2);
        log.debug1('    d: $d');
        if (d == null)
          msg += 'Invalid day(${dt.substring(start + 6, start + 8)})\n';
        if ((index += 8) < end) {
          h = parseHour(dt, index);
          log.debug1('    h: $h');
          if (h == null)
            msg += 'Invalid Hour(${dt.substring(start, start + 10)})\n';
          if ((index += 10) < end) {
            mm = parseMinute(dt, index);
            log.debug1('    mm: $mm');
            if (mm == null)
              msg += 'Invalid Minute(${dt.substring(start + 2, start + 4)})';
            if ((index += 12) < end) {
              s = parseSecond(dt, index);
              log.debug1('    s: $s');
              if (s == null)
                msg += 'Invalid Second(${dt.substring(start + 4, start + 6)})';
              if ((index += 14) < end) {
                log.debug1('    fraction: $index');
                if (dt.codeUnitAt(index) != kDot) return msg;
                f = parseFraction(dt, index, end);
                log.debug1('    f: $f');
                if (f == null)
                  msg += 'Invalid Second Fraction(${dt.substring(start + 14,
                      start + 20)})';
                do {
                  if (index < end) index++;
                } while (isDigitChar(dt.codeUnitAt(index)));
                if (index < end) int c = dt.codeUnitAt(index);
                if (c != kMinusSign || c != kPlusSign) return msg;
                log.debug1('    Time Zone: $index');
                tz = parseTimeZone(dt, index);
                log.debug1('    tz: $tz');
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
    log.debug1('    y: $y, m:$m, d: $d, h: $h, m: $m, s: $s, f: $f');
    return msg;
  } catch (e) {
    log.debug('Error: caught $e');
    rethrow;
  }
}
*/
