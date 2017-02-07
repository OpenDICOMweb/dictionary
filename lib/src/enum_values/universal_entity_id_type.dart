// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/terminology/term.dart';

import 'enum_value_base.dart';

class UniversalEntityIDType extends EnumValue<String> {
  const UniversalEntityIDType(int index, String name, String value, Term term)
      : super(index, name, value, term);

  static const DNS =
      const UniversalEntityIDType(0, "DNS", "Domain Name System", Term.DNS);
  static const EUI64 = const UniversalEntityIDType(
      0, "EUI64", "IEEE Extended Unique Idnetifier", Term.EUI64);
  static const ISO =
      const UniversalEntityIDType(0, "DNS", "Domain Name System", Term.ISO);
  static const URI =
      const UniversalEntityIDType(0, "URI", "Universal Resource Identifier", Term.URI);
  static const UUID =
      const UniversalEntityIDType(0, "UUID", "Universal Unique Identifier", Term.UUID);
  static const X400 =
      const UniversalEntityIDType(0, "X400", "X400 MHS Identifier", Term.X400);
  static const X500 =
      const UniversalEntityIDType(0, "X500", "X500 Directory Name", Term.X500);

  UniversalEntityIDType lookup(String key) => map[key];

  static const map = const {
    "DNS": DNS,
    "EUI64": EUI64,
    "ISO": ISO,
    "URI": URI,
    "UUID": UUID,
    "X400": X400,
    "X500": X500
  };
}
