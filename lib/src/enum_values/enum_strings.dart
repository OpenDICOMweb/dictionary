// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'enum_values_base.dart';

class EnumStrings extends EnumValues<String> {

  const EnumStrings(values) : super(values);

  static const kYesNo = const EnumStrings(const ['YES, NO']);

  static const kPhotometricInterpretation = const EnumStrings(const [
    "MONOCHROME1", "MONOCHROME2", "PALETTE COLOR", "RGB", "HSV", // No reformat.
    "ARGB", "CMYK", "YBR_FULL", "YBR_FULL_422", "YBR_PARTIAL_422",
    "YBR_PARTIAL_420", "YBR_ITC", "YBR_RCT"
  ]);

  static const kUniversalEntityIDType = const [
    "DNS", "EUI64", "ISO", "URI", "UUID", "X400", "X500" // No reformat
  ];
}

