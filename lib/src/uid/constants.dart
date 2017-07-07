// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// This library contains compile time constant definitions of
/// "Well Known" UIDs and there corresponding [String] values.
/// All names  start with 'k'.
///
/// Note: These constants names use the ODW convention of starting with
/// the letter "k" with followed by the DICOM keyword.

const String kVerificationSOPClass = "1.2.840.10008.1.1";
const String kImplicitVRLittleEndian = "1.2.840.10008.1.2";
const String kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM =
    "1.2.840.10008.1.2";
const String kExplicitVRLittleEndian = "1.2.840.10008.1.2.1";
const String kDeflatedExplicitVRLittleEndian = "1.2.840.10008.1.2.1.99";
// ignore: constant_identifier_names
const String kExplicitVRBigEndian_Retired = "1.2.840.10008.1.2.2";
// ignore: constant_identifier_names
const String
    kJPEGBaseline_1DefaultTransferSyntaxforLossyJPEG8BitImageCompression =
    "1.2.840.10008.1.2.4.50";
// ignore: constant_identifier_names
const String
    kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 =
    "1.2.840.10008.1.2.4.51";
const String kJPEGExtended_3_5_Retired = "1.2.840.10008.1.2.4.52";
const String kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired =
    "1.2.840.10008.1.2.4.53";
const String kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired =
    "1.2.840.10008.1.2.4.54";
const String kJPEGFullProgressionNon_Hierarchical_10_12_Retired =
    "1.2.840.10008.1.2.4.55";
const String kJPEGFullProgressionNon_Hierarchical_11_13_Retired =
    "1.2.840.10008.1.2.4.56";
const String kJPEGLosslessNon_Hierarchical_14 = "1.2.840.10008.1.2.4.57";
const String kJPEGLosslessNon_Hierarchical_15_Retired =
    "1.2.840.10008.1.2.4.58";
const String kJPEGExtendedHierarchical_16_18_Retired = "1.2.840.10008.1.2.4.59";
const String kJPEGExtendedHierarchical_17_19_Retired = "1.2.840.10008.1.2.4.60";
const String kJPEGSpectralSelectionHierarchical_20_22_Retired =
    "1.2.840.10008.1.2.4.61";
const String kJPEGSpectralSelectionHierarchical_21_23_Retired =
    "1.2.840.10008.1.2.4.62";
const String kJPEGFullProgressionHierarchical_24_26_Retired =
    "1.2.840.10008.1.2.4.63";
const String kJPEGFullProgressionHierarchical_25_27_Retired =
    "1.2.840.10008.1.2.4.64";
const String kJPEGLosslessHierarchical_28_Retired = "1.2.840.10008.1.2.4.65";
const String kJPEGLosslessHierarchical_29_Retired = "1.2.840.10008.1.2.4.66";
const String
    kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
    "1.2.840.10008.1.2.4.70";
const String kJPEG_LSLosslessImageCompression = "1.2.840.10008.1.2.4.80";
const String kJPEG_LSLossyImageCompression = "1.2.840.10008.1.2.4.81";
const String kJPEG2000ImageCompressionLosslessOnly = "1.2.840.10008.1.2.4.90";
const String kJPEG2000ImageCompression = "1.2.840.10008.1.2.4.91";
const String kJPEG2000Part2Multi_componentImageCompressionLosslessOnly =
    "1.2.840.10008.1.2.4.92";
const String kJPEG2000Part2Multi_componentImageCompression =
    "1.2.840.10008.1.2.4.93";
const String kJPIPReferenced = "1.2.840.10008.1.2.4.94";
const String kJPIPReferencedDeflate = "1.2.840.10008.1.2.4.95";
const String kMPEG2MainProfile_MainLevel = "1.2.840.10008.1.2.4.100";
const String kMPEG2MainProfile_HighLevel = "1.2.840.10008.1.2.4.101";
const String kMPEG_4AVC_H264HighProfile_Level41 = "1.2.840.10008.1.2.4.102";
const String kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 =
    "1.2.840.10008.1.2.4.103";
