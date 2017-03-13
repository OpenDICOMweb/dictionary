// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The possible class of a [Modality].
class ModalityType {
  final int value;

  //TODO need a better name
  const ModalityType(this.value);

  //TODO make lowercase
  static const ModalityType kACQUISITION = const ModalityType(0);
  static const ModalityType kDERIVED = const ModalityType(1);
  static const ModalityType kMEASUREMENT = const ModalityType(2);
  static const ModalityType kPLANNING = const ModalityType(3);
  // ignore: constant_identifier_names
  static const ModalityType kPOST_PROCESSING = const ModalityType(4);
  static const ModalityType kDOCUMENT = const ModalityType(5);
  static const ModalityType kOTHER = const ModalityType(6);
  //TODO Figure out what other classes there should be.

  @override
  String toString() => 'MClass(Modality).$value';
}

//TODO document what part of the standard this comes from.
//TODO: rename constants as kName
class Modality {
  //TODO should this be Symbol or String
  final String keyword;
  final String name;
  final ModalityType type;
  final bool isRetired;
  final Modality mapsTo;

  const Modality(
      this.keyword, this.name, this.type, this.isRetired, this.mapsTo);

  bool get isAcquisition => (type == ModalityType.kACQUISITION);
  bool get isDerived => (type == ModalityType.kDERIVED);
  bool get isDocument => (type == ModalityType.kDOCUMENT);
  bool get isMeasurement => (type == ModalityType.kMEASUREMENT);
  bool get isOther => (type == ModalityType.kOTHER);
  bool get isPlanning => (type == ModalityType.kPLANNING);
  bool get isPostProcessing => (type == ModalityType.kPOST_PROCESSING);

  /// [replacedBy] returns the new modality that replaced this modality
  Modality get replacedBy =>
      (this.replacedBy == null) ? this.keyword : this.mapsTo;

  @override
  String toString() => 'Modality.$keyword';

