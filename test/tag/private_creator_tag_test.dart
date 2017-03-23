// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/tag/private/private_creator_tag.dart';
import 'package:test/test.dart';

final Logger log = new Logger('uint_test.dart', watermark: Severity.info);

void main() {
  privateCreatorTagTest();
  unknownPrivateCreatorTagTest();
}

void privateCreatorTagTest() {
  test("PrivateCreatorTag Test", () {
    PrivateCreatorTag pTag = new PrivateCreatorTag("ACUSON", 0x00090010);
    log.debug(pTag.info);
    log.debug('${pTag.creatorToken}: ${pTag.dataTags}');
  });
}

void unknownPrivateCreatorTagTest() {
  test("PrivateCreatorTag.unknown Test", () {
    PrivateCreatorTag pTag = new PrivateCreatorTag("foo", 0x00090010);
    log.debug(pTag.info);
    log.debug('${pTag.creatorToken}: ${pTag.dataTags}');
  });
}
