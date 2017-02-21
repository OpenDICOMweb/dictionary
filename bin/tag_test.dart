// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

void main() {

    PrivateCreatorTag tag = PrivateCreatorTag.lookup("ACUSON", 0x00211001);
    print('tag is creator(${tag.isCreator}) and private(${tag.isPrivate})');

    PrivateDataTag data = tag.dataTags[0x00211001];
    print('Acuson data: ${tag.dataTags}');
    print('Tag is Private Data(${data.isPrivateData}) and private(${data.isPrivate})');

    PrivateCreatorTag pcTag = new PrivateCreatorTag("ACUSON", 0x00090010, VR.kLO);
    print('Tag is $pcTag (${pcTag is PrivateCreatorTag}) '
        'and is private(${pcTag.isPrivate})');

    //TODO: Private Data
    // PrivateData privateData = new PrivateData(0x00090000, ['123456'], )


}
