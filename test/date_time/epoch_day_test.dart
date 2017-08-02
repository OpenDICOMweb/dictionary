// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';

final Logger log =
    new Logger('date_time/utils_old.dart', Level.info);

void main() {
  int zeroDay = epochDay(1970, 1, 1);
  log.debug('zeroDay: $zeroDay');
  List<int> zeroDate = const <int>[1970, 1, 1];
  log.debug('zeroDayAsList: $zeroDate');

  assert(zeroDay == 0, "1970-01-01 is day 0");
  assert(datesEqual(epochDayToDate(0), zeroDate), "1970-01-01 is day 0");
  assert(weekdayFromEpochDay(epochDay(1970, 1, 1)) == 4,
      "1970-01-01 is a Thursday");

  assert(epochDay(1970, 1, 1) == 0);
  assert(epochDay(1969, 12, 31) == -1);
  assert(epochDay(1970, 1, 2) == 1);

  int wd = weekdayFromEpochDay(0);
  assert(wd == 4);

  dateBasicTest();
  leapYearTest();
  weekDayFromEpochDay();

  // int startYear = -1000000;
  dateUnitTest(-100000);
}

void dateBasicTest() {
  log.info('conversionTest...');
  Stopwatch watch = new Stopwatch();
  watch.start();
  for (int i = -100000; i < 100000; i++) {
    List<int> date = epochDayToDate(i);
    int y = date[0];
    int m = date[1];
    int d = date[2];
    int n = epochDay(y, m, d);
    log.debug2('$i, $n, ${i == n}');
    if (isLeapYear(y) && m == 2 && d == 29) {
      int last = lastDayOfMonth(y, m);
      assert(last == 29);
      log.debug2('$y-$m-$d');
    }
    assert(i == n);
  }
  watch.stop();
  log.info('  Elapsed: ${watch.elapsed}');
}

void dateUnitTest([int startYear = -10000, int endYear]) {
  log.info('Date Unit Test...');
  if (endYear == null) endYear = -startYear;
  log.info('  startYear: $startYear, endYear: $endYear');

  int eStart = epochDay(startYear, 1, 1, minYear: startYear, maxYear: endYear);
  log.info('  Epoch Start Day: $eStart');
  int eEnd = epochDay(endYear, 1, 1, minYear: startYear, maxYear: endYear);
  log.info('  Epoch End Day: $eEnd');

  int zeroDay = epochDay(1970, 1, 1);
  int wd = weekdayFromEpochDay(zeroDay);
  assert(wd == 4);

  Stopwatch watch = new Stopwatch();
  watch.start();
  int previousEpochDay = eStart - 1;
  assert(previousEpochDay < 0);
//  log.debug('  Previous Epoch Day: $previousEpochDay');
  int previousWeekDay = weekdayFromEpochDay(previousEpochDay);
//  log.debug('  Previous Week Day: $previousWeekDay');
  assert(0 <= previousWeekDay && previousWeekDay <= 6);

  // log.debug('\n******* Starting Loop');
  watch.start();
  for (int y = startYear; y <= endYear; y++) {
    if (y % 10000 == 0) log.info('    Year: $y: ${watch.elapsed}');
    for (int m = 1; m <= 12; m++) {
      int e = lastDayOfMonth(y, m);
      //    log.debug2('Month: $m, lastDay: $e');
      for (int d = 1; d <= e; d++) {
        int z = epochDay(y, m, d, minYear: startYear, maxYear: endYear);
        //      log.debug2('Day: $d z: $z');
        assert(previousEpochDay < z);
        assert(z == previousEpochDay + 1);

        List<int> date = epochDayToDate(z);
        assert(y == date[0]);
        assert(m == date[1]);
        assert(d == date[2]);
        int wd = weekdayFromEpochDay(z);
        assert(0 <= wd && wd <= 6);
        int nwd = nextWeekday(previousWeekDay);

        assert(wd == nwd, '$wd, $previousWeekDay: $nwd');
        assert(previousWeekDay == previousWeekday(wd));
        previousEpochDay = z;
        //     log.debug2('  previousEDay: $z');
        previousWeekDay = wd;
        //     log.debug2('  previousWeekDay: $wd');
      }
    }
  }
  watch.stop();
  log.info('  Elaped Time: ${watch.elapsed}');
  int begin = epochDay(startYear, 1, 1, minYear: startYear, maxYear: endYear);
  int end = epochDay(endYear, 12, 31, minYear: startYear, maxYear: endYear);
  log.info('  StartYear: $startYear, EndYear: $endYear, Total Years: '
      '${endYear - startYear}');
  log.info('  Tested ${-begin + end} dates');
}

void leapYearTest() {
  log.info('leapYearTest');
  Stopwatch watch = new Stopwatch();
  watch.start();
  for (int i = -100000; i < 100000; i++) {
    List<int> date = epochDayToDate(i);
    int y = date[0];
    int m = date[1];
    int d = date[2];
    int n = epochDay(y, m, d);
    // log.debug2('$i, $n, ${i == n}');
    if (isLeapYear(y) && m == 2 && d == 29) {
      int last = lastDayOfMonth(y, m);
      assert(last == 29);
      //    log.debug2('$y-$m-$d');
    }
    assert(i == n);
  }
  watch.stop();
  log.info('    Elapsed: ${watch.elapsed}');
}

void weekDayFromEpochDay() {
  Stopwatch watch = new Stopwatch();
  log.info('weekdayFromEpochDay0');
  log.debug(' weekDayFromDay: days >= 0');
  int zeroWeekDay = 4;

  watch.start();
  for (int i = 0; i < 100000; i++) {
    int day = (zeroWeekDay + i) % 7;
    int wd = weekdayFromEpochDay(i);

    //  log.debug('    $i: day: $day, wd: $wd');
    assert(day == wd);
  }
  log.info('    Elapesd: ${watch.elapsed}');

  log.debug('  weekDayFromDay: days <= 0');
  for (int i = 0; i > -100000; i--) {
    int wd = weekdayFromEpochDay(i);
    int day = (zeroWeekDay + i) % 7;
    //  log.debug('    $i: day: $day, wd: $wd');
    assert(day == wd);
  }
  watch.stop();
  log.info('    Elapesd: ${watch.elapsed}');
}
