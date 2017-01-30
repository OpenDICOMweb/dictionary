// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

//TODO wwe need add the keyword to the to the class.

/// Compile time constant definitions for the "Well Known" UIDs from PS 3.6
class WKUid extends UidString {
  //TODO add keyword to table below
  // final String  keyword;
  @override
  final UidType type;
  final String name;
  final bool isRetired;

  const WKUid._(String string, this.type, this.isRetired, this.name) : super._(string);

  //static fromString(String s) => stringToUidMap[validate(s)];

  bool get isNotRetired => !isRetired;

  //TODO: create UidType class
  bool get isTransferSyntax => type == UidType.kTransferSyntax;

  //TODO: create UidType class
  bool get isSOPClass => type == UidType.kSOPClass;

  bool get isMetaSOPClass => type == UidType.kMetaSOPClass;

  bool get isFrameOfReference => type == UidType.kWellKnownFrameOfReference;

  bool get isSOPInstance => type == UidType.kWellKnownSOPInstance;

  bool get isCodingScheme => type == UidType.kCodingScheme;

  String get info => "UID: $string (type=$type, name=$name)";

  @override
  String toString() => string;

  static WKUid lookup(var uid) {
    if (uid is Uid) uid = uid.string;
    if (uid is String) return wellKnownUids[uid];
    return null;
  }

  //*****   Constant Values   *****
  static const kVerificationSOPClass =
      const WKUid._("1.2.840.10008.1.1", UidType.kSOPClass, false, "Verification SOP Class");
  static const kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM = const WKUid._(
    "1.2.840.10008.1.2",
    UidType.kTransferSyntax,
    false,
    "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
  );

