// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';

import 'package:dictionary/src/person_name.dart';

void main() {

  const ListEquality equality = const ListEquality();
  bool v = equality.equals([1,2, 3], [1, 2, 3]);
  print('equal: $v');
  String name0 = "";
  String name1 = 'a';
  String name2 = 'a^b';
  String name3 = 'a^b^c';
  String name4 = 'a^b^c^d';
  String name5 = 'a^b^c^d^e';

  String nameX0 = 'a^b^^^e';
  String nameX1 = ' a^ b ^ ^^ e ';

  var s0 = nameX1.split('^');
  var j0 = s0.join('|');
  print('j0: "$j0"');

  var s1 = splitTrim(nameX1, '^');
  var j1 = s1.join('|');
  print('j1: "$j1"');

 // print('s: $s');
 // for(String ss in s) print('"$ss"');

  print(nameX0.split('^').fold("", (t, e) => t  + '|"$e"'));

  for(String s in nameX0.split('^')) print('"$s"');

  Name name8 = new Name.fromString(name5);
  Name name9 = new Name.fromString(name5);
  print('name8 == name9: ${name8 == name9}');
  printName(name8);

  name8 = new Name.fromString(nameX0);
  print('Name.fromString: $name8');
  printName(name8);

  var pnString = [name5, name4, name3].join('=');
  print('pnString: "$pnString"');
  PersonName pn = new PersonName.fromString(pnString);
  print('pn: $pn ${pn.dcm}');




}

void printName(Name name) {
  print('name: $name');
  print('       dcm: ${name.dcm}');
  print('   isValid: ${Name.isValidString(name.dcm)}');
  print('  initials: ${name.initials}');
  print('      info: ${name.info}');
}
