// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.string.parse;

// ********* private functions after this line **********

/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid and [doThrow]
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
String _checkArgs(String s, int start, int end, int min, int max,
    [doThrow = true]) {
  log.debug1('_checkArgs($doThrow): (${s.length})"$s"\n'
      '    start: $start, end: $end, min: $min, max: $max');
  String issues = "";
  if (s == null) {
    issues += 'Invalid null String';
    if (doThrow) throw new ParseError(issues);
    log.debug2('issues 2: "$issues"');
    return issues;
  }
  if (end == null) {
    end = s.length;
  } else {
    if (s.length < end) {
      issues += 'end($end)is greater than the length of s(${s.length})"$s".\n';
      log.debug2('issues 3: "$issues"');
      if (doThrow) throw new ParseError(issues);
    }
  }
  if (end < start + min) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"';
    log.debug2('issues 4: "$issues"');
    if (doThrow) throw new ParseError(issues);
  }
  if (end > start + max) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"';
    log.debug2('issues 5: "$issues"');
    if (doThrow) throw new ParseError(issues);
  }
  log.debug2('_checkArgs issues: $issues');
  return issues;
}

int _checkYear(int y) => _checkRange(y, 0, 9999);
int _checkMonth(int m) => _checkRange(m, 1, 12);
int _checkHour(int h) => _checkRange(h, 0, 23);
int _checkMinute(int mm) => _checkRange(mm, 0, 59);
int _checkSecond(int s) => _checkRange(s, 0, 59);
int _checkFraction(int f) => _checkRange(f, 0, 999999);

/*
int _checkDay(int y, int m, int d) {
  const List<int> _daysPerMonth = const <int>[
    0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 //keep
  ];
  //TODO: Fix to handle leap years and leap seconds
  return _checkRange(d, 1, _daysPerMonth[_checkMonth(m)]);
}
*/

int _checkDay(int y, int m, int d) {
  const List<int> _daysPerMonth = const <int>[
    0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 //keep
  ];
  //TODO: Test leap year handling
  log.debug('_checkDay: $y-$m-$d');
  int maxDay = (m != 2) ? _daysPerMonth[m] : (_isLeapYear(y)) ? 29 : 28;
  log.debug('_checkDay: day: $d');
  return _checkRange(d, 1, maxDay);
}

/// if (year is not divisible by 4) then (it is a common year)
/// else if (year is not divisible by 100) then (it is a leap year)
/// else if (year is not ivisible by 400) then (it is a common year)
/// else (it is a leap year)
///
/// Note: error checking for year value is done by caller.
/*bool _isLeapYear(int year) => !_isCommonYear(year);

bool _isCommonYear(int year) =>
    (year % 4 != 0) || (year % 400 == 0) && !(year % 100 == 0);*/

bool _isLeapYear(int year) =>
    (year % 4 == 0)&& (year % 100 != 0 || year % 400 == 0);

bool _isCommonYear(int year) =>!_isLeapYear(year);

int _checkTimeZone(int sign, int hour, int minute) {
  int h = sign * hour;
  _checkRange(h, -12, 14);
  if (minute % 15 != 0)
    throw new ParseError('Invalid Time Zone minute offset($minute)');
  return ((hour * 60) + minute) * sign;
}

// Note: _checkRange throws so all the other _check* might also throw.
int _checkRange(int v, int min, int max) {
  if (v < min || v > max) throw new ParseError('Invalid value($v)');
  return v;
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
int _parseYear(String s, [int start = 0]) =>
    _checkYear(_parseUint(s, start, start + 4));

/// Returns a valid [month] or [null].  The [month] must be 2 characters.
int _parseMonth(String s, [int start = 0]) =>
    _checkMonth(_parseUint(s, start, start + 2));

/// Returns a valid [day] or [null].  The [day] must be 2 characters.
int _parseDay(int year, int month, String s, [int start = 0]) =>
    _checkDay(year, month, _parseUint(s, start, start + 2));

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int _parseHour(String s, [int start = 0]) =>
    _checkHour(_parseUint(s, start, start + 2));

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int _parseMinute(String s, [int start = 0]) =>
    _checkMinute(_parseUint(s, start, start + 2));

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int _parseSecond(String s, [int start = 0]) =>
    _checkSecond(_parseUint(s, start, start + 2));

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseFraction(String s, int start, int end) {
  log.debug2('s: ${s.substring(start, end)}');
  log.debug2('    end: $end');
  int c = s.codeUnitAt(start);
  log.debug2('    c: ${s[start]}');
  if (c != kDot) throw new ParseError('Missing decimal point (".")');
  int f = _parseUint(s, start + 1, end);
  log.debug2('    f.uint: $f');
  f = toMicroseconds(f);
  log.debug2('    f: $f');
  return _checkFraction(f);
}

/// Returns a valid [hour] or [null].  The [hour] must be 2 characters.
int parseTimeZone(String s, int start) {
  int sign = 1;
  log.debug2('s: ${s.substring(start, start + 5)}');
  log.debug2('    end: $start + 5');
  int c = s.codeUnitAt(start);
  if (c == kMinusSign) {
    sign = -1;
  } else if (c != kPlusSign) {
    throw new ParseError('No Time Zone present at index($start) in "$s"');
  }
  int h = _parseHour(s, start + 1);
  log.debug2('    tz hour: $h');
  int m = _parseMinute(s, start + 3);
  log.debug2('    tz minute: $m');
  return _checkTimeZone(sign, h, m);
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

//Note: the following do no error checking.
String digits2(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String digits3(int n) {
  if (n >= 100) return "$n";
  if (n >= 10) return "$n";
  return "$n";
}

String digits4(int n) {
  if (n >= 1000) return "$n";
  if (n >= 100) return "0$n";
  if (n >= 10) return "00$n";
  return "000$n";
}

String digits6(int n) {
  log.debug2('    _digit6: $n');
  if (n >= 100000) return "$n";
  if (n >= 10000) return "0$n";
  if (n >= 1000) return "00$n";
  if (n >= 100) return "000$n";
  if (n >= 10) return "0000$n";
  return "00000$n";
}
