// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

//TODO:
typedef dynamic Decode(int length);

/// DICOM Value Representation [VR] definitions.
class VR {
  final int code;
  final int index;
  final int vfLength;
  final String name;
  final int sizeInBytes;

  //TODO: add min, max for value length
  const VR(this.code, this.index, this.vfLength, this.name, this.sizeInBytes);

  String get id => "k$name";

  @override
  String toString() => 'VR.$id';

  static const VR kAE = const VR(0x4145, 1, 2, "AE", 1);
  static const VR kAS = const VR(0x4153, 2, 2, "AS", 1);
  static const VR kAT = const VR(0x4154, 3, 2, "AT", 4);
  static const VR kBR = const VR(0x4252, 4, 2, "BR", 1); //Bulkdata Reference
  static const VR kCS = const VR(0x4353, 5, 2, "CS", 1);
  static const VR kDA = const VR(0x4441, 6, 2, "DA", 1);
  static const VR kDS = const VR(0x4453, 7, 2, "DS", 1);
  static const VR kDT = const VR(0x4454, 8, 2, "DT", 1);
  static const VR kFD = const VR(0x4644, 9, 2, "FD", 8);
  static const VR kFL = const VR(0x464c, 10, 2, "FL", 4);
  static const VR kIS = const VR(0x4953, 11, 2, "IS", 1);
  static const VR kLO = const VR(0x4c4f, 12, 2, "LO", 1);
  static const VR kLT = const VR(0x4c54, 13, 2, "LT", 1);
  static const VR kOB = const VR(0x4f42, 14, 4, "OB", 1);
  static const VR kOD = const VR(0x4f44, 15, 4, "OD", 8);
  static const VR kOF = const VR(0x4f46, 16, 4, "OF", 4);
  static const VR kOL = const VR(0x4f4c, 17, 4, "OL", 4);
  static const VR kOW = const VR(0x4f57, 18, 4, "OW", 2);
  static const VR kPN = const VR(0x504e, 19, 2, "PN", 1);
  static const VR kSH = const VR(0x5348, 20, 2, "SH", 1);
  static const VR kSL = const VR(0x534c, 21, 2, "SL", 4);
  static const VR kSQ = const VR(0x5351, 22, 4, "SQ", 1);
  static const VR kSS = const VR(0x5353, 23, 2, "SS", 2);
  static const VR kST = const VR(0x5354, 24, 2, "ST", 1);
  static const VR kTM = const VR(0x544d, 25, 2, "TM", 1);
  static const VR kUC = const VR(0x5543, 26, 4, "UC", 1);
  static const VR kUI = const VR(0x5549, 27, 2, "UI", 1);
  static const VR kUL = const VR(0x554c, 28, 2, "UL", 4);
  static const VR kUN = const VR(0x554e, 29, 4, "UN", 1);
  static const VR kUR = const VR(0x5552, 30, 4, "UR", 1);
  static const VR kUS = const VR(0x5553, 31, 2, "US", 2);
  static const VR kUT = const VR(0x5554, 32, 4, "UT", 1);

  // Special constants only used in Tag class
  static const VR kUnknown = const VR(0x0000, 33, 4, "Unknown", 1);
  static const VR kOBOW = const VR(0x0001, 34, 4, "OBOW", 1);
  static const VR kUSSS = const VR(0x0003, 35, 4, "USSS", 2);
  static const VR kUSSSOW = const VR(0x0003, 36, 4, "USSSOW", 2);
  static const VR kUSOW = const VR(0x0003, 37, 4, "USOW", 2);
  static const VR kUSOW1 = const VR(0x0003, 38, 4, "USOW1", 2);
  static const VR kNoVR = const VR(0x0000, 39, 4, "NoVR", 1);

  /// The order of the VRs in this [List] MUST correspond to the [index]
  /// in the definitions above.  Note: the [index]es start at 1, so
  /// in this [List] the 0th dictionary is [null].
  static const List<VR> vector = const [
    null,
    VR.kAE, VR.kAS, VR.kAT, VR.kBR, VR.kCS, VR.kDA, VR.kDS, VR.kDT,
    VR.kFD, VR.kFL, VR.kIS, VR.kLO, VR.kLT, VR.kPN, VR.kOB, VR.kOD,
    VR.kOF, VR.kOL, VR.kOW, VR.kSH, VR.kSL, VR.kSQ, VR.kSS, VR.kST,
    VR.kTM, VR.kUC, VR.kUI, VR.kUL, VR.kUN, VR.kUR, VR.kUS, VR.kUT,
    // Special VRs for internal use only
    VR.kNoVR, VR.kOBOW, VR.kUSSS, VR.kUSSSOW, VR.kUSOW, VR.kUSOW1
  ];

  static const List<VR> stringVRs = const [
    VR.kAE,
    VR.kAS,
    VR.kBR,
    VR.kCS,
    VR.kDA,
    VR.kDS,
    VR.kDT,
    VR.kIS,
    VR.kLO,
    VR.kLT,
    VR.kPN,
    VR.kSH,
    VR.kST,
    VR.kTM,
    VR.kUC,
    VR.kUI,
    VR.kUR,
    VR.kUT
  ];

  static const List<VR> byteVRs = const [
    VR.kAT,
    VR.kFD,
    VR.kFL,
    VR.kOB,
    VR.kOD,
    VR.kOF,
    VR.kOW,
    VR.kSL,
    VR.kSS,
    VR.kUL,
    VR.kUN,
    VR.kUS
  ];

