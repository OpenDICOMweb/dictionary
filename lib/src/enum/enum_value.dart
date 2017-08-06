// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

class EV {
  static const kYesNo = const ['YES', 'NO'];

  static const kUniversalEntityIDType = const [
    "DNS", "EUI64", "ISO", "URI", "UUID", "X400", "X500" // No reformat
  ];

  static const members = const <String, List<String>>{
    'YesNo': kYesNo,
    'UniversalEntityIDType': kUniversalEntityIDType,
  };
}
