// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Binayak Behera <binayak.b@mwebware.com> -
// See the AUTHORS file for other contributors.

import 'dart:math';

import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random/random_string.dart' as random_string;

void main() {
  validateTest();
}

void validateTest() {
  Tag tagCS = new Tag(0x00080008);
  Tag tagPublicCS =
      new Tag.public("Image​Type", 0x00080008, "Image Type", VR.kCS, VM.k2_n);
  Tag tagSQ = new Tag.public("LanguageCodeSequence", 0x00080006,
      "Language Code Sequence", VR.kSQ, VM.k1, false);
  Tag tagUS = new Tag.public("NumberOfZeroFills", 0x00189066,
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

      expect(tagSQ.isValidLength(tagSQ.minLength), true);
      expect(tagSQ.isValidLength(tagSQ.minLength - 1), true);
      expect(tagSQ.isValidLength(tagSQ.minLength + 1), false);
      expect(tagSQ.isValidLength(tagSQ.maxLength), true);
      expect(tagSQ.isValidLength(tagSQ.maxLength - 1), true);

      expect(tagUS.isValidLength(tagUS.minLength), true);
      expect(tagUS.isValidLength(tagUS.minLength - 1), true);
      expect(tagUS.isValidLength(tagUS.minLength + 1), true);
      expect(tagUS.isValidLength(tagUS.maxLength), true);
      expect(tagUS.isValidLength(tagUS.maxLength + 1), false);
    });

    test("test for isValidWidth", () {
      expect(tagPublicCS.isValidWidth(tagPublicCS.maxLength + 1), true);
      expect(tagPublicCS.isValidWidth(tagPublicCS.maxLength), false);
      expect(tagPublicCS.isValidWidth(tagPublicCS.minLength - 1), false);
      expect(tagPublicCS.isValidWidth(tagPublicCS.minLength), true);

      expect(tagSQ.isValidWidth(tagSQ.minLength), true);
      expect(tagSQ.isValidWidth(tagSQ.minLength - 1), true);
      expect(tagSQ.isValidWidth(tagSQ.maxLength), true);
      expect(tagSQ.isValidWidth(tagSQ.maxLength + 1), true);

      expect(tagUS.isValidWidth(tagUS.minLength), true);
      expect(tagUS.isValidWidth(tagUS.minLength - 1), true);
      expect(tagUS.isValidWidth(tagUS.maxLength), true);
      expect(tagUS.isValidWidth(tagUS.maxLength + 1), true);
    });

    test("test for isValidVFLength", () {
      expect(
          tagPublicCS.isValidVFLength(
              tagPublicCS.minLength * tagPublicCS.vr.minValueLength),
          true);
      expect(
          tagPublicCS.isValidVFLength(
              (tagPublicCS.minLength * tagPublicCS.vr.minValueLength) - 1),
          false);
      expect(
          tagPublicCS.isValidVFLength(
              tagPublicCS.maxLength * tagPublicCS.vr.maxValueLength),
          true);
      expect(
          tagPublicCS.isValidVFLength(
              (tagPublicCS.maxLength * tagPublicCS.vr.maxValueLength) + 1),
          false);

      expect(tagSQ.isValidVFLength(tagSQ.maxLength * tagSQ.vr.maxValueLength),
          true);
      expect(
          tagSQ.isValidVFLength(tagSQ.maxLength * tagSQ.vr.maxValueLength + 1),
          false);
      expect(tagSQ.isValidVFLength(tagSQ.minLength * tagSQ.vr.minValueLength),
          true);
      expect(
          tagSQ.isValidVFLength(tagSQ.minLength * tagSQ.vr.minValueLength - 1),
          false);

      expect(tagUS.isValidVFLength(tagUS.minLength * tagUS.vr.minValueLength),
          true);
      expect(
          tagUS.isValidVFLength(tagUS.minLength * tagUS.vr.minValueLength - 1),
          false);
      expect(tagUS.isValidVFLength(tagUS.maxLength * tagUS.vr.maxValueLength),
          true);
      expect(
          tagUS.isValidVFLength(tagUS.maxLength * tagUS.vr.maxValueLength + 1),
          false);
    });
  });
}
