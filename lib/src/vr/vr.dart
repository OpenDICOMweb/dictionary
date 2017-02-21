// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.dictionary.vr;

import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:common/date_time.dart';
import 'package:dictionary/src/vr/vr_index.dart';

part 'float.dart';
part 'integer.dart';
part 'string.dart';
part 'utils.dart';

//TODO: Explain VR class structure
//typedef bool _Test<E>(E value);
//typedef String _ErrorMsg<E>(E value);

/// The maximum value of an unsigned 16-bit integer (2^32).
const int kUint16Max = 0xFFFF;

/// The maximum value of an unsigned 32-bit integer (2^32).
const int kUint32Max = 0xFFFFFFFF;

/// The maximum length, in bytes, of a "short" (16-bit) Value Field.
const int kMaxShortVF = kUint16Max;

/// The maximum length, in bytes, of a "long" (32-bit) Value Field.
///
/// Note: the values is `[kUint32Max] - 1` because the maximum value (0xFFFFFFFF)
/// is used to denote a Value Field with Undefined Length.
const int kMaxLongVF = kUint32Max - 2;

/// DICOM Value Representation [VR] definitions.
class VR<T> {
  static const int kMaxShortVFLength = kMaxShortVF;
  static const int kMaxLongVFLength = kMaxLongVF;
  final int index;
  final int code;
  final String id;
  final String desc;

  const VR._(this.index, this.code, this.id, this.desc);

  /// Create a VR with a Short (16-bit) Value Field length.
  //const VR._(this.index, this.code, this.id, this.desc);

  // **** This next getters are overridden in some of the subclasses.
  // **** The values here are the most common values.  The private
  // **** names (prefixed by underscore) are just abbreviations of
  // **** longer public names.

  /// The element size in bytes. The default is 1 for Strings and Sequences.
  int get _eSize => 1;

  /// The number of bytes in each element of a value of with this [VR].
  int get elementSize => _eSize;

  /// _Deprecated:_ Use [elementSize] instead.
  @deprecated
  int get sizeInBytes => _eSize;

  /// _Deprecated:_ Use [elementSize] instead.
  @deprecated
  int get elementSizeInBytes => _eSize;

  // TODO: make private?
  /// Abbreviation for [minValueLength].
  int get min => _eSize;

  /// The minimum length in bytes of a value with this [VR].
  int get minValueLength => min;

  // TODO: make private?
  /// Abbreviation for [maxValueLength].
  int get max => _eSize;

  /// The maximum length in bytes of a value with this [VR].
  int get maxValueLength => max;

  /// The minimum Length in bytes of a Value Field for this [VR].
  int get minVFLength => min;

  /// Abbreviation for [maxVFLength].
  int get _maxVF => kMaxShortVF;

  /// The maximum Length in bytes of a Value Field for this [VR].
  int get maxVFLength => _maxVF;

  /// Abbreviation for [undefinedVRLengthAllowed].
  bool get _undefinedOK => false;

  /// Returns [true] if the [VR] allows the Value Field Length to be
  /// kUndefinedLength.  This is true for SQ, OB, OW, UN and Item.
  bool get undefinedVRLengthAllowed => _undefinedOK;

  /// Return the [id] in constant keyword format.
  String get keyword => "k$id";

  @deprecated
  bool get isShort => hasShortVF;

  bool get hasShortVF => _maxVF <= kMaxShortVF;

  bool get hasLongVF => _maxVF > kMaxShortVF;

  int get vfLength => (hasShortVF) ? 2 : 4;

  int get code16Bit => (code >> 8) + ((code & 0xFF) << 8);

  String get info =>
      '$runtimeType: $id(${Int16.hex(code)})[$index]: maxVFLength($_maxVF), '
      'elementSize($elementSize)';

  //TODO: decide if these are needed or useful
  bool get isUnknown => index == 0;
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

  bool isValidValue(T value) => false;

  bool isNotValidValue(T value) => !isValidValue(value);

  T check(T value) => null;

  //TODO: currently returns one [String], but since there could be more than one
  //TODO: error maybe it should be a [List<String>].
  String getValueError(T value) => null;

  /// Returns a value of the appropriate type
  T parse(String s) => null;

  //TODO: implement or flush
  Uint8List checkBytes(Uint8List bytes) => null;

  @override
  String toString() => '$runtimeType.k$id';

  // **** Constant definitions for all VRs.

  // Unknown - placeholder in [vrs].
  static const VR kUnknown = VROther.kUnknown;
  // Sequence
  static const VR kSQ = VROther.kSQ;

  // Integers
  static const VR kSS = VRInt.kSS;
  static const VR kSL = VRInt.kSL;
  static const VR kOB = VRInt.kOB;
  static const VR kUN = VRInt.kUN;
  static const VR kOW = VRInt.kOW;
  static const VR kUS = VRInt.kUS;
  static const VR kUL = VRInt.kUL;
  static const VR kOL = VRInt.kOL;
  static const VR kAT = VRInt.kAT;

  // Floats
  static const VR kFD = VRFloat.kFD;
  static const VR kFL = VRFloat.kFL;
  static const VR kOD = VRFloat.kOD;
  static const VR kOF = VRFloat.kOF;

  // String.numbers
  static const VR kIS = VRShortString.kIS;
  static const VR kDS = VRShortString.kDS;

