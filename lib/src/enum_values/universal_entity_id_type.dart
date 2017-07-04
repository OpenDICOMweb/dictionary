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

  static const UniversalEntityIDType kDNS =
      const UniversalEntityIDType(0, "DNS", "Domain Name System", Term.kDNS);
  static const UniversalEntityIDType kEUI64 = const UniversalEntityIDType(
      0, "EUI64", "IEEE Extended Unique Idnetifier", Term.kEUI64);
  static const UniversalEntityIDType kISO =
      const UniversalEntityIDType(0, "DNS", "Domain Name System", Term.kISO);
  static const UniversalEntityIDType kURI = const UniversalEntityIDType(
      0, "URI", "Universal Resource Identifier", Term.kURI);
  static const UniversalEntityIDType kUUID = const UniversalEntityIDType(
      0, "UUID", "Universal Unique Identifier", Term.kUUID);
  static const UniversalEntityIDType kX400 =
      const UniversalEntityIDType(0, "X400", "X400 MHS Identifier", Term.kX400);
  static const UniversalEntityIDType kX500 =
      const UniversalEntityIDType(0, "X500", "X500 Directory Name", Term.kX500);

  @override
  UniversalEntityIDType lookup(String key) => map[key];

  static const Map<String, UniversalEntityIDType> map = const {
    "DNS": kDNS,
    "EUI64": kEUI64,
    "ISO": kISO,
    "URI": kURI,
    "UUID": kUUID,
    "X400": kX400,
    "X500": kX500
  };
}
