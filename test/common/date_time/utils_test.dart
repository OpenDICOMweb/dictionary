// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import "package:dictionary/src/common/date_time/utils.dart";
import 'package:test/test.dart';

List<List> goodDicomDates = [
  ["19000101", 1900, 1, 1],
  ["20161006", 2016, 10, 6],
  ["20001231", 2000, 12, 31],
  ["19500930", 1950, 9, 30],
  ["20490315", 2049, 3, 15],
];

void main() {
    group("Read Good DICOM Dates", () {
      var gdd = goodDicomDates;
      for (int i = 0; i < gdd.length; i++) {
        test("Read Year", () {
          expect(readYear(gdd[i][0]), equals(gdd[i][1]));
        });
      }
      for (int i = 0; i < gdd.length; i++) {
        test("Read Month", () {
          expect(readMonth(gdd[i][0]), equals(gdd[i][2]));
        });
      }
      for (int i = 0; i < gdd.length; i++) {
        test("Read Day", () {
          int y = readYear(gdd[i][0]);
          int m = readMonth(gdd[i][0]);
          expect(readDay(y, m, gdd[i][0]), equals(gdd[i][3]));
        });
      }

    });
    group("Validate Good DICOM Dates", () {
      var gdd = goodDicomDates;
      for (int i = 0; i < gdd.length; i++) {
        test("Validate Year", () {
          expect(checkYear(gdd[i][1]), equals(gdd[i][1]));
        });
      }
      for (int i = 0; i < gdd.length; i++) {
        test("Validate Month", () {
          expect(checkMonth(gdd[i][2]), equals(gdd[i][2]));
        });
      }
      for (int i = 0; i < gdd.length; i++) {
        test("Validate Day", () {
          expect(readDay(gdd[i][1], gdd[i][2], gdd[i][3]), equals(gdd[i][3]));
        });
      }

    });

}