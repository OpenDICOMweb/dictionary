// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Binyak Behera <binayak.b@mwebware.com>
//    and Sharath chandra <sharath.ch@mwebware.com>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/person_name.dart';
import 'package:test/test.dart';

void main() {
  personNameTest();
}

void personNameTest() {
  var pnstr1 =
      "abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  var pnstr2 =
      "abc23de^fhg%&*ij^klm_-\\oo /no^pqrst^uvwxy=zabfdsfdsfcd^efdsfdsfdsfghi^jklwerewrermn^operewrewrewqrs^tuvwrewrewrerwx=yzabc^defgh^ijklm^nopqr^stuvw";

  group("person_name", () {
    test("test for isValidString and isValidList", () {
      PersonName personName = new PersonName.fromString(pnstr1);
      print(personName.toString());
      expect(PersonName.isValidString(pnstr1), true);

      List<String> listNames = pnstr1.split("=");
      expect(PersonName.isValidList(listNames), true);
    });

    test("test for == in PersonName", () {
      PersonName pn1 = new PersonName.fromString(pnstr1);
      PersonName pn2 = new PersonName.fromString(pnstr1);
      print(pn1.hashCode);
      expect(pn1 == pn2, true);
      expect(pn1, equals(pn2));
    });

    test("test for parse", () {
      var pnStr3 =
          "abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=fdf=dsdf";
      PersonName pn = PersonName.parse(pnstr1);
      print("alphabetic: ${pn.alphabetic}");
      print("phonetic: ${pn.phonetic}");
      print("ideographic: ${pn.ideographic}");

      PersonName pn1 = PersonName.parse(pnStr3);
      PersonName pn2 = PersonName.parse("");
      PersonName pn3 = PersonName.parse(null);
      expect(pn1, null);
      expect(pn2, null);
      expect(pn3, null);
    });
  });

  group("Name", () {
    List<String> namesList = pnstr1.split("=");
    List<String> namesList2 = pnstr2.split("=");

    test("test for isValidList", () {
      for (String name in namesList) {
        expect(Name.isValidList(name.split("^")), true);
      }
    });

    test("test for == in Name", () {
      Name name = new Name.fromString(namesList[0]);
      Name name1 = new Name.fromString(namesList[0]);
      Name name2 = new Name.fromString(namesList[1]);
      expect(name == name1, true);
      expect(name == name2, false);
    });

    test("test for isvalidString", () {
      expect(Name.isValidString(namesList[0]), true);
    });

    test("test for parse in Name", () {
      Name n1 = Name.parse(namesList2[1]);
      Name n2 = Name.parse(null);
      Name n3 = Name.parse("");
      Name n4 = Name.parse(namesList2[0]);
      Name n5 = Name.parse(namesList[0]);

      print(n5.components);
      expect(n1, null);
      expect(n2, null);
      expect(n3, null);
      expect(n4, null);
    });
  });
}
