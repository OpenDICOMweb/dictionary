// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'enum_values_base.dart';

class EnumStringMap extends EnumValuesMap<String, String>{

  const EnumStringMap(Map<String, String> map) : super(map);

  static const kUniversalEntityIDType = const <String, String>  {
  "DNS": "Domain Name System",
  "EUI64":  "IEEE Extended Unique Idnetifier",
  "ISO": "An International Standards Organization Object Identifier",
  "URI": "Universal Resource Identifier",
  "UUID": "Universal Unique Identifier",
  "X400": "X400 MHS Identifier",
  "X500": "X500 Directory Name"
  };
}
