// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/string.dart';
import 'package:test/test.dart';

void main() {

  //Good dates
  List<String> goodDcmDateList = ['19500718', '00000101', '19700101'];

  group('Test Date Part of String', () {
    
    test('parseDcmDateString: gool full date', () {
      for(String s in goodDcmDateList) {
        DateTime value = DateTime.parse(s);
        DateTime date = parseDcmDateString(s, 0, s.length);
        log.debug('string: "$s"');
        log.debug('  value: $value');
        log.debug('   date: $date');
        expect(date, equals(value));
      }
    });

    test('isValidDcmDateString: good full date', () {
      for(String s in goodDcmDateList) {
        log.debug('string: "$s"');
        DateTime value = DateTime.parse(s);
        bool date = isValidDcmDateString(s, 0, s.length);
        log.debug('  valid: $date');
        expect(date, true);
      }
    });

    test('getDcmDateIssues: good full date', () {
      for(String s in goodDcmDateList) {
        log.debug('string: "$s"');
        DateTime value = DateTime.parse(s);
        String issues = getDcmDateIssues(s, 0, s.length);
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
        DateTime date = parseDcmDateString(s, 0, s.length);

 //       log.debug(' value: $value');
        log.debug('  date: $date');
        expect(date == null, true);
        log.debug1('  Date: $s: $date');
      }
    });

    test('isValidDcmDate: Bad full date', () {
      log.debug1('Bad Dates');
      for (String s in badDcmDateList) {
        log.debug('string: "$s"');
        //       DateTime value = DateTime.parse(s);
        DateTime date = parseDcmDateString(s, 0, s.length);

        //       log.debug(' value: $value');
        log.debug('  date: $date');
        expect(date == null, true);
        log.debug1('  Date: $s: $date');
      }
    });

    test('getDcmDateIssues: Bad full date', () {
      for(String s in badDcmDateList) {
        log.debug('string: "$s"');
        String issues = getDcmDateIssues(s, 0, s.length);
        log.debug('  issues: "$issues"');
        expect(issues, equals(""));
      }
    });
  });


}