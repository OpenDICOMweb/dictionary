// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:test/test.dart';

import 'package:dictionary/src/vr/vr_index.dart';
import 'package:dictionary/src/vr/vr.dart';

main() {
  test8BitVR();
  test16BitVRMapLookup();
}

test8BitVR() {
  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kAE8];
    expect(vr == VR.kAE, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kAS8];
    expect(vr == VR.kAS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kAT8];
    expect(vr == VR.kAT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kBR8];
    expect(vr == VR.kBR, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kCS8];
    expect(vr == VR.kCS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kDA8];
    expect(vr == VR.kDA, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kDS8];
    expect(vr == VR.kDS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kDT8];
    expect(vr == VR.kDT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kFD8];
    expect(vr == VR.kFD, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kFL8];
    expect(vr == VR.kFL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kIS8];
    expect(vr == VR.kIS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kLO8];
    expect(vr == VR.kLO, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kLT8];
    expect(vr == VR.kLT, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kOB8];
    expect(vr == VR.kOB, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kOD8];
    expect(vr == VR.kOD, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kOF8];
    expect(vr == VR.kOF, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kOL8];
    expect(vr == VR.kOL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kOW8];
    expect(vr == VR.kOW, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kPN8];
    expect(vr == VR.kPN, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kSH8];
    expect(vr == VR.kSH, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kSL8];
    expect(vr == VR.kSL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kSQ8];
    expect(vr == VR.kSQ, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kSS8];
    expect(vr == VR.kSS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kST8];
    expect(vr == VR.kST, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kTM8];
    expect(vr == VR.kTM, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUC8];
    expect(vr == VR.kUC, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUI8];
    expect(vr == VR.kUI, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUL8];
    expect(vr == VR.kUL, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUN8];
    expect(vr == VR.kUN, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUR8];
    expect(vr == VR.kUR, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUS8];
    expect(vr == VR.kUS, true);
  });

  test("Regular Map Lookup (8-Bit)", () {
    VR vr = VR.map[kUT8];
    expect(vr == VR.kUT, true);
  });
}

test16BitVRMapLookup() {
  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kAE16];
    expect(vr == VR.kAE, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kAS16];
    expect(vr == VR.kAS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kAT16];
    expect(vr == VR.kAT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kBR16];
    expect(vr == VR.kBR, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kCS16];
    expect(vr == VR.kCS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kDA16];
    expect(vr == VR.kDA, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kDS16];
    expect(vr == VR.kDS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kDT16];
    expect(vr == VR.kDT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kFD16];
    expect(vr == VR.kFD, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kFL16];
    expect(vr == VR.kFL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kIS16];
    expect(vr == VR.kIS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kLO16];
    expect(vr == VR.kLO, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kLT16];
    expect(vr == VR.kLT, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kOB16];
    expect(vr == VR.kOB, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kOD16];
    expect(vr == VR.kOD, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kOF16];
    expect(vr == VR.kOF, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kOL16];
    expect(vr == VR.kOL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kOW16];
    expect(vr == VR.kOW, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kPN16];
    expect(vr == VR.kPN, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kSH16];
    expect(vr == VR.kSH, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kSL16];
    expect(vr == VR.kSL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kSQ16];
    expect(vr == VR.kSQ, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kSS16];
    expect(vr == VR.kSS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kST16];
    expect(vr == VR.kST, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kTM16];
    expect(vr == VR.kTM, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUC16];
    expect(vr == VR.kUC, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUI16];
    expect(vr == VR.kUI, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUL16];
    expect(vr == VR.kUL, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUN16];
    expect(vr == VR.kUN, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUR16];
    expect(vr == VR.kUR, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUS16];
    expect(vr == VR.kUS, true);
  });

  test("Inverted Map Lookup (16-Bit)", () {
    VR vr = VR.mapInverted[kUT16];
    expect(vr == VR.kUT, true);
  });
}

test16BitVRVectorLookup() {
  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kAE16);
    expect(vr == VR.kAE, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kAS16);
    expect(vr == VR.kAS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kAT16);
    expect(vr == VR.kAT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kBR16);
    expect(vr == VR.kBR, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kCS16);
    expect(vr == VR.kCS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kDA16);
    expect(vr == VR.kDA, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kDS16);
    expect(vr == VR.kDS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kDT16);
    expect(vr == VR.kDT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kFD16);
    expect(vr == VR.kFD, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kFL16);
    expect(vr == VR.kFL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kIS16);
    expect(vr == VR.kIS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kLO16);
    expect(vr == VR.kLO, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kLT16);
    expect(vr == VR.kLT, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kOB16);
    expect(vr == VR.kOB, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kOD16);
    expect(vr == VR.kOD, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kOF16);
    expect(vr == VR.kOF, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kOL16);
    expect(vr == VR.kOL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kOW16);
    expect(vr == VR.kOW, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kPN16);
    expect(vr == VR.kPN, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kSH16);
    expect(vr == VR.kSH, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kSL16);
    expect(vr == VR.kSL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kSQ16);
    expect(vr == VR.kSQ, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kSS16);
    expect(vr == VR.kSS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kST16);
    expect(vr == VR.kST, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kTM16);
    expect(vr == VR.kTM, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUC16);
    expect(vr == VR.kUC, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUI16);
    expect(vr == VR.kUI, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUL16);
    expect(vr == VR.kUL, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUN16);
    expect(vr == VR.kUN, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUR16);
    expect(vr == VR.kUR, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUS16);
    expect(vr == VR.kUS, true);
  });

  test("Inverted Vector Lookup (16-Bit)", () {
    VR vr = VR.lookup16(kUT16);
    expect(vr == VR.kUT, true);
  });
}
