// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/tag/constants.dart';
import 'package:dictionary/src/dicom/tag/utils.dart';


/// A library for handling DICOM File Meta Information Tags.

const int kMinFmiTag = kFileMetaInformationGroupLength;
const int kMaxFmiTag = kPrivateInformation;

/// [True] for any File Meta Information [Tag], false otherwise.
/// Note: Does not test tag validity.
bool inFmiRange(int tag) => (kMinFmiTag <= tag) && (tag <= kMaxFmiTag);

void checkFmiRange(int tag) {
  if (! inFmiRange(tag)) tagRangeError(tag, kMinFmiTag, kMaxFmiTag);
}

/// [True] for any Public (i.e. defined in PS3.6) File Meta Information [Tag].
bool isValidFmiTag(int tag) => fmiTags.contains(tag);

int fmiTagIndex(int tag) => fmiTags.indexOf(tag);

String fmiKeyword(int tag) => fmiKeywords[fmiTagIndex(tag)];

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





