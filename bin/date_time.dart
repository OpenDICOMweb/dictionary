// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/date_time/date.dart';
import 'package:dictionary/src/date_time/time.dart';
import 'package:dictionary/src/string/dcm_parse.dart';

final Logger log = new Logger('DateTimeTests', watermark: Severity.debug);
void main() {
  goodDcmTimes();
  badDcmTimes();
  /*
  parseFractionTest();

  goodDcmDates();
  badDcmDates();
  badDcmTimes();

  print('Test Dates');
  var s = "230718.1234";
  Time t = parseDcmTimeString(s, 0, s.length);
  print('  Time "$s": $t');
  */
}
void parseFractionTest() {
  List<String> goodFractions = <String>[
    ".0", ".1", ".90", ".101", ".9091", ".10987", ".123456",
    ".987654", ".000000", ".000001", ".100000", ".999999",
    ".012345", ".199990" // Don't reformat.
  ];

  print('Good Fractions');
  for (String s in goodFractions) {
    int f = parseFraction(s, 0, s.length);
    log.debug('    $s: $f');
  }
}
void goodDcmDates() {
  List<String> goodDcmDateList = ['19500718', '00000101', '19700101'];

  print('Good Dates');
  for (String s in goodDcmDateList) {
    Date d = Date.parse(s);
    print('  Date $s: $d');
  }
}

void badDcmDates() {
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

  print('Bad Dates');
  for (String s in badDcmDateList) {
    Date d = Date.parse(s);
    print('  Date: $s: $d');
  }
}

void goodDcmTimes() {
  List<String> goodDcmTimeList = [
    '230718', '000000', '190101', '235959',
    '010101.1', '010101.11', '010101.111',
    '010101.1111', '010101.11111', '010101.111111',
    '000000.0', '000000.00', '000000.000',
    '000000.0000', '000000.00000', '000000.000000',
    '999999.9', '999999.99', '999999.999',
    '999999.9999', '999999.99999', '999999.999999',
    '00', '0000', '000000', '000000.1', '000000.111111',
    '01', '0101', '010101', '010101.1', '010101.111111',
    '10', '1010', '101010', '101010.1', '101010.111111',
    '22', '2222', '222222', '222222.1', '222222.111111',
    '23', '2323', '232323', '232323.1', '232323.111111',
    '23', '2359', '235959', '235959.1', '235959.111111',
  ];

  print('Good Times');
  for (String s in goodDcmTimeList) {
    print('Time: $s');
    Time t = Time.parse(s);
    print('  Time $s: $t');
    print('  Milliseconds: ${t.milliseconds}');
    print('  Microseconds: ${t.microseconds}');
    print('  Fraction: ${t.fraction}');
    print('  ms: ${t.f}');
    print('  us: ${t.f}');
  }
}

void badDcmTimes() {
  List<String> badDcmTimeList = [
    '241318', // bad hour
    '006132', // bad minute
    '006161', // bad minute and second
    '000000', // bad month and day
    '-00101', // bad character in hour
    'a00101', // bad character in hour
    '0a0101', // bad character in hour
    'ad0101', // bad characters in hour
    '19a101', // bad character in minute
    '190b01', // bad character in minute
    '1901a1', // bad character in second
    '19011a', // bad character in second
  ];

  print('Bad Dates');
  for (String s in badDcmTimeList) {
    Time t= Time.parse(s);
    print('  Date: $s: $t');
  }
}