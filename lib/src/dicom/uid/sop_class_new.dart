// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

part of odw.sdk.dictionary.uid;

//TODO: Finish this class and write Unit test.

class SopClassUid extends WKUid {
  static const String classLink = 'TODO link';

  const SopClassUid(String uid, WKUidType type, bool isRetired, String name)
      : super(uid, type, isRetired, name);

  //TODO: create UidType class
  bool get isSopClass => true;

  //TODO: Make this print SOP Class
  String toString() => '$runtimeType($string)';

  //TODO: when other classes are implemented convert to lookup the uidString
  //in each class.
  static SopClassUid lookup(String uidString) => members[uidString];

  //TODO: verify that all SOPClass Definitions are present

  static const kVerificationSOPClass =
      const SopClassUid("1.2.840.10008.1.1", WKUidType.kSopClass, false, "Verification SOP Class");

  static const kMediaStorageDirectoryStorage = const WKUid(
      "1.2.840.10008.1.3.10", WKUidType.kSopClass, false, "Media Storage Directory Storage");

  static const kBasicStudyContentNotificationSOPClass_Retired = const WKUid("1.2.840.10008.1.9",
      WKUidType.kSopClass, true, "Basic Study Content Notification SOP Class (Retired)");
  static const kStorageCommitmentPushModelSOPClass = const WKUid(
      "1.2.840.10008.1.20.1", WKUidType.kSopClass, true, "Storage Commitment Push Model SOP Class");

  static const kStorageCommitmentPullModelSOPClass_Retired = const WKUid("1.2.840.10008.1.20.2",
      WKUidType.kSopClass, true, "Storage Commitment Pull Model SOP Class (Retired)");

  static const kProceduralEventLoggingSOPClass = const WKUid(
      "1.2.840.10008.1.40", WKUidType.kSopClass, false, "Procedural Event Logging SOP Class");

  static const kSubstanceAdministrationLoggingSOPClass = const WKUid("1.2.840.10008.1.42",
      WKUidType.kSopClass, false, "Substance Administration Logging SOP Class");
  static const kDetachedPatientManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.1.1",
      WKUidType.kSopClass, true, "Detached Patient Management SOP Class (Retired)");

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
  static const kDetachedInterpretationManagementSOPClass_Retired = const WKUid(
    "1.2.840.10008.3.1.2.6.1",
    WKUidType.kSopClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );

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
  static const kPrintJobSOPClass =
      const WKUid("1.2.840.10008.5.1.1.14", WKUidType.kSopClass, false, "Print Job SOP Class");
  static const kBasicAnnotationBoxSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.15", WKUidType.kSopClass, false, "Basic Annotation Box SOP Class");
  static const kPrinterSOPClass =
      const WKUid("1.2.840.10008.5.1.1.16", WKUidType.kSopClass, false, "Printer SOP Class");
  static const kPrinterConfigurationRetrievalSOPClass = const WKUid("1.2.840.10008.5.1.1.16.376",
      WKUidType.kSopClass, false, "Printer Configuration Retrieval SOP Class");
  static const kVOILUTBoxSOPClass =
      const WKUid("1.2.840.10008.5.1.1.22", WKUidType.kSopClass, false, "VOI LUT Box SOP Class");
  static const kPresentationLUTSOPClass = const WKUid(
      "1.2.840.10008.5.1.1.23", WKUidType.kSopClass, false, "Presentation LUT SOP Class");
  static const kImageOverlayBoxSOPClass_Retired = const WKUid(
      "1.2.840.10008.5.1.1.24", WKUidType.kSopClass, true, "Image Overlay Box SOP Class (Retired)");
  static const kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24.1",
      WKUidType.kSopClass, true, "Basic Print Image Overlay Box SOP Class (Retired)");

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
      "1.2.840.10008.5.1.4.1.1.501.1", WKUidType.kSopClass, false, "DICOS CT Image Storage");
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
  static const kDICOSThreatDetectionReportStorage = const WKUid("1.2.840.10008.5.1.4.1.1.501.3",
      WKUidType.kSopClass, false, "DICOS Threat Detection Report Storage");
  static const kDICOS2DAITStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.4", WKUidType.kSopClass, false, "DICOS 2D AIT Storage");
  static const kDICOS3DAITStorage = const WKUid(
      "1.2.840.10008.5.1.4.1.1.501.5", WKUidType.kSopClass, false, "DICOS 3D AIT Storage");
  static const kDICOSQuadrupoleResonanceStorage = const WKUid("1.2.840.10008.5.1.4.1.1.501.6",
      WKUidType.kSopClass, false, "DICOS Quadrupole Resonance (QR) Storage");
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
  static const kGenericImplantTemplateInformationModel_GET =
    const WKUid("1.2.840.10008.5.1.4.43.4",
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


//TODO: finish Map

  static const Map<String, SopClassUid> members = const <String, SopClassUid> {

  };
}