const String kRLELossless = "1.2.840.10008.1.2.5";
const String kRFC2557MIMEencapsulation = "1.2.840.10008.1.2.6.1";
const String kXMLEncoding = "1.2.840.10008.1.2.6.2";
const String kMediaStorageDirectoryStorage = "1.2.840.10008.1.3.10";
const String kTalairachBrainAtlasFrameofReference = "1.2.840.10008.1.4.1.1";
const String kSPM2T1FrameofReference = "1.2.840.10008.1.4.1.2";
const String kSPM2T2FrameofReference = "1.2.840.10008.1.4.1.3";
const String kSPM2PDFrameofReference = "1.2.840.10008.1.4.1.4";
const String kSPM2EPIFrameofReference = "1.2.840.10008.1.4.1.5";
const String kSPM2FILT1FrameofReference = "1.2.840.10008.1.4.1.6";
const String kSPM2PETFrameofReference = "1.2.840.10008.1.4.1.7";
const String kSPM2TRANSMFrameofReference = "1.2.840.10008.1.4.1.8";
const String kSPM2SPECTFrameofReference = "1.2.840.10008.1.4.1.9";
const String kSPM2GRAYFrameofReference = "1.2.840.10008.1.4.1.10";
const String kSPM2WHITEFrameofReference = "1.2.840.10008.1.4.1.11";
const String kSPM2CSFFrameofReference = "1.2.840.10008.1.4.1.12";
const String kSPM2BRAINMASKFrameofReference = "1.2.840.10008.1.4.1.13";
const String kSPM2AVG305T1FrameofReference = "1.2.840.10008.1.4.1.14";
const String kSPM2AVG152T1FrameofReference = "1.2.840.10008.1.4.1.15";
const String kSPM2AVG152T2FrameofReference = "1.2.840.10008.1.4.1.16";
const String kSPM2AVG152PDFrameofReference = "1.2.840.10008.1.4.1.17";
const String kSPM2SINGLESUBJT1FrameofReference = "1.2.840.10008.1.4.1.18";
const String kICBM452T1FrameofReference = "1.2.840.10008.1.4.2.1";
const String kICBMSingleSubjectMRIFrameofReference = "1.2.840.10008.1.4.2.2";
const String kHotIronColorPaletteSOPInstance = "1.2.840.10008.1.5.1";
const String kPETColorPaletteSOPInstance = "1.2.840.10008.1.5.2";
const String kHotMetalBlueColorPaletteSOPInstance = "1.2.840.10008.1.5.3";
const String kPET20StepColorPaletteSOPInstance = "1.2.840.10008.1.5.4";
const String kBasicStudyContentNotificationSOPClass_Retired =
    "1.2.840.10008.1.9";
const String kStorageCommitmentPushModelSOPClass = "1.2.840.10008.1.20.1";
const String kStorageCommitmentPushModelSOPInstance = "1.2.840.10008.1.20.1.1";
const String kStorageCommitmentPullModelSOPClass_Retired =
    "1.2.840.10008.1.20.2";
const String kStorageCommitmentPullModelSOPInstance_Retired =
    "1.2.840.10008.1.20.2.1";
const String kProceduralEventLoggingSOPClass = "1.2.840.10008.1.40";
const String kProceduralEventLoggingSOPInstance = "1.2.840.10008.1.40.1";
const String kSubstanceAdministrationLoggingSOPClass = "1.2.840.10008.1.42";
const String kSubstanceAdministrationLoggingSOPInstance =
    "1.2.840.10008.1.42.1";
const String kDICOMUIDRegistry = "1.2.840.10008.2.6.1";
const String kDICOMControlledTerminology = "1.2.840.10008.2.16.4";
const String kDICOMApplicationContextName = "1.2.840.10008.3.1.1.1";
const String kDetachedPatientManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.1.1";
const String kDetachedPatientManagementMetaSOPClass_Retired =
    "1.2.840.10008.3.1.2.1.4";
const String kDetachedVisitManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.2.1";
const String kDetachedStudyManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.3.1";
const String kStudyComponentManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.3.2";
const String kModalityPerformedProcedureStepSOPClass =
    "1.2.840.10008.3.1.2.3.3";
const String kModalityPerformedProcedureStepRetrieveSOPClass =
    "1.2.840.10008.3.1.2.3.4";
const String kModalityPerformedProcedureStepNotificationSOPClass =
    "1.2.840.10008.3.1.2.3.5";
const String kDetachedResultsManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.5.1";
const String kDetachedResultsManagementMetaSOPClass_Retired =
    "1.2.840.10008.3.1.2.5.4";
const String kDetachedStudyManagementMetaSOPClass_Retired =
    "1.2.840.10008.3.1.2.5.5";
const String kDetachedInterpretationManagementSOPClass_Retired =
    "1.2.840.10008.3.1.2.6.1";
