// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/constants.dart';

import 'float.dart';
import 'integer.dart';
import 'string.dart';

//TODO: Explain VR class structure

abstract class VR<T> {
  final int index;
  final int code;
  final String id;
  final int elementSize;
  final int vfLengthSize;
  final int maxVFLength;
  final String keyword;

  const VR(this.index, this.code, this.id, this.elementSize, this.vfLengthSize,
      this.maxVFLength, this.keyword,
      [this.undefinedLengthAllowed = false]);

  VR operator [](int i) => vrList[i];

  /// The minimum length of a value.
  int get minValueLength => elementSize;

  /// The maximum length of a value.
  int get maxValueLength => elementSize;

  /// Is the kUndefinedLength value allowed as a Value Field Length.
  final bool undefinedLengthAllowed;

  bool get hasShortVF => vfLengthSize == 2;
  bool get hasLongVF => !hasShortVF;

  bool get isAscii => false;
  bool get isUtf8 => false;

  /// Returns the [VR] as a [String].
  String get asString => 'VR.k$id';

  String get info => '$runtimeType: $keyword $id(${Int16.hex(code)})[$index]: '
      'elementSize($elementSize) vfLengthSize($vfLengthSize), '
      'maxVFLength($maxVFLength)';

  //TODO: decide whether these should be here or in Element
  //List<T> bytesToValues(Uint8List bytes);
  //TODO: decide whether these should be here or in Element
  //Uint8List valuesToBytes(List<T> values);

  /// Returns the length in number of elements.
  int toLength(int lengthInBytes) => lengthInBytes ~/ elementSize;

  /// Returns [true] if any number of values is always valid.
  bool get isLengthAlwaysValid => false;

  bool isValidLength(int length) => false;
  // **** Must be overridden.
  /// Returns [true] of [value] is UN.
  bool isValid(Object value) => (value is int) && Uint8.inRange(value);

  /// Returns [true] of [value] is not valid for this VR.kUN.
  bool isNotValid(Object value) => !isValid(value);

  T check(T value) => (isValid(value)) ? value : null;

  // **** Must be overridden.
  /// Returns a valid value, or if not parsable, [null].
  dynamic parse(String s) => null;

  //TODO: decide whether these should be here or in Element
  /// Returns a [String] containing a Base 64 encoding of [bytes].
  String base64Encode(Uint8List bytes) => BASE64.encode(bytes);

  /// Returns a [Uint8List] containing the Base 64 decoding of [s].
  Uint8List base64decode(String s) => BASE64.decode(s);

  // **** Must be overridden.
  /// Returns a [ParseIssues] object indicating any issues with value.
  /// If there are no issues returns the empty string ("").
  //Urgent: finish
  ParseIssues issues(T value) => null;

  // List<int> view(List<int> list) => Uint8.view(list);
  // **** Must be overridden.
  /// Returns a new value that is legal and a best practice.
  T fix(T value) => null;

  // **** Must be overridden.
  /// Returns [true] if [bytes] has a valid Value Field length.
  bool isValidBytes(Uint8List bytes) =>
      bytes.length > -1 && bytes.length < maxVFLength;

  @override
  String toString() => asString;

  // **** Constant members

  // Invalid
  static const VR kInvalid = VRInvalid.kInvalid;
  // Unknown
  static const VR kUN = VRUnknown.kUN;
  // Sequence
  static const VR kSQ = VRSequence.kSQ;

  // Integers
  static const VR kSS = VRInt.kSS;
  static const VR kSL = VRInt.kSL;
  static const VR kOB = VRInt.kOB;
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
  static const VR kIS = VRIntString.kIS;
  static const VR kDS = VRDecimalString.kDS;

  // String.dcm
  static const VR kAE = VRDcmString.kAE;
  static const VR kLO = VRDcmString.kLO;
  static const VR kSH = VRDcmString.kSH;

  // Code String
  static const VR kCS = VRCodeString.kCS;

  // String.Text
  static const VR kST = VRDcmText.kST;
  static const VR kLT = VRDcmText.kLT;

  // String.DateTime
  static const VR kDA = VRDcmDate.kDA;
  static const VR kDT = VRDcmDateTime.kDT;
  static const VR kTM = VRDcmTime.kTM;

  // String.Other
  static const VR kPN = VRPersonName.kPN;
  static const VR kUI = VRUid.kUI;
  static const VR kAS = VRDcmAge.kAS;

  // String with long Value Field
  static const VR kUC = VRDcmString.kUC;
  static const VR kUR = VRUri.kUR;
  static const VR kUT = VRDcmText.kUT;

