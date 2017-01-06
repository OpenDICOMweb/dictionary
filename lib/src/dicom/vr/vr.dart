// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/tag.dart';
import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/string/dicom_predicates.dart';
import 'package:dictionary/src/dicom/vr/vr_index.dart';

//TODO:
typedef dynamic Decode(int length);

enum VRType { integer, float, string, text, dateTime, sequence, other, unknown }

/// DICOM Value Representation [VR] definitions.
class VR {
  final int index;
  final int code;
  final bool isShort;
  final String name;
  final String desc;
  final int sizeInBytes;
  final ValueChecker checkValue;

  //TODO: add min, max for value length
  const VR._(this.index, this.code, this.isShort, this.name, this.desc,
           this.sizeInBytes, this.checkValue);

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
      'ElementSize($sizeInBytes)';

  List<ValueIssue> checkValues(List values) {
    var viList = <ValueIssue>[];
    for (int i = 0; i < values.length; i++) {
      var issues = <String>[];
      if (checkValue(values[i], issues)) {
        viList.add(new ValueIssue(i, values[i], issues));
      }
    }
    return (viList.length == 0) ? null : viList;
  }

  @override
  String toString() => 'VR.$id';

  static bool noCheck(value, List<String> issues, [int index = 0]) => null;

  // index, code, isShort, name, sizeInBytes, check, [this.type = null]);
  // Item ...
  static const VR kNoVR = const VR._(00, 0x0000, false, "NoVR", "Unknown VR", 1, noCheck);

  // Sequence
  static const VR kSQ = const VR._(01, 0x5351, false, "SQ", "Sequence", 1, noCheck);

  // Integers (Int first, then Uint)
  static const VR kSS = const VR._(02, 0x5353, true, "SS", "Signed Short Integer", 2, Int16.check);
  static const VR kSL = const VR._(03, 0x534c, true, "SL", "Signed Long Integer", 4, Int32.check);
  static const VR kOB = const VR._(04, 0x4f42, false, "OB", "Other Bytes Integer", 1, Uint8.check);
  static const VR kUN = const VR._(05, 0x554e, false, "UN", "Unknown VR", 1, Uint8.check);
  static const VR kOW = const VR._(06, 0x4f57, false, "OW", "Other Bytes",2, Uint8.check);
  static const VR kUS = const VR._(07, 0x5553, true, "US", "Unsigned Short", 2, Int16.check);
  static const VR kUL = const VR._(08, 0x554c, true, "UL", "Unsigned Long", 4, Uint32.check);
  //TODO: this should do a lookup to validate the Public or Private Tag
  static const VR kAT = const VR._(09, 0x4154, true, "AT", "Attribute Tag", 4, Uint32.check);
  static const VR kOL = const VR._(10, 0x4f4c, false, "OL", "Other Long", 4, Uint32.check);

  // Floats
  static const VR kFD = const VR._(11, 0x4644, true, "FD", "Float Double", 8, noCheck);
  static const VR kFL = const VR._(12, 0x464c, true, "FL", "Float Single", 4, noCheck);
  static const VR kOD = const VR._(13, 0x4f44, false, "OD", "Other Double Float", 8, noCheck);
  static const VR kOF = const VR._(14, 0x4f46, false, "OF", "Other Float Single", 4, noCheck);

  // Integer & String.integer
  static const VR kIS = const VR._(15, 0x4953, true, "IS", "Integer String", 1, checkISString);

  // Float & String.float
  static const VR kDS = const VR._(16, 0x4453, true, "DS", "Decimal String", 1, checkDSString);

  // String.array
  static const VR kAE = const VR._(17, 0x4145, true, "AE", "AE Title", 1, checkAEString);
  static const VR kCS = const VR._(18, 0x4353, true, "CS", "Code String", 1, checkCSString);
  static const VR kLO = const VR._(19, 0x4c4f, true, "LO", "Long String", 1, checkLOString);
  static const VR kSH = const VR._(20, 0x5348, true, "SH", "Short String", 1, checkSHString);
  static const VR kUC = const VR._(21, 0x5543, false, "UC", "Unlimited Characters", 1, checkUCString);

  // String.Text
  static const VR kST = const VR._(22, 0x5354, true, "ST", "Short Text", 1, checkSTString);
  static const VR kLT = const VR._(23, 0x4c54, true, "LT", "Long Text",  1, checkLTString);
  static const VR kUT = const VR._(24, 0x5554, false, "UT", "Unlimited Text", 1, checkUTString);

  // String.DateTime
  static const VR kDA = const VR._(25, 0x4441, true, "DA", "Date", 1, checkDAString);
  static const VR kDT = const VR._(26, 0x4454, true, "DT", "DateTime", 1, checkDTString);
  static const VR kTM = const VR._(27, 0x544d, true, "TM", "Time", 1, checkTMString);

  // String.Other
  static const VR kPN = const VR._(28, 0x504e, true, "PN", "Person Name", 1, checkPNString);
  static const VR kUI = const VR._(29, 0x5549, true, "UI", "Unique Id", 1, checkUIString);
  static const VR kUR = const VR._(30, 0x5552, false, "UR", "URI", 1, checkURString);
  static const VR kAS = const VR._(31, 0x4153, true, "AS", "Age String", 1, checkASString);

  //Bulkdata Reference
  static const VR kBR = const VR._(32, 0x4252, true, "BR", "BulkData Reference", 1, noCheck);

