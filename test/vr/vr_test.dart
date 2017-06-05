// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> and Binyak Behera <binayak.b@mwebware.com>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';
import 'package:test_tools/tools.dart';

final Logger log = new Logger('uint_test.dart', watermark: Severity.debug);

//Urgent: why is every test a group by itself
void main() {
  //printCode();
  vrMapAndListTest();
  integerVRsTest();
  stringVRsTest();
}

void vrMapAndListTest() {
  test("Check vrMap and vrList have equal Lengths", () {
    int mapLength = VR.vrMap.length;
    int listLength = VR.vrList.length;
    expect(mapLength == listLength, true);
  });
  test("Check vrList vs vrMap", () {
    log.debug('Check vr16itCodeList');
    for (int i = 1; i < VR.vrList.length; i++) {
      VR vr0 = VR.vrList[i];
      int code = vr0.code;
      VR vr1 = VR.vrMap[code];
      expect(vr0, equals(vr1));
    }
  });
}

void integerVRsTest() {
  RNG rng = new RNG(0);
  group("Integer VRs", () {
    test("isValid", () {
      expect(VR.kAT.isValid(0), true);
      expect(VR.kAT.isValid(Uint32.minValue - 1), false);
      expect(VR.kAT.isValid(Uint32.maxValue), true);
      expect(VR.kAT.isValid(Uint32.maxValue + 1), false);

      expect(VR.kOB.isValid(0), true);
      expect(VR.kOB.isValid(Uint8.minValue - 1), false);
      expect(VR.kOB.isValid(Uint8.maxValue), true);
      expect(VR.kOB.isValid(Uint8.maxValue + 1), false);

      expect(VR.kOL.isValid(0), true);
      expect(VR.kOL.isValid(Uint32.minValue - 1), false);
      expect(VR.kOL.isValid(Uint32.maxValue), true);
      expect(VR.kOL.isValid(Uint32.maxValue + 1), false);

      expect(VR.kOW.isValid(0), true);
      expect(VR.kOW.isValid(Uint16.minValue - 1), false);
      expect(VR.kOW.isValid(Uint16.maxValue), true);
      expect(VR.kOW.isValid(Uint16.maxValue + 1), false);

      expect(VR.kSL.isValid(Int32.minValue), true);
      expect(VR.kSL.isValid(Int32.minValue - 1), false);
      expect(VR.kSL.isValid(Int32.maxValue), true);
      expect(VR.kSL.isValid(Int32.maxValue + 1), false);

      expect(VR.kSS.isValid(Int16.minValue), true);
      expect(VR.kSS.isValid(Int16.minValue - 1), false);
      expect(VR.kSS.isValid(Int16.maxValue), true);
      expect(VR.kSS.isValid(Int16.maxValue + 1), false);

      expect(VR.kUL.isValid(0), true);
      expect(VR.kUL.isValid(Uint32.minValue - 1), false);
      expect(VR.kUL.isValid(Uint32.maxValue), true);
      expect(VR.kUL.isValid(Uint32.maxValue + 1), false);

      expect(VR.kUS.isValid(0), true);
      expect(VR.kUS.isValid(Uint16.minValue - 1), false);
      expect(VR.kUS.isValid(Uint16.maxValue), true);
      expect(VR.kUS.isValid(Uint16.maxValue + 1), false);
    });

    test("isValid VR.kUN", () {
      log.debug(VR.kUN.isValid(Uint8.minValue));
      expect(VR.kUN.isValid(Uint8.minValue), true);
      expect(VR.kUN.isValid(Uint8.minValue - 1), false);
      expect(VR.kUN.isValid(Uint8.maxValue), true);
      expect(VR.kUN.isValid(Uint8.maxValue + 1), false);
    });

    bool isValidList<E>(List<E> list, bool pred(E value)) {
      for (E value in list) {
        if (pred(value) != true) {
          log.debug('Invalid: $value');
          return false;
        }
      }
      return true;
    }

    test("isValidList", () {
      //kAT
      Uint32List validATList = rng.uint32List(20, 20 + rng.nextUint8);
      expect(isValidList(validATList, VR.kAT.isValid), true);

      List<int> invalidATList = <int>[];
      invalidATList
        ..addAll(validATList)
        ..add(Uint32.maxValue + 1);
      expect(isValidList(invalidATList, VR.kAT.isValid), false);

      invalidATList = <int>[];
      invalidATList
        ..addAll(validATList)
        ..add(Uint32.minValue - 1);
      expect(isValidList(invalidATList, VR.kAT.isValid), false);

      //KOB
      Uint8List u8ListkOB = rng.uint8List(10, 200);
      expect(isValidList(u8ListkOB, VR.kOB.isValid), true);

      List<int> u8ListkOBN = <int>[];
      u8ListkOBN
        ..addAll(u8ListkOB)
        ..add(Uint8.maxValue + 1);
      expect(isValidList(u8ListkOBN, VR.kOB.isValid), false);

      u8ListkOBN = <int>[];
      u8ListkOBN
        ..addAll(u8ListkOB)
        ..add(Uint8.minValue - 1);
      expect(isValidList(u8ListkOBN, VR.kOB.isValid), false);

      //kOL
      Uint32List u32ListkOL = rng.uint32List(20, 100);
      expect(isValidList(u32ListkOL, VR.kOL.isValid), true);

      List<int> u32ListkOLN = <int>[];
      u32ListkOLN
        ..addAll(u32ListkOL)
        ..add(Uint32.maxValue + 1);
      expect(isValidList(u32ListkOLN, VR.kOL.isValid), false);

      u32ListkOLN = <int>[];
      u32ListkOLN
        ..addAll(u32ListkOL)
        ..add(Uint32.minValue - 1);
      expect(isValidList(u32ListkOLN, VR.kOL.isValid), false);

      //kOW
      Uint16List u16ListkOW = rng.uint16List(20, 500);
      expect(isValidList(u16ListkOW, VR.kOW.isValid), true);

      List<int> u16ListkOWN = <int>[];
      u16ListkOWN
        ..addAll(u16ListkOW)
        ..add(Uint16.maxValue + 1);
      expect(isValidList(u16ListkOWN, VR.kOW.isValid), false);

      u16ListkOWN = <int>[];
      u16ListkOWN
        ..addAll(u16ListkOW)
        ..add(Uint16.minValue - 1);
      expect(isValidList(u16ListkOWN, VR.kOW.isValid), false);

      //kSL
      Uint8List u8ListkSL = rng.uint8List(20, 60);
      Int32List i32kSL = Int32.fromBytes(u8ListkSL);
      expect(isValidList(i32kSL, VR.kSL.isValid), true); //Good input

      List<int> i32kSLN = <int>[];
      i32kSLN
        ..addAll(i32kSL)
        ..add(Int32.maxValue + 1);
      expect(isValidList(i32kSLN, VR.kSL.isValid), false); //Bad input

      i32kSLN = <int>[];
      i32kSLN
        ..addAll(i32kSL)
        ..add(Int32.minValue - 1);
      expect(isValidList(i32kSLN, VR.kSL.isValid), false); //Bad input

      //kSS
      Uint8List u8ListkSS = rng.uint8List(20, 100);
      Int16List i16kSS = Int16.fromBytes(u8ListkSS);
      expect(isValidList(i16kSS, VR.kSS.isValid), true);
      List<int> i16kSSN = <int>[];
      i16kSSN
        ..addAll(i16kSS)
        ..add(Int16.maxValue + 1);
      expect(isValidList(i16kSSN, VR.kSS.isValid), false);
      i16kSSN = <int>[];
      i16kSSN
        ..addAll(i16kSS)
        ..add(Int16.minValue - 1);
      expect(isValidList(i16kSSN, VR.kSS.isValid), false);

      //kUL
      Uint32List u32ListkUL = rng.uint32List(20, 100);
      expect(isValidList(u32ListkUL, VR.kUL.isValid), true);

      List<int> invalidULList = <int>[];
      invalidULList
        ..addAll(u32ListkUL)
        ..add(Uint32.maxValue + 1);
      expect(isValidList(invalidULList, VR.kUL.isValid), false);

      invalidULList = <int>[];
      invalidULList
        ..addAll(u32ListkUL)
        ..add(Uint32.minValue - 1);
      expect(isValidList(invalidULList, VR.kUL.isValid), false);

      //kUN
      Uint8List validUNList = rng.uint8List(10, 200);
      log.debug(validUNList);
      expect(isValidList(validUNList, VR.kUN.isValid), true);

      List<int> invalidUNList = <int>[];
      invalidUNList
        ..addAll(validUNList)
        ..add(Uint8.maxValue + 1);
      expect(isValidList(invalidUNList, VR.kUN.isValid), false);

      invalidUNList = <int>[];
      invalidUNList
        ..addAll(validUNList)
        ..add(Uint8.minValue - 1);
      expect(isValidList(invalidUNList, VR.kUN.isValid), false);

      //kUS
      Uint16List u16ListkUS = rng.uint16List(20, 100);
      expect(isValidList(u16ListkUS, VR.kUS.isValid), true);

      List<int> u16ListkUSN = <int>[];
      List<int> sdf = new List();
      sdf.addAll(u16ListkUS);
      sdf.add(Uint16.maxValue + 1);
      expect(isValidList(sdf, VR.kUS.isValid), false);
      u16ListkUSN
        ..addAll(u16ListkUS)
        ..add(Uint16.maxValue + 1);
      expect(isValidList(u16ListkUSN, VR.kUS.isValid), false);

      u16ListkUSN = <int>[];
      u16ListkUSN
        ..addAll(u16ListkUS)
        ..add(Uint16.minValue - 1);
      expect(isValidList(u16ListkUSN, VR.kUS.isValid), false);
    });

    test("issue  ee", () {
      expect(VR.kAT.issues(Uint32.minValue), null);
      expect(VR.kAT.issues(Uint32.maxValue), null);
      log.debug(VR.kAT.issues(Uint32.maxValue + 1));
      log.debug(VR.kAT.issues(Uint32.minValue - 1));

      expect(VR.kUS.issues(Uint16.minValue), null);
      expect(VR.kUS.issues(Uint16.maxValue), null);
      log.debug(VR.kUS.issues(Uint16.maxValue + 1));
      log.debug(VR.kUS.issues(Uint16.minValue - 1));

      expect(VR.kSL.issues(Int32.minValue), null);
      expect(VR.kSL.issues(Int32.maxValue), null);
      log.debug(VR.kSL.issues(Int32.maxValue + 1));
      log.debug(VR.kSL.issues(Int32.minValue - 1));

      expect(VR.kUN.issues(Uint8.minValue), null);
      expect(VR.kUN.issues(Uint8.maxValue), null);
      log.debug(VR.kUN.issues(Uint8.maxValue + 1));
      log.debug(VR.kUN.issues(Uint8.minValue - 1));
    });

    test("fix", () {
      expect(VR.kAT.fix(Uint32.minValue - 1), Uint32.minValue);
      expect(VR.kAT.fix(Uint32.maxValue + 1), Uint32.maxValue);

      expect(VR.kUS.fix(Uint16.minValue - 1), Uint16.minValue);
      expect(VR.kUS.fix(Uint16.maxValue + 1), Uint16.maxValue);

      expect(VR.kSL.fix(Int32.minValue - 1), Int32.minValue);
      expect(VR.kSL.fix(Int32.maxValue + 1), Int32.maxValue);

      log.debug('fix(-1): ${VR.kUN.fix(-1)}');
      log.debug('fix(256): ${VR.kUN.fix(-1)}');
      log.debug('fix(128): ${VR.kUN.fix(128)}');
      expect(VR.kUN.fix(Uint8.minValue - 1), null);
      expect(VR.kUN.fix(Uint8.maxValue + 1), null);
    });

    test("view", () {
      Uint32List u32List = rng.uint32List(10, 20);
      log.debug('u32List: $u32List');
      //Urgent: decide if .view should be in tag or element
      //log.debug(VR.kAT.view(u32List));
    }, skip: 'Needs to add expects...');
  });
}