const String kStorageServiceClass = "1.2.840.10008.4.2";
const String kBasicFilmSessionSOPClass = "1.2.840.10008.5.1.1.1";
const String kBasicFilmBoxSOPClass = "1.2.840.10008.5.1.1.2";
const String kBasicGrayscaleImageBoxSOPClass = "1.2.840.10008.5.1.1.4";
const String kBasicColorImageBoxSOPClass = "1.2.840.10008.5.1.1.4.1";
const String kReferencedImageBoxSOPClass_Retired = "1.2.840.10008.5.1.1.4.2";
const String kBasicGrayscalePrintManagementMetaSOPClass =
    "1.2.840.10008.5.1.1.9";
const String kReferencedGrayscalePrintManagementMetaSOPClass_Retired =
    "1.2.840.10008.5.1.1.9.1";
const String kPrintJobSOPClass = "1.2.840.10008.5.1.1.14";
const String kBasicAnnotationBoxSOPClass = "1.2.840.10008.5.1.1.15";
const String kPrinterSOPClass = "1.2.840.10008.5.1.1.16";
const String kPrinterConfigurationRetrievalSOPClass =
    "1.2.840.10008.5.1.1.16.376";
const String kPrinterSOPInstance = "1.2.840.10008.5.1.1.17";
const String kPrinterConfigurationRetrievalSOPInstance =
    "1.2.840.10008.5.1.1.17.376";
const String kBasicColorPrintManagementMetaSOPClass = "1.2.840.10008.5.1.1.18";
const String kReferencedColorPrintManagementMetaSOPClass_Retired =
    "1.2.840.10008.5.1.1.18.1";
const String kVOILUTBoxSOPClass = "1.2.840.10008.5.1.1.22";
const String kPresentationLUTSOPClass = "1.2.840.10008.5.1.1.23";
const String kImageOverlayBoxSOPClass_Retired = "1.2.840.10008.5.1.1.24";
const String kBasicPrintImageOverlayBoxSOPClass_Retired =
    "1.2.840.10008.5.1.1.24.1";
const String kPrintQueueSOPInstance_Retired = "1.2.840.10008.5.1.1.25";
const String kPrintQueueManagementSOPClass_Retired = "1.2.840.10008.5.1.1.26";
const String kStoredPrintStorageSOPClass_Retired = "1.2.840.10008.5.1.1.27";
const String kHardcopyGrayscaleImageStorageSOPClass_Retired =
    "1.2.840.10008.5.1.1.29";
const String kHardcopyColorImageStorageSOPClass_Retired =
    "1.2.840.10008.5.1.1.30";
const String kPullPrintRequestSOPClass_Retired = "1.2.840.10008.5.1.1.31";
const String kPullStoredPrintManagementMetaSOPClass_Retired =
    "1.2.840.10008.5.1.1.32";
const String kMediaCreationManagementSOPClassUID = "1.2.840.10008.5.1.1.33";
const String kComputedRadiographyImageStorage = "1.2.840.10008.5.1.4.1.1.1";
const String kDigitalX_RayImageStorage_ForPresentation =
    "1.2.840.10008.5.1.4.1.1.1.1";
const String kDigitalX_RayImageStorage_ForProcessing =
    "1.2.840.10008.5.1.4.1.1.1.1.1";
const String kDigitalMammographyX_RayImageStorage_ForPresentation =
    "1.2.840.10008.5.1.4.1.1.1.2";
const String kDigitalMammographyX_RayImageStorage_ForProcessing =
    "1.2.840.10008.5.1.4.1.1.1.2.1";
const String kDigitalIntra_OralX_RayImageStorage_ForPresentation =
    "1.2.840.10008.5.1.4.1.1.1.3";
const String kDigitalIntra_OralX_RayImageStorage_ForProcessing =
    "1.2.840.10008.5.1.4.1.1.1.3.1";
const String kCTImageStorage = "1.2.840.10008.5.1.4.1.1.2";
const String kEnhancedCTImageStorage = "1.2.840.10008.5.1.4.1.1.2.1";
const String kLegacyConvertedEnhancedCTImageStorage =
    "1.2.840.10008.5.1.4.1.1.2.2";
const String kUltrasoundMulti_frameImageStorage_Retired =
    "1.2.840.10008.5.1.4.1.1.3";
const String kUltrasoundMulti_frameImageStorage = "1.2.840.10008.5.1.4.1.1.3.1";
const String kMRImageStorage = "1.2.840.10008.5.1.4.1.1.4";
const String kEnhancedMRImageStorage = "1.2.840.10008.5.1.4.1.1.4.1";
const String kMRSpectroscopyStorage = "1.2.840.10008.5.1.4.1.1.4.2";
const String kEnhancedMRColorImageStorage = "1.2.840.10008.5.1.4.1.1.4.3";
const String kLegacyConvertedEnhancedMRImageStorage =
    "1.2.840.10008.5.1.4.1.1.4.4";
