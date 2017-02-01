// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:test/test.dart';

main() {
  dateTest();
}

void dateTest() {
  List<String> goodYears = ["0000", "1900", "1999", "2000", "2049", "25000"];
  List<int> goodYearValues = [0000, 1900, 1999, 2000, 2049, 2500];

  group('Good Years', () {
    test("readUint Good 4 Digit Year min = 4, max = 4", () {
      for (int i = 0; i < goodYears.length; i++) {
        var s = goodYears[i];
        int offset = 0;
        int min = 4;
        int max = 4;
        int v = readUint(s, offset, min, max);
        expect(v, equals(goodYearValues[i]));
      }
    });

  });

  List<String> badYears = ["", "X", "00", "1F00", "199", "2", "-100", "+2500"];
  List<int> badYearValues = [null, null, null, null, null, null, null, null];
  group('Bad Years', () {
    test("readUint Bad 4 Digit Year min = 4, max = 4", () {
      for (int i = 0; i < badYears.length; i++) {
        var s = badYears[i];
        int offset = 0;
        int min = 4;
        int max = 4;
        int v = readUint(s, offset, min, max);
        expect(v, equals(badYearValues[i]));
      }
    });

  });
}