  static const Modality kAR = const Modality(
      "AR", "Autorefraction", ModalityType.kACQUISITION, false, null);
  static const Modality kAU =
      const Modality("AU", "Audio", ModalityType.kACQUISITION, false, null);
  static const Modality kBDUS = const Modality("BDUS",
      "Bone Densitometry (ultrasound)", ModalityType.kACQUISITION, false, null);
  static const Modality kBI = const Modality(
      "BI", "Biomagnetic imaging", ModalityType.kACQUISITION, false, null);
  static const Modality kBMD = const Modality("BMD",
      "Bone Densitometry (X-Ray)", ModalityType.kACQUISITION, false, null);
  static const Modality kCR = const Modality(
      "CR", "Computed Radiography", ModalityType.kACQUISITION, false, null);
  // Note: this is a special (Non-DICOM) Modality
  // added for Clinical Trial Processors
  static const Modality kCTP = const Modality(
      "CTP", "Clinical Trial Processor", ModalityType.kDERIVED, false, null);
  static const Modality kCT = const Modality(
      "CT", "Computed Tomography", ModalityType.kACQUISITION, false, null);
  static const Modality kDG = const Modality(
      "DG", "Diaphanography", ModalityType.kACQUISITION, false, null);
  static const Modality kDOC =
      const Modality("DOC", "Document", ModalityType.kDOCUMENT, false, null);
  static const Modality kDX = const Modality(
      "DX", "Digital Radiography", ModalityType.kACQUISITION, false, null);
  static const Modality kECG = const Modality(
      "ECG", "Electrocardiography", ModalityType.kACQUISITION, false, null);
  static const Modality kEPS = const Modality("EPS",
      "Cardiac Electrophysiology", ModalityType.kACQUISITION, false, null);
  static const Modality kES =
      const Modality("ES", "Endoscopy", ModalityType.kACQUISITION, false, null);
  static const Modality kFID = const Modality(
      "FID", "Fiducials", ModalityType.kACQUISITION, false, null);
  static const Modality kGM = const Modality(
      "GM", "General Microscopy", ModalityType.kACQUISITION, false, null);
  static const Modality kHC =
      const Modality("HC", "Hard Copy", ModalityType.kOTHER, false, null);
  static const Modality kHD = const Modality(
      "HD", "Hemodynamic Waveform", ModalityType.kACQUISITION, false, null);
  static const Modality kIO = const Modality(
      "IO", "Intra-Oral Radiography", ModalityType.kACQUISITION, false, null);
  static const Modality kIOL = const Modality(
      "IOL", "Intraocular Lens Data", ModalityType.kACQUISITION, false, null);
  static const Modality kIVOCT = const Modality(
      "IVOCT",
      "Intravascular Optical Coherence Tomography",
      ModalityType.kACQUISITION,
      false,
      null);
  static const Modality kIVUS = const Modality("IVUS",
      "Intravascular Ultrasound", ModalityType.kACQUISITION, false, null);
  static const Modality kKER = const Modality(
      "KER", "Keratometry", ModalityType.kACQUISITION, false, null);
  static const Modality kKO = const Modality(
      "KO", "Key Object Selection", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kLEN = const Modality(
      "LEN", "Lensometry", ModalityType.kACQUISITION, false, null);
  static const Modality kLS = const Modality(
      "LS", "Laser surface scan", ModalityType.kACQUISITION, false, null);
  static const Modality kMG = const Modality(
      "MG", "Mammography", ModalityType.kACQUISITION, false, null);
  static const Modality kMR = const Modality(
      "MR", "Magnetic Resonance", ModalityType.kACQUISITION, false, null);
  static const Modality kNM = const Modality(
      "NM", "Nuclear Medicine", ModalityType.kACQUISITION, false, null);
  static const Modality kOAM = const Modality(
      "OAM",
      "Ophthalmic Axial Measurements",
      ModalityType.kPOST_PROCESSING,
      false,
      null);
  static const Modality kOCT = const Modality(
      "OCT",
      "Optical Coherence Tomography (non-Ophthalmic)",
      ModalityType.kACQUISITION,
      false,
      null);
  static const Modality kOPM = const Modality(
      "OPM", "Ophthalmic Mapping", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kOP = const Modality(
      "OP", "Ophthalmic Photography", ModalityType.kACQUISITION, false, null);
  static const Modality kOPT = const Modality(
      "OPT", "Ophthalmic Tomography", ModalityType.kACQUISITION, false, null);
  static const Modality kOPV = const Modality(
      "OPV", "Ophthalmic Visual Field", ModalityType.kACQUISITION, false, null);
  static const Modality kOSS = const Modality(
      "OSS", "Optical Surface Scan", ModalityType.kACQUISITION, false, null);
  static const Modality kOT =
      const Modality("OT", "Other", ModalityType.kACQUISITION, false, null);
  static const Modality kPLAN = const Modality(
      "PLAN", "Plan", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kPR = const Modality(
      "PR", "Presentation State", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kPT = const Modality(
      "PT",
      "Positron emission tomography (PET)",
      ModalityType.kACQUISITION,
      false,
      null);
  //TODO: determine the correct code for PET/CT
  static const Modality kPTCT = const Modality(
      "PTCT",
      "Computed Tomography & Positron emission tomography (PET)",
      ModalityType.kACQUISITION,
      false,
      null);
  static const Modality kPX = const Modality(
      "PX", "Panoramic X-Ray", ModalityType.kACQUISITION, false, null);
  static const Modality kREG = const Modality(
      "REG", "Registration", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kRESP = const Modality(
      "RESP", "Respiratory Waveform", ModalityType.kACQUISITION, false, null);
  static const Modality kRF = const Modality(
      "RF", "Radio Fluoroscopy", ModalityType.kACQUISITION, false, null);
  static const Modality kRG = const Modality(
      "RG",
      "Radiographic imaging (conventional film/screen)",
      ModalityType.kACQUISITION,
      false,
      null);
  static const Modality kRTDOSE = const Modality(
      "RTDOSE", "Radiotherapy Dose", ModalityType.kACQUISITION, false, null);
  static const Modality kRTIMAGE = const Modality(
      "RTIMAGE", "Radiotherapy Image", ModalityType.kACQUISITION, false, null);
  static const Modality kRTPLAN = const Modality("RTPLAN", "Radiotherapy Plan",
      ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kRTRECORD = const Modality(
      "RTRECORD", "RT Treatment Record", ModalityType.kDOCUMENT, false, null);
  static const Modality kRTSTRUCT = const Modality("RTSTRUCT",
      "Radiotherapy Structure Set", ModalityType.kPLANNING, false, null);
  static const Modality kSEG = const Modality(
      "SEG", "Segmentation", ModalityType.kPOST_PROCESSING, false, null);
  static const Modality kSMR = const Modality(
      "SMR", "Stereometric Relationship", ModalityType.kOTHER, false, null);
  static const Modality kSM = const Modality(
      "SM", "Slide Microscopy", ModalityType.kACQUISITION, false, null);
  static const Modality kSRF = const Modality(
      "SRF", "Subjective Refraction", ModalityType.kACQUISITION, false, null);
  static const Modality kSR =
      const Modality("SR", "SR Document", ModalityType.kDOCUMENT, false, null);
  static const Modality kSTAIN = const Modality("STAIN",
      "Automated Slide Stainer", ModalityType.kACQUISITION, false, null);
  static const Modality kTG = const Modality(
      "TG", "Thermography", ModalityType.kACQUISITION, false, null);
  static const Modality kUS = const Modality(
      "US", "Ultrasound", ModalityType.kACQUISITION, false, null);
  static const Modality kVA = const Modality(
      "VA", "Visual Acuity", ModalityType.kACQUISITION, false, null);
  static const Modality kXA = const Modality(
      "XA", "X-Ray Angiography", ModalityType.kACQUISITION, false, null);
  static const Modality kXC = const Modality("XC",
      "External-camera Photography", ModalityType.kACQUISITION, false, null);
  static const Modality kAS =
      const Modality("AS", "Angioscopy", ModalityType.kACQUISITION, true, null);

  // Retired Modalities below here
  static const Modality kCD = const Modality(
      "CD", "Color flow Doppler", ModalityType.kACQUISITION, true, kUS);
  static const Modality kCF = const Modality(
      "CF", "Cinefluorography", ModalityType.kACQUISITION, true, kRF);
  static const Modality kCP =
      const Modality("CP", "Culposcopy", ModalityType.kACQUISITION, true, null);
  static const Modality kCS =
      const Modality("CS", "Cystoscopy", ModalityType.kACQUISITION, true, null);
  static const Modality kDD = const Modality(
      "DD", "Duplex Doppler", ModalityType.kACQUISITION, true, kUS);
  static const Modality kDF = const Modality(
      "DF", "Digital fluoroscopy", ModalityType.kACQUISITION, true, kRF);
  static const Modality kDM = const Modality(
      "DM", "Digital microscopy", ModalityType.kACQUISITION, true, null);
  static const Modality kDS = const Modality("DS",
      "Digital Subtraction Angiography", ModalityType.kACQUISITION, true, kXA);
  static const Modality kEC = const Modality(
      "EC", "Echocardiography", ModalityType.kACQUISITION, true, kUS);
  static const Modality kFA = const Modality(
      "FA", "Fluorescein angiography", ModalityType.kACQUISITION, true, null);
  static const Modality kFS =
      const Modality("FS", "Fundoscopy", ModalityType.kACQUISITION, true, null);
  static const Modality kLP = const Modality(
      "LP", "Laparoscopy", ModalityType.kACQUISITION, true, null);
  static const Modality kMA = const Modality("MA",
      "Magnetic resonance angiography", ModalityType.kACQUISITION, true, kMR);
  static const Modality kMS = const Modality("MS",
      "Magnetic resonance spectroscopy", ModalityType.kACQUISITION, true, kMR);
  static const Modality kOPR = const Modality(
      "OPR", "Ophthalmic Refraction", ModalityType.kACQUISITION, true, null);
  static const Modality kST = const Modality(
      "ST",
      "Single-photon emission computed tomography (SPECT)",
      ModalityType.kACQUISITION,
      true,
      kNM);
  static const Modality kVF = const Modality(
      "VF", "Videofluorography", ModalityType.kACQUISITION, true, kRF);

  static const Modality kUnknown = const Modality(
      "Unknown", "Unknown Modality", ModalityType.kOTHER, false, null);

  // A lookup table for modality codes.
  //TODO find out why keys can't be Symbols
  static const Map<String, Modality> stringToModality = const {
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

  /// [lookupOldName] returns the [Modality] associated with [name] even if it has been
  /// replaced by a new one.
  static Modality lookupOldName(String name) => stringToModality[name];

  /// Returns the current name for this modality.
  static Modality lookup(String name) {
    Modality m = stringToModality[name];
    if (m == null) return null;
    return (m.mapsTo == null) ? m : m.mapsTo;
  }
}
