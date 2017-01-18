// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/tag.dart';
import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/vr/vr_index.dart';

import 'check_values.dart';

//TODO:
typedef dynamic Decode(int length);

typedef List<String> ValueChecker(dynamic value);

// Abbreviation used to shorten constant definitions so they line up.
const int kMaxLong = kMaxLongLengthInBytes;

enum VRType { integer, float, string, text, dateTime, sequence, other, unknown }

/// DICOM Value Representation [VR] definitions.
class VR {
  final int index;
  final int code;
  final bool isShort;
  final String id;
  final String desc;
  final int min;
  final int max;
  final ValueChecker checkValue;

  //TODO: add min, max for value length
  const VR._(this.index, this.code, this.isShort, this.id, this.desc, this.min,
      this.max, this.checkValue);

  String get keyword => "k$id";

  int get sizeInBytes => max;

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

  String get info => 'VR: $id(${Int16.hex(code)})[$index]: isShort($isShort), '
      'ElementSize($sizeInBytes)';

  //TODO: implement
  Uint8List checkBytes(Uint8List bytes) => null;

  String toString() => 'VR.k$id';

  // index, code, isShort, id, sizeInBytes, check, [this.type = null]);
  // Item ...
  static const VR kNoVR = const VR._(00, 0x0000, false, "NoVR", "Unknown VR", 0, 1, invalid);

  // Sequence
  static const VR kSQ = const VR._(01, 0x5351, false, "SQ", "Sequence", 0, kMaxLong, invalid);

  // Integers (Int first, then Uint)
  static const VR kSS = const VR._(02, 0x5353, true, "SS", "Signed Short", 2, 2, getErrorsSS);
  static const VR kSL = const VR._(03, 0x534c, true, "SL", "Signed Long", 4, 4, getErrorsSL);
  static const VR kOB = const VR._(04, 0x4f42, false, "OB", "Other Bytes", 1, 1, getErrorsOB);
  static const VR kUN = const VR._(05, 0x554e, false, "UN", "Unknown VR", 1, 1, getErrorsUN);
  static const VR kOW = const VR._(06, 0x4f57, false, "OW", "Other Bytes", 2, 2, getErrorsOW);
  static const VR kUS = const VR._(07, 0x5553, true, "US", "Unsigned Short", 2, 2, getErrorsUS);
  static const VR kUL = const VR._(08, 0x554c, true, "UL", "Unsigned Long", 4, 4, getErrorsUL);
  //TODO: this should do a lookup to validate the Public or Private Tag
  static const VR kAT = const VR._(09, 0x4154, true, "AT", "Attribute Tag", 4, 4, getErrorsAT);
  static const VR kOL = const VR._(10, 0x4f4c, false, "OL", "Other Long", 4, 4, getErrorsOL);

  // Floats
  static const VR kFD = const VR._(11, 0x4644, true, "FD", "Float Double", 8, 8, getErrorsFD);
  static const VR kFL = const VR._(12, 0x464c, true, "FL", "Float Single", 4, 4, getErrorsFL);
  static const VR kOD = const VR._(13, 0x4f44, false, "OD", "Other Double", 8, 8, getErrorsOD);
  static const VR kOF = const VR._(14, 0x4f46, false, "OF", "Other Float", 4, 4, getErrorsOF);

  // Integer & String.integer
  static const VR kIS = const VR._(15, 0x4953, true, "IS", "Integer String", 1, 12, getErrorsIS);

  // Float & String.float
  static const VR kDS = const VR._(16, 0x4453, true, "DS", "Decimal String", 1, 16, getErrorsDS);

  // String.array
  static const VR kAE = const VR._(17, 0x4145, true, "AE", "AE Title", 1, 16, getErrorsAE);
  static const VR kCS = const VR._(18, 0x4353, true, "CS", "Code String", 1, 16, getErrorsCS);
  static const VR kLO = const VR._(19, 0x4c4f, true, "LO", "Long String", 1, 64, getErrorsLO);
  static const VR kSH = const VR._(20, 0x5348, true, "SH", "Short String", 1, 16, getErrorsSH);
  static const VR kUC =
      const VR._(21, 0x5543, false, "UC", "Unlimited Characters", 1, kMaxLong, getErrorsUC);

