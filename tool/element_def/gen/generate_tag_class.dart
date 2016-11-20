// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:dictionary/dicom.dart';
import 'package:dictionary/src/dicom/tag/tag2.dart';

import 'tag_class_code.dart';

const String outputDir = "C:/odw/sdk/core/lib/src/base/tag/gen/output";
const String outputPath = outputDir + '/tag_constants.dart';

void main(args) {

  File outFile = new File(outputPath);
  var members = generateMembers(deDefs);
  var s = '$header$members';
  print(s);
  outFile.writeAsStringSync(s);
}

String generateMembers(Map<int, ElementDef> map) {
  var s = "";

  map.forEach((int tag, ElementDef deDef) {
    s += '  static const Tag k${deDef.keyword} = const Tag(${Tag.hex(tag)});\n';
  });
  return s += '}\n';
}