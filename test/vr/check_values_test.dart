// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/system.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:test/test.dart';

//Flush final Logger log = new Logger('check_values_test', Level.debug);

void main() {
// TODO: create good and bad data generators for these tests

  List<String> uintStrings = ["9", "09", "990", "0999", "9099099909"];
  List<int> uintValues = [9, 09, 990, 0999, 9099099909];
  List<int> uintLength1Values = [0, 0, 99, 099, 909909990];

  List<String> badUintStrings = ["", "X", "9X", "99S", "999S", "99999999X"];
  List<int> badUintValues = [null, null, null, null, null, null];

  group("parseUint Good Tests", () {
    test("parseUint Good Good Fixed Length: min = 0, max = s.length", () {
      for (int i = 0; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s);
        expect(v, equals(uintValues[i]));
      }
    });

    test("Uint Good Fixed Length: min = 0, max = s.length - 1", () {
      for (int i = 1; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s, end: s.length - 1, max: s.length - 1);
        expect(v, equals(uintLength1Values[i]));
      }
    });

    test("Uint Good Variable with min = 1, max = length", () {
      for (int i = 1; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s, min: 1);
        expect(v, equals(uintValues[i]));
      }
    });

    test("parseUint Good Variable with min = 2, max = s.length", () {
      for (int i = 2; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s, min: 2);
        expect(v, equals(uintValues[i]));
      }
    });

    test("Good Uint ", () {});
  });

  group("parseUint Bad Tests", () {
    test("parseUint Bad Fixed Length: min = 0, max = s.length", () {
      for (int i = 0; i < uintStrings.length; i++) {
        var s = badUintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("Uint Bad Variable with min = 1, max = length", () {
      for (int i = 1; i < badUintStrings.length; i++) {
        var s = badUintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("parseUint Bad Variable with min = 2, max = s.length", () {
      for (int i = 2; i < badUintStrings.length; i++) {
        var s = badUintStrings[i];
        log.debug('s(${s.length}): "$s"');
        int v = parseUint(s);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("Bad Uint ", () {});
  });
}
