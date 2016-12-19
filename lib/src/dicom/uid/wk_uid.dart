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

  const WKUid(String uid, this.type, this.isRetired, this.name) : super.constant(uid);

  //static fromString(String s) => stringToUidMap[validate(s)];

  String debug() => "UID: $string (type=$type, name=$name)";

  bool get isNotRetired => !isRetired;

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
      const WKUid("1.2.840.10008.1.1", WKUidType.kSopClass, false, "Verification SOP Class");
  static const kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM = const WKUid(
    "1.2.840.10008.1.2",
    WKUidType.kTransferSyntax,
    false,
    "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
  );

  static const kExplicitVRLittleEndian = const WKUid(
      "1.2.840.10008.1.2.1", WKUidType.kTransferSyntax, false, "Explicit VR Little Endian");
  static const kDeflatedExplicitVRLittleEndian = const WKUid("1.2.840.10008.1.2.1.99",
      WKUidType.kTransferSyntax, false, "Deflated Explicit VR Little Endian");
  static const kExplicitVRBigEndian_Retired = const WKUid(
      "1.2.840.10008.1.2.2", WKUidType.kTransferSyntax, true, "Explicit VR Big Endian (Retired)");
  static const kJPEGBaseline_1 = const WKUid(
    "1.2.840.10008.1.2.4.50",
    WKUidType.kTransferSyntax,
    false,
    "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy JPEG 8 Bit Image Compression",
  );
  static const kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 =
      const WKUid(
    "1.2.840.10008.1.2.4.51",
    WKUidType.kTransferSyntax,
    false,
    "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for Lossy JPEG 12 Bit Image Compression (Process 4 only)",
  );
  static const kJPEGExtended_3_5_Retired = const WKUid("1.2.840.10008.1.2.4.52",
      WKUidType.kTransferSyntax, true, "JPEG Extended (Process 3 & 5) (Retired)");
  static const kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired = const WKUid(
    "1.2.840.10008.1.2.4.53",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
  );
  static const kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired = const WKUid(
    "1.2.840.10008.1.2.4.54",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
  );
  static const kJPEGFullProgressionNon_Hierarchical_10_12_Retired = const WKUid(
    "1.2.840.10008.1.2.4.55",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
  );
  static const kJPEGFullProgressionNon_Hierarchical_11_13_Retired = const WKUid(
    "1.2.840.10008.1.2.4.56",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
  );
  static const kJPEGLosslessNon_Hierarchical_14 = const WKUid("1.2.840.10008.1.2.4.57",
      WKUidType.kTransferSyntax, false, "JPEG Lossless, Non-Hierarchical (Process 14)");
  static const kJPEGLosslessNon_Hierarchical_15_Retired = const WKUid(
    "1.2.840.10008.1.2.4.58",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
  );
  static const kJPEGExtendedHierarchical_16_18_Retired = const WKUid(
    "1.2.840.10008.1.2.4.59",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
  );
  static const kJPEGExtendedHierarchical_17_19_Retired = const WKUid(
    "1.2.840.10008.1.2.4.60",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
  );
  static const kJPEGSpectralSelectionHierarchical_20_22_Retired = const WKUid(
    "1.2.840.10008.1.2.4.61",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
  );
  static const kJPEGSpectralSelectionHierarchical_21_23_Retired = const WKUid(
    "1.2.840.10008.1.2.4.62",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
  );
  static const kJPEGFullProgressionHierarchical_24_26_Retired = const WKUid(
    "1.2.840.10008.1.2.4.63",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
  );
  static const kJPEGFullProgressionHierarchical_25_27_Retired = const WKUid(
    "1.2.840.10008.1.2.4.64",
    WKUidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
  );
  static const kJPEGLosslessHierarchical_28_Retired = const WKUid("1.2.840.10008.1.2.4.65",
      WKUidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 28) (Retired)");
  static const kJPEGLosslessHierarchical_29_Retired = const WKUid("1.2.840.10008.1.2.4.66",
      WKUidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 29) (Retired)");
  static const kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
      const WKUid(
    "1.2.840.10008.1.2.4.70",
    WKUidType.kTransferSyntax,
    false,
    "JPEG Lossless, Non-Hierarchical, First-Order Prediction (Process 14 [Selection Value 1]) : Default Transfer Syntax for Lossless JPEG Image Compression",
  );
  static const kJPEG_LSLosslessImageCompression = const WKUid("1.2.840.10008.1.2.4.80",
      WKUidType.kTransferSyntax, false, "JPEG-LS Lossless Image Compression");
  static const kJPEG_LSLossyImageCompression = const WKUid("1.2.840.10008.1.2.4.81",
      WKUidType.kTransferSyntax, false, "JPEG-LS Lossy (Near-Lossless) Image Compression");
  static const kJPEG2000ImageCompressionLosslessOnly = const WKUid("1.2.840.10008.1.2.4.90",
      WKUidType.kTransferSyntax, false, "JPEG 2000 Image Compression Lossless Only");
  static const kJPEG2000ImageCompression = const WKUid(
      "1.2.840.10008.1.2.4.91", WKUidType.kTransferSyntax, false, "JPEG 2000 Image Compression");
  static const kJPEG2000Part2Multi_componentImageCompressionLosslessOnly = const WKUid(
    "1.2.840.10008.1.2.4.92",
    WKUidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
  );
  static const kJPEG2000Part2Multi_componentImageCompression = const WKUid(
    "1.2.840.10008.1.2.4.93",
    WKUidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression",
  );
  static const kJPIPReferenced =
      const WKUid("1.2.840.10008.1.2.4.94", WKUidType.kTransferSyntax, false, "JPIP Referenced");
  static const kJPIPReferencedDeflate = const WKUid(
      "1.2.840.10008.1.2.4.95", WKUidType.kTransferSyntax, false, "JPIP Referenced Deflate");
  static const kMPEG2MainProfile_MainLevel = const WKUid("1.2.840.10008.1.2.4.100",
      WKUidType.kTransferSyntax, false, "MPEG2 Main Profile @ Main Level");
  static const kMPEG2MainProfile_HighLevel = const WKUid("1.2.840.10008.1.2.4.101",
      WKUidType.kTransferSyntax, false, "MPEG2 Main Profile @ High Level");
  static const kMPEG_4AVC_H264HighProfile_Level41 = const WKUid("1.2.840.10008.1.2.4.102",
      WKUidType.kTransferSyntax, false, "MPEG-4 AVC/H.264 High Profile / Level 4.1");
  static const kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 = const WKUid(
    "1.2.840.10008.1.2.4.103",
    WKUidType.kTransferSyntax,
    false,
    "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
  );
  static const kRLELossless =
      const WKUid("1.2.840.10008.1.2.5", WKUidType.kTransferSyntax, false, "RLE Lossless");
  static const kRFC2557MIMEencapsulation = const WKUid(
      "1.2.840.10008.1.2.6.1", WKUidType.kTransferSyntax, false, "RFC 2557 MIME encapsulation");
  static const kXMLEncoding =
      const WKUid("1.2.840.10008.1.2.6.2", WKUidType.kTransferSyntax, false, "XML Encoding");
  static const kMediaStorageDirectoryStorage = const WKUid(
      "1.2.840.10008.1.3.10", WKUidType.kSopClass, false, "Media Storage Directory Storage");
  static const kTalairachBrainAtlasFrameofReference = const WKUid("1.2.840.10008.1.4.1.1",
      WKUidType.kFrameOfReference, false, "Talairach Brain Atlas Frame of Reference");
  static const kSPM2T1FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.2", WKUidType.kFrameOfReference, false, "SPM2 T1 Frame of Reference");
  static const kSPM2T2FrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.3", WKUidType.kFrameOfReference, false, "SPM2 T2 Frame of Reference");
  static const kSPM2PDFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.4", WKUidType.kFrameOfReference, false, "SPM2 PD Frame of Reference");
  static const kSPM2EPIFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.5", WKUidType.kFrameOfReference, false, "SPM2 EPI Frame of Reference");
  static const kSPM2FILT1FrameofReference = const WKUid("1.2.840.10008.1.4.1.6",
      WKUidType.kFrameOfReference, false, "SPM2 FIL T1 Frame of Reference");
  static const kSPM2PETFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.7", WKUidType.kFrameOfReference, false, "SPM2 PET Frame of Reference");
  static const kSPM2TRANSMFrameofReference = const WKUid("1.2.840.10008.1.4.1.8",
      WKUidType.kFrameOfReference, false, "SPM2 TRANSM Frame of Reference");
  static const kSPM2SPECTFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.9", WKUidType.kFrameOfReference, false, "SPM2 SPECT Frame of Reference");
  static const kSPM2GRAYFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.10", WKUidType.kFrameOfReference, false, "SPM2 GRAY Frame of Reference");
  static const kSPM2WHITEFrameofReference = const WKUid("1.2.840.10008.1.4.1.11",
      WKUidType.kFrameOfReference, false, "SPM2 WHITE Frame of Reference");
  static const kSPM2CSFFrameofReference = const WKUid(
      "1.2.840.10008.1.4.1.12", WKUidType.kFrameOfReference, false, "SPM2 CSF Frame of Reference");
  static const kSPM2BRAINMASKFrameofReference = const WKUid("1.2.840.10008.1.4.1.13",
      WKUidType.kFrameOfReference, false, "SPM2 BRAINMASK Frame of Reference");
  static const kSPM2AVG305T1FrameofReference = const WKUid("1.2.840.10008.1.4.1.14",
      WKUidType.kFrameOfReference, false, "SPM2 AVG305T1 Frame of Reference");
  static const kSPM2AVG152T1FrameofReference = const WKUid("1.2.840.10008.1.4.1.15",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152T1 Frame of Reference");
  static const kSPM2AVG152T2FrameofReference = const WKUid("1.2.840.10008.1.4.1.16",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152T2 Frame of Reference");
  static const kSPM2AVG152PDFrameofReference = const WKUid("1.2.840.10008.1.4.1.17",
      WKUidType.kFrameOfReference, false, "SPM2 AVG152PD Frame of Reference");
  static const kSPM2SINGLESUBJT1FrameofReference = const WKUid("1.2.840.10008.1.4.1.18",
      WKUidType.kFrameOfReference, false, "SPM2 SINGLESUBJT1 Frame of Reference");
  static const kICBM452T1FrameofReference = const WKUid("1.2.840.10008.1.4.2.1",
      WKUidType.kFrameOfReference, false, "ICBM 452 T1 Frame of Reference");
  static const kICBMSingleSubjectMRIFrameofReference = const WKUid("1.2.840.10008.1.4.2.2",
      WKUidType.kFrameOfReference, false, "ICBM Single Subject MRI Frame of Reference");
  static const kHotIronColorPaletteSOPInstance = const WKUid(
    "1.2.840.10008.1.5.1",
    WKUidType.kColorPalette,
    false,
    "Hot Iron Color Palette SOP "
        "Instance",
  );
  static const kPETColorPaletteSOPInstance = const WKUid(
      "1.2.840.10008.1.5.2", WKUidType.kColorPalette, false, "PET Color Palette SOP Instance");
  static const kHotMetalBlueColorPaletteSOPInstance = const WKUid("1.2.840.10008.1.5.3",
      WKUidType.kColorPalette, false, "Hot Metal Blue Color Palette SOP Instance");
  static const kPET20StepColorPaletteSOPInstance = const WKUid("1.2.840.10008.1.5.4",
      WKUidType.kSopInstance, false, "PET 20 Step Color Palette SOP Instance");
  static const kBasicStudyContentNotificationSOPClass_Retired = const WKUid("1.2.840.10008.1.9",
      WKUidType.kSopClass, true, "Basic Study Content Notification SOP Class (Retired)");
  static const kStorageCommitmentPushModelSOPClass = const WKUid(
      "1.2.840.10008.1.20.1", WKUidType.kSopClass, true, "Storage Commitment Push Model SOP Class");
  static const kStorageCommitmentPushModelSOPInstance = const WKUid("1.2.840.10008.1.20.1.1",
      WKUidType.kSopInstance, false, "Storage Commitment Push Model SOP Instance");
  static const kStorageCommitmentPullModelSOPClass_Retired = const WKUid("1.2.840.10008.1.20.2",
      WKUidType.kSopClass, true, "Storage Commitment Pull Model SOP Class (Retired)");
  static const kStorageCommitmentPullModelSOPInstance_Retired = const WKUid(
    "1.2.840.10008.1.20.2.1",
    WKUidType.kSopInstance,
    true,
    "Storage Commitment Pull Model SOP Instance (Retired)",
  );
  static const kProceduralEventLoggingSOPClass = const WKUid(
      "1.2.840.10008.1.40", WKUidType.kSopClass, false, "Procedural Event Logging SOP Class");
  static const kProceduralEventLoggingSOPInstance = const WKUid("1.2.840.10008.1.40.1",
      WKUidType.kSopInstance, false, "Procedural Event Logging SOP Instance");
  static const kSubstanceAdministrationLoggingSOPClass = const WKUid("1.2.840.10008.1.42",
      WKUidType.kSopClass, false, "Substance Administration Logging SOP Class");
  static const kSubstanceAdministrationLoggingSOPInstance = const WKUid("1.2.840.10008.1.42.1",
      WKUidType.kSopInstance, false, "Substance Administration Logging SOP Instance");
  static const kDICOMUIDRegistry =
      const WKUid("1.2.840.10008.2.6.1", WKUidType.kDicomCodingScheme, false, "DICOM UID Registry");
  static const kDICOMControlledTerminology = const WKUid(
    "1.2.840.10008.2.16.4",
    WKUidType.kCodingScheme,
    false,
    "DICOM Controlled Terminology",
  );
  static const kDICOMApplicationContextName = const WKUid(
    "1.2.840.10008.3.1.1.1",
    WKUidType.kApplicationContextName,
    false,
    "DICOM Application Context Name",
  );
  static const kDetachedPatientManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.1.1",
      WKUidType.kSopClass, true, "Detached Patient Management SOP Class (Retired)");
  static const kDetachedPatientManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.3.1.2.1.4",
    WKUidType.kMetaSopClass,
    true,
    "Detached Patient Management Meta SOP Class (Retired)",
  );
  static const kDetachedVisitManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.2.1",
      WKUidType.kSopClass, true, "Detached Visit Management SOP Class (Retired)");
  static const kDetachedStudyManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.3.1",
      WKUidType.kSopClass, true, "Detached Study Management SOP Class (Retired)");
  static const kStudyComponentManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.3.2",
      WKUidType.kSopClass, true, "Study Component Management SOP Class (Retired)");
  static const kModalityPerformedProcedureStepSOPClass = const WKUid("1.­2.840.10008.3.1.2.3.3",
      WKUidType.kSopClass, false, "Modality Performed Procedure Step SOP Class");
  static const kModalityPerformedProcedureStepRetrieveSOPClass = const WKUid(
    "1.­2.840.10008.3.1.2.3.4",
    WKUidType.kSopClass,
    false,
    "Modality Performed Procedure Step Retrieve SOP Class",
  );
  static const kModalityPerformedProcedureStepNotificationSOPClass = const WKUid(
    "1.­2.840.10008.3.1.2.3.5",
    WKUidType.kSopClass,
    false,
    "Modality Performed Procedure Step Notification SOP Class",
  );
  static const kDetachedResultsManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.5.1",
      WKUidType.kSopClass, true, "Detached Results Management SOP Class (Retired)");
  static const kDetachedResultsManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.3.1.2.5.4",
    WKUidType.kMetaSopClass,
    true,
    "Detached Results Management Meta SOP Class (Retired)",
  );
  static const kDetachedStudyManagementMetaSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.5.5",
      WKUidType.kMetaSopClass, true, "Detached Study Management Meta SOP Class (Retired)");
  static const kDetachedInterpretationManagementSOPClass_Retired = const WKUid(
    "1.2.840.10008.3.1.2.6.1",
    WKUidType.kSopClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );
  static const kStorageServiceClass =
      const WKUid("1.2.840.10008.4.2", WKUidType.kServiceClass, false, "Storage Service Class");
  static const kBasicFilmSessionSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.1", WKUidType.kSopClass, false, "Basic Film Session SOP Class");
  static const kBasicFilmBoxSOPClass =
      const WKUid("1.2.840.10008.5.1.1.2", WKUidType.kSopClass, false, "Basic Film Box SOP Class");
  static const kBasicGrayscaleImageBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.4", WKUidType.kSopClass, false, "Basic Grayscale Image Box SOP Class");
  static const kBasicColorImageBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.4.1", WKUidType.kSopClass, false, "Basic Color Image Box SOP Class");
  static const kReferencedImageBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.4.2",
      WKUidType.kSopClass, true, "Referenced Image Box SOP Class (Retired)");
  static const kBasicGrayscalePrintManagementMetaSOPClass = const WKUid("1.2.840.10008.5.1.1.9",
      WKUidType.kMetaSopClass, false, "Basic Grayscale Print Management Meta SOP Class");
  static const kReferencedGrayscalePrintManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.1.9.1",
    WKUidType.kMetaSopClass,
    true,
    "Referenced Grayscale Print Management Meta SOP Class (Retired)",
  );
  static const kPrintJobSOPClass =
      const WKUid("1.2.840.10008.5.1.1.14", WKUidType.kSopClass, false, "Print Job SOP Class");
  static const kBasicAnnotationBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.15", WKUidType.kSopClass, false, "Basic Annotation Box SOP Class");
  static const kPrinterSOPClass =
      const WKUid("1.2.840.10008.5.1.1.16", WKUidType.kSopClass, false, "Printer SOP Class");
  static const kPrinterConfigurationRetrievalSOPClass = const WKUid("1.2.840.10008.5.1.1.16.376",
      WKUidType.kSopClass, false, "Printer Configuration Retrieval SOP Class");
  static const kPrinterSOPInstance = const WKUid(
      "1.2.840.10008.5.1.1.17", WKUidType.kPrinterSopInstance, false, "Printer SOP Instance");
  static const kPrinterConfigurationRetrievalSOPInstance = const WKUid("1.2.840.10008.5.1.1.17.376",
      WKUidType.kPrinterSopInstance, false, "Printer Configuration Retrieval SOP Instance");
  static const kBasicColorPrintManagementMetaSOPClass = const WKUid("1.2.840.10008.5.1.1.18",
      WKUidType.kMetaSopClass, false, "Basic Color Print Management Meta SOP Class");
  static const kReferencedColorPrintManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.1.18.1",
    WKUidType.kMetaSopClass,
    true,
    "Referenced Color Print Management Meta SOP Class (Retired)",
  );
  static const kVOILUTBoxSOPClass =
      const WKUid("1.2.840.10008.5.1.1.22", WKUidType.kSopClass, false, "VOI LUT Box SOP Class");
  static const kPresentationLUTSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.23", WKUidType.kSopClass, false, "Presentation LUT SOP Class");
  static const kImageOverlayBoxSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.24", WKUidType.kSopClass, true, "Image Overlay Box SOP Class (Retired)");
  static const kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24.1",
      WKUidType.kSopClass, true, "Basic Print Image Overlay Box SOP Class (Retired)");
  static const kPrintQueueSOPInstance_Retired = const WKUid("1.2.840.10008.5.1.1.25",
      WKUidType.kPrintQueueSopInstance, true, "Print Queue SOP Instance (Retired)");
  static const kPrintQueueManagementSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.26",
      WKUidType.kSopClass, true, "Print Queue Management SOP Class (Retired)");
  static const kStoredPrintStorageSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.27",
      WKUidType.kSopClass, true, "Stored Print Storage SOP Class (Retired)");
  static const kHardcopyGrayscaleImageStorageSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.1.29",
    WKUidType.kSopClass,
    true,
    "Hardcopy Grayscale Image Storage SOP Class (Retired)",
  );
  static const kHardcopyColorImageStorageSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.30",
      WKUidType.kSopClass, true, "Hardcopy Color Image Storage SOP Class (Retired)");
  static const kPullPrintRequestSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.31",
      WKUidType.kSopClass, true, "Pull Print Request SOP Class (Retired)");
  static const kPullStoredPrintManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.1.32",
    WKUidType.kMetaSopClass,
    true,
    "Pull Stored Print Management Meta SOP Class (Retired)",
  );
  static const kMediaCreationManagementSOPClassUID = const WKUid("1.2.840.10008.5.1.1.33",
      WKUidType.kSopClass, false, "Media Creation Management SOP Class UID");
  static const kComputedRadiographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.1",
      WKUidType.kSopClass, false, "Computed Radiography Image Storage");
  static const kDigitalX_RayImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.1",
    WKUidType.kSopClass,
    false,
    "Digital X-Ray Image Storage - For Presentation",
  );
  static const kDigitalX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.1.1",
    WKUidType.kSopClass,
    false,
    "Digital X-Ray Image Storage - For Processing",
  );
  static const kDigitalMammographyX_RayImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.2",
    WKUidType.kSopClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Presentation",
  );
  static const kDigitalMammographyX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.2.1",
    WKUidType.kSopClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Processing",
  );
  static const kDigitalIntra_OralX_RayImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.3",
    WKUidType.kSopClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Presentation",
  );
  static const kDigitalIntra_OralX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.1.3.1",
    WKUidType.kSopClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Processing",
  );
  static const kCTImageStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.2", WKUidType.kSopClass, false, "CT Image Storage");
  static const kEnhancedCTImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.2.1", WKUidType.kSopClass, false, "Enhanced CT Image Storage");
  static const kLegacyConvertedEnhancedCTImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.2.2",
      WKUidType.kSopClass, false, "Legacy Converted Enhanced CT Image Storage");
  static const kUltrasoundMulti_frameImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.3",
      WKUidType.kSopClass, true, "Ultrasound Multi-frame Image Storage (Retired)");
  static const kUltrasoundMulti_frameImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.3.1",
      WKUidType.kSopClass, false, "Ultrasound Multi-frame Image Storage");
  static const kMRImageStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.4", WKUidType.kSopClass, false, "MR Image Storage");
  static const kEnhancedMRImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.1", WKUidType.kSopClass, false, "Enhanced MR Image Storage");
  static const kMRSpectroscopyStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.2", WKUidType.kSopClass, false, "MR Spectroscopy Storage");
  static const kEnhancedMRColorImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.4.3", WKUidType.kSopClass, false, "Enhanced MR Color Image Storage");
  static const kLegacyConvertedEnhancedMRImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.4",
      WKUidType.kSopClass, false, "Legacy Converted Enhanced MR Image Storage");
  static const kNuclearMedicineImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.5",
      WKUidType.kSopClass, true, "Nuclear Medicine Image Storage (Retired)");
  static const kUltrasoundImageStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6", WKUidType.kSopClass, true, "Ultrasound Image Storage (Retired)");
  static const kUltrasoundImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6.1", WKUidType.kSopClass, false, "Ultrasound Image Storage");
  static const kEnhancedUSVolumeStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.6.2", WKUidType.kSopClass, false, "Enhanced US Volume Storage");
  static const kSecondaryCaptureImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.7", WKUidType.kSopClass, false, "Secondary Capture Image Storage");
  static const kMulti_frameSingleBitSecondaryCaptureImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.1",
    WKUidType.kSopClass,
    false,
    "Multi-frame Single Bit Secondary Capture Image Storage",
  );
  static const kMulti_frameGrayscaleByteSecondaryCaptureImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.2",
    WKUidType.kSopClass,
    false,
    "Multi-frame Grayscale Byte Secondary Capture Image Storage",
  );
  static const kMulti_frameGrayscaleWordSecondaryCaptureImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.3",
    WKUidType.kSopClass,
    false,
    "Multi-frame Grayscale Word Secondary Capture Image Storage",
  );
  static const kMulti_frameTrueColorSecondaryCaptureImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.7.4",
    WKUidType.kSopClass,
    false,
    "Multi-frame True Color Secondary Capture Image Storage",
  );
  static const kStandaloneOverlayStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.8",
      WKUidType.kSopClass, true, "Standalone Overlay Storage (Retired)");
  static const kStandaloneCurveStorage_Retired = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9", WKUidType.kSopClass, true, "Standalone Curve Storage (Retired)");
  static const kWaveformStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.9.1",
      WKUidType.kSopClass, true, "Waveform Storage - Trial (Retired)");
  static const ktwelve_lead_12ECGWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.1.1",
      WKUidType.kSopClass, false, "twelve-lead(12) ECG Waveform Storage");
  static const kGeneralECGWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.1.2", WKUidType.kSopClass, false, "General ECG Waveform Storage");
  static const kAmbulatoryECGWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.1.3",
      WKUidType.kSopClass, false, "Ambulatory ECG Waveform Storage");
  static const kHemodynamicWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.2.1", WKUidType.kSopClass, false, "Hemodynamic Waveform Storage");
  static const kCardiacElectrophysiologyWaveformStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.9.3.1",
    WKUidType.kSopClass,
    false,
    "Cardiac Electrophysiology Waveform Storage",
  );
  static const kBasicVoiceAudioWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.4.1",
      WKUidType.kSopClass, false, "Basic Voice Audio Waveform Storage");
  static const kGeneralAudioWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.4.2",
      WKUidType.kSopClass, false, "General Audio Waveform Storage");
  static const kArterialPulseWaveformStorage = const WKUid("1.2.840.10008.5.1.4.1.1.9.5.1",
      WKUidType.kSopClass, false, "Arterial Pulse Waveform Storage");
  static const kRespiratoryWaveformStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.9.6.1", WKUidType.kSopClass, false, "Respiratory Waveform Storage");
  static const kStandaloneModalityLUTStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.10",
      WKUidType.kSopClass, true, "Standalone Modality LUT Storage (Retired)");
  static const kStandaloneVOILUTStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.11",
      WKUidType.kSopClass, true, "Standalone VOI LUT Storage (Retired)");
  static const kGrayscaleSoftcopyPresentationStateStorageSOPClass = const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.1",
    WKUidType.kSopClass,
    false,
    "Grayscale Softcopy Presentation State Storage SOP Class",
  );
  static const kColorSoftcopyPresentationStateStorageSOPClass = const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.2",
    WKUidType.kSopClass,
    false,
    "Color Softcopy Presentation State Storage SOP Class",
  );
  static const kPseudo_ColorSoftcopyPresentationStateStorageSOPClass = const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.3",
    WKUidType.kSopClass,
    false,
    "Pseudo-Color Softcopy Presentation State Storage SOP Class",
  );
  static const kBlendingSoftcopyPresentationStateStorageSOPClass = const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.4",
    WKUidType.kSopClass,
    false,
    "Blending Softcopy Presentation State Storage SOP Class",
  );
  static const kXA_XRFGrayscaleSoftcopyPresentationStateStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.11.5",
    WKUidType.kSopClass,
    false,
    "XA/XRF Grayscale Softcopy Presentation State Storage",
  );
  static const kX_RayAngiographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.1",
      WKUidType.kSopClass, false, "X-Ray Angiographic Image Storage");
  static const kEnhancedXAImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.1.1", WKUidType.kSopClass, false, "Enhanced XA Image Storage");
  static const kX_RayRadiofluoroscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.12.2",
      WKUidType.kSopClass, false, "X-Ray Radiofluoroscopic Image Storage");
  static const kEnhancedXRFImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.12.2.1", WKUidType.kSopClass, false, "Enhanced XRF Image Storage");
  static const kX_RayAngiographicBi_PlaneImageStorage_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.1.12.3",
    WKUidType.kSopClass,
    true,
    "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
  );
  static const kX_Ray3DAngiographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.1",
      WKUidType.kSopClass, false, "X-Ray 3D Angiographic Image Storage");
  static const kX_Ray3DCraniofacialImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.2",
      WKUidType.kSopClass, false, "X-Ray 3D Craniofacial Image Storage");
  static const kBreastTomosynthesisImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.13.1.3",
      WKUidType.kSopClass, false, "Breast Tomosynthesis Image Storage");
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.14.1",
    WKUidType.kSopClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Presentation",
  );
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.14.2",
    WKUidType.kSopClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Processing",
  );
  static const kNuclearMedicineImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.20", WKUidType.kSopClass, false, "Nuclear Medicine Image Storage");
  static const kRawDataStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.66", WKUidType.kSopClass, false, "Raw Data Storage");
  static const kSpatialRegistrationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.1", WKUidType.kSopClass, false, "Spatial Registration Storage");
  static const kSpatialFiducialsStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.2", WKUidType.kSopClass, false, "Spatial Fiducials Storage");
  static const kDeformableSpatialRegistrationStorage = const WKUid("1.2.840.10008.5.1.4.1.1.66.3",
      WKUidType.kSopClass, false, "Deformable Spatial Registration Storage");
  static const kSegmentationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.4", WKUidType.kSopClass, false, "Segmentation Storage");
  static const kSurfaceSegmentationStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.66.5", WKUidType.kSopClass, false, "Surface Segmentation Storage");
  static const kRealWorldValueMappingStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.67", WKUidType.kSopClass, false, "Real World Value Mapping Storage");
  static const kSurfaceScanMeshStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.68.1", WKUidType.kSopClass, false, "Surface Scan Mesh Storage");
  static const kSurfaceScanPointCloudStorage = const WKUid("1.2.840.10008.5.1.4.1.1.68.2",
      WKUidType.kSopClass, false, "Surface Scan Point Cloud Storage");
  static const kVLImageStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.77.1",
      WKUidType.kSopClass, true, "VL Image Storage - Trial (Retired)");
  static const kVLMulti_frameImageStorage_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.2",
    WKUidType.kSopClass,
    true,
    "VL Multi-frame Image Storage - Trial (Retired)",
  );
  static const kVLEndoscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1", WKUidType.kSopClass, false, "VL Endoscopic Image Storage");
  static const kVideoEndoscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.1.1",
      WKUidType.kSopClass, false, "Video Endoscopic Image Storage");
  static const kVLMicroscopicImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2", WKUidType.kSopClass, false, "VL Microscopic Image Storage");
  static const kVideoMicroscopicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.2.1",
      WKUidType.kSopClass, false, "Video Microscopic Image Storage");
  static const kVLSlide_CoordinatesMicroscopicImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.3",
    WKUidType.kSopClass,
    false,
    "VL Slide-Coordinates Microscopic Image Storage",
  );
  static const kVLPhotographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.4",
      WKUidType.kSopClass, false, "VL Photographic Image Storage");
  static const kVideoPhotographicImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.4.1",
      WKUidType.kSopClass, false, "Video Photographic Image Storage");
  static const kOphthalmicPhotography8BitImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.1",
    WKUidType.kSopClass,
    false,
    "Ophthalmic Photography 8 Bit Image Storage",
  );
  static const kOphthalmicPhotography16BitImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.2",
    WKUidType.kSopClass,
    false,
    "Ophthalmic Photography 16 Bit Image Storage",
  );
  static const kStereometricRelationshipStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.5.3",
      WKUidType.kSopClass, false, "Stereometric Relationship Storage");
  static const kOphthalmicTomographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.5.4",
      WKUidType.kSopClass, false, "Ophthalmic Tomography Image Storage");
  static const kVLWholeSlideMicroscopyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.77.1.6",
      WKUidType.kSopClass, false, "VL Whole Slide Microscopy Image Storage");
  static const kLensometryMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.1",
      WKUidType.kSopClass, false, "Lensometry Measurements Storage");
  static const kAutorefractionMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.2",
      WKUidType.kSopClass, false, "Autorefraction Measurements Storage");
  static const kKeratometryMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.3",
      WKUidType.kSopClass, false, "Keratometry Measurements Storage");
  static const kSubjectiveRefractionMeasurementsStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.78.4",
    WKUidType.kSopClass,
    false,
    "Subjective Refraction Measurements Storage",
  );
  static const kVisualAcuityMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.5",
      WKUidType.kSopClass, false, "Visual Acuity Measurements Storage");
  static const kSpectaclePrescriptionReportStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.6",
      WKUidType.kSopClass, false, "Spectacle Prescription Report Storage");
  static const kOphthalmicAxialMeasurementsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.7",
      WKUidType.kSopClass, false, "Ophthalmic Axial Measurements Storage");
  static const kIntraocularLensCalculationsStorage = const WKUid("1.2.840.10008.5.1.4.1.1.78.8",
      WKUidType.kSopClass, false, "Intraocular Lens Calculations Storage");
  static const kMacularGridThicknessandVolumeReportStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.79.1",
    WKUidType.kSopClass,
    false,
    "Macular Grid Thickness and Volume Report Storage",
  );
  static const kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.80.1",
    WKUidType.kSopClass,
    false,
    "Ophthalmic Visual Field Static Perimetry Measurements Storage",
  );
  static const kOphthalmicThicknessMapStorage = const WKUid("1.2.840.10008.5.1.4.1.1.81.1",
      WKUidType.kSopClass, false, "Ophthalmic Thickness Map Storage");
  static const kCornealTopographyMapStorage = const WKUid("11.2.840.10008.5.1.4.1.1.82.1",
      WKUidType.kSopClass, false, "Corneal Topography Map Storage");
  static const kTextSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.1",
      WKUidType.kSopClass, true, "Text SR Storage - Trial (Retired)");
  static const kAudioSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.2",
      WKUidType.kSopClass, true, "Audio SR Storage - Trial (Retired)");
  static const kDetailSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.3",
      WKUidType.kSopClass, true, "Detail SR Storage - Trial (Retired)");
  static const kComprehensiveSRStorage_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.88.4",
      WKUidType.kSopClass, true, "Comprehensive SR Storage - Trial (Retired)");
  static const kBasicTextSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.11", WKUidType.kSopClass, false, "Basic Text SR Storage");
  static const kEnhancedSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.22", WKUidType.kSopClass, false, "Enhanced SR Storage");
  static const kComprehensiveSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.33", WKUidType.kSopClass, false, "Comprehensive SR Storage");
  static const kComprehensive3DSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.34", WKUidType.kSopClass, false, "Comprehensive 3D SR Storage");
  static const kProcedureLogStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.40", WKUidType.kSopClass, false, "Procedure Log Storage");
  static const kMammographyCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.50", WKUidType.kSopClass, false, "Mammography CAD SR Storage");
  static const kKeyObjectSelectionDocumentStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.59",
      WKUidType.kSopClass, false, "Key Object Selection Document Storage");
  static const kChestCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.65", WKUidType.kSopClass, false, "Chest CAD SR Storage");
  static const kX_RayRadiationDoseSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.67",
      WKUidType.kSopClass, false, "X-Ray Radiation Dose SR Storage");
  static const kColonCADSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.69", WKUidType.kSopClass, false, "Colon CAD SR Storage");
  static const kImplantationPlanSRStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.88.70", WKUidType.kSopClass, false, "Implantation Plan SR Storage");
  static const kEncapsulatedPDFStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.104.1", WKUidType.kSopClass, false, "Encapsulated PDF Storage");
  static const kEncapsulatedCDAStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.104.2", WKUidType.kSopClass, false, "Encapsulated CDA Storage");
  static const kPositronEmissionTomographyImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.128",
      WKUidType.kSopClass, false, "Positron Emission Tomography Image Storage");
  static const kLegacyConvertedEnhancedPETImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.128.1",
    WKUidType.kSopClass,
    false,
    "Legacy Converted Enhanced PET Image Storage",
  );
  static const kStandalonePETCurveStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.129",
      WKUidType.kSopClass, true, "Standalone PET Curve Storage (Retired)");
  static const kEnhancedPETImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.130", WKUidType.kSopClass, false, "Enhanced PET Image Storage");
  static const kBasicStructuredDisplayStorage = const WKUid("1.2.840.10008.5.1.4.1.1.131",
      WKUidType.kSopClass, false, "Basic Structured Display Storage");
  static const kRTImageStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.481.1", WKUidType.kSopClass, false, "RT Image Storage");
  static const kRTDoseStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.481.2", WKUidType.kSopClass, false, "RT Dose Storage");
  static const kRTStructureSetStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.3", WKUidType.kSopClass, false, "RT Structure Set Storage");
  static const kRTBeamsTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.4",
      WKUidType.kSopClass, false, "RT Beams Treatment Record Storage");
  static const kRTPlanStorage =
      const WKUid("1.2.840.10008.5.1.4.1.1.481.5", WKUidType.kSopClass, false, "RT Plan Storage");
  static const kRTBrachyTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.6",
      WKUidType.kSopClass, false, "RT Brachy Treatment Record Storage");
  static const kRTTreatmentSummaryRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.7",
      WKUidType.kSopClass, false, "RT Treatment Summary Record Storage");
  static const kRTIonPlanStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.481.8", WKUidType.kSopClass, false, "RT Ion Plan Storage");
  static const kRTIonBeamsTreatmentRecordStorage = const WKUid("1.2.840.10008.5.1.4.1.1.481.9",
      WKUidType.kSopClass, false, "RT Ion Beams Treatment Record Storage");
  static const kDICOSCTImageStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.1",
    WKUidType.kSopClass,
    false,
    "DICOS CT Image Storage",
  );
  static const kDICOSDigitalX_RayImageStorage_ForPresentation = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.2.1",
    WKUidType.kSopClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Presentation",
  );
  static const kDICOSDigitalX_RayImageStorage_ForProcessing = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.2.2",
    WKUidType.kSopClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Processing",
  );
  static const kDICOSThreatDetectionReportStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.3",
    WKUidType.kSopClass,
    false,
    "DICOS Threat Detection Report Storage",
  );
  static const kDICOS2DAITStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.4",
    WKUidType.kSopClass,
    false,
    "DICOS 2D AIT Storage",
  );
  static const kDICOS3DAITStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.5",
    WKUidType.kSopClass,
    false,
    "DICOS 3D AIT Storage",
  );
  static const kDICOSQuadrupoleResonanceStorage = const WKUid(
    "1.2.840.10008.5.1.4.1.1.501.6",
    WKUidType.kSopClass,
    false,
    "DICOS Quadrupole Resonance (QR) Storage",
  );
  static const kEddyCurrentImageStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.601.1", WKUidType.kSopClass, false, "Eddy Current Image Storage");
  static const kEddyCurrentMulti_frameImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.601.2",
      WKUidType.kSopClass, false, "Eddy Current Multi-frame Image Storage");
  static const kPatientRootQueryRetrieveInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.1",
    WKUidType.kSopClass,
    false,
    "Patient Root Query/Retrieve Information Model - FIND",
  );
  static const kPatientRootQueryRetrieveInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.2",
    WKUidType.kSopClass,
    false,
    "Patient Root Query/Retrieve Information Model - MOVE",
  );
  static const kPatientRootQueryRetrieveInformationModel_GET = const WKUid(
    "1.2.840.10008.5.1.4.1.2.1.3",
    WKUidType.kSopClass,
    false,
    "Patient Root Query/Retrieve Information Model - GET",
  );
  static const kStudyRootQueryRetrieveInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.1",
    WKUidType.kSopClass,
    false,
    "Study Root Query/Retrieve Information Model - FIND",
  );
  static const kStudyRootQueryRetrieveInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.2",
    WKUidType.kSopClass,
    false,
    "Study Root Query/Retrieve Information Model - MOVE",
  );
  static const kStudyRootQueryRetrieveInformationModel_GET = const WKUid(
    "1.2.840.10008.5.1.4.1.2.2.3",
    WKUidType.kSopClass,
    false,
    "Study Root Query/Retrieve Information Model - GET",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.1",
    WKUidType.kSopClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.2",
    WKUidType.kSopClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired = const WKUid(
    "1.2.840.10008.5.1.4.1.2.3.3",
    WKUidType.kSopClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
  );
  static const kCompositeInstanceRootRetrieve_MOVE = const WKUid("1.2.840.10008.5.1.4.1.2.4.2",
      WKUidType.kSopClass, false, "Composite Instance Root Retrieve - MOVE");
  static const kCompositeInstanceRootRetrieve_GET = const WKUid("1.2.840.10008.5.1.4.1.2.4.3",
      WKUidType.kSopClass, false, "Composite Instance Root Retrieve - GET");
  static const kCompositeInstanceRetrieveWithoutBulkData_GET = const WKUid(
    "1.2.840.10008.5.1.4.1.2.5.3",
    WKUidType.kSopClass,
    false,
    "Composite Instance Retrieve Without Bulk Data - GET",
  );
  static const kModalityWorklistInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.31",
      WKUidType.kSopClass, false, "Modality Worklist Information Model - FIND");
  static const kGeneralPurposeWorklistInformationModel_FIND_Retired = const WKUid(
    "1.2.840.10008.5.1.4.32.1",
    WKUidType.kSopClass,
    true,
    "General Purpose Worklist Information Model - FIND (Retired)",
  );
  static const kGeneralPurposeScheduledProcedureStepSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.4.32.2",
    WKUidType.kSopClass,
    true,
    "General Purpose Scheduled Procedure Step SOP Class (Retired)",
  );
  static const kGeneralPurposePerformedProcedureStepSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.4.32.3",
    WKUidType.kSopClass,
    true,
    "General Purpose Performed Procedure Step SOP Class (Retired)",
  );
  static const kGeneralPurposeWorklistManagementMetaSOPClass_Retired = const WKUid(
    "1.2.840.10008.5.1.4.32",
    WKUidType.kMetaSopClass,
    true,
    "General Purpose Worklist Management Meta SOP Class (Retired)",
  );
  static const kInstanceAvailabilityNotificationSOPClass = const WKUid("1.2.840.10008.5.1.4.33",
      WKUidType.kSopClass, false, "Instance Availability Notification SOP Class");
  static const kRTBeamsDeliveryInstructionStorage_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.1",
    WKUidType.kSopClass,
    true,
    "RT Beams Delivery Instruction Storage - Trial (Retired)",
  );
  static const kRTConventionalMachineVerification_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.2",
    WKUidType.kSopClass,
    true,
    "RT Conventional Machine Verification - Trial (Retired)",
  );
  static const kRTIonMachineVerification_Trial_Retired = const WKUid("1.2.840.10008.5.1.4.34.3",
      WKUidType.kSopClass, true, "RT Ion Machine Verification - Trial (Retired)");
  static const kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4",
    WKUidType.kServiceClass,
    true,
    "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_PushSOPClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4.1",
    WKUidType.kSopClass,
    true,
    "Unified Procedure Step - Push SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_WatchSOPClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4.2",
    WKUidType.kSopClass,
    true,
    "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_PullSOPClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4.3",
    WKUidType.kSopClass,
    true,
    "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_EventSOPClass_Trial_Retired = const WKUid(
    "1.2.840.10008.5.1.4.34.4.4",
    WKUidType.kSopClass,
    true,
    "Unified Procedure Step - Event SOP Class - Trial (Retired)",
  );
  static const kUnifiedWorklistandProcedureStepSOPInstance = const WKUid("1.2.840.10008.5.1.4.34.5",
      WKUidType.kSopInstance, false, "Unified Worklist and Procedure Step SOP Instance");
  static const kUnifiedWorklistandProcedureStepServiceClass = const WKUid(
    "1.2.840.10008.5.1.4.34.6",
    WKUidType.kServiceClass,
    false,
    "Unified Worklist and Procedure Step Service Class",
  );
  static const kUnifiedProcedureStep_PushSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.1",
      WKUidType.kSopClass, false, "Unified Procedure Step - Push SOP Class");
  static const kUnifiedProcedureStep_WatchSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.2",
      WKUidType.kSopClass, false, "Unified Procedure Step - Watch SOP Class");
  static const kUnifiedProcedureStep_PullSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.3",
      WKUidType.kSopClass, false, "Unified Procedure Step - Pull SOP Class");
  static const kUnifiedProcedureStep_EventSOPClass = const WKUid("1.2.840.10008.5.1.4.34.6.4",
      WKUidType.kSopClass, false, "Unified Procedure Step - Event SOP Class");
  static const kRTBeamsDeliveryInstructionStorage = const WKUid("1.2.840.10008.5.1.4.34.7",
      WKUidType.kSopClass, false, "RT Beams Delivery Instruction Storage");
  static const kRTConventionalMachineVerification = const WKUid("1.2.840.10008.5.1.4.34.8",
      WKUidType.kSopClass, false, "RT Conventional Machine Verification");
  static const kRTIonMachineVerification = const WKUid(
      "1.2.840.10008.5.1.4.34.9", WKUidType.kSopClass, false, "RT Ion Machine Verification");
  static const kGeneralRelevantPatientInformationQuery = const WKUid("1.2.840.10008.5.1.4.37.1",
      WKUidType.kSopClass, false, "General Relevant Patient Information Query");
  static const kBreastImagingRelevantPatientInformationQuery = const WKUid(
    "1.2.840.10008.5.1.4.37.2",
    WKUidType.kSopClass,
    false,
    "Breast Imaging Relevant Patient Information Query",
  );
  static const kCardiacRelevantPatientInformationQuery = const WKUid("1.2.840.10008.5.1.4.37.3",
      WKUidType.kSopClass, false, "Cardiac Relevant Patient Information Query");
  static const kHangingProtocolStorage = const WKUid(
      "1.2.840.10008.5.1.4.38.1", WKUidType.kSopClass, false, "Hanging Protocol Storage");
  static const kHangingProtocolInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.38.2",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - FIND");
  static const kHangingProtocolInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.38.3",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - MOVE");
  static const kHangingProtocolInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.38.4",
      WKUidType.kSopClass, false, "Hanging Protocol Information Model - GET");
  static const kColorPaletteStorage =
      const WKUid("1.2.840.10008.5.1.4.39.1", WKUidType.kTransfer, false, "Color Palette Storage");
  static const kColorPaletteInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.39.2",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - FIND");
  static const kColorPaletteInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.39.3",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - MOVE");
  static const kColorPaletteInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.39.4",
      WKUidType.kQueryRetrieve, false, "Color Palette Information Model - GET");
  static const kProductCharacteristicsQuerySOPClass = const WKUid("1.2.840.10008.5.1.4.41",
      WKUidType.kSopClass, false, "Product Characteristics Query SOP Class");
  static const kSubstanceApprovalQuerySOPClass = const WKUid(
      "1.2.840.10008.5.1.4.42", WKUidType.kSopClass, false, "Substance Approval Query SOP Class");
  static const kGenericImplantTemplateStorage = const WKUid(
      "1.2.840.10008.5.1.4.43.1", WKUidType.kSopClass, false, "Generic Implant Template Storage");
  static const kGenericImplantTemplateInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.43.2",
    WKUidType.kSopClass,
    false,
    "Generic Implant Template Information Model - FIND",
  );
  static const kGenericImplantTemplateInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.43.3",
    WKUidType.kSopClass,
    false,
    "Generic Implant Template Information Model - MOVE",
  );
  static const kGenericImplantTemplateInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.43.4",
      WKUidType.kSopClass, false, "Generic Implant Template Information Model - GET");
  static const kImplantAssemblyTemplateStorage = const WKUid(
      "1.2.840.10008.5.1.4.44.1", WKUidType.kSopClass, false, "Implant Assembly Template Storage");
  static const kImplantAssemblyTemplateInformationModel_FIND = const WKUid(
    "1.2.840.10008.5.1.4.44.2",
    WKUidType.kSopClass,
    false,
    "Implant Assembly Template Information Model - FIND",
  );
  static const kImplantAssemblyTemplateInformationModel_MOVE = const WKUid(
    "1.2.840.10008.5.1.4.44.3",
    WKUidType.kSopClass,
    false,
    "Implant Assembly Template Information Model - MOVE",
  );
  static const kImplantAssemblyTemplateInformationModel_GET = const WKUid(
    "1.2.840.10008.5.1.4.44.4",
    WKUidType.kSopClass,
    false,
    "Implant Assembly Template Information Model - GET",
  );
  static const kImplantTemplateGroupStorage = const WKUid(
      "1.2.840.10008.5.1.4.45.1", WKUidType.kSopClass, false, "Implant Template Group Storage");
  static const kImplantTemplateGroupInformationModel_FIND = const WKUid("1.2.840.10008.5.1.4.45.2",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - FIND");
  static const kImplantTemplateGroupInformationModel_MOVE = const WKUid("1.2.840.10008.5.1.4.45.3",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - MOVE");
  static const kImplantTemplateGroupInformationModel_GET = const WKUid("1.2.840.10008.5.1.4.45.4",
      WKUidType.kSopClass, false, "Implant Template Group Information Model - GET");
  static const kNativeDICOMModel = const WKUid(
      "1.2.840.10008.7.1.1", WKUidType.kApplicationHostingModel, false, "Native DICOM Model");
  static const kAbstractMulti_DimensionalImageModel = const WKUid("1.2.840.10008.7.1.2",
      WKUidType.kApplicationHostingModel, false, "Abstract Multi-Dimensional Image Model");
  static const kdicomDeviceName =
      const WKUid("1.2.840.10008.15.0.3.1", WKUidType.kLdapOid, false, "dicomDeviceName");
  static const kdicomDescription =
      const WKUid("1.2.840.10008.15.0.3.2", WKUidType.kLdapOid, false, "dicomDescription");
  static const kdicomManufacturer =
      const WKUid("1.2.840.10008.15.0.3.3", WKUidType.kLdapOid, false, "dicomManufacturer");
  static const kdicomManufacturerModelName = const WKUid(
      "1.2.840.10008.15.0.3.4", WKUidType.kLdapOid, false, "dicomManufacturerModelName");
  static const kdicomSoftwareVersion =
      const WKUid("1.2.840.10008.15.0.3.5", WKUidType.kLdapOid, false, "dicomSoftwareVersion");
  static const kdicomVendorData =
      const WKUid("1.2.840.10008.15.0.3.6", WKUidType.kLdapOid, false, "dicomVendorData");
  static const kdicomAETitle =
      const WKUid("1.2.840.10008.15.0.3.7", WKUidType.kLdapOid, false, "dicomAETitle");
  static const kdicomNetworkConnectionReference = const WKUid(
      "1.2.840.10008.15.0.3.8", WKUidType.kLdapOid, false, "dicomNetworkConnectionReference");
  static const kdicomApplicationCluster =
      const WKUid("1.2.840.10008.15.0.3.9", WKUidType.kLdapOid, false, "dicomApplicationCluster");
  static const kdicomAssociationInitiator = const WKUid(
      "1.2.840.10008.15.0.3.10", WKUidType.kLdapOid, false, "dicomAssociationInitiator");
  static const kdicomAssociationAcceptor =
      const WKUid("1.2.840.10008.15.0.3.11", WKUidType.kLdapOid, false, "dicomAssociationAcceptor");
  static const kdicomHostname =
      const WKUid("1.2.840.10008.15.0.3.12", WKUidType.kLdapOid, false, "dicomHostname");
  static const kdicomPort =
      const WKUid("1.2.840.10008.15.0.3.13", WKUidType.kLdapOid, false, "dicomPort");
  static const kdicomSOPClass =
      const WKUid("1.2.840.10008.15.0.3.14", WKUidType.kLdapOid, false, "dicomSOPClass");
  static const kdicomTransferRole =
      const WKUid("1.2.840.10008.15.0.3.15", WKUidType.kLdapOid, false, "dicomTransferRole");
  static const kdicomTransferSyntax =
      const WKUid("1.2.840.10008.15.0.3.16", WKUidType.kLdapOid, false, "dicomTransferSyntax");
  static const kdicomPrimaryDeviceType =
      const WKUid("1.2.840.10008.15.0.3.17", WKUidType.kLdapOid, false, "dicomPrimaryDeviceType");
  static const kdicomRelatedDeviceReference = const WKUid(
      "1.2.840.10008.15.0.3.18", WKUidType.kLdapOid, false, "dicomRelatedDeviceReference");
  static const kdicomPreferredCalledAETitle = const WKUid(
      "1.2.840.10008.15.0.3.19", WKUidType.kLdapOid, false, "dicomPreferredCalledAETitle");
  static const kdicomTLSCyphersuite =
      const WKUid("1.2.840.10008.15.0.3.20", WKUidType.kLdapOid, false, "dicomTLSCyphersuite");
  static const kdicomAuthorizedNodeCertificateReference = const WKUid("1.2.840.10008.15.0.3.21",
      WKUidType.kLdapOid, false, "dicomAuthorizedNodeCertificateReference");
  static const kdicomThisNodeCertificateReference = const WKUid(
      "1.2.840.10008.15.0.3.22", WKUidType.kLdapOid, false, "dicomThisNodeCertificateReference");
  static const kdicomInstalled =
      const WKUid("1.2.840.10008.15.0.3.23", WKUidType.kLdapOid, false, "dicomInstalled");
  static const kdicomStationName =
      const WKUid("1.2.840.10008.15.0.3.24", WKUidType.kLdapOid, false, "dicomStationName");
  static const kdicomDeviceSerialNumber =
      const WKUid("1.2.840.10008.15.0.3.25", WKUidType.kLdapOid, false, "dicomDeviceSerialNumber");
  static const kdicomInstitutionName =
      const WKUid("1.2.840.10008.15.0.3.26", WKUidType.kLdapOid, false, "dicomInstitutionName");
  static const kdicomInstitutionAddress =
      const WKUid("1.2.840.10008.15.0.3.27", WKUidType.kLdapOid, false, "dicomInstitutionAddress");
  static const kdicomInstitutionDepartmentName = const WKUid(
      "1.2.840.10008.15.0.3.28", WKUidType.kLdapOid, false, "dicomInstitutionDepartmentName");
  static const kdicomIssuerOfPatientID =
      const WKUid("1.2.840.10008.15.0.3.29", WKUidType.kLdapOid, false, "dicomIssuerOfPatientID");
  static const kdicomPreferredCallingAETitle = const WKUid(
      "1.2.840.10008.15.0.3.30", WKUidType.kLdapOid, false, "dicomPreferredCallingAETitle");
  static const kdicomSupportedCharacterSet = const WKUid(
      "1.2.840.10008.15.0.3.31", WKUidType.kLdapOid, false, "dicomSupportedCharacterSet");
  static const kdicomConfigurationRoot =
      const WKUid("1.2.840.10008.15.0.4.1", WKUidType.kLdapOid, false, "dicomConfigurationRoot");
  static const kdicomDevicesRoot =
      const WKUid("1.2.840.10008.15.0.4.2", WKUidType.kLdapOid, false, "dicomDevicesRoot");
  static const kdicomUniqueAETitlesRegistryRoot = const WKUid(
      "1.2.840.10008.15.0.4.3", WKUidType.kLdapOid, false, "dicomUniqueAETitlesRegistryRoot");
  static const kdicomDevice =
      const WKUid("1.2.840.10008.15.0.4.4", WKUidType.kLdapOid, false, "dicomDevice");
  static const kdicomNetworkAE =
      const WKUid("1.2.840.10008.15.0.4.5", WKUidType.kLdapOid, false, "dicomNetworkAE");
  static const kdicomNetworkConnection =
      const WKUid("1.2.840.10008.15.0.4.6", WKUidType.kLdapOid, false, "dicomNetworkConnection");
  static const kdicomUniqueAETitle =
      const WKUid("1.2.840.10008.15.0.4.7", WKUidType.kLdapOid, false, "dicomUniqueAETitle");
  static const kdicomTransferCapability =
      const WKUid("1.2.840.10008.15.0.4.8", WKUidType.kLdapOid, false, "dicomTransferCapability");
  static const kUniversalCoordinatedTime = const WKUid("1.2.840.10008.15.1.1",
      WKUidType.kSynchronizationFrameOfReference, false, "Universal Coordinated Time");
}
