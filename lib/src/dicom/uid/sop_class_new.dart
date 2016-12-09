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

import 'package:dictionary/src/dicom/uid/wk_uid.dart';
import 'package:dictionary/src/dicom/uid/wk_uid_type.dart';

//TODO: fix this class

class SopClassUid extends WKUid {
    static const String classLink = 'TODO link';

    const SopClassUid(String uid, WKUidType type, bool isRetired, String name, String link)
        : super(uid, type, isRetired, name, link);

    //TODO: create UidType class
    bool get isSopClass => true;

    //TODO: Make this print SOP Class
    String toString() => '$runtimeType($string)';

    static SopClassUid lookup(v) {
        WKUid wk = WKUid.lookup(v);
        return ((wk != null) && (wk.type == WKUidType.kSopClass)) ? wk : null;
    }


    static const kVerificationSOPClass = const SopClassUid(
        "1.2.840.10008.1.1", WKUidType.kSopClass, false, "Verification SOP Class", "PS3.4");

    static const kMediaStorageDirectoryStorage = const WKUid("1.2.840.10008.1.3.10",
                                                                 WKUidType.kSopClass, false, "Media Storage Directory Storage", "PS3.4");

    static const kBasicStudyContentNotificationSOPClass_Retired = const WKUid("1.2.840.10008.1.9",
                                                                                  WKUidType.kSopClass, true, "Basic Study Content Notification SOP Class (Retired)", "PS3.4");
    static const kStorageCommitmentPushModelSOPClass = const WKUid("1.2.840.10008.1.20.1",
                                                                       WKUidType.kSopClass, true, "Storage Commitment Push Model SOP Class", "PS3.4");

    static const kStorageCommitmentPullModelSOPClass_Retired = const WKUid("1.2.840.10008.1.20.2",
                                                                               WKUidType.kSopClass, true, "Storage Commitment Pull Model SOP Class (Retired)", "PS3.4");

    static const kProceduralEventLoggingSOPClass = const WKUid("1.2.840.10008.1.40",
                                                                   WKUidType.kSopClass, false, "Procedural Event Logging SOP Class", "PS3.4");

    static const kSubstanceAdministrationLoggingSOPClass = const WKUid("1.2.840.10008.1.42",
                                                                           WKUidType.kSopClass, false, "Substance Administration Logging SOP Class", "PS3.4");
    static const kDetachedPatientManagementSOPClass_Retired = const WKUid("1.2.840.10008.3.1.2.1.1",
                                                                              WKUidType.kSopClass, true, "Detached Patient Management SOP Class (Retired)", "PS3.4");

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
    static const kDetachedInterpretationManagementSOPClass_Retired = const WKUid(
        "1.2.840.10008.3.1.2.6.1",
        WKUidType.kSopClass,
        true,
        "Detached Interpretation Management SOP Class (Retired)",
        "PS3.4");

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
    static const kPrintJobSOPClass = const WKUid(
        "1.2.840.10008.5.1.1.14", WKUidType.kSopClass, false, "Print Job SOP Class", "PS3.4");
    static const kBasicAnnotationBoxSOPClass = const WKUid("1.2.840.10008.5.1.1.15",
                                                               WKUidType.kSopClass, false, "Basic Annotation Box SOP Class", "PS3.4");
    static const kPrinterSOPClass = const WKUid(
        "1.2.840.10008.5.1.1.16", WKUidType.kSopClass, false, "Printer SOP Class", "PS3.4");
    static const kPrinterConfigurationRetrievalSOPClass = const WKUid("1.2.840.10008.5.1.1.16.376",
                                                                          WKUidType.kSopClass, false, "Printer Configuration Retrieval SOP Class", "PS3.4");
    static const kVOILUTBoxSOPClass = const WKUid(
        "1.2.840.10008.5.1.1.22", WKUidType.kSopClass, false, "VOI LUT Box SOP Class", "PS3.4");
    static const kPresentationLUTSOPClass = const WKUid(
        "1.2.840.10008.5.1.1.23", WKUidType.kSopClass, false, "Presentation LUT SOP Class", "PS3.4");
    static const kImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24",
                                                                    WKUidType.kSopClass, true, "Image Overlay Box SOP Class (Retired)", "PS3.4");
    static const kBasicPrintImageOverlayBoxSOPClass_Retired = const WKUid("1.2.840.10008.5.1.1.24.1",
                                                                              WKUidType.kSopClass, true, "Basic Print Image Overlay Box SOP Class (Retired)", "PS3.4");

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
    static const kMRSpectroscopyStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.2",
                                                          WKUidType.kSopClass, false, "MR Spectroscopy Storage", "PS3.4");
    static const kEnhancedMRColorImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.3",
                                                                WKUidType.kSopClass, false, "Enhanced MR Color Image Storage", "PS3.4");
    static const kLegacyConvertedEnhancedMRImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.4.4",
                                                                          WKUidType.kSopClass, false, "Legacy Converted Enhanced MR Image Storage", "PS3.4");
    static const kNuclearMedicineImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.5",
                                                                        WKUidType.kSopClass, true, "Nuclear Medicine Image Storage (Retired)", "PS3.4");
    static const kUltrasoundImageStorage_Retired = const WKUid("1.2.840.10008.5.1.4.1.1.6",
                                                                   WKUidType.kSopClass, true, "Ultrasound Image Storage (Retired)", "PS3.4");
    static const kUltrasoundImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.6.1",
                                                           WKUidType.kSopClass, false, "Ultrasound Image Storage", "PS3.4");
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
    static const kBasicTextSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.11",
                                                       WKUidType.kSopClass, false, "Basic Text SR Storage", "PS3.4");
    static const kEnhancedSRStorage = const WKUid(
        "1.2.840.10008.5.1.4.1.1.88.22", WKUidType.kSopClass, false, "Enhanced SR Storage", "PS3.4");
    static const kComprehensiveSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.33",
                                                           WKUidType.kSopClass, false, "Comprehensive SR Storage", "PS3.4");
    static const kComprehensive3DSRStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.34",
                                                             WKUidType.kSopClass, false, "Comprehensive 3D SR Storage", "PS3.4");
    static const kProcedureLogStorage = const WKUid("1.2.840.10008.5.1.4.1.1.88.40",
                                                        WKUidType.kSopClass, false, "Procedure Log Storage", "PS3.4");
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
    static const kDICOSCTImageStorage = const WKUid("1.2.840.10008.5.1.4.1.1.501.1",
                                                        WKUidType.kSopClass, false, "DICOS CT Image Storage", "DICOS");
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
    static const kRTIonMachineVerification = const WKUid("1.2.840.10008.5.1.4.34.9",
                                                             WKUidType.kSopClass, false, "RT Ion Machine Verification", "PS3.4");
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

//TODO: finish adding classes
}