  static const kExplicitVRLittleEndian = const WKUid._(
      "1.2.840.10008.1.2.1", UidType.kTransferSyntax, false, "Explicit VR Little Endian");
  static const kDeflatedExplicitVRLittleEndian = const WKUid._("1.2.840.10008.1.2.1.99",
      UidType.kTransferSyntax, false, "Deflated Explicit VR Little Endian");
  static const kExplicitVRBigEndian_Retired = const WKUid._(
      "1.2.840.10008.1.2.2", UidType.kTransferSyntax, true, "Explicit VR Big Endian (Retired)");
  static const kJPEGBaseline_1 = const WKUid._(
    "1.2.840.10008.1.2.4.50",
    UidType.kTransferSyntax,
    false,
    "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy JPEG 8 Bit Image Compression",
  );
  static const kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 =
      const WKUid._(
    "1.2.840.10008.1.2.4.51",
    UidType.kTransferSyntax,
    false,
    "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for Lossy JPEG 12 Bit Image Compression (Process 4 only)",
  );
  static const kJPEGExtended_3_5_Retired = const WKUid._("1.2.840.10008.1.2.4.52",
      UidType.kTransferSyntax, true, "JPEG Extended (Process 3 & 5) (Retired)");
  static const kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.53",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
  );
  static const kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.54",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
  );
  static const kJPEGFullProgressionNon_Hierarchical_10_12_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.55",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
  );
  static const kJPEGFullProgressionNon_Hierarchical_11_13_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.56",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
  );
  static const kJPEGLosslessNon_Hierarchical_14 = const WKUid._("1.2.840.10008.1.2.4.57",
      UidType.kTransferSyntax, false, "JPEG Lossless, Non-Hierarchical (Process 14)");
  static const kJPEGLosslessNon_Hierarchical_15_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.58",
    UidType.kTransferSyntax,
    true,
    "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
  );
  static const kJPEGExtendedHierarchical_16_18_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.59",
    UidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
  );
  static const kJPEGExtendedHierarchical_17_19_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.60",
    UidType.kTransferSyntax,
    true,
    "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
  );
  static const kJPEGSpectralSelectionHierarchical_20_22_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.61",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
  );
  static const kJPEGSpectralSelectionHierarchical_21_23_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.62",
    UidType.kTransferSyntax,
    true,
    "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
  );
  static const kJPEGFullProgressionHierarchical_24_26_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.63",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
  );
  static const kJPEGFullProgressionHierarchical_25_27_Retired = const WKUid._(
    "1.2.840.10008.1.2.4.64",
    UidType.kTransferSyntax,
    true,
    "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
  );
  static const kJPEGLosslessHierarchical_28_Retired = const WKUid._("1.2.840.10008.1.2.4.65",
      UidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 28) (Retired)");
  static const kJPEGLosslessHierarchical_29_Retired = const WKUid._("1.2.840.10008.1.2.4.66",
      UidType.kTransferSyntax, true, "JPEG Lossless, Hierarchical (Process 29) (Retired)");
  static const kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
      const WKUid._(
    "1.2.840.10008.1.2.4.70",
    UidType.kTransferSyntax,
    false,
    "JPEG Lossless, Non-Hierarchical, First-Order Prediction (Process 14 [Selection Value 1]) : Default Transfer Syntax for Lossless JPEG Image Compression",
  );
  static const kJPEG_LSLosslessImageCompression = const WKUid._("1.2.840.10008.1.2.4.80",
      UidType.kTransferSyntax, false, "JPEG-LS Lossless Image Compression");
  static const kJPEG_LSLossyImageCompression = const WKUid._("1.2.840.10008.1.2.4.81",
      UidType.kTransferSyntax, false, "JPEG-LS Lossy (Near-Lossless) Image Compression");
  static const kJPEG2000ImageCompressionLosslessOnly = const WKUid._("1.2.840.10008.1.2.4.90",
      UidType.kTransferSyntax, false, "JPEG 2000 Image Compression Lossless Only");
  static const kJPEG2000ImageCompression = const WKUid._(
      "1.2.840.10008.1.2.4.91", UidType.kTransferSyntax, false, "JPEG 2000 Image Compression");
  static const kJPEG2000Part2Multi_componentImageCompressionLosslessOnly = const WKUid._(
    "1.2.840.10008.1.2.4.92",
    UidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
  );
  static const kJPEG2000Part2Multi_componentImageCompression = const WKUid._(
    "1.2.840.10008.1.2.4.93",
    UidType.kTransferSyntax,
    false,
    "JPEG 2000 Part 2 Multi-component Image Compression",
  );
  static const kJPIPReferenced =
      const WKUid._("1.2.840.10008.1.2.4.94", UidType.kTransferSyntax, false, "JPIP Referenced");
  static const kJPIPReferencedDeflate = const WKUid._(
      "1.2.840.10008.1.2.4.95", UidType.kTransferSyntax, false, "JPIP Referenced Deflate");
  static const kMPEG2MainProfile_MainLevel = const WKUid._("1.2.840.10008.1.2.4.100",
      UidType.kTransferSyntax, false, "MPEG2 Main Profile @ Main Level");
  static const kMPEG2MainProfile_HighLevel = const WKUid._("1.2.840.10008.1.2.4.101",
      UidType.kTransferSyntax, false, "MPEG2 Main Profile @ High Level");
  static const kMPEG_4AVC_H264HighProfile_Level41 = const WKUid._("1.2.840.10008.1.2.4.102",
      UidType.kTransferSyntax, false, "MPEG-4 AVC/H.264 High Profile / Level 4.1");
  static const kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 = const WKUid._(
    "1.2.840.10008.1.2.4.103",
    UidType.kTransferSyntax,
    false,
    "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
  );
  static const kRLELossless =
      const WKUid._("1.2.840.10008.1.2.5", UidType.kTransferSyntax, false, "RLE Lossless");
  static const kRFC2557MIMEencapsulation = const WKUid._(
      "1.2.840.10008.1.2.6.1", UidType.kTransferSyntax, false, "RFC 2557 MIME encapsulation");
  static const kXMLEncoding =
      const WKUid._("1.2.840.10008.1.2.6.2", UidType.kTransferSyntax, false, "XML Encoding");
  static const kMediaStorageDirectoryStorage = const WKUid._(
      "1.2.840.10008.1.3.10", UidType.kSOPClass, false, "Media Storage Directory Storage");
  static const kTalairachBrainAtlasFrameofReference = const WKUid._("1.2.840.10008.1.4.1.1",
      UidType.kWellKnownFrameOfReference, false, "Talairach Brain Atlas Frame of Reference");
  static const kSPM2T1FrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.2", UidType.kWellKnownFrameOfReference, false, "SPM2 T1 Frame of Reference");
  static const kSPM2T2FrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.3", UidType.kWellKnownFrameOfReference, false, "SPM2 T2 Frame of Reference");
  static const kSPM2PDFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.4", UidType.kWellKnownFrameOfReference, false, "SPM2 PD Frame of Reference");
  static const kSPM2EPIFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.5", UidType.kWellKnownFrameOfReference, false, "SPM2 EPI Frame of Reference");
  static const kSPM2FILT1FrameofReference = const WKUid._("1.2.840.10008.1.4.1.6",
      UidType.kWellKnownFrameOfReference, false, "SPM2 FIL T1 Frame of Reference");
  static const kSPM2PETFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.7", UidType.kWellKnownFrameOfReference, false, "SPM2 PET Frame of Reference");
  static const kSPM2TRANSMFrameofReference = const WKUid._("1.2.840.10008.1.4.1.8",
      UidType.kWellKnownFrameOfReference, false, "SPM2 TRANSM Frame of Reference");
  static const kSPM2SPECTFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.9", UidType.kWellKnownFrameOfReference, false, "SPM2 SPECT Frame of Reference");
  static const kSPM2GRAYFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.10", UidType.kWellKnownFrameOfReference, false, "SPM2 GRAY Frame of Reference");
  static const kSPM2WHITEFrameofReference = const WKUid._("1.2.840.10008.1.4.1.11",
      UidType.kWellKnownFrameOfReference, false, "SPM2 WHITE Frame of Reference");
  static const kSPM2CSFFrameofReference = const WKUid._(
      "1.2.840.10008.1.4.1.12", UidType.kWellKnownFrameOfReference, false, "SPM2 CSF Frame of Reference");
  static const kSPM2BRAINMASKFrameofReference = const WKUid._("1.2.840.10008.1.4.1.13",
      UidType.kWellKnownFrameOfReference, false, "SPM2 BRAINMASK Frame of Reference");
  static const kSPM2AVG305T1FrameofReference = const WKUid._("1.2.840.10008.1.4.1.14",
      UidType.kWellKnownFrameOfReference, false, "SPM2 AVG305T1 Frame of Reference");
  static const kSPM2AVG152T1FrameofReference = const WKUid._("1.2.840.10008.1.4.1.15",
      UidType.kWellKnownFrameOfReference, false, "SPM2 AVG152T1 Frame of Reference");
  static const kSPM2AVG152T2FrameofReference = const WKUid._("1.2.840.10008.1.4.1.16",
      UidType.kWellKnownFrameOfReference, false, "SPM2 AVG152T2 Frame of Reference");
  static const kSPM2AVG152PDFrameofReference = const WKUid._("1.2.840.10008.1.4.1.17",
      UidType.kWellKnownFrameOfReference, false, "SPM2 AVG152PD Frame of Reference");
  static const kSPM2SINGLESUBJT1FrameofReference = const WKUid._("1.2.840.10008.1.4.1.18",
      UidType.kWellKnownFrameOfReference, false, "SPM2 SINGLESUBJT1 Frame of Reference");
  static const kICBM452T1FrameofReference = const WKUid._("1.2.840.10008.1.4.2.1",
      UidType.kWellKnownFrameOfReference, false, "ICBM 452 T1 Frame of Reference");
  static const kICBMSingleSubjectMRIFrameofReference = const WKUid._("1.2.840.10008.1.4.2.2",
      UidType.kWellKnownFrameOfReference, false, "ICBM Single Subject MRI Frame of Reference");
  static const kHotIronColorPaletteSOPInstance = const WKUid._(
    "1.2.840.10008.1.5.1",
    UidType.kColorPalette,
    false,
    "Hot Iron Color Palette SOP "
        "Instance",
  );
  static const kPETColorPaletteSOPInstance = const WKUid._(
      "1.2.840.10008.1.5.2", UidType.kColorPalette, false, "PET Color Palette SOP Instance");
  static const kHotMetalBlueColorPaletteSOPInstance = const WKUid._("1.2.840.10008.1.5.3",
      UidType.kColorPalette, false, "Hot Metal Blue Color Palette SOP Instance");
  static const kPET20StepColorPaletteSOPInstance = const WKUid._("1.2.840.10008.1.5.4",
      UidType.kWellKnownSOPInstance, false, "PET 20 Step Color Palette SOP Instance");
  static const kBasicStudyContentNotificationSOPClass_Retired = const WKUid._("1.2.840.10008.1.9",
      UidType.kSOPClass, true, "Basic Study Content Notification SOP Class (Retired)");
  static const kStorageCommitmentPushModelSOPClass = const WKUid._(
      "1.2.840.10008.1.20.1", UidType.kSOPClass, true, "Storage Commitment Push Model SOP Class");
  static const kStorageCommitmentPushModelSOPInstance = const WKUid._("1.2.840.10008.1.20.1.1",
      UidType.kWellKnownSOPInstance, false, "Storage Commitment Push Model SOP Instance");
  static const kStorageCommitmentPullModelSOPClass_Retired = const WKUid._("1.2.840.10008.1.20.2",
      UidType.kSOPClass, true, "Storage Commitment Pull Model SOP Class (Retired)");
  static const kStorageCommitmentPullModelSOPInstance_Retired = const WKUid._(
    "1.2.840.10008.1.20.2.1",
    UidType.kWellKnownSOPInstance,
    true,
    "Storage Commitment Pull Model SOP Instance (Retired)",
  );
  static const kProceduralEventLoggingSOPClass = const WKUid._(
      "1.2.840.10008.1.40", UidType.kSOPClass, false, "Procedural Event Logging SOP Class");
  static const kProceduralEventLoggingSOPInstance = const WKUid._("1.2.840.10008.1.40.1",
      UidType.kWellKnownSOPInstance, false, "Procedural Event Logging SOP Instance");
  static const kSubstanceAdministrationLoggingSOPClass = const WKUid._("1.2.840.10008.1.42",
      UidType.kSOPClass, false, "Substance Administration Logging SOP Class");
  static const kSubstanceAdministrationLoggingSOPInstance = const WKUid._("1.2.840.10008.1.42.1",
      UidType.kWellKnownSOPInstance, false, "Substance Administration Logging SOP Instance");
  static const kDICOMUIDRegistry = const WKUid._(
      "1.2.840.10008.2.6.1", UidType.kDicomUidCodingScheme, false, "DICOM UID Registry");
  static const kDICOMControlledTerminology = const WKUid._(
    "1.2.840.10008.2.16.4",
    UidType.kCodingScheme,
    false,
    "DICOM Controlled Terminology",
  );
  static const kDICOMApplicationContextName = const WKUid._(
    "1.2.840.10008.3.1.1.1",
    UidType.kApplicationContextName,
    false,
    "DICOM Application Context Name",
  );
  static const kDetachedPatientManagementSOPClass_Retired = const WKUid._("1.2.840.10008.3.1.2.1.1",
      UidType.kSOPClass, true, "Detached Patient Management SOP Class (Retired)");
  static const kDetachedPatientManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.3.1.2.1.4",
    UidType.kMetaSOPClass,
    true,
    "Detached Patient Management Meta SOP Class (Retired)",
  );
  static const kDetachedVisitManagementSOPClass_Retired = const WKUid._("1.2.840.10008.3.1.2.2.1",
      UidType.kSOPClass, true, "Detached Visit Management SOP Class (Retired)");
  static const kDetachedStudyManagementSOPClass_Retired = const WKUid._("1.2.840.10008.3.1.2.3.1",
      UidType.kSOPClass, true, "Detached Study Management SOP Class (Retired)");
  static const kStudyComponentManagementSOPClass_Retired = const WKUid._("1.2.840.10008.3.1.2.3.2",
      UidType.kSOPClass, true, "Study Component Management SOP Class (Retired)");
  static const kModalityPerformedProcedureStepSOPClass = const WKUid._("1.­2.840.10008.3.1.2.3.3",
      UidType.kSOPClass, false, "Modality Performed Procedure Step SOP Class");
  static const kModalityPerformedProcedureStepRetrieveSOPClass = const WKUid._(
    "1.­2.840.10008.3.1.2.3.4",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Retrieve SOP Class",
  );
  static const kModalityPerformedProcedureStepNotificationSOPClass = const WKUid._(
    "1.­2.840.10008.3.1.2.3.5",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Notification SOP Class",
  );
  static const kDetachedResultsManagementSOPClass_Retired = const WKUid._("1.2.840.10008.3.1.2.5.1",
      UidType.kSOPClass, true, "Detached Results Management SOP Class (Retired)");
  static const kDetachedResultsManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.3.1.2.5.4",
    UidType.kMetaSOPClass,
    true,
    "Detached Results Management Meta SOP Class (Retired)",
  );
  static const kDetachedStudyManagementMetaSOPClass_Retired = const WKUid._(
      "1.2.840.10008.3.1.2.5.5",
      UidType.kMetaSOPClass,
      true,
      "Detached Study Management Meta SOP Class (Retired)");
  static const kDetachedInterpretationManagementSOPClass_Retired = const WKUid._(
    "1.2.840.10008.3.1.2.6.1",
    UidType.kSOPClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );
  static const kStorageServiceClass =
      const WKUid._("1.2.840.10008.4.2", UidType.kServiceClass, false, "Storage Service Class");
  static const kBasicFilmSessionSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.1", UidType.kSOPClass, false, "Basic Film Session SOP Class");
  static const kBasicFilmBoxSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.2", UidType.kSOPClass, false, "Basic Film Box SOP Class");
  static const kBasicGrayscaleImageBoxSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.4", UidType.kSOPClass, false, "Basic Grayscale Image Box SOP Class");
  static const kBasicColorImageBoxSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.4.1", UidType.kSOPClass, false, "Basic Color Image Box SOP Class");
  static const kReferencedImageBoxSOPClass_Retired = const WKUid._("1.2.840.10008.5.1.1.4.2",
      UidType.kSOPClass, true, "Referenced Image Box SOP Class (Retired)");
  static const kBasicGrayscalePrintManagementMetaSOPClass = const WKUid._("1.2.840.10008.5.1.1.9",
      UidType.kMetaSOPClass, false, "Basic Grayscale Print Management Meta SOP Class");
  static const kReferencedGrayscalePrintManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.1.9.1",
    UidType.kMetaSOPClass,
    true,
    "Referenced Grayscale Print Management Meta SOP Class (Retired)",
  );
  static const kPrintJobSOPClass =
      const WKUid._("1.2.840.10008.5.1.1.14", UidType.kSOPClass, false, "Print Job SOP Class");
  static const kBasicAnnotationBoxSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.15", UidType.kSOPClass, false, "Basic Annotation Box SOP Class");
  static const kPrinterSOPClass =
      const WKUid._("1.2.840.10008.5.1.1.16", UidType.kSOPClass, false, "Printer SOP Class");
  static const kPrinterConfigurationRetrievalSOPClass = const WKUid._("1.2.840.10008.5.1.1.16.376",
      UidType.kSOPClass, false, "Printer Configuration Retrieval SOP Class");
  static const kPrinterSOPInstance = const WKUid._(
      "1.2.840.10008.5.1.1.17", UidType.kWellKnownPrinterSOPInstance, false, "Printer SOP Instance");
  static const kPrinterConfigurationRetrievalSOPInstance = const WKUid._(
      "1.2.840.10008.5.1.1.17.376",
      UidType.kWellKnownPrinterSOPInstance,
      false,
      "Printer Configuration Retrieval SOP Instance");
  static const kBasicColorPrintManagementMetaSOPClass = const WKUid._("1.2.840.10008.5.1.1.18",
      UidType.kMetaSOPClass, false, "Basic Color Print Management Meta SOP Class");
  static const kReferencedColorPrintManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.1.18.1",
    UidType.kMetaSOPClass,
    true,
    "Referenced Color Print Management Meta SOP Class (Retired)",
  );
  static const kVOILUTBoxSOPClass =
      const WKUid._("1.2.840.10008.5.1.1.22", UidType.kSOPClass, false, "VOI LUT Box SOP Class");
  static const kPresentationLUTSOPClass = const WKUid._(
      "1.2.840.10008.5.1.1.23", UidType.kSOPClass, false, "Presentation LUT SOP Class");
  static const kImageOverlayBoxSOPClass_Retired = const WKUid._(
      "1.2.840.10008.5.1.1.24", UidType.kSOPClass, true, "Image Overlay Box SOP Class (Retired)");
  static const kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid._(
      "1.2.840.10008.5.1.1.24.1",
      UidType.kSOPClass,
      true,
      "Basic Print Image Overlay Box SOP Class (Retired)");
  static const kPrintQueueSOPInstance_Retired = const WKUid._("1.2.840.10008.5.1.1.25",
      UidType.kWellKnownPrintQueueSOPInstance, true, "Print Queue SOP Instance (Retired)");
  static const kPrintQueueManagementSOPClass_Retired = const WKUid._("1.2.840.10008.5.1.1.26",
      UidType.kSOPClass, true, "Print Queue Management SOP Class (Retired)");
  static const kStoredPrintStorageSOPClass_Retired = const WKUid._("1.2.840.10008.5.1.1.27",
      UidType.kSOPClass, true, "Stored Print Storage SOP Class (Retired)");
  static const kHardcopyGrayscaleImageStorageSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.1.29",
    UidType.kSOPClass,
    true,
    "Hardcopy Grayscale Image Storage SOP Class (Retired)",
  );
  static const kHardcopyColorImageStorageSOPClass_Retired = const WKUid._("1.2.840.10008.5.1.1.30",
      UidType.kSOPClass, true, "Hardcopy Color Image Storage SOP Class (Retired)");
  static const kPullPrintRequestSOPClass_Retired = const WKUid._("1.2.840.10008.5.1.1.31",
      UidType.kSOPClass, true, "Pull Print Request SOP Class (Retired)");
  static const kPullStoredPrintManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.1.32",
    UidType.kMetaSOPClass,
    true,
    "Pull Stored Print Management Meta SOP Class (Retired)",
  );
  static const kMediaCreationManagementSOPClassUID = const WKUid._("1.2.840.10008.5.1.1.33",
      UidType.kSOPClass, false, "Media Creation Management SOP Class UID");
  static const kComputedRadiographyImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.1",
      UidType.kSOPClass, false, "Computed Radiography Image Storage");
  static const kDigitalX_RayImageStorage_ForPresentation = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.1",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Presentation",
  );
  static const kDigitalX_RayImageStorage_ForProcessing = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.1.1",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Processing",
  );
  static const kDigitalMammographyX_RayImageStorage_ForPresentation = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.2",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Presentation",
  );
  static const kDigitalMammographyX_RayImageStorage_ForProcessing = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.2.1",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Processing",
  );
  static const kDigitalIntra_OralX_RayImageStorage_ForPresentation = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.3",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Presentation",
  );
  static const kDigitalIntra_OralX_RayImageStorage_ForProcessing = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.1.3.1",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Processing",
  );
  static const kCTImageStorage =
      const WKUid._("1.2.840.10008.5.1.4.1.1.2", UidType.kSOPClass, false, "CT Image Storage");
  static const kEnhancedCTImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.2.1", UidType.kSOPClass, false, "Enhanced CT Image Storage");
  static const kLegacyConvertedEnhancedCTImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.2.2",
      UidType.kSOPClass, false, "Legacy Converted Enhanced CT Image Storage");
  static const kUltrasoundMulti_frameImageStorage_Retired = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.3",
      UidType.kSOPClass,
      true,
      "Ultrasound Multi-frame Image Storage (Retired)");
  static const kUltrasoundMulti_frameImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.3.1",
      UidType.kSOPClass, false, "Ultrasound Multi-frame Image Storage");
  static const kMRImageStorage =
      const WKUid._("1.2.840.10008.5.1.4.1.1.4", UidType.kSOPClass, false, "MR Image Storage");
  static const kEnhancedMRImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.4.1", UidType.kSOPClass, false, "Enhanced MR Image Storage");
  static const kMRSpectroscopyStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.4.2", UidType.kSOPClass, false, "MR Spectroscopy Storage");
  static const kEnhancedMRColorImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.4.3", UidType.kSOPClass, false, "Enhanced MR Color Image Storage");
  static const kLegacyConvertedEnhancedMRImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.4.4",
      UidType.kSOPClass, false, "Legacy Converted Enhanced MR Image Storage");
  static const kNuclearMedicineImageStorage_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.5",
      UidType.kSOPClass, true, "Nuclear Medicine Image Storage (Retired)");
  static const kUltrasoundImageStorage_Retired = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.6", UidType.kSOPClass, true, "Ultrasound Image Storage (Retired)");
  static const kUltrasoundImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.6.1", UidType.kSOPClass, false, "Ultrasound Image Storage");
  static const kEnhancedUSVolumeStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.6.2", UidType.kSOPClass, false, "Enhanced US Volume Storage");
  static const kSecondaryCaptureImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.7", UidType.kSOPClass, false, "Secondary Capture Image Storage");
  static const kMulti_frameSingleBitSecondaryCaptureImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.7.1",
    UidType.kSOPClass,
    false,
    "Multi-frame Single Bit Secondary Capture Image Storage",
  );
  static const kMulti_frameGrayscaleByteSecondaryCaptureImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.7.2",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Byte Secondary Capture Image Storage",
  );
  static const kMulti_frameGrayscaleWordSecondaryCaptureImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.7.3",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Word Secondary Capture Image Storage",
  );
  static const kMulti_frameTrueColorSecondaryCaptureImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.7.4",
    UidType.kSOPClass,
    false,
    "Multi-frame True Color Secondary Capture Image Storage",
  );
  static const kStandaloneOverlayStorage_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.8",
      UidType.kSOPClass, true, "Standalone Overlay Storage (Retired)");
  static const kStandaloneCurveStorage_Retired = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.9", UidType.kSOPClass, true, "Standalone Curve Storage (Retired)");
  static const kWaveformStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.9.1",
      UidType.kSOPClass, true, "Waveform Storage - Trial (Retired)");
  static const ktwelve_lead_12ECGWaveformStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.9.1.1",
      UidType.kSOPClass, false, "twelve-lead(12) ECG Waveform Storage");
  static const kGeneralECGWaveformStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.9.1.2", UidType.kSOPClass, false, "General ECG Waveform Storage");
  static const kAmbulatoryECGWaveformStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.9.1.3",
      UidType.kSOPClass, false, "Ambulatory ECG Waveform Storage");
  static const kHemodynamicWaveformStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.9.2.1", UidType.kSOPClass, false, "Hemodynamic Waveform Storage");
  static const kCardiacElectrophysiologyWaveformStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.9.3.1",
    UidType.kSOPClass,
    false,
    "Cardiac Electrophysiology Waveform Storage",
  );
  static const kBasicVoiceAudioWaveformStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.9.4.1",
      UidType.kSOPClass, false, "Basic Voice Audio Waveform Storage");
  static const kGeneralAudioWaveformStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.9.4.2",
      UidType.kSOPClass, false, "General Audio Waveform Storage");
  static const kArterialPulseWaveformStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.9.5.1",
      UidType.kSOPClass, false, "Arterial Pulse Waveform Storage");
  static const kRespiratoryWaveformStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.9.6.1", UidType.kSOPClass, false, "Respiratory Waveform Storage");
  static const kStandaloneModalityLUTStorage_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.10",
      UidType.kSOPClass, true, "Standalone Modality LUT Storage (Retired)");
  static const kStandaloneVOILUTStorage_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.11",
      UidType.kSOPClass, true, "Standalone VOI LUT Storage (Retired)");
  static const kGrayscaleSoftcopyPresentationStateStorageSOPClass = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.11.1",
    UidType.kSOPClass,
    false,
    "Grayscale Softcopy Presentation State Storage SOP Class",
  );
  static const kColorSoftcopyPresentationStateStorageSOPClass = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.11.2",
    UidType.kSOPClass,
    false,
    "Color Softcopy Presentation State Storage SOP Class",
  );
  static const kPseudo_ColorSoftcopyPresentationStateStorageSOPClass = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.11.3",
    UidType.kSOPClass,
    false,
    "Pseudo-Color Softcopy Presentation State Storage SOP Class",
  );
  static const kBlendingSoftcopyPresentationStateStorageSOPClass = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.11.4",
    UidType.kSOPClass,
    false,
    "Blending Softcopy Presentation State Storage SOP Class",
  );
  static const kXA_XRFGrayscaleSoftcopyPresentationStateStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.11.5",
    UidType.kSOPClass,
    false,
    "XA/XRF Grayscale Softcopy Presentation State Storage",
  );
  static const kX_RayAngiographicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.12.1",
      UidType.kSOPClass, false, "X-Ray Angiographic Image Storage");
  static const kEnhancedXAImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.12.1.1", UidType.kSOPClass, false, "Enhanced XA Image Storage");
  static const kX_RayRadiofluoroscopicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.12.2",
      UidType.kSOPClass, false, "X-Ray Radiofluoroscopic Image Storage");
  static const kEnhancedXRFImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.12.2.1", UidType.kSOPClass, false, "Enhanced XRF Image Storage");
  static const kX_RayAngiographicBi_PlaneImageStorage_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.12.3",
    UidType.kSOPClass,
    true,
    "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
  );
  static const kX_Ray3DAngiographicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.13.1.1",
      UidType.kSOPClass, false, "X-Ray 3D Angiographic Image Storage");
  static const kX_Ray3DCraniofacialImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.13.1.2",
      UidType.kSOPClass, false, "X-Ray 3D Craniofacial Image Storage");
  static const kBreastTomosynthesisImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.13.1.3",
      UidType.kSOPClass, false, "Breast Tomosynthesis Image Storage");
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.14.1",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Presentation",
  );
  static const kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.14.2",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Processing",
  );
  static const kNuclearMedicineImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.20", UidType.kSOPClass, false, "Nuclear Medicine Image Storage");
  static const kRawDataStorage =
      const WKUid._("1.2.840.10008.5.1.4.1.1.66", UidType.kSOPClass, false, "Raw Data Storage");
  static const kSpatialRegistrationStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.66.1", UidType.kSOPClass, false, "Spatial Registration Storage");
  static const kSpatialFiducialsStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.66.2", UidType.kSOPClass, false, "Spatial Fiducials Storage");
  static const kDeformableSpatialRegistrationStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.66.3",
      UidType.kSOPClass, false, "Deformable Spatial Registration Storage");
  static const kSegmentationStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.66.4", UidType.kSOPClass, false, "Segmentation Storage");
  static const kSurfaceSegmentationStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.66.5", UidType.kSOPClass, false, "Surface Segmentation Storage");
  static const kRealWorldValueMappingStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.67", UidType.kSOPClass, false, "Real World Value Mapping Storage");
  static const kSurfaceScanMeshStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.68.1", UidType.kSOPClass, false, "Surface Scan Mesh Storage");
  static const kSurfaceScanPointCloudStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.68.2",
      UidType.kSOPClass, false, "Surface Scan Point Cloud Storage");
  static const kVLImageStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1",
      UidType.kSOPClass, true, "VL Image Storage - Trial (Retired)");
  static const kVLMulti_frameImageStorage_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.77.2",
    UidType.kSOPClass,
    true,
    "VL Multi-frame Image Storage - Trial (Retired)",
  );
  static const kVLEndoscopicImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.77.1.1", UidType.kSOPClass, false, "VL Endoscopic Image Storage");
  static const kVideoEndoscopicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.1.1",
      UidType.kSOPClass, false, "Video Endoscopic Image Storage");
  static const kVLMicroscopicImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.77.1.2", UidType.kSOPClass, false, "VL Microscopic Image Storage");
  static const kVideoMicroscopicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.2.1",
      UidType.kSOPClass, false, "Video Microscopic Image Storage");
  static const kVLSlide_CoordinatesMicroscopicImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.77.1.3",
    UidType.kSOPClass,
    false,
    "VL Slide-Coordinates Microscopic Image Storage",
  );
  static const kVLPhotographicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.4",
      UidType.kSOPClass, false, "VL Photographic Image Storage");
  static const kVideoPhotographicImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.4.1",
      UidType.kSOPClass, false, "Video Photographic Image Storage");
  static const kOphthalmicPhotography8BitImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.77.1.5.1",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 8 Bit Image Storage",
  );
  static const kOphthalmicPhotography16BitImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.77.1.5.2",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 16 Bit Image Storage",
  );
  static const kStereometricRelationshipStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.5.3",
      UidType.kSOPClass, false, "Stereometric Relationship Storage");
  static const kOphthalmicTomographyImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.5.4",
      UidType.kSOPClass, false, "Ophthalmic Tomography Image Storage");
  static const kVLWholeSlideMicroscopyImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.77.1.6",
      UidType.kSOPClass, false, "VL Whole Slide Microscopy Image Storage");
  static const kLensometryMeasurementsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.1",
      UidType.kSOPClass, false, "Lensometry Measurements Storage");
  static const kAutorefractionMeasurementsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.2",
      UidType.kSOPClass, false, "Autorefraction Measurements Storage");
  static const kKeratometryMeasurementsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.3",
      UidType.kSOPClass, false, "Keratometry Measurements Storage");
  static const kSubjectiveRefractionMeasurementsStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.78.4",
    UidType.kSOPClass,
    false,
    "Subjective Refraction Measurements Storage",
  );
  static const kVisualAcuityMeasurementsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.5",
      UidType.kSOPClass, false, "Visual Acuity Measurements Storage");
  static const kSpectaclePrescriptionReportStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.6",
      UidType.kSOPClass, false, "Spectacle Prescription Report Storage");
  static const kOphthalmicAxialMeasurementsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.7",
      UidType.kSOPClass, false, "Ophthalmic Axial Measurements Storage");
  static const kIntraocularLensCalculationsStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.78.8",
      UidType.kSOPClass, false, "Intraocular Lens Calculations Storage");
  static const kMacularGridThicknessandVolumeReportStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.79.1",
    UidType.kSOPClass,
    false,
    "Macular Grid Thickness and Volume Report Storage",
  );
  static const kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.80.1",
    UidType.kSOPClass,
    false,
    "Ophthalmic Visual Field Static Perimetry Measurements Storage",
  );
  static const kOphthalmicThicknessMapStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.81.1",
      UidType.kSOPClass, false, "Ophthalmic Thickness Map Storage");
  static const kCornealTopographyMapStorage = const WKUid._("11.2.840.10008.5.1.4.1.1.82.1",
      UidType.kSOPClass, false, "Corneal Topography Map Storage");
  static const kTextSRStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.88.1",
      UidType.kSOPClass, true, "Text SR Storage - Trial (Retired)");
  static const kAudioSRStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.88.2",
      UidType.kSOPClass, true, "Audio SR Storage - Trial (Retired)");
  static const kDetailSRStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.88.3",
      UidType.kSOPClass, true, "Detail SR Storage - Trial (Retired)");
  static const kComprehensiveSRStorage_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.88.4",
      UidType.kSOPClass, true, "Comprehensive SR Storage - Trial (Retired)");
  static const kBasicTextSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.11", UidType.kSOPClass, false, "Basic Text SR Storage");
  static const kEnhancedSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.22", UidType.kSOPClass, false, "Enhanced SR Storage");
  static const kComprehensiveSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.33", UidType.kSOPClass, false, "Comprehensive SR Storage");
  static const kComprehensive3DSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.34", UidType.kSOPClass, false, "Comprehensive 3D SR Storage");
  static const kProcedureLogStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.40", UidType.kSOPClass, false, "Procedure Log Storage");
  static const kMammographyCADSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.50", UidType.kSOPClass, false, "Mammography CAD SR Storage");
  static const kKeyObjectSelectionDocumentStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.88.59",
      UidType.kSOPClass, false, "Key Object Selection Document Storage");
  static const kChestCADSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.65", UidType.kSOPClass, false, "Chest CAD SR Storage");
  static const kX_RayRadiationDoseSRStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.88.67",
      UidType.kSOPClass, false, "X-Ray Radiation Dose SR Storage");
  static const kColonCADSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.69", UidType.kSOPClass, false, "Colon CAD SR Storage");
  static const kImplantationPlanSRStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.88.70", UidType.kSOPClass, false, "Implantation Plan SR Storage");
  static const kEncapsulatedPDFStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.104.1", UidType.kSOPClass, false, "Encapsulated PDF Storage");
  static const kEncapsulatedCDAStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.104.2", UidType.kSOPClass, false, "Encapsulated CDA Storage");
  static const kPositronEmissionTomographyImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.128",
      UidType.kSOPClass,
      false,
      "Positron Emission Tomography Image Storage");
  static const kLegacyConvertedEnhancedPETImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.128.1",
    UidType.kSOPClass,
    false,
    "Legacy Converted Enhanced PET Image Storage",
  );
  static const kStandalonePETCurveStorage_Retired = const WKUid._("1.2.840.10008.5.1.4.1.1.129",
      UidType.kSOPClass, true, "Standalone PET Curve Storage (Retired)");
  static const kEnhancedPETImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.130", UidType.kSOPClass, false, "Enhanced PET Image Storage");
  static const kBasicStructuredDisplayStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.131",
      UidType.kSOPClass, false, "Basic Structured Display Storage");
  static const kRTImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.481.1", UidType.kSOPClass, false, "RT Image Storage");
  static const kRTDoseStorage =
      const WKUid._("1.2.840.10008.5.1.4.1.1.481.2", UidType.kSOPClass, false, "RT Dose Storage");
  static const kRTStructureSetStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.481.3", UidType.kSOPClass, false, "RT Structure Set Storage");
  static const kRTBeamsTreatmentRecordStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.481.4",
      UidType.kSOPClass, false, "RT Beams Treatment Record Storage");
  static const kRTPlanStorage =
      const WKUid._("1.2.840.10008.5.1.4.1.1.481.5", UidType.kSOPClass, false, "RT Plan Storage");
  static const kRTBrachyTreatmentRecordStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.481.6",
      UidType.kSOPClass, false, "RT Brachy Treatment Record Storage");
  static const kRTTreatmentSummaryRecordStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.481.7",
      UidType.kSOPClass, false, "RT Treatment Summary Record Storage");
  static const kRTIonPlanStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.481.8", UidType.kSOPClass, false, "RT Ion Plan Storage");
  static const kRTIonBeamsTreatmentRecordStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.481.9",
      UidType.kSOPClass, false, "RT Ion Beams Treatment Record Storage");
  static const kDICOSCTImageStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.1",
    UidType.kSOPClass,
    false,
    "DICOS CT Image Storage",
  );
  static const kDICOSDigitalX_RayImageStorage_ForPresentation = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.2.1",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Presentation",
  );
  static const kDICOSDigitalX_RayImageStorage_ForProcessing = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.2.2",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Processing",
  );
  static const kDICOSThreatDetectionReportStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.3",
    UidType.kSOPClass,
    false,
    "DICOS Threat Detection Report Storage",
  );
  static const kDICOS2DAITStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.4",
    UidType.kSOPClass,
    false,
    "DICOS 2D AIT Storage",
  );
  static const kDICOS3DAITStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.5",
    UidType.kSOPClass,
    false,
    "DICOS 3D AIT Storage",
  );
  static const kDICOSQuadrupoleResonanceStorage = const WKUid._(
    "1.2.840.10008.5.1.4.1.1.501.6",
    UidType.kSOPClass,
    false,
    "DICOS Quadrupole Resonance (QR) Storage",
  );
  static const kEddyCurrentImageStorage = const WKUid._(
      "1.2.840.10008.5.1.4.1.1.601.1", UidType.kSOPClass, false, "Eddy Current Image Storage");
  static const kEddyCurrentMulti_frameImageStorage = const WKUid._("1.2.840.10008.5.1.4.1.1.601.2",
      UidType.kSOPClass, false, "Eddy Current Multi-frame Image Storage");
  static const kPatientRootQueryRetrieveInformationModel_FIND = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.1.1",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - FIND",
  );
  static const kPatientRootQueryRetrieveInformationModel_MOVE = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.1.2",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - MOVE",
  );
  static const kPatientRootQueryRetrieveInformationModel_GET = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.1.3",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - GET",
  );
  static const kStudyRootQueryRetrieveInformationModel_FIND = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.2.1",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - FIND",
  );
  static const kStudyRootQueryRetrieveInformationModel_MOVE = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.2.2",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - MOVE",
  );
  static const kStudyRootQueryRetrieveInformationModel_GET = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.2.3",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - GET",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.3.1",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.3.2",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
  );
  static const kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.3.3",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
  );
  static const kCompositeInstanceRootRetrieve_MOVE = const WKUid._("1.2.840.10008.5.1.4.1.2.4.2",
      UidType.kSOPClass, false, "Composite Instance Root Retrieve - MOVE");
  static const kCompositeInstanceRootRetrieve_GET = const WKUid._("1.2.840.10008.5.1.4.1.2.4.3",
      UidType.kSOPClass, false, "Composite Instance Root Retrieve - GET");
  static const kCompositeInstanceRetrieveWithoutBulkData_GET = const WKUid._(
    "1.2.840.10008.5.1.4.1.2.5.3",
    UidType.kSOPClass,
    false,
    "Composite Instance Retrieve Without Bulk Data - GET",
  );
  static const kModalityWorklistInformationModel_FIND = const WKUid._("1.2.840.10008.5.1.4.31",
      UidType.kSOPClass, false, "Modality Worklist Information Model - FIND");
  static const kGeneralPurposeWorklistInformationModel_FIND_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.32.1",
    UidType.kSOPClass,
    true,
    "General Purpose Worklist Information Model - FIND (Retired)",
  );
  static const kGeneralPurposeScheduledProcedureStepSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.32.2",
    UidType.kSOPClass,
    true,
    "General Purpose Scheduled Procedure Step SOP Class (Retired)",
  );
  static const kGeneralPurposePerformedProcedureStepSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.32.3",
    UidType.kSOPClass,
    true,
    "General Purpose Performed Procedure Step SOP Class (Retired)",
  );
  static const kGeneralPurposeWorklistManagementMetaSOPClass_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.32",
    UidType.kMetaSOPClass,
    true,
    "General Purpose Worklist Management Meta SOP Class (Retired)",
  );
  static const kInstanceAvailabilityNotificationSOPClass = const WKUid._("1.2.840.10008.5.1.4.33",
      UidType.kSOPClass, false, "Instance Availability Notification SOP Class");
  static const kRTBeamsDeliveryInstructionStorage_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.1",
    UidType.kSOPClass,
    true,
    "RT Beams Delivery Instruction Storage - Trial (Retired)",
  );
  static const kRTConventionalMachineVerification_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.2",
    UidType.kSOPClass,
    true,
    "RT Conventional Machine Verification - Trial (Retired)",
  );
  static const kRTIonMachineVerification_Trial_Retired = const WKUid._("1.2.840.10008.5.1.4.34.3",
      UidType.kSOPClass, true, "RT Ion Machine Verification - Trial (Retired)");
  static const kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.4",
    UidType.kServiceClass,
    true,
    "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_PushSOPClass_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.4.1",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Push SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_WatchSOPClass_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.4.2",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_PullSOPClass_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.4.3",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
  );
  static const kUnifiedProcedureStep_EventSOPClass_Trial_Retired = const WKUid._(
    "1.2.840.10008.5.1.4.34.4.4",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Event SOP Class - Trial (Retired)",
  );
  static const kUnifiedWorklistandProcedureStepSOPInstance = const WKUid._(
      "1.2.840.10008.5.1.4.34.5",
      UidType.kWellKnownSOPInstance,
      false,
      "Unified Worklist and Procedure Step SOP Instance");
  static const kUnifiedWorklistandProcedureStepServiceClass = const WKUid._(
    "1.2.840.10008.5.1.4.34.6",
    UidType.kServiceClass,
    false,
    "Unified Worklist and Procedure Step Service Class",
  );
  static const kUnifiedProcedureStep_PushSOPClass = const WKUid._("1.2.840.10008.5.1.4.34.6.1",
      UidType.kSOPClass, false, "Unified Procedure Step - Push SOP Class");
  static const kUnifiedProcedureStep_WatchSOPClass = const WKUid._("1.2.840.10008.5.1.4.34.6.2",
      UidType.kSOPClass, false, "Unified Procedure Step - Watch SOP Class");
  static const kUnifiedProcedureStep_PullSOPClass = const WKUid._("1.2.840.10008.5.1.4.34.6.3",
      UidType.kSOPClass, false, "Unified Procedure Step - Pull SOP Class");
  static const kUnifiedProcedureStep_EventSOPClass = const WKUid._("1.2.840.10008.5.1.4.34.6.4",
      UidType.kSOPClass, false, "Unified Procedure Step - Event SOP Class");
  static const kRTBeamsDeliveryInstructionStorage = const WKUid._("1.2.840.10008.5.1.4.34.7",
      UidType.kSOPClass, false, "RT Beams Delivery Instruction Storage");
  static const kRTConventionalMachineVerification = const WKUid._("1.2.840.10008.5.1.4.34.8",
      UidType.kSOPClass, false, "RT Conventional Machine Verification");
  static const kRTIonMachineVerification = const WKUid._(
      "1.2.840.10008.5.1.4.34.9", UidType.kSOPClass, false, "RT Ion Machine Verification");
  static const kGeneralRelevantPatientInformationQuery = const WKUid._("1.2.840.10008.5.1.4.37.1",
      UidType.kSOPClass, false, "General Relevant Patient Information Query");
  static const kBreastImagingRelevantPatientInformationQuery = const WKUid._(
    "1.2.840.10008.5.1.4.37.2",
    UidType.kSOPClass,
    false,
    "Breast Imaging Relevant Patient Information Query",
  );
  static const kCardiacRelevantPatientInformationQuery = const WKUid._("1.2.840.10008.5.1.4.37.3",
      UidType.kSOPClass, false, "Cardiac Relevant Patient Information Query");
  static const kHangingProtocolStorage = const WKUid._(
      "1.2.840.10008.5.1.4.38.1", UidType.kSOPClass, false, "Hanging Protocol Storage");
  static const kHangingProtocolInformationModel_FIND = const WKUid._("1.2.840.10008.5.1.4.38.2",
      UidType.kSOPClass, false, "Hanging Protocol Information Model - FIND");
  static const kHangingProtocolInformationModel_MOVE = const WKUid._("1.2.840.10008.5.1.4.38.3",
      UidType.kSOPClass, false, "Hanging Protocol Information Model - MOVE");
  static const kHangingProtocolInformationModel_GET = const WKUid._("1.2.840.10008.5.1.4.38.4",
      UidType.kSOPClass, false, "Hanging Protocol Information Model - GET");
  static const kColorPaletteStorage = const WKUid._(
      "1.2.840.10008.5.1.4.39.1", UidType.kTransfer, false, "Color Palette Storage");
  static const kColorPaletteInformationModel_FIND = const WKUid._("1.2.840.10008.5.1.4.39.2",
      UidType.kQueryRetrieve, false, "Color Palette Information Model - FIND");
  static const kColorPaletteInformationModel_MOVE = const WKUid._("1.2.840.10008.5.1.4.39.3",
      UidType.kQueryRetrieve, false, "Color Palette Information Model - MOVE");
  static const kColorPaletteInformationModel_GET = const WKUid._("1.2.840.10008.5.1.4.39.4",
      UidType.kQueryRetrieve, false, "Color Palette Information Model - GET");
  static const kProductCharacteristicsQuerySOPClass = const WKUid._("1.2.840.10008.5.1.4.41",
      UidType.kSOPClass, false, "Product Characteristics Query SOP Class");
  static const kSubstanceApprovalQuerySOPClass = const WKUid._(
      "1.2.840.10008.5.1.4.42", UidType.kSOPClass, false, "Substance Approval Query SOP Class");
  static const kGenericImplantTemplateStorage = const WKUid._(
      "1.2.840.10008.5.1.4.43.1", UidType.kSOPClass, false, "Generic Implant Template Storage");
  static const kGenericImplantTemplateInformationModel_FIND = const WKUid._(
    "1.2.840.10008.5.1.4.43.2",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - FIND",
  );
  static const kGenericImplantTemplateInformationModel_MOVE = const WKUid._(
    "1.2.840.10008.5.1.4.43.3",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - MOVE",
  );
  static const kGenericImplantTemplateInformationModel_GET = const WKUid._(
      "1.2.840.10008.5.1.4.43.4",
      UidType.kSOPClass,
      false,
      "Generic Implant Template Information Model - GET");
  static const kImplantAssemblyTemplateStorage = const WKUid._(
      "1.2.840.10008.5.1.4.44.1", UidType.kSOPClass, false, "Implant Assembly Template Storage");
  static const kImplantAssemblyTemplateInformationModel_FIND = const WKUid._(
    "1.2.840.10008.5.1.4.44.2",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - FIND",
  );
  static const kImplantAssemblyTemplateInformationModel_MOVE = const WKUid._(
    "1.2.840.10008.5.1.4.44.3",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - MOVE",
  );
  static const kImplantAssemblyTemplateInformationModel_GET = const WKUid._(
    "1.2.840.10008.5.1.4.44.4",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - GET",
  );
  static const kImplantTemplateGroupStorage = const WKUid._(
      "1.2.840.10008.5.1.4.45.1", UidType.kSOPClass, false, "Implant Template Group Storage");
  static const kImplantTemplateGroupInformationModel_FIND = const WKUid._(
      "1.2.840.10008.5.1.4.45.2",
      UidType.kSOPClass,
      false,
      "Implant Template Group Information Model - FIND");
  static const kImplantTemplateGroupInformationModel_MOVE = const WKUid._(
      "1.2.840.10008.5.1.4.45.3",
      UidType.kSOPClass,
      false,
      "Implant Template Group Information Model - MOVE");
  static const kImplantTemplateGroupInformationModel_GET = const WKUid._("1.2.840.10008.5.1.4.45.4",
      UidType.kSOPClass, false, "Implant Template Group Information Model - GET");
  static const kNativeDICOMModel = const WKUid._(
      "1.2.840.10008.7.1.1", UidType.kApplicationHostingModel, false, "Native DICOM Model");
  static const kAbstractMulti_DimensionalImageModel = const WKUid._("1.2.840.10008.7.1.2",
      UidType.kApplicationHostingModel, false, "Abstract Multi-Dimensional Image Model");
  static const kdicomDeviceName =
      const WKUid._("1.2.840.10008.15.0.3.1", UidType.kLdapOid, false, "dicomDeviceName");
  static const kdicomDescription =
      const WKUid._("1.2.840.10008.15.0.3.2", UidType.kLdapOid, false, "dicomDescription");
  static const kdicomManufacturer =
      const WKUid._("1.2.840.10008.15.0.3.3", UidType.kLdapOid, false, "dicomManufacturer");
  static const kdicomManufacturerModelName = const WKUid._(
      "1.2.840.10008.15.0.3.4", UidType.kLdapOid, false, "dicomManufacturerModelName");
  static const kdicomSoftwareVersion =
      const WKUid._("1.2.840.10008.15.0.3.5", UidType.kLdapOid, false, "dicomSoftwareVersion");
  static const kdicomVendorData =
      const WKUid._("1.2.840.10008.15.0.3.6", UidType.kLdapOid, false, "dicomVendorData");
  static const kdicomAETitle =
      const WKUid._("1.2.840.10008.15.0.3.7", UidType.kLdapOid, false, "dicomAETitle");
  static const kdicomNetworkConnectionReference = const WKUid._(
      "1.2.840.10008.15.0.3.8", UidType.kLdapOid, false, "dicomNetworkConnectionReference");
  static const kdicomApplicationCluster =
      const WKUid._("1.2.840.10008.15.0.3.9", UidType.kLdapOid, false, "dicomApplicationCluster");
  static const kdicomAssociationInitiator = const WKUid._(
      "1.2.840.10008.15.0.3.10", UidType.kLdapOid, false, "dicomAssociationInitiator");
  static const kdicomAssociationAcceptor = const WKUid._(
      "1.2.840.10008.15.0.3.11", UidType.kLdapOid, false, "dicomAssociationAcceptor");
  static const kdicomHostname =
      const WKUid._("1.2.840.10008.15.0.3.12", UidType.kLdapOid, false, "dicomHostname");
  static const kdicomPort =
      const WKUid._("1.2.840.10008.15.0.3.13", UidType.kLdapOid, false, "dicomPort");
  static const kdicomSOPClass =
      const WKUid._("1.2.840.10008.15.0.3.14", UidType.kLdapOid, false, "dicomSOPClass");
  static const kdicomTransferRole =
      const WKUid._("1.2.840.10008.15.0.3.15", UidType.kLdapOid, false, "dicomTransferRole");
  static const kdicomTransferSyntax =
      const WKUid._("1.2.840.10008.15.0.3.16", UidType.kLdapOid, false, "dicomTransferSyntax");
  static const kdicomPrimaryDeviceType =
      const WKUid._("1.2.840.10008.15.0.3.17", UidType.kLdapOid, false, "dicomPrimaryDeviceType");
  static const kdicomRelatedDeviceReference = const WKUid._(
      "1.2.840.10008.15.0.3.18", UidType.kLdapOid, false, "dicomRelatedDeviceReference");
  static const kdicomPreferredCalledAETitle = const WKUid._(
      "1.2.840.10008.15.0.3.19", UidType.kLdapOid, false, "dicomPreferredCalledAETitle");
  static const kdicomTLSCyphersuite =
      const WKUid._("1.2.840.10008.15.0.3.20", UidType.kLdapOid, false, "dicomTLSCyphersuite");
  static const kdicomAuthorizedNodeCertificateReference = const WKUid._("1.2.840.10008.15.0.3.21",
      UidType.kLdapOid, false, "dicomAuthorizedNodeCertificateReference");
  static const kdicomThisNodeCertificateReference = const WKUid._(
      "1.2.840.10008.15.0.3.22", UidType.kLdapOid, false, "dicomThisNodeCertificateReference");
  static const kdicomInstalled =
      const WKUid._("1.2.840.10008.15.0.3.23", UidType.kLdapOid, false, "dicomInstalled");
  static const kdicomStationName =
      const WKUid._("1.2.840.10008.15.0.3.24", UidType.kLdapOid, false, "dicomStationName");
  static const kdicomDeviceSerialNumber = const WKUid._(
      "1.2.840.10008.15.0.3.25", UidType.kLdapOid, false, "dicomDeviceSerialNumber");
  static const kdicomInstitutionName =
      const WKUid._("1.2.840.10008.15.0.3.26", UidType.kLdapOid, false, "dicomInstitutionName");
  static const kdicomInstitutionAddress = const WKUid._(
      "1.2.840.10008.15.0.3.27", UidType.kLdapOid, false, "dicomInstitutionAddress");
  static const kdicomInstitutionDepartmentName = const WKUid._(
      "1.2.840.10008.15.0.3.28", UidType.kLdapOid, false, "dicomInstitutionDepartmentName");
  static const kdicomIssuerOfPatientID =
      const WKUid._("1.2.840.10008.15.0.3.29", UidType.kLdapOid, false, "dicomIssuerOfPatientID");
  static const kdicomPreferredCallingAETitle = const WKUid._(
      "1.2.840.10008.15.0.3.30", UidType.kLdapOid, false, "dicomPreferredCallingAETitle");
  static const kdicomSupportedCharacterSet = const WKUid._(
      "1.2.840.10008.15.0.3.31", UidType.kLdapOid, false, "dicomSupportedCharacterSet");
  static const kdicomConfigurationRoot =
      const WKUid._("1.2.840.10008.15.0.4.1", UidType.kLdapOid, false, "dicomConfigurationRoot");
  static const kdicomDevicesRoot =
      const WKUid._("1.2.840.10008.15.0.4.2", UidType.kLdapOid, false, "dicomDevicesRoot");
  static const kdicomUniqueAETitlesRegistryRoot = const WKUid._(
      "1.2.840.10008.15.0.4.3", UidType.kLdapOid, false, "dicomUniqueAETitlesRegistryRoot");
  static const kdicomDevice =
      const WKUid._("1.2.840.10008.15.0.4.4", UidType.kLdapOid, false, "dicomDevice");
  static const kdicomNetworkAE =
      const WKUid._("1.2.840.10008.15.0.4.5", UidType.kLdapOid, false, "dicomNetworkAE");
  static const kdicomNetworkConnection =
      const WKUid._("1.2.840.10008.15.0.4.6", UidType.kLdapOid, false, "dicomNetworkConnection");
  static const kdicomUniqueAETitle =
      const WKUid._("1.2.840.10008.15.0.4.7", UidType.kLdapOid, false, "dicomUniqueAETitle");
  static const kdicomTransferCapability =
      const WKUid._("1.2.840.10008.15.0.4.8", UidType.kLdapOid, false, "dicomTransferCapability");
  static const kUniversalCoordinatedTime = const WKUid._("1.2.840.10008.15.1.1",
      UidType.kSynchronizationFrameOfReference, false, "Universal Coordinated Time");
}
