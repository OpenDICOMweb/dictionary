// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private_creator_tag.dart';
import 'package:test/test.dart';

main() {
  PrivateCreatorTagTest();
  UnknownPrivateCreatorTagTest();
}

  PrivateCreatorTagTest() {
    test("PrivateCreatorTag Test", () {
      PrivateCreatorTag pTag = PrivateCreatorTag.lookup("ACUSON", 0x00090010);
      print(pTag.info);
      //print('${pTag.token}: ${pTag.dataTagMap}');

    });

}

UnknownPrivateCreatorTagTest() {
  test("PrivateCreatorTag.unknown Test", () {
    PrivateCreatorTag pTag = PrivateCreatorTag.lookup("foo", 0x00090010);
    print(pTag.info);
    //print('${pTag.token}: ${pTag.dataTagMap}');

  });
}