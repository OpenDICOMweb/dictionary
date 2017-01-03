// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


const kNoVR = 0;
const kAE8 = 0x4145;
const kAS8 = 0x4153;
const kAT8 = 0x4154;
const kBR8 = 0x4252;
const kCS8 = 0x4353;
const kDA8 = 0x4441;
const kDS8 = 0x4453;
const kDT8 = 0x4454;
const kFD8 = 0x4644;
const kFL8 = 0x464c;
const kIS8 = 0x4953;
const kLO8 = 0x4c4f;
const kLT8 = 0x4c54;
const kOB8 = 0x4f42;
const kOD8 = 0x4f44;
const kOF8 = 0x4f46;
const kOL8 = 0x4f4c;
const kOW8 = 0x4f57;
const kPN8 = 0x504e;
const kSH8 = 0x5348;
const kSL8 = 0x534c;
const kSQ8 = 0x5351;
const kSS8 = 0x5353;
const kST8 = 0x5354;
const kTM8 = 0x544d;
const kUC8 = 0x5543;
const kUI8 = 0x5549;
const kUL8 = 0x554c;
const kUN8 = 0x554e;
const kUR8 = 0x5552;
const kUS8 = 0x5553;
const kUT8 = 0x5554;

/// A [List] of valid [VR]s as 16-bit values.  Since the target architectures
/// are all [LittleEndian], the byte order is reversed. The [VR]s are in the
/// order of [VR.vrs]
const List<int> kVR8BitCodeList = const [
  kNoVR, kSQ8, kSS8, kSL8, kOB8, kUN8, kOW8, kUS8, kUL8, kAT8,
  kOL8,  kFD8, kFL8, kOD8, kOF8, kIS8, kDS8, kAE8, kCS8, kLO8,
  kSH8,  kUC8, kST8, kLT8, kUT8, kDA8, kDT8, kTM8, kPN8, kUI8,
  kUR8,  kAS8, kBR8 // preserve formatting
];

/// Returns the [_index] of [vrCode] in kVR8List.
int vrCodeToIndex(int vrCode) => kVR8BitCodeList.indexOf(vrCode);

// Constant definitions for 16-bit VR Codes. Since the
// target architectures are all [LittleEndian], the byte order is reversed.
const kAE16 = 0x4541;
const kAS16 = 0x5341;
const kAT16 = 0x5441;
const kBR16 = 0x5242;
const kCS16 = 0x5343;
const kDA16 = 0x4144;
const kDS16 = 0x5344;
const kDT16 = 0x5444;
const kFD16 = 0x4446;
const kFL16 = 0x4c46;
const kIS16 = 0x5349;
const kLO16 = 0x4f4c;
const kLT16 = 0x544c;
const kOB16 = 0x424f;
const kOD16 = 0x444f;
const kOF16 = 0x464f;
const kOL16 = 0x4c4f;
const kOW16 = 0x574f;
const kPN16 = 0x4e50;
const kSH16 = 0x4853;
const kSL16 = 0x4c53;
const kSQ16 = 0x5153;
const kSS16 = 0x5353;
const kST16 = 0x5453;
const kTM16 = 0x4d54;
const kUC16 = 0x4355;
const kUI16 = 0x4955;
const kUL16 = 0x4c55;
const kUN16 = 0x4e55;
const kUR16 = 0x5255;
const kUS16 = 0x5355;
const kUT16 = 0x5455;

/// A [List] of valid [VR]s as 16-bit values.  Since the target architectures
/// are all [LittleEndian], the byte order is reversed. The [VR]s are in the
/// order of [VR.vrs]
const List<int> kVR16BitCodeList = const [
  kNoVR, kSQ16, kSS16, kSL16, kOB16, kUN16, kOW16, kUS16, kUL16, kAT16,
  kOL16, kFD16, kFL16, kOD16, kOF16, kIS16, kDS16, kAE16, kCS16, kLO16,
  kSH16, kUC16, kST16, kLT16, kUT16, kDA16, kDT16, kTM16, kPN16, kUI16,
  kUR16, kAS16, kBR16 // preserve formatting
];

/// Returns the [_index] of [vrCode] in kVR16List.
int vr16CodeToIndex(int vrCode) => kVR16BitCodeList.indexOf(vrCode);
