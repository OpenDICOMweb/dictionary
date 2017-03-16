// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/string/dcm_parse.dart';
import 'package:test/test.dart';

//TODO: needs more tests

void main() {
  group('Uint Parse Tests', () {
    List<String> goodUints = ["0000", "1900", "1999", "2000", "2049", "25000"];
    List<int> goodUintValues = [0000, 1900, 1999, 2000, 2049, 2500];

    group('Good Uints', () {
      test("parseUint ", () {
        for (int i = 0; i < goodUints.length; i++) {
          var s = goodUints[i];
          int v = parseUint(s, 0, 4);
          expect(v, equals(goodUintValues[i]));
        }
      });
    });

    List<String> badUints = [null, "", "X", "1F00", "-100", "+2500"];

    test("readUint Bad 4 Digit Year min = 4, max = 4", () {
      for (int i = 0; i < badUints.length; i++) {
        var s = badUints[i];
        print('s: "$s"');
        int end = (s == null) ? 1 : s.length;
        int v = parseUint(s, 0, end);
        expect(v == null, true);
      }
    });

    test('Good Uints', () {});

    test('Bad Uints', () {});
  });
}
