// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

import 'tag_type.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

/// A [const] [class] containing complete DICOM Data Element Definitions.
class Tag {
  /// The [index] in [TagList] for this [Tag]
  final int index;
  final int tag; // 32-bit integer from PS3.6
  final String keyword;
  final String name;
  final VR vr;
  // vrIndex, vrMaxLength, vrSizeInBytes,
  final VM vm;
  // index, min, max, width
  final TagType type;
  final bool isPublic;
  final bool isRetired;

  const Tag(this.index, this.tag, this.keyword, this.name, this.vr, this.vm, this.type,
      this.isPublic, this.isRetired);

  String get hex => '0x' + Int.hex(tag, 8);

  /// Returns [tag] in DICOM format '(gggg,eeee)'.
  String get dcm => '(${Int.hex(group)},${Int.hex(elt)})';

  /// Returns the group number of [tag].
  int get group => tag >> 16;

  /// Returns the [tagGroup] number as a hex [String].
  String get groupHex => Int.hex(group, 4);

  /// Returns the dictionary number of [tag].
  int get elt => tag & kElementMask;

  /// Returns the dictionary number as a hex [String].
  String get eltHex => Int.hex(elt, 4);

  int get elementSize => vr.sizeInBytes;

  bool get isPrivate => !isPublic;

  // VR Getters
  int get sizeInBytes => vr.sizeInBytes;

  // VM Getters
  int get vmMin => vm.min;
  int get vmMax => vm.max;
  int get vmWidth => vm.width;
  bool get isSingleton => vm.isSingleton;

  bool hasValidLength(List values) => vm.validate(values);

  static Tag lookup(int tag) {
    //TODO: fix
    Tag def = tagsMap[tag];
    if (def != null) return def;

    // Retired _special case_ tags that still must be handled

    // (0020,31xx)
    if ((tag >= 0x00283100) && (tag <= 0x002031FF)) return Tag.kSourceImageIDs;

    // (0028,04X0)
    if ((tag >= 0x00280410) && (tag <= 0x002804F0)) return Tag.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((tag >= 0x00280411) && (tag <= 0x002804F1)) return Tag.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((tag >= 0x00280412) && (tag <= 0x002804F2)) return Tag.kCoefficientCoding;
    // (0028,04X3)
    if ((tag >= 0x00280413) && (tag <= 0x002804F3)) return Tag.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((tag >= 0x00280810) && (tag <= 0x002808F0)) return Tag.kCodeLabel;
    // (0028,08x2)
    if ((tag >= 0x00280812) && (tag <= 0x002808F2)) return Tag.kNumberOfTables;
    // (0028,08x3)
    if ((tag >= 0x00280813) && (tag <= 0x002808F3)) return Tag.kCodeTableLocation;
    // (0028,08x4)
    if ((tag >= 0x00280814) && (tag <= 0x002808F4)) return Tag.kBitsForCodeWord;
    // (0028,08x8)
    if ((tag >= 0x00280818) && (tag <= 0x002808F8)) return Tag.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((tag >= 0x10000000) && (tag <= 0x1000FFF0)) return Tag.kEscapeTriplet;
    // (1000,04X3)
    if ((tag >= 0x10000001) && (tag <= 0x1000FFF1)) return Tag.kRunLengthTriplet;
    // (1000,08x0)
    if ((tag >= 0x10000002) && (tag <= 0x1000FFF2)) return Tag.kHuffmanTableSize;
    // (1000,08x2)
    if ((tag >= 0x10000003) && (tag <= 0x1000FFF3)) return Tag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((tag >= 0x10000004) && (tag <= 0x1000FFF4)) return Tag.kShiftTableSize;
    // (1000,08x4)
    if ((tag >= 0x10000005) && (tag <= 0x1000FFF5)) return Tag.kShiftTableTriplet;
    // (1000,08x8)
    if ((tag >= 0x10100000) && (tag <= 0x1010FFFF)) return Tag.kZonalMap;

    //TODO: 0x50xx,yyyy Elements
    //TODO: 0x60xx,yyyy Elements
    //TODO: 0x7Fxx,yyyy Elements

    // No match return [null]
    return null;
  }

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'Tag: $dcm $keyword, $vr, $vm, $retired';
  }

