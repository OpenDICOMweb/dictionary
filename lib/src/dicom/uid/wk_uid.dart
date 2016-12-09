// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/uid/uid.dart';

import 'wk_uid_type.dart';
import 'wk_uids_map.dart';

//TODO wwe need add the keyword to the to the class.
//TODO: change the type from String to WKUidType

/// Compile time constant definitions for the "Well Known" UIDs from PS 3.6
class WKUid extends Uid {
  //TODO add keyword to table below
  // final String  keyword;
  // TODO: convert to WKUidType
  final WKUidType type;
  final String name;
  final bool isRetired;
  final String link;

  const WKUid(String uid, this.type, this.isRetired, this.name, this.link)
      : super.constant(uid);

  //static fromString(String s) => stringToUidMap[validate(s)];

  String debug() => "UID: $string (type=$type, name=$name)";

  bool get isNotRetired => ! isRetired;

  //TODO: create WKUidType class
  bool get isTransferSyntax => type == "TransferSyntax";

  //TODO: create WKUidType class
  bool get isSopClass => type == "SOPClass";

  bool get isMetaSOPInstance => type == "MetaSOPInstance";

  bool get isFrameOfReference => type == "Frameofreference";

  bool get isSOPInstance => type == "SOPInstance";

  bool get isContextGroupID => type == "ContextGroup";

  @override
  String toString() => '$type($string): $name';

  static WKUid lookup(var uid) {
    if (uid is Uid) uid = uid.string;
    if (uid is String) return wellKnownUids[uid];
    return null;
  }

