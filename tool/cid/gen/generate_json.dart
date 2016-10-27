// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// generate_json

import 'dart:convert';
import 'dart:io';

/// This program is used to gen dart classes from DICOM table in PS3.15 Appendix E.
/// It read the .csv file and converts them to .json data structures.  It then uses these
/// *.json gen a Dart compile time constant class.

String inputDir = "C:/odw/sdk/core/lib/src/base/cid/gen/input/csv";
String outputDir = "C:/odw/sdk/core/lib/src/base/cid/gen/output/json";

String csvFilePath = '$inputDir/coding_scheme.csv';
String jsonFilePath = '$outputDir/coding_scheme.json';


// Utilities
bool isDigit(String s) {
  int min = "0".codeUnitAt(0);
  int max = "9".codeUnitAt(0);
  return ((min <=s.codeUnitAt(0)) && (s.codeUnitAt(0) <= max)) ? true : false;
}
// TODO move to generators.dart library
String cleanKeyword(String s) {
  // Remove spaces and apsotrophies
  s = s.replaceAll(' ', "");
  s = s.replaceAll("'", "");
  // Replace '/' and '-' with '_'
  s = s.replaceAll('/', "_");
  s = s.replaceAll("-", "_");
  if (isDigit(s[0])) s = "_" + s;
  return s;
}

/*
//Remove '/' and '*'
String removeSlashesAndStars(String s) {
  s = s.replaceAll("/", "");
  return s.replaceAll('*', "");
}


String convertY_N(String value) {
  print('$value');
  if (value == 'N') {
    return 'false';
  } else if (value == 'Y') {
    return 'true';
  } else if (value == "") {
    return 'false';
  } else {
    throw new Error();
  }
}


String convertDeIdActionCodes(String value) {
  if (value == "") {
    return 'null';
  } else if (value.length > 1) {
    var s = removeSlashesAndStars(value);
    return 'DeIdAction.$s';
  } else {
    return 'DeIdAction.$value';
  }
}
*/

String cleanString(String s) {
  if (s[0] == '"') s = s.substring(1);
  int last = (s.length - 1);
  if (s[last] == '"') s = s.substring(0, last);
  s = s.replaceAll('"', '\"');
  return s;
}

void main() {
  File input = new File(csvFilePath);
  File output = new File(jsonFilePath);

  List<String> lines = input.readAsLinesSync(encoding: SYSTEM_ENCODING);
  // Get the Headers
  String className = lines[0].trim();
  int fieldCount = int.parse(lines[1].trim());
  List fieldTypes = lines[2].trim().split('|');
  List fieldNames = lines[3].trim().split('|');

  List values = new List(lines.length - 4);
  print('line count: ${values.length}');
  int line = 0;
  for (int i = 4; i < lines.length; i++) {
    print('i=$i');
    List row = lines[i].trim().split('|');
    if (fieldCount != row.length) throw new Error();
    row[2] = cleanString(row[2]);
    for (int j = i + 1; j < lines.length; j++) {
      if (fieldCount != row.length) throw new Error();
      List next = lines[j].trim().split('|');
      if (next[0] == "") {
        print('  $j: $next');
        if (row[2] == "Note") row[2] = "Note:";
        row[2] += ' ' + cleanString(next[2]);
        i++;
      } else {
        break;
      }
    }
    //print(row);
    values[line] = row;
    line++;
  }
  values = values.sublist(0, line);

  print('value rows: ${values.length}, descriptor count: $line');

  Map table = new Map();
  table["className"] = className;
  // +1 on next line because we added a new field called 'dcmFmt'.
  table["fieldCount"] = fieldCount;
  table["fieldTypes"] = fieldTypes;
  table["fieldNames"] = fieldNames;
  table["values"] = values;

  String json = JSON.encode(table);
  output.writeAsStringSync(json);
}
