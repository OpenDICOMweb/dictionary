// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'e_type.dart';

//                               Tag,
//                       Group,       Elt,    Index, VR, Sz, VM,  Mn, Mx,  W,   T,  R,  P,  x
//                      0     1     2     3   4   5   6   7   8    9  10  11   12  13  14  15
// const bd = const [0x00, 0x08, 0x00, 0x05, 00, 00, 00, 00, 00,  00, 00, 00,  00, 00, 00, 00];

//TODO: vrs[0] = VR.kUnknown;
//TODO vms[0] = VM.kUnknown;
//TODO: tagIndex[0] = Tag.kUnknown;
//TODO: tagTypes[0] = TagTypes.kUnknown;
//TODO:

const int kTagOffset = 0; // Tag
const int kGroupOffset = 0; // Group
const int kEltOffset = 2; // Elt
const int kIndexOffset = 4; // Index
const int kVRIndexOffset = 6; // VR
const int kVRElementSize = 7; // Sz
const int kVRSizeInBytes = 7; // Sz
const int kVMIndexOffset = 8; // VM
const int kMinOffset = 9; // Mn
const int kMaxOffset = 10; // Mx
const int kWidthOffset = 11; // W
const int kTypeOffset = 12; // T
const int kIsRetiredOffset = 13; // R
const int kUnused0 = 14; // Reserved 0
const int kUnused1 = 15; // Reserved 1

//NOTE: Type can include DataElement Type, and Public

/// The
abstract class TagBase {
  static const bool public = true;

  final Uint8List _bytes;
  /// The [ByteData] containing values for the [Tag].
  final ByteData _bd;

  const TagBase(this._bytes, this._bd);

  bool get isPublic => public;
  bool get isPrivate => !isPublic;

  /// Returns the 32-bit [Tag] number from PS3.6.
  int get tag => _bd.getUint32(kTagOffset);

  /// Return the hexadecimal [String] corresponding to [tag].
  String get hex => '0x' + Int.hex(tag, 8);

  /// Returns a DICOM format (gggg,eeee) [String] corresponding to [tag].
  String get dcm => '(${Int.hex(group)},${Int.hex(elt)})';

  /// Returns the group number of [tag].
  int get group => _bd.getUint16(kGroupOffset);

  /// Returns the [group] number as a hex [String].
  String get groupHex => Int.hex(group, 4);

  /// Returns the [elt] (Element) number of [tag].
  int get elt => _bd.getUint16(kEltOffset);

  /// Returns the [elt] number as a hex [String].
  String get eltHex => Int.hex(elt, 4);

  String get keyword;
  String get name;
  VR get vr;

  bool get isImplicitVR => vr == VR.kNoVR;
  bool get isExplicitVR => !isImplicitVR;

  // VR Getters
  int get elementSize => _bd.getUint8(kVRElementSize);
  int get sizeInBytes => _bd.getUint8(kVRSizeInBytes);

  // VM Getters
  VM get vm;

  /// The minimum number of values for this element.
  ///
  /// If [min] is 0 then only 1 values is allowed. This is an optimization.
  int get min => _bd.getUint8(kMinOffset);
  @deprecated
  int get vmMin => min;

  /// The maximum number of values for this element.
  ///
  /// If [max] is -1 then the maximum is as many values that can fit in the Value Field.
  int get max => _bd.getUint8(kMaxOffset);
  @deprecated
  int get vmMax => max;

  /// The [width] of each set of values for this element.
  ///
  /// [width] must be greater than or equal to 1.  If [width] is greater than 1,
  /// then the minimum number of values is [min] * [width],
  /// and the maximum number of values is [max] * [width], unless [max] == -1,
  /// in which case the maximum number of values is as many values that can fit
  /// in the Value Field, but in all cases must be a even multiple of the [width].
  int get width => _bd.getUint8(kWidthOffset);
  @deprecated
  int get vmWidth => width;

  /// The maximum length of the values, i.e. Value Field.
  int get maxLength => max * width;

  EType get type => EType.list[_bd.getUint8(kTypeOffset)];

  //TODO: add warning to [Dataset] for any retired Data [Element]s.
  /// Returns [true] if this Data Element is retired from the DICOM Standard.
  bool get isRetired => (_bd.getUint8(kIsRetiredOffset) == 0) ? false : true;

  /// Returns [true] if [List] length is [inRange] for this element.
  bool inRange(List values) {
    int length = values.length;
    if (length < 1) throw new ArgumentError("Invalid Values Length($length)");
    if (min == 0 && length == 1) return true;
    if (width == 1) {
      return (max == -1 || length <= maxLength) ? true : false;
    } else {
      // [width] must be greater than 1.
      return (max == -1 || length <= maxLength && length % width == 0) ? true : false;
    }
  }

  String toString() {
    String retired = (isRetired) ? "Retired" : "";
    return '$runtimeType$dcm VR($vr) VM($vm) Type($type) $retired';
  }
}

//TODO add Group Length Tags for Each Group

//TODO: generate this table
const List<List<int>> PublicTagData = const <List<int>>[
  const <int>[0x00000000, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
  //     tag,        index,  VR  VM  min  max width type isRetired
  const <int>[0x00080000, 00, 00, 08, 09, 00, 00, 00, 01, 00, 0xFF, 0xFFFF], // Group Length
  const <int>[0x00080005, 00, 00, 08, 09, 00, 00, 00, 01, 00, 0xFF, 0xFFFF],
  const <int>[0x00080008, 00, 01, 07, 08, 01, -01, 01, 02, -01, 0xFF, 0xFFFF]
];

const Uint8List foo =

class Tag extends TagBase {
  const Tag._(Uint8List bytes, ByteData bd) : super(bytes,bd);

  String get keyword => tagKeywords[_bd.getUint8(kIndexOffset)];
  String get name => tagKeywords[_bd.getUint8(kIndexOffset)];
  VR get vr => vrs[_bd.getUint8(kVRIndexOffset)];
  VM get vm => vms[_bd.getUint8(kVMIndexOffset)];

  static final k0008GroupLength = new Tag_(new Uint8List.fromList(PublicTagData[1]));
  static final kSpecificCharacterSet = new Tag_bd(new ByteData.fromList(PublicTagData[2]));

  //**** Can't be constant because there is no way to make ByteData constant
  static final  Map<int, Tag> tags =  {
    0x00080000: k0008GroupLength,
    0x00080008: kSpecificCharacterSet
  };

  static const List<String> tagKeywords = const ["Unknown", "foo", "bar"];
  static const List<String> tagNames = const ["Unknown", "foo", "bar"];
  static const List<VR> vrs = const [VR.kNoVR, VR.kCS, VR.kOB];
  static const List<VM> vms = const [VM.kUnknown, VM.k1, VM.k2];
  static const List<EType> tagTypes =
      const [EType.kUnknown, EType.k1, EType.k1c, EType.k2, EType.k2c, EType.k3];
}

class InvalidTag extends Tag {
  factory InvalidTag(int tag, int vrIndex) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new InvalidTag_bd(bd);
  }

  InvalidTag._bd(ByteData bd) : super_bd(bd);
}
