// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/date_time/date.dart';
import 'package:test/test.dart';

final Logger log = new Logger('uint_test.dart', watermark: Severity.debug);

void main() {
  group('Date Tests', () {
    test('Good Dates', () {
      List<String> goodDcmDateList = ['19500718', '00000101', '19700101'];
      log.debug('Good Dates');
      for (String s in goodDcmDateList) {
        Date d = Date.parse(s);
        log.debug('  Date $s: $d');
      }
    });

    test('Bad Dates', () {
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

      log.debug1('Bad Dates');
      for (String s in badDcmDateList) {
        Date d = Date.parse(s);
        log.debug1('  Date: $s: $d');
      }
    });
  });
}
