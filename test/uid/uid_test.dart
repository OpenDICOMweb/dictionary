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

void uidTest() {
  group('Uid Tests', () {
    test('String to UID', () {
      Uid uid = Uid.parse("1.2.840.10008.1.2");
      expect(uid == WKUid.kImplicitVRLittleEndian, true);
      expect(uid.asString, equals("1.2.840.10008.1.2"));
      uid = Uid.parse("1.2.840.10008.1.2.1");
      expect(uid == WKUid.kExplicitVRLittleEndian, true);
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

    test('String to TransferSyntax', () {
      Uid uid = TransferSyntax.lookup("1.2.840.10008.1.2");
      expect(uid == TransferSyntax.kImplicitVRLittleEndian, true);
      uid = TransferSyntax.lookup("1.2.840.10008.1.2.1");
      expect(uid == TransferSyntax.kExplicitVRLittleEndian, true);
    });
  });
}
