// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

import 'tag_type.dart';

//                               Tag,
//                       Group,       Elt,    Index, VR, Sz, VM,  Mn, Mx,  W,   T,  R,  P,  x
//                      0     1     2     3   4   5   6   7   8    9  10  11   12  13  14  15
// const bd = const [0x00, 0x08, 0x00, 0x05, 00, 00, 00, 00, 00,  00, 00, 00,  00, 00, 00, 00];


//TODO: vrs[0] = VR.kUnknown;
//TODO vms[0] = VM.kUnknown;
//TODO: tagIndex[0] = Tag.kUnknown;
//TODO: tagTypes[0] = TagTypes.kUnknown;
//TODO:

const kTagOffset = 0;        // Tag
const kGroupOffset = 0;      // Group
const kEltOffset = 2;        // Elt
const kIndexOffset = 4;      // Index
const kVRIndexOffset = 6;    // VR
const kVRElementSize = 7;    // Sz
const kVRSizeInBytes = 7;    // Sz
const kVMIndexOffset = 8;    // VM
const kMinOffset = 9;        // Mn
const kMaxOffset = 10;       // Mx
const kWidthOffset = 11;     // W
const kTypeOffset = 12;      // T
const kIsRetiredOffset = 13; // R
const kUnused0 = 14;         // Reserved 0
const kUnused1 = 15;         // Reserved 1

//NOTE: Type can include DataElement Type, and Public

/// The
abstract class TagBase {
  static const bool public = true;
  /// The [ByteData] containing values for the [Tag].
  final ByteData bd;

  const TagBase(this.bd);

  bool get isPublic => public;
  bool get isPrivate => !isPublic;

  /// Returns the 32-bit [Tag] number from PS3.6.
  int get tag => bd.getUint32(kTagOffset);

  /// Return the hexadecimal [String] corresponding to [tag].
  String get hex => '0x' + Int.hex(tag, 8);

  /// Returns a DICOM format (gggg,eeee) [String] corresponding to [tag].
  String get dcm => '(${Int.hex(group)},${Int.hex(elt)})';

  /// Returns the group number of [tag].
  int get group => bd.getUint16(kGroupOffset);

  /// Returns the [tagGroup] number as a hex [String].
  String get groupHex => Int.hex(group, 4);

  /// Returns the [Elt] (Element) number of [tag].
  int get elt => bd.getUint16(kEltOffset);

  /// Returns the dictionary number as a hex [String].
  String get eltHex => Int.hex(elt, 4);

  String get keyword;
  String get name;
  VR get vr;


  bool get isImplicitVR => vr == VR.kUnknown;
  bool get isExplicitVR => !isImplicitVR;

  // VR Getters
  int get elementSize => bd.getUint8(kVRElementSize);
  int get sizeInBytes => bd.getUint8(kVRSizeInBytes);

  // VM Getters
  VM get vm;

  /// The minimum number of [values] for this element.
  ///
  /// If [min] is 0 then only 1 values is allowed. This is an optimization.
  int get min => bd.getUint8(kMinOffset);
  @deprecated
  int get vmMin => min;

  /// The maximum number of [values] for this element.
  ///
  /// If [max] is -1 then the maximum is as many values that can fit in the Value Field.
  int get max => bd.getUint8(kMaxOffset);
  @deprecated
  int get vmMax => max;

  /// The [width] of each set of [values] for this element.
  ///
  /// [width] must be greater than or equal to 1.  If [width] is greater than 1,
  /// then the minimum number of [values] is [min] * [width],
  /// and the maximum number of [values] is [max] * [width], unless [max] == -1,
  /// in which case the maximum number of [values] is as many [values] that can fit
  /// in the Value Field, but in all cases must be a even multiple of the [width].
  int get width => bd.getUint8(kWidthOffset);
  @deprecated
  int get vmWidth => width;

  /// The maximum length of the [values], i.e. Value Field.
  int get maxLength => max * width;

  //TODO: add warning to [Dataset] for any retired Data [Element]s.
  /// Returns [true] if this Data Element is retired from the DICOM Standard.
  bool get isRetired => (bd.getUint8(kIsRetiredOffset) == 0) ? false : true;


  /// Returns [true] if [values.length] is [inRange] for this element.
  bool inRange(List values) {
    int length = values.length;
    if (length < 1) throw "Invalid Values Length($length)";
    if (min == 0 && length == 1) return true;
    if (width == 1) {
      return (max == -1 || length <= maxLength) ? true : false;
    } else {
      // [width] must be greater than 1.
      return (max == -1 || length <= maxLength && length % width == 0) ? true : false;
    }
  }


  String toString() => '$runtimeType$dcm $vr';
}

//TODO add Group Length Tags for Each Group

const PublicTagData = const [
  const [0x00000000, 00, 00, 00, 00, 00,  00, 00,   00,   00, 00,   00, 00],
  //     tag,        index,  VR  VM  min  max width type isRetired
  const [0x00080000, 00, 00, 08, 09, 00,  00, 00,   01,   00, 0xFF, 0xFFFF], // Group Length
  const [0x00080005, 00, 00, 08, 09, 00,  00, 00,   01,   00, 0xFF, 0xFFFF],
  const [0x00080008, 00, 01, 07, 08, 01, -01, 01,   02,  -01, 0xFF, 0xFFFF]
];

class Tag extends TagBase {

  const Tag.bd(ByteData bd) : super(bd);

  String get keyword => tagKeywords[bd.getUint8(kIndexOffset)];
  String get name => tagKeywords[bd.getUint8(kIndexOffset)];
  VR get vr => vrs[bd.getUint8(kVRIndexOffset)];
  VM get vm => vms[bd.getUint8(kVMIndexOffset)];
  TagType get type => tagTypes[bd.getUint16(kTypeOffset)];

  static final k0008GroupLength = new Tag.bd(new ByteData.view(PublicTagData[1]));
  static final kSpecificCharacterSet = new Tag.bd(new ByteData.view(PublicTagData[2]));

  //**** can't be constant
  static Map<int, Tag> tags = {
    0x00080000: k0008GroupLength,
    0x00080008: kSpecificCharacterSet
  };

  static const List<String> tagKeywords = const ["Unknown", "foo", "bar"];
  static const List<String> tagNames = const ["Unknown", "foo", "bar"];
  static const List<VR> vrs = const [VR.kUnknown, VR.kCS, VR.kOB];
  static const List<VM> vms = const [VM.kUnknown, VM.k1, VM.k2];
  static const List<TagType> tagTypes = const [VM.kUnknown, TagType.k1, VM.k2];
}

class InvalidTag extends Tag {

  factory InvalidTag(int tag, int vrIndex) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new InvalidTag.bd(bd);
  }

  InvalidTag.bd(ByteData bd) : super.bd(bd);

}



