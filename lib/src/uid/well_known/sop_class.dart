// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/uid/uid_type.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';

//TODO: Finish this class and write Unit test.

class SopClassUid extends WKUid {
  const SopClassUid(String uid, UidType type, bool isRetired, String name)
      : super(uid, type, isRetired, name);

  //TODO: create UidType class
  bool get isSopClass => true;

  @override
  String get info => '$runtimeType($asString)';

  @override
  String toString() => asString;

  //TODO: when other classes are implemented convert to lookup the uidString
  //in each class.
  static SopClassUid lookup(String uidString) => members[uidString];

  //TODO: verify that all SOPClass Definitions are present
  static const SopClassUid kVerificationSOPClass = const SopClassUid(
      "1.2.840.10008.1.1", UidType.kSOPClass, false, "Verification SOP Class");

  static const SopClassUid kMediaStorageDirectoryStorage = const SopClassUid(
      "1.2.840.10008.1.3.10",
      UidType.kSOPClass,
      false,
      "Media Storage Directory Storage");

  static const SopClassUid kBasicStudyContentNotificationSOPClass_Retired =
      const SopClassUid("1.2.840.10008.1.9", UidType.kSOPClass, true,
          "Basic Study Content Notification SOP Class (Retired)");
  static const SopClassUid kStorageCommitmentPushModelSOPClass =
      const SopClassUid("1.2.840.10008.1.20.1", UidType.kSOPClass, true,
          "Storage Commitment Push Model SOP Class");

  static const SopClassUid kStorageCommitmentPullModelSOPClass_Retired =
      const SopClassUid("1.2.840.10008.1.20.2", UidType.kSOPClass, true,
          "Storage Commitment Pull Model SOP Class (Retired)");

  static const SopClassUid kProceduralEventLoggingSOPClass = const SopClassUid(
      "1.2.840.10008.1.40",
      UidType.kSOPClass,
      false,
      "Procedural Event Logging SOP Class");

