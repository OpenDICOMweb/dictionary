// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:test/test.dart';

final Logger log = new Logger('time_test.dart', Level.debug1);

void main() {
  const List<String> goodDcmTimes = const <String>[
    '000000',
    '190101',
    '235959',
    '010101.1',
    '010101.11',
    '010101.111',
    '010101.1111',
    '010101.11111',
    '010101.111111',
    '000000.0',
    '000000.00',
    '000000.000',
    '000000.0000',
    '000000.00000',
    '000000.000000',
    '00',
    '0000',
    '000000',
    '000000.1',
    '000000.111111',
    '01',
    '0101',
    '010101',
    '010101.1',
    '010101.111111',
    '10',
    '1010',
    '101010',
    '101010.1',
    '101010.111111',
    '22',
    '2222',
    '222222',
    '222222.1',
    '222222.111111',
    '23',
    '2323',
    '232323',
    '232323.1',
    '232323.111111',
    '23',
    '2359',
    '235959',
    '235959.1',
    '235959.111111',
  ];

  group('Time Tests', () {
    test('Good parseDcmTime', () {
      log.debug('Good parseDcmTime');
      for (String s in goodDcmTimes) {
        log.debug('  parseDcmTime: $s');
        int us = parseDcmTime(s);
        log.debug('    parseDcmTime: $us');
        expect(us is int, true);
      }
    });

    test('Good parseDcmTime', () {
      log.debug('Good isValidDcmTime');
      for (String s in goodDcmTimes) {
        log.debug('  isValidDcmTime: $s');
        bool v = isValidDcmTime(s);
        log.debug('    isValidDcmTime: "$s", $v');
        expect(v, true);
      }
    });

    test('Good getDcmTimeIssues', () {
      for (String s in goodDcmTimes) {
        log.debug('  getDcmTimeIssues: $s');
        var issues = new ParseIssues('getDcmTimeIssues', s);
        getDcmTimeIssues(s, issues: issues);
        log.debug('    getDcmTimeIssues: "$s", issues: $issues');
        expect(issues.isEmpty, true);
      }
    });

    test('Good Time.parse', () {
      log.debug('Good Times');
      for (String s in goodDcmTimes) {
        log.debug('Time: $s');
        Time time = Time.parse(s);
        log.debug('  Time $s: $time');
        log.debug('  Milliseconds: ${time.millisecond}');
        log.debug('  Microseconds: ${time.microsecond}');
        log.debug('  Fraction: ${time.fraction}');
        log.debug('  ms: ${time.f}');
        log.debug('  us: ${time.f}');
        expect(time, isNotNull);
      }
    });

    test('Good Time.parse', () {
      log.debug('Good Times.isValid');
      for (String s in goodDcmTimes) {
        log.debug('Times.isValid: $s');
        bool v = Time.isValidString(s);
        log.debug('  Times.isValid $s: $v');
        expect(v, true);
      }
    });

    test('Good Time.issues', () {
      for (String s in goodDcmTimes) {
        log.debug('  Time.issues: $s');
        var issues = new ParseIssues('Time.issues', s);
        getDcmTimeIssues(s, issues: issues);
        log.debug('    Time.issues: "$s", issues: $issues');
        expect(issues.isEmpty, true);
      }
    });

    test('Good Time in Microseconds', () {
      for (String s in goodDcmTimes) {
        log.debug('  parseDcmTime: "$s"');
        int us = parseDcmTime(s, min: 2, max: 13);
        if (us == null) throw "Bad Value in Good Time in Microseconds";
        expect(us, isNotNull);
        log.debug('    parseDcmTime "$s": us: $us');
      }
    });

    //Urgent: fix
    test('Good Time as Time', () {
      for (String s in goodDcmTimes) {
        log.debug('  Time.parse: $s');
        Time time = Time.parse(s);
        log.debug('    Time: $time');
        if (time == null) throw "Bad Value in Good Time in Microseconds";
        expect(time, isNotNull);
        log.debug('    Time.parse: "$s": $time');
        log.debug1('    Milliseconds: ${time.inMilliseconds}');
        log.debug1('    Microseconds: ${time.inMicroseconds}');
      }
    });

    test('Good Time to microseconds', () {
      for (String s in goodDcmTimes) {
        log.debug('  isValidDcmTime: $s');
        bool v = isValidDcmTime(s, min: 2, max: 13);
        expect(v, true);
        log.debug('    isValidDcmTime: "$s", us: $v');
      }
    });

    test('Good Time to Time', () {
      log.debug('Good Times');
      for (String s in goodDcmTimes) {
        log.debug('  Time: $s');
        Time time = Time.parse(s);
        log.debug('    Time: $time');
        if (time == null) {
          var issues = new ParseIssues('Good Time to Time', s);
          getDcmTimeIssues(s, issues: issues, min: 2, max: 13);
          log.debug('    Issues: $issues');
        }
        expect(time, isNotNull);
        log.debug('  Time "$s": $time');
        log.debug('    Hours: ${time.hour}');
        log.debug('    Minutes: ${time.minute}');
        log.debug('    Seconds: ${time.second}');
        log.debug1('    Milliseconds: ${time.millisecond}');
        log.debug1('    Microseconds: ${time.microsecond}');
        log.debug1('    Fraction: ${time.fraction}');
      }
    });
  });

  group('Bad DCM Time tests', () {
    List<String> badDcmTimes = [
      '241318', // bad hour
      '006132', // bad minute
      '006060', // bad minute and second
      '000060', // bad month and day
      '-00101', // bad character in hour
      'a00101', // bad character in hour
      '0a0101', // bad character in hour
      'ad0101', // bad characters in hour
      '19a101', // bad character in minute
      '190b01', // bad character in minute
      '1901a1', // bad character in second
      '19011a', // bad character in second
      '999999.9', '999999.99', '999999.999',
      '999999.9999', '999999.99999', '999999.999999', //don't format
      //TODO: test fractions
    ];

    test('parseDcmTime with Bad Times', () {
      for (String s in badDcmTimes) {
        log.debug('  parseDcmTime: $s');
        int us = parseDcmTime(s, min: 2, max: 13);
        expect(us == null, true);
        log.debug('    parseDcmTime: "$s": us: $us');
      }
    });

    test('Time.parse with Bad Times', () {
      for (String s in badDcmTimes) {
        log.debug('  Time.parse: $s');
        Time time = Time.parse(s);
        expect(time == null, true);
        log.debug('    Time.parse: "$s": time: $time');
      }
    });

    test('isValidDcmTime with Bad Times', () {
      for (String s in badDcmTimes) {
        log.debug('  isValidDcmTime: $s');
        bool value = isValidDcmTime(s, min: 2, max: 13);
        expect(value == false, true);
        log.debug('    isValidDcmTime: "$s": isValid: $value');
      }
    });

    test('Time.isValidString with Bad Times', () {
      for (String s in badDcmTimes) {
        log.debug('  Time.isValidString: $s');
        bool value = Time.isValidString(s);
        expect(value == false, true);
        log.debug('    Time.isValidString: "$s": isValid: $value');
      }
    });

    test('getDcmTimeIssues with Bad Times', () {
      for (String s in badDcmTimes) {
        log.debug('  getDcmTimeIssues: $s');
        var issues = new ParseIssues('Bad uSeconds', s);
        getDcmTimeIssues(s, issues: issues, min: 2, max: 13);
        log.debug('    Issues(${issues.isEmpty}: ${issues.info}');
        expect(issues.isEmpty, false);
        log.debug('    getDcmTimeIssues: "$s": $issues');
      }
    });

    test('Bad Times as Time', () {
      log.debug('Bad Times as Time');
      for (String s in badDcmTimes) {
        log.debug('Time: $s');
        Time time = Time.parse(s);
        expect(time == null, true);
        log.debug('  Time: $s: $time');
      }
    });

    test('Good and Bad Time for isValidTimeString', () {
      for (String s in goodDcmTimes) {
        expect(Time.isValidString(s), true);
      }
      for (String s in badDcmTimes) {
        expect(Time.isValidString(s), false);
      }
    });

    test('Good and Bad Time for isValid', () {
      for (String s in goodDcmTimes) {
        expect(Time.isValidString(s), true);
      }
      for (String s in badDcmTimes) {
        expect(Time.isValidString(s), false);
      }
    });
  });

  group('Other Time Tests', () {
    List<String> goodTimes = [
      "12",
      "1212",
      "121212",
      "010101.99",
      "121212.999",
      "101010.9999"
    ];

    test("Good Time Strings", () {
      for (int i = 0; i < goodTimes.length; i++) {
        var s = goodTimes[i];
        int us = parseDcmTime(s, min: 2, max: 13);
        expect(us is int, true);
      }
    });

    List<String> badTimes = [
      "",
      "1",
      "123",
      "12345",
      "10101.99",
      "a21212.999",
      "101010.b999"
    ];

    test("Bad Time Strings", () {
      for (int i = 0; i < badTimes.length; i++) {
        var s = badTimes[i];
        log.debug('t: "$s"');
        int us = parseDcmTime(s, min: 2, max: 13);
        log.debug('Microseconds: $us');
        expect(us == null, true);
      }
    });
  });
}
