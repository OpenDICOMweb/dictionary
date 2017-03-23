// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:dictionary/src/vr/vr.dart';
//import 'package:test/test.dart';

//import 'vr_index.dart';

void main() {
  //test8BitVR();
  //test16BitVRMapLookup();
}

/* Removed the 8-bit lookup - now use only 16-bit lookup
void test8BitVR() {
  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kAE8];
    expect(vr == VR.kAE, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kAS8];
    expect(vr == VR.kAS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kAT8];
    expect(vr == VR.kAT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kBR8];
    expect(vr == VR.kBR, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kCS8];
    expect(vr == VR.kCS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kDA8];
    expect(vr == VR.kDA, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kDS8];
    expect(vr == VR.kDS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kDT8];
    expect(vr == VR.kDT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kFD8];
    expect(vr == VR.kFD, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kFL8];
    expect(vr == VR.kFL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kIS8];
    expect(vr == VR.kIS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kLO8];
    expect(vr == VR.kLO, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kLT8];
    expect(vr == VR.kLT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kOB8];
    expect(vr == VR.kOB, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kOD8];
    expect(vr == VR.kOD, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kOF8];
    expect(vr == VR.kOF, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kOL8];
    expect(vr == VR.kOL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kOW8];
    expect(vr == VR.kOW, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kPN8];
    expect(vr == VR.kPN, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kSH8];
    expect(vr == VR.kSH, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kSL8];
    expect(vr == VR.kSL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kSQ8];
    expect(vr == VR.kSQ, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kSS8];
    expect(vr == VR.kSS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kST8];
    expect(vr == VR.kST, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kTM8];
    expect(vr == VR.kTM, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUC8];
    expect(vr == VR.kUC, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUI8];
    expect(vr == VR.kUI, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUL8];
    expect(vr == VR.kUL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUN8];
    expect(vr == VR.kUN, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUR8];
    expect(vr == VR.kUR, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUS8];
    expect(vr == VR.kUS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.vrs[kUT8];
    expect(vr == VR.kUT, true);
  });
}
*/
/*
void test16BitVRMapLookup() {
  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kAE16];
    expect(vr == VR.kAE, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kAS16];
    expect(vr == VR.kAS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kAT16];
    expect(vr == VR.kAT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kBR16];
    expect(vr == VR.kBR, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kCS16];
    expect(vr == VR.kCS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kDA16];
    expect(vr == VR.kDA, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kDS16];
    expect(vr == VR.kDS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kDT16];
    expect(vr == VR.kDT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kFD16];
    expect(vr == VR.kFD, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kFL16];
    expect(vr == VR.kFL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kIS16];
    expect(vr == VR.kIS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kLO16];
    expect(vr == VR.kLO, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kLT16];
    expect(vr == VR.kLT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kOB16];
    expect(vr == VR.kOB, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kOD16];
    expect(vr == VR.kOD, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kOF16];
    expect(vr == VR.kOF, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kOL16];
    expect(vr == VR.kOL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kOW16];
    expect(vr == VR.kOW, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kPN16];
    expect(vr == VR.kPN, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kSH16];
    expect(vr == VR.kSH, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kSL16];
    expect(vr == VR.kSL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kSQ16];
    expect(vr == VR.kSQ, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kSS16];
    expect(vr == VR.kSS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kST16];
    expect(vr == VR.kST, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kTM16];
    expect(vr == VR.kTM, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUC16];
    expect(vr == VR.kUC, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUI16];
    expect(vr == VR.kUI, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUL16];
    expect(vr == VR.kUL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUN16];
    expect(vr == VR.kUN, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUR16];
    expect(vr == VR.kUR, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUS16];
    expect(vr == VR.kUS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.vrMap[kUT16];
    expect(vr == VR.kUT, true);
  });
}

void test16BitVRVectorLookup() {
  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kAE16);
    expect(vr == VR.kAE, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kAS16);
    expect(vr == VR.kAS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kAT16);
    expect(vr == VR.kAT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kBR16);
    expect(vr == VR.kBR, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kCS16);
    expect(vr == VR.kCS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kDA16);
    expect(vr == VR.kDA, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kDS16);
    expect(vr == VR.kDS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kDT16);
    expect(vr == VR.kDT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kFD16);
    expect(vr == VR.kFD, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kFL16);
    expect(vr == VR.kFL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kIS16);
    expect(vr == VR.kIS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kLO16);
    expect(vr == VR.kLO, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kLT16);
    expect(vr == VR.kLT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kOB16);
    expect(vr == VR.kOB, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kOD16);
    expect(vr == VR.kOD, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kOF16);
    expect(vr == VR.kOF, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kOL16);
    expect(vr == VR.kOL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kOW16);
    expect(vr == VR.kOW, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kPN16);
    expect(vr == VR.kPN, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kSH16);
    expect(vr == VR.kSH, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kSL16);
    expect(vr == VR.kSL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kSQ16);
    expect(vr == VR.kSQ, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kSS16);
    expect(vr == VR.kSS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kST16);
    expect(vr == VR.kST, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kTM16);
    expect(vr == VR.kTM, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUC16);
    expect(vr == VR.kUC, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUI16);
    expect(vr == VR.kUI, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUL16);
    expect(vr == VR.kUL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUN16);
    expect(vr == VR.kUN, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUR16);
    expect(vr == VR.kUR, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUS16);
    expect(vr == VR.kUS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup(kUT16);
    expect(vr == VR.kUT, true);
  });
}
*/