  static const SopClassUid kSubstanceAdministrationLoggingSOPClass =
      const SopClassUid("1.2.840.10008.1.42", UidType.kSOPClass, false,
          "Substance Administration Logging SOP Class");
  static const SopClassUid kDetachedPatientManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.3.1.2.1.1", UidType.kSOPClass, true,
          "Detached Patient Management SOP Class (Retired)");

  static const SopClassUid kDetachedVisitManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.3.1.2.2.1", UidType.kSOPClass, true,
          "Detached Visit Management SOP Class (Retired)");
  static const SopClassUid kDetachedStudyManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.3.1.2.3.1", UidType.kSOPClass, true,
          "Detached Study Management SOP Class (Retired)");
  static const SopClassUid kStudyComponentManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.3.1.2.3.2", UidType.kSOPClass, true,
          "Study Component Management SOP Class (Retired)");
  static const SopClassUid kModalityPerformedProcedureStepSOPClass =
      const SopClassUid("1.­2.840.10008.3.1.2.3.3", UidType.kSOPClass, false,
          "Modality Performed Procedure Step SOP Class");
  static const SopClassUid kModalityPerformedProcedureStepRetrieveSOPClass =
      const SopClassUid(
    "1.2.840.10008.3.1.2.3.4",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Retrieve SOP Class",
  );
  static const SopClassUid kModalityPerformedProcedureStepNotificationSOPClass =
      const SopClassUid(
    "1.­2.840.10008.3.1.2.3.5",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Notification SOP Class",
  );
  static const SopClassUid kDetachedResultsManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.3.1.2.5.1", UidType.kSOPClass, true,
          "Detached Results Management SOP Class (Retired)");
  static const SopClassUid kDetachedInterpretationManagementSOPClass_Retired =
      const SopClassUid(
    "1.2.840.10008.3.1.2.6.1",
    UidType.kSOPClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );

  static const SopClassUid kBasicFilmSessionSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.1",
      UidType.kSOPClass,
      false,
      "Basic Film Session SOP Class");
  static const SopClassUid kBasicFilmBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.2",
      UidType.kSOPClass,
      false,
      "Basic Film Box SOP Class");
  static const SopClassUid kBasicGrayscaleImageBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.4",
      UidType.kSOPClass,
      false,
      "Basic Grayscale Image Box SOP Class");
  static const SopClassUid kBasicColorImageBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.4.1",
      UidType.kSOPClass,
      false,
      "Basic Color Image Box SOP Class");
  static const SopClassUid kReferencedImageBoxSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.4.2", UidType.kSOPClass, true,
          "Referenced Image Box SOP Class (Retired)");
  static const SopClassUid kPrintJobSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.14",
      UidType.kSOPClass,
      false,
      "Print Job SOP Class");
  static const SopClassUid kBasicAnnotationBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.15",
      UidType.kSOPClass,
      false,
      "Basic Annotation Box SOP Class");
  static const SopClassUid kPrinterSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.16", UidType.kSOPClass, false, "Printer SOP Class");
  static const SopClassUid kPrinterConfigurationRetrievalSOPClass =
      const SopClassUid("1.2.840.10008.5.1.1.16.376", UidType.kSOPClass, false,
          "Printer Configuration Retrieval SOP Class");
  static const SopClassUid kVOILUTBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.22",
      UidType.kSOPClass,
      false,
      "VOI LUT Box SOP Class");
  static const SopClassUid kPresentationLUTSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.23",
      UidType.kSOPClass,
      false,
      "Presentation LUT SOP Class");
  static const SopClassUid kImageOverlayBoxSOPClass_Retired = const SopClassUid(
      "1.2.840.10008.5.1.1.24",
      UidType.kSOPClass,
      true,
      "Image Overlay Box SOP Class (Retired)");
  static const SopClassUid kBasicPrintImageOverlayBoxSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.24.1", UidType.kSOPClass, true,
          "Basic Print Image Overlay Box SOP Class (Retired)");

  static const SopClassUid kPrintQueueManagementSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.26", UidType.kSOPClass, true,
          "Print Queue Management SOP Class (Retired)");
  static const SopClassUid kStoredPrintStorageSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.27", UidType.kSOPClass, true,
          "Stored Print Storage SOP Class (Retired)");
  static const SopClassUid kHardcopyGrayscaleImageStorageSOPClass_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.1.29",
    UidType.kSOPClass,
    true,
    "Hardcopy Grayscale Image Storage SOP Class (Retired)",
  );
  static const SopClassUid kHardcopyColorImageStorageSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.30", UidType.kSOPClass, true,
          "Hardcopy Color Image Storage SOP Class (Retired)");
  static const SopClassUid kPullPrintRequestSOPClass_Retired =
      const SopClassUid("1.2.840.10008.5.1.1.31", UidType.kSOPClass, true,
          "Pull Print Request SOP Class (Retired)");
  static const SopClassUid kMediaCreationManagementSOPClassUID =
      const SopClassUid("1.2.840.10008.5.1.1.33", UidType.kSOPClass, false,
          "Media Creation Management SOP Class UID");
  static const SopClassUid kComputedRadiographyImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.1",
      UidType.kSOPClass,
      false,
      "Computed Radiography Image Storage");
  static const SopClassUid kDigitalX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.1",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.1.1",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Processing",
  );
  static const SopClassUid
      kDigitalMammographyX_RayImageStorage_ForPresentation = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.2",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalMammographyX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.2.1",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kDigitalIntra_OralX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.3",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalIntra_OralX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.3.1",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.2",
      UidType.kSOPClass,
      false,
      "CT Image Storage");
  static const SopClassUid kEnhancedCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.2.1",
      UidType.kSOPClass,
      false,
      "Enhanced CT Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedCTImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.2.2", UidType.kSOPClass, false,
          "Legacy Converted Enhanced CT Image Storage");
  static const SopClassUid kUltrasoundMulti_frameImageStorage_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.3", UidType.kSOPClass, true,
          "Ultrasound Multi-frame Image Storage (Retired)");
  static const SopClassUid kUltrasoundMulti_frameImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.3.1", UidType.kSOPClass, false,
          "Ultrasound Multi-frame Image Storage");
  static const SopClassUid kMRImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4",
      UidType.kSOPClass,
      false,
      "MR Image Storage");
  static const SopClassUid kEnhancedMRImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.1",
      UidType.kSOPClass,
      false,
      "Enhanced MR Image Storage");
  static const SopClassUid kMRSpectroscopyStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.2",
      UidType.kSOPClass,
      false,
      "MR Spectroscopy Storage");
  static const SopClassUid kEnhancedMRColorImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.3",
      UidType.kSOPClass,
      false,
      "Enhanced MR Color Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedMRImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.4.4", UidType.kSOPClass, false,
          "Legacy Converted Enhanced MR Image Storage");
  static const SopClassUid kNuclearMedicineImageStorage_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.5", UidType.kSOPClass, true,
          "Nuclear Medicine Image Storage (Retired)");
  static const SopClassUid kUltrasoundImageStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6",
      UidType.kSOPClass,
      true,
      "Ultrasound Image Storage (Retired)");
  static const SopClassUid kUltrasoundImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6.1",
      UidType.kSOPClass,
      false,
      "Ultrasound Image Storage");
  static const SopClassUid kEnhancedUSVolumeStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6.2",
      UidType.kSOPClass,
      false,
      "Enhanced US Volume Storage");
  static const SopClassUid kSecondaryCaptureImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.7",
      UidType.kSOPClass,
      false,
      "Secondary Capture Image Storage");
  static const SopClassUid kMulti_frameSingleBitSecondaryCaptureImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.1",
    UidType.kSOPClass,
    false,
    "Multi-frame Single Bit Secondary Capture Image Storage",
  );
  static const SopClassUid
      kMulti_frameGrayscaleByteSecondaryCaptureImageStorage = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.2",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Byte Secondary Capture Image Storage",
  );
  static const SopClassUid
      kMulti_frameGrayscaleWordSecondaryCaptureImageStorage = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.3",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Word Secondary Capture Image Storage",
  );
  static const SopClassUid kMulti_frameTrueColorSecondaryCaptureImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.4",
    UidType.kSOPClass,
    false,
    "Multi-frame True Color Secondary Capture Image Storage",
  );
  static const SopClassUid kStandaloneOverlayStorage_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.8", UidType.kSOPClass, true,
          "Standalone Overlay Storage (Retired)");
  static const SopClassUid kStandaloneCurveStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9",
      UidType.kSOPClass,
      true,
      "Standalone Curve Storage (Retired)");
  static const SopClassUid kWaveformStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1",
      UidType.kSOPClass,
      true,
      "Waveform Storage - Trial (Retired)");
  static const SopClassUid ktwelve_lead_12ECGWaveformStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.9.1.1", UidType.kSOPClass,
          false, "twelve-lead(12) ECG Waveform Storage");
  static const SopClassUid kGeneralECGWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1.2",
      UidType.kSOPClass,
      false,
      "General ECG Waveform Storage");
  static const SopClassUid kAmbulatoryECGWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1.3",
      UidType.kSOPClass,
      false,
      "Ambulatory ECG Waveform Storage");
  static const SopClassUid kHemodynamicWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.2.1",
      UidType.kSOPClass,
      false,
      "Hemodynamic Waveform Storage");
  static const SopClassUid kCardiacElectrophysiologyWaveformStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.9.3.1",
    UidType.kSOPClass,
    false,
    "Cardiac Electrophysiology Waveform Storage",
  );
  static const SopClassUid kBasicVoiceAudioWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.4.1",
      UidType.kSOPClass,
      false,
      "Basic Voice Audio Waveform Storage");
  static const SopClassUid kGeneralAudioWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.4.2",
      UidType.kSOPClass,
      false,
      "General Audio Waveform Storage");
  static const SopClassUid kArterialPulseWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.5.1",
      UidType.kSOPClass,
      false,
      "Arterial Pulse Waveform Storage");
  static const SopClassUid kRespiratoryWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.6.1",
      UidType.kSOPClass,
      false,
      "Respiratory Waveform Storage");
  static const SopClassUid kStandaloneModalityLUTStorage_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.10", UidType.kSOPClass, true,
          "Standalone Modality LUT Storage (Retired)");
  static const SopClassUid kStandaloneVOILUTStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.11",
      UidType.kSOPClass,
      true,
      "Standalone VOI LUT Storage (Retired)");
  static const SopClassUid kGrayscaleSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.1",
    UidType.kSOPClass,
    false,
    "Grayscale Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kColorSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.2",
    UidType.kSOPClass,
    false,
    "Color Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid
      kPseudo_ColorSoftcopyPresentationStateStorageSOPClass = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.3",
    UidType.kSOPClass,
    false,
    "Pseudo-Color Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kBlendingSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.4",
    UidType.kSOPClass,
    false,
    "Blending Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kXA_XRFGrayscaleSoftcopyPresentationStateStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.5",
    UidType.kSOPClass,
    false,
    "XA/XRF Grayscale Softcopy Presentation State Storage",
  );
  static const SopClassUid kX_RayAngiographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.1",
      UidType.kSOPClass,
      false,
      "X-Ray Angiographic Image Storage");
  static const SopClassUid kEnhancedXAImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.1.1",
      UidType.kSOPClass,
      false,
      "Enhanced XA Image Storage");
  static const SopClassUid kX_RayRadiofluoroscopicImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.12.2", UidType.kSOPClass,
          false, "X-Ray Radiofluoroscopic Image Storage");
  static const SopClassUid kEnhancedXRFImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.2.1",
      UidType.kSOPClass,
      false,
      "Enhanced XRF Image Storage");
  static const SopClassUid kX_RayAngiographicBi_PlaneImageStorage_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.12.3",
    UidType.kSOPClass,
    true,
    "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
  );
  static const SopClassUid kX_Ray3DAngiographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.1",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Angiographic Image Storage");
  static const SopClassUid kX_Ray3DCraniofacialImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.2",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Craniofacial Image Storage");
  static const SopClassUid kBreastTomosynthesisImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.3",
      UidType.kSOPClass,
      false,
      "Breast Tomosynthesis Image Storage");
  static const SopClassUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.14.1",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage "
        "- For Presentation",
  );
  static const SopClassUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.14.2",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Processing",
  );
  static const SopClassUid kNuclearMedicineImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.20",
      UidType.kSOPClass,
      false,
      "Nuclear Medicine Image Storage");
  static const SopClassUid kRawDataStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66",
      UidType.kSOPClass,
      false,
      "Raw Data Storage");
  static const SopClassUid kSpatialRegistrationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.1",
      UidType.kSOPClass,
      false,
      "Spatial Registration Storage");
  static const SopClassUid kSpatialFiducialsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.2",
      UidType.kSOPClass,
      false,
      "Spatial Fiducials Storage");
  static const SopClassUid kDeformableSpatialRegistrationStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.66.3", UidType.kSOPClass,
          false, "Deformable Spatial Registration Storage");
  static const SopClassUid kSegmentationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.4",
      UidType.kSOPClass,
      false,
      "Segmentation Storage");
  static const SopClassUid kSurfaceSegmentationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.5",
      UidType.kSOPClass,
      false,
      "Surface Segmentation Storage");
  static const SopClassUid kRealWorldValueMappingStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.67",
      UidType.kSOPClass,
      false,
      "Real World Value Mapping Storage");
  static const SopClassUid kSurfaceScanMeshStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.68.1",
      UidType.kSOPClass,
      false,
      "Surface Scan Mesh Storage");
  static const SopClassUid kSurfaceScanPointCloudStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.68.2",
      UidType.kSOPClass,
      false,
      "Surface Scan Point Cloud Storage");
  static const SopClassUid kVLImageStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1",
      UidType.kSOPClass,
      true,
      "VL Image Storage - Trial (Retired)");
  static const SopClassUid kVLMulti_frameImageStorage_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.2",
    UidType.kSOPClass,
    true,
    "VL Multi-frame Image Storage - Trial (Retired)",
  );
  static const SopClassUid kVLEndoscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1",
      UidType.kSOPClass,
      false,
      "VL Endoscopic Image Storage");
  static const SopClassUid kVideoEndoscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1.1",
      UidType.kSOPClass,
      false,
      "Video Endoscopic Image Storage");
  static const SopClassUid kVLMicroscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2",
      UidType.kSOPClass,
      false,
      "VL Microscopic Image Storage");
  static const SopClassUid kVideoMicroscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2.1",
      UidType.kSOPClass,
      false,
      "Video Microscopic Image Storage");
  static const SopClassUid kVLSlide_CoordinatesMicroscopicImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.3",
    UidType.kSOPClass,
    false,
    "VL Slide-Coordinates Microscopic Image Storage",
  );
  static const SopClassUid kVLPhotographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4",
      UidType.kSOPClass,
      false,
      "VL Photographic Image Storage");
  static const SopClassUid kVideoPhotographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4.1",
      UidType.kSOPClass,
      false,
      "Video Photographic Image Storage");
  static const SopClassUid kOphthalmicPhotography8BitImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.1",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 8 Bit Image Storage",
  );
  static const SopClassUid kOphthalmicPhotography16BitImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.2",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 16 Bit Image Storage",
  );
  static const SopClassUid kStereometricRelationshipStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.3",
      UidType.kSOPClass,
      false,
      "Stereometric Relationship Storage");
  static const SopClassUid kOphthalmicTomographyImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.77.1.5.4", UidType.kSOPClass,
          false, "Ophthalmic Tomography Image Storage");
  static const SopClassUid kVLWholeSlideMicroscopyImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.77.1.6", UidType.kSOPClass,
          false, "VL Whole Slide Microscopy Image Storage");
  static const SopClassUid kLensometryMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.1",
      UidType.kSOPClass,
      false,
      "Lensometry Measurements Storage");
  static const SopClassUid kAutorefractionMeasurementsStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.78.2", UidType.kSOPClass,
          false, "Autorefraction Measurements Storage");
  static const SopClassUid kKeratometryMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.3",
      UidType.kSOPClass,
      false,
      "Keratometry Measurements Storage");
  static const SopClassUid kSubjectiveRefractionMeasurementsStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.78.4",
    UidType.kSOPClass,
    false,
    "Subjective Refraction Measurements Storage",
  );
  static const SopClassUid kVisualAcuityMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.5",
      UidType.kSOPClass,
      false,
      "Visual Acuity Measurements Storage");
  static const SopClassUid kSpectaclePrescriptionReportStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.78.6", UidType.kSOPClass,
          false, "Spectacle Prescription Report Storage");
  static const SopClassUid kOphthalmicAxialMeasurementsStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.78.7", UidType.kSOPClass,
          false, "Ophthalmic Axial Measurements Storage");
  static const SopClassUid kIntraocularLensCalculationsStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.78.8", UidType.kSOPClass,
          false, "Intraocular Lens Calculations Storage");
  static const SopClassUid kMacularGridThicknessandVolumeReportStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.79.1",
    UidType.kSOPClass,
    false,
    "Macular Grid Thickness and Volume Report Storage",
  );
  static const SopClassUid
      kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.80.1",
    UidType.kSOPClass,
    false,
    "Ophthalmic Visual Field Static Perimetry Measurements Storage",
  );
  static const SopClassUid kOphthalmicThicknessMapStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.81.1",
      UidType.kSOPClass,
      false,
      "Ophthalmic Thickness Map Storage");
  static const SopClassUid kCornealTopographyMapStorage = const SopClassUid(
      "11.2.840.10008.5.1.4.1.1.82.1",
      UidType.kSOPClass,
      false,
      "Corneal Topography Map Storage");
  static const SopClassUid kTextSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.1",
      UidType.kSOPClass,
      true,
      "Text SR Storage - Trial (Retired)");
  static const SopClassUid kAudioSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.2",
      UidType.kSOPClass,
      true,
      "Audio SR Storage - Trial (Retired)");
  static const SopClassUid kDetailSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.3",
      UidType.kSOPClass,
      true,
      "Detail SR Storage - Trial (Retired)");
  static const SopClassUid kComprehensiveSRStorage_Trial_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.88.4", UidType.kSOPClass, true,
          "Comprehensive SR Storage - Trial (Retired)");
  static const SopClassUid kBasicTextSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.11",
      UidType.kSOPClass,
      false,
      "Basic Text SR Storage");
  static const SopClassUid kEnhancedSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.22",
      UidType.kSOPClass,
      false,
      "Enhanced SR Storage");
  static const SopClassUid kComprehensiveSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.33",
      UidType.kSOPClass,
      false,
      "Comprehensive SR Storage");
  static const SopClassUid kComprehensive3DSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.34",
      UidType.kSOPClass,
      false,
      "Comprehensive 3D SR Storage");
  static const SopClassUid kProcedureLogStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.40",
      UidType.kSOPClass,
      false,
      "Procedure Log Storage");
  static const SopClassUid kMammographyCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.50",
      UidType.kSOPClass,
      false,
      "Mammography CAD SR Storage");
  static const SopClassUid kKeyObjectSelectionDocumentStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.88.59", UidType.kSOPClass,
          false, "Key Object Selection Document Storage");
  static const SopClassUid kChestCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.65",
      UidType.kSOPClass,
      false,
      "Chest CAD SR Storage");
  static const SopClassUid kX_RayRadiationDoseSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.67",
      UidType.kSOPClass,
      false,
      "X-Ray Radiation Dose SR Storage");
  static const SopClassUid kColonCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.69",
      UidType.kSOPClass,
      false,
      "Colon CAD SR Storage");
  static const SopClassUid kImplantationPlanSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.70",
      UidType.kSOPClass,
      false,
      "Implantation Plan SR Storage");
  static const SopClassUid kEncapsulatedPDFStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.104.1",
      UidType.kSOPClass,
      false,
      "Encapsulated PDF Storage");
  static const SopClassUid kEncapsulatedCDAStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.104.2",
      UidType.kSOPClass,
      false,
      "Encapsulated CDA Storage");
  static const SopClassUid kPositronEmissionTomographyImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.128", UidType.kSOPClass, false,
          "Positron Emission Tomography Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedPETImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.128.1",
    UidType.kSOPClass,
    false,
    "Legacy Converted Enhanced PET Image Storage",
  );
  static const SopClassUid kStandalonePETCurveStorage_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.129", UidType.kSOPClass, true,
          "Standalone PET Curve Storage (Retired)");
  static const SopClassUid kEnhancedPETImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.130",
      UidType.kSOPClass,
      false,
      "Enhanced PET Image Storage");
  static const SopClassUid kBasicStructuredDisplayStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.131",
      UidType.kSOPClass,
      false,
      "Basic Structured Display Storage");
  static const SopClassUid kRTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.1",
      UidType.kSOPClass,
      false,
      "RT Image Storage");
  static const SopClassUid kRTDoseStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.2",
      UidType.kSOPClass,
      false,
      "RT Dose Storage");
  static const SopClassUid kRTStructureSetStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.3",
      UidType.kSOPClass,
      false,
      "RT Structure Set Storage");
  static const SopClassUid kRTBeamsTreatmentRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.4",
      UidType.kSOPClass,
      false,
      "RT Beams Treatment Record Storage");
  static const SopClassUid kRTPlanStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.5",
      UidType.kSOPClass,
      false,
      "RT Plan Storage");
  static const SopClassUid kRTBrachyTreatmentRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.6",
      UidType.kSOPClass,
      false,
      "RT Brachy Treatment Record Storage");
  static const SopClassUid kRTTreatmentSummaryRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.7",
      UidType.kSOPClass,
      false,
      "RT Treatment Summary Record Storage");
  static const SopClassUid kRTIonPlanStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.8",
      UidType.kSOPClass,
      false,
      "RT Ion Plan Storage");
  static const SopClassUid kRTIonBeamsTreatmentRecordStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.481.9", UidType.kSOPClass,
          false, "RT Ion Beams Treatment Record Storage");
  static const SopClassUid kDICOSCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.1",
      UidType.kSOPClass,
      false,
      "DICOS CT Image Storage");
  static const SopClassUid kDICOSDigitalX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.501.2.1",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDICOSDigitalX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.501.2.2",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kDICOSThreatDetectionReportStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.501.3", UidType.kSOPClass,
          false, "DICOS Threat Detection Report Storage");
  static const SopClassUid kDICOS2DAITStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.4",
      UidType.kSOPClass,
      false,
      "DICOS 2D AIT Storage");
  static const SopClassUid kDICOS3DAITStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.5",
      UidType.kSOPClass,
      false,
      "DICOS 3D AIT Storage");
  static const SopClassUid kDICOSQuadrupoleResonanceStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.6",
      UidType.kSOPClass,
      false,
      "DICOS Quadrupole Resonance (QR) Storage");
  static const SopClassUid kEddyCurrentImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.601.1",
      UidType.kSOPClass,
      false,
      "Eddy Current Image Storage");

  static const SopClassUid kEddyCurrentMulti_frameImageStorage =
      const SopClassUid("1.2.840.10008.5.1.4.1.1.601.2", UidType.kSOPClass,
          false, "Eddy Current Multi-frame Image Storage");
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.1",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - FIND",
  );
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.2",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - MOVE",
  );
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.3",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - GET",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.1",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - FIND",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.2",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - MOVE",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.3",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - GET",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.1",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.2",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.3",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
  );
  static const SopClassUid kCompositeInstanceRootRetrieve_MOVE =
      const SopClassUid("1.2.840.10008.5.1.4.1.2.4.2", UidType.kSOPClass, false,
          "Composite Instance Root Retrieve - MOVE");
  static const SopClassUid kCompositeInstanceRootRetrieve_GET =
      const SopClassUid("1.2.840.10008.5.1.4.1.2.4.3", UidType.kSOPClass, false,
          "Composite Instance Root Retrieve - GET");
  static const SopClassUid kCompositeInstanceRetrieveWithoutBulkData_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.5.3",
    UidType.kSOPClass,
    false,
    "Composite Instance Retrieve Without Bulk Data - GET",
  );
  static const SopClassUid kModalityWorklistInformationModel_FIND =
      const SopClassUid("1.2.840.10008.5.1.4.31", UidType.kSOPClass, false,
          "Modality Worklist Information Model - FIND");
  static const SopClassUid
      kGeneralPurposeWorklistInformationModel_FIND_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.1",
    UidType.kSOPClass,
    true,
    "General Purpose Worklist Information Model - FIND (Retired)",
  );
  static const SopClassUid
      kGeneralPurposeScheduledProcedureStepSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.2",
    UidType.kSOPClass,
    true,
    "General Purpose Scheduled Procedure Step SOP Class (Retired)",
  );
  static const SopClassUid
      kGeneralPurposePerformedProcedureStepSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.3",
    UidType.kSOPClass,
    true,
    "General Purpose Performed Procedure Step SOP Class (Retired)",
  );
  static const SopClassUid
      kGeneralPurposeWorklistManagementMetaSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32",
    UidType.kMetaSOPClass,
    true,
    "General Purpose Worklist Management Meta SOP Class (Retired)",
  );
  static const SopClassUid kInstanceAvailabilityNotificationSOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.33", UidType.kSOPClass, false,
          "Instance Availability Notification SOP Class");
  static const SopClassUid kRTBeamsDeliveryInstructionStorage_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.1",
    UidType.kSOPClass,
    true,
    "RT Beams Delivery Instruction Storage - Trial (Retired)",
  );
  static const SopClassUid kRTConventionalMachineVerification_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.2",
    UidType.kSOPClass,
    true,
    "RT Conventional Machine Verification - Trial (Retired)",
  );
  static const SopClassUid kRTIonMachineVerification_Trial_Retired =
      const SopClassUid("1.2.840.10008.5.1.4.34.3", UidType.kSOPClass, true,
          "RT Ion Machine Verification - Trial (Retired)");
  static const SopClassUid
      kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4",
    UidType.kServiceClass,
    true,
    "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PushSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.1",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Push SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_WatchSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.2",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PullSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.3",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_EventSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.4",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Event SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PushSOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.34.6.1", UidType.kSOPClass, false,
          "Unified Procedure Step - Push SOP Class");
  static const SopClassUid kUnifiedProcedureStep_WatchSOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.34.6.2", UidType.kSOPClass, false,
          "Unified Procedure Step - Watch SOP Class");
  static const SopClassUid kUnifiedProcedureStep_PullSOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.34.6.3", UidType.kSOPClass, false,
          "Unified Procedure Step - Pull SOP Class");
  static const SopClassUid kUnifiedProcedureStep_EventSOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.34.6.4", UidType.kSOPClass, false,
          "Unified Procedure Step - Event SOP Class");
  static const SopClassUid kRTBeamsDeliveryInstructionStorage =
      const SopClassUid("1.2.840.10008.5.1.4.34.7", UidType.kSOPClass, false,
          "RT Beams Delivery Instruction Storage");
  static const SopClassUid kRTConventionalMachineVerification =
      const SopClassUid("1.2.840.10008.5.1.4.34.8", UidType.kSOPClass, false,
          "RT Conventional Machine Verification");
  static const SopClassUid kRTIonMachineVerification = const SopClassUid(
      "1.2.840.10008.5.1.4.34.9",
      UidType.kSOPClass,
      false,
      "RT Ion Machine Verification");
  static const SopClassUid kGeneralRelevantPatientInformationQuery =
      const SopClassUid("1.2.840.10008.5.1.4.37.1", UidType.kSOPClass, false,
          "General Relevant Patient Information Query");
  static const SopClassUid kBreastImagingRelevantPatientInformationQuery =
      const SopClassUid(
    "1.2.840.10008.5.1.4.37.2",
    UidType.kSOPClass,
    false,
    "Breast Imaging Relevant Patient Information Query",
  );
  static const SopClassUid kCardiacRelevantPatientInformationQuery =
      const SopClassUid("1.2.840.10008.5.1.4.37.3", UidType.kSOPClass, false,
          "Cardiac Relevant Patient Information Query");
  static const SopClassUid kHangingProtocolStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.38.1",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Storage");
  static const SopClassUid kHangingProtocolInformationModel_FIND =
      const SopClassUid("1.2.840.10008.5.1.4.38.2", UidType.kSOPClass, false,
          "Hanging Protocol Information Model - FIND");
  static const SopClassUid kHangingProtocolInformationModel_MOVE =
      const SopClassUid("1.2.840.10008.5.1.4.38.3", UidType.kSOPClass, false,
          "Hanging Protocol Information Model - MOVE");
  static const SopClassUid kHangingProtocolInformationModel_GET =
      const SopClassUid("1.2.840.10008.5.1.4.38.4", UidType.kSOPClass, false,
          "Hanging Protocol Information Model - GET");
  static const SopClassUid kProductCharacteristicsQuerySOPClass =
      const SopClassUid("1.2.840.10008.5.1.4.41", UidType.kSOPClass, false,
          "Product Characteristics Query SOP Class");
  static const SopClassUid kSubstanceApprovalQuerySOPClass = const SopClassUid(
      "1.2.840.10008.5.1.4.42",
      UidType.kSOPClass,
      false,
      "Substance Approval Query SOP Class");
  static const SopClassUid kGenericImplantTemplateStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.43.1",
      UidType.kSOPClass,
      false,
      "Generic Implant Template Storage");
  static const SopClassUid kGenericImplantTemplateInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.43.2",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - FIND",
  );
  static const SopClassUid kGenericImplantTemplateInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.43.3",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - MOVE",
  );
  static const SopClassUid kGenericImplantTemplateInformationModel_GET =
      const SopClassUid("1.2.840.10008.5.1.4.43.4", UidType.kSOPClass, false,
          "Generic Implant Template Information Model - GET");
  static const SopClassUid kImplantAssemblyTemplateStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.44.1",
      UidType.kSOPClass,
      false,
      "Implant Assembly Template Storage");
  static const SopClassUid kImplantAssemblyTemplateInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.2",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - FIND",
  );
  static const SopClassUid kImplantAssemblyTemplateInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.3",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - MOVE",
  );
  static const SopClassUid kImplantAssemblyTemplateInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.4",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - GET",
  );
  static const SopClassUid kImplantTemplateGroupStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.45.1",
      UidType.kSOPClass,
      false,
      "Implant Template Group Storage");
  static const SopClassUid kImplantTemplateGroupInformationModel_FIND =
      const SopClassUid("1.2.840.10008.5.1.4.45.2", UidType.kSOPClass, false,
          "Implant Template Group Information Model - FIND");
  static const SopClassUid kImplantTemplateGroupInformationModel_MOVE =
      const SopClassUid("1.2.840.10008.5.1.4.45.3", UidType.kSOPClass, false,
          "Implant Template Group Information Model - MOVE");
  static const SopClassUid kImplantTemplateGroupInformationModel_GET =
      const SopClassUid("1.2.840.10008.5.1.4.45.4", UidType.kSOPClass, false,
          "Implant Template Group Information Model - GET");

//TODO: finish Map

  static const Map<String, SopClassUid> members = const <String, SopClassUid>{};
}
