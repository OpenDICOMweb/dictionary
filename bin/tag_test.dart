// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

void main() {
  PCTag pcTag = new PCTag(0x00090010, VR.kLO, "ACUSON");
  print('${pcTag.runtimeType}: tag is creator(${pcTag.isCreator}) '
      'and private(${pcTag.isPrivate})');

  if (pcTag is PCTagKnown) {
    var data = pcTag.dataTags[0x00090001];
    print('${data.runtimeType}: Acuson data: ${pcTag.definition.dataTags}');
    print('${data.runtimeType}: Tag is Private Data(${data is PDTagKnown}) '
        'and private(${pcTag.isPrivate})');
  }
  PCTag pcTag1 = new PCTag(0x00090010, VR.kUN, "ACUSON");
  print('${pcTag1.runtimeType}: Tag is $pcTag1 (${pcTag1 is
  PCTag}) '
      'and is private(${pcTag1.isPrivate})');


}
