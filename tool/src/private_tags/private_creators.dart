// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

// The generate time data structure is as follows:
//
Map<String, List<PrivateCreator>> privateGroups;





//TODO: generate a file like this one for each Private Creator String.
class PrivateGroup {
    final String id;
    final List<PrivateCreator> creators;

    const PrivateGroup(this.id, this.creators);

    static const GEMS_ACQU_01 =
        const PrivateGroup("GEMS_ACQU_01", const [PrivateCreator.GEMS_ACQU_01]);
}

class PrivateCreator {
  final String id;
  final String name;
  final int group;
  final int elt;
  final VR vr = VR.kLO;
  final VM vm = VM.k1;
  final List<PrivateData> pData;

  //TODO: validate VR and VM when generating

  const PrivateCreator(this.id, this.name, this.group, this.elt, this.pData);

  static const GEMS_ACQU_01 =
      const PrivateCreator("GEMS_ACQU_01", "lastPseq", 0x0019, 0x12, const []);
}

class PrivateData {
  final PrivateCreator creator;
  //final String creatorId;
  final String name;
  final int group;
  final int elt;
  final VR vr;
  final VM vm;

  //TODO: validate creator and creatorId when generating.

  const PrivateData(this.creator, this.name, this.group, this.elt,
                    this.vr, this.vm, );

  static const k00090011 =
      const PrivateData(PrivateCreator.GEMS_ACQU_01, "lastPseq", 0x009, 0x11, VR.kSS, VM.k1);
}

// One list like this per creator.
const List<PrivateData> privateData = const [
  //TODO: how to name the elements
  ];