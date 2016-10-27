// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/tag/constants.dart';

// Standard Library definitions
String docLink = 'doc/dicom/dart/tag.html';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

const int kMinTag = kAffectedSOPInstanceUID;
const int kMaxTag = kSequenceDelimitationItem;

/// A library for handling DICOM Tags.

//**** Tag Group and Element Utilities ****
/// Returns the group number of [tag].
int tagGroup(int tag) => tag >> 16;

/// Returns the [tagGroup] number as a hex [String].
String tagGroupHex(int tag) => toHexString(tagGroup(tag), 4);

/// Returns the dictionary number of [tag].
int tagElement(int tag) => tag & kElementMask;

/// Returns the dictionary number as a hex [String].
String tagElementHex(int tag) => toHexString(tagElement(tag), 4);

//*** Tag String Utilities ***

/// Returns [value] as a hexadecimal string of [length] with prefix [prefix].
String toHexString(int v, [int padding = 8]) =>
  v.toRadixString(16).padLeft(padding, "0");

/// Returns a hex [String] 8 characters long with a "0x" prefix.
String tagToHex(int tag) => '0x'+ toHexString(tag, 8);

/// Returns [tag] in DICOM format '(gggg,eeee)'.
String tagToDcm(int dcm) =>
   '(${tagGroupHex(dcm)},${tagElementHex(dcm)})';

/// Returns a [List] of DICOM tag codes in '0xggggeeee format
List<String> tagListToHex(List<int> list) => list.map(tagToHex);

/// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
Iterable<String> tagListToDcmFmt(List<int> list) => list.map(tagToDcm);

/// Returns a [List<String>], of decimal [String]s.
Iterable <String> intListToString(List<int> list) =>
    list.map((int i) => i.toRadixString(10));

bool isSQEndTag(int tag) => tag == kSequenceDelimitationItem;

// Items
/// Returns [true] if [tag] is  ItemTag
bool isItemTag(int tag) => tag == kItem;

bool isItemEndTag(int tag) => tag == kItemDelimitationItem;

// Tag Validators

bool tagRangeError(int tag, int min, int max) {
  String msg = 'invalid tag: $tag not in $min <= x <= $max';
  throw new RangeError(msg);
}



const int kMinDcmDirTag = kFileSetID;
const int kMaxDcmDirTag = kNumberOfReferences;

/// Returns [true] if [tag] is in the range of DICOM Directory Tags.
/// Note: Does not test tag validity.
bool inDcmDirRange(int tag) => (kMinDcmDirTag <= tag) && (tag <= kMaxDcmDirTag);

void checkDcmDirRange(int tag) {
  if (! inDcmDirRange(tag)) tagRangeError(tag, kMinDcmDirTag, kMaxDcmDirTag);
}

const int kMinDatasetTag = kLengthToEnd;
const int kMaxDatasetTag = kSequenceDelimitationItem;
/// Returns [true] if [tag] is in the range of DICOM [Dataset] Tags.
/// Note: Does not test tag validity.
bool inDatasetRange(int tag) => (kMinDatasetTag <= tag) && (tag <= kMaxDatasetTag);

void checkDatasetRange(int tag) {
  if (! inDatasetRange(tag)) tagRangeError(tag, kMinDatasetTag, kMaxDatasetTag);
}

/// Takes a [String] in format "(gggg,eeee)" and returns [int].
int dcmToInt(String tag) {
  String tmp = tag.substring(1, 5) + tag.substring(6, 10);
  return int.parse(tmp, radix: 16);
}

//**** Private Tag Functions ****

/// Groups that shall not be used in Private [Attributes].
const List<int> invalidPrivateGroups = const [0x0001, 0x0003, 0x0005, 0x0007, 0xFFFF];

bool hasPrivateGroup(int tag) {
  int group = tagGroup(tag);
  return group.isOdd && (! invalidPrivateGroups.contains(group));
}


bool hasCreatorElement(int tag) =>
    (tagElement(tag) >= 0x0010) && (tagElement(tag) <= 0x00FF);

//TODO: improve this by checking the dictionary table
/// Returns true if the tag is defined by DICOM, false otherwise
/// All DICOM Public tags have group numbers that are even.
/// Note: This only checks that the group number is even.
bool isPublicTag(int tag) => tagGroup(tag).isEven;

//**** Private Tag Methods ****
/// PrivateTag == 0xggggeeee, where 0xgggg is odd and 0xeeee is any number
/// groupBase == 0xgggg0000, where gggg is odd
privateSetBase(int pgBase) => pgBase & 0xFFFF0000;

// Private Creator Group == 0x00XX, where 0x0010 <= 0x00XX <= 0x00FF
privateCreatorGroup(int creator) => creator & 0x000000FF;

/// Private Group Base == 0xgggg00XX, where 0xgggg0010 <= 0xgggg00XX <= 0xgggg00FF
privateGroupBase(int creator) => (creator & 0xFFFF0000) + (privateCreatorGroup(creator) << 8);

/// Private Group Limit
privateGroupLimit(int pgBase) => pgBase + 0x00FF;

// pdBase == 0xggggXX00, where 0x1000 <= 0xXX00 <= 0xFF00
privateDataBase(int pCreator) =>
    privateSetBase(pCreator) + (privateCreatorGroup(pCreator) << 8);

/// Returns [true] if [tag] is a valid DICOM Private Tag.
bool isPrivateTag(int tag) => hasPrivateGroup(tag);

/// Returns true if [tag] is a valid [PrivateCreator] tag.
bool isPrivateCreatorTag(int tag) =>
    (hasPrivateGroup(tag) && hasCreatorElement(tag));

/// Returns the dictionary number of the first dictionary in
/// the private data for [creator].
//int privateGroupBase(int creator) => tagElement(creator) << 8;

/// Returns true if this is a valid [PrivateData] tag.
/// Note: it does not confirm that it is in the correct group
bool isPrivateData(int tag, int creator) {
  if (! isPrivateCreatorTag(creator))
    throw "Invalid Private Creator: ${tagToHex(creator)}";
  int base = privateGroupBase(creator);
  return ((tagElement(tag) >= base) && (tagElement(tag) <= (base + 0xFF)));
}

/// Returns [true] if [data] is in [creators] private tag group.
bool inPrivateGroup(List<int> creators, int data) {
  print('inPrivateGroup: $creators, ${tagToDcm(data)}');
  for (int i = 0; i < creators.length; i++) {
    print('creator: ${tagToDcm(creators[i])}, data: ${tagToDcm(data)}');
    if (!isPrivateData(data, creators[i]))
      return false;
  }
  return true;
}

/// Returns true if this is a valid [PrivateData] (pdTag) tag.
///
/// pdTag == 0xggggXXee,
///     where 0x10 <= 0xXX <= 0xFF and 0x0010 <= 0x00ee <= 0x00FF

/// Note: it does not confirm that it is in the correct group
bool isPrivateDataTag(int pdTag) {
  if (isPrivateTag(pdTag) &&
      ((tagElement(pdTag) >= 0x1000) && (tagElement(pdTag) <= 0xFFFF)))
    return true;
  return false;
}




