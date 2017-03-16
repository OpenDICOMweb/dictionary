// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> and Binyak Behera <binayak.b@mwebware.com>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/integer.dart';
import 'package:common/logger.dart';
import 'package:common/src/random/rng.dart';
import 'package:dictionary/src/vr/integer.dart';
import 'package:dictionary/src/vr/string.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';
import 'package:test_tools/src/random/random_string.dart' as rsg;

void main() {
  //printCode();
  vrMapAndListTest();
  integerVRsTest();
  stringVRsTest();
}

Logger log = new Logger('test', watermark: Severity.debug);
void vrMapAndListTest() {
  test("Check vrMap and vrList have equal Lengths", () {
    int mapLength = VR.vrMap.length;
    int listLength = VR.vrList.length;
    expect(mapLength == listLength, true);
  });
  test("Check vrList vs vrMap", () {
    print('Check vr16itCodeList');
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
      expect(VRInt.kAT.isValid(0), true);
      expect(VRInt.kAT.isValid(Uint32.minValue - 1), false);
      expect(VRInt.kAT.isValid(Uint32.maxValue), true);
      expect(VRInt.kAT.isValid(Uint32.maxValue + 1), false);

      expect(VRInt.kOB.isValid(0), true);
      expect(VRInt.kOB.isValid(Uint8.minValue - 1), false);
      expect(VRInt.kOB.isValid(Uint8.maxValue), true);
      expect(VRInt.kOB.isValid(Uint8.maxValue + 1), false);

      expect(VRInt.kOL.isValid(0), true);
      expect(VRInt.kOL.isValid(Uint32.minValue - 1), false);
      expect(VRInt.kOL.isValid(Uint32.maxValue), true);
      expect(VRInt.kOL.isValid(Uint32.maxValue + 1), false);

      expect(VRInt.kOW.isValid(0), true);
      expect(VRInt.kOW.isValid(Uint16.minValue - 1), false);
      expect(VRInt.kOW.isValid(Uint16.maxValue), true);
      expect(VRInt.kOW.isValid(Uint16.maxValue + 1), false);

      expect(VRInt.kSL.isValid(Int32.minValue), true);
      expect(VRInt.kSL.isValid(Int32.minValue - 1), false);
      expect(VRInt.kSL.isValid(Int32.maxValue), true);
      expect(VRInt.kSL.isValid(Int32.maxValue + 1), false);

      expect(VRInt.kSS.isValid(Int16.minValue), true);
      expect(VRInt.kSS.isValid(Int16.minValue - 1), false);
      expect(VRInt.kSS.isValid(Int16.maxValue), true);
      expect(VRInt.kSS.isValid(Int16.maxValue + 1), false);

      expect(VRInt.kUL.isValid(0), true);
      expect(VRInt.kUL.isValid(Uint32.minValue - 1), false);
      expect(VRInt.kUL.isValid(Uint32.maxValue), true);
      expect(VRInt.kUL.isValid(Uint32.maxValue + 1), false);

      expect(VRInt.kUN.isValid(0), true);
      expect(VRInt.kUN.isValid(Uint8.minValue - 1), false);
      expect(VRInt.kUN.isValid(Uint8.maxValue), true);
      expect(VRInt.kUN.isValid(Uint8.maxValue + 1), false);

      expect(VRInt.kUS.isValid(0), true);
      expect(VRInt.kUS.isValid(Uint16.minValue - 1), false);
      expect(VRInt.kUS.isValid(Uint16.maxValue), true);
      expect(VRInt.kUS.isValid(Uint16.maxValue + 1), false);
    });

    test("isValidList", () {
      //kAT
      Uint32List u32LstkAT = rng.uint32List(20, 20 + rng.nextUint8);
      //Int8List i8 = Int8.fromBytes(bytes);
      expect(VRInt.kAT.isValidList(u32LstkAT), true);

      List<int> u32LstkATN = <int>[];
      u32LstkATN
        ..addAll(u32LstkAT)
        ..add(Uint32.maxValue + 1);
      expect(VRInt.kAT.isValidList(u32LstkATN), false);

      u32LstkATN = <int>[];
      u32LstkATN
        ..addAll(u32LstkAT)
        ..add(Uint32.minValue - 1);
      expect(VRInt.kAT.isValidList(u32LstkATN), false);

      //KOB
      Uint8List u8ListkOB = rng.uint8List(10, 200);
      expect(VRInt.kOB.isValidList(u8ListkOB), true);

      List<int> u8ListkOBN = <int>[];
      u8ListkOBN
        ..addAll(u8ListkOB)
        ..add(Uint8.maxValue + 1);
      expect(VRInt.kOB.isValidList(u8ListkOBN), false);

      u8ListkOBN = <int>[];
      u8ListkOBN
        ..addAll(u8ListkOB)
        ..add(Uint8.minValue - 1);
      expect(VRInt.kOB.isValidList(u8ListkOBN), false);

      //kOL
      Uint32List u32ListkOL = rng.uint32List(20, 100);
      expect(VRInt.kOL.isValidList(u32ListkOL), true);

      List<int> u32ListkOLN = <int>[];
      u32ListkOLN
        ..addAll(u32ListkOL)
        ..add(Uint32.maxValue + 1);
      expect(VRInt.kOL.isValidList(u32ListkOLN), false);

      u32ListkOLN = <int>[];
      u32ListkOLN
        ..addAll(u32ListkOL)
        ..add(Uint32.minValue - 1);
      expect(VRInt.kOL.isValidList(u32ListkOLN), false);

      //kOW
      Uint16List u16ListkOW = rng.uint16List(20, 500);
      expect(VRInt.kOW.isValidList(u16ListkOW), true);

      List<int> u16ListkOWN = <int>[];
      u16ListkOWN
        ..addAll(u16ListkOW)
        ..add(Uint16.maxValue + 1);
      expect(VRInt.kOW.isValidList(u16ListkOWN), false);

      u16ListkOWN = <int>[];
      u16ListkOWN
        ..addAll(u16ListkOW)
        ..add(Uint16.minValue - 1);
      expect(VRInt.kOW.isValidList(u16ListkOWN), false);

      //kSL
      Uint8List u8ListkSL = rng.uint8List(20, 60);
      Int32List i32kSL = Int32.fromBytes(u8ListkSL);
      expect(VRInt.kSL.isValidList(i32kSL), true); //Good input

      List<int> i32kSLN = <int>[];
      i32kSLN
        ..addAll(i32kSL)
        ..add(Int32.maxValue + 1);
      expect(VRInt.kSL.isValidList(i32kSLN), false); //Bad input

      i32kSLN = <int>[];
      i32kSLN
        ..addAll(i32kSL)
        ..add(Int32.minValue - 1);
      expect(VRInt.kSL.isValidList(i32kSLN), false); //Bad input

      //kSS
      Uint8List u8ListkSS = rng.uint8List(20, 100);
      Int16List i16kSS = Int16.fromBytes(u8ListkSS);
      expect(VRInt.kSS.isValidList(i16kSS), true);
      List<int> i16kSSN = <int>[];
      i16kSSN
        ..addAll(i16kSS)
        ..add(Int16.maxValue + 1);
      expect(VRInt.kSS.isValidList(i16kSSN), false);
      i16kSSN = <int>[];
      i16kSSN
        ..addAll(i16kSS)
        ..add(Int16.minValue - 1);
      expect(VRInt.kSS.isValidList(i16kSSN), false);

      //kUL
      Uint32List u32ListkUL = rng.uint32List(20, 100);
      expect(VRInt.kUL.isValidList(u32ListkUL), true);

      List<int> u32ListkULN = <int>[];
      u32ListkULN
        ..addAll(u32ListkUL)
        ..add(Uint32.maxValue + 1);
      expect(VRInt.kUL.isValidList(u32ListkULN), false);

      u32ListkULN = <int>[];
      u32ListkULN
        ..addAll(u32ListkUL)
        ..add(Uint32.minValue - 1);
      expect(VRInt.kUL.isValidList(u32ListkULN), false);

      //kUN
      Uint8List u8ListkUN = rng.uint8List(10, 200);
      expect(VRInt.kUN.isValidList(u8ListkUN), true);

      List<int> u8ListkUNN = <int>[];
      u8ListkUNN
        ..addAll(u8ListkUN)
        ..add(Uint8.maxValue + 1);
      expect(VRInt.kUN.isValidList(u8ListkUNN), false);

      u8ListkUNN = <int>[];
      u8ListkUNN
        ..addAll(u8ListkUN)
        ..add(Uint8.minValue - 1);
      expect(VRInt.kUN.isValidList(u8ListkUNN), false);

      //kUS
      Uint16List u16ListkUS = rng.uint16List(20, 100);
      expect(VRInt.kUS.isValidList(u16ListkUS), true);

      List<int> u16ListkUSN = <int>[];
      List<int> sdf = new List();
      sdf.addAll(u16ListkUS);
      sdf.add(Uint16.maxValue + 1);
      expect(VRInt.kUS.isValidList(sdf), false);
      u16ListkUSN
        ..addAll(u16ListkUS)
        ..add(Uint16.maxValue + 1);
      expect(VRInt.kUS.isValidList(u16ListkUSN), false);

      u16ListkUSN = <int>[];
      u16ListkUSN
        ..addAll(u16ListkUS)
        ..add(Uint16.minValue - 1);
      expect(VRInt.kUS.isValidList(u16ListkUSN), false);
    });

    test("issue  ee", () {
      expect(VRInt.kAT.issue(Uint32.minValue), null);
      expect(VRInt.kAT.issue(Uint32.maxValue), null);
      log.debug(VRInt.kAT.issue(Uint32.maxValue + 1));
      log.debug(VRInt.kAT.issue(Uint32.minValue - 1));

      expect(VRInt.kUS.issue(Uint16.minValue), null);
      expect(VRInt.kUS.issue(Uint16.maxValue), null);
      log.debug(VRInt.kUS.issue(Uint16.maxValue + 1));
      log.debug(VRInt.kUS.issue(Uint16.minValue - 1));

      expect(VRInt.kSL.issue(Int32.minValue), null);
      expect(VRInt.kSL.issue(Int32.maxValue), null);
      log.debug(VRInt.kSL.issue(Int32.maxValue + 1));
      log.debug(VRInt.kSL.issue(Int32.minValue - 1));

      expect(VRInt.kUN.issue(Uint8.minValue), null);
      expect(VRInt.kUN.issue(Uint8.maxValue), null);
      log.debug(VRInt.kUN.issue(Uint8.maxValue + 1));
      log.debug(VRInt.kUN.issue(Uint8.minValue - 1));
    });

    test("fix", () {
      expect(VRInt.kAT.fix(Uint32.minValue - 1), Uint32.minValue);
      expect(VRInt.kAT.fix(Uint32.maxValue + 1), Uint32.maxValue);

      expect(VRInt.kUS.fix(Uint16.minValue - 1), Uint16.minValue);
      expect(VRInt.kUS.fix(Uint16.maxValue + 1), Uint16.maxValue);

      expect(VRInt.kSL.fix(Int32.minValue - 1), Int32.minValue);
      expect(VRInt.kSL.fix(Int32.maxValue + 1), Int32.maxValue);

      expect(VRInt.kUN.fix(Uint8.minValue - 1), Uint8.minValue);
      expect(VRInt.kUN.fix(Uint8.maxValue + 1), Uint8.maxValue);
    });

    /*test("view", ()
    {
      Uint8List u8List = rng.uint8List(10, 20);
      print(VRInt.kAT.view(u8List));
    });*/
  });
}

