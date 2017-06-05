// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/person_name.dart';
import 'package:test/test.dart';
import 'package:test_tools/random_string.dart' as rsg;

void main() {
  personNameTest();
}

void personNameTest() {
  Logger log = new Logger('test', watermark: Severity.info);

  //noOfgroups=3, noOfomponents=5, componentLength=8
  String strValid = rsg.generateDcmPersonName(3, 5, 6);
  //noOfgroups=3, noOfomponents=5, componentLength=8
  String strValid1 = rsg.generateDcmPersonName(3, 5, 15);

  group("person_name", () {
    test("test for isValidString and isValidList", () {
      PersonName personName = new PersonName.fromString(strValid);
      log.debug(personName.toString());
      expect(PersonName.isValidString(strValid), true);

      List<String> listNames = strValid.split("=");
      expect(PersonName.isValidList(listNames), true);
    });

    test("test for == in PersonName", () {
      PersonName pn1 = new PersonName.fromString(strValid);
      PersonName pn2 = new PersonName.fromString(strValid);
      log.debug(pn1.hashCode);
      expect(pn1 == pn2, true);
      expect(pn1, equals(pn2));
    });

    test("test for parse", () {
      //noOfgroups=3, noOfomponents=5, componentLength=8
      String strInValid = rsg.generateDcmPersonName(4, 5, 8);

      PersonName pn = PersonName.parse(strValid);
      log.debug("alphabetic: ${pn.alphabetic}");
      log.debug("phonetic: ${pn.phonetic}");
      log.debug("ideographic: ${pn.ideographic}");

      PersonName pn1 = PersonName.parse(strInValid);
      PersonName pn2 = PersonName.parse("");
      PersonName pn3 = PersonName.parse(null);
      expect(pn1, null);
      expect(pn2, null);
      expect(pn3, null);
    });
  });

  group("Name", () {
    List<String> namesList1 = strValid.split("=");
    List<String> namesList2 = strValid1.split("=");

    test("test for isValidList", () {
      for (String name in namesList1) {
        expect(Name.isValidList(name.split("^")), true);
      }
    });

    test("test for == in Name", () {
      Name name = new Name.fromString(namesList1[0]);
      Name name1 = new Name.fromString(namesList1[0]);
      Name name2 = new Name.fromString(namesList1[1]);
      expect(name == name1, true);
      expect(name == name2, false);
    });

    test("test for isvalidString", () {
      expect(Name.isValidString(namesList1[0]), true);
    });

    test("test for parse in Name", () {
      Name n1 = Name.parse(namesList2[1]);
      Name n2 = Name.parse(null);
      Name n3 = Name.parse("");
      Name n4 = Name.parse(namesList2[0]);
      Name n5 = Name.parse(namesList1[0]);

      log.debug(n5.components);
      expect(n1, null);
      expect(n2, null);
      expect(n3, null);
      expect(n4, null);
    });
  });
}
