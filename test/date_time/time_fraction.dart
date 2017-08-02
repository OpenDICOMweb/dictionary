// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:test/test.dart';

final Logger log = new Logger('time_test.dart', Level.debug);

const List<int> goodTimeFractionValues = const <int>[
  100000, 110000, 111000, 111100, 111110, 111111,
  000000, 000000, 000000, 000000, 000000, 000000,
  900000, 990000, 999000, 999900, 999990, 999999 //no reformat
];

const List<int> goodFractionValues = const <int>[
  1, 11, 111, 1111, 11111, 111111,
  0, 00, 000, 0000, 00000, 000000,
  9, 99, 999, 9999, 99999, 999999 //no reformat
];

const List<String> goodFractionStrings = const <String>[
  '.1',
  '.11',
  '.111',
  '.1111',
  '.11111',
  '.111111',
  '.0',
  '.00',
  '.000',
  '.0000',
  '.00000',
  '.000000',
  '.9',
  '.99',
  '.999',
  '.9999',
  '.99999',
  '.999999',
];

const List<String> badFractionStrings = const <String>[
  'a',
  'aa',
  '.',
  '.a',
  '.1a',
  '.11x',
  '.111*',
  '.1111.',
  '.11111,',
  '0',
  '00',
  '.,00',
  '.*000',
  '.00-000',
  '.00000+00',
  '.00000000zx',
];

const List<String> badTimeFractionStrings = const <String>[
  'a',
  'aa',
  '.',
  '.a',
  '.1a',
  '.11x',
  '.111*',
  '.1111.',
  '.11111,',
  '0',
  '00',
  '.,00',
  '.*000',
  '.00-000',
  '.00000+00',
  '.00000000', //Too Long
];

void main() {
  group("ParseFraction", () {
    test("Good Fraction", () {
      if (goodFractionStrings.length != goodFractionValues.length)
        throw 'Unequal lengths';
      log.debug('Parse Good Fractions:');
      for (int i = 0; i < goodFractionStrings.length; i++) {
        var s = goodFractionStrings[i];
        log.debug('  Parse Good Fraction: "$s"');
        int f = parseFraction(s);
        log.debug('                   $f');
        var v = goodFractionValues[i];
        if (f != v) throw '    Unequal Values: f: $f, v: $v';
      }
    });

    test("Bad Fraction", () {
      log.debug('Parse Bad Fractions:');
      for (int i = 0; i < badFractionStrings.length; i++) {
        var s = badFractionStrings[i];
        log.debug('  Parse Bad Fraction: "$s"');
        int f = parseFraction(s);
        log.debug('                       $f');
        if (f != null) throw '    Non-Null Value: f: $f';
      }
    });

    test("Good Time Fractions", () {
      log.debug('Parse Good Time Fractions:');
      if (goodFractionStrings.length != goodTimeFractionValues.length)
        throw 'Unequal lengths';
      log.debug('Good Time Fractions:');
      for (int i = 0; i < goodFractionStrings.length; i++) {
        var s = goodFractionStrings[i];
        log.debug('  Parse Good Time Fraction: "$s"');
        var issues = new ParseIssues('Good Time Fractions', s);
        int us = parseTimeFraction(s, issues: issues);
        log.debug('  Time Fraction: us: $us');
        var v = goodTimeFractionValues[i];
        log.debug('  Good Value:     v: $v');
        log.debug('             issues: "$issues"');
        if (us != v) throw '  Unequal Values: f: $us, v: $v';

        if (!issues.isEmpty)
          throw '  Issues is not empty: ${issues.isEmpty}, issues: "$issues"';
      }
    });

    test("Bad Time Fractions", () {
      log.debug('Parse Bad Time Fractions:');
      for (int i = 0; i < badTimeFractionStrings.length; i++) {
        var s = badFractionStrings[i];
        log.debug('  Parse Bad Time Fraction: "$s"');
        var issues = new ParseIssues('Bad Time Fraction', s);
        int us = parseTimeFraction(s, issues: issues);
        log.debug('  Time Fraction: us: $us');
        if (us != null) throw '  Non-Null Value: us: $us';
        log.debug('             issues: "$issues"');
        if (issues.isEmpty)
          throw '  Issues is not empty: ${issues.isEmpty}, issues: "$issues"';
      }
    });
  });
}
