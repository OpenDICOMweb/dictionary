// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/integer/integer.dart';
import 'package:dictionary/src/dicom/de_def/element_def.dart';

import 'tag_constants.dart';

// **** Tag Utilities ****

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

/// Methods to use with a DICOM Group, a 16-bit integer.
///
/// The [Group] methods expect their argument to be a 16-bit group number.
class Group {
  /// Returns [true] if [g] is Public Group (even) or a valid Private Group. fits in 16-bits.
  static bool isValid(int g) => g.isEven || isPrivate(g);

  /// Returns the Group Number is it is a valid Group Number.
  static int valid(int g) => (isValid(g)) ? g : null;

  /// Returns[true] is [g] is a valid Public Group Number.
  static bool isPublic(int g) => g.isEven && 0x0008 <= g  && g <= 0xFFFC;

  static bool isNotPublic(int g) => !isPublic(g);

  /// Returns [true] if [g] is a valid Private Group Number.
  static bool isPrivate(int g)=> g.isOdd && (0x0007 < g && g < 0xFFFF);

  static int validPrivate(int g) => (isPrivate(g)) ? g : null;

  static bool isNotPrivate(int g) => !isPrivate(g);

  /// Returns the [tagGroup] number as a hex [String].
  static String hex(int g) => Int.hex(g, 4);

  //static int validateGroup(int tag) => validGroup(tag) ? tag : null;
}

class Elt {
  /// Returns the [Elt] [int] as a hex [String].
  static String hex(int elt) => Group.hex(elt);

  /// Returns [true] if [v] fits in 16-bits.
  static bool isValid(int v) => (0 <= v && v <= 0xFFFF) ? true : false;

  static int valid(int v) => isValid(v) ? v : null;

  static bool isPrivateCreator(int elt) => 0x10 <= elt && elt <= 0xFF;

  static int pcBase(int elt) => elt << 8;

  static int pcLimit(int elt) => pcBase(elt) + 0xFF;

  static bool isPrivateData(int elt) => 0x1000 <= elt && elt <= 0xFFFF;

  static bool isValidPrivateData(int pdElt, int pcElt) =>
      pcBase(pcElt) <= pdElt && pdElt <= pcLimit(pcElt);
}

class Tag {
  /// Returns a hex [String] 8 characters long with a "0x" prefix.
  static String hex(int tag) => Int.hex(tag, 8);

  /// Returns the [keyword] associated with this [tag].
  static String keyword(int tag) => ElementDef.lookup(tag).keyword;

  /// Returns true if the tag is defined by DICOM, false otherwise.
  /// All DICOM Public tags have group numbers that are even integers.
  /// Note: This only checks that the group number is an even.
  static bool isPublic(int tag) => group(tag).isEven;

  /// Returns [true] if [tag] is defined by the DICOM Standard.
  static bool isValidPublic(int tag) => !(ElementDef.lookup(tag) == null);

// **** Tag Group ****

  /// Returns the group number of [tag].
  static int group(int tag) => Group.valid(tag >> 16) ;

  /// Returns the [tagGroup] number as a hex [String].
  static String groupHex(int tag) => Group.hex(group(tag));

  /// Returns [true] if [tag] is Public or valid Private fits in 16-bits.
  static bool isValidGroup(int tag) => Group.isValid(group(tag));

 // static int validateGroup(int tag) => validGroup(tag) ? tag : null;

// **** Tag Elt (Element) ****

  /// Returns the dictionary number of [tag].
  static int elt(int tag) => tag & kElementMask;

  /// Returns the dictionary number as a hex [String].
  static String eltHex(int tag) => Group.hex(elt(tag));

  /// Returns [true] if [tag] fits in 16-bits.
  static bool isValidElt(int tag) => Elt.isValid(elt(tag));

  static int validElt(int tag) => Elt.valid(tag);

//**** Utilities for reading and printing DCM format (gggg,eeee).

  /// Returns [tag] in DICOM format '(gggg,eeee)'.
  static String dcm(int tag) {
    String hex(int n) => Int.hex(n, 4, "");
    return '(${hex(Tag.group(tag))},${hex(Tag.elt(tag))})';
  }

  /// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
  static Iterable<String> listToDcm(List<int> tags) => tags.map(dcm);

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

//**** File Meta Information Utilities ****

  /// Returns [true] if [tag] is a File Meta Information [tag]; otherwise false.
  static bool isFmi(int tag) => group(tag) == 0x0002;

  /// Returns [true] if [tag] is in the range of DICOM Directory Tags.
  /// Note: Does not test tag validity.
  static bool inFmiRange(int tag) => (kMinFmiTag <= tag) && (tag <= kMaxFmiTag);

