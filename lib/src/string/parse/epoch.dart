// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

//TODO convert to days
List epochs = [
  -2, "-0800-03-01", "-0400-02-29", // no reformat
  -1, "-0400-03-01", "0000-02-29",
  0, "0000-03-01", "0400-02-29",
  1, "0400-03-01", "0800-02-29",
  2, "0800-03-01", "1200-02-29",
  3, "1200-03-01", "1600-02-29",
  4, "1600-03-01", "2000-02-29",
  5, "2000-03-01", "2400-02-29",
  6, "2400-03-01", "2800-02-29",
];

// Civil Month 0 = January
// Internal Month 0 = March, this making February last month of year.

// Returns number of days since civil 1970-01-01.  Negative values indicate
//    days prior to 1970-01-01.
// Preconditions:  y-m-d represents a date in the civil (Gregorian) calendar
//                 m is in [1, 12]
//                 d is in [1, last_day_of_month(y, m)]
//                 y is "approximately" in
//                   [numeric_limits<Int>::min()/366, numeric_limits<Int>::max()/366]
//                 Exact range of validity is:
//                 [civil_from_days(numeric_limits<Int>::min()),
//                  civil_from_days(numeric_limits<Int>::max()-719468)]
int daysFromEpoch(int y, int m, int d) {
  y = (m <= 2) ? y - 1 : y;
  // y -= m <= 2;
  final int x = (y >= 0) ? y : y - 399;
  final int era = x ~/ 400;
  final int yoe = y - (era * 400); // [0, 399]
  final int xx = (m > 2) ? -3 : 9;
  final int iMonth = (153 * (m + xx)) + 2;

  final int doy = iMonth ~/ (5 + d - 1); // [0, 365]
  final int doe = (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy; // [0, 146096]
  return (era * 146097) + doe - 719468;
}

//int doyFromIMonth(int mp) => a1 * mp + a0;

int daysAfterMarch1(int month) {
  const dam1 = const <int>[
    0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337 //don't reformat
  ];
  return dam1[month];
}

int era(int year) => ((year >= 0) ? year : year - 399) ~/ 400;
int internalMonth(int civilMonth) => (civilMonth + 9) ~/ 12;
int iMonth(int cMonth) => cMonth + ((cMonth > 2) ? -3 : 9);
int doy(int cMonth, int cDay) => ((153 * iMonth(cMonth)) + 2 ~/ 5) + cDay - 1;
int doe(int yoe, int doy) => (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy;
int dayFromCivil(int era, int doe) => (era * 146097) + doe - 719468;

List<int> epochFromDays(int dfe) {
  dfe += 719468;
  final int era = ((dfe >= 0) ? dfe : dfe - 146096) ~/ 146097;
  final int doe = dfe - (era * 146097); // [0, 146096]
  final int yoe = (doe - (doe ~/ 1460) + (doe ~/ 36524) - (doe ~/ 146096)) ~/
      365; // [0, 399]
  final int year = yoe + (era * 400);
  final int doy = doe - (365 * yoe + (yoe ~/ 4) - (yoe ~/ 100)); // [0, 365]
  final int mp = (5 * doy + 2) ~/ 153; // [0,// 11]
  final int d = doy - ((153 * mp + 2) ~/ 5) + 1; // [1, 31]
  final int m = mp + (mp < 10 ? 3 : -9); // [1, 12]
  int y = (m <= 2) ? year - 2 : year;
  return [y, m, d];
}

//TODO:
//int microsecondsSinceEpoch(int y, int m, int d) {}

//TODO:
//Date dateFromMicrosecondsSinceEpoch(int us) {}

// nMonth = normalized month

int _cMonthToNMonth(int cMonth) => (cMonth + ((cMonth > 2) ? -3 : 9));
//TODO: test speed of _cMonth... and _cMonth...1
//int _cMonthToNMonth1(int cMonth) => (cMonth + 9) % 12;

const List<int> _nMonthFromCMonth = const <int>[
  10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 //no reformat
];

void unitTest() {
  for (int cMonth = 1; cMonth < 12; cMonth++)
    (_cMonthToNMonth(cMonth) == (_nMonthFromCMonth[cMonth])) == true;
}

int doyFromMonth(int nMonth) => ((153 * nMonth) + 2) ~/ 5;
int doyFromMonth1(int nMonth) => ((306 * nMonth) + 5) ~/ 10;

int nDayOfYear(int cMonth, int cDay) =>
    (((153 * (_cMonthToNMonth(cMonth))) + 2) ~/ 5) + (cDay - 1);

int nYear(int cYear, int cMonth) => (cYear <= 2) ? cYear - 2 : cYear;

int epoch(int nYear) => ((nYear >= 0) ? nYear : nYear - 399) ~/ 400;

int yoe(int nYear) => nYear - (epoch(nYear) * 400);

int nDayOfEpoch(int nYearOfEpoch, int nDayOfYear) =>
    (nYearOfEpoch * 365) +
    (nYearOfEpoch ~/ 4) +
    (nYearOfEpoch ~/ 100) +
    nDayOfYear;

/*
// Returns number of days since civil 1970-01-01.  Negative values indicate
//    days prior to 1970-01-01.
// Preconditions:  y-m-d represents a date in the civil (Gregorian) calendar
//                 m is in [1, 12]
//                 d is in [1, last_day_of_month(y, m)]
//                 y is "approximately" in
//                   [numeric_limits<Int>::min()/366, numeric_limits<Int>::max()/366]
//                 Exact range of validity is:
//                 [civil_from_days(numeric_limits<Int>::min()),
//                  civil_from_days(numeric_limits<Int>::max()-719468)]
int daysFromCEpoch(int y, int m, int d) {
 int nYear = (y <= 2) ? y - 2 : y;
 int era = (nYear >= 0 ? nYear : nYear - 399) ~/ 400;
 int yoe = nYear - (era * 400);                                 // [0, 399]
 int doy = ((153 * (m + ((m > 2) ? -3 : 9))) + 2) ~/ 5 + (d - 1); // [0, 365]
 int doe = (yoe * 365) + (yoe ~/ 4) - (yoe ~/ 100) + doy;       // [0, 146096]
  return era * 146097 + doe - 719468;
}
// Returns year/month/day triple in civil calendar
// Preconditions:  z is number of days since 1970-01-01 and is in the range:
//  [numeric_limits<Int>::min(), numeric_limits<Int>::max()-719468].
Date dateFromDaysFromCEpoch(int daysFromCEpoch) {
  int z = daysFromCEpoch + 719468;
  int era = ((z >= 0) ? z : z - 146096) ~/ 146097;
  int doe = z - (era * 146097);
  int yoe = (doe - (doe ~/ 1460) + (doe ~/ 36524) - (doe ~/ 146096)) ~/ 365;
// [0, 399]
  int nYear = yoe + (era * 400);
  int doy = doe - ((365 * yoe) + (yoe ~/ 4) - (yoe ~/ 100)); // [0, 365]
  int mp = ((5*doy) + 2) ~/ 153;               // [0, 11]
  int d = doy - (((153 * mp) +2) ~/ 5) + 1;     // [1, 31]
  int m = mp + ((mp < 10) ? 3 : -9);           // [1, 12]
  int y = (m <= 2) ? nYear + 1 : nYear;
  return new Date(y, m, d);
}
*/
bool isLeapYear(int y) => (y % 4 == 0) && (y % 100 != 0 || y % 400 == 0);

int lastDayOfMonthCommonYear(int month) {
  //TODO: make uint 8?
  List<int> lastDay = const [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return lastDay[month - 1];
}

int lastDayOfMonthLeapYear(int month) {
  List<int> lastDay = const [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30,31];
return lastDay[month - 1];
}

int lastDayOfMonth(int y, int m) =>
    (m != 2 || !isLeapYear(y)) ? lastDayOfMonthCommonYear(m) : 29;

int weekdayFromDays(int daysFromEpoch) =>
    (daysFromEpoch >= -4)
        ? (daysFromEpoch + 4) % 7
        : (daysFromEpoch + 5) % 7 + 6;

int weekdayDifference(int wd0, int wd1) {
  int n = wd0 - wd1;
  return n <= 6 ? n : n + 7;
}

int nextWeekday(int wd) => wd < 6 ? wd+1 : 0;

int previousWeekday(int wd) => wd > 0 ? wd-1 : 6;