  // String.Text
  static const VR kST = const VR._(22, 0x5354, true, "ST", "Short Text", 1, 1024, getErrorsST);
  static const VR kLT = const VR._(23, 0x4c54, true, "LT", "Long Text", 1, 10240, getErrorsLT);
  static const VR kUT =
      const VR._(24, 0x5554, false, "UT", "Unlimited Text", 1, kMaxLong, getErrorsUT);

  // String.DateTime
  static const VR kDA = const VR._(25, 0x4441, true, "DA", "Date", 8, 8, getErrorsDA);
  static const VR kDT = const VR._(26, 0x4454, true, "DT", "DateTime", 4, 26, getErrorsDT);
  static const VR kTM = const VR._(27, 0x544d, true, "TM", "Time", 2, 14, getErrorsTM);

  // String.Other
  static const VR kPN = const VR._(28, 0x504e, true, "PN", "Person Name", 0, 5 * 64, getErrorsPN);
  static const VR kUI = const VR._(29, 0x5549, true, "UI", "Unique Id", 8, 64, getErrorsUI);
  static const VR kUR = const VR._(30, 0x5552, false, "UR", "URI", 1, kMaxLong, getErrorsUR);
  static const VR kAS = const VR._(31, 0x4153, true, "AS", "Age String", 4, 4, getErrorsAS);

  //Bulkdata Reference
  static const VR kBR =
      const VR._(32, 0x4252, true, "BR", "BulkData Reference", 1, kMaxLong, invalid);

  // Flush?
  // Special constants only used in Tag class
  static const VR kOBOW = const VR._(34, 0x0001, null, "OBOW", "OB or OW", null, null, invalid);
  static const VR kUSSS = const VR._(35, 0x0003, null, "USSS", "US or SS", 2, 2, invalid);
  static const VR kUSSSOW = const VR._(36, 0x0003, null, "USSSOW", "US or SS or OW", 2, 2, invalid);
  static const VR kUSOW = const VR._(37, 0x0003, null, "USOW", "US or OW", 2, 2, invalid);
  static const VR kUSOW1 = const VR._(38, 0x0003, null, "USOW1", "US or OW1", 2, 2, invalid);

  // Special constants only used in Tag class
  //TODO: flush
  // static const VR kUnknown = const VR._(, 0x0000, false, "Unknown", 1);

