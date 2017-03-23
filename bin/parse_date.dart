// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';

final Logger log = new Logger('bin/parse_date.dart', watermark: Severity.debug);

void main(List<String> args) {
  //testIssues();
  //  testOneYearIssues();
  //  testYearLengthOnlyIssues();
  // testYearLengthAndCharIssues();
  // testGoodMonthLengthAndCharIssues();
  // testBadMonthLengthAndCharIssues();
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
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    var issues = new ParseIssues('Date', year);
    parseYear(year, 0);
    log.debug(issues.info);
  }
}

void testYearLengthAndCharIssues() {
  List<String> numbers = <String>['a', 'ab', 'abc', 'abcd', 'abced'];
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    var issues = new ParseIssues('Date', year);
    parseYear(year, 0);
    log.debug(issues.info);
  }
}

void testGoodMonthLengthAndCharIssues() {
  List<String> numbers = <String>['01', '02', '12'];
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    var issues = new ParseIssues('Date', year);
    parseMonth(year, 0);
    log.debug(issues.info);
  }
}

void testBadMonthLengthAndCharIssues() {
  List<String> numbers = <String>['0', '023', 'a', 'ab', 'abc'];
  for (int i = 0; i < numbers.length; i++) {
    var year = numbers[i];
    var issues = new ParseIssues('Date', year);
    parseMonth(year, 0);
    log.debug(issues.info);
  }
}

void testGoodDateIssues() {
  List<String> dates = <String>['10500718', '19000101', '20001212'];
  for (int i = 0; i < dates.length; i++) {
    var date = dates[i];
    var issues = new ParseIssues('Date', date);
    issues = Date.issues(date);
    log.debug(issues.info);
  }
}

void testBadDateIssues() {
  List<String> dates = <String>[
    '1950071', '190001010',  //bad length
    '2a0b1212', '1900Z1010', // good length bad char
    '2a0b121', '1900Z10100'  // bad length and bad char
  ];

  for (int i = 0; i < dates.length; i++) {
    var date = dates[i];
    var issues = new ParseIssues('Date', date);
    issues = Date.issues(date);
    log.debug(issues.info);
  }
}
