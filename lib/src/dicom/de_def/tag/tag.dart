// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

/// A [const] [class] containing complete DICOM Data Element Definitions.
class TagBase {
  final int code; // 32-bit integer
  final int index;
  final String keyword;
  final String name;
  final VR vr;
  // vrIndex
  // vr.vfLength
  final VM vm;
  // index, min, max, width
  final bool isPublic;
  final bool isRetired;

  const TagBase(this.code, this.index, this.keyword, this.name, this.vr, this.vm,
                this.isPublic, this.isRetired);

  String get hex => '0x' + Int.hex(code, 8);

  /// Returns [tag] in DICOM format '(gggg,eeee)'.
  String get dcm => '(${Int.hex(group)},${Int.hex(elt)})';

  /// Returns the group number of [tag].
  int get group => code >> 16;

  /// Returns the [tagGroup] number as a hex [String].
  String get groupHex => Int.hex(group, 4);


  /// Returns the dictionary number of [tag].
  int get elt => code & kElementMask;

  /// Returns the dictionary number as a hex [String].
  String get eltHex => Int.hex(elt, 4);

  int get elementSize => vr.sizeInBytes;

  bool get isPrivate => !isPublic;

  // VR Getters
  int get sizeInBytes => vr.sizeInBytes;

  // VM Getters
  int get minValues => vm.min;
  int get maxValues => vm.max;
  int get valuesWidth => vm.width;
  bool get isSingleton => vm.isSingleton;
  bool hasValidLength(List values) => vm.validate(values);



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
  static String  toDcm(int code) => '(${Int.hex(toGroup(code))},${Int.hex(toElt(code))})';

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

  /// A map of all Public [Tag] [code]s to [Tag].
  static final Map<int, Tag> publicCodes = const {

  };

  /// A map of all Public [Tag] [code]s to [Tag].
  static final Map<int, Tag> keywords = const {

  };

  /// A map of all known Private [Tag] [code]s to [Tag].
  static final Map<int, Tag> knownPrivateCodes = const {

  };

}

/*
class Tag implements TagBase {
  final TagBase t;
  final DEType type;

  const Tag(this.t, this.type);

  int get code => t.code;


}
*/