  // Special constants only used in Tag class
  static const VR kOBOW = const VR._(34, 0x0001, null, "OBOW", "OB or OW", null, noCheck);
  static const VR kUSSS = const VR._(35, 0x0003, null, "USSS", "US or SS",  1, noCheck);
  static const VR kUSSSOW = const VR._(36, 0x0003, null, "USSSOW", "US or SS or OW", null, noCheck);
  static const VR kUSOW = const VR._(37, 0x0003, null, "USOW", "US or OW", null, noCheck);
  static const VR kUSOW1 = const VR._(38, 0x0003, null, "USOW1", "US or OW1", null, noCheck);



  // Special constants only used in Tag class
  //TODO: flush
  // static const VR kUnknown = const VR._(, 0x0000, false, "Unknown", 1);

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
  static int indexOf(int vrCode) => vr16CodeToIndex(vrCode);

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
    if (val is Map<int, dynamic>) return val[second]._index;
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
  const VRSpecial(this.list, int index, int code, bool isShort, String name,
                  String desc, int sizeInBytes, [ValueChecker check = VR.noCheck])
      : super._(index, code, isShort, name, desc, sizeInBytes, check);

  static const VRSpecial kOBOW =
      const VRSpecial(const [VR.kOB, VR.kOW], 01, -1, false, "OBOW","OB or OW", 1);
  static const VRSpecial kUSSS =
      const VRSpecial(const [VR.kUS, VR.kSS], 02, -2, false, "USSS", "US or SS", 2);
  static const VRSpecial kUSSSOW =
      const VRSpecial(const [VR.kUS, VR.kSS, VR.kOW], 03, -3, false, "US or SS or OW", "USSSOW", 2);
  static const VRSpecial kUSOW =
      const VRSpecial(const [VR.kUS, VR.kOW], 04, -4, false, "USOW", "US or OW",2);
  static const VRSpecial kUSOW1 =
      const VRSpecial(const [VR.kUS, VR.kOW], 05, -5, false, "USOW1","US or OW1", 2);
}

/* TODO: flush when fully working
typedef Issue VRValueChecker(int vrIndex);


Issue noVRValueChecker(value) => throw 'Invalid vrIndex';

Issue sequenceValueChecker(value) => throw 'Shouldn\'t check sequence values';







const List<ValueChecker> vrValueCheckers = const [
  //kNoVR,
  noVRValueChecker,
  // Sequence
  sequenceValueChecker, //kSQ,
  // Integers
  //kSS,

  Int16.listGuard,
  // kSL,
  Int32.listGuard,
  // kOB,
  Uint8.listGuard,
  // kUN,
  Uint8.listGuard,
  // kOW,
  Uint16.listGuard,
  // kUS,
  Uint16.listGuard,
  // kUL,
  Uint32.listGuard,
  // kAT,
  Uint32.listGuard,
  // kOL,
  Uint32.listGuard,

  // Floats
  // kFD,
  Tag.checkLength,
  // kFL,
  checkValuesLength,
  // kOD,
  checkValuesLength,
  // kOF,
  checkValuesLength,

  // kIS - Integer & String.integer
  //kIS,
  checkISValue,

  // kDS - Float & String.float
  checkISValue,
  // String.array
  // kAE,
  checkAEValue,
  // kCS,
  checkCodeStringValue,
  // kLO,
  checkLongStringValue,
  // kSH,
  checkShortStringValue,
  // kUC,
  checkUnlimitedStringValue,

  // String.Text
  // kST,
  checkShortText,
  // kLT,
  checkLongText,
  // kUT,
  checkUnlimitedText,

  // String.DateTime
  // kDA,
  checkDateValue,
  // kDT,
  checkDataTimeValue,
  // kTM,
  checkTimeValue,

  // String.Other
  // kPN,
  checkPNValue,
  // kUI,
  checkUIValue,
  // kUR,
  checkURValue,
  // kAS,
  checkASValue,
  //Bulkdata Reference
 // kBR
];



const List<VR> byteCheckers = const [
  //kNoVR,
  noVRBytesChecker,
  // Sequence
  checkSequenceBytes, //kSQ,
  // Integers
  //kSS,
  int16BytesChecker,
  // kSL,
  int32BytesChecker,
  // kOB,
  uint8BytesChecker,
  // kUN,
  uint8BytesChecker,
  // kOW,
  uint16BytesChecker,
  // kUS,
  uint16BytesChecker,
  // kUL,
  uint32BytesChecker,
  // kAT,
  uint32BytesChecker,
  // kOL,
  uint32BytesChecker,

  // Floats
  // kFD,
  checkBytessLength,
  // kFL,
  checkBytessLength,
  // kOD,
  checkBytessLength,
  // kOF,
  checkBytessLength,

  // kIS - Integer & String.integer
  //kIS,
  checkISBytes,

  // kDS - Float & String.float
  checkISBytes,
  // String.array
  // kAE,
  checkAEBytes,
  // kCS,
  checkCodeStringBytes,
  // kLO,
  checkLongStringBytes,
  // kSH,
  checkShortStringBytes,
  // kUC,
  checkUnlimitedStringBytes,

  // String.Text
  // kST,
  checkShortText,
  // kLT,
  checkLongText,
  // kUT,
  checkUnlimitedText,

  // String.DateTime
  // kDA,
  checkDateBytes,
  // kDT,
  checkDataTimeBytes,
  // kTM,
  checkTimeBytes,

  // String.Other
  // kPN,
  checkPNBytes,
  // kUI,
  checkUIBytes,
  // kUR,
  checkURBytes,
  // kAS,
  checkASBytes,
  //Bulkdata Reference
  kBR
];
*/