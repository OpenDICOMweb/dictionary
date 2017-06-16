// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Binayak Behera <binayak.b@mwebware.com> -
// See the AUTHORS file for other contributors.

import 'package:test/test.dart';
import 'package:dictionary/src/vr/vr.dart';

void main() {
  validateTest();
}

void validateTest() {
  group("VR validators", () {
    test("Check hasShortVF", () {
      expect(VR.kFD.hasShortVF, true);
      expect(VR.kFD.hasLongVF, false);
    });

    test("Check hasLongVF", () {
      expect(VR.kOB.hasLongVF, true);
    });

    test("Check isValidLength", () {
      expect(VR.kUC.isValidLength(''.length), false);
      expect(VR.kUC.isValidLength('sdfsdfsadf'.length), true);
      expect(
          VR.kUC.isValidLength(
              'sdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsd'
              'fsdfsadfsdfsdfsadf'.length),
          true);
    });

    test("Check isValid", () {
      expect(VR.kUC.isValid('sdfsdfsadf'), true);
      expect(
          VR.kUC.isValid(
              'sdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsd'
              'fsdfsadfsdfsdfsadf'),
          true);
    });

    test("test for isvalidvalue", () {
      String str = "DART";
      String str1 = "dartDD434 ";
      String str2 = "0123456789";
      String str3 = "DDD_545 ";

      expect(VR.kCS.isValid(str), true);
      expect(VR.kCS.isValid(str1), false);
      expect(VR.kCS.isValid(str2), true);
      expect(VR.kCS.isValid(str3), true);
    });
  });
}
