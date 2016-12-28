// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/integer.dart';
import 'package:dictionary/src/dicom/tag/tag_constants.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'tag.dart';
import 'tag_type.dart';
import 'wk_public_tags.dart';

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name

/// A [const] [class] containing complete DICOM Data Element Definitions.
/// These are also known as Public [Tag]s.
class WKTag extends Tag {
  final bool isPublic = true;

  final String keyword;
  final String name;
  final VM vm;
  final EType type;
  final bool isRetired;

  const WKTag._(int tag, this.keyword, this.name, VR vr, this.vm, this.type, this.isRetired)
      : super(tag, vr);

  bool operator ==(WKTag other) => other.code == code;

  bool hasValidLength(List values) => vm.validate(values);

  int get hash => Int.hash(code);

  static WKTag lookup(int tag) {
    //TODO: fix
    WKTag wkTag = wellKnownPublicTags[tag];
    if (wkTag != null) return wkTag;

    // Retired _special case_ tags that still must be handled

    // (0020,31xx)
    if ((tag >= 0x00283100) && (tag <= 0x002031FF)) return WKTag.kSourceImageIDs;

    // (0028,04X0)
    if ((tag >= 0x00280410) && (tag <= 0x002804F0)) return WKTag.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((tag >= 0x00280411) && (tag <= 0x002804F1)) return WKTag.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((tag >= 0x00280412) && (tag <= 0x002804F2)) return WKTag.kCoefficientCoding;
    // (0028,04X3)
    if ((tag >= 0x00280413) && (tag <= 0x002804F3)) return WKTag.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((tag >= 0x00280810) && (tag <= 0x002808F0)) return WKTag.kCodeLabel;
    // (0028,08x2)
    if ((tag >= 0x00280812) && (tag <= 0x002808F2)) return WKTag.kNumberOfTables;
    // (0028,08x3)
    if ((tag >= 0x00280813) && (tag <= 0x002808F3)) return WKTag.kCodeTableLocation;
    // (0028,08x4)
    if ((tag >= 0x00280814) && (tag <= 0x002808F4)) return WKTag.kBitsForCodeWord;
    // (0028,08x8)
    if ((tag >= 0x00280818) && (tag <= 0x002808F8)) return WKTag.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((tag >= 0x10000000) && (tag <= 0x1000FFF0)) return WKTag.kEscapeTriplet;
    // (1000,04X3)
    if ((tag >= 0x10000001) && (tag <= 0x1000FFF1)) return WKTag.kRunLengthTriplet;
    // (1000,08x0)
    if ((tag >= 0x10000002) && (tag <= 0x1000FFF2)) return WKTag.kHuffmanTableSize;
    // (1000,08x2)
    if ((tag >= 0x10000003) && (tag <= 0x1000FFF3)) return WKTag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((tag >= 0x10000004) && (tag <= 0x1000FFF4)) return WKTag.kShiftTableSize;
    // (1000,08x4)
    if ((tag >= 0x10000005) && (tag <= 0x1000FFF5)) return WKTag.kShiftTableTriplet;
    // (1000,08x8)
    if ((tag >= 0x10100000) && (tag <= 0x1010FFFF)) return WKTag.kZonalMap;

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
  static const WKTag kSourceImageIDs = const WKTag._(
      0x00203100, "SourceImageIDs", "Source Image IDs", VR.kCS, VM.k1_n, EType.kUnknown, true);

  //(0028,04X0)
  static const WKTag kRowsForNthOrderCoefficients = const WKTag._(
      0x002804F0,
      "RowsForNthOrderCoefficients",
      "Rows For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      EType.kUnknown,
      true);

  //(0028,04X1)
  static const WKTag kColumnsForNthOrderCoefficients = const WKTag._(
      0x00280401,
      "ColumnsForNthOrderCoefficients",
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      EType.kUnknown,
      true);

  //(0028,0402)
  static const WKTag kCoefficientCoding = const WKTag._(0x00280402, "CoefficientCoding",
      "Coefficient Coding", VR.kLO, VM.k1_n, EType.kUnknown, true);

  //(0028,0403)
  static const WKTag kCoefficientCodingPointers = const WKTag._(
      0x00280403,
      "CoefficientCodingPointers",
      "Coefficient Coding Pointers",
      VR.kAT,
      VM.k1_n,
      EType.kUnknown,
      true);

  //(0028,0800)
  static const WKTag kCodeLabel =
      const WKTag._(0x00280800, "CodeLabel", "Code Label", VR.kCS, VM.k1_n, EType.kUnknown, true);
  //(0028,0802)
  static const WKTag kNumberOfTables = const WKTag._(
      0x00280802, "NumberOfTables", "Number of Tables", VR.kUS, VM.k1, EType.kUnknown, true);
  //(0028,0803)
  static const WKTag kCodeTableLocation = const WKTag._(0x00280803, "CodeTableLocation",
      "Code Table Location", VR.kAT, VM.k1_n, EType.kUnknown, true);

  //(0028,0804)
  static const WKTag kBitsForCodeWord = const WKTag._(
      0x00280804, "BitsForCodeWord", "Bits For Code Word", VR.kUS, VM.k1, EType.kUnknown, true);
  //(0028,0808)
  static const WKTag kImageDataLocation = const WKTag._(0x00280808, "ImageDataLocation",
      "Image Data Location", VR.kAT, VM.k1_n, EType.kUnknown, true);

  //(1000,0000)
  static const WKTag kEscapeTriplet = const WKTag._(
      0x10000000, "EscapeTriplet", "Escape Triplet", VR.kUS, VM.k3, EType.kUnknown, true);

  //(1000,0001)
  static const WKTag kRunLengthTriplet = const WKTag._(
      0x10000001, "RunLengthTriplet", "Run Length Triplet", VR.kUS, VM.k3, EType.kUnknown, true);

  //(1000,0002)
  static const WKTag kHuffmanTableSize = const WKTag._(
      0x10000002, "HuffmanTableSize", "Huffman Table Size", VR.kUS, VM.k1, EType.kUnknown, true);

  //(1000,0003)
  static const WKTag kHuffmanTableTriplet = const WKTag._(0x10000003, "HuffmanTableTriplet",
      "Huffman Table Triplet", VR.kUS, VM.k3, EType.kUnknown, true);

  //(1000,0004)
  static const WKTag kShiftTableSize = const WKTag._(
      0x10000004, "ShiftTableSize", "Shift Table Size", VR.kUS, VM.k1, EType.kUnknown, true);

  //(1000,0005)
  static const WKTag kShiftTableTriplet = const WKTag._(0x10000005, "ShiftTableTriplet",
      "Shift Table Triplet", VR.kUS, VM.k3, EType.kUnknown, true);

  //(1010,0000)
  static const WKTag kZonalMap =
      const WKTag._(0x10100000, "ZonalMap", "Zonal Map", VR.kUS, VM.k1_n, EType.kUnknown, true);

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

  /// A map of all Public [Tag] [code]s to [WKTag].
  //TODO: needed?
  static final Map<int, WKTag> publicCodes = const {};

  /// A map of all Public [Tag] [code]s to [WKTag].
  static final Map<int, WKTag> keywords = const {};

  /// A map of all known Private [Tag] [code]s to [WKTag].
  static final Map<int, WKTag> knownPrivateCodes = const {};

  /// Returns the Well Known [PrivateCreatorTag] that corresponds to [tag].
  static wellKnown(int tag) => _wellKnown[tag];

  /// [Map] of Well Known [WKTag]s.
  static const Map<int, WKTag> _wellKnown = const {};
}
