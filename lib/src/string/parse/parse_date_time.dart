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
    _parseDcmDateString(s, start, end, false);

/// Returns [true] if [s] is a valid DICOM date [String] (DA).
bool isValidDcmDateString(String s, int start, int end) =>
    _parseDcmDateString(s, start, end, true);

/// TODO: doc
/// Note: end isn't strictly necessary, but makes all data/time parsers
/// have the same interface.
dynamic _parseDcmDateString(String s, int start, int end, bool isValidOnly) {
  int y, m, d;
  if (s == null || end - start != 8 || (s.length - start < 8)) return null;
  try {
    int index = start;
    y = _parseYear(s, index);
    log.debug1('y: $y');
    m = _parseMonth(s, index += 4);
    log.debug1('m: $m');
    d = _parseDay(y, m, s, index += 2);
    log.debug1('d: $d');
    return (isValidOnly) ? true : new DateTime(y, m, d);
  } catch (e) {
    return (isValidOnly) ? false : null;
  }
}

/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
String getDcmDateIssues(String s, int start, int end) {
  String msg = _getLengthError(s.length, 8, 8);
  int y = _parseYear(s, start);
  if (y == null) msg += 'Invalid year(${s.substring(start, start + 4)})\n';
  int m = _parseMonth(s, start + 4);
  if (m == null) return 'Invalid month(${s.substring(start + 4, start + 6)})\n';
  int d = _parseDay(y, m, s, start + 6);
  if (d == null) return 'Invalid day(${s.substring(start + 6, start + 8)})\n';
  return msg;
}

/// if [s] is a valid DICOM time [String] (DA), returns a new
/// Dart [Duration]; otherwise, null.
Duration parseDcmTimeString(String s, [int start = 0, int end]) =>
    _parseDcmTimeString(s, start,  end, false);


/// Returns [true] if [s] is a valid DICOM time [String] (DA).
bool isValidDcmTimeString(String s, [int start = 0, int end]) =>
    _parseDcmTimeString(s, start,  end, false);

// valid lengths: 2 4 6 8-13
dynamic _parseDcmTimeString(String s,
    [int start = 0, int end, bool isValidOnly = false]) {
  int h, m = 0, ss = 0, f = 0;
  if (s == null) return null;
  if (s.length == 0 || (s.length < 8 && s.length.isOdd)) return null;
  try {
    if (end == null) end = s.length;
    log.debug1('before _checkArgs');
    _checkArgs(s, start, end, 2, 14);
    log.debug1('after _checkArgs');

    int index = start;
    h = _parseHour(s, index);
    log.debug1('    h: $h');
    if ((index += 2) < end) {
      m = _parseMinute(s, index);
      log.debug1('    m: $m');
      if ((index += 2) < end) {
        ss = _parseSecond(s, index);
        log.debug1('    ss: $ss');
        if ((index += 2) < end) {
          f = parseFraction(s, index, end);
          log.debug1('    f: $f');
        }
      }
    }
    log.debug1('    h: $h, m: $m, s: $ss, f: $f');
    log.debug2('    f: $f, ms: ${f~/1000}, us: ${f%1000}');
    return (isValidOnly)
        ? true
        : new Duration(
        hours: h,
        minutes: m,
        seconds: ss,
        milliseconds: f ~/ 1000,
        microseconds: f % 1000);
  } on ParseError catch (e) {
    log.debug1('parseDcmTimeString caught:\n $e');
    return (isValidOnly) ? false : null;
  }
}

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

    if (_parseHour(s, index) == null) {
      issues += 'Invalid Hour(${s.substring(start, start + 2)})\n';
      log.debug1('    h: $h');
      if ((index += 2) < end) {
        if (_parseMinute(s, index) == null)
          issues += 'Invalid Minute(${s.substring(start + 2, start + 4)})';
        log.debug1('    m: $m');
        if ((index += 2) < end) {
          if (_parseSecond(s, index) == null)
            issues += 'Invalid Second(${s.substring(start + 4, start + 6)})';
          log.debug1('    ss: $ss');
          if ((index += 2) < end) {
            if (parseFraction(s, index, end) == null)
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
    _parseDcmDateTimeString( dt,  start,  end,  false);

/// Returns [true] if [s] is a valid DICOM date/time [String] (DA).
bool isValidDcmDateTimeString(String dt, int start, int end) =>
    _parseDcmDateTimeString( dt,  start,  end,  false);
//               y  m  d  h   m   s     f    tz
// Legal lengths 4, 6, 8, 10, 12, 14  16-21, 26
dynamic _parseDcmDateTimeString(
    String dt, int start, int end, bool isValidOnly) {
  int y, m = 0, d = 0, h = 0, mm = 0, s = 0, f = 0, tz = 0;
  if (dt == null) return null;
  int length = end - start;
  if (length == 0 || (length < 16 && length.isOdd)) return null;
  try {
    _checkArgs(dt, start, end, 4, 26);
    if (end < 16 && (end - start).isOdd) return null;

    int index = start;
    y = _parseYear(dt, index);
    log.debug1('    y: $y');
    if ((index += 4) < end) {
      m = _parseMonth(dt, index);
      log.debug1('    m: $m');
      if ((index += 2) < end) {
        d = _parseDay(y, m, dt, index += 2);
        log.debug1('    d: $d');
        if ((index += 2) < end) {
          h = _parseHour(dt, index);
          log.debug1('    h: $h');
          if ((index += 2) < end) {
            mm = _parseMinute(dt, index);
            log.debug1('    mm: $mm');
            if ((index += 2) < end) {
              s = _parseSecond(dt, index);
              log.debug1('    s: $s');
              if ((index += 2) < end) {
                log.debug1('    fraction: $index');
                f = parseFraction(dt, index, end);
                log.debug1('    f: $f');
                for(; index < end; index++) {
                  int c = dt.codeUnitAt(index);
                  if (c == kMinusSign || c == kPlusSign) break;
                }
                if (index < end) {
                  log.debug1('    Time Zone: $index');
                  tz = parseTimeZone(dt, index);
                  log.debug1('    tz: $tz');
                  if (f == null) return null;
                  index += 2;
                }
              }
            }
          }
        }
      }
    }
    log.debug1('    y: $y, m:$m, d: $d, h: $h, m: $m, s: $s, f: $f');
    return (isValidOnly)
        ? true
        : new DateTime(y, m, d, h, mm, s, f ~/ 1000, f % 1000);
  } catch (e) {
    return (isValidOnly) ? false : null;
  }
}

/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
String getDcmDateTimeIssues(String s, int start, int end) {
  const int min = 4;
  const int max = 26;
  String msg = _getLengthError(s.length, min, max);
  int start = 0;
  int y = _parseHour(s, start);
  if (y == null) msg += 'Invalid Hour(${s.substring(start, start + 2)})\n';
  int m = _parseMinute(s, start + 2);
  if (m == null) msg += 'Invalid Minute(${s.substring(start + 2, start + 4)})';
  int d = _parseSecond(s, start + 6);
  if (d == null) msg += 'Invalid Second(${s.substring(start + 4, start + 6)})';
  int f = _parseSecond(s, start + 6);
  if (f == null)
    msg += 'Invalid Second Fraction(${s.substring(start + 6, start + 13)})';
  return msg;
}

