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

/// Returns a hex [String] 8 characters long with a "0x" prefix.
String hex(int tag) => '0x'+ Int.toHex(tag, 8);

/// Returns true if the tag is defined by DICOM, false otherwise.
/// All DICOM Public tags have group numbers that are even integers.
/// Note: This only checks that the group number is an even.
bool isPublic(int tag) => group(tag).isEven;

/// Returns [true] if [tag] is defined by the DICOM Standard.
bool isValidPublic(int tag) => !(ElementDef.lookup(tag) == null);

// **** Tag Group ****

/// Returns the group number of [tag].
int group(int tag) => tag >> 16;

/// Returns the [tagGroup] number as a hex [String].
String groupHex(int tag) => Int.toHex(group(tag), 4);


/// Returns [true] if [v] fits in 16-bits.
bool validGroup(int code) {
  int g = group(code);
  return g.isEven || _isPrivateGroup(g) ? true : false;
}

int validateGroup(int code) => validGroup(code) ? code : null;

// **** Tag Elt (Element) ****

/// Returns the dictionary number of [tag].
int elt(int tag) => tag & kElementMask;

/// Returns the dictionary number as a hex [String].
String eltHex(int tag) => Int.toHex(elt(tag), 4);

/// Returns [true] if [v] fits in 16-bits.
bool validElt(int v) => (0 <= v && v <= 0xFFFF) ? true : false;

int validateElt(int v) => validElt(v) ? v : null;

//**** Utilities for reading and printing DCM format (gggg,eeee).

/// Returns [tag] in DICOM format '(gggg,eeee)'.
String dcm(int tag) =>
    '(${Int.toHex(group(tag))},${Int.toHex(elt(tag))})';

/// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
Iterable<String> listToDcm(List<int> list) => list.map(dcm);

/// Takes a [String] in format "(gggg,eeee)" and returns [int].
int dcmToInt(String tag) {
  String tmp = tag.substring(1, 5) + tag.substring(6, 10);
  return int.parse(tmp, radix: 16);
}

//*** Sequence & Item Utilities ***

/// Returns [true] if
bool isSQEnd(int tag) => tag == kSequenceDelimitationItem;

/// Returns [true] if [tag] is  ItemTag
bool isItem(int tag) => tag == kItem;

bool isItemEnd(int tag) => tag == kItemDelimitationItem;

// Tag Validators
bool rangeError(int tag, int min, int max) {
  String msg = 'invalid tag: $tag not in $min <= x <= $max';
  throw new RangeError(msg);
}

//**** File Meta Information Utilities ****

/// Returns [true] if [tag] is in the range of DICOM Directory Tags.
/// Note: Does not test tag validity.
bool inFmiRange(int tag) => (kMinFmiTag <= tag) && (tag <= kMaxFmiTag);

void checkFmiRange(int tag) {
  if (! inDcmDirRange(tag)) rangeError(tag, kMinFmiTag, kMaxFmiTag);
}

/// [True] for any Public (i.e. defined in PS3.6) File Meta Information [Tag].
bool isValidFmi(int tag) => fmiTags.contains(tag);

int fmiIndex(int tag) => fmiTags.indexOf(tag);

String fmiKeyword(int tag) => fmiKeywords[fmiIndex(tag)];

bool isValidFmiKeyword(String keyword) => fmiKeywords.contains(keyword);


const List<int> fmiTags = const [
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
  kPrivateInformation];

const List<String> fmiKeywords = const [
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
  "PrivateInformation"];