  //*****   Constant Values   *****
  static const kVerificationSOPClass =
      const WKUid("1.2.840.10008.1.1", WKUidType.kSopClass, false, "Verification SOP Class", "PS3.4");
  static const kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM = const WKUid(
      "1.2.840.10008.1.2",
      WKUidType.kTransferSyntax,
      false,
      "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
      "PS3.5");
  static const kExplicitVRLittleEndian = const WKUid(
      "1.2.840.10008.1.2.1", WKUidType.kTransferSyntax, false, "Explicit VR Little Endian", "PS3.5");
  static const kDeflatedExplicitVRLittleEndian = const WKUid("1.2.840.10008.1.2.1.99",
      WKUidType.kTransferSyntax, false, "Deflated Explicit VR Little Endian", "PS3.5");
  static const kExplicitVRBigEndian_Retired = const WKUid("1.2.840.10008.1.2.2",
      WKUidType.kTransferSyntax, true, "Explicit VR Big Endian (Retired)", "PS3.5");
  static const kJPEGBaseline_1 = const WKUid(
      "1.2.840.10008.1.2.4.50",
      WKUidType.kTransferSyntax,
      false,
      "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy JPEG 8 Bit Image Compression",
      "PS3.5");
  static const kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 = const WKUid(
      "1.2.840.10008.1.2.4.51",
      WKUidType.kTransferSyntax,
      false,
      "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for Lossy JPEG 12 Bit Image Compression (Process 4 only)",
      "PS3.5");
  static const kJPEGExtended_3_5_Retired = const WKUid("1.2.840.10008.1.2.4.52",
      WKUidType.kTransferSyntax, true, "JPEG Extended (Process 3 & 5) (Retired)", "PS3.5");
  static const kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired = const WKUid(
      "1.2.840.10008.1.2.4.53",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
      "PS3.5");
  static const kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired = const WKUid(
      "1.2.840.10008.1.2.4.54",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
      "PS3.5");
  static const kJPEGFullProgressionNon_Hierarchical_10_12_Retired = const WKUid(
      "1.2.840.10008.1.2.4.55",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
      "PS3.5");
  static const kJPEGFullProgressionNon_Hierarchical_11_13_Retired = const WKUid(
      "1.2.840.10008.1.2.4.56",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
      "PS3.5");
  static const kJPEGLosslessNon_Hierarchical_14 = const WKUid("1.2.840.10008.1.2.4.57",
      WKUidType.kTransferSyntax, false, "JPEG Lossless, Non-Hierarchical (Process 14)", "PS3.5");
  static const kJPEGLosslessNon_Hierarchical_15_Retired = const WKUid(
      "1.2.840.10008.1.2.4.58",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
      "PS3.5");
  static const kJPEGExtendedHierarchical_16_18_Retired = const WKUid(
      "1.2.840.10008.1.2.4.59",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
      "PS3.5");
  static const kJPEGExtendedHierarchical_17_19_Retired = const WKUid(
      "1.2.840.10008.1.2.4.60",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
      "PS3.5");
  static const kJPEGSpectralSelectionHierarchical_20_22_Retired = const WKUid(
      "1.2.840.10008.1.2.4.61",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
      "PS3.5");
  static const kJPEGSpectralSelectionHierarchical_21_23_Retired = const WKUid(
      "1.2.840.10008.1.2.4.62",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
      "PS3.5");
  static const kJPEGFullProgressionHierarchical_24_26_Retired = const WKUid(
      "1.2.840.10008.1.2.4.63",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
      "PS3.5");
  static const kJPEGFullProgressionHierarchical_25_27_Retired = const WKUid(
      "1.2.840.10008.1.2.4.64",
      WKUidType.kTransferSyntax,
      true,
      "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
      "PS3.5");
  static const kJPEGLosslessHierarchical_28_Retired = const WKUid("1.2.840.10008.1.2.4.65",
      WKUidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 28) (Retired)", "PS3.5");
  static const kJPEGLosslessHierarchical_29_Retired = const WKUid("1.2.840.10008.1.2.4.66",
      WKUidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 29) (Retired)", "PS3.5");
  static const kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
      const WKUid(
          "1.2.840.10008.1.2.4.70",
          WKUidType.kTransferSyntax,
          false,
          "JPEG Lossless, Non-Hierarchical, First-Order Prediction (Process 14 [Selection Value 1]) : Default Transfer Syntax for Lossless JPEG Image Compression",
          "PS3.5");
  static const kJPEG_LSLosslessImageCompression = const WKUid("1.2.840.10008.1.2.4.80",
      WKUidType.kTransferSyntax, false, "JPEG-LS Lossless Image Compression", "PS3.5");
  static const kJPEG_LSLossyImageCompression = const WKUid("1.2.840.10008.1.2.4.81",
      WKUidType.kTransferSyntax, false, "JPEG-LS Lossy (Near-Lossless) Image Compression", "PS3.5");
  static const kJPEG2000ImageCompressionLosslessOnly = const WKUid("1.2.840.10008.1.2.4.90",
      WKUidType.kTransferSyntax, false, "JPEG 2000 Image Compression Lossless Only", "PS3.5");
  static const kJPEG2000ImageCompression = const WKUid("1.2.840.10008.1.2.4.91",
      WKUidType.kTransferSyntax, false, "JPEG 2000 Image Compression", "PS3.5");
  static const kJPEG2000Part2Multi_componentImageCompressionLosslessOnly = const WKUid(
      "1.2.840.10008.1.2.4.92",
      WKUidType.kTransferSyntax,
      false,
      "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
      "PS3.5");
  static const kJPEG2000Part2Multi_componentImageCompression = const WKUid(
      "1.2.840.10008.1.2.4.93",
      WKUidType.kTransferSyntax,
      false,
      "JPEG 2000 Part 2 Multi-component Image Compression",
      "PS3.5");
  static const kJPIPReferenced = const WKUid(
      "1.2.840.10008.1.2.4.94", WKUidType.kTransferSyntax, false, "JPIP Referenced", "PS3.5");
  static const kJPIPReferencedDeflate = const WKUid(
      "1.2.840.10008.1.2.4.95", WKUidType.kTransferSyntax, false, "JPIP Referenced Deflate", "PS3.5");
  static const kMPEG2MainProfile_MainLevel = const WKUid("1.2.840.10008.1.2.4.100",
      WKUidType.kTransferSyntax, false, "MPEG2 Main Profile @ Main Level", "PS3.5");
  static const kMPEG2MainProfile_HighLevel = const WKUid("1.2.840.10008.1.2.4.101",
      WKUidType.kTransferSyntax, false, "MPEG2 Main Profile @ High Level", "PS3.5");
  static const kMPEG_4AVC_H264HighProfile_Level41 = const WKUid("1.2.840.10008.1.2.4.102",
      WKUidType.kTransferSyntax, false, "MPEG-4 AVC/H.264 High Profile / Level 4.1", "PS3.5");
  static const kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 = const WKUid(
      "1.2.840.10008.1.2.4.103",
      WKUidType.kTransferSyntax,
      false,
      "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
      "PS3.5");
  static const kRLELossless =
      const WKUid("1.2.840.10008.1.2.5", WKUidType.kTransferSyntax, false, "RLE Lossless", "PS3.5");
  static const kRFC2557MIMEencapsulation = const WKUid("1.2.840.10008.1.2.6.1",
      WKUidType.kTransferSyntax, false, "RFC 2557 MIME encapsulation", "PS3.10");
  static const kXMLEncoding = const WKUid(
      "1.2.840.10008.1.2.6.2", WKUidType.kTransferSyntax, false, "XML Encoding", "PS3.10");
  static const kMediaStorageDirectoryStorage = const WKUid(
      "1.2.840.10008.1.3.10", WKUidType.kSopClass, false, "Media Storage Directory Storage", "PS3.4");
  static const kTalairachBrainAtlasFrameofReference = const WKUid("1.2.840.10008.1.4.1.1",
      WKUidType.kFrameOfReference, false, "Talairach Brain Atlas Frame of Reference", "");
  static const kSPM2T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.2", WKUidType.kFrameOfReference, false, "SPM2 T1 Frame of Reference", "");
  static const kSPM2T2FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.3", WKUidType.kFrameOfReference, false, "SPM2 T2 Frame of Reference", "");
  static const kSPM2PDFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.4", WKUidType.kFrameOfReference, false, "SPM2 PD Frame of Reference", "");
  static const kSPM2EPIFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.5", WKUidType.kFrameOfReference, false, "SPM2 EPI Frame of Reference", "");
  static const kSPM2FILT1FrameofReference = const WKUid("1.2.840.10008.1.4.1.6",
      WKUidType.kFrameOfReference, false, "SPM2 FIL T1 Frame of Reference", "");
  static const kSPM2PETFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.7", WKUidType.kFrameOfReference, false, "SPM2 PET Frame of Reference", "");
  static const kSPM2TRANSMFrameofReference = const WKUid("1.2.840.10008.1.4.1.8",
      WKUidType.kFrameOfReference, false, "SPM2 TRANSM Frame of Reference", "");
  static const kSPM2SPECTFrameofReference = const WKUid("1.2.840.10008.1.4.1.9",
      WKUidType.kFrameOfReference, false, "SPM2 SPECT Frame of Reference", "");
  static const kSPM2GRAYFrameofReference = const WKUid("1.2.840.10008.1.4.1.10",
      WKUidType.kFrameOfReference, false, "SPM2 GRAY Frame of Reference", "");
  static const kSPM2WHITEFrameofReference = const WKUid("1.2.840.10008.1.4.1.11",
      WKUidType.kFrameOfReference, false, "SPM2 WHITE Frame of Reference", "");
  static const kSPM2CSFFrameofReference = const WKUid("1.2.840.10008.1.4.1.12",
      WKUidType.kFrameOfReference, false, "SPM2 CSF Frame of Reference", "");
  static const kSPM2BRAINMASKFrameofReference = const WKUid("1.2.840.10008.1.4.1.13",
      WKUidType.kFrameOfReference, false, "SPM2 BRAINMASK Frame of Reference", "");
  static const kSPM2AVG305T1FrameofReference = const WKUid("1.2.840.10008.1.4.1.14",
      WKUidType.kFrameOfReference, false, "SPM2 AVG305T1 Frame of Reference", "");
  static const kSPM2AVG152T1FrameofReference = const WKUid("1.2.840.10008.1.4.1.15",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152T1 Frame of Reference", "");
  static const kSPM2AVG152T2FrameofReference = const WKUid("1.2.840.10008.1.4.1.16",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152T2 Frame of Reference", "");
  static const kSPM2AVG152PDFrameofReference = const WKUid("1.2.840.10008.1.4.1.17",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152PD Frame of Reference", "");
  static const kSPM2SINGLESUBJT1FrameofReference = const WKUid("1.2.840.10008.1.4.1.18",
      WKUidType.kFrameOfReference, false, "SPM2 SINGLESUBJT1 Frame of Reference", "");
  static const kICBM452T1FrameofReference = const WKUid("1.2.840.10008.1.4.2.1",
      WKUidType.kFrameOfReference, false, "ICBM 452 T1 Frame of Reference", "");
  static const kICBMSingleSubjectMRIFrameofReference = const WKUid("1.2.840.10008.1.4.2.2",
      WKUidType.kFrameOfReference, false, "ICBM Single Subject MRI Frame of Reference", "");
  static const kHotIronColorPaletteSOPInstance = const WKUid(
      "1.2.840.10008.1.5.1",
      WKUidType.kColorPalette,
      false,
      "Hot Iron Color Palette SOP "
      "Instance",
      "PS 3.6");
  static const kPETColorPaletteSOPInstance = const WKUid("1.2.840.10008.1.5.2",
      WKUidType.kColorPalette, false, "PET Color Palette SOP Instance", "PS 3.6");
  static const kHotMetalBlueColorPaletteSOPInstance = const WKUid("1.2.840.10008.1.5.3",
      WKUidType.kColorPalette, false, "Hot Metal Blue Color Palette SOP Instance", "PS 3.6");
  static const kPET20StepColorPaletteSOPInstance = const WKUid("1.2.840.10008.1.5.4",
      WKUidType.kSopInstance, false, "PET 20 Step Color Palette SOP Instance", "PS 3.6");
  static const kBasicStudyContentNotificationSOPClass_Retired = const WKUid("1.2.840.10008.1.9",
      WKUidType.kSopClass, true, "Basic Study Content Notification SOP Class (Retired)", "PS3.4");
  static const kStorageCommitmentPushModelSOPClass = const WKUid("1.2.840.10008.1.20.1",
      WKUidType.kSopClass, true, "Storage Commitment Push Model SOP Class", "PS3.4");
  static const kStorageCommitmentPushModelSOPInstance = const WKUid("1.2.840.10008.1.20.1.1",
      WKUidType.kSopInstance, false, "Storage Commitment Push Model SOP Instance", "PS3.4");
  static const kStorageCommitmentPullModelSOPClass_Retired = const WKUid("1.2.840.10008.1.20.2",
      WKUidType.kSopClass, true, "Storage Commitment Pull Model SOP Class (Retired)", "PS3.4");
  static const kStorageCommitmentPullModelSOPInstance_Retired = const WKUid(
      "1.2.840.10008.1.20.2.1",
      WKUidType.kSopInstance,
      true,
      "Storage Commitment Pull Model SOP Instance (Retired)",
      "PS3.4");
  static const kProceduralEventLoggingSOPClass = const WKUid("1.2.840.10008.1.40",
      WKUidType.kSopClass, false, "Procedural Event Logging SOP Class", "PS3.4");
  static const kProceduralEventLoggingSOPInstance = const WKUid("1.2.840.10008.1.40.1",
      WKUidType.kSopInstance, false, "Procedural Event Logging SOP Instance", "PS3.4");
  static const kSubstanceAdministrationLoggingSOPClass = const WKUid("1.2.840.10008.1.42",
      WKUidType.kSopClass, false, "Substance Administration Logging SOP Class", "PS3.4");
  static const kSubstanceAdministrationLoggingSOPInstance = const WKUid("1.2.840.10008.1.42.1",
      WKUidType.kSopInstance, false, "Substance Administration Logging SOP Instance", "PS3.4");
  static const kDICOMUIDRegistry = const WKUid(
      "1.2.840.10008.2.6.1", WKUidType.kDicomCodingScheme, false, "DICOM UID Registry", "PS 3.6");
  static const kDICOMControlledTerminology = const WKUid("1.2.840.10008.2.16.4",
      WKUidType.kCodingScheme, false, "DICOM Controlled Terminology", "PS3.16");
  static const kDICOMApplicationContextName = const WKUid("1.2.840.10008.3.1.1.1",
      WKUidType.kApplicationContextName, false, "DICOM Application Context Name", "PS3.7");
  static const kDetachedPatientManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.1.1",
      WKUidType.kSopClass, true, "Detached Patient Management SOP Class (Retired)", "PS3.4");
  static const kDetachedPatientManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.1.4",
      WKUidType.kMetaSopClass,
      true,
      "Detached Patient Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kDetachedVisitManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.2.1",
      WKUidType.kSopClass, true, "Detached Visit Management SOP Class (Retired)", "PS3.4");
  static const kDetachedStudyManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.3.1",
      WKUidType.kSopClass, true, "Detached Study Management SOP Class (Retired)", "PS3.4");
  static const kStudyComponentManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.3.2",
      WKUidType.kSopClass, true, "Study Component Management SOP Class (Retired)", "PS3.4");
  static const kModalityPerformedProcedureStepSOPClass = const WKUid("1.­2.840.10008.3.1.2.3.3",
      WKUidType.kSopClass, false, "Modality Performed Procedure Step SOP Class", "PS3.4");
  static const kModalityPerformedProcedureStepRetrieveSOPClass = const WKUid(
      "1.­2.840.10008.3.1.2.3.4",
      WKUidType.kSopClass,
      false,
      "Modality Performed Procedure Step Retrieve SOP Class",
      "PS3.4");
  static const kModalityPerformedProcedureStepNotificationSOPClass = const WKUid(
      "1.­2.840.10008.3.1.2.3.5",
      WKUidType.kSopClass,
      false,
      "Modality Performed Procedure Step Notification SOP Class",
      "PS3.4");
  static const kDetachedResultsManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.5.1",
      WKUidType.kSopClass, true, "Detached Results Management SOP Class (Retired)", "PS3.4");
  static const kDetachedResultsManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.5.4",
      WKUidType.kMetaSopClass,
      true,
      "Detached Results Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kDetachedStudyManagementMetaSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.5.5",
      WKUidType.kMetaSopClass, true, "Detached Study Management Meta SOP Class (Retired)", "PS3.4");
  static const kDetachedInterpretationManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.6.1",
      WKUidType.kSopClass,
      true,
      "Detached Interpretation Management SOP Class (Retired)",
      "PS3.4");
  static const kStorageServiceClass = const WKUid(
      "1.2.840.10008.4.2", WKUidType.kServiceClass, false, "Storage Service Class", "PS3.4");
  static const kBasicFilmSessionSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.1", WKUidType.kSopClass, false, "Basic Film Session SOP Class", "PS3.4");
  static const kBasicFilmBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.2", WKUidType.kSopClass, false, "Basic Film Box SOP Class", "PS3.4");
  static const kBasicGrayscaleImageBoxSOPClass = const WKUid("1.2.840.10008.5.1.1.4",
      WKUidType.kSopClass, false, "Basic Grayscale Image Box SOP Class", "PS3.4");
  static const kBasicColorImageBoxSOPClass = const WKUid("1.2.840.10008.5.1.1.4.1",
      WKUidType.kSopClass, false, "Basic Color Image Box SOP Class", "PS3.4");
  static const kReferencedImageBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.4.2",
      WKUidType.kSopClass, true, "Referenced Image Box SOP Class (Retired)", "PS3.4");
  static const kBasicGrayscalePrintManagementMetaSOPClass = const WKUid("1.2.840.10008.5.1.1.9",
      WKUidType.kMetaSopClass, false, "Basic Grayscale Print Management Meta SOP Class", "PS3.4");
  static const kReferencedGrayscalePrintManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.9.1",
      WKUidType.kMetaSopClass,
      true,
      "Referenced Grayscale Print Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kPrintJobSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.14", WKUidType.kSopClass, false, "Print Job SOP Class", "PS3.4");
  static const kBasicAnnotationBoxSOPClass = const WKUid("1.2.840.10008.5.1.1.15",
      WKUidType.kSopClass, false, "Basic Annotation Box SOP Class", "PS3.4");
  static const kPrinterSOPClass =
      const WKUid("1.2.840.10008.5.1.1.16", WKUidType.kSopClass, false, "Printer SOP Class", "PS3.4");
  static const kPrinterConfigurationRetrievalSOPClass = const WKUid("1.2.840.10008.5.1.1.16.376",
      WKUidType.kSopClass, false, "Printer Configuration Retrieval SOP Class", "PS3.4");
  static const kPrinterSOPInstance = const WKUid("1.2.840.10008.5.1.1.17",
      WKUidType.kPrinterSopInstance, false, "Printer SOP Instance", "PS3.4");
  static const kPrinterConfigurationRetrievalSOPInstance = const WKUid("1.2.840.10008.5.1.1.17.376",
      WKUidType.kPrinterSopInstance, false, "Printer Configuration Retrieval SOP Instance", "PS3.4");
  static const kBasicColorPrintManagementMetaSOPClass = const WKUid("1.2.840.10008.5.1.1.18",
      WKUidType.kMetaSopClass, false, "Basic Color Print Management Meta SOP Class", "PS3.4");
  static const kReferencedColorPrintManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.18.1",
      WKUidType.kMetaSopClass,
      true,
      "Referenced Color Print Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kVOILUTBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.22", WKUidType.kSopClass, false, "VOI LUT Box SOP Class", "PS3.4");
  static const kPresentationLUTSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.23", WKUidType.kSopClass, false, "Presentation LUT SOP Class", "PS3.4");
  static const kImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24",
      WKUidType.kSopClass, true, "Image Overlay Box SOP Class (Retired)", "PS3.4");
  static const kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24.1",
      WKUidType.kSopClass, true, "Basic Print Image Overlay Box SOP Class (Retired)", "PS3.4");
  static const kPrintQueueSOPInstance_Retired = const WKUid("1.2.840.10008.5.1.1.25",
      WKUidType.kPrintQueueSopInstance, true, "Print Queue SOP Instance (Retired)", "PS3.4");
  static const kPrintQueueManagementSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.26",
      WKUidType.kSopClass, true, "Print Queue Management SOP Class (Retired)", "PS3.4");
  static const kStoredPrintStorageSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.27",
      WKUidType.kSopClass, true, "Stored Print Storage SOP Class (Retired)", "PS3.4");
  static const kHardcopyGrayscaleImageStorageSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.29",
      WKUidType.kSopClass,
      true,
      "Hardcopy Grayscale Image Storage SOP Class (Retired)",
      "PS3.4");
  static const kHardcopyColorImageStorageSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.30",
      WKUidType.kSopClass, true, "Hardcopy Color Image Storage SOP Class (Retired)", "PS3.4");
  static const kPullPrintRequestSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.31",
      WKUidType.kSopClass, true, "Pull Print Request SOP Class (Retired)", "PS3.4");
  static const kPullStoredPrintManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.32",
      WKUidType.kMetaSopClass,
      true,
      "Pull Stored Print Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kMediaCreationManagementSOPClassUID = const WKUid("1.2.840.10008.5.1.1.33",
      WKUidType.kSopClass, false, "Media Creation Management SOP Class UID", "PS3.4");
  static const kComputedRadiographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.1",
      WKUidType.kSopClass, false, "Computed Radiography Image Storage", "PS3.4");
  static const kDigitalX_RayImageStorage_ForPresentation = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.1",
      WKUidType.kSopClass,
      false,
      "Digital X-Ray Image Storage - For Presentation",
      "PS3.4");
  static const kDigitalX_RayImageStorage_ForProcessing = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.1.1",
      WKUidType.kSopClass,
      false,
      "Digital X-Ray Image Storage - For Processing",
      "PS3.4");
  static const kDigitalMammographyX_RayImageStorage_ForPresentation = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.2",
      WKUidType.kSopClass,
      false,
      "Digital Mammography X-Ray Image Storage - For Presentation",
      "PS3.4");
  static const kDigitalMammographyX_RayImageStorage_ForProcessing = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.2.1",
      WKUidType.kSopClass,
      false,
      "Digital Mammography X-Ray Image Storage - For Processing",
      "PS3.4");
  static const kDigitalIntra_OralX_RayImageStorage_ForPresentation = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.3",
      WKUidType.kSopClass,
      false,
      "Digital Intra-Oral X-Ray Image Storage - For Presentation",
      "PS3.4");
  static const kDigitalIntra_OralX_RayImageStorage_ForProcessing = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1.3.1",
      WKUidType.kSopClass,
      false,
      "Digital Intra-Oral X-Ray Image Storage - For Processing",
      "PS3.4");
  static const kCTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.2", WKUidType.kSopClass, false, "CT Image Storage", "PS3.4");
  static const kEnhancedCTImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.2.1",
      WKUidType.kSopClass, false, "Enhanced CT Image Storage", "PS3.4");
  static const kLegacyConvertedEnhancedCTImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.2.2",
      WKUidType.kSopClass, false, "Legacy Converted Enhanced CT Image Storage", "PS3.4");
  static const kUltrasoundMulti_frameImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.3",
      WKUidType.kSopClass, true, "Ultrasound Multi-frame Image Storage (Retired)", "PS3.4");
  static const kUltrasoundMulti_frameImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.3.1",
      WKUidType.kSopClass, false, "Ultrasound Multi-frame Image Storage", "PS3.4");
  static const kMRImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4", WKUidType.kSopClass, false, "MR Image Storage", "PS3.4");
  static const kEnhancedMRImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.1",
      WKUidType.kSopClass, false, "Enhanced MR Image Storage", "PS3.4");
  static const kMRSpectroscopyStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.2", WKUidType.kSopClass, false, "MR Spectroscopy Storage", "PS3.4");
  static const kEnhancedMRColorImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.3",
      WKUidType.kSopClass, false, "Enhanced MR Color Image Storage", "PS3.4");
  static const kLegacyConvertedEnhancedMRImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.4",
      WKUidType.kSopClass, false, "Legacy Converted Enhanced MR Image Storage", "PS3.4");
  static const kNuclearMedicineImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.5",
      WKUidType.kSopClass, true, "Nuclear Medicine Image Storage (Retired)", "PS3.4");
  static const kUltrasoundImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.6",
      WKUidType.kSopClass, true, "Ultrasound Image Storage (Retired)", "PS3.4");
  static const kUltrasoundImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6.1", WKUidType.kSopClass, false, "Ultrasound Image Storage", "PS3.4");
  static const kEnhancedUSVolumeStorage = const WKUid("1.2.840.10008.5.1.4.1.1.6.2",
      WKUidType.kSopClass, false, "Enhanced US Volume Storage", "PS3.4");
  static const kSecondaryCaptureImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.7",
      WKUidType.kSopClass, false, "Secondary Capture Image Storage", "PS3.4");
  static const kMulti_frameSingleBitSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7.1",
      WKUidType.kSopClass,
      false,
      "Multi-frame Single Bit Secondary Capture Image Storage",
      "PS3.4");
  static const kMulti_frameGrayscaleByteSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7.2",
      WKUidType.kSopClass,
      false,
      "Multi-frame Grayscale Byte Secondary Capture Image Storage",
      "PS3.4");
  static const kMulti_frameGrayscaleWordSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7.3",
      WKUidType.kSopClass,
      false,
      "Multi-frame Grayscale Word Secondary Capture Image Storage",
      "PS3.4");
  static const kMulti_frameTrueColorSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7.4",
      WKUidType.kSopClass,
      false,
      "Multi-frame True Color Secondary Capture Image Storage",
      "PS3.4");
  static const kStandaloneOverlayStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.8",
      WKUidType.kSopClass, true, "Standalone Overlay Storage (Retired)", "PS3.4");
  static const kStandaloneCurveStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.9",
      WKUidType.kSopClass, true, "Standalone Curve Storage (Retired)", "PS3.4");
  static const kWaveformStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.9.1",
      WKUidType.kSopClass, true, "Waveform Storage - Trial (Retired)", "PS3.4");
  static const ktwelve_lead_12ECGWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.1.1",
      WKUidType.kSopClass, false, "twelve-lead(12) ECG Waveform Storage", "PS3.4");
  static const kGeneralECGWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.1.2",
      WKUidType.kSopClass, false, "General ECG Waveform Storage", "PS3.4");
  static const kAmbulatoryECGWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.1.3",
      WKUidType.kSopClass, false, "Ambulatory ECG Waveform Storage", "PS3.4");
  static const kHemodynamicWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.2.1",
      WKUidType.kSopClass, false, "Hemodynamic Waveform Storage", "PS3.4");
  static const kCardiacElectrophysiologyWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.3.1",
      WKUidType.kSopClass,
      false,
      "Cardiac Electrophysiology Waveform Storage",
      "PS3.4");
  static const kBasicVoiceAudioWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.4.1",
      WKUidType.kSopClass, false, "Basic Voice Audio Waveform Storage", "PS3.4");
  static const kGeneralAudioWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.4.2",
      WKUidType.kSopClass, false, "General Audio Waveform Storage", "PS3.4");
  static const kArterialPulseWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.5.1",
      WKUidType.kSopClass, false, "Arterial Pulse Waveform Storage", "PS3.4");
  static const kRespiratoryWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.6.1",
      WKUidType.kSopClass, false, "Respiratory Waveform Storage", "PS3.4");
  static const kStandaloneModalityLUTStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.10",
      WKUidType.kSopClass, true, "Standalone Modality LUT Storage (Retired)", "PS3.4");
  static const kStandaloneVOILUTStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.11",
      WKUidType.kSopClass, true, "Standalone VOI LUT Storage (Retired)", "PS3.4");
  static const kGrayscaleSoftcopyPresentationStateStorageSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11.1",
      WKUidType.kSopClass,
      false,
      "Grayscale Softcopy Presentation State Storage SOP Class",
      "PS3.4");
  static const kColorSoftcopyPresentationStateStorageSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11.2",
      WKUidType.kSopClass,
      false,
      "Color Softcopy Presentation State Storage SOP Class",
      "PS3.4");
  static const kPseudo_ColorSoftcopyPresentationStateStorageSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11.3",
      WKUidType.kSopClass,
      false,
      "Pseudo-Color Softcopy Presentation State Storage SOP Class",
      "PS3.4");
  static const kBlendingSoftcopyPresentationStateStorageSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11.4",
      WKUidType.kSopClass,
      false,
      "Blending Softcopy Presentation State Storage SOP Class",
      "PS3.4");
  static const kXA_XRFGrayscaleSoftcopyPresentationStateStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11.5",
      WKUidType.kSopClass,
      false,
      "XA/XRF Grayscale Softcopy Presentation State Storage",
      "PS3.4");
  static const kX_RayAngiographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.1",
      WKUidType.kSopClass, false, "X-Ray Angiographic Image Storage", "PS3.4");
  static const kEnhancedXAImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.1.1",
      WKUidType.kSopClass, false, "Enhanced XA Image Storage", "PS3.4");
  static const kX_RayRadiofluoroscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.2",
      WKUidType.kSopClass, false, "X-Ray Radiofluoroscopic Image Storage", "PS3.4");
  static const kEnhancedXRFImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.2.1",
      WKUidType.kSopClass, false, "Enhanced XRF Image Storage", "PS3.4");
  static const kX_RayAngiographicBi_PlaneImageStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.3",
      WKUidType.kSopClass,
      true,
      "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
      "PS3.4");
  static const kX_Ray3DAngiographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.1",
      WKUidType.kSopClass, false, "X-Ray 3D Angiographic Image Storage", "PS3.4");
  static const kX_Ray3DCraniofacialImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.2",
      WKUidType.kSopClass, false, "X-Ray 3D Craniofacial Image Storage", "PS3.4");
  static const kBreastTomosynthesisImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.3",
      WKUidType.kSopClass, false, "Breast Tomosynthesis Image Storage", "PS3.4");
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation = const WKUid(
      "1.2.840.10008.5.1.4.1.1.14.1",
      WKUidType.kSopClass,
      false,
      "Intravascular Optical Coherence Tomography Image Storage - For Presentation",
      "PS3.4");
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing = const WKUid(
      "1.2.840.10008.5.1.4.1.1.14.2",
      WKUidType.kSopClass,
      false,
      "Intravascular Optical Coherence Tomography Image Storage - For Processing",
      "PS3.4");
  static const kNuclearMedicineImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.20",
      WKUidType.kSopClass, false, "Nuclear Medicine Image Storage", "PS3.4");
  static const kRawDataStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66", WKUidType.kSopClass, false, "Raw Data Storage", "PS3.4");
  static const kSpatialRegistrationStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66.1",
      WKUidType.kSopClass, false, "Spatial Registration Storage", "PS3.4");
  static const kSpatialFiducialsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66.2",
      WKUidType.kSopClass, false, "Spatial Fiducials Storage", "PS3.4");
  static const kDeformableSpatialRegistrationStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66.3",
      WKUidType.kSopClass, false, "Deformable Spatial Registration Storage", "PS3.4");
  static const kSegmentationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.4", WKUidType.kSopClass, false, "Segmentation Storage", "PS3.4");
  static const kSurfaceSegmentationStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66.5",
      WKUidType.kSopClass, false, "Surface Segmentation Storage", "PS3.4");
  static const kRealWorldValueMappingStorage = const WKUid("1.2.840.10008.5.1.4.1.1.67",
      WKUidType.kSopClass, false, "Real World Value Mapping Storage", "PS3.4");
  static const kSurfaceScanMeshStorage = const WKUid("1.2.840.10008.5.1.4.1.1.68.1",
      WKUidType.kSopClass, false, "Surface Scan Mesh Storage", "PS3.4");
  static const kSurfaceScanPointCloudStorage = const WKUid("1.2.840.10008.5.1.4.1.1.68.2",
      WKUidType.kSopClass, false, "Surface Scan Point Cloud Storage", "PS3.4");
  static const kVLImageStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.77.1",
      WKUidType.kSopClass, true, "VL Image Storage - Trial (Retired)", "PS3.4");
  static const kVLMulti_frameImageStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.2",
      WKUidType.kSopClass,
      true,
      "VL Multi-frame Image Storage - Trial (Retired)",
      "PS3.4");
  static const kVLEndoscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.1",
      WKUidType.kSopClass, false, "VL Endoscopic Image Storage", "PS3.4");
  static const kVideoEndoscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.1.1",
      WKUidType.kSopClass, false, "Video Endoscopic Image Storage", "PS3.4");
  static const kVLMicroscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.2",
      WKUidType.kSopClass, false, "VL Microscopic Image Storage", "PS3.4");
  static const kVideoMicroscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.2.1",
      WKUidType.kSopClass, false, "Video Microscopic Image Storage", "PS3.4");
  static const kVLSlide_CoordinatesMicroscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.3",
      WKUidType.kSopClass,
      false,
      "VL Slide-Coordinates Microscopic Image Storage",
      "PS3.4");
  static const kVLPhotographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.4",
      WKUidType.kSopClass, false, "VL Photographic Image Storage", "PS3.4");
  static const kVideoPhotographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.4.1",
      WKUidType.kSopClass, false, "Video Photographic Image Storage", "PS3.4");
  static const kOphthalmicPhotography8BitImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.1",
      WKUidType.kSopClass,
      false,
      "Ophthalmic Photography 8 Bit Image Storage",
      "PS3.4");
  static const kOphthalmicPhotography16BitImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.2",
      WKUidType.kSopClass,
      false,
      "Ophthalmic Photography 16 Bit Image Storage",
      "PS3.4");
  static const kStereometricRelationshipStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.5.3",
      WKUidType.kSopClass, false, "Stereometric Relationship Storage", "PS3.4");
  static const kOphthalmicTomographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.5.4",
      WKUidType.kSopClass, false, "Ophthalmic Tomography Image Storage", "PS3.4");
  static const kVLWholeSlideMicroscopyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.6",
      WKUidType.kSopClass, false, "VL Whole Slide Microscopy Image Storage", "PS3.4");
  static const kLensometryMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.1",
      WKUidType.kSopClass, false, "Lensometry Measurements Storage", "PS3.4");
  static const kAutorefractionMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.2",
      WKUidType.kSopClass, false, "Autorefraction Measurements Storage", "PS3.4");
  static const kKeratometryMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.3",
      WKUidType.kSopClass, false, "Keratometry Measurements Storage", "PS3.4");
  static const kSubjectiveRefractionMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.4",
      WKUidType.kSopClass,
      false,
      "Subjective Refraction Measurements Storage",
      "PS3.4");
  static const kVisualAcuityMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.5",
      WKUidType.kSopClass, false, "Visual Acuity Measurements Storage", "PS3.4");
  static const kSpectaclePrescriptionReportStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.6",
      WKUidType.kSopClass, false, "Spectacle Prescription Report Storage", "PS3.4");
  static const kOphthalmicAxialMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.7",
      WKUidType.kSopClass, false, "Ophthalmic Axial Measurements Storage", "PS3.4");
  static const kIntraocularLensCalculationsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.8",
      WKUidType.kSopClass, false, "Intraocular Lens Calculations Storage", "PS3.4");
  static const kMacularGridThicknessandVolumeReportStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.79.1",
      WKUidType.kSopClass,
      false,
      "Macular Grid Thickness and Volume Report Storage",
      "PS3.4");
  static const kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.80.1",
      WKUidType.kSopClass,
      false,
      "Ophthalmic Visual Field Static Perimetry Measurements Storage",
      "PS3.4");
  static const kOphthalmicThicknessMapStorage = const WKUid("1.2.840.10008.5.1.4.1.1.81.1",
      WKUidType.kSopClass, false, "Ophthalmic Thickness Map Storage", "PS3.4");
  static const kCornealTopographyMapStorage = const WKUid("11.2.840.10008.5.1.4.1.1.82.1",
      WKUidType.kSopClass, false, "Corneal Topography Map Storage", "PS3.4");
  static const kTextSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.1",
      WKUidType.kSopClass, true, "Text SR Storage - Trial (Retired)", "PS3.4");
  static const kAudioSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.2",
      WKUidType.kSopClass, true, "Audio SR Storage - Trial (Retired)", "PS3.4");
  static const kDetailSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.3",
      WKUidType.kSopClass, true, "Detail SR Storage - Trial (Retired)", "PS3.4");
  static const kComprehensiveSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.4",
      WKUidType.kSopClass, true, "Comprehensive SR Storage - Trial (Retired)", "PS3.4");
  static const kBasicTextSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.11", WKUidType.kSopClass, false, "Basic Text SR Storage", "PS3.4");
  static const kEnhancedSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.22", WKUidType.kSopClass, false, "Enhanced SR Storage", "PS3.4");
  static const kComprehensiveSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.33",
      WKUidType.kSopClass, false, "Comprehensive SR Storage", "PS3.4");
  static const kComprehensive3DSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.34",
      WKUidType.kSopClass, false, "Comprehensive 3D SR Storage", "PS3.4");
  static const kProcedureLogStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.40", WKUidType.kSopClass, false, "Procedure Log Storage", "PS3.4");
  static const kMammographyCADSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.50",
      WKUidType.kSopClass, false, "Mammography CAD SR Storage", "PS3.4");
  static const kKeyObjectSelectionDocumentStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.59",
      WKUidType.kSopClass, false, "Key Object Selection Document Storage", "PS3.4");
  static const kChestCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.65", WKUidType.kSopClass, false, "Chest CAD SR Storage", "PS3.4");
  static const kX_RayRadiationDoseSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.67",
      WKUidType.kSopClass, false, "X-Ray Radiation Dose SR Storage", "PS3.4");
  static const kColonCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.69", WKUidType.kSopClass, false, "Colon CAD SR Storage", "PS3.4");
  static const kImplantationPlanSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.70",
      WKUidType.kSopClass, false, "Implantation Plan SR Storage", "PS3.4");
  static const kEncapsulatedPDFStorage = const WKUid("1.2.840.10008.5.1.4.1.1.104.1",
      WKUidType.kSopClass, false, "Encapsulated PDF Storage", "PS3.4");
  static const kEncapsulatedCDAStorage = const WKUid("1.2.840.10008.5.1.4.1.1.104.2",
      WKUidType.kSopClass, false, "Encapsulated CDA Storage", "PS3.4");
  static const kPositronEmissionTomographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.128",
      WKUidType.kSopClass, false, "Positron Emission Tomography Image Storage", "PS3.4");
  static const kLegacyConvertedEnhancedPETImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.128.1",
      WKUidType.kSopClass,
      false,
      "Legacy Converted Enhanced PET Image Storage",
      "PS3.4");
  static const kStandalonePETCurveStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.129",
      WKUidType.kSopClass, true, "Standalone PET Curve Storage (Retired)", "PS3.4");
  static const kEnhancedPETImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.130",
      WKUidType.kSopClass, false, "Enhanced PET Image Storage", "PS3.4");
  static const kBasicStructuredDisplayStorage = const WKUid("1.2.840.10008.5.1.4.1.1.131",
      WKUidType.kSopClass, false, "Basic Structured Display Storage", "PS3.4");
  static const kRTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.1", WKUidType.kSopClass, false, "RT Image Storage", "PS3.4");
  static const kRTDoseStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.2", WKUidType.kSopClass, false, "RT Dose Storage", "PS3.4");
  static const kRTStructureSetStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.3",
      WKUidType.kSopClass, false, "RT Structure Set Storage", "PS3.4");
  static const kRTBeamsTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.4",
      WKUidType.kSopClass, false, "RT Beams Treatment Record Storage", "PS3.4");
  static const kRTPlanStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.5", WKUidType.kSopClass, false, "RT Plan Storage", "PS3.4");
  static const kRTBrachyTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.6",
      WKUidType.kSopClass, false, "RT Brachy Treatment Record Storage", "PS3.4");
  static const kRTTreatmentSummaryRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.7",
      WKUidType.kSopClass, false, "RT Treatment Summary Record Storage", "PS3.4");
  static const kRTIonPlanStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.8", WKUidType.kSopClass, false, "RT Ion Plan Storage", "PS3.4");
  static const kRTIonBeamsTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.9",
      WKUidType.kSopClass, false, "RT Ion Beams Treatment Record Storage", "PS3.4");
  static const kDICOSCTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.1", WKUidType.kSopClass, false, "DICOS CT Image Storage", "DICOS");
  static const kDICOSDigitalX_RayImageStorage_ForPresentation = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.2.1",
      WKUidType.kSopClass,
      false,
      "DICOS Digital X-Ray Image Storage - For Presentation",
      "DICOS");
  static const kDICOSDigitalX_RayImageStorage_ForProcessing = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.2.2",
      WKUidType.kSopClass,
      false,
      "DICOS Digital X-Ray Image Storage - For Processing",
      "DICOS");
  static const kDICOSThreatDetectionReportStorage = const WKUid("1.2.840.10008.5.1.4.1.1.501.3",
      WKUidType.kSopClass, false, "DICOS Threat Detection Report Storage", "DICOS");
  static const kDICOS2DAITStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.4", WKUidType.kSopClass, false, "DICOS 2D AIT Storage", "DICOS");
  static const kDICOS3DAITStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.5", WKUidType.kSopClass, false, "DICOS 3D AIT Storage", "DICOS");
  static const kDICOSQuadrupoleResonanceStorage = const WKUid("1.2.840.10008.5.1.4.1.1.501.6",
      WKUidType.kSopClass, false, "DICOS Quadrupole Resonance (QR) Storage", "DICOS");
  static const kEddyCurrentImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.601.1",
      WKUidType.kSopClass, false, "Eddy Current Image Storage", "DICONDE ASTM E2934");
  static const kEddyCurrentMulti_frameImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.601.2",
      WKUidType.kSopClass, false, "Eddy Current Multi-frame Image Storage", "DICONDE ASTM E2934");
  static const kPatientRootQueryRetrieveInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.1.2.1.1",
      WKUidType.kSopClass,
      false,
      "Patient Root Query/Retrieve Information Model - FIND",
      "PS3.4");
  static const kPatientRootQueryRetrieveInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.1.2.1.2",
      WKUidType.kSopClass,
      false,
      "Patient Root Query/Retrieve Information Model - MOVE",
      "PS3.4");
  static const kPatientRootQueryRetrieveInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.1.2.1.3",
      WKUidType.kSopClass,
      false,
      "Patient Root Query/Retrieve Information Model - GET",
      "PS3.4");
  static const kStudyRootQueryRetrieveInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.1.2.2.1",
      WKUidType.kSopClass,
      false,
      "Study Root Query/Retrieve Information Model - FIND",
      "PS3.4");
  static const kStudyRootQueryRetrieveInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.1.2.2.2",
      WKUidType.kSopClass,
      false,
      "Study Root Query/Retrieve Information Model - MOVE",
      "PS3.4");
  static const kStudyRootQueryRetrieveInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.1.2.2.3",
      WKUidType.kSopClass,
      false,
      "Study Root Query/Retrieve Information Model - GET",
      "PS3.4");
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.2.3.1",
      WKUidType.kSopClass,
      true,
      "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
      "PS3.4");
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.2.3.2",
      WKUidType.kSopClass,
      true,
      "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
      "PS3.4");
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.2.3.3",
      WKUidType.kSopClass,
      true,
      "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
      "PS3.4");
  static const kCompositeInstanceRootRetrieve_MOVE = const WKUid("1.2.840.10008.5.1.4.1.2.4.2",
      WKUidType.kSopClass, false, "Composite Instance Root Retrieve - MOVE", "PS3.4");
  static const kCompositeInstanceRootRetrieve_GET = const WKUid("1.2.840.10008.5.1.4.1.2.4.3",
      WKUidType.kSopClass, false, "Composite Instance Root Retrieve - GET", "PS3.4");
  static const kCompositeInstanceRetrieveWithoutBulkData_GET = const WKUid(
      "1.2.840.10008.5.1.4.1.2.5.3",
      WKUidType.kSopClass,
      false,
      "Composite Instance Retrieve Without Bulk Data - GET",
      "PS3.4");
  static const kModalityWorklistInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.31",
      WKUidType.kSopClass, false, "Modality Worklist Information Model - FIND", "PS3.4");
  static const kGeneralPurposeWorklistInformationModel_FIND_Retired = const WKUid(
      "1.2.840.10008.5.1.4.32.1",
      WKUidType.kSopClass,
      true,
      "General Purpose Worklist Information Model - FIND (Retired)",
      "PS3.4");
  static const kGeneralPurposeScheduledProcedureStepSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.4.32.2",
      WKUidType.kSopClass,
      true,
      "General Purpose Scheduled Procedure Step SOP Class (Retired)",
      "PS3.4");
  static const kGeneralPurposePerformedProcedureStepSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.4.32.3",
      WKUidType.kSopClass,
      true,
      "General Purpose Performed Procedure Step SOP Class (Retired)",
      "PS3.4");
  static const kGeneralPurposeWorklistManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.4.32",
      WKUidType.kMetaSopClass,
      true,
      "General Purpose Worklist Management Meta SOP Class (Retired)",
      "PS3.4");
  static const kInstanceAvailabilityNotificationSOPClass = const WKUid("1.2.840.10008.5.1.4.33",
      WKUidType.kSopClass, false, "Instance Availability Notification SOP Class", "PS3.4");
  static const kRTBeamsDeliveryInstructionStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.1",
      WKUidType.kSopClass,
      true,
      "RT Beams Delivery Instruction Storage - Trial (Retired)",
      "PS3.4");
  static const kRTConventionalMachineVerification_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.2",
      WKUidType.kSopClass,
      true,
      "RT Conventional Machine Verification - Trial (Retired)",
      "PS3.4");
  static const kRTIonMachineVerification_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.34.3",
      WKUidType.kSopClass, true, "RT Ion Machine Verification - Trial (Retired)", "PS3.4");
  static const kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.4",
      WKUidType.kServiceClass,
      true,
      "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
      "PS3.4");
  static const kUnifiedProcedureStep_PushSOPClass_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.4.1",
      WKUidType.kSopClass,
      true,
      "Unified Procedure Step - Push SOP Class - Trial (Retired)",
      "PS3.4");
  static const kUnifiedProcedureStep_WatchSOPClass_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.4.2",
      WKUidType.kSopClass,
      true,
      "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
      "PS3.4");
  static const kUnifiedProcedureStep_PullSOPClass_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.4.3",
      WKUidType.kSopClass,
      true,
      "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
      "PS3.4");
  static const kUnifiedProcedureStep_EventSOPClass_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.4.4",
      WKUidType.kSopClass,
      true,
      "Unified Procedure Step - Event SOP Class - Trial (Retired)",
      "PS3.4");
  static const kUnifiedWorklistandProcedureStepSOPInstance = const WKUid("1.2.840.10008.5.1.4.34.5",
      WKUidType.kSopInstance, false, "Unified Worklist and Procedure Step SOP Instance", "PS3.4");
  static const kUnifiedWorklistandProcedureStepServiceClass = const WKUid(
      "1.2.840.10008.5.1.4.34.6",
      WKUidType.kServiceClass,
      false,
      "Unified Worklist and Procedure Step Service Class",
      "PS3.4");
  static const kUnifiedProcedureStep_PushSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.1",
      WKUidType.kSopClass, false, "Unified Procedure Step - Push SOP Class", "PS3.4");
  static const kUnifiedProcedureStep_WatchSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.2",
      WKUidType.kSopClass, false, "Unified Procedure Step - Watch SOP Class", "PS3.4");
  static const kUnifiedProcedureStep_PullSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.3",
      WKUidType.kSopClass, false, "Unified Procedure Step - Pull SOP Class", "PS3.4");
  static const kUnifiedProcedureStep_EventSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.4",
      WKUidType.kSopClass, false, "Unified Procedure Step - Event SOP Class", "PS3.4");
  static const kRTBeamsDeliveryInstructionStorage = const WKUid("1.2.840.10008.5.1.4.34.7",
      WKUidType.kSopClass, false, "RT Beams Delivery Instruction Storage", "PS3.4");
  static const kRTConventionalMachineVerification = const WKUid("1.2.840.10008.5.1.4.34.8",
      WKUidType.kSopClass, false, "RT Conventional Machine Verification", "PS3.4");
  static const kRTIonMachineVerification = const WKUid(
      "1.2.840.10008.5.1.4.34.9", WKUidType.kSopClass, false, "RT Ion Machine Verification", "PS3.4");
  static const kGeneralRelevantPatientInformationQuery = const WKUid("1.2.840.10008.5.1.4.37.1",
      WKUidType.kSopClass, false, "General Relevant Patient Information Query", "PS3.4");
  static const kBreastImagingRelevantPatientInformationQuery = const WKUid(
      "1.2.840.10008.5.1.4.37.2",
      WKUidType.kSopClass,
      false,
      "Breast Imaging Relevant Patient Information Query",
      "PS3.4");
  static const kCardiacRelevantPatientInformationQuery = const WKUid("1.2.840.10008.5.1.4.37.3",
      WKUidType.kSopClass, false, "Cardiac Relevant Patient Information Query", "PS3.4");
  static const kHangingProtocolStorage = const WKUid(
      "1.2.840.10008.5.1.4.38.1", WKUidType.kSopClass, false, "Hanging Protocol Storage", "PS3.4");
  static const kHangingProtocolInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.38.2",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - FIND", "PS3.4");
  static const kHangingProtocolInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.38.3",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - MOVE", "PS3.4");
  static const kHangingProtocolInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.38.4",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - GET", "PS3.4");
  static const kColorPaletteStorage = const WKUid(
      "1.2.840.10008.5.1.4.39.1", WKUidType.kTransfer, false, "Color Palette Storage", "PS3.4");
  static const kColorPaletteInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.39.2",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - FIND", "PS3.4");
  static const kColorPaletteInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.39.3",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - MOVE", "PS3.4");
  static const kColorPaletteInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.39.4",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - GET", "PS3.4");
  static const kProductCharacteristicsQuerySOPClass = const WKUid("1.2.840.10008.5.1.4.41",
      WKUidType.kSopClass, false, "Product Characteristics Query SOP Class", "PS3.4");
  static const kSubstanceApprovalQuerySOPClass = const WKUid("1.2.840.10008.5.1.4.42",
      WKUidType.kSopClass, false, "Substance Approval Query SOP Class", "PS3.4");
  static const kGenericImplantTemplateStorage = const WKUid("1.2.840.10008.5.1.4.43.1",
      WKUidType.kSopClass, false, "Generic Implant Template Storage", "PS3.4");
  static const kGenericImplantTemplateInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.43.2",
      WKUidType.kSopClass,
      false,
      "Generic Implant Template Information Model - FIND",
      "PS3.4");
  static const kGenericImplantTemplateInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.43.3",
      WKUidType.kSopClass,
      false,
      "Generic Implant Template Information Model - MOVE",
      "PS3.4");
  static const kGenericImplantTemplateInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.43.4",
      WKUidType.kSopClass, false, "Generic Implant Template Information Model - GET", "PS3.4");
  static const kImplantAssemblyTemplateStorage = const WKUid("1.2.840.10008.5.1.4.44.1",
      WKUidType.kSopClass, false, "Implant Assembly Template Storage", "PS3.4");
  static const kImplantAssemblyTemplateInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.44.2",
      WKUidType.kSopClass,
      false,
      "Implant Assembly Template Information Model - FIND",
      "PS3.4");
  static const kImplantAssemblyTemplateInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.44.3",
      WKUidType.kSopClass,
      false,
      "Implant Assembly Template Information Model - MOVE",
      "PS3.4");
  static const kImplantAssemblyTemplateInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.44.4",
      WKUidType.kSopClass,
      false,
      "Implant Assembly Template Information Model - GET",
      "PS3.4");
  static const kImplantTemplateGroupStorage = const WKUid("1.2.840.10008.5.1.4.45.1",
      WKUidType.kSopClass, false, "Implant Template Group Storage", "PS3.4");
  static const kImplantTemplateGroupInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.45.2",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - FIND", "PS3.4");
  static const kImplantTemplateGroupInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.45.3",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - MOVE", "PS3.4");
  static const kImplantTemplateGroupInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.45.4",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - GET", "PS3.4");
  static const kNativeDICOMModel = const WKUid("1.2.840.10008.7.1.1",
      WKUidType.kApplicationHostingModel, false, "Native DICOM Model", "PS3.19");
  static const kAbstractMulti_DimensionalImageModel = const WKUid("1.2.840.10008.7.1.2",
      WKUidType.kApplicationHostingModel, false, "Abstract Multi-Dimensional Image Model", "PS3.19");
  static const kdicomDeviceName =
      const WKUid("1.2.840.10008.15.0.3.1", WKUidType.kLdapOid, false, "dicomDeviceName", "PS3.15");
  static const kdicomDescription =
      const WKUid("1.2.840.10008.15.0.3.2", WKUidType.kLdapOid, false, "dicomDescription", "PS3.15");
  static const kdicomManufacturer =
      const WKUid("1.2.840.10008.15.0.3.3", WKUidType.kLdapOid, false, "dicomManufacturer", "PS3.15");
  static const kdicomManufacturerModelName = const WKUid(
      "1.2.840.10008.15.0.3.4", WKUidType.kLdapOid, false, "dicomManufacturerModelName", "PS3.15");
  static const kdicomSoftwareVersion = const WKUid(
      "1.2.840.10008.15.0.3.5", WKUidType.kLdapOid, false, "dicomSoftwareVersion", "PS3.15");
  static const kdicomVendorData =
      const WKUid("1.2.840.10008.15.0.3.6", WKUidType.kLdapOid, false, "dicomVendorData", "PS3.15");
  static const kdicomAETitle =
      const WKUid("1.2.840.10008.15.0.3.7", WKUidType.kLdapOid, false, "dicomAETitle", "PS3.15");
  static const kdicomNetworkConnectionReference = const WKUid("1.2.840.10008.15.0.3.8",
      WKUidType.kLdapOid, false, "dicomNetworkConnectionReference", "PS3.15");
  static const kdicomApplicationCluster = const WKUid(
      "1.2.840.10008.15.0.3.9", WKUidType.kLdapOid, false, "dicomApplicationCluster", "PS3.15");
  static const kdicomAssociationInitiator = const WKUid(
      "1.2.840.10008.15.0.3.10", WKUidType.kLdapOid, false, "dicomAssociationInitiator", "PS3.15");
  static const kdicomAssociationAcceptor = const WKUid(
      "1.2.840.10008.15.0.3.11", WKUidType.kLdapOid, false, "dicomAssociationAcceptor", "PS3.15");
  static const kdicomHostname =
      const WKUid("1.2.840.10008.15.0.3.12", WKUidType.kLdapOid, false, "dicomHostname", "PS3.15");
  static const kdicomPort =
      const WKUid("1.2.840.10008.15.0.3.13", WKUidType.kLdapOid, false, "dicomPort", "PS3.15");
  static const kdicomSOPClass =
      const WKUid("1.2.840.10008.15.0.3.14", WKUidType.kLdapOid, false, "dicomSOPClass", "PS3.15");
  static const kdicomTransferRole = const WKUid(
      "1.2.840.10008.15.0.3.15", WKUidType.kLdapOid, false, "dicomTransferRole", "PS3.15");
  static const kdicomTransferSyntax = const WKUid(
      "1.2.840.10008.15.0.3.16", WKUidType.kLdapOid, false, "dicomTransferSyntax", "PS3.15");
  static const kdicomPrimaryDeviceType = const WKUid(
      "1.2.840.10008.15.0.3.17", WKUidType.kLdapOid, false, "dicomPrimaryDeviceType", "PS3.15");
  static const kdicomRelatedDeviceReference = const WKUid(
      "1.2.840.10008.15.0.3.18", WKUidType.kLdapOid, false, "dicomRelatedDeviceReference", "PS3.15");
  static const kdicomPreferredCalledAETitle = const WKUid(
      "1.2.840.10008.15.0.3.19", WKUidType.kLdapOid, false, "dicomPreferredCalledAETitle", "PS3.15");
  static const kdicomTLSCyphersuite = const WKUid(
      "1.2.840.10008.15.0.3.20", WKUidType.kLdapOid, false, "dicomTLSCyphersuite", "PS3.15");
  static const kdicomAuthorizedNodeCertificateReference = const WKUid("1.2.840.10008.15.0.3.21",
      WKUidType.kLdapOid, false, "dicomAuthorizedNodeCertificateReference", "PS3.15");
  static const kdicomThisNodeCertificateReference = const WKUid("1.2.840.10008.15.0.3.22",
      WKUidType.kLdapOid, false, "dicomThisNodeCertificateReference", "PS3.15");
  static const kdicomInstalled =
      const WKUid("1.2.840.10008.15.0.3.23", WKUidType.kLdapOid, false, "dicomInstalled", "PS3.15");
  static const kdicomStationName =
      const WKUid("1.2.840.10008.15.0.3.24", WKUidType.kLdapOid, false, "dicomStationName", "PS3.15");
  static const kdicomDeviceSerialNumber = const WKUid(
      "1.2.840.10008.15.0.3.25", WKUidType.kLdapOid, false, "dicomDeviceSerialNumber", "PS3.15");
  static const kdicomInstitutionName = const WKUid(
      "1.2.840.10008.15.0.3.26", WKUidType.kLdapOid, false, "dicomInstitutionName", "PS3.15");
  static const kdicomInstitutionAddress = const WKUid(
      "1.2.840.10008.15.0.3.27", WKUidType.kLdapOid, false, "dicomInstitutionAddress", "PS3.15");
  static const kdicomInstitutionDepartmentName = const WKUid("1.2.840.10008.15.0.3.28",
      WKUidType.kLdapOid, false, "dicomInstitutionDepartmentName", "PS3.15");
  static const kdicomIssuerOfPatientID = const WKUid(
      "1.2.840.10008.15.0.3.29", WKUidType.kLdapOid, false, "dicomIssuerOfPatientID", "PS3.15");
  static const kdicomPreferredCallingAETitle = const WKUid(
      "1.2.840.10008.15.0.3.30", WKUidType.kLdapOid, false, "dicomPreferredCallingAETitle", "PS3.15");
  static const kdicomSupportedCharacterSet = const WKUid(
      "1.2.840.10008.15.0.3.31", WKUidType.kLdapOid, false, "dicomSupportedCharacterSet", "PS3.15");
  static const kdicomConfigurationRoot = const WKUid(
      "1.2.840.10008.15.0.4.1", WKUidType.kLdapOid, false, "dicomConfigurationRoot", "PS3.15");
  static const kdicomDevicesRoot =
      const WKUid("1.2.840.10008.15.0.4.2", WKUidType.kLdapOid, false, "dicomDevicesRoot", "PS3.15");
  static const kdicomUniqueAETitlesRegistryRoot = const WKUid("1.2.840.10008.15.0.4.3",
      WKUidType.kLdapOid, false, "dicomUniqueAETitlesRegistryRoot", "PS3.15");
  static const kdicomDevice =
      const WKUid("1.2.840.10008.15.0.4.4", WKUidType.kLdapOid, false, "dicomDevice", "PS3.15");
  static const kdicomNetworkAE =
      const WKUid("1.2.840.10008.15.0.4.5", WKUidType.kLdapOid, false, "dicomNetworkAE", "PS3.15");
  static const kdicomNetworkConnection = const WKUid(
      "1.2.840.10008.15.0.4.6", WKUidType.kLdapOid, false, "dicomNetworkConnection", "PS3.15");
  static const kdicomUniqueAETitle = const WKUid(
      "1.2.840.10008.15.0.4.7", WKUidType.kLdapOid, false, "dicomUniqueAETitle", "PS3.15");
  static const kdicomTransferCapability = const WKUid(
      "1.2.840.10008.15.0.4.8", WKUidType.kLdapOid, false, "dicomTransferCapability", "PS3.15");
  static const kUniversalCoordinatedTime = const WKUid("1.2.840.10008.15.1.1",
      WKUidType.kSynchronizationFrameOfReference, false, "Universal Coordinated Time", "PS3.3");
}
