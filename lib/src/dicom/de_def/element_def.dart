// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/de_def/de_defs.dart';
import 'package:dictionary/src/dicom/tag/tag.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

//TODO: sort out the naming between Attribute, Data Element, tag, etc.
// DICOM Attribute Definitions
class ElementDef {
  final String keyword;
  final int code;
  final String name;
  final VR vr;
  final VM vm;
  final bool isRetired;

  const ElementDef(this.keyword, this.code, this.name, this.vr, this.vm, this.isRetired);

  String get hex => Tag.hex(code);

  int get group => Tag.group(code);

  String get groupHex => Tag.groupHex(code);

  int get elt => Tag.elt(code);

  String get eltHex => Tag.eltHex(code);

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'Element: ${Tag.dcm(code)} $keyword, $vr, $vm, $retired';
  }

  static ElementDef lookup(int tag) {
    ElementDef e = deDefs[tag];
    if (e != null) return e;

    // Retired _special case_ tags that still must be handled

    // (0020,31xx)
    if ((tag >= 0x00283100) && (tag <= 0x002031FF)) return ElementDef.kSourceImageIDs;

    // (0028,04X0)
    if ((tag >= 0x00280410) && (tag <= 0x002804F0)) return ElementDef.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((tag >= 0x00280411) && (tag <= 0x002804F1)) return ElementDef.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((tag >= 0x00280412) && (tag <= 0x002804F2)) return ElementDef.kCoefficientCoding;
    // (0028,04X3)
    if ((tag >= 0x00280413) && (tag <= 0x002804F3)) return ElementDef.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((tag >= 0x00280810) && (tag <= 0x002808F0)) return ElementDef.kCodeLabel;
    // (0028,08x2)
    if ((tag >= 0x00280812) && (tag <= 0x002808F2)) return ElementDef.kNumberOfTables;
    // (0028,08x3)
    if ((tag >= 0x00280813) && (tag <= 0x002808F3)) return ElementDef.kCodeTableLocation;
    // (0028,08x4)
    if ((tag >= 0x00280814) && (tag <= 0x002808F4)) return ElementDef.kBitsForCodeWord;
    // (0028,08x8)
    if ((tag >= 0x00280818) && (tag <= 0x002808F8)) return ElementDef.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((tag >= 0x10000000) && (tag <= 0x1000FFF0)) return ElementDef.kEscapeTriplet;
    // (1000,04X3)
    if ((tag >= 0x10000001) && (tag <= 0x1000FFF1)) return ElementDef.kRunLengthTriplet;
    // (1000,08x0)
    if ((tag >= 0x10000002) && (tag <= 0x1000FFF2)) return ElementDef.kHuffmanTableSize;
    // (1000,08x2)
    if ((tag >= 0x10000003) && (tag <= 0x1000FFF3)) return ElementDef.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((tag >= 0x10000004) && (tag <= 0x1000FFF4)) return ElementDef.kShiftTableSize;
    // (1000,08x4)
    if ((tag >= 0x10000005) && (tag <= 0x1000FFF5)) return ElementDef.kShiftTableTriplet;
    // (1000,08x8)
    if ((tag >= 0x10100000) && (tag <= 0x1010FFFF)) return ElementDef.kZonalMap;

    //TODO: 0x50xx,yyyy Elements
    //TODO: 0x60xx,yyyy Elements
    //TODO: 0x7Fxx,yyyy Elements

    // No match return [null]
    return null;
  }

  //**** Message Data Elements begin here ****
  static const kAffectedSOPInstanceUID = const ElementDef(
      "AffectedSOPInstanceUID", 0x00001000, "Affected SOP Instance UID ", VR.kUI, VM.k1, false);

  static const kRequestedSOPInstanceUID = const ElementDef(
      "RequestedSOPInstanceUID", 0x00001001,
      "Requested SOP Instance UID", VR.kUI, VM.k1, false);

  //**** File Meta Information Data Elements begin here ****
  static const kFileMetaInformationGroupLength = const ElementDef("FileMetaInformationGroupLength",
      0x00020000, "File Meta Information Group Length", VR.kUL, VM.k1, false);

  static const kFileMetaInformationVersion = const ElementDef("FileMetaInformationVersion", 0x00020001,
      "File Meta Information Version", VR.kOB, VM.k1, false);

  static const kMediaStorageSOPClassUID = const ElementDef(
      "MediaStorageSOPClassUID", 0x00020002, "Media Storage SOP Class UID", VR.kUI, VM.k1, false);

  static const kMediaStorageSOPInstanceUID = const ElementDef("MediaStorageSOPInstanceUID", 0x00020003,
      "Media Storage SOP Instance UID", VR.kUI, VM.k1, false);

  static const kTransferSyntaxUID =
      const ElementDef("TransferSyntaxUID", 0x00020010, "Transfer Syntax UID", VR.kUI, VM.k1, false);

  static const kImplementationClassUID = const ElementDef(
      "ImplementationClassUID", 0x00020012, "Implementation Class UID", VR.kUI, VM.k1, false);

  static const kImplementationVersionName = const ElementDef(
      "ImplementationVersionName", 0x00020013, "Implementation Version Name", VR.kSH, VM.k1, false);

  static const kSourceApplicationEntityTitle = const ElementDef("SourceApplicationEntityTitle",
      0x00020016, "Source ApplicationEntity Title", VR.kAE, VM.k1, false);

  static const kSendingApplicationEntityTitle = const ElementDef("SendingApplicationEntityTitle",
      0x00020017, "Sending Application Entity Title", VR.kAE, VM.k1, false);

  static const kReceivingApplicationEntityTitle = const ElementDef("ReceivingApplicationEntityTitle",
      0x00020018, "Receiving Application Entity Title", VR.kAE, VM.k1, false);

  static const kPrivateInformationCreatorUID = const ElementDef("PrivateInformationCreatorUID",
      0x00020100, "Private Information Creator UID", VR.kUI, VM.k1, false);

  static const kPrivateInformation =
      const ElementDef("PrivateInformation", 0x00020102, "Private Information", VR.kOB, VM.k1, false);

  //**** DICOM Directory Tags begin here ****
  static const ElementDef kFileSetID =
      const ElementDef("FileSetID", 0x00041130, "File-set ID", VR.kCS, VM.k1, false);

  static const ElementDef kFileSetDescriptorFileID = const ElementDef(
      "FileSetDescriptorFileID", 0x00041141, "File-set Descriptor File ID", VR.kCS, VM.k1_8, false);

  static const ElementDef kSpecificCharacterSetOfFileSetDescriptorFile = const ElementDef(
      "SpecificCharacterSetOfFileSetDescriptorFile",
      0x00041142,
      "Specific Character Set of File Set Descriptor File",
      VR.kCS,
      VM.k1,
      false);

  static const ElementDef kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity = const ElementDef(
      "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
      0x00041200,
      "Offset of the First Directory Record of the Root Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const ElementDef kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity = const ElementDef(
      "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
      0x00041202,
      "Offset of the Last Directory Record of the Root Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const ElementDef kFileSetConsistencyFlag = const ElementDef(
      "FileSetConsistencyFlag", 0x00041212, "File-set Consistency Flag", VR.kUS, VM.k1, false);

  static const ElementDef kDirectoryRecordSequence = const ElementDef(
      "DirectoryRecordSequence", 0x00041220, "Directory Record Sequence", VR.kSQ, VM.k1, false);

  static const ElementDef kOffsetOfTheNextDirectoryRecord = const ElementDef(
      "OffsetOfTheNextDirectoryRecord",
      0x00041400,
      "Offset of the Next Directory Record",
      VR.kUL,
      VM.k1,
      false);

  static const ElementDef kRecordInUseFlag =
      const ElementDef("RecordInUseFlag", 0x00041410, "Record In-use Flag", VR.kUS, VM.k1, false);

  static const ElementDef kOffsetOfReferencedLowerLevelDirectoryEntity = const ElementDef(
      "OffsetOfReferencedLowerLevelDirectoryEntity",
      0x00041420,
      "Offset of Referenced Lower-Level Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const ElementDef kDirectoryRecordType = const ElementDef(
      "DirectoryRecordType", 0x00041430, "Directory​Record​Type", VR.kCS, VM.k1, false);

  static const ElementDef kPrivateRecordUID =
      const ElementDef("PrivateRecordUID", 0x00041432, "Private Record UID", VR.kUI, VM.k1, false);

  static const ElementDef kReferencedFileID =
      const ElementDef("ReferencedFileID", 0x00041500, "Referenced File ID", VR.kCS, VM.k1_8, false);

  static const ElementDef kMRDRDirectoryRecordOffset = const ElementDef(
      "MRDRDirectoryRecordOffset", 0x00041504, "MRDR Directory Record Offset", VR.kUL, VM.k1, true);

  static const ElementDef kReferencedSOPClassUIDInFile = const ElementDef("ReferencedSOPClassUIDInFile",
      0x00041510, "Referenced SOP Class UID in File", VR.kUI, VM.k1, false);

  static const ElementDef kReferencedSOPInstanceUIDInFile = const ElementDef(
      "ReferencedSOPInstanceUIDInFile",
      0x00041511,
      "Referenced SOP Instance UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const ElementDef kReferencedTransferSyntaxUIDInFile = const ElementDef(
      "ReferencedTransferSyntaxUIDInFile",
      0x00041512,
      "Referenced Transfer Syntax UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const ElementDef kReferencedRelatedGeneralSOPClassUIDInFile = const ElementDef(
      "ReferencedRelatedGeneralSOPClassUIDInFile",
      0x0004151a,
      "Referenced Related General SOP Class UID in File",
      VR.kUI,
      VM.k1_n,
      false);

  static const ElementDef kNumberOfReferences =
      const ElementDef("NumberOfReferences", 0x00041600, "Number of References", VR.kUL, VM.k1, true);
  //**** Standard Dataset Tags begin here ****

  static const ElementDef kLengthToEnd
      //(0008,0001) "00080001"
      = const ElementDef("LengthToEnd", 0x00080001, "Length to End", VR.kUL, VM.k1, true);
  static const ElementDef kSpecificCharacterSet
      //(0008,0005)
      = const ElementDef(
          "SpecificCharacterSet", 0x00080005, "Specific Character Set", VR.kCS, VM.k1_n, false);
  static const ElementDef kLanguageCodeSequence
      //(0008,0006)
      = const ElementDef(
          "LanguageCodeSequence", 0x00080006, "Language Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImageType
      //(0008,0008)
      = const ElementDef("ImageType", 0x00080008, "Image Type", VR.kCS, VM.k2_n, false);
  static const ElementDef kRecognitionCode
      //(0008,0010)
      = const ElementDef("RecognitionCode", 0x00080010, "Recognition Code", VR.kSH, VM.k1, true);
  static const ElementDef kInstanceCreationDate
      //(0008,0012)
      = const ElementDef(
          "InstanceCreationDate", 0x00080012, "Instance Creation Date", VR.kDA, VM.k1, false);
  static const ElementDef kInstanceCreationTime
      //(0008,0013)
      = const ElementDef(
          "InstanceCreationTime", 0x00080013, "Instance Creation Time", VR.kTM, VM.k1, false);
  static const ElementDef kInstanceCreatorUID
      //(0008,0014)
      =
      const ElementDef("InstanceCreatorUID", 0x00080014, "Instance Creator UID", VR.kUI, VM.k1, false);
  static const ElementDef kInstanceCoercionDateTime
      //(0008,0015)
      = const ElementDef("InstanceCoercionDateTime", 0x00080015, "Instance Coercion DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kSOPClassUID
      //(0008,0016)
      = const ElementDef("SOPClassUID", 0x00080016, "SOP Class UID", VR.kUI, VM.k1, false);
  static const ElementDef kSOPInstanceUID
      //(0008,0018)
      = const ElementDef("SOPInstanceUID", 0x00080018, "SOP Instance UID", VR.kUI, VM.k1, false);
  static const ElementDef kRelatedGeneralSOPClassUID
      //(0008,001A)
      = const ElementDef("RelatedGeneralSOPClassUID", 0x0008001A, "Related General SOP Class UID",
          VR.kUI, VM.k1_n, false);
  static const ElementDef kOriginalSpecializedSOPClassUID
      //(0008,001B)
      = const ElementDef("OriginalSpecializedSOPClassUID", 0x0008001B,
          "Original Specialized SOP Class UID", VR.kUI, VM.k1, false);
  static const ElementDef kStudyDate
      //(0008,0020)
      = const ElementDef("StudyDate", 0x00080020, "Study Date", VR.kDA, VM.k1, false);
  static const ElementDef kSeriesDate
      //(0008,0021)
      = const ElementDef("SeriesDate", 0x00080021, "Series Date", VR.kDA, VM.k1, false);
  static const ElementDef kAcquisitionDate
      //(0008,0022)
      = const ElementDef("AcquisitionDate", 0x00080022, "Acquisition Date", VR.kDA, VM.k1, false);
  static const ElementDef kContentDate
      //(0008,0023)
      = const ElementDef("ContentDate", 0x00080023, "Content Date", VR.kDA, VM.k1, false);
  static const ElementDef kOverlayDate
      //(0008,0024)
      = const ElementDef("OverlayDate", 0x00080024, "Overlay Date", VR.kDA, VM.k1, true);
  static const ElementDef kCurveDate
      //(0008,0025)
      = const ElementDef("CurveDate", 0x00080025, "Curve Date", VR.kDA, VM.k1, true);
  static const ElementDef kAcquisitionDateTime
      //(0008,002A)
      = const ElementDef(
          "AcquisitionDateTime", 0x0008002A, "Acquisition DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kStudyTime
      //(0008,0030)
      = const ElementDef("StudyTime", 0x00080030, "Study Time", VR.kTM, VM.k1, false);
  static const ElementDef kSeriesTime
      //(0008,0031)
      = const ElementDef("SeriesTime", 0x00080031, "Series Time", VR.kTM, VM.k1, false);
  static const ElementDef kAcquisitionTime
      //(0008,0032)
      = const ElementDef("AcquisitionTime", 0x00080032, "Acquisition Time", VR.kTM, VM.k1, false);
  static const ElementDef kContentTime
      //(0008,0033)
      = const ElementDef("ContentTime", 0x00080033, "Content Time", VR.kTM, VM.k1, false);
  static const ElementDef kOverlayTime
      //(0008,0034)
      = const ElementDef("OverlayTime", 0x00080034, "Overlay Time", VR.kTM, VM.k1, true);
  static const ElementDef kCurveTime
      //(0008,0035)
      = const ElementDef("CurveTime", 0x00080035, "Curve Time", VR.kTM, VM.k1, true);
  static const ElementDef kDataSetType
      //(0008,0040)
      = const ElementDef("DataSetType", 0x00080040, "Data Set Type", VR.kUS, VM.k1, true);
  static const ElementDef kDataSetSubtype
      //(0008,0041)
      = const ElementDef("DataSetSubtype", 0x00080041, "Data Set Subtype", VR.kLO, VM.k1, true);
  static const ElementDef kNuclearMedicineSeriesType
      //(0008,0042)
      = const ElementDef("NuclearMedicineSeriesType", 0x00080042, "Nuclear Medicine Series Type",
          VR.kCS, VM.k1, true);
  static const ElementDef kAccessionNumber
      //(0008,0050)
      = const ElementDef("AccessionNumber", 0x00080050, "Accession Number", VR.kSH, VM.k1, false);
  static const ElementDef kIssuerOfAccessionNumberSequence
      //(0008,0051)
      = const ElementDef("IssuerOfAccessionNumberSequence", 0x00080051,
          "Issuer of Accession Number Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kQueryRetrieveLevel
      //(0008,0052)
      =
      const ElementDef("QueryRetrieveLevel", 0x00080052, "Query/Retrieve Level", VR.kCS, VM.k1, false);
  static const ElementDef kQueryRetrieveView
      //(0008,0053)
      = const ElementDef("QueryRetrieveView", 0x00080053, "Query/Retrieve View", VR.kCS, VM.k1, false);
  static const ElementDef kRetrieveAETitle
      //(0008,0054)
      = const ElementDef("RetrieveAETitle", 0x00080054, "Retrieve AE Title", VR.kAE, VM.k1_n, false);
  static const ElementDef kInstanceAvailability
      //(0008,0056)
      = const ElementDef(
          "InstanceAvailability", 0x00080056, "Instance Availability", VR.kCS, VM.k1, false);
  static const ElementDef kFailedSOPInstanceUIDList
      //(0008,0058)
      = const ElementDef("FailedSOPInstanceUIDList", 0x00080058, "Failed SOP Instance UID List",
          VR.kUI, VM.k1_n, false);
  static const ElementDef kModality
      //(0008,0060)
      = const ElementDef("Modality", 0x00080060, "Modality", VR.kCS, VM.k1, false);
  static const ElementDef kModalitiesInStudy
      //(0008,0061)
      =
      const ElementDef("ModalitiesInStudy", 0x00080061, "Modalities in Study", VR.kCS, VM.k1_n, false);
  static const ElementDef kSOPClassesInStudy
      //(0008,0062)
      = const ElementDef(
          "SOPClassesInStudy", 0x00080062, "SOP Classes in Study", VR.kUI, VM.k1_n, false);
  static const ElementDef kConversionType
      //(0008,0064)
      = const ElementDef("ConversionType", 0x00080064, "Conversion Type", VR.kCS, VM.k1, false);
  static const ElementDef kPresentationIntentType
      //(0008,0068)
      = const ElementDef(
          "PresentationIntentType", 0x00080068, "Presentation Intent Type", VR.kCS, VM.k1, false);
  static const ElementDef kManufacturer
      //(0008,0070)
      = const ElementDef("Manufacturer", 0x00080070, "Manufacturer", VR.kLO, VM.k1, false);
  static const ElementDef kInstitutionName
      //(0008,0080)
      = const ElementDef("InstitutionName", 0x00080080, "Institution Name", VR.kLO, VM.k1, false);
  static const ElementDef kInstitutionAddress
      //(0008,0081)
      =
      const ElementDef("InstitutionAddress", 0x00080081, "Institution Address", VR.kST, VM.k1, false);
  static const ElementDef kInstitutionCodeSequence
      //(0008,0082)
      = const ElementDef(
          "InstitutionCodeSequence", 0x00080082, "Institution Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferringPhysicianName
      //(0008,0090)
      = const ElementDef(
          "ReferringPhysicianName", 0x00080090, "Referring Physician's Name", VR.kPN, VM.k1, false);
  static const ElementDef kReferringPhysicianAddress
      //(0008,0092)
      = const ElementDef("ReferringPhysicianAddress", 0x00080092, "Referring Physician's Address",
          VR.kST, VM.k1, false);
  static const ElementDef kReferringPhysicianTelephoneNumbers
      //(0008,0094)
      = const ElementDef("ReferringPhysicianTelephoneNumbers", 0x00080094,
          "Referring Physician's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const ElementDef kReferringPhysicianIdentificationSequence
      //(0008,0096)
      = const ElementDef("ReferringPhysicianIdentificationSequence", 0x00080096,
          "Referring Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCodeValue
      //(0008,0100)
      = const ElementDef("CodeValue", 0x00080100, "Code Value", VR.kSH, VM.k1, false);
  static const ElementDef kExtendedCodeValue
      //(0008,0101)
      = const ElementDef("ExtendedCodeValue", 0x00080101, "Extended Code Value", VR.kLO, VM.k1, false);
  static const ElementDef kCodingSchemeDesignator
      //(0008,0102)
      = const ElementDef(
          "CodingSchemeDesignator", 0x00080102, "Coding Scheme Designator", VR.kSH, VM.k1, false);
  static const ElementDef kCodingSchemeVersion
      //(0008,0103)
      = const ElementDef(
          "CodingSchemeVersion", 0x00080103, "Coding Scheme Version", VR.kSH, VM.k1, false);
  static const ElementDef kCodeMeaning
      //(0008,0104)
      = const ElementDef("CodeMeaning", 0x00080104, "Code Meaning", VR.kLO, VM.k1, false);
  static const ElementDef kMappingResource
      //(0008,0105)
      = const ElementDef("MappingResource", 0x00080105, "Mapping Resource", VR.kCS, VM.k1, false);
  static const ElementDef kContextGroupVersion
      //(0008,0106)
      = const ElementDef(
          "ContextGroupVersion", 0x00080106, "Context Group Version", VR.kDT, VM.k1, false);
  static const ElementDef kContextGroupLocalVersion
      //(0008,0107)
      = const ElementDef("ContextGroupLocalVersion", 0x00080107, "Context Group Local Version", VR.kDT,
          VM.k1, false);
  static const ElementDef kExtendedCodeMeaning
      //(0008,0108)
      = const ElementDef(
          "ExtendedCodeMeaning", 0x00080108, "Extended Code Meaning", VR.kLT, VM.k1, false);
  static const ElementDef kContextGroupExtensionFlag
      //(0008,010B)
      = const ElementDef("ContextGroupExtensionFlag", 0x0008010B, "Context Group Extension Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kCodingSchemeUID
      //(0008,010C)
      = const ElementDef("CodingSchemeUID", 0x0008010C, "Coding Scheme UID", VR.kUI, VM.k1, false);
  static const ElementDef kContextGroupExtensionCreatorUID
      //(0008,010D)
      = const ElementDef("ContextGroupExtensionCreatorUID", 0x0008010D,
          "Context Group Extension Creator UID", VR.kUI, VM.k1, false);
  static const ElementDef kContextIdentifier
      //(0008,010F)
      = const ElementDef("ContextIdentifier", 0x0008010F, "Context Identifier", VR.kCS, VM.k1, false);
  static const ElementDef kCodingSchemeIdentificationSequence
      //(0008,0110)
      = const ElementDef("CodingSchemeIdentificationSequence", 0x00080110,
          "Coding Scheme Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCodingSchemeRegistry
      //(0008,0112)
      = const ElementDef(
          "CodingSchemeRegistry", 0x00080112, "Coding Scheme Registry", VR.kLO, VM.k1, false);
  static const ElementDef kCodingSchemeExternalID
      //(0008,0114)
      = const ElementDef(
          "CodingSchemeExternalID", 0x00080114, "Coding Scheme External ID", VR.kST, VM.k1, false);
  static const ElementDef kCodingSchemeName
      //(0008,0115)
      = const ElementDef("CodingSchemeName", 0x00080115, "Coding Scheme Name", VR.kST, VM.k1, false);
  static const ElementDef kCodingSchemeResponsibleOrganization
      //(0008,0116)
      = const ElementDef("CodingSchemeResponsibleOrganization", 0x00080116,
          "Coding Scheme Responsible Organization", VR.kST, VM.k1, false);
  static const ElementDef kContextUID
      //(0008,0117)
      = const ElementDef("ContextUID", 0x00080117, "Context UID", VR.kUI, VM.k1, false);
  static const ElementDef kTimezoneOffsetFromUTC
      //(0008,0201)
      = const ElementDef(
          "TimezoneOffsetFromUTC", 0x00080201, "Timezone Offset From UTC", VR.kSH, VM.k1, false);

  static const kPrivateDataElementCharacteristicsSequence = const ElementDef(
      "PrivateDataElementCharacteristicsSequence",
      0x0080300,
      "Private​Data​Element​Characteristics​Sequence",
      VR.kSQ,
      VM.k1,
      false);

  static const kPrivateGroupReference = const ElementDef(
      "PrivateGroupReference",
      0x00080301,
      "Private Group Reference",
      VR.kUS,
      VM.k1,
      false);


  static const kPrivateCreatorReference = const ElementDef(
      "PrivateCreatorReference",
      0x00080302,
      "Private Creator Reference",
      VR.kLO,
      VM.k1,
      false);

  static const kBlockIdentifyingInformationStatus = const ElementDef(
      "BlockIdentifyingInformationStatus",
      0x00080303,
      "Block Identifying Information Status",
      VR.kCS,
      VM.k1,
      false);

  static const kNonidentifyingPrivateElements = const ElementDef(
      "NonidentifyingPrivateElements",
      0x00080304,
      "Nonidentifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const kDeidentificationActionSequence = const ElementDef(
      "DeidentificationActionSequence",
      0x00080305,
      "Deidentification Action Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const kIdentifyingPrivateElements = const ElementDef(
      "IdentifyingPrivateElements",
      0x00080306,
      "Identifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const kDeidentificationAction = const ElementDef(
      "DeidentificationAction",
      0x00080307,
      "Deidentification Action",
      VR.kCS,
      VM.k1,
      false);
  static const ElementDef kNetworkID
      //(0008,1000)
      = const ElementDef("NetworkID", 0x00081000, "Network ID", VR.kAE, VM.k1, true);
  static const ElementDef kStationName
      //(0008,1010)
      = const ElementDef("StationName", 0x00081010, "Station Name", VR.kSH, VM.k1, false);
  static const ElementDef kStudyDescription
      //(0008,1030)
      = const ElementDef("StudyDescription", 0x00081030, "Study Description", VR.kLO, VM.k1, false);
  static const ElementDef kProcedureCodeSequence
      //(0008,1032)
      = const ElementDef(
          "ProcedureCodeSequence", 0x00081032, "Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSeriesDescription
      //(0008,103E)
      = const ElementDef("SeriesDescription", 0x0008103E, "Series Description", VR.kLO, VM.k1, false);
  static const ElementDef kSeriesDescriptionCodeSequence
      //(0008,103F)
      = const ElementDef("SeriesDescriptionCodeSequence", 0x0008103F,
          "Series Description Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kInstitutionalDepartmentName
      //(0008,1040)
      = const ElementDef("InstitutionalDepartmentName", 0x00081040, "Institutional Department Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kPhysiciansOfRecord
      //(0008,1048)
      = const ElementDef(
          "PhysiciansOfRecord", 0x00081048, "Physician(s) of Record", VR.kPN, VM.k1_n, false);
  static const ElementDef kPhysiciansOfRecordIdentificationSequence
      //(0008,1049)
      = const ElementDef("PhysiciansOfRecordIdentificationSequence", 0x00081049,
          "Physician(s) of Record Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformingPhysicianName
      //(0008,1050)
      = const ElementDef("PerformingPhysicianName", 0x00081050, "Performing Physician's Name", VR.kPN,
          VM.k1_n, false);
  static const ElementDef kPerformingPhysicianIdentificationSequence
      //(0008,1052)
      = const ElementDef("PerformingPhysicianIdentificationSequence", 0x00081052,
          "Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNameOfPhysiciansReadingStudy
      //(0008,1060)
      = const ElementDef("NameOfPhysiciansReadingStudy", 0x00081060,
          "Name of Physician(s) Reading Study", VR.kPN, VM.k1_n, false);
  static const ElementDef kPhysiciansReadingStudyIdentificationSequence
      //(0008,1062)
      = const ElementDef("PhysiciansReadingStudyIdentificationSequence", 0x00081062,
          "Physician(s) Reading Study Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOperatorsName
      //(0008,1070)
      = const ElementDef("OperatorsName", 0x00081070, "Operators' Name", VR.kPN, VM.k1_n, false);
  static const ElementDef kOperatorIdentificationSequence
      //(0008,1072)
      = const ElementDef("OperatorIdentificationSequence", 0x00081072,
          "Operator Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAdmittingDiagnosesDescription
      //(0008,1080)
      = const ElementDef("AdmittingDiagnosesDescription", 0x00081080,
          "Admitting Diagnoses Description", VR.kLO, VM.k1_n, false);
  static const ElementDef kAdmittingDiagnosesCodeSequence
      //(0008,1084)
      = const ElementDef("AdmittingDiagnosesCodeSequence", 0x00081084,
          "Admitting Diagnoses Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kManufacturerModelName
      //(0008,1090)
      = const ElementDef(
          "ManufacturerModelName", 0x00081090, "Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const ElementDef kReferencedResultsSequence
      //(0008,1100)
      = const ElementDef("ReferencedResultsSequence", 0x00081100, "Referenced Results Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedStudySequence
      //(0008,1110)
      = const ElementDef(
          "ReferencedStudySequence", 0x00081110, "Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedPerformedProcedureStepSequence
      //(0008,1111)
      = const ElementDef("ReferencedPerformedProcedureStepSequence", 0x00081111,
          "Referenced Performed Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSeriesSequence
      //(0008,1115)
      = const ElementDef("ReferencedSeriesSequence", 0x00081115, "Referenced Series Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kReferencedPatientSequence
      //(0008,1120)
      = const ElementDef("ReferencedPatientSequence", 0x00081120, "Referenced Patient Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedVisitSequence
      //(0008,1125)
      = const ElementDef(
          "ReferencedVisitSequence", 0x00081125, "Referenced Visit Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedOverlaySequence
      //(0008,1130)
      = const ElementDef("ReferencedOverlaySequence", 0x00081130, "Referenced Overlay Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedStereometricInstanceSequence
      //(0008,1134)
      = const ElementDef("ReferencedStereometricInstanceSequence", 0x00081134,
          "Referenced Stereometric Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedWaveformSequence
      //(0008,113A)
      = const ElementDef("ReferencedWaveformSequence", 0x0008113A, "Referenced Waveform Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedImageSequence
      //(0008,1140)
      = const ElementDef(
          "ReferencedImageSequence", 0x00081140, "Referenced Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedCurveSequence
      //(0008,1145)
      = const ElementDef(
          "ReferencedCurveSequence", 0x00081145, "Referenced Curve Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedInstanceSequence
      //(0008,114A)
      = const ElementDef("ReferencedInstanceSequence", 0x0008114A, "Referenced Instance Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedRealWorldValueMappingInstanceSequence
      //(0008,114B)
      = const ElementDef("ReferencedRealWorldValueMappingInstanceSequence", 0x0008114B,
          "Referenced Real World Value Mapping Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSOPClassUID
      //(0008,1150)
      = const ElementDef(
          "ReferencedSOPClassUID", 0x00081150, "Referenced SOP Class UID", VR.kUI, VM.k1, false);
  static const ElementDef kReferencedSOPInstanceUID
      //(0008,1155)
      = const ElementDef("ReferencedSOPInstanceUID", 0x00081155, "Referenced SOP Instance UID", VR.kUI,
          VM.k1, false);
  static const ElementDef kSOPClassesSupported
      //(0008,115A)
      = const ElementDef(
          "SOPClassesSupported", 0x0008115A, "SOP Classes Supported", VR.kUI, VM.k1_n, false);
  static const ElementDef kReferencedFrameNumber
      //(0008,1160)
      = const ElementDef(
          "ReferencedFrameNumber", 0x00081160, "Referenced Frame Number", VR.kIS, VM.k1_n, false);
  static const ElementDef kSimpleFrameList
      //(0008,1161)
      = const ElementDef("SimpleFrameList", 0x00081161, "Simple Frame List", VR.kUL, VM.k1_n, false);
  static const ElementDef kCalculatedFrameList
      //(0008,1162)
      = const ElementDef(
          "CalculatedFrameList", 0x00081162, "Calculated Frame List", VR.kUL, VM.k3_3n, false);
  static const ElementDef kTimeRange
      //(0008,1163)
      = const ElementDef("TimeRange", 0x00081163, "TimeRange", VR.kFD, VM.k2, false);
  static const ElementDef kFrameExtractionSequence
      //(0008,1164)
      = const ElementDef(
          "FrameExtractionSequence", 0x00081164, "Frame Extraction Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMultiFrameSourceSOPInstanceUID
      //(0008,1167)
      = const ElementDef("MultiFrameSourceSOPInstanceUID", 0x00081167,
          "Multi-frame Source SOP Instance UID", VR.kUI, VM.k1, false);
  static const ElementDef kRetrieveURL
      //(0008,1190)
      = const ElementDef("RetrieveURL", 0x00081190, "Retrieve URL", VR.kUT, VM.k1, false);
  static const ElementDef kTransactionUID
      //(0008,1195)
      = const ElementDef("TransactionUID", 0x00081195, "Transaction UID", VR.kUI, VM.k1, false);
  static const ElementDef kWarningReason
      //(0008,1196)
      = const ElementDef("WarningReason", 0x00081196, "Warning Reason", VR.kUS, VM.k1, false);
  static const ElementDef kFailureReason
      //(0008,1197)
      = const ElementDef("FailureReason", 0x00081197, "Failure Reason", VR.kUS, VM.k1, false);
  static const ElementDef kFailedSOPSequence
      //(0008,1198)
      = const ElementDef("FailedSOPSequence", 0x00081198, "Failed SOP Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSOPSequence
      //(0008,1199)
      = const ElementDef(
          "ReferencedSOPSequence", 0x00081199, "Referenced SOP Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStudiesContainingOtherReferencedInstancesSequence
      //(0008,1200)
      = const ElementDef("StudiesContainingOtherReferencedInstancesSequence", 0x00081200,
          "Studies Containing Other Referenced Instances Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRelatedSeriesSequence
      //(0008,1250)
      = const ElementDef(
          "RelatedSeriesSequence", 0x00081250, "Related Series Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLossyImageCompressionRetired
      //(0008,2110)
      = const ElementDef("LossyImageCompressionRetired", 0x00082110,
          "Lossy Image Compression (Retired)", VR.kCS, VM.k1, true);
  static const ElementDef kDerivationDescription
      //(0008,2111)
      = const ElementDef(
          "DerivationDescription", 0x00082111, "Derivation Description", VR.kST, VM.k1, false);
  static const ElementDef kSourceImageSequence
      //(0008,2112)
      = const ElementDef(
          "SourceImageSequence", 0x00082112, "Source Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStageName
      //(0008,2120)
      = const ElementDef("StageName", 0x00082120, "Stage Name", VR.kSH, VM.k1, false);
  static const ElementDef kStageNumber
      //(0008,2122)
      = const ElementDef("StageNumber", 0x00082122, "Stage Number", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfStages
      //(0008,2124)
      =
      const ElementDef("NumberOfStages", 0x00082124, "Number of Stages", VR.kIS, VM.k1, false);
  static const ElementDef kViewName
      //(0008,2127)
      = const ElementDef("ViewName", 0x00082127, "View Name", VR.kSH, VM.k1, false);
  static const ElementDef kViewNumber
      //(0008,2128)
      = const ElementDef("ViewNumber", 0x00082128, "View Number", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfEventTimers
      //(0008,2129)
      = const ElementDef(
          "NumberOfEventTimers", 0x00082129, "Number of Event Timers", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfViewsInStage
      //(0008,212A)
      = const ElementDef("NumberOfViewsInStage", 0x0008212A, "Number of Views in Stage",
          VR.kIS, VM.k1, false);
  static const ElementDef kEventElapsedTimes
      //(0008,2130)
      = const ElementDef(
          "EventElapsedTimes", 0x00082130, "Event Elapsed Time(s)", VR.kDS, VM.k1_n, false);
  static const ElementDef kEventTimerNames
      //(0008,2132)
      = const ElementDef("EventTimerNames", 0x00082132, "Event Timer Name(s)", VR.kLO, VM.k1_n, false);
  static const ElementDef kEventTimerSequence
      //(0008,2133)
      =
      const ElementDef("EventTimerSequence", 0x00082133, "Event Timer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kEventTimeOffset
      //(0008,2134)
      = const ElementDef("EventTimeOffset", 0x00082134, "Event Time Offset", VR.kFD, VM.k1, false);
  static const ElementDef kEventCodeSequence
      //(0008,2135)
      = const ElementDef("EventCodeSequence", 0x00082135, "Event Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStartTrim
      //(0008,2142)
      = const ElementDef("StartTrim", 0x00082142, "Start Trim", VR.kIS, VM.k1, false);
  static const ElementDef kStopTrim
      //(0008,2143)
      = const ElementDef("StopTrim", 0x00082143, "Stop Trim", VR.kIS, VM.k1, false);
  static const ElementDef kRecommendedDisplayFrameRate
      //(0008,2144)
      = const ElementDef("RecommendedDisplayFrameRate", 0x00082144, "Recommended Display Frame Rate",
          VR.kIS, VM.k1, false);
  static const ElementDef kTransducerPosition
      //(0008,2200)
      = const ElementDef("TransducerPosition", 0x00082200, "Transducer Position", VR.kCS, VM.k1, true);
  static const ElementDef kTransducerOrientation
      //(0008,2204)
      = const ElementDef(
          "TransducerOrientation", 0x00082204, "Transducer Orientation", VR.kCS, VM.k1, true);
  static const ElementDef kAnatomicStructure
      //(0008,2208)
      = const ElementDef("AnatomicStructure", 0x00082208, "Anatomic Structure", VR.kCS, VM.k1, true);
  static const ElementDef kAnatomicRegionSequence
      //(0008,2218)
      = const ElementDef(
          "AnatomicRegionSequence", 0x00082218, "Anatomic Region Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAnatomicRegionModifierSequence
      //(0008,2220)
      = const ElementDef("AnatomicRegionModifierSequence", 0x00082220,
          "Anatomic Region Modifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPrimaryAnatomicStructureSequence
      //(0008,2228)
      = const ElementDef("PrimaryAnatomicStructureSequence", 0x00082228,
          "Primary Anatomic Structure Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAnatomicStructureSpaceOrRegionSequence
      //(0008,2229)
      = const ElementDef("AnatomicStructureSpaceOrRegionSequence", 0x00082229,
          "Anatomic Structure: Space or Region Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPrimaryAnatomicStructureModifierSequence
      //(0008,2230)
      = const ElementDef("PrimaryAnatomicStructureModifierSequence", 0x00082230,
          "Primary Anatomic Structure Modifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTransducerPositionSequence
      //(0008,2240)
      = const ElementDef("TransducerPositionSequence", 0x00082240, "Transducer Position Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kTransducerPositionModifierSequence
      //(0008,2242)
      = const ElementDef("TransducerPositionModifierSequence", 0x00082242,
          "Transducer Position Modifier Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kTransducerOrientationSequence
      //(0008,2244)
      = const ElementDef("TransducerOrientationSequence", 0x00082244,
          "Transducer Orientation Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kTransducerOrientationModifierSequence
      //(0008,2246)
      = const ElementDef("TransducerOrientationModifierSequence", 0x00082246,
          "Transducer Orientation Modifier Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicStructureSpaceOrRegionCodeSequenceTrial
      //(0008,2251)
      = const ElementDef("AnatomicStructureSpaceOrRegionCodeSequenceTrial", 0x00082251,
          "Anatomic Structure Space Or Region Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicPortalOfEntranceCodeSequenceTrial
      //(0008,2253)
      = const ElementDef("AnatomicPortalOfEntranceCodeSequenceTrial", 0x00082253,
          "Anatomic Portal Of Entrance Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicApproachDirectionCodeSequenceTrial
      //(0008,2255)
      = const ElementDef("AnatomicApproachDirectionCodeSequenceTrial", 0x00082255,
          "Anatomic Approach Direction Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicPerspectiveDescriptionTrial
      //(0008,2256)
      = const ElementDef("AnatomicPerspectiveDescriptionTrial", 0x00082256,
          "Anatomic Perspective Description (Trial)", VR.kST, VM.k1, true);
  static const ElementDef kAnatomicPerspectiveCodeSequenceTrial
      //(0008,2257)
      = const ElementDef("AnatomicPerspectiveCodeSequenceTrial", 0x00082257,
          "Anatomic Perspective Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicLocationOfExaminingInstrumentDescriptionTrial
      //(0008,2258)
      = const ElementDef("AnatomicLocationOfExaminingInstrumentDescriptionTrial", 0x00082258,
          "Anatomic Location Of Examining Instrument Description (Trial)", VR.kST, VM.k1, true);
  static const ElementDef kAnatomicLocationOfExaminingInstrumentCodeSequenceTrial
      //(0008,2259)
      = const ElementDef("AnatomicLocationOfExaminingInstrumentCodeSequenceTrial", 0x00082259,
          "Anatomic Location Of Examining Instrument Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAnatomicStructureSpaceOrRegionModifierCodeSequenceTrial
      //(0008,225A)
      = const ElementDef("AnatomicStructureSpaceOrRegionModifierCodeSequenceTrial", 0x0008225A,
          "Anatomic Structure Space Or Region Modifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kOnAxisBackgroundAnatomicStructureCodeSequenceTrial
      //(0008,225C)
      = const ElementDef("OnAxisBackgroundAnatomicStructureCodeSequenceTrial", 0x0008225C,
          "OnAxis Background Anatomic Structure Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAlternateRepresentationSequence
      //(0008,3001)
      = const ElementDef("AlternateRepresentationSequence", 0x00083001,
          "Alternate Representation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIrradiationEventUID
      //(0008,3010)
      = const ElementDef(
          "IrradiationEventUID", 0x00083010, "Irradiation Event UID", VR.kUI, VM.k1_n, false);
  static const ElementDef kIdentifyingComments
      //(0008,4000)
      =
      const ElementDef("IdentifyingComments", 0x00084000, "Identifying Comments", VR.kLT, VM.k1, true);
  static const ElementDef kFrameType
      //(0008,9007)
      = const ElementDef("FrameType", 0x00089007, "Frame Type", VR.kCS, VM.k4, false);
  static const ElementDef kReferencedImageEvidenceSequence
      //(0008,9092)
      = const ElementDef("ReferencedImageEvidenceSequence", 0x00089092,
          "Referenced Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedRawDataSequence
      //(0008,9121)
      = const ElementDef("ReferencedRawDataSequence", 0x00089121, "Referenced Raw Data Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCreatorVersionUID
      //(0008,9123)
      = const ElementDef("CreatorVersionUID", 0x00089123, "Creator-Version UID", VR.kUI, VM.k1, false);
  static const ElementDef kDerivationImageSequence
      //(0008,9124)
      = const ElementDef(
          "DerivationImageSequence", 0x00089124, "Derivation Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceImageEvidenceSequence
      //(0008,9154)
      = const ElementDef("SourceImageEvidenceSequence", 0x00089154, "Source Image Evidence Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPixelPresentation
      //(0008,9205)
      = const ElementDef("PixelPresentation", 0x00089205, "Pixel Presentation", VR.kCS, VM.k1, false);
  static const ElementDef kVolumetricProperties
      //(0008,9206)
      = const ElementDef(
          "VolumetricProperties", 0x00089206, "Volumetric Properties", VR.kCS, VM.k1, false);
  static const ElementDef kVolumeBasedCalculationTechnique
      //(0008,9207)
      = const ElementDef("VolumeBasedCalculationTechnique", 0x00089207,
          "Volume Based Calculation Technique", VR.kCS, VM.k1, false);
  static const ElementDef kComplexImageComponent
      //(0008,9208)
      = const ElementDef(
          "ComplexImageComponent", 0x00089208, "Complex Image Component", VR.kCS, VM.k1, false);
  static const ElementDef kAcquisitionContrast
      //(0008,9209)
      = const ElementDef(
          "AcquisitionContrast", 0x00089209, "Acquisition Contrast", VR.kCS, VM.k1, false);
  static const ElementDef kDerivationCodeSequence
      //(0008,9215)
      = const ElementDef(
          "DerivationCodeSequence", 0x00089215, "Derivation Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedPresentationStateSequence
      //(0008,9237)
      = const ElementDef("ReferencedPresentationStateSequence", 0x00089237,
          "Referenced Presentation State Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedOtherPlaneSequence
      //(0008,9410)
      = const ElementDef("ReferencedOtherPlaneSequence", 0x00089410, "Referenced Other Plane Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kFrameDisplaySequence
      //(0008,9458)
      = const ElementDef(
          "FrameDisplaySequence", 0x00089458, "Frame Display Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecommendedDisplayFrameRateInFloat
      //(0008,9459)
      = const ElementDef("RecommendedDisplayFrameRateInFloat", 0x00089459,
          "Recommended Display Frame Rate in Float", VR.kFL, VM.k1, false);
  static const ElementDef kSkipFrameRangeFlag
      //(0008,9460)
      = const ElementDef(
          "SkipFrameRangeFlag", 0x00089460, "Skip Frame Range Flag", VR.kCS, VM.k1, false);
  static const ElementDef kPatientName
      //(0010,0010)
      = const ElementDef("PatientName", 0x00100010, "Patient's Name", VR.kPN, VM.k1, false);
  static const ElementDef kPatientID
      //(0010,0020)
      = const ElementDef("PatientID", 0x00100020, "Patient ID", VR.kLO, VM.k1, false);
  static const ElementDef kIssuerOfPatientID
      //(0010,0021)
      =
      const ElementDef("IssuerOfPatientID", 0x00100021, "Issuer of Patient ID", VR.kLO, VM.k1, false);
  static const ElementDef kTypeOfPatientID
      //(0010,0022)
      = const ElementDef("TypeOfPatientID", 0x00100022, "Type of Patient ID", VR.kCS, VM.k1, false);
  static const ElementDef kIssuerOfPatientIDQualifiersSequence
      //(0010,0024)
      = const ElementDef("IssuerOfPatientIDQualifiersSequence", 0x00100024,
          "Issuer of Patient ID Qualifiers Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientBirthDate
      //(0010,0030)
      = const ElementDef("PatientBirthDate", 0x00100030, "Patient's Birth Date", VR.kDA, VM.k1, false);
  static const ElementDef kPatientBirthTime
      //(0010,0032)
      = const ElementDef("PatientBirthTime", 0x00100032, "Patient's Birth Time", VR.kTM, VM.k1, false);
  static const ElementDef kPatientSex
      //(0010,0040)
      = const ElementDef("PatientSex", 0x00100040, "Patient's Sex", VR.kCS, VM.k1, false);
  static const ElementDef kPatientInsurancePlanCodeSequence
      //(0010,0050)
      = const ElementDef("PatientInsurancePlanCodeSequence", 0x00100050,
          "Patient's Insurance Plan Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientPrimaryLanguageCodeSequence
      //(0010,0101)
      = const ElementDef("PatientPrimaryLanguageCodeSequence", 0x00100101,
          "Patient's Primary Language Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientPrimaryLanguageModifierCodeSequence
      //(0010,0102)
      = const ElementDef("PatientPrimaryLanguageModifierCodeSequence", 0x00100102,
          "Patient's Primary Language Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kQualityControlSubject
      //(0010,0200)
      = const ElementDef(
          "QualityControlSubject", 0x00100200, "Quality Control Subject", VR.kCS, VM.k1, false);
  static const ElementDef kQualityControlSubjectTypeCodeSequence
      //(0010,0201)
      = const ElementDef("QualityControlSubjectTypeCodeSequence", 0x00100201,
          "Quality Control Subject Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOtherPatientIDs
      //(0010,1000)
      = const ElementDef("OtherPatientIDs", 0x00101000, "Other Patient IDs", VR.kLO, VM.k1_n, false);
  static const ElementDef kOtherPatientNames
      //(0010,1001)
      =
      const ElementDef("OtherPatientNames", 0x00101001, "Other Patient Names", VR.kPN, VM.k1_n, false);
  static const ElementDef kOtherPatientIDsSequence
      //(0010,1002)
      = const ElementDef("OtherPatientIDsSequence", 0x00101002, "Other Patient IDs Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kPatientBirthName
      //(0010,1005)
      = const ElementDef("PatientBirthName", 0x00101005, "Patient's Birth Name", VR.kPN, VM.k1, false);
  static const ElementDef kPatientAge
      //(0010,1010)
      = const ElementDef("PatientAge", 0x00101010, "Patient's Age", VR.kAS, VM.k1, false);
  static const ElementDef kPatientSize
      //(0010,1020)
      = const ElementDef("PatientSize", 0x00101020, "Patient's Size", VR.kDS, VM.k1, false);
  static const ElementDef kPatientSizeCodeSequence
      //(0010,1021)
      = const ElementDef("PatientSizeCodeSequence", 0x00101021, "Patient's Size Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kPatientWeight
      //(0010,1030)
      = const ElementDef("PatientWeight", 0x00101030, "Patient's Weight", VR.kDS, VM.k1, false);
  static const ElementDef kPatientAddress
      //(0010,1040)
      = const ElementDef("PatientAddress", 0x00101040, "Patient's Address", VR.kLO, VM.k1, false);
  static const ElementDef kInsurancePlanIdentification
      //(0010,1050)
      = const ElementDef("InsurancePlanIdentification", 0x00101050, "Insurance Plan Identification",
          VR.kLO, VM.k1_n, true);
  static const ElementDef kPatientMotherBirthName
      //(0010,1060)
      = const ElementDef("PatientMotherBirthName", 0x00101060, "Patient's Mother's Birth Name", VR.kPN,
          VM.k1, false);
  static const ElementDef kMilitaryRank
      //(0010,1080)
      = const ElementDef("MilitaryRank", 0x00101080, "Military Rank", VR.kLO, VM.k1, false);
  static const ElementDef kBranchOfService
      //(0010,1081)
      = const ElementDef("BranchOfService", 0x00101081, "Branch of Service", VR.kLO, VM.k1, false);
  static const ElementDef kMedicalRecordLocator
      //(0010,1090)
      = const ElementDef(
          "MedicalRecordLocator", 0x00101090, "Medical Record Locator", VR.kLO, VM.k1, false);
  static const ElementDef kReferencedPatientPhotoSequence = const ElementDef(
      // (0010,1100)
      "ReferencedPatientPhotoSequence",
      0x00101100,
      "Referenced Patient Photo Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const ElementDef kMedicalAlerts
      //(0010,2000)
      = const ElementDef("MedicalAlerts", 0x00102000, "Medical Alerts", VR.kLO, VM.k1_n, false);
  static const ElementDef kAllergies
      //(0010,2110)
      = const ElementDef("Allergies", 0x00102110, "Allergies", VR.kLO, VM.k1_n, false);
  static const ElementDef kCountryOfResidence
      //(0010,2150)
      =
      const ElementDef("CountryOfResidence", 0x00102150, "Country of Residence", VR.kLO, VM.k1, false);
  static const ElementDef kRegionOfResidence
      //(0010,2152)
      = const ElementDef("RegionOfResidence", 0x00102152, "Region of Residence", VR.kLO, VM.k1, false);
  static const ElementDef kPatientTelephoneNumbers
      //(0010,2154)
      = const ElementDef("PatientTelephoneNumbers", 0x00102154, "Patient's Telephone Numbers", VR.kSH,
          VM.k1_n, false);
  static const ElementDef kEthnicGroup
      //(0010,2160)
      = const ElementDef("EthnicGroup", 0x00102160, "Ethnic Group", VR.kSH, VM.k1, false);
  static const ElementDef kOccupation
      //(0010,2180)
      = const ElementDef("Occupation", 0x00102180, "Occupation", VR.kSH, VM.k1, false);
  static const ElementDef kSmokingStatus
      //(0010,21A0)
      = const ElementDef("SmokingStatus", 0x001021A0, "Smoking Status", VR.kCS, VM.k1, false);
  static const ElementDef kAdditionalPatientHistory
      //(0010,21B0)
      = const ElementDef("AdditionalPatientHistory", 0x001021B0, "Additional Patient History", VR.kLT,
          VM.k1, false);
  static const ElementDef kPregnancyStatus
      //(0010,21C0)
      = const ElementDef("PregnancyStatus", 0x001021C0, "Pregnancy Status", VR.kUS, VM.k1, false);
  static const ElementDef kLastMenstrualDate
      //(0010,21D0)
      = const ElementDef("LastMenstrualDate", 0x001021D0, "Last Menstrual Date", VR.kDA, VM.k1, false);
  static const ElementDef kPatientReligiousPreference
      //(0010,21F0)
      = const ElementDef("PatientReligiousPreference", 0x001021F0, "Patient's Religious Preference",
          VR.kLO, VM.k1, false);
  static const ElementDef kPatientSpeciesDescription
      //(0010,2201)
      = const ElementDef("PatientSpeciesDescription", 0x00102201, "Patient Species Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kPatientSpeciesCodeSequence
      //(0010,2202)
      = const ElementDef("PatientSpeciesCodeSequence", 0x00102202, "Patient Species Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPatientSexNeutered
      //(0010,2203)
      = const ElementDef(
          "PatientSexNeutered", 0x00102203, "Patient's Sex Neutered", VR.kCS, VM.k1, false);
  static const ElementDef kAnatomicalOrientationType
      //(0010,2210)
      = const ElementDef("AnatomicalOrientationType", 0x00102210, "Anatomical Orientation Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kPatientBreedDescription
      //(0010,2292)
      = const ElementDef(
          "PatientBreedDescription", 0x00102292, "Patient Breed Description", VR.kLO, VM.k1, false);
  static const ElementDef kPatientBreedCodeSequence
      //(0010,2293)
      = const ElementDef("PatientBreedCodeSequence", 0x00102293, "Patient Breed Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kBreedRegistrationSequence
      //(0010,2294)
      = const ElementDef("BreedRegistrationSequence", 0x00102294, "Breed Registration Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kBreedRegistrationNumber
      //(0010,2295)
      = const ElementDef(
          "BreedRegistrationNumber", 0x00102295, "Breed Registration Number", VR.kLO, VM.k1, false);
  static const ElementDef kBreedRegistryCodeSequence
      //(0010,2296)
      = const ElementDef("BreedRegistryCodeSequence", 0x00102296, "Breed Registry Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kResponsiblePerson
      //(0010,2297)
      = const ElementDef("ResponsiblePerson", 0x00102297, "Responsible Person", VR.kPN, VM.k1, false);
  static const ElementDef kResponsiblePersonRole
      //(0010,2298)
      = const ElementDef(
          "ResponsiblePersonRole", 0x00102298, "Responsible Person Role", VR.kCS, VM.k1, false);
  static const ElementDef kResponsibleOrganization
      //(0010,2299)
      = const ElementDef(
          "ResponsibleOrganization", 0x00102299, "Responsible Organization", VR.kLO, VM.k1, false);
  static const ElementDef kPatientComments
      //(0010,4000)
      = const ElementDef("PatientComments", 0x00104000, "Patient Comments", VR.kLT, VM.k1, false);
  static const ElementDef kExaminedBodyThickness
      //(0010,9431)
      = const ElementDef(
          "ExaminedBodyThickness", 0x00109431, "Examined Body Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kClinicalTrialSponsorName
      //(0012,0010)
      = const ElementDef("ClinicalTrialSponsorName", 0x00120010, "Clinical Trial Sponsor Name", VR.kLO,
          VM.k1, false);
  static const ElementDef kClinicalTrialProtocolID
      //(0012,0020)
      = const ElementDef("ClinicalTrialProtocolID", 0x00120020, "Clinical Trial Protocol ID", VR.kLO,
          VM.k1, false);
  static const ElementDef kClinicalTrialProtocolName
      //(0012,0021)
      = const ElementDef("ClinicalTrialProtocolName", 0x00120021, "Clinical Trial Protocol Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialSiteID
      //(0012,0030)
      = const ElementDef(
          "ClinicalTrialSiteID", 0x00120030, "Clinical Trial Site ID", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialSiteName
      //(0012,0031)
      = const ElementDef(
          "ClinicalTrialSiteName", 0x00120031, "Clinical Trial Site Name", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialSubjectID
      //(0012,0040)
      = const ElementDef(
          "ClinicalTrialSubjectID", 0x00120040, "Clinical Trial Subject ID", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialSubjectReadingID
      //(0012,0042)
      = const ElementDef("ClinicalTrialSubjectReadingID", 0x00120042,
          "Clinical Trial Subject Reading ID", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialTimePointID
      //(0012,0050)
      = const ElementDef("ClinicalTrialTimePointID", 0x00120050, "Clinical Trial Time Point ID",
          VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialTimePointDescription
      //(0012,0051)
      = const ElementDef("ClinicalTrialTimePointDescription", 0x00120051,
          "Clinical Trial Time Point Description", VR.kST, VM.k1, false);
  static const ElementDef kClinicalTrialCoordinatingCenterName
      //(0012,0060)
      = const ElementDef("ClinicalTrialCoordinatingCenterName", 0x00120060,
          "Clinical Trial Coordinating Center Name", VR.kLO, VM.k1, false);
  static const ElementDef kPatientIdentityRemoved
      //(0012,0062)
      = const ElementDef(
          "PatientIdentityRemoved", 0x00120062, "Patient Identity Removed", VR.kCS, VM.k1, false);
  static const ElementDef kDeidentificationMethod
      //(0012,0063)
      = const ElementDef(
          "DeidentificationMethod", 0x00120063, "De-identification Method", VR.kLO, VM.k1_n, false);
  static const ElementDef kDeidentificationMethodCodeSequence
      //(0012,0064)
      = const ElementDef("DeidentificationMethodCodeSequence", 0x00120064,
          "De-identification Method Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kClinicalTrialSeriesID
      //(0012,0071)
      = const ElementDef(
          "ClinicalTrialSeriesID", 0x00120071, "Clinical Trial Series ID", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialSeriesDescription
      //(0012,0072)
      = const ElementDef("ClinicalTrialSeriesDescription", 0x00120072,
          "Clinical Trial Series Description", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialProtocolEthicsCommitteeName
      //(0012,0081)
      = const ElementDef("ClinicalTrialProtocolEthicsCommitteeName", 0x00120081,
          "Clinical Trial Protocol Ethics Committee Name", VR.kLO, VM.k1, false);
  static const ElementDef kClinicalTrialProtocolEthicsCommitteeApprovalNumber
      //(0012,0082)
      = const ElementDef("ClinicalTrialProtocolEthicsCommitteeApprovalNumber", 0x00120082,
          "Clinical Trial Protocol Ethics Committee Approval Number", VR.kLO, VM.k1, false);
  static const ElementDef kConsentForClinicalTrialUseSequence
      //(0012,0083)
      = const ElementDef("ConsentForClinicalTrialUseSequence", 0x00120083,
          "Consent for Clinical Trial Use Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDistributionType
      //(0012,0084)
      = const ElementDef("DistributionType", 0x00120084, "Distribution Type", VR.kCS, VM.k1, false);
  static const ElementDef kConsentForDistributionFlag
      //(0012,0085)
      = const ElementDef("ConsentForDistributionFlag", 0x00120085, "Consent for Distribution Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kCADFileFormat
      //(0014,0023)
      = const ElementDef("CADFileFormat", 0x00140023, "CAD File Format", VR.kST, VM.k1_n, true);
  static const ElementDef kComponentReferenceSystem
      //(0014,0024)
      = const ElementDef("ComponentReferenceSystem", 0x00140024, "Component Reference System", VR.kST,
          VM.k1_n, true);
  static const ElementDef kComponentManufacturingProcedure
      //(0014,0025)
      = const ElementDef("ComponentManufacturingProcedure", 0x00140025,
          "Component Manufacturing Procedure", VR.kST, VM.k1_n, false);
  static const ElementDef kComponentManufacturer
      //(0014,0028)
      = const ElementDef(
          "ComponentManufacturer", 0x00140028, "Component Manufacturer", VR.kST, VM.k1_n, false);
  static const ElementDef kMaterialThickness
      //(0014,0030)
      =
      const ElementDef("MaterialThickness", 0x00140030, "Material Thickness", VR.kDS, VM.k1_n, false);
  static const ElementDef kMaterialPipeDiameter
      //(0014,0032)
      = const ElementDef(
          "MaterialPipeDiameter", 0x00140032, "Material Pipe Diameter", VR.kDS, VM.k1_n, false);
  static const ElementDef kMaterialIsolationDiameter
      //(0014,0034)
      = const ElementDef("MaterialIsolationDiameter", 0x00140034, "Material Isolation Diameter",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kMaterialGrade
      //(0014,0042)
      = const ElementDef("MaterialGrade", 0x00140042, "Material Grade", VR.kST, VM.k1_n, false);
  static const ElementDef kMaterialPropertiesDescription
      //(0014,0044)
      = const ElementDef("MaterialPropertiesDescription", 0x00140044,
          "Material Properties Description", VR.kST, VM.k1_n, false);
  static const ElementDef kMaterialPropertiesFileFormatRetired
      //(0014,0045)
      = const ElementDef("MaterialPropertiesFileFormatRetired", 0x00140045,
          "Material Properties File Format (Retired)", VR.kST, VM.k1_n, true);
  static const ElementDef kMaterialNotes
      //(0014,0046)
      = const ElementDef("MaterialNotes", 0x00140046, "Material Notes", VR.kLT, VM.k1, false);
  static const ElementDef kComponentShape
      //(0014,0050)
      = const ElementDef("ComponentShape", 0x00140050, "Component Shape", VR.kCS, VM.k1, false);
  static const ElementDef kCurvatureType
      //(0014,0052)
      = const ElementDef("CurvatureType", 0x00140052, "Curvature Type", VR.kCS, VM.k1, false);
  static const ElementDef kOuterDiameter
      //(0014,0054)
      = const ElementDef("OuterDiameter", 0x00140054, "Outer Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kInnerDiameter
      //(0014,0056)
      = const ElementDef("InnerDiameter", 0x00140056, "Inner Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kActualEnvironmentalConditions
      //(0014,1010)
      = const ElementDef("ActualEnvironmentalConditions", 0x00141010,
          "Actual Environmental Conditions", VR.kST, VM.k1, false);
  static const ElementDef kExpiryDate
      //(0014,1020)
      = const ElementDef("ExpiryDate", 0x00141020, "Expiry Date", VR.kDA, VM.k1, false);
  static const ElementDef kEnvironmentalConditions
      //(0014,1040)
      = const ElementDef(
          "EnvironmentalConditions", 0x00141040, "Environmental Conditions", VR.kST, VM.k1, false);
  static const ElementDef kEvaluatorSequence
      //(0014,2002)
      = const ElementDef("EvaluatorSequence", 0x00142002, "Evaluator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kEvaluatorNumber
      //(0014,2004)
      = const ElementDef("EvaluatorNumber", 0x00142004, "Evaluator Number", VR.kIS, VM.k1, false);
  static const ElementDef kEvaluatorName
      //(0014,2006)
      = const ElementDef("EvaluatorName", 0x00142006, "Evaluator Name", VR.kPN, VM.k1, false);
  static const ElementDef kEvaluationAttempt
      //(0014,2008)
      = const ElementDef("EvaluationAttempt", 0x00142008, "Evaluation Attempt", VR.kIS, VM.k1, false);
  static const ElementDef kIndicationSequence
      //(0014,2012)
      =
      const ElementDef("IndicationSequence", 0x00142012, "Indication Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIndicationNumber
      //(0014,2014)
      = const ElementDef("IndicationNumber", 0x00142014, "Indication Number", VR.kIS, VM.k1, false);
  static const ElementDef kIndicationLabel
      //(0014,2016)
      = const ElementDef("IndicationLabel", 0x00142016, "Indication Label", VR.kSH, VM.k1, false);
  static const ElementDef kIndicationDescription
      //(0014,2018)
      = const ElementDef(
          "IndicationDescription", 0x00142018, "Indication Description", VR.kST, VM.k1, false);
  static const ElementDef kIndicationType
      //(0014,201A)
      = const ElementDef("IndicationType", 0x0014201A, "Indication Type", VR.kCS, VM.k1_n, false);
  static const ElementDef kIndicationDisposition
      //(0014,201C)
      = const ElementDef(
          "IndicationDisposition", 0x0014201C, "Indication Disposition", VR.kCS, VM.k1, false);
  static const ElementDef kIndicationROISequence
      //(0014,201E)
      = const ElementDef(
          "IndicationROISequence", 0x0014201E, "Indication ROI Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIndicationPhysicalPropertySequence
      //(0014,2030)
      = const ElementDef("IndicationPhysicalPropertySequence", 0x00142030,
          "Indication Physical Property Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPropertyLabel
      //(0014,2032)
      = const ElementDef("PropertyLabel", 0x00142032, "Property Label", VR.kSH, VM.k1, false);
  static const ElementDef kCoordinateSystemNumberOfAxes
      //(0014,2202)
      = const ElementDef("CoordinateSystemNumberOfAxes", 0x00142202,
          "Coordinate System Number of Axes", VR.kIS, VM.k1, false);
  static const ElementDef kCoordinateSystemAxesSequence
      //(0014,2204)
      = const ElementDef("CoordinateSystemAxesSequence", 0x00142204, "Coordinate System Axes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCoordinateSystemAxisDescription
      //(0014,2206)
      = const ElementDef("CoordinateSystemAxisDescription", 0x00142206,
          "Coordinate System Axis Description", VR.kST, VM.k1, false);
  static const ElementDef kCoordinateSystemDataSetMapping
      //(0014,2208)
      = const ElementDef("CoordinateSystemDataSetMapping", 0x00142208,
          "Coordinate System Data Set Mapping", VR.kCS, VM.k1, false);
  static const ElementDef kCoordinateSystemAxisNumber
      //(0014,220A)
      = const ElementDef("CoordinateSystemAxisNumber", 0x0014220A, "Coordinate System Axis Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kCoordinateSystemAxisType
      //(0014,220C)
      = const ElementDef("CoordinateSystemAxisType", 0x0014220C, "Coordinate System Axis Type", VR.kCS,
          VM.k1, false);
  static const ElementDef kCoordinateSystemAxisUnits
      //(0014,220E)
      = const ElementDef("CoordinateSystemAxisUnits", 0x0014220E, "Coordinate System Axis Units",
          VR.kCS, VM.k1, false);
  static const ElementDef kCoordinateSystemAxisValues
      //(0014,2210)
      = const ElementDef("CoordinateSystemAxisValues", 0x00142210, "Coordinate System Axis Values",
          VR.kOB, VM.k1, false);
  static const ElementDef kCoordinateSystemTransformSequence
      //(0014,2220)
      = const ElementDef("CoordinateSystemTransformSequence", 0x00142220,
          "Coordinate System Transform Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTransformDescription
      //(0014,2222)
      = const ElementDef(
          "TransformDescription", 0x00142222, "Transform Description", VR.kST, VM.k1, false);
  static const ElementDef kTransformNumberOfAxes
      //(0014,2224)
      = const ElementDef(
          "TransformNumberOfAxes", 0x00142224, "Transform Number of Axes", VR.kIS, VM.k1, false);
  static const ElementDef kTransformOrderOfAxes
      //(0014,2226)
      = const ElementDef(
          "TransformOrderOfAxes", 0x00142226, "Transform Order of Axes", VR.kIS, VM.k1_n, false);
  static const ElementDef kTransformedAxisUnits
      //(0014,2228)
      = const ElementDef(
          "TransformedAxisUnits", 0x00142228, "Transformed Axis Units", VR.kCS, VM.k1, false);
  static const ElementDef kCoordinateSystemTransformRotationAndScaleMatrix
      //(0014,222A)
      = const ElementDef("CoordinateSystemTransformRotationAndScaleMatrix", 0x0014222A,
          "Coordinate System Transform Rotation and Scale Matrix", VR.kDS, VM.k1_n, false);
  static const ElementDef kCoordinateSystemTransformTranslationMatrix
      //(0014,222C)
      = const ElementDef("CoordinateSystemTransformTranslationMatrix", 0x0014222C,
          "Coordinate System Transform Translation Matrix", VR.kDS, VM.k1_n, false);
  static const ElementDef kInternalDetectorFrameTime
      //(0014,3011)
      = const ElementDef("InternalDetectorFrameTime", 0x00143011, "Internal Detector Frame Time",
          VR.kDS, VM.k1, false);
  static const ElementDef kNumberOfFramesIntegrated
      //(0014,3012)
      = const ElementDef("NumberOfFramesIntegrated", 0x00143012, "Number of Frames Integrated", VR.kDS,
          VM.k1, false);
  static const ElementDef kDetectorTemperatureSequence
      //(0014,3020)
      = const ElementDef("DetectorTemperatureSequence", 0x00143020, "Detector Temperature Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSensorName
      //(0014,3022)
      = const ElementDef("SensorName", 0x00143022, "Sensor Name", VR.kST, VM.k1, false);
  static const ElementDef kHorizontalOffsetOfSensor
      //(0014,3024)
      = const ElementDef("HorizontalOffsetOfSensor", 0x00143024, "Horizontal Offset of Sensor", VR.kDS,
          VM.k1, false);
  static const ElementDef kVerticalOffsetOfSensor
      //(0014,3026)
      = const ElementDef(
          "VerticalOffsetOfSensor", 0x00143026, "Vertical Offset of Sensor", VR.kDS, VM.k1, false);
  static const ElementDef kSensorTemperature
      //(0014,3028)
      = const ElementDef("SensorTemperature", 0x00143028, "Sensor Temperature", VR.kDS, VM.k1, false);
  static const ElementDef kDarkCurrentSequence
      //(0014,3040)
      = const ElementDef(
          "DarkCurrentSequence", 0x00143040, "Dark Current Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDarkCurrentCounts
      //(0014,3050)
      =
      const ElementDef("DarkCurrentCounts", 0x00143050, "Dark Current Counts", VR.kOBOW, VM.k1, false);
  static const ElementDef kGainCorrectionReferenceSequence
      //(0014,3060)
      = const ElementDef("GainCorrectionReferenceSequence", 0x00143060,
          "Gain Correction Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAirCounts
      //(0014,3070)
      = const ElementDef("AirCounts", 0x00143070, "Air Counts", VR.kOBOW, VM.k1, false);
  static const ElementDef kKVUsedInGainCalibration
      //(0014,3071)
      = const ElementDef("KVUsedInGainCalibration", 0x00143071, "KV Used in Gain Calibration", VR.kDS,
          VM.k1, false);
  static const ElementDef kMAUsedInGainCalibration
      //(0014,3072)
      = const ElementDef("MAUsedInGainCalibration", 0x00143072, "MA Used in Gain Calibration", VR.kDS,
          VM.k1, false);
  static const ElementDef kNumberOfFramesUsedForIntegration
      //(0014,3073)
      = const ElementDef("NumberOfFramesUsedForIntegration", 0x00143073,
          "Number of Frames Used for Integration", VR.kDS, VM.k1, false);
  static const ElementDef kFilterMaterialUsedInGainCalibration
      //(0014,3074)
      = const ElementDef("FilterMaterialUsedInGainCalibration", 0x00143074,
          "Filter Material Used in Gain Calibration", VR.kLO, VM.k1, false);
  static const ElementDef kFilterThicknessUsedInGainCalibration
      //(0014,3075)
      = const ElementDef("FilterThicknessUsedInGainCalibration", 0x00143075,
          "Filter Thickness Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const ElementDef kDateOfGainCalibration
      //(0014,3076)
      = const ElementDef(
          "DateOfGainCalibration", 0x00143076, "Date of Gain Calibration", VR.kDA, VM.k1, false);
  static const ElementDef kTimeOfGainCalibration
      //(0014,3077)
      = const ElementDef(
          "TimeOfGainCalibration", 0x00143077, "Time of Gain Calibration", VR.kTM, VM.k1, false);
  static const ElementDef kBadPixelImage
      //(0014,3080)
      = const ElementDef("BadPixelImage", 0x00143080, "Bad Pixel Image", VR.kOB, VM.k1, false);
  static const ElementDef kCalibrationNotes
      //(0014,3099)
      = const ElementDef("CalibrationNotes", 0x00143099, "Calibration Notes", VR.kLT, VM.k1, false);
  static const ElementDef kPulserEquipmentSequence
      //(0014,4002)
      = const ElementDef(
          "PulserEquipmentSequence", 0x00144002, "Pulser Equipment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPulserType
      //(0014,4004)
      = const ElementDef("PulserType", 0x00144004, "Pulser Type", VR.kCS, VM.k1, false);
  static const ElementDef kPulserNotes
      //(0014,4006)
      = const ElementDef("PulserNotes", 0x00144006, "Pulser Notes", VR.kLT, VM.k1, false);
  static const ElementDef kReceiverEquipmentSequence
      //(0014,4008)
      = const ElementDef("ReceiverEquipmentSequence", 0x00144008, "Receiver Equipment Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAmplifierType
      //(0014,400A)
      = const ElementDef("AmplifierType", 0x0014400A, "Amplifier Type", VR.kCS, VM.k1, false);
  static const ElementDef kReceiverNotes
      //(0014,400C)
      = const ElementDef("ReceiverNotes", 0x0014400C, "Receiver Notes", VR.kLT, VM.k1, false);
  static const ElementDef kPreAmplifierEquipmentSequence
      //(0014,400E)
      = const ElementDef("PreAmplifierEquipmentSequence", 0x0014400E,
          "Pre-Amplifier Equipment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPreAmplifierNotes
      //(0014,400F)
      = const ElementDef("PreAmplifierNotes", 0x0014400F, "Pre-Amplifier Notes", VR.kLT, VM.k1, false);
  static const ElementDef kTransmitTransducerSequence
      //(0014,4010)
      = const ElementDef("TransmitTransducerSequence", 0x00144010, "Transmit Transducer Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReceiveTransducerSequence
      //(0014,4011)
      = const ElementDef("ReceiveTransducerSequence", 0x00144011, "Receive Transducer Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfElements
      //(0014,4012)
      = const ElementDef("NumberOfElements", 0x00144012, "Number of Elements", VR.kUS, VM.k1, false);
  static const ElementDef kElementShape
      //(0014,4013)
      = const ElementDef("ElementShape", 0x00144013, "Element Shape", VR.kCS, VM.k1, false);
  static const ElementDef kElementDimensionA
      //(0014,4014)
      = const ElementDef("ElementDimensionA", 0x00144014, "Element Dimension A", VR.kDS, VM.k1, false);
  static const ElementDef kElementDimensionB
      //(0014,4015)
      = const ElementDef("ElementDimensionB", 0x00144015, "Element Dimension B", VR.kDS, VM.k1, false);
  static const ElementDef kElementPitchA
      //(0014,4016)
      = const ElementDef("ElementPitchA", 0x00144016, "Element Pitch A", VR.kDS, VM.k1, false);
  static const ElementDef kMeasuredBeamDimensionA
      //(0014,4017)
      = const ElementDef(
          "MeasuredBeamDimensionA", 0x00144017, "Measured Beam Dimension A", VR.kDS, VM.k1, false);
  static const ElementDef kMeasuredBeamDimensionB
      //(0014,4018)
      = const ElementDef(
          "MeasuredBeamDimensionB", 0x00144018, "Measured Beam Dimension B", VR.kDS, VM.k1, false);
  static const ElementDef kLocationOfMeasuredBeamDiameter
      //(0014,4019)
      = const ElementDef("LocationOfMeasuredBeamDiameter", 0x00144019,
          "Location of Measured Beam Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kNominalFrequency
      //(0014,401A)
      = const ElementDef("NominalFrequency", 0x0014401A, "Nominal Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kMeasuredCenterFrequency
      //(0014,401B)
      = const ElementDef(
          "MeasuredCenterFrequency", 0x0014401B, "Measured Center Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kMeasuredBandwidth
      //(0014,401C)
      = const ElementDef("MeasuredBandwidth", 0x0014401C, "Measured Bandwidth", VR.kDS, VM.k1, false);
  static const ElementDef kElementPitchB
      //(0014,401D)
      = const ElementDef("ElementPitchB", 0x0014401D, "Element Pitch B", VR.kDS, VM.k1, false);
  static const ElementDef kPulserSettingsSequence
      //(0014,4020)
      = const ElementDef(
          "PulserSettingsSequence", 0x00144020, "Pulser Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPulseWidth
      //(0014,4022)
      = const ElementDef("PulseWidth", 0x00144022, "Pulse Width", VR.kDS, VM.k1, false);
  static const ElementDef kExcitationFrequency
      //(0014,4024)
      = const ElementDef(
          "ExcitationFrequency", 0x00144024, "Excitation Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kModulationType
      //(0014,4026)
      = const ElementDef("ModulationType", 0x00144026, "Modulation Type", VR.kCS, VM.k1, false);
  static const ElementDef kDamping
      //(0014,4028)
      = const ElementDef("Damping", 0x00144028, "Damping", VR.kDS, VM.k1, false);
  static const ElementDef kReceiverSettingsSequence
      //(0014,4030)
      = const ElementDef("ReceiverSettingsSequence", 0x00144030, "Receiver Settings Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kAcquiredSoundpathLength
      //(0014,4031)
      = const ElementDef(
          "AcquiredSoundpathLength", 0x00144031, "Acquired Soundpath Length", VR.kDS, VM.k1, false);
  static const ElementDef kAcquisitionCompressionType
      //(0014,4032)
      = const ElementDef("AcquisitionCompressionType", 0x00144032, "Acquisition Compression Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kAcquisitionSampleSize
      //(0014,4033)
      = const ElementDef(
          "AcquisitionSampleSize", 0x00144033, "Acquisition Sample Size", VR.kIS, VM.k1, false);
  static const ElementDef kRectifierSmoothing
      //(0014,4034)
      =
      const ElementDef("RectifierSmoothing", 0x00144034, "Rectifier Smoothing", VR.kDS, VM.k1, false);
  static const ElementDef kDACSequence
      //(0014,4035)
      = const ElementDef("DACSequence", 0x00144035, "DAC Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDACType
      //(0014,4036)
      = const ElementDef("DACType", 0x00144036, "DAC Type", VR.kCS, VM.k1, false);
  static const ElementDef kDACGainPoints
      //(0014,4038)
      = const ElementDef("DACGainPoints", 0x00144038, "DAC Gain Points", VR.kDS, VM.k1_n, false);
  static const ElementDef kDACTimePoints
      //(0014,403A)
      = const ElementDef("DACTimePoints", 0x0014403A, "DAC Time Points", VR.kDS, VM.k1_n, false);
  static const ElementDef kDACAmplitude
      //(0014,403C)
      = const ElementDef("DACAmplitude", 0x0014403C, "DAC Amplitude", VR.kDS, VM.k1_n, false);
  static const ElementDef kPreAmplifierSettingsSequence
      //(0014,4040)
      = const ElementDef("PreAmplifierSettingsSequence", 0x00144040, "Pre-Amplifier Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTransmitTransducerSettingsSequence
      //(0014,4050)
      = const ElementDef("TransmitTransducerSettingsSequence", 0x00144050,
          "Transmit Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReceiveTransducerSettingsSequence
      //(0014,4051)
      = const ElementDef("ReceiveTransducerSettingsSequence", 0x00144051,
          "Receive Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIncidentAngle
      //(0014,4052)
      = const ElementDef("IncidentAngle", 0x00144052, "Incident Angle", VR.kDS, VM.k1, false);
  static const ElementDef kCouplingTechnique
      //(0014,4054)
      = const ElementDef("CouplingTechnique", 0x00144054, "Coupling Technique", VR.kST, VM.k1, false);
  static const ElementDef kCouplingMedium
      //(0014,4056)
      = const ElementDef("CouplingMedium", 0x00144056, "Coupling Medium", VR.kST, VM.k1, false);
  static const ElementDef kCouplingVelocity
      //(0014,4057)
      = const ElementDef("CouplingVelocity", 0x00144057, "Coupling Velocity", VR.kDS, VM.k1, false);
  static const ElementDef kProbeCenterLocationX
      //(0014,4058)
      = const ElementDef(
          "ProbeCenterLocationX", 0x00144058, "Probe Center Location X", VR.kDS, VM.k1, false);
  static const ElementDef kProbeCenterLocationZ
      //(0014,4059)
      = const ElementDef(
          "ProbeCenterLocationZ", 0x00144059, "Probe Center Location Z", VR.kDS, VM.k1, false);
  static const ElementDef kSoundPathLength
      //(0014,405A)
      = const ElementDef("SoundPathLength", 0x0014405A, "Sound Path Length", VR.kDS, VM.k1, false);
  static const ElementDef kDelayLawIdentifier
      //(0014,405C)
      =
      const ElementDef("DelayLawIdentifier", 0x0014405C, "Delay Law Identifier", VR.kST, VM.k1, false);
  static const ElementDef kGateSettingsSequence
      //(0014,4060)
      = const ElementDef(
          "GateSettingsSequence", 0x00144060, "Gate Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGateThreshold
      //(0014,4062)
      = const ElementDef("GateThreshold", 0x00144062, "Gate Threshold", VR.kDS, VM.k1, false);
  static const ElementDef kVelocityOfSound
      //(0014,4064)
      = const ElementDef("VelocityOfSound", 0x00144064, "Velocity of Sound", VR.kDS, VM.k1, false);
  static const ElementDef kCalibrationSettingsSequence
      //(0014,4070)
      = const ElementDef("CalibrationSettingsSequence", 0x00144070, "Calibration Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCalibrationProcedure
      //(0014,4072)
      = const ElementDef(
          "CalibrationProcedure", 0x00144072, "Calibration Procedure", VR.kST, VM.k1, false);
  static const ElementDef kProcedureVersion
      //(0014,4074)
      = const ElementDef("ProcedureVersion", 0x00144074, "Procedure Version", VR.kSH, VM.k1, false);
  static const ElementDef kProcedureCreationDate
      //(0014,4076)
      = const ElementDef(
          "ProcedureCreationDate", 0x00144076, "Procedure Creation Date", VR.kDA, VM.k1, false);
  static const ElementDef kProcedureExpirationDate
      //(0014,4078)
      = const ElementDef(
          "ProcedureExpirationDate", 0x00144078, "Procedure Expiration Date", VR.kDA, VM.k1, false);
  static const ElementDef kProcedureLastModifiedDate
      //(0014,407A)
      = const ElementDef("ProcedureLastModifiedDate", 0x0014407A, "Procedure Last Modified Date",
          VR.kDA, VM.k1, false);
  static const ElementDef kCalibrationTime
      //(0014,407C)
      = const ElementDef("CalibrationTime", 0x0014407C, "Calibration Time", VR.kTM, VM.k1_n, false);
  static const ElementDef kCalibrationDate
      //(0014,407E)
      = const ElementDef("CalibrationDate", 0x0014407E, "Calibration Date", VR.kDA, VM.k1_n, false);
  static const ElementDef kProbeDriveEquipmentSequence
      //(0014,4080)
      = const ElementDef("ProbeDriveEquipmentSequence", 0x00144080, "Probe Drive Equipment Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kDriveType
      //(0014,4081)
      = const ElementDef("DriveType", 0x00144081, "Drive Type", VR.kCS, VM.k1, false);
  static const ElementDef kProbeDriveNotes
      //(0014,4082)
      = const ElementDef("ProbeDriveNotes", 0x00144082, "Probe Drive Notes", VR.kLT, VM.k1, false);
  static const ElementDef kDriveProbeSequence
      //(0014,4083)
      =
      const ElementDef("DriveProbeSequence", 0x00144083, "Drive Probe Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kProbeInductance
      //(0014,4084)
      = const ElementDef("ProbeInductance", 0x00144084, "Probe Inductance", VR.kDS, VM.k1, false);
  static const ElementDef kProbeResistance
      //(0014,4085)
      = const ElementDef("ProbeResistance", 0x00144085, "Probe Resistance", VR.kDS, VM.k1, false);
  static const ElementDef kReceiveProbeSequence
      //(0014,4086)
      = const ElementDef(
          "ReceiveProbeSequence", 0x00144086, "Receive Probe Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kProbeDriveSettingsSequence
      //(0014,4087)
      = const ElementDef("ProbeDriveSettingsSequence", 0x00144087, "Probe Drive Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kBridgeResistors
      //(0014,4088)
      = const ElementDef("BridgeResistors", 0x00144088, "Bridge Resistors", VR.kDS, VM.k1, false);
  static const ElementDef kProbeOrientationAngle
      //(0014,4089)
      = const ElementDef(
          "ProbeOrientationAngle", 0x00144089, "Probe Orientation Angle", VR.kDS, VM.k1, false);
  static const ElementDef kUserSelectedGainY
      //(0014,408B)
      =
      const ElementDef("UserSelectedGainY", 0x0014408B, "User Selected Gain Y", VR.kDS, VM.k1, false);
  static const ElementDef kUserSelectedPhase
      //(0014,408C)
      = const ElementDef("UserSelectedPhase", 0x0014408C, "User Selected Phase", VR.kDS, VM.k1, false);
  static const ElementDef kUserSelectedOffsetX
      //(0014,408D)
      = const ElementDef(
          "UserSelectedOffsetX", 0x0014408D, "User Selected Offset X", VR.kDS, VM.k1, false);
  static const ElementDef kUserSelectedOffsetY
      //(0014,408E)
      = const ElementDef(
          "UserSelectedOffsetY", 0x0014408E, "User Selected Offset Y", VR.kDS, VM.k1, false);
  static const ElementDef kChannelSettingsSequence
      //(0014,4091)
      = const ElementDef(
          "ChannelSettingsSequence", 0x00144091, "Channel Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelThreshold
      //(0014,4092)
      = const ElementDef("ChannelThreshold", 0x00144092, "Channel Threshold", VR.kDS, VM.k1, false);
  static const ElementDef kScannerSettingsSequence
      //(0014,409A)
      = const ElementDef(
          "ScannerSettingsSequence", 0x0014409A, "Scanner Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScanProcedure
      //(0014,409B)
      = const ElementDef("ScanProcedure", 0x0014409B, "Scan Procedure", VR.kST, VM.k1, false);
  static const ElementDef kTranslationRateX
      //(0014,409C)
      = const ElementDef("TranslationRateX", 0x0014409C, "Translation Rate X", VR.kDS, VM.k1, false);
  static const ElementDef kTranslationRateY
      //(0014,409D)
      = const ElementDef("TranslationRateY", 0x0014409D, "Translation Rate Y", VR.kDS, VM.k1, false);
  static const ElementDef kChannelOverlap
      //(0014,409F)
      = const ElementDef("ChannelOverlap", 0x0014409F, "Channel Overlap", VR.kDS, VM.k1, false);
  static const ElementDef kImageQualityIndicatorType
      //(0014,40A0)
      = const ElementDef("ImageQualityIndicatorType", 0x001440A0, "Image Quality Indicator Type",
          VR.kLO, VM.k1, false);
  static const ElementDef kImageQualityIndicatorMaterial
      //(0014,40A1)
      = const ElementDef("ImageQualityIndicatorMaterial", 0x001440A1,
          "Image Quality Indicator Material", VR.kLO, VM.k1, false);
  static const ElementDef kImageQualityIndicatorSize
      //(0014,40A2)
      = const ElementDef("ImageQualityIndicatorSize", 0x001440A2, "Image Quality Indicator Size",
          VR.kLO, VM.k1, false);
  static const ElementDef kLINACEnergy
      //(0014,5002)
      = const ElementDef("LINACEnergy", 0x00145002, "LINAC Energy", VR.kIS, VM.k1, false);
  static const ElementDef kLINACOutput
      //(0014,5004)
      = const ElementDef("LINACOutput", 0x00145004, "LINAC Output", VR.kIS, VM.k1, false);
  static const ElementDef kContrastBolusAgent
      //(0018,0010)
      =
      const ElementDef("ContrastBolusAgent", 0x00180010, "Contrast/Bolus Agent", VR.kLO, VM.k1, false);
  static const ElementDef kContrastBolusAgentSequence
      //(0018,0012)
      = const ElementDef("ContrastBolusAgentSequence", 0x00180012, "Contrast/Bolus Agent Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kContrastBolusAdministrationRouteSequence
      //(0018,0014)
      = const ElementDef("ContrastBolusAdministrationRouteSequence", 0x00180014,
          "Contrast/Bolus Administration Route Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBodyPartExamined
      //(0018,0015)
      = const ElementDef("BodyPartExamined", 0x00180015, "Body Part Examined", VR.kCS, VM.k1, false);
  static const ElementDef kScanningSequence
      //(0018,0020)
      = const ElementDef("ScanningSequence", 0x00180020, "Scanning Sequence", VR.kCS, VM.k1_n, false);
  static const ElementDef kSequenceVariant
      //(0018,0021)
      = const ElementDef("SequenceVariant", 0x00180021, "Sequence Variant", VR.kCS, VM.k1_n, false);
  static const ElementDef kScanOptions
      //(0018,0022)
      = const ElementDef("ScanOptions", 0x00180022, "Scan Options", VR.kCS, VM.k1_n, false);
  static const ElementDef kMRAcquisitionType
      //(0018,0023)
      = const ElementDef("MRAcquisitionType", 0x00180023, "MR Acquisition Type", VR.kCS, VM.k1, false);
  static const ElementDef kSequenceName
      //(0018,0024)
      = const ElementDef("SequenceName", 0x00180024, "Sequence Name", VR.kSH, VM.k1, false);
  static const ElementDef kAngioFlag
      //(0018,0025)
      = const ElementDef("AngioFlag", 0x00180025, "Angio Flag", VR.kCS, VM.k1, false);
  static const ElementDef kInterventionDrugInformationSequence
      //(0018,0026)
      = const ElementDef("InterventionDrugInformationSequence", 0x00180026,
          "Intervention Drug Information Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kInterventionDrugStopTime
      //(0018,0027)
      = const ElementDef("InterventionDrugStopTime", 0x00180027, "Intervention Drug Stop Time", VR.kTM,
          VM.k1, false);
  static const ElementDef kInterventionDrugDose
      //(0018,0028)
      = const ElementDef(
          "InterventionDrugDose", 0x00180028, "Intervention Drug Dose", VR.kDS, VM.k1, false);
  static const ElementDef kInterventionDrugCodeSequence
      //(0018,0029)
      = const ElementDef("InterventionDrugCodeSequence", 0x00180029, "Intervention Drug Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAdditionalDrugSequence
      //(0018,002A)
      = const ElementDef(
          "AdditionalDrugSequence", 0x0018002A, "Additional Drug Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRadionuclide
      //(0018,0030)
      = const ElementDef("Radionuclide", 0x00180030, "Radionuclide", VR.kLO, VM.k1_n, true);
  static const ElementDef kRadiopharmaceutical
      //(0018,0031)
      =
      const ElementDef("Radiopharmaceutical", 0x00180031, "Radiopharmaceutical", VR.kLO, VM.k1, false);
  static const ElementDef kEnergyWindowCenterline
      //(0018,0032)
      = const ElementDef(
          "EnergyWindowCenterline", 0x00180032, "Energy Window Centerline", VR.kDS, VM.k1, true);
  static const ElementDef kEnergyWindowTotalWidth
      //(0018,0033)
      = const ElementDef(
          "EnergyWindowTotalWidth", 0x00180033, "Energy Window Total Width", VR.kDS, VM.k1_n, true);
  static const ElementDef kInterventionDrugName
      //(0018,0034)
      = const ElementDef(
          "InterventionDrugName", 0x00180034, "Intervention Drug Name", VR.kLO, VM.k1, false);
  static const ElementDef kInterventionDrugStartTime
      //(0018,0035)
      = const ElementDef("InterventionDrugStartTime", 0x00180035, "Intervention Drug Start Time",
          VR.kTM, VM.k1, false);
  static const ElementDef kInterventionSequence
      //(0018,0036)
      = const ElementDef(
          "InterventionSequence", 0x00180036, "Intervention Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTherapyType
      //(0018,0037)
      = const ElementDef("TherapyType", 0x00180037, "Therapy Type", VR.kCS, VM.k1, true);
  static const ElementDef kInterventionStatus
      //(0018,0038)
      =
      const ElementDef("InterventionStatus", 0x00180038, "Intervention Status", VR.kCS, VM.k1, false);
  static const ElementDef kTherapyDescription
      //(0018,0039)
      = const ElementDef("TherapyDescription", 0x00180039, "Therapy Description", VR.kCS, VM.k1, true);
  static const ElementDef kInterventionDescription
      //(0018,003A)
      = const ElementDef(
          "InterventionDescription", 0x0018003A, "Intervention Description", VR.kST, VM.k1, false);
  static const ElementDef kCineRate
      //(0018,0040)
      = const ElementDef("CineRate", 0x00180040, "Cine Rate", VR.kIS, VM.k1, false);
  static const ElementDef kInitialCineRunState
      //(0018,0042)
      = const ElementDef(
          "InitialCineRunState", 0x00180042, "Initial Cine Run State", VR.kCS, VM.k1, false);
  static const ElementDef kSliceThickness
      //(0018,0050)
      = const ElementDef("SliceThickness", 0x00180050, "Slice Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kKVP
      //(0018,0060)
      = const ElementDef("KVP", 0x00180060, "KVP", VR.kDS, VM.k1, false);
  static const ElementDef kCountsAccumulated
      //(0018,0070)
      = const ElementDef("CountsAccumulated", 0x00180070, "Counts Accumulated", VR.kIS, VM.k1, false);
  static const ElementDef kAcquisitionTerminationCondition
      //(0018,0071)
      = const ElementDef("AcquisitionTerminationCondition", 0x00180071,
          "Acquisition Termination Condition", VR.kCS, VM.k1, false);
  static const ElementDef kEffectiveDuration
      //(0018,0072)
      = const ElementDef("EffectiveDuration", 0x00180072, "Effective Duration", VR.kDS, VM.k1, false);
  static const ElementDef kAcquisitionStartCondition
      //(0018,0073)
      = const ElementDef("AcquisitionStartCondition", 0x00180073, "Acquisition Start Condition",
          VR.kCS, VM.k1, false);
  static const ElementDef kAcquisitionStartConditionData
      //(0018,0074)
      = const ElementDef("AcquisitionStartConditionData", 0x00180074,
          "Acquisition Start Condition Data", VR.kIS, VM.k1, false);
  static const ElementDef kAcquisitionTerminationConditionData
      //(0018,0075)
      = const ElementDef("AcquisitionTerminationConditionData", 0x00180075,
          "Acquisition Termination Condition Data", VR.kIS, VM.k1, false);
  static const ElementDef kRepetitionTime
      //(0018,0080)
      = const ElementDef("RepetitionTime", 0x00180080, "Repetition Time", VR.kDS, VM.k1, false);
  static const ElementDef kEchoTime
      //(0018,0081)
      = const ElementDef("EchoTime", 0x00180081, "Echo Time", VR.kDS, VM.k1, false);
  static const ElementDef kInversionTime
      //(0018,0082)
      = const ElementDef("InversionTime", 0x00180082, "Inversion Time", VR.kDS, VM.k1, false);
  static const ElementDef kNumberOfAverages
      //(0018,0083)
      = const ElementDef("NumberOfAverages", 0x00180083, "Number of Averages", VR.kDS, VM.k1, false);
  static const ElementDef kImagingFrequency
      //(0018,0084)
      = const ElementDef("ImagingFrequency", 0x00180084, "Imaging Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kImagedNucleus
      //(0018,0085)
      = const ElementDef("ImagedNucleus", 0x00180085, "Imaged Nucleus", VR.kSH, VM.k1, false);
  static const ElementDef kEchoNumbers
      //(0018,0086)
      = const ElementDef("EchoNumbers", 0x00180086, "Echo Number(s)", VR.kIS, VM.k1_n, false);
  static const ElementDef kMagneticFieldStrength
      //(0018,0087)
      = const ElementDef(
          "MagneticFieldStrength", 0x00180087, "Magnetic Field Strength", VR.kDS, VM.k1, false);
  static const ElementDef kSpacingBetweenSlices
      //(0018,0088)
      = const ElementDef(
          "SpacingBetweenSlices", 0x00180088, "Spacing Between Slices", VR.kDS, VM.k1, false);
  static const ElementDef kNumberOfPhaseEncodingSteps
      //(0018,0089)
      = const ElementDef("NumberOfPhaseEncodingSteps", 0x00180089, "Number of Phase Encoding Steps",
          VR.kIS, VM.k1, false);
  static const ElementDef kDataCollectionDiameter
      //(0018,0090)
      = const ElementDef(
          "DataCollectionDiameter", 0x00180090, "Data Collection Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kEchoTrainLength
      //(0018,0091)
      = const ElementDef("EchoTrainLength", 0x00180091, "Echo Train Length", VR.kIS, VM.k1, false);
  static const ElementDef kPercentSampling
      //(0018,0093)
      = const ElementDef("PercentSampling", 0x00180093, "Percent Sampling", VR.kDS, VM.k1, false);
  static const ElementDef kPercentPhaseFieldOfView
      //(0018,0094)
      = const ElementDef("PercentPhaseFieldOfView", 0x00180094, "Percent Phase Field of View", VR.kDS,
          VM.k1, false);
  static const ElementDef kPixelBandwidth
      //(0018,0095)
      = const ElementDef("PixelBandwidth", 0x00180095, "Pixel Bandwidth", VR.kDS, VM.k1, false);
  static const ElementDef kDeviceSerialNumber
      //(0018,1000)
      =
      const ElementDef("DeviceSerialNumber", 0x00181000, "Device Serial Number", VR.kLO, VM.k1, false);
  static const ElementDef kDeviceUID
      //(0018,1002)
      = const ElementDef("DeviceUID", 0x00181002, "Device UID", VR.kUI, VM.k1, false);
  static const ElementDef kDeviceID
      //(0018,1003)
      = const ElementDef("DeviceID", 0x00181003, "Device ID", VR.kLO, VM.k1, false);
  static const ElementDef kPlateID
      //(0018,1004)
      = const ElementDef("PlateID", 0x00181004, "Plate ID", VR.kLO, VM.k1, false);
  static const ElementDef kGeneratorID
      //(0018,1005)
      = const ElementDef("GeneratorID", 0x00181005, "Generator ID", VR.kLO, VM.k1, false);
  static const ElementDef kGridID
      //(0018,1006)
      = const ElementDef("GridID", 0x00181006, "Grid ID", VR.kLO, VM.k1, false);
  static const ElementDef kCassetteID
      //(0018,1007)
      = const ElementDef("CassetteID", 0x00181007, "Cassette ID", VR.kLO, VM.k1, false);
  static const ElementDef kGantryID
      //(0018,1008)
      = const ElementDef("GantryID", 0x00181008, "Gantry ID", VR.kLO, VM.k1, false);
  static const ElementDef kSecondaryCaptureDeviceID
      //(0018,1010)
      = const ElementDef("SecondaryCaptureDeviceID", 0x00181010, "Secondary Capture Device ID", VR.kLO,
          VM.k1, false);
  static const ElementDef kHardcopyCreationDeviceID
      //(0018,1011)
      = const ElementDef("HardcopyCreationDeviceID", 0x00181011, "Hardcopy Creation Device ID", VR.kLO,
          VM.k1, true);
  static const ElementDef kDateOfSecondaryCapture
      //(0018,1012)
      = const ElementDef(
          "DateOfSecondaryCapture", 0x00181012, "Date of Secondary Capture", VR.kDA, VM.k1, false);
  static const ElementDef kTimeOfSecondaryCapture
      //(0018,1014)
      = const ElementDef(
          "TimeOfSecondaryCapture", 0x00181014, "Time of Secondary Capture", VR.kTM, VM.k1, false);
  static const ElementDef kSecondaryCaptureDeviceManufacturer
      //(0018,1016)
      = const ElementDef("SecondaryCaptureDeviceManufacturer", 0x00181016,
          "Secondary Capture Device Manufacturer", VR.kLO, VM.k1, false);
  static const ElementDef kHardcopyDeviceManufacturer
      //(0018,1017)
      = const ElementDef("HardcopyDeviceManufacturer", 0x00181017, "Hardcopy Device Manufacturer",
          VR.kLO, VM.k1, true);
  static const ElementDef kSecondaryCaptureDeviceManufacturerModelName
      //(0018,1018)
      = const ElementDef("SecondaryCaptureDeviceManufacturerModelName", 0x00181018,
          "Secondary Capture Device Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const ElementDef kSecondaryCaptureDeviceSoftwareVersions
      //(0018,1019)
      = const ElementDef("SecondaryCaptureDeviceSoftwareVersions", 0x00181019,
          "Secondary Capture Device Software Versions", VR.kLO, VM.k1_n, false);
  static const ElementDef kHardcopyDeviceSoftwareVersion
      //(0018,101A)
      = const ElementDef("HardcopyDeviceSoftwareVersion", 0x0018101A,
          "Hardcopy Device Software Version", VR.kLO, VM.k1_n, true);
  static const ElementDef kHardcopyDeviceManufacturerModelName
      //(0018,101B)
      = const ElementDef("HardcopyDeviceManufacturerModelName", 0x0018101B,
          "Hardcopy Device Manufacturer's Model Name", VR.kLO, VM.k1, true);
  static const ElementDef kSoftwareVersions
      //(0018,1020)
      =
      const ElementDef("SoftwareVersions", 0x00181020, "Software Version(s)", VR.kLO, VM.k1_n, false);
  static const ElementDef kVideoImageFormatAcquired
      //(0018,1022)
      = const ElementDef("VideoImageFormatAcquired", 0x00181022, "Video Image Format Acquired", VR.kSH,
          VM.k1, false);
  static const ElementDef kDigitalImageFormatAcquired
      //(0018,1023)
      = const ElementDef("DigitalImageFormatAcquired", 0x00181023, "Digital Image Format Acquired",
          VR.kLO, VM.k1, false);
  static const ElementDef kProtocolName
      //(0018,1030)
      = const ElementDef("ProtocolName", 0x00181030, "Protocol Name", VR.kLO, VM.k1, false);
  static const ElementDef kContrastBolusRoute
      //(0018,1040)
      =
      const ElementDef("ContrastBolusRoute", 0x00181040, "Contrast/Bolus Route", VR.kLO, VM.k1, false);
  static const ElementDef kContrastBolusVolume
      //(0018,1041)
      = const ElementDef(
          "ContrastBolusVolume", 0x00181041, "Contrast/Bolus Volume", VR.kDS, VM.k1, false);
  static const ElementDef kContrastBolusStartTime
      //(0018,1042)
      = const ElementDef(
          "ContrastBolusStartTime", 0x00181042, "Contrast/Bolus Start Time", VR.kTM, VM.k1, false);
  static const ElementDef kContrastBolusStopTime
      //(0018,1043)
      = const ElementDef(
          "ContrastBolusStopTime", 0x00181043, "Contrast/Bolus Stop Time", VR.kTM, VM.k1, false);
  static const ElementDef kContrastBolusTotalDose
      //(0018,1044)
      = const ElementDef(
          "ContrastBolusTotalDose", 0x00181044, "Contrast/Bolus Total Dose", VR.kDS, VM.k1, false);
  static const ElementDef kSyringeCounts
      //(0018,1045)
      = const ElementDef("SyringeCounts", 0x00181045, "Syringe Counts", VR.kIS, VM.k1, false);
  static const ElementDef kContrastFlowRate
      //(0018,1046)
      = const ElementDef("ContrastFlowRate", 0x00181046, "Contrast Flow Rate", VR.kDS, VM.k1_n, false);
  static const ElementDef kContrastFlowDuration
      //(0018,1047)
      = const ElementDef(
          "ContrastFlowDuration", 0x00181047, "Contrast Flow Duration", VR.kDS, VM.k1_n, false);
  static const ElementDef kContrastBolusIngredient
      //(0018,1048)
      = const ElementDef(
          "ContrastBolusIngredient", 0x00181048, "Contrast/Bolus Ingredient", VR.kCS, VM.k1, false);
  static const ElementDef kContrastBolusIngredientConcentration
      //(0018,1049)
      = const ElementDef("ContrastBolusIngredientConcentration", 0x00181049,
          "Contrast/Bolus Ingredient Concentration", VR.kDS, VM.k1, false);
  static const ElementDef kSpatialResolution
      //(0018,1050)
      = const ElementDef("SpatialResolution", 0x00181050, "Spatial Resolution", VR.kDS, VM.k1, false);
  static const ElementDef kTriggerTime
      //(0018,1060)
      = const ElementDef("TriggerTime", 0x00181060, "Trigger Time", VR.kDS, VM.k1, false);
  static const ElementDef kTriggerSourceOrType
      //(0018,1061)
      = const ElementDef(
          "TriggerSourceOrType", 0x00181061, "Trigger Source or Type", VR.kLO, VM.k1, false);
  static const ElementDef kNominalInterval
      //(0018,1062)
      = const ElementDef("NominalInterval", 0x00181062, "Nominal Interval", VR.kIS, VM.k1, false);
  static const ElementDef kFrameTime
      //(0018,1063)
      = const ElementDef("FrameTime", 0x00181063, "Frame Time", VR.kDS, VM.k1, false);
  static const ElementDef kCardiacFramingType
      //(0018,1064)
      =
      const ElementDef("CardiacFramingType", 0x00181064, "Cardiac Framing Type", VR.kLO, VM.k1, false);
  static const ElementDef kFrameTimeVector
      //(0018,1065)
      = const ElementDef("FrameTimeVector", 0x00181065, "Frame Time Vector", VR.kDS, VM.k1_n, false);
  static const ElementDef kFrameDelay
      //(0018,1066)
      = const ElementDef("FrameDelay", 0x00181066, "Frame Delay", VR.kDS, VM.k1, false);
  static const ElementDef kImageTriggerDelay
      //(0018,1067)
      = const ElementDef("ImageTriggerDelay", 0x00181067, "Image Trigger Delay", VR.kDS, VM.k1, false);
  static const ElementDef kMultiplexGroupTimeOffset
      //(0018,1068)
      = const ElementDef("MultiplexGroupTimeOffset", 0x00181068, "Multiplex Group Time Offset", VR.kDS,
          VM.k1, false);
  static const ElementDef kTriggerTimeOffset
      //(0018,1069)
      = const ElementDef("TriggerTimeOffset", 0x00181069, "Trigger Time Offset", VR.kDS, VM.k1, false);
  static const ElementDef kSynchronizationTrigger
      //(0018,106A)
      = const ElementDef(
          "SynchronizationTrigger", 0x0018106A, "Synchronization Trigger", VR.kCS, VM.k1, false);
  static const ElementDef kSynchronizationChannel
      //(0018,106C)
      = const ElementDef(
          "SynchronizationChannel", 0x0018106C, "Synchronization Channel", VR.kUS, VM.k2, false);
  static const ElementDef kTriggerSamplePosition
      //(0018,106E)
      = const ElementDef(
          "TriggerSamplePosition", 0x0018106E, "Trigger Sample Position", VR.kUL, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalRoute
      //(0018,1070)
      = const ElementDef("RadiopharmaceuticalRoute", 0x00181070, "Radiopharmaceutical Route", VR.kLO,
          VM.k1, false);
  static const ElementDef kRadiopharmaceuticalVolume
      //(0018,1071)
      = const ElementDef("RadiopharmaceuticalVolume", 0x00181071, "Radiopharmaceutical Volume", VR.kDS,
          VM.k1, false);
  static const ElementDef kRadiopharmaceuticalStartTime
      //(0018,1072)
      = const ElementDef("RadiopharmaceuticalStartTime", 0x00181072, "Radiopharmaceutical Start Time",
          VR.kTM, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalStopTime
      //(0018,1073)
      = const ElementDef("RadiopharmaceuticalStopTime", 0x00181073, "Radiopharmaceutical Stop Time",
          VR.kTM, VM.k1, false);
  static const ElementDef kRadionuclideTotalDose
      //(0018,1074)
      = const ElementDef(
          "RadionuclideTotalDose", 0x00181074, "Radionuclide Total Dose", VR.kDS, VM.k1, false);
  static const ElementDef kRadionuclideHalfLife
      //(0018,1075)
      = const ElementDef(
          "RadionuclideHalfLife", 0x00181075, "Radionuclide Half Life", VR.kDS, VM.k1, false);
  static const ElementDef kRadionuclidePositronFraction
      //(0018,1076)
      = const ElementDef("RadionuclidePositronFraction", 0x00181076, "Radionuclide Positron Fraction",
          VR.kDS, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalSpecificActivity
      //(0018,1077)
      = const ElementDef("RadiopharmaceuticalSpecificActivity", 0x00181077,
          "Radiopharmaceutical Specific Activity", VR.kDS, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalStartDateTime
      //(0018,1078)
      = const ElementDef("RadiopharmaceuticalStartDateTime", 0x00181078,
          "Radiopharmaceutical Start DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalStopDateTime
      //(0018,1079)
      = const ElementDef("RadiopharmaceuticalStopDateTime", 0x00181079,
          "Radiopharmaceutical Stop DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kBeatRejectionFlag
      //(0018,1080)
      = const ElementDef("BeatRejectionFlag", 0x00181080, "Beat Rejection Flag", VR.kCS, VM.k1, false);
  static const ElementDef kLowRRValue
      //(0018,1081)
      = const ElementDef("LowRRValue", 0x00181081, "Low R-R Value", VR.kIS, VM.k1, false);
  static const ElementDef kHighRRValue
      //(0018,1082)
      = const ElementDef("HighRRValue", 0x00181082, "High R-R Value", VR.kIS, VM.k1, false);
  static const ElementDef kIntervalsAcquired
      //(0018,1083)
      = const ElementDef("IntervalsAcquired", 0x00181083, "Intervals Acquired", VR.kIS, VM.k1, false);
  static const ElementDef kIntervalsRejected
      //(0018,1084)
      = const ElementDef("IntervalsRejected", 0x00181084, "Intervals Rejected", VR.kIS, VM.k1, false);
  static const ElementDef kPVCRejection
      //(0018,1085)
      = const ElementDef("PVCRejection", 0x00181085, "PVC Rejection", VR.kLO, VM.k1, false);
  static const ElementDef kSkipBeats
      //(0018,1086)
      = const ElementDef("SkipBeats", 0x00181086, "Skip Beats", VR.kIS, VM.k1, false);
  static const ElementDef kHeartRate
      //(0018,1088)
      = const ElementDef("HeartRate", 0x00181088, "Heart Rate", VR.kIS, VM.k1, false);
  static const ElementDef kCardiacNumberOfImages
      //(0018,1090)
      = const ElementDef(
          "CardiacNumberOfImages", 0x00181090, "Cardiac Number of Images", VR.kIS, VM.k1, false);
  static const ElementDef kTriggerWindow
      //(0018,1094)
      = const ElementDef("TriggerWindow", 0x00181094, "Trigger Window", VR.kIS, VM.k1, false);
  static const ElementDef kReconstructionDiameter
      //(0018,1100)
      = const ElementDef(
          "ReconstructionDiameter", 0x00181100, "Reconstruction Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kDistanceSourceToDetector
      //(0018,1110)
      = const ElementDef("DistanceSourceToDetector", 0x00181110, "Distance Source to Detector", VR.kDS,
          VM.k1, false);
  static const ElementDef kDistanceSourceToPatient
      //(0018,1111)
      = const ElementDef("DistanceSourceToPatient", 0x00181111, "Distance Source to Patient", VR.kDS,
          VM.k1, false);
  static const ElementDef kEstimatedRadiographicMagnificationFactor
      //(0018,1114)
      = const ElementDef("EstimatedRadiographicMagnificationFactor", 0x00181114,
          "Estimated Radiographic Magnification Factor", VR.kDS, VM.k1, false);
  static const ElementDef kGantryDetectorTilt
      //(0018,1120)
      =
      const ElementDef("GantryDetectorTilt", 0x00181120, "Gantry/Detector Tilt", VR.kDS, VM.k1, false);
  static const ElementDef kGantryDetectorSlew
      //(0018,1121)
      =
      const ElementDef("GantryDetectorSlew", 0x00181121, "Gantry/Detector Slew", VR.kDS, VM.k1, false);
  static const ElementDef kTableHeight
      //(0018,1130)
      = const ElementDef("TableHeight", 0x00181130, "Table Height", VR.kDS, VM.k1, false);
  static const ElementDef kTableTraverse
      //(0018,1131)
      = const ElementDef("TableTraverse", 0x00181131, "Table Traverse", VR.kDS, VM.k1, false);
  static const ElementDef kTableMotion
      //(0018,1134)
      = const ElementDef("TableMotion", 0x00181134, "Table Motion", VR.kCS, VM.k1, false);
  static const ElementDef kTableVerticalIncrement
      //(0018,1135)
      = const ElementDef(
          "TableVerticalIncrement", 0x00181135, "Table Vertical Increment", VR.kDS, VM.k1_n, false);
  static const ElementDef kTableLateralIncrement
      //(0018,1136)
      = const ElementDef(
          "TableLateralIncrement", 0x00181136, "Table Lateral Increment", VR.kDS, VM.k1_n, false);
  static const ElementDef kTableLongitudinalIncrement
      //(0018,1137)
      = const ElementDef("TableLongitudinalIncrement", 0x00181137, "Table Longitudinal Increment",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kTableAngle
      //(0018,1138)
      = const ElementDef("TableAngle", 0x00181138, "Table Angle", VR.kDS, VM.k1, false);
  static const ElementDef kTableType
      //(0018,113A)
      = const ElementDef("TableType", 0x0018113A, "Table Type", VR.kCS, VM.k1, false);
  static const ElementDef kRotationDirection
      //(0018,1140)
      = const ElementDef("RotationDirection", 0x00181140, "Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kAngularPosition
      //(0018,1141)
      = const ElementDef("AngularPosition", 0x00181141, "Angular Position", VR.kDS, VM.k1, true);
  static const ElementDef kRadialPosition
      //(0018,1142)
      = const ElementDef("RadialPosition", 0x00181142, "Radial Position", VR.kDS, VM.k1_n, false);
  static const ElementDef kScanArc
      //(0018,1143)
      = const ElementDef("ScanArc", 0x00181143, "Scan Arc", VR.kDS, VM.k1, false);
  static const ElementDef kAngularStep
      //(0018,1144)
      = const ElementDef("AngularStep", 0x00181144, "Angular Step", VR.kDS, VM.k1, false);
  static const ElementDef kCenterOfRotationOffset
      //(0018,1145)
      = const ElementDef(
          "CenterOfRotationOffset", 0x00181145, "Center of Rotation Offset", VR.kDS, VM.k1, false);
  static const ElementDef kRotationOffset
      //(0018,1146)
      = const ElementDef("RotationOffset", 0x00181146, "Rotation Offset", VR.kDS, VM.k1_n, true);
  static const ElementDef kFieldOfViewShape
      //(0018,1147)
      = const ElementDef("FieldOfViewShape", 0x00181147, "Field of View Shape", VR.kCS, VM.k1, false);
  static const ElementDef kFieldOfViewDimensions
      //(0018,1149)
      = const ElementDef("FieldOfViewDimensions", 0x00181149, "Field of View Dimension(s)", VR.kIS,
          VM.k1_2, false);
  static const ElementDef kExposureTime
      //(0018,1150)
      = const ElementDef("ExposureTime", 0x00181150, "Exposure Time", VR.kIS, VM.k1, false);
  static const ElementDef kXRayTubeCurrent
      //(0018,1151)
      = const ElementDef("XRayTubeCurrent", 0x00181151, "X-Ray Tube Current", VR.kIS, VM.k1, false);
  static const ElementDef kExposure
      //(0018,1152)
      = const ElementDef("Exposure", 0x00181152, "Exposure", VR.kIS, VM.k1, false);
  static const ElementDef kExposureInuAs
      //(0018,1153)
      = const ElementDef("ExposureInuAs", 0x00181153, "Exposure in µAs", VR.kIS, VM.k1, false);
  static const ElementDef kAveragePulseWidth
      //(0018,1154)
      = const ElementDef("AveragePulseWidth", 0x00181154, "Average Pulse Width", VR.kDS, VM.k1, false);
  static const ElementDef kRadiationSetting
      //(0018,1155)
      = const ElementDef("RadiationSetting", 0x00181155, "Radiation Setting", VR.kCS, VM.k1, false);
  static const ElementDef kRectificationType
      //(0018,1156)
      = const ElementDef("RectificationType", 0x00181156, "Rectification Type", VR.kCS, VM.k1, false);
  static const ElementDef kRadiationMode
      //(0018,115A)
      = const ElementDef("RadiationMode", 0x0018115A, "Radiation Mode", VR.kCS, VM.k1, false);
  static const ElementDef kImageAndFluoroscopyAreaDoseProduct
      //(0018,115E)
      = const ElementDef("ImageAndFluoroscopyAreaDoseProduct", 0x0018115E,
          "Image and Fluoroscopy Area Dose Product", VR.kDS, VM.k1, false);
  static const ElementDef kFilterType
      //(0018,1160)
      = const ElementDef("FilterType", 0x00181160, "Filter Type", VR.kSH, VM.k1, false);
  static const ElementDef kTypeOfFilters
      //(0018,1161)
      = const ElementDef("TypeOfFilters", 0x00181161, "Type of Filters", VR.kLO, VM.k1_n, false);
  static const ElementDef kIntensifierSize
      //(0018,1162)
      = const ElementDef("IntensifierSize", 0x00181162, "Intensifier Size", VR.kDS, VM.k1, false);
  static const ElementDef kImagerPixelSpacing
      //(0018,1164)
      =
      const ElementDef("ImagerPixelSpacing", 0x00181164, "Imager Pixel Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kGrid
      //(0018,1166)
      = const ElementDef("Grid", 0x00181166, "Grid", VR.kCS, VM.k1_n, false);
  static const ElementDef kGeneratorPower
      //(0018,1170)
      = const ElementDef("GeneratorPower", 0x00181170, "Generator Power", VR.kIS, VM.k1, false);
  static const ElementDef kCollimatorGridName
      //(0018,1180)
      =
      const ElementDef("CollimatorGridName", 0x00181180, "Collimator/grid Name", VR.kSH, VM.k1, false);
  static const ElementDef kCollimatorType
      //(0018,1181)
      = const ElementDef("CollimatorType", 0x00181181, "Collimator Type", VR.kCS, VM.k1, false);
  static const ElementDef kFocalDistance
      //(0018,1182)
      = const ElementDef("FocalDistance", 0x00181182, "Focal Distance", VR.kIS, VM.k1_2, false);
  static const ElementDef kXFocusCenter
      //(0018,1183)
      = const ElementDef("XFocusCenter", 0x00181183, "X Focus Center", VR.kDS, VM.k1_2, false);
  static const ElementDef kYFocusCenter
      //(0018,1184)
      = const ElementDef("YFocusCenter", 0x00181184, "Y Focus Center", VR.kDS, VM.k1_2, false);
  static const ElementDef kFocalSpots
      //(0018,1190)
      = const ElementDef("FocalSpots", 0x00181190, "Focal Spot(s)", VR.kDS, VM.k1_n, false);
  static const ElementDef kAnodeTargetMaterial
      //(0018,1191)
      = const ElementDef(
          "AnodeTargetMaterial", 0x00181191, "Anode Target Material", VR.kCS, VM.k1, false);
  static const ElementDef kBodyPartThickness
      //(0018,11A0)
      = const ElementDef("BodyPartThickness", 0x001811A0, "Body Part Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kCompressionForce
      //(0018,11A2)
      = const ElementDef("CompressionForce", 0x001811A2, "Compression Force", VR.kDS, VM.k1, false);
  static const ElementDef kPaddleDescription
      //(0018,11A4)
      = const ElementDef("PaddleDescription", 0x001811A4, "Paddle Description", VR.kLO, VM.k1, false);
  static const ElementDef kDateOfLastCalibration
      //(0018,1200)
      = const ElementDef(
          "DateOfLastCalibration", 0x00181200, "Date of Last Calibration", VR.kDA, VM.k1_n, false);
  static const ElementDef kTimeOfLastCalibration
      //(0018,1201)
      = const ElementDef(
          "TimeOfLastCalibration", 0x00181201, "Time of Last Calibration", VR.kTM, VM.k1_n, false);
  static const ElementDef kConvolutionKernel
      //(0018,1210)
      =
      const ElementDef("ConvolutionKernel", 0x00181210, "Convolution Kernel", VR.kSH, VM.k1_n, false);
  static const ElementDef kUpperLowerPixelValues
      //(0018,1240)
      = const ElementDef(
          "UpperLowerPixelValues", 0x00181240, "Upper/Lower Pixel Values", VR.kIS, VM.k1_n, true);
  static const ElementDef kActualFrameDuration
      //(0018,1242)
      = const ElementDef(
          "ActualFrameDuration", 0x00181242, "Actual Frame Duration", VR.kIS, VM.k1, false);
  static const ElementDef kCountRate
      //(0018,1243)
      = const ElementDef("CountRate", 0x00181243, "Count Rate", VR.kIS, VM.k1, false);
  static const ElementDef kPreferredPlaybackSequencing
      //(0018,1244)
      = const ElementDef("PreferredPlaybackSequencing", 0x00181244, "Preferred Playback Sequencing",
          VR.kUS, VM.k1, false);
  static const ElementDef kReceiveCoilName
      //(0018,1250)
      = const ElementDef("ReceiveCoilName", 0x00181250, "Receive Coil Name", VR.kSH, VM.k1, false);
  static const ElementDef kTransmitCoilName
      //(0018,1251)
      = const ElementDef("TransmitCoilName", 0x00181251, "Transmit Coil Name", VR.kSH, VM.k1, false);
  static const ElementDef kPlateType
      //(0018,1260)
      = const ElementDef("PlateType", 0x00181260, "Plate Type", VR.kSH, VM.k1, false);
  static const ElementDef kPhosphorType
      //(0018,1261)
      = const ElementDef("PhosphorType", 0x00181261, "Phosphor Type", VR.kLO, VM.k1, false);
  static const ElementDef kScanVelocity
      //(0018,1300)
      = const ElementDef("ScanVelocity", 0x00181300, "Scan Velocity", VR.kDS, VM.k1, false);
  static const ElementDef kWholeBodyTechnique
      //(0018,1301)
      = const ElementDef(
          "WholeBodyTechnique", 0x00181301, "Whole Body Technique", VR.kCS, VM.k1_n, false);
  static const ElementDef kScanLength
      //(0018,1302)
      = const ElementDef("ScanLength", 0x00181302, "Scan Length", VR.kIS, VM.k1, false);
  static const ElementDef kAcquisitionMatrix
      //(0018,1310)
      = const ElementDef("AcquisitionMatrix", 0x00181310, "Acquisition Matrix", VR.kUS, VM.k4, false);
  static const ElementDef kInPlanePhaseEncodingDirection
      //(0018,1312)
      = const ElementDef("InPlanePhaseEncodingDirection", 0x00181312,
          "In-plane Phase Encoding Direction", VR.kCS, VM.k1, false);
  static const ElementDef kFlipAngle
      //(0018,1314)
      = const ElementDef("FlipAngle", 0x00181314, "Flip Angle", VR.kDS, VM.k1, false);
  static const ElementDef kVariableFlipAngleFlag
      //(0018,1315)
      = const ElementDef(
          "VariableFlipAngleFlag", 0x00181315, "Variable Flip Angle Flag", VR.kCS, VM.k1, false);
  static const ElementDef kSAR
      //(0018,1316)
      = const ElementDef("SAR", 0x00181316, "SAR", VR.kDS, VM.k1, false);
  static const ElementDef kdBdt
      //(0018,1318)
      = const ElementDef("dBdt", 0x00181318, "dB/dt", VR.kDS, VM.k1, false);
  static const ElementDef kAcquisitionDeviceProcessingDescription
      //(0018,1400)
      = const ElementDef("AcquisitionDeviceProcessingDescription", 0x00181400,
          "Acquisition Device Processing Description", VR.kLO, VM.k1, false);
  static const ElementDef kAcquisitionDeviceProcessingCode
      //(0018,1401)
      = const ElementDef("AcquisitionDeviceProcessingCode", 0x00181401,
          "Acquisition Device Processing Code", VR.kLO, VM.k1, false);
  static const ElementDef kCassetteOrientation
      //(0018,1402)
      = const ElementDef(
          "CassetteOrientation", 0x00181402, "Cassette Orientation", VR.kCS, VM.k1, false);
  static const ElementDef kCassetteSize
      //(0018,1403)
      = const ElementDef("CassetteSize", 0x00181403, "Cassette Size", VR.kCS, VM.k1, false);
  static const ElementDef kExposuresOnPlate
      //(0018,1404)
      = const ElementDef("ExposuresOnPlate", 0x00181404, "Exposures on Plate", VR.kUS, VM.k1, false);
  static const ElementDef kRelativeXRayExposure
      //(0018,1405)
      = const ElementDef(
          "RelativeXRayExposure", 0x00181405, "Relative X-Ray Exposure", VR.kIS, VM.k1, false);
  static const ElementDef kExposureIndex
      //(0018,1411)
      = const ElementDef("ExposureIndex", 0x00181411, "Exposure Index", VR.kDS, VM.k1, false);
  static const ElementDef kTargetExposureIndex
      //(0018,1412)
      = const ElementDef(
          "TargetExposureIndex", 0x00181412, "Target Exposure Index", VR.kDS, VM.k1, false);
  static const ElementDef kDeviationIndex
      //(0018,1413)
      = const ElementDef("DeviationIndex", 0x00181413, "Deviation Index", VR.kDS, VM.k1, false);
  static const ElementDef kColumnAngulation
      //(0018,1450)
      = const ElementDef("ColumnAngulation", 0x00181450, "Column Angulation", VR.kDS, VM.k1, false);
  static const ElementDef kTomoLayerHeight
      //(0018,1460)
      = const ElementDef("TomoLayerHeight", 0x00181460, "Tomo Layer Height", VR.kDS, VM.k1, false);
  static const ElementDef kTomoAngle
      //(0018,1470)
      = const ElementDef("TomoAngle", 0x00181470, "Tomo Angle", VR.kDS, VM.k1, false);
  static const ElementDef kTomoTime
      //(0018,1480)
      = const ElementDef("TomoTime", 0x00181480, "Tomo Time", VR.kDS, VM.k1, false);
  static const ElementDef kTomoType
      //(0018,1490)
      = const ElementDef("TomoType", 0x00181490, "Tomo Type", VR.kCS, VM.k1, false);
  static const ElementDef kTomoClass
      //(0018,1491)
      = const ElementDef("TomoClass", 0x00181491, "Tomo Class", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfTomosynthesisSourceImages
      //(0018,1495)
      = const ElementDef("NumberOfTomosynthesisSourceImages", 0x00181495,
          "Number of Tomosynthesis Source Images", VR.kIS, VM.k1, false);
  static const ElementDef kPositionerMotion
      //(0018,1500)
      = const ElementDef("PositionerMotion", 0x00181500, "Positioner Motion", VR.kCS, VM.k1, false);
  static const ElementDef kPositionerType
      //(0018,1508)
      = const ElementDef("PositionerType", 0x00181508, "Positioner Type", VR.kCS, VM.k1, false);
  static const ElementDef kPositionerPrimaryAngle
      //(0018,1510)
      = const ElementDef(
          "PositionerPrimaryAngle", 0x00181510, "Positioner Primary Angle", VR.kDS, VM.k1, false);
  static const ElementDef kPositionerSecondaryAngle
      //(0018,1511)
      = const ElementDef("PositionerSecondaryAngle", 0x00181511, "Positioner Secondary Angle", VR.kDS,
          VM.k1, false);
  static const ElementDef kPositionerPrimaryAngleIncrement
      //(0018,1520)
      = const ElementDef("PositionerPrimaryAngleIncrement", 0x00181520,
          "Positioner Primary Angle Increment", VR.kDS, VM.k1_n, false);
  static const ElementDef kPositionerSecondaryAngleIncrement
      //(0018,1521)
      = const ElementDef("PositionerSecondaryAngleIncrement", 0x00181521,
          "Positioner Secondary Angle Increment", VR.kDS, VM.k1_n, false);
  static const ElementDef kDetectorPrimaryAngle
      //(0018,1530)
      = const ElementDef(
          "DetectorPrimaryAngle", 0x00181530, "Detector Primary Angle", VR.kDS, VM.k1, false);
  static const ElementDef kDetectorSecondaryAngle
      //(0018,1531)
      = const ElementDef(
          "DetectorSecondaryAngle", 0x00181531, "Detector Secondary Angle", VR.kDS, VM.k1, false);
  static const ElementDef kShutterShape
      //(0018,1600)
      = const ElementDef("ShutterShape", 0x00181600, "Shutter Shape", VR.kCS, VM.k1_3, false);
  static const ElementDef kShutterLeftVerticalEdge
      //(0018,1602)
      = const ElementDef("ShutterLeftVerticalEdge", 0x00181602, "Shutter Left Vertical Edge", VR.kIS,
          VM.k1, false);
  static const ElementDef kShutterRightVerticalEdge
      //(0018,1604)
      = const ElementDef("ShutterRightVerticalEdge", 0x00181604, "Shutter Right Vertical Edge", VR.kIS,
          VM.k1, false);
  static const ElementDef kShutterUpperHorizontalEdge
      //(0018,1606)
      = const ElementDef("ShutterUpperHorizontalEdge", 0x00181606, "Shutter Upper Horizontal Edge",
          VR.kIS, VM.k1, false);
  static const ElementDef kShutterLowerHorizontalEdge
      //(0018,1608)
      = const ElementDef("ShutterLowerHorizontalEdge", 0x00181608, "Shutter Lower Horizontal Edge",
          VR.kIS, VM.k1, false);
  static const ElementDef kCenterOfCircularShutter
      //(0018,1610)
      = const ElementDef("CenterOfCircularShutter", 0x00181610, "Center of Circular Shutter", VR.kIS,
          VM.k2, false);
  static const ElementDef kRadiusOfCircularShutter
      //(0018,1612)
      = const ElementDef("RadiusOfCircularShutter", 0x00181612, "Radius of Circular Shutter", VR.kIS,
          VM.k1, false);
  static const ElementDef kVerticesOfThePolygonalShutter
      //(0018,1620)
      = const ElementDef("VerticesOfThePolygonalShutter", 0x00181620,
          "Vertices of the Polygonal Shutter", VR.kIS, VM.k2_2n, false);
  static const ElementDef kShutterPresentationValue
      //(0018,1622)
      = const ElementDef("ShutterPresentationValue", 0x00181622, "Shutter Presentation Value", VR.kUS,
          VM.k1, false);
  static const ElementDef kShutterOverlayGroup
      //(0018,1623)
      = const ElementDef(
          "ShutterOverlayGroup", 0x00181623, "Shutter Overlay Group", VR.kUS, VM.k1, false);
  static const ElementDef kShutterPresentationColorCIELabValue
      //(0018,1624)
      = const ElementDef("ShutterPresentationColorCIELabValue", 0x00181624,
          "Shutter Presentation Color CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kCollimatorShape
      //(0018,1700)
      = const ElementDef("CollimatorShape", 0x00181700, "Collimator Shape", VR.kCS, VM.k1_3, false);
  static const ElementDef kCollimatorLeftVerticalEdge
      //(0018,1702)
      = const ElementDef("CollimatorLeftVerticalEdge", 0x00181702, "Collimator Left Vertical Edge",
          VR.kIS, VM.k1, false);
  static const ElementDef kCollimatorRightVerticalEdge
      //(0018,1704)
      = const ElementDef("CollimatorRightVerticalEdge", 0x00181704, "Collimator Right Vertical Edge",
          VR.kIS, VM.k1, false);
  static const ElementDef kCollimatorUpperHorizontalEdge
      //(0018,1706)
      = const ElementDef("CollimatorUpperHorizontalEdge", 0x00181706,
          "Collimator Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const ElementDef kCollimatorLowerHorizontalEdge
      //(0018,1708)
      = const ElementDef("CollimatorLowerHorizontalEdge", 0x00181708,
          "Collimator Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const ElementDef kCenterOfCircularCollimator
      //(0018,1710)
      = const ElementDef("CenterOfCircularCollimator", 0x00181710, "Center of Circular Collimator",
          VR.kIS, VM.k2, false);
  static const ElementDef kRadiusOfCircularCollimator
      //(0018,1712)
      = const ElementDef("RadiusOfCircularCollimator", 0x00181712, "Radius of Circular Collimator",
          VR.kIS, VM.k1, false);
  static const ElementDef kVerticesOfThePolygonalCollimator
      //(0018,1720)
      = const ElementDef("VerticesOfThePolygonalCollimator", 0x00181720,
          "Vertices of the Polygonal Collimator", VR.kIS, VM.k2_2n, false);
  static const ElementDef kAcquisitionTimeSynchronized
      //(0018,1800)
      = const ElementDef("AcquisitionTimeSynchronized", 0x00181800, "Acquisition Time Synchronized",
          VR.kCS, VM.k1, false);
  static const ElementDef kTimeSource
      //(0018,1801)
      = const ElementDef("TimeSource", 0x00181801, "Time Source", VR.kSH, VM.k1, false);
  static const ElementDef kTimeDistributionProtocol
      //(0018,1802)
      = const ElementDef("TimeDistributionProtocol", 0x00181802, "Time Distribution Protocol", VR.kCS,
          VM.k1, false);
  static const ElementDef kNTPSourceAddress
      //(0018,1803)
      = const ElementDef("NTPSourceAddress", 0x00181803, "NTP Source Address", VR.kLO, VM.k1, false);
  static const ElementDef kPageNumberVector
      //(0018,2001)
      = const ElementDef("PageNumberVector", 0x00182001, "Page Number Vector", VR.kIS, VM.k1_n, false);
  static const ElementDef kFrameLabelVector
      //(0018,2002)
      = const ElementDef("FrameLabelVector", 0x00182002, "Frame Label Vector", VR.kSH, VM.k1_n, false);
  static const ElementDef kFramePrimaryAngleVector
      //(0018,2003)
      = const ElementDef("FramePrimaryAngleVector", 0x00182003, "Frame Primary Angle Vector", VR.kDS,
          VM.k1_n, false);
  static const ElementDef kFrameSecondaryAngleVector
      //(0018,2004)
      = const ElementDef("FrameSecondaryAngleVector", 0x00182004, "Frame Secondary Angle Vector",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kSliceLocationVector
      //(0018,2005)
      = const ElementDef(
          "SliceLocationVector", 0x00182005, "Slice Location Vector", VR.kDS, VM.k1_n, false);
  static const ElementDef kDisplayWindowLabelVector
      //(0018,2006)
      = const ElementDef("DisplayWindowLabelVector", 0x00182006, "Display Window Label Vector", VR.kSH,
          VM.k1_n, false);
  static const ElementDef kNominalScannedPixelSpacing
      //(0018,2010)
      = const ElementDef("NominalScannedPixelSpacing", 0x00182010, "Nominal Scanned Pixel Spacing",
          VR.kDS, VM.k2, false);
  static const ElementDef kDigitizingDeviceTransportDirection
      //(0018,2020)
      = const ElementDef("DigitizingDeviceTransportDirection", 0x00182020,
          "Digitizing Device Transport Direction", VR.kCS, VM.k1, false);
  static const ElementDef kRotationOfScannedFilm
      //(0018,2030)
      = const ElementDef(
          "RotationOfScannedFilm", 0x00182030, "Rotation of Scanned Film", VR.kDS, VM.k1, false);
  static const ElementDef kBiopsyTargetSequence
      //(0018,2041)
      = const ElementDef(
          "BiopsyTargetSequence", 0x00182041, "Biopsy Target Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTargetUID
      //(0018,2042)
      = const ElementDef("TargetUID", 0x00182042, "Target UID", VR.kUI, VM.k1, false);
  static const ElementDef kLocalizingCursorPosition
      //(0018,2043)
      = const ElementDef("LocalizingCursorPosition", 0x00182043, "Localizing Cursor Position", VR.kFL,
          VM.k2, false);
  static const ElementDef kCalculatedTargetPosition
      //(0018,2044)
      = const ElementDef("CalculatedTargetPosition", 0x00182044, "Calculated Target Position", VR.kFL,
          VM.k3, false);
  static const ElementDef kTargetLabel
      //(0018,2045)
      = const ElementDef("TargetLabel", 0x00182045, "Target Label", VR.kSH, VM.k1, false);
  static const ElementDef kDisplayedZValue
      //(0018,2046)
      = const ElementDef("DisplayedZValue", 0x00182046, "Displayed Z Value", VR.kFL, VM.k1, false);
  static const ElementDef kIVUSAcquisition
      //(0018,3100)
      = const ElementDef("IVUSAcquisition", 0x00183100, "IVUS Acquisition", VR.kCS, VM.k1, false);
  static const ElementDef kIVUSPullbackRate
      //(0018,3101)
      = const ElementDef("IVUSPullbackRate", 0x00183101, "IVUS Pullback Rate", VR.kDS, VM.k1, false);
  static const ElementDef kIVUSGatedRate
      //(0018,3102)
      = const ElementDef("IVUSGatedRate", 0x00183102, "IVUS Gated Rate", VR.kDS, VM.k1, false);
  static const ElementDef kIVUSPullbackStartFrameNumber
      //(0018,3103)
      = const ElementDef("IVUSPullbackStartFrameNumber", 0x00183103,
          "IVUS Pullback Start Frame Number", VR.kIS, VM.k1, false);
  static const ElementDef kIVUSPullbackStopFrameNumber
      //(0018,3104)
      = const ElementDef("IVUSPullbackStopFrameNumber", 0x00183104, "IVUS Pullback Stop Frame Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kLesionNumber
      //(0018,3105)
      = const ElementDef("LesionNumber", 0x00183105, "Lesion Number", VR.kIS, VM.k1_n, false);
  static const ElementDef kAcquisitionComments
      //(0018,4000)
      =
      const ElementDef("AcquisitionComments", 0x00184000, "Acquisition Comments", VR.kLT, VM.k1, true);
  static const ElementDef kOutputPower
      //(0018,5000)
      = const ElementDef("OutputPower", 0x00185000, "Output Power", VR.kSH, VM.k1_n, false);
  static const ElementDef kTransducerData
      //(0018,5010)
      = const ElementDef("TransducerData", 0x00185010, "Transducer Data", VR.kLO, VM.k1_n, false);
  static const ElementDef kFocusDepth
      //(0018,5012)
      = const ElementDef("FocusDepth", 0x00185012, "Focus Depth", VR.kDS, VM.k1, false);
  static const ElementDef kProcessingFunction
      //(0018,5020)
      =
      const ElementDef("ProcessingFunction", 0x00185020, "Processing Function", VR.kLO, VM.k1, false);
  static const ElementDef kPostprocessingFunction
      //(0018,5021)
      = const ElementDef(
          "PostprocessingFunction", 0x00185021, "Postprocessing Function", VR.kLO, VM.k1, true);
  static const ElementDef kMechanicalIndex
      //(0018,5022)
      = const ElementDef("MechanicalIndex", 0x00185022, "Mechanical Index", VR.kDS, VM.k1, false);
  static const ElementDef kBoneThermalIndex
      //(0018,5024)
      = const ElementDef("BoneThermalIndex", 0x00185024, "Bone Thermal Index", VR.kDS, VM.k1, false);
  static const ElementDef kCranialThermalIndex
      //(0018,5026)
      = const ElementDef(
          "CranialThermalIndex", 0x00185026, "Cranial Thermal Index", VR.kDS, VM.k1, false);
  static const ElementDef kSoftTissueThermalIndex
      //(0018,5027)
      = const ElementDef(
          "SoftTissueThermalIndex", 0x00185027, "Soft Tissue Thermal Index", VR.kDS, VM.k1, false);
  static const ElementDef kSoftTissueFocusThermalIndex
      //(0018,5028)
      = const ElementDef("SoftTissueFocusThermalIndex", 0x00185028, "Soft Tissue-focus Thermal Index",
          VR.kDS, VM.k1, false);
  static const ElementDef kSoftTissueSurfaceThermalIndex
      //(0018,5029)
      = const ElementDef("SoftTissueSurfaceThermalIndex", 0x00185029,
          "Soft Tissue-surface Thermal Index", VR.kDS, VM.k1, false);
  static const ElementDef kDynamicRange
      //(0018,5030)
      = const ElementDef("DynamicRange", 0x00185030, "Dynamic Range", VR.kDS, VM.k1, true);
  static const ElementDef kTotalGain
      //(0018,5040)
      = const ElementDef("TotalGain", 0x00185040, "Total Gain", VR.kDS, VM.k1, true);
  static const ElementDef kDepthOfScanField
      //(0018,5050)
      = const ElementDef("DepthOfScanField", 0x00185050, "Depth of Scan Field", VR.kIS, VM.k1, false);
  static const ElementDef kPatientPosition
      //(0018,5100)
      = const ElementDef("PatientPosition", 0x00185100, "Patient Position", VR.kCS, VM.k1, false);
  static const ElementDef kViewPosition
      //(0018,5101)
      = const ElementDef("ViewPosition", 0x00185101, "View Position", VR.kCS, VM.k1, false);
  static const ElementDef kProjectionEponymousNameCodeSequence
      //(0018,5104)
      = const ElementDef("ProjectionEponymousNameCodeSequence", 0x00185104,
          "Projection Eponymous Name Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImageTransformationMatrix
      //(0018,5210)
      = const ElementDef("ImageTransformationMatrix", 0x00185210, "Image Transformation Matrix",
          VR.kDS, VM.k6, true);
  static const ElementDef kImageTranslationVector
      //(0018,5212)
      = const ElementDef(
          "ImageTranslationVector", 0x00185212, "Image Translation Vector", VR.kDS, VM.k3, true);
  static const ElementDef kSensitivity
      //(0018,6000)
      = const ElementDef("Sensitivity", 0x00186000, "Sensitivity", VR.kDS, VM.k1, false);
  static const ElementDef kSequenceOfUltrasoundRegions
      //(0018,6011)
      = const ElementDef("SequenceOfUltrasoundRegions", 0x00186011, "Sequence of Ultrasound Regions",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRegionSpatialFormat
      //(0018,6012)
      = const ElementDef(
          "RegionSpatialFormat", 0x00186012, "Region Spatial Format", VR.kUS, VM.k1, false);
  static const ElementDef kRegionDataType
      //(0018,6014)
      = const ElementDef("RegionDataType", 0x00186014, "Region Data Type", VR.kUS, VM.k1, false);
  static const ElementDef kRegionFlags
      //(0018,6016)
      = const ElementDef("RegionFlags", 0x00186016, "Region Flags", VR.kUL, VM.k1, false);
  static const ElementDef kRegionLocationMinX0
      //(0018,6018)
      = const ElementDef(
          "RegionLocationMinX0", 0x00186018, "Region Location Min X0", VR.kUL, VM.k1, false);
  static const ElementDef kRegionLocationMinY0
      //(0018,601A)
      = const ElementDef(
          "RegionLocationMinY0", 0x0018601A, "Region Location Min Y0", VR.kUL, VM.k1, false);
  static const ElementDef kRegionLocationMaxX1
      //(0018,601C)
      = const ElementDef(
          "RegionLocationMaxX1", 0x0018601C, "Region Location Max X1", VR.kUL, VM.k1, false);
  static const ElementDef kRegionLocationMaxY1
      //(0018,601E)
      = const ElementDef(
          "RegionLocationMaxY1", 0x0018601E, "Region Location Max Y1", VR.kUL, VM.k1, false);
  static const ElementDef kReferencePixelX0
      //(0018,6020)
      = const ElementDef("ReferencePixelX0", 0x00186020, "Reference Pixel X0", VR.kSL, VM.k1, false);
  static const ElementDef kReferencePixelY0
      //(0018,6022)
      = const ElementDef("ReferencePixelY0", 0x00186022, "Reference Pixel Y0", VR.kSL, VM.k1, false);
  static const ElementDef kPhysicalUnitsXDirection
      //(0018,6024)
      = const ElementDef("PhysicalUnitsXDirection", 0x00186024, "Physical Units X Direction", VR.kUS,
          VM.k1, false);
  static const ElementDef kPhysicalUnitsYDirection
      //(0018,6026)
      = const ElementDef("PhysicalUnitsYDirection", 0x00186026, "Physical Units Y Direction", VR.kUS,
          VM.k1, false);
  static const ElementDef kReferencePixelPhysicalValueX
      //(0018,6028)
      = const ElementDef("ReferencePixelPhysicalValueX", 0x00186028,
          "Reference Pixel Physical Value X", VR.kFD, VM.k1, false);
  static const ElementDef kReferencePixelPhysicalValueY
      //(0018,602A)
      = const ElementDef("ReferencePixelPhysicalValueY", 0x0018602A,
          "Reference Pixel Physical Value Y", VR.kFD, VM.k1, false);
  static const ElementDef kPhysicalDeltaX
      //(0018,602C)
      = const ElementDef("PhysicalDeltaX", 0x0018602C, "Physical Delta X", VR.kFD, VM.k1, false);
  static const ElementDef kPhysicalDeltaY
      //(0018,602E)
      = const ElementDef("PhysicalDeltaY", 0x0018602E, "Physical Delta Y", VR.kFD, VM.k1, false);
  static const ElementDef kTransducerFrequency
      //(0018,6030)
      = const ElementDef(
          "TransducerFrequency", 0x00186030, "Transducer Frequency", VR.kUL, VM.k1, false);
  static const ElementDef kTransducerType
      //(0018,6031)
      = const ElementDef("TransducerType", 0x00186031, "Transducer Type", VR.kCS, VM.k1, false);
  static const ElementDef kPulseRepetitionFrequency
      //(0018,6032)
      = const ElementDef("PulseRepetitionFrequency", 0x00186032, "Pulse Repetition Frequency", VR.kUL,
          VM.k1, false);
  static const ElementDef kDopplerCorrectionAngle
      //(0018,6034)
      = const ElementDef(
          "DopplerCorrectionAngle", 0x00186034, "Doppler Correction Angle", VR.kFD, VM.k1, false);
  static const ElementDef kSteeringAngle
      //(0018,6036)
      = const ElementDef("SteeringAngle", 0x00186036, "Steering Angle", VR.kFD, VM.k1, false);
  static const ElementDef kDopplerSampleVolumeXPositionRetired
      //(0018,6038)
      = const ElementDef("DopplerSampleVolumeXPositionRetired", 0x00186038,
          "Doppler Sample Volume X Position (Retired)", VR.kUL, VM.k1, true);
  static const ElementDef kDopplerSampleVolumeXPosition
      //(0018,6039)
      = const ElementDef("DopplerSampleVolumeXPosition", 0x00186039,
          "Doppler Sample Volume X Position", VR.kSL, VM.k1, false);
  static const ElementDef kDopplerSampleVolumeYPositionRetired
      //(0018,603A)
      = const ElementDef("DopplerSampleVolumeYPositionRetired", 0x0018603A,
          "Doppler Sample Volume Y Position (Retired)", VR.kUL, VM.k1, true);
  static const ElementDef kDopplerSampleVolumeYPosition
      //(0018,603B)
      = const ElementDef("DopplerSampleVolumeYPosition", 0x0018603B,
          "Doppler Sample Volume Y Position", VR.kSL, VM.k1, false);
  static const ElementDef kTMLinePositionX0Retired
      //(0018,603C)
      = const ElementDef("TMLinePositionX0Retired", 0x0018603C, "TM-Line Position X0 (Retired)",
          VR.kUL, VM.k1, true);
  static const ElementDef kTMLinePositionX0
      //(0018,603D)
      = const ElementDef("TMLinePositionX0", 0x0018603D, "TM-Line Position X0", VR.kSL, VM.k1, false);
  static const ElementDef kTMLinePositionY0Retired
      //(0018,603E)
      = const ElementDef("TMLinePositionY0Retired", 0x0018603E, "TM-Line Position Y0 (Retired)",
          VR.kUL, VM.k1, true);
  static const ElementDef kTMLinePositionY0
      //(0018,603F)
      = const ElementDef("TMLinePositionY0", 0x0018603F, "TM-Line Position Y0", VR.kSL, VM.k1, false);
  static const ElementDef kTMLinePositionX1Retired
      //(0018,6040)
      = const ElementDef("TMLinePositionX1Retired", 0x00186040, "TM-Line Position X1 (Retired)",
          VR.kUL, VM.k1, true);
  static const ElementDef kTMLinePositionX1
      //(0018,6041)
      = const ElementDef("TMLinePositionX1", 0x00186041, "TM-Line Position X1", VR.kSL, VM.k1, false);
  static const ElementDef kTMLinePositionY1Retired
      //(0018,6042)
      = const ElementDef("TMLinePositionY1Retired", 0x00186042, "TM-Line Position Y1 (Retired)",
          VR.kUL, VM.k1, true);
  static const ElementDef kTMLinePositionY1
      //(0018,6043)
      = const ElementDef("TMLinePositionY1", 0x00186043, "TM-Line Position Y1", VR.kSL, VM.k1, false);
  static const ElementDef kPixelComponentOrganization
      //(0018,6044)
      = const ElementDef("PixelComponentOrganization", 0x00186044, "Pixel Component Organization",
          VR.kUS, VM.k1, false);
  static const ElementDef kPixelComponentMask
      //(0018,6046)
      =
      const ElementDef("PixelComponentMask", 0x00186046, "Pixel Component Mask", VR.kUL, VM.k1, false);
  static const ElementDef kPixelComponentRangeStart
      //(0018,6048)
      = const ElementDef("PixelComponentRangeStart", 0x00186048, "Pixel Component Range Start", VR.kUL,
          VM.k1, false);
  static const ElementDef kPixelComponentRangeStop
      //(0018,604A)
      = const ElementDef("PixelComponentRangeStop", 0x0018604A, "Pixel Component Range Stop", VR.kUL,
          VM.k1, false);
  static const ElementDef kPixelComponentPhysicalUnits
      //(0018,604C)
      = const ElementDef("PixelComponentPhysicalUnits", 0x0018604C, "Pixel Component Physical Units",
          VR.kUS, VM.k1, false);
  static const ElementDef kPixelComponentDataType
      //(0018,604E)
      = const ElementDef(
          "PixelComponentDataType", 0x0018604E, "Pixel Component Data Type", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfTableBreakPoints
      //(0018,6050)
      = const ElementDef("NumberOfTableBreakPoints", 0x00186050, "Number of Table Break Points",
          VR.kUL, VM.k1, false);
  static const ElementDef kTableOfXBreakPoints
      //(0018,6052)
      = const ElementDef(
          "TableOfXBreakPoints", 0x00186052, "Table of X Break Points", VR.kUL, VM.k1_n, false);
  static const ElementDef kTableOfYBreakPoints
      //(0018,6054)
      = const ElementDef(
          "TableOfYBreakPoints", 0x00186054, "Table of Y Break Points", VR.kFD, VM.k1_n, false);
  static const ElementDef kNumberOfTableEntries
      //(0018,6056)
      = const ElementDef(
          "NumberOfTableEntries", 0x00186056, "Number of Table Entries", VR.kUL, VM.k1, false);
  static const ElementDef kTableOfPixelValues
      //(0018,6058)
      = const ElementDef(
          "TableOfPixelValues", 0x00186058, "Table of Pixel Values", VR.kUL, VM.k1_n, false);
  static const ElementDef kTableOfParameterValues
      //(0018,605A)
      = const ElementDef("TableOfParameterValues", 0x0018605A, "Table of Parameter Values", VR.kFL,
          VM.k1_n, false);
  static const ElementDef kRWaveTimeVector
      //(0018,6060)
      = const ElementDef("RWaveTimeVector", 0x00186060, "R Wave Time Vector", VR.kFL, VM.k1_n, false);
  static const ElementDef kDetectorConditionsNominalFlag
      //(0018,7000)
      = const ElementDef("DetectorConditionsNominalFlag", 0x00187000,
          "Detector Conditions Nominal Flag", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorTemperature
      //(0018,7001)
      = const ElementDef(
          "DetectorTemperature", 0x00187001, "Detector Temperature", VR.kDS, VM.k1, false);
  static const ElementDef kDetectorType
      //(0018,7004)
      = const ElementDef("DetectorType", 0x00187004, "Detector Type", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorConfiguration
      //(0018,7005)
      = const ElementDef(
          "DetectorConfiguration", 0x00187005, "Detector Configuration", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorDescription
      //(0018,7006)
      = const ElementDef(
          "DetectorDescription", 0x00187006, "Detector Description", VR.kLT, VM.k1, false);
  static const ElementDef kDetectorMode
      //(0018,7008)
      = const ElementDef("DetectorMode", 0x00187008, "Detector Mode", VR.kLT, VM.k1, false);
  static const ElementDef kDetectorID
      //(0018,700A)
      = const ElementDef("DetectorID", 0x0018700A, "Detector ID", VR.kSH, VM.k1, false);
  static const ElementDef kDateOfLastDetectorCalibration
      //(0018,700C)
      = const ElementDef("DateOfLastDetectorCalibration", 0x0018700C,
          "Date of Last Detector Calibration", VR.kDA, VM.k1, false);
  static const ElementDef kTimeOfLastDetectorCalibration
      //(0018,700E)
      = const ElementDef("TimeOfLastDetectorCalibration", 0x0018700E,
          "Time of Last Detector Calibration", VR.kTM, VM.k1, false);
  static const ElementDef kExposuresOnDetectorSinceLastCalibration
      //(0018,7010)
      = const ElementDef("ExposuresOnDetectorSinceLastCalibration", 0x00187010,
          "Exposures on Detector Since Last Calibration", VR.kIS, VM.k1, false);
  static const ElementDef kExposuresOnDetectorSinceManufactured
      //(0018,7011)
      = const ElementDef("ExposuresOnDetectorSinceManufactured", 0x00187011,
          "Exposures on Detector Since Manufactured", VR.kIS, VM.k1, false);
  static const ElementDef kDetectorTimeSinceLastExposure
      //(0018,7012)
      = const ElementDef("DetectorTimeSinceLastExposure", 0x00187012,
          "Detector Time Since Last Exposure", VR.kDS, VM.k1, false);
  static const ElementDef kDetectorActiveTime
      //(0018,7014)
      =
      const ElementDef("DetectorActiveTime", 0x00187014, "Detector Active Time", VR.kDS, VM.k1, false);
  static const ElementDef kDetectorActivationOffsetFromExposure
      //(0018,7016)
      = const ElementDef("DetectorActivationOffsetFromExposure", 0x00187016,
          "Detector Activation Offset From Exposure", VR.kDS, VM.k1, false);
  static const ElementDef kDetectorBinning
      //(0018,701A)
      = const ElementDef("DetectorBinning", 0x0018701A, "Detector Binning", VR.kDS, VM.k2, false);
  static const ElementDef kDetectorElementPhysicalSize
      //(0018,7020)
      = const ElementDef("DetectorElementPhysicalSize", 0x00187020, "Detector Element Physical Size",
          VR.kDS, VM.k2, false);
  static const ElementDef kDetectorElementSpacing
      //(0018,7022)
      = const ElementDef(
          "DetectorElementSpacing", 0x00187022, "Detector Element Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kDetectorActiveShape
      //(0018,7024)
      = const ElementDef(
          "DetectorActiveShape", 0x00187024, "Detector Active Shape", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorActiveDimensions
      //(0018,7026)
      = const ElementDef("DetectorActiveDimensions", 0x00187026, "Detector Active Dimension(s)",
          VR.kDS, VM.k1_2, false);
  static const ElementDef kDetectorActiveOrigin
      //(0018,7028)
      = const ElementDef(
          "DetectorActiveOrigin", 0x00187028, "Detector Active Origin", VR.kDS, VM.k2, false);
  static const ElementDef kDetectorManufacturerName
      //(0018,702A)
      = const ElementDef("DetectorManufacturerName", 0x0018702A, "Detector Manufacturer Name", VR.kLO,
          VM.k1, false);
  static const ElementDef kDetectorManufacturerModelName
      //(0018,702B)
      = const ElementDef("DetectorManufacturerModelName", 0x0018702B,
          "Detector Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const ElementDef kFieldOfViewOrigin
      //(0018,7030)
      =
      const ElementDef("FieldOfViewOrigin", 0x00187030, "Field of View Origin", VR.kDS, VM.k2, false);
  static const ElementDef kFieldOfViewRotation
      //(0018,7032)
      = const ElementDef(
          "FieldOfViewRotation", 0x00187032, "Field of View Rotation", VR.kDS, VM.k1, false);
  static const ElementDef kFieldOfViewHorizontalFlip
      //(0018,7034)
      = const ElementDef("FieldOfViewHorizontalFlip", 0x00187034, "Field of View Horizontal Flip",
          VR.kCS, VM.k1, false);
  static const ElementDef kPixelDataAreaOriginRelativeToFOV
      //(0018,7036)
      = const ElementDef("PixelDataAreaOriginRelativeToFOV", 0x00187036,
          "Pixel Data Area Origin Relative To FOV", VR.kFL, VM.k2, false);
  static const ElementDef kPixelDataAreaRotationAngleRelativeToFOV
      //(0018,7038)
      = const ElementDef("PixelDataAreaRotationAngleRelativeToFOV", 0x00187038,
          "Pixel Data Area Rotation Angle Relative To FOV", VR.kFL, VM.k1, false);
  static const ElementDef kGridAbsorbingMaterial
      //(0018,7040)
      = const ElementDef(
          "GridAbsorbingMaterial", 0x00187040, "Grid Absorbing Material", VR.kLT, VM.k1, false);
  static const ElementDef kGridSpacingMaterial
      //(0018,7041)
      = const ElementDef(
          "GridSpacingMaterial", 0x00187041, "Grid Spacing Material", VR.kLT, VM.k1, false);
  static const ElementDef kGridThickness
      //(0018,7042)
      = const ElementDef("GridThickness", 0x00187042, "Grid Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kGridPitch
      //(0018,7044)
      = const ElementDef("GridPitch", 0x00187044, "Grid Pitch", VR.kDS, VM.k1, false);
  static const ElementDef kGridAspectRatio
      //(0018,7046)
      = const ElementDef("GridAspectRatio", 0x00187046, "Grid Aspect Ratio", VR.kIS, VM.k2, false);
  static const ElementDef kGridPeriod
      //(0018,7048)
      = const ElementDef("GridPeriod", 0x00187048, "Grid Period", VR.kDS, VM.k1, false);
  static const ElementDef kGridFocalDistance
      //(0018,704C)
      = const ElementDef("GridFocalDistance", 0x0018704C, "Grid Focal Distance", VR.kDS, VM.k1, false);
  static const ElementDef kFilterMaterial
      //(0018,7050)
      = const ElementDef("FilterMaterial", 0x00187050, "Filter Material", VR.kCS, VM.k1_n, false);
  static const ElementDef kFilterThicknessMinimum
      //(0018,7052)
      = const ElementDef(
          "FilterThicknessMinimum", 0x00187052, "Filter Thickness Minimum", VR.kDS, VM.k1_n, false);
  static const ElementDef kFilterThicknessMaximum
      //(0018,7054)
      = const ElementDef(
          "FilterThicknessMaximum", 0x00187054, "Filter Thickness Maximum", VR.kDS, VM.k1_n, false);
  static const ElementDef kFilterBeamPathLengthMinimum
      //(0018,7056)
      = const ElementDef("FilterBeamPathLengthMinimum", 0x00187056, "Filter Beam Path Length Minimum",
          VR.kFL, VM.k1_n, false);
  static const ElementDef kFilterBeamPathLengthMaximum
      //(0018,7058)
      = const ElementDef("FilterBeamPathLengthMaximum", 0x00187058, "Filter Beam Path Length Maximum",
          VR.kFL, VM.k1_n, false);
  static const ElementDef kExposureControlMode
      //(0018,7060)
      = const ElementDef(
          "ExposureControlMode", 0x00187060, "Exposure Control Mode", VR.kCS, VM.k1, false);
  static const ElementDef kExposureControlModeDescription
      //(0018,7062)
      = const ElementDef("ExposureControlModeDescription", 0x00187062,
          "Exposure Control Mode Description", VR.kLT, VM.k1, false);
  static const ElementDef kExposureStatus
      //(0018,7064)
      = const ElementDef("ExposureStatus", 0x00187064, "Exposure Status", VR.kCS, VM.k1, false);
  static const ElementDef kPhototimerSetting
      //(0018,7065)
      = const ElementDef("PhototimerSetting", 0x00187065, "Phototimer Setting", VR.kDS, VM.k1, false);
  static const ElementDef kExposureTimeInuS
      //(0018,8150)
      = const ElementDef("ExposureTimeInuS", 0x00188150, "Exposure Time in µS", VR.kDS, VM.k1, false);
  static const ElementDef kXRayTubeCurrentInuA
      //(0018,8151)
      = const ElementDef(
          "XRayTubeCurrentInuA", 0x00188151, "X-Ray Tube Current in µA", VR.kDS, VM.k1, false);
  static const ElementDef kContentQualification
      //(0018,9004)
      = const ElementDef(
          "ContentQualification", 0x00189004, "Content Qualification", VR.kCS, VM.k1, false);
  static const ElementDef kPulseSequenceName
      //(0018,9005)
      = const ElementDef("PulseSequenceName", 0x00189005, "Pulse Sequence Name", VR.kSH, VM.k1, false);
  static const ElementDef kMRImagingModifierSequence
      //(0018,9006)
      = const ElementDef("MRImagingModifierSequence", 0x00189006, "MR Imaging Modifier Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kEchoPulseSequence
      //(0018,9008)
      = const ElementDef("EchoPulseSequence", 0x00189008, "Echo Pulse Sequence", VR.kCS, VM.k1, false);
  static const ElementDef kInversionRecovery
      //(0018,9009)
      = const ElementDef("InversionRecovery", 0x00189009, "Inversion Recovery", VR.kCS, VM.k1, false);
  static const ElementDef kFlowCompensation
      //(0018,9010)
      = const ElementDef("FlowCompensation", 0x00189010, "Flow Compensation", VR.kCS, VM.k1, false);
  static const ElementDef kMultipleSpinEcho
      //(0018,9011)
      = const ElementDef("MultipleSpinEcho", 0x00189011, "Multiple Spin Echo", VR.kCS, VM.k1, false);
  static const ElementDef kMultiPlanarExcitation
      //(0018,9012)
      = const ElementDef(
          "MultiPlanarExcitation", 0x00189012, "Multi-planar Excitation", VR.kCS, VM.k1, false);
  static const ElementDef kPhaseContrast
      //(0018,9014)
      = const ElementDef("PhaseContrast", 0x00189014, "Phase Contrast", VR.kCS, VM.k1, false);
  static const ElementDef kTimeOfFlightContrast
      //(0018,9015)
      = const ElementDef(
          "TimeOfFlightContrast", 0x00189015, "Time of Flight Contrast", VR.kCS, VM.k1, false);
  static const ElementDef kSpoiling
      //(0018,9016)
      = const ElementDef("Spoiling", 0x00189016, "Spoiling", VR.kCS, VM.k1, false);
  static const ElementDef kSteadyStatePulseSequence
      //(0018,9017)
      = const ElementDef("SteadyStatePulseSequence", 0x00189017, "Steady State Pulse Sequence", VR.kCS,
          VM.k1, false);
  static const ElementDef kEchoPlanarPulseSequence
      //(0018,9018)
      = const ElementDef("EchoPlanarPulseSequence", 0x00189018, "Echo Planar Pulse Sequence", VR.kCS,
          VM.k1, false);
  static const ElementDef kTagAngleFirstAxis
      //(0018,9019)
      = const ElementDef(
          "TagAngleFirstAxis", 0x00189019, "Tag Angle First Axis", VR.kFD, VM.k1, false);
  static const ElementDef kMagnetizationTransfer
      //(0018,9020)
      = const ElementDef(
          "MagnetizationTransfer", 0x00189020, "Magnetization Transfer", VR.kCS, VM.k1, false);
  static const ElementDef kT2Preparation
      //(0018,9021)
      = const ElementDef("T2Preparation", 0x00189021, "T2 Preparation", VR.kCS, VM.k1, false);
  static const ElementDef kBloodSignalNulling
      //(0018,9022)
      =
      const ElementDef("BloodSignalNulling", 0x00189022, "Blood Signal Nulling", VR.kCS, VM.k1, false);
  static const ElementDef kSaturationRecovery
      //(0018,9024)
      =
      const ElementDef("SaturationRecovery", 0x00189024, "Saturation Recovery", VR.kCS, VM.k1, false);
  static const ElementDef kSpectrallySelectedSuppression
      //(0018,9025)
      = const ElementDef("SpectrallySelectedSuppression", 0x00189025,
          "Spectrally Selected Suppression", VR.kCS, VM.k1, false);
  static const ElementDef kSpectrallySelectedExcitation
      //(0018,9026)
      = const ElementDef("SpectrallySelectedExcitation", 0x00189026, "Spectrally Selected Excitation",
          VR.kCS, VM.k1, false);
  static const ElementDef kSpatialPresaturation
      //(0018,9027)
      = const ElementDef(
          "SpatialPresaturation", 0x00189027, "Spatial Pre-saturation", VR.kCS, VM.k1, false);
  static const ElementDef kTagging
      //(0018,9028)
      = const ElementDef("Tagging", 0x00189028, "Tagging", VR.kCS, VM.k1, false);
  static const ElementDef kOversamplingPhase
      //(0018,9029)
      = const ElementDef("OversamplingPhase", 0x00189029, "Oversampling Phase", VR.kCS, VM.k1, false);
  static const ElementDef kTagSpacingFirstDimension
      //(0018,9030)
      = const ElementDef("TagSpacingFirstDimension", 0x00189030, "Tag Spacing First Dimension",
          VR.kFD, VM.k1, false);
  static const ElementDef kGeometryOfKSpaceTraversal
      //(0018,9032)
      = const ElementDef("GeometryOfKSpaceTraversal", 0x00189032, "Geometry of k-Space Traversal",
          VR.kCS, VM.k1, false);
  static const ElementDef kSegmentedKSpaceTraversal
      //(0018,9033)
      = const ElementDef("SegmentedKSpaceTraversal", 0x00189033, "Segmented k-Space Traversal", VR.kCS,
          VM.k1, false);
  static const ElementDef kRectilinearPhaseEncodeReordering
      //(0018,9034)
      = const ElementDef("RectilinearPhaseEncodeReordering", 0x00189034,
          "Rectilinear Phase Encode Reordering", VR.kCS, VM.k1, false);
  static const ElementDef kTagThickness
      //(0018,9035)
      = const ElementDef("TagThickness", 0x00189035, "Tag Thickness", VR.kFD, VM.k1, false);
  static const ElementDef kPartialFourierDirection
      //(0018,9036)
      = const ElementDef(
          "PartialFourierDirection", 0x00189036, "Partial Fourier Direction", VR.kCS, VM.k1, false);
  static const ElementDef kCardiacSynchronizationTechnique
      //(0018,9037)
      = const ElementDef("CardiacSynchronizationTechnique", 0x00189037,
          "Cardiac Synchronization Technique", VR.kCS, VM.k1, false);
  static const ElementDef kReceiveCoilManufacturerName
      //(0018,9041)
      = const ElementDef("ReceiveCoilManufacturerName", 0x00189041, "Receive Coil Manufacturer Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kMRReceiveCoilSequence
      //(0018,9042)
      = const ElementDef(
          "MRReceiveCoilSequence", 0x00189042, "MR Receive Coil Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReceiveCoilType
      //(0018,9043)
      = const ElementDef("ReceiveCoilType", 0x00189043, "Receive Coil Type", VR.kCS, VM.k1, false);
  static const ElementDef kQuadratureReceiveCoil
      //(0018,9044)
      = const ElementDef(
          "QuadratureReceiveCoil", 0x00189044, "Quadrature Receive Coil", VR.kCS, VM.k1, false);
  static const ElementDef kMultiCoilDefinitionSequence
      //(0018,9045)
      = const ElementDef("MultiCoilDefinitionSequence", 0x00189045, "Multi-Coil Definition Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMultiCoilConfiguration
      //(0018,9046)
      = const ElementDef(
          "MultiCoilConfiguration", 0x00189046, "Multi-Coil Configuration", VR.kLO, VM.k1, false);
  static const ElementDef kMultiCoilElementName
      //(0018,9047)
      = const ElementDef(
          "MultiCoilElementName", 0x00189047, "Multi-Coil Element Name", VR.kSH, VM.k1, false);
  static const ElementDef kMultiCoilElementUsed
      //(0018,9048)
      = const ElementDef(
          "MultiCoilElementUsed", 0x00189048, "Multi-Coil Element Used", VR.kCS, VM.k1, false);
  static const ElementDef kMRTransmitCoilSequence
      //(0018,9049)
      = const ElementDef(
          "MRTransmitCoilSequence", 0x00189049, "MR Transmit Coil Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTransmitCoilManufacturerName
      //(0018,9050)
      = const ElementDef("TransmitCoilManufacturerName", 0x00189050, "Transmit Coil Manufacturer Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kTransmitCoilType
      //(0018,9051)
      = const ElementDef("TransmitCoilType", 0x00189051, "Transmit Coil Type", VR.kCS, VM.k1, false);
  static const ElementDef kSpectralWidth
      //(0018,9052)
      = const ElementDef("SpectralWidth", 0x00189052, "Spectral Width", VR.kFD, VM.k1_2, false);
  static const ElementDef kChemicalShiftReference
      //(0018,9053)
      = const ElementDef(
          "ChemicalShiftReference", 0x00189053, "Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const ElementDef kVolumeLocalizationTechnique
      //(0018,9054)
      = const ElementDef("VolumeLocalizationTechnique", 0x00189054, "Volume Localization Technique",
          VR.kCS, VM.k1, false);
  static const ElementDef kMRAcquisitionFrequencyEncodingSteps
      //(0018,9058)
      = const ElementDef("MRAcquisitionFrequencyEncodingSteps", 0x00189058,
          "MR Acquisition Frequency Encoding Steps", VR.kUS, VM.k1, false);
  static const ElementDef kDecoupling
      //(0018,9059)
      = const ElementDef("Decoupling", 0x00189059, "De-coupling", VR.kCS, VM.k1, false);
  static const ElementDef kDecoupledNucleus
      //(0018,9060)
      = const ElementDef("DecoupledNucleus", 0x00189060, "De-coupled Nucleus", VR.kCS, VM.k1_2, false);
  static const ElementDef kDecouplingFrequency
      //(0018,9061)
      = const ElementDef(
          "DecouplingFrequency", 0x00189061, "De-coupling Frequency", VR.kFD, VM.k1_2, false);
  static const ElementDef kDecouplingMethod
      //(0018,9062)
      = const ElementDef("DecouplingMethod", 0x00189062, "De-coupling Method", VR.kCS, VM.k1, false);
  static const ElementDef kDecouplingChemicalShiftReference
      //(0018,9063)
      = const ElementDef("DecouplingChemicalShiftReference", 0x00189063,
          "De-coupling Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const ElementDef kKSpaceFiltering
      //(0018,9064)
      = const ElementDef("KSpaceFiltering", 0x00189064, "k-space Filtering", VR.kCS, VM.k1, false);
  static const ElementDef kTimeDomainFiltering
      //(0018,9065)
      = const ElementDef(
          "TimeDomainFiltering", 0x00189065, "Time Domain Filtering", VR.kCS, VM.k1_2, false);
  static const ElementDef kNumberOfZeroFills
      //(0018,9066)
      = const ElementDef(
          "NumberOfZeroFills", 0x00189066, "Number of Zero Fills", VR.kUS, VM.k1_2, false);
  static const ElementDef kBaselineCorrection
      //(0018,9067)
      =
      const ElementDef("BaselineCorrection", 0x00189067, "Baseline Correction", VR.kCS, VM.k1, false);
  static const ElementDef kParallelReductionFactorInPlane
      //(0018,9069)
      = const ElementDef("ParallelReductionFactorInPlane", 0x00189069,
          "Parallel Reduction Factor In-plane", VR.kFD, VM.k1, false);
  static const ElementDef kCardiacRRIntervalSpecified
      //(0018,9070)
      = const ElementDef("CardiacRRIntervalSpecified", 0x00189070, "Cardiac R-R Interval Specified",
          VR.kFD, VM.k1, false);
  static const ElementDef kAcquisitionDuration
      //(0018,9073)
      = const ElementDef(
          "AcquisitionDuration", 0x00189073, "Acquisition Duration", VR.kFD, VM.k1, false);
  static const ElementDef kFrameAcquisitionDateTime
      //(0018,9074)
      = const ElementDef("FrameAcquisitionDateTime", 0x00189074, "Frame Acquisition DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kDiffusionDirectionality
      //(0018,9075)
      = const ElementDef(
          "DiffusionDirectionality", 0x00189075, "Diffusion Directionality", VR.kCS, VM.k1, false);
  static const ElementDef kDiffusionGradientDirectionSequence
      //(0018,9076)
      = const ElementDef("DiffusionGradientDirectionSequence", 0x00189076,
          "Diffusion Gradient Direction Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kParallelAcquisition
      //(0018,9077)
      = const ElementDef(
          "ParallelAcquisition", 0x00189077, "Parallel Acquisition", VR.kCS, VM.k1, false);
  static const ElementDef kParallelAcquisitionTechnique
      //(0018,9078)
      = const ElementDef("ParallelAcquisitionTechnique", 0x00189078, "Parallel Acquisition Technique",
          VR.kCS, VM.k1, false);
  static const ElementDef kInversionTimes
      //(0018,9079)
      = const ElementDef("InversionTimes", 0x00189079, "Inversion Times", VR.kFD, VM.k1_n, false);
  static const ElementDef kMetaboliteMapDescription
      //(0018,9080)
      = const ElementDef("MetaboliteMapDescription", 0x00189080, "Metabolite Map Description", VR.kST,
          VM.k1, false);
  static const ElementDef kPartialFourier
      //(0018,9081)
      = const ElementDef("PartialFourier", 0x00189081, "Partial Fourier", VR.kCS, VM.k1, false);
  static const ElementDef kEffectiveEchoTime
      //(0018,9082)
      = const ElementDef("EffectiveEchoTime", 0x00189082, "Effective Echo Time", VR.kFD, VM.k1, false);
  static const ElementDef kMetaboliteMapCodeSequence
      //(0018,9083)
      = const ElementDef("MetaboliteMapCodeSequence", 0x00189083, "Metabolite Map Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kChemicalShiftSequence
      //(0018,9084)
      = const ElementDef(
          "ChemicalShiftSequence", 0x00189084, "Chemical Shift Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCardiacSignalSource
      //(0018,9085)
      = const ElementDef(
          "CardiacSignalSource", 0x00189085, "Cardiac Signal Source", VR.kCS, VM.k1, false);
  static const ElementDef kDiffusionBValue
      //(0018,9087)
      = const ElementDef("DiffusionBValue", 0x00189087, "Diffusion b-value", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionGradientOrientation
      //(0018,9089)
      = const ElementDef("DiffusionGradientOrientation", 0x00189089, "Diffusion Gradient Orientation",
          VR.kFD, VM.k3, false);
  static const ElementDef kVelocityEncodingDirection
      //(0018,9090)
      = const ElementDef("VelocityEncodingDirection", 0x00189090, "Velocity Encoding Direction",
          VR.kFD, VM.k3, false);
  static const ElementDef kVelocityEncodingMinimumValue
      //(0018,9091)
      = const ElementDef("VelocityEncodingMinimumValue", 0x00189091, "Velocity Encoding Minimum Value",
          VR.kFD, VM.k1, false);
  static const ElementDef kVelocityEncodingAcquisitionSequence
      //(0018,9092)
      = const ElementDef("VelocityEncodingAcquisitionSequence", 0x00189092,
          "Velocity Encoding Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfKSpaceTrajectories
      //(0018,9093)
      = const ElementDef("NumberOfKSpaceTrajectories", 0x00189093, "Number of k-Space Trajectories",
          VR.kUS, VM.k1, false);
  static const ElementDef kCoverageOfKSpace
      //(0018,9094)
      = const ElementDef("CoverageOfKSpace", 0x00189094, "Coverage of k-Space", VR.kCS, VM.k1, false);
  static const ElementDef kSpectroscopyAcquisitionPhaseRows
      //(0018,9095)
      = const ElementDef("SpectroscopyAcquisitionPhaseRows", 0x00189095,
          "Spectroscopy Acquisition Phase Rows", VR.kUL, VM.k1, false);
  static const ElementDef kParallelReductionFactorInPlaneRetired
      //(0018,9096)
      = const ElementDef("ParallelReductionFactorInPlaneRetired", 0x00189096,
          "Parallel Reduction Factor In-plane (Retired)", VR.kFD, VM.k1, true);
  static const ElementDef kTransmitterFrequency
      //(0018,9098)
      = const ElementDef(
          "TransmitterFrequency", 0x00189098, "Transmitter Frequency", VR.kFD, VM.k1_2, false);
  static const ElementDef kResonantNucleus
      //(0018,9100)
      = const ElementDef("ResonantNucleus", 0x00189100, "Resonant Nucleus", VR.kCS, VM.k1_2, false);
  static const ElementDef kFrequencyCorrection
      //(0018,9101)
      = const ElementDef(
          "FrequencyCorrection", 0x00189101, "Frequency Correction", VR.kCS, VM.k1, false);
  static const ElementDef kMRSpectroscopyFOVGeometrySequence
      //(0018,9103)
      = const ElementDef("MRSpectroscopyFOVGeometrySequence", 0x00189103,
          "MR Spectroscopy FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSlabThickness
      //(0018,9104)
      = const ElementDef("SlabThickness", 0x00189104, "Slab Thickness", VR.kFD, VM.k1, false);
  static const ElementDef kSlabOrientation
      //(0018,9105)
      = const ElementDef("SlabOrientation", 0x00189105, "Slab Orientation", VR.kFD, VM.k3, false);
  static const ElementDef kMidSlabPosition
      //(0018,9106)
      = const ElementDef("MidSlabPosition", 0x00189106, "Mid Slab Position", VR.kFD, VM.k3, false);
  static const ElementDef kMRSpatialSaturationSequence
      //(0018,9107)
      = const ElementDef("MRSpatialSaturationSequence", 0x00189107, "MR Spatial Saturation Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMRTimingAndRelatedParametersSequence
      //(0018,9112)
      = const ElementDef("MRTimingAndRelatedParametersSequence", 0x00189112,
          "MR Timing and Related Parameters Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMREchoSequence
      //(0018,9114)
      = const ElementDef("MREchoSequence", 0x00189114, "MR Echo Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMRModifierSequence
      //(0018,9115)
      =
      const ElementDef("MRModifierSequence", 0x00189115, "MR Modifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMRDiffusionSequence
      //(0018,9117)
      = const ElementDef(
          "MRDiffusionSequence", 0x00189117, "MR Diffusion Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCardiacSynchronizationSequence
      //(0018,9118)
      = const ElementDef("CardiacSynchronizationSequence", 0x00189118,
          "Cardiac Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMRAveragesSequence
      //(0018,9119)
      =
      const ElementDef("MRAveragesSequence", 0x00189119, "MR Averages Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMRFOVGeometrySequence
      //(0018,9125)
      = const ElementDef(
          "MRFOVGeometrySequence", 0x00189125, "MR FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVolumeLocalizationSequence
      //(0018,9126)
      = const ElementDef("VolumeLocalizationSequence", 0x00189126, "Volume Localization Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSpectroscopyAcquisitionDataColumns
      //(0018,9127)
      = const ElementDef("SpectroscopyAcquisitionDataColumns", 0x00189127,
          "Spectroscopy Acquisition Data Columns", VR.kUL, VM.k1, false);
  static const ElementDef kDiffusionAnisotropyType
      //(0018,9147)
      = const ElementDef(
          "DiffusionAnisotropyType", 0x00189147, "Diffusion Anisotropy Type", VR.kCS, VM.k1, false);
  static const ElementDef kFrameReferenceDateTime
      //(0018,9151)
      = const ElementDef(
          "FrameReferenceDateTime", 0x00189151, "Frame Reference DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kMRMetaboliteMapSequence
      //(0018,9152)
      = const ElementDef("MRMetaboliteMapSequence", 0x00189152, "MR Metabolite Map Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kParallelReductionFactorOutOfPlane
      //(0018,9155)
      = const ElementDef("ParallelReductionFactorOutOfPlane", 0x00189155,
          "Parallel Reduction Factor out-of-plane", VR.kFD, VM.k1, false);
  static const ElementDef kSpectroscopyAcquisitionOutOfPlanePhaseSteps
      //(0018,9159)
      = const ElementDef("SpectroscopyAcquisitionOutOfPlanePhaseSteps", 0x00189159,
          "Spectroscopy Acquisition Out-of-plane Phase Steps", VR.kUL, VM.k1, false);
  static const ElementDef kBulkMotionStatus
      //(0018,9166)
      = const ElementDef("BulkMotionStatus", 0x00189166, "Bulk Motion Status", VR.kCS, VM.k1, true);
  static const ElementDef kParallelReductionFactorSecondInPlane
      //(0018,9168)
      = const ElementDef("ParallelReductionFactorSecondInPlane", 0x00189168,
          "Parallel Reduction Factor Second In-plane", VR.kFD, VM.k1, false);
  static const ElementDef kCardiacBeatRejectionTechnique
      //(0018,9169)
      = const ElementDef("CardiacBeatRejectionTechnique", 0x00189169,
          "Cardiac Beat Rejection Technique", VR.kCS, VM.k1, false);
  static const ElementDef kRespiratoryMotionCompensationTechnique
      //(0018,9170)
      = const ElementDef("RespiratoryMotionCompensationTechnique", 0x00189170,
          "Respiratory Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const ElementDef kRespiratorySignalSource
      //(0018,9171)
      = const ElementDef(
          "RespiratorySignalSource", 0x00189171, "Respiratory Signal Source", VR.kCS, VM.k1, false);
  static const ElementDef kBulkMotionCompensationTechnique
      //(0018,9172)
      = const ElementDef("BulkMotionCompensationTechnique", 0x00189172,
          "Bulk Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const ElementDef kBulkMotionSignalSource
      //(0018,9173)
      = const ElementDef(
          "BulkMotionSignalSource", 0x00189173, "Bulk Motion Signal Source", VR.kCS, VM.k1, false);
  static const ElementDef kApplicableSafetyStandardAgency
      //(0018,9174)
      = const ElementDef("ApplicableSafetyStandardAgency", 0x00189174,
          "Applicable Safety Standard Agency", VR.kCS, VM.k1, false);
  static const ElementDef kApplicableSafetyStandardDescription
      //(0018,9175)
      = const ElementDef("ApplicableSafetyStandardDescription", 0x00189175,
          "Applicable Safety Standard Description", VR.kLO, VM.k1, false);
  static const ElementDef kOperatingModeSequence
      //(0018,9176)
      = const ElementDef(
          "OperatingModeSequence", 0x00189176, "Operating Mode Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOperatingModeType
      //(0018,9177)
      = const ElementDef("OperatingModeType", 0x00189177, "Operating Mode Type", VR.kCS, VM.k1, false);
  static const ElementDef kOperatingMode
      //(0018,9178)
      = const ElementDef("OperatingMode", 0x00189178, "Operating Mode", VR.kCS, VM.k1, false);
  static const ElementDef kSpecificAbsorptionRateDefinition
      //(0018,9179)
      = const ElementDef("SpecificAbsorptionRateDefinition", 0x00189179,
          "Specific Absorption Rate Definition", VR.kCS, VM.k1, false);
  static const ElementDef kGradientOutputType
      //(0018,9180)
      =
      const ElementDef("GradientOutputType", 0x00189180, "Gradient Output Type", VR.kCS, VM.k1, false);
  static const ElementDef kSpecificAbsorptionRateValue
      //(0018,9181)
      = const ElementDef("SpecificAbsorptionRateValue", 0x00189181, "Specific Absorption Rate Value",
          VR.kFD, VM.k1, false);
  static const ElementDef kGradientOutput
      //(0018,9182)
      = const ElementDef("GradientOutput", 0x00189182, "Gradient Output", VR.kFD, VM.k1, false);
  static const ElementDef kFlowCompensationDirection
      //(0018,9183)
      = const ElementDef("FlowCompensationDirection", 0x00189183, "Flow Compensation Direction",
          VR.kCS, VM.k1, false);
  static const ElementDef kTaggingDelay
      //(0018,9184)
      = const ElementDef("TaggingDelay", 0x00189184, "Tagging Delay", VR.kFD, VM.k1, false);
  static const ElementDef kRespiratoryMotionCompensationTechniqueDescription
      //(0018,9185)
      = const ElementDef("RespiratoryMotionCompensationTechniqueDescription", 0x00189185,
          "Respiratory Motion Compensation Technique Description", VR.kST, VM.k1, false);
  static const ElementDef kRespiratorySignalSourceID
      //(0018,9186)
      = const ElementDef("RespiratorySignalSourceID", 0x00189186, "Respiratory Signal Source ID",
          VR.kSH, VM.k1, false);
  static const ElementDef kChemicalShiftMinimumIntegrationLimitInHz
      //(0018,9195)
      = const ElementDef("ChemicalShiftMinimumIntegrationLimitInHz", 0x00189195,
          "Chemical Shift Minimum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const ElementDef kChemicalShiftMaximumIntegrationLimitInHz
      //(0018,9196)
      = const ElementDef("ChemicalShiftMaximumIntegrationLimitInHz", 0x00189196,
          "Chemical Shift Maximum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const ElementDef kMRVelocityEncodingSequence
      //(0018,9197)
      = const ElementDef("MRVelocityEncodingSequence", 0x00189197, "MR Velocity Encoding Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kFirstOrderPhaseCorrection
      //(0018,9198)
      = const ElementDef("FirstOrderPhaseCorrection", 0x00189198, "First Order Phase Correction",
          VR.kCS, VM.k1, false);
  static const ElementDef kWaterReferencedPhaseCorrection
      //(0018,9199)
      = const ElementDef("WaterReferencedPhaseCorrection", 0x00189199,
          "Water Referenced Phase Correction", VR.kCS, VM.k1, false);
  static const ElementDef kMRSpectroscopyAcquisitionType
      //(0018,9200)
      = const ElementDef("MRSpectroscopyAcquisitionType", 0x00189200,
          "MR Spectroscopy Acquisition Type", VR.kCS, VM.k1, false);
  static const ElementDef kRespiratoryCyclePosition
      //(0018,9214)
      = const ElementDef("RespiratoryCyclePosition", 0x00189214, "Respiratory Cycle Position", VR.kCS,
          VM.k1, false);
  static const ElementDef kVelocityEncodingMaximumValue
      //(0018,9217)
      = const ElementDef("VelocityEncodingMaximumValue", 0x00189217, "Velocity Encoding Maximum Value",
          VR.kFD, VM.k1, false);
  static const ElementDef kTagSpacingSecondDimension
      //(0018,9218)
      = const ElementDef("TagSpacingSecondDimension", 0x00189218,
          "Tag Spacing Second Dimension", VR.kFD, VM.k1, false);
  static const ElementDef kTagAngleSecondAxis
      //(0018,9219)
      = const ElementDef(
          "TagAngleSecondAxis", 0x00189219, "Tag Angle Second Axis", VR.kSS, VM.k1, false);
  static const ElementDef kFrameAcquisitionDuration
      //(0018,9220)
      = const ElementDef("FrameAcquisitionDuration", 0x00189220, "Frame Acquisition Duration", VR.kFD,
          VM.k1, false);
  static const ElementDef kMRImageFrameTypeSequence
      //(0018,9226)
      = const ElementDef("MRImageFrameTypeSequence", 0x00189226, "MR Image Frame Type Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMRSpectroscopyFrameTypeSequence
      //(0018,9227)
      = const ElementDef("MRSpectroscopyFrameTypeSequence", 0x00189227,
          "MR Spectroscopy Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMRAcquisitionPhaseEncodingStepsInPlane
      //(0018,9231)
      = const ElementDef("MRAcquisitionPhaseEncodingStepsInPlane", 0x00189231,
          "MR Acquisition Phase Encoding Steps in-plane", VR.kUS, VM.k1, false);
  static const ElementDef kMRAcquisitionPhaseEncodingStepsOutOfPlane
      //(0018,9232)
      = const ElementDef("MRAcquisitionPhaseEncodingStepsOutOfPlane", 0x00189232,
          "MR Acquisition Phase Encoding Steps out-of-plane", VR.kUS, VM.k1, false);
  static const ElementDef kSpectroscopyAcquisitionPhaseColumns
      //(0018,9234)
      = const ElementDef("SpectroscopyAcquisitionPhaseColumns", 0x00189234,
          "Spectroscopy Acquisition Phase Columns", VR.kUL, VM.k1, false);
  static const ElementDef kCardiacCyclePosition
      //(0018,9236)
      = const ElementDef(
          "CardiacCyclePosition", 0x00189236, "Cardiac Cycle Position", VR.kCS, VM.k1, false);
  static const ElementDef kSpecificAbsorptionRateSequence
      //(0018,9239)
      = const ElementDef("SpecificAbsorptionRateSequence", 0x00189239,
          "Specific Absorption Rate Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRFEchoTrainLength
      //(0018,9240)
      =
      const ElementDef("RFEchoTrainLength", 0x00189240, "RF Echo Train Length", VR.kUS, VM.k1, false);
  static const ElementDef kGradientEchoTrainLength
      //(0018,9241)
      = const ElementDef("GradientEchoTrainLength", 0x00189241, "Gradient Echo Train Length", VR.kUS,
          VM.k1, false);
  static const ElementDef kArterialSpinLabelingContrast
      //(0018,9250)
      = const ElementDef("ArterialSpinLabelingContrast", 0x00189250, "Arterial Spin Labeling Contrast",
          VR.kCS, VM.k1, false);
  static const ElementDef kMRArterialSpinLabelingSequence
      //(0018,9251)
      = const ElementDef("MRArterialSpinLabelingSequence", 0x00189251,
          "MR Arterial Spin Labeling Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kASLTechniqueDescription
      //(0018,9252)
      = const ElementDef(
          "ASLTechniqueDescription", 0x00189252, "ASL Technique Description", VR.kLO, VM.k1, false);
  static const ElementDef kASLSlabNumber
      //(0018,9253)
      = const ElementDef("ASLSlabNumber", 0x00189253, "ASL Slab Number", VR.kUS, VM.k1, false);
  static const ElementDef kASLSlabThickness
      //(0018,9254)
      = const ElementDef("ASLSlabThickness", 0x00189254, "ASL Slab Thickness", VR.kFD, VM.k1, false);
  static const ElementDef kASLSlabOrientation
      //(0018,9255)
      =
      const ElementDef("ASLSlabOrientation", 0x00189255, "ASL Slab Orientation", VR.kFD, VM.k3, false);
  static const ElementDef kASLMidSlabPosition
      //(0018,9256)
      = const ElementDef(
          "ASLMidSlabPosition", 0x00189256, "ASL Mid Slab Position", VR.kFD, VM.k3, false);
  static const ElementDef kASLContext
      //(0018,9257)
      = const ElementDef("ASLContext", 0x00189257, "ASL Context", VR.kCS, VM.k1, false);
  static const ElementDef kASLPulseTrainDuration
      //(0018,9258)
      = const ElementDef(
          "ASLPulseTrainDuration", 0x00189258, "ASL Pulse Train Duration", VR.kUL, VM.k1, false);
  static const ElementDef kASLCrusherFlag
      //(0018,9259)
      = const ElementDef("ASLCrusherFlag", 0x00189259, "ASL Crusher Flag", VR.kCS, VM.k1, false);
  static const ElementDef kASLCrusherFlowLimit
      //(0018,925A)
      = const ElementDef(
          "ASLCrusherFlowLimit", 0x0018925A, "ASL Crusher Flow Limit", VR.kFD, VM.k1, false);
  static const ElementDef kASLCrusherDescription
      //(0018,925B)
      = const ElementDef(
          "ASLCrusherDescription", 0x0018925B, "ASL Crusher Description", VR.kLO, VM.k1, false);
  static const ElementDef kASLBolusCutoffFlag
      //(0018,925C)
      = const ElementDef(
          "ASLBolusCutoffFlag", 0x0018925C, "ASL Bolus Cut-off Flag", VR.kCS, VM.k1, false);
  static const ElementDef kASLBolusCutoffTimingSequence
      //(0018,925D)
      = const ElementDef("ASLBolusCutoffTimingSequence", 0x0018925D,
          "ASL Bolus Cut-off Timing Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kASLBolusCutoffTechnique
      //(0018,925E)
      = const ElementDef("ASLBolusCutoffTechnique", 0x0018925E, "ASL Bolus Cut-off Technique", VR.kLO,
          VM.k1, false);
  static const ElementDef kASLBolusCutoffDelayTime
      //(0018,925F)
      = const ElementDef("ASLBolusCutoffDelayTime", 0x0018925F, "ASL Bolus Cut-off Delay Time", VR.kUL,
          VM.k1, false);
  static const ElementDef kASLSlabSequence
      //(0018,9260)
      = const ElementDef("ASLSlabSequence", 0x00189260, "ASL Slab Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChemicalShiftMinimumIntegrationLimitInppm
      //(0018,9295)
      = const ElementDef("ChemicalShiftMinimumIntegrationLimitInppm", 0x00189295,
          "Chemical Shift Minimum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const ElementDef kChemicalShiftMaximumIntegrationLimitInppm
      //(0018,9296)
      = const ElementDef("ChemicalShiftMaximumIntegrationLimitInppm", 0x00189296,
          "Chemical Shift Maximum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const ElementDef kCTAcquisitionTypeSequence
      //(0018,9301)
      = const ElementDef("CTAcquisitionTypeSequence", 0x00189301, "CT Acquisition Type Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAcquisitionType
      //(0018,9302)
      = const ElementDef("AcquisitionType", 0x00189302, "Acquisition Type", VR.kCS, VM.k1, false);
  static const ElementDef kTubeAngle
      //(0018,9303)
      = const ElementDef("TubeAngle", 0x00189303, "Tube Angle", VR.kFD, VM.k1, false);
  static const ElementDef kCTAcquisitionDetailsSequence
      //(0018,9304)
      = const ElementDef("CTAcquisitionDetailsSequence", 0x00189304, "CT Acquisition Details Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRevolutionTime
      //(0018,9305)
      = const ElementDef("RevolutionTime", 0x00189305, "Revolution Time", VR.kFD, VM.k1, false);
  static const ElementDef kSingleCollimationWidth
      //(0018,9306)
      = const ElementDef(
          "SingleCollimationWidth", 0x00189306, "Single Collimation Width", VR.kFD, VM.k1, false);
  static const ElementDef kTotalCollimationWidth
      //(0018,9307)
      = const ElementDef(
          "TotalCollimationWidth", 0x00189307, "Total Collimation Width", VR.kFD, VM.k1, false);
  static const ElementDef kCTTableDynamicsSequence
      //(0018,9308)
      = const ElementDef("CTTableDynamicsSequence", 0x00189308, "CT Table Dynamics Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kTableSpeed
      //(0018,9309)
      = const ElementDef("TableSpeed", 0x00189309, "Table Speed", VR.kFD, VM.k1, false);
  static const ElementDef kTableFeedPerRotation
      //(0018,9310)
      = const ElementDef(
          "TableFeedPerRotation", 0x00189310, "Table Feed per Rotation", VR.kFD, VM.k1, false);
  static const ElementDef kSpiralPitchFactor
      //(0018,9311)
      = const ElementDef("SpiralPitchFactor", 0x00189311, "Spiral Pitch Factor", VR.kFD, VM.k1, false);
  static const ElementDef kCTGeometrySequence
      //(0018,9312)
      =
      const ElementDef("CTGeometrySequence", 0x00189312, "CT Geometry Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDataCollectionCenterPatient
      //(0018,9313)
      = const ElementDef("DataCollectionCenterPatient", 0x00189313, "Data Collection Center (Patient)",
          VR.kFD, VM.k3, false);
  static const ElementDef kCTReconstructionSequence
      //(0018,9314)
      = const ElementDef("CTReconstructionSequence", 0x00189314, "CT Reconstruction Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kReconstructionAlgorithm
      //(0018,9315)
      = const ElementDef(
          "ReconstructionAlgorithm", 0x00189315, "Reconstruction Algorithm", VR.kCS, VM.k1, false);
  static const ElementDef kConvolutionKernelGroup
      //(0018,9316)
      = const ElementDef(
          "ConvolutionKernelGroup", 0x00189316, "Convolution Kernel Group", VR.kCS, VM.k1, false);
  static const ElementDef kReconstructionFieldOfView
      //(0018,9317)
      = const ElementDef("ReconstructionFieldOfView", 0x00189317, "Reconstruction Field of View",
          VR.kFD, VM.k2, false);
  static const ElementDef kReconstructionTargetCenterPatient
      //(0018,9318)
      = const ElementDef("ReconstructionTargetCenterPatient", 0x00189318,
          "Reconstruction Target Center (Patient)", VR.kFD, VM.k3, false);
  static const ElementDef kReconstructionAngle
      //(0018,9319)
      = const ElementDef(
          "ReconstructionAngle", 0x00189319, "Reconstruction Angle", VR.kFD, VM.k1, false);
  static const ElementDef kImageFilter
      //(0018,9320)
      = const ElementDef("ImageFilter", 0x00189320, "Image Filter", VR.kSH, VM.k1, false);
  static const ElementDef kCTExposureSequence
      //(0018,9321)
      =
      const ElementDef("CTExposureSequence", 0x00189321, "CT Exposure Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReconstructionPixelSpacing
      //(0018,9322)
      = const ElementDef("ReconstructionPixelSpacing", 0x00189322, "Reconstruction Pixel Spacing",
          VR.kFD, VM.k2, false);
  static const ElementDef kExposureModulationType
      //(0018,9323)
      = const ElementDef(
          "ExposureModulationType", 0x00189323, "Exposure Modulation Type", VR.kCS, VM.k1, false);
  static const ElementDef kEstimatedDoseSaving
      //(0018,9324)
      = const ElementDef(
          "EstimatedDoseSaving", 0x00189324, "Estimated Dose Saving", VR.kFD, VM.k1, false);
  static const ElementDef kCTXRayDetailsSequence
      //(0018,9325)
      = const ElementDef(
          "CTXRayDetailsSequence", 0x00189325, "CT X-Ray Details Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCTPositionSequence
      //(0018,9326)
      =
      const ElementDef("CTPositionSequence", 0x00189326, "CT Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTablePosition
      //(0018,9327)
      = const ElementDef("TablePosition", 0x00189327, "Table Position", VR.kFD, VM.k1, false);
  static const ElementDef kExposureTimeInms
      //(0018,9328)
      = const ElementDef("ExposureTimeInms", 0x00189328, "Exposure Time in ms", VR.kFD, VM.k1, false);
  static const ElementDef kCTImageFrameTypeSequence
      //(0018,9329)
      = const ElementDef("CTImageFrameTypeSequence", 0x00189329, "CT Image Frame Type Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kXRayTubeCurrentInmA
      //(0018,9330)
      = const ElementDef(
          "XRayTubeCurrentInmA", 0x00189330, "X-Ray Tube Current in mA", VR.kFD, VM.k1, false);
  static const ElementDef kExposureInmAs
      //(0018,9332)
      = const ElementDef("ExposureInmAs", 0x00189332, "Exposure in mAs", VR.kFD, VM.k1, false);
  static const ElementDef kConstantVolumeFlag
      //(0018,9333)
      =
      const ElementDef("ConstantVolumeFlag", 0x00189333, "Constant Volume Flag", VR.kCS, VM.k1, false);
  static const ElementDef kFluoroscopyFlag
      //(0018,9334)
      = const ElementDef("FluoroscopyFlag", 0x00189334, "Fluoroscopy Flag", VR.kCS, VM.k1, false);
  static const ElementDef kDistanceSourceToDataCollectionCenter
      //(0018,9335)
      = const ElementDef("DistanceSourceToDataCollectionCenter", 0x00189335,
          "Distance Source to Data Collection Center", VR.kFD, VM.k1, false);
  static const ElementDef kContrastBolusAgentNumber
      //(0018,9337)
      = const ElementDef("ContrastBolusAgentNumber", 0x00189337, "Contrast/Bolus Agent Number", VR.kUS,
          VM.k1, false);
  static const ElementDef kContrastBolusIngredientCodeSequence
      //(0018,9338)
      = const ElementDef("ContrastBolusIngredientCodeSequence", 0x00189338,
          "Contrast/Bolus Ingredient Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContrastAdministrationProfileSequence
      //(0018,9340)
      = const ElementDef("ContrastAdministrationProfileSequence", 0x00189340,
          "Contrast Administration Profile Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContrastBolusUsageSequence
      //(0018,9341)
      = const ElementDef("ContrastBolusUsageSequence", 0x00189341, "Contrast/Bolus Usage Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kContrastBolusAgentAdministered
      //(0018,9342)
      = const ElementDef("ContrastBolusAgentAdministered", 0x00189342,
          "Contrast/Bolus Agent Administered", VR.kCS, VM.k1, false);
  static const ElementDef kContrastBolusAgentDetected
      //(0018,9343)
      = const ElementDef("ContrastBolusAgentDetected", 0x00189343, "Contrast/Bolus Agent Detected",
          VR.kCS, VM.k1, false);
  static const ElementDef kContrastBolusAgentPhase
      //(0018,9344)
      = const ElementDef("ContrastBolusAgentPhase", 0x00189344, "Contrast/Bolus Agent Phase", VR.kCS,
          VM.k1, false);
  static const ElementDef kCTDIvol
      //(0018,9345)
      = const ElementDef("CTDIvol", 0x00189345, "CTDIvol", VR.kFD, VM.k1, false);
  static const ElementDef kCTDIPhantomTypeCodeSequence
      //(0018,9346)
      = const ElementDef("CTDIPhantomTypeCodeSequence", 0x00189346, "CTDI Phantom Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCalciumScoringMassFactorPatient
      //(0018,9351)
      = const ElementDef("CalciumScoringMassFactorPatient", 0x00189351,
          "Calcium Scoring Mass Factor Patient", VR.kFL, VM.k1, false);
  static const ElementDef kCalciumScoringMassFactorDevice
      //(0018,9352)
      = const ElementDef("CalciumScoringMassFactorDevice", 0x00189352,
          "Calcium Scoring Mass Factor Device", VR.kFL, VM.k3, false);
  static const ElementDef kEnergyWeightingFactor
      //(0018,9353)
      = const ElementDef(
          "EnergyWeightingFactor", 0x00189353, "Energy Weighting Factor", VR.kFL, VM.k1, false);
  static const ElementDef kCTAdditionalXRaySourceSequence
      //(0018,9360)
      = const ElementDef("CTAdditionalXRaySourceSequence", 0x00189360,
          "CT Additional X-Ray Source Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kProjectionPixelCalibrationSequence
      //(0018,9401)
      = const ElementDef("ProjectionPixelCalibrationSequence", 0x00189401,
          "Projection Pixel Calibration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDistanceSourceToIsocenter
      //(0018,9402)
      = const ElementDef("DistanceSourceToIsocenter", 0x00189402, "Distance Source to Isocenter",
          VR.kFL, VM.k1, false);
  static const ElementDef kDistanceObjectToTableTop
      //(0018,9403)
      = const ElementDef("DistanceObjectToTableTop", 0x00189403, "Distance Object to Table Top",
          VR.kFL, VM.k1, false);
  static const ElementDef kObjectPixelSpacingInCenterOfBeam
      //(0018,9404)
      = const ElementDef("ObjectPixelSpacingInCenterOfBeam", 0x00189404,
          "Object Pixel Spacing in Center of Beam", VR.kFL, VM.k2, false);
  static const ElementDef kPositionerPositionSequence
      //(0018,9405)
      = const ElementDef("PositionerPositionSequence", 0x00189405, "Positioner Position Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTablePositionSequence
      //(0018,9406)
      = const ElementDef(
          "TablePositionSequence", 0x00189406, "Table Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCollimatorShapeSequence
      //(0018,9407)
      = const ElementDef(
          "CollimatorShapeSequence", 0x00189407, "Collimator Shape Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlanesInAcquisition
      //(0018,9410)
      = const ElementDef(
          "PlanesInAcquisition", 0x00189410, "Planes in Acquisition", VR.kCS, VM.k1, false);
  static const ElementDef kXAXRFFrameCharacteristicsSequence
      //(0018,9412)
      = const ElementDef("XAXRFFrameCharacteristicsSequence", 0x00189412,
          "XA/XRF Frame Characteristics Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFrameAcquisitionSequence
      //(0018,9417)
      = const ElementDef("FrameAcquisitionSequence", 0x00189417, "Frame Acquisition Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kXRayReceptorType
      //(0018,9420)
      = const ElementDef("XRayReceptorType", 0x00189420, "X-Ray Receptor Type", VR.kCS, VM.k1, false);
  static const ElementDef kAcquisitionProtocolName
      //(0018,9423)
      = const ElementDef(
          "AcquisitionProtocolName", 0x00189423, "Acquisition Protocol Name", VR.kLO, VM.k1, false);
  static const ElementDef kAcquisitionProtocolDescription
      //(0018,9424)
      = const ElementDef("AcquisitionProtocolDescription", 0x00189424,
          "Acquisition Protocol Description", VR.kLT, VM.k1, false);
  static const ElementDef kContrastBolusIngredientOpaque
      //(0018,9425)
      = const ElementDef("ContrastBolusIngredientOpaque", 0x00189425,
          "Contrast/Bolus Ingredient Opaque", VR.kCS, VM.k1, false);
  static const ElementDef kDistanceReceptorPlaneToDetectorHousing
      //(0018,9426)
      = const ElementDef("DistanceReceptorPlaneToDetectorHousing", 0x00189426,
          "Distance Receptor Plane to Detector Housing", VR.kFL, VM.k1, false);
  static const ElementDef kIntensifierActiveShape
      //(0018,9427)
      = const ElementDef(
          "IntensifierActiveShape", 0x00189427, "Intensifier Active Shape", VR.kCS, VM.k1, false);
  static const ElementDef kIntensifierActiveDimensions
      //(0018,9428)
      = const ElementDef("IntensifierActiveDimensions", 0x00189428, "Intensifier Active Dimension(s)",
          VR.kFL, VM.k1_2, false);
  static const ElementDef kPhysicalDetectorSize
      //(0018,9429)
      = const ElementDef(
          "PhysicalDetectorSize", 0x00189429, "Physical Detector Size", VR.kFL, VM.k2, false);
  static const ElementDef kPositionOfIsocenterProjection
      //(0018,9430)
      = const ElementDef("PositionOfIsocenterProjection", 0x00189430,
          "Position of Isocenter Projection", VR.kFL, VM.k2, false);
  static const ElementDef kFieldOfViewSequence
      //(0018,9432)
      = const ElementDef(
          "FieldOfViewSequence", 0x00189432, "Field of View Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFieldOfViewDescription
      //(0018,9433)
      = const ElementDef(
          "FieldOfViewDescription", 0x00189433, "Field of View Description", VR.kLO, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionsSequence
      //(0018,9434)
      = const ElementDef("ExposureControlSensingRegionsSequence", 0x00189434,
          "Exposure Control Sensing Regions Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionShape
      //(0018,9435)
      = const ElementDef("ExposureControlSensingRegionShape", 0x00189435,
          "Exposure Control Sensing Region Shape", VR.kCS, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionLeftVerticalEdge
      //(0018,9436)
      = const ElementDef("ExposureControlSensingRegionLeftVerticalEdge", 0x00189436,
          "Exposure Control Sensing Region Left Vertical Edge", VR.kSS, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionRightVerticalEdge
      //(0018,9437)
      = const ElementDef("ExposureControlSensingRegionRightVerticalEdge", 0x00189437,
          "Exposure Control Sensing Region Right Vertical Edge", VR.kSS, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionUpperHorizontalEdge
      //(0018,9438)
      = const ElementDef("ExposureControlSensingRegionUpperHorizontalEdge", 0x00189438,
          "Exposure Control Sensing Region Upper Horizontal Edge", VR.kSS, VM.k1, false);
  static const ElementDef kExposureControlSensingRegionLowerHorizontalEdge
      //(0018,9439)
      = const ElementDef("ExposureControlSensingRegionLowerHorizontalEdge", 0x00189439,
          "Exposure Control Sensing Region Lower Horizontal Edge", VR.kSS, VM.k1, false);
  static const ElementDef kCenterOfCircularExposureControlSensingRegion
      //(0018,9440)
      = const ElementDef("CenterOfCircularExposureControlSensingRegion", 0x00189440,
          "Center of Circular Exposure Control Sensing Region", VR.kSS, VM.k2, false);
  static const ElementDef kRadiusOfCircularExposureControlSensingRegion
      //(0018,9441)
      = const ElementDef("RadiusOfCircularExposureControlSensingRegion", 0x00189441,
          "Radius of Circular Exposure Control Sensing Region", VR.kUS, VM.k1, false);
  static const ElementDef kVerticesOfThePolygonalExposureControlSensingRegion
      //(0018,9442)
      = const ElementDef("VerticesOfThePolygonalExposureControlSensingRegion", 0x00189442,
          "Vertices of the Polygonal Exposure Control Sensing Region", VR.kSS, VM.k2_n, false);
  static const ElementDef kNoName0
      //(0018,9445)
      = const ElementDef("NoName0", 0x00189445, "See Note 3", VR.kNoVR, VM.kNoVM, true);
  static const ElementDef kColumnAngulationPatient
      //(0018,9447)
      = const ElementDef("ColumnAngulationPatient", 0x00189447, "Column Angulation (Patient)", VR.kFL,
          VM.k1, false);
  static const ElementDef kBeamAngle
      //(0018,9449)
      = const ElementDef("BeamAngle", 0x00189449, "Beam Angle", VR.kFL, VM.k1, false);
  static const ElementDef kFrameDetectorParametersSequence
      //(0018,9451)
      = const ElementDef("FrameDetectorParametersSequence", 0x00189451,
          "Frame Detector Parameters Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCalculatedAnatomyThickness
      //(0018,9452)
      = const ElementDef("CalculatedAnatomyThickness", 0x00189452, "Calculated Anatomy Thickness",
          VR.kFL, VM.k1, false);
  static const ElementDef kCalibrationSequence
      //(0018,9455)
      = const ElementDef(
          "CalibrationSequence", 0x00189455, "Calibration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kObjectThicknessSequence
      //(0018,9456)
      = const ElementDef(
          "ObjectThicknessSequence", 0x00189456, "Object Thickness Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlaneIdentification
      //(0018,9457)
      = const ElementDef(
          "PlaneIdentification", 0x00189457, "Plane Identification", VR.kCS, VM.k1, false);
  static const ElementDef kFieldOfViewDimensionsInFloat
      //(0018,9461)
      = const ElementDef("FieldOfViewDimensionsInFloat", 0x00189461,
          "Field of View Dimension(s) in Float", VR.kFL, VM.k1_2, false);
  static const ElementDef kIsocenterReferenceSystemSequence
      //(0018,9462)
      = const ElementDef("IsocenterReferenceSystemSequence", 0x00189462,
          "Isocenter Reference System Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPositionerIsocenterPrimaryAngle
      //(0018,9463)
      = const ElementDef("PositionerIsocenterPrimaryAngle", 0x00189463,
          "Positioner Isocenter Primary Angle", VR.kFL, VM.k1, false);
  static const ElementDef kPositionerIsocenterSecondaryAngle
      //(0018,9464)
      = const ElementDef("PositionerIsocenterSecondaryAngle", 0x00189464,
          "Positioner Isocenter Secondary Angle", VR.kFL, VM.k1, false);
  static const ElementDef kPositionerIsocenterDetectorRotationAngle
      //(0018,9465)
      = const ElementDef("PositionerIsocenterDetectorRotationAngle", 0x00189465,
          "Positioner Isocenter Detector Rotation Angle", VR.kFL, VM.k1, false);
  static const ElementDef kTableXPositionToIsocenter
      //(0018,9466)
      = const ElementDef("TableXPositionToIsocenter", 0x00189466, "Table X Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableYPositionToIsocenter
      //(0018,9467)
      = const ElementDef("TableYPositionToIsocenter", 0x00189467, "Table Y Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableZPositionToIsocenter
      //(0018,9468)
      = const ElementDef("TableZPositionToIsocenter", 0x00189468, "Table Z Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableHorizontalRotationAngle
      //(0018,9469)
      = const ElementDef("TableHorizontalRotationAngle", 0x00189469, "Table Horizontal Rotation Angle",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableHeadTiltAngle
      //(0018,9470)
      = const ElementDef(
          "TableHeadTiltAngle", 0x00189470, "Table Head Tilt Angle", VR.kFL, VM.k1, false);
  static const ElementDef kTableCradleTiltAngle
      //(0018,9471)
      = const ElementDef(
          "TableCradleTiltAngle", 0x00189471, "Table Cradle Tilt Angle", VR.kFL, VM.k1, false);
  static const ElementDef kFrameDisplayShutterSequence
      //(0018,9472)
      = const ElementDef("FrameDisplayShutterSequence", 0x00189472, "Frame Display Shutter Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAcquiredImageAreaDoseProduct
      //(0018,9473)
      = const ElementDef("AcquiredImageAreaDoseProduct", 0x00189473,
          "Acquired Image Area Dose Product", VR.kFL, VM.k1, false);
  static const ElementDef kCArmPositionerTabletopRelationship
      //(0018,9474)
      = const ElementDef("CArmPositionerTabletopRelationship", 0x00189474,
          "C-arm Positioner Tabletop Relationship", VR.kCS, VM.k1, false);
  static const ElementDef kXRayGeometrySequence
      //(0018,9476)
      = const ElementDef(
          "XRayGeometrySequence", 0x00189476, "X-Ray Geometry Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIrradiationEventIdentificationSequence
      //(0018,9477)
      = const ElementDef("IrradiationEventIdentificationSequence", 0x00189477,
          "Irradiation Event Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kXRay3DFrameTypeSequence
      //(0018,9504)
      = const ElementDef("XRay3DFrameTypeSequence", 0x00189504, "X-Ray 3D Frame Type Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kContributingSourcesSequence
      //(0018,9506)
      = const ElementDef("ContributingSourcesSequence", 0x00189506, "Contributing Sources Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kXRay3DAcquisitionSequence
      //(0018,9507)
      = const ElementDef("XRay3DAcquisitionSequence", 0x00189507, "X-Ray 3D Acquisition Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPrimaryPositionerScanArc
      //(0018,9508)
      = const ElementDef("PrimaryPositionerScanArc", 0x00189508, "Primary Positioner Scan Arc", VR.kFL,
          VM.k1, false);
  static const ElementDef kSecondaryPositionerScanArc
      //(0018,9509)
      = const ElementDef("SecondaryPositionerScanArc", 0x00189509, "Secondary Positioner Scan Arc",
          VR.kFL, VM.k1, false);
  static const ElementDef kPrimaryPositionerScanStartAngle
      //(0018,9510)
      = const ElementDef("PrimaryPositionerScanStartAngle", 0x00189510,
          "Primary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const ElementDef kSecondaryPositionerScanStartAngle
      //(0018,9511)
      = const ElementDef("SecondaryPositionerScanStartAngle", 0x00189511,
          "Secondary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const ElementDef kPrimaryPositionerIncrement
      //(0018,9514)
      = const ElementDef("PrimaryPositionerIncrement", 0x00189514, "Primary Positioner Increment",
          VR.kFL, VM.k1, false);
  static const ElementDef kSecondaryPositionerIncrement
      //(0018,9515)
      = const ElementDef("SecondaryPositionerIncrement", 0x00189515, "Secondary Positioner Increment",
          VR.kFL, VM.k1, false);
  static const ElementDef kStartAcquisitionDateTime
      //(0018,9516)
      = const ElementDef("StartAcquisitionDateTime", 0x00189516, "Start Acquisition DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kEndAcquisitionDateTime
      //(0018,9517)
      = const ElementDef(
          "EndAcquisitionDateTime", 0x00189517, "End Acquisition DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kApplicationName
      //(0018,9524)
      = const ElementDef("ApplicationName", 0x00189524, "Application Name", VR.kLO, VM.k1, false);
  static const ElementDef kApplicationVersion
      //(0018,9525)
      =
      const ElementDef("ApplicationVersion", 0x00189525, "Application Version", VR.kLO, VM.k1, false);
  static const ElementDef kApplicationManufacturer
      //(0018,9526)
      = const ElementDef(
          "ApplicationManufacturer", 0x00189526, "Application Manufacturer", VR.kLO, VM.k1, false);
  static const ElementDef kAlgorithmType
      //(0018,9527)
      = const ElementDef("AlgorithmType", 0x00189527, "Algorithm Type", VR.kCS, VM.k1, false);
  static const ElementDef kAlgorithmDescription
      //(0018,9528)
      = const ElementDef(
          "AlgorithmDescription", 0x00189528, "Algorithm Description", VR.kLO, VM.k1, false);
  static const ElementDef kXRay3DReconstructionSequence
      //(0018,9530)
      = const ElementDef("XRay3DReconstructionSequence", 0x00189530,
          "X-Ray 3D Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReconstructionDescription
      //(0018,9531)
      = const ElementDef("ReconstructionDescription", 0x00189531, "Reconstruction Description", VR.kLO,
          VM.k1, false);
  static const ElementDef kPerProjectionAcquisitionSequence
      //(0018,9538)
      = const ElementDef("PerProjectionAcquisitionSequence", 0x00189538,
          "Per Projection Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDiffusionBMatrixSequence
      //(0018,9601)
      = const ElementDef("DiffusionBMatrixSequence", 0x00189601, "Diffusion b-matrix Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kDiffusionBValueXX
      //(0018,9602)
      =
      const ElementDef("DiffusionBValueXX", 0x00189602, "Diffusion b-value XX", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionBValueXY
      //(0018,9603)
      =
      const ElementDef("DiffusionBValueXY", 0x00189603, "Diffusion b-value XY", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionBValueXZ
      //(0018,9604)
      =
      const ElementDef("DiffusionBValueXZ", 0x00189604, "Diffusion b-value XZ", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionBValueYY
      //(0018,9605)
      =
      const ElementDef("DiffusionBValueYY", 0x00189605, "Diffusion b-value YY", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionBValueYZ
      //(0018,9606)
      =
      const ElementDef("DiffusionBValueYZ", 0x00189606, "Diffusion b-value YZ", VR.kFD, VM.k1, false);
  static const ElementDef kDiffusionBValueZZ
      //(0018,9607)
      =
      const ElementDef("DiffusionBValueZZ", 0x00189607, "Diffusion b-value ZZ", VR.kFD, VM.k1, false);
  static const ElementDef kDecayCorrectionDateTime
      //(0018,9701)
      = const ElementDef(
          "DecayCorrectionDateTime", 0x00189701, "Decay Correction DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kStartDensityThreshold
      //(0018,9715)
      = const ElementDef(
          "StartDensityThreshold", 0x00189715, "Start Density Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kStartRelativeDensityDifferenceThreshold
      //(0018,9716)
      = const ElementDef("StartRelativeDensityDifferenceThreshold", 0x00189716,
          "Start Relative Density Difference Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kStartCardiacTriggerCountThreshold
      //(0018,9717)
      = const ElementDef("StartCardiacTriggerCountThreshold", 0x00189717,
          "Start Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kStartRespiratoryTriggerCountThreshold
      //(0018,9718)
      = const ElementDef("StartRespiratoryTriggerCountThreshold", 0x00189718,
          "Start Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kTerminationCountsThreshold
      //(0018,9719)
      = const ElementDef("TerminationCountsThreshold", 0x00189719, "Termination Counts Threshold",
          VR.kFD, VM.k1, false);
  static const ElementDef kTerminationDensityThreshold
      //(0018,9720)
      = const ElementDef("TerminationDensityThreshold", 0x00189720, "Termination Density Threshold",
          VR.kFD, VM.k1, false);
  static const ElementDef kTerminationRelativeDensityThreshold
      //(0018,9721)
      = const ElementDef("TerminationRelativeDensityThreshold", 0x00189721,
          "Termination Relative Density Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kTerminationTimeThreshold
      //(0018,9722)
      = const ElementDef("TerminationTimeThreshold", 0x00189722, "Termination Time Threshold", VR.kFD,
          VM.k1, false);
  static const ElementDef kTerminationCardiacTriggerCountThreshold
      //(0018,9723)
      = const ElementDef("TerminationCardiacTriggerCountThreshold", 0x00189723,
          "Termination Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kTerminationRespiratoryTriggerCountThreshold
      //(0018,9724)
      = const ElementDef("TerminationRespiratoryTriggerCountThreshold", 0x00189724,
          "Termination Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kDetectorGeometry
      //(0018,9725)
      = const ElementDef("DetectorGeometry", 0x00189725, "Detector Geometry", VR.kCS, VM.k1, false);
  static const ElementDef kTransverseDetectorSeparation
      //(0018,9726)
      = const ElementDef("TransverseDetectorSeparation", 0x00189726, "Transverse Detector Separation",
          VR.kFD, VM.k1, false);
  static const ElementDef kAxialDetectorDimension
      //(0018,9727)
      = const ElementDef(
          "AxialDetectorDimension", 0x00189727, "Axial Detector Dimension", VR.kFD, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalAgentNumber
      //(0018,9729)
      = const ElementDef("RadiopharmaceuticalAgentNumber", 0x00189729,
          "Radiopharmaceutical Agent Number", VR.kUS, VM.k1, false);
  static const ElementDef kPETFrameAcquisitionSequence
      //(0018,9732)
      = const ElementDef("PETFrameAcquisitionSequence", 0x00189732, "PET Frame Acquisition Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPETDetectorMotionDetailsSequence
      //(0018,9733)
      = const ElementDef("PETDetectorMotionDetailsSequence", 0x00189733,
          "PET Detector Motion Details Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPETTableDynamicsSequence
      //(0018,9734)
      = const ElementDef("PETTableDynamicsSequence", 0x00189734, "PET Table Dynamics Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kPETPositionSequence
      //(0018,9735)
      = const ElementDef(
          "PETPositionSequence", 0x00189735, "PET Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPETFrameCorrectionFactorsSequence
      //(0018,9736)
      = const ElementDef("PETFrameCorrectionFactorsSequence", 0x00189736,
          "PET Frame Correction Factors Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalUsageSequence
      //(0018,9737)
      = const ElementDef("RadiopharmaceuticalUsageSequence", 0x00189737,
          "Radiopharmaceutical Usage Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAttenuationCorrectionSource
      //(0018,9738)
      = const ElementDef("AttenuationCorrectionSource", 0x00189738, "Attenuation Correction Source",
          VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfIterations
      //(0018,9739)
      =
      const ElementDef("NumberOfIterations", 0x00189739, "Number of Iterations", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfSubsets
      //(0018,9740)
      = const ElementDef("NumberOfSubsets", 0x00189740, "Number of Subsets", VR.kUS, VM.k1, false);
  static const ElementDef kPETReconstructionSequence
      //(0018,9749)
      = const ElementDef("PETReconstructionSequence", 0x00189749, "PET Reconstruction Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPETFrameTypeSequence
      //(0018,9751)
      = const ElementDef(
          "PETFrameTypeSequence", 0x00189751, "PET Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTimeOfFlightInformationUsed
      //(0018,9755)
      = const ElementDef("TimeOfFlightInformationUsed", 0x00189755, "Time of Flight Information Used",
          VR.kCS, VM.k1, false);
  static const ElementDef kReconstructionType
      //(0018,9756)
      =
      const ElementDef("ReconstructionType", 0x00189756, "Reconstruction Type", VR.kCS, VM.k1, false);
  static const ElementDef kDecayCorrected
      //(0018,9758)
      = const ElementDef("DecayCorrected", 0x00189758, "Decay Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kAttenuationCorrected
      //(0018,9759)
      = const ElementDef(
          "AttenuationCorrected", 0x00189759, "Attenuation Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kScatterCorrected
      //(0018,9760)
      = const ElementDef("ScatterCorrected", 0x00189760, "Scatter Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kDeadTimeCorrected
      //(0018,9761)
      = const ElementDef("DeadTimeCorrected", 0x00189761, "Dead Time Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kGantryMotionCorrected
      //(0018,9762)
      = const ElementDef(
          "GantryMotionCorrected", 0x00189762, "Gantry Motion Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kPatientMotionCorrected
      //(0018,9763)
      = const ElementDef(
          "PatientMotionCorrected", 0x00189763, "Patient Motion Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kCountLossNormalizationCorrected
      //(0018,9764)
      = const ElementDef("CountLossNormalizationCorrected", 0x00189764,
          "Count Loss Normalization Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kRandomsCorrected
      //(0018,9765)
      = const ElementDef("RandomsCorrected", 0x00189765, "Randoms Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kNonUniformRadialSamplingCorrected
      //(0018,9766)
      = const ElementDef("NonUniformRadialSamplingCorrected", 0x00189766,
          "Non-uniform Radial Sampling Corrected", VR.kCS, VM.k1, false);
  static const ElementDef kSensitivityCalibrated
      //(0018,9767)
      = const ElementDef(
          "SensitivityCalibrated", 0x00189767, "Sensitivity Calibrated", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorNormalizationCorrection
      //(0018,9768)
      = const ElementDef("DetectorNormalizationCorrection", 0x00189768,
          "Detector Normalization Correction", VR.kCS, VM.k1, false);
  static const ElementDef kIterativeReconstructionMethod
      //(0018,9769)
      = const ElementDef("IterativeReconstructionMethod", 0x00189769,
          "Iterative Reconstruction Method", VR.kCS, VM.k1, false);
  static const ElementDef kAttenuationCorrectionTemporalRelationship
      //(0018,9770)
      = const ElementDef("AttenuationCorrectionTemporalRelationship", 0x00189770,
          "Attenuation Correction Temporal Relationship", VR.kCS, VM.k1, false);
  static const ElementDef kPatientPhysiologicalStateSequence
      //(0018,9771)
      = const ElementDef("PatientPhysiologicalStateSequence", 0x00189771,
          "Patient Physiological State Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientPhysiologicalStateCodeSequence
      //(0018,9772)
      = const ElementDef("PatientPhysiologicalStateCodeSequence", 0x00189772,
          "Patient Physiological State Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDepthsOfFocus
      //(0018,9801)
      = const ElementDef("DepthsOfFocus", 0x00189801, "Depth(s) of Focus", VR.kFD, VM.k1_n, false);
  static const ElementDef kExcludedIntervalsSequence
      //(0018,9803)
      = const ElementDef("ExcludedIntervalsSequence", 0x00189803, "Excluded Intervals Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kExclusionStartDateTime
      //(0018,9804)
      = const ElementDef(
          "ExclusionStartDateTime", 0x00189804, "Exclusion Start DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kExclusionDuration
      //(0018,9805)
      = const ElementDef("ExclusionDuration", 0x00189805, "Exclusion Duration", VR.kFD, VM.k1, false);
  static const ElementDef kUSImageDescriptionSequence
      //(0018,9806)
      = const ElementDef("USImageDescriptionSequence", 0x00189806, "US Image Description Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImageDataTypeSequence
      //(0018,9807)
      = const ElementDef(
          "ImageDataTypeSequence", 0x00189807, "Image Data Type Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDataType
      //(0018,9808)
      = const ElementDef("DataType", 0x00189808, "Data Type", VR.kCS, VM.k1, false);
  static const ElementDef kTransducerScanPatternCodeSequence
      //(0018,9809)
      = const ElementDef("TransducerScanPatternCodeSequence", 0x00189809,
          "Transducer Scan Pattern Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAliasedDataType
      //(0018,980B)
      = const ElementDef("AliasedDataType", 0x0018980B, "Aliased Data Type", VR.kCS, VM.k1, false);
  static const ElementDef kPositionMeasuringDeviceUsed
      //(0018,980C)
      = const ElementDef("PositionMeasuringDeviceUsed", 0x0018980C, "Position Measuring Device Used",
          VR.kCS, VM.k1, false);
  static const ElementDef kTransducerGeometryCodeSequence
      //(0018,980D)
      = const ElementDef("TransducerGeometryCodeSequence", 0x0018980D,
          "Transducer Geometry Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTransducerBeamSteeringCodeSequence
      //(0018,980E)
      = const ElementDef("TransducerBeamSteeringCodeSequence", 0x0018980E,
          "Transducer Beam Steering Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTransducerApplicationCodeSequence
      //(0018,980F)
      = const ElementDef("TransducerApplicationCodeSequence", 0x0018980F,
          "Transducer Application Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kZeroVelocityPixelValue
      //(0018,9810)
      = const ElementDef("ZeroVelocityPixelValue", 0x00189810, "Zero Velocity Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const ElementDef kContributingEquipmentSequence
      //(0018,A001)
      = const ElementDef("ContributingEquipmentSequence", 0x0018A001,
          "Contributing Equipment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContributionDateTime
      //(0018,A002)
      = const ElementDef(
          "ContributionDateTime", 0x0018A002, "Contribution DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kContributionDescription
      //(0018,A003)
      = const ElementDef(
          "ContributionDescription", 0x0018A003, "Contribution Description", VR.kST, VM.k1, false);
  static const ElementDef kStudyInstanceUID
      //(0020,000D)
      = const ElementDef("StudyInstanceUID", 0x0020000D, "Study Instance UID", VR.kUI, VM.k1, false);
  static const ElementDef kSeriesInstanceUID
      //(0020,000E)
      = const ElementDef("SeriesInstanceUID", 0x0020000E, "Series Instance UID", VR.kUI, VM.k1, false);
  static const ElementDef kStudyID
      //(0020,0010)
      = const ElementDef("StudyID", 0x00200010, "Study ID", VR.kSH, VM.k1, false);
  static const ElementDef kSeriesNumber
      //(0020,0011)
      = const ElementDef("SeriesNumber", 0x00200011, "Series Number", VR.kIS, VM.k1, false);
  static const ElementDef kAcquisitionNumber
      //(0020,0012)
      = const ElementDef("AcquisitionNumber", 0x00200012, "Acquisition Number", VR.kIS, VM.k1, false);
  static const ElementDef kInstanceNumber
      //(0020,0013)
      = const ElementDef("InstanceNumber", 0x00200013, "Instance Number", VR.kIS, VM.k1, false);
  static const ElementDef kIsotopeNumber
      //(0020,0014)
      = const ElementDef("IsotopeNumber", 0x00200014, "Isotope Number", VR.kIS, VM.k1, true);
  static const ElementDef kPhaseNumber
      //(0020,0015)
      = const ElementDef("PhaseNumber", 0x00200015, "Phase Number", VR.kIS, VM.k1, true);
  static const ElementDef kIntervalNumber
      //(0020,0016)
      = const ElementDef("IntervalNumber", 0x00200016, "Interval Number", VR.kIS, VM.k1, true);
  static const ElementDef kTimeSlotNumber
      //(0020,0017)
      = const ElementDef("TimeSlotNumber", 0x00200017, "Time Slot Number", VR.kIS, VM.k1, true);
  static const ElementDef kAngleNumber
      //(0020,0018)
      = const ElementDef("AngleNumber", 0x00200018, "Angle Number", VR.kIS, VM.k1, true);
  static const ElementDef kItemNumber
      //(0020,0019)
      = const ElementDef("ItemNumber", 0x00200019, "Item Number", VR.kIS, VM.k1, false);
  static const ElementDef kPatientOrientation
      //(0020,0020)
      =
      const ElementDef("PatientOrientation", 0x00200020, "Patient Orientation", VR.kCS, VM.k2, false);
  static const ElementDef kOverlayNumber
      //(0020,0022)
      = const ElementDef("OverlayNumber", 0x00200022, "Overlay Number", VR.kIS, VM.k1, true);
  static const ElementDef kCurveNumber
      //(0020,0024)
      = const ElementDef("CurveNumber", 0x00200024, "Curve Number", VR.kIS, VM.k1, true);
  static const ElementDef kLUTNumber
      //(0020,0026)
      = const ElementDef("LUTNumber", 0x00200026, "LUT Number", VR.kIS, VM.k1, true);
  static const ElementDef kImagePosition
      //(0020,0030)
      = const ElementDef("ImagePosition", 0x00200030, "Image Position", VR.kDS, VM.k3, true);
  static const ElementDef kImagePositionPatient
      //(0020,0032)
      = const ElementDef(
          "ImagePositionPatient", 0x00200032, "Image Position (Patient)", VR.kDS, VM.k3, false);
  static const ElementDef kImageOrientation
      //(0020,0035)
      = const ElementDef("ImageOrientation", 0x00200035, "Image Orientation", VR.kDS, VM.k6, true);
  static const ElementDef kImageOrientationPatient
      //(0020,0037)
      = const ElementDef("ImageOrientationPatient", 0x00200037, "Image Orientation (Patient)", VR.kDS,
          VM.k6, false);
  static const ElementDef kLocation
      //(0020,0050)
      = const ElementDef("Location", 0x00200050, "Location", VR.kDS, VM.k1, true);
  static const ElementDef kFrameOfReferenceUID
      //(0020,0052)
      = const ElementDef(
          "FrameOfReferenceUID", 0x00200052, "Frame of Reference UID", VR.kUI, VM.k1, false);
  static const ElementDef kLaterality
      //(0020,0060)
      = const ElementDef("Laterality", 0x00200060, "Laterality", VR.kCS, VM.k1, false);
  static const ElementDef kImageLaterality
      //(0020,0062)
      = const ElementDef("ImageLaterality", 0x00200062, "Image Laterality", VR.kCS, VM.k1, false);
  static const ElementDef kImageGeometryType
      //(0020,0070)
      = const ElementDef("ImageGeometryType", 0x00200070, "Image Geometry Type", VR.kLO, VM.k1, true);
  static const ElementDef kMaskingImage
      //(0020,0080)
      = const ElementDef("MaskingImage", 0x00200080, "Masking Image", VR.kCS, VM.k1_n, true);
  static const ElementDef kReportNumber
      //(0020,00AA)
      = const ElementDef("ReportNumber", 0x002000AA, "Report Number", VR.kIS, VM.k1, true);
  static const ElementDef kTemporalPositionIdentifier
      //(0020,0100)
      = const ElementDef("TemporalPositionIdentifier", 0x00200100, "Temporal Position Identifier",
          VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfTemporalPositions
      //(0020,0105)
      = const ElementDef("NumberOfTemporalPositions", 0x00200105, "Number of Temporal Positions",
          VR.kIS, VM.k1, false);
  static const ElementDef kTemporalResolution
      //(0020,0110)
      =
      const ElementDef("TemporalResolution", 0x00200110, "Temporal Resolution", VR.kDS, VM.k1, false);
  static const ElementDef kSynchronizationFrameOfReferenceUID
      //(0020,0200)
      = const ElementDef("SynchronizationFrameOfReferenceUID", 0x00200200,
          "Synchronization Frame of Reference UID", VR.kUI, VM.k1, false);
  static const ElementDef kSOPInstanceUIDOfConcatenationSource
      //(0020,0242)
      = const ElementDef("SOPInstanceUIDOfConcatenationSource", 0x00200242,
          "SOP Instance UID of Concatenation Source", VR.kUI, VM.k1, false);
  static const ElementDef kSeriesInStudy
      //(0020,1000)
      = const ElementDef("SeriesInStudy", 0x00201000, "Series in Study", VR.kIS, VM.k1, true);
  static const ElementDef kAcquisitionsInSeries
      //(0020,1001)
      = const ElementDef(
          "AcquisitionsInSeries", 0x00201001, "Acquisitions in Series", VR.kIS, VM.k1, true);
  static const ElementDef kImagesInAcquisition
      //(0020,1002)
      = const ElementDef(
          "ImagesInAcquisition", 0x00201002, "Images in Acquisition", VR.kIS, VM.k1, false);
  static const ElementDef kImagesInSeries
      //(0020,1003)
      = const ElementDef("ImagesInSeries", 0x00201003, "Images in Series", VR.kIS, VM.k1, true);
  static const ElementDef kAcquisitionsInStudy
      //(0020,1004)
      = const ElementDef(
          "AcquisitionsInStudy", 0x00201004, "Acquisitions in Study", VR.kIS, VM.k1, true);
  static const ElementDef kImagesInStudy
      //(0020,1005)
      = const ElementDef("ImagesInStudy", 0x00201005, "Images in Study", VR.kIS, VM.k1, true);
  static const ElementDef kReference
      //(0020,1020)
      = const ElementDef("Reference", 0x00201020, "Reference", VR.kLO, VM.k1_n, true);
  static const ElementDef kPositionReferenceIndicator
      //(0020,1040)
      = const ElementDef("PositionReferenceIndicator", 0x00201040, "Position Reference Indicator",
          VR.kLO, VM.k1, false);
  static const ElementDef kSliceLocation
      //(0020,1041)
      = const ElementDef("SliceLocation", 0x00201041, "Slice Location", VR.kDS, VM.k1, false);
  static const ElementDef kOtherStudyNumbers
      //(0020,1070)
      =
      const ElementDef("OtherStudyNumbers", 0x00201070, "Other Study Numbers", VR.kIS, VM.k1_n, true);
  static const ElementDef kNumberOfPatientRelatedStudies
      //(0020,1200)
      = const ElementDef("NumberOfPatientRelatedStudies", 0x00201200,
          "Number of Patient Related Studies", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfPatientRelatedSeries
      //(0020,1202)
      = const ElementDef("NumberOfPatientRelatedSeries", 0x00201202,
          "Number of Patient Related Series", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfPatientRelatedInstances
      //(0020,1204)
      = const ElementDef("NumberOfPatientRelatedInstances", 0x00201204,
          "Number of Patient Related Instances", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfStudyRelatedSeries
      //(0020,1206)
      = const ElementDef("NumberOfStudyRelatedSeries", 0x00201206, "Number of Study Related Series",
          VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfStudyRelatedInstances
      //(0020,1208)
      = const ElementDef("NumberOfStudyRelatedInstances", 0x00201208,
          "Number of Study Related Instances", VR.kIS, VM.k1, false);
  static const ElementDef kNumberOfSeriesRelatedInstances
      //(0020,1209)
      = const ElementDef("NumberOfSeriesRelatedInstances", 0x00201209,
          "Number of Series Related Instances", VR.kIS, VM.k1, false);
  static const ElementDef kSourceImageIDs
      //(0020,3100)
      = const ElementDef("SourceImageIDs", 0x00203100, "Source Image IDs", VR.kCS, VM.k1_n, true);
  static const ElementDef kModifyingDeviceID
      //(0020,3401)
      = const ElementDef("ModifyingDeviceID", 0x00203401, "Modifying Device ID", VR.kCS, VM.k1, true);
  static const ElementDef kModifiedImageID
      //(0020,3402)
      = const ElementDef("ModifiedImageID", 0x00203402, "Modified Image ID", VR.kCS, VM.k1, true);
  static const ElementDef kModifiedImageDate
      //(0020,3403)
      = const ElementDef("ModifiedImageDate", 0x00203403, "Modified Image Date", VR.kDA, VM.k1, true);
  static const ElementDef kModifyingDeviceManufacturer
      //(0020,3404)
      = const ElementDef("ModifyingDeviceManufacturer", 0x00203404, "Modifying Device Manufacturer",
          VR.kLO, VM.k1, true);
  static const ElementDef kModifiedImageTime
      //(0020,3405)
      = const ElementDef("ModifiedImageTime", 0x00203405, "Modified Image Time", VR.kTM, VM.k1, true);
  static const ElementDef kModifiedImageDescription
      //(0020,3406)
      = const ElementDef("ModifiedImageDescription", 0x00203406, "Modified Image Description", VR.kLO,
          VM.k1, true);
  static const ElementDef kImageComments
      //(0020,4000)
      = const ElementDef("ImageComments", 0x00204000, "Image Comments", VR.kLT, VM.k1, false);
  static const ElementDef kOriginalImageIdentification
      //(0020,5000)
      = const ElementDef("OriginalImageIdentification", 0x00205000, "Original Image Identification",
          VR.kAT, VM.k1_n, true);
  static const ElementDef kOriginalImageIdentificationNomenclature
      //(0020,5002)
      = const ElementDef("OriginalImageIdentificationNomenclature", 0x00205002,
          "Original Image Identification Nomenclature", VR.kLO, VM.k1_n, true);
  static const ElementDef kStackID
      //(0020,9056)
      = const ElementDef("StackID", 0x00209056, "Stack ID", VR.kSH, VM.k1, false);
  static const ElementDef kInStackPositionNumber
      //(0020,9057)
      = const ElementDef(
          "InStackPositionNumber", 0x00209057, "In-Stack Position Number", VR.kUL, VM.k1, false);
  static const ElementDef kFrameAnatomySequence
      //(0020,9071)
      = const ElementDef(
          "FrameAnatomySequence", 0x00209071, "Frame Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFrameLaterality
      //(0020,9072)
      = const ElementDef("FrameLaterality", 0x00209072, "Frame Laterality", VR.kCS, VM.k1, false);
  static const ElementDef kFrameContentSequence
      //(0020,9111)
      = const ElementDef(
          "FrameContentSequence", 0x00209111, "Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlanePositionSequence
      //(0020,9113)
      = const ElementDef(
          "PlanePositionSequence", 0x00209113, "Plane Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlaneOrientationSequence
      //(0020,9116)
      = const ElementDef("PlaneOrientationSequence", 0x00209116, "Plane Orientation Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kTemporalPositionIndex
      //(0020,9128)
      = const ElementDef(
          "TemporalPositionIndex", 0x00209128, "Temporal Position Index", VR.kUL, VM.k1, false);
  static const ElementDef kNominalCardiacTriggerDelayTime
      //(0020,9153)
      = const ElementDef("NominalCardiacTriggerDelayTime", 0x00209153,
          "Nominal Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const ElementDef kNominalCardiacTriggerTimePriorToRPeak
      //(0020,9154)
      = const ElementDef("NominalCardiacTriggerTimePriorToRPeak", 0x00209154,
          "Nominal Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const ElementDef kActualCardiacTriggerTimePriorToRPeak
      //(0020,9155)
      = const ElementDef("ActualCardiacTriggerTimePriorToRPeak", 0x00209155,
          "Actual Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const ElementDef kFrameAcquisitionNumber
      //(0020,9156)
      = const ElementDef(
          "FrameAcquisitionNumber", 0x00209156, "Frame Acquisition Number", VR.kUS, VM.k1, false);
  static const ElementDef kDimensionIndexValues
      //(0020,9157)
      = const ElementDef(
          "DimensionIndexValues", 0x00209157, "Dimension Index Values", VR.kUL, VM.k1_n, false);
  static const ElementDef kFrameComments
      //(0020,9158)
      = const ElementDef("FrameComments", 0x00209158, "Frame Comments", VR.kLT, VM.k1, false);
  static const ElementDef kConcatenationUID
      //(0020,9161)
      = const ElementDef("ConcatenationUID", 0x00209161, "Concatenation UID", VR.kUI, VM.k1, false);
  static const ElementDef kInConcatenationNumber
      //(0020,9162)
      = const ElementDef(
          "InConcatenationNumber", 0x00209162, "In-concatenation Number", VR.kUS, VM.k1, false);
  static const ElementDef kInConcatenationTotalNumber
      //(0020,9163)
      = const ElementDef("InConcatenationTotalNumber", 0x00209163, "In-concatenation Total Number",
          VR.kUS, VM.k1, false);
  static const ElementDef kDimensionOrganizationUID
      //(0020,9164)
      = const ElementDef("DimensionOrganizationUID", 0x00209164, "Dimension Organization UID", VR.kUI,
          VM.k1, false);
  static const ElementDef kDimensionIndexPointer
      //(0020,9165)
      = const ElementDef(
          "DimensionIndexPointer", 0x00209165, "Dimension Index Pointer", VR.kAT, VM.k1, false);
  static const ElementDef kFunctionalGroupPointer
      //(0020,9167)
      = const ElementDef(
          "FunctionalGroupPointer", 0x00209167, "Functional Group Pointer", VR.kAT, VM.k1, false);
  static const ElementDef kUnassignedSharedConvertedAttributesSequence
      //(0020,9170)
      = const ElementDef("UnassignedSharedConvertedAttributesSequence", 0x00209170,
          "Unassigned Shared Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUnassignedPerFrameConvertedAttributesSequence
      //(0020,9171)
      = const ElementDef("UnassignedPerFrameConvertedAttributesSequence", 0x00209171,
          "Unassigned Per-Frame Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kConversionSourceAttributesSequence
      //(0020,9172)
      = const ElementDef("ConversionSourceAttributesSequence", 0x00209172,
          "Conversion Source Attributes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDimensionIndexPrivateCreator
      //(0020,9213)
      = const ElementDef("DimensionIndexPrivateCreator", 0x00209213, "Dimension Index Private Creator",
          VR.kLO, VM.k1, false);
  static const ElementDef kDimensionOrganizationSequence
      //(0020,9221)
      = const ElementDef("DimensionOrganizationSequence", 0x00209221,
          "Dimension Organization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDimensionIndexSequence
      //(0020,9222)
      = const ElementDef(
          "DimensionIndexSequence", 0x00209222, "Dimension Index Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kConcatenationFrameOffsetNumber
      //(0020,9228)
      = const ElementDef("ConcatenationFrameOffsetNumber", 0x00209228,
          "Concatenation Frame Offset Number", VR.kUL, VM.k1, false);
  static const ElementDef kFunctionalGroupPrivateCreator
      //(0020,9238)
      = const ElementDef("FunctionalGroupPrivateCreator", 0x00209238,
          "Functional Group Private Creator", VR.kLO, VM.k1, false);
  static const ElementDef kNominalPercentageOfCardiacPhase
      //(0020,9241)
      = const ElementDef("NominalPercentageOfCardiacPhase", 0x00209241,
          "Nominal Percentage of Cardiac Phase", VR.kFL, VM.k1, false);
  static const ElementDef kNominalPercentageOfRespiratoryPhase
      //(0020,9245)
      = const ElementDef("NominalPercentageOfRespiratoryPhase", 0x00209245,
          "Nominal Percentage of Respiratory Phase", VR.kFL, VM.k1, false);
  static const ElementDef kStartingRespiratoryAmplitude
      //(0020,9246)
      = const ElementDef("StartingRespiratoryAmplitude", 0x00209246, "Starting Respiratory Amplitude",
          VR.kFL, VM.k1, false);
  static const ElementDef kStartingRespiratoryPhase
      //(0020,9247)
      = const ElementDef("StartingRespiratoryPhase", 0x00209247, "Starting Respiratory Phase", VR.kCS,
          VM.k1, false);
  static const ElementDef kEndingRespiratoryAmplitude
      //(0020,9248)
      = const ElementDef("EndingRespiratoryAmplitude", 0x00209248, "Ending Respiratory Amplitude",
          VR.kFL, VM.k1, false);
  static const ElementDef kEndingRespiratoryPhase
      //(0020,9249)
      = const ElementDef(
          "EndingRespiratoryPhase", 0x00209249, "Ending Respiratory Phase", VR.kCS, VM.k1, false);
  static const ElementDef kRespiratoryTriggerType
      //(0020,9250)
      = const ElementDef(
          "RespiratoryTriggerType", 0x00209250, "Respiratory Trigger Type", VR.kCS, VM.k1, false);
  static const ElementDef kRRIntervalTimeNominal
      //(0020,9251)
      = const ElementDef(
          "RRIntervalTimeNominal", 0x00209251, "R-R Interval Time Nominal", VR.kFD, VM.k1, false);
  static const ElementDef kActualCardiacTriggerDelayTime
      //(0020,9252)
      = const ElementDef("ActualCardiacTriggerDelayTime", 0x00209252,
          "Actual Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const ElementDef kRespiratorySynchronizationSequence
      //(0020,9253)
      = const ElementDef("RespiratorySynchronizationSequence", 0x00209253,
          "Respiratory Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRespiratoryIntervalTime
      //(0020,9254)
      = const ElementDef(
          "RespiratoryIntervalTime", 0x00209254, "Respiratory Interval Time", VR.kFD, VM.k1, false);
  static const ElementDef kNominalRespiratoryTriggerDelayTime
      //(0020,9255)
      = const ElementDef("NominalRespiratoryTriggerDelayTime", 0x00209255,
          "Nominal Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const ElementDef kRespiratoryTriggerDelayThreshold
      //(0020,9256)
      = const ElementDef("RespiratoryTriggerDelayThreshold", 0x00209256,
          "Respiratory Trigger Delay Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kActualRespiratoryTriggerDelayTime
      //(0020,9257)
      = const ElementDef("ActualRespiratoryTriggerDelayTime", 0x00209257,
          "Actual Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const ElementDef kImagePositionVolume
      //(0020,9301)
      = const ElementDef(
          "ImagePositionVolume", 0x00209301, "Image Position (Volume)", VR.kFD, VM.k3, false);
  static const ElementDef kImageOrientationVolume
      //(0020,9302)
      = const ElementDef(
          "ImageOrientationVolume", 0x00209302, "Image Orientation (Volume)", VR.kFD, VM.k6, false);
  static const ElementDef kUltrasoundAcquisitionGeometry
      //(0020,9307)
      = const ElementDef("UltrasoundAcquisitionGeometry", 0x00209307,
          "Ultrasound Acquisition Geometry", VR.kCS, VM.k1, false);
  static const ElementDef kApexPosition
      //(0020,9308)
      = const ElementDef("ApexPosition", 0x00209308, "Apex Position", VR.kFD, VM.k3, false);
  static const ElementDef kVolumeToTransducerMappingMatrix
      //(0020,9309)
      = const ElementDef("VolumeToTransducerMappingMatrix", 0x00209309,
          "Volume to Transducer Mapping Matrix", VR.kFD, VM.k16, false);
  static const ElementDef kVolumeToTableMappingMatrix
      //(0020,930A)
      = const ElementDef("VolumeToTableMappingMatrix", 0x0020930A, "Volume to Table Mapping Matrix",
          VR.kFD, VM.k16, false);
  static const ElementDef kPatientFrameOfReferenceSource
      //(0020,930C)
      = const ElementDef("PatientFrameOfReferenceSource", 0x0020930C,
          "Patient Frame of Reference Source", VR.kCS, VM.k1, false);
  static const ElementDef kTemporalPositionTimeOffset
      //(0020,930D)
      = const ElementDef("TemporalPositionTimeOffset", 0x0020930D, "Temporal Position Time Offset",
          VR.kFD, VM.k1, false);
  static const ElementDef kPlanePositionVolumeSequence
      //(0020,930E)
      = const ElementDef("PlanePositionVolumeSequence", 0x0020930E, "Plane Position (Volume) Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPlaneOrientationVolumeSequence
      //(0020,930F)
      = const ElementDef("PlaneOrientationVolumeSequence", 0x0020930F,
          "Plane Orientation (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTemporalPositionSequence
      //(0020,9310)
      = const ElementDef("TemporalPositionSequence", 0x00209310, "Temporal Position Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kDimensionOrganizationType
      //(0020,9311)
      = const ElementDef("DimensionOrganizationType", 0x00209311, "Dimension Organization Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kVolumeFrameOfReferenceUID
      //(0020,9312)
      = const ElementDef("VolumeFrameOfReferenceUID", 0x00209312, "Volume Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const ElementDef kTableFrameOfReferenceUID
      //(0020,9313)
      = const ElementDef("TableFrameOfReferenceUID", 0x00209313, "Table Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const ElementDef kDimensionDescriptionLabel
      //(0020,9421)
      = const ElementDef("DimensionDescriptionLabel", 0x00209421, "Dimension Description Label",
          VR.kLO, VM.k1, false);
  static const ElementDef kPatientOrientationInFrameSequence
      //(0020,9450)
      = const ElementDef("PatientOrientationInFrameSequence", 0x00209450,
          "Patient Orientation in Frame Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFrameLabel
      //(0020,9453)
      = const ElementDef("FrameLabel", 0x00209453, "Frame Label", VR.kLO, VM.k1, false);
  static const ElementDef kAcquisitionIndex
      //(0020,9518)
      = const ElementDef("AcquisitionIndex", 0x00209518, "Acquisition Index", VR.kUS, VM.k1_n, false);
  static const ElementDef kContributingSOPInstancesReferenceSequence
      //(0020,9529)
      = const ElementDef("ContributingSOPInstancesReferenceSequence", 0x00209529,
          "Contributing SOP Instances Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReconstructionIndex
      //(0020,9536)
      = const ElementDef(
          "ReconstructionIndex", 0x00209536, "Reconstruction Index", VR.kUS, VM.k1, false);
  static const ElementDef kLightPathFilterPassThroughWavelength
      //(0022,0001)
      = const ElementDef("LightPathFilterPassThroughWavelength", 0x00220001,
          "Light Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const ElementDef kLightPathFilterPassBand
      //(0022,0002)
      = const ElementDef("LightPathFilterPassBand", 0x00220002, "Light Path Filter Pass Band", VR.kUS,
          VM.k2, false);
  static const ElementDef kImagePathFilterPassThroughWavelength
      //(0022,0003)
      = const ElementDef("ImagePathFilterPassThroughWavelength", 0x00220003,
          "Image Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const ElementDef kImagePathFilterPassBand
      //(0022,0004)
      = const ElementDef("ImagePathFilterPassBand", 0x00220004, "Image Path Filter Pass Band", VR.kUS,
          VM.k2, false);
  static const ElementDef kPatientEyeMovementCommanded
      //(0022,0005)
      = const ElementDef("PatientEyeMovementCommanded", 0x00220005, "Patient Eye Movement Commanded",
          VR.kCS, VM.k1, false);
  static const ElementDef kPatientEyeMovementCommandCodeSequence
      //(0022,0006)
      = const ElementDef("PatientEyeMovementCommandCodeSequence", 0x00220006,
          "Patient Eye Movement Command Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSphericalLensPower
      //(0022,0007)
      =
      const ElementDef("SphericalLensPower", 0x00220007, "Spherical Lens Power", VR.kFL, VM.k1, false);
  static const ElementDef kCylinderLensPower
      //(0022,0008)
      = const ElementDef("CylinderLensPower", 0x00220008, "Cylinder Lens Power", VR.kFL, VM.k1, false);
  static const ElementDef kCylinderAxis
      //(0022,0009)
      = const ElementDef("CylinderAxis", 0x00220009, "Cylinder Axis", VR.kFL, VM.k1, false);
  static const ElementDef kEmmetropicMagnification
      //(0022,000A)
      = const ElementDef(
          "EmmetropicMagnification", 0x0022000A, "Emmetropic Magnification", VR.kFL, VM.k1, false);
  static const ElementDef kIntraOcularPressure
      //(0022,000B)
      = const ElementDef(
          "IntraOcularPressure", 0x0022000B, "Intra Ocular Pressure", VR.kFL, VM.k1, false);
  static const ElementDef kHorizontalFieldOfView
      //(0022,000C)
      = const ElementDef(
          "HorizontalFieldOfView", 0x0022000C, "Horizontal Field of View", VR.kFL, VM.k1, false);
  static const ElementDef kPupilDilated
      //(0022,000D)
      = const ElementDef("PupilDilated", 0x0022000D, "Pupil Dilated", VR.kCS, VM.k1, false);
  static const ElementDef kDegreeOfDilation
      //(0022,000E)
      = const ElementDef("DegreeOfDilation", 0x0022000E, "Degree of Dilation", VR.kFL, VM.k1, false);
  static const ElementDef kStereoBaselineAngle
      //(0022,0010)
      = const ElementDef(
          "StereoBaselineAngle", 0x00220010, "Stereo Baseline Angle", VR.kFL, VM.k1, false);
  static const ElementDef kStereoBaselineDisplacement
      //(0022,0011)
      = const ElementDef("StereoBaselineDisplacement", 0x00220011, "Stereo Baseline Displacement",
          VR.kFL, VM.k1, false);
  static const ElementDef kStereoHorizontalPixelOffset
      //(0022,0012)
      = const ElementDef("StereoHorizontalPixelOffset", 0x00220012, "Stereo Horizontal Pixel Offset",
          VR.kFL, VM.k1, false);
  static const ElementDef kStereoVerticalPixelOffset
      //(0022,0013)
      = const ElementDef("StereoVerticalPixelOffset", 0x00220013, "Stereo Vertical Pixel Offset",
          VR.kFL, VM.k1, false);
  static const ElementDef kStereoRotation
      //(0022,0014)
      = const ElementDef("StereoRotation", 0x00220014, "Stereo Rotation", VR.kFL, VM.k1, false);
  static const ElementDef kAcquisitionDeviceTypeCodeSequence
      //(0022,0015)
      = const ElementDef("AcquisitionDeviceTypeCodeSequence", 0x00220015,
          "Acquisition Device Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIlluminationTypeCodeSequence
      //(0022,0016)
      = const ElementDef("IlluminationTypeCodeSequence", 0x00220016, "Illumination Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kLightPathFilterTypeStackCodeSequence
      //(0022,0017)
      = const ElementDef("LightPathFilterTypeStackCodeSequence", 0x00220017,
          "Light Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImagePathFilterTypeStackCodeSequence
      //(0022,0018)
      = const ElementDef("ImagePathFilterTypeStackCodeSequence", 0x00220018,
          "Image Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLensesCodeSequence
      //(0022,0019)
      =
      const ElementDef("LensesCodeSequence", 0x00220019, "Lenses Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelDescriptionCodeSequence
      //(0022,001A)
      = const ElementDef("ChannelDescriptionCodeSequence", 0x0022001A,
          "Channel Description Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRefractiveStateSequence
      //(0022,001B)
      = const ElementDef(
          "RefractiveStateSequence", 0x0022001B, "Refractive State Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMydriaticAgentCodeSequence
      //(0022,001C)
      = const ElementDef("MydriaticAgentCodeSequence", 0x0022001C, "Mydriatic Agent Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRelativeImagePositionCodeSequence
      //(0022,001D)
      = const ElementDef("RelativeImagePositionCodeSequence", 0x0022001D,
          "Relative Image Position Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCameraAngleOfView
      //(0022,001E)
      =
      const ElementDef("CameraAngleOfView", 0x0022001E, "Camera Angle of View", VR.kFL, VM.k1, false);
  static const ElementDef kStereoPairsSequence
      //(0022,0020)
      = const ElementDef(
          "StereoPairsSequence", 0x00220020, "Stereo Pairs Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLeftImageSequence
      //(0022,0021)
      = const ElementDef("LeftImageSequence", 0x00220021, "Left Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRightImageSequence
      //(0022,0022)
      =
      const ElementDef("RightImageSequence", 0x00220022, "Right Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAxialLengthOfTheEye
      //(0022,0030)
      = const ElementDef(
          "AxialLengthOfTheEye", 0x00220030, "Axial Length of the Eye", VR.kFL, VM.k1, false);
  static const ElementDef kOphthalmicFrameLocationSequence
      //(0022,0031)
      = const ElementDef("OphthalmicFrameLocationSequence", 0x00220031,
          "Ophthalmic Frame Location Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferenceCoordinates
      //(0022,0032)
      = const ElementDef(
          "ReferenceCoordinates", 0x00220032, "Reference Coordinates", VR.kFL, VM.k2_2n, false);
  static const ElementDef kDepthSpatialResolution
      //(0022,0035)
      = const ElementDef(
          "DepthSpatialResolution", 0x00220035, "Depth Spatial Resolution", VR.kFL, VM.k1, false);
  static const ElementDef kMaximumDepthDistortion
      //(0022,0036)
      = const ElementDef(
          "MaximumDepthDistortion", 0x00220036, "Maximum Depth Distortion", VR.kFL, VM.k1, false);
  static const ElementDef kAlongScanSpatialResolution
      //(0022,0037)
      = const ElementDef("AlongScanSpatialResolution", 0x00220037, "Along-scan Spatial Resolution",
          VR.kFL, VM.k1, false);
  static const ElementDef kMaximumAlongScanDistortion
      //(0022,0038)
      = const ElementDef("MaximumAlongScanDistortion", 0x00220038, "Maximum Along-scan Distortion",
          VR.kFL, VM.k1, false);
  static const ElementDef kOphthalmicImageOrientation
      //(0022,0039)
      = const ElementDef("OphthalmicImageOrientation", 0x00220039, "Ophthalmic Image Orientation",
          VR.kCS, VM.k1, false);
  static const ElementDef kDepthOfTransverseImage
      //(0022,0041)
      = const ElementDef(
          "DepthOfTransverseImage", 0x00220041, "Depth of Transverse Image", VR.kFL, VM.k1, false);
  static const ElementDef kMydriaticAgentConcentrationUnitsSequence
      //(0022,0042)
      = const ElementDef("MydriaticAgentConcentrationUnitsSequence", 0x00220042,
          "Mydriatic Agent Concentration Units Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAcrossScanSpatialResolution
      //(0022,0048)
      = const ElementDef("AcrossScanSpatialResolution", 0x00220048, "Across-scan Spatial Resolution",
          VR.kFL, VM.k1, false);
  static const ElementDef kMaximumAcrossScanDistortion
      //(0022,0049)
      = const ElementDef("MaximumAcrossScanDistortion", 0x00220049, "Maximum Across-scan Distortion",
          VR.kFL, VM.k1, false);
  static const ElementDef kMydriaticAgentConcentration
      //(0022,004E)
      = const ElementDef("MydriaticAgentConcentration", 0x0022004E, "Mydriatic Agent Concentration",
          VR.kDS, VM.k1, false);
  static const ElementDef kIlluminationWaveLength
      //(0022,0055)
      = const ElementDef(
          "IlluminationWaveLength", 0x00220055, "Illumination Wave Length", VR.kFL, VM.k1, false);
  static const ElementDef kIlluminationPower
      //(0022,0056)
      = const ElementDef("IlluminationPower", 0x00220056, "Illumination Power", VR.kFL, VM.k1, false);
  static const ElementDef kIlluminationBandwidth
      //(0022,0057)
      = const ElementDef(
          "IlluminationBandwidth", 0x00220057, "Illumination Bandwidth", VR.kFL, VM.k1, false);
  static const ElementDef kMydriaticAgentSequence
      //(0022,0058)
      = const ElementDef(
          "MydriaticAgentSequence", 0x00220058, "Mydriatic Agent Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialMeasurementsRightEyeSequence
      //(0022,1007)
      = const ElementDef("OphthalmicAxialMeasurementsRightEyeSequence", 0x00221007,
          "Ophthalmic Axial Measurements Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialMeasurementsLeftEyeSequence
      //(0022,1008)
      = const ElementDef("OphthalmicAxialMeasurementsLeftEyeSequence", 0x00221008,
          "Ophthalmic Axial Measurements Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialMeasurementsDeviceType
      //(0022,1009)
      = const ElementDef("OphthalmicAxialMeasurementsDeviceType", 0x00221009,
          "Ophthalmic Axial Measurements Device Type", VR.kCS, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsType
      //(0022,1010)
      = const ElementDef("OphthalmicAxialLengthMeasurementsType", 0x00221010,
          "Ophthalmic Axial Length Measurements Type", VR.kCS, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthSequence
      //(0022,1012)
      = const ElementDef("OphthalmicAxialLengthSequence", 0x00221012,
          "Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLength
      //(0022,1019)
      = const ElementDef(
          "OphthalmicAxialLength", 0x00221019, "Ophthalmic Axial Length", VR.kFL, VM.k1, false);
  static const ElementDef kLensStatusCodeSequence
      //(0022,1024)
      = const ElementDef(
          "LensStatusCodeSequence", 0x00221024, "Lens Status Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVitreousStatusCodeSequence
      //(0022,1025)
      = const ElementDef("VitreousStatusCodeSequence", 0x00221025, "Vitreous Status Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kIOLFormulaCodeSequence
      //(0022,1028)
      = const ElementDef(
          "IOLFormulaCodeSequence", 0x00221028, "IOL Formula Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIOLFormulaDetail
      //(0022,1029)
      = const ElementDef("IOLFormulaDetail", 0x00221029, "IOL Formula Detail", VR.kLO, VM.k1, false);
  static const ElementDef kKeratometerIndex
      //(0022,1033)
      = const ElementDef("KeratometerIndex", 0x00221033, "Keratometer Index", VR.kFL, VM.k1, false);
  static const ElementDef kSourceOfOphthalmicAxialLengthCodeSequence
      //(0022,1035)
      = const ElementDef("SourceOfOphthalmicAxialLengthCodeSequence", 0x00221035,
          "Source of Ophthalmic Axial Length Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTargetRefraction
      //(0022,1037)
      = const ElementDef("TargetRefraction", 0x00221037, "Target Refraction", VR.kFL, VM.k1, false);
  static const ElementDef kRefractiveProcedureOccurred
      //(0022,1039)
      = const ElementDef("RefractiveProcedureOccurred", 0x00221039, "Refractive Procedure Occurred",
          VR.kCS, VM.k1, false);
  static const ElementDef kRefractiveSurgeryTypeCodeSequence
      //(0022,1040)
      = const ElementDef("RefractiveSurgeryTypeCodeSequence", 0x00221040,
          "Refractive Surgery Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicUltrasoundMethodCodeSequence
      //(0022,1044)
      = const ElementDef("OphthalmicUltrasoundMethodCodeSequence", 0x00221044,
          "Ophthalmic Ultrasound Method Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsSequence
      //(0022,1050)
      = const ElementDef("OphthalmicAxialLengthMeasurementsSequence", 0x00221050,
          "Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIOLPower
      //(0022,1053)
      = const ElementDef("IOLPower", 0x00221053, "IOL Power", VR.kFL, VM.k1, false);
  static const ElementDef kPredictedRefractiveError
      //(0022,1054)
      = const ElementDef("PredictedRefractiveError", 0x00221054, "Predicted Refractive Error", VR.kFL,
          VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthVelocity
      //(0022,1059)
      = const ElementDef("OphthalmicAxialLengthVelocity", 0x00221059,
          "Ophthalmic Axial Length Velocity", VR.kFL, VM.k1, false);
  static const ElementDef kLensStatusDescription
      //(0022,1065)
      = const ElementDef(
          "LensStatusDescription", 0x00221065, "Lens Status Description", VR.kLO, VM.k1, false);
  static const ElementDef kVitreousStatusDescription
      //(0022,1066)
      = const ElementDef("VitreousStatusDescription", 0x00221066, "Vitreous Status Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kIOLPowerSequence
      //(0022,1090)
      = const ElementDef("IOLPowerSequence", 0x00221090, "IOL Power Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLensConstantSequence
      //(0022,1092)
      = const ElementDef(
          "LensConstantSequence", 0x00221092, "Lens Constant Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIOLManufacturer
      //(0022,1093)
      = const ElementDef("IOLManufacturer", 0x00221093, "IOL Manufacturer", VR.kLO, VM.k1, false);
  static const ElementDef kLensConstantDescription
      //(0022,1094)
      = const ElementDef(
          "LensConstantDescription", 0x00221094, "Lens Constant Description", VR.kLO, VM.k1, true);
  static const ElementDef kImplantName
      //(0022,1095)
      = const ElementDef("ImplantName", 0x00221095, "Implant Name", VR.kLO, VM.k1, false);
  static const ElementDef kKeratometryMeasurementTypeCodeSequence
      //(0022,1096)
      = const ElementDef("KeratometryMeasurementTypeCodeSequence", 0x00221096,
          "Keratometry Measurement Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantPartNumber
      //(0022,1097)
      = const ElementDef("ImplantPartNumber", 0x00221097, "Implant Part Number", VR.kLO, VM.k1, false);
  static const ElementDef kReferencedOphthalmicAxialMeasurementsSequence
      //(0022,1100)
      = const ElementDef("ReferencedOphthalmicAxialMeasurementsSequence", 0x00221100,
          "Referenced Ophthalmic Axial Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsSegmentNameCodeSequence
      //(0022,1101)
      = const ElementDef("OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence", 0x00221101,
          "Ophthalmic Axial Length Measurements Segment Name Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRefractiveErrorBeforeRefractiveSurgeryCodeSequence
      //(0022,1103)
      = const ElementDef("RefractiveErrorBeforeRefractiveSurgeryCodeSequence", 0x00221103,
          "Refractive Error Before Refractive Surgery Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIOLPowerForExactEmmetropia
      //(0022,1121)
      = const ElementDef("IOLPowerForExactEmmetropia", 0x00221121, "IOL Power For Exact Emmetropia",
          VR.kFL, VM.k1, false);
  static const ElementDef kIOLPowerForExactTargetRefraction
      //(0022,1122)
      = const ElementDef("IOLPowerForExactTargetRefraction", 0x00221122,
          "IOL Power For Exact Target Refraction", VR.kFL, VM.k1, false);
  static const ElementDef kAnteriorChamberDepthDefinitionCodeSequence
      //(0022,1125)
      = const ElementDef("AnteriorChamberDepthDefinitionCodeSequence", 0x00221125,
          "Anterior Chamber Depth Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLensThicknessSequence
      //(0022,1127)
      = const ElementDef(
          "LensThicknessSequence", 0x00221127, "Lens Thickness Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAnteriorChamberDepthSequence
      //(0022,1128)
      = const ElementDef("AnteriorChamberDepthSequence", 0x00221128, "Anterior Chamber Depth Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kLensThickness
      //(0022,1130)
      = const ElementDef("LensThickness", 0x00221130, "Lens Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kAnteriorChamberDepth
      //(0022,1131)
      = const ElementDef(
          "AnteriorChamberDepth", 0x00221131, "Anterior Chamber Depth", VR.kFL, VM.k1, false);
  static const ElementDef kSourceOfLensThicknessDataCodeSequence
      //(0022,1132)
      = const ElementDef("SourceOfLensThicknessDataCodeSequence", 0x00221132,
          "Source of Lens Thickness Data Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceOfAnteriorChamberDepthDataCodeSequence
      //(0022,1133)
      = const ElementDef("SourceOfAnteriorChamberDepthDataCodeSequence", 0x00221133,
          "Source of Anterior Chamber Depth Data Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceOfRefractiveMeasurementsSequence
      //(0022,1134)
      = const ElementDef("SourceOfRefractiveMeasurementsSequence", 0x00221134,
          "Source of Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceOfRefractiveMeasurementsCodeSequence
      //(0022,1135)
      = const ElementDef("SourceOfRefractiveMeasurementsCodeSequence", 0x00221135,
          "Source of Refractive Measurements Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementModified
      //(0022,1140)
      = const ElementDef("OphthalmicAxialLengthMeasurementModified", 0x00221140,
          "Ophthalmic Axial Length Measurement Modified", VR.kCS, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthDataSourceCodeSequence
      //(0022,1150)
      = const ElementDef("OphthalmicAxialLengthDataSourceCodeSequence", 0x00221150,
          "Ophthalmic Axial Length Data Source Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthAcquisitionMethodCodeSequence
      //(0022,1153)
      = const ElementDef("OphthalmicAxialLengthAcquisitionMethodCodeSequence", 0x00221153,
          "Ophthalmic Axial Length Acquisition Method Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kSignalToNoiseRatio
      //(0022,1155)
      = const ElementDef(
          "SignalToNoiseRatio", 0x00221155, "Signal to Noise Ratio", VR.kFL, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthDataSourceDescription
      //(0022,1159)
      = const ElementDef("OphthalmicAxialLengthDataSourceDescription", 0x00221159,
          "Ophthalmic Axial Length Data Source Description", VR.kLO, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsTotalLengthSequence
      //(0022,1210)
      = const ElementDef("OphthalmicAxialLengthMeasurementsTotalLengthSequence", 0x00221210,
          "Ophthalmic Axial Length Measurements Total Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsSegmentalLengthSequence
      //(0022,1211)
      = const ElementDef("OphthalmicAxialLengthMeasurementsSegmentalLengthSequence", 0x00221211,
          "Ophthalmic Axial Length Measurements Segmental Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthMeasurementsLengthSummationSequence
      //(0022,1212)
      = const ElementDef("OphthalmicAxialLengthMeasurementsLengthSummationSequence", 0x00221212,
          "Ophthalmic Axial Length Measurements Length Summation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUltrasoundOphthalmicAxialLengthMeasurementsSequence
      //(0022,1220)
      = const ElementDef("UltrasoundOphthalmicAxialLengthMeasurementsSequence", 0x00221220,
          "Ultrasound Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOpticalOphthalmicAxialLengthMeasurementsSequence
      //(0022,1225)
      = const ElementDef("OpticalOphthalmicAxialLengthMeasurementsSequence", 0x00221225,
          "Optical Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUltrasoundSelectedOphthalmicAxialLengthSequence
      //(0022,1230)
      = const ElementDef("UltrasoundSelectedOphthalmicAxialLengthSequence", 0x00221230,
          "Ultrasound Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthSelectionMethodCodeSequence
      //(0022,1250)
      = const ElementDef("OphthalmicAxialLengthSelectionMethodCodeSequence", 0x00221250,
          "Ophthalmic Axial Length Selection Method Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOpticalSelectedOphthalmicAxialLengthSequence
      //(0022,1255)
      = const ElementDef("OpticalSelectedOphthalmicAxialLengthSequence", 0x00221255,
          "Optical Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSelectedSegmentalOphthalmicAxialLengthSequence
      //(0022,1257)
      = const ElementDef("SelectedSegmentalOphthalmicAxialLengthSequence", 0x00221257,
          "Selected Segmental Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSelectedTotalOphthalmicAxialLengthSequence
      //(0022,1260)
      = const ElementDef("SelectedTotalOphthalmicAxialLengthSequence", 0x00221260,
          "Selected Total Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthQualityMetricSequence
      //(0022,1262)
      = const ElementDef("OphthalmicAxialLengthQualityMetricSequence", 0x00221262,
          "Ophthalmic Axial Length Quality Metric Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicAxialLengthQualityMetricTypeCodeSequence
      //(0022,1265)
      = const ElementDef("OphthalmicAxialLengthQualityMetricTypeCodeSequence", 0x00221265,
          "Ophthalmic Axial Length Quality Metric Type Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kOphthalmicAxialLengthQualityMetricTypeDescription
      //(0022,1273)
      = const ElementDef("OphthalmicAxialLengthQualityMetricTypeDescription", 0x00221273,
          "Ophthalmic Axial Length Quality Metric Type Description", VR.kLO, VM.k1, true);
  static const ElementDef kIntraocularLensCalculationsRightEyeSequence
      //(0022,1300)
      = const ElementDef("IntraocularLensCalculationsRightEyeSequence", 0x00221300,
          "Intraocular Lens Calculations Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIntraocularLensCalculationsLeftEyeSequence
      //(0022,1310)
      = const ElementDef("IntraocularLensCalculationsLeftEyeSequence", 0x00221310,
          "Intraocular Lens Calculations Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedOphthalmicAxialLengthMeasurementQCImageSequence
      //(0022,1330)
      = const ElementDef("ReferencedOphthalmicAxialLengthMeasurementQCImageSequence", 0x00221330,
          "Referenced Ophthalmic Axial Length Measurement QC Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicMappingDeviceType
      //(0022,1415)
      = const ElementDef("OphthalmicMappingDeviceType", 0x00221415, "Ophthalmic Mapping Device Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kAcquisitionMethodCodeSequence
      //(0022,1420)
      = const ElementDef("AcquisitionMethodCodeSequence", 0x00221420,
          "Acquisition Method Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAcquisitionMethodAlgorithmSequence
      //(0022,1423)
      = const ElementDef("AcquisitionMethodAlgorithmSequence", 0x00221423,
          "Acquisition Method Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicThicknessMapTypeCodeSequence
      //(0022,1436)
      = const ElementDef("OphthalmicThicknessMapTypeCodeSequence", 0x00221436,
          "Ophthalmic Thickness Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicThicknessMappingNormalsSequence
      //(0022,1443)
      = const ElementDef("OphthalmicThicknessMappingNormalsSequence", 0x00221443,
          "Ophthalmic Thickness Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRetinalThicknessDefinitionCodeSequence
      //(0022,1445)
      = const ElementDef("RetinalThicknessDefinitionCodeSequence", 0x00221445,
          "Retinal Thickness Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPixelValueMappingToCodedConceptSequence
      //(0022,1450)
      = const ElementDef("PixelValueMappingToCodedConceptSequence", 0x00221450,
          "Pixel Value Mapping to Coded Concept Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMappedPixelValue
      //(0022,1452)
      = const ElementDef("MappedPixelValue", 0x00221452, "Mapped Pixel Value", VR.kUSSS, VM.k1, false);
  static const ElementDef kPixelValueMappingExplanation
      //(0022,1454)
      = const ElementDef("PixelValueMappingExplanation", 0x00221454, "Pixel Value Mapping Explanation",
          VR.kLO, VM.k1, false);
  static const ElementDef kOphthalmicThicknessMapQualityThresholdSequence
      //(0022,1458)
      = const ElementDef("OphthalmicThicknessMapQualityThresholdSequence", 0x00221458,
          "Ophthalmic Thickness Map Quality Threshold Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicThicknessMapThresholdQualityRating
      //(0022,1460)
      = const ElementDef("OphthalmicThicknessMapThresholdQualityRating", 0x00221460,
          "Ophthalmic Thickness Map Threshold Quality Rating", VR.kFL, VM.k1, false);
  static const ElementDef kAnatomicStructureReferencePoint
      //(0022,1463)
      = const ElementDef("AnatomicStructureReferencePoint", 0x00221463,
          "Anatomic Structure Reference Point", VR.kFL, VM.k2, false);
  static const ElementDef kRegistrationToLocalizerSequence
      //(0022,1465)
      = const ElementDef("RegistrationToLocalizerSequence", 0x00221465,
          "Registration to Localizer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRegisteredLocalizerUnits
      //(0022,1466)
      = const ElementDef("RegisteredLocalizerUnits", 0x00221466, "Registered Localizer Units", VR.kCS,
          VM.k1, false);
  static const ElementDef kRegisteredLocalizerTopLeftHandCorner
      //(0022,1467)
      = const ElementDef("RegisteredLocalizerTopLeftHandCorner", 0x00221467,
          "Registered Localizer Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const ElementDef kRegisteredLocalizerBottomRightHandCorner
      //(0022,1468)
      = const ElementDef("RegisteredLocalizerBottomRightHandCorner", 0x00221468,
          "Registered Localizer Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const ElementDef kOphthalmicThicknessMapQualityRatingSequence
      //(0022,1470)
      = const ElementDef("OphthalmicThicknessMapQualityRatingSequence", 0x00221470,
          "Ophthalmic Thickness Map Quality Rating Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRelevantOPTAttributesSequence
      //(0022,1472)
      = const ElementDef("RelevantOPTAttributesSequence", 0x00221472,
          "Relevant OPT Attributes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualFieldHorizontalExtent
      //(0024,0010)
      = const ElementDef("VisualFieldHorizontalExtent", 0x00240010, "Visual Field Horizontal Extent",
          VR.kFL, VM.k1, false);
  static const ElementDef kVisualFieldVerticalExtent
      //(0024,0011)
      = const ElementDef("VisualFieldVerticalExtent", 0x00240011, "Visual Field Vertical Extent",
          VR.kFL, VM.k1, false);
  static const ElementDef kVisualFieldShape
      //(0024,0012)
      = const ElementDef("VisualFieldShape", 0x00240012, "Visual Field Shape", VR.kCS, VM.k1, false);
  static const ElementDef kScreeningTestModeCodeSequence
      //(0024,0016)
      = const ElementDef("ScreeningTestModeCodeSequence", 0x00240016,
          "Screening Test Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMaximumStimulusLuminance
      //(0024,0018)
      = const ElementDef("MaximumStimulusLuminance", 0x00240018, "Maximum Stimulus Luminance", VR.kFL,
          VM.k1, false);
  static const ElementDef kBackgroundLuminance
      //(0024,0020)
      = const ElementDef(
          "BackgroundLuminance", 0x00240020, "Background Luminance", VR.kFL, VM.k1, false);
  static const ElementDef kStimulusColorCodeSequence
      //(0024,0021)
      = const ElementDef("StimulusColorCodeSequence", 0x00240021, "Stimulus Color Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kBackgroundIlluminationColorCodeSequence
      //(0024,0024)
      = const ElementDef("BackgroundIlluminationColorCodeSequence", 0x00240024,
          "Background Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStimulusArea
      //(0024,0025)
      = const ElementDef("StimulusArea", 0x00240025, "Stimulus Area", VR.kFL, VM.k1, false);
  static const ElementDef kStimulusPresentationTime
      //(0024,0028)
      = const ElementDef("StimulusPresentationTime", 0x00240028, "Stimulus Presentation Time", VR.kFL,
          VM.k1, false);
  static const ElementDef kFixationSequence
      //(0024,0032)
      = const ElementDef("FixationSequence", 0x00240032, "Fixation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFixationMonitoringCodeSequence
      //(0024,0033)
      = const ElementDef("FixationMonitoringCodeSequence", 0x00240033,
          "Fixation Monitoring Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualFieldCatchTrialSequence
      //(0024,0034)
      = const ElementDef("VisualFieldCatchTrialSequence", 0x00240034,
          "Visual Field Catch Trial Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFixationCheckedQuantity
      //(0024,0035)
      = const ElementDef(
          "FixationCheckedQuantity", 0x00240035, "Fixation Checked Quantity", VR.kUS, VM.k1, false);
  static const ElementDef kPatientNotProperlyFixatedQuantity
      //(0024,0036)
      = const ElementDef("PatientNotProperlyFixatedQuantity", 0x00240036,
          "Patient Not Properly Fixated Quantity", VR.kUS, VM.k1, false);
  static const ElementDef kPresentedVisualStimuliDataFlag
      //(0024,0037)
      = const ElementDef("PresentedVisualStimuliDataFlag", 0x00240037,
          "Presented Visual Stimuli Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfVisualStimuli
      //(0024,0038)
      = const ElementDef(
          "NumberOfVisualStimuli", 0x00240038, "Number of Visual Stimuli", VR.kUS, VM.k1, false);
  static const ElementDef kExcessiveFixationLossesDataFlag
      //(0024,0039)
      = const ElementDef("ExcessiveFixationLossesDataFlag", 0x00240039,
          "Excessive Fixation Losses Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kExcessiveFixationLosses
      //(0024,0040)
      = const ElementDef(
          "ExcessiveFixationLosses", 0x00240040, "Excessive Fixation Losses", VR.kCS, VM.k1, false);
  static const ElementDef kStimuliRetestingQuantity
      //(0024,0042)
      = const ElementDef("StimuliRetestingQuantity", 0x00240042, "Stimuli Retesting Quantity", VR.kUS,
          VM.k1, false);
  static const ElementDef kCommentsOnPatientPerformanceOfVisualField
      //(0024,0044)
      = const ElementDef("CommentsOnPatientPerformanceOfVisualField", 0x00240044,
          "Comments on Patient's Performance of Visual Field", VR.kLT, VM.k1, false);
  static const ElementDef kFalseNegativesEstimateFlag
      //(0024,0045)
      = const ElementDef("FalseNegativesEstimateFlag", 0x00240045, "False Negatives Estimate Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kFalseNegativesEstimate
      //(0024,0046)
      = const ElementDef(
          "FalseNegativesEstimate", 0x00240046, "False Negatives Estimate", VR.kFL, VM.k1, false);
  static const ElementDef kNegativeCatchTrialsQuantity
      //(0024,0048)
      = const ElementDef("NegativeCatchTrialsQuantity", 0x00240048, "Negative Catch Trials Quantity",
          VR.kUS, VM.k1, false);
  static const ElementDef kFalseNegativesQuantity
      //(0024,0050)
      = const ElementDef(
          "FalseNegativesQuantity", 0x00240050, "False Negatives Quantity", VR.kUS, VM.k1, false);
  static const ElementDef kExcessiveFalseNegativesDataFlag
      //(0024,0051)
      = const ElementDef("ExcessiveFalseNegativesDataFlag", 0x00240051,
          "Excessive False Negatives Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kExcessiveFalseNegatives
      //(0024,0052)
      = const ElementDef(
          "ExcessiveFalseNegatives", 0x00240052, "Excessive False Negatives", VR.kCS, VM.k1, false);
  static const ElementDef kFalsePositivesEstimateFlag
      //(0024,0053)
      = const ElementDef("FalsePositivesEstimateFlag", 0x00240053, "False Positives Estimate Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kFalsePositivesEstimate
      //(0024,0054)
      = const ElementDef(
          "FalsePositivesEstimate", 0x00240054, "False Positives Estimate", VR.kFL, VM.k1, false);
  static const ElementDef kCatchTrialsDataFlag
      //(0024,0055)
      = const ElementDef(
          "CatchTrialsDataFlag", 0x00240055, "Catch Trials Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kPositiveCatchTrialsQuantity
      //(0024,0056)
      = const ElementDef("PositiveCatchTrialsQuantity", 0x00240056, "Positive Catch Trials Quantity",
          VR.kUS, VM.k1, false);
  static const ElementDef kTestPointNormalsDataFlag
      //(0024,0057)
      = const ElementDef("TestPointNormalsDataFlag", 0x00240057, "Test Point Normals Data Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kTestPointNormalsSequence
      //(0024,0058)
      = const ElementDef("TestPointNormalsSequence", 0x00240058, "Test Point Normals Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kGlobalDeviationProbabilityNormalsFlag
      //(0024,0059)
      = const ElementDef("GlobalDeviationProbabilityNormalsFlag", 0x00240059,
          "Global Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const ElementDef kFalsePositivesQuantity
      //(0024,0060)
      = const ElementDef(
          "FalsePositivesQuantity", 0x00240060, "False Positives Quantity", VR.kUS, VM.k1, false);
  static const ElementDef kExcessiveFalsePositivesDataFlag
      //(0024,0061)
      = const ElementDef("ExcessiveFalsePositivesDataFlag", 0x00240061,
          "Excessive False Positives Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kExcessiveFalsePositives
      //(0024,0062)
      = const ElementDef(
          "ExcessiveFalsePositives", 0x00240062, "Excessive False Positives", VR.kCS, VM.k1, false);
  static const ElementDef kVisualFieldTestNormalsFlag
      //(0024,0063)
      = const ElementDef("VisualFieldTestNormalsFlag", 0x00240063, "Visual Field Test Normals Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kResultsNormalsSequence
      //(0024,0064)
      = const ElementDef(
          "ResultsNormalsSequence", 0x00240064, "Results Normals Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAgeCorrectedSensitivityDeviationAlgorithmSequence
      //(0024,0065)
      = const ElementDef("AgeCorrectedSensitivityDeviationAlgorithmSequence", 0x00240065,
          "Age Corrected Sensitivity Deviation Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGlobalDeviationFromNormal
      //(0024,0066)
      = const ElementDef("GlobalDeviationFromNormal", 0x00240066, "Global Deviation From Normal",
          VR.kFL, VM.k1, false);
  static const ElementDef kGeneralizedDefectSensitivityDeviationAlgorithmSequence
      //(0024,0067)
      = const ElementDef("GeneralizedDefectSensitivityDeviationAlgorithmSequence", 0x00240067,
          "Generalized Defect Sensitivity Deviation Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLocalizedDeviationFromNormal
      //(0024,0068)
      = const ElementDef("LocalizedDeviationFromNormal", 0x00240068, "Localized Deviation From Normal",
          VR.kFL, VM.k1, false);
  static const ElementDef kPatientReliabilityIndicator
      //(0024,0069)
      = const ElementDef("PatientReliabilityIndicator", 0x00240069, "Patient Reliability Indicator",
          VR.kLO, VM.k1, false);
  static const ElementDef kVisualFieldMeanSensitivity
      //(0024,0070)
      = const ElementDef("VisualFieldMeanSensitivity", 0x00240070, "Visual Field Mean Sensitivity",
          VR.kFL, VM.k1, false);
  static const ElementDef kGlobalDeviationProbability
      //(0024,0071)
      = const ElementDef("GlobalDeviationProbability", 0x00240071, "Global Deviation Probability",
          VR.kFL, VM.k1, false);
  static const ElementDef kLocalDeviationProbabilityNormalsFlag
      //(0024,0072)
      = const ElementDef("LocalDeviationProbabilityNormalsFlag", 0x00240072,
          "Local Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const ElementDef kLocalizedDeviationProbability
      //(0024,0073)
      = const ElementDef("LocalizedDeviationProbability", 0x00240073,
          "Localized Deviation Probability", VR.kFL, VM.k1, false);
  static const ElementDef kShortTermFluctuationCalculated
      //(0024,0074)
      = const ElementDef("ShortTermFluctuationCalculated", 0x00240074,
          "Short Term Fluctuation Calculated", VR.kCS, VM.k1, false);
  static const ElementDef kShortTermFluctuation
      //(0024,0075)
      = const ElementDef(
          "ShortTermFluctuation", 0x00240075, "Short Term Fluctuation", VR.kFL, VM.k1, false);
  static const ElementDef kShortTermFluctuationProbabilityCalculated
      //(0024,0076)
      = const ElementDef("ShortTermFluctuationProbabilityCalculated", 0x00240076,
          "Short Term Fluctuation Probability Calculated", VR.kCS, VM.k1, false);
  static const ElementDef kShortTermFluctuationProbability
      //(0024,0077)
      = const ElementDef("ShortTermFluctuationProbability", 0x00240077,
          "Short Term Fluctuation Probability", VR.kFL, VM.k1, false);
  static const ElementDef kCorrectedLocalizedDeviationFromNormalCalculated
      //(0024,0078)
      = const ElementDef("CorrectedLocalizedDeviationFromNormalCalculated", 0x00240078,
          "Corrected Localized Deviation From Normal Calculated", VR.kCS, VM.k1, false);
  static const ElementDef kCorrectedLocalizedDeviationFromNormal
      //(0024,0079)
      = const ElementDef("CorrectedLocalizedDeviationFromNormal", 0x00240079,
          "Corrected Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const ElementDef kCorrectedLocalizedDeviationFromNormalProbabilityCalculated
      //(0024,0080)
      = const ElementDef("CorrectedLocalizedDeviationFromNormalProbabilityCalculated", 0x00240080,
          "Corrected Localized Deviation From Normal Probability Calculated", VR.kCS, VM.k1, false);
  static const ElementDef kCorrectedLocalizedDeviationFromNormalProbability
      //(0024,0081)
      = const ElementDef("CorrectedLocalizedDeviationFromNormalProbability", 0x00240081,
          "Corrected Localized Deviation From Normal Probability", VR.kFL, VM.k1, false);
  static const ElementDef kGlobalDeviationProbabilitySequence
      //(0024,0083)
      = const ElementDef("GlobalDeviationProbabilitySequence", 0x00240083,
          "Global Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLocalizedDeviationProbabilitySequence
      //(0024,0085)
      = const ElementDef("LocalizedDeviationProbabilitySequence", 0x00240085,
          "Localized Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFovealSensitivityMeasured
      //(0024,0086)
      = const ElementDef("FovealSensitivityMeasured", 0x00240086, "Foveal Sensitivity Measured",
          VR.kCS, VM.k1, false);
  static const ElementDef kFovealSensitivity
      //(0024,0087)
      = const ElementDef("FovealSensitivity", 0x00240087, "Foveal Sensitivity", VR.kFL, VM.k1, false);
  static const ElementDef kVisualFieldTestDuration
      //(0024,0088)
      = const ElementDef("VisualFieldTestDuration", 0x00240088, "Visual Field Test Duration", VR.kFL,
          VM.k1, false);
  static const ElementDef kVisualFieldTestPointSequence
      //(0024,0089)
      = const ElementDef("VisualFieldTestPointSequence", 0x00240089,
          "Visual Field Test Point Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualFieldTestPointXCoordinate
      //(0024,0090)
      = const ElementDef("VisualFieldTestPointXCoordinate", 0x00240090,
          "Visual Field Test Point X-Coordinate", VR.kFL, VM.k1, false);
  static const ElementDef kVisualFieldTestPointYCoordinate
      //(0024,0091)
      = const ElementDef("VisualFieldTestPointYCoordinate", 0x00240091,
          "Visual Field Test Point Y-Coordinate", VR.kFL, VM.k1, false);
  static const ElementDef kAgeCorrectedSensitivityDeviationValue
      //(0024,0092)
      = const ElementDef("AgeCorrectedSensitivityDeviationValue", 0x00240092,
          "Age Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const ElementDef kStimulusResults
      //(0024,0093)
      = const ElementDef("StimulusResults", 0x00240093, "Stimulus Results", VR.kCS, VM.k1, false);
  static const ElementDef kSensitivityValue
      //(0024,0094)
      = const ElementDef("SensitivityValue", 0x00240094, "Sensitivity Value", VR.kFL, VM.k1, false);
  static const ElementDef kRetestStimulusSeen
      //(0024,0095)
      =
      const ElementDef("RetestStimulusSeen", 0x00240095, "Retest Stimulus Seen", VR.kCS, VM.k1, false);
  static const ElementDef kRetestSensitivityValue
      //(0024,0096)
      = const ElementDef(
          "RetestSensitivityValue", 0x00240096, "Retest Sensitivity Value", VR.kFL, VM.k1, false);
  static const ElementDef kVisualFieldTestPointNormalsSequence
      //(0024,0097)
      = const ElementDef("VisualFieldTestPointNormalsSequence", 0x00240097,
          "Visual Field Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kQuantifiedDefect
      //(0024,0098)
      = const ElementDef("QuantifiedDefect", 0x00240098, "Quantified Defect", VR.kFL, VM.k1, false);
  static const ElementDef kAgeCorrectedSensitivityDeviationProbabilityValue
      //(0024,0100)
      = const ElementDef("AgeCorrectedSensitivityDeviationProbabilityValue", 0x00240100,
          "Age Corrected Sensitivity Deviation Probability Value", VR.kFL, VM.k1, false);
  static const ElementDef kGeneralizedDefectCorrectedSensitivityDeviationFlag
      //(0024,0102)
      = const ElementDef("GeneralizedDefectCorrectedSensitivityDeviationFlag", 0x00240102,
          "Generalized Defect Corrected Sensitivity Deviation Flag", VR.kCS, VM.k1, false);
  static const ElementDef kGeneralizedDefectCorrectedSensitivityDeviationValue
      //(0024,0103)
      = const ElementDef("GeneralizedDefectCorrectedSensitivityDeviationValue", 0x00240103,
          "Generalized Defect Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const ElementDef kGeneralizedDefectCorrectedSensitivityDeviationProbabilityValue
      //(0024,0104)
      = const ElementDef(
          "GeneralizedDefectCorrectedSensitivityDeviationProbabilityValue",
          0x00240104,
          "Generalized Defect Corrected Sensitivity Deviation Probability Value",
          VR.kFL,
          VM.k1,
          false);
  static const ElementDef kMinimumSensitivityValue
      //(0024,0105)
      = const ElementDef(
          "MinimumSensitivityValue", 0x00240105, "Minimum Sensitivity Value", VR.kFL, VM.k1, false);
  static const ElementDef kBlindSpotLocalized
      //(0024,0106)
      =
      const ElementDef("BlindSpotLocalized", 0x00240106, "Blind Spot Localized", VR.kCS, VM.k1, false);
  static const ElementDef kBlindSpotXCoordinate
      //(0024,0107)
      = const ElementDef(
          "BlindSpotXCoordinate", 0x00240107, "Blind Spot X-Coordinate", VR.kFL, VM.k1, false);
  static const ElementDef kBlindSpotYCoordinate
      //(0024,0108)
      = const ElementDef(
          "BlindSpotYCoordinate", 0x00240108, "Blind Spot Y-Coordinate", VR.kFL, VM.k1, false);
  static const ElementDef kVisualAcuityMeasurementSequence
      //(0024,0110)
      = const ElementDef("VisualAcuityMeasurementSequence", 0x00240110,
          "Visual Acuity Measurement Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRefractiveParametersUsedOnPatientSequence
      //(0024,0112)
      = const ElementDef("RefractiveParametersUsedOnPatientSequence", 0x00240112,
          "Refractive Parameters Used on Patient Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMeasurementLaterality
      //(0024,0113)
      = const ElementDef(
          "MeasurementLaterality", 0x00240113, "Measurement Laterality", VR.kCS, VM.k1, false);
  static const ElementDef kOphthalmicPatientClinicalInformationLeftEyeSequence
      //(0024,0114)
      = const ElementDef("OphthalmicPatientClinicalInformationLeftEyeSequence", 0x00240114,
          "Ophthalmic Patient Clinical Information Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOphthalmicPatientClinicalInformationRightEyeSequence
      //(0024,0115)
      = const ElementDef("OphthalmicPatientClinicalInformationRightEyeSequence", 0x00240115,
          "Ophthalmic Patient Clinical Information Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFovealPointNormativeDataFlag
      //(0024,0117)
      = const ElementDef("FovealPointNormativeDataFlag", 0x00240117,
          "Foveal Point Normative Data Flag", VR.kCS, VM.k1, false);
  static const ElementDef kFovealPointProbabilityValue
      //(0024,0118)
      = const ElementDef("FovealPointProbabilityValue", 0x00240118, "Foveal Point Probability Value",
          VR.kFL, VM.k1, false);
  static const ElementDef kScreeningBaselineMeasured
      //(0024,0120)
      = const ElementDef("ScreeningBaselineMeasured", 0x00240120, "Screening Baseline Measured",
          VR.kCS, VM.k1, false);
  static const ElementDef kScreeningBaselineMeasuredSequence
      //(0024,0122)
      = const ElementDef("ScreeningBaselineMeasuredSequence", 0x00240122,
          "Screening Baseline Measured Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScreeningBaselineType
      //(0024,0124)
      = const ElementDef(
          "ScreeningBaselineType", 0x00240124, "Screening Baseline Type", VR.kCS, VM.k1, false);
  static const ElementDef kScreeningBaselineValue
      //(0024,0126)
      = const ElementDef(
          "ScreeningBaselineValue", 0x00240126, "Screening Baseline Value", VR.kFL, VM.k1, false);
  static const ElementDef kAlgorithmSource
      //(0024,0202)
      = const ElementDef("AlgorithmSource", 0x00240202, "Algorithm Source", VR.kLO, VM.k1, false);
  static const ElementDef kDataSetName
      //(0024,0306)
      = const ElementDef("DataSetName", 0x00240306, "Data Set Name", VR.kLO, VM.k1, false);
  static const ElementDef kDataSetVersion
      //(0024,0307)
      = const ElementDef("DataSetVersion", 0x00240307, "Data Set Version", VR.kLO, VM.k1, false);
  static const ElementDef kDataSetSource
      //(0024,0308)
      = const ElementDef("DataSetSource", 0x00240308, "Data Set Source", VR.kLO, VM.k1, false);
  static const ElementDef kDataSetDescription
      //(0024,0309)
      =
      const ElementDef("DataSetDescription", 0x00240309, "Data Set Description", VR.kLO, VM.k1, false);
  static const ElementDef kVisualFieldTestReliabilityGlobalIndexSequence
      //(0024,0317)
      = const ElementDef("VisualFieldTestReliabilityGlobalIndexSequence", 0x00240317,
          "Visual Field Test Reliability Global Index Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualFieldGlobalResultsIndexSequence
      //(0024,0320)
      = const ElementDef("VisualFieldGlobalResultsIndexSequence", 0x00240320,
          "Visual Field Global Results Index Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDataObservationSequence
      //(0024,0325)
      = const ElementDef(
          "DataObservationSequence", 0x00240325, "Data Observation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIndexNormalsFlag
      //(0024,0338)
      = const ElementDef("IndexNormalsFlag", 0x00240338, "Index Normals Flag", VR.kCS, VM.k1, false);
  static const ElementDef kIndexProbability
      //(0024,0341)
      = const ElementDef("IndexProbability", 0x00240341, "Index Probability", VR.kFL, VM.k1, false);
  static const ElementDef kIndexProbabilitySequence
      //(0024,0344)
      = const ElementDef("IndexProbabilitySequence", 0x00240344, "Index Probability Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSamplesPerPixel
      //(0028,0002)
      = const ElementDef("SamplesPerPixel", 0x00280002, "Samples per Pixel", VR.kUS, VM.k1, false);
  static const ElementDef kSamplesPerPixelUsed
      //(0028,0003)
      = const ElementDef(
          "SamplesPerPixelUsed", 0x00280003, "Samples per Pixel Used", VR.kUS, VM.k1, false);
  static const ElementDef kPhotometricInterpretation
      //(0028,0004)
      = const ElementDef("PhotometricInterpretation", 0x00280004, "Photometric Interpretation", VR.kCS,
          VM.k1, false);
  static const ElementDef kImageDimensions
      //(0028,0005)
      = const ElementDef("ImageDimensions", 0x00280005, "Image Dimensions", VR.kUS, VM.k1, true);
  static const ElementDef kPlanarConfiguration
      //(0028,0006)
      = const ElementDef(
          "PlanarConfiguration", 0x00280006, "Planar Configuration", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfFrames
      //(0028,0008)
      = const ElementDef("NumberOfFrames", 0x00280008, "Number of Frames", VR.kIS, VM.k1, false);
  static const ElementDef kFrameIncrementPointer
      //(0028,0009)
      = const ElementDef(
          "FrameIncrementPointer", 0x00280009, "Frame Increment Pointer", VR.kAT, VM.k1_n, false);
  static const ElementDef kFrameDimensionPointer
      //(0028,000A)
      = const ElementDef(
          "FrameDimensionPointer", 0x0028000A, "Frame Dimension Pointer", VR.kAT, VM.k1_n, false);
  static const ElementDef kRows
      //(0028,0010)
      = const ElementDef("Rows", 0x00280010, "Rows", VR.kUS, VM.k1, false);
  static const ElementDef kColumns
      //(0028,0011)
      = const ElementDef("Columns", 0x00280011, "Columns", VR.kUS, VM.k1, false);
  static const ElementDef kPlanes
      //(0028,0012)
      = const ElementDef("Planes", 0x00280012, "Planes", VR.kUS, VM.k1, true);
  static const ElementDef kUltrasoundColorDataPresent
      //(0028,0014)
      = const ElementDef("UltrasoundColorDataPresent", 0x00280014, "Ultrasound Color Data Present",
          VR.kUS, VM.k1, false);
  static const ElementDef kNoName1
      //(0028,0020)
      = const ElementDef("NoName1", 0x00280020, "See Note 3", VR.kNoVR, VM.kNoVM, true);
  static const ElementDef kPixelSpacing
      //(0028,0030)
      = const ElementDef("PixelSpacing", 0x00280030, "Pixel Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kZoomFactor
      //(0028,0031)
      = const ElementDef("ZoomFactor", 0x00280031, "Zoom Factor", VR.kDS, VM.k2, false);
  static const ElementDef kZoomCenter
      //(0028,0032)
      = const ElementDef("ZoomCenter", 0x00280032, "Zoom Center", VR.kDS, VM.k2, false);
  static const ElementDef kPixelAspectRatio
      //(0028,0034)
      = const ElementDef("PixelAspectRatio", 0x00280034, "Pixel Aspect Ratio", VR.kIS, VM.k2, false);
  static const ElementDef kImageFormat
      //(0028,0040)
      = const ElementDef("ImageFormat", 0x00280040, "Image Format", VR.kCS, VM.k1, true);
  static const ElementDef kManipulatedImage
      //(0028,0050)
      = const ElementDef("ManipulatedImage", 0x00280050, "Manipulated Image", VR.kLO, VM.k1_n, true);
  static const ElementDef kCorrectedImage
      //(0028,0051)
      = const ElementDef("CorrectedImage", 0x00280051, "Corrected Image", VR.kCS, VM.k1_n, false);
  static const ElementDef kCompressionRecognitionCode
      //(0028,005F)
      = const ElementDef("CompressionRecognitionCode", 0x0028005F, "Compression Recognition Code",
          VR.kLO, VM.k1, true);
  static const ElementDef kCompressionCode
      //(0028,0060)
      = const ElementDef("CompressionCode", 0x00280060, "Compression Code", VR.kCS, VM.k1, true);
  static const ElementDef kCompressionOriginator
      //(0028,0061)
      = const ElementDef(
          "CompressionOriginator", 0x00280061, "Compression Originator", VR.kSH, VM.k1, true);
  static const ElementDef kCompressionLabel
      //(0028,0062)
      = const ElementDef("CompressionLabel", 0x00280062, "Compression Label", VR.kLO, VM.k1, true);
  static const ElementDef kCompressionDescription
      //(0028,0063)
      = const ElementDef(
          "CompressionDescription", 0x00280063, "Compression Description", VR.kSH, VM.k1, true);
  static const ElementDef kCompressionSequence
      //(0028,0065)
      = const ElementDef(
          "CompressionSequence", 0x00280065, "Compression Sequence", VR.kCS, VM.k1_n, true);
  static const ElementDef kCompressionStepPointers
      //(0028,0066)
      = const ElementDef("CompressionStepPointers", 0x00280066, "Compression Step Pointers", VR.kAT,
          VM.k1_n, true);
  static const ElementDef kRepeatInterval
      //(0028,0068)
      = const ElementDef("RepeatInterval", 0x00280068, "Repeat Interval", VR.kUS, VM.k1, true);
  static const ElementDef kBitsGrouped
      //(0028,0069)
      = const ElementDef("BitsGrouped", 0x00280069, "Bits Grouped", VR.kUS, VM.k1, true);
  static const ElementDef kPerimeterTable
      //(0028,0070)
      = const ElementDef("PerimeterTable", 0x00280070, "Perimeter Table", VR.kUS, VM.k1_n, true);
  static const ElementDef kPerimeterValue
      //(0028,0071)
      = const ElementDef("PerimeterValue", 0x00280071, "Perimeter Value", VR.kUSSS, VM.k1, true);
  static const ElementDef kPredictorRows
      //(0028,0080)
      = const ElementDef("PredictorRows", 0x00280080, "Predictor Rows", VR.kUS, VM.k1, true);
  static const ElementDef kPredictorColumns
      //(0028,0081)
      = const ElementDef("PredictorColumns", 0x00280081, "Predictor Columns", VR.kUS, VM.k1, true);
  static const ElementDef kPredictorConstants
      //(0028,0082)
      =
      const ElementDef("PredictorConstants", 0x00280082, "Predictor Constants", VR.kUS, VM.k1_n, true);
  static const ElementDef kBlockedPixels
      //(0028,0090)
      = const ElementDef("BlockedPixels", 0x00280090, "Blocked Pixels", VR.kCS, VM.k1, true);
  static const ElementDef kBlockRows
      //(0028,0091)
      = const ElementDef("BlockRows", 0x00280091, "Block Rows", VR.kUS, VM.k1, true);
  static const ElementDef kBlockColumns
      //(0028,0092)
      = const ElementDef("BlockColumns", 0x00280092, "Block Columns", VR.kUS, VM.k1, true);
  static const ElementDef kRowOverlap
      //(0028,0093)
      = const ElementDef("RowOverlap", 0x00280093, "Row Overlap", VR.kUS, VM.k1, true);
  static const ElementDef kColumnOverlap
      //(0028,0094)
      = const ElementDef("ColumnOverlap", 0x00280094, "Column Overlap", VR.kUS, VM.k1, true);
  static const ElementDef kBitsAllocated
      //(0028,0100)
      = const ElementDef("BitsAllocated", 0x00280100, "Bits Allocated", VR.kUS, VM.k1, false);
  static const ElementDef kBitsStored
      //(0028,0101)
      = const ElementDef("BitsStored", 0x00280101, "Bits Stored", VR.kUS, VM.k1, false);
  static const ElementDef kHighBit
      //(0028,0102)
      = const ElementDef("HighBit", 0x00280102, "High Bit", VR.kUS, VM.k1, false);
  static const ElementDef kPixelRepresentation
      //(0028,0103)
      = const ElementDef(
          "PixelRepresentation", 0x00280103, "Pixel Representation", VR.kUS, VM.k1, false);
  static const ElementDef kSmallestValidPixelValue
      //(0028,0104)
      = const ElementDef("SmallestValidPixelValue", 0x00280104, "Smallest Valid Pixel Value", VR.kUSSS,
          VM.k1, true);
  static const ElementDef kLargestValidPixelValue
      //(0028,0105)
      = const ElementDef(
          "LargestValidPixelValue", 0x00280105, "Largest Valid Pixel Value", VR.kUSSS, VM.k1, true);
  static const ElementDef kSmallestImagePixelValue
      //(0028,0106)
      = const ElementDef("SmallestImagePixelValue", 0x00280106, "Smallest Image Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const ElementDef kLargestImagePixelValue
      //(0028,0107)
      = const ElementDef("LargestImagePixelValue", 0x00280107, "Largest Image Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const ElementDef kSmallestPixelValueInSeries
      //(0028,0108)
      = const ElementDef("SmallestPixelValueInSeries", 0x00280108, "Smallest Pixel Value in Series",
          VR.kUSSS, VM.k1, false);
  static const ElementDef kLargestPixelValueInSeries
      //(0028,0109)
      = const ElementDef("LargestPixelValueInSeries", 0x00280109, "Largest Pixel Value in Series",
          VR.kUSSS, VM.k1, false);
  static const ElementDef kSmallestImagePixelValueInPlane
      //(0028,0110)
      = const ElementDef("SmallestImagePixelValueInPlane", 0x00280110,
          "Smallest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const ElementDef kLargestImagePixelValueInPlane
      //(0028,0111)
      = const ElementDef("LargestImagePixelValueInPlane", 0x00280111,
          "Largest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const ElementDef kPixelPaddingValue
      //(0028,0120)
      =
      const ElementDef("PixelPaddingValue", 0x00280120, "Pixel Padding Value", VR.kUSSS, VM.k1, false);
  static const ElementDef kPixelPaddingRangeLimit
      //(0028,0121)
      = const ElementDef("PixelPaddingRangeLimit", 0x00280121, "Pixel Padding Range Limit", VR.kUSSS,
          VM.k1, false);
  static const ElementDef kImageLocation
      //(0028,0200)
      = const ElementDef("ImageLocation", 0x00280200, "Image Location", VR.kUS, VM.k1, true);
  static const ElementDef kQualityControlImage
      //(0028,0300)
      = const ElementDef(
          "QualityControlImage", 0x00280300, "Quality Control Image", VR.kCS, VM.k1, false);
  static const ElementDef kBurnedInAnnotation
      //(0028,0301)
      =
      const ElementDef("BurnedInAnnotation", 0x00280301, "Burned In Annotation", VR.kCS, VM.k1, false);
  static const ElementDef kRecognizableVisualFeatures
      //(0028,0302)
      = const ElementDef("RecognizableVisualFeatures", 0x00280302, "Recognizable Visual Features",
          VR.kCS, VM.k1, false);
  static const ElementDef kLongitudinalTemporalInformationModified
      //(0028,0303)
      = const ElementDef("LongitudinalTemporalInformationModified", 0x00280303,
          "Longitudinal Temporal Information Modified", VR.kCS, VM.k1, false);
  static const ElementDef kReferencedColorPaletteInstanceUID
      //(0028,0304)
      = const ElementDef("ReferencedColorPaletteInstanceUID", 0x00280304,
          "Referenced Color Palette Instance UID", VR.kUI, VM.k1, false);
  static const ElementDef kTransformLabel
      //(0028,0400)
      = const ElementDef("TransformLabel", 0x00280400, "Transform Label", VR.kLO, VM.k1, true);
  static const ElementDef kTransformVersionNumber
      //(0028,0401)
      = const ElementDef(
          "TransformVersionNumber", 0x00280401, "Transform Version Number", VR.kLO, VM.k1, true);
  static const ElementDef kNumberOfTransformSteps
      //(0028,0402)
      = const ElementDef(
          "NumberOfTransformSteps", 0x00280402, "Number of Transform Steps", VR.kUS, VM.k1, true);
  static const ElementDef kSequenceOfCompressedData
      //(0028,0403)
      = const ElementDef("SequenceOfCompressedData", 0x00280403, "Sequence of Compressed Data", VR.kLO,
          VM.k1_n, true);
  static const ElementDef kDetailsOfCoefficients
      //(0028,0404)
      = const ElementDef(
          "DetailsOfCoefficients", 0x00280404, "Details of Coefficients", VR.kAT, VM.k1_n, true);

  // *** See below ***
  //static const Element kRowsForNthOrderCoefficients
  //(0028,0400)
  //= const Element("RowsForNthOrderCoefficients", 0x00280400, "Rows For Nth Order Coefficients",
  //VR.kUS, VM.k1, true);
  // *** See below ***
  //static const Element kColumnsForNthOrderCoefficients
  //(0028,0401)
  //= const Element("ColumnsForNthOrderCoefficients", 0x00280401, "Columns For Nth Order
  //Coefficients", VR.kUS, VM.k1, true);
  //static const Element kCoefficientCoding
  //(0028,0402)
  //= const Element("CoefficientCoding", 0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);
  //static const Element kCoefficientCodingPointers
  //(0028,0403)
  //= const Element("CoefficientCodingPointers", 0x00280403, "Coefficient Coding Pointers", VR
  //    .kAT, VM.k1_n, true);
  static const ElementDef kDCTLabel
      //(0028,0700)
      = const ElementDef("DCTLabel", 0x00280700, "DCT Label", VR.kLO, VM.k1, true);
  static const ElementDef kDataBlockDescription
      //(0028,0701)
      = const ElementDef(
          "DataBlockDescription", 0x00280701, "Data Block Description", VR.kCS, VM.k1_n, true);
  static const ElementDef kDataBlock
      //(0028,0702)
      = const ElementDef("DataBlock", 0x00280702, "Data Block", VR.kAT, VM.k1_n, true);
  static const ElementDef kNormalizationFactorFormat
      //(0028,0710)
      = const ElementDef("NormalizationFactorFormat", 0x00280710, "Normalization Factor Format",
          VR.kUS, VM.k1, true);
  static const ElementDef kZonalMapNumberFormat
      //(0028,0720)
      = const ElementDef(
          "ZonalMapNumberFormat", 0x00280720, "Zonal Map Number Format", VR.kUS, VM.k1, true);
  static const ElementDef kZonalMapLocation
      //(0028,0721)
      = const ElementDef("ZonalMapLocation", 0x00280721, "Zonal Map Location", VR.kAT, VM.k1_n, true);
  static const ElementDef kZonalMapFormat
      //(0028,0722)
      = const ElementDef("ZonalMapFormat", 0x00280722, "Zonal Map Format", VR.kUS, VM.k1, true);
  static const ElementDef kAdaptiveMapFormat
      //(0028,0730)
      = const ElementDef("AdaptiveMapFormat", 0x00280730, "Adaptive Map Format", VR.kUS, VM.k1, true);
  static const ElementDef kCodeNumberFormat
      //(0028,0740)
      = const ElementDef("CodeNumberFormat", 0x00280740, "Code Number Format", VR.kUS, VM.k1, true);
  static const ElementDef kCodeLabel
      //(0028,0800)
      = const ElementDef("CodeLabel", 0x00280800, "Code Label", VR.kCS, VM.k1_n, true);
  static const ElementDef kNumberOfTables
      //(0028,0802)
      = const ElementDef("NumberOfTables", 0x00280802, "Number of Tables", VR.kUS, VM.k1, true);
  static const ElementDef kCodeTableLocation
      //(0028,0803)
      =
      const ElementDef("CodeTableLocation", 0x00280803, "Code Table Location", VR.kAT, VM.k1_n, true);
  static const ElementDef kBitsForCodeWord
      //(0028,0804)
      = const ElementDef("BitsForCodeWord", 0x00280804, "Bits For Code Word", VR.kUS, VM.k1, true);
  static const ElementDef kImageDataLocation
      //(0028,0808)
      =
      const ElementDef("ImageDataLocation", 0x00280808, "Image Data Location", VR.kAT, VM.k1_n, true);
  static const ElementDef kPixelSpacingCalibrationType
      //(0028,0A02)
      = const ElementDef("PixelSpacingCalibrationType", 0x00280A02, "Pixel Spacing Calibration Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kPixelSpacingCalibrationDescription
      //(0028,0A04)
      = const ElementDef("PixelSpacingCalibrationDescription", 0x00280A04,
          "Pixel Spacing Calibration Description", VR.kLO, VM.k1, false);
  static const ElementDef kPixelIntensityRelationship
      //(0028,1040)
      = const ElementDef("PixelIntensityRelationship", 0x00281040, "Pixel Intensity Relationship",
          VR.kCS, VM.k1, false);
  static const ElementDef kPixelIntensityRelationshipSign
      //(0028,1041)
      = const ElementDef("PixelIntensityRelationshipSign", 0x00281041,
          "Pixel Intensity Relationship Sign", VR.kSS, VM.k1, false);
  static const ElementDef kWindowCenter
      //(0028,1050)
      = const ElementDef("WindowCenter", 0x00281050, "Window Center", VR.kDS, VM.k1_n, false);
  static const ElementDef kWindowWidth
      //(0028,1051)
      = const ElementDef("WindowWidth", 0x00281051, "Window Width", VR.kDS, VM.k1_n, false);
  static const ElementDef kRescaleIntercept
      //(0028,1052)
      = const ElementDef("RescaleIntercept", 0x00281052, "Rescale Intercept", VR.kDS, VM.k1, false);
  static const ElementDef kRescaleSlope
      //(0028,1053)
      = const ElementDef("RescaleSlope", 0x00281053, "Rescale Slope", VR.kDS, VM.k1, false);
  static const ElementDef kRescaleType
      //(0028,1054)
      = const ElementDef("RescaleType", 0x00281054, "Rescale Type", VR.kLO, VM.k1, false);
  static const ElementDef kWindowCenterWidthExplanation
      //(0028,1055)
      = const ElementDef("WindowCenterWidthExplanation", 0x00281055,
          "Window Center & Width Explanation", VR.kLO, VM.k1_n, false);
  static const ElementDef kVOILUTFunction
      //(0028,1056)
      = const ElementDef("VOILUTFunction", 0x00281056, "VOI LUT Function", VR.kCS, VM.k1, false);
  static const ElementDef kGrayScale
      //(0028,1080)
      = const ElementDef("GrayScale", 0x00281080, "Gray Scale", VR.kCS, VM.k1, true);
  static const ElementDef kRecommendedViewingMode
      //(0028,1090)
      = const ElementDef(
          "RecommendedViewingMode", 0x00281090, "Recommended Viewing Mode", VR.kCS, VM.k1, false);
  static const ElementDef kGrayLookupTableDescriptor
      //(0028,1100)
      = const ElementDef("GrayLookupTableDescriptor", 0x00281100, "Gray Lookup Table Descriptor",
          VR.kUSSS, VM.k3, true);
  static const ElementDef kRedPaletteColorLookupTableDescriptor
      //(0028,1101)
      = const ElementDef("RedPaletteColorLookupTableDescriptor", 0x00281101,
          "Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const ElementDef kGreenPaletteColorLookupTableDescriptor
      //(0028,1102)
      = const ElementDef("GreenPaletteColorLookupTableDescriptor", 0x00281102,
          "Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const ElementDef kBluePaletteColorLookupTableDescriptor
      //(0028,1103)
      = const ElementDef("BluePaletteColorLookupTableDescriptor", 0x00281103,
          "Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const ElementDef kAlphaPaletteColorLookupTableDescriptor
      //(0028,1104)
      = const ElementDef("AlphaPaletteColorLookupTableDescriptor", 0x00281104,
          "AlphaPalette ColorLookup Table Descriptor", VR.kUS, VM.k3, false);
  static const ElementDef kLargeRedPaletteColorLookupTableDescriptor
      //(0028,1111)
      = const ElementDef("LargeRedPaletteColorLookupTableDescriptor", 0x00281111,
          "Large Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const ElementDef kLargeGreenPaletteColorLookupTableDescriptor
      //(0028,1112)
      = const ElementDef("LargeGreenPaletteColorLookupTableDescriptor", 0x00281112,
          "Large Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const ElementDef kLargeBluePaletteColorLookupTableDescriptor
      //(0028,1113)
      = const ElementDef("LargeBluePaletteColorLookupTableDescriptor", 0x00281113,
          "Large Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const ElementDef kPaletteColorLookupTableUID
      //(0028,1199)
      = const ElementDef("PaletteColorLookupTableUID", 0x00281199, "Palette Color Lookup Table UID",
          VR.kUI, VM.k1, false);
  static const ElementDef kGrayLookupTableData
      //(0028,1200)
      = const ElementDef(
          "GrayLookupTableData", 0x00281200, "Gray Lookup Table Data", VR.kUSSSOW, VM.k1_n, true);
  static const ElementDef kRedPaletteColorLookupTableData
      //(0028,1201)
      = const ElementDef("RedPaletteColorLookupTableData", 0x00281201,
          "Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kGreenPaletteColorLookupTableData
      //(0028,1202)
      = const ElementDef("GreenPaletteColorLookupTableData", 0x00281202,
          "Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kBluePaletteColorLookupTableData
      //(0028,1203)
      = const ElementDef("BluePaletteColorLookupTableData", 0x00281203,
          "Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kAlphaPaletteColorLookupTableData
      //(0028,1204)
      = const ElementDef("AlphaPaletteColorLookupTableData", 0x00281204,
          "Alpha Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kLargeRedPaletteColorLookupTableData
      //(0028,1211)
      = const ElementDef("LargeRedPaletteColorLookupTableData", 0x00281211,
          "Large Red Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const ElementDef kLargeGreenPaletteColorLookupTableData
      //(0028,1212)
      = const ElementDef("LargeGreenPaletteColorLookupTableData", 0x00281212,
          "Large Green Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const ElementDef kLargeBluePaletteColorLookupTableData
      //(0028,1213)
      = const ElementDef("LargeBluePaletteColorLookupTableData", 0x00281213,
          "Large Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const ElementDef kLargePaletteColorLookupTableUID
      //(0028,1214)
      = const ElementDef("LargePaletteColorLookupTableUID", 0x00281214,
          "Large Palette Color Lookup Table UID", VR.kUI, VM.k1, true);
  static const ElementDef kSegmentedRedPaletteColorLookupTableData
      //(0028,1221)
      = const ElementDef("SegmentedRedPaletteColorLookupTableData", 0x00281221,
          "Segmented Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kSegmentedGreenPaletteColorLookupTableData
      //(0028,1222)
      = const ElementDef("SegmentedGreenPaletteColorLookupTableData", 0x00281222,
          "Segmented Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kSegmentedBluePaletteColorLookupTableData
      //(0028,1223)
      = const ElementDef("SegmentedBluePaletteColorLookupTableData", 0x00281223,
          "Segmented Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const ElementDef kBreastImplantPresent
      //(0028,1300)
      = const ElementDef(
          "BreastImplantPresent", 0x00281300, "Breast Implant Present", VR.kCS, VM.k1, false);
  static const ElementDef kPartialView
      //(0028,1350)
      = const ElementDef("PartialView", 0x00281350, "Partial View", VR.kCS, VM.k1, false);
  static const ElementDef kPartialViewDescription
      //(0028,1351)
      = const ElementDef(
          "PartialViewDescription", 0x00281351, "Partial View Description", VR.kST, VM.k1, false);
  static const ElementDef kPartialViewCodeSequence
      //(0028,1352)
      = const ElementDef("PartialViewCodeSequence", 0x00281352, "Partial View Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSpatialLocationsPreserved
      //(0028,135A)
      = const ElementDef("SpatialLocationsPreserved", 0x0028135A, "Spatial Locations Preserved",
          VR.kCS, VM.k1, false);
  static const ElementDef kDataFrameAssignmentSequence
      //(0028,1401)
      = const ElementDef("DataFrameAssignmentSequence", 0x00281401, "Data Frame Assignment Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kDataPathAssignment
      //(0028,1402)
      =
      const ElementDef("DataPathAssignment", 0x00281402, "Data Path Assignment", VR.kCS, VM.k1, false);
  static const ElementDef kBitsMappedToColorLookupTable
      //(0028,1403)
      = const ElementDef("BitsMappedToColorLookupTable", 0x00281403,
          "Bits Mapped to Color Lookup Table", VR.kUS, VM.k1, false);
  static const ElementDef kBlendingLUT1Sequence
      //(0028,1404)
      = const ElementDef(
          "BlendingLUT1Sequence", 0x00281404, "Blending LUT 1 Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBlendingLUT1TransferFunction
      //(0028,1405)
      = const ElementDef("BlendingLUT1TransferFunction", 0x00281405,
          "Blending LUT 1 Transfer Function", VR.kCS, VM.k1, false);
  static const ElementDef kBlendingWeightConstant
      //(0028,1406)
      = const ElementDef(
          "BlendingWeightConstant", 0x00281406, "Blending Weight Constant", VR.kFD, VM.k1, false);
  static const ElementDef kBlendingLookupTableDescriptor
      //(0028,1407)
      = const ElementDef("BlendingLookupTableDescriptor", 0x00281407,
          "Blending Lookup Table Descriptor", VR.kUS, VM.k3, false);
  static const ElementDef kBlendingLookupTableData
      //(0028,1408)
      = const ElementDef("BlendingLookupTableData", 0x00281408, "Blending Lookup Table Data", VR.kOW,
          VM.k1, false);
  static const ElementDef kEnhancedPaletteColorLookupTableSequence
      //(0028,140B)
      = const ElementDef("EnhancedPaletteColorLookupTableSequence", 0x0028140B,
          "Enhanced Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBlendingLUT2Sequence
      //(0028,140C)
      = const ElementDef(
          "BlendingLUT2Sequence", 0x0028140C, "Blending LUT 2 Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBlendingLUT2TransferFunction
      //(0028,140D)
      = const ElementDef("BlendingLUT2TransferFunction", 0x0028140D,
          "Blending LUT 2 Transfer Function", VR.kCS, VM.k1, false);
  static const ElementDef kDataPathID
      //(0028,140E)
      = const ElementDef("DataPathID", 0x0028140E, "Data Path ID", VR.kCS, VM.k1, false);
  static const ElementDef kRGBLUTTransferFunction
      //(0028,140F)
      = const ElementDef(
          "RGBLUTTransferFunction", 0x0028140F, "RGB LUT Transfer Function", VR.kCS, VM.k1, false);
  static const ElementDef kAlphaLUTTransferFunction
      //(0028,1410)
      = const ElementDef("AlphaLUTTransferFunction", 0x00281410, "Alpha LUT Transfer Function", VR.kCS,
          VM.k1, false);
  static const ElementDef kICCProfile
      //(0028,2000)
      = const ElementDef("ICCProfile", 0x00282000, "ICC Profile", VR.kOB, VM.k1, false);
  static const ElementDef kLossyImageCompression
      //(0028,2110)
      = const ElementDef(
          "LossyImageCompression", 0x00282110, "Lossy Image Compression", VR.kCS, VM.k1, false);
  static const ElementDef kLossyImageCompressionRatio
      //(0028,2112)
      = const ElementDef("LossyImageCompressionRatio", 0x00282112, "Lossy Image Compression Ratio",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kLossyImageCompressionMethod
      //(0028,2114)
      = const ElementDef("LossyImageCompressionMethod", 0x00282114, "Lossy Image Compression Method",
          VR.kCS, VM.k1_n, false);
  static const ElementDef kModalityLUTSequence
      //(0028,3000)
      = const ElementDef(
          "ModalityLUTSequence", 0x00283000, "Modality LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLUTDescriptor
      //(0028,3002)
      = const ElementDef("LUTDescriptor", 0x00283002, "LUT Descriptor", VR.kUSSS, VM.k3, false);
  static const ElementDef kLUTExplanation
      //(0028,3003)
      = const ElementDef("LUTExplanation", 0x00283003, "LUT Explanation", VR.kLO, VM.k1, false);
  static const ElementDef kModalityLUTType
      //(0028,3004)
      = const ElementDef("ModalityLUTType", 0x00283004, "Modality LUT Type", VR.kLO, VM.k1, false);
  static const ElementDef kLUTData
      //(0028,3006)
      = const ElementDef("LUTData", 0x00283006, "LUT Data", VR.kUSOW, VM.k1_n, false);
  static const ElementDef kVOILUTSequence
      //(0028,3010)
      = const ElementDef("VOILUTSequence", 0x00283010, "VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSoftcopyVOILUTSequence
      //(0028,3110)
      = const ElementDef(
          "SoftcopyVOILUTSequence", 0x00283110, "Softcopy VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImagePresentationComments
      //(0028,4000)
      = const ElementDef("ImagePresentationComments", 0x00284000, "Image Presentation Comments",
          VR.kLT, VM.k1, true);
  static const ElementDef kBiPlaneAcquisitionSequence
      //(0028,5000)
      = const ElementDef("BiPlaneAcquisitionSequence", 0x00285000, "Bi-Plane Acquisition Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kRepresentativeFrameNumber
      //(0028,6010)
      = const ElementDef("RepresentativeFrameNumber", 0x00286010, "Representative Frame Number",
          VR.kUS, VM.k1, false);
  static const ElementDef kFrameNumbersOfInterest
      //(0028,6020)
      = const ElementDef("FrameNumbersOfInterest", 0x00286020, "Frame Numbers of Interest (FOI)",
          VR.kUS, VM.k1_n, false);
  static const ElementDef kFrameOfInterestDescription
      //(0028,6022)
      = const ElementDef("FrameOfInterestDescription", 0x00286022, "Frame of Interest Description",
          VR.kLO, VM.k1_n, false);
  static const ElementDef kFrameOfInterestType
      //(0028,6023)
      = const ElementDef(
          "FrameOfInterestType", 0x00286023, "Frame of Interest Type", VR.kCS, VM.k1_n, false);
  static const ElementDef kMaskPointers
      //(0028,6030)
      = const ElementDef("MaskPointers", 0x00286030, "Mask Pointer(s)", VR.kUS, VM.k1_n, true);
  static const ElementDef kRWavePointer
      //(0028,6040)
      = const ElementDef("RWavePointer", 0x00286040, "R Wave Pointer", VR.kUS, VM.k1_n, false);
  static const ElementDef kMaskSubtractionSequence
      //(0028,6100)
      = const ElementDef(
          "MaskSubtractionSequence", 0x00286100, "Mask Subtraction Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMaskOperation
      //(0028,6101)
      = const ElementDef("MaskOperation", 0x00286101, "Mask Operation", VR.kCS, VM.k1, false);
  static const ElementDef kApplicableFrameRange
      //(0028,6102)
      = const ElementDef(
          "ApplicableFrameRange", 0x00286102, "Applicable Frame Range", VR.kUS, VM.k2_2n, false);
  static const ElementDef kMaskFrameNumbers
      //(0028,6110)
      = const ElementDef("MaskFrameNumbers", 0x00286110, "Mask Frame Numbers", VR.kUS, VM.k1_n, false);
  static const ElementDef kContrastFrameAveraging
      //(0028,6112)
      = const ElementDef(
          "ContrastFrameAveraging", 0x00286112, "Contrast Frame Averaging", VR.kUS, VM.k1, false);
  static const ElementDef kMaskSubPixelShift
      //(0028,6114)
      =
      const ElementDef("MaskSubPixelShift", 0x00286114, "Mask Sub-pixel Shift", VR.kFL, VM.k2, false);
  static const ElementDef kTIDOffset
      //(0028,6120)
      = const ElementDef("TIDOffset", 0x00286120, "TID Offset", VR.kSS, VM.k1, false);
  static const ElementDef kMaskOperationExplanation
      //(0028,6190)
      = const ElementDef("MaskOperationExplanation", 0x00286190, "Mask Operation Explanation", VR.kST,
          VM.k1, false);
  static const ElementDef kPixelDataProviderURL
      //(0028,7FE0)
      = const ElementDef(
          "PixelDataProviderURL", 0x00287FE0, "Pixel Data Provider URL", VR.kUT, VM.k1, false);
  static const ElementDef kDataPointRows
      //(0028,9001)
      = const ElementDef("DataPointRows", 0x00289001, "Data Point Rows", VR.kUL, VM.k1, false);
  static const ElementDef kDataPointColumns
      //(0028,9002)
      = const ElementDef("DataPointColumns", 0x00289002, "Data Point Columns", VR.kUL, VM.k1, false);
  static const ElementDef kSignalDomainColumns
      //(0028,9003)
      = const ElementDef(
          "SignalDomainColumns", 0x00289003, "Signal Domain Columns", VR.kCS, VM.k1, false);
  static const ElementDef kLargestMonochromePixelValue
      //(0028,9099)
      = const ElementDef("LargestMonochromePixelValue", 0x00289099, "Largest Monochrome Pixel Value",
          VR.kUS, VM.k1, true);
  static const ElementDef kDataRepresentation
      //(0028,9108)
      =
      const ElementDef("DataRepresentation", 0x00289108, "Data Representation", VR.kCS, VM.k1, false);
  static const ElementDef kPixelMeasuresSequence
      //(0028,9110)
      = const ElementDef(
          "PixelMeasuresSequence", 0x00289110, "Pixel Measures Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFrameVOILUTSequence
      //(0028,9132)
      = const ElementDef(
          "FrameVOILUTSequence", 0x00289132, "Frame VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPixelValueTransformationSequence
      //(0028,9145)
      = const ElementDef("PixelValueTransformationSequence", 0x00289145,
          "Pixel Value Transformation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSignalDomainRows
      //(0028,9235)
      = const ElementDef("SignalDomainRows", 0x00289235, "Signal Domain Rows", VR.kCS, VM.k1, false);
  static const ElementDef kDisplayFilterPercentage
      //(0028,9411)
      = const ElementDef("DisplayFilterPercentage", 0x00289411, "Display Filter Percentage",
          VR.kFL, VM.k1, false);
  static const ElementDef kFramePixelShiftSequence
      //(0028,9415)
      = const ElementDef("FramePixelShiftSequence", 0x00289415, "Frame Pixel Shift Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSubtractionItemID
      //(0028,9416)
      = const ElementDef("SubtractionItemID", 0x00289416, "Subtraction Item ID", VR.kUS, VM.k1, false);
  static const ElementDef kPixelIntensityRelationshipLUTSequence
      //(0028,9422)
      = const ElementDef("PixelIntensityRelationshipLUTSequence", 0x00289422,
          "Pixel Intensity Relationship LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFramePixelDataPropertiesSequence
      //(0028,9443)
      = const ElementDef("FramePixelDataPropertiesSequence", 0x00289443,
          "Frame Pixel Data Properties Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGeometricalProperties
      //(0028,9444)
      = const ElementDef(
          "GeometricalProperties", 0x00289444, "Geometrical Properties", VR.kCS, VM.k1, false);
  static const ElementDef kGeometricMaximumDistortion
      //(0028,9445)
      = const ElementDef("GeometricMaximumDistortion", 0x00289445, "Geometric Maximum Distortion",
          VR.kFL, VM.k1, false);
  static const ElementDef kImageProcessingApplied
      //(0028,9446)
      = const ElementDef(
          "ImageProcessingApplied", 0x00289446, "Image Processing Applied", VR.kCS, VM.k1_n, false);
  static const ElementDef kMaskSelectionMode
      //(0028,9454)
      = const ElementDef("MaskSelectionMode", 0x00289454, "Mask Selection Mode", VR.kCS, VM.k1, false);
  static const ElementDef kLUTFunction
      //(0028,9474)
      = const ElementDef("LUTFunction", 0x00289474, "LUT Function", VR.kCS, VM.k1, false);
  static const ElementDef kMaskVisibilityPercentage
      //(0028,9478)
      = const ElementDef("MaskVisibilityPercentage", 0x00289478, "Mask Visibility Percentage",
          VR.kFL, VM.k1, false);
  static const ElementDef kPixelShiftSequence
      //(0028,9501)
      =
      const ElementDef("PixelShiftSequence", 0x00289501, "Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRegionPixelShiftSequence
      //(0028,9502)
      = const ElementDef("RegionPixelShiftSequence", 0x00289502, "Region Pixel Shift Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kVerticesOfTheRegion
      //(0028,9503)
      = const ElementDef(
          "VerticesOfTheRegion", 0x00289503, "Vertices of the Region", VR.kSS, VM.k2_2n, false);
  static const ElementDef kMultiFramePresentationSequence
      //(0028,9505)
      = const ElementDef("MultiFramePresentationSequence", 0x00289505,
          "Multi-frame Presentation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPixelShiftFrameRange
      //(0028,9506)
      = const ElementDef(
          "PixelShiftFrameRange", 0x00289506, "Pixel Shift Frame Range", VR.kUS, VM.k2_2n, false);
  static const ElementDef kLUTFrameRange
      //(0028,9507)
      = const ElementDef("LUTFrameRange", 0x00289507, "LUT Frame Range", VR.kUS, VM.k2_2n, false);
  static const ElementDef kImageToEquipmentMappingMatrix
      //(0028,9520)
      = const ElementDef("ImageToEquipmentMappingMatrix", 0x00289520,
          "Image to Equipment Mapping Matrix", VR.kDS, VM.k16, false);
  static const ElementDef kEquipmentCoordinateSystemIdentification
      //(0028,9537)
      = const ElementDef("EquipmentCoordinateSystemIdentification", 0x00289537,
          "Equipment Coordinate System Identification", VR.kCS, VM.k1, false);
  static const ElementDef kStudyStatusID
      //(0032,000A)
      = const ElementDef("StudyStatusID", 0x0032000A, "Study Status ID", VR.kCS, VM.k1, true);
  static const ElementDef kStudyPriorityID
      //(0032,000C)
      = const ElementDef("StudyPriorityID", 0x0032000C, "Study Priority ID", VR.kCS, VM.k1, true);
  static const ElementDef kStudyIDIssuer
      //(0032,0012)
      = const ElementDef("StudyIDIssuer", 0x00320012, "Study ID Issuer", VR.kLO, VM.k1, true);
  static const ElementDef kStudyVerifiedDate
      //(0032,0032)
      = const ElementDef("StudyVerifiedDate", 0x00320032, "Study Verified Date", VR.kDA, VM.k1, true);
  static const ElementDef kStudyVerifiedTime
      //(0032,0033)
      = const ElementDef("StudyVerifiedTime", 0x00320033, "Study Verified Time", VR.kTM, VM.k1, true);
  static const ElementDef kStudyReadDate
      //(0032,0034)
      = const ElementDef("StudyReadDate", 0x00320034, "Study Read Date", VR.kDA, VM.k1, true);
  static const ElementDef kStudyReadTime
      //(0032,0035)
      = const ElementDef("StudyReadTime", 0x00320035, "Study Read Time", VR.kTM, VM.k1, true);
  static const ElementDef kScheduledStudyStartDate
      //(0032,1000)
      = const ElementDef(
          "ScheduledStudyStartDate", 0x00321000, "Scheduled Study Start Date", VR.kDA, VM.k1, true);
  static const ElementDef kScheduledStudyStartTime
      //(0032,1001)
      = const ElementDef(
          "ScheduledStudyStartTime", 0x00321001, "Scheduled Study Start Time", VR.kTM, VM.k1, true);
  static const ElementDef kScheduledStudyStopDate
      //(0032,1010)
      = const ElementDef(
          "ScheduledStudyStopDate", 0x00321010, "Scheduled Study Stop Date", VR.kDA, VM.k1, true);
  static const ElementDef kScheduledStudyStopTime
      //(0032,1011)
      = const ElementDef(
          "ScheduledStudyStopTime", 0x00321011, "Scheduled Study Stop Time", VR.kTM, VM.k1, true);
  static const ElementDef kScheduledStudyLocation
      //(0032,1020)
      = const ElementDef(
          "ScheduledStudyLocation", 0x00321020, "Scheduled Study Location", VR.kLO, VM.k1, true);
  static const ElementDef kScheduledStudyLocationAETitle
      //(0032,1021)
      = const ElementDef("ScheduledStudyLocationAETitle", 0x00321021,
          "Scheduled Study Location AE Title", VR.kAE, VM.k1_n, true);
  static const ElementDef kReasonForStudy
      //(0032,1030)
      = const ElementDef("ReasonForStudy", 0x00321030, "Reason for Study", VR.kLO, VM.k1, true);
  static const ElementDef kRequestingPhysicianIdentificationSequence
      //(0032,1031)
      = const ElementDef("RequestingPhysicianIdentificationSequence", 0x00321031,
          "Requesting Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRequestingPhysician
      //(0032,1032)
      = const ElementDef(
          "RequestingPhysician", 0x00321032, "Requesting Physician", VR.kPN, VM.k1, false);
  static const ElementDef kRequestingService
      //(0032,1033)
      = const ElementDef("RequestingService", 0x00321033, "Requesting Service", VR.kLO, VM.k1, false);
  static const ElementDef kRequestingServiceCodeSequence
      //(0032,1034)
      = const ElementDef("RequestingServiceCodeSequence", 0x00321034,
          "Requesting Service Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStudyArrivalDate
      //(0032,1040)
      = const ElementDef("StudyArrivalDate", 0x00321040, "Study Arrival Date", VR.kDA, VM.k1, true);
  static const ElementDef kStudyArrivalTime
      //(0032,1041)
      = const ElementDef("StudyArrivalTime", 0x00321041, "Study Arrival Time", VR.kTM, VM.k1, true);
  static const ElementDef kStudyCompletionDate
      //(0032,1050)
      = const ElementDef(
          "StudyCompletionDate", 0x00321050, "Study Completion Date", VR.kDA, VM.k1, true);
  static const ElementDef kStudyCompletionTime
      //(0032,1051)
      = const ElementDef(
          "StudyCompletionTime", 0x00321051, "Study Completion Time", VR.kTM, VM.k1, true);
  static const ElementDef kStudyComponentStatusID
      //(0032,1055)
      = const ElementDef(
          "StudyComponentStatusID", 0x00321055, "Study Component Status ID", VR.kCS, VM.k1, true);
  static const ElementDef kRequestedProcedureDescription
      //(0032,1060)
      = const ElementDef("RequestedProcedureDescription", 0x00321060,
          "Requested Procedure Description", VR.kLO, VM.k1, false);
  static const ElementDef kRequestedProcedureCodeSequence
      //(0032,1064)
      = const ElementDef("RequestedProcedureCodeSequence", 0x00321064,
          "Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRequestedContrastAgent
      //(0032,1070)
      = const ElementDef("RequestedContrastAgent", 0x00321070, "Requested Contrast Agent", VR.kLO,
          VM.k1, false);
  static const ElementDef kStudyComments
      //(0032,4000)
      = const ElementDef("StudyComments", 0x00324000, "Study Comments", VR.kLT, VM.k1, true);
  static const ElementDef kReferencedPatientAliasSequence
      //(0038,0004)
      = const ElementDef("ReferencedPatientAliasSequence", 0x00380004,
          "Referenced Patient Alias Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisitStatusID
      //(0038,0008)
      = const ElementDef("VisitStatusID", 0x00380008, "Visit Status ID", VR.kCS, VM.k1, false);
  static const ElementDef kAdmissionID
      //(0038,0010)
      = const ElementDef("AdmissionID", 0x00380010, "Admission ID", VR.kLO, VM.k1, false);
  static const ElementDef kIssuerOfAdmissionID
      //(0038,0011)
      = const ElementDef(
          "IssuerOfAdmissionID", 0x00380011, "Issuer of Admission ID", VR.kLO, VM.k1, true);
  static const ElementDef kIssuerOfAdmissionIDSequence
      //(0038,0014)
      = const ElementDef("IssuerOfAdmissionIDSequence", 0x00380014, "Issuer of Admission ID Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRouteOfAdmissions
      //(0038,0016)
      = const ElementDef("RouteOfAdmissions", 0x00380016, "Route of Admissions", VR.kLO, VM.k1, false);
  static const ElementDef kScheduledAdmissionDate
      //(0038,001A)
      = const ElementDef(
          "ScheduledAdmissionDate", 0x0038001A, "Scheduled Admission Date", VR.kDA, VM.k1, true);
  static const ElementDef kScheduledAdmissionTime
      //(0038,001B)
      = const ElementDef(
          "ScheduledAdmissionTime", 0x0038001B, "Scheduled Admission Time", VR.kTM, VM.k1, true);
  static const ElementDef kScheduledDischargeDate
      //(0038,001C)
      = const ElementDef(
          "ScheduledDischargeDate", 0x0038001C, "Scheduled Discharge Date", VR.kDA, VM.k1, true);
  static const ElementDef kScheduledDischargeTime
      //(0038,001D)
      = const ElementDef(
          "ScheduledDischargeTime", 0x0038001D, "Scheduled Discharge Time", VR.kTM, VM.k1, true);
  static const ElementDef kScheduledPatientInstitutionResidence
      //(0038,001E)
      = const ElementDef("ScheduledPatientInstitutionResidence", 0x0038001E,
          "Scheduled Patient Institution Residence", VR.kLO, VM.k1, true);
  static const ElementDef kAdmittingDate
      //(0038,0020)
      = const ElementDef("AdmittingDate", 0x00380020, "Admitting Date", VR.kDA, VM.k1, false);
  static const ElementDef kAdmittingTime
      //(0038,0021)
      = const ElementDef("AdmittingTime", 0x00380021, "Admitting Time", VR.kTM, VM.k1, false);
  static const ElementDef kDischargeDate
      //(0038,0030)
      = const ElementDef("DischargeDate", 0x00380030, "Discharge Date", VR.kDA, VM.k1, true);
  static const ElementDef kDischargeTime
      //(0038,0032)
      = const ElementDef("DischargeTime", 0x00380032, "Discharge Time", VR.kTM, VM.k1, true);
  static const ElementDef kDischargeDiagnosisDescription
      //(0038,0040)
      = const ElementDef("DischargeDiagnosisDescription", 0x00380040,
          "Discharge Diagnosis Description", VR.kLO, VM.k1, true);
  static const ElementDef kDischargeDiagnosisCodeSequence
      //(0038,0044)
      = const ElementDef("DischargeDiagnosisCodeSequence", 0x00380044,
          "Discharge Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kSpecialNeeds
      //(0038,0050)
      = const ElementDef("SpecialNeeds", 0x00380050, "Special Needs", VR.kLO, VM.k1, false);
  static const ElementDef kServiceEpisodeID
      //(0038,0060)
      = const ElementDef("ServiceEpisodeID", 0x00380060, "Service Episode ID", VR.kLO, VM.k1, false);
  static const ElementDef kIssuerOfServiceEpisodeID
      //(0038,0061)
      = const ElementDef("IssuerOfServiceEpisodeID", 0x00380061, "Issuer of Service Episode ID",
          VR.kLO, VM.k1, true);
  static const ElementDef kServiceEpisodeDescription
      //(0038,0062)
      = const ElementDef("ServiceEpisodeDescription", 0x00380062, "Service Episode Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kIssuerOfServiceEpisodeIDSequence
      //(0038,0064)
      = const ElementDef("IssuerOfServiceEpisodeIDSequence", 0x00380064,
          "Issuer of Service Episode ID Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPertinentDocumentsSequence
      //(0038,0100)
      = const ElementDef("PertinentDocumentsSequence", 0x00380100, "Pertinent Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCurrentPatientLocation
      //(0038,0300)
      = const ElementDef(
          "CurrentPatientLocation", 0x00380300, "Current Patient Location", VR.kLO, VM.k1, false);
  static const ElementDef kPatientInstitutionResidence
      //(0038,0400)
      = const ElementDef("PatientInstitutionResidence", 0x00380400, "Patient's Institution Residence",
          VR.kLO, VM.k1, false);
  static const ElementDef kPatientState
      //(0038,0500)
      = const ElementDef("PatientState", 0x00380500, "Patient State", VR.kLO, VM.k1, false);
  static const ElementDef kPatientClinicalTrialParticipationSequence
      //(0038,0502)
      = const ElementDef("PatientClinicalTrialParticipationSequence", 0x00380502,
          "Patient Clinical Trial Participation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisitComments
      //(0038,4000)
      = const ElementDef("VisitComments", 0x00384000, "Visit Comments", VR.kLT, VM.k1, false);
  static const ElementDef kWaveformOriginality
      //(003A,0004)
      = const ElementDef(
          "WaveformOriginality", 0x003A0004, "Waveform Originality", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfWaveformChannels
      //(003A,0005)
      = const ElementDef("NumberOfWaveformChannels", 0x003A0005, "Number of Waveform Channels", VR.kUS,
          VM.k1, false);
  static const ElementDef kNumberOfWaveformSamples
      //(003A,0010)
      = const ElementDef("NumberOfWaveformSamples", 0x003A0010, "Number of Waveform Samples", VR.kUL,
          VM.k1, false);
  static const ElementDef kSamplingFrequency
      //(003A,001A)
      = const ElementDef("SamplingFrequency", 0x003A001A, "Sampling Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kMultiplexGroupLabel
      //(003A,0020)
      = const ElementDef(
          "MultiplexGroupLabel", 0x003A0020, "Multiplex Group Label", VR.kSH, VM.k1, false);
  static const ElementDef kChannelDefinitionSequence
      //(003A,0200)
      = const ElementDef("ChannelDefinitionSequence", 0x003A0200, "Channel Definition Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kWaveformChannelNumber
      //(003A,0202)
      = const ElementDef(
          "WaveformChannelNumber", 0x003A0202, "Waveform Channel Number", VR.kIS, VM.k1, false);
  static const ElementDef kChannelLabel
      //(003A,0203)
      = const ElementDef("ChannelLabel", 0x003A0203, "Channel Label", VR.kSH, VM.k1, false);
  static const ElementDef kChannelStatus
      //(003A,0205)
      = const ElementDef("ChannelStatus", 0x003A0205, "Channel Status", VR.kCS, VM.k1_n, false);
  static const ElementDef kChannelSourceSequence
      //(003A,0208)
      = const ElementDef(
          "ChannelSourceSequence", 0x003A0208, "Channel Source Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelSourceModifiersSequence
      //(003A,0209)
      = const ElementDef("ChannelSourceModifiersSequence", 0x003A0209,
          "Channel Source Modifiers Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceWaveformSequence
      //(003A,020A)
      = const ElementDef(
          "SourceWaveformSequence", 0x003A020A, "Source Waveform Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelDerivationDescription
      //(003A,020C)
      = const ElementDef("ChannelDerivationDescription", 0x003A020C, "Channel Derivation Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kChannelSensitivity
      //(003A,0210)
      =
      const ElementDef("ChannelSensitivity", 0x003A0210, "Channel Sensitivity", VR.kDS, VM.k1, false);
  static const ElementDef kChannelSensitivityUnitsSequence
      //(003A,0211)
      = const ElementDef("ChannelSensitivityUnitsSequence", 0x003A0211,
          "Channel Sensitivity Units Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelSensitivityCorrectionFactor
      //(003A,0212)
      = const ElementDef("ChannelSensitivityCorrectionFactor", 0x003A0212,
          "Channel Sensitivity Correction Factor", VR.kDS, VM.k1, false);
  static const ElementDef kChannelBaseline
      //(003A,0213)
      = const ElementDef("ChannelBaseline", 0x003A0213, "Channel Baseline", VR.kDS, VM.k1, false);
  static const ElementDef kChannelTimeSkew
      //(003A,0214)
      = const ElementDef("ChannelTimeSkew", 0x003A0214, "Channel Time Skew", VR.kDS, VM.k1, false);
  static const ElementDef kChannelSampleSkew
      //(003A,0215)
      = const ElementDef("ChannelSampleSkew", 0x003A0215, "Channel Sample Skew", VR.kDS, VM.k1, false);
  static const ElementDef kChannelOffset
      //(003A,0218)
      = const ElementDef("ChannelOffset", 0x003A0218, "Channel Offset", VR.kDS, VM.k1, false);
  static const ElementDef kWaveformBitsStored
      //(003A,021A)
      =
      const ElementDef("WaveformBitsStored", 0x003A021A, "Waveform Bits Stored", VR.kUS, VM.k1, false);
  static const ElementDef kFilterLowFrequency
      //(003A,0220)
      =
      const ElementDef("FilterLowFrequency", 0x003A0220, "Filter Low Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kFilterHighFrequency
      //(003A,0221)
      = const ElementDef(
          "FilterHighFrequency", 0x003A0221, "Filter High Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kNotchFilterFrequency
      //(003A,0222)
      = const ElementDef(
          "NotchFilterFrequency", 0x003A0222, "Notch Filter Frequency", VR.kDS, VM.k1, false);
  static const ElementDef kNotchFilterBandwidth
      //(003A,0223)
      = const ElementDef(
          "NotchFilterBandwidth", 0x003A0223, "Notch Filter Bandwidth", VR.kDS, VM.k1, false);
  static const ElementDef kWaveformDataDisplayScale
      //(003A,0230)
      = const ElementDef("WaveformDataDisplayScale", 0x003A0230, "Waveform Data Display Scale", VR.kFL,
          VM.k1, false);
  static const ElementDef kWaveformDisplayBackgroundCIELabValue
      //(003A,0231)
      = const ElementDef("WaveformDisplayBackgroundCIELabValue", 0x003A0231,
          "Waveform Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kWaveformPresentationGroupSequence
      //(003A,0240)
      = const ElementDef("WaveformPresentationGroupSequence", 0x003A0240,
          "Waveform Presentation Group Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPresentationGroupNumber
      //(003A,0241)
      = const ElementDef(
          "PresentationGroupNumber", 0x003A0241, "Presentation Group Number", VR.kUS, VM.k1, false);
  static const ElementDef kChannelDisplaySequence
      //(003A,0242)
      = const ElementDef(
          "ChannelDisplaySequence", 0x003A0242, "Channel Display Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelRecommendedDisplayCIELabValue
      //(003A,0244)
      = const ElementDef("ChannelRecommendedDisplayCIELabValue", 0x003A0244,
          "Channel Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kChannelPosition
      //(003A,0245)
      = const ElementDef("ChannelPosition", 0x003A0245, "Channel Position", VR.kFL, VM.k1, false);
  static const ElementDef kDisplayShadingFlag
      //(003A,0246)
      =
      const ElementDef("DisplayShadingFlag", 0x003A0246, "Display Shading Flag", VR.kCS, VM.k1, false);
  static const ElementDef kFractionalChannelDisplayScale
      //(003A,0247)
      = const ElementDef("FractionalChannelDisplayScale", 0x003A0247,
          "Fractional Channel Display Scale", VR.kFL, VM.k1, false);
  static const ElementDef kAbsoluteChannelDisplayScale
      //(003A,0248)
      = const ElementDef("AbsoluteChannelDisplayScale", 0x003A0248, "Absolute Channel Display Scale",
          VR.kFL, VM.k1, false);
  static const ElementDef kMultiplexedAudioChannelsDescriptionCodeSequence
      //(003A,0300)
      = const ElementDef("MultiplexedAudioChannelsDescriptionCodeSequence", 0x003A0300,
          "Multiplexed Audio Channels Description Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelIdentificationCode
      //(003A,0301)
      = const ElementDef("ChannelIdentificationCode", 0x003A0301, "Channel Identification Code",
          VR.kIS, VM.k1, false);
  static const ElementDef kChannelMode
      //(003A,0302)
      = const ElementDef("ChannelMode", 0x003A0302, "Channel Mode", VR.kCS, VM.k1, false);
  static const ElementDef kScheduledStationAETitle
      //(0040,0001)
      = const ElementDef("ScheduledStationAETitle", 0x00400001, "Scheduled Station AE Title", VR.kAE,
          VM.k1_n, false);
  static const ElementDef kScheduledProcedureStepStartDate
      //(0040,0002)
      = const ElementDef("ScheduledProcedureStepStartDate", 0x00400002,
          "Scheduled Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const ElementDef kScheduledProcedureStepStartTime
      //(0040,0003)
      = const ElementDef("ScheduledProcedureStepStartTime", 0x00400003,
          "Scheduled Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const ElementDef kScheduledProcedureStepEndDate
      //(0040,0004)
      = const ElementDef("ScheduledProcedureStepEndDate", 0x00400004,
          "Scheduled Procedure Step End Date", VR.kDA, VM.k1, false);
  static const ElementDef kScheduledProcedureStepEndTime
      //(0040,0005)
      = const ElementDef("ScheduledProcedureStepEndTime", 0x00400005,
          "Scheduled Procedure Step End Time", VR.kTM, VM.k1, false);
  static const ElementDef kScheduledPerformingPhysicianName
      //(0040,0006)
      = const ElementDef("ScheduledPerformingPhysicianName", 0x00400006,
          "Scheduled Performing Physician's Name", VR.kPN, VM.k1, false);
  static const ElementDef kScheduledProcedureStepDescription
      //(0040,0007)
      = const ElementDef("ScheduledProcedureStepDescription", 0x00400007,
          "Scheduled Procedure Step Description", VR.kLO, VM.k1, false);
  static const ElementDef kScheduledProtocolCodeSequence
      //(0040,0008)
      = const ElementDef("ScheduledProtocolCodeSequence", 0x00400008,
          "Scheduled Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledProcedureStepID
      //(0040,0009)
      = const ElementDef("ScheduledProcedureStepID", 0x00400009, "Scheduled Procedure Step ID", VR.kSH,
          VM.k1, false);
  static const ElementDef kStageCodeSequence
      //(0040,000A)
      = const ElementDef(
          "StageCodeSequence", 0x0040000A, "Stage Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledPerformingPhysicianIdentificationSequence
      //(0040,000B)
      = const ElementDef("ScheduledPerformingPhysicianIdentificationSequence", 0x0040000B,
          "Scheduled Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledStationName
      //(0040,0010)
      = const ElementDef(
          "ScheduledStationName", 0x00400010, "Scheduled Station Name", VR.kSH, VM.k1_n, false);
  static const ElementDef kScheduledProcedureStepLocation
      //(0040,0011)
      = const ElementDef("ScheduledProcedureStepLocation", 0x00400011,
          "Scheduled Procedure Step Location", VR.kSH, VM.k1, false);
  static const ElementDef kPreMedication
      //(0040,0012)
      = const ElementDef("PreMedication", 0x00400012, "Pre-Medication", VR.kLO, VM.k1, false);
  static const ElementDef kScheduledProcedureStepStatus
      //(0040,0020)
      = const ElementDef("ScheduledProcedureStepStatus", 0x00400020, "Scheduled Procedure Step Status",
          VR.kCS, VM.k1, false);
  static const ElementDef kOrderPlacerIdentifierSequence
      //(0040,0026)
      = const ElementDef("OrderPlacerIdentifierSequence", 0x00400026,
          "Order Placer Identifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOrderFillerIdentifierSequence
      //(0040,0027)
      = const ElementDef("OrderFillerIdentifierSequence", 0x00400027,
          "Order Filler Identifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLocalNamespaceEntityID
      //(0040,0031)
      = const ElementDef(
          "LocalNamespaceEntityID", 0x00400031, "Local Namespace Entity ID", VR.kUT, VM.k1, false);
  static const ElementDef kUniversalEntityID
      //(0040,0032)
      = const ElementDef("UniversalEntityID", 0x00400032, "Universal Entity ID", VR.kUT, VM.k1, false);
  static const ElementDef kUniversalEntityIDType
      //(0040,0033)
      = const ElementDef(
          "UniversalEntityIDType", 0x00400033, "Universal Entity ID Type", VR.kCS, VM.k1, false);
  static const ElementDef kIdentifierTypeCode
      //(0040,0035)
      =
      const ElementDef("IdentifierTypeCode", 0x00400035, "Identifier Type Code", VR.kCS, VM.k1, false);
  static const ElementDef kAssigningFacilitySequence
      //(0040,0036)
      = const ElementDef("AssigningFacilitySequence", 0x00400036, "Assigning Facility Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAssigningJurisdictionCodeSequence
      //(0040,0039)
      = const ElementDef("AssigningJurisdictionCodeSequence", 0x00400039,
          "Assigning Jurisdiction Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAssigningAgencyOrDepartmentCodeSequence
      //(0040,003A)
      = const ElementDef("AssigningAgencyOrDepartmentCodeSequence", 0x0040003A,
          "Assigning Agency or Department Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledProcedureStepSequence
      //(0040,0100)
      = const ElementDef("ScheduledProcedureStepSequence", 0x00400100,
          "Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedNonImageCompositeSOPInstanceSequence
      //(0040,0220)
      = const ElementDef("ReferencedNonImageCompositeSOPInstanceSequence", 0x00400220,
          "Referenced Non-Image Composite SOP Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedStationAETitle
      //(0040,0241)
      = const ElementDef("PerformedStationAETitle", 0x00400241, "Performed Station AE Title", VR.kAE,
          VM.k1, false);
  static const ElementDef kPerformedStationName
      //(0040,0242)
      = const ElementDef(
          "PerformedStationName", 0x00400242, "Performed Station Name", VR.kSH, VM.k1, false);
  static const ElementDef kPerformedLocation
      //(0040,0243)
      = const ElementDef("PerformedLocation", 0x00400243, "Performed Location", VR.kSH, VM.k1, false);
  static const ElementDef kPerformedProcedureStepStartDate
      //(0040,0244)
      = const ElementDef("PerformedProcedureStepStartDate", 0x00400244,
          "Performed Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const ElementDef kPerformedProcedureStepStartTime
      //(0040,0245)
      = const ElementDef("PerformedProcedureStepStartTime", 0x00400245,
          "Performed Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const ElementDef kPerformedProcedureStepEndDate
      //(0040,0250)
      = const ElementDef("PerformedProcedureStepEndDate", 0x00400250,
          "Performed Procedure Step End Date", VR.kDA, VM.k1, false);
  static const ElementDef kPerformedProcedureStepEndTime
      //(0040,0251)
      = const ElementDef("PerformedProcedureStepEndTime", 0x00400251,
          "Performed Procedure Step End Time", VR.kTM, VM.k1, false);
  static const ElementDef kPerformedProcedureStepStatus
      //(0040,0252)
      = const ElementDef("PerformedProcedureStepStatus", 0x00400252, "Performed Procedure Step Status",
          VR.kCS, VM.k1, false);
  static const ElementDef kPerformedProcedureStepID
      //(0040,0253)
      = const ElementDef("PerformedProcedureStepID", 0x00400253, "Performed Procedure Step ID", VR.kSH,
          VM.k1, false);
  static const ElementDef kPerformedProcedureStepDescription
      //(0040,0254)
      = const ElementDef("PerformedProcedureStepDescription", 0x00400254,
          "Performed Procedure Step Description", VR.kLO, VM.k1, false);
  static const ElementDef kPerformedProcedureTypeDescription
      //(0040,0255)
      = const ElementDef("PerformedProcedureTypeDescription", 0x00400255,
          "Performed Procedure Type Description", VR.kLO, VM.k1, false);
  static const ElementDef kPerformedProtocolCodeSequence
      //(0040,0260)
      = const ElementDef("PerformedProtocolCodeSequence", 0x00400260,
          "Performed Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedProtocolType
      //(0040,0261)
      = const ElementDef(
          "PerformedProtocolType", 0x00400261, "Performed Protocol Type", VR.kCS, VM.k1, false);
  static const ElementDef kScheduledStepAttributesSequence
      //(0040,0270)
      = const ElementDef("ScheduledStepAttributesSequence", 0x00400270,
          "Scheduled Step Attributes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRequestAttributesSequence
      //(0040,0275)
      = const ElementDef("RequestAttributesSequence", 0x00400275, "Request Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCommentsOnThePerformedProcedureStep
      //(0040,0280)
      = const ElementDef("CommentsOnThePerformedProcedureStep", 0x00400280,
          "Comments on the Performed Procedure Step", VR.kST, VM.k1, false);
  static const ElementDef kPerformedProcedureStepDiscontinuationReasonCodeSequence
      //(0040,0281)
      = const ElementDef("PerformedProcedureStepDiscontinuationReasonCodeSequence", 0x00400281,
          "Performed Procedure Step Discontinuation Reason Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kQuantitySequence
      //(0040,0293)
      = const ElementDef("QuantitySequence", 0x00400293, "Quantity Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kQuantity
      //(0040,0294)
      = const ElementDef("Quantity", 0x00400294, "Quantity", VR.kDS, VM.k1, false);
  static const ElementDef kMeasuringUnitsSequence
      //(0040,0295)
      = const ElementDef(
          "MeasuringUnitsSequence", 0x00400295, "Measuring Units Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBillingItemSequence
      //(0040,0296)
      = const ElementDef(
          "BillingItemSequence", 0x00400296, "Billing Item Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTotalTimeOfFluoroscopy
      //(0040,0300)
      = const ElementDef(
          "TotalTimeOfFluoroscopy", 0x00400300, "Total Time of Fluoroscopy", VR.kUS, VM.k1, false);
  static const ElementDef kTotalNumberOfExposures
      //(0040,0301)
      = const ElementDef(
          "TotalNumberOfExposures", 0x00400301, "Total Number of Exposures", VR.kUS, VM.k1, false);
  static const ElementDef kEntranceDose
      //(0040,0302)
      = const ElementDef("EntranceDose", 0x00400302, "Entrance Dose", VR.kUS, VM.k1, false);
  static const ElementDef kExposedArea
      //(0040,0303)
      = const ElementDef("ExposedArea", 0x00400303, "Exposed Area", VR.kUS, VM.k1_2, false);
  static const ElementDef kDistanceSourceToEntrance
      //(0040,0306)
      = const ElementDef("DistanceSourceToEntrance", 0x00400306, "Distance Source to Entrance", VR.kDS,
          VM.k1, false);
  static const ElementDef kDistanceSourceToSupport
      //(0040,0307)
      = const ElementDef(
          "DistanceSourceToSupport", 0x00400307, "Distance Source to Support", VR.kDS, VM.k1, true);
  static const ElementDef kExposureDoseSequence
      //(0040,030E)
      = const ElementDef(
          "ExposureDoseSequence", 0x0040030E, "Exposure Dose Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCommentsOnRadiationDose
      //(0040,0310)
      = const ElementDef("CommentsOnRadiationDose", 0x00400310, "Comments on Radiation Dose", VR.kST,
          VM.k1, false);
  static const ElementDef kXRayOutput
      //(0040,0312)
      = const ElementDef("XRayOutput", 0x00400312, "X-Ray Output", VR.kDS, VM.k1, false);
  static const ElementDef kHalfValueLayer
      //(0040,0314)
      = const ElementDef("HalfValueLayer", 0x00400314, "Half Value Layer", VR.kDS, VM.k1, false);
  static const ElementDef kOrganDose
      //(0040,0316)
      = const ElementDef("OrganDose", 0x00400316, "Organ Dose", VR.kDS, VM.k1, false);
  static const ElementDef kOrganExposed
      //(0040,0318)
      = const ElementDef("OrganExposed", 0x00400318, "Organ Exposed", VR.kCS, VM.k1, false);
  static const ElementDef kBillingProcedureStepSequence
      //(0040,0320)
      = const ElementDef("BillingProcedureStepSequence", 0x00400320, "Billing Procedure Step Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kFilmConsumptionSequence
      //(0040,0321)
      = const ElementDef(
          "FilmConsumptionSequence", 0x00400321, "Film Consumption Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBillingSuppliesAndDevicesSequence
      //(0040,0324)
      = const ElementDef("BillingSuppliesAndDevicesSequence", 0x00400324,
          "Billing Supplies and Devices Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedProcedureStepSequence
      //(0040,0330)
      = const ElementDef("ReferencedProcedureStepSequence", 0x00400330,
          "Referenced Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kPerformedSeriesSequence
      //(0040,0340)
      = const ElementDef(
          "PerformedSeriesSequence", 0x00400340, "Performed Series Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCommentsOnTheScheduledProcedureStep
      //(0040,0400)
      = const ElementDef("CommentsOnTheScheduledProcedureStep", 0x00400400,
          "Comments on the Scheduled Procedure Step", VR.kLT, VM.k1, false);
  static const ElementDef kProtocolContextSequence
      //(0040,0440)
      = const ElementDef(
          "ProtocolContextSequence", 0x00400440, "Protocol Context Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContentItemModifierSequence
      //(0040,0441)
      = const ElementDef("ContentItemModifierSequence", 0x00400441, "Content Item Modifier Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledSpecimenSequence
      //(0040,0500)
      = const ElementDef("ScheduledSpecimenSequence", 0x00400500, "Scheduled Specimen Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenAccessionNumber
      //(0040,050A)
      = const ElementDef(
          "SpecimenAccessionNumber", 0x0040050A, "Specimen Accession Number", VR.kLO, VM.k1, true);
  static const ElementDef kContainerIdentifier
      //(0040,0512)
      = const ElementDef(
          "ContainerIdentifier", 0x00400512, "Container Identifier", VR.kLO, VM.k1, false);
  static const ElementDef kIssuerOfTheContainerIdentifierSequence
      //(0040,0513)
      = const ElementDef("IssuerOfTheContainerIdentifierSequence", 0x00400513,
          "Issuer of the Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAlternateContainerIdentifierSequence
      //(0040,0515)
      = const ElementDef("AlternateContainerIdentifierSequence", 0x00400515,
          "Alternate Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContainerTypeCodeSequence
      //(0040,0518)
      = const ElementDef("ContainerTypeCodeSequence", 0x00400518, "Container Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kContainerDescription
      //(0040,051A)
      = const ElementDef(
          "ContainerDescription", 0x0040051A, "Container Description", VR.kLO, VM.k1, false);
  static const ElementDef kContainerComponentSequence
      //(0040,0520)
      = const ElementDef("ContainerComponentSequence", 0x00400520, "Container Component Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenSequence
      //(0040,0550)
      = const ElementDef("SpecimenSequence", 0x00400550, "Specimen Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kSpecimenIdentifier
      //(0040,0551)
      =
      const ElementDef("SpecimenIdentifier", 0x00400551, "Specimen Identifier", VR.kLO, VM.k1, false);
  static const ElementDef kSpecimenDescriptionSequenceTrial
      //(0040,0552)
      = const ElementDef("SpecimenDescriptionSequenceTrial", 0x00400552,
          "Specimen Description Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kSpecimenDescriptionTrial
      //(0040,0553)
      = const ElementDef("SpecimenDescriptionTrial", 0x00400553, "Specimen Description (Trial)",
          VR.kST, VM.k1, true);
  static const ElementDef kSpecimenUID
      //(0040,0554)
      = const ElementDef("SpecimenUID", 0x00400554, "Specimen UID", VR.kUI, VM.k1, false);
  static const ElementDef kAcquisitionContextSequence
      //(0040,0555)
      = const ElementDef("AcquisitionContextSequence", 0x00400555, "Acquisition Context Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAcquisitionContextDescription
      //(0040,0556)
      = const ElementDef("AcquisitionContextDescription", 0x00400556,
          "Acquisition Context Description", VR.kST, VM.k1, false);
  static const ElementDef kSpecimenTypeCodeSequence
      //(0040,059A)
      = const ElementDef("SpecimenTypeCodeSequence", 0x0040059A, "Specimen Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSpecimenDescriptionSequence
      //(0040,0560)
      = const ElementDef("SpecimenDescriptionSequence", 0x00400560, "Specimen Description Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kIssuerOfTheSpecimenIdentifierSequence
      //(0040,0562)
      = const ElementDef("IssuerOfTheSpecimenIdentifierSequence", 0x00400562,
          "Issuer of the Specimen Identifier Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenShortDescription
      //(0040,0600)
      = const ElementDef("SpecimenShortDescription", 0x00400600, "Specimen Short Description", VR.kLO,
          VM.k1, false);
  static const ElementDef kSpecimenDetailedDescription
      //(0040,0602)
      = const ElementDef("SpecimenDetailedDescription", 0x00400602, "Specimen Detailed Description",
          VR.kUT, VM.k1, false);
  static const ElementDef kSpecimenPreparationSequence
      //(0040,0610)
      = const ElementDef("SpecimenPreparationSequence", 0x00400610, "Specimen Preparation Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenPreparationStepContentItemSequence
      //(0040,0612)
      = const ElementDef("SpecimenPreparationStepContentItemSequence", 0x00400612,
          "Specimen Preparation Step Content Item Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenLocalizationContentItemSequence
      //(0040,0620)
      = const ElementDef("SpecimenLocalizationContentItemSequence", 0x00400620,
          "Specimen Localization Content Item Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSlideIdentifier
      //(0040,06FA)
      = const ElementDef("SlideIdentifier", 0x004006FA, "Slide Identifier", VR.kLO, VM.k1, true);
  static const ElementDef kImageCenterPointCoordinatesSequence
      //(0040,071A)
      = const ElementDef("ImageCenterPointCoordinatesSequence", 0x0040071A,
          "Image Center Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kXOffsetInSlideCoordinateSystem
      //(0040,072A)
      = const ElementDef("XOffsetInSlideCoordinateSystem", 0x0040072A,
          "X Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const ElementDef kYOffsetInSlideCoordinateSystem
      //(0040,073A)
      = const ElementDef("YOffsetInSlideCoordinateSystem", 0x0040073A,
          "Y Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const ElementDef kZOffsetInSlideCoordinateSystem
      //(0040,074A)
      = const ElementDef("ZOffsetInSlideCoordinateSystem", 0x0040074A,
          "Z Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const ElementDef kPixelSpacingSequence
      //(0040,08D8)
      = const ElementDef(
          "PixelSpacingSequence", 0x004008D8, "Pixel Spacing Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kCoordinateSystemAxisCodeSequence
      //(0040,08DA)
      = const ElementDef("CoordinateSystemAxisCodeSequence", 0x004008DA,
          "Coordinate System Axis Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kMeasurementUnitsCodeSequence
      //(0040,08EA)
      = const ElementDef("MeasurementUnitsCodeSequence", 0x004008EA, "Measurement Units Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kVitalStainCodeSequenceTrial
      //(0040,09F8)
      = const ElementDef("VitalStainCodeSequenceTrial", 0x004009F8,
          "Vital Stain Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kRequestedProcedureID
      //(0040,1001)
      = const ElementDef(
          "RequestedProcedureID", 0x00401001, "Requested Procedure ID", VR.kSH, VM.k1, false);
  static const ElementDef kReasonForTheRequestedProcedure
      //(0040,1002)
      = const ElementDef("ReasonForTheRequestedProcedure", 0x00401002,
          "Reason for the Requested Procedure", VR.kLO, VM.k1, false);
  static const ElementDef kRequestedProcedurePriority
      //(0040,1003)
      = const ElementDef("RequestedProcedurePriority", 0x00401003, "Requested Procedure Priority",
          VR.kSH, VM.k1, false);
  static const ElementDef kPatientTransportArrangements
      //(0040,1004)
      = const ElementDef("PatientTransportArrangements", 0x00401004, "Patient Transport Arrangements",
          VR.kLO, VM.k1, false);
  static const ElementDef kRequestedProcedureLocation
      //(0040,1005)
      = const ElementDef("RequestedProcedureLocation", 0x00401005, "Requested Procedure Location",
          VR.kLO, VM.k1, false);
  static const ElementDef kPlacerOrderNumberProcedure
      //(0040,1006)
      = const ElementDef("PlacerOrderNumberProcedure", 0x00401006, "Placer Order Number / Procedure",
          VR.kSH, VM.k1, true);
  static const ElementDef kFillerOrderNumberProcedure
      //(0040,1007)
      = const ElementDef("FillerOrderNumberProcedure", 0x00401007, "Filler Order Number / Procedure",
          VR.kSH, VM.k1, true);
  static const ElementDef kConfidentialityCode
      //(0040,1008)
      = const ElementDef(
          "ConfidentialityCode", 0x00401008, "Confidentiality Code", VR.kLO, VM.k1, false);
  static const ElementDef kReportingPriority
      //(0040,1009)
      = const ElementDef("ReportingPriority", 0x00401009, "Reporting Priority", VR.kSH, VM.k1, false);
  static const ElementDef kReasonForRequestedProcedureCodeSequence
      //(0040,100A)
      = const ElementDef("ReasonForRequestedProcedureCodeSequence", 0x0040100A,
          "Reason for Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNamesOfIntendedRecipientsOfResults
      //(0040,1010)
      = const ElementDef("NamesOfIntendedRecipientsOfResults", 0x00401010,
          "Names of Intended Recipients of Results", VR.kPN, VM.k1_n, false);
  static const ElementDef kIntendedRecipientsOfResultsIdentificationSequence
      //(0040,1011)
      = const ElementDef("IntendedRecipientsOfResultsIdentificationSequence", 0x00401011,
          "Intended Recipients of Results Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReasonForPerformedProcedureCodeSequence
      //(0040,1012)
      = const ElementDef("ReasonForPerformedProcedureCodeSequence", 0x00401012,
          "Reason For Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRequestedProcedureDescriptionTrial
      //(0040,1060)
      = const ElementDef("RequestedProcedureDescriptionTrial", 0x00401060,
          "Requested Procedure Description (Trial)", VR.kLO, VM.k1, true);
  static const ElementDef kPersonIdentificationCodeSequence
      //(0040,1101)
      = const ElementDef("PersonIdentificationCodeSequence", 0x00401101,
          "Person Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPersonAddress
      //(0040,1102)
      = const ElementDef("PersonAddress", 0x00401102, "Person's Address", VR.kST, VM.k1, false);
  static const ElementDef kPersonTelephoneNumbers
      //(0040,1103)
      = const ElementDef("PersonTelephoneNumbers", 0x00401103, "Person's Telephone Numbers", VR.kLO,
          VM.k1_n, false);
  static const ElementDef kRequestedProcedureComments
      //(0040,1400)
      = const ElementDef("RequestedProcedureComments", 0x00401400, "Requested Procedure Comments",
          VR.kLT, VM.k1, false);
  static const ElementDef kReasonForTheImagingServiceRequest
      //(0040,2001)
      = const ElementDef("ReasonForTheImagingServiceRequest", 0x00402001,
          "Reason for the Imaging Service Request", VR.kLO, VM.k1, true);
  static const ElementDef kIssueDateOfImagingServiceRequest
      //(0040,2004)
      = const ElementDef("IssueDateOfImagingServiceRequest", 0x00402004,
          "Issue Date of Imaging Service Request", VR.kDA, VM.k1, false);
  static const ElementDef kIssueTimeOfImagingServiceRequest
      //(0040,2005)
      = const ElementDef("IssueTimeOfImagingServiceRequest", 0x00402005,
          "Issue Time of Imaging Service Request", VR.kTM, VM.k1, false);
  static const ElementDef kPlacerOrderNumberImagingServiceRequestRetired
      //(0040,2006)
      = const ElementDef("PlacerOrderNumberImagingServiceRequestRetired", 0x00402006,
          "Placer Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const ElementDef kFillerOrderNumberImagingServiceRequestRetired
      //(0040,2007)
      = const ElementDef("FillerOrderNumberImagingServiceRequestRetired", 0x00402007,
          "Filler Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const ElementDef kOrderEnteredBy
      //(0040,2008)
      = const ElementDef("OrderEnteredBy", 0x00402008, "Order Entered By", VR.kPN, VM.k1, false);
  static const ElementDef kOrderEntererLocation
      //(0040,2009)
      = const ElementDef(
          "OrderEntererLocation", 0x00402009, "Order Enterer's Location", VR.kSH, VM.k1, false);
  static const ElementDef kOrderCallbackPhoneNumber
      //(0040,2010)
      = const ElementDef("OrderCallbackPhoneNumber", 0x00402010, "Order Callback Phone Number", VR.kSH,
          VM.k1, false);
  static const ElementDef kPlacerOrderNumberImagingServiceRequest
      //(0040,2016)
      = const ElementDef("PlacerOrderNumberImagingServiceRequest", 0x00402016,
          "Placer Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const ElementDef kFillerOrderNumberImagingServiceRequest
      //(0040,2017)
      = const ElementDef("FillerOrderNumberImagingServiceRequest", 0x00402017,
          "Filler Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const ElementDef kImagingServiceRequestComments
      //(0040,2400)
      = const ElementDef("ImagingServiceRequestComments", 0x00402400,
          "Imaging Service Request Comments", VR.kLT, VM.k1, false);
  static const ElementDef kConfidentialityConstraintOnPatientDataDescription
      //(0040,3001)
      = const ElementDef("ConfidentialityConstraintOnPatientDataDescription", 0x00403001,
          "Confidentiality Constraint on Patient Data Description", VR.kLO, VM.k1, false);
  static const ElementDef kGeneralPurposeScheduledProcedureStepStatus
      //(0040,4001)
      = const ElementDef("GeneralPurposeScheduledProcedureStepStatus", 0x00404001,
          "General Purpose Scheduled Procedure Step Status", VR.kCS, VM.k1, true);
  static const ElementDef kGeneralPurposePerformedProcedureStepStatus
      //(0040,4002)
      = const ElementDef("GeneralPurposePerformedProcedureStepStatus", 0x00404002,
          "General Purpose Performed Procedure Step Status", VR.kCS, VM.k1, true);
  static const ElementDef kGeneralPurposeScheduledProcedureStepPriority
      //(0040,4003)
      = const ElementDef("GeneralPurposeScheduledProcedureStepPriority", 0x00404003,
          "General Purpose Scheduled Procedure Step Priority", VR.kCS, VM.k1, true);
  static const ElementDef kScheduledProcessingApplicationsCodeSequence
      //(0040,4004)
      = const ElementDef("ScheduledProcessingApplicationsCodeSequence", 0x00404004,
          "Scheduled Processing Applications Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kScheduledProcedureStepStartDateTime
      //(0040,4005)
      = const ElementDef("ScheduledProcedureStepStartDateTime", 0x00404005,
          "Scheduled Procedure Step Start DateTime", VR.kDT, VM.k1, true);
  static const ElementDef kMultipleCopiesFlag
      //(0040,4006)
      =
      const ElementDef("MultipleCopiesFlag", 0x00404006, "Multiple Copies Flag", VR.kCS, VM.k1, true);
  static const ElementDef kPerformedProcessingApplicationsCodeSequence
      //(0040,4007)
      = const ElementDef("PerformedProcessingApplicationsCodeSequence", 0x00404007,
          "Performed Processing Applications Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHumanPerformerCodeSequence
      //(0040,4009)
      = const ElementDef("HumanPerformerCodeSequence", 0x00404009, "Human Performer Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledProcedureStepModificationDateTime
      //(0040,4010)
      = const ElementDef("ScheduledProcedureStepModificationDateTime", 0x00404010,
          "Scheduled Procedure Step Modification DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kExpectedCompletionDateTime
      //(0040,4011)
      = const ElementDef("ExpectedCompletionDateTime", 0x00404011, "Expected Completion DateTime",
          VR.kDT, VM.k1, false);
  static const ElementDef kResultingGeneralPurposePerformedProcedureStepsSequence
      //(0040,4015)
      = const ElementDef("ResultingGeneralPurposePerformedProcedureStepsSequence", 0x00404015,
          "Resulting General Purpose Performed Procedure Steps Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedGeneralPurposeScheduledProcedureStepSequence
      //(0040,4016)
      = const ElementDef("ReferencedGeneralPurposeScheduledProcedureStepSequence", 0x00404016,
          "Referenced General Purpose Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kScheduledWorkitemCodeSequence
      //(0040,4018)
      = const ElementDef("ScheduledWorkitemCodeSequence", 0x00404018,
          "Scheduled Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedWorkitemCodeSequence
      //(0040,4019)
      = const ElementDef("PerformedWorkitemCodeSequence", 0x00404019,
          "Performed Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kInputAvailabilityFlag
      //(0040,4020)
      = const ElementDef(
          "InputAvailabilityFlag", 0x00404020, "Input Availability Flag", VR.kCS, VM.k1, false);
  static const ElementDef kInputInformationSequence
      //(0040,4021)
      = const ElementDef("InputInformationSequence", 0x00404021, "Input Information Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kRelevantInformationSequence
      //(0040,4022)
      = const ElementDef("RelevantInformationSequence", 0x00404022, "Relevant Information Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedGeneralPurposeScheduledProcedureStepTransactionUID
      //(0040,4023)
      = const ElementDef(
          "ReferencedGeneralPurposeScheduledProcedureStepTransactionUID",
          0x00404023,
          "Referenced General Purpose Scheduled Procedure Step Transaction UID",
          VR.kUI,
          VM.k1,
          true);
  static const ElementDef kScheduledStationNameCodeSequence
      //(0040,4025)
      = const ElementDef("ScheduledStationNameCodeSequence", 0x00404025,
          "Scheduled Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledStationClassCodeSequence
      //(0040,4026)
      = const ElementDef("ScheduledStationClassCodeSequence", 0x00404026,
          "Scheduled Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledStationGeographicLocationCodeSequence
      //(0040,4027)
      = const ElementDef("ScheduledStationGeographicLocationCodeSequence", 0x00404027,
          "Scheduled Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedStationNameCodeSequence
      //(0040,4028)
      = const ElementDef("PerformedStationNameCodeSequence", 0x00404028,
          "Performed Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedStationClassCodeSequence
      //(0040,4029)
      = const ElementDef("PerformedStationClassCodeSequence", 0x00404029,
          "Performed Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedStationGeographicLocationCodeSequence
      //(0040,4030)
      = const ElementDef("PerformedStationGeographicLocationCodeSequence", 0x00404030,
          "Performed Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRequestedSubsequentWorkitemCodeSequence
      //(0040,4031)
      = const ElementDef("RequestedSubsequentWorkitemCodeSequence", 0x00404031,
          "Requested Subsequent Workitem Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kNonDICOMOutputCodeSequence
      //(0040,4032)
      = const ElementDef("NonDICOMOutputCodeSequence", 0x00404032, "Non-DICOM Output Code Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kOutputInformationSequence
      //(0040,4033)
      = const ElementDef("OutputInformationSequence", 0x00404033, "Output Information Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kScheduledHumanPerformersSequence
      //(0040,4034)
      = const ElementDef("ScheduledHumanPerformersSequence", 0x00404034,
          "Scheduled Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kActualHumanPerformersSequence
      //(0040,4035)
      = const ElementDef("ActualHumanPerformersSequence", 0x00404035,
          "Actual Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHumanPerformerOrganization
      //(0040,4036)
      = const ElementDef("HumanPerformerOrganization", 0x00404036, "Human Performer's Organization",
          VR.kLO, VM.k1, false);
  static const ElementDef kHumanPerformerName
      //(0040,4037)
      = const ElementDef(
          "HumanPerformerName", 0x00404037, "Human Performer's Name", VR.kPN, VM.k1, false);
  static const ElementDef kRawDataHandling
      //(0040,4040)
      = const ElementDef("RawDataHandling", 0x00404040, "Raw Data Handling", VR.kCS, VM.k1, false);
  static const ElementDef kInputReadinessState
      //(0040,4041)
      = const ElementDef(
          "InputReadinessState", 0x00404041, "Input Readiness State", VR.kCS, VM.k1, false);
  static const ElementDef kPerformedProcedureStepStartDateTime
      //(0040,4050)
      = const ElementDef("PerformedProcedureStepStartDateTime", 0x00404050,
          "Performed Procedure Step Start DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kPerformedProcedureStepEndDateTime
      //(0040,4051)
      = const ElementDef("PerformedProcedureStepEndDateTime", 0x00404051,
          "Performed Procedure Step End DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kProcedureStepCancellationDateTime
      //(0040,4052)
      = const ElementDef("ProcedureStepCancellationDateTime", 0x00404052,
          "Procedure Step Cancellation DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kEntranceDoseInmGy
      //(0040,8302)
      =
      const ElementDef("EntranceDoseInmGy", 0x00408302, "Entrance Dose in mGy", VR.kDS, VM.k1, false);
  static const ElementDef kReferencedImageRealWorldValueMappingSequence
      //(0040,9094)
      = const ElementDef("ReferencedImageRealWorldValueMappingSequence", 0x00409094,
          "Referenced Image Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRealWorldValueMappingSequence
      //(0040,9096)
      = const ElementDef("RealWorldValueMappingSequence", 0x00409096,
          "Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPixelValueMappingCodeSequence
      //(0040,9098)
      = const ElementDef("PixelValueMappingCodeSequence", 0x00409098,
          "Pixel Value Mapping Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLUTLabel
      //(0040,9210)
      = const ElementDef("LUTLabel", 0x00409210, "LUT Label", VR.kSH, VM.k1, false);
  static const ElementDef kRealWorldValueLastValueMapped
      //(0040,9211)
      = const ElementDef("RealWorldValueLastValueMapped", 0x00409211,
          "Real World Value Last Value Mapped", VR.kUSSS, VM.k1, false);
  static const ElementDef kRealWorldValueLUTData
      //(0040,9212)
      = const ElementDef(
          "RealWorldValueLUTData", 0x00409212, "Real World Value LUT Data", VR.kFD, VM.k1_n, false);
  static const ElementDef kRealWorldValueFirstValueMapped
      //(0040,9216)
      = const ElementDef("RealWorldValueFirstValueMapped", 0x00409216,
          "Real World Value First Value Mapped", VR.kUSSS, VM.k1, false);
  static const ElementDef kRealWorldValueIntercept
      //(0040,9224)
      = const ElementDef("RealWorldValueIntercept", 0x00409224, "Real World Value Intercept", VR.kFD,
          VM.k1, false);
  static const ElementDef kRealWorldValueSlope
      //(0040,9225)
      = const ElementDef(
          "RealWorldValueSlope", 0x00409225, "Real World Value Slope", VR.kFD, VM.k1, false);
  static const ElementDef kFindingsFlagTrial
      //(0040,A007)
      =
      const ElementDef("FindingsFlagTrial", 0x0040A007, "Findings Flag (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kRelationshipType
      //(0040,A010)
      = const ElementDef("RelationshipType", 0x0040A010, "Relationship Type", VR.kCS, VM.k1, false);
  static const ElementDef kFindingsSequenceTrial
      //(0040,A020)
      = const ElementDef(
          "FindingsSequenceTrial", 0x0040A020, "Findings Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kFindingsGroupUIDTrial
      //(0040,A021)
      = const ElementDef(
          "FindingsGroupUIDTrial", 0x0040A021, "Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const ElementDef kReferencedFindingsGroupUIDTrial
      //(0040,A022)
      = const ElementDef("ReferencedFindingsGroupUIDTrial", 0x0040A022,
          "Referenced Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const ElementDef kFindingsGroupRecordingDateTrial
      //(0040,A023)
      = const ElementDef("FindingsGroupRecordingDateTrial", 0x0040A023,
          "Findings Group Recording Date (Trial)", VR.kDA, VM.k1, true);
  static const ElementDef kFindingsGroupRecordingTimeTrial
      //(0040,A024)
      = const ElementDef("FindingsGroupRecordingTimeTrial", 0x0040A024,
          "Findings Group Recording Time (Trial)", VR.kTM, VM.k1, true);
  static const ElementDef kFindingsSourceCategoryCodeSequenceTrial
      //(0040,A026)
      = const ElementDef("FindingsSourceCategoryCodeSequenceTrial", 0x0040A026,
          "Findings Source Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kVerifyingOrganization
      //(0040,A027)
      = const ElementDef(
          "VerifyingOrganization", 0x0040A027, "Verifying Organization", VR.kLO, VM.k1, false);
  static const ElementDef kDocumentingOrganizationIdentifierCodeSequenceTrial
      //(0040,A028)
      = const ElementDef("DocumentingOrganizationIdentifierCodeSequenceTrial", 0x0040A028,
          "Documenting Organization Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kVerificationDateTime
      //(0040,A030)
      = const ElementDef(
          "VerificationDateTime", 0x0040A030, "Verification DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kObservationDateTime
      //(0040,A032)
      = const ElementDef(
          "ObservationDateTime", 0x0040A032, "Observation DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kValueType
      //(0040,A040)
      = const ElementDef("ValueType", 0x0040A040, "Value Type", VR.kCS, VM.k1, false);
  static const ElementDef kConceptNameCodeSequence
      //(0040,A043)
      = const ElementDef("ConceptNameCodeSequence", 0x0040A043, "Concept Name Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kMeasurementPrecisionDescriptionTrial
      //(0040,A047)
      = const ElementDef("MeasurementPrecisionDescriptionTrial", 0x0040A047,
          "Measurement Precision Description (Trial)", VR.kLO, VM.k1, true);
  static const ElementDef kContinuityOfContent
      //(0040,A050)
      = const ElementDef(
          "ContinuityOfContent", 0x0040A050, "Continuity Of Content", VR.kCS, VM.k1, false);
  static const ElementDef kUrgencyOrPriorityAlertsTrial
      //(0040,A057)
      = const ElementDef("UrgencyOrPriorityAlertsTrial", 0x0040A057,
          "Urgency or Priority Alerts (Trial)", VR.kCS, VM.k1_n, true);
  static const ElementDef kSequencingIndicatorTrial
      //(0040,A060)
      = const ElementDef("SequencingIndicatorTrial", 0x0040A060, "Sequencing Indicator (Trial)",
          VR.kLO, VM.k1, true);
  static const ElementDef kDocumentIdentifierCodeSequenceTrial
      //(0040,A066)
      = const ElementDef("DocumentIdentifierCodeSequenceTrial", 0x0040A066,
          "Document Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kDocumentAuthorTrial
      //(0040,A067)
      = const ElementDef(
          "DocumentAuthorTrial", 0x0040A067, "Document Author (Trial)", VR.kPN, VM.k1, true);
  static const ElementDef kDocumentAuthorIdentifierCodeSequenceTrial
      //(0040,A068)
      = const ElementDef("DocumentAuthorIdentifierCodeSequenceTrial", 0x0040A068,
          "Document Author Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kIdentifierCodeSequenceTrial
      //(0040,A070)
      = const ElementDef("IdentifierCodeSequenceTrial", 0x0040A070, "Identifier Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const ElementDef kVerifyingObserverSequence
      //(0040,A073)
      = const ElementDef("VerifyingObserverSequence", 0x0040A073, "Verifying Observer Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kObjectBinaryIdentifierTrial
      //(0040,A074)
      = const ElementDef("ObjectBinaryIdentifierTrial", 0x0040A074, "Object Binary Identifier (Trial)",
          VR.kOB, VM.k1, true);
  static const ElementDef kVerifyingObserverName
      //(0040,A075)
      = const ElementDef(
          "VerifyingObserverName", 0x0040A075, "Verifying Observer Name", VR.kPN, VM.k1, false);
  static const ElementDef kDocumentingObserverIdentifierCodeSequenceTrial
      //(0040,A076)
      = const ElementDef("DocumentingObserverIdentifierCodeSequenceTrial", 0x0040A076,
          "Documenting Observer Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kAuthorObserverSequence
      //(0040,A078)
      = const ElementDef(
          "AuthorObserverSequence", 0x0040A078, "Author Observer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kParticipantSequence
      //(0040,A07A)
      = const ElementDef(
          "ParticipantSequence", 0x0040A07A, "Participant Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCustodialOrganizationSequence
      //(0040,A07C)
      = const ElementDef("CustodialOrganizationSequence", 0x0040A07C,
          "Custodial Organization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kParticipationType
      //(0040,A080)
      = const ElementDef("ParticipationType", 0x0040A080, "Participation Type", VR.kCS, VM.k1, false);
  static const ElementDef kParticipationDateTime
      //(0040,A082)
      = const ElementDef(
          "ParticipationDateTime", 0x0040A082, "Participation DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kObserverType
      //(0040,A084)
      = const ElementDef("ObserverType", 0x0040A084, "Observer Type", VR.kCS, VM.k1, false);
  static const ElementDef kProcedureIdentifierCodeSequenceTrial
      //(0040,A085)
      = const ElementDef("ProcedureIdentifierCodeSequenceTrial", 0x0040A085,
          "Procedure Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kVerifyingObserverIdentificationCodeSequence
      //(0040,A088)
      = const ElementDef("VerifyingObserverIdentificationCodeSequence", 0x0040A088,
          "Verifying Observer Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kObjectDirectoryBinaryIdentifierTrial
      //(0040,A089)
      = const ElementDef("ObjectDirectoryBinaryIdentifierTrial", 0x0040A089,
          "Object Directory Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const ElementDef kEquivalentCDADocumentSequence
      //(0040,A090)
      = const ElementDef("EquivalentCDADocumentSequence", 0x0040A090,
          "Equivalent CDA Document Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedWaveformChannels
      //(0040,A0B0)
      = const ElementDef("ReferencedWaveformChannels", 0x0040A0B0, "Referenced Waveform Channels",
          VR.kUS, VM.k2_2n, false);
  static const ElementDef kDateOfDocumentOrVerbalTransactionTrial
      //(0040,A110)
      = const ElementDef("DateOfDocumentOrVerbalTransactionTrial", 0x0040A110,
          "Date of Document or Verbal Transaction (Trial)", VR.kDA, VM.k1, true);
  static const ElementDef kTimeOfDocumentCreationOrVerbalTransactionTrial
      //(0040,A112)
      = const ElementDef("TimeOfDocumentCreationOrVerbalTransactionTrial", 0x0040A112,
          "Time of Document Creation or Verbal Transaction (Trial)", VR.kTM, VM.k1, true);
  static const ElementDef kDateTime
      //(0040,A120)
      = const ElementDef("DateTime", 0x0040A120, "DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kDate
      //(0040,A121)
      = const ElementDef("Date", 0x0040A121, "Date", VR.kDA, VM.k1, false);
  static const ElementDef kTime
      //(0040,A122)
      = const ElementDef("Time", 0x0040A122, "Time", VR.kTM, VM.k1, false);
  static const ElementDef kPersonName
      //(0040,A123)
      = const ElementDef("PersonName", 0x0040A123, "Person Name", VR.kPN, VM.k1, false);
  static const ElementDef kUID
      //(0040,A124)
      = const ElementDef("UID", 0x0040A124, "UID", VR.kUI, VM.k1, false);
  static const ElementDef kReportStatusIDTrial
      //(0040,A125)
      = const ElementDef(
          "ReportStatusIDTrial", 0x0040A125, "Report Status ID (Trial)", VR.kCS, VM.k2, true);
  static const ElementDef kTemporalRangeType
      //(0040,A130)
      = const ElementDef("TemporalRangeType", 0x0040A130, "Temporal Range Type", VR.kCS, VM.k1, false);
  static const ElementDef kReferencedSamplePositions
      //(0040,A132)
      = const ElementDef("ReferencedSamplePositions", 0x0040A132, "Referenced Sample Positions",
          VR.kUL, VM.k1_n, false);
  static const ElementDef kReferencedFrameNumbers
      //(0040,A136)
      = const ElementDef(
          "ReferencedFrameNumbers", 0x0040A136, "Referenced Frame Numbers", VR.kUS, VM.k1_n, false);
  static const ElementDef kReferencedTimeOffsets
      //(0040,A138)
      = const ElementDef(
          "ReferencedTimeOffsets", 0x0040A138, "Referenced Time Offsets", VR.kDS, VM.k1_n, false);
  static const ElementDef kReferencedDateTime
      //(0040,A13A)
      = const ElementDef(
          "ReferencedDateTime", 0x0040A13A, "Referenced DateTime", VR.kDT, VM.k1_n, false);
  static const ElementDef kTextValue
      //(0040,A160)
      = const ElementDef("TextValue", 0x0040A160, "Text Value", VR.kUT, VM.k1, false);
  static const ElementDef kFloatingPointValue
      //(0040,A161)
      = const ElementDef(
          "FloatingPointValue", 0x0040A161, "Floating Point Value", VR.kFD, VM.k1_n, false);
  static const ElementDef kRationalNumeratorValue
      //(0040,A162)
      = const ElementDef(
          "RationalNumeratorValue", 0x0040A162, "Rational Numerator Value", VR.kSL, VM.k1_n, false);
  static const ElementDef kRationalDenominatorValue
      //(0040,A163)
      = const ElementDef("RationalDenominatorValue", 0x0040A163, "Rational Denominator Value", VR.kUL,
          VM.k1_n, false);
  static const ElementDef kObservationCategoryCodeSequenceTrial
      //(0040,A167)
      = const ElementDef("ObservationCategoryCodeSequenceTrial", 0x0040A167,
          "Observation Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kConceptCodeSequence
      //(0040,A168)
      = const ElementDef(
          "ConceptCodeSequence", 0x0040A168, "Concept Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBibliographicCitationTrial
      //(0040,A16A)
      = const ElementDef("BibliographicCitationTrial", 0x0040A16A, "Bibliographic Citation (Trial)",
          VR.kST, VM.k1, true);
  static const ElementDef kPurposeOfReferenceCodeSequence
      //(0040,A170)
      = const ElementDef("PurposeOfReferenceCodeSequence", 0x0040A170,
          "Purpose of Reference Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kObservationUID
      //(0040,A171)
      = const ElementDef("ObservationUID", 0x0040A171, "Observation UID", VR.kUI, VM.k1, false);
  static const ElementDef kReferencedObservationUIDTrial
      //(0040,A172)
      = const ElementDef("ReferencedObservationUIDTrial", 0x0040A172,
          "Referenced Observation UID (Trial)", VR.kUI, VM.k1, true);
  static const ElementDef kReferencedObservationClassTrial
      //(0040,A173)
      = const ElementDef("ReferencedObservationClassTrial", 0x0040A173,
          "Referenced Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kReferencedObjectObservationClassTrial
      //(0040,A174)
      = const ElementDef("ReferencedObjectObservationClassTrial", 0x0040A174,
          "Referenced Object Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kAnnotationGroupNumber
      //(0040,A180)
      = const ElementDef(
          "AnnotationGroupNumber", 0x0040A180, "Annotation Group Number", VR.kUS, VM.k1, false);
  static const ElementDef kObservationDateTrial
      //(0040,A192)
      = const ElementDef(
          "ObservationDateTrial", 0x0040A192, "Observation Date (Trial)", VR.kDA, VM.k1, true);
  static const ElementDef kObservationTimeTrial
      //(0040,A193)
      = const ElementDef(
          "ObservationTimeTrial", 0x0040A193, "Observation Time (Trial)", VR.kTM, VM.k1, true);
  static const ElementDef kMeasurementAutomationTrial
      //(0040,A194)
      = const ElementDef("MeasurementAutomationTrial", 0x0040A194, "Measurement Automation (Trial)",
          VR.kCS, VM.k1, true);
  static const ElementDef kModifierCodeSequence
      //(0040,A195)
      = const ElementDef(
          "ModifierCodeSequence", 0x0040A195, "Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIdentificationDescriptionTrial
      //(0040,A224)
      = const ElementDef("IdentificationDescriptionTrial", 0x0040A224,
          "Identification Description (Trial)", VR.kST, VM.k1, true);
  static const ElementDef kCoordinatesSetGeometricTypeTrial
      //(0040,A290)
      = const ElementDef("CoordinatesSetGeometricTypeTrial", 0x0040A290,
          "Coordinates Set Geometric Type (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kAlgorithmCodeSequenceTrial
      //(0040,A296)
      = const ElementDef("AlgorithmCodeSequenceTrial", 0x0040A296, "Algorithm Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const ElementDef kAlgorithmDescriptionTrial
      //(0040,A297)
      = const ElementDef("AlgorithmDescriptionTrial", 0x0040A297, "Algorithm Description (Trial)",
          VR.kST, VM.k1, true);
  static const ElementDef kPixelCoordinatesSetTrial
      //(0040,A29A)
      = const ElementDef("PixelCoordinatesSetTrial", 0x0040A29A, "Pixel Coordinates Set (Trial)",
          VR.kSL, VM.k2_2n, true);
  static const ElementDef kMeasuredValueSequence
      //(0040,A300)
      = const ElementDef(
          "MeasuredValueSequence", 0x0040A300, "Measured Value Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumericValueQualifierCodeSequence
      //(0040,A301)
      = const ElementDef("NumericValueQualifierCodeSequence", 0x0040A301,
          "Numeric Value Qualifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCurrentObserverTrial
      //(0040,A307)
      = const ElementDef(
          "CurrentObserverTrial", 0x0040A307, "Current Observer (Trial)", VR.kPN, VM.k1, true);
  static const ElementDef kNumericValue
      //(0040,A30A)
      = const ElementDef("NumericValue", 0x0040A30A, "Numeric Value", VR.kDS, VM.k1_n, false);
  static const ElementDef kReferencedAccessionSequenceTrial
      //(0040,A313)
      = const ElementDef("ReferencedAccessionSequenceTrial", 0x0040A313,
          "Referenced Accession Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kReportStatusCommentTrial
      //(0040,A33A)
      = const ElementDef("ReportStatusCommentTrial", 0x0040A33A, "Report Status Comment (Trial)",
          VR.kST, VM.k1, true);
  static const ElementDef kProcedureContextSequenceTrial
      //(0040,A340)
      = const ElementDef("ProcedureContextSequenceTrial", 0x0040A340,
          "Procedure Context Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kVerbalSourceTrial
      //(0040,A352)
      =
      const ElementDef("VerbalSourceTrial", 0x0040A352, "Verbal Source (Trial)", VR.kPN, VM.k1, true);
  static const ElementDef kAddressTrial
      //(0040,A353)
      = const ElementDef("AddressTrial", 0x0040A353, "Address (Trial)", VR.kST, VM.k1, true);
  static const ElementDef kTelephoneNumberTrial
      //(0040,A354)
      = const ElementDef(
          "TelephoneNumberTrial", 0x0040A354, "Telephone Number (Trial)", VR.kLO, VM.k1, true);
  static const ElementDef kVerbalSourceIdentifierCodeSequenceTrial
      //(0040,A358)
      = const ElementDef("VerbalSourceIdentifierCodeSequenceTrial", 0x0040A358,
          "Verbal Source Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kPredecessorDocumentsSequence
      //(0040,A360)
      = const ElementDef("PredecessorDocumentsSequence", 0x0040A360, "Predecessor Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedRequestSequence
      //(0040,A370)
      = const ElementDef("ReferencedRequestSequence", 0x0040A370, "Referenced Request Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedProcedureCodeSequence
      //(0040,A372)
      = const ElementDef("PerformedProcedureCodeSequence", 0x0040A372,
          "Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCurrentRequestedProcedureEvidenceSequence
      //(0040,A375)
      = const ElementDef("CurrentRequestedProcedureEvidenceSequence", 0x0040A375,
          "Current Requested Procedure Evidence Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReportDetailSequenceTrial
      //(0040,A380)
      = const ElementDef("ReportDetailSequenceTrial", 0x0040A380, "Report Detail Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const ElementDef kPertinentOtherEvidenceSequence
      //(0040,A385)
      = const ElementDef("PertinentOtherEvidenceSequence", 0x0040A385,
          "Pertinent Other Evidence Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHL7StructuredDocumentReferenceSequence
      //(0040,A390)
      = const ElementDef("HL7StructuredDocumentReferenceSequence", 0x0040A390,
          "HL7 Structured Document Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kObservationSubjectUIDTrial
      //(0040,A402)
      = const ElementDef("ObservationSubjectUIDTrial", 0x0040A402, "Observation Subject UID (Trial)",
          VR.kUI, VM.k1, true);
  static const ElementDef kObservationSubjectClassTrial
      //(0040,A403)
      = const ElementDef("ObservationSubjectClassTrial", 0x0040A403,
          "Observation Subject Class (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kObservationSubjectTypeCodeSequenceTrial
      //(0040,A404)
      = const ElementDef("ObservationSubjectTypeCodeSequenceTrial", 0x0040A404,
          "Observation Subject Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kCompletionFlag
      //(0040,A491)
      = const ElementDef("CompletionFlag", 0x0040A491, "Completion Flag", VR.kCS, VM.k1, false);
  static const ElementDef kCompletionFlagDescription
      //(0040,A492)
      = const ElementDef("CompletionFlagDescription", 0x0040A492, "Completion Flag Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kVerificationFlag
      //(0040,A493)
      = const ElementDef("VerificationFlag", 0x0040A493, "Verification Flag", VR.kCS, VM.k1, false);
  static const ElementDef kArchiveRequested
      //(0040,A494)
      = const ElementDef("ArchiveRequested", 0x0040A494, "Archive Requested", VR.kCS, VM.k1, false);
  static const ElementDef kPreliminaryFlag
      //(0040,A496)
      = const ElementDef("PreliminaryFlag", 0x0040A496, "Preliminary Flag", VR.kCS, VM.k1, false);
  static const ElementDef kContentTemplateSequence
      //(0040,A504)
      = const ElementDef(
          "ContentTemplateSequence", 0x0040A504, "Content Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIdenticalDocumentsSequence
      //(0040,A525)
      = const ElementDef("IdenticalDocumentsSequence", 0x0040A525, "Identical Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kObservationSubjectContextFlagTrial
      //(0040,A600)
      = const ElementDef("ObservationSubjectContextFlagTrial", 0x0040A600,
          "Observation Subject Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const ElementDef kObserverContextFlagTrial
      //(0040,A601)
      = const ElementDef("ObserverContextFlagTrial", 0x0040A601, "Observer Context Flag (Trial)",
          VR.kCS, VM.k1, true);
  static const ElementDef kProcedureContextFlagTrial
      //(0040,A603)
      = const ElementDef("ProcedureContextFlagTrial", 0x0040A603, "Procedure Context Flag (Trial)",
          VR.kCS, VM.k1, true);
  static const ElementDef kContentSequence
      //(0040,A730)
      = const ElementDef("ContentSequence", 0x0040A730, "Content Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRelationshipSequenceTrial
      //(0040,A731)
      = const ElementDef("RelationshipSequenceTrial", 0x0040A731, "Relationship Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const ElementDef kRelationshipTypeCodeSequenceTrial
      //(0040,A732)
      = const ElementDef("RelationshipTypeCodeSequenceTrial", 0x0040A732,
          "Relationship Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const ElementDef kLanguageCodeSequenceTrial
      //(0040,A744)
      = const ElementDef("LanguageCodeSequenceTrial", 0x0040A744, "Language Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const ElementDef kUniformResourceLocatorTrial
      //(0040,A992)
      = const ElementDef("UniformResourceLocatorTrial", 0x0040A992, "Uniform Resource Locator (Trial)",
          VR.kST, VM.k1, true);
  static const ElementDef kWaveformAnnotationSequence
      //(0040,B020)
      = const ElementDef("WaveformAnnotationSequence", 0x0040B020, "Waveform Annotation Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTemplateIdentifier
      //(0040,DB00)
      =
      const ElementDef("TemplateIdentifier", 0x0040DB00, "Template Identifier", VR.kCS, VM.k1, false);
  static const ElementDef kTemplateVersion
      //(0040,DB06)
      = const ElementDef("TemplateVersion", 0x0040DB06, "Template Version", VR.kDT, VM.k1, true);
  static const ElementDef kTemplateLocalVersion
      //(0040,DB07)
      = const ElementDef(
          "TemplateLocalVersion", 0x0040DB07, "Template Local Version", VR.kDT, VM.k1, true);
  static const ElementDef kTemplateExtensionFlag
      //(0040,DB0B)
      = const ElementDef(
          "TemplateExtensionFlag", 0x0040DB0B, "Template Extension Flag", VR.kCS, VM.k1, true);
  static const ElementDef kTemplateExtensionOrganizationUID
      //(0040,DB0C)
      = const ElementDef("TemplateExtensionOrganizationUID", 0x0040DB0C,
          "Template Extension Organization UID", VR.kUI, VM.k1, true);
  static const ElementDef kTemplateExtensionCreatorUID
      //(0040,DB0D)
      = const ElementDef("TemplateExtensionCreatorUID", 0x0040DB0D, "Template Extension Creator UID",
          VR.kUI, VM.k1, true);
  static const ElementDef kReferencedContentItemIdentifier
      //(0040,DB73)
      = const ElementDef("ReferencedContentItemIdentifier", 0x0040DB73,
          "Referenced Content Item Identifier", VR.kUL, VM.k1_n, false);
  static const ElementDef kHL7InstanceIdentifier
      //(0040,E001)
      = const ElementDef(
          "HL7InstanceIdentifier", 0x0040E001, "HL7 Instance Identifier", VR.kST, VM.k1, false);
  static const ElementDef kHL7DocumentEffectiveTime
      //(0040,E004)
      = const ElementDef("HL7DocumentEffectiveTime", 0x0040E004, "HL7 Document Effective Time", VR.kDT,
          VM.k1, false);
  static const ElementDef kHL7DocumentTypeCodeSequence
      //(0040,E006)
      = const ElementDef("HL7DocumentTypeCodeSequence", 0x0040E006, "HL7 Document Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kDocumentClassCodeSequence
      //(0040,E008)
      = const ElementDef("DocumentClassCodeSequence", 0x0040E008, "Document Class Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRetrieveURI
      //(0040,E010)
      = const ElementDef("RetrieveURI", 0x0040E010, "Retrieve URI", VR.kUT, VM.k1, false);
  static const ElementDef kRetrieveLocationUID
      //(0040,E011)
      = const ElementDef(
          "RetrieveLocationUID", 0x0040E011, "Retrieve Location UID", VR.kUI, VM.k1, false);
  static const ElementDef kTypeOfInstances
      //(0040,E020)
      = const ElementDef("TypeOfInstances", 0x0040E020, "Type of Instances", VR.kCS, VM.k1, false);
  static const ElementDef kDICOMRetrievalSequence
      //(0040,E021)
      = const ElementDef(
          "DICOMRetrievalSequence", 0x0040E021, "DICOM Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDICOMMediaRetrievalSequence
      //(0040,E022)
      = const ElementDef("DICOMMediaRetrievalSequence", 0x0040E022, "DICOM Media Retrieval Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kWADORetrievalSequence
      //(0040,E023)
      = const ElementDef(
          "WADORetrievalSequence", 0x0040E023, "WADO Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kXDSRetrievalSequence
      //(0040,E024)
      = const ElementDef(
          "XDSRetrievalSequence", 0x0040E024, "XDS Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRepositoryUniqueID
      //(0040,E030)
      =
      const ElementDef("RepositoryUniqueID", 0x0040E030, "Repository Unique ID", VR.kUI, VM.k1, false);
  static const ElementDef kHomeCommunityID
      //(0040,E031)
      = const ElementDef("HomeCommunityID", 0x0040E031, "Home Community ID", VR.kUI, VM.k1, false);
  static const ElementDef kDocumentTitle
      //(0042,0010)
      = const ElementDef("DocumentTitle", 0x00420010, "Document Title", VR.kST, VM.k1, false);
  static const ElementDef kEncapsulatedDocument
      //(0042,0011)
      = const ElementDef(
          "EncapsulatedDocument", 0x00420011, "Encapsulated Document", VR.kOB, VM.k1, false);
  static const ElementDef kMIMETypeOfEncapsulatedDocument
      //(0042,0012)
      = const ElementDef("MIMETypeOfEncapsulatedDocument", 0x00420012,
          "MIME Type of Encapsulated Document", VR.kLO, VM.k1, false);
  static const ElementDef kSourceInstanceSequence
      //(0042,0013)
      = const ElementDef(
          "SourceInstanceSequence", 0x00420013, "Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kListOfMIMETypes
      //(0042,0014)
      = const ElementDef("ListOfMIMETypes", 0x00420014, "List of MIME Types", VR.kLO, VM.k1_n, false);
  static const ElementDef kProductPackageIdentifier
      //(0044,0001)
      = const ElementDef("ProductPackageIdentifier", 0x00440001, "Product Package Identifier", VR.kST,
          VM.k1, false);
  static const ElementDef kSubstanceAdministrationApproval
      //(0044,0002)
      = const ElementDef("SubstanceAdministrationApproval", 0x00440002,
          "Substance Administration Approval", VR.kCS, VM.k1, false);
  static const ElementDef kApprovalStatusFurtherDescription
      //(0044,0003)
      = const ElementDef("ApprovalStatusFurtherDescription", 0x00440003,
          "Approval Status Further Description", VR.kLT, VM.k1, false);
  static const ElementDef kApprovalStatusDateTime
      //(0044,0004)
      = const ElementDef(
          "ApprovalStatusDateTime", 0x00440004, "Approval Status DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kProductTypeCodeSequence
      //(0044,0007)
      = const ElementDef("ProductTypeCodeSequence", 0x00440007, "Product Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kProductName
      //(0044,0008)
      = const ElementDef("ProductName", 0x00440008, "Product Name", VR.kLO, VM.k1_n, false);
  static const ElementDef kProductDescription
      //(0044,0009)
      =
      const ElementDef("ProductDescription", 0x00440009, "Product Description", VR.kLT, VM.k1, false);
  static const ElementDef kProductLotIdentifier
      //(0044,000A)
      = const ElementDef(
          "ProductLotIdentifier", 0x0044000A, "Product Lot Identifier", VR.kLO, VM.k1, false);
  static const ElementDef kProductExpirationDateTime
      //(0044,000B)
      = const ElementDef("ProductExpirationDateTime", 0x0044000B, "Product Expiration DateTime",
          VR.kDT, VM.k1, false);
  static const ElementDef kSubstanceAdministrationDateTime
      //(0044,0010)
      = const ElementDef("SubstanceAdministrationDateTime", 0x00440010,
          "Substance Administration DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kSubstanceAdministrationNotes
      //(0044,0011)
      = const ElementDef("SubstanceAdministrationNotes", 0x00440011, "Substance Administration Notes",
          VR.kLO, VM.k1, false);
  static const ElementDef kSubstanceAdministrationDeviceID
      //(0044,0012)
      = const ElementDef("SubstanceAdministrationDeviceID", 0x00440012,
          "Substance Administration Device ID", VR.kLO, VM.k1, false);
  static const ElementDef kProductParameterSequence
      //(0044,0013)
      = const ElementDef("ProductParameterSequence", 0x00440013, "Product Parameter Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSubstanceAdministrationParameterSequence
      //(0044,0019)
      = const ElementDef("SubstanceAdministrationParameterSequence", 0x00440019,
          "Substance Administration Parameter Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLensDescription
      //(0046,0012)
      = const ElementDef("LensDescription", 0x00460012, "Lens Description", VR.kLO, VM.k1, false);
  static const ElementDef kRightLensSequence
      //(0046,0014)
      = const ElementDef("RightLensSequence", 0x00460014, "Right Lens Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLeftLensSequence
      //(0046,0015)
      = const ElementDef("LeftLensSequence", 0x00460015, "Left Lens Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUnspecifiedLateralityLensSequence
      //(0046,0016)
      = const ElementDef("UnspecifiedLateralityLensSequence", 0x00460016,
          "Unspecified Laterality Lens Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCylinderSequence
      //(0046,0018)
      = const ElementDef("CylinderSequence", 0x00460018, "Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPrismSequence
      //(0046,0028)
      = const ElementDef("PrismSequence", 0x00460028, "Prism Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHorizontalPrismPower
      //(0046,0030)
      = const ElementDef(
          "HorizontalPrismPower", 0x00460030, "Horizontal Prism Power", VR.kFD, VM.k1, false);
  static const ElementDef kHorizontalPrismBase
      //(0046,0032)
      = const ElementDef(
          "HorizontalPrismBase", 0x00460032, "Horizontal Prism Base", VR.kCS, VM.k1, false);
  static const ElementDef kVerticalPrismPower
      //(0046,0034)
      =
      const ElementDef("VerticalPrismPower", 0x00460034, "Vertical Prism Power", VR.kFD, VM.k1, false);
  static const ElementDef kVerticalPrismBase
      //(0046,0036)
      = const ElementDef("VerticalPrismBase", 0x00460036, "Vertical Prism Base", VR.kCS, VM.k1, false);
  static const ElementDef kLensSegmentType
      //(0046,0038)
      = const ElementDef("LensSegmentType", 0x00460038, "Lens Segment Type", VR.kCS, VM.k1, false);
  static const ElementDef kOpticalTransmittance
      //(0046,0040)
      = const ElementDef(
          "OpticalTransmittance", 0x00460040, "Optical Transmittance", VR.kFD, VM.k1, false);
  static const ElementDef kChannelWidth
      //(0046,0042)
      = const ElementDef("ChannelWidth", 0x00460042, "Channel Width", VR.kFD, VM.k1, false);
  static const ElementDef kPupilSize
      //(0046,0044)
      = const ElementDef("PupilSize", 0x00460044, "Pupil Size", VR.kFD, VM.k1, false);
  static const ElementDef kCornealSize
      //(0046,0046)
      = const ElementDef("CornealSize", 0x00460046, "Corneal Size", VR.kFD, VM.k1, false);
  static const ElementDef kAutorefractionRightEyeSequence
      //(0046,0050)
      = const ElementDef("AutorefractionRightEyeSequence", 0x00460050,
          "Autorefraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAutorefractionLeftEyeSequence
      //(0046,0052)
      = const ElementDef("AutorefractionLeftEyeSequence", 0x00460052,
          "Autorefraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDistancePupillaryDistance
      //(0046,0060)
      = const ElementDef("DistancePupillaryDistance", 0x00460060, "Distance Pupillary Distance",
          VR.kFD, VM.k1, false);
  static const ElementDef kNearPupillaryDistance
      //(0046,0062)
      = const ElementDef(
          "NearPupillaryDistance", 0x00460062, "Near Pupillary Distance", VR.kFD, VM.k1, false);
  static const ElementDef kIntermediatePupillaryDistance
      //(0046,0063)
      = const ElementDef("IntermediatePupillaryDistance", 0x00460063,
          "Intermediate Pupillary Distance", VR.kFD, VM.k1, false);
  static const ElementDef kOtherPupillaryDistance
      //(0046,0064)
      = const ElementDef(
          "OtherPupillaryDistance", 0x00460064, "Other Pupillary Distance", VR.kFD, VM.k1, false);
  static const ElementDef kKeratometryRightEyeSequence
      //(0046,0070)
      = const ElementDef("KeratometryRightEyeSequence", 0x00460070, "Keratometry Right Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kKeratometryLeftEyeSequence
      //(0046,0071)
      = const ElementDef("KeratometryLeftEyeSequence", 0x00460071, "Keratometry Left Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSteepKeratometricAxisSequence
      //(0046,0074)
      = const ElementDef("SteepKeratometricAxisSequence", 0x00460074,
          "Steep Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRadiusOfCurvature
      //(0046,0075)
      = const ElementDef("RadiusOfCurvature", 0x00460075, "Radius of Curvature", VR.kFD, VM.k1, false);
  static const ElementDef kKeratometricPower
      //(0046,0076)
      = const ElementDef("KeratometricPower", 0x00460076, "Keratometric Power", VR.kFD, VM.k1, false);
  static const ElementDef kKeratometricAxis
      //(0046,0077)
      = const ElementDef("KeratometricAxis", 0x00460077, "Keratometric Axis", VR.kFD, VM.k1, false);
  static const ElementDef kFlatKeratometricAxisSequence
      //(0046,0080)
      = const ElementDef("FlatKeratometricAxisSequence", 0x00460080, "Flat Keratometric Axis Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kBackgroundColor
      //(0046,0092)
      = const ElementDef("BackgroundColor", 0x00460092, "Background Color", VR.kCS, VM.k1, false);
  static const ElementDef kOptotype
      //(0046,0094)
      = const ElementDef("Optotype", 0x00460094, "Optotype", VR.kCS, VM.k1, false);
  static const ElementDef kOptotypePresentation
      //(0046,0095)
      = const ElementDef(
          "OptotypePresentation", 0x00460095, "Optotype Presentation", VR.kCS, VM.k1, false);
  static const ElementDef kSubjectiveRefractionRightEyeSequence
      //(0046,0097)
      = const ElementDef("SubjectiveRefractionRightEyeSequence", 0x00460097,
          "Subjective Refraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSubjectiveRefractionLeftEyeSequence
      //(0046,0098)
      = const ElementDef("SubjectiveRefractionLeftEyeSequence", 0x00460098,
          "Subjective Refraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAddNearSequence
      //(0046,0100)
      = const ElementDef("AddNearSequence", 0x00460100, "Add Near Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAddIntermediateSequence
      //(0046,0101)
      = const ElementDef(
          "AddIntermediateSequence", 0x00460101, "Add Intermediate Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAddOtherSequence
      //(0046,0102)
      = const ElementDef("AddOtherSequence", 0x00460102, "Add Other Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAddPower
      //(0046,0104)
      = const ElementDef("AddPower", 0x00460104, "Add Power", VR.kFD, VM.k1, false);
  static const ElementDef kViewingDistance
      //(0046,0106)
      = const ElementDef("ViewingDistance", 0x00460106, "Viewing Distance", VR.kFD, VM.k1, false);
  static const ElementDef kVisualAcuityTypeCodeSequence
      //(0046,0121)
      = const ElementDef("VisualAcuityTypeCodeSequence", 0x00460121,
          "Visual Acuity Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualAcuityRightEyeSequence
      //(0046,0122)
      = const ElementDef("VisualAcuityRightEyeSequence", 0x00460122,
          "Visual Acuity Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVisualAcuityLeftEyeSequence
      //(0046,0123)
      = const ElementDef("VisualAcuityLeftEyeSequence", 0x00460123, "Visual Acuity Left Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kVisualAcuityBothEyesOpenSequence
      //(0046,0124)
      = const ElementDef("VisualAcuityBothEyesOpenSequence", 0x00460124,
          "Visual Acuity Both Eyes Open Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kViewingDistanceType
      //(0046,0125)
      = const ElementDef(
          "ViewingDistanceType", 0x00460125, "Viewing Distance Type", VR.kCS, VM.k1, false);
  static const ElementDef kVisualAcuityModifiers
      //(0046,0135)
      = const ElementDef(
          "VisualAcuityModifiers", 0x00460135, "Visual Acuity Modifiers", VR.kSS, VM.k2, false);
  static const ElementDef kDecimalVisualAcuity
      //(0046,0137)
      = const ElementDef(
          "DecimalVisualAcuity", 0x00460137, "Decimal Visual Acuity", VR.kFD, VM.k1, false);
  static const ElementDef kOptotypeDetailedDefinition
      //(0046,0139)
      = const ElementDef("OptotypeDetailedDefinition", 0x00460139, "Optotype Detailed Definition",
          VR.kLO, VM.k1, false);
  static const ElementDef kReferencedRefractiveMeasurementsSequence
      //(0046,0145)
      = const ElementDef("ReferencedRefractiveMeasurementsSequence", 0x00460145,
          "Referenced Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpherePower
      //(0046,0146)
      = const ElementDef("SpherePower", 0x00460146, "Sphere Power", VR.kFD, VM.k1, false);
  static const ElementDef kCylinderPower
      //(0046,0147)
      = const ElementDef("CylinderPower", 0x00460147, "Cylinder Power", VR.kFD, VM.k1, false);
  static const ElementDef kCornealTopographySurface
      //(0046,0201)
      = const ElementDef("CornealTopographySurface", 0x00460201, "Corneal Topography Surface", VR.kCS,
          VM.k1, false);
  static const ElementDef kCornealVertexLocation
      //(0046,0202)
      = const ElementDef(
          "CornealVertexLocation", 0x00460202, "Corneal Vertex Location", VR.kFL, VM.k2, false);
  static const ElementDef kPupilCentroidXCoordinate
      //(0046,0203)
      = const ElementDef("PupilCentroidXCoordinate", 0x00460203, "Pupil Centroid X-Coordinate", VR.kFL,
          VM.k1, false);
  static const ElementDef kPupilCentroidYCoordinate
      //(0046,0204)
      = const ElementDef("PupilCentroidYCoordinate", 0x00460204, "Pupil Centroid Y-Coordinate", VR.kFL,
          VM.k1, false);
  static const ElementDef kEquivalentPupilRadius
      //(0046,0205)
      = const ElementDef(
          "EquivalentPupilRadius", 0x00460205, "Equivalent Pupil Radius", VR.kFL, VM.k1, false);
  static const ElementDef kCornealTopographyMapTypeCodeSequence
      //(0046,0207)
      = const ElementDef("CornealTopographyMapTypeCodeSequence", 0x00460207,
          "Corneal Topography Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVerticesOfTheOutlineOfPupil
      //(0046,0208)
      = const ElementDef("VerticesOfTheOutlineOfPupil", 0x00460208, "Vertices of the Outline of Pupil",
          VR.kIS, VM.k2_2n, false);
  static const ElementDef kCornealTopographyMappingNormalsSequence
      //(0046,0210)
      = const ElementDef("CornealTopographyMappingNormalsSequence", 0x00460210,
          "Corneal Topography Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMaximumCornealCurvatureSequence
      //(0046,0211)
      = const ElementDef("MaximumCornealCurvatureSequence", 0x00460211,
          "Maximum Corneal Curvature Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMaximumCornealCurvature
      //(0046,0212)
      = const ElementDef(
          "MaximumCornealCurvature", 0x00460212, "Maximum Corneal Curvature", VR.kFL, VM.k1, false);
  static const ElementDef kMaximumCornealCurvatureLocation
      //(0046,0213)
      = const ElementDef("MaximumCornealCurvatureLocation", 0x00460213,
          "Maximum Corneal Curvature Location", VR.kFL, VM.k2, false);
  static const ElementDef kMinimumKeratometricSequence
      //(0046,0215)
      = const ElementDef("MinimumKeratometricSequence", 0x00460215, "Minimum Keratometric Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSimulatedKeratometricCylinderSequence
      //(0046,0218)
      = const ElementDef("SimulatedKeratometricCylinderSequence", 0x00460218,
          "Simulated Keratometric Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAverageCornealPower
      //(0046,0220)
      = const ElementDef(
          "AverageCornealPower", 0x00460220, "Average Corneal Power", VR.kFL, VM.k1, false);
  static const ElementDef kCornealISValue
      //(0046,0224)
      = const ElementDef("CornealISValue", 0x00460224, "Corneal I-S Value", VR.kFL, VM.k1, false);
  static const ElementDef kAnalyzedArea
      //(0046,0227)
      = const ElementDef("AnalyzedArea", 0x00460227, "Analyzed Area", VR.kFL, VM.k1, false);
  static const ElementDef kSurfaceRegularityIndex
      //(0046,0230)
      = const ElementDef(
          "SurfaceRegularityIndex", 0x00460230, "Surface Regularity Index", VR.kFL, VM.k1, false);
  static const ElementDef kSurfaceAsymmetryIndex
      //(0046,0232)
      = const ElementDef(
          "SurfaceAsymmetryIndex", 0x00460232, "Surface Asymmetry Index", VR.kFL, VM.k1, false);
  static const ElementDef kCornealEccentricityIndex
      //(0046,0234)
      = const ElementDef("CornealEccentricityIndex", 0x00460234, "Corneal Eccentricity Index", VR.kFL,
          VM.k1, false);
  static const ElementDef kKeratoconusPredictionIndex
      //(0046,0236)
      = const ElementDef("KeratoconusPredictionIndex", 0x00460236, "Keratoconus Prediction Index",
          VR.kFL, VM.k1, false);
  static const ElementDef kDecimalPotentialVisualAcuity
      //(0046,0238)
      = const ElementDef("DecimalPotentialVisualAcuity", 0x00460238, "Decimal Potential Visual Acuity",
          VR.kFL, VM.k1, false);
  static const ElementDef kCornealTopographyMapQualityEvaluation
      //(0046,0242)
      = const ElementDef("CornealTopographyMapQualityEvaluation", 0x00460242,
          "Corneal Topography Map Quality Evaluation", VR.kCS, VM.k1, false);
  static const ElementDef kSourceImageCornealProcessedDataSequence
      //(0046,0244)
      = const ElementDef("SourceImageCornealProcessedDataSequence", 0x00460244,
          "Source Image Corneal Processed Data Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCornealPointLocation
      //(0046,0247)
      = const ElementDef(
          "CornealPointLocation", 0x00460247, "Corneal Point Location", VR.kFL, VM.k3, false);
  static const ElementDef kCornealPointEstimated
      //(0046,0248)
      = const ElementDef(
          "CornealPointEstimated", 0x00460248, "Corneal Point Estimated", VR.kCS, VM.k1, false);
  static const ElementDef kAxialPower
      //(0046,0249)
      = const ElementDef("AxialPower", 0x00460249, "Axial Power", VR.kFL, VM.k1, false);
  static const ElementDef kTangentialPower
      //(0046,0250)
      = const ElementDef("TangentialPower", 0x00460250, "Tangential Power", VR.kFL, VM.k1, false);
  static const ElementDef kRefractivePower
      //(0046,0251)
      = const ElementDef("RefractivePower", 0x00460251, "Refractive Power", VR.kFL, VM.k1, false);
  static const ElementDef kRelativeElevation
      //(0046,0252)
      = const ElementDef("RelativeElevation", 0x00460252, "Relative Elevation", VR.kFL, VM.k1, false);
  static const ElementDef kCornealWavefront
      //(0046,0253)
      = const ElementDef("CornealWavefront", 0x00460253, "Corneal Wavefront", VR.kFL, VM.k1, false);
  static const ElementDef kImagedVolumeWidth
      //(0048,0001)
      = const ElementDef("ImagedVolumeWidth", 0x00480001, "Imaged Volume Width", VR.kFL, VM.k1, false);
  static const ElementDef kImagedVolumeHeight
      //(0048,0002)
      =
      const ElementDef("ImagedVolumeHeight", 0x00480002, "Imaged Volume Height", VR.kFL, VM.k1, false);
  static const ElementDef kImagedVolumeDepth
      //(0048,0003)
      = const ElementDef("ImagedVolumeDepth", 0x00480003, "Imaged Volume Depth", VR.kFL, VM.k1, false);
  static const ElementDef kTotalPixelMatrixColumns
      //(0048,0006)
      = const ElementDef("TotalPixelMatrixColumns", 0x00480006, "Total Pixel Matrix Columns", VR.kUL,
          VM.k1, false);
  static const ElementDef kTotalPixelMatrixRows
      //(0048,0007)
      = const ElementDef(
          "TotalPixelMatrixRows", 0x00480007, "Total Pixel Matrix Rows", VR.kUL, VM.k1, false);
  static const ElementDef kTotalPixelMatrixOriginSequence
      //(0048,0008)
      = const ElementDef("TotalPixelMatrixOriginSequence", 0x00480008,
          "Total Pixel Matrix Origin Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenLabelInImage
      //(0048,0010)
      = const ElementDef(
          "SpecimenLabelInImage", 0x00480010, "Specimen Label in Image", VR.kCS, VM.k1, false);
  static const ElementDef kFocusMethod
      //(0048,0011)
      = const ElementDef("FocusMethod", 0x00480011, "Focus Method", VR.kCS, VM.k1, false);
  static const ElementDef kExtendedDepthOfField
      //(0048,0012)
      = const ElementDef(
          "ExtendedDepthOfField", 0x00480012, "Extended Depth of Field", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfFocalPlanes
      //(0048,0013)
      = const ElementDef(
          "NumberOfFocalPlanes", 0x00480013, "Number of Focal Planes", VR.kUS, VM.k1, false);
  static const ElementDef kDistanceBetweenFocalPlanes
      //(0048,0014)
      = const ElementDef("DistanceBetweenFocalPlanes", 0x00480014, "Distance Between Focal Planes",
          VR.kFL, VM.k1, false);
  static const ElementDef kRecommendedAbsentPixelCIELabValue
      //(0048,0015)
      = const ElementDef("RecommendedAbsentPixelCIELabValue", 0x00480015,
          "Recommended Absent Pixel CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kIlluminatorTypeCodeSequence
      //(0048,0100)
      = const ElementDef("IlluminatorTypeCodeSequence", 0x00480100, "Illuminator Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImageOrientationSlide
      //(0048,0102)
      = const ElementDef(
          "ImageOrientationSlide", 0x00480102, "Image Orientation (Slide)", VR.kDS, VM.k6, false);
  static const ElementDef kOpticalPathSequence
      //(0048,0105)
      = const ElementDef(
          "OpticalPathSequence", 0x00480105, "Optical Path Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOpticalPathIdentifier
      //(0048,0106)
      = const ElementDef(
          "OpticalPathIdentifier", 0x00480106, "Optical Path Identifier", VR.kSH, VM.k1, false);
  static const ElementDef kOpticalPathDescription
      //(0048,0107)
      = const ElementDef(
          "OpticalPathDescription", 0x00480107, "Optical Path Description", VR.kST, VM.k1, false);
  static const ElementDef kIlluminationColorCodeSequence
      //(0048,0108)
      = const ElementDef("IlluminationColorCodeSequence", 0x00480108,
          "Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecimenReferenceSequence
      //(0048,0110)
      = const ElementDef("SpecimenReferenceSequence", 0x00480110, "Specimen Reference Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCondenserLensPower
      //(0048,0111)
      =
      const ElementDef("CondenserLensPower", 0x00480111, "Condenser Lens Power", VR.kDS, VM.k1, false);
  static const ElementDef kObjectiveLensPower
      //(0048,0112)
      =
      const ElementDef("ObjectiveLensPower", 0x00480112, "Objective Lens Power", VR.kDS, VM.k1, false);
  static const ElementDef kObjectiveLensNumericalAperture
      //(0048,0113)
      = const ElementDef("ObjectiveLensNumericalAperture", 0x00480113,
          "Objective Lens Numerical Aperture", VR.kDS, VM.k1, false);
  static const ElementDef kPaletteColorLookupTableSequence
      //(0048,0120)
      = const ElementDef("PaletteColorLookupTableSequence", 0x00480120,
          "Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedImageNavigationSequence
      //(0048,0200)
      = const ElementDef("ReferencedImageNavigationSequence", 0x00480200,
          "Referenced Image Navigation Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTopLeftHandCornerOfLocalizerArea
      //(0048,0201)
      = const ElementDef("TopLeftHandCornerOfLocalizerArea", 0x00480201,
          "Top Left Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const ElementDef kBottomRightHandCornerOfLocalizerArea
      //(0048,0202)
      = const ElementDef("BottomRightHandCornerOfLocalizerArea", 0x00480202,
          "Bottom Right Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const ElementDef kOpticalPathIdentificationSequence
      //(0048,0207)
      = const ElementDef("OpticalPathIdentificationSequence", 0x00480207,
          "Optical Path Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlanePositionSlideSequence
      //(0048,021A)
      = const ElementDef("PlanePositionSlideSequence", 0x0048021A, "Plane Position (Slide) Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kColumnPositionInTotalImagePixelMatrix
      //(0048,021E)
      = const ElementDef("ColumnPositionInTotalImagePixelMatrix", 0x0048021E,
          "Column Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const ElementDef kRowPositionInTotalImagePixelMatrix
      //(0048,021F)
      = const ElementDef("RowPositionInTotalImagePixelMatrix", 0x0048021F,
          "Row Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const ElementDef kPixelOriginInterpretation
      //(0048,0301)
      = const ElementDef("PixelOriginInterpretation", 0x00480301, "Pixel Origin Interpretation",
          VR.kCS, VM.k1, false);
  static const ElementDef kCalibrationImage
      //(0050,0004)
      = const ElementDef("CalibrationImage", 0x00500004, "Calibration Image", VR.kCS, VM.k1, false);
  static const ElementDef kDeviceSequence
      //(0050,0010)
      = const ElementDef("DeviceSequence", 0x00500010, "Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContainerComponentTypeCodeSequence
      //(0050,0012)
      = const ElementDef("ContainerComponentTypeCodeSequence", 0x00500012,
          "Container Component Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContainerComponentThickness
      //(0050,0013)
      = const ElementDef("ContainerComponentThickness", 0x00500013, "Container Component Thickness",
          VR.kFD, VM.k1, false);
  static const ElementDef kDeviceLength
      //(0050,0014)
      = const ElementDef("DeviceLength", 0x00500014, "Device Length", VR.kDS, VM.k1, false);
  static const ElementDef kContainerComponentWidth
      //(0050,0015)
      = const ElementDef(
          "ContainerComponentWidth", 0x00500015, "Container Component Width", VR.kFD, VM.k1, false);
  static const ElementDef kDeviceDiameter
      //(0050,0016)
      = const ElementDef("DeviceDiameter", 0x00500016, "Device Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kDeviceDiameterUnits
      //(0050,0017)
      = const ElementDef(
          "DeviceDiameterUnits", 0x00500017, "Device Diameter Units", VR.kCS, VM.k1, false);
  static const ElementDef kDeviceVolume
      //(0050,0018)
      = const ElementDef("DeviceVolume", 0x00500018, "Device Volume", VR.kDS, VM.k1, false);
  static const ElementDef kInterMarkerDistance
      //(0050,0019)
      = const ElementDef(
          "InterMarkerDistance", 0x00500019, "Inter-Marker Distance", VR.kDS, VM.k1, false);
  static const ElementDef kContainerComponentMaterial
      //(0050,001A)
      = const ElementDef("ContainerComponentMaterial", 0x0050001A, "Container Component Material",
          VR.kCS, VM.k1, false);
  static const ElementDef kContainerComponentID
      //(0050,001B)
      = const ElementDef(
          "ContainerComponentID", 0x0050001B, "Container Component ID", VR.kLO, VM.k1, false);
  static const ElementDef kContainerComponentLength
      //(0050,001C)
      = const ElementDef("ContainerComponentLength", 0x0050001C, "Container Component Length", VR.kFD,
          VM.k1, false);
  static const ElementDef kContainerComponentDiameter
      //(0050,001D)
      = const ElementDef("ContainerComponentDiameter", 0x0050001D, "Container Component Diameter",
          VR.kFD, VM.k1, false);
  static const ElementDef kContainerComponentDescription
      //(0050,001E)
      = const ElementDef("ContainerComponentDescription", 0x0050001E,
          "Container Component Description", VR.kLO, VM.k1, false);
  static const ElementDef kDeviceDescription
      //(0050,0020)
      = const ElementDef("DeviceDescription", 0x00500020, "Device Description", VR.kLO, VM.k1, false);
  static const ElementDef kContrastBolusIngredientPercentByVolume
      //(0052,0001)
      = const ElementDef("ContrastBolusIngredientPercentByVolume", 0x00520001,
          "Contrast/Bolus Ingredient Percent by Volume", VR.kFL, VM.k1, false);
  static const ElementDef kOCTFocalDistance
      //(0052,0002)
      = const ElementDef("OCTFocalDistance", 0x00520002, "OCT Focal Distance", VR.kFD, VM.k1, false);
  static const ElementDef kBeamSpotSize
      //(0052,0003)
      = const ElementDef("BeamSpotSize", 0x00520003, "Beam Spot Size", VR.kFD, VM.k1, false);
  static const ElementDef kEffectiveRefractiveIndex
      //(0052,0004)
      = const ElementDef("EffectiveRefractiveIndex", 0x00520004, "Effective Refractive Index", VR.kFD,
          VM.k1, false);
  static const ElementDef kOCTAcquisitionDomain
      //(0052,0006)
      = const ElementDef(
          "OCTAcquisitionDomain", 0x00520006, "OCT Acquisition Domain", VR.kCS, VM.k1, false);
  static const ElementDef kOCTOpticalCenterWavelength
      //(0052,0007)
      = const ElementDef("OCTOpticalCenterWavelength", 0x00520007, "OCT Optical Center Wavelength",
          VR.kFD, VM.k1, false);
  static const ElementDef kAxialResolution
      //(0052,0008)
      = const ElementDef("AxialResolution", 0x00520008, "Axial Resolution", VR.kFD, VM.k1, false);
  static const ElementDef kRangingDepth
      //(0052,0009)
      = const ElementDef("RangingDepth", 0x00520009, "Ranging Depth", VR.kFD, VM.k1, false);
  static const ElementDef kALineRate
      //(0052,0011)
      = const ElementDef("ALineRate", 0x00520011, "A-line Rate", VR.kFD, VM.k1, false);
  static const ElementDef kALinesPerFrame
      //(0052,0012)
      = const ElementDef("ALinesPerFrame", 0x00520012, "A-lines Per Frame", VR.kUS, VM.k1, false);
  static const ElementDef kCatheterRotationalRate
      //(0052,0013)
      = const ElementDef(
          "CatheterRotationalRate", 0x00520013, "Catheter Rotational Rate", VR.kFD, VM.k1, false);
  static const ElementDef kALinePixelSpacing
      //(0052,0014)
      =
      const ElementDef("ALinePixelSpacing", 0x00520014, "A-line Pixel Spacing", VR.kFD, VM.k1, false);
  static const ElementDef kModeOfPercutaneousAccessSequence
      //(0052,0016)
      = const ElementDef("ModeOfPercutaneousAccessSequence", 0x00520016,
          "Mode of Percutaneous Access Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIntravascularOCTFrameTypeSequence
      //(0052,0025)
      = const ElementDef("IntravascularOCTFrameTypeSequence", 0x00520025,
          "Intravascular OCT Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOCTZOffsetApplied
      //(0052,0026)
      =
      const ElementDef("OCTZOffsetApplied", 0x00520026, "OCT Z Offset Applied", VR.kCS, VM.k1, false);
  static const ElementDef kIntravascularFrameContentSequence
      //(0052,0027)
      = const ElementDef("IntravascularFrameContentSequence", 0x00520027,
          "Intravascular Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIntravascularLongitudinalDistance
      //(0052,0028)
      = const ElementDef("IntravascularLongitudinalDistance", 0x00520028,
          "Intravascular Longitudinal Distance", VR.kFD, VM.k1, false);
  static const ElementDef kIntravascularOCTFrameContentSequence
      //(0052,0029)
      = const ElementDef("IntravascularOCTFrameContentSequence", 0x00520029,
          "Intravascular OCT Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOCTZOffsetCorrection
      //(0052,0030)
      = const ElementDef(
          "OCTZOffsetCorrection", 0x00520030, "OCT Z Offset Correction", VR.kSS, VM.k1, false);
  static const ElementDef kCatheterDirectionOfRotation
      //(0052,0031)
      = const ElementDef("CatheterDirectionOfRotation", 0x00520031, "Catheter Direction of Rotation",
          VR.kCS, VM.k1, false);
  static const ElementDef kSeamLineLocation
      //(0052,0033)
      = const ElementDef("SeamLineLocation", 0x00520033, "Seam Line Location", VR.kFD, VM.k1, false);
  static const ElementDef kFirstALineLocation
      //(0052,0034)
      = const ElementDef(
          "FirstALineLocation", 0x00520034, "First A-line Location", VR.kFD, VM.k1, false);
  static const ElementDef kSeamLineIndex
      //(0052,0036)
      = const ElementDef("SeamLineIndex", 0x00520036, "Seam Line Index", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfPaddedALines
      //(0052,0038)
      = const ElementDef(
          "NumberOfPaddedALines", 0x00520038, "Number of Padded A-lines", VR.kUS, VM.k1, false);
  static const ElementDef kInterpolationType
      //(0052,0039)
      = const ElementDef("InterpolationType", 0x00520039, "Interpolation Type", VR.kCS, VM.k1, false);
  static const ElementDef kRefractiveIndexApplied
      //(0052,003A)
      = const ElementDef(
          "RefractiveIndexApplied", 0x0052003A, "Refractive Index Applied", VR.kCS, VM.k1, false);
  static const ElementDef kEnergyWindowVector
      //(0054,0010)
      = const ElementDef(
          "EnergyWindowVector", 0x00540010, "Energy Window Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfEnergyWindows
      //(0054,0011)
      = const ElementDef(
          "NumberOfEnergyWindows", 0x00540011, "Number of Energy Windows", VR.kUS, VM.k1, false);
  static const ElementDef kEnergyWindowInformationSequence
      //(0054,0012)
      = const ElementDef("EnergyWindowInformationSequence", 0x00540012,
          "Energy Window Information Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kEnergyWindowRangeSequence
      //(0054,0013)
      = const ElementDef("EnergyWindowRangeSequence", 0x00540013, "Energy Window Range Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kEnergyWindowLowerLimit
      //(0054,0014)
      = const ElementDef(
          "EnergyWindowLowerLimit", 0x00540014, "Energy Window Lower Limit", VR.kDS, VM.k1, false);
  static const ElementDef kEnergyWindowUpperLimit
      //(0054,0015)
      = const ElementDef(
          "EnergyWindowUpperLimit", 0x00540015, "Energy Window Upper Limit", VR.kDS, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalInformationSequence
      //(0054,0016)
      = const ElementDef("RadiopharmaceuticalInformationSequence", 0x00540016,
          "Radiopharmaceutical Information Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kResidualSyringeCounts
      //(0054,0017)
      = const ElementDef(
          "ResidualSyringeCounts", 0x00540017, "Residual Syringe Counts", VR.kIS, VM.k1, false);
  static const ElementDef kEnergyWindowName
      //(0054,0018)
      = const ElementDef("EnergyWindowName", 0x00540018, "Energy Window Name", VR.kSH, VM.k1, false);
  static const ElementDef kDetectorVector
      //(0054,0020)
      = const ElementDef("DetectorVector", 0x00540020, "Detector Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfDetectors
      //(0054,0021)
      = const ElementDef("NumberOfDetectors", 0x00540021, "Number of Detectors", VR.kUS, VM.k1, false);
  static const ElementDef kDetectorInformationSequence
      //(0054,0022)
      = const ElementDef("DetectorInformationSequence", 0x00540022, "Detector Information Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPhaseVector
      //(0054,0030)
      = const ElementDef("PhaseVector", 0x00540030, "Phase Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfPhases
      //(0054,0031)
      = const ElementDef("NumberOfPhases", 0x00540031, "Number of Phases", VR.kUS, VM.k1, false);
  static const ElementDef kPhaseInformationSequence
      //(0054,0032)
      = const ElementDef("PhaseInformationSequence", 0x00540032, "Phase Information Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kNumberOfFramesInPhase
      //(0054,0033)
      = const ElementDef(
          "NumberOfFramesInPhase", 0x00540033, "Number of Frames in Phase", VR.kUS, VM.k1, false);
  static const ElementDef kPhaseDelay
      //(0054,0036)
      = const ElementDef("PhaseDelay", 0x00540036, "Phase Delay", VR.kIS, VM.k1, false);
  static const ElementDef kPauseBetweenFrames
      //(0054,0038)
      =
      const ElementDef("PauseBetweenFrames", 0x00540038, "Pause Between Frames", VR.kIS, VM.k1, false);
  static const ElementDef kPhaseDescription
      //(0054,0039)
      = const ElementDef("PhaseDescription", 0x00540039, "Phase Description", VR.kCS, VM.k1, false);
  static const ElementDef kRotationVector
      //(0054,0050)
      = const ElementDef("RotationVector", 0x00540050, "Rotation Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfRotations
      //(0054,0051)
      = const ElementDef("NumberOfRotations", 0x00540051, "Number of Rotations", VR.kUS, VM.k1, false);
  static const ElementDef kRotationInformationSequence
      //(0054,0052)
      = const ElementDef("RotationInformationSequence", 0x00540052, "Rotation Information Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfFramesInRotation
      //(0054,0053)
      = const ElementDef("NumberOfFramesInRotation", 0x00540053, "Number of Frames in Rotation",
          VR.kUS, VM.k1, false);
  static const ElementDef kRRIntervalVector
      //(0054,0060)
      =
      const ElementDef("RRIntervalVector", 0x00540060, "R-R Interval Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfRRIntervals
      //(0054,0061)
      = const ElementDef(
          "NumberOfRRIntervals", 0x00540061, "Number of R-R Intervals", VR.kUS, VM.k1, false);
  static const ElementDef kGatedInformationSequence
      //(0054,0062)
      = const ElementDef("GatedInformationSequence", 0x00540062, "Gated Information Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kDataInformationSequence
      //(0054,0063)
      = const ElementDef(
          "DataInformationSequence", 0x00540063, "Data Information Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTimeSlotVector
      //(0054,0070)
      = const ElementDef("TimeSlotVector", 0x00540070, "Time Slot Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfTimeSlots
      //(0054,0071)
      =
      const ElementDef("NumberOfTimeSlots", 0x00540071, "Number of Time Slots", VR.kUS, VM.k1, false);
  static const ElementDef kTimeSlotInformationSequence
      //(0054,0072)
      = const ElementDef("TimeSlotInformationSequence", 0x00540072, "Time Slot Information Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTimeSlotTime
      //(0054,0073)
      = const ElementDef("TimeSlotTime", 0x00540073, "Time Slot Time", VR.kDS, VM.k1, false);
  static const ElementDef kSliceVector
      //(0054,0080)
      = const ElementDef("SliceVector", 0x00540080, "Slice Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfSlices
      //(0054,0081)
      = const ElementDef("NumberOfSlices", 0x00540081, "Number of Slices", VR.kUS, VM.k1, false);
  static const ElementDef kAngularViewVector
      //(0054,0090)
      =
      const ElementDef("AngularViewVector", 0x00540090, "Angular View Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kTimeSliceVector
      //(0054,0100)
      = const ElementDef("TimeSliceVector", 0x00540100, "Time Slice Vector", VR.kUS, VM.k1_n, false);
  static const ElementDef kNumberOfTimeSlices
      //(0054,0101)
      = const ElementDef(
          "NumberOfTimeSlices", 0x00540101, "Number of Time Slices", VR.kUS, VM.k1, false);
  static const ElementDef kStartAngle
      //(0054,0200)
      = const ElementDef("StartAngle", 0x00540200, "Start Angle", VR.kDS, VM.k1, false);
  static const ElementDef kTypeOfDetectorMotion
      //(0054,0202)
      = const ElementDef(
          "TypeOfDetectorMotion", 0x00540202, "Type of Detector Motion", VR.kCS, VM.k1, false);
  static const ElementDef kTriggerVector
      //(0054,0210)
      = const ElementDef("TriggerVector", 0x00540210, "Trigger Vector", VR.kIS, VM.k1_n, false);
  static const ElementDef kNumberOfTriggersInPhase
      //(0054,0211)
      = const ElementDef("NumberOfTriggersInPhase", 0x00540211, "Number of Triggers in Phase", VR.kUS,
          VM.k1, false);
  static const ElementDef kViewCodeSequence
      //(0054,0220)
      = const ElementDef("ViewCodeSequence", 0x00540220, "View Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kViewModifierCodeSequence
      //(0054,0222)
      = const ElementDef("ViewModifierCodeSequence", 0x00540222, "View Modifier Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kRadionuclideCodeSequence
      //(0054,0300)
      = const ElementDef("RadionuclideCodeSequence", 0x00540300, "Radionuclide Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kAdministrationRouteCodeSequence
      //(0054,0302)
      = const ElementDef("AdministrationRouteCodeSequence", 0x00540302,
          "Administration Route Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRadiopharmaceuticalCodeSequence
      //(0054,0304)
      = const ElementDef("RadiopharmaceuticalCodeSequence", 0x00540304,
          "Radiopharmaceutical Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCalibrationDataSequence
      //(0054,0306)
      = const ElementDef(
          "CalibrationDataSequence", 0x00540306, "Calibration Data Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kEnergyWindowNumber
      //(0054,0308)
      =
      const ElementDef("EnergyWindowNumber", 0x00540308, "Energy Window Number", VR.kUS, VM.k1, false);
  static const ElementDef kImageID
      //(0054,0400)
      = const ElementDef("ImageID", 0x00540400, "Image ID", VR.kSH, VM.k1, false);
  static const ElementDef kPatientOrientationCodeSequence
      //(0054,0410)
      = const ElementDef("PatientOrientationCodeSequence", 0x00540410,
          "Patient Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientOrientationModifierCodeSequence
      //(0054,0412)
      = const ElementDef("PatientOrientationModifierCodeSequence", 0x00540412,
          "Patient Orientation Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientGantryRelationshipCodeSequence
      //(0054,0414)
      = const ElementDef("PatientGantryRelationshipCodeSequence", 0x00540414,
          "Patient Gantry Relationship Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSliceProgressionDirection
      //(0054,0500)
      = const ElementDef("SliceProgressionDirection", 0x00540500, "Slice Progression Direction",
          VR.kCS, VM.k1, false);
  static const ElementDef kSeriesType
      //(0054,1000)
      = const ElementDef("SeriesType", 0x00541000, "Series Type", VR.kCS, VM.k2, false);
  static const ElementDef kUnits
      //(0054,1001)
      = const ElementDef("Units", 0x00541001, "Units", VR.kCS, VM.k1, false);
  static const ElementDef kCountsSource
      //(0054,1002)
      = const ElementDef("CountsSource", 0x00541002, "Counts Source", VR.kCS, VM.k1, false);
  static const ElementDef kReprojectionMethod
      //(0054,1004)
      =
      const ElementDef("ReprojectionMethod", 0x00541004, "Reprojection Method", VR.kCS, VM.k1, false);
  static const ElementDef kSUVType
      //(0054,1006)
      = const ElementDef("SUVType", 0x00541006, "SUV Type", VR.kCS, VM.k1, false);
  static const ElementDef kRandomsCorrectionMethod
      //(0054,1100)
      = const ElementDef(
          "RandomsCorrectionMethod", 0x00541100, "Randoms Correction Method", VR.kCS, VM.k1, false);
  static const ElementDef kAttenuationCorrectionMethod
      //(0054,1101)
      = const ElementDef("AttenuationCorrectionMethod", 0x00541101, "Attenuation Correction Method",
          VR.kLO, VM.k1, false);
  static const ElementDef kDecayCorrection
      //(0054,1102)
      = const ElementDef("DecayCorrection", 0x00541102, "Decay Correction", VR.kCS, VM.k1, false);
  static const ElementDef kReconstructionMethod
      //(0054,1103)
      = const ElementDef(
          "ReconstructionMethod", 0x00541103, "Reconstruction Method", VR.kLO, VM.k1, false);
  static const ElementDef kDetectorLinesOfResponseUsed
      //(0054,1104)
      = const ElementDef("DetectorLinesOfResponseUsed", 0x00541104, "Detector Lines of Response Used",
          VR.kLO, VM.k1, false);
  static const ElementDef kScatterCorrectionMethod
      //(0054,1105)
      = const ElementDef(
          "ScatterCorrectionMethod", 0x00541105, "Scatter Correction Method", VR.kLO, VM.k1, false);
  static const ElementDef kAxialAcceptance
      //(0054,1200)
      = const ElementDef("AxialAcceptance", 0x00541200, "Axial Acceptance", VR.kDS, VM.k1, false);
  static const ElementDef kAxialMash
      //(0054,1201)
      = const ElementDef("AxialMash", 0x00541201, "Axial Mash", VR.kIS, VM.k2, false);
  static const ElementDef kTransverseMash
      //(0054,1202)
      = const ElementDef("TransverseMash", 0x00541202, "Transverse Mash", VR.kIS, VM.k1, false);
  static const ElementDef kDetectorElementSize
      //(0054,1203)
      = const ElementDef(
          "DetectorElementSize", 0x00541203, "Detector Element Size", VR.kDS, VM.k2, false);
  static const ElementDef kCoincidenceWindowWidth
      //(0054,1210)
      = const ElementDef(
          "CoincidenceWindowWidth", 0x00541210, "Coincidence Window Width", VR.kDS, VM.k1, false);
  static const ElementDef kSecondaryCountsType
      //(0054,1220)
      = const ElementDef(
          "SecondaryCountsType", 0x00541220, "Secondary Counts Type", VR.kCS, VM.k1_n, false);
  static const ElementDef kFrameReferenceTime
      //(0054,1300)
      =
      const ElementDef("FrameReferenceTime", 0x00541300, "Frame Reference Time", VR.kDS, VM.k1, false);
  static const ElementDef kPrimaryPromptsCountsAccumulated
      //(0054,1310)
      = const ElementDef("PrimaryPromptsCountsAccumulated", 0x00541310,
          "Primary (Prompts) Counts Accumulated", VR.kIS, VM.k1, false);
  static const ElementDef kSecondaryCountsAccumulated
      //(0054,1311)
      = const ElementDef("SecondaryCountsAccumulated", 0x00541311, "Secondary Counts Accumulated",
          VR.kIS, VM.k1_n, false);
  static const ElementDef kSliceSensitivityFactor
      //(0054,1320)
      = const ElementDef(
          "SliceSensitivityFactor", 0x00541320, "Slice Sensitivity Factor", VR.kDS, VM.k1, false);
  static const ElementDef kDecayFactor
      //(0054,1321)
      = const ElementDef("DecayFactor", 0x00541321, "Decay Factor", VR.kDS, VM.k1, false);
  static const ElementDef kDoseCalibrationFactor
      //(0054,1322)
      = const ElementDef(
          "DoseCalibrationFactor", 0x00541322, "Dose Calibration Factor", VR.kDS, VM.k1, false);
  static const ElementDef kScatterFractionFactor
      //(0054,1323)
      = const ElementDef(
          "ScatterFractionFactor", 0x00541323, "Scatter Fraction Factor", VR.kDS, VM.k1, false);
  static const ElementDef kDeadTimeFactor
      //(0054,1324)
      = const ElementDef("DeadTimeFactor", 0x00541324, "Dead Time Factor", VR.kDS, VM.k1, false);
  static const ElementDef kImageIndex
      //(0054,1330)
      = const ElementDef("ImageIndex", 0x00541330, "Image Index", VR.kUS, VM.k1, false);
  static const ElementDef kCountsIncluded
      //(0054,1400)
      = const ElementDef("CountsIncluded", 0x00541400, "Counts Included", VR.kCS, VM.k1_n, true);
  static const ElementDef kDeadTimeCorrectionFlag
      //(0054,1401)
      = const ElementDef(
          "DeadTimeCorrectionFlag", 0x00541401, "Dead Time Correction Flag", VR.kCS, VM.k1, true);
  static const ElementDef kHistogramSequence
      //(0060,3000)
      = const ElementDef("HistogramSequence", 0x00603000, "Histogram Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHistogramNumberOfBins
      //(0060,3002)
      = const ElementDef(
          "HistogramNumberOfBins", 0x00603002, "Histogram Number of Bins", VR.kUS, VM.k1, false);
  static const ElementDef kHistogramFirstBinValue
      //(0060,3004)
      = const ElementDef("HistogramFirstBinValue", 0x00603004, "Histogram First Bin Value", VR.kUSSS,
          VM.k1, false);
  static const ElementDef kHistogramLastBinValue
      //(0060,3006)
      = const ElementDef(
          "HistogramLastBinValue", 0x00603006, "Histogram Last Bin Value", VR.kUSSS, VM.k1, false);
  static const ElementDef kHistogramBinWidth
      //(0060,3008)
      = const ElementDef("HistogramBinWidth", 0x00603008, "Histogram Bin Width", VR.kUS, VM.k1, false);
  static const ElementDef kHistogramExplanation
      //(0060,3010)
      = const ElementDef(
          "HistogramExplanation", 0x00603010, "Histogram Explanation", VR.kLO, VM.k1, false);
  static const ElementDef kHistogramData
      //(0060,3020)
      = const ElementDef("HistogramData", 0x00603020, "Histogram Data", VR.kUL, VM.k1_n, false);
  static const ElementDef kSegmentationType
      //(0062,0001)
      = const ElementDef("SegmentationType", 0x00620001, "Segmentation Type", VR.kCS, VM.k1, false);
  static const ElementDef kSegmentSequence
      //(0062,0002)
      = const ElementDef("SegmentSequence", 0x00620002, "Segment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSegmentedPropertyCategoryCodeSequence
      //(0062,0003)
      = const ElementDef("SegmentedPropertyCategoryCodeSequence", 0x00620003,
          "Segmented Property Category Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSegmentNumber
      //(0062,0004)
      = const ElementDef("SegmentNumber", 0x00620004, "Segment Number", VR.kUS, VM.k1, false);
  static const ElementDef kSegmentLabel
      //(0062,0005)
      = const ElementDef("SegmentLabel", 0x00620005, "Segment Label", VR.kLO, VM.k1, false);
  static const ElementDef kSegmentDescription
      //(0062,0006)
      =
      const ElementDef("SegmentDescription", 0x00620006, "Segment Description", VR.kST, VM.k1, false);
  static const ElementDef kSegmentAlgorithmType
      //(0062,0008)
      = const ElementDef(
          "SegmentAlgorithmType", 0x00620008, "Segment Algorithm Type", VR.kCS, VM.k1, false);
  static const ElementDef kSegmentAlgorithmName
      //(0062,0009)
      = const ElementDef(
          "SegmentAlgorithmName", 0x00620009, "Segment Algorithm Name", VR.kLO, VM.k1, false);
  static const ElementDef kSegmentIdentificationSequence
      //(0062,000A)
      = const ElementDef("SegmentIdentificationSequence", 0x0062000A,
          "Segment Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSegmentNumber
      //(0062,000B)
      = const ElementDef("ReferencedSegmentNumber", 0x0062000B, "Referenced Segment Number", VR.kUS,
          VM.k1_n, false);
  static const ElementDef kRecommendedDisplayGrayscaleValue
      //(0062,000C)
      = const ElementDef("RecommendedDisplayGrayscaleValue", 0x0062000C,
          "Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const ElementDef kRecommendedDisplayCIELabValue
      //(0062,000D)
      = const ElementDef("RecommendedDisplayCIELabValue", 0x0062000D,
          "Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kMaximumFractionalValue
      //(0062,000E)
      = const ElementDef(
          "MaximumFractionalValue", 0x0062000E, "Maximum Fractional Value", VR.kUS, VM.k1, false);
  static const ElementDef kSegmentedPropertyTypeCodeSequence
      //(0062,000F)
      = const ElementDef("SegmentedPropertyTypeCodeSequence", 0x0062000F,
          "Segmented Property Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSegmentationFractionalType
      //(0062,0010)
      = const ElementDef("SegmentationFractionalType", 0x00620010, "Segmentation Fractional Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kSegmentedPropertyTypeModifierCodeSequence
      //(0062,0011)
      = const ElementDef("SegmentedPropertyTypeModifierCodeSequence", 0x00620011,
          "Segmented Property Type Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUsedSegmentsSequence
      //(0062,0012)
      = const ElementDef(
          "UsedSegmentsSequence", 0x00620012, "Used Segments Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDeformableRegistrationSequence
      //(0064,0002)
      = const ElementDef("DeformableRegistrationSequence", 0x00640002,
          "Deformable Registration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceFrameOfReferenceUID
      //(0064,0003)
      = const ElementDef("SourceFrameOfReferenceUID", 0x00640003, "Source Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const ElementDef kDeformableRegistrationGridSequence
      //(0064,0005)
      = const ElementDef("DeformableRegistrationGridSequence", 0x00640005,
          "Deformable Registration Grid Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGridDimensions
      //(0064,0007)
      = const ElementDef("GridDimensions", 0x00640007, "Grid Dimensions", VR.kUL, VM.k3, false);
  static const ElementDef kGridResolution
      //(0064,0008)
      = const ElementDef("GridResolution", 0x00640008, "Grid Resolution", VR.kFD, VM.k3, false);
  static const ElementDef kVectorGridData
      //(0064,0009)
      = const ElementDef("VectorGridData", 0x00640009, "Vector Grid Data", VR.kOF, VM.k1, false);
  static const ElementDef kPreDeformationMatrixRegistrationSequence
      //(0064,000F)
      = const ElementDef("PreDeformationMatrixRegistrationSequence", 0x0064000F,
          "Pre Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPostDeformationMatrixRegistrationSequence
      //(0064,0010)
      = const ElementDef("PostDeformationMatrixRegistrationSequence", 0x00640010,
          "Post Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfSurfaces
      //(0066,0001)
      = const ElementDef("NumberOfSurfaces", 0x00660001, "Number of Surfaces", VR.kUL, VM.k1, false);
  static const ElementDef kSurfaceSequence
      //(0066,0002)
      = const ElementDef("SurfaceSequence", 0x00660002, "Surface Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSurfaceNumber
      //(0066,0003)
      = const ElementDef("SurfaceNumber", 0x00660003, "Surface Number", VR.kUL, VM.k1, false);
  static const ElementDef kSurfaceComments
      //(0066,0004)
      = const ElementDef("SurfaceComments", 0x00660004, "Surface Comments", VR.kLT, VM.k1, false);
  static const ElementDef kSurfaceProcessing
      //(0066,0009)
      = const ElementDef("SurfaceProcessing", 0x00660009, "Surface Processing", VR.kCS, VM.k1, false);
  static const ElementDef kSurfaceProcessingRatio
      //(0066,000A)
      = const ElementDef(
          "SurfaceProcessingRatio", 0x0066000A, "Surface Processing Ratio", VR.kFL, VM.k1, false);
  static const ElementDef kSurfaceProcessingDescription
      //(0066,000B)
      = const ElementDef("SurfaceProcessingDescription", 0x0066000B, "Surface Processing Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kRecommendedPresentationOpacity
      //(0066,000C)
      = const ElementDef("RecommendedPresentationOpacity", 0x0066000C,
          "Recommended Presentation Opacity", VR.kFL, VM.k1, false);
  static const ElementDef kRecommendedPresentationType
      //(0066,000D)
      = const ElementDef("RecommendedPresentationType", 0x0066000D, "Recommended Presentation Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kFiniteVolume
      //(0066,000E)
      = const ElementDef("FiniteVolume", 0x0066000E, "Finite Volume", VR.kCS, VM.k1, false);
  static const ElementDef kManifold
      //(0066,0010)
      = const ElementDef("Manifold", 0x00660010, "Manifold", VR.kCS, VM.k1, false);
  static const ElementDef kSurfacePointsSequence
      //(0066,0011)
      = const ElementDef(
          "SurfacePointsSequence", 0x00660011, "Surface Points Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSurfacePointsNormalsSequence
      //(0066,0012)
      = const ElementDef("SurfacePointsNormalsSequence", 0x00660012, "Surface Points Normals Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSurfaceMeshPrimitivesSequence
      //(0066,0013)
      = const ElementDef("SurfaceMeshPrimitivesSequence", 0x00660013,
          "Surface Mesh Primitives Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfSurfacePoints
      //(0066,0015)
      = const ElementDef(
          "NumberOfSurfacePoints", 0x00660015, "Number of Surface Points", VR.kUL, VM.k1, false);
  static const ElementDef kPointCoordinatesData
      //(0066,0016)
      = const ElementDef(
          "PointCoordinatesData", 0x00660016, "Point Coordinates Data", VR.kOF, VM.k1, false);
  static const ElementDef kPointPositionAccuracy
      //(0066,0017)
      = const ElementDef(
          "PointPositionAccuracy", 0x00660017, "Point Position Accuracy", VR.kFL, VM.k3, false);
  static const ElementDef kMeanPointDistance
      //(0066,0018)
      = const ElementDef("MeanPointDistance", 0x00660018, "Mean Point Distance", VR.kFL, VM.k1, false);
  static const ElementDef kMaximumPointDistance
      //(0066,0019)
      = const ElementDef(
          "MaximumPointDistance", 0x00660019, "Maximum Point Distance", VR.kFL, VM.k1, false);
  static const ElementDef kPointsBoundingBoxCoordinates
      //(0066,001A)
      = const ElementDef("PointsBoundingBoxCoordinates", 0x0066001A, "Points Bounding Box Coordinates",
          VR.kFL, VM.k6, false);
  static const ElementDef kAxisOfRotation
      //(0066,001B)
      = const ElementDef("AxisOfRotation", 0x0066001B, "Axis of Rotation", VR.kFL, VM.k3, false);
  static const ElementDef kCenterOfRotation
      //(0066,001C)
      = const ElementDef("CenterOfRotation", 0x0066001C, "Center of Rotation", VR.kFL, VM.k3, false);
  static const ElementDef kNumberOfVectors
      //(0066,001E)
      = const ElementDef("NumberOfVectors", 0x0066001E, "Number of Vectors", VR.kUL, VM.k1, false);
  static const ElementDef kVectorDimensionality
      //(0066,001F)
      = const ElementDef(
          "VectorDimensionality", 0x0066001F, "Vector Dimensionality", VR.kUS, VM.k1, false);
  static const ElementDef kVectorAccuracy
      //(0066,0020)
      = const ElementDef("VectorAccuracy", 0x00660020, "Vector Accuracy", VR.kFL, VM.k1_n, false);
  static const ElementDef kVectorCoordinateData
      //(0066,0021)
      = const ElementDef(
          "VectorCoordinateData", 0x00660021, "Vector Coordinate Data", VR.kOF, VM.k1, false);
  static const ElementDef kTrianglePointIndexList
      //(0066,0023)
      = const ElementDef(
          "TrianglePointIndexList", 0x00660023, "Triangle Point Index List", VR.kOW, VM.k1, false);
  static const ElementDef kEdgePointIndexList
      //(0066,0024)
      = const ElementDef(
          "EdgePointIndexList", 0x00660024, "Edge Point Index List", VR.kOW, VM.k1, false);
  static const ElementDef kVertexPointIndexList
      //(0066,0025)
      = const ElementDef(
          "VertexPointIndexList", 0x00660025, "Vertex Point Index List", VR.kOW, VM.k1, false);
  static const ElementDef kTriangleStripSequence
      //(0066,0026)
      = const ElementDef(
          "TriangleStripSequence", 0x00660026, "Triangle Strip Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTriangleFanSequence
      //(0066,0027)
      = const ElementDef(
          "TriangleFanSequence", 0x00660027, "Triangle Fan Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLineSequence
      //(0066,0028)
      = const ElementDef("LineSequence", 0x00660028, "Line Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPrimitivePointIndexList
      //(0066,0029)
      = const ElementDef("PrimitivePointIndexList", 0x00660029, "Primitive Point Index List", VR.kOW,
          VM.k1, false);
  static const ElementDef kSurfaceCount
      //(0066,002A)
      = const ElementDef("SurfaceCount", 0x0066002A, "Surface Count", VR.kUL, VM.k1, false);
  static const ElementDef kReferencedSurfaceSequence
      //(0066,002B)
      = const ElementDef("ReferencedSurfaceSequence", 0x0066002B, "Referenced Surface Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSurfaceNumber
      //(0066,002C)
      = const ElementDef(
          "ReferencedSurfaceNumber", 0x0066002C, "Referenced Surface Number", VR.kUL, VM.k1, false);
  static const ElementDef kSegmentSurfaceGenerationAlgorithmIdentificationSequence
      //(0066,002D)
      = const ElementDef("SegmentSurfaceGenerationAlgorithmIdentificationSequence", 0x0066002D,
          "Segment Surface Generation Algorithm Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSegmentSurfaceSourceInstanceSequence
      //(0066,002E)
      = const ElementDef("SegmentSurfaceSourceInstanceSequence", 0x0066002E,
          "Segment Surface Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAlgorithmFamilyCodeSequence
      //(0066,002F)
      = const ElementDef("AlgorithmFamilyCodeSequence", 0x0066002F, "Algorithm Family Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAlgorithmNameCodeSequence
      //(0066,0030)
      = const ElementDef("AlgorithmNameCodeSequence", 0x00660030, "Algorithm Name Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAlgorithmVersion
      //(0066,0031)
      = const ElementDef("AlgorithmVersion", 0x00660031, "Algorithm Version", VR.kLO, VM.k1, false);
  static const ElementDef kAlgorithmParameters
      //(0066,0032)
      = const ElementDef(
          "AlgorithmParameters", 0x00660032, "Algorithm Parameters", VR.kLT, VM.k1, false);
  static const ElementDef kFacetSequence
      //(0066,0034)
      = const ElementDef("FacetSequence", 0x00660034, "Facet Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSurfaceProcessingAlgorithmIdentificationSequence
      //(0066,0035)
      = const ElementDef("SurfaceProcessingAlgorithmIdentificationSequence", 0x00660035,
          "Surface Processing Algorithm Identification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAlgorithmName
      //(0066,0036)
      = const ElementDef("AlgorithmName", 0x00660036, "Algorithm Name", VR.kLO, VM.k1, false);
  static const ElementDef kRecommendedPointRadius
      //(0066,0037)
      = const ElementDef(
          "RecommendedPointRadius", 0x00660037, "Recommended Point Radius", VR.kFL, VM.k1, false);
  static const ElementDef kRecommendedLineThickness
      //(0066,0038)
      = const ElementDef("RecommendedLineThickness", 0x00660038, "Recommended Line Thickness", VR.kFL,
          VM.k1, false);
  static const ElementDef kImplantSize
      //(0068,6210)
      = const ElementDef("ImplantSize", 0x00686210, "Implant Size", VR.kLO, VM.k1, false);
  static const ElementDef kImplantTemplateVersion
      //(0068,6221)
      = const ElementDef(
          "ImplantTemplateVersion", 0x00686221, "Implant Template Version", VR.kLO, VM.k1, false);
  static const ElementDef kReplacedImplantTemplateSequence
      //(0068,6222)
      = const ElementDef("ReplacedImplantTemplateSequence", 0x00686222,
          "Replaced Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantType
      //(0068,6223)
      = const ElementDef("ImplantType", 0x00686223, "Implant Type", VR.kCS, VM.k1, false);
  static const ElementDef kDerivationImplantTemplateSequence
      //(0068,6224)
      = const ElementDef("DerivationImplantTemplateSequence", 0x00686224,
          "Derivation Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOriginalImplantTemplateSequence
      //(0068,6225)
      = const ElementDef("OriginalImplantTemplateSequence", 0x00686225,
          "Original Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kEffectiveDateTime
      //(0068,6226)
      = const ElementDef("EffectiveDateTime", 0x00686226, "Effective DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kImplantTargetAnatomySequence
      //(0068,6230)
      = const ElementDef("ImplantTargetAnatomySequence", 0x00686230, "Implant Target Anatomy Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kInformationFromManufacturerSequence
      //(0068,6260)
      = const ElementDef("InformationFromManufacturerSequence", 0x00686260,
          "Information From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNotificationFromManufacturerSequence
      //(0068,6265)
      = const ElementDef("NotificationFromManufacturerSequence", 0x00686265,
          "Notification From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kInformationIssueDateTime
      //(0068,6270)
      = const ElementDef("InformationIssueDateTime", 0x00686270, "Information Issue DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kInformationSummary
      //(0068,6280)
      =
      const ElementDef("InformationSummary", 0x00686280, "Information Summary", VR.kST, VM.k1, false);
  static const ElementDef kImplantRegulatoryDisapprovalCodeSequence
      //(0068,62A0)
      = const ElementDef("ImplantRegulatoryDisapprovalCodeSequence", 0x006862A0,
          "Implant Regulatory Disapproval Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOverallTemplateSpatialTolerance
      //(0068,62A5)
      = const ElementDef("OverallTemplateSpatialTolerance", 0x006862A5,
          "Overall Template Spatial Tolerance", VR.kFD, VM.k1, false);
  static const ElementDef kHPGLDocumentSequence
      //(0068,62C0)
      = const ElementDef(
          "HPGLDocumentSequence", 0x006862C0, "HPGL Document Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHPGLDocumentID
      //(0068,62D0)
      = const ElementDef("HPGLDocumentID", 0x006862D0, "HPGL Document ID", VR.kUS, VM.k1, false);
  static const ElementDef kHPGLDocumentLabel
      //(0068,62D5)
      = const ElementDef("HPGLDocumentLabel", 0x006862D5, "HPGL Document Label", VR.kLO, VM.k1, false);
  static const ElementDef kViewOrientationCodeSequence
      //(0068,62E0)
      = const ElementDef("ViewOrientationCodeSequence", 0x006862E0, "View Orientation Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kViewOrientationModifier
      //(0068,62F0)
      = const ElementDef(
          "ViewOrientationModifier", 0x006862F0, "View Orientation Modifier", VR.kFD, VM.k9, false);
  static const ElementDef kHPGLDocumentScaling
      //(0068,62F2)
      = const ElementDef(
          "HPGLDocumentScaling", 0x006862F2, "HPGL Document Scaling", VR.kFD, VM.k1, false);
  static const ElementDef kHPGLDocument
      //(0068,6300)
      = const ElementDef("HPGLDocument", 0x00686300, "HPGL Document", VR.kOB, VM.k1, false);
  static const ElementDef kHPGLContourPenNumber
      //(0068,6310)
      = const ElementDef(
          "HPGLContourPenNumber", 0x00686310, "HPGL Contour Pen Number", VR.kUS, VM.k1, false);
  static const ElementDef kHPGLPenSequence
      //(0068,6320)
      = const ElementDef("HPGLPenSequence", 0x00686320, "HPGL Pen Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHPGLPenNumber
      //(0068,6330)
      = const ElementDef("HPGLPenNumber", 0x00686330, "HPGL Pen Number", VR.kUS, VM.k1, false);
  static const ElementDef kHPGLPenLabel
      //(0068,6340)
      = const ElementDef("HPGLPenLabel", 0x00686340, "HPGL Pen Label", VR.kLO, VM.k1, false);
  static const ElementDef kHPGLPenDescription
      //(0068,6345)
      =
      const ElementDef("HPGLPenDescription", 0x00686345, "HPGL Pen Description", VR.kST, VM.k1, false);
  static const ElementDef kRecommendedRotationPoint
      //(0068,6346)
      = const ElementDef("RecommendedRotationPoint", 0x00686346, "Recommended Rotation Point", VR.kFD,
          VM.k2, false);
  static const ElementDef kBoundingRectangle
      //(0068,6347)
      = const ElementDef("BoundingRectangle", 0x00686347, "Bounding Rectangle", VR.kFD, VM.k4, false);
  static const ElementDef kImplantTemplate3DModelSurfaceNumber
      //(0068,6350)
      = const ElementDef("ImplantTemplate3DModelSurfaceNumber", 0x00686350,
          "Implant Template 3D Model Surface Number", VR.kUS, VM.k1_n, false);
  static const ElementDef kSurfaceModelDescriptionSequence
      //(0068,6360)
      = const ElementDef("SurfaceModelDescriptionSequence", 0x00686360,
          "Surface Model Description Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSurfaceModelLabel
      //(0068,6380)
      = const ElementDef("SurfaceModelLabel", 0x00686380, "Surface Model Label", VR.kLO, VM.k1, false);
  static const ElementDef kSurfaceModelScalingFactor
      //(0068,6390)
      = const ElementDef("SurfaceModelScalingFactor", 0x00686390, "Surface Model Scaling Factor",
          VR.kFD, VM.k1, false);
  static const ElementDef kMaterialsCodeSequence
      //(0068,63A0)
      = const ElementDef(
          "MaterialsCodeSequence", 0x006863A0, "Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCoatingMaterialsCodeSequence
      //(0068,63A4)
      = const ElementDef("CoatingMaterialsCodeSequence", 0x006863A4, "Coating Materials Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImplantTypeCodeSequence
      //(0068,63A8)
      = const ElementDef("ImplantTypeCodeSequence", 0x006863A8, "Implant Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kFixationMethodCodeSequence
      //(0068,63AC)
      = const ElementDef("FixationMethodCodeSequence", 0x006863AC, "Fixation Method Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMatingFeatureSetsSequence
      //(0068,63B0)
      = const ElementDef("MatingFeatureSetsSequence", 0x006863B0, "Mating Feature Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMatingFeatureSetID
      //(0068,63C0)
      = const ElementDef(
          "MatingFeatureSetID", 0x006863C0, "Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const ElementDef kMatingFeatureSetLabel
      //(0068,63D0)
      = const ElementDef(
          "MatingFeatureSetLabel", 0x006863D0, "Mating Feature Set Label", VR.kLO, VM.k1, false);
  static const ElementDef kMatingFeatureSequence
      //(0068,63E0)
      = const ElementDef(
          "MatingFeatureSequence", 0x006863E0, "Mating Feature Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMatingFeatureID
      //(0068,63F0)
      = const ElementDef("MatingFeatureID", 0x006863F0, "Mating Feature ID", VR.kUS, VM.k1, false);
  static const ElementDef kMatingFeatureDegreeOfFreedomSequence
      //(0068,6400)
      = const ElementDef("MatingFeatureDegreeOfFreedomSequence", 0x00686400,
          "Mating Feature Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDegreeOfFreedomID
      //(0068,6410)
      =
      const ElementDef("DegreeOfFreedomID", 0x00686410, "Degree of Freedom ID", VR.kUS, VM.k1, false);
  static const ElementDef kDegreeOfFreedomType
      //(0068,6420)
      = const ElementDef(
          "DegreeOfFreedomType", 0x00686420, "Degree of Freedom Type", VR.kCS, VM.k1, false);
  static const ElementDef kTwoDMatingFeatureCoordinatesSequence
      //(0068,6430)
      = const ElementDef("TwoDMatingFeatureCoordinatesSequence", 0x00686430,
          "2D Mating Feature Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedHPGLDocumentID
      //(0068,6440)
      = const ElementDef("ReferencedHPGLDocumentID", 0x00686440, "Referenced HPGL Document ID", VR.kUS,
          VM.k1, false);
  static const ElementDef kTwoDMatingPoint
      //(0068,6450)
      = const ElementDef("TwoDMatingPoint", 0x00686450, "2D Mating Point", VR.kFD, VM.k2, false);
  static const ElementDef kTwoDMatingAxes
      //(0068,6460)
      = const ElementDef("TwoDMatingAxes", 0x00686460, "2D Mating Axes", VR.kFD, VM.k4, false);
  static const ElementDef kTwoDDegreeOfFreedomSequence
      //(0068,6470)
      = const ElementDef("TwoDDegreeOfFreedomSequence", 0x00686470, "2D Degree of Freedom Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kThreeDDegreeOfFreedomAxis
      //(0068,6490)
      = const ElementDef("ThreeDDegreeOfFreedomAxis", 0x00686490, "3D Degree of Freedom Axis", VR.kFD,
          VM.k3, false);
  static const ElementDef kRangeOfFreedom
      //(0068,64A0)
      = const ElementDef("RangeOfFreedom", 0x006864A0, "Range of Freedom", VR.kFD, VM.k2, false);
  static const ElementDef kThreeDMatingPoint
      //(0068,64C0)
      = const ElementDef("ThreeDMatingPoint", 0x006864C0, "3D Mating Point", VR.kFD, VM.k3, false);
  static const ElementDef kThreeDMatingAxes
      //(0068,64D0)
      = const ElementDef("ThreeDMatingAxes", 0x006864D0, "3D Mating Axes", VR.kFD, VM.k9, false);
  static const ElementDef kTwoDDegreeOfFreedomAxis
      //(0068,64F0)
      = const ElementDef(
          "TwoDDegreeOfFreedomAxis", 0x006864F0, "2D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const ElementDef kPlanningLandmarkPointSequence
      //(0068,6500)
      = const ElementDef("PlanningLandmarkPointSequence", 0x00686500,
          "Planning Landmark Point Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlanningLandmarkLineSequence
      //(0068,6510)
      = const ElementDef("PlanningLandmarkLineSequence", 0x00686510, "Planning Landmark Line Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPlanningLandmarkPlaneSequence
      //(0068,6520)
      = const ElementDef("PlanningLandmarkPlaneSequence", 0x00686520,
          "Planning Landmark Plane Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPlanningLandmarkID
      //(0068,6530)
      =
      const ElementDef("PlanningLandmarkID", 0x00686530, "Planning Landmark ID", VR.kUS, VM.k1, false);
  static const ElementDef kPlanningLandmarkDescription
      //(0068,6540)
      = const ElementDef("PlanningLandmarkDescription", 0x00686540, "Planning Landmark Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kPlanningLandmarkIdentificationCodeSequence
      //(0068,6545)
      = const ElementDef("PlanningLandmarkIdentificationCodeSequence", 0x00686545,
          "Planning Landmark Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTwoDPointCoordinatesSequence
      //(0068,6550)
      = const ElementDef("TwoDPointCoordinatesSequence", 0x00686550, "2D Point Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTwoDPointCoordinates
      //(0068,6560)
      = const ElementDef(
          "TwoDPointCoordinates", 0x00686560, "2D Point Coordinates", VR.kFD, VM.k2, false);
  static const ElementDef kThreeDPointCoordinates
      //(0068,6590)
      = const ElementDef(
          "ThreeDPointCoordinates", 0x00686590, "3D Point Coordinates", VR.kFD, VM.k3, false);
  static const ElementDef kTwoDLineCoordinatesSequence
      //(0068,65A0)
      = const ElementDef("TwoDLineCoordinatesSequence", 0x006865A0, "2D Line Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTwoDLineCoordinates
      //(0068,65B0)
      =
      const ElementDef("TwoDLineCoordinates", 0x006865B0, "2D Line Coordinates", VR.kFD, VM.k4, false);
  static const ElementDef kThreeDLineCoordinates
      //(0068,65D0)
      = const ElementDef(
          "ThreeDLineCoordinates", 0x006865D0, "3D Line Coordinates", VR.kFD, VM.k6, false);
  static const ElementDef kTwoDPlaneCoordinatesSequence
      //(0068,65E0)
      = const ElementDef("TwoDPlaneCoordinatesSequence", 0x006865E0, "2D Plane Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTwoDPlaneIntersection
      //(0068,65F0)
      = const ElementDef(
          "TwoDPlaneIntersection", 0x006865F0, "2D Plane Intersection", VR.kFD, VM.k4, false);
  static const ElementDef kThreeDPlaneOrigin
      //(0068,6610)
      = const ElementDef("ThreeDPlaneOrigin", 0x00686610, "3D Plane Origin", VR.kFD, VM.k3, false);
  static const ElementDef kThreeDPlaneNormal
      //(0068,6620)
      = const ElementDef("ThreeDPlaneNormal", 0x00686620, "3D Plane Normal", VR.kFD, VM.k3, false);
  static const ElementDef kGraphicAnnotationSequence
      //(0070,0001)
      = const ElementDef("GraphicAnnotationSequence", 0x00700001, "Graphic Annotation Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicLayer
      //(0070,0002)
      = const ElementDef("GraphicLayer", 0x00700002, "Graphic Layer", VR.kCS, VM.k1, false);
  static const ElementDef kBoundingBoxAnnotationUnits
      //(0070,0003)
      = const ElementDef("BoundingBoxAnnotationUnits", 0x00700003, "Bounding Box Annotation Units",
          VR.kCS, VM.k1, false);
  static const ElementDef kAnchorPointAnnotationUnits
      //(0070,0004)
      = const ElementDef("AnchorPointAnnotationUnits", 0x00700004, "Anchor Point Annotation Units",
          VR.kCS, VM.k1, false);
  static const ElementDef kGraphicAnnotationUnits
      //(0070,0005)
      = const ElementDef(
          "GraphicAnnotationUnits", 0x00700005, "Graphic Annotation Units", VR.kCS, VM.k1, false);
  static const ElementDef kUnformattedTextValue
      //(0070,0006)
      = const ElementDef(
          "UnformattedTextValue", 0x00700006, "Unformatted Text Value", VR.kST, VM.k1, false);
  static const ElementDef kTextObjectSequence
      //(0070,0008)
      =
      const ElementDef("TextObjectSequence", 0x00700008, "Text Object Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicObjectSequence
      //(0070,0009)
      = const ElementDef(
          "GraphicObjectSequence", 0x00700009, "Graphic Object Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBoundingBoxTopLeftHandCorner
      //(0070,0010)
      = const ElementDef("BoundingBoxTopLeftHandCorner", 0x00700010,
          "Bounding Box Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const ElementDef kBoundingBoxBottomRightHandCorner
      //(0070,0011)
      = const ElementDef("BoundingBoxBottomRightHandCorner", 0x00700011,
          "Bounding Box Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const ElementDef kBoundingBoxTextHorizontalJustification
      //(0070,0012)
      = const ElementDef("BoundingBoxTextHorizontalJustification", 0x00700012,
          "Bounding Box Text Horizontal Justification", VR.kCS, VM.k1, false);
  static const ElementDef kAnchorPoint
      //(0070,0014)
      = const ElementDef("AnchorPoint", 0x00700014, "Anchor Point", VR.kFL, VM.k2, false);
  static const ElementDef kAnchorPointVisibility
      //(0070,0015)
      = const ElementDef(
          "AnchorPointVisibility", 0x00700015, "Anchor Point Visibility", VR.kCS, VM.k1, false);
  static const ElementDef kGraphicDimensions
      //(0070,0020)
      = const ElementDef("GraphicDimensions", 0x00700020, "Graphic Dimensions", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfGraphicPoints
      //(0070,0021)
      = const ElementDef(
          "NumberOfGraphicPoints", 0x00700021, "Number of Graphic Points", VR.kUS, VM.k1, false);
  static const ElementDef kGraphicData
      //(0070,0022)
      = const ElementDef("GraphicData", 0x00700022, "Graphic Data", VR.kFL, VM.k2_n, false);
  static const ElementDef kGraphicType
      //(0070,0023)
      = const ElementDef("GraphicType", 0x00700023, "Graphic Type", VR.kCS, VM.k1, false);
  static const ElementDef kGraphicFilled
      //(0070,0024)
      = const ElementDef("GraphicFilled", 0x00700024, "Graphic Filled", VR.kCS, VM.k1, false);
  static const ElementDef kImageRotationRetired
      //(0070,0040)
      = const ElementDef(
          "ImageRotationRetired", 0x00700040, "Image Rotation (Retired)", VR.kIS, VM.k1, true);
  static const ElementDef kImageHorizontalFlip
      //(0070,0041)
      = const ElementDef(
          "ImageHorizontalFlip", 0x00700041, "Image Horizontal Flip", VR.kCS, VM.k1, false);
  static const ElementDef kImageRotation
      //(0070,0042)
      = const ElementDef("ImageRotation", 0x00700042, "Image Rotation", VR.kUS, VM.k1, false);
  static const ElementDef kDisplayedAreaTopLeftHandCornerTrial
      //(0070,0050)
      = const ElementDef("DisplayedAreaTopLeftHandCornerTrial", 0x00700050,
          "Displayed Area Top Left Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const ElementDef kDisplayedAreaBottomRightHandCornerTrial
      //(0070,0051)
      = const ElementDef("DisplayedAreaBottomRightHandCornerTrial", 0x00700051,
          "Displayed Area Bottom Right Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const ElementDef kDisplayedAreaTopLeftHandCorner
      //(0070,0052)
      = const ElementDef("DisplayedAreaTopLeftHandCorner", 0x00700052,
          "Displayed Area Top Left Hand Corner", VR.kSL, VM.k2, false);
  static const ElementDef kDisplayedAreaBottomRightHandCorner
      //(0070,0053)
      = const ElementDef("DisplayedAreaBottomRightHandCorner", 0x00700053,
          "Displayed Area Bottom Right Hand Corner", VR.kSL, VM.k2, false);
  static const ElementDef kDisplayedAreaSelectionSequence
      //(0070,005A)
      = const ElementDef("DisplayedAreaSelectionSequence", 0x0070005A,
          "Displayed Area Selection Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicLayerSequence
      //(0070,0060)
      = const ElementDef(
          "GraphicLayerSequence", 0x00700060, "Graphic Layer Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicLayerOrder
      //(0070,0062)
      = const ElementDef("GraphicLayerOrder", 0x00700062, "Graphic Layer Order", VR.kIS, VM.k1, false);
  static const ElementDef kGraphicLayerRecommendedDisplayGrayscaleValue
      //(0070,0066)
      = const ElementDef("GraphicLayerRecommendedDisplayGrayscaleValue", 0x00700066,
          "Graphic Layer Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const ElementDef kGraphicLayerRecommendedDisplayRGBValue
      //(0070,0067)
      = const ElementDef("GraphicLayerRecommendedDisplayRGBValue", 0x00700067,
          "Graphic Layer Recommended Display RGB Value", VR.kUS, VM.k3, true);
  static const ElementDef kGraphicLayerDescription
      //(0070,0068)
      = const ElementDef(
          "GraphicLayerDescription", 0x00700068, "Graphic Layer Description", VR.kLO, VM.k1, false);
  static const ElementDef kContentLabel
      //(0070,0080)
      = const ElementDef("ContentLabel", 0x00700080, "Content Label", VR.kCS, VM.k1, false);
  static const ElementDef kContentDescription
      //(0070,0081)
      =
      const ElementDef("ContentDescription", 0x00700081, "Content Description", VR.kLO, VM.k1, false);
  static const ElementDef kPresentationCreationDate
      //(0070,0082)
      = const ElementDef("PresentationCreationDate", 0x00700082, "Presentation Creation Date", VR.kDA,
          VM.k1, false);
  static const ElementDef kPresentationCreationTime
      //(0070,0083)
      = const ElementDef("PresentationCreationTime", 0x00700083, "Presentation Creation Time", VR.kTM,
          VM.k1, false);
  static const ElementDef kContentCreatorName
      //(0070,0084)
      = const ElementDef(
          "ContentCreatorName", 0x00700084, "Content Creator's Name", VR.kPN, VM.k1, false);
  static const ElementDef kContentCreatorIdentificationCodeSequence
      //(0070,0086)
      = const ElementDef("ContentCreatorIdentificationCodeSequence", 0x00700086,
          "Content Creator's Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAlternateContentDescriptionSequence
      //(0070,0087)
      = const ElementDef("AlternateContentDescriptionSequence", 0x00700087,
          "Alternate Content Description Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPresentationSizeMode
      //(0070,0100)
      = const ElementDef(
          "PresentationSizeMode", 0x00700100, "Presentation Size Mode", VR.kCS, VM.k1, false);
  static const ElementDef kPresentationPixelSpacing
      //(0070,0101)
      = const ElementDef("PresentationPixelSpacing", 0x00700101, "Presentation Pixel Spacing", VR.kDS,
          VM.k2, false);
  static const ElementDef kPresentationPixelAspectRatio
      //(0070,0102)
      = const ElementDef("PresentationPixelAspectRatio", 0x00700102, "Presentation Pixel Aspect Ratio",
          VR.kIS, VM.k2, false);
  static const ElementDef kPresentationPixelMagnificationRatio
      //(0070,0103)
      = const ElementDef("PresentationPixelMagnificationRatio", 0x00700103,
          "Presentation Pixel Magnification Ratio", VR.kFL, VM.k1, false);
  static const ElementDef kGraphicGroupLabel
      //(0070,0207)
      = const ElementDef("GraphicGroupLabel", 0x00700207, "Graphic Group Label", VR.kLO, VM.k1, false);
  static const ElementDef kGraphicGroupDescription
      //(0070,0208)
      = const ElementDef(
          "GraphicGroupDescription", 0x00700208, "Graphic Group Description", VR.kST, VM.k1, false);
  static const ElementDef kCompoundGraphicSequence
      //(0070,0209)
      = const ElementDef(
          "CompoundGraphicSequence", 0x00700209, "Compound Graphic Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCompoundGraphicInstanceID
      //(0070,0226)
      = const ElementDef("CompoundGraphicInstanceID", 0x00700226, "Compound Graphic Instance ID",
          VR.kUL, VM.k1, false);
  static const ElementDef kFontName
      //(0070,0227)
      = const ElementDef("FontName", 0x00700227, "Font Name", VR.kLO, VM.k1, false);
  static const ElementDef kFontNameType
      //(0070,0228)
      = const ElementDef("FontNameType", 0x00700228, "Font Name Type", VR.kCS, VM.k1, false);
  static const ElementDef kCSSFontName
      //(0070,0229)
      = const ElementDef("CSSFontName", 0x00700229, "CSS Font Name", VR.kLO, VM.k1, false);
  static const ElementDef kRotationAngle
      //(0070,0230)
      = const ElementDef("RotationAngle", 0x00700230, "Rotation Angle", VR.kFD, VM.k1, false);
  static const ElementDef kTextStyleSequence
      //(0070,0231)
      = const ElementDef("TextStyleSequence", 0x00700231, "Text Style Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLineStyleSequence
      //(0070,0232)
      = const ElementDef("LineStyleSequence", 0x00700232, "Line Style Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFillStyleSequence
      //(0070,0233)
      = const ElementDef("FillStyleSequence", 0x00700233, "Fill Style Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicGroupSequence
      //(0070,0234)
      = const ElementDef(
          "GraphicGroupSequence", 0x00700234, "Graphic Group Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTextColorCIELabValue
      //(0070,0241)
      = const ElementDef(
          "TextColorCIELabValue", 0x00700241, "Text Color CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kHorizontalAlignment
      //(0070,0242)
      = const ElementDef(
          "HorizontalAlignment", 0x00700242, "Horizontal Alignment", VR.kCS, VM.k1, false);
  static const ElementDef kVerticalAlignment
      //(0070,0243)
      = const ElementDef("VerticalAlignment", 0x00700243, "Vertical Alignment", VR.kCS, VM.k1, false);
  static const ElementDef kShadowStyle
      //(0070,0244)
      = const ElementDef("ShadowStyle", 0x00700244, "Shadow Style", VR.kCS, VM.k1, false);
  static const ElementDef kShadowOffsetX
      //(0070,0245)
      = const ElementDef("ShadowOffsetX", 0x00700245, "Shadow Offset X", VR.kFL, VM.k1, false);
  static const ElementDef kShadowOffsetY
      //(0070,0246)
      = const ElementDef("ShadowOffsetY", 0x00700246, "Shadow Offset Y", VR.kFL, VM.k1, false);
  static const ElementDef kShadowColorCIELabValue
      //(0070,0247)
      = const ElementDef(
          "ShadowColorCIELabValue", 0x00700247, "Shadow Color CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kUnderlined
      //(0070,0248)
      = const ElementDef("Underlined", 0x00700248, "Underlined", VR.kCS, VM.k1, false);
  static const ElementDef kBold
      //(0070,0249)
      = const ElementDef("Bold", 0x00700249, "Bold", VR.kCS, VM.k1, false);
  static const ElementDef kItalic
      //(0070,0250)
      = const ElementDef("Italic", 0x00700250, "Italic", VR.kCS, VM.k1, false);
  static const ElementDef kPatternOnColorCIELabValue
      //(0070,0251)
      = const ElementDef("PatternOnColorCIELabValue", 0x00700251, "Pattern On Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const ElementDef kPatternOffColorCIELabValue
      //(0070,0252)
      = const ElementDef("PatternOffColorCIELabValue", 0x00700252, "Pattern Off Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const ElementDef kLineThickness
      //(0070,0253)
      = const ElementDef("LineThickness", 0x00700253, "Line Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kLineDashingStyle
      //(0070,0254)
      = const ElementDef("LineDashingStyle", 0x00700254, "Line Dashing Style", VR.kCS, VM.k1, false);
  static const ElementDef kLinePattern
      //(0070,0255)
      = const ElementDef("LinePattern", 0x00700255, "Line Pattern", VR.kUL, VM.k1, false);
  static const ElementDef kFillPattern
      //(0070,0256)
      = const ElementDef("FillPattern", 0x00700256, "Fill Pattern", VR.kOB, VM.k1, false);
  static const ElementDef kFillMode
      //(0070,0257)
      = const ElementDef("FillMode", 0x00700257, "Fill Mode", VR.kCS, VM.k1, false);
  static const ElementDef kShadowOpacity
      //(0070,0258)
      = const ElementDef("ShadowOpacity", 0x00700258, "Shadow Opacity", VR.kFL, VM.k1, false);
  static const ElementDef kGapLength
      //(0070,0261)
      = const ElementDef("GapLength", 0x00700261, "Gap Length", VR.kFL, VM.k1, false);
  static const ElementDef kDiameterOfVisibility
      //(0070,0262)
      = const ElementDef(
          "DiameterOfVisibility", 0x00700262, "Diameter of Visibility", VR.kFL, VM.k1, false);
  static const ElementDef kRotationPoint
      //(0070,0273)
      = const ElementDef("RotationPoint", 0x00700273, "Rotation Point", VR.kFL, VM.k2, false);
  static const ElementDef kTickAlignment
      //(0070,0274)
      = const ElementDef("TickAlignment", 0x00700274, "Tick Alignment", VR.kCS, VM.k1, false);
  static const ElementDef kShowTickLabel
      //(0070,0278)
      = const ElementDef("ShowTickLabel", 0x00700278, "Show Tick Label", VR.kCS, VM.k1, false);
  static const ElementDef kTickLabelAlignment
      //(0070,0279)
      =
      const ElementDef("TickLabelAlignment", 0x00700279, "Tick Label Alignment", VR.kCS, VM.k1, false);
  static const ElementDef kCompoundGraphicUnits
      //(0070,0282)
      = const ElementDef(
          "CompoundGraphicUnits", 0x00700282, "Compound Graphic Units", VR.kCS, VM.k1, false);
  static const ElementDef kPatternOnOpacity
      //(0070,0284)
      = const ElementDef("PatternOnOpacity", 0x00700284, "Pattern On Opacity", VR.kFL, VM.k1, false);
  static const ElementDef kPatternOffOpacity
      //(0070,0285)
      = const ElementDef("PatternOffOpacity", 0x00700285, "Pattern Off Opacity", VR.kFL, VM.k1, false);
  static const ElementDef kMajorTicksSequence
      //(0070,0287)
      =
      const ElementDef("MajorTicksSequence", 0x00700287, "Major Ticks Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTickPosition
      //(0070,0288)
      = const ElementDef("TickPosition", 0x00700288, "Tick Position", VR.kFL, VM.k1, false);
  static const ElementDef kTickLabel
      //(0070,0289)
      = const ElementDef("TickLabel", 0x00700289, "Tick Label", VR.kSH, VM.k1, false);
  static const ElementDef kCompoundGraphicType
      //(0070,0294)
      = const ElementDef(
          "CompoundGraphicType", 0x00700294, "Compound Graphic Type", VR.kCS, VM.k1, false);
  static const ElementDef kGraphicGroupID
      //(0070,0295)
      = const ElementDef("GraphicGroupID", 0x00700295, "Graphic Group ID", VR.kUL, VM.k1, false);
  static const ElementDef kShapeType
      //(0070,0306)
      = const ElementDef("ShapeType", 0x00700306, "Shape Type", VR.kCS, VM.k1, false);
  static const ElementDef kRegistrationSequence
      //(0070,0308)
      = const ElementDef(
          "RegistrationSequence", 0x00700308, "Registration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMatrixRegistrationSequence
      //(0070,0309)
      = const ElementDef("MatrixRegistrationSequence", 0x00700309, "Matrix Registration Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kMatrixSequence
      //(0070,030A)
      = const ElementDef("MatrixSequence", 0x0070030A, "Matrix Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFrameOfReferenceTransformationMatrixType
      //(0070,030C)
      = const ElementDef("FrameOfReferenceTransformationMatrixType", 0x0070030C,
          "Frame of Reference Transformation Matrix Type", VR.kCS, VM.k1, false);
  static const ElementDef kRegistrationTypeCodeSequence
      //(0070,030D)
      = const ElementDef("RegistrationTypeCodeSequence", 0x0070030D, "Registration Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kFiducialDescription
      //(0070,030F)
      = const ElementDef(
          "FiducialDescription", 0x0070030F, "Fiducial Description", VR.kST, VM.k1, false);
  static const ElementDef kFiducialIdentifier
      //(0070,0310)
      =
      const ElementDef("FiducialIdentifier", 0x00700310, "Fiducial Identifier", VR.kSH, VM.k1, false);
  static const ElementDef kFiducialIdentifierCodeSequence
      //(0070,0311)
      = const ElementDef("FiducialIdentifierCodeSequence", 0x00700311,
          "Fiducial Identifier Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContourUncertaintyRadius
      //(0070,0312)
      = const ElementDef("ContourUncertaintyRadius", 0x00700312, "Contour Uncertainty Radius", VR.kFD,
          VM.k1, false);
  static const ElementDef kUsedFiducialsSequence
      //(0070,0314)
      = const ElementDef(
          "UsedFiducialsSequence", 0x00700314, "Used Fiducials Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicCoordinatesDataSequence
      //(0070,0318)
      = const ElementDef("GraphicCoordinatesDataSequence", 0x00700318,
          "Graphic Coordinates Data Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFiducialUID
      //(0070,031A)
      = const ElementDef("FiducialUID", 0x0070031A, "Fiducial UID", VR.kUI, VM.k1, false);
  static const ElementDef kFiducialSetSequence
      //(0070,031C)
      = const ElementDef(
          "FiducialSetSequence", 0x0070031C, "Fiducial Set Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFiducialSequence
      //(0070,031E)
      = const ElementDef("FiducialSequence", 0x0070031E, "Fiducial Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGraphicLayerRecommendedDisplayCIELabValue
      //(0070,0401)
      = const ElementDef("GraphicLayerRecommendedDisplayCIELabValue", 0x00700401,
          "Graphic Layer Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kBlendingSequence
      //(0070,0402)
      = const ElementDef("BlendingSequence", 0x00700402, "Blending Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRelativeOpacity
      //(0070,0403)
      = const ElementDef("RelativeOpacity", 0x00700403, "Relative Opacity", VR.kFL, VM.k1, false);
  static const ElementDef kReferencedSpatialRegistrationSequence
      //(0070,0404)
      = const ElementDef("ReferencedSpatialRegistrationSequence", 0x00700404,
          "Referenced Spatial Registration Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBlendingPosition
      //(0070,0405)
      = const ElementDef("BlendingPosition", 0x00700405, "Blending Position", VR.kCS, VM.k1, false);
  static const ElementDef kHangingProtocolName
      //(0072,0002)
      = const ElementDef(
          "HangingProtocolName", 0x00720002, "Hanging Protocol Name", VR.kSH, VM.k1, false);
  static const ElementDef kHangingProtocolDescription
      //(0072,0004)
      = const ElementDef("HangingProtocolDescription", 0x00720004, "Hanging Protocol Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kHangingProtocolLevel
      //(0072,0006)
      = const ElementDef(
          "HangingProtocolLevel", 0x00720006, "Hanging Protocol Level", VR.kCS, VM.k1, false);
  static const ElementDef kHangingProtocolCreator
      //(0072,0008)
      = const ElementDef(
          "HangingProtocolCreator", 0x00720008, "Hanging Protocol Creator", VR.kLO, VM.k1, false);
  static const ElementDef kHangingProtocolCreationDateTime
      //(0072,000A)
      = const ElementDef("HangingProtocolCreationDateTime", 0x0072000A,
          "Hanging Protocol Creation DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kHangingProtocolDefinitionSequence
      //(0072,000C)
      = const ElementDef("HangingProtocolDefinitionSequence", 0x0072000C,
          "Hanging Protocol Definition Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHangingProtocolUserIdentificationCodeSequence
      //(0072,000E)
      = const ElementDef("HangingProtocolUserIdentificationCodeSequence", 0x0072000E,
          "Hanging Protocol User Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kHangingProtocolUserGroupName
      //(0072,0010)
      = const ElementDef("HangingProtocolUserGroupName", 0x00720010,
          "Hanging Protocol User Group Name", VR.kLO, VM.k1, false);
  static const ElementDef kSourceHangingProtocolSequence
      //(0072,0012)
      = const ElementDef("SourceHangingProtocolSequence", 0x00720012,
          "Source Hanging Protocol Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfPriorsReferenced
      //(0072,0014)
      = const ElementDef("NumberOfPriorsReferenced", 0x00720014, "Number of Priors Referenced", VR.kUS,
          VM.k1, false);
  static const ElementDef kImageSetsSequence
      //(0072,0020)
      = const ElementDef("ImageSetsSequence", 0x00720020, "Image Sets Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImageSetSelectorSequence
      //(0072,0022)
      = const ElementDef("ImageSetSelectorSequence", 0x00720022, "Image Set Selector Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kImageSetSelectorUsageFlag
      //(0072,0024)
      = const ElementDef("ImageSetSelectorUsageFlag", 0x00720024, "Image Set Selector Usage Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kSelectorAttribute
      //(0072,0026)
      = const ElementDef("SelectorAttribute", 0x00720026, "Selector Attribute", VR.kAT, VM.k1, false);
  static const ElementDef kSelectorValueNumber
      //(0072,0028)
      = const ElementDef(
          "SelectorValueNumber", 0x00720028, "Selector Value Number", VR.kUS, VM.k1, false);
  static const ElementDef kTimeBasedImageSetsSequence
      //(0072,0030)
      = const ElementDef("TimeBasedImageSetsSequence", 0x00720030, "Time Based Image Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImageSetNumber
      //(0072,0032)
      = const ElementDef("ImageSetNumber", 0x00720032, "Image Set Number", VR.kUS, VM.k1, false);
  static const ElementDef kImageSetSelectorCategory
      //(0072,0034)
      = const ElementDef("ImageSetSelectorCategory", 0x00720034, "Image Set Selector Category", VR.kCS,
          VM.k1, false);
  static const ElementDef kRelativeTime
      //(0072,0038)
      = const ElementDef("RelativeTime", 0x00720038, "Relative Time", VR.kUS, VM.k2, false);
  static const ElementDef kRelativeTimeUnits
      //(0072,003A)
      = const ElementDef("RelativeTimeUnits", 0x0072003A, "Relative Time Units", VR.kCS, VM.k1, false);
  static const ElementDef kAbstractPriorValue
      //(0072,003C)
      =
      const ElementDef("AbstractPriorValue", 0x0072003C, "Abstract Prior Value", VR.kSS, VM.k2, false);
  static const ElementDef kAbstractPriorCodeSequence
      //(0072,003E)
      = const ElementDef("AbstractPriorCodeSequence", 0x0072003E, "Abstract Prior Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImageSetLabel
      //(0072,0040)
      = const ElementDef("ImageSetLabel", 0x00720040, "Image Set Label", VR.kLO, VM.k1, false);
  static const ElementDef kSelectorAttributeVR
      //(0072,0050)
      = const ElementDef(
          "SelectorAttributeVR", 0x00720050, "Selector Attribute VR", VR.kCS, VM.k1, false);
  static const ElementDef kSelectorSequencePointer
      //(0072,0052)
      = const ElementDef("SelectorSequencePointer", 0x00720052, "Selector Sequence Pointer", VR.kAT,
          VM.k1_n, false);
  static const ElementDef kSelectorSequencePointerPrivateCreator
      //(0072,0054)
      = const ElementDef("SelectorSequencePointerPrivateCreator", 0x00720054,
          "Selector Sequence Pointer Private Creator", VR.kLO, VM.k1_n, false);
  static const ElementDef kSelectorAttributePrivateCreator
      //(0072,0056)
      = const ElementDef("SelectorAttributePrivateCreator", 0x00720056,
          "Selector Attribute Private Creator", VR.kLO, VM.k1, false);
  static const ElementDef kSelectorATValue
      //(0072,0060)
      = const ElementDef("SelectorATValue", 0x00720060, "Selector AT Value", VR.kAT, VM.k1_n, false);
  static const ElementDef kSelectorCSValue
      //(0072,0062)
      = const ElementDef("SelectorCSValue", 0x00720062, "Selector CS Value", VR.kCS, VM.k1_n, false);
  static const ElementDef kSelectorISValue
      //(0072,0064)
      = const ElementDef("SelectorISValue", 0x00720064, "Selector IS Value", VR.kIS, VM.k1_n, false);
  static const ElementDef kSelectorLOValue
      //(0072,0066)
      = const ElementDef("SelectorLOValue", 0x00720066, "Selector LO Value", VR.kLO, VM.k1_n, false);
  static const ElementDef kSelectorLTValue
      //(0072,0068)
      = const ElementDef("SelectorLTValue", 0x00720068, "Selector LT Value", VR.kLT, VM.k1, false);
  static const ElementDef kSelectorPNValue
      //(0072,006A)
      = const ElementDef("SelectorPNValue", 0x0072006A, "Selector PN Value", VR.kPN, VM.k1_n, false);
  static const ElementDef kSelectorSHValue
      //(0072,006C)
      = const ElementDef("SelectorSHValue", 0x0072006C, "Selector SH Value", VR.kSH, VM.k1_n, false);
  static const ElementDef kSelectorSTValue
      //(0072,006E)
      = const ElementDef("SelectorSTValue", 0x0072006E, "Selector ST Value", VR.kST, VM.k1, false);
  static const ElementDef kSelectorUTValue
      //(0072,0070)
      = const ElementDef("SelectorUTValue", 0x00720070, "Selector UT Value", VR.kUT, VM.k1, false);
  static const ElementDef kSelectorDSValue
      //(0072,0072)
      = const ElementDef("SelectorDSValue", 0x00720072, "Selector DS Value", VR.kDS, VM.k1_n, false);
  static const ElementDef kSelectorFDValue
      //(0072,0074)
      = const ElementDef("SelectorFDValue", 0x00720074, "Selector FD Value", VR.kFD, VM.k1_n, false);
  static const ElementDef kSelectorFLValue
      //(0072,0076)
      = const ElementDef("SelectorFLValue", 0x00720076, "Selector FL Value", VR.kFL, VM.k1_n, false);
  static const ElementDef kSelectorULValue
      //(0072,0078)
      = const ElementDef("SelectorULValue", 0x00720078, "Selector UL Value", VR.kUL, VM.k1_n, false);
  static const ElementDef kSelectorUSValue
      //(0072,007A)
      = const ElementDef("SelectorUSValue", 0x0072007A, "Selector US Value", VR.kUS, VM.k1_n, false);
  static const ElementDef kSelectorSLValue
      //(0072,007C)
      = const ElementDef("SelectorSLValue", 0x0072007C, "Selector SL Value", VR.kSL, VM.k1_n, false);
  static const ElementDef kSelectorSSValue
      //(0072,007E)
      = const ElementDef("SelectorSSValue", 0x0072007E, "Selector SS Value", VR.kSS, VM.k1_n, false);
  static const ElementDef kSelectorCodeSequenceValue
      //(0072,0080)
      = const ElementDef("SelectorCodeSequenceValue", 0x00720080, "Selector Code Sequence Value",
          VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfScreens
      //(0072,0100)
      = const ElementDef("NumberOfScreens", 0x00720100, "Number of Screens", VR.kUS, VM.k1, false);
  static const ElementDef kNominalScreenDefinitionSequence
      //(0072,0102)
      = const ElementDef("NominalScreenDefinitionSequence", 0x00720102,
          "Nominal Screen Definition Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kNumberOfVerticalPixels
      //(0072,0104)
      = const ElementDef(
          "NumberOfVerticalPixels", 0x00720104, "Number of Vertical Pixels", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfHorizontalPixels
      //(0072,0106)
      = const ElementDef("NumberOfHorizontalPixels", 0x00720106, "Number of Horizontal Pixels", VR.kUS,
          VM.k1, false);
  static const ElementDef kDisplayEnvironmentSpatialPosition
      //(0072,0108)
      = const ElementDef("DisplayEnvironmentSpatialPosition", 0x00720108,
          "Display Environment Spatial Position", VR.kFD, VM.k4, false);
  static const ElementDef kScreenMinimumGrayscaleBitDepth
      //(0072,010A)
      = const ElementDef("ScreenMinimumGrayscaleBitDepth", 0x0072010A,
          "Screen Minimum Grayscale Bit Depth", VR.kUS, VM.k1, false);
  static const ElementDef kScreenMinimumColorBitDepth
      //(0072,010C)
      = const ElementDef("ScreenMinimumColorBitDepth", 0x0072010C, "Screen Minimum Color Bit Depth",
          VR.kUS, VM.k1, false);
  static const ElementDef kApplicationMaximumRepaintTime
      //(0072,010E)
      = const ElementDef("ApplicationMaximumRepaintTime", 0x0072010E,
          "Application Maximum Repaint Time", VR.kUS, VM.k1, false);
  static const ElementDef kDisplaySetsSequence
      //(0072,0200)
      = const ElementDef(
          "DisplaySetsSequence", 0x00720200, "Display Sets Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDisplaySetNumber
      //(0072,0202)
      = const ElementDef("DisplaySetNumber", 0x00720202, "Display Set Number", VR.kUS, VM.k1, false);
  static const ElementDef kDisplaySetLabel
      //(0072,0203)
      = const ElementDef("DisplaySetLabel", 0x00720203, "Display Set Label", VR.kLO, VM.k1, false);
  static const ElementDef kDisplaySetPresentationGroup
      //(0072,0204)
      = const ElementDef("DisplaySetPresentationGroup", 0x00720204, "Display Set Presentation Group",
          VR.kUS, VM.k1, false);
  static const ElementDef kDisplaySetPresentationGroupDescription
      //(0072,0206)
      = const ElementDef("DisplaySetPresentationGroupDescription", 0x00720206,
          "Display Set Presentation Group Description", VR.kLO, VM.k1, false);
  static const ElementDef kPartialDataDisplayHandling
      //(0072,0208)
      = const ElementDef("PartialDataDisplayHandling", 0x00720208, "Partial Data Display Handling",
          VR.kCS, VM.k1, false);
  static const ElementDef kSynchronizedScrollingSequence
      //(0072,0210)
      = const ElementDef("SynchronizedScrollingSequence", 0x00720210,
          "Synchronized Scrolling Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDisplaySetScrollingGroup
      //(0072,0212)
      = const ElementDef("DisplaySetScrollingGroup", 0x00720212, "Display Set Scrolling Group", VR.kUS,
          VM.k2_n, false);
  static const ElementDef kNavigationIndicatorSequence
      //(0072,0214)
      = const ElementDef("NavigationIndicatorSequence", 0x00720214, "Navigation Indicator Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kNavigationDisplaySet
      //(0072,0216)
      = const ElementDef(
          "NavigationDisplaySet", 0x00720216, "Navigation Display Set", VR.kUS, VM.k1, false);
  static const ElementDef kReferenceDisplaySets
      //(0072,0218)
      = const ElementDef(
          "ReferenceDisplaySets", 0x00720218, "Reference Display Sets", VR.kUS, VM.k1_n, false);
  static const ElementDef kImageBoxesSequence
      //(0072,0300)
      =
      const ElementDef("ImageBoxesSequence", 0x00720300, "Image Boxes Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImageBoxNumber
      //(0072,0302)
      = const ElementDef("ImageBoxNumber", 0x00720302, "Image Box Number", VR.kUS, VM.k1, false);
  static const ElementDef kImageBoxLayoutType
      //(0072,0304)
      = const ElementDef(
          "ImageBoxLayoutType", 0x00720304, "Image Box Layout Type", VR.kCS, VM.k1, false);
  static const ElementDef kImageBoxTileHorizontalDimension
      //(0072,0306)
      = const ElementDef("ImageBoxTileHorizontalDimension", 0x00720306,
          "Image Box Tile Horizontal Dimension", VR.kUS, VM.k1, false);
  static const ElementDef kImageBoxTileVerticalDimension
      //(0072,0308)
      = const ElementDef("ImageBoxTileVerticalDimension", 0x00720308,
          "Image Box Tile Vertical Dimension", VR.kUS, VM.k1, false);
  static const ElementDef kImageBoxScrollDirection
      //(0072,0310)
      = const ElementDef("ImageBoxScrollDirection", 0x00720310, "Image Box Scroll Direction", VR.kCS,
          VM.k1, false);
  static const ElementDef kImageBoxSmallScrollType
      //(0072,0312)
      = const ElementDef("ImageBoxSmallScrollType", 0x00720312, "Image Box Small Scroll Type", VR.kCS,
          VM.k1, false);
  static const ElementDef kImageBoxSmallScrollAmount
      //(0072,0314)
      = const ElementDef("ImageBoxSmallScrollAmount", 0x00720314, "Image Box Small Scroll Amount",
          VR.kUS, VM.k1, false);
  static const ElementDef kImageBoxLargeScrollType
      //(0072,0316)
      = const ElementDef("ImageBoxLargeScrollType", 0x00720316, "Image Box Large Scroll Type", VR.kCS,
          VM.k1, false);
  static const ElementDef kImageBoxLargeScrollAmount
      //(0072,0318)
      = const ElementDef("ImageBoxLargeScrollAmount", 0x00720318, "Image Box Large Scroll Amount",
          VR.kUS, VM.k1, false);
  static const ElementDef kImageBoxOverlapPriority
      //(0072,0320)
      = const ElementDef("ImageBoxOverlapPriority", 0x00720320, "Image Box Overlap Priority", VR.kUS,
          VM.k1, false);
  static const ElementDef kCineRelativeToRealTime
      //(0072,0330)
      = const ElementDef(
          "CineRelativeToRealTime", 0x00720330, "Cine Relative to Real-Time", VR.kFD, VM.k1, false);
  static const ElementDef kFilterOperationsSequence
      //(0072,0400)
      = const ElementDef("FilterOperationsSequence", 0x00720400, "Filter Operations Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kFilterByCategory
      //(0072,0402)
      = const ElementDef("FilterByCategory", 0x00720402, "Filter-by Category", VR.kCS, VM.k1, false);
  static const ElementDef kFilterByAttributePresence
      //(0072,0404)
      = const ElementDef("FilterByAttributePresence", 0x00720404, "Filter-by Attribute Presence",
          VR.kCS, VM.k1, false);
  static const ElementDef kFilterByOperator
      //(0072,0406)
      = const ElementDef("FilterByOperator", 0x00720406, "Filter-by Operator", VR.kCS, VM.k1, false);
  static const ElementDef kStructuredDisplayBackgroundCIELabValue
      //(0072,0420)
      = const ElementDef("StructuredDisplayBackgroundCIELabValue", 0x00720420,
          "Structured Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const ElementDef kEmptyImageBoxCIELabValue
      //(0072,0421)
      = const ElementDef("EmptyImageBoxCIELabValue", 0x00720421, "Empty Image Box CIELab Value",
          VR.kUS, VM.k3, false);
  static const ElementDef kStructuredDisplayImageBoxSequence
      //(0072,0422)
      = const ElementDef("StructuredDisplayImageBoxSequence", 0x00720422,
          "Structured Display Image Box Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStructuredDisplayTextBoxSequence
      //(0072,0424)
      = const ElementDef("StructuredDisplayTextBoxSequence", 0x00720424,
          "Structured Display Text Box Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedFirstFrameSequence
      //(0072,0427)
      = const ElementDef("ReferencedFirstFrameSequence", 0x00720427, "Referenced First Frame Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kImageBoxSynchronizationSequence
      //(0072,0430)
      = const ElementDef("ImageBoxSynchronizationSequence", 0x00720430,
          "Image Box Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSynchronizedImageBoxList
      //(0072,0432)
      = const ElementDef("SynchronizedImageBoxList", 0x00720432, "Synchronized Image Box List", VR.kUS,
          VM.k2_n, false);
  static const ElementDef kTypeOfSynchronization
      //(0072,0434)
      = const ElementDef(
          "TypeOfSynchronization", 0x00720434, "Type of Synchronization", VR.kCS, VM.k1, false);
  static const ElementDef kBlendingOperationType
      //(0072,0500)
      = const ElementDef(
          "BlendingOperationType", 0x00720500, "Blending Operation Type", VR.kCS, VM.k1, false);
  static const ElementDef kReformattingOperationType
      //(0072,0510)
      = const ElementDef("ReformattingOperationType", 0x00720510, "Reformatting Operation Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kReformattingThickness
      //(0072,0512)
      = const ElementDef(
          "ReformattingThickness", 0x00720512, "Reformatting Thickness", VR.kFD, VM.k1, false);
  static const ElementDef kReformattingInterval
      //(0072,0514)
      = const ElementDef(
          "ReformattingInterval", 0x00720514, "Reformatting Interval", VR.kFD, VM.k1, false);
  static const ElementDef kReformattingOperationInitialViewDirection
      //(0072,0516)
      = const ElementDef("ReformattingOperationInitialViewDirection", 0x00720516,
          "Reformatting Operation Initial View Direction", VR.kCS, VM.k1, false);
  static const ElementDef kThreeDRenderingType
      //(0072,0520)
      =
      const ElementDef("ThreeDRenderingType", 0x00720520, "3D Rendering Type", VR.kCS, VM.k1_n, false);
  static const ElementDef kSortingOperationsSequence
      //(0072,0600)
      = const ElementDef("SortingOperationsSequence", 0x00720600, "Sorting Operations Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSortByCategory
      //(0072,0602)
      = const ElementDef("SortByCategory", 0x00720602, "Sort-by Category", VR.kCS, VM.k1, false);
  static const ElementDef kSortingDirection
      //(0072,0604)
      = const ElementDef("SortingDirection", 0x00720604, "Sorting Direction", VR.kCS, VM.k1, false);
  static const ElementDef kDisplaySetPatientOrientation
      //(0072,0700)
      = const ElementDef("DisplaySetPatientOrientation", 0x00720700, "Display Set Patient Orientation",
          VR.kCS, VM.k2, false);
  static const ElementDef kVOIType
      //(0072,0702)
      = const ElementDef("VOIType", 0x00720702, "VOI Type", VR.kCS, VM.k1, false);
  static const ElementDef kPseudoColorType
      //(0072,0704)
      = const ElementDef("PseudoColorType", 0x00720704, "Pseudo-Color Type", VR.kCS, VM.k1, false);
  static const ElementDef kPseudoColorPaletteInstanceReferenceSequence
      //(0072,0705)
      = const ElementDef("PseudoColorPaletteInstanceReferenceSequence", 0x00720705,
          "Pseudo-Color Palette Instance Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kShowGrayscaleInverted
      //(0072,0706)
      = const ElementDef(
          "ShowGrayscaleInverted", 0x00720706, "Show Grayscale Inverted", VR.kCS, VM.k1, false);
  static const ElementDef kShowImageTrueSizeFlag
      //(0072,0710)
      = const ElementDef(
          "ShowImageTrueSizeFlag", 0x00720710, "Show Image True Size Flag", VR.kCS, VM.k1, false);
  static const ElementDef kShowGraphicAnnotationFlag
      //(0072,0712)
      = const ElementDef("ShowGraphicAnnotationFlag", 0x00720712, "Show Graphic Annotation Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kShowPatientDemographicsFlag
      //(0072,0714)
      = const ElementDef("ShowPatientDemographicsFlag", 0x00720714, "Show Patient Demographics Flag",
          VR.kCS, VM.k1, false);
  static const ElementDef kShowAcquisitionTechniquesFlag
      //(0072,0716)
      = const ElementDef("ShowAcquisitionTechniquesFlag", 0x00720716,
          "Show Acquisition Techniques Flag", VR.kCS, VM.k1, false);
  static const ElementDef kDisplaySetHorizontalJustification
      //(0072,0717)
      = const ElementDef("DisplaySetHorizontalJustification", 0x00720717,
          "Display Set Horizontal Justification", VR.kCS, VM.k1, false);
  static const ElementDef kDisplaySetVerticalJustification
      //(0072,0718)
      = const ElementDef("DisplaySetVerticalJustification", 0x00720718,
          "Display Set Vertical Justification", VR.kCS, VM.k1, false);
  static const ElementDef kContinuationStartMeterset
      //(0074,0120)
      = const ElementDef("ContinuationStartMeterset", 0x00740120, "Continuation Start Meterset",
          VR.kFD, VM.k1, false);
  static const ElementDef kContinuationEndMeterset
      //(0074,0121)
      = const ElementDef(
          "ContinuationEndMeterset", 0x00740121, "Continuation End Meterset", VR.kFD, VM.k1, false);
  static const ElementDef kProcedureStepState
      //(0074,1000)
      =
      const ElementDef("ProcedureStepState", 0x00741000, "Procedure Step State", VR.kCS, VM.k1, false);
  static const ElementDef kProcedureStepProgressInformationSequence
      //(0074,1002)
      = const ElementDef("ProcedureStepProgressInformationSequence", 0x00741002,
          "Procedure Step Progress Information Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kProcedureStepProgress
      //(0074,1004)
      = const ElementDef(
          "ProcedureStepProgress", 0x00741004, "Procedure Step Progress", VR.kDS, VM.k1, false);
  static const ElementDef kProcedureStepProgressDescription
      //(0074,1006)
      = const ElementDef("ProcedureStepProgressDescription", 0x00741006,
          "Procedure Step Progress Description", VR.kST, VM.k1, false);
  static const ElementDef kProcedureStepCommunicationsURISequence
      //(0074,1008)
      = const ElementDef("ProcedureStepCommunicationsURISequence", 0x00741008,
          "Procedure Step Communications URI Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContactURI
      //(0074,100a)
      = const ElementDef("ContactURI", 0x0074100a, "Contact URI", VR.kST, VM.k1, false);
  static const ElementDef kContactDisplayName
      //(0074,100c)
      =
      const ElementDef("ContactDisplayName", 0x0074100c, "Contact Display Name", VR.kLO, VM.k1, false);
  static const ElementDef kProcedureStepDiscontinuationReasonCodeSequence
      //(0074,100e)
      = const ElementDef("ProcedureStepDiscontinuationReasonCodeSequence", 0x0074100e,
          "Procedure Step Discontinuation Reason Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBeamTaskSequence
      //(0074,1020)
      = const ElementDef("BeamTaskSequence", 0x00741020, "Beam Task Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBeamTaskType
      //(0074,1022)
      = const ElementDef("BeamTaskType", 0x00741022, "Beam Task Type", VR.kCS, VM.k1, false);
  static const ElementDef kBeamOrderIndexTrial
      //(0074,1024)
      = const ElementDef(
          "BeamOrderIndexTrial", 0x00741024, "Beam Order Index (Trial)", VR.kIS, VM.k1, true);
  static const ElementDef kAutosequenceFlag
      //(0074,1025)
      = const ElementDef("AutosequenceFlag", 0x00741025, "Autosequence Flag", VR.kCS, VM.k1, false);
  static const ElementDef kTableTopVerticalAdjustedPosition
      //(0074,1026)
      = const ElementDef("TableTopVerticalAdjustedPosition", 0x00741026,
          "Table Top Vertical Adjusted Position", VR.kFD, VM.k1, false);
  static const ElementDef kTableTopLongitudinalAdjustedPosition
      //(0074,1027)
      = const ElementDef("TableTopLongitudinalAdjustedPosition", 0x00741027,
          "Table Top Longitudinal Adjusted Position", VR.kFD, VM.k1, false);
  static const ElementDef kTableTopLateralAdjustedPosition
      //(0074,1028)
      = const ElementDef("TableTopLateralAdjustedPosition", 0x00741028,
          "Table Top Lateral Adjusted Position", VR.kFD, VM.k1, false);
  static const ElementDef kPatientSupportAdjustedAngle
      //(0074,102A)
      = const ElementDef("PatientSupportAdjustedAngle", 0x0074102A, "Patient Support Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const ElementDef kTableTopEccentricAdjustedAngle
      //(0074,102B)
      = const ElementDef("TableTopEccentricAdjustedAngle", 0x0074102B,
          "Table Top Eccentric Adjusted Angle", VR.kFD, VM.k1, false);
  static const ElementDef kTableTopPitchAdjustedAngle
      //(0074,102C)
      = const ElementDef("TableTopPitchAdjustedAngle", 0x0074102C, "Table Top Pitch Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const ElementDef kTableTopRollAdjustedAngle
      //(0074,102D)
      = const ElementDef("TableTopRollAdjustedAngle", 0x0074102D, "Table Top Roll Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const ElementDef kDeliveryVerificationImageSequence
      //(0074,1030)
      = const ElementDef("DeliveryVerificationImageSequence", 0x00741030,
          "Delivery Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kVerificationImageTiming
      //(0074,1032)
      = const ElementDef(
          "VerificationImageTiming", 0x00741032, "Verification Image Timing", VR.kCS, VM.k1, false);
  static const ElementDef kDoubleExposureFlag
      //(0074,1034)
      =
      const ElementDef("DoubleExposureFlag", 0x00741034, "Double Exposure Flag", VR.kCS, VM.k1, false);
  static const ElementDef kDoubleExposureOrdering
      //(0074,1036)
      = const ElementDef(
          "DoubleExposureOrdering", 0x00741036, "Double Exposure Ordering", VR.kCS, VM.k1, false);
  static const ElementDef kDoubleExposureMetersetTrial
      //(0074,1038)
      = const ElementDef("DoubleExposureMetersetTrial", 0x00741038, "Double Exposure Meterset (Trial)",
          VR.kDS, VM.k1, true);
  static const ElementDef kDoubleExposureFieldDeltaTrial
      //(0074,103A)
      = const ElementDef("DoubleExposureFieldDeltaTrial", 0x0074103A,
          "Double Exposure Field Delta (Trial)", VR.kDS, VM.k4, true);
  static const ElementDef kRelatedReferenceRTImageSequence
      //(0074,1040)
      = const ElementDef("RelatedReferenceRTImageSequence", 0x00741040,
          "Related Reference RT Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kGeneralMachineVerificationSequence
      //(0074,1042)
      = const ElementDef("GeneralMachineVerificationSequence", 0x00741042,
          "General Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kConventionalMachineVerificationSequence
      //(0074,1044)
      = const ElementDef("ConventionalMachineVerificationSequence", 0x00741044,
          "Conventional Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonMachineVerificationSequence
      //(0074,1046)
      = const ElementDef("IonMachineVerificationSequence", 0x00741046,
          "Ion Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFailedAttributesSequence
      //(0074,1048)
      = const ElementDef("FailedAttributesSequence", 0x00741048, "Failed Attributes Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kOverriddenAttributesSequence
      //(0074,104A)
      = const ElementDef("OverriddenAttributesSequence", 0x0074104A, "Overridden Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kConventionalControlPointVerificationSequence
      //(0074,104C)
      = const ElementDef("ConventionalControlPointVerificationSequence", 0x0074104C,
          "Conventional Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonControlPointVerificationSequence
      //(0074,104E)
      = const ElementDef("IonControlPointVerificationSequence", 0x0074104E,
          "Ion Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAttributeOccurrenceSequence
      //(0074,1050)
      = const ElementDef("AttributeOccurrenceSequence", 0x00741050, "Attribute Occurrence Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAttributeOccurrencePointer
      //(0074,1052)
      = const ElementDef("AttributeOccurrencePointer", 0x00741052, "Attribute Occurrence Pointer",
          VR.kAT, VM.k1, false);
  static const ElementDef kAttributeItemSelector
      //(0074,1054)
      = const ElementDef(
          "AttributeItemSelector", 0x00741054, "Attribute Item Selector", VR.kUL, VM.k1, false);
  static const ElementDef kAttributeOccurrencePrivateCreator
      //(0074,1056)
      = const ElementDef("AttributeOccurrencePrivateCreator", 0x00741056,
          "Attribute Occurrence Private Creator", VR.kLO, VM.k1, false);
  static const ElementDef kSelectorSequencePointerItems
      //(0074,1057)
      = const ElementDef("SelectorSequencePointerItems", 0x00741057, "Selector Sequence Pointer Items",
          VR.kIS, VM.k1_n, false);
  static const ElementDef kScheduledProcedureStepPriority
      //(0074,1200)
      = const ElementDef("ScheduledProcedureStepPriority", 0x00741200,
          "Scheduled Procedure Step Priority", VR.kCS, VM.k1, false);
  static const ElementDef kWorklistLabel
      //(0074,1202)
      = const ElementDef("WorklistLabel", 0x00741202, "Worklist Label", VR.kLO, VM.k1, false);
  static const ElementDef kProcedureStepLabel
      //(0074,1204)
      =
      const ElementDef("ProcedureStepLabel", 0x00741204, "Procedure Step Label", VR.kLO, VM.k1, false);
  static const ElementDef kScheduledProcessingParametersSequence
      //(0074,1210)
      = const ElementDef("ScheduledProcessingParametersSequence", 0x00741210,
          "Scheduled Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerformedProcessingParametersSequence
      //(0074,1212)
      = const ElementDef("PerformedProcessingParametersSequence", 0x00741212,
          "Performed Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kUnifiedProcedureStepPerformedProcedureSequence
      //(0074,1216)
      = const ElementDef("UnifiedProcedureStepPerformedProcedureSequence", 0x00741216,
          "Unified Procedure Step Performed Procedure Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRelatedProcedureStepSequence
      //(0074,1220)
      = const ElementDef("RelatedProcedureStepSequence", 0x00741220, "Related Procedure Step Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kProcedureStepRelationshipType
      //(0074,1222)
      = const ElementDef("ProcedureStepRelationshipType", 0x00741222,
          "Procedure Step Relationship Type", VR.kLO, VM.k1, true);
  static const ElementDef kReplacedProcedureStepSequence
      //(0074,1224)
      = const ElementDef("ReplacedProcedureStepSequence", 0x00741224,
          "Replaced Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDeletionLock
      //(0074,1230)
      = const ElementDef("DeletionLock", 0x00741230, "Deletion Lock", VR.kLO, VM.k1, false);
  static const ElementDef kReceivingAE
      //(0074,1234)
      = const ElementDef("ReceivingAE", 0x00741234, "Receiving AE", VR.kAE, VM.k1, false);
  static const ElementDef kRequestingAE
      //(0074,1236)
      = const ElementDef("RequestingAE", 0x00741236, "Requesting AE", VR.kAE, VM.k1, false);
  static const ElementDef kReasonForCancellation
      //(0074,1238)
      = const ElementDef(
          "ReasonForCancellation", 0x00741238, "Reason for Cancellation", VR.kLT, VM.k1, false);
  static const ElementDef kSCPStatus
      //(0074,1242)
      = const ElementDef("SCPStatus", 0x00741242, "SCP Status", VR.kCS, VM.k1, false);
  static const ElementDef kSubscriptionListStatus
      //(0074,1244)
      = const ElementDef(
          "SubscriptionListStatus", 0x00741244, "Subscription List Status", VR.kCS, VM.k1, false);
  static const ElementDef kUnifiedProcedureStepListStatus
      //(0074,1246)
      = const ElementDef("UnifiedProcedureStepListStatus", 0x00741246,
          "Unified Procedure StepList Status", VR.kCS, VM.k1, false);
  static const ElementDef kBeamOrderIndex
      //(0074,1324)
      = const ElementDef("BeamOrderIndex", 0x00741324, "Beam Order Index", VR.kUL, VM.k1, false);
  static const ElementDef kDoubleExposureMeterset
      //(0074,1338)
      = const ElementDef(
          "DoubleExposureMeterset", 0x00741338, "Double Exposure Meterset", VR.kFD, VM.k1, false);
  static const ElementDef kDoubleExposureFieldDelta
      //(0074,133A)
      = const ElementDef("DoubleExposureFieldDelta", 0x0074133A, "Double Exposure Field Delta", VR.kFD,
          VM.k4, false);
  static const ElementDef kImplantAssemblyTemplateName
      //(0076,0001)
      = const ElementDef("ImplantAssemblyTemplateName", 0x00760001, "Implant Assembly Template Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kImplantAssemblyTemplateIssuer
      //(0076,0003)
      = const ElementDef("ImplantAssemblyTemplateIssuer", 0x00760003,
          "Implant Assembly Template Issuer", VR.kLO, VM.k1, false);
  static const ElementDef kImplantAssemblyTemplateVersion
      //(0076,0006)
      = const ElementDef("ImplantAssemblyTemplateVersion", 0x00760006,
          "Implant Assembly Template Version", VR.kLO, VM.k1, false);
  static const ElementDef kReplacedImplantAssemblyTemplateSequence
      //(0076,0008)
      = const ElementDef("ReplacedImplantAssemblyTemplateSequence", 0x00760008,
          "Replaced Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantAssemblyTemplateType
      //(0076,000A)
      = const ElementDef("ImplantAssemblyTemplateType", 0x0076000A, "Implant Assembly Template Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kOriginalImplantAssemblyTemplateSequence
      //(0076,000C)
      = const ElementDef("OriginalImplantAssemblyTemplateSequence", 0x0076000C,
          "Original Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDerivationImplantAssemblyTemplateSequence
      //(0076,000E)
      = const ElementDef("DerivationImplantAssemblyTemplateSequence", 0x0076000E,
          "Derivation Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantAssemblyTemplateTargetAnatomySequence
      //(0076,0010)
      = const ElementDef("ImplantAssemblyTemplateTargetAnatomySequence", 0x00760010,
          "Implant Assembly Template Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kProcedureTypeCodeSequence
      //(0076,0020)
      = const ElementDef("ProcedureTypeCodeSequence", 0x00760020, "Procedure Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSurgicalTechnique
      //(0076,0030)
      = const ElementDef("SurgicalTechnique", 0x00760030, "Surgical Technique", VR.kLO, VM.k1, false);
  static const ElementDef kComponentTypesSequence
      //(0076,0032)
      = const ElementDef(
          "ComponentTypesSequence", 0x00760032, "Component Types Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kComponentTypeCodeSequence
      //(0076,0034)
      = const ElementDef("ComponentTypeCodeSequence", 0x00760034, "Component Type Code Sequence",
          VR.kCS, VM.k1, false);
  static const ElementDef kExclusiveComponentType
      //(0076,0036)
      = const ElementDef(
          "ExclusiveComponentType", 0x00760036, "Exclusive Component Type", VR.kCS, VM.k1, false);
  static const ElementDef kMandatoryComponentType
      //(0076,0038)
      = const ElementDef(
          "MandatoryComponentType", 0x00760038, "Mandatory Component Type", VR.kCS, VM.k1, false);
  static const ElementDef kComponentSequence
      //(0076,0040)
      = const ElementDef("ComponentSequence", 0x00760040, "Component Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kComponentID
      //(0076,0055)
      = const ElementDef("ComponentID", 0x00760055, "Component ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponentAssemblySequence
      //(0076,0060)
      = const ElementDef("ComponentAssemblySequence", 0x00760060, "Component Assembly Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kComponent1ReferencedID
      //(0076,0070)
      = const ElementDef(
          "Component1ReferencedID", 0x00760070, "Component 1 Referenced ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponent1ReferencedMatingFeatureSetID
      //(0076,0080)
      = const ElementDef("Component1ReferencedMatingFeatureSetID", 0x00760080,
          "Component 1 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponent1ReferencedMatingFeatureID
      //(0076,0090)
      = const ElementDef("Component1ReferencedMatingFeatureID", 0x00760090,
          "Component 1 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponent2ReferencedID
      //(0076,00A0)
      = const ElementDef(
          "Component2ReferencedID", 0x007600A0, "Component 2 Referenced ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponent2ReferencedMatingFeatureSetID
      //(0076,00B0)
      = const ElementDef("Component2ReferencedMatingFeatureSetID", 0x007600B0,
          "Component 2 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const ElementDef kComponent2ReferencedMatingFeatureID
      //(0076,00C0)
      = const ElementDef("Component2ReferencedMatingFeatureID", 0x007600C0,
          "Component 2 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const ElementDef kImplantTemplateGroupName
      //(0078,0001)
      = const ElementDef("ImplantTemplateGroupName", 0x00780001, "Implant Template Group Name", VR.kLO,
          VM.k1, false);
  static const ElementDef kImplantTemplateGroupDescription
      //(0078,0010)
      = const ElementDef("ImplantTemplateGroupDescription", 0x00780010,
          "Implant Template Group Description", VR.kST, VM.k1, false);
  static const ElementDef kImplantTemplateGroupIssuer
      //(0078,0020)
      = const ElementDef("ImplantTemplateGroupIssuer", 0x00780020, "Implant Template Group Issuer",
          VR.kLO, VM.k1, false);
  static const ElementDef kImplantTemplateGroupVersion
      //(0078,0024)
      = const ElementDef("ImplantTemplateGroupVersion", 0x00780024, "Implant Template Group Version",
          VR.kLO, VM.k1, false);
  static const ElementDef kReplacedImplantTemplateGroupSequence
      //(0078,0026)
      = const ElementDef("ReplacedImplantTemplateGroupSequence", 0x00780026,
          "Replaced Implant Template Group Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantTemplateGroupTargetAnatomySequence
      //(0078,0028)
      = const ElementDef("ImplantTemplateGroupTargetAnatomySequence", 0x00780028,
          "Implant Template Group Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantTemplateGroupMembersSequence
      //(0078,002A)
      = const ElementDef("ImplantTemplateGroupMembersSequence", 0x0078002A,
          "Implant Template Group Members Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantTemplateGroupMemberID
      //(0078,002E)
      = const ElementDef("ImplantTemplateGroupMemberID", 0x0078002E,
          "Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const ElementDef kThreeDImplantTemplateGroupMemberMatchingPoint
      //(0078,0050)
      = const ElementDef("ThreeDImplantTemplateGroupMemberMatchingPoint", 0x00780050,
          "3D Implant Template Group Member Matching Point", VR.kFD, VM.k3, false);
  static const ElementDef kThreeDImplantTemplateGroupMemberMatchingAxes
      //(0078,0060)
      = const ElementDef("ThreeDImplantTemplateGroupMemberMatchingAxes", 0x00780060,
          "3D Implant Template Group Member Matching Axes", VR.kFD, VM.k9, false);
  static const ElementDef kImplantTemplateGroupMemberMatching2DCoordinatesSequence
      //(0078,0070)
      = const ElementDef("ImplantTemplateGroupMemberMatching2DCoordinatesSequence", 0x00780070,
          "Implant Template Group Member Matching 2D Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTwoDImplantTemplateGroupMemberMatchingPoint
      //(0078,0090)
      = const ElementDef("TwoDImplantTemplateGroupMemberMatchingPoint", 0x00780090,
          "2D Implant Template Group Member Matching Point", VR.kFD, VM.k2, false);
  static const ElementDef kTwoDImplantTemplateGroupMemberMatchingAxes
      //(0078,00A0)
      = const ElementDef("TwoDImplantTemplateGroupMemberMatchingAxes", 0x007800A0,
          "2D Implant Template Group Member Matching Axes", VR.kFD, VM.k4, false);
  static const ElementDef kImplantTemplateGroupVariationDimensionSequence
      //(0078,00B0)
      = const ElementDef("ImplantTemplateGroupVariationDimensionSequence", 0x007800B0,
          "Implant Template Group Variation Dimension Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImplantTemplateGroupVariationDimensionName
      //(0078,00B2)
      = const ElementDef("ImplantTemplateGroupVariationDimensionName", 0x007800B2,
          "Implant Template Group Variation Dimension Name", VR.kLO, VM.k1, false);
  static const ElementDef kImplantTemplateGroupVariationDimensionRankSequence
      //(0078,00B4)
      = const ElementDef("ImplantTemplateGroupVariationDimensionRankSequence", 0x007800B4,
          "Implant Template Group Variation Dimension Rank Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedImplantTemplateGroupMemberID
      //(0078,00B6)
      = const ElementDef("ReferencedImplantTemplateGroupMemberID", 0x007800B6,
          "Referenced Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const ElementDef kImplantTemplateGroupVariationDimensionRank
      //(0078,00B8)
      = const ElementDef("ImplantTemplateGroupVariationDimensionRank", 0x007800B8,
          "Implant Template Group Variation Dimension Rank", VR.kUS, VM.k1, false);
  static const ElementDef kSurfaceScanAcquisitionTypeCodeSequence
      //(0080,0001)
      = const ElementDef("SurfaceScanAcquisitionTypeCodeSequence", 0x00800001,
          "Surface Scan Acquisition Type Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSurfaceScanModeCodeSequence
      //(0080,0002)
      = const ElementDef("SurfaceScanModeCodeSequence", 0x00800002, "Surface Scan Mode Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRegistrationMethodCodeSequence
      //(0080,0003)
      = const ElementDef("RegistrationMethodCodeSequence", 0x00800003,
          "Registration Method Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kShotDurationTime
      //(0080,0004)
      = const ElementDef("ShotDurationTime", 0x00800004, "Shot Duration Time", VR.kFD, VM.k1, false);
  static const ElementDef kShotOffsetTime
      //(0080,0005)
      = const ElementDef("ShotOffsetTime", 0x00800005, "Shot Offset Time", VR.kFD, VM.k1, false);
  static const ElementDef kSurfacePointPresentationValueData
      //(0080,0006)
      = const ElementDef("SurfacePointPresentationValueData", 0x00800006,
          "Surface Point Presentation Value Data", VR.kUS, VM.k1_n, false);
  static const ElementDef kSurfacePointColorCIELabValueData
      //(0080,0007)
      = const ElementDef("SurfacePointColorCIELabValueData", 0x00800007,
          "Surface Point Color CIELab Value Data", VR.kUS, VM.k3_3n, false);
  static const ElementDef kUVMappingSequence
      //(0080,0008)
      = const ElementDef("UVMappingSequence", 0x00800008, "UV Mapping Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTextureLabel
      //(0080,0009)
      = const ElementDef("TextureLabel", 0x00800009, "Texture Label", VR.kSH, VM.k1, false);
  static const ElementDef kUValueData
      //(0080,0010)
      = const ElementDef("UValueData", 0x00800010, "U Value Data", VR.kOF, VM.k1_n, false);
  static const ElementDef kVValueData
      //(0080,0011)
      = const ElementDef("VValueData", 0x00800011, "V Value Data", VR.kOF, VM.k1_n, false);
  static const ElementDef kReferencedTextureSequence
      //(0080,0012)
      = const ElementDef("ReferencedTextureSequence", 0x00800012, "Referenced Texture Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSurfaceDataSequence
      //(0080,0013)
      = const ElementDef("ReferencedSurfaceDataSequence", 0x00800013,
          "Referenced Surface Data Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStorageMediaFileSetID
      //(0088,0130)
      = const ElementDef(
          "StorageMediaFileSetID", 0x00880130, "Storage Media File-set ID", VR.kSH, VM.k1, false);
  static const ElementDef kStorageMediaFileSetUID
      //(0088,0140)
      = const ElementDef(
          "StorageMediaFileSetUID", 0x00880140, "Storage Media File-set UID", VR.kUI, VM.k1, false);
  static const ElementDef kIconImageSequence
      //(0088,0200)
      = const ElementDef("IconImageSequence", 0x00880200, "Icon Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTopicTitle
      //(0088,0904)
      = const ElementDef("TopicTitle", 0x00880904, "Topic Title", VR.kLO, VM.k1, true);
  static const ElementDef kTopicSubject
      //(0088,0906)
      = const ElementDef("TopicSubject", 0x00880906, "Topic Subject", VR.kST, VM.k1, true);
  static const ElementDef kTopicAuthor
      //(0088,0910)
      = const ElementDef("TopicAuthor", 0x00880910, "Topic Author", VR.kLO, VM.k1, true);
  static const ElementDef kTopicKeywords
      //(0088,0912)
      = const ElementDef("TopicKeywords", 0x00880912, "Topic Keywords", VR.kLO, VM.k1_32, true);
  static const ElementDef kSOPInstanceStatus
      //(0100,0410)
      = const ElementDef("SOPInstanceStatus", 0x01000410, "SOP Instance Status", VR.kCS, VM.k1, false);
  static const ElementDef kSOPAuthorizationDateTime
      //(0100,0420)
      = const ElementDef("SOPAuthorizationDateTime", 0x01000420, "SOP Authorization DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kSOPAuthorizationComment
      //(0100,0424)
      = const ElementDef(
          "SOPAuthorizationComment", 0x01000424, "SOP Authorization Comment", VR.kLT, VM.k1, false);
  static const ElementDef kAuthorizationEquipmentCertificationNumber
      //(0100,0426)
      = const ElementDef("AuthorizationEquipmentCertificationNumber", 0x01000426,
          "Authorization Equipment Certification Number", VR.kLO, VM.k1, false);
  static const ElementDef kMACIDNumber
      //(0400,0005)
      = const ElementDef("MACIDNumber", 0x04000005, "MAC ID Number", VR.kUS, VM.k1, false);
  static const ElementDef kMACCalculationTransferSyntaxUID
      //(0400,0010)
      = const ElementDef("MACCalculationTransferSyntaxUID", 0x04000010,
          "MAC Calculation Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const ElementDef kMACAlgorithm
      //(0400,0015)
      = const ElementDef("MACAlgorithm", 0x04000015, "MAC Algorithm", VR.kCS, VM.k1, false);
  static const ElementDef kDataElementsSigned
      //(0400,0020)
      = const ElementDef(
          "DataElementsSigned", 0x04000020, "Data Elements Signed", VR.kAT, VM.k1_n, false);
  static const ElementDef kDigitalSignatureUID
      //(0400,0100)
      = const ElementDef(
          "DigitalSignatureUID", 0x04000100, "Digital Signature UID", VR.kUI, VM.k1, false);
  static const ElementDef kDigitalSignatureDateTime
      //(0400,0105)
      = const ElementDef("DigitalSignatureDateTime", 0x04000105, "Digital Signature DateTime", VR.kDT,
          VM.k1, false);
  static const ElementDef kCertificateType
      //(0400,0110)
      = const ElementDef("CertificateType", 0x04000110, "Certificate Type", VR.kCS, VM.k1, false);
  static const ElementDef kCertificateOfSigner
      //(0400,0115)
      = const ElementDef(
          "CertificateOfSigner", 0x04000115, "Certificate of Signer", VR.kOB, VM.k1, false);
  static const ElementDef kSignature
      //(0400,0120)
      = const ElementDef("Signature", 0x04000120, "Signature", VR.kOB, VM.k1, false);
  static const ElementDef kCertifiedTimestampType
      //(0400,0305)
      = const ElementDef(
          "CertifiedTimestampType", 0x04000305, "Certified Timestamp Type", VR.kCS, VM.k1, false);
  static const ElementDef kCertifiedTimestamp
      //(0400,0310)
      =
      const ElementDef("CertifiedTimestamp", 0x04000310, "Certified Timestamp", VR.kOB, VM.k1, false);
  static const ElementDef kDigitalSignaturePurposeCodeSequence
      //(0400,0401)
      = const ElementDef("DigitalSignaturePurposeCodeSequence", 0x04000401,
          "Digital Signature Purpose Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedDigitalSignatureSequence
      //(0400,0402)
      = const ElementDef("ReferencedDigitalSignatureSequence", 0x04000402,
          "Referenced Digital Signature Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSOPInstanceMACSequence
      //(0400,0403)
      = const ElementDef("ReferencedSOPInstanceMACSequence", 0x04000403,
          "Referenced SOP Instance MAC Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMAC
      //(0400,0404)
      = const ElementDef("MAC", 0x04000404, "MAC", VR.kOB, VM.k1, false);
  static const ElementDef kEncryptedAttributesSequence
      //(0400,0500)
      = const ElementDef("EncryptedAttributesSequence", 0x04000500, "Encrypted Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kEncryptedContentTransferSyntaxUID
      //(0400,0510)
      = const ElementDef("EncryptedContentTransferSyntaxUID", 0x04000510,
          "Encrypted Content Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const ElementDef kEncryptedContent
      //(0400,0520)
      = const ElementDef("EncryptedContent", 0x04000520, "Encrypted Content", VR.kOB, VM.k1, false);
  static const ElementDef kModifiedAttributesSequence
      //(0400,0550)
      = const ElementDef("ModifiedAttributesSequence", 0x04000550, "Modified Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kOriginalAttributesSequence
      //(0400,0561)
      = const ElementDef("OriginalAttributesSequence", 0x04000561, "Original Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kAttributeModificationDateTime
      //(0400,0562)
      = const ElementDef("AttributeModificationDateTime", 0x04000562,
          "Attribute Modification DateTime", VR.kDT, VM.k1, false);
  static const ElementDef kModifyingSystem
      //(0400,0563)
      = const ElementDef("ModifyingSystem", 0x04000563, "Modifying System", VR.kLO, VM.k1, false);
  static const ElementDef kSourceOfPreviousValues
      //(0400,0564)
      = const ElementDef(
          "SourceOfPreviousValues", 0x04000564, "Source of Previous Values", VR.kLO, VM.k1, false);
  static const ElementDef kReasonForTheAttributeModification
      //(0400,0565)
      = const ElementDef("ReasonForTheAttributeModification", 0x04000565,
          "Reason for the Attribute Modification", VR.kCS, VM.k1, false);
  static const ElementDef kEscapeTriplet
      //(1000,0000)
      = const ElementDef("EscapeTriplet", 0x10000000, "Escape Triplet", VR.kUS, VM.k3, true);
  static const ElementDef kRunLengthTriplet
      //(1000,0001)
      = const ElementDef("RunLengthTriplet", 0x10000001, "Run Length Triplet", VR.kUS, VM.k3, true);
  static const ElementDef kHuffmanTableSize
      //(1000,0002)
      = const ElementDef("HuffmanTableSize", 0x10000002, "Huffman Table Size", VR.kUS, VM.k1, true);
  static const ElementDef kHuffmanTableTriplet
      //(1000,0003)
      = const ElementDef(
          "HuffmanTableTriplet", 0x10000003, "Huffman Table Triplet", VR.kUS, VM.k3, true);
  static const ElementDef kShiftTableSize
      //(1000,0004)
      = const ElementDef("ShiftTableSize", 0x10000004, "Shift Table Size", VR.kUS, VM.k1, true);
  static const ElementDef kShiftTableTriplet
      //(1000,0005)
      = const ElementDef("ShiftTableTriplet", 0x10000005, "Shift Table Triplet", VR.kUS, VM.k3, true);
  static const ElementDef kZonalMap
      //(1010,0000)
      = const ElementDef("ZonalMap", 0x10100000, "Zonal Map", VR.kUS, VM.k1_n, true);
  static const ElementDef kNumberOfCopies
      //(2000,0010)
      = const ElementDef("NumberOfCopies", 0x20000010, "Number of Copies", VR.kIS, VM.k1, false);
  static const ElementDef kPrinterConfigurationSequence
      //(2000,001E)
      = const ElementDef("PrinterConfigurationSequence", 0x2000001E, "Printer Configuration Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPrintPriority
      //(2000,0020)
      = const ElementDef("PrintPriority", 0x20000020, "Print Priority", VR.kCS, VM.k1, false);
  static const ElementDef kMediumType
      //(2000,0030)
      = const ElementDef("MediumType", 0x20000030, "Medium Type", VR.kCS, VM.k1, false);
  static const ElementDef kFilmDestination
      //(2000,0040)
      = const ElementDef("FilmDestination", 0x20000040, "Film Destination", VR.kCS, VM.k1, false);
  static const ElementDef kFilmSessionLabel
      //(2000,0050)
      = const ElementDef("FilmSessionLabel", 0x20000050, "Film Session Label", VR.kLO, VM.k1, false);
  static const ElementDef kMemoryAllocation
      //(2000,0060)
      = const ElementDef("MemoryAllocation", 0x20000060, "Memory Allocation", VR.kIS, VM.k1, false);
  static const ElementDef kMaximumMemoryAllocation
      //(2000,0061)
      = const ElementDef(
          "MaximumMemoryAllocation", 0x20000061, "Maximum Memory Allocation", VR.kIS, VM.k1, false);
  static const ElementDef kColorImagePrintingFlag
      //(2000,0062)
      = const ElementDef(
          "ColorImagePrintingFlag", 0x20000062, "Color Image Printing Flag", VR.kCS, VM.k1, true);
  static const ElementDef kCollationFlag
      //(2000,0063)
      = const ElementDef("CollationFlag", 0x20000063, "Collation Flag", VR.kCS, VM.k1, true);
  static const ElementDef kAnnotationFlag
      //(2000,0065)
      = const ElementDef("AnnotationFlag", 0x20000065, "Annotation Flag", VR.kCS, VM.k1, true);
  static const ElementDef kImageOverlayFlag
      //(2000,0067)
      = const ElementDef("ImageOverlayFlag", 0x20000067, "Image Overlay Flag", VR.kCS, VM.k1, true);
  static const ElementDef kPresentationLUTFlag
      //(2000,0069)
      = const ElementDef(
          "PresentationLUTFlag", 0x20000069, "Presentation LUT Flag", VR.kCS, VM.k1, true);
  static const ElementDef kImageBoxPresentationLUTFlag
      //(2000,006A)
      = const ElementDef("ImageBoxPresentationLUTFlag", 0x2000006A, "Image Box Presentation LUT Flag",
          VR.kCS, VM.k1, true);
  static const ElementDef kMemoryBitDepth
      //(2000,00A0)
      = const ElementDef("MemoryBitDepth", 0x200000A0, "Memory Bit Depth", VR.kUS, VM.k1, false);
  static const ElementDef kPrintingBitDepth
      //(2000,00A1)
      = const ElementDef("PrintingBitDepth", 0x200000A1, "Printing Bit Depth", VR.kUS, VM.k1, false);
  static const ElementDef kMediaInstalledSequence
      //(2000,00A2)
      = const ElementDef(
          "MediaInstalledSequence", 0x200000A2, "Media Installed Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kOtherMediaAvailableSequence
      //(2000,00A4)
      = const ElementDef("OtherMediaAvailableSequence", 0x200000A4, "Other Media Available Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSupportedImageDisplayFormatsSequence
      //(2000,00A8)
      = const ElementDef("SupportedImageDisplayFormatsSequence", 0x200000A8,
          "Supported Image Display Formats Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedFilmBoxSequence
      //(2000,0500)
      = const ElementDef("ReferencedFilmBoxSequence", 0x20000500, "Referenced Film Box Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedStoredPrintSequence
      //(2000,0510)
      = const ElementDef("ReferencedStoredPrintSequence", 0x20000510,
          "Referenced Stored Print Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kImageDisplayFormat
      //(2010,0010)
      =
      const ElementDef("ImageDisplayFormat", 0x20100010, "Image Display Format", VR.kST, VM.k1, false);
  static const ElementDef kAnnotationDisplayFormatID
      //(2010,0030)
      = const ElementDef("AnnotationDisplayFormatID", 0x20100030, "Annotation Display Format ID",
          VR.kCS, VM.k1, false);
  static const ElementDef kFilmOrientation
      //(2010,0040)
      = const ElementDef("FilmOrientation", 0x20100040, "Film Orientation", VR.kCS, VM.k1, false);
  static const ElementDef kFilmSizeID
      //(2010,0050)
      = const ElementDef("FilmSizeID", 0x20100050, "Film Size ID", VR.kCS, VM.k1, false);
  static const ElementDef kPrinterResolutionID
      //(2010,0052)
      = const ElementDef(
          "PrinterResolutionID", 0x20100052, "Printer Resolution ID", VR.kCS, VM.k1, false);
  static const ElementDef kDefaultPrinterResolutionID
      //(2010,0054)
      = const ElementDef("DefaultPrinterResolutionID", 0x20100054, "Default Printer Resolution ID",
          VR.kCS, VM.k1, false);
  static const ElementDef kMagnificationType
      //(2010,0060)
      = const ElementDef("MagnificationType", 0x20100060, "Magnification Type", VR.kCS, VM.k1, false);
  static const ElementDef kSmoothingType
      //(2010,0080)
      = const ElementDef("SmoothingType", 0x20100080, "Smoothing Type", VR.kCS, VM.k1, false);
  static const ElementDef kDefaultMagnificationType
      //(2010,00A6)
      = const ElementDef("DefaultMagnificationType", 0x201000A6, "Default Magnification Type", VR.kCS,
          VM.k1, false);
  static const ElementDef kOtherMagnificationTypesAvailable
      //(2010,00A7)
      = const ElementDef("OtherMagnificationTypesAvailable", 0x201000A7,
          "Other Magnification Types Available", VR.kCS, VM.k1_n, false);
  static const ElementDef kDefaultSmoothingType
      //(2010,00A8)
      = const ElementDef(
          "DefaultSmoothingType", 0x201000A8, "Default Smoothing Type", VR.kCS, VM.k1, false);
  static const ElementDef kOtherSmoothingTypesAvailable
      //(2010,00A9)
      = const ElementDef("OtherSmoothingTypesAvailable", 0x201000A9, "Other Smoothing Types Available",
          VR.kCS, VM.k1_n, false);
  static const ElementDef kBorderDensity
      //(2010,0100)
      = const ElementDef("BorderDensity", 0x20100100, "Border Density", VR.kCS, VM.k1, false);
  static const ElementDef kEmptyImageDensity
      //(2010,0110)
      = const ElementDef("EmptyImageDensity", 0x20100110, "Empty Image Density", VR.kCS, VM.k1, false);
  static const ElementDef kMinDensity
      //(2010,0120)
      = const ElementDef("MinDensity", 0x20100120, "Min Density", VR.kUS, VM.k1, false);
  static const ElementDef kMaxDensity
      //(2010,0130)
      = const ElementDef("MaxDensity", 0x20100130, "Max Density", VR.kUS, VM.k1, false);
  static const ElementDef kTrim
      //(2010,0140)
      = const ElementDef("Trim", 0x20100140, "Trim", VR.kCS, VM.k1, false);
  static const ElementDef kConfigurationInformation
      //(2010,0150)
      = const ElementDef("ConfigurationInformation", 0x20100150, "Configuration Information", VR.kST,
          VM.k1, false);
  static const ElementDef kConfigurationInformationDescription
      //(2010,0152)
      = const ElementDef("ConfigurationInformationDescription", 0x20100152,
          "Configuration Information Description", VR.kLT, VM.k1, false);
  static const ElementDef kMaximumCollatedFilms
      //(2010,0154)
      = const ElementDef(
          "MaximumCollatedFilms", 0x20100154, "Maximum Collated Films", VR.kIS, VM.k1, false);
  static const ElementDef kIllumination
      //(2010,015E)
      = const ElementDef("Illumination", 0x2010015E, "Illumination", VR.kUS, VM.k1, false);
  static const ElementDef kReflectedAmbientLight
      //(2010,0160)
      = const ElementDef(
          "ReflectedAmbientLight", 0x20100160, "Reflected Ambient Light", VR.kUS, VM.k1, false);
  static const ElementDef kPrinterPixelSpacing
      //(2010,0376)
      = const ElementDef(
          "PrinterPixelSpacing", 0x20100376, "Printer Pixel Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kReferencedFilmSessionSequence
      //(2010,0500)
      = const ElementDef("ReferencedFilmSessionSequence", 0x20100500,
          "Referenced Film Session Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedImageBoxSequence
      //(2010,0510)
      = const ElementDef("ReferencedImageBoxSequence", 0x20100510, "Referenced Image Box Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedBasicAnnotationBoxSequence
      //(2010,0520)
      = const ElementDef("ReferencedBasicAnnotationBoxSequence", 0x20100520,
          "Referenced Basic Annotation Box Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImageBoxPosition
      //(2020,0010)
      = const ElementDef("ImageBoxPosition", 0x20200010, "Image Box Position", VR.kUS, VM.k1, false);
  static const ElementDef kPolarity
      //(2020,0020)
      = const ElementDef("Polarity", 0x20200020, "Polarity", VR.kCS, VM.k1, false);
  static const ElementDef kRequestedImageSize
      //(2020,0030)
      =
      const ElementDef("RequestedImageSize", 0x20200030, "Requested Image Size", VR.kDS, VM.k1, false);
  static const ElementDef kRequestedDecimateCropBehavior
      //(2020,0040)
      = const ElementDef("RequestedDecimateCropBehavior", 0x20200040,
          "Requested Decimate/Crop Behavior", VR.kCS, VM.k1, false);
  static const ElementDef kRequestedResolutionID
      //(2020,0050)
      = const ElementDef(
          "RequestedResolutionID", 0x20200050, "Requested Resolution ID", VR.kCS, VM.k1, false);
  static const ElementDef kRequestedImageSizeFlag
      //(2020,00A0)
      = const ElementDef(
          "RequestedImageSizeFlag", 0x202000A0, "Requested Image Size Flag", VR.kCS, VM.k1, false);
  static const ElementDef kDecimateCropResult
      //(2020,00A2)
      =
      const ElementDef("DecimateCropResult", 0x202000A2, "Decimate/Crop Result", VR.kCS, VM.k1, false);
  static const ElementDef kBasicGrayscaleImageSequence
      //(2020,0110)
      = const ElementDef("BasicGrayscaleImageSequence", 0x20200110, "Basic Grayscale Image Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kBasicColorImageSequence
      //(2020,0111)
      = const ElementDef("BasicColorImageSequence", 0x20200111, "Basic Color Image Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kReferencedImageOverlayBoxSequence
      //(2020,0130)
      = const ElementDef("ReferencedImageOverlayBoxSequence", 0x20200130,
          "Referenced Image Overlay Box Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedVOILUTBoxSequence
      //(2020,0140)
      = const ElementDef("ReferencedVOILUTBoxSequence", 0x20200140, "Referenced VOI LUT Box Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kAnnotationPosition
      //(2030,0010)
      =
      const ElementDef("AnnotationPosition", 0x20300010, "Annotation Position", VR.kUS, VM.k1, false);
  static const ElementDef kTextString
      //(2030,0020)
      = const ElementDef("TextString", 0x20300020, "Text String", VR.kLO, VM.k1, false);
  static const ElementDef kReferencedOverlayPlaneSequence
      //(2040,0010)
      = const ElementDef("ReferencedOverlayPlaneSequence", 0x20400010,
          "Referenced Overlay Plane Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedOverlayPlaneGroups
      //(2040,0011)
      = const ElementDef("ReferencedOverlayPlaneGroups", 0x20400011, "Referenced Overlay Plane Groups",
          VR.kUS, VM.k1_99, true);
  static const ElementDef kOverlayPixelDataSequence
      //(2040,0020)
      = const ElementDef("OverlayPixelDataSequence", 0x20400020, "Overlay Pixel Data Sequence", VR.kSQ,
          VM.k1, true);
  static const ElementDef kOverlayMagnificationType
      //(2040,0060)
      = const ElementDef("OverlayMagnificationType", 0x20400060, "Overlay Magnification Type", VR.kCS,
          VM.k1, true);
  static const ElementDef kOverlaySmoothingType
      //(2040,0070)
      = const ElementDef(
          "OverlaySmoothingType", 0x20400070, "Overlay Smoothing Type", VR.kCS, VM.k1, true);
  static const ElementDef kOverlayOrImageMagnification
      //(2040,0072)
      = const ElementDef("OverlayOrImageMagnification", 0x20400072, "Overlay or Image Magnification",
          VR.kCS, VM.k1, true);
  static const ElementDef kMagnifyToNumberOfColumns
      //(2040,0074)
      = const ElementDef("MagnifyToNumberOfColumns", 0x20400074, "Magnify to Number of Columns",
          VR.kUS, VM.k1, true);
  static const ElementDef kOverlayForegroundDensity
      //(2040,0080)
      = const ElementDef("OverlayForegroundDensity", 0x20400080, "Overlay Foreground Density", VR.kCS,
          VM.k1, true);
  static const ElementDef kOverlayBackgroundDensity
      //(2040,0082)
      = const ElementDef("OverlayBackgroundDensity", 0x20400082, "Overlay Background Density", VR.kCS,
          VM.k1, true);
  static const ElementDef kOverlayMode
      //(2040,0090)
      = const ElementDef("OverlayMode", 0x20400090, "Overlay Mode", VR.kCS, VM.k1, true);
  static const ElementDef kThresholdDensity
      //(2040,0100)
      = const ElementDef("ThresholdDensity", 0x20400100, "Threshold Density", VR.kCS, VM.k1, true);
  static const ElementDef kReferencedImageBoxSequenceRetired
      //(2040,0500)
      = const ElementDef("ReferencedImageBoxSequenceRetired", 0x20400500,
          "Referenced Image Box Sequence (Retired)", VR.kSQ, VM.k1, true);
  static const ElementDef kPresentationLUTSequence
      //(2050,0010)
      = const ElementDef(
          "PresentationLUTSequence", 0x20500010, "Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPresentationLUTShape
      //(2050,0020)
      = const ElementDef(
          "PresentationLUTShape", 0x20500020, "Presentation LUT Shape", VR.kCS, VM.k1, false);
  static const ElementDef kReferencedPresentationLUTSequence
      //(2050,0500)
      = const ElementDef("ReferencedPresentationLUTSequence", 0x20500500,
          "Referenced Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPrintJobID
      //(2100,0010)
      = const ElementDef("PrintJobID", 0x21000010, "Print Job ID", VR.kSH, VM.k1, true);
  static const ElementDef kExecutionStatus
      //(2100,0020)
      = const ElementDef("ExecutionStatus", 0x21000020, "Execution Status", VR.kCS, VM.k1, false);
  static const ElementDef kExecutionStatusInfo
      //(2100,0030)
      = const ElementDef(
          "ExecutionStatusInfo", 0x21000030, "Execution Status Info", VR.kCS, VM.k1, false);
  static const ElementDef kCreationDate
      //(2100,0040)
      = const ElementDef("CreationDate", 0x21000040, "Creation Date", VR.kDA, VM.k1, false);
  static const ElementDef kCreationTime
      //(2100,0050)
      = const ElementDef("CreationTime", 0x21000050, "Creation Time", VR.kTM, VM.k1, false);
  static const ElementDef kOriginator
      //(2100,0070)
      = const ElementDef("Originator", 0x21000070, "Originator", VR.kAE, VM.k1, false);
  static const ElementDef kDestinationAE
      //(2100,0140)
      = const ElementDef("DestinationAE", 0x21000140, "Destination AE", VR.kAE, VM.k1, true);
  static const ElementDef kOwnerID
      //(2100,0160)
      = const ElementDef("OwnerID", 0x21000160, "Owner ID", VR.kSH, VM.k1, false);
  static const ElementDef kNumberOfFilms
      //(2100,0170)
      = const ElementDef("NumberOfFilms", 0x21000170, "Number of Films", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedPrintJobSequencePullStoredPrint
      //(2100,0500)
      = const ElementDef("ReferencedPrintJobSequencePullStoredPrint", 0x21000500,
          "Referenced Print Job Sequence (Pull Stored Print)", VR.kSQ, VM.k1, true);
  static const ElementDef kPrinterStatus
      //(2110,0010)
      = const ElementDef("PrinterStatus", 0x21100010, "Printer Status", VR.kCS, VM.k1, false);
  static const ElementDef kPrinterStatusInfo
      //(2110,0020)
      = const ElementDef("PrinterStatusInfo", 0x21100020, "Printer Status Info", VR.kCS, VM.k1, false);
  static const ElementDef kPrinterName
      //(2110,0030)
      = const ElementDef("PrinterName", 0x21100030, "Printer Name", VR.kLO, VM.k1, false);
  static const ElementDef kPrintQueueID
      //(2110,0099)
      = const ElementDef("PrintQueueID", 0x21100099, "Print Queue ID", VR.kSH, VM.k1, true);
  static const ElementDef kQueueStatus
      //(2120,0010)
      = const ElementDef("QueueStatus", 0x21200010, "Queue Status", VR.kCS, VM.k1, true);
  static const ElementDef kPrintJobDescriptionSequence
      //(2120,0050)
      = const ElementDef("PrintJobDescriptionSequence", 0x21200050, "Print Job Description Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kReferencedPrintJobSequence
      //(2120,0070)
      = const ElementDef("ReferencedPrintJobSequence", 0x21200070, "Referenced Print Job Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kPrintManagementCapabilitiesSequence
      //(2130,0010)
      = const ElementDef("PrintManagementCapabilitiesSequence", 0x21300010,
          "Print Management Capabilities Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kPrinterCharacteristicsSequence
      //(2130,0015)
      = const ElementDef("PrinterCharacteristicsSequence", 0x21300015,
          "Printer Characteristics Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kFilmBoxContentSequence
      //(2130,0030)
      = const ElementDef(
          "FilmBoxContentSequence", 0x21300030, "Film Box Content Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kImageBoxContentSequence
      //(2130,0040)
      = const ElementDef(
          "ImageBoxContentSequence", 0x21300040, "Image Box Content Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kAnnotationContentSequence
      //(2130,0050)
      = const ElementDef("AnnotationContentSequence", 0x21300050, "Annotation Content Sequence",
          VR.kSQ, VM.k1, true);
  static const ElementDef kImageOverlayBoxContentSequence
      //(2130,0060)
      = const ElementDef("ImageOverlayBoxContentSequence", 0x21300060,
          "Image Overlay Box Content Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kPresentationLUTContentSequence
      //(2130,0080)
      = const ElementDef("PresentationLUTContentSequence", 0x21300080,
          "Presentation LUT Content Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kProposedStudySequence
      //(2130,00A0)
      = const ElementDef(
          "ProposedStudySequence", 0x213000A0, "Proposed Study Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kOriginalImageSequence
      //(2130,00C0)
      = const ElementDef(
          "OriginalImageSequence", 0x213000C0, "Original Image Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kLabelUsingInformationExtractedFromInstances
      //(2200,0001)
      = const ElementDef("LabelUsingInformationExtractedFromInstances", 0x22000001,
          "Label Using Information Extracted From Instances", VR.kCS, VM.k1, false);
  static const ElementDef kLabelText
      //(2200,0002)
      = const ElementDef("LabelText", 0x22000002, "Label Text", VR.kUT, VM.k1, false);
  static const ElementDef kLabelStyleSelection
      //(2200,0003)
      = const ElementDef(
          "LabelStyleSelection", 0x22000003, "Label Style Selection", VR.kCS, VM.k1, false);
  static const ElementDef kMediaDisposition
      //(2200,0004)
      = const ElementDef("MediaDisposition", 0x22000004, "Media Disposition", VR.kLT, VM.k1, false);
  static const ElementDef kBarcodeValue
      //(2200,0005)
      = const ElementDef("BarcodeValue", 0x22000005, "Barcode Value", VR.kLT, VM.k1, false);
  static const ElementDef kBarcodeSymbology
      //(2200,0006)
      = const ElementDef("BarcodeSymbology", 0x22000006, "Barcode Symbology", VR.kCS, VM.k1, false);
  static const ElementDef kAllowMediaSplitting
      //(2200,0007)
      = const ElementDef(
          "AllowMediaSplitting", 0x22000007, "Allow Media Splitting", VR.kCS, VM.k1, false);
  static const ElementDef kIncludeNonDICOMObjects
      //(2200,0008)
      = const ElementDef(
          "IncludeNonDICOMObjects", 0x22000008, "Include Non-DICOM Objects", VR.kCS, VM.k1, false);
  static const ElementDef kIncludeDisplayApplication
      //(2200,0009)
      = const ElementDef("IncludeDisplayApplication", 0x22000009, "Include Display Application",
          VR.kCS, VM.k1, false);
  static const ElementDef kPreserveCompositeInstancesAfterMediaCreation
      //(2200,000A)
      = const ElementDef("PreserveCompositeInstancesAfterMediaCreation", 0x2200000A,
          "Preserve Composite Instances After Media Creation", VR.kCS, VM.k1, false);
  static const ElementDef kTotalNumberOfPiecesOfMediaCreated
      //(2200,000B)
      = const ElementDef("TotalNumberOfPiecesOfMediaCreated", 0x2200000B,
          "Total Number of Pieces of Media Created", VR.kUS, VM.k1, false);
  static const ElementDef kRequestedMediaApplicationProfile
      //(2200,000C)
      = const ElementDef("RequestedMediaApplicationProfile", 0x2200000C,
          "Requested Media Application Profile", VR.kLO, VM.k1, false);
  static const ElementDef kReferencedStorageMediaSequence
      //(2200,000D)
      = const ElementDef("ReferencedStorageMediaSequence", 0x2200000D,
          "Referenced Storage Media Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFailureAttributes
      //(2200,000E)
      =
      const ElementDef("FailureAttributes", 0x2200000E, "Failure Attributes", VR.kAT, VM.k1_n, false);
  static const ElementDef kAllowLossyCompression
      //(2200,000F)
      = const ElementDef(
          "AllowLossyCompression", 0x2200000F, "Allow Lossy Compression", VR.kCS, VM.k1, false);
  static const ElementDef kRequestPriority
      //(2200,0020)
      = const ElementDef("RequestPriority", 0x22000020, "Request Priority", VR.kCS, VM.k1, false);
  static const ElementDef kRTImageLabel
      //(3002,0002)
      = const ElementDef("RTImageLabel", 0x30020002, "RT Image Label", VR.kSH, VM.k1, false);
  static const ElementDef kRTImageName
      //(3002,0003)
      = const ElementDef("RTImageName", 0x30020003, "RT Image Name", VR.kLO, VM.k1, false);
  static const ElementDef kRTImageDescription
      //(3002,0004)
      =
      const ElementDef("RTImageDescription", 0x30020004, "RT Image Description", VR.kST, VM.k1, false);
  static const ElementDef kReportedValuesOrigin
      //(3002,000A)
      = const ElementDef(
          "ReportedValuesOrigin", 0x3002000A, "Reported Values Origin", VR.kCS, VM.k1, false);
  static const ElementDef kRTImagePlane
      //(3002,000C)
      = const ElementDef("RTImagePlane", 0x3002000C, "RT Image Plane", VR.kCS, VM.k1, false);
  static const ElementDef kXRayImageReceptorTranslation
      //(3002,000D)
      = const ElementDef("XRayImageReceptorTranslation", 0x3002000D,
          "X-Ray Image Receptor Translation", VR.kDS, VM.k3, false);
  static const ElementDef kXRayImageReceptorAngle
      //(3002,000E)
      = const ElementDef(
          "XRayImageReceptorAngle", 0x3002000E, "X-Ray Image Receptor Angle", VR.kDS, VM.k1, false);
  static const ElementDef kRTImageOrientation
      //(3002,0010)
      =
      const ElementDef("RTImageOrientation", 0x30020010, "RT Image Orientation", VR.kDS, VM.k6, false);
  static const ElementDef kImagePlanePixelSpacing
      //(3002,0011)
      = const ElementDef(
          "ImagePlanePixelSpacing", 0x30020011, "Image Plane Pixel Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kRTImagePosition
      //(3002,0012)
      = const ElementDef("RTImagePosition", 0x30020012, "RT Image Position", VR.kDS, VM.k2, false);
  static const ElementDef kRadiationMachineName
      //(3002,0020)
      = const ElementDef(
          "RadiationMachineName", 0x30020020, "Radiation Machine Name", VR.kSH, VM.k1, false);
  static const ElementDef kRadiationMachineSAD
      //(3002,0022)
      = const ElementDef(
          "RadiationMachineSAD", 0x30020022, "Radiation Machine SAD", VR.kDS, VM.k1, false);
  static const ElementDef kRadiationMachineSSD
      //(3002,0024)
      = const ElementDef(
          "RadiationMachineSSD", 0x30020024, "Radiation Machine SSD", VR.kDS, VM.k1, false);
  static const ElementDef kRTImageSID
      //(3002,0026)
      = const ElementDef("RTImageSID", 0x30020026, "RT Image SID", VR.kDS, VM.k1, false);
  static const ElementDef kSourceToReferenceObjectDistance
      //(3002,0028)
      = const ElementDef("SourceToReferenceObjectDistance", 0x30020028,
          "Source to Reference Object Distance", VR.kDS, VM.k1, false);
  static const ElementDef kFractionNumber
      //(3002,0029)
      = const ElementDef("FractionNumber", 0x30020029, "Fraction Number", VR.kIS, VM.k1, false);
  static const ElementDef kExposureSequence
      //(3002,0030)
      = const ElementDef("ExposureSequence", 0x30020030, "Exposure Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMetersetExposure
      //(3002,0032)
      = const ElementDef("MetersetExposure", 0x30020032, "Meterset Exposure", VR.kDS, VM.k1, false);
  static const ElementDef kDiaphragmPosition
      //(3002,0034)
      = const ElementDef("DiaphragmPosition", 0x30020034, "Diaphragm Position", VR.kDS, VM.k4, false);
  static const ElementDef kFluenceMapSequence
      //(3002,0040)
      =
      const ElementDef("FluenceMapSequence", 0x30020040, "Fluence Map Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFluenceDataSource
      //(3002,0041)
      = const ElementDef("FluenceDataSource", 0x30020041, "Fluence Data Source", VR.kCS, VM.k1, false);
  static const ElementDef kFluenceDataScale
      //(3002,0042)
      = const ElementDef("FluenceDataScale", 0x30020042, "Fluence Data Scale", VR.kDS, VM.k1, false);
  static const ElementDef kPrimaryFluenceModeSequence
      //(3002,0050)
      = const ElementDef("PrimaryFluenceModeSequence", 0x30020050, "Primary Fluence Mode Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kFluenceMode
      //(3002,0051)
      = const ElementDef("FluenceMode", 0x30020051, "Fluence Mode", VR.kCS, VM.k1, false);
  static const ElementDef kFluenceModeID
      //(3002,0052)
      = const ElementDef("FluenceModeID", 0x30020052, "Fluence Mode ID", VR.kSH, VM.k1, false);
  static const ElementDef kDVHType
      //(3004,0001)
      = const ElementDef("DVHType", 0x30040001, "DVH Type", VR.kCS, VM.k1, false);
  static const ElementDef kDoseUnits
      //(3004,0002)
      = const ElementDef("DoseUnits", 0x30040002, "Dose Units", VR.kCS, VM.k1, false);
  static const ElementDef kDoseType
      //(3004,0004)
      = const ElementDef("DoseType", 0x30040004, "Dose Type", VR.kCS, VM.k1, false);
  static const ElementDef kSpatialTransformOfDose
      //(3004,0005)
      = const ElementDef(
          "SpatialTransformOfDose", 0x30040005, "Spatial Transform of Dose", VR.kCS, VM.k1, false);
  static const ElementDef kDoseComment
      //(3004,0006)
      = const ElementDef("DoseComment", 0x30040006, "Dose Comment", VR.kLO, VM.k1, false);
  static const ElementDef kNormalizationPoint
      //(3004,0008)
      =
      const ElementDef("NormalizationPoint", 0x30040008, "Normalization Point", VR.kDS, VM.k3, false);
  static const ElementDef kDoseSummationType
      //(3004,000A)
      = const ElementDef("DoseSummationType", 0x3004000A, "Dose Summation Type", VR.kCS, VM.k1, false);
  static const ElementDef kGridFrameOffsetVector
      //(3004,000C)
      = const ElementDef(
          "GridFrameOffsetVector", 0x3004000C, "Grid Frame Offset Vector", VR.kDS, VM.k2_n, false);
  static const ElementDef kDoseGridScaling
      //(3004,000E)
      = const ElementDef("DoseGridScaling", 0x3004000E, "Dose Grid Scaling", VR.kDS, VM.k1, false);
  static const ElementDef kRTDoseROISequence
      //(3004,0010)
      =
      const ElementDef("RTDoseROISequence", 0x30040010, "RT Dose ROI Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDoseValue
      //(3004,0012)
      = const ElementDef("DoseValue", 0x30040012, "Dose Value", VR.kDS, VM.k1, false);
  static const ElementDef kTissueHeterogeneityCorrection
      //(3004,0014)
      = const ElementDef("TissueHeterogeneityCorrection", 0x30040014,
          "Tissue Heterogeneity Correction", VR.kCS, VM.k1_3, false);
  static const ElementDef kDVHNormalizationPoint
      //(3004,0040)
      = const ElementDef(
          "DVHNormalizationPoint", 0x30040040, "DVH Normalization Point", VR.kDS, VM.k3, false);
  static const ElementDef kDVHNormalizationDoseValue
      //(3004,0042)
      = const ElementDef("DVHNormalizationDoseValue", 0x30040042, "DVH Normalization Dose Value",
          VR.kDS, VM.k1, false);
  static const ElementDef kDVHSequence
      //(3004,0050)
      = const ElementDef("DVHSequence", 0x30040050, "DVH Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDVHDoseScaling
      //(3004,0052)
      = const ElementDef("DVHDoseScaling", 0x30040052, "DVH Dose Scaling", VR.kDS, VM.k1, false);
  static const ElementDef kDVHVolumeUnits
      //(3004,0054)
      = const ElementDef("DVHVolumeUnits", 0x30040054, "DVH Volume Units", VR.kCS, VM.k1, false);
  static const ElementDef kDVHNumberOfBins
      //(3004,0056)
      = const ElementDef("DVHNumberOfBins", 0x30040056, "DVH Number of Bins", VR.kIS, VM.k1, false);
  static const ElementDef kDVHData
      //(3004,0058)
      = const ElementDef("DVHData", 0x30040058, "DVH Data", VR.kDS, VM.k2_2n, false);
  static const ElementDef kDVHReferencedROISequence
      //(3004,0060)
      = const ElementDef("DVHReferencedROISequence", 0x30040060, "DVH Referenced ROI Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kDVHROIContributionType
      //(3004,0062)
      = const ElementDef(
          "DVHROIContributionType", 0x30040062, "DVH ROI Contribution Type", VR.kCS, VM.k1, false);
  static const ElementDef kDVHMinimumDose
      //(3004,0070)
      = const ElementDef("DVHMinimumDose", 0x30040070, "DVH Minimum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kDVHMaximumDose
      //(3004,0072)
      = const ElementDef("DVHMaximumDose", 0x30040072, "DVH Maximum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kDVHMeanDose
      //(3004,0074)
      = const ElementDef("DVHMeanDose", 0x30040074, "DVH Mean Dose", VR.kDS, VM.k1, false);
  static const ElementDef kStructureSetLabel
      //(3006,0002)
      = const ElementDef("StructureSetLabel", 0x30060002, "Structure Set Label", VR.kSH, VM.k1, false);
  static const ElementDef kStructureSetName
      //(3006,0004)
      = const ElementDef("StructureSetName", 0x30060004, "Structure Set Name", VR.kLO, VM.k1, false);
  static const ElementDef kStructureSetDescription
      //(3006,0006)
      = const ElementDef(
          "StructureSetDescription", 0x30060006, "Structure Set Description", VR.kST, VM.k1, false);
  static const ElementDef kStructureSetDate
      //(3006,0008)
      = const ElementDef("StructureSetDate", 0x30060008, "Structure Set Date", VR.kDA, VM.k1, false);
  static const ElementDef kStructureSetTime
      //(3006,0009)
      = const ElementDef("StructureSetTime", 0x30060009, "Structure Set Time", VR.kTM, VM.k1, false);
  static const ElementDef kReferencedFrameOfReferenceSequence
      //(3006,0010)
      = const ElementDef("ReferencedFrameOfReferenceSequence", 0x30060010,
          "Referenced Frame of Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRTReferencedStudySequence
      //(3006,0012)
      = const ElementDef("RTReferencedStudySequence", 0x30060012, "RT Referenced Study Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRTReferencedSeriesSequence
      //(3006,0014)
      = const ElementDef("RTReferencedSeriesSequence", 0x30060014, "RT Referenced Series Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kContourImageSequence
      //(3006,0016)
      = const ElementDef(
          "ContourImageSequence", 0x30060016, "Contour Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPredecessorStructureSetSequence
      //(3006,0018)
      = const ElementDef("PredecessorStructureSetSequence", 0x30060018,
          "Predecessor Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kStructureSetROISequence
      //(3006,0020)
      = const ElementDef("StructureSetROISequence", 0x30060020, "Structure Set ROI Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kROINumber
      //(3006,0022)
      = const ElementDef("ROINumber", 0x30060022, "ROI Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedFrameOfReferenceUID
      //(3006,0024)
      = const ElementDef("ReferencedFrameOfReferenceUID", 0x30060024,
          "Referenced Frame of Reference UID", VR.kUI, VM.k1, false);
  static const ElementDef kROIName
      //(3006,0026)
      = const ElementDef("ROIName", 0x30060026, "ROI Name", VR.kLO, VM.k1, false);
  static const ElementDef kROIDescription
      //(3006,0028)
      = const ElementDef("ROIDescription", 0x30060028, "ROI Description", VR.kST, VM.k1, false);
  static const ElementDef kROIDisplayColor
      //(3006,002A)
      = const ElementDef("ROIDisplayColor", 0x3006002A, "ROI Display Color", VR.kIS, VM.k3, false);
  static const ElementDef kROIVolume
      //(3006,002C)
      = const ElementDef("ROIVolume", 0x3006002C, "ROI Volume", VR.kDS, VM.k1, false);
  static const ElementDef kRTRelatedROISequence
      //(3006,0030)
      = const ElementDef(
          "RTRelatedROISequence", 0x30060030, "RT Related ROI Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRTROIRelationship
      //(3006,0033)
      = const ElementDef("RTROIRelationship", 0x30060033, "RT ROI Relationship", VR.kCS, VM.k1, false);
  static const ElementDef kROIGenerationAlgorithm
      //(3006,0036)
      = const ElementDef(
          "ROIGenerationAlgorithm", 0x30060036, "ROI Generation Algorithm", VR.kCS, VM.k1, false);
  static const ElementDef kROIGenerationDescription
      //(3006,0038)
      = const ElementDef("ROIGenerationDescription", 0x30060038, "ROI Generation Description", VR.kLO,
          VM.k1, false);
  static const ElementDef kROIContourSequence
      //(3006,0039)
      =
      const ElementDef("ROIContourSequence", 0x30060039, "ROI Contour Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContourSequence
      //(3006,0040)
      = const ElementDef("ContourSequence", 0x30060040, "Contour Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kContourGeometricType
      //(3006,0042)
      = const ElementDef(
          "ContourGeometricType", 0x30060042, "Contour Geometric Type", VR.kCS, VM.k1, false);
  static const ElementDef kContourSlabThickness
      //(3006,0044)
      = const ElementDef(
          "ContourSlabThickness", 0x30060044, "Contour Slab Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kContourOffsetVector
      //(3006,0045)
      = const ElementDef(
          "ContourOffsetVector", 0x30060045, "Contour Offset Vector", VR.kDS, VM.k3, false);
  static const ElementDef kNumberOfContourPoints
      //(3006,0046)
      = const ElementDef(
          "NumberOfContourPoints", 0x30060046, "Number of Contour Points", VR.kIS, VM.k1, false);
  static const ElementDef kContourNumber
      //(3006,0048)
      = const ElementDef("ContourNumber", 0x30060048, "Contour Number", VR.kIS, VM.k1, false);
  static const ElementDef kAttachedContours
      //(3006,0049)
      = const ElementDef("AttachedContours", 0x30060049, "Attached Contours", VR.kIS, VM.k1_n, false);
  static const ElementDef kContourData
      //(3006,0050)
      = const ElementDef("ContourData", 0x30060050, "Contour Data", VR.kDS, VM.k3_3n, false);
  static const ElementDef kRTROIObservationsSequence
      //(3006,0080)
      = const ElementDef("RTROIObservationsSequence", 0x30060080, "RT ROI Observations Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kObservationNumber
      //(3006,0082)
      = const ElementDef("ObservationNumber", 0x30060082, "Observation Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedROINumber
      //(3006,0084)
      = const ElementDef(
          "ReferencedROINumber", 0x30060084, "Referenced ROI Number", VR.kIS, VM.k1, false);
  static const ElementDef kROIObservationLabel
      //(3006,0085)
      = const ElementDef(
          "ROIObservationLabel", 0x30060085, "ROI Observation Label", VR.kSH, VM.k1, false);
  static const ElementDef kRTROIIdentificationCodeSequence
      //(3006,0086)
      = const ElementDef("RTROIIdentificationCodeSequence", 0x30060086,
          "RT ROI Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kROIObservationDescription
      //(3006,0088)
      = const ElementDef("ROIObservationDescription", 0x30060088, "ROI Observation Description",
          VR.kST, VM.k1, false);
  static const ElementDef kRelatedRTROIObservationsSequence
      //(3006,00A0)
      = const ElementDef("RelatedRTROIObservationsSequence", 0x300600A0,
          "Related RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRTROIInterpretedType
      //(3006,00A4)
      = const ElementDef(
          "RTROIInterpretedType", 0x300600A4, "RT ROI Interpreted Type", VR.kCS, VM.k1, false);
  static const ElementDef kROIInterpreter
      //(3006,00A6)
      = const ElementDef("ROIInterpreter", 0x300600A6, "ROI Interpreter", VR.kPN, VM.k1, false);
  static const ElementDef kROIPhysicalPropertiesSequence
      //(3006,00B0)
      = const ElementDef("ROIPhysicalPropertiesSequence", 0x300600B0,
          "ROI Physical Properties Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kROIPhysicalProperty
      //(3006,00B2)
      = const ElementDef(
          "ROIPhysicalProperty", 0x300600B2, "ROI Physical Property", VR.kCS, VM.k1, false);
  static const ElementDef kROIPhysicalPropertyValue
      //(3006,00B4)
      = const ElementDef("ROIPhysicalPropertyValue", 0x300600B4, "ROI Physical Property Value", VR.kDS,
          VM.k1, false);
  static const ElementDef kROIElementalCompositionSequence
      //(3006,00B6)
      = const ElementDef("ROIElementalCompositionSequence", 0x300600B6,
          "ROI Elemental Composition Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kROIElementalCompositionAtomicNumber
      //(3006,00B7)
      = const ElementDef("ROIElementalCompositionAtomicNumber", 0x300600B7,
          "ROI Elemental Composition Atomic Number", VR.kUS, VM.k1, false);
  static const ElementDef kROIElementalCompositionAtomicMassFraction
      //(3006,00B8)
      = const ElementDef("ROIElementalCompositionAtomicMassFraction", 0x300600B8,
          "ROI Elemental Composition Atomic Mass Fraction", VR.kFL, VM.k1, false);
  static const ElementDef kFrameOfReferenceRelationshipSequence
      //(3006,00C0)
      = const ElementDef("FrameOfReferenceRelationshipSequence", 0x300600C0,
          "Frame of Reference Relationship Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kRelatedFrameOfReferenceUID
      //(3006,00C2)
      = const ElementDef("RelatedFrameOfReferenceUID", 0x300600C2, "Related Frame of Reference UID",
          VR.kUI, VM.k1, true);
  static const ElementDef kFrameOfReferenceTransformationType
      //(3006,00C4)
      = const ElementDef("FrameOfReferenceTransformationType", 0x300600C4,
          "Frame of Reference Transformation Type", VR.kCS, VM.k1, true);
  static const ElementDef kFrameOfReferenceTransformationMatrix
      //(3006,00C6)
      = const ElementDef("FrameOfReferenceTransformationMatrix", 0x300600C6,
          "Frame of Reference Transformation Matrix", VR.kDS, VM.k16, false);
  static const ElementDef kFrameOfReferenceTransformationComment
      //(3006,00C8)
      = const ElementDef("FrameOfReferenceTransformationComment", 0x300600C8,
          "Frame of Reference Transformation Comment", VR.kLO, VM.k1, false);
  static const ElementDef kMeasuredDoseReferenceSequence
      //(3008,0010)
      = const ElementDef("MeasuredDoseReferenceSequence", 0x30080010,
          "Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kMeasuredDoseDescription
      //(3008,0012)
      = const ElementDef(
          "MeasuredDoseDescription", 0x30080012, "Measured Dose Description", VR.kST, VM.k1, false);
  static const ElementDef kMeasuredDoseType
      //(3008,0014)
      = const ElementDef("MeasuredDoseType", 0x30080014, "Measured Dose Type", VR.kCS, VM.k1, false);
  static const ElementDef kMeasuredDoseValue
      //(3008,0016)
      = const ElementDef("MeasuredDoseValue", 0x30080016, "Measured Dose Value", VR.kDS, VM.k1, false);
  static const ElementDef kTreatmentSessionBeamSequence
      //(3008,0020)
      = const ElementDef("TreatmentSessionBeamSequence", 0x30080020, "Treatment Session Beam Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTreatmentSessionIonBeamSequence
      //(3008,0021)
      = const ElementDef("TreatmentSessionIonBeamSequence", 0x30080021,
          "Treatment Session Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCurrentFractionNumber
      //(3008,0022)
      = const ElementDef(
          "CurrentFractionNumber", 0x30080022, "Current Fraction Number", VR.kIS, VM.k1, false);
  static const ElementDef kTreatmentControlPointDate
      //(3008,0024)
      = const ElementDef("TreatmentControlPointDate", 0x30080024, "Treatment Control Point Date",
          VR.kDA, VM.k1, false);
  static const ElementDef kTreatmentControlPointTime
      //(3008,0025)
      = const ElementDef("TreatmentControlPointTime", 0x30080025, "Treatment Control Point Time",
          VR.kTM, VM.k1, false);
  static const ElementDef kTreatmentTerminationStatus
      //(3008,002A)
      = const ElementDef("TreatmentTerminationStatus", 0x3008002A, "Treatment Termination Status",
          VR.kCS, VM.k1, false);
  static const ElementDef kTreatmentTerminationCode
      //(3008,002B)
      = const ElementDef("TreatmentTerminationCode", 0x3008002B, "Treatment Termination Code", VR.kSH,
          VM.k1, false);
  static const ElementDef kTreatmentVerificationStatus
      //(3008,002C)
      = const ElementDef("TreatmentVerificationStatus", 0x3008002C, "Treatment Verification Status",
          VR.kCS, VM.k1, false);
  static const ElementDef kReferencedTreatmentRecordSequence
      //(3008,0030)
      = const ElementDef("ReferencedTreatmentRecordSequence", 0x30080030,
          "Referenced Treatment Record Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecifiedPrimaryMeterset
      //(3008,0032)
      = const ElementDef("SpecifiedPrimaryMeterset", 0x30080032, "Specified Primary Meterset", VR.kDS,
          VM.k1, false);
  static const ElementDef kSpecifiedSecondaryMeterset
      //(3008,0033)
      = const ElementDef("SpecifiedSecondaryMeterset", 0x30080033, "Specified Secondary Meterset",
          VR.kDS, VM.k1, false);
  static const ElementDef kDeliveredPrimaryMeterset
      //(3008,0036)
      = const ElementDef("DeliveredPrimaryMeterset", 0x30080036, "Delivered Primary Meterset", VR.kDS,
          VM.k1, false);
  static const ElementDef kDeliveredSecondaryMeterset
      //(3008,0037)
      = const ElementDef("DeliveredSecondaryMeterset", 0x30080037, "Delivered Secondary Meterset",
          VR.kDS, VM.k1, false);
  static const ElementDef kSpecifiedTreatmentTime
      //(3008,003A)
      = const ElementDef(
          "SpecifiedTreatmentTime", 0x3008003A, "Specified Treatment Time", VR.kDS, VM.k1, false);
  static const ElementDef kDeliveredTreatmentTime
      //(3008,003B)
      = const ElementDef(
          "DeliveredTreatmentTime", 0x3008003B, "Delivered Treatment Time", VR.kDS, VM.k1, false);
  static const ElementDef kControlPointDeliverySequence
      //(3008,0040)
      = const ElementDef("ControlPointDeliverySequence", 0x30080040, "Control Point Delivery Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kIonControlPointDeliverySequence
      //(3008,0041)
      = const ElementDef("IonControlPointDeliverySequence", 0x30080041,
          "Ion Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecifiedMeterset
      //(3008,0042)
      = const ElementDef("SpecifiedMeterset", 0x30080042, "Specified Meterset", VR.kDS, VM.k1, false);
  static const ElementDef kDeliveredMeterset
      //(3008,0044)
      = const ElementDef("DeliveredMeterset", 0x30080044, "Delivered Meterset", VR.kDS, VM.k1, false);
  static const ElementDef kMetersetRateSet
      //(3008,0045)
      = const ElementDef("MetersetRateSet", 0x30080045, "Meterset Rate Set", VR.kFL, VM.k1, false);
  static const ElementDef kMetersetRateDelivered
      //(3008,0046)
      = const ElementDef(
          "MetersetRateDelivered", 0x30080046, "Meterset Rate Delivered", VR.kFL, VM.k1, false);
  static const ElementDef kScanSpotMetersetsDelivered
      //(3008,0047)
      = const ElementDef("ScanSpotMetersetsDelivered", 0x30080047, "Scan Spot Metersets Delivered",
          VR.kFL, VM.k1_n, false);
  static const ElementDef kDoseRateDelivered
      //(3008,0048)
      = const ElementDef("DoseRateDelivered", 0x30080048, "Dose Rate Delivered", VR.kDS, VM.k1, false);
  static const ElementDef kTreatmentSummaryCalculatedDoseReferenceSequence
      //(3008,0050)
      = const ElementDef("TreatmentSummaryCalculatedDoseReferenceSequence", 0x30080050,
          "Treatment Summary Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCumulativeDoseToDoseReference
      //(3008,0052)
      = const ElementDef("CumulativeDoseToDoseReference", 0x30080052,
          "Cumulative Dose to Dose Reference", VR.kDS, VM.k1, false);
  static const ElementDef kFirstTreatmentDate
      //(3008,0054)
      =
      const ElementDef("FirstTreatmentDate", 0x30080054, "First Treatment Date", VR.kDA, VM.k1, false);
  static const ElementDef kMostRecentTreatmentDate
      //(3008,0056)
      = const ElementDef("MostRecentTreatmentDate", 0x30080056, "Most Recent Treatment Date", VR.kDA,
          VM.k1, false);
  static const ElementDef kNumberOfFractionsDelivered
      //(3008,005A)
      = const ElementDef("NumberOfFractionsDelivered", 0x3008005A, "Number of Fractions Delivered",
          VR.kIS, VM.k1, false);
  static const ElementDef kOverrideSequence
      //(3008,0060)
      = const ElementDef("OverrideSequence", 0x30080060, "Override Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kParameterSequencePointer
      //(3008,0061)
      = const ElementDef("ParameterSequencePointer", 0x30080061, "Parameter Sequence Pointer", VR.kAT,
          VM.k1, false);
  static const ElementDef kOverrideParameterPointer
      //(3008,0062)
      = const ElementDef("OverrideParameterPointer", 0x30080062, "Override Parameter Pointer", VR.kAT,
          VM.k1, false);
  static const ElementDef kParameterItemIndex
      //(3008,0063)
      =
      const ElementDef("ParameterItemIndex", 0x30080063, "Parameter Item Index", VR.kIS, VM.k1, false);
  static const ElementDef kMeasuredDoseReferenceNumber
      //(3008,0064)
      = const ElementDef("MeasuredDoseReferenceNumber", 0x30080064, "Measured Dose Reference Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kParameterPointer
      //(3008,0065)
      = const ElementDef("ParameterPointer", 0x30080065, "Parameter Pointer", VR.kAT, VM.k1, false);
  static const ElementDef kOverrideReason
      //(3008,0066)
      = const ElementDef("OverrideReason", 0x30080066, "Override Reason", VR.kST, VM.k1, false);
  static const ElementDef kCorrectedParameterSequence
      //(3008,0068)
      = const ElementDef("CorrectedParameterSequence", 0x30080068, "Corrected Parameter Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCorrectionValue
      //(3008,006A)
      = const ElementDef("CorrectionValue", 0x3008006A, "Correction Value", VR.kFL, VM.k1, false);
  static const ElementDef kCalculatedDoseReferenceSequence
      //(3008,0070)
      = const ElementDef("CalculatedDoseReferenceSequence", 0x30080070,
          "Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCalculatedDoseReferenceNumber
      //(3008,0072)
      = const ElementDef("CalculatedDoseReferenceNumber", 0x30080072,
          "Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const ElementDef kCalculatedDoseReferenceDescription
      //(3008,0074)
      = const ElementDef("CalculatedDoseReferenceDescription", 0x30080074,
          "Calculated Dose Reference Description", VR.kST, VM.k1, false);
  static const ElementDef kCalculatedDoseReferenceDoseValue
      //(3008,0076)
      = const ElementDef("CalculatedDoseReferenceDoseValue", 0x30080076,
          "Calculated Dose Reference Dose Value", VR.kDS, VM.k1, false);
  static const ElementDef kStartMeterset
      //(3008,0078)
      = const ElementDef("StartMeterset", 0x30080078, "Start Meterset", VR.kDS, VM.k1, false);
  static const ElementDef kEndMeterset
      //(3008,007A)
      = const ElementDef("EndMeterset", 0x3008007A, "End Meterset", VR.kDS, VM.k1, false);
  static const ElementDef kReferencedMeasuredDoseReferenceSequence
      //(3008,0080)
      = const ElementDef("ReferencedMeasuredDoseReferenceSequence", 0x30080080,
          "Referenced Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedMeasuredDoseReferenceNumber
      //(3008,0082)
      = const ElementDef("ReferencedMeasuredDoseReferenceNumber", 0x30080082,
          "Referenced Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedCalculatedDoseReferenceSequence
      //(3008,0090)
      = const ElementDef("ReferencedCalculatedDoseReferenceSequence", 0x30080090,
          "Referenced Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedCalculatedDoseReferenceNumber
      //(3008,0092)
      = const ElementDef("ReferencedCalculatedDoseReferenceNumber", 0x30080092,
          "Referenced Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const ElementDef kBeamLimitingDeviceLeafPairsSequence
      //(3008,00A0)
      = const ElementDef("BeamLimitingDeviceLeafPairsSequence", 0x300800A0,
          "Beam Limiting Device Leaf Pairs Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedWedgeSequence
      //(3008,00B0)
      = const ElementDef(
          "RecordedWedgeSequence", 0x300800B0, "Recorded Wedge Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedCompensatorSequence
      //(3008,00C0)
      = const ElementDef("RecordedCompensatorSequence", 0x300800C0, "Recorded Compensator Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedBlockSequence
      //(3008,00D0)
      = const ElementDef(
          "RecordedBlockSequence", 0x300800D0, "Recorded Block Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTreatmentSummaryMeasuredDoseReferenceSequence
      //(3008,00E0)
      = const ElementDef("TreatmentSummaryMeasuredDoseReferenceSequence", 0x300800E0,
          "Treatment Summary Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedSnoutSequence
      //(3008,00F0)
      = const ElementDef(
          "RecordedSnoutSequence", 0x300800F0, "Recorded Snout Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedRangeShifterSequence
      //(3008,00F2)
      = const ElementDef("RecordedRangeShifterSequence", 0x300800F2, "Recorded Range Shifter Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedLateralSpreadingDeviceSequence
      //(3008,00F4)
      = const ElementDef("RecordedLateralSpreadingDeviceSequence", 0x300800F4,
          "Recorded Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedRangeModulatorSequence
      //(3008,00F6)
      = const ElementDef("RecordedRangeModulatorSequence", 0x300800F6,
          "Recorded Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRecordedSourceSequence
      //(3008,0100)
      = const ElementDef(
          "RecordedSourceSequence", 0x30080100, "Recorded Source Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceSerialNumber
      //(3008,0105)
      =
      const ElementDef("SourceSerialNumber", 0x30080105, "Source Serial Number", VR.kLO, VM.k1, false);
  static const ElementDef kTreatmentSessionApplicationSetupSequence
      //(3008,0110)
      = const ElementDef("TreatmentSessionApplicationSetupSequence", 0x30080110,
          "Treatment Session Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kApplicationSetupCheck
      //(3008,0116)
      = const ElementDef(
          "ApplicationSetupCheck", 0x30080116, "Application Setup Check", VR.kCS, VM.k1, false);
  static const ElementDef kRecordedBrachyAccessoryDeviceSequence
      //(3008,0120)
      = const ElementDef("RecordedBrachyAccessoryDeviceSequence", 0x30080120,
          "Recorded Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedBrachyAccessoryDeviceNumber
      //(3008,0122)
      = const ElementDef("ReferencedBrachyAccessoryDeviceNumber", 0x30080122,
          "Referenced Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const ElementDef kRecordedChannelSequence
      //(3008,0130)
      = const ElementDef(
          "RecordedChannelSequence", 0x30080130, "Recorded Channel Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSpecifiedChannelTotalTime
      //(3008,0132)
      = const ElementDef("SpecifiedChannelTotalTime", 0x30080132, "Specified Channel Total Time",
          VR.kDS, VM.k1, false);
  static const ElementDef kDeliveredChannelTotalTime
      //(3008,0134)
      = const ElementDef("DeliveredChannelTotalTime", 0x30080134, "Delivered Channel Total Time",
          VR.kDS, VM.k1, false);
  static const ElementDef kSpecifiedNumberOfPulses
      //(3008,0136)
      = const ElementDef("SpecifiedNumberOfPulses", 0x30080136, "Specified Number of Pulses", VR.kIS,
          VM.k1, false);
  static const ElementDef kDeliveredNumberOfPulses
      //(3008,0138)
      = const ElementDef("DeliveredNumberOfPulses", 0x30080138, "Delivered Number of Pulses", VR.kIS,
          VM.k1, false);
  static const ElementDef kSpecifiedPulseRepetitionInterval
      //(3008,013A)
      = const ElementDef("SpecifiedPulseRepetitionInterval", 0x3008013A,
          "Specified Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const ElementDef kDeliveredPulseRepetitionInterval
      //(3008,013C)
      = const ElementDef("DeliveredPulseRepetitionInterval", 0x3008013C,
          "Delivered Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const ElementDef kRecordedSourceApplicatorSequence
      //(3008,0140)
      = const ElementDef("RecordedSourceApplicatorSequence", 0x30080140,
          "Recorded Source Applicator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedSourceApplicatorNumber
      //(3008,0142)
      = const ElementDef("ReferencedSourceApplicatorNumber", 0x30080142,
          "Referenced Source Applicator Number", VR.kIS, VM.k1, false);
  static const ElementDef kRecordedChannelShieldSequence
      //(3008,0150)
      = const ElementDef("RecordedChannelShieldSequence", 0x30080150,
          "Recorded Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedChannelShieldNumber
      //(3008,0152)
      = const ElementDef("ReferencedChannelShieldNumber", 0x30080152,
          "Referenced Channel Shield Number", VR.kIS, VM.k1, false);
  static const ElementDef kBrachyControlPointDeliveredSequence
      //(3008,0160)
      = const ElementDef("BrachyControlPointDeliveredSequence", 0x30080160,
          "Brachy Control Point Delivered Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSafePositionExitDate
      //(3008,0162)
      = const ElementDef(
          "SafePositionExitDate", 0x30080162, "Safe Position Exit Date", VR.kDA, VM.k1, false);
  static const ElementDef kSafePositionExitTime
      //(3008,0164)
      = const ElementDef(
          "SafePositionExitTime", 0x30080164, "Safe Position Exit Time", VR.kTM, VM.k1, false);
  static const ElementDef kSafePositionReturnDate
      //(3008,0166)
      = const ElementDef(
          "SafePositionReturnDate", 0x30080166, "Safe Position Return Date", VR.kDA, VM.k1, false);
  static const ElementDef kSafePositionReturnTime
      //(3008,0168)
      = const ElementDef(
          "SafePositionReturnTime", 0x30080168, "Safe Position Return Time", VR.kTM, VM.k1, false);
  static const ElementDef kCurrentTreatmentStatus
      //(3008,0200)
      = const ElementDef(
          "CurrentTreatmentStatus", 0x30080200, "Current Treatment Status", VR.kCS, VM.k1, false);
  static const ElementDef kTreatmentStatusComment
      //(3008,0202)
      = const ElementDef(
          "TreatmentStatusComment", 0x30080202, "Treatment Status Comment", VR.kST, VM.k1, false);
  static const ElementDef kFractionGroupSummarySequence
      //(3008,0220)
      = const ElementDef("FractionGroupSummarySequence", 0x30080220, "Fraction Group Summary Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedFractionNumber
      //(3008,0223)
      = const ElementDef("ReferencedFractionNumber", 0x30080223, "Referenced Fraction Number", VR.kIS,
          VM.k1, false);
  static const ElementDef kFractionGroupType
      //(3008,0224)
      = const ElementDef("FractionGroupType", 0x30080224, "Fraction Group Type", VR.kCS, VM.k1, false);
  static const ElementDef kBeamStopperPosition
      //(3008,0230)
      = const ElementDef(
          "BeamStopperPosition", 0x30080230, "Beam Stopper Position", VR.kCS, VM.k1, false);
  static const ElementDef kFractionStatusSummarySequence
      //(3008,0240)
      = const ElementDef("FractionStatusSummarySequence", 0x30080240,
          "Fraction Status Summary Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTreatmentDate
      //(3008,0250)
      = const ElementDef("TreatmentDate", 0x30080250, "Treatment Date", VR.kDA, VM.k1, false);
  static const ElementDef kTreatmentTime
      //(3008,0251)
      = const ElementDef("TreatmentTime", 0x30080251, "Treatment Time", VR.kTM, VM.k1, false);
  static const ElementDef kRTPlanLabel
      //(300A,0002)
      = const ElementDef("RTPlanLabel", 0x300A0002, "RT Plan Label", VR.kSH, VM.k1, false);
  static const ElementDef kRTPlanName
      //(300A,0003)
      = const ElementDef("RTPlanName", 0x300A0003, "RT Plan Name", VR.kLO, VM.k1, false);
  static const ElementDef kRTPlanDescription
      //(300A,0004)
      = const ElementDef("RTPlanDescription", 0x300A0004, "RT Plan Description", VR.kST, VM.k1, false);
  static const ElementDef kRTPlanDate
      //(300A,0006)
      = const ElementDef("RTPlanDate", 0x300A0006, "RT Plan Date", VR.kDA, VM.k1, false);
  static const ElementDef kRTPlanTime
      //(300A,0007)
      = const ElementDef("RTPlanTime", 0x300A0007, "RT Plan Time", VR.kTM, VM.k1, false);
  static const ElementDef kTreatmentProtocols
      //(300A,0009)
      = const ElementDef(
          "TreatmentProtocols", 0x300A0009, "Treatment Protocols", VR.kLO, VM.k1_n, false);
  static const ElementDef kPlanIntent
      //(300A,000A)
      = const ElementDef("PlanIntent", 0x300A000A, "Plan Intent", VR.kCS, VM.k1, false);
  static const ElementDef kTreatmentSites
      //(300A,000B)
      = const ElementDef("TreatmentSites", 0x300A000B, "Treatment Sites", VR.kLO, VM.k1_n, false);
  static const ElementDef kRTPlanGeometry
      //(300A,000C)
      = const ElementDef("RTPlanGeometry", 0x300A000C, "RT Plan Geometry", VR.kCS, VM.k1, false);
  static const ElementDef kPrescriptionDescription
      //(300A,000E)
      = const ElementDef(
          "PrescriptionDescription", 0x300A000E, "Prescription Description", VR.kST, VM.k1, false);
  static const ElementDef kDoseReferenceSequence
      //(300A,0010)
      = const ElementDef(
          "DoseReferenceSequence", 0x300A0010, "Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kDoseReferenceNumber
      //(300A,0012)
      = const ElementDef(
          "DoseReferenceNumber", 0x300A0012, "Dose Reference Number", VR.kIS, VM.k1, false);
  static const ElementDef kDoseReferenceUID
      //(300A,0013)
      = const ElementDef("DoseReferenceUID", 0x300A0013, "Dose Reference UID", VR.kUI, VM.k1, false);
  static const ElementDef kDoseReferenceStructureType
      //(300A,0014)
      = const ElementDef("DoseReferenceStructureType", 0x300A0014, "Dose Reference Structure Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kNominalBeamEnergyUnit
      //(300A,0015)
      = const ElementDef(
          "NominalBeamEnergyUnit", 0x300A0015, "Nominal Beam Energy Unit", VR.kCS, VM.k1, false);
  static const ElementDef kDoseReferenceDescription
      //(300A,0016)
      = const ElementDef("DoseReferenceDescription", 0x300A0016, "Dose Reference Description", VR.kLO,
          VM.k1, false);
  static const ElementDef kDoseReferencePointCoordinates
      //(300A,0018)
      = const ElementDef("DoseReferencePointCoordinates", 0x300A0018,
          "Dose Reference Point Coordinates", VR.kDS, VM.k3, false);
  static const ElementDef kNominalPriorDose
      //(300A,001A)
      = const ElementDef("NominalPriorDose", 0x300A001A, "Nominal Prior Dose", VR.kDS, VM.k1, false);
  static const ElementDef kDoseReferenceType
      //(300A,0020)
      = const ElementDef("DoseReferenceType", 0x300A0020, "Dose Reference Type", VR.kCS, VM.k1, false);
  static const ElementDef kConstraintWeight
      //(300A,0021)
      = const ElementDef("ConstraintWeight", 0x300A0021, "Constraint Weight", VR.kDS, VM.k1, false);
  static const ElementDef kDeliveryWarningDose
      //(300A,0022)
      = const ElementDef(
          "DeliveryWarningDose", 0x300A0022, "Delivery Warning Dose", VR.kDS, VM.k1, false);
  static const ElementDef kDeliveryMaximumDose
      //(300A,0023)
      = const ElementDef(
          "DeliveryMaximumDose", 0x300A0023, "Delivery Maximum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kTargetMinimumDose
      //(300A,0025)
      = const ElementDef("TargetMinimumDose", 0x300A0025, "Target Minimum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kTargetPrescriptionDose
      //(300A,0026)
      = const ElementDef(
          "TargetPrescriptionDose", 0x300A0026, "Target Prescription Dose", VR.kDS, VM.k1, false);
  static const ElementDef kTargetMaximumDose
      //(300A,0027)
      = const ElementDef("TargetMaximumDose", 0x300A0027, "Target Maximum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kTargetUnderdoseVolumeFraction
      //(300A,0028)
      = const ElementDef("TargetUnderdoseVolumeFraction", 0x300A0028,
          "Target Underdose Volume Fraction", VR.kDS, VM.k1, false);
  static const ElementDef kOrganAtRiskFullVolumeDose
      //(300A,002A)
      = const ElementDef("OrganAtRiskFullVolumeDose", 0x300A002A, "Organ at Risk Full-volume Dose",
          VR.kDS, VM.k1, false);
  static const ElementDef kOrganAtRiskLimitDose
      //(300A,002B)
      = const ElementDef(
          "OrganAtRiskLimitDose", 0x300A002B, "Organ at Risk Limit Dose", VR.kDS, VM.k1, false);
  static const ElementDef kOrganAtRiskMaximumDose
      //(300A,002C)
      = const ElementDef(
          "OrganAtRiskMaximumDose", 0x300A002C, "Organ at Risk Maximum Dose", VR.kDS, VM.k1, false);
  static const ElementDef kOrganAtRiskOverdoseVolumeFraction
      //(300A,002D)
      = const ElementDef("OrganAtRiskOverdoseVolumeFraction", 0x300A002D,
          "Organ at Risk Overdose Volume Fraction", VR.kDS, VM.k1, false);
  static const ElementDef kToleranceTableSequence
      //(300A,0040)
      = const ElementDef(
          "ToleranceTableSequence", 0x300A0040, "Tolerance Table Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kToleranceTableNumber
      //(300A,0042)
      = const ElementDef(
          "ToleranceTableNumber", 0x300A0042, "Tolerance Table Number", VR.kIS, VM.k1, false);
  static const ElementDef kToleranceTableLabel
      //(300A,0043)
      = const ElementDef(
          "ToleranceTableLabel", 0x300A0043, "Tolerance Table Label", VR.kSH, VM.k1, false);
  static const ElementDef kGantryAngleTolerance
      //(300A,0044)
      = const ElementDef(
          "GantryAngleTolerance", 0x300A0044, "Gantry Angle Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kBeamLimitingDeviceAngleTolerance
      //(300A,0046)
      = const ElementDef("BeamLimitingDeviceAngleTolerance", 0x300A0046,
          "Beam Limiting Device Angle Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kBeamLimitingDeviceToleranceSequence
      //(300A,0048)
      = const ElementDef("BeamLimitingDeviceToleranceSequence", 0x300A0048,
          "Beam Limiting Device Tolerance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBeamLimitingDevicePositionTolerance
      //(300A,004A)
      = const ElementDef("BeamLimitingDevicePositionTolerance", 0x300A004A,
          "Beam Limiting Device Position Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kSnoutPositionTolerance
      //(300A,004B)
      = const ElementDef(
          "SnoutPositionTolerance", 0x300A004B, "Snout Position Tolerance", VR.kFL, VM.k1, false);
  static const ElementDef kPatientSupportAngleTolerance
      //(300A,004C)
      = const ElementDef("PatientSupportAngleTolerance", 0x300A004C, "Patient Support Angle Tolerance",
          VR.kDS, VM.k1, false);
  static const ElementDef kTableTopEccentricAngleTolerance
      //(300A,004E)
      = const ElementDef("TableTopEccentricAngleTolerance", 0x300A004E,
          "Table Top Eccentric Angle Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopPitchAngleTolerance
      //(300A,004F)
      = const ElementDef("TableTopPitchAngleTolerance", 0x300A004F, "Table Top Pitch Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableTopRollAngleTolerance
      //(300A,0050)
      = const ElementDef("TableTopRollAngleTolerance", 0x300A0050, "Table Top Roll Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const ElementDef kTableTopVerticalPositionTolerance
      //(300A,0051)
      = const ElementDef("TableTopVerticalPositionTolerance", 0x300A0051,
          "Table Top Vertical Position Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopLongitudinalPositionTolerance
      //(300A,0052)
      = const ElementDef("TableTopLongitudinalPositionTolerance", 0x300A0052,
          "Table Top Longitudinal Position Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopLateralPositionTolerance
      //(300A,0053)
      = const ElementDef("TableTopLateralPositionTolerance", 0x300A0053,
          "Table Top Lateral Position Tolerance", VR.kDS, VM.k1, false);
  static const ElementDef kRTPlanRelationship
      //(300A,0055)
      =
      const ElementDef("RTPlanRelationship", 0x300A0055, "RT Plan Relationship", VR.kCS, VM.k1, false);
  static const ElementDef kFractionGroupSequence
      //(300A,0070)
      = const ElementDef(
          "FractionGroupSequence", 0x300A0070, "Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFractionGroupNumber
      //(300A,0071)
      = const ElementDef(
          "FractionGroupNumber", 0x300A0071, "Fraction Group Number", VR.kIS, VM.k1, false);
  static const ElementDef kFractionGroupDescription
      //(300A,0072)
      = const ElementDef("FractionGroupDescription", 0x300A0072, "Fraction Group Description", VR.kLO,
          VM.k1, false);
  static const ElementDef kNumberOfFractionsPlanned
      //(300A,0078)
      = const ElementDef("NumberOfFractionsPlanned", 0x300A0078, "Number of Fractions Planned", VR.kIS,
          VM.k1, false);
  static const ElementDef kNumberOfFractionPatternDigitsPerDay
      //(300A,0079)
      = const ElementDef("NumberOfFractionPatternDigitsPerDay", 0x300A0079,
          "Number of Fraction Pattern Digits Per Day", VR.kIS, VM.k1, false);
  static const ElementDef kRepeatFractionCycleLength
      //(300A,007A)
      = const ElementDef("RepeatFractionCycleLength", 0x300A007A, "Repeat Fraction Cycle Length",
          VR.kIS, VM.k1, false);
  static const ElementDef kFractionPattern
      //(300A,007B)
      = const ElementDef("FractionPattern", 0x300A007B, "Fraction Pattern", VR.kLT, VM.k1, false);
  static const ElementDef kNumberOfBeams
      //(300A,0080)
      = const ElementDef("NumberOfBeams", 0x300A0080, "Number of Beams", VR.kIS, VM.k1, false);
  static const ElementDef kBeamDoseSpecificationPoint
      //(300A,0082)
      = const ElementDef("BeamDoseSpecificationPoint", 0x300A0082, "Beam Dose Specification Point",
          VR.kDS, VM.k3, false);
  static const ElementDef kBeamDose
      //(300A,0084)
      = const ElementDef("BeamDose", 0x300A0084, "Beam Dose", VR.kDS, VM.k1, false);
  static const ElementDef kBeamMeterset
      //(300A,0086)
      = const ElementDef("BeamMeterset", 0x300A0086, "Beam Meterset", VR.kDS, VM.k1, false);
  static const ElementDef kBeamDosePointDepth
      //(300A,0088)
      =
      const ElementDef("BeamDosePointDepth", 0x300A0088, "Beam Dose Point Depth", VR.kFL, VM.k1, true);
  static const ElementDef kBeamDosePointEquivalentDepth
      //(300A,0089)
      = const ElementDef("BeamDosePointEquivalentDepth", 0x300A0089,
          "Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, true);
  static const ElementDef kBeamDosePointSSD
      //(300A,008A)
      = const ElementDef("BeamDosePointSSD", 0x300A008A, "Beam Dose Point SSD", VR.kFL, VM.k1, true);
  static const ElementDef kBeamDoseMeaning
      //(300A,008B)
      = const ElementDef("BeamDoseMeaning", 0x300A008B, "Beam Dose Meaning", VR.kCS, VM.k1, false);
  static const ElementDef kBeamDoseVerificationControlPointSequence
      //(300A,008C)
      = const ElementDef("BeamDoseVerificationControlPointSequence", 0x300A008C,
          "Beam Dose Verification Control Point Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAverageBeamDosePointDepth
      //(300A,008D)
      = const ElementDef("AverageBeamDosePointDepth", 0x300A008D, "Average Beam Dose Point Depth",
          VR.kFL, VM.k1, false);
  static const ElementDef kAverageBeamDosePointEquivalentDepth
      //(300A,008E)
      = const ElementDef("AverageBeamDosePointEquivalentDepth", 0x300A008E,
          "Average Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, false);
  static const ElementDef kAverageBeamDosePointSSD
      //(300A,008F)
      = const ElementDef("AverageBeamDosePointSSD", 0x300A008F, "Average Beam Dose Point SSD", VR.kFL,
          VM.k1, false);
  static const ElementDef kNumberOfBrachyApplicationSetups
      //(300A,00A0)
      = const ElementDef("NumberOfBrachyApplicationSetups", 0x300A00A0,
          "Number of Brachy Application Setups", VR.kIS, VM.k1, false);
  static const ElementDef kBrachyApplicationSetupDoseSpecificationPoint
      //(300A,00A2)
      = const ElementDef("BrachyApplicationSetupDoseSpecificationPoint", 0x300A00A2,
          "Brachy Application Setup Dose Specification Point", VR.kDS, VM.k3, false);
  static const ElementDef kBrachyApplicationSetupDose
      //(300A,00A4)
      = const ElementDef("BrachyApplicationSetupDose", 0x300A00A4, "Brachy Application Setup Dose",
          VR.kDS, VM.k1, false);
  static const ElementDef kBeamSequence
      //(300A,00B0)
      = const ElementDef("BeamSequence", 0x300A00B0, "Beam Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTreatmentMachineName
      //(300A,00B2)
      = const ElementDef(
          "TreatmentMachineName", 0x300A00B2, "Treatment Machine Name", VR.kSH, VM.k1, false);
  static const ElementDef kPrimaryDosimeterUnit
      //(300A,00B3)
      = const ElementDef(
          "PrimaryDosimeterUnit", 0x300A00B3, "Primary Dosimeter Unit", VR.kCS, VM.k1, false);
  static const ElementDef kSourceAxisDistance
      //(300A,00B4)
      =
      const ElementDef("SourceAxisDistance", 0x300A00B4, "Source-Axis Distance", VR.kDS, VM.k1, false);
  static const ElementDef kBeamLimitingDeviceSequence
      //(300A,00B6)
      = const ElementDef("BeamLimitingDeviceSequence", 0x300A00B6, "Beam Limiting Device Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRTBeamLimitingDeviceType
      //(300A,00B8)
      = const ElementDef("RTBeamLimitingDeviceType", 0x300A00B8, "RT Beam Limiting Device Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kSourceToBeamLimitingDeviceDistance
      //(300A,00BA)
      = const ElementDef("SourceToBeamLimitingDeviceDistance", 0x300A00BA,
          "Source to Beam Limiting Device Distance", VR.kDS, VM.k1, false);
  static const ElementDef kIsocenterToBeamLimitingDeviceDistance
      //(300A,00BB)
      = const ElementDef("IsocenterToBeamLimitingDeviceDistance", 0x300A00BB,
          "Isocenter to Beam Limiting Device Distance", VR.kFL, VM.k1, false);
  static const ElementDef kNumberOfLeafJawPairs
      //(300A,00BC)
      = const ElementDef(
          "NumberOfLeafJawPairs", 0x300A00BC, "Number of Leaf/Jaw Pairs", VR.kIS, VM.k1, false);
  static const ElementDef kLeafPositionBoundaries
      //(300A,00BE)
      = const ElementDef(
          "LeafPositionBoundaries", 0x300A00BE, "Leaf Position Boundaries", VR.kDS, VM.k3_n, false);
  static const ElementDef kBeamNumber
      //(300A,00C0)
      = const ElementDef("BeamNumber", 0x300A00C0, "Beam Number", VR.kIS, VM.k1, false);
  static const ElementDef kBeamName
      //(300A,00C2)
      = const ElementDef("BeamName", 0x300A00C2, "Beam Name", VR.kLO, VM.k1, false);
  static const ElementDef kBeamDescription
      //(300A,00C3)
      = const ElementDef("BeamDescription", 0x300A00C3, "Beam Description", VR.kST, VM.k1, false);
  static const ElementDef kBeamType
      //(300A,00C4)
      = const ElementDef("BeamType", 0x300A00C4, "Beam Type", VR.kCS, VM.k1, false);
  static const ElementDef kRadiationType
      //(300A,00C6)
      = const ElementDef("RadiationType", 0x300A00C6, "Radiation Type", VR.kCS, VM.k1, false);
  static const ElementDef kHighDoseTechniqueType
      //(300A,00C7)
      = const ElementDef(
          "HighDoseTechniqueType", 0x300A00C7, "High-Dose Technique Type", VR.kCS, VM.k1, false);
  static const ElementDef kReferenceImageNumber
      //(300A,00C8)
      = const ElementDef(
          "ReferenceImageNumber", 0x300A00C8, "Reference Image Number", VR.kIS, VM.k1, false);
  static const ElementDef kPlannedVerificationImageSequence
      //(300A,00CA)
      = const ElementDef("PlannedVerificationImageSequence", 0x300A00CA,
          "Planned Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kImagingDeviceSpecificAcquisitionParameters
      //(300A,00CC)
      = const ElementDef("ImagingDeviceSpecificAcquisitionParameters", 0x300A00CC,
          "Imaging Device-Specific Acquisition Parameters", VR.kLO, VM.k1_n, false);
  static const ElementDef kTreatmentDeliveryType
      //(300A,00CE)
      = const ElementDef(
          "TreatmentDeliveryType", 0x300A00CE, "Treatment Delivery Type", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfWedges
      //(300A,00D0)
      = const ElementDef("NumberOfWedges", 0x300A00D0, "Number of Wedges", VR.kIS, VM.k1, false);
  static const ElementDef kWedgeSequence
      //(300A,00D1)
      = const ElementDef("WedgeSequence", 0x300A00D1, "Wedge Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kWedgeNumber
      //(300A,00D2)
      = const ElementDef("WedgeNumber", 0x300A00D2, "Wedge Number", VR.kIS, VM.k1, false);
  static const ElementDef kWedgeType
      //(300A,00D3)
      = const ElementDef("WedgeType", 0x300A00D3, "Wedge Type", VR.kCS, VM.k1, false);
  static const ElementDef kWedgeID
      //(300A,00D4)
      = const ElementDef("WedgeID", 0x300A00D4, "Wedge ID", VR.kSH, VM.k1, false);
  static const ElementDef kWedgeAngle
      //(300A,00D5)
      = const ElementDef("WedgeAngle", 0x300A00D5, "Wedge Angle", VR.kIS, VM.k1, false);
  static const ElementDef kWedgeFactor
      //(300A,00D6)
      = const ElementDef("WedgeFactor", 0x300A00D6, "Wedge Factor", VR.kDS, VM.k1, false);
  static const ElementDef kTotalWedgeTrayWaterEquivalentThickness
      //(300A,00D7)
      = const ElementDef("TotalWedgeTrayWaterEquivalentThickness", 0x300A00D7,
          "Total Wedge Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kWedgeOrientation
      //(300A,00D8)
      = const ElementDef("WedgeOrientation", 0x300A00D8, "Wedge Orientation", VR.kDS, VM.k1, false);
  static const ElementDef kIsocenterToWedgeTrayDistance
      //(300A,00D9)
      = const ElementDef("IsocenterToWedgeTrayDistance", 0x300A00D9,
          "Isocenter to Wedge Tray Distance", VR.kFL, VM.k1, false);
  static const ElementDef kSourceToWedgeTrayDistance
      //(300A,00DA)
      = const ElementDef("SourceToWedgeTrayDistance", 0x300A00DA, "Source to Wedge Tray Distance",
          VR.kDS, VM.k1, false);
  static const ElementDef kWedgeThinEdgePosition
      //(300A,00DB)
      = const ElementDef(
          "WedgeThinEdgePosition", 0x300A00DB, "Wedge Thin Edge Position", VR.kFL, VM.k1, false);
  static const ElementDef kBolusID
      //(300A,00DC)
      = const ElementDef("BolusID", 0x300A00DC, "Bolus ID", VR.kSH, VM.k1, false);
  static const ElementDef kBolusDescription
      //(300A,00DD)
      = const ElementDef("BolusDescription", 0x300A00DD, "Bolus Description", VR.kST, VM.k1, false);
  static const ElementDef kNumberOfCompensators
      //(300A,00E0)
      = const ElementDef(
          "NumberOfCompensators", 0x300A00E0, "Number of Compensators", VR.kIS, VM.k1, false);
  static const ElementDef kMaterialID
      //(300A,00E1)
      = const ElementDef("MaterialID", 0x300A00E1, "Material ID", VR.kSH, VM.k1, false);
  static const ElementDef kTotalCompensatorTrayFactor
      //(300A,00E2)
      = const ElementDef("TotalCompensatorTrayFactor", 0x300A00E2, "Total Compensator Tray Factor",
          VR.kDS, VM.k1, false);
  static const ElementDef kCompensatorSequence
      //(300A,00E3)
      = const ElementDef(
          "CompensatorSequence", 0x300A00E3, "Compensator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCompensatorNumber
      //(300A,00E4)
      = const ElementDef("CompensatorNumber", 0x300A00E4, "Compensator Number", VR.kIS, VM.k1, false);
  static const ElementDef kCompensatorID
      //(300A,00E5)
      = const ElementDef("CompensatorID", 0x300A00E5, "Compensator ID", VR.kSH, VM.k1, false);
  static const ElementDef kSourceToCompensatorTrayDistance
      //(300A,00E6)
      = const ElementDef("SourceToCompensatorTrayDistance", 0x300A00E6,
          "Source to Compensator Tray Distance", VR.kDS, VM.k1, false);
  static const ElementDef kCompensatorRows
      //(300A,00E7)
      = const ElementDef("CompensatorRows", 0x300A00E7, "Compensator Rows", VR.kIS, VM.k1, false);
  static const ElementDef kCompensatorColumns
      //(300A,00E8)
      =
      const ElementDef("CompensatorColumns", 0x300A00E8, "Compensator Columns", VR.kIS, VM.k1, false);
  static const ElementDef kCompensatorPixelSpacing
      //(300A,00E9)
      = const ElementDef(
          "CompensatorPixelSpacing", 0x300A00E9, "Compensator Pixel Spacing", VR.kDS, VM.k2, false);
  static const ElementDef kCompensatorPosition
      //(300A,00EA)
      = const ElementDef(
          "CompensatorPosition", 0x300A00EA, "Compensator Position", VR.kDS, VM.k2, false);
  static const ElementDef kCompensatorTransmissionData
      //(300A,00EB)
      = const ElementDef("CompensatorTransmissionData", 0x300A00EB, "Compensator Transmission Data",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kCompensatorThicknessData
      //(300A,00EC)
      = const ElementDef("CompensatorThicknessData", 0x300A00EC, "Compensator Thickness Data", VR.kDS,
          VM.k1_n, false);
  static const ElementDef kNumberOfBoli
      //(300A,00ED)
      = const ElementDef("NumberOfBoli", 0x300A00ED, "Number of Boli", VR.kIS, VM.k1, false);
  static const ElementDef kCompensatorType
      //(300A,00EE)
      = const ElementDef("CompensatorType", 0x300A00EE, "Compensator Type", VR.kCS, VM.k1, false);
  static const ElementDef kCompensatorTrayID
      //(300A,00EF)
      = const ElementDef("CompensatorTrayID", 0x300A00EF, "Compensator Tray ID", VR.kSH, VM.k1, false);
  static const ElementDef kNumberOfBlocks
      //(300A,00F0)
      = const ElementDef("NumberOfBlocks", 0x300A00F0, "Number of Blocks", VR.kIS, VM.k1, false);
  static const ElementDef kTotalBlockTrayFactor
      //(300A,00F2)
      = const ElementDef(
          "TotalBlockTrayFactor", 0x300A00F2, "Total Block Tray Factor", VR.kDS, VM.k1, false);
  static const ElementDef kTotalBlockTrayWaterEquivalentThickness
      //(300A,00F3)
      = const ElementDef("TotalBlockTrayWaterEquivalentThickness", 0x300A00F3,
          "Total Block Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kBlockSequence
      //(300A,00F4)
      = const ElementDef("BlockSequence", 0x300A00F4, "Block Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBlockTrayID
      //(300A,00F5)
      = const ElementDef("BlockTrayID", 0x300A00F5, "Block Tray ID", VR.kSH, VM.k1, false);
  static const ElementDef kSourceToBlockTrayDistance
      //(300A,00F6)
      = const ElementDef("SourceToBlockTrayDistance", 0x300A00F6, "Source to Block Tray Distance",
          VR.kDS, VM.k1, false);
  static const ElementDef kIsocenterToBlockTrayDistance
      //(300A,00F7)
      = const ElementDef("IsocenterToBlockTrayDistance", 0x300A00F7,
          "Isocenter to Block Tray Distance", VR.kFL, VM.k1, false);
  static const ElementDef kBlockType
      //(300A,00F8)
      = const ElementDef("BlockType", 0x300A00F8, "Block Type", VR.kCS, VM.k1, false);
  static const ElementDef kAccessoryCode
      //(300A,00F9)
      = const ElementDef("AccessoryCode", 0x300A00F9, "Accessory Code", VR.kLO, VM.k1, false);
  static const ElementDef kBlockDivergence
      //(300A,00FA)
      = const ElementDef("BlockDivergence", 0x300A00FA, "Block Divergence", VR.kCS, VM.k1, false);
  static const ElementDef kBlockMountingPosition
      //(300A,00FB)
      = const ElementDef(
          "BlockMountingPosition", 0x300A00FB, "Block Mounting Position", VR.kCS, VM.k1, false);
  static const ElementDef kBlockNumber
      //(300A,00FC)
      = const ElementDef("BlockNumber", 0x300A00FC, "Block Number", VR.kIS, VM.k1, false);
  static const ElementDef kBlockName
      //(300A,00FE)
      = const ElementDef("BlockName", 0x300A00FE, "Block Name", VR.kLO, VM.k1, false);
  static const ElementDef kBlockThickness
      //(300A,0100)
      = const ElementDef("BlockThickness", 0x300A0100, "Block Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kBlockTransmission
      //(300A,0102)
      = const ElementDef("BlockTransmission", 0x300A0102, "Block Transmission", VR.kDS, VM.k1, false);
  static const ElementDef kBlockNumberOfPoints
      //(300A,0104)
      = const ElementDef(
          "BlockNumberOfPoints", 0x300A0104, "Block Number of Points", VR.kIS, VM.k1, false);
  static const ElementDef kBlockData
      //(300A,0106)
      = const ElementDef("BlockData", 0x300A0106, "Block Data", VR.kDS, VM.k2_2n, false);
  static const ElementDef kApplicatorSequence
      //(300A,0107)
      =
      const ElementDef("ApplicatorSequence", 0x300A0107, "Applicator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kApplicatorID
      //(300A,0108)
      = const ElementDef("ApplicatorID", 0x300A0108, "Applicator ID", VR.kSH, VM.k1, false);
  static const ElementDef kApplicatorType
      //(300A,0109)
      = const ElementDef("ApplicatorType", 0x300A0109, "Applicator Type", VR.kCS, VM.k1, false);
  static const ElementDef kApplicatorDescription
      //(300A,010A)
      = const ElementDef(
          "ApplicatorDescription", 0x300A010A, "Applicator Description", VR.kLO, VM.k1, false);
  static const ElementDef kCumulativeDoseReferenceCoefficient
      //(300A,010C)
      = const ElementDef("CumulativeDoseReferenceCoefficient", 0x300A010C,
          "Cumulative Dose Reference Coefficient", VR.kDS, VM.k1, false);
  static const ElementDef kFinalCumulativeMetersetWeight
      //(300A,010E)
      = const ElementDef("FinalCumulativeMetersetWeight", 0x300A010E,
          "Final Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const ElementDef kNumberOfControlPoints
      //(300A,0110)
      = const ElementDef(
          "NumberOfControlPoints", 0x300A0110, "Number of Control Points", VR.kIS, VM.k1, false);
  static const ElementDef kControlPointSequence
      //(300A,0111)
      = const ElementDef(
          "ControlPointSequence", 0x300A0111, "Control Point Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kControlPointIndex
      //(300A,0112)
      = const ElementDef("ControlPointIndex", 0x300A0112, "Control Point Index", VR.kIS, VM.k1, false);
  static const ElementDef kNominalBeamEnergy
      //(300A,0114)
      = const ElementDef("NominalBeamEnergy", 0x300A0114, "Nominal Beam Energy", VR.kDS, VM.k1, false);
  static const ElementDef kDoseRateSet
      //(300A,0115)
      = const ElementDef("DoseRateSet", 0x300A0115, "Dose Rate Set", VR.kDS, VM.k1, false);
  static const ElementDef kWedgePositionSequence
      //(300A,0116)
      = const ElementDef(
          "WedgePositionSequence", 0x300A0116, "Wedge Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kWedgePosition
      //(300A,0118)
      = const ElementDef("WedgePosition", 0x300A0118, "Wedge Position", VR.kCS, VM.k1, false);
  static const ElementDef kBeamLimitingDevicePositionSequence
      //(300A,011A)
      = const ElementDef("BeamLimitingDevicePositionSequence", 0x300A011A,
          "Beam Limiting Device Position Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLeafJawPositions
      //(300A,011C)
      =
      const ElementDef("LeafJawPositions", 0x300A011C, "Leaf/Jaw Positions", VR.kDS, VM.k2_2n, false);
  static const ElementDef kGantryAngle
      //(300A,011E)
      = const ElementDef("GantryAngle", 0x300A011E, "Gantry Angle", VR.kDS, VM.k1, false);
  static const ElementDef kGantryRotationDirection
      //(300A,011F)
      = const ElementDef(
          "GantryRotationDirection", 0x300A011F, "Gantry Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kBeamLimitingDeviceAngle
      //(300A,0120)
      = const ElementDef("BeamLimitingDeviceAngle", 0x300A0120, "Beam Limiting Device Angle", VR.kDS,
          VM.k1, false);
  static const ElementDef kBeamLimitingDeviceRotationDirection
      //(300A,0121)
      = const ElementDef("BeamLimitingDeviceRotationDirection", 0x300A0121,
          "Beam Limiting Device Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kPatientSupportAngle
      //(300A,0122)
      = const ElementDef(
          "PatientSupportAngle", 0x300A0122, "Patient Support Angle", VR.kDS, VM.k1, false);
  static const ElementDef kPatientSupportRotationDirection
      //(300A,0123)
      = const ElementDef("PatientSupportRotationDirection", 0x300A0123,
          "Patient Support Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kTableTopEccentricAxisDistance
      //(300A,0124)
      = const ElementDef("TableTopEccentricAxisDistance", 0x300A0124,
          "Table Top Eccentric Axis Distance", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopEccentricAngle
      //(300A,0125)
      = const ElementDef(
          "TableTopEccentricAngle", 0x300A0125, "Table Top Eccentric Angle", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopEccentricRotationDirection
      //(300A,0126)
      = const ElementDef("TableTopEccentricRotationDirection", 0x300A0126,
          "Table Top Eccentric Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kTableTopVerticalPosition
      //(300A,0128)
      = const ElementDef("TableTopVerticalPosition", 0x300A0128, "Table Top Vertical Position", VR.kDS,
          VM.k1, false);
  static const ElementDef kTableTopLongitudinalPosition
      //(300A,0129)
      = const ElementDef("TableTopLongitudinalPosition", 0x300A0129, "Table Top Longitudinal Position",
          VR.kDS, VM.k1, false);
  static const ElementDef kTableTopLateralPosition
      //(300A,012A)
      = const ElementDef("TableTopLateralPosition", 0x300A012A, "Table Top Lateral Position", VR.kDS,
          VM.k1, false);
  static const ElementDef kIsocenterPosition
      //(300A,012C)
      = const ElementDef("IsocenterPosition", 0x300A012C, "Isocenter Position", VR.kDS, VM.k3, false);
  static const ElementDef kSurfaceEntryPoint
      //(300A,012E)
      = const ElementDef("SurfaceEntryPoint", 0x300A012E, "Surface Entry Point", VR.kDS, VM.k3, false);
  static const ElementDef kSourceToSurfaceDistance
      //(300A,0130)
      = const ElementDef("SourceToSurfaceDistance", 0x300A0130, "Source to Surface Distance", VR.kDS,
          VM.k1, false);
  static const ElementDef kCumulativeMetersetWeight
      //(300A,0134)
      = const ElementDef("CumulativeMetersetWeight", 0x300A0134, "Cumulative Meterset Weight", VR.kDS,
          VM.k1, false);
  static const ElementDef kTableTopPitchAngle
      //(300A,0140)
      = const ElementDef(
          "TableTopPitchAngle", 0x300A0140, "Table Top Pitch Angle", VR.kFL, VM.k1, false);
  static const ElementDef kTableTopPitchRotationDirection
      //(300A,0142)
      = const ElementDef("TableTopPitchRotationDirection", 0x300A0142,
          "Table Top Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kTableTopRollAngle
      //(300A,0144)
      =
      const ElementDef("TableTopRollAngle", 0x300A0144, "Table Top Roll Angle", VR.kFL, VM.k1, false);
  static const ElementDef kTableTopRollRotationDirection
      //(300A,0146)
      = const ElementDef("TableTopRollRotationDirection", 0x300A0146,
          "Table Top Roll Rotation Direction", VR.kCS, VM.k1, false);
  static const ElementDef kHeadFixationAngle
      //(300A,0148)
      = const ElementDef("HeadFixationAngle", 0x300A0148, "Head Fixation Angle", VR.kFL, VM.k1, false);
  static const ElementDef kGantryPitchAngle
      //(300A,014A)
      = const ElementDef("GantryPitchAngle", 0x300A014A, "Gantry Pitch Angle", VR.kFL, VM.k1, false);
  static const ElementDef kGantryPitchRotationDirection
      //(300A,014C)
      = const ElementDef("GantryPitchRotationDirection", 0x300A014C, "Gantry Pitch Rotation Direction",
          VR.kCS, VM.k1, false);
  static const ElementDef kGantryPitchAngleTolerance
      //(300A,014E)
      = const ElementDef("GantryPitchAngleTolerance", 0x300A014E, "Gantry Pitch Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const ElementDef kPatientSetupSequence
      //(300A,0180)
      = const ElementDef(
          "PatientSetupSequence", 0x300A0180, "Patient Setup Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPatientSetupNumber
      //(300A,0182)
      =
      const ElementDef("PatientSetupNumber", 0x300A0182, "Patient Setup Number", VR.kIS, VM.k1, false);
  static const ElementDef kPatientSetupLabel
      //(300A,0183)
      = const ElementDef("PatientSetupLabel", 0x300A0183, "Patient Setup Label", VR.kLO, VM.k1, false);
  static const ElementDef kPatientAdditionalPosition
      //(300A,0184)
      = const ElementDef("PatientAdditionalPosition", 0x300A0184, "Patient Additional Position",
          VR.kLO, VM.k1, false);
  static const ElementDef kFixationDeviceSequence
      //(300A,0190)
      = const ElementDef(
          "FixationDeviceSequence", 0x300A0190, "Fixation Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kFixationDeviceType
      //(300A,0192)
      =
      const ElementDef("FixationDeviceType", 0x300A0192, "Fixation Device Type", VR.kCS, VM.k1, false);
  static const ElementDef kFixationDeviceLabel
      //(300A,0194)
      = const ElementDef(
          "FixationDeviceLabel", 0x300A0194, "Fixation Device Label", VR.kSH, VM.k1, false);
  static const ElementDef kFixationDeviceDescription
      //(300A,0196)
      = const ElementDef("FixationDeviceDescription", 0x300A0196, "Fixation Device Description",
          VR.kST, VM.k1, false);
  static const ElementDef kFixationDevicePosition
      //(300A,0198)
      = const ElementDef(
          "FixationDevicePosition", 0x300A0198, "Fixation Device Position", VR.kSH, VM.k1, false);
  static const ElementDef kFixationDevicePitchAngle
      //(300A,0199)
      = const ElementDef("FixationDevicePitchAngle", 0x300A0199, "Fixation Device Pitch Angle", VR.kFL,
          VM.k1, false);
  static const ElementDef kFixationDeviceRollAngle
      //(300A,019A)
      = const ElementDef("FixationDeviceRollAngle", 0x300A019A, "Fixation Device Roll Angle", VR.kFL,
          VM.k1, false);
  static const ElementDef kShieldingDeviceSequence
      //(300A,01A0)
      = const ElementDef(
          "ShieldingDeviceSequence", 0x300A01A0, "Shielding Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kShieldingDeviceType
      //(300A,01A2)
      = const ElementDef(
          "ShieldingDeviceType", 0x300A01A2, "Shielding Device Type", VR.kCS, VM.k1, false);
  static const ElementDef kShieldingDeviceLabel
      //(300A,01A4)
      = const ElementDef(
          "ShieldingDeviceLabel", 0x300A01A4, "Shielding Device Label", VR.kSH, VM.k1, false);
  static const ElementDef kShieldingDeviceDescription
      //(300A,01A6)
      = const ElementDef("ShieldingDeviceDescription", 0x300A01A6, "Shielding Device Description",
          VR.kST, VM.k1, false);
  static const ElementDef kShieldingDevicePosition
      //(300A,01A8)
      = const ElementDef(
          "ShieldingDevicePosition", 0x300A01A8, "Shielding Device Position", VR.kSH, VM.k1, false);
  static const ElementDef kSetupTechnique
      //(300A,01B0)
      = const ElementDef("SetupTechnique", 0x300A01B0, "Setup Technique", VR.kCS, VM.k1, false);
  static const ElementDef kSetupTechniqueDescription
      //(300A,01B2)
      = const ElementDef("SetupTechniqueDescription", 0x300A01B2, "Setup Technique Description",
          VR.kST, VM.k1, false);
  static const ElementDef kSetupDeviceSequence
      //(300A,01B4)
      = const ElementDef(
          "SetupDeviceSequence", 0x300A01B4, "Setup Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSetupDeviceType
      //(300A,01B6)
      = const ElementDef("SetupDeviceType", 0x300A01B6, "Setup Device Type", VR.kCS, VM.k1, false);
  static const ElementDef kSetupDeviceLabel
      //(300A,01B8)
      = const ElementDef("SetupDeviceLabel", 0x300A01B8, "Setup Device Label", VR.kSH, VM.k1, false);
  static const ElementDef kSetupDeviceDescription
      //(300A,01BA)
      = const ElementDef(
          "SetupDeviceDescription", 0x300A01BA, "Setup Device Description", VR.kST, VM.k1, false);
  static const ElementDef kSetupDeviceParameter
      //(300A,01BC)
      = const ElementDef(
          "SetupDeviceParameter", 0x300A01BC, "Setup Device Parameter", VR.kDS, VM.k1, false);
  static const ElementDef kSetupReferenceDescription
      //(300A,01D0)
      = const ElementDef("SetupReferenceDescription", 0x300A01D0, "Setup Reference Description",
          VR.kST, VM.k1, false);
  static const ElementDef kTableTopVerticalSetupDisplacement
      //(300A,01D2)
      = const ElementDef("TableTopVerticalSetupDisplacement", 0x300A01D2,
          "Table Top Vertical Setup Displacement", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopLongitudinalSetupDisplacement
      //(300A,01D4)
      = const ElementDef("TableTopLongitudinalSetupDisplacement", 0x300A01D4,
          "Table Top Longitudinal Setup Displacement", VR.kDS, VM.k1, false);
  static const ElementDef kTableTopLateralSetupDisplacement
      //(300A,01D6)
      = const ElementDef("TableTopLateralSetupDisplacement", 0x300A01D6,
          "Table Top Lateral Setup Displacement", VR.kDS, VM.k1, false);
  static const ElementDef kBrachyTreatmentTechnique
      //(300A,0200)
      = const ElementDef("BrachyTreatmentTechnique", 0x300A0200, "Brachy Treatment Technique", VR.kCS,
          VM.k1, false);
  static const ElementDef kBrachyTreatmentType
      //(300A,0202)
      = const ElementDef(
          "BrachyTreatmentType", 0x300A0202, "Brachy Treatment Type", VR.kCS, VM.k1, false);
  static const ElementDef kTreatmentMachineSequence
      //(300A,0206)
      = const ElementDef("TreatmentMachineSequence", 0x300A0206, "Treatment Machine Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kSourceSequence
      //(300A,0210)
      = const ElementDef("SourceSequence", 0x300A0210, "Source Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSourceNumber
      //(300A,0212)
      = const ElementDef("SourceNumber", 0x300A0212, "Source Number", VR.kIS, VM.k1, false);
  static const ElementDef kSourceType
      //(300A,0214)
      = const ElementDef("SourceType", 0x300A0214, "Source Type", VR.kCS, VM.k1, false);
  static const ElementDef kSourceManufacturer
      //(300A,0216)
      =
      const ElementDef("SourceManufacturer", 0x300A0216, "Source Manufacturer", VR.kLO, VM.k1, false);
  static const ElementDef kActiveSourceDiameter
      //(300A,0218)
      = const ElementDef(
          "ActiveSourceDiameter", 0x300A0218, "Active Source Diameter", VR.kDS, VM.k1, false);
  static const ElementDef kActiveSourceLength
      //(300A,021A)
      =
      const ElementDef("ActiveSourceLength", 0x300A021A, "Active Source Length", VR.kDS, VM.k1, false);
  static const ElementDef kSourceModelID
      //(300A,021B)
      = const ElementDef("SourceModelID", 0x300A021B, "Source Model ID", VR.kSH, VM.k1, false);
  static const ElementDef kSourceDescription
      //(300A,021C)
      = const ElementDef("SourceDescription", 0x300A021C, "Source Description", VR.kLO, VM.k1, false);
  static const ElementDef kSourceEncapsulationNominalThickness
      //(300A,0222)
      = const ElementDef("SourceEncapsulationNominalThickness", 0x300A0222,
          "Source Encapsulation Nominal Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kSourceEncapsulationNominalTransmission
      //(300A,0224)
      = const ElementDef("SourceEncapsulationNominalTransmission", 0x300A0224,
          "Source Encapsulation Nominal Transmission", VR.kDS, VM.k1, false);
  static const ElementDef kSourceIsotopeName
      //(300A,0226)
      = const ElementDef("SourceIsotopeName", 0x300A0226, "Source Isotope Name", VR.kLO, VM.k1, false);
  static const ElementDef kSourceIsotopeHalfLife
      //(300A,0228)
      = const ElementDef(
          "SourceIsotopeHalfLife", 0x300A0228, "Source Isotope Half Life", VR.kDS, VM.k1, false);
  static const ElementDef kSourceStrengthUnits
      //(300A,0229)
      = const ElementDef(
          "SourceStrengthUnits", 0x300A0229, "Source Strength Units", VR.kCS, VM.k1, false);
  static const ElementDef kReferenceAirKermaRate
      //(300A,022A)
      = const ElementDef(
          "ReferenceAirKermaRate", 0x300A022A, "Reference Air Kerma Rate", VR.kDS, VM.k1, false);
  static const ElementDef kSourceStrength
      //(300A,022B)
      = const ElementDef("SourceStrength", 0x300A022B, "Source Strength", VR.kDS, VM.k1, false);
  static const ElementDef kSourceStrengthReferenceDate
      //(300A,022C)
      = const ElementDef("SourceStrengthReferenceDate", 0x300A022C, "Source Strength Reference Date",
          VR.kDA, VM.k1, false);
  static const ElementDef kSourceStrengthReferenceTime
      //(300A,022E)
      = const ElementDef("SourceStrengthReferenceTime", 0x300A022E, "Source Strength Reference Time",
          VR.kTM, VM.k1, false);
  static const ElementDef kApplicationSetupSequence
      //(300A,0230)
      = const ElementDef("ApplicationSetupSequence", 0x300A0230, "Application Setup Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kApplicationSetupType
      //(300A,0232)
      = const ElementDef(
          "ApplicationSetupType", 0x300A0232, "Application Setup Type", VR.kCS, VM.k1, false);
  static const ElementDef kApplicationSetupNumber
      //(300A,0234)
      = const ElementDef(
          "ApplicationSetupNumber", 0x300A0234, "Application Setup Number", VR.kIS, VM.k1, false);
  static const ElementDef kApplicationSetupName
      //(300A,0236)
      = const ElementDef(
          "ApplicationSetupName", 0x300A0236, "Application Setup Name", VR.kLO, VM.k1, false);
  static const ElementDef kApplicationSetupManufacturer
      //(300A,0238)
      = const ElementDef("ApplicationSetupManufacturer", 0x300A0238, "Application Setup Manufacturer",
          VR.kLO, VM.k1, false);
  static const ElementDef kTemplateNumber
      //(300A,0240)
      = const ElementDef("TemplateNumber", 0x300A0240, "Template Number", VR.kIS, VM.k1, false);
  static const ElementDef kTemplateType
      //(300A,0242)
      = const ElementDef("TemplateType", 0x300A0242, "Template Type", VR.kSH, VM.k1, false);
  static const ElementDef kTemplateName
      //(300A,0244)
      = const ElementDef("TemplateName", 0x300A0244, "Template Name", VR.kLO, VM.k1, false);
  static const ElementDef kTotalReferenceAirKerma
      //(300A,0250)
      = const ElementDef(
          "TotalReferenceAirKerma", 0x300A0250, "Total Reference Air Kerma", VR.kDS, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceSequence
      //(300A,0260)
      = const ElementDef("BrachyAccessoryDeviceSequence", 0x300A0260,
          "Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceNumber
      //(300A,0262)
      = const ElementDef("BrachyAccessoryDeviceNumber", 0x300A0262, "Brachy Accessory Device Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceID
      //(300A,0263)
      = const ElementDef("BrachyAccessoryDeviceID", 0x300A0263, "Brachy Accessory Device ID", VR.kSH,
          VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceType
      //(300A,0264)
      = const ElementDef("BrachyAccessoryDeviceType", 0x300A0264, "Brachy Accessory Device Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceName
      //(300A,0266)
      = const ElementDef("BrachyAccessoryDeviceName", 0x300A0266, "Brachy Accessory Device Name",
          VR.kLO, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceNominalThickness
      //(300A,026A)
      = const ElementDef("BrachyAccessoryDeviceNominalThickness", 0x300A026A,
          "Brachy Accessory Device Nominal Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kBrachyAccessoryDeviceNominalTransmission
      //(300A,026C)
      = const ElementDef("BrachyAccessoryDeviceNominalTransmission", 0x300A026C,
          "Brachy Accessory Device Nominal Transmission", VR.kDS, VM.k1, false);
  static const ElementDef kChannelSequence
      //(300A,0280)
      = const ElementDef("ChannelSequence", 0x300A0280, "Channel Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelNumber
      //(300A,0282)
      = const ElementDef("ChannelNumber", 0x300A0282, "Channel Number", VR.kIS, VM.k1, false);
  static const ElementDef kChannelLength
      //(300A,0284)
      = const ElementDef("ChannelLength", 0x300A0284, "Channel Length", VR.kDS, VM.k1, false);
  static const ElementDef kChannelTotalTime
      //(300A,0286)
      = const ElementDef("ChannelTotalTime", 0x300A0286, "Channel Total Time", VR.kDS, VM.k1, false);
  static const ElementDef kSourceMovementType
      //(300A,0288)
      =
      const ElementDef("SourceMovementType", 0x300A0288, "Source Movement Type", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfPulses
      //(300A,028A)
      = const ElementDef("NumberOfPulses", 0x300A028A, "Number of Pulses", VR.kIS, VM.k1, false);
  static const ElementDef kPulseRepetitionInterval
      //(300A,028C)
      = const ElementDef(
          "PulseRepetitionInterval", 0x300A028C, "Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const ElementDef kSourceApplicatorNumber
      //(300A,0290)
      = const ElementDef(
          "SourceApplicatorNumber", 0x300A0290, "Source Applicator Number", VR.kIS, VM.k1, false);
  static const ElementDef kSourceApplicatorID
      //(300A,0291)
      =
      const ElementDef("SourceApplicatorID", 0x300A0291, "Source Applicator ID", VR.kSH, VM.k1, false);
  static const ElementDef kSourceApplicatorType
      //(300A,0292)
      = const ElementDef(
          "SourceApplicatorType", 0x300A0292, "Source Applicator Type", VR.kCS, VM.k1, false);
  static const ElementDef kSourceApplicatorName
      //(300A,0294)
      = const ElementDef(
          "SourceApplicatorName", 0x300A0294, "Source Applicator Name", VR.kLO, VM.k1, false);
  static const ElementDef kSourceApplicatorLength
      //(300A,0296)
      = const ElementDef(
          "SourceApplicatorLength", 0x300A0296, "Source Applicator Length", VR.kDS, VM.k1, false);
  static const ElementDef kSourceApplicatorManufacturer
      //(300A,0298)
      = const ElementDef("SourceApplicatorManufacturer", 0x300A0298, "Source Applicator Manufacturer",
          VR.kLO, VM.k1, false);
  static const ElementDef kSourceApplicatorWallNominalThickness
      //(300A,029C)
      = const ElementDef("SourceApplicatorWallNominalThickness", 0x300A029C,
          "Source Applicator Wall Nominal Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kSourceApplicatorWallNominalTransmission
      //(300A,029E)
      = const ElementDef("SourceApplicatorWallNominalTransmission", 0x300A029E,
          "Source Applicator Wall Nominal Transmission", VR.kDS, VM.k1, false);
  static const ElementDef kSourceApplicatorStepSize
      //(300A,02A0)
      = const ElementDef("SourceApplicatorStepSize", 0x300A02A0, "Source Applicator Step Size", VR.kDS,
          VM.k1, false);
  static const ElementDef kTransferTubeNumber
      //(300A,02A2)
      =
      const ElementDef("TransferTubeNumber", 0x300A02A2, "Transfer Tube Number", VR.kIS, VM.k1, false);
  static const ElementDef kTransferTubeLength
      //(300A,02A4)
      =
      const ElementDef("TransferTubeLength", 0x300A02A4, "Transfer Tube Length", VR.kDS, VM.k1, false);
  static const ElementDef kChannelShieldSequence
      //(300A,02B0)
      = const ElementDef(
          "ChannelShieldSequence", 0x300A02B0, "Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelShieldNumber
      //(300A,02B2)
      = const ElementDef(
          "ChannelShieldNumber", 0x300A02B2, "Channel Shield Number", VR.kIS, VM.k1, false);
  static const ElementDef kChannelShieldID
      //(300A,02B3)
      = const ElementDef("ChannelShieldID", 0x300A02B3, "Channel Shield ID", VR.kSH, VM.k1, false);
  static const ElementDef kChannelShieldName
      //(300A,02B4)
      = const ElementDef("ChannelShieldName", 0x300A02B4, "Channel Shield Name", VR.kLO, VM.k1, false);
  static const ElementDef kChannelShieldNominalThickness
      //(300A,02B8)
      = const ElementDef("ChannelShieldNominalThickness", 0x300A02B8,
          "Channel Shield Nominal Thickness", VR.kDS, VM.k1, false);
  static const ElementDef kChannelShieldNominalTransmission
      //(300A,02BA)
      = const ElementDef("ChannelShieldNominalTransmission", 0x300A02BA,
          "Channel Shield Nominal Transmission", VR.kDS, VM.k1, false);
  static const ElementDef kFinalCumulativeTimeWeight
      //(300A,02C8)
      = const ElementDef("FinalCumulativeTimeWeight", 0x300A02C8, "Final Cumulative Time Weight",
          VR.kDS, VM.k1, false);
  static const ElementDef kBrachyControlPointSequence
      //(300A,02D0)
      = const ElementDef("BrachyControlPointSequence", 0x300A02D0, "Brachy Control Point Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kControlPointRelativePosition
      //(300A,02D2)
      = const ElementDef("ControlPointRelativePosition", 0x300A02D2, "Control Point Relative Position",
          VR.kDS, VM.k1, false);
  static const ElementDef kControlPoint3DPosition
      //(300A,02D4)
      = const ElementDef(
          "ControlPoint3DPosition", 0x300A02D4, "Control Point 3D Position", VR.kDS, VM.k3, false);
  static const ElementDef kCumulativeTimeWeight
      //(300A,02D6)
      = const ElementDef(
          "CumulativeTimeWeight", 0x300A02D6, "Cumulative Time Weight", VR.kDS, VM.k1, false);
  static const ElementDef kCompensatorDivergence
      //(300A,02E0)
      = const ElementDef(
          "CompensatorDivergence", 0x300A02E0, "Compensator Divergence", VR.kCS, VM.k1, false);
  static const ElementDef kCompensatorMountingPosition
      //(300A,02E1)
      = const ElementDef("CompensatorMountingPosition", 0x300A02E1, "Compensator Mounting Position",
          VR.kCS, VM.k1, false);
  static const ElementDef kSourceToCompensatorDistance
      //(300A,02E2)
      = const ElementDef("SourceToCompensatorDistance", 0x300A02E2, "Source to Compensator Distance",
          VR.kDS, VM.k1_n, false);
  static const ElementDef kTotalCompensatorTrayWaterEquivalentThickness
      //(300A,02E3)
      = const ElementDef("TotalCompensatorTrayWaterEquivalentThickness", 0x300A02E3,
          "Total Compensator Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kIsocenterToCompensatorTrayDistance
      //(300A,02E4)
      = const ElementDef("IsocenterToCompensatorTrayDistance", 0x300A02E4,
          "Isocenter to Compensator Tray Distance", VR.kFL, VM.k1, false);
  static const ElementDef kCompensatorColumnOffset
      //(300A,02E5)
      = const ElementDef(
          "CompensatorColumnOffset", 0x300A02E5, "Compensator Column Offset", VR.kFL, VM.k1, false);
  static const ElementDef kIsocenterToCompensatorDistances
      //(300A,02E6)
      = const ElementDef("IsocenterToCompensatorDistances", 0x300A02E6,
          "Isocenter to Compensator Distances", VR.kFL, VM.k1_n, false);
  static const ElementDef kCompensatorRelativeStoppingPowerRatio
      //(300A,02E7)
      = const ElementDef("CompensatorRelativeStoppingPowerRatio", 0x300A02E7,
          "Compensator Relative Stopping Power Ratio", VR.kFL, VM.k1, false);
  static const ElementDef kCompensatorMillingToolDiameter
      //(300A,02E8)
      = const ElementDef("CompensatorMillingToolDiameter", 0x300A02E8,
          "Compensator Milling Tool Diameter", VR.kFL, VM.k1, false);
  static const ElementDef kIonRangeCompensatorSequence
      //(300A,02EA)
      = const ElementDef("IonRangeCompensatorSequence", 0x300A02EA, "Ion Range Compensator Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kCompensatorDescription
      //(300A,02EB)
      = const ElementDef(
          "CompensatorDescription", 0x300A02EB, "Compensator Description", VR.kLT, VM.k1, false);
  static const ElementDef kRadiationMassNumber
      //(300A,0302)
      = const ElementDef(
          "RadiationMassNumber", 0x300A0302, "Radiation Mass Number", VR.kIS, VM.k1, false);
  static const ElementDef kRadiationAtomicNumber
      //(300A,0304)
      = const ElementDef(
          "RadiationAtomicNumber", 0x300A0304, "Radiation Atomic Number", VR.kIS, VM.k1, false);
  static const ElementDef kRadiationChargeState
      //(300A,0306)
      = const ElementDef(
          "RadiationChargeState", 0x300A0306, "Radiation Charge State", VR.kSS, VM.k1, false);
  static const ElementDef kScanMode
      //(300A,0308)
      = const ElementDef("ScanMode", 0x300A0308, "Scan Mode", VR.kCS, VM.k1, false);
  static const ElementDef kVirtualSourceAxisDistances
      //(300A,030A)
      = const ElementDef("VirtualSourceAxisDistances", 0x300A030A, "Virtual Source-Axis Distances",
          VR.kFL, VM.k2, false);
  static const ElementDef kSnoutSequence
      //(300A,030C)
      = const ElementDef("SnoutSequence", 0x300A030C, "Snout Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSnoutPosition
      //(300A,030D)
      = const ElementDef("SnoutPosition", 0x300A030D, "Snout Position", VR.kFL, VM.k1, false);
  static const ElementDef kSnoutID
      //(300A,030F)
      = const ElementDef("SnoutID", 0x300A030F, "Snout ID", VR.kSH, VM.k1, false);
  static const ElementDef kNumberOfRangeShifters
      //(300A,0312)
      = const ElementDef(
          "NumberOfRangeShifters", 0x300A0312, "Number of Range Shifters", VR.kIS, VM.k1, false);
  static const ElementDef kRangeShifterSequence
      //(300A,0314)
      = const ElementDef(
          "RangeShifterSequence", 0x300A0314, "Range Shifter Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRangeShifterNumber
      //(300A,0316)
      =
      const ElementDef("RangeShifterNumber", 0x300A0316, "Range Shifter Number", VR.kIS, VM.k1, false);
  static const ElementDef kRangeShifterID
      //(300A,0318)
      = const ElementDef("RangeShifterID", 0x300A0318, "Range Shifter ID", VR.kSH, VM.k1, false);
  static const ElementDef kRangeShifterType
      //(300A,0320)
      = const ElementDef("RangeShifterType", 0x300A0320, "Range Shifter Type", VR.kCS, VM.k1, false);
  static const ElementDef kRangeShifterDescription
      //(300A,0322)
      = const ElementDef(
          "RangeShifterDescription", 0x300A0322, "Range Shifter Description", VR.kLO, VM.k1, false);
  static const ElementDef kNumberOfLateralSpreadingDevices
      //(300A,0330)
      = const ElementDef("NumberOfLateralSpreadingDevices", 0x300A0330,
          "Number of Lateral Spreading Devices", VR.kIS, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceSequence
      //(300A,0332)
      = const ElementDef("LateralSpreadingDeviceSequence", 0x300A0332,
          "Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceNumber
      //(300A,0334)
      = const ElementDef("LateralSpreadingDeviceNumber", 0x300A0334, "Lateral Spreading Device Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceID
      //(300A,0336)
      = const ElementDef("LateralSpreadingDeviceID", 0x300A0336, "Lateral Spreading Device ID", VR.kSH,
          VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceType
      //(300A,0338)
      = const ElementDef("LateralSpreadingDeviceType", 0x300A0338, "Lateral Spreading Device Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceDescription
      //(300A,033A)
      = const ElementDef("LateralSpreadingDeviceDescription", 0x300A033A,
          "Lateral Spreading Device Description", VR.kLO, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceWaterEquivalentThickness
      //(300A,033C)
      = const ElementDef("LateralSpreadingDeviceWaterEquivalentThickness", 0x300A033C,
          "Lateral Spreading Device Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kNumberOfRangeModulators
      //(300A,0340)
      = const ElementDef("NumberOfRangeModulators", 0x300A0340, "Number of Range Modulators", VR.kIS,
          VM.k1, false);
  static const ElementDef kRangeModulatorSequence
      //(300A,0342)
      = const ElementDef(
          "RangeModulatorSequence", 0x300A0342, "Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRangeModulatorNumber
      //(300A,0344)
      = const ElementDef(
          "RangeModulatorNumber", 0x300A0344, "Range Modulator Number", VR.kIS, VM.k1, false);
  static const ElementDef kRangeModulatorID
      //(300A,0346)
      = const ElementDef("RangeModulatorID", 0x300A0346, "Range Modulator ID", VR.kSH, VM.k1, false);
  static const ElementDef kRangeModulatorType
      //(300A,0348)
      =
      const ElementDef("RangeModulatorType", 0x300A0348, "Range Modulator Type", VR.kCS, VM.k1, false);
  static const ElementDef kRangeModulatorDescription
      //(300A,034A)
      = const ElementDef("RangeModulatorDescription", 0x300A034A, "Range Modulator Description",
          VR.kLO, VM.k1, false);
  static const ElementDef kBeamCurrentModulationID
      //(300A,034C)
      = const ElementDef("BeamCurrentModulationID", 0x300A034C, "Beam Current Modulation ID", VR.kSH,
          VM.k1, false);
  static const ElementDef kPatientSupportType
      //(300A,0350)
      =
      const ElementDef("PatientSupportType", 0x300A0350, "Patient Support Type", VR.kCS, VM.k1, false);
  static const ElementDef kPatientSupportID
      //(300A,0352)
      = const ElementDef("PatientSupportID", 0x300A0352, "Patient Support ID", VR.kSH, VM.k1, false);
  static const ElementDef kPatientSupportAccessoryCode
      //(300A,0354)
      = const ElementDef("PatientSupportAccessoryCode", 0x300A0354, "Patient Support Accessory Code",
          VR.kLO, VM.k1, false);
  static const ElementDef kFixationLightAzimuthalAngle
      //(300A,0356)
      = const ElementDef("FixationLightAzimuthalAngle", 0x300A0356, "Fixation Light Azimuthal Angle",
          VR.kFL, VM.k1, false);
  static const ElementDef kFixationLightPolarAngle
      //(300A,0358)
      = const ElementDef("FixationLightPolarAngle", 0x300A0358, "Fixation Light Polar Angle", VR.kFL,
          VM.k1, false);
  static const ElementDef kMetersetRate
      //(300A,035A)
      = const ElementDef("MetersetRate", 0x300A035A, "Meterset Rate", VR.kFL, VM.k1, false);
  static const ElementDef kRangeShifterSettingsSequence
      //(300A,0360)
      = const ElementDef("RangeShifterSettingsSequence", 0x300A0360, "Range Shifter Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kRangeShifterSetting
      //(300A,0362)
      = const ElementDef(
          "RangeShifterSetting", 0x300A0362, "Range Shifter Setting", VR.kLO, VM.k1, false);
  static const ElementDef kIsocenterToRangeShifterDistance
      //(300A,0364)
      = const ElementDef("IsocenterToRangeShifterDistance", 0x300A0364,
          "Isocenter to Range Shifter Distance", VR.kFL, VM.k1, false);
  static const ElementDef kRangeShifterWaterEquivalentThickness
      //(300A,0366)
      = const ElementDef("RangeShifterWaterEquivalentThickness", 0x300A0366,
          "Range Shifter Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceSettingsSequence
      //(300A,0370)
      = const ElementDef("LateralSpreadingDeviceSettingsSequence", 0x300A0370,
          "Lateral Spreading Device Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kLateralSpreadingDeviceSetting
      //(300A,0372)
      = const ElementDef("LateralSpreadingDeviceSetting", 0x300A0372,
          "Lateral Spreading Device Setting", VR.kLO, VM.k1, false);
  static const ElementDef kIsocenterToLateralSpreadingDeviceDistance
      //(300A,0374)
      = const ElementDef("IsocenterToLateralSpreadingDeviceDistance", 0x300A0374,
          "Isocenter to Lateral Spreading Device Distance", VR.kFL, VM.k1, false);
  static const ElementDef kRangeModulatorSettingsSequence
      //(300A,0380)
      = const ElementDef("RangeModulatorSettingsSequence", 0x300A0380,
          "Range Modulator Settings Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kRangeModulatorGatingStartValue
      //(300A,0382)
      = const ElementDef("RangeModulatorGatingStartValue", 0x300A0382,
          "Range Modulator Gating Start Value", VR.kFL, VM.k1, false);
  static const ElementDef kRangeModulatorGatingStopValue
      //(300A,0384)
      = const ElementDef("RangeModulatorGatingStopValue", 0x300A0384,
          "Range Modulator Gating Stop Value", VR.kFL, VM.k1, false);
  static const ElementDef kRangeModulatorGatingStartWaterEquivalentThickness
      //(300A,0386)
      = const ElementDef("RangeModulatorGatingStartWaterEquivalentThickness", 0x300A0386,
          "Range Modulator Gating Start Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kRangeModulatorGatingStopWaterEquivalentThickness
      //(300A,0388)
      = const ElementDef("RangeModulatorGatingStopWaterEquivalentThickness", 0x300A0388,
          "Range Modulator Gating Stop Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const ElementDef kIsocenterToRangeModulatorDistance
      //(300A,038A)
      = const ElementDef("IsocenterToRangeModulatorDistance", 0x300A038A,
          "Isocenter to Range Modulator Distance", VR.kFL, VM.k1, false);
  static const ElementDef kScanSpotTuneID
      //(300A,0390)
      = const ElementDef("ScanSpotTuneID", 0x300A0390, "Scan Spot Tune ID", VR.kSH, VM.k1, false);
  static const ElementDef kNumberOfScanSpotPositions
      //(300A,0392)
      = const ElementDef("NumberOfScanSpotPositions", 0x300A0392, "Number of Scan Spot Positions",
          VR.kIS, VM.k1, false);
  static const ElementDef kScanSpotPositionMap
      //(300A,0394)
      = const ElementDef(
          "ScanSpotPositionMap", 0x300A0394, "Scan Spot Position Map", VR.kFL, VM.k1_n, false);
  static const ElementDef kScanSpotMetersetWeights
      //(300A,0396)
      = const ElementDef("ScanSpotMetersetWeights", 0x300A0396, "Scan Spot Meterset Weights", VR.kFL,
          VM.k1_n, false);
  static const ElementDef kScanningSpotSize
      //(300A,0398)
      = const ElementDef("ScanningSpotSize", 0x300A0398, "Scanning Spot Size", VR.kFL, VM.k2, false);
  static const ElementDef kNumberOfPaintings
      //(300A,039A)
      = const ElementDef("NumberOfPaintings", 0x300A039A, "Number of Paintings", VR.kIS, VM.k1, false);
  static const ElementDef kIonToleranceTableSequence
      //(300A,03A0)
      = const ElementDef("IonToleranceTableSequence", 0x300A03A0, "Ion Tolerance Table Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kIonBeamSequence
      //(300A,03A2)
      = const ElementDef("IonBeamSequence", 0x300A03A2, "Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonBeamLimitingDeviceSequence
      //(300A,03A4)
      = const ElementDef("IonBeamLimitingDeviceSequence", 0x300A03A4,
          "Ion Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonBlockSequence
      //(300A,03A6)
      = const ElementDef("IonBlockSequence", 0x300A03A6, "Ion Block Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonControlPointSequence
      //(300A,03A8)
      = const ElementDef("IonControlPointSequence", 0x300A03A8, "Ion Control Point Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kIonWedgeSequence
      //(300A,03AA)
      = const ElementDef("IonWedgeSequence", 0x300A03AA, "Ion Wedge Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kIonWedgePositionSequence
      //(300A,03AC)
      = const ElementDef("IonWedgePositionSequence", 0x300A03AC, "Ion Wedge Position Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kReferencedSetupImageSequence
      //(300A,0401)
      = const ElementDef("ReferencedSetupImageSequence", 0x300A0401, "Referenced Setup Image Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kSetupImageComment
      //(300A,0402)
      = const ElementDef("SetupImageComment", 0x300A0402, "Setup Image Comment", VR.kST, VM.k1, false);
  static const ElementDef kMotionSynchronizationSequence
      //(300A,0410)
      = const ElementDef("MotionSynchronizationSequence", 0x300A0410,
          "Motion Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kControlPointOrientation
      //(300A,0412)
      = const ElementDef(
          "ControlPointOrientation", 0x300A0412, "Control Point Orientation", VR.kFL, VM.k3, false);
  static const ElementDef kGeneralAccessorySequence
      //(300A,0420)
      = const ElementDef("GeneralAccessorySequence", 0x300A0420, "General Accessory Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kGeneralAccessoryID
      //(300A,0421)
      =
      const ElementDef("GeneralAccessoryID", 0x300A0421, "General Accessory ID", VR.kSH, VM.k1, false);
  static const ElementDef kGeneralAccessoryDescription
      //(300A,0422)
      = const ElementDef("GeneralAccessoryDescription", 0x300A0422, "General Accessory Description",
          VR.kST, VM.k1, false);
  static const ElementDef kGeneralAccessoryType
      //(300A,0423)
      = const ElementDef(
          "GeneralAccessoryType", 0x300A0423, "General Accessory Type", VR.kCS, VM.k1, false);
  static const ElementDef kGeneralAccessoryNumber
      //(300A,0424)
      = const ElementDef(
          "GeneralAccessoryNumber", 0x300A0424, "General Accessory Number", VR.kIS, VM.k1, false);
  static const ElementDef kSourceToGeneralAccessoryDistance
      //(300A,0425)
      = const ElementDef("SourceToGeneralAccessoryDistance", 0x300A0425,
          "Source to General Accessory Distance", VR.kFL, VM.k1, false);
  static const ElementDef kApplicatorGeometrySequence
      //(300A,0431)
      = const ElementDef("ApplicatorGeometrySequence", 0x300A0431, "Applicator Geometry Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kApplicatorApertureShape
      //(300A,0432)
      = const ElementDef(
          "ApplicatorApertureShape", 0x300A0432, "Applicator Aperture Shape", VR.kCS, VM.k1, false);
  static const ElementDef kApplicatorOpening
      //(300A,0433)
      = const ElementDef("ApplicatorOpening", 0x300A0433, "Applicator Opening", VR.kFL, VM.k1, false);
  static const ElementDef kApplicatorOpeningX
      //(300A,0434)
      =
      const ElementDef("ApplicatorOpeningX", 0x300A0434, "Applicator Opening X", VR.kFL, VM.k1, false);
  static const ElementDef kApplicatorOpeningY
      //(300A,0435)
      =
      const ElementDef("ApplicatorOpeningY", 0x300A0435, "Applicator Opening Y", VR.kFL, VM.k1, false);
  static const ElementDef kSourceToApplicatorMountingPositionDistance
      //(300A,0436)
      = const ElementDef("SourceToApplicatorMountingPositionDistance", 0x300A0436,
          "Source to Applicator Mounting Position Distance", VR.kFL, VM.k1, false);
  static const ElementDef kReferencedRTPlanSequence
      //(300C,0002)
      = const ElementDef("ReferencedRTPlanSequence", 0x300C0002, "Referenced RT Plan Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kReferencedBeamSequence
      //(300C,0004)
      = const ElementDef(
          "ReferencedBeamSequence", 0x300C0004, "Referenced Beam Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedBeamNumber
      //(300C,0006)
      = const ElementDef(
          "ReferencedBeamNumber", 0x300C0006, "Referenced Beam Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedReferenceImageNumber
      //(300C,0007)
      = const ElementDef("ReferencedReferenceImageNumber", 0x300C0007,
          "Referenced Reference Image Number", VR.kIS, VM.k1, false);
  static const ElementDef kStartCumulativeMetersetWeight
      //(300C,0008)
      = const ElementDef("StartCumulativeMetersetWeight", 0x300C0008,
          "Start Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const ElementDef kEndCumulativeMetersetWeight
      //(300C,0009)
      = const ElementDef("EndCumulativeMetersetWeight", 0x300C0009, "End Cumulative Meterset Weight",
          VR.kDS, VM.k1, false);
  static const ElementDef kReferencedBrachyApplicationSetupSequence
      //(300C,000A)
      = const ElementDef("ReferencedBrachyApplicationSetupSequence", 0x300C000A,
          "Referenced Brachy Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedBrachyApplicationSetupNumber
      //(300C,000C)
      = const ElementDef("ReferencedBrachyApplicationSetupNumber", 0x300C000C,
          "Referenced Brachy Application Setup Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedSourceNumber
      //(300C,000E)
      = const ElementDef(
          "ReferencedSourceNumber", 0x300C000E, "Referenced Source Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedFractionGroupSequence
      //(300C,0020)
      = const ElementDef("ReferencedFractionGroupSequence", 0x300C0020,
          "Referenced Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedFractionGroupNumber
      //(300C,0022)
      = const ElementDef("ReferencedFractionGroupNumber", 0x300C0022,
          "Referenced Fraction Group Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedVerificationImageSequence
      //(300C,0040)
      = const ElementDef("ReferencedVerificationImageSequence", 0x300C0040,
          "Referenced Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedReferenceImageSequence
      //(300C,0042)
      = const ElementDef("ReferencedReferenceImageSequence", 0x300C0042,
          "Referenced Reference Image Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedDoseReferenceSequence
      //(300C,0050)
      = const ElementDef("ReferencedDoseReferenceSequence", 0x300C0050,
          "Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedDoseReferenceNumber
      //(300C,0051)
      = const ElementDef("ReferencedDoseReferenceNumber", 0x300C0051,
          "Referenced Dose Reference Number", VR.kIS, VM.k1, false);
  static const ElementDef kBrachyReferencedDoseReferenceSequence
      //(300C,0055)
      = const ElementDef("BrachyReferencedDoseReferenceSequence", 0x300C0055,
          "Brachy Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedStructureSetSequence
      //(300C,0060)
      = const ElementDef("ReferencedStructureSetSequence", 0x300C0060,
          "Referenced Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedPatientSetupNumber
      //(300C,006A)
      = const ElementDef("ReferencedPatientSetupNumber", 0x300C006A, "Referenced Patient Setup Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kReferencedDoseSequence
      //(300C,0080)
      = const ElementDef(
          "ReferencedDoseSequence", 0x300C0080, "Referenced Dose Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedToleranceTableNumber
      //(300C,00A0)
      = const ElementDef("ReferencedToleranceTableNumber", 0x300C00A0,
          "Referenced Tolerance Table Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedBolusSequence
      //(300C,00B0)
      = const ElementDef(
          "ReferencedBolusSequence", 0x300C00B0, "Referenced Bolus Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedWedgeNumber
      //(300C,00C0)
      = const ElementDef(
          "ReferencedWedgeNumber", 0x300C00C0, "Referenced Wedge Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedCompensatorNumber
      //(300C,00D0)
      = const ElementDef("ReferencedCompensatorNumber", 0x300C00D0, "Referenced Compensator Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kReferencedBlockNumber
      //(300C,00E0)
      = const ElementDef(
          "ReferencedBlockNumber", 0x300C00E0, "Referenced Block Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedControlPointIndex
      //(300C,00F0)
      = const ElementDef("ReferencedControlPointIndex", 0x300C00F0, "Referenced Control Point Index",
          VR.kIS, VM.k1, false);
  static const ElementDef kReferencedControlPointSequence
      //(300C,00F2)
      = const ElementDef("ReferencedControlPointSequence", 0x300C00F2,
          "Referenced Control Point Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedStartControlPointIndex
      //(300C,00F4)
      = const ElementDef("ReferencedStartControlPointIndex", 0x300C00F4,
          "Referenced Start Control Point Index", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedStopControlPointIndex
      //(300C,00F6)
      = const ElementDef("ReferencedStopControlPointIndex", 0x300C00F6,
          "Referenced Stop Control Point Index", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedRangeShifterNumber
      //(300C,0100)
      = const ElementDef("ReferencedRangeShifterNumber", 0x300C0100, "Referenced Range Shifter Number",
          VR.kIS, VM.k1, false);
  static const ElementDef kReferencedLateralSpreadingDeviceNumber
      //(300C,0102)
      = const ElementDef("ReferencedLateralSpreadingDeviceNumber", 0x300C0102,
          "Referenced Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const ElementDef kReferencedRangeModulatorNumber
      //(300C,0104)
      = const ElementDef("ReferencedRangeModulatorNumber", 0x300C0104,
          "Referenced Range Modulator Number", VR.kIS, VM.k1, false);
  static const ElementDef kApprovalStatus
      //(300E,0002)
      = const ElementDef("ApprovalStatus", 0x300E0002, "Approval Status", VR.kCS, VM.k1, false);
  static const ElementDef kReviewDate
      //(300E,0004)
      = const ElementDef("ReviewDate", 0x300E0004, "Review Date", VR.kDA, VM.k1, false);
  static const ElementDef kReviewTime
      //(300E,0005)
      = const ElementDef("ReviewTime", 0x300E0005, "Review Time", VR.kTM, VM.k1, false);
  static const ElementDef kReviewerName
      //(300E,0008)
      = const ElementDef("ReviewerName", 0x300E0008, "Reviewer Name", VR.kPN, VM.k1, false);
  static const ElementDef kArbitrary
      //(4000,0010)
      = const ElementDef("Arbitrary", 0x40000010, "Arbitrary", VR.kLT, VM.k1, true);
  static const ElementDef kTextComments
      //(4000,4000)
      = const ElementDef("TextComments", 0x40004000, "Text Comments", VR.kLT, VM.k1, true);
  static const ElementDef kResultsID
      //(4008,0040)
      = const ElementDef("ResultsID", 0x40080040, "Results ID", VR.kSH, VM.k1, true);
  static const ElementDef kResultsIDIssuer
      //(4008,0042)
      = const ElementDef("ResultsIDIssuer", 0x40080042, "Results ID Issuer", VR.kLO, VM.k1, true);
  static const ElementDef kReferencedInterpretationSequence
      //(4008,0050)
      = const ElementDef("ReferencedInterpretationSequence", 0x40080050,
          "Referenced Interpretation Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kReportProductionStatusTrial
      //(4008,00FF)
      = const ElementDef("ReportProductionStatusTrial", 0x400800FF, "Report Production Status (Trial)",
          VR.kCS, VM.k1, true);
  static const ElementDef kInterpretationRecordedDate
      //(4008,0100)
      = const ElementDef("InterpretationRecordedDate", 0x40080100, "Interpretation Recorded Date",
          VR.kDA, VM.k1, true);
  static const ElementDef kInterpretationRecordedTime
      //(4008,0101)
      = const ElementDef("InterpretationRecordedTime", 0x40080101, "Interpretation Recorded Time",
          VR.kTM, VM.k1, true);
  static const ElementDef kInterpretationRecorder
      //(4008,0102)
      = const ElementDef(
          "InterpretationRecorder", 0x40080102, "Interpretation Recorder", VR.kPN, VM.k1, true);
  static const ElementDef kReferenceToRecordedSound
      //(4008,0103)
      = const ElementDef("ReferenceToRecordedSound", 0x40080103, "Reference to Recorded Sound", VR.kLO,
          VM.k1, true);
  static const ElementDef kInterpretationTranscriptionDate
      //(4008,0108)
      = const ElementDef("InterpretationTranscriptionDate", 0x40080108,
          "Interpretation Transcription Date", VR.kDA, VM.k1, true);
  static const ElementDef kInterpretationTranscriptionTime
      //(4008,0109)
      = const ElementDef("InterpretationTranscriptionTime", 0x40080109,
          "Interpretation Transcription Time", VR.kTM, VM.k1, true);
  static const ElementDef kInterpretationTranscriber
      //(4008,010A)
      = const ElementDef("InterpretationTranscriber", 0x4008010A, "Interpretation Transcriber", VR.kPN,
          VM.k1, true);
  static const ElementDef kInterpretationText
      //(4008,010B)
      = const ElementDef("InterpretationText", 0x4008010B, "Interpretation Text", VR.kST, VM.k1, true);
  static const ElementDef kInterpretationAuthor
      //(4008,010C)
      = const ElementDef(
          "InterpretationAuthor", 0x4008010C, "Interpretation Author", VR.kPN, VM.k1, true);
  static const ElementDef kInterpretationApproverSequence
      //(4008,0111)
      = const ElementDef("InterpretationApproverSequence", 0x40080111,
          "Interpretation Approver Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kInterpretationApprovalDate
      //(4008,0112)
      = const ElementDef("InterpretationApprovalDate", 0x40080112, "Interpretation Approval Date",
          VR.kDA, VM.k1, true);
  static const ElementDef kInterpretationApprovalTime
      //(4008,0113)
      = const ElementDef("InterpretationApprovalTime", 0x40080113, "Interpretation Approval Time",
          VR.kTM, VM.k1, true);
  static const ElementDef kPhysicianApprovingInterpretation
      //(4008,0114)
      = const ElementDef("PhysicianApprovingInterpretation", 0x40080114,
          "Physician Approving Interpretation", VR.kPN, VM.k1, true);
  static const ElementDef kInterpretationDiagnosisDescription
      //(4008,0115)
      = const ElementDef("InterpretationDiagnosisDescription", 0x40080115,
          "Interpretation Diagnosis Description", VR.kLT, VM.k1, true);
  static const ElementDef kInterpretationDiagnosisCodeSequence
      //(4008,0117)
      = const ElementDef("InterpretationDiagnosisCodeSequence", 0x40080117,
          "Interpretation Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kResultsDistributionListSequence
      //(4008,0118)
      = const ElementDef("ResultsDistributionListSequence", 0x40080118,
          "Results Distribution List Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kDistributionName
      //(4008,0119)
      = const ElementDef("DistributionName", 0x40080119, "Distribution Name", VR.kPN, VM.k1, true);
  static const ElementDef kDistributionAddress
      //(4008,011A)
      =
      const ElementDef("DistributionAddress", 0x4008011A, "Distribution Address", VR.kLO, VM.k1, true);
  static const ElementDef kInterpretationID
      //(4008,0200)
      = const ElementDef("InterpretationID", 0x40080200, "Interpretation ID", VR.kSH, VM.k1, true);
  static const ElementDef kInterpretationIDIssuer
      //(4008,0202)
      = const ElementDef(
          "InterpretationIDIssuer", 0x40080202, "Interpretation ID Issuer", VR.kLO, VM.k1, true);
  static const ElementDef kInterpretationTypeID
      //(4008,0210)
      = const ElementDef(
          "InterpretationTypeID", 0x40080210, "Interpretation Type ID", VR.kCS, VM.k1, true);
  static const ElementDef kInterpretationStatusID
      //(4008,0212)
      = const ElementDef(
          "InterpretationStatusID", 0x40080212, "Interpretation Status ID", VR.kCS, VM.k1, true);
  static const ElementDef kImpressions
      //(4008,0300)
      = const ElementDef("Impressions", 0x40080300, "Impressions", VR.kST, VM.k1, true);
  static const ElementDef kResultsComments
      //(4008,4000)
      = const ElementDef("ResultsComments", 0x40084000, "Results Comments", VR.kST, VM.k1, true);
  static const ElementDef kLowEnergyDetectors
      //(4010,0001)
      =
      const ElementDef("LowEnergyDetectors", 0x40100001, "Low Energy Detectors", VR.kCS, VM.k1, false);
  static const ElementDef kHighEnergyDetectors
      //(4010,0002)
      = const ElementDef(
          "HighEnergyDetectors", 0x40100002, "High Energy Detectors", VR.kCS, VM.k1, false);
  static const ElementDef kDetectorGeometrySequence
      //(4010,0004)
      = const ElementDef("DetectorGeometrySequence", 0x40100004, "Detector Geometry Sequence", VR.kSQ,
          VM.k1, false);
  static const ElementDef kThreatROIVoxelSequence
      //(4010,1001)
      = const ElementDef(
          "ThreatROIVoxelSequence", 0x40101001, "Threat ROI Voxel Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kThreatROIBase
      //(4010,1004)
      = const ElementDef("ThreatROIBase", 0x40101004, "Threat ROI Base", VR.kFL, VM.k3, false);
  static const ElementDef kThreatROIExtents
      //(4010,1005)
      = const ElementDef("ThreatROIExtents", 0x40101005, "Threat ROI Extents", VR.kFL, VM.k3, false);
  static const ElementDef kThreatROIBitmap
      //(4010,1006)
      = const ElementDef("ThreatROIBitmap", 0x40101006, "Threat ROI Bitmap", VR.kOB, VM.k1, false);
  static const ElementDef kRouteSegmentID
      //(4010,1007)
      = const ElementDef("RouteSegmentID", 0x40101007, "Route Segment ID", VR.kSH, VM.k1, false);
  static const ElementDef kGantryType
      //(4010,1008)
      = const ElementDef("GantryType", 0x40101008, "Gantry Type", VR.kCS, VM.k1, false);
  static const ElementDef kOOIOwnerType
      //(4010,1009)
      = const ElementDef("OOIOwnerType", 0x40101009, "OOI Owner Type", VR.kCS, VM.k1, false);
  static const ElementDef kRouteSegmentSequence
      //(4010,100A)
      = const ElementDef(
          "RouteSegmentSequence", 0x4010100A, "Route Segment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPotentialThreatObjectID
      //(4010,1010)
      = const ElementDef("PotentialThreatObjectID", 0x40101010, "Potential Threat Object ID", VR.kUS,
          VM.k1, false);
  static const ElementDef kThreatSequence
      //(4010,1011)
      = const ElementDef("ThreatSequence", 0x40101011, "Threat Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kThreatCategory
      //(4010,1012)
      = const ElementDef("ThreatCategory", 0x40101012, "Threat Category", VR.kCS, VM.k1, false);
  static const ElementDef kThreatCategoryDescription
      //(4010,1013)
      = const ElementDef("ThreatCategoryDescription", 0x40101013, "Threat Category Description",
          VR.kLT, VM.k1, false);
  static const ElementDef kATDAbilityAssessment
      //(4010,1014)
      = const ElementDef(
          "ATDAbilityAssessment", 0x40101014, "ATD Ability Assessment", VR.kCS, VM.k1, false);
  static const ElementDef kATDAssessmentFlag
      //(4010,1015)
      = const ElementDef("ATDAssessmentFlag", 0x40101015, "ATD Assessment Flag", VR.kCS, VM.k1, false);
  static const ElementDef kATDAssessmentProbability
      //(4010,1016)
      = const ElementDef("ATDAssessmentProbability", 0x40101016, "ATD Assessment Probability", VR.kFL,
          VM.k1, false);
  static const ElementDef kMass
      //(4010,1017)
      = const ElementDef("Mass", 0x40101017, "Mass", VR.kFL, VM.k1, false);
  static const ElementDef kDensity
      //(4010,1018)
      = const ElementDef("Density", 0x40101018, "Density", VR.kFL, VM.k1, false);
  static const ElementDef kZEffective
      //(4010,1019)
      = const ElementDef("ZEffective", 0x40101019, "Z Effective", VR.kFL, VM.k1, false);
  static const ElementDef kBoardingPassID
      //(4010,101A)
      = const ElementDef("BoardingPassID", 0x4010101A, "Boarding Pass ID", VR.kSH, VM.k1, false);
  static const ElementDef kCenterOfMass
      //(4010,101B)
      = const ElementDef("CenterOfMass", 0x4010101B, "Center of Mass", VR.kFL, VM.k3, false);
  static const ElementDef kCenterOfPTO
      //(4010,101C)
      = const ElementDef("CenterOfPTO", 0x4010101C, "Center of PTO", VR.kFL, VM.k3, false);
  static const ElementDef kBoundingPolygon
      //(4010,101D)
      = const ElementDef("BoundingPolygon", 0x4010101D, "Bounding Polygon", VR.kFL, VM.k6_n, false);
  static const ElementDef kRouteSegmentStartLocationID
      //(4010,101E)
      = const ElementDef("RouteSegmentStartLocationID", 0x4010101E, "Route Segment Start Location ID",
          VR.kSH, VM.k1, false);
  static const ElementDef kRouteSegmentEndLocationID
      //(4010,101F)
      = const ElementDef("RouteSegmentEndLocationID", 0x4010101F, "Route Segment End Location ID",
          VR.kSH, VM.k1, false);
  static const ElementDef kRouteSegmentLocationIDType
      //(4010,1020)
      = const ElementDef("RouteSegmentLocationIDType", 0x40101020, "Route Segment Location ID Type",
          VR.kCS, VM.k1, false);
  static const ElementDef kAbortReason
      //(4010,1021)
      = const ElementDef("AbortReason", 0x40101021, "Abort Reason", VR.kCS, VM.k1_n, false);
  static const ElementDef kVolumeOfPTO
      //(4010,1023)
      = const ElementDef("VolumeOfPTO", 0x40101023, "Volume of PTO", VR.kFL, VM.k1, false);
  static const ElementDef kAbortFlag
      //(4010,1024)
      = const ElementDef("AbortFlag", 0x40101024, "Abort Flag", VR.kCS, VM.k1, false);
  static const ElementDef kRouteSegmentStartTime
      //(4010,1025)
      = const ElementDef(
          "RouteSegmentStartTime", 0x40101025, "Route Segment Start Time", VR.kDT, VM.k1, false);
  static const ElementDef kRouteSegmentEndTime
      //(4010,1026)
      = const ElementDef(
          "RouteSegmentEndTime", 0x40101026, "Route Segment End Time", VR.kDT, VM.k1, false);
  static const ElementDef kTDRType
      //(4010,1027)
      = const ElementDef("TDRType", 0x40101027, "TDR Type", VR.kCS, VM.k1, false);
  static const ElementDef kInternationalRouteSegment
      //(4010,1028)
      = const ElementDef("InternationalRouteSegment", 0x40101028, "International Route Segment",
          VR.kCS, VM.k1, false);
  static const ElementDef kThreatDetectionAlgorithmandVersion
      //(4010,1029)
      = const ElementDef("ThreatDetectionAlgorithmandVersion", 0x40101029,
          "Threat Detection Algorithm and Version", VR.kLO, VM.k1_n, false);
  static const ElementDef kAssignedLocation
      //(4010,102A)
      = const ElementDef("AssignedLocation", 0x4010102A, "Assigned Location", VR.kSH, VM.k1, false);
  static const ElementDef kAlarmDecisionTime
      //(4010,102B)
      = const ElementDef("AlarmDecisionTime", 0x4010102B, "Alarm Decision Time", VR.kDT, VM.k1, false);
  static const ElementDef kAlarmDecision
      //(4010,1031)
      = const ElementDef("AlarmDecision", 0x40101031, "Alarm Decision", VR.kCS, VM.k1, false);
  static const ElementDef kNumberOfTotalObjects
      //(4010,1033)
      = const ElementDef(
          "NumberOfTotalObjects", 0x40101033, "Number of Total Objects", VR.kUS, VM.k1, false);
  static const ElementDef kNumberOfAlarmObjects
      //(4010,1034)
      = const ElementDef(
          "NumberOfAlarmObjects", 0x40101034, "Number of Alarm Objects", VR.kUS, VM.k1, false);
  static const ElementDef kPTORepresentationSequence
      //(4010,1037)
      = const ElementDef("PTORepresentationSequence", 0x40101037, "PTO Representation Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kATDAssessmentSequence
      //(4010,1038)
      = const ElementDef(
          "ATDAssessmentSequence", 0x40101038, "ATD Assessment Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTIPType
      //(4010,1039)
      = const ElementDef("TIPType", 0x40101039, "TIP Type", VR.kCS, VM.k1, false);
  static const ElementDef kDICOSVersion
      //(4010,103A)
      = const ElementDef("DICOSVersion", 0x4010103A, "DICOS Version", VR.kCS, VM.k1, false);
  static const ElementDef kOOIOwnerCreationTime
      //(4010,1041)
      = const ElementDef(
          "OOIOwnerCreationTime", 0x40101041, "OOI Owner Creation Time", VR.kDT, VM.k1, false);
  static const ElementDef kOOIType
      //(4010,1042)
      = const ElementDef("OOIType", 0x40101042, "OOI Type", VR.kCS, VM.k1, false);
  static const ElementDef kOOISize
      //(4010,1043)
      = const ElementDef("OOISize", 0x40101043, "OOI Size", VR.kFL, VM.k3, false);
  static const ElementDef kAcquisitionStatus
      //(4010,1044)
      = const ElementDef("AcquisitionStatus", 0x40101044, "Acquisition Status", VR.kCS, VM.k1, false);
  static const ElementDef kBasisMaterialsCodeSequence
      //(4010,1045)
      = const ElementDef("BasisMaterialsCodeSequence", 0x40101045, "Basis Materials Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kPhantomType
      //(4010,1046)
      = const ElementDef("PhantomType", 0x40101046, "Phantom Type", VR.kCS, VM.k1, false);
  static const ElementDef kOOIOwnerSequence
      //(4010,1047)
      = const ElementDef("OOIOwnerSequence", 0x40101047, "OOI Owner Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kScanType
      //(4010,1048)
      = const ElementDef("ScanType", 0x40101048, "Scan Type", VR.kCS, VM.k1, false);
  static const ElementDef kItineraryID
      //(4010,1051)
      = const ElementDef("ItineraryID", 0x40101051, "Itinerary ID", VR.kLO, VM.k1, false);
  static const ElementDef kItineraryIDType
      //(4010,1052)
      = const ElementDef("ItineraryIDType", 0x40101052, "Itinerary ID Type", VR.kSH, VM.k1, false);
  static const ElementDef kItineraryIDAssigningAuthority
      //(4010,1053)
      = const ElementDef("ItineraryIDAssigningAuthority", 0x40101053,
          "Itinerary ID Assigning Authority", VR.kLO, VM.k1, false);
  static const ElementDef kRouteID
      //(4010,1054)
      = const ElementDef("RouteID", 0x40101054, "Route ID", VR.kSH, VM.k1, false);
  static const ElementDef kRouteIDAssigningAuthority
      //(4010,1055)
      = const ElementDef("RouteIDAssigningAuthority", 0x40101055, "Route ID Assigning Authority",
          VR.kSH, VM.k1, false);
  static const ElementDef kInboundArrivalType
      //(4010,1056)
      =
      const ElementDef("InboundArrivalType", 0x40101056, "Inbound Arrival Type", VR.kCS, VM.k1, false);
  static const ElementDef kCarrierID
      //(4010,1058)
      = const ElementDef("CarrierID", 0x40101058, "Carrier ID", VR.kSH, VM.k1, false);
  static const ElementDef kCarrierIDAssigningAuthority
      //(4010,1059)
      = const ElementDef("CarrierIDAssigningAuthority", 0x40101059, "Carrier ID Assigning Authority",
          VR.kCS, VM.k1, false);
  static const ElementDef kSourceOrientation
      //(4010,1060)
      = const ElementDef("SourceOrientation", 0x40101060, "Source Orientation", VR.kFL, VM.k3, false);
  static const ElementDef kSourcePosition
      //(4010,1061)
      = const ElementDef("SourcePosition", 0x40101061, "Source Position", VR.kFL, VM.k3, false);
  static const ElementDef kBeltHeight
      //(4010,1062)
      = const ElementDef("BeltHeight", 0x40101062, "Belt Height", VR.kFL, VM.k1, false);
  static const ElementDef kAlgorithmRoutingCodeSequence
      //(4010,1064)
      = const ElementDef("AlgorithmRoutingCodeSequence", 0x40101064, "Algorithm Routing Code Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kTransportClassification
      //(4010,1067)
      = const ElementDef(
          "TransportClassification", 0x40101067, "Transport Classification", VR.kCS, VM.k1, false);
  static const ElementDef kOOITypeDescriptor
      //(4010,1068)
      = const ElementDef("OOITypeDescriptor", 0x40101068, "OOI Type Descriptor", VR.kLT, VM.k1, false);
  static const ElementDef kTotalProcessingTime
      //(4010,1069)
      = const ElementDef(
          "TotalProcessingTime", 0x40101069, "Total Processing Time", VR.kFL, VM.k1, false);
  static const ElementDef kDetectorCalibrationData
      //(4010,106C)
      = const ElementDef(
          "DetectorCalibrationData", 0x4010106C, "Detector Calibration Data", VR.kOB, VM.k1, false);
  static const ElementDef kAdditionalScreeningPerformed
      //(4010,106D)
      = const ElementDef("AdditionalScreeningPerformed", 0x4010106D, "Additional Screening Performed",
          VR.kCS, VM.k1, false);
  static const ElementDef kAdditionalInspectionSelectionCriteria
      //(4010,106E)
      = const ElementDef("AdditionalInspectionSelectionCriteria", 0x4010106E,
          "Additional Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const ElementDef kAdditionalInspectionMethodSequence
      //(4010,106F)
      = const ElementDef("AdditionalInspectionMethodSequence", 0x4010106F,
          "Additional Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAITDeviceType
      //(4010,1070)
      = const ElementDef("AITDeviceType", 0x40101070, "AIT Device Type", VR.kCS, VM.k1, false);
  static const ElementDef kQRMeasurementsSequence
      //(4010,1071)
      = const ElementDef(
          "QRMeasurementsSequence", 0x40101071, "QR Measurements Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kTargetMaterialSequence
      //(4010,1072)
      = const ElementDef(
          "TargetMaterialSequence", 0x40101072, "Target Material Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kSNRThreshold
      //(4010,1073)
      = const ElementDef("SNRThreshold", 0x40101073, "SNR Threshold", VR.kFD, VM.k1, false);
  static const ElementDef kImageScaleRepresentation
      //(4010,1075)
      = const ElementDef("ImageScaleRepresentation", 0x40101075, "Image Scale Representation", VR.kDS,
          VM.k1, false);
  static const ElementDef kReferencedPTOSequence
      //(4010,1076)
      = const ElementDef(
          "ReferencedPTOSequence", 0x40101076, "Referenced PTO Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kReferencedTDRInstanceSequence
      //(4010,1077)
      = const ElementDef("ReferencedTDRInstanceSequence", 0x40101077,
          "Referenced TDR Instance Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPTOLocationDescription
      //(4010,1078)
      = const ElementDef(
          "PTOLocationDescription", 0x40101078, "PTO Location Description", VR.kST, VM.k1, false);
  static const ElementDef kAnomalyLocatorIndicatorSequence
      //(4010,1079)
      = const ElementDef("AnomalyLocatorIndicatorSequence", 0x40101079,
          "Anomaly Locator Indicator Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kAnomalyLocatorIndicator
      //(4010,107A)
      = const ElementDef(
          "AnomalyLocatorIndicator", 0x4010107A, "Anomaly Locator Indicator", VR.kFL, VM.k3, false);
  static const ElementDef kPTORegionSequence
      //(4010,107B)
      = const ElementDef("PTORegionSequence", 0x4010107B, "PTO Region Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kInspectionSelectionCriteria
      //(4010,107C)
      = const ElementDef("InspectionSelectionCriteria", 0x4010107C, "Inspection Selection Criteria",
          VR.kCS, VM.k1, false);
  static const ElementDef kSecondaryInspectionMethodSequence
      //(4010,107D)
      = const ElementDef("SecondaryInspectionMethodSequence", 0x4010107D,
          "Secondary Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPRCSToRCSOrientation
      //(4010,107E)
      = const ElementDef(
          "PRCSToRCSOrientation", 0x4010107E, "PRCS to RCS Orientation", VR.kDS, VM.k6, false);
  static const ElementDef kMACParametersSequence
      //(4FFE,0001)
      = const ElementDef(
          "MACParametersSequence", 0x4FFE0001, "MAC Parameters Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kCurveDimensions
      //(5000,0005)
      = const ElementDef("CurveDimensions", 0x50000005, "Curve Dimensions", VR.kUS, VM.k1, true);
  static const ElementDef kNumberOfPoints
      //(5000,0010)
      = const ElementDef("NumberOfPoints", 0x50000010, "Number of Points", VR.kUS, VM.k1, true);
  static const ElementDef kTypeOfData
      //(5000,0020)
      = const ElementDef("TypeOfData", 0x50000020, "Type of Data", VR.kCS, VM.k1, true);
  static const ElementDef kCurveDescription
      //(5000,0022)
      = const ElementDef("CurveDescription", 0x50000022, "Curve Description", VR.kLO, VM.k1, true);
  static const ElementDef kAxisUnits
      //(5000,0030)
      = const ElementDef("AxisUnits", 0x50000030, "Axis Units", VR.kSH, VM.k1_n, true);
  static const ElementDef kAxisLabels
      //(5000,0040)
      = const ElementDef("AxisLabels", 0x50000040, "Axis Labels", VR.kSH, VM.k1_n, true);
  static const ElementDef kDataValueRepresentation
      //(5000,0103)
      = const ElementDef(
          "DataValueRepresentation", 0x50000103, "Data Value Representation", VR.kUS, VM.k1, true);
  static const ElementDef kMinimumCoordinateValue
      //(5000,0104)
      = const ElementDef(
          "MinimumCoordinateValue", 0x50000104, "Minimum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const ElementDef kMaximumCoordinateValue
      //(5000,0105)
      = const ElementDef(
          "MaximumCoordinateValue", 0x50000105, "Maximum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const ElementDef kCurveRange
      //(5000,0106)
      = const ElementDef("CurveRange", 0x50000106, "Curve Range", VR.kSH, VM.k1_n, true);
  static const ElementDef kCurveDataDescriptor
      //(5000,0110)
      = const ElementDef(
          "CurveDataDescriptor", 0x50000110, "Curve Data Descriptor", VR.kUS, VM.k1_n, true);
  static const ElementDef kCoordinateStartValue
      //(5000,0112)
      = const ElementDef(
          "CoordinateStartValue", 0x50000112, "Coordinate Start Value", VR.kUS, VM.k1_n, true);
  static const ElementDef kCoordinateStepValue
      //(5000,0114)
      = const ElementDef(
          "CoordinateStepValue", 0x50000114, "Coordinate Step Value", VR.kUS, VM.k1_n, true);
  static const ElementDef kCurveActivationLayer
      //(5000,1001)
      = const ElementDef(
          "CurveActivationLayer", 0x50001001, "Curve Activation Layer", VR.kCS, VM.k1, true);
  static const ElementDef kAudioType
      //(5000,2000)
      = const ElementDef("AudioType", 0x50002000, "Audio Type", VR.kUS, VM.k1, true);
  static const ElementDef kAudioSampleFormat
      //(5000,2002)
      = const ElementDef("AudioSampleFormat", 0x50002002, "Audio Sample Format", VR.kUS, VM.k1, true);
  static const ElementDef kNumberOfChannels
      //(5000,2004)
      = const ElementDef("NumberOfChannels", 0x50002004, "Number of Channels", VR.kUS, VM.k1, true);
  static const ElementDef kNumberOfSamples
      //(5000,2006)
      = const ElementDef("NumberOfSamples", 0x50002006, "Number of Samples", VR.kUL, VM.k1, true);
  static const ElementDef kSampleRate
      //(5000,2008)
      = const ElementDef("SampleRate", 0x50002008, "Sample Rate", VR.kUL, VM.k1, true);
  static const ElementDef kTotalTime
      //(5000,200A)
      = const ElementDef("TotalTime", 0x5000200A, "Total Time", VR.kUL, VM.k1, true);
  static const ElementDef kAudioSampleData
      //(5000,200C)
      = const ElementDef("AudioSampleData", 0x5000200C, "Audio Sample Data", VR.kOBOW, VM.k1, true);
  static const ElementDef kAudioComments
      //(5000,200E)
      = const ElementDef("AudioComments", 0x5000200E, "Audio Comments", VR.kLT, VM.k1, true);
  static const ElementDef kCurveLabel
      //(5000,2500)
      = const ElementDef("CurveLabel", 0x50002500, "Curve Label", VR.kLO, VM.k1, true);
  static const ElementDef kCurveReferencedOverlaySequence
      //(5000,2600)
      = const ElementDef("CurveReferencedOverlaySequence", 0x50002600,
          "Curve Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const ElementDef kCurveReferencedOverlayGroup
      //(5000,2610)
      = const ElementDef("CurveReferencedOverlayGroup", 0x50002610, "Curve Referenced Overlay Group",
          VR.kUS, VM.k1, true);
  static const ElementDef kCurveData
      //(5000,3000)
      = const ElementDef("CurveData", 0x50003000, "Curve Data", VR.kOBOW, VM.k1, true);
  static const ElementDef kSharedFunctionalGroupsSequence
      //(5200,9229)
      = const ElementDef("SharedFunctionalGroupsSequence", 0x52009229,
          "Shared Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kPerFrameFunctionalGroupsSequence
      //(5200,9230)
      = const ElementDef("PerFrameFunctionalGroupsSequence", 0x52009230,
          "Per-frame Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kWaveformSequence
      //(5400,0100)
      = const ElementDef("WaveformSequence", 0x54000100, "Waveform Sequence", VR.kSQ, VM.k1, false);
  static const ElementDef kChannelMinimumValue
      //(5400,0110)
      = const ElementDef(
          "ChannelMinimumValue", 0x54000110, "Channel Minimum Value", VR.kOBOW, VM.k1, false);
  static const ElementDef kChannelMaximumValue
      //(5400,0112)
      = const ElementDef(
          "ChannelMaximumValue", 0x54000112, "Channel Maximum Value", VR.kOBOW, VM.k1, false);
  static const ElementDef kWaveformBitsAllocated
      //(5400,1004)
      = const ElementDef(
          "WaveformBitsAllocated", 0x54001004, "Waveform Bits Allocated", VR.kUS, VM.k1, false);
  static const ElementDef kWaveformSampleInterpretation
      //(5400,1006)
      = const ElementDef("WaveformSampleInterpretation", 0x54001006, "Waveform Sample Interpretation",
          VR.kCS, VM.k1, false);
  static const ElementDef kWaveformPaddingValue
      //(5400,100A)
      = const ElementDef(
          "WaveformPaddingValue", 0x5400100A, "Waveform Padding Value", VR.kOBOW, VM.k1, false);
  static const ElementDef kWaveformData
      //(5400,1010)
      = const ElementDef("WaveformData", 0x54001010, "Waveform Data", VR.kOBOW, VM.k1, false);
  static const ElementDef kFirstOrderPhaseCorrectionAngle
      //(5600,0010)
      = const ElementDef("FirstOrderPhaseCorrectionAngle", 0x56000010,
          "First Order Phase Correction Angle", VR.kOF, VM.k1, false);
  static const ElementDef kSpectroscopyData
      //(5600,0020)
      = const ElementDef("SpectroscopyData", 0x56000020, "Spectroscopy Data", VR.kOF, VM.k1, false);
  static const ElementDef kOverlayRows
      //(6000,0010)
      = const ElementDef("OverlayRows", 0x60000010, "Overlay Rows", VR.kUS, VM.k1, false);
  static const ElementDef kOverlayColumns
      //(6000,0011)
      = const ElementDef("OverlayColumns", 0x60000011, "Overlay Columns", VR.kUS, VM.k1, false);
  static const ElementDef kOverlayPlanes
      //(6000,0012)
      = const ElementDef("OverlayPlanes", 0x60000012, "Overlay Planes", VR.kUS, VM.k1, true);
  static const ElementDef kNumberOfFramesInOverlay
      //(6000,0015)
      = const ElementDef("NumberOfFramesInOverlay", 0x60000015, "Number of Frames in Overlay", VR.kIS,
          VM.k1, false);
  static const ElementDef kOverlayDescription
      //(6000,0022)
      =
      const ElementDef("OverlayDescription", 0x60000022, "Overlay Description", VR.kLO, VM.k1, false);
  static const ElementDef kOverlayType
      //(6000,0040)
      = const ElementDef("OverlayType", 0x60000040, "Overlay Type", VR.kCS, VM.k1, false);
  static const ElementDef kOverlaySubtype
      //(6000,0045)
      = const ElementDef("OverlaySubtype", 0x60000045, "Overlay Subtype", VR.kLO, VM.k1, false);
  static const ElementDef kOverlayOrigin
      //(6000,0050)
      = const ElementDef("OverlayOrigin", 0x60000050, "Overlay Origin", VR.kSS, VM.k2, false);
  static const ElementDef kImageFrameOrigin
      //(6000,0051)
      = const ElementDef("ImageFrameOrigin", 0x60000051, "Image Frame Origin", VR.kUS, VM.k1, false);
  static const ElementDef kOverlayPlaneOrigin
      //(6000,0052)
      =
      const ElementDef("OverlayPlaneOrigin", 0x60000052, "Overlay Plane Origin", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayCompressionCode
      //(6000,0060)
      = const ElementDef(
          "OverlayCompressionCode", 0x60000060, "Overlay Compression Code", VR.kCS, VM.k1, true);
  static const ElementDef kOverlayCompressionOriginator
      //(6000,0061)
      = const ElementDef("OverlayCompressionOriginator", 0x60000061, "Overlay Compression Originator",
          VR.kSH, VM.k1, true);
  static const ElementDef kOverlayCompressionLabel
      //(6000,0062)
      = const ElementDef(
          "OverlayCompressionLabel", 0x60000062, "Overlay Compression Label", VR.kSH, VM.k1, true);
  static const ElementDef kOverlayCompressionDescription
      //(6000,0063)
      = const ElementDef("OverlayCompressionDescription", 0x60000063,
          "Overlay Compression Description", VR.kCS, VM.k1, true);
  static const ElementDef kOverlayCompressionStepPointers
      //(6000,0066)
      = const ElementDef("OverlayCompressionStepPointers", 0x60000066,
          "Overlay Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const ElementDef kOverlayRepeatInterval
      //(6000,0068)
      = const ElementDef(
          "OverlayRepeatInterval", 0x60000068, "Overlay Repeat Interval", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayBitsGrouped
      //(6000,0069)
      =
      const ElementDef("OverlayBitsGrouped", 0x60000069, "Overlay Bits Grouped", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayBitsAllocated
      //(6000,0100)
      = const ElementDef(
          "OverlayBitsAllocated", 0x60000100, "Overlay Bits Allocated", VR.kUS, VM.k1, false);
  static const ElementDef kOverlayBitPosition
      //(6000,0102)
      =
      const ElementDef("OverlayBitPosition", 0x60000102, "Overlay Bit Position", VR.kUS, VM.k1, false);
  static const ElementDef kOverlayFormat
      //(6000,0110)
      = const ElementDef("OverlayFormat", 0x60000110, "Overlay Format", VR.kCS, VM.k1, true);
  static const ElementDef kOverlayLocation
      //(6000,0200)
      = const ElementDef("OverlayLocation", 0x60000200, "Overlay Location", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayCodeLabel
      //(6000,0800)
      = const ElementDef("OverlayCodeLabel", 0x60000800, "Overlay Code Label", VR.kCS, VM.k1_n, true);
  static const ElementDef kOverlayNumberOfTables
      //(6000,0802)
      = const ElementDef(
          "OverlayNumberOfTables", 0x60000802, "Overlay Number of Tables", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayCodeTableLocation
      //(6000,0803)
      = const ElementDef("OverlayCodeTableLocation", 0x60000803, "Overlay Code Table Location", VR.kAT,
          VM.k1_n, true);
  static const ElementDef kOverlayBitsForCodeWord
      //(6000,0804)
      = const ElementDef(
          "OverlayBitsForCodeWord", 0x60000804, "Overlay Bits For Code Word", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayActivationLayer
      //(6000,1001)
      = const ElementDef(
          "OverlayActivationLayer", 0x60001001, "Overlay Activation Layer", VR.kCS, VM.k1, false);
  static const ElementDef kOverlayDescriptorGray
      //(6000,1100)
      = const ElementDef(
          "OverlayDescriptorGray", 0x60001100, "Overlay Descriptor - Gray", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayDescriptorRed
      //(6000,1101)
      = const ElementDef(
          "OverlayDescriptorRed", 0x60001101, "Overlay Descriptor - Red", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayDescriptorGreen
      //(6000,1102)
      = const ElementDef(
          "OverlayDescriptorGreen", 0x60001102, "Overlay Descriptor - Green", VR.kUS, VM.k1, true);
  static const ElementDef kOverlayDescriptorBlue
      //(6000,1103)
      = const ElementDef(
          "OverlayDescriptorBlue", 0x60001103, "Overlay Descriptor - Blue", VR.kUS, VM.k1, true);
  static const ElementDef kOverlaysGray
      //(6000,1200)
      = const ElementDef("OverlaysGray", 0x60001200, "Overlays - Gray", VR.kUS, VM.k1_n, true);
  static const ElementDef kOverlaysRed
      //(6000,1201)
      = const ElementDef("OverlaysRed", 0x60001201, "Overlays - Red", VR.kUS, VM.k1_n, true);
  static const ElementDef kOverlaysGreen
      //(6000,1202)
      = const ElementDef("OverlaysGreen", 0x60001202, "Overlays - Green", VR.kUS, VM.k1_n, true);
  static const ElementDef kOverlaysBlue
      //(6000,1203)
      = const ElementDef("OverlaysBlue", 0x60001203, "Overlays - Blue", VR.kUS, VM.k1_n, true);
  static const ElementDef kROIArea
      //(6000,1301)
      = const ElementDef("ROIArea", 0x60001301, "ROI Area", VR.kIS, VM.k1, false);
  static const ElementDef kROIMean
      //(6000,1302)
      = const ElementDef("ROIMean", 0x60001302, "ROI Mean", VR.kDS, VM.k1, false);
  static const ElementDef kROIStandardDeviation
      //(6000,1303)
      = const ElementDef(
          "ROIStandardDeviation", 0x60001303, "ROI Standard Deviation", VR.kDS, VM.k1, false);
  static const ElementDef kOverlayLabel
      //(6000,1500)
      = const ElementDef("OverlayLabel", 0x60001500, "Overlay Label", VR.kLO, VM.k1, false);
  static const ElementDef kOverlayData
      //(6000,3000)
      = const ElementDef("OverlayData", 0x60003000, "Overlay Data", VR.kOBOW, VM.k1, false);
  static const ElementDef kOverlayComments
      //(6000,4000)
      = const ElementDef("OverlayComments", 0x60004000, "Overlay Comments", VR.kLT, VM.k1, true);
  static const ElementDef kFloatPixelData =
    const ElementDef("FloatPixelData",
                      0x7FE00008, "Float Pixel Data", VR.kOF, VM.k1, false);
  static const ElementDef kDoubleFloatPixelData =
    const ElementDef("DoubleFloatPixelData",
                      0x7FE00009, "Double Float Pixel Data", VR.kOD, VM.k1, false);
  static const ElementDef kPixelData =
    const ElementDef("PixelData", 0x7FE00010, "Pixel Data", VR.kOBOW, VM.k1, false);
  static const ElementDef kCoefficientsSDVN
      //(7FE0,0020)
      = const ElementDef("CoefficientsSDVN", 0x7FE00020, "Coefficients SDVN", VR.kOW, VM.k1, true);
  static const ElementDef kCoefficientsSDHN
      //(7FE0,0030)
      = const ElementDef("CoefficientsSDHN", 0x7FE00030, "Coefficients SDHN", VR.kOW, VM.k1, true);
  static const ElementDef kCoefficientsSDDN
      //(7FE0,0040)
      = const ElementDef("CoefficientsSDDN", 0x7FE00040, "Coefficients SDDN", VR.kOW, VM.k1, true);
  static const ElementDef kVariablePixelData
      //(7F00,0010)
      =
      const ElementDef("VariablePixelData", 0x7F000010, "Variable Pixel Data", VR.kOBOW, VM.k1, true);
  static const ElementDef kVariableNextDataGroup
      //(7F00,0011)
      = const ElementDef(
          "VariableNextDataGroup", 0x7F000011, "Variable Next Data Group", VR.kUS, VM.k1, true);
  static const ElementDef kVariableCoefficientsSDVN
      //(7F00,0020)
      = const ElementDef("VariableCoefficientsSDVN", 0x7F000020, "Variable Coefficients SDVN", VR.kOW,
          VM.k1, true);
  static const ElementDef kVariableCoefficientsSDHN
      //(7F00,0030)
      = const ElementDef("VariableCoefficientsSDHN", 0x7F000030, "Variable Coefficients SDHN", VR.kOW,
          VM.k1, true);
  static const ElementDef kVariableCoefficientsSDDN
      //(7F00,0040)
      = const ElementDef("VariableCoefficientsSDDN", 0x7F000040, "Variable Coefficients SDDN", VR.kOW,
          VM.k1, true);
  static const ElementDef kDigitalSignaturesSequence
      //(FFFA,FFFA)
      = const ElementDef("DigitalSignaturesSequence", 0xFFFAFFFA, "Digital Signatures Sequence",
          VR.kSQ, VM.k1, false);
  static const ElementDef kDataSetTrailingPadding
      //(FFFC,FFFC)
      = const ElementDef(
          "DataSetTrailingPadding", 0xFFFCFFFC, "Data Set Trailing Padding", VR.kOB, VM.k1, false);
  static const ElementDef kItem
      //(FFFE,E000)
      = const ElementDef("Item", 0xFFFEE000, "Item", VR.kNoVR, VM.kNoVM, false);
  static const ElementDef kItemDelimitationItem
      //(FFFE,E00D)
      = const ElementDef(
          "ItemDelimitationItem", 0xFFFEE00D, "Item Delimitation Item", VR.kNoVR, VM.kNoVM, false);
  static const ElementDef kSequenceDelimitationItem
      //(FFFE,E0DD)
      = const ElementDef("SequenceDelimitationItem", 0xFFFEE0DD, "Sequence Delimitation Item",
          VR.kNoVR, VM.kNoVM, false);

  //**** Special Elements where multiple tags map to the same dictionary

  //(0028,04X0)
  static const ElementDef kRowsForNthOrderCoefficients = const ElementDef("RowsForNthOrderCoefficients",
      0x002804F0, "Rows For Nth Order Coefficients", VR.kUS, VM.k1, true);

  //(0028,04X1)
  static const ElementDef kColumnsForNthOrderCoefficients = const ElementDef(
      "ColumnsForNthOrderCoefficients",
      0x00280401,
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,0402)
  static const ElementDef kCoefficientCoding =
      const ElementDef("CoefficientCoding", 0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);

  //(0028,0403)
  static const ElementDef kCoefficientCodingPointers = const ElementDef("CoefficientCodingPointers",
      0x00280403, "Coefficient Coding Pointers", VR.kAT, VM.k1_n, true);
}

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name
