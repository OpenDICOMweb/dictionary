// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/pd_tag.dart';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vr/vr.dart';

class PrivateCreatorTag extends Tag {
  final String token;
  final Map<int, PDTagKnown> dataTagMap;

  PrivateCreatorTag(code, this.token, this.dataTagMap)
      : super(code, VR.kLO) {
    if (!Tag.isPrivateCreatorCode(code))
      throw new ArgumentError('Invalid Private Creator Tag Code($code)');
  }

  const PrivateCreatorTag._(index, this.token, this.dataTagMap)
      : super(index, VR.kLO);

  static const Map<int, PDTagKnown> kPD0 = const <int, PDTagKnown>{
    0x00191000: PDTagKnown.k1,
    0x00191100: PDTagKnown.k2,
    0x00191200: PDTagKnown.k3,
    0x00191300: PDTagKnown.k4,
  };
  static const PrivateCreatorTag k0 = const PrivateCreatorTag._(
      0, "1.2.840.113681", const <int, PDTagKnown>{
    0x00191000: PDTagKnown.k1,
    0x00191100: PDTagKnown.k2,
    0x00191200: PDTagKnown.k3,
    0x00191300: PDTagKnown.k4,
  });
  static const PrivateCreatorTag k1 = const PrivateCreatorTag._(
      1, "1.2.840.113708.794.1.1.2.0", const <int, PDTagKnown>{
    0x00871000: PDTagKnown.k5,
    0x00872000: PDTagKnown.k6,
    0x00875000: PDTagKnown.k7,
    0x00873000: PDTagKnown.k4451,
    0x00874000: PDTagKnown.k4452,
  });
}

const List<Map<int, PDTagKnown>> privateDataMaps = const [
  const <int, PDTagKnown>{
    0x00191000: PDTagKnown.k1,
    0x00191100: PDTagKnown.k2,
    0x00191200: PDTagKnown.k3,
    0x00191300: PDTagKnown.k4,
  }
];
