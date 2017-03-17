// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/date_time/date.dart';
import 'package:dictionary/src/date_time/dcm_date_time.dart';
import 'package:dictionary/src/date_time/time.dart';
import 'package:dictionary/src/string/dcm_parse.dart';
import 'package:test/test.dart';

final Logger log = new Logger('uint_test.dart', watermark: Severity.info);

void main() {
  //Good dates
  List<String> goodDcmDateList = ['19500718', '00000101', '19700101'];

  //Bad dates
  List<String> badDcmDateList = [
    '19501318', // bad month
    '19501032', // bad day
    '00000032', // bad month and day
    '00000000', // bad month and day
    '-9700101', // bad character in year
    '1b700101', // bad character in year
    '19c00101', // bad character in year
    '197d0101', // bad character in year
    '1970a101', // bad character in month
    '19700b01', // bad character in month
    '197001a1', // bad character in day
    '1970011a', // bad character in day
  ];

  group('Date Tests', () {
    test('Good Dates', () {
      log.debug('Good Dates');
      for (String s in goodDcmDateList) {
        Date d = Date.parse(s);
        expect(d, isNotNull);
        log.debug('  Date $s: $d');
      }
    });

    test('Bad Dates', () {
      log.debug1('Bad Dates');
      for (String s in badDcmDateList) {
        Date d = Date.parse(s);
        expect(d == null, true);
        log.debug1('  Date: $s: $d');
      }
    });
  });

  group('isValidDateString', () {
    test('isValidDateString Good and Bad dates', () {
      for (String s in goodDcmDateList) {
        expect(Date.isValidDateString(s), true);
      }

      for (String s in badDcmDateList) {
        expect(Date.isValidDateString(s), false);
      }
    });
  });

  group('isValid', () {
    test('isValid Good and Bad dates', () {
      for (String s in goodDcmDateList) {
        var dt = new Date.fromDateTime(parseDcmDateString(s, 0, s.length));
        expect(dt.isValid(s), true);
      }

      for (String s in badDcmDateList) {
        var dt = new Date.fromDateTime(parseDcmDateString(s, 0, s.length));
        expect(dt.isValid(s), false);
      }
    });

    test('issues', () {
      var dt = new Date(2016, 05, 15);
      for (String s in goodDcmDateList) {
        expect(dt.isValid(s), true);
      }

      for (String s in badDcmDateList) {
        expect(dt.isValid(s), false);
      }
    });

    test('add and subtract', () {
      String s = '19500718';
      var dt = new Date.fromDateTime(parseDcmDateString(s, 0, s.length));
      log.debug(dt.date);
      DcmDateTime ddt1 = dt.add(new Time(hours: 4, minutes: 20, seconds: 56));
      log.debug(ddt1.hour);
      log.debug(ddt1.minute);
      log.debug(ddt1.second);
      DcmDateTime ddt2 =
          dt.subtract(new Time(hours: 2, minutes: 5, seconds: 26));
      log.debug(ddt2.hour);
      log.debug(ddt2.minute);
      log.debug(ddt2.second);
    });
  });
}