  /// The order of the VRs in this [List] MUST correspond to the [index]
  /// in the definitions above.  Note: the [index]es start at 1, so
  /// in this [List] the 0th dictionary ,is [null].
  ///
  //TODO: For performance It would be better to order this table from most common VR to Least.
  static const List<VR> vrs = const <VR>[
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

  static const List<VR> stringVRs = const <VR>[
    kAE, kAS, kBR, kCS, kDA, kDS, kDT, kIS, kLO, kLT, kPN, kSH, kST, kTM, kUC, kUI, kUR, kUT //
  ];

  static const List<VR> byteVRs = const <VR>[
    kAT, kFD, kFL, kOB, kOD, kOF, kOW, kSL, kSS, kUL, kUN, kUS // stop reformat
  ];

  static const List<VR> intVRs = const <VR>[kAT, kOB, kOW, kSL, kSS, kUL, kUS, kDS, kIS];
  static const List<VR> floatVRs = const <VR>[kFD, kFL, kOD, kOF];

  //TODO: flush when mapInverted works?
  static const Map<int, VR> map = const <int, VR>{
    0x4145: kAE, 0x4153: kAS, 0x4154: kAT, 0x4252: kBR, 0x4353: kCS, 0x4441: kDA,
    0x4453: kDS, 0x4454: kDT, 0x4644: kFD, 0x464c: kFL, 0x4953: kIS, 0x4c4f: kLO,
    0x4c54: kLT, 0x4f42: kOB, 0x4f44: kOD, 0x4f46: kOF, 0x4f4c: kOL, 0x4f57: kOW,
    0x504e: kPN, 0x5348: kSH, 0x534c: kSL, 0x5351: kSQ, 0x5353: kSS, 0x5354: kST,
    0x544d: kTM, 0x5543: kUC, 0x5549: kUI, 0x554c: kUL, 0x554e: kUN, 0x5552: kUR,
    0x5553: kUS, 0x5554: kUT // stop reformat
  };

  static const Map<String, VR> strings = const <String, VR>{
    "AE": kAE, "AS": kAS, "AT": kAT, "BR": kBR, "CS": kCS, "DA": kDA,
    "DS": kDS, "DT": kDT, "FD": kFD, "FL": kFL, "IS": kIS, "LO": kLO,
    "LT": kLT, "OB": kOB, "OD": kOD, "OF": kOF, "OL": kOL, "OW": kOW,
    "PN": kPN, "SH": kSH, "SL": kSL, "SQ": kSQ, "SS": kSS, "ST": kST,
    "TM": kTM, "UC": kUC, "UI": kUI, "UL": kUL, "UN": kUN, "UR": kUR,
    "US": kUS, "UT": kUT // stop reformat
  };

  /// Returns a [VR] if [s](a 2 uppercase character [String] is a valid [VR] [id].
  static VR lookup(String s) => strings[s];

  /// Returns a [VR] if [vrCode](two [Uint8] integers) is a valid [VR] [id].
  static VR lookup8(int vrCode) => vrs[vrCodeToIndex(vrCode)];

  /// Returns a [VR] if [vrCode](one [Uint16] integer) is a valid [VR] [id].
  static int indexOf(int vrCode) => vr16CodeToIndex(vrCode);

  /// Returns a [VR] if [vrCode](one [Uint16] integer) is a valid [VR] [id].
  static VR lookup16(int vrCode) => vrs[vrCodeToIndex(vrCode)];

  //TODO: create invertedMap
  static const Map<int, VR> mapInverted = const <int, VR>{
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
    dynamic val = lookupTable[first];
    if (val is VR) return val.index;
    if (val is Map<int, dynamic>) return val[second]._index;
    throw 'Invalid VR "${new String.fromCharCode(first)}${new String.fromCharCode(first)}"';
  }

  //TODO: review and make sure it is correct
  //TODO: Compare performance of this with [map] above.
  static const Map<int, dynamic> lookupTable = const <int, dynamic>{
    0x41: const <int, VR>{0x45: kAE, 0x53: kAS, 0x54: kAT},
    0x42: kBR,
    0x43: kCS,
    0x44: const <int, VR>{0x41: kDA, 0x53: kDS, 0x54: kDT},
    0x46: const <int, VR>{0x44: kFD, 0x4c: kFL},
    0x49: kIS,
    0x4c: const <int, VR>{0x4f: kLO, 0x54: kLT},
    0x4f: const <int, VR>{0x42: kOB, 0x44: kOD, 0x46: kOF, 0x4c: kOL, 0x57: kOW},
    0x50: kPN,
    0x53: const <int, VR>{0x48: kSH, 0x4c: kSL, 0x51: kSQ, 0x53: kSS, 0x54: kST},
    0x54: kTM,
    0x55: const <int, VR>{0x43: kUC, 0x49: kUI, 0x4c: kUL, 0x4e: kUN, 0x52: kUR, 0x53: kUS, 0x54: kUT}
  };
}

//TODO: Add this field to VR Definition
const Map<VR, String> dataTypes = const <VR, String>{
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

// Flush
class VRSpecial extends VR {
  final List<VR> list;

  //TODO: add min, max for value length
  const VRSpecial(this.list, int index, int code, bool isShort, String id, String desc,
      int minBytes, int maxBytes,
      [ValueChecker check = invalid])
      : super._(index, code, isShort, id, desc, minBytes, maxBytes, check);

  static const VRSpecial kOBOW =
      const VRSpecial(const [VR.kOB, VR.kOW], 01, -1, false, "OBOW", "OB or OW", 1, 2);
  static const VRSpecial kUSSS =
      const VRSpecial(const [VR.kUS, VR.kSS], 02, -2, false, "USSS", "US or SS", 2, 2);
  static const VRSpecial kUSSSOW = const VRSpecial(
      const [VR.kUS, VR.kSS, VR.kOW], 03, -3, false, "US or SS or OW", "USSSOW", 2, 2);
  static const VRSpecial kUSOW =
      const VRSpecial(const [VR.kUS, VR.kOW], 04, -4, false, "USOW", "US or OW", 2, 2);
  static const VRSpecial kUSOW1 =
      const VRSpecial(const [VR.kUS, VR.kOW], 05, -5, false, "USOW1", "US or OW1", 2, 2);
}

Issue addIssue(Tag tag, Issue issue, int i, String msg) {
  if (issue == null) return new Issue(tag, i, msg);
  return issue.add(i, msg);
}


