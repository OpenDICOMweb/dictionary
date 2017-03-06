// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/private_data_tag.dart';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

class PrivateCreatorTag extends Tag {
  final String token;
  final Map<int, PrivateDataTag> dataTagMap;

  PrivateCreatorTag(code, this.token, this.dataTagMap)
      : super(code, VR.kLO, VM.k1) {
    if (!Tag.isPrivateCreatorCode(code))
      throw new ArgumentError('Invalid Private Creator Tag Code($code)');
  }

  const PrivateCreatorTag._(index, this.token, this.dataTagMap)
      : super(index, VR.kLO, VM.k1);

  static const Map<int, PrivateDataTag> kPD0 = const <int, PrivateDataTag>{
    0x00191000: PrivateDataTag.k1,
    0x00191100: PrivateDataTag.k2,
    0x00191200: PrivateDataTag.k3,
    0x00191300: PrivateDataTag.k4,
  };
  static const PrivateCreatorTag k0 = const PrivateCreatorTag._(
      0, "1.2.840.113681", const <int, PrivateDataTag>{
    0x00191000: PrivateDataTag.k1,
    0x00191100: PrivateDataTag.k2,
    0x00191200: PrivateDataTag.k3,
    0x00191300: PrivateDataTag.k4,
  });
  static const PrivateCreatorTag k1 = const PrivateCreatorTag._(
      1, "1.2.840.113708.794.1.1.2.0", const <int, PrivateDataTag>{
    0x00871000: PrivateDataTag.k5,
    0x00872000: PrivateDataTag.k6,
    0x00875000: PrivateDataTag.k7,
    0x00873000: PrivateDataTag.k4451,
    0x00874000: PrivateDataTag.k4452,
  });
}

const List<Map<int, PrivateDataTag>> privateDataMaps = const [
  const <int, PrivateDataTag>{
    0x00191000: PrivateDataTag.k1,
    0x00191100: PrivateDataTag.k2,
    0x00191200: PrivateDataTag.k3,
    0x00191300: PrivateDataTag.k4,
  }
];
