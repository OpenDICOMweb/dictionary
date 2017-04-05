// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/tag/private/pc_tag.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';

final Logger log = new Logger('uint_test.dart', watermark: Severity.debug);

void main() {
  privateCreatorTagTest();
  unknownPrivateCreatorTagTest();
}

void privateCreatorTagTest() {
  test("PrivateCreatorTag Test", () {
    PCTag pTag = new PCTag(0x00090010, VR.kUN, "ACUSON");
    log.debug(pTag.info);
    log.debug('${pTag.name}: ${pTag.dataTags}');
  });
}

void unknownPrivateCreatorTagTest() {
  test("PrivateCreatorTag.unknown Test", () {
    PCTag pTag = new PCTag(0x00090010, VR.kUN, "foo");
    log.debug(pTag.info);
    log.debug('${pTag.name}: ${pTag.dataTags}');
  });
}
