// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/dicom.dart';

import 'private_data.dart';

class PrivateCreator {
  final Tag tag;
  final int code;
    final String name;
    final int group;
    final int elt;
    final VR vr = VR.kLO;
    final VM vm = VM.k1;
   //final List<PrivateData> pData;

    //TODO: validate VR and VM when generating

    const PrivateCreator(this.name, this.group, this.elt, this.pData);

    int get id => group << 16 + elt;

    static const GEMS_ACQU_01 =
    const PrivateCreator("Creator", 0x0009, 0x10, const [PrivateData.k00091000]);
}
