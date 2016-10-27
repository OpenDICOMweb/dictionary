// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/tag/tags.dart';
import 'package:dictionary/src/dicom/tag/utils.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

//TODO: sort out the naming between Attribute, Data Element, tag, etc.
// DICOM Attribute Definitions
class DED {
  final String keyword;
  final int code;
  final String name;
  final VR vr;
  final VM vm;
  final bool isRetired;

  const DED(this.keyword, this.code, this.name, this.vr, this.vm, this.isRetired);

  String get hex => tagToHex(code);

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'Element: ${tagToDcm(code)}, $vr, $vm, $keyword$retired';
  }

  static DED lookup(int tag) {
    DED e = tags[tag];
    if (e != null) return e;

    // Retired _special case_ tags that still must be handled

    // (0020,31xx)
    if ((tag >= 0x00283100) && (tag <= 0x002031FF)) return DED.kSourceImageIDs;

    // (0028,04X0)
    if ((tag >= 0x00280410) && (tag <= 0x002804F0)) return DED.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((tag >= 0x00280411) && (tag <= 0x002804F1)) return DED.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((tag >= 0x00280412) && (tag <= 0x002804F2)) return DED.kCoefficientCoding;
    // (0028,04X3)
    if ((tag >= 0x00280413) && (tag <= 0x002804F3)) return DED.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((tag >= 0x00280810) && (tag <= 0x002808F0)) return DED.kCodeLabel;
    // (0028,08x2)
    if ((tag >= 0x00280812) && (tag <= 0x002808F2)) return DED.kNumberOfTables;
    // (0028,08x3)
    if ((tag >= 0x00280813) && (tag <= 0x002808F3)) return DED.kCodeTableLocation;
    // (0028,08x4)
    if ((tag >= 0x00280814) && (tag <= 0x002808F4)) return DED.kBitsForCodeWord;
    // (0028,08x8)
    if ((tag >= 0x00280818) && (tag <= 0x002808F8)) return DED.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((tag >= 0x10000000) && (tag <= 0x1000FFF0)) return DED.kEscapeTriplet;
    // (1000,04X3)
    if ((tag >= 0x10000001) && (tag <= 0x1000FFF1)) return DED.kRunLengthTriplet;
    // (1000,08x0)
    if ((tag >= 0x10000002) && (tag <= 0x1000FFF2)) return DED.kHuffmanTableSize;
    // (1000,08x2)
    if ((tag >= 0x10000003) && (tag <= 0x1000FFF3)) return DED.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((tag >= 0x10000004) && (tag <= 0x1000FFF4)) return DED.kShiftTableSize;
    // (1000,08x4)
    if ((tag >= 0x10000005) && (tag <= 0x1000FFF5)) return DED.kShiftTableTriplet;
    // (1000,08x8)
    if ((tag >= 0x10100000) && (tag <= 0x1010FFFF)) return DED.kZonalMap;

    //TODO: 0x50xx,yyyy Elements
    //TODO: 0x60xx,yyyy Elements
    //TODO: 0x7Fxx,yyyy Elements

    // No match return [null]
    return null;
  }

  //**** Message Data Elements begin here ****
  static const kAffectedSOPInstanceUID = const DED(
      "AffectedSOPInstanceUID", 0x00001000, "Affected SOP Instance UID ", VR.kUI, VM.k1, false);

  static const kRequestedSOPInstanceUID = const DED(
      "RequestedSOPInstanceUID", 0x00001001,
      "Requested SOP Instance UID", VR.kUI, VM.k1, false);

  //**** File Meta Information Data Elements begin here ****
  static const kFileMetaInformationGroupLength = const DED("FileMetaInformationGroupLength",
      0x00020000, "File Meta Information Group Length", VR.kUL, VM.k1, false);

  static const kFileMetaInformationVersion = const DED("FileMetaInformationVersion", 0x00020001,
      "File Meta Information Version", VR.kOB, VM.k1, false);

  static const kMediaStorageSOPClassUID = const DED(
      "MediaStorageSOPClassUID", 0x00020002, "Media Storage SOP Class UID", VR.kUI, VM.k1, false);

  static const kMediaStorageSOPInstanceUID = const DED("MediaStorageSOPInstanceUID", 0x00020003,
      "Media Storage SOP Instance UID", VR.kUI, VM.k1, false);

  static const kTransferSyntaxUID =
      const DED("TransferSyntaxUID", 0x00020010, "Transfer Syntax UID", VR.kUI, VM.k1, false);

  static const kImplementationClassUID = const DED(
      "ImplementationClassUID", 0x00020012, "Implementation Class UID", VR.kUI, VM.k1, false);

  static const kImplementationVersionName = const DED(
      "ImplementationVersionName", 0x00020013, "Implementation Version Name", VR.kSH, VM.k1, false);

  static const kSourceApplicationEntityTitle = const DED("SourceApplicationEntityTitle",
      0x00020016, "Source ApplicationEntity Title", VR.kAE, VM.k1, false);

  static const kSendingApplicationEntityTitle = const DED("SendingApplicationEntityTitle",
      0x00020017, "Sending Application Entity Title", VR.kAE, VM.k1, false);

  static const kReceivingApplicationEntityTitle = const DED("ReceivingApplicationEntityTitle",
      0x00020018, "Receiving Application Entity Title", VR.kAE, VM.k1, false);

  static const kPrivateInformationCreatorUID = const DED("PrivateInformationCreatorUID",
      0x00020100, "Private Information Creator UID", VR.kUI, VM.k1, false);

  static const kPrivateInformation =
      const DED("PrivateInformation", 0x00020102, "Private Information", VR.kOB, VM.k1, false);

  //**** DICOM Directory Tags begin here ****
  static const DED kFileSetID =
      const DED("FileSetID", 0x00041130, "File-set ID", VR.kCS, VM.k1, false);

  static const DED kFileSetDescriptorFileID = const DED(
      "FileSetDescriptorFileID", 0x00041141, "File-set Descriptor File ID", VR.kCS, VM.k1_8, false);

  static const DED kSpecificCharacterSetOfFileSetDescriptorFile = const DED(
      "SpecificCharacterSetOfFileSetDescriptorFile",
      0x00041142,
      "Specific Character Set of File Set Descriptor File",
      VR.kCS,
      VM.k1,
      false);

  static const DED kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity = const DED(
      "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
      0x00041200,
      "Offset of the First Directory Record of the Root Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const DED kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity = const DED(
      "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
      0x00041202,
      "Offset of the Last Directory Record of the Root Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const DED kFileSetConsistencyFlag = const DED(
      "FileSetConsistencyFlag", 0x00041212, "File-set Consistency Flag", VR.kUS, VM.k1, false);

  static const DED kDirectoryRecordSequence = const DED(
      "DirectoryRecordSequence", 0x00041220, "Directory Record Sequence", VR.kSQ, VM.k1, false);

  static const DED kOffsetOfTheNextDirectoryRecord = const DED(
      "OffsetOfTheNextDirectoryRecord",
      0x00041400,
      "Offset of the Next Directory Record",
      VR.kUL,
      VM.k1,
      false);

  static const DED kRecordInUseFlag =
      const DED("RecordInUseFlag", 0x00041410, "Record In-use Flag", VR.kUS, VM.k1, false);

  static const DED kOffsetOfReferencedLowerLevelDirectoryEntity = const DED(
      "OffsetOfReferencedLowerLevelDirectoryEntity",
      0x00041420,
      "Offset of Referenced Lower-Level Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const DED kDirectoryRecordType = const DED(
      "DirectoryRecordType", 0x00041430, "Directory​Record​Type", VR.kCS, VM.k1, false);

  static const DED kPrivateRecordUID =
      const DED("PrivateRecordUID", 0x00041432, "Private Record UID", VR.kUI, VM.k1, false);

  static const DED kReferencedFileID =
      const DED("ReferencedFileID", 0x00041500, "Referenced File ID", VR.kCS, VM.k1_8, false);

  static const DED kMRDRDirectoryRecordOffset = const DED(
      "MRDRDirectoryRecordOffset", 0x00041504, "MRDR Directory Record Offset", VR.kUL, VM.k1, true);

  static const DED kReferencedSOPClassUIDInFile = const DED("ReferencedSOPClassUIDInFile",
      0x00041510, "Referenced SOP Class UID in File", VR.kUI, VM.k1, false);

  static const DED kReferencedSOPInstanceUIDInFile = const DED(
      "ReferencedSOPInstanceUIDInFile",
      0x00041511,
      "Referenced SOP Instance UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const DED kReferencedTransferSyntaxUIDInFile = const DED(
      "ReferencedTransferSyntaxUIDInFile",
      0x00041512,
      "Referenced Transfer Syntax UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const DED kReferencedRelatedGeneralSOPClassUIDInFile = const DED(
      "ReferencedRelatedGeneralSOPClassUIDInFile",
      0x0004151a,
      "Referenced Related General SOP Class UID in File",
      VR.kUI,
      VM.k1_n,
      false);

  static const DED kNumberOfReferences =
      const DED("NumberOfReferences", 0x00041600, "Number of References", VR.kUL, VM.k1, true);
  //**** Standard Dataset Tags begin here ****

  static const DED kLengthToEnd
      //(0008,0001) "00080001"
      = const DED("LengthToEnd", 0x00080001, "Length to End", VR.kUL, VM.k1, true);
  static const DED kSpecificCharacterSet
      //(0008,0005)
      = const DED(
          "SpecificCharacterSet", 0x00080005, "Specific Character Set", VR.kCS, VM.k1_n, false);
  static const DED kLanguageCodeSequence
      //(0008,0006)
      = const DED(
          "LanguageCodeSequence", 0x00080006, "Language Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kImageType
      //(0008,0008)
      = const DED("ImageType", 0x00080008, "Image Type", VR.kCS, VM.k2_n, false);
  static const DED kRecognitionCode
      //(0008,0010)
      = const DED("RecognitionCode", 0x00080010, "Recognition Code", VR.kSH, VM.k1, true);
  static const DED kInstanceCreationDate
      //(0008,0012)
      = const DED(
          "InstanceCreationDate", 0x00080012, "Instance Creation Date", VR.kDA, VM.k1, false);
  static const DED kInstanceCreationTime
      //(0008,0013)
      = const DED(
          "InstanceCreationTime", 0x00080013, "Instance Creation Time", VR.kTM, VM.k1, false);
  static const DED kInstanceCreatorUID
      //(0008,0014)
      =
      const DED("InstanceCreatorUID", 0x00080014, "Instance Creator UID", VR.kUI, VM.k1, false);
  static const DED kInstanceCoercionDateTime
      //(0008,0015)
      = const DED("InstanceCoercionDateTime", 0x00080015, "Instance Coercion DateTime", VR.kDT,
          VM.k1, false);
  static const DED kSOPClassUID
      //(0008,0016)
      = const DED("SOPClassUID", 0x00080016, "SOP Class UID", VR.kUI, VM.k1, false);
  static const DED kSOPInstanceUID
      //(0008,0018)
      = const DED("SOPInstanceUID", 0x00080018, "SOP Instance UID", VR.kUI, VM.k1, false);
  static const DED kRelatedGeneralSOPClassUID
      //(0008,001A)
      = const DED("RelatedGeneralSOPClassUID", 0x0008001A, "Related General SOP Class UID",
          VR.kUI, VM.k1_n, false);
  static const DED kOriginalSpecializedSOPClassUID
      //(0008,001B)
      = const DED("OriginalSpecializedSOPClassUID", 0x0008001B,
          "Original Specialized SOP Class UID", VR.kUI, VM.k1, false);
  static const DED kStudyDate
      //(0008,0020)
      = const DED("StudyDate", 0x00080020, "Study Date", VR.kDA, VM.k1, false);
  static const DED kSeriesDate
      //(0008,0021)
      = const DED("SeriesDate", 0x00080021, "Series Date", VR.kDA, VM.k1, false);
  static const DED kAcquisitionDate
      //(0008,0022)
      = const DED("AcquisitionDate", 0x00080022, "Acquisition Date", VR.kDA, VM.k1, false);
  static const DED kContentDate
      //(0008,0023)
      = const DED("ContentDate", 0x00080023, "Content Date", VR.kDA, VM.k1, false);
  static const DED kOverlayDate
      //(0008,0024)
      = const DED("OverlayDate", 0x00080024, "Overlay Date", VR.kDA, VM.k1, true);
  static const DED kCurveDate
      //(0008,0025)
      = const DED("CurveDate", 0x00080025, "Curve Date", VR.kDA, VM.k1, true);
  static const DED kAcquisitionDateTime
      //(0008,002A)
      = const DED(
          "AcquisitionDateTime", 0x0008002A, "Acquisition DateTime", VR.kDT, VM.k1, false);
  static const DED kStudyTime
      //(0008,0030)
      = const DED("StudyTime", 0x00080030, "Study Time", VR.kTM, VM.k1, false);
  static const DED kSeriesTime
      //(0008,0031)
      = const DED("SeriesTime", 0x00080031, "Series Time", VR.kTM, VM.k1, false);
  static const DED kAcquisitionTime
      //(0008,0032)
      = const DED("AcquisitionTime", 0x00080032, "Acquisition Time", VR.kTM, VM.k1, false);
  static const DED kContentTime
      //(0008,0033)
      = const DED("ContentTime", 0x00080033, "Content Time", VR.kTM, VM.k1, false);
  static const DED kOverlayTime
      //(0008,0034)
      = const DED("OverlayTime", 0x00080034, "Overlay Time", VR.kTM, VM.k1, true);
  static const DED kCurveTime
      //(0008,0035)
      = const DED("CurveTime", 0x00080035, "Curve Time", VR.kTM, VM.k1, true);
  static const DED kDataSetType
      //(0008,0040)
      = const DED("DataSetType", 0x00080040, "Data Set Type", VR.kUS, VM.k1, true);
  static const DED kDataSetSubtype
      //(0008,0041)
      = const DED("DataSetSubtype", 0x00080041, "Data Set Subtype", VR.kLO, VM.k1, true);
  static const DED kNuclearMedicineSeriesType
      //(0008,0042)
      = const DED("NuclearMedicineSeriesType", 0x00080042, "Nuclear Medicine Series Type",
          VR.kCS, VM.k1, true);
  static const DED kAccessionNumber
      //(0008,0050)
      = const DED("AccessionNumber", 0x00080050, "Accession Number", VR.kSH, VM.k1, false);
  static const DED kIssuerOfAccessionNumberSequence
      //(0008,0051)
      = const DED("IssuerOfAccessionNumberSequence", 0x00080051,
          "Issuer of Accession Number Sequence", VR.kSQ, VM.k1, false);
  static const DED kQueryRetrieveLevel
      //(0008,0052)
      =
      const DED("QueryRetrieveLevel", 0x00080052, "Query/Retrieve Level", VR.kCS, VM.k1, false);
  static const DED kQueryRetrieveView
      //(0008,0053)
      = const DED("QueryRetrieveView", 0x00080053, "Query/Retrieve View", VR.kCS, VM.k1, false);
  static const DED kRetrieveAETitle
      //(0008,0054)
      = const DED("RetrieveAETitle", 0x00080054, "Retrieve AE Title", VR.kAE, VM.k1_n, false);
  static const DED kInstanceAvailability
      //(0008,0056)
      = const DED(
          "InstanceAvailability", 0x00080056, "Instance Availability", VR.kCS, VM.k1, false);
  static const DED kFailedSOPInstanceUIDList
      //(0008,0058)
      = const DED("FailedSOPInstanceUIDList", 0x00080058, "Failed SOP Instance UID List",
          VR.kUI, VM.k1_n, false);
  static const DED kModality
      //(0008,0060)
      = const DED("Modality", 0x00080060, "Modality", VR.kCS, VM.k1, false);
  static const DED kModalitiesInStudy
      //(0008,0061)
      =
      const DED("ModalitiesInStudy", 0x00080061, "Modalities in Study", VR.kCS, VM.k1_n, false);
  static const DED kSOPClassesInStudy
      //(0008,0062)
      = const DED(
          "SOPClassesInStudy", 0x00080062, "SOP Classes in Study", VR.kUI, VM.k1_n, false);
  static const DED kConversionType
      //(0008,0064)
      = const DED("ConversionType", 0x00080064, "Conversion Type", VR.kCS, VM.k1, false);
  static const DED kPresentationIntentType
      //(0008,0068)
      = const DED(
          "PresentationIntentType", 0x00080068, "Presentation Intent Type", VR.kCS, VM.k1, false);
  static const DED kManufacturer
      //(0008,0070)
      = const DED("Manufacturer", 0x00080070, "Manufacturer", VR.kLO, VM.k1, false);
  static const DED kInstitutionName
      //(0008,0080)
      = const DED("InstitutionName", 0x00080080, "Institution Name", VR.kLO, VM.k1, false);
  static const DED kInstitutionAddress
      //(0008,0081)
      =
      const DED("InstitutionAddress", 0x00080081, "Institution Address", VR.kST, VM.k1, false);
  static const DED kInstitutionCodeSequence
      //(0008,0082)
      = const DED(
          "InstitutionCodeSequence", 0x00080082, "Institution Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferringPhysicianName
      //(0008,0090)
      = const DED(
          "ReferringPhysicianName", 0x00080090, "Referring Physician's Name", VR.kPN, VM.k1, false);
  static const DED kReferringPhysicianAddress
      //(0008,0092)
      = const DED("ReferringPhysicianAddress", 0x00080092, "Referring Physician's Address",
          VR.kST, VM.k1, false);
  static const DED kReferringPhysicianTelephoneNumbers
      //(0008,0094)
      = const DED("ReferringPhysicianTelephoneNumbers", 0x00080094,
          "Referring Physician's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const DED kReferringPhysicianIdentificationSequence
      //(0008,0096)
      = const DED("ReferringPhysicianIdentificationSequence", 0x00080096,
          "Referring Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kCodeValue
      //(0008,0100)
      = const DED("CodeValue", 0x00080100, "Code Value", VR.kSH, VM.k1, false);
  static const DED kExtendedCodeValue
      //(0008,0101)
      = const DED("ExtendedCodeValue", 0x00080101, "Extended Code Value", VR.kLO, VM.k1, false);
  static const DED kCodingSchemeDesignator
      //(0008,0102)
      = const DED(
          "CodingSchemeDesignator", 0x00080102, "Coding Scheme Designator", VR.kSH, VM.k1, false);
  static const DED kCodingSchemeVersion
      //(0008,0103)
      = const DED(
          "CodingSchemeVersion", 0x00080103, "Coding Scheme Version", VR.kSH, VM.k1, false);
  static const DED kCodeMeaning
      //(0008,0104)
      = const DED("CodeMeaning", 0x00080104, "Code Meaning", VR.kLO, VM.k1, false);
  static const DED kMappingResource
      //(0008,0105)
      = const DED("MappingResource", 0x00080105, "Mapping Resource", VR.kCS, VM.k1, false);
  static const DED kContextGroupVersion
      //(0008,0106)
      = const DED(
          "ContextGroupVersion", 0x00080106, "Context Group Version", VR.kDT, VM.k1, false);
  static const DED kContextGroupLocalVersion
      //(0008,0107)
      = const DED("ContextGroupLocalVersion", 0x00080107, "Context Group Local Version", VR.kDT,
          VM.k1, false);
  static const DED kExtendedCodeMeaning
      //(0008,0108)
      = const DED(
          "ExtendedCodeMeaning", 0x00080108, "Extended Code Meaning", VR.kLT, VM.k1, false);
  static const DED kContextGroupExtensionFlag
      //(0008,010B)
      = const DED("ContextGroupExtensionFlag", 0x0008010B, "Context Group Extension Flag",
          VR.kCS, VM.k1, false);
  static const DED kCodingSchemeUID
      //(0008,010C)
      = const DED("CodingSchemeUID", 0x0008010C, "Coding Scheme UID", VR.kUI, VM.k1, false);
  static const DED kContextGroupExtensionCreatorUID
      //(0008,010D)
      = const DED("ContextGroupExtensionCreatorUID", 0x0008010D,
          "Context Group Extension Creator UID", VR.kUI, VM.k1, false);
  static const DED kContextIdentifier
      //(0008,010F)
      = const DED("ContextIdentifier", 0x0008010F, "Context Identifier", VR.kCS, VM.k1, false);
  static const DED kCodingSchemeIdentificationSequence
      //(0008,0110)
      = const DED("CodingSchemeIdentificationSequence", 0x00080110,
          "Coding Scheme Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kCodingSchemeRegistry
      //(0008,0112)
      = const DED(
          "CodingSchemeRegistry", 0x00080112, "Coding Scheme Registry", VR.kLO, VM.k1, false);
  static const DED kCodingSchemeExternalID
      //(0008,0114)
      = const DED(
          "CodingSchemeExternalID", 0x00080114, "Coding Scheme External ID", VR.kST, VM.k1, false);
  static const DED kCodingSchemeName
      //(0008,0115)
      = const DED("CodingSchemeName", 0x00080115, "Coding Scheme Name", VR.kST, VM.k1, false);
  static const DED kCodingSchemeResponsibleOrganization
      //(0008,0116)
      = const DED("CodingSchemeResponsibleOrganization", 0x00080116,
          "Coding Scheme Responsible Organization", VR.kST, VM.k1, false);
  static const DED kContextUID
      //(0008,0117)
      = const DED("ContextUID", 0x00080117, "Context UID", VR.kUI, VM.k1, false);
  static const DED kTimezoneOffsetFromUTC
      //(0008,0201)
      = const DED(
          "TimezoneOffsetFromUTC", 0x00080201, "Timezone Offset From UTC", VR.kSH, VM.k1, false);

  static const kPrivateDataElementCharacteristicsSequence = const DED(
      "PrivateDataElementCharacteristicsSequence",
      0x0080300,
      "Private​Data​Element​Characteristics​Sequence",
      VR.kSQ,
      VM.k1,
      false);

  static const kPrivateGroupReference = const DED(
      "PrivateGroupReference",
      0x00080301,
      "Private Group Reference",
      VR.kUS,
      VM.k1,
      false);


  static const kPrivateCreatorReference = const DED(
      "PrivateCreatorReference",
      0x00080302,
      "Private Creator Reference",
      VR.kLO,
      VM.k1,
      false);

  static const kBlockIdentifyingInformationStatus = const DED(
      "BlockIdentifyingInformationStatus",
      0x00080303,
      "Block Identifying Information Status",
      VR.kCS,
      VM.k1,
      false);

  static const kNonidentifyingPrivateElements = const DED(
      "NonidentifyingPrivateElements",
      0x00080304,
      "Nonidentifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const kDeidentificationActionSequence = const DED(
      "DeidentificationActionSequence",
      0x00080305,
      "Deidentification Action Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const kIdentifyingPrivateElements = const DED(
      "IdentifyingPrivateElements",
      0x00080306,
      "Identifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const kDeidentificationAction = const DED(
      "DeidentificationAction",
      0x00080307,
      "Deidentification Action",
      VR.kCS,
      VM.k1,
      false);
  static const DED kNetworkID
      //(0008,1000)
      = const DED("NetworkID", 0x00081000, "Network ID", VR.kAE, VM.k1, true);
  static const DED kStationName
      //(0008,1010)
      = const DED("StationName", 0x00081010, "Station Name", VR.kSH, VM.k1, false);
  static const DED kStudyDescription
      //(0008,1030)
      = const DED("StudyDescription", 0x00081030, "Study Description", VR.kLO, VM.k1, false);
  static const DED kProcedureCodeSequence
      //(0008,1032)
      = const DED(
          "ProcedureCodeSequence", 0x00081032, "Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSeriesDescription
      //(0008,103E)
      = const DED("SeriesDescription", 0x0008103E, "Series Description", VR.kLO, VM.k1, false);
  static const DED kSeriesDescriptionCodeSequence
      //(0008,103F)
      = const DED("SeriesDescriptionCodeSequence", 0x0008103F,
          "Series Description Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kInstitutionalDepartmentName
      //(0008,1040)
      = const DED("InstitutionalDepartmentName", 0x00081040, "Institutional Department Name",
          VR.kLO, VM.k1, false);
  static const DED kPhysiciansOfRecord
      //(0008,1048)
      = const DED(
          "PhysiciansOfRecord", 0x00081048, "Physician(s) of Record", VR.kPN, VM.k1_n, false);
  static const DED kPhysiciansOfRecordIdentificationSequence
      //(0008,1049)
      = const DED("PhysiciansOfRecordIdentificationSequence", 0x00081049,
          "Physician(s) of Record Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformingPhysicianName
      //(0008,1050)
      = const DED("PerformingPhysicianName", 0x00081050, "Performing Physician's Name", VR.kPN,
          VM.k1_n, false);
  static const DED kPerformingPhysicianIdentificationSequence
      //(0008,1052)
      = const DED("PerformingPhysicianIdentificationSequence", 0x00081052,
          "Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kNameOfPhysiciansReadingStudy
      //(0008,1060)
      = const DED("NameOfPhysiciansReadingStudy", 0x00081060,
          "Name of Physician(s) Reading Study", VR.kPN, VM.k1_n, false);
  static const DED kPhysiciansReadingStudyIdentificationSequence
      //(0008,1062)
      = const DED("PhysiciansReadingStudyIdentificationSequence", 0x00081062,
          "Physician(s) Reading Study Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kOperatorsName
      //(0008,1070)
      = const DED("OperatorsName", 0x00081070, "Operators' Name", VR.kPN, VM.k1_n, false);
  static const DED kOperatorIdentificationSequence
      //(0008,1072)
      = const DED("OperatorIdentificationSequence", 0x00081072,
          "Operator Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kAdmittingDiagnosesDescription
      //(0008,1080)
      = const DED("AdmittingDiagnosesDescription", 0x00081080,
          "Admitting Diagnoses Description", VR.kLO, VM.k1_n, false);
  static const DED kAdmittingDiagnosesCodeSequence
      //(0008,1084)
      = const DED("AdmittingDiagnosesCodeSequence", 0x00081084,
          "Admitting Diagnoses Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kManufacturerModelName
      //(0008,1090)
      = const DED(
          "ManufacturerModelName", 0x00081090, "Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const DED kReferencedResultsSequence
      //(0008,1100)
      = const DED("ReferencedResultsSequence", 0x00081100, "Referenced Results Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kReferencedStudySequence
      //(0008,1110)
      = const DED(
          "ReferencedStudySequence", 0x00081110, "Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedPerformedProcedureStepSequence
      //(0008,1111)
      = const DED("ReferencedPerformedProcedureStepSequence", 0x00081111,
          "Referenced Performed Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSeriesSequence
      //(0008,1115)
      = const DED("ReferencedSeriesSequence", 0x00081115, "Referenced Series Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kReferencedPatientSequence
      //(0008,1120)
      = const DED("ReferencedPatientSequence", 0x00081120, "Referenced Patient Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedVisitSequence
      //(0008,1125)
      = const DED(
          "ReferencedVisitSequence", 0x00081125, "Referenced Visit Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedOverlaySequence
      //(0008,1130)
      = const DED("ReferencedOverlaySequence", 0x00081130, "Referenced Overlay Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kReferencedStereometricInstanceSequence
      //(0008,1134)
      = const DED("ReferencedStereometricInstanceSequence", 0x00081134,
          "Referenced Stereometric Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedWaveformSequence
      //(0008,113A)
      = const DED("ReferencedWaveformSequence", 0x0008113A, "Referenced Waveform Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedImageSequence
      //(0008,1140)
      = const DED(
          "ReferencedImageSequence", 0x00081140, "Referenced Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedCurveSequence
      //(0008,1145)
      = const DED(
          "ReferencedCurveSequence", 0x00081145, "Referenced Curve Sequence", VR.kSQ, VM.k1, true);
  static const DED kReferencedInstanceSequence
      //(0008,114A)
      = const DED("ReferencedInstanceSequence", 0x0008114A, "Referenced Instance Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedRealWorldValueMappingInstanceSequence
      //(0008,114B)
      = const DED("ReferencedRealWorldValueMappingInstanceSequence", 0x0008114B,
          "Referenced Real World Value Mapping Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSOPClassUID
      //(0008,1150)
      = const DED(
          "ReferencedSOPClassUID", 0x00081150, "Referenced SOP Class UID", VR.kUI, VM.k1, false);
  static const DED kReferencedSOPInstanceUID
      //(0008,1155)
      = const DED("ReferencedSOPInstanceUID", 0x00081155, "Referenced SOP Instance UID", VR.kUI,
          VM.k1, false);
  static const DED kSOPClassesSupported
      //(0008,115A)
      = const DED(
          "SOPClassesSupported", 0x0008115A, "SOP Classes Supported", VR.kUI, VM.k1_n, false);
  static const DED kReferencedFrameNumber
      //(0008,1160)
      = const DED(
          "ReferencedFrameNumber", 0x00081160, "Referenced Frame Number", VR.kIS, VM.k1_n, false);
  static const DED kSimpleFrameList
      //(0008,1161)
      = const DED("SimpleFrameList", 0x00081161, "Simple Frame List", VR.kUL, VM.k1_n, false);
  static const DED kCalculatedFrameList
      //(0008,1162)
      = const DED(
          "CalculatedFrameList", 0x00081162, "Calculated Frame List", VR.kUL, VM.k3_3n, false);
  static const DED kTimeRange
      //(0008,1163)
      = const DED("TimeRange", 0x00081163, "TimeRange", VR.kFD, VM.k2, false);
  static const DED kFrameExtractionSequence
      //(0008,1164)
      = const DED(
          "FrameExtractionSequence", 0x00081164, "Frame Extraction Sequence", VR.kSQ, VM.k1, false);
  static const DED kMultiFrameSourceSOPInstanceUID
      //(0008,1167)
      = const DED("MultiFrameSourceSOPInstanceUID", 0x00081167,
          "Multi-frame Source SOP Instance UID", VR.kUI, VM.k1, false);
  static const DED kRetrieveURL
      //(0008,1190)
      = const DED("RetrieveURL", 0x00081190, "Retrieve URL", VR.kUT, VM.k1, false);
  static const DED kTransactionUID
      //(0008,1195)
      = const DED("TransactionUID", 0x00081195, "Transaction UID", VR.kUI, VM.k1, false);
  static const DED kWarningReason
      //(0008,1196)
      = const DED("WarningReason", 0x00081196, "Warning Reason", VR.kUS, VM.k1, false);
  static const DED kFailureReason
      //(0008,1197)
      = const DED("FailureReason", 0x00081197, "Failure Reason", VR.kUS, VM.k1, false);
  static const DED kFailedSOPSequence
      //(0008,1198)
      = const DED("FailedSOPSequence", 0x00081198, "Failed SOP Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSOPSequence
      //(0008,1199)
      = const DED(
          "ReferencedSOPSequence", 0x00081199, "Referenced SOP Sequence", VR.kSQ, VM.k1, false);
  static const DED kStudiesContainingOtherReferencedInstancesSequence
      //(0008,1200)
      = const DED("StudiesContainingOtherReferencedInstancesSequence", 0x00081200,
          "Studies Containing Other Referenced Instances Sequence", VR.kSQ, VM.k1, false);
  static const DED kRelatedSeriesSequence
      //(0008,1250)
      = const DED(
          "RelatedSeriesSequence", 0x00081250, "Related Series Sequence", VR.kSQ, VM.k1, false);
  static const DED kLossyImageCompressionRetired
      //(0008,2110)
      = const DED("LossyImageCompressionRetired", 0x00082110,
          "Lossy Image Compression (Retired)", VR.kCS, VM.k1, true);
  static const DED kDerivationDescription
      //(0008,2111)
      = const DED(
          "DerivationDescription", 0x00082111, "Derivation Description", VR.kST, VM.k1, false);
  static const DED kSourceImageSequence
      //(0008,2112)
      = const DED(
          "SourceImageSequence", 0x00082112, "Source Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kStageName
      //(0008,2120)
      = const DED("StageName", 0x00082120, "Stage Name", VR.kSH, VM.k1, false);
  static const DED kStageNumber
      //(0008,2122)
      = const DED("StageNumber", 0x00082122, "Stage Number", VR.kIS, VM.k1, false);
  static const DED kNumberOfStages
      //(0008,2124)
      =
      const DED("NumberOfStages", 0x00082124, "Number of Stages", VR.kIS, VM.k1, false);
  static const DED kViewName
      //(0008,2127)
      = const DED("ViewName", 0x00082127, "View Name", VR.kSH, VM.k1, false);
  static const DED kViewNumber
      //(0008,2128)
      = const DED("ViewNumber", 0x00082128, "View Number", VR.kIS, VM.k1, false);
  static const DED kNumberOfEventTimers
      //(0008,2129)
      = const DED(
          "NumberOfEventTimers", 0x00082129, "Number of Event Timers", VR.kIS, VM.k1, false);
  static const DED kNumberOfViewsInStage
      //(0008,212A)
      = const DED("NumberOfViewsInStage", 0x0008212A, "Number of Views in Stage",
          VR.kIS, VM.k1, false);
  static const DED kEventElapsedTimes
      //(0008,2130)
      = const DED(
          "EventElapsedTimes", 0x00082130, "Event Elapsed Time(s)", VR.kDS, VM.k1_n, false);
  static const DED kEventTimerNames
      //(0008,2132)
      = const DED("EventTimerNames", 0x00082132, "Event Timer Name(s)", VR.kLO, VM.k1_n, false);
  static const DED kEventTimerSequence
      //(0008,2133)
      =
      const DED("EventTimerSequence", 0x00082133, "Event Timer Sequence", VR.kSQ, VM.k1, false);
  static const DED kEventTimeOffset
      //(0008,2134)
      = const DED("EventTimeOffset", 0x00082134, "Event Time Offset", VR.kFD, VM.k1, false);
  static const DED kEventCodeSequence
      //(0008,2135)
      = const DED("EventCodeSequence", 0x00082135, "Event Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kStartTrim
      //(0008,2142)
      = const DED("StartTrim", 0x00082142, "Start Trim", VR.kIS, VM.k1, false);
  static const DED kStopTrim
      //(0008,2143)
      = const DED("StopTrim", 0x00082143, "Stop Trim", VR.kIS, VM.k1, false);
  static const DED kRecommendedDisplayFrameRate
      //(0008,2144)
      = const DED("RecommendedDisplayFrameRate", 0x00082144, "Recommended Display Frame Rate",
          VR.kIS, VM.k1, false);
  static const DED kTransducerPosition
      //(0008,2200)
      = const DED("TransducerPosition", 0x00082200, "Transducer Position", VR.kCS, VM.k1, true);
  static const DED kTransducerOrientation
      //(0008,2204)
      = const DED(
          "TransducerOrientation", 0x00082204, "Transducer Orientation", VR.kCS, VM.k1, true);
  static const DED kAnatomicStructure
      //(0008,2208)
      = const DED("AnatomicStructure", 0x00082208, "Anatomic Structure", VR.kCS, VM.k1, true);
  static const DED kAnatomicRegionSequence
      //(0008,2218)
      = const DED(
          "AnatomicRegionSequence", 0x00082218, "Anatomic Region Sequence", VR.kSQ, VM.k1, false);
  static const DED kAnatomicRegionModifierSequence
      //(0008,2220)
      = const DED("AnatomicRegionModifierSequence", 0x00082220,
          "Anatomic Region Modifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kPrimaryAnatomicStructureSequence
      //(0008,2228)
      = const DED("PrimaryAnatomicStructureSequence", 0x00082228,
          "Primary Anatomic Structure Sequence", VR.kSQ, VM.k1, false);
  static const DED kAnatomicStructureSpaceOrRegionSequence
      //(0008,2229)
      = const DED("AnatomicStructureSpaceOrRegionSequence", 0x00082229,
          "Anatomic Structure: Space or Region Sequence", VR.kSQ, VM.k1, false);
  static const DED kPrimaryAnatomicStructureModifierSequence
      //(0008,2230)
      = const DED("PrimaryAnatomicStructureModifierSequence", 0x00082230,
          "Primary Anatomic Structure Modifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kTransducerPositionSequence
      //(0008,2240)
      = const DED("TransducerPositionSequence", 0x00082240, "Transducer Position Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kTransducerPositionModifierSequence
      //(0008,2242)
      = const DED("TransducerPositionModifierSequence", 0x00082242,
          "Transducer Position Modifier Sequence", VR.kSQ, VM.k1, true);
  static const DED kTransducerOrientationSequence
      //(0008,2244)
      = const DED("TransducerOrientationSequence", 0x00082244,
          "Transducer Orientation Sequence", VR.kSQ, VM.k1, true);
  static const DED kTransducerOrientationModifierSequence
      //(0008,2246)
      = const DED("TransducerOrientationModifierSequence", 0x00082246,
          "Transducer Orientation Modifier Sequence", VR.kSQ, VM.k1, true);
  static const DED kAnatomicStructureSpaceOrRegionCodeSequenceTrial
      //(0008,2251)
      = const DED("AnatomicStructureSpaceOrRegionCodeSequenceTrial", 0x00082251,
          "Anatomic Structure Space Or Region Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAnatomicPortalOfEntranceCodeSequenceTrial
      //(0008,2253)
      = const DED("AnatomicPortalOfEntranceCodeSequenceTrial", 0x00082253,
          "Anatomic Portal Of Entrance Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAnatomicApproachDirectionCodeSequenceTrial
      //(0008,2255)
      = const DED("AnatomicApproachDirectionCodeSequenceTrial", 0x00082255,
          "Anatomic Approach Direction Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAnatomicPerspectiveDescriptionTrial
      //(0008,2256)
      = const DED("AnatomicPerspectiveDescriptionTrial", 0x00082256,
          "Anatomic Perspective Description (Trial)", VR.kST, VM.k1, true);
  static const DED kAnatomicPerspectiveCodeSequenceTrial
      //(0008,2257)
      = const DED("AnatomicPerspectiveCodeSequenceTrial", 0x00082257,
          "Anatomic Perspective Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAnatomicLocationOfExaminingInstrumentDescriptionTrial
      //(0008,2258)
      = const DED("AnatomicLocationOfExaminingInstrumentDescriptionTrial", 0x00082258,
          "Anatomic Location Of Examining Instrument Description (Trial)", VR.kST, VM.k1, true);
  static const DED kAnatomicLocationOfExaminingInstrumentCodeSequenceTrial
      //(0008,2259)
      = const DED("AnatomicLocationOfExaminingInstrumentCodeSequenceTrial", 0x00082259,
          "Anatomic Location Of Examining Instrument Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAnatomicStructureSpaceOrRegionModifierCodeSequenceTrial
      //(0008,225A)
      = const DED("AnatomicStructureSpaceOrRegionModifierCodeSequenceTrial", 0x0008225A,
          "Anatomic Structure Space Or Region Modifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kOnAxisBackgroundAnatomicStructureCodeSequenceTrial
      //(0008,225C)
      = const DED("OnAxisBackgroundAnatomicStructureCodeSequenceTrial", 0x0008225C,
          "OnAxis Background Anatomic Structure Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAlternateRepresentationSequence
      //(0008,3001)
      = const DED("AlternateRepresentationSequence", 0x00083001,
          "Alternate Representation Sequence", VR.kSQ, VM.k1, false);
  static const DED kIrradiationEventUID
      //(0008,3010)
      = const DED(
          "IrradiationEventUID", 0x00083010, "Irradiation Event UID", VR.kUI, VM.k1_n, false);
  static const DED kIdentifyingComments
      //(0008,4000)
      =
      const DED("IdentifyingComments", 0x00084000, "Identifying Comments", VR.kLT, VM.k1, true);
  static const DED kFrameType
      //(0008,9007)
      = const DED("FrameType", 0x00089007, "Frame Type", VR.kCS, VM.k4, false);
  static const DED kReferencedImageEvidenceSequence
      //(0008,9092)
      = const DED("ReferencedImageEvidenceSequence", 0x00089092,
          "Referenced Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedRawDataSequence
      //(0008,9121)
      = const DED("ReferencedRawDataSequence", 0x00089121, "Referenced Raw Data Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCreatorVersionUID
      //(0008,9123)
      = const DED("CreatorVersionUID", 0x00089123, "Creator-Version UID", VR.kUI, VM.k1, false);
  static const DED kDerivationImageSequence
      //(0008,9124)
      = const DED(
          "DerivationImageSequence", 0x00089124, "Derivation Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceImageEvidenceSequence
      //(0008,9154)
      = const DED("SourceImageEvidenceSequence", 0x00089154, "Source Image Evidence Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPixelPresentation
      //(0008,9205)
      = const DED("PixelPresentation", 0x00089205, "Pixel Presentation", VR.kCS, VM.k1, false);
  static const DED kVolumetricProperties
      //(0008,9206)
      = const DED(
          "VolumetricProperties", 0x00089206, "Volumetric Properties", VR.kCS, VM.k1, false);
  static const DED kVolumeBasedCalculationTechnique
      //(0008,9207)
      = const DED("VolumeBasedCalculationTechnique", 0x00089207,
          "Volume Based Calculation Technique", VR.kCS, VM.k1, false);
  static const DED kComplexImageComponent
      //(0008,9208)
      = const DED(
          "ComplexImageComponent", 0x00089208, "Complex Image Component", VR.kCS, VM.k1, false);
  static const DED kAcquisitionContrast
      //(0008,9209)
      = const DED(
          "AcquisitionContrast", 0x00089209, "Acquisition Contrast", VR.kCS, VM.k1, false);
  static const DED kDerivationCodeSequence
      //(0008,9215)
      = const DED(
          "DerivationCodeSequence", 0x00089215, "Derivation Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedPresentationStateSequence
      //(0008,9237)
      = const DED("ReferencedPresentationStateSequence", 0x00089237,
          "Referenced Presentation State Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedOtherPlaneSequence
      //(0008,9410)
      = const DED("ReferencedOtherPlaneSequence", 0x00089410, "Referenced Other Plane Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kFrameDisplaySequence
      //(0008,9458)
      = const DED(
          "FrameDisplaySequence", 0x00089458, "Frame Display Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecommendedDisplayFrameRateInFloat
      //(0008,9459)
      = const DED("RecommendedDisplayFrameRateInFloat", 0x00089459,
          "Recommended Display Frame Rate in Float", VR.kFL, VM.k1, false);
  static const DED kSkipFrameRangeFlag
      //(0008,9460)
      = const DED(
          "SkipFrameRangeFlag", 0x00089460, "Skip Frame Range Flag", VR.kCS, VM.k1, false);
  static const DED kPatientName
      //(0010,0010)
      = const DED("PatientName", 0x00100010, "Patient's Name", VR.kPN, VM.k1, false);
  static const DED kPatientID
      //(0010,0020)
      = const DED("PatientID", 0x00100020, "Patient ID", VR.kLO, VM.k1, false);
  static const DED kIssuerOfPatientID
      //(0010,0021)
      =
      const DED("IssuerOfPatientID", 0x00100021, "Issuer of Patient ID", VR.kLO, VM.k1, false);
  static const DED kTypeOfPatientID
      //(0010,0022)
      = const DED("TypeOfPatientID", 0x00100022, "Type of Patient ID", VR.kCS, VM.k1, false);
  static const DED kIssuerOfPatientIDQualifiersSequence
      //(0010,0024)
      = const DED("IssuerOfPatientIDQualifiersSequence", 0x00100024,
          "Issuer of Patient ID Qualifiers Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientBirthDate
      //(0010,0030)
      = const DED("PatientBirthDate", 0x00100030, "Patient's Birth Date", VR.kDA, VM.k1, false);
  static const DED kPatientBirthTime
      //(0010,0032)
      = const DED("PatientBirthTime", 0x00100032, "Patient's Birth Time", VR.kTM, VM.k1, false);
  static const DED kPatientSex
      //(0010,0040)
      = const DED("PatientSex", 0x00100040, "Patient's Sex", VR.kCS, VM.k1, false);
  static const DED kPatientInsurancePlanCodeSequence
      //(0010,0050)
      = const DED("PatientInsurancePlanCodeSequence", 0x00100050,
          "Patient's Insurance Plan Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientPrimaryLanguageCodeSequence
      //(0010,0101)
      = const DED("PatientPrimaryLanguageCodeSequence", 0x00100101,
          "Patient's Primary Language Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientPrimaryLanguageModifierCodeSequence
      //(0010,0102)
      = const DED("PatientPrimaryLanguageModifierCodeSequence", 0x00100102,
          "Patient's Primary Language Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kQualityControlSubject
      //(0010,0200)
      = const DED(
          "QualityControlSubject", 0x00100200, "Quality Control Subject", VR.kCS, VM.k1, false);
  static const DED kQualityControlSubjectTypeCodeSequence
      //(0010,0201)
      = const DED("QualityControlSubjectTypeCodeSequence", 0x00100201,
          "Quality Control Subject Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOtherPatientIDs
      //(0010,1000)
      = const DED("OtherPatientIDs", 0x00101000, "Other Patient IDs", VR.kLO, VM.k1_n, false);
  static const DED kOtherPatientNames
      //(0010,1001)
      =
      const DED("OtherPatientNames", 0x00101001, "Other Patient Names", VR.kPN, VM.k1_n, false);
  static const DED kOtherPatientIDsSequence
      //(0010,1002)
      = const DED("OtherPatientIDsSequence", 0x00101002, "Other Patient IDs Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kPatientBirthName
      //(0010,1005)
      = const DED("PatientBirthName", 0x00101005, "Patient's Birth Name", VR.kPN, VM.k1, false);
  static const DED kPatientAge
      //(0010,1010)
      = const DED("PatientAge", 0x00101010, "Patient's Age", VR.kAS, VM.k1, false);
  static const DED kPatientSize
      //(0010,1020)
      = const DED("PatientSize", 0x00101020, "Patient's Size", VR.kDS, VM.k1, false);
  static const DED kPatientSizeCodeSequence
      //(0010,1021)
      = const DED("PatientSizeCodeSequence", 0x00101021, "Patient's Size Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kPatientWeight
      //(0010,1030)
      = const DED("PatientWeight", 0x00101030, "Patient's Weight", VR.kDS, VM.k1, false);
  static const DED kPatientAddress
      //(0010,1040)
      = const DED("PatientAddress", 0x00101040, "Patient's Address", VR.kLO, VM.k1, false);
  static const DED kInsurancePlanIdentification
      //(0010,1050)
      = const DED("InsurancePlanIdentification", 0x00101050, "Insurance Plan Identification",
          VR.kLO, VM.k1_n, true);
  static const DED kPatientMotherBirthName
      //(0010,1060)
      = const DED("PatientMotherBirthName", 0x00101060, "Patient's Mother's Birth Name", VR.kPN,
          VM.k1, false);
  static const DED kMilitaryRank
      //(0010,1080)
      = const DED("MilitaryRank", 0x00101080, "Military Rank", VR.kLO, VM.k1, false);
  static const DED kBranchOfService
      //(0010,1081)
      = const DED("BranchOfService", 0x00101081, "Branch of Service", VR.kLO, VM.k1, false);
  static const DED kMedicalRecordLocator
      //(0010,1090)
      = const DED(
          "MedicalRecordLocator", 0x00101090, "Medical Record Locator", VR.kLO, VM.k1, false);
  static const DED kReferencedPatientPhotoSequence = const DED(
      // (0010,1100)
      "ReferencedPatientPhotoSequence",
      0x00101100,
      "Referenced Patient Photo Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const DED kMedicalAlerts
      //(0010,2000)
      = const DED("MedicalAlerts", 0x00102000, "Medical Alerts", VR.kLO, VM.k1_n, false);
  static const DED kAllergies
      //(0010,2110)
      = const DED("Allergies", 0x00102110, "Allergies", VR.kLO, VM.k1_n, false);
  static const DED kCountryOfResidence
      //(0010,2150)
      =
      const DED("CountryOfResidence", 0x00102150, "Country of Residence", VR.kLO, VM.k1, false);
  static const DED kRegionOfResidence
      //(0010,2152)
      = const DED("RegionOfResidence", 0x00102152, "Region of Residence", VR.kLO, VM.k1, false);
  static const DED kPatientTelephoneNumbers
      //(0010,2154)
      = const DED("PatientTelephoneNumbers", 0x00102154, "Patient's Telephone Numbers", VR.kSH,
          VM.k1_n, false);
  static const DED kEthnicGroup
      //(0010,2160)
      = const DED("EthnicGroup", 0x00102160, "Ethnic Group", VR.kSH, VM.k1, false);
  static const DED kOccupation
      //(0010,2180)
      = const DED("Occupation", 0x00102180, "Occupation", VR.kSH, VM.k1, false);
  static const DED kSmokingStatus
      //(0010,21A0)
      = const DED("SmokingStatus", 0x001021A0, "Smoking Status", VR.kCS, VM.k1, false);
  static const DED kAdditionalPatientHistory
      //(0010,21B0)
      = const DED("AdditionalPatientHistory", 0x001021B0, "Additional Patient History", VR.kLT,
          VM.k1, false);
  static const DED kPregnancyStatus
      //(0010,21C0)
      = const DED("PregnancyStatus", 0x001021C0, "Pregnancy Status", VR.kUS, VM.k1, false);
  static const DED kLastMenstrualDate
      //(0010,21D0)
      = const DED("LastMenstrualDate", 0x001021D0, "Last Menstrual Date", VR.kDA, VM.k1, false);
  static const DED kPatientReligiousPreference
      //(0010,21F0)
      = const DED("PatientReligiousPreference", 0x001021F0, "Patient's Religious Preference",
          VR.kLO, VM.k1, false);
  static const DED kPatientSpeciesDescription
      //(0010,2201)
      = const DED("PatientSpeciesDescription", 0x00102201, "Patient Species Description",
          VR.kLO, VM.k1, false);
  static const DED kPatientSpeciesCodeSequence
      //(0010,2202)
      = const DED("PatientSpeciesCodeSequence", 0x00102202, "Patient Species Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPatientSexNeutered
      //(0010,2203)
      = const DED(
          "PatientSexNeutered", 0x00102203, "Patient's Sex Neutered", VR.kCS, VM.k1, false);
  static const DED kAnatomicalOrientationType
      //(0010,2210)
      = const DED("AnatomicalOrientationType", 0x00102210, "Anatomical Orientation Type",
          VR.kCS, VM.k1, false);
  static const DED kPatientBreedDescription
      //(0010,2292)
      = const DED(
          "PatientBreedDescription", 0x00102292, "Patient Breed Description", VR.kLO, VM.k1, false);
  static const DED kPatientBreedCodeSequence
      //(0010,2293)
      = const DED("PatientBreedCodeSequence", 0x00102293, "Patient Breed Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kBreedRegistrationSequence
      //(0010,2294)
      = const DED("BreedRegistrationSequence", 0x00102294, "Breed Registration Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kBreedRegistrationNumber
      //(0010,2295)
      = const DED(
          "BreedRegistrationNumber", 0x00102295, "Breed Registration Number", VR.kLO, VM.k1, false);
  static const DED kBreedRegistryCodeSequence
      //(0010,2296)
      = const DED("BreedRegistryCodeSequence", 0x00102296, "Breed Registry Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kResponsiblePerson
      //(0010,2297)
      = const DED("ResponsiblePerson", 0x00102297, "Responsible Person", VR.kPN, VM.k1, false);
  static const DED kResponsiblePersonRole
      //(0010,2298)
      = const DED(
          "ResponsiblePersonRole", 0x00102298, "Responsible Person Role", VR.kCS, VM.k1, false);
  static const DED kResponsibleOrganization
      //(0010,2299)
      = const DED(
          "ResponsibleOrganization", 0x00102299, "Responsible Organization", VR.kLO, VM.k1, false);
  static const DED kPatientComments
      //(0010,4000)
      = const DED("PatientComments", 0x00104000, "Patient Comments", VR.kLT, VM.k1, false);
  static const DED kExaminedBodyThickness
      //(0010,9431)
      = const DED(
          "ExaminedBodyThickness", 0x00109431, "Examined Body Thickness", VR.kFL, VM.k1, false);
  static const DED kClinicalTrialSponsorName
      //(0012,0010)
      = const DED("ClinicalTrialSponsorName", 0x00120010, "Clinical Trial Sponsor Name", VR.kLO,
          VM.k1, false);
  static const DED kClinicalTrialProtocolID
      //(0012,0020)
      = const DED("ClinicalTrialProtocolID", 0x00120020, "Clinical Trial Protocol ID", VR.kLO,
          VM.k1, false);
  static const DED kClinicalTrialProtocolName
      //(0012,0021)
      = const DED("ClinicalTrialProtocolName", 0x00120021, "Clinical Trial Protocol Name",
          VR.kLO, VM.k1, false);
  static const DED kClinicalTrialSiteID
      //(0012,0030)
      = const DED(
          "ClinicalTrialSiteID", 0x00120030, "Clinical Trial Site ID", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialSiteName
      //(0012,0031)
      = const DED(
          "ClinicalTrialSiteName", 0x00120031, "Clinical Trial Site Name", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialSubjectID
      //(0012,0040)
      = const DED(
          "ClinicalTrialSubjectID", 0x00120040, "Clinical Trial Subject ID", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialSubjectReadingID
      //(0012,0042)
      = const DED("ClinicalTrialSubjectReadingID", 0x00120042,
          "Clinical Trial Subject Reading ID", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialTimePointID
      //(0012,0050)
      = const DED("ClinicalTrialTimePointID", 0x00120050, "Clinical Trial Time Point ID",
          VR.kLO, VM.k1, false);
  static const DED kClinicalTrialTimePointDescription
      //(0012,0051)
      = const DED("ClinicalTrialTimePointDescription", 0x00120051,
          "Clinical Trial Time Point Description", VR.kST, VM.k1, false);
  static const DED kClinicalTrialCoordinatingCenterName
      //(0012,0060)
      = const DED("ClinicalTrialCoordinatingCenterName", 0x00120060,
          "Clinical Trial Coordinating Center Name", VR.kLO, VM.k1, false);
  static const DED kPatientIdentityRemoved
      //(0012,0062)
      = const DED(
          "PatientIdentityRemoved", 0x00120062, "Patient Identity Removed", VR.kCS, VM.k1, false);
  static const DED kDeidentificationMethod
      //(0012,0063)
      = const DED(
          "DeidentificationMethod", 0x00120063, "De-identification Method", VR.kLO, VM.k1_n, false);
  static const DED kDeidentificationMethodCodeSequence
      //(0012,0064)
      = const DED("DeidentificationMethodCodeSequence", 0x00120064,
          "De-identification Method Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kClinicalTrialSeriesID
      //(0012,0071)
      = const DED(
          "ClinicalTrialSeriesID", 0x00120071, "Clinical Trial Series ID", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialSeriesDescription
      //(0012,0072)
      = const DED("ClinicalTrialSeriesDescription", 0x00120072,
          "Clinical Trial Series Description", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialProtocolEthicsCommitteeName
      //(0012,0081)
      = const DED("ClinicalTrialProtocolEthicsCommitteeName", 0x00120081,
          "Clinical Trial Protocol Ethics Committee Name", VR.kLO, VM.k1, false);
  static const DED kClinicalTrialProtocolEthicsCommitteeApprovalNumber
      //(0012,0082)
      = const DED("ClinicalTrialProtocolEthicsCommitteeApprovalNumber", 0x00120082,
          "Clinical Trial Protocol Ethics Committee Approval Number", VR.kLO, VM.k1, false);
  static const DED kConsentForClinicalTrialUseSequence
      //(0012,0083)
      = const DED("ConsentForClinicalTrialUseSequence", 0x00120083,
          "Consent for Clinical Trial Use Sequence", VR.kSQ, VM.k1, false);
  static const DED kDistributionType
      //(0012,0084)
      = const DED("DistributionType", 0x00120084, "Distribution Type", VR.kCS, VM.k1, false);
  static const DED kConsentForDistributionFlag
      //(0012,0085)
      = const DED("ConsentForDistributionFlag", 0x00120085, "Consent for Distribution Flag",
          VR.kCS, VM.k1, false);
  static const DED kCADFileFormat
      //(0014,0023)
      = const DED("CADFileFormat", 0x00140023, "CAD File Format", VR.kST, VM.k1_n, true);
  static const DED kComponentReferenceSystem
      //(0014,0024)
      = const DED("ComponentReferenceSystem", 0x00140024, "Component Reference System", VR.kST,
          VM.k1_n, true);
  static const DED kComponentManufacturingProcedure
      //(0014,0025)
      = const DED("ComponentManufacturingProcedure", 0x00140025,
          "Component Manufacturing Procedure", VR.kST, VM.k1_n, false);
  static const DED kComponentManufacturer
      //(0014,0028)
      = const DED(
          "ComponentManufacturer", 0x00140028, "Component Manufacturer", VR.kST, VM.k1_n, false);
  static const DED kMaterialThickness
      //(0014,0030)
      =
      const DED("MaterialThickness", 0x00140030, "Material Thickness", VR.kDS, VM.k1_n, false);
  static const DED kMaterialPipeDiameter
      //(0014,0032)
      = const DED(
          "MaterialPipeDiameter", 0x00140032, "Material Pipe Diameter", VR.kDS, VM.k1_n, false);
  static const DED kMaterialIsolationDiameter
      //(0014,0034)
      = const DED("MaterialIsolationDiameter", 0x00140034, "Material Isolation Diameter",
          VR.kDS, VM.k1_n, false);
  static const DED kMaterialGrade
      //(0014,0042)
      = const DED("MaterialGrade", 0x00140042, "Material Grade", VR.kST, VM.k1_n, false);
  static const DED kMaterialPropertiesDescription
      //(0014,0044)
      = const DED("MaterialPropertiesDescription", 0x00140044,
          "Material Properties Description", VR.kST, VM.k1_n, false);
  static const DED kMaterialPropertiesFileFormatRetired
      //(0014,0045)
      = const DED("MaterialPropertiesFileFormatRetired", 0x00140045,
          "Material Properties File Format (Retired)", VR.kST, VM.k1_n, true);
  static const DED kMaterialNotes
      //(0014,0046)
      = const DED("MaterialNotes", 0x00140046, "Material Notes", VR.kLT, VM.k1, false);
  static const DED kComponentShape
      //(0014,0050)
      = const DED("ComponentShape", 0x00140050, "Component Shape", VR.kCS, VM.k1, false);
  static const DED kCurvatureType
      //(0014,0052)
      = const DED("CurvatureType", 0x00140052, "Curvature Type", VR.kCS, VM.k1, false);
  static const DED kOuterDiameter
      //(0014,0054)
      = const DED("OuterDiameter", 0x00140054, "Outer Diameter", VR.kDS, VM.k1, false);
  static const DED kInnerDiameter
      //(0014,0056)
      = const DED("InnerDiameter", 0x00140056, "Inner Diameter", VR.kDS, VM.k1, false);
  static const DED kActualEnvironmentalConditions
      //(0014,1010)
      = const DED("ActualEnvironmentalConditions", 0x00141010,
          "Actual Environmental Conditions", VR.kST, VM.k1, false);
  static const DED kExpiryDate
      //(0014,1020)
      = const DED("ExpiryDate", 0x00141020, "Expiry Date", VR.kDA, VM.k1, false);
  static const DED kEnvironmentalConditions
      //(0014,1040)
      = const DED(
          "EnvironmentalConditions", 0x00141040, "Environmental Conditions", VR.kST, VM.k1, false);
  static const DED kEvaluatorSequence
      //(0014,2002)
      = const DED("EvaluatorSequence", 0x00142002, "Evaluator Sequence", VR.kSQ, VM.k1, false);
  static const DED kEvaluatorNumber
      //(0014,2004)
      = const DED("EvaluatorNumber", 0x00142004, "Evaluator Number", VR.kIS, VM.k1, false);
  static const DED kEvaluatorName
      //(0014,2006)
      = const DED("EvaluatorName", 0x00142006, "Evaluator Name", VR.kPN, VM.k1, false);
  static const DED kEvaluationAttempt
      //(0014,2008)
      = const DED("EvaluationAttempt", 0x00142008, "Evaluation Attempt", VR.kIS, VM.k1, false);
  static const DED kIndicationSequence
      //(0014,2012)
      =
      const DED("IndicationSequence", 0x00142012, "Indication Sequence", VR.kSQ, VM.k1, false);
  static const DED kIndicationNumber
      //(0014,2014)
      = const DED("IndicationNumber", 0x00142014, "Indication Number", VR.kIS, VM.k1, false);
  static const DED kIndicationLabel
      //(0014,2016)
      = const DED("IndicationLabel", 0x00142016, "Indication Label", VR.kSH, VM.k1, false);
  static const DED kIndicationDescription
      //(0014,2018)
      = const DED(
          "IndicationDescription", 0x00142018, "Indication Description", VR.kST, VM.k1, false);
  static const DED kIndicationType
      //(0014,201A)
      = const DED("IndicationType", 0x0014201A, "Indication Type", VR.kCS, VM.k1_n, false);
  static const DED kIndicationDisposition
      //(0014,201C)
      = const DED(
          "IndicationDisposition", 0x0014201C, "Indication Disposition", VR.kCS, VM.k1, false);
  static const DED kIndicationROISequence
      //(0014,201E)
      = const DED(
          "IndicationROISequence", 0x0014201E, "Indication ROI Sequence", VR.kSQ, VM.k1, false);
  static const DED kIndicationPhysicalPropertySequence
      //(0014,2030)
      = const DED("IndicationPhysicalPropertySequence", 0x00142030,
          "Indication Physical Property Sequence", VR.kSQ, VM.k1, false);
  static const DED kPropertyLabel
      //(0014,2032)
      = const DED("PropertyLabel", 0x00142032, "Property Label", VR.kSH, VM.k1, false);
  static const DED kCoordinateSystemNumberOfAxes
      //(0014,2202)
      = const DED("CoordinateSystemNumberOfAxes", 0x00142202,
          "Coordinate System Number of Axes", VR.kIS, VM.k1, false);
  static const DED kCoordinateSystemAxesSequence
      //(0014,2204)
      = const DED("CoordinateSystemAxesSequence", 0x00142204, "Coordinate System Axes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCoordinateSystemAxisDescription
      //(0014,2206)
      = const DED("CoordinateSystemAxisDescription", 0x00142206,
          "Coordinate System Axis Description", VR.kST, VM.k1, false);
  static const DED kCoordinateSystemDataSetMapping
      //(0014,2208)
      = const DED("CoordinateSystemDataSetMapping", 0x00142208,
          "Coordinate System Data Set Mapping", VR.kCS, VM.k1, false);
  static const DED kCoordinateSystemAxisNumber
      //(0014,220A)
      = const DED("CoordinateSystemAxisNumber", 0x0014220A, "Coordinate System Axis Number",
          VR.kIS, VM.k1, false);
  static const DED kCoordinateSystemAxisType
      //(0014,220C)
      = const DED("CoordinateSystemAxisType", 0x0014220C, "Coordinate System Axis Type", VR.kCS,
          VM.k1, false);
  static const DED kCoordinateSystemAxisUnits
      //(0014,220E)
      = const DED("CoordinateSystemAxisUnits", 0x0014220E, "Coordinate System Axis Units",
          VR.kCS, VM.k1, false);
  static const DED kCoordinateSystemAxisValues
      //(0014,2210)
      = const DED("CoordinateSystemAxisValues", 0x00142210, "Coordinate System Axis Values",
          VR.kOB, VM.k1, false);
  static const DED kCoordinateSystemTransformSequence
      //(0014,2220)
      = const DED("CoordinateSystemTransformSequence", 0x00142220,
          "Coordinate System Transform Sequence", VR.kSQ, VM.k1, false);
  static const DED kTransformDescription
      //(0014,2222)
      = const DED(
          "TransformDescription", 0x00142222, "Transform Description", VR.kST, VM.k1, false);
  static const DED kTransformNumberOfAxes
      //(0014,2224)
      = const DED(
          "TransformNumberOfAxes", 0x00142224, "Transform Number of Axes", VR.kIS, VM.k1, false);
  static const DED kTransformOrderOfAxes
      //(0014,2226)
      = const DED(
          "TransformOrderOfAxes", 0x00142226, "Transform Order of Axes", VR.kIS, VM.k1_n, false);
  static const DED kTransformedAxisUnits
      //(0014,2228)
      = const DED(
          "TransformedAxisUnits", 0x00142228, "Transformed Axis Units", VR.kCS, VM.k1, false);
  static const DED kCoordinateSystemTransformRotationAndScaleMatrix
      //(0014,222A)
      = const DED("CoordinateSystemTransformRotationAndScaleMatrix", 0x0014222A,
          "Coordinate System Transform Rotation and Scale Matrix", VR.kDS, VM.k1_n, false);
  static const DED kCoordinateSystemTransformTranslationMatrix
      //(0014,222C)
      = const DED("CoordinateSystemTransformTranslationMatrix", 0x0014222C,
          "Coordinate System Transform Translation Matrix", VR.kDS, VM.k1_n, false);
  static const DED kInternalDetectorFrameTime
      //(0014,3011)
      = const DED("InternalDetectorFrameTime", 0x00143011, "Internal Detector Frame Time",
          VR.kDS, VM.k1, false);
  static const DED kNumberOfFramesIntegrated
      //(0014,3012)
      = const DED("NumberOfFramesIntegrated", 0x00143012, "Number of Frames Integrated", VR.kDS,
          VM.k1, false);
  static const DED kDetectorTemperatureSequence
      //(0014,3020)
      = const DED("DetectorTemperatureSequence", 0x00143020, "Detector Temperature Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSensorName
      //(0014,3022)
      = const DED("SensorName", 0x00143022, "Sensor Name", VR.kST, VM.k1, false);
  static const DED kHorizontalOffsetOfSensor
      //(0014,3024)
      = const DED("HorizontalOffsetOfSensor", 0x00143024, "Horizontal Offset of Sensor", VR.kDS,
          VM.k1, false);
  static const DED kVerticalOffsetOfSensor
      //(0014,3026)
      = const DED(
          "VerticalOffsetOfSensor", 0x00143026, "Vertical Offset of Sensor", VR.kDS, VM.k1, false);
  static const DED kSensorTemperature
      //(0014,3028)
      = const DED("SensorTemperature", 0x00143028, "Sensor Temperature", VR.kDS, VM.k1, false);
  static const DED kDarkCurrentSequence
      //(0014,3040)
      = const DED(
          "DarkCurrentSequence", 0x00143040, "Dark Current Sequence", VR.kSQ, VM.k1, false);
  static const DED kDarkCurrentCounts
      //(0014,3050)
      =
      const DED("DarkCurrentCounts", 0x00143050, "Dark Current Counts", VR.kOBOW, VM.k1, false);
  static const DED kGainCorrectionReferenceSequence
      //(0014,3060)
      = const DED("GainCorrectionReferenceSequence", 0x00143060,
          "Gain Correction Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kAirCounts
      //(0014,3070)
      = const DED("AirCounts", 0x00143070, "Air Counts", VR.kOBOW, VM.k1, false);
  static const DED kKVUsedInGainCalibration
      //(0014,3071)
      = const DED("KVUsedInGainCalibration", 0x00143071, "KV Used in Gain Calibration", VR.kDS,
          VM.k1, false);
  static const DED kMAUsedInGainCalibration
      //(0014,3072)
      = const DED("MAUsedInGainCalibration", 0x00143072, "MA Used in Gain Calibration", VR.kDS,
          VM.k1, false);
  static const DED kNumberOfFramesUsedForIntegration
      //(0014,3073)
      = const DED("NumberOfFramesUsedForIntegration", 0x00143073,
          "Number of Frames Used for Integration", VR.kDS, VM.k1, false);
  static const DED kFilterMaterialUsedInGainCalibration
      //(0014,3074)
      = const DED("FilterMaterialUsedInGainCalibration", 0x00143074,
          "Filter Material Used in Gain Calibration", VR.kLO, VM.k1, false);
  static const DED kFilterThicknessUsedInGainCalibration
      //(0014,3075)
      = const DED("FilterThicknessUsedInGainCalibration", 0x00143075,
          "Filter Thickness Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const DED kDateOfGainCalibration
      //(0014,3076)
      = const DED(
          "DateOfGainCalibration", 0x00143076, "Date of Gain Calibration", VR.kDA, VM.k1, false);
  static const DED kTimeOfGainCalibration
      //(0014,3077)
      = const DED(
          "TimeOfGainCalibration", 0x00143077, "Time of Gain Calibration", VR.kTM, VM.k1, false);
  static const DED kBadPixelImage
      //(0014,3080)
      = const DED("BadPixelImage", 0x00143080, "Bad Pixel Image", VR.kOB, VM.k1, false);
  static const DED kCalibrationNotes
      //(0014,3099)
      = const DED("CalibrationNotes", 0x00143099, "Calibration Notes", VR.kLT, VM.k1, false);
  static const DED kPulserEquipmentSequence
      //(0014,4002)
      = const DED(
          "PulserEquipmentSequence", 0x00144002, "Pulser Equipment Sequence", VR.kSQ, VM.k1, false);
  static const DED kPulserType
      //(0014,4004)
      = const DED("PulserType", 0x00144004, "Pulser Type", VR.kCS, VM.k1, false);
  static const DED kPulserNotes
      //(0014,4006)
      = const DED("PulserNotes", 0x00144006, "Pulser Notes", VR.kLT, VM.k1, false);
  static const DED kReceiverEquipmentSequence
      //(0014,4008)
      = const DED("ReceiverEquipmentSequence", 0x00144008, "Receiver Equipment Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAmplifierType
      //(0014,400A)
      = const DED("AmplifierType", 0x0014400A, "Amplifier Type", VR.kCS, VM.k1, false);
  static const DED kReceiverNotes
      //(0014,400C)
      = const DED("ReceiverNotes", 0x0014400C, "Receiver Notes", VR.kLT, VM.k1, false);
  static const DED kPreAmplifierEquipmentSequence
      //(0014,400E)
      = const DED("PreAmplifierEquipmentSequence", 0x0014400E,
          "Pre-Amplifier Equipment Sequence", VR.kSQ, VM.k1, false);
  static const DED kPreAmplifierNotes
      //(0014,400F)
      = const DED("PreAmplifierNotes", 0x0014400F, "Pre-Amplifier Notes", VR.kLT, VM.k1, false);
  static const DED kTransmitTransducerSequence
      //(0014,4010)
      = const DED("TransmitTransducerSequence", 0x00144010, "Transmit Transducer Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReceiveTransducerSequence
      //(0014,4011)
      = const DED("ReceiveTransducerSequence", 0x00144011, "Receive Transducer Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kNumberOfElements
      //(0014,4012)
      = const DED("NumberOfElements", 0x00144012, "Number of Elements", VR.kUS, VM.k1, false);
  static const DED kElementShape
      //(0014,4013)
      = const DED("ElementShape", 0x00144013, "Element Shape", VR.kCS, VM.k1, false);
  static const DED kElementDimensionA
      //(0014,4014)
      = const DED("ElementDimensionA", 0x00144014, "Element Dimension A", VR.kDS, VM.k1, false);
  static const DED kElementDimensionB
      //(0014,4015)
      = const DED("ElementDimensionB", 0x00144015, "Element Dimension B", VR.kDS, VM.k1, false);
  static const DED kElementPitchA
      //(0014,4016)
      = const DED("ElementPitchA", 0x00144016, "Element Pitch A", VR.kDS, VM.k1, false);
  static const DED kMeasuredBeamDimensionA
      //(0014,4017)
      = const DED(
          "MeasuredBeamDimensionA", 0x00144017, "Measured Beam Dimension A", VR.kDS, VM.k1, false);
  static const DED kMeasuredBeamDimensionB
      //(0014,4018)
      = const DED(
          "MeasuredBeamDimensionB", 0x00144018, "Measured Beam Dimension B", VR.kDS, VM.k1, false);
  static const DED kLocationOfMeasuredBeamDiameter
      //(0014,4019)
      = const DED("LocationOfMeasuredBeamDiameter", 0x00144019,
          "Location of Measured Beam Diameter", VR.kDS, VM.k1, false);
  static const DED kNominalFrequency
      //(0014,401A)
      = const DED("NominalFrequency", 0x0014401A, "Nominal Frequency", VR.kDS, VM.k1, false);
  static const DED kMeasuredCenterFrequency
      //(0014,401B)
      = const DED(
          "MeasuredCenterFrequency", 0x0014401B, "Measured Center Frequency", VR.kDS, VM.k1, false);
  static const DED kMeasuredBandwidth
      //(0014,401C)
      = const DED("MeasuredBandwidth", 0x0014401C, "Measured Bandwidth", VR.kDS, VM.k1, false);
  static const DED kElementPitchB
      //(0014,401D)
      = const DED("ElementPitchB", 0x0014401D, "Element Pitch B", VR.kDS, VM.k1, false);
  static const DED kPulserSettingsSequence
      //(0014,4020)
      = const DED(
          "PulserSettingsSequence", 0x00144020, "Pulser Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kPulseWidth
      //(0014,4022)
      = const DED("PulseWidth", 0x00144022, "Pulse Width", VR.kDS, VM.k1, false);
  static const DED kExcitationFrequency
      //(0014,4024)
      = const DED(
          "ExcitationFrequency", 0x00144024, "Excitation Frequency", VR.kDS, VM.k1, false);
  static const DED kModulationType
      //(0014,4026)
      = const DED("ModulationType", 0x00144026, "Modulation Type", VR.kCS, VM.k1, false);
  static const DED kDamping
      //(0014,4028)
      = const DED("Damping", 0x00144028, "Damping", VR.kDS, VM.k1, false);
  static const DED kReceiverSettingsSequence
      //(0014,4030)
      = const DED("ReceiverSettingsSequence", 0x00144030, "Receiver Settings Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kAcquiredSoundpathLength
      //(0014,4031)
      = const DED(
          "AcquiredSoundpathLength", 0x00144031, "Acquired Soundpath Length", VR.kDS, VM.k1, false);
  static const DED kAcquisitionCompressionType
      //(0014,4032)
      = const DED("AcquisitionCompressionType", 0x00144032, "Acquisition Compression Type",
          VR.kCS, VM.k1, false);
  static const DED kAcquisitionSampleSize
      //(0014,4033)
      = const DED(
          "AcquisitionSampleSize", 0x00144033, "Acquisition Sample Size", VR.kIS, VM.k1, false);
  static const DED kRectifierSmoothing
      //(0014,4034)
      =
      const DED("RectifierSmoothing", 0x00144034, "Rectifier Smoothing", VR.kDS, VM.k1, false);
  static const DED kDACSequence
      //(0014,4035)
      = const DED("DACSequence", 0x00144035, "DAC Sequence", VR.kSQ, VM.k1, false);
  static const DED kDACType
      //(0014,4036)
      = const DED("DACType", 0x00144036, "DAC Type", VR.kCS, VM.k1, false);
  static const DED kDACGainPoints
      //(0014,4038)
      = const DED("DACGainPoints", 0x00144038, "DAC Gain Points", VR.kDS, VM.k1_n, false);
  static const DED kDACTimePoints
      //(0014,403A)
      = const DED("DACTimePoints", 0x0014403A, "DAC Time Points", VR.kDS, VM.k1_n, false);
  static const DED kDACAmplitude
      //(0014,403C)
      = const DED("DACAmplitude", 0x0014403C, "DAC Amplitude", VR.kDS, VM.k1_n, false);
  static const DED kPreAmplifierSettingsSequence
      //(0014,4040)
      = const DED("PreAmplifierSettingsSequence", 0x00144040, "Pre-Amplifier Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTransmitTransducerSettingsSequence
      //(0014,4050)
      = const DED("TransmitTransducerSettingsSequence", 0x00144050,
          "Transmit Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kReceiveTransducerSettingsSequence
      //(0014,4051)
      = const DED("ReceiveTransducerSettingsSequence", 0x00144051,
          "Receive Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kIncidentAngle
      //(0014,4052)
      = const DED("IncidentAngle", 0x00144052, "Incident Angle", VR.kDS, VM.k1, false);
  static const DED kCouplingTechnique
      //(0014,4054)
      = const DED("CouplingTechnique", 0x00144054, "Coupling Technique", VR.kST, VM.k1, false);
  static const DED kCouplingMedium
      //(0014,4056)
      = const DED("CouplingMedium", 0x00144056, "Coupling Medium", VR.kST, VM.k1, false);
  static const DED kCouplingVelocity
      //(0014,4057)
      = const DED("CouplingVelocity", 0x00144057, "Coupling Velocity", VR.kDS, VM.k1, false);
  static const DED kProbeCenterLocationX
      //(0014,4058)
      = const DED(
          "ProbeCenterLocationX", 0x00144058, "Probe Center Location X", VR.kDS, VM.k1, false);
  static const DED kProbeCenterLocationZ
      //(0014,4059)
      = const DED(
          "ProbeCenterLocationZ", 0x00144059, "Probe Center Location Z", VR.kDS, VM.k1, false);
  static const DED kSoundPathLength
      //(0014,405A)
      = const DED("SoundPathLength", 0x0014405A, "Sound Path Length", VR.kDS, VM.k1, false);
  static const DED kDelayLawIdentifier
      //(0014,405C)
      =
      const DED("DelayLawIdentifier", 0x0014405C, "Delay Law Identifier", VR.kST, VM.k1, false);
  static const DED kGateSettingsSequence
      //(0014,4060)
      = const DED(
          "GateSettingsSequence", 0x00144060, "Gate Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kGateThreshold
      //(0014,4062)
      = const DED("GateThreshold", 0x00144062, "Gate Threshold", VR.kDS, VM.k1, false);
  static const DED kVelocityOfSound
      //(0014,4064)
      = const DED("VelocityOfSound", 0x00144064, "Velocity of Sound", VR.kDS, VM.k1, false);
  static const DED kCalibrationSettingsSequence
      //(0014,4070)
      = const DED("CalibrationSettingsSequence", 0x00144070, "Calibration Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCalibrationProcedure
      //(0014,4072)
      = const DED(
          "CalibrationProcedure", 0x00144072, "Calibration Procedure", VR.kST, VM.k1, false);
  static const DED kProcedureVersion
      //(0014,4074)
      = const DED("ProcedureVersion", 0x00144074, "Procedure Version", VR.kSH, VM.k1, false);
  static const DED kProcedureCreationDate
      //(0014,4076)
      = const DED(
          "ProcedureCreationDate", 0x00144076, "Procedure Creation Date", VR.kDA, VM.k1, false);
  static const DED kProcedureExpirationDate
      //(0014,4078)
      = const DED(
          "ProcedureExpirationDate", 0x00144078, "Procedure Expiration Date", VR.kDA, VM.k1, false);
  static const DED kProcedureLastModifiedDate
      //(0014,407A)
      = const DED("ProcedureLastModifiedDate", 0x0014407A, "Procedure Last Modified Date",
          VR.kDA, VM.k1, false);
  static const DED kCalibrationTime
      //(0014,407C)
      = const DED("CalibrationTime", 0x0014407C, "Calibration Time", VR.kTM, VM.k1_n, false);
  static const DED kCalibrationDate
      //(0014,407E)
      = const DED("CalibrationDate", 0x0014407E, "Calibration Date", VR.kDA, VM.k1_n, false);
  static const DED kProbeDriveEquipmentSequence
      //(0014,4080)
      = const DED("ProbeDriveEquipmentSequence", 0x00144080, "Probe Drive Equipment Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kDriveType
      //(0014,4081)
      = const DED("DriveType", 0x00144081, "Drive Type", VR.kCS, VM.k1, false);
  static const DED kProbeDriveNotes
      //(0014,4082)
      = const DED("ProbeDriveNotes", 0x00144082, "Probe Drive Notes", VR.kLT, VM.k1, false);
  static const DED kDriveProbeSequence
      //(0014,4083)
      =
      const DED("DriveProbeSequence", 0x00144083, "Drive Probe Sequence", VR.kSQ, VM.k1, false);
  static const DED kProbeInductance
      //(0014,4084)
      = const DED("ProbeInductance", 0x00144084, "Probe Inductance", VR.kDS, VM.k1, false);
  static const DED kProbeResistance
      //(0014,4085)
      = const DED("ProbeResistance", 0x00144085, "Probe Resistance", VR.kDS, VM.k1, false);
  static const DED kReceiveProbeSequence
      //(0014,4086)
      = const DED(
          "ReceiveProbeSequence", 0x00144086, "Receive Probe Sequence", VR.kSQ, VM.k1, false);
  static const DED kProbeDriveSettingsSequence
      //(0014,4087)
      = const DED("ProbeDriveSettingsSequence", 0x00144087, "Probe Drive Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kBridgeResistors
      //(0014,4088)
      = const DED("BridgeResistors", 0x00144088, "Bridge Resistors", VR.kDS, VM.k1, false);
  static const DED kProbeOrientationAngle
      //(0014,4089)
      = const DED(
          "ProbeOrientationAngle", 0x00144089, "Probe Orientation Angle", VR.kDS, VM.k1, false);
  static const DED kUserSelectedGainY
      //(0014,408B)
      =
      const DED("UserSelectedGainY", 0x0014408B, "User Selected Gain Y", VR.kDS, VM.k1, false);
  static const DED kUserSelectedPhase
      //(0014,408C)
      = const DED("UserSelectedPhase", 0x0014408C, "User Selected Phase", VR.kDS, VM.k1, false);
  static const DED kUserSelectedOffsetX
      //(0014,408D)
      = const DED(
          "UserSelectedOffsetX", 0x0014408D, "User Selected Offset X", VR.kDS, VM.k1, false);
  static const DED kUserSelectedOffsetY
      //(0014,408E)
      = const DED(
          "UserSelectedOffsetY", 0x0014408E, "User Selected Offset Y", VR.kDS, VM.k1, false);
  static const DED kChannelSettingsSequence
      //(0014,4091)
      = const DED(
          "ChannelSettingsSequence", 0x00144091, "Channel Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelThreshold
      //(0014,4092)
      = const DED("ChannelThreshold", 0x00144092, "Channel Threshold", VR.kDS, VM.k1, false);
  static const DED kScannerSettingsSequence
      //(0014,409A)
      = const DED(
          "ScannerSettingsSequence", 0x0014409A, "Scanner Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kScanProcedure
      //(0014,409B)
      = const DED("ScanProcedure", 0x0014409B, "Scan Procedure", VR.kST, VM.k1, false);
  static const DED kTranslationRateX
      //(0014,409C)
      = const DED("TranslationRateX", 0x0014409C, "Translation Rate X", VR.kDS, VM.k1, false);
  static const DED kTranslationRateY
      //(0014,409D)
      = const DED("TranslationRateY", 0x0014409D, "Translation Rate Y", VR.kDS, VM.k1, false);
  static const DED kChannelOverlap
      //(0014,409F)
      = const DED("ChannelOverlap", 0x0014409F, "Channel Overlap", VR.kDS, VM.k1, false);
  static const DED kImageQualityIndicatorType
      //(0014,40A0)
      = const DED("ImageQualityIndicatorType", 0x001440A0, "Image Quality Indicator Type",
          VR.kLO, VM.k1, false);
  static const DED kImageQualityIndicatorMaterial
      //(0014,40A1)
      = const DED("ImageQualityIndicatorMaterial", 0x001440A1,
          "Image Quality Indicator Material", VR.kLO, VM.k1, false);
  static const DED kImageQualityIndicatorSize
      //(0014,40A2)
      = const DED("ImageQualityIndicatorSize", 0x001440A2, "Image Quality Indicator Size",
          VR.kLO, VM.k1, false);
  static const DED kLINACEnergy
      //(0014,5002)
      = const DED("LINACEnergy", 0x00145002, "LINAC Energy", VR.kIS, VM.k1, false);
  static const DED kLINACOutput
      //(0014,5004)
      = const DED("LINACOutput", 0x00145004, "LINAC Output", VR.kIS, VM.k1, false);
  static const DED kContrastBolusAgent
      //(0018,0010)
      =
      const DED("ContrastBolusAgent", 0x00180010, "Contrast/Bolus Agent", VR.kLO, VM.k1, false);
  static const DED kContrastBolusAgentSequence
      //(0018,0012)
      = const DED("ContrastBolusAgentSequence", 0x00180012, "Contrast/Bolus Agent Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kContrastBolusAdministrationRouteSequence
      //(0018,0014)
      = const DED("ContrastBolusAdministrationRouteSequence", 0x00180014,
          "Contrast/Bolus Administration Route Sequence", VR.kSQ, VM.k1, false);
  static const DED kBodyPartExamined
      //(0018,0015)
      = const DED("BodyPartExamined", 0x00180015, "Body Part Examined", VR.kCS, VM.k1, false);
  static const DED kScanningSequence
      //(0018,0020)
      = const DED("ScanningSequence", 0x00180020, "Scanning Sequence", VR.kCS, VM.k1_n, false);
  static const DED kSequenceVariant
      //(0018,0021)
      = const DED("SequenceVariant", 0x00180021, "Sequence Variant", VR.kCS, VM.k1_n, false);
  static const DED kScanOptions
      //(0018,0022)
      = const DED("ScanOptions", 0x00180022, "Scan Options", VR.kCS, VM.k1_n, false);
  static const DED kMRAcquisitionType
      //(0018,0023)
      = const DED("MRAcquisitionType", 0x00180023, "MR Acquisition Type", VR.kCS, VM.k1, false);
  static const DED kSequenceName
      //(0018,0024)
      = const DED("SequenceName", 0x00180024, "Sequence Name", VR.kSH, VM.k1, false);
  static const DED kAngioFlag
      //(0018,0025)
      = const DED("AngioFlag", 0x00180025, "Angio Flag", VR.kCS, VM.k1, false);
  static const DED kInterventionDrugInformationSequence
      //(0018,0026)
      = const DED("InterventionDrugInformationSequence", 0x00180026,
          "Intervention Drug Information Sequence", VR.kSQ, VM.k1, false);
  static const DED kInterventionDrugStopTime
      //(0018,0027)
      = const DED("InterventionDrugStopTime", 0x00180027, "Intervention Drug Stop Time", VR.kTM,
          VM.k1, false);
  static const DED kInterventionDrugDose
      //(0018,0028)
      = const DED(
          "InterventionDrugDose", 0x00180028, "Intervention Drug Dose", VR.kDS, VM.k1, false);
  static const DED kInterventionDrugCodeSequence
      //(0018,0029)
      = const DED("InterventionDrugCodeSequence", 0x00180029, "Intervention Drug Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAdditionalDrugSequence
      //(0018,002A)
      = const DED(
          "AdditionalDrugSequence", 0x0018002A, "Additional Drug Sequence", VR.kSQ, VM.k1, false);
  static const DED kRadionuclide
      //(0018,0030)
      = const DED("Radionuclide", 0x00180030, "Radionuclide", VR.kLO, VM.k1_n, true);
  static const DED kRadiopharmaceutical
      //(0018,0031)
      =
      const DED("Radiopharmaceutical", 0x00180031, "Radiopharmaceutical", VR.kLO, VM.k1, false);
  static const DED kEnergyWindowCenterline
      //(0018,0032)
      = const DED(
          "EnergyWindowCenterline", 0x00180032, "Energy Window Centerline", VR.kDS, VM.k1, true);
  static const DED kEnergyWindowTotalWidth
      //(0018,0033)
      = const DED(
          "EnergyWindowTotalWidth", 0x00180033, "Energy Window Total Width", VR.kDS, VM.k1_n, true);
  static const DED kInterventionDrugName
      //(0018,0034)
      = const DED(
          "InterventionDrugName", 0x00180034, "Intervention Drug Name", VR.kLO, VM.k1, false);
  static const DED kInterventionDrugStartTime
      //(0018,0035)
      = const DED("InterventionDrugStartTime", 0x00180035, "Intervention Drug Start Time",
          VR.kTM, VM.k1, false);
  static const DED kInterventionSequence
      //(0018,0036)
      = const DED(
          "InterventionSequence", 0x00180036, "Intervention Sequence", VR.kSQ, VM.k1, false);
  static const DED kTherapyType
      //(0018,0037)
      = const DED("TherapyType", 0x00180037, "Therapy Type", VR.kCS, VM.k1, true);
  static const DED kInterventionStatus
      //(0018,0038)
      =
      const DED("InterventionStatus", 0x00180038, "Intervention Status", VR.kCS, VM.k1, false);
  static const DED kTherapyDescription
      //(0018,0039)
      = const DED("TherapyDescription", 0x00180039, "Therapy Description", VR.kCS, VM.k1, true);
  static const DED kInterventionDescription
      //(0018,003A)
      = const DED(
          "InterventionDescription", 0x0018003A, "Intervention Description", VR.kST, VM.k1, false);
  static const DED kCineRate
      //(0018,0040)
      = const DED("CineRate", 0x00180040, "Cine Rate", VR.kIS, VM.k1, false);
  static const DED kInitialCineRunState
      //(0018,0042)
      = const DED(
          "InitialCineRunState", 0x00180042, "Initial Cine Run State", VR.kCS, VM.k1, false);
  static const DED kSliceThickness
      //(0018,0050)
      = const DED("SliceThickness", 0x00180050, "Slice Thickness", VR.kDS, VM.k1, false);
  static const DED kKVP
      //(0018,0060)
      = const DED("KVP", 0x00180060, "KVP", VR.kDS, VM.k1, false);
  static const DED kCountsAccumulated
      //(0018,0070)
      = const DED("CountsAccumulated", 0x00180070, "Counts Accumulated", VR.kIS, VM.k1, false);
  static const DED kAcquisitionTerminationCondition
      //(0018,0071)
      = const DED("AcquisitionTerminationCondition", 0x00180071,
          "Acquisition Termination Condition", VR.kCS, VM.k1, false);
  static const DED kEffectiveDuration
      //(0018,0072)
      = const DED("EffectiveDuration", 0x00180072, "Effective Duration", VR.kDS, VM.k1, false);
  static const DED kAcquisitionStartCondition
      //(0018,0073)
      = const DED("AcquisitionStartCondition", 0x00180073, "Acquisition Start Condition",
          VR.kCS, VM.k1, false);
  static const DED kAcquisitionStartConditionData
      //(0018,0074)
      = const DED("AcquisitionStartConditionData", 0x00180074,
          "Acquisition Start Condition Data", VR.kIS, VM.k1, false);
  static const DED kAcquisitionTerminationConditionData
      //(0018,0075)
      = const DED("AcquisitionTerminationConditionData", 0x00180075,
          "Acquisition Termination Condition Data", VR.kIS, VM.k1, false);
  static const DED kRepetitionTime
      //(0018,0080)
      = const DED("RepetitionTime", 0x00180080, "Repetition Time", VR.kDS, VM.k1, false);
  static const DED kEchoTime
      //(0018,0081)
      = const DED("EchoTime", 0x00180081, "Echo Time", VR.kDS, VM.k1, false);
  static const DED kInversionTime
      //(0018,0082)
      = const DED("InversionTime", 0x00180082, "Inversion Time", VR.kDS, VM.k1, false);
  static const DED kNumberOfAverages
      //(0018,0083)
      = const DED("NumberOfAverages", 0x00180083, "Number of Averages", VR.kDS, VM.k1, false);
  static const DED kImagingFrequency
      //(0018,0084)
      = const DED("ImagingFrequency", 0x00180084, "Imaging Frequency", VR.kDS, VM.k1, false);
  static const DED kImagedNucleus
      //(0018,0085)
      = const DED("ImagedNucleus", 0x00180085, "Imaged Nucleus", VR.kSH, VM.k1, false);
  static const DED kEchoNumbers
      //(0018,0086)
      = const DED("EchoNumbers", 0x00180086, "Echo Number(s)", VR.kIS, VM.k1_n, false);
  static const DED kMagneticFieldStrength
      //(0018,0087)
      = const DED(
          "MagneticFieldStrength", 0x00180087, "Magnetic Field Strength", VR.kDS, VM.k1, false);
  static const DED kSpacingBetweenSlices
      //(0018,0088)
      = const DED(
          "SpacingBetweenSlices", 0x00180088, "Spacing Between Slices", VR.kDS, VM.k1, false);
  static const DED kNumberOfPhaseEncodingSteps
      //(0018,0089)
      = const DED("NumberOfPhaseEncodingSteps", 0x00180089, "Number of Phase Encoding Steps",
          VR.kIS, VM.k1, false);
  static const DED kDataCollectionDiameter
      //(0018,0090)
      = const DED(
          "DataCollectionDiameter", 0x00180090, "Data Collection Diameter", VR.kDS, VM.k1, false);
  static const DED kEchoTrainLength
      //(0018,0091)
      = const DED("EchoTrainLength", 0x00180091, "Echo Train Length", VR.kIS, VM.k1, false);
  static const DED kPercentSampling
      //(0018,0093)
      = const DED("PercentSampling", 0x00180093, "Percent Sampling", VR.kDS, VM.k1, false);
  static const DED kPercentPhaseFieldOfView
      //(0018,0094)
      = const DED("PercentPhaseFieldOfView", 0x00180094, "Percent Phase Field of View", VR.kDS,
          VM.k1, false);
  static const DED kPixelBandwidth
      //(0018,0095)
      = const DED("PixelBandwidth", 0x00180095, "Pixel Bandwidth", VR.kDS, VM.k1, false);
  static const DED kDeviceSerialNumber
      //(0018,1000)
      =
      const DED("DeviceSerialNumber", 0x00181000, "Device Serial Number", VR.kLO, VM.k1, false);
  static const DED kDeviceUID
      //(0018,1002)
      = const DED("DeviceUID", 0x00181002, "Device UID", VR.kUI, VM.k1, false);
  static const DED kDeviceID
      //(0018,1003)
      = const DED("DeviceID", 0x00181003, "Device ID", VR.kLO, VM.k1, false);
  static const DED kPlateID
      //(0018,1004)
      = const DED("PlateID", 0x00181004, "Plate ID", VR.kLO, VM.k1, false);
  static const DED kGeneratorID
      //(0018,1005)
      = const DED("GeneratorID", 0x00181005, "Generator ID", VR.kLO, VM.k1, false);
  static const DED kGridID
      //(0018,1006)
      = const DED("GridID", 0x00181006, "Grid ID", VR.kLO, VM.k1, false);
  static const DED kCassetteID
      //(0018,1007)
      = const DED("CassetteID", 0x00181007, "Cassette ID", VR.kLO, VM.k1, false);
  static const DED kGantryID
      //(0018,1008)
      = const DED("GantryID", 0x00181008, "Gantry ID", VR.kLO, VM.k1, false);
  static const DED kSecondaryCaptureDeviceID
      //(0018,1010)
      = const DED("SecondaryCaptureDeviceID", 0x00181010, "Secondary Capture Device ID", VR.kLO,
          VM.k1, false);
  static const DED kHardcopyCreationDeviceID
      //(0018,1011)
      = const DED("HardcopyCreationDeviceID", 0x00181011, "Hardcopy Creation Device ID", VR.kLO,
          VM.k1, true);
  static const DED kDateOfSecondaryCapture
      //(0018,1012)
      = const DED(
          "DateOfSecondaryCapture", 0x00181012, "Date of Secondary Capture", VR.kDA, VM.k1, false);
  static const DED kTimeOfSecondaryCapture
      //(0018,1014)
      = const DED(
          "TimeOfSecondaryCapture", 0x00181014, "Time of Secondary Capture", VR.kTM, VM.k1, false);
  static const DED kSecondaryCaptureDeviceManufacturer
      //(0018,1016)
      = const DED("SecondaryCaptureDeviceManufacturer", 0x00181016,
          "Secondary Capture Device Manufacturer", VR.kLO, VM.k1, false);
  static const DED kHardcopyDeviceManufacturer
      //(0018,1017)
      = const DED("HardcopyDeviceManufacturer", 0x00181017, "Hardcopy Device Manufacturer",
          VR.kLO, VM.k1, true);
  static const DED kSecondaryCaptureDeviceManufacturerModelName
      //(0018,1018)
      = const DED("SecondaryCaptureDeviceManufacturerModelName", 0x00181018,
          "Secondary Capture Device Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const DED kSecondaryCaptureDeviceSoftwareVersions
      //(0018,1019)
      = const DED("SecondaryCaptureDeviceSoftwareVersions", 0x00181019,
          "Secondary Capture Device Software Versions", VR.kLO, VM.k1_n, false);
  static const DED kHardcopyDeviceSoftwareVersion
      //(0018,101A)
      = const DED("HardcopyDeviceSoftwareVersion", 0x0018101A,
          "Hardcopy Device Software Version", VR.kLO, VM.k1_n, true);
  static const DED kHardcopyDeviceManufacturerModelName
      //(0018,101B)
      = const DED("HardcopyDeviceManufacturerModelName", 0x0018101B,
          "Hardcopy Device Manufacturer's Model Name", VR.kLO, VM.k1, true);
  static const DED kSoftwareVersions
      //(0018,1020)
      =
      const DED("SoftwareVersions", 0x00181020, "Software Version(s)", VR.kLO, VM.k1_n, false);
  static const DED kVideoImageFormatAcquired
      //(0018,1022)
      = const DED("VideoImageFormatAcquired", 0x00181022, "Video Image Format Acquired", VR.kSH,
          VM.k1, false);
  static const DED kDigitalImageFormatAcquired
      //(0018,1023)
      = const DED("DigitalImageFormatAcquired", 0x00181023, "Digital Image Format Acquired",
          VR.kLO, VM.k1, false);
  static const DED kProtocolName
      //(0018,1030)
      = const DED("ProtocolName", 0x00181030, "Protocol Name", VR.kLO, VM.k1, false);
  static const DED kContrastBolusRoute
      //(0018,1040)
      =
      const DED("ContrastBolusRoute", 0x00181040, "Contrast/Bolus Route", VR.kLO, VM.k1, false);
  static const DED kContrastBolusVolume
      //(0018,1041)
      = const DED(
          "ContrastBolusVolume", 0x00181041, "Contrast/Bolus Volume", VR.kDS, VM.k1, false);
  static const DED kContrastBolusStartTime
      //(0018,1042)
      = const DED(
          "ContrastBolusStartTime", 0x00181042, "Contrast/Bolus Start Time", VR.kTM, VM.k1, false);
  static const DED kContrastBolusStopTime
      //(0018,1043)
      = const DED(
          "ContrastBolusStopTime", 0x00181043, "Contrast/Bolus Stop Time", VR.kTM, VM.k1, false);
  static const DED kContrastBolusTotalDose
      //(0018,1044)
      = const DED(
          "ContrastBolusTotalDose", 0x00181044, "Contrast/Bolus Total Dose", VR.kDS, VM.k1, false);
  static const DED kSyringeCounts
      //(0018,1045)
      = const DED("SyringeCounts", 0x00181045, "Syringe Counts", VR.kIS, VM.k1, false);
  static const DED kContrastFlowRate
      //(0018,1046)
      = const DED("ContrastFlowRate", 0x00181046, "Contrast Flow Rate", VR.kDS, VM.k1_n, false);
  static const DED kContrastFlowDuration
      //(0018,1047)
      = const DED(
          "ContrastFlowDuration", 0x00181047, "Contrast Flow Duration", VR.kDS, VM.k1_n, false);
  static const DED kContrastBolusIngredient
      //(0018,1048)
      = const DED(
          "ContrastBolusIngredient", 0x00181048, "Contrast/Bolus Ingredient", VR.kCS, VM.k1, false);
  static const DED kContrastBolusIngredientConcentration
      //(0018,1049)
      = const DED("ContrastBolusIngredientConcentration", 0x00181049,
          "Contrast/Bolus Ingredient Concentration", VR.kDS, VM.k1, false);
  static const DED kSpatialResolution
      //(0018,1050)
      = const DED("SpatialResolution", 0x00181050, "Spatial Resolution", VR.kDS, VM.k1, false);
  static const DED kTriggerTime
      //(0018,1060)
      = const DED("TriggerTime", 0x00181060, "Trigger Time", VR.kDS, VM.k1, false);
  static const DED kTriggerSourceOrType
      //(0018,1061)
      = const DED(
          "TriggerSourceOrType", 0x00181061, "Trigger Source or Type", VR.kLO, VM.k1, false);
  static const DED kNominalInterval
      //(0018,1062)
      = const DED("NominalInterval", 0x00181062, "Nominal Interval", VR.kIS, VM.k1, false);
  static const DED kFrameTime
      //(0018,1063)
      = const DED("FrameTime", 0x00181063, "Frame Time", VR.kDS, VM.k1, false);
  static const DED kCardiacFramingType
      //(0018,1064)
      =
      const DED("CardiacFramingType", 0x00181064, "Cardiac Framing Type", VR.kLO, VM.k1, false);
  static const DED kFrameTimeVector
      //(0018,1065)
      = const DED("FrameTimeVector", 0x00181065, "Frame Time Vector", VR.kDS, VM.k1_n, false);
  static const DED kFrameDelay
      //(0018,1066)
      = const DED("FrameDelay", 0x00181066, "Frame Delay", VR.kDS, VM.k1, false);
  static const DED kImageTriggerDelay
      //(0018,1067)
      = const DED("ImageTriggerDelay", 0x00181067, "Image Trigger Delay", VR.kDS, VM.k1, false);
  static const DED kMultiplexGroupTimeOffset
      //(0018,1068)
      = const DED("MultiplexGroupTimeOffset", 0x00181068, "Multiplex Group Time Offset", VR.kDS,
          VM.k1, false);
  static const DED kTriggerTimeOffset
      //(0018,1069)
      = const DED("TriggerTimeOffset", 0x00181069, "Trigger Time Offset", VR.kDS, VM.k1, false);
  static const DED kSynchronizationTrigger
      //(0018,106A)
      = const DED(
          "SynchronizationTrigger", 0x0018106A, "Synchronization Trigger", VR.kCS, VM.k1, false);
  static const DED kSynchronizationChannel
      //(0018,106C)
      = const DED(
          "SynchronizationChannel", 0x0018106C, "Synchronization Channel", VR.kUS, VM.k2, false);
  static const DED kTriggerSamplePosition
      //(0018,106E)
      = const DED(
          "TriggerSamplePosition", 0x0018106E, "Trigger Sample Position", VR.kUL, VM.k1, false);
  static const DED kRadiopharmaceuticalRoute
      //(0018,1070)
      = const DED("RadiopharmaceuticalRoute", 0x00181070, "Radiopharmaceutical Route", VR.kLO,
          VM.k1, false);
  static const DED kRadiopharmaceuticalVolume
      //(0018,1071)
      = const DED("RadiopharmaceuticalVolume", 0x00181071, "Radiopharmaceutical Volume", VR.kDS,
          VM.k1, false);
  static const DED kRadiopharmaceuticalStartTime
      //(0018,1072)
      = const DED("RadiopharmaceuticalStartTime", 0x00181072, "Radiopharmaceutical Start Time",
          VR.kTM, VM.k1, false);
  static const DED kRadiopharmaceuticalStopTime
      //(0018,1073)
      = const DED("RadiopharmaceuticalStopTime", 0x00181073, "Radiopharmaceutical Stop Time",
          VR.kTM, VM.k1, false);
  static const DED kRadionuclideTotalDose
      //(0018,1074)
      = const DED(
          "RadionuclideTotalDose", 0x00181074, "Radionuclide Total Dose", VR.kDS, VM.k1, false);
  static const DED kRadionuclideHalfLife
      //(0018,1075)
      = const DED(
          "RadionuclideHalfLife", 0x00181075, "Radionuclide Half Life", VR.kDS, VM.k1, false);
  static const DED kRadionuclidePositronFraction
      //(0018,1076)
      = const DED("RadionuclidePositronFraction", 0x00181076, "Radionuclide Positron Fraction",
          VR.kDS, VM.k1, false);
  static const DED kRadiopharmaceuticalSpecificActivity
      //(0018,1077)
      = const DED("RadiopharmaceuticalSpecificActivity", 0x00181077,
          "Radiopharmaceutical Specific Activity", VR.kDS, VM.k1, false);
  static const DED kRadiopharmaceuticalStartDateTime
      //(0018,1078)
      = const DED("RadiopharmaceuticalStartDateTime", 0x00181078,
          "Radiopharmaceutical Start DateTime", VR.kDT, VM.k1, false);
  static const DED kRadiopharmaceuticalStopDateTime
      //(0018,1079)
      = const DED("RadiopharmaceuticalStopDateTime", 0x00181079,
          "Radiopharmaceutical Stop DateTime", VR.kDT, VM.k1, false);
  static const DED kBeatRejectionFlag
      //(0018,1080)
      = const DED("BeatRejectionFlag", 0x00181080, "Beat Rejection Flag", VR.kCS, VM.k1, false);
  static const DED kLowRRValue
      //(0018,1081)
      = const DED("LowRRValue", 0x00181081, "Low R-R Value", VR.kIS, VM.k1, false);
  static const DED kHighRRValue
      //(0018,1082)
      = const DED("HighRRValue", 0x00181082, "High R-R Value", VR.kIS, VM.k1, false);
  static const DED kIntervalsAcquired
      //(0018,1083)
      = const DED("IntervalsAcquired", 0x00181083, "Intervals Acquired", VR.kIS, VM.k1, false);
  static const DED kIntervalsRejected
      //(0018,1084)
      = const DED("IntervalsRejected", 0x00181084, "Intervals Rejected", VR.kIS, VM.k1, false);
  static const DED kPVCRejection
      //(0018,1085)
      = const DED("PVCRejection", 0x00181085, "PVC Rejection", VR.kLO, VM.k1, false);
  static const DED kSkipBeats
      //(0018,1086)
      = const DED("SkipBeats", 0x00181086, "Skip Beats", VR.kIS, VM.k1, false);
  static const DED kHeartRate
      //(0018,1088)
      = const DED("HeartRate", 0x00181088, "Heart Rate", VR.kIS, VM.k1, false);
  static const DED kCardiacNumberOfImages
      //(0018,1090)
      = const DED(
          "CardiacNumberOfImages", 0x00181090, "Cardiac Number of Images", VR.kIS, VM.k1, false);
  static const DED kTriggerWindow
      //(0018,1094)
      = const DED("TriggerWindow", 0x00181094, "Trigger Window", VR.kIS, VM.k1, false);
  static const DED kReconstructionDiameter
      //(0018,1100)
      = const DED(
          "ReconstructionDiameter", 0x00181100, "Reconstruction Diameter", VR.kDS, VM.k1, false);
  static const DED kDistanceSourceToDetector
      //(0018,1110)
      = const DED("DistanceSourceToDetector", 0x00181110, "Distance Source to Detector", VR.kDS,
          VM.k1, false);
  static const DED kDistanceSourceToPatient
      //(0018,1111)
      = const DED("DistanceSourceToPatient", 0x00181111, "Distance Source to Patient", VR.kDS,
          VM.k1, false);
  static const DED kEstimatedRadiographicMagnificationFactor
      //(0018,1114)
      = const DED("EstimatedRadiographicMagnificationFactor", 0x00181114,
          "Estimated Radiographic Magnification Factor", VR.kDS, VM.k1, false);
  static const DED kGantryDetectorTilt
      //(0018,1120)
      =
      const DED("GantryDetectorTilt", 0x00181120, "Gantry/Detector Tilt", VR.kDS, VM.k1, false);
  static const DED kGantryDetectorSlew
      //(0018,1121)
      =
      const DED("GantryDetectorSlew", 0x00181121, "Gantry/Detector Slew", VR.kDS, VM.k1, false);
  static const DED kTableHeight
      //(0018,1130)
      = const DED("TableHeight", 0x00181130, "Table Height", VR.kDS, VM.k1, false);
  static const DED kTableTraverse
      //(0018,1131)
      = const DED("TableTraverse", 0x00181131, "Table Traverse", VR.kDS, VM.k1, false);
  static const DED kTableMotion
      //(0018,1134)
      = const DED("TableMotion", 0x00181134, "Table Motion", VR.kCS, VM.k1, false);
  static const DED kTableVerticalIncrement
      //(0018,1135)
      = const DED(
          "TableVerticalIncrement", 0x00181135, "Table Vertical Increment", VR.kDS, VM.k1_n, false);
  static const DED kTableLateralIncrement
      //(0018,1136)
      = const DED(
          "TableLateralIncrement", 0x00181136, "Table Lateral Increment", VR.kDS, VM.k1_n, false);
  static const DED kTableLongitudinalIncrement
      //(0018,1137)
      = const DED("TableLongitudinalIncrement", 0x00181137, "Table Longitudinal Increment",
          VR.kDS, VM.k1_n, false);
  static const DED kTableAngle
      //(0018,1138)
      = const DED("TableAngle", 0x00181138, "Table Angle", VR.kDS, VM.k1, false);
  static const DED kTableType
      //(0018,113A)
      = const DED("TableType", 0x0018113A, "Table Type", VR.kCS, VM.k1, false);
  static const DED kRotationDirection
      //(0018,1140)
      = const DED("RotationDirection", 0x00181140, "Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kAngularPosition
      //(0018,1141)
      = const DED("AngularPosition", 0x00181141, "Angular Position", VR.kDS, VM.k1, true);
  static const DED kRadialPosition
      //(0018,1142)
      = const DED("RadialPosition", 0x00181142, "Radial Position", VR.kDS, VM.k1_n, false);
  static const DED kScanArc
      //(0018,1143)
      = const DED("ScanArc", 0x00181143, "Scan Arc", VR.kDS, VM.k1, false);
  static const DED kAngularStep
      //(0018,1144)
      = const DED("AngularStep", 0x00181144, "Angular Step", VR.kDS, VM.k1, false);
  static const DED kCenterOfRotationOffset
      //(0018,1145)
      = const DED(
          "CenterOfRotationOffset", 0x00181145, "Center of Rotation Offset", VR.kDS, VM.k1, false);
  static const DED kRotationOffset
      //(0018,1146)
      = const DED("RotationOffset", 0x00181146, "Rotation Offset", VR.kDS, VM.k1_n, true);
  static const DED kFieldOfViewShape
      //(0018,1147)
      = const DED("FieldOfViewShape", 0x00181147, "Field of View Shape", VR.kCS, VM.k1, false);
  static const DED kFieldOfViewDimensions
      //(0018,1149)
      = const DED("FieldOfViewDimensions", 0x00181149, "Field of View Dimension(s)", VR.kIS,
          VM.k1_2, false);
  static const DED kExposureTime
      //(0018,1150)
      = const DED("ExposureTime", 0x00181150, "Exposure Time", VR.kIS, VM.k1, false);
  static const DED kXRayTubeCurrent
      //(0018,1151)
      = const DED("XRayTubeCurrent", 0x00181151, "X-Ray Tube Current", VR.kIS, VM.k1, false);
  static const DED kExposure
      //(0018,1152)
      = const DED("Exposure", 0x00181152, "Exposure", VR.kIS, VM.k1, false);
  static const DED kExposureInuAs
      //(0018,1153)
      = const DED("ExposureInuAs", 0x00181153, "Exposure in µAs", VR.kIS, VM.k1, false);
  static const DED kAveragePulseWidth
      //(0018,1154)
      = const DED("AveragePulseWidth", 0x00181154, "Average Pulse Width", VR.kDS, VM.k1, false);
  static const DED kRadiationSetting
      //(0018,1155)
      = const DED("RadiationSetting", 0x00181155, "Radiation Setting", VR.kCS, VM.k1, false);
  static const DED kRectificationType
      //(0018,1156)
      = const DED("RectificationType", 0x00181156, "Rectification Type", VR.kCS, VM.k1, false);
  static const DED kRadiationMode
      //(0018,115A)
      = const DED("RadiationMode", 0x0018115A, "Radiation Mode", VR.kCS, VM.k1, false);
  static const DED kImageAndFluoroscopyAreaDoseProduct
      //(0018,115E)
      = const DED("ImageAndFluoroscopyAreaDoseProduct", 0x0018115E,
          "Image and Fluoroscopy Area Dose Product", VR.kDS, VM.k1, false);
  static const DED kFilterType
      //(0018,1160)
      = const DED("FilterType", 0x00181160, "Filter Type", VR.kSH, VM.k1, false);
  static const DED kTypeOfFilters
      //(0018,1161)
      = const DED("TypeOfFilters", 0x00181161, "Type of Filters", VR.kLO, VM.k1_n, false);
  static const DED kIntensifierSize
      //(0018,1162)
      = const DED("IntensifierSize", 0x00181162, "Intensifier Size", VR.kDS, VM.k1, false);
  static const DED kImagerPixelSpacing
      //(0018,1164)
      =
      const DED("ImagerPixelSpacing", 0x00181164, "Imager Pixel Spacing", VR.kDS, VM.k2, false);
  static const DED kGrid
      //(0018,1166)
      = const DED("Grid", 0x00181166, "Grid", VR.kCS, VM.k1_n, false);
  static const DED kGeneratorPower
      //(0018,1170)
      = const DED("GeneratorPower", 0x00181170, "Generator Power", VR.kIS, VM.k1, false);
  static const DED kCollimatorGridName
      //(0018,1180)
      =
      const DED("CollimatorGridName", 0x00181180, "Collimator/grid Name", VR.kSH, VM.k1, false);
  static const DED kCollimatorType
      //(0018,1181)
      = const DED("CollimatorType", 0x00181181, "Collimator Type", VR.kCS, VM.k1, false);
  static const DED kFocalDistance
      //(0018,1182)
      = const DED("FocalDistance", 0x00181182, "Focal Distance", VR.kIS, VM.k1_2, false);
  static const DED kXFocusCenter
      //(0018,1183)
      = const DED("XFocusCenter", 0x00181183, "X Focus Center", VR.kDS, VM.k1_2, false);
  static const DED kYFocusCenter
      //(0018,1184)
      = const DED("YFocusCenter", 0x00181184, "Y Focus Center", VR.kDS, VM.k1_2, false);
  static const DED kFocalSpots
      //(0018,1190)
      = const DED("FocalSpots", 0x00181190, "Focal Spot(s)", VR.kDS, VM.k1_n, false);
  static const DED kAnodeTargetMaterial
      //(0018,1191)
      = const DED(
          "AnodeTargetMaterial", 0x00181191, "Anode Target Material", VR.kCS, VM.k1, false);
  static const DED kBodyPartThickness
      //(0018,11A0)
      = const DED("BodyPartThickness", 0x001811A0, "Body Part Thickness", VR.kDS, VM.k1, false);
  static const DED kCompressionForce
      //(0018,11A2)
      = const DED("CompressionForce", 0x001811A2, "Compression Force", VR.kDS, VM.k1, false);
  static const DED kPaddleDescription
      //(0018,11A4)
      = const DED("PaddleDescription", 0x001811A4, "Paddle Description", VR.kLO, VM.k1, false);
  static const DED kDateOfLastCalibration
      //(0018,1200)
      = const DED(
          "DateOfLastCalibration", 0x00181200, "Date of Last Calibration", VR.kDA, VM.k1_n, false);
  static const DED kTimeOfLastCalibration
      //(0018,1201)
      = const DED(
          "TimeOfLastCalibration", 0x00181201, "Time of Last Calibration", VR.kTM, VM.k1_n, false);
  static const DED kConvolutionKernel
      //(0018,1210)
      =
      const DED("ConvolutionKernel", 0x00181210, "Convolution Kernel", VR.kSH, VM.k1_n, false);
  static const DED kUpperLowerPixelValues
      //(0018,1240)
      = const DED(
          "UpperLowerPixelValues", 0x00181240, "Upper/Lower Pixel Values", VR.kIS, VM.k1_n, true);
  static const DED kActualFrameDuration
      //(0018,1242)
      = const DED(
          "ActualFrameDuration", 0x00181242, "Actual Frame Duration", VR.kIS, VM.k1, false);
  static const DED kCountRate
      //(0018,1243)
      = const DED("CountRate", 0x00181243, "Count Rate", VR.kIS, VM.k1, false);
  static const DED kPreferredPlaybackSequencing
      //(0018,1244)
      = const DED("PreferredPlaybackSequencing", 0x00181244, "Preferred Playback Sequencing",
          VR.kUS, VM.k1, false);
  static const DED kReceiveCoilName
      //(0018,1250)
      = const DED("ReceiveCoilName", 0x00181250, "Receive Coil Name", VR.kSH, VM.k1, false);
  static const DED kTransmitCoilName
      //(0018,1251)
      = const DED("TransmitCoilName", 0x00181251, "Transmit Coil Name", VR.kSH, VM.k1, false);
  static const DED kPlateType
      //(0018,1260)
      = const DED("PlateType", 0x00181260, "Plate Type", VR.kSH, VM.k1, false);
  static const DED kPhosphorType
      //(0018,1261)
      = const DED("PhosphorType", 0x00181261, "Phosphor Type", VR.kLO, VM.k1, false);
  static const DED kScanVelocity
      //(0018,1300)
      = const DED("ScanVelocity", 0x00181300, "Scan Velocity", VR.kDS, VM.k1, false);
  static const DED kWholeBodyTechnique
      //(0018,1301)
      = const DED(
          "WholeBodyTechnique", 0x00181301, "Whole Body Technique", VR.kCS, VM.k1_n, false);
  static const DED kScanLength
      //(0018,1302)
      = const DED("ScanLength", 0x00181302, "Scan Length", VR.kIS, VM.k1, false);
  static const DED kAcquisitionMatrix
      //(0018,1310)
      = const DED("AcquisitionMatrix", 0x00181310, "Acquisition Matrix", VR.kUS, VM.k4, false);
  static const DED kInPlanePhaseEncodingDirection
      //(0018,1312)
      = const DED("InPlanePhaseEncodingDirection", 0x00181312,
          "In-plane Phase Encoding Direction", VR.kCS, VM.k1, false);
  static const DED kFlipAngle
      //(0018,1314)
      = const DED("FlipAngle", 0x00181314, "Flip Angle", VR.kDS, VM.k1, false);
  static const DED kVariableFlipAngleFlag
      //(0018,1315)
      = const DED(
          "VariableFlipAngleFlag", 0x00181315, "Variable Flip Angle Flag", VR.kCS, VM.k1, false);
  static const DED kSAR
      //(0018,1316)
      = const DED("SAR", 0x00181316, "SAR", VR.kDS, VM.k1, false);
  static const DED kdBdt
      //(0018,1318)
      = const DED("dBdt", 0x00181318, "dB/dt", VR.kDS, VM.k1, false);
  static const DED kAcquisitionDeviceProcessingDescription
      //(0018,1400)
      = const DED("AcquisitionDeviceProcessingDescription", 0x00181400,
          "Acquisition Device Processing Description", VR.kLO, VM.k1, false);
  static const DED kAcquisitionDeviceProcessingCode
      //(0018,1401)
      = const DED("AcquisitionDeviceProcessingCode", 0x00181401,
          "Acquisition Device Processing Code", VR.kLO, VM.k1, false);
  static const DED kCassetteOrientation
      //(0018,1402)
      = const DED(
          "CassetteOrientation", 0x00181402, "Cassette Orientation", VR.kCS, VM.k1, false);
  static const DED kCassetteSize
      //(0018,1403)
      = const DED("CassetteSize", 0x00181403, "Cassette Size", VR.kCS, VM.k1, false);
  static const DED kExposuresOnPlate
      //(0018,1404)
      = const DED("ExposuresOnPlate", 0x00181404, "Exposures on Plate", VR.kUS, VM.k1, false);
  static const DED kRelativeXRayExposure
      //(0018,1405)
      = const DED(
          "RelativeXRayExposure", 0x00181405, "Relative X-Ray Exposure", VR.kIS, VM.k1, false);
  static const DED kExposureIndex
      //(0018,1411)
      = const DED("ExposureIndex", 0x00181411, "Exposure Index", VR.kDS, VM.k1, false);
  static const DED kTargetExposureIndex
      //(0018,1412)
      = const DED(
          "TargetExposureIndex", 0x00181412, "Target Exposure Index", VR.kDS, VM.k1, false);
  static const DED kDeviationIndex
      //(0018,1413)
      = const DED("DeviationIndex", 0x00181413, "Deviation Index", VR.kDS, VM.k1, false);
  static const DED kColumnAngulation
      //(0018,1450)
      = const DED("ColumnAngulation", 0x00181450, "Column Angulation", VR.kDS, VM.k1, false);
  static const DED kTomoLayerHeight
      //(0018,1460)
      = const DED("TomoLayerHeight", 0x00181460, "Tomo Layer Height", VR.kDS, VM.k1, false);
  static const DED kTomoAngle
      //(0018,1470)
      = const DED("TomoAngle", 0x00181470, "Tomo Angle", VR.kDS, VM.k1, false);
  static const DED kTomoTime
      //(0018,1480)
      = const DED("TomoTime", 0x00181480, "Tomo Time", VR.kDS, VM.k1, false);
  static const DED kTomoType
      //(0018,1490)
      = const DED("TomoType", 0x00181490, "Tomo Type", VR.kCS, VM.k1, false);
  static const DED kTomoClass
      //(0018,1491)
      = const DED("TomoClass", 0x00181491, "Tomo Class", VR.kCS, VM.k1, false);
  static const DED kNumberOfTomosynthesisSourceImages
      //(0018,1495)
      = const DED("NumberOfTomosynthesisSourceImages", 0x00181495,
          "Number of Tomosynthesis Source Images", VR.kIS, VM.k1, false);
  static const DED kPositionerMotion
      //(0018,1500)
      = const DED("PositionerMotion", 0x00181500, "Positioner Motion", VR.kCS, VM.k1, false);
  static const DED kPositionerType
      //(0018,1508)
      = const DED("PositionerType", 0x00181508, "Positioner Type", VR.kCS, VM.k1, false);
  static const DED kPositionerPrimaryAngle
      //(0018,1510)
      = const DED(
          "PositionerPrimaryAngle", 0x00181510, "Positioner Primary Angle", VR.kDS, VM.k1, false);
  static const DED kPositionerSecondaryAngle
      //(0018,1511)
      = const DED("PositionerSecondaryAngle", 0x00181511, "Positioner Secondary Angle", VR.kDS,
          VM.k1, false);
  static const DED kPositionerPrimaryAngleIncrement
      //(0018,1520)
      = const DED("PositionerPrimaryAngleIncrement", 0x00181520,
          "Positioner Primary Angle Increment", VR.kDS, VM.k1_n, false);
  static const DED kPositionerSecondaryAngleIncrement
      //(0018,1521)
      = const DED("PositionerSecondaryAngleIncrement", 0x00181521,
          "Positioner Secondary Angle Increment", VR.kDS, VM.k1_n, false);
  static const DED kDetectorPrimaryAngle
      //(0018,1530)
      = const DED(
          "DetectorPrimaryAngle", 0x00181530, "Detector Primary Angle", VR.kDS, VM.k1, false);
  static const DED kDetectorSecondaryAngle
      //(0018,1531)
      = const DED(
          "DetectorSecondaryAngle", 0x00181531, "Detector Secondary Angle", VR.kDS, VM.k1, false);
  static const DED kShutterShape
      //(0018,1600)
      = const DED("ShutterShape", 0x00181600, "Shutter Shape", VR.kCS, VM.k1_3, false);
  static const DED kShutterLeftVerticalEdge
      //(0018,1602)
      = const DED("ShutterLeftVerticalEdge", 0x00181602, "Shutter Left Vertical Edge", VR.kIS,
          VM.k1, false);
  static const DED kShutterRightVerticalEdge
      //(0018,1604)
      = const DED("ShutterRightVerticalEdge", 0x00181604, "Shutter Right Vertical Edge", VR.kIS,
          VM.k1, false);
  static const DED kShutterUpperHorizontalEdge
      //(0018,1606)
      = const DED("ShutterUpperHorizontalEdge", 0x00181606, "Shutter Upper Horizontal Edge",
          VR.kIS, VM.k1, false);
  static const DED kShutterLowerHorizontalEdge
      //(0018,1608)
      = const DED("ShutterLowerHorizontalEdge", 0x00181608, "Shutter Lower Horizontal Edge",
          VR.kIS, VM.k1, false);
  static const DED kCenterOfCircularShutter
      //(0018,1610)
      = const DED("CenterOfCircularShutter", 0x00181610, "Center of Circular Shutter", VR.kIS,
          VM.k2, false);
  static const DED kRadiusOfCircularShutter
      //(0018,1612)
      = const DED("RadiusOfCircularShutter", 0x00181612, "Radius of Circular Shutter", VR.kIS,
          VM.k1, false);
  static const DED kVerticesOfThePolygonalShutter
      //(0018,1620)
      = const DED("VerticesOfThePolygonalShutter", 0x00181620,
          "Vertices of the Polygonal Shutter", VR.kIS, VM.k2_2n, false);
  static const DED kShutterPresentationValue
      //(0018,1622)
      = const DED("ShutterPresentationValue", 0x00181622, "Shutter Presentation Value", VR.kUS,
          VM.k1, false);
  static const DED kShutterOverlayGroup
      //(0018,1623)
      = const DED(
          "ShutterOverlayGroup", 0x00181623, "Shutter Overlay Group", VR.kUS, VM.k1, false);
  static const DED kShutterPresentationColorCIELabValue
      //(0018,1624)
      = const DED("ShutterPresentationColorCIELabValue", 0x00181624,
          "Shutter Presentation Color CIELab Value", VR.kUS, VM.k3, false);
  static const DED kCollimatorShape
      //(0018,1700)
      = const DED("CollimatorShape", 0x00181700, "Collimator Shape", VR.kCS, VM.k1_3, false);
  static const DED kCollimatorLeftVerticalEdge
      //(0018,1702)
      = const DED("CollimatorLeftVerticalEdge", 0x00181702, "Collimator Left Vertical Edge",
          VR.kIS, VM.k1, false);
  static const DED kCollimatorRightVerticalEdge
      //(0018,1704)
      = const DED("CollimatorRightVerticalEdge", 0x00181704, "Collimator Right Vertical Edge",
          VR.kIS, VM.k1, false);
  static const DED kCollimatorUpperHorizontalEdge
      //(0018,1706)
      = const DED("CollimatorUpperHorizontalEdge", 0x00181706,
          "Collimator Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const DED kCollimatorLowerHorizontalEdge
      //(0018,1708)
      = const DED("CollimatorLowerHorizontalEdge", 0x00181708,
          "Collimator Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const DED kCenterOfCircularCollimator
      //(0018,1710)
      = const DED("CenterOfCircularCollimator", 0x00181710, "Center of Circular Collimator",
          VR.kIS, VM.k2, false);
  static const DED kRadiusOfCircularCollimator
      //(0018,1712)
      = const DED("RadiusOfCircularCollimator", 0x00181712, "Radius of Circular Collimator",
          VR.kIS, VM.k1, false);
  static const DED kVerticesOfThePolygonalCollimator
      //(0018,1720)
      = const DED("VerticesOfThePolygonalCollimator", 0x00181720,
          "Vertices of the Polygonal Collimator", VR.kIS, VM.k2_2n, false);
  static const DED kAcquisitionTimeSynchronized
      //(0018,1800)
      = const DED("AcquisitionTimeSynchronized", 0x00181800, "Acquisition Time Synchronized",
          VR.kCS, VM.k1, false);
  static const DED kTimeSource
      //(0018,1801)
      = const DED("TimeSource", 0x00181801, "Time Source", VR.kSH, VM.k1, false);
  static const DED kTimeDistributionProtocol
      //(0018,1802)
      = const DED("TimeDistributionProtocol", 0x00181802, "Time Distribution Protocol", VR.kCS,
          VM.k1, false);
  static const DED kNTPSourceAddress
      //(0018,1803)
      = const DED("NTPSourceAddress", 0x00181803, "NTP Source Address", VR.kLO, VM.k1, false);
  static const DED kPageNumberVector
      //(0018,2001)
      = const DED("PageNumberVector", 0x00182001, "Page Number Vector", VR.kIS, VM.k1_n, false);
  static const DED kFrameLabelVector
      //(0018,2002)
      = const DED("FrameLabelVector", 0x00182002, "Frame Label Vector", VR.kSH, VM.k1_n, false);
  static const DED kFramePrimaryAngleVector
      //(0018,2003)
      = const DED("FramePrimaryAngleVector", 0x00182003, "Frame Primary Angle Vector", VR.kDS,
          VM.k1_n, false);
  static const DED kFrameSecondaryAngleVector
      //(0018,2004)
      = const DED("FrameSecondaryAngleVector", 0x00182004, "Frame Secondary Angle Vector",
          VR.kDS, VM.k1_n, false);
  static const DED kSliceLocationVector
      //(0018,2005)
      = const DED(
          "SliceLocationVector", 0x00182005, "Slice Location Vector", VR.kDS, VM.k1_n, false);
  static const DED kDisplayWindowLabelVector
      //(0018,2006)
      = const DED("DisplayWindowLabelVector", 0x00182006, "Display Window Label Vector", VR.kSH,
          VM.k1_n, false);
  static const DED kNominalScannedPixelSpacing
      //(0018,2010)
      = const DED("NominalScannedPixelSpacing", 0x00182010, "Nominal Scanned Pixel Spacing",
          VR.kDS, VM.k2, false);
  static const DED kDigitizingDeviceTransportDirection
      //(0018,2020)
      = const DED("DigitizingDeviceTransportDirection", 0x00182020,
          "Digitizing Device Transport Direction", VR.kCS, VM.k1, false);
  static const DED kRotationOfScannedFilm
      //(0018,2030)
      = const DED(
          "RotationOfScannedFilm", 0x00182030, "Rotation of Scanned Film", VR.kDS, VM.k1, false);
  static const DED kBiopsyTargetSequence
      //(0018,2041)
      = const DED(
          "BiopsyTargetSequence", 0x00182041, "Biopsy Target Sequence", VR.kSQ, VM.k1, false);
  static const DED kTargetUID
      //(0018,2042)
      = const DED("TargetUID", 0x00182042, "Target UID", VR.kUI, VM.k1, false);
  static const DED kLocalizingCursorPosition
      //(0018,2043)
      = const DED("LocalizingCursorPosition", 0x00182043, "Localizing Cursor Position", VR.kFL,
          VM.k2, false);
  static const DED kCalculatedTargetPosition
      //(0018,2044)
      = const DED("CalculatedTargetPosition", 0x00182044, "Calculated Target Position", VR.kFL,
          VM.k3, false);
  static const DED kTargetLabel
      //(0018,2045)
      = const DED("TargetLabel", 0x00182045, "Target Label", VR.kSH, VM.k1, false);
  static const DED kDisplayedZValue
      //(0018,2046)
      = const DED("DisplayedZValue", 0x00182046, "Displayed Z Value", VR.kFL, VM.k1, false);
  static const DED kIVUSAcquisition
      //(0018,3100)
      = const DED("IVUSAcquisition", 0x00183100, "IVUS Acquisition", VR.kCS, VM.k1, false);
  static const DED kIVUSPullbackRate
      //(0018,3101)
      = const DED("IVUSPullbackRate", 0x00183101, "IVUS Pullback Rate", VR.kDS, VM.k1, false);
  static const DED kIVUSGatedRate
      //(0018,3102)
      = const DED("IVUSGatedRate", 0x00183102, "IVUS Gated Rate", VR.kDS, VM.k1, false);
  static const DED kIVUSPullbackStartFrameNumber
      //(0018,3103)
      = const DED("IVUSPullbackStartFrameNumber", 0x00183103,
          "IVUS Pullback Start Frame Number", VR.kIS, VM.k1, false);
  static const DED kIVUSPullbackStopFrameNumber
      //(0018,3104)
      = const DED("IVUSPullbackStopFrameNumber", 0x00183104, "IVUS Pullback Stop Frame Number",
          VR.kIS, VM.k1, false);
  static const DED kLesionNumber
      //(0018,3105)
      = const DED("LesionNumber", 0x00183105, "Lesion Number", VR.kIS, VM.k1_n, false);
  static const DED kAcquisitionComments
      //(0018,4000)
      =
      const DED("AcquisitionComments", 0x00184000, "Acquisition Comments", VR.kLT, VM.k1, true);
  static const DED kOutputPower
      //(0018,5000)
      = const DED("OutputPower", 0x00185000, "Output Power", VR.kSH, VM.k1_n, false);
  static const DED kTransducerData
      //(0018,5010)
      = const DED("TransducerData", 0x00185010, "Transducer Data", VR.kLO, VM.k1_n, false);
  static const DED kFocusDepth
      //(0018,5012)
      = const DED("FocusDepth", 0x00185012, "Focus Depth", VR.kDS, VM.k1, false);
  static const DED kProcessingFunction
      //(0018,5020)
      =
      const DED("ProcessingFunction", 0x00185020, "Processing Function", VR.kLO, VM.k1, false);
  static const DED kPostprocessingFunction
      //(0018,5021)
      = const DED(
          "PostprocessingFunction", 0x00185021, "Postprocessing Function", VR.kLO, VM.k1, true);
  static const DED kMechanicalIndex
      //(0018,5022)
      = const DED("MechanicalIndex", 0x00185022, "Mechanical Index", VR.kDS, VM.k1, false);
  static const DED kBoneThermalIndex
      //(0018,5024)
      = const DED("BoneThermalIndex", 0x00185024, "Bone Thermal Index", VR.kDS, VM.k1, false);
  static const DED kCranialThermalIndex
      //(0018,5026)
      = const DED(
          "CranialThermalIndex", 0x00185026, "Cranial Thermal Index", VR.kDS, VM.k1, false);
  static const DED kSoftTissueThermalIndex
      //(0018,5027)
      = const DED(
          "SoftTissueThermalIndex", 0x00185027, "Soft Tissue Thermal Index", VR.kDS, VM.k1, false);
  static const DED kSoftTissueFocusThermalIndex
      //(0018,5028)
      = const DED("SoftTissueFocusThermalIndex", 0x00185028, "Soft Tissue-focus Thermal Index",
          VR.kDS, VM.k1, false);
  static const DED kSoftTissueSurfaceThermalIndex
      //(0018,5029)
      = const DED("SoftTissueSurfaceThermalIndex", 0x00185029,
          "Soft Tissue-surface Thermal Index", VR.kDS, VM.k1, false);
  static const DED kDynamicRange
      //(0018,5030)
      = const DED("DynamicRange", 0x00185030, "Dynamic Range", VR.kDS, VM.k1, true);
  static const DED kTotalGain
      //(0018,5040)
      = const DED("TotalGain", 0x00185040, "Total Gain", VR.kDS, VM.k1, true);
  static const DED kDepthOfScanField
      //(0018,5050)
      = const DED("DepthOfScanField", 0x00185050, "Depth of Scan Field", VR.kIS, VM.k1, false);
  static const DED kPatientPosition
      //(0018,5100)
      = const DED("PatientPosition", 0x00185100, "Patient Position", VR.kCS, VM.k1, false);
  static const DED kViewPosition
      //(0018,5101)
      = const DED("ViewPosition", 0x00185101, "View Position", VR.kCS, VM.k1, false);
  static const DED kProjectionEponymousNameCodeSequence
      //(0018,5104)
      = const DED("ProjectionEponymousNameCodeSequence", 0x00185104,
          "Projection Eponymous Name Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kImageTransformationMatrix
      //(0018,5210)
      = const DED("ImageTransformationMatrix", 0x00185210, "Image Transformation Matrix",
          VR.kDS, VM.k6, true);
  static const DED kImageTranslationVector
      //(0018,5212)
      = const DED(
          "ImageTranslationVector", 0x00185212, "Image Translation Vector", VR.kDS, VM.k3, true);
  static const DED kSensitivity
      //(0018,6000)
      = const DED("Sensitivity", 0x00186000, "Sensitivity", VR.kDS, VM.k1, false);
  static const DED kSequenceOfUltrasoundRegions
      //(0018,6011)
      = const DED("SequenceOfUltrasoundRegions", 0x00186011, "Sequence of Ultrasound Regions",
          VR.kSQ, VM.k1, false);
  static const DED kRegionSpatialFormat
      //(0018,6012)
      = const DED(
          "RegionSpatialFormat", 0x00186012, "Region Spatial Format", VR.kUS, VM.k1, false);
  static const DED kRegionDataType
      //(0018,6014)
      = const DED("RegionDataType", 0x00186014, "Region Data Type", VR.kUS, VM.k1, false);
  static const DED kRegionFlags
      //(0018,6016)
      = const DED("RegionFlags", 0x00186016, "Region Flags", VR.kUL, VM.k1, false);
  static const DED kRegionLocationMinX0
      //(0018,6018)
      = const DED(
          "RegionLocationMinX0", 0x00186018, "Region Location Min X0", VR.kUL, VM.k1, false);
  static const DED kRegionLocationMinY0
      //(0018,601A)
      = const DED(
          "RegionLocationMinY0", 0x0018601A, "Region Location Min Y0", VR.kUL, VM.k1, false);
  static const DED kRegionLocationMaxX1
      //(0018,601C)
      = const DED(
          "RegionLocationMaxX1", 0x0018601C, "Region Location Max X1", VR.kUL, VM.k1, false);
  static const DED kRegionLocationMaxY1
      //(0018,601E)
      = const DED(
          "RegionLocationMaxY1", 0x0018601E, "Region Location Max Y1", VR.kUL, VM.k1, false);
  static const DED kReferencePixelX0
      //(0018,6020)
      = const DED("ReferencePixelX0", 0x00186020, "Reference Pixel X0", VR.kSL, VM.k1, false);
  static const DED kReferencePixelY0
      //(0018,6022)
      = const DED("ReferencePixelY0", 0x00186022, "Reference Pixel Y0", VR.kSL, VM.k1, false);
  static const DED kPhysicalUnitsXDirection
      //(0018,6024)
      = const DED("PhysicalUnitsXDirection", 0x00186024, "Physical Units X Direction", VR.kUS,
          VM.k1, false);
  static const DED kPhysicalUnitsYDirection
      //(0018,6026)
      = const DED("PhysicalUnitsYDirection", 0x00186026, "Physical Units Y Direction", VR.kUS,
          VM.k1, false);
  static const DED kReferencePixelPhysicalValueX
      //(0018,6028)
      = const DED("ReferencePixelPhysicalValueX", 0x00186028,
          "Reference Pixel Physical Value X", VR.kFD, VM.k1, false);
  static const DED kReferencePixelPhysicalValueY
      //(0018,602A)
      = const DED("ReferencePixelPhysicalValueY", 0x0018602A,
          "Reference Pixel Physical Value Y", VR.kFD, VM.k1, false);
  static const DED kPhysicalDeltaX
      //(0018,602C)
      = const DED("PhysicalDeltaX", 0x0018602C, "Physical Delta X", VR.kFD, VM.k1, false);
  static const DED kPhysicalDeltaY
      //(0018,602E)
      = const DED("PhysicalDeltaY", 0x0018602E, "Physical Delta Y", VR.kFD, VM.k1, false);
  static const DED kTransducerFrequency
      //(0018,6030)
      = const DED(
          "TransducerFrequency", 0x00186030, "Transducer Frequency", VR.kUL, VM.k1, false);
  static const DED kTransducerType
      //(0018,6031)
      = const DED("TransducerType", 0x00186031, "Transducer Type", VR.kCS, VM.k1, false);
  static const DED kPulseRepetitionFrequency
      //(0018,6032)
      = const DED("PulseRepetitionFrequency", 0x00186032, "Pulse Repetition Frequency", VR.kUL,
          VM.k1, false);
  static const DED kDopplerCorrectionAngle
      //(0018,6034)
      = const DED(
          "DopplerCorrectionAngle", 0x00186034, "Doppler Correction Angle", VR.kFD, VM.k1, false);
  static const DED kSteeringAngle
      //(0018,6036)
      = const DED("SteeringAngle", 0x00186036, "Steering Angle", VR.kFD, VM.k1, false);
  static const DED kDopplerSampleVolumeXPositionRetired
      //(0018,6038)
      = const DED("DopplerSampleVolumeXPositionRetired", 0x00186038,
          "Doppler Sample Volume X Position (Retired)", VR.kUL, VM.k1, true);
  static const DED kDopplerSampleVolumeXPosition
      //(0018,6039)
      = const DED("DopplerSampleVolumeXPosition", 0x00186039,
          "Doppler Sample Volume X Position", VR.kSL, VM.k1, false);
  static const DED kDopplerSampleVolumeYPositionRetired
      //(0018,603A)
      = const DED("DopplerSampleVolumeYPositionRetired", 0x0018603A,
          "Doppler Sample Volume Y Position (Retired)", VR.kUL, VM.k1, true);
  static const DED kDopplerSampleVolumeYPosition
      //(0018,603B)
      = const DED("DopplerSampleVolumeYPosition", 0x0018603B,
          "Doppler Sample Volume Y Position", VR.kSL, VM.k1, false);
  static const DED kTMLinePositionX0Retired
      //(0018,603C)
      = const DED("TMLinePositionX0Retired", 0x0018603C, "TM-Line Position X0 (Retired)",
          VR.kUL, VM.k1, true);
  static const DED kTMLinePositionX0
      //(0018,603D)
      = const DED("TMLinePositionX0", 0x0018603D, "TM-Line Position X0", VR.kSL, VM.k1, false);
  static const DED kTMLinePositionY0Retired
      //(0018,603E)
      = const DED("TMLinePositionY0Retired", 0x0018603E, "TM-Line Position Y0 (Retired)",
          VR.kUL, VM.k1, true);
  static const DED kTMLinePositionY0
      //(0018,603F)
      = const DED("TMLinePositionY0", 0x0018603F, "TM-Line Position Y0", VR.kSL, VM.k1, false);
  static const DED kTMLinePositionX1Retired
      //(0018,6040)
      = const DED("TMLinePositionX1Retired", 0x00186040, "TM-Line Position X1 (Retired)",
          VR.kUL, VM.k1, true);
  static const DED kTMLinePositionX1
      //(0018,6041)
      = const DED("TMLinePositionX1", 0x00186041, "TM-Line Position X1", VR.kSL, VM.k1, false);
  static const DED kTMLinePositionY1Retired
      //(0018,6042)
      = const DED("TMLinePositionY1Retired", 0x00186042, "TM-Line Position Y1 (Retired)",
          VR.kUL, VM.k1, true);
  static const DED kTMLinePositionY1
      //(0018,6043)
      = const DED("TMLinePositionY1", 0x00186043, "TM-Line Position Y1", VR.kSL, VM.k1, false);
  static const DED kPixelComponentOrganization
      //(0018,6044)
      = const DED("PixelComponentOrganization", 0x00186044, "Pixel Component Organization",
          VR.kUS, VM.k1, false);
  static const DED kPixelComponentMask
      //(0018,6046)
      =
      const DED("PixelComponentMask", 0x00186046, "Pixel Component Mask", VR.kUL, VM.k1, false);
  static const DED kPixelComponentRangeStart
      //(0018,6048)
      = const DED("PixelComponentRangeStart", 0x00186048, "Pixel Component Range Start", VR.kUL,
          VM.k1, false);
  static const DED kPixelComponentRangeStop
      //(0018,604A)
      = const DED("PixelComponentRangeStop", 0x0018604A, "Pixel Component Range Stop", VR.kUL,
          VM.k1, false);
  static const DED kPixelComponentPhysicalUnits
      //(0018,604C)
      = const DED("PixelComponentPhysicalUnits", 0x0018604C, "Pixel Component Physical Units",
          VR.kUS, VM.k1, false);
  static const DED kPixelComponentDataType
      //(0018,604E)
      = const DED(
          "PixelComponentDataType", 0x0018604E, "Pixel Component Data Type", VR.kUS, VM.k1, false);
  static const DED kNumberOfTableBreakPoints
      //(0018,6050)
      = const DED("NumberOfTableBreakPoints", 0x00186050, "Number of Table Break Points",
          VR.kUL, VM.k1, false);
  static const DED kTableOfXBreakPoints
      //(0018,6052)
      = const DED(
          "TableOfXBreakPoints", 0x00186052, "Table of X Break Points", VR.kUL, VM.k1_n, false);
  static const DED kTableOfYBreakPoints
      //(0018,6054)
      = const DED(
          "TableOfYBreakPoints", 0x00186054, "Table of Y Break Points", VR.kFD, VM.k1_n, false);
  static const DED kNumberOfTableEntries
      //(0018,6056)
      = const DED(
          "NumberOfTableEntries", 0x00186056, "Number of Table Entries", VR.kUL, VM.k1, false);
  static const DED kTableOfPixelValues
      //(0018,6058)
      = const DED(
          "TableOfPixelValues", 0x00186058, "Table of Pixel Values", VR.kUL, VM.k1_n, false);
  static const DED kTableOfParameterValues
      //(0018,605A)
      = const DED("TableOfParameterValues", 0x0018605A, "Table of Parameter Values", VR.kFL,
          VM.k1_n, false);
  static const DED kRWaveTimeVector
      //(0018,6060)
      = const DED("RWaveTimeVector", 0x00186060, "R Wave Time Vector", VR.kFL, VM.k1_n, false);
  static const DED kDetectorConditionsNominalFlag
      //(0018,7000)
      = const DED("DetectorConditionsNominalFlag", 0x00187000,
          "Detector Conditions Nominal Flag", VR.kCS, VM.k1, false);
  static const DED kDetectorTemperature
      //(0018,7001)
      = const DED(
          "DetectorTemperature", 0x00187001, "Detector Temperature", VR.kDS, VM.k1, false);
  static const DED kDetectorType
      //(0018,7004)
      = const DED("DetectorType", 0x00187004, "Detector Type", VR.kCS, VM.k1, false);
  static const DED kDetectorConfiguration
      //(0018,7005)
      = const DED(
          "DetectorConfiguration", 0x00187005, "Detector Configuration", VR.kCS, VM.k1, false);
  static const DED kDetectorDescription
      //(0018,7006)
      = const DED(
          "DetectorDescription", 0x00187006, "Detector Description", VR.kLT, VM.k1, false);
  static const DED kDetectorMode
      //(0018,7008)
      = const DED("DetectorMode", 0x00187008, "Detector Mode", VR.kLT, VM.k1, false);
  static const DED kDetectorID
      //(0018,700A)
      = const DED("DetectorID", 0x0018700A, "Detector ID", VR.kSH, VM.k1, false);
  static const DED kDateOfLastDetectorCalibration
      //(0018,700C)
      = const DED("DateOfLastDetectorCalibration", 0x0018700C,
          "Date of Last Detector Calibration", VR.kDA, VM.k1, false);
  static const DED kTimeOfLastDetectorCalibration
      //(0018,700E)
      = const DED("TimeOfLastDetectorCalibration", 0x0018700E,
          "Time of Last Detector Calibration", VR.kTM, VM.k1, false);
  static const DED kExposuresOnDetectorSinceLastCalibration
      //(0018,7010)
      = const DED("ExposuresOnDetectorSinceLastCalibration", 0x00187010,
          "Exposures on Detector Since Last Calibration", VR.kIS, VM.k1, false);
  static const DED kExposuresOnDetectorSinceManufactured
      //(0018,7011)
      = const DED("ExposuresOnDetectorSinceManufactured", 0x00187011,
          "Exposures on Detector Since Manufactured", VR.kIS, VM.k1, false);
  static const DED kDetectorTimeSinceLastExposure
      //(0018,7012)
      = const DED("DetectorTimeSinceLastExposure", 0x00187012,
          "Detector Time Since Last Exposure", VR.kDS, VM.k1, false);
  static const DED kDetectorActiveTime
      //(0018,7014)
      =
      const DED("DetectorActiveTime", 0x00187014, "Detector Active Time", VR.kDS, VM.k1, false);
  static const DED kDetectorActivationOffsetFromExposure
      //(0018,7016)
      = const DED("DetectorActivationOffsetFromExposure", 0x00187016,
          "Detector Activation Offset From Exposure", VR.kDS, VM.k1, false);
  static const DED kDetectorBinning
      //(0018,701A)
      = const DED("DetectorBinning", 0x0018701A, "Detector Binning", VR.kDS, VM.k2, false);
  static const DED kDetectorElementPhysicalSize
      //(0018,7020)
      = const DED("DetectorElementPhysicalSize", 0x00187020, "Detector Element Physical Size",
          VR.kDS, VM.k2, false);
  static const DED kDetectorElementSpacing
      //(0018,7022)
      = const DED(
          "DetectorElementSpacing", 0x00187022, "Detector Element Spacing", VR.kDS, VM.k2, false);
  static const DED kDetectorActiveShape
      //(0018,7024)
      = const DED(
          "DetectorActiveShape", 0x00187024, "Detector Active Shape", VR.kCS, VM.k1, false);
  static const DED kDetectorActiveDimensions
      //(0018,7026)
      = const DED("DetectorActiveDimensions", 0x00187026, "Detector Active Dimension(s)",
          VR.kDS, VM.k1_2, false);
  static const DED kDetectorActiveOrigin
      //(0018,7028)
      = const DED(
          "DetectorActiveOrigin", 0x00187028, "Detector Active Origin", VR.kDS, VM.k2, false);
  static const DED kDetectorManufacturerName
      //(0018,702A)
      = const DED("DetectorManufacturerName", 0x0018702A, "Detector Manufacturer Name", VR.kLO,
          VM.k1, false);
  static const DED kDetectorManufacturerModelName
      //(0018,702B)
      = const DED("DetectorManufacturerModelName", 0x0018702B,
          "Detector Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const DED kFieldOfViewOrigin
      //(0018,7030)
      =
      const DED("FieldOfViewOrigin", 0x00187030, "Field of View Origin", VR.kDS, VM.k2, false);
  static const DED kFieldOfViewRotation
      //(0018,7032)
      = const DED(
          "FieldOfViewRotation", 0x00187032, "Field of View Rotation", VR.kDS, VM.k1, false);
  static const DED kFieldOfViewHorizontalFlip
      //(0018,7034)
      = const DED("FieldOfViewHorizontalFlip", 0x00187034, "Field of View Horizontal Flip",
          VR.kCS, VM.k1, false);
  static const DED kPixelDataAreaOriginRelativeToFOV
      //(0018,7036)
      = const DED("PixelDataAreaOriginRelativeToFOV", 0x00187036,
          "Pixel Data Area Origin Relative To FOV", VR.kFL, VM.k2, false);
  static const DED kPixelDataAreaRotationAngleRelativeToFOV
      //(0018,7038)
      = const DED("PixelDataAreaRotationAngleRelativeToFOV", 0x00187038,
          "Pixel Data Area Rotation Angle Relative To FOV", VR.kFL, VM.k1, false);
  static const DED kGridAbsorbingMaterial
      //(0018,7040)
      = const DED(
          "GridAbsorbingMaterial", 0x00187040, "Grid Absorbing Material", VR.kLT, VM.k1, false);
  static const DED kGridSpacingMaterial
      //(0018,7041)
      = const DED(
          "GridSpacingMaterial", 0x00187041, "Grid Spacing Material", VR.kLT, VM.k1, false);
  static const DED kGridThickness
      //(0018,7042)
      = const DED("GridThickness", 0x00187042, "Grid Thickness", VR.kDS, VM.k1, false);
  static const DED kGridPitch
      //(0018,7044)
      = const DED("GridPitch", 0x00187044, "Grid Pitch", VR.kDS, VM.k1, false);
  static const DED kGridAspectRatio
      //(0018,7046)
      = const DED("GridAspectRatio", 0x00187046, "Grid Aspect Ratio", VR.kIS, VM.k2, false);
  static const DED kGridPeriod
      //(0018,7048)
      = const DED("GridPeriod", 0x00187048, "Grid Period", VR.kDS, VM.k1, false);
  static const DED kGridFocalDistance
      //(0018,704C)
      = const DED("GridFocalDistance", 0x0018704C, "Grid Focal Distance", VR.kDS, VM.k1, false);
  static const DED kFilterMaterial
      //(0018,7050)
      = const DED("FilterMaterial", 0x00187050, "Filter Material", VR.kCS, VM.k1_n, false);
  static const DED kFilterThicknessMinimum
      //(0018,7052)
      = const DED(
          "FilterThicknessMinimum", 0x00187052, "Filter Thickness Minimum", VR.kDS, VM.k1_n, false);
  static const DED kFilterThicknessMaximum
      //(0018,7054)
      = const DED(
          "FilterThicknessMaximum", 0x00187054, "Filter Thickness Maximum", VR.kDS, VM.k1_n, false);
  static const DED kFilterBeamPathLengthMinimum
      //(0018,7056)
      = const DED("FilterBeamPathLengthMinimum", 0x00187056, "Filter Beam Path Length Minimum",
          VR.kFL, VM.k1_n, false);
  static const DED kFilterBeamPathLengthMaximum
      //(0018,7058)
      = const DED("FilterBeamPathLengthMaximum", 0x00187058, "Filter Beam Path Length Maximum",
          VR.kFL, VM.k1_n, false);
  static const DED kExposureControlMode
      //(0018,7060)
      = const DED(
          "ExposureControlMode", 0x00187060, "Exposure Control Mode", VR.kCS, VM.k1, false);
  static const DED kExposureControlModeDescription
      //(0018,7062)
      = const DED("ExposureControlModeDescription", 0x00187062,
          "Exposure Control Mode Description", VR.kLT, VM.k1, false);
  static const DED kExposureStatus
      //(0018,7064)
      = const DED("ExposureStatus", 0x00187064, "Exposure Status", VR.kCS, VM.k1, false);
  static const DED kPhototimerSetting
      //(0018,7065)
      = const DED("PhototimerSetting", 0x00187065, "Phototimer Setting", VR.kDS, VM.k1, false);
  static const DED kExposureTimeInuS
      //(0018,8150)
      = const DED("ExposureTimeInuS", 0x00188150, "Exposure Time in µS", VR.kDS, VM.k1, false);
  static const DED kXRayTubeCurrentInuA
      //(0018,8151)
      = const DED(
          "XRayTubeCurrentInuA", 0x00188151, "X-Ray Tube Current in µA", VR.kDS, VM.k1, false);
  static const DED kContentQualification
      //(0018,9004)
      = const DED(
          "ContentQualification", 0x00189004, "Content Qualification", VR.kCS, VM.k1, false);
  static const DED kPulseSequenceName
      //(0018,9005)
      = const DED("PulseSequenceName", 0x00189005, "Pulse Sequence Name", VR.kSH, VM.k1, false);
  static const DED kMRImagingModifierSequence
      //(0018,9006)
      = const DED("MRImagingModifierSequence", 0x00189006, "MR Imaging Modifier Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kEchoPulseSequence
      //(0018,9008)
      = const DED("EchoPulseSequence", 0x00189008, "Echo Pulse Sequence", VR.kCS, VM.k1, false);
  static const DED kInversionRecovery
      //(0018,9009)
      = const DED("InversionRecovery", 0x00189009, "Inversion Recovery", VR.kCS, VM.k1, false);
  static const DED kFlowCompensation
      //(0018,9010)
      = const DED("FlowCompensation", 0x00189010, "Flow Compensation", VR.kCS, VM.k1, false);
  static const DED kMultipleSpinEcho
      //(0018,9011)
      = const DED("MultipleSpinEcho", 0x00189011, "Multiple Spin Echo", VR.kCS, VM.k1, false);
  static const DED kMultiPlanarExcitation
      //(0018,9012)
      = const DED(
          "MultiPlanarExcitation", 0x00189012, "Multi-planar Excitation", VR.kCS, VM.k1, false);
  static const DED kPhaseContrast
      //(0018,9014)
      = const DED("PhaseContrast", 0x00189014, "Phase Contrast", VR.kCS, VM.k1, false);
  static const DED kTimeOfFlightContrast
      //(0018,9015)
      = const DED(
          "TimeOfFlightContrast", 0x00189015, "Time of Flight Contrast", VR.kCS, VM.k1, false);
  static const DED kSpoiling
      //(0018,9016)
      = const DED("Spoiling", 0x00189016, "Spoiling", VR.kCS, VM.k1, false);
  static const DED kSteadyStatePulseSequence
      //(0018,9017)
      = const DED("SteadyStatePulseSequence", 0x00189017, "Steady State Pulse Sequence", VR.kCS,
          VM.k1, false);
  static const DED kEchoPlanarPulseSequence
      //(0018,9018)
      = const DED("EchoPlanarPulseSequence", 0x00189018, "Echo Planar Pulse Sequence", VR.kCS,
          VM.k1, false);
  static const DED kTagAngleFirstAxis
      //(0018,9019)
      = const DED(
          "TagAngleFirstAxis", 0x00189019, "Tag Angle First Axis", VR.kFD, VM.k1, false);
  static const DED kMagnetizationTransfer
      //(0018,9020)
      = const DED(
          "MagnetizationTransfer", 0x00189020, "Magnetization Transfer", VR.kCS, VM.k1, false);
  static const DED kT2Preparation
      //(0018,9021)
      = const DED("T2Preparation", 0x00189021, "T2 Preparation", VR.kCS, VM.k1, false);
  static const DED kBloodSignalNulling
      //(0018,9022)
      =
      const DED("BloodSignalNulling", 0x00189022, "Blood Signal Nulling", VR.kCS, VM.k1, false);
  static const DED kSaturationRecovery
      //(0018,9024)
      =
      const DED("SaturationRecovery", 0x00189024, "Saturation Recovery", VR.kCS, VM.k1, false);
  static const DED kSpectrallySelectedSuppression
      //(0018,9025)
      = const DED("SpectrallySelectedSuppression", 0x00189025,
          "Spectrally Selected Suppression", VR.kCS, VM.k1, false);
  static const DED kSpectrallySelectedExcitation
      //(0018,9026)
      = const DED("SpectrallySelectedExcitation", 0x00189026, "Spectrally Selected Excitation",
          VR.kCS, VM.k1, false);
  static const DED kSpatialPresaturation
      //(0018,9027)
      = const DED(
          "SpatialPresaturation", 0x00189027, "Spatial Pre-saturation", VR.kCS, VM.k1, false);
  static const DED kTagging
      //(0018,9028)
      = const DED("Tagging", 0x00189028, "Tagging", VR.kCS, VM.k1, false);
  static const DED kOversamplingPhase
      //(0018,9029)
      = const DED("OversamplingPhase", 0x00189029, "Oversampling Phase", VR.kCS, VM.k1, false);
  static const DED kTagSpacingFirstDimension
      //(0018,9030)
      = const DED("TagSpacingFirstDimension", 0x00189030, "Tag Spacing First Dimension",
          VR.kFD, VM.k1, false);
  static const DED kGeometryOfKSpaceTraversal
      //(0018,9032)
      = const DED("GeometryOfKSpaceTraversal", 0x00189032, "Geometry of k-Space Traversal",
          VR.kCS, VM.k1, false);
  static const DED kSegmentedKSpaceTraversal
      //(0018,9033)
      = const DED("SegmentedKSpaceTraversal", 0x00189033, "Segmented k-Space Traversal", VR.kCS,
          VM.k1, false);
  static const DED kRectilinearPhaseEncodeReordering
      //(0018,9034)
      = const DED("RectilinearPhaseEncodeReordering", 0x00189034,
          "Rectilinear Phase Encode Reordering", VR.kCS, VM.k1, false);
  static const DED kTagThickness
      //(0018,9035)
      = const DED("TagThickness", 0x00189035, "Tag Thickness", VR.kFD, VM.k1, false);
  static const DED kPartialFourierDirection
      //(0018,9036)
      = const DED(
          "PartialFourierDirection", 0x00189036, "Partial Fourier Direction", VR.kCS, VM.k1, false);
  static const DED kCardiacSynchronizationTechnique
      //(0018,9037)
      = const DED("CardiacSynchronizationTechnique", 0x00189037,
          "Cardiac Synchronization Technique", VR.kCS, VM.k1, false);
  static const DED kReceiveCoilManufacturerName
      //(0018,9041)
      = const DED("ReceiveCoilManufacturerName", 0x00189041, "Receive Coil Manufacturer Name",
          VR.kLO, VM.k1, false);
  static const DED kMRReceiveCoilSequence
      //(0018,9042)
      = const DED(
          "MRReceiveCoilSequence", 0x00189042, "MR Receive Coil Sequence", VR.kSQ, VM.k1, false);
  static const DED kReceiveCoilType
      //(0018,9043)
      = const DED("ReceiveCoilType", 0x00189043, "Receive Coil Type", VR.kCS, VM.k1, false);
  static const DED kQuadratureReceiveCoil
      //(0018,9044)
      = const DED(
          "QuadratureReceiveCoil", 0x00189044, "Quadrature Receive Coil", VR.kCS, VM.k1, false);
  static const DED kMultiCoilDefinitionSequence
      //(0018,9045)
      = const DED("MultiCoilDefinitionSequence", 0x00189045, "Multi-Coil Definition Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMultiCoilConfiguration
      //(0018,9046)
      = const DED(
          "MultiCoilConfiguration", 0x00189046, "Multi-Coil Configuration", VR.kLO, VM.k1, false);
  static const DED kMultiCoilElementName
      //(0018,9047)
      = const DED(
          "MultiCoilElementName", 0x00189047, "Multi-Coil Element Name", VR.kSH, VM.k1, false);
  static const DED kMultiCoilElementUsed
      //(0018,9048)
      = const DED(
          "MultiCoilElementUsed", 0x00189048, "Multi-Coil Element Used", VR.kCS, VM.k1, false);
  static const DED kMRTransmitCoilSequence
      //(0018,9049)
      = const DED(
          "MRTransmitCoilSequence", 0x00189049, "MR Transmit Coil Sequence", VR.kSQ, VM.k1, false);
  static const DED kTransmitCoilManufacturerName
      //(0018,9050)
      = const DED("TransmitCoilManufacturerName", 0x00189050, "Transmit Coil Manufacturer Name",
          VR.kLO, VM.k1, false);
  static const DED kTransmitCoilType
      //(0018,9051)
      = const DED("TransmitCoilType", 0x00189051, "Transmit Coil Type", VR.kCS, VM.k1, false);
  static const DED kSpectralWidth
      //(0018,9052)
      = const DED("SpectralWidth", 0x00189052, "Spectral Width", VR.kFD, VM.k1_2, false);
  static const DED kChemicalShiftReference
      //(0018,9053)
      = const DED(
          "ChemicalShiftReference", 0x00189053, "Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const DED kVolumeLocalizationTechnique
      //(0018,9054)
      = const DED("VolumeLocalizationTechnique", 0x00189054, "Volume Localization Technique",
          VR.kCS, VM.k1, false);
  static const DED kMRAcquisitionFrequencyEncodingSteps
      //(0018,9058)
      = const DED("MRAcquisitionFrequencyEncodingSteps", 0x00189058,
          "MR Acquisition Frequency Encoding Steps", VR.kUS, VM.k1, false);
  static const DED kDecoupling
      //(0018,9059)
      = const DED("Decoupling", 0x00189059, "De-coupling", VR.kCS, VM.k1, false);
  static const DED kDecoupledNucleus
      //(0018,9060)
      = const DED("DecoupledNucleus", 0x00189060, "De-coupled Nucleus", VR.kCS, VM.k1_2, false);
  static const DED kDecouplingFrequency
      //(0018,9061)
      = const DED(
          "DecouplingFrequency", 0x00189061, "De-coupling Frequency", VR.kFD, VM.k1_2, false);
  static const DED kDecouplingMethod
      //(0018,9062)
      = const DED("DecouplingMethod", 0x00189062, "De-coupling Method", VR.kCS, VM.k1, false);
  static const DED kDecouplingChemicalShiftReference
      //(0018,9063)
      = const DED("DecouplingChemicalShiftReference", 0x00189063,
          "De-coupling Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const DED kKSpaceFiltering
      //(0018,9064)
      = const DED("KSpaceFiltering", 0x00189064, "k-space Filtering", VR.kCS, VM.k1, false);
  static const DED kTimeDomainFiltering
      //(0018,9065)
      = const DED(
          "TimeDomainFiltering", 0x00189065, "Time Domain Filtering", VR.kCS, VM.k1_2, false);
  static const DED kNumberOfZeroFills
      //(0018,9066)
      = const DED(
          "NumberOfZeroFills", 0x00189066, "Number of Zero Fills", VR.kUS, VM.k1_2, false);
  static const DED kBaselineCorrection
      //(0018,9067)
      =
      const DED("BaselineCorrection", 0x00189067, "Baseline Correction", VR.kCS, VM.k1, false);
  static const DED kParallelReductionFactorInPlane
      //(0018,9069)
      = const DED("ParallelReductionFactorInPlane", 0x00189069,
          "Parallel Reduction Factor In-plane", VR.kFD, VM.k1, false);
  static const DED kCardiacRRIntervalSpecified
      //(0018,9070)
      = const DED("CardiacRRIntervalSpecified", 0x00189070, "Cardiac R-R Interval Specified",
          VR.kFD, VM.k1, false);
  static const DED kAcquisitionDuration
      //(0018,9073)
      = const DED(
          "AcquisitionDuration", 0x00189073, "Acquisition Duration", VR.kFD, VM.k1, false);
  static const DED kFrameAcquisitionDateTime
      //(0018,9074)
      = const DED("FrameAcquisitionDateTime", 0x00189074, "Frame Acquisition DateTime", VR.kDT,
          VM.k1, false);
  static const DED kDiffusionDirectionality
      //(0018,9075)
      = const DED(
          "DiffusionDirectionality", 0x00189075, "Diffusion Directionality", VR.kCS, VM.k1, false);
  static const DED kDiffusionGradientDirectionSequence
      //(0018,9076)
      = const DED("DiffusionGradientDirectionSequence", 0x00189076,
          "Diffusion Gradient Direction Sequence", VR.kSQ, VM.k1, false);
  static const DED kParallelAcquisition
      //(0018,9077)
      = const DED(
          "ParallelAcquisition", 0x00189077, "Parallel Acquisition", VR.kCS, VM.k1, false);
  static const DED kParallelAcquisitionTechnique
      //(0018,9078)
      = const DED("ParallelAcquisitionTechnique", 0x00189078, "Parallel Acquisition Technique",
          VR.kCS, VM.k1, false);
  static const DED kInversionTimes
      //(0018,9079)
      = const DED("InversionTimes", 0x00189079, "Inversion Times", VR.kFD, VM.k1_n, false);
  static const DED kMetaboliteMapDescription
      //(0018,9080)
      = const DED("MetaboliteMapDescription", 0x00189080, "Metabolite Map Description", VR.kST,
          VM.k1, false);
  static const DED kPartialFourier
      //(0018,9081)
      = const DED("PartialFourier", 0x00189081, "Partial Fourier", VR.kCS, VM.k1, false);
  static const DED kEffectiveEchoTime
      //(0018,9082)
      = const DED("EffectiveEchoTime", 0x00189082, "Effective Echo Time", VR.kFD, VM.k1, false);
  static const DED kMetaboliteMapCodeSequence
      //(0018,9083)
      = const DED("MetaboliteMapCodeSequence", 0x00189083, "Metabolite Map Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kChemicalShiftSequence
      //(0018,9084)
      = const DED(
          "ChemicalShiftSequence", 0x00189084, "Chemical Shift Sequence", VR.kSQ, VM.k1, false);
  static const DED kCardiacSignalSource
      //(0018,9085)
      = const DED(
          "CardiacSignalSource", 0x00189085, "Cardiac Signal Source", VR.kCS, VM.k1, false);
  static const DED kDiffusionBValue
      //(0018,9087)
      = const DED("DiffusionBValue", 0x00189087, "Diffusion b-value", VR.kFD, VM.k1, false);
  static const DED kDiffusionGradientOrientation
      //(0018,9089)
      = const DED("DiffusionGradientOrientation", 0x00189089, "Diffusion Gradient Orientation",
          VR.kFD, VM.k3, false);
  static const DED kVelocityEncodingDirection
      //(0018,9090)
      = const DED("VelocityEncodingDirection", 0x00189090, "Velocity Encoding Direction",
          VR.kFD, VM.k3, false);
  static const DED kVelocityEncodingMinimumValue
      //(0018,9091)
      = const DED("VelocityEncodingMinimumValue", 0x00189091, "Velocity Encoding Minimum Value",
          VR.kFD, VM.k1, false);
  static const DED kVelocityEncodingAcquisitionSequence
      //(0018,9092)
      = const DED("VelocityEncodingAcquisitionSequence", 0x00189092,
          "Velocity Encoding Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumberOfKSpaceTrajectories
      //(0018,9093)
      = const DED("NumberOfKSpaceTrajectories", 0x00189093, "Number of k-Space Trajectories",
          VR.kUS, VM.k1, false);
  static const DED kCoverageOfKSpace
      //(0018,9094)
      = const DED("CoverageOfKSpace", 0x00189094, "Coverage of k-Space", VR.kCS, VM.k1, false);
  static const DED kSpectroscopyAcquisitionPhaseRows
      //(0018,9095)
      = const DED("SpectroscopyAcquisitionPhaseRows", 0x00189095,
          "Spectroscopy Acquisition Phase Rows", VR.kUL, VM.k1, false);
  static const DED kParallelReductionFactorInPlaneRetired
      //(0018,9096)
      = const DED("ParallelReductionFactorInPlaneRetired", 0x00189096,
          "Parallel Reduction Factor In-plane (Retired)", VR.kFD, VM.k1, true);
  static const DED kTransmitterFrequency
      //(0018,9098)
      = const DED(
          "TransmitterFrequency", 0x00189098, "Transmitter Frequency", VR.kFD, VM.k1_2, false);
  static const DED kResonantNucleus
      //(0018,9100)
      = const DED("ResonantNucleus", 0x00189100, "Resonant Nucleus", VR.kCS, VM.k1_2, false);
  static const DED kFrequencyCorrection
      //(0018,9101)
      = const DED(
          "FrequencyCorrection", 0x00189101, "Frequency Correction", VR.kCS, VM.k1, false);
  static const DED kMRSpectroscopyFOVGeometrySequence
      //(0018,9103)
      = const DED("MRSpectroscopyFOVGeometrySequence", 0x00189103,
          "MR Spectroscopy FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const DED kSlabThickness
      //(0018,9104)
      = const DED("SlabThickness", 0x00189104, "Slab Thickness", VR.kFD, VM.k1, false);
  static const DED kSlabOrientation
      //(0018,9105)
      = const DED("SlabOrientation", 0x00189105, "Slab Orientation", VR.kFD, VM.k3, false);
  static const DED kMidSlabPosition
      //(0018,9106)
      = const DED("MidSlabPosition", 0x00189106, "Mid Slab Position", VR.kFD, VM.k3, false);
  static const DED kMRSpatialSaturationSequence
      //(0018,9107)
      = const DED("MRSpatialSaturationSequence", 0x00189107, "MR Spatial Saturation Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMRTimingAndRelatedParametersSequence
      //(0018,9112)
      = const DED("MRTimingAndRelatedParametersSequence", 0x00189112,
          "MR Timing and Related Parameters Sequence", VR.kSQ, VM.k1, false);
  static const DED kMREchoSequence
      //(0018,9114)
      = const DED("MREchoSequence", 0x00189114, "MR Echo Sequence", VR.kSQ, VM.k1, false);
  static const DED kMRModifierSequence
      //(0018,9115)
      =
      const DED("MRModifierSequence", 0x00189115, "MR Modifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kMRDiffusionSequence
      //(0018,9117)
      = const DED(
          "MRDiffusionSequence", 0x00189117, "MR Diffusion Sequence", VR.kSQ, VM.k1, false);
  static const DED kCardiacSynchronizationSequence
      //(0018,9118)
      = const DED("CardiacSynchronizationSequence", 0x00189118,
          "Cardiac Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const DED kMRAveragesSequence
      //(0018,9119)
      =
      const DED("MRAveragesSequence", 0x00189119, "MR Averages Sequence", VR.kSQ, VM.k1, false);
  static const DED kMRFOVGeometrySequence
      //(0018,9125)
      = const DED(
          "MRFOVGeometrySequence", 0x00189125, "MR FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const DED kVolumeLocalizationSequence
      //(0018,9126)
      = const DED("VolumeLocalizationSequence", 0x00189126, "Volume Localization Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSpectroscopyAcquisitionDataColumns
      //(0018,9127)
      = const DED("SpectroscopyAcquisitionDataColumns", 0x00189127,
          "Spectroscopy Acquisition Data Columns", VR.kUL, VM.k1, false);
  static const DED kDiffusionAnisotropyType
      //(0018,9147)
      = const DED(
          "DiffusionAnisotropyType", 0x00189147, "Diffusion Anisotropy Type", VR.kCS, VM.k1, false);
  static const DED kFrameReferenceDateTime
      //(0018,9151)
      = const DED(
          "FrameReferenceDateTime", 0x00189151, "Frame Reference DateTime", VR.kDT, VM.k1, false);
  static const DED kMRMetaboliteMapSequence
      //(0018,9152)
      = const DED("MRMetaboliteMapSequence", 0x00189152, "MR Metabolite Map Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kParallelReductionFactorOutOfPlane
      //(0018,9155)
      = const DED("ParallelReductionFactorOutOfPlane", 0x00189155,
          "Parallel Reduction Factor out-of-plane", VR.kFD, VM.k1, false);
  static const DED kSpectroscopyAcquisitionOutOfPlanePhaseSteps
      //(0018,9159)
      = const DED("SpectroscopyAcquisitionOutOfPlanePhaseSteps", 0x00189159,
          "Spectroscopy Acquisition Out-of-plane Phase Steps", VR.kUL, VM.k1, false);
  static const DED kBulkMotionStatus
      //(0018,9166)
      = const DED("BulkMotionStatus", 0x00189166, "Bulk Motion Status", VR.kCS, VM.k1, true);
  static const DED kParallelReductionFactorSecondInPlane
      //(0018,9168)
      = const DED("ParallelReductionFactorSecondInPlane", 0x00189168,
          "Parallel Reduction Factor Second In-plane", VR.kFD, VM.k1, false);
  static const DED kCardiacBeatRejectionTechnique
      //(0018,9169)
      = const DED("CardiacBeatRejectionTechnique", 0x00189169,
          "Cardiac Beat Rejection Technique", VR.kCS, VM.k1, false);
  static const DED kRespiratoryMotionCompensationTechnique
      //(0018,9170)
      = const DED("RespiratoryMotionCompensationTechnique", 0x00189170,
          "Respiratory Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const DED kRespiratorySignalSource
      //(0018,9171)
      = const DED(
          "RespiratorySignalSource", 0x00189171, "Respiratory Signal Source", VR.kCS, VM.k1, false);
  static const DED kBulkMotionCompensationTechnique
      //(0018,9172)
      = const DED("BulkMotionCompensationTechnique", 0x00189172,
          "Bulk Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const DED kBulkMotionSignalSource
      //(0018,9173)
      = const DED(
          "BulkMotionSignalSource", 0x00189173, "Bulk Motion Signal Source", VR.kCS, VM.k1, false);
  static const DED kApplicableSafetyStandardAgency
      //(0018,9174)
      = const DED("ApplicableSafetyStandardAgency", 0x00189174,
          "Applicable Safety Standard Agency", VR.kCS, VM.k1, false);
  static const DED kApplicableSafetyStandardDescription
      //(0018,9175)
      = const DED("ApplicableSafetyStandardDescription", 0x00189175,
          "Applicable Safety Standard Description", VR.kLO, VM.k1, false);
  static const DED kOperatingModeSequence
      //(0018,9176)
      = const DED(
          "OperatingModeSequence", 0x00189176, "Operating Mode Sequence", VR.kSQ, VM.k1, false);
  static const DED kOperatingModeType
      //(0018,9177)
      = const DED("OperatingModeType", 0x00189177, "Operating Mode Type", VR.kCS, VM.k1, false);
  static const DED kOperatingMode
      //(0018,9178)
      = const DED("OperatingMode", 0x00189178, "Operating Mode", VR.kCS, VM.k1, false);
  static const DED kSpecificAbsorptionRateDefinition
      //(0018,9179)
      = const DED("SpecificAbsorptionRateDefinition", 0x00189179,
          "Specific Absorption Rate Definition", VR.kCS, VM.k1, false);
  static const DED kGradientOutputType
      //(0018,9180)
      =
      const DED("GradientOutputType", 0x00189180, "Gradient Output Type", VR.kCS, VM.k1, false);
  static const DED kSpecificAbsorptionRateValue
      //(0018,9181)
      = const DED("SpecificAbsorptionRateValue", 0x00189181, "Specific Absorption Rate Value",
          VR.kFD, VM.k1, false);
  static const DED kGradientOutput
      //(0018,9182)
      = const DED("GradientOutput", 0x00189182, "Gradient Output", VR.kFD, VM.k1, false);
  static const DED kFlowCompensationDirection
      //(0018,9183)
      = const DED("FlowCompensationDirection", 0x00189183, "Flow Compensation Direction",
          VR.kCS, VM.k1, false);
  static const DED kTaggingDelay
      //(0018,9184)
      = const DED("TaggingDelay", 0x00189184, "Tagging Delay", VR.kFD, VM.k1, false);
  static const DED kRespiratoryMotionCompensationTechniqueDescription
      //(0018,9185)
      = const DED("RespiratoryMotionCompensationTechniqueDescription", 0x00189185,
          "Respiratory Motion Compensation Technique Description", VR.kST, VM.k1, false);
  static const DED kRespiratorySignalSourceID
      //(0018,9186)
      = const DED("RespiratorySignalSourceID", 0x00189186, "Respiratory Signal Source ID",
          VR.kSH, VM.k1, false);
  static const DED kChemicalShiftMinimumIntegrationLimitInHz
      //(0018,9195)
      = const DED("ChemicalShiftMinimumIntegrationLimitInHz", 0x00189195,
          "Chemical Shift Minimum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const DED kChemicalShiftMaximumIntegrationLimitInHz
      //(0018,9196)
      = const DED("ChemicalShiftMaximumIntegrationLimitInHz", 0x00189196,
          "Chemical Shift Maximum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const DED kMRVelocityEncodingSequence
      //(0018,9197)
      = const DED("MRVelocityEncodingSequence", 0x00189197, "MR Velocity Encoding Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kFirstOrderPhaseCorrection
      //(0018,9198)
      = const DED("FirstOrderPhaseCorrection", 0x00189198, "First Order Phase Correction",
          VR.kCS, VM.k1, false);
  static const DED kWaterReferencedPhaseCorrection
      //(0018,9199)
      = const DED("WaterReferencedPhaseCorrection", 0x00189199,
          "Water Referenced Phase Correction", VR.kCS, VM.k1, false);
  static const DED kMRSpectroscopyAcquisitionType
      //(0018,9200)
      = const DED("MRSpectroscopyAcquisitionType", 0x00189200,
          "MR Spectroscopy Acquisition Type", VR.kCS, VM.k1, false);
  static const DED kRespiratoryCyclePosition
      //(0018,9214)
      = const DED("RespiratoryCyclePosition", 0x00189214, "Respiratory Cycle Position", VR.kCS,
          VM.k1, false);
  static const DED kVelocityEncodingMaximumValue
      //(0018,9217)
      = const DED("VelocityEncodingMaximumValue", 0x00189217, "Velocity Encoding Maximum Value",
          VR.kFD, VM.k1, false);
  static const DED kTagSpacingSecondDimension
      //(0018,9218)
      = const DED("TagSpacingSecondDimension", 0x00189218,
          "Tag Spacing Second Dimension", VR.kFD, VM.k1, false);
  static const DED kTagAngleSecondAxis
      //(0018,9219)
      = const DED(
          "TagAngleSecondAxis", 0x00189219, "Tag Angle Second Axis", VR.kSS, VM.k1, false);
  static const DED kFrameAcquisitionDuration
      //(0018,9220)
      = const DED("FrameAcquisitionDuration", 0x00189220, "Frame Acquisition Duration", VR.kFD,
          VM.k1, false);
  static const DED kMRImageFrameTypeSequence
      //(0018,9226)
      = const DED("MRImageFrameTypeSequence", 0x00189226, "MR Image Frame Type Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMRSpectroscopyFrameTypeSequence
      //(0018,9227)
      = const DED("MRSpectroscopyFrameTypeSequence", 0x00189227,
          "MR Spectroscopy Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const DED kMRAcquisitionPhaseEncodingStepsInPlane
      //(0018,9231)
      = const DED("MRAcquisitionPhaseEncodingStepsInPlane", 0x00189231,
          "MR Acquisition Phase Encoding Steps in-plane", VR.kUS, VM.k1, false);
  static const DED kMRAcquisitionPhaseEncodingStepsOutOfPlane
      //(0018,9232)
      = const DED("MRAcquisitionPhaseEncodingStepsOutOfPlane", 0x00189232,
          "MR Acquisition Phase Encoding Steps out-of-plane", VR.kUS, VM.k1, false);
  static const DED kSpectroscopyAcquisitionPhaseColumns
      //(0018,9234)
      = const DED("SpectroscopyAcquisitionPhaseColumns", 0x00189234,
          "Spectroscopy Acquisition Phase Columns", VR.kUL, VM.k1, false);
  static const DED kCardiacCyclePosition
      //(0018,9236)
      = const DED(
          "CardiacCyclePosition", 0x00189236, "Cardiac Cycle Position", VR.kCS, VM.k1, false);
  static const DED kSpecificAbsorptionRateSequence
      //(0018,9239)
      = const DED("SpecificAbsorptionRateSequence", 0x00189239,
          "Specific Absorption Rate Sequence", VR.kSQ, VM.k1, false);
  static const DED kRFEchoTrainLength
      //(0018,9240)
      =
      const DED("RFEchoTrainLength", 0x00189240, "RF Echo Train Length", VR.kUS, VM.k1, false);
  static const DED kGradientEchoTrainLength
      //(0018,9241)
      = const DED("GradientEchoTrainLength", 0x00189241, "Gradient Echo Train Length", VR.kUS,
          VM.k1, false);
  static const DED kArterialSpinLabelingContrast
      //(0018,9250)
      = const DED("ArterialSpinLabelingContrast", 0x00189250, "Arterial Spin Labeling Contrast",
          VR.kCS, VM.k1, false);
  static const DED kMRArterialSpinLabelingSequence
      //(0018,9251)
      = const DED("MRArterialSpinLabelingSequence", 0x00189251,
          "MR Arterial Spin Labeling Sequence", VR.kSQ, VM.k1, false);
  static const DED kASLTechniqueDescription
      //(0018,9252)
      = const DED(
          "ASLTechniqueDescription", 0x00189252, "ASL Technique Description", VR.kLO, VM.k1, false);
  static const DED kASLSlabNumber
      //(0018,9253)
      = const DED("ASLSlabNumber", 0x00189253, "ASL Slab Number", VR.kUS, VM.k1, false);
  static const DED kASLSlabThickness
      //(0018,9254)
      = const DED("ASLSlabThickness", 0x00189254, "ASL Slab Thickness", VR.kFD, VM.k1, false);
  static const DED kASLSlabOrientation
      //(0018,9255)
      =
      const DED("ASLSlabOrientation", 0x00189255, "ASL Slab Orientation", VR.kFD, VM.k3, false);
  static const DED kASLMidSlabPosition
      //(0018,9256)
      = const DED(
          "ASLMidSlabPosition", 0x00189256, "ASL Mid Slab Position", VR.kFD, VM.k3, false);
  static const DED kASLContext
      //(0018,9257)
      = const DED("ASLContext", 0x00189257, "ASL Context", VR.kCS, VM.k1, false);
  static const DED kASLPulseTrainDuration
      //(0018,9258)
      = const DED(
          "ASLPulseTrainDuration", 0x00189258, "ASL Pulse Train Duration", VR.kUL, VM.k1, false);
  static const DED kASLCrusherFlag
      //(0018,9259)
      = const DED("ASLCrusherFlag", 0x00189259, "ASL Crusher Flag", VR.kCS, VM.k1, false);
  static const DED kASLCrusherFlowLimit
      //(0018,925A)
      = const DED(
          "ASLCrusherFlowLimit", 0x0018925A, "ASL Crusher Flow Limit", VR.kFD, VM.k1, false);
  static const DED kASLCrusherDescription
      //(0018,925B)
      = const DED(
          "ASLCrusherDescription", 0x0018925B, "ASL Crusher Description", VR.kLO, VM.k1, false);
  static const DED kASLBolusCutoffFlag
      //(0018,925C)
      = const DED(
          "ASLBolusCutoffFlag", 0x0018925C, "ASL Bolus Cut-off Flag", VR.kCS, VM.k1, false);
  static const DED kASLBolusCutoffTimingSequence
      //(0018,925D)
      = const DED("ASLBolusCutoffTimingSequence", 0x0018925D,
          "ASL Bolus Cut-off Timing Sequence", VR.kSQ, VM.k1, false);
  static const DED kASLBolusCutoffTechnique
      //(0018,925E)
      = const DED("ASLBolusCutoffTechnique", 0x0018925E, "ASL Bolus Cut-off Technique", VR.kLO,
          VM.k1, false);
  static const DED kASLBolusCutoffDelayTime
      //(0018,925F)
      = const DED("ASLBolusCutoffDelayTime", 0x0018925F, "ASL Bolus Cut-off Delay Time", VR.kUL,
          VM.k1, false);
  static const DED kASLSlabSequence
      //(0018,9260)
      = const DED("ASLSlabSequence", 0x00189260, "ASL Slab Sequence", VR.kSQ, VM.k1, false);
  static const DED kChemicalShiftMinimumIntegrationLimitInppm
      //(0018,9295)
      = const DED("ChemicalShiftMinimumIntegrationLimitInppm", 0x00189295,
          "Chemical Shift Minimum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const DED kChemicalShiftMaximumIntegrationLimitInppm
      //(0018,9296)
      = const DED("ChemicalShiftMaximumIntegrationLimitInppm", 0x00189296,
          "Chemical Shift Maximum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const DED kCTAcquisitionTypeSequence
      //(0018,9301)
      = const DED("CTAcquisitionTypeSequence", 0x00189301, "CT Acquisition Type Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAcquisitionType
      //(0018,9302)
      = const DED("AcquisitionType", 0x00189302, "Acquisition Type", VR.kCS, VM.k1, false);
  static const DED kTubeAngle
      //(0018,9303)
      = const DED("TubeAngle", 0x00189303, "Tube Angle", VR.kFD, VM.k1, false);
  static const DED kCTAcquisitionDetailsSequence
      //(0018,9304)
      = const DED("CTAcquisitionDetailsSequence", 0x00189304, "CT Acquisition Details Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRevolutionTime
      //(0018,9305)
      = const DED("RevolutionTime", 0x00189305, "Revolution Time", VR.kFD, VM.k1, false);
  static const DED kSingleCollimationWidth
      //(0018,9306)
      = const DED(
          "SingleCollimationWidth", 0x00189306, "Single Collimation Width", VR.kFD, VM.k1, false);
  static const DED kTotalCollimationWidth
      //(0018,9307)
      = const DED(
          "TotalCollimationWidth", 0x00189307, "Total Collimation Width", VR.kFD, VM.k1, false);
  static const DED kCTTableDynamicsSequence
      //(0018,9308)
      = const DED("CTTableDynamicsSequence", 0x00189308, "CT Table Dynamics Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kTableSpeed
      //(0018,9309)
      = const DED("TableSpeed", 0x00189309, "Table Speed", VR.kFD, VM.k1, false);
  static const DED kTableFeedPerRotation
      //(0018,9310)
      = const DED(
          "TableFeedPerRotation", 0x00189310, "Table Feed per Rotation", VR.kFD, VM.k1, false);
  static const DED kSpiralPitchFactor
      //(0018,9311)
      = const DED("SpiralPitchFactor", 0x00189311, "Spiral Pitch Factor", VR.kFD, VM.k1, false);
  static const DED kCTGeometrySequence
      //(0018,9312)
      =
      const DED("CTGeometrySequence", 0x00189312, "CT Geometry Sequence", VR.kSQ, VM.k1, false);
  static const DED kDataCollectionCenterPatient
      //(0018,9313)
      = const DED("DataCollectionCenterPatient", 0x00189313, "Data Collection Center (Patient)",
          VR.kFD, VM.k3, false);
  static const DED kCTReconstructionSequence
      //(0018,9314)
      = const DED("CTReconstructionSequence", 0x00189314, "CT Reconstruction Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kReconstructionAlgorithm
      //(0018,9315)
      = const DED(
          "ReconstructionAlgorithm", 0x00189315, "Reconstruction Algorithm", VR.kCS, VM.k1, false);
  static const DED kConvolutionKernelGroup
      //(0018,9316)
      = const DED(
          "ConvolutionKernelGroup", 0x00189316, "Convolution Kernel Group", VR.kCS, VM.k1, false);
  static const DED kReconstructionFieldOfView
      //(0018,9317)
      = const DED("ReconstructionFieldOfView", 0x00189317, "Reconstruction Field of View",
          VR.kFD, VM.k2, false);
  static const DED kReconstructionTargetCenterPatient
      //(0018,9318)
      = const DED("ReconstructionTargetCenterPatient", 0x00189318,
          "Reconstruction Target Center (Patient)", VR.kFD, VM.k3, false);
  static const DED kReconstructionAngle
      //(0018,9319)
      = const DED(
          "ReconstructionAngle", 0x00189319, "Reconstruction Angle", VR.kFD, VM.k1, false);
  static const DED kImageFilter
      //(0018,9320)
      = const DED("ImageFilter", 0x00189320, "Image Filter", VR.kSH, VM.k1, false);
  static const DED kCTExposureSequence
      //(0018,9321)
      =
      const DED("CTExposureSequence", 0x00189321, "CT Exposure Sequence", VR.kSQ, VM.k1, false);
  static const DED kReconstructionPixelSpacing
      //(0018,9322)
      = const DED("ReconstructionPixelSpacing", 0x00189322, "Reconstruction Pixel Spacing",
          VR.kFD, VM.k2, false);
  static const DED kExposureModulationType
      //(0018,9323)
      = const DED(
          "ExposureModulationType", 0x00189323, "Exposure Modulation Type", VR.kCS, VM.k1, false);
  static const DED kEstimatedDoseSaving
      //(0018,9324)
      = const DED(
          "EstimatedDoseSaving", 0x00189324, "Estimated Dose Saving", VR.kFD, VM.k1, false);
  static const DED kCTXRayDetailsSequence
      //(0018,9325)
      = const DED(
          "CTXRayDetailsSequence", 0x00189325, "CT X-Ray Details Sequence", VR.kSQ, VM.k1, false);
  static const DED kCTPositionSequence
      //(0018,9326)
      =
      const DED("CTPositionSequence", 0x00189326, "CT Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kTablePosition
      //(0018,9327)
      = const DED("TablePosition", 0x00189327, "Table Position", VR.kFD, VM.k1, false);
  static const DED kExposureTimeInms
      //(0018,9328)
      = const DED("ExposureTimeInms", 0x00189328, "Exposure Time in ms", VR.kFD, VM.k1, false);
  static const DED kCTImageFrameTypeSequence
      //(0018,9329)
      = const DED("CTImageFrameTypeSequence", 0x00189329, "CT Image Frame Type Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kXRayTubeCurrentInmA
      //(0018,9330)
      = const DED(
          "XRayTubeCurrentInmA", 0x00189330, "X-Ray Tube Current in mA", VR.kFD, VM.k1, false);
  static const DED kExposureInmAs
      //(0018,9332)
      = const DED("ExposureInmAs", 0x00189332, "Exposure in mAs", VR.kFD, VM.k1, false);
  static const DED kConstantVolumeFlag
      //(0018,9333)
      =
      const DED("ConstantVolumeFlag", 0x00189333, "Constant Volume Flag", VR.kCS, VM.k1, false);
  static const DED kFluoroscopyFlag
      //(0018,9334)
      = const DED("FluoroscopyFlag", 0x00189334, "Fluoroscopy Flag", VR.kCS, VM.k1, false);
  static const DED kDistanceSourceToDataCollectionCenter
      //(0018,9335)
      = const DED("DistanceSourceToDataCollectionCenter", 0x00189335,
          "Distance Source to Data Collection Center", VR.kFD, VM.k1, false);
  static const DED kContrastBolusAgentNumber
      //(0018,9337)
      = const DED("ContrastBolusAgentNumber", 0x00189337, "Contrast/Bolus Agent Number", VR.kUS,
          VM.k1, false);
  static const DED kContrastBolusIngredientCodeSequence
      //(0018,9338)
      = const DED("ContrastBolusIngredientCodeSequence", 0x00189338,
          "Contrast/Bolus Ingredient Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kContrastAdministrationProfileSequence
      //(0018,9340)
      = const DED("ContrastAdministrationProfileSequence", 0x00189340,
          "Contrast Administration Profile Sequence", VR.kSQ, VM.k1, false);
  static const DED kContrastBolusUsageSequence
      //(0018,9341)
      = const DED("ContrastBolusUsageSequence", 0x00189341, "Contrast/Bolus Usage Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kContrastBolusAgentAdministered
      //(0018,9342)
      = const DED("ContrastBolusAgentAdministered", 0x00189342,
          "Contrast/Bolus Agent Administered", VR.kCS, VM.k1, false);
  static const DED kContrastBolusAgentDetected
      //(0018,9343)
      = const DED("ContrastBolusAgentDetected", 0x00189343, "Contrast/Bolus Agent Detected",
          VR.kCS, VM.k1, false);
  static const DED kContrastBolusAgentPhase
      //(0018,9344)
      = const DED("ContrastBolusAgentPhase", 0x00189344, "Contrast/Bolus Agent Phase", VR.kCS,
          VM.k1, false);
  static const DED kCTDIvol
      //(0018,9345)
      = const DED("CTDIvol", 0x00189345, "CTDIvol", VR.kFD, VM.k1, false);
  static const DED kCTDIPhantomTypeCodeSequence
      //(0018,9346)
      = const DED("CTDIPhantomTypeCodeSequence", 0x00189346, "CTDI Phantom Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCalciumScoringMassFactorPatient
      //(0018,9351)
      = const DED("CalciumScoringMassFactorPatient", 0x00189351,
          "Calcium Scoring Mass Factor Patient", VR.kFL, VM.k1, false);
  static const DED kCalciumScoringMassFactorDevice
      //(0018,9352)
      = const DED("CalciumScoringMassFactorDevice", 0x00189352,
          "Calcium Scoring Mass Factor Device", VR.kFL, VM.k3, false);
  static const DED kEnergyWeightingFactor
      //(0018,9353)
      = const DED(
          "EnergyWeightingFactor", 0x00189353, "Energy Weighting Factor", VR.kFL, VM.k1, false);
  static const DED kCTAdditionalXRaySourceSequence
      //(0018,9360)
      = const DED("CTAdditionalXRaySourceSequence", 0x00189360,
          "CT Additional X-Ray Source Sequence", VR.kSQ, VM.k1, false);
  static const DED kProjectionPixelCalibrationSequence
      //(0018,9401)
      = const DED("ProjectionPixelCalibrationSequence", 0x00189401,
          "Projection Pixel Calibration Sequence", VR.kSQ, VM.k1, false);
  static const DED kDistanceSourceToIsocenter
      //(0018,9402)
      = const DED("DistanceSourceToIsocenter", 0x00189402, "Distance Source to Isocenter",
          VR.kFL, VM.k1, false);
  static const DED kDistanceObjectToTableTop
      //(0018,9403)
      = const DED("DistanceObjectToTableTop", 0x00189403, "Distance Object to Table Top",
          VR.kFL, VM.k1, false);
  static const DED kObjectPixelSpacingInCenterOfBeam
      //(0018,9404)
      = const DED("ObjectPixelSpacingInCenterOfBeam", 0x00189404,
          "Object Pixel Spacing in Center of Beam", VR.kFL, VM.k2, false);
  static const DED kPositionerPositionSequence
      //(0018,9405)
      = const DED("PositionerPositionSequence", 0x00189405, "Positioner Position Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTablePositionSequence
      //(0018,9406)
      = const DED(
          "TablePositionSequence", 0x00189406, "Table Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kCollimatorShapeSequence
      //(0018,9407)
      = const DED(
          "CollimatorShapeSequence", 0x00189407, "Collimator Shape Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlanesInAcquisition
      //(0018,9410)
      = const DED(
          "PlanesInAcquisition", 0x00189410, "Planes in Acquisition", VR.kCS, VM.k1, false);
  static const DED kXAXRFFrameCharacteristicsSequence
      //(0018,9412)
      = const DED("XAXRFFrameCharacteristicsSequence", 0x00189412,
          "XA/XRF Frame Characteristics Sequence", VR.kSQ, VM.k1, false);
  static const DED kFrameAcquisitionSequence
      //(0018,9417)
      = const DED("FrameAcquisitionSequence", 0x00189417, "Frame Acquisition Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kXRayReceptorType
      //(0018,9420)
      = const DED("XRayReceptorType", 0x00189420, "X-Ray Receptor Type", VR.kCS, VM.k1, false);
  static const DED kAcquisitionProtocolName
      //(0018,9423)
      = const DED(
          "AcquisitionProtocolName", 0x00189423, "Acquisition Protocol Name", VR.kLO, VM.k1, false);
  static const DED kAcquisitionProtocolDescription
      //(0018,9424)
      = const DED("AcquisitionProtocolDescription", 0x00189424,
          "Acquisition Protocol Description", VR.kLT, VM.k1, false);
  static const DED kContrastBolusIngredientOpaque
      //(0018,9425)
      = const DED("ContrastBolusIngredientOpaque", 0x00189425,
          "Contrast/Bolus Ingredient Opaque", VR.kCS, VM.k1, false);
  static const DED kDistanceReceptorPlaneToDetectorHousing
      //(0018,9426)
      = const DED("DistanceReceptorPlaneToDetectorHousing", 0x00189426,
          "Distance Receptor Plane to Detector Housing", VR.kFL, VM.k1, false);
  static const DED kIntensifierActiveShape
      //(0018,9427)
      = const DED(
          "IntensifierActiveShape", 0x00189427, "Intensifier Active Shape", VR.kCS, VM.k1, false);
  static const DED kIntensifierActiveDimensions
      //(0018,9428)
      = const DED("IntensifierActiveDimensions", 0x00189428, "Intensifier Active Dimension(s)",
          VR.kFL, VM.k1_2, false);
  static const DED kPhysicalDetectorSize
      //(0018,9429)
      = const DED(
          "PhysicalDetectorSize", 0x00189429, "Physical Detector Size", VR.kFL, VM.k2, false);
  static const DED kPositionOfIsocenterProjection
      //(0018,9430)
      = const DED("PositionOfIsocenterProjection", 0x00189430,
          "Position of Isocenter Projection", VR.kFL, VM.k2, false);
  static const DED kFieldOfViewSequence
      //(0018,9432)
      = const DED(
          "FieldOfViewSequence", 0x00189432, "Field of View Sequence", VR.kSQ, VM.k1, false);
  static const DED kFieldOfViewDescription
      //(0018,9433)
      = const DED(
          "FieldOfViewDescription", 0x00189433, "Field of View Description", VR.kLO, VM.k1, false);
  static const DED kExposureControlSensingRegionsSequence
      //(0018,9434)
      = const DED("ExposureControlSensingRegionsSequence", 0x00189434,
          "Exposure Control Sensing Regions Sequence", VR.kSQ, VM.k1, false);
  static const DED kExposureControlSensingRegionShape
      //(0018,9435)
      = const DED("ExposureControlSensingRegionShape", 0x00189435,
          "Exposure Control Sensing Region Shape", VR.kCS, VM.k1, false);
  static const DED kExposureControlSensingRegionLeftVerticalEdge
      //(0018,9436)
      = const DED("ExposureControlSensingRegionLeftVerticalEdge", 0x00189436,
          "Exposure Control Sensing Region Left Vertical Edge", VR.kSS, VM.k1, false);
  static const DED kExposureControlSensingRegionRightVerticalEdge
      //(0018,9437)
      = const DED("ExposureControlSensingRegionRightVerticalEdge", 0x00189437,
          "Exposure Control Sensing Region Right Vertical Edge", VR.kSS, VM.k1, false);
  static const DED kExposureControlSensingRegionUpperHorizontalEdge
      //(0018,9438)
      = const DED("ExposureControlSensingRegionUpperHorizontalEdge", 0x00189438,
          "Exposure Control Sensing Region Upper Horizontal Edge", VR.kSS, VM.k1, false);
  static const DED kExposureControlSensingRegionLowerHorizontalEdge
      //(0018,9439)
      = const DED("ExposureControlSensingRegionLowerHorizontalEdge", 0x00189439,
          "Exposure Control Sensing Region Lower Horizontal Edge", VR.kSS, VM.k1, false);
  static const DED kCenterOfCircularExposureControlSensingRegion
      //(0018,9440)
      = const DED("CenterOfCircularExposureControlSensingRegion", 0x00189440,
          "Center of Circular Exposure Control Sensing Region", VR.kSS, VM.k2, false);
  static const DED kRadiusOfCircularExposureControlSensingRegion
      //(0018,9441)
      = const DED("RadiusOfCircularExposureControlSensingRegion", 0x00189441,
          "Radius of Circular Exposure Control Sensing Region", VR.kUS, VM.k1, false);
  static const DED kVerticesOfThePolygonalExposureControlSensingRegion
      //(0018,9442)
      = const DED("VerticesOfThePolygonalExposureControlSensingRegion", 0x00189442,
          "Vertices of the Polygonal Exposure Control Sensing Region", VR.kSS, VM.k2_n, false);
  static const DED kNoName0
      //(0018,9445)
      = const DED("NoName0", 0x00189445, "See Note 3", VR.kNoVR, VM.kNoVM, true);
  static const DED kColumnAngulationPatient
      //(0018,9447)
      = const DED("ColumnAngulationPatient", 0x00189447, "Column Angulation (Patient)", VR.kFL,
          VM.k1, false);
  static const DED kBeamAngle
      //(0018,9449)
      = const DED("BeamAngle", 0x00189449, "Beam Angle", VR.kFL, VM.k1, false);
  static const DED kFrameDetectorParametersSequence
      //(0018,9451)
      = const DED("FrameDetectorParametersSequence", 0x00189451,
          "Frame Detector Parameters Sequence", VR.kSQ, VM.k1, false);
  static const DED kCalculatedAnatomyThickness
      //(0018,9452)
      = const DED("CalculatedAnatomyThickness", 0x00189452, "Calculated Anatomy Thickness",
          VR.kFL, VM.k1, false);
  static const DED kCalibrationSequence
      //(0018,9455)
      = const DED(
          "CalibrationSequence", 0x00189455, "Calibration Sequence", VR.kSQ, VM.k1, false);
  static const DED kObjectThicknessSequence
      //(0018,9456)
      = const DED(
          "ObjectThicknessSequence", 0x00189456, "Object Thickness Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlaneIdentification
      //(0018,9457)
      = const DED(
          "PlaneIdentification", 0x00189457, "Plane Identification", VR.kCS, VM.k1, false);
  static const DED kFieldOfViewDimensionsInFloat
      //(0018,9461)
      = const DED("FieldOfViewDimensionsInFloat", 0x00189461,
          "Field of View Dimension(s) in Float", VR.kFL, VM.k1_2, false);
  static const DED kIsocenterReferenceSystemSequence
      //(0018,9462)
      = const DED("IsocenterReferenceSystemSequence", 0x00189462,
          "Isocenter Reference System Sequence", VR.kSQ, VM.k1, false);
  static const DED kPositionerIsocenterPrimaryAngle
      //(0018,9463)
      = const DED("PositionerIsocenterPrimaryAngle", 0x00189463,
          "Positioner Isocenter Primary Angle", VR.kFL, VM.k1, false);
  static const DED kPositionerIsocenterSecondaryAngle
      //(0018,9464)
      = const DED("PositionerIsocenterSecondaryAngle", 0x00189464,
          "Positioner Isocenter Secondary Angle", VR.kFL, VM.k1, false);
  static const DED kPositionerIsocenterDetectorRotationAngle
      //(0018,9465)
      = const DED("PositionerIsocenterDetectorRotationAngle", 0x00189465,
          "Positioner Isocenter Detector Rotation Angle", VR.kFL, VM.k1, false);
  static const DED kTableXPositionToIsocenter
      //(0018,9466)
      = const DED("TableXPositionToIsocenter", 0x00189466, "Table X Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const DED kTableYPositionToIsocenter
      //(0018,9467)
      = const DED("TableYPositionToIsocenter", 0x00189467, "Table Y Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const DED kTableZPositionToIsocenter
      //(0018,9468)
      = const DED("TableZPositionToIsocenter", 0x00189468, "Table Z Position to Isocenter",
          VR.kFL, VM.k1, false);
  static const DED kTableHorizontalRotationAngle
      //(0018,9469)
      = const DED("TableHorizontalRotationAngle", 0x00189469, "Table Horizontal Rotation Angle",
          VR.kFL, VM.k1, false);
  static const DED kTableHeadTiltAngle
      //(0018,9470)
      = const DED(
          "TableHeadTiltAngle", 0x00189470, "Table Head Tilt Angle", VR.kFL, VM.k1, false);
  static const DED kTableCradleTiltAngle
      //(0018,9471)
      = const DED(
          "TableCradleTiltAngle", 0x00189471, "Table Cradle Tilt Angle", VR.kFL, VM.k1, false);
  static const DED kFrameDisplayShutterSequence
      //(0018,9472)
      = const DED("FrameDisplayShutterSequence", 0x00189472, "Frame Display Shutter Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAcquiredImageAreaDoseProduct
      //(0018,9473)
      = const DED("AcquiredImageAreaDoseProduct", 0x00189473,
          "Acquired Image Area Dose Product", VR.kFL, VM.k1, false);
  static const DED kCArmPositionerTabletopRelationship
      //(0018,9474)
      = const DED("CArmPositionerTabletopRelationship", 0x00189474,
          "C-arm Positioner Tabletop Relationship", VR.kCS, VM.k1, false);
  static const DED kXRayGeometrySequence
      //(0018,9476)
      = const DED(
          "XRayGeometrySequence", 0x00189476, "X-Ray Geometry Sequence", VR.kSQ, VM.k1, false);
  static const DED kIrradiationEventIdentificationSequence
      //(0018,9477)
      = const DED("IrradiationEventIdentificationSequence", 0x00189477,
          "Irradiation Event Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kXRay3DFrameTypeSequence
      //(0018,9504)
      = const DED("XRay3DFrameTypeSequence", 0x00189504, "X-Ray 3D Frame Type Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kContributingSourcesSequence
      //(0018,9506)
      = const DED("ContributingSourcesSequence", 0x00189506, "Contributing Sources Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kXRay3DAcquisitionSequence
      //(0018,9507)
      = const DED("XRay3DAcquisitionSequence", 0x00189507, "X-Ray 3D Acquisition Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPrimaryPositionerScanArc
      //(0018,9508)
      = const DED("PrimaryPositionerScanArc", 0x00189508, "Primary Positioner Scan Arc", VR.kFL,
          VM.k1, false);
  static const DED kSecondaryPositionerScanArc
      //(0018,9509)
      = const DED("SecondaryPositionerScanArc", 0x00189509, "Secondary Positioner Scan Arc",
          VR.kFL, VM.k1, false);
  static const DED kPrimaryPositionerScanStartAngle
      //(0018,9510)
      = const DED("PrimaryPositionerScanStartAngle", 0x00189510,
          "Primary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const DED kSecondaryPositionerScanStartAngle
      //(0018,9511)
      = const DED("SecondaryPositionerScanStartAngle", 0x00189511,
          "Secondary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const DED kPrimaryPositionerIncrement
      //(0018,9514)
      = const DED("PrimaryPositionerIncrement", 0x00189514, "Primary Positioner Increment",
          VR.kFL, VM.k1, false);
  static const DED kSecondaryPositionerIncrement
      //(0018,9515)
      = const DED("SecondaryPositionerIncrement", 0x00189515, "Secondary Positioner Increment",
          VR.kFL, VM.k1, false);
  static const DED kStartAcquisitionDateTime
      //(0018,9516)
      = const DED("StartAcquisitionDateTime", 0x00189516, "Start Acquisition DateTime", VR.kDT,
          VM.k1, false);
  static const DED kEndAcquisitionDateTime
      //(0018,9517)
      = const DED(
          "EndAcquisitionDateTime", 0x00189517, "End Acquisition DateTime", VR.kDT, VM.k1, false);
  static const DED kApplicationName
      //(0018,9524)
      = const DED("ApplicationName", 0x00189524, "Application Name", VR.kLO, VM.k1, false);
  static const DED kApplicationVersion
      //(0018,9525)
      =
      const DED("ApplicationVersion", 0x00189525, "Application Version", VR.kLO, VM.k1, false);
  static const DED kApplicationManufacturer
      //(0018,9526)
      = const DED(
          "ApplicationManufacturer", 0x00189526, "Application Manufacturer", VR.kLO, VM.k1, false);
  static const DED kAlgorithmType
      //(0018,9527)
      = const DED("AlgorithmType", 0x00189527, "Algorithm Type", VR.kCS, VM.k1, false);
  static const DED kAlgorithmDescription
      //(0018,9528)
      = const DED(
          "AlgorithmDescription", 0x00189528, "Algorithm Description", VR.kLO, VM.k1, false);
  static const DED kXRay3DReconstructionSequence
      //(0018,9530)
      = const DED("XRay3DReconstructionSequence", 0x00189530,
          "X-Ray 3D Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const DED kReconstructionDescription
      //(0018,9531)
      = const DED("ReconstructionDescription", 0x00189531, "Reconstruction Description", VR.kLO,
          VM.k1, false);
  static const DED kPerProjectionAcquisitionSequence
      //(0018,9538)
      = const DED("PerProjectionAcquisitionSequence", 0x00189538,
          "Per Projection Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const DED kDiffusionBMatrixSequence
      //(0018,9601)
      = const DED("DiffusionBMatrixSequence", 0x00189601, "Diffusion b-matrix Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kDiffusionBValueXX
      //(0018,9602)
      =
      const DED("DiffusionBValueXX", 0x00189602, "Diffusion b-value XX", VR.kFD, VM.k1, false);
  static const DED kDiffusionBValueXY
      //(0018,9603)
      =
      const DED("DiffusionBValueXY", 0x00189603, "Diffusion b-value XY", VR.kFD, VM.k1, false);
  static const DED kDiffusionBValueXZ
      //(0018,9604)
      =
      const DED("DiffusionBValueXZ", 0x00189604, "Diffusion b-value XZ", VR.kFD, VM.k1, false);
  static const DED kDiffusionBValueYY
      //(0018,9605)
      =
      const DED("DiffusionBValueYY", 0x00189605, "Diffusion b-value YY", VR.kFD, VM.k1, false);
  static const DED kDiffusionBValueYZ
      //(0018,9606)
      =
      const DED("DiffusionBValueYZ", 0x00189606, "Diffusion b-value YZ", VR.kFD, VM.k1, false);
  static const DED kDiffusionBValueZZ
      //(0018,9607)
      =
      const DED("DiffusionBValueZZ", 0x00189607, "Diffusion b-value ZZ", VR.kFD, VM.k1, false);
  static const DED kDecayCorrectionDateTime
      //(0018,9701)
      = const DED(
          "DecayCorrectionDateTime", 0x00189701, "Decay Correction DateTime", VR.kDT, VM.k1, false);
  static const DED kStartDensityThreshold
      //(0018,9715)
      = const DED(
          "StartDensityThreshold", 0x00189715, "Start Density Threshold", VR.kFD, VM.k1, false);
  static const DED kStartRelativeDensityDifferenceThreshold
      //(0018,9716)
      = const DED("StartRelativeDensityDifferenceThreshold", 0x00189716,
          "Start Relative Density Difference Threshold", VR.kFD, VM.k1, false);
  static const DED kStartCardiacTriggerCountThreshold
      //(0018,9717)
      = const DED("StartCardiacTriggerCountThreshold", 0x00189717,
          "Start Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const DED kStartRespiratoryTriggerCountThreshold
      //(0018,9718)
      = const DED("StartRespiratoryTriggerCountThreshold", 0x00189718,
          "Start Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const DED kTerminationCountsThreshold
      //(0018,9719)
      = const DED("TerminationCountsThreshold", 0x00189719, "Termination Counts Threshold",
          VR.kFD, VM.k1, false);
  static const DED kTerminationDensityThreshold
      //(0018,9720)
      = const DED("TerminationDensityThreshold", 0x00189720, "Termination Density Threshold",
          VR.kFD, VM.k1, false);
  static const DED kTerminationRelativeDensityThreshold
      //(0018,9721)
      = const DED("TerminationRelativeDensityThreshold", 0x00189721,
          "Termination Relative Density Threshold", VR.kFD, VM.k1, false);
  static const DED kTerminationTimeThreshold
      //(0018,9722)
      = const DED("TerminationTimeThreshold", 0x00189722, "Termination Time Threshold", VR.kFD,
          VM.k1, false);
  static const DED kTerminationCardiacTriggerCountThreshold
      //(0018,9723)
      = const DED("TerminationCardiacTriggerCountThreshold", 0x00189723,
          "Termination Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const DED kTerminationRespiratoryTriggerCountThreshold
      //(0018,9724)
      = const DED("TerminationRespiratoryTriggerCountThreshold", 0x00189724,
          "Termination Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const DED kDetectorGeometry
      //(0018,9725)
      = const DED("DetectorGeometry", 0x00189725, "Detector Geometry", VR.kCS, VM.k1, false);
  static const DED kTransverseDetectorSeparation
      //(0018,9726)
      = const DED("TransverseDetectorSeparation", 0x00189726, "Transverse Detector Separation",
          VR.kFD, VM.k1, false);
  static const DED kAxialDetectorDimension
      //(0018,9727)
      = const DED(
          "AxialDetectorDimension", 0x00189727, "Axial Detector Dimension", VR.kFD, VM.k1, false);
  static const DED kRadiopharmaceuticalAgentNumber
      //(0018,9729)
      = const DED("RadiopharmaceuticalAgentNumber", 0x00189729,
          "Radiopharmaceutical Agent Number", VR.kUS, VM.k1, false);
  static const DED kPETFrameAcquisitionSequence
      //(0018,9732)
      = const DED("PETFrameAcquisitionSequence", 0x00189732, "PET Frame Acquisition Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPETDetectorMotionDetailsSequence
      //(0018,9733)
      = const DED("PETDetectorMotionDetailsSequence", 0x00189733,
          "PET Detector Motion Details Sequence", VR.kSQ, VM.k1, false);
  static const DED kPETTableDynamicsSequence
      //(0018,9734)
      = const DED("PETTableDynamicsSequence", 0x00189734, "PET Table Dynamics Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kPETPositionSequence
      //(0018,9735)
      = const DED(
          "PETPositionSequence", 0x00189735, "PET Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kPETFrameCorrectionFactorsSequence
      //(0018,9736)
      = const DED("PETFrameCorrectionFactorsSequence", 0x00189736,
          "PET Frame Correction Factors Sequence", VR.kSQ, VM.k1, false);
  static const DED kRadiopharmaceuticalUsageSequence
      //(0018,9737)
      = const DED("RadiopharmaceuticalUsageSequence", 0x00189737,
          "Radiopharmaceutical Usage Sequence", VR.kSQ, VM.k1, false);
  static const DED kAttenuationCorrectionSource
      //(0018,9738)
      = const DED("AttenuationCorrectionSource", 0x00189738, "Attenuation Correction Source",
          VR.kCS, VM.k1, false);
  static const DED kNumberOfIterations
      //(0018,9739)
      =
      const DED("NumberOfIterations", 0x00189739, "Number of Iterations", VR.kUS, VM.k1, false);
  static const DED kNumberOfSubsets
      //(0018,9740)
      = const DED("NumberOfSubsets", 0x00189740, "Number of Subsets", VR.kUS, VM.k1, false);
  static const DED kPETReconstructionSequence
      //(0018,9749)
      = const DED("PETReconstructionSequence", 0x00189749, "PET Reconstruction Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPETFrameTypeSequence
      //(0018,9751)
      = const DED(
          "PETFrameTypeSequence", 0x00189751, "PET Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const DED kTimeOfFlightInformationUsed
      //(0018,9755)
      = const DED("TimeOfFlightInformationUsed", 0x00189755, "Time of Flight Information Used",
          VR.kCS, VM.k1, false);
  static const DED kReconstructionType
      //(0018,9756)
      =
      const DED("ReconstructionType", 0x00189756, "Reconstruction Type", VR.kCS, VM.k1, false);
  static const DED kDecayCorrected
      //(0018,9758)
      = const DED("DecayCorrected", 0x00189758, "Decay Corrected", VR.kCS, VM.k1, false);
  static const DED kAttenuationCorrected
      //(0018,9759)
      = const DED(
          "AttenuationCorrected", 0x00189759, "Attenuation Corrected", VR.kCS, VM.k1, false);
  static const DED kScatterCorrected
      //(0018,9760)
      = const DED("ScatterCorrected", 0x00189760, "Scatter Corrected", VR.kCS, VM.k1, false);
  static const DED kDeadTimeCorrected
      //(0018,9761)
      = const DED("DeadTimeCorrected", 0x00189761, "Dead Time Corrected", VR.kCS, VM.k1, false);
  static const DED kGantryMotionCorrected
      //(0018,9762)
      = const DED(
          "GantryMotionCorrected", 0x00189762, "Gantry Motion Corrected", VR.kCS, VM.k1, false);
  static const DED kPatientMotionCorrected
      //(0018,9763)
      = const DED(
          "PatientMotionCorrected", 0x00189763, "Patient Motion Corrected", VR.kCS, VM.k1, false);
  static const DED kCountLossNormalizationCorrected
      //(0018,9764)
      = const DED("CountLossNormalizationCorrected", 0x00189764,
          "Count Loss Normalization Corrected", VR.kCS, VM.k1, false);
  static const DED kRandomsCorrected
      //(0018,9765)
      = const DED("RandomsCorrected", 0x00189765, "Randoms Corrected", VR.kCS, VM.k1, false);
  static const DED kNonUniformRadialSamplingCorrected
      //(0018,9766)
      = const DED("NonUniformRadialSamplingCorrected", 0x00189766,
          "Non-uniform Radial Sampling Corrected", VR.kCS, VM.k1, false);
  static const DED kSensitivityCalibrated
      //(0018,9767)
      = const DED(
          "SensitivityCalibrated", 0x00189767, "Sensitivity Calibrated", VR.kCS, VM.k1, false);
  static const DED kDetectorNormalizationCorrection
      //(0018,9768)
      = const DED("DetectorNormalizationCorrection", 0x00189768,
          "Detector Normalization Correction", VR.kCS, VM.k1, false);
  static const DED kIterativeReconstructionMethod
      //(0018,9769)
      = const DED("IterativeReconstructionMethod", 0x00189769,
          "Iterative Reconstruction Method", VR.kCS, VM.k1, false);
  static const DED kAttenuationCorrectionTemporalRelationship
      //(0018,9770)
      = const DED("AttenuationCorrectionTemporalRelationship", 0x00189770,
          "Attenuation Correction Temporal Relationship", VR.kCS, VM.k1, false);
  static const DED kPatientPhysiologicalStateSequence
      //(0018,9771)
      = const DED("PatientPhysiologicalStateSequence", 0x00189771,
          "Patient Physiological State Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientPhysiologicalStateCodeSequence
      //(0018,9772)
      = const DED("PatientPhysiologicalStateCodeSequence", 0x00189772,
          "Patient Physiological State Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kDepthsOfFocus
      //(0018,9801)
      = const DED("DepthsOfFocus", 0x00189801, "Depth(s) of Focus", VR.kFD, VM.k1_n, false);
  static const DED kExcludedIntervalsSequence
      //(0018,9803)
      = const DED("ExcludedIntervalsSequence", 0x00189803, "Excluded Intervals Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kExclusionStartDateTime
      //(0018,9804)
      = const DED(
          "ExclusionStartDateTime", 0x00189804, "Exclusion Start DateTime", VR.kDT, VM.k1, false);
  static const DED kExclusionDuration
      //(0018,9805)
      = const DED("ExclusionDuration", 0x00189805, "Exclusion Duration", VR.kFD, VM.k1, false);
  static const DED kUSImageDescriptionSequence
      //(0018,9806)
      = const DED("USImageDescriptionSequence", 0x00189806, "US Image Description Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImageDataTypeSequence
      //(0018,9807)
      = const DED(
          "ImageDataTypeSequence", 0x00189807, "Image Data Type Sequence", VR.kSQ, VM.k1, false);
  static const DED kDataType
      //(0018,9808)
      = const DED("DataType", 0x00189808, "Data Type", VR.kCS, VM.k1, false);
  static const DED kTransducerScanPatternCodeSequence
      //(0018,9809)
      = const DED("TransducerScanPatternCodeSequence", 0x00189809,
          "Transducer Scan Pattern Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kAliasedDataType
      //(0018,980B)
      = const DED("AliasedDataType", 0x0018980B, "Aliased Data Type", VR.kCS, VM.k1, false);
  static const DED kPositionMeasuringDeviceUsed
      //(0018,980C)
      = const DED("PositionMeasuringDeviceUsed", 0x0018980C, "Position Measuring Device Used",
          VR.kCS, VM.k1, false);
  static const DED kTransducerGeometryCodeSequence
      //(0018,980D)
      = const DED("TransducerGeometryCodeSequence", 0x0018980D,
          "Transducer Geometry Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kTransducerBeamSteeringCodeSequence
      //(0018,980E)
      = const DED("TransducerBeamSteeringCodeSequence", 0x0018980E,
          "Transducer Beam Steering Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kTransducerApplicationCodeSequence
      //(0018,980F)
      = const DED("TransducerApplicationCodeSequence", 0x0018980F,
          "Transducer Application Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kZeroVelocityPixelValue
      //(0018,9810)
      = const DED("ZeroVelocityPixelValue", 0x00189810, "Zero Velocity Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const DED kContributingEquipmentSequence
      //(0018,A001)
      = const DED("ContributingEquipmentSequence", 0x0018A001,
          "Contributing Equipment Sequence", VR.kSQ, VM.k1, false);
  static const DED kContributionDateTime
      //(0018,A002)
      = const DED(
          "ContributionDateTime", 0x0018A002, "Contribution DateTime", VR.kDT, VM.k1, false);
  static const DED kContributionDescription
      //(0018,A003)
      = const DED(
          "ContributionDescription", 0x0018A003, "Contribution Description", VR.kST, VM.k1, false);
  static const DED kStudyInstanceUID
      //(0020,000D)
      = const DED("StudyInstanceUID", 0x0020000D, "Study Instance UID", VR.kUI, VM.k1, false);
  static const DED kSeriesInstanceUID
      //(0020,000E)
      = const DED("SeriesInstanceUID", 0x0020000E, "Series Instance UID", VR.kUI, VM.k1, false);
  static const DED kStudyID
      //(0020,0010)
      = const DED("StudyID", 0x00200010, "Study ID", VR.kSH, VM.k1, false);
  static const DED kSeriesNumber
      //(0020,0011)
      = const DED("SeriesNumber", 0x00200011, "Series Number", VR.kIS, VM.k1, false);
  static const DED kAcquisitionNumber
      //(0020,0012)
      = const DED("AcquisitionNumber", 0x00200012, "Acquisition Number", VR.kIS, VM.k1, false);
  static const DED kInstanceNumber
      //(0020,0013)
      = const DED("InstanceNumber", 0x00200013, "Instance Number", VR.kIS, VM.k1, false);
  static const DED kIsotopeNumber
      //(0020,0014)
      = const DED("IsotopeNumber", 0x00200014, "Isotope Number", VR.kIS, VM.k1, true);
  static const DED kPhaseNumber
      //(0020,0015)
      = const DED("PhaseNumber", 0x00200015, "Phase Number", VR.kIS, VM.k1, true);
  static const DED kIntervalNumber
      //(0020,0016)
      = const DED("IntervalNumber", 0x00200016, "Interval Number", VR.kIS, VM.k1, true);
  static const DED kTimeSlotNumber
      //(0020,0017)
      = const DED("TimeSlotNumber", 0x00200017, "Time Slot Number", VR.kIS, VM.k1, true);
  static const DED kAngleNumber
      //(0020,0018)
      = const DED("AngleNumber", 0x00200018, "Angle Number", VR.kIS, VM.k1, true);
  static const DED kItemNumber
      //(0020,0019)
      = const DED("ItemNumber", 0x00200019, "Item Number", VR.kIS, VM.k1, false);
  static const DED kPatientOrientation
      //(0020,0020)
      =
      const DED("PatientOrientation", 0x00200020, "Patient Orientation", VR.kCS, VM.k2, false);
  static const DED kOverlayNumber
      //(0020,0022)
      = const DED("OverlayNumber", 0x00200022, "Overlay Number", VR.kIS, VM.k1, true);
  static const DED kCurveNumber
      //(0020,0024)
      = const DED("CurveNumber", 0x00200024, "Curve Number", VR.kIS, VM.k1, true);
  static const DED kLUTNumber
      //(0020,0026)
      = const DED("LUTNumber", 0x00200026, "LUT Number", VR.kIS, VM.k1, true);
  static const DED kImagePosition
      //(0020,0030)
      = const DED("ImagePosition", 0x00200030, "Image Position", VR.kDS, VM.k3, true);
  static const DED kImagePositionPatient
      //(0020,0032)
      = const DED(
          "ImagePositionPatient", 0x00200032, "Image Position (Patient)", VR.kDS, VM.k3, false);
  static const DED kImageOrientation
      //(0020,0035)
      = const DED("ImageOrientation", 0x00200035, "Image Orientation", VR.kDS, VM.k6, true);
  static const DED kImageOrientationPatient
      //(0020,0037)
      = const DED("ImageOrientationPatient", 0x00200037, "Image Orientation (Patient)", VR.kDS,
          VM.k6, false);
  static const DED kLocation
      //(0020,0050)
      = const DED("Location", 0x00200050, "Location", VR.kDS, VM.k1, true);
  static const DED kFrameOfReferenceUID
      //(0020,0052)
      = const DED(
          "FrameOfReferenceUID", 0x00200052, "Frame of Reference UID", VR.kUI, VM.k1, false);
  static const DED kLaterality
      //(0020,0060)
      = const DED("Laterality", 0x00200060, "Laterality", VR.kCS, VM.k1, false);
  static const DED kImageLaterality
      //(0020,0062)
      = const DED("ImageLaterality", 0x00200062, "Image Laterality", VR.kCS, VM.k1, false);
  static const DED kImageGeometryType
      //(0020,0070)
      = const DED("ImageGeometryType", 0x00200070, "Image Geometry Type", VR.kLO, VM.k1, true);
  static const DED kMaskingImage
      //(0020,0080)
      = const DED("MaskingImage", 0x00200080, "Masking Image", VR.kCS, VM.k1_n, true);
  static const DED kReportNumber
      //(0020,00AA)
      = const DED("ReportNumber", 0x002000AA, "Report Number", VR.kIS, VM.k1, true);
  static const DED kTemporalPositionIdentifier
      //(0020,0100)
      = const DED("TemporalPositionIdentifier", 0x00200100, "Temporal Position Identifier",
          VR.kIS, VM.k1, false);
  static const DED kNumberOfTemporalPositions
      //(0020,0105)
      = const DED("NumberOfTemporalPositions", 0x00200105, "Number of Temporal Positions",
          VR.kIS, VM.k1, false);
  static const DED kTemporalResolution
      //(0020,0110)
      =
      const DED("TemporalResolution", 0x00200110, "Temporal Resolution", VR.kDS, VM.k1, false);
  static const DED kSynchronizationFrameOfReferenceUID
      //(0020,0200)
      = const DED("SynchronizationFrameOfReferenceUID", 0x00200200,
          "Synchronization Frame of Reference UID", VR.kUI, VM.k1, false);
  static const DED kSOPInstanceUIDOfConcatenationSource
      //(0020,0242)
      = const DED("SOPInstanceUIDOfConcatenationSource", 0x00200242,
          "SOP Instance UID of Concatenation Source", VR.kUI, VM.k1, false);
  static const DED kSeriesInStudy
      //(0020,1000)
      = const DED("SeriesInStudy", 0x00201000, "Series in Study", VR.kIS, VM.k1, true);
  static const DED kAcquisitionsInSeries
      //(0020,1001)
      = const DED(
          "AcquisitionsInSeries", 0x00201001, "Acquisitions in Series", VR.kIS, VM.k1, true);
  static const DED kImagesInAcquisition
      //(0020,1002)
      = const DED(
          "ImagesInAcquisition", 0x00201002, "Images in Acquisition", VR.kIS, VM.k1, false);
  static const DED kImagesInSeries
      //(0020,1003)
      = const DED("ImagesInSeries", 0x00201003, "Images in Series", VR.kIS, VM.k1, true);
  static const DED kAcquisitionsInStudy
      //(0020,1004)
      = const DED(
          "AcquisitionsInStudy", 0x00201004, "Acquisitions in Study", VR.kIS, VM.k1, true);
  static const DED kImagesInStudy
      //(0020,1005)
      = const DED("ImagesInStudy", 0x00201005, "Images in Study", VR.kIS, VM.k1, true);
  static const DED kReference
      //(0020,1020)
      = const DED("Reference", 0x00201020, "Reference", VR.kLO, VM.k1_n, true);
  static const DED kPositionReferenceIndicator
      //(0020,1040)
      = const DED("PositionReferenceIndicator", 0x00201040, "Position Reference Indicator",
          VR.kLO, VM.k1, false);
  static const DED kSliceLocation
      //(0020,1041)
      = const DED("SliceLocation", 0x00201041, "Slice Location", VR.kDS, VM.k1, false);
  static const DED kOtherStudyNumbers
      //(0020,1070)
      =
      const DED("OtherStudyNumbers", 0x00201070, "Other Study Numbers", VR.kIS, VM.k1_n, true);
  static const DED kNumberOfPatientRelatedStudies
      //(0020,1200)
      = const DED("NumberOfPatientRelatedStudies", 0x00201200,
          "Number of Patient Related Studies", VR.kIS, VM.k1, false);
  static const DED kNumberOfPatientRelatedSeries
      //(0020,1202)
      = const DED("NumberOfPatientRelatedSeries", 0x00201202,
          "Number of Patient Related Series", VR.kIS, VM.k1, false);
  static const DED kNumberOfPatientRelatedInstances
      //(0020,1204)
      = const DED("NumberOfPatientRelatedInstances", 0x00201204,
          "Number of Patient Related Instances", VR.kIS, VM.k1, false);
  static const DED kNumberOfStudyRelatedSeries
      //(0020,1206)
      = const DED("NumberOfStudyRelatedSeries", 0x00201206, "Number of Study Related Series",
          VR.kIS, VM.k1, false);
  static const DED kNumberOfStudyRelatedInstances
      //(0020,1208)
      = const DED("NumberOfStudyRelatedInstances", 0x00201208,
          "Number of Study Related Instances", VR.kIS, VM.k1, false);
  static const DED kNumberOfSeriesRelatedInstances
      //(0020,1209)
      = const DED("NumberOfSeriesRelatedInstances", 0x00201209,
          "Number of Series Related Instances", VR.kIS, VM.k1, false);
  static const DED kSourceImageIDs
      //(0020,3100)
      = const DED("SourceImageIDs", 0x00203100, "Source Image IDs", VR.kCS, VM.k1_n, true);
  static const DED kModifyingDeviceID
      //(0020,3401)
      = const DED("ModifyingDeviceID", 0x00203401, "Modifying Device ID", VR.kCS, VM.k1, true);
  static const DED kModifiedImageID
      //(0020,3402)
      = const DED("ModifiedImageID", 0x00203402, "Modified Image ID", VR.kCS, VM.k1, true);
  static const DED kModifiedImageDate
      //(0020,3403)
      = const DED("ModifiedImageDate", 0x00203403, "Modified Image Date", VR.kDA, VM.k1, true);
  static const DED kModifyingDeviceManufacturer
      //(0020,3404)
      = const DED("ModifyingDeviceManufacturer", 0x00203404, "Modifying Device Manufacturer",
          VR.kLO, VM.k1, true);
  static const DED kModifiedImageTime
      //(0020,3405)
      = const DED("ModifiedImageTime", 0x00203405, "Modified Image Time", VR.kTM, VM.k1, true);
  static const DED kModifiedImageDescription
      //(0020,3406)
      = const DED("ModifiedImageDescription", 0x00203406, "Modified Image Description", VR.kLO,
          VM.k1, true);
  static const DED kImageComments
      //(0020,4000)
      = const DED("ImageComments", 0x00204000, "Image Comments", VR.kLT, VM.k1, false);
  static const DED kOriginalImageIdentification
      //(0020,5000)
      = const DED("OriginalImageIdentification", 0x00205000, "Original Image Identification",
          VR.kAT, VM.k1_n, true);
  static const DED kOriginalImageIdentificationNomenclature
      //(0020,5002)
      = const DED("OriginalImageIdentificationNomenclature", 0x00205002,
          "Original Image Identification Nomenclature", VR.kLO, VM.k1_n, true);
  static const DED kStackID
      //(0020,9056)
      = const DED("StackID", 0x00209056, "Stack ID", VR.kSH, VM.k1, false);
  static const DED kInStackPositionNumber
      //(0020,9057)
      = const DED(
          "InStackPositionNumber", 0x00209057, "In-Stack Position Number", VR.kUL, VM.k1, false);
  static const DED kFrameAnatomySequence
      //(0020,9071)
      = const DED(
          "FrameAnatomySequence", 0x00209071, "Frame Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const DED kFrameLaterality
      //(0020,9072)
      = const DED("FrameLaterality", 0x00209072, "Frame Laterality", VR.kCS, VM.k1, false);
  static const DED kFrameContentSequence
      //(0020,9111)
      = const DED(
          "FrameContentSequence", 0x00209111, "Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlanePositionSequence
      //(0020,9113)
      = const DED(
          "PlanePositionSequence", 0x00209113, "Plane Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlaneOrientationSequence
      //(0020,9116)
      = const DED("PlaneOrientationSequence", 0x00209116, "Plane Orientation Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kTemporalPositionIndex
      //(0020,9128)
      = const DED(
          "TemporalPositionIndex", 0x00209128, "Temporal Position Index", VR.kUL, VM.k1, false);
  static const DED kNominalCardiacTriggerDelayTime
      //(0020,9153)
      = const DED("NominalCardiacTriggerDelayTime", 0x00209153,
          "Nominal Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const DED kNominalCardiacTriggerTimePriorToRPeak
      //(0020,9154)
      = const DED("NominalCardiacTriggerTimePriorToRPeak", 0x00209154,
          "Nominal Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const DED kActualCardiacTriggerTimePriorToRPeak
      //(0020,9155)
      = const DED("ActualCardiacTriggerTimePriorToRPeak", 0x00209155,
          "Actual Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const DED kFrameAcquisitionNumber
      //(0020,9156)
      = const DED(
          "FrameAcquisitionNumber", 0x00209156, "Frame Acquisition Number", VR.kUS, VM.k1, false);
  static const DED kDimensionIndexValues
      //(0020,9157)
      = const DED(
          "DimensionIndexValues", 0x00209157, "Dimension Index Values", VR.kUL, VM.k1_n, false);
  static const DED kFrameComments
      //(0020,9158)
      = const DED("FrameComments", 0x00209158, "Frame Comments", VR.kLT, VM.k1, false);
  static const DED kConcatenationUID
      //(0020,9161)
      = const DED("ConcatenationUID", 0x00209161, "Concatenation UID", VR.kUI, VM.k1, false);
  static const DED kInConcatenationNumber
      //(0020,9162)
      = const DED(
          "InConcatenationNumber", 0x00209162, "In-concatenation Number", VR.kUS, VM.k1, false);
  static const DED kInConcatenationTotalNumber
      //(0020,9163)
      = const DED("InConcatenationTotalNumber", 0x00209163, "In-concatenation Total Number",
          VR.kUS, VM.k1, false);
  static const DED kDimensionOrganizationUID
      //(0020,9164)
      = const DED("DimensionOrganizationUID", 0x00209164, "Dimension Organization UID", VR.kUI,
          VM.k1, false);
  static const DED kDimensionIndexPointer
      //(0020,9165)
      = const DED(
          "DimensionIndexPointer", 0x00209165, "Dimension Index Pointer", VR.kAT, VM.k1, false);
  static const DED kFunctionalGroupPointer
      //(0020,9167)
      = const DED(
          "FunctionalGroupPointer", 0x00209167, "Functional Group Pointer", VR.kAT, VM.k1, false);
  static const DED kUnassignedSharedConvertedAttributesSequence
      //(0020,9170)
      = const DED("UnassignedSharedConvertedAttributesSequence", 0x00209170,
          "Unassigned Shared Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const DED kUnassignedPerFrameConvertedAttributesSequence
      //(0020,9171)
      = const DED("UnassignedPerFrameConvertedAttributesSequence", 0x00209171,
          "Unassigned Per-Frame Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const DED kConversionSourceAttributesSequence
      //(0020,9172)
      = const DED("ConversionSourceAttributesSequence", 0x00209172,
          "Conversion Source Attributes Sequence", VR.kSQ, VM.k1, false);
  static const DED kDimensionIndexPrivateCreator
      //(0020,9213)
      = const DED("DimensionIndexPrivateCreator", 0x00209213, "Dimension Index Private Creator",
          VR.kLO, VM.k1, false);
  static const DED kDimensionOrganizationSequence
      //(0020,9221)
      = const DED("DimensionOrganizationSequence", 0x00209221,
          "Dimension Organization Sequence", VR.kSQ, VM.k1, false);
  static const DED kDimensionIndexSequence
      //(0020,9222)
      = const DED(
          "DimensionIndexSequence", 0x00209222, "Dimension Index Sequence", VR.kSQ, VM.k1, false);
  static const DED kConcatenationFrameOffsetNumber
      //(0020,9228)
      = const DED("ConcatenationFrameOffsetNumber", 0x00209228,
          "Concatenation Frame Offset Number", VR.kUL, VM.k1, false);
  static const DED kFunctionalGroupPrivateCreator
      //(0020,9238)
      = const DED("FunctionalGroupPrivateCreator", 0x00209238,
          "Functional Group Private Creator", VR.kLO, VM.k1, false);
  static const DED kNominalPercentageOfCardiacPhase
      //(0020,9241)
      = const DED("NominalPercentageOfCardiacPhase", 0x00209241,
          "Nominal Percentage of Cardiac Phase", VR.kFL, VM.k1, false);
  static const DED kNominalPercentageOfRespiratoryPhase
      //(0020,9245)
      = const DED("NominalPercentageOfRespiratoryPhase", 0x00209245,
          "Nominal Percentage of Respiratory Phase", VR.kFL, VM.k1, false);
  static const DED kStartingRespiratoryAmplitude
      //(0020,9246)
      = const DED("StartingRespiratoryAmplitude", 0x00209246, "Starting Respiratory Amplitude",
          VR.kFL, VM.k1, false);
  static const DED kStartingRespiratoryPhase
      //(0020,9247)
      = const DED("StartingRespiratoryPhase", 0x00209247, "Starting Respiratory Phase", VR.kCS,
          VM.k1, false);
  static const DED kEndingRespiratoryAmplitude
      //(0020,9248)
      = const DED("EndingRespiratoryAmplitude", 0x00209248, "Ending Respiratory Amplitude",
          VR.kFL, VM.k1, false);
  static const DED kEndingRespiratoryPhase
      //(0020,9249)
      = const DED(
          "EndingRespiratoryPhase", 0x00209249, "Ending Respiratory Phase", VR.kCS, VM.k1, false);
  static const DED kRespiratoryTriggerType
      //(0020,9250)
      = const DED(
          "RespiratoryTriggerType", 0x00209250, "Respiratory Trigger Type", VR.kCS, VM.k1, false);
  static const DED kRRIntervalTimeNominal
      //(0020,9251)
      = const DED(
          "RRIntervalTimeNominal", 0x00209251, "R-R Interval Time Nominal", VR.kFD, VM.k1, false);
  static const DED kActualCardiacTriggerDelayTime
      //(0020,9252)
      = const DED("ActualCardiacTriggerDelayTime", 0x00209252,
          "Actual Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const DED kRespiratorySynchronizationSequence
      //(0020,9253)
      = const DED("RespiratorySynchronizationSequence", 0x00209253,
          "Respiratory Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const DED kRespiratoryIntervalTime
      //(0020,9254)
      = const DED(
          "RespiratoryIntervalTime", 0x00209254, "Respiratory Interval Time", VR.kFD, VM.k1, false);
  static const DED kNominalRespiratoryTriggerDelayTime
      //(0020,9255)
      = const DED("NominalRespiratoryTriggerDelayTime", 0x00209255,
          "Nominal Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const DED kRespiratoryTriggerDelayThreshold
      //(0020,9256)
      = const DED("RespiratoryTriggerDelayThreshold", 0x00209256,
          "Respiratory Trigger Delay Threshold", VR.kFD, VM.k1, false);
  static const DED kActualRespiratoryTriggerDelayTime
      //(0020,9257)
      = const DED("ActualRespiratoryTriggerDelayTime", 0x00209257,
          "Actual Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const DED kImagePositionVolume
      //(0020,9301)
      = const DED(
          "ImagePositionVolume", 0x00209301, "Image Position (Volume)", VR.kFD, VM.k3, false);
  static const DED kImageOrientationVolume
      //(0020,9302)
      = const DED(
          "ImageOrientationVolume", 0x00209302, "Image Orientation (Volume)", VR.kFD, VM.k6, false);
  static const DED kUltrasoundAcquisitionGeometry
      //(0020,9307)
      = const DED("UltrasoundAcquisitionGeometry", 0x00209307,
          "Ultrasound Acquisition Geometry", VR.kCS, VM.k1, false);
  static const DED kApexPosition
      //(0020,9308)
      = const DED("ApexPosition", 0x00209308, "Apex Position", VR.kFD, VM.k3, false);
  static const DED kVolumeToTransducerMappingMatrix
      //(0020,9309)
      = const DED("VolumeToTransducerMappingMatrix", 0x00209309,
          "Volume to Transducer Mapping Matrix", VR.kFD, VM.k16, false);
  static const DED kVolumeToTableMappingMatrix
      //(0020,930A)
      = const DED("VolumeToTableMappingMatrix", 0x0020930A, "Volume to Table Mapping Matrix",
          VR.kFD, VM.k16, false);
  static const DED kPatientFrameOfReferenceSource
      //(0020,930C)
      = const DED("PatientFrameOfReferenceSource", 0x0020930C,
          "Patient Frame of Reference Source", VR.kCS, VM.k1, false);
  static const DED kTemporalPositionTimeOffset
      //(0020,930D)
      = const DED("TemporalPositionTimeOffset", 0x0020930D, "Temporal Position Time Offset",
          VR.kFD, VM.k1, false);
  static const DED kPlanePositionVolumeSequence
      //(0020,930E)
      = const DED("PlanePositionVolumeSequence", 0x0020930E, "Plane Position (Volume) Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPlaneOrientationVolumeSequence
      //(0020,930F)
      = const DED("PlaneOrientationVolumeSequence", 0x0020930F,
          "Plane Orientation (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const DED kTemporalPositionSequence
      //(0020,9310)
      = const DED("TemporalPositionSequence", 0x00209310, "Temporal Position Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kDimensionOrganizationType
      //(0020,9311)
      = const DED("DimensionOrganizationType", 0x00209311, "Dimension Organization Type",
          VR.kCS, VM.k1, false);
  static const DED kVolumeFrameOfReferenceUID
      //(0020,9312)
      = const DED("VolumeFrameOfReferenceUID", 0x00209312, "Volume Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const DED kTableFrameOfReferenceUID
      //(0020,9313)
      = const DED("TableFrameOfReferenceUID", 0x00209313, "Table Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const DED kDimensionDescriptionLabel
      //(0020,9421)
      = const DED("DimensionDescriptionLabel", 0x00209421, "Dimension Description Label",
          VR.kLO, VM.k1, false);
  static const DED kPatientOrientationInFrameSequence
      //(0020,9450)
      = const DED("PatientOrientationInFrameSequence", 0x00209450,
          "Patient Orientation in Frame Sequence", VR.kSQ, VM.k1, false);
  static const DED kFrameLabel
      //(0020,9453)
      = const DED("FrameLabel", 0x00209453, "Frame Label", VR.kLO, VM.k1, false);
  static const DED kAcquisitionIndex
      //(0020,9518)
      = const DED("AcquisitionIndex", 0x00209518, "Acquisition Index", VR.kUS, VM.k1_n, false);
  static const DED kContributingSOPInstancesReferenceSequence
      //(0020,9529)
      = const DED("ContributingSOPInstancesReferenceSequence", 0x00209529,
          "Contributing SOP Instances Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kReconstructionIndex
      //(0020,9536)
      = const DED(
          "ReconstructionIndex", 0x00209536, "Reconstruction Index", VR.kUS, VM.k1, false);
  static const DED kLightPathFilterPassThroughWavelength
      //(0022,0001)
      = const DED("LightPathFilterPassThroughWavelength", 0x00220001,
          "Light Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const DED kLightPathFilterPassBand
      //(0022,0002)
      = const DED("LightPathFilterPassBand", 0x00220002, "Light Path Filter Pass Band", VR.kUS,
          VM.k2, false);
  static const DED kImagePathFilterPassThroughWavelength
      //(0022,0003)
      = const DED("ImagePathFilterPassThroughWavelength", 0x00220003,
          "Image Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const DED kImagePathFilterPassBand
      //(0022,0004)
      = const DED("ImagePathFilterPassBand", 0x00220004, "Image Path Filter Pass Band", VR.kUS,
          VM.k2, false);
  static const DED kPatientEyeMovementCommanded
      //(0022,0005)
      = const DED("PatientEyeMovementCommanded", 0x00220005, "Patient Eye Movement Commanded",
          VR.kCS, VM.k1, false);
  static const DED kPatientEyeMovementCommandCodeSequence
      //(0022,0006)
      = const DED("PatientEyeMovementCommandCodeSequence", 0x00220006,
          "Patient Eye Movement Command Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSphericalLensPower
      //(0022,0007)
      =
      const DED("SphericalLensPower", 0x00220007, "Spherical Lens Power", VR.kFL, VM.k1, false);
  static const DED kCylinderLensPower
      //(0022,0008)
      = const DED("CylinderLensPower", 0x00220008, "Cylinder Lens Power", VR.kFL, VM.k1, false);
  static const DED kCylinderAxis
      //(0022,0009)
      = const DED("CylinderAxis", 0x00220009, "Cylinder Axis", VR.kFL, VM.k1, false);
  static const DED kEmmetropicMagnification
      //(0022,000A)
      = const DED(
          "EmmetropicMagnification", 0x0022000A, "Emmetropic Magnification", VR.kFL, VM.k1, false);
  static const DED kIntraOcularPressure
      //(0022,000B)
      = const DED(
          "IntraOcularPressure", 0x0022000B, "Intra Ocular Pressure", VR.kFL, VM.k1, false);
  static const DED kHorizontalFieldOfView
      //(0022,000C)
      = const DED(
          "HorizontalFieldOfView", 0x0022000C, "Horizontal Field of View", VR.kFL, VM.k1, false);
  static const DED kPupilDilated
      //(0022,000D)
      = const DED("PupilDilated", 0x0022000D, "Pupil Dilated", VR.kCS, VM.k1, false);
  static const DED kDegreeOfDilation
      //(0022,000E)
      = const DED("DegreeOfDilation", 0x0022000E, "Degree of Dilation", VR.kFL, VM.k1, false);
  static const DED kStereoBaselineAngle
      //(0022,0010)
      = const DED(
          "StereoBaselineAngle", 0x00220010, "Stereo Baseline Angle", VR.kFL, VM.k1, false);
  static const DED kStereoBaselineDisplacement
      //(0022,0011)
      = const DED("StereoBaselineDisplacement", 0x00220011, "Stereo Baseline Displacement",
          VR.kFL, VM.k1, false);
  static const DED kStereoHorizontalPixelOffset
      //(0022,0012)
      = const DED("StereoHorizontalPixelOffset", 0x00220012, "Stereo Horizontal Pixel Offset",
          VR.kFL, VM.k1, false);
  static const DED kStereoVerticalPixelOffset
      //(0022,0013)
      = const DED("StereoVerticalPixelOffset", 0x00220013, "Stereo Vertical Pixel Offset",
          VR.kFL, VM.k1, false);
  static const DED kStereoRotation
      //(0022,0014)
      = const DED("StereoRotation", 0x00220014, "Stereo Rotation", VR.kFL, VM.k1, false);
  static const DED kAcquisitionDeviceTypeCodeSequence
      //(0022,0015)
      = const DED("AcquisitionDeviceTypeCodeSequence", 0x00220015,
          "Acquisition Device Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kIlluminationTypeCodeSequence
      //(0022,0016)
      = const DED("IlluminationTypeCodeSequence", 0x00220016, "Illumination Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kLightPathFilterTypeStackCodeSequence
      //(0022,0017)
      = const DED("LightPathFilterTypeStackCodeSequence", 0x00220017,
          "Light Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kImagePathFilterTypeStackCodeSequence
      //(0022,0018)
      = const DED("ImagePathFilterTypeStackCodeSequence", 0x00220018,
          "Image Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kLensesCodeSequence
      //(0022,0019)
      =
      const DED("LensesCodeSequence", 0x00220019, "Lenses Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelDescriptionCodeSequence
      //(0022,001A)
      = const DED("ChannelDescriptionCodeSequence", 0x0022001A,
          "Channel Description Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRefractiveStateSequence
      //(0022,001B)
      = const DED(
          "RefractiveStateSequence", 0x0022001B, "Refractive State Sequence", VR.kSQ, VM.k1, false);
  static const DED kMydriaticAgentCodeSequence
      //(0022,001C)
      = const DED("MydriaticAgentCodeSequence", 0x0022001C, "Mydriatic Agent Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRelativeImagePositionCodeSequence
      //(0022,001D)
      = const DED("RelativeImagePositionCodeSequence", 0x0022001D,
          "Relative Image Position Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kCameraAngleOfView
      //(0022,001E)
      =
      const DED("CameraAngleOfView", 0x0022001E, "Camera Angle of View", VR.kFL, VM.k1, false);
  static const DED kStereoPairsSequence
      //(0022,0020)
      = const DED(
          "StereoPairsSequence", 0x00220020, "Stereo Pairs Sequence", VR.kSQ, VM.k1, false);
  static const DED kLeftImageSequence
      //(0022,0021)
      = const DED("LeftImageSequence", 0x00220021, "Left Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kRightImageSequence
      //(0022,0022)
      =
      const DED("RightImageSequence", 0x00220022, "Right Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kAxialLengthOfTheEye
      //(0022,0030)
      = const DED(
          "AxialLengthOfTheEye", 0x00220030, "Axial Length of the Eye", VR.kFL, VM.k1, false);
  static const DED kOphthalmicFrameLocationSequence
      //(0022,0031)
      = const DED("OphthalmicFrameLocationSequence", 0x00220031,
          "Ophthalmic Frame Location Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferenceCoordinates
      //(0022,0032)
      = const DED(
          "ReferenceCoordinates", 0x00220032, "Reference Coordinates", VR.kFL, VM.k2_2n, false);
  static const DED kDepthSpatialResolution
      //(0022,0035)
      = const DED(
          "DepthSpatialResolution", 0x00220035, "Depth Spatial Resolution", VR.kFL, VM.k1, false);
  static const DED kMaximumDepthDistortion
      //(0022,0036)
      = const DED(
          "MaximumDepthDistortion", 0x00220036, "Maximum Depth Distortion", VR.kFL, VM.k1, false);
  static const DED kAlongScanSpatialResolution
      //(0022,0037)
      = const DED("AlongScanSpatialResolution", 0x00220037, "Along-scan Spatial Resolution",
          VR.kFL, VM.k1, false);
  static const DED kMaximumAlongScanDistortion
      //(0022,0038)
      = const DED("MaximumAlongScanDistortion", 0x00220038, "Maximum Along-scan Distortion",
          VR.kFL, VM.k1, false);
  static const DED kOphthalmicImageOrientation
      //(0022,0039)
      = const DED("OphthalmicImageOrientation", 0x00220039, "Ophthalmic Image Orientation",
          VR.kCS, VM.k1, false);
  static const DED kDepthOfTransverseImage
      //(0022,0041)
      = const DED(
          "DepthOfTransverseImage", 0x00220041, "Depth of Transverse Image", VR.kFL, VM.k1, false);
  static const DED kMydriaticAgentConcentrationUnitsSequence
      //(0022,0042)
      = const DED("MydriaticAgentConcentrationUnitsSequence", 0x00220042,
          "Mydriatic Agent Concentration Units Sequence", VR.kSQ, VM.k1, false);
  static const DED kAcrossScanSpatialResolution
      //(0022,0048)
      = const DED("AcrossScanSpatialResolution", 0x00220048, "Across-scan Spatial Resolution",
          VR.kFL, VM.k1, false);
  static const DED kMaximumAcrossScanDistortion
      //(0022,0049)
      = const DED("MaximumAcrossScanDistortion", 0x00220049, "Maximum Across-scan Distortion",
          VR.kFL, VM.k1, false);
  static const DED kMydriaticAgentConcentration
      //(0022,004E)
      = const DED("MydriaticAgentConcentration", 0x0022004E, "Mydriatic Agent Concentration",
          VR.kDS, VM.k1, false);
  static const DED kIlluminationWaveLength
      //(0022,0055)
      = const DED(
          "IlluminationWaveLength", 0x00220055, "Illumination Wave Length", VR.kFL, VM.k1, false);
  static const DED kIlluminationPower
      //(0022,0056)
      = const DED("IlluminationPower", 0x00220056, "Illumination Power", VR.kFL, VM.k1, false);
  static const DED kIlluminationBandwidth
      //(0022,0057)
      = const DED(
          "IlluminationBandwidth", 0x00220057, "Illumination Bandwidth", VR.kFL, VM.k1, false);
  static const DED kMydriaticAgentSequence
      //(0022,0058)
      = const DED(
          "MydriaticAgentSequence", 0x00220058, "Mydriatic Agent Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialMeasurementsRightEyeSequence
      //(0022,1007)
      = const DED("OphthalmicAxialMeasurementsRightEyeSequence", 0x00221007,
          "Ophthalmic Axial Measurements Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialMeasurementsLeftEyeSequence
      //(0022,1008)
      = const DED("OphthalmicAxialMeasurementsLeftEyeSequence", 0x00221008,
          "Ophthalmic Axial Measurements Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialMeasurementsDeviceType
      //(0022,1009)
      = const DED("OphthalmicAxialMeasurementsDeviceType", 0x00221009,
          "Ophthalmic Axial Measurements Device Type", VR.kCS, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsType
      //(0022,1010)
      = const DED("OphthalmicAxialLengthMeasurementsType", 0x00221010,
          "Ophthalmic Axial Length Measurements Type", VR.kCS, VM.k1, false);
  static const DED kOphthalmicAxialLengthSequence
      //(0022,1012)
      = const DED("OphthalmicAxialLengthSequence", 0x00221012,
          "Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLength
      //(0022,1019)
      = const DED(
          "OphthalmicAxialLength", 0x00221019, "Ophthalmic Axial Length", VR.kFL, VM.k1, false);
  static const DED kLensStatusCodeSequence
      //(0022,1024)
      = const DED(
          "LensStatusCodeSequence", 0x00221024, "Lens Status Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kVitreousStatusCodeSequence
      //(0022,1025)
      = const DED("VitreousStatusCodeSequence", 0x00221025, "Vitreous Status Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kIOLFormulaCodeSequence
      //(0022,1028)
      = const DED(
          "IOLFormulaCodeSequence", 0x00221028, "IOL Formula Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kIOLFormulaDetail
      //(0022,1029)
      = const DED("IOLFormulaDetail", 0x00221029, "IOL Formula Detail", VR.kLO, VM.k1, false);
  static const DED kKeratometerIndex
      //(0022,1033)
      = const DED("KeratometerIndex", 0x00221033, "Keratometer Index", VR.kFL, VM.k1, false);
  static const DED kSourceOfOphthalmicAxialLengthCodeSequence
      //(0022,1035)
      = const DED("SourceOfOphthalmicAxialLengthCodeSequence", 0x00221035,
          "Source of Ophthalmic Axial Length Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kTargetRefraction
      //(0022,1037)
      = const DED("TargetRefraction", 0x00221037, "Target Refraction", VR.kFL, VM.k1, false);
  static const DED kRefractiveProcedureOccurred
      //(0022,1039)
      = const DED("RefractiveProcedureOccurred", 0x00221039, "Refractive Procedure Occurred",
          VR.kCS, VM.k1, false);
  static const DED kRefractiveSurgeryTypeCodeSequence
      //(0022,1040)
      = const DED("RefractiveSurgeryTypeCodeSequence", 0x00221040,
          "Refractive Surgery Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicUltrasoundMethodCodeSequence
      //(0022,1044)
      = const DED("OphthalmicUltrasoundMethodCodeSequence", 0x00221044,
          "Ophthalmic Ultrasound Method Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsSequence
      //(0022,1050)
      = const DED("OphthalmicAxialLengthMeasurementsSequence", 0x00221050,
          "Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kIOLPower
      //(0022,1053)
      = const DED("IOLPower", 0x00221053, "IOL Power", VR.kFL, VM.k1, false);
  static const DED kPredictedRefractiveError
      //(0022,1054)
      = const DED("PredictedRefractiveError", 0x00221054, "Predicted Refractive Error", VR.kFL,
          VM.k1, false);
  static const DED kOphthalmicAxialLengthVelocity
      //(0022,1059)
      = const DED("OphthalmicAxialLengthVelocity", 0x00221059,
          "Ophthalmic Axial Length Velocity", VR.kFL, VM.k1, false);
  static const DED kLensStatusDescription
      //(0022,1065)
      = const DED(
          "LensStatusDescription", 0x00221065, "Lens Status Description", VR.kLO, VM.k1, false);
  static const DED kVitreousStatusDescription
      //(0022,1066)
      = const DED("VitreousStatusDescription", 0x00221066, "Vitreous Status Description",
          VR.kLO, VM.k1, false);
  static const DED kIOLPowerSequence
      //(0022,1090)
      = const DED("IOLPowerSequence", 0x00221090, "IOL Power Sequence", VR.kSQ, VM.k1, false);
  static const DED kLensConstantSequence
      //(0022,1092)
      = const DED(
          "LensConstantSequence", 0x00221092, "Lens Constant Sequence", VR.kSQ, VM.k1, false);
  static const DED kIOLManufacturer
      //(0022,1093)
      = const DED("IOLManufacturer", 0x00221093, "IOL Manufacturer", VR.kLO, VM.k1, false);
  static const DED kLensConstantDescription
      //(0022,1094)
      = const DED(
          "LensConstantDescription", 0x00221094, "Lens Constant Description", VR.kLO, VM.k1, true);
  static const DED kImplantName
      //(0022,1095)
      = const DED("ImplantName", 0x00221095, "Implant Name", VR.kLO, VM.k1, false);
  static const DED kKeratometryMeasurementTypeCodeSequence
      //(0022,1096)
      = const DED("KeratometryMeasurementTypeCodeSequence", 0x00221096,
          "Keratometry Measurement Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantPartNumber
      //(0022,1097)
      = const DED("ImplantPartNumber", 0x00221097, "Implant Part Number", VR.kLO, VM.k1, false);
  static const DED kReferencedOphthalmicAxialMeasurementsSequence
      //(0022,1100)
      = const DED("ReferencedOphthalmicAxialMeasurementsSequence", 0x00221100,
          "Referenced Ophthalmic Axial Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsSegmentNameCodeSequence
      //(0022,1101)
      = const DED("OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence", 0x00221101,
          "Ophthalmic Axial Length Measurements Segment Name Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRefractiveErrorBeforeRefractiveSurgeryCodeSequence
      //(0022,1103)
      = const DED("RefractiveErrorBeforeRefractiveSurgeryCodeSequence", 0x00221103,
          "Refractive Error Before Refractive Surgery Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kIOLPowerForExactEmmetropia
      //(0022,1121)
      = const DED("IOLPowerForExactEmmetropia", 0x00221121, "IOL Power For Exact Emmetropia",
          VR.kFL, VM.k1, false);
  static const DED kIOLPowerForExactTargetRefraction
      //(0022,1122)
      = const DED("IOLPowerForExactTargetRefraction", 0x00221122,
          "IOL Power For Exact Target Refraction", VR.kFL, VM.k1, false);
  static const DED kAnteriorChamberDepthDefinitionCodeSequence
      //(0022,1125)
      = const DED("AnteriorChamberDepthDefinitionCodeSequence", 0x00221125,
          "Anterior Chamber Depth Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kLensThicknessSequence
      //(0022,1127)
      = const DED(
          "LensThicknessSequence", 0x00221127, "Lens Thickness Sequence", VR.kSQ, VM.k1, false);
  static const DED kAnteriorChamberDepthSequence
      //(0022,1128)
      = const DED("AnteriorChamberDepthSequence", 0x00221128, "Anterior Chamber Depth Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kLensThickness
      //(0022,1130)
      = const DED("LensThickness", 0x00221130, "Lens Thickness", VR.kFL, VM.k1, false);
  static const DED kAnteriorChamberDepth
      //(0022,1131)
      = const DED(
          "AnteriorChamberDepth", 0x00221131, "Anterior Chamber Depth", VR.kFL, VM.k1, false);
  static const DED kSourceOfLensThicknessDataCodeSequence
      //(0022,1132)
      = const DED("SourceOfLensThicknessDataCodeSequence", 0x00221132,
          "Source of Lens Thickness Data Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceOfAnteriorChamberDepthDataCodeSequence
      //(0022,1133)
      = const DED("SourceOfAnteriorChamberDepthDataCodeSequence", 0x00221133,
          "Source of Anterior Chamber Depth Data Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceOfRefractiveMeasurementsSequence
      //(0022,1134)
      = const DED("SourceOfRefractiveMeasurementsSequence", 0x00221134,
          "Source of Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceOfRefractiveMeasurementsCodeSequence
      //(0022,1135)
      = const DED("SourceOfRefractiveMeasurementsCodeSequence", 0x00221135,
          "Source of Refractive Measurements Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementModified
      //(0022,1140)
      = const DED("OphthalmicAxialLengthMeasurementModified", 0x00221140,
          "Ophthalmic Axial Length Measurement Modified", VR.kCS, VM.k1, false);
  static const DED kOphthalmicAxialLengthDataSourceCodeSequence
      //(0022,1150)
      = const DED("OphthalmicAxialLengthDataSourceCodeSequence", 0x00221150,
          "Ophthalmic Axial Length Data Source Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthAcquisitionMethodCodeSequence
      //(0022,1153)
      = const DED("OphthalmicAxialLengthAcquisitionMethodCodeSequence", 0x00221153,
          "Ophthalmic Axial Length Acquisition Method Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kSignalToNoiseRatio
      //(0022,1155)
      = const DED(
          "SignalToNoiseRatio", 0x00221155, "Signal to Noise Ratio", VR.kFL, VM.k1, false);
  static const DED kOphthalmicAxialLengthDataSourceDescription
      //(0022,1159)
      = const DED("OphthalmicAxialLengthDataSourceDescription", 0x00221159,
          "Ophthalmic Axial Length Data Source Description", VR.kLO, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsTotalLengthSequence
      //(0022,1210)
      = const DED("OphthalmicAxialLengthMeasurementsTotalLengthSequence", 0x00221210,
          "Ophthalmic Axial Length Measurements Total Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsSegmentalLengthSequence
      //(0022,1211)
      = const DED("OphthalmicAxialLengthMeasurementsSegmentalLengthSequence", 0x00221211,
          "Ophthalmic Axial Length Measurements Segmental Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthMeasurementsLengthSummationSequence
      //(0022,1212)
      = const DED("OphthalmicAxialLengthMeasurementsLengthSummationSequence", 0x00221212,
          "Ophthalmic Axial Length Measurements Length Summation Sequence", VR.kSQ, VM.k1, false);
  static const DED kUltrasoundOphthalmicAxialLengthMeasurementsSequence
      //(0022,1220)
      = const DED("UltrasoundOphthalmicAxialLengthMeasurementsSequence", 0x00221220,
          "Ultrasound Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kOpticalOphthalmicAxialLengthMeasurementsSequence
      //(0022,1225)
      = const DED("OpticalOphthalmicAxialLengthMeasurementsSequence", 0x00221225,
          "Optical Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kUltrasoundSelectedOphthalmicAxialLengthSequence
      //(0022,1230)
      = const DED("UltrasoundSelectedOphthalmicAxialLengthSequence", 0x00221230,
          "Ultrasound Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthSelectionMethodCodeSequence
      //(0022,1250)
      = const DED("OphthalmicAxialLengthSelectionMethodCodeSequence", 0x00221250,
          "Ophthalmic Axial Length Selection Method Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOpticalSelectedOphthalmicAxialLengthSequence
      //(0022,1255)
      = const DED("OpticalSelectedOphthalmicAxialLengthSequence", 0x00221255,
          "Optical Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kSelectedSegmentalOphthalmicAxialLengthSequence
      //(0022,1257)
      = const DED("SelectedSegmentalOphthalmicAxialLengthSequence", 0x00221257,
          "Selected Segmental Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kSelectedTotalOphthalmicAxialLengthSequence
      //(0022,1260)
      = const DED("SelectedTotalOphthalmicAxialLengthSequence", 0x00221260,
          "Selected Total Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthQualityMetricSequence
      //(0022,1262)
      = const DED("OphthalmicAxialLengthQualityMetricSequence", 0x00221262,
          "Ophthalmic Axial Length Quality Metric Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicAxialLengthQualityMetricTypeCodeSequence
      //(0022,1265)
      = const DED("OphthalmicAxialLengthQualityMetricTypeCodeSequence", 0x00221265,
          "Ophthalmic Axial Length Quality Metric Type Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kOphthalmicAxialLengthQualityMetricTypeDescription
      //(0022,1273)
      = const DED("OphthalmicAxialLengthQualityMetricTypeDescription", 0x00221273,
          "Ophthalmic Axial Length Quality Metric Type Description", VR.kLO, VM.k1, true);
  static const DED kIntraocularLensCalculationsRightEyeSequence
      //(0022,1300)
      = const DED("IntraocularLensCalculationsRightEyeSequence", 0x00221300,
          "Intraocular Lens Calculations Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kIntraocularLensCalculationsLeftEyeSequence
      //(0022,1310)
      = const DED("IntraocularLensCalculationsLeftEyeSequence", 0x00221310,
          "Intraocular Lens Calculations Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedOphthalmicAxialLengthMeasurementQCImageSequence
      //(0022,1330)
      = const DED("ReferencedOphthalmicAxialLengthMeasurementQCImageSequence", 0x00221330,
          "Referenced Ophthalmic Axial Length Measurement QC Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicMappingDeviceType
      //(0022,1415)
      = const DED("OphthalmicMappingDeviceType", 0x00221415, "Ophthalmic Mapping Device Type",
          VR.kCS, VM.k1, false);
  static const DED kAcquisitionMethodCodeSequence
      //(0022,1420)
      = const DED("AcquisitionMethodCodeSequence", 0x00221420,
          "Acquisition Method Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kAcquisitionMethodAlgorithmSequence
      //(0022,1423)
      = const DED("AcquisitionMethodAlgorithmSequence", 0x00221423,
          "Acquisition Method Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicThicknessMapTypeCodeSequence
      //(0022,1436)
      = const DED("OphthalmicThicknessMapTypeCodeSequence", 0x00221436,
          "Ophthalmic Thickness Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicThicknessMappingNormalsSequence
      //(0022,1443)
      = const DED("OphthalmicThicknessMappingNormalsSequence", 0x00221443,
          "Ophthalmic Thickness Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const DED kRetinalThicknessDefinitionCodeSequence
      //(0022,1445)
      = const DED("RetinalThicknessDefinitionCodeSequence", 0x00221445,
          "Retinal Thickness Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPixelValueMappingToCodedConceptSequence
      //(0022,1450)
      = const DED("PixelValueMappingToCodedConceptSequence", 0x00221450,
          "Pixel Value Mapping to Coded Concept Sequence", VR.kSQ, VM.k1, false);
  static const DED kMappedPixelValue
      //(0022,1452)
      = const DED("MappedPixelValue", 0x00221452, "Mapped Pixel Value", VR.kUSSS, VM.k1, false);
  static const DED kPixelValueMappingExplanation
      //(0022,1454)
      = const DED("PixelValueMappingExplanation", 0x00221454, "Pixel Value Mapping Explanation",
          VR.kLO, VM.k1, false);
  static const DED kOphthalmicThicknessMapQualityThresholdSequence
      //(0022,1458)
      = const DED("OphthalmicThicknessMapQualityThresholdSequence", 0x00221458,
          "Ophthalmic Thickness Map Quality Threshold Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicThicknessMapThresholdQualityRating
      //(0022,1460)
      = const DED("OphthalmicThicknessMapThresholdQualityRating", 0x00221460,
          "Ophthalmic Thickness Map Threshold Quality Rating", VR.kFL, VM.k1, false);
  static const DED kAnatomicStructureReferencePoint
      //(0022,1463)
      = const DED("AnatomicStructureReferencePoint", 0x00221463,
          "Anatomic Structure Reference Point", VR.kFL, VM.k2, false);
  static const DED kRegistrationToLocalizerSequence
      //(0022,1465)
      = const DED("RegistrationToLocalizerSequence", 0x00221465,
          "Registration to Localizer Sequence", VR.kSQ, VM.k1, false);
  static const DED kRegisteredLocalizerUnits
      //(0022,1466)
      = const DED("RegisteredLocalizerUnits", 0x00221466, "Registered Localizer Units", VR.kCS,
          VM.k1, false);
  static const DED kRegisteredLocalizerTopLeftHandCorner
      //(0022,1467)
      = const DED("RegisteredLocalizerTopLeftHandCorner", 0x00221467,
          "Registered Localizer Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const DED kRegisteredLocalizerBottomRightHandCorner
      //(0022,1468)
      = const DED("RegisteredLocalizerBottomRightHandCorner", 0x00221468,
          "Registered Localizer Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const DED kOphthalmicThicknessMapQualityRatingSequence
      //(0022,1470)
      = const DED("OphthalmicThicknessMapQualityRatingSequence", 0x00221470,
          "Ophthalmic Thickness Map Quality Rating Sequence", VR.kSQ, VM.k1, false);
  static const DED kRelevantOPTAttributesSequence
      //(0022,1472)
      = const DED("RelevantOPTAttributesSequence", 0x00221472,
          "Relevant OPT Attributes Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualFieldHorizontalExtent
      //(0024,0010)
      = const DED("VisualFieldHorizontalExtent", 0x00240010, "Visual Field Horizontal Extent",
          VR.kFL, VM.k1, false);
  static const DED kVisualFieldVerticalExtent
      //(0024,0011)
      = const DED("VisualFieldVerticalExtent", 0x00240011, "Visual Field Vertical Extent",
          VR.kFL, VM.k1, false);
  static const DED kVisualFieldShape
      //(0024,0012)
      = const DED("VisualFieldShape", 0x00240012, "Visual Field Shape", VR.kCS, VM.k1, false);
  static const DED kScreeningTestModeCodeSequence
      //(0024,0016)
      = const DED("ScreeningTestModeCodeSequence", 0x00240016,
          "Screening Test Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kMaximumStimulusLuminance
      //(0024,0018)
      = const DED("MaximumStimulusLuminance", 0x00240018, "Maximum Stimulus Luminance", VR.kFL,
          VM.k1, false);
  static const DED kBackgroundLuminance
      //(0024,0020)
      = const DED(
          "BackgroundLuminance", 0x00240020, "Background Luminance", VR.kFL, VM.k1, false);
  static const DED kStimulusColorCodeSequence
      //(0024,0021)
      = const DED("StimulusColorCodeSequence", 0x00240021, "Stimulus Color Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kBackgroundIlluminationColorCodeSequence
      //(0024,0024)
      = const DED("BackgroundIlluminationColorCodeSequence", 0x00240024,
          "Background Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kStimulusArea
      //(0024,0025)
      = const DED("StimulusArea", 0x00240025, "Stimulus Area", VR.kFL, VM.k1, false);
  static const DED kStimulusPresentationTime
      //(0024,0028)
      = const DED("StimulusPresentationTime", 0x00240028, "Stimulus Presentation Time", VR.kFL,
          VM.k1, false);
  static const DED kFixationSequence
      //(0024,0032)
      = const DED("FixationSequence", 0x00240032, "Fixation Sequence", VR.kSQ, VM.k1, false);
  static const DED kFixationMonitoringCodeSequence
      //(0024,0033)
      = const DED("FixationMonitoringCodeSequence", 0x00240033,
          "Fixation Monitoring Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualFieldCatchTrialSequence
      //(0024,0034)
      = const DED("VisualFieldCatchTrialSequence", 0x00240034,
          "Visual Field Catch Trial Sequence", VR.kSQ, VM.k1, false);
  static const DED kFixationCheckedQuantity
      //(0024,0035)
      = const DED(
          "FixationCheckedQuantity", 0x00240035, "Fixation Checked Quantity", VR.kUS, VM.k1, false);
  static const DED kPatientNotProperlyFixatedQuantity
      //(0024,0036)
      = const DED("PatientNotProperlyFixatedQuantity", 0x00240036,
          "Patient Not Properly Fixated Quantity", VR.kUS, VM.k1, false);
  static const DED kPresentedVisualStimuliDataFlag
      //(0024,0037)
      = const DED("PresentedVisualStimuliDataFlag", 0x00240037,
          "Presented Visual Stimuli Data Flag", VR.kCS, VM.k1, false);
  static const DED kNumberOfVisualStimuli
      //(0024,0038)
      = const DED(
          "NumberOfVisualStimuli", 0x00240038, "Number of Visual Stimuli", VR.kUS, VM.k1, false);
  static const DED kExcessiveFixationLossesDataFlag
      //(0024,0039)
      = const DED("ExcessiveFixationLossesDataFlag", 0x00240039,
          "Excessive Fixation Losses Data Flag", VR.kCS, VM.k1, false);
  static const DED kExcessiveFixationLosses
      //(0024,0040)
      = const DED(
          "ExcessiveFixationLosses", 0x00240040, "Excessive Fixation Losses", VR.kCS, VM.k1, false);
  static const DED kStimuliRetestingQuantity
      //(0024,0042)
      = const DED("StimuliRetestingQuantity", 0x00240042, "Stimuli Retesting Quantity", VR.kUS,
          VM.k1, false);
  static const DED kCommentsOnPatientPerformanceOfVisualField
      //(0024,0044)
      = const DED("CommentsOnPatientPerformanceOfVisualField", 0x00240044,
          "Comments on Patient's Performance of Visual Field", VR.kLT, VM.k1, false);
  static const DED kFalseNegativesEstimateFlag
      //(0024,0045)
      = const DED("FalseNegativesEstimateFlag", 0x00240045, "False Negatives Estimate Flag",
          VR.kCS, VM.k1, false);
  static const DED kFalseNegativesEstimate
      //(0024,0046)
      = const DED(
          "FalseNegativesEstimate", 0x00240046, "False Negatives Estimate", VR.kFL, VM.k1, false);
  static const DED kNegativeCatchTrialsQuantity
      //(0024,0048)
      = const DED("NegativeCatchTrialsQuantity", 0x00240048, "Negative Catch Trials Quantity",
          VR.kUS, VM.k1, false);
  static const DED kFalseNegativesQuantity
      //(0024,0050)
      = const DED(
          "FalseNegativesQuantity", 0x00240050, "False Negatives Quantity", VR.kUS, VM.k1, false);
  static const DED kExcessiveFalseNegativesDataFlag
      //(0024,0051)
      = const DED("ExcessiveFalseNegativesDataFlag", 0x00240051,
          "Excessive False Negatives Data Flag", VR.kCS, VM.k1, false);
  static const DED kExcessiveFalseNegatives
      //(0024,0052)
      = const DED(
          "ExcessiveFalseNegatives", 0x00240052, "Excessive False Negatives", VR.kCS, VM.k1, false);
  static const DED kFalsePositivesEstimateFlag
      //(0024,0053)
      = const DED("FalsePositivesEstimateFlag", 0x00240053, "False Positives Estimate Flag",
          VR.kCS, VM.k1, false);
  static const DED kFalsePositivesEstimate
      //(0024,0054)
      = const DED(
          "FalsePositivesEstimate", 0x00240054, "False Positives Estimate", VR.kFL, VM.k1, false);
  static const DED kCatchTrialsDataFlag
      //(0024,0055)
      = const DED(
          "CatchTrialsDataFlag", 0x00240055, "Catch Trials Data Flag", VR.kCS, VM.k1, false);
  static const DED kPositiveCatchTrialsQuantity
      //(0024,0056)
      = const DED("PositiveCatchTrialsQuantity", 0x00240056, "Positive Catch Trials Quantity",
          VR.kUS, VM.k1, false);
  static const DED kTestPointNormalsDataFlag
      //(0024,0057)
      = const DED("TestPointNormalsDataFlag", 0x00240057, "Test Point Normals Data Flag",
          VR.kCS, VM.k1, false);
  static const DED kTestPointNormalsSequence
      //(0024,0058)
      = const DED("TestPointNormalsSequence", 0x00240058, "Test Point Normals Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kGlobalDeviationProbabilityNormalsFlag
      //(0024,0059)
      = const DED("GlobalDeviationProbabilityNormalsFlag", 0x00240059,
          "Global Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const DED kFalsePositivesQuantity
      //(0024,0060)
      = const DED(
          "FalsePositivesQuantity", 0x00240060, "False Positives Quantity", VR.kUS, VM.k1, false);
  static const DED kExcessiveFalsePositivesDataFlag
      //(0024,0061)
      = const DED("ExcessiveFalsePositivesDataFlag", 0x00240061,
          "Excessive False Positives Data Flag", VR.kCS, VM.k1, false);
  static const DED kExcessiveFalsePositives
      //(0024,0062)
      = const DED(
          "ExcessiveFalsePositives", 0x00240062, "Excessive False Positives", VR.kCS, VM.k1, false);
  static const DED kVisualFieldTestNormalsFlag
      //(0024,0063)
      = const DED("VisualFieldTestNormalsFlag", 0x00240063, "Visual Field Test Normals Flag",
          VR.kCS, VM.k1, false);
  static const DED kResultsNormalsSequence
      //(0024,0064)
      = const DED(
          "ResultsNormalsSequence", 0x00240064, "Results Normals Sequence", VR.kSQ, VM.k1, false);
  static const DED kAgeCorrectedSensitivityDeviationAlgorithmSequence
      //(0024,0065)
      = const DED("AgeCorrectedSensitivityDeviationAlgorithmSequence", 0x00240065,
          "Age Corrected Sensitivity Deviation Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const DED kGlobalDeviationFromNormal
      //(0024,0066)
      = const DED("GlobalDeviationFromNormal", 0x00240066, "Global Deviation From Normal",
          VR.kFL, VM.k1, false);
  static const DED kGeneralizedDefectSensitivityDeviationAlgorithmSequence
      //(0024,0067)
      = const DED("GeneralizedDefectSensitivityDeviationAlgorithmSequence", 0x00240067,
          "Generalized Defect Sensitivity Deviation Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const DED kLocalizedDeviationFromNormal
      //(0024,0068)
      = const DED("LocalizedDeviationFromNormal", 0x00240068, "Localized Deviation From Normal",
          VR.kFL, VM.k1, false);
  static const DED kPatientReliabilityIndicator
      //(0024,0069)
      = const DED("PatientReliabilityIndicator", 0x00240069, "Patient Reliability Indicator",
          VR.kLO, VM.k1, false);
  static const DED kVisualFieldMeanSensitivity
      //(0024,0070)
      = const DED("VisualFieldMeanSensitivity", 0x00240070, "Visual Field Mean Sensitivity",
          VR.kFL, VM.k1, false);
  static const DED kGlobalDeviationProbability
      //(0024,0071)
      = const DED("GlobalDeviationProbability", 0x00240071, "Global Deviation Probability",
          VR.kFL, VM.k1, false);
  static const DED kLocalDeviationProbabilityNormalsFlag
      //(0024,0072)
      = const DED("LocalDeviationProbabilityNormalsFlag", 0x00240072,
          "Local Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const DED kLocalizedDeviationProbability
      //(0024,0073)
      = const DED("LocalizedDeviationProbability", 0x00240073,
          "Localized Deviation Probability", VR.kFL, VM.k1, false);
  static const DED kShortTermFluctuationCalculated
      //(0024,0074)
      = const DED("ShortTermFluctuationCalculated", 0x00240074,
          "Short Term Fluctuation Calculated", VR.kCS, VM.k1, false);
  static const DED kShortTermFluctuation
      //(0024,0075)
      = const DED(
          "ShortTermFluctuation", 0x00240075, "Short Term Fluctuation", VR.kFL, VM.k1, false);
  static const DED kShortTermFluctuationProbabilityCalculated
      //(0024,0076)
      = const DED("ShortTermFluctuationProbabilityCalculated", 0x00240076,
          "Short Term Fluctuation Probability Calculated", VR.kCS, VM.k1, false);
  static const DED kShortTermFluctuationProbability
      //(0024,0077)
      = const DED("ShortTermFluctuationProbability", 0x00240077,
          "Short Term Fluctuation Probability", VR.kFL, VM.k1, false);
  static const DED kCorrectedLocalizedDeviationFromNormalCalculated
      //(0024,0078)
      = const DED("CorrectedLocalizedDeviationFromNormalCalculated", 0x00240078,
          "Corrected Localized Deviation From Normal Calculated", VR.kCS, VM.k1, false);
  static const DED kCorrectedLocalizedDeviationFromNormal
      //(0024,0079)
      = const DED("CorrectedLocalizedDeviationFromNormal", 0x00240079,
          "Corrected Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const DED kCorrectedLocalizedDeviationFromNormalProbabilityCalculated
      //(0024,0080)
      = const DED("CorrectedLocalizedDeviationFromNormalProbabilityCalculated", 0x00240080,
          "Corrected Localized Deviation From Normal Probability Calculated", VR.kCS, VM.k1, false);
  static const DED kCorrectedLocalizedDeviationFromNormalProbability
      //(0024,0081)
      = const DED("CorrectedLocalizedDeviationFromNormalProbability", 0x00240081,
          "Corrected Localized Deviation From Normal Probability", VR.kFL, VM.k1, false);
  static const DED kGlobalDeviationProbabilitySequence
      //(0024,0083)
      = const DED("GlobalDeviationProbabilitySequence", 0x00240083,
          "Global Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const DED kLocalizedDeviationProbabilitySequence
      //(0024,0085)
      = const DED("LocalizedDeviationProbabilitySequence", 0x00240085,
          "Localized Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const DED kFovealSensitivityMeasured
      //(0024,0086)
      = const DED("FovealSensitivityMeasured", 0x00240086, "Foveal Sensitivity Measured",
          VR.kCS, VM.k1, false);
  static const DED kFovealSensitivity
      //(0024,0087)
      = const DED("FovealSensitivity", 0x00240087, "Foveal Sensitivity", VR.kFL, VM.k1, false);
  static const DED kVisualFieldTestDuration
      //(0024,0088)
      = const DED("VisualFieldTestDuration", 0x00240088, "Visual Field Test Duration", VR.kFL,
          VM.k1, false);
  static const DED kVisualFieldTestPointSequence
      //(0024,0089)
      = const DED("VisualFieldTestPointSequence", 0x00240089,
          "Visual Field Test Point Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualFieldTestPointXCoordinate
      //(0024,0090)
      = const DED("VisualFieldTestPointXCoordinate", 0x00240090,
          "Visual Field Test Point X-Coordinate", VR.kFL, VM.k1, false);
  static const DED kVisualFieldTestPointYCoordinate
      //(0024,0091)
      = const DED("VisualFieldTestPointYCoordinate", 0x00240091,
          "Visual Field Test Point Y-Coordinate", VR.kFL, VM.k1, false);
  static const DED kAgeCorrectedSensitivityDeviationValue
      //(0024,0092)
      = const DED("AgeCorrectedSensitivityDeviationValue", 0x00240092,
          "Age Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const DED kStimulusResults
      //(0024,0093)
      = const DED("StimulusResults", 0x00240093, "Stimulus Results", VR.kCS, VM.k1, false);
  static const DED kSensitivityValue
      //(0024,0094)
      = const DED("SensitivityValue", 0x00240094, "Sensitivity Value", VR.kFL, VM.k1, false);
  static const DED kRetestStimulusSeen
      //(0024,0095)
      =
      const DED("RetestStimulusSeen", 0x00240095, "Retest Stimulus Seen", VR.kCS, VM.k1, false);
  static const DED kRetestSensitivityValue
      //(0024,0096)
      = const DED(
          "RetestSensitivityValue", 0x00240096, "Retest Sensitivity Value", VR.kFL, VM.k1, false);
  static const DED kVisualFieldTestPointNormalsSequence
      //(0024,0097)
      = const DED("VisualFieldTestPointNormalsSequence", 0x00240097,
          "Visual Field Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const DED kQuantifiedDefect
      //(0024,0098)
      = const DED("QuantifiedDefect", 0x00240098, "Quantified Defect", VR.kFL, VM.k1, false);
  static const DED kAgeCorrectedSensitivityDeviationProbabilityValue
      //(0024,0100)
      = const DED("AgeCorrectedSensitivityDeviationProbabilityValue", 0x00240100,
          "Age Corrected Sensitivity Deviation Probability Value", VR.kFL, VM.k1, false);
  static const DED kGeneralizedDefectCorrectedSensitivityDeviationFlag
      //(0024,0102)
      = const DED("GeneralizedDefectCorrectedSensitivityDeviationFlag", 0x00240102,
          "Generalized Defect Corrected Sensitivity Deviation Flag", VR.kCS, VM.k1, false);
  static const DED kGeneralizedDefectCorrectedSensitivityDeviationValue
      //(0024,0103)
      = const DED("GeneralizedDefectCorrectedSensitivityDeviationValue", 0x00240103,
          "Generalized Defect Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const DED kGeneralizedDefectCorrectedSensitivityDeviationProbabilityValue
      //(0024,0104)
      = const DED(
          "GeneralizedDefectCorrectedSensitivityDeviationProbabilityValue",
          0x00240104,
          "Generalized Defect Corrected Sensitivity Deviation Probability Value",
          VR.kFL,
          VM.k1,
          false);
  static const DED kMinimumSensitivityValue
      //(0024,0105)
      = const DED(
          "MinimumSensitivityValue", 0x00240105, "Minimum Sensitivity Value", VR.kFL, VM.k1, false);
  static const DED kBlindSpotLocalized
      //(0024,0106)
      =
      const DED("BlindSpotLocalized", 0x00240106, "Blind Spot Localized", VR.kCS, VM.k1, false);
  static const DED kBlindSpotXCoordinate
      //(0024,0107)
      = const DED(
          "BlindSpotXCoordinate", 0x00240107, "Blind Spot X-Coordinate", VR.kFL, VM.k1, false);
  static const DED kBlindSpotYCoordinate
      //(0024,0108)
      = const DED(
          "BlindSpotYCoordinate", 0x00240108, "Blind Spot Y-Coordinate", VR.kFL, VM.k1, false);
  static const DED kVisualAcuityMeasurementSequence
      //(0024,0110)
      = const DED("VisualAcuityMeasurementSequence", 0x00240110,
          "Visual Acuity Measurement Sequence", VR.kSQ, VM.k1, false);
  static const DED kRefractiveParametersUsedOnPatientSequence
      //(0024,0112)
      = const DED("RefractiveParametersUsedOnPatientSequence", 0x00240112,
          "Refractive Parameters Used on Patient Sequence", VR.kSQ, VM.k1, false);
  static const DED kMeasurementLaterality
      //(0024,0113)
      = const DED(
          "MeasurementLaterality", 0x00240113, "Measurement Laterality", VR.kCS, VM.k1, false);
  static const DED kOphthalmicPatientClinicalInformationLeftEyeSequence
      //(0024,0114)
      = const DED("OphthalmicPatientClinicalInformationLeftEyeSequence", 0x00240114,
          "Ophthalmic Patient Clinical Information Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kOphthalmicPatientClinicalInformationRightEyeSequence
      //(0024,0115)
      = const DED("OphthalmicPatientClinicalInformationRightEyeSequence", 0x00240115,
          "Ophthalmic Patient Clinical Information Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kFovealPointNormativeDataFlag
      //(0024,0117)
      = const DED("FovealPointNormativeDataFlag", 0x00240117,
          "Foveal Point Normative Data Flag", VR.kCS, VM.k1, false);
  static const DED kFovealPointProbabilityValue
      //(0024,0118)
      = const DED("FovealPointProbabilityValue", 0x00240118, "Foveal Point Probability Value",
          VR.kFL, VM.k1, false);
  static const DED kScreeningBaselineMeasured
      //(0024,0120)
      = const DED("ScreeningBaselineMeasured", 0x00240120, "Screening Baseline Measured",
          VR.kCS, VM.k1, false);
  static const DED kScreeningBaselineMeasuredSequence
      //(0024,0122)
      = const DED("ScreeningBaselineMeasuredSequence", 0x00240122,
          "Screening Baseline Measured Sequence", VR.kSQ, VM.k1, false);
  static const DED kScreeningBaselineType
      //(0024,0124)
      = const DED(
          "ScreeningBaselineType", 0x00240124, "Screening Baseline Type", VR.kCS, VM.k1, false);
  static const DED kScreeningBaselineValue
      //(0024,0126)
      = const DED(
          "ScreeningBaselineValue", 0x00240126, "Screening Baseline Value", VR.kFL, VM.k1, false);
  static const DED kAlgorithmSource
      //(0024,0202)
      = const DED("AlgorithmSource", 0x00240202, "Algorithm Source", VR.kLO, VM.k1, false);
  static const DED kDataSetName
      //(0024,0306)
      = const DED("DataSetName", 0x00240306, "Data Set Name", VR.kLO, VM.k1, false);
  static const DED kDataSetVersion
      //(0024,0307)
      = const DED("DataSetVersion", 0x00240307, "Data Set Version", VR.kLO, VM.k1, false);
  static const DED kDataSetSource
      //(0024,0308)
      = const DED("DataSetSource", 0x00240308, "Data Set Source", VR.kLO, VM.k1, false);
  static const DED kDataSetDescription
      //(0024,0309)
      =
      const DED("DataSetDescription", 0x00240309, "Data Set Description", VR.kLO, VM.k1, false);
  static const DED kVisualFieldTestReliabilityGlobalIndexSequence
      //(0024,0317)
      = const DED("VisualFieldTestReliabilityGlobalIndexSequence", 0x00240317,
          "Visual Field Test Reliability Global Index Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualFieldGlobalResultsIndexSequence
      //(0024,0320)
      = const DED("VisualFieldGlobalResultsIndexSequence", 0x00240320,
          "Visual Field Global Results Index Sequence", VR.kSQ, VM.k1, false);
  static const DED kDataObservationSequence
      //(0024,0325)
      = const DED(
          "DataObservationSequence", 0x00240325, "Data Observation Sequence", VR.kSQ, VM.k1, false);
  static const DED kIndexNormalsFlag
      //(0024,0338)
      = const DED("IndexNormalsFlag", 0x00240338, "Index Normals Flag", VR.kCS, VM.k1, false);
  static const DED kIndexProbability
      //(0024,0341)
      = const DED("IndexProbability", 0x00240341, "Index Probability", VR.kFL, VM.k1, false);
  static const DED kIndexProbabilitySequence
      //(0024,0344)
      = const DED("IndexProbabilitySequence", 0x00240344, "Index Probability Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSamplesPerPixel
      //(0028,0002)
      = const DED("SamplesPerPixel", 0x00280002, "Samples per Pixel", VR.kUS, VM.k1, false);
  static const DED kSamplesPerPixelUsed
      //(0028,0003)
      = const DED(
          "SamplesPerPixelUsed", 0x00280003, "Samples per Pixel Used", VR.kUS, VM.k1, false);
  static const DED kPhotometricInterpretation
      //(0028,0004)
      = const DED("PhotometricInterpretation", 0x00280004, "Photometric Interpretation", VR.kCS,
          VM.k1, false);
  static const DED kImageDimensions
      //(0028,0005)
      = const DED("ImageDimensions", 0x00280005, "Image Dimensions", VR.kUS, VM.k1, true);
  static const DED kPlanarConfiguration
      //(0028,0006)
      = const DED(
          "PlanarConfiguration", 0x00280006, "Planar Configuration", VR.kUS, VM.k1, false);
  static const DED kNumberOfFrames
      //(0028,0008)
      = const DED("NumberOfFrames", 0x00280008, "Number of Frames", VR.kIS, VM.k1, false);
  static const DED kFrameIncrementPointer
      //(0028,0009)
      = const DED(
          "FrameIncrementPointer", 0x00280009, "Frame Increment Pointer", VR.kAT, VM.k1_n, false);
  static const DED kFrameDimensionPointer
      //(0028,000A)
      = const DED(
          "FrameDimensionPointer", 0x0028000A, "Frame Dimension Pointer", VR.kAT, VM.k1_n, false);
  static const DED kRows
      //(0028,0010)
      = const DED("Rows", 0x00280010, "Rows", VR.kUS, VM.k1, false);
  static const DED kColumns
      //(0028,0011)
      = const DED("Columns", 0x00280011, "Columns", VR.kUS, VM.k1, false);
  static const DED kPlanes
      //(0028,0012)
      = const DED("Planes", 0x00280012, "Planes", VR.kUS, VM.k1, true);
  static const DED kUltrasoundColorDataPresent
      //(0028,0014)
      = const DED("UltrasoundColorDataPresent", 0x00280014, "Ultrasound Color Data Present",
          VR.kUS, VM.k1, false);
  static const DED kNoName1
      //(0028,0020)
      = const DED("NoName1", 0x00280020, "See Note 3", VR.kNoVR, VM.kNoVM, true);
  static const DED kPixelSpacing
      //(0028,0030)
      = const DED("PixelSpacing", 0x00280030, "Pixel Spacing", VR.kDS, VM.k2, false);
  static const DED kZoomFactor
      //(0028,0031)
      = const DED("ZoomFactor", 0x00280031, "Zoom Factor", VR.kDS, VM.k2, false);
  static const DED kZoomCenter
      //(0028,0032)
      = const DED("ZoomCenter", 0x00280032, "Zoom Center", VR.kDS, VM.k2, false);
  static const DED kPixelAspectRatio
      //(0028,0034)
      = const DED("PixelAspectRatio", 0x00280034, "Pixel Aspect Ratio", VR.kIS, VM.k2, false);
  static const DED kImageFormat
      //(0028,0040)
      = const DED("ImageFormat", 0x00280040, "Image Format", VR.kCS, VM.k1, true);
  static const DED kManipulatedImage
      //(0028,0050)
      = const DED("ManipulatedImage", 0x00280050, "Manipulated Image", VR.kLO, VM.k1_n, true);
  static const DED kCorrectedImage
      //(0028,0051)
      = const DED("CorrectedImage", 0x00280051, "Corrected Image", VR.kCS, VM.k1_n, false);
  static const DED kCompressionRecognitionCode
      //(0028,005F)
      = const DED("CompressionRecognitionCode", 0x0028005F, "Compression Recognition Code",
          VR.kLO, VM.k1, true);
  static const DED kCompressionCode
      //(0028,0060)
      = const DED("CompressionCode", 0x00280060, "Compression Code", VR.kCS, VM.k1, true);
  static const DED kCompressionOriginator
      //(0028,0061)
      = const DED(
          "CompressionOriginator", 0x00280061, "Compression Originator", VR.kSH, VM.k1, true);
  static const DED kCompressionLabel
      //(0028,0062)
      = const DED("CompressionLabel", 0x00280062, "Compression Label", VR.kLO, VM.k1, true);
  static const DED kCompressionDescription
      //(0028,0063)
      = const DED(
          "CompressionDescription", 0x00280063, "Compression Description", VR.kSH, VM.k1, true);
  static const DED kCompressionSequence
      //(0028,0065)
      = const DED(
          "CompressionSequence", 0x00280065, "Compression Sequence", VR.kCS, VM.k1_n, true);
  static const DED kCompressionStepPointers
      //(0028,0066)
      = const DED("CompressionStepPointers", 0x00280066, "Compression Step Pointers", VR.kAT,
          VM.k1_n, true);
  static const DED kRepeatInterval
      //(0028,0068)
      = const DED("RepeatInterval", 0x00280068, "Repeat Interval", VR.kUS, VM.k1, true);
  static const DED kBitsGrouped
      //(0028,0069)
      = const DED("BitsGrouped", 0x00280069, "Bits Grouped", VR.kUS, VM.k1, true);
  static const DED kPerimeterTable
      //(0028,0070)
      = const DED("PerimeterTable", 0x00280070, "Perimeter Table", VR.kUS, VM.k1_n, true);
  static const DED kPerimeterValue
      //(0028,0071)
      = const DED("PerimeterValue", 0x00280071, "Perimeter Value", VR.kUSSS, VM.k1, true);
  static const DED kPredictorRows
      //(0028,0080)
      = const DED("PredictorRows", 0x00280080, "Predictor Rows", VR.kUS, VM.k1, true);
  static const DED kPredictorColumns
      //(0028,0081)
      = const DED("PredictorColumns", 0x00280081, "Predictor Columns", VR.kUS, VM.k1, true);
  static const DED kPredictorConstants
      //(0028,0082)
      =
      const DED("PredictorConstants", 0x00280082, "Predictor Constants", VR.kUS, VM.k1_n, true);
  static const DED kBlockedPixels
      //(0028,0090)
      = const DED("BlockedPixels", 0x00280090, "Blocked Pixels", VR.kCS, VM.k1, true);
  static const DED kBlockRows
      //(0028,0091)
      = const DED("BlockRows", 0x00280091, "Block Rows", VR.kUS, VM.k1, true);
  static const DED kBlockColumns
      //(0028,0092)
      = const DED("BlockColumns", 0x00280092, "Block Columns", VR.kUS, VM.k1, true);
  static const DED kRowOverlap
      //(0028,0093)
      = const DED("RowOverlap", 0x00280093, "Row Overlap", VR.kUS, VM.k1, true);
  static const DED kColumnOverlap
      //(0028,0094)
      = const DED("ColumnOverlap", 0x00280094, "Column Overlap", VR.kUS, VM.k1, true);
  static const DED kBitsAllocated
      //(0028,0100)
      = const DED("BitsAllocated", 0x00280100, "Bits Allocated", VR.kUS, VM.k1, false);
  static const DED kBitsStored
      //(0028,0101)
      = const DED("BitsStored", 0x00280101, "Bits Stored", VR.kUS, VM.k1, false);
  static const DED kHighBit
      //(0028,0102)
      = const DED("HighBit", 0x00280102, "High Bit", VR.kUS, VM.k1, false);
  static const DED kPixelRepresentation
      //(0028,0103)
      = const DED(
          "PixelRepresentation", 0x00280103, "Pixel Representation", VR.kUS, VM.k1, false);
  static const DED kSmallestValidPixelValue
      //(0028,0104)
      = const DED("SmallestValidPixelValue", 0x00280104, "Smallest Valid Pixel Value", VR.kUSSS,
          VM.k1, true);
  static const DED kLargestValidPixelValue
      //(0028,0105)
      = const DED(
          "LargestValidPixelValue", 0x00280105, "Largest Valid Pixel Value", VR.kUSSS, VM.k1, true);
  static const DED kSmallestImagePixelValue
      //(0028,0106)
      = const DED("SmallestImagePixelValue", 0x00280106, "Smallest Image Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const DED kLargestImagePixelValue
      //(0028,0107)
      = const DED("LargestImagePixelValue", 0x00280107, "Largest Image Pixel Value", VR.kUSSS,
          VM.k1, false);
  static const DED kSmallestPixelValueInSeries
      //(0028,0108)
      = const DED("SmallestPixelValueInSeries", 0x00280108, "Smallest Pixel Value in Series",
          VR.kUSSS, VM.k1, false);
  static const DED kLargestPixelValueInSeries
      //(0028,0109)
      = const DED("LargestPixelValueInSeries", 0x00280109, "Largest Pixel Value in Series",
          VR.kUSSS, VM.k1, false);
  static const DED kSmallestImagePixelValueInPlane
      //(0028,0110)
      = const DED("SmallestImagePixelValueInPlane", 0x00280110,
          "Smallest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const DED kLargestImagePixelValueInPlane
      //(0028,0111)
      = const DED("LargestImagePixelValueInPlane", 0x00280111,
          "Largest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const DED kPixelPaddingValue
      //(0028,0120)
      =
      const DED("PixelPaddingValue", 0x00280120, "Pixel Padding Value", VR.kUSSS, VM.k1, false);
  static const DED kPixelPaddingRangeLimit
      //(0028,0121)
      = const DED("PixelPaddingRangeLimit", 0x00280121, "Pixel Padding Range Limit", VR.kUSSS,
          VM.k1, false);
  static const DED kImageLocation
      //(0028,0200)
      = const DED("ImageLocation", 0x00280200, "Image Location", VR.kUS, VM.k1, true);
  static const DED kQualityControlImage
      //(0028,0300)
      = const DED(
          "QualityControlImage", 0x00280300, "Quality Control Image", VR.kCS, VM.k1, false);
  static const DED kBurnedInAnnotation
      //(0028,0301)
      =
      const DED("BurnedInAnnotation", 0x00280301, "Burned In Annotation", VR.kCS, VM.k1, false);
  static const DED kRecognizableVisualFeatures
      //(0028,0302)
      = const DED("RecognizableVisualFeatures", 0x00280302, "Recognizable Visual Features",
          VR.kCS, VM.k1, false);
  static const DED kLongitudinalTemporalInformationModified
      //(0028,0303)
      = const DED("LongitudinalTemporalInformationModified", 0x00280303,
          "Longitudinal Temporal Information Modified", VR.kCS, VM.k1, false);
  static const DED kReferencedColorPaletteInstanceUID
      //(0028,0304)
      = const DED("ReferencedColorPaletteInstanceUID", 0x00280304,
          "Referenced Color Palette Instance UID", VR.kUI, VM.k1, false);
  static const DED kTransformLabel
      //(0028,0400)
      = const DED("TransformLabel", 0x00280400, "Transform Label", VR.kLO, VM.k1, true);
  static const DED kTransformVersionNumber
      //(0028,0401)
      = const DED(
          "TransformVersionNumber", 0x00280401, "Transform Version Number", VR.kLO, VM.k1, true);
  static const DED kNumberOfTransformSteps
      //(0028,0402)
      = const DED(
          "NumberOfTransformSteps", 0x00280402, "Number of Transform Steps", VR.kUS, VM.k1, true);
  static const DED kSequenceOfCompressedData
      //(0028,0403)
      = const DED("SequenceOfCompressedData", 0x00280403, "Sequence of Compressed Data", VR.kLO,
          VM.k1_n, true);
  static const DED kDetailsOfCoefficients
      //(0028,0404)
      = const DED(
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
  static const DED kDCTLabel
      //(0028,0700)
      = const DED("DCTLabel", 0x00280700, "DCT Label", VR.kLO, VM.k1, true);
  static const DED kDataBlockDescription
      //(0028,0701)
      = const DED(
          "DataBlockDescription", 0x00280701, "Data Block Description", VR.kCS, VM.k1_n, true);
  static const DED kDataBlock
      //(0028,0702)
      = const DED("DataBlock", 0x00280702, "Data Block", VR.kAT, VM.k1_n, true);
  static const DED kNormalizationFactorFormat
      //(0028,0710)
      = const DED("NormalizationFactorFormat", 0x00280710, "Normalization Factor Format",
          VR.kUS, VM.k1, true);
  static const DED kZonalMapNumberFormat
      //(0028,0720)
      = const DED(
          "ZonalMapNumberFormat", 0x00280720, "Zonal Map Number Format", VR.kUS, VM.k1, true);
  static const DED kZonalMapLocation
      //(0028,0721)
      = const DED("ZonalMapLocation", 0x00280721, "Zonal Map Location", VR.kAT, VM.k1_n, true);
  static const DED kZonalMapFormat
      //(0028,0722)
      = const DED("ZonalMapFormat", 0x00280722, "Zonal Map Format", VR.kUS, VM.k1, true);
  static const DED kAdaptiveMapFormat
      //(0028,0730)
      = const DED("AdaptiveMapFormat", 0x00280730, "Adaptive Map Format", VR.kUS, VM.k1, true);
  static const DED kCodeNumberFormat
      //(0028,0740)
      = const DED("CodeNumberFormat", 0x00280740, "Code Number Format", VR.kUS, VM.k1, true);
  static const DED kCodeLabel
      //(0028,0800)
      = const DED("CodeLabel", 0x00280800, "Code Label", VR.kCS, VM.k1_n, true);
  static const DED kNumberOfTables
      //(0028,0802)
      = const DED("NumberOfTables", 0x00280802, "Number of Tables", VR.kUS, VM.k1, true);
  static const DED kCodeTableLocation
      //(0028,0803)
      =
      const DED("CodeTableLocation", 0x00280803, "Code Table Location", VR.kAT, VM.k1_n, true);
  static const DED kBitsForCodeWord
      //(0028,0804)
      = const DED("BitsForCodeWord", 0x00280804, "Bits For Code Word", VR.kUS, VM.k1, true);
  static const DED kImageDataLocation
      //(0028,0808)
      =
      const DED("ImageDataLocation", 0x00280808, "Image Data Location", VR.kAT, VM.k1_n, true);
  static const DED kPixelSpacingCalibrationType
      //(0028,0A02)
      = const DED("PixelSpacingCalibrationType", 0x00280A02, "Pixel Spacing Calibration Type",
          VR.kCS, VM.k1, false);
  static const DED kPixelSpacingCalibrationDescription
      //(0028,0A04)
      = const DED("PixelSpacingCalibrationDescription", 0x00280A04,
          "Pixel Spacing Calibration Description", VR.kLO, VM.k1, false);
  static const DED kPixelIntensityRelationship
      //(0028,1040)
      = const DED("PixelIntensityRelationship", 0x00281040, "Pixel Intensity Relationship",
          VR.kCS, VM.k1, false);
  static const DED kPixelIntensityRelationshipSign
      //(0028,1041)
      = const DED("PixelIntensityRelationshipSign", 0x00281041,
          "Pixel Intensity Relationship Sign", VR.kSS, VM.k1, false);
  static const DED kWindowCenter
      //(0028,1050)
      = const DED("WindowCenter", 0x00281050, "Window Center", VR.kDS, VM.k1_n, false);
  static const DED kWindowWidth
      //(0028,1051)
      = const DED("WindowWidth", 0x00281051, "Window Width", VR.kDS, VM.k1_n, false);
  static const DED kRescaleIntercept
      //(0028,1052)
      = const DED("RescaleIntercept", 0x00281052, "Rescale Intercept", VR.kDS, VM.k1, false);
  static const DED kRescaleSlope
      //(0028,1053)
      = const DED("RescaleSlope", 0x00281053, "Rescale Slope", VR.kDS, VM.k1, false);
  static const DED kRescaleType
      //(0028,1054)
      = const DED("RescaleType", 0x00281054, "Rescale Type", VR.kLO, VM.k1, false);
  static const DED kWindowCenterWidthExplanation
      //(0028,1055)
      = const DED("WindowCenterWidthExplanation", 0x00281055,
          "Window Center & Width Explanation", VR.kLO, VM.k1_n, false);
  static const DED kVOILUTFunction
      //(0028,1056)
      = const DED("VOILUTFunction", 0x00281056, "VOI LUT Function", VR.kCS, VM.k1, false);
  static const DED kGrayScale
      //(0028,1080)
      = const DED("GrayScale", 0x00281080, "Gray Scale", VR.kCS, VM.k1, true);
  static const DED kRecommendedViewingMode
      //(0028,1090)
      = const DED(
          "RecommendedViewingMode", 0x00281090, "Recommended Viewing Mode", VR.kCS, VM.k1, false);
  static const DED kGrayLookupTableDescriptor
      //(0028,1100)
      = const DED("GrayLookupTableDescriptor", 0x00281100, "Gray Lookup Table Descriptor",
          VR.kUSSS, VM.k3, true);
  static const DED kRedPaletteColorLookupTableDescriptor
      //(0028,1101)
      = const DED("RedPaletteColorLookupTableDescriptor", 0x00281101,
          "Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const DED kGreenPaletteColorLookupTableDescriptor
      //(0028,1102)
      = const DED("GreenPaletteColorLookupTableDescriptor", 0x00281102,
          "Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const DED kBluePaletteColorLookupTableDescriptor
      //(0028,1103)
      = const DED("BluePaletteColorLookupTableDescriptor", 0x00281103,
          "Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const DED kAlphaPaletteColorLookupTableDescriptor
      //(0028,1104)
      = const DED("AlphaPaletteColorLookupTableDescriptor", 0x00281104,
          "AlphaPalette ColorLookup Table Descriptor", VR.kUS, VM.k3, false);
  static const DED kLargeRedPaletteColorLookupTableDescriptor
      //(0028,1111)
      = const DED("LargeRedPaletteColorLookupTableDescriptor", 0x00281111,
          "Large Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const DED kLargeGreenPaletteColorLookupTableDescriptor
      //(0028,1112)
      = const DED("LargeGreenPaletteColorLookupTableDescriptor", 0x00281112,
          "Large Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const DED kLargeBluePaletteColorLookupTableDescriptor
      //(0028,1113)
      = const DED("LargeBluePaletteColorLookupTableDescriptor", 0x00281113,
          "Large Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const DED kPaletteColorLookupTableUID
      //(0028,1199)
      = const DED("PaletteColorLookupTableUID", 0x00281199, "Palette Color Lookup Table UID",
          VR.kUI, VM.k1, false);
  static const DED kGrayLookupTableData
      //(0028,1200)
      = const DED(
          "GrayLookupTableData", 0x00281200, "Gray Lookup Table Data", VR.kUSSSOW, VM.k1_n, true);
  static const DED kRedPaletteColorLookupTableData
      //(0028,1201)
      = const DED("RedPaletteColorLookupTableData", 0x00281201,
          "Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kGreenPaletteColorLookupTableData
      //(0028,1202)
      = const DED("GreenPaletteColorLookupTableData", 0x00281202,
          "Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kBluePaletteColorLookupTableData
      //(0028,1203)
      = const DED("BluePaletteColorLookupTableData", 0x00281203,
          "Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kAlphaPaletteColorLookupTableData
      //(0028,1204)
      = const DED("AlphaPaletteColorLookupTableData", 0x00281204,
          "Alpha Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kLargeRedPaletteColorLookupTableData
      //(0028,1211)
      = const DED("LargeRedPaletteColorLookupTableData", 0x00281211,
          "Large Red Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const DED kLargeGreenPaletteColorLookupTableData
      //(0028,1212)
      = const DED("LargeGreenPaletteColorLookupTableData", 0x00281212,
          "Large Green Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const DED kLargeBluePaletteColorLookupTableData
      //(0028,1213)
      = const DED("LargeBluePaletteColorLookupTableData", 0x00281213,
          "Large Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const DED kLargePaletteColorLookupTableUID
      //(0028,1214)
      = const DED("LargePaletteColorLookupTableUID", 0x00281214,
          "Large Palette Color Lookup Table UID", VR.kUI, VM.k1, true);
  static const DED kSegmentedRedPaletteColorLookupTableData
      //(0028,1221)
      = const DED("SegmentedRedPaletteColorLookupTableData", 0x00281221,
          "Segmented Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kSegmentedGreenPaletteColorLookupTableData
      //(0028,1222)
      = const DED("SegmentedGreenPaletteColorLookupTableData", 0x00281222,
          "Segmented Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kSegmentedBluePaletteColorLookupTableData
      //(0028,1223)
      = const DED("SegmentedBluePaletteColorLookupTableData", 0x00281223,
          "Segmented Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const DED kBreastImplantPresent
      //(0028,1300)
      = const DED(
          "BreastImplantPresent", 0x00281300, "Breast Implant Present", VR.kCS, VM.k1, false);
  static const DED kPartialView
      //(0028,1350)
      = const DED("PartialView", 0x00281350, "Partial View", VR.kCS, VM.k1, false);
  static const DED kPartialViewDescription
      //(0028,1351)
      = const DED(
          "PartialViewDescription", 0x00281351, "Partial View Description", VR.kST, VM.k1, false);
  static const DED kPartialViewCodeSequence
      //(0028,1352)
      = const DED("PartialViewCodeSequence", 0x00281352, "Partial View Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSpatialLocationsPreserved
      //(0028,135A)
      = const DED("SpatialLocationsPreserved", 0x0028135A, "Spatial Locations Preserved",
          VR.kCS, VM.k1, false);
  static const DED kDataFrameAssignmentSequence
      //(0028,1401)
      = const DED("DataFrameAssignmentSequence", 0x00281401, "Data Frame Assignment Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kDataPathAssignment
      //(0028,1402)
      =
      const DED("DataPathAssignment", 0x00281402, "Data Path Assignment", VR.kCS, VM.k1, false);
  static const DED kBitsMappedToColorLookupTable
      //(0028,1403)
      = const DED("BitsMappedToColorLookupTable", 0x00281403,
          "Bits Mapped to Color Lookup Table", VR.kUS, VM.k1, false);
  static const DED kBlendingLUT1Sequence
      //(0028,1404)
      = const DED(
          "BlendingLUT1Sequence", 0x00281404, "Blending LUT 1 Sequence", VR.kSQ, VM.k1, false);
  static const DED kBlendingLUT1TransferFunction
      //(0028,1405)
      = const DED("BlendingLUT1TransferFunction", 0x00281405,
          "Blending LUT 1 Transfer Function", VR.kCS, VM.k1, false);
  static const DED kBlendingWeightConstant
      //(0028,1406)
      = const DED(
          "BlendingWeightConstant", 0x00281406, "Blending Weight Constant", VR.kFD, VM.k1, false);
  static const DED kBlendingLookupTableDescriptor
      //(0028,1407)
      = const DED("BlendingLookupTableDescriptor", 0x00281407,
          "Blending Lookup Table Descriptor", VR.kUS, VM.k3, false);
  static const DED kBlendingLookupTableData
      //(0028,1408)
      = const DED("BlendingLookupTableData", 0x00281408, "Blending Lookup Table Data", VR.kOW,
          VM.k1, false);
  static const DED kEnhancedPaletteColorLookupTableSequence
      //(0028,140B)
      = const DED("EnhancedPaletteColorLookupTableSequence", 0x0028140B,
          "Enhanced Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const DED kBlendingLUT2Sequence
      //(0028,140C)
      = const DED(
          "BlendingLUT2Sequence", 0x0028140C, "Blending LUT 2 Sequence", VR.kSQ, VM.k1, false);
  static const DED kBlendingLUT2TransferFunction
      //(0028,140D)
      = const DED("BlendingLUT2TransferFunction", 0x0028140D,
          "Blending LUT 2 Transfer Function", VR.kCS, VM.k1, false);
  static const DED kDataPathID
      //(0028,140E)
      = const DED("DataPathID", 0x0028140E, "Data Path ID", VR.kCS, VM.k1, false);
  static const DED kRGBLUTTransferFunction
      //(0028,140F)
      = const DED(
          "RGBLUTTransferFunction", 0x0028140F, "RGB LUT Transfer Function", VR.kCS, VM.k1, false);
  static const DED kAlphaLUTTransferFunction
      //(0028,1410)
      = const DED("AlphaLUTTransferFunction", 0x00281410, "Alpha LUT Transfer Function", VR.kCS,
          VM.k1, false);
  static const DED kICCProfile
      //(0028,2000)
      = const DED("ICCProfile", 0x00282000, "ICC Profile", VR.kOB, VM.k1, false);
  static const DED kLossyImageCompression
      //(0028,2110)
      = const DED(
          "LossyImageCompression", 0x00282110, "Lossy Image Compression", VR.kCS, VM.k1, false);
  static const DED kLossyImageCompressionRatio
      //(0028,2112)
      = const DED("LossyImageCompressionRatio", 0x00282112, "Lossy Image Compression Ratio",
          VR.kDS, VM.k1_n, false);
  static const DED kLossyImageCompressionMethod
      //(0028,2114)
      = const DED("LossyImageCompressionMethod", 0x00282114, "Lossy Image Compression Method",
          VR.kCS, VM.k1_n, false);
  static const DED kModalityLUTSequence
      //(0028,3000)
      = const DED(
          "ModalityLUTSequence", 0x00283000, "Modality LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kLUTDescriptor
      //(0028,3002)
      = const DED("LUTDescriptor", 0x00283002, "LUT Descriptor", VR.kUSSS, VM.k3, false);
  static const DED kLUTExplanation
      //(0028,3003)
      = const DED("LUTExplanation", 0x00283003, "LUT Explanation", VR.kLO, VM.k1, false);
  static const DED kModalityLUTType
      //(0028,3004)
      = const DED("ModalityLUTType", 0x00283004, "Modality LUT Type", VR.kLO, VM.k1, false);
  static const DED kLUTData
      //(0028,3006)
      = const DED("LUTData", 0x00283006, "LUT Data", VR.kUSOW, VM.k1_n, false);
  static const DED kVOILUTSequence
      //(0028,3010)
      = const DED("VOILUTSequence", 0x00283010, "VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kSoftcopyVOILUTSequence
      //(0028,3110)
      = const DED(
          "SoftcopyVOILUTSequence", 0x00283110, "Softcopy VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kImagePresentationComments
      //(0028,4000)
      = const DED("ImagePresentationComments", 0x00284000, "Image Presentation Comments",
          VR.kLT, VM.k1, true);
  static const DED kBiPlaneAcquisitionSequence
      //(0028,5000)
      = const DED("BiPlaneAcquisitionSequence", 0x00285000, "Bi-Plane Acquisition Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kRepresentativeFrameNumber
      //(0028,6010)
      = const DED("RepresentativeFrameNumber", 0x00286010, "Representative Frame Number",
          VR.kUS, VM.k1, false);
  static const DED kFrameNumbersOfInterest
      //(0028,6020)
      = const DED("FrameNumbersOfInterest", 0x00286020, "Frame Numbers of Interest (FOI)",
          VR.kUS, VM.k1_n, false);
  static const DED kFrameOfInterestDescription
      //(0028,6022)
      = const DED("FrameOfInterestDescription", 0x00286022, "Frame of Interest Description",
          VR.kLO, VM.k1_n, false);
  static const DED kFrameOfInterestType
      //(0028,6023)
      = const DED(
          "FrameOfInterestType", 0x00286023, "Frame of Interest Type", VR.kCS, VM.k1_n, false);
  static const DED kMaskPointers
      //(0028,6030)
      = const DED("MaskPointers", 0x00286030, "Mask Pointer(s)", VR.kUS, VM.k1_n, true);
  static const DED kRWavePointer
      //(0028,6040)
      = const DED("RWavePointer", 0x00286040, "R Wave Pointer", VR.kUS, VM.k1_n, false);
  static const DED kMaskSubtractionSequence
      //(0028,6100)
      = const DED(
          "MaskSubtractionSequence", 0x00286100, "Mask Subtraction Sequence", VR.kSQ, VM.k1, false);
  static const DED kMaskOperation
      //(0028,6101)
      = const DED("MaskOperation", 0x00286101, "Mask Operation", VR.kCS, VM.k1, false);
  static const DED kApplicableFrameRange
      //(0028,6102)
      = const DED(
          "ApplicableFrameRange", 0x00286102, "Applicable Frame Range", VR.kUS, VM.k2_2n, false);
  static const DED kMaskFrameNumbers
      //(0028,6110)
      = const DED("MaskFrameNumbers", 0x00286110, "Mask Frame Numbers", VR.kUS, VM.k1_n, false);
  static const DED kContrastFrameAveraging
      //(0028,6112)
      = const DED(
          "ContrastFrameAveraging", 0x00286112, "Contrast Frame Averaging", VR.kUS, VM.k1, false);
  static const DED kMaskSubPixelShift
      //(0028,6114)
      =
      const DED("MaskSubPixelShift", 0x00286114, "Mask Sub-pixel Shift", VR.kFL, VM.k2, false);
  static const DED kTIDOffset
      //(0028,6120)
      = const DED("TIDOffset", 0x00286120, "TID Offset", VR.kSS, VM.k1, false);
  static const DED kMaskOperationExplanation
      //(0028,6190)
      = const DED("MaskOperationExplanation", 0x00286190, "Mask Operation Explanation", VR.kST,
          VM.k1, false);
  static const DED kPixelDataProviderURL
      //(0028,7FE0)
      = const DED(
          "PixelDataProviderURL", 0x00287FE0, "Pixel Data Provider URL", VR.kUT, VM.k1, false);
  static const DED kDataPointRows
      //(0028,9001)
      = const DED("DataPointRows", 0x00289001, "Data Point Rows", VR.kUL, VM.k1, false);
  static const DED kDataPointColumns
      //(0028,9002)
      = const DED("DataPointColumns", 0x00289002, "Data Point Columns", VR.kUL, VM.k1, false);
  static const DED kSignalDomainColumns
      //(0028,9003)
      = const DED(
          "SignalDomainColumns", 0x00289003, "Signal Domain Columns", VR.kCS, VM.k1, false);
  static const DED kLargestMonochromePixelValue
      //(0028,9099)
      = const DED("LargestMonochromePixelValue", 0x00289099, "Largest Monochrome Pixel Value",
          VR.kUS, VM.k1, true);
  static const DED kDataRepresentation
      //(0028,9108)
      =
      const DED("DataRepresentation", 0x00289108, "Data Representation", VR.kCS, VM.k1, false);
  static const DED kPixelMeasuresSequence
      //(0028,9110)
      = const DED(
          "PixelMeasuresSequence", 0x00289110, "Pixel Measures Sequence", VR.kSQ, VM.k1, false);
  static const DED kFrameVOILUTSequence
      //(0028,9132)
      = const DED(
          "FrameVOILUTSequence", 0x00289132, "Frame VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kPixelValueTransformationSequence
      //(0028,9145)
      = const DED("PixelValueTransformationSequence", 0x00289145,
          "Pixel Value Transformation Sequence", VR.kSQ, VM.k1, false);
  static const DED kSignalDomainRows
      //(0028,9235)
      = const DED("SignalDomainRows", 0x00289235, "Signal Domain Rows", VR.kCS, VM.k1, false);
  static const DED kDisplayFilterPercentage
      //(0028,9411)
      = const DED("DisplayFilterPercentage", 0x00289411, "Display Filter Percentage",
          VR.kFL, VM.k1, false);
  static const DED kFramePixelShiftSequence
      //(0028,9415)
      = const DED("FramePixelShiftSequence", 0x00289415, "Frame Pixel Shift Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSubtractionItemID
      //(0028,9416)
      = const DED("SubtractionItemID", 0x00289416, "Subtraction Item ID", VR.kUS, VM.k1, false);
  static const DED kPixelIntensityRelationshipLUTSequence
      //(0028,9422)
      = const DED("PixelIntensityRelationshipLUTSequence", 0x00289422,
          "Pixel Intensity Relationship LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kFramePixelDataPropertiesSequence
      //(0028,9443)
      = const DED("FramePixelDataPropertiesSequence", 0x00289443,
          "Frame Pixel Data Properties Sequence", VR.kSQ, VM.k1, false);
  static const DED kGeometricalProperties
      //(0028,9444)
      = const DED(
          "GeometricalProperties", 0x00289444, "Geometrical Properties", VR.kCS, VM.k1, false);
  static const DED kGeometricMaximumDistortion
      //(0028,9445)
      = const DED("GeometricMaximumDistortion", 0x00289445, "Geometric Maximum Distortion",
          VR.kFL, VM.k1, false);
  static const DED kImageProcessingApplied
      //(0028,9446)
      = const DED(
          "ImageProcessingApplied", 0x00289446, "Image Processing Applied", VR.kCS, VM.k1_n, false);
  static const DED kMaskSelectionMode
      //(0028,9454)
      = const DED("MaskSelectionMode", 0x00289454, "Mask Selection Mode", VR.kCS, VM.k1, false);
  static const DED kLUTFunction
      //(0028,9474)
      = const DED("LUTFunction", 0x00289474, "LUT Function", VR.kCS, VM.k1, false);
  static const DED kMaskVisibilityPercentage
      //(0028,9478)
      = const DED("MaskVisibilityPercentage", 0x00289478, "Mask Visibility Percentage",
          VR.kFL, VM.k1, false);
  static const DED kPixelShiftSequence
      //(0028,9501)
      =
      const DED("PixelShiftSequence", 0x00289501, "Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const DED kRegionPixelShiftSequence
      //(0028,9502)
      = const DED("RegionPixelShiftSequence", 0x00289502, "Region Pixel Shift Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kVerticesOfTheRegion
      //(0028,9503)
      = const DED(
          "VerticesOfTheRegion", 0x00289503, "Vertices of the Region", VR.kSS, VM.k2_2n, false);
  static const DED kMultiFramePresentationSequence
      //(0028,9505)
      = const DED("MultiFramePresentationSequence", 0x00289505,
          "Multi-frame Presentation Sequence", VR.kSQ, VM.k1, false);
  static const DED kPixelShiftFrameRange
      //(0028,9506)
      = const DED(
          "PixelShiftFrameRange", 0x00289506, "Pixel Shift Frame Range", VR.kUS, VM.k2_2n, false);
  static const DED kLUTFrameRange
      //(0028,9507)
      = const DED("LUTFrameRange", 0x00289507, "LUT Frame Range", VR.kUS, VM.k2_2n, false);
  static const DED kImageToEquipmentMappingMatrix
      //(0028,9520)
      = const DED("ImageToEquipmentMappingMatrix", 0x00289520,
          "Image to Equipment Mapping Matrix", VR.kDS, VM.k16, false);
  static const DED kEquipmentCoordinateSystemIdentification
      //(0028,9537)
      = const DED("EquipmentCoordinateSystemIdentification", 0x00289537,
          "Equipment Coordinate System Identification", VR.kCS, VM.k1, false);
  static const DED kStudyStatusID
      //(0032,000A)
      = const DED("StudyStatusID", 0x0032000A, "Study Status ID", VR.kCS, VM.k1, true);
  static const DED kStudyPriorityID
      //(0032,000C)
      = const DED("StudyPriorityID", 0x0032000C, "Study Priority ID", VR.kCS, VM.k1, true);
  static const DED kStudyIDIssuer
      //(0032,0012)
      = const DED("StudyIDIssuer", 0x00320012, "Study ID Issuer", VR.kLO, VM.k1, true);
  static const DED kStudyVerifiedDate
      //(0032,0032)
      = const DED("StudyVerifiedDate", 0x00320032, "Study Verified Date", VR.kDA, VM.k1, true);
  static const DED kStudyVerifiedTime
      //(0032,0033)
      = const DED("StudyVerifiedTime", 0x00320033, "Study Verified Time", VR.kTM, VM.k1, true);
  static const DED kStudyReadDate
      //(0032,0034)
      = const DED("StudyReadDate", 0x00320034, "Study Read Date", VR.kDA, VM.k1, true);
  static const DED kStudyReadTime
      //(0032,0035)
      = const DED("StudyReadTime", 0x00320035, "Study Read Time", VR.kTM, VM.k1, true);
  static const DED kScheduledStudyStartDate
      //(0032,1000)
      = const DED(
          "ScheduledStudyStartDate", 0x00321000, "Scheduled Study Start Date", VR.kDA, VM.k1, true);
  static const DED kScheduledStudyStartTime
      //(0032,1001)
      = const DED(
          "ScheduledStudyStartTime", 0x00321001, "Scheduled Study Start Time", VR.kTM, VM.k1, true);
  static const DED kScheduledStudyStopDate
      //(0032,1010)
      = const DED(
          "ScheduledStudyStopDate", 0x00321010, "Scheduled Study Stop Date", VR.kDA, VM.k1, true);
  static const DED kScheduledStudyStopTime
      //(0032,1011)
      = const DED(
          "ScheduledStudyStopTime", 0x00321011, "Scheduled Study Stop Time", VR.kTM, VM.k1, true);
  static const DED kScheduledStudyLocation
      //(0032,1020)
      = const DED(
          "ScheduledStudyLocation", 0x00321020, "Scheduled Study Location", VR.kLO, VM.k1, true);
  static const DED kScheduledStudyLocationAETitle
      //(0032,1021)
      = const DED("ScheduledStudyLocationAETitle", 0x00321021,
          "Scheduled Study Location AE Title", VR.kAE, VM.k1_n, true);
  static const DED kReasonForStudy
      //(0032,1030)
      = const DED("ReasonForStudy", 0x00321030, "Reason for Study", VR.kLO, VM.k1, true);
  static const DED kRequestingPhysicianIdentificationSequence
      //(0032,1031)
      = const DED("RequestingPhysicianIdentificationSequence", 0x00321031,
          "Requesting Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kRequestingPhysician
      //(0032,1032)
      = const DED(
          "RequestingPhysician", 0x00321032, "Requesting Physician", VR.kPN, VM.k1, false);
  static const DED kRequestingService
      //(0032,1033)
      = const DED("RequestingService", 0x00321033, "Requesting Service", VR.kLO, VM.k1, false);
  static const DED kRequestingServiceCodeSequence
      //(0032,1034)
      = const DED("RequestingServiceCodeSequence", 0x00321034,
          "Requesting Service Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kStudyArrivalDate
      //(0032,1040)
      = const DED("StudyArrivalDate", 0x00321040, "Study Arrival Date", VR.kDA, VM.k1, true);
  static const DED kStudyArrivalTime
      //(0032,1041)
      = const DED("StudyArrivalTime", 0x00321041, "Study Arrival Time", VR.kTM, VM.k1, true);
  static const DED kStudyCompletionDate
      //(0032,1050)
      = const DED(
          "StudyCompletionDate", 0x00321050, "Study Completion Date", VR.kDA, VM.k1, true);
  static const DED kStudyCompletionTime
      //(0032,1051)
      = const DED(
          "StudyCompletionTime", 0x00321051, "Study Completion Time", VR.kTM, VM.k1, true);
  static const DED kStudyComponentStatusID
      //(0032,1055)
      = const DED(
          "StudyComponentStatusID", 0x00321055, "Study Component Status ID", VR.kCS, VM.k1, true);
  static const DED kRequestedProcedureDescription
      //(0032,1060)
      = const DED("RequestedProcedureDescription", 0x00321060,
          "Requested Procedure Description", VR.kLO, VM.k1, false);
  static const DED kRequestedProcedureCodeSequence
      //(0032,1064)
      = const DED("RequestedProcedureCodeSequence", 0x00321064,
          "Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRequestedContrastAgent
      //(0032,1070)
      = const DED("RequestedContrastAgent", 0x00321070, "Requested Contrast Agent", VR.kLO,
          VM.k1, false);
  static const DED kStudyComments
      //(0032,4000)
      = const DED("StudyComments", 0x00324000, "Study Comments", VR.kLT, VM.k1, true);
  static const DED kReferencedPatientAliasSequence
      //(0038,0004)
      = const DED("ReferencedPatientAliasSequence", 0x00380004,
          "Referenced Patient Alias Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisitStatusID
      //(0038,0008)
      = const DED("VisitStatusID", 0x00380008, "Visit Status ID", VR.kCS, VM.k1, false);
  static const DED kAdmissionID
      //(0038,0010)
      = const DED("AdmissionID", 0x00380010, "Admission ID", VR.kLO, VM.k1, false);
  static const DED kIssuerOfAdmissionID
      //(0038,0011)
      = const DED(
          "IssuerOfAdmissionID", 0x00380011, "Issuer of Admission ID", VR.kLO, VM.k1, true);
  static const DED kIssuerOfAdmissionIDSequence
      //(0038,0014)
      = const DED("IssuerOfAdmissionIDSequence", 0x00380014, "Issuer of Admission ID Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRouteOfAdmissions
      //(0038,0016)
      = const DED("RouteOfAdmissions", 0x00380016, "Route of Admissions", VR.kLO, VM.k1, false);
  static const DED kScheduledAdmissionDate
      //(0038,001A)
      = const DED(
          "ScheduledAdmissionDate", 0x0038001A, "Scheduled Admission Date", VR.kDA, VM.k1, true);
  static const DED kScheduledAdmissionTime
      //(0038,001B)
      = const DED(
          "ScheduledAdmissionTime", 0x0038001B, "Scheduled Admission Time", VR.kTM, VM.k1, true);
  static const DED kScheduledDischargeDate
      //(0038,001C)
      = const DED(
          "ScheduledDischargeDate", 0x0038001C, "Scheduled Discharge Date", VR.kDA, VM.k1, true);
  static const DED kScheduledDischargeTime
      //(0038,001D)
      = const DED(
          "ScheduledDischargeTime", 0x0038001D, "Scheduled Discharge Time", VR.kTM, VM.k1, true);
  static const DED kScheduledPatientInstitutionResidence
      //(0038,001E)
      = const DED("ScheduledPatientInstitutionResidence", 0x0038001E,
          "Scheduled Patient Institution Residence", VR.kLO, VM.k1, true);
  static const DED kAdmittingDate
      //(0038,0020)
      = const DED("AdmittingDate", 0x00380020, "Admitting Date", VR.kDA, VM.k1, false);
  static const DED kAdmittingTime
      //(0038,0021)
      = const DED("AdmittingTime", 0x00380021, "Admitting Time", VR.kTM, VM.k1, false);
  static const DED kDischargeDate
      //(0038,0030)
      = const DED("DischargeDate", 0x00380030, "Discharge Date", VR.kDA, VM.k1, true);
  static const DED kDischargeTime
      //(0038,0032)
      = const DED("DischargeTime", 0x00380032, "Discharge Time", VR.kTM, VM.k1, true);
  static const DED kDischargeDiagnosisDescription
      //(0038,0040)
      = const DED("DischargeDiagnosisDescription", 0x00380040,
          "Discharge Diagnosis Description", VR.kLO, VM.k1, true);
  static const DED kDischargeDiagnosisCodeSequence
      //(0038,0044)
      = const DED("DischargeDiagnosisCodeSequence", 0x00380044,
          "Discharge Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kSpecialNeeds
      //(0038,0050)
      = const DED("SpecialNeeds", 0x00380050, "Special Needs", VR.kLO, VM.k1, false);
  static const DED kServiceEpisodeID
      //(0038,0060)
      = const DED("ServiceEpisodeID", 0x00380060, "Service Episode ID", VR.kLO, VM.k1, false);
  static const DED kIssuerOfServiceEpisodeID
      //(0038,0061)
      = const DED("IssuerOfServiceEpisodeID", 0x00380061, "Issuer of Service Episode ID",
          VR.kLO, VM.k1, true);
  static const DED kServiceEpisodeDescription
      //(0038,0062)
      = const DED("ServiceEpisodeDescription", 0x00380062, "Service Episode Description",
          VR.kLO, VM.k1, false);
  static const DED kIssuerOfServiceEpisodeIDSequence
      //(0038,0064)
      = const DED("IssuerOfServiceEpisodeIDSequence", 0x00380064,
          "Issuer of Service Episode ID Sequence", VR.kSQ, VM.k1, false);
  static const DED kPertinentDocumentsSequence
      //(0038,0100)
      = const DED("PertinentDocumentsSequence", 0x00380100, "Pertinent Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCurrentPatientLocation
      //(0038,0300)
      = const DED(
          "CurrentPatientLocation", 0x00380300, "Current Patient Location", VR.kLO, VM.k1, false);
  static const DED kPatientInstitutionResidence
      //(0038,0400)
      = const DED("PatientInstitutionResidence", 0x00380400, "Patient's Institution Residence",
          VR.kLO, VM.k1, false);
  static const DED kPatientState
      //(0038,0500)
      = const DED("PatientState", 0x00380500, "Patient State", VR.kLO, VM.k1, false);
  static const DED kPatientClinicalTrialParticipationSequence
      //(0038,0502)
      = const DED("PatientClinicalTrialParticipationSequence", 0x00380502,
          "Patient Clinical Trial Participation Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisitComments
      //(0038,4000)
      = const DED("VisitComments", 0x00384000, "Visit Comments", VR.kLT, VM.k1, false);
  static const DED kWaveformOriginality
      //(003A,0004)
      = const DED(
          "WaveformOriginality", 0x003A0004, "Waveform Originality", VR.kCS, VM.k1, false);
  static const DED kNumberOfWaveformChannels
      //(003A,0005)
      = const DED("NumberOfWaveformChannels", 0x003A0005, "Number of Waveform Channels", VR.kUS,
          VM.k1, false);
  static const DED kNumberOfWaveformSamples
      //(003A,0010)
      = const DED("NumberOfWaveformSamples", 0x003A0010, "Number of Waveform Samples", VR.kUL,
          VM.k1, false);
  static const DED kSamplingFrequency
      //(003A,001A)
      = const DED("SamplingFrequency", 0x003A001A, "Sampling Frequency", VR.kDS, VM.k1, false);
  static const DED kMultiplexGroupLabel
      //(003A,0020)
      = const DED(
          "MultiplexGroupLabel", 0x003A0020, "Multiplex Group Label", VR.kSH, VM.k1, false);
  static const DED kChannelDefinitionSequence
      //(003A,0200)
      = const DED("ChannelDefinitionSequence", 0x003A0200, "Channel Definition Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kWaveformChannelNumber
      //(003A,0202)
      = const DED(
          "WaveformChannelNumber", 0x003A0202, "Waveform Channel Number", VR.kIS, VM.k1, false);
  static const DED kChannelLabel
      //(003A,0203)
      = const DED("ChannelLabel", 0x003A0203, "Channel Label", VR.kSH, VM.k1, false);
  static const DED kChannelStatus
      //(003A,0205)
      = const DED("ChannelStatus", 0x003A0205, "Channel Status", VR.kCS, VM.k1_n, false);
  static const DED kChannelSourceSequence
      //(003A,0208)
      = const DED(
          "ChannelSourceSequence", 0x003A0208, "Channel Source Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelSourceModifiersSequence
      //(003A,0209)
      = const DED("ChannelSourceModifiersSequence", 0x003A0209,
          "Channel Source Modifiers Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceWaveformSequence
      //(003A,020A)
      = const DED(
          "SourceWaveformSequence", 0x003A020A, "Source Waveform Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelDerivationDescription
      //(003A,020C)
      = const DED("ChannelDerivationDescription", 0x003A020C, "Channel Derivation Description",
          VR.kLO, VM.k1, false);
  static const DED kChannelSensitivity
      //(003A,0210)
      =
      const DED("ChannelSensitivity", 0x003A0210, "Channel Sensitivity", VR.kDS, VM.k1, false);
  static const DED kChannelSensitivityUnitsSequence
      //(003A,0211)
      = const DED("ChannelSensitivityUnitsSequence", 0x003A0211,
          "Channel Sensitivity Units Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelSensitivityCorrectionFactor
      //(003A,0212)
      = const DED("ChannelSensitivityCorrectionFactor", 0x003A0212,
          "Channel Sensitivity Correction Factor", VR.kDS, VM.k1, false);
  static const DED kChannelBaseline
      //(003A,0213)
      = const DED("ChannelBaseline", 0x003A0213, "Channel Baseline", VR.kDS, VM.k1, false);
  static const DED kChannelTimeSkew
      //(003A,0214)
      = const DED("ChannelTimeSkew", 0x003A0214, "Channel Time Skew", VR.kDS, VM.k1, false);
  static const DED kChannelSampleSkew
      //(003A,0215)
      = const DED("ChannelSampleSkew", 0x003A0215, "Channel Sample Skew", VR.kDS, VM.k1, false);
  static const DED kChannelOffset
      //(003A,0218)
      = const DED("ChannelOffset", 0x003A0218, "Channel Offset", VR.kDS, VM.k1, false);
  static const DED kWaveformBitsStored
      //(003A,021A)
      =
      const DED("WaveformBitsStored", 0x003A021A, "Waveform Bits Stored", VR.kUS, VM.k1, false);
  static const DED kFilterLowFrequency
      //(003A,0220)
      =
      const DED("FilterLowFrequency", 0x003A0220, "Filter Low Frequency", VR.kDS, VM.k1, false);
  static const DED kFilterHighFrequency
      //(003A,0221)
      = const DED(
          "FilterHighFrequency", 0x003A0221, "Filter High Frequency", VR.kDS, VM.k1, false);
  static const DED kNotchFilterFrequency
      //(003A,0222)
      = const DED(
          "NotchFilterFrequency", 0x003A0222, "Notch Filter Frequency", VR.kDS, VM.k1, false);
  static const DED kNotchFilterBandwidth
      //(003A,0223)
      = const DED(
          "NotchFilterBandwidth", 0x003A0223, "Notch Filter Bandwidth", VR.kDS, VM.k1, false);
  static const DED kWaveformDataDisplayScale
      //(003A,0230)
      = const DED("WaveformDataDisplayScale", 0x003A0230, "Waveform Data Display Scale", VR.kFL,
          VM.k1, false);
  static const DED kWaveformDisplayBackgroundCIELabValue
      //(003A,0231)
      = const DED("WaveformDisplayBackgroundCIELabValue", 0x003A0231,
          "Waveform Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const DED kWaveformPresentationGroupSequence
      //(003A,0240)
      = const DED("WaveformPresentationGroupSequence", 0x003A0240,
          "Waveform Presentation Group Sequence", VR.kSQ, VM.k1, false);
  static const DED kPresentationGroupNumber
      //(003A,0241)
      = const DED(
          "PresentationGroupNumber", 0x003A0241, "Presentation Group Number", VR.kUS, VM.k1, false);
  static const DED kChannelDisplaySequence
      //(003A,0242)
      = const DED(
          "ChannelDisplaySequence", 0x003A0242, "Channel Display Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelRecommendedDisplayCIELabValue
      //(003A,0244)
      = const DED("ChannelRecommendedDisplayCIELabValue", 0x003A0244,
          "Channel Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const DED kChannelPosition
      //(003A,0245)
      = const DED("ChannelPosition", 0x003A0245, "Channel Position", VR.kFL, VM.k1, false);
  static const DED kDisplayShadingFlag
      //(003A,0246)
      =
      const DED("DisplayShadingFlag", 0x003A0246, "Display Shading Flag", VR.kCS, VM.k1, false);
  static const DED kFractionalChannelDisplayScale
      //(003A,0247)
      = const DED("FractionalChannelDisplayScale", 0x003A0247,
          "Fractional Channel Display Scale", VR.kFL, VM.k1, false);
  static const DED kAbsoluteChannelDisplayScale
      //(003A,0248)
      = const DED("AbsoluteChannelDisplayScale", 0x003A0248, "Absolute Channel Display Scale",
          VR.kFL, VM.k1, false);
  static const DED kMultiplexedAudioChannelsDescriptionCodeSequence
      //(003A,0300)
      = const DED("MultiplexedAudioChannelsDescriptionCodeSequence", 0x003A0300,
          "Multiplexed Audio Channels Description Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelIdentificationCode
      //(003A,0301)
      = const DED("ChannelIdentificationCode", 0x003A0301, "Channel Identification Code",
          VR.kIS, VM.k1, false);
  static const DED kChannelMode
      //(003A,0302)
      = const DED("ChannelMode", 0x003A0302, "Channel Mode", VR.kCS, VM.k1, false);
  static const DED kScheduledStationAETitle
      //(0040,0001)
      = const DED("ScheduledStationAETitle", 0x00400001, "Scheduled Station AE Title", VR.kAE,
          VM.k1_n, false);
  static const DED kScheduledProcedureStepStartDate
      //(0040,0002)
      = const DED("ScheduledProcedureStepStartDate", 0x00400002,
          "Scheduled Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const DED kScheduledProcedureStepStartTime
      //(0040,0003)
      = const DED("ScheduledProcedureStepStartTime", 0x00400003,
          "Scheduled Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const DED kScheduledProcedureStepEndDate
      //(0040,0004)
      = const DED("ScheduledProcedureStepEndDate", 0x00400004,
          "Scheduled Procedure Step End Date", VR.kDA, VM.k1, false);
  static const DED kScheduledProcedureStepEndTime
      //(0040,0005)
      = const DED("ScheduledProcedureStepEndTime", 0x00400005,
          "Scheduled Procedure Step End Time", VR.kTM, VM.k1, false);
  static const DED kScheduledPerformingPhysicianName
      //(0040,0006)
      = const DED("ScheduledPerformingPhysicianName", 0x00400006,
          "Scheduled Performing Physician's Name", VR.kPN, VM.k1, false);
  static const DED kScheduledProcedureStepDescription
      //(0040,0007)
      = const DED("ScheduledProcedureStepDescription", 0x00400007,
          "Scheduled Procedure Step Description", VR.kLO, VM.k1, false);
  static const DED kScheduledProtocolCodeSequence
      //(0040,0008)
      = const DED("ScheduledProtocolCodeSequence", 0x00400008,
          "Scheduled Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledProcedureStepID
      //(0040,0009)
      = const DED("ScheduledProcedureStepID", 0x00400009, "Scheduled Procedure Step ID", VR.kSH,
          VM.k1, false);
  static const DED kStageCodeSequence
      //(0040,000A)
      = const DED(
          "StageCodeSequence", 0x0040000A, "Stage Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledPerformingPhysicianIdentificationSequence
      //(0040,000B)
      = const DED("ScheduledPerformingPhysicianIdentificationSequence", 0x0040000B,
          "Scheduled Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledStationName
      //(0040,0010)
      = const DED(
          "ScheduledStationName", 0x00400010, "Scheduled Station Name", VR.kSH, VM.k1_n, false);
  static const DED kScheduledProcedureStepLocation
      //(0040,0011)
      = const DED("ScheduledProcedureStepLocation", 0x00400011,
          "Scheduled Procedure Step Location", VR.kSH, VM.k1, false);
  static const DED kPreMedication
      //(0040,0012)
      = const DED("PreMedication", 0x00400012, "Pre-Medication", VR.kLO, VM.k1, false);
  static const DED kScheduledProcedureStepStatus
      //(0040,0020)
      = const DED("ScheduledProcedureStepStatus", 0x00400020, "Scheduled Procedure Step Status",
          VR.kCS, VM.k1, false);
  static const DED kOrderPlacerIdentifierSequence
      //(0040,0026)
      = const DED("OrderPlacerIdentifierSequence", 0x00400026,
          "Order Placer Identifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kOrderFillerIdentifierSequence
      //(0040,0027)
      = const DED("OrderFillerIdentifierSequence", 0x00400027,
          "Order Filler Identifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kLocalNamespaceEntityID
      //(0040,0031)
      = const DED(
          "LocalNamespaceEntityID", 0x00400031, "Local Namespace Entity ID", VR.kUT, VM.k1, false);
  static const DED kUniversalEntityID
      //(0040,0032)
      = const DED("UniversalEntityID", 0x00400032, "Universal Entity ID", VR.kUT, VM.k1, false);
  static const DED kUniversalEntityIDType
      //(0040,0033)
      = const DED(
          "UniversalEntityIDType", 0x00400033, "Universal Entity ID Type", VR.kCS, VM.k1, false);
  static const DED kIdentifierTypeCode
      //(0040,0035)
      =
      const DED("IdentifierTypeCode", 0x00400035, "Identifier Type Code", VR.kCS, VM.k1, false);
  static const DED kAssigningFacilitySequence
      //(0040,0036)
      = const DED("AssigningFacilitySequence", 0x00400036, "Assigning Facility Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAssigningJurisdictionCodeSequence
      //(0040,0039)
      = const DED("AssigningJurisdictionCodeSequence", 0x00400039,
          "Assigning Jurisdiction Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kAssigningAgencyOrDepartmentCodeSequence
      //(0040,003A)
      = const DED("AssigningAgencyOrDepartmentCodeSequence", 0x0040003A,
          "Assigning Agency or Department Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledProcedureStepSequence
      //(0040,0100)
      = const DED("ScheduledProcedureStepSequence", 0x00400100,
          "Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedNonImageCompositeSOPInstanceSequence
      //(0040,0220)
      = const DED("ReferencedNonImageCompositeSOPInstanceSequence", 0x00400220,
          "Referenced Non-Image Composite SOP Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedStationAETitle
      //(0040,0241)
      = const DED("PerformedStationAETitle", 0x00400241, "Performed Station AE Title", VR.kAE,
          VM.k1, false);
  static const DED kPerformedStationName
      //(0040,0242)
      = const DED(
          "PerformedStationName", 0x00400242, "Performed Station Name", VR.kSH, VM.k1, false);
  static const DED kPerformedLocation
      //(0040,0243)
      = const DED("PerformedLocation", 0x00400243, "Performed Location", VR.kSH, VM.k1, false);
  static const DED kPerformedProcedureStepStartDate
      //(0040,0244)
      = const DED("PerformedProcedureStepStartDate", 0x00400244,
          "Performed Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const DED kPerformedProcedureStepStartTime
      //(0040,0245)
      = const DED("PerformedProcedureStepStartTime", 0x00400245,
          "Performed Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const DED kPerformedProcedureStepEndDate
      //(0040,0250)
      = const DED("PerformedProcedureStepEndDate", 0x00400250,
          "Performed Procedure Step End Date", VR.kDA, VM.k1, false);
  static const DED kPerformedProcedureStepEndTime
      //(0040,0251)
      = const DED("PerformedProcedureStepEndTime", 0x00400251,
          "Performed Procedure Step End Time", VR.kTM, VM.k1, false);
  static const DED kPerformedProcedureStepStatus
      //(0040,0252)
      = const DED("PerformedProcedureStepStatus", 0x00400252, "Performed Procedure Step Status",
          VR.kCS, VM.k1, false);
  static const DED kPerformedProcedureStepID
      //(0040,0253)
      = const DED("PerformedProcedureStepID", 0x00400253, "Performed Procedure Step ID", VR.kSH,
          VM.k1, false);
  static const DED kPerformedProcedureStepDescription
      //(0040,0254)
      = const DED("PerformedProcedureStepDescription", 0x00400254,
          "Performed Procedure Step Description", VR.kLO, VM.k1, false);
  static const DED kPerformedProcedureTypeDescription
      //(0040,0255)
      = const DED("PerformedProcedureTypeDescription", 0x00400255,
          "Performed Procedure Type Description", VR.kLO, VM.k1, false);
  static const DED kPerformedProtocolCodeSequence
      //(0040,0260)
      = const DED("PerformedProtocolCodeSequence", 0x00400260,
          "Performed Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedProtocolType
      //(0040,0261)
      = const DED(
          "PerformedProtocolType", 0x00400261, "Performed Protocol Type", VR.kCS, VM.k1, false);
  static const DED kScheduledStepAttributesSequence
      //(0040,0270)
      = const DED("ScheduledStepAttributesSequence", 0x00400270,
          "Scheduled Step Attributes Sequence", VR.kSQ, VM.k1, false);
  static const DED kRequestAttributesSequence
      //(0040,0275)
      = const DED("RequestAttributesSequence", 0x00400275, "Request Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCommentsOnThePerformedProcedureStep
      //(0040,0280)
      = const DED("CommentsOnThePerformedProcedureStep", 0x00400280,
          "Comments on the Performed Procedure Step", VR.kST, VM.k1, false);
  static const DED kPerformedProcedureStepDiscontinuationReasonCodeSequence
      //(0040,0281)
      = const DED("PerformedProcedureStepDiscontinuationReasonCodeSequence", 0x00400281,
          "Performed Procedure Step Discontinuation Reason Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kQuantitySequence
      //(0040,0293)
      = const DED("QuantitySequence", 0x00400293, "Quantity Sequence", VR.kSQ, VM.k1, false);
  static const DED kQuantity
      //(0040,0294)
      = const DED("Quantity", 0x00400294, "Quantity", VR.kDS, VM.k1, false);
  static const DED kMeasuringUnitsSequence
      //(0040,0295)
      = const DED(
          "MeasuringUnitsSequence", 0x00400295, "Measuring Units Sequence", VR.kSQ, VM.k1, false);
  static const DED kBillingItemSequence
      //(0040,0296)
      = const DED(
          "BillingItemSequence", 0x00400296, "Billing Item Sequence", VR.kSQ, VM.k1, false);
  static const DED kTotalTimeOfFluoroscopy
      //(0040,0300)
      = const DED(
          "TotalTimeOfFluoroscopy", 0x00400300, "Total Time of Fluoroscopy", VR.kUS, VM.k1, false);
  static const DED kTotalNumberOfExposures
      //(0040,0301)
      = const DED(
          "TotalNumberOfExposures", 0x00400301, "Total Number of Exposures", VR.kUS, VM.k1, false);
  static const DED kEntranceDose
      //(0040,0302)
      = const DED("EntranceDose", 0x00400302, "Entrance Dose", VR.kUS, VM.k1, false);
  static const DED kExposedArea
      //(0040,0303)
      = const DED("ExposedArea", 0x00400303, "Exposed Area", VR.kUS, VM.k1_2, false);
  static const DED kDistanceSourceToEntrance
      //(0040,0306)
      = const DED("DistanceSourceToEntrance", 0x00400306, "Distance Source to Entrance", VR.kDS,
          VM.k1, false);
  static const DED kDistanceSourceToSupport
      //(0040,0307)
      = const DED(
          "DistanceSourceToSupport", 0x00400307, "Distance Source to Support", VR.kDS, VM.k1, true);
  static const DED kExposureDoseSequence
      //(0040,030E)
      = const DED(
          "ExposureDoseSequence", 0x0040030E, "Exposure Dose Sequence", VR.kSQ, VM.k1, false);
  static const DED kCommentsOnRadiationDose
      //(0040,0310)
      = const DED("CommentsOnRadiationDose", 0x00400310, "Comments on Radiation Dose", VR.kST,
          VM.k1, false);
  static const DED kXRayOutput
      //(0040,0312)
      = const DED("XRayOutput", 0x00400312, "X-Ray Output", VR.kDS, VM.k1, false);
  static const DED kHalfValueLayer
      //(0040,0314)
      = const DED("HalfValueLayer", 0x00400314, "Half Value Layer", VR.kDS, VM.k1, false);
  static const DED kOrganDose
      //(0040,0316)
      = const DED("OrganDose", 0x00400316, "Organ Dose", VR.kDS, VM.k1, false);
  static const DED kOrganExposed
      //(0040,0318)
      = const DED("OrganExposed", 0x00400318, "Organ Exposed", VR.kCS, VM.k1, false);
  static const DED kBillingProcedureStepSequence
      //(0040,0320)
      = const DED("BillingProcedureStepSequence", 0x00400320, "Billing Procedure Step Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kFilmConsumptionSequence
      //(0040,0321)
      = const DED(
          "FilmConsumptionSequence", 0x00400321, "Film Consumption Sequence", VR.kSQ, VM.k1, false);
  static const DED kBillingSuppliesAndDevicesSequence
      //(0040,0324)
      = const DED("BillingSuppliesAndDevicesSequence", 0x00400324,
          "Billing Supplies and Devices Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedProcedureStepSequence
      //(0040,0330)
      = const DED("ReferencedProcedureStepSequence", 0x00400330,
          "Referenced Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const DED kPerformedSeriesSequence
      //(0040,0340)
      = const DED(
          "PerformedSeriesSequence", 0x00400340, "Performed Series Sequence", VR.kSQ, VM.k1, false);
  static const DED kCommentsOnTheScheduledProcedureStep
      //(0040,0400)
      = const DED("CommentsOnTheScheduledProcedureStep", 0x00400400,
          "Comments on the Scheduled Procedure Step", VR.kLT, VM.k1, false);
  static const DED kProtocolContextSequence
      //(0040,0440)
      = const DED(
          "ProtocolContextSequence", 0x00400440, "Protocol Context Sequence", VR.kSQ, VM.k1, false);
  static const DED kContentItemModifierSequence
      //(0040,0441)
      = const DED("ContentItemModifierSequence", 0x00400441, "Content Item Modifier Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kScheduledSpecimenSequence
      //(0040,0500)
      = const DED("ScheduledSpecimenSequence", 0x00400500, "Scheduled Specimen Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSpecimenAccessionNumber
      //(0040,050A)
      = const DED(
          "SpecimenAccessionNumber", 0x0040050A, "Specimen Accession Number", VR.kLO, VM.k1, true);
  static const DED kContainerIdentifier
      //(0040,0512)
      = const DED(
          "ContainerIdentifier", 0x00400512, "Container Identifier", VR.kLO, VM.k1, false);
  static const DED kIssuerOfTheContainerIdentifierSequence
      //(0040,0513)
      = const DED("IssuerOfTheContainerIdentifierSequence", 0x00400513,
          "Issuer of the Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kAlternateContainerIdentifierSequence
      //(0040,0515)
      = const DED("AlternateContainerIdentifierSequence", 0x00400515,
          "Alternate Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kContainerTypeCodeSequence
      //(0040,0518)
      = const DED("ContainerTypeCodeSequence", 0x00400518, "Container Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kContainerDescription
      //(0040,051A)
      = const DED(
          "ContainerDescription", 0x0040051A, "Container Description", VR.kLO, VM.k1, false);
  static const DED kContainerComponentSequence
      //(0040,0520)
      = const DED("ContainerComponentSequence", 0x00400520, "Container Component Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSpecimenSequence
      //(0040,0550)
      = const DED("SpecimenSequence", 0x00400550, "Specimen Sequence", VR.kSQ, VM.k1, true);
  static const DED kSpecimenIdentifier
      //(0040,0551)
      =
      const DED("SpecimenIdentifier", 0x00400551, "Specimen Identifier", VR.kLO, VM.k1, false);
  static const DED kSpecimenDescriptionSequenceTrial
      //(0040,0552)
      = const DED("SpecimenDescriptionSequenceTrial", 0x00400552,
          "Specimen Description Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kSpecimenDescriptionTrial
      //(0040,0553)
      = const DED("SpecimenDescriptionTrial", 0x00400553, "Specimen Description (Trial)",
          VR.kST, VM.k1, true);
  static const DED kSpecimenUID
      //(0040,0554)
      = const DED("SpecimenUID", 0x00400554, "Specimen UID", VR.kUI, VM.k1, false);
  static const DED kAcquisitionContextSequence
      //(0040,0555)
      = const DED("AcquisitionContextSequence", 0x00400555, "Acquisition Context Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAcquisitionContextDescription
      //(0040,0556)
      = const DED("AcquisitionContextDescription", 0x00400556,
          "Acquisition Context Description", VR.kST, VM.k1, false);
  static const DED kSpecimenTypeCodeSequence
      //(0040,059A)
      = const DED("SpecimenTypeCodeSequence", 0x0040059A, "Specimen Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSpecimenDescriptionSequence
      //(0040,0560)
      = const DED("SpecimenDescriptionSequence", 0x00400560, "Specimen Description Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kIssuerOfTheSpecimenIdentifierSequence
      //(0040,0562)
      = const DED("IssuerOfTheSpecimenIdentifierSequence", 0x00400562,
          "Issuer of the Specimen Identifier Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecimenShortDescription
      //(0040,0600)
      = const DED("SpecimenShortDescription", 0x00400600, "Specimen Short Description", VR.kLO,
          VM.k1, false);
  static const DED kSpecimenDetailedDescription
      //(0040,0602)
      = const DED("SpecimenDetailedDescription", 0x00400602, "Specimen Detailed Description",
          VR.kUT, VM.k1, false);
  static const DED kSpecimenPreparationSequence
      //(0040,0610)
      = const DED("SpecimenPreparationSequence", 0x00400610, "Specimen Preparation Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSpecimenPreparationStepContentItemSequence
      //(0040,0612)
      = const DED("SpecimenPreparationStepContentItemSequence", 0x00400612,
          "Specimen Preparation Step Content Item Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecimenLocalizationContentItemSequence
      //(0040,0620)
      = const DED("SpecimenLocalizationContentItemSequence", 0x00400620,
          "Specimen Localization Content Item Sequence", VR.kSQ, VM.k1, false);
  static const DED kSlideIdentifier
      //(0040,06FA)
      = const DED("SlideIdentifier", 0x004006FA, "Slide Identifier", VR.kLO, VM.k1, true);
  static const DED kImageCenterPointCoordinatesSequence
      //(0040,071A)
      = const DED("ImageCenterPointCoordinatesSequence", 0x0040071A,
          "Image Center Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const DED kXOffsetInSlideCoordinateSystem
      //(0040,072A)
      = const DED("XOffsetInSlideCoordinateSystem", 0x0040072A,
          "X Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const DED kYOffsetInSlideCoordinateSystem
      //(0040,073A)
      = const DED("YOffsetInSlideCoordinateSystem", 0x0040073A,
          "Y Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const DED kZOffsetInSlideCoordinateSystem
      //(0040,074A)
      = const DED("ZOffsetInSlideCoordinateSystem", 0x0040074A,
          "Z Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const DED kPixelSpacingSequence
      //(0040,08D8)
      = const DED(
          "PixelSpacingSequence", 0x004008D8, "Pixel Spacing Sequence", VR.kSQ, VM.k1, true);
  static const DED kCoordinateSystemAxisCodeSequence
      //(0040,08DA)
      = const DED("CoordinateSystemAxisCodeSequence", 0x004008DA,
          "Coordinate System Axis Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kMeasurementUnitsCodeSequence
      //(0040,08EA)
      = const DED("MeasurementUnitsCodeSequence", 0x004008EA, "Measurement Units Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kVitalStainCodeSequenceTrial
      //(0040,09F8)
      = const DED("VitalStainCodeSequenceTrial", 0x004009F8,
          "Vital Stain Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kRequestedProcedureID
      //(0040,1001)
      = const DED(
          "RequestedProcedureID", 0x00401001, "Requested Procedure ID", VR.kSH, VM.k1, false);
  static const DED kReasonForTheRequestedProcedure
      //(0040,1002)
      = const DED("ReasonForTheRequestedProcedure", 0x00401002,
          "Reason for the Requested Procedure", VR.kLO, VM.k1, false);
  static const DED kRequestedProcedurePriority
      //(0040,1003)
      = const DED("RequestedProcedurePriority", 0x00401003, "Requested Procedure Priority",
          VR.kSH, VM.k1, false);
  static const DED kPatientTransportArrangements
      //(0040,1004)
      = const DED("PatientTransportArrangements", 0x00401004, "Patient Transport Arrangements",
          VR.kLO, VM.k1, false);
  static const DED kRequestedProcedureLocation
      //(0040,1005)
      = const DED("RequestedProcedureLocation", 0x00401005, "Requested Procedure Location",
          VR.kLO, VM.k1, false);
  static const DED kPlacerOrderNumberProcedure
      //(0040,1006)
      = const DED("PlacerOrderNumberProcedure", 0x00401006, "Placer Order Number / Procedure",
          VR.kSH, VM.k1, true);
  static const DED kFillerOrderNumberProcedure
      //(0040,1007)
      = const DED("FillerOrderNumberProcedure", 0x00401007, "Filler Order Number / Procedure",
          VR.kSH, VM.k1, true);
  static const DED kConfidentialityCode
      //(0040,1008)
      = const DED(
          "ConfidentialityCode", 0x00401008, "Confidentiality Code", VR.kLO, VM.k1, false);
  static const DED kReportingPriority
      //(0040,1009)
      = const DED("ReportingPriority", 0x00401009, "Reporting Priority", VR.kSH, VM.k1, false);
  static const DED kReasonForRequestedProcedureCodeSequence
      //(0040,100A)
      = const DED("ReasonForRequestedProcedureCodeSequence", 0x0040100A,
          "Reason for Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kNamesOfIntendedRecipientsOfResults
      //(0040,1010)
      = const DED("NamesOfIntendedRecipientsOfResults", 0x00401010,
          "Names of Intended Recipients of Results", VR.kPN, VM.k1_n, false);
  static const DED kIntendedRecipientsOfResultsIdentificationSequence
      //(0040,1011)
      = const DED("IntendedRecipientsOfResultsIdentificationSequence", 0x00401011,
          "Intended Recipients of Results Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kReasonForPerformedProcedureCodeSequence
      //(0040,1012)
      = const DED("ReasonForPerformedProcedureCodeSequence", 0x00401012,
          "Reason For Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRequestedProcedureDescriptionTrial
      //(0040,1060)
      = const DED("RequestedProcedureDescriptionTrial", 0x00401060,
          "Requested Procedure Description (Trial)", VR.kLO, VM.k1, true);
  static const DED kPersonIdentificationCodeSequence
      //(0040,1101)
      = const DED("PersonIdentificationCodeSequence", 0x00401101,
          "Person Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPersonAddress
      //(0040,1102)
      = const DED("PersonAddress", 0x00401102, "Person's Address", VR.kST, VM.k1, false);
  static const DED kPersonTelephoneNumbers
      //(0040,1103)
      = const DED("PersonTelephoneNumbers", 0x00401103, "Person's Telephone Numbers", VR.kLO,
          VM.k1_n, false);
  static const DED kRequestedProcedureComments
      //(0040,1400)
      = const DED("RequestedProcedureComments", 0x00401400, "Requested Procedure Comments",
          VR.kLT, VM.k1, false);
  static const DED kReasonForTheImagingServiceRequest
      //(0040,2001)
      = const DED("ReasonForTheImagingServiceRequest", 0x00402001,
          "Reason for the Imaging Service Request", VR.kLO, VM.k1, true);
  static const DED kIssueDateOfImagingServiceRequest
      //(0040,2004)
      = const DED("IssueDateOfImagingServiceRequest", 0x00402004,
          "Issue Date of Imaging Service Request", VR.kDA, VM.k1, false);
  static const DED kIssueTimeOfImagingServiceRequest
      //(0040,2005)
      = const DED("IssueTimeOfImagingServiceRequest", 0x00402005,
          "Issue Time of Imaging Service Request", VR.kTM, VM.k1, false);
  static const DED kPlacerOrderNumberImagingServiceRequestRetired
      //(0040,2006)
      = const DED("PlacerOrderNumberImagingServiceRequestRetired", 0x00402006,
          "Placer Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const DED kFillerOrderNumberImagingServiceRequestRetired
      //(0040,2007)
      = const DED("FillerOrderNumberImagingServiceRequestRetired", 0x00402007,
          "Filler Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const DED kOrderEnteredBy
      //(0040,2008)
      = const DED("OrderEnteredBy", 0x00402008, "Order Entered By", VR.kPN, VM.k1, false);
  static const DED kOrderEntererLocation
      //(0040,2009)
      = const DED(
          "OrderEntererLocation", 0x00402009, "Order Enterer's Location", VR.kSH, VM.k1, false);
  static const DED kOrderCallbackPhoneNumber
      //(0040,2010)
      = const DED("OrderCallbackPhoneNumber", 0x00402010, "Order Callback Phone Number", VR.kSH,
          VM.k1, false);
  static const DED kPlacerOrderNumberImagingServiceRequest
      //(0040,2016)
      = const DED("PlacerOrderNumberImagingServiceRequest", 0x00402016,
          "Placer Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const DED kFillerOrderNumberImagingServiceRequest
      //(0040,2017)
      = const DED("FillerOrderNumberImagingServiceRequest", 0x00402017,
          "Filler Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const DED kImagingServiceRequestComments
      //(0040,2400)
      = const DED("ImagingServiceRequestComments", 0x00402400,
          "Imaging Service Request Comments", VR.kLT, VM.k1, false);
  static const DED kConfidentialityConstraintOnPatientDataDescription
      //(0040,3001)
      = const DED("ConfidentialityConstraintOnPatientDataDescription", 0x00403001,
          "Confidentiality Constraint on Patient Data Description", VR.kLO, VM.k1, false);
  static const DED kGeneralPurposeScheduledProcedureStepStatus
      //(0040,4001)
      = const DED("GeneralPurposeScheduledProcedureStepStatus", 0x00404001,
          "General Purpose Scheduled Procedure Step Status", VR.kCS, VM.k1, true);
  static const DED kGeneralPurposePerformedProcedureStepStatus
      //(0040,4002)
      = const DED("GeneralPurposePerformedProcedureStepStatus", 0x00404002,
          "General Purpose Performed Procedure Step Status", VR.kCS, VM.k1, true);
  static const DED kGeneralPurposeScheduledProcedureStepPriority
      //(0040,4003)
      = const DED("GeneralPurposeScheduledProcedureStepPriority", 0x00404003,
          "General Purpose Scheduled Procedure Step Priority", VR.kCS, VM.k1, true);
  static const DED kScheduledProcessingApplicationsCodeSequence
      //(0040,4004)
      = const DED("ScheduledProcessingApplicationsCodeSequence", 0x00404004,
          "Scheduled Processing Applications Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kScheduledProcedureStepStartDateTime
      //(0040,4005)
      = const DED("ScheduledProcedureStepStartDateTime", 0x00404005,
          "Scheduled Procedure Step Start DateTime", VR.kDT, VM.k1, true);
  static const DED kMultipleCopiesFlag
      //(0040,4006)
      =
      const DED("MultipleCopiesFlag", 0x00404006, "Multiple Copies Flag", VR.kCS, VM.k1, true);
  static const DED kPerformedProcessingApplicationsCodeSequence
      //(0040,4007)
      = const DED("PerformedProcessingApplicationsCodeSequence", 0x00404007,
          "Performed Processing Applications Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kHumanPerformerCodeSequence
      //(0040,4009)
      = const DED("HumanPerformerCodeSequence", 0x00404009, "Human Performer Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kScheduledProcedureStepModificationDateTime
      //(0040,4010)
      = const DED("ScheduledProcedureStepModificationDateTime", 0x00404010,
          "Scheduled Procedure Step Modification DateTime", VR.kDT, VM.k1, false);
  static const DED kExpectedCompletionDateTime
      //(0040,4011)
      = const DED("ExpectedCompletionDateTime", 0x00404011, "Expected Completion DateTime",
          VR.kDT, VM.k1, false);
  static const DED kResultingGeneralPurposePerformedProcedureStepsSequence
      //(0040,4015)
      = const DED("ResultingGeneralPurposePerformedProcedureStepsSequence", 0x00404015,
          "Resulting General Purpose Performed Procedure Steps Sequence", VR.kSQ, VM.k1, true);
  static const DED kReferencedGeneralPurposeScheduledProcedureStepSequence
      //(0040,4016)
      = const DED("ReferencedGeneralPurposeScheduledProcedureStepSequence", 0x00404016,
          "Referenced General Purpose Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const DED kScheduledWorkitemCodeSequence
      //(0040,4018)
      = const DED("ScheduledWorkitemCodeSequence", 0x00404018,
          "Scheduled Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedWorkitemCodeSequence
      //(0040,4019)
      = const DED("PerformedWorkitemCodeSequence", 0x00404019,
          "Performed Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kInputAvailabilityFlag
      //(0040,4020)
      = const DED(
          "InputAvailabilityFlag", 0x00404020, "Input Availability Flag", VR.kCS, VM.k1, false);
  static const DED kInputInformationSequence
      //(0040,4021)
      = const DED("InputInformationSequence", 0x00404021, "Input Information Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kRelevantInformationSequence
      //(0040,4022)
      = const DED("RelevantInformationSequence", 0x00404022, "Relevant Information Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kReferencedGeneralPurposeScheduledProcedureStepTransactionUID
      //(0040,4023)
      = const DED(
          "ReferencedGeneralPurposeScheduledProcedureStepTransactionUID",
          0x00404023,
          "Referenced General Purpose Scheduled Procedure Step Transaction UID",
          VR.kUI,
          VM.k1,
          true);
  static const DED kScheduledStationNameCodeSequence
      //(0040,4025)
      = const DED("ScheduledStationNameCodeSequence", 0x00404025,
          "Scheduled Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledStationClassCodeSequence
      //(0040,4026)
      = const DED("ScheduledStationClassCodeSequence", 0x00404026,
          "Scheduled Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kScheduledStationGeographicLocationCodeSequence
      //(0040,4027)
      = const DED("ScheduledStationGeographicLocationCodeSequence", 0x00404027,
          "Scheduled Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedStationNameCodeSequence
      //(0040,4028)
      = const DED("PerformedStationNameCodeSequence", 0x00404028,
          "Performed Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedStationClassCodeSequence
      //(0040,4029)
      = const DED("PerformedStationClassCodeSequence", 0x00404029,
          "Performed Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedStationGeographicLocationCodeSequence
      //(0040,4030)
      = const DED("PerformedStationGeographicLocationCodeSequence", 0x00404030,
          "Performed Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRequestedSubsequentWorkitemCodeSequence
      //(0040,4031)
      = const DED("RequestedSubsequentWorkitemCodeSequence", 0x00404031,
          "Requested Subsequent Workitem Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kNonDICOMOutputCodeSequence
      //(0040,4032)
      = const DED("NonDICOMOutputCodeSequence", 0x00404032, "Non-DICOM Output Code Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kOutputInformationSequence
      //(0040,4033)
      = const DED("OutputInformationSequence", 0x00404033, "Output Information Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kScheduledHumanPerformersSequence
      //(0040,4034)
      = const DED("ScheduledHumanPerformersSequence", 0x00404034,
          "Scheduled Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const DED kActualHumanPerformersSequence
      //(0040,4035)
      = const DED("ActualHumanPerformersSequence", 0x00404035,
          "Actual Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const DED kHumanPerformerOrganization
      //(0040,4036)
      = const DED("HumanPerformerOrganization", 0x00404036, "Human Performer's Organization",
          VR.kLO, VM.k1, false);
  static const DED kHumanPerformerName
      //(0040,4037)
      = const DED(
          "HumanPerformerName", 0x00404037, "Human Performer's Name", VR.kPN, VM.k1, false);
  static const DED kRawDataHandling
      //(0040,4040)
      = const DED("RawDataHandling", 0x00404040, "Raw Data Handling", VR.kCS, VM.k1, false);
  static const DED kInputReadinessState
      //(0040,4041)
      = const DED(
          "InputReadinessState", 0x00404041, "Input Readiness State", VR.kCS, VM.k1, false);
  static const DED kPerformedProcedureStepStartDateTime
      //(0040,4050)
      = const DED("PerformedProcedureStepStartDateTime", 0x00404050,
          "Performed Procedure Step Start DateTime", VR.kDT, VM.k1, false);
  static const DED kPerformedProcedureStepEndDateTime
      //(0040,4051)
      = const DED("PerformedProcedureStepEndDateTime", 0x00404051,
          "Performed Procedure Step End DateTime", VR.kDT, VM.k1, false);
  static const DED kProcedureStepCancellationDateTime
      //(0040,4052)
      = const DED("ProcedureStepCancellationDateTime", 0x00404052,
          "Procedure Step Cancellation DateTime", VR.kDT, VM.k1, false);
  static const DED kEntranceDoseInmGy
      //(0040,8302)
      =
      const DED("EntranceDoseInmGy", 0x00408302, "Entrance Dose in mGy", VR.kDS, VM.k1, false);
  static const DED kReferencedImageRealWorldValueMappingSequence
      //(0040,9094)
      = const DED("ReferencedImageRealWorldValueMappingSequence", 0x00409094,
          "Referenced Image Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const DED kRealWorldValueMappingSequence
      //(0040,9096)
      = const DED("RealWorldValueMappingSequence", 0x00409096,
          "Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const DED kPixelValueMappingCodeSequence
      //(0040,9098)
      = const DED("PixelValueMappingCodeSequence", 0x00409098,
          "Pixel Value Mapping Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kLUTLabel
      //(0040,9210)
      = const DED("LUTLabel", 0x00409210, "LUT Label", VR.kSH, VM.k1, false);
  static const DED kRealWorldValueLastValueMapped
      //(0040,9211)
      = const DED("RealWorldValueLastValueMapped", 0x00409211,
          "Real World Value Last Value Mapped", VR.kUSSS, VM.k1, false);
  static const DED kRealWorldValueLUTData
      //(0040,9212)
      = const DED(
          "RealWorldValueLUTData", 0x00409212, "Real World Value LUT Data", VR.kFD, VM.k1_n, false);
  static const DED kRealWorldValueFirstValueMapped
      //(0040,9216)
      = const DED("RealWorldValueFirstValueMapped", 0x00409216,
          "Real World Value First Value Mapped", VR.kUSSS, VM.k1, false);
  static const DED kRealWorldValueIntercept
      //(0040,9224)
      = const DED("RealWorldValueIntercept", 0x00409224, "Real World Value Intercept", VR.kFD,
          VM.k1, false);
  static const DED kRealWorldValueSlope
      //(0040,9225)
      = const DED(
          "RealWorldValueSlope", 0x00409225, "Real World Value Slope", VR.kFD, VM.k1, false);
  static const DED kFindingsFlagTrial
      //(0040,A007)
      =
      const DED("FindingsFlagTrial", 0x0040A007, "Findings Flag (Trial)", VR.kCS, VM.k1, true);
  static const DED kRelationshipType
      //(0040,A010)
      = const DED("RelationshipType", 0x0040A010, "Relationship Type", VR.kCS, VM.k1, false);
  static const DED kFindingsSequenceTrial
      //(0040,A020)
      = const DED(
          "FindingsSequenceTrial", 0x0040A020, "Findings Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kFindingsGroupUIDTrial
      //(0040,A021)
      = const DED(
          "FindingsGroupUIDTrial", 0x0040A021, "Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const DED kReferencedFindingsGroupUIDTrial
      //(0040,A022)
      = const DED("ReferencedFindingsGroupUIDTrial", 0x0040A022,
          "Referenced Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const DED kFindingsGroupRecordingDateTrial
      //(0040,A023)
      = const DED("FindingsGroupRecordingDateTrial", 0x0040A023,
          "Findings Group Recording Date (Trial)", VR.kDA, VM.k1, true);
  static const DED kFindingsGroupRecordingTimeTrial
      //(0040,A024)
      = const DED("FindingsGroupRecordingTimeTrial", 0x0040A024,
          "Findings Group Recording Time (Trial)", VR.kTM, VM.k1, true);
  static const DED kFindingsSourceCategoryCodeSequenceTrial
      //(0040,A026)
      = const DED("FindingsSourceCategoryCodeSequenceTrial", 0x0040A026,
          "Findings Source Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kVerifyingOrganization
      //(0040,A027)
      = const DED(
          "VerifyingOrganization", 0x0040A027, "Verifying Organization", VR.kLO, VM.k1, false);
  static const DED kDocumentingOrganizationIdentifierCodeSequenceTrial
      //(0040,A028)
      = const DED("DocumentingOrganizationIdentifierCodeSequenceTrial", 0x0040A028,
          "Documenting Organization Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kVerificationDateTime
      //(0040,A030)
      = const DED(
          "VerificationDateTime", 0x0040A030, "Verification DateTime", VR.kDT, VM.k1, false);
  static const DED kObservationDateTime
      //(0040,A032)
      = const DED(
          "ObservationDateTime", 0x0040A032, "Observation DateTime", VR.kDT, VM.k1, false);
  static const DED kValueType
      //(0040,A040)
      = const DED("ValueType", 0x0040A040, "Value Type", VR.kCS, VM.k1, false);
  static const DED kConceptNameCodeSequence
      //(0040,A043)
      = const DED("ConceptNameCodeSequence", 0x0040A043, "Concept Name Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kMeasurementPrecisionDescriptionTrial
      //(0040,A047)
      = const DED("MeasurementPrecisionDescriptionTrial", 0x0040A047,
          "Measurement Precision Description (Trial)", VR.kLO, VM.k1, true);
  static const DED kContinuityOfContent
      //(0040,A050)
      = const DED(
          "ContinuityOfContent", 0x0040A050, "Continuity Of Content", VR.kCS, VM.k1, false);
  static const DED kUrgencyOrPriorityAlertsTrial
      //(0040,A057)
      = const DED("UrgencyOrPriorityAlertsTrial", 0x0040A057,
          "Urgency or Priority Alerts (Trial)", VR.kCS, VM.k1_n, true);
  static const DED kSequencingIndicatorTrial
      //(0040,A060)
      = const DED("SequencingIndicatorTrial", 0x0040A060, "Sequencing Indicator (Trial)",
          VR.kLO, VM.k1, true);
  static const DED kDocumentIdentifierCodeSequenceTrial
      //(0040,A066)
      = const DED("DocumentIdentifierCodeSequenceTrial", 0x0040A066,
          "Document Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kDocumentAuthorTrial
      //(0040,A067)
      = const DED(
          "DocumentAuthorTrial", 0x0040A067, "Document Author (Trial)", VR.kPN, VM.k1, true);
  static const DED kDocumentAuthorIdentifierCodeSequenceTrial
      //(0040,A068)
      = const DED("DocumentAuthorIdentifierCodeSequenceTrial", 0x0040A068,
          "Document Author Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kIdentifierCodeSequenceTrial
      //(0040,A070)
      = const DED("IdentifierCodeSequenceTrial", 0x0040A070, "Identifier Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const DED kVerifyingObserverSequence
      //(0040,A073)
      = const DED("VerifyingObserverSequence", 0x0040A073, "Verifying Observer Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kObjectBinaryIdentifierTrial
      //(0040,A074)
      = const DED("ObjectBinaryIdentifierTrial", 0x0040A074, "Object Binary Identifier (Trial)",
          VR.kOB, VM.k1, true);
  static const DED kVerifyingObserverName
      //(0040,A075)
      = const DED(
          "VerifyingObserverName", 0x0040A075, "Verifying Observer Name", VR.kPN, VM.k1, false);
  static const DED kDocumentingObserverIdentifierCodeSequenceTrial
      //(0040,A076)
      = const DED("DocumentingObserverIdentifierCodeSequenceTrial", 0x0040A076,
          "Documenting Observer Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kAuthorObserverSequence
      //(0040,A078)
      = const DED(
          "AuthorObserverSequence", 0x0040A078, "Author Observer Sequence", VR.kSQ, VM.k1, false);
  static const DED kParticipantSequence
      //(0040,A07A)
      = const DED(
          "ParticipantSequence", 0x0040A07A, "Participant Sequence", VR.kSQ, VM.k1, false);
  static const DED kCustodialOrganizationSequence
      //(0040,A07C)
      = const DED("CustodialOrganizationSequence", 0x0040A07C,
          "Custodial Organization Sequence", VR.kSQ, VM.k1, false);
  static const DED kParticipationType
      //(0040,A080)
      = const DED("ParticipationType", 0x0040A080, "Participation Type", VR.kCS, VM.k1, false);
  static const DED kParticipationDateTime
      //(0040,A082)
      = const DED(
          "ParticipationDateTime", 0x0040A082, "Participation DateTime", VR.kDT, VM.k1, false);
  static const DED kObserverType
      //(0040,A084)
      = const DED("ObserverType", 0x0040A084, "Observer Type", VR.kCS, VM.k1, false);
  static const DED kProcedureIdentifierCodeSequenceTrial
      //(0040,A085)
      = const DED("ProcedureIdentifierCodeSequenceTrial", 0x0040A085,
          "Procedure Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kVerifyingObserverIdentificationCodeSequence
      //(0040,A088)
      = const DED("VerifyingObserverIdentificationCodeSequence", 0x0040A088,
          "Verifying Observer Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kObjectDirectoryBinaryIdentifierTrial
      //(0040,A089)
      = const DED("ObjectDirectoryBinaryIdentifierTrial", 0x0040A089,
          "Object Directory Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const DED kEquivalentCDADocumentSequence
      //(0040,A090)
      = const DED("EquivalentCDADocumentSequence", 0x0040A090,
          "Equivalent CDA Document Sequence", VR.kSQ, VM.k1, true);
  static const DED kReferencedWaveformChannels
      //(0040,A0B0)
      = const DED("ReferencedWaveformChannels", 0x0040A0B0, "Referenced Waveform Channels",
          VR.kUS, VM.k2_2n, false);
  static const DED kDateOfDocumentOrVerbalTransactionTrial
      //(0040,A110)
      = const DED("DateOfDocumentOrVerbalTransactionTrial", 0x0040A110,
          "Date of Document or Verbal Transaction (Trial)", VR.kDA, VM.k1, true);
  static const DED kTimeOfDocumentCreationOrVerbalTransactionTrial
      //(0040,A112)
      = const DED("TimeOfDocumentCreationOrVerbalTransactionTrial", 0x0040A112,
          "Time of Document Creation or Verbal Transaction (Trial)", VR.kTM, VM.k1, true);
  static const DED kDateTime
      //(0040,A120)
      = const DED("DateTime", 0x0040A120, "DateTime", VR.kDT, VM.k1, false);
  static const DED kDate
      //(0040,A121)
      = const DED("Date", 0x0040A121, "Date", VR.kDA, VM.k1, false);
  static const DED kTime
      //(0040,A122)
      = const DED("Time", 0x0040A122, "Time", VR.kTM, VM.k1, false);
  static const DED kPersonName
      //(0040,A123)
      = const DED("PersonName", 0x0040A123, "Person Name", VR.kPN, VM.k1, false);
  static const DED kUID
      //(0040,A124)
      = const DED("UID", 0x0040A124, "UID", VR.kUI, VM.k1, false);
  static const DED kReportStatusIDTrial
      //(0040,A125)
      = const DED(
          "ReportStatusIDTrial", 0x0040A125, "Report Status ID (Trial)", VR.kCS, VM.k2, true);
  static const DED kTemporalRangeType
      //(0040,A130)
      = const DED("TemporalRangeType", 0x0040A130, "Temporal Range Type", VR.kCS, VM.k1, false);
  static const DED kReferencedSamplePositions
      //(0040,A132)
      = const DED("ReferencedSamplePositions", 0x0040A132, "Referenced Sample Positions",
          VR.kUL, VM.k1_n, false);
  static const DED kReferencedFrameNumbers
      //(0040,A136)
      = const DED(
          "ReferencedFrameNumbers", 0x0040A136, "Referenced Frame Numbers", VR.kUS, VM.k1_n, false);
  static const DED kReferencedTimeOffsets
      //(0040,A138)
      = const DED(
          "ReferencedTimeOffsets", 0x0040A138, "Referenced Time Offsets", VR.kDS, VM.k1_n, false);
  static const DED kReferencedDateTime
      //(0040,A13A)
      = const DED(
          "ReferencedDateTime", 0x0040A13A, "Referenced DateTime", VR.kDT, VM.k1_n, false);
  static const DED kTextValue
      //(0040,A160)
      = const DED("TextValue", 0x0040A160, "Text Value", VR.kUT, VM.k1, false);
  static const DED kFloatingPointValue
      //(0040,A161)
      = const DED(
          "FloatingPointValue", 0x0040A161, "Floating Point Value", VR.kFD, VM.k1_n, false);
  static const DED kRationalNumeratorValue
      //(0040,A162)
      = const DED(
          "RationalNumeratorValue", 0x0040A162, "Rational Numerator Value", VR.kSL, VM.k1_n, false);
  static const DED kRationalDenominatorValue
      //(0040,A163)
      = const DED("RationalDenominatorValue", 0x0040A163, "Rational Denominator Value", VR.kUL,
          VM.k1_n, false);
  static const DED kObservationCategoryCodeSequenceTrial
      //(0040,A167)
      = const DED("ObservationCategoryCodeSequenceTrial", 0x0040A167,
          "Observation Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kConceptCodeSequence
      //(0040,A168)
      = const DED(
          "ConceptCodeSequence", 0x0040A168, "Concept Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kBibliographicCitationTrial
      //(0040,A16A)
      = const DED("BibliographicCitationTrial", 0x0040A16A, "Bibliographic Citation (Trial)",
          VR.kST, VM.k1, true);
  static const DED kPurposeOfReferenceCodeSequence
      //(0040,A170)
      = const DED("PurposeOfReferenceCodeSequence", 0x0040A170,
          "Purpose of Reference Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kObservationUID
      //(0040,A171)
      = const DED("ObservationUID", 0x0040A171, "Observation UID", VR.kUI, VM.k1, false);
  static const DED kReferencedObservationUIDTrial
      //(0040,A172)
      = const DED("ReferencedObservationUIDTrial", 0x0040A172,
          "Referenced Observation UID (Trial)", VR.kUI, VM.k1, true);
  static const DED kReferencedObservationClassTrial
      //(0040,A173)
      = const DED("ReferencedObservationClassTrial", 0x0040A173,
          "Referenced Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const DED kReferencedObjectObservationClassTrial
      //(0040,A174)
      = const DED("ReferencedObjectObservationClassTrial", 0x0040A174,
          "Referenced Object Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const DED kAnnotationGroupNumber
      //(0040,A180)
      = const DED(
          "AnnotationGroupNumber", 0x0040A180, "Annotation Group Number", VR.kUS, VM.k1, false);
  static const DED kObservationDateTrial
      //(0040,A192)
      = const DED(
          "ObservationDateTrial", 0x0040A192, "Observation Date (Trial)", VR.kDA, VM.k1, true);
  static const DED kObservationTimeTrial
      //(0040,A193)
      = const DED(
          "ObservationTimeTrial", 0x0040A193, "Observation Time (Trial)", VR.kTM, VM.k1, true);
  static const DED kMeasurementAutomationTrial
      //(0040,A194)
      = const DED("MeasurementAutomationTrial", 0x0040A194, "Measurement Automation (Trial)",
          VR.kCS, VM.k1, true);
  static const DED kModifierCodeSequence
      //(0040,A195)
      = const DED(
          "ModifierCodeSequence", 0x0040A195, "Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kIdentificationDescriptionTrial
      //(0040,A224)
      = const DED("IdentificationDescriptionTrial", 0x0040A224,
          "Identification Description (Trial)", VR.kST, VM.k1, true);
  static const DED kCoordinatesSetGeometricTypeTrial
      //(0040,A290)
      = const DED("CoordinatesSetGeometricTypeTrial", 0x0040A290,
          "Coordinates Set Geometric Type (Trial)", VR.kCS, VM.k1, true);
  static const DED kAlgorithmCodeSequenceTrial
      //(0040,A296)
      = const DED("AlgorithmCodeSequenceTrial", 0x0040A296, "Algorithm Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const DED kAlgorithmDescriptionTrial
      //(0040,A297)
      = const DED("AlgorithmDescriptionTrial", 0x0040A297, "Algorithm Description (Trial)",
          VR.kST, VM.k1, true);
  static const DED kPixelCoordinatesSetTrial
      //(0040,A29A)
      = const DED("PixelCoordinatesSetTrial", 0x0040A29A, "Pixel Coordinates Set (Trial)",
          VR.kSL, VM.k2_2n, true);
  static const DED kMeasuredValueSequence
      //(0040,A300)
      = const DED(
          "MeasuredValueSequence", 0x0040A300, "Measured Value Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumericValueQualifierCodeSequence
      //(0040,A301)
      = const DED("NumericValueQualifierCodeSequence", 0x0040A301,
          "Numeric Value Qualifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kCurrentObserverTrial
      //(0040,A307)
      = const DED(
          "CurrentObserverTrial", 0x0040A307, "Current Observer (Trial)", VR.kPN, VM.k1, true);
  static const DED kNumericValue
      //(0040,A30A)
      = const DED("NumericValue", 0x0040A30A, "Numeric Value", VR.kDS, VM.k1_n, false);
  static const DED kReferencedAccessionSequenceTrial
      //(0040,A313)
      = const DED("ReferencedAccessionSequenceTrial", 0x0040A313,
          "Referenced Accession Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kReportStatusCommentTrial
      //(0040,A33A)
      = const DED("ReportStatusCommentTrial", 0x0040A33A, "Report Status Comment (Trial)",
          VR.kST, VM.k1, true);
  static const DED kProcedureContextSequenceTrial
      //(0040,A340)
      = const DED("ProcedureContextSequenceTrial", 0x0040A340,
          "Procedure Context Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kVerbalSourceTrial
      //(0040,A352)
      =
      const DED("VerbalSourceTrial", 0x0040A352, "Verbal Source (Trial)", VR.kPN, VM.k1, true);
  static const DED kAddressTrial
      //(0040,A353)
      = const DED("AddressTrial", 0x0040A353, "Address (Trial)", VR.kST, VM.k1, true);
  static const DED kTelephoneNumberTrial
      //(0040,A354)
      = const DED(
          "TelephoneNumberTrial", 0x0040A354, "Telephone Number (Trial)", VR.kLO, VM.k1, true);
  static const DED kVerbalSourceIdentifierCodeSequenceTrial
      //(0040,A358)
      = const DED("VerbalSourceIdentifierCodeSequenceTrial", 0x0040A358,
          "Verbal Source Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kPredecessorDocumentsSequence
      //(0040,A360)
      = const DED("PredecessorDocumentsSequence", 0x0040A360, "Predecessor Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedRequestSequence
      //(0040,A370)
      = const DED("ReferencedRequestSequence", 0x0040A370, "Referenced Request Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPerformedProcedureCodeSequence
      //(0040,A372)
      = const DED("PerformedProcedureCodeSequence", 0x0040A372,
          "Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kCurrentRequestedProcedureEvidenceSequence
      //(0040,A375)
      = const DED("CurrentRequestedProcedureEvidenceSequence", 0x0040A375,
          "Current Requested Procedure Evidence Sequence", VR.kSQ, VM.k1, false);
  static const DED kReportDetailSequenceTrial
      //(0040,A380)
      = const DED("ReportDetailSequenceTrial", 0x0040A380, "Report Detail Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const DED kPertinentOtherEvidenceSequence
      //(0040,A385)
      = const DED("PertinentOtherEvidenceSequence", 0x0040A385,
          "Pertinent Other Evidence Sequence", VR.kSQ, VM.k1, false);
  static const DED kHL7StructuredDocumentReferenceSequence
      //(0040,A390)
      = const DED("HL7StructuredDocumentReferenceSequence", 0x0040A390,
          "HL7 Structured Document Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kObservationSubjectUIDTrial
      //(0040,A402)
      = const DED("ObservationSubjectUIDTrial", 0x0040A402, "Observation Subject UID (Trial)",
          VR.kUI, VM.k1, true);
  static const DED kObservationSubjectClassTrial
      //(0040,A403)
      = const DED("ObservationSubjectClassTrial", 0x0040A403,
          "Observation Subject Class (Trial)", VR.kCS, VM.k1, true);
  static const DED kObservationSubjectTypeCodeSequenceTrial
      //(0040,A404)
      = const DED("ObservationSubjectTypeCodeSequenceTrial", 0x0040A404,
          "Observation Subject Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kCompletionFlag
      //(0040,A491)
      = const DED("CompletionFlag", 0x0040A491, "Completion Flag", VR.kCS, VM.k1, false);
  static const DED kCompletionFlagDescription
      //(0040,A492)
      = const DED("CompletionFlagDescription", 0x0040A492, "Completion Flag Description",
          VR.kLO, VM.k1, false);
  static const DED kVerificationFlag
      //(0040,A493)
      = const DED("VerificationFlag", 0x0040A493, "Verification Flag", VR.kCS, VM.k1, false);
  static const DED kArchiveRequested
      //(0040,A494)
      = const DED("ArchiveRequested", 0x0040A494, "Archive Requested", VR.kCS, VM.k1, false);
  static const DED kPreliminaryFlag
      //(0040,A496)
      = const DED("PreliminaryFlag", 0x0040A496, "Preliminary Flag", VR.kCS, VM.k1, false);
  static const DED kContentTemplateSequence
      //(0040,A504)
      = const DED(
          "ContentTemplateSequence", 0x0040A504, "Content Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kIdenticalDocumentsSequence
      //(0040,A525)
      = const DED("IdenticalDocumentsSequence", 0x0040A525, "Identical Documents Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kObservationSubjectContextFlagTrial
      //(0040,A600)
      = const DED("ObservationSubjectContextFlagTrial", 0x0040A600,
          "Observation Subject Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const DED kObserverContextFlagTrial
      //(0040,A601)
      = const DED("ObserverContextFlagTrial", 0x0040A601, "Observer Context Flag (Trial)",
          VR.kCS, VM.k1, true);
  static const DED kProcedureContextFlagTrial
      //(0040,A603)
      = const DED("ProcedureContextFlagTrial", 0x0040A603, "Procedure Context Flag (Trial)",
          VR.kCS, VM.k1, true);
  static const DED kContentSequence
      //(0040,A730)
      = const DED("ContentSequence", 0x0040A730, "Content Sequence", VR.kSQ, VM.k1, false);
  static const DED kRelationshipSequenceTrial
      //(0040,A731)
      = const DED("RelationshipSequenceTrial", 0x0040A731, "Relationship Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const DED kRelationshipTypeCodeSequenceTrial
      //(0040,A732)
      = const DED("RelationshipTypeCodeSequenceTrial", 0x0040A732,
          "Relationship Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const DED kLanguageCodeSequenceTrial
      //(0040,A744)
      = const DED("LanguageCodeSequenceTrial", 0x0040A744, "Language Code Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const DED kUniformResourceLocatorTrial
      //(0040,A992)
      = const DED("UniformResourceLocatorTrial", 0x0040A992, "Uniform Resource Locator (Trial)",
          VR.kST, VM.k1, true);
  static const DED kWaveformAnnotationSequence
      //(0040,B020)
      = const DED("WaveformAnnotationSequence", 0x0040B020, "Waveform Annotation Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTemplateIdentifier
      //(0040,DB00)
      =
      const DED("TemplateIdentifier", 0x0040DB00, "Template Identifier", VR.kCS, VM.k1, false);
  static const DED kTemplateVersion
      //(0040,DB06)
      = const DED("TemplateVersion", 0x0040DB06, "Template Version", VR.kDT, VM.k1, true);
  static const DED kTemplateLocalVersion
      //(0040,DB07)
      = const DED(
          "TemplateLocalVersion", 0x0040DB07, "Template Local Version", VR.kDT, VM.k1, true);
  static const DED kTemplateExtensionFlag
      //(0040,DB0B)
      = const DED(
          "TemplateExtensionFlag", 0x0040DB0B, "Template Extension Flag", VR.kCS, VM.k1, true);
  static const DED kTemplateExtensionOrganizationUID
      //(0040,DB0C)
      = const DED("TemplateExtensionOrganizationUID", 0x0040DB0C,
          "Template Extension Organization UID", VR.kUI, VM.k1, true);
  static const DED kTemplateExtensionCreatorUID
      //(0040,DB0D)
      = const DED("TemplateExtensionCreatorUID", 0x0040DB0D, "Template Extension Creator UID",
          VR.kUI, VM.k1, true);
  static const DED kReferencedContentItemIdentifier
      //(0040,DB73)
      = const DED("ReferencedContentItemIdentifier", 0x0040DB73,
          "Referenced Content Item Identifier", VR.kUL, VM.k1_n, false);
  static const DED kHL7InstanceIdentifier
      //(0040,E001)
      = const DED(
          "HL7InstanceIdentifier", 0x0040E001, "HL7 Instance Identifier", VR.kST, VM.k1, false);
  static const DED kHL7DocumentEffectiveTime
      //(0040,E004)
      = const DED("HL7DocumentEffectiveTime", 0x0040E004, "HL7 Document Effective Time", VR.kDT,
          VM.k1, false);
  static const DED kHL7DocumentTypeCodeSequence
      //(0040,E006)
      = const DED("HL7DocumentTypeCodeSequence", 0x0040E006, "HL7 Document Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kDocumentClassCodeSequence
      //(0040,E008)
      = const DED("DocumentClassCodeSequence", 0x0040E008, "Document Class Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRetrieveURI
      //(0040,E010)
      = const DED("RetrieveURI", 0x0040E010, "Retrieve URI", VR.kUT, VM.k1, false);
  static const DED kRetrieveLocationUID
      //(0040,E011)
      = const DED(
          "RetrieveLocationUID", 0x0040E011, "Retrieve Location UID", VR.kUI, VM.k1, false);
  static const DED kTypeOfInstances
      //(0040,E020)
      = const DED("TypeOfInstances", 0x0040E020, "Type of Instances", VR.kCS, VM.k1, false);
  static const DED kDICOMRetrievalSequence
      //(0040,E021)
      = const DED(
          "DICOMRetrievalSequence", 0x0040E021, "DICOM Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const DED kDICOMMediaRetrievalSequence
      //(0040,E022)
      = const DED("DICOMMediaRetrievalSequence", 0x0040E022, "DICOM Media Retrieval Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kWADORetrievalSequence
      //(0040,E023)
      = const DED(
          "WADORetrievalSequence", 0x0040E023, "WADO Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const DED kXDSRetrievalSequence
      //(0040,E024)
      = const DED(
          "XDSRetrievalSequence", 0x0040E024, "XDS Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const DED kRepositoryUniqueID
      //(0040,E030)
      =
      const DED("RepositoryUniqueID", 0x0040E030, "Repository Unique ID", VR.kUI, VM.k1, false);
  static const DED kHomeCommunityID
      //(0040,E031)
      = const DED("HomeCommunityID", 0x0040E031, "Home Community ID", VR.kUI, VM.k1, false);
  static const DED kDocumentTitle
      //(0042,0010)
      = const DED("DocumentTitle", 0x00420010, "Document Title", VR.kST, VM.k1, false);
  static const DED kEncapsulatedDocument
      //(0042,0011)
      = const DED(
          "EncapsulatedDocument", 0x00420011, "Encapsulated Document", VR.kOB, VM.k1, false);
  static const DED kMIMETypeOfEncapsulatedDocument
      //(0042,0012)
      = const DED("MIMETypeOfEncapsulatedDocument", 0x00420012,
          "MIME Type of Encapsulated Document", VR.kLO, VM.k1, false);
  static const DED kSourceInstanceSequence
      //(0042,0013)
      = const DED(
          "SourceInstanceSequence", 0x00420013, "Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kListOfMIMETypes
      //(0042,0014)
      = const DED("ListOfMIMETypes", 0x00420014, "List of MIME Types", VR.kLO, VM.k1_n, false);
  static const DED kProductPackageIdentifier
      //(0044,0001)
      = const DED("ProductPackageIdentifier", 0x00440001, "Product Package Identifier", VR.kST,
          VM.k1, false);
  static const DED kSubstanceAdministrationApproval
      //(0044,0002)
      = const DED("SubstanceAdministrationApproval", 0x00440002,
          "Substance Administration Approval", VR.kCS, VM.k1, false);
  static const DED kApprovalStatusFurtherDescription
      //(0044,0003)
      = const DED("ApprovalStatusFurtherDescription", 0x00440003,
          "Approval Status Further Description", VR.kLT, VM.k1, false);
  static const DED kApprovalStatusDateTime
      //(0044,0004)
      = const DED(
          "ApprovalStatusDateTime", 0x00440004, "Approval Status DateTime", VR.kDT, VM.k1, false);
  static const DED kProductTypeCodeSequence
      //(0044,0007)
      = const DED("ProductTypeCodeSequence", 0x00440007, "Product Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kProductName
      //(0044,0008)
      = const DED("ProductName", 0x00440008, "Product Name", VR.kLO, VM.k1_n, false);
  static const DED kProductDescription
      //(0044,0009)
      =
      const DED("ProductDescription", 0x00440009, "Product Description", VR.kLT, VM.k1, false);
  static const DED kProductLotIdentifier
      //(0044,000A)
      = const DED(
          "ProductLotIdentifier", 0x0044000A, "Product Lot Identifier", VR.kLO, VM.k1, false);
  static const DED kProductExpirationDateTime
      //(0044,000B)
      = const DED("ProductExpirationDateTime", 0x0044000B, "Product Expiration DateTime",
          VR.kDT, VM.k1, false);
  static const DED kSubstanceAdministrationDateTime
      //(0044,0010)
      = const DED("SubstanceAdministrationDateTime", 0x00440010,
          "Substance Administration DateTime", VR.kDT, VM.k1, false);
  static const DED kSubstanceAdministrationNotes
      //(0044,0011)
      = const DED("SubstanceAdministrationNotes", 0x00440011, "Substance Administration Notes",
          VR.kLO, VM.k1, false);
  static const DED kSubstanceAdministrationDeviceID
      //(0044,0012)
      = const DED("SubstanceAdministrationDeviceID", 0x00440012,
          "Substance Administration Device ID", VR.kLO, VM.k1, false);
  static const DED kProductParameterSequence
      //(0044,0013)
      = const DED("ProductParameterSequence", 0x00440013, "Product Parameter Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSubstanceAdministrationParameterSequence
      //(0044,0019)
      = const DED("SubstanceAdministrationParameterSequence", 0x00440019,
          "Substance Administration Parameter Sequence", VR.kSQ, VM.k1, false);
  static const DED kLensDescription
      //(0046,0012)
      = const DED("LensDescription", 0x00460012, "Lens Description", VR.kLO, VM.k1, false);
  static const DED kRightLensSequence
      //(0046,0014)
      = const DED("RightLensSequence", 0x00460014, "Right Lens Sequence", VR.kSQ, VM.k1, false);
  static const DED kLeftLensSequence
      //(0046,0015)
      = const DED("LeftLensSequence", 0x00460015, "Left Lens Sequence", VR.kSQ, VM.k1, false);
  static const DED kUnspecifiedLateralityLensSequence
      //(0046,0016)
      = const DED("UnspecifiedLateralityLensSequence", 0x00460016,
          "Unspecified Laterality Lens Sequence", VR.kSQ, VM.k1, false);
  static const DED kCylinderSequence
      //(0046,0018)
      = const DED("CylinderSequence", 0x00460018, "Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const DED kPrismSequence
      //(0046,0028)
      = const DED("PrismSequence", 0x00460028, "Prism Sequence", VR.kSQ, VM.k1, false);
  static const DED kHorizontalPrismPower
      //(0046,0030)
      = const DED(
          "HorizontalPrismPower", 0x00460030, "Horizontal Prism Power", VR.kFD, VM.k1, false);
  static const DED kHorizontalPrismBase
      //(0046,0032)
      = const DED(
          "HorizontalPrismBase", 0x00460032, "Horizontal Prism Base", VR.kCS, VM.k1, false);
  static const DED kVerticalPrismPower
      //(0046,0034)
      =
      const DED("VerticalPrismPower", 0x00460034, "Vertical Prism Power", VR.kFD, VM.k1, false);
  static const DED kVerticalPrismBase
      //(0046,0036)
      = const DED("VerticalPrismBase", 0x00460036, "Vertical Prism Base", VR.kCS, VM.k1, false);
  static const DED kLensSegmentType
      //(0046,0038)
      = const DED("LensSegmentType", 0x00460038, "Lens Segment Type", VR.kCS, VM.k1, false);
  static const DED kOpticalTransmittance
      //(0046,0040)
      = const DED(
          "OpticalTransmittance", 0x00460040, "Optical Transmittance", VR.kFD, VM.k1, false);
  static const DED kChannelWidth
      //(0046,0042)
      = const DED("ChannelWidth", 0x00460042, "Channel Width", VR.kFD, VM.k1, false);
  static const DED kPupilSize
      //(0046,0044)
      = const DED("PupilSize", 0x00460044, "Pupil Size", VR.kFD, VM.k1, false);
  static const DED kCornealSize
      //(0046,0046)
      = const DED("CornealSize", 0x00460046, "Corneal Size", VR.kFD, VM.k1, false);
  static const DED kAutorefractionRightEyeSequence
      //(0046,0050)
      = const DED("AutorefractionRightEyeSequence", 0x00460050,
          "Autorefraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kAutorefractionLeftEyeSequence
      //(0046,0052)
      = const DED("AutorefractionLeftEyeSequence", 0x00460052,
          "Autorefraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kDistancePupillaryDistance
      //(0046,0060)
      = const DED("DistancePupillaryDistance", 0x00460060, "Distance Pupillary Distance",
          VR.kFD, VM.k1, false);
  static const DED kNearPupillaryDistance
      //(0046,0062)
      = const DED(
          "NearPupillaryDistance", 0x00460062, "Near Pupillary Distance", VR.kFD, VM.k1, false);
  static const DED kIntermediatePupillaryDistance
      //(0046,0063)
      = const DED("IntermediatePupillaryDistance", 0x00460063,
          "Intermediate Pupillary Distance", VR.kFD, VM.k1, false);
  static const DED kOtherPupillaryDistance
      //(0046,0064)
      = const DED(
          "OtherPupillaryDistance", 0x00460064, "Other Pupillary Distance", VR.kFD, VM.k1, false);
  static const DED kKeratometryRightEyeSequence
      //(0046,0070)
      = const DED("KeratometryRightEyeSequence", 0x00460070, "Keratometry Right Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kKeratometryLeftEyeSequence
      //(0046,0071)
      = const DED("KeratometryLeftEyeSequence", 0x00460071, "Keratometry Left Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSteepKeratometricAxisSequence
      //(0046,0074)
      = const DED("SteepKeratometricAxisSequence", 0x00460074,
          "Steep Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const DED kRadiusOfCurvature
      //(0046,0075)
      = const DED("RadiusOfCurvature", 0x00460075, "Radius of Curvature", VR.kFD, VM.k1, false);
  static const DED kKeratometricPower
      //(0046,0076)
      = const DED("KeratometricPower", 0x00460076, "Keratometric Power", VR.kFD, VM.k1, false);
  static const DED kKeratometricAxis
      //(0046,0077)
      = const DED("KeratometricAxis", 0x00460077, "Keratometric Axis", VR.kFD, VM.k1, false);
  static const DED kFlatKeratometricAxisSequence
      //(0046,0080)
      = const DED("FlatKeratometricAxisSequence", 0x00460080, "Flat Keratometric Axis Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kBackgroundColor
      //(0046,0092)
      = const DED("BackgroundColor", 0x00460092, "Background Color", VR.kCS, VM.k1, false);
  static const DED kOptotype
      //(0046,0094)
      = const DED("Optotype", 0x00460094, "Optotype", VR.kCS, VM.k1, false);
  static const DED kOptotypePresentation
      //(0046,0095)
      = const DED(
          "OptotypePresentation", 0x00460095, "Optotype Presentation", VR.kCS, VM.k1, false);
  static const DED kSubjectiveRefractionRightEyeSequence
      //(0046,0097)
      = const DED("SubjectiveRefractionRightEyeSequence", 0x00460097,
          "Subjective Refraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kSubjectiveRefractionLeftEyeSequence
      //(0046,0098)
      = const DED("SubjectiveRefractionLeftEyeSequence", 0x00460098,
          "Subjective Refraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kAddNearSequence
      //(0046,0100)
      = const DED("AddNearSequence", 0x00460100, "Add Near Sequence", VR.kSQ, VM.k1, false);
  static const DED kAddIntermediateSequence
      //(0046,0101)
      = const DED(
          "AddIntermediateSequence", 0x00460101, "Add Intermediate Sequence", VR.kSQ, VM.k1, false);
  static const DED kAddOtherSequence
      //(0046,0102)
      = const DED("AddOtherSequence", 0x00460102, "Add Other Sequence", VR.kSQ, VM.k1, false);
  static const DED kAddPower
      //(0046,0104)
      = const DED("AddPower", 0x00460104, "Add Power", VR.kFD, VM.k1, false);
  static const DED kViewingDistance
      //(0046,0106)
      = const DED("ViewingDistance", 0x00460106, "Viewing Distance", VR.kFD, VM.k1, false);
  static const DED kVisualAcuityTypeCodeSequence
      //(0046,0121)
      = const DED("VisualAcuityTypeCodeSequence", 0x00460121,
          "Visual Acuity Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualAcuityRightEyeSequence
      //(0046,0122)
      = const DED("VisualAcuityRightEyeSequence", 0x00460122,
          "Visual Acuity Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const DED kVisualAcuityLeftEyeSequence
      //(0046,0123)
      = const DED("VisualAcuityLeftEyeSequence", 0x00460123, "Visual Acuity Left Eye Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kVisualAcuityBothEyesOpenSequence
      //(0046,0124)
      = const DED("VisualAcuityBothEyesOpenSequence", 0x00460124,
          "Visual Acuity Both Eyes Open Sequence", VR.kSQ, VM.k1, false);
  static const DED kViewingDistanceType
      //(0046,0125)
      = const DED(
          "ViewingDistanceType", 0x00460125, "Viewing Distance Type", VR.kCS, VM.k1, false);
  static const DED kVisualAcuityModifiers
      //(0046,0135)
      = const DED(
          "VisualAcuityModifiers", 0x00460135, "Visual Acuity Modifiers", VR.kSS, VM.k2, false);
  static const DED kDecimalVisualAcuity
      //(0046,0137)
      = const DED(
          "DecimalVisualAcuity", 0x00460137, "Decimal Visual Acuity", VR.kFD, VM.k1, false);
  static const DED kOptotypeDetailedDefinition
      //(0046,0139)
      = const DED("OptotypeDetailedDefinition", 0x00460139, "Optotype Detailed Definition",
          VR.kLO, VM.k1, false);
  static const DED kReferencedRefractiveMeasurementsSequence
      //(0046,0145)
      = const DED("ReferencedRefractiveMeasurementsSequence", 0x00460145,
          "Referenced Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpherePower
      //(0046,0146)
      = const DED("SpherePower", 0x00460146, "Sphere Power", VR.kFD, VM.k1, false);
  static const DED kCylinderPower
      //(0046,0147)
      = const DED("CylinderPower", 0x00460147, "Cylinder Power", VR.kFD, VM.k1, false);
  static const DED kCornealTopographySurface
      //(0046,0201)
      = const DED("CornealTopographySurface", 0x00460201, "Corneal Topography Surface", VR.kCS,
          VM.k1, false);
  static const DED kCornealVertexLocation
      //(0046,0202)
      = const DED(
          "CornealVertexLocation", 0x00460202, "Corneal Vertex Location", VR.kFL, VM.k2, false);
  static const DED kPupilCentroidXCoordinate
      //(0046,0203)
      = const DED("PupilCentroidXCoordinate", 0x00460203, "Pupil Centroid X-Coordinate", VR.kFL,
          VM.k1, false);
  static const DED kPupilCentroidYCoordinate
      //(0046,0204)
      = const DED("PupilCentroidYCoordinate", 0x00460204, "Pupil Centroid Y-Coordinate", VR.kFL,
          VM.k1, false);
  static const DED kEquivalentPupilRadius
      //(0046,0205)
      = const DED(
          "EquivalentPupilRadius", 0x00460205, "Equivalent Pupil Radius", VR.kFL, VM.k1, false);
  static const DED kCornealTopographyMapTypeCodeSequence
      //(0046,0207)
      = const DED("CornealTopographyMapTypeCodeSequence", 0x00460207,
          "Corneal Topography Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kVerticesOfTheOutlineOfPupil
      //(0046,0208)
      = const DED("VerticesOfTheOutlineOfPupil", 0x00460208, "Vertices of the Outline of Pupil",
          VR.kIS, VM.k2_2n, false);
  static const DED kCornealTopographyMappingNormalsSequence
      //(0046,0210)
      = const DED("CornealTopographyMappingNormalsSequence", 0x00460210,
          "Corneal Topography Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const DED kMaximumCornealCurvatureSequence
      //(0046,0211)
      = const DED("MaximumCornealCurvatureSequence", 0x00460211,
          "Maximum Corneal Curvature Sequence", VR.kSQ, VM.k1, false);
  static const DED kMaximumCornealCurvature
      //(0046,0212)
      = const DED(
          "MaximumCornealCurvature", 0x00460212, "Maximum Corneal Curvature", VR.kFL, VM.k1, false);
  static const DED kMaximumCornealCurvatureLocation
      //(0046,0213)
      = const DED("MaximumCornealCurvatureLocation", 0x00460213,
          "Maximum Corneal Curvature Location", VR.kFL, VM.k2, false);
  static const DED kMinimumKeratometricSequence
      //(0046,0215)
      = const DED("MinimumKeratometricSequence", 0x00460215, "Minimum Keratometric Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSimulatedKeratometricCylinderSequence
      //(0046,0218)
      = const DED("SimulatedKeratometricCylinderSequence", 0x00460218,
          "Simulated Keratometric Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const DED kAverageCornealPower
      //(0046,0220)
      = const DED(
          "AverageCornealPower", 0x00460220, "Average Corneal Power", VR.kFL, VM.k1, false);
  static const DED kCornealISValue
      //(0046,0224)
      = const DED("CornealISValue", 0x00460224, "Corneal I-S Value", VR.kFL, VM.k1, false);
  static const DED kAnalyzedArea
      //(0046,0227)
      = const DED("AnalyzedArea", 0x00460227, "Analyzed Area", VR.kFL, VM.k1, false);
  static const DED kSurfaceRegularityIndex
      //(0046,0230)
      = const DED(
          "SurfaceRegularityIndex", 0x00460230, "Surface Regularity Index", VR.kFL, VM.k1, false);
  static const DED kSurfaceAsymmetryIndex
      //(0046,0232)
      = const DED(
          "SurfaceAsymmetryIndex", 0x00460232, "Surface Asymmetry Index", VR.kFL, VM.k1, false);
  static const DED kCornealEccentricityIndex
      //(0046,0234)
      = const DED("CornealEccentricityIndex", 0x00460234, "Corneal Eccentricity Index", VR.kFL,
          VM.k1, false);
  static const DED kKeratoconusPredictionIndex
      //(0046,0236)
      = const DED("KeratoconusPredictionIndex", 0x00460236, "Keratoconus Prediction Index",
          VR.kFL, VM.k1, false);
  static const DED kDecimalPotentialVisualAcuity
      //(0046,0238)
      = const DED("DecimalPotentialVisualAcuity", 0x00460238, "Decimal Potential Visual Acuity",
          VR.kFL, VM.k1, false);
  static const DED kCornealTopographyMapQualityEvaluation
      //(0046,0242)
      = const DED("CornealTopographyMapQualityEvaluation", 0x00460242,
          "Corneal Topography Map Quality Evaluation", VR.kCS, VM.k1, false);
  static const DED kSourceImageCornealProcessedDataSequence
      //(0046,0244)
      = const DED("SourceImageCornealProcessedDataSequence", 0x00460244,
          "Source Image Corneal Processed Data Sequence", VR.kSQ, VM.k1, false);
  static const DED kCornealPointLocation
      //(0046,0247)
      = const DED(
          "CornealPointLocation", 0x00460247, "Corneal Point Location", VR.kFL, VM.k3, false);
  static const DED kCornealPointEstimated
      //(0046,0248)
      = const DED(
          "CornealPointEstimated", 0x00460248, "Corneal Point Estimated", VR.kCS, VM.k1, false);
  static const DED kAxialPower
      //(0046,0249)
      = const DED("AxialPower", 0x00460249, "Axial Power", VR.kFL, VM.k1, false);
  static const DED kTangentialPower
      //(0046,0250)
      = const DED("TangentialPower", 0x00460250, "Tangential Power", VR.kFL, VM.k1, false);
  static const DED kRefractivePower
      //(0046,0251)
      = const DED("RefractivePower", 0x00460251, "Refractive Power", VR.kFL, VM.k1, false);
  static const DED kRelativeElevation
      //(0046,0252)
      = const DED("RelativeElevation", 0x00460252, "Relative Elevation", VR.kFL, VM.k1, false);
  static const DED kCornealWavefront
      //(0046,0253)
      = const DED("CornealWavefront", 0x00460253, "Corneal Wavefront", VR.kFL, VM.k1, false);
  static const DED kImagedVolumeWidth
      //(0048,0001)
      = const DED("ImagedVolumeWidth", 0x00480001, "Imaged Volume Width", VR.kFL, VM.k1, false);
  static const DED kImagedVolumeHeight
      //(0048,0002)
      =
      const DED("ImagedVolumeHeight", 0x00480002, "Imaged Volume Height", VR.kFL, VM.k1, false);
  static const DED kImagedVolumeDepth
      //(0048,0003)
      = const DED("ImagedVolumeDepth", 0x00480003, "Imaged Volume Depth", VR.kFL, VM.k1, false);
  static const DED kTotalPixelMatrixColumns
      //(0048,0006)
      = const DED("TotalPixelMatrixColumns", 0x00480006, "Total Pixel Matrix Columns", VR.kUL,
          VM.k1, false);
  static const DED kTotalPixelMatrixRows
      //(0048,0007)
      = const DED(
          "TotalPixelMatrixRows", 0x00480007, "Total Pixel Matrix Rows", VR.kUL, VM.k1, false);
  static const DED kTotalPixelMatrixOriginSequence
      //(0048,0008)
      = const DED("TotalPixelMatrixOriginSequence", 0x00480008,
          "Total Pixel Matrix Origin Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecimenLabelInImage
      //(0048,0010)
      = const DED(
          "SpecimenLabelInImage", 0x00480010, "Specimen Label in Image", VR.kCS, VM.k1, false);
  static const DED kFocusMethod
      //(0048,0011)
      = const DED("FocusMethod", 0x00480011, "Focus Method", VR.kCS, VM.k1, false);
  static const DED kExtendedDepthOfField
      //(0048,0012)
      = const DED(
          "ExtendedDepthOfField", 0x00480012, "Extended Depth of Field", VR.kCS, VM.k1, false);
  static const DED kNumberOfFocalPlanes
      //(0048,0013)
      = const DED(
          "NumberOfFocalPlanes", 0x00480013, "Number of Focal Planes", VR.kUS, VM.k1, false);
  static const DED kDistanceBetweenFocalPlanes
      //(0048,0014)
      = const DED("DistanceBetweenFocalPlanes", 0x00480014, "Distance Between Focal Planes",
          VR.kFL, VM.k1, false);
  static const DED kRecommendedAbsentPixelCIELabValue
      //(0048,0015)
      = const DED("RecommendedAbsentPixelCIELabValue", 0x00480015,
          "Recommended Absent Pixel CIELab Value", VR.kUS, VM.k3, false);
  static const DED kIlluminatorTypeCodeSequence
      //(0048,0100)
      = const DED("IlluminatorTypeCodeSequence", 0x00480100, "Illuminator Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImageOrientationSlide
      //(0048,0102)
      = const DED(
          "ImageOrientationSlide", 0x00480102, "Image Orientation (Slide)", VR.kDS, VM.k6, false);
  static const DED kOpticalPathSequence
      //(0048,0105)
      = const DED(
          "OpticalPathSequence", 0x00480105, "Optical Path Sequence", VR.kSQ, VM.k1, false);
  static const DED kOpticalPathIdentifier
      //(0048,0106)
      = const DED(
          "OpticalPathIdentifier", 0x00480106, "Optical Path Identifier", VR.kSH, VM.k1, false);
  static const DED kOpticalPathDescription
      //(0048,0107)
      = const DED(
          "OpticalPathDescription", 0x00480107, "Optical Path Description", VR.kST, VM.k1, false);
  static const DED kIlluminationColorCodeSequence
      //(0048,0108)
      = const DED("IlluminationColorCodeSequence", 0x00480108,
          "Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecimenReferenceSequence
      //(0048,0110)
      = const DED("SpecimenReferenceSequence", 0x00480110, "Specimen Reference Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCondenserLensPower
      //(0048,0111)
      =
      const DED("CondenserLensPower", 0x00480111, "Condenser Lens Power", VR.kDS, VM.k1, false);
  static const DED kObjectiveLensPower
      //(0048,0112)
      =
      const DED("ObjectiveLensPower", 0x00480112, "Objective Lens Power", VR.kDS, VM.k1, false);
  static const DED kObjectiveLensNumericalAperture
      //(0048,0113)
      = const DED("ObjectiveLensNumericalAperture", 0x00480113,
          "Objective Lens Numerical Aperture", VR.kDS, VM.k1, false);
  static const DED kPaletteColorLookupTableSequence
      //(0048,0120)
      = const DED("PaletteColorLookupTableSequence", 0x00480120,
          "Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedImageNavigationSequence
      //(0048,0200)
      = const DED("ReferencedImageNavigationSequence", 0x00480200,
          "Referenced Image Navigation Sequence", VR.kSQ, VM.k1, false);
  static const DED kTopLeftHandCornerOfLocalizerArea
      //(0048,0201)
      = const DED("TopLeftHandCornerOfLocalizerArea", 0x00480201,
          "Top Left Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const DED kBottomRightHandCornerOfLocalizerArea
      //(0048,0202)
      = const DED("BottomRightHandCornerOfLocalizerArea", 0x00480202,
          "Bottom Right Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const DED kOpticalPathIdentificationSequence
      //(0048,0207)
      = const DED("OpticalPathIdentificationSequence", 0x00480207,
          "Optical Path Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlanePositionSlideSequence
      //(0048,021A)
      = const DED("PlanePositionSlideSequence", 0x0048021A, "Plane Position (Slide) Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kColumnPositionInTotalImagePixelMatrix
      //(0048,021E)
      = const DED("ColumnPositionInTotalImagePixelMatrix", 0x0048021E,
          "Column Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const DED kRowPositionInTotalImagePixelMatrix
      //(0048,021F)
      = const DED("RowPositionInTotalImagePixelMatrix", 0x0048021F,
          "Row Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const DED kPixelOriginInterpretation
      //(0048,0301)
      = const DED("PixelOriginInterpretation", 0x00480301, "Pixel Origin Interpretation",
          VR.kCS, VM.k1, false);
  static const DED kCalibrationImage
      //(0050,0004)
      = const DED("CalibrationImage", 0x00500004, "Calibration Image", VR.kCS, VM.k1, false);
  static const DED kDeviceSequence
      //(0050,0010)
      = const DED("DeviceSequence", 0x00500010, "Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kContainerComponentTypeCodeSequence
      //(0050,0012)
      = const DED("ContainerComponentTypeCodeSequence", 0x00500012,
          "Container Component Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kContainerComponentThickness
      //(0050,0013)
      = const DED("ContainerComponentThickness", 0x00500013, "Container Component Thickness",
          VR.kFD, VM.k1, false);
  static const DED kDeviceLength
      //(0050,0014)
      = const DED("DeviceLength", 0x00500014, "Device Length", VR.kDS, VM.k1, false);
  static const DED kContainerComponentWidth
      //(0050,0015)
      = const DED(
          "ContainerComponentWidth", 0x00500015, "Container Component Width", VR.kFD, VM.k1, false);
  static const DED kDeviceDiameter
      //(0050,0016)
      = const DED("DeviceDiameter", 0x00500016, "Device Diameter", VR.kDS, VM.k1, false);
  static const DED kDeviceDiameterUnits
      //(0050,0017)
      = const DED(
          "DeviceDiameterUnits", 0x00500017, "Device Diameter Units", VR.kCS, VM.k1, false);
  static const DED kDeviceVolume
      //(0050,0018)
      = const DED("DeviceVolume", 0x00500018, "Device Volume", VR.kDS, VM.k1, false);
  static const DED kInterMarkerDistance
      //(0050,0019)
      = const DED(
          "InterMarkerDistance", 0x00500019, "Inter-Marker Distance", VR.kDS, VM.k1, false);
  static const DED kContainerComponentMaterial
      //(0050,001A)
      = const DED("ContainerComponentMaterial", 0x0050001A, "Container Component Material",
          VR.kCS, VM.k1, false);
  static const DED kContainerComponentID
      //(0050,001B)
      = const DED(
          "ContainerComponentID", 0x0050001B, "Container Component ID", VR.kLO, VM.k1, false);
  static const DED kContainerComponentLength
      //(0050,001C)
      = const DED("ContainerComponentLength", 0x0050001C, "Container Component Length", VR.kFD,
          VM.k1, false);
  static const DED kContainerComponentDiameter
      //(0050,001D)
      = const DED("ContainerComponentDiameter", 0x0050001D, "Container Component Diameter",
          VR.kFD, VM.k1, false);
  static const DED kContainerComponentDescription
      //(0050,001E)
      = const DED("ContainerComponentDescription", 0x0050001E,
          "Container Component Description", VR.kLO, VM.k1, false);
  static const DED kDeviceDescription
      //(0050,0020)
      = const DED("DeviceDescription", 0x00500020, "Device Description", VR.kLO, VM.k1, false);
  static const DED kContrastBolusIngredientPercentByVolume
      //(0052,0001)
      = const DED("ContrastBolusIngredientPercentByVolume", 0x00520001,
          "Contrast/Bolus Ingredient Percent by Volume", VR.kFL, VM.k1, false);
  static const DED kOCTFocalDistance
      //(0052,0002)
      = const DED("OCTFocalDistance", 0x00520002, "OCT Focal Distance", VR.kFD, VM.k1, false);
  static const DED kBeamSpotSize
      //(0052,0003)
      = const DED("BeamSpotSize", 0x00520003, "Beam Spot Size", VR.kFD, VM.k1, false);
  static const DED kEffectiveRefractiveIndex
      //(0052,0004)
      = const DED("EffectiveRefractiveIndex", 0x00520004, "Effective Refractive Index", VR.kFD,
          VM.k1, false);
  static const DED kOCTAcquisitionDomain
      //(0052,0006)
      = const DED(
          "OCTAcquisitionDomain", 0x00520006, "OCT Acquisition Domain", VR.kCS, VM.k1, false);
  static const DED kOCTOpticalCenterWavelength
      //(0052,0007)
      = const DED("OCTOpticalCenterWavelength", 0x00520007, "OCT Optical Center Wavelength",
          VR.kFD, VM.k1, false);
  static const DED kAxialResolution
      //(0052,0008)
      = const DED("AxialResolution", 0x00520008, "Axial Resolution", VR.kFD, VM.k1, false);
  static const DED kRangingDepth
      //(0052,0009)
      = const DED("RangingDepth", 0x00520009, "Ranging Depth", VR.kFD, VM.k1, false);
  static const DED kALineRate
      //(0052,0011)
      = const DED("ALineRate", 0x00520011, "A-line Rate", VR.kFD, VM.k1, false);
  static const DED kALinesPerFrame
      //(0052,0012)
      = const DED("ALinesPerFrame", 0x00520012, "A-lines Per Frame", VR.kUS, VM.k1, false);
  static const DED kCatheterRotationalRate
      //(0052,0013)
      = const DED(
          "CatheterRotationalRate", 0x00520013, "Catheter Rotational Rate", VR.kFD, VM.k1, false);
  static const DED kALinePixelSpacing
      //(0052,0014)
      =
      const DED("ALinePixelSpacing", 0x00520014, "A-line Pixel Spacing", VR.kFD, VM.k1, false);
  static const DED kModeOfPercutaneousAccessSequence
      //(0052,0016)
      = const DED("ModeOfPercutaneousAccessSequence", 0x00520016,
          "Mode of Percutaneous Access Sequence", VR.kSQ, VM.k1, false);
  static const DED kIntravascularOCTFrameTypeSequence
      //(0052,0025)
      = const DED("IntravascularOCTFrameTypeSequence", 0x00520025,
          "Intravascular OCT Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const DED kOCTZOffsetApplied
      //(0052,0026)
      =
      const DED("OCTZOffsetApplied", 0x00520026, "OCT Z Offset Applied", VR.kCS, VM.k1, false);
  static const DED kIntravascularFrameContentSequence
      //(0052,0027)
      = const DED("IntravascularFrameContentSequence", 0x00520027,
          "Intravascular Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const DED kIntravascularLongitudinalDistance
      //(0052,0028)
      = const DED("IntravascularLongitudinalDistance", 0x00520028,
          "Intravascular Longitudinal Distance", VR.kFD, VM.k1, false);
  static const DED kIntravascularOCTFrameContentSequence
      //(0052,0029)
      = const DED("IntravascularOCTFrameContentSequence", 0x00520029,
          "Intravascular OCT Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const DED kOCTZOffsetCorrection
      //(0052,0030)
      = const DED(
          "OCTZOffsetCorrection", 0x00520030, "OCT Z Offset Correction", VR.kSS, VM.k1, false);
  static const DED kCatheterDirectionOfRotation
      //(0052,0031)
      = const DED("CatheterDirectionOfRotation", 0x00520031, "Catheter Direction of Rotation",
          VR.kCS, VM.k1, false);
  static const DED kSeamLineLocation
      //(0052,0033)
      = const DED("SeamLineLocation", 0x00520033, "Seam Line Location", VR.kFD, VM.k1, false);
  static const DED kFirstALineLocation
      //(0052,0034)
      = const DED(
          "FirstALineLocation", 0x00520034, "First A-line Location", VR.kFD, VM.k1, false);
  static const DED kSeamLineIndex
      //(0052,0036)
      = const DED("SeamLineIndex", 0x00520036, "Seam Line Index", VR.kUS, VM.k1, false);
  static const DED kNumberOfPaddedALines
      //(0052,0038)
      = const DED(
          "NumberOfPaddedALines", 0x00520038, "Number of Padded A-lines", VR.kUS, VM.k1, false);
  static const DED kInterpolationType
      //(0052,0039)
      = const DED("InterpolationType", 0x00520039, "Interpolation Type", VR.kCS, VM.k1, false);
  static const DED kRefractiveIndexApplied
      //(0052,003A)
      = const DED(
          "RefractiveIndexApplied", 0x0052003A, "Refractive Index Applied", VR.kCS, VM.k1, false);
  static const DED kEnergyWindowVector
      //(0054,0010)
      = const DED(
          "EnergyWindowVector", 0x00540010, "Energy Window Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfEnergyWindows
      //(0054,0011)
      = const DED(
          "NumberOfEnergyWindows", 0x00540011, "Number of Energy Windows", VR.kUS, VM.k1, false);
  static const DED kEnergyWindowInformationSequence
      //(0054,0012)
      = const DED("EnergyWindowInformationSequence", 0x00540012,
          "Energy Window Information Sequence", VR.kSQ, VM.k1, false);
  static const DED kEnergyWindowRangeSequence
      //(0054,0013)
      = const DED("EnergyWindowRangeSequence", 0x00540013, "Energy Window Range Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kEnergyWindowLowerLimit
      //(0054,0014)
      = const DED(
          "EnergyWindowLowerLimit", 0x00540014, "Energy Window Lower Limit", VR.kDS, VM.k1, false);
  static const DED kEnergyWindowUpperLimit
      //(0054,0015)
      = const DED(
          "EnergyWindowUpperLimit", 0x00540015, "Energy Window Upper Limit", VR.kDS, VM.k1, false);
  static const DED kRadiopharmaceuticalInformationSequence
      //(0054,0016)
      = const DED("RadiopharmaceuticalInformationSequence", 0x00540016,
          "Radiopharmaceutical Information Sequence", VR.kSQ, VM.k1, false);
  static const DED kResidualSyringeCounts
      //(0054,0017)
      = const DED(
          "ResidualSyringeCounts", 0x00540017, "Residual Syringe Counts", VR.kIS, VM.k1, false);
  static const DED kEnergyWindowName
      //(0054,0018)
      = const DED("EnergyWindowName", 0x00540018, "Energy Window Name", VR.kSH, VM.k1, false);
  static const DED kDetectorVector
      //(0054,0020)
      = const DED("DetectorVector", 0x00540020, "Detector Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfDetectors
      //(0054,0021)
      = const DED("NumberOfDetectors", 0x00540021, "Number of Detectors", VR.kUS, VM.k1, false);
  static const DED kDetectorInformationSequence
      //(0054,0022)
      = const DED("DetectorInformationSequence", 0x00540022, "Detector Information Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPhaseVector
      //(0054,0030)
      = const DED("PhaseVector", 0x00540030, "Phase Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfPhases
      //(0054,0031)
      = const DED("NumberOfPhases", 0x00540031, "Number of Phases", VR.kUS, VM.k1, false);
  static const DED kPhaseInformationSequence
      //(0054,0032)
      = const DED("PhaseInformationSequence", 0x00540032, "Phase Information Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kNumberOfFramesInPhase
      //(0054,0033)
      = const DED(
          "NumberOfFramesInPhase", 0x00540033, "Number of Frames in Phase", VR.kUS, VM.k1, false);
  static const DED kPhaseDelay
      //(0054,0036)
      = const DED("PhaseDelay", 0x00540036, "Phase Delay", VR.kIS, VM.k1, false);
  static const DED kPauseBetweenFrames
      //(0054,0038)
      =
      const DED("PauseBetweenFrames", 0x00540038, "Pause Between Frames", VR.kIS, VM.k1, false);
  static const DED kPhaseDescription
      //(0054,0039)
      = const DED("PhaseDescription", 0x00540039, "Phase Description", VR.kCS, VM.k1, false);
  static const DED kRotationVector
      //(0054,0050)
      = const DED("RotationVector", 0x00540050, "Rotation Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfRotations
      //(0054,0051)
      = const DED("NumberOfRotations", 0x00540051, "Number of Rotations", VR.kUS, VM.k1, false);
  static const DED kRotationInformationSequence
      //(0054,0052)
      = const DED("RotationInformationSequence", 0x00540052, "Rotation Information Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kNumberOfFramesInRotation
      //(0054,0053)
      = const DED("NumberOfFramesInRotation", 0x00540053, "Number of Frames in Rotation",
          VR.kUS, VM.k1, false);
  static const DED kRRIntervalVector
      //(0054,0060)
      =
      const DED("RRIntervalVector", 0x00540060, "R-R Interval Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfRRIntervals
      //(0054,0061)
      = const DED(
          "NumberOfRRIntervals", 0x00540061, "Number of R-R Intervals", VR.kUS, VM.k1, false);
  static const DED kGatedInformationSequence
      //(0054,0062)
      = const DED("GatedInformationSequence", 0x00540062, "Gated Information Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kDataInformationSequence
      //(0054,0063)
      = const DED(
          "DataInformationSequence", 0x00540063, "Data Information Sequence", VR.kSQ, VM.k1, false);
  static const DED kTimeSlotVector
      //(0054,0070)
      = const DED("TimeSlotVector", 0x00540070, "Time Slot Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfTimeSlots
      //(0054,0071)
      =
      const DED("NumberOfTimeSlots", 0x00540071, "Number of Time Slots", VR.kUS, VM.k1, false);
  static const DED kTimeSlotInformationSequence
      //(0054,0072)
      = const DED("TimeSlotInformationSequence", 0x00540072, "Time Slot Information Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTimeSlotTime
      //(0054,0073)
      = const DED("TimeSlotTime", 0x00540073, "Time Slot Time", VR.kDS, VM.k1, false);
  static const DED kSliceVector
      //(0054,0080)
      = const DED("SliceVector", 0x00540080, "Slice Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfSlices
      //(0054,0081)
      = const DED("NumberOfSlices", 0x00540081, "Number of Slices", VR.kUS, VM.k1, false);
  static const DED kAngularViewVector
      //(0054,0090)
      =
      const DED("AngularViewVector", 0x00540090, "Angular View Vector", VR.kUS, VM.k1_n, false);
  static const DED kTimeSliceVector
      //(0054,0100)
      = const DED("TimeSliceVector", 0x00540100, "Time Slice Vector", VR.kUS, VM.k1_n, false);
  static const DED kNumberOfTimeSlices
      //(0054,0101)
      = const DED(
          "NumberOfTimeSlices", 0x00540101, "Number of Time Slices", VR.kUS, VM.k1, false);
  static const DED kStartAngle
      //(0054,0200)
      = const DED("StartAngle", 0x00540200, "Start Angle", VR.kDS, VM.k1, false);
  static const DED kTypeOfDetectorMotion
      //(0054,0202)
      = const DED(
          "TypeOfDetectorMotion", 0x00540202, "Type of Detector Motion", VR.kCS, VM.k1, false);
  static const DED kTriggerVector
      //(0054,0210)
      = const DED("TriggerVector", 0x00540210, "Trigger Vector", VR.kIS, VM.k1_n, false);
  static const DED kNumberOfTriggersInPhase
      //(0054,0211)
      = const DED("NumberOfTriggersInPhase", 0x00540211, "Number of Triggers in Phase", VR.kUS,
          VM.k1, false);
  static const DED kViewCodeSequence
      //(0054,0220)
      = const DED("ViewCodeSequence", 0x00540220, "View Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kViewModifierCodeSequence
      //(0054,0222)
      = const DED("ViewModifierCodeSequence", 0x00540222, "View Modifier Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kRadionuclideCodeSequence
      //(0054,0300)
      = const DED("RadionuclideCodeSequence", 0x00540300, "Radionuclide Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kAdministrationRouteCodeSequence
      //(0054,0302)
      = const DED("AdministrationRouteCodeSequence", 0x00540302,
          "Administration Route Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kRadiopharmaceuticalCodeSequence
      //(0054,0304)
      = const DED("RadiopharmaceuticalCodeSequence", 0x00540304,
          "Radiopharmaceutical Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kCalibrationDataSequence
      //(0054,0306)
      = const DED(
          "CalibrationDataSequence", 0x00540306, "Calibration Data Sequence", VR.kSQ, VM.k1, false);
  static const DED kEnergyWindowNumber
      //(0054,0308)
      =
      const DED("EnergyWindowNumber", 0x00540308, "Energy Window Number", VR.kUS, VM.k1, false);
  static const DED kImageID
      //(0054,0400)
      = const DED("ImageID", 0x00540400, "Image ID", VR.kSH, VM.k1, false);
  static const DED kPatientOrientationCodeSequence
      //(0054,0410)
      = const DED("PatientOrientationCodeSequence", 0x00540410,
          "Patient Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientOrientationModifierCodeSequence
      //(0054,0412)
      = const DED("PatientOrientationModifierCodeSequence", 0x00540412,
          "Patient Orientation Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientGantryRelationshipCodeSequence
      //(0054,0414)
      = const DED("PatientGantryRelationshipCodeSequence", 0x00540414,
          "Patient Gantry Relationship Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSliceProgressionDirection
      //(0054,0500)
      = const DED("SliceProgressionDirection", 0x00540500, "Slice Progression Direction",
          VR.kCS, VM.k1, false);
  static const DED kSeriesType
      //(0054,1000)
      = const DED("SeriesType", 0x00541000, "Series Type", VR.kCS, VM.k2, false);
  static const DED kUnits
      //(0054,1001)
      = const DED("Units", 0x00541001, "Units", VR.kCS, VM.k1, false);
  static const DED kCountsSource
      //(0054,1002)
      = const DED("CountsSource", 0x00541002, "Counts Source", VR.kCS, VM.k1, false);
  static const DED kReprojectionMethod
      //(0054,1004)
      =
      const DED("ReprojectionMethod", 0x00541004, "Reprojection Method", VR.kCS, VM.k1, false);
  static const DED kSUVType
      //(0054,1006)
      = const DED("SUVType", 0x00541006, "SUV Type", VR.kCS, VM.k1, false);
  static const DED kRandomsCorrectionMethod
      //(0054,1100)
      = const DED(
          "RandomsCorrectionMethod", 0x00541100, "Randoms Correction Method", VR.kCS, VM.k1, false);
  static const DED kAttenuationCorrectionMethod
      //(0054,1101)
      = const DED("AttenuationCorrectionMethod", 0x00541101, "Attenuation Correction Method",
          VR.kLO, VM.k1, false);
  static const DED kDecayCorrection
      //(0054,1102)
      = const DED("DecayCorrection", 0x00541102, "Decay Correction", VR.kCS, VM.k1, false);
  static const DED kReconstructionMethod
      //(0054,1103)
      = const DED(
          "ReconstructionMethod", 0x00541103, "Reconstruction Method", VR.kLO, VM.k1, false);
  static const DED kDetectorLinesOfResponseUsed
      //(0054,1104)
      = const DED("DetectorLinesOfResponseUsed", 0x00541104, "Detector Lines of Response Used",
          VR.kLO, VM.k1, false);
  static const DED kScatterCorrectionMethod
      //(0054,1105)
      = const DED(
          "ScatterCorrectionMethod", 0x00541105, "Scatter Correction Method", VR.kLO, VM.k1, false);
  static const DED kAxialAcceptance
      //(0054,1200)
      = const DED("AxialAcceptance", 0x00541200, "Axial Acceptance", VR.kDS, VM.k1, false);
  static const DED kAxialMash
      //(0054,1201)
      = const DED("AxialMash", 0x00541201, "Axial Mash", VR.kIS, VM.k2, false);
  static const DED kTransverseMash
      //(0054,1202)
      = const DED("TransverseMash", 0x00541202, "Transverse Mash", VR.kIS, VM.k1, false);
  static const DED kDetectorElementSize
      //(0054,1203)
      = const DED(
          "DetectorElementSize", 0x00541203, "Detector Element Size", VR.kDS, VM.k2, false);
  static const DED kCoincidenceWindowWidth
      //(0054,1210)
      = const DED(
          "CoincidenceWindowWidth", 0x00541210, "Coincidence Window Width", VR.kDS, VM.k1, false);
  static const DED kSecondaryCountsType
      //(0054,1220)
      = const DED(
          "SecondaryCountsType", 0x00541220, "Secondary Counts Type", VR.kCS, VM.k1_n, false);
  static const DED kFrameReferenceTime
      //(0054,1300)
      =
      const DED("FrameReferenceTime", 0x00541300, "Frame Reference Time", VR.kDS, VM.k1, false);
  static const DED kPrimaryPromptsCountsAccumulated
      //(0054,1310)
      = const DED("PrimaryPromptsCountsAccumulated", 0x00541310,
          "Primary (Prompts) Counts Accumulated", VR.kIS, VM.k1, false);
  static const DED kSecondaryCountsAccumulated
      //(0054,1311)
      = const DED("SecondaryCountsAccumulated", 0x00541311, "Secondary Counts Accumulated",
          VR.kIS, VM.k1_n, false);
  static const DED kSliceSensitivityFactor
      //(0054,1320)
      = const DED(
          "SliceSensitivityFactor", 0x00541320, "Slice Sensitivity Factor", VR.kDS, VM.k1, false);
  static const DED kDecayFactor
      //(0054,1321)
      = const DED("DecayFactor", 0x00541321, "Decay Factor", VR.kDS, VM.k1, false);
  static const DED kDoseCalibrationFactor
      //(0054,1322)
      = const DED(
          "DoseCalibrationFactor", 0x00541322, "Dose Calibration Factor", VR.kDS, VM.k1, false);
  static const DED kScatterFractionFactor
      //(0054,1323)
      = const DED(
          "ScatterFractionFactor", 0x00541323, "Scatter Fraction Factor", VR.kDS, VM.k1, false);
  static const DED kDeadTimeFactor
      //(0054,1324)
      = const DED("DeadTimeFactor", 0x00541324, "Dead Time Factor", VR.kDS, VM.k1, false);
  static const DED kImageIndex
      //(0054,1330)
      = const DED("ImageIndex", 0x00541330, "Image Index", VR.kUS, VM.k1, false);
  static const DED kCountsIncluded
      //(0054,1400)
      = const DED("CountsIncluded", 0x00541400, "Counts Included", VR.kCS, VM.k1_n, true);
  static const DED kDeadTimeCorrectionFlag
      //(0054,1401)
      = const DED(
          "DeadTimeCorrectionFlag", 0x00541401, "Dead Time Correction Flag", VR.kCS, VM.k1, true);
  static const DED kHistogramSequence
      //(0060,3000)
      = const DED("HistogramSequence", 0x00603000, "Histogram Sequence", VR.kSQ, VM.k1, false);
  static const DED kHistogramNumberOfBins
      //(0060,3002)
      = const DED(
          "HistogramNumberOfBins", 0x00603002, "Histogram Number of Bins", VR.kUS, VM.k1, false);
  static const DED kHistogramFirstBinValue
      //(0060,3004)
      = const DED("HistogramFirstBinValue", 0x00603004, "Histogram First Bin Value", VR.kUSSS,
          VM.k1, false);
  static const DED kHistogramLastBinValue
      //(0060,3006)
      = const DED(
          "HistogramLastBinValue", 0x00603006, "Histogram Last Bin Value", VR.kUSSS, VM.k1, false);
  static const DED kHistogramBinWidth
      //(0060,3008)
      = const DED("HistogramBinWidth", 0x00603008, "Histogram Bin Width", VR.kUS, VM.k1, false);
  static const DED kHistogramExplanation
      //(0060,3010)
      = const DED(
          "HistogramExplanation", 0x00603010, "Histogram Explanation", VR.kLO, VM.k1, false);
  static const DED kHistogramData
      //(0060,3020)
      = const DED("HistogramData", 0x00603020, "Histogram Data", VR.kUL, VM.k1_n, false);
  static const DED kSegmentationType
      //(0062,0001)
      = const DED("SegmentationType", 0x00620001, "Segmentation Type", VR.kCS, VM.k1, false);
  static const DED kSegmentSequence
      //(0062,0002)
      = const DED("SegmentSequence", 0x00620002, "Segment Sequence", VR.kSQ, VM.k1, false);
  static const DED kSegmentedPropertyCategoryCodeSequence
      //(0062,0003)
      = const DED("SegmentedPropertyCategoryCodeSequence", 0x00620003,
          "Segmented Property Category Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSegmentNumber
      //(0062,0004)
      = const DED("SegmentNumber", 0x00620004, "Segment Number", VR.kUS, VM.k1, false);
  static const DED kSegmentLabel
      //(0062,0005)
      = const DED("SegmentLabel", 0x00620005, "Segment Label", VR.kLO, VM.k1, false);
  static const DED kSegmentDescription
      //(0062,0006)
      =
      const DED("SegmentDescription", 0x00620006, "Segment Description", VR.kST, VM.k1, false);
  static const DED kSegmentAlgorithmType
      //(0062,0008)
      = const DED(
          "SegmentAlgorithmType", 0x00620008, "Segment Algorithm Type", VR.kCS, VM.k1, false);
  static const DED kSegmentAlgorithmName
      //(0062,0009)
      = const DED(
          "SegmentAlgorithmName", 0x00620009, "Segment Algorithm Name", VR.kLO, VM.k1, false);
  static const DED kSegmentIdentificationSequence
      //(0062,000A)
      = const DED("SegmentIdentificationSequence", 0x0062000A,
          "Segment Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSegmentNumber
      //(0062,000B)
      = const DED("ReferencedSegmentNumber", 0x0062000B, "Referenced Segment Number", VR.kUS,
          VM.k1_n, false);
  static const DED kRecommendedDisplayGrayscaleValue
      //(0062,000C)
      = const DED("RecommendedDisplayGrayscaleValue", 0x0062000C,
          "Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const DED kRecommendedDisplayCIELabValue
      //(0062,000D)
      = const DED("RecommendedDisplayCIELabValue", 0x0062000D,
          "Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const DED kMaximumFractionalValue
      //(0062,000E)
      = const DED(
          "MaximumFractionalValue", 0x0062000E, "Maximum Fractional Value", VR.kUS, VM.k1, false);
  static const DED kSegmentedPropertyTypeCodeSequence
      //(0062,000F)
      = const DED("SegmentedPropertyTypeCodeSequence", 0x0062000F,
          "Segmented Property Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSegmentationFractionalType
      //(0062,0010)
      = const DED("SegmentationFractionalType", 0x00620010, "Segmentation Fractional Type",
          VR.kCS, VM.k1, false);
  static const DED kSegmentedPropertyTypeModifierCodeSequence
      //(0062,0011)
      = const DED("SegmentedPropertyTypeModifierCodeSequence", 0x00620011,
          "Segmented Property Type Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kUsedSegmentsSequence
      //(0062,0012)
      = const DED(
          "UsedSegmentsSequence", 0x00620012, "Used Segments Sequence", VR.kSQ, VM.k1, false);
  static const DED kDeformableRegistrationSequence
      //(0064,0002)
      = const DED("DeformableRegistrationSequence", 0x00640002,
          "Deformable Registration Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceFrameOfReferenceUID
      //(0064,0003)
      = const DED("SourceFrameOfReferenceUID", 0x00640003, "Source Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const DED kDeformableRegistrationGridSequence
      //(0064,0005)
      = const DED("DeformableRegistrationGridSequence", 0x00640005,
          "Deformable Registration Grid Sequence", VR.kSQ, VM.k1, false);
  static const DED kGridDimensions
      //(0064,0007)
      = const DED("GridDimensions", 0x00640007, "Grid Dimensions", VR.kUL, VM.k3, false);
  static const DED kGridResolution
      //(0064,0008)
      = const DED("GridResolution", 0x00640008, "Grid Resolution", VR.kFD, VM.k3, false);
  static const DED kVectorGridData
      //(0064,0009)
      = const DED("VectorGridData", 0x00640009, "Vector Grid Data", VR.kOF, VM.k1, false);
  static const DED kPreDeformationMatrixRegistrationSequence
      //(0064,000F)
      = const DED("PreDeformationMatrixRegistrationSequence", 0x0064000F,
          "Pre Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const DED kPostDeformationMatrixRegistrationSequence
      //(0064,0010)
      = const DED("PostDeformationMatrixRegistrationSequence", 0x00640010,
          "Post Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumberOfSurfaces
      //(0066,0001)
      = const DED("NumberOfSurfaces", 0x00660001, "Number of Surfaces", VR.kUL, VM.k1, false);
  static const DED kSurfaceSequence
      //(0066,0002)
      = const DED("SurfaceSequence", 0x00660002, "Surface Sequence", VR.kSQ, VM.k1, false);
  static const DED kSurfaceNumber
      //(0066,0003)
      = const DED("SurfaceNumber", 0x00660003, "Surface Number", VR.kUL, VM.k1, false);
  static const DED kSurfaceComments
      //(0066,0004)
      = const DED("SurfaceComments", 0x00660004, "Surface Comments", VR.kLT, VM.k1, false);
  static const DED kSurfaceProcessing
      //(0066,0009)
      = const DED("SurfaceProcessing", 0x00660009, "Surface Processing", VR.kCS, VM.k1, false);
  static const DED kSurfaceProcessingRatio
      //(0066,000A)
      = const DED(
          "SurfaceProcessingRatio", 0x0066000A, "Surface Processing Ratio", VR.kFL, VM.k1, false);
  static const DED kSurfaceProcessingDescription
      //(0066,000B)
      = const DED("SurfaceProcessingDescription", 0x0066000B, "Surface Processing Description",
          VR.kLO, VM.k1, false);
  static const DED kRecommendedPresentationOpacity
      //(0066,000C)
      = const DED("RecommendedPresentationOpacity", 0x0066000C,
          "Recommended Presentation Opacity", VR.kFL, VM.k1, false);
  static const DED kRecommendedPresentationType
      //(0066,000D)
      = const DED("RecommendedPresentationType", 0x0066000D, "Recommended Presentation Type",
          VR.kCS, VM.k1, false);
  static const DED kFiniteVolume
      //(0066,000E)
      = const DED("FiniteVolume", 0x0066000E, "Finite Volume", VR.kCS, VM.k1, false);
  static const DED kManifold
      //(0066,0010)
      = const DED("Manifold", 0x00660010, "Manifold", VR.kCS, VM.k1, false);
  static const DED kSurfacePointsSequence
      //(0066,0011)
      = const DED(
          "SurfacePointsSequence", 0x00660011, "Surface Points Sequence", VR.kSQ, VM.k1, false);
  static const DED kSurfacePointsNormalsSequence
      //(0066,0012)
      = const DED("SurfacePointsNormalsSequence", 0x00660012, "Surface Points Normals Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSurfaceMeshPrimitivesSequence
      //(0066,0013)
      = const DED("SurfaceMeshPrimitivesSequence", 0x00660013,
          "Surface Mesh Primitives Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumberOfSurfacePoints
      //(0066,0015)
      = const DED(
          "NumberOfSurfacePoints", 0x00660015, "Number of Surface Points", VR.kUL, VM.k1, false);
  static const DED kPointCoordinatesData
      //(0066,0016)
      = const DED(
          "PointCoordinatesData", 0x00660016, "Point Coordinates Data", VR.kOF, VM.k1, false);
  static const DED kPointPositionAccuracy
      //(0066,0017)
      = const DED(
          "PointPositionAccuracy", 0x00660017, "Point Position Accuracy", VR.kFL, VM.k3, false);
  static const DED kMeanPointDistance
      //(0066,0018)
      = const DED("MeanPointDistance", 0x00660018, "Mean Point Distance", VR.kFL, VM.k1, false);
  static const DED kMaximumPointDistance
      //(0066,0019)
      = const DED(
          "MaximumPointDistance", 0x00660019, "Maximum Point Distance", VR.kFL, VM.k1, false);
  static const DED kPointsBoundingBoxCoordinates
      //(0066,001A)
      = const DED("PointsBoundingBoxCoordinates", 0x0066001A, "Points Bounding Box Coordinates",
          VR.kFL, VM.k6, false);
  static const DED kAxisOfRotation
      //(0066,001B)
      = const DED("AxisOfRotation", 0x0066001B, "Axis of Rotation", VR.kFL, VM.k3, false);
  static const DED kCenterOfRotation
      //(0066,001C)
      = const DED("CenterOfRotation", 0x0066001C, "Center of Rotation", VR.kFL, VM.k3, false);
  static const DED kNumberOfVectors
      //(0066,001E)
      = const DED("NumberOfVectors", 0x0066001E, "Number of Vectors", VR.kUL, VM.k1, false);
  static const DED kVectorDimensionality
      //(0066,001F)
      = const DED(
          "VectorDimensionality", 0x0066001F, "Vector Dimensionality", VR.kUS, VM.k1, false);
  static const DED kVectorAccuracy
      //(0066,0020)
      = const DED("VectorAccuracy", 0x00660020, "Vector Accuracy", VR.kFL, VM.k1_n, false);
  static const DED kVectorCoordinateData
      //(0066,0021)
      = const DED(
          "VectorCoordinateData", 0x00660021, "Vector Coordinate Data", VR.kOF, VM.k1, false);
  static const DED kTrianglePointIndexList
      //(0066,0023)
      = const DED(
          "TrianglePointIndexList", 0x00660023, "Triangle Point Index List", VR.kOW, VM.k1, false);
  static const DED kEdgePointIndexList
      //(0066,0024)
      = const DED(
          "EdgePointIndexList", 0x00660024, "Edge Point Index List", VR.kOW, VM.k1, false);
  static const DED kVertexPointIndexList
      //(0066,0025)
      = const DED(
          "VertexPointIndexList", 0x00660025, "Vertex Point Index List", VR.kOW, VM.k1, false);
  static const DED kTriangleStripSequence
      //(0066,0026)
      = const DED(
          "TriangleStripSequence", 0x00660026, "Triangle Strip Sequence", VR.kSQ, VM.k1, false);
  static const DED kTriangleFanSequence
      //(0066,0027)
      = const DED(
          "TriangleFanSequence", 0x00660027, "Triangle Fan Sequence", VR.kSQ, VM.k1, false);
  static const DED kLineSequence
      //(0066,0028)
      = const DED("LineSequence", 0x00660028, "Line Sequence", VR.kSQ, VM.k1, false);
  static const DED kPrimitivePointIndexList
      //(0066,0029)
      = const DED("PrimitivePointIndexList", 0x00660029, "Primitive Point Index List", VR.kOW,
          VM.k1, false);
  static const DED kSurfaceCount
      //(0066,002A)
      = const DED("SurfaceCount", 0x0066002A, "Surface Count", VR.kUL, VM.k1, false);
  static const DED kReferencedSurfaceSequence
      //(0066,002B)
      = const DED("ReferencedSurfaceSequence", 0x0066002B, "Referenced Surface Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedSurfaceNumber
      //(0066,002C)
      = const DED(
          "ReferencedSurfaceNumber", 0x0066002C, "Referenced Surface Number", VR.kUL, VM.k1, false);
  static const DED kSegmentSurfaceGenerationAlgorithmIdentificationSequence
      //(0066,002D)
      = const DED("SegmentSurfaceGenerationAlgorithmIdentificationSequence", 0x0066002D,
          "Segment Surface Generation Algorithm Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kSegmentSurfaceSourceInstanceSequence
      //(0066,002E)
      = const DED("SegmentSurfaceSourceInstanceSequence", 0x0066002E,
          "Segment Surface Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kAlgorithmFamilyCodeSequence
      //(0066,002F)
      = const DED("AlgorithmFamilyCodeSequence", 0x0066002F, "Algorithm Family Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAlgorithmNameCodeSequence
      //(0066,0030)
      = const DED("AlgorithmNameCodeSequence", 0x00660030, "Algorithm Name Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAlgorithmVersion
      //(0066,0031)
      = const DED("AlgorithmVersion", 0x00660031, "Algorithm Version", VR.kLO, VM.k1, false);
  static const DED kAlgorithmParameters
      //(0066,0032)
      = const DED(
          "AlgorithmParameters", 0x00660032, "Algorithm Parameters", VR.kLT, VM.k1, false);
  static const DED kFacetSequence
      //(0066,0034)
      = const DED("FacetSequence", 0x00660034, "Facet Sequence", VR.kSQ, VM.k1, false);
  static const DED kSurfaceProcessingAlgorithmIdentificationSequence
      //(0066,0035)
      = const DED("SurfaceProcessingAlgorithmIdentificationSequence", 0x00660035,
          "Surface Processing Algorithm Identification Sequence", VR.kSQ, VM.k1, false);
  static const DED kAlgorithmName
      //(0066,0036)
      = const DED("AlgorithmName", 0x00660036, "Algorithm Name", VR.kLO, VM.k1, false);
  static const DED kRecommendedPointRadius
      //(0066,0037)
      = const DED(
          "RecommendedPointRadius", 0x00660037, "Recommended Point Radius", VR.kFL, VM.k1, false);
  static const DED kRecommendedLineThickness
      //(0066,0038)
      = const DED("RecommendedLineThickness", 0x00660038, "Recommended Line Thickness", VR.kFL,
          VM.k1, false);
  static const DED kImplantSize
      //(0068,6210)
      = const DED("ImplantSize", 0x00686210, "Implant Size", VR.kLO, VM.k1, false);
  static const DED kImplantTemplateVersion
      //(0068,6221)
      = const DED(
          "ImplantTemplateVersion", 0x00686221, "Implant Template Version", VR.kLO, VM.k1, false);
  static const DED kReplacedImplantTemplateSequence
      //(0068,6222)
      = const DED("ReplacedImplantTemplateSequence", 0x00686222,
          "Replaced Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantType
      //(0068,6223)
      = const DED("ImplantType", 0x00686223, "Implant Type", VR.kCS, VM.k1, false);
  static const DED kDerivationImplantTemplateSequence
      //(0068,6224)
      = const DED("DerivationImplantTemplateSequence", 0x00686224,
          "Derivation Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kOriginalImplantTemplateSequence
      //(0068,6225)
      = const DED("OriginalImplantTemplateSequence", 0x00686225,
          "Original Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kEffectiveDateTime
      //(0068,6226)
      = const DED("EffectiveDateTime", 0x00686226, "Effective DateTime", VR.kDT, VM.k1, false);
  static const DED kImplantTargetAnatomySequence
      //(0068,6230)
      = const DED("ImplantTargetAnatomySequence", 0x00686230, "Implant Target Anatomy Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kInformationFromManufacturerSequence
      //(0068,6260)
      = const DED("InformationFromManufacturerSequence", 0x00686260,
          "Information From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const DED kNotificationFromManufacturerSequence
      //(0068,6265)
      = const DED("NotificationFromManufacturerSequence", 0x00686265,
          "Notification From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const DED kInformationIssueDateTime
      //(0068,6270)
      = const DED("InformationIssueDateTime", 0x00686270, "Information Issue DateTime", VR.kDT,
          VM.k1, false);
  static const DED kInformationSummary
      //(0068,6280)
      =
      const DED("InformationSummary", 0x00686280, "Information Summary", VR.kST, VM.k1, false);
  static const DED kImplantRegulatoryDisapprovalCodeSequence
      //(0068,62A0)
      = const DED("ImplantRegulatoryDisapprovalCodeSequence", 0x006862A0,
          "Implant Regulatory Disapproval Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kOverallTemplateSpatialTolerance
      //(0068,62A5)
      = const DED("OverallTemplateSpatialTolerance", 0x006862A5,
          "Overall Template Spatial Tolerance", VR.kFD, VM.k1, false);
  static const DED kHPGLDocumentSequence
      //(0068,62C0)
      = const DED(
          "HPGLDocumentSequence", 0x006862C0, "HPGL Document Sequence", VR.kSQ, VM.k1, false);
  static const DED kHPGLDocumentID
      //(0068,62D0)
      = const DED("HPGLDocumentID", 0x006862D0, "HPGL Document ID", VR.kUS, VM.k1, false);
  static const DED kHPGLDocumentLabel
      //(0068,62D5)
      = const DED("HPGLDocumentLabel", 0x006862D5, "HPGL Document Label", VR.kLO, VM.k1, false);
  static const DED kViewOrientationCodeSequence
      //(0068,62E0)
      = const DED("ViewOrientationCodeSequence", 0x006862E0, "View Orientation Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kViewOrientationModifier
      //(0068,62F0)
      = const DED(
          "ViewOrientationModifier", 0x006862F0, "View Orientation Modifier", VR.kFD, VM.k9, false);
  static const DED kHPGLDocumentScaling
      //(0068,62F2)
      = const DED(
          "HPGLDocumentScaling", 0x006862F2, "HPGL Document Scaling", VR.kFD, VM.k1, false);
  static const DED kHPGLDocument
      //(0068,6300)
      = const DED("HPGLDocument", 0x00686300, "HPGL Document", VR.kOB, VM.k1, false);
  static const DED kHPGLContourPenNumber
      //(0068,6310)
      = const DED(
          "HPGLContourPenNumber", 0x00686310, "HPGL Contour Pen Number", VR.kUS, VM.k1, false);
  static const DED kHPGLPenSequence
      //(0068,6320)
      = const DED("HPGLPenSequence", 0x00686320, "HPGL Pen Sequence", VR.kSQ, VM.k1, false);
  static const DED kHPGLPenNumber
      //(0068,6330)
      = const DED("HPGLPenNumber", 0x00686330, "HPGL Pen Number", VR.kUS, VM.k1, false);
  static const DED kHPGLPenLabel
      //(0068,6340)
      = const DED("HPGLPenLabel", 0x00686340, "HPGL Pen Label", VR.kLO, VM.k1, false);
  static const DED kHPGLPenDescription
      //(0068,6345)
      =
      const DED("HPGLPenDescription", 0x00686345, "HPGL Pen Description", VR.kST, VM.k1, false);
  static const DED kRecommendedRotationPoint
      //(0068,6346)
      = const DED("RecommendedRotationPoint", 0x00686346, "Recommended Rotation Point", VR.kFD,
          VM.k2, false);
  static const DED kBoundingRectangle
      //(0068,6347)
      = const DED("BoundingRectangle", 0x00686347, "Bounding Rectangle", VR.kFD, VM.k4, false);
  static const DED kImplantTemplate3DModelSurfaceNumber
      //(0068,6350)
      = const DED("ImplantTemplate3DModelSurfaceNumber", 0x00686350,
          "Implant Template 3D Model Surface Number", VR.kUS, VM.k1_n, false);
  static const DED kSurfaceModelDescriptionSequence
      //(0068,6360)
      = const DED("SurfaceModelDescriptionSequence", 0x00686360,
          "Surface Model Description Sequence", VR.kSQ, VM.k1, false);
  static const DED kSurfaceModelLabel
      //(0068,6380)
      = const DED("SurfaceModelLabel", 0x00686380, "Surface Model Label", VR.kLO, VM.k1, false);
  static const DED kSurfaceModelScalingFactor
      //(0068,6390)
      = const DED("SurfaceModelScalingFactor", 0x00686390, "Surface Model Scaling Factor",
          VR.kFD, VM.k1, false);
  static const DED kMaterialsCodeSequence
      //(0068,63A0)
      = const DED(
          "MaterialsCodeSequence", 0x006863A0, "Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kCoatingMaterialsCodeSequence
      //(0068,63A4)
      = const DED("CoatingMaterialsCodeSequence", 0x006863A4, "Coating Materials Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImplantTypeCodeSequence
      //(0068,63A8)
      = const DED("ImplantTypeCodeSequence", 0x006863A8, "Implant Type Code Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kFixationMethodCodeSequence
      //(0068,63AC)
      = const DED("FixationMethodCodeSequence", 0x006863AC, "Fixation Method Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMatingFeatureSetsSequence
      //(0068,63B0)
      = const DED("MatingFeatureSetsSequence", 0x006863B0, "Mating Feature Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMatingFeatureSetID
      //(0068,63C0)
      = const DED(
          "MatingFeatureSetID", 0x006863C0, "Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const DED kMatingFeatureSetLabel
      //(0068,63D0)
      = const DED(
          "MatingFeatureSetLabel", 0x006863D0, "Mating Feature Set Label", VR.kLO, VM.k1, false);
  static const DED kMatingFeatureSequence
      //(0068,63E0)
      = const DED(
          "MatingFeatureSequence", 0x006863E0, "Mating Feature Sequence", VR.kSQ, VM.k1, false);
  static const DED kMatingFeatureID
      //(0068,63F0)
      = const DED("MatingFeatureID", 0x006863F0, "Mating Feature ID", VR.kUS, VM.k1, false);
  static const DED kMatingFeatureDegreeOfFreedomSequence
      //(0068,6400)
      = const DED("MatingFeatureDegreeOfFreedomSequence", 0x00686400,
          "Mating Feature Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const DED kDegreeOfFreedomID
      //(0068,6410)
      =
      const DED("DegreeOfFreedomID", 0x00686410, "Degree of Freedom ID", VR.kUS, VM.k1, false);
  static const DED kDegreeOfFreedomType
      //(0068,6420)
      = const DED(
          "DegreeOfFreedomType", 0x00686420, "Degree of Freedom Type", VR.kCS, VM.k1, false);
  static const DED kTwoDMatingFeatureCoordinatesSequence
      //(0068,6430)
      = const DED("TwoDMatingFeatureCoordinatesSequence", 0x00686430,
          "2D Mating Feature Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedHPGLDocumentID
      //(0068,6440)
      = const DED("ReferencedHPGLDocumentID", 0x00686440, "Referenced HPGL Document ID", VR.kUS,
          VM.k1, false);
  static const DED kTwoDMatingPoint
      //(0068,6450)
      = const DED("TwoDMatingPoint", 0x00686450, "2D Mating Point", VR.kFD, VM.k2, false);
  static const DED kTwoDMatingAxes
      //(0068,6460)
      = const DED("TwoDMatingAxes", 0x00686460, "2D Mating Axes", VR.kFD, VM.k4, false);
  static const DED kTwoDDegreeOfFreedomSequence
      //(0068,6470)
      = const DED("TwoDDegreeOfFreedomSequence", 0x00686470, "2D Degree of Freedom Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kThreeDDegreeOfFreedomAxis
      //(0068,6490)
      = const DED("ThreeDDegreeOfFreedomAxis", 0x00686490, "3D Degree of Freedom Axis", VR.kFD,
          VM.k3, false);
  static const DED kRangeOfFreedom
      //(0068,64A0)
      = const DED("RangeOfFreedom", 0x006864A0, "Range of Freedom", VR.kFD, VM.k2, false);
  static const DED kThreeDMatingPoint
      //(0068,64C0)
      = const DED("ThreeDMatingPoint", 0x006864C0, "3D Mating Point", VR.kFD, VM.k3, false);
  static const DED kThreeDMatingAxes
      //(0068,64D0)
      = const DED("ThreeDMatingAxes", 0x006864D0, "3D Mating Axes", VR.kFD, VM.k9, false);
  static const DED kTwoDDegreeOfFreedomAxis
      //(0068,64F0)
      = const DED(
          "TwoDDegreeOfFreedomAxis", 0x006864F0, "2D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const DED kPlanningLandmarkPointSequence
      //(0068,6500)
      = const DED("PlanningLandmarkPointSequence", 0x00686500,
          "Planning Landmark Point Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlanningLandmarkLineSequence
      //(0068,6510)
      = const DED("PlanningLandmarkLineSequence", 0x00686510, "Planning Landmark Line Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPlanningLandmarkPlaneSequence
      //(0068,6520)
      = const DED("PlanningLandmarkPlaneSequence", 0x00686520,
          "Planning Landmark Plane Sequence", VR.kSQ, VM.k1, false);
  static const DED kPlanningLandmarkID
      //(0068,6530)
      =
      const DED("PlanningLandmarkID", 0x00686530, "Planning Landmark ID", VR.kUS, VM.k1, false);
  static const DED kPlanningLandmarkDescription
      //(0068,6540)
      = const DED("PlanningLandmarkDescription", 0x00686540, "Planning Landmark Description",
          VR.kLO, VM.k1, false);
  static const DED kPlanningLandmarkIdentificationCodeSequence
      //(0068,6545)
      = const DED("PlanningLandmarkIdentificationCodeSequence", 0x00686545,
          "Planning Landmark Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kTwoDPointCoordinatesSequence
      //(0068,6550)
      = const DED("TwoDPointCoordinatesSequence", 0x00686550, "2D Point Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTwoDPointCoordinates
      //(0068,6560)
      = const DED(
          "TwoDPointCoordinates", 0x00686560, "2D Point Coordinates", VR.kFD, VM.k2, false);
  static const DED kThreeDPointCoordinates
      //(0068,6590)
      = const DED(
          "ThreeDPointCoordinates", 0x00686590, "3D Point Coordinates", VR.kFD, VM.k3, false);
  static const DED kTwoDLineCoordinatesSequence
      //(0068,65A0)
      = const DED("TwoDLineCoordinatesSequence", 0x006865A0, "2D Line Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTwoDLineCoordinates
      //(0068,65B0)
      =
      const DED("TwoDLineCoordinates", 0x006865B0, "2D Line Coordinates", VR.kFD, VM.k4, false);
  static const DED kThreeDLineCoordinates
      //(0068,65D0)
      = const DED(
          "ThreeDLineCoordinates", 0x006865D0, "3D Line Coordinates", VR.kFD, VM.k6, false);
  static const DED kTwoDPlaneCoordinatesSequence
      //(0068,65E0)
      = const DED("TwoDPlaneCoordinatesSequence", 0x006865E0, "2D Plane Coordinates Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTwoDPlaneIntersection
      //(0068,65F0)
      = const DED(
          "TwoDPlaneIntersection", 0x006865F0, "2D Plane Intersection", VR.kFD, VM.k4, false);
  static const DED kThreeDPlaneOrigin
      //(0068,6610)
      = const DED("ThreeDPlaneOrigin", 0x00686610, "3D Plane Origin", VR.kFD, VM.k3, false);
  static const DED kThreeDPlaneNormal
      //(0068,6620)
      = const DED("ThreeDPlaneNormal", 0x00686620, "3D Plane Normal", VR.kFD, VM.k3, false);
  static const DED kGraphicAnnotationSequence
      //(0070,0001)
      = const DED("GraphicAnnotationSequence", 0x00700001, "Graphic Annotation Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kGraphicLayer
      //(0070,0002)
      = const DED("GraphicLayer", 0x00700002, "Graphic Layer", VR.kCS, VM.k1, false);
  static const DED kBoundingBoxAnnotationUnits
      //(0070,0003)
      = const DED("BoundingBoxAnnotationUnits", 0x00700003, "Bounding Box Annotation Units",
          VR.kCS, VM.k1, false);
  static const DED kAnchorPointAnnotationUnits
      //(0070,0004)
      = const DED("AnchorPointAnnotationUnits", 0x00700004, "Anchor Point Annotation Units",
          VR.kCS, VM.k1, false);
  static const DED kGraphicAnnotationUnits
      //(0070,0005)
      = const DED(
          "GraphicAnnotationUnits", 0x00700005, "Graphic Annotation Units", VR.kCS, VM.k1, false);
  static const DED kUnformattedTextValue
      //(0070,0006)
      = const DED(
          "UnformattedTextValue", 0x00700006, "Unformatted Text Value", VR.kST, VM.k1, false);
  static const DED kTextObjectSequence
      //(0070,0008)
      =
      const DED("TextObjectSequence", 0x00700008, "Text Object Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicObjectSequence
      //(0070,0009)
      = const DED(
          "GraphicObjectSequence", 0x00700009, "Graphic Object Sequence", VR.kSQ, VM.k1, false);
  static const DED kBoundingBoxTopLeftHandCorner
      //(0070,0010)
      = const DED("BoundingBoxTopLeftHandCorner", 0x00700010,
          "Bounding Box Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const DED kBoundingBoxBottomRightHandCorner
      //(0070,0011)
      = const DED("BoundingBoxBottomRightHandCorner", 0x00700011,
          "Bounding Box Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const DED kBoundingBoxTextHorizontalJustification
      //(0070,0012)
      = const DED("BoundingBoxTextHorizontalJustification", 0x00700012,
          "Bounding Box Text Horizontal Justification", VR.kCS, VM.k1, false);
  static const DED kAnchorPoint
      //(0070,0014)
      = const DED("AnchorPoint", 0x00700014, "Anchor Point", VR.kFL, VM.k2, false);
  static const DED kAnchorPointVisibility
      //(0070,0015)
      = const DED(
          "AnchorPointVisibility", 0x00700015, "Anchor Point Visibility", VR.kCS, VM.k1, false);
  static const DED kGraphicDimensions
      //(0070,0020)
      = const DED("GraphicDimensions", 0x00700020, "Graphic Dimensions", VR.kUS, VM.k1, false);
  static const DED kNumberOfGraphicPoints
      //(0070,0021)
      = const DED(
          "NumberOfGraphicPoints", 0x00700021, "Number of Graphic Points", VR.kUS, VM.k1, false);
  static const DED kGraphicData
      //(0070,0022)
      = const DED("GraphicData", 0x00700022, "Graphic Data", VR.kFL, VM.k2_n, false);
  static const DED kGraphicType
      //(0070,0023)
      = const DED("GraphicType", 0x00700023, "Graphic Type", VR.kCS, VM.k1, false);
  static const DED kGraphicFilled
      //(0070,0024)
      = const DED("GraphicFilled", 0x00700024, "Graphic Filled", VR.kCS, VM.k1, false);
  static const DED kImageRotationRetired
      //(0070,0040)
      = const DED(
          "ImageRotationRetired", 0x00700040, "Image Rotation (Retired)", VR.kIS, VM.k1, true);
  static const DED kImageHorizontalFlip
      //(0070,0041)
      = const DED(
          "ImageHorizontalFlip", 0x00700041, "Image Horizontal Flip", VR.kCS, VM.k1, false);
  static const DED kImageRotation
      //(0070,0042)
      = const DED("ImageRotation", 0x00700042, "Image Rotation", VR.kUS, VM.k1, false);
  static const DED kDisplayedAreaTopLeftHandCornerTrial
      //(0070,0050)
      = const DED("DisplayedAreaTopLeftHandCornerTrial", 0x00700050,
          "Displayed Area Top Left Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const DED kDisplayedAreaBottomRightHandCornerTrial
      //(0070,0051)
      = const DED("DisplayedAreaBottomRightHandCornerTrial", 0x00700051,
          "Displayed Area Bottom Right Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const DED kDisplayedAreaTopLeftHandCorner
      //(0070,0052)
      = const DED("DisplayedAreaTopLeftHandCorner", 0x00700052,
          "Displayed Area Top Left Hand Corner", VR.kSL, VM.k2, false);
  static const DED kDisplayedAreaBottomRightHandCorner
      //(0070,0053)
      = const DED("DisplayedAreaBottomRightHandCorner", 0x00700053,
          "Displayed Area Bottom Right Hand Corner", VR.kSL, VM.k2, false);
  static const DED kDisplayedAreaSelectionSequence
      //(0070,005A)
      = const DED("DisplayedAreaSelectionSequence", 0x0070005A,
          "Displayed Area Selection Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicLayerSequence
      //(0070,0060)
      = const DED(
          "GraphicLayerSequence", 0x00700060, "Graphic Layer Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicLayerOrder
      //(0070,0062)
      = const DED("GraphicLayerOrder", 0x00700062, "Graphic Layer Order", VR.kIS, VM.k1, false);
  static const DED kGraphicLayerRecommendedDisplayGrayscaleValue
      //(0070,0066)
      = const DED("GraphicLayerRecommendedDisplayGrayscaleValue", 0x00700066,
          "Graphic Layer Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const DED kGraphicLayerRecommendedDisplayRGBValue
      //(0070,0067)
      = const DED("GraphicLayerRecommendedDisplayRGBValue", 0x00700067,
          "Graphic Layer Recommended Display RGB Value", VR.kUS, VM.k3, true);
  static const DED kGraphicLayerDescription
      //(0070,0068)
      = const DED(
          "GraphicLayerDescription", 0x00700068, "Graphic Layer Description", VR.kLO, VM.k1, false);
  static const DED kContentLabel
      //(0070,0080)
      = const DED("ContentLabel", 0x00700080, "Content Label", VR.kCS, VM.k1, false);
  static const DED kContentDescription
      //(0070,0081)
      =
      const DED("ContentDescription", 0x00700081, "Content Description", VR.kLO, VM.k1, false);
  static const DED kPresentationCreationDate
      //(0070,0082)
      = const DED("PresentationCreationDate", 0x00700082, "Presentation Creation Date", VR.kDA,
          VM.k1, false);
  static const DED kPresentationCreationTime
      //(0070,0083)
      = const DED("PresentationCreationTime", 0x00700083, "Presentation Creation Time", VR.kTM,
          VM.k1, false);
  static const DED kContentCreatorName
      //(0070,0084)
      = const DED(
          "ContentCreatorName", 0x00700084, "Content Creator's Name", VR.kPN, VM.k1, false);
  static const DED kContentCreatorIdentificationCodeSequence
      //(0070,0086)
      = const DED("ContentCreatorIdentificationCodeSequence", 0x00700086,
          "Content Creator's Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kAlternateContentDescriptionSequence
      //(0070,0087)
      = const DED("AlternateContentDescriptionSequence", 0x00700087,
          "Alternate Content Description Sequence", VR.kSQ, VM.k1, false);
  static const DED kPresentationSizeMode
      //(0070,0100)
      = const DED(
          "PresentationSizeMode", 0x00700100, "Presentation Size Mode", VR.kCS, VM.k1, false);
  static const DED kPresentationPixelSpacing
      //(0070,0101)
      = const DED("PresentationPixelSpacing", 0x00700101, "Presentation Pixel Spacing", VR.kDS,
          VM.k2, false);
  static const DED kPresentationPixelAspectRatio
      //(0070,0102)
      = const DED("PresentationPixelAspectRatio", 0x00700102, "Presentation Pixel Aspect Ratio",
          VR.kIS, VM.k2, false);
  static const DED kPresentationPixelMagnificationRatio
      //(0070,0103)
      = const DED("PresentationPixelMagnificationRatio", 0x00700103,
          "Presentation Pixel Magnification Ratio", VR.kFL, VM.k1, false);
  static const DED kGraphicGroupLabel
      //(0070,0207)
      = const DED("GraphicGroupLabel", 0x00700207, "Graphic Group Label", VR.kLO, VM.k1, false);
  static const DED kGraphicGroupDescription
      //(0070,0208)
      = const DED(
          "GraphicGroupDescription", 0x00700208, "Graphic Group Description", VR.kST, VM.k1, false);
  static const DED kCompoundGraphicSequence
      //(0070,0209)
      = const DED(
          "CompoundGraphicSequence", 0x00700209, "Compound Graphic Sequence", VR.kSQ, VM.k1, false);
  static const DED kCompoundGraphicInstanceID
      //(0070,0226)
      = const DED("CompoundGraphicInstanceID", 0x00700226, "Compound Graphic Instance ID",
          VR.kUL, VM.k1, false);
  static const DED kFontName
      //(0070,0227)
      = const DED("FontName", 0x00700227, "Font Name", VR.kLO, VM.k1, false);
  static const DED kFontNameType
      //(0070,0228)
      = const DED("FontNameType", 0x00700228, "Font Name Type", VR.kCS, VM.k1, false);
  static const DED kCSSFontName
      //(0070,0229)
      = const DED("CSSFontName", 0x00700229, "CSS Font Name", VR.kLO, VM.k1, false);
  static const DED kRotationAngle
      //(0070,0230)
      = const DED("RotationAngle", 0x00700230, "Rotation Angle", VR.kFD, VM.k1, false);
  static const DED kTextStyleSequence
      //(0070,0231)
      = const DED("TextStyleSequence", 0x00700231, "Text Style Sequence", VR.kSQ, VM.k1, false);
  static const DED kLineStyleSequence
      //(0070,0232)
      = const DED("LineStyleSequence", 0x00700232, "Line Style Sequence", VR.kSQ, VM.k1, false);
  static const DED kFillStyleSequence
      //(0070,0233)
      = const DED("FillStyleSequence", 0x00700233, "Fill Style Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicGroupSequence
      //(0070,0234)
      = const DED(
          "GraphicGroupSequence", 0x00700234, "Graphic Group Sequence", VR.kSQ, VM.k1, false);
  static const DED kTextColorCIELabValue
      //(0070,0241)
      = const DED(
          "TextColorCIELabValue", 0x00700241, "Text Color CIELab Value", VR.kUS, VM.k3, false);
  static const DED kHorizontalAlignment
      //(0070,0242)
      = const DED(
          "HorizontalAlignment", 0x00700242, "Horizontal Alignment", VR.kCS, VM.k1, false);
  static const DED kVerticalAlignment
      //(0070,0243)
      = const DED("VerticalAlignment", 0x00700243, "Vertical Alignment", VR.kCS, VM.k1, false);
  static const DED kShadowStyle
      //(0070,0244)
      = const DED("ShadowStyle", 0x00700244, "Shadow Style", VR.kCS, VM.k1, false);
  static const DED kShadowOffsetX
      //(0070,0245)
      = const DED("ShadowOffsetX", 0x00700245, "Shadow Offset X", VR.kFL, VM.k1, false);
  static const DED kShadowOffsetY
      //(0070,0246)
      = const DED("ShadowOffsetY", 0x00700246, "Shadow Offset Y", VR.kFL, VM.k1, false);
  static const DED kShadowColorCIELabValue
      //(0070,0247)
      = const DED(
          "ShadowColorCIELabValue", 0x00700247, "Shadow Color CIELab Value", VR.kUS, VM.k3, false);
  static const DED kUnderlined
      //(0070,0248)
      = const DED("Underlined", 0x00700248, "Underlined", VR.kCS, VM.k1, false);
  static const DED kBold
      //(0070,0249)
      = const DED("Bold", 0x00700249, "Bold", VR.kCS, VM.k1, false);
  static const DED kItalic
      //(0070,0250)
      = const DED("Italic", 0x00700250, "Italic", VR.kCS, VM.k1, false);
  static const DED kPatternOnColorCIELabValue
      //(0070,0251)
      = const DED("PatternOnColorCIELabValue", 0x00700251, "Pattern On Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const DED kPatternOffColorCIELabValue
      //(0070,0252)
      = const DED("PatternOffColorCIELabValue", 0x00700252, "Pattern Off Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const DED kLineThickness
      //(0070,0253)
      = const DED("LineThickness", 0x00700253, "Line Thickness", VR.kFL, VM.k1, false);
  static const DED kLineDashingStyle
      //(0070,0254)
      = const DED("LineDashingStyle", 0x00700254, "Line Dashing Style", VR.kCS, VM.k1, false);
  static const DED kLinePattern
      //(0070,0255)
      = const DED("LinePattern", 0x00700255, "Line Pattern", VR.kUL, VM.k1, false);
  static const DED kFillPattern
      //(0070,0256)
      = const DED("FillPattern", 0x00700256, "Fill Pattern", VR.kOB, VM.k1, false);
  static const DED kFillMode
      //(0070,0257)
      = const DED("FillMode", 0x00700257, "Fill Mode", VR.kCS, VM.k1, false);
  static const DED kShadowOpacity
      //(0070,0258)
      = const DED("ShadowOpacity", 0x00700258, "Shadow Opacity", VR.kFL, VM.k1, false);
  static const DED kGapLength
      //(0070,0261)
      = const DED("GapLength", 0x00700261, "Gap Length", VR.kFL, VM.k1, false);
  static const DED kDiameterOfVisibility
      //(0070,0262)
      = const DED(
          "DiameterOfVisibility", 0x00700262, "Diameter of Visibility", VR.kFL, VM.k1, false);
  static const DED kRotationPoint
      //(0070,0273)
      = const DED("RotationPoint", 0x00700273, "Rotation Point", VR.kFL, VM.k2, false);
  static const DED kTickAlignment
      //(0070,0274)
      = const DED("TickAlignment", 0x00700274, "Tick Alignment", VR.kCS, VM.k1, false);
  static const DED kShowTickLabel
      //(0070,0278)
      = const DED("ShowTickLabel", 0x00700278, "Show Tick Label", VR.kCS, VM.k1, false);
  static const DED kTickLabelAlignment
      //(0070,0279)
      =
      const DED("TickLabelAlignment", 0x00700279, "Tick Label Alignment", VR.kCS, VM.k1, false);
  static const DED kCompoundGraphicUnits
      //(0070,0282)
      = const DED(
          "CompoundGraphicUnits", 0x00700282, "Compound Graphic Units", VR.kCS, VM.k1, false);
  static const DED kPatternOnOpacity
      //(0070,0284)
      = const DED("PatternOnOpacity", 0x00700284, "Pattern On Opacity", VR.kFL, VM.k1, false);
  static const DED kPatternOffOpacity
      //(0070,0285)
      = const DED("PatternOffOpacity", 0x00700285, "Pattern Off Opacity", VR.kFL, VM.k1, false);
  static const DED kMajorTicksSequence
      //(0070,0287)
      =
      const DED("MajorTicksSequence", 0x00700287, "Major Ticks Sequence", VR.kSQ, VM.k1, false);
  static const DED kTickPosition
      //(0070,0288)
      = const DED("TickPosition", 0x00700288, "Tick Position", VR.kFL, VM.k1, false);
  static const DED kTickLabel
      //(0070,0289)
      = const DED("TickLabel", 0x00700289, "Tick Label", VR.kSH, VM.k1, false);
  static const DED kCompoundGraphicType
      //(0070,0294)
      = const DED(
          "CompoundGraphicType", 0x00700294, "Compound Graphic Type", VR.kCS, VM.k1, false);
  static const DED kGraphicGroupID
      //(0070,0295)
      = const DED("GraphicGroupID", 0x00700295, "Graphic Group ID", VR.kUL, VM.k1, false);
  static const DED kShapeType
      //(0070,0306)
      = const DED("ShapeType", 0x00700306, "Shape Type", VR.kCS, VM.k1, false);
  static const DED kRegistrationSequence
      //(0070,0308)
      = const DED(
          "RegistrationSequence", 0x00700308, "Registration Sequence", VR.kSQ, VM.k1, false);
  static const DED kMatrixRegistrationSequence
      //(0070,0309)
      = const DED("MatrixRegistrationSequence", 0x00700309, "Matrix Registration Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kMatrixSequence
      //(0070,030A)
      = const DED("MatrixSequence", 0x0070030A, "Matrix Sequence", VR.kSQ, VM.k1, false);
  static const DED kFrameOfReferenceTransformationMatrixType
      //(0070,030C)
      = const DED("FrameOfReferenceTransformationMatrixType", 0x0070030C,
          "Frame of Reference Transformation Matrix Type", VR.kCS, VM.k1, false);
  static const DED kRegistrationTypeCodeSequence
      //(0070,030D)
      = const DED("RegistrationTypeCodeSequence", 0x0070030D, "Registration Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kFiducialDescription
      //(0070,030F)
      = const DED(
          "FiducialDescription", 0x0070030F, "Fiducial Description", VR.kST, VM.k1, false);
  static const DED kFiducialIdentifier
      //(0070,0310)
      =
      const DED("FiducialIdentifier", 0x00700310, "Fiducial Identifier", VR.kSH, VM.k1, false);
  static const DED kFiducialIdentifierCodeSequence
      //(0070,0311)
      = const DED("FiducialIdentifierCodeSequence", 0x00700311,
          "Fiducial Identifier Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kContourUncertaintyRadius
      //(0070,0312)
      = const DED("ContourUncertaintyRadius", 0x00700312, "Contour Uncertainty Radius", VR.kFD,
          VM.k1, false);
  static const DED kUsedFiducialsSequence
      //(0070,0314)
      = const DED(
          "UsedFiducialsSequence", 0x00700314, "Used Fiducials Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicCoordinatesDataSequence
      //(0070,0318)
      = const DED("GraphicCoordinatesDataSequence", 0x00700318,
          "Graphic Coordinates Data Sequence", VR.kSQ, VM.k1, false);
  static const DED kFiducialUID
      //(0070,031A)
      = const DED("FiducialUID", 0x0070031A, "Fiducial UID", VR.kUI, VM.k1, false);
  static const DED kFiducialSetSequence
      //(0070,031C)
      = const DED(
          "FiducialSetSequence", 0x0070031C, "Fiducial Set Sequence", VR.kSQ, VM.k1, false);
  static const DED kFiducialSequence
      //(0070,031E)
      = const DED("FiducialSequence", 0x0070031E, "Fiducial Sequence", VR.kSQ, VM.k1, false);
  static const DED kGraphicLayerRecommendedDisplayCIELabValue
      //(0070,0401)
      = const DED("GraphicLayerRecommendedDisplayCIELabValue", 0x00700401,
          "Graphic Layer Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const DED kBlendingSequence
      //(0070,0402)
      = const DED("BlendingSequence", 0x00700402, "Blending Sequence", VR.kSQ, VM.k1, false);
  static const DED kRelativeOpacity
      //(0070,0403)
      = const DED("RelativeOpacity", 0x00700403, "Relative Opacity", VR.kFL, VM.k1, false);
  static const DED kReferencedSpatialRegistrationSequence
      //(0070,0404)
      = const DED("ReferencedSpatialRegistrationSequence", 0x00700404,
          "Referenced Spatial Registration Sequence", VR.kSQ, VM.k1, false);
  static const DED kBlendingPosition
      //(0070,0405)
      = const DED("BlendingPosition", 0x00700405, "Blending Position", VR.kCS, VM.k1, false);
  static const DED kHangingProtocolName
      //(0072,0002)
      = const DED(
          "HangingProtocolName", 0x00720002, "Hanging Protocol Name", VR.kSH, VM.k1, false);
  static const DED kHangingProtocolDescription
      //(0072,0004)
      = const DED("HangingProtocolDescription", 0x00720004, "Hanging Protocol Description",
          VR.kLO, VM.k1, false);
  static const DED kHangingProtocolLevel
      //(0072,0006)
      = const DED(
          "HangingProtocolLevel", 0x00720006, "Hanging Protocol Level", VR.kCS, VM.k1, false);
  static const DED kHangingProtocolCreator
      //(0072,0008)
      = const DED(
          "HangingProtocolCreator", 0x00720008, "Hanging Protocol Creator", VR.kLO, VM.k1, false);
  static const DED kHangingProtocolCreationDateTime
      //(0072,000A)
      = const DED("HangingProtocolCreationDateTime", 0x0072000A,
          "Hanging Protocol Creation DateTime", VR.kDT, VM.k1, false);
  static const DED kHangingProtocolDefinitionSequence
      //(0072,000C)
      = const DED("HangingProtocolDefinitionSequence", 0x0072000C,
          "Hanging Protocol Definition Sequence", VR.kSQ, VM.k1, false);
  static const DED kHangingProtocolUserIdentificationCodeSequence
      //(0072,000E)
      = const DED("HangingProtocolUserIdentificationCodeSequence", 0x0072000E,
          "Hanging Protocol User Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kHangingProtocolUserGroupName
      //(0072,0010)
      = const DED("HangingProtocolUserGroupName", 0x00720010,
          "Hanging Protocol User Group Name", VR.kLO, VM.k1, false);
  static const DED kSourceHangingProtocolSequence
      //(0072,0012)
      = const DED("SourceHangingProtocolSequence", 0x00720012,
          "Source Hanging Protocol Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumberOfPriorsReferenced
      //(0072,0014)
      = const DED("NumberOfPriorsReferenced", 0x00720014, "Number of Priors Referenced", VR.kUS,
          VM.k1, false);
  static const DED kImageSetsSequence
      //(0072,0020)
      = const DED("ImageSetsSequence", 0x00720020, "Image Sets Sequence", VR.kSQ, VM.k1, false);
  static const DED kImageSetSelectorSequence
      //(0072,0022)
      = const DED("ImageSetSelectorSequence", 0x00720022, "Image Set Selector Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kImageSetSelectorUsageFlag
      //(0072,0024)
      = const DED("ImageSetSelectorUsageFlag", 0x00720024, "Image Set Selector Usage Flag",
          VR.kCS, VM.k1, false);
  static const DED kSelectorAttribute
      //(0072,0026)
      = const DED("SelectorAttribute", 0x00720026, "Selector Attribute", VR.kAT, VM.k1, false);
  static const DED kSelectorValueNumber
      //(0072,0028)
      = const DED(
          "SelectorValueNumber", 0x00720028, "Selector Value Number", VR.kUS, VM.k1, false);
  static const DED kTimeBasedImageSetsSequence
      //(0072,0030)
      = const DED("TimeBasedImageSetsSequence", 0x00720030, "Time Based Image Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImageSetNumber
      //(0072,0032)
      = const DED("ImageSetNumber", 0x00720032, "Image Set Number", VR.kUS, VM.k1, false);
  static const DED kImageSetSelectorCategory
      //(0072,0034)
      = const DED("ImageSetSelectorCategory", 0x00720034, "Image Set Selector Category", VR.kCS,
          VM.k1, false);
  static const DED kRelativeTime
      //(0072,0038)
      = const DED("RelativeTime", 0x00720038, "Relative Time", VR.kUS, VM.k2, false);
  static const DED kRelativeTimeUnits
      //(0072,003A)
      = const DED("RelativeTimeUnits", 0x0072003A, "Relative Time Units", VR.kCS, VM.k1, false);
  static const DED kAbstractPriorValue
      //(0072,003C)
      =
      const DED("AbstractPriorValue", 0x0072003C, "Abstract Prior Value", VR.kSS, VM.k2, false);
  static const DED kAbstractPriorCodeSequence
      //(0072,003E)
      = const DED("AbstractPriorCodeSequence", 0x0072003E, "Abstract Prior Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImageSetLabel
      //(0072,0040)
      = const DED("ImageSetLabel", 0x00720040, "Image Set Label", VR.kLO, VM.k1, false);
  static const DED kSelectorAttributeVR
      //(0072,0050)
      = const DED(
          "SelectorAttributeVR", 0x00720050, "Selector Attribute VR", VR.kCS, VM.k1, false);
  static const DED kSelectorSequencePointer
      //(0072,0052)
      = const DED("SelectorSequencePointer", 0x00720052, "Selector Sequence Pointer", VR.kAT,
          VM.k1_n, false);
  static const DED kSelectorSequencePointerPrivateCreator
      //(0072,0054)
      = const DED("SelectorSequencePointerPrivateCreator", 0x00720054,
          "Selector Sequence Pointer Private Creator", VR.kLO, VM.k1_n, false);
  static const DED kSelectorAttributePrivateCreator
      //(0072,0056)
      = const DED("SelectorAttributePrivateCreator", 0x00720056,
          "Selector Attribute Private Creator", VR.kLO, VM.k1, false);
  static const DED kSelectorATValue
      //(0072,0060)
      = const DED("SelectorATValue", 0x00720060, "Selector AT Value", VR.kAT, VM.k1_n, false);
  static const DED kSelectorCSValue
      //(0072,0062)
      = const DED("SelectorCSValue", 0x00720062, "Selector CS Value", VR.kCS, VM.k1_n, false);
  static const DED kSelectorISValue
      //(0072,0064)
      = const DED("SelectorISValue", 0x00720064, "Selector IS Value", VR.kIS, VM.k1_n, false);
  static const DED kSelectorLOValue
      //(0072,0066)
      = const DED("SelectorLOValue", 0x00720066, "Selector LO Value", VR.kLO, VM.k1_n, false);
  static const DED kSelectorLTValue
      //(0072,0068)
      = const DED("SelectorLTValue", 0x00720068, "Selector LT Value", VR.kLT, VM.k1, false);
  static const DED kSelectorPNValue
      //(0072,006A)
      = const DED("SelectorPNValue", 0x0072006A, "Selector PN Value", VR.kPN, VM.k1_n, false);
  static const DED kSelectorSHValue
      //(0072,006C)
      = const DED("SelectorSHValue", 0x0072006C, "Selector SH Value", VR.kSH, VM.k1_n, false);
  static const DED kSelectorSTValue
      //(0072,006E)
      = const DED("SelectorSTValue", 0x0072006E, "Selector ST Value", VR.kST, VM.k1, false);
  static const DED kSelectorUTValue
      //(0072,0070)
      = const DED("SelectorUTValue", 0x00720070, "Selector UT Value", VR.kUT, VM.k1, false);
  static const DED kSelectorDSValue
      //(0072,0072)
      = const DED("SelectorDSValue", 0x00720072, "Selector DS Value", VR.kDS, VM.k1_n, false);
  static const DED kSelectorFDValue
      //(0072,0074)
      = const DED("SelectorFDValue", 0x00720074, "Selector FD Value", VR.kFD, VM.k1_n, false);
  static const DED kSelectorFLValue
      //(0072,0076)
      = const DED("SelectorFLValue", 0x00720076, "Selector FL Value", VR.kFL, VM.k1_n, false);
  static const DED kSelectorULValue
      //(0072,0078)
      = const DED("SelectorULValue", 0x00720078, "Selector UL Value", VR.kUL, VM.k1_n, false);
  static const DED kSelectorUSValue
      //(0072,007A)
      = const DED("SelectorUSValue", 0x0072007A, "Selector US Value", VR.kUS, VM.k1_n, false);
  static const DED kSelectorSLValue
      //(0072,007C)
      = const DED("SelectorSLValue", 0x0072007C, "Selector SL Value", VR.kSL, VM.k1_n, false);
  static const DED kSelectorSSValue
      //(0072,007E)
      = const DED("SelectorSSValue", 0x0072007E, "Selector SS Value", VR.kSS, VM.k1_n, false);
  static const DED kSelectorCodeSequenceValue
      //(0072,0080)
      = const DED("SelectorCodeSequenceValue", 0x00720080, "Selector Code Sequence Value",
          VR.kSQ, VM.k1, false);
  static const DED kNumberOfScreens
      //(0072,0100)
      = const DED("NumberOfScreens", 0x00720100, "Number of Screens", VR.kUS, VM.k1, false);
  static const DED kNominalScreenDefinitionSequence
      //(0072,0102)
      = const DED("NominalScreenDefinitionSequence", 0x00720102,
          "Nominal Screen Definition Sequence", VR.kSQ, VM.k1, false);
  static const DED kNumberOfVerticalPixels
      //(0072,0104)
      = const DED(
          "NumberOfVerticalPixels", 0x00720104, "Number of Vertical Pixels", VR.kUS, VM.k1, false);
  static const DED kNumberOfHorizontalPixels
      //(0072,0106)
      = const DED("NumberOfHorizontalPixels", 0x00720106, "Number of Horizontal Pixels", VR.kUS,
          VM.k1, false);
  static const DED kDisplayEnvironmentSpatialPosition
      //(0072,0108)
      = const DED("DisplayEnvironmentSpatialPosition", 0x00720108,
          "Display Environment Spatial Position", VR.kFD, VM.k4, false);
  static const DED kScreenMinimumGrayscaleBitDepth
      //(0072,010A)
      = const DED("ScreenMinimumGrayscaleBitDepth", 0x0072010A,
          "Screen Minimum Grayscale Bit Depth", VR.kUS, VM.k1, false);
  static const DED kScreenMinimumColorBitDepth
      //(0072,010C)
      = const DED("ScreenMinimumColorBitDepth", 0x0072010C, "Screen Minimum Color Bit Depth",
          VR.kUS, VM.k1, false);
  static const DED kApplicationMaximumRepaintTime
      //(0072,010E)
      = const DED("ApplicationMaximumRepaintTime", 0x0072010E,
          "Application Maximum Repaint Time", VR.kUS, VM.k1, false);
  static const DED kDisplaySetsSequence
      //(0072,0200)
      = const DED(
          "DisplaySetsSequence", 0x00720200, "Display Sets Sequence", VR.kSQ, VM.k1, false);
  static const DED kDisplaySetNumber
      //(0072,0202)
      = const DED("DisplaySetNumber", 0x00720202, "Display Set Number", VR.kUS, VM.k1, false);
  static const DED kDisplaySetLabel
      //(0072,0203)
      = const DED("DisplaySetLabel", 0x00720203, "Display Set Label", VR.kLO, VM.k1, false);
  static const DED kDisplaySetPresentationGroup
      //(0072,0204)
      = const DED("DisplaySetPresentationGroup", 0x00720204, "Display Set Presentation Group",
          VR.kUS, VM.k1, false);
  static const DED kDisplaySetPresentationGroupDescription
      //(0072,0206)
      = const DED("DisplaySetPresentationGroupDescription", 0x00720206,
          "Display Set Presentation Group Description", VR.kLO, VM.k1, false);
  static const DED kPartialDataDisplayHandling
      //(0072,0208)
      = const DED("PartialDataDisplayHandling", 0x00720208, "Partial Data Display Handling",
          VR.kCS, VM.k1, false);
  static const DED kSynchronizedScrollingSequence
      //(0072,0210)
      = const DED("SynchronizedScrollingSequence", 0x00720210,
          "Synchronized Scrolling Sequence", VR.kSQ, VM.k1, false);
  static const DED kDisplaySetScrollingGroup
      //(0072,0212)
      = const DED("DisplaySetScrollingGroup", 0x00720212, "Display Set Scrolling Group", VR.kUS,
          VM.k2_n, false);
  static const DED kNavigationIndicatorSequence
      //(0072,0214)
      = const DED("NavigationIndicatorSequence", 0x00720214, "Navigation Indicator Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kNavigationDisplaySet
      //(0072,0216)
      = const DED(
          "NavigationDisplaySet", 0x00720216, "Navigation Display Set", VR.kUS, VM.k1, false);
  static const DED kReferenceDisplaySets
      //(0072,0218)
      = const DED(
          "ReferenceDisplaySets", 0x00720218, "Reference Display Sets", VR.kUS, VM.k1_n, false);
  static const DED kImageBoxesSequence
      //(0072,0300)
      =
      const DED("ImageBoxesSequence", 0x00720300, "Image Boxes Sequence", VR.kSQ, VM.k1, false);
  static const DED kImageBoxNumber
      //(0072,0302)
      = const DED("ImageBoxNumber", 0x00720302, "Image Box Number", VR.kUS, VM.k1, false);
  static const DED kImageBoxLayoutType
      //(0072,0304)
      = const DED(
          "ImageBoxLayoutType", 0x00720304, "Image Box Layout Type", VR.kCS, VM.k1, false);
  static const DED kImageBoxTileHorizontalDimension
      //(0072,0306)
      = const DED("ImageBoxTileHorizontalDimension", 0x00720306,
          "Image Box Tile Horizontal Dimension", VR.kUS, VM.k1, false);
  static const DED kImageBoxTileVerticalDimension
      //(0072,0308)
      = const DED("ImageBoxTileVerticalDimension", 0x00720308,
          "Image Box Tile Vertical Dimension", VR.kUS, VM.k1, false);
  static const DED kImageBoxScrollDirection
      //(0072,0310)
      = const DED("ImageBoxScrollDirection", 0x00720310, "Image Box Scroll Direction", VR.kCS,
          VM.k1, false);
  static const DED kImageBoxSmallScrollType
      //(0072,0312)
      = const DED("ImageBoxSmallScrollType", 0x00720312, "Image Box Small Scroll Type", VR.kCS,
          VM.k1, false);
  static const DED kImageBoxSmallScrollAmount
      //(0072,0314)
      = const DED("ImageBoxSmallScrollAmount", 0x00720314, "Image Box Small Scroll Amount",
          VR.kUS, VM.k1, false);
  static const DED kImageBoxLargeScrollType
      //(0072,0316)
      = const DED("ImageBoxLargeScrollType", 0x00720316, "Image Box Large Scroll Type", VR.kCS,
          VM.k1, false);
  static const DED kImageBoxLargeScrollAmount
      //(0072,0318)
      = const DED("ImageBoxLargeScrollAmount", 0x00720318, "Image Box Large Scroll Amount",
          VR.kUS, VM.k1, false);
  static const DED kImageBoxOverlapPriority
      //(0072,0320)
      = const DED("ImageBoxOverlapPriority", 0x00720320, "Image Box Overlap Priority", VR.kUS,
          VM.k1, false);
  static const DED kCineRelativeToRealTime
      //(0072,0330)
      = const DED(
          "CineRelativeToRealTime", 0x00720330, "Cine Relative to Real-Time", VR.kFD, VM.k1, false);
  static const DED kFilterOperationsSequence
      //(0072,0400)
      = const DED("FilterOperationsSequence", 0x00720400, "Filter Operations Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kFilterByCategory
      //(0072,0402)
      = const DED("FilterByCategory", 0x00720402, "Filter-by Category", VR.kCS, VM.k1, false);
  static const DED kFilterByAttributePresence
      //(0072,0404)
      = const DED("FilterByAttributePresence", 0x00720404, "Filter-by Attribute Presence",
          VR.kCS, VM.k1, false);
  static const DED kFilterByOperator
      //(0072,0406)
      = const DED("FilterByOperator", 0x00720406, "Filter-by Operator", VR.kCS, VM.k1, false);
  static const DED kStructuredDisplayBackgroundCIELabValue
      //(0072,0420)
      = const DED("StructuredDisplayBackgroundCIELabValue", 0x00720420,
          "Structured Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const DED kEmptyImageBoxCIELabValue
      //(0072,0421)
      = const DED("EmptyImageBoxCIELabValue", 0x00720421, "Empty Image Box CIELab Value",
          VR.kUS, VM.k3, false);
  static const DED kStructuredDisplayImageBoxSequence
      //(0072,0422)
      = const DED("StructuredDisplayImageBoxSequence", 0x00720422,
          "Structured Display Image Box Sequence", VR.kSQ, VM.k1, false);
  static const DED kStructuredDisplayTextBoxSequence
      //(0072,0424)
      = const DED("StructuredDisplayTextBoxSequence", 0x00720424,
          "Structured Display Text Box Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedFirstFrameSequence
      //(0072,0427)
      = const DED("ReferencedFirstFrameSequence", 0x00720427, "Referenced First Frame Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kImageBoxSynchronizationSequence
      //(0072,0430)
      = const DED("ImageBoxSynchronizationSequence", 0x00720430,
          "Image Box Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const DED kSynchronizedImageBoxList
      //(0072,0432)
      = const DED("SynchronizedImageBoxList", 0x00720432, "Synchronized Image Box List", VR.kUS,
          VM.k2_n, false);
  static const DED kTypeOfSynchronization
      //(0072,0434)
      = const DED(
          "TypeOfSynchronization", 0x00720434, "Type of Synchronization", VR.kCS, VM.k1, false);
  static const DED kBlendingOperationType
      //(0072,0500)
      = const DED(
          "BlendingOperationType", 0x00720500, "Blending Operation Type", VR.kCS, VM.k1, false);
  static const DED kReformattingOperationType
      //(0072,0510)
      = const DED("ReformattingOperationType", 0x00720510, "Reformatting Operation Type",
          VR.kCS, VM.k1, false);
  static const DED kReformattingThickness
      //(0072,0512)
      = const DED(
          "ReformattingThickness", 0x00720512, "Reformatting Thickness", VR.kFD, VM.k1, false);
  static const DED kReformattingInterval
      //(0072,0514)
      = const DED(
          "ReformattingInterval", 0x00720514, "Reformatting Interval", VR.kFD, VM.k1, false);
  static const DED kReformattingOperationInitialViewDirection
      //(0072,0516)
      = const DED("ReformattingOperationInitialViewDirection", 0x00720516,
          "Reformatting Operation Initial View Direction", VR.kCS, VM.k1, false);
  static const DED kThreeDRenderingType
      //(0072,0520)
      =
      const DED("ThreeDRenderingType", 0x00720520, "3D Rendering Type", VR.kCS, VM.k1_n, false);
  static const DED kSortingOperationsSequence
      //(0072,0600)
      = const DED("SortingOperationsSequence", 0x00720600, "Sorting Operations Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSortByCategory
      //(0072,0602)
      = const DED("SortByCategory", 0x00720602, "Sort-by Category", VR.kCS, VM.k1, false);
  static const DED kSortingDirection
      //(0072,0604)
      = const DED("SortingDirection", 0x00720604, "Sorting Direction", VR.kCS, VM.k1, false);
  static const DED kDisplaySetPatientOrientation
      //(0072,0700)
      = const DED("DisplaySetPatientOrientation", 0x00720700, "Display Set Patient Orientation",
          VR.kCS, VM.k2, false);
  static const DED kVOIType
      //(0072,0702)
      = const DED("VOIType", 0x00720702, "VOI Type", VR.kCS, VM.k1, false);
  static const DED kPseudoColorType
      //(0072,0704)
      = const DED("PseudoColorType", 0x00720704, "Pseudo-Color Type", VR.kCS, VM.k1, false);
  static const DED kPseudoColorPaletteInstanceReferenceSequence
      //(0072,0705)
      = const DED("PseudoColorPaletteInstanceReferenceSequence", 0x00720705,
          "Pseudo-Color Palette Instance Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kShowGrayscaleInverted
      //(0072,0706)
      = const DED(
          "ShowGrayscaleInverted", 0x00720706, "Show Grayscale Inverted", VR.kCS, VM.k1, false);
  static const DED kShowImageTrueSizeFlag
      //(0072,0710)
      = const DED(
          "ShowImageTrueSizeFlag", 0x00720710, "Show Image True Size Flag", VR.kCS, VM.k1, false);
  static const DED kShowGraphicAnnotationFlag
      //(0072,0712)
      = const DED("ShowGraphicAnnotationFlag", 0x00720712, "Show Graphic Annotation Flag",
          VR.kCS, VM.k1, false);
  static const DED kShowPatientDemographicsFlag
      //(0072,0714)
      = const DED("ShowPatientDemographicsFlag", 0x00720714, "Show Patient Demographics Flag",
          VR.kCS, VM.k1, false);
  static const DED kShowAcquisitionTechniquesFlag
      //(0072,0716)
      = const DED("ShowAcquisitionTechniquesFlag", 0x00720716,
          "Show Acquisition Techniques Flag", VR.kCS, VM.k1, false);
  static const DED kDisplaySetHorizontalJustification
      //(0072,0717)
      = const DED("DisplaySetHorizontalJustification", 0x00720717,
          "Display Set Horizontal Justification", VR.kCS, VM.k1, false);
  static const DED kDisplaySetVerticalJustification
      //(0072,0718)
      = const DED("DisplaySetVerticalJustification", 0x00720718,
          "Display Set Vertical Justification", VR.kCS, VM.k1, false);
  static const DED kContinuationStartMeterset
      //(0074,0120)
      = const DED("ContinuationStartMeterset", 0x00740120, "Continuation Start Meterset",
          VR.kFD, VM.k1, false);
  static const DED kContinuationEndMeterset
      //(0074,0121)
      = const DED(
          "ContinuationEndMeterset", 0x00740121, "Continuation End Meterset", VR.kFD, VM.k1, false);
  static const DED kProcedureStepState
      //(0074,1000)
      =
      const DED("ProcedureStepState", 0x00741000, "Procedure Step State", VR.kCS, VM.k1, false);
  static const DED kProcedureStepProgressInformationSequence
      //(0074,1002)
      = const DED("ProcedureStepProgressInformationSequence", 0x00741002,
          "Procedure Step Progress Information Sequence", VR.kSQ, VM.k1, false);
  static const DED kProcedureStepProgress
      //(0074,1004)
      = const DED(
          "ProcedureStepProgress", 0x00741004, "Procedure Step Progress", VR.kDS, VM.k1, false);
  static const DED kProcedureStepProgressDescription
      //(0074,1006)
      = const DED("ProcedureStepProgressDescription", 0x00741006,
          "Procedure Step Progress Description", VR.kST, VM.k1, false);
  static const DED kProcedureStepCommunicationsURISequence
      //(0074,1008)
      = const DED("ProcedureStepCommunicationsURISequence", 0x00741008,
          "Procedure Step Communications URI Sequence", VR.kSQ, VM.k1, false);
  static const DED kContactURI
      //(0074,100a)
      = const DED("ContactURI", 0x0074100a, "Contact URI", VR.kST, VM.k1, false);
  static const DED kContactDisplayName
      //(0074,100c)
      =
      const DED("ContactDisplayName", 0x0074100c, "Contact Display Name", VR.kLO, VM.k1, false);
  static const DED kProcedureStepDiscontinuationReasonCodeSequence
      //(0074,100e)
      = const DED("ProcedureStepDiscontinuationReasonCodeSequence", 0x0074100e,
          "Procedure Step Discontinuation Reason Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kBeamTaskSequence
      //(0074,1020)
      = const DED("BeamTaskSequence", 0x00741020, "Beam Task Sequence", VR.kSQ, VM.k1, false);
  static const DED kBeamTaskType
      //(0074,1022)
      = const DED("BeamTaskType", 0x00741022, "Beam Task Type", VR.kCS, VM.k1, false);
  static const DED kBeamOrderIndexTrial
      //(0074,1024)
      = const DED(
          "BeamOrderIndexTrial", 0x00741024, "Beam Order Index (Trial)", VR.kIS, VM.k1, true);
  static const DED kAutosequenceFlag
      //(0074,1025)
      = const DED("AutosequenceFlag", 0x00741025, "Autosequence Flag", VR.kCS, VM.k1, false);
  static const DED kTableTopVerticalAdjustedPosition
      //(0074,1026)
      = const DED("TableTopVerticalAdjustedPosition", 0x00741026,
          "Table Top Vertical Adjusted Position", VR.kFD, VM.k1, false);
  static const DED kTableTopLongitudinalAdjustedPosition
      //(0074,1027)
      = const DED("TableTopLongitudinalAdjustedPosition", 0x00741027,
          "Table Top Longitudinal Adjusted Position", VR.kFD, VM.k1, false);
  static const DED kTableTopLateralAdjustedPosition
      //(0074,1028)
      = const DED("TableTopLateralAdjustedPosition", 0x00741028,
          "Table Top Lateral Adjusted Position", VR.kFD, VM.k1, false);
  static const DED kPatientSupportAdjustedAngle
      //(0074,102A)
      = const DED("PatientSupportAdjustedAngle", 0x0074102A, "Patient Support Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const DED kTableTopEccentricAdjustedAngle
      //(0074,102B)
      = const DED("TableTopEccentricAdjustedAngle", 0x0074102B,
          "Table Top Eccentric Adjusted Angle", VR.kFD, VM.k1, false);
  static const DED kTableTopPitchAdjustedAngle
      //(0074,102C)
      = const DED("TableTopPitchAdjustedAngle", 0x0074102C, "Table Top Pitch Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const DED kTableTopRollAdjustedAngle
      //(0074,102D)
      = const DED("TableTopRollAdjustedAngle", 0x0074102D, "Table Top Roll Adjusted Angle",
          VR.kFD, VM.k1, false);
  static const DED kDeliveryVerificationImageSequence
      //(0074,1030)
      = const DED("DeliveryVerificationImageSequence", 0x00741030,
          "Delivery Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kVerificationImageTiming
      //(0074,1032)
      = const DED(
          "VerificationImageTiming", 0x00741032, "Verification Image Timing", VR.kCS, VM.k1, false);
  static const DED kDoubleExposureFlag
      //(0074,1034)
      =
      const DED("DoubleExposureFlag", 0x00741034, "Double Exposure Flag", VR.kCS, VM.k1, false);
  static const DED kDoubleExposureOrdering
      //(0074,1036)
      = const DED(
          "DoubleExposureOrdering", 0x00741036, "Double Exposure Ordering", VR.kCS, VM.k1, false);
  static const DED kDoubleExposureMetersetTrial
      //(0074,1038)
      = const DED("DoubleExposureMetersetTrial", 0x00741038, "Double Exposure Meterset (Trial)",
          VR.kDS, VM.k1, true);
  static const DED kDoubleExposureFieldDeltaTrial
      //(0074,103A)
      = const DED("DoubleExposureFieldDeltaTrial", 0x0074103A,
          "Double Exposure Field Delta (Trial)", VR.kDS, VM.k4, true);
  static const DED kRelatedReferenceRTImageSequence
      //(0074,1040)
      = const DED("RelatedReferenceRTImageSequence", 0x00741040,
          "Related Reference RT Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kGeneralMachineVerificationSequence
      //(0074,1042)
      = const DED("GeneralMachineVerificationSequence", 0x00741042,
          "General Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const DED kConventionalMachineVerificationSequence
      //(0074,1044)
      = const DED("ConventionalMachineVerificationSequence", 0x00741044,
          "Conventional Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonMachineVerificationSequence
      //(0074,1046)
      = const DED("IonMachineVerificationSequence", 0x00741046,
          "Ion Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const DED kFailedAttributesSequence
      //(0074,1048)
      = const DED("FailedAttributesSequence", 0x00741048, "Failed Attributes Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kOverriddenAttributesSequence
      //(0074,104A)
      = const DED("OverriddenAttributesSequence", 0x0074104A, "Overridden Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kConventionalControlPointVerificationSequence
      //(0074,104C)
      = const DED("ConventionalControlPointVerificationSequence", 0x0074104C,
          "Conventional Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonControlPointVerificationSequence
      //(0074,104E)
      = const DED("IonControlPointVerificationSequence", 0x0074104E,
          "Ion Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const DED kAttributeOccurrenceSequence
      //(0074,1050)
      = const DED("AttributeOccurrenceSequence", 0x00741050, "Attribute Occurrence Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAttributeOccurrencePointer
      //(0074,1052)
      = const DED("AttributeOccurrencePointer", 0x00741052, "Attribute Occurrence Pointer",
          VR.kAT, VM.k1, false);
  static const DED kAttributeItemSelector
      //(0074,1054)
      = const DED(
          "AttributeItemSelector", 0x00741054, "Attribute Item Selector", VR.kUL, VM.k1, false);
  static const DED kAttributeOccurrencePrivateCreator
      //(0074,1056)
      = const DED("AttributeOccurrencePrivateCreator", 0x00741056,
          "Attribute Occurrence Private Creator", VR.kLO, VM.k1, false);
  static const DED kSelectorSequencePointerItems
      //(0074,1057)
      = const DED("SelectorSequencePointerItems", 0x00741057, "Selector Sequence Pointer Items",
          VR.kIS, VM.k1_n, false);
  static const DED kScheduledProcedureStepPriority
      //(0074,1200)
      = const DED("ScheduledProcedureStepPriority", 0x00741200,
          "Scheduled Procedure Step Priority", VR.kCS, VM.k1, false);
  static const DED kWorklistLabel
      //(0074,1202)
      = const DED("WorklistLabel", 0x00741202, "Worklist Label", VR.kLO, VM.k1, false);
  static const DED kProcedureStepLabel
      //(0074,1204)
      =
      const DED("ProcedureStepLabel", 0x00741204, "Procedure Step Label", VR.kLO, VM.k1, false);
  static const DED kScheduledProcessingParametersSequence
      //(0074,1210)
      = const DED("ScheduledProcessingParametersSequence", 0x00741210,
          "Scheduled Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerformedProcessingParametersSequence
      //(0074,1212)
      = const DED("PerformedProcessingParametersSequence", 0x00741212,
          "Performed Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const DED kUnifiedProcedureStepPerformedProcedureSequence
      //(0074,1216)
      = const DED("UnifiedProcedureStepPerformedProcedureSequence", 0x00741216,
          "Unified Procedure Step Performed Procedure Sequence", VR.kSQ, VM.k1, false);
  static const DED kRelatedProcedureStepSequence
      //(0074,1220)
      = const DED("RelatedProcedureStepSequence", 0x00741220, "Related Procedure Step Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kProcedureStepRelationshipType
      //(0074,1222)
      = const DED("ProcedureStepRelationshipType", 0x00741222,
          "Procedure Step Relationship Type", VR.kLO, VM.k1, true);
  static const DED kReplacedProcedureStepSequence
      //(0074,1224)
      = const DED("ReplacedProcedureStepSequence", 0x00741224,
          "Replaced Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const DED kDeletionLock
      //(0074,1230)
      = const DED("DeletionLock", 0x00741230, "Deletion Lock", VR.kLO, VM.k1, false);
  static const DED kReceivingAE
      //(0074,1234)
      = const DED("ReceivingAE", 0x00741234, "Receiving AE", VR.kAE, VM.k1, false);
  static const DED kRequestingAE
      //(0074,1236)
      = const DED("RequestingAE", 0x00741236, "Requesting AE", VR.kAE, VM.k1, false);
  static const DED kReasonForCancellation
      //(0074,1238)
      = const DED(
          "ReasonForCancellation", 0x00741238, "Reason for Cancellation", VR.kLT, VM.k1, false);
  static const DED kSCPStatus
      //(0074,1242)
      = const DED("SCPStatus", 0x00741242, "SCP Status", VR.kCS, VM.k1, false);
  static const DED kSubscriptionListStatus
      //(0074,1244)
      = const DED(
          "SubscriptionListStatus", 0x00741244, "Subscription List Status", VR.kCS, VM.k1, false);
  static const DED kUnifiedProcedureStepListStatus
      //(0074,1246)
      = const DED("UnifiedProcedureStepListStatus", 0x00741246,
          "Unified Procedure StepList Status", VR.kCS, VM.k1, false);
  static const DED kBeamOrderIndex
      //(0074,1324)
      = const DED("BeamOrderIndex", 0x00741324, "Beam Order Index", VR.kUL, VM.k1, false);
  static const DED kDoubleExposureMeterset
      //(0074,1338)
      = const DED(
          "DoubleExposureMeterset", 0x00741338, "Double Exposure Meterset", VR.kFD, VM.k1, false);
  static const DED kDoubleExposureFieldDelta
      //(0074,133A)
      = const DED("DoubleExposureFieldDelta", 0x0074133A, "Double Exposure Field Delta", VR.kFD,
          VM.k4, false);
  static const DED kImplantAssemblyTemplateName
      //(0076,0001)
      = const DED("ImplantAssemblyTemplateName", 0x00760001, "Implant Assembly Template Name",
          VR.kLO, VM.k1, false);
  static const DED kImplantAssemblyTemplateIssuer
      //(0076,0003)
      = const DED("ImplantAssemblyTemplateIssuer", 0x00760003,
          "Implant Assembly Template Issuer", VR.kLO, VM.k1, false);
  static const DED kImplantAssemblyTemplateVersion
      //(0076,0006)
      = const DED("ImplantAssemblyTemplateVersion", 0x00760006,
          "Implant Assembly Template Version", VR.kLO, VM.k1, false);
  static const DED kReplacedImplantAssemblyTemplateSequence
      //(0076,0008)
      = const DED("ReplacedImplantAssemblyTemplateSequence", 0x00760008,
          "Replaced Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantAssemblyTemplateType
      //(0076,000A)
      = const DED("ImplantAssemblyTemplateType", 0x0076000A, "Implant Assembly Template Type",
          VR.kCS, VM.k1, false);
  static const DED kOriginalImplantAssemblyTemplateSequence
      //(0076,000C)
      = const DED("OriginalImplantAssemblyTemplateSequence", 0x0076000C,
          "Original Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kDerivationImplantAssemblyTemplateSequence
      //(0076,000E)
      = const DED("DerivationImplantAssemblyTemplateSequence", 0x0076000E,
          "Derivation Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantAssemblyTemplateTargetAnatomySequence
      //(0076,0010)
      = const DED("ImplantAssemblyTemplateTargetAnatomySequence", 0x00760010,
          "Implant Assembly Template Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const DED kProcedureTypeCodeSequence
      //(0076,0020)
      = const DED("ProcedureTypeCodeSequence", 0x00760020, "Procedure Type Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSurgicalTechnique
      //(0076,0030)
      = const DED("SurgicalTechnique", 0x00760030, "Surgical Technique", VR.kLO, VM.k1, false);
  static const DED kComponentTypesSequence
      //(0076,0032)
      = const DED(
          "ComponentTypesSequence", 0x00760032, "Component Types Sequence", VR.kSQ, VM.k1, false);
  static const DED kComponentTypeCodeSequence
      //(0076,0034)
      = const DED("ComponentTypeCodeSequence", 0x00760034, "Component Type Code Sequence",
          VR.kCS, VM.k1, false);
  static const DED kExclusiveComponentType
      //(0076,0036)
      = const DED(
          "ExclusiveComponentType", 0x00760036, "Exclusive Component Type", VR.kCS, VM.k1, false);
  static const DED kMandatoryComponentType
      //(0076,0038)
      = const DED(
          "MandatoryComponentType", 0x00760038, "Mandatory Component Type", VR.kCS, VM.k1, false);
  static const DED kComponentSequence
      //(0076,0040)
      = const DED("ComponentSequence", 0x00760040, "Component Sequence", VR.kSQ, VM.k1, false);
  static const DED kComponentID
      //(0076,0055)
      = const DED("ComponentID", 0x00760055, "Component ID", VR.kUS, VM.k1, false);
  static const DED kComponentAssemblySequence
      //(0076,0060)
      = const DED("ComponentAssemblySequence", 0x00760060, "Component Assembly Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kComponent1ReferencedID
      //(0076,0070)
      = const DED(
          "Component1ReferencedID", 0x00760070, "Component 1 Referenced ID", VR.kUS, VM.k1, false);
  static const DED kComponent1ReferencedMatingFeatureSetID
      //(0076,0080)
      = const DED("Component1ReferencedMatingFeatureSetID", 0x00760080,
          "Component 1 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const DED kComponent1ReferencedMatingFeatureID
      //(0076,0090)
      = const DED("Component1ReferencedMatingFeatureID", 0x00760090,
          "Component 1 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const DED kComponent2ReferencedID
      //(0076,00A0)
      = const DED(
          "Component2ReferencedID", 0x007600A0, "Component 2 Referenced ID", VR.kUS, VM.k1, false);
  static const DED kComponent2ReferencedMatingFeatureSetID
      //(0076,00B0)
      = const DED("Component2ReferencedMatingFeatureSetID", 0x007600B0,
          "Component 2 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const DED kComponent2ReferencedMatingFeatureID
      //(0076,00C0)
      = const DED("Component2ReferencedMatingFeatureID", 0x007600C0,
          "Component 2 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const DED kImplantTemplateGroupName
      //(0078,0001)
      = const DED("ImplantTemplateGroupName", 0x00780001, "Implant Template Group Name", VR.kLO,
          VM.k1, false);
  static const DED kImplantTemplateGroupDescription
      //(0078,0010)
      = const DED("ImplantTemplateGroupDescription", 0x00780010,
          "Implant Template Group Description", VR.kST, VM.k1, false);
  static const DED kImplantTemplateGroupIssuer
      //(0078,0020)
      = const DED("ImplantTemplateGroupIssuer", 0x00780020, "Implant Template Group Issuer",
          VR.kLO, VM.k1, false);
  static const DED kImplantTemplateGroupVersion
      //(0078,0024)
      = const DED("ImplantTemplateGroupVersion", 0x00780024, "Implant Template Group Version",
          VR.kLO, VM.k1, false);
  static const DED kReplacedImplantTemplateGroupSequence
      //(0078,0026)
      = const DED("ReplacedImplantTemplateGroupSequence", 0x00780026,
          "Replaced Implant Template Group Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantTemplateGroupTargetAnatomySequence
      //(0078,0028)
      = const DED("ImplantTemplateGroupTargetAnatomySequence", 0x00780028,
          "Implant Template Group Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantTemplateGroupMembersSequence
      //(0078,002A)
      = const DED("ImplantTemplateGroupMembersSequence", 0x0078002A,
          "Implant Template Group Members Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantTemplateGroupMemberID
      //(0078,002E)
      = const DED("ImplantTemplateGroupMemberID", 0x0078002E,
          "Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const DED kThreeDImplantTemplateGroupMemberMatchingPoint
      //(0078,0050)
      = const DED("ThreeDImplantTemplateGroupMemberMatchingPoint", 0x00780050,
          "3D Implant Template Group Member Matching Point", VR.kFD, VM.k3, false);
  static const DED kThreeDImplantTemplateGroupMemberMatchingAxes
      //(0078,0060)
      = const DED("ThreeDImplantTemplateGroupMemberMatchingAxes", 0x00780060,
          "3D Implant Template Group Member Matching Axes", VR.kFD, VM.k9, false);
  static const DED kImplantTemplateGroupMemberMatching2DCoordinatesSequence
      //(0078,0070)
      = const DED("ImplantTemplateGroupMemberMatching2DCoordinatesSequence", 0x00780070,
          "Implant Template Group Member Matching 2D Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const DED kTwoDImplantTemplateGroupMemberMatchingPoint
      //(0078,0090)
      = const DED("TwoDImplantTemplateGroupMemberMatchingPoint", 0x00780090,
          "2D Implant Template Group Member Matching Point", VR.kFD, VM.k2, false);
  static const DED kTwoDImplantTemplateGroupMemberMatchingAxes
      //(0078,00A0)
      = const DED("TwoDImplantTemplateGroupMemberMatchingAxes", 0x007800A0,
          "2D Implant Template Group Member Matching Axes", VR.kFD, VM.k4, false);
  static const DED kImplantTemplateGroupVariationDimensionSequence
      //(0078,00B0)
      = const DED("ImplantTemplateGroupVariationDimensionSequence", 0x007800B0,
          "Implant Template Group Variation Dimension Sequence", VR.kSQ, VM.k1, false);
  static const DED kImplantTemplateGroupVariationDimensionName
      //(0078,00B2)
      = const DED("ImplantTemplateGroupVariationDimensionName", 0x007800B2,
          "Implant Template Group Variation Dimension Name", VR.kLO, VM.k1, false);
  static const DED kImplantTemplateGroupVariationDimensionRankSequence
      //(0078,00B4)
      = const DED("ImplantTemplateGroupVariationDimensionRankSequence", 0x007800B4,
          "Implant Template Group Variation Dimension Rank Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedImplantTemplateGroupMemberID
      //(0078,00B6)
      = const DED("ReferencedImplantTemplateGroupMemberID", 0x007800B6,
          "Referenced Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const DED kImplantTemplateGroupVariationDimensionRank
      //(0078,00B8)
      = const DED("ImplantTemplateGroupVariationDimensionRank", 0x007800B8,
          "Implant Template Group Variation Dimension Rank", VR.kUS, VM.k1, false);
  static const DED kSurfaceScanAcquisitionTypeCodeSequence
      //(0080,0001)
      = const DED("SurfaceScanAcquisitionTypeCodeSequence", 0x00800001,
          "Surface Scan Acquisition Type Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kSurfaceScanModeCodeSequence
      //(0080,0002)
      = const DED("SurfaceScanModeCodeSequence", 0x00800002, "Surface Scan Mode Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRegistrationMethodCodeSequence
      //(0080,0003)
      = const DED("RegistrationMethodCodeSequence", 0x00800003,
          "Registration Method Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kShotDurationTime
      //(0080,0004)
      = const DED("ShotDurationTime", 0x00800004, "Shot Duration Time", VR.kFD, VM.k1, false);
  static const DED kShotOffsetTime
      //(0080,0005)
      = const DED("ShotOffsetTime", 0x00800005, "Shot Offset Time", VR.kFD, VM.k1, false);
  static const DED kSurfacePointPresentationValueData
      //(0080,0006)
      = const DED("SurfacePointPresentationValueData", 0x00800006,
          "Surface Point Presentation Value Data", VR.kUS, VM.k1_n, false);
  static const DED kSurfacePointColorCIELabValueData
      //(0080,0007)
      = const DED("SurfacePointColorCIELabValueData", 0x00800007,
          "Surface Point Color CIELab Value Data", VR.kUS, VM.k3_3n, false);
  static const DED kUVMappingSequence
      //(0080,0008)
      = const DED("UVMappingSequence", 0x00800008, "UV Mapping Sequence", VR.kSQ, VM.k1, false);
  static const DED kTextureLabel
      //(0080,0009)
      = const DED("TextureLabel", 0x00800009, "Texture Label", VR.kSH, VM.k1, false);
  static const DED kUValueData
      //(0080,0010)
      = const DED("UValueData", 0x00800010, "U Value Data", VR.kOF, VM.k1_n, false);
  static const DED kVValueData
      //(0080,0011)
      = const DED("VValueData", 0x00800011, "V Value Data", VR.kOF, VM.k1_n, false);
  static const DED kReferencedTextureSequence
      //(0080,0012)
      = const DED("ReferencedTextureSequence", 0x00800012, "Referenced Texture Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedSurfaceDataSequence
      //(0080,0013)
      = const DED("ReferencedSurfaceDataSequence", 0x00800013,
          "Referenced Surface Data Sequence", VR.kSQ, VM.k1, false);
  static const DED kStorageMediaFileSetID
      //(0088,0130)
      = const DED(
          "StorageMediaFileSetID", 0x00880130, "Storage Media File-set ID", VR.kSH, VM.k1, false);
  static const DED kStorageMediaFileSetUID
      //(0088,0140)
      = const DED(
          "StorageMediaFileSetUID", 0x00880140, "Storage Media File-set UID", VR.kUI, VM.k1, false);
  static const DED kIconImageSequence
      //(0088,0200)
      = const DED("IconImageSequence", 0x00880200, "Icon Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kTopicTitle
      //(0088,0904)
      = const DED("TopicTitle", 0x00880904, "Topic Title", VR.kLO, VM.k1, true);
  static const DED kTopicSubject
      //(0088,0906)
      = const DED("TopicSubject", 0x00880906, "Topic Subject", VR.kST, VM.k1, true);
  static const DED kTopicAuthor
      //(0088,0910)
      = const DED("TopicAuthor", 0x00880910, "Topic Author", VR.kLO, VM.k1, true);
  static const DED kTopicKeywords
      //(0088,0912)
      = const DED("TopicKeywords", 0x00880912, "Topic Keywords", VR.kLO, VM.k1_32, true);
  static const DED kSOPInstanceStatus
      //(0100,0410)
      = const DED("SOPInstanceStatus", 0x01000410, "SOP Instance Status", VR.kCS, VM.k1, false);
  static const DED kSOPAuthorizationDateTime
      //(0100,0420)
      = const DED("SOPAuthorizationDateTime", 0x01000420, "SOP Authorization DateTime", VR.kDT,
          VM.k1, false);
  static const DED kSOPAuthorizationComment
      //(0100,0424)
      = const DED(
          "SOPAuthorizationComment", 0x01000424, "SOP Authorization Comment", VR.kLT, VM.k1, false);
  static const DED kAuthorizationEquipmentCertificationNumber
      //(0100,0426)
      = const DED("AuthorizationEquipmentCertificationNumber", 0x01000426,
          "Authorization Equipment Certification Number", VR.kLO, VM.k1, false);
  static const DED kMACIDNumber
      //(0400,0005)
      = const DED("MACIDNumber", 0x04000005, "MAC ID Number", VR.kUS, VM.k1, false);
  static const DED kMACCalculationTransferSyntaxUID
      //(0400,0010)
      = const DED("MACCalculationTransferSyntaxUID", 0x04000010,
          "MAC Calculation Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const DED kMACAlgorithm
      //(0400,0015)
      = const DED("MACAlgorithm", 0x04000015, "MAC Algorithm", VR.kCS, VM.k1, false);
  static const DED kDataElementsSigned
      //(0400,0020)
      = const DED(
          "DataElementsSigned", 0x04000020, "Data Elements Signed", VR.kAT, VM.k1_n, false);
  static const DED kDigitalSignatureUID
      //(0400,0100)
      = const DED(
          "DigitalSignatureUID", 0x04000100, "Digital Signature UID", VR.kUI, VM.k1, false);
  static const DED kDigitalSignatureDateTime
      //(0400,0105)
      = const DED("DigitalSignatureDateTime", 0x04000105, "Digital Signature DateTime", VR.kDT,
          VM.k1, false);
  static const DED kCertificateType
      //(0400,0110)
      = const DED("CertificateType", 0x04000110, "Certificate Type", VR.kCS, VM.k1, false);
  static const DED kCertificateOfSigner
      //(0400,0115)
      = const DED(
          "CertificateOfSigner", 0x04000115, "Certificate of Signer", VR.kOB, VM.k1, false);
  static const DED kSignature
      //(0400,0120)
      = const DED("Signature", 0x04000120, "Signature", VR.kOB, VM.k1, false);
  static const DED kCertifiedTimestampType
      //(0400,0305)
      = const DED(
          "CertifiedTimestampType", 0x04000305, "Certified Timestamp Type", VR.kCS, VM.k1, false);
  static const DED kCertifiedTimestamp
      //(0400,0310)
      =
      const DED("CertifiedTimestamp", 0x04000310, "Certified Timestamp", VR.kOB, VM.k1, false);
  static const DED kDigitalSignaturePurposeCodeSequence
      //(0400,0401)
      = const DED("DigitalSignaturePurposeCodeSequence", 0x04000401,
          "Digital Signature Purpose Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedDigitalSignatureSequence
      //(0400,0402)
      = const DED("ReferencedDigitalSignatureSequence", 0x04000402,
          "Referenced Digital Signature Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSOPInstanceMACSequence
      //(0400,0403)
      = const DED("ReferencedSOPInstanceMACSequence", 0x04000403,
          "Referenced SOP Instance MAC Sequence", VR.kSQ, VM.k1, false);
  static const DED kMAC
      //(0400,0404)
      = const DED("MAC", 0x04000404, "MAC", VR.kOB, VM.k1, false);
  static const DED kEncryptedAttributesSequence
      //(0400,0500)
      = const DED("EncryptedAttributesSequence", 0x04000500, "Encrypted Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kEncryptedContentTransferSyntaxUID
      //(0400,0510)
      = const DED("EncryptedContentTransferSyntaxUID", 0x04000510,
          "Encrypted Content Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const DED kEncryptedContent
      //(0400,0520)
      = const DED("EncryptedContent", 0x04000520, "Encrypted Content", VR.kOB, VM.k1, false);
  static const DED kModifiedAttributesSequence
      //(0400,0550)
      = const DED("ModifiedAttributesSequence", 0x04000550, "Modified Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kOriginalAttributesSequence
      //(0400,0561)
      = const DED("OriginalAttributesSequence", 0x04000561, "Original Attributes Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kAttributeModificationDateTime
      //(0400,0562)
      = const DED("AttributeModificationDateTime", 0x04000562,
          "Attribute Modification DateTime", VR.kDT, VM.k1, false);
  static const DED kModifyingSystem
      //(0400,0563)
      = const DED("ModifyingSystem", 0x04000563, "Modifying System", VR.kLO, VM.k1, false);
  static const DED kSourceOfPreviousValues
      //(0400,0564)
      = const DED(
          "SourceOfPreviousValues", 0x04000564, "Source of Previous Values", VR.kLO, VM.k1, false);
  static const DED kReasonForTheAttributeModification
      //(0400,0565)
      = const DED("ReasonForTheAttributeModification", 0x04000565,
          "Reason for the Attribute Modification", VR.kCS, VM.k1, false);
  static const DED kEscapeTriplet
      //(1000,0000)
      = const DED("EscapeTriplet", 0x10000000, "Escape Triplet", VR.kUS, VM.k3, true);
  static const DED kRunLengthTriplet
      //(1000,0001)
      = const DED("RunLengthTriplet", 0x10000001, "Run Length Triplet", VR.kUS, VM.k3, true);
  static const DED kHuffmanTableSize
      //(1000,0002)
      = const DED("HuffmanTableSize", 0x10000002, "Huffman Table Size", VR.kUS, VM.k1, true);
  static const DED kHuffmanTableTriplet
      //(1000,0003)
      = const DED(
          "HuffmanTableTriplet", 0x10000003, "Huffman Table Triplet", VR.kUS, VM.k3, true);
  static const DED kShiftTableSize
      //(1000,0004)
      = const DED("ShiftTableSize", 0x10000004, "Shift Table Size", VR.kUS, VM.k1, true);
  static const DED kShiftTableTriplet
      //(1000,0005)
      = const DED("ShiftTableTriplet", 0x10000005, "Shift Table Triplet", VR.kUS, VM.k3, true);
  static const DED kZonalMap
      //(1010,0000)
      = const DED("ZonalMap", 0x10100000, "Zonal Map", VR.kUS, VM.k1_n, true);
  static const DED kNumberOfCopies
      //(2000,0010)
      = const DED("NumberOfCopies", 0x20000010, "Number of Copies", VR.kIS, VM.k1, false);
  static const DED kPrinterConfigurationSequence
      //(2000,001E)
      = const DED("PrinterConfigurationSequence", 0x2000001E, "Printer Configuration Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPrintPriority
      //(2000,0020)
      = const DED("PrintPriority", 0x20000020, "Print Priority", VR.kCS, VM.k1, false);
  static const DED kMediumType
      //(2000,0030)
      = const DED("MediumType", 0x20000030, "Medium Type", VR.kCS, VM.k1, false);
  static const DED kFilmDestination
      //(2000,0040)
      = const DED("FilmDestination", 0x20000040, "Film Destination", VR.kCS, VM.k1, false);
  static const DED kFilmSessionLabel
      //(2000,0050)
      = const DED("FilmSessionLabel", 0x20000050, "Film Session Label", VR.kLO, VM.k1, false);
  static const DED kMemoryAllocation
      //(2000,0060)
      = const DED("MemoryAllocation", 0x20000060, "Memory Allocation", VR.kIS, VM.k1, false);
  static const DED kMaximumMemoryAllocation
      //(2000,0061)
      = const DED(
          "MaximumMemoryAllocation", 0x20000061, "Maximum Memory Allocation", VR.kIS, VM.k1, false);
  static const DED kColorImagePrintingFlag
      //(2000,0062)
      = const DED(
          "ColorImagePrintingFlag", 0x20000062, "Color Image Printing Flag", VR.kCS, VM.k1, true);
  static const DED kCollationFlag
      //(2000,0063)
      = const DED("CollationFlag", 0x20000063, "Collation Flag", VR.kCS, VM.k1, true);
  static const DED kAnnotationFlag
      //(2000,0065)
      = const DED("AnnotationFlag", 0x20000065, "Annotation Flag", VR.kCS, VM.k1, true);
  static const DED kImageOverlayFlag
      //(2000,0067)
      = const DED("ImageOverlayFlag", 0x20000067, "Image Overlay Flag", VR.kCS, VM.k1, true);
  static const DED kPresentationLUTFlag
      //(2000,0069)
      = const DED(
          "PresentationLUTFlag", 0x20000069, "Presentation LUT Flag", VR.kCS, VM.k1, true);
  static const DED kImageBoxPresentationLUTFlag
      //(2000,006A)
      = const DED("ImageBoxPresentationLUTFlag", 0x2000006A, "Image Box Presentation LUT Flag",
          VR.kCS, VM.k1, true);
  static const DED kMemoryBitDepth
      //(2000,00A0)
      = const DED("MemoryBitDepth", 0x200000A0, "Memory Bit Depth", VR.kUS, VM.k1, false);
  static const DED kPrintingBitDepth
      //(2000,00A1)
      = const DED("PrintingBitDepth", 0x200000A1, "Printing Bit Depth", VR.kUS, VM.k1, false);
  static const DED kMediaInstalledSequence
      //(2000,00A2)
      = const DED(
          "MediaInstalledSequence", 0x200000A2, "Media Installed Sequence", VR.kSQ, VM.k1, false);
  static const DED kOtherMediaAvailableSequence
      //(2000,00A4)
      = const DED("OtherMediaAvailableSequence", 0x200000A4, "Other Media Available Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSupportedImageDisplayFormatsSequence
      //(2000,00A8)
      = const DED("SupportedImageDisplayFormatsSequence", 0x200000A8,
          "Supported Image Display Formats Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedFilmBoxSequence
      //(2000,0500)
      = const DED("ReferencedFilmBoxSequence", 0x20000500, "Referenced Film Box Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedStoredPrintSequence
      //(2000,0510)
      = const DED("ReferencedStoredPrintSequence", 0x20000510,
          "Referenced Stored Print Sequence", VR.kSQ, VM.k1, true);
  static const DED kImageDisplayFormat
      //(2010,0010)
      =
      const DED("ImageDisplayFormat", 0x20100010, "Image Display Format", VR.kST, VM.k1, false);
  static const DED kAnnotationDisplayFormatID
      //(2010,0030)
      = const DED("AnnotationDisplayFormatID", 0x20100030, "Annotation Display Format ID",
          VR.kCS, VM.k1, false);
  static const DED kFilmOrientation
      //(2010,0040)
      = const DED("FilmOrientation", 0x20100040, "Film Orientation", VR.kCS, VM.k1, false);
  static const DED kFilmSizeID
      //(2010,0050)
      = const DED("FilmSizeID", 0x20100050, "Film Size ID", VR.kCS, VM.k1, false);
  static const DED kPrinterResolutionID
      //(2010,0052)
      = const DED(
          "PrinterResolutionID", 0x20100052, "Printer Resolution ID", VR.kCS, VM.k1, false);
  static const DED kDefaultPrinterResolutionID
      //(2010,0054)
      = const DED("DefaultPrinterResolutionID", 0x20100054, "Default Printer Resolution ID",
          VR.kCS, VM.k1, false);
  static const DED kMagnificationType
      //(2010,0060)
      = const DED("MagnificationType", 0x20100060, "Magnification Type", VR.kCS, VM.k1, false);
  static const DED kSmoothingType
      //(2010,0080)
      = const DED("SmoothingType", 0x20100080, "Smoothing Type", VR.kCS, VM.k1, false);
  static const DED kDefaultMagnificationType
      //(2010,00A6)
      = const DED("DefaultMagnificationType", 0x201000A6, "Default Magnification Type", VR.kCS,
          VM.k1, false);
  static const DED kOtherMagnificationTypesAvailable
      //(2010,00A7)
      = const DED("OtherMagnificationTypesAvailable", 0x201000A7,
          "Other Magnification Types Available", VR.kCS, VM.k1_n, false);
  static const DED kDefaultSmoothingType
      //(2010,00A8)
      = const DED(
          "DefaultSmoothingType", 0x201000A8, "Default Smoothing Type", VR.kCS, VM.k1, false);
  static const DED kOtherSmoothingTypesAvailable
      //(2010,00A9)
      = const DED("OtherSmoothingTypesAvailable", 0x201000A9, "Other Smoothing Types Available",
          VR.kCS, VM.k1_n, false);
  static const DED kBorderDensity
      //(2010,0100)
      = const DED("BorderDensity", 0x20100100, "Border Density", VR.kCS, VM.k1, false);
  static const DED kEmptyImageDensity
      //(2010,0110)
      = const DED("EmptyImageDensity", 0x20100110, "Empty Image Density", VR.kCS, VM.k1, false);
  static const DED kMinDensity
      //(2010,0120)
      = const DED("MinDensity", 0x20100120, "Min Density", VR.kUS, VM.k1, false);
  static const DED kMaxDensity
      //(2010,0130)
      = const DED("MaxDensity", 0x20100130, "Max Density", VR.kUS, VM.k1, false);
  static const DED kTrim
      //(2010,0140)
      = const DED("Trim", 0x20100140, "Trim", VR.kCS, VM.k1, false);
  static const DED kConfigurationInformation
      //(2010,0150)
      = const DED("ConfigurationInformation", 0x20100150, "Configuration Information", VR.kST,
          VM.k1, false);
  static const DED kConfigurationInformationDescription
      //(2010,0152)
      = const DED("ConfigurationInformationDescription", 0x20100152,
          "Configuration Information Description", VR.kLT, VM.k1, false);
  static const DED kMaximumCollatedFilms
      //(2010,0154)
      = const DED(
          "MaximumCollatedFilms", 0x20100154, "Maximum Collated Films", VR.kIS, VM.k1, false);
  static const DED kIllumination
      //(2010,015E)
      = const DED("Illumination", 0x2010015E, "Illumination", VR.kUS, VM.k1, false);
  static const DED kReflectedAmbientLight
      //(2010,0160)
      = const DED(
          "ReflectedAmbientLight", 0x20100160, "Reflected Ambient Light", VR.kUS, VM.k1, false);
  static const DED kPrinterPixelSpacing
      //(2010,0376)
      = const DED(
          "PrinterPixelSpacing", 0x20100376, "Printer Pixel Spacing", VR.kDS, VM.k2, false);
  static const DED kReferencedFilmSessionSequence
      //(2010,0500)
      = const DED("ReferencedFilmSessionSequence", 0x20100500,
          "Referenced Film Session Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedImageBoxSequence
      //(2010,0510)
      = const DED("ReferencedImageBoxSequence", 0x20100510, "Referenced Image Box Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedBasicAnnotationBoxSequence
      //(2010,0520)
      = const DED("ReferencedBasicAnnotationBoxSequence", 0x20100520,
          "Referenced Basic Annotation Box Sequence", VR.kSQ, VM.k1, false);
  static const DED kImageBoxPosition
      //(2020,0010)
      = const DED("ImageBoxPosition", 0x20200010, "Image Box Position", VR.kUS, VM.k1, false);
  static const DED kPolarity
      //(2020,0020)
      = const DED("Polarity", 0x20200020, "Polarity", VR.kCS, VM.k1, false);
  static const DED kRequestedImageSize
      //(2020,0030)
      =
      const DED("RequestedImageSize", 0x20200030, "Requested Image Size", VR.kDS, VM.k1, false);
  static const DED kRequestedDecimateCropBehavior
      //(2020,0040)
      = const DED("RequestedDecimateCropBehavior", 0x20200040,
          "Requested Decimate/Crop Behavior", VR.kCS, VM.k1, false);
  static const DED kRequestedResolutionID
      //(2020,0050)
      = const DED(
          "RequestedResolutionID", 0x20200050, "Requested Resolution ID", VR.kCS, VM.k1, false);
  static const DED kRequestedImageSizeFlag
      //(2020,00A0)
      = const DED(
          "RequestedImageSizeFlag", 0x202000A0, "Requested Image Size Flag", VR.kCS, VM.k1, false);
  static const DED kDecimateCropResult
      //(2020,00A2)
      =
      const DED("DecimateCropResult", 0x202000A2, "Decimate/Crop Result", VR.kCS, VM.k1, false);
  static const DED kBasicGrayscaleImageSequence
      //(2020,0110)
      = const DED("BasicGrayscaleImageSequence", 0x20200110, "Basic Grayscale Image Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kBasicColorImageSequence
      //(2020,0111)
      = const DED("BasicColorImageSequence", 0x20200111, "Basic Color Image Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kReferencedImageOverlayBoxSequence
      //(2020,0130)
      = const DED("ReferencedImageOverlayBoxSequence", 0x20200130,
          "Referenced Image Overlay Box Sequence", VR.kSQ, VM.k1, true);
  static const DED kReferencedVOILUTBoxSequence
      //(2020,0140)
      = const DED("ReferencedVOILUTBoxSequence", 0x20200140, "Referenced VOI LUT Box Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kAnnotationPosition
      //(2030,0010)
      =
      const DED("AnnotationPosition", 0x20300010, "Annotation Position", VR.kUS, VM.k1, false);
  static const DED kTextString
      //(2030,0020)
      = const DED("TextString", 0x20300020, "Text String", VR.kLO, VM.k1, false);
  static const DED kReferencedOverlayPlaneSequence
      //(2040,0010)
      = const DED("ReferencedOverlayPlaneSequence", 0x20400010,
          "Referenced Overlay Plane Sequence", VR.kSQ, VM.k1, true);
  static const DED kReferencedOverlayPlaneGroups
      //(2040,0011)
      = const DED("ReferencedOverlayPlaneGroups", 0x20400011, "Referenced Overlay Plane Groups",
          VR.kUS, VM.k1_99, true);
  static const DED kOverlayPixelDataSequence
      //(2040,0020)
      = const DED("OverlayPixelDataSequence", 0x20400020, "Overlay Pixel Data Sequence", VR.kSQ,
          VM.k1, true);
  static const DED kOverlayMagnificationType
      //(2040,0060)
      = const DED("OverlayMagnificationType", 0x20400060, "Overlay Magnification Type", VR.kCS,
          VM.k1, true);
  static const DED kOverlaySmoothingType
      //(2040,0070)
      = const DED(
          "OverlaySmoothingType", 0x20400070, "Overlay Smoothing Type", VR.kCS, VM.k1, true);
  static const DED kOverlayOrImageMagnification
      //(2040,0072)
      = const DED("OverlayOrImageMagnification", 0x20400072, "Overlay or Image Magnification",
          VR.kCS, VM.k1, true);
  static const DED kMagnifyToNumberOfColumns
      //(2040,0074)
      = const DED("MagnifyToNumberOfColumns", 0x20400074, "Magnify to Number of Columns",
          VR.kUS, VM.k1, true);
  static const DED kOverlayForegroundDensity
      //(2040,0080)
      = const DED("OverlayForegroundDensity", 0x20400080, "Overlay Foreground Density", VR.kCS,
          VM.k1, true);
  static const DED kOverlayBackgroundDensity
      //(2040,0082)
      = const DED("OverlayBackgroundDensity", 0x20400082, "Overlay Background Density", VR.kCS,
          VM.k1, true);
  static const DED kOverlayMode
      //(2040,0090)
      = const DED("OverlayMode", 0x20400090, "Overlay Mode", VR.kCS, VM.k1, true);
  static const DED kThresholdDensity
      //(2040,0100)
      = const DED("ThresholdDensity", 0x20400100, "Threshold Density", VR.kCS, VM.k1, true);
  static const DED kReferencedImageBoxSequenceRetired
      //(2040,0500)
      = const DED("ReferencedImageBoxSequenceRetired", 0x20400500,
          "Referenced Image Box Sequence (Retired)", VR.kSQ, VM.k1, true);
  static const DED kPresentationLUTSequence
      //(2050,0010)
      = const DED(
          "PresentationLUTSequence", 0x20500010, "Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kPresentationLUTShape
      //(2050,0020)
      = const DED(
          "PresentationLUTShape", 0x20500020, "Presentation LUT Shape", VR.kCS, VM.k1, false);
  static const DED kReferencedPresentationLUTSequence
      //(2050,0500)
      = const DED("ReferencedPresentationLUTSequence", 0x20500500,
          "Referenced Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const DED kPrintJobID
      //(2100,0010)
      = const DED("PrintJobID", 0x21000010, "Print Job ID", VR.kSH, VM.k1, true);
  static const DED kExecutionStatus
      //(2100,0020)
      = const DED("ExecutionStatus", 0x21000020, "Execution Status", VR.kCS, VM.k1, false);
  static const DED kExecutionStatusInfo
      //(2100,0030)
      = const DED(
          "ExecutionStatusInfo", 0x21000030, "Execution Status Info", VR.kCS, VM.k1, false);
  static const DED kCreationDate
      //(2100,0040)
      = const DED("CreationDate", 0x21000040, "Creation Date", VR.kDA, VM.k1, false);
  static const DED kCreationTime
      //(2100,0050)
      = const DED("CreationTime", 0x21000050, "Creation Time", VR.kTM, VM.k1, false);
  static const DED kOriginator
      //(2100,0070)
      = const DED("Originator", 0x21000070, "Originator", VR.kAE, VM.k1, false);
  static const DED kDestinationAE
      //(2100,0140)
      = const DED("DestinationAE", 0x21000140, "Destination AE", VR.kAE, VM.k1, true);
  static const DED kOwnerID
      //(2100,0160)
      = const DED("OwnerID", 0x21000160, "Owner ID", VR.kSH, VM.k1, false);
  static const DED kNumberOfFilms
      //(2100,0170)
      = const DED("NumberOfFilms", 0x21000170, "Number of Films", VR.kIS, VM.k1, false);
  static const DED kReferencedPrintJobSequencePullStoredPrint
      //(2100,0500)
      = const DED("ReferencedPrintJobSequencePullStoredPrint", 0x21000500,
          "Referenced Print Job Sequence (Pull Stored Print)", VR.kSQ, VM.k1, true);
  static const DED kPrinterStatus
      //(2110,0010)
      = const DED("PrinterStatus", 0x21100010, "Printer Status", VR.kCS, VM.k1, false);
  static const DED kPrinterStatusInfo
      //(2110,0020)
      = const DED("PrinterStatusInfo", 0x21100020, "Printer Status Info", VR.kCS, VM.k1, false);
  static const DED kPrinterName
      //(2110,0030)
      = const DED("PrinterName", 0x21100030, "Printer Name", VR.kLO, VM.k1, false);
  static const DED kPrintQueueID
      //(2110,0099)
      = const DED("PrintQueueID", 0x21100099, "Print Queue ID", VR.kSH, VM.k1, true);
  static const DED kQueueStatus
      //(2120,0010)
      = const DED("QueueStatus", 0x21200010, "Queue Status", VR.kCS, VM.k1, true);
  static const DED kPrintJobDescriptionSequence
      //(2120,0050)
      = const DED("PrintJobDescriptionSequence", 0x21200050, "Print Job Description Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kReferencedPrintJobSequence
      //(2120,0070)
      = const DED("ReferencedPrintJobSequence", 0x21200070, "Referenced Print Job Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kPrintManagementCapabilitiesSequence
      //(2130,0010)
      = const DED("PrintManagementCapabilitiesSequence", 0x21300010,
          "Print Management Capabilities Sequence", VR.kSQ, VM.k1, true);
  static const DED kPrinterCharacteristicsSequence
      //(2130,0015)
      = const DED("PrinterCharacteristicsSequence", 0x21300015,
          "Printer Characteristics Sequence", VR.kSQ, VM.k1, true);
  static const DED kFilmBoxContentSequence
      //(2130,0030)
      = const DED(
          "FilmBoxContentSequence", 0x21300030, "Film Box Content Sequence", VR.kSQ, VM.k1, true);
  static const DED kImageBoxContentSequence
      //(2130,0040)
      = const DED(
          "ImageBoxContentSequence", 0x21300040, "Image Box Content Sequence", VR.kSQ, VM.k1, true);
  static const DED kAnnotationContentSequence
      //(2130,0050)
      = const DED("AnnotationContentSequence", 0x21300050, "Annotation Content Sequence",
          VR.kSQ, VM.k1, true);
  static const DED kImageOverlayBoxContentSequence
      //(2130,0060)
      = const DED("ImageOverlayBoxContentSequence", 0x21300060,
          "Image Overlay Box Content Sequence", VR.kSQ, VM.k1, true);
  static const DED kPresentationLUTContentSequence
      //(2130,0080)
      = const DED("PresentationLUTContentSequence", 0x21300080,
          "Presentation LUT Content Sequence", VR.kSQ, VM.k1, true);
  static const DED kProposedStudySequence
      //(2130,00A0)
      = const DED(
          "ProposedStudySequence", 0x213000A0, "Proposed Study Sequence", VR.kSQ, VM.k1, true);
  static const DED kOriginalImageSequence
      //(2130,00C0)
      = const DED(
          "OriginalImageSequence", 0x213000C0, "Original Image Sequence", VR.kSQ, VM.k1, true);
  static const DED kLabelUsingInformationExtractedFromInstances
      //(2200,0001)
      = const DED("LabelUsingInformationExtractedFromInstances", 0x22000001,
          "Label Using Information Extracted From Instances", VR.kCS, VM.k1, false);
  static const DED kLabelText
      //(2200,0002)
      = const DED("LabelText", 0x22000002, "Label Text", VR.kUT, VM.k1, false);
  static const DED kLabelStyleSelection
      //(2200,0003)
      = const DED(
          "LabelStyleSelection", 0x22000003, "Label Style Selection", VR.kCS, VM.k1, false);
  static const DED kMediaDisposition
      //(2200,0004)
      = const DED("MediaDisposition", 0x22000004, "Media Disposition", VR.kLT, VM.k1, false);
  static const DED kBarcodeValue
      //(2200,0005)
      = const DED("BarcodeValue", 0x22000005, "Barcode Value", VR.kLT, VM.k1, false);
  static const DED kBarcodeSymbology
      //(2200,0006)
      = const DED("BarcodeSymbology", 0x22000006, "Barcode Symbology", VR.kCS, VM.k1, false);
  static const DED kAllowMediaSplitting
      //(2200,0007)
      = const DED(
          "AllowMediaSplitting", 0x22000007, "Allow Media Splitting", VR.kCS, VM.k1, false);
  static const DED kIncludeNonDICOMObjects
      //(2200,0008)
      = const DED(
          "IncludeNonDICOMObjects", 0x22000008, "Include Non-DICOM Objects", VR.kCS, VM.k1, false);
  static const DED kIncludeDisplayApplication
      //(2200,0009)
      = const DED("IncludeDisplayApplication", 0x22000009, "Include Display Application",
          VR.kCS, VM.k1, false);
  static const DED kPreserveCompositeInstancesAfterMediaCreation
      //(2200,000A)
      = const DED("PreserveCompositeInstancesAfterMediaCreation", 0x2200000A,
          "Preserve Composite Instances After Media Creation", VR.kCS, VM.k1, false);
  static const DED kTotalNumberOfPiecesOfMediaCreated
      //(2200,000B)
      = const DED("TotalNumberOfPiecesOfMediaCreated", 0x2200000B,
          "Total Number of Pieces of Media Created", VR.kUS, VM.k1, false);
  static const DED kRequestedMediaApplicationProfile
      //(2200,000C)
      = const DED("RequestedMediaApplicationProfile", 0x2200000C,
          "Requested Media Application Profile", VR.kLO, VM.k1, false);
  static const DED kReferencedStorageMediaSequence
      //(2200,000D)
      = const DED("ReferencedStorageMediaSequence", 0x2200000D,
          "Referenced Storage Media Sequence", VR.kSQ, VM.k1, false);
  static const DED kFailureAttributes
      //(2200,000E)
      =
      const DED("FailureAttributes", 0x2200000E, "Failure Attributes", VR.kAT, VM.k1_n, false);
  static const DED kAllowLossyCompression
      //(2200,000F)
      = const DED(
          "AllowLossyCompression", 0x2200000F, "Allow Lossy Compression", VR.kCS, VM.k1, false);
  static const DED kRequestPriority
      //(2200,0020)
      = const DED("RequestPriority", 0x22000020, "Request Priority", VR.kCS, VM.k1, false);
  static const DED kRTImageLabel
      //(3002,0002)
      = const DED("RTImageLabel", 0x30020002, "RT Image Label", VR.kSH, VM.k1, false);
  static const DED kRTImageName
      //(3002,0003)
      = const DED("RTImageName", 0x30020003, "RT Image Name", VR.kLO, VM.k1, false);
  static const DED kRTImageDescription
      //(3002,0004)
      =
      const DED("RTImageDescription", 0x30020004, "RT Image Description", VR.kST, VM.k1, false);
  static const DED kReportedValuesOrigin
      //(3002,000A)
      = const DED(
          "ReportedValuesOrigin", 0x3002000A, "Reported Values Origin", VR.kCS, VM.k1, false);
  static const DED kRTImagePlane
      //(3002,000C)
      = const DED("RTImagePlane", 0x3002000C, "RT Image Plane", VR.kCS, VM.k1, false);
  static const DED kXRayImageReceptorTranslation
      //(3002,000D)
      = const DED("XRayImageReceptorTranslation", 0x3002000D,
          "X-Ray Image Receptor Translation", VR.kDS, VM.k3, false);
  static const DED kXRayImageReceptorAngle
      //(3002,000E)
      = const DED(
          "XRayImageReceptorAngle", 0x3002000E, "X-Ray Image Receptor Angle", VR.kDS, VM.k1, false);
  static const DED kRTImageOrientation
      //(3002,0010)
      =
      const DED("RTImageOrientation", 0x30020010, "RT Image Orientation", VR.kDS, VM.k6, false);
  static const DED kImagePlanePixelSpacing
      //(3002,0011)
      = const DED(
          "ImagePlanePixelSpacing", 0x30020011, "Image Plane Pixel Spacing", VR.kDS, VM.k2, false);
  static const DED kRTImagePosition
      //(3002,0012)
      = const DED("RTImagePosition", 0x30020012, "RT Image Position", VR.kDS, VM.k2, false);
  static const DED kRadiationMachineName
      //(3002,0020)
      = const DED(
          "RadiationMachineName", 0x30020020, "Radiation Machine Name", VR.kSH, VM.k1, false);
  static const DED kRadiationMachineSAD
      //(3002,0022)
      = const DED(
          "RadiationMachineSAD", 0x30020022, "Radiation Machine SAD", VR.kDS, VM.k1, false);
  static const DED kRadiationMachineSSD
      //(3002,0024)
      = const DED(
          "RadiationMachineSSD", 0x30020024, "Radiation Machine SSD", VR.kDS, VM.k1, false);
  static const DED kRTImageSID
      //(3002,0026)
      = const DED("RTImageSID", 0x30020026, "RT Image SID", VR.kDS, VM.k1, false);
  static const DED kSourceToReferenceObjectDistance
      //(3002,0028)
      = const DED("SourceToReferenceObjectDistance", 0x30020028,
          "Source to Reference Object Distance", VR.kDS, VM.k1, false);
  static const DED kFractionNumber
      //(3002,0029)
      = const DED("FractionNumber", 0x30020029, "Fraction Number", VR.kIS, VM.k1, false);
  static const DED kExposureSequence
      //(3002,0030)
      = const DED("ExposureSequence", 0x30020030, "Exposure Sequence", VR.kSQ, VM.k1, false);
  static const DED kMetersetExposure
      //(3002,0032)
      = const DED("MetersetExposure", 0x30020032, "Meterset Exposure", VR.kDS, VM.k1, false);
  static const DED kDiaphragmPosition
      //(3002,0034)
      = const DED("DiaphragmPosition", 0x30020034, "Diaphragm Position", VR.kDS, VM.k4, false);
  static const DED kFluenceMapSequence
      //(3002,0040)
      =
      const DED("FluenceMapSequence", 0x30020040, "Fluence Map Sequence", VR.kSQ, VM.k1, false);
  static const DED kFluenceDataSource
      //(3002,0041)
      = const DED("FluenceDataSource", 0x30020041, "Fluence Data Source", VR.kCS, VM.k1, false);
  static const DED kFluenceDataScale
      //(3002,0042)
      = const DED("FluenceDataScale", 0x30020042, "Fluence Data Scale", VR.kDS, VM.k1, false);
  static const DED kPrimaryFluenceModeSequence
      //(3002,0050)
      = const DED("PrimaryFluenceModeSequence", 0x30020050, "Primary Fluence Mode Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kFluenceMode
      //(3002,0051)
      = const DED("FluenceMode", 0x30020051, "Fluence Mode", VR.kCS, VM.k1, false);
  static const DED kFluenceModeID
      //(3002,0052)
      = const DED("FluenceModeID", 0x30020052, "Fluence Mode ID", VR.kSH, VM.k1, false);
  static const DED kDVHType
      //(3004,0001)
      = const DED("DVHType", 0x30040001, "DVH Type", VR.kCS, VM.k1, false);
  static const DED kDoseUnits
      //(3004,0002)
      = const DED("DoseUnits", 0x30040002, "Dose Units", VR.kCS, VM.k1, false);
  static const DED kDoseType
      //(3004,0004)
      = const DED("DoseType", 0x30040004, "Dose Type", VR.kCS, VM.k1, false);
  static const DED kSpatialTransformOfDose
      //(3004,0005)
      = const DED(
          "SpatialTransformOfDose", 0x30040005, "Spatial Transform of Dose", VR.kCS, VM.k1, false);
  static const DED kDoseComment
      //(3004,0006)
      = const DED("DoseComment", 0x30040006, "Dose Comment", VR.kLO, VM.k1, false);
  static const DED kNormalizationPoint
      //(3004,0008)
      =
      const DED("NormalizationPoint", 0x30040008, "Normalization Point", VR.kDS, VM.k3, false);
  static const DED kDoseSummationType
      //(3004,000A)
      = const DED("DoseSummationType", 0x3004000A, "Dose Summation Type", VR.kCS, VM.k1, false);
  static const DED kGridFrameOffsetVector
      //(3004,000C)
      = const DED(
          "GridFrameOffsetVector", 0x3004000C, "Grid Frame Offset Vector", VR.kDS, VM.k2_n, false);
  static const DED kDoseGridScaling
      //(3004,000E)
      = const DED("DoseGridScaling", 0x3004000E, "Dose Grid Scaling", VR.kDS, VM.k1, false);
  static const DED kRTDoseROISequence
      //(3004,0010)
      =
      const DED("RTDoseROISequence", 0x30040010, "RT Dose ROI Sequence", VR.kSQ, VM.k1, false);
  static const DED kDoseValue
      //(3004,0012)
      = const DED("DoseValue", 0x30040012, "Dose Value", VR.kDS, VM.k1, false);
  static const DED kTissueHeterogeneityCorrection
      //(3004,0014)
      = const DED("TissueHeterogeneityCorrection", 0x30040014,
          "Tissue Heterogeneity Correction", VR.kCS, VM.k1_3, false);
  static const DED kDVHNormalizationPoint
      //(3004,0040)
      = const DED(
          "DVHNormalizationPoint", 0x30040040, "DVH Normalization Point", VR.kDS, VM.k3, false);
  static const DED kDVHNormalizationDoseValue
      //(3004,0042)
      = const DED("DVHNormalizationDoseValue", 0x30040042, "DVH Normalization Dose Value",
          VR.kDS, VM.k1, false);
  static const DED kDVHSequence
      //(3004,0050)
      = const DED("DVHSequence", 0x30040050, "DVH Sequence", VR.kSQ, VM.k1, false);
  static const DED kDVHDoseScaling
      //(3004,0052)
      = const DED("DVHDoseScaling", 0x30040052, "DVH Dose Scaling", VR.kDS, VM.k1, false);
  static const DED kDVHVolumeUnits
      //(3004,0054)
      = const DED("DVHVolumeUnits", 0x30040054, "DVH Volume Units", VR.kCS, VM.k1, false);
  static const DED kDVHNumberOfBins
      //(3004,0056)
      = const DED("DVHNumberOfBins", 0x30040056, "DVH Number of Bins", VR.kIS, VM.k1, false);
  static const DED kDVHData
      //(3004,0058)
      = const DED("DVHData", 0x30040058, "DVH Data", VR.kDS, VM.k2_2n, false);
  static const DED kDVHReferencedROISequence
      //(3004,0060)
      = const DED("DVHReferencedROISequence", 0x30040060, "DVH Referenced ROI Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kDVHROIContributionType
      //(3004,0062)
      = const DED(
          "DVHROIContributionType", 0x30040062, "DVH ROI Contribution Type", VR.kCS, VM.k1, false);
  static const DED kDVHMinimumDose
      //(3004,0070)
      = const DED("DVHMinimumDose", 0x30040070, "DVH Minimum Dose", VR.kDS, VM.k1, false);
  static const DED kDVHMaximumDose
      //(3004,0072)
      = const DED("DVHMaximumDose", 0x30040072, "DVH Maximum Dose", VR.kDS, VM.k1, false);
  static const DED kDVHMeanDose
      //(3004,0074)
      = const DED("DVHMeanDose", 0x30040074, "DVH Mean Dose", VR.kDS, VM.k1, false);
  static const DED kStructureSetLabel
      //(3006,0002)
      = const DED("StructureSetLabel", 0x30060002, "Structure Set Label", VR.kSH, VM.k1, false);
  static const DED kStructureSetName
      //(3006,0004)
      = const DED("StructureSetName", 0x30060004, "Structure Set Name", VR.kLO, VM.k1, false);
  static const DED kStructureSetDescription
      //(3006,0006)
      = const DED(
          "StructureSetDescription", 0x30060006, "Structure Set Description", VR.kST, VM.k1, false);
  static const DED kStructureSetDate
      //(3006,0008)
      = const DED("StructureSetDate", 0x30060008, "Structure Set Date", VR.kDA, VM.k1, false);
  static const DED kStructureSetTime
      //(3006,0009)
      = const DED("StructureSetTime", 0x30060009, "Structure Set Time", VR.kTM, VM.k1, false);
  static const DED kReferencedFrameOfReferenceSequence
      //(3006,0010)
      = const DED("ReferencedFrameOfReferenceSequence", 0x30060010,
          "Referenced Frame of Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kRTReferencedStudySequence
      //(3006,0012)
      = const DED("RTReferencedStudySequence", 0x30060012, "RT Referenced Study Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRTReferencedSeriesSequence
      //(3006,0014)
      = const DED("RTReferencedSeriesSequence", 0x30060014, "RT Referenced Series Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kContourImageSequence
      //(3006,0016)
      = const DED(
          "ContourImageSequence", 0x30060016, "Contour Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kPredecessorStructureSetSequence
      //(3006,0018)
      = const DED("PredecessorStructureSetSequence", 0x30060018,
          "Predecessor Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const DED kStructureSetROISequence
      //(3006,0020)
      = const DED("StructureSetROISequence", 0x30060020, "Structure Set ROI Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kROINumber
      //(3006,0022)
      = const DED("ROINumber", 0x30060022, "ROI Number", VR.kIS, VM.k1, false);
  static const DED kReferencedFrameOfReferenceUID
      //(3006,0024)
      = const DED("ReferencedFrameOfReferenceUID", 0x30060024,
          "Referenced Frame of Reference UID", VR.kUI, VM.k1, false);
  static const DED kROIName
      //(3006,0026)
      = const DED("ROIName", 0x30060026, "ROI Name", VR.kLO, VM.k1, false);
  static const DED kROIDescription
      //(3006,0028)
      = const DED("ROIDescription", 0x30060028, "ROI Description", VR.kST, VM.k1, false);
  static const DED kROIDisplayColor
      //(3006,002A)
      = const DED("ROIDisplayColor", 0x3006002A, "ROI Display Color", VR.kIS, VM.k3, false);
  static const DED kROIVolume
      //(3006,002C)
      = const DED("ROIVolume", 0x3006002C, "ROI Volume", VR.kDS, VM.k1, false);
  static const DED kRTRelatedROISequence
      //(3006,0030)
      = const DED(
          "RTRelatedROISequence", 0x30060030, "RT Related ROI Sequence", VR.kSQ, VM.k1, false);
  static const DED kRTROIRelationship
      //(3006,0033)
      = const DED("RTROIRelationship", 0x30060033, "RT ROI Relationship", VR.kCS, VM.k1, false);
  static const DED kROIGenerationAlgorithm
      //(3006,0036)
      = const DED(
          "ROIGenerationAlgorithm", 0x30060036, "ROI Generation Algorithm", VR.kCS, VM.k1, false);
  static const DED kROIGenerationDescription
      //(3006,0038)
      = const DED("ROIGenerationDescription", 0x30060038, "ROI Generation Description", VR.kLO,
          VM.k1, false);
  static const DED kROIContourSequence
      //(3006,0039)
      =
      const DED("ROIContourSequence", 0x30060039, "ROI Contour Sequence", VR.kSQ, VM.k1, false);
  static const DED kContourSequence
      //(3006,0040)
      = const DED("ContourSequence", 0x30060040, "Contour Sequence", VR.kSQ, VM.k1, false);
  static const DED kContourGeometricType
      //(3006,0042)
      = const DED(
          "ContourGeometricType", 0x30060042, "Contour Geometric Type", VR.kCS, VM.k1, false);
  static const DED kContourSlabThickness
      //(3006,0044)
      = const DED(
          "ContourSlabThickness", 0x30060044, "Contour Slab Thickness", VR.kDS, VM.k1, false);
  static const DED kContourOffsetVector
      //(3006,0045)
      = const DED(
          "ContourOffsetVector", 0x30060045, "Contour Offset Vector", VR.kDS, VM.k3, false);
  static const DED kNumberOfContourPoints
      //(3006,0046)
      = const DED(
          "NumberOfContourPoints", 0x30060046, "Number of Contour Points", VR.kIS, VM.k1, false);
  static const DED kContourNumber
      //(3006,0048)
      = const DED("ContourNumber", 0x30060048, "Contour Number", VR.kIS, VM.k1, false);
  static const DED kAttachedContours
      //(3006,0049)
      = const DED("AttachedContours", 0x30060049, "Attached Contours", VR.kIS, VM.k1_n, false);
  static const DED kContourData
      //(3006,0050)
      = const DED("ContourData", 0x30060050, "Contour Data", VR.kDS, VM.k3_3n, false);
  static const DED kRTROIObservationsSequence
      //(3006,0080)
      = const DED("RTROIObservationsSequence", 0x30060080, "RT ROI Observations Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kObservationNumber
      //(3006,0082)
      = const DED("ObservationNumber", 0x30060082, "Observation Number", VR.kIS, VM.k1, false);
  static const DED kReferencedROINumber
      //(3006,0084)
      = const DED(
          "ReferencedROINumber", 0x30060084, "Referenced ROI Number", VR.kIS, VM.k1, false);
  static const DED kROIObservationLabel
      //(3006,0085)
      = const DED(
          "ROIObservationLabel", 0x30060085, "ROI Observation Label", VR.kSH, VM.k1, false);
  static const DED kRTROIIdentificationCodeSequence
      //(3006,0086)
      = const DED("RTROIIdentificationCodeSequence", 0x30060086,
          "RT ROI Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const DED kROIObservationDescription
      //(3006,0088)
      = const DED("ROIObservationDescription", 0x30060088, "ROI Observation Description",
          VR.kST, VM.k1, false);
  static const DED kRelatedRTROIObservationsSequence
      //(3006,00A0)
      = const DED("RelatedRTROIObservationsSequence", 0x300600A0,
          "Related RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const DED kRTROIInterpretedType
      //(3006,00A4)
      = const DED(
          "RTROIInterpretedType", 0x300600A4, "RT ROI Interpreted Type", VR.kCS, VM.k1, false);
  static const DED kROIInterpreter
      //(3006,00A6)
      = const DED("ROIInterpreter", 0x300600A6, "ROI Interpreter", VR.kPN, VM.k1, false);
  static const DED kROIPhysicalPropertiesSequence
      //(3006,00B0)
      = const DED("ROIPhysicalPropertiesSequence", 0x300600B0,
          "ROI Physical Properties Sequence", VR.kSQ, VM.k1, false);
  static const DED kROIPhysicalProperty
      //(3006,00B2)
      = const DED(
          "ROIPhysicalProperty", 0x300600B2, "ROI Physical Property", VR.kCS, VM.k1, false);
  static const DED kROIPhysicalPropertyValue
      //(3006,00B4)
      = const DED("ROIPhysicalPropertyValue", 0x300600B4, "ROI Physical Property Value", VR.kDS,
          VM.k1, false);
  static const DED kROIElementalCompositionSequence
      //(3006,00B6)
      = const DED("ROIElementalCompositionSequence", 0x300600B6,
          "ROI Elemental Composition Sequence", VR.kSQ, VM.k1, false);
  static const DED kROIElementalCompositionAtomicNumber
      //(3006,00B7)
      = const DED("ROIElementalCompositionAtomicNumber", 0x300600B7,
          "ROI Elemental Composition Atomic Number", VR.kUS, VM.k1, false);
  static const DED kROIElementalCompositionAtomicMassFraction
      //(3006,00B8)
      = const DED("ROIElementalCompositionAtomicMassFraction", 0x300600B8,
          "ROI Elemental Composition Atomic Mass Fraction", VR.kFL, VM.k1, false);
  static const DED kFrameOfReferenceRelationshipSequence
      //(3006,00C0)
      = const DED("FrameOfReferenceRelationshipSequence", 0x300600C0,
          "Frame of Reference Relationship Sequence", VR.kSQ, VM.k1, true);
  static const DED kRelatedFrameOfReferenceUID
      //(3006,00C2)
      = const DED("RelatedFrameOfReferenceUID", 0x300600C2, "Related Frame of Reference UID",
          VR.kUI, VM.k1, true);
  static const DED kFrameOfReferenceTransformationType
      //(3006,00C4)
      = const DED("FrameOfReferenceTransformationType", 0x300600C4,
          "Frame of Reference Transformation Type", VR.kCS, VM.k1, true);
  static const DED kFrameOfReferenceTransformationMatrix
      //(3006,00C6)
      = const DED("FrameOfReferenceTransformationMatrix", 0x300600C6,
          "Frame of Reference Transformation Matrix", VR.kDS, VM.k16, false);
  static const DED kFrameOfReferenceTransformationComment
      //(3006,00C8)
      = const DED("FrameOfReferenceTransformationComment", 0x300600C8,
          "Frame of Reference Transformation Comment", VR.kLO, VM.k1, false);
  static const DED kMeasuredDoseReferenceSequence
      //(3008,0010)
      = const DED("MeasuredDoseReferenceSequence", 0x30080010,
          "Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kMeasuredDoseDescription
      //(3008,0012)
      = const DED(
          "MeasuredDoseDescription", 0x30080012, "Measured Dose Description", VR.kST, VM.k1, false);
  static const DED kMeasuredDoseType
      //(3008,0014)
      = const DED("MeasuredDoseType", 0x30080014, "Measured Dose Type", VR.kCS, VM.k1, false);
  static const DED kMeasuredDoseValue
      //(3008,0016)
      = const DED("MeasuredDoseValue", 0x30080016, "Measured Dose Value", VR.kDS, VM.k1, false);
  static const DED kTreatmentSessionBeamSequence
      //(3008,0020)
      = const DED("TreatmentSessionBeamSequence", 0x30080020, "Treatment Session Beam Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTreatmentSessionIonBeamSequence
      //(3008,0021)
      = const DED("TreatmentSessionIonBeamSequence", 0x30080021,
          "Treatment Session Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const DED kCurrentFractionNumber
      //(3008,0022)
      = const DED(
          "CurrentFractionNumber", 0x30080022, "Current Fraction Number", VR.kIS, VM.k1, false);
  static const DED kTreatmentControlPointDate
      //(3008,0024)
      = const DED("TreatmentControlPointDate", 0x30080024, "Treatment Control Point Date",
          VR.kDA, VM.k1, false);
  static const DED kTreatmentControlPointTime
      //(3008,0025)
      = const DED("TreatmentControlPointTime", 0x30080025, "Treatment Control Point Time",
          VR.kTM, VM.k1, false);
  static const DED kTreatmentTerminationStatus
      //(3008,002A)
      = const DED("TreatmentTerminationStatus", 0x3008002A, "Treatment Termination Status",
          VR.kCS, VM.k1, false);
  static const DED kTreatmentTerminationCode
      //(3008,002B)
      = const DED("TreatmentTerminationCode", 0x3008002B, "Treatment Termination Code", VR.kSH,
          VM.k1, false);
  static const DED kTreatmentVerificationStatus
      //(3008,002C)
      = const DED("TreatmentVerificationStatus", 0x3008002C, "Treatment Verification Status",
          VR.kCS, VM.k1, false);
  static const DED kReferencedTreatmentRecordSequence
      //(3008,0030)
      = const DED("ReferencedTreatmentRecordSequence", 0x30080030,
          "Referenced Treatment Record Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecifiedPrimaryMeterset
      //(3008,0032)
      = const DED("SpecifiedPrimaryMeterset", 0x30080032, "Specified Primary Meterset", VR.kDS,
          VM.k1, false);
  static const DED kSpecifiedSecondaryMeterset
      //(3008,0033)
      = const DED("SpecifiedSecondaryMeterset", 0x30080033, "Specified Secondary Meterset",
          VR.kDS, VM.k1, false);
  static const DED kDeliveredPrimaryMeterset
      //(3008,0036)
      = const DED("DeliveredPrimaryMeterset", 0x30080036, "Delivered Primary Meterset", VR.kDS,
          VM.k1, false);
  static const DED kDeliveredSecondaryMeterset
      //(3008,0037)
      = const DED("DeliveredSecondaryMeterset", 0x30080037, "Delivered Secondary Meterset",
          VR.kDS, VM.k1, false);
  static const DED kSpecifiedTreatmentTime
      //(3008,003A)
      = const DED(
          "SpecifiedTreatmentTime", 0x3008003A, "Specified Treatment Time", VR.kDS, VM.k1, false);
  static const DED kDeliveredTreatmentTime
      //(3008,003B)
      = const DED(
          "DeliveredTreatmentTime", 0x3008003B, "Delivered Treatment Time", VR.kDS, VM.k1, false);
  static const DED kControlPointDeliverySequence
      //(3008,0040)
      = const DED("ControlPointDeliverySequence", 0x30080040, "Control Point Delivery Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kIonControlPointDeliverySequence
      //(3008,0041)
      = const DED("IonControlPointDeliverySequence", 0x30080041,
          "Ion Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecifiedMeterset
      //(3008,0042)
      = const DED("SpecifiedMeterset", 0x30080042, "Specified Meterset", VR.kDS, VM.k1, false);
  static const DED kDeliveredMeterset
      //(3008,0044)
      = const DED("DeliveredMeterset", 0x30080044, "Delivered Meterset", VR.kDS, VM.k1, false);
  static const DED kMetersetRateSet
      //(3008,0045)
      = const DED("MetersetRateSet", 0x30080045, "Meterset Rate Set", VR.kFL, VM.k1, false);
  static const DED kMetersetRateDelivered
      //(3008,0046)
      = const DED(
          "MetersetRateDelivered", 0x30080046, "Meterset Rate Delivered", VR.kFL, VM.k1, false);
  static const DED kScanSpotMetersetsDelivered
      //(3008,0047)
      = const DED("ScanSpotMetersetsDelivered", 0x30080047, "Scan Spot Metersets Delivered",
          VR.kFL, VM.k1_n, false);
  static const DED kDoseRateDelivered
      //(3008,0048)
      = const DED("DoseRateDelivered", 0x30080048, "Dose Rate Delivered", VR.kDS, VM.k1, false);
  static const DED kTreatmentSummaryCalculatedDoseReferenceSequence
      //(3008,0050)
      = const DED("TreatmentSummaryCalculatedDoseReferenceSequence", 0x30080050,
          "Treatment Summary Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kCumulativeDoseToDoseReference
      //(3008,0052)
      = const DED("CumulativeDoseToDoseReference", 0x30080052,
          "Cumulative Dose to Dose Reference", VR.kDS, VM.k1, false);
  static const DED kFirstTreatmentDate
      //(3008,0054)
      =
      const DED("FirstTreatmentDate", 0x30080054, "First Treatment Date", VR.kDA, VM.k1, false);
  static const DED kMostRecentTreatmentDate
      //(3008,0056)
      = const DED("MostRecentTreatmentDate", 0x30080056, "Most Recent Treatment Date", VR.kDA,
          VM.k1, false);
  static const DED kNumberOfFractionsDelivered
      //(3008,005A)
      = const DED("NumberOfFractionsDelivered", 0x3008005A, "Number of Fractions Delivered",
          VR.kIS, VM.k1, false);
  static const DED kOverrideSequence
      //(3008,0060)
      = const DED("OverrideSequence", 0x30080060, "Override Sequence", VR.kSQ, VM.k1, false);
  static const DED kParameterSequencePointer
      //(3008,0061)
      = const DED("ParameterSequencePointer", 0x30080061, "Parameter Sequence Pointer", VR.kAT,
          VM.k1, false);
  static const DED kOverrideParameterPointer
      //(3008,0062)
      = const DED("OverrideParameterPointer", 0x30080062, "Override Parameter Pointer", VR.kAT,
          VM.k1, false);
  static const DED kParameterItemIndex
      //(3008,0063)
      =
      const DED("ParameterItemIndex", 0x30080063, "Parameter Item Index", VR.kIS, VM.k1, false);
  static const DED kMeasuredDoseReferenceNumber
      //(3008,0064)
      = const DED("MeasuredDoseReferenceNumber", 0x30080064, "Measured Dose Reference Number",
          VR.kIS, VM.k1, false);
  static const DED kParameterPointer
      //(3008,0065)
      = const DED("ParameterPointer", 0x30080065, "Parameter Pointer", VR.kAT, VM.k1, false);
  static const DED kOverrideReason
      //(3008,0066)
      = const DED("OverrideReason", 0x30080066, "Override Reason", VR.kST, VM.k1, false);
  static const DED kCorrectedParameterSequence
      //(3008,0068)
      = const DED("CorrectedParameterSequence", 0x30080068, "Corrected Parameter Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCorrectionValue
      //(3008,006A)
      = const DED("CorrectionValue", 0x3008006A, "Correction Value", VR.kFL, VM.k1, false);
  static const DED kCalculatedDoseReferenceSequence
      //(3008,0070)
      = const DED("CalculatedDoseReferenceSequence", 0x30080070,
          "Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kCalculatedDoseReferenceNumber
      //(3008,0072)
      = const DED("CalculatedDoseReferenceNumber", 0x30080072,
          "Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const DED kCalculatedDoseReferenceDescription
      //(3008,0074)
      = const DED("CalculatedDoseReferenceDescription", 0x30080074,
          "Calculated Dose Reference Description", VR.kST, VM.k1, false);
  static const DED kCalculatedDoseReferenceDoseValue
      //(3008,0076)
      = const DED("CalculatedDoseReferenceDoseValue", 0x30080076,
          "Calculated Dose Reference Dose Value", VR.kDS, VM.k1, false);
  static const DED kStartMeterset
      //(3008,0078)
      = const DED("StartMeterset", 0x30080078, "Start Meterset", VR.kDS, VM.k1, false);
  static const DED kEndMeterset
      //(3008,007A)
      = const DED("EndMeterset", 0x3008007A, "End Meterset", VR.kDS, VM.k1, false);
  static const DED kReferencedMeasuredDoseReferenceSequence
      //(3008,0080)
      = const DED("ReferencedMeasuredDoseReferenceSequence", 0x30080080,
          "Referenced Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedMeasuredDoseReferenceNumber
      //(3008,0082)
      = const DED("ReferencedMeasuredDoseReferenceNumber", 0x30080082,
          "Referenced Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const DED kReferencedCalculatedDoseReferenceSequence
      //(3008,0090)
      = const DED("ReferencedCalculatedDoseReferenceSequence", 0x30080090,
          "Referenced Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedCalculatedDoseReferenceNumber
      //(3008,0092)
      = const DED("ReferencedCalculatedDoseReferenceNumber", 0x30080092,
          "Referenced Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const DED kBeamLimitingDeviceLeafPairsSequence
      //(3008,00A0)
      = const DED("BeamLimitingDeviceLeafPairsSequence", 0x300800A0,
          "Beam Limiting Device Leaf Pairs Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedWedgeSequence
      //(3008,00B0)
      = const DED(
          "RecordedWedgeSequence", 0x300800B0, "Recorded Wedge Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedCompensatorSequence
      //(3008,00C0)
      = const DED("RecordedCompensatorSequence", 0x300800C0, "Recorded Compensator Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRecordedBlockSequence
      //(3008,00D0)
      = const DED(
          "RecordedBlockSequence", 0x300800D0, "Recorded Block Sequence", VR.kSQ, VM.k1, false);
  static const DED kTreatmentSummaryMeasuredDoseReferenceSequence
      //(3008,00E0)
      = const DED("TreatmentSummaryMeasuredDoseReferenceSequence", 0x300800E0,
          "Treatment Summary Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedSnoutSequence
      //(3008,00F0)
      = const DED(
          "RecordedSnoutSequence", 0x300800F0, "Recorded Snout Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedRangeShifterSequence
      //(3008,00F2)
      = const DED("RecordedRangeShifterSequence", 0x300800F2, "Recorded Range Shifter Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRecordedLateralSpreadingDeviceSequence
      //(3008,00F4)
      = const DED("RecordedLateralSpreadingDeviceSequence", 0x300800F4,
          "Recorded Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedRangeModulatorSequence
      //(3008,00F6)
      = const DED("RecordedRangeModulatorSequence", 0x300800F6,
          "Recorded Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const DED kRecordedSourceSequence
      //(3008,0100)
      = const DED(
          "RecordedSourceSequence", 0x30080100, "Recorded Source Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceSerialNumber
      //(3008,0105)
      =
      const DED("SourceSerialNumber", 0x30080105, "Source Serial Number", VR.kLO, VM.k1, false);
  static const DED kTreatmentSessionApplicationSetupSequence
      //(3008,0110)
      = const DED("TreatmentSessionApplicationSetupSequence", 0x30080110,
          "Treatment Session Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const DED kApplicationSetupCheck
      //(3008,0116)
      = const DED(
          "ApplicationSetupCheck", 0x30080116, "Application Setup Check", VR.kCS, VM.k1, false);
  static const DED kRecordedBrachyAccessoryDeviceSequence
      //(3008,0120)
      = const DED("RecordedBrachyAccessoryDeviceSequence", 0x30080120,
          "Recorded Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedBrachyAccessoryDeviceNumber
      //(3008,0122)
      = const DED("ReferencedBrachyAccessoryDeviceNumber", 0x30080122,
          "Referenced Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const DED kRecordedChannelSequence
      //(3008,0130)
      = const DED(
          "RecordedChannelSequence", 0x30080130, "Recorded Channel Sequence", VR.kSQ, VM.k1, false);
  static const DED kSpecifiedChannelTotalTime
      //(3008,0132)
      = const DED("SpecifiedChannelTotalTime", 0x30080132, "Specified Channel Total Time",
          VR.kDS, VM.k1, false);
  static const DED kDeliveredChannelTotalTime
      //(3008,0134)
      = const DED("DeliveredChannelTotalTime", 0x30080134, "Delivered Channel Total Time",
          VR.kDS, VM.k1, false);
  static const DED kSpecifiedNumberOfPulses
      //(3008,0136)
      = const DED("SpecifiedNumberOfPulses", 0x30080136, "Specified Number of Pulses", VR.kIS,
          VM.k1, false);
  static const DED kDeliveredNumberOfPulses
      //(3008,0138)
      = const DED("DeliveredNumberOfPulses", 0x30080138, "Delivered Number of Pulses", VR.kIS,
          VM.k1, false);
  static const DED kSpecifiedPulseRepetitionInterval
      //(3008,013A)
      = const DED("SpecifiedPulseRepetitionInterval", 0x3008013A,
          "Specified Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const DED kDeliveredPulseRepetitionInterval
      //(3008,013C)
      = const DED("DeliveredPulseRepetitionInterval", 0x3008013C,
          "Delivered Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const DED kRecordedSourceApplicatorSequence
      //(3008,0140)
      = const DED("RecordedSourceApplicatorSequence", 0x30080140,
          "Recorded Source Applicator Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedSourceApplicatorNumber
      //(3008,0142)
      = const DED("ReferencedSourceApplicatorNumber", 0x30080142,
          "Referenced Source Applicator Number", VR.kIS, VM.k1, false);
  static const DED kRecordedChannelShieldSequence
      //(3008,0150)
      = const DED("RecordedChannelShieldSequence", 0x30080150,
          "Recorded Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedChannelShieldNumber
      //(3008,0152)
      = const DED("ReferencedChannelShieldNumber", 0x30080152,
          "Referenced Channel Shield Number", VR.kIS, VM.k1, false);
  static const DED kBrachyControlPointDeliveredSequence
      //(3008,0160)
      = const DED("BrachyControlPointDeliveredSequence", 0x30080160,
          "Brachy Control Point Delivered Sequence", VR.kSQ, VM.k1, false);
  static const DED kSafePositionExitDate
      //(3008,0162)
      = const DED(
          "SafePositionExitDate", 0x30080162, "Safe Position Exit Date", VR.kDA, VM.k1, false);
  static const DED kSafePositionExitTime
      //(3008,0164)
      = const DED(
          "SafePositionExitTime", 0x30080164, "Safe Position Exit Time", VR.kTM, VM.k1, false);
  static const DED kSafePositionReturnDate
      //(3008,0166)
      = const DED(
          "SafePositionReturnDate", 0x30080166, "Safe Position Return Date", VR.kDA, VM.k1, false);
  static const DED kSafePositionReturnTime
      //(3008,0168)
      = const DED(
          "SafePositionReturnTime", 0x30080168, "Safe Position Return Time", VR.kTM, VM.k1, false);
  static const DED kCurrentTreatmentStatus
      //(3008,0200)
      = const DED(
          "CurrentTreatmentStatus", 0x30080200, "Current Treatment Status", VR.kCS, VM.k1, false);
  static const DED kTreatmentStatusComment
      //(3008,0202)
      = const DED(
          "TreatmentStatusComment", 0x30080202, "Treatment Status Comment", VR.kST, VM.k1, false);
  static const DED kFractionGroupSummarySequence
      //(3008,0220)
      = const DED("FractionGroupSummarySequence", 0x30080220, "Fraction Group Summary Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kReferencedFractionNumber
      //(3008,0223)
      = const DED("ReferencedFractionNumber", 0x30080223, "Referenced Fraction Number", VR.kIS,
          VM.k1, false);
  static const DED kFractionGroupType
      //(3008,0224)
      = const DED("FractionGroupType", 0x30080224, "Fraction Group Type", VR.kCS, VM.k1, false);
  static const DED kBeamStopperPosition
      //(3008,0230)
      = const DED(
          "BeamStopperPosition", 0x30080230, "Beam Stopper Position", VR.kCS, VM.k1, false);
  static const DED kFractionStatusSummarySequence
      //(3008,0240)
      = const DED("FractionStatusSummarySequence", 0x30080240,
          "Fraction Status Summary Sequence", VR.kSQ, VM.k1, false);
  static const DED kTreatmentDate
      //(3008,0250)
      = const DED("TreatmentDate", 0x30080250, "Treatment Date", VR.kDA, VM.k1, false);
  static const DED kTreatmentTime
      //(3008,0251)
      = const DED("TreatmentTime", 0x30080251, "Treatment Time", VR.kTM, VM.k1, false);
  static const DED kRTPlanLabel
      //(300A,0002)
      = const DED("RTPlanLabel", 0x300A0002, "RT Plan Label", VR.kSH, VM.k1, false);
  static const DED kRTPlanName
      //(300A,0003)
      = const DED("RTPlanName", 0x300A0003, "RT Plan Name", VR.kLO, VM.k1, false);
  static const DED kRTPlanDescription
      //(300A,0004)
      = const DED("RTPlanDescription", 0x300A0004, "RT Plan Description", VR.kST, VM.k1, false);
  static const DED kRTPlanDate
      //(300A,0006)
      = const DED("RTPlanDate", 0x300A0006, "RT Plan Date", VR.kDA, VM.k1, false);
  static const DED kRTPlanTime
      //(300A,0007)
      = const DED("RTPlanTime", 0x300A0007, "RT Plan Time", VR.kTM, VM.k1, false);
  static const DED kTreatmentProtocols
      //(300A,0009)
      = const DED(
          "TreatmentProtocols", 0x300A0009, "Treatment Protocols", VR.kLO, VM.k1_n, false);
  static const DED kPlanIntent
      //(300A,000A)
      = const DED("PlanIntent", 0x300A000A, "Plan Intent", VR.kCS, VM.k1, false);
  static const DED kTreatmentSites
      //(300A,000B)
      = const DED("TreatmentSites", 0x300A000B, "Treatment Sites", VR.kLO, VM.k1_n, false);
  static const DED kRTPlanGeometry
      //(300A,000C)
      = const DED("RTPlanGeometry", 0x300A000C, "RT Plan Geometry", VR.kCS, VM.k1, false);
  static const DED kPrescriptionDescription
      //(300A,000E)
      = const DED(
          "PrescriptionDescription", 0x300A000E, "Prescription Description", VR.kST, VM.k1, false);
  static const DED kDoseReferenceSequence
      //(300A,0010)
      = const DED(
          "DoseReferenceSequence", 0x300A0010, "Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kDoseReferenceNumber
      //(300A,0012)
      = const DED(
          "DoseReferenceNumber", 0x300A0012, "Dose Reference Number", VR.kIS, VM.k1, false);
  static const DED kDoseReferenceUID
      //(300A,0013)
      = const DED("DoseReferenceUID", 0x300A0013, "Dose Reference UID", VR.kUI, VM.k1, false);
  static const DED kDoseReferenceStructureType
      //(300A,0014)
      = const DED("DoseReferenceStructureType", 0x300A0014, "Dose Reference Structure Type",
          VR.kCS, VM.k1, false);
  static const DED kNominalBeamEnergyUnit
      //(300A,0015)
      = const DED(
          "NominalBeamEnergyUnit", 0x300A0015, "Nominal Beam Energy Unit", VR.kCS, VM.k1, false);
  static const DED kDoseReferenceDescription
      //(300A,0016)
      = const DED("DoseReferenceDescription", 0x300A0016, "Dose Reference Description", VR.kLO,
          VM.k1, false);
  static const DED kDoseReferencePointCoordinates
      //(300A,0018)
      = const DED("DoseReferencePointCoordinates", 0x300A0018,
          "Dose Reference Point Coordinates", VR.kDS, VM.k3, false);
  static const DED kNominalPriorDose
      //(300A,001A)
      = const DED("NominalPriorDose", 0x300A001A, "Nominal Prior Dose", VR.kDS, VM.k1, false);
  static const DED kDoseReferenceType
      //(300A,0020)
      = const DED("DoseReferenceType", 0x300A0020, "Dose Reference Type", VR.kCS, VM.k1, false);
  static const DED kConstraintWeight
      //(300A,0021)
      = const DED("ConstraintWeight", 0x300A0021, "Constraint Weight", VR.kDS, VM.k1, false);
  static const DED kDeliveryWarningDose
      //(300A,0022)
      = const DED(
          "DeliveryWarningDose", 0x300A0022, "Delivery Warning Dose", VR.kDS, VM.k1, false);
  static const DED kDeliveryMaximumDose
      //(300A,0023)
      = const DED(
          "DeliveryMaximumDose", 0x300A0023, "Delivery Maximum Dose", VR.kDS, VM.k1, false);
  static const DED kTargetMinimumDose
      //(300A,0025)
      = const DED("TargetMinimumDose", 0x300A0025, "Target Minimum Dose", VR.kDS, VM.k1, false);
  static const DED kTargetPrescriptionDose
      //(300A,0026)
      = const DED(
          "TargetPrescriptionDose", 0x300A0026, "Target Prescription Dose", VR.kDS, VM.k1, false);
  static const DED kTargetMaximumDose
      //(300A,0027)
      = const DED("TargetMaximumDose", 0x300A0027, "Target Maximum Dose", VR.kDS, VM.k1, false);
  static const DED kTargetUnderdoseVolumeFraction
      //(300A,0028)
      = const DED("TargetUnderdoseVolumeFraction", 0x300A0028,
          "Target Underdose Volume Fraction", VR.kDS, VM.k1, false);
  static const DED kOrganAtRiskFullVolumeDose
      //(300A,002A)
      = const DED("OrganAtRiskFullVolumeDose", 0x300A002A, "Organ at Risk Full-volume Dose",
          VR.kDS, VM.k1, false);
  static const DED kOrganAtRiskLimitDose
      //(300A,002B)
      = const DED(
          "OrganAtRiskLimitDose", 0x300A002B, "Organ at Risk Limit Dose", VR.kDS, VM.k1, false);
  static const DED kOrganAtRiskMaximumDose
      //(300A,002C)
      = const DED(
          "OrganAtRiskMaximumDose", 0x300A002C, "Organ at Risk Maximum Dose", VR.kDS, VM.k1, false);
  static const DED kOrganAtRiskOverdoseVolumeFraction
      //(300A,002D)
      = const DED("OrganAtRiskOverdoseVolumeFraction", 0x300A002D,
          "Organ at Risk Overdose Volume Fraction", VR.kDS, VM.k1, false);
  static const DED kToleranceTableSequence
      //(300A,0040)
      = const DED(
          "ToleranceTableSequence", 0x300A0040, "Tolerance Table Sequence", VR.kSQ, VM.k1, false);
  static const DED kToleranceTableNumber
      //(300A,0042)
      = const DED(
          "ToleranceTableNumber", 0x300A0042, "Tolerance Table Number", VR.kIS, VM.k1, false);
  static const DED kToleranceTableLabel
      //(300A,0043)
      = const DED(
          "ToleranceTableLabel", 0x300A0043, "Tolerance Table Label", VR.kSH, VM.k1, false);
  static const DED kGantryAngleTolerance
      //(300A,0044)
      = const DED(
          "GantryAngleTolerance", 0x300A0044, "Gantry Angle Tolerance", VR.kDS, VM.k1, false);
  static const DED kBeamLimitingDeviceAngleTolerance
      //(300A,0046)
      = const DED("BeamLimitingDeviceAngleTolerance", 0x300A0046,
          "Beam Limiting Device Angle Tolerance", VR.kDS, VM.k1, false);
  static const DED kBeamLimitingDeviceToleranceSequence
      //(300A,0048)
      = const DED("BeamLimitingDeviceToleranceSequence", 0x300A0048,
          "Beam Limiting Device Tolerance Sequence", VR.kSQ, VM.k1, false);
  static const DED kBeamLimitingDevicePositionTolerance
      //(300A,004A)
      = const DED("BeamLimitingDevicePositionTolerance", 0x300A004A,
          "Beam Limiting Device Position Tolerance", VR.kDS, VM.k1, false);
  static const DED kSnoutPositionTolerance
      //(300A,004B)
      = const DED(
          "SnoutPositionTolerance", 0x300A004B, "Snout Position Tolerance", VR.kFL, VM.k1, false);
  static const DED kPatientSupportAngleTolerance
      //(300A,004C)
      = const DED("PatientSupportAngleTolerance", 0x300A004C, "Patient Support Angle Tolerance",
          VR.kDS, VM.k1, false);
  static const DED kTableTopEccentricAngleTolerance
      //(300A,004E)
      = const DED("TableTopEccentricAngleTolerance", 0x300A004E,
          "Table Top Eccentric Angle Tolerance", VR.kDS, VM.k1, false);
  static const DED kTableTopPitchAngleTolerance
      //(300A,004F)
      = const DED("TableTopPitchAngleTolerance", 0x300A004F, "Table Top Pitch Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const DED kTableTopRollAngleTolerance
      //(300A,0050)
      = const DED("TableTopRollAngleTolerance", 0x300A0050, "Table Top Roll Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const DED kTableTopVerticalPositionTolerance
      //(300A,0051)
      = const DED("TableTopVerticalPositionTolerance", 0x300A0051,
          "Table Top Vertical Position Tolerance", VR.kDS, VM.k1, false);
  static const DED kTableTopLongitudinalPositionTolerance
      //(300A,0052)
      = const DED("TableTopLongitudinalPositionTolerance", 0x300A0052,
          "Table Top Longitudinal Position Tolerance", VR.kDS, VM.k1, false);
  static const DED kTableTopLateralPositionTolerance
      //(300A,0053)
      = const DED("TableTopLateralPositionTolerance", 0x300A0053,
          "Table Top Lateral Position Tolerance", VR.kDS, VM.k1, false);
  static const DED kRTPlanRelationship
      //(300A,0055)
      =
      const DED("RTPlanRelationship", 0x300A0055, "RT Plan Relationship", VR.kCS, VM.k1, false);
  static const DED kFractionGroupSequence
      //(300A,0070)
      = const DED(
          "FractionGroupSequence", 0x300A0070, "Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const DED kFractionGroupNumber
      //(300A,0071)
      = const DED(
          "FractionGroupNumber", 0x300A0071, "Fraction Group Number", VR.kIS, VM.k1, false);
  static const DED kFractionGroupDescription
      //(300A,0072)
      = const DED("FractionGroupDescription", 0x300A0072, "Fraction Group Description", VR.kLO,
          VM.k1, false);
  static const DED kNumberOfFractionsPlanned
      //(300A,0078)
      = const DED("NumberOfFractionsPlanned", 0x300A0078, "Number of Fractions Planned", VR.kIS,
          VM.k1, false);
  static const DED kNumberOfFractionPatternDigitsPerDay
      //(300A,0079)
      = const DED("NumberOfFractionPatternDigitsPerDay", 0x300A0079,
          "Number of Fraction Pattern Digits Per Day", VR.kIS, VM.k1, false);
  static const DED kRepeatFractionCycleLength
      //(300A,007A)
      = const DED("RepeatFractionCycleLength", 0x300A007A, "Repeat Fraction Cycle Length",
          VR.kIS, VM.k1, false);
  static const DED kFractionPattern
      //(300A,007B)
      = const DED("FractionPattern", 0x300A007B, "Fraction Pattern", VR.kLT, VM.k1, false);
  static const DED kNumberOfBeams
      //(300A,0080)
      = const DED("NumberOfBeams", 0x300A0080, "Number of Beams", VR.kIS, VM.k1, false);
  static const DED kBeamDoseSpecificationPoint
      //(300A,0082)
      = const DED("BeamDoseSpecificationPoint", 0x300A0082, "Beam Dose Specification Point",
          VR.kDS, VM.k3, false);
  static const DED kBeamDose
      //(300A,0084)
      = const DED("BeamDose", 0x300A0084, "Beam Dose", VR.kDS, VM.k1, false);
  static const DED kBeamMeterset
      //(300A,0086)
      = const DED("BeamMeterset", 0x300A0086, "Beam Meterset", VR.kDS, VM.k1, false);
  static const DED kBeamDosePointDepth
      //(300A,0088)
      =
      const DED("BeamDosePointDepth", 0x300A0088, "Beam Dose Point Depth", VR.kFL, VM.k1, true);
  static const DED kBeamDosePointEquivalentDepth
      //(300A,0089)
      = const DED("BeamDosePointEquivalentDepth", 0x300A0089,
          "Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, true);
  static const DED kBeamDosePointSSD
      //(300A,008A)
      = const DED("BeamDosePointSSD", 0x300A008A, "Beam Dose Point SSD", VR.kFL, VM.k1, true);
  static const DED kBeamDoseMeaning
      //(300A,008B)
      = const DED("BeamDoseMeaning", 0x300A008B, "Beam Dose Meaning", VR.kCS, VM.k1, false);
  static const DED kBeamDoseVerificationControlPointSequence
      //(300A,008C)
      = const DED("BeamDoseVerificationControlPointSequence", 0x300A008C,
          "Beam Dose Verification Control Point Sequence", VR.kSQ, VM.k1, false);
  static const DED kAverageBeamDosePointDepth
      //(300A,008D)
      = const DED("AverageBeamDosePointDepth", 0x300A008D, "Average Beam Dose Point Depth",
          VR.kFL, VM.k1, false);
  static const DED kAverageBeamDosePointEquivalentDepth
      //(300A,008E)
      = const DED("AverageBeamDosePointEquivalentDepth", 0x300A008E,
          "Average Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, false);
  static const DED kAverageBeamDosePointSSD
      //(300A,008F)
      = const DED("AverageBeamDosePointSSD", 0x300A008F, "Average Beam Dose Point SSD", VR.kFL,
          VM.k1, false);
  static const DED kNumberOfBrachyApplicationSetups
      //(300A,00A0)
      = const DED("NumberOfBrachyApplicationSetups", 0x300A00A0,
          "Number of Brachy Application Setups", VR.kIS, VM.k1, false);
  static const DED kBrachyApplicationSetupDoseSpecificationPoint
      //(300A,00A2)
      = const DED("BrachyApplicationSetupDoseSpecificationPoint", 0x300A00A2,
          "Brachy Application Setup Dose Specification Point", VR.kDS, VM.k3, false);
  static const DED kBrachyApplicationSetupDose
      //(300A,00A4)
      = const DED("BrachyApplicationSetupDose", 0x300A00A4, "Brachy Application Setup Dose",
          VR.kDS, VM.k1, false);
  static const DED kBeamSequence
      //(300A,00B0)
      = const DED("BeamSequence", 0x300A00B0, "Beam Sequence", VR.kSQ, VM.k1, false);
  static const DED kTreatmentMachineName
      //(300A,00B2)
      = const DED(
          "TreatmentMachineName", 0x300A00B2, "Treatment Machine Name", VR.kSH, VM.k1, false);
  static const DED kPrimaryDosimeterUnit
      //(300A,00B3)
      = const DED(
          "PrimaryDosimeterUnit", 0x300A00B3, "Primary Dosimeter Unit", VR.kCS, VM.k1, false);
  static const DED kSourceAxisDistance
      //(300A,00B4)
      =
      const DED("SourceAxisDistance", 0x300A00B4, "Source-Axis Distance", VR.kDS, VM.k1, false);
  static const DED kBeamLimitingDeviceSequence
      //(300A,00B6)
      = const DED("BeamLimitingDeviceSequence", 0x300A00B6, "Beam Limiting Device Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRTBeamLimitingDeviceType
      //(300A,00B8)
      = const DED("RTBeamLimitingDeviceType", 0x300A00B8, "RT Beam Limiting Device Type",
          VR.kCS, VM.k1, false);
  static const DED kSourceToBeamLimitingDeviceDistance
      //(300A,00BA)
      = const DED("SourceToBeamLimitingDeviceDistance", 0x300A00BA,
          "Source to Beam Limiting Device Distance", VR.kDS, VM.k1, false);
  static const DED kIsocenterToBeamLimitingDeviceDistance
      //(300A,00BB)
      = const DED("IsocenterToBeamLimitingDeviceDistance", 0x300A00BB,
          "Isocenter to Beam Limiting Device Distance", VR.kFL, VM.k1, false);
  static const DED kNumberOfLeafJawPairs
      //(300A,00BC)
      = const DED(
          "NumberOfLeafJawPairs", 0x300A00BC, "Number of Leaf/Jaw Pairs", VR.kIS, VM.k1, false);
  static const DED kLeafPositionBoundaries
      //(300A,00BE)
      = const DED(
          "LeafPositionBoundaries", 0x300A00BE, "Leaf Position Boundaries", VR.kDS, VM.k3_n, false);
  static const DED kBeamNumber
      //(300A,00C0)
      = const DED("BeamNumber", 0x300A00C0, "Beam Number", VR.kIS, VM.k1, false);
  static const DED kBeamName
      //(300A,00C2)
      = const DED("BeamName", 0x300A00C2, "Beam Name", VR.kLO, VM.k1, false);
  static const DED kBeamDescription
      //(300A,00C3)
      = const DED("BeamDescription", 0x300A00C3, "Beam Description", VR.kST, VM.k1, false);
  static const DED kBeamType
      //(300A,00C4)
      = const DED("BeamType", 0x300A00C4, "Beam Type", VR.kCS, VM.k1, false);
  static const DED kRadiationType
      //(300A,00C6)
      = const DED("RadiationType", 0x300A00C6, "Radiation Type", VR.kCS, VM.k1, false);
  static const DED kHighDoseTechniqueType
      //(300A,00C7)
      = const DED(
          "HighDoseTechniqueType", 0x300A00C7, "High-Dose Technique Type", VR.kCS, VM.k1, false);
  static const DED kReferenceImageNumber
      //(300A,00C8)
      = const DED(
          "ReferenceImageNumber", 0x300A00C8, "Reference Image Number", VR.kIS, VM.k1, false);
  static const DED kPlannedVerificationImageSequence
      //(300A,00CA)
      = const DED("PlannedVerificationImageSequence", 0x300A00CA,
          "Planned Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kImagingDeviceSpecificAcquisitionParameters
      //(300A,00CC)
      = const DED("ImagingDeviceSpecificAcquisitionParameters", 0x300A00CC,
          "Imaging Device-Specific Acquisition Parameters", VR.kLO, VM.k1_n, false);
  static const DED kTreatmentDeliveryType
      //(300A,00CE)
      = const DED(
          "TreatmentDeliveryType", 0x300A00CE, "Treatment Delivery Type", VR.kCS, VM.k1, false);
  static const DED kNumberOfWedges
      //(300A,00D0)
      = const DED("NumberOfWedges", 0x300A00D0, "Number of Wedges", VR.kIS, VM.k1, false);
  static const DED kWedgeSequence
      //(300A,00D1)
      = const DED("WedgeSequence", 0x300A00D1, "Wedge Sequence", VR.kSQ, VM.k1, false);
  static const DED kWedgeNumber
      //(300A,00D2)
      = const DED("WedgeNumber", 0x300A00D2, "Wedge Number", VR.kIS, VM.k1, false);
  static const DED kWedgeType
      //(300A,00D3)
      = const DED("WedgeType", 0x300A00D3, "Wedge Type", VR.kCS, VM.k1, false);
  static const DED kWedgeID
      //(300A,00D4)
      = const DED("WedgeID", 0x300A00D4, "Wedge ID", VR.kSH, VM.k1, false);
  static const DED kWedgeAngle
      //(300A,00D5)
      = const DED("WedgeAngle", 0x300A00D5, "Wedge Angle", VR.kIS, VM.k1, false);
  static const DED kWedgeFactor
      //(300A,00D6)
      = const DED("WedgeFactor", 0x300A00D6, "Wedge Factor", VR.kDS, VM.k1, false);
  static const DED kTotalWedgeTrayWaterEquivalentThickness
      //(300A,00D7)
      = const DED("TotalWedgeTrayWaterEquivalentThickness", 0x300A00D7,
          "Total Wedge Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kWedgeOrientation
      //(300A,00D8)
      = const DED("WedgeOrientation", 0x300A00D8, "Wedge Orientation", VR.kDS, VM.k1, false);
  static const DED kIsocenterToWedgeTrayDistance
      //(300A,00D9)
      = const DED("IsocenterToWedgeTrayDistance", 0x300A00D9,
          "Isocenter to Wedge Tray Distance", VR.kFL, VM.k1, false);
  static const DED kSourceToWedgeTrayDistance
      //(300A,00DA)
      = const DED("SourceToWedgeTrayDistance", 0x300A00DA, "Source to Wedge Tray Distance",
          VR.kDS, VM.k1, false);
  static const DED kWedgeThinEdgePosition
      //(300A,00DB)
      = const DED(
          "WedgeThinEdgePosition", 0x300A00DB, "Wedge Thin Edge Position", VR.kFL, VM.k1, false);
  static const DED kBolusID
      //(300A,00DC)
      = const DED("BolusID", 0x300A00DC, "Bolus ID", VR.kSH, VM.k1, false);
  static const DED kBolusDescription
      //(300A,00DD)
      = const DED("BolusDescription", 0x300A00DD, "Bolus Description", VR.kST, VM.k1, false);
  static const DED kNumberOfCompensators
      //(300A,00E0)
      = const DED(
          "NumberOfCompensators", 0x300A00E0, "Number of Compensators", VR.kIS, VM.k1, false);
  static const DED kMaterialID
      //(300A,00E1)
      = const DED("MaterialID", 0x300A00E1, "Material ID", VR.kSH, VM.k1, false);
  static const DED kTotalCompensatorTrayFactor
      //(300A,00E2)
      = const DED("TotalCompensatorTrayFactor", 0x300A00E2, "Total Compensator Tray Factor",
          VR.kDS, VM.k1, false);
  static const DED kCompensatorSequence
      //(300A,00E3)
      = const DED(
          "CompensatorSequence", 0x300A00E3, "Compensator Sequence", VR.kSQ, VM.k1, false);
  static const DED kCompensatorNumber
      //(300A,00E4)
      = const DED("CompensatorNumber", 0x300A00E4, "Compensator Number", VR.kIS, VM.k1, false);
  static const DED kCompensatorID
      //(300A,00E5)
      = const DED("CompensatorID", 0x300A00E5, "Compensator ID", VR.kSH, VM.k1, false);
  static const DED kSourceToCompensatorTrayDistance
      //(300A,00E6)
      = const DED("SourceToCompensatorTrayDistance", 0x300A00E6,
          "Source to Compensator Tray Distance", VR.kDS, VM.k1, false);
  static const DED kCompensatorRows
      //(300A,00E7)
      = const DED("CompensatorRows", 0x300A00E7, "Compensator Rows", VR.kIS, VM.k1, false);
  static const DED kCompensatorColumns
      //(300A,00E8)
      =
      const DED("CompensatorColumns", 0x300A00E8, "Compensator Columns", VR.kIS, VM.k1, false);
  static const DED kCompensatorPixelSpacing
      //(300A,00E9)
      = const DED(
          "CompensatorPixelSpacing", 0x300A00E9, "Compensator Pixel Spacing", VR.kDS, VM.k2, false);
  static const DED kCompensatorPosition
      //(300A,00EA)
      = const DED(
          "CompensatorPosition", 0x300A00EA, "Compensator Position", VR.kDS, VM.k2, false);
  static const DED kCompensatorTransmissionData
      //(300A,00EB)
      = const DED("CompensatorTransmissionData", 0x300A00EB, "Compensator Transmission Data",
          VR.kDS, VM.k1_n, false);
  static const DED kCompensatorThicknessData
      //(300A,00EC)
      = const DED("CompensatorThicknessData", 0x300A00EC, "Compensator Thickness Data", VR.kDS,
          VM.k1_n, false);
  static const DED kNumberOfBoli
      //(300A,00ED)
      = const DED("NumberOfBoli", 0x300A00ED, "Number of Boli", VR.kIS, VM.k1, false);
  static const DED kCompensatorType
      //(300A,00EE)
      = const DED("CompensatorType", 0x300A00EE, "Compensator Type", VR.kCS, VM.k1, false);
  static const DED kCompensatorTrayID
      //(300A,00EF)
      = const DED("CompensatorTrayID", 0x300A00EF, "Compensator Tray ID", VR.kSH, VM.k1, false);
  static const DED kNumberOfBlocks
      //(300A,00F0)
      = const DED("NumberOfBlocks", 0x300A00F0, "Number of Blocks", VR.kIS, VM.k1, false);
  static const DED kTotalBlockTrayFactor
      //(300A,00F2)
      = const DED(
          "TotalBlockTrayFactor", 0x300A00F2, "Total Block Tray Factor", VR.kDS, VM.k1, false);
  static const DED kTotalBlockTrayWaterEquivalentThickness
      //(300A,00F3)
      = const DED("TotalBlockTrayWaterEquivalentThickness", 0x300A00F3,
          "Total Block Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kBlockSequence
      //(300A,00F4)
      = const DED("BlockSequence", 0x300A00F4, "Block Sequence", VR.kSQ, VM.k1, false);
  static const DED kBlockTrayID
      //(300A,00F5)
      = const DED("BlockTrayID", 0x300A00F5, "Block Tray ID", VR.kSH, VM.k1, false);
  static const DED kSourceToBlockTrayDistance
      //(300A,00F6)
      = const DED("SourceToBlockTrayDistance", 0x300A00F6, "Source to Block Tray Distance",
          VR.kDS, VM.k1, false);
  static const DED kIsocenterToBlockTrayDistance
      //(300A,00F7)
      = const DED("IsocenterToBlockTrayDistance", 0x300A00F7,
          "Isocenter to Block Tray Distance", VR.kFL, VM.k1, false);
  static const DED kBlockType
      //(300A,00F8)
      = const DED("BlockType", 0x300A00F8, "Block Type", VR.kCS, VM.k1, false);
  static const DED kAccessoryCode
      //(300A,00F9)
      = const DED("AccessoryCode", 0x300A00F9, "Accessory Code", VR.kLO, VM.k1, false);
  static const DED kBlockDivergence
      //(300A,00FA)
      = const DED("BlockDivergence", 0x300A00FA, "Block Divergence", VR.kCS, VM.k1, false);
  static const DED kBlockMountingPosition
      //(300A,00FB)
      = const DED(
          "BlockMountingPosition", 0x300A00FB, "Block Mounting Position", VR.kCS, VM.k1, false);
  static const DED kBlockNumber
      //(300A,00FC)
      = const DED("BlockNumber", 0x300A00FC, "Block Number", VR.kIS, VM.k1, false);
  static const DED kBlockName
      //(300A,00FE)
      = const DED("BlockName", 0x300A00FE, "Block Name", VR.kLO, VM.k1, false);
  static const DED kBlockThickness
      //(300A,0100)
      = const DED("BlockThickness", 0x300A0100, "Block Thickness", VR.kDS, VM.k1, false);
  static const DED kBlockTransmission
      //(300A,0102)
      = const DED("BlockTransmission", 0x300A0102, "Block Transmission", VR.kDS, VM.k1, false);
  static const DED kBlockNumberOfPoints
      //(300A,0104)
      = const DED(
          "BlockNumberOfPoints", 0x300A0104, "Block Number of Points", VR.kIS, VM.k1, false);
  static const DED kBlockData
      //(300A,0106)
      = const DED("BlockData", 0x300A0106, "Block Data", VR.kDS, VM.k2_2n, false);
  static const DED kApplicatorSequence
      //(300A,0107)
      =
      const DED("ApplicatorSequence", 0x300A0107, "Applicator Sequence", VR.kSQ, VM.k1, false);
  static const DED kApplicatorID
      //(300A,0108)
      = const DED("ApplicatorID", 0x300A0108, "Applicator ID", VR.kSH, VM.k1, false);
  static const DED kApplicatorType
      //(300A,0109)
      = const DED("ApplicatorType", 0x300A0109, "Applicator Type", VR.kCS, VM.k1, false);
  static const DED kApplicatorDescription
      //(300A,010A)
      = const DED(
          "ApplicatorDescription", 0x300A010A, "Applicator Description", VR.kLO, VM.k1, false);
  static const DED kCumulativeDoseReferenceCoefficient
      //(300A,010C)
      = const DED("CumulativeDoseReferenceCoefficient", 0x300A010C,
          "Cumulative Dose Reference Coefficient", VR.kDS, VM.k1, false);
  static const DED kFinalCumulativeMetersetWeight
      //(300A,010E)
      = const DED("FinalCumulativeMetersetWeight", 0x300A010E,
          "Final Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const DED kNumberOfControlPoints
      //(300A,0110)
      = const DED(
          "NumberOfControlPoints", 0x300A0110, "Number of Control Points", VR.kIS, VM.k1, false);
  static const DED kControlPointSequence
      //(300A,0111)
      = const DED(
          "ControlPointSequence", 0x300A0111, "Control Point Sequence", VR.kSQ, VM.k1, false);
  static const DED kControlPointIndex
      //(300A,0112)
      = const DED("ControlPointIndex", 0x300A0112, "Control Point Index", VR.kIS, VM.k1, false);
  static const DED kNominalBeamEnergy
      //(300A,0114)
      = const DED("NominalBeamEnergy", 0x300A0114, "Nominal Beam Energy", VR.kDS, VM.k1, false);
  static const DED kDoseRateSet
      //(300A,0115)
      = const DED("DoseRateSet", 0x300A0115, "Dose Rate Set", VR.kDS, VM.k1, false);
  static const DED kWedgePositionSequence
      //(300A,0116)
      = const DED(
          "WedgePositionSequence", 0x300A0116, "Wedge Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kWedgePosition
      //(300A,0118)
      = const DED("WedgePosition", 0x300A0118, "Wedge Position", VR.kCS, VM.k1, false);
  static const DED kBeamLimitingDevicePositionSequence
      //(300A,011A)
      = const DED("BeamLimitingDevicePositionSequence", 0x300A011A,
          "Beam Limiting Device Position Sequence", VR.kSQ, VM.k1, false);
  static const DED kLeafJawPositions
      //(300A,011C)
      =
      const DED("LeafJawPositions", 0x300A011C, "Leaf/Jaw Positions", VR.kDS, VM.k2_2n, false);
  static const DED kGantryAngle
      //(300A,011E)
      = const DED("GantryAngle", 0x300A011E, "Gantry Angle", VR.kDS, VM.k1, false);
  static const DED kGantryRotationDirection
      //(300A,011F)
      = const DED(
          "GantryRotationDirection", 0x300A011F, "Gantry Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kBeamLimitingDeviceAngle
      //(300A,0120)
      = const DED("BeamLimitingDeviceAngle", 0x300A0120, "Beam Limiting Device Angle", VR.kDS,
          VM.k1, false);
  static const DED kBeamLimitingDeviceRotationDirection
      //(300A,0121)
      = const DED("BeamLimitingDeviceRotationDirection", 0x300A0121,
          "Beam Limiting Device Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kPatientSupportAngle
      //(300A,0122)
      = const DED(
          "PatientSupportAngle", 0x300A0122, "Patient Support Angle", VR.kDS, VM.k1, false);
  static const DED kPatientSupportRotationDirection
      //(300A,0123)
      = const DED("PatientSupportRotationDirection", 0x300A0123,
          "Patient Support Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kTableTopEccentricAxisDistance
      //(300A,0124)
      = const DED("TableTopEccentricAxisDistance", 0x300A0124,
          "Table Top Eccentric Axis Distance", VR.kDS, VM.k1, false);
  static const DED kTableTopEccentricAngle
      //(300A,0125)
      = const DED(
          "TableTopEccentricAngle", 0x300A0125, "Table Top Eccentric Angle", VR.kDS, VM.k1, false);
  static const DED kTableTopEccentricRotationDirection
      //(300A,0126)
      = const DED("TableTopEccentricRotationDirection", 0x300A0126,
          "Table Top Eccentric Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kTableTopVerticalPosition
      //(300A,0128)
      = const DED("TableTopVerticalPosition", 0x300A0128, "Table Top Vertical Position", VR.kDS,
          VM.k1, false);
  static const DED kTableTopLongitudinalPosition
      //(300A,0129)
      = const DED("TableTopLongitudinalPosition", 0x300A0129, "Table Top Longitudinal Position",
          VR.kDS, VM.k1, false);
  static const DED kTableTopLateralPosition
      //(300A,012A)
      = const DED("TableTopLateralPosition", 0x300A012A, "Table Top Lateral Position", VR.kDS,
          VM.k1, false);
  static const DED kIsocenterPosition
      //(300A,012C)
      = const DED("IsocenterPosition", 0x300A012C, "Isocenter Position", VR.kDS, VM.k3, false);
  static const DED kSurfaceEntryPoint
      //(300A,012E)
      = const DED("SurfaceEntryPoint", 0x300A012E, "Surface Entry Point", VR.kDS, VM.k3, false);
  static const DED kSourceToSurfaceDistance
      //(300A,0130)
      = const DED("SourceToSurfaceDistance", 0x300A0130, "Source to Surface Distance", VR.kDS,
          VM.k1, false);
  static const DED kCumulativeMetersetWeight
      //(300A,0134)
      = const DED("CumulativeMetersetWeight", 0x300A0134, "Cumulative Meterset Weight", VR.kDS,
          VM.k1, false);
  static const DED kTableTopPitchAngle
      //(300A,0140)
      = const DED(
          "TableTopPitchAngle", 0x300A0140, "Table Top Pitch Angle", VR.kFL, VM.k1, false);
  static const DED kTableTopPitchRotationDirection
      //(300A,0142)
      = const DED("TableTopPitchRotationDirection", 0x300A0142,
          "Table Top Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kTableTopRollAngle
      //(300A,0144)
      =
      const DED("TableTopRollAngle", 0x300A0144, "Table Top Roll Angle", VR.kFL, VM.k1, false);
  static const DED kTableTopRollRotationDirection
      //(300A,0146)
      = const DED("TableTopRollRotationDirection", 0x300A0146,
          "Table Top Roll Rotation Direction", VR.kCS, VM.k1, false);
  static const DED kHeadFixationAngle
      //(300A,0148)
      = const DED("HeadFixationAngle", 0x300A0148, "Head Fixation Angle", VR.kFL, VM.k1, false);
  static const DED kGantryPitchAngle
      //(300A,014A)
      = const DED("GantryPitchAngle", 0x300A014A, "Gantry Pitch Angle", VR.kFL, VM.k1, false);
  static const DED kGantryPitchRotationDirection
      //(300A,014C)
      = const DED("GantryPitchRotationDirection", 0x300A014C, "Gantry Pitch Rotation Direction",
          VR.kCS, VM.k1, false);
  static const DED kGantryPitchAngleTolerance
      //(300A,014E)
      = const DED("GantryPitchAngleTolerance", 0x300A014E, "Gantry Pitch Angle Tolerance",
          VR.kFL, VM.k1, false);
  static const DED kPatientSetupSequence
      //(300A,0180)
      = const DED(
          "PatientSetupSequence", 0x300A0180, "Patient Setup Sequence", VR.kSQ, VM.k1, false);
  static const DED kPatientSetupNumber
      //(300A,0182)
      =
      const DED("PatientSetupNumber", 0x300A0182, "Patient Setup Number", VR.kIS, VM.k1, false);
  static const DED kPatientSetupLabel
      //(300A,0183)
      = const DED("PatientSetupLabel", 0x300A0183, "Patient Setup Label", VR.kLO, VM.k1, false);
  static const DED kPatientAdditionalPosition
      //(300A,0184)
      = const DED("PatientAdditionalPosition", 0x300A0184, "Patient Additional Position",
          VR.kLO, VM.k1, false);
  static const DED kFixationDeviceSequence
      //(300A,0190)
      = const DED(
          "FixationDeviceSequence", 0x300A0190, "Fixation Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kFixationDeviceType
      //(300A,0192)
      =
      const DED("FixationDeviceType", 0x300A0192, "Fixation Device Type", VR.kCS, VM.k1, false);
  static const DED kFixationDeviceLabel
      //(300A,0194)
      = const DED(
          "FixationDeviceLabel", 0x300A0194, "Fixation Device Label", VR.kSH, VM.k1, false);
  static const DED kFixationDeviceDescription
      //(300A,0196)
      = const DED("FixationDeviceDescription", 0x300A0196, "Fixation Device Description",
          VR.kST, VM.k1, false);
  static const DED kFixationDevicePosition
      //(300A,0198)
      = const DED(
          "FixationDevicePosition", 0x300A0198, "Fixation Device Position", VR.kSH, VM.k1, false);
  static const DED kFixationDevicePitchAngle
      //(300A,0199)
      = const DED("FixationDevicePitchAngle", 0x300A0199, "Fixation Device Pitch Angle", VR.kFL,
          VM.k1, false);
  static const DED kFixationDeviceRollAngle
      //(300A,019A)
      = const DED("FixationDeviceRollAngle", 0x300A019A, "Fixation Device Roll Angle", VR.kFL,
          VM.k1, false);
  static const DED kShieldingDeviceSequence
      //(300A,01A0)
      = const DED(
          "ShieldingDeviceSequence", 0x300A01A0, "Shielding Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kShieldingDeviceType
      //(300A,01A2)
      = const DED(
          "ShieldingDeviceType", 0x300A01A2, "Shielding Device Type", VR.kCS, VM.k1, false);
  static const DED kShieldingDeviceLabel
      //(300A,01A4)
      = const DED(
          "ShieldingDeviceLabel", 0x300A01A4, "Shielding Device Label", VR.kSH, VM.k1, false);
  static const DED kShieldingDeviceDescription
      //(300A,01A6)
      = const DED("ShieldingDeviceDescription", 0x300A01A6, "Shielding Device Description",
          VR.kST, VM.k1, false);
  static const DED kShieldingDevicePosition
      //(300A,01A8)
      = const DED(
          "ShieldingDevicePosition", 0x300A01A8, "Shielding Device Position", VR.kSH, VM.k1, false);
  static const DED kSetupTechnique
      //(300A,01B0)
      = const DED("SetupTechnique", 0x300A01B0, "Setup Technique", VR.kCS, VM.k1, false);
  static const DED kSetupTechniqueDescription
      //(300A,01B2)
      = const DED("SetupTechniqueDescription", 0x300A01B2, "Setup Technique Description",
          VR.kST, VM.k1, false);
  static const DED kSetupDeviceSequence
      //(300A,01B4)
      = const DED(
          "SetupDeviceSequence", 0x300A01B4, "Setup Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kSetupDeviceType
      //(300A,01B6)
      = const DED("SetupDeviceType", 0x300A01B6, "Setup Device Type", VR.kCS, VM.k1, false);
  static const DED kSetupDeviceLabel
      //(300A,01B8)
      = const DED("SetupDeviceLabel", 0x300A01B8, "Setup Device Label", VR.kSH, VM.k1, false);
  static const DED kSetupDeviceDescription
      //(300A,01BA)
      = const DED(
          "SetupDeviceDescription", 0x300A01BA, "Setup Device Description", VR.kST, VM.k1, false);
  static const DED kSetupDeviceParameter
      //(300A,01BC)
      = const DED(
          "SetupDeviceParameter", 0x300A01BC, "Setup Device Parameter", VR.kDS, VM.k1, false);
  static const DED kSetupReferenceDescription
      //(300A,01D0)
      = const DED("SetupReferenceDescription", 0x300A01D0, "Setup Reference Description",
          VR.kST, VM.k1, false);
  static const DED kTableTopVerticalSetupDisplacement
      //(300A,01D2)
      = const DED("TableTopVerticalSetupDisplacement", 0x300A01D2,
          "Table Top Vertical Setup Displacement", VR.kDS, VM.k1, false);
  static const DED kTableTopLongitudinalSetupDisplacement
      //(300A,01D4)
      = const DED("TableTopLongitudinalSetupDisplacement", 0x300A01D4,
          "Table Top Longitudinal Setup Displacement", VR.kDS, VM.k1, false);
  static const DED kTableTopLateralSetupDisplacement
      //(300A,01D6)
      = const DED("TableTopLateralSetupDisplacement", 0x300A01D6,
          "Table Top Lateral Setup Displacement", VR.kDS, VM.k1, false);
  static const DED kBrachyTreatmentTechnique
      //(300A,0200)
      = const DED("BrachyTreatmentTechnique", 0x300A0200, "Brachy Treatment Technique", VR.kCS,
          VM.k1, false);
  static const DED kBrachyTreatmentType
      //(300A,0202)
      = const DED(
          "BrachyTreatmentType", 0x300A0202, "Brachy Treatment Type", VR.kCS, VM.k1, false);
  static const DED kTreatmentMachineSequence
      //(300A,0206)
      = const DED("TreatmentMachineSequence", 0x300A0206, "Treatment Machine Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kSourceSequence
      //(300A,0210)
      = const DED("SourceSequence", 0x300A0210, "Source Sequence", VR.kSQ, VM.k1, false);
  static const DED kSourceNumber
      //(300A,0212)
      = const DED("SourceNumber", 0x300A0212, "Source Number", VR.kIS, VM.k1, false);
  static const DED kSourceType
      //(300A,0214)
      = const DED("SourceType", 0x300A0214, "Source Type", VR.kCS, VM.k1, false);
  static const DED kSourceManufacturer
      //(300A,0216)
      =
      const DED("SourceManufacturer", 0x300A0216, "Source Manufacturer", VR.kLO, VM.k1, false);
  static const DED kActiveSourceDiameter
      //(300A,0218)
      = const DED(
          "ActiveSourceDiameter", 0x300A0218, "Active Source Diameter", VR.kDS, VM.k1, false);
  static const DED kActiveSourceLength
      //(300A,021A)
      =
      const DED("ActiveSourceLength", 0x300A021A, "Active Source Length", VR.kDS, VM.k1, false);
  static const DED kSourceModelID
      //(300A,021B)
      = const DED("SourceModelID", 0x300A021B, "Source Model ID", VR.kSH, VM.k1, false);
  static const DED kSourceDescription
      //(300A,021C)
      = const DED("SourceDescription", 0x300A021C, "Source Description", VR.kLO, VM.k1, false);
  static const DED kSourceEncapsulationNominalThickness
      //(300A,0222)
      = const DED("SourceEncapsulationNominalThickness", 0x300A0222,
          "Source Encapsulation Nominal Thickness", VR.kDS, VM.k1, false);
  static const DED kSourceEncapsulationNominalTransmission
      //(300A,0224)
      = const DED("SourceEncapsulationNominalTransmission", 0x300A0224,
          "Source Encapsulation Nominal Transmission", VR.kDS, VM.k1, false);
  static const DED kSourceIsotopeName
      //(300A,0226)
      = const DED("SourceIsotopeName", 0x300A0226, "Source Isotope Name", VR.kLO, VM.k1, false);
  static const DED kSourceIsotopeHalfLife
      //(300A,0228)
      = const DED(
          "SourceIsotopeHalfLife", 0x300A0228, "Source Isotope Half Life", VR.kDS, VM.k1, false);
  static const DED kSourceStrengthUnits
      //(300A,0229)
      = const DED(
          "SourceStrengthUnits", 0x300A0229, "Source Strength Units", VR.kCS, VM.k1, false);
  static const DED kReferenceAirKermaRate
      //(300A,022A)
      = const DED(
          "ReferenceAirKermaRate", 0x300A022A, "Reference Air Kerma Rate", VR.kDS, VM.k1, false);
  static const DED kSourceStrength
      //(300A,022B)
      = const DED("SourceStrength", 0x300A022B, "Source Strength", VR.kDS, VM.k1, false);
  static const DED kSourceStrengthReferenceDate
      //(300A,022C)
      = const DED("SourceStrengthReferenceDate", 0x300A022C, "Source Strength Reference Date",
          VR.kDA, VM.k1, false);
  static const DED kSourceStrengthReferenceTime
      //(300A,022E)
      = const DED("SourceStrengthReferenceTime", 0x300A022E, "Source Strength Reference Time",
          VR.kTM, VM.k1, false);
  static const DED kApplicationSetupSequence
      //(300A,0230)
      = const DED("ApplicationSetupSequence", 0x300A0230, "Application Setup Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kApplicationSetupType
      //(300A,0232)
      = const DED(
          "ApplicationSetupType", 0x300A0232, "Application Setup Type", VR.kCS, VM.k1, false);
  static const DED kApplicationSetupNumber
      //(300A,0234)
      = const DED(
          "ApplicationSetupNumber", 0x300A0234, "Application Setup Number", VR.kIS, VM.k1, false);
  static const DED kApplicationSetupName
      //(300A,0236)
      = const DED(
          "ApplicationSetupName", 0x300A0236, "Application Setup Name", VR.kLO, VM.k1, false);
  static const DED kApplicationSetupManufacturer
      //(300A,0238)
      = const DED("ApplicationSetupManufacturer", 0x300A0238, "Application Setup Manufacturer",
          VR.kLO, VM.k1, false);
  static const DED kTemplateNumber
      //(300A,0240)
      = const DED("TemplateNumber", 0x300A0240, "Template Number", VR.kIS, VM.k1, false);
  static const DED kTemplateType
      //(300A,0242)
      = const DED("TemplateType", 0x300A0242, "Template Type", VR.kSH, VM.k1, false);
  static const DED kTemplateName
      //(300A,0244)
      = const DED("TemplateName", 0x300A0244, "Template Name", VR.kLO, VM.k1, false);
  static const DED kTotalReferenceAirKerma
      //(300A,0250)
      = const DED(
          "TotalReferenceAirKerma", 0x300A0250, "Total Reference Air Kerma", VR.kDS, VM.k1, false);
  static const DED kBrachyAccessoryDeviceSequence
      //(300A,0260)
      = const DED("BrachyAccessoryDeviceSequence", 0x300A0260,
          "Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kBrachyAccessoryDeviceNumber
      //(300A,0262)
      = const DED("BrachyAccessoryDeviceNumber", 0x300A0262, "Brachy Accessory Device Number",
          VR.kIS, VM.k1, false);
  static const DED kBrachyAccessoryDeviceID
      //(300A,0263)
      = const DED("BrachyAccessoryDeviceID", 0x300A0263, "Brachy Accessory Device ID", VR.kSH,
          VM.k1, false);
  static const DED kBrachyAccessoryDeviceType
      //(300A,0264)
      = const DED("BrachyAccessoryDeviceType", 0x300A0264, "Brachy Accessory Device Type",
          VR.kCS, VM.k1, false);
  static const DED kBrachyAccessoryDeviceName
      //(300A,0266)
      = const DED("BrachyAccessoryDeviceName", 0x300A0266, "Brachy Accessory Device Name",
          VR.kLO, VM.k1, false);
  static const DED kBrachyAccessoryDeviceNominalThickness
      //(300A,026A)
      = const DED("BrachyAccessoryDeviceNominalThickness", 0x300A026A,
          "Brachy Accessory Device Nominal Thickness", VR.kDS, VM.k1, false);
  static const DED kBrachyAccessoryDeviceNominalTransmission
      //(300A,026C)
      = const DED("BrachyAccessoryDeviceNominalTransmission", 0x300A026C,
          "Brachy Accessory Device Nominal Transmission", VR.kDS, VM.k1, false);
  static const DED kChannelSequence
      //(300A,0280)
      = const DED("ChannelSequence", 0x300A0280, "Channel Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelNumber
      //(300A,0282)
      = const DED("ChannelNumber", 0x300A0282, "Channel Number", VR.kIS, VM.k1, false);
  static const DED kChannelLength
      //(300A,0284)
      = const DED("ChannelLength", 0x300A0284, "Channel Length", VR.kDS, VM.k1, false);
  static const DED kChannelTotalTime
      //(300A,0286)
      = const DED("ChannelTotalTime", 0x300A0286, "Channel Total Time", VR.kDS, VM.k1, false);
  static const DED kSourceMovementType
      //(300A,0288)
      =
      const DED("SourceMovementType", 0x300A0288, "Source Movement Type", VR.kCS, VM.k1, false);
  static const DED kNumberOfPulses
      //(300A,028A)
      = const DED("NumberOfPulses", 0x300A028A, "Number of Pulses", VR.kIS, VM.k1, false);
  static const DED kPulseRepetitionInterval
      //(300A,028C)
      = const DED(
          "PulseRepetitionInterval", 0x300A028C, "Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const DED kSourceApplicatorNumber
      //(300A,0290)
      = const DED(
          "SourceApplicatorNumber", 0x300A0290, "Source Applicator Number", VR.kIS, VM.k1, false);
  static const DED kSourceApplicatorID
      //(300A,0291)
      =
      const DED("SourceApplicatorID", 0x300A0291, "Source Applicator ID", VR.kSH, VM.k1, false);
  static const DED kSourceApplicatorType
      //(300A,0292)
      = const DED(
          "SourceApplicatorType", 0x300A0292, "Source Applicator Type", VR.kCS, VM.k1, false);
  static const DED kSourceApplicatorName
      //(300A,0294)
      = const DED(
          "SourceApplicatorName", 0x300A0294, "Source Applicator Name", VR.kLO, VM.k1, false);
  static const DED kSourceApplicatorLength
      //(300A,0296)
      = const DED(
          "SourceApplicatorLength", 0x300A0296, "Source Applicator Length", VR.kDS, VM.k1, false);
  static const DED kSourceApplicatorManufacturer
      //(300A,0298)
      = const DED("SourceApplicatorManufacturer", 0x300A0298, "Source Applicator Manufacturer",
          VR.kLO, VM.k1, false);
  static const DED kSourceApplicatorWallNominalThickness
      //(300A,029C)
      = const DED("SourceApplicatorWallNominalThickness", 0x300A029C,
          "Source Applicator Wall Nominal Thickness", VR.kDS, VM.k1, false);
  static const DED kSourceApplicatorWallNominalTransmission
      //(300A,029E)
      = const DED("SourceApplicatorWallNominalTransmission", 0x300A029E,
          "Source Applicator Wall Nominal Transmission", VR.kDS, VM.k1, false);
  static const DED kSourceApplicatorStepSize
      //(300A,02A0)
      = const DED("SourceApplicatorStepSize", 0x300A02A0, "Source Applicator Step Size", VR.kDS,
          VM.k1, false);
  static const DED kTransferTubeNumber
      //(300A,02A2)
      =
      const DED("TransferTubeNumber", 0x300A02A2, "Transfer Tube Number", VR.kIS, VM.k1, false);
  static const DED kTransferTubeLength
      //(300A,02A4)
      =
      const DED("TransferTubeLength", 0x300A02A4, "Transfer Tube Length", VR.kDS, VM.k1, false);
  static const DED kChannelShieldSequence
      //(300A,02B0)
      = const DED(
          "ChannelShieldSequence", 0x300A02B0, "Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelShieldNumber
      //(300A,02B2)
      = const DED(
          "ChannelShieldNumber", 0x300A02B2, "Channel Shield Number", VR.kIS, VM.k1, false);
  static const DED kChannelShieldID
      //(300A,02B3)
      = const DED("ChannelShieldID", 0x300A02B3, "Channel Shield ID", VR.kSH, VM.k1, false);
  static const DED kChannelShieldName
      //(300A,02B4)
      = const DED("ChannelShieldName", 0x300A02B4, "Channel Shield Name", VR.kLO, VM.k1, false);
  static const DED kChannelShieldNominalThickness
      //(300A,02B8)
      = const DED("ChannelShieldNominalThickness", 0x300A02B8,
          "Channel Shield Nominal Thickness", VR.kDS, VM.k1, false);
  static const DED kChannelShieldNominalTransmission
      //(300A,02BA)
      = const DED("ChannelShieldNominalTransmission", 0x300A02BA,
          "Channel Shield Nominal Transmission", VR.kDS, VM.k1, false);
  static const DED kFinalCumulativeTimeWeight
      //(300A,02C8)
      = const DED("FinalCumulativeTimeWeight", 0x300A02C8, "Final Cumulative Time Weight",
          VR.kDS, VM.k1, false);
  static const DED kBrachyControlPointSequence
      //(300A,02D0)
      = const DED("BrachyControlPointSequence", 0x300A02D0, "Brachy Control Point Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kControlPointRelativePosition
      //(300A,02D2)
      = const DED("ControlPointRelativePosition", 0x300A02D2, "Control Point Relative Position",
          VR.kDS, VM.k1, false);
  static const DED kControlPoint3DPosition
      //(300A,02D4)
      = const DED(
          "ControlPoint3DPosition", 0x300A02D4, "Control Point 3D Position", VR.kDS, VM.k3, false);
  static const DED kCumulativeTimeWeight
      //(300A,02D6)
      = const DED(
          "CumulativeTimeWeight", 0x300A02D6, "Cumulative Time Weight", VR.kDS, VM.k1, false);
  static const DED kCompensatorDivergence
      //(300A,02E0)
      = const DED(
          "CompensatorDivergence", 0x300A02E0, "Compensator Divergence", VR.kCS, VM.k1, false);
  static const DED kCompensatorMountingPosition
      //(300A,02E1)
      = const DED("CompensatorMountingPosition", 0x300A02E1, "Compensator Mounting Position",
          VR.kCS, VM.k1, false);
  static const DED kSourceToCompensatorDistance
      //(300A,02E2)
      = const DED("SourceToCompensatorDistance", 0x300A02E2, "Source to Compensator Distance",
          VR.kDS, VM.k1_n, false);
  static const DED kTotalCompensatorTrayWaterEquivalentThickness
      //(300A,02E3)
      = const DED("TotalCompensatorTrayWaterEquivalentThickness", 0x300A02E3,
          "Total Compensator Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kIsocenterToCompensatorTrayDistance
      //(300A,02E4)
      = const DED("IsocenterToCompensatorTrayDistance", 0x300A02E4,
          "Isocenter to Compensator Tray Distance", VR.kFL, VM.k1, false);
  static const DED kCompensatorColumnOffset
      //(300A,02E5)
      = const DED(
          "CompensatorColumnOffset", 0x300A02E5, "Compensator Column Offset", VR.kFL, VM.k1, false);
  static const DED kIsocenterToCompensatorDistances
      //(300A,02E6)
      = const DED("IsocenterToCompensatorDistances", 0x300A02E6,
          "Isocenter to Compensator Distances", VR.kFL, VM.k1_n, false);
  static const DED kCompensatorRelativeStoppingPowerRatio
      //(300A,02E7)
      = const DED("CompensatorRelativeStoppingPowerRatio", 0x300A02E7,
          "Compensator Relative Stopping Power Ratio", VR.kFL, VM.k1, false);
  static const DED kCompensatorMillingToolDiameter
      //(300A,02E8)
      = const DED("CompensatorMillingToolDiameter", 0x300A02E8,
          "Compensator Milling Tool Diameter", VR.kFL, VM.k1, false);
  static const DED kIonRangeCompensatorSequence
      //(300A,02EA)
      = const DED("IonRangeCompensatorSequence", 0x300A02EA, "Ion Range Compensator Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kCompensatorDescription
      //(300A,02EB)
      = const DED(
          "CompensatorDescription", 0x300A02EB, "Compensator Description", VR.kLT, VM.k1, false);
  static const DED kRadiationMassNumber
      //(300A,0302)
      = const DED(
          "RadiationMassNumber", 0x300A0302, "Radiation Mass Number", VR.kIS, VM.k1, false);
  static const DED kRadiationAtomicNumber
      //(300A,0304)
      = const DED(
          "RadiationAtomicNumber", 0x300A0304, "Radiation Atomic Number", VR.kIS, VM.k1, false);
  static const DED kRadiationChargeState
      //(300A,0306)
      = const DED(
          "RadiationChargeState", 0x300A0306, "Radiation Charge State", VR.kSS, VM.k1, false);
  static const DED kScanMode
      //(300A,0308)
      = const DED("ScanMode", 0x300A0308, "Scan Mode", VR.kCS, VM.k1, false);
  static const DED kVirtualSourceAxisDistances
      //(300A,030A)
      = const DED("VirtualSourceAxisDistances", 0x300A030A, "Virtual Source-Axis Distances",
          VR.kFL, VM.k2, false);
  static const DED kSnoutSequence
      //(300A,030C)
      = const DED("SnoutSequence", 0x300A030C, "Snout Sequence", VR.kSQ, VM.k1, false);
  static const DED kSnoutPosition
      //(300A,030D)
      = const DED("SnoutPosition", 0x300A030D, "Snout Position", VR.kFL, VM.k1, false);
  static const DED kSnoutID
      //(300A,030F)
      = const DED("SnoutID", 0x300A030F, "Snout ID", VR.kSH, VM.k1, false);
  static const DED kNumberOfRangeShifters
      //(300A,0312)
      = const DED(
          "NumberOfRangeShifters", 0x300A0312, "Number of Range Shifters", VR.kIS, VM.k1, false);
  static const DED kRangeShifterSequence
      //(300A,0314)
      = const DED(
          "RangeShifterSequence", 0x300A0314, "Range Shifter Sequence", VR.kSQ, VM.k1, false);
  static const DED kRangeShifterNumber
      //(300A,0316)
      =
      const DED("RangeShifterNumber", 0x300A0316, "Range Shifter Number", VR.kIS, VM.k1, false);
  static const DED kRangeShifterID
      //(300A,0318)
      = const DED("RangeShifterID", 0x300A0318, "Range Shifter ID", VR.kSH, VM.k1, false);
  static const DED kRangeShifterType
      //(300A,0320)
      = const DED("RangeShifterType", 0x300A0320, "Range Shifter Type", VR.kCS, VM.k1, false);
  static const DED kRangeShifterDescription
      //(300A,0322)
      = const DED(
          "RangeShifterDescription", 0x300A0322, "Range Shifter Description", VR.kLO, VM.k1, false);
  static const DED kNumberOfLateralSpreadingDevices
      //(300A,0330)
      = const DED("NumberOfLateralSpreadingDevices", 0x300A0330,
          "Number of Lateral Spreading Devices", VR.kIS, VM.k1, false);
  static const DED kLateralSpreadingDeviceSequence
      //(300A,0332)
      = const DED("LateralSpreadingDeviceSequence", 0x300A0332,
          "Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kLateralSpreadingDeviceNumber
      //(300A,0334)
      = const DED("LateralSpreadingDeviceNumber", 0x300A0334, "Lateral Spreading Device Number",
          VR.kIS, VM.k1, false);
  static const DED kLateralSpreadingDeviceID
      //(300A,0336)
      = const DED("LateralSpreadingDeviceID", 0x300A0336, "Lateral Spreading Device ID", VR.kSH,
          VM.k1, false);
  static const DED kLateralSpreadingDeviceType
      //(300A,0338)
      = const DED("LateralSpreadingDeviceType", 0x300A0338, "Lateral Spreading Device Type",
          VR.kCS, VM.k1, false);
  static const DED kLateralSpreadingDeviceDescription
      //(300A,033A)
      = const DED("LateralSpreadingDeviceDescription", 0x300A033A,
          "Lateral Spreading Device Description", VR.kLO, VM.k1, false);
  static const DED kLateralSpreadingDeviceWaterEquivalentThickness
      //(300A,033C)
      = const DED("LateralSpreadingDeviceWaterEquivalentThickness", 0x300A033C,
          "Lateral Spreading Device Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kNumberOfRangeModulators
      //(300A,0340)
      = const DED("NumberOfRangeModulators", 0x300A0340, "Number of Range Modulators", VR.kIS,
          VM.k1, false);
  static const DED kRangeModulatorSequence
      //(300A,0342)
      = const DED(
          "RangeModulatorSequence", 0x300A0342, "Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const DED kRangeModulatorNumber
      //(300A,0344)
      = const DED(
          "RangeModulatorNumber", 0x300A0344, "Range Modulator Number", VR.kIS, VM.k1, false);
  static const DED kRangeModulatorID
      //(300A,0346)
      = const DED("RangeModulatorID", 0x300A0346, "Range Modulator ID", VR.kSH, VM.k1, false);
  static const DED kRangeModulatorType
      //(300A,0348)
      =
      const DED("RangeModulatorType", 0x300A0348, "Range Modulator Type", VR.kCS, VM.k1, false);
  static const DED kRangeModulatorDescription
      //(300A,034A)
      = const DED("RangeModulatorDescription", 0x300A034A, "Range Modulator Description",
          VR.kLO, VM.k1, false);
  static const DED kBeamCurrentModulationID
      //(300A,034C)
      = const DED("BeamCurrentModulationID", 0x300A034C, "Beam Current Modulation ID", VR.kSH,
          VM.k1, false);
  static const DED kPatientSupportType
      //(300A,0350)
      =
      const DED("PatientSupportType", 0x300A0350, "Patient Support Type", VR.kCS, VM.k1, false);
  static const DED kPatientSupportID
      //(300A,0352)
      = const DED("PatientSupportID", 0x300A0352, "Patient Support ID", VR.kSH, VM.k1, false);
  static const DED kPatientSupportAccessoryCode
      //(300A,0354)
      = const DED("PatientSupportAccessoryCode", 0x300A0354, "Patient Support Accessory Code",
          VR.kLO, VM.k1, false);
  static const DED kFixationLightAzimuthalAngle
      //(300A,0356)
      = const DED("FixationLightAzimuthalAngle", 0x300A0356, "Fixation Light Azimuthal Angle",
          VR.kFL, VM.k1, false);
  static const DED kFixationLightPolarAngle
      //(300A,0358)
      = const DED("FixationLightPolarAngle", 0x300A0358, "Fixation Light Polar Angle", VR.kFL,
          VM.k1, false);
  static const DED kMetersetRate
      //(300A,035A)
      = const DED("MetersetRate", 0x300A035A, "Meterset Rate", VR.kFL, VM.k1, false);
  static const DED kRangeShifterSettingsSequence
      //(300A,0360)
      = const DED("RangeShifterSettingsSequence", 0x300A0360, "Range Shifter Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kRangeShifterSetting
      //(300A,0362)
      = const DED(
          "RangeShifterSetting", 0x300A0362, "Range Shifter Setting", VR.kLO, VM.k1, false);
  static const DED kIsocenterToRangeShifterDistance
      //(300A,0364)
      = const DED("IsocenterToRangeShifterDistance", 0x300A0364,
          "Isocenter to Range Shifter Distance", VR.kFL, VM.k1, false);
  static const DED kRangeShifterWaterEquivalentThickness
      //(300A,0366)
      = const DED("RangeShifterWaterEquivalentThickness", 0x300A0366,
          "Range Shifter Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kLateralSpreadingDeviceSettingsSequence
      //(300A,0370)
      = const DED("LateralSpreadingDeviceSettingsSequence", 0x300A0370,
          "Lateral Spreading Device Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kLateralSpreadingDeviceSetting
      //(300A,0372)
      = const DED("LateralSpreadingDeviceSetting", 0x300A0372,
          "Lateral Spreading Device Setting", VR.kLO, VM.k1, false);
  static const DED kIsocenterToLateralSpreadingDeviceDistance
      //(300A,0374)
      = const DED("IsocenterToLateralSpreadingDeviceDistance", 0x300A0374,
          "Isocenter to Lateral Spreading Device Distance", VR.kFL, VM.k1, false);
  static const DED kRangeModulatorSettingsSequence
      //(300A,0380)
      = const DED("RangeModulatorSettingsSequence", 0x300A0380,
          "Range Modulator Settings Sequence", VR.kSQ, VM.k1, false);
  static const DED kRangeModulatorGatingStartValue
      //(300A,0382)
      = const DED("RangeModulatorGatingStartValue", 0x300A0382,
          "Range Modulator Gating Start Value", VR.kFL, VM.k1, false);
  static const DED kRangeModulatorGatingStopValue
      //(300A,0384)
      = const DED("RangeModulatorGatingStopValue", 0x300A0384,
          "Range Modulator Gating Stop Value", VR.kFL, VM.k1, false);
  static const DED kRangeModulatorGatingStartWaterEquivalentThickness
      //(300A,0386)
      = const DED("RangeModulatorGatingStartWaterEquivalentThickness", 0x300A0386,
          "Range Modulator Gating Start Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kRangeModulatorGatingStopWaterEquivalentThickness
      //(300A,0388)
      = const DED("RangeModulatorGatingStopWaterEquivalentThickness", 0x300A0388,
          "Range Modulator Gating Stop Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const DED kIsocenterToRangeModulatorDistance
      //(300A,038A)
      = const DED("IsocenterToRangeModulatorDistance", 0x300A038A,
          "Isocenter to Range Modulator Distance", VR.kFL, VM.k1, false);
  static const DED kScanSpotTuneID
      //(300A,0390)
      = const DED("ScanSpotTuneID", 0x300A0390, "Scan Spot Tune ID", VR.kSH, VM.k1, false);
  static const DED kNumberOfScanSpotPositions
      //(300A,0392)
      = const DED("NumberOfScanSpotPositions", 0x300A0392, "Number of Scan Spot Positions",
          VR.kIS, VM.k1, false);
  static const DED kScanSpotPositionMap
      //(300A,0394)
      = const DED(
          "ScanSpotPositionMap", 0x300A0394, "Scan Spot Position Map", VR.kFL, VM.k1_n, false);
  static const DED kScanSpotMetersetWeights
      //(300A,0396)
      = const DED("ScanSpotMetersetWeights", 0x300A0396, "Scan Spot Meterset Weights", VR.kFL,
          VM.k1_n, false);
  static const DED kScanningSpotSize
      //(300A,0398)
      = const DED("ScanningSpotSize", 0x300A0398, "Scanning Spot Size", VR.kFL, VM.k2, false);
  static const DED kNumberOfPaintings
      //(300A,039A)
      = const DED("NumberOfPaintings", 0x300A039A, "Number of Paintings", VR.kIS, VM.k1, false);
  static const DED kIonToleranceTableSequence
      //(300A,03A0)
      = const DED("IonToleranceTableSequence", 0x300A03A0, "Ion Tolerance Table Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kIonBeamSequence
      //(300A,03A2)
      = const DED("IonBeamSequence", 0x300A03A2, "Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonBeamLimitingDeviceSequence
      //(300A,03A4)
      = const DED("IonBeamLimitingDeviceSequence", 0x300A03A4,
          "Ion Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonBlockSequence
      //(300A,03A6)
      = const DED("IonBlockSequence", 0x300A03A6, "Ion Block Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonControlPointSequence
      //(300A,03A8)
      = const DED("IonControlPointSequence", 0x300A03A8, "Ion Control Point Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kIonWedgeSequence
      //(300A,03AA)
      = const DED("IonWedgeSequence", 0x300A03AA, "Ion Wedge Sequence", VR.kSQ, VM.k1, false);
  static const DED kIonWedgePositionSequence
      //(300A,03AC)
      = const DED("IonWedgePositionSequence", 0x300A03AC, "Ion Wedge Position Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kReferencedSetupImageSequence
      //(300A,0401)
      = const DED("ReferencedSetupImageSequence", 0x300A0401, "Referenced Setup Image Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kSetupImageComment
      //(300A,0402)
      = const DED("SetupImageComment", 0x300A0402, "Setup Image Comment", VR.kST, VM.k1, false);
  static const DED kMotionSynchronizationSequence
      //(300A,0410)
      = const DED("MotionSynchronizationSequence", 0x300A0410,
          "Motion Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const DED kControlPointOrientation
      //(300A,0412)
      = const DED(
          "ControlPointOrientation", 0x300A0412, "Control Point Orientation", VR.kFL, VM.k3, false);
  static const DED kGeneralAccessorySequence
      //(300A,0420)
      = const DED("GeneralAccessorySequence", 0x300A0420, "General Accessory Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kGeneralAccessoryID
      //(300A,0421)
      =
      const DED("GeneralAccessoryID", 0x300A0421, "General Accessory ID", VR.kSH, VM.k1, false);
  static const DED kGeneralAccessoryDescription
      //(300A,0422)
      = const DED("GeneralAccessoryDescription", 0x300A0422, "General Accessory Description",
          VR.kST, VM.k1, false);
  static const DED kGeneralAccessoryType
      //(300A,0423)
      = const DED(
          "GeneralAccessoryType", 0x300A0423, "General Accessory Type", VR.kCS, VM.k1, false);
  static const DED kGeneralAccessoryNumber
      //(300A,0424)
      = const DED(
          "GeneralAccessoryNumber", 0x300A0424, "General Accessory Number", VR.kIS, VM.k1, false);
  static const DED kSourceToGeneralAccessoryDistance
      //(300A,0425)
      = const DED("SourceToGeneralAccessoryDistance", 0x300A0425,
          "Source to General Accessory Distance", VR.kFL, VM.k1, false);
  static const DED kApplicatorGeometrySequence
      //(300A,0431)
      = const DED("ApplicatorGeometrySequence", 0x300A0431, "Applicator Geometry Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kApplicatorApertureShape
      //(300A,0432)
      = const DED(
          "ApplicatorApertureShape", 0x300A0432, "Applicator Aperture Shape", VR.kCS, VM.k1, false);
  static const DED kApplicatorOpening
      //(300A,0433)
      = const DED("ApplicatorOpening", 0x300A0433, "Applicator Opening", VR.kFL, VM.k1, false);
  static const DED kApplicatorOpeningX
      //(300A,0434)
      =
      const DED("ApplicatorOpeningX", 0x300A0434, "Applicator Opening X", VR.kFL, VM.k1, false);
  static const DED kApplicatorOpeningY
      //(300A,0435)
      =
      const DED("ApplicatorOpeningY", 0x300A0435, "Applicator Opening Y", VR.kFL, VM.k1, false);
  static const DED kSourceToApplicatorMountingPositionDistance
      //(300A,0436)
      = const DED("SourceToApplicatorMountingPositionDistance", 0x300A0436,
          "Source to Applicator Mounting Position Distance", VR.kFL, VM.k1, false);
  static const DED kReferencedRTPlanSequence
      //(300C,0002)
      = const DED("ReferencedRTPlanSequence", 0x300C0002, "Referenced RT Plan Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kReferencedBeamSequence
      //(300C,0004)
      = const DED(
          "ReferencedBeamSequence", 0x300C0004, "Referenced Beam Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedBeamNumber
      //(300C,0006)
      = const DED(
          "ReferencedBeamNumber", 0x300C0006, "Referenced Beam Number", VR.kIS, VM.k1, false);
  static const DED kReferencedReferenceImageNumber
      //(300C,0007)
      = const DED("ReferencedReferenceImageNumber", 0x300C0007,
          "Referenced Reference Image Number", VR.kIS, VM.k1, false);
  static const DED kStartCumulativeMetersetWeight
      //(300C,0008)
      = const DED("StartCumulativeMetersetWeight", 0x300C0008,
          "Start Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const DED kEndCumulativeMetersetWeight
      //(300C,0009)
      = const DED("EndCumulativeMetersetWeight", 0x300C0009, "End Cumulative Meterset Weight",
          VR.kDS, VM.k1, false);
  static const DED kReferencedBrachyApplicationSetupSequence
      //(300C,000A)
      = const DED("ReferencedBrachyApplicationSetupSequence", 0x300C000A,
          "Referenced Brachy Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedBrachyApplicationSetupNumber
      //(300C,000C)
      = const DED("ReferencedBrachyApplicationSetupNumber", 0x300C000C,
          "Referenced Brachy Application Setup Number", VR.kIS, VM.k1, false);
  static const DED kReferencedSourceNumber
      //(300C,000E)
      = const DED(
          "ReferencedSourceNumber", 0x300C000E, "Referenced Source Number", VR.kIS, VM.k1, false);
  static const DED kReferencedFractionGroupSequence
      //(300C,0020)
      = const DED("ReferencedFractionGroupSequence", 0x300C0020,
          "Referenced Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedFractionGroupNumber
      //(300C,0022)
      = const DED("ReferencedFractionGroupNumber", 0x300C0022,
          "Referenced Fraction Group Number", VR.kIS, VM.k1, false);
  static const DED kReferencedVerificationImageSequence
      //(300C,0040)
      = const DED("ReferencedVerificationImageSequence", 0x300C0040,
          "Referenced Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedReferenceImageSequence
      //(300C,0042)
      = const DED("ReferencedReferenceImageSequence", 0x300C0042,
          "Referenced Reference Image Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedDoseReferenceSequence
      //(300C,0050)
      = const DED("ReferencedDoseReferenceSequence", 0x300C0050,
          "Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedDoseReferenceNumber
      //(300C,0051)
      = const DED("ReferencedDoseReferenceNumber", 0x300C0051,
          "Referenced Dose Reference Number", VR.kIS, VM.k1, false);
  static const DED kBrachyReferencedDoseReferenceSequence
      //(300C,0055)
      = const DED("BrachyReferencedDoseReferenceSequence", 0x300C0055,
          "Brachy Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedStructureSetSequence
      //(300C,0060)
      = const DED("ReferencedStructureSetSequence", 0x300C0060,
          "Referenced Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedPatientSetupNumber
      //(300C,006A)
      = const DED("ReferencedPatientSetupNumber", 0x300C006A, "Referenced Patient Setup Number",
          VR.kIS, VM.k1, false);
  static const DED kReferencedDoseSequence
      //(300C,0080)
      = const DED(
          "ReferencedDoseSequence", 0x300C0080, "Referenced Dose Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedToleranceTableNumber
      //(300C,00A0)
      = const DED("ReferencedToleranceTableNumber", 0x300C00A0,
          "Referenced Tolerance Table Number", VR.kIS, VM.k1, false);
  static const DED kReferencedBolusSequence
      //(300C,00B0)
      = const DED(
          "ReferencedBolusSequence", 0x300C00B0, "Referenced Bolus Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedWedgeNumber
      //(300C,00C0)
      = const DED(
          "ReferencedWedgeNumber", 0x300C00C0, "Referenced Wedge Number", VR.kIS, VM.k1, false);
  static const DED kReferencedCompensatorNumber
      //(300C,00D0)
      = const DED("ReferencedCompensatorNumber", 0x300C00D0, "Referenced Compensator Number",
          VR.kIS, VM.k1, false);
  static const DED kReferencedBlockNumber
      //(300C,00E0)
      = const DED(
          "ReferencedBlockNumber", 0x300C00E0, "Referenced Block Number", VR.kIS, VM.k1, false);
  static const DED kReferencedControlPointIndex
      //(300C,00F0)
      = const DED("ReferencedControlPointIndex", 0x300C00F0, "Referenced Control Point Index",
          VR.kIS, VM.k1, false);
  static const DED kReferencedControlPointSequence
      //(300C,00F2)
      = const DED("ReferencedControlPointSequence", 0x300C00F2,
          "Referenced Control Point Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedStartControlPointIndex
      //(300C,00F4)
      = const DED("ReferencedStartControlPointIndex", 0x300C00F4,
          "Referenced Start Control Point Index", VR.kIS, VM.k1, false);
  static const DED kReferencedStopControlPointIndex
      //(300C,00F6)
      = const DED("ReferencedStopControlPointIndex", 0x300C00F6,
          "Referenced Stop Control Point Index", VR.kIS, VM.k1, false);
  static const DED kReferencedRangeShifterNumber
      //(300C,0100)
      = const DED("ReferencedRangeShifterNumber", 0x300C0100, "Referenced Range Shifter Number",
          VR.kIS, VM.k1, false);
  static const DED kReferencedLateralSpreadingDeviceNumber
      //(300C,0102)
      = const DED("ReferencedLateralSpreadingDeviceNumber", 0x300C0102,
          "Referenced Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const DED kReferencedRangeModulatorNumber
      //(300C,0104)
      = const DED("ReferencedRangeModulatorNumber", 0x300C0104,
          "Referenced Range Modulator Number", VR.kIS, VM.k1, false);
  static const DED kApprovalStatus
      //(300E,0002)
      = const DED("ApprovalStatus", 0x300E0002, "Approval Status", VR.kCS, VM.k1, false);
  static const DED kReviewDate
      //(300E,0004)
      = const DED("ReviewDate", 0x300E0004, "Review Date", VR.kDA, VM.k1, false);
  static const DED kReviewTime
      //(300E,0005)
      = const DED("ReviewTime", 0x300E0005, "Review Time", VR.kTM, VM.k1, false);
  static const DED kReviewerName
      //(300E,0008)
      = const DED("ReviewerName", 0x300E0008, "Reviewer Name", VR.kPN, VM.k1, false);
  static const DED kArbitrary
      //(4000,0010)
      = const DED("Arbitrary", 0x40000010, "Arbitrary", VR.kLT, VM.k1, true);
  static const DED kTextComments
      //(4000,4000)
      = const DED("TextComments", 0x40004000, "Text Comments", VR.kLT, VM.k1, true);
  static const DED kResultsID
      //(4008,0040)
      = const DED("ResultsID", 0x40080040, "Results ID", VR.kSH, VM.k1, true);
  static const DED kResultsIDIssuer
      //(4008,0042)
      = const DED("ResultsIDIssuer", 0x40080042, "Results ID Issuer", VR.kLO, VM.k1, true);
  static const DED kReferencedInterpretationSequence
      //(4008,0050)
      = const DED("ReferencedInterpretationSequence", 0x40080050,
          "Referenced Interpretation Sequence", VR.kSQ, VM.k1, true);
  static const DED kReportProductionStatusTrial
      //(4008,00FF)
      = const DED("ReportProductionStatusTrial", 0x400800FF, "Report Production Status (Trial)",
          VR.kCS, VM.k1, true);
  static const DED kInterpretationRecordedDate
      //(4008,0100)
      = const DED("InterpretationRecordedDate", 0x40080100, "Interpretation Recorded Date",
          VR.kDA, VM.k1, true);
  static const DED kInterpretationRecordedTime
      //(4008,0101)
      = const DED("InterpretationRecordedTime", 0x40080101, "Interpretation Recorded Time",
          VR.kTM, VM.k1, true);
  static const DED kInterpretationRecorder
      //(4008,0102)
      = const DED(
          "InterpretationRecorder", 0x40080102, "Interpretation Recorder", VR.kPN, VM.k1, true);
  static const DED kReferenceToRecordedSound
      //(4008,0103)
      = const DED("ReferenceToRecordedSound", 0x40080103, "Reference to Recorded Sound", VR.kLO,
          VM.k1, true);
  static const DED kInterpretationTranscriptionDate
      //(4008,0108)
      = const DED("InterpretationTranscriptionDate", 0x40080108,
          "Interpretation Transcription Date", VR.kDA, VM.k1, true);
  static const DED kInterpretationTranscriptionTime
      //(4008,0109)
      = const DED("InterpretationTranscriptionTime", 0x40080109,
          "Interpretation Transcription Time", VR.kTM, VM.k1, true);
  static const DED kInterpretationTranscriber
      //(4008,010A)
      = const DED("InterpretationTranscriber", 0x4008010A, "Interpretation Transcriber", VR.kPN,
          VM.k1, true);
  static const DED kInterpretationText
      //(4008,010B)
      = const DED("InterpretationText", 0x4008010B, "Interpretation Text", VR.kST, VM.k1, true);
  static const DED kInterpretationAuthor
      //(4008,010C)
      = const DED(
          "InterpretationAuthor", 0x4008010C, "Interpretation Author", VR.kPN, VM.k1, true);
  static const DED kInterpretationApproverSequence
      //(4008,0111)
      = const DED("InterpretationApproverSequence", 0x40080111,
          "Interpretation Approver Sequence", VR.kSQ, VM.k1, true);
  static const DED kInterpretationApprovalDate
      //(4008,0112)
      = const DED("InterpretationApprovalDate", 0x40080112, "Interpretation Approval Date",
          VR.kDA, VM.k1, true);
  static const DED kInterpretationApprovalTime
      //(4008,0113)
      = const DED("InterpretationApprovalTime", 0x40080113, "Interpretation Approval Time",
          VR.kTM, VM.k1, true);
  static const DED kPhysicianApprovingInterpretation
      //(4008,0114)
      = const DED("PhysicianApprovingInterpretation", 0x40080114,
          "Physician Approving Interpretation", VR.kPN, VM.k1, true);
  static const DED kInterpretationDiagnosisDescription
      //(4008,0115)
      = const DED("InterpretationDiagnosisDescription", 0x40080115,
          "Interpretation Diagnosis Description", VR.kLT, VM.k1, true);
  static const DED kInterpretationDiagnosisCodeSequence
      //(4008,0117)
      = const DED("InterpretationDiagnosisCodeSequence", 0x40080117,
          "Interpretation Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const DED kResultsDistributionListSequence
      //(4008,0118)
      = const DED("ResultsDistributionListSequence", 0x40080118,
          "Results Distribution List Sequence", VR.kSQ, VM.k1, true);
  static const DED kDistributionName
      //(4008,0119)
      = const DED("DistributionName", 0x40080119, "Distribution Name", VR.kPN, VM.k1, true);
  static const DED kDistributionAddress
      //(4008,011A)
      =
      const DED("DistributionAddress", 0x4008011A, "Distribution Address", VR.kLO, VM.k1, true);
  static const DED kInterpretationID
      //(4008,0200)
      = const DED("InterpretationID", 0x40080200, "Interpretation ID", VR.kSH, VM.k1, true);
  static const DED kInterpretationIDIssuer
      //(4008,0202)
      = const DED(
          "InterpretationIDIssuer", 0x40080202, "Interpretation ID Issuer", VR.kLO, VM.k1, true);
  static const DED kInterpretationTypeID
      //(4008,0210)
      = const DED(
          "InterpretationTypeID", 0x40080210, "Interpretation Type ID", VR.kCS, VM.k1, true);
  static const DED kInterpretationStatusID
      //(4008,0212)
      = const DED(
          "InterpretationStatusID", 0x40080212, "Interpretation Status ID", VR.kCS, VM.k1, true);
  static const DED kImpressions
      //(4008,0300)
      = const DED("Impressions", 0x40080300, "Impressions", VR.kST, VM.k1, true);
  static const DED kResultsComments
      //(4008,4000)
      = const DED("ResultsComments", 0x40084000, "Results Comments", VR.kST, VM.k1, true);
  static const DED kLowEnergyDetectors
      //(4010,0001)
      =
      const DED("LowEnergyDetectors", 0x40100001, "Low Energy Detectors", VR.kCS, VM.k1, false);
  static const DED kHighEnergyDetectors
      //(4010,0002)
      = const DED(
          "HighEnergyDetectors", 0x40100002, "High Energy Detectors", VR.kCS, VM.k1, false);
  static const DED kDetectorGeometrySequence
      //(4010,0004)
      = const DED("DetectorGeometrySequence", 0x40100004, "Detector Geometry Sequence", VR.kSQ,
          VM.k1, false);
  static const DED kThreatROIVoxelSequence
      //(4010,1001)
      = const DED(
          "ThreatROIVoxelSequence", 0x40101001, "Threat ROI Voxel Sequence", VR.kSQ, VM.k1, false);
  static const DED kThreatROIBase
      //(4010,1004)
      = const DED("ThreatROIBase", 0x40101004, "Threat ROI Base", VR.kFL, VM.k3, false);
  static const DED kThreatROIExtents
      //(4010,1005)
      = const DED("ThreatROIExtents", 0x40101005, "Threat ROI Extents", VR.kFL, VM.k3, false);
  static const DED kThreatROIBitmap
      //(4010,1006)
      = const DED("ThreatROIBitmap", 0x40101006, "Threat ROI Bitmap", VR.kOB, VM.k1, false);
  static const DED kRouteSegmentID
      //(4010,1007)
      = const DED("RouteSegmentID", 0x40101007, "Route Segment ID", VR.kSH, VM.k1, false);
  static const DED kGantryType
      //(4010,1008)
      = const DED("GantryType", 0x40101008, "Gantry Type", VR.kCS, VM.k1, false);
  static const DED kOOIOwnerType
      //(4010,1009)
      = const DED("OOIOwnerType", 0x40101009, "OOI Owner Type", VR.kCS, VM.k1, false);
  static const DED kRouteSegmentSequence
      //(4010,100A)
      = const DED(
          "RouteSegmentSequence", 0x4010100A, "Route Segment Sequence", VR.kSQ, VM.k1, false);
  static const DED kPotentialThreatObjectID
      //(4010,1010)
      = const DED("PotentialThreatObjectID", 0x40101010, "Potential Threat Object ID", VR.kUS,
          VM.k1, false);
  static const DED kThreatSequence
      //(4010,1011)
      = const DED("ThreatSequence", 0x40101011, "Threat Sequence", VR.kSQ, VM.k1, false);
  static const DED kThreatCategory
      //(4010,1012)
      = const DED("ThreatCategory", 0x40101012, "Threat Category", VR.kCS, VM.k1, false);
  static const DED kThreatCategoryDescription
      //(4010,1013)
      = const DED("ThreatCategoryDescription", 0x40101013, "Threat Category Description",
          VR.kLT, VM.k1, false);
  static const DED kATDAbilityAssessment
      //(4010,1014)
      = const DED(
          "ATDAbilityAssessment", 0x40101014, "ATD Ability Assessment", VR.kCS, VM.k1, false);
  static const DED kATDAssessmentFlag
      //(4010,1015)
      = const DED("ATDAssessmentFlag", 0x40101015, "ATD Assessment Flag", VR.kCS, VM.k1, false);
  static const DED kATDAssessmentProbability
      //(4010,1016)
      = const DED("ATDAssessmentProbability", 0x40101016, "ATD Assessment Probability", VR.kFL,
          VM.k1, false);
  static const DED kMass
      //(4010,1017)
      = const DED("Mass", 0x40101017, "Mass", VR.kFL, VM.k1, false);
  static const DED kDensity
      //(4010,1018)
      = const DED("Density", 0x40101018, "Density", VR.kFL, VM.k1, false);
  static const DED kZEffective
      //(4010,1019)
      = const DED("ZEffective", 0x40101019, "Z Effective", VR.kFL, VM.k1, false);
  static const DED kBoardingPassID
      //(4010,101A)
      = const DED("BoardingPassID", 0x4010101A, "Boarding Pass ID", VR.kSH, VM.k1, false);
  static const DED kCenterOfMass
      //(4010,101B)
      = const DED("CenterOfMass", 0x4010101B, "Center of Mass", VR.kFL, VM.k3, false);
  static const DED kCenterOfPTO
      //(4010,101C)
      = const DED("CenterOfPTO", 0x4010101C, "Center of PTO", VR.kFL, VM.k3, false);
  static const DED kBoundingPolygon
      //(4010,101D)
      = const DED("BoundingPolygon", 0x4010101D, "Bounding Polygon", VR.kFL, VM.k6_n, false);
  static const DED kRouteSegmentStartLocationID
      //(4010,101E)
      = const DED("RouteSegmentStartLocationID", 0x4010101E, "Route Segment Start Location ID",
          VR.kSH, VM.k1, false);
  static const DED kRouteSegmentEndLocationID
      //(4010,101F)
      = const DED("RouteSegmentEndLocationID", 0x4010101F, "Route Segment End Location ID",
          VR.kSH, VM.k1, false);
  static const DED kRouteSegmentLocationIDType
      //(4010,1020)
      = const DED("RouteSegmentLocationIDType", 0x40101020, "Route Segment Location ID Type",
          VR.kCS, VM.k1, false);
  static const DED kAbortReason
      //(4010,1021)
      = const DED("AbortReason", 0x40101021, "Abort Reason", VR.kCS, VM.k1_n, false);
  static const DED kVolumeOfPTO
      //(4010,1023)
      = const DED("VolumeOfPTO", 0x40101023, "Volume of PTO", VR.kFL, VM.k1, false);
  static const DED kAbortFlag
      //(4010,1024)
      = const DED("AbortFlag", 0x40101024, "Abort Flag", VR.kCS, VM.k1, false);
  static const DED kRouteSegmentStartTime
      //(4010,1025)
      = const DED(
          "RouteSegmentStartTime", 0x40101025, "Route Segment Start Time", VR.kDT, VM.k1, false);
  static const DED kRouteSegmentEndTime
      //(4010,1026)
      = const DED(
          "RouteSegmentEndTime", 0x40101026, "Route Segment End Time", VR.kDT, VM.k1, false);
  static const DED kTDRType
      //(4010,1027)
      = const DED("TDRType", 0x40101027, "TDR Type", VR.kCS, VM.k1, false);
  static const DED kInternationalRouteSegment
      //(4010,1028)
      = const DED("InternationalRouteSegment", 0x40101028, "International Route Segment",
          VR.kCS, VM.k1, false);
  static const DED kThreatDetectionAlgorithmandVersion
      //(4010,1029)
      = const DED("ThreatDetectionAlgorithmandVersion", 0x40101029,
          "Threat Detection Algorithm and Version", VR.kLO, VM.k1_n, false);
  static const DED kAssignedLocation
      //(4010,102A)
      = const DED("AssignedLocation", 0x4010102A, "Assigned Location", VR.kSH, VM.k1, false);
  static const DED kAlarmDecisionTime
      //(4010,102B)
      = const DED("AlarmDecisionTime", 0x4010102B, "Alarm Decision Time", VR.kDT, VM.k1, false);
  static const DED kAlarmDecision
      //(4010,1031)
      = const DED("AlarmDecision", 0x40101031, "Alarm Decision", VR.kCS, VM.k1, false);
  static const DED kNumberOfTotalObjects
      //(4010,1033)
      = const DED(
          "NumberOfTotalObjects", 0x40101033, "Number of Total Objects", VR.kUS, VM.k1, false);
  static const DED kNumberOfAlarmObjects
      //(4010,1034)
      = const DED(
          "NumberOfAlarmObjects", 0x40101034, "Number of Alarm Objects", VR.kUS, VM.k1, false);
  static const DED kPTORepresentationSequence
      //(4010,1037)
      = const DED("PTORepresentationSequence", 0x40101037, "PTO Representation Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kATDAssessmentSequence
      //(4010,1038)
      = const DED(
          "ATDAssessmentSequence", 0x40101038, "ATD Assessment Sequence", VR.kSQ, VM.k1, false);
  static const DED kTIPType
      //(4010,1039)
      = const DED("TIPType", 0x40101039, "TIP Type", VR.kCS, VM.k1, false);
  static const DED kDICOSVersion
      //(4010,103A)
      = const DED("DICOSVersion", 0x4010103A, "DICOS Version", VR.kCS, VM.k1, false);
  static const DED kOOIOwnerCreationTime
      //(4010,1041)
      = const DED(
          "OOIOwnerCreationTime", 0x40101041, "OOI Owner Creation Time", VR.kDT, VM.k1, false);
  static const DED kOOIType
      //(4010,1042)
      = const DED("OOIType", 0x40101042, "OOI Type", VR.kCS, VM.k1, false);
  static const DED kOOISize
      //(4010,1043)
      = const DED("OOISize", 0x40101043, "OOI Size", VR.kFL, VM.k3, false);
  static const DED kAcquisitionStatus
      //(4010,1044)
      = const DED("AcquisitionStatus", 0x40101044, "Acquisition Status", VR.kCS, VM.k1, false);
  static const DED kBasisMaterialsCodeSequence
      //(4010,1045)
      = const DED("BasisMaterialsCodeSequence", 0x40101045, "Basis Materials Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kPhantomType
      //(4010,1046)
      = const DED("PhantomType", 0x40101046, "Phantom Type", VR.kCS, VM.k1, false);
  static const DED kOOIOwnerSequence
      //(4010,1047)
      = const DED("OOIOwnerSequence", 0x40101047, "OOI Owner Sequence", VR.kSQ, VM.k1, false);
  static const DED kScanType
      //(4010,1048)
      = const DED("ScanType", 0x40101048, "Scan Type", VR.kCS, VM.k1, false);
  static const DED kItineraryID
      //(4010,1051)
      = const DED("ItineraryID", 0x40101051, "Itinerary ID", VR.kLO, VM.k1, false);
  static const DED kItineraryIDType
      //(4010,1052)
      = const DED("ItineraryIDType", 0x40101052, "Itinerary ID Type", VR.kSH, VM.k1, false);
  static const DED kItineraryIDAssigningAuthority
      //(4010,1053)
      = const DED("ItineraryIDAssigningAuthority", 0x40101053,
          "Itinerary ID Assigning Authority", VR.kLO, VM.k1, false);
  static const DED kRouteID
      //(4010,1054)
      = const DED("RouteID", 0x40101054, "Route ID", VR.kSH, VM.k1, false);
  static const DED kRouteIDAssigningAuthority
      //(4010,1055)
      = const DED("RouteIDAssigningAuthority", 0x40101055, "Route ID Assigning Authority",
          VR.kSH, VM.k1, false);
  static const DED kInboundArrivalType
      //(4010,1056)
      =
      const DED("InboundArrivalType", 0x40101056, "Inbound Arrival Type", VR.kCS, VM.k1, false);
  static const DED kCarrierID
      //(4010,1058)
      = const DED("CarrierID", 0x40101058, "Carrier ID", VR.kSH, VM.k1, false);
  static const DED kCarrierIDAssigningAuthority
      //(4010,1059)
      = const DED("CarrierIDAssigningAuthority", 0x40101059, "Carrier ID Assigning Authority",
          VR.kCS, VM.k1, false);
  static const DED kSourceOrientation
      //(4010,1060)
      = const DED("SourceOrientation", 0x40101060, "Source Orientation", VR.kFL, VM.k3, false);
  static const DED kSourcePosition
      //(4010,1061)
      = const DED("SourcePosition", 0x40101061, "Source Position", VR.kFL, VM.k3, false);
  static const DED kBeltHeight
      //(4010,1062)
      = const DED("BeltHeight", 0x40101062, "Belt Height", VR.kFL, VM.k1, false);
  static const DED kAlgorithmRoutingCodeSequence
      //(4010,1064)
      = const DED("AlgorithmRoutingCodeSequence", 0x40101064, "Algorithm Routing Code Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kTransportClassification
      //(4010,1067)
      = const DED(
          "TransportClassification", 0x40101067, "Transport Classification", VR.kCS, VM.k1, false);
  static const DED kOOITypeDescriptor
      //(4010,1068)
      = const DED("OOITypeDescriptor", 0x40101068, "OOI Type Descriptor", VR.kLT, VM.k1, false);
  static const DED kTotalProcessingTime
      //(4010,1069)
      = const DED(
          "TotalProcessingTime", 0x40101069, "Total Processing Time", VR.kFL, VM.k1, false);
  static const DED kDetectorCalibrationData
      //(4010,106C)
      = const DED(
          "DetectorCalibrationData", 0x4010106C, "Detector Calibration Data", VR.kOB, VM.k1, false);
  static const DED kAdditionalScreeningPerformed
      //(4010,106D)
      = const DED("AdditionalScreeningPerformed", 0x4010106D, "Additional Screening Performed",
          VR.kCS, VM.k1, false);
  static const DED kAdditionalInspectionSelectionCriteria
      //(4010,106E)
      = const DED("AdditionalInspectionSelectionCriteria", 0x4010106E,
          "Additional Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const DED kAdditionalInspectionMethodSequence
      //(4010,106F)
      = const DED("AdditionalInspectionMethodSequence", 0x4010106F,
          "Additional Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const DED kAITDeviceType
      //(4010,1070)
      = const DED("AITDeviceType", 0x40101070, "AIT Device Type", VR.kCS, VM.k1, false);
  static const DED kQRMeasurementsSequence
      //(4010,1071)
      = const DED(
          "QRMeasurementsSequence", 0x40101071, "QR Measurements Sequence", VR.kSQ, VM.k1, false);
  static const DED kTargetMaterialSequence
      //(4010,1072)
      = const DED(
          "TargetMaterialSequence", 0x40101072, "Target Material Sequence", VR.kSQ, VM.k1, false);
  static const DED kSNRThreshold
      //(4010,1073)
      = const DED("SNRThreshold", 0x40101073, "SNR Threshold", VR.kFD, VM.k1, false);
  static const DED kImageScaleRepresentation
      //(4010,1075)
      = const DED("ImageScaleRepresentation", 0x40101075, "Image Scale Representation", VR.kDS,
          VM.k1, false);
  static const DED kReferencedPTOSequence
      //(4010,1076)
      = const DED(
          "ReferencedPTOSequence", 0x40101076, "Referenced PTO Sequence", VR.kSQ, VM.k1, false);
  static const DED kReferencedTDRInstanceSequence
      //(4010,1077)
      = const DED("ReferencedTDRInstanceSequence", 0x40101077,
          "Referenced TDR Instance Sequence", VR.kSQ, VM.k1, false);
  static const DED kPTOLocationDescription
      //(4010,1078)
      = const DED(
          "PTOLocationDescription", 0x40101078, "PTO Location Description", VR.kST, VM.k1, false);
  static const DED kAnomalyLocatorIndicatorSequence
      //(4010,1079)
      = const DED("AnomalyLocatorIndicatorSequence", 0x40101079,
          "Anomaly Locator Indicator Sequence", VR.kSQ, VM.k1, false);
  static const DED kAnomalyLocatorIndicator
      //(4010,107A)
      = const DED(
          "AnomalyLocatorIndicator", 0x4010107A, "Anomaly Locator Indicator", VR.kFL, VM.k3, false);
  static const DED kPTORegionSequence
      //(4010,107B)
      = const DED("PTORegionSequence", 0x4010107B, "PTO Region Sequence", VR.kSQ, VM.k1, false);
  static const DED kInspectionSelectionCriteria
      //(4010,107C)
      = const DED("InspectionSelectionCriteria", 0x4010107C, "Inspection Selection Criteria",
          VR.kCS, VM.k1, false);
  static const DED kSecondaryInspectionMethodSequence
      //(4010,107D)
      = const DED("SecondaryInspectionMethodSequence", 0x4010107D,
          "Secondary Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const DED kPRCSToRCSOrientation
      //(4010,107E)
      = const DED(
          "PRCSToRCSOrientation", 0x4010107E, "PRCS to RCS Orientation", VR.kDS, VM.k6, false);
  static const DED kMACParametersSequence
      //(4FFE,0001)
      = const DED(
          "MACParametersSequence", 0x4FFE0001, "MAC Parameters Sequence", VR.kSQ, VM.k1, false);
  static const DED kCurveDimensions
      //(5000,0005)
      = const DED("CurveDimensions", 0x50000005, "Curve Dimensions", VR.kUS, VM.k1, true);
  static const DED kNumberOfPoints
      //(5000,0010)
      = const DED("NumberOfPoints", 0x50000010, "Number of Points", VR.kUS, VM.k1, true);
  static const DED kTypeOfData
      //(5000,0020)
      = const DED("TypeOfData", 0x50000020, "Type of Data", VR.kCS, VM.k1, true);
  static const DED kCurveDescription
      //(5000,0022)
      = const DED("CurveDescription", 0x50000022, "Curve Description", VR.kLO, VM.k1, true);
  static const DED kAxisUnits
      //(5000,0030)
      = const DED("AxisUnits", 0x50000030, "Axis Units", VR.kSH, VM.k1_n, true);
  static const DED kAxisLabels
      //(5000,0040)
      = const DED("AxisLabels", 0x50000040, "Axis Labels", VR.kSH, VM.k1_n, true);
  static const DED kDataValueRepresentation
      //(5000,0103)
      = const DED(
          "DataValueRepresentation", 0x50000103, "Data Value Representation", VR.kUS, VM.k1, true);
  static const DED kMinimumCoordinateValue
      //(5000,0104)
      = const DED(
          "MinimumCoordinateValue", 0x50000104, "Minimum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const DED kMaximumCoordinateValue
      //(5000,0105)
      = const DED(
          "MaximumCoordinateValue", 0x50000105, "Maximum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const DED kCurveRange
      //(5000,0106)
      = const DED("CurveRange", 0x50000106, "Curve Range", VR.kSH, VM.k1_n, true);
  static const DED kCurveDataDescriptor
      //(5000,0110)
      = const DED(
          "CurveDataDescriptor", 0x50000110, "Curve Data Descriptor", VR.kUS, VM.k1_n, true);
  static const DED kCoordinateStartValue
      //(5000,0112)
      = const DED(
          "CoordinateStartValue", 0x50000112, "Coordinate Start Value", VR.kUS, VM.k1_n, true);
  static const DED kCoordinateStepValue
      //(5000,0114)
      = const DED(
          "CoordinateStepValue", 0x50000114, "Coordinate Step Value", VR.kUS, VM.k1_n, true);
  static const DED kCurveActivationLayer
      //(5000,1001)
      = const DED(
          "CurveActivationLayer", 0x50001001, "Curve Activation Layer", VR.kCS, VM.k1, true);
  static const DED kAudioType
      //(5000,2000)
      = const DED("AudioType", 0x50002000, "Audio Type", VR.kUS, VM.k1, true);
  static const DED kAudioSampleFormat
      //(5000,2002)
      = const DED("AudioSampleFormat", 0x50002002, "Audio Sample Format", VR.kUS, VM.k1, true);
  static const DED kNumberOfChannels
      //(5000,2004)
      = const DED("NumberOfChannels", 0x50002004, "Number of Channels", VR.kUS, VM.k1, true);
  static const DED kNumberOfSamples
      //(5000,2006)
      = const DED("NumberOfSamples", 0x50002006, "Number of Samples", VR.kUL, VM.k1, true);
  static const DED kSampleRate
      //(5000,2008)
      = const DED("SampleRate", 0x50002008, "Sample Rate", VR.kUL, VM.k1, true);
  static const DED kTotalTime
      //(5000,200A)
      = const DED("TotalTime", 0x5000200A, "Total Time", VR.kUL, VM.k1, true);
  static const DED kAudioSampleData
      //(5000,200C)
      = const DED("AudioSampleData", 0x5000200C, "Audio Sample Data", VR.kOBOW, VM.k1, true);
  static const DED kAudioComments
      //(5000,200E)
      = const DED("AudioComments", 0x5000200E, "Audio Comments", VR.kLT, VM.k1, true);
  static const DED kCurveLabel
      //(5000,2500)
      = const DED("CurveLabel", 0x50002500, "Curve Label", VR.kLO, VM.k1, true);
  static const DED kCurveReferencedOverlaySequence
      //(5000,2600)
      = const DED("CurveReferencedOverlaySequence", 0x50002600,
          "Curve Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const DED kCurveReferencedOverlayGroup
      //(5000,2610)
      = const DED("CurveReferencedOverlayGroup", 0x50002610, "Curve Referenced Overlay Group",
          VR.kUS, VM.k1, true);
  static const DED kCurveData
      //(5000,3000)
      = const DED("CurveData", 0x50003000, "Curve Data", VR.kOBOW, VM.k1, true);
  static const DED kSharedFunctionalGroupsSequence
      //(5200,9229)
      = const DED("SharedFunctionalGroupsSequence", 0x52009229,
          "Shared Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const DED kPerFrameFunctionalGroupsSequence
      //(5200,9230)
      = const DED("PerFrameFunctionalGroupsSequence", 0x52009230,
          "Per-frame Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const DED kWaveformSequence
      //(5400,0100)
      = const DED("WaveformSequence", 0x54000100, "Waveform Sequence", VR.kSQ, VM.k1, false);
  static const DED kChannelMinimumValue
      //(5400,0110)
      = const DED(
          "ChannelMinimumValue", 0x54000110, "Channel Minimum Value", VR.kOBOW, VM.k1, false);
  static const DED kChannelMaximumValue
      //(5400,0112)
      = const DED(
          "ChannelMaximumValue", 0x54000112, "Channel Maximum Value", VR.kOBOW, VM.k1, false);
  static const DED kWaveformBitsAllocated
      //(5400,1004)
      = const DED(
          "WaveformBitsAllocated", 0x54001004, "Waveform Bits Allocated", VR.kUS, VM.k1, false);
  static const DED kWaveformSampleInterpretation
      //(5400,1006)
      = const DED("WaveformSampleInterpretation", 0x54001006, "Waveform Sample Interpretation",
          VR.kCS, VM.k1, false);
  static const DED kWaveformPaddingValue
      //(5400,100A)
      = const DED(
          "WaveformPaddingValue", 0x5400100A, "Waveform Padding Value", VR.kOBOW, VM.k1, false);
  static const DED kWaveformData
      //(5400,1010)
      = const DED("WaveformData", 0x54001010, "Waveform Data", VR.kOBOW, VM.k1, false);
  static const DED kFirstOrderPhaseCorrectionAngle
      //(5600,0010)
      = const DED("FirstOrderPhaseCorrectionAngle", 0x56000010,
          "First Order Phase Correction Angle", VR.kOF, VM.k1, false);
  static const DED kSpectroscopyData
      //(5600,0020)
      = const DED("SpectroscopyData", 0x56000020, "Spectroscopy Data", VR.kOF, VM.k1, false);
  static const DED kOverlayRows
      //(6000,0010)
      = const DED("OverlayRows", 0x60000010, "Overlay Rows", VR.kUS, VM.k1, false);
  static const DED kOverlayColumns
      //(6000,0011)
      = const DED("OverlayColumns", 0x60000011, "Overlay Columns", VR.kUS, VM.k1, false);
  static const DED kOverlayPlanes
      //(6000,0012)
      = const DED("OverlayPlanes", 0x60000012, "Overlay Planes", VR.kUS, VM.k1, true);
  static const DED kNumberOfFramesInOverlay
      //(6000,0015)
      = const DED("NumberOfFramesInOverlay", 0x60000015, "Number of Frames in Overlay", VR.kIS,
          VM.k1, false);
  static const DED kOverlayDescription
      //(6000,0022)
      =
      const DED("OverlayDescription", 0x60000022, "Overlay Description", VR.kLO, VM.k1, false);
  static const DED kOverlayType
      //(6000,0040)
      = const DED("OverlayType", 0x60000040, "Overlay Type", VR.kCS, VM.k1, false);
  static const DED kOverlaySubtype
      //(6000,0045)
      = const DED("OverlaySubtype", 0x60000045, "Overlay Subtype", VR.kLO, VM.k1, false);
  static const DED kOverlayOrigin
      //(6000,0050)
      = const DED("OverlayOrigin", 0x60000050, "Overlay Origin", VR.kSS, VM.k2, false);
  static const DED kImageFrameOrigin
      //(6000,0051)
      = const DED("ImageFrameOrigin", 0x60000051, "Image Frame Origin", VR.kUS, VM.k1, false);
  static const DED kOverlayPlaneOrigin
      //(6000,0052)
      =
      const DED("OverlayPlaneOrigin", 0x60000052, "Overlay Plane Origin", VR.kUS, VM.k1, true);
  static const DED kOverlayCompressionCode
      //(6000,0060)
      = const DED(
          "OverlayCompressionCode", 0x60000060, "Overlay Compression Code", VR.kCS, VM.k1, true);
  static const DED kOverlayCompressionOriginator
      //(6000,0061)
      = const DED("OverlayCompressionOriginator", 0x60000061, "Overlay Compression Originator",
          VR.kSH, VM.k1, true);
  static const DED kOverlayCompressionLabel
      //(6000,0062)
      = const DED(
          "OverlayCompressionLabel", 0x60000062, "Overlay Compression Label", VR.kSH, VM.k1, true);
  static const DED kOverlayCompressionDescription
      //(6000,0063)
      = const DED("OverlayCompressionDescription", 0x60000063,
          "Overlay Compression Description", VR.kCS, VM.k1, true);
  static const DED kOverlayCompressionStepPointers
      //(6000,0066)
      = const DED("OverlayCompressionStepPointers", 0x60000066,
          "Overlay Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const DED kOverlayRepeatInterval
      //(6000,0068)
      = const DED(
          "OverlayRepeatInterval", 0x60000068, "Overlay Repeat Interval", VR.kUS, VM.k1, true);
  static const DED kOverlayBitsGrouped
      //(6000,0069)
      =
      const DED("OverlayBitsGrouped", 0x60000069, "Overlay Bits Grouped", VR.kUS, VM.k1, true);
  static const DED kOverlayBitsAllocated
      //(6000,0100)
      = const DED(
          "OverlayBitsAllocated", 0x60000100, "Overlay Bits Allocated", VR.kUS, VM.k1, false);
  static const DED kOverlayBitPosition
      //(6000,0102)
      =
      const DED("OverlayBitPosition", 0x60000102, "Overlay Bit Position", VR.kUS, VM.k1, false);
  static const DED kOverlayFormat
      //(6000,0110)
      = const DED("OverlayFormat", 0x60000110, "Overlay Format", VR.kCS, VM.k1, true);
  static const DED kOverlayLocation
      //(6000,0200)
      = const DED("OverlayLocation", 0x60000200, "Overlay Location", VR.kUS, VM.k1, true);
  static const DED kOverlayCodeLabel
      //(6000,0800)
      = const DED("OverlayCodeLabel", 0x60000800, "Overlay Code Label", VR.kCS, VM.k1_n, true);
  static const DED kOverlayNumberOfTables
      //(6000,0802)
      = const DED(
          "OverlayNumberOfTables", 0x60000802, "Overlay Number of Tables", VR.kUS, VM.k1, true);
  static const DED kOverlayCodeTableLocation
      //(6000,0803)
      = const DED("OverlayCodeTableLocation", 0x60000803, "Overlay Code Table Location", VR.kAT,
          VM.k1_n, true);
  static const DED kOverlayBitsForCodeWord
      //(6000,0804)
      = const DED(
          "OverlayBitsForCodeWord", 0x60000804, "Overlay Bits For Code Word", VR.kUS, VM.k1, true);
  static const DED kOverlayActivationLayer
      //(6000,1001)
      = const DED(
          "OverlayActivationLayer", 0x60001001, "Overlay Activation Layer", VR.kCS, VM.k1, false);
  static const DED kOverlayDescriptorGray
      //(6000,1100)
      = const DED(
          "OverlayDescriptorGray", 0x60001100, "Overlay Descriptor - Gray", VR.kUS, VM.k1, true);
  static const DED kOverlayDescriptorRed
      //(6000,1101)
      = const DED(
          "OverlayDescriptorRed", 0x60001101, "Overlay Descriptor - Red", VR.kUS, VM.k1, true);
  static const DED kOverlayDescriptorGreen
      //(6000,1102)
      = const DED(
          "OverlayDescriptorGreen", 0x60001102, "Overlay Descriptor - Green", VR.kUS, VM.k1, true);
  static const DED kOverlayDescriptorBlue
      //(6000,1103)
      = const DED(
          "OverlayDescriptorBlue", 0x60001103, "Overlay Descriptor - Blue", VR.kUS, VM.k1, true);
  static const DED kOverlaysGray
      //(6000,1200)
      = const DED("OverlaysGray", 0x60001200, "Overlays - Gray", VR.kUS, VM.k1_n, true);
  static const DED kOverlaysRed
      //(6000,1201)
      = const DED("OverlaysRed", 0x60001201, "Overlays - Red", VR.kUS, VM.k1_n, true);
  static const DED kOverlaysGreen
      //(6000,1202)
      = const DED("OverlaysGreen", 0x60001202, "Overlays - Green", VR.kUS, VM.k1_n, true);
  static const DED kOverlaysBlue
      //(6000,1203)
      = const DED("OverlaysBlue", 0x60001203, "Overlays - Blue", VR.kUS, VM.k1_n, true);
  static const DED kROIArea
      //(6000,1301)
      = const DED("ROIArea", 0x60001301, "ROI Area", VR.kIS, VM.k1, false);
  static const DED kROIMean
      //(6000,1302)
      = const DED("ROIMean", 0x60001302, "ROI Mean", VR.kDS, VM.k1, false);
  static const DED kROIStandardDeviation
      //(6000,1303)
      = const DED(
          "ROIStandardDeviation", 0x60001303, "ROI Standard Deviation", VR.kDS, VM.k1, false);
  static const DED kOverlayLabel
      //(6000,1500)
      = const DED("OverlayLabel", 0x60001500, "Overlay Label", VR.kLO, VM.k1, false);
  static const DED kOverlayData
      //(6000,3000)
      = const DED("OverlayData", 0x60003000, "Overlay Data", VR.kOBOW, VM.k1, false);
  static const DED kOverlayComments
      //(6000,4000)
      = const DED("OverlayComments", 0x60004000, "Overlay Comments", VR.kLT, VM.k1, true);
  static const DED kFloatPixelData =
    const DED("FloatPixelData",
                      0x7FE00008, "Float Pixel Data", VR.kOF, VM.k1, false);
  static const DED kDoubleFloatPixelData =
    const DED("DoubleFloatPixelData",
                      0x7FE00009, "Double Float Pixel Data", VR.kOD, VM.k1, false);
  static const DED kPixelData =
    const DED("PixelData", 0x7FE00010, "Pixel Data", VR.kOBOW, VM.k1, false);
  static const DED kCoefficientsSDVN
      //(7FE0,0020)
      = const DED("CoefficientsSDVN", 0x7FE00020, "Coefficients SDVN", VR.kOW, VM.k1, true);
  static const DED kCoefficientsSDHN
      //(7FE0,0030)
      = const DED("CoefficientsSDHN", 0x7FE00030, "Coefficients SDHN", VR.kOW, VM.k1, true);
  static const DED kCoefficientsSDDN
      //(7FE0,0040)
      = const DED("CoefficientsSDDN", 0x7FE00040, "Coefficients SDDN", VR.kOW, VM.k1, true);
  static const DED kVariablePixelData
      //(7F00,0010)
      =
      const DED("VariablePixelData", 0x7F000010, "Variable Pixel Data", VR.kOBOW, VM.k1, true);
  static const DED kVariableNextDataGroup
      //(7F00,0011)
      = const DED(
          "VariableNextDataGroup", 0x7F000011, "Variable Next Data Group", VR.kUS, VM.k1, true);
  static const DED kVariableCoefficientsSDVN
      //(7F00,0020)
      = const DED("VariableCoefficientsSDVN", 0x7F000020, "Variable Coefficients SDVN", VR.kOW,
          VM.k1, true);
  static const DED kVariableCoefficientsSDHN
      //(7F00,0030)
      = const DED("VariableCoefficientsSDHN", 0x7F000030, "Variable Coefficients SDHN", VR.kOW,
          VM.k1, true);
  static const DED kVariableCoefficientsSDDN
      //(7F00,0040)
      = const DED("VariableCoefficientsSDDN", 0x7F000040, "Variable Coefficients SDDN", VR.kOW,
          VM.k1, true);
  static const DED kDigitalSignaturesSequence
      //(FFFA,FFFA)
      = const DED("DigitalSignaturesSequence", 0xFFFAFFFA, "Digital Signatures Sequence",
          VR.kSQ, VM.k1, false);
  static const DED kDataSetTrailingPadding
      //(FFFC,FFFC)
      = const DED(
          "DataSetTrailingPadding", 0xFFFCFFFC, "Data Set Trailing Padding", VR.kOB, VM.k1, false);
  static const DED kItem
      //(FFFE,E000)
      = const DED("Item", 0xFFFEE000, "Item", VR.kNoVR, VM.kNoVM, false);
  static const DED kItemDelimitationItem
      //(FFFE,E00D)
      = const DED(
          "ItemDelimitationItem", 0xFFFEE00D, "Item Delimitation Item", VR.kNoVR, VM.kNoVM, false);
  static const DED kSequenceDelimitationItem
      //(FFFE,E0DD)
      = const DED("SequenceDelimitationItem", 0xFFFEE0DD, "Sequence Delimitation Item",
          VR.kNoVR, VM.kNoVM, false);

  //**** Special Elements where multiple tags map to the same dictionary

  //(0028,04X0)
  static const DED kRowsForNthOrderCoefficients = const DED("RowsForNthOrderCoefficients",
      0x002804F0, "Rows For Nth Order Coefficients", VR.kUS, VM.k1, true);

  //(0028,04X1)
  static const DED kColumnsForNthOrderCoefficients = const DED(
      "ColumnsForNthOrderCoefficients",
      0x00280401,
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,0402)
  static const DED kCoefficientCoding =
      const DED("CoefficientCoding", 0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);

  //(0028,0403)
  static const DED kCoefficientCodingPointers = const DED("CoefficientCodingPointers",
      0x00280403, "Coefficient Coding Pointers", VR.kAT, VM.k1_n, true);
}

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name
