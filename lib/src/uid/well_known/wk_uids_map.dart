// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'wk_uid.dart';

//TODO: doc
//TODO: change entries to proper type
const Map<String, WKUid> wellKnownUids = const {
  "1.2.840.10008.1.1": WKUid.kVerificationSOPClass,
  "1.2.840.10008.1.2": WKUid.kImplicitVRLittleEndian,
  "1.2.840.10008.1.2.1": WKUid.kExplicitVRLittleEndian,
  "1.2.840.10008.1.2.1.99": WKUid.kDeflatedExplicitVRLittleEndian,
  "1.2.840.10008.1.2.2": WKUid.kExplicitVRBigEndian_Retired,
  "1.2.840.10008.1.2.4.50": WKUid.kJPEGBaseline_1,
  "1.2.840.10008.1.2.4.51": WKUid
      .kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4,
  "1.2.840.10008.1.2.4.52": WKUid.kJPEGExtended_3_5_Retired,
  "1.2.840.10008.1.2.4.53":
      WKUid.kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired,
  "1.2.840.10008.1.2.4.54":
      WKUid.kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired,
  "1.2.840.10008.1.2.4.55":
      WKUid.kJPEGFullProgressionNon_Hierarchical_10_12_Retired,
  "1.2.840.10008.1.2.4.56":
      WKUid.kJPEGFullProgressionNon_Hierarchical_11_13_Retired,
  "1.2.840.10008.1.2.4.57": WKUid.kJPEGLosslessNon_Hierarchical_14,
  "1.2.840.10008.1.2.4.58": WKUid.kJPEGLosslessNon_Hierarchical_15_Retired,
  "1.2.840.10008.1.2.4.59": WKUid.kJPEGExtendedHierarchical_16_18_Retired,
  "1.2.840.10008.1.2.4.60": WKUid.kJPEGExtendedHierarchical_17_19_Retired,
  "1.2.840.10008.1.2.4.61":
      WKUid.kJPEGSpectralSelectionHierarchical_20_22_Retired,
  "1.2.840.10008.1.2.4.62":
      WKUid.kJPEGSpectralSelectionHierarchical_21_23_Retired,
  "1.2.840.10008.1.2.4.63":
      WKUid.kJPEGFullProgressionHierarchical_24_26_Retired,
  "1.2.840.10008.1.2.4.64":
      WKUid.kJPEGFullProgressionHierarchical_25_27_Retired,
  "1.2.840.10008.1.2.4.65": WKUid.kJPEGLosslessHierarchical_28_Retired,
  "1.2.840.10008.1.2.4.66": WKUid.kJPEGLosslessHierarchical_29_Retired,
  "1.2.840.10008.1.2.4.70": WKUid
      .kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression,
  "1.2.840.10008.1.2.4.80": WKUid.kJPEG_LSLosslessImageCompression,
  "1.2.840.10008.1.2.4.81": WKUid.kJPEG_LSLossyImageCompression,
  "1.2.840.10008.1.2.4.90": WKUid.kJPEG2000ImageCompressionLosslessOnly,
  "1.2.840.10008.1.2.4.91": WKUid.kJPEG2000ImageCompression,
  "1.2.840.10008.1.2.4.92":
      WKUid.kJPEG2000Part2Multi_componentImageCompressionLosslessOnly,
  "1.2.840.10008.1.2.4.93": WKUid.kJPEG2000Part2Multi_componentImageCompression,
  "1.2.840.10008.1.2.4.94": WKUid.kJPIPReferenced,
  "1.2.840.10008.1.2.4.95": WKUid.kJPIPReferencedDeflate,
  "1.2.840.10008.1.2.4.100": WKUid.kMPEG2MainProfile_MainLevel,
  "1.2.840.10008.1.2.4.101": WKUid.kMPEG2MainProfile_HighLevel,
  "1.2.840.10008.1.2.4.102": WKUid.kMPEG_4AVC_H264HighProfile_Level41,
  "1.2.840.10008.1.2.4.103":
      WKUid.kMPEG_4AVC_H264BD_compatibleHighProfile_Level41,
  "1.2.840.10008.1.2.5": WKUid.kRLELossless,
  "1.2.840.10008.1.2.6.1": WKUid.kRFC2557MIMEencapsulation,
  "1.2.840.10008.1.2.6.2": WKUid.kXMLEncoding,
  "1.2.840.10008.1.3.10": WKUid.kMediaStorageDirectoryStorage,
  "1.2.840.10008.1.4.1.1": WKUid.kTalairachBrainAtlasFrameofReference,
  "1.2.840.10008.1.4.1.2": WKUid.kSPM2T1FrameofReference,
  "1.2.840.10008.1.4.1.3": WKUid.kSPM2T2FrameofReference,
  "1.2.840.10008.1.4.1.4": WKUid.kSPM2PDFrameofReference,
  "1.2.840.10008.1.4.1.5": WKUid.kSPM2EPIFrameofReference,
  "1.2.840.10008.1.4.1.6": WKUid.kSPM2FILT1FrameofReference,
  "1.2.840.10008.1.4.1.7": WKUid.kSPM2PETFrameofReference,
  "1.2.840.10008.1.4.1.8": WKUid.kSPM2TRANSMFrameofReference,
  "1.2.840.10008.1.4.1.9": WKUid.kSPM2SPECTFrameofReference,
  "1.2.840.10008.1.4.1.10": WKUid.kSPM2GRAYFrameofReference,
  "1.2.840.10008.1.4.1.11": WKUid.kSPM2WHITEFrameofReference,
  "1.2.840.10008.1.4.1.12": WKUid.kSPM2CSFFrameofReference,
  "1.2.840.10008.1.4.1.13": WKUid.kSPM2BRAINMASKFrameofReference,
  "1.2.840.10008.1.4.1.14": WKUid.kSPM2AVG305T1FrameofReference,
  "1.2.840.10008.1.4.1.15": WKUid.kSPM2AVG152T1FrameofReference,
  "1.2.840.10008.1.4.1.16": WKUid.kSPM2AVG152T2FrameofReference,
  "1.2.840.10008.1.4.1.17": WKUid.kSPM2AVG152PDFrameofReference,
  "1.2.840.10008.1.4.1.18": WKUid.kSPM2SINGLESUBJT1FrameofReference,
  "1.2.840.10008.1.4.2.1": WKUid.kICBM452T1FrameofReference,
  "1.2.840.10008.1.4.2.2": WKUid.kICBMSingleSubjectMRIFrameofReference,
  "1.2.840.10008.1.5.1": WKUid.kHotIronColorPaletteSOPInstance,
  "1.2.840.10008.1.5.2": WKUid.kPETColorPaletteSOPInstance,
  "1.2.840.10008.1.5.3": WKUid.kHotMetalBlueColorPaletteSOPInstance,
  "1.2.840.10008.1.5.4": WKUid.kPET20StepColorPaletteSOPInstance,
  "1.2.840.10008.1.9": WKUid.kBasicStudyContentNotificationSOPClass_Retired,
  "1.2.840.10008.1.20.1": WKUid.kStorageCommitmentPushModelSOPClass,
  "1.2.840.10008.1.20.1.1": WKUid.kStorageCommitmentPushModelSOPInstance,
  "1.2.840.10008.1.20.2": WKUid.kStorageCommitmentPullModelSOPClass_Retired,
  "1.2.840.10008.1.20.2.1":
      WKUid.kStorageCommitmentPullModelSOPInstance_Retired,
  "1.2.840.10008.1.40": WKUid.kProceduralEventLoggingSOPClass,
  "1.2.840.10008.1.40.1": WKUid.kProceduralEventLoggingSOPInstance,
  "1.2.840.10008.1.42": WKUid.kSubstanceAdministrationLoggingSOPClass,
  "1.2.840.10008.1.42.1": WKUid.kSubstanceAdministrationLoggingSOPInstance,
  "1.2.840.10008.2.6.1": WKUid.kDICOMUIDRegistry,
  "1.2.840.10008.2.16.4": WKUid.kDICOMControlledTerminology,
  "1.2.840.10008.3.1.1.1": WKUid.kDICOMApplicationContextName,
  "1.2.840.10008.3.1.2.1.1": WKUid.kDetachedPatientManagementSOPClass_Retired,
  "1.2.840.10008.3.1.2.1.4":
      WKUid.kDetachedPatientManagementMetaSOPClass_Retired,
  "1.2.840.10008.3.1.2.2.1": WKUid.kDetachedVisitManagementSOPClass_Retired,
  "1.2.840.10008.3.1.2.3.1": WKUid.kDetachedStudyManagementSOPClass_Retired,
  "1.2.840.10008.3.1.2.3.2": WKUid.kStudyComponentManagementSOPClass_Retired,
  "1.�2.840.10008.3.1.2.3.3": WKUid.kModalityPerformedProcedureStepSOPClass,
  "1.�2.840.10008.3.1.2.3.4":
      WKUid.kModalityPerformedProcedureStepRetrieveSOPClass,
  "1.�2.840.10008.3.1.2.3.5":
      WKUid.kModalityPerformedProcedureStepNotificationSOPClass,
  "1.2.840.10008.3.1.2.5.1": WKUid.kDetachedResultsManagementSOPClass_Retired,
  "1.2.840.10008.3.1.2.5.4":
      WKUid.kDetachedResultsManagementMetaSOPClass_Retired,
  "1.2.840.10008.3.1.2.5.5": WKUid.kDetachedStudyManagementMetaSOPClass_Retired,
  "1.2.840.10008.3.1.2.6.1":
      WKUid.kDetachedInterpretationManagementSOPClass_Retired,
  "1.2.840.10008.4.2": WKUid.kStorageServiceClass,
  "1.2.840.10008.5.1.1.1": WKUid.kBasicFilmSessionSOPClass,
  "1.2.840.10008.5.1.1.2": WKUid.kBasicFilmBoxSOPClass,
  "1.2.840.10008.5.1.1.4": WKUid.kBasicGrayscaleImageBoxSOPClass,
  "1.2.840.10008.5.1.1.4.1": WKUid.kBasicColorImageBoxSOPClass,
  "1.2.840.10008.5.1.1.4.2": WKUid.kReferencedImageBoxSOPClass_Retired,
  "1.2.840.10008.5.1.1.9": WKUid.kBasicGrayscalePrintManagementMetaSOPClass,
  "1.2.840.10008.5.1.1.9.1":
      WKUid.kReferencedGrayscalePrintManagementMetaSOPClass_Retired,
  "1.2.840.10008.5.1.1.14": WKUid.kPrintJobSOPClass,
  "1.2.840.10008.5.1.1.15": WKUid.kBasicAnnotationBoxSOPClass,
  "1.2.840.10008.5.1.1.16": WKUid.kPrinterSOPClass,
  "1.2.840.10008.5.1.1.16.376": WKUid.kPrinterConfigurationRetrievalSOPClass,
  "1.2.840.10008.5.1.1.17": WKUid.kPrinterSOPInstance,
  "1.2.840.10008.5.1.1.17.376": WKUid.kPrinterConfigurationRetrievalSOPInstance,
  "1.2.840.10008.5.1.1.18": WKUid.kBasicColorPrintManagementMetaSOPClass,
  "1.2.840.10008.5.1.1.18.1":
      WKUid.kReferencedColorPrintManagementMetaSOPClass_Retired,
  "1.2.840.10008.5.1.1.22": WKUid.kVOILUTBoxSOPClass,
  "1.2.840.10008.5.1.1.23": WKUid.kPresentationLUTSOPClass,
  "1.2.840.10008.5.1.1.24": WKUid.kImageOverlayBoxSOPClass_Retired,
  "1.2.840.10008.5.1.1.24.1": WKUid.kBasicPrintImageOverlayBoxSOPClass_Retired,
  "1.2.840.10008.5.1.1.25": WKUid.kPrintQueueSOPInstance_Retired,
  "1.2.840.10008.5.1.1.26": WKUid.kPrintQueueManagementSOPClass_Retired,
  "1.2.840.10008.5.1.1.27": WKUid.kStoredPrintStorageSOPClass_Retired,
  "1.2.840.10008.5.1.1.29":
      WKUid.kHardcopyGrayscaleImageStorageSOPClass_Retired,
  "1.2.840.10008.5.1.1.30": WKUid.kHardcopyColorImageStorageSOPClass_Retired,
  "1.2.840.10008.5.1.1.31": WKUid.kPullPrintRequestSOPClass_Retired,
  "1.2.840.10008.5.1.1.32":
      WKUid.kPullStoredPrintManagementMetaSOPClass_Retired,
  "1.2.840.10008.5.1.1.33": WKUid.kMediaCreationManagementSOPClassUID,
  "1.2.840.10008.5.1.4.1.1.1": WKUid.kComputedRadiographyImageStorage,
  "1.2.840.10008.5.1.4.1.1.1.1":
      WKUid.kDigitalX_RayImageStorage_ForPresentation,
  "1.2.840.10008.5.1.4.1.1.1.1.1":
      WKUid.kDigitalX_RayImageStorage_ForProcessing,
  "1.2.840.10008.5.1.4.1.1.1.2":
      WKUid.kDigitalMammographyX_RayImageStorage_ForPresentation,
  "1.2.840.10008.5.1.4.1.1.1.2.1":
      WKUid.kDigitalMammographyX_RayImageStorage_ForProcessing,
  "1.2.840.10008.5.1.4.1.1.1.3":
      WKUid.kDigitalIntra_OralX_RayImageStorage_ForPresentation,
  "1.2.840.10008.5.1.4.1.1.1.3.1":
      WKUid.kDigitalIntra_OralX_RayImageStorage_ForProcessing,
  "1.2.840.10008.5.1.4.1.1.2": WKUid.kCTImageStorage,
  "1.2.840.10008.5.1.4.1.1.2.1": WKUid.kEnhancedCTImageStorage,
  "1.2.840.10008.5.1.4.1.1.2.2": WKUid.kLegacyConvertedEnhancedCTImageStorage,
  "1.2.840.10008.5.1.4.1.1.3": WKUid.kUltrasoundMulti_frameImageStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.3.1": WKUid.kUltrasoundMulti_frameImageStorage,
  "1.2.840.10008.5.1.4.1.1.4": WKUid.kMRImageStorage,
  "1.2.840.10008.5.1.4.1.1.4.1": WKUid.kEnhancedMRImageStorage,
  "1.2.840.10008.5.1.4.1.1.4.2": WKUid.kMRSpectroscopyStorage,
  "1.2.840.10008.5.1.4.1.1.4.3": WKUid.kEnhancedMRColorImageStorage,
  "1.2.840.10008.5.1.4.1.1.4.4": WKUid.kLegacyConvertedEnhancedMRImageStorage,
  "1.2.840.10008.5.1.4.1.1.5": WKUid.kNuclearMedicineImageStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.6": WKUid.kUltrasoundImageStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.6.1": WKUid.kUltrasoundImageStorage,
  "1.2.840.10008.5.1.4.1.1.6.2": WKUid.kEnhancedUSVolumeStorage,
  "1.2.840.10008.5.1.4.1.1.7": WKUid.kSecondaryCaptureImageStorage,
  "1.2.840.10008.5.1.4.1.1.7.1":
      WKUid.kMulti_frameSingleBitSecondaryCaptureImageStorage,
  "1.2.840.10008.5.1.4.1.1.7.2":
      WKUid.kMulti_frameGrayscaleByteSecondaryCaptureImageStorage,
  "1.2.840.10008.5.1.4.1.1.7.3":
      WKUid.kMulti_frameGrayscaleWordSecondaryCaptureImageStorage,
  "1.2.840.10008.5.1.4.1.1.7.4":
      WKUid.kMulti_frameTrueColorSecondaryCaptureImageStorage,
  "1.2.840.10008.5.1.4.1.1.8": WKUid.kStandaloneOverlayStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.9": WKUid.kStandaloneCurveStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.9.1": WKUid.kWaveformStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.9.1.1": WKUid.ktwelve_lead_12ECGWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.1.2": WKUid.kGeneralECGWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.1.3": WKUid.kAmbulatoryECGWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.2.1": WKUid.kHemodynamicWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.3.1":
      WKUid.kCardiacElectrophysiologyWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.4.1": WKUid.kBasicVoiceAudioWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.4.2": WKUid.kGeneralAudioWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.5.1": WKUid.kArterialPulseWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.9.6.1": WKUid.kRespiratoryWaveformStorage,
  "1.2.840.10008.5.1.4.1.1.10": WKUid.kStandaloneModalityLUTStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.11": WKUid.kStandaloneVOILUTStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.11.1":
      WKUid.kGrayscaleSoftcopyPresentationStateStorageSOPClass,
  "1.2.840.10008.5.1.4.1.1.11.2":
      WKUid.kColorSoftcopyPresentationStateStorageSOPClass,
  "1.2.840.10008.5.1.4.1.1.11.3":
      WKUid.kPseudo_ColorSoftcopyPresentationStateStorageSOPClass,
  "1.2.840.10008.5.1.4.1.1.11.4":
      WKUid.kBlendingSoftcopyPresentationStateStorageSOPClass,
  "1.2.840.10008.5.1.4.1.1.11.5":
      WKUid.kXA_XRFGrayscaleSoftcopyPresentationStateStorage,
  "1.2.840.10008.5.1.4.1.1.12.1": WKUid.kX_RayAngiographicImageStorage,
  "1.2.840.10008.5.1.4.1.1.12.1.1": WKUid.kEnhancedXAImageStorage,
  "1.2.840.10008.5.1.4.1.1.12.2": WKUid.kX_RayRadiofluoroscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.12.2.1": WKUid.kEnhancedXRFImageStorage,
  "1.2.840.10008.5.1.4.1.1.12.3":
      WKUid.kX_RayAngiographicBi_PlaneImageStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.13.1.1": WKUid.kX_Ray3DAngiographicImageStorage,
  "1.2.840.10008.5.1.4.1.1.13.1.2": WKUid.kX_Ray3DCraniofacialImageStorage,
  "1.2.840.10008.5.1.4.1.1.13.1.3": WKUid.kBreastTomosynthesisImageStorage,
  "1.2.840.10008.5.1.4.1.1.14.1": WKUid
      .kIntravascularOpticalCoherenceTomographyImageStorage_ForPresentation,
  "1.2.840.10008.5.1.4.1.1.14.2":
      WKUid.kIntravascularOpticalCoherenceTomographyImageStorage_ForProcessing,
  "1.2.840.10008.5.1.4.1.1.20": WKUid.kNuclearMedicineImageStorage,
  "1.2.840.10008.5.1.4.1.1.66": WKUid.kRawDataStorage,
  "1.2.840.10008.5.1.4.1.1.66.1": WKUid.kSpatialRegistrationStorage,
  "1.2.840.10008.5.1.4.1.1.66.2": WKUid.kSpatialFiducialsStorage,
  "1.2.840.10008.5.1.4.1.1.66.3": WKUid.kDeformableSpatialRegistrationStorage,
  "1.2.840.10008.5.1.4.1.1.66.4": WKUid.kSegmentationStorage,
  "1.2.840.10008.5.1.4.1.1.66.5": WKUid.kSurfaceSegmentationStorage,
  "1.2.840.10008.5.1.4.1.1.67": WKUid.kRealWorldValueMappingStorage,
  "1.2.840.10008.5.1.4.1.1.68.1": WKUid.kSurfaceScanMeshStorage,
  "1.2.840.10008.5.1.4.1.1.68.2": WKUid.kSurfaceScanPointCloudStorage,
  "1.2.840.10008.5.1.4.1.1.77.1": WKUid.kVLImageStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.77.2":
      WKUid.kVLMulti_frameImageStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.77.1.1": WKUid.kVLEndoscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.1.1": WKUid.kVideoEndoscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.2": WKUid.kVLMicroscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.2.1": WKUid.kVideoMicroscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.3":
      WKUid.kVLSlide_CoordinatesMicroscopicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.4": WKUid.kVLPhotographicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.4.1": WKUid.kVideoPhotographicImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.5.1":
      WKUid.kOphthalmicPhotography8BitImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.5.2":
      WKUid.kOphthalmicPhotography16BitImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.5.3": WKUid.kStereometricRelationshipStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.5.4": WKUid.kOphthalmicTomographyImageStorage,
  "1.2.840.10008.5.1.4.1.1.77.1.6": WKUid.kVLWholeSlideMicroscopyImageStorage,
  "1.2.840.10008.5.1.4.1.1.78.1": WKUid.kLensometryMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.2": WKUid.kAutorefractionMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.3": WKUid.kKeratometryMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.4":
      WKUid.kSubjectiveRefractionMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.5": WKUid.kVisualAcuityMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.6": WKUid.kSpectaclePrescriptionReportStorage,
  "1.2.840.10008.5.1.4.1.1.78.7": WKUid.kOphthalmicAxialMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.78.8": WKUid.kIntraocularLensCalculationsStorage,
  "1.2.840.10008.5.1.4.1.1.79.1":
      WKUid.kMacularGridThicknessandVolumeReportStorage,
  "1.2.840.10008.5.1.4.1.1.80.1":
      WKUid.kOphthalmicVisualFieldStaticPerimetryMeasurementsStorage,
  "1.2.840.10008.5.1.4.1.1.81.1": WKUid.kOphthalmicThicknessMapStorage,
  "11.2.840.10008.5.1.4.1.1.82.1": WKUid.kCornealTopographyMapStorage,
  "1.2.840.10008.5.1.4.1.1.88.1": WKUid.kTextSRStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.88.2": WKUid.kAudioSRStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.88.3": WKUid.kDetailSRStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.88.4": WKUid.kComprehensiveSRStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.1.1.88.11": WKUid.kBasicTextSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.22": WKUid.kEnhancedSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.33": WKUid.kComprehensiveSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.34": WKUid.kComprehensive3DSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.40": WKUid.kProcedureLogStorage,
  "1.2.840.10008.5.1.4.1.1.88.50": WKUid.kMammographyCADSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.59": WKUid.kKeyObjectSelectionDocumentStorage,
  "1.2.840.10008.5.1.4.1.1.88.65": WKUid.kChestCADSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.67": WKUid.kX_RayRadiationDoseSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.69": WKUid.kColonCADSRStorage,
  "1.2.840.10008.5.1.4.1.1.88.70": WKUid.kImplantationPlanSRStorage,
  "1.2.840.10008.5.1.4.1.1.104.1": WKUid.kEncapsulatedPDFStorage,
  "1.2.840.10008.5.1.4.1.1.104.2": WKUid.kEncapsulatedCDAStorage,
  "1.2.840.10008.5.1.4.1.1.128": WKUid.kPositronEmissionTomographyImageStorage,
  "1.2.840.10008.5.1.4.1.1.128.1":
      WKUid.kLegacyConvertedEnhancedPETImageStorage,
  "1.2.840.10008.5.1.4.1.1.129": WKUid.kStandalonePETCurveStorage_Retired,
  "1.2.840.10008.5.1.4.1.1.130": WKUid.kEnhancedPETImageStorage,
  "1.2.840.10008.5.1.4.1.1.131": WKUid.kBasicStructuredDisplayStorage,
  "1.2.840.10008.5.1.4.1.1.481.1": WKUid.kRTImageStorage,
  "1.2.840.10008.5.1.4.1.1.481.2": WKUid.kRTDoseStorage,
  "1.2.840.10008.5.1.4.1.1.481.3": WKUid.kRTStructureSetStorage,
  "1.2.840.10008.5.1.4.1.1.481.4": WKUid.kRTBeamsTreatmentRecordStorage,
  "1.2.840.10008.5.1.4.1.1.481.5": WKUid.kRTPlanStorage,
  "1.2.840.10008.5.1.4.1.1.481.6": WKUid.kRTBrachyTreatmentRecordStorage,
  "1.2.840.10008.5.1.4.1.1.481.7": WKUid.kRTTreatmentSummaryRecordStorage,
  "1.2.840.10008.5.1.4.1.1.481.8": WKUid.kRTIonPlanStorage,
  "1.2.840.10008.5.1.4.1.1.481.9": WKUid.kRTIonBeamsTreatmentRecordStorage,
  "1.2.840.10008.5.1.4.1.1.501.1": WKUid.kDICOSCTImageStorage,
  "1.2.840.10008.5.1.4.1.1.501.2.1":
      WKUid.kDICOSDigitalX_RayImageStorage_ForPresentation,
  "1.2.840.10008.5.1.4.1.1.501.2.2":
      WKUid.kDICOSDigitalX_RayImageStorage_ForProcessing,
  "1.2.840.10008.5.1.4.1.1.501.3": WKUid.kDICOSThreatDetectionReportStorage,
  "1.2.840.10008.5.1.4.1.1.501.4": WKUid.kDICOS2DAITStorage,
  "1.2.840.10008.5.1.4.1.1.501.5": WKUid.kDICOS3DAITStorage,
  "1.2.840.10008.5.1.4.1.1.501.6": WKUid.kDICOSQuadrupoleResonanceStorage,
  "1.2.840.10008.5.1.4.1.1.601.1": WKUid.kEddyCurrentImageStorage,
  "1.2.840.10008.5.1.4.1.1.601.2": WKUid.kEddyCurrentMulti_frameImageStorage,
  "1.2.840.10008.5.1.4.1.2.1.1":
      WKUid.kPatientRootQueryRetrieveInformationModel_FIND,
  "1.2.840.10008.5.1.4.1.2.1.2":
      WKUid.kPatientRootQueryRetrieveInformationModel_MOVE,
  "1.2.840.10008.5.1.4.1.2.1.3":
      WKUid.kPatientRootQueryRetrieveInformationModel_GET,
  "1.2.840.10008.5.1.4.1.2.2.1":
      WKUid.kStudyRootQueryRetrieveInformationModel_FIND,
  "1.2.840.10008.5.1.4.1.2.2.2":
      WKUid.kStudyRootQueryRetrieveInformationModel_MOVE,
  "1.2.840.10008.5.1.4.1.2.2.3":
      WKUid.kStudyRootQueryRetrieveInformationModel_GET,
  "1.2.840.10008.5.1.4.1.2.3.1":
      WKUid.kPatient_StudyOnlyQueryRetrieveInformationModel_FIND_Retired,
  "1.2.840.10008.5.1.4.1.2.3.2":
      WKUid.kPatient_StudyOnlyQueryRetrieveInformationModel_MOVE_Retired,
  "1.2.840.10008.5.1.4.1.2.3.3":
      WKUid.kPatient_StudyOnlyQueryRetrieveInformationModel_GET_Retired,
  "1.2.840.10008.5.1.4.1.2.4.2": WKUid.kCompositeInstanceRootRetrieve_MOVE,
  "1.2.840.10008.5.1.4.1.2.4.3": WKUid.kCompositeInstanceRootRetrieve_GET,
  "1.2.840.10008.5.1.4.1.2.5.3":
      WKUid.kCompositeInstanceRetrieveWithoutBulkData_GET,
  "1.2.840.10008.5.1.4.31": WKUid.kModalityWorklistInformationModel_FIND,
  "1.2.840.10008.5.1.4.32.1":
      WKUid.kGeneralPurposeWorklistInformationModel_FIND_Retired,
  "1.2.840.10008.5.1.4.32.2":
      WKUid.kGeneralPurposeScheduledProcedureStepSOPClass_Retired,
  "1.2.840.10008.5.1.4.32.3":
      WKUid.kGeneralPurposePerformedProcedureStepSOPClass_Retired,
  "1.2.840.10008.5.1.4.32":
      WKUid.kGeneralPurposeWorklistManagementMetaSOPClass_Retired,
  "1.2.840.10008.5.1.4.33": WKUid.kInstanceAvailabilityNotificationSOPClass,
  "1.2.840.10008.5.1.4.34.1":
      WKUid.kRTBeamsDeliveryInstructionStorage_Trial_Retired,
  "1.2.840.10008.5.1.4.34.2":
      WKUid.kRTConventionalMachineVerification_Trial_Retired,
  "1.2.840.10008.5.1.4.34.3": WKUid.kRTIonMachineVerification_Trial_Retired,
  "1.2.840.10008.5.1.4.34.4":
      WKUid.kUnifiedWorklistandProcedureStepServiceClass_Trial_Retired,
  "1.2.840.10008.5.1.4.34.4.1":
      WKUid.kUnifiedProcedureStep_PushSOPClass_Trial_Retired,
  "1.2.840.10008.5.1.4.34.4.2":
      WKUid.kUnifiedProcedureStep_WatchSOPClass_Trial_Retired,
  "1.2.840.10008.5.1.4.34.4.3":
      WKUid.kUnifiedProcedureStep_PullSOPClass_Trial_Retired,
  "1.2.840.10008.5.1.4.34.4.4":
      WKUid.kUnifiedProcedureStep_EventSOPClass_Trial_Retired,
  "1.2.840.10008.5.1.4.34.5": WKUid.kUnifiedWorklistandProcedureStepSOPInstance,
  "1.2.840.10008.5.1.4.34.6":
      WKUid.kUnifiedWorklistandProcedureStepServiceClass,
  "1.2.840.10008.5.1.4.34.6.1": WKUid.kUnifiedProcedureStep_PushSOPClass,
  "1.2.840.10008.5.1.4.34.6.2": WKUid.kUnifiedProcedureStep_WatchSOPClass,
  "1.2.840.10008.5.1.4.34.6.3": WKUid.kUnifiedProcedureStep_PullSOPClass,
  "1.2.840.10008.5.1.4.34.6.4": WKUid.kUnifiedProcedureStep_EventSOPClass,
  "1.2.840.10008.5.1.4.34.7": WKUid.kRTBeamsDeliveryInstructionStorage,
  "1.2.840.10008.5.1.4.34.8": WKUid.kRTConventionalMachineVerification,
  "1.2.840.10008.5.1.4.34.9": WKUid.kRTIonMachineVerification,
  "1.2.840.10008.5.1.4.37.1": WKUid.kGeneralRelevantPatientInformationQuery,
  "1.2.840.10008.5.1.4.37.2":
      WKUid.kBreastImagingRelevantPatientInformationQuery,
  "1.2.840.10008.5.1.4.37.3": WKUid.kCardiacRelevantPatientInformationQuery,
  "1.2.840.10008.5.1.4.38.1": WKUid.kHangingProtocolStorage,
  "1.2.840.10008.5.1.4.38.2": WKUid.kHangingProtocolInformationModel_FIND,
  "1.2.840.10008.5.1.4.38.3": WKUid.kHangingProtocolInformationModel_MOVE,
  "1.2.840.10008.5.1.4.38.4": WKUid.kHangingProtocolInformationModel_GET,
  "1.2.840.10008.5.1.4.39.1": WKUid.kColorPaletteStorage,
  "1.2.840.10008.5.1.4.39.2": WKUid.kColorPaletteInformationModel_FIND,
  "1.2.840.10008.5.1.4.39.3": WKUid.kColorPaletteInformationModel_MOVE,
  "1.2.840.10008.5.1.4.39.4": WKUid.kColorPaletteInformationModel_GET,
  "1.2.840.10008.5.1.4.41": WKUid.kProductCharacteristicsQuerySOPClass,
  "1.2.840.10008.5.1.4.42": WKUid.kSubstanceApprovalQuerySOPClass,
  "1.2.840.10008.5.1.4.43.1": WKUid.kGenericImplantTemplateStorage,
  "1.2.840.10008.5.1.4.43.2":
      WKUid.kGenericImplantTemplateInformationModel_FIND,
  "1.2.840.10008.5.1.4.43.3":
      WKUid.kGenericImplantTemplateInformationModel_MOVE,
  "1.2.840.10008.5.1.4.43.4": WKUid.kGenericImplantTemplateInformationModel_GET,
  "1.2.840.10008.5.1.4.44.1": WKUid.kImplantAssemblyTemplateStorage,
  "1.2.840.10008.5.1.4.44.2":
      WKUid.kImplantAssemblyTemplateInformationModel_FIND,
  "1.2.840.10008.5.1.4.44.3":
      WKUid.kImplantAssemblyTemplateInformationModel_MOVE,
  "1.2.840.10008.5.1.4.44.4":
      WKUid.kImplantAssemblyTemplateInformationModel_GET,
  "1.2.840.10008.5.1.4.45.1": WKUid.kImplantTemplateGroupStorage,
  "1.2.840.10008.5.1.4.45.2": WKUid.kImplantTemplateGroupInformationModel_FIND,
  "1.2.840.10008.5.1.4.45.3": WKUid.kImplantTemplateGroupInformationModel_MOVE,
  "1.2.840.10008.5.1.4.45.4": WKUid.kImplantTemplateGroupInformationModel_GET,
  "1.2.840.10008.7.1.1": WKUid.kNativeDICOMModel,
  "1.2.840.10008.7.1.2": WKUid.kAbstractMulti_DimensionalImageModel,
  "1.2.840.10008.15.0.3.1": WKUid.kdicomDeviceName,
  "1.2.840.10008.15.0.3.2": WKUid.kdicomDescription,
  "1.2.840.10008.15.0.3.3": WKUid.kdicomManufacturer,
  "1.2.840.10008.15.0.3.4": WKUid.kdicomManufacturerModelName,
  "1.2.840.10008.15.0.3.5": WKUid.kdicomSoftwareVersion,
  "1.2.840.10008.15.0.3.6": WKUid.kdicomVendorData,
  "1.2.840.10008.15.0.3.7": WKUid.kdicomAETitle,
  "1.2.840.10008.15.0.3.8": WKUid.kdicomNetworkConnectionReference,
  "1.2.840.10008.15.0.3.9": WKUid.kdicomApplicationCluster,
  "1.2.840.10008.15.0.3.10": WKUid.kdicomAssociationInitiator,
  "1.2.840.10008.15.0.3.11": WKUid.kdicomAssociationAcceptor,
  "1.2.840.10008.15.0.3.12": WKUid.kdicomHostname,
  "1.2.840.10008.15.0.3.13": WKUid.kdicomPort,
  "1.2.840.10008.15.0.3.14": WKUid.kdicomSOPClass,
  "1.2.840.10008.15.0.3.15": WKUid.kdicomTransferRole,
  "1.2.840.10008.15.0.3.16": WKUid.kdicomTransferSyntax,
  "1.2.840.10008.15.0.3.17": WKUid.kdicomPrimaryDeviceType,
  "1.2.840.10008.15.0.3.18": WKUid.kdicomRelatedDeviceReference,
  "1.2.840.10008.15.0.3.19": WKUid.kdicomPreferredCalledAETitle,
  "1.2.840.10008.15.0.3.20": WKUid.kdicomTLSCyphersuite,
  "1.2.840.10008.15.0.3.21": WKUid.kdicomAuthorizedNodeCertificateReference,
  "1.2.840.10008.15.0.3.22": WKUid.kdicomThisNodeCertificateReference,
  "1.2.840.10008.15.0.3.23": WKUid.kdicomInstalled,
  "1.2.840.10008.15.0.3.24": WKUid.kdicomStationName,
  "1.2.840.10008.15.0.3.25": WKUid.kdicomDeviceSerialNumber,
  "1.2.840.10008.15.0.3.26": WKUid.kdicomInstitutionName,
  "1.2.840.10008.15.0.3.27": WKUid.kdicomInstitutionAddress,
  "1.2.840.10008.15.0.3.28": WKUid.kdicomInstitutionDepartmentName,
  "1.2.840.10008.15.0.3.29": WKUid.kdicomIssuerOfPatientID,
  "1.2.840.10008.15.0.3.30": WKUid.kdicomPreferredCallingAETitle,
  "1.2.840.10008.15.0.3.31": WKUid.kdicomSupportedCharacterSet,
  "1.2.840.10008.15.0.4.1": WKUid.kdicomConfigurationRoot,
  "1.2.840.10008.15.0.4.2": WKUid.kdicomDevicesRoot,
  "1.2.840.10008.15.0.4.3": WKUid.kdicomUniqueAETitlesRegistryRoot,
  "1.2.840.10008.15.0.4.4": WKUid.kdicomDevice,
  "1.2.840.10008.15.0.4.5": WKUid.kdicomNetworkAE,
  "1.2.840.10008.15.0.4.6": WKUid.kdicomNetworkConnection,
  "1.2.840.10008.15.0.4.7": WKUid.kdicomUniqueAETitle,
  "1.2.840.10008.15.0.4.8": WKUid.kdicomTransferCapability,
  "1.2.840.10008.15.1.1": WKUid.kUniversalCoordinatedTime,
};
