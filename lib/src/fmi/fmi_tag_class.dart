// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr.dart';

/// Constant Tag definitions for File Meta Information [FmiTag]s.
class FmiTag {
  final String keyword;
  final int tag;
  final String name;
  final VR vr;
  final VM vm;
  final bool isRetired;

  const FmiTag(this.keyword, this.tag, this.name, this.vr, this.vm, [this.isRetired = false]);

  FmiTag operator [](int tag) => map[tag];

  static const kFileMetaInformationGroupLength =
  const FmiTag("FileMetaInformationGroupLength",
                   0x00020000,
                   "File Meta Information Group Length",
                   VR.kUL,
                   VM.k1);

  static const kFileMetaInformationVersion =
      const FmiTag("FileMetaInformationVersion",
                       0x00020001,
                       "File Meta Information Version",
                   VR.kOB,
                   VM.k1);

  //TODO: Is this an identifier of a DICOM Media Type
  static const kMediaStorageSOPClassUID =
      const FmiTag("MediaStorageSOPClassUID",
                   0x00020002,
                   "Media Storage SOP Class UID",
                   VR.kUI,
                   VM.k1);
  /// Must be unique to the Media Storage SOP Class, Media Type, SOP Instance
  static const kMediaStorageSOPInstanceUID =
  const FmiTag("MediaStorageSOPInstanceUID",
                   0x00020003,
                   "Media Storage SOP Instance UID",
                   VR.kUI,
                   VM.k1);

  static const kTransferSyntaxUID =
  const FmiTag("TransferSyntaxUID",
                   0x00020010,
                   "Transfer Syntax UID",
                   VR.kUI,
                   VM.k1);

  static const kImplementationClassUID =
  const FmiTag("ImplementationClassUID",
                   0x00020012,
                   "Implementation Class UID",
                   VR.kUI,
                   VM.k1);

  static const kImplementationVersionName =
  const FmiTag("ImplementationVersionName",
                   0x00020013,
                   "Implementation Version Name",
                   VR.kSH,
                   VM.k1);

  static const kSourceApplicationEntityTitle =
  const FmiTag("SourceApplicationEntityTitle",
                   0x00020016,
                   "Source ApplicationEntity Title",
                   VR.kAE,
                   VM.k1);


  static const kSendingApplicationEntityTitle =
  const FmiTag("SendingApplicationEntityTitle",
                   0x00020017,
                   "Sending Application Entity Title",
                   VR.kAE,
                   VM.k1);

  static const kReceivingApplicationEntityTitle =
  const FmiTag("ReceivingApplicationEntityTitle",
                   0x00020018,
                   "Receiving Application Entity Title",
                   VR.kAE,
                   VM.k1);

  static const kPrivateInformationCreatorUID =
  const FmiTag("PrivateInformationCreatorUID",
                   0x00020100,
                   "Private Information Creator UID",
                   VR.kUI,
                   VM.k1);

  static const kPrivateInformation =
  const FmiTag("PrivateInformation",
                   0x00020102,
                   "Private Information",
                   VR.kOB,
                   VM.k1);

  static const Map<int, FmiTag> map = const {
    0x00020000: kFileMetaInformationGroupLength,
    0x00020001: kFileMetaInformationVersion,
    0x00020002: kMediaStorageSOPClassUID,
    0x00020003: kMediaStorageSOPInstanceUID,
    0x00020010: kTransferSyntaxUID,
    0x00020012: kImplementationClassUID,
    0x00020013: kImplementationVersionName,
    0x00020016: kSourceApplicationEntityTitle,
    0x00020017: kSendingApplicationEntityTitle,
    0x00020018: kReceivingApplicationEntityTitle,
    0x00020100: kPrivateInformationCreatorUID,
    0x00020102: kPrivateInformation
  };

  static const List<FmiTag> list = const [
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

  List<int> get tags => map.keys;

}
