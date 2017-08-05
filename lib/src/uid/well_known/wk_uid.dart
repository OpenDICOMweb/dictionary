// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//part of odw.sdk.dictionary.uid;

import 'package:dictionary/src/uid/uid.dart';
import 'package:dictionary/src/uid/uid_type.dart';
import 'package:dictionary/src/uid/well_known/wk_uids_map.dart';

/// Compile time constant definitions for the "Well Known" UIDs from PS 3.6
class WKUid extends UidString {
  //TODO add keyword to table below
  final String keyword;
  @override
  final UidType type;
  final String name;
  final bool isRetired;

  const WKUid(String value, this.keyword, this.type, this.isRetired, this.name)
      : super.wellKnown(value);

  bool get isNotRetired => !isRetired;

  bool get isTransferSyntax => type == UidType.kTransferSyntax;

  bool get isSOPClass => type == UidType.kSOPClass;

  bool get isMetaSOPClass => type == UidType.kMetaSOPClass;

  bool get isFrameOfReference => type == UidType.kWellKnownFrameOfReference;

  bool get isSOPInstance => type == UidType.kWellKnownSOPInstance;

  bool get isCodingScheme => type == UidType.kCodingScheme;

  @override
  String get info => "UID: $asString (type=$type, name=$name)";

  @override
  String toString() => asString;

  static WKUid lookup(dynamic uid) {
    if (uid is Uid) uid = uid.asString;
    if (uid is String) return wellKnownUids[uid];
    return null;
  }

  //*****   Constant Values   *****
  static const WKUid kVerificationSOPClass = const WKUid(
      "1.2.840.10008.1.1",
      "VerificationSOPClass",
      UidType.kSOPClass,
      false,
      "Verification SOP Class");
  static const WKUid kImplicitVRLittleEndian = const WKUid(
    "1.2.840.10008.1.2",
    "ImplicitVRLittleEndian",
    UidType.kTransferSyntax,
    false,
    "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
  );
  static const WKUid kDefaultTransferSyntaxForDICOM = kImplicitVRLittleEndian;

