// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';

final Logger log = new Logger('bin/parse_date.dart', watermark: Severity.debug);

void main(List<String> args) {
  testIssues();
  testOneYearIssues();
  testYearLengthOnlyIssues();
  testYearLengthAndCharIssues();
  testGoodMonthLengthAndCharIssues();
  testBadMonthLengthAndCharIssues();
  testGoodDateIssues();
  testBadDateIssues();
}

void testIssues() {
  var issues = new ParseIssues('test', "");
  issues.add('first issue');
  issues.add('second issue');
  issues.add('third issue');
  issues.add('fourth issue');
  log.debug(issues.info);
}

void testOneYearIssues() {
  String year = "0bc";
  var issues = new ParseIssues('Date', year);
  parseYear(year, 0, issues);
  log.debug(issues.info);
}

void testYearLengthOnlyIssues() {
  List<String> numbers = <String>['0', '01', '012', '012345'];
  log.debug('testYearLengthOnlyIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new ParseIssues('Date', year);
    parseYear(year, 0, issues);
    log.debug('  ${issues.info}');
  }
}

void testYearLengthAndCharIssues() {
  List<String> numbers = <String>['a', 'ab', 'abc', 'abcd', 'abced'];
  log.debug('testYearLengthOnlyIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new ParseIssues('Date', year);
    parseYear(year, 0, issues);
    log.debug('  ${issues.info}');
  }
}

void testGoodMonthLengthAndCharIssues() {
  List<String> numbers = <String>['01', '02', '12'];
  log.debug('testGoodMonthLengthAndCharIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new ParseIssues('Date', year);
    parseYear(year, 0, issues);
    log.debug('  ${issues.info}');
  }
}

void testBadMonthLengthAndCharIssues() {
  List<String> numbers = <String>['0', '023', 'a', 'ab', 'abc'];
  log.debug('testBadMonthLengthAndCharIssues:');
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    log.debug('  year: $year');
    var issues = new ParseIssues('Date', year);
    log.debug('  ${issues.info}');
  }
}

void testGoodDateIssues() {
  List<String> dates = <String>['10500718', '19000101', '20001212'];
  log.debug('testGoodDateIssues:');
  for (int i = 0; i < dates.length; i++) {
    var date = dates[i];
    log.debug('  date: $date');
    var issues = new ParseIssues('Date', date);
    log.debug('  ${issues.info}');
  }
}

void testBadDateIssues() {
  List<String> dates = <String>[
    '1950071', '190001010', //bad length
    '2a0b1212', '1900Z1010', // good length bad char
    '2a0b121', '1900Z10100' // bad length and bad char
  ];

  log.debug('testBadDateIssues:');
  for (int i = 0; i < dates.length; i++) {
    var date = dates[i];
    log.debug('  date: $date');
    var issues = new ParseIssues('Date', date);
    log.debug('  ${issues.info}');
  }
}