const String kNuclearMedicineImageStorage_Retired = "1.2.840.10008.5.1.4.1.1.5";
const String kUltrasoundImageStorage_Retired = "1.2.840.10008.5.1.4.1.1.6";
const String kUltrasoundImageStorage = "1.2.840.10008.5.1.4.1.1.6.1";
const String kEnhancedUSVolumeStorage = "1.2.840.10008.5.1.4.1.1.6.2";
const String kSecondaryCaptureImageStorage = "1.2.840.10008.5.1.4.1.1.7";
const String kMulti_frameSingleBitSecondaryCaptureImageStorage =
    "1.2.840.10008.5.1.4.1.1.7.1";
const String kMulti_frameGrayscaleByteSecondaryCaptureImageStorage =
    "1.2.840.10008.5.1.4.1.1.7.2";
const String kMulti_frameGrayscaleWordSecondaryCaptureImageStorage =
    "1.2.840.10008.5.1.4.1.1.7.3";
const String kMulti_frameTrueColorSecondaryCaptureImageStorage =
    "1.2.840.10008.5.1.4.1.1.7.4";
const String kStandaloneOverlayStorage_Retired = "1.2.840.10008.5.1.4.1.1.8";
const String kStandaloneCurveStorage_Retired = "1.2.840.10008.5.1.4.1.1.9";
const String kWaveformStorage_Trial_Retired = "1.2.840.10008.5.1.4.1.1.9.1";
const String ktwelve_lead_12ECGWaveformStorage =
    "1.2.840.10008.5.1.4.1.1.9.1.1";
const String kGeneralECGWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.1.2";
const String kAmbulatoryECGWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.1.3";
const String kHemodynamicWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.2.1";
const String kCardiacElectrophysiologyWaveformStorage =
    "1.2.840.10008.5.1.4.1.1.9.3.1";
const String kBasicVoiceAudioWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.4.1";
const String kGeneralAudioWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.4.2";
const String kArterialPulseWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.5.1";
const String kRespiratoryWaveformStorage = "1.2.840.10008.5.1.4.1.1.9.6.1";
const String kStandaloneModalityLUTStorage_Retired =
    "1.2.840.10008.5.1.4.1.1.10";
const String kStandaloneVOILUTStorage_Retired = "1.2.840.10008.5.1.4.1.1.11";
const String kGrayscaleSoftcopyPresentationStateStorageSOPClass =
    "1.2.840.10008.5.1.4.1.1.11.1";
const String kColorSoftcopyPresentationStateStorageSOPClass =
    "1.2.840.10008.5.1.4.1.1.11.2";
const String kPseudo_ColorSoftcopyPresentationStateStorageSOPClass =
    "1.2.840.10008.5.1.4.1.1.11.3";
const String kBlendingSoftcopyPresentationStateStorageSOPClass =
    "1.2.840.10008.5.1.4.1.1.11.4";
const String kXA_XRFGrayscaleSoftcopyPresentationStateStorage =
    "1.2.840.10008.5.1.4.1.1.11.5";
const String kX_RayAngiographicImageStorage = "1.2.840.10008.5.1.4.1.1.12.1";
const String kEnhancedXAImageStorage = "1.2.840.10008.5.1.4.1.1.12.1.1";
const String kX_RayRadiofluoroscopicImageStorage =
    "1.2.840.10008.5.1.4.1.1.12.2";
const String kEnhancedXRFImageStorage = "1.2.840.10008.5.1.4.1.1.12.2.1";
const String kX_RayAngiographicBi_PlaneImageStorage_Retired =
    "1.2.840.10008.5.1.4.1.1.12.3";
const String kX_Ray3DAngiographicImageStorage =
    "1.2.840.10008.5.1.4.1.1.13.1.1";
const String kX_Ray3DCraniofacialImageStorage =
    "1.2.840.10008.5.1.4.1.1.13.1.2";
const String kBreastTomosynthesisImageStorage =
    "1.2.840.10008.5.1.4.1.1.13.1.3";
const String
    kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation =
    "1.2.840.10008.5.1.4.1.1.14.1";
const String
    kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing =
    "1.2.840.10008.5.1.4.1.1.14.2";
const String kNuclearMedicineImageStorage = "1.2.840.10008.5.1.4.1.1.20";
const String kRawDataStorage = "1.2.840.10008.5.1.4.1.1.66";
const String kSpatialRegistrationStorage = "1.2.840.10008.5.1.4.1.1.66.1";
const String kSpatialFiducialsStorage = "1.2.840.10008.5.1.4.1.1.66.2";
const String kDeformableSpatialRegistrationStorage =
    "1.2.840.10008.5.1.4.1.1.66.3";
