// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';

//TODO:
typedef dynamic Decode(int length);

enum VRType { integers, floats, strings, text, dateTime, other, sequence, none }

/// DICOM Value Representation [VR] definitions.
class VR {
  final int index;
  final int code;
  final bool isShort;
  final String name;
  final int sizeInBytes;
  final Type type;

  //TODO: add min, max for value length
  const VR(this.index, this.code, this.isShort, this.name, this.sizeInBytes, [this.type = null]);

  String get id => "k$name";

  bool get isNoVR => index == 0;
  bool get isSequence => index == 1;
  bool get isInteger => 2 <= index && index <= 11;
  bool get isFloat => 12 <= index && index <= 17;
  bool get isBinary => 2 <= index && index <= 14;

  bool get isString => 16 <= index && index <= 32;
  bool get isText => 23 <= index && index <= 25;
  bool get isDateTime => 26 <= index && index <= 28;
  bool get isOther => 29 <= index && index <= 32;

  bool get isStringNumber => this == kIS || this == kDS;
  bool get isNumber => isInteger || isFloat || isStringNumber;

  int get vfLength => (isShort) ? 2 : 4;

  @override
  String toString() => 'VR.$id';

  // Item ...
  static const VR kNoVR = const VR(00, 0x0000, false, "NoVR", 1);
  // Sequence
  static const VR kSQ = const VR(01, 0x5351, false, "SQ", 1);

  // Integers
  static const VR kSS = const VR(02, 0x5353, true,  "SS", 2);
  static const VR kSL = const VR(03, 0x534c, true,  "SL", 4);
  static const VR kOB = const VR(04, 0x4f42, false, "OB", 1);
  static const VR kUN = const VR(05, 0x554e, false, "UN", 1);
  static const VR kOW = const VR(06, 0x4f57, false, "OW", 2);
  static const VR kUS = const VR(07, 0x5553, true,  "US", 2);
  static const VR kUL = const VR(08, 0x554c, true,  "UL", 4);
  static const VR kAT = const VR(09, 0x4154, true,  "AT", 4);
  static const VR kOL = const VR(10, 0x4f4c, false, "OL", 4);


  // Floats
  static const VR kFD = const VR(11, 0x4644, true, "FD", 8);
  static const VR kFL = const VR(12, 0x464c, true, "FL", 4);
  static const VR kOD = const VR(13, 0x4f44, false, "OD", 8);
  static const VR kOF = const VR(14, 0x4f46, false, "OF", 4);

  // Integer & String.integer
  static const VR kIS = const VR(16, 0x4953, true, "IS", 1);
  // Float & String.float
  static const VR kDS = const VR(17, 0x4453, true, "DS", 1);
  // String.array
  static const VR kAE = const VR(18, 0x4145, true, "AE", 1);
  static const VR kCS = const VR(19, 0x4353, true, "CS", 1);
  static const VR kLO = const VR(20, 0x4c4f, true, "LO", 1);
  static const VR kSH = const VR(21, 0x5348, true, "SH", 1);
  static const VR kUC = const VR(22, 0x5443, false, "UC", 1);

  // String.Text
  static const VR kST = const VR(23, 0x5354, true, "ST", 1);
  static const VR kLT = const VR(24, 0x4c54, true, "LT", 1);
  static const VR kUT = const VR(25, 0x5554, false, "UT", 1);

  // String.DateTime
  static const VR kDA = const VR(26, 0x4441, true, "DA", 1);
  static const VR kDT = const VR(27, 0x4454, true, "DT", 1);
  static const VR kTM = const VR(28, 0x544d, true, "TM", 1);

  // String.Other
  static const VR kPN = const VR(29, 0x504e, true, "PN", 1);
  static const VR kUI = const VR(30, 0x5549, true, "UI", 1);
  static const VR kUR = const VR(31, 0x5552, false, "UR", 1);
  static const VR kAS = const VR(32, 0x4153, true, "AS", 1);

  //Bulkdata Reference
  static const VR kBR = const VR(33, 0x4252, true, "BR", 1);

  // Special constants only used in Tag class
  //TODO: flush
 // static const VR kUnknown = const VR(, 0x0000, false, "Unknown", 1);

  /// The order of the VRs in this [List] MUST correspond to the [index]
  /// in the definitions above.  Note: the [index]es start at 1, so
  /// in this [List] the 0th dictionary ,is [null].
  static const List<VR> vrs = const [
    kNoVR,
    // Sequence
    kSQ,
    // Integer
    // Float
    // String.Array
    // String.Text
    // String.DateTime
    // String.Other
    VR.kAE, VR.kAS, VR.kAT, VR.kCS, VR.kDA, VR.kDS, VR.kDT,
    VR.kFD, VR.kFL, VR.kIS, VR.kLO, VR.kLT, VR.kPN, VR.kOB, VR.kOD,
    VR.kOF, VR.kOL, VR.kOW, VR.kSH, VR.kSL, VR.kSQ, VR.kSS, VR.kST,
    VR.kTM, VR.kUC, VR.kUI, VR.kUL, VR.kUN, VR.kUR, VR.kUS, VR.kUT,
    // Special VRs for internal use only
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
    //   0x4252: VR.kBR,
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
Map<VR, Type> dataTypes = {
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
  VR.kAT: Uint32,
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

class VRSpecial extends VR {
  final List<VR> list;
  //TODO: add min, max for value length
  const VRSpecial(this.list, int index, int code, bool isShort, String name, int sizeInBytes)
      : super(index, code, isShort, name, sizeInBytes);

  static const VRSpecial kOBOW =
      const VRSpecial(const [VR.kOB, VR.kOW], 01, 0x0001, false, "OBOW", 1);
  static const VRSpecial kUSSS =
      const VRSpecial(const [VR.kUS, VR.kSS], 01, 0x0003, false, "USSS", 2);
  static const VRSpecial kUSSSOW =
      const VRSpecial(const [VR.kUS, VR.kSS, VR.kOW], 01, 0x0003, false, "USSSOW", 2);
  static const VRSpecial kUSOW =
      const VRSpecial(const [VR.kUS, VR.kOW], 01, 0x0003, false, "USOW", 2);
  static const VRSpecial kUSOW1 =
      const VRSpecial(const [VR.kUS, VR.kOW], 01, 0x0003, false, "USOW1", 2);
}
