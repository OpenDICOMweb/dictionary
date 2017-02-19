// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The possible class of a [ModalityType].
class MClass {
  final int value;

  //TODO need a better name
  const MClass(this.value);

  //TODO make lowercase
  static const MClass kACQUISITION = const MClass(0);
  static const MClass kDERIVED = const MClass(1);
  static const MClass kMEASUREMENT = const MClass(2);
  static const MClass kPLANNING = const MClass(3);
  // ignore: constant_identifier_names
  static const MClass kPOST_PROCESSING = const MClass(4);
  static const MClass kDOCUMENT = const MClass(5);
  static const MClass kOTHER = const MClass(6);
  //TODO Figure out what other classes there should be.

  @override
  String toString() => 'MClass(Modality).$value';
}

//TODO document what part of the standard this comes from.
//TODO: rename constants as kName
class ModalityType {
  //TODO should this be Symbol or String
  final String keyword;
  final String name;
  final MClass mClass;
  final bool isRetired;
  final ModalityType mapsTo;

  const ModalityType(
      this.keyword, this.name, this.mClass, this.isRetired, this.mapsTo);

  bool get isAcquisition => (mClass == MClass.kACQUISITION);
  bool get isDerived => (mClass == MClass.kDERIVED);
  bool get isDocument => (mClass == MClass.kDOCUMENT);
  bool get isMeasurement => (mClass == MClass.kMEASUREMENT);
  bool get isOther => (mClass == MClass.kOTHER);
  bool get isPlanning => (mClass == MClass.kPLANNING);
  bool get isPostProcessing => (mClass == MClass.kPOST_PROCESSING);

  /// [replacedBy] returns the new modality that replaced this modality
  ModalityType get replacedBy =>
      (this.replacedBy == null) ? this.keyword : this.mapsTo;

  @override
  String toString() => 'Modality.$keyword';

