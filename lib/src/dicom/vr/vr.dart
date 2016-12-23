// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/vr/vr_index.dart';

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

  int get code16Bit => (code >> 8) + ((code & 0xFF) << 8);

  String get info => 'VR: $name(${Int16.hex(code)})[$index]: isShort($isShort), '
      'ElementSize($sizeInBytes), type($type)';

  @override
  String toString() => 'VR.$id';

  // Item ...
  static const VR kNoVR = const VR(00, 0x0000, false, "NoVR", 1);

  // Sequence
  static const VR kSQ = const VR(01, 0x5351, false, "SQ", 1);

  // Integers (Int first, then Uint)
  static const VR kSS = const VR(02, 0x5353, true, "SS", 2);
  static const VR kSL = const VR(03, 0x534c, true, "SL", 4);
  static const VR kOB = const VR(04, 0x4f42, false, "OB", 1);
  static const VR kUN = const VR(05, 0x554e, false, "UN", 1);
  static const VR kOW = const VR(06, 0x4f57, false, "OW", 2);
  static const VR kUS = const VR(07, 0x5553, true, "US", 2);
  static const VR kUL = const VR(08, 0x554c, true, "UL", 4);
  static const VR kAT = const VR(09, 0x4154, true, "AT", 4);
  static const VR kOL = const VR(10, 0x4f4c, false, "OL", 4);

  // Floats
  static const VR kFD = const VR(11, 0x4644, true, "FD", 8);
  static const VR kFL = const VR(12, 0x464c, true, "FL", 4);
  static const VR kOD = const VR(13, 0x4f44, false, "OD", 8);
  static const VR kOF = const VR(14, 0x4f46, false, "OF", 4);

  // Integer & String.integer
  static const VR kIS = const VR(15, 0x4953, true, "IS", 1);

  // Float & String.float
  static const VR kDS = const VR(16, 0x4453, true, "DS", 1);

  // String.array
  static const VR kAE = const VR(17, 0x4145, true, "AE", 1);
  static const VR kCS = const VR(18, 0x4353, true, "CS", 1);
  static const VR kLO = const VR(19, 0x4c4f, true, "LO", 1);
  static const VR kSH = const VR(20, 0x5348, true, "SH", 1);
  static const VR kUC = const VR(21, 0x5543, false, "UC", 1);

  // String.Text
  static const VR kST = const VR(22, 0x5354, true, "ST", 1);
  static const VR kLT = const VR(23, 0x4c54, true, "LT", 1);
  static const VR kUT = const VR(24, 0x5554, false, "UT", 1);

  // String.DateTime
  static const VR kDA = const VR(25, 0x4441, true, "DA", 1);
  static const VR kDT = const VR(26, 0x4454, true, "DT", 1);
  static const VR kTM = const VR(27, 0x544d, true, "TM", 1);

  // String.Other
  static const VR kPN = const VR(28, 0x504e, true, "PN", 1);
  static const VR kUI = const VR(29, 0x5549, true, "UI", 1);
  static const VR kUR = const VR(30, 0x5552, false, "UR", 1);
  static const VR kAS = const VR(31, 0x4153, true, "AS", 1);

  //Bulkdata Reference
  static const VR kBR = const VR(32, 0x4252, true, "BR", 1);

  // Special constants only used in Tag class
  static const VR kUnknown = const VR(33, 0x0000, null, "Unknown", null);
  static const VR kOBOW = const VR(34, 0x0001, null, "OBOW", null);
  static const VR kUSSS = const VR(35, 0x0003, null, "USSS", 1);
  static const VR kUSSSOW = const VR(36, 0x0003, null, "USSSOW", null);
  static const VR kUSOW = const VR(37, 0x0003, null, "USOW", null);
  static const VR kUSOW1 = const VR(38, 0x0003, null, "USOW1", null);



  // Special constants only used in Tag class
  //TODO: flush
  // static const VR kUnknown = const VR(, 0x0000, false, "Unknown", 1);

  /// The order of the VRs in this [List] MUST correspond to the [index]
  /// in the definitions above.  Note: the [index]es start at 1, so
  /// in this [List] the 0th dictionary ,is [null].
  ///
  //TODO: For performance It would be better to order this table from most common VR to Least.
  static const List<VR> vrs = const [
    kNoVR,
    // Sequence
    kSQ,
    // Integers
    kSS, kSL, kOB, kUN, kOW, kUS, kUL, kAT, kOL,
    // Floats
    kFD, kFL, kOD, kOF,
    // Integer & String.integer
    kIS,
    // Float & String.float
    kDS,
    // String.array
    kAE, kCS, kLO, kSH, kUC,
    // String.Text
    kST, kLT, kUT,
    // String.DateTime
    kDA, kDT, kTM,
    // String.Other
    kPN, kUI, kUR, kAS,
    //Bulkdata Reference
    kBR
  ];

  static const List<VR> stringVRs = const [
    kAE, kAS, kBR, kCS, kDA, kDS, kDT, kIS, kLO, kLT, kPN, kSH, kST, kTM, kUC, kUI, kUR, kUT //
  ];

  static const List<VR> byteVRs = const [
    kAT, kFD, kFL, kOB, kOD, kOF, kOW, kSL, kSS, kUL, kUN, kUS // stop reformat
  ];

  static const List<VR> intVRs = const [kAT, kOB, kOW, kSL, kSS, kUL, kUS, kDS, kIS];
  static const List<VR> floatVRs = const [kFD, kFL, kOD, kOF];

  //TODO: flush when mapInverted works?
  static const Map<int, VR> map = const {
    0x4145: kAE, 0x4153: kAS, 0x4154: kAT, 0x4252: kBR, 0x4353: kCS, 0x4441: kDA,
    0x4453: kDS, 0x4454: kDT, 0x4644: kFD, 0x464c: kFL, 0x4953: kIS, 0x4c4f: kLO,
    0x4c54: kLT, 0x4f42: kOB, 0x4f44: kOD, 0x4f46: kOF, 0x4f4c: kOL, 0x4f57: kOW,
    0x504e: kPN, 0x5348: kSH, 0x534c: kSL, 0x5351: kSQ, 0x5353: kSS, 0x5354: kST,
    0x544d: kTM, 0x5543: kUC, 0x5549: kUI, 0x554c: kUL, 0x554e: kUN, 0x5552: kUR,
    0x5553: kUS, 0x5554: kUT // stop reformat
  };

  static const Map<String, VR> strings = const {
    "AE": kAE, "AS": kAS, "AT": kAT, "BR": kBR, "CS": kCS, "DA": kDA,
    "DS": kDS, "DT": kDT, "FD": kFD, "FL": kFL, "IS": kIS, "LO": kLO,
    "LT": kLT, "OB": kOB, "OD": kOD, "OF": kOF, "OL": kOL, "OW": kOW,
    "PN": kPN, "SH": kSH, "SL": kSL, "SQ": kSQ, "SS": kSS, "ST": kST,
    "TM": kTM, "UC": kUC, "UI": kUI, "UL": kUL, "UN": kUN, "UR": kUR,
    "US": kUS, "UT": kUT // stop reformat
  };

  /// Returns a [VR] if [s](a 2 uppercase character [String] is a valid [VR] [name].
  static VR lookup(String s) => strings[s];

  /// Returns a [VR] if [vrCode](two [Uint8] integers) is a valid [VR] [name].
  static VR lookup8(int vrCode) => vrs[vrCodeToIndex(vrCode)];

  /// Returns a [VR] if [vrCode](one [Uint16] integer) is a valid [VR] [name].
  static int indexOf(int vrCode) => vrCodeToIndex(vrCode);

  /// Returns a [VR] if [vrCode](one [Uint16] integer) is a valid [VR] [name].
  static VR lookup16(int vrCode) => vrs[vrCodeToIndex(vrCode)];

  //TODO: create invertedMap
  static const Map<int, VR> mapInverted = const {
    0x4541: kAE, 0x5341: kAS, 0x5441: kAT, 0x5242: kBR, 0x5343: kCS, 0x4144: kDA,
    0x5344: kDS, 0x5444: kDT, 0x4446: kFD, 0x4c46: kFL, 0x5349: kIS, 0x4f4c: kLO,
    0x544c: kLT, 0x424f: kOB, 0x444f: kOD, 0x464f: kOF, 0x4c4f: kOL, 0x574f: kOW,
    0x4e50: kPN, 0x4853: kSH, 0x4c53: kSL, 0x5153: kSQ, 0x5353: kSS, 0x5453: kST,
    0x4d54: kTM, 0x4355: kUC, 0x4955: kUI, 0x4c55: kUL, 0x4e55: kUN, 0x5255: kUR,
    0x5355: kUS, 0x5455: kUT // stop reformat
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

  //tODO: create index(int x, int y)
  int getIndex(int first, int second) {
    var val = lookupTable[first];
    if (val is VR) return val.index;
    if (val is Map<int, dynamic>) return val[second].index;
    throw 'Invalid VR "${new String.fromCharCode(first)}${new String.fromCharCode(first)}"';
  }

  //TODO: review and make sure it is correct
  //TODO: Compare performance of this with [map] above.
  static const Map<int, dynamic> lookupTable = const {
    0x41: const {0x45: kAE, 0x53: kAS, 0x54: kAT},
    0x42: kBR,
    0x43: kCS,
    0x44: const {0x41: kDA, 0x53: kDS, 0x54: kDT},
    0x46: const {0x44: kFD, 0x4c: kFL},
    0x49: kIS,
    0x4c: const {0x4f: kLO, 0x54: kLT},
    0x4f: const {0x42: kOB, 0x44: kOD, 0x46: kOF, 0x4c: kOL, 0x57: kOW},
    0x50: kPN,
    0x53: const {0x48: kSH, 0x4c: kSL, 0x51: kSQ, 0x53: kSS, 0x54: kST},
    0x54: kTM,
    0x55: const {0x43: kUC, 0x49: kUI, 0x4c: kUL, 0x4e: kUN, 0x52: kUR, 0x53: kUS, 0x54: kUT}
  };
}

//TODO: Add this field to VR Definition
Map<VR, Type> dataTypes = const {
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
