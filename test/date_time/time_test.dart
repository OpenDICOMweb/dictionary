// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/date_time/time.dart';
import 'package:dictionary/src/string/dcm_parse.dart';
import 'package:test/test.dart';

final Logger log = new Logger('time_test.dart', watermark: Severity.debug);

void main() {
  group('Time Tests', () {
    List<String> goodDcmTimes = [
      '230718',
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

    test('Good Time as Duration', () {
      log.debug('Good Times');
      for (String s in goodDcmTimes) {
        log.debug('\n  Time: $s');
        Duration t = parseDcmTimeString(s, 0, s.length);
        log.debug('  Time t: $t');
        if (t == null) {
          var issues = getDcmTimeStringIssues(s, 0, s.length);
          log.debug('Issues: $issues');
        }
        expect(t, isNotNull);
        log.debug('  Time $s: $t');
        log.debug1('  Milliseconds: ${t.inMilliseconds}');
        log.debug1('  Microseconds: ${t.inMicroseconds}');
      }
    });

    test('Good Time as Dcm Time', () {
      log.debug('Good Times');
      for (String s in goodDcmTimes) {
        log.debug('\n  Time: $s');
        Time t = new Time.fromDuration(parseDcmTimeString(s, 0, s.length));
        log.debug('  Time t: $t');
        if (t == null) {
          var issues = getDcmTimeStringIssues(s, 0, s.length);
          log.debug('Issues: $issues');
        }
        expect(t, isNotNull);
        log.debug('  Time $s: $t');
        log.debug1('  Milliseconds: ${t.milliseconds}');
        log.debug1('  Microseconds: ${t.microseconds}');
        log.debug1('  Fraction: ${t.fraction}');
        log.debug1('  ms: ${t.f}');
        log.debug1('  us: ${t.f}');
      }
    });

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

    test('Bad Times as Duration', () {
      log.debug('Bad Times as Duration');
      for (String s in badDcmTimes) {
        log.debug('Time: $s');
        Duration t = parseDcmTimeString(s, 0, s.length);
        expect(t == null, true);
        log.debug('  Time: $s: $t');
      }
    });

    test('Bad Times as Time', () {
      log.debug('Bad Times as Time');
      for (String s in badDcmTimes) {
        log.debug('Time: $s');
        Time t = Time.parse(s);
        expect(t == null, true);
        log.debug('  Time: $s: $t');
      }
    });

    test('Good and Bad Time for isValidTimeString', () {
      for (String s in goodDcmTimes) {
        expect(Time.isValidTimeString(s), true);
      }
      for (String s in badDcmTimes) {
        expect(Time.isValidTimeString(s), false);
      }
    });

    test('Good and Bad Time for isValid', () {
      String s = '235959.1';
      Time t = new Time.fromDuration(parseDcmTimeString(s, 0, s.length));
      for (String s in goodDcmTimes) {
        expect(t.isValid(s), true);
      }
      for (String s in badDcmTimes) {
        expect(t.isValid(s), false);
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
        var t = goodTimes[i];
        Duration time = parseDcmTimeString(t);
        expect(time is Duration, true);
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
        var t = badTimes[i];
        log.debug('t: "$t"');
        Duration time = parseDcmTimeString(t);
        log.debug('Time: $time');
        expect(time == null, true);
      }
    });
  });
}
