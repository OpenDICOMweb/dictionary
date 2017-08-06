// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:test/test.dart';

final Logger log = new Logger('uint_test.dart', Level.debug);

void main() {
  List<String> goodDcmDateTimeList = [
    '19500718105630',
    '00000101010101',
    '19700101000000',
    '20161229000000',
    '19991025235959',
    '20170223122334.111111',
    '20120228105630', // leap year
    '20080229105630', // leap year
    '20160229105630', // leap year
    '20200125105630', // leap year
    '20240229105630', // leap year
  ];

  List<String> badDcmDateTimeList = [
    '19501318105630', //bad months
    '19501032105630', // bad day
    '00000000000000', // bad month and day
    '19501032105660', // bad day and second
    '00000032240212', // bad month and day and hour
    '20161229006100', // bad minute
    '-9700101226a22', // bad character in year minute
    '1b7001012a1045', // bad character in year and hour
    '19c001012210a2', // bad character in year and sec
    '197d0101105630', // bad character in year
    '1970a101105630', // bad character in month
    '19700b01105630', // bad character in month
    '197001a1105630', // bad character in day
    '1970011a105630', // bad character in day
    '20120230105630', // bad day in leap year
    '20160231105630', // bad day in leap year
    '20130229105630', // bad day in year
    '20230229105630', // bad day in year
    '20210229105630', // bad day in year
  ];
  group("DcmDateTime", () {
    test("Good DcmDateTime", () {
      //DcmDateTime d=new DcmDateTime(1505,12,4);
      log.debug("Good DcmDateTime");
      for (String dt in goodDcmDateTimeList) {
        log.debug("  date and time:$dt");
        DcmDateTime datetime = DcmDateTime.parse(dt);
        expect(datetime, isNotNull);
      }
    });
    test("Bad DcmDateTime", () {
      //DcmDateTime datetim=DcmDateTime.parse(dt);
      log.debug("Bad DcmDateTime");
      for (String dt in badDcmDateTimeList) {
        log.debug('    "$dt"');
        DcmDateTime dateTime = DcmDateTime.parse(dt);
        log.debug1('    "$dt": $dateTime');
        expect(dateTime == null, true);
      }
    });
  });

  group('isValid', () {
    test('isValid Good and Bad DcmDateTime', () {
      for (String dt in goodDcmDateTimeList) {
        DcmDateTime dateTime = DcmDateTime.parse(dt);
        expect(dateTime is DcmDateTime, true);
        expect(DcmDateTime.isValidString(dt), true);
      }

      for (String dt in badDcmDateTimeList) {
        DcmDateTime dateTime = DcmDateTime.parse(dt);
        expect(dateTime, isNull);
        expect(DcmDateTime.isValidString(dt), false);
      }
    });

    test('issues', () {
      //     var dt = new DcmDateTime(2016, 05, 15, 04, 22, 14);
      for (String s in goodDcmDateTimeList) {
        ParseIssues issues = DcmDateTime.issues(s);
        expect(issues.isEmpty, true);
      }
    });

    test('parseTimeZone', () {
      String tzValid = '-1200';
      expect(parseTimeZone(tzValid) == (-1 * ((12 * 60) + 00)), true);

      tzValid = '+1330';
      expect(parseTimeZone(tzValid) == (((13 * 60) + 30)), true);

      tzValid = '+1445';
      expect(parseTimeZone(tzValid) == (((14 * 60) + 45)), false);

      String tzInValid = '1200';
      //  expect(() => parseTimeZone(tzInValid),
      //      throwsA(new isInstanceOf<Error>()));
      expect(parseTimeZone(tzInValid), isNull);

      tzInValid = '-1240';
      //  expect(() => parseTimeZone(tzInValid),
      //      throwsA(new isInstanceOf<Error>()));
      expect(parseTimeZone(tzInValid), isNull);

      tzInValid = '1500';
      //   expect(() => parseTimeZone(tzInValid),
      //       throwsA(new isInstanceOf<Error>()));
      expect(parseTimeZone(tzInValid), isNull);

      tzInValid = '-1300+';
      //   expect(() => parseTimeZone(tzInValid),
      //       throwsA(new isInstanceOf<Error>()));
      expect(parseTimeZone(tzInValid), isNull);
    });
  });
}
