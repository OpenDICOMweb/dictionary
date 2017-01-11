// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vr/check_values.dart';
import 'package:test/test.dart';

main() {
  //List<String> uints = ["9", "99", "999", "9999", "9999999999"];

  //int v = readUint(uints[0], 0, 1, 1);
 // print('v = $v');
  uintTest();
}

// TODO: create good and bad data generators for these tests

uintTest() {
  List<String> uintStrings = ["9", "09", "990", "0999", "9099099909"];
  List<int> uintValues = [9, 09, 990, 0999, 9099099909];
  List<int> uintLength_1Values = [0, 0, 99, 099, 909909990];
  List<int> uintLengths = [1, 2, 3, 4, 9];

  List<String> badUintStrings = ["", "X", "9X", "99S", "999S", "99999999X"];
  List<int> badUintValues = [null, null, null, null, null, null];
  List<int> badUintLengths = [0, 1, 2, 3, 4, 9];

  group("readUint Good Tests", () {
    test("readUint Good Good Fixed Length: min = 0, max = s.length", () {
      for (int i = 0; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        int offset = 0;
        int min = 0;
        int max = s.length;
        int v = readUint(uintStrings[i], offset, 0, max);
        expect(v, equals(uintValues[i]));
      }
    });

    test("Uint Good Fixed Length: min = 0, max = s.length - 1", () {
      for (int i = 1; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        int offset = 0;
        int min = 0;
        int max = s.length - 1;
        int v = readUint(uintStrings[i], offset, 0, max);
        expect(v, equals(uintLength_1Values[i]));
      }
    });

    test("Uint Good Variable with min = 1, max = length", () {
      for (int i = 1; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        int offset = 0;
        int min = 1;
        int max = s.length;
        int v = readUint(uintStrings[i], offset, min, max);
        expect(v, equals(uintValues[i]));
      }
    });

    test("readUint Good Variable with min = 2, max = s.length", () {
      for (int i = 2; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        int offset = 0;
        int min = 2;
        int max = s.length;
        int v = readUint(uintStrings[i], offset, min, max);
        expect(v, equals(uintValues[i]));
      }
    });

    test("Good Uint ", () {});
  });

  group("readUint Bad Tests", () {
    test("readUint Bad Fixed Length: min = 0, max = s.length", () {
      for (int i = 0; i < uintStrings.length; i++) {
        var s = uintStrings[i];
        int offset = 0;
        int min = 0;
        int max = s.length;
        int v = readUint(badUintStrings[i], offset, 0, max);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("Uint Bad Variable with min = 1, max = length", () {
      for (int i = 1; i < badUintStrings.length; i++) {
        var s = badUintStrings[i];
        int offset = 0;
        int min = 1;
        int max = s.length;
        int v = readUint(badUintStrings[i], offset, min, max);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("readUint Bad Variable with min = 2, max = s.length", () {
      for (int i = 2; i < badUintStrings.length; i++) {
        var s = badUintStrings[i];
        int offset = 0;
        int min = 2;
        int max = s.length;
        int v = readUint(badUintStrings[i], offset, min, max);
        expect(v, equals(badUintValues[i]));
      }
    });

    test("Bad Uint ", () {});
  });
}