// **** Special Constants ****
//TODO fix indexes

  //(0020,3100)
  static const Tag kSourceImageIDs = const Tag(-1, 0x00203100, "SourceImageIDs", "Source Image IDs",
      VR.kCS, VM.k1_n, TagType.kUnknown, true, true);

  //(0028,04X0)
  static const Tag kRowsForNthOrderCoefficients = const Tag(
      -1,
      0x002804F0,
      "RowsForNthOrderCoefficients",
      "Rows For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      TagType.kUnknown,
      true,
      true);

  //(0028,04X1)
  static const Tag kColumnsForNthOrderCoefficients = const Tag(
      -1,
      0x00280401,
      "ColumnsForNthOrderCoefficients",
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      TagType.kUnknown,
      true,
      true);

  //(0028,0402)
  static const Tag kCoefficientCoding = const Tag(-1, 0x00280402, "CoefficientCoding",
      "Coefficient Coding", VR.kLO, VM.k1_n, TagType.kUnknown, true, true);

  //(0028,0403)
  static const Tag kCoefficientCodingPointers = const Tag(
      -1,
      0x00280403,
      "CoefficientCodingPointers",
      "Coefficient Coding Pointers",
      VR.kAT,
      VM.k1_n,
      TagType.kUnknown,
      true,
      true);

  //(0028,0800)
  static const Tag kCodeLabel = const Tag(
      -1, 0x00280800, "CodeLabel", "Code Label", VR.kCS, VM.k1_n, TagType.kUnknown, true, true);
  //(0028,0802)
  static const Tag kNumberOfTables = const Tag(-1, 0x00280802, "NumberOfTables", "Number of Tables",
      VR.kUS, VM.k1, TagType.kUnknown, true, true);
  //(0028,0803)
  static const Tag kCodeTableLocation = const Tag(-1, 0x00280803, "CodeTableLocation",
      "Code Table Location", VR.kAT, VM.k1_n, TagType.kUnknown, true, true);

  //(0028,0804)
  static const Tag kBitsForCodeWord = const Tag(-1, 0x00280804, "BitsForCodeWord",
      "Bits For Code Word", VR.kUS, VM.k1, TagType.kUnknown, true, true);
  //(0028,0808)
  static const Tag kImageDataLocation = const Tag(-1, 0x00280808, "ImageDataLocation",
      "Image Data Location", VR.kAT, VM.k1_n, TagType.kUnknown, true, true);

  //(1000,0000)
  static const Tag kEscapeTriplet = const Tag(-1, 0x10000000, "EscapeTriplet", "Escape Triplet",
      VR.kUS, VM.k3, TagType.kUnknown, true, true);

  //(1000,0001)
  static const Tag kRunLengthTriplet = const Tag(-1, 0x10000001, "RunLengthTriplet",
      "Run Length Triplet", VR.kUS, VM.k3, TagType.kUnknown, true, true);

  //(1000,0002)
  static const Tag kHuffmanTableSize = const Tag(-1, 0x10000002, "HuffmanTableSize",
      "Huffman Table Size", VR.kUS, VM.k1, TagType.kUnknown, true, true);

  //(1000,0003)
  static const Tag kHuffmanTableTriplet = const Tag(-1, 0x10000003, "HuffmanTableTriplet",
      "Huffman Table Triplet", VR.kUS, VM.k3, TagType.kUnknown, true, true);

  //(1000,0004)
  static const Tag kShiftTableSize = const Tag(-1, 0x10000004, "ShiftTableSize", "Shift Table Size",
      VR.kUS, VM.k1, TagType.kUnknown, true, true);

  //(1000,0005)
  static const Tag kShiftTableTriplet = const Tag(-1, 0x10000005, "ShiftTableTriplet",
      "Shift Table Triplet", VR.kUS, VM.k3, TagType.kUnknown, true, true);

  //(1010,0000)
  static const Tag kZonalMap = const Tag(
      -1, 0x10100000, "ZonalMap", "Zonal Map", VR.kUS, VM.k1_n, TagType.kUnknown, true, true);

  static isValid(int code) => isValidPublic(code) || isValidPrivate(code);

  /// Returns [true] if [tag] is defined by the DICOM Standard.
  static bool isValidPublic(int code) => publicCodes[code] != null;

  /// Returns [true] if [tag] is defined by the Standard.
  static bool isKnownPrivate(int code) => knownPrivateCodes[code] != null;

  static bool isValidPrivate(int code) {
    int g = code >> 16;
    return g.isOdd && (0x0007 < g && g != 0xFFFF) ? true : false;
  }

  /// Returns [true] if [v] fits in 16-bits.
  static bool validElt(int v) => (0 <= v && v <= 0xFFFF) ? true : false;

  static int validateElt(int v) => validElt(v) ? v : null;

  static int toGroup(int code) => code >> 16;

  static int toElt(int code) => code & kElementMask;

  /// Returns [tag] in DICOM format '(gggg,eeee)'.
  static String toDcm(int code) => '(${Int.hex(toGroup(code))},${Int.hex(toElt(code))})';

  /// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
  static Iterable<String> listToDcm(List<int> list) => list.map(toDcm);

  /// Takes a [String] in format "(gggg,eeee)" and returns [int].
  static int dcmToInt(String tag) {
    String tmp = tag.substring(1, 5) + tag.substring(6, 10);
    return int.parse(tmp, radix: 16);
  }

  //*** Sequence & Item Utilities ***

  /// Returns [true] if
  static bool isSQEnd(int tag) => tag == kSequenceDelimitationItem;

  /// Returns [true] if [tag] is  ItemTag
  static bool isItem(int tag) => tag == kItem;

  static bool isItemEnd(int tag) => tag == kItemDelimitationItem;

  // Tag Validators
  static bool rangeError(int tag, int min, int max) {
    String msg = 'invalid tag: $tag not in $min <= x <= $max';
    throw new RangeError(msg);
  }

  /// A map of all Public [Tag] [tag]s to [Tag].
  static final Map<int, Tag> publicCodes = const {};

  /// A map of all Public [Tag] [tag]s to [Tag].
  static final Map<int, Tag> keywords = const {};

  /// A map of all known Private [Tag] [tag]s to [Tag].
  static final Map<int, Tag> knownPrivateCodes = const {};
}
