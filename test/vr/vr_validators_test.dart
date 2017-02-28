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
      expect(VRFloat.kFD.hasShortVF, true);
      expect(VRFloat.kFD.hasLongVF, false);
    });

    test("Check hasLongVF", () {
      expect(VRInt.kOB.hasLongVF, true);
    });

    test("Check isValidLength", () {
      expect(VRLongString.kUC.isValidLength(''), false);
      expect(VRLongString.kUC.isValidLength('sdfsdfsadf'), true);
      expect(
          VRLongString.kUC.isValidLength(
              'sdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsdfsdfsadfsd'
              'fsdfsadfsdfsdfsadf'),
          true);
    });

    test("Check isValid", () {
      expect(VRLongString.kUC.isValid('sdfsdfsadf'), true);
      expect(
          VRLongString.kUC.isValid(
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
