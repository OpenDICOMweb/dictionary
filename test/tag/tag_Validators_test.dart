// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Binayak Behera <binayak.b@mwebware.com> -
// See the AUTHORS file for other contributors.

import 'dart:math';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:dictionary/src/vm.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random/random_string.dart' as random_string;

void main() {
  validateTest();
}

validateTest() {
  int code = 0x00080008;
  Tag tag_cs = new Tag(code);
  Tag tP_cs = new Tag.public("Image​Type", code, "Image Type", VR.kCS, VM.k2_n);
  Tag tP_sq = new Tag.public("LanguageCodeSequence", 0x00080006,
      "Language Code Sequence", VR.kSQ, VM.k1, false);
  Tag tP_us = new Tag.public("NumberOfZeroFills", 0x00189066,
      "Number of Zero Fills", VR.kUS, VM.k1_2, false);

  group("Tag validators in tag", () {
    test("test for isvalidvalues", () {
      var listsInt = new List<int>();
      for (int i = 0; i < 10; i++) {
        listsInt.add(i);
      }
      var listsStr = new List<String>();
      for (int i = 0; i < 10; i++) {
        listsStr.add(random_string.randomString(12, noLowerCase: true) +
            new String.fromCharCode([32, 95][new Random().nextInt(2)]));
      }
      expect(tag_cs.isValidValues(listsInt), true);
      expect(tP_cs.isValidValues(listsStr), true);
    });

    test("test for isValidLength", () {
      expect(tP_cs.isValidLength(tP_cs.maxLength + 1), false);
      expect(tP_cs.isValidLength(tP_cs.maxLength), false);
      expect(tP_cs.isValidLength(tP_cs.maxLength - 1), true);
      expect(tP_cs.isValidLength(tP_cs.minLength - 1), false);
      expect(tP_cs.isValidLength(tP_cs.minLength), true);

      expect(tP_sq.isValidLength(tP_sq.minLength), true);
      expect(tP_sq.isValidLength(tP_sq.minLength - 1), true);
      expect(tP_sq.isValidLength(tP_sq.minLength + 1), false);
      expect(tP_sq.isValidLength(tP_sq.maxLength), true);
      expect(tP_sq.isValidLength(tP_sq.maxLength - 1), true);

      expect(tP_us.isValidLength(tP_us.minLength), true);
      expect(tP_us.isValidLength(tP_us.minLength - 1), true);
      expect(tP_us.isValidLength(tP_us.minLength + 1), true);
      expect(tP_us.isValidLength(tP_us.maxLength), true);
      expect(tP_us.isValidLength(tP_us.maxLength + 1), false);
    });

    test("test for isValidWidth", () {
      expect(tP_cs.isValidWidth(tP_cs.maxLength + 1), true);
      expect(tP_cs.isValidWidth(tP_cs.maxLength), false);
      expect(tP_cs.isValidWidth(tP_cs.minLength - 1), false);
      expect(tP_cs.isValidWidth(tP_cs.minLength), true);

      expect(tP_sq.isValidWidth(tP_sq.minLength), true);
      expect(tP_sq.isValidWidth(tP_sq.minLength - 1), true);
      expect(tP_sq.isValidWidth(tP_sq.maxLength), true);
      expect(tP_sq.isValidWidth(tP_sq.maxLength + 1), true);

      expect(tP_us.isValidWidth(tP_us.minLength), true);
      expect(tP_us.isValidWidth(tP_us.minLength - 1), true);
      expect(tP_us.isValidWidth(tP_us.maxLength), true);
      expect(tP_us.isValidWidth(tP_us.maxLength + 1), true);
    });

    test("test for isValidVFLength", () {
      expect(tP_cs.isValidVFLength(tP_cs.minLength * tP_cs.vr.minValueLength),
          true);
      expect(
          tP_cs
              .isValidVFLength((tP_cs.minLength * tP_cs.vr.minValueLength) - 1),
          false);
      expect(tP_cs.isValidVFLength(tP_cs.maxLength * tP_cs.vr.maxValueLength),
          true);
      expect(
          tP_cs
              .isValidVFLength((tP_cs.maxLength * tP_cs.vr.maxValueLength) + 1),
          false);

      expect(tP_sq.isValidVFLength(tP_sq.maxLength * tP_sq.vr.maxValueLength),
          true);
      expect(
          tP_sq.isValidVFLength(tP_sq.maxLength * tP_sq.vr.maxValueLength + 1),
          false);
      expect(tP_sq.isValidVFLength(tP_sq.minLength * tP_sq.vr.minValueLength),
          true);
      expect(
          tP_sq.isValidVFLength(tP_sq.minLength * tP_sq.vr.minValueLength - 1),
          false);

      expect(tP_us.isValidVFLength(tP_us.minLength * tP_us.vr.minValueLength),
          true);
      expect(
          tP_us.isValidVFLength(tP_us.minLength * tP_us.vr.minValueLength - 1),
          false);
      expect(tP_us.isValidVFLength(tP_us.maxLength * tP_us.vr.maxValueLength),
          true);
      expect(
          tP_us.isValidVFLength(tP_us.maxLength * tP_us.vr.maxValueLength + 1),
          false);
    });
  });
}