const String kSegmentationStorage = "1.2.840.10008.5.1.4.1.1.66.4";
const String kSurfaceSegmentationStorage = "1.2.840.10008.5.1.4.1.1.66.5";
const String kRealWorldValueMappingStorage = "1.2.840.10008.5.1.4.1.1.67";
const String kSurfaceScanMeshStorage = "1.2.840.10008.5.1.4.1.1.68.1";
const String kSurfaceScanPointCloudStorage = "1.2.840.10008.5.1.4.1.1.68.2";
const String kVLImageStorage_Trial_Retired = "1.2.840.10008.5.1.4.1.1.77.1";
const String kVLMulti_frameImageStorage_Trial_Retired =
    "1.2.840.10008.5.1.4.1.1.77.2";
const String kVLEndoscopicImageStorage = "1.2.840.10008.5.1.4.1.1.77.1.1";
const String kVideoEndoscopicImageStorage = "1.2.840.10008.5.1.4.1.1.77.1.1.1";
const String kVLMicroscopicImageStorage = "1.2.840.10008.5.1.4.1.1.77.1.2";
const String kVideoMicroscopicImageStorage = "1.2.840.10008.5.1.4.1.1.77.1.2.1";
const String kVLSlide_CoordinatesMicroscopicImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.3";
const String kVLPhotographicImageStorage = "1.2.840.10008.5.1.4.1.1.77.1.4";
const String kVideoPhotographicImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.4.1";
const String kOphthalmicPhotography8BitImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.5.1";
const String kOphthalmicPhotography16BitImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.5.2";
const String kStereometricRelationshipStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.5.3";
const String kOphthalmicTomographyImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.5.4";
const String kVLWholeSlideMicroscopyImageStorage =
    "1.2.840.10008.5.1.4.1.1.77.1.6";
const String kLensometryMeasurementsStorage = "1.2.840.10008.5.1.4.1.1.78.1";
const String kAutorefractionMeasurementsStorage =
    "1.2.840.10008.5.1.4.1.1.78.2";
const String kKeratometryMeasurementsStorage = "1.2.840.10008.5.1.4.1.1.78.3";
const String kSubjectiveRefractionMeasurementsStorage =
    "1.2.840.10008.5.1.4.1.1.78.4";
const String kVisualAcuityMeasurementsStorage = "1.2.840.10008.5.1.4.1.1.78.5";
const String kSpectaclePrescriptionReportStorage =
    "1.2.840.10008.5.1.4.1.1.78.6";
const String kOphthalmicAxialMeasurementsStorage =
    "1.2.840.10008.5.1.4.1.1.78.7";
const String kIntraocularLensCalculationsStorage =
    "1.2.840.10008.5.1.4.1.1.78.8";
const String kMacularGridThicknessandVolumeReportStorage =
    "1.2.840.10008.5.1.4.1.1.79.1";
const String kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage =
    "1.2.840.10008.5.1.4.1.1.80.1";
const String kOphthalmicThicknessMapStorage = "1.2.840.10008.5.1.4.1.1.81.1";
const String kCornealTopographyMapStorage = "11.2.840.10008.5.1.4.1.1.82.1";
const String kTextSRStorage_Trial_Retired = "1.2.840.10008.5.1.4.1.1.88.1";
const String kAudioSRStorage_Trial_Retired = "1.2.840.10008.5.1.4.1.1.88.2";
const String kDetailSRStorage_Trial_Retired = "1.2.840.10008.5.1.4.1.1.88.3";
const String kComprehensiveSRStorage_Trial_Retired =
    "1.2.840.10008.5.1.4.1.1.88.4";
const String kBasicTextSRStorage = "1.2.840.10008.5.1.4.1.1.88.11";
const String kEnhancedSRStorage = "1.2.840.10008.5.1.4.1.1.88.22";
const String kComprehensiveSRStorage = "1.2.840.10008.5.1.4.1.1.88.33";
const String kComprehensive3DSRStorage = "1.2.840.10008.5.1.4.1.1.88.34";
const String kProcedureLogStorage = "1.2.840.10008.5.1.4.1.1.88.40";
const String kMammographyCADSRStorage = "1.2.840.10008.5.1.4.1.1.88.50";
const String kKeyObjectSelectionDocumentStorage =
    "1.2.840.10008.5.1.4.1.1.88.59";