const Map<String, int> fmiKeywordToTagMap = const {
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

int fmiKeywordToTag(String keyword) => fmiKeywordToTagMap[keyword];

const Map<int, String> fmiTagToKeywordMap = const {
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
  kPrivateInformation: "PrivateInformation"};

String fmiTagToKeyword(int tag) => fmiTagToKeywordMap[tag];
//String fmiTagToName(int tag) => keywordToName(fmiTagToKeywordMap[tag]);

//**** DICOM Directory Utilities ****

/// Returns [true] if [tag] is in the range of DICOM Directory Tags.
/// Note: Does not test tag validity.
bool inDcmDirRange(int tag) => (kMinDcmDirTag <= tag) && (tag <= kMaxDcmDirTag);

void checkDcmDirRange(int tag) {
  if (! inDcmDirRange(tag)) rangeError(tag, kMinDcmDirTag, kMaxDcmDirTag);
}

//**** DICOM Dataset Utilities ****

/// Returns [true] if [tag] is in the range of DICOM [Dataset] Tags.
/// Note: Does not test tag validity.
bool inDatasetRange(int tag) => (kMinDatasetTag <= tag) && (tag <= kMaxDatasetTag);

void checkDatasetRange(int tag) {
  if (! inDatasetRange(tag)) rangeError(tag, kMinDatasetTag, kMaxDatasetTag);
}

/// Utilities for working with private Tags
///
/// This library is designed to be imported using 'as pTag'.
///
/// Definitions:
///   Private Group Number: A Tag Group Number that is odd and is greater than 0x0007
///       and less than 0xFFFF.
///   Private Group: includes all the Private Creator and Private Data Tag with the
///     same Private Group Number
///   Private Creator: A tag with the form GGGG00CC, where GGGG is the Private Group Number,
///       and CC is a Private Creator Index.
///   Private Creator Index: A 16-bit value between 0x0010 and 0x00FF.
///   Private Data: A tag with the form GGGGCCDD, where GGGG is the Private Group Number,
///       CC is the Private Creator Index, and DD is the Private Data Index.
///   Private Data Index: A 16-bit value between 0xCC00 and 0xCCFF, where CC is the Private
///       Creator Index for the Private Data Element.

// Note: the following conventions are used function arguments in this library:
//   t -  a 32-bit DICOM Tag
//   pc - a 32-bit Private Creator Tag
//   pd - a 32-bit Private Data Tag

//   g -  a 16-bit Private Group Number

//   e - a 16-bit Element Number
//   pce - a 16-bit Private Creator Element
//   pde - a 16-bit Private Data Element
//   pci - an 8-bit Private Creator Index
//   pdi - an 8-bit Private Data Index

/// Groups that shall not be used in Private [Attributes].
const List<int> invalidPrivateGroups = const [0x0001, 0x0003, 0x0005, 0x0007, 0xFFFF];

/// Returns [true] if [tag] is a valid DICOM Private Tag.
bool isPrivate(int code) => _isPrivateGroup(group(code));

/// Returns true if [tag] is a valid [PrivateCreator] tag.
bool isPrivateCreator(int code) => isPrivate(code) && _isPCIndex(elt(code));

/// Returns true if this is a valid [PrivateData] tag.
///
/// If the Private Creator Tag is present, verifies that [pd] and [pc] have the
/// same [group], and that [pc] has a valid [pcIndex].
bool isPrivateData(int pd, [int pc]) {
  int g = group(pd);
  if (_isPrivateGroup(g)) {
    int pde = elt(pd);
    if (pc == null) {
      return _isSimplePDIndex(pde);
    } else {
      int pcg = group(pc);
      if (g != pcg) return null;
      int pce = elt(pc);
      if (_isPCIndex(pce)) {
        if (_isPDIndex(pce, pde)) return true;
      }
    }
  }
  return false;
}

/// Returns [true] if the Private Data Element [pde] is valid for one of the [pcs] Private
/// Creator Tags.
bool inPrivateGroup(List<int> pcs, int pde) {
  for (int i = 0; i < pcs.length; i++) {
    if (!isPrivateData(pde, pcs[i])) return false;
  }
  return true;
}

//**** Private Tag Constructors ****

/// Returns a valid Private Creator Tag ([pce]), or [null].
int toPrivateCreator(int group, int pcIndex) {
  if (isPrivate(group) && _isPCIndex(pcIndex))
    return _toPrivateCreator(group, pcIndex);
  return null;
}

/// Returns a valid Private Data Tag ([pde]), or [null].
int toPrivateData(int group, int pcIndex, int pdIndex) {
  if (isPrivate(group) && _isPCIndex(pcIndex) && _isPDIndex(pcIndex, pdIndex))
    return _toPrivateData(group, pcIndex, pcIndex);
  return null;
}

/// Returns a Private Creator Tag ([pce]), without checking arguments.
int _toPrivateCreator(int group, int pcIndex) => (group << 16) + pcIndex;

/// Returns a Private Data Tag ([pde]), without checking argumnents.
int _toPrivateData(int group, pcIndex, pdIndex) => (group << 16) + (pcIndex << 8) + pdIndex;

// Internal Utility functions

/// Returns [true] if [g] is a valid Private Group Number.
bool _isPrivateGroup(int g) => g.isOdd && (0x0007 < g && g != 0xFFFF);

/// Return [true] if [pde] is a valid Private Creator Index.
bool _isPCIndex(int pde) => 0x10 <= pde && pde <= 0xFF;

/// Returns [true] if [pde] in a valid Private Data Index
bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

/// Return [true] if [e] is a valid Private Data Index.
bool _isPDIndex(int pce, int pde) => _pdBase(pce) <= pde && pde <= _pdLimit(pce);

/// Returns the offset base  for a Private Data Element with the Private Creator [pc].
int _pdBase(int pcIndex) => pcIndex << 8;

/// Returns the offset limit for a Private Data Element with the Private Creator [pc].
int _pdLimit(int pdBase) => pdBase + 0x00FF;
