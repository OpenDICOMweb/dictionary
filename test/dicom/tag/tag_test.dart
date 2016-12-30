// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/tag/tag/constants.dart';
import 'package:dictionary/src/dicom/tag/tag/tag.dart';

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
main() {
  tagTest();
}

  tagTest() {

  for(int i = 0; i < tags.length; i++) {
    Tag tag = Tag.lookup(tags[i]);
    print('${tag.info}');
    print('isShort: ${tag.isShort}, sizeInBytes: ${tag.sizeInBytes}');
    print('min: ${tag.minLength}, max: ${tag.maxLength}, width: ${tag.width}');
  }


}