// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/common.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:dictionary/src/vr/vr_index.dart';
import 'package:test/test.dart';

main() {
  //printCode();

  test("Check List Lengths", () {
    int vectorLength = VR.vrs.length;
    print('vrVector Length: $vectorLength');
    int vr8BitCodeListLength = kVR8BitCodeList.length;
    print('vr8BitCodeList Length: $vr8BitCodeListLength');
    int vr16BitCodeListLength = VR.vrs.length;
    print('vr8BitCodeList  Length: $vr16BitCodeListLength');
    expect(vectorLength == vr8BitCodeListLength, true);
    expect(vectorLength == vr16BitCodeListLength, true);
  });

  test("Check vr8BitCodeList", () {
    print('Check vr8itCodeList');
    for (int i = 0; i < VR.vrs.length; i++) {
      int c0 = VR.vrs[i].code;
      int c1 = kVR8BitCodeList[i];
      print('$i: ${VR.vrs[i].info}), ${Uint16.hex(kVR8BitCodeList[i])})');
      print('$i: c0(${Int16.hex(c0)}), c1  (${Int16.hex(c1)})');
      expect(c0 == c1, true);
    }
  });

  test("Check vr16BitCodeList", () {
    print('Check vr16itCodeList');
    for (int i = 0; i < VR.vrs.length; i++) {
      print('vr16(${Int16.hex(VR.vrs[i].code16Bit)}');
      print('vr8(${Int16.hex(VR.vrs[i].code)}');
      print('kVR16(${Int16.hex(kVR16BitCodeList[i])}');
      expect(VR.vrs[i].code16Bit == kVR16BitCodeList[i], true);
    }
  });

  test("Test vrCodes 8 & 16 and Index", () {
    print('Check indices');
    for (int i = 0; i < VR.vrs.length; i++) {
      VR vr = VR.vrs[i];
      print(vr.info);
      int vrCode8 = vr.code;
      int vrCode16 = vr.code16Bit;
      print('8: ${Int16.hex(vrCode8)}, 16: ${Int16.hex(vrCode16)}');

      int vrCode8Bit = kVR8BitCodeList[i];
      print('$vr(8): ${Int16.hex(vrCode8)}, Vector8: ${Int16.hex(vrCode8Bit)}');
      expect(vrCode8 == vrCode8Bit, true);

      int vrCode16Bit = kVR16BitCodeList[i];
      print('$vr(16): ${Int16.hex(vrCode16)}, Vector16: ${Int16.hex(vrCode16Bit)}');
      expect(vrCode16 == vrCode16Bit, true);
    }
  });

  test("Test vrCodes lookup Index", () {
    print('Check indices');
    for (int i = 0; i < VR.vrs.length; i++) {
      VR vr = VR.vrs[i];
      print(vr.info);
      int index = vr.index;
      int vrCode8 = vr.code;
      int vrCode16 = vr.code16Bit;
      print('$i: ${Int16.hex(vrCode8)}, 16: ${Int16.hex(vrCode16)}');

      int vrIndex8Bit = kVR8BitCodeList.indexOf(vrCode8);
      print('vr.index: $index , vrIndex8Bit: $vrIndex8Bit');
      expect(index == vrIndex8Bit, true);

      int vrIndex16Bit = kVR8BitCodeList.indexOf(vrCode8);
      print('vr.index: $index, vrIndex16Bit: $vrIndex16Bit');
      expect(index == vrIndex16Bit, true);
    }
  });
}

void printCode() {
  for (int i = 0; i < VR.vrs.length; i++) {
    int code = VR.vrs[i].code;
    int reverse = VR.vrs[i].code16Bit;
    print('code: ${Int16.hex(code)}');
    int c0 = code >> 8;
    print('c0: ${Int8.hex(c0)}');
    int c1 = (code & 0xFF) << 8;
    print('c1: ${Int8.hex(c1)}');
    int inverted = (code >> 8) + ((code & 0xFF) << 8);
    print('inverted: ${Int16.hex(inverted)}');
    print('j(${Int16.hex(code)}) k(${Int16.hex(reverse)})');
  }
}
