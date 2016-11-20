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
  static const MClass ACQUISITION = const MClass(0);
  static const MClass DERIVED = const MClass(1);
  static const MClass MEASUREMENT = const MClass(2);
  static const MClass PLANNING = const MClass(3);
  static const MClass POST_PROCESSING = const MClass(4);
  static const MClass DOCUMENT = const MClass(5);
  static const MClass OTHER = const MClass(6);
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

  const ModalityType(this.keyword, this.name, this.mClass, this.isRetired, this.mapsTo);

  bool get isAcquisition => (mClass == MClass.ACQUISITION);
  bool get isDerived => (mClass == MClass.DERIVED);
  bool get isDocument => (mClass == MClass.DOCUMENT);
  bool get isMeasurement => (mClass == MClass.MEASUREMENT);
  bool get isOther => (mClass == MClass.OTHER);
  bool get isPlanning => (mClass == MClass.PLANNING);
  bool get isPostProcessing => (mClass == MClass.POST_PROCESSING);

  /// [replacedBy] returns the new modality that replaced this modality
  ModalityType get replacedBy => (this.replacedBy == null) ? this.keyword : this.mapsTo;

  toString() => 'Modality.$keyword';

  static const ModalityType AR =
      const ModalityType("AR", "Autorefraction", MClass.ACQUISITION, false, null);
  static const ModalityType AU = const ModalityType("AU", "Audio", MClass.ACQUISITION, false, null);
  static const ModalityType BDUS =
      const ModalityType("BDUS", "Bone Densitometry (ultrasound)", MClass.ACQUISITION, false, null);
  static const ModalityType BI =
      const ModalityType("BI", "Biomagnetic imaging", MClass.ACQUISITION, false, null);
  static const ModalityType BMD =
      const ModalityType("BMD", "Bone Densitometry (X-Ray)", MClass.ACQUISITION, false, null);
  static const ModalityType CR =
      const ModalityType("CR", "Computed Radiography", MClass.ACQUISITION, false, null);
  // Note: this is a special (Non-DICOM) Modality added for Clinical Trial Processors
  static const ModalityType CTP =
  const ModalityType("CTP", "Clinical Trial Processor", MClass.DERIVED, false, null);
  static const ModalityType CT =
      const ModalityType("CT", "Computed Tomography", MClass.ACQUISITION, false, null);
  static const ModalityType DG =
      const ModalityType("DG", "Diaphanography", MClass.ACQUISITION, false, null);
  static const ModalityType DOC = const ModalityType("DOC", "Document", MClass.DOCUMENT, false, null);
  static const ModalityType DX =
      const ModalityType("DX", "Digital Radiography", MClass.ACQUISITION, false, null);
  static const ModalityType ECG =
      const ModalityType("ECG", "Electrocardiography", MClass.ACQUISITION, false, null);
  static const ModalityType EPS =
      const ModalityType("EPS", "Cardiac Electrophysiology", MClass.ACQUISITION, false, null);
  static const ModalityType ES = const ModalityType("ES", "Endoscopy", MClass.ACQUISITION, false, null);
  static const ModalityType FID = const ModalityType("FID", "Fiducials", MClass.ACQUISITION, false, null);
  static const ModalityType GM =
      const ModalityType("GM", "General Microscopy", MClass.ACQUISITION, false, null);
  static const ModalityType HC = const ModalityType("HC", "Hard Copy", MClass.OTHER, false, null);
  static const ModalityType HD =
      const ModalityType("HD", "Hemodynamic Waveform", MClass.ACQUISITION, false, null);
  static const ModalityType IO =
      const ModalityType("IO", "Intra-Oral Radiography", MClass.ACQUISITION, false, null);
  static const ModalityType IOL =
      const ModalityType("IOL", "Intraocular Lens Data", MClass.ACQUISITION, false, null);
  static const ModalityType IVOCT = const ModalityType(
      "IVOCT", "Intravascular Optical Coherence Tomography", MClass.ACQUISITION, false, null);
  static const ModalityType IVUS =
      const ModalityType("IVUS", "Intravascular Ultrasound", MClass.ACQUISITION, false, null);
  static const ModalityType KER = const ModalityType("KER", "Keratometry", MClass.ACQUISITION, false, null);
  static const ModalityType KO =
      const ModalityType("KO", "Key Object Selection", MClass.POST_PROCESSING, false, null);
  static const ModalityType LEN = const ModalityType("LEN", "Lensometry", MClass.ACQUISITION, false, null);
  static const ModalityType LS =
      const ModalityType("LS", "Laser surface scan", MClass.ACQUISITION, false, null);
  static const ModalityType MG = const ModalityType("MG", "Mammography", MClass.ACQUISITION, false, null);
  static const ModalityType MR =
      const ModalityType("MR", "Magnetic Resonance", MClass.ACQUISITION, false, null);
  static const ModalityType NM =
      const ModalityType("NM", "Nuclear Medicine", MClass.ACQUISITION, false, null);
  static const ModalityType OAM =
      const ModalityType("OAM", "Ophthalmic Axial Measurements", MClass.POST_PROCESSING, false, null);
  static const ModalityType OCT = const ModalityType(
      "OCT", "Optical Coherence Tomography (non-Ophthalmic)", MClass.ACQUISITION, false, null);
  static const ModalityType OPM =
      const ModalityType("OPM", "Ophthalmic Mapping", MClass.POST_PROCESSING, false, null);
  static const ModalityType OP =
      const ModalityType("OP", "Ophthalmic Photography", MClass.ACQUISITION, false, null);
  static const ModalityType OPT =
      const ModalityType("OPT", "Ophthalmic Tomography", MClass.ACQUISITION, false, null);
  static const ModalityType OPV =
      const ModalityType("OPV", "Ophthalmic Visual Field", MClass.ACQUISITION, false, null);
  static const ModalityType OSS =
      const ModalityType("OSS", "Optical Surface Scan", MClass.ACQUISITION, false, null);
  static const ModalityType OT = const ModalityType("OT", "Other", MClass.ACQUISITION, false, null);
  static const ModalityType PLAN = const ModalityType("PLAN", "Plan", MClass.POST_PROCESSING, false, null);
  static const ModalityType PR =
      const ModalityType("PR", "Presentation State", MClass.POST_PROCESSING, false, null);
  static const ModalityType PT =
      const ModalityType("PT", "Positron emission tomography (PET)", MClass.ACQUISITION, false, null);
  //TODO: determine the correct code for PET/CT
  static const ModalityType PTCT =
  const ModalityType("PTCT", "Computed Tomography & Positron emission tomography (PET)", MClass
      .ACQUISITION, false, null);
  static const ModalityType PX =
      const ModalityType("PX", "Panoramic X-Ray", MClass.ACQUISITION, false, null);
  static const ModalityType REG =
      const ModalityType("REG", "Registration", MClass.POST_PROCESSING, false, null);
  static const ModalityType RESP =
      const ModalityType("RESP", "Respiratory Waveform", MClass.ACQUISITION, false, null);
  static const ModalityType RF =
      const ModalityType("RF", "Radio Fluoroscopy", MClass.ACQUISITION, false, null);
  static const ModalityType RG = const ModalityType(
      "RG", "Radiographic imaging (conventional film/screen)", MClass.ACQUISITION, false, null);
  static const ModalityType RTDOSE =
      const ModalityType("RTDOSE", "Radiotherapy Dose", MClass.ACQUISITION, false, null);
  static const ModalityType RTIMAGE =
      const ModalityType("RTIMAGE", "Radiotherapy Image", MClass.ACQUISITION, false, null);
  static const ModalityType RTPLAN =
      const ModalityType("RTPLAN", "Radiotherapy Plan", MClass.POST_PROCESSING, false, null);
  static const ModalityType RTRECORD =
      const ModalityType("RTRECORD", "RT Treatment Record", MClass.DOCUMENT, false, null);
  static const ModalityType RTSTRUCT =
      const ModalityType("RTSTRUCT", "Radiotherapy Structure Set", MClass.PLANNING, false, null);
  static const ModalityType SEG =
      const ModalityType("SEG", "Segmentation", MClass.POST_PROCESSING, false, null);
  static const ModalityType SMR =
      const ModalityType("SMR", "Stereometric Relationship", MClass.OTHER, false, null);
  static const ModalityType SM =
      const ModalityType("SM", "Slide Microscopy", MClass.ACQUISITION, false, null);
  static const ModalityType SRF =
      const ModalityType("SRF", "Subjective Refraction", MClass.ACQUISITION, false, null);
  static const ModalityType SR = const ModalityType("SR", "SR Document", MClass.DOCUMENT, false, null);
  static const ModalityType STAIN =
      const ModalityType("STAIN", "Automated Slide Stainer", MClass.ACQUISITION, false, null);
  static const ModalityType TG = const ModalityType("TG", "Thermography", MClass.ACQUISITION, false, null);
  static const ModalityType US = const ModalityType("US", "Ultrasound", MClass.ACQUISITION, false, null);
  static const ModalityType VA = const ModalityType("VA", "Visual Acuity", MClass.ACQUISITION, false, null);
  static const ModalityType XA =
      const ModalityType("XA", "X-Ray Angiography", MClass.ACQUISITION, false, null);
  static const ModalityType XC =
      const ModalityType("XC", "External-camera Photography", MClass.ACQUISITION, false, null);
  static const ModalityType AS = const ModalityType("AS", "Angioscopy", MClass.ACQUISITION, true, null);

  // Retired Modalities below here
  static const ModalityType CD =
      const ModalityType("CD", "Color flow Doppler", MClass.ACQUISITION, true, US);
  static const ModalityType CF = const ModalityType("CF", "Cinefluorography", MClass.ACQUISITION, true, RF);
  static const ModalityType CP = const ModalityType("CP", "Culposcopy", MClass.ACQUISITION, true, null);
  static const ModalityType CS = const ModalityType("CS", "Cystoscopy", MClass.ACQUISITION, true, null);
  static const ModalityType DD = const ModalityType("DD", "Duplex Doppler", MClass.ACQUISITION, true, US);
  static const ModalityType DF =
      const ModalityType("DF", "Digital fluoroscopy", MClass.ACQUISITION, true, RF);
  static const ModalityType DM =
      const ModalityType("DM", "Digital microscopy", MClass.ACQUISITION, true, null);
  static const ModalityType DS =
      const ModalityType("DS", "Digital Subtraction Angiography", MClass.ACQUISITION, true, XA);
  static const ModalityType EC = const ModalityType("EC", "Echocardiography", MClass.ACQUISITION, true, US);
  static const ModalityType FA =
      const ModalityType("FA", "Fluorescein angiography", MClass.ACQUISITION, true, null);
  static const ModalityType FS = const ModalityType("FS", "Fundoscopy", MClass.ACQUISITION, true, null);
  static const ModalityType LP = const ModalityType("LP", "Laparoscopy", MClass.ACQUISITION, true, null);
  static const ModalityType MA =
      const ModalityType("MA", "Magnetic resonance angiography", MClass.ACQUISITION, true, MR);
  static const ModalityType MS =
      const ModalityType("MS", "Magnetic resonance spectroscopy", MClass.ACQUISITION, true, MR);
  static const ModalityType OPR =
      const ModalityType("OPR", "Ophthalmic Refraction", MClass.ACQUISITION, true, null);
  static const ModalityType ST = const ModalityType(
      "ST", "Single-photon emission computed tomography (SPECT)", MClass.ACQUISITION, true, NM);
  static const ModalityType VF =
  const ModalityType("VF", "Videofluorography", MClass.ACQUISITION, true, RF);

  static const ModalityType Unknown =
  const ModalityType("Unknown", "Unknown Modality", MClass.OTHER, false, null);

  // A lookup table for modality codes.
  //TODO find out why keys can't be Symbols
  static const Map<String, ModalityType> stringToModality = const {
    "AR": AR,
    "AU": AU,
    "BDUS": BDUS,
    "BI": BI,
    "BMD": BMD,
    "CR": CR,
    "CT": CT,
    "CTP": CTP,
    "DG": DG,
    "DOC": DOC,
    "DX": DX,
    "ECG": ECG,
    "EPS": EPS,
    "ES": ES,
    "FID": FID,
    "GM": GM,
    "HC": HC,
    "HD": HD,
    "IO": IO,
    "IOL": IOL,
    "IVOCT": IVOCT,
    "IVUS": IVUS,
    "KER": KER,
    "KO": KO,
    "LEN": LEN,
    "LS": LS,
    "MG": MG,
    "MR": MR,
    "NM": NM,
    "OAM": OAM,
    "OCT": OCT,
    "OPM": OPM,
    "OP": OP,
    "OPT": OPT,
    "OPV": OPV,
    "OSS": OSS,
    "OT": OT,
    "PLAN": PLAN,
    "PR": PR,
    "PT": PT,
    "PTCT": PTCT,
    "PX": PX,
    "REG": REG,
    "RESP": RESP,
    "RF": RF,
    "RG": RG,
    "RTDOSE": RTDOSE,
    "RTIMAGE": RTIMAGE,
    "RTPLAN": RTPLAN,
    "RTRECORD": RTRECORD,
    "RTSTRUCT": RTSTRUCT,
    "SEG": SEG,
    "SMR": SMR,
    "SM": SM,
    "SRF": SRF,
    "SR": SR,
    "STAIN": STAIN,
    "TG": TG,
    "US": US,
    "VA": VA,
    "XA": XA,
    "XC": XC,
    "AS": AS,
    "CD": CD,
    "CF": CF,
    "CP": CP,
    "CS": CS,
    "DD": DD,
    "DF": DF,
    "DM": DM,
    "DS": DS,
    "EC": EC,
    "FA": FA,
    "FS": FS,
    "LP": LP,
    "MA": MA,
    "MS": MS,
    "OPR": OPR,
    "ST": ST,
    "VF": VF,
    "Unknown": Unknown
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