void stringVRsTest() {
  group("VRDcmString", () {
    RSG rsg = new RSG(0);
    test("isValid", () {
      //kAE
      for (int i = 0; i < 10; i++) {
        var vList = rsg.getAEList(1, 10, 1, 16);
        print('vList: $vList');
        expect(VR.kAE.isValid(vList), true);
      }

      var vList1 = rsg.getAEList(
          1, 10, VR.kAE.maxValueLength + 1, VR.kAE.maxValueLength + 1);
      expect(VR.kAE.isValid(vList1), false);
      expect(VR.kAE.isValid(""), false);
      expect(VR.kAE.isValid(null), false);

      //kLO
      for (int i = 0; i < 10; i++) {
        var vList2 = rsg.getLOList(1, 10, 1, VR.kLO.maxValueLength);
        expect(VR.kLO.isValid(vList2), true);
      }

      var vList3 = rsg.getLOList(
          1, 10, VR.kLO.maxValueLength + 1, VR.kLO.maxValueLength + 1);
      expect(VR.kLO.isValid(vList3), false);
      expect(VR.kLO.isValid(""), false);

      //kSH
      for (int i = 0; i < 10; i++) {
        var vList4 = rsg.getSHList(1, 10, 1, VR.kSH.maxValueLength);
        expect(VR.kSH.isValid(vList4), true);
      }

      var vList5 = rsg.getSHList(1, 10, 1, VR.kSH.maxValueLength);
      expect(VR.kSH.isValid(vList5), false);
      expect(VR.kSH.isValid(""), false);

      //kUC
      for (int i = 0; i < 10; i++) {
        var vList6 = rsg.getUCList(1024);
        expect(VR.kUC.isValid(vList6), true);
      }

      expect(VR.kUC.isValid(""), false);
    });
  });

  group("VR", () {
    RSG rsg = new RSG(0);
    test("isValid", () {
      //kLT
      for (int i = 0; i < 10; i++) {
        var vList0 = rsg.getLTList(1, 10, 1, VR.kLT.maxValueLength);
        expect(VR.kLT.isValid(vList0), true);
      }

      var vList1 = rsg.getLTList(
          1, 10, VR.kLT.maxValueLength + 1, VR.kLT.maxValueLength + 1);
      expect(VR.kLT.isValid(vList1), false);
      expect(VR.kLT.isValid(""), false);

      //kST
      for (int i = 0; i < 10; i++) {
        var vList2 = rsg.getSTList(VR.kST.maxValueLength);
        expect(VR.kST.isValid(vList2), true);
      }

      var vList3 = rsg.getSTList(VR.kST.maxValueLength + 1);
      expect(VR.kST.isValid(vList3), false);
      expect(VR.kST.isValid(""), false);

      //kUT
      for (int i = 0; i < 10; i++) {
        var vList4 = rsg.getUTList(1024);
        expect(VR.kUT.isValid(vList4), true);
      }

      expect(VR.kUT.isValid(""), false);
    });
  });
  group("VRCodeString", () {
    RSG rsg = new RSG(0);
    test("isValid", () {
      //kCS
      for (int i = 0; i < 10; i++) {
        var vList0 = rsg.getCSList(1, 10, 1, VR.kLT.maxValueLength);
        expect(VR.kCS.isValid(vList0), true);
      }

      var vList1 = rsg.getCSList(
          1, 10, VR.kLT.maxValueLength + 1, VR.kLT.maxValueLength + 1);
      expect(VR.kCS.isValid(vList1), false);
      expect(VR.kCS.isValid(""), false);
    });
  });

  group("VRDcmAge", () {
   // RSG rsg = new RSG(0);
    test("isValid", () {
      //kAS
      var vList0 = ["125M"];
      expect(VR.kAS.isValid(vList0), true);

      var vList1 = ["1025M"];
      expect(VR.kAS.isValid(vList1), false);

      vList1 = ["102K"];
      expect(VR.kAS.isValid(vList0), false);

      vList1 = ["102m"];
      expect(VR.kAS.isValid(vList1), false);
    });
  });

  group("VRDcmDate", () {
   // RSG rsg = new RSG(0);
    test("isValid", () {
      expect(VR.kDA.isValid("19680518"), true);
      expect(VR.kDA.isValid("20161231"), true);
      expect(VR.kDA.isValid("18051988"), false); //verify:PLEASE CHECK
      expect(VR.kDA.isValid("18-05-1988"), false);
      expect(VR.kDA.isValid("18/05/1968"), false);
    });
  });
  group("VRFloatString", () {
  //  RSG rsg = new RSG(0);
    test("isValid", () {
      expect(VR.kDS.isValid("18443232.42"), true);
      expect(VR.kDS.isValid("18443232.4243423"), true);
      expect(VR.kDS.isValid("1844323233.4243423"), false);
      expect(VR.kDS.isValid("18443232.42M"), false);
    });
  });

  group("VRDcmDateTime", () {
   // RSG rsg = new RSG(0);
    test("isValid", () {
      //verify: space between data and time?
      log.debug(VR.kDT.isValid("20170314 124603.424306"));
      //verify: no space
      log.debug(VR.kDT.isValid("20170314124603.424306"));
    });
  });

  group("VRIntString", () {
   // RSG rsg = new RSG(0);
    test("isValid VRString", () {
      expect(VR.kIS.isValid("567891234567"), true);
      expect(VR.kIS.isValid("5678912345671"), false);
      expect(VR.kIS.isValid("567891234.67"), false);
      expect(VR.kIS.isValid(""), false);
    });
  });

  group("VRPersonName", () {
    RSG rsg = new RSG(0);
    test("isValid VRPersonName", () {
      //noOfgroups=3, noOfomponents=5, componentLength=8
      var vList0 = rsg.getPNList(3, 5, 8);
      expect(VR.kPN.isValid(vList0), true);

      //noOfgroups=3, noOfomponents=5, componentLength=11
      vList0 = rsg.getPNList(3, 5, 11);
      expect(VR.kPN.isValid(vList0), true);

      //noOfgroups=3, noOfomponents=5, componentLength=13
      vList0 = rsg.getPNList(3, 5, 13);
      expect(VR.kPN.isValid(vList0), false);

      //noOfgroups=2, noOfomponents=5, componentLength=13
      vList0 = rsg.getPNList(2, 5, 13);
      expect(VR.kPN.isValid(vList0), false);
    }, skip: 'need getPNList to be implemented');
  });

  group("VRDcmTime", () {
    test("isValid VRDcmTime", () {
  //    RSG rsg = new RSG(0);
      expect(VR.kTM.isValid("070907.0705"), true);
      expect(VR.kTM.isValid("070907.070590"), true);
      expect(VR.kTM.isValid("070907.07059099"), false);
      expect(VR.kTM.isValid("070907.07059U"), false);
    });
  });

  group("VRUid", () {
    test("isValid VRUid", () {
  //    RSG rsg = new RSG(0);
      expect(VR.kUI.isValid("1.2.840.444.3.152.235.2.12.187636473"), true);
      expect(
          VR.kUI.isValid(
              "1.2.840.444.3.152.235.2.12.187636473.435345.345435435.435435435435.3"),
          false);
    });
  });
}
