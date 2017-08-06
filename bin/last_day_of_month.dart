// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/date_time/date.dart';

final Logger log = new Logger('date_time/utils_old.dart', Level.debug);

void main(List<String> args) {
  epochDayTest();
}

void epochDayTest() {
  int startDay = -1;
  int endDay = 1;

  int y = 1970;
  for (int i = 1; i <= 24; i++) {
    int mp = (i + 9) % 12;
    log.debug('m: $i, mp: $mp');
    int yp = y - (mp ~/ 10);
    log.debug('yp: $yp');
  }
  for (int i = startDay; i <= endDay; i++) {
    int dayZero = epochDay(1970, 1, 1);
    if (dayZero != 0) throw 'Day Zero error: $dayZero';
    int dayMinusOne = epochDay(1969, 12, 31);
    if (dayMinusOne != -1) throw 'Day MinusOne error: $dayZero';
    int dayPlusOne = epochDay(1970, 1, 1);
    if (dayPlusOne != 0) throw 'Day PlusOne error: $dayZero';
  }
  log.debug('Success');
}

void weekDayFromDayTest() {
  log.debug('v: ${(-10 + 5) % 7}');
  log.debug('v: ${(-10 + 5) % 7}');
  for (int eDay = -1000000; eDay < 1000000; eDay++) {
    int wd = weekdayFromEpochDay(eDay);
    log.debug('$eDay: weekDay: $wd');
    if (wd < 0 || wd > 6) throw 'bad weekday: $wd';
  }
}

void lastDayOfMonthTest() {
  for (int y = 1970; y < 1973; y++) {
    for (int m = 1; m < 13; m++) {
      int last = lastDayOfMonth(y, m);
      log.debug('$y: $m: last: $last');
    }
  }
}
