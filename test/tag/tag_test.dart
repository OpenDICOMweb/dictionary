// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/tag/constants.dart';
import 'package:dictionary/src/tag/p_tag.dart';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';

final Logger log = new Logger('DateTimeTests', Level.debug);

List<int> tags = const [
  kSpecificCharacterSet,
  kLanguageCodeSequence,
  kImageType,
  kInstanceCreationDate,
  kInstanceCreationTime,
  kDataSetType,
  kSimpleFrameList,
  kRecommendedDisplayFrameRateInFloat,
  kEventTimeOffset,
  kTagAngleSecondAxis,
  kReferencePixelX0,
  kVectorGridData
];

/// Test the Tag Class
void main() {
  tagTest();
}

/// Simple Tag Test
void tagTest() {
  test('Simple Tag Test', () {
    for (int i = 0; i < tags.length; i++) {
      Tag tag = PTag.lookupCode(tags[i], VR.kUN);
      log.debug('${tag.info}');
      log.debug(
          'isShort: ${tag.hasShortVF}, sizeInBytes: ${tag.vr.elementSize}');
      log.debug(
          'min: ${tag.minValues}, max: ${tag.maxValues}, width: ${tag.width}');
    }
  });
}
