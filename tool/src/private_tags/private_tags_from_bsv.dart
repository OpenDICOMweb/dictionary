// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'dart:io';

String inPath = 'C:/odw/sdk/dictionary/tool/src/private_tags/data/ListOfPrivateElementsFromDD.bsv';
String outPath = 'C:/odw/sdk/dictionary/tool/src/private_tags/array.dart';
void main(List<String> args) {
  File inFile = new File(inPath);
  List<String> lines = inFile.readAsLinesSync();

  List rows = new List(lines.length);

  //for (int i = 0; i < lines.length; i++) {

  var header = lines[0].split("|");
  for (int i = 0; i < header.length; i++)
    header[i] = '"${header[i]}"';
  var headRow = 'const [' + header.join(', ') + ']';
  rows[0] = headRow;

  for (int i = 1; i < lines.length; i++) {
    List<String> v = lines[i].split("|");
    var group = v[0];
    var creator = v[1];
    var element = v[2];
    var vr = v[3];
    var vm = v[4].replaceAll('-', '_');
    var name = v[5];

    var nLine = ['$i', '"$creator"', '"$name"', '0x$group', '0x$element', 'VR.k$vr', 'VM.k$vm'];

    rows[i] = nLine;
  }

  //for (int i = 0; i < lines.length; i++) print('$i, ${rows[i]}');

  var out = createDartArray(rows);
  print(out);

  File outFile = new File(outPath);
  outFile.writeAsStringSync(out);
}

String createDartArray(List rows) {
  List<String> sList = new List(rows.length);
  sList[0] = rows[0];

  for (int i = 1; i < rows.length; i++) {
    sList[i] = 'const [${rows[i].join(', ')}]';
  }
  var s = sList.join(',\n  ');
  return '''
// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

const List<List<String>> privateTagArray = const [
  $s
];
  ''';
}
