// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.modality.modality_class ;


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
//TODO Replace isAcquitition with ModalityClass
//TODO: rename constants as kName
class Modality {
  //TODO should this be Symbol or String
  final Symbol keyword;
  final String name;
  final MClass mClass;
  final bool isRetired;
  final Modality mapsTo;

  const Modality(this.keyword, this.name, this.mClass, this.isRetired, this.mapsTo);

  static const Modality AR = const Modality(#AR, "Autorefraction", MClass.ACQUISITION, false, null
                                            );
  static const Modality AU = const Modality(#AU, "Audio", MClass.ACQUISITION, false, null);
  static const Modality BDUS = const Modality(#BDUS, "Bone Densitometry (ultrasound)",
                                                  MClass.ACQUISITION, false, null);
  static const Modality BI = const Modality(#BI, "Biomagnetic imaging", MClass.ACQUISITION, false,
                                                null);
  static const Modality BMD = const Modality(#BMD, "Bone Densitometry (X-Ray)", MClass.ACQUISITION,
                                                 false, null);
  static const Modality CR = const Modality(#CR, "Computed Radiography", MClass.ACQUISITION, false,
                                                null);
  static const Modality CT = const Modality(#CT, "Computed Tomography", MClass.ACQUISITION, false,
                                                null);
  static const Modality DG = const Modality(#DG, "Diaphanography", MClass.ACQUISITION, false, null
                                            );
  static const Modality DOC = const Modality(#DOC, "Document", MClass.DOCUMENT, false, null);
  static const Modality DX = const Modality(#DX, "Digital Radiography", MClass.ACQUISITION, false,
                                                null);
  static const Modality ECG = const Modality(#ECG, "Electrocardiography", MClass.ACQUISITION,
                                                 false, null);
  static const Modality EPS = const Modality(#EPS, "Cardiac Electrophysiology", MClass.ACQUISITION,
                                                 false, null);
  static const Modality ES = const Modality(#ES, "Endoscopy", MClass.ACQUISITION, false, null);
  static const Modality FID = const Modality(#FID, "Fiducials", MClass.ACQUISITION, false, null);
  static const Modality GM = const Modality(#GM, "General Microscopy", MClass.ACQUISITION, false,
                                                null);
  static const Modality HC = const Modality(#HC, "Hard Copy", MClass.OTHER, false, null);
  static const Modality HD = const Modality(#HD, "Hemodynamic Waveform", MClass.ACQUISITION, false,
                                                null);
  static const Modality IO = const Modality(#IO, "Intra-Oral Radiography", MClass.ACQUISITION,
                                                false, null);
  static const Modality IOL = const Modality(#IOL, "Intraocular Lens Data", MClass.ACQUISITION,
                                                 false, null);
  static const Modality IVOCT = const Modality(#IVOCT,
                                                   "Intravascular Optical Coherence Tomography", MClass.ACQUISITION, false, null);
  static const Modality IVUS = const Modality(#IVUS, "Intravascular Ultrasound",
                                                  MClass.ACQUISITION, false, null);
  static const Modality KER = const Modality(#KER, "Keratometry", MClass.ACQUISITION, false, null);
  static const Modality KO = const Modality(#KO, "Key Object Selection", MClass.POST_PROCESSING,
                                                false, null);
  static const Modality LEN = const Modality(#LEN, "Lensometry", MClass.ACQUISITION, false, null);
  static const Modality LS = const Modality(#LS, "Laser surface scan", MClass.ACQUISITION, false,
                                                null);
  static const Modality MG = const Modality(#MG, "Mammography", MClass.ACQUISITION, false, null);
  static const Modality MR = const Modality(#MR, "Magnetic Resonance", MClass.ACQUISITION, false,
                                                null);
  static const Modality NM = const Modality(#NM, "Nuclear Medicine", MClass.ACQUISITION, false,
                                                null);
  static const Modality OAM = const Modality(#OAM, "Ophthalmic Axial Measurements",
                                                 MClass.POST_PROCESSING, false, null);
  static const Modality OCT = const Modality(#OCT, "Optical Coherence Tomography (non-Ophthalmic)",
                                                 MClass.ACQUISITION, false, null);
  static const Modality OPM = const Modality(#OPM, "Ophthalmic Mapping", MClass.POST_PROCESSING,
                                                 false, null);
  static const Modality OP = const Modality(#OP, "Ophthalmic Photography", MClass.ACQUISITION,
                                                false, null);
  static const Modality OPT = const Modality(#OPT, "Ophthalmic Tomography", MClass.ACQUISITION,
                                                 false, null);
  static const Modality OPV = const Modality(#OPV, "Ophthalmic Visual Field", MClass.ACQUISITION,
                                                 false, null);
  static const Modality OSS = const Modality(#OSS, "Optical Surface Scan", MClass.ACQUISITION,
                                                 false, null);
  static const Modality OT = const Modality(#OT, "Other", MClass.ACQUISITION, false, null);
  static const Modality PLAN = const Modality(#PLAN, "Plan", MClass.POST_PROCESSING, false, null);
  static const Modality PR = const Modality(#PR, "Presentation State", MClass.POST_PROCESSING,
                                                false, null);
  static const Modality PT = const Modality(#PT, "Positron emission tomography (PET)",
                                                MClass.ACQUISITION, false, null);
  static const Modality PX = const Modality(#PX, "Panoramic X-Ray", MClass.ACQUISITION, false, null
                                            );
  static const Modality REG = const Modality(#REG, "Registration", MClass.POST_PROCESSING, false,
                                                 null);
  static const Modality RESP = const Modality(#RESP, "Respiratory Waveform", MClass.ACQUISITION,
                                                  false, null);
  static const Modality RF = const Modality(#RF, "Radio Fluoroscopy", MClass.ACQUISITION, false,
                                                null);
  static const Modality RG = const Modality(#RG, "Radiographic imaging (conventional film/screen)",
                                                MClass.ACQUISITION, false, null);
  static const Modality RTDOSE = const Modality(#RTDOSE, "Radiotherapy Dose", MClass.ACQUISITION,
                                                    false, null);
  static const Modality RTIMAGE = const Modality(#RTIMAGE, "Radiotherapy Image",
                                                     MClass.ACQUISITION, false, null);
  static const Modality RTPLAN = const Modality(#RTPLAN, "Radiotherapy Plan",
                                                    MClass.POST_PROCESSING, false, null);
  static const Modality RTRECORD = const Modality(#RTRECORD, "RT Treatment Record",
                                                      MClass.DOCUMENT, false, null);
  static const Modality RTSTRUCT = const Modality(#RTSTRUCT, "Radiotherapy Structure Set",
                                                      MClass.PLANNING, false, null);
  static const Modality SEG = const Modality(#SEG, "Segmentation", MClass.POST_PROCESSING, false,
                                                 null);
  static const Modality SMR = const Modality(#SMR, "Stereometric Relationship", MClass.OTHER,
                                                 false, null);
  static const Modality SM = const Modality(#SM, "Slide Microscopy", MClass.ACQUISITION, false,
                                                null);
  static const Modality SRF = const Modality(#SRF, "Subjective Refraction", MClass.ACQUISITION,
                                                 false, null);
  static const Modality SR = const Modality(#SR, "SR Document", MClass.DOCUMENT, false, null);
  static const Modality STAIN = const Modality(#STAIN, "Automated Slide Stainer",
                                                   MClass.ACQUISITION, false, null);
  static const Modality TG = const Modality(#TG, "Thermography", MClass.ACQUISITION, false, null);
  static const Modality US = const Modality(#US, "Ultrasound", MClass.ACQUISITION, false, null);
  static const Modality VA = const Modality(#VA, "Visual Acuity", MClass.ACQUISITION, false, null);
  static const Modality XA = const Modality(#XA, "X-Ray Angiography", MClass.ACQUISITION, false,
                                                null);
  static const Modality XC = const Modality(#XC, "External-camera Photography", MClass.ACQUISITION,
                                                false, null);
  static const Modality AS = const Modality(#AS, "Angioscopy", MClass.ACQUISITION, true, null);
  static const Modality CD = const Modality(#CD, "Color flow Doppler", MClass.ACQUISITION, true, US
                                            );
  static const Modality CF = const Modality(#CF, "Cinefluorography", MClass.ACQUISITION, true, RF);
  static const Modality CP = const Modality(#CP, "Culposcopy", MClass.ACQUISITION, true, null);
  static const Modality CS = const Modality(#CS, "Cystoscopy", MClass.ACQUISITION, true, null);
  static const Modality DD = const Modality(#DD, "Duplex Doppler", MClass.ACQUISITION, true, US);
  static const Modality DF = const Modality(#DF, "Digital fluoroscopy", MClass.ACQUISITION, true,
                                                RF);
  static const Modality DM = const Modality(#DM, "Digital microscopy", MClass.ACQUISITION, true,
                                                null);
  static const Modality DS = const Modality(#DS, "Digital Subtraction Angiography",
                                                MClass.ACQUISITION, true, XA);
  static const Modality EC = const Modality(#EC, "Echocardiography", MClass.ACQUISITION, true, US);
  static const Modality FA = const Modality(#FA, "Fluorescein angiography", MClass.ACQUISITION,
                                                true, null);
  static const Modality FS = const Modality(#FS, "Fundoscopy", MClass.ACQUISITION, true, null);
  static const Modality LP = const Modality(#LP, "Laparoscopy", MClass.ACQUISITION, true, null);
  static const Modality MA = const Modality(#MA, "Magnetic resonance angiography",
                                                MClass.ACQUISITION, true, MR);
  static const Modality MS = const Modality(#MS, "Magnetic resonance spectroscopy",
                                                MClass.ACQUISITION, true, MR);
  static const Modality OPR = const Modality(#OPR, "Ophthalmic Refraction", MClass.ACQUISITION,
                                                 true, null);
  static const Modality ST = const Modality(#ST,
                                                "Single-photon emission computed tomography (SPECT)", MClass.ACQUISITION, true, NM);
  static const Modality VF = const Modality(#VF, "Videofluorography", MClass.ACQUISITION, true, RF
                                            );

  bool get isAcquisition => (mClass == MClass.ACQUISITION);
  bool get isDerived => (mClass == MClass.DERIVED);
  bool get isDocument => (mClass == MClass.DOCUMENT);
  bool get isMeasurement => (mClass == MClass.MEASUREMENT);
  bool get isOther => (mClass == MClass.OTHER);
  bool get isPlanning => (mClass == MClass.PLANNING);
  bool get isPostProcessing => (mClass == MClass.POST_PROCESSING);

  /// [replacedBy] returns the new modality that replaced this modality
  Modality get replacedBy => (this.replacedBy == null) ? this.keyword : this.mapsTo;

  // A lookup table for modality codes.
  //TODO find out why keys can't be Symbols
  static const  Map<String, Modality> modalityMap = const {
    "AR":    AR,
    "AU":    AU,
    "BDUS":  BDUS,
    "BI":    BI,
    "BMD":   BMD,
    "CR":    CR,
    "CT":    CT,
    "DG":    DG,
    "DOC":   DOC,
    "DX":    DX,
    "ECG":   ECG,
    "EPS":   EPS,
    "ES":    ES,
    "FID":   FID,
    "GM":    GM,
    "HC":    HC,
    "HD":    HD,
    "IO":    IO,
    "IOL":   IOL,
    "IVOCT": IVOCT,
    "IVUS":  IVUS,
    "KER":   KER,
    "KO":    KO,
    "LEN":   LEN,
    "LS":    LS,
    "MG":    MG,
    "MR":    MR,
    "NM":    NM,
    "OAM":   OAM,
    "OCT":   OCT,
    "OPM":   OPM,
    "OP":    OP,
    "OPT":   OPT,
    "OPV":   OPV,
    "OSS":   OSS,
    "OT":    OT,
    "PLAN":  PLAN,
    "PR":    PR,
    "PT":    PT,
    "PX":    PX,
    "REG":   REG,
    "RESP":  RESP,
    "RF":    RF,
    "RG":    RG,
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
    "VF": VF
  };

  /// [lookupOldName] returns the [Modality] associated with [name] even if it has been
  /// replaced by a new one.
  static Modality lookupOldName(Symbol name) => modalityMap[name];

  /// Returns the current name for this modality.
  static Modality lookup(Symbol name) {
    Modality mod = modalityMap[name];
    return (mod.mapsTo == null) ? mod : mod.mapsTo;
  }

  toString() => 'Modality.${keyword.toString()}';
}