  // String.dcm
  static const VR kAE = VRShortString.kAE;
  static const VR kCS = VRShortString.kCS;
  static const VR kLO = VRShortString.kLO;
  static const VR kSH = VRShortString.kSH;

  // String.Text
  static const VR kST = VRShortString.kST;
  static const VR kLT = VRShortString.kLT;

  // String.DateTime
  static const VR kDA = VRShortString.kDA;
  static const VR kDT = VRShortString.kDT;
  static const VR kTM = VRShortString.kTM;

  // String.Other
  static const VR kPN = VRShortString.kPN;
  static const VR kUI = VRShortString.kUI;
  static const VR kAS = VRShortString.kAS;

  // String with long Value Field
  static const VR kUC = VRLongString.kUC;
  static const VR kUR = VRLongString.kUR;
  static const VR kUT = VRLongString.kUT;

  // Placeholder for Bulkdata Reference
  static const VR kBR = VROther.kBR;

  // Special values used by Tag
  static const VR kOBOW = VRIntSpecial.kOBOW;
  static const VR kUSSS = VRIntSpecial.kUSSS;
  static const VR kUSSSOW = VRIntSpecial.kUSSSOW;
  static const VR kUSOW = VRIntSpecial.kUSOW;
  static const VR kUSOW1 = VRIntSpecial.kUSOW1;

  /// The order of the VRs in this [List] MUST correspond to the [index]
  /// in the definitions above.  Note: the [index]es start at 1, so
  /// in this [List] the 0th dictionary ,is [null].
  ///
  static const List<VR> vrs = const <VR>[
    kUnknown,
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
    kAE, kAS, kBR, kCS, kDA, kDS, kDT, kIS, kLO, kLT, kPN, kSH, kST, kTM, kUC,
    kUI, kUR,
    kUT //
  ];

  static const List<VR> byteVRs = const <VR>[
    kAT, kFD, kFL, kOB, kOD, kOF, kOW, kSL, kSS, kUL, kUN, kUS // stop reformat
  ];

  static const List<VR> intVRs = const <VR>[
    kAT,
    kOB,
    kOW,
    kSL,
    kSS,
    kUL,
    kUS,
    kDS,
    kIS
  ];
  static const List<VR> floatVRs = const <VR>[kFD, kFL, kOD, kOF];

  //TODO: flush when mapInverted works?
  static const Map<int, VR> map = const <int, VR>{
    0x4145: kAE, 0x4153: kAS, 0x4154: kAT, 0x4252: kBR, 0x4353: kCS,
    0x4441: kDA,
    0x4453: kDS, 0x4454: kDT, 0x4644: kFD, 0x464c: kFL, 0x4953: kIS,
    0x4c4f: kLO,
    0x4c54: kLT, 0x4f42: kOB, 0x4f44: kOD, 0x4f46: kOF, 0x4f4c: kOL,
    0x4f57: kOW,
    0x504e: kPN, 0x5348: kSH, 0x534c: kSL, 0x5351: kSQ, 0x5353: kSS,
    0x5354: kST,
    0x544d: kTM, 0x5543: kUC, 0x5549: kUI, 0x554c: kUL, 0x554e: kUN,
    0x5552: kUR,
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
    0x4541: kAE, 0x5341: kAS, 0x5441: kAT, 0x5242: kBR, 0x5343: kCS,
    0x4144: kDA,
    0x5344: kDS, 0x5444: kDT, 0x4446: kFD, 0x4c46: kFL, 0x5349: kIS,
    0x4f4c: kLO,
    0x544c: kLT, 0x424f: kOB, 0x444f: kOD, 0x464f: kOF, 0x4c4f: kOL,
    0x574f: kOW,
    0x4e50: kPN, 0x4853: kSH, 0x4c53: kSL, 0x5153: kSQ, 0x5353: kSS,
    0x5453: kST,
    0x4d54: kTM, 0x4355: kUC, 0x4955: kUI, 0x4c55: kUL, 0x4e55: kUN,
    0x5255: kUR,
    0x5355: kUS, 0x5455: kUT // stop reformat
  };

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
    0x4f: const <int, VR>{
      0x42: kOB,
      0x44: kOD,
      0x46: kOF,
      0x4c: kOL,
      0x57: kOW
    },
    0x50: kPN,
    0x53: const <int, VR>{
      0x48: kSH,
      0x4c: kSL,
      0x51: kSQ,
      0x53: kSS,
      0x54: kST
    },
    0x54: kTM,
    0x55: const <int, VR>{
      0x43: kUC,
      0x49: kUI,
      0x4c: kUL,
      0x4e: kUN,
      0x52: kUR,
      0x53: kUS,
      0x54: kUT
    }
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

//TODO: clean this up. remove VR.kUnknown and VR.kBR. How to handle SQ
class VROther extends VR {
  @override
  final int _maxVF;
  @override
  final bool _undefinedOK;

  /// Create a VR with a Short (16-bit) Value Field length.
  const VROther._(int index, int code, String id, String desc,
      [this._maxVF = -1, this._undefinedOK = false])
      : super._(index, code, id, desc);

  static const VR kUnknown = const VR._(00, 0x0000, "Unknown", "Unknown VR");

  // TODO: Currently not used - might be useful for new media types.
  /// Bulkdata Reference
  static const VR kBR = const VR._(32, 0x4252, "BR", "BulkData Reference");

  //Bulkdata Reference
  static const VROther kSQ =
      const VROther._(1, 0x5351, "SQ", "Sequence", kMaxLongVF, true);
}
