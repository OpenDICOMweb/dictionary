// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:convert';

import 'package:dictionary/src/ascii/constants.dart';

/// Converts a DICOM [keyword] to the equivalent DICOM name.
///
/// Given a keyword in camelCase, returns a [String] with a
/// space (' ') inserted before each uppercase letter.
///
/// Note: This algorithm does not return the exact [name] string,
/// for example some [name]s have apostrophes ("'") in them,
/// but they are not in the [keyword]. Also, all dashes ('-') in
/// keywords have been converted to underscores ('_'), because
/// dashes are illegal in Dart identifiers.
String keywordToName(String keyword) {
  List<int> kw = keyword.codeUnits;
  List<int> name = new List<int>();
  name[0] = kw[0];
  for(int i = 0; i < kw.length; i++) {
    int char = kw[i];
    if (isUppercaseChar(char)) name.add(kSpace);
    name.add(char);
  }
  return UTF8.decode(name);
}

