// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/uid/uid_type.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';

//TODO: Finish this class and write Unit test.

class SopClassUid extends WKUid {
  const SopClassUid(
      String uid, String keyword, UidType type, bool isRetired, String name)
      : super(uid, keyword, type, isRetired, name);

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
      "1.2.840.10008.1.1",
      "VerificationSOPClass",
      UidType.kSOPClass,
      false,
      "Verification SOP Class");

  static const SopClassUid kMediaStorageDirectoryStorage = const SopClassUid(
      "1.2.840.10008.1.3.10",
      "MediaStorageDirectoryStorage",
      UidType.kSOPClass,
      false,
      "Media Storage Directory Storage");

  static const SopClassUid kBasicStudyContentNotificationSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.1.9",
          "BasicStudyContentNotificationSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Basic Study Content Notification SOP Class (Retired)");
  static const SopClassUid kStorageCommitmentPushModelSOPClass =
      const SopClassUid(
          "1.2.840.10008.1.20.1",
          "StorageCommitmentPushModelSOPClass",
          UidType.kSOPClass,
          true,
          "Storage Commitment Push Model SOP Class");

  static const SopClassUid kStorageCommitmentPullModelSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.1.20.2",
          "StorageCommitmentPullModelSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Storage Commitment Pull Model SOP Class (Retired)");

  static const SopClassUid kProceduralEventLoggingSOPClass = const SopClassUid(
      "1.2.840.10008.1.40",
      "ProceduralEventLoggingSOPClass",
      UidType.kSOPClass,
      false,
      "Procedural Event Logging SOP Class");

  static const SopClassUid kSubstanceAdministrationLoggingSOPClass =
      const SopClassUid(
          "1.2.840.10008.1.42",
          "SubstanceAdministrationLoggingSOPClass",
          UidType.kSOPClass,
          false,
          "Substance Administration Logging SOP Class");
  static const SopClassUid kDetachedPatientManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.3.1.2.1.1",
          "DetachedPatientManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Detached Patient Management SOP Class (Retired)");

  static const SopClassUid kDetachedVisitManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.3.1.2.2.1",
          "DetachedVisitManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Detached Visit Management SOP Class (Retired)");
  static const SopClassUid kDetachedStudyManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.3.1.2.3.1",
          "DetachedStudyManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Detached Study Management SOP Class (Retired)");
  static const SopClassUid kStudyComponentManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.3.1.2.3.2",
          "StudyComponentManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Study Component Management SOP Class (Retired)");
  static const SopClassUid kModalityPerformedProcedureStepSOPClass =
      const SopClassUid(
          "1.­2.840.10008.3.1.2.3.3",
          "ModalityPerformedProcedureStepSOPClass",
          UidType.kSOPClass,
          false,
          "Modality Performed Procedure Step SOP Class");
  static const SopClassUid kModalityPerformedProcedureStepRetrieveSOPClass =
      const SopClassUid(
    "1.2.840.10008.3.1.2.3.4",
    "ModalityPerformedProcedureStepRetrieveSOPClass",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Retrieve SOP Class",
  );
  static const SopClassUid kModalityPerformedProcedureStepNotificationSOPClass =
      const SopClassUid(
    "1.2.840.10008.3.1.2.3.5",
    "ModalityPerformedProcedureStepNotificationSOPClass",
    UidType.kSOPClass,
    false,
    "Modality Performed Procedure Step Notification SOP Class",
  );
  static const SopClassUid kDetachedResultsManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.3.1.2.5.1",
          "DetachedResultsManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Detached Results Management SOP Class (Retired)");
  static const SopClassUid kDetachedInterpretationManagementSOPClass_Retired =
      const SopClassUid(
    "1.2.840.10008.3.1.2.6.1",
    "DetachedInterpretationManagementSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "Detached Interpretation Management SOP Class (Retired)",
  );

  static const SopClassUid kBasicFilmSessionSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.1",
      "BasicFilmSessionSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Film Session SOP Class");
  static const SopClassUid kBasicFilmBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.2",
      "BasicFilmBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Film Box SOP Class");
  static const SopClassUid kBasicGrayscaleImageBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.4",
      "BasicGrayscaleImageBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Grayscale Image Box SOP Class");
  static const SopClassUid kBasicColorImageBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.4.1",
      "BasicColorImageBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Color Image Box SOP Class");
  static const SopClassUid kReferencedImageBoxSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.4.2",
          "ReferencedImageBoxSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Referenced Image Box SOP Class (Retired)");
  static const SopClassUid kPrintJobSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.14",
      "PrintJobSOPClass",
      UidType.kSOPClass,
      false,
      "Print Job SOP Class");
  static const SopClassUid kBasicAnnotationBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.15",
      "BasicAnnotationBoxSOPClass",
      UidType.kSOPClass,
      false,
      "Basic Annotation Box SOP Class");
  static const SopClassUid kPrinterSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.16",
      "PrinterSOPClass",
      UidType.kSOPClass,
      false,
      "Printer SOP Class");
  static const SopClassUid kPrinterConfigurationRetrievalSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.1.16.376",
          "PrinterConfigurationRetrievalSOPClass",
          UidType.kSOPClass,
          false,
          "Printer Configuration Retrieval SOP Class");
  static const SopClassUid kVOILUTBoxSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.22",
      "VOILUTBoxSOPClass",
      UidType.kSOPClass,
      false,
      "VOI LUT Box SOP Class");
  static const SopClassUid kPresentationLUTSOPClass = const SopClassUid(
      "1.2.840.10008.5.1.1.23",
      "PresentationLUTSOPClass",
      UidType.kSOPClass,
      false,
      "Presentation LUT SOP Class");
  static const SopClassUid kImageOverlayBoxSOPClass_Retired = const SopClassUid(
      "1.2.840.10008.5.1.1.24",
      "ImageOverlayBoxSOPClass_Retired",
      UidType.kSOPClass,
      true,
      "Image Overlay Box SOP Class (Retired)");
  static const SopClassUid kBasicPrintImageOverlayBoxSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.24.1",
          "BasicPrintImageOverlayBoxSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Basic Print Image Overlay Box SOP Class (Retired)");

  static const SopClassUid kPrintQueueManagementSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.26",
          "PrintQueueManagementSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Print Queue Management SOP Class (Retired)");
  static const SopClassUid kStoredPrintStorageSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.27",
          "StoredPrintStorageSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Stored Print Storage SOP Class (Retired)");
  static const SopClassUid kHardcopyGrayscaleImageStorageSOPClass_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.1.29",
    "HardcopyGrayscaleImageStorageSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "Hardcopy Grayscale Image Storage SOP Class (Retired)",
  );
  static const SopClassUid kHardcopyColorImageStorageSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.30",
          "HardcopyColorImageStorageSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Hardcopy Color Image Storage SOP Class (Retired)");
  static const SopClassUid kPullPrintRequestSOPClass_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.1.31",
          "PullPrintRequestSOPClass_Retired",
          UidType.kSOPClass,
          true,
          "Pull Print Request SOP Class (Retired)");
  static const SopClassUid kMediaCreationManagementSOPClassUID =
      const SopClassUid(
          "1.2.840.10008.5.1.1.33",
          "MediaCreationManagementSOPClassUID",
          UidType.kSOPClass,
          false,
          "Media Creation Management SOP Class UID");
  static const SopClassUid kComputedRadiographyImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.1",
      "ComputedRadiographyImageStorage",
      UidType.kSOPClass,
      false,
      "Computed Radiography Image Storage");
  static const SopClassUid kDigitalX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.1",
    "DigitalX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.1.1",
    "DigitalX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital X-Ray Image Storage - For Processing",
  );
  static const SopClassUid
      kDigitalMammographyX_RayImageStorage_ForPresentation = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.2",
    "DigitalMammographyX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalMammographyX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.2.1",
    "DigitalMammographyX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital Mammography X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kDigitalIntra_OralX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.3",
    "DigitalIntra_OralX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDigitalIntra_OralX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.1.3.1",
    "DigitalIntra_OralX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Digital Intra-Oral X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.2",
      "CTImageStorage",
      UidType.kSOPClass,
      false,
      "CT Image Storage");
  static const SopClassUid kEnhancedCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.2.1",
      "EnhancedCTImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced CT Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedCTImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.2.2",
          "LegacyConvertedEnhancedCTImageStorage",
          UidType.kSOPClass,
          false,
          "Legacy Converted Enhanced CT Image Storage");
  static const SopClassUid kUltrasoundMulti_frameImageStorage_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.3",
          "UltrasoundMulti_frameImageStorage_Retired",
          UidType.kSOPClass,
          true,
          "Ultrasound Multi-frame Image Storage (Retired)");
  static const SopClassUid kUltrasoundMulti_frameImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.3.1",
          "UltrasoundMulti_frameImageStorage",
          UidType.kSOPClass,
          false,
          "Ultrasound Multi-frame Image Storage");
  static const SopClassUid kMRImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4",
      "MRImageStorage",
      UidType.kSOPClass,
      false,
      "MR Image Storage");
  static const SopClassUid kEnhancedMRImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.1",
      "EnhancedMRImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced MR Image Storage");
  static const SopClassUid kMRSpectroscopyStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.2",
      "MRSpectroscopyStorage",
      UidType.kSOPClass,
      false,
      "MR Spectroscopy Storage");
  static const SopClassUid kEnhancedMRColorImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.4.3",
      "EnhancedMRColorImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced MR Color Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedMRImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.4.4",
          "LegacyConvertedEnhancedMRImageStorage",
          UidType.kSOPClass,
          false,
          "Legacy Converted Enhanced MR Image Storage");
  static const SopClassUid kNuclearMedicineImageStorage_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.5",
          "NuclearMedicineImageStorage_Retired",
          UidType.kSOPClass,
          true,
          "Nuclear Medicine Image Storage (Retired)");
  static const SopClassUid kUltrasoundImageStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6",
      "UltrasoundImageStorage_Retired",
      UidType.kSOPClass,
      true,
      "Ultrasound Image Storage (Retired)");
  static const SopClassUid kUltrasoundImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6.1",
      "UltrasoundImageStorage",
      UidType.kSOPClass,
      false,
      "Ultrasound Image Storage");
  static const SopClassUid kEnhancedUSVolumeStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.6.2",
      "EnhancedUSVolumeStorage",
      UidType.kSOPClass,
      false,
      "Enhanced US Volume Storage");
  static const SopClassUid kSecondaryCaptureImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.7",
      "SecondaryCaptureImageStorage",
      UidType.kSOPClass,
      false,
      "Secondary Capture Image Storage");
  static const SopClassUid kMulti_frameSingleBitSecondaryCaptureImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.1",
    "Multi_frameSingleBitSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Single Bit Secondary Capture Image Storage",
  );
  static const SopClassUid
      kMulti_frameGrayscaleByteSecondaryCaptureImageStorage = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.2",
    "Multi_frameGrayscaleByteSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Byte Secondary Capture Image Storage",
  );
  static const SopClassUid
      kMulti_frameGrayscaleWordSecondaryCaptureImageStorage = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.3",
    "Multi_frameGrayscaleWordSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame Grayscale Word Secondary Capture Image Storage",
  );
  static const SopClassUid kMulti_frameTrueColorSecondaryCaptureImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.7.4",
    "Multi_frameTrueColorSecondaryCaptureImageStorage",
    UidType.kSOPClass,
    false,
    "Multi-frame True Color Secondary Capture Image Storage",
  );
  static const SopClassUid kStandaloneOverlayStorage_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.8",
          "StandaloneOverlayStorage_Retired",
          UidType.kSOPClass,
          true,
          "Standalone Overlay Storage (Retired)");
  static const SopClassUid kStandaloneCurveStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9",
      "StandaloneCurveStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone Curve Storage (Retired)");
  static const SopClassUid kWaveformStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1",
      "WaveformStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Waveform Storage - Trial (Retired)");
  static const SopClassUid ktwelve_lead_12ECGWaveformStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.9.1.1",
          "twelve_lead_12ECGWaveformStorage",
          UidType.kSOPClass,
          false,
          "twelve-lead(12) ECG Waveform Storage");
  static const SopClassUid kGeneralECGWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1.2",
      "GeneralECGWaveformStorage",
      UidType.kSOPClass,
      false,
      "General ECG Waveform Storage");
  static const SopClassUid kAmbulatoryECGWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.1.3",
      "AmbulatoryECGWaveformStorage",
      UidType.kSOPClass,
      false,
      "Ambulatory ECG Waveform Storage");
  static const SopClassUid kHemodynamicWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.2.1",
      "HemodynamicWaveformStorage",
      UidType.kSOPClass,
      false,
      "Hemodynamic Waveform Storage");
  static const SopClassUid kCardiacElectrophysiologyWaveformStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.9.3.1",
    "CardiacElectrophysiologyWaveformStorage",
    UidType.kSOPClass,
    false,
    "Cardiac Electrophysiology Waveform Storage",
  );
  static const SopClassUid kBasicVoiceAudioWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.4.1",
      "BasicVoiceAudioWaveformStorage",
      UidType.kSOPClass,
      false,
      "Basic Voice Audio Waveform Storage");
  static const SopClassUid kGeneralAudioWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.4.2",
      "GeneralAudioWaveformStorage",
      UidType.kSOPClass,
      false,
      "General Audio Waveform Storage");
  static const SopClassUid kArterialPulseWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.5.1",
      "ArterialPulseWaveformStorage",
      UidType.kSOPClass,
      false,
      "Arterial Pulse Waveform Storage");
  static const SopClassUid kRespiratoryWaveformStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.9.6.1",
      "RespiratoryWaveformStorage",
      UidType.kSOPClass,
      false,
      "Respiratory Waveform Storage");
  static const SopClassUid kStandaloneModalityLUTStorage_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.10",
          "StandaloneModalityLUTStorage_Retired",
          UidType.kSOPClass,
          true,
          "Standalone Modality LUT Storage (Retired)");
  static const SopClassUid kStandaloneVOILUTStorage_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.11",
      "StandaloneVOILUTStorage_Retired",
      UidType.kSOPClass,
      true,
      "Standalone VOI LUT Storage (Retired)");
  static const SopClassUid kGrayscaleSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.1",
    "GrayscaleSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Grayscale Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kColorSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.2",
    "ColorSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Color Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid
      kPseudo_ColorSoftcopyPresentationStateStorageSOPClass = const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.3",
    "Pseudo_ColorSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Pseudo-Color Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kBlendingSoftcopyPresentationStateStorageSOPClass =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.4",
    "BlendingSoftcopyPresentationStateStorageSOPClass",
    UidType.kSOPClass,
    false,
    "Blending Softcopy Presentation State Storage SOP Class",
  );
  static const SopClassUid kXA_XRFGrayscaleSoftcopyPresentationStateStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.11.5",
    "XA_XRFGrayscaleSoftcopyPresentationStateStorage",
    UidType.kSOPClass,
    false,
    "XA/XRF Grayscale Softcopy Presentation State Storage",
  );
  static const SopClassUid kX_RayAngiographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.1",
      "X_RayAngiographicImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray Angiographic Image Storage");
  static const SopClassUid kEnhancedXAImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.1.1",
      "EnhancedXAImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced XA Image Storage");
  static const SopClassUid kX_RayRadiofluoroscopicImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.12.2",
          "X_RayRadiofluoroscopicImageStorage",
          UidType.kSOPClass,
          false,
          "X-Ray Radiofluoroscopic Image Storage");
  static const SopClassUid kEnhancedXRFImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.12.2.1",
      "EnhancedXRFImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced XRF Image Storage");
  static const SopClassUid kX_RayAngiographicBi_PlaneImageStorage_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.12.3",
    "X_RayAngiographicBi_PlaneImageStorage_Retired",
    UidType.kSOPClass,
    true,
    "X-Ray Angiographic Bi-Plane Image Storage (Retired)",
  );
  static const SopClassUid kX_Ray3DAngiographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.1",
      "X_Ray3DAngiographicImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Angiographic Image Storage");
  static const SopClassUid kX_Ray3DCraniofacialImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.2",
      "X_Ray3DCraniofacialImageStorage",
      UidType.kSOPClass,
      false,
      "X-Ray 3D Craniofacial Image Storage");
  static const SopClassUid kBreastTomosynthesisImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.13.1.3",
      "BreastTomosynthesisImageStorage",
      UidType.kSOPClass,
      false,
      "Breast Tomosynthesis Image Storage");
  static const SopClassUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.14.1",
    "IntravascularOpticalCoherenceTomographyImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage "
        "- For Presentation",
  );
  static const SopClassUid
      kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.14.2",
    "IntravascularOpticalCoherenceTomographyImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "Intravascular Optical Coherence Tomography Image Storage - For Processing",
  );
  static const SopClassUid kNuclearMedicineImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.20",
      "NuclearMedicineImageStorage",
      UidType.kSOPClass,
      false,
      "Nuclear Medicine Image Storage");
  static const SopClassUid kRawDataStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66",
      "RawDataStorage",
      UidType.kSOPClass,
      false,
      "Raw Data Storage");
  static const SopClassUid kSpatialRegistrationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.1",
      "SpatialRegistrationStorage",
      UidType.kSOPClass,
      false,
      "Spatial Registration Storage");
  static const SopClassUid kSpatialFiducialsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.2",
      "SpatialFiducialsStorage",
      UidType.kSOPClass,
      false,
      "Spatial Fiducials Storage");
  static const SopClassUid kDeformableSpatialRegistrationStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.66.3",
          "DeformableSpatialRegistrationStorage",
          UidType.kSOPClass,
          false,
          "Deformable Spatial Registration Storage");
  static const SopClassUid kSegmentationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.4",
      "SegmentationStorage",
      UidType.kSOPClass,
      false,
      "Segmentation Storage");
  static const SopClassUid kSurfaceSegmentationStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.66.5",
      "SurfaceSegmentationStorage",
      UidType.kSOPClass,
      false,
      "Surface Segmentation Storage");
  static const SopClassUid kRealWorldValueMappingStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.67",
      "RealWorldValueMappingStorage",
      UidType.kSOPClass,
      false,
      "Real World Value Mapping Storage");
  static const SopClassUid kSurfaceScanMeshStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.68.1",
      "SurfaceScanMeshStorage",
      UidType.kSOPClass,
      false,
      "Surface Scan Mesh Storage");
  static const SopClassUid kSurfaceScanPointCloudStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.68.2",
      "SurfaceScanPointCloudStorage",
      UidType.kSOPClass,
      false,
      "Surface Scan Point Cloud Storage");
  static const SopClassUid kVLImageStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1",
      "VLImageStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "VL Image Storage - Trial (Retired)");
  static const SopClassUid kVLMulti_frameImageStorage_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.2",
    "VLMulti_frameImageStorage_Trial_Retired",
    UidType.kSOPClass,
    true,
    "VL Multi-frame Image Storage - Trial (Retired)",
  );
  static const SopClassUid kVLEndoscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1",
      "VLEndoscopicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Endoscopic Image Storage");
  static const SopClassUid kVideoEndoscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.1.1",
      "VideoEndoscopicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Endoscopic Image Storage");
  static const SopClassUid kVLMicroscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2",
      "VLMicroscopicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Microscopic Image Storage");
  static const SopClassUid kVideoMicroscopicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.2.1",
      "VideoMicroscopicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Microscopic Image Storage");
  static const SopClassUid kVLSlide_CoordinatesMicroscopicImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.3",
    "VLSlide_CoordinatesMicroscopicImageStorage",
    UidType.kSOPClass,
    false,
    "VL Slide-Coordinates Microscopic Image Storage",
  );
  static const SopClassUid kVLPhotographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4",
      "VLPhotographicImageStorage",
      UidType.kSOPClass,
      false,
      "VL Photographic Image Storage");
  static const SopClassUid kVideoPhotographicImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.4.1",
      "VideoPhotographicImageStorage",
      UidType.kSOPClass,
      false,
      "Video Photographic Image Storage");
  static const SopClassUid kOphthalmicPhotography8BitImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.1",
    "OphthalmicPhotography8BitImageStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 8 Bit Image Storage",
  );
  static const SopClassUid kOphthalmicPhotography16BitImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.77.1.5.2",
    "OphthalmicPhotography16BitImageStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Photography 16 Bit Image Storage",
  );
  static const SopClassUid kStereometricRelationshipStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.77.1.5.3",
      "StereometricRelationshipStorage",
      UidType.kSOPClass,
      false,
      "Stereometric Relationship Storage");
  static const SopClassUid kOphthalmicTomographyImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.77.1.5.4",
          "OphthalmicTomographyImageStorage",
          UidType.kSOPClass,
          false,
          "Ophthalmic Tomography Image Storage");
  static const SopClassUid kVLWholeSlideMicroscopyImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.77.1.6",
          "VLWholeSlideMicroscopyImageStorage",
          UidType.kSOPClass,
          false,
          "VL Whole Slide Microscopy Image Storage");
  static const SopClassUid kLensometryMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.1",
      "LensometryMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Lensometry Measurements Storage");
  static const SopClassUid kAutorefractionMeasurementsStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.78.2",
          "AutorefractionMeasurementsStorage",
          UidType.kSOPClass,
          false,
          "Autorefraction Measurements Storage");
  static const SopClassUid kKeratometryMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.3",
      "KeratometryMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Keratometry Measurements Storage");
  static const SopClassUid kSubjectiveRefractionMeasurementsStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.78.4",
    "SubjectiveRefractionMeasurementsStorage",
    UidType.kSOPClass,
    false,
    "Subjective Refraction Measurements Storage",
  );
  static const SopClassUid kVisualAcuityMeasurementsStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.78.5",
      "VisualAcuityMeasurementsStorage",
      UidType.kSOPClass,
      false,
      "Visual Acuity Measurements Storage");
  static const SopClassUid kSpectaclePrescriptionReportStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.78.6",
          "SpectaclePrescriptionReportStorage",
          UidType.kSOPClass,
          false,
          "Spectacle Prescription Report Storage");
  static const SopClassUid kOphthalmicAxialMeasurementsStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.78.7",
          "OphthalmicAxialMeasurementsStorage",
          UidType.kSOPClass,
          false,
          "Ophthalmic Axial Measurements Storage");
  static const SopClassUid kIntraocularLensCalculationsStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.78.8",
          "IntraocularLensCalculationsStorage",
          UidType.kSOPClass,
          false,
          "Intraocular Lens Calculations Storage");
  static const SopClassUid kMacularGridThicknessandVolumeReportStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.79.1",
    "MacularGridThicknessandVolumeReportStorage",
    UidType.kSOPClass,
    false,
    "Macular Grid Thickness and Volume Report Storage",
  );
  static const SopClassUid
      kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.80.1",
    "OphthalmicVisualFieldStaticPerimetryMeasurementsStorage",
    UidType.kSOPClass,
    false,
    "Ophthalmic Visual Field Static Perimetry Measurements Storage",
  );
  static const SopClassUid kOphthalmicThicknessMapStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.81.1",
      "OphthalmicThicknessMapStorage",
      UidType.kSOPClass,
      false,
      "Ophthalmic Thickness Map Storage");
  static const SopClassUid kCornealTopographyMapStorage = const SopClassUid(
      "11.2.840.10008.5.1.4.1.1.82.1",
      "CornealTopographyMapStorage",
      UidType.kSOPClass,
      false,
      "Corneal Topography Map Storage");
  static const SopClassUid kTextSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.1",
      "TextSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Text SR Storage - Trial (Retired)");
  static const SopClassUid kAudioSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.2",
      "AudioSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Audio SR Storage - Trial (Retired)");
  static const SopClassUid kDetailSRStorage_Trial_Retired = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.3",
      "DetailSRStorage_Trial_Retired",
      UidType.kSOPClass,
      true,
      "Detail SR Storage - Trial (Retired)");
  static const SopClassUid kComprehensiveSRStorage_Trial_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.88.4",
          "ComprehensiveSRStorage_Trial_Retired",
          UidType.kSOPClass,
          true,
          "Comprehensive SR Storage - Trial (Retired)");
  static const SopClassUid kBasicTextSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.11",
      "BasicTextSRStorage",
      UidType.kSOPClass,
      false,
      "Basic Text SR Storage");
  static const SopClassUid kEnhancedSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.22",
      "EnhancedSRStorage",
      UidType.kSOPClass,
      false,
      "Enhanced SR Storage");
  static const SopClassUid kComprehensiveSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.33",
      "ComprehensiveSRStorage",
      UidType.kSOPClass,
      false,
      "Comprehensive SR Storage");
  static const SopClassUid kComprehensive3DSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.34",
      "Comprehensive3DSRStorage",
      UidType.kSOPClass,
      false,
      "Comprehensive 3D SR Storage");
  static const SopClassUid kProcedureLogStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.40",
      "ProcedureLogStorage",
      UidType.kSOPClass,
      false,
      "Procedure Log Storage");
  static const SopClassUid kMammographyCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.50",
      "MammographyCADSRStorage",
      UidType.kSOPClass,
      false,
      "Mammography CAD SR Storage");
  static const SopClassUid kKeyObjectSelectionDocumentStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.88.59",
          "KeyObjectSelectionDocumentStorage",
          UidType.kSOPClass,
          false,
          "Key Object Selection Document Storage");
  static const SopClassUid kChestCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.65",
      "ChestCADSRStorage",
      UidType.kSOPClass,
      false,
      "Chest CAD SR Storage");
  static const SopClassUid kX_RayRadiationDoseSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.67",
      "X_RayRadiationDoseSRStorage",
      UidType.kSOPClass,
      false,
      "X-Ray Radiation Dose SR Storage");
  static const SopClassUid kColonCADSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.69",
      "ColonCADSRStorage",
      UidType.kSOPClass,
      false,
      "Colon CAD SR Storage");
  static const SopClassUid kImplantationPlanSRStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.88.70",
      "ImplantationPlanSRStorage",
      UidType.kSOPClass,
      false,
      "Implantation Plan SR Storage");
  static const SopClassUid kEncapsulatedPDFStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.104.1",
      "EncapsulatedPDFStorage",
      UidType.kSOPClass,
      false,
      "Encapsulated PDF Storage");
  static const SopClassUid kEncapsulatedCDAStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.104.2",
      "EncapsulatedCDAStorage",
      UidType.kSOPClass,
      false,
      "Encapsulated CDA Storage");
  static const SopClassUid kPositronEmissionTomographyImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.128",
          "PositronEmissionTomographyImageStorage",
          UidType.kSOPClass,
          false,
          "Positron Emission Tomography Image Storage");
  static const SopClassUid kLegacyConvertedEnhancedPETImageStorage =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.128.1",
    "LegacyConvertedEnhancedPETImageStorage",
    UidType.kSOPClass,
    false,
    "Legacy Converted Enhanced PET Image Storage",
  );
  static const SopClassUid kStandalonePETCurveStorage_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.129",
          "StandalonePETCurveStorage_Retired",
          UidType.kSOPClass,
          true,
          "Standalone PET Curve Storage (Retired)");
  static const SopClassUid kEnhancedPETImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.130",
      "EnhancedPETImageStorage",
      UidType.kSOPClass,
      false,
      "Enhanced PET Image Storage");
  static const SopClassUid kBasicStructuredDisplayStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.131",
      "BasicStructuredDisplayStorage",
      UidType.kSOPClass,
      false,
      "Basic Structured Display Storage");
  static const SopClassUid kRTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.1",
      "RTImageStorage",
      UidType.kSOPClass,
      false,
      "RT Image Storage");
  static const SopClassUid kRTDoseStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.2",
      "RTDoseStorage",
      UidType.kSOPClass,
      false,
      "RT Dose Storage");
  static const SopClassUid kRTStructureSetStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.3",
      "RTStructureSetStorage",
      UidType.kSOPClass,
      false,
      "RT Structure Set Storage");
  static const SopClassUid kRTBeamsTreatmentRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.4",
      "RTBeamsTreatmentRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Beams Treatment Record Storage");
  static const SopClassUid kRTPlanStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.5",
      "RTPlanStorage",
      UidType.kSOPClass,
      false,
      "RT Plan Storage");
  static const SopClassUid kRTBrachyTreatmentRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.6",
      "RTBrachyTreatmentRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Brachy Treatment Record Storage");
  static const SopClassUid kRTTreatmentSummaryRecordStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.7",
      "RTTreatmentSummaryRecordStorage",
      UidType.kSOPClass,
      false,
      "RT Treatment Summary Record Storage");
  static const SopClassUid kRTIonPlanStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.481.8",
      "RTIonPlanStorage",
      UidType.kSOPClass,
      false,
      "RT Ion Plan Storage");
  static const SopClassUid kRTIonBeamsTreatmentRecordStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.481.9",
          "RTIonBeamsTreatmentRecordStorage",
          UidType.kSOPClass,
          false,
          "RT Ion Beams Treatment Record Storage");
  static const SopClassUid kDICOSCTImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.1",
      "DICOSCTImageStorage",
      UidType.kSOPClass,
      false,
      "DICOS CT Image Storage");
  static const SopClassUid kDICOSDigitalX_RayImageStorage_ForPresentation =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.501.2.1",
    "DICOSDigitalX_RayImageStorage_ForPresentation",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Presentation",
  );
  static const SopClassUid kDICOSDigitalX_RayImageStorage_ForProcessing =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.1.501.2.2",
    "DICOSDigitalX_RayImageStorage_ForProcessing",
    UidType.kSOPClass,
    false,
    "DICOS Digital X-Ray Image Storage - For Processing",
  );
  static const SopClassUid kDICOSThreatDetectionReportStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.501.3",
          "DICOSThreatDetectionReportStorage",
          UidType.kSOPClass,
          false,
          "DICOS Threat Detection Report Storage");
  static const SopClassUid kDICOS2DAITStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.4",
      "DICOS2DAITStorage",
      UidType.kSOPClass,
      false,
      "DICOS 2D AIT Storage");
  static const SopClassUid kDICOS3DAITStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.5",
      "DICOS3DAITStorage",
      UidType.kSOPClass,
      false,
      "DICOS 3D AIT Storage");
  static const SopClassUid kDICOSQuadrupoleResonanceStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.501.6",
      "DICOSQuadrupoleResonanceStorage",
      UidType.kSOPClass,
      false,
      "DICOS Quadrupole Resonance (QR) Storage");
  static const SopClassUid kEddyCurrentImageStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.1.1.601.1",
      "EddyCurrentImageStorage",
      UidType.kSOPClass,
      false,
      "Eddy Current Image Storage");

  static const SopClassUid kEddyCurrentMulti_frameImageStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.1.601.2",
          "EddyCurrentMulti_frameImageStorage",
          UidType.kSOPClass,
          false,
          "Eddy Current Multi-frame Image Storage");
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.1",
    "PatientRootQueryRetrieveInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - FIND",
  );
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.2",
    "PatientRootQueryRetrieveInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - MOVE",
  );
  static const SopClassUid kPatientRootQueryRetrieveInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.1.3",
    "PatientRootQueryRetrieveInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Patient Root Query/Retrieve Information Model - GET",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.1",
    "StudyRootQueryRetrieveInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - FIND",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.2",
    "StudyRootQueryRetrieveInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - MOVE",
  );
  static const SopClassUid kStudyRootQueryRetrieveInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.2.3",
    "StudyRootQueryRetrieveInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Study Root Query/Retrieve Information Model - GET",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.1",
    "Patient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - FIND (Retired)",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.2",
    "Patient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - MOVE (Retired)",
  );
  static const SopClassUid
      kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.3.3",
    "Patient_StudyOnlyQueryRetrieveInformationModel_GET_Retired",
    UidType.kSOPClass,
    true,
    "Patient/Study Only Query/Retrieve Information Model - GET (Retired)",
  );
  static const SopClassUid kCompositeInstanceRootRetrieve_MOVE =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.2.4.2",
          "CompositeInstanceRootRetrieve_MOVE",
          UidType.kSOPClass,
          false,
          "Composite Instance Root Retrieve - MOVE");
  static const SopClassUid kCompositeInstanceRootRetrieve_GET =
      const SopClassUid(
          "1.2.840.10008.5.1.4.1.2.4.3",
          "CompositeInstanceRootRetrieve_GET",
          UidType.kSOPClass,
          false,
          "Composite Instance Root Retrieve - GET");
  static const SopClassUid kCompositeInstanceRetrieveWithoutBulkData_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.1.2.5.3",
    "CompositeInstanceRetrieveWithoutBulkData_GET",
    UidType.kSOPClass,
    false,
    "Composite Instance Retrieve Without Bulk Data - GET",
  );
  static const SopClassUid kModalityWorklistInformationModel_FIND =
      const SopClassUid(
          "1.2.840.10008.5.1.4.31",
          "ModalityWorklistInformationModel_FIND",
          UidType.kSOPClass,
          false,
          "Modality Worklist Information Model - FIND");
  static const SopClassUid
      kGeneralPurposeWorklistInformationModel_FIND_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.1",
    "GeneralPurposeWorklistInformationModel_FIND_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Worklist Information Model - FIND (Retired)",
  );
  static const SopClassUid
      kGeneralPurposeScheduledProcedureStepSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.2",
    "GeneralPurposeScheduledProcedureStepSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Scheduled Procedure Step SOP Class (Retired)",
  );
  static const SopClassUid
      kGeneralPurposePerformedProcedureStepSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32.3",
    "GeneralPurposePerformedProcedureStepSOPClass_Retired",
    UidType.kSOPClass,
    true,
    "General Purpose Performed Procedure Step SOP Class (Retired)",
  );
  static const SopClassUid
      kGeneralPurposeWorklistManagementMetaSOPClass_Retired = const SopClassUid(
    "1.2.840.10008.5.1.4.32",
    "GeneralPurposeWorklistManagementMetaSOPClass_Retired",
    UidType.kMetaSOPClass,
    true,
    "General Purpose Worklist Management Meta SOP Class (Retired)",
  );
  static const SopClassUid kInstanceAvailabilityNotificationSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.33",
          "InstanceAvailabilityNotificationSOPClass",
          UidType.kSOPClass,
          false,
          "Instance Availability Notification SOP Class");
  static const SopClassUid kRTBeamsDeliveryInstructionStorage_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.1",
    "RTBeamsDeliveryInstructionStorage_Trial_Retired",
    UidType.kSOPClass,
    true,
    "RT Beams Delivery Instruction Storage - Trial (Retired)",
  );
  static const SopClassUid kRTConventionalMachineVerification_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.2",
    "RTConventionalMachineVerification_Trial_Retired",
    UidType.kSOPClass,
    true,
    "RT Conventional Machine Verification - Trial (Retired)",
  );
  static const SopClassUid kRTIonMachineVerification_Trial_Retired =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.3",
          "RTIonMachineVerification_Trial_Retired",
          UidType.kSOPClass,
          true,
          "RT Ion Machine Verification - Trial (Retired)");
  static const SopClassUid
      kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4",
    "UnifiedWorklistandProcedureStepServiceClass_Trial_Retired",
    UidType.kServiceClass,
    true,
    "Unified Worklist and Procedure Step Service Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PushSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.1",
    "UnifiedProcedureStep_PushSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Push SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_WatchSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.2",
    "UnifiedProcedureStep_WatchSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Watch SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PullSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.3",
    "UnifiedProcedureStep_PullSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Pull SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_EventSOPClass_Trial_Retired =
      const SopClassUid(
    "1.2.840.10008.5.1.4.34.4.4",
    "UnifiedProcedureStep_EventSOPClass_Trial_Retired",
    UidType.kSOPClass,
    true,
    "Unified Procedure Step - Event SOP Class - Trial (Retired)",
  );
  static const SopClassUid kUnifiedProcedureStep_PushSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.6.1",
          "UnifiedProcedureStep_PushSOPClass",
          UidType.kSOPClass,
          false,
          "Unified Procedure Step - Push SOP Class");
  static const SopClassUid kUnifiedProcedureStep_WatchSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.6.2",
          "UnifiedProcedureStep_WatchSOPClass",
          UidType.kSOPClass,
          false,
          "Unified Procedure Step - Watch SOP Class");
  static const SopClassUid kUnifiedProcedureStep_PullSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.6.3",
          "UnifiedProcedureStep_PullSOPClass",
          UidType.kSOPClass,
          false,
          "Unified Procedure Step - Pull SOP Class");
  static const SopClassUid kUnifiedProcedureStep_EventSOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.6.4",
          "UnifiedProcedureStep_EventSOPClass",
          UidType.kSOPClass,
          false,
          "Unified Procedure Step - Event SOP Class");
  static const SopClassUid kRTBeamsDeliveryInstructionStorage =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.7",
          "RTBeamsDeliveryInstructionStorage",
          UidType.kSOPClass,
          false,
          "RT Beams Delivery Instruction Storage");
  static const SopClassUid kRTConventionalMachineVerification =
      const SopClassUid(
          "1.2.840.10008.5.1.4.34.8",
          "RTConventionalMachineVerification",
          UidType.kSOPClass,
          false,
          "RT Conventional Machine Verification");
  static const SopClassUid kRTIonMachineVerification = const SopClassUid(
      "1.2.840.10008.5.1.4.34.9",
      "RTIonMachineVerification",
      UidType.kSOPClass,
      false,
      "RT Ion Machine Verification");
  static const SopClassUid kGeneralRelevantPatientInformationQuery =
      const SopClassUid(
          "1.2.840.10008.5.1.4.37.1",
          "GeneralRelevantPatientInformationQuery",
          UidType.kSOPClass,
          false,
          "General Relevant Patient Information Query");
  static const SopClassUid kBreastImagingRelevantPatientInformationQuery =
      const SopClassUid(
    "1.2.840.10008.5.1.4.37.2",
    "BreastImagingRelevantPatientInformationQuery",
    UidType.kSOPClass,
    false,
    "Breast Imaging Relevant Patient Information Query",
  );
  static const SopClassUid kCardiacRelevantPatientInformationQuery =
      const SopClassUid(
          "1.2.840.10008.5.1.4.37.3",
          "CardiacRelevantPatientInformationQuery",
          UidType.kSOPClass,
          false,
          "Cardiac Relevant Patient Information Query");
  static const SopClassUid kHangingProtocolStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.38.1",
      "HangingProtocolStorage",
      UidType.kSOPClass,
      false,
      "Hanging Protocol Storage");
  static const SopClassUid kHangingProtocolInformationModel_FIND =
      const SopClassUid(
          "1.2.840.10008.5.1.4.38.2",
          "HangingProtocolInformationModel_FIND",
          UidType.kSOPClass,
          false,
          "Hanging Protocol Information Model - FIND");
  static const SopClassUid kHangingProtocolInformationModel_MOVE =
      const SopClassUid(
          "1.2.840.10008.5.1.4.38.3",
          "HangingProtocolInformationModel_MOVE",
          UidType.kSOPClass,
          false,
          "Hanging Protocol Information Model - MOVE");
  static const SopClassUid kHangingProtocolInformationModel_GET =
      const SopClassUid(
          "1.2.840.10008.5.1.4.38.4",
          "HangingProtocolInformationModel_GET",
          UidType.kSOPClass,
          false,
          "Hanging Protocol Information Model - GET");
  static const SopClassUid kProductCharacteristicsQuerySOPClass =
      const SopClassUid(
          "1.2.840.10008.5.1.4.41",
          "ProductCharacteristicsQuerySOPClass",
          UidType.kSOPClass,
          false,
          "Product Characteristics Query SOP Class");
  static const SopClassUid kSubstanceApprovalQuerySOPClass = const SopClassUid(
      "1.2.840.10008.5.1.4.42",
      "SubstanceApprovalQuerySOPClass",
      UidType.kSOPClass,
      false,
      "Substance Approval Query SOP Class");
  static const SopClassUid kGenericImplantTemplateStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.43.1",
      "GenericImplantTemplateStorage",
      UidType.kSOPClass,
      false,
      "Generic Implant Template Storage");
  static const SopClassUid kGenericImplantTemplateInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.43.2",
    "GenericImplantTemplateInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - FIND",
  );
  static const SopClassUid kGenericImplantTemplateInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.43.3",
    "GenericImplantTemplateInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Generic Implant Template Information Model - MOVE",
  );
  static const SopClassUid kGenericImplantTemplateInformationModel_GET =
      const SopClassUid(
          "1.2.840.10008.5.1.4.43.4",
          "GenericImplantTemplateInformationModel_GET",
          UidType.kSOPClass,
          false,
          "Generic Implant Template Information Model - GET");
  static const SopClassUid kImplantAssemblyTemplateStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.44.1",
      "ImplantAssemblyTemplateStorage",
      UidType.kSOPClass,
      false,
      "Implant Assembly Template Storage");
  static const SopClassUid kImplantAssemblyTemplateInformationModel_FIND =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.2",
    "ImplantAssemblyTemplateInformationModel_FIND",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - FIND",
  );
  static const SopClassUid kImplantAssemblyTemplateInformationModel_MOVE =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.3",
    "ImplantAssemblyTemplateInformationModel_MOVE",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - MOVE",
  );
  static const SopClassUid kImplantAssemblyTemplateInformationModel_GET =
      const SopClassUid(
    "1.2.840.10008.5.1.4.44.4",
    "ImplantAssemblyTemplateInformationModel_GET",
    UidType.kSOPClass,
    false,
    "Implant Assembly Template Information Model - GET",
  );
  static const SopClassUid kImplantTemplateGroupStorage = const SopClassUid(
      "1.2.840.10008.5.1.4.45.1",
      "ImplantTemplateGroupStorage",
      UidType.kSOPClass,
      false,
      "Implant Template Group Storage");
  static const SopClassUid kImplantTemplateGroupInformationModel_FIND =
      const SopClassUid(
          "1.2.840.10008.5.1.4.45.2",
          "ImplantTemplateGroupInformationModel_FIND",
          UidType.kSOPClass,
          false,
          "Implant Template Group Information Model - FIND");
  static const SopClassUid kImplantTemplateGroupInformationModel_MOVE =
      const SopClassUid(
          "1.2.840.10008.5.1.4.45.3",
          "ImplantTemplateGroupInformationModel_MOVE",
          UidType.kSOPClass,
          false,
          "Implant Template Group Information Model - MOVE");
  static const SopClassUid kImplantTemplateGroupInformationModel_GET =
      const SopClassUid(
          "1.2.840.10008.5.1.4.45.4",
          "ImplantTemplateGroupInformationModel_GET",
          UidType.kSOPClass,
          false,
          "Implant Template Group Information Model - GET");

//TODO: finish Map

  static const Map<String, SopClassUid> members = const <String, SopClassUid>{};
}