const String kChestCADSRStorage = "1.2.840.10008.5.1.4.1.1.88.65";
const String kX_RayRadiationDoseSRStorage = "1.2.840.10008.5.1.4.1.1.88.67";
const String kColonCADSRStorage = "1.2.840.10008.5.1.4.1.1.88.69";
const String kImplantationPlanSRStorage = "1.2.840.10008.5.1.4.1.1.88.70";
const String kEncapsulatedPDFStorage = "1.2.840.10008.5.1.4.1.1.104.1";
const String kEncapsulatedCDAStorage = "1.2.840.10008.5.1.4.1.1.104.2";
const String kPositronEmissionTomographyImageStorage =
    "1.2.840.10008.5.1.4.1.1.128";
const String kLegacyConvertedEnhancedPETImageStorage =
    "1.2.840.10008.5.1.4.1.1.128.1";
const String kStandalonePETCurveStorage_Retired = "1.2.840.10008.5.1.4.1.1.129";
const String kEnhancedPETImageStorage = "1.2.840.10008.5.1.4.1.1.130";
const String kBasicStructuredDisplayStorage = "1.2.840.10008.5.1.4.1.1.131";
const String kRTImageStorage = "1.2.840.10008.5.1.4.1.1.481.1";
const String kRTDoseStorage = "1.2.840.10008.5.1.4.1.1.481.2";
const String kRTStructureSetStorage = "1.2.840.10008.5.1.4.1.1.481.3";
const String kRTBeamsTreatmentRecordStorage = "1.2.840.10008.5.1.4.1.1.481.4";
const String kRTPlanStorage = "1.2.840.10008.5.1.4.1.1.481.5";
const String kRTBrachyTreatmentRecordStorage = "1.2.840.10008.5.1.4.1.1.481.6";
const String kRTTreatmentSummaryRecordStorage = "1.2.840.10008.5.1.4.1.1.481.7";
const String kRTIonPlanStorage = "1.2.840.10008.5.1.4.1.1.481.8";
const String kRTIonBeamsTreatmentRecordStorage =
    "1.2.840.10008.5.1.4.1.1.481.9";
const String kDICOSCTImageStorage = "1.2.840.10008.5.1.4.1.1.501.1";
const String kDICOSDigitalX_RayImageStorage_ForPresentation =
    "1.2.840.10008.5.1.4.1.1.501.2.1";
const String kDICOSDigitalX_RayImageStorage_ForProcessing =
    "1.2.840.10008.5.1.4.1.1.501.2.2";
const String kDICOSThreatDetectionReportStorage =
    "1.2.840.10008.5.1.4.1.1.501.3";
const String kDICOS2DAITStorage = "1.2.840.10008.5.1.4.1.1.501.4";
const String kDICOS3DAITStorage = "1.2.840.10008.5.1.4.1.1.501.5";
const String kDICOSQuadrupoleResonanceStorage = "1.2.840.10008.5.1.4.1.1.501.6";
const String kEddyCurrentImageStorage = "1.2.840.10008.5.1.4.1.1.601.1";
const String kEddyCurrentMulti_frameImageStorage =
    "1.2.840.10008.5.1.4.1.1.601.2";
const String kPatientRootQuery_RetrieveInformationModel_FIND =
    "1.2.840.10008.5.1.4.1.2.1.1";
const String kPatientRootQuery_RetrieveInformationModel_MOVE =
    "1.2.840.10008.5.1.4.1.2.1.2";
const String kPatientRootQuery_RetrieveInformationModel_GET =
    "1.2.840.10008.5.1.4.1.2.1.3";
const String kStudyRootQuery_RetrieveInformationModel_FIND =
    "1.2.840.10008.5.1.4.1.2.2.1";
const String kStudyRootQuery_RetrieveInformationModel_MOVE =
    "1.2.840.10008.5.1.4.1.2.2.2";
const String kStudyRootQuery_RetrieveInformationModel_GET =
    "1.2.840.10008.5.1.4.1.2.2.3";
const String kPatient_StudyOnlyQuery_RetrieveInformationModel_FIND_Retired =
    "1.2.840.10008.5.1.4.1.2.3.1";
const String kPatient_StudyOnlyQuery_RetrieveInformationModel_MOVE_Retired =
    "1.2.840.10008.5.1.4.1.2.3.2";
const String kPatient_StudyOnlyQuery_RetrieveInformationModel_GET_Retired =
    "1.2.840.10008.5.1.4.1.2.3.3";
const String kCompositeInstanceRootRetrieve_MOVE =
    "1.2.840.10008.5.1.4.1.2.4.2";