  static const WKUid kExplicitVRLittleEndian = const WKUid(
      "1.2.840.10008.1.2.1",
      "ExplicitVRLittleEndian",
      UidType.kTransferSyntax,
      false,
      "Explicit VR Little Endian");
  static const WKUid kDefaultTransferSyntaxForDicomWeb =
      kExplicitVRLittleEndian;
  static const WKUid kDeflatedExplicitVRLittleEndian = const WKUid(
      "1.2.840.10008.1.2.1.99",
      "DeflatedExplicitVRLittleEndian",
      UidType.kTransferSyntax,
      false,
      "Deflated Explicit VR Little Endian");
  static const WKUid kExplicitVRBigEndian_Retired = const WKUid(
      "1.2.840.10008.1.2.2",
      "ExplicitVRBigEndian_Retired",
      UidType.kTransferSyntax,
      true,
      "Explicit VR Big Endian (Retired)");
  static const WKUid kJPEGBaseline_1 = const WKUid(
    "1.2.840.10008.1.2.4.50",
    "JPEGBaseline_1",
    UidType.kTransferSyntax,
    false,
    "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy JPEG 8 Bit Image Compression",
  );
  static const WKUid
      kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 =
      const WKUid(
    "1.2.840.10008.1.2.4.51",
          "JPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4",
    UidType.kTransferSyntax,
    false,
    "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for Lossy JPEG 12 Bit Image Compression (Process 4 only)",
  );
  static const WKUid kJPEGExtended_3_5_Retired = const WKUid(
      "1.2.840.10008.1.2.4.52",
      "JPEGExtended_3_5_Retired",
      UidType.kTransferSyntax,
      true,
      "JPEG Extended (Process 3 & 5) (Retired)");
  static const WKUid kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.53",
    "JPEGSpectralSelectionNon_Hierarchical_6_8_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
  );
  static const WKUid kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.54",
    "JPEGSpectralSelectionNon_Hierarchical_7_9_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
  );
  static const WKUid kJPEGFullProgressionNon_Hierarchical_10_12_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.55",
    "JPEGFullProgressionNon_Hierarchical_10_12_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
  );
  static const WKUid kJPEGFullProgressionNon_Hierarchical_11_13_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.56",
    "JPEGFullProgressionNon_Hierarchical_11_13_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
  );
  static const WKUid kJPEGLosslessNon_Hierarchical_14 = const WKUid(
      "1.2.840.10008.1.2.4.57",
      "JPEGLosslessNon_Hierarchical_14",
      UidType.kTransferSyntax,
      false,
      "JPEG Lossless, Non-Hierarchical (Process 14)");
  static const WKUid kJPEGLosslessNon_Hierarchical_15_Retired = const WKUid(
    "1.2.840.10008.1.2.4.58",
    "JPEGLosslessNon_Hierarchical_15_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
  );
  static const WKUid kJPEGExtendedHierarchical_16_18_Retired = const WKUid(
    "1.2.840.10008.1.2.4.59",
    "JPEGExtendedHierarchical_16_18_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
  );
  static const WKUid kJPEGExtendedHierarchical_17_19_Retired = const WKUid(
    "1.2.840.10008.1.2.4.60",
    "JPEGExtendedHierarchical_17_19_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
  );
  static const WKUid kJPEGSpectralSelectionHierarchical_20_22_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.61",
    "JPEGSpectralSelectionHierarchical_20_22_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
  );
  static const WKUid kJPEGSpectralSelectionHierarchical_21_23_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.62",
    "JPEGSpectralSelectionHierarchical_21_23_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
  );
  static const WKUid kJPEGFullProgressionHierarchical_24_26_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.63",
    "JPEGFullProgressionHierarchical_24_26_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
  );
  static const WKUid kJPEGFullProgressionHierarchical_25_27_Retired =
      const WKUid(
    "1.2.840.10008.1.2.4.64",
    "JPEGFullProgressionHierarchical_25_27_Retired",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
  );
  static const WKUid kJPEGLosslessHierarchical_28_Retired = const WKUid(
      "1.2.840.10008.1.2.4.65",
      "JPEGLosslessHierarchical_28_Retired",
      UidType.kTransferSyntax,
      true,
      "JPEG Lossless, Hierarchical (Process 28) (Retired)");
  static const WKUid kJPEGLosslessHierarchical_29_Retired = const WKUid(
      "1.2.840.10008.1.2.4.66",
      "JPEGLosslessHierarchical_29_Retired",
      UidType.kTransferSyntax,
      true,
      "JPEG Lossless, Hierarchical (Process 29) (Retired)");
  static const WKUid
      kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
      const WKUid(
    "1.2.840.10008.1.2.4.70",
    "JPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyn"
        "taxforLosslessJPEGImageCompression",
    UidType.kTransferSyntax,
    false,
    "JPEG Lossless, Non-Hierarchical, First-Order Prediction (Process 14 "
        "[Selection Value 1]) : Default Transfer Syntax for Lossless"
        " JPEG Image Compression",
  );
  static const WKUid kJPEG_LSLosslessImageCompression = const WKUid(
      "1.2.840.10008.1.2.4.80",
      "JPEG_LSLosslessImageCompression",
      UidType.kTransferSyntax,
      false,
      "JPEG-LS Lossless Image Compression");
  static const WKUid kJPEG_LSLossyImageCompression = const WKUid(
      "1.2.840.10008.1.2.4.81",
      "JPEG_LSLossyImageCompression",
      UidType.kTransferSyntax,
      false,
      "JPEG-LS Lossy (Near-Lossless) Image Compression");
  static const WKUid kJPEG2000ImageCompressionLosslessOnly = const WKUid(
      "1.2.840.10008.1.2.4.90",
      "JPEG2000ImageCompressionLosslessOnly",
      UidType.kTransferSyntax,
      false,
      "JPEG 2000 Image Compression Lossless Only");
  static const WKUid kJPEG2000ImageCompression = const WKUid(
      "1.2.840.10008.1.2.4.91",
      "JPEG2000ImageCompression",
      UidType.kTransferSyntax,
      false,
      "JPEG 2000 Image Compression");
  static const WKUid kJPEG2000Part2Multi_componentImageCompressionLosslessOnly =
      const WKUid(
    "1.2.840.10008.1.2.4.92",
    "JPEG2000Part2Multi_componentImageCompressionLosslessOnly",
    UidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
  );
  static const WKUid kJPEG2000Part2Multi_componentImageCompression =
      const WKUid(
    "1.2.840.10008.1.2.4.93",
    "JPEG2000Part2Multi_componentImageCompression",
    UidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression",
  );
  static const WKUid kJPIPReferenced = const WKUid("1.2.840.10008.1.2.4.94",
      "JPIPReferenced", UidType.kTransferSyntax, false, "JPIP Referenced");
  static const WKUid kJPIPReferencedDeflate = const WKUid(
      "1.2.840.10008.1.2.4.95",
      "JPIPReferencedDeflate",
      UidType.kTransferSyntax,
      false,
      "JPIP Referenced Deflate");
  static const WKUid kMPEG2MainProfile_MainLevel = const WKUid(
      "1.2.840.10008.1.2.4.100",
      "MPEG2MainProfile_MainLevel",
      UidType.kTransferSyntax,
      false,
      "MPEG2 Main Profile @ Main Level");
  static const WKUid kMPEG2MainProfile_HighLevel = const WKUid(
      "1.2.840.10008.1.2.4.101",
      "MPEG2MainProfile_HighLevel",
      UidType.kTransferSyntax,
      false,
      "MPEG2 Main Profile @ High Level");
  static const WKUid kMPEG_4AVC_H264HighProfile_Level41 = const WKUid(
      "1.2.840.10008.1.2.4.102",
      "MPEG_4AVC_H264HighProfile_Level41",
      UidType.kTransferSyntax,
      false,
      "MPEG-4 AVC/H.264 High Profile / Level 4.1");
  static const WKUid kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 =
      const WKUid(
    "1.2.840.10008.1.2.4.103",
    "MPEG_4AVC_H264BD_compatibleHighProfile_Level41",
    UidType.kTransferSyntax,
    false,
    "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
  );
  static const WKUid kRLELossless = const WKUid("1.2.840.10008.1.2.5",
      "RLELossless", UidType.kTransferSyntax, false, "RLE Lossless");
  static const WKUid kRFC2557MIMEencapsulation = const WKUid(
      "1.2.840.10008.1.2.6.1",
      "RFC2557MIMEencapsulation",
      UidType.kTransferSyntax,
      false,
      "RFC 2557 MIME encapsulation");
  static const WKUid kXMLEncoding = const WKUid("1.2.840.10008.1.2.6.2",
      "XMLEncoding", UidType.kTransferSyntax, false, "XML Encoding");
  static const WKUid kMediaStorageDirectoryStorage = const WKUid(
      "1.2.840.10008.1.3.10",
      "MediaStorageDirectoryStorage",
      UidType.kSOPClass,
      false,
      "Media Storage Directory Storage");
  static const WKUid kTalairachBrainAtlasFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.1",
      "TalairachBrainAtlasFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "Talairach Brain Atlas Frame of Reference");
  static const WKUid kSPM2T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.2",
      "SPM2T1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 T1 Frame of Reference");
  static const WKUid kSPM2T2FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.3",
      "SPM2T2FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 T2 Frame of Reference");
  static const WKUid kSPM2PDFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.4",
      "SPM2PDFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 PD Frame of Reference");
  static const WKUid kSPM2EPIFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.5",
      "SPM2EPIFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 EPI Frame of Reference");
  static const WKUid kSPM2FILT1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.6",
      "SPM2FILT1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 FIL T1 Frame of Reference");
  static const WKUid kSPM2PETFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.7",
      "SPM2PETFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 PET Frame of Reference");
  static const WKUid kSPM2TRANSMFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.8",
      "SPM2TRANSMFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 TRANSM Frame of Reference");
  static const WKUid kSPM2SPECTFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.9",
      "SPM2SPECTFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 SPECT Frame of Reference");
  static const WKUid kSPM2GRAYFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.10",
      "SPM2GRAYFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 GRAY Frame of Reference");
  static const WKUid kSPM2WHITEFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.11",
      "SPM2WHITEFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 WHITE Frame of Reference");
  static const WKUid kSPM2CSFFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.12",
      "SPM2CSFFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 CSF Frame of Reference");
  static const WKUid kSPM2BRAINMASKFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.13",
      "SPM2BRAINMASKFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 BRAINMASK Frame of Reference");
  static const WKUid kSPM2AVG305T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.14",
      "SPM2AVG305T1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 AVG305T1 Frame of Reference");
  static const WKUid kSPM2AVG152T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.15",
      "SPM2AVG152T1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 AVG152T1 Frame of Reference");
  static const WKUid kSPM2AVG152T2FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.16",
      "SPM2AVG152T2FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 AVG152T2 Frame of Reference");
  static const WKUid kSPM2AVG152PDFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.17",
      "SPM2AVG152PDFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 AVG152PD Frame of Reference");
  static const WKUid kSPM2SINGLESUBJT1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.18",
      "SPM2SINGLESUBJT1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "SPM2 SINGLESUBJT1 Frame of Reference");
  static const WKUid kICBM452T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.2.1",
      "ICBM452T1FrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "ICBM 452 T1 Frame of Reference");
  static const WKUid kICBMSingleSubjectMRIFrameofReference = const WKUid(
      "1.2.840.10008.1.4.2.2",
      "ICBMSingleSubjectMRIFrameofReference",
      UidType.kWellKnownFrameOfReference,
      false,
      "ICBM Single Subject MRI Frame of Reference");
  static const WKUid kHotIronColorPaletteSOPInstance = const WKUid(
    "1.2.840.10008.1.5.1",
    "HotIronColorPaletteSOPInstance",
    UidType.kColorPalette,
    false,
    "Hot Iron Color Palette SOP "
        "Instance",
  );
  static const WKUid kPETColorPaletteSOPInstance = const WKUid(
      "1.2.840.10008.1.5.2",
      "PETColorPaletteSOPInstance",
      UidType.kColorPalette,
      false,
      "PET Color Palette SOP Instance");
  static const WKUid kHotMetalBlueColorPaletteSOPInstance = const WKUid(
      "1.2.840.10008.1.5.3",
      "HotMetalBlueColorPaletteSOPInstance",
      UidType.kColorPalette,
      false,
      "Hot Metal Blue Color Palette SOP Instance");
  static const WKUid kPET20StepColorPaletteSOPInstance = const WKUid(
      "1.2.840.10008.1.5.4",
      "PET20StepColorPaletteSOPInstance",
      UidType.kWellKnownSOPInstance,
      false,
      "PET 20 Step Color Palette SOP Instance");
  static const WKUid kBasicStudyContentNotificationSOPClass_Retired =
      const WKUid(
          "1.2.840.10008.1.9",
          "BasicStudyContentNotificationSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Basic Study Content Notification SOP Class (Retired)");
  static const WKUid kStorageCommitmentPushModelSOPClass = const WKUid(
      "1.2.840.10008.1.20.1",
      "StorageCommitmentPushModelSOPClass",
      UidType.kSOPClass,
      true,
      "Storage Commitment Push Model SOP Class");
  static const WKUid kStorageCommitmentPushModelSOPInstance = const WKUid(
      "1.2.840.10008.1.20.1.1",
      "StorageCommitmentPushModelSOPInstance",
      UidType.kWellKnownSOPInstance,
      false,
      "Storage Commitment Push Model SOP Instance");
  static const WKUid kStorageCommitmentPullModelSOPClass_Retired = const WKUid(
      "1.2.840.10008.1.20.2",
      "StorageCommitmentPullModelSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Storage Commitment Pull Model SOP Class (Retired)");
  static const WKUid kStorageCommitmentPullModelSOPInstance_Retired =
      const WKUid(
    "1.2.840.10008.1.20.2.1",
    "StorageCommitmentPullModelSOPInstance_Retired",
    UidType.kWellKnownSOPInstance,
    true,
    "Storage Commitment Pull Model SOP Instance (Retired)",
  );
  static const WKUid kProceduralEventLoggingSOPClass = const WKUid(
      "1.2.840.10008.1.40",
      "ProceduralEventLoggingSOPClass",
      UidType.kSOPClass,
      false,
      "Procedural Event Logging SOP Class");
  static const WKUid kProceduralEventLoggingSOPInstance = const WKUid(
      "1.2.840.10008.1.40.1",
      "ProceduralEventLoggingSOPInstance",
      UidType.kWellKnownSOPInstance,
      false,
      "Procedural Event Logging SOP Instance");
  static const WKUid kSubstanceAdministrationLoggingSOPClass = const WKUid(
      "1.2.840.10008.1.42",
      "SubstanceAdministrationLoggingSOPClass",
      UidType.kSOPClass,
      false,
      "Substance Administration Logging SOP Class");
  static const WKUid kSubstanceAdministrationLoggingSOPInstance = const WKUid(
      "1.2.840.10008.1.42.1",
      "SubstanceAdministrationLoggingSOPInstance",
      UidType.kWellKnownSOPInstance,
      false,
      "Substance Administration Logging SOP Instance");
  static const WKUid kDICOMUIDRegistry = const WKUid(
      "1.2.840.10008.2.6.1",
      "DICOMUIDRegistry",
      UidType.kDicomUidCodingScheme,
      false,
      "DICOM UID Registry");
  static const WKUid kDICOMControlledTerminology = const WKUid(
    "1.2.840.10008.2.16.4",
    "DICOMControlledTerminology",
    UidType.kCodingScheme,
    false,
    "DICOM Controlled Terminology",
  );
  static const WKUid kDICOMApplicationContextName = const WKUid(
    "1.2.840.10008.3.1.1.1",
    "DICOMApplicationContextName",
    UidType.kApplicationContextName,
    false,
    "DICOM Application Context Name",
  );
  static const WKUid kDetachedPatientManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.1.1",
      "DetachedPatientManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Detached Patient Management SOP Class (Retired)");
  static const WKUid kDetachedPatientManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.3.1.2.1.4",
    "DetachedPatientManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "Detached Patient Management Meta SOP Class (Retired)",
  );
  static const WKUid kDetachedVisitManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.2.1",
      "DetachedVisitManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Detached Visit Management SOP Class (Retired)");
  static const WKUid kDetachedStudyManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.3.1",
      "DetachedStudyManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Detached Study Management SOP Class (Retired)");
  static const WKUid kStudyComponentManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.3.2",
      "StudyComponentManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Study Component Management SOP Class (Retired)");
  static const WKUid kModalityPerformedProcedureStepSOPClass = const WKUid(
      "1.­2.840.10008.3.1.2.3.3",
      "ModalityPerformedProcedureStepSOPClass",
      UidType.kSOPClass,
      false,
      "Modality Performed Procedure Step SOP Class");

  static const WKUid kModalityPerformedProcedureStepRetrieveSOPClass =
      const WKUid(
    "1.2.840.10008.3.1.2.3.4",
    "ModalityPerformedProcedureStepRetrieveSOPClass",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Retrieve SOP Class",
  );
  static const WKUid kModalityPerformedProcedureStepNotificationSOPClass =
      const WKUid(
    "1.­2.840.10008.3.1.2.3.5",
    "ModalityPerformedProcedureStepNotificationSOPClass",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Notification SOP Class",
  );
  static const WKUid kDetachedResultsManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.5.1",
      "DetachedResultsManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Detached Results Management SOP Class (Retired)");
  static const WKUid kDetachedResultsManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.3.1.2.5.4",
    "DetachedResultsManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "Detached Results Management Meta SOP Class (Retired)",
  );
  static const WKUid kDetachedStudyManagementMetaSOPClass_Retired = const WKUid(
      "1.2.840.10008.3.1.2.5.5",
      "DetachedStudyManagementMetaSOPClass_Retired",
      UidType.kMetaSOPClass,
      true,
      "Detached Study Management Meta SOP Class (Retired)");
  static const WKUid kDetachedInterpretationManagementSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.3.1.2.6.1",
    "DetachedInterpretationManagementSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );
  static const WKUid kStorageServiceClass = const WKUid(
      "1.2.840.10008.4.2",
      "StorageServiceClass",
      UidType.kServiceClass,
      false,
      "Storage Service Class");
  static const WKUid kBasicFilmSessionSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.1",
      "BasicFilmSessionSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Film Session SOP Class");
  static const WKUid kBasicFilmBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.2",
      "BasicFilmBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Film Box SOP Class");
  static const WKUid kBasicGrayscaleImageBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.4",
      "BasicGrayscaleImageBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Grayscale Image Box SOP Class");
  static const WKUid kBasicColorImageBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.4.1",
      "BasicColorImageBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Color Image Box SOP Class");
  static const WKUid kReferencedImageBoxSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.4.2",
      "ReferencedImageBoxSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Referenced Image Box SOP Class (Retired)");
  static const WKUid kBasicGrayscalePrintManagementMetaSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.9",
      "BasicGrayscalePrintManagementMetaSOPClass",
      UidType.kMetaSOPClass,
      false,
      "Basic Grayscale Print Management Meta SOP Class");
  static const WKUid kReferencedGrayscalePrintManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.1.9.1",
    "ReferencedGrayscalePrintManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "Referenced Grayscale Print Management Meta SOP Class (Retired)",
  );
  static const WKUid kPrintJobSOPClass = const WKUid("1.2.840.10008.5.1.1.14",
      "PrintJobSOPClass", UidType.kSOPClass, false, "Print Job SOP Class");
  static const WKUid kBasicAnnotationBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.15",
      "BasicAnnotationBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Annotation Box SOP Class");
  static const WKUid kPrinterSOPClass = const WKUid("1.2.840.10008.5.1.1.16",
      "PrinterSOPClass", UidType.kSOPClass, false, "Printer SOP Class");
  static const WKUid kPrinterConfigurationRetrievalSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.16.376",
      "PrinterConfigurationRetrievalSOPClass",
      UidType.kSOPClass,
      false,
      "Printer Configuration Retrieval SOP Class");
  static const WKUid kPrinterSOPInstance = const WKUid(
      "1.2.840.10008.5.1.1.17",
      "PrinterSOPInstance",
      UidType.kWellKnownPrinterSOPInstance,
      false,
      "Printer SOP Instance");
  static const WKUid kPrinterConfigurationRetrievalSOPInstance = const WKUid(
      "1.2.840.10008.5.1.1.17.376",
      "PrinterConfigurationRetrievalSOPInstance",
      UidType.kWellKnownPrinterSOPInstance,
      false,
      "Printer Configuration Retrieval SOP Instance");
  static const WKUid kBasicColorPrintManagementMetaSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.18",
      "BasicColorPrintManagementMetaSOPClass",
      UidType.kMetaSOPClass,
      false,
      "Basic Color Print Management Meta SOP Class");
  static const WKUid kReferencedColorPrintManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.1.18.1",
    "ReferencedColorPrintManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "Referenced Color Print Management Meta SOP Class (Retired)",
  );
  static const WKUid kVOILUTBoxSOPClass = const WKUid("1.2.840.10008.5.1.1.22",
      "VOILUTBoxSOPClass", UidType.kSOPClass, false, "VOI LUT Box SOP Class");
  static const WKUid kPresentationLUTSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.23",
      "PresentationLUTSOPClass",
      UidType.kSOPClass,
      false,
      "Presentation LUT SOP Class");
  static const WKUid kImageOverlayBoxSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.24",
      "ImageOverlayBoxSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Image Overlay Box SOP Class (Retired)");
  static const WKUid kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.24.1",
      "BasicPrintImageOverlayBoxSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Basic Print Image Overlay Box SOP Class (Retired)");
  static const WKUid kPrintQueueSOPInstance_Retired = const WKUid(
      "1.2.840.10008.5.1.1.25",
      "PrintQueueSOPInstance_Retired",
      UidType.kWellKnownPrintQueueSOPInstance,
      true,
      "Print Queue SOP Instance (Retired)");
  static const WKUid kPrintQueueManagementSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.26",
      "PrintQueueManagementSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Print Queue Management SOP Class (Retired)");
  static const WKUid kStoredPrintStorageSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.27",
      "StoredPrintStorageSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Stored Print Storage SOP Class (Retired)");
  static const WKUid kHardcopyGrayscaleImageStorageSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.1.29",
    "HardcopyGrayscaleImageStorageSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "Hardcopy Grayscale Image Storage SOP Class (Retired)",
  );
  static const WKUid kHardcopyColorImageStorageSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.30",
      "HardcopyColorImageStorageSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Hardcopy Color Image Storage SOP Class (Retired)");
  static const WKUid kPullPrintRequestSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.31",
      "PullPrintRequestSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Pull Print Request SOP Class (Retired)");
  static const WKUid kPullStoredPrintManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.1.32",
    "PullStoredPrintManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "Pull Stored Print Management Meta SOP Class (Retired)",
  );
  static const WKUid kMediaCreationManagementSOPClassUID = const WKUid(
      "1.2.840.10008.5.1.1.33",
      "MediaCreationManagementSOPClassUID",
      UidType.kSOPClass,
      false,
      "Media Creation Management SOP Class UID");
  static const WKUid kComputedRadiographyImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.1",
      "ComputedRadiographyImageStorage",
      UidType.kSOPClass,
      false,
      "Computed Radiography Image Storage");
  static const WKUid kDigitalX_RayImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.1",
    "DigitalX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Presentation",
  );
  static const WKUid kDigitalX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.1.1",
    "DigitalX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Processing",
  );
  static const WKUid kDigitalMammographyX_RayImageStorage_ForPresentation =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.2",
    "DigitalMammographyX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Presentation",
  );
  static const WKUid kDigitalMammographyX_RayImageStorage_ForProcessing =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.2.1",
    "DigitalMammographyX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Processing",
  );
  static const WKUid kDigitalIntra_OralX_RayImageStorage_ForPresentation =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.3",
    "DigitalIntra_OralX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Presentation",
  );
  static const WKUid kDigitalIntra_OralX_RayImageStorage_ForProcessing =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.3.1",
    "DigitalIntra_OralX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Processing",
  );
  static const WKUid kCTImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.2",
      "CTImageStorage", UidType.kSOPClass, false, "CT Image Storage");
  static const WKUid kEnhancedCTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.2.1",
      "EnhancedCTImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced CT Image Storage");
  static const WKUid kLegacyConvertedEnhancedCTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.2.2",
      "LegacyConvertedEnhancedCTImageStorage",
      UidType.kSOPClass,
      false,
      "Legacy Converted Enhanced CT Image Storage");
  static const WKUid kUltrasoundMulti_frameImageStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.3",
      "UltrasoundMulti_frameImageStorage_Retired",
      UidType.kSOPClass,
      true,
      "Ultrasound Multi-frame Image Storage (Retired)");
  static const WKUid kUltrasoundMulti_frameImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.3.1",
      "UltrasoundMulti_frameImageStorage",
      UidType.kSOPClass,
      false,
      "Ultrasound Multi-frame Image Storage");
  static const WKUid kMRImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4",
      "MRImageStorage", UidType.kSOPClass, false, "MR Image Storage");
  static const WKUid kEnhancedMRImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.1",
      "EnhancedMRImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced MR Image Storage");
  static const WKUid kMRSpectroscopyStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.2",
      "MRSpectroscopyStorage",
      UidType.kSOPClass,
      false,
      "MR Spectroscopy Storage");
  static const WKUid kEnhancedMRColorImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.3",
      "EnhancedMRColorImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced MR Color Image Storage");
  static const WKUid kLegacyConvertedEnhancedMRImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.4",
      "LegacyConvertedEnhancedMRImageStorage",
      UidType.kSOPClass,
      false,
      "Legacy Converted Enhanced MR Image Storage");
  static const WKUid kNuclearMedicineImageStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.5",
      "NuclearMedicineImageStorage_Retired",
      UidType.kSOPClass,
      true,
      "Nuclear Medicine Image Storage (Retired)");
  static const WKUid kUltrasoundImageStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6",
      "UltrasoundImageStorage_Retired",
      UidType.kSOPClass,
      true,
      "Ultrasound Image Storage (Retired)");
  static const WKUid kUltrasoundImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6.1",
      "UltrasoundImageStorage",
      UidType.kSOPClass,
      false,
      "Ultrasound Image Storage");
  static const WKUid kEnhancedUSVolumeStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6.2",
      "EnhancedUSVolumeStorage",
      UidType.kSOPClass,
      false,
      "Enhanced US Volume Storage");
  static const WKUid kSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7",
      "SecondaryCaptureImageStorage",
      UidType.kSOPClass,
      false,
      "Secondary Capture Image Storage");
  static const WKUid kMulti_frameSingleBitSecondaryCaptureImageStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.1",
    "Multi_frameSingleBitSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Single Bit Secondary Capture Image Storage",
  );
  static const WKUid kMulti_frameGrayscaleByteSecondaryCaptureImageStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.2",
    "Multi_frameGrayscaleByteSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Byte Secondary Capture Image Storage",
  );
  static const WKUid kMulti_frameGrayscaleWordSecondaryCaptureImageStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.3",
    "Multi_frameGrayscaleWordSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Word Secondary Capture Image Storage",
  );
  static const WKUid kMulti_frameTrueColorSecondaryCaptureImageStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.4",
    "Multi_frameTrueColorSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame True Color Secondary Capture Image Storage",
  );
  static const WKUid kStandaloneOverlayStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.8",
      "StandaloneOverlayStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone Overlay Storage (Retired)");
  static const WKUid kStandaloneCurveStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9",
      "StandaloneCurveStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone Curve Storage (Retired)");
  static const WKUid kWaveformStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.1",
      "WaveformStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Waveform Storage - Trial (Retired)");
  static const WKUid ktwelve_lead_12ECGWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.1.1",
      "twelve_lead_12ECGWaveformStorage",
      UidType.kSOPClass,
      false,
      "twelve-lead(12) ECG Waveform Storage");
  static const WKUid kGeneralECGWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.1.2",
      "GeneralECGWaveformStorage",
      UidType.kSOPClass,
      false,
      "General ECG Waveform Storage");
  static const WKUid kAmbulatoryECGWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.1.3",
      "AmbulatoryECGWaveformStorage",
      UidType.kSOPClass,
      false,
      "Ambulatory ECG Waveform Storage");
  static const WKUid kHemodynamicWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.2.1",
      "HemodynamicWaveformStorage",
      UidType.kSOPClass,
      false,
      "Hemodynamic Waveform Storage");
  static const WKUid kCardiacElectrophysiologyWaveformStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.9.3.1",
    "CardiacElectrophysiologyWaveformStorage",
    UidType.kSOPClass,
    false,
    "Cardiac Electrophysiology Waveform Storage",
  );
  static const WKUid kBasicVoiceAudioWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.4.1",
      "BasicVoiceAudioWaveformStorage",
      UidType.kSOPClass,
      false,
      "Basic Voice Audio Waveform Storage");
  static const WKUid kGeneralAudioWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.4.2",
      "GeneralAudioWaveformStorage",
      UidType.kSOPClass,
      false,
      "General Audio Waveform Storage");
  static const WKUid kArterialPulseWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.5.1",
      "ArterialPulseWaveformStorage",
      UidType.kSOPClass,
      false,
      "Arterial Pulse Waveform Storage");
  static const WKUid kRespiratoryWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.6.1",
      "RespiratoryWaveformStorage",
      UidType.kSOPClass,
      false,
      "Respiratory Waveform Storage");
  static const WKUid kStandaloneModalityLUTStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.10",
      "StandaloneModalityLUTStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone Modality LUT Storage (Retired)");
  static const WKUid kStandaloneVOILUTStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.11",
      "StandaloneVOILUTStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone VOI LUT Storage (Retired)");
  static const WKUid kGrayscaleSoftcopyPresentationStateStorageSOPClass =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.1",
    "GrayscaleSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Grayscale Softcopy Presentation State Storage SOP Class",
  );
  static const WKUid kColorSoftcopyPresentationStateStorageSOPClass =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.2",
    "ColorSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Color Softcopy Presentation State Storage SOP Class",
  );
  static const WKUid kPseudo_ColorSoftcopyPresentationStateStorageSOPClass =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.3",
    "Pseudo_ColorSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Pseudo-Color Softcopy Presentation State Storage SOP Class",
  );
  static const WKUid kBlendingSoftcopyPresentationStateStorageSOPClass =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.4",
    "BlendingSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Blending Softcopy Presentation State Storage SOP Class",
  );
  static const WKUid kXA_XRFGrayscaleSoftcopyPresentationStateStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.5",
    "XA_XRFGrayscaleSoftcopyPresentationStateStorage",
    UidType.kSOPClass,
    false,
    "XA/XRF Grayscale Softcopy Presentation State Storage",
  );
  static const WKUid kX_RayAngiographicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.1",
      "X_RayAngiographicImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray Angiographic Image Storage");
  static const WKUid kEnhancedXAImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.1.1",
      "EnhancedXAImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced XA Image Storage");
  static const WKUid kX_RayRadiofluoroscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.2",
      "X_RayRadiofluoroscopicImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray Radiofluoroscopic Image Storage");
  static const WKUid kEnhancedXRFImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.2.1",
      "EnhancedXRFImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced XRF Image Storage");
  static const WKUid kX_RayAngiographicBi_PlaneImageStorage_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.12.3",
    "X_RayAngiographicBi_PlaneImageStorage_Retired",
    UidType.kSOPClass,
    true,
    "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
  );
  static const WKUid kX_Ray3DAngiographicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.13.1.1",
      "X_Ray3DAngiographicImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Angiographic Image Storage");
  static const WKUid kX_Ray3DCraniofacialImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.13.1.2",
      "X_Ray3DCraniofacialImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Craniofacial Image Storage");
  static const WKUid kBreastTomosynthesisImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.13.1.3",
      "BreastTomosynthesisImageStorage",
      UidType.kSOPClass,
      false,
      "Breast Tomosynthesis Image Storage");
  static const WKUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.14.1",
    "IntravascularOpticalCoherenceTomographyImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Presentation",
  );
  static const WKUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.14.2",
    "IntravascularOpticalCoherenceTomographyI"
        "mageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Processing",
  );
  static const WKUid kNuclearMedicineImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.20",
      "NuclearMedicineImageStorage",
      UidType.kSOPClass,
      false,
      "Nuclear Medicine Image Storage");
  static const WKUid kRawDataStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66",
      "RawDataStorage", UidType.kSOPClass, false, "Raw Data Storage");
  static const WKUid kSpatialRegistrationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.1",
      "SpatialRegistrationStorage",
      UidType.kSOPClass,
      false,
      "Spatial Registration Storage");
  static const WKUid kSpatialFiducialsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.2",
      "SpatialFiducialsStorage",
      UidType.kSOPClass,
      false,
      "Spatial Fiducials Storage");
  static const WKUid kDeformableSpatialRegistrationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.3",
      "DeformableSpatialRegistrationStorage",
      UidType.kSOPClass,
      false,
      "Deformable Spatial Registration Storage");
  static const WKUid kSegmentationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.4",
      "SegmentationStorage",
      UidType.kSOPClass,
      false,
      "Segmentation Storage");
  static const WKUid kSurfaceSegmentationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.5",
      "SurfaceSegmentationStorage",
      UidType.kSOPClass,
      false,
      "Surface Segmentation Storage");
  static const WKUid kRealWorldValueMappingStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.67",
      "RealWorldValueMappingStorage",
      UidType.kSOPClass,
      false,
      "Real World Value Mapping Storage");
  static const WKUid kSurfaceScanMeshStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.68.1",
      "SurfaceScanMeshStorage",
      UidType.kSOPClass,
      false,
      "Surface Scan Mesh Storage");
  static const WKUid kSurfaceScanPointCloudStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.68.2",
      "SurfaceScanPointCloudStorage",
      UidType.kSOPClass,
      false,
      "Surface Scan Point Cloud Storage");
  static const WKUid kVLImageStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1",
      "VLImageStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "VL Image Storage - Trial (Retired)");
  static const WKUid kVLMulti_frameImageStorage_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.2",
    "VLMulti_frameImageStorage_Trial_Retired",
    UidType.kSOPClass,
    true,
    "VL Multi-frame Image Storage - Trial (Retired)",
  );
  static const WKUid kVLEndoscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1",
      "VLEndoscopicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Endoscopic Image Storage");
  static const WKUid kVideoEndoscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1.1",
      "VideoEndoscopicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Endoscopic Image Storage");
  static const WKUid kVLMicroscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2",
      "VLMicroscopicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Microscopic Image Storage");
  static const WKUid kVideoMicroscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2.1",
      "VideoMicroscopicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Microscopic Image Storage");
  static const WKUid kVLSlide_CoordinatesMicroscopicImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.3",
    "VLSlide_CoordinatesMicroscopicImageStorage",
    UidType.kSOPClass,
    false,
    "VL Slide-Coordinates Microscopic Image Storage",
  );
  static const WKUid kVLPhotographicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4",
      "VLPhotographicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Photographic Image Storage");
  static const WKUid kVideoPhotographicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4.1",
      "VideoPhotographicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Photographic Image Storage");
  static const WKUid kOphthalmicPhotography8BitImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.1",
    "OphthalmicPhotography8BitImageStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 8 Bit Image Storage",
  );
  static const WKUid kOphthalmicPhotography16BitImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.2",
    "OphthalmicPhotography16BitImageStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 16 Bit Image Storage",
  );
  static const WKUid kStereometricRelationshipStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.3",
      "StereometricRelationshipStorage",
      UidType.kSOPClass,
      false,
      "Stereometric Relationship Storage");
  static const WKUid kOphthalmicTomographyImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.4",
      "OphthalmicTomographyImageStorage",
      UidType.kSOPClass,
      false,
      "Ophthalmic Tomography Image Storage");
  static const WKUid kVLWholeSlideMicroscopyImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.6",
      "VLWholeSlideMicroscopyImageStorage",
      UidType.kSOPClass,
      false,
      "VL Whole Slide Microscopy Image Storage");
  static const WKUid kLensometryMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.1",
      "LensometryMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Lensometry Measurements Storage");
  static const WKUid kAutorefractionMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.2",
      "AutorefractionMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Autorefraction Measurements Storage");
  static const WKUid kKeratometryMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.3",
      "KeratometryMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Keratometry Measurements Storage");
  static const WKUid kSubjectiveRefractionMeasurementsStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.78.4",
    "SubjectiveRefractionMeasurementsStorage",
    UidType.kSOPClass,
    false,
    "Subjective Refraction Measurements Storage",
  );
  static const WKUid kVisualAcuityMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.5",
      "VisualAcuityMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Visual Acuity Measurements Storage");
  static const WKUid kSpectaclePrescriptionReportStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.6",
      "SpectaclePrescriptionReportStorage",
      UidType.kSOPClass,
      false,
      "Spectacle Prescription Report Storage");
  static const WKUid kOphthalmicAxialMeasurementsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.7",
      "OphthalmicAxialMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Ophthalmic Axial Measurements Storage");
  static const WKUid kIntraocularLensCalculationsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.78.8",
      "IntraocularLensCalculationsStorage",
      UidType.kSOPClass,
      false,
      "Intraocular Lens Calculations Storage");
  static const WKUid kMacularGridThicknessandVolumeReportStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.79.1",
    "MacularGridThicknessandVolumeReportStorage",
    UidType.kSOPClass,
    false,
    "Macular Grid Thickness and Volume Report Storage",
  );
  static const WKUid kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.80.1",
    "OphthalmicVisualFieldStaticPerimetryMeasurementsStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Visual Field Static Perimetry Measurements Storage",
  );
  static const WKUid kOphthalmicThicknessMapStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.81.1",
      "OphthalmicThicknessMapStorage",
      UidType.kSOPClass,
      false,
      "Ophthalmic Thickness Map Storage");
  static const WKUid kCornealTopographyMapStorage = const WKUid(
      "11.2.840.10008.5.1.4.1.1.82.1",
      "CornealTopographyMapStorage",
      UidType.kSOPClass,
      false,
      "Corneal Topography Map Storage");
  static const WKUid kTextSRStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.1",
      "TextSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Text SR Storage - Trial (Retired)");
  static const WKUid kAudioSRStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.2",
      "AudioSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Audio SR Storage - Trial (Retired)");
  static const WKUid kDetailSRStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.3",
      "DetailSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Detail SR Storage - Trial (Retired)");
  static const WKUid kComprehensiveSRStorage_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.4",
      "ComprehensiveSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Comprehensive SR Storage - Trial (Retired)");
  static const WKUid kBasicTextSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.11",
      "BasicTextSRStorage",
      UidType.kSOPClass,
      false,
      "Basic Text SR Storage");
  static const WKUid kEnhancedSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.22",
      "EnhancedSRStorage",
      UidType.kSOPClass,
      false,
      "Enhanced SR Storage");
  static const WKUid kComprehensiveSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.33",
      "ComprehensiveSRStorage",
      UidType.kSOPClass,
      false,
      "Comprehensive SR Storage");
  static const WKUid kComprehensive3DSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.34",
      "Comprehensive3DSRStorage",
      UidType.kSOPClass,
      false,
      "Comprehensive 3D SR Storage");
  static const WKUid kProcedureLogStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.40",
      "ProcedureLogStorage",
      UidType.kSOPClass,
      false,
      "Procedure Log Storage");
  static const WKUid kMammographyCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.50",
      "MammographyCADSRStorage",
      UidType.kSOPClass,
      false,
      "Mammography CAD SR Storage");
  static const WKUid kKeyObjectSelectionDocumentStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.59",
      "KeyObjectSelectionDocumentStorage",
      UidType.kSOPClass,
      false,
      "Key Object Selection Document Storage");
  static const WKUid kChestCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.65",
      "ChestCADSRStorage",
      UidType.kSOPClass,
      false,
      "Chest CAD SR Storage");
  static const WKUid kX_RayRadiationDoseSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.67",
      "X_RayRadiationDoseSRStorage",
      UidType.kSOPClass,
      false,
      "X-Ray Radiation Dose SR Storage");
  static const WKUid kColonCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.69",
      "ColonCADSRStorage",
      UidType.kSOPClass,
      false,
      "Colon CAD SR Storage");
  static const WKUid kImplantationPlanSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.70",
      "ImplantationPlanSRStorage",
      UidType.kSOPClass,
      false,
      "Implantation Plan SR Storage");
  static const WKUid kEncapsulatedPDFStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.104.1",
      "EncapsulatedPDFStorage",
      UidType.kSOPClass,
      false,
      "Encapsulated PDF Storage");
  static const WKUid kEncapsulatedCDAStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.104.2",
      "EncapsulatedCDAStorage",
      UidType.kSOPClass,
      false,
      "Encapsulated CDA Storage");
  static const WKUid kPositronEmissionTomographyImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.128",
      "PositronEmissionTomographyImageStorage",
      UidType.kSOPClass,
      false,
      "Positron Emission Tomography Image Storage");
  static const WKUid kLegacyConvertedEnhancedPETImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.128.1",
    "LegacyConvertedEnhancedPETImageStorage",
    UidType.kSOPClass,
    false,
    "Legacy Converted Enhanced PET Image Storage",
  );
  static const WKUid kStandalonePETCurveStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.129",
      "StandalonePETCurveStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone PET Curve Storage (Retired)");
  static const WKUid kEnhancedPETImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.130",
      "EnhancedPETImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced PET Image Storage");
  static const WKUid kBasicStructuredDisplayStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.131",
      "BasicStructuredDisplayStorage",
      UidType.kSOPClass,
      false,
      "Basic Structured Display Storage");
  static const WKUid kRTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.1",
      "RTImageStorage",
      UidType.kSOPClass,
      false,
      "RT Image Storage");
  static const WKUid kRTDoseStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.2",
      "RTDoseStorage",
      UidType.kSOPClass,
      false,
      "RT Dose Storage");
  static const WKUid kRTStructureSetStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.3",
      "RTStructureSetStorage",
      UidType.kSOPClass,
      false,
      "RT Structure Set Storage");
  static const WKUid kRTBeamsTreatmentRecordStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.4",
      "RTBeamsTreatmentRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Beams Treatment Record Storage");
  static const WKUid kRTPlanStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.5",
      "RTPlanStorage",
      UidType.kSOPClass,
      false,
      "RT Plan Storage");
  static const WKUid kRTBrachyTreatmentRecordStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.6",
      "RTBrachyTreatmentRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Brachy Treatment Record Storage");
  static const WKUid kRTTreatmentSummaryRecordStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.7",
      "RTTreatmentSummaryRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Treatment Summary Record Storage");
  static const WKUid kRTIonPlanStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.8",
      "RTIonPlanStorage",
      UidType.kSOPClass,
      false,
      "RT Ion Plan Storage");
  static const WKUid kRTIonBeamsTreatmentRecordStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.9",
      "RTIonBeamsTreatmentRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Ion Beams Treatment Record Storage");
  static const WKUid kDICOSCTImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.1",
    "DICOSCTImageStorage",
    UidType.kSOPClass,
    false,
    "DICOS CT Image Storage",
  );
  static const WKUid kDICOSDigitalX_RayImageStorage_ForPresentation =
      const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.2.1",
    "DICOSDigitalX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Presentation",
  );
  static const WKUid kDICOSDigitalX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.2.2",
    "DICOSDigitalX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Processing",
  );
  static const WKUid kDICOSThreatDetectionReportStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.3",
    "DICOSThreatDetectionReportStorage",
    UidType.kSOPClass,
    false,
    "DICOS Threat Detection Report Storage",
  );
  static const WKUid kDICOS2DAITStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.4",
    "DICOS2DAITStorage",
    UidType.kSOPClass,
    false,
    "DICOS 2D AIT Storage",
  );
  static const WKUid kDICOS3DAITStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.5",
    "DICOS3DAITStorage",
    UidType.kSOPClass,
    false,
    "DICOS 3D AIT Storage",
  );
  static const WKUid kDICOSQuadrupoleResonanceStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.6",
    "DICOSQuadrupoleResonanceStorage",
    UidType.kSOPClass,
    false,
    "DICOS Quadrupole Resonance (QR) Storage",
  );
  static const WKUid kEddyCurrentImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.601.1",
      "EddyCurrentImageStorage",
      UidType.kSOPClass,
      false,
      "Eddy Current Image Storage");
  static const WKUid kEddyCurrentMulti_frameImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.601.2",
      "EddyCurrentMulti_frameImageStorage",
      UidType.kSOPClass,
      false,
      "Eddy Current Multi-frame Image Storage");
  static const WKUid kPatientRootQueryRetrieveInformationModel_FIND =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.1",
    "PatientRootQueryRetrieveInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - FIND",
  );
  static const WKUid kPatientRootQueryRetrieveInformationModel_MOVE =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.2",
    "PatientRootQueryRetrieveInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - MOVE",
  );
  static const WKUid kPatientRootQueryRetrieveInformationModel_GET =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.3",
    "PatientRootQueryRetrieveInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - GET",
  );
  static const WKUid kStudyRootQueryRetrieveInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.1",
    "StudyRootQueryRetrieveInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - FIND",
  );
  static const WKUid kStudyRootQueryRetrieveInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.2",
    "StudyRootQueryRetrieveInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - MOVE",
  );
  static const WKUid kStudyRootQueryRetrieveInformationModel_GET = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.3",
    "StudyRootQueryRetrieveInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - GET",
  );
  static const WKUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.1",
    "Patient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
  );

  static const WKUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.2",
    "Patient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
  );

  static const WKUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.3",
    "Patient_StudyOnlyQueryRetrieveInformationModel_GET_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
  );

  static const WKUid kCompositeInstanceRootRetrieve_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.1.2.4.2",
      "CompositeInstanceRootRetrieve_MOVE",
      UidType.kSOPClass,
      false,
      "Composite Instance Root Retrieve - MOVE");
  static const WKUid kCompositeInstanceRootRetrieve_GET = const WKUid(
      "1.2.840.10008.5.1.4.1.2.4.3",
      "CompositeInstanceRootRetrieve_GET",
      UidType.kSOPClass,
      false,
      "Composite Instance Root Retrieve - GET");
  static const WKUid kCompositeInstanceRetrieveWithoutBulkData_GET =
      const WKUid(
    "1.2.840.10008.5.1.4.1.2.5.3",
    "CompositeInstanceRetrieveWithoutBulkData_GET",
    UidType.kSOPClass,
    false,
    "Composite Instance Retrieve Without Bulk Data - GET",
  );
  static const WKUid kModalityWorklistInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.31",
      "ModalityWorklistInformationModel_FIND",
      UidType.kSOPClass,
      false,
      "Modality Worklist Information Model - FIND");
  static const WKUid kGeneralPurposeWorklistInformationModel_FIND_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.32.1",
    "GeneralPurposeWorklistInformationModel_FIND_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Worklist Information Model - FIND (Retired)",
  );
  static const WKUid kGeneralPurposeScheduledProcedureStepSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.32.2",
    "GeneralPurposeScheduledProcedureStepSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Scheduled Procedure Step SOP Class (Retired)",
  );
  static const WKUid kGeneralPurposePerformedProcedureStepSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.32.3",
    "GeneralPurposePerformedProcedureStepSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Performed Procedure Step SOP Class (Retired)",
  );
  static const WKUid kGeneralPurposeWorklistManagementMetaSOPClass_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.32",
    "GeneralPurposeWorklistManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "General Purpose Worklist Management Meta SOP Class (Retired)",
  );
  static const WKUid kInstanceAvailabilityNotificationSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.33",
      "InstanceAvailabilityNotificationSOPClass",
      UidType.kSOPClass,
      false,
      "Instance Availability Notification SOP Class");
  static const WKUid kRTBeamsDeliveryInstructionStorage_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.1",
    "RTBeamsDeliveryInstructionStorage_Trial_Retired",
    UidType.kSOPClass,
    true,
    "RT Beams Delivery Instruction Storage - Trial (Retired)",
  );
  static const WKUid kRTConventionalMachineVerification_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.2",
    "RTConventionalMachineVerification_Trial_Retired",
    UidType.kSOPClass,
    true,
    "RT Conventional Machine Verification - Trial (Retired)",
  );
  static const WKUid kRTIonMachineVerification_Trial_Retired = const WKUid(
      "1.2.840.10008.5.1.4.34.3",
      "RTIonMachineVerification_Trial_Retired",
      UidType.kSOPClass,
      true,
      "RT Ion Machine Verification - Trial (Retired)");
  static const WKUid
      kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4",
    "UnifiedWorklistandProcedureStepServiceClass_Trial_Retired",
    UidType.kServiceClass,
    true,
    "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
  );
  static const WKUid kUnifiedProcedureStep_PushSOPClass_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.4.1",
    "UnifiedProcedureStep_PushSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Push SOP Class - Trial (Retired)",
  );
  static const WKUid kUnifiedProcedureStep_WatchSOPClass_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.4.2",
    "UnifiedProcedureStep_WatchSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
  );
  static const WKUid kUnifiedProcedureStep_PullSOPClass_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.4.3",
    "UnifiedProcedureStep_PullSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
  );
  static const WKUid kUnifiedProcedureStep_EventSOPClass_Trial_Retired =
      const WKUid(
    "1.2.840.10008.5.1.4.34.4.4",
    "UnifiedProcedureStep_EventSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Event SOP Class - Trial (Retired)",
  );
  static const WKUid kUnifiedWorklistandProcedureStepSOPInstance = const WKUid(
      "1.2.840.10008.5.1.4.34.5",
      "UnifiedWorklistandProcedureStepSOPInstance",
      UidType.kWellKnownSOPInstance,
      false,
      "Unified Worklist and Procedure Step SOP Instance");
  static const WKUid kUnifiedWorklistandProcedureStepServiceClass = const WKUid(
    "1.2.840.10008.5.1.4.34.6",
    "UnifiedWorklistandProcedureStepServiceClass",
    UidType.kServiceClass,
    false,
    "Unified Worklist and Procedure Step Service Class",
  );
  static const WKUid kUnifiedProcedureStep_PushSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.34.6.1",
      "UnifiedProcedureStep_PushSOPClass",
      UidType.kSOPClass,
      false,
      "Unified Procedure Step - Push SOP Class");
  static const WKUid kUnifiedProcedureStep_WatchSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.34.6.2",
      "UnifiedProcedureStep_WatchSOPClass",
      UidType.kSOPClass,
      false,
      "Unified Procedure Step - Watch SOP Class");
  static const WKUid kUnifiedProcedureStep_PullSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.34.6.3",
      "UnifiedProcedureStep_PullSOPClass",
      UidType.kSOPClass,
      false,
      "Unified Procedure Step - Pull SOP Class");
  static const WKUid kUnifiedProcedureStep_EventSOPClass = const WKUid(
      "1.2.840.10008.5.1.4.34.6.4",
      "UnifiedProcedureStep_EventSOPClass",
      UidType.kSOPClass,
      false,
      "Unified Procedure Step - Event SOP Class");
  static const WKUid kRTBeamsDeliveryInstructionStorage = const WKUid(
      "1.2.840.10008.5.1.4.34.7",
      "RTBeamsDeliveryInstructionStorage",
      UidType.kSOPClass,
      false,
      "RT Beams Delivery Instruction Storage");
  static const WKUid kRTConventionalMachineVerification = const WKUid(
      "1.2.840.10008.5.1.4.34.8",
      "RTConventionalMachineVerification",
      UidType.kSOPClass,
      false,
      "RT Conventional Machine Verification");
  static const WKUid kRTIonMachineVerification = const WKUid(
      "1.2.840.10008.5.1.4.34.9",
      "RTIonMachineVerification",
      UidType.kSOPClass,
      false,
      "RT Ion Machine Verification");
  static const WKUid kGeneralRelevantPatientInformationQuery = const WKUid(
      "1.2.840.10008.5.1.4.37.1",
      "GeneralRelevantPatientInformationQuery",
      UidType.kSOPClass,
      false,
      "General Relevant Patient Information Query");
  static const WKUid kBreastImagingRelevantPatientInformationQuery =
      const WKUid(
    "1.2.840.10008.5.1.4.37.2",
    "BreastImagingRelevantPatientInformationQuery",
    UidType.kSOPClass,
    false,
    "Breast Imaging Relevant Patient Information Query",
  );
  static const WKUid kCardiacRelevantPatientInformationQuery = const WKUid(
      "1.2.840.10008.5.1.4.37.3",
      "CardiacRelevantPatientInformationQuery",
      UidType.kSOPClass,
      false,
      "Cardiac Relevant Patient Information Query");
  static const WKUid kHangingProtocolStorage = const WKUid(
      "1.2.840.10008.5.1.4.38.1",
      "HangingProtocolStorage",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Storage");
  static const WKUid kHangingProtocolInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.38.2",
      "HangingProtocolInformationModel_FIND",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Information Model - FIND");
  static const WKUid kHangingProtocolInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.38.3",
      "HangingProtocolInformationModel_MOVE",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Information Model - MOVE");
  static const WKUid kHangingProtocolInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.38.4",
      "HangingProtocolInformationModel_GET",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Information Model - GET");
  static const WKUid kColorPaletteStorage = const WKUid(
      "1.2.840.10008.5.1.4.39.1",
      "ColorPaletteStorage",
      UidType.kTransfer,
      false,
      "Color Palette Storage");
  static const WKUid kColorPaletteInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.39.2",
      "ColorPaletteInformationModel_FIND",
      UidType.kQueryRetrieve,
      false,
      "Color Palette Information Model - FIND");
  static const WKUid kColorPaletteInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.39.3",
      "ColorPaletteInformationModel_MOVE",
      UidType.kQueryRetrieve,
      false,
      "Color Palette Information Model - MOVE");
  static const WKUid kColorPaletteInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.39.4",
      "ColorPaletteInformationModel_GET",
      UidType.kQueryRetrieve,
      false,
      "Color Palette Information Model - GET");
  static const WKUid kProductCharacteristicsQuerySOPClass = const WKUid(
      "1.2.840.10008.5.1.4.41",
      "ProductCharacteristicsQuerySOPClass",
      UidType.kSOPClass,
      false,
      "Product Characteristics Query SOP Class");
  static const WKUid kSubstanceApprovalQuerySOPClass = const WKUid(
      "1.2.840.10008.5.1.4.42",
      "SubstanceApprovalQuerySOPClass",
      UidType.kSOPClass,
      false,
      "Substance Approval Query SOP Class");
  static const WKUid kGenericImplantTemplateStorage = const WKUid(
      "1.2.840.10008.5.1.4.43.1",
      "GenericImplantTemplateStorage",
      UidType.kSOPClass,
      false,
      "Generic Implant Template Storage");
  static const WKUid kGenericImplantTemplateInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.43.2",
    "GenericImplantTemplateInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - FIND",
  );
  static const WKUid kGenericImplantTemplateInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.43.3",
    "GenericImplantTemplateInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - MOVE",
  );
  static const WKUid kGenericImplantTemplateInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.43.4",
      "GenericImplantTemplateInformationModel_GET",
      UidType.kSOPClass,
      false,
      "Generic Implant Template Information Model - GET");
  static const WKUid kImplantAssemblyTemplateStorage = const WKUid(
      "1.2.840.10008.5.1.4.44.1",
      "ImplantAssemblyTemplateStorage",
      UidType.kSOPClass,
      false,
      "Implant Assembly Template Storage");
  static const WKUid kImplantAssemblyTemplateInformationModel_FIND =
      const WKUid(
    "1.2.840.10008.5.1.4.44.2",
    "ImplantAssemblyTemplateInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - FIND",
  );
  static const WKUid kImplantAssemblyTemplateInformationModel_MOVE =
      const WKUid(
    "1.2.840.10008.5.1.4.44.3",
    "ImplantAssemblyTemplateInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - MOVE",
  );
  static const WKUid kImplantAssemblyTemplateInformationModel_GET = const WKUid(
    "1.2.840.10008.5.1.4.44.4",
    "ImplantAssemblyTemplateInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - GET",
  );
  static const WKUid kImplantTemplateGroupStorage = const WKUid(
      "1.2.840.10008.5.1.4.45.1",
      "ImplantTemplateGroupStorage",
      UidType.kSOPClass,
      false,
      "Implant Template Group Storage");
  static const WKUid kImplantTemplateGroupInformationModel_FIND = const WKUid(
      "1.2.840.10008.5.1.4.45.2",
      "ImplantTemplateGroupInformationModel_FIND",
      UidType.kSOPClass,
      false,
      "Implant Template Group Information Model - FIND");
  static const WKUid kImplantTemplateGroupInformationModel_MOVE = const WKUid(
      "1.2.840.10008.5.1.4.45.3",
      "ImplantTemplateGroupInformationModel_MOVE",
      UidType.kSOPClass,
      false,
      "Implant Template Group Information Model - MOVE");
  static const WKUid kImplantTemplateGroupInformationModel_GET = const WKUid(
      "1.2.840.10008.5.1.4.45.4",
      "ImplantTemplateGroupInformationModel_GET",
      UidType.kSOPClass,
      false,
      "Implant Template Group Information Model - GET");
  static const WKUid kNativeDICOMModel = const WKUid(
      "1.2.840.10008.7.1.1",
      "NativeDICOMModel",
      UidType.kApplicationHostingModel,
      false,
      "Native DICOM Model");
  static const WKUid kAbstractMulti_DimensionalImageModel = const WKUid(
      "1.2.840.10008.7.1.2",
      "AbstractMulti_DimensionalImageModel",
      UidType.kApplicationHostingModel,
      false,
      "Abstract Multi-Dimensional Image Model");
  static const WKUid kdicomDeviceName = const WKUid("1.2.840.10008.15.0.3.1",
      "dicomDeviceName", UidType.kLdapOid, false, "dicomDeviceName");
  static const WKUid kdicomDescription = const WKUid("1.2.840.10008.15.0.3.2",
      "dicomDescription", UidType.kLdapOid, false, "dicomDescription");
  static const WKUid kdicomManufacturer = const WKUid("1.2.840.10008.15.0.3.3",
      "dicomManufacturer", UidType.kLdapOid, false, "dicomManufacturer");
  static const WKUid kdicomManufacturerModelName = const WKUid(
      "1.2.840.10008.15.0.3.4",
      "dicomManufacturerModelName",
      UidType.kLdapOid,
      false,
      "dicomManufacturerModelName");
  static const WKUid kdicomSoftwareVersion = const WKUid(
      "1.2.840.10008.15.0.3.5",
      "dicomSoftwareVersion",
      UidType.kLdapOid,
      false,
      "dicomSoftwareVersion");
  static const WKUid kdicomVendorData = const WKUid("1.2.840.10008.15.0.3.6",
      "dicomVendorData", UidType.kLdapOid, false, "dicomVendorData");
  static const WKUid kdicomAETitle = const WKUid("1.2.840.10008.15.0.3.7",
      "dicomAETitle", UidType.kLdapOid, false, "dicomAETitle");
  static const WKUid kdicomNetworkConnectionReference = const WKUid(
      "1.2.840.10008.15.0.3.8",
      "dicomNetworkConnectionReference",
      UidType.kLdapOid,
      false,
      "dicomNetworkConnectionReference");
  static const WKUid kdicomApplicationCluster = const WKUid(
      "1.2.840.10008.15.0.3.9",
      "dicomApplicationCluster",
      UidType.kLdapOid,
      false,
      "dicomApplicationCluster");
  static const WKUid kdicomAssociationInitiator = const WKUid(
      "1.2.840.10008.15.0.3.10",
      "dicomAssociationInitiator",
      UidType.kLdapOid,
      false,
      "dicomAssociationInitiator");
  static const WKUid kdicomAssociationAcceptor = const WKUid(
      "1.2.840.10008.15.0.3.11",
      "dicomAssociationAcceptor",
      UidType.kLdapOid,
      false,
      "dicomAssociationAcceptor");
  static const WKUid kdicomHostname = const WKUid("1.2.840.10008.15.0.3.12",
      "dicomHostname", UidType.kLdapOid, false, "dicomHostname");
  static const WKUid kdicomPort = const WKUid("1.2.840.10008.15.0.3.13",
      "dicomPort", UidType.kLdapOid, false, "dicomPort");
  static const WKUid kdicomSOPClass = const WKUid("1.2.840.10008.15.0.3.14",
      "dicomSOPClass", UidType.kLdapOid, false, "dicomSOPClass");
  static const WKUid kdicomTransferRole = const WKUid("1.2.840.10008.15.0.3.15",
      "dicomTransferRole", UidType.kLdapOid, false, "dicomTransferRole");
  static const WKUid kdicomTransferSyntax = const WKUid(
      "1.2.840.10008.15.0.3.16",
      "dicomTransferSyntax",
      UidType.kLdapOid,
      false,
      "dicomTransferSyntax");
  static const WKUid kdicomPrimaryDeviceType = const WKUid(
      "1.2.840.10008.15.0.3.17",
      "dicomPrimaryDeviceType",
      UidType.kLdapOid,
      false,
      "dicomPrimaryDeviceType");
  static const WKUid kdicomRelatedDeviceReference = const WKUid(
      "1.2.840.10008.15.0.3.18",
      "dicomRelatedDeviceReference",
      UidType.kLdapOid,
      false,
      "dicomRelatedDeviceReference");
  static const WKUid kdicomPreferredCalledAETitle = const WKUid(
      "1.2.840.10008.15.0.3.19",
      "dicomPreferredCalledAETitle",
      UidType.kLdapOid,
      false,
      "dicomPreferredCalledAETitle");
  static const WKUid kdicomTLSCyphersuite = const WKUid(
      "1.2.840.10008.15.0.3.20",
      "dicomTLSCyphersuite",
      UidType.kLdapOid,
      false,
      "dicomTLSCyphersuite");
  static const WKUid kdicomAuthorizedNodeCertificateReference = const WKUid(
      "1.2.840.10008.15.0.3.21",
      "dicomAuthorizedNodeCertificateReference",
      UidType.kLdapOid,
      false,
      "dicomAuthorizedNodeCertificateReference");
  static const WKUid kdicomThisNodeCertificateReference = const WKUid(
      "1.2.840.10008.15.0.3.22",
      "dicomThisNodeCertificateReference",
      UidType.kLdapOid,
      false,
      "dicomThisNodeCertificateReference");
  static const WKUid kdicomInstalled = const WKUid("1.2.840.10008.15.0.3.23",
      "dicomInstalled", UidType.kLdapOid, false, "dicomInstalled");
  static const WKUid kdicomStationName = const WKUid("1.2.840.10008.15.0.3.24",
      "dicomStationName", UidType.kLdapOid, false, "dicomStationName");
  static const WKUid kdicomDeviceSerialNumber = const WKUid(
      "1.2.840.10008.15.0.3.25",
      "dicomDeviceSerialNumber",
      UidType.kLdapOid,
      false,
      "dicomDeviceSerialNumber");
  static const WKUid kdicomInstitutionName = const WKUid(
      "1.2.840.10008.15.0.3.26",
      "dicomInstitutionName",
      UidType.kLdapOid,
      false,
      "dicomInstitutionName");
  static const WKUid kdicomInstitutionAddress = const WKUid(
      "1.2.840.10008.15.0.3.27",
      "dicomInstitutionAddress",
      UidType.kLdapOid,
      false,
      "dicomInstitutionAddress");
  static const WKUid kdicomInstitutionDepartmentName = const WKUid(
      "1.2.840.10008.15.0.3.28",
      "dicomInstitutionDepartmentName",
      UidType.kLdapOid,
      false,
      "dicomInstitutionDepartmentName");
  static const WKUid kdicomIssuerOfPatientID = const WKUid(
      "1.2.840.10008.15.0.3.29",
      "dicomIssuerOfPatientID",
      UidType.kLdapOid,
      false,
      "dicomIssuerOfPatientID");
  static const WKUid kdicomPreferredCallingAETitle = const WKUid(
      "1.2.840.10008.15.0.3.30",
      "dicomPreferredCallingAETitle",
      UidType.kLdapOid,
      false,
      "dicomPreferredCallingAETitle");
  static const WKUid kdicomSupportedCharacterSet = const WKUid(
      "1.2.840.10008.15.0.3.31",
      "dicomSupportedCharacterSet",
      UidType.kLdapOid,
      false,
      "dicomSupportedCharacterSet");
  static const WKUid kdicomConfigurationRoot = const WKUid(
      "1.2.840.10008.15.0.4.1",
      "dicomConfigurationRoot",
      UidType.kLdapOid,
      false,
      "dicomConfigurationRoot");
  static const WKUid kdicomDevicesRoot = const WKUid("1.2.840.10008.15.0.4.2",
      "dicomDevicesRoot", UidType.kLdapOid, false, "dicomDevicesRoot");
  static const WKUid kdicomUniqueAETitlesRegistryRoot = const WKUid(
      "1.2.840.10008.15.0.4.3",
      "dicomUniqueAETitlesRegistryRoot",
      UidType.kLdapOid,
      false,
      "dicomUniqueAETitlesRegistryRoot");
  static const WKUid kdicomDevice = const WKUid("1.2.840.10008.15.0.4.4",
      "dicomDevice", UidType.kLdapOid, false, "dicomDevice");
  static const WKUid kdicomNetworkAE = const WKUid("1.2.840.10008.15.0.4.5",
      "dicomNetworkAE", UidType.kLdapOid, false, "dicomNetworkAE");
  static const WKUid kdicomNetworkConnection = const WKUid(
      "1.2.840.10008.15.0.4.6",
      "dicomNetworkConnection",
      UidType.kLdapOid,
      false,
      "dicomNetworkConnection");
  static const WKUid kdicomUniqueAETitle = const WKUid("1.2.840.10008.15.0.4.7",
      "dicomUniqueAETitle", UidType.kLdapOid, false, "dicomUniqueAETitle");
  static const WKUid kdicomTransferCapability = const WKUid(
      "1.2.840.10008.15.0.4.8",
      "dicomTransferCapability",
      UidType.kLdapOid,
      false,
      "dicomTransferCapability");
  static const WKUid kUniversalCoordinatedTime = const WKUid(
      "1.2.840.10008.15.1.1",
      "UniversalCoordinatedTime",
      UidType.kSynchronizationFrameOfReference,
      false,
      "Universal Coordinated Time");
}
