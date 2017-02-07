// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

const int kUnknown = 0;
const int kAE8 = 0x4145;
const int kAS8 = 0x4153;
const int kAT8 = 0x4154;
const int kBR8 = 0x4252;
const int kCS8 = 0x4353;
const int kDA8 = 0x4441;
const int kDS8 = 0x4453;
const int kDT8 = 0x4454;
const int kFD8 = 0x4644;
const int kFL8 = 0x464c;
const int kIS8 = 0x4953;
const int kLO8 = 0x4c4f;
const int kLT8 = 0x4c54;
const int kOB8 = 0x4f42;
const int kOD8 = 0x4f44;
const int kOF8 = 0x4f46;
const int kOL8 = 0x4f4c;
const int kOW8 = 0x4f57;
const int kPN8 = 0x504e;
const int kSH8 = 0x5348;
const int kSL8 = 0x534c;
const int kSQ8 = 0x5351;
const int kSS8 = 0x5353;
const int kST8 = 0x5354;
const int kTM8 = 0x544d;
const int kUC8 = 0x5543;
const int kUI8 = 0x5549;
const int kUL8 = 0x554c;
const int kUN8 = 0x554e;
const int kUR8 = 0x5552;
const int kUS8 = 0x5553;
const int kUT8 = 0x5554;

/// A [List] of valid [VR]s as 16-bit values.  Since the target architectures
/// are all [LittleEndian], the byte order is reversed. The [VR]s are in the
/// order of [VR.vrs]
const List<int> kVR8BitCodeList = const [
  kUnknown, kSQ8, kSS8, kSL8, kOB8, kUN8, kOW8, kUS8, kUL8, kAT8,
  kOL8, kFD8, kFL8, kOD8, kOF8, kIS8, kDS8, kAE8, kCS8, kLO8,
  kSH8, kUC8, kST8, kLT8, kUT8, kDA8, kDT8, kTM8, kPN8, kUI8,
  kUR8, kAS8, kBR8 // preserve formatting
];

/// Returns the [_index] of [vrCode] in kVR8List.
int vrCodeToIndex(int vrCode) => kVR8BitCodeList.indexOf(vrCode);

// Constant definitions for 16-bit VR Codes. Since the
// target architectures are all [LittleEndian], the byte order is reversed.
const int kAE16 = 0x4541;
const int kAS16 = 0x5341;
const int kAT16 = 0x5441;
const int kBR16 = 0x5242;
const int kCS16 = 0x5343;
const int kDA16 = 0x4144;
const int kDS16 = 0x5344;
const int kDT16 = 0x5444;
const int kFD16 = 0x4446;
const int kFL16 = 0x4c46;
const int kIS16 = 0x5349;
const int kLO16 = 0x4f4c;
const int kLT16 = 0x544c;
const int kOB16 = 0x424f;
const int kOD16 = 0x444f;
const int kOF16 = 0x464f;
const int kOL16 = 0x4c4f;
const int kOW16 = 0x574f;
const int kPN16 = 0x4e50;
const int kSH16 = 0x4853;
const int kSL16 = 0x4c53;
const int kSQ16 = 0x5153;
const int kSS16 = 0x5353;
const int kST16 = 0x5453;
const int kTM16 = 0x4d54;
const int kUC16 = 0x4355;
const int kUI16 = 0x4955;
const int kUL16 = 0x4c55;
const int kUN16 = 0x4e55;
const int kUR16 = 0x5255;
const int kUS16 = 0x5355;
const int kUT16 = 0x5455;

/// A [List] of valid [VR]s as 16-bit values.  Since the target architectures
/// are all [LittleEndian], the byte order is reversed. The [VR]s are in the
/// order of [VR.vrs]
const List<int> kVR16BitCodeList = const [
  kUnknown, kSQ16, kSS16, kSL16, kOB16, kUN16, kOW16, kUS16, kUL16, kAT16,
  kOL16, kFD16, kFL16, kOD16, kOF16, kIS16, kDS16, kAE16, kCS16, kLO16,
  kSH16, kUC16, kST16, kLT16, kUT16, kDA16, kDT16, kTM16, kPN16, kUI16,
  kUR16, kAS16, kBR16 // preserve formatting
];

/// Returns the [_index] of [vrCode] in kVR16List.
int vr16CodeToIndex(int vrCode) => kVR16BitCodeList.indexOf(vrCode);
