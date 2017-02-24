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

void validateTest() {
  int code = 0x00080008;
  Tag tagCS = new Tag(code);
  Tag tagPublicCS = new Tag.public("Image​Type", code, "Image Type", VR.kCS, VM.k2_n);
  Tag tagPublicSQ = new Tag.public("LanguageCodeSequence", 0x00080006,
      "Language Code Sequence", VR.kSQ, VM.k1, false);
  Tag tagPublicUS = new Tag.public("NumberOfZeroFills", 0x00189066,
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
      expect(tagCS.isValidValues(listsInt), true);
      expect(tagPublicCS.isValidValues(listsStr), true);
    });

    test("test for isValidLength", () {
      expect(tagPublicCS.isValidLength(tagPublicCS.maxLength + 1), false);
      expect(tagPublicCS.isValidLength(tagPublicCS.maxLength), false);
      expect(tagPublicCS.isValidLength(tagPublicCS.maxLength - 1), true);
      expect(tagPublicCS.isValidLength(tagPublicCS.minLength - 1), false);
      expect(tagPublicCS.isValidLength(tagPublicCS.minLength), true);

      expect(tagPublicSQ.isValidLength(tagPublicSQ.minLength), true);
      expect(tagPublicSQ.isValidLength(tagPublicSQ.minLength - 1), true);
      expect(tagPublicSQ.isValidLength(tagPublicSQ.minLength + 1), false);
      expect(tagPublicSQ.isValidLength(tagPublicSQ.maxLength), true);
      expect(tagPublicSQ.isValidLength(tagPublicSQ.maxLength - 1), true);

      expect(tagPublicUS.isValidLength(tagPublicUS.minLength), true);
      expect(tagPublicUS.isValidLength(tagPublicUS.minLength - 1), true);
      expect(tagPublicUS.isValidLength(tagPublicUS.minLength + 1), true);
      expect(tagPublicUS.isValidLength(tagPublicUS.maxLength), true);
      expect(tagPublicUS.isValidLength(tagPublicUS.maxLength + 1), false);
    });

    test("test for isValidWidth", () {
      expect(tagPublicCS.isValidWidth(tagPublicCS.maxLength + 1), true);
      expect(tagPublicCS.isValidWidth(tagPublicCS.maxLength), false);
      expect(tagPublicCS.isValidWidth(tagPublicCS.minLength - 1), false);
      expect(tagPublicCS.isValidWidth(tagPublicCS.minLength), true);

      expect(tagPublicSQ.isValidWidth(tagPublicSQ.minLength), true);
      expect(tagPublicSQ.isValidWidth(tagPublicSQ.minLength - 1), true);
      expect(tagPublicSQ.isValidWidth(tagPublicSQ.maxLength), true);
      expect(tagPublicSQ.isValidWidth(tagPublicSQ.maxLength + 1), true);

      expect(tagPublicUS.isValidWidth(tagPublicUS.minLength), true);
      expect(tagPublicUS.isValidWidth(tagPublicUS.minLength - 1), true);
      expect(tagPublicUS.isValidWidth(tagPublicUS.maxLength), true);
      expect(tagPublicUS.isValidWidth(tagPublicUS.maxLength + 1), true);
    });

    test("test for isValidVFLength", () {
      expect(tagPublicCS.isValidVFLength(tagPublicCS.minLength * tagPublicCS.vr.minValueLength),
          true);
      expect(
          tagPublicCS
              .isValidVFLength((tagPublicCS.minLength * tagPublicCS.vr.minValueLength) - 1),
          false);
      expect(tagPublicCS.isValidVFLength(tagPublicCS.maxLength * tagPublicCS.vr.maxValueLength),
          true);
      expect(
          tagPublicCS
              .isValidVFLength((tagPublicCS.maxLength * tagPublicCS.vr.maxValueLength) + 1),
          false);

      expect(tagPublicSQ.isValidVFLength(tagPublicSQ.maxLength * tagPublicSQ.vr.maxValueLength),
          true);
      expect(
          tagPublicSQ.isValidVFLength(tagPublicSQ.maxLength * tagPublicSQ.vr.maxValueLength + 1),
          false);
      expect(tagPublicSQ.isValidVFLength(tagPublicSQ.minLength * tagPublicSQ.vr.minValueLength),
          true);
      expect(
          tagPublicSQ.isValidVFLength(tagPublicSQ.minLength * tagPublicSQ.vr.minValueLength - 1),
          false);

      expect(tagPublicUS.isValidVFLength(tagPublicUS.minLength * tagPublicUS.vr.minValueLength),
          true);
      expect(
          tagPublicUS.isValidVFLength(tagPublicUS.minLength * tagPublicUS.vr.minValueLength - 1),
          false);
      expect(tagPublicUS.isValidVFLength(tagPublicUS.maxLength * tagPublicUS.vr.maxValueLength),
          true);
      expect(
          tagPublicUS.isValidVFLength(tagPublicUS.maxLength * tagPublicUS.vr.maxValueLength + 1),
          false);
    });
  });
}
