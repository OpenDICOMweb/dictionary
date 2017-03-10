// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/uid/uid_utils.dart';
import 'package:test/test.dart';

void main() {
  uidTest2();
}

void uidTest2() {
  var goodUids = [
    "0.20.3000",
    "1.20.3000",
    "2.20.3000",
    "0.3.0.812345",
    "1.2.840.10008.1.2.4.58",
    "1.2.840.10008.1.2.4.61"
  ];

  group('Good Uids Test', () {
    test('Good UID', () {
      for (String s in goodUids) {
        var v = isValidUidString(s);
        print('$v: $s');
        expect(isValidUidString(s), true);
      }
    });
  });

  var badUids = [
    // Bad root
    "3.20.3000",
    // Bad root
    "4.A0.3000",
    // '.0' must be followed by '.'
    "2.01.3000",
    // Invalid char 'g
    "0.A0.0.abcdeg",
    // Invalid char '_'
    "2.C0.-bcdef",
    // Can't end in '.'
    "1.B0.abcde.",
    // length too short
    "1.25",
    // Length too long
    "1.25.111111111111111111111111111111111111111111111111111111111111111111111"
  ];

  group('Bad Uids Test', () {
    test('Bad UID', () {
      for (String s in badUids) {
        print('"$s":');
        var v = isValidUidString(s);
        print('"$s": $v');
        expect(isValidUidString(s), false);
      }
    });
  });
}
