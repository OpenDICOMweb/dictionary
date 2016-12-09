// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/integer.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

import 'tag_private.dart';
import 'tag_public.dart';
import 'tag_type.dart';
import 'well_known_private_tags.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

abstract class TagBase {
  final int tag;

  const TagBase(this.tag);

  VR get vr;
  VM get vm;
  String get keyword;
  String get name;
  bool get isPublic;

  bool get isImplicitVR => vr == VR.kUnknown;
  bool get isExplicitVR => !isImplicitVR;

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

  String toString() => '$runtimeType$dcm $vr';
}

/// [const
class Tag extends TagBase {
  final String keyword = "Unknown";
  final String name = "Unknown";
  final VM vm = VM.kUnknown;
  final TagType type = TagType.kUnknown;
  final bool isPublic = true;

  final VR vr;

  const Tag(int tag, this.vr) : super(tag);

  /// Creates an Tag with Implicit VR.
  factory Tag.implicit(int tag) {
    if (isPublicTag(tag)) {
      WKTag wkTag = WKTag.wellKnown(tag);
      return (wkTag != null) ? wkTag : throw "Invalid Public Tag(${toDcm(tag)}";
    } else {
      PrivateTag wkTag = wellKnownPrivateTags[tag];
      return (wkTag != null) ? wkTag : new Tag(tag, VR.kUnknown);
    }
  }

  static int getGroup(int tag) => tag >> 16;

  static int getElt(int tag) => tag & 0xFFFF;

  static bool isPublicTag(int tag) => getGroup(tag).isEven;

  static bool isPrivateTag(int tag) {
    int g = getPrivateGroup(tag);
    return (g == null) ? false : true;
  }

  static int getPrivateGroup(int tag) {
    if (isPublicTag(tag)) return null;
    int g = tag >> 16;
    return (g.isOdd && (0x0007 < g && g != 0xFFFF)) ? g : null;
  }

  static bool isPrivateCreator(int tag) {
    if (isPrivateTag(tag)) {
      int elt = getElt(tag);
      return 0x10 <= elt && elt <= 0xFF;
    }
    return false;
  }

  static bool isPrivateData(int tag) {
    if (isPrivateTag(tag)) {
      int elt = getElt(tag);
      return 0x1000 <= elt && elt <= 0xFFFF;
    }
    return false;
  }

  //TODO: needed
  //static isValid(int code) => isValidPublic(code) || isValidPrivate(code);

  //TODO: needed?
  /// Returns [true] if [tag] is defined by the DICOM Standard.
  //static bool isValidPublic(int code) => publicCodes[code] != null;

  //TODO: needed?
  /// Returns [true] if [tag] is defined by the Standard.
  //static bool isKnownPrivate(int code) => knownPrivateCodes[code] != null;

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

  //TODO: needed?
  // static isValid(TagBase tag) => tag.group.isOdd && tag.isPrivateCreator;

  /// Returns the Well Known [PrivateCreatorTag] that corresponds to [tag].
  //TODO: could throw an error if [tag] is Public and not recognized.
  static wellKnown(int tag) =>
      (isPublicTag(tag)) ? wellKnownPrivateTags[tag] : wellKnownPrivateTags[tag];
}
