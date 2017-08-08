// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:core/system.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/issues/parse_issues.dart';

import 'parse.dart';

class Date {
  final int _epochDay;

  Date(int year, [int month = 0, int day = 0])
      : _epochDay = epochDay(year, month, day);

  //Internal constructor - hidden when exported:
  Date.fromEpochDay(this._epochDay);

  int get year => _yearFromEpochDay(_epochDay);

  int get month => _monthFromEpochDay(_epochDay);

  int get day => _dayFromEpochDay(_epochDay);

  int get daysSinceEpoch => epochDay(year, month, day);

  String get y => digits4(year);

  String get m => digits2(month);

  String get d => digits2(day);

  String get dcm => '$y$m$d';

  String get inet => '$y:$m:$d';

  Date get today {
    DateTime dt = new DateTime.now();
    return new Date(dt.year, dt.month, dt.day);
  }

  int get weekday => weekdayFromEpochDay(_epochDay);

  String get weekDayName => weekdayNames[day];

  static const int minLength = 8;
  static const int maxLength = 8;

  static const List<String> weekdayNames = const <String>[
    "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday" // no reformat
  ];

  /* TODO: add later
  DcmDateTime add(Time time, [TimeZone tz]) =>
    new DcmDateTime.fromDateTime(this, time, tz);

  DcmDateTime subtract(Time time, [TimeZone tz]) {
    new DcmDateTime.fromDateTime(this, time);
  }
  */
  @override
  String toString() => '$y-$m-$d';

  static bool isValidString(String s,
          {int start = 0, int end, int min = 0, int max}) =>
      isValidDcmDate(s, min: min, max: max);

  static Date parse(String s, {int start = 0, int end, int min = 0, int max}) {
    int epochDay = parseDcmDate(s, start: start, end: end, min: min, max: max);
    return (epochDay == null) ? null : new Date.fromEpochDay(epochDay);
  }

  static ParseIssues issues(String s,
      {int start = 0, int end, int min = 0, int max}) {
    ParseIssues issues = new ParseIssues('Date', s);
    getDcmDateIssues(s, min: 8, max: 8, issues: issues);
    return issues;
  }
}

//TODO: make everything below this line internal

// Note: _checkRange throws so all the other _check* might also throw.
bool _inRange(int v, int min, int max, [bool throwOnError = true]) {
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (throwOnError) throw new ParseError(msg);
    return false;
  }
  return true;
}

//TODO: what should these values be?
const int defaultMinYear = -1000000;
const int defaultMaxYear = 1000000;

bool _isValidDate(int y, int m, int d,
    {int minYear = defaultMinYear,
    int maxYear = defaultMaxYear,
    bool throwOnError = true}) {
  try {
    if (_inRange(y, minYear, maxYear, throwOnError) &&
        _inRange(m, 1, 12, throwOnError) &&
        _inRange(d, 1, _lastDayOfMonth(y, m), throwOnError)) return true;
  } on ParseError {
    return false;
  }
  return true;
}

//Issue: should this be public (not private)
int _lastDayOfMonth(int y, int m) =>
    (m != 2 || !isLeapYear(y)) ? _daysInMonthCommonYear[m - 1] : 29;

int lastDayOfMonth(int y, int m) => _lastDayOfMonth(y, m);

const List<int> _daysInMonthCommonYear = const [
  31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 // no reformat
];

bool isLeapYear(int y) => (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0);

// The following algorithms come from:
//    http://howardhinnant.github.io/date_algorithms.html
//
// The following abbreviations are used in the following code:
//   - ny: normalized year to March 1
//   - era: a 400 year period
//   - yoe: year of ero
//   - doy: day of year
//   - doe: day of Epoch
//   - eDay: epoch day
//   - nm: normalized month number - March is 1

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
int epochDay(int y, int m, int d,
    {int minYear = defaultMinYear, int maxYear = defaultMaxYear}) {
  int eDay;
  try {
    if (!_isValidDate(y, m, d, minYear: minYear, maxYear: maxYear)) return null;
    int ny = (m <= 2) ? y - 1 : y;
    int era = (ny >= 0 ? ny : ny - 399) ~/ 400;
    int yoe = ny - (era * 400); // [0, 399]
    int doy = ((153 * (m + ((m > 2) ? -3 : 9))) + 2) ~/ 5 + (d - 1); // [0, 365]
    int doe = (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy; // [0, 146096]
    eDay = (era * 146097) + doe - 719468;
  } on ParseError {
    return null;
  }
  return eDay;
}

/// Returns gregorian year/month/day in a [list<int>].
///
/// Preconditions:
///     z is number of days since 1970-01-01 and is in the range:
///         [epochFromDays(Int64.min), epochFromDays(Int64.max - 719468)]
List<int> epochDayToDate(int epochDay) {
  int z = epochDay + 719468;
  int era = ((z >= 0) ? z : z - 146096) ~/ 146097;
  int doe = z - (era * 146097);
  int yoe = _yearOfEpoch(doe);
  int nYear = yoe + (era * 400);
  int doy = doe - ((365 * yoe) + (yoe ~/ 4) - (yoe ~/ 100)); // [0, 365]
  int nm = ((5 * doy) + 2) ~/ 153; // [0, 11]
  int d = doy - (((153 * nm) + 2) ~/ 5) + 1; // [1, 31]
  int m = nm + ((nm < 10) ? 3 : -9); // [1, 12]
  int y = (m <= 2) ? nYear + 1 : nYear;
  var date = new List<int>(3);
  date[0] = y;
  date[1] = m;
  date[2] = d;
  return date;
}

/// Returns the Day in number of days since Epoch Zero Day. The returned
/// value is in the range: `0 <= yoe <= 399`.
/// yoe: year of Epoch
int _yearOfEpoch(int doe) =>
    ((doe - (doe ~/ 1460)) + (doe ~/ 36524) - (doe ~/ 146096)) ~/ 365;

int _yearFromEpochDay(int z) => epochDayToDate(z)[0];
int _monthFromEpochDay(int z) => epochDayToDate(z)[1];
int _dayFromEpochDay(int z) => epochDayToDate(z)[2];

/// Returns an [int] between 0 and 6, with 0 corresponding to Sunday.
int weekdayFromEpochDay(int z) =>
    (z >= -4) ? (z + 4).remainder(7) : (z + 5).remainder(7) + 6;

int weekdayDifference(int wd0, int wd1) {
  int n = wd0 - wd1;
  return n <= 6 ? n : n + 7;
}

int nextWeekday(int wd) => wd < 6 ? wd + 1 : 0;

int previousWeekday(int wd) => wd > 0 ? wd - 1 : 6;

bool datesEqual(List<int> date0, List<int> date1) =>
    date0.length == 3 &&
    date1.length == 3 &&
    date0[0] == date1[0] &&
    date0[1] == date1[1] &&
    date0[2] == date1[2];
