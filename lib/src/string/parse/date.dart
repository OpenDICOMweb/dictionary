// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/logger.dart';
import 'package:dictionary/src/string/parse/parse_error.dart';

//Urgent:
// 1. define _isValidMonthDay
// 2. define minYear, maxYear
// 3. define _isValidMonthDay
// 4. calculate tzOffsetMin
// 5. calculate tzOffsetMax
// 6. handle leap Seconds with table

// TODO: remove logging before version 0.9.0
final Logger log =
    new Logger('date_time/utils_old.dart', watermark: Severity.info);

//TODO: make these parameters
int minYear = -1000000;
int maxYear = 1000000;

// Note: _inRange throws so all the other _check* might also throw.
bool _inRange(int v, int min, int max, [bool throwOnError = true]) {
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (throwOnError) throw new ParseError(msg);
    return false;
  }
  return true;
}

bool _isValidDay(int y, int m, int d, [bool throwOnError = true]) {
  try {
    bool isY = _inRange(y, minYear, maxYear, throwOnError);
    bool isM = _inRange(m, 1, 12, throwOnError);
    bool isD = _inRange(d, 1, _lastDayOfMonth(y, m), throwOnError);
    bool v = isY && isM && isD;
    // log.debug2('isValidDay: $v');
    return v;
  } on ParseError {
    // log.debug('_isValidDay Error: $e');
    return null;
  }
}

//Issue: should this be public (not private)
int _lastDayOfMonth(int y, int m) =>
    (m != 2 || !isLeapYear(y)) ? _daysInMonthCommonYear[m - 1] : 29;

int lastDayOfMonth(int y, int m) => _lastDayOfMonth(y, m);

const List<int> _daysInMonthCommonYear = const [
  31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 // no reformat
];

bool isLeapYear(int y) => (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0);

/// Returns number of days since Epoch Zero Day 1970-01-01.
/// Negative values indicate days prior to 1970-01-01.
///
/// Preconditions:
///     y-m-d represents a date in the (Gregorian) calendar
///     m is in [1, 12]
///     d is in [1, lastDayOfMonth(y, m)]
///     y is "approximately" in [min()/366, max()/366]
///     Exact range of validity is:
///         [epochFromDays(Int64.min), epochFromDays(Int64.max - 719468)]
int epochDay(int y, int m, int d) {
  // log.debug1('epochDay: y: $y, m: $m, d: $d');
  int eDay;
  try {
    if (!_isValidDay(y, m, d)) return null;
    // log.debug2('  epochDay: $y-$m-$d');
    // log.debug2('    cYear: $y');
    int nYear = (m <= 2) ? y - 1 : y;
    // log.debug2('    nYear: $nYear');
    int era = (nYear >= 0 ? nYear : nYear - 399) ~/ 400;
    // log.debug2('    era: $era');
    int yoe = nYear - (era * 400); // [0, 399]
    // log.debug2('    yoe: $yoe');
    int doy = ((153 * (m + ((m > 2) ? -3 : 9))) + 2) ~/ 5 + (d - 1); // [0, 365]
    // log.debug2('    doy: $doy');
    int doe = (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy; // [0, 146096]
    // log.debug2('    doe: $era');
    eDay = (era * 146097) + doe - 719468;
    // log.debug('  y: $y, m: $m, d: $d: $eDay');
  } on ParseError {
    return null;
  }
  return eDay;
}

/// Returns gregorian year/month/day in a 4-byte [ByteData] triple.
///
/// Preconditions:
///     z is number of days since 1970-01-01 and is in the range:
///         [epochFromDays(Int64.min), epochFromDays(Int64.max - 719468)]
// ** ByteData
List<int> epochDayToDate(int epochDay) {
  // log.debug1('  epochDayToDate: $epochDay');
  int z = epochDay + 719468;
  // log.debug2('  z: $z');
  int era = ((z >= 0) ? z : z - 146096) ~/ 146097;
  // log.debug2('  era: $era');
  int doe = z - (era * 146097);
  // log.debug2('  doe0: $doe');
//  doe = (doe < 0) ? -doe : doe;
//  // log.debug2('  doe1: $doe');
  int yoe = _yearOfEpoch(doe);
  // log.debug2('  yoe: $yoe');
  int nYear = yoe + (era * 400);
  // log.debug2('  Normalized Year: $nYear');
  int doy = doe - ((365 * yoe) + (yoe ~/ 4) - (yoe ~/ 100)); // [0, 365]
  // log.debug2('  doy: $doy');
  int mp = ((5 * doy) + 2) ~/ 153; // [0, 11]
  // log.debug2('  Normalized Month: $mp');
  int d = doy - (((153 * mp) + 2) ~/ 5) + 1; // [1, 31]
  // log.debug2('  Gregorian Day: $d');
  int m = mp + ((mp < 10) ? 3 : -9); // [1, 12]
  // log.debug2('  Gregorian Month: $m');
  int y = (m <= 2) ? nYear + 1 : nYear;
  // log.debug2('  Gregorian Year: $y');
  // log.debug('  $epochDay: $y:$m:$d');
  //return toBDDate(y, m, d);
  return [y, m, d];
}

/// Returns the Day in number of days since Epoch Zero Day. The returned
/// value is in the range: `0 <= yoe <= 399`.
/// yoe: year of Epoch
/// doe: day of Epoch
int _yearOfEpoch(int doe) {
  // log.debug2('    doe: $doe');
  int x0 = (doe ~/ 1460);
  // log.debug2('    x0: $x0');
  int x1 = (doe ~/ 36524);
//  log.debug2('    x1: $x1');
  int x2 = (doe ~/ 146096);
  // log.debug2('    x2: $x2');
  int x3 = ((doe - x0) + x1 - x2) ~/ 365; // [0, 399]
  // log.debug2('    x3: $x3');
  return x3;
}

int weekdayFromEDay(int z) =>
    (z >= -4) ? (z + 4).remainder(7) : (z + 5).remainder(7);

int weekdayDifference(int wd0, int wd1) {
  int n = wd0 - wd1;
  return n <= 6 ? n : n + 7;
}

int nextWeekday(int wd) => wd < 6 ? wd + 1 : 0;

int previousWeekday(int wd) => wd > 0 ? wd - 1 : 6;

String dateToString(List<int> date) => '"${date[0]}-${date[1]}-${date[2]}"';
