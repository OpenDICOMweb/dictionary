// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/private_creator_tag.dart';
import 'package:test/test.dart';

void main() {
  privateCreatorTagTest();
  unknownPrivateCreatorTagTest();
}

void privateCreatorTagTest() {
  test("PrivateCreatorTag Test", () {
    PrivateCreatorTag pTag = PrivateCreatorTag.lookup("ACUSON");
    print(pTag.info);
    //print('${pTag.token}: ${pTag.dataTagMap}');
  });
}

void unknownPrivateCreatorTagTest() {
  test("PrivateCreatorTag.unknown Test", () {
    PrivateCreatorTag pTag = PrivateCreatorTag.lookup("foo");
    print(pTag.info);
    //print('${pTag.token}: ${pTag.dataTagMap}');
  });
}