  // Placeholder for Bulkdata Reference
   static const VR kBR = VRUnknown.kBR;

  // Special values used by Tag
  static const VR kOBOW = VR.kUN;
  static const VR kUSSS = VR.kUN;
  static const VR kUSSSOW = VR.kUN;
  static const VR kUSOW = VR.kUN;
  static const VR kUSOW1 = VR.kUN;

  static const List<VR> vrList = const <VR>[
    kInvalid,
    kAE, kAS, kAT, kBR, kCS,
    kDA, kDS, kDT, kFD, kFL,
    kIS, kLO, kLT, kOB, kOD,
    kOF, kOL, kOW, kPN, kSH,
    kSL, kSQ, kSS, kST, kTM,
    kUC, kUI, kUL, kUN, kUR,
    kUS, kUT // stop reformat
  ];

  static const Map<int, VR> vrMap = const <int, VR>{
    0x0000: kInvalid,
    0x4541: kAE, 0x5341: kAS, 0x5441: kAT, 0x5242: kBR, 0x5343: kCS,
    0x4144: kDA, 0x5344: kDS, 0x5444: kDT, 0x4446: kFD, 0x4c46: kFL,
    0x5349: kIS, 0x4f4c: kLO, 0x544c: kLT, 0x424f: kOB, 0x444f: kOD,
    0x464f: kOF, 0x4c4f: kOL, 0x574f: kOW, 0x4e50: kPN, 0x4853: kSH,
    0x4c53: kSL, 0x5153: kSQ, 0x5353: kSS, 0x5453: kST, 0x4d54: kTM,
    0x4355: kUC, 0x4955: kUI, 0x4c55: kUL, 0x4e55: kUN, 0x5255: kUR,
    0x5355: kUS, 0x5455: kUT // stop reformat
  };

  bool get isBinary => false;
  bool get isString => false;

  static VR lookup(int vrCode) => vrMap[vrCode];

  static const Map<String, VR> _idMap = const <String, VR>{
    "AE": kAE, "AS": kAS, "BR": kBR, "CS": kCS,
    "DA": kDA, "DS": kDS, "DT": kDT, "IS": kIS,
    "LO": kLO, "LT": kLT, "PN": kPN, "SH": kSH,
    "ST": kST, "TM": kTM, "UC": kUC, "UI": kUI,
    "UR": kUR, "UT": kUT, "AT": kAT, "OB": kOB,
    "OW": kOW, "SL": kSL, "SS": kSS, "UL": kUL,
    "US": kUS, "FD": kFD, "FL": kFL, "OD": kOD,
    "OF": VR.kOF // prevent reformat
  };

  static VR lookupId(String id) => _idMap[id];
}

//TODO: clean this up. remove VR.kUnknown and VR.kBR. How to handle SQ
class VRUnknown extends VR<int> {
  const VRUnknown._(int index, int code, String id, int elementSize,
      int vfLengthSize, int maxVFLength, String keyword)
      : super(index, code, id, 1, 4, kMaxLongVF, keyword, true);

  @override
  bool get isBinary => true;
  @override
  bool get isString => false;

  //index, code, id, elementSize, vfLengthSize, maxVFLength, keyword
  /// UN - Unknown. The supertype of all VRs
  static const VRUnknown kUN =
      const VRUnknown._(29, 0x4e55, "UN", 1, 4, kMaxUN, "Unknown");

  //TODO: this should have its own class
  static const VRUnknown kBR = const VRUnknown._(4, 0x5242, "BR", 0, 0, -1, "B"
  "DRef");

}

//TODO: clean this up. remove VR.kUnknown and VR.kBR. How to handle SQ
class VRSequence extends VR<int> {
  // 8 is the size of an empty [Item].
  @override
  final int minValueLength = 8;
  @override
  final int maxValueLength = kMaxLongVF;

  const VRSequence._(int index, int code, String id, int elementSize,
      int vfLengthSize, int maxVFLength, String keyword)
      : super(index, code, id, 1, 4, kMaxLongVF, keyword, true);

  bool get isSequence => true;

  //index, code, id, elementSize, vfLengthSize, maxVFLength, keyword
  static const VR kSQ =
      const VRSequence._(22, 0x5153, "SQ", 1, 4, kMaxLongVF, "Sequence");
}


class VRInvalid extends VR<int> {
  const VRInvalid._(int index, int code, String id, int elementSize,
      int vfLengthSize, int maxVFLength, String keyword)
      : super(index, code, id, 1, 4, kMaxLongVF, keyword);

  static const VRUnknown kInvalid = const VRUnknown._(0, 0, "Invalid", 0, 0,
      0, "Invalid VR");
}

