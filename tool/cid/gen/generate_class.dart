// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// generate_class

import 'dart:io';

import 'src/create_class_table.dart';

String inputDir = "C:/odw/sdk/core/lib/src/base/cid/gen/input/json";
String outputDir = "C:/odw/sdk/core/lib/src/base/cid/gen/output/dart";

/// This program generates the Coding Scheme class using the 'coding_scheme.json' file
/// that was created from the DICOM table in PS3.16.
void main() {
  String s;
  File output;

  String jsonFilename = '$inputDir/coding_scheme.json';
  String classFilename = '$outputDir/coding_scheme.dart';

  CodingSchemeClassTable table = CodingSchemeClassTable.read(jsonFilename);

  // Write Tags class
  s = table.codingSchemeClassString;
  output = new File(classFilename);
  output.writeAsStringSync(s);

  print('Done');
}