const String kCompositeInstanceRootRetrieve_GET = "1.2.840.10008.5.1.4.1.2.4.3";
const String kCompositeInstanceRetrieveWithoutBulkData_GET =
    "1.2.840.10008.5.1.4.1.2.5.3";
const String kModalityWorklistInformationModel_FIND = "1.2.840.10008.5.1.4.31";
const String kGeneralPurposeWorklistInformationModel_FIND_Retired =
    "1.2.840.10008.5.1.4.32.1";
const String kGeneralPurposeScheduledProcedureStepSOPClass_Retired =
    "1.2.840.10008.5.1.4.32.2";
const String kGeneralPurposePerformedProcedureStepSOPClass_Retired =
    "1.2.840.10008.5.1.4.32.3";
const String kGeneralPurposeWorklistManagementMetaSOPClass_Retired =
    "1.2.840.10008.5.1.4.32";
const String kInstanceAvailabilityNotificationSOPClass =
    "1.2.840.10008.5.1.4.33";
const String kRTBeamsDeliveryInstructionStorage_Trial_Retired =
    "1.2.840.10008.5.1.4.34.1";
const String kRTConventionalMachineVerification_Trial_Retired =
    "1.2.840.10008.5.1.4.34.2";
const String kRTIonMachineVerification_Trial_Retired =
    "1.2.840.10008.5.1.4.34.3";
const String kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired =
    "1.2.840.10008.5.1.4.34.4";
const String kUnifiedProcedureStep_PushSOPClass_Trial_Retired =
    "1.2.840.10008.5.1.4.34.4.1";
const String kUnifiedProcedureStep_WatchSOPClass_Trial_Retired =
    "1.2.840.10008.5.1.4.34.4.2";
const String kUnifiedProcedureStep_PullSOPClass_Trial_Retired =
    "1.2.840.10008.5.1.4.34.4.3";
const String kUnifiedProcedureStep_EventSOPClass_Trial_Retired =
    "1.2.840.10008.5.1.4.34.4.4";
const String kUnifiedWorklistandProcedureStepSOPInstance =
    "1.2.840.10008.5.1.4.34.5";
const String kUnifiedWorklistandProcedureStepServiceClass =
    "1.2.840.10008.5.1.4.34.6";
const String kUnifiedProcedureStep_PushSOPClass = "1.2.840.10008.5.1.4.34.6.1";
const String kUnifiedProcedureStep_WatchSOPClass = "1.2.840.10008.5.1.4.34.6.2";
const String kUnifiedProcedureStep_PullSOPClass = "1.2.840.10008.5.1.4.34.6.3";
const String kUnifiedProcedureStep_EventSOPClass = "1.2.840.10008.5.1.4.34.6.4";
const String kRTBeamsDeliveryInstructionStorage = "1.2.840.10008.5.1.4.34.7";
const String kRTConventionalMachineVerification = "1.2.840.10008.5.1.4.34.8";
const String kRTIonMachineVerification = "1.2.840.10008.5.1.4.34.9";
const String kGeneralRelevantPatientInformationQuery =
    "1.2.840.10008.5.1.4.37.1";
const String kBreastImagingRelevantPatientInformationQuery =
    "1.2.840.10008.5.1.4.37.2";
const String kCardiacRelevantPatientInformationQuery =
    "1.2.840.10008.5.1.4.37.3";
const String kHangingProtocolStorage = "1.2.840.10008.5.1.4.38.1";
const String kHangingProtocolInformationModel_FIND = "1.2.840.10008.5.1.4.38.2";
const String kHangingProtocolInformationModel_MOVE = "1.2.840.10008.5.1.4.38.3";
const String kHangingProtocolInformationModel_GET = "1.2.840.10008.5.1.4.38.4";
const String kColorPaletteStorage = "1.2.840.10008.5.1.4.39.1";
const String kColorPaletteInformationModel_FIND = "1.2.840.10008.5.1.4.39.2";
const String kColorPaletteInformationModel_MOVE = "1.2.840.10008.5.1.4.39.3";
const String kColorPaletteInformationModel_GET = "1.2.840.10008.5.1.4.39.4";
const String kProductCharacteristicsQuerySOPClass = "1.2.840.10008.5.1.4.41";
const String kSubstanceApprovalQuerySOPClass = "1.2.840.10008.5.1.4.42";
const String kGenericImplantTemplateStorage = "1.2.840.10008.5.1.4.43.1";
const String kGenericImplantTemplateInformationModel_FIND =
    "1.2.840.10008.5.1.4.43.2";
const String kGenericImplantTemplateInformationModel_MOVE =
    "1.2.840.10008.5.1.4.43.3";
