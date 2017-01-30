// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


const String header = '''
// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


//TODO: have these libraries load lazily
import 'package:core/dictionary.dart';
import 'package:core/vm.dart';
import 'package:core/vr.dart';

import 'tag_type_map.dart';

/// A library for handling DICOM Tags.
///
/// Compile-Time static constant definitions for Standard DICOM Data [Element] [Tag]s.
/// Each [Tag] contains the integer value of the associated Data [Element] definition
/// (see PS3.6).
///
/// Note: Some Data Elements [tag]s that specify ranges do not have [int] values,
/// these [tag]s are defined with string values.
//TODO: define a TagRange class for tags that have xx's in them
class Tag {
  //TODO: fix link
  // Standard Library definitions
  static String docLink = 'doc/dicom/dart/tag.html';

  /// The minimum legal [Tag] value.
  static const Tag kMinTag = kFileMetaInformationGroupLength;

  /// The maximum legal [Tag] value.
  static const Tag kMaxTag = kSequenceDelimitationItem;

  final int tag;

  const Tag(this.tag);

  /// Returns the [Tag] corresponding the [value], or [null];
  static Tag lookup(int value) => tagMap[value];

  String get keyword => Element.lookup(tag).keyword;

  String get name => Element.lookup(tag).name;

  VR get vr => Element.lookup(tag).vr;

  VM get vm => Element.lookup(tag).vm;

  bool get isRetired => Element.lookup(tag).isRetired;


  //**** Tag Groups and Elements

  /// A bit mask, which when bitwise-anded (&) with [tag] returns [tagGroup].
  static const int kGroupMask = 0xFFFF0000;

  /// A bit mask, which when bitwise-anded (&) with [tag] returns [tagElement].
  static const int kElementMask = 0x0000FFFF;


  static int intToGroup(int v) => v >> 16;

  static int intToElement(int v) => v & kElementMask;

  static String intToHex(int v, [int padding = 8]) =>
      "0x" + v.toRadixString(16).padLeft(padding, "0");

  /// Returns the group number of [tag].
  int get group => tag >> 16;

  String get groupHex => intToHex(group, 4);

  int get dictionary => tag & kElementMask;

  String get elementHex => intToHex(dictionary, 4);

  /// Returns a hex [String] 8 characters long with a "0x" prefix.
  String get hex => intToHex(tag);

  /// Returns [tag] in DICOM format '(gggg,eeee)'.
  String get dcm => (\$groupHex,\$elementHex);

  //TODO:  move to Integer
  /// Returns a [List<String>], of decimal [String]s.
  static Iterable <String> intListToString(List<int> list) =>
      list.map((int i) => i.toRadixString(10));

//Flush
  /// Returns [true] if the [VR] of the [Tag] is [SQ].
//bool isSQTag(int tag) => tagToTagClassMap[tag].vr == VR.kSQ;

  bool isSQEndTag(int tag) => tag == kSequenceDelimitationItem;

  //**** Item related

  /// The length of a [Sequence] or [Item] DelimitationItem field.
  static const int kDelimitationItemLength = 8;

  /// Returns [true] if [tag] is  ItemTag
  bool get isItem => tag == kItem;

  bool get isItemEnd => tag == kItemDelimitationItem;

  // Tag Validators
  // Internal implementation of Tag Validators
  Exception rangeError(Tag min, Tag max) {
    String msg = 'invalid tag: \$tag not inRange of \$min <= x <= \$max';
    throw new RangeError(msg);
  }

  bool checkRange(test(Tag min, Tag max), Tag min, Tag max) =>
      test(min, max) ? true : rangeError(min, max);

  /// True for any Tag in the DICOM range, false otherwise.
  /// The minimum legal tag value.
  bool get inRange =>
    (kMinTag.tag <= tag) && (tag <= kMaxTag.tag);

  /// [True] for any File Meta Information [Tag], false otherwise.
  /// Note: Does not test flag validity
  bool get isFmiTag =>
      (kMinFmiTag.tag <= tag) && (tag <= kMaxFmiTag.tag);

  /// Returns [true] if [tag] is in the range of DICOM Directory Tags
  bool get isDcmDir =>
      (kMinDcmDirTag.tag <= tag) && (tag <= kMaxDcmDirTag.tag);


  /// [True] for any [Tag] that can be contained in a general [Dataset], false otherwise.
  bool get inDataset =>
    (kMinDatasetTag.tag <= tag) && (tag <= kMaxDatasetTag.tag);

  //TODO: document & add error value
  static int toInt(String s) {
    s = s.replaceAll('(),', "");
    return int.parse(s, radix: 16);
  }

  //TODO: improve this by checking the dictionary table
  /// Returns true if the tag is defined by DICOM, false otherwise
  /// All DICOM Public tags have group numbers that are even.
  /// Note: This only checks that the group number is even.
  bool get isPublic => true;

  /// Returns [true] if [tag] is a valid DICOM Private Tag.
  bool get isPrivate => false;

  /// Returns true if [tag] is a valid [PrivateCreator] tag.
  bool get isPrivateCreator => false;

  //**** Static Methods ****
  /// Returns a [List] of DICOM tag codes in '0xggggeeee format
  static List<String> listToHex(List<Tag> list) => list.map((Tag t) => t.hex);

  /// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
  static Iterable<String> listToDcm(List<Tag> list) => list.map((Tag t) => t.dcm);


  //**** Standard Tags defined in PS3.6 ****

  /// File Meta Info Tag definitions. All File Meta Info tag have a group number of 0x0004.

  /// The minimum File Meta Information [Tag] value.
  static const Tag kMinFmiTag = kFileMetaInformationGroupLength;

  /// The maximum File Meta Info [Tag] value.
  static const Tag kMaxFmiTag = kPrivateInformation;

''';

const String getters = '''

''';