void stringVRsTest() {
  group("VRDcmString", () {
    test("isValid", () {
      //kAE
      for (int i = 0; i < 10; i++) {
        String strValidkAE = rsg.generateDcmChar(VRDcmString.kAE.maxValue);
        expect(VRDcmString.kAE.isValid(strValidkAE), true);
      }

      String strInValidkAE = rsg.generateDcmChar(VRDcmString.kAE.maxValue + 1);
      expect(VRDcmString.kAE.isValid(strInValidkAE), false);
      expect(VRDcmString.kAE.isValid(""), false);
      expect(VRDcmString.kAE.isValid(null), false);

      //kLO
      for (int i = 0; i < 10; i++) {
        String strValidkLO = rsg.generateDcmChar(VRDcmString.kLO.maxValue);
        expect(VRDcmString.kLO.isValid(strValidkLO), true);
      }

      String strInValidkLO = rsg.generateDcmChar(VRDcmString.kLO.maxValue + 1);
      expect(VRDcmString.kLO.isValid(strInValidkLO), false);
      expect(VRDcmString.kLO.isValid(""), false);

      //kSH
      for (int i = 0; i < 10; i++) {
        String strValidkSH = rsg.generateDcmChar(VRDcmString.kSH.maxValue);
        expect(VRDcmString.kSH.isValid(strValidkSH), true);
      }

      String strInValidkSH = rsg.generateDcmChar(VRDcmString.kSH.maxValue + 1);
      expect(VRDcmString.kSH.isValid(strInValidkSH), false);
      expect(VRDcmString.kSH.isValid(""), false);

      //kUC
      for (int i = 0; i < 10; i++) {
        String strValidkUC = rsg.generateDcmChar(1024);
        expect(VRDcmString.kUC.isValid(strValidkUC), true);
      }

      expect(VRDcmString.kUC.isValid(""), false);
    });
  });
  group("VRDcmString", () {
    test("isValid", () {
      //kLT
      for (int i = 0; i < 10; i++) {
        String strValidkLT = rsg.generateTextChar(VRDcmText.kLT.maxValue);
        expect(VRDcmText.kLT.isValid(strValidkLT), true);
      }

      String strInValidkLT = rsg.generateTextChar(VRDcmText.kLT.maxValue + 1);
      expect(VRDcmText.kLT.isValid(strInValidkLT), false);
      expect(VRDcmText.kLT.isValid(""), false);

      //kST
      for (int i = 0; i < 10; i++) {
        String strValidkST = rsg.generateTextChar(VRDcmText.kST.maxValue);
        expect(VRDcmText.kST.isValid(strValidkST), true);
      }

      String strInValidkST = rsg.generateTextChar(VRDcmText.kST.maxValue + 1);
      expect(VRDcmText.kST.isValid(strInValidkST), false);
      expect(VRDcmText.kST.isValid(""), false);

      //kUT
      for (int i = 0; i < 10; i++) {
        String strValidkUT = rsg.generateTextChar(1024);
        expect(VRDcmText.kUT.isValid(strValidkUT), true);
      }

      expect(VRDcmText.kUT.isValid(""), false);
    });
  });
  group("VRCodeString", () {
    test("isValid", () {
      //kCS
      for (int i = 0; i < 10; i++) {
        String strValid = rsg.generateCodeStringChar(VRCodeString.kCS.maxValue);
        expect(VRCodeString.kCS.isValid(strValid), true);
      }

      String strInValid = rsg.generateDcmChar(VRCodeString.kCS.maxValue + 1);
      expect(VRCodeString.kCS.isValid(strInValid), false);
      expect(VRCodeString.kCS.isValid(""), false);
    });
  });

  group("VRDcmAge", () {
    test("isValid", () {
      //kAS
      String strValid = "125M";
      expect(VRDcmAge.kAS.isValid(strValid), true);

      String strValidInvalid = "1025M";
      expect(VRDcmAge.kAS.isValid(strValidInvalid), false);

      strValidInvalid = "102K";
      expect(VRDcmAge.kAS.isValid(strValidInvalid), false);

      strValidInvalid = "102m";
      expect(VRDcmAge.kAS.isValid(strValidInvalid), false);
    });
  });
  group("VRDcmDate", () {
    test("isValid", () {
      expect(VRDcmDate.kDA.isValid("19680518"), true);
      expect(VRDcmDate.kDA.isValid("20161231"), true);
      //expect(VRDcmDate.kDA.isValid("18051988"),true);//verify:PLEASE CHECK
      expect(VRDcmDate.kDA.isValid("18-05-1988"), false);
      expect(VRDcmDate.kDA.isValid("18/05/1968"), false);
    });
  });
  group("VRFloatString", () {
    test("isValid", () {
      expect(VRFloatString.kDS.isValid("18443232.42"), true);
      expect(VRFloatString.kDS.isValid("18443232.4243423"), true);
      expect(VRFloatString.kDS.isValid("1844323233.4243423"), false);
      expect(VRFloatString.kDS.isValid("18443232.42M"), false);
    });
  });

  /*group("VRDcmDateTime", () {
    test("isValid", () {
      print(VRDcmDateTime.kDT.isValid("20170314 124603.424306"));//verify: space btwn data and time?
      print(VRDcmDateTime.kDT.isValid("20170314124603.424306"));//verify
    });
  });*/

  group("VRIntString", () {
    test("isValid VRIntString", () {
      expect(VRIntString.kIS.isValid("567891234567"), true);
      expect(VRIntString.kIS.isValid("5678912345671"), false);
      expect(VRIntString.kIS.isValid("567891234.67"), false);
      expect(VRIntString.kIS.isValid(""), false);
    });
  });

  group("VRPersonName", () {
    test("isValid VRPersonName", () {
      //noOfgroups=3, noOfomponents=5, componentLength=8
      String strValid = rsg.generatePersonName(3, 5, 8);
      expect(VRPersonName.kPN.isValid(strValid), true);

      //noOfgroups=3, noOfomponents=5, componentLength=11
      String strInValid = rsg.generatePersonName(3, 5, 11);
      expect(VRPersonName.kPN.isValid(strInValid), true);

      //noOfgroups=3, noOfomponents=5, componentLength=13
      strInValid = rsg.generatePersonName(3, 5, 13);
      expect(VRPersonName.kPN.isValid(strInValid), false);

      //noOfgroups=2, noOfomponents=5, componentLength=13
      strInValid = rsg.generatePersonName(2, 5, 13);
      expect(VRPersonName.kPN.isValid(strInValid), false);
    });
  });

  group("VRDcmTime", () {
    test("isValid VRDcmTime", () {
      expect(VRDcmTime.kTM.isValid("070907.0705"), true);
      expect(VRDcmTime.kTM.isValid("070907.070590"), true);
      expect(VRDcmTime.kTM.isValid("070907.07059099"), false);
      expect(VRDcmTime.kTM.isValid("070907.07059U"), false);
    });
  });

  group("VRUid", () {
    test("isValid VRUid", () {
      expect(VRUid.kUI.isValid("1.2.840.444.3.152.235.2.12.187636473"), true);
      expect(
          VRUid.kUI.isValid(
              "1.2.840.444.3.152.235.2.12.187636473.435345.345435435.435435435435.3"),
          false);
    });
  });
}