  static const ModalityType kAR = const ModalityType(
      "AR", "Autorefraction", MClass.kACQUISITION, false, null);
  static const ModalityType kAU =
      const ModalityType("AU", "Audio", MClass.kACQUISITION, false, null);
  static const ModalityType kBDUS = const ModalityType("BDUS",
      "Bone Densitometry (ultrasound)", MClass.kACQUISITION, false, null);
  static const ModalityType kBI = const ModalityType(
      "BI", "Biomagnetic imaging", MClass.kACQUISITION, false, null);
  static const ModalityType kBMD = const ModalityType(
      "BMD", "Bone Densitometry (X-Ray)", MClass.kACQUISITION, false, null);
  static const ModalityType kCR = const ModalityType(
      "CR", "Computed Radiography", MClass.kACQUISITION, false, null);
  // Note: this is a special (Non-DICOM) Modality
  // added for Clinical Trial Processors
  static const ModalityType kCTP = const ModalityType(
      "CTP", "Clinical Trial Processor", MClass.kDERIVED, false, null);
  static const ModalityType kCT = const ModalityType(
      "CT", "Computed Tomography", MClass.kACQUISITION, false, null);
  static const ModalityType kDG = const ModalityType(
      "DG", "Diaphanography", MClass.kACQUISITION, false, null);
  static const ModalityType kDOC =
      const ModalityType("DOC", "Document", MClass.kDOCUMENT, false, null);
  static const ModalityType kDX = const ModalityType(
      "DX", "Digital Radiography", MClass.kACQUISITION, false, null);
  static const ModalityType kECG = const ModalityType(
      "ECG", "Electrocardiography", MClass.kACQUISITION, false, null);
  static const ModalityType kEPS = const ModalityType(
      "EPS", "Cardiac Electrophysiology", MClass.kACQUISITION, false, null);
  static const ModalityType kES =
      const ModalityType("ES", "Endoscopy", MClass.kACQUISITION, false, null);
  static const ModalityType kFID =
      const ModalityType("FID", "Fiducials", MClass.kACQUISITION, false, null);
  static const ModalityType kGM = const ModalityType(
      "GM", "General Microscopy", MClass.kACQUISITION, false, null);
  static const ModalityType kHC =
      const ModalityType("HC", "Hard Copy", MClass.kOTHER, false, null);
  static const ModalityType kHD = const ModalityType(
      "HD", "Hemodynamic Waveform", MClass.kACQUISITION, false, null);
  static const ModalityType kIO = const ModalityType(
      "IO", "Intra-Oral Radiography", MClass.kACQUISITION, false, null);
  static const ModalityType kIOL = const ModalityType(
      "IOL", "Intraocular Lens Data", MClass.kACQUISITION, false, null);
  static const ModalityType kIVOCT = const ModalityType(
      "IVOCT",
      "Intravascular Optical Coherence Tomography",
      MClass.kACQUISITION,
      false,
      null);
  static const ModalityType kIVUS = const ModalityType(
      "IVUS", "Intravascular Ultrasound", MClass.kACQUISITION, false, null);
  static const ModalityType kKER = const ModalityType(
      "KER", "Keratometry", MClass.kACQUISITION, false, null);
  static const ModalityType kKO = const ModalityType(
      "KO", "Key Object Selection", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kLEN =
      const ModalityType("LEN", "Lensometry", MClass.kACQUISITION, false, null);
  static const ModalityType kLS = const ModalityType(
      "LS", "Laser surface scan", MClass.kACQUISITION, false, null);
  static const ModalityType kMG =
      const ModalityType("MG", "Mammography", MClass.kACQUISITION, false, null);
  static const ModalityType kMR = const ModalityType(
      "MR", "Magnetic Resonance", MClass.kACQUISITION, false, null);
  static const ModalityType kNM = const ModalityType(
      "NM", "Nuclear Medicine", MClass.kACQUISITION, false, null);
  static const ModalityType kOAM = const ModalityType("OAM",
      "Ophthalmic Axial Measurements", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kOCT = const ModalityType(
      "OCT",
      "Optical Coherence Tomography (non-Ophthalmic)",
      MClass.kACQUISITION,
      false,
      null);
  static const ModalityType kOPM = const ModalityType(
      "OPM", "Ophthalmic Mapping", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kOP = const ModalityType(
      "OP", "Ophthalmic Photography", MClass.kACQUISITION, false, null);
  static const ModalityType kOPT = const ModalityType(
      "OPT", "Ophthalmic Tomography", MClass.kACQUISITION, false, null);
  static const ModalityType kOPV = const ModalityType(
      "OPV", "Ophthalmic Visual Field", MClass.kACQUISITION, false, null);
  static const ModalityType kOSS = const ModalityType(
      "OSS", "Optical Surface Scan", MClass.kACQUISITION, false, null);
  static const ModalityType kOT =
      const ModalityType("OT", "Other", MClass.kACQUISITION, false, null);
  static const ModalityType kPLAN =
      const ModalityType("PLAN", "Plan", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kPR = const ModalityType(
      "PR", "Presentation State", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kPT = const ModalityType("PT",
      "Positron emission tomography (PET)", MClass.kACQUISITION, false, null);
  //TODO: determine the correct code for PET/CT
  static const ModalityType kPTCT = const ModalityType(
      "PTCT",
      "Computed Tomography & Positron emission tomography (PET)",
      MClass.kACQUISITION,
      false,
      null);
  static const ModalityType kPX = const ModalityType(
      "PX", "Panoramic X-Ray", MClass.kACQUISITION, false, null);
  static const ModalityType kREG = const ModalityType(
      "REG", "Registration", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kRESP = const ModalityType(
      "RESP", "Respiratory Waveform", MClass.kACQUISITION, false, null);
  static const ModalityType kRF = const ModalityType(
      "RF", "Radio Fluoroscopy", MClass.kACQUISITION, false, null);
  static const ModalityType kRG = const ModalityType(
      "RG",
      "Radiographic imaging (conventional film/screen)",
      MClass.kACQUISITION,
      false,
      null);
  static const ModalityType kRTDOSE = const ModalityType(
      "RTDOSE", "Radiotherapy Dose", MClass.kACQUISITION, false, null);
  static const ModalityType kRTIMAGE = const ModalityType(
      "RTIMAGE", "Radiotherapy Image", MClass.kACQUISITION, false, null);
  static const ModalityType kRTPLAN = const ModalityType(
      "RTPLAN", "Radiotherapy Plan", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kRTRECORD = const ModalityType(
      "RTRECORD", "RT Treatment Record", MClass.kDOCUMENT, false, null);
  static const ModalityType kRTSTRUCT = const ModalityType(
      "RTSTRUCT", "Radiotherapy Structure Set", MClass.kPLANNING, false, null);
  static const ModalityType kSEG = const ModalityType(
      "SEG", "Segmentation", MClass.kPOST_PROCESSING, false, null);
  static const ModalityType kSMR = const ModalityType(
      "SMR", "Stereometric Relationship", MClass.kOTHER, false, null);
  static const ModalityType kSM = const ModalityType(
      "SM", "Slide Microscopy", MClass.kACQUISITION, false, null);
  static const ModalityType kSRF = const ModalityType(
      "SRF", "Subjective Refraction", MClass.kACQUISITION, false, null);
  static const ModalityType kSR =
      const ModalityType("SR", "SR Document", MClass.kDOCUMENT, false, null);
  static const ModalityType kSTAIN = const ModalityType(
      "STAIN", "Automated Slide Stainer", MClass.kACQUISITION, false, null);
  static const ModalityType kTG = const ModalityType(
      "TG", "Thermography", MClass.kACQUISITION, false, null);
  static const ModalityType kUS =
      const ModalityType("US", "Ultrasound", MClass.kACQUISITION, false, null);
  static const ModalityType kVA = const ModalityType(
      "VA", "Visual Acuity", MClass.kACQUISITION, false, null);
  static const ModalityType kXA = const ModalityType(
      "XA", "X-Ray Angiography", MClass.kACQUISITION, false, null);
  static const ModalityType kXC = const ModalityType(
      "XC", "External-camera Photography", MClass.kACQUISITION, false, null);
  static const ModalityType kAS =
      const ModalityType("AS", "Angioscopy", MClass.kACQUISITION, true, null);

  // Retired Modalities below here
  static const ModalityType kCD = const ModalityType(
      "CD", "Color flow Doppler", MClass.kACQUISITION, true, kUS);
  static const ModalityType kCF = const ModalityType(
      "CF", "Cinefluorography", MClass.kACQUISITION, true, kRF);
  static const ModalityType kCP =
      const ModalityType("CP", "Culposcopy", MClass.kACQUISITION, true, null);
  static const ModalityType kCS =
      const ModalityType("CS", "Cystoscopy", MClass.kACQUISITION, true, null);
  static const ModalityType kDD = const ModalityType(
      "DD", "Duplex Doppler", MClass.kACQUISITION, true, kUS);
  static const ModalityType kDF = const ModalityType(
      "DF", "Digital fluoroscopy", MClass.kACQUISITION, true, kRF);
  static const ModalityType kDM = const ModalityType(
      "DM", "Digital microscopy", MClass.kACQUISITION, true, null);
  static const ModalityType kDS = const ModalityType(
      "DS", "Digital Subtraction Angiography", MClass.kACQUISITION, true, kXA);
  static const ModalityType kEC = const ModalityType(
      "EC", "Echocardiography", MClass.kACQUISITION, true, kUS);
  static const ModalityType kFA = const ModalityType(
      "FA", "Fluorescein angiography", MClass.kACQUISITION, true, null);
  static const ModalityType kFS =
      const ModalityType("FS", "Fundoscopy", MClass.kACQUISITION, true, null);
  static const ModalityType kLP =
      const ModalityType("LP", "Laparoscopy", MClass.kACQUISITION, true, null);
  static const ModalityType kMA = const ModalityType(
      "MA", "Magnetic resonance angiography", MClass.kACQUISITION, true, kMR);
  static const ModalityType kMS = const ModalityType(
      "MS", "Magnetic resonance spectroscopy", MClass.kACQUISITION, true, kMR);
  static const ModalityType kOPR = const ModalityType(
      "OPR", "Ophthalmic Refraction", MClass.kACQUISITION, true, null);
  static const ModalityType kST = const ModalityType(
      "ST",
      "Single-photon emission computed tomography (SPECT)",
      MClass.kACQUISITION,
      true,
      kNM);
  static const ModalityType kVF = const ModalityType(
      "VF", "Videofluorography", MClass.kACQUISITION, true, kRF);

  static const ModalityType kUnknown = const ModalityType(
      "Unknown", "Unknown Modality", MClass.kOTHER, false, null);

  // A lookup table for modality codes.
  //TODO find out why keys can't be Symbols
  static const Map<String, ModalityType> stringToModality = const {
    "AR": kAR,
    "AU": kAU,
    "BDUS": kBDUS,
    "BI": kBI,
    "BMD": kBMD,
    "CR": kCR,
    "CT": kCT,
    "CTP": kCTP,
    "DG": kDG,
    "DOC": kDOC,
    "DX": kDX,
    "ECG": kECG,
    "EPS": kEPS,
    "ES": kES,
    "FID": kFID,
    "GM": kGM,
    "HC": kHC,
    "HD": kHD,
    "IO": kIO,
    "IOL": kIOL,
    "IVOCT": kIVOCT,
    "IVUS": kIVUS,
    "KER": kKER,
    "KO": kKO,
    "LEN": kLEN,
    "LS": kLS,
    "MG": kMG,
    "MR": kMR,
    "NM": kNM,
    "OAM": kOAM,
    "OCT": kOCT,
    "OPM": kOPM,
    "OP": kOP,
    "OPT": kOPT,
    "OPV": kOPV,
    "OSS": kOSS,
    "OT": kOT,
    "PLAN": kPLAN,
    "PR": kPR,
    "PT": kPT,
    "PTCT": kPTCT,
    "PX": kPX,
    "REG": kREG,
    "RESP": kRESP,
    "RF": kRF,
    "RG": kRG,
    "RTDOSE": kRTDOSE,
    "RTIMAGE": kRTIMAGE,
    "RTPLAN": kRTPLAN,
    "RTRECORD": kRTRECORD,
    "RTSTRUCT": kRTSTRUCT,
    "SEG": kSEG,
    "SMR": kSMR,
    "SM": kSM,
    "SRF": kSRF,
    "SR": kSR,
    "STAIN": kSTAIN,
    "TG": kTG,
    "US": kUS,
    "VA": kVA,
    "XA": kXA,
    "XC": kXC,
    "AS": kAS,
    "CD": kCD,
    "CF": kCF,
    "CP": kCP,
    "CS": kCS,
    "DD": kDD,
    "DF": kDF,
    "DM": kDM,
    "DS": kDS,
    "EC": kEC,
    "FA": kFA,
    "FS": kFS,
    "LP": kLP,
    "MA": kMA,
    "MS": kMS,
    "OPR": kOPR,
    "ST": kST,
    "VF": kVF,
    "Unknown": kUnknown
  };

  /// [lookupOldName] returns the [ModalityType] associated with [name] even if it has been
  /// replaced by a new one.
  static ModalityType lookupOldName(String name) => stringToModality[name];

  /// Returns the current name for this modality.
  static ModalityType lookup(String name) {
    ModalityType m = stringToModality[name];
    if (m == null) return null;
    return (m.mapsTo == null) ? m : m.mapsTo;
  }
}