  static const List<VR> intVRs = const [
    VR.kAT,
    VR.kOB,
    VR.kOW,
    VR.kSL,
    VR.kSS,
    VR.kUL,
    VR.kUS,
    VR.kDS,
    VR.kIS
  ];
  static const List<VR> floatVRs = const [VR.kFD, VR.kFL, VR.kOD, VR.kOF];

  static const Map<int, VR> map = const {
    0x4145: VR.kAE,
    0x4153: VR.kAS,
    0x4154: VR.kAT,
    0x4252: VR.kBR,
    0x4353: VR.kCS,
    0x4441: VR.kDA,
    0x4453: VR.kDS,
    0x4454: VR.kDT,
    0x4644: VR.kFD,
    0x464c: VR.kFL,
    0x4953: VR.kIS,
    0x4c4f: VR.kLO,
    0x4c54: VR.kLT,
    0x4f42: VR.kOB,
    0x4f44: VR.kOD,
    0x4f46: VR.kOF,
    0x4f57: VR.kOW,
    0x504e: VR.kPN,
    0x5348: VR.kSH,
    0x534c: VR.kSL,
    0x5351: VR.kSQ,
    0x5353: VR.kSS,
    0x5354: VR.kST,
    0x544d: VR.kTM,
    0x5543: VR.kUC,
    0x5549: VR.kUI,
    0x554c: VR.kUL,
    0x554e: VR.kUN,
    0x5552: VR.kUR,
    0x5553: VR.kUS,
    0x5554: VR.kUT
  };

  static const Map<String, VR> strings = const {
    "AE": VR.kAE,
    "AS": VR.kAS,
    "AT": VR.kAT,
    "BR": VR.kBR,
    "CS": VR.kCS,
    "DA": VR.kDA,
    "DS": VR.kDS,
    "DT": VR.kDT,
    "FD": VR.kFD,
    "FL": VR.kFL,
    "IS": VR.kIS,
    "LO": VR.kLO,
    "LT": VR.kLT,
    "OB": VR.kOB,
    "OD": VR.kOD,
    "OF": VR.kOF,
    "OW": VR.kOW,
    "PN": VR.kPN,
    "SH": VR.kSH,
    "SL": VR.kSL,
    "SQ": VR.kSQ,
    "SS": VR.kSS,
    "ST": VR.kST,
    "TM": VR.kTM,
    "UC": VR.kUC,
    "UI": VR.kUI,
    "UL": VR.kUL,
    "UN": VR.kUN,
    "UR": VR.kUR,
    "US": VR.kUS,
    "UT": VR.kUT
  };

  static VR lookup(String s) => strings[s];

  //TODO: create invertedMap
  static const Map<int, VR> mapInverted = const {
    0x4541: VR.kAE,
    0x5341: VR.kAS,
    0x5441: VR.kAT,
    0x5242: VR.kBR,
    0x5343: VR.kCS,
    0x4144: VR.kDA,
    0x5344: VR.kDS,
    0x5444: VR.kDT,
    0x4446: VR.kFD,
    0x4c46: VR.kFL,
    0x5349: VR.kIS,
    0x4f4c: VR.kLO,
    0x544c: VR.kLT,
    0x424f: VR.kOB,
    0x444f: VR.kOD,
    0x464f: VR.kOF,
    0x574f: VR.kOW,
    0x4e50: VR.kPN,
    0x4853: VR.kSH,
    0x4c53: VR.kSL,
    0x5153: VR.kSQ,
    0x5353: VR.kSS,
    0x5453: VR.kST,
    0x4d54: VR.kTM,
    0x4355: VR.kUC,
    0x4955: VR.kUI,
    0x4c55: VR.kUL,
    0x4e55: VR.kUN,
    0x5255: VR.kUR,
    0x5355: VR.kUS,
    0x5455: VR.kUT
  };

  // Flush:?
  /// Returns the length of the Value Field of an Explicit VR Attribute.
  static int length(VR vr) {
    switch (vr) {
      case kOB:
      case kOD:
      case kOW:
      case kOF:
      case kSQ:
      case kUN:
      case kUC:
      case kUR:
      case kUT:
        return 4;
      default:
        return 2;
    }
  }
}

//TODO: Add this field to VR Definition
Map<VR, String> dataTypes = {
  // String VRs
  VR.kAE: "AE Title",
  VR.kAS: "String",
  //  VR.kBR:
  VR.kCS: "Code String",
  VR.kDA: "Date",
  VR.kDS: "Decimal String",
  VR.kDT: "DateTime",
  VR.kIS: "Integer String",
  VR.kLO: "String",
  VR.kLT: "Text",
  VR.kPN: "String",
  VR.kSH: "String",
  VR.kST: "Text",
  VR.kTM: "Time",
  VR.kUC: "String",
  VR.kUI: "UID",
  VR.kUR: "URI",
  VR.kUT: "Text",

  // Integers
  VR.kAT: "uint32",
  VR.kOB: "uint8",
  VR.kOW: "uint16",
  VR.kSL: "int32",
  VR.kSS: "int16",
  VR.kUL: "uint32",
  VR.kUS: "uint16",

  //Floats
  VR.kFD: "float64",
  VR.kFL: "float32",
  VR.kOD: "float64",
  VR.kOF: "float32"
};
