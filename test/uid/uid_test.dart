// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/uid/well_known/transfer_syntax.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';
import 'package:test/test.dart';

final Logger log = new Logger('Uid2_Test', watermark: Severity.info);

void main() {
  uidTest();
}

//TODO: add goodUids from test files
List<String> goodUids = const <String>[
  "1.2.840.10008.1.2",
  "1.2.840.10008.1.2.0",
  "1.2.840.10008.0.1.2"
];

//TODO: create more bad Uids
List<String> badUids = const <String>[
  "3.2.840.10008.1.2.0", // "3.": not valid root
  "1.02.840.10008.1.2",  // ".02": "0" can only be followed by "."
  "1.2.840.10008.0.1.2."  // ".2.": uid can't end with dot
];
void uidTest() {
  group('Uid Tests', () {

    //TODO: create a list of well known strings, Uids, and the corresponding
    //      WKUids and test equivalence.
    test('Well Known UIDs', () {
        Uid uid = Uid.parse("1.2.840.10008.1.2");
        expect(uid == WKUid.kImplicitVRLittleEndian, true);
        expect(uid.asString, equals("1.2.840.10008.1.2"));
        uid = Uid.parse("1.2.840.10008.1.2.1");
        expect(uid == WKUid.kExplicitVRLittleEndian, true);

    });

    test('Good UIDs', () {
      for(String s in goodUids) {
        Uid uid = Uid.parse(s);
        expect(uid, isNotNull);
        expect(uid is Uid, true);
        expect(uid.asString, equals(s));
      }
    });

    test('Bad String to UID should fail', () {
      // Bad letter 'Z'
      Uid uid = Uid.parse("1.2.8z0.10008.1.2");
      expect(uid == null, true);
      //TODO: this should return null or
      uid = Uid.parse("4.2.840.10008.1.2");
      log.debug('uid: $uid');
      expect(uid == null, true);
    });

    test('Bad UIDs', () {
      for(String s in badUids) {
        expect(Uid.isValidString(s), false);
        Uid uid = Uid.parse(s);
        expect(uid, isNull);
        expect(uid is Uid, false);
      }
    });

    test('String to TransferSyntax', () {
      Uid uid = TransferSyntax.lookup("1.2.840.10008.1.2");
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      uid = TransferSyntax.lookup("1.2.840.10008.1.2.1");
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
    });
  });
}
