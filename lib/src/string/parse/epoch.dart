// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

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

int microsecondsSinceEpoch(int y, int m, int d) {

}
