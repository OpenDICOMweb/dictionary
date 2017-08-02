// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';
import 'package:common/logger.dart';
import 'package:dictionary/src/person_name.dart';

final Logger log = new Logger('DateTimeTests', Level.info);

void main() {
  const ListEquality equality = const ListEquality();
  bool v = equality.equals([1, 2, 3], [1, 2, 3]);
  log.debug('equal: $v');
  String name0 = "";
  String name1 = 'a';
  String name2 = 'a^b';
  String name3 = 'a^b^c';
  String name4 = 'a^b^c^d';
  String name5 = 'a^b^c^d^e';

  List<String> names = [name0, name1, name2, name3, name4, name5];

  String nameX0 = 'a^b^^^e';
  String nameX1 = ' a^ b ^ ^^ e ';

  for (String s in names) {
    var s0 = s.split('^');
    var j0 = s0.join('|');
    log.debug('j0: "$j0"');
  }

  var s1 = splitTrim(nameX1, '^');
  var j1 = s1.join('|');
  log.debug('j1: "$j1"');

  // log.debug('s: $s');
  // for(String ss in s) log.debug('"$ss"');

  log.debug(nameX0.split('^').fold("", (t, e) => '$t|"$e"'));

  for (String s in nameX0.split('^')) log.debug('"$s"');

  Name name8 = new Name.fromString(name5);
  Name name9 = new Name.fromString(name5);
  log.debug('name8 == name9: ${name8 == name9}');
  printName(name8);

  name8 = new Name.fromString(nameX0);
  log.debug('Name.fromString: $name8');
  printName(name8);

  var pnString = [name5, name4, name3].join('=');
  log.debug('pnString: "$pnString"');
  PersonName pn = new PersonName.fromString(pnString);
  log.debug('pn: $pn ${pn.dcm}');
}

void printName(Name name) {
  log.debug('name: $name');
  log.debug('       dcm: ${name.dcm}');
  log.debug('   isValid: ${Name.isValidString(name.dcm)}');
  log.debug('  initials: ${name.initials}');
  log.debug('      info: ${name.info}');
}