  static void checkFmiRange(int tag) {
    if (!inDcmDirRange(tag)) rangeError(tag, kMinFmiTag, kMaxFmiTag);
  }

  /// [True] for any Public (i.e. defined in PS3.6) File Meta Information [Tag].
  static bool isValidFmi(int tag) => fmiTags.contains(tag);

  static int fmiIndex(int tag) => fmiTags.indexOf(tag);

  static String fmiKeyword(int tag) => fmiKeywords[fmiIndex(tag)];

  static bool isValidFmiKeyword(String keyword) => fmiKeywords.contains(keyword);

  static const List<int> fmiTags = const [
    kFileMetaInformationGroupLength,
    kFileMetaInformationVersion,
    kMediaStorageSOPClassUID,
    kMediaStorageSOPInstanceUID,
    kTransferSyntaxUID,
    kImplementationClassUID,
    kImplementationVersionName,
    kSourceApplicationEntityTitle,
    kSendingApplicationEntityTitle,
    kReceivingApplicationEntityTitle,
    kPrivateInformationCreatorUID,
    kPrivateInformation
  ];

  static const List<String> fmiKeywords = const [
    "FileMetaInformationGroupLength",
    "FileMetaInformationVersion",
    "MediaStorageSOPClassUID",
    "MediaStorageSOPInstanceUID",
    "TransferSyntaxUID",
    "ImplementationClassUID",
    "ImplementationVersionName",
    "SourceApplicationEntityTitle",
    "SendingApplicationEntityTitle",
    "ReceivingApplicationEntityTitle",
    "PrivateInformationCreatorUID",
    "PrivateInformation"
  ];

  static const Map<String, int> fmiKeywordToTagMap = const {
    "FileMetaInformationGroupLength": kFileMetaInformationGroupLength,
    "FileMetaInformationVersion": kFileMetaInformationVersion,
    "MediaStorageSOPClassUID": kMediaStorageSOPClassUID,
    "MediaStorageSOPInstanceUID": kMediaStorageSOPInstanceUID,
    "TransferSyntaxUID": kTransferSyntaxUID,
    "ImplementationClassUID": kImplementationClassUID,
    "ImplementationVersionName": kImplementationVersionName,
    "SourceApplicationEntityTitle": kSourceApplicationEntityTitle,
    "SendingApplicationEntityTitle": kSendingApplicationEntityTitle,
    "ReceivingApplicationEntityTitle": kReceivingApplicationEntityTitle,
    "PrivateInformationCreatorUID": kPrivateInformationCreatorUID,
    "PrivateInformation": kPrivateInformation
  };

  static int fmiKeywordToTag(String keyword) => fmiKeywordToTagMap[keyword];

  static const Map<int, String> fmiTagToKeywordMap = const {
    kFileMetaInformationGroupLength: "FileMetaInformationGroupLength",
    kFileMetaInformationVersion: "FileMetaInformationVersion",
    kMediaStorageSOPClassUID: "MediaStorageSOPClassUID",
    kMediaStorageSOPInstanceUID: "MediaStorageSOPInstanceUID",
    kTransferSyntaxUID: "TransferSyntaxUID",
    kImplementationClassUID: "ImplementationClassUID",
    kImplementationVersionName: "ImplementationVersionName",
    kSourceApplicationEntityTitle: "SourceApplicationEntityTitle",
    kSendingApplicationEntityTitle: "SendingApplicationEntityTitle",
    kReceivingApplicationEntityTitle: "ReceivingApplicationEntityTitle",
    kPrivateInformationCreatorUID: "PrivateInformationCreatorUID",
    kPrivateInformation: "PrivateInformation"
  };

  static String fmiTagToKeyword(int tag) => fmiTagToKeywordMap[tag];

//String fmiTagToName(int tag) => keywordToName(fmiTagToKeywordMap[tag]);

//**** DICOM Directory Utilities ****

  /// Returns [true] if [tag] is in the range of DICOM Directory Tags.
  /// Note: Does not test tag validity.
  static bool inDcmDirRange(int tag) => (kMinDcmDirTag <= tag) && (tag <= kMaxDcmDirTag);

  static void checkDcmDirRange(int tag) {
    if (!inDcmDirRange(tag)) rangeError(tag, kMinDcmDirTag, kMaxDcmDirTag);
  }

//**** DICOM Dataset Utilities ****

  /// Returns [true] if [tag] is in the range of DICOM [Dataset] Tags.
  /// Note: Does not test tag validity.
  static bool inDatasetRange(int tag) => (kMinDatasetTag <= tag) && (tag <= kMaxDatasetTag);

  static void checkDatasetRange(int tag) {
    if (!inDatasetRange(tag)) rangeError(tag, kMinDatasetTag, kMaxDatasetTag);
  }


}
