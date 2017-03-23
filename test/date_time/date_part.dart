// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:test/test.dart';

final Logger log =
new Logger('date_time/utils_old.dart', watermark: Severity.debug);

void main() {

  //Good dates
  List<String> goodDcmDateList = ['19500718', '00000101', '19700101'];

  group('Test Date Part of String', () {
    
    test('parseDcmDateString: gool full date', () {
      for(String s in goodDcmDateList) {
        DateTime value = DateTime.parse(s);
        int epochDay = parseDcmDate(s, 0, s.length, 8, 8, null, false);
        log.debug('string: "$s"');
        log.debug('  value: $value');
        log.debug('   date: $epochDay');
        expect(epochDay, equals(value));
      }
    });

    test('isValidDcmDateString: good full date', () {
      for(String s in goodDcmDateList) {
        log.debug('string: "$s"');
    //    DateTime value = DateTime.parse(s);
        bool date = parseDcmDate(s, 0, s.length, 8, 8, null, true);
        log.debug('  valid: $date');
        expect(date, true);
      }
    });

    test('getDcmDateIssues: good full date', () {
      for(String s in goodDcmDateList) {
        log.debug('string: "$s"');
        var issues = new ParseIssues("getDcmDateIssues", s);
        issues = parseDcmDate(s,  0, s.length, 8, 8, issues, true);
        log.debug('  issues: "$issues"');
        expect(issues, equals(""));
      }
    });

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

    test('parseDcmDateString: Bad Dates', () {
      log.debug1('Bad Dates');
      for (String s in badDcmDateList) {
        log.debug('string: "$s"');
 //       DateTime value = DateTime.parse(s);
        int epochDay = parseDcmDate(s, 0, s.length, 8, 8, null, false);

 //       log.debug(' value: $value');
        log.debug('  date: $epochDay');
        expect(epochDay == null, true);
        log.debug1('  Date: $s: $epochDay');
      }
    });

    test('isValidDcmDate: Bad full date', () {
      log.debug1('Bad Dates');
      for (String s in badDcmDateList) {
        log.debug('string: "$s"');
        //       DateTime value = DateTime.parse(s);
        int epochDay = parseDcmDate(s, 0, s.length, 8, 8, null, true);

        //       log.debug(' value: $value');
        log.debug('  date: $epochDay');
        expect(epochDay == null, true);
        log.debug1('  Date: $s: $epochDay');
      }
    });

    test('getDcmDateIssues: Bad full date', () {
      for(String s in badDcmDateList) {
        log.debug('string: "$s"');
        ParseIssues issues = parseDcmDate(s, 0, s.length, 8, 8, null, false);
        log.debug('  issues: "$issues"');
        expect(issues, equals(""));
      }
    });
  });


}