const String kGenericImplantTemplateInformationModel_GET =
    "1.2.840.10008.5.1.4.43.4";
const String kImplantAssemblyTemplateStorage = "1.2.840.10008.5.1.4.44.1";
const String kImplantAssemblyTemplateInformationModel_FIND =
    "1.2.840.10008.5.1.4.44.2";
const String kImplantAssemblyTemplateInformationModel_MOVE =
    "1.2.840.10008.5.1.4.44.3";
const String kImplantAssemblyTemplateInformationModel_GET =
    "1.2.840.10008.5.1.4.44.4";
const String kImplantTemplateGroupStorage = "1.2.840.10008.5.1.4.45.1";
const String kImplantTemplateGroupInformationModel_FIND =
    "1.2.840.10008.5.1.4.45.2";
const String kImplantTemplateGroupInformationModel_MOVE =
    "1.2.840.10008.5.1.4.45.3";
const String kImplantTemplateGroupInformationModel_GET =
    "1.2.840.10008.5.1.4.45.4";
const String kNativeDICOMModel = "1.2.840.10008.7.1.1";
const String kAbstractMulti_DimensionalImageModel = "1.2.840.10008.7.1.2";
const String kdicomDeviceName = "1.2.840.10008.15.0.3.1";
const String kdicomDescription = "1.2.840.10008.15.0.3.2";
const String kdicomManufacturer = "1.2.840.10008.15.0.3.3";
const String kdicomManufacturerModelName = "1.2.840.10008.15.0.3.4";
const String kdicomSoftwareVersion = "1.2.840.10008.15.0.3.5";
const String kdicomVendorData = "1.2.840.10008.15.0.3.6";
const String kdicomAETitle = "1.2.840.10008.15.0.3.7";
const String kdicomNetworkConnectionReference = "1.2.840.10008.15.0.3.8";
const String kdicomApplicationCluster = "1.2.840.10008.15.0.3.9";
const String kdicomAssociationInitiator = "1.2.840.10008.15.0.3.10";
const String kdicomAssociationAcceptor = "1.2.840.10008.15.0.3.11";
const String kdicomHostname = "1.2.840.10008.15.0.3.12";
const String kdicomPort = "1.2.840.10008.15.0.3.13";
const String kdicomSOPClass = "1.2.840.10008.15.0.3.14";
const String kdicomTransferRole = "1.2.840.10008.15.0.3.15";
const String kdicomTransferSyntax = "1.2.840.10008.15.0.3.16";
const String kdicomPrimaryDeviceType = "1.2.840.10008.15.0.3.17";
const String kdicomRelatedDeviceReference = "1.2.840.10008.15.0.3.18";
const String kdicomPreferredCalledAETitle = "1.2.840.10008.15.0.3.19";
const String kdicomTLSCyphersuite = "1.2.840.10008.15.0.3.20";
const String kdicomAuthorizedNodeCertificateReference =
    "1.2.840.10008.15.0.3.21";
const String kdicomThisNodeCertificateReference = "1.2.840.10008.15.0.3.22";
const String kdicomInstalled = "1.2.840.10008.15.0.3.23";
const String kdicomStationName = "1.2.840.10008.15.0.3.24";
const String kdicomDeviceSerialNumber = "1.2.840.10008.15.0.3.25";
const String kdicomInstitutionName = "1.2.840.10008.15.0.3.26";
const String kdicomInstitutionAddress = "1.2.840.10008.15.0.3.27";
const String kdicomInstitutionDepartmentName = "1.2.840.10008.15.0.3.28";
const String kdicomIssuerOfPatientID = "1.2.840.10008.15.0.3.29";
const String kdicomPreferredCallingAETitle = "1.2.840.10008.15.0.3.30";
const String kdicomSupportedCharacterSet = "1.2.840.10008.15.0.3.31";
const String kdicomConfigurationRoot = "1.2.840.10008.15.0.4.1";
const String kdicomDevicesRoot = "1.2.840.10008.15.0.4.2";
const String kdicomUniqueAETitlesRegistryRoot = "1.2.840.10008.15.0.4.3";
const String kdicomDevice = "1.2.840.10008.15.0.4.4";
const String kdicomNetworkAE = "1.2.840.10008.15.0.4.5";
const String kdicomNetworkConnection = "1.2.840.10008.15.0.4.6";
const String kdicomUniqueAETitle = "1.2.840.10008.15.0.4.7";
const String kdicomTransferCapability = "1.2.840.10008.15.0.4.8";
const String kUniversalCoordinatedTime = "1.2.840.10008.15.1.1";
