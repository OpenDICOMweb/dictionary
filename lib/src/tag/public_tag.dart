// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:dictionary/src/tag/e_type.dart';
import 'package:dictionary/src/tag/errors.dart';
import 'package:dictionary/src/tag/public_tag_code_map.dart';
import 'package:dictionary/src/tag/public_tag_keyword_map.dart';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

class PublicTag extends Tag {
  @override
  final String keyword;
  @override
  final String name;
  @override
  final bool isRetired;

  const PublicTag(this.keyword, int code, this.name, VR vr, VM vm,
      [this.isRetired = false, EType type = EType.kUnknown])
      : super(code, vr, vm, type);

  bool get isWKFmi => fmiTags.contains(code);

  @override
  String get info {
    String retired = (isRetired) ? '- Retired' : '';
    return '$runtimeType$dcm $vr $vm $keyword $retired';
  }

  @override
  String toString() {
    String retired = (isRetired == false) ? "" : ", (Retired)";
    return 'Element: $dcm $keyword, $vr, $vm, $retired';
  }

  //TODO: this should become public when fully converted to Tags.
  static PublicTag lookupCode(int code, [bool shouldThrow = true]) {
    PublicTag tag = publicTagCodeMap[code];

    // Tag tag = (isPrivateTag(v)) ? PrivateTag.lookup(v) : Tag.lookup(v);
    // TODO handle private tags here

    if (tag != null) return tag;

    // **** Retired _special case_ codes that still must be handled
    if ((code >= 0x00283100) && (code <= 0x002031FF)) return PublicTag.kSourceImageIDs;
    if ((code >= 0x00280410) && (code <= 0x002804F0))
      return PublicTag.kRowsForNthOrderCoefficients;
    if ((code >= 0x00280411) && (code <= 0x002804F1))
      return PublicTag.kColumnsForNthOrderCoefficients;
    if ((code >= 0x00280412) && (code <= 0x002804F2)) return PublicTag.kCoefficientCoding;
    if ((code >= 0x00280413) && (code <= 0x002804F3))
      return PublicTag.kCoefficientCodingPointers;
    if ((code >= 0x00280810) && (code <= 0x002808F0)) return PublicTag.kCodeLabel;
    if ((code >= 0x00280812) && (code <= 0x002808F2)) return PublicTag.kNumberOfTables;
    if ((code >= 0x00280813) && (code <= 0x002808F3)) return PublicTag.kCodeTableLocation;
    if ((code >= 0x00280814) && (code <= 0x002808F4)) return PublicTag.kBitsForCodeWord;
    if ((code >= 0x00280818) && (code <= 0x002808F8)) return PublicTag.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((code >= 0x10000000) && (code <= 0x1000FFF0)) return PublicTag.kEscapeTriplet;
    // (1000,04X3)
    if ((code >= 0x10000001) && (code <= 0x1000FFF1)) return PublicTag.kRunLengthTriplet;
    // (1000,08x0)
    if ((code >= 0x10000002) && (code <= 0x1000FFF2)) return PublicTag.kHuffmanTableSize;
    // (1000,08x2)
    if ((code >= 0x10000003) && (code <= 0x1000FFF3))
      return PublicTag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((code >= 0x10000004) && (code <= 0x1000FFF4)) return PublicTag.kShiftTableSize;
    // (1000,08x4)
    if ((code >= 0x10000005) && (code <= 0x1000FFF5)) return PublicTag.kShiftTableTriplet;
    // (1000,08x8)
    if ((code >= 0x10100000) && (code <= 0x1010FFFF)) return PublicTag.kZonalMap;

    //Urgent: 0x50xx,yyyy Elements
    //Urgent: 0x60xx,yyyy Elements
    //Urgent: 0x7Fxx,yyyy Elements

    // No match return [null]
    return tagCodeError(code);
  }

  //TODO: make keyword lookup work
  static PublicTag lookupKeyword(String keyword, [bool shouldThrow = true]) {
    PublicTag tag = publicTagKeywordMap[keyword];
    if (tag != null) return tag;

    // Retired _special case_ keywords that still must be handled
/* TODO: figure out what to do with this? remove?
    // (0020,31xx)
    if ((keyword >= 0x00283100) && (keyword <= 0x002031FF)) return PublicTag.kSourceImageIDs;

    // (0028,04X0)
    if ((keyword >= 0x00280410) && (keyword <= 0x002804F0))
      return PublicTag.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((keyword >= 0x00280411) && (keyword <= 0x002804F1))
      return PublicTag.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((keyword >= 0x00280412) && (keyword <= 0x002804F2)) return PublicTag.kCoefficientCoding;
    // (0028,04X3)
    if ((keyword >= 0x00280413) && (keyword <= 0x002804F3))
      return PublicTag.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((keyword >= 0x00280810) && (keyword <= 0x002808F0)) return PublicTag.kCodeLabel;
    // (0028,08x2)
    if ((keyword >= 0x00280812) && (keyword <= 0x002808F2)) return PublicTag.kNumberOfTables;
    // (0028,08x3)
    if ((keyword >= 0x00280813) && (keyword <= 0x002808F3)) return PublicTag.kCodeTableLocation;
    // (0028,08x4)
    if ((keyword >= 0x00280814) && (keyword <= 0x002808F4)) return PublicTag.kBitsForCodeWord;
    // (0028,08x8)
    if ((keyword >= 0x00280818) && (keyword <= 0x002808F8)) return PublicTag.kImageDataLocation;

    // **** (1000,xxxy ****
    // (1000,04X2)
    if ((keyword >= 0x10000000) && (keyword <= 0x1000FFF0)) return PublicTag.kEscapeTriplet;
    // (1000,04X3)
    if ((keyword >= 0x10000001) && (keyword <= 0x1000FFF1)) return PublicTag.kRunLengthTriplet;
    // (1000,08x0)
    if ((keyword >= 0x10000002) && (keyword <= 0x1000FFF2)) return PublicTag.kHuffmanTableSize;
    // (1000,08x2)
    if ((keyword >= 0x10000003) && (keyword <= 0x1000FFF3))
      return PublicTag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((keyword >= 0x10000004) && (keyword <= 0x1000FFF4)) return PublicTag.kShiftTableSize;
    // (1000,08x4)
    if ((keyword >= 0x10000005) && (keyword <= 0x1000FFF5)) return PublicTag.kShiftTableTriplet;
    // (1000,08x8)
    if ((keyword >= 0x10100000) && (keyword <= 0x1010FFFF)) return PublicTag.kZonalMap;

    //TODO: 0x50xx,yyyy Elements
    //TODO: 0x60xx,yyyy Elements
    //TODO: 0x7Fxx,yyyy Elements
*/
    // No match return [null]
    return tagKeywordError(keyword);
  }

  //**** Message Data Elements begin here ****
  static const PublicTag kAffectedSOPInstanceUID = const PublicTag(
      "AffectedSOPInstanceUID",
      0x00001000,
      "Affected SOP Instance UID ",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kRequestedSOPInstanceUID = const PublicTag(
      "RequestedSOPInstanceUID",
      0x00001001,
      "Requested SOP Instance UID",
      VR.kUI,
      VM.k1,
      false);

  //**** File Meta Information Data Elements begin here ****
  static const PublicTag kFileMetaInformationGroupLength = const PublicTag(
      "FileMetaInformationGroupLength",
      0x00020000,
      "File Meta Information Group Length",
      VR.kUL,
      VM.k1,
      false);

  static const PublicTag kFileMetaInformationVersion = const PublicTag(
      "FileMetaInformationVersion",
      0x00020001,
      "File Meta Information Version",
      VR.kOB,
      VM.k1,
      false);

  static const PublicTag kMediaStorageSOPClassUID = const PublicTag(
      "MediaStorageSOPClassUID",
      0x00020002,
      "Media Storage SOP Class UID",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kMediaStorageSOPInstanceUID = const PublicTag(
      "MediaStorageSOPInstanceUID",
      0x00020003,
      "Media Storage SOP Instance UID",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kTransferSyntaxUID = const PublicTag(
      "TransferSyntaxUID", 0x00020010, "Transfer Syntax UID", VR.kUI, VM.k1, false);

  static const PublicTag kImplementationClassUID = const PublicTag(
      "ImplementationClassUID",
      0x00020012,
      "Implementation Class UID",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kImplementationVersionName = const PublicTag(
      "ImplementationVersionName",
      0x00020013,
      "Implementation Version Name",
      VR.kSH,
      VM.k1,
      false);

  static const PublicTag kSourceApplicationEntityTitle = const PublicTag(
      "SourceApplicationEntityTitle",
      0x00020016,
      "Source ApplicationEntity Title",
      VR.kAE,
      VM.k1,
      false);

  static const PublicTag kSendingApplicationEntityTitle = const PublicTag(
      "SendingApplicationEntityTitle",
      0x00020017,
      "Sending Application Entity Title",
      VR.kAE,
      VM.k1,
      false);

  static const PublicTag kReceivingApplicationEntityTitle = const PublicTag(
      "ReceivingApplicationEntityTitle",
      0x00020018,
      "Receiving Application Entity Title",
      VR.kAE,
      VM.k1,
      false);

  static const PublicTag kPrivateInformationCreatorUID = const PublicTag(
      "PrivateInformationCreatorUID",
      0x00020100,
      "Private Information Creator UID",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kPrivateInformation = const PublicTag(
      "PrivateInformation", 0x00020102, "Private Information", VR.kOB, VM.k1, false);

  //**** DICOM Directory Tags begin here ****
  static const PublicTag kFileSetID =
      const PublicTag("FileSetID", 0x00041130, "File-set ID", VR.kCS, VM.k1, false);

  static const PublicTag kFileSetDescriptorFileID = const PublicTag(
      "FileSetDescriptorFileID",
      0x00041141,
      "File-set Descriptor File ID",
      VR.kCS,
      VM.k1_8,
      false);

  static const PublicTag kSpecificCharacterSetOfFileSetDescriptorFile = const PublicTag(
      "SpecificCharacterSetOfFileSetDescriptorFile",
      0x00041142,
      "Specific Character Set of File Set Descriptor File",
      VR.kCS,
      VM.k1,
      false);

  static const PublicTag kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity =
      const PublicTag(
          "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
          0x00041200,
          "Offset of the First Directory Record of the Root Directory Entity",
          VR.kUL,
          VM.k1,
          false);

  static const PublicTag kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity =
      const PublicTag(
          "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
          0x00041202,
          "Offset of the Last Directory Record of the Root Directory Entity",
          VR.kUL,
          VM.k1,
          false);

  static const PublicTag kFileSetConsistencyFlag = const PublicTag(
      "FileSetConsistencyFlag",
      0x00041212,
      "File-set Consistency Flag",
      VR.kUS,
      VM.k1,
      false);

  static const PublicTag kDirectoryRecordSequence = const PublicTag(
      "DirectoryRecordSequence",
      0x00041220,
      "Directory Record Sequence",
      VR.kSQ,
      VM.k1,
      false);

  static const PublicTag kOffsetOfTheNextDirectoryRecord = const PublicTag(
      "OffsetOfTheNextDirectoryRecord",
      0x00041400,
      "Offset of the Next Directory Record",
      VR.kUL,
      VM.k1,
      false);

  static const PublicTag kRecordInUseFlag = const PublicTag(
      "RecordInUseFlag", 0x00041410, "Record In-use Flag", VR.kUS, VM.k1, false);

  static const PublicTag kOffsetOfReferencedLowerLevelDirectoryEntity = const PublicTag(
      "OffsetOfReferencedLowerLevelDirectoryEntity",
      0x00041420,
      "Offset of Referenced Lower-Level Directory Entity",
      VR.kUL,
      VM.k1,
      false);

  static const PublicTag kDirectoryRecordType = const PublicTag(
      "DirectoryRecordType", 0x00041430, "Directory​Record​Type", VR.kCS, VM.k1, false);

  static const PublicTag kPrivateRecordUID = const PublicTag(
      "PrivateRecordUID", 0x00041432, "Private Record UID", VR.kUI, VM.k1, false);

  static const PublicTag kReferencedFileID = const PublicTag(
      "ReferencedFileID", 0x00041500, "Referenced File ID", VR.kCS, VM.k1_8, false);

  static const PublicTag kMRDRDirectoryRecordOffset = const PublicTag(
      "MRDRDirectoryRecordOffset",
      0x00041504,
      "MRDR Directory Record Offset",
      VR.kUL,
      VM.k1,
      true);

  static const PublicTag kReferencedSOPClassUIDInFile = const PublicTag(
      "ReferencedSOPClassUIDInFile",
      0x00041510,
      "Referenced SOP Class UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kReferencedSOPInstanceUIDInFile = const PublicTag(
      "ReferencedSOPInstanceUIDInFile",
      0x00041511,
      "Referenced SOP Instance UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kReferencedTransferSyntaxUIDInFile = const PublicTag(
      "ReferencedTransferSyntaxUIDInFile",
      0x00041512,
      "Referenced Transfer Syntax UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const PublicTag kReferencedRelatedGeneralSOPClassUIDInFile = const PublicTag(
      "ReferencedRelatedGeneralSOPClassUIDInFile",
      0x0004151a,
      "Referenced Related General SOP Class UID in File",
      VR.kUI,
      VM.k1_n,
      false);

  static const PublicTag kNumberOfReferences = const PublicTag(
      "NumberOfReferences", 0x00041600, "Number of References", VR.kUL, VM.k1, true);

  //**** Standard Dataset Tags begin here ****

  static const PublicTag kLengthToEnd
      //(0008,0001) "00080001"
      = const PublicTag("LengthToEnd", 0x00080001, "Length to End", VR.kUL, VM.k1, true);
  static const PublicTag kSpecificCharacterSet
      //(0008,0005)
      = const PublicTag("SpecificCharacterSet", 0x00080005, "Specific Character Set",
          VR.kCS, VM.k1_n, false);
  static const PublicTag kLanguageCodeSequence
      //(0008,0006)
      = const PublicTag("LanguageCodeSequence", 0x00080006, "Language Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kImageType
      //(0008,0008)
      = const PublicTag("ImageType", 0x00080008, "Image Type", VR.kCS, VM.k2_n, false);
  static const PublicTag kRecognitionCode
      //(0008,0010)
      = const PublicTag(
          "RecognitionCode", 0x00080010, "Recognition Code", VR.kSH, VM.k1, true);
  static const PublicTag kInstanceCreationDate
      //(0008,0012)
      = const PublicTag("InstanceCreationDate", 0x00080012, "Instance Creation Date",
          VR.kDA, VM.k1, false);
  static const PublicTag kInstanceCreationTime
      //(0008,0013)
      = const PublicTag("InstanceCreationTime", 0x00080013, "Instance Creation Time",
          VR.kTM, VM.k1, false);
  static const PublicTag kInstanceCreatorUID
      //(0008,0014)
      = const PublicTag(
          "InstanceCreatorUID", 0x00080014, "Instance Creator UID", VR.kUI, VM.k1, false);
  static const PublicTag kInstanceCoercionDateTime
      //(0008,0015)
      = const PublicTag("InstanceCoercionDateTime", 0x00080015,
          "Instance Coercion DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kSOPClassUID
      //(0008,0016)
      = const PublicTag("SOPClassUID", 0x00080016, "SOP Class UID", VR.kUI, VM.k1, false);
  static const PublicTag kSOPInstanceUID
      //(0008,0018)
      = const PublicTag(
          "SOPInstanceUID", 0x00080018, "SOP Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kRelatedGeneralSOPClassUID
      //(0008,001A)
      = const PublicTag("RelatedGeneralSOPClassUID", 0x0008001A,
          "Related General SOP Class UID", VR.kUI, VM.k1_n, false);
  static const PublicTag kOriginalSpecializedSOPClassUID
      //(0008,001B)
      = const PublicTag("OriginalSpecializedSOPClassUID", 0x0008001B,
          "Original Specialized SOP Class UID", VR.kUI, VM.k1, false);
  static const PublicTag kStudyDate
      //(0008,0020)
      = const PublicTag("StudyDate", 0x00080020, "Study Date", VR.kDA, VM.k1, false);
  static const PublicTag kSeriesDate
      //(0008,0021)
      = const PublicTag("SeriesDate", 0x00080021, "Series Date", VR.kDA, VM.k1, false);
  static const PublicTag kAcquisitionDate
      //(0008,0022)
      = const PublicTag(
          "AcquisitionDate", 0x00080022, "Acquisition Date", VR.kDA, VM.k1, false);
  static const PublicTag kContentDate
      //(0008,0023)
      = const PublicTag("ContentDate", 0x00080023, "Content Date", VR.kDA, VM.k1, false);
  static const PublicTag kOverlayDate
      //(0008,0024)
      = const PublicTag("OverlayDate", 0x00080024, "Overlay Date", VR.kDA, VM.k1, true);
  static const PublicTag kCurveDate
      //(0008,0025)
      = const PublicTag("CurveDate", 0x00080025, "Curve Date", VR.kDA, VM.k1, true);
  static const PublicTag kAcquisitionDateTime
      //(0008,002A)
      = const PublicTag("AcquisitionDateTime", 0x0008002A, "Acquisition DateTime", VR.kDT,
          VM.k1, false);
  static const PublicTag kStudyTime
      //(0008,0030)
      = const PublicTag("StudyTime", 0x00080030, "Study Time", VR.kTM, VM.k1, false);
  static const PublicTag kSeriesTime
      //(0008,0031)
      = const PublicTag("SeriesTime", 0x00080031, "Series Time", VR.kTM, VM.k1, false);
  static const PublicTag kAcquisitionTime
      //(0008,0032)
      = const PublicTag(
          "AcquisitionTime", 0x00080032, "Acquisition Time", VR.kTM, VM.k1, false);
  static const PublicTag kContentTime
      //(0008,0033)
      = const PublicTag("ContentTime", 0x00080033, "Content Time", VR.kTM, VM.k1, false);
  static const PublicTag kOverlayTime
      //(0008,0034)
      = const PublicTag("OverlayTime", 0x00080034, "Overlay Time", VR.kTM, VM.k1, true);
  static const PublicTag kCurveTime
      //(0008,0035)
      = const PublicTag("CurveTime", 0x00080035, "Curve Time", VR.kTM, VM.k1, true);
  static const PublicTag kDataSetType
      //(0008,0040)
      = const PublicTag("DataSetType", 0x00080040, "Data Set Type", VR.kUS, VM.k1, true);
  static const PublicTag kDataSetSubtype
      //(0008,0041)
      = const PublicTag(
          "DataSetSubtype", 0x00080041, "Data Set Subtype", VR.kLO, VM.k1, true);
  static const PublicTag kNuclearMedicineSeriesType
      //(0008,0042)
      = const PublicTag("NuclearMedicineSeriesType", 0x00080042,
          "Nuclear Medicine Series Type", VR.kCS, VM.k1, true);
  static const PublicTag kAccessionNumber
      //(0008,0050)
      = const PublicTag(
          "AccessionNumber", 0x00080050, "Accession Number", VR.kSH, VM.k1, false);
  static const PublicTag kIssuerOfAccessionNumberSequence
      //(0008,0051)
      = const PublicTag("IssuerOfAccessionNumberSequence", 0x00080051,
          "Issuer of Accession Number Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kQueryRetrieveLevel
      //(0008,0052)
      = const PublicTag(
          "QueryRetrieveLevel", 0x00080052, "Query/Retrieve Level", VR.kCS, VM.k1, false);
  static const PublicTag kQueryRetrieveView
      //(0008,0053)
      = const PublicTag(
          "QueryRetrieveView", 0x00080053, "Query/Retrieve View", VR.kCS, VM.k1, false);
  static const PublicTag kRetrieveAETitle
      //(0008,0054)
      = const PublicTag(
          "RetrieveAETitle", 0x00080054, "Retrieve AE Title", VR.kAE, VM.k1_n, false);
  static const PublicTag kInstanceAvailability
      //(0008,0056)
      = const PublicTag("InstanceAvailability", 0x00080056, "Instance Availability",
          VR.kCS, VM.k1, false);
  static const PublicTag kFailedSOPInstanceUIDList
      //(0008,0058)
      = const PublicTag("FailedSOPInstanceUIDList", 0x00080058,
          "Failed SOP Instance UID List", VR.kUI, VM.k1_n, false);
  static const PublicTag kModality
      //(0008,0060)
      = const PublicTag("Modality", 0x00080060, "Modality", VR.kCS, VM.k1, false);
  static const PublicTag kModalitiesInStudy
      //(0008,0061)
      = const PublicTag(
          "ModalitiesInStudy", 0x00080061, "Modalities in Study", VR.kCS, VM.k1_n, false);
  static const PublicTag kSOPClassesInStudy
      //(0008,0062)
      = const PublicTag("SOPClassesInStudy", 0x00080062, "SOP Classes in Study", VR.kUI,
          VM.k1_n, false);
  static const PublicTag kConversionType
      //(0008,0064)
      = const PublicTag(
          "ConversionType", 0x00080064, "Conversion Type", VR.kCS, VM.k1, false);
  static const PublicTag kPresentationIntentType
      //(0008,0068)
      = const PublicTag("PresentationIntentType", 0x00080068, "Presentation Intent Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kManufacturer
      //(0008,0070)
      = const PublicTag("Manufacturer", 0x00080070, "Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kInstitutionName
      //(0008,0080)
      = const PublicTag(
          "InstitutionName", 0x00080080, "Institution Name", VR.kLO, VM.k1, false);
  static const PublicTag kInstitutionAddress
      //(0008,0081)
      = const PublicTag(
          "InstitutionAddress", 0x00080081, "Institution Address", VR.kST, VM.k1, false);
  static const PublicTag kInstitutionCodeSequence
      //(0008,0082)
      = const PublicTag("InstitutionCodeSequence", 0x00080082,
          "Institution Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferringPhysicianName
      //(0008,0090)
      = const PublicTag("ReferringPhysicianName", 0x00080090,
          "Referring Physician's Name", VR.kPN, VM.k1, false);
  static const PublicTag kReferringPhysicianAddress
      //(0008,0092)
      = const PublicTag("ReferringPhysicianAddress", 0x00080092,
          "Referring Physician's Address", VR.kST, VM.k1, false);
  static const PublicTag kReferringPhysicianTelephoneNumbers
      //(0008,0094)
      = const PublicTag("ReferringPhysicianTelephoneNumbers", 0x00080094,
          "Referring Physician's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const PublicTag kReferringPhysicianIdentificationSequence
      //(0008,0096)
      = const PublicTag("ReferringPhysicianIdentificationSequence", 0x00080096,
          "Referring Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCodeValue
      //(0008,0100)
      = const PublicTag("CodeValue", 0x00080100, "Code Value", VR.kSH, VM.k1, false);
  static const PublicTag kExtendedCodeValue
      //(0008,0101)
      = const PublicTag(
          "ExtendedCodeValue", 0x00080101, "Extended Code Value", VR.kLO, VM.k1, false);
  static const PublicTag kCodingSchemeDesignator
      //(0008,0102)
      = const PublicTag("CodingSchemeDesignator", 0x00080102, "Coding Scheme Designator",
          VR.kSH, VM.k1, false);
  static const PublicTag kCodingSchemeVersion
      //(0008,0103)
      = const PublicTag("CodingSchemeVersion", 0x00080103, "Coding Scheme Version",
          VR.kSH, VM.k1, false);
  static const PublicTag kCodeMeaning
      //(0008,0104)
      = const PublicTag("CodeMeaning", 0x00080104, "Code Meaning", VR.kLO, VM.k1, false);
  static const PublicTag kMappingResource
      //(0008,0105)
      = const PublicTag(
          "MappingResource", 0x00080105, "Mapping Resource", VR.kCS, VM.k1, false);
  static const PublicTag kContextGroupVersion
      //(0008,0106)
      = const PublicTag("ContextGroupVersion", 0x00080106, "Context Group Version",
          VR.kDT, VM.k1, false);
  static const PublicTag kContextGroupLocalVersion
      //(0008,0107)
      = const PublicTag("ContextGroupLocalVersion", 0x00080107,
          "Context Group Local Version", VR.kDT, VM.k1, false);
  static const PublicTag kExtendedCodeMeaning
      //(0008,0108)
      = const PublicTag("ExtendedCodeMeaning", 0x00080108, "Extended Code Meaning",
          VR.kLT, VM.k1, false);
  static const PublicTag kContextGroupExtensionFlag
      //(0008,010B)
      = const PublicTag("ContextGroupExtensionFlag", 0x0008010B,
          "Context Group Extension Flag", VR.kCS, VM.k1, false);
  static const PublicTag kCodingSchemeUID
      //(0008,010C)
      = const PublicTag(
          "CodingSchemeUID", 0x0008010C, "Coding Scheme UID", VR.kUI, VM.k1, false);
  static const PublicTag kContextGroupExtensionCreatorUID
      //(0008,010D)
      = const PublicTag("ContextGroupExtensionCreatorUID", 0x0008010D,
          "Context Group Extension Creator UID", VR.kUI, VM.k1, false);
  static const PublicTag kContextIdentifier
      //(0008,010F)
      = const PublicTag(
          "ContextIdentifier", 0x0008010F, "Context Identifier", VR.kCS, VM.k1, false);
  static const PublicTag kCodingSchemeIdentificationSequence
      //(0008,0110)
      = const PublicTag("CodingSchemeIdentificationSequence", 0x00080110,
          "Coding Scheme Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCodingSchemeRegistry
      //(0008,0112)
      = const PublicTag("CodingSchemeRegistry", 0x00080112, "Coding Scheme Registry",
          VR.kLO, VM.k1, false);
  static const PublicTag kCodingSchemeExternalID
      //(0008,0114)
      = const PublicTag("CodingSchemeExternalID", 0x00080114, "Coding Scheme External ID",
          VR.kST, VM.k1, false);
  static const PublicTag kCodingSchemeName
      //(0008,0115)
      = const PublicTag(
          "CodingSchemeName", 0x00080115, "Coding Scheme Name", VR.kST, VM.k1, false);
  static const PublicTag kCodingSchemeResponsibleOrganization
      //(0008,0116)
      = const PublicTag("CodingSchemeResponsibleOrganization", 0x00080116,
          "Coding Scheme Responsible Organization", VR.kST, VM.k1, false);
  static const PublicTag kContextUID
      //(0008,0117)
      = const PublicTag("ContextUID", 0x00080117, "Context UID", VR.kUI, VM.k1, false);
  static const PublicTag kTimezoneOffsetFromUTC
      //(0008,0201)
      = const PublicTag("TimezoneOffsetFromUTC", 0x00080201, "Timezone Offset From UTC",
          VR.kSH, VM.k1, false);

  static const PublicTag kPrivateDataElementCharacteristicsSequence = const PublicTag(
      "PrivateDataElementCharacteristicsSequence",
      0x0080300,
      "Private​Data​Element​Characteristics​Sequence",
      VR.kSQ,
      VM.k1,
      false);

  static const PublicTag kPrivateGroupReference = const PublicTag("PrivateGroupReference",
      0x00080301, "Private Group Reference", VR.kUS, VM.k1, false);

  static const PublicTag kPrivateCreatorReference = const PublicTag(
      "PrivateCreatorReference",
      0x00080302,
      "Private Creator Reference",
      VR.kLO,
      VM.k1,
      false);

  static const PublicTag kBlockIdentifyingInformationStatus = const PublicTag(
      "BlockIdentifyingInformationStatus",
      0x00080303,
      "Block Identifying Information Status",
      VR.kCS,
      VM.k1,
      false);

  static const PublicTag kNonidentifyingPrivateElements = const PublicTag(
      "NonidentifyingPrivateElements",
      0x00080304,
      "Nonidentifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const PublicTag kDeidentificationActionSequence = const PublicTag(
      "DeidentificationActionSequence",
      0x00080305,
      "Deidentification Action Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const PublicTag kIdentifyingPrivateElements = const PublicTag(
      "IdentifyingPrivateElements",
      0x00080306,
      "Identifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const PublicTag kDeidentificationAction = const PublicTag(
      "DeidentificationAction",
      0x00080307,
      "Deidentification Action",
      VR.kCS,
      VM.k1,
      false);
  static const PublicTag kNetworkID
      //(0008,1000)
      = const PublicTag("NetworkID", 0x00081000, "Network ID", VR.kAE, VM.k1, true);
  static const PublicTag kStationName
      //(0008,1010)
      = const PublicTag("StationName", 0x00081010, "Station Name", VR.kSH, VM.k1, false);
  static const PublicTag kStudyDescription
      //(0008,1030)
      = const PublicTag(
          "StudyDescription", 0x00081030, "Study Description", VR.kLO, VM.k1, false);
  static const PublicTag kProcedureCodeSequence
      //(0008,1032)
      = const PublicTag("ProcedureCodeSequence", 0x00081032, "Procedure Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kSeriesDescription
      //(0008,103E)
      = const PublicTag(
          "SeriesDescription", 0x0008103E, "Series Description", VR.kLO, VM.k1, false);
  static const PublicTag kSeriesDescriptionCodeSequence
      //(0008,103F)
      = const PublicTag("SeriesDescriptionCodeSequence", 0x0008103F,
          "Series Description Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInstitutionalDepartmentName
      //(0008,1040)
      = const PublicTag("InstitutionalDepartmentName", 0x00081040,
          "Institutional Department Name", VR.kLO, VM.k1, false);
  static const PublicTag kPhysiciansOfRecord
      //(0008,1048)
      = const PublicTag("PhysiciansOfRecord", 0x00081048, "Physician(s) of Record",
          VR.kPN, VM.k1_n, false);
  static const PublicTag kPhysiciansOfRecordIdentificationSequence
      //(0008,1049)
      = const PublicTag("PhysiciansOfRecordIdentificationSequence", 0x00081049,
          "Physician(s) of Record Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformingPhysicianName
      //(0008,1050)
      = const PublicTag("PerformingPhysicianName", 0x00081050,
          "Performing Physician's Name", VR.kPN, VM.k1_n, false);
  static const PublicTag kPerformingPhysicianIdentificationSequence
      //(0008,1052)
      = const PublicTag("PerformingPhysicianIdentificationSequence", 0x00081052,
          "Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNameOfPhysiciansReadingStudy
      //(0008,1060)
      = const PublicTag("NameOfPhysiciansReadingStudy", 0x00081060,
          "Name of Physician(s) Reading Study", VR.kPN, VM.k1_n, false);
  static const PublicTag kPhysiciansReadingStudyIdentificationSequence
      //(0008,1062)
      = const PublicTag("PhysiciansReadingStudyIdentificationSequence", 0x00081062,
          "Physician(s) Reading Study Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOperatorsName
      //(0008,1070)
      = const PublicTag(
          "OperatorsName", 0x00081070, "Operators' Name", VR.kPN, VM.k1_n, false);
  static const PublicTag kOperatorIdentificationSequence
      //(0008,1072)
      = const PublicTag("OperatorIdentificationSequence", 0x00081072,
          "Operator Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAdmittingDiagnosesDescription
      //(0008,1080)
      = const PublicTag("AdmittingDiagnosesDescription", 0x00081080,
          "Admitting Diagnoses Description", VR.kLO, VM.k1_n, false);
  static const PublicTag kAdmittingDiagnosesCodeSequence
      //(0008,1084)
      = const PublicTag("AdmittingDiagnosesCodeSequence", 0x00081084,
          "Admitting Diagnoses Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kManufacturerModelName
      //(0008,1090)
      = const PublicTag("ManufacturerModelName", 0x00081090, "Manufacturer's Model Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kReferencedResultsSequence
      //(0008,1100)
      = const PublicTag("ReferencedResultsSequence", 0x00081100,
          "Referenced Results Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedStudySequence
      //(0008,1110)
      = const PublicTag("ReferencedStudySequence", 0x00081110,
          "Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedPerformedProcedureStepSequence
      //(0008,1111)
      = const PublicTag("ReferencedPerformedProcedureStepSequence", 0x00081111,
          "Referenced Performed Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSeriesSequence
      //(0008,1115)
      = const PublicTag("ReferencedSeriesSequence", 0x00081115,
          "Referenced Series Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedPatientSequence
      //(0008,1120)
      = const PublicTag("ReferencedPatientSequence", 0x00081120,
          "Referenced Patient Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedVisitSequence
      //(0008,1125)
      = const PublicTag("ReferencedVisitSequence", 0x00081125,
          "Referenced Visit Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedOverlaySequence
      //(0008,1130)
      = const PublicTag("ReferencedOverlaySequence", 0x00081130,
          "Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedStereometricInstanceSequence
      //(0008,1134)
      = const PublicTag("ReferencedStereometricInstanceSequence", 0x00081134,
          "Referenced Stereometric Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedWaveformSequence
      //(0008,113A)
      = const PublicTag("ReferencedWaveformSequence", 0x0008113A,
          "Referenced Waveform Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedImageSequence
      //(0008,1140)
      = const PublicTag("ReferencedImageSequence", 0x00081140,
          "Referenced Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedCurveSequence
      //(0008,1145)
      = const PublicTag("ReferencedCurveSequence", 0x00081145,
          "Referenced Curve Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedInstanceSequence
      //(0008,114A)
      = const PublicTag("ReferencedInstanceSequence", 0x0008114A,
          "Referenced Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedRealWorldValueMappingInstanceSequence
      //(0008,114B)
      = const PublicTag("ReferencedRealWorldValueMappingInstanceSequence", 0x0008114B,
          "Referenced Real World Value Mapping Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSOPClassUID
      //(0008,1150)
      = const PublicTag("ReferencedSOPClassUID", 0x00081150, "Referenced SOP Class UID",
          VR.kUI, VM.k1, false);
  static const PublicTag kReferencedSOPInstanceUID
      //(0008,1155)
      = const PublicTag("ReferencedSOPInstanceUID", 0x00081155,
          "Referenced SOP Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kSOPClassesSupported
      //(0008,115A)
      = const PublicTag("SOPClassesSupported", 0x0008115A, "SOP Classes Supported",
          VR.kUI, VM.k1_n, false);
  static const PublicTag kReferencedFrameNumber
      //(0008,1160)
      = const PublicTag("ReferencedFrameNumber", 0x00081160, "Referenced Frame Number",
          VR.kIS, VM.k1_n, false);
  static const PublicTag kSimpleFrameList
      //(0008,1161)
      = const PublicTag(
          "SimpleFrameList", 0x00081161, "Simple Frame List", VR.kUL, VM.k1_n, false);
  static const PublicTag kCalculatedFrameList
      //(0008,1162)
      = const PublicTag("CalculatedFrameList", 0x00081162, "Calculated Frame List",
          VR.kUL, VM.k3_3n, false);
  static const PublicTag kTimeRange
      //(0008,1163)
      = const PublicTag("TimeRange", 0x00081163, "TimeRange", VR.kFD, VM.k2, false);
  static const PublicTag kFrameExtractionSequence
      //(0008,1164)
      = const PublicTag("FrameExtractionSequence", 0x00081164,
          "Frame Extraction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMultiFrameSourceSOPInstanceUID
      //(0008,1167)
      = const PublicTag("MultiFrameSourceSOPInstanceUID", 0x00081167,
          "Multi-frame Source SOP Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kRetrieveURL
      //(0008,1190)
      = const PublicTag("RetrieveURL", 0x00081190, "Retrieve URL", VR.kUT, VM.k1, false);
  static const PublicTag kTransactionUID
      //(0008,1195)
      = const PublicTag(
          "TransactionUID", 0x00081195, "Transaction UID", VR.kUI, VM.k1, false);
  static const PublicTag kWarningReason
      //(0008,1196)
      = const PublicTag(
          "WarningReason", 0x00081196, "Warning Reason", VR.kUS, VM.k1, false);
  static const PublicTag kFailureReason
      //(0008,1197)
      = const PublicTag(
          "FailureReason", 0x00081197, "Failure Reason", VR.kUS, VM.k1, false);
  static const PublicTag kFailedSOPSequence
      //(0008,1198)
      = const PublicTag(
          "FailedSOPSequence", 0x00081198, "Failed SOP Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSOPSequence
      //(0008,1199)
      = const PublicTag("ReferencedSOPSequence", 0x00081199, "Referenced SOP Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kStudiesContainingOtherReferencedInstancesSequence
      //(0008,1200)
      = const PublicTag("StudiesContainingOtherReferencedInstancesSequence", 0x00081200,
          "Studies Containing Other Referenced Instances Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelatedSeriesSequence
      //(0008,1250)
      = const PublicTag("RelatedSeriesSequence", 0x00081250, "Related Series Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kLossyImageCompressionRetired
      //(0008,2110)
      = const PublicTag("LossyImageCompressionRetired", 0x00082110,
          "Lossy Image Compression (Retired)", VR.kCS, VM.k1, true);
  static const PublicTag kDerivationDescription
      //(0008,2111)
      = const PublicTag("DerivationDescription", 0x00082111, "Derivation Description",
          VR.kST, VM.k1, false);
  static const PublicTag kSourceImageSequence
      //(0008,2112)
      = const PublicTag("SourceImageSequence", 0x00082112, "Source Image Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kStageName
      //(0008,2120)
      = const PublicTag("StageName", 0x00082120, "Stage Name", VR.kSH, VM.k1, false);
  static const PublicTag kStageNumber
      //(0008,2122)
      = const PublicTag("StageNumber", 0x00082122, "Stage Number", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfStages
      //(0008,2124)
      = const PublicTag(
          "NumberOfStages", 0x00082124, "Number of Stages", VR.kIS, VM.k1, false);
  static const PublicTag kViewName
      //(0008,2127)
      = const PublicTag("ViewName", 0x00082127, "View Name", VR.kSH, VM.k1, false);
  static const PublicTag kViewNumber
      //(0008,2128)
      = const PublicTag("ViewNumber", 0x00082128, "View Number", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfEventTimers
      //(0008,2129)
      = const PublicTag("NumberOfEventTimers", 0x00082129, "Number of Event Timers",
          VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfViewsInStage
      //(0008,212A)
      = const PublicTag("NumberOfViewsInStage", 0x0008212A, "Number of Views in Stage",
          VR.kIS, VM.k1, false);
  static const PublicTag kEventElapsedTimes
      //(0008,2130)
      = const PublicTag("EventElapsedTimes", 0x00082130, "Event Elapsed Time(s)", VR.kDS,
          VM.k1_n, false);
  static const PublicTag kEventTimerNames
      //(0008,2132)
      = const PublicTag(
          "EventTimerNames", 0x00082132, "Event Timer Name(s)", VR.kLO, VM.k1_n, false);
  static const PublicTag kEventTimerSequence
      //(0008,2133)
      = const PublicTag(
          "EventTimerSequence", 0x00082133, "Event Timer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEventTimeOffset
      //(0008,2134)
      = const PublicTag(
          "EventTimeOffset", 0x00082134, "Event Time Offset", VR.kFD, VM.k1, false);
  static const PublicTag kEventCodeSequence
      //(0008,2135)
      = const PublicTag(
          "EventCodeSequence", 0x00082135, "Event Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStartTrim
      //(0008,2142)
      = const PublicTag("StartTrim", 0x00082142, "Start Trim", VR.kIS, VM.k1, false);
  static const PublicTag kStopTrim
      //(0008,2143)
      = const PublicTag("StopTrim", 0x00082143, "Stop Trim", VR.kIS, VM.k1, false);
  static const PublicTag kRecommendedDisplayFrameRate
      //(0008,2144)
      = const PublicTag("RecommendedDisplayFrameRate", 0x00082144,
          "Recommended Display Frame Rate", VR.kIS, VM.k1, false);
  static const PublicTag kTransducerPosition
      //(0008,2200)
      = const PublicTag(
          "TransducerPosition", 0x00082200, "Transducer Position", VR.kCS, VM.k1, true);
  static const PublicTag kTransducerOrientation
      //(0008,2204)
      = const PublicTag("TransducerOrientation", 0x00082204, "Transducer Orientation",
          VR.kCS, VM.k1, true);
  static const PublicTag kAnatomicStructure
      //(0008,2208)
      = const PublicTag(
          "AnatomicStructure", 0x00082208, "Anatomic Structure", VR.kCS, VM.k1, true);
  static const PublicTag kAnatomicRegionSequence
      //(0008,2218)
      = const PublicTag("AnatomicRegionSequence", 0x00082218, "Anatomic Region Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kAnatomicRegionModifierSequence
      //(0008,2220)
      = const PublicTag("AnatomicRegionModifierSequence", 0x00082220,
          "Anatomic Region Modifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrimaryAnatomicStructureSequence
      //(0008,2228)
      = const PublicTag("PrimaryAnatomicStructureSequence", 0x00082228,
          "Primary Anatomic Structure Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAnatomicStructureSpaceOrRegionSequence
      //(0008,2229)
      = const PublicTag("AnatomicStructureSpaceOrRegionSequence", 0x00082229,
          "Anatomic Structure: Space or Region Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrimaryAnatomicStructureModifierSequence
      //(0008,2230)
      = const PublicTag("PrimaryAnatomicStructureModifierSequence", 0x00082230,
          "Primary Anatomic Structure Modifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransducerPositionSequence
      //(0008,2240)
      = const PublicTag("TransducerPositionSequence", 0x00082240,
          "Transducer Position Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kTransducerPositionModifierSequence
      //(0008,2242)
      = const PublicTag("TransducerPositionModifierSequence", 0x00082242,
          "Transducer Position Modifier Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kTransducerOrientationSequence
      //(0008,2244)
      = const PublicTag("TransducerOrientationSequence", 0x00082244,
          "Transducer Orientation Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kTransducerOrientationModifierSequence
      //(0008,2246)
      = const PublicTag("TransducerOrientationModifierSequence", 0x00082246,
          "Transducer Orientation Modifier Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kAnatomicStructureSpaceOrRegionCodeSequenceTrial
      //(0008,2251)
      = const PublicTag(
          "AnatomicStructureSpaceOrRegionCodeSequenceTrial",
          0x00082251,
          "Anatomic Structure Space Or Region Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kAnatomicPortalOfEntranceCodeSequenceTrial
      //(0008,2253)
      = const PublicTag("AnatomicPortalOfEntranceCodeSequenceTrial", 0x00082253,
          "Anatomic Portal Of Entrance Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kAnatomicApproachDirectionCodeSequenceTrial
      //(0008,2255)
      = const PublicTag("AnatomicApproachDirectionCodeSequenceTrial", 0x00082255,
          "Anatomic Approach Direction Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kAnatomicPerspectiveDescriptionTrial
      //(0008,2256)
      = const PublicTag("AnatomicPerspectiveDescriptionTrial", 0x00082256,
          "Anatomic Perspective Description (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kAnatomicPerspectiveCodeSequenceTrial
      //(0008,2257)
      = const PublicTag("AnatomicPerspectiveCodeSequenceTrial", 0x00082257,
          "Anatomic Perspective Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kAnatomicLocationOfExaminingInstrumentDescriptionTrial
      //(0008,2258)
      = const PublicTag(
          "AnatomicLocationOfExaminingInstrumentDescriptionTrial",
          0x00082258,
          "Anatomic Location Of Examining Instrument Description (Trial)",
          VR.kST,
          VM.k1,
          true);
  static const PublicTag kAnatomicLocationOfExaminingInstrumentCodeSequenceTrial
      //(0008,2259)
      = const PublicTag(
          "AnatomicLocationOfExaminingInstrumentCodeSequenceTrial",
          0x00082259,
          "Anatomic Location Of Examining Instrument Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kAnatomicStructureSpaceOrRegionModifierCodeSequenceTrial
      //(0008,225A)
      = const PublicTag(
          "AnatomicStructureSpaceOrRegionModifierCodeSequenceTrial",
          0x0008225A,
          "Anatomic Structure Space Or Region Modifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kOnAxisBackgroundAnatomicStructureCodeSequenceTrial
      //(0008,225C)
      = const PublicTag(
          "OnAxisBackgroundAnatomicStructureCodeSequenceTrial",
          0x0008225C,
          "OnAxis Background Anatomic Structure Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kAlternateRepresentationSequence
      //(0008,3001)
      = const PublicTag("AlternateRepresentationSequence", 0x00083001,
          "Alternate Representation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIrradiationEventUID
      //(0008,3010)
      = const PublicTag("IrradiationEventUID", 0x00083010, "Irradiation Event UID",
          VR.kUI, VM.k1_n, false);
  static const PublicTag kIdentifyingComments
      //(0008,4000)
      = const PublicTag(
          "IdentifyingComments", 0x00084000, "Identifying Comments", VR.kLT, VM.k1, true);
  static const PublicTag kFrameType
      //(0008,9007)
      = const PublicTag("FrameType", 0x00089007, "Frame Type", VR.kCS, VM.k4, false);
  static const PublicTag kReferencedImageEvidenceSequence
      //(0008,9092)
      = const PublicTag("ReferencedImageEvidenceSequence", 0x00089092,
          "Referenced Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedRawDataSequence
      //(0008,9121)
      = const PublicTag("ReferencedRawDataSequence", 0x00089121,
          "Referenced Raw Data Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCreatorVersionUID
      //(0008,9123)
      = const PublicTag(
          "CreatorVersionUID", 0x00089123, "Creator-Version UID", VR.kUI, VM.k1, false);
  static const PublicTag kDerivationImageSequence
      //(0008,9124)
      = const PublicTag("DerivationImageSequence", 0x00089124,
          "Derivation Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceImageEvidenceSequence
      //(0008,9154)
      = const PublicTag("SourceImageEvidenceSequence", 0x00089154,
          "Source Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPixelPresentation
      //(0008,9205)
      = const PublicTag(
          "PixelPresentation", 0x00089205, "Pixel Presentation", VR.kCS, VM.k1, false);
  static const PublicTag kVolumetricProperties
      //(0008,9206)
      = const PublicTag("VolumetricProperties", 0x00089206, "Volumetric Properties",
          VR.kCS, VM.k1, false);
  static const PublicTag kVolumeBasedCalculationTechnique
      //(0008,9207)
      = const PublicTag("VolumeBasedCalculationTechnique", 0x00089207,
          "Volume Based Calculation Technique", VR.kCS, VM.k1, false);
  static const PublicTag kComplexImageComponent
      //(0008,9208)
      = const PublicTag("ComplexImageComponent", 0x00089208, "Complex Image Component",
          VR.kCS, VM.k1, false);
  static const PublicTag kAcquisitionContrast
      //(0008,9209)
      = const PublicTag("AcquisitionContrast", 0x00089209, "Acquisition Contrast", VR.kCS,
          VM.k1, false);
  static const PublicTag kDerivationCodeSequence
      //(0008,9215)
      = const PublicTag("DerivationCodeSequence", 0x00089215, "Derivation Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedPresentationStateSequence
      //(0008,9237)
      = const PublicTag("ReferencedPresentationStateSequence", 0x00089237,
          "Referenced Presentation State Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedOtherPlaneSequence
      //(0008,9410)
      = const PublicTag("ReferencedOtherPlaneSequence", 0x00089410,
          "Referenced Other Plane Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFrameDisplaySequence
      //(0008,9458)
      = const PublicTag("FrameDisplaySequence", 0x00089458, "Frame Display Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRecommendedDisplayFrameRateInFloat
      //(0008,9459)
      = const PublicTag("RecommendedDisplayFrameRateInFloat", 0x00089459,
          "Recommended Display Frame Rate in Float", VR.kFL, VM.k1, false);
  static const PublicTag kSkipFrameRangeFlag
      //(0008,9460)
      = const PublicTag("SkipFrameRangeFlag", 0x00089460, "Skip Frame Range Flag", VR.kCS,
          VM.k1, false);
  static const PublicTag kPatientName
      //(0010,0010)
      =
      const PublicTag("PatientName", 0x00100010, "Patient's Name", VR.kPN, VM.k1, false);
  static const PublicTag kPatientID
      //(0010,0020)
      = const PublicTag("PatientID", 0x00100020, "Patient ID", VR.kLO, VM.k1, false);
  static const PublicTag kIssuerOfPatientID
      //(0010,0021)
      = const PublicTag(
          "IssuerOfPatientID", 0x00100021, "Issuer of Patient ID", VR.kLO, VM.k1, false);
  static const PublicTag kTypeOfPatientID
      //(0010,0022)
      = const PublicTag(
          "TypeOfPatientID", 0x00100022, "Type of Patient ID", VR.kCS, VM.k1, false);
  static const PublicTag kIssuerOfPatientIDQualifiersSequence
      //(0010,0024)
      = const PublicTag("IssuerOfPatientIDQualifiersSequence", 0x00100024,
          "Issuer of Patient ID Qualifiers Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientBirthDate
      //(0010,0030)
      = const PublicTag(
          "PatientBirthDate", 0x00100030, "Patient's Birth Date", VR.kDA, VM.k1, false);
  static const PublicTag kPatientBirthTime
      //(0010,0032)
      = const PublicTag(
          "PatientBirthTime", 0x00100032, "Patient's Birth Time", VR.kTM, VM.k1, false);
  static const PublicTag kPatientSex
      //(0010,0040)
      = const PublicTag("PatientSex", 0x00100040, "Patient's Sex", VR.kCS, VM.k1, false);
  static const PublicTag kPatientInsurancePlanCodeSequence
      //(0010,0050)
      = const PublicTag("PatientInsurancePlanCodeSequence", 0x00100050,
          "Patient's Insurance Plan Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientPrimaryLanguageCodeSequence
      //(0010,0101)
      = const PublicTag("PatientPrimaryLanguageCodeSequence", 0x00100101,
          "Patient's Primary Language Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientPrimaryLanguageModifierCodeSequence
      //(0010,0102)
      = const PublicTag("PatientPrimaryLanguageModifierCodeSequence", 0x00100102,
          "Patient's Primary Language Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kQualityControlSubject
      //(0010,0200)
      = const PublicTag("QualityControlSubject", 0x00100200, "Quality Control Subject",
          VR.kCS, VM.k1, false);
  static const PublicTag kQualityControlSubjectTypeCodeSequence
      //(0010,0201)
      = const PublicTag("QualityControlSubjectTypeCodeSequence", 0x00100201,
          "Quality Control Subject Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOtherPatientIDs
      //(0010,1000)
      = const PublicTag(
          "OtherPatientIDs", 0x00101000, "Other Patient IDs", VR.kLO, VM.k1_n, false);
  static const PublicTag kOtherPatientNames
      //(0010,1001)
      = const PublicTag(
          "OtherPatientNames", 0x00101001, "Other Patient Names", VR.kPN, VM.k1_n, false);
  static const PublicTag kOtherPatientIDsSequence
      //(0010,1002)
      = const PublicTag("OtherPatientIDsSequence", 0x00101002,
          "Other Patient IDs Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientBirthName
      //(0010,1005)
      = const PublicTag(
          "PatientBirthName", 0x00101005, "Patient's Birth Name", VR.kPN, VM.k1, false);
  static const PublicTag kPatientAge
      //(0010,1010)
      = const PublicTag("PatientAge", 0x00101010, "Patient's Age", VR.kAS, VM.k1, false);
  static const PublicTag kPatientSize
      //(0010,1020)
      =
      const PublicTag("PatientSize", 0x00101020, "Patient's Size", VR.kDS, VM.k1, false);
  static const PublicTag kPatientSizeCodeSequence
      //(0010,1021)
      = const PublicTag("PatientSizeCodeSequence", 0x00101021,
          "Patient's Size Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientWeight
      //(0010,1030)
      = const PublicTag(
          "PatientWeight", 0x00101030, "Patient's Weight", VR.kDS, VM.k1, false);
  static const PublicTag kPatientAddress
      //(0010,1040)
      = const PublicTag(
          "PatientAddress", 0x00101040, "Patient's Address", VR.kLO, VM.k1, false);
  static const PublicTag kInsurancePlanIdentification
      //(0010,1050)
      = const PublicTag("InsurancePlanIdentification", 0x00101050,
          "Insurance Plan Identification", VR.kLO, VM.k1_n, true);
  static const PublicTag kPatientMotherBirthName
      //(0010,1060)
      = const PublicTag("PatientMotherBirthName", 0x00101060,
          "Patient's Mother's Birth Name", VR.kPN, VM.k1, false);
  static const PublicTag kMilitaryRank
      //(0010,1080)
      =
      const PublicTag("MilitaryRank", 0x00101080, "Military Rank", VR.kLO, VM.k1, false);
  static const PublicTag kBranchOfService
      //(0010,1081)
      = const PublicTag(
          "BranchOfService", 0x00101081, "Branch of Service", VR.kLO, VM.k1, false);
  static const PublicTag kMedicalRecordLocator
      //(0010,1090)
      = const PublicTag("MedicalRecordLocator", 0x00101090, "Medical Record Locator",
          VR.kLO, VM.k1, false);
  static const PublicTag kReferencedPatientPhotoSequence = const PublicTag(
      // (0010,1100)
      "ReferencedPatientPhotoSequence",
      0x00101100,
      "Referenced Patient Photo Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const PublicTag kMedicalAlerts
      //(0010,2000)
      = const PublicTag(
          "MedicalAlerts", 0x00102000, "Medical Alerts", VR.kLO, VM.k1_n, false);
  static const PublicTag kAllergies
      //(0010,2110)
      = const PublicTag("Allergies", 0x00102110, "Allergies", VR.kLO, VM.k1_n, false);
  static const PublicTag kCountryOfResidence
      //(0010,2150)
      = const PublicTag(
          "CountryOfResidence", 0x00102150, "Country of Residence", VR.kLO, VM.k1, false);
  static const PublicTag kRegionOfResidence
      //(0010,2152)
      = const PublicTag(
          "RegionOfResidence", 0x00102152, "Region of Residence", VR.kLO, VM.k1, false);
  static const PublicTag kPatientTelephoneNumbers
      //(0010,2154)
      = const PublicTag("PatientTelephoneNumbers", 0x00102154,
          "Patient's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const PublicTag kEthnicGroup
      //(0010,2160)
      = const PublicTag("EthnicGroup", 0x00102160, "Ethnic Group", VR.kSH, VM.k1, false);
  static const PublicTag kOccupation
      //(0010,2180)
      = const PublicTag("Occupation", 0x00102180, "Occupation", VR.kSH, VM.k1, false);
  static const PublicTag kSmokingStatus
      //(0010,21A0)
      = const PublicTag(
          "SmokingStatus", 0x001021A0, "Smoking Status", VR.kCS, VM.k1, false);
  static const PublicTag kAdditionalPatientHistory
      //(0010,21B0)
      = const PublicTag("AdditionalPatientHistory", 0x001021B0,
          "Additional Patient History", VR.kLT, VM.k1, false);
  static const PublicTag kPregnancyStatus
      //(0010,21C0)
      = const PublicTag(
          "PregnancyStatus", 0x001021C0, "Pregnancy Status", VR.kUS, VM.k1, false);
  static const PublicTag kLastMenstrualDate
      //(0010,21D0)
      = const PublicTag(
          "LastMenstrualDate", 0x001021D0, "Last Menstrual Date", VR.kDA, VM.k1, false);
  static const PublicTag kPatientReligiousPreference
      //(0010,21F0)
      = const PublicTag("PatientReligiousPreference", 0x001021F0,
          "Patient's Religious Preference", VR.kLO, VM.k1, false);
  static const PublicTag kPatientSpeciesDescription
      //(0010,2201)
      = const PublicTag("PatientSpeciesDescription", 0x00102201,
          "Patient Species Description", VR.kLO, VM.k1, false);
  static const PublicTag kPatientSpeciesCodeSequence
      //(0010,2202)
      = const PublicTag("PatientSpeciesCodeSequence", 0x00102202,
          "Patient Species Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientSexNeutered
      //(0010,2203)
      = const PublicTag("PatientSexNeutered", 0x00102203, "Patient's Sex Neutered",
          VR.kCS, VM.k1, false);
  static const PublicTag kAnatomicalOrientationType
      //(0010,2210)
      = const PublicTag("AnatomicalOrientationType", 0x00102210,
          "Anatomical Orientation Type", VR.kCS, VM.k1, false);
  static const PublicTag kPatientBreedDescription
      //(0010,2292)
      = const PublicTag("PatientBreedDescription", 0x00102292,
          "Patient Breed Description", VR.kLO, VM.k1, false);
  static const PublicTag kPatientBreedCodeSequence
      //(0010,2293)
      = const PublicTag("PatientBreedCodeSequence", 0x00102293,
          "Patient Breed Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBreedRegistrationSequence
      //(0010,2294)
      = const PublicTag("BreedRegistrationSequence", 0x00102294,
          "Breed Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBreedRegistrationNumber
      //(0010,2295)
      = const PublicTag("BreedRegistrationNumber", 0x00102295,
          "Breed Registration Number", VR.kLO, VM.k1, false);
  static const PublicTag kBreedRegistryCodeSequence
      //(0010,2296)
      = const PublicTag("BreedRegistryCodeSequence", 0x00102296,
          "Breed Registry Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kResponsiblePerson
      //(0010,2297)
      = const PublicTag(
          "ResponsiblePerson", 0x00102297, "Responsible Person", VR.kPN, VM.k1, false);
  static const PublicTag kResponsiblePersonRole
      //(0010,2298)
      = const PublicTag("ResponsiblePersonRole", 0x00102298, "Responsible Person Role",
          VR.kCS, VM.k1, false);
  static const PublicTag kResponsibleOrganization
      //(0010,2299)
      = const PublicTag("ResponsibleOrganization", 0x00102299, "Responsible Organization",
          VR.kLO, VM.k1, false);
  static const PublicTag kPatientComments
      //(0010,4000)
      = const PublicTag(
          "PatientComments", 0x00104000, "Patient Comments", VR.kLT, VM.k1, false);
  static const PublicTag kExaminedBodyThickness
      //(0010,9431)
      = const PublicTag("ExaminedBodyThickness", 0x00109431, "Examined Body Thickness",
          VR.kFL, VM.k1, false);
  static const PublicTag kClinicalTrialSponsorName
      //(0012,0010)
      = const PublicTag("ClinicalTrialSponsorName", 0x00120010,
          "Clinical Trial Sponsor Name", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialProtocolID
      //(0012,0020)
      = const PublicTag("ClinicalTrialProtocolID", 0x00120020,
          "Clinical Trial Protocol ID", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialProtocolName
      //(0012,0021)
      = const PublicTag("ClinicalTrialProtocolName", 0x00120021,
          "Clinical Trial Protocol Name", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialSiteID
      //(0012,0030)
      = const PublicTag("ClinicalTrialSiteID", 0x00120030, "Clinical Trial Site ID",
          VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialSiteName
      //(0012,0031)
      = const PublicTag("ClinicalTrialSiteName", 0x00120031, "Clinical Trial Site Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialSubjectID
      //(0012,0040)
      = const PublicTag("ClinicalTrialSubjectID", 0x00120040, "Clinical Trial Subject ID",
          VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialSubjectReadingID
      //(0012,0042)
      = const PublicTag("ClinicalTrialSubjectReadingID", 0x00120042,
          "Clinical Trial Subject Reading ID", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialTimePointID
      //(0012,0050)
      = const PublicTag("ClinicalTrialTimePointID", 0x00120050,
          "Clinical Trial Time Point ID", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialTimePointDescription
      //(0012,0051)
      = const PublicTag("ClinicalTrialTimePointDescription", 0x00120051,
          "Clinical Trial Time Point Description", VR.kST, VM.k1, false);
  static const PublicTag kClinicalTrialCoordinatingCenterName
      //(0012,0060)
      = const PublicTag("ClinicalTrialCoordinatingCenterName", 0x00120060,
          "Clinical Trial Coordinating Center Name", VR.kLO, VM.k1, false);
  static const PublicTag kPatientIdentityRemoved
      //(0012,0062)
      = const PublicTag("PatientIdentityRemoved", 0x00120062, "Patient Identity Removed",
          VR.kCS, VM.k1, false);
  static const PublicTag kDeidentificationMethod
      //(0012,0063)
      = const PublicTag("DeidentificationMethod", 0x00120063, "De-identification Method",
          VR.kLO, VM.k1_n, false);
  static const PublicTag kDeidentificationMethodCodeSequence
      //(0012,0064)
      = const PublicTag("DeidentificationMethodCodeSequence", 0x00120064,
          "De-identification Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kClinicalTrialSeriesID
      //(0012,0071)
      = const PublicTag("ClinicalTrialSeriesID", 0x00120071, "Clinical Trial Series ID",
          VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialSeriesDescription
      //(0012,0072)
      = const PublicTag("ClinicalTrialSeriesDescription", 0x00120072,
          "Clinical Trial Series Description", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialProtocolEthicsCommitteeName
      //(0012,0081)
      = const PublicTag("ClinicalTrialProtocolEthicsCommitteeName", 0x00120081,
          "Clinical Trial Protocol Ethics Committee Name", VR.kLO, VM.k1, false);
  static const PublicTag kClinicalTrialProtocolEthicsCommitteeApprovalNumber
      //(0012,0082)
      = const PublicTag(
          "ClinicalTrialProtocolEthicsCommitteeApprovalNumber",
          0x00120082,
          "Clinical Trial Protocol Ethics Committee Approval Number",
          VR.kLO,
          VM.k1,
          false);
  static const PublicTag kConsentForClinicalTrialUseSequence
      //(0012,0083)
      = const PublicTag("ConsentForClinicalTrialUseSequence", 0x00120083,
          "Consent for Clinical Trial Use Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDistributionType
      //(0012,0084)
      = const PublicTag(
          "DistributionType", 0x00120084, "Distribution Type", VR.kCS, VM.k1, false);
  static const PublicTag kConsentForDistributionFlag
      //(0012,0085)
      = const PublicTag("ConsentForDistributionFlag", 0x00120085,
          "Consent for Distribution Flag", VR.kCS, VM.k1, false);
  static const PublicTag kCADFileFormat
      //(0014,0023)
      = const PublicTag(
          "CADFileFormat", 0x00140023, "CAD File Format", VR.kST, VM.k1_n, true);
  static const PublicTag kComponentReferenceSystem
      //(0014,0024)
      = const PublicTag("ComponentReferenceSystem", 0x00140024,
          "Component Reference System", VR.kST, VM.k1_n, true);
  static const PublicTag kComponentManufacturingProcedure
      //(0014,0025)
      = const PublicTag("ComponentManufacturingProcedure", 0x00140025,
          "Component Manufacturing Procedure", VR.kST, VM.k1_n, false);
  static const PublicTag kComponentManufacturer
      //(0014,0028)
      = const PublicTag("ComponentManufacturer", 0x00140028, "Component Manufacturer",
          VR.kST, VM.k1_n, false);
  static const PublicTag kMaterialThickness
      //(0014,0030)
      = const PublicTag(
          "MaterialThickness", 0x00140030, "Material Thickness", VR.kDS, VM.k1_n, false);
  static const PublicTag kMaterialPipeDiameter
      //(0014,0032)
      = const PublicTag("MaterialPipeDiameter", 0x00140032, "Material Pipe Diameter",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kMaterialIsolationDiameter
      //(0014,0034)
      = const PublicTag("MaterialIsolationDiameter", 0x00140034,
          "Material Isolation Diameter", VR.kDS, VM.k1_n, false);
  static const PublicTag kMaterialGrade
      //(0014,0042)
      = const PublicTag(
          "MaterialGrade", 0x00140042, "Material Grade", VR.kST, VM.k1_n, false);
  static const PublicTag kMaterialPropertiesDescription
      //(0014,0044)
      = const PublicTag("MaterialPropertiesDescription", 0x00140044,
          "Material Properties Description", VR.kST, VM.k1_n, false);
  static const PublicTag kMaterialPropertiesFileFormatRetired
      //(0014,0045)
      = const PublicTag("MaterialPropertiesFileFormatRetired", 0x00140045,
          "Material Properties File Format (Retired)", VR.kST, VM.k1_n, true);
  static const PublicTag kMaterialNotes
      //(0014,0046)
      = const PublicTag(
          "MaterialNotes", 0x00140046, "Material Notes", VR.kLT, VM.k1, false);
  static const PublicTag kComponentShape
      //(0014,0050)
      = const PublicTag(
          "ComponentShape", 0x00140050, "Component Shape", VR.kCS, VM.k1, false);
  static const PublicTag kCurvatureType
      //(0014,0052)
      = const PublicTag(
          "CurvatureType", 0x00140052, "Curvature Type", VR.kCS, VM.k1, false);
  static const PublicTag kOuterDiameter
      //(0014,0054)
      = const PublicTag(
          "OuterDiameter", 0x00140054, "Outer Diameter", VR.kDS, VM.k1, false);
  static const PublicTag kInnerDiameter
      //(0014,0056)
      = const PublicTag(
          "InnerDiameter", 0x00140056, "Inner Diameter", VR.kDS, VM.k1, false);
  static const PublicTag kActualEnvironmentalConditions
      //(0014,1010)
      = const PublicTag("ActualEnvironmentalConditions", 0x00141010,
          "Actual Environmental Conditions", VR.kST, VM.k1, false);
  static const PublicTag kExpiryDate
      //(0014,1020)
      = const PublicTag("ExpiryDate", 0x00141020, "Expiry Date", VR.kDA, VM.k1, false);
  static const PublicTag kEnvironmentalConditions
      //(0014,1040)
      = const PublicTag("EnvironmentalConditions", 0x00141040, "Environmental Conditions",
          VR.kST, VM.k1, false);
  static const PublicTag kEvaluatorSequence
      //(0014,2002)
      = const PublicTag(
          "EvaluatorSequence", 0x00142002, "Evaluator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEvaluatorNumber
      //(0014,2004)
      = const PublicTag(
          "EvaluatorNumber", 0x00142004, "Evaluator Number", VR.kIS, VM.k1, false);
  static const PublicTag kEvaluatorName
      //(0014,2006)
      = const PublicTag(
          "EvaluatorName", 0x00142006, "Evaluator Name", VR.kPN, VM.k1, false);
  static const PublicTag kEvaluationAttempt
      //(0014,2008)
      = const PublicTag(
          "EvaluationAttempt", 0x00142008, "Evaluation Attempt", VR.kIS, VM.k1, false);
  static const PublicTag kIndicationSequence
      //(0014,2012)
      = const PublicTag(
          "IndicationSequence", 0x00142012, "Indication Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIndicationNumber
      //(0014,2014)
      = const PublicTag(
          "IndicationNumber", 0x00142014, "Indication Number", VR.kIS, VM.k1, false);
  static const PublicTag kIndicationLabel
      //(0014,2016)
      = const PublicTag(
          "IndicationLabel", 0x00142016, "Indication Label", VR.kSH, VM.k1, false);
  static const PublicTag kIndicationDescription
      //(0014,2018)
      = const PublicTag("IndicationDescription", 0x00142018, "Indication Description",
          VR.kST, VM.k1, false);
  static const PublicTag kIndicationType
      //(0014,201A)
      = const PublicTag(
          "IndicationType", 0x0014201A, "Indication Type", VR.kCS, VM.k1_n, false);
  static const PublicTag kIndicationDisposition
      //(0014,201C)
      = const PublicTag("IndicationDisposition", 0x0014201C, "Indication Disposition",
          VR.kCS, VM.k1, false);
  static const PublicTag kIndicationROISequence
      //(0014,201E)
      = const PublicTag("IndicationROISequence", 0x0014201E, "Indication ROI Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kIndicationPhysicalPropertySequence
      //(0014,2030)
      = const PublicTag("IndicationPhysicalPropertySequence", 0x00142030,
          "Indication Physical Property Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPropertyLabel
      //(0014,2032)
      = const PublicTag(
          "PropertyLabel", 0x00142032, "Property Label", VR.kSH, VM.k1, false);
  static const PublicTag kCoordinateSystemNumberOfAxes
      //(0014,2202)
      = const PublicTag("CoordinateSystemNumberOfAxes", 0x00142202,
          "Coordinate System Number of Axes", VR.kIS, VM.k1, false);
  static const PublicTag kCoordinateSystemAxesSequence
      //(0014,2204)
      = const PublicTag("CoordinateSystemAxesSequence", 0x00142204,
          "Coordinate System Axes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCoordinateSystemAxisDescription
      //(0014,2206)
      = const PublicTag("CoordinateSystemAxisDescription", 0x00142206,
          "Coordinate System Axis Description", VR.kST, VM.k1, false);
  static const PublicTag kCoordinateSystemDataSetMapping
      //(0014,2208)
      = const PublicTag("CoordinateSystemDataSetMapping", 0x00142208,
          "Coordinate System Data Set Mapping", VR.kCS, VM.k1, false);
  static const PublicTag kCoordinateSystemAxisNumber
      //(0014,220A)
      = const PublicTag("CoordinateSystemAxisNumber", 0x0014220A,
          "Coordinate System Axis Number", VR.kIS, VM.k1, false);
  static const PublicTag kCoordinateSystemAxisType
      //(0014,220C)
      = const PublicTag("CoordinateSystemAxisType", 0x0014220C,
          "Coordinate System Axis Type", VR.kCS, VM.k1, false);
  static const PublicTag kCoordinateSystemAxisUnits
      //(0014,220E)
      = const PublicTag("CoordinateSystemAxisUnits", 0x0014220E,
          "Coordinate System Axis Units", VR.kCS, VM.k1, false);
  static const PublicTag kCoordinateSystemAxisValues
      //(0014,2210)
      = const PublicTag("CoordinateSystemAxisValues", 0x00142210,
          "Coordinate System Axis Values", VR.kOB, VM.k1, false);
  static const PublicTag kCoordinateSystemTransformSequence
      //(0014,2220)
      = const PublicTag("CoordinateSystemTransformSequence", 0x00142220,
          "Coordinate System Transform Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransformDescription
      //(0014,2222)
      = const PublicTag("TransformDescription", 0x00142222, "Transform Description",
          VR.kST, VM.k1, false);
  static const PublicTag kTransformNumberOfAxes
      //(0014,2224)
      = const PublicTag("TransformNumberOfAxes", 0x00142224, "Transform Number of Axes",
          VR.kIS, VM.k1, false);
  static const PublicTag kTransformOrderOfAxes
      //(0014,2226)
      = const PublicTag("TransformOrderOfAxes", 0x00142226, "Transform Order of Axes",
          VR.kIS, VM.k1_n, false);
  static const PublicTag kTransformedAxisUnits
      //(0014,2228)
      = const PublicTag("TransformedAxisUnits", 0x00142228, "Transformed Axis Units",
          VR.kCS, VM.k1, false);
  static const PublicTag kCoordinateSystemTransformRotationAndScaleMatrix
      //(0014,222A)
      = const PublicTag(
          "CoordinateSystemTransformRotationAndScaleMatrix",
          0x0014222A,
          "Coordinate System Transform Rotation and Scale Matrix",
          VR.kDS,
          VM.k1_n,
          false);
  static const PublicTag kCoordinateSystemTransformTranslationMatrix
      //(0014,222C)
      = const PublicTag("CoordinateSystemTransformTranslationMatrix", 0x0014222C,
          "Coordinate System Transform Translation Matrix", VR.kDS, VM.k1_n, false);
  static const PublicTag kInternalDetectorFrameTime
      //(0014,3011)
      = const PublicTag("InternalDetectorFrameTime", 0x00143011,
          "Internal Detector Frame Time", VR.kDS, VM.k1, false);
  static const PublicTag kNumberOfFramesIntegrated
      //(0014,3012)
      = const PublicTag("NumberOfFramesIntegrated", 0x00143012,
          "Number of Frames Integrated", VR.kDS, VM.k1, false);
  static const PublicTag kDetectorTemperatureSequence
      //(0014,3020)
      = const PublicTag("DetectorTemperatureSequence", 0x00143020,
          "Detector Temperature Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSensorName
      //(0014,3022)
      = const PublicTag("SensorName", 0x00143022, "Sensor Name", VR.kST, VM.k1, false);
  static const PublicTag kHorizontalOffsetOfSensor
      //(0014,3024)
      = const PublicTag("HorizontalOffsetOfSensor", 0x00143024,
          "Horizontal Offset of Sensor", VR.kDS, VM.k1, false);
  static const PublicTag kVerticalOffsetOfSensor
      //(0014,3026)
      = const PublicTag("VerticalOffsetOfSensor", 0x00143026, "Vertical Offset of Sensor",
          VR.kDS, VM.k1, false);
  static const PublicTag kSensorTemperature
      //(0014,3028)
      = const PublicTag(
          "SensorTemperature", 0x00143028, "Sensor Temperature", VR.kDS, VM.k1, false);
  static const PublicTag kDarkCurrentSequence
      //(0014,3040)
      = const PublicTag("DarkCurrentSequence", 0x00143040, "Dark Current Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDarkCurrentCounts
      //(0014,3050)
      = const PublicTag(
          "DarkCurrentCounts", 0x00143050, "Dark Current Counts", VR.kOBOW, VM.k1, false);
  static const PublicTag kGainCorrectionReferenceSequence
      //(0014,3060)
      = const PublicTag("GainCorrectionReferenceSequence", 0x00143060,
          "Gain Correction Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAirCounts
      //(0014,3070)
      = const PublicTag("AirCounts", 0x00143070, "Air Counts", VR.kOBOW, VM.k1, false);
  static const PublicTag kKVUsedInGainCalibration
      //(0014,3071)
      = const PublicTag("KVUsedInGainCalibration", 0x00143071,
          "KV Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const PublicTag kMAUsedInGainCalibration
      //(0014,3072)
      = const PublicTag("MAUsedInGainCalibration", 0x00143072,
          "MA Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const PublicTag kNumberOfFramesUsedForIntegration
      //(0014,3073)
      = const PublicTag("NumberOfFramesUsedForIntegration", 0x00143073,
          "Number of Frames Used for Integration", VR.kDS, VM.k1, false);
  static const PublicTag kFilterMaterialUsedInGainCalibration
      //(0014,3074)
      = const PublicTag("FilterMaterialUsedInGainCalibration", 0x00143074,
          "Filter Material Used in Gain Calibration", VR.kLO, VM.k1, false);
  static const PublicTag kFilterThicknessUsedInGainCalibration
      //(0014,3075)
      = const PublicTag("FilterThicknessUsedInGainCalibration", 0x00143075,
          "Filter Thickness Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const PublicTag kDateOfGainCalibration
      //(0014,3076)
      = const PublicTag("DateOfGainCalibration", 0x00143076, "Date of Gain Calibration",
          VR.kDA, VM.k1, false);
  static const PublicTag kTimeOfGainCalibration
      //(0014,3077)
      = const PublicTag("TimeOfGainCalibration", 0x00143077, "Time of Gain Calibration",
          VR.kTM, VM.k1, false);
  static const PublicTag kBadPixelImage
      //(0014,3080)
      = const PublicTag(
          "BadPixelImage", 0x00143080, "Bad Pixel Image", VR.kOB, VM.k1, false);
  static const PublicTag kCalibrationNotes
      //(0014,3099)
      = const PublicTag(
          "CalibrationNotes", 0x00143099, "Calibration Notes", VR.kLT, VM.k1, false);
  static const PublicTag kPulserEquipmentSequence
      //(0014,4002)
      = const PublicTag("PulserEquipmentSequence", 0x00144002,
          "Pulser Equipment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPulserType
      //(0014,4004)
      = const PublicTag("PulserType", 0x00144004, "Pulser Type", VR.kCS, VM.k1, false);
  static const PublicTag kPulserNotes
      //(0014,4006)
      = const PublicTag("PulserNotes", 0x00144006, "Pulser Notes", VR.kLT, VM.k1, false);
  static const PublicTag kReceiverEquipmentSequence
      //(0014,4008)
      = const PublicTag("ReceiverEquipmentSequence", 0x00144008,
          "Receiver Equipment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAmplifierType
      //(0014,400A)
      = const PublicTag(
          "AmplifierType", 0x0014400A, "Amplifier Type", VR.kCS, VM.k1, false);
  static const PublicTag kReceiverNotes
      //(0014,400C)
      = const PublicTag(
          "ReceiverNotes", 0x0014400C, "Receiver Notes", VR.kLT, VM.k1, false);
  static const PublicTag kPreAmplifierEquipmentSequence
      //(0014,400E)
      = const PublicTag("PreAmplifierEquipmentSequence", 0x0014400E,
          "Pre-Amplifier Equipment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPreAmplifierNotes
      //(0014,400F)
      = const PublicTag(
          "PreAmplifierNotes", 0x0014400F, "Pre-Amplifier Notes", VR.kLT, VM.k1, false);
  static const PublicTag kTransmitTransducerSequence
      //(0014,4010)
      = const PublicTag("TransmitTransducerSequence", 0x00144010,
          "Transmit Transducer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReceiveTransducerSequence
      //(0014,4011)
      = const PublicTag("ReceiveTransducerSequence", 0x00144011,
          "Receive Transducer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfElements
      //(0014,4012)
      = const PublicTag(
          "NumberOfElements", 0x00144012, "Number of Elements", VR.kUS, VM.k1, false);
  static const PublicTag kElementShape
      //(0014,4013)
      =
      const PublicTag("ElementShape", 0x00144013, "Element Shape", VR.kCS, VM.k1, false);
  static const PublicTag kElementDimensionA
      //(0014,4014)
      = const PublicTag(
          "ElementDimensionA", 0x00144014, "Element Dimension A", VR.kDS, VM.k1, false);
  static const PublicTag kElementDimensionB
      //(0014,4015)
      = const PublicTag(
          "ElementDimensionB", 0x00144015, "Element Dimension B", VR.kDS, VM.k1, false);
  static const PublicTag kElementPitchA
      //(0014,4016)
      = const PublicTag(
          "ElementPitchA", 0x00144016, "Element Pitch A", VR.kDS, VM.k1, false);
  static const PublicTag kMeasuredBeamDimensionA
      //(0014,4017)
      = const PublicTag("MeasuredBeamDimensionA", 0x00144017, "Measured Beam Dimension A",
          VR.kDS, VM.k1, false);
  static const PublicTag kMeasuredBeamDimensionB
      //(0014,4018)
      = const PublicTag("MeasuredBeamDimensionB", 0x00144018, "Measured Beam Dimension B",
          VR.kDS, VM.k1, false);
  static const PublicTag kLocationOfMeasuredBeamDiameter
      //(0014,4019)
      = const PublicTag("LocationOfMeasuredBeamDiameter", 0x00144019,
          "Location of Measured Beam Diameter", VR.kDS, VM.k1, false);
  static const PublicTag kNominalFrequency
      //(0014,401A)
      = const PublicTag(
          "NominalFrequency", 0x0014401A, "Nominal Frequency", VR.kDS, VM.k1, false);
  static const PublicTag kMeasuredCenterFrequency
      //(0014,401B)
      = const PublicTag("MeasuredCenterFrequency", 0x0014401B,
          "Measured Center Frequency", VR.kDS, VM.k1, false);
  static const PublicTag kMeasuredBandwidth
      //(0014,401C)
      = const PublicTag(
          "MeasuredBandwidth", 0x0014401C, "Measured Bandwidth", VR.kDS, VM.k1, false);
  static const PublicTag kElementPitchB
      //(0014,401D)
      = const PublicTag(
          "ElementPitchB", 0x0014401D, "Element Pitch B", VR.kDS, VM.k1, false);
  static const PublicTag kPulserSettingsSequence
      //(0014,4020)
      = const PublicTag("PulserSettingsSequence", 0x00144020, "Pulser Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPulseWidth
      //(0014,4022)
      = const PublicTag("PulseWidth", 0x00144022, "Pulse Width", VR.kDS, VM.k1, false);
  static const PublicTag kExcitationFrequency
      //(0014,4024)
      = const PublicTag("ExcitationFrequency", 0x00144024, "Excitation Frequency", VR.kDS,
          VM.k1, false);
  static const PublicTag kModulationType
      //(0014,4026)
      = const PublicTag(
          "ModulationType", 0x00144026, "Modulation Type", VR.kCS, VM.k1, false);
  static const PublicTag kDamping
      //(0014,4028)
      = const PublicTag("Damping", 0x00144028, "Damping", VR.kDS, VM.k1, false);
  static const PublicTag kReceiverSettingsSequence
      //(0014,4030)
      = const PublicTag("ReceiverSettingsSequence", 0x00144030,
          "Receiver Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcquiredSoundpathLength
      //(0014,4031)
      = const PublicTag("AcquiredSoundpathLength", 0x00144031,
          "Acquired Soundpath Length", VR.kDS, VM.k1, false);
  static const PublicTag kAcquisitionCompressionType
      //(0014,4032)
      = const PublicTag("AcquisitionCompressionType", 0x00144032,
          "Acquisition Compression Type", VR.kCS, VM.k1, false);
  static const PublicTag kAcquisitionSampleSize
      //(0014,4033)
      = const PublicTag("AcquisitionSampleSize", 0x00144033, "Acquisition Sample Size",
          VR.kIS, VM.k1, false);
  static const PublicTag kRectifierSmoothing
      //(0014,4034)
      = const PublicTag(
          "RectifierSmoothing", 0x00144034, "Rectifier Smoothing", VR.kDS, VM.k1, false);
  static const PublicTag kDACSequence
      //(0014,4035)
      = const PublicTag("DACSequence", 0x00144035, "DAC Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDACType
      //(0014,4036)
      = const PublicTag("DACType", 0x00144036, "DAC Type", VR.kCS, VM.k1, false);
  static const PublicTag kDACGainPoints
      //(0014,4038)
      = const PublicTag(
          "DACGainPoints", 0x00144038, "DAC Gain Points", VR.kDS, VM.k1_n, false);
  static const PublicTag kDACTimePoints
      //(0014,403A)
      = const PublicTag(
          "DACTimePoints", 0x0014403A, "DAC Time Points", VR.kDS, VM.k1_n, false);
  static const PublicTag kDACAmplitude
      //(0014,403C)
      = const PublicTag(
          "DACAmplitude", 0x0014403C, "DAC Amplitude", VR.kDS, VM.k1_n, false);
  static const PublicTag kPreAmplifierSettingsSequence
      //(0014,4040)
      = const PublicTag("PreAmplifierSettingsSequence", 0x00144040,
          "Pre-Amplifier Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransmitTransducerSettingsSequence
      //(0014,4050)
      = const PublicTag("TransmitTransducerSettingsSequence", 0x00144050,
          "Transmit Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReceiveTransducerSettingsSequence
      //(0014,4051)
      = const PublicTag("ReceiveTransducerSettingsSequence", 0x00144051,
          "Receive Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIncidentAngle
      //(0014,4052)
      = const PublicTag(
          "IncidentAngle", 0x00144052, "Incident Angle", VR.kDS, VM.k1, false);
  static const PublicTag kCouplingTechnique
      //(0014,4054)
      = const PublicTag(
          "CouplingTechnique", 0x00144054, "Coupling Technique", VR.kST, VM.k1, false);
  static const PublicTag kCouplingMedium
      //(0014,4056)
      = const PublicTag(
          "CouplingMedium", 0x00144056, "Coupling Medium", VR.kST, VM.k1, false);
  static const PublicTag kCouplingVelocity
      //(0014,4057)
      = const PublicTag(
          "CouplingVelocity", 0x00144057, "Coupling Velocity", VR.kDS, VM.k1, false);
  static const PublicTag kProbeCenterLocationX
      //(0014,4058)
      = const PublicTag("ProbeCenterLocationX", 0x00144058, "Probe Center Location X",
          VR.kDS, VM.k1, false);
  static const PublicTag kProbeCenterLocationZ
      //(0014,4059)
      = const PublicTag("ProbeCenterLocationZ", 0x00144059, "Probe Center Location Z",
          VR.kDS, VM.k1, false);
  static const PublicTag kSoundPathLength
      //(0014,405A)
      = const PublicTag(
          "SoundPathLength", 0x0014405A, "Sound Path Length", VR.kDS, VM.k1, false);
  static const PublicTag kDelayLawIdentifier
      //(0014,405C)
      = const PublicTag(
          "DelayLawIdentifier", 0x0014405C, "Delay Law Identifier", VR.kST, VM.k1, false);
  static const PublicTag kGateSettingsSequence
      //(0014,4060)
      = const PublicTag("GateSettingsSequence", 0x00144060, "Gate Settings Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kGateThreshold
      //(0014,4062)
      = const PublicTag(
          "GateThreshold", 0x00144062, "Gate Threshold", VR.kDS, VM.k1, false);
  static const PublicTag kVelocityOfSound
      //(0014,4064)
      = const PublicTag(
          "VelocityOfSound", 0x00144064, "Velocity of Sound", VR.kDS, VM.k1, false);
  static const PublicTag kCalibrationSettingsSequence
      //(0014,4070)
      = const PublicTag("CalibrationSettingsSequence", 0x00144070,
          "Calibration Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCalibrationProcedure
      //(0014,4072)
      = const PublicTag("CalibrationProcedure", 0x00144072, "Calibration Procedure",
          VR.kST, VM.k1, false);
  static const PublicTag kProcedureVersion
      //(0014,4074)
      = const PublicTag(
          "ProcedureVersion", 0x00144074, "Procedure Version", VR.kSH, VM.k1, false);
  static const PublicTag kProcedureCreationDate
      //(0014,4076)
      = const PublicTag("ProcedureCreationDate", 0x00144076, "Procedure Creation Date",
          VR.kDA, VM.k1, false);
  static const PublicTag kProcedureExpirationDate
      //(0014,4078)
      = const PublicTag("ProcedureExpirationDate", 0x00144078,
          "Procedure Expiration Date", VR.kDA, VM.k1, false);
  static const PublicTag kProcedureLastModifiedDate
      //(0014,407A)
      = const PublicTag("ProcedureLastModifiedDate", 0x0014407A,
          "Procedure Last Modified Date", VR.kDA, VM.k1, false);
  static const PublicTag kCalibrationTime
      //(0014,407C)
      = const PublicTag(
          "CalibrationTime", 0x0014407C, "Calibration Time", VR.kTM, VM.k1_n, false);
  static const PublicTag kCalibrationDate
      //(0014,407E)
      = const PublicTag(
          "CalibrationDate", 0x0014407E, "Calibration Date", VR.kDA, VM.k1_n, false);
  static const PublicTag kProbeDriveEquipmentSequence
      //(0014,4080)
      = const PublicTag("ProbeDriveEquipmentSequence", 0x00144080,
          "Probe Drive Equipment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDriveType
      //(0014,4081)
      = const PublicTag("DriveType", 0x00144081, "Drive Type", VR.kCS, VM.k1, false);
  static const PublicTag kProbeDriveNotes
      //(0014,4082)
      = const PublicTag(
          "ProbeDriveNotes", 0x00144082, "Probe Drive Notes", VR.kLT, VM.k1, false);
  static const PublicTag kDriveProbeSequence
      //(0014,4083)
      = const PublicTag(
          "DriveProbeSequence", 0x00144083, "Drive Probe Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kProbeInductance
      //(0014,4084)
      = const PublicTag(
          "ProbeInductance", 0x00144084, "Probe Inductance", VR.kDS, VM.k1, false);
  static const PublicTag kProbeResistance
      //(0014,4085)
      = const PublicTag(
          "ProbeResistance", 0x00144085, "Probe Resistance", VR.kDS, VM.k1, false);
  static const PublicTag kReceiveProbeSequence
      //(0014,4086)
      = const PublicTag("ReceiveProbeSequence", 0x00144086, "Receive Probe Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kProbeDriveSettingsSequence
      //(0014,4087)
      = const PublicTag("ProbeDriveSettingsSequence", 0x00144087,
          "Probe Drive Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBridgeResistors
      //(0014,4088)
      = const PublicTag(
          "BridgeResistors", 0x00144088, "Bridge Resistors", VR.kDS, VM.k1, false);
  static const PublicTag kProbeOrientationAngle
      //(0014,4089)
      = const PublicTag("ProbeOrientationAngle", 0x00144089, "Probe Orientation Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kUserSelectedGainY
      //(0014,408B)
      = const PublicTag(
          "UserSelectedGainY", 0x0014408B, "User Selected Gain Y", VR.kDS, VM.k1, false);
  static const PublicTag kUserSelectedPhase
      //(0014,408C)
      = const PublicTag(
          "UserSelectedPhase", 0x0014408C, "User Selected Phase", VR.kDS, VM.k1, false);
  static const PublicTag kUserSelectedOffsetX
      //(0014,408D)
      = const PublicTag("UserSelectedOffsetX", 0x0014408D, "User Selected Offset X",
          VR.kDS, VM.k1, false);
  static const PublicTag kUserSelectedOffsetY
      //(0014,408E)
      = const PublicTag("UserSelectedOffsetY", 0x0014408E, "User Selected Offset Y",
          VR.kDS, VM.k1, false);
  static const PublicTag kChannelSettingsSequence
      //(0014,4091)
      = const PublicTag("ChannelSettingsSequence", 0x00144091,
          "Channel Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelThreshold
      //(0014,4092)
      = const PublicTag(
          "ChannelThreshold", 0x00144092, "Channel Threshold", VR.kDS, VM.k1, false);
  static const PublicTag kScannerSettingsSequence
      //(0014,409A)
      = const PublicTag("ScannerSettingsSequence", 0x0014409A,
          "Scanner Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScanProcedure
      //(0014,409B)
      = const PublicTag(
          "ScanProcedure", 0x0014409B, "Scan Procedure", VR.kST, VM.k1, false);
  static const PublicTag kTranslationRateX
      //(0014,409C)
      = const PublicTag(
          "TranslationRateX", 0x0014409C, "Translation Rate X", VR.kDS, VM.k1, false);
  static const PublicTag kTranslationRateY
      //(0014,409D)
      = const PublicTag(
          "TranslationRateY", 0x0014409D, "Translation Rate Y", VR.kDS, VM.k1, false);
  static const PublicTag kChannelOverlap
      //(0014,409F)
      = const PublicTag(
          "ChannelOverlap", 0x0014409F, "Channel Overlap", VR.kDS, VM.k1, false);
  static const PublicTag kImageQualityIndicatorType
      //(0014,40A0)
      = const PublicTag("ImageQualityIndicatorType", 0x001440A0,
          "Image Quality Indicator Type", VR.kLO, VM.k1, false);
  static const PublicTag kImageQualityIndicatorMaterial
      //(0014,40A1)
      = const PublicTag("ImageQualityIndicatorMaterial", 0x001440A1,
          "Image Quality Indicator Material", VR.kLO, VM.k1, false);
  static const PublicTag kImageQualityIndicatorSize
      //(0014,40A2)
      = const PublicTag("ImageQualityIndicatorSize", 0x001440A2,
          "Image Quality Indicator Size", VR.kLO, VM.k1, false);
  static const PublicTag kLINACEnergy
      //(0014,5002)
      = const PublicTag("LINACEnergy", 0x00145002, "LINAC Energy", VR.kIS, VM.k1, false);
  static const PublicTag kLINACOutput
      //(0014,5004)
      = const PublicTag("LINACOutput", 0x00145004, "LINAC Output", VR.kIS, VM.k1, false);
  static const PublicTag kContrastBolusAgent
      //(0018,0010)
      = const PublicTag(
          "ContrastBolusAgent", 0x00180010, "Contrast/Bolus Agent", VR.kLO, VM.k1, false);
  static const PublicTag kContrastBolusAgentSequence
      //(0018,0012)
      = const PublicTag("ContrastBolusAgentSequence", 0x00180012,
          "Contrast/Bolus Agent Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContrastBolusAdministrationRouteSequence
      //(0018,0014)
      = const PublicTag("ContrastBolusAdministrationRouteSequence", 0x00180014,
          "Contrast/Bolus Administration Route Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBodyPartExamined
      //(0018,0015)
      = const PublicTag(
          "BodyPartExamined", 0x00180015, "Body Part Examined", VR.kCS, VM.k1, false);
  static const PublicTag kScanningSequence
      //(0018,0020)
      = const PublicTag(
          "ScanningSequence", 0x00180020, "Scanning Sequence", VR.kCS, VM.k1_n, false);
  static const PublicTag kSequenceVariant
      //(0018,0021)
      = const PublicTag(
          "SequenceVariant", 0x00180021, "Sequence Variant", VR.kCS, VM.k1_n, false);
  static const PublicTag kScanOptions
      //(0018,0022)
      =
      const PublicTag("ScanOptions", 0x00180022, "Scan Options", VR.kCS, VM.k1_n, false);
  static const PublicTag kMRAcquisitionType
      //(0018,0023)
      = const PublicTag(
          "MRAcquisitionType", 0x00180023, "MR Acquisition Type", VR.kCS, VM.k1, false);
  static const PublicTag kSequenceName
      //(0018,0024)
      =
      const PublicTag("SequenceName", 0x00180024, "Sequence Name", VR.kSH, VM.k1, false);
  static const PublicTag kAngioFlag
      //(0018,0025)
      = const PublicTag("AngioFlag", 0x00180025, "Angio Flag", VR.kCS, VM.k1, false);
  static const PublicTag kInterventionDrugInformationSequence
      //(0018,0026)
      = const PublicTag("InterventionDrugInformationSequence", 0x00180026,
          "Intervention Drug Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInterventionDrugStopTime
      //(0018,0027)
      = const PublicTag("InterventionDrugStopTime", 0x00180027,
          "Intervention Drug Stop Time", VR.kTM, VM.k1, false);
  static const PublicTag kInterventionDrugDose
      //(0018,0028)
      = const PublicTag("InterventionDrugDose", 0x00180028, "Intervention Drug Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kInterventionDrugCodeSequence
      //(0018,0029)
      = const PublicTag("InterventionDrugCodeSequence", 0x00180029,
          "Intervention Drug Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAdditionalDrugSequence
      //(0018,002A)
      = const PublicTag("AdditionalDrugSequence", 0x0018002A, "Additional Drug Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRadionuclide
      //(0018,0030)
      =
      const PublicTag("Radionuclide", 0x00180030, "Radionuclide", VR.kLO, VM.k1_n, true);
  static const PublicTag kRadiopharmaceutical
      //(0018,0031)
      = const PublicTag(
          "Radiopharmaceutical", 0x00180031, "Radiopharmaceutical", VR.kLO, VM.k1, false);
  static const PublicTag kEnergyWindowCenterline
      //(0018,0032)
      = const PublicTag("EnergyWindowCenterline", 0x00180032, "Energy Window Centerline",
          VR.kDS, VM.k1, true);
  static const PublicTag kEnergyWindowTotalWidth
      //(0018,0033)
      = const PublicTag("EnergyWindowTotalWidth", 0x00180033, "Energy Window Total Width",
          VR.kDS, VM.k1_n, true);
  static const PublicTag kInterventionDrugName
      //(0018,0034)
      = const PublicTag("InterventionDrugName", 0x00180034, "Intervention Drug Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kInterventionDrugStartTime
      //(0018,0035)
      = const PublicTag("InterventionDrugStartTime", 0x00180035,
          "Intervention Drug Start Time", VR.kTM, VM.k1, false);
  static const PublicTag kInterventionSequence
      //(0018,0036)
      = const PublicTag("InterventionSequence", 0x00180036, "Intervention Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTherapyType
      //(0018,0037)
      = const PublicTag("TherapyType", 0x00180037, "Therapy Type", VR.kCS, VM.k1, true);
  static const PublicTag kInterventionStatus
      //(0018,0038)
      = const PublicTag(
          "InterventionStatus", 0x00180038, "Intervention Status", VR.kCS, VM.k1, false);
  static const PublicTag kTherapyDescription
      //(0018,0039)
      = const PublicTag(
          "TherapyDescription", 0x00180039, "Therapy Description", VR.kCS, VM.k1, true);
  static const PublicTag kInterventionDescription
      //(0018,003A)
      = const PublicTag("InterventionDescription", 0x0018003A, "Intervention Description",
          VR.kST, VM.k1, false);
  static const PublicTag kCineRate
      //(0018,0040)
      = const PublicTag("CineRate", 0x00180040, "Cine Rate", VR.kIS, VM.k1, false);
  static const PublicTag kInitialCineRunState
      //(0018,0042)
      = const PublicTag("InitialCineRunState", 0x00180042, "Initial Cine Run State",
          VR.kCS, VM.k1, false);
  static const PublicTag kSliceThickness
      //(0018,0050)
      = const PublicTag(
          "SliceThickness", 0x00180050, "Slice Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kKVP
      //(0018,0060)
      = const PublicTag("KVP", 0x00180060, "KVP", VR.kDS, VM.k1, false);
  static const PublicTag kCountsAccumulated
      //(0018,0070)
      = const PublicTag(
          "CountsAccumulated", 0x00180070, "Counts Accumulated", VR.kIS, VM.k1, false);
  static const PublicTag kAcquisitionTerminationCondition
      //(0018,0071)
      = const PublicTag("AcquisitionTerminationCondition", 0x00180071,
          "Acquisition Termination Condition", VR.kCS, VM.k1, false);
  static const PublicTag kEffectiveDuration
      //(0018,0072)
      = const PublicTag(
          "EffectiveDuration", 0x00180072, "Effective Duration", VR.kDS, VM.k1, false);
  static const PublicTag kAcquisitionStartCondition
      //(0018,0073)
      = const PublicTag("AcquisitionStartCondition", 0x00180073,
          "Acquisition Start Condition", VR.kCS, VM.k1, false);
  static const PublicTag kAcquisitionStartConditionData
      //(0018,0074)
      = const PublicTag("AcquisitionStartConditionData", 0x00180074,
          "Acquisition Start Condition Data", VR.kIS, VM.k1, false);
  static const PublicTag kAcquisitionTerminationConditionData
      //(0018,0075)
      = const PublicTag("AcquisitionTerminationConditionData", 0x00180075,
          "Acquisition Termination Condition Data", VR.kIS, VM.k1, false);
  static const PublicTag kRepetitionTime
      //(0018,0080)
      = const PublicTag(
          "RepetitionTime", 0x00180080, "Repetition Time", VR.kDS, VM.k1, false);
  static const PublicTag kEchoTime
      //(0018,0081)
      = const PublicTag("EchoTime", 0x00180081, "Echo Time", VR.kDS, VM.k1, false);
  static const PublicTag kInversionTime
      //(0018,0082)
      = const PublicTag(
          "InversionTime", 0x00180082, "Inversion Time", VR.kDS, VM.k1, false);
  static const PublicTag kNumberOfAverages
      //(0018,0083)
      = const PublicTag(
          "NumberOfAverages", 0x00180083, "Number of Averages", VR.kDS, VM.k1, false);
  static const PublicTag kImagingFrequency
      //(0018,0084)
      = const PublicTag(
          "ImagingFrequency", 0x00180084, "Imaging Frequency", VR.kDS, VM.k1, false);
  static const PublicTag kImagedNucleus
      //(0018,0085)
      = const PublicTag(
          "ImagedNucleus", 0x00180085, "Imaged Nucleus", VR.kSH, VM.k1, false);
  static const PublicTag kEchoNumbers
      //(0018,0086)
      = const PublicTag(
          "EchoNumbers", 0x00180086, "Echo Number(s)", VR.kIS, VM.k1_n, false);
  static const PublicTag kMagneticFieldStrength
      //(0018,0087)
      = const PublicTag("MagneticFieldStrength", 0x00180087, "Magnetic Field Strength",
          VR.kDS, VM.k1, false);
  static const PublicTag kSpacingBetweenSlices
      //(0018,0088)
      = const PublicTag("SpacingBetweenSlices", 0x00180088, "Spacing Between Slices",
          VR.kDS, VM.k1, false);
  static const PublicTag kNumberOfPhaseEncodingSteps
      //(0018,0089)
      = const PublicTag("NumberOfPhaseEncodingSteps", 0x00180089,
          "Number of Phase Encoding Steps", VR.kIS, VM.k1, false);
  static const PublicTag kDataCollectionDiameter
      //(0018,0090)
      = const PublicTag("DataCollectionDiameter", 0x00180090, "Data Collection Diameter",
          VR.kDS, VM.k1, false);
  static const PublicTag kEchoTrainLength
      //(0018,0091)
      = const PublicTag(
          "EchoTrainLength", 0x00180091, "Echo Train Length", VR.kIS, VM.k1, false);
  static const PublicTag kPercentSampling
      //(0018,0093)
      = const PublicTag(
          "PercentSampling", 0x00180093, "Percent Sampling", VR.kDS, VM.k1, false);
  static const PublicTag kPercentPhaseFieldOfView
      //(0018,0094)
      = const PublicTag("PercentPhaseFieldOfView", 0x00180094,
          "Percent Phase Field of View", VR.kDS, VM.k1, false);
  static const PublicTag kPixelBandwidth
      //(0018,0095)
      = const PublicTag(
          "PixelBandwidth", 0x00180095, "Pixel Bandwidth", VR.kDS, VM.k1, false);
  static const PublicTag kDeviceSerialNumber
      //(0018,1000)
      = const PublicTag(
          "DeviceSerialNumber", 0x00181000, "Device Serial Number", VR.kLO, VM.k1, false);
  static const PublicTag kDeviceUID
      //(0018,1002)
      = const PublicTag("DeviceUID", 0x00181002, "Device UID", VR.kUI, VM.k1, false);
  static const PublicTag kDeviceID
      //(0018,1003)
      = const PublicTag("DeviceID", 0x00181003, "Device ID", VR.kLO, VM.k1, false);
  static const PublicTag kPlateID
      //(0018,1004)
      = const PublicTag("PlateID", 0x00181004, "Plate ID", VR.kLO, VM.k1, false);
  static const PublicTag kGeneratorID
      //(0018,1005)
      = const PublicTag("GeneratorID", 0x00181005, "Generator ID", VR.kLO, VM.k1, false);
  static const PublicTag kGridID
      //(0018,1006)
      = const PublicTag("GridID", 0x00181006, "Grid ID", VR.kLO, VM.k1, false);
  static const PublicTag kCassetteID
      //(0018,1007)
      = const PublicTag("CassetteID", 0x00181007, "Cassette ID", VR.kLO, VM.k1, false);
  static const PublicTag kGantryID
      //(0018,1008)
      = const PublicTag("GantryID", 0x00181008, "Gantry ID", VR.kLO, VM.k1, false);
  static const PublicTag kSecondaryCaptureDeviceID
      //(0018,1010)
      = const PublicTag("SecondaryCaptureDeviceID", 0x00181010,
          "Secondary Capture Device ID", VR.kLO, VM.k1, false);
  static const PublicTag kHardcopyCreationDeviceID
      //(0018,1011)
      = const PublicTag("HardcopyCreationDeviceID", 0x00181011,
          "Hardcopy Creation Device ID", VR.kLO, VM.k1, true);
  static const PublicTag kDateOfSecondaryCapture
      //(0018,1012)
      = const PublicTag("DateOfSecondaryCapture", 0x00181012, "Date of Secondary Capture",
          VR.kDA, VM.k1, false);
  static const PublicTag kTimeOfSecondaryCapture
      //(0018,1014)
      = const PublicTag("TimeOfSecondaryCapture", 0x00181014, "Time of Secondary Capture",
          VR.kTM, VM.k1, false);
  static const PublicTag kSecondaryCaptureDeviceManufacturer
      //(0018,1016)
      = const PublicTag("SecondaryCaptureDeviceManufacturer", 0x00181016,
          "Secondary Capture Device Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kHardcopyDeviceManufacturer
      //(0018,1017)
      = const PublicTag("HardcopyDeviceManufacturer", 0x00181017,
          "Hardcopy Device Manufacturer", VR.kLO, VM.k1, true);
  static const PublicTag kSecondaryCaptureDeviceManufacturerModelName
      //(0018,1018)
      = const PublicTag("SecondaryCaptureDeviceManufacturerModelName", 0x00181018,
          "Secondary Capture Device Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const PublicTag kSecondaryCaptureDeviceSoftwareVersions
      //(0018,1019)
      = const PublicTag("SecondaryCaptureDeviceSoftwareVersions", 0x00181019,
          "Secondary Capture Device Software Versions", VR.kLO, VM.k1_n, false);
  static const PublicTag kHardcopyDeviceSoftwareVersion
      //(0018,101A)
      = const PublicTag("HardcopyDeviceSoftwareVersion", 0x0018101A,
          "Hardcopy Device Software Version", VR.kLO, VM.k1_n, true);
  static const PublicTag kHardcopyDeviceManufacturerModelName
      //(0018,101B)
      = const PublicTag("HardcopyDeviceManufacturerModelName", 0x0018101B,
          "Hardcopy Device Manufacturer's Model Name", VR.kLO, VM.k1, true);
  static const PublicTag kSoftwareVersions
      //(0018,1020)
      = const PublicTag(
          "SoftwareVersions", 0x00181020, "Software Version(s)", VR.kLO, VM.k1_n, false);
  static const PublicTag kVideoImageFormatAcquired
      //(0018,1022)
      = const PublicTag("VideoImageFormatAcquired", 0x00181022,
          "Video Image Format Acquired", VR.kSH, VM.k1, false);
  static const PublicTag kDigitalImageFormatAcquired
      //(0018,1023)
      = const PublicTag("DigitalImageFormatAcquired", 0x00181023,
          "Digital Image Format Acquired", VR.kLO, VM.k1, false);
  static const PublicTag kProtocolName
      //(0018,1030)
      =
      const PublicTag("ProtocolName", 0x00181030, "Protocol Name", VR.kLO, VM.k1, false);
  static const PublicTag kContrastBolusRoute
      //(0018,1040)
      = const PublicTag(
          "ContrastBolusRoute", 0x00181040, "Contrast/Bolus Route", VR.kLO, VM.k1, false);
  static const PublicTag kContrastBolusVolume
      //(0018,1041)
      = const PublicTag("ContrastBolusVolume", 0x00181041, "Contrast/Bolus Volume",
          VR.kDS, VM.k1, false);
  static const PublicTag kContrastBolusStartTime
      //(0018,1042)
      = const PublicTag("ContrastBolusStartTime", 0x00181042, "Contrast/Bolus Start Time",
          VR.kTM, VM.k1, false);
  static const PublicTag kContrastBolusStopTime
      //(0018,1043)
      = const PublicTag("ContrastBolusStopTime", 0x00181043, "Contrast/Bolus Stop Time",
          VR.kTM, VM.k1, false);
  static const PublicTag kContrastBolusTotalDose
      //(0018,1044)
      = const PublicTag("ContrastBolusTotalDose", 0x00181044, "Contrast/Bolus Total Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kSyringeCounts
      //(0018,1045)
      = const PublicTag(
          "SyringeCounts", 0x00181045, "Syringe Counts", VR.kIS, VM.k1, false);
  static const PublicTag kContrastFlowRate
      //(0018,1046)
      = const PublicTag(
          "ContrastFlowRate", 0x00181046, "Contrast Flow Rate", VR.kDS, VM.k1_n, false);
  static const PublicTag kContrastFlowDuration
      //(0018,1047)
      = const PublicTag("ContrastFlowDuration", 0x00181047, "Contrast Flow Duration",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kContrastBolusIngredient
      //(0018,1048)
      = const PublicTag("ContrastBolusIngredient", 0x00181048,
          "Contrast/Bolus Ingredient", VR.kCS, VM.k1, false);
  static const PublicTag kContrastBolusIngredientConcentration
      //(0018,1049)
      = const PublicTag("ContrastBolusIngredientConcentration", 0x00181049,
          "Contrast/Bolus Ingredient Concentration", VR.kDS, VM.k1, false);
  static const PublicTag kSpatialResolution
      //(0018,1050)
      = const PublicTag(
          "SpatialResolution", 0x00181050, "Spatial Resolution", VR.kDS, VM.k1, false);
  static const PublicTag kTriggerTime
      //(0018,1060)
      = const PublicTag("TriggerTime", 0x00181060, "Trigger Time", VR.kDS, VM.k1, false);
  static const PublicTag kTriggerSourceOrType
      //(0018,1061)
      = const PublicTag("TriggerSourceOrType", 0x00181061, "Trigger Source or Type",
          VR.kLO, VM.k1, false);
  static const PublicTag kNominalInterval
      //(0018,1062)
      = const PublicTag(
          "NominalInterval", 0x00181062, "Nominal Interval", VR.kIS, VM.k1, false);
  static const PublicTag kFrameTime
      //(0018,1063)
      = const PublicTag("FrameTime", 0x00181063, "Frame Time", VR.kDS, VM.k1, false);
  static const PublicTag kCardiacFramingType
      //(0018,1064)
      = const PublicTag(
          "CardiacFramingType", 0x00181064, "Cardiac Framing Type", VR.kLO, VM.k1, false);
  static const PublicTag kFrameTimeVector
      //(0018,1065)
      = const PublicTag(
          "FrameTimeVector", 0x00181065, "Frame Time Vector", VR.kDS, VM.k1_n, false);
  static const PublicTag kFrameDelay
      //(0018,1066)
      = const PublicTag("FrameDelay", 0x00181066, "Frame Delay", VR.kDS, VM.k1, false);
  static const PublicTag kImageTriggerDelay
      //(0018,1067)
      = const PublicTag(
          "ImageTriggerDelay", 0x00181067, "Image Trigger Delay", VR.kDS, VM.k1, false);
  static const PublicTag kMultiplexGroupTimeOffset
      //(0018,1068)
      = const PublicTag("MultiplexGroupTimeOffset", 0x00181068,
          "Multiplex Group Time Offset", VR.kDS, VM.k1, false);
  static const PublicTag kTriggerTimeOffset
      //(0018,1069)
      = const PublicTag(
          "TriggerTimeOffset", 0x00181069, "Trigger Time Offset", VR.kDS, VM.k1, false);
  static const PublicTag kSynchronizationTrigger
      //(0018,106A)
      = const PublicTag("SynchronizationTrigger", 0x0018106A, "Synchronization Trigger",
          VR.kCS, VM.k1, false);
  static const PublicTag kSynchronizationChannel
      //(0018,106C)
      = const PublicTag("SynchronizationChannel", 0x0018106C, "Synchronization Channel",
          VR.kUS, VM.k2, false);
  static const PublicTag kTriggerSamplePosition
      //(0018,106E)
      = const PublicTag("TriggerSamplePosition", 0x0018106E, "Trigger Sample Position",
          VR.kUL, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalRoute
      //(0018,1070)
      = const PublicTag("RadiopharmaceuticalRoute", 0x00181070,
          "Radiopharmaceutical Route", VR.kLO, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalVolume
      //(0018,1071)
      = const PublicTag("RadiopharmaceuticalVolume", 0x00181071,
          "Radiopharmaceutical Volume", VR.kDS, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalStartTime
      //(0018,1072)
      = const PublicTag("RadiopharmaceuticalStartTime", 0x00181072,
          "Radiopharmaceutical Start Time", VR.kTM, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalStopTime
      //(0018,1073)
      = const PublicTag("RadiopharmaceuticalStopTime", 0x00181073,
          "Radiopharmaceutical Stop Time", VR.kTM, VM.k1, false);
  static const PublicTag kRadionuclideTotalDose
      //(0018,1074)
      = const PublicTag("RadionuclideTotalDose", 0x00181074, "Radionuclide Total Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kRadionuclideHalfLife
      //(0018,1075)
      = const PublicTag("RadionuclideHalfLife", 0x00181075, "Radionuclide Half Life",
          VR.kDS, VM.k1, false);
  static const PublicTag kRadionuclidePositronFraction
      //(0018,1076)
      = const PublicTag("RadionuclidePositronFraction", 0x00181076,
          "Radionuclide Positron Fraction", VR.kDS, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalSpecificActivity
      //(0018,1077)
      = const PublicTag("RadiopharmaceuticalSpecificActivity", 0x00181077,
          "Radiopharmaceutical Specific Activity", VR.kDS, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalStartDateTime
      //(0018,1078)
      = const PublicTag("RadiopharmaceuticalStartDateTime", 0x00181078,
          "Radiopharmaceutical Start DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalStopDateTime
      //(0018,1079)
      = const PublicTag("RadiopharmaceuticalStopDateTime", 0x00181079,
          "Radiopharmaceutical Stop DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kBeatRejectionFlag
      //(0018,1080)
      = const PublicTag(
          "BeatRejectionFlag", 0x00181080, "Beat Rejection Flag", VR.kCS, VM.k1, false);
  static const PublicTag kLowRRValue
      //(0018,1081)
      = const PublicTag("LowRRValue", 0x00181081, "Low R-R Value", VR.kIS, VM.k1, false);
  static const PublicTag kHighRRValue
      //(0018,1082)
      =
      const PublicTag("HighRRValue", 0x00181082, "High R-R Value", VR.kIS, VM.k1, false);
  static const PublicTag kIntervalsAcquired
      //(0018,1083)
      = const PublicTag(
          "IntervalsAcquired", 0x00181083, "Intervals Acquired", VR.kIS, VM.k1, false);
  static const PublicTag kIntervalsRejected
      //(0018,1084)
      = const PublicTag(
          "IntervalsRejected", 0x00181084, "Intervals Rejected", VR.kIS, VM.k1, false);
  static const PublicTag kPVCRejection
      //(0018,1085)
      =
      const PublicTag("PVCRejection", 0x00181085, "PVC Rejection", VR.kLO, VM.k1, false);
  static const PublicTag kSkipBeats
      //(0018,1086)
      = const PublicTag("SkipBeats", 0x00181086, "Skip Beats", VR.kIS, VM.k1, false);
  static const PublicTag kHeartRate
      //(0018,1088)
      = const PublicTag("HeartRate", 0x00181088, "Heart Rate", VR.kIS, VM.k1, false);
  static const PublicTag kCardiacNumberOfImages
      //(0018,1090)
      = const PublicTag("CardiacNumberOfImages", 0x00181090, "Cardiac Number of Images",
          VR.kIS, VM.k1, false);
  static const PublicTag kTriggerWindow
      //(0018,1094)
      = const PublicTag(
          "TriggerWindow", 0x00181094, "Trigger Window", VR.kIS, VM.k1, false);
  static const PublicTag kReconstructionDiameter
      //(0018,1100)
      = const PublicTag("ReconstructionDiameter", 0x00181100, "Reconstruction Diameter",
          VR.kDS, VM.k1, false);
  static const PublicTag kDistanceSourceToDetector
      //(0018,1110)
      = const PublicTag("DistanceSourceToDetector", 0x00181110,
          "Distance Source to Detector", VR.kDS, VM.k1, false);
  static const PublicTag kDistanceSourceToPatient
      //(0018,1111)
      = const PublicTag("DistanceSourceToPatient", 0x00181111,
          "Distance Source to Patient", VR.kDS, VM.k1, false);
  static const PublicTag kEstimatedRadiographicMagnificationFactor
      //(0018,1114)
      = const PublicTag("EstimatedRadiographicMagnificationFactor", 0x00181114,
          "Estimated Radiographic Magnification Factor", VR.kDS, VM.k1, false);
  static const PublicTag kGantryDetectorTilt
      //(0018,1120)
      = const PublicTag(
          "GantryDetectorTilt", 0x00181120, "Gantry/Detector Tilt", VR.kDS, VM.k1, false);
  static const PublicTag kGantryDetectorSlew
      //(0018,1121)
      = const PublicTag(
          "GantryDetectorSlew", 0x00181121, "Gantry/Detector Slew", VR.kDS, VM.k1, false);
  static const PublicTag kTableHeight
      //(0018,1130)
      = const PublicTag("TableHeight", 0x00181130, "Table Height", VR.kDS, VM.k1, false);
  static const PublicTag kTableTraverse
      //(0018,1131)
      = const PublicTag(
          "TableTraverse", 0x00181131, "Table Traverse", VR.kDS, VM.k1, false);
  static const PublicTag kTableMotion
      //(0018,1134)
      = const PublicTag("TableMotion", 0x00181134, "Table Motion", VR.kCS, VM.k1, false);
  static const PublicTag kTableVerticalIncrement
      //(0018,1135)
      = const PublicTag("TableVerticalIncrement", 0x00181135, "Table Vertical Increment",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kTableLateralIncrement
      //(0018,1136)
      = const PublicTag("TableLateralIncrement", 0x00181136, "Table Lateral Increment",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kTableLongitudinalIncrement
      //(0018,1137)
      = const PublicTag("TableLongitudinalIncrement", 0x00181137,
          "Table Longitudinal Increment", VR.kDS, VM.k1_n, false);
  static const PublicTag kTableAngle
      //(0018,1138)
      = const PublicTag("TableAngle", 0x00181138, "Table Angle", VR.kDS, VM.k1, false);
  static const PublicTag kTableType
      //(0018,113A)
      = const PublicTag("TableType", 0x0018113A, "Table Type", VR.kCS, VM.k1, false);
  static const PublicTag kRotationDirection
      //(0018,1140)
      = const PublicTag(
          "RotationDirection", 0x00181140, "Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kAngularPosition
      //(0018,1141)
      = const PublicTag(
          "AngularPosition", 0x00181141, "Angular Position", VR.kDS, VM.k1, true);
  static const PublicTag kRadialPosition
      //(0018,1142)
      = const PublicTag(
          "RadialPosition", 0x00181142, "Radial Position", VR.kDS, VM.k1_n, false);
  static const PublicTag kScanArc
      //(0018,1143)
      = const PublicTag("ScanArc", 0x00181143, "Scan Arc", VR.kDS, VM.k1, false);
  static const PublicTag kAngularStep
      //(0018,1144)
      = const PublicTag("AngularStep", 0x00181144, "Angular Step", VR.kDS, VM.k1, false);
  static const PublicTag kCenterOfRotationOffset
      //(0018,1145)
      = const PublicTag("CenterOfRotationOffset", 0x00181145, "Center of Rotation Offset",
          VR.kDS, VM.k1, false);
  static const PublicTag kRotationOffset
      //(0018,1146)
      = const PublicTag(
          "RotationOffset", 0x00181146, "Rotation Offset", VR.kDS, VM.k1_n, true);
  static const PublicTag kFieldOfViewShape
      //(0018,1147)
      = const PublicTag(
          "FieldOfViewShape", 0x00181147, "Field of View Shape", VR.kCS, VM.k1, false);
  static const PublicTag kFieldOfViewDimensions
      //(0018,1149)
      = const PublicTag("FieldOfViewDimensions", 0x00181149, "Field of View Dimension(s)",
          VR.kIS, VM.k1_2, false);
  static const PublicTag kExposureTime
      //(0018,1150)
      =
      const PublicTag("ExposureTime", 0x00181150, "Exposure Time", VR.kIS, VM.k1, false);
  static const PublicTag kXRayTubeCurrent
      //(0018,1151)
      = const PublicTag(
          "XRayTubeCurrent", 0x00181151, "X-Ray Tube Current", VR.kIS, VM.k1, false);
  static const PublicTag kExposure
      //(0018,1152)
      = const PublicTag("Exposure", 0x00181152, "Exposure", VR.kIS, VM.k1, false);
  static const PublicTag kExposureInuAs
      //(0018,1153)
      = const PublicTag(
          "ExposureInuAs", 0x00181153, "Exposure in µAs", VR.kIS, VM.k1, false);
  static const PublicTag kAveragePulseWidth
      //(0018,1154)
      = const PublicTag(
          "AveragePulseWidth", 0x00181154, "Average Pulse Width", VR.kDS, VM.k1, false);
  static const PublicTag kRadiationSetting
      //(0018,1155)
      = const PublicTag(
          "RadiationSetting", 0x00181155, "Radiation Setting", VR.kCS, VM.k1, false);
  static const PublicTag kRectificationType
      //(0018,1156)
      = const PublicTag(
          "RectificationType", 0x00181156, "Rectification Type", VR.kCS, VM.k1, false);
  static const PublicTag kRadiationMode
      //(0018,115A)
      = const PublicTag(
          "RadiationMode", 0x0018115A, "Radiation Mode", VR.kCS, VM.k1, false);
  static const PublicTag kImageAndFluoroscopyAreaDoseProduct
      //(0018,115E)
      = const PublicTag("ImageAndFluoroscopyAreaDoseProduct", 0x0018115E,
          "Image and Fluoroscopy Area Dose Product", VR.kDS, VM.k1, false);
  static const PublicTag kFilterType
      //(0018,1160)
      = const PublicTag("FilterType", 0x00181160, "Filter Type", VR.kSH, VM.k1, false);
  static const PublicTag kTypeOfFilters
      //(0018,1161)
      = const PublicTag(
          "TypeOfFilters", 0x00181161, "Type of Filters", VR.kLO, VM.k1_n, false);
  static const PublicTag kIntensifierSize
      //(0018,1162)
      = const PublicTag(
          "IntensifierSize", 0x00181162, "Intensifier Size", VR.kDS, VM.k1, false);
  static const PublicTag kImagerPixelSpacing
      //(0018,1164)
      = const PublicTag(
          "ImagerPixelSpacing", 0x00181164, "Imager Pixel Spacing", VR.kDS, VM.k2, false);
  static const PublicTag kGrid
      //(0018,1166)
      = const PublicTag("Grid", 0x00181166, "Grid", VR.kCS, VM.k1_n, false);
  static const PublicTag kGeneratorPower
      //(0018,1170)
      = const PublicTag(
          "GeneratorPower", 0x00181170, "Generator Power", VR.kIS, VM.k1, false);
  static const PublicTag kCollimatorGridName
      //(0018,1180)
      = const PublicTag(
          "CollimatorGridName", 0x00181180, "Collimator/grid Name", VR.kSH, VM.k1, false);
  static const PublicTag kCollimatorType
      //(0018,1181)
      = const PublicTag(
          "CollimatorType", 0x00181181, "Collimator Type", VR.kCS, VM.k1, false);
  static const PublicTag kFocalDistance
      //(0018,1182)
      = const PublicTag(
          "FocalDistance", 0x00181182, "Focal Distance", VR.kIS, VM.k1_2, false);
  static const PublicTag kXFocusCenter
      //(0018,1183)
      = const PublicTag(
          "XFocusCenter", 0x00181183, "X Focus Center", VR.kDS, VM.k1_2, false);
  static const PublicTag kYFocusCenter
      //(0018,1184)
      = const PublicTag(
          "YFocusCenter", 0x00181184, "Y Focus Center", VR.kDS, VM.k1_2, false);
  static const PublicTag kFocalSpots
      //(0018,1190)
      =
      const PublicTag("FocalSpots", 0x00181190, "Focal Spot(s)", VR.kDS, VM.k1_n, false);
  static const PublicTag kAnodeTargetMaterial
      //(0018,1191)
      = const PublicTag("AnodeTargetMaterial", 0x00181191, "Anode Target Material",
          VR.kCS, VM.k1, false);
  static const PublicTag kBodyPartThickness
      //(0018,11A0)
      = const PublicTag(
          "BodyPartThickness", 0x001811A0, "Body Part Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kCompressionForce
      //(0018,11A2)
      = const PublicTag(
          "CompressionForce", 0x001811A2, "Compression Force", VR.kDS, VM.k1, false);
  static const PublicTag kPaddleDescription
      //(0018,11A4)
      = const PublicTag(
          "PaddleDescription", 0x001811A4, "Paddle Description", VR.kLO, VM.k1, false);
  static const PublicTag kDateOfLastCalibration
      //(0018,1200)
      = const PublicTag("DateOfLastCalibration", 0x00181200, "Date of Last Calibration",
          VR.kDA, VM.k1_n, false);
  static const PublicTag kTimeOfLastCalibration
      //(0018,1201)
      = const PublicTag("TimeOfLastCalibration", 0x00181201, "Time of Last Calibration",
          VR.kTM, VM.k1_n, false);
  static const PublicTag kConvolutionKernel
      //(0018,1210)
      = const PublicTag(
          "ConvolutionKernel", 0x00181210, "Convolution Kernel", VR.kSH, VM.k1_n, false);
  static const PublicTag kUpperLowerPixelValues
      //(0018,1240)
      = const PublicTag("UpperLowerPixelValues", 0x00181240, "Upper/Lower Pixel Values",
          VR.kIS, VM.k1_n, true);
  static const PublicTag kActualFrameDuration
      //(0018,1242)
      = const PublicTag("ActualFrameDuration", 0x00181242, "Actual Frame Duration",
          VR.kIS, VM.k1, false);
  static const PublicTag kCountRate
      //(0018,1243)
      = const PublicTag("CountRate", 0x00181243, "Count Rate", VR.kIS, VM.k1, false);
  static const PublicTag kPreferredPlaybackSequencing
      //(0018,1244)
      = const PublicTag("PreferredPlaybackSequencing", 0x00181244,
          "Preferred Playback Sequencing", VR.kUS, VM.k1, false);
  static const PublicTag kReceiveCoilName
      //(0018,1250)
      = const PublicTag(
          "ReceiveCoilName", 0x00181250, "Receive Coil Name", VR.kSH, VM.k1, false);
  static const PublicTag kTransmitCoilName
      //(0018,1251)
      = const PublicTag(
          "TransmitCoilName", 0x00181251, "Transmit Coil Name", VR.kSH, VM.k1, false);
  static const PublicTag kPlateType
      //(0018,1260)
      = const PublicTag("PlateType", 0x00181260, "Plate Type", VR.kSH, VM.k1, false);
  static const PublicTag kPhosphorType
      //(0018,1261)
      =
      const PublicTag("PhosphorType", 0x00181261, "Phosphor Type", VR.kLO, VM.k1, false);
  static const PublicTag kScanVelocity
      //(0018,1300)
      =
      const PublicTag("ScanVelocity", 0x00181300, "Scan Velocity", VR.kDS, VM.k1, false);
  static const PublicTag kWholeBodyTechnique
      //(0018,1301)
      = const PublicTag("WholeBodyTechnique", 0x00181301, "Whole Body Technique", VR.kCS,
          VM.k1_n, false);
  static const PublicTag kScanLength
      //(0018,1302)
      = const PublicTag("ScanLength", 0x00181302, "Scan Length", VR.kIS, VM.k1, false);
  static const PublicTag kAcquisitionMatrix
      //(0018,1310)
      = const PublicTag(
          "AcquisitionMatrix", 0x00181310, "Acquisition Matrix", VR.kUS, VM.k4, false);
  static const PublicTag kInPlanePhaseEncodingDirection
      //(0018,1312)
      = const PublicTag("InPlanePhaseEncodingDirection", 0x00181312,
          "In-plane Phase Encoding Direction", VR.kCS, VM.k1, false);
  static const PublicTag kFlipAngle
      //(0018,1314)
      = const PublicTag("FlipAngle", 0x00181314, "Flip Angle", VR.kDS, VM.k1, false);
  static const PublicTag kVariableFlipAngleFlag
      //(0018,1315)
      = const PublicTag("VariableFlipAngleFlag", 0x00181315, "Variable Flip Angle Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kSAR
      //(0018,1316)
      = const PublicTag("SAR", 0x00181316, "SAR", VR.kDS, VM.k1, false);
  static const PublicTag kdBdt
      //(0018,1318)
      = const PublicTag("dBdt", 0x00181318, "dB/dt", VR.kDS, VM.k1, false);
  static const PublicTag kAcquisitionDeviceProcessingDescription
      //(0018,1400)
      = const PublicTag("AcquisitionDeviceProcessingDescription", 0x00181400,
          "Acquisition Device Processing Description", VR.kLO, VM.k1, false);
  static const PublicTag kAcquisitionDeviceProcessingCode
      //(0018,1401)
      = const PublicTag("AcquisitionDeviceProcessingCode", 0x00181401,
          "Acquisition Device Processing Code", VR.kLO, VM.k1, false);
  static const PublicTag kCassetteOrientation
      //(0018,1402)
      = const PublicTag("CassetteOrientation", 0x00181402, "Cassette Orientation", VR.kCS,
          VM.k1, false);
  static const PublicTag kCassetteSize
      //(0018,1403)
      =
      const PublicTag("CassetteSize", 0x00181403, "Cassette Size", VR.kCS, VM.k1, false);
  static const PublicTag kExposuresOnPlate
      //(0018,1404)
      = const PublicTag(
          "ExposuresOnPlate", 0x00181404, "Exposures on Plate", VR.kUS, VM.k1, false);
  static const PublicTag kRelativeXRayExposure
      //(0018,1405)
      = const PublicTag("RelativeXRayExposure", 0x00181405, "Relative X-Ray Exposure",
          VR.kIS, VM.k1, false);
  static const PublicTag kExposureIndex
      //(0018,1411)
      = const PublicTag(
          "ExposureIndex", 0x00181411, "Exposure Index", VR.kDS, VM.k1, false);
  static const PublicTag kTargetExposureIndex
      //(0018,1412)
      = const PublicTag("TargetExposureIndex", 0x00181412, "Target Exposure Index",
          VR.kDS, VM.k1, false);
  static const PublicTag kDeviationIndex
      //(0018,1413)
      = const PublicTag(
          "DeviationIndex", 0x00181413, "Deviation Index", VR.kDS, VM.k1, false);
  static const PublicTag kColumnAngulation
      //(0018,1450)
      = const PublicTag(
          "ColumnAngulation", 0x00181450, "Column Angulation", VR.kDS, VM.k1, false);
  static const PublicTag kTomoLayerHeight
      //(0018,1460)
      = const PublicTag(
          "TomoLayerHeight", 0x00181460, "Tomo Layer Height", VR.kDS, VM.k1, false);
  static const PublicTag kTomoAngle
      //(0018,1470)
      = const PublicTag("TomoAngle", 0x00181470, "Tomo Angle", VR.kDS, VM.k1, false);
  static const PublicTag kTomoTime
      //(0018,1480)
      = const PublicTag("TomoTime", 0x00181480, "Tomo Time", VR.kDS, VM.k1, false);
  static const PublicTag kTomoType
      //(0018,1490)
      = const PublicTag("TomoType", 0x00181490, "Tomo Type", VR.kCS, VM.k1, false);
  static const PublicTag kTomoClass
      //(0018,1491)
      = const PublicTag("TomoClass", 0x00181491, "Tomo Class", VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfTomosynthesisSourceImages
      //(0018,1495)
      = const PublicTag("NumberOfTomosynthesisSourceImages", 0x00181495,
          "Number of Tomosynthesis Source Images", VR.kIS, VM.k1, false);
  static const PublicTag kPositionerMotion
      //(0018,1500)
      = const PublicTag(
          "PositionerMotion", 0x00181500, "Positioner Motion", VR.kCS, VM.k1, false);
  static const PublicTag kPositionerType
      //(0018,1508)
      = const PublicTag(
          "PositionerType", 0x00181508, "Positioner Type", VR.kCS, VM.k1, false);
  static const PublicTag kPositionerPrimaryAngle
      //(0018,1510)
      = const PublicTag("PositionerPrimaryAngle", 0x00181510, "Positioner Primary Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kPositionerSecondaryAngle
      //(0018,1511)
      = const PublicTag("PositionerSecondaryAngle", 0x00181511,
          "Positioner Secondary Angle", VR.kDS, VM.k1, false);
  static const PublicTag kPositionerPrimaryAngleIncrement
      //(0018,1520)
      = const PublicTag("PositionerPrimaryAngleIncrement", 0x00181520,
          "Positioner Primary Angle Increment", VR.kDS, VM.k1_n, false);
  static const PublicTag kPositionerSecondaryAngleIncrement
      //(0018,1521)
      = const PublicTag("PositionerSecondaryAngleIncrement", 0x00181521,
          "Positioner Secondary Angle Increment", VR.kDS, VM.k1_n, false);
  static const PublicTag kDetectorPrimaryAngle
      //(0018,1530)
      = const PublicTag("DetectorPrimaryAngle", 0x00181530, "Detector Primary Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kDetectorSecondaryAngle
      //(0018,1531)
      = const PublicTag("DetectorSecondaryAngle", 0x00181531, "Detector Secondary Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kShutterShape
      //(0018,1600)
      = const PublicTag(
          "ShutterShape", 0x00181600, "Shutter Shape", VR.kCS, VM.k1_3, false);
  static const PublicTag kShutterLeftVerticalEdge
      //(0018,1602)
      = const PublicTag("ShutterLeftVerticalEdge", 0x00181602,
          "Shutter Left Vertical Edge", VR.kIS, VM.k1, false);
  static const PublicTag kShutterRightVerticalEdge
      //(0018,1604)
      = const PublicTag("ShutterRightVerticalEdge", 0x00181604,
          "Shutter Right Vertical Edge", VR.kIS, VM.k1, false);
  static const PublicTag kShutterUpperHorizontalEdge
      //(0018,1606)
      = const PublicTag("ShutterUpperHorizontalEdge", 0x00181606,
          "Shutter Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const PublicTag kShutterLowerHorizontalEdge
      //(0018,1608)
      = const PublicTag("ShutterLowerHorizontalEdge", 0x00181608,
          "Shutter Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const PublicTag kCenterOfCircularShutter
      //(0018,1610)
      = const PublicTag("CenterOfCircularShutter", 0x00181610,
          "Center of Circular Shutter", VR.kIS, VM.k2, false);
  static const PublicTag kRadiusOfCircularShutter
      //(0018,1612)
      = const PublicTag("RadiusOfCircularShutter", 0x00181612,
          "Radius of Circular Shutter", VR.kIS, VM.k1, false);
  static const PublicTag kVerticesOfThePolygonalShutter
      //(0018,1620)
      = const PublicTag("VerticesOfThePolygonalShutter", 0x00181620,
          "Vertices of the Polygonal Shutter", VR.kIS, VM.k2_2n, false);
  static const PublicTag kShutterPresentationValue
      //(0018,1622)
      = const PublicTag("ShutterPresentationValue", 0x00181622,
          "Shutter Presentation Value", VR.kUS, VM.k1, false);
  static const PublicTag kShutterOverlayGroup
      //(0018,1623)
      = const PublicTag("ShutterOverlayGroup", 0x00181623, "Shutter Overlay Group",
          VR.kUS, VM.k1, false);
  static const PublicTag kShutterPresentationColorCIELabValue
      //(0018,1624)
      = const PublicTag("ShutterPresentationColorCIELabValue", 0x00181624,
          "Shutter Presentation Color CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kCollimatorShape
      //(0018,1700)
      = const PublicTag(
          "CollimatorShape", 0x00181700, "Collimator Shape", VR.kCS, VM.k1_3, false);
  static const PublicTag kCollimatorLeftVerticalEdge
      //(0018,1702)
      = const PublicTag("CollimatorLeftVerticalEdge", 0x00181702,
          "Collimator Left Vertical Edge", VR.kIS, VM.k1, false);
  static const PublicTag kCollimatorRightVerticalEdge
      //(0018,1704)
      = const PublicTag("CollimatorRightVerticalEdge", 0x00181704,
          "Collimator Right Vertical Edge", VR.kIS, VM.k1, false);
  static const PublicTag kCollimatorUpperHorizontalEdge
      //(0018,1706)
      = const PublicTag("CollimatorUpperHorizontalEdge", 0x00181706,
          "Collimator Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const PublicTag kCollimatorLowerHorizontalEdge
      //(0018,1708)
      = const PublicTag("CollimatorLowerHorizontalEdge", 0x00181708,
          "Collimator Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const PublicTag kCenterOfCircularCollimator
      //(0018,1710)
      = const PublicTag("CenterOfCircularCollimator", 0x00181710,
          "Center of Circular Collimator", VR.kIS, VM.k2, false);
  static const PublicTag kRadiusOfCircularCollimator
      //(0018,1712)
      = const PublicTag("RadiusOfCircularCollimator", 0x00181712,
          "Radius of Circular Collimator", VR.kIS, VM.k1, false);
  static const PublicTag kVerticesOfThePolygonalCollimator
      //(0018,1720)
      = const PublicTag("VerticesOfThePolygonalCollimator", 0x00181720,
          "Vertices of the Polygonal Collimator", VR.kIS, VM.k2_2n, false);
  static const PublicTag kAcquisitionTimeSynchronized
      //(0018,1800)
      = const PublicTag("AcquisitionTimeSynchronized", 0x00181800,
          "Acquisition Time Synchronized", VR.kCS, VM.k1, false);
  static const PublicTag kTimeSource
      //(0018,1801)
      = const PublicTag("TimeSource", 0x00181801, "Time Source", VR.kSH, VM.k1, false);
  static const PublicTag kTimeDistributionProtocol
      //(0018,1802)
      = const PublicTag("TimeDistributionProtocol", 0x00181802,
          "Time Distribution Protocol", VR.kCS, VM.k1, false);
  static const PublicTag kNTPSourceAddress
      //(0018,1803)
      = const PublicTag(
          "NTPSourceAddress", 0x00181803, "NTP Source Address", VR.kLO, VM.k1, false);
  static const PublicTag kPageNumberVector
      //(0018,2001)
      = const PublicTag(
          "PageNumberVector", 0x00182001, "Page Number Vector", VR.kIS, VM.k1_n, false);
  static const PublicTag kFrameLabelVector
      //(0018,2002)
      = const PublicTag(
          "FrameLabelVector", 0x00182002, "Frame Label Vector", VR.kSH, VM.k1_n, false);
  static const PublicTag kFramePrimaryAngleVector
      //(0018,2003)
      = const PublicTag("FramePrimaryAngleVector", 0x00182003,
          "Frame Primary Angle Vector", VR.kDS, VM.k1_n, false);
  static const PublicTag kFrameSecondaryAngleVector
      //(0018,2004)
      = const PublicTag("FrameSecondaryAngleVector", 0x00182004,
          "Frame Secondary Angle Vector", VR.kDS, VM.k1_n, false);
  static const PublicTag kSliceLocationVector
      //(0018,2005)
      = const PublicTag("SliceLocationVector", 0x00182005, "Slice Location Vector",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kDisplayWindowLabelVector
      //(0018,2006)
      = const PublicTag("DisplayWindowLabelVector", 0x00182006,
          "Display Window Label Vector", VR.kSH, VM.k1_n, false);
  static const PublicTag kNominalScannedPixelSpacing
      //(0018,2010)
      = const PublicTag("NominalScannedPixelSpacing", 0x00182010,
          "Nominal Scanned Pixel Spacing", VR.kDS, VM.k2, false);
  static const PublicTag kDigitizingDeviceTransportDirection
      //(0018,2020)
      = const PublicTag("DigitizingDeviceTransportDirection", 0x00182020,
          "Digitizing Device Transport Direction", VR.kCS, VM.k1, false);
  static const PublicTag kRotationOfScannedFilm
      //(0018,2030)
      = const PublicTag("RotationOfScannedFilm", 0x00182030, "Rotation of Scanned Film",
          VR.kDS, VM.k1, false);
  static const PublicTag kBiopsyTargetSequence
      //(0018,2041)
      = const PublicTag("BiopsyTargetSequence", 0x00182041, "Biopsy Target Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTargetUID
      //(0018,2042)
      = const PublicTag("TargetUID", 0x00182042, "Target UID", VR.kUI, VM.k1, false);
  static const PublicTag kLocalizingCursorPosition
      //(0018,2043)
      = const PublicTag("LocalizingCursorPosition", 0x00182043,
          "Localizing Cursor Position", VR.kFL, VM.k2, false);
  static const PublicTag kCalculatedTargetPosition
      //(0018,2044)
      = const PublicTag("CalculatedTargetPosition", 0x00182044,
          "Calculated Target Position", VR.kFL, VM.k3, false);
  static const PublicTag kTargetLabel
      //(0018,2045)
      = const PublicTag("TargetLabel", 0x00182045, "Target Label", VR.kSH, VM.k1, false);
  static const PublicTag kDisplayedZValue
      //(0018,2046)
      = const PublicTag(
          "DisplayedZValue", 0x00182046, "Displayed Z Value", VR.kFL, VM.k1, false);
  static const PublicTag kIVUSAcquisition
      //(0018,3100)
      = const PublicTag(
          "IVUSAcquisition", 0x00183100, "IVUS Acquisition", VR.kCS, VM.k1, false);
  static const PublicTag kIVUSPullbackRate
      //(0018,3101)
      = const PublicTag(
          "IVUSPullbackRate", 0x00183101, "IVUS Pullback Rate", VR.kDS, VM.k1, false);
  static const PublicTag kIVUSGatedRate
      //(0018,3102)
      = const PublicTag(
          "IVUSGatedRate", 0x00183102, "IVUS Gated Rate", VR.kDS, VM.k1, false);
  static const PublicTag kIVUSPullbackStartFrameNumber
      //(0018,3103)
      = const PublicTag("IVUSPullbackStartFrameNumber", 0x00183103,
          "IVUS Pullback Start Frame Number", VR.kIS, VM.k1, false);
  static const PublicTag kIVUSPullbackStopFrameNumber
      //(0018,3104)
      = const PublicTag("IVUSPullbackStopFrameNumber", 0x00183104,
          "IVUS Pullback Stop Frame Number", VR.kIS, VM.k1, false);
  static const PublicTag kLesionNumber
      //(0018,3105)
      = const PublicTag(
          "LesionNumber", 0x00183105, "Lesion Number", VR.kIS, VM.k1_n, false);
  static const PublicTag kAcquisitionComments
      //(0018,4000)
      = const PublicTag(
          "AcquisitionComments", 0x00184000, "Acquisition Comments", VR.kLT, VM.k1, true);
  static const PublicTag kOutputPower
      //(0018,5000)
      =
      const PublicTag("OutputPower", 0x00185000, "Output Power", VR.kSH, VM.k1_n, false);
  static const PublicTag kTransducerData
      //(0018,5010)
      = const PublicTag(
          "TransducerData", 0x00185010, "Transducer Data", VR.kLO, VM.k1_n, false);
  static const PublicTag kFocusDepth
      //(0018,5012)
      = const PublicTag("FocusDepth", 0x00185012, "Focus Depth", VR.kDS, VM.k1, false);
  static const PublicTag kProcessingFunction
      //(0018,5020)
      = const PublicTag(
          "ProcessingFunction", 0x00185020, "Processing Function", VR.kLO, VM.k1, false);
  static const PublicTag kPostprocessingFunction
      //(0018,5021)
      = const PublicTag("PostprocessingFunction", 0x00185021, "Postprocessing Function",
          VR.kLO, VM.k1, true);
  static const PublicTag kMechanicalIndex
      //(0018,5022)
      = const PublicTag(
          "MechanicalIndex", 0x00185022, "Mechanical Index", VR.kDS, VM.k1, false);
  static const PublicTag kBoneThermalIndex
      //(0018,5024)
      = const PublicTag(
          "BoneThermalIndex", 0x00185024, "Bone Thermal Index", VR.kDS, VM.k1, false);
  static const PublicTag kCranialThermalIndex
      //(0018,5026)
      = const PublicTag("CranialThermalIndex", 0x00185026, "Cranial Thermal Index",
          VR.kDS, VM.k1, false);
  static const PublicTag kSoftTissueThermalIndex
      //(0018,5027)
      = const PublicTag("SoftTissueThermalIndex", 0x00185027, "Soft Tissue Thermal Index",
          VR.kDS, VM.k1, false);
  static const PublicTag kSoftTissueFocusThermalIndex
      //(0018,5028)
      = const PublicTag("SoftTissueFocusThermalIndex", 0x00185028,
          "Soft Tissue-focus Thermal Index", VR.kDS, VM.k1, false);
  static const PublicTag kSoftTissueSurfaceThermalIndex
      //(0018,5029)
      = const PublicTag("SoftTissueSurfaceThermalIndex", 0x00185029,
          "Soft Tissue-surface Thermal Index", VR.kDS, VM.k1, false);
  static const PublicTag kDynamicRange
      //(0018,5030)
      = const PublicTag("DynamicRange", 0x00185030, "Dynamic Range", VR.kDS, VM.k1, true);
  static const PublicTag kTotalGain
      //(0018,5040)
      = const PublicTag("TotalGain", 0x00185040, "Total Gain", VR.kDS, VM.k1, true);
  static const PublicTag kDepthOfScanField
      //(0018,5050)
      = const PublicTag(
          "DepthOfScanField", 0x00185050, "Depth of Scan Field", VR.kIS, VM.k1, false);
  static const PublicTag kPatientPosition
      //(0018,5100)
      = const PublicTag(
          "PatientPosition", 0x00185100, "Patient Position", VR.kCS, VM.k1, false);
  static const PublicTag kViewPosition
      //(0018,5101)
      =
      const PublicTag("ViewPosition", 0x00185101, "View Position", VR.kCS, VM.k1, false);
  static const PublicTag kProjectionEponymousNameCodeSequence
      //(0018,5104)
      = const PublicTag("ProjectionEponymousNameCodeSequence", 0x00185104,
          "Projection Eponymous Name Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageTransformationMatrix
      //(0018,5210)
      = const PublicTag("ImageTransformationMatrix", 0x00185210,
          "Image Transformation Matrix", VR.kDS, VM.k6, true);
  static const PublicTag kImageTranslationVector
      //(0018,5212)
      = const PublicTag("ImageTranslationVector", 0x00185212, "Image Translation Vector",
          VR.kDS, VM.k3, true);
  static const PublicTag kSensitivity
      //(0018,6000)
      = const PublicTag("Sensitivity", 0x00186000, "Sensitivity", VR.kDS, VM.k1, false);
  static const PublicTag kSequenceOfUltrasoundRegions
      //(0018,6011)
      = const PublicTag("SequenceOfUltrasoundRegions", 0x00186011,
          "Sequence of Ultrasound Regions", VR.kSQ, VM.k1, false);
  static const PublicTag kRegionSpatialFormat
      //(0018,6012)
      = const PublicTag("RegionSpatialFormat", 0x00186012, "Region Spatial Format",
          VR.kUS, VM.k1, false);
  static const PublicTag kRegionDataType
      //(0018,6014)
      = const PublicTag(
          "RegionDataType", 0x00186014, "Region Data Type", VR.kUS, VM.k1, false);
  static const PublicTag kRegionFlags
      //(0018,6016)
      = const PublicTag("RegionFlags", 0x00186016, "Region Flags", VR.kUL, VM.k1, false);
  static const PublicTag kRegionLocationMinX0
      //(0018,6018)
      = const PublicTag("RegionLocationMinX0", 0x00186018, "Region Location Min X0",
          VR.kUL, VM.k1, false);
  static const PublicTag kRegionLocationMinY0
      //(0018,601A)
      = const PublicTag("RegionLocationMinY0", 0x0018601A, "Region Location Min Y0",
          VR.kUL, VM.k1, false);
  static const PublicTag kRegionLocationMaxX1
      //(0018,601C)
      = const PublicTag("RegionLocationMaxX1", 0x0018601C, "Region Location Max X1",
          VR.kUL, VM.k1, false);
  static const PublicTag kRegionLocationMaxY1
      //(0018,601E)
      = const PublicTag("RegionLocationMaxY1", 0x0018601E, "Region Location Max Y1",
          VR.kUL, VM.k1, false);
  static const PublicTag kReferencePixelX0
      //(0018,6020)
      = const PublicTag(
          "ReferencePixelX0", 0x00186020, "Reference Pixel X0", VR.kSL, VM.k1, false);
  static const PublicTag kReferencePixelY0
      //(0018,6022)
      = const PublicTag(
          "ReferencePixelY0", 0x00186022, "Reference Pixel Y0", VR.kSL, VM.k1, false);
  static const PublicTag kPhysicalUnitsXDirection
      //(0018,6024)
      = const PublicTag("PhysicalUnitsXDirection", 0x00186024,
          "Physical Units X Direction", VR.kUS, VM.k1, false);
  static const PublicTag kPhysicalUnitsYDirection
      //(0018,6026)
      = const PublicTag("PhysicalUnitsYDirection", 0x00186026,
          "Physical Units Y Direction", VR.kUS, VM.k1, false);
  static const PublicTag kReferencePixelPhysicalValueX
      //(0018,6028)
      = const PublicTag("ReferencePixelPhysicalValueX", 0x00186028,
          "Reference Pixel Physical Value X", VR.kFD, VM.k1, false);
  static const PublicTag kReferencePixelPhysicalValueY
      //(0018,602A)
      = const PublicTag("ReferencePixelPhysicalValueY", 0x0018602A,
          "Reference Pixel Physical Value Y", VR.kFD, VM.k1, false);
  static const PublicTag kPhysicalDeltaX
      //(0018,602C)
      = const PublicTag(
          "PhysicalDeltaX", 0x0018602C, "Physical Delta X", VR.kFD, VM.k1, false);
  static const PublicTag kPhysicalDeltaY
      //(0018,602E)
      = const PublicTag(
          "PhysicalDeltaY", 0x0018602E, "Physical Delta Y", VR.kFD, VM.k1, false);
  static const PublicTag kTransducerFrequency
      //(0018,6030)
      = const PublicTag("TransducerFrequency", 0x00186030, "Transducer Frequency", VR.kUL,
          VM.k1, false);
  static const PublicTag kTransducerType
      //(0018,6031)
      = const PublicTag(
          "TransducerType", 0x00186031, "Transducer Type", VR.kCS, VM.k1, false);
  static const PublicTag kPulseRepetitionFrequency
      //(0018,6032)
      = const PublicTag("PulseRepetitionFrequency", 0x00186032,
          "Pulse Repetition Frequency", VR.kUL, VM.k1, false);
  static const PublicTag kDopplerCorrectionAngle
      //(0018,6034)
      = const PublicTag("DopplerCorrectionAngle", 0x00186034, "Doppler Correction Angle",
          VR.kFD, VM.k1, false);
  static const PublicTag kSteeringAngle
      //(0018,6036)
      = const PublicTag(
          "SteeringAngle", 0x00186036, "Steering Angle", VR.kFD, VM.k1, false);
  static const PublicTag kDopplerSampleVolumeXPositionRetired
      //(0018,6038)
      = const PublicTag("DopplerSampleVolumeXPositionRetired", 0x00186038,
          "Doppler Sample Volume X Position (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kDopplerSampleVolumeXPosition
      //(0018,6039)
      = const PublicTag("DopplerSampleVolumeXPosition", 0x00186039,
          "Doppler Sample Volume X Position", VR.kSL, VM.k1, false);
  static const PublicTag kDopplerSampleVolumeYPositionRetired
      //(0018,603A)
      = const PublicTag("DopplerSampleVolumeYPositionRetired", 0x0018603A,
          "Doppler Sample Volume Y Position (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kDopplerSampleVolumeYPosition
      //(0018,603B)
      = const PublicTag("DopplerSampleVolumeYPosition", 0x0018603B,
          "Doppler Sample Volume Y Position", VR.kSL, VM.k1, false);
  static const PublicTag kTMLinePositionX0Retired
      //(0018,603C)
      = const PublicTag("TMLinePositionX0Retired", 0x0018603C,
          "TM-Line Position X0 (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kTMLinePositionX0
      //(0018,603D)
      = const PublicTag(
          "TMLinePositionX0", 0x0018603D, "TM-Line Position X0", VR.kSL, VM.k1, false);
  static const PublicTag kTMLinePositionY0Retired
      //(0018,603E)
      = const PublicTag("TMLinePositionY0Retired", 0x0018603E,
          "TM-Line Position Y0 (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kTMLinePositionY0
      //(0018,603F)
      = const PublicTag(
          "TMLinePositionY0", 0x0018603F, "TM-Line Position Y0", VR.kSL, VM.k1, false);
  static const PublicTag kTMLinePositionX1Retired
      //(0018,6040)
      = const PublicTag("TMLinePositionX1Retired", 0x00186040,
          "TM-Line Position X1 (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kTMLinePositionX1
      //(0018,6041)
      = const PublicTag(
          "TMLinePositionX1", 0x00186041, "TM-Line Position X1", VR.kSL, VM.k1, false);
  static const PublicTag kTMLinePositionY1Retired
      //(0018,6042)
      = const PublicTag("TMLinePositionY1Retired", 0x00186042,
          "TM-Line Position Y1 (Retired)", VR.kUL, VM.k1, true);
  static const PublicTag kTMLinePositionY1
      //(0018,6043)
      = const PublicTag(
          "TMLinePositionY1", 0x00186043, "TM-Line Position Y1", VR.kSL, VM.k1, false);
  static const PublicTag kPixelComponentOrganization
      //(0018,6044)
      = const PublicTag("PixelComponentOrganization", 0x00186044,
          "Pixel Component Organization", VR.kUS, VM.k1, false);
  static const PublicTag kPixelComponentMask
      //(0018,6046)
      = const PublicTag(
          "PixelComponentMask", 0x00186046, "Pixel Component Mask", VR.kUL, VM.k1, false);
  static const PublicTag kPixelComponentRangeStart
      //(0018,6048)
      = const PublicTag("PixelComponentRangeStart", 0x00186048,
          "Pixel Component Range Start", VR.kUL, VM.k1, false);
  static const PublicTag kPixelComponentRangeStop
      //(0018,604A)
      = const PublicTag("PixelComponentRangeStop", 0x0018604A,
          "Pixel Component Range Stop", VR.kUL, VM.k1, false);
  static const PublicTag kPixelComponentPhysicalUnits
      //(0018,604C)
      = const PublicTag("PixelComponentPhysicalUnits", 0x0018604C,
          "Pixel Component Physical Units", VR.kUS, VM.k1, false);
  static const PublicTag kPixelComponentDataType
      //(0018,604E)
      = const PublicTag("PixelComponentDataType", 0x0018604E, "Pixel Component Data Type",
          VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfTableBreakPoints
      //(0018,6050)
      = const PublicTag("NumberOfTableBreakPoints", 0x00186050,
          "Number of Table Break Points", VR.kUL, VM.k1, false);
  static const PublicTag kTableOfXBreakPoints
      //(0018,6052)
      = const PublicTag("TableOfXBreakPoints", 0x00186052, "Table of X Break Points",
          VR.kUL, VM.k1_n, false);
  static const PublicTag kTableOfYBreakPoints
      //(0018,6054)
      = const PublicTag("TableOfYBreakPoints", 0x00186054, "Table of Y Break Points",
          VR.kFD, VM.k1_n, false);
  static const PublicTag kNumberOfTableEntries
      //(0018,6056)
      = const PublicTag("NumberOfTableEntries", 0x00186056, "Number of Table Entries",
          VR.kUL, VM.k1, false);
  static const PublicTag kTableOfPixelValues
      //(0018,6058)
      = const PublicTag("TableOfPixelValues", 0x00186058, "Table of Pixel Values", VR.kUL,
          VM.k1_n, false);
  static const PublicTag kTableOfParameterValues
      //(0018,605A)
      = const PublicTag("TableOfParameterValues", 0x0018605A, "Table of Parameter Values",
          VR.kFL, VM.k1_n, false);
  static const PublicTag kRWaveTimeVector
      //(0018,6060)
      = const PublicTag(
          "RWaveTimeVector", 0x00186060, "R Wave Time Vector", VR.kFL, VM.k1_n, false);
  static const PublicTag kDetectorConditionsNominalFlag
      //(0018,7000)
      = const PublicTag("DetectorConditionsNominalFlag", 0x00187000,
          "Detector Conditions Nominal Flag", VR.kCS, VM.k1, false);
  static const PublicTag kDetectorTemperature
      //(0018,7001)
      = const PublicTag("DetectorTemperature", 0x00187001, "Detector Temperature", VR.kDS,
          VM.k1, false);
  static const PublicTag kDetectorType
      //(0018,7004)
      =
      const PublicTag("DetectorType", 0x00187004, "Detector Type", VR.kCS, VM.k1, false);
  static const PublicTag kDetectorConfiguration
      //(0018,7005)
      = const PublicTag("DetectorConfiguration", 0x00187005, "Detector Configuration",
          VR.kCS, VM.k1, false);
  static const PublicTag kDetectorDescription
      //(0018,7006)
      = const PublicTag("DetectorDescription", 0x00187006, "Detector Description", VR.kLT,
          VM.k1, false);
  static const PublicTag kDetectorMode
      //(0018,7008)
      =
      const PublicTag("DetectorMode", 0x00187008, "Detector Mode", VR.kLT, VM.k1, false);
  static const PublicTag kDetectorID
      //(0018,700A)
      = const PublicTag("DetectorID", 0x0018700A, "Detector ID", VR.kSH, VM.k1, false);
  static const PublicTag kDateOfLastDetectorCalibration
      //(0018,700C)
      = const PublicTag("DateOfLastDetectorCalibration", 0x0018700C,
          "Date of Last Detector Calibration", VR.kDA, VM.k1, false);
  static const PublicTag kTimeOfLastDetectorCalibration
      //(0018,700E)
      = const PublicTag("TimeOfLastDetectorCalibration", 0x0018700E,
          "Time of Last Detector Calibration", VR.kTM, VM.k1, false);
  static const PublicTag kExposuresOnDetectorSinceLastCalibration
      //(0018,7010)
      = const PublicTag("ExposuresOnDetectorSinceLastCalibration", 0x00187010,
          "Exposures on Detector Since Last Calibration", VR.kIS, VM.k1, false);
  static const PublicTag kExposuresOnDetectorSinceManufactured
      //(0018,7011)
      = const PublicTag("ExposuresOnDetectorSinceManufactured", 0x00187011,
          "Exposures on Detector Since Manufactured", VR.kIS, VM.k1, false);
  static const PublicTag kDetectorTimeSinceLastExposure
      //(0018,7012)
      = const PublicTag("DetectorTimeSinceLastExposure", 0x00187012,
          "Detector Time Since Last Exposure", VR.kDS, VM.k1, false);
  static const PublicTag kDetectorActiveTime
      //(0018,7014)
      = const PublicTag(
          "DetectorActiveTime", 0x00187014, "Detector Active Time", VR.kDS, VM.k1, false);
  static const PublicTag kDetectorActivationOffsetFromExposure
      //(0018,7016)
      = const PublicTag("DetectorActivationOffsetFromExposure", 0x00187016,
          "Detector Activation Offset From Exposure", VR.kDS, VM.k1, false);
  static const PublicTag kDetectorBinning
      //(0018,701A)
      = const PublicTag(
          "DetectorBinning", 0x0018701A, "Detector Binning", VR.kDS, VM.k2, false);
  static const PublicTag kDetectorElementPhysicalSize
      //(0018,7020)
      = const PublicTag("DetectorElementPhysicalSize", 0x00187020,
          "Detector Element Physical Size", VR.kDS, VM.k2, false);
  static const PublicTag kDetectorElementSpacing
      //(0018,7022)
      = const PublicTag("DetectorElementSpacing", 0x00187022, "Detector Element Spacing",
          VR.kDS, VM.k2, false);
  static const PublicTag kDetectorActiveShape
      //(0018,7024)
      = const PublicTag("DetectorActiveShape", 0x00187024, "Detector Active Shape",
          VR.kCS, VM.k1, false);
  static const PublicTag kDetectorActiveDimensions
      //(0018,7026)
      = const PublicTag("DetectorActiveDimensions", 0x00187026,
          "Detector Active Dimension(s)", VR.kDS, VM.k1_2, false);
  static const PublicTag kDetectorActiveOrigin
      //(0018,7028)
      = const PublicTag("DetectorActiveOrigin", 0x00187028, "Detector Active Origin",
          VR.kDS, VM.k2, false);
  static const PublicTag kDetectorManufacturerName
      //(0018,702A)
      = const PublicTag("DetectorManufacturerName", 0x0018702A,
          "Detector Manufacturer Name", VR.kLO, VM.k1, false);
  static const PublicTag kDetectorManufacturerModelName
      //(0018,702B)
      = const PublicTag("DetectorManufacturerModelName", 0x0018702B,
          "Detector Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const PublicTag kFieldOfViewOrigin
      //(0018,7030)
      = const PublicTag(
          "FieldOfViewOrigin", 0x00187030, "Field of View Origin", VR.kDS, VM.k2, false);
  static const PublicTag kFieldOfViewRotation
      //(0018,7032)
      = const PublicTag("FieldOfViewRotation", 0x00187032, "Field of View Rotation",
          VR.kDS, VM.k1, false);
  static const PublicTag kFieldOfViewHorizontalFlip
      //(0018,7034)
      = const PublicTag("FieldOfViewHorizontalFlip", 0x00187034,
          "Field of View Horizontal Flip", VR.kCS, VM.k1, false);
  static const PublicTag kPixelDataAreaOriginRelativeToFOV
      //(0018,7036)
      = const PublicTag("PixelDataAreaOriginRelativeToFOV", 0x00187036,
          "Pixel Data Area Origin Relative To FOV", VR.kFL, VM.k2, false);
  static const PublicTag kPixelDataAreaRotationAngleRelativeToFOV
      //(0018,7038)
      = const PublicTag("PixelDataAreaRotationAngleRelativeToFOV", 0x00187038,
          "Pixel Data Area Rotation Angle Relative To FOV", VR.kFL, VM.k1, false);
  static const PublicTag kGridAbsorbingMaterial
      //(0018,7040)
      = const PublicTag("GridAbsorbingMaterial", 0x00187040, "Grid Absorbing Material",
          VR.kLT, VM.k1, false);
  static const PublicTag kGridSpacingMaterial
      //(0018,7041)
      = const PublicTag("GridSpacingMaterial", 0x00187041, "Grid Spacing Material",
          VR.kLT, VM.k1, false);
  static const PublicTag kGridThickness
      //(0018,7042)
      = const PublicTag(
          "GridThickness", 0x00187042, "Grid Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kGridPitch
      //(0018,7044)
      = const PublicTag("GridPitch", 0x00187044, "Grid Pitch", VR.kDS, VM.k1, false);
  static const PublicTag kGridAspectRatio
      //(0018,7046)
      = const PublicTag(
          "GridAspectRatio", 0x00187046, "Grid Aspect Ratio", VR.kIS, VM.k2, false);
  static const PublicTag kGridPeriod
      //(0018,7048)
      = const PublicTag("GridPeriod", 0x00187048, "Grid Period", VR.kDS, VM.k1, false);
  static const PublicTag kGridFocalDistance
      //(0018,704C)
      = const PublicTag(
          "GridFocalDistance", 0x0018704C, "Grid Focal Distance", VR.kDS, VM.k1, false);
  static const PublicTag kFilterMaterial
      //(0018,7050)
      = const PublicTag(
          "FilterMaterial", 0x00187050, "Filter Material", VR.kCS, VM.k1_n, false);
  static const PublicTag kFilterThicknessMinimum
      //(0018,7052)
      = const PublicTag("FilterThicknessMinimum", 0x00187052, "Filter Thickness Minimum",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kFilterThicknessMaximum
      //(0018,7054)
      = const PublicTag("FilterThicknessMaximum", 0x00187054, "Filter Thickness Maximum",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kFilterBeamPathLengthMinimum
      //(0018,7056)
      = const PublicTag("FilterBeamPathLengthMinimum", 0x00187056,
          "Filter Beam Path Length Minimum", VR.kFL, VM.k1_n, false);
  static const PublicTag kFilterBeamPathLengthMaximum
      //(0018,7058)
      = const PublicTag("FilterBeamPathLengthMaximum", 0x00187058,
          "Filter Beam Path Length Maximum", VR.kFL, VM.k1_n, false);
  static const PublicTag kExposureControlMode
      //(0018,7060)
      = const PublicTag("ExposureControlMode", 0x00187060, "Exposure Control Mode",
          VR.kCS, VM.k1, false);
  static const PublicTag kExposureControlModeDescription
      //(0018,7062)
      = const PublicTag("ExposureControlModeDescription", 0x00187062,
          "Exposure Control Mode Description", VR.kLT, VM.k1, false);
  static const PublicTag kExposureStatus
      //(0018,7064)
      = const PublicTag(
          "ExposureStatus", 0x00187064, "Exposure Status", VR.kCS, VM.k1, false);
  static const PublicTag kPhototimerSetting
      //(0018,7065)
      = const PublicTag(
          "PhototimerSetting", 0x00187065, "Phototimer Setting", VR.kDS, VM.k1, false);
  static const PublicTag kExposureTimeInuS
      //(0018,8150)
      = const PublicTag(
          "ExposureTimeInuS", 0x00188150, "Exposure Time in µS", VR.kDS, VM.k1, false);
  static const PublicTag kXRayTubeCurrentInuA
      //(0018,8151)
      = const PublicTag("XRayTubeCurrentInuA", 0x00188151, "X-Ray Tube Current in µA",
          VR.kDS, VM.k1, false);
  static const PublicTag kContentQualification
      //(0018,9004)
      = const PublicTag("ContentQualification", 0x00189004, "Content Qualification",
          VR.kCS, VM.k1, false);
  static const PublicTag kPulseSequenceName
      //(0018,9005)
      = const PublicTag(
          "PulseSequenceName", 0x00189005, "Pulse Sequence Name", VR.kSH, VM.k1, false);
  static const PublicTag kMRImagingModifierSequence
      //(0018,9006)
      = const PublicTag("MRImagingModifierSequence", 0x00189006,
          "MR Imaging Modifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEchoPulseSequence
      //(0018,9008)
      = const PublicTag(
          "EchoPulseSequence", 0x00189008, "Echo Pulse Sequence", VR.kCS, VM.k1, false);
  static const PublicTag kInversionRecovery
      //(0018,9009)
      = const PublicTag(
          "InversionRecovery", 0x00189009, "Inversion Recovery", VR.kCS, VM.k1, false);
  static const PublicTag kFlowCompensation
      //(0018,9010)
      = const PublicTag(
          "FlowCompensation", 0x00189010, "Flow Compensation", VR.kCS, VM.k1, false);
  static const PublicTag kMultipleSpinEcho
      //(0018,9011)
      = const PublicTag(
          "MultipleSpinEcho", 0x00189011, "Multiple Spin Echo", VR.kCS, VM.k1, false);
  static const PublicTag kMultiPlanarExcitation
      //(0018,9012)
      = const PublicTag("MultiPlanarExcitation", 0x00189012, "Multi-planar Excitation",
          VR.kCS, VM.k1, false);
  static const PublicTag kPhaseContrast
      //(0018,9014)
      = const PublicTag(
          "PhaseContrast", 0x00189014, "Phase Contrast", VR.kCS, VM.k1, false);
  static const PublicTag kTimeOfFlightContrast
      //(0018,9015)
      = const PublicTag("TimeOfFlightContrast", 0x00189015, "Time of Flight Contrast",
          VR.kCS, VM.k1, false);
  static const PublicTag kSpoiling
      //(0018,9016)
      = const PublicTag("Spoiling", 0x00189016, "Spoiling", VR.kCS, VM.k1, false);
  static const PublicTag kSteadyStatePulseSequence
      //(0018,9017)
      = const PublicTag("SteadyStatePulseSequence", 0x00189017,
          "Steady State Pulse Sequence", VR.kCS, VM.k1, false);
  static const PublicTag kEchoPlanarPulseSequence
      //(0018,9018)
      = const PublicTag("EchoPlanarPulseSequence", 0x00189018,
          "Echo Planar Pulse Sequence", VR.kCS, VM.k1, false);
  static const PublicTag kTagAngleFirstAxis
      //(0018,9019)
      = const PublicTag(
          "TagAngleFirstAxis", 0x00189019, "Tag Angle First Axis", VR.kFD, VM.k1, false);
  static const PublicTag kMagnetizationTransfer
      //(0018,9020)
      = const PublicTag("MagnetizationTransfer", 0x00189020, "Magnetization Transfer",
          VR.kCS, VM.k1, false);
  static const PublicTag kT2Preparation
      //(0018,9021)
      = const PublicTag(
          "T2Preparation", 0x00189021, "T2 Preparation", VR.kCS, VM.k1, false);
  static const PublicTag kBloodSignalNulling
      //(0018,9022)
      = const PublicTag(
          "BloodSignalNulling", 0x00189022, "Blood Signal Nulling", VR.kCS, VM.k1, false);
  static const PublicTag kSaturationRecovery
      //(0018,9024)
      = const PublicTag(
          "SaturationRecovery", 0x00189024, "Saturation Recovery", VR.kCS, VM.k1, false);
  static const PublicTag kSpectrallySelectedSuppression
      //(0018,9025)
      = const PublicTag("SpectrallySelectedSuppression", 0x00189025,
          "Spectrally Selected Suppression", VR.kCS, VM.k1, false);
  static const PublicTag kSpectrallySelectedExcitation
      //(0018,9026)
      = const PublicTag("SpectrallySelectedExcitation", 0x00189026,
          "Spectrally Selected Excitation", VR.kCS, VM.k1, false);
  static const PublicTag kSpatialPresaturation
      //(0018,9027)
      = const PublicTag("SpatialPresaturation", 0x00189027, "Spatial Pre-saturation",
          VR.kCS, VM.k1, false);
  static const PublicTag kTagging
      //(0018,9028)
      = const PublicTag("Tagging", 0x00189028, "Tagging", VR.kCS, VM.k1, false);
  static const PublicTag kOversamplingPhase
      //(0018,9029)
      = const PublicTag(
          "OversamplingPhase", 0x00189029, "Oversampling Phase", VR.kCS, VM.k1, false);
  static const PublicTag kTagSpacingFirstDimension
      //(0018,9030)
      = const PublicTag("TagSpacingFirstDimension", 0x00189030,
          "Tag Spacing First Dimension", VR.kFD, VM.k1, false);
  static const PublicTag kGeometryOfKSpaceTraversal
      //(0018,9032)
      = const PublicTag("GeometryOfKSpaceTraversal", 0x00189032,
          "Geometry of k-Space Traversal", VR.kCS, VM.k1, false);
  static const PublicTag kSegmentedKSpaceTraversal
      //(0018,9033)
      = const PublicTag("SegmentedKSpaceTraversal", 0x00189033,
          "Segmented k-Space Traversal", VR.kCS, VM.k1, false);
  static const PublicTag kRectilinearPhaseEncodeReordering
      //(0018,9034)
      = const PublicTag("RectilinearPhaseEncodeReordering", 0x00189034,
          "Rectilinear Phase Encode Reordering", VR.kCS, VM.k1, false);
  static const PublicTag kTagThickness
      //(0018,9035)
      =
      const PublicTag("TagThickness", 0x00189035, "Tag Thickness", VR.kFD, VM.k1, false);
  static const PublicTag kPartialFourierDirection
      //(0018,9036)
      = const PublicTag("PartialFourierDirection", 0x00189036,
          "Partial Fourier Direction", VR.kCS, VM.k1, false);
  static const PublicTag kCardiacSynchronizationTechnique
      //(0018,9037)
      = const PublicTag("CardiacSynchronizationTechnique", 0x00189037,
          "Cardiac Synchronization Technique", VR.kCS, VM.k1, false);
  static const PublicTag kReceiveCoilManufacturerName
      //(0018,9041)
      = const PublicTag("ReceiveCoilManufacturerName", 0x00189041,
          "Receive Coil Manufacturer Name", VR.kLO, VM.k1, false);
  static const PublicTag kMRReceiveCoilSequence
      //(0018,9042)
      = const PublicTag("MRReceiveCoilSequence", 0x00189042, "MR Receive Coil Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kReceiveCoilType
      //(0018,9043)
      = const PublicTag(
          "ReceiveCoilType", 0x00189043, "Receive Coil Type", VR.kCS, VM.k1, false);
  static const PublicTag kQuadratureReceiveCoil
      //(0018,9044)
      = const PublicTag("QuadratureReceiveCoil", 0x00189044, "Quadrature Receive Coil",
          VR.kCS, VM.k1, false);
  static const PublicTag kMultiCoilDefinitionSequence
      //(0018,9045)
      = const PublicTag("MultiCoilDefinitionSequence", 0x00189045,
          "Multi-Coil Definition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMultiCoilConfiguration
      //(0018,9046)
      = const PublicTag("MultiCoilConfiguration", 0x00189046, "Multi-Coil Configuration",
          VR.kLO, VM.k1, false);
  static const PublicTag kMultiCoilElementName
      //(0018,9047)
      = const PublicTag("MultiCoilElementName", 0x00189047, "Multi-Coil Element Name",
          VR.kSH, VM.k1, false);
  static const PublicTag kMultiCoilElementUsed
      //(0018,9048)
      = const PublicTag("MultiCoilElementUsed", 0x00189048, "Multi-Coil Element Used",
          VR.kCS, VM.k1, false);
  static const PublicTag kMRTransmitCoilSequence
      //(0018,9049)
      = const PublicTag("MRTransmitCoilSequence", 0x00189049, "MR Transmit Coil Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTransmitCoilManufacturerName
      //(0018,9050)
      = const PublicTag("TransmitCoilManufacturerName", 0x00189050,
          "Transmit Coil Manufacturer Name", VR.kLO, VM.k1, false);
  static const PublicTag kTransmitCoilType
      //(0018,9051)
      = const PublicTag(
          "TransmitCoilType", 0x00189051, "Transmit Coil Type", VR.kCS, VM.k1, false);
  static const PublicTag kSpectralWidth
      //(0018,9052)
      = const PublicTag(
          "SpectralWidth", 0x00189052, "Spectral Width", VR.kFD, VM.k1_2, false);
  static const PublicTag kChemicalShiftReference
      //(0018,9053)
      = const PublicTag("ChemicalShiftReference", 0x00189053, "Chemical Shift Reference",
          VR.kFD, VM.k1_2, false);
  static const PublicTag kVolumeLocalizationTechnique
      //(0018,9054)
      = const PublicTag("VolumeLocalizationTechnique", 0x00189054,
          "Volume Localization Technique", VR.kCS, VM.k1, false);
  static const PublicTag kMRAcquisitionFrequencyEncodingSteps
      //(0018,9058)
      = const PublicTag("MRAcquisitionFrequencyEncodingSteps", 0x00189058,
          "MR Acquisition Frequency Encoding Steps", VR.kUS, VM.k1, false);
  static const PublicTag kDecoupling
      //(0018,9059)
      = const PublicTag("Decoupling", 0x00189059, "De-coupling", VR.kCS, VM.k1, false);
  static const PublicTag kDecoupledNucleus
      //(0018,9060)
      = const PublicTag(
          "DecoupledNucleus", 0x00189060, "De-coupled Nucleus", VR.kCS, VM.k1_2, false);
  static const PublicTag kDecouplingFrequency
      //(0018,9061)
      = const PublicTag("DecouplingFrequency", 0x00189061, "De-coupling Frequency",
          VR.kFD, VM.k1_2, false);
  static const PublicTag kDecouplingMethod
      //(0018,9062)
      = const PublicTag(
          "DecouplingMethod", 0x00189062, "De-coupling Method", VR.kCS, VM.k1, false);
  static const PublicTag kDecouplingChemicalShiftReference
      //(0018,9063)
      = const PublicTag("DecouplingChemicalShiftReference", 0x00189063,
          "De-coupling Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const PublicTag kKSpaceFiltering
      //(0018,9064)
      = const PublicTag(
          "KSpaceFiltering", 0x00189064, "k-space Filtering", VR.kCS, VM.k1, false);
  static const PublicTag kTimeDomainFiltering
      //(0018,9065)
      = const PublicTag("TimeDomainFiltering", 0x00189065, "Time Domain Filtering",
          VR.kCS, VM.k1_2, false);
  static const PublicTag kNumberOfZeroFills
      //(0018,9066)
      = const PublicTag("NumberOfZeroFills", 0x00189066, "Number of Zero Fills", VR.kUS,
          VM.k1_2, false);
  static const PublicTag kBaselineCorrection
      //(0018,9067)
      = const PublicTag(
          "BaselineCorrection", 0x00189067, "Baseline Correction", VR.kCS, VM.k1, false);
  static const PublicTag kParallelReductionFactorInPlane
      //(0018,9069)
      = const PublicTag("ParallelReductionFactorInPlane", 0x00189069,
          "Parallel Reduction Factor In-plane", VR.kFD, VM.k1, false);
  static const PublicTag kCardiacRRIntervalSpecified
      //(0018,9070)
      = const PublicTag("CardiacRRIntervalSpecified", 0x00189070,
          "Cardiac R-R Interval Specified", VR.kFD, VM.k1, false);
  static const PublicTag kAcquisitionDuration
      //(0018,9073)
      = const PublicTag("AcquisitionDuration", 0x00189073, "Acquisition Duration", VR.kFD,
          VM.k1, false);
  static const PublicTag kFrameAcquisitionDateTime
      //(0018,9074)
      = const PublicTag("FrameAcquisitionDateTime", 0x00189074,
          "Frame Acquisition DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kDiffusionDirectionality
      //(0018,9075)
      = const PublicTag("DiffusionDirectionality", 0x00189075, "Diffusion Directionality",
          VR.kCS, VM.k1, false);
  static const PublicTag kDiffusionGradientDirectionSequence
      //(0018,9076)
      = const PublicTag("DiffusionGradientDirectionSequence", 0x00189076,
          "Diffusion Gradient Direction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kParallelAcquisition
      //(0018,9077)
      = const PublicTag("ParallelAcquisition", 0x00189077, "Parallel Acquisition", VR.kCS,
          VM.k1, false);
  static const PublicTag kParallelAcquisitionTechnique
      //(0018,9078)
      = const PublicTag("ParallelAcquisitionTechnique", 0x00189078,
          "Parallel Acquisition Technique", VR.kCS, VM.k1, false);
  static const PublicTag kInversionTimes
      //(0018,9079)
      = const PublicTag(
          "InversionTimes", 0x00189079, "Inversion Times", VR.kFD, VM.k1_n, false);
  static const PublicTag kMetaboliteMapDescription
      //(0018,9080)
      = const PublicTag("MetaboliteMapDescription", 0x00189080,
          "Metabolite Map Description", VR.kST, VM.k1, false);
  static const PublicTag kPartialFourier
      //(0018,9081)
      = const PublicTag(
          "PartialFourier", 0x00189081, "Partial Fourier", VR.kCS, VM.k1, false);
  static const PublicTag kEffectiveEchoTime
      //(0018,9082)
      = const PublicTag(
          "EffectiveEchoTime", 0x00189082, "Effective Echo Time", VR.kFD, VM.k1, false);
  static const PublicTag kMetaboliteMapCodeSequence
      //(0018,9083)
      = const PublicTag("MetaboliteMapCodeSequence", 0x00189083,
          "Metabolite Map Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChemicalShiftSequence
      //(0018,9084)
      = const PublicTag("ChemicalShiftSequence", 0x00189084, "Chemical Shift Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCardiacSignalSource
      //(0018,9085)
      = const PublicTag("CardiacSignalSource", 0x00189085, "Cardiac Signal Source",
          VR.kCS, VM.k1, false);
  static const PublicTag kDiffusionBValue
      //(0018,9087)
      = const PublicTag(
          "DiffusionBValue", 0x00189087, "Diffusion b-value", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionGradientOrientation
      //(0018,9089)
      = const PublicTag("DiffusionGradientOrientation", 0x00189089,
          "Diffusion Gradient Orientation", VR.kFD, VM.k3, false);
  static const PublicTag kVelocityEncodingDirection
      //(0018,9090)
      = const PublicTag("VelocityEncodingDirection", 0x00189090,
          "Velocity Encoding Direction", VR.kFD, VM.k3, false);
  static const PublicTag kVelocityEncodingMinimumValue
      //(0018,9091)
      = const PublicTag("VelocityEncodingMinimumValue", 0x00189091,
          "Velocity Encoding Minimum Value", VR.kFD, VM.k1, false);
  static const PublicTag kVelocityEncodingAcquisitionSequence
      //(0018,9092)
      = const PublicTag("VelocityEncodingAcquisitionSequence", 0x00189092,
          "Velocity Encoding Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfKSpaceTrajectories
      //(0018,9093)
      = const PublicTag("NumberOfKSpaceTrajectories", 0x00189093,
          "Number of k-Space Trajectories", VR.kUS, VM.k1, false);
  static const PublicTag kCoverageOfKSpace
      //(0018,9094)
      = const PublicTag(
          "CoverageOfKSpace", 0x00189094, "Coverage of k-Space", VR.kCS, VM.k1, false);
  static const PublicTag kSpectroscopyAcquisitionPhaseRows
      //(0018,9095)
      = const PublicTag("SpectroscopyAcquisitionPhaseRows", 0x00189095,
          "Spectroscopy Acquisition Phase Rows", VR.kUL, VM.k1, false);
  static const PublicTag kParallelReductionFactorInPlaneRetired
      //(0018,9096)
      = const PublicTag("ParallelReductionFactorInPlaneRetired", 0x00189096,
          "Parallel Reduction Factor In-plane (Retired)", VR.kFD, VM.k1, true);
  static const PublicTag kTransmitterFrequency
      //(0018,9098)
      = const PublicTag("TransmitterFrequency", 0x00189098, "Transmitter Frequency",
          VR.kFD, VM.k1_2, false);
  static const PublicTag kResonantNucleus
      //(0018,9100)
      = const PublicTag(
          "ResonantNucleus", 0x00189100, "Resonant Nucleus", VR.kCS, VM.k1_2, false);
  static const PublicTag kFrequencyCorrection
      //(0018,9101)
      = const PublicTag("FrequencyCorrection", 0x00189101, "Frequency Correction", VR.kCS,
          VM.k1, false);
  static const PublicTag kMRSpectroscopyFOVGeometrySequence
      //(0018,9103)
      = const PublicTag("MRSpectroscopyFOVGeometrySequence", 0x00189103,
          "MR Spectroscopy FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSlabThickness
      //(0018,9104)
      = const PublicTag(
          "SlabThickness", 0x00189104, "Slab Thickness", VR.kFD, VM.k1, false);
  static const PublicTag kSlabOrientation
      //(0018,9105)
      = const PublicTag(
          "SlabOrientation", 0x00189105, "Slab Orientation", VR.kFD, VM.k3, false);
  static const PublicTag kMidSlabPosition
      //(0018,9106)
      = const PublicTag(
          "MidSlabPosition", 0x00189106, "Mid Slab Position", VR.kFD, VM.k3, false);
  static const PublicTag kMRSpatialSaturationSequence
      //(0018,9107)
      = const PublicTag("MRSpatialSaturationSequence", 0x00189107,
          "MR Spatial Saturation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRTimingAndRelatedParametersSequence
      //(0018,9112)
      = const PublicTag("MRTimingAndRelatedParametersSequence", 0x00189112,
          "MR Timing and Related Parameters Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMREchoSequence
      //(0018,9114)
      = const PublicTag(
          "MREchoSequence", 0x00189114, "MR Echo Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRModifierSequence
      //(0018,9115)
      = const PublicTag(
          "MRModifierSequence", 0x00189115, "MR Modifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRDiffusionSequence
      //(0018,9117)
      = const PublicTag("MRDiffusionSequence", 0x00189117, "MR Diffusion Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCardiacSynchronizationSequence
      //(0018,9118)
      = const PublicTag("CardiacSynchronizationSequence", 0x00189118,
          "Cardiac Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRAveragesSequence
      //(0018,9119)
      = const PublicTag(
          "MRAveragesSequence", 0x00189119, "MR Averages Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRFOVGeometrySequence
      //(0018,9125)
      = const PublicTag("MRFOVGeometrySequence", 0x00189125, "MR FOV/Geometry Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kVolumeLocalizationSequence
      //(0018,9126)
      = const PublicTag("VolumeLocalizationSequence", 0x00189126,
          "Volume Localization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpectroscopyAcquisitionDataColumns
      //(0018,9127)
      = const PublicTag("SpectroscopyAcquisitionDataColumns", 0x00189127,
          "Spectroscopy Acquisition Data Columns", VR.kUL, VM.k1, false);
  static const PublicTag kDiffusionAnisotropyType
      //(0018,9147)
      = const PublicTag("DiffusionAnisotropyType", 0x00189147,
          "Diffusion Anisotropy Type", VR.kCS, VM.k1, false);
  static const PublicTag kFrameReferenceDateTime
      //(0018,9151)
      = const PublicTag("FrameReferenceDateTime", 0x00189151, "Frame Reference DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kMRMetaboliteMapSequence
      //(0018,9152)
      = const PublicTag("MRMetaboliteMapSequence", 0x00189152,
          "MR Metabolite Map Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kParallelReductionFactorOutOfPlane
      //(0018,9155)
      = const PublicTag("ParallelReductionFactorOutOfPlane", 0x00189155,
          "Parallel Reduction Factor out-of-plane", VR.kFD, VM.k1, false);
  static const PublicTag kSpectroscopyAcquisitionOutOfPlanePhaseSteps
      //(0018,9159)
      = const PublicTag("SpectroscopyAcquisitionOutOfPlanePhaseSteps", 0x00189159,
          "Spectroscopy Acquisition Out-of-plane Phase Steps", VR.kUL, VM.k1, false);
  static const PublicTag kBulkMotionStatus
      //(0018,9166)
      = const PublicTag(
          "BulkMotionStatus", 0x00189166, "Bulk Motion Status", VR.kCS, VM.k1, true);
  static const PublicTag kParallelReductionFactorSecondInPlane
      //(0018,9168)
      = const PublicTag("ParallelReductionFactorSecondInPlane", 0x00189168,
          "Parallel Reduction Factor Second In-plane", VR.kFD, VM.k1, false);
  static const PublicTag kCardiacBeatRejectionTechnique
      //(0018,9169)
      = const PublicTag("CardiacBeatRejectionTechnique", 0x00189169,
          "Cardiac Beat Rejection Technique", VR.kCS, VM.k1, false);
  static const PublicTag kRespiratoryMotionCompensationTechnique
      //(0018,9170)
      = const PublicTag("RespiratoryMotionCompensationTechnique", 0x00189170,
          "Respiratory Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const PublicTag kRespiratorySignalSource
      //(0018,9171)
      = const PublicTag("RespiratorySignalSource", 0x00189171,
          "Respiratory Signal Source", VR.kCS, VM.k1, false);
  static const PublicTag kBulkMotionCompensationTechnique
      //(0018,9172)
      = const PublicTag("BulkMotionCompensationTechnique", 0x00189172,
          "Bulk Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const PublicTag kBulkMotionSignalSource
      //(0018,9173)
      = const PublicTag("BulkMotionSignalSource", 0x00189173, "Bulk Motion Signal Source",
          VR.kCS, VM.k1, false);
  static const PublicTag kApplicableSafetyStandardAgency
      //(0018,9174)
      = const PublicTag("ApplicableSafetyStandardAgency", 0x00189174,
          "Applicable Safety Standard Agency", VR.kCS, VM.k1, false);
  static const PublicTag kApplicableSafetyStandardDescription
      //(0018,9175)
      = const PublicTag("ApplicableSafetyStandardDescription", 0x00189175,
          "Applicable Safety Standard Description", VR.kLO, VM.k1, false);
  static const PublicTag kOperatingModeSequence
      //(0018,9176)
      = const PublicTag("OperatingModeSequence", 0x00189176, "Operating Mode Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kOperatingModeType
      //(0018,9177)
      = const PublicTag(
          "OperatingModeType", 0x00189177, "Operating Mode Type", VR.kCS, VM.k1, false);
  static const PublicTag kOperatingMode
      //(0018,9178)
      = const PublicTag(
          "OperatingMode", 0x00189178, "Operating Mode", VR.kCS, VM.k1, false);
  static const PublicTag kSpecificAbsorptionRateDefinition
      //(0018,9179)
      = const PublicTag("SpecificAbsorptionRateDefinition", 0x00189179,
          "Specific Absorption Rate Definition", VR.kCS, VM.k1, false);
  static const PublicTag kGradientOutputType
      //(0018,9180)
      = const PublicTag(
          "GradientOutputType", 0x00189180, "Gradient Output Type", VR.kCS, VM.k1, false);
  static const PublicTag kSpecificAbsorptionRateValue
      //(0018,9181)
      = const PublicTag("SpecificAbsorptionRateValue", 0x00189181,
          "Specific Absorption Rate Value", VR.kFD, VM.k1, false);
  static const PublicTag kGradientOutput
      //(0018,9182)
      = const PublicTag(
          "GradientOutput", 0x00189182, "Gradient Output", VR.kFD, VM.k1, false);
  static const PublicTag kFlowCompensationDirection
      //(0018,9183)
      = const PublicTag("FlowCompensationDirection", 0x00189183,
          "Flow Compensation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kTaggingDelay
      //(0018,9184)
      =
      const PublicTag("TaggingDelay", 0x00189184, "Tagging Delay", VR.kFD, VM.k1, false);
  static const PublicTag kRespiratoryMotionCompensationTechniqueDescription
      //(0018,9185)
      = const PublicTag("RespiratoryMotionCompensationTechniqueDescription", 0x00189185,
          "Respiratory Motion Compensation Technique Description", VR.kST, VM.k1, false);
  static const PublicTag kRespiratorySignalSourceID
      //(0018,9186)
      = const PublicTag("RespiratorySignalSourceID", 0x00189186,
          "Respiratory Signal Source ID", VR.kSH, VM.k1, false);
  static const PublicTag kChemicalShiftMinimumIntegrationLimitInHz
      //(0018,9195)
      = const PublicTag("ChemicalShiftMinimumIntegrationLimitInHz", 0x00189195,
          "Chemical Shift Minimum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const PublicTag kChemicalShiftMaximumIntegrationLimitInHz
      //(0018,9196)
      = const PublicTag("ChemicalShiftMaximumIntegrationLimitInHz", 0x00189196,
          "Chemical Shift Maximum Integration Limit in Hz", VR.kFD, VM.k1, true);
  static const PublicTag kMRVelocityEncodingSequence
      //(0018,9197)
      = const PublicTag("MRVelocityEncodingSequence", 0x00189197,
          "MR Velocity Encoding Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFirstOrderPhaseCorrection
      //(0018,9198)
      = const PublicTag("FirstOrderPhaseCorrection", 0x00189198,
          "First Order Phase Correction", VR.kCS, VM.k1, false);
  static const PublicTag kWaterReferencedPhaseCorrection
      //(0018,9199)
      = const PublicTag("WaterReferencedPhaseCorrection", 0x00189199,
          "Water Referenced Phase Correction", VR.kCS, VM.k1, false);
  static const PublicTag kMRSpectroscopyAcquisitionType
      //(0018,9200)
      = const PublicTag("MRSpectroscopyAcquisitionType", 0x00189200,
          "MR Spectroscopy Acquisition Type", VR.kCS, VM.k1, false);
  static const PublicTag kRespiratoryCyclePosition
      //(0018,9214)
      = const PublicTag("RespiratoryCyclePosition", 0x00189214,
          "Respiratory Cycle Position", VR.kCS, VM.k1, false);
  static const PublicTag kVelocityEncodingMaximumValue
      //(0018,9217)
      = const PublicTag("VelocityEncodingMaximumValue", 0x00189217,
          "Velocity Encoding Maximum Value", VR.kFD, VM.k1, false);
  static const PublicTag kTagSpacingSecondDimension
      //(0018,9218)
      = const PublicTag("TagSpacingSecondDimension", 0x00189218,
          "Tag Spacing Second Dimension", VR.kFD, VM.k1, false);
  static const PublicTag kTagAngleSecondAxis
      //(0018,9219)
      = const PublicTag("TagAngleSecondAxis", 0x00189219, "Tag Angle Second Axis", VR.kSS,
          VM.k1, false);
  static const PublicTag kFrameAcquisitionDuration
      //(0018,9220)
      = const PublicTag("FrameAcquisitionDuration", 0x00189220,
          "Frame Acquisition Duration", VR.kFD, VM.k1, false);
  static const PublicTag kMRImageFrameTypeSequence
      //(0018,9226)
      = const PublicTag("MRImageFrameTypeSequence", 0x00189226,
          "MR Image Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRSpectroscopyFrameTypeSequence
      //(0018,9227)
      = const PublicTag("MRSpectroscopyFrameTypeSequence", 0x00189227,
          "MR Spectroscopy Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMRAcquisitionPhaseEncodingStepsInPlane
      //(0018,9231)
      = const PublicTag("MRAcquisitionPhaseEncodingStepsInPlane", 0x00189231,
          "MR Acquisition Phase Encoding Steps in-plane", VR.kUS, VM.k1, false);
  static const PublicTag kMRAcquisitionPhaseEncodingStepsOutOfPlane
      //(0018,9232)
      = const PublicTag("MRAcquisitionPhaseEncodingStepsOutOfPlane", 0x00189232,
          "MR Acquisition Phase Encoding Steps out-of-plane", VR.kUS, VM.k1, false);
  static const PublicTag kSpectroscopyAcquisitionPhaseColumns
      //(0018,9234)
      = const PublicTag("SpectroscopyAcquisitionPhaseColumns", 0x00189234,
          "Spectroscopy Acquisition Phase Columns", VR.kUL, VM.k1, false);
  static const PublicTag kCardiacCyclePosition
      //(0018,9236)
      = const PublicTag("CardiacCyclePosition", 0x00189236, "Cardiac Cycle Position",
          VR.kCS, VM.k1, false);
  static const PublicTag kSpecificAbsorptionRateSequence
      //(0018,9239)
      = const PublicTag("SpecificAbsorptionRateSequence", 0x00189239,
          "Specific Absorption Rate Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRFEchoTrainLength
      //(0018,9240)
      = const PublicTag(
          "RFEchoTrainLength", 0x00189240, "RF Echo Train Length", VR.kUS, VM.k1, false);
  static const PublicTag kGradientEchoTrainLength
      //(0018,9241)
      = const PublicTag("GradientEchoTrainLength", 0x00189241,
          "Gradient Echo Train Length", VR.kUS, VM.k1, false);
  static const PublicTag kArterialSpinLabelingContrast
      //(0018,9250)
      = const PublicTag("ArterialSpinLabelingContrast", 0x00189250,
          "Arterial Spin Labeling Contrast", VR.kCS, VM.k1, false);
  static const PublicTag kMRArterialSpinLabelingSequence
      //(0018,9251)
      = const PublicTag("MRArterialSpinLabelingSequence", 0x00189251,
          "MR Arterial Spin Labeling Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kASLTechniqueDescription
      //(0018,9252)
      = const PublicTag("ASLTechniqueDescription", 0x00189252,
          "ASL Technique Description", VR.kLO, VM.k1, false);
  static const PublicTag kASLSlabNumber
      //(0018,9253)
      = const PublicTag(
          "ASLSlabNumber", 0x00189253, "ASL Slab Number", VR.kUS, VM.k1, false);
  static const PublicTag kASLSlabThickness
      //(0018,9254)
      = const PublicTag(
          "ASLSlabThickness", 0x00189254, "ASL Slab Thickness", VR.kFD, VM.k1, false);
  static const PublicTag kASLSlabOrientation
      //(0018,9255)
      = const PublicTag(
          "ASLSlabOrientation", 0x00189255, "ASL Slab Orientation", VR.kFD, VM.k3, false);
  static const PublicTag kASLMidSlabPosition
      //(0018,9256)
      = const PublicTag("ASLMidSlabPosition", 0x00189256, "ASL Mid Slab Position", VR.kFD,
          VM.k3, false);
  static const PublicTag kASLContext
      //(0018,9257)
      = const PublicTag("ASLContext", 0x00189257, "ASL Context", VR.kCS, VM.k1, false);
  static const PublicTag kASLPulseTrainDuration
      //(0018,9258)
      = const PublicTag("ASLPulseTrainDuration", 0x00189258, "ASL Pulse Train Duration",
          VR.kUL, VM.k1, false);
  static const PublicTag kASLCrusherFlag
      //(0018,9259)
      = const PublicTag(
          "ASLCrusherFlag", 0x00189259, "ASL Crusher Flag", VR.kCS, VM.k1, false);
  static const PublicTag kASLCrusherFlowLimit
      //(0018,925A)
      = const PublicTag("ASLCrusherFlowLimit", 0x0018925A, "ASL Crusher Flow Limit",
          VR.kFD, VM.k1, false);
  static const PublicTag kASLCrusherDescription
      //(0018,925B)
      = const PublicTag("ASLCrusherDescription", 0x0018925B, "ASL Crusher Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kASLBolusCutoffFlag
      //(0018,925C)
      = const PublicTag("ASLBolusCutoffFlag", 0x0018925C, "ASL Bolus Cut-off Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kASLBolusCutoffTimingSequence
      //(0018,925D)
      = const PublicTag("ASLBolusCutoffTimingSequence", 0x0018925D,
          "ASL Bolus Cut-off Timing Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kASLBolusCutoffTechnique
      //(0018,925E)
      = const PublicTag("ASLBolusCutoffTechnique", 0x0018925E,
          "ASL Bolus Cut-off Technique", VR.kLO, VM.k1, false);
  static const PublicTag kASLBolusCutoffDelayTime
      //(0018,925F)
      = const PublicTag("ASLBolusCutoffDelayTime", 0x0018925F,
          "ASL Bolus Cut-off Delay Time", VR.kUL, VM.k1, false);
  static const PublicTag kASLSlabSequence
      //(0018,9260)
      = const PublicTag(
          "ASLSlabSequence", 0x00189260, "ASL Slab Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChemicalShiftMinimumIntegrationLimitInppm
      //(0018,9295)
      = const PublicTag("ChemicalShiftMinimumIntegrationLimitInppm", 0x00189295,
          "Chemical Shift Minimum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const PublicTag kChemicalShiftMaximumIntegrationLimitInppm
      //(0018,9296)
      = const PublicTag("ChemicalShiftMaximumIntegrationLimitInppm", 0x00189296,
          "Chemical Shift Maximum Integration Limit in ppm", VR.kFD, VM.k1, false);
  static const PublicTag kCTAcquisitionTypeSequence
      //(0018,9301)
      = const PublicTag("CTAcquisitionTypeSequence", 0x00189301,
          "CT Acquisition Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcquisitionType
      //(0018,9302)
      = const PublicTag(
          "AcquisitionType", 0x00189302, "Acquisition Type", VR.kCS, VM.k1, false);
  static const PublicTag kTubeAngle
      //(0018,9303)
      = const PublicTag("TubeAngle", 0x00189303, "Tube Angle", VR.kFD, VM.k1, false);
  static const PublicTag kCTAcquisitionDetailsSequence
      //(0018,9304)
      = const PublicTag("CTAcquisitionDetailsSequence", 0x00189304,
          "CT Acquisition Details Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRevolutionTime
      //(0018,9305)
      = const PublicTag(
          "RevolutionTime", 0x00189305, "Revolution Time", VR.kFD, VM.k1, false);
  static const PublicTag kSingleCollimationWidth
      //(0018,9306)
      = const PublicTag("SingleCollimationWidth", 0x00189306, "Single Collimation Width",
          VR.kFD, VM.k1, false);
  static const PublicTag kTotalCollimationWidth
      //(0018,9307)
      = const PublicTag("TotalCollimationWidth", 0x00189307, "Total Collimation Width",
          VR.kFD, VM.k1, false);
  static const PublicTag kCTTableDynamicsSequence
      //(0018,9308)
      = const PublicTag("CTTableDynamicsSequence", 0x00189308,
          "CT Table Dynamics Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTableSpeed
      //(0018,9309)
      = const PublicTag("TableSpeed", 0x00189309, "Table Speed", VR.kFD, VM.k1, false);
  static const PublicTag kTableFeedPerRotation
      //(0018,9310)
      = const PublicTag("TableFeedPerRotation", 0x00189310, "Table Feed per Rotation",
          VR.kFD, VM.k1, false);
  static const PublicTag kSpiralPitchFactor
      //(0018,9311)
      = const PublicTag(
          "SpiralPitchFactor", 0x00189311, "Spiral Pitch Factor", VR.kFD, VM.k1, false);
  static const PublicTag kCTGeometrySequence
      //(0018,9312)
      = const PublicTag(
          "CTGeometrySequence", 0x00189312, "CT Geometry Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDataCollectionCenterPatient
      //(0018,9313)
      = const PublicTag("DataCollectionCenterPatient", 0x00189313,
          "Data Collection Center (Patient)", VR.kFD, VM.k3, false);
  static const PublicTag kCTReconstructionSequence
      //(0018,9314)
      = const PublicTag("CTReconstructionSequence", 0x00189314,
          "CT Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReconstructionAlgorithm
      //(0018,9315)
      = const PublicTag("ReconstructionAlgorithm", 0x00189315, "Reconstruction Algorithm",
          VR.kCS, VM.k1, false);
  static const PublicTag kConvolutionKernelGroup
      //(0018,9316)
      = const PublicTag("ConvolutionKernelGroup", 0x00189316, "Convolution Kernel Group",
          VR.kCS, VM.k1, false);
  static const PublicTag kReconstructionFieldOfView
      //(0018,9317)
      = const PublicTag("ReconstructionFieldOfView", 0x00189317,
          "Reconstruction Field of View", VR.kFD, VM.k2, false);
  static const PublicTag kReconstructionTargetCenterPatient
      //(0018,9318)
      = const PublicTag("ReconstructionTargetCenterPatient", 0x00189318,
          "Reconstruction Target Center (Patient)", VR.kFD, VM.k3, false);
  static const PublicTag kReconstructionAngle
      //(0018,9319)
      = const PublicTag("ReconstructionAngle", 0x00189319, "Reconstruction Angle", VR.kFD,
          VM.k1, false);
  static const PublicTag kImageFilter
      //(0018,9320)
      = const PublicTag("ImageFilter", 0x00189320, "Image Filter", VR.kSH, VM.k1, false);
  static const PublicTag kCTExposureSequence
      //(0018,9321)
      = const PublicTag(
          "CTExposureSequence", 0x00189321, "CT Exposure Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReconstructionPixelSpacing
      //(0018,9322)
      = const PublicTag("ReconstructionPixelSpacing", 0x00189322,
          "Reconstruction Pixel Spacing", VR.kFD, VM.k2, false);
  static const PublicTag kExposureModulationType
      //(0018,9323)
      = const PublicTag("ExposureModulationType", 0x00189323, "Exposure Modulation Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kEstimatedDoseSaving
      //(0018,9324)
      = const PublicTag("EstimatedDoseSaving", 0x00189324, "Estimated Dose Saving",
          VR.kFD, VM.k1, false);
  static const PublicTag kCTXRayDetailsSequence
      //(0018,9325)
      = const PublicTag("CTXRayDetailsSequence", 0x00189325, "CT X-Ray Details Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCTPositionSequence
      //(0018,9326)
      = const PublicTag(
          "CTPositionSequence", 0x00189326, "CT Position Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTablePosition
      //(0018,9327)
      = const PublicTag(
          "TablePosition", 0x00189327, "Table Position", VR.kFD, VM.k1, false);
  static const PublicTag kExposureTimeInms
      //(0018,9328)
      = const PublicTag(
          "ExposureTimeInms", 0x00189328, "Exposure Time in ms", VR.kFD, VM.k1, false);
  static const PublicTag kCTImageFrameTypeSequence
      //(0018,9329)
      = const PublicTag("CTImageFrameTypeSequence", 0x00189329,
          "CT Image Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kXRayTubeCurrentInmA
      //(0018,9330)
      = const PublicTag("XRayTubeCurrentInmA", 0x00189330, "X-Ray Tube Current in mA",
          VR.kFD, VM.k1, false);
  static const PublicTag kExposureInmAs
      //(0018,9332)
      = const PublicTag(
          "ExposureInmAs", 0x00189332, "Exposure in mAs", VR.kFD, VM.k1, false);
  static const PublicTag kConstantVolumeFlag
      //(0018,9333)
      = const PublicTag(
          "ConstantVolumeFlag", 0x00189333, "Constant Volume Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFluoroscopyFlag
      //(0018,9334)
      = const PublicTag(
          "FluoroscopyFlag", 0x00189334, "Fluoroscopy Flag", VR.kCS, VM.k1, false);
  static const PublicTag kDistanceSourceToDataCollectionCenter
      //(0018,9335)
      = const PublicTag("DistanceSourceToDataCollectionCenter", 0x00189335,
          "Distance Source to Data Collection Center", VR.kFD, VM.k1, false);
  static const PublicTag kContrastBolusAgentNumber
      //(0018,9337)
      = const PublicTag("ContrastBolusAgentNumber", 0x00189337,
          "Contrast/Bolus Agent Number", VR.kUS, VM.k1, false);
  static const PublicTag kContrastBolusIngredientCodeSequence
      //(0018,9338)
      = const PublicTag("ContrastBolusIngredientCodeSequence", 0x00189338,
          "Contrast/Bolus Ingredient Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContrastAdministrationProfileSequence
      //(0018,9340)
      = const PublicTag("ContrastAdministrationProfileSequence", 0x00189340,
          "Contrast Administration Profile Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContrastBolusUsageSequence
      //(0018,9341)
      = const PublicTag("ContrastBolusUsageSequence", 0x00189341,
          "Contrast/Bolus Usage Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContrastBolusAgentAdministered
      //(0018,9342)
      = const PublicTag("ContrastBolusAgentAdministered", 0x00189342,
          "Contrast/Bolus Agent Administered", VR.kCS, VM.k1, false);
  static const PublicTag kContrastBolusAgentDetected
      //(0018,9343)
      = const PublicTag("ContrastBolusAgentDetected", 0x00189343,
          "Contrast/Bolus Agent Detected", VR.kCS, VM.k1, false);
  static const PublicTag kContrastBolusAgentPhase
      //(0018,9344)
      = const PublicTag("ContrastBolusAgentPhase", 0x00189344,
          "Contrast/Bolus Agent Phase", VR.kCS, VM.k1, false);
  static const PublicTag kCTDIvol
      //(0018,9345)
      = const PublicTag("CTDIvol", 0x00189345, "CTDIvol", VR.kFD, VM.k1, false);
  static const PublicTag kCTDIPhantomTypeCodeSequence
      //(0018,9346)
      = const PublicTag("CTDIPhantomTypeCodeSequence", 0x00189346,
          "CTDI Phantom Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCalciumScoringMassFactorPatient
      //(0018,9351)
      = const PublicTag("CalciumScoringMassFactorPatient", 0x00189351,
          "Calcium Scoring Mass Factor Patient", VR.kFL, VM.k1, false);
  static const PublicTag kCalciumScoringMassFactorDevice
      //(0018,9352)
      = const PublicTag("CalciumScoringMassFactorDevice", 0x00189352,
          "Calcium Scoring Mass Factor Device", VR.kFL, VM.k3, false);
  static const PublicTag kEnergyWeightingFactor
      //(0018,9353)
      = const PublicTag("EnergyWeightingFactor", 0x00189353, "Energy Weighting Factor",
          VR.kFL, VM.k1, false);
  static const PublicTag kCTAdditionalXRaySourceSequence
      //(0018,9360)
      = const PublicTag("CTAdditionalXRaySourceSequence", 0x00189360,
          "CT Additional X-Ray Source Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kProjectionPixelCalibrationSequence
      //(0018,9401)
      = const PublicTag("ProjectionPixelCalibrationSequence", 0x00189401,
          "Projection Pixel Calibration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDistanceSourceToIsocenter
      //(0018,9402)
      = const PublicTag("DistanceSourceToIsocenter", 0x00189402,
          "Distance Source to Isocenter", VR.kFL, VM.k1, false);
  static const PublicTag kDistanceObjectToTableTop
      //(0018,9403)
      = const PublicTag("DistanceObjectToTableTop", 0x00189403,
          "Distance Object to Table Top", VR.kFL, VM.k1, false);
  static const PublicTag kObjectPixelSpacingInCenterOfBeam
      //(0018,9404)
      = const PublicTag("ObjectPixelSpacingInCenterOfBeam", 0x00189404,
          "Object Pixel Spacing in Center of Beam", VR.kFL, VM.k2, false);
  static const PublicTag kPositionerPositionSequence
      //(0018,9405)
      = const PublicTag("PositionerPositionSequence", 0x00189405,
          "Positioner Position Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTablePositionSequence
      //(0018,9406)
      = const PublicTag("TablePositionSequence", 0x00189406, "Table Position Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCollimatorShapeSequence
      //(0018,9407)
      = const PublicTag("CollimatorShapeSequence", 0x00189407,
          "Collimator Shape Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlanesInAcquisition
      //(0018,9410)
      = const PublicTag("PlanesInAcquisition", 0x00189410, "Planes in Acquisition",
          VR.kCS, VM.k1, false);
  static const PublicTag kXAXRFFrameCharacteristicsSequence
      //(0018,9412)
      = const PublicTag("XAXRFFrameCharacteristicsSequence", 0x00189412,
          "XA/XRF Frame Characteristics Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFrameAcquisitionSequence
      //(0018,9417)
      = const PublicTag("FrameAcquisitionSequence", 0x00189417,
          "Frame Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kXRayReceptorType
      //(0018,9420)
      = const PublicTag(
          "XRayReceptorType", 0x00189420, "X-Ray Receptor Type", VR.kCS, VM.k1, false);
  static const PublicTag kAcquisitionProtocolName
      //(0018,9423)
      = const PublicTag("AcquisitionProtocolName", 0x00189423,
          "Acquisition Protocol Name", VR.kLO, VM.k1, false);
  static const PublicTag kAcquisitionProtocolDescription
      //(0018,9424)
      = const PublicTag("AcquisitionProtocolDescription", 0x00189424,
          "Acquisition Protocol Description", VR.kLT, VM.k1, false);
  static const PublicTag kContrastBolusIngredientOpaque
      //(0018,9425)
      = const PublicTag("ContrastBolusIngredientOpaque", 0x00189425,
          "Contrast/Bolus Ingredient Opaque", VR.kCS, VM.k1, false);
  static const PublicTag kDistanceReceptorPlaneToDetectorHousing
      //(0018,9426)
      = const PublicTag("DistanceReceptorPlaneToDetectorHousing", 0x00189426,
          "Distance Receptor Plane to Detector Housing", VR.kFL, VM.k1, false);
  static const PublicTag kIntensifierActiveShape
      //(0018,9427)
      = const PublicTag("IntensifierActiveShape", 0x00189427, "Intensifier Active Shape",
          VR.kCS, VM.k1, false);
  static const PublicTag kIntensifierActiveDimensions
      //(0018,9428)
      = const PublicTag("IntensifierActiveDimensions", 0x00189428,
          "Intensifier Active Dimension(s)", VR.kFL, VM.k1_2, false);
  static const PublicTag kPhysicalDetectorSize
      //(0018,9429)
      = const PublicTag("PhysicalDetectorSize", 0x00189429, "Physical Detector Size",
          VR.kFL, VM.k2, false);
  static const PublicTag kPositionOfIsocenterProjection
      //(0018,9430)
      = const PublicTag("PositionOfIsocenterProjection", 0x00189430,
          "Position of Isocenter Projection", VR.kFL, VM.k2, false);
  static const PublicTag kFieldOfViewSequence
      //(0018,9432)
      = const PublicTag("FieldOfViewSequence", 0x00189432, "Field of View Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFieldOfViewDescription
      //(0018,9433)
      = const PublicTag("FieldOfViewDescription", 0x00189433, "Field of View Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionsSequence
      //(0018,9434)
      = const PublicTag("ExposureControlSensingRegionsSequence", 0x00189434,
          "Exposure Control Sensing Regions Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionShape
      //(0018,9435)
      = const PublicTag("ExposureControlSensingRegionShape", 0x00189435,
          "Exposure Control Sensing Region Shape", VR.kCS, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionLeftVerticalEdge
      //(0018,9436)
      = const PublicTag("ExposureControlSensingRegionLeftVerticalEdge", 0x00189436,
          "Exposure Control Sensing Region Left Vertical Edge", VR.kSS, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionRightVerticalEdge
      //(0018,9437)
      = const PublicTag("ExposureControlSensingRegionRightVerticalEdge", 0x00189437,
          "Exposure Control Sensing Region Right Vertical Edge", VR.kSS, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionUpperHorizontalEdge
      //(0018,9438)
      = const PublicTag("ExposureControlSensingRegionUpperHorizontalEdge", 0x00189438,
          "Exposure Control Sensing Region Upper Horizontal Edge", VR.kSS, VM.k1, false);
  static const PublicTag kExposureControlSensingRegionLowerHorizontalEdge
      //(0018,9439)
      = const PublicTag("ExposureControlSensingRegionLowerHorizontalEdge", 0x00189439,
          "Exposure Control Sensing Region Lower Horizontal Edge", VR.kSS, VM.k1, false);
  static const PublicTag kCenterOfCircularExposureControlSensingRegion
      //(0018,9440)
      = const PublicTag("CenterOfCircularExposureControlSensingRegion", 0x00189440,
          "Center of Circular Exposure Control Sensing Region", VR.kSS, VM.k2, false);
  static const PublicTag kRadiusOfCircularExposureControlSensingRegion
      //(0018,9441)
      = const PublicTag("RadiusOfCircularExposureControlSensingRegion", 0x00189441,
          "Radius of Circular Exposure Control Sensing Region", VR.kUS, VM.k1, false);
  static const PublicTag kVerticesOfThePolygonalExposureControlSensingRegion
      //(0018,9442)
      = const PublicTag(
          "VerticesOfThePolygonalExposureControlSensingRegion",
          0x00189442,
          "Vertices of the Polygonal Exposure Control Sensing Region",
          VR.kSS,
          VM.k2_n,
          false);
  static const PublicTag kNoName0
      //(0018,9445)
      = const PublicTag("NoName0", 0x00189445, "See Note 3", VR.kUnknown, VM.kNoVM, true);
  static const PublicTag kColumnAngulationPatient
      //(0018,9447)
      = const PublicTag("ColumnAngulationPatient", 0x00189447,
          "Column Angulation (Patient)", VR.kFL, VM.k1, false);
  static const PublicTag kBeamAngle
      //(0018,9449)
      = const PublicTag("BeamAngle", 0x00189449, "Beam Angle", VR.kFL, VM.k1, false);
  static const PublicTag kFrameDetectorParametersSequence
      //(0018,9451)
      = const PublicTag("FrameDetectorParametersSequence", 0x00189451,
          "Frame Detector Parameters Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCalculatedAnatomyThickness
      //(0018,9452)
      = const PublicTag("CalculatedAnatomyThickness", 0x00189452,
          "Calculated Anatomy Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kCalibrationSequence
      //(0018,9455)
      = const PublicTag("CalibrationSequence", 0x00189455, "Calibration Sequence", VR.kSQ,
          VM.k1, false);
  static const PublicTag kObjectThicknessSequence
      //(0018,9456)
      = const PublicTag("ObjectThicknessSequence", 0x00189456,
          "Object Thickness Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlaneIdentification
      //(0018,9457)
      = const PublicTag("PlaneIdentification", 0x00189457, "Plane Identification", VR.kCS,
          VM.k1, false);
  static const PublicTag kFieldOfViewDimensionsInFloat
      //(0018,9461)
      = const PublicTag("FieldOfViewDimensionsInFloat", 0x00189461,
          "Field of View Dimension(s) in Float", VR.kFL, VM.k1_2, false);
  static const PublicTag kIsocenterReferenceSystemSequence
      //(0018,9462)
      = const PublicTag("IsocenterReferenceSystemSequence", 0x00189462,
          "Isocenter Reference System Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPositionerIsocenterPrimaryAngle
      //(0018,9463)
      = const PublicTag("PositionerIsocenterPrimaryAngle", 0x00189463,
          "Positioner Isocenter Primary Angle", VR.kFL, VM.k1, false);
  static const PublicTag kPositionerIsocenterSecondaryAngle
      //(0018,9464)
      = const PublicTag("PositionerIsocenterSecondaryAngle", 0x00189464,
          "Positioner Isocenter Secondary Angle", VR.kFL, VM.k1, false);
  static const PublicTag kPositionerIsocenterDetectorRotationAngle
      //(0018,9465)
      = const PublicTag("PositionerIsocenterDetectorRotationAngle", 0x00189465,
          "Positioner Isocenter Detector Rotation Angle", VR.kFL, VM.k1, false);
  static const PublicTag kTableXPositionToIsocenter
      //(0018,9466)
      = const PublicTag("TableXPositionToIsocenter", 0x00189466,
          "Table X Position to Isocenter", VR.kFL, VM.k1, false);
  static const PublicTag kTableYPositionToIsocenter
      //(0018,9467)
      = const PublicTag("TableYPositionToIsocenter", 0x00189467,
          "Table Y Position to Isocenter", VR.kFL, VM.k1, false);
  static const PublicTag kTableZPositionToIsocenter
      //(0018,9468)
      = const PublicTag("TableZPositionToIsocenter", 0x00189468,
          "Table Z Position to Isocenter", VR.kFL, VM.k1, false);
  static const PublicTag kTableHorizontalRotationAngle
      //(0018,9469)
      = const PublicTag("TableHorizontalRotationAngle", 0x00189469,
          "Table Horizontal Rotation Angle", VR.kFL, VM.k1, false);
  static const PublicTag kTableHeadTiltAngle
      //(0018,9470)
      = const PublicTag("TableHeadTiltAngle", 0x00189470, "Table Head Tilt Angle", VR.kFL,
          VM.k1, false);
  static const PublicTag kTableCradleTiltAngle
      //(0018,9471)
      = const PublicTag("TableCradleTiltAngle", 0x00189471, "Table Cradle Tilt Angle",
          VR.kFL, VM.k1, false);
  static const PublicTag kFrameDisplayShutterSequence
      //(0018,9472)
      = const PublicTag("FrameDisplayShutterSequence", 0x00189472,
          "Frame Display Shutter Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcquiredImageAreaDoseProduct
      //(0018,9473)
      = const PublicTag("AcquiredImageAreaDoseProduct", 0x00189473,
          "Acquired Image Area Dose Product", VR.kFL, VM.k1, false);
  static const PublicTag kCArmPositionerTabletopRelationship
      //(0018,9474)
      = const PublicTag("CArmPositionerTabletopRelationship", 0x00189474,
          "C-arm Positioner Tabletop Relationship", VR.kCS, VM.k1, false);
  static const PublicTag kXRayGeometrySequence
      //(0018,9476)
      = const PublicTag("XRayGeometrySequence", 0x00189476, "X-Ray Geometry Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kIrradiationEventIdentificationSequence
      //(0018,9477)
      = const PublicTag("IrradiationEventIdentificationSequence", 0x00189477,
          "Irradiation Event Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kXRay3DFrameTypeSequence
      //(0018,9504)
      = const PublicTag("XRay3DFrameTypeSequence", 0x00189504,
          "X-Ray 3D Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContributingSourcesSequence
      //(0018,9506)
      = const PublicTag("ContributingSourcesSequence", 0x00189506,
          "Contributing Sources Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kXRay3DAcquisitionSequence
      //(0018,9507)
      = const PublicTag("XRay3DAcquisitionSequence", 0x00189507,
          "X-Ray 3D Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrimaryPositionerScanArc
      //(0018,9508)
      = const PublicTag("PrimaryPositionerScanArc", 0x00189508,
          "Primary Positioner Scan Arc", VR.kFL, VM.k1, false);
  static const PublicTag kSecondaryPositionerScanArc
      //(0018,9509)
      = const PublicTag("SecondaryPositionerScanArc", 0x00189509,
          "Secondary Positioner Scan Arc", VR.kFL, VM.k1, false);
  static const PublicTag kPrimaryPositionerScanStartAngle
      //(0018,9510)
      = const PublicTag("PrimaryPositionerScanStartAngle", 0x00189510,
          "Primary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const PublicTag kSecondaryPositionerScanStartAngle
      //(0018,9511)
      = const PublicTag("SecondaryPositionerScanStartAngle", 0x00189511,
          "Secondary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const PublicTag kPrimaryPositionerIncrement
      //(0018,9514)
      = const PublicTag("PrimaryPositionerIncrement", 0x00189514,
          "Primary Positioner Increment", VR.kFL, VM.k1, false);
  static const PublicTag kSecondaryPositionerIncrement
      //(0018,9515)
      = const PublicTag("SecondaryPositionerIncrement", 0x00189515,
          "Secondary Positioner Increment", VR.kFL, VM.k1, false);
  static const PublicTag kStartAcquisitionDateTime
      //(0018,9516)
      = const PublicTag("StartAcquisitionDateTime", 0x00189516,
          "Start Acquisition DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kEndAcquisitionDateTime
      //(0018,9517)
      = const PublicTag("EndAcquisitionDateTime", 0x00189517, "End Acquisition DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kApplicationName
      //(0018,9524)
      = const PublicTag(
          "ApplicationName", 0x00189524, "Application Name", VR.kLO, VM.k1, false);
  static const PublicTag kApplicationVersion
      //(0018,9525)
      = const PublicTag(
          "ApplicationVersion", 0x00189525, "Application Version", VR.kLO, VM.k1, false);
  static const PublicTag kApplicationManufacturer
      //(0018,9526)
      = const PublicTag("ApplicationManufacturer", 0x00189526, "Application Manufacturer",
          VR.kLO, VM.k1, false);
  static const PublicTag kAlgorithmType
      //(0018,9527)
      = const PublicTag(
          "AlgorithmType", 0x00189527, "Algorithm Type", VR.kCS, VM.k1, false);
  static const PublicTag kAlgorithmDescription
      //(0018,9528)
      = const PublicTag("AlgorithmDescription", 0x00189528, "Algorithm Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kXRay3DReconstructionSequence
      //(0018,9530)
      = const PublicTag("XRay3DReconstructionSequence", 0x00189530,
          "X-Ray 3D Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReconstructionDescription
      //(0018,9531)
      = const PublicTag("ReconstructionDescription", 0x00189531,
          "Reconstruction Description", VR.kLO, VM.k1, false);
  static const PublicTag kPerProjectionAcquisitionSequence
      //(0018,9538)
      = const PublicTag("PerProjectionAcquisitionSequence", 0x00189538,
          "Per Projection Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDiffusionBMatrixSequence
      //(0018,9601)
      = const PublicTag("DiffusionBMatrixSequence", 0x00189601,
          "Diffusion b-matrix Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDiffusionBValueXX
      //(0018,9602)
      = const PublicTag(
          "DiffusionBValueXX", 0x00189602, "Diffusion b-value XX", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionBValueXY
      //(0018,9603)
      = const PublicTag(
          "DiffusionBValueXY", 0x00189603, "Diffusion b-value XY", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionBValueXZ
      //(0018,9604)
      = const PublicTag(
          "DiffusionBValueXZ", 0x00189604, "Diffusion b-value XZ", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionBValueYY
      //(0018,9605)
      = const PublicTag(
          "DiffusionBValueYY", 0x00189605, "Diffusion b-value YY", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionBValueYZ
      //(0018,9606)
      = const PublicTag(
          "DiffusionBValueYZ", 0x00189606, "Diffusion b-value YZ", VR.kFD, VM.k1, false);
  static const PublicTag kDiffusionBValueZZ
      //(0018,9607)
      = const PublicTag(
          "DiffusionBValueZZ", 0x00189607, "Diffusion b-value ZZ", VR.kFD, VM.k1, false);
  static const PublicTag kDecayCorrectionDateTime
      //(0018,9701)
      = const PublicTag("DecayCorrectionDateTime", 0x00189701,
          "Decay Correction DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kStartDensityThreshold
      //(0018,9715)
      = const PublicTag("StartDensityThreshold", 0x00189715, "Start Density Threshold",
          VR.kFD, VM.k1, false);
  static const PublicTag kStartRelativeDensityDifferenceThreshold
      //(0018,9716)
      = const PublicTag("StartRelativeDensityDifferenceThreshold", 0x00189716,
          "Start Relative Density Difference Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kStartCardiacTriggerCountThreshold
      //(0018,9717)
      = const PublicTag("StartCardiacTriggerCountThreshold", 0x00189717,
          "Start Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kStartRespiratoryTriggerCountThreshold
      //(0018,9718)
      = const PublicTag("StartRespiratoryTriggerCountThreshold", 0x00189718,
          "Start Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationCountsThreshold
      //(0018,9719)
      = const PublicTag("TerminationCountsThreshold", 0x00189719,
          "Termination Counts Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationDensityThreshold
      //(0018,9720)
      = const PublicTag("TerminationDensityThreshold", 0x00189720,
          "Termination Density Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationRelativeDensityThreshold
      //(0018,9721)
      = const PublicTag("TerminationRelativeDensityThreshold", 0x00189721,
          "Termination Relative Density Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationTimeThreshold
      //(0018,9722)
      = const PublicTag("TerminationTimeThreshold", 0x00189722,
          "Termination Time Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationCardiacTriggerCountThreshold
      //(0018,9723)
      = const PublicTag("TerminationCardiacTriggerCountThreshold", 0x00189723,
          "Termination Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kTerminationRespiratoryTriggerCountThreshold
      //(0018,9724)
      = const PublicTag("TerminationRespiratoryTriggerCountThreshold", 0x00189724,
          "Termination Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kDetectorGeometry
      //(0018,9725)
      = const PublicTag(
          "DetectorGeometry", 0x00189725, "Detector Geometry", VR.kCS, VM.k1, false);
  static const PublicTag kTransverseDetectorSeparation
      //(0018,9726)
      = const PublicTag("TransverseDetectorSeparation", 0x00189726,
          "Transverse Detector Separation", VR.kFD, VM.k1, false);
  static const PublicTag kAxialDetectorDimension
      //(0018,9727)
      = const PublicTag("AxialDetectorDimension", 0x00189727, "Axial Detector Dimension",
          VR.kFD, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalAgentNumber
      //(0018,9729)
      = const PublicTag("RadiopharmaceuticalAgentNumber", 0x00189729,
          "Radiopharmaceutical Agent Number", VR.kUS, VM.k1, false);
  static const PublicTag kPETFrameAcquisitionSequence
      //(0018,9732)
      = const PublicTag("PETFrameAcquisitionSequence", 0x00189732,
          "PET Frame Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPETDetectorMotionDetailsSequence
      //(0018,9733)
      = const PublicTag("PETDetectorMotionDetailsSequence", 0x00189733,
          "PET Detector Motion Details Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPETTableDynamicsSequence
      //(0018,9734)
      = const PublicTag("PETTableDynamicsSequence", 0x00189734,
          "PET Table Dynamics Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPETPositionSequence
      //(0018,9735)
      = const PublicTag("PETPositionSequence", 0x00189735, "PET Position Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPETFrameCorrectionFactorsSequence
      //(0018,9736)
      = const PublicTag("PETFrameCorrectionFactorsSequence", 0x00189736,
          "PET Frame Correction Factors Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalUsageSequence
      //(0018,9737)
      = const PublicTag("RadiopharmaceuticalUsageSequence", 0x00189737,
          "Radiopharmaceutical Usage Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAttenuationCorrectionSource
      //(0018,9738)
      = const PublicTag("AttenuationCorrectionSource", 0x00189738,
          "Attenuation Correction Source", VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfIterations
      //(0018,9739)
      = const PublicTag(
          "NumberOfIterations", 0x00189739, "Number of Iterations", VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfSubsets
      //(0018,9740)
      = const PublicTag(
          "NumberOfSubsets", 0x00189740, "Number of Subsets", VR.kUS, VM.k1, false);
  static const PublicTag kPETReconstructionSequence
      //(0018,9749)
      = const PublicTag("PETReconstructionSequence", 0x00189749,
          "PET Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPETFrameTypeSequence
      //(0018,9751)
      = const PublicTag("PETFrameTypeSequence", 0x00189751, "PET Frame Type Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTimeOfFlightInformationUsed
      //(0018,9755)
      = const PublicTag("TimeOfFlightInformationUsed", 0x00189755,
          "Time of Flight Information Used", VR.kCS, VM.k1, false);
  static const PublicTag kReconstructionType
      //(0018,9756)
      = const PublicTag(
          "ReconstructionType", 0x00189756, "Reconstruction Type", VR.kCS, VM.k1, false);
  static const PublicTag kDecayCorrected
      //(0018,9758)
      = const PublicTag(
          "DecayCorrected", 0x00189758, "Decay Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kAttenuationCorrected
      //(0018,9759)
      = const PublicTag("AttenuationCorrected", 0x00189759, "Attenuation Corrected",
          VR.kCS, VM.k1, false);
  static const PublicTag kScatterCorrected
      //(0018,9760)
      = const PublicTag(
          "ScatterCorrected", 0x00189760, "Scatter Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kDeadTimeCorrected
      //(0018,9761)
      = const PublicTag(
          "DeadTimeCorrected", 0x00189761, "Dead Time Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kGantryMotionCorrected
      //(0018,9762)
      = const PublicTag("GantryMotionCorrected", 0x00189762, "Gantry Motion Corrected",
          VR.kCS, VM.k1, false);
  static const PublicTag kPatientMotionCorrected
      //(0018,9763)
      = const PublicTag("PatientMotionCorrected", 0x00189763, "Patient Motion Corrected",
          VR.kCS, VM.k1, false);
  static const PublicTag kCountLossNormalizationCorrected
      //(0018,9764)
      = const PublicTag("CountLossNormalizationCorrected", 0x00189764,
          "Count Loss Normalization Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kRandomsCorrected
      //(0018,9765)
      = const PublicTag(
          "RandomsCorrected", 0x00189765, "Randoms Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kNonUniformRadialSamplingCorrected
      //(0018,9766)
      = const PublicTag("NonUniformRadialSamplingCorrected", 0x00189766,
          "Non-uniform Radial Sampling Corrected", VR.kCS, VM.k1, false);
  static const PublicTag kSensitivityCalibrated
      //(0018,9767)
      = const PublicTag("SensitivityCalibrated", 0x00189767, "Sensitivity Calibrated",
          VR.kCS, VM.k1, false);
  static const PublicTag kDetectorNormalizationCorrection
      //(0018,9768)
      = const PublicTag("DetectorNormalizationCorrection", 0x00189768,
          "Detector Normalization Correction", VR.kCS, VM.k1, false);
  static const PublicTag kIterativeReconstructionMethod
      //(0018,9769)
      = const PublicTag("IterativeReconstructionMethod", 0x00189769,
          "Iterative Reconstruction Method", VR.kCS, VM.k1, false);
  static const PublicTag kAttenuationCorrectionTemporalRelationship
      //(0018,9770)
      = const PublicTag("AttenuationCorrectionTemporalRelationship", 0x00189770,
          "Attenuation Correction Temporal Relationship", VR.kCS, VM.k1, false);
  static const PublicTag kPatientPhysiologicalStateSequence
      //(0018,9771)
      = const PublicTag("PatientPhysiologicalStateSequence", 0x00189771,
          "Patient Physiological State Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientPhysiologicalStateCodeSequence
      //(0018,9772)
      = const PublicTag("PatientPhysiologicalStateCodeSequence", 0x00189772,
          "Patient Physiological State Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDepthsOfFocus
      //(0018,9801)
      = const PublicTag(
          "DepthsOfFocus", 0x00189801, "Depth(s) of Focus", VR.kFD, VM.k1_n, false);
  static const PublicTag kExcludedIntervalsSequence
      //(0018,9803)
      = const PublicTag("ExcludedIntervalsSequence", 0x00189803,
          "Excluded Intervals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kExclusionStartDateTime
      //(0018,9804)
      = const PublicTag("ExclusionStartDateTime", 0x00189804, "Exclusion Start DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kExclusionDuration
      //(0018,9805)
      = const PublicTag(
          "ExclusionDuration", 0x00189805, "Exclusion Duration", VR.kFD, VM.k1, false);
  static const PublicTag kUSImageDescriptionSequence
      //(0018,9806)
      = const PublicTag("USImageDescriptionSequence", 0x00189806,
          "US Image Description Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageDataTypeSequence
      //(0018,9807)
      = const PublicTag("ImageDataTypeSequence", 0x00189807, "Image Data Type Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDataType
      //(0018,9808)
      = const PublicTag("DataType", 0x00189808, "Data Type", VR.kCS, VM.k1, false);
  static const PublicTag kTransducerScanPatternCodeSequence
      //(0018,9809)
      = const PublicTag("TransducerScanPatternCodeSequence", 0x00189809,
          "Transducer Scan Pattern Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAliasedDataType
      //(0018,980B)
      = const PublicTag(
          "AliasedDataType", 0x0018980B, "Aliased Data Type", VR.kCS, VM.k1, false);
  static const PublicTag kPositionMeasuringDeviceUsed
      //(0018,980C)
      = const PublicTag("PositionMeasuringDeviceUsed", 0x0018980C,
          "Position Measuring Device Used", VR.kCS, VM.k1, false);
  static const PublicTag kTransducerGeometryCodeSequence
      //(0018,980D)
      = const PublicTag("TransducerGeometryCodeSequence", 0x0018980D,
          "Transducer Geometry Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransducerBeamSteeringCodeSequence
      //(0018,980E)
      = const PublicTag("TransducerBeamSteeringCodeSequence", 0x0018980E,
          "Transducer Beam Steering Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransducerApplicationCodeSequence
      //(0018,980F)
      = const PublicTag("TransducerApplicationCodeSequence", 0x0018980F,
          "Transducer Application Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kZeroVelocityPixelValue
      //(0018,9810)
      = const PublicTag("ZeroVelocityPixelValue", 0x00189810, "Zero Velocity Pixel Value",
          VR.kUSSS, VM.k1, false);
  static const PublicTag kContributingEquipmentSequence
      //(0018,A001)
      = const PublicTag("ContributingEquipmentSequence", 0x0018A001,
          "Contributing Equipment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContributionDateTime
      //(0018,A002)
      = const PublicTag("ContributionDateTime", 0x0018A002, "Contribution DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kContributionDescription
      //(0018,A003)
      = const PublicTag("ContributionDescription", 0x0018A003, "Contribution Description",
          VR.kST, VM.k1, false);
  static const PublicTag kStudyInstanceUID
      //(0020,000D)
      = const PublicTag(
          "StudyInstanceUID", 0x0020000D, "Study Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kSeriesInstanceUID
      //(0020,000E)
      = const PublicTag(
          "SeriesInstanceUID", 0x0020000E, "Series Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kStudyID
      //(0020,0010)
      = const PublicTag("StudyID", 0x00200010, "Study ID", VR.kSH, VM.k1, false);
  static const PublicTag kSeriesNumber
      //(0020,0011)
      =
      const PublicTag("SeriesNumber", 0x00200011, "Series Number", VR.kIS, VM.k1, false);
  static const PublicTag kAcquisitionNumber
      //(0020,0012)
      = const PublicTag(
          "AcquisitionNumber", 0x00200012, "Acquisition Number", VR.kIS, VM.k1, false);
  static const PublicTag kInstanceNumber
      //(0020,0013)
      = const PublicTag(
          "InstanceNumber", 0x00200013, "Instance Number", VR.kIS, VM.k1, false);
  static const PublicTag kIsotopeNumber
      //(0020,0014)
      =
      const PublicTag("IsotopeNumber", 0x00200014, "Isotope Number", VR.kIS, VM.k1, true);
  static const PublicTag kPhaseNumber
      //(0020,0015)
      = const PublicTag("PhaseNumber", 0x00200015, "Phase Number", VR.kIS, VM.k1, true);
  static const PublicTag kIntervalNumber
      //(0020,0016)
      = const PublicTag(
          "IntervalNumber", 0x00200016, "Interval Number", VR.kIS, VM.k1, true);
  static const PublicTag kTimeSlotNumber
      //(0020,0017)
      = const PublicTag(
          "TimeSlotNumber", 0x00200017, "Time Slot Number", VR.kIS, VM.k1, true);
  static const PublicTag kAngleNumber
      //(0020,0018)
      = const PublicTag("AngleNumber", 0x00200018, "Angle Number", VR.kIS, VM.k1, true);
  static const PublicTag kItemNumber
      //(0020,0019)
      = const PublicTag("ItemNumber", 0x00200019, "Item Number", VR.kIS, VM.k1, false);
  static const PublicTag kPatientOrientation
      //(0020,0020)
      = const PublicTag(
          "PatientOrientation", 0x00200020, "Patient Orientation", VR.kCS, VM.k2, false);
  static const PublicTag kOverlayNumber
      //(0020,0022)
      =
      const PublicTag("OverlayNumber", 0x00200022, "Overlay Number", VR.kIS, VM.k1, true);
  static const PublicTag kCurveNumber
      //(0020,0024)
      = const PublicTag("CurveNumber", 0x00200024, "Curve Number", VR.kIS, VM.k1, true);
  static const PublicTag kLUTNumber
      //(0020,0026)
      = const PublicTag("LUTNumber", 0x00200026, "LUT Number", VR.kIS, VM.k1, true);
  static const PublicTag kImagePosition
      //(0020,0030)
      =
      const PublicTag("ImagePosition", 0x00200030, "Image Position", VR.kDS, VM.k3, true);
  static const PublicTag kImagePositionPatient
      //(0020,0032)
      = const PublicTag("ImagePositionPatient", 0x00200032, "Image Position (Patient)",
          VR.kDS, VM.k3, false);
  static const PublicTag kImageOrientation
      //(0020,0035)
      = const PublicTag(
          "ImageOrientation", 0x00200035, "Image Orientation", VR.kDS, VM.k6, true);
  static const PublicTag kImageOrientationPatient
      //(0020,0037)
      = const PublicTag("ImageOrientationPatient", 0x00200037,
          "Image Orientation (Patient)", VR.kDS, VM.k6, false);
  static const PublicTag kLocation
      //(0020,0050)
      = const PublicTag("Location", 0x00200050, "Location", VR.kDS, VM.k1, true);
  static const PublicTag kFrameOfReferenceUID
      //(0020,0052)
      = const PublicTag("FrameOfReferenceUID", 0x00200052, "Frame of Reference UID",
          VR.kUI, VM.k1, false);
  static const PublicTag kLaterality
      //(0020,0060)
      = const PublicTag("Laterality", 0x00200060, "Laterality", VR.kCS, VM.k1, false);
  static const PublicTag kImageLaterality
      //(0020,0062)
      = const PublicTag(
          "ImageLaterality", 0x00200062, "Image Laterality", VR.kCS, VM.k1, false);
  static const PublicTag kImageGeometryType
      //(0020,0070)
      = const PublicTag(
          "ImageGeometryType", 0x00200070, "Image Geometry Type", VR.kLO, VM.k1, true);
  static const PublicTag kMaskingImage
      //(0020,0080)
      =
      const PublicTag("MaskingImage", 0x00200080, "Masking Image", VR.kCS, VM.k1_n, true);
  static const PublicTag kReportNumber
      //(0020,00AA)
      = const PublicTag("ReportNumber", 0x002000AA, "Report Number", VR.kIS, VM.k1, true);
  static const PublicTag kTemporalPositionIdentifier
      //(0020,0100)
      = const PublicTag("TemporalPositionIdentifier", 0x00200100,
          "Temporal Position Identifier", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfTemporalPositions
      //(0020,0105)
      = const PublicTag("NumberOfTemporalPositions", 0x00200105,
          "Number of Temporal Positions", VR.kIS, VM.k1, false);
  static const PublicTag kTemporalResolution
      //(0020,0110)
      = const PublicTag(
          "TemporalResolution", 0x00200110, "Temporal Resolution", VR.kDS, VM.k1, false);
  static const PublicTag kSynchronizationFrameOfReferenceUID
      //(0020,0200)
      = const PublicTag("SynchronizationFrameOfReferenceUID", 0x00200200,
          "Synchronization Frame of Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kSOPInstanceUIDOfConcatenationSource
      //(0020,0242)
      = const PublicTag("SOPInstanceUIDOfConcatenationSource", 0x00200242,
          "SOP Instance UID of Concatenation Source", VR.kUI, VM.k1, false);
  static const PublicTag kSeriesInStudy
      //(0020,1000)
      = const PublicTag(
          "SeriesInStudy", 0x00201000, "Series in Study", VR.kIS, VM.k1, true);
  static const PublicTag kAcquisitionsInSeries
      //(0020,1001)
      = const PublicTag("AcquisitionsInSeries", 0x00201001, "Acquisitions in Series",
          VR.kIS, VM.k1, true);
  static const PublicTag kImagesInAcquisition
      //(0020,1002)
      = const PublicTag("ImagesInAcquisition", 0x00201002, "Images in Acquisition",
          VR.kIS, VM.k1, false);
  static const PublicTag kImagesInSeries
      //(0020,1003)
      = const PublicTag(
          "ImagesInSeries", 0x00201003, "Images in Series", VR.kIS, VM.k1, true);
  static const PublicTag kAcquisitionsInStudy
      //(0020,1004)
      = const PublicTag("AcquisitionsInStudy", 0x00201004, "Acquisitions in Study",
          VR.kIS, VM.k1, true);
  static const PublicTag kImagesInStudy
      //(0020,1005)
      = const PublicTag(
          "ImagesInStudy", 0x00201005, "Images in Study", VR.kIS, VM.k1, true);
  static const PublicTag kReference
      //(0020,1020)
      = const PublicTag("Reference", 0x00201020, "Reference", VR.kLO, VM.k1_n, true);
  static const PublicTag kPositionReferenceIndicator
      //(0020,1040)
      = const PublicTag("PositionReferenceIndicator", 0x00201040,
          "Position Reference Indicator", VR.kLO, VM.k1, false);
  static const PublicTag kSliceLocation
      //(0020,1041)
      = const PublicTag(
          "SliceLocation", 0x00201041, "Slice Location", VR.kDS, VM.k1, false);
  static const PublicTag kOtherStudyNumbers
      //(0020,1070)
      = const PublicTag(
          "OtherStudyNumbers", 0x00201070, "Other Study Numbers", VR.kIS, VM.k1_n, true);
  static const PublicTag kNumberOfPatientRelatedStudies
      //(0020,1200)
      = const PublicTag("NumberOfPatientRelatedStudies", 0x00201200,
          "Number of Patient Related Studies", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfPatientRelatedSeries
      //(0020,1202)
      = const PublicTag("NumberOfPatientRelatedSeries", 0x00201202,
          "Number of Patient Related Series", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfPatientRelatedInstances
      //(0020,1204)
      = const PublicTag("NumberOfPatientRelatedInstances", 0x00201204,
          "Number of Patient Related Instances", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfStudyRelatedSeries
      //(0020,1206)
      = const PublicTag("NumberOfStudyRelatedSeries", 0x00201206,
          "Number of Study Related Series", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfStudyRelatedInstances
      //(0020,1208)
      = const PublicTag("NumberOfStudyRelatedInstances", 0x00201208,
          "Number of Study Related Instances", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfSeriesRelatedInstances
      //(0020,1209)
      = const PublicTag("NumberOfSeriesRelatedInstances", 0x00201209,
          "Number of Series Related Instances", VR.kIS, VM.k1, false);
  static const PublicTag kSourceImageIDs
      //(0020,3100)
      = const PublicTag(
          "SourceImageIDs", 0x00203100, "Source Image IDs", VR.kCS, VM.k1_n, true);
  static const PublicTag kModifyingDeviceID
      //(0020,3401)
      = const PublicTag(
          "ModifyingDeviceID", 0x00203401, "Modifying Device ID", VR.kCS, VM.k1, true);
  static const PublicTag kModifiedImageID
      //(0020,3402)
      = const PublicTag(
          "ModifiedImageID", 0x00203402, "Modified Image ID", VR.kCS, VM.k1, true);
  static const PublicTag kModifiedImageDate
      //(0020,3403)
      = const PublicTag(
          "ModifiedImageDate", 0x00203403, "Modified Image Date", VR.kDA, VM.k1, true);
  static const PublicTag kModifyingDeviceManufacturer
      //(0020,3404)
      = const PublicTag("ModifyingDeviceManufacturer", 0x00203404,
          "Modifying Device Manufacturer", VR.kLO, VM.k1, true);
  static const PublicTag kModifiedImageTime
      //(0020,3405)
      = const PublicTag(
          "ModifiedImageTime", 0x00203405, "Modified Image Time", VR.kTM, VM.k1, true);
  static const PublicTag kModifiedImageDescription
      //(0020,3406)
      = const PublicTag("ModifiedImageDescription", 0x00203406,
          "Modified Image Description", VR.kLO, VM.k1, true);
  static const PublicTag kImageComments
      //(0020,4000)
      = const PublicTag(
          "ImageComments", 0x00204000, "Image Comments", VR.kLT, VM.k1, false);
  static const PublicTag kOriginalImageIdentification
      //(0020,5000)
      = const PublicTag("OriginalImageIdentification", 0x00205000,
          "Original Image Identification", VR.kAT, VM.k1_n, true);
  static const PublicTag kOriginalImageIdentificationNomenclature
      //(0020,5002)
      = const PublicTag("OriginalImageIdentificationNomenclature", 0x00205002,
          "Original Image Identification Nomenclature", VR.kLO, VM.k1_n, true);
  static const PublicTag kStackID
      //(0020,9056)
      = const PublicTag("StackID", 0x00209056, "Stack ID", VR.kSH, VM.k1, false);
  static const PublicTag kInStackPositionNumber
      //(0020,9057)
      = const PublicTag("InStackPositionNumber", 0x00209057, "In-Stack Position Number",
          VR.kUL, VM.k1, false);
  static const PublicTag kFrameAnatomySequence
      //(0020,9071)
      = const PublicTag("FrameAnatomySequence", 0x00209071, "Frame Anatomy Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFrameLaterality
      //(0020,9072)
      = const PublicTag(
          "FrameLaterality", 0x00209072, "Frame Laterality", VR.kCS, VM.k1, false);
  static const PublicTag kFrameContentSequence
      //(0020,9111)
      = const PublicTag("FrameContentSequence", 0x00209111, "Frame Content Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPlanePositionSequence
      //(0020,9113)
      = const PublicTag("PlanePositionSequence", 0x00209113, "Plane Position Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPlaneOrientationSequence
      //(0020,9116)
      = const PublicTag("PlaneOrientationSequence", 0x00209116,
          "Plane Orientation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTemporalPositionIndex
      //(0020,9128)
      = const PublicTag("TemporalPositionIndex", 0x00209128, "Temporal Position Index",
          VR.kUL, VM.k1, false);
  static const PublicTag kNominalCardiacTriggerDelayTime
      //(0020,9153)
      = const PublicTag("NominalCardiacTriggerDelayTime", 0x00209153,
          "Nominal Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const PublicTag kNominalCardiacTriggerTimePriorToRPeak
      //(0020,9154)
      = const PublicTag("NominalCardiacTriggerTimePriorToRPeak", 0x00209154,
          "Nominal Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const PublicTag kActualCardiacTriggerTimePriorToRPeak
      //(0020,9155)
      = const PublicTag("ActualCardiacTriggerTimePriorToRPeak", 0x00209155,
          "Actual Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const PublicTag kFrameAcquisitionNumber
      //(0020,9156)
      = const PublicTag("FrameAcquisitionNumber", 0x00209156, "Frame Acquisition Number",
          VR.kUS, VM.k1, false);
  static const PublicTag kDimensionIndexValues
      //(0020,9157)
      = const PublicTag("DimensionIndexValues", 0x00209157, "Dimension Index Values",
          VR.kUL, VM.k1_n, false);
  static const PublicTag kFrameComments
      //(0020,9158)
      = const PublicTag(
          "FrameComments", 0x00209158, "Frame Comments", VR.kLT, VM.k1, false);
  static const PublicTag kConcatenationUID
      //(0020,9161)
      = const PublicTag(
          "ConcatenationUID", 0x00209161, "Concatenation UID", VR.kUI, VM.k1, false);
  static const PublicTag kInConcatenationNumber
      //(0020,9162)
      = const PublicTag("InConcatenationNumber", 0x00209162, "In-concatenation Number",
          VR.kUS, VM.k1, false);
  static const PublicTag kInConcatenationTotalNumber
      //(0020,9163)
      = const PublicTag("InConcatenationTotalNumber", 0x00209163,
          "In-concatenation Total Number", VR.kUS, VM.k1, false);
  static const PublicTag kDimensionOrganizationUID
      //(0020,9164)
      = const PublicTag("DimensionOrganizationUID", 0x00209164,
          "Dimension Organization UID", VR.kUI, VM.k1, false);
  static const PublicTag kDimensionIndexPointer
      //(0020,9165)
      = const PublicTag("DimensionIndexPointer", 0x00209165, "Dimension Index Pointer",
          VR.kAT, VM.k1, false);
  static const PublicTag kFunctionalGroupPointer
      //(0020,9167)
      = const PublicTag("FunctionalGroupPointer", 0x00209167, "Functional Group Pointer",
          VR.kAT, VM.k1, false);
  static const PublicTag kUnassignedSharedConvertedAttributesSequence
      //(0020,9170)
      = const PublicTag("UnassignedSharedConvertedAttributesSequence", 0x00209170,
          "Unassigned Shared Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kUnassignedPerFrameConvertedAttributesSequence
      //(0020,9171)
      = const PublicTag("UnassignedPerFrameConvertedAttributesSequence", 0x00209171,
          "Unassigned Per-Frame Converted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kConversionSourceAttributesSequence
      //(0020,9172)
      = const PublicTag("ConversionSourceAttributesSequence", 0x00209172,
          "Conversion Source Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDimensionIndexPrivateCreator
      //(0020,9213)
      = const PublicTag("DimensionIndexPrivateCreator", 0x00209213,
          "Dimension Index Private Creator", VR.kLO, VM.k1, false);
  static const PublicTag kDimensionOrganizationSequence
      //(0020,9221)
      = const PublicTag("DimensionOrganizationSequence", 0x00209221,
          "Dimension Organization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDimensionIndexSequence
      //(0020,9222)
      = const PublicTag("DimensionIndexSequence", 0x00209222, "Dimension Index Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kConcatenationFrameOffsetNumber
      //(0020,9228)
      = const PublicTag("ConcatenationFrameOffsetNumber", 0x00209228,
          "Concatenation Frame Offset Number", VR.kUL, VM.k1, false);
  static const PublicTag kFunctionalGroupPrivateCreator
      //(0020,9238)
      = const PublicTag("FunctionalGroupPrivateCreator", 0x00209238,
          "Functional Group Private Creator", VR.kLO, VM.k1, false);
  static const PublicTag kNominalPercentageOfCardiacPhase
      //(0020,9241)
      = const PublicTag("NominalPercentageOfCardiacPhase", 0x00209241,
          "Nominal Percentage of Cardiac Phase", VR.kFL, VM.k1, false);
  static const PublicTag kNominalPercentageOfRespiratoryPhase
      //(0020,9245)
      = const PublicTag("NominalPercentageOfRespiratoryPhase", 0x00209245,
          "Nominal Percentage of Respiratory Phase", VR.kFL, VM.k1, false);
  static const PublicTag kStartingRespiratoryAmplitude
      //(0020,9246)
      = const PublicTag("StartingRespiratoryAmplitude", 0x00209246,
          "Starting Respiratory Amplitude", VR.kFL, VM.k1, false);
  static const PublicTag kStartingRespiratoryPhase
      //(0020,9247)
      = const PublicTag("StartingRespiratoryPhase", 0x00209247,
          "Starting Respiratory Phase", VR.kCS, VM.k1, false);
  static const PublicTag kEndingRespiratoryAmplitude
      //(0020,9248)
      = const PublicTag("EndingRespiratoryAmplitude", 0x00209248,
          "Ending Respiratory Amplitude", VR.kFL, VM.k1, false);
  static const PublicTag kEndingRespiratoryPhase
      //(0020,9249)
      = const PublicTag("EndingRespiratoryPhase", 0x00209249, "Ending Respiratory Phase",
          VR.kCS, VM.k1, false);
  static const PublicTag kRespiratoryTriggerType
      //(0020,9250)
      = const PublicTag("RespiratoryTriggerType", 0x00209250, "Respiratory Trigger Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kRRIntervalTimeNominal
      //(0020,9251)
      = const PublicTag("RRIntervalTimeNominal", 0x00209251, "R-R Interval Time Nominal",
          VR.kFD, VM.k1, false);
  static const PublicTag kActualCardiacTriggerDelayTime
      //(0020,9252)
      = const PublicTag("ActualCardiacTriggerDelayTime", 0x00209252,
          "Actual Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const PublicTag kRespiratorySynchronizationSequence
      //(0020,9253)
      = const PublicTag("RespiratorySynchronizationSequence", 0x00209253,
          "Respiratory Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRespiratoryIntervalTime
      //(0020,9254)
      = const PublicTag("RespiratoryIntervalTime", 0x00209254,
          "Respiratory Interval Time", VR.kFD, VM.k1, false);
  static const PublicTag kNominalRespiratoryTriggerDelayTime
      //(0020,9255)
      = const PublicTag("NominalRespiratoryTriggerDelayTime", 0x00209255,
          "Nominal Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const PublicTag kRespiratoryTriggerDelayThreshold
      //(0020,9256)
      = const PublicTag("RespiratoryTriggerDelayThreshold", 0x00209256,
          "Respiratory Trigger Delay Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kActualRespiratoryTriggerDelayTime
      //(0020,9257)
      = const PublicTag("ActualRespiratoryTriggerDelayTime", 0x00209257,
          "Actual Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const PublicTag kImagePositionVolume
      //(0020,9301)
      = const PublicTag("ImagePositionVolume", 0x00209301, "Image Position (Volume)",
          VR.kFD, VM.k3, false);
  static const PublicTag kImageOrientationVolume
      //(0020,9302)
      = const PublicTag("ImageOrientationVolume", 0x00209302,
          "Image Orientation (Volume)", VR.kFD, VM.k6, false);
  static const PublicTag kUltrasoundAcquisitionGeometry
      //(0020,9307)
      = const PublicTag("UltrasoundAcquisitionGeometry", 0x00209307,
          "Ultrasound Acquisition Geometry", VR.kCS, VM.k1, false);
  static const PublicTag kApexPosition
      //(0020,9308)
      =
      const PublicTag("ApexPosition", 0x00209308, "Apex Position", VR.kFD, VM.k3, false);
  static const PublicTag kVolumeToTransducerMappingMatrix
      //(0020,9309)
      = const PublicTag("VolumeToTransducerMappingMatrix", 0x00209309,
          "Volume to Transducer Mapping Matrix", VR.kFD, VM.k16, false);
  static const PublicTag kVolumeToTableMappingMatrix
      //(0020,930A)
      = const PublicTag("VolumeToTableMappingMatrix", 0x0020930A,
          "Volume to Table Mapping Matrix", VR.kFD, VM.k16, false);
  static const PublicTag kPatientFrameOfReferenceSource
      //(0020,930C)
      = const PublicTag("PatientFrameOfReferenceSource", 0x0020930C,
          "Patient Frame of Reference Source", VR.kCS, VM.k1, false);
  static const PublicTag kTemporalPositionTimeOffset
      //(0020,930D)
      = const PublicTag("TemporalPositionTimeOffset", 0x0020930D,
          "Temporal Position Time Offset", VR.kFD, VM.k1, false);
  static const PublicTag kPlanePositionVolumeSequence
      //(0020,930E)
      = const PublicTag("PlanePositionVolumeSequence", 0x0020930E,
          "Plane Position (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlaneOrientationVolumeSequence
      //(0020,930F)
      = const PublicTag("PlaneOrientationVolumeSequence", 0x0020930F,
          "Plane Orientation (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTemporalPositionSequence
      //(0020,9310)
      = const PublicTag("TemporalPositionSequence", 0x00209310,
          "Temporal Position Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDimensionOrganizationType
      //(0020,9311)
      = const PublicTag("DimensionOrganizationType", 0x00209311,
          "Dimension Organization Type", VR.kCS, VM.k1, false);
  static const PublicTag kVolumeFrameOfReferenceUID
      //(0020,9312)
      = const PublicTag("VolumeFrameOfReferenceUID", 0x00209312,
          "Volume Frame of Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kTableFrameOfReferenceUID
      //(0020,9313)
      = const PublicTag("TableFrameOfReferenceUID", 0x00209313,
          "Table Frame of Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kDimensionDescriptionLabel
      //(0020,9421)
      = const PublicTag("DimensionDescriptionLabel", 0x00209421,
          "Dimension Description Label", VR.kLO, VM.k1, false);
  static const PublicTag kPatientOrientationInFrameSequence
      //(0020,9450)
      = const PublicTag("PatientOrientationInFrameSequence", 0x00209450,
          "Patient Orientation in Frame Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFrameLabel
      //(0020,9453)
      = const PublicTag("FrameLabel", 0x00209453, "Frame Label", VR.kLO, VM.k1, false);
  static const PublicTag kAcquisitionIndex
      //(0020,9518)
      = const PublicTag(
          "AcquisitionIndex", 0x00209518, "Acquisition Index", VR.kUS, VM.k1_n, false);
  static const PublicTag kContributingSOPInstancesReferenceSequence
      //(0020,9529)
      = const PublicTag("ContributingSOPInstancesReferenceSequence", 0x00209529,
          "Contributing SOP Instances Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReconstructionIndex
      //(0020,9536)
      = const PublicTag("ReconstructionIndex", 0x00209536, "Reconstruction Index", VR.kUS,
          VM.k1, false);
  static const PublicTag kLightPathFilterPassThroughWavelength
      //(0022,0001)
      = const PublicTag("LightPathFilterPassThroughWavelength", 0x00220001,
          "Light Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const PublicTag kLightPathFilterPassBand
      //(0022,0002)
      = const PublicTag("LightPathFilterPassBand", 0x00220002,
          "Light Path Filter Pass Band", VR.kUS, VM.k2, false);
  static const PublicTag kImagePathFilterPassThroughWavelength
      //(0022,0003)
      = const PublicTag("ImagePathFilterPassThroughWavelength", 0x00220003,
          "Image Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const PublicTag kImagePathFilterPassBand
      //(0022,0004)
      = const PublicTag("ImagePathFilterPassBand", 0x00220004,
          "Image Path Filter Pass Band", VR.kUS, VM.k2, false);
  static const PublicTag kPatientEyeMovementCommanded
      //(0022,0005)
      = const PublicTag("PatientEyeMovementCommanded", 0x00220005,
          "Patient Eye Movement Commanded", VR.kCS, VM.k1, false);
  static const PublicTag kPatientEyeMovementCommandCodeSequence
      //(0022,0006)
      = const PublicTag("PatientEyeMovementCommandCodeSequence", 0x00220006,
          "Patient Eye Movement Command Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSphericalLensPower
      //(0022,0007)
      = const PublicTag(
          "SphericalLensPower", 0x00220007, "Spherical Lens Power", VR.kFL, VM.k1, false);
  static const PublicTag kCylinderLensPower
      //(0022,0008)
      = const PublicTag(
          "CylinderLensPower", 0x00220008, "Cylinder Lens Power", VR.kFL, VM.k1, false);
  static const PublicTag kCylinderAxis
      //(0022,0009)
      =
      const PublicTag("CylinderAxis", 0x00220009, "Cylinder Axis", VR.kFL, VM.k1, false);
  static const PublicTag kEmmetropicMagnification
      //(0022,000A)
      = const PublicTag("EmmetropicMagnification", 0x0022000A, "Emmetropic Magnification",
          VR.kFL, VM.k1, false);
  static const PublicTag kIntraOcularPressure
      //(0022,000B)
      = const PublicTag("IntraOcularPressure", 0x0022000B, "Intra Ocular Pressure",
          VR.kFL, VM.k1, false);
  static const PublicTag kHorizontalFieldOfView
      //(0022,000C)
      = const PublicTag("HorizontalFieldOfView", 0x0022000C, "Horizontal Field of View",
          VR.kFL, VM.k1, false);
  static const PublicTag kPupilDilated
      //(0022,000D)
      =
      const PublicTag("PupilDilated", 0x0022000D, "Pupil Dilated", VR.kCS, VM.k1, false);
  static const PublicTag kDegreeOfDilation
      //(0022,000E)
      = const PublicTag(
          "DegreeOfDilation", 0x0022000E, "Degree of Dilation", VR.kFL, VM.k1, false);
  static const PublicTag kStereoBaselineAngle
      //(0022,0010)
      = const PublicTag("StereoBaselineAngle", 0x00220010, "Stereo Baseline Angle",
          VR.kFL, VM.k1, false);
  static const PublicTag kStereoBaselineDisplacement
      //(0022,0011)
      = const PublicTag("StereoBaselineDisplacement", 0x00220011,
          "Stereo Baseline Displacement", VR.kFL, VM.k1, false);
  static const PublicTag kStereoHorizontalPixelOffset
      //(0022,0012)
      = const PublicTag("StereoHorizontalPixelOffset", 0x00220012,
          "Stereo Horizontal Pixel Offset", VR.kFL, VM.k1, false);
  static const PublicTag kStereoVerticalPixelOffset
      //(0022,0013)
      = const PublicTag("StereoVerticalPixelOffset", 0x00220013,
          "Stereo Vertical Pixel Offset", VR.kFL, VM.k1, false);
  static const PublicTag kStereoRotation
      //(0022,0014)
      = const PublicTag(
          "StereoRotation", 0x00220014, "Stereo Rotation", VR.kFL, VM.k1, false);
  static const PublicTag kAcquisitionDeviceTypeCodeSequence
      //(0022,0015)
      = const PublicTag("AcquisitionDeviceTypeCodeSequence", 0x00220015,
          "Acquisition Device Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIlluminationTypeCodeSequence
      //(0022,0016)
      = const PublicTag("IlluminationTypeCodeSequence", 0x00220016,
          "Illumination Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLightPathFilterTypeStackCodeSequence
      //(0022,0017)
      = const PublicTag("LightPathFilterTypeStackCodeSequence", 0x00220017,
          "Light Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImagePathFilterTypeStackCodeSequence
      //(0022,0018)
      = const PublicTag("ImagePathFilterTypeStackCodeSequence", 0x00220018,
          "Image Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLensesCodeSequence
      //(0022,0019)
      = const PublicTag(
          "LensesCodeSequence", 0x00220019, "Lenses Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelDescriptionCodeSequence
      //(0022,001A)
      = const PublicTag("ChannelDescriptionCodeSequence", 0x0022001A,
          "Channel Description Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRefractiveStateSequence
      //(0022,001B)
      = const PublicTag("RefractiveStateSequence", 0x0022001B,
          "Refractive State Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMydriaticAgentCodeSequence
      //(0022,001C)
      = const PublicTag("MydriaticAgentCodeSequence", 0x0022001C,
          "Mydriatic Agent Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelativeImagePositionCodeSequence
      //(0022,001D)
      = const PublicTag("RelativeImagePositionCodeSequence", 0x0022001D,
          "Relative Image Position Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCameraAngleOfView
      //(0022,001E)
      = const PublicTag(
          "CameraAngleOfView", 0x0022001E, "Camera Angle of View", VR.kFL, VM.k1, false);
  static const PublicTag kStereoPairsSequence
      //(0022,0020)
      = const PublicTag("StereoPairsSequence", 0x00220020, "Stereo Pairs Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kLeftImageSequence
      //(0022,0021)
      = const PublicTag(
          "LeftImageSequence", 0x00220021, "Left Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRightImageSequence
      //(0022,0022)
      = const PublicTag(
          "RightImageSequence", 0x00220022, "Right Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAxialLengthOfTheEye
      //(0022,0030)
      = const PublicTag("AxialLengthOfTheEye", 0x00220030, "Axial Length of the Eye",
          VR.kFL, VM.k1, false);
  static const PublicTag kOphthalmicFrameLocationSequence
      //(0022,0031)
      = const PublicTag("OphthalmicFrameLocationSequence", 0x00220031,
          "Ophthalmic Frame Location Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferenceCoordinates
      //(0022,0032)
      = const PublicTag("ReferenceCoordinates", 0x00220032, "Reference Coordinates",
          VR.kFL, VM.k2_2n, false);
  static const PublicTag kDepthSpatialResolution
      //(0022,0035)
      = const PublicTag("DepthSpatialResolution", 0x00220035, "Depth Spatial Resolution",
          VR.kFL, VM.k1, false);
  static const PublicTag kMaximumDepthDistortion
      //(0022,0036)
      = const PublicTag("MaximumDepthDistortion", 0x00220036, "Maximum Depth Distortion",
          VR.kFL, VM.k1, false);
  static const PublicTag kAlongScanSpatialResolution
      //(0022,0037)
      = const PublicTag("AlongScanSpatialResolution", 0x00220037,
          "Along-scan Spatial Resolution", VR.kFL, VM.k1, false);
  static const PublicTag kMaximumAlongScanDistortion
      //(0022,0038)
      = const PublicTag("MaximumAlongScanDistortion", 0x00220038,
          "Maximum Along-scan Distortion", VR.kFL, VM.k1, false);
  static const PublicTag kOphthalmicImageOrientation
      //(0022,0039)
      = const PublicTag("OphthalmicImageOrientation", 0x00220039,
          "Ophthalmic Image Orientation", VR.kCS, VM.k1, false);
  static const PublicTag kDepthOfTransverseImage
      //(0022,0041)
      = const PublicTag("DepthOfTransverseImage", 0x00220041, "Depth of Transverse Image",
          VR.kFL, VM.k1, false);
  static const PublicTag kMydriaticAgentConcentrationUnitsSequence
      //(0022,0042)
      = const PublicTag("MydriaticAgentConcentrationUnitsSequence", 0x00220042,
          "Mydriatic Agent Concentration Units Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcrossScanSpatialResolution
      //(0022,0048)
      = const PublicTag("AcrossScanSpatialResolution", 0x00220048,
          "Across-scan Spatial Resolution", VR.kFL, VM.k1, false);
  static const PublicTag kMaximumAcrossScanDistortion
      //(0022,0049)
      = const PublicTag("MaximumAcrossScanDistortion", 0x00220049,
          "Maximum Across-scan Distortion", VR.kFL, VM.k1, false);
  static const PublicTag kMydriaticAgentConcentration
      //(0022,004E)
      = const PublicTag("MydriaticAgentConcentration", 0x0022004E,
          "Mydriatic Agent Concentration", VR.kDS, VM.k1, false);
  static const PublicTag kIlluminationWaveLength
      //(0022,0055)
      = const PublicTag("IlluminationWaveLength", 0x00220055, "Illumination Wave Length",
          VR.kFL, VM.k1, false);
  static const PublicTag kIlluminationPower
      //(0022,0056)
      = const PublicTag(
          "IlluminationPower", 0x00220056, "Illumination Power", VR.kFL, VM.k1, false);
  static const PublicTag kIlluminationBandwidth
      //(0022,0057)
      = const PublicTag("IlluminationBandwidth", 0x00220057, "Illumination Bandwidth",
          VR.kFL, VM.k1, false);
  static const PublicTag kMydriaticAgentSequence
      //(0022,0058)
      = const PublicTag("MydriaticAgentSequence", 0x00220058, "Mydriatic Agent Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialMeasurementsRightEyeSequence
      //(0022,1007)
      = const PublicTag("OphthalmicAxialMeasurementsRightEyeSequence", 0x00221007,
          "Ophthalmic Axial Measurements Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialMeasurementsLeftEyeSequence
      //(0022,1008)
      = const PublicTag("OphthalmicAxialMeasurementsLeftEyeSequence", 0x00221008,
          "Ophthalmic Axial Measurements Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialMeasurementsDeviceType
      //(0022,1009)
      = const PublicTag("OphthalmicAxialMeasurementsDeviceType", 0x00221009,
          "Ophthalmic Axial Measurements Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsType
      //(0022,1010)
      = const PublicTag("OphthalmicAxialLengthMeasurementsType", 0x00221010,
          "Ophthalmic Axial Length Measurements Type", VR.kCS, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthSequence
      //(0022,1012)
      = const PublicTag("OphthalmicAxialLengthSequence", 0x00221012,
          "Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLength
      //(0022,1019)
      = const PublicTag("OphthalmicAxialLength", 0x00221019, "Ophthalmic Axial Length",
          VR.kFL, VM.k1, false);
  static const PublicTag kLensStatusCodeSequence
      //(0022,1024)
      = const PublicTag("LensStatusCodeSequence", 0x00221024, "Lens Status Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kVitreousStatusCodeSequence
      //(0022,1025)
      = const PublicTag("VitreousStatusCodeSequence", 0x00221025,
          "Vitreous Status Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIOLFormulaCodeSequence
      //(0022,1028)
      = const PublicTag("IOLFormulaCodeSequence", 0x00221028, "IOL Formula Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kIOLFormulaDetail
      //(0022,1029)
      = const PublicTag(
          "IOLFormulaDetail", 0x00221029, "IOL Formula Detail", VR.kLO, VM.k1, false);
  static const PublicTag kKeratometerIndex
      //(0022,1033)
      = const PublicTag(
          "KeratometerIndex", 0x00221033, "Keratometer Index", VR.kFL, VM.k1, false);
  static const PublicTag kSourceOfOphthalmicAxialLengthCodeSequence
      //(0022,1035)
      = const PublicTag("SourceOfOphthalmicAxialLengthCodeSequence", 0x00221035,
          "Source of Ophthalmic Axial Length Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTargetRefraction
      //(0022,1037)
      = const PublicTag(
          "TargetRefraction", 0x00221037, "Target Refraction", VR.kFL, VM.k1, false);
  static const PublicTag kRefractiveProcedureOccurred
      //(0022,1039)
      = const PublicTag("RefractiveProcedureOccurred", 0x00221039,
          "Refractive Procedure Occurred", VR.kCS, VM.k1, false);
  static const PublicTag kRefractiveSurgeryTypeCodeSequence
      //(0022,1040)
      = const PublicTag("RefractiveSurgeryTypeCodeSequence", 0x00221040,
          "Refractive Surgery Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicUltrasoundMethodCodeSequence
      //(0022,1044)
      = const PublicTag("OphthalmicUltrasoundMethodCodeSequence", 0x00221044,
          "Ophthalmic Ultrasound Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsSequence
      //(0022,1050)
      = const PublicTag("OphthalmicAxialLengthMeasurementsSequence", 0x00221050,
          "Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIOLPower
      //(0022,1053)
      = const PublicTag("IOLPower", 0x00221053, "IOL Power", VR.kFL, VM.k1, false);
  static const PublicTag kPredictedRefractiveError
      //(0022,1054)
      = const PublicTag("PredictedRefractiveError", 0x00221054,
          "Predicted Refractive Error", VR.kFL, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthVelocity
      //(0022,1059)
      = const PublicTag("OphthalmicAxialLengthVelocity", 0x00221059,
          "Ophthalmic Axial Length Velocity", VR.kFL, VM.k1, false);
  static const PublicTag kLensStatusDescription
      //(0022,1065)
      = const PublicTag("LensStatusDescription", 0x00221065, "Lens Status Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kVitreousStatusDescription
      //(0022,1066)
      = const PublicTag("VitreousStatusDescription", 0x00221066,
          "Vitreous Status Description", VR.kLO, VM.k1, false);
  static const PublicTag kIOLPowerSequence
      //(0022,1090)
      = const PublicTag(
          "IOLPowerSequence", 0x00221090, "IOL Power Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLensConstantSequence
      //(0022,1092)
      = const PublicTag("LensConstantSequence", 0x00221092, "Lens Constant Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kIOLManufacturer
      //(0022,1093)
      = const PublicTag(
          "IOLManufacturer", 0x00221093, "IOL Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kLensConstantDescription
      //(0022,1094)
      = const PublicTag("LensConstantDescription", 0x00221094,
          "Lens Constant Description", VR.kLO, VM.k1, true);
  static const PublicTag kImplantName
      //(0022,1095)
      = const PublicTag("ImplantName", 0x00221095, "Implant Name", VR.kLO, VM.k1, false);
  static const PublicTag kKeratometryMeasurementTypeCodeSequence
      //(0022,1096)
      = const PublicTag("KeratometryMeasurementTypeCodeSequence", 0x00221096,
          "Keratometry Measurement Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantPartNumber
      //(0022,1097)
      = const PublicTag(
          "ImplantPartNumber", 0x00221097, "Implant Part Number", VR.kLO, VM.k1, false);
  static const PublicTag kReferencedOphthalmicAxialMeasurementsSequence
      //(0022,1100)
      = const PublicTag("ReferencedOphthalmicAxialMeasurementsSequence", 0x00221100,
          "Referenced Ophthalmic Axial Measurements Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsSegmentNameCodeSequence
      //(0022,1101)
      = const PublicTag(
          "OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence",
          0x00221101,
          "Ophthalmic Axial Length Measurements Segment Name Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kRefractiveErrorBeforeRefractiveSurgeryCodeSequence
      //(0022,1103)
      = const PublicTag(
          "RefractiveErrorBeforeRefractiveSurgeryCodeSequence",
          0x00221103,
          "Refractive Error Before Refractive Surgery Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kIOLPowerForExactEmmetropia
      //(0022,1121)
      = const PublicTag("IOLPowerForExactEmmetropia", 0x00221121,
          "IOL Power For Exact Emmetropia", VR.kFL, VM.k1, false);
  static const PublicTag kIOLPowerForExactTargetRefraction
      //(0022,1122)
      = const PublicTag("IOLPowerForExactTargetRefraction", 0x00221122,
          "IOL Power For Exact Target Refraction", VR.kFL, VM.k1, false);
  static const PublicTag kAnteriorChamberDepthDefinitionCodeSequence
      //(0022,1125)
      = const PublicTag("AnteriorChamberDepthDefinitionCodeSequence", 0x00221125,
          "Anterior Chamber Depth Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLensThicknessSequence
      //(0022,1127)
      = const PublicTag("LensThicknessSequence", 0x00221127, "Lens Thickness Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kAnteriorChamberDepthSequence
      //(0022,1128)
      = const PublicTag("AnteriorChamberDepthSequence", 0x00221128,
          "Anterior Chamber Depth Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLensThickness
      //(0022,1130)
      = const PublicTag(
          "LensThickness", 0x00221130, "Lens Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kAnteriorChamberDepth
      //(0022,1131)
      = const PublicTag("AnteriorChamberDepth", 0x00221131, "Anterior Chamber Depth",
          VR.kFL, VM.k1, false);
  static const PublicTag kSourceOfLensThicknessDataCodeSequence
      //(0022,1132)
      = const PublicTag("SourceOfLensThicknessDataCodeSequence", 0x00221132,
          "Source of Lens Thickness Data Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceOfAnteriorChamberDepthDataCodeSequence
      //(0022,1133)
      = const PublicTag("SourceOfAnteriorChamberDepthDataCodeSequence", 0x00221133,
          "Source of Anterior Chamber Depth Data Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceOfRefractiveMeasurementsSequence
      //(0022,1134)
      = const PublicTag("SourceOfRefractiveMeasurementsSequence", 0x00221134,
          "Source of Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceOfRefractiveMeasurementsCodeSequence
      //(0022,1135)
      = const PublicTag("SourceOfRefractiveMeasurementsCodeSequence", 0x00221135,
          "Source of Refractive Measurements Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthMeasurementModified
      //(0022,1140)
      = const PublicTag("OphthalmicAxialLengthMeasurementModified", 0x00221140,
          "Ophthalmic Axial Length Measurement Modified", VR.kCS, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthDataSourceCodeSequence
      //(0022,1150)
      = const PublicTag("OphthalmicAxialLengthDataSourceCodeSequence", 0x00221150,
          "Ophthalmic Axial Length Data Source Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthAcquisitionMethodCodeSequence
      //(0022,1153)
      = const PublicTag(
          "OphthalmicAxialLengthAcquisitionMethodCodeSequence",
          0x00221153,
          "Ophthalmic Axial Length Acquisition Method Code Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kSignalToNoiseRatio
      //(0022,1155)
      = const PublicTag("SignalToNoiseRatio", 0x00221155, "Signal to Noise Ratio", VR.kFL,
          VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthDataSourceDescription
      //(0022,1159)
      = const PublicTag("OphthalmicAxialLengthDataSourceDescription", 0x00221159,
          "Ophthalmic Axial Length Data Source Description", VR.kLO, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsTotalLengthSequence
      //(0022,1210)
      = const PublicTag(
          "OphthalmicAxialLengthMeasurementsTotalLengthSequence",
          0x00221210,
          "Ophthalmic Axial Length Measurements Total Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsSegmentalLengthSequence
      //(0022,1211)
      = const PublicTag(
          "OphthalmicAxialLengthMeasurementsSegmentalLengthSequence",
          0x00221211,
          "Ophthalmic Axial Length Measurements Segmental Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kOphthalmicAxialLengthMeasurementsLengthSummationSequence
      //(0022,1212)
      = const PublicTag(
          "OphthalmicAxialLengthMeasurementsLengthSummationSequence",
          0x00221212,
          "Ophthalmic Axial Length Measurements Length Summation Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kUltrasoundOphthalmicAxialLengthMeasurementsSequence
      //(0022,1220)
      = const PublicTag(
          "UltrasoundOphthalmicAxialLengthMeasurementsSequence",
          0x00221220,
          "Ultrasound Ophthalmic Axial Length Measurements Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kOpticalOphthalmicAxialLengthMeasurementsSequence
      //(0022,1225)
      = const PublicTag("OpticalOphthalmicAxialLengthMeasurementsSequence", 0x00221225,
          "Optical Ophthalmic Axial Length Measurements Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kUltrasoundSelectedOphthalmicAxialLengthSequence
      //(0022,1230)
      = const PublicTag("UltrasoundSelectedOphthalmicAxialLengthSequence", 0x00221230,
          "Ultrasound Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthSelectionMethodCodeSequence
      //(0022,1250)
      = const PublicTag("OphthalmicAxialLengthSelectionMethodCodeSequence", 0x00221250,
          "Ophthalmic Axial Length Selection Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOpticalSelectedOphthalmicAxialLengthSequence
      //(0022,1255)
      = const PublicTag("OpticalSelectedOphthalmicAxialLengthSequence", 0x00221255,
          "Optical Selected Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSelectedSegmentalOphthalmicAxialLengthSequence
      //(0022,1257)
      = const PublicTag("SelectedSegmentalOphthalmicAxialLengthSequence", 0x00221257,
          "Selected Segmental Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSelectedTotalOphthalmicAxialLengthSequence
      //(0022,1260)
      = const PublicTag("SelectedTotalOphthalmicAxialLengthSequence", 0x00221260,
          "Selected Total Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthQualityMetricSequence
      //(0022,1262)
      = const PublicTag("OphthalmicAxialLengthQualityMetricSequence", 0x00221262,
          "Ophthalmic Axial Length Quality Metric Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicAxialLengthQualityMetricTypeCodeSequence
      //(0022,1265)
      = const PublicTag(
          "OphthalmicAxialLengthQualityMetricTypeCodeSequence",
          0x00221265,
          "Ophthalmic Axial Length Quality Metric Type Code Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kOphthalmicAxialLengthQualityMetricTypeDescription
      //(0022,1273)
      = const PublicTag("OphthalmicAxialLengthQualityMetricTypeDescription", 0x00221273,
          "Ophthalmic Axial Length Quality Metric Type Description", VR.kLO, VM.k1, true);
  static const PublicTag kIntraocularLensCalculationsRightEyeSequence
      //(0022,1300)
      = const PublicTag("IntraocularLensCalculationsRightEyeSequence", 0x00221300,
          "Intraocular Lens Calculations Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIntraocularLensCalculationsLeftEyeSequence
      //(0022,1310)
      = const PublicTag("IntraocularLensCalculationsLeftEyeSequence", 0x00221310,
          "Intraocular Lens Calculations Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedOphthalmicAxialLengthMeasurementQCImageSequence
      //(0022,1330)
      = const PublicTag(
          "ReferencedOphthalmicAxialLengthMeasurementQCImageSequence",
          0x00221330,
          "Referenced Ophthalmic Axial Length Measurement QC Image Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kOphthalmicMappingDeviceType
      //(0022,1415)
      = const PublicTag("OphthalmicMappingDeviceType", 0x00221415,
          "Ophthalmic Mapping Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kAcquisitionMethodCodeSequence
      //(0022,1420)
      = const PublicTag("AcquisitionMethodCodeSequence", 0x00221420,
          "Acquisition Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcquisitionMethodAlgorithmSequence
      //(0022,1423)
      = const PublicTag("AcquisitionMethodAlgorithmSequence", 0x00221423,
          "Acquisition Method Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicThicknessMapTypeCodeSequence
      //(0022,1436)
      = const PublicTag("OphthalmicThicknessMapTypeCodeSequence", 0x00221436,
          "Ophthalmic Thickness Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicThicknessMappingNormalsSequence
      //(0022,1443)
      = const PublicTag("OphthalmicThicknessMappingNormalsSequence", 0x00221443,
          "Ophthalmic Thickness Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRetinalThicknessDefinitionCodeSequence
      //(0022,1445)
      = const PublicTag("RetinalThicknessDefinitionCodeSequence", 0x00221445,
          "Retinal Thickness Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPixelValueMappingToCodedConceptSequence
      //(0022,1450)
      = const PublicTag("PixelValueMappingToCodedConceptSequence", 0x00221450,
          "Pixel Value Mapping to Coded Concept Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMappedPixelValue
      //(0022,1452)
      = const PublicTag(
          "MappedPixelValue", 0x00221452, "Mapped Pixel Value", VR.kUSSS, VM.k1, false);
  static const PublicTag kPixelValueMappingExplanation
      //(0022,1454)
      = const PublicTag("PixelValueMappingExplanation", 0x00221454,
          "Pixel Value Mapping Explanation", VR.kLO, VM.k1, false);
  static const PublicTag kOphthalmicThicknessMapQualityThresholdSequence
      //(0022,1458)
      = const PublicTag("OphthalmicThicknessMapQualityThresholdSequence", 0x00221458,
          "Ophthalmic Thickness Map Quality Threshold Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOphthalmicThicknessMapThresholdQualityRating
      //(0022,1460)
      = const PublicTag("OphthalmicThicknessMapThresholdQualityRating", 0x00221460,
          "Ophthalmic Thickness Map Threshold Quality Rating", VR.kFL, VM.k1, false);
  static const PublicTag kAnatomicStructureReferencePoint
      //(0022,1463)
      = const PublicTag("AnatomicStructureReferencePoint", 0x00221463,
          "Anatomic Structure Reference Point", VR.kFL, VM.k2, false);
  static const PublicTag kRegistrationToLocalizerSequence
      //(0022,1465)
      = const PublicTag("RegistrationToLocalizerSequence", 0x00221465,
          "Registration to Localizer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRegisteredLocalizerUnits
      //(0022,1466)
      = const PublicTag("RegisteredLocalizerUnits", 0x00221466,
          "Registered Localizer Units", VR.kCS, VM.k1, false);
  static const PublicTag kRegisteredLocalizerTopLeftHandCorner
      //(0022,1467)
      = const PublicTag("RegisteredLocalizerTopLeftHandCorner", 0x00221467,
          "Registered Localizer Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const PublicTag kRegisteredLocalizerBottomRightHandCorner
      //(0022,1468)
      = const PublicTag("RegisteredLocalizerBottomRightHandCorner", 0x00221468,
          "Registered Localizer Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const PublicTag kOphthalmicThicknessMapQualityRatingSequence
      //(0022,1470)
      = const PublicTag("OphthalmicThicknessMapQualityRatingSequence", 0x00221470,
          "Ophthalmic Thickness Map Quality Rating Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelevantOPTAttributesSequence
      //(0022,1472)
      = const PublicTag("RelevantOPTAttributesSequence", 0x00221472,
          "Relevant OPT Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualFieldHorizontalExtent
      //(0024,0010)
      = const PublicTag("VisualFieldHorizontalExtent", 0x00240010,
          "Visual Field Horizontal Extent", VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldVerticalExtent
      //(0024,0011)
      = const PublicTag("VisualFieldVerticalExtent", 0x00240011,
          "Visual Field Vertical Extent", VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldShape
      //(0024,0012)
      = const PublicTag(
          "VisualFieldShape", 0x00240012, "Visual Field Shape", VR.kCS, VM.k1, false);
  static const PublicTag kScreeningTestModeCodeSequence
      //(0024,0016)
      = const PublicTag("ScreeningTestModeCodeSequence", 0x00240016,
          "Screening Test Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMaximumStimulusLuminance
      //(0024,0018)
      = const PublicTag("MaximumStimulusLuminance", 0x00240018,
          "Maximum Stimulus Luminance", VR.kFL, VM.k1, false);
  static const PublicTag kBackgroundLuminance
      //(0024,0020)
      = const PublicTag("BackgroundLuminance", 0x00240020, "Background Luminance", VR.kFL,
          VM.k1, false);
  static const PublicTag kStimulusColorCodeSequence
      //(0024,0021)
      = const PublicTag("StimulusColorCodeSequence", 0x00240021,
          "Stimulus Color Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBackgroundIlluminationColorCodeSequence
      //(0024,0024)
      = const PublicTag("BackgroundIlluminationColorCodeSequence", 0x00240024,
          "Background Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStimulusArea
      //(0024,0025)
      =
      const PublicTag("StimulusArea", 0x00240025, "Stimulus Area", VR.kFL, VM.k1, false);
  static const PublicTag kStimulusPresentationTime
      //(0024,0028)
      = const PublicTag("StimulusPresentationTime", 0x00240028,
          "Stimulus Presentation Time", VR.kFL, VM.k1, false);
  static const PublicTag kFixationSequence
      //(0024,0032)
      = const PublicTag(
          "FixationSequence", 0x00240032, "Fixation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFixationMonitoringCodeSequence
      //(0024,0033)
      = const PublicTag("FixationMonitoringCodeSequence", 0x00240033,
          "Fixation Monitoring Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualFieldCatchTrialSequence
      //(0024,0034)
      = const PublicTag("VisualFieldCatchTrialSequence", 0x00240034,
          "Visual Field Catch Trial Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFixationCheckedQuantity
      //(0024,0035)
      = const PublicTag("FixationCheckedQuantity", 0x00240035,
          "Fixation Checked Quantity", VR.kUS, VM.k1, false);
  static const PublicTag kPatientNotProperlyFixatedQuantity
      //(0024,0036)
      = const PublicTag("PatientNotProperlyFixatedQuantity", 0x00240036,
          "Patient Not Properly Fixated Quantity", VR.kUS, VM.k1, false);
  static const PublicTag kPresentedVisualStimuliDataFlag
      //(0024,0037)
      = const PublicTag("PresentedVisualStimuliDataFlag", 0x00240037,
          "Presented Visual Stimuli Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfVisualStimuli
      //(0024,0038)
      = const PublicTag("NumberOfVisualStimuli", 0x00240038, "Number of Visual Stimuli",
          VR.kUS, VM.k1, false);
  static const PublicTag kExcessiveFixationLossesDataFlag
      //(0024,0039)
      = const PublicTag("ExcessiveFixationLossesDataFlag", 0x00240039,
          "Excessive Fixation Losses Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kExcessiveFixationLosses
      //(0024,0040)
      = const PublicTag("ExcessiveFixationLosses", 0x00240040,
          "Excessive Fixation Losses", VR.kCS, VM.k1, false);
  static const PublicTag kStimuliRetestingQuantity
      //(0024,0042)
      = const PublicTag("StimuliRetestingQuantity", 0x00240042,
          "Stimuli Retesting Quantity", VR.kUS, VM.k1, false);
  static const PublicTag kCommentsOnPatientPerformanceOfVisualField
      //(0024,0044)
      = const PublicTag("CommentsOnPatientPerformanceOfVisualField", 0x00240044,
          "Comments on Patient's Performance of Visual Field", VR.kLT, VM.k1, false);
  static const PublicTag kFalseNegativesEstimateFlag
      //(0024,0045)
      = const PublicTag("FalseNegativesEstimateFlag", 0x00240045,
          "False Negatives Estimate Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFalseNegativesEstimate
      //(0024,0046)
      = const PublicTag("FalseNegativesEstimate", 0x00240046, "False Negatives Estimate",
          VR.kFL, VM.k1, false);
  static const PublicTag kNegativeCatchTrialsQuantity
      //(0024,0048)
      = const PublicTag("NegativeCatchTrialsQuantity", 0x00240048,
          "Negative Catch Trials Quantity", VR.kUS, VM.k1, false);
  static const PublicTag kFalseNegativesQuantity
      //(0024,0050)
      = const PublicTag("FalseNegativesQuantity", 0x00240050, "False Negatives Quantity",
          VR.kUS, VM.k1, false);
  static const PublicTag kExcessiveFalseNegativesDataFlag
      //(0024,0051)
      = const PublicTag("ExcessiveFalseNegativesDataFlag", 0x00240051,
          "Excessive False Negatives Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kExcessiveFalseNegatives
      //(0024,0052)
      = const PublicTag("ExcessiveFalseNegatives", 0x00240052,
          "Excessive False Negatives", VR.kCS, VM.k1, false);
  static const PublicTag kFalsePositivesEstimateFlag
      //(0024,0053)
      = const PublicTag("FalsePositivesEstimateFlag", 0x00240053,
          "False Positives Estimate Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFalsePositivesEstimate
      //(0024,0054)
      = const PublicTag("FalsePositivesEstimate", 0x00240054, "False Positives Estimate",
          VR.kFL, VM.k1, false);
  static const PublicTag kCatchTrialsDataFlag
      //(0024,0055)
      = const PublicTag("CatchTrialsDataFlag", 0x00240055, "Catch Trials Data Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kPositiveCatchTrialsQuantity
      //(0024,0056)
      = const PublicTag("PositiveCatchTrialsQuantity", 0x00240056,
          "Positive Catch Trials Quantity", VR.kUS, VM.k1, false);
  static const PublicTag kTestPointNormalsDataFlag
      //(0024,0057)
      = const PublicTag("TestPointNormalsDataFlag", 0x00240057,
          "Test Point Normals Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kTestPointNormalsSequence
      //(0024,0058)
      = const PublicTag("TestPointNormalsSequence", 0x00240058,
          "Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGlobalDeviationProbabilityNormalsFlag
      //(0024,0059)
      = const PublicTag("GlobalDeviationProbabilityNormalsFlag", 0x00240059,
          "Global Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFalsePositivesQuantity
      //(0024,0060)
      = const PublicTag("FalsePositivesQuantity", 0x00240060, "False Positives Quantity",
          VR.kUS, VM.k1, false);
  static const PublicTag kExcessiveFalsePositivesDataFlag
      //(0024,0061)
      = const PublicTag("ExcessiveFalsePositivesDataFlag", 0x00240061,
          "Excessive False Positives Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kExcessiveFalsePositives
      //(0024,0062)
      = const PublicTag("ExcessiveFalsePositives", 0x00240062,
          "Excessive False Positives", VR.kCS, VM.k1, false);
  static const PublicTag kVisualFieldTestNormalsFlag
      //(0024,0063)
      = const PublicTag("VisualFieldTestNormalsFlag", 0x00240063,
          "Visual Field Test Normals Flag", VR.kCS, VM.k1, false);
  static const PublicTag kResultsNormalsSequence
      //(0024,0064)
      = const PublicTag("ResultsNormalsSequence", 0x00240064, "Results Normals Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kAgeCorrectedSensitivityDeviationAlgorithmSequence
      //(0024,0065)
      = const PublicTag("AgeCorrectedSensitivityDeviationAlgorithmSequence", 0x00240065,
          "Age Corrected Sensitivity Deviation Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGlobalDeviationFromNormal
      //(0024,0066)
      = const PublicTag("GlobalDeviationFromNormal", 0x00240066,
          "Global Deviation From Normal", VR.kFL, VM.k1, false);
  static const PublicTag kGeneralizedDefectSensitivityDeviationAlgorithmSequence
      //(0024,0067)
      = const PublicTag(
          "GeneralizedDefectSensitivityDeviationAlgorithmSequence",
          0x00240067,
          "Generalized Defect Sensitivity Deviation Algorithm Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kLocalizedDeviationFromNormal
      //(0024,0068)
      = const PublicTag("LocalizedDeviationFromNormal", 0x00240068,
          "Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const PublicTag kPatientReliabilityIndicator
      //(0024,0069)
      = const PublicTag("PatientReliabilityIndicator", 0x00240069,
          "Patient Reliability Indicator", VR.kLO, VM.k1, false);
  static const PublicTag kVisualFieldMeanSensitivity
      //(0024,0070)
      = const PublicTag("VisualFieldMeanSensitivity", 0x00240070,
          "Visual Field Mean Sensitivity", VR.kFL, VM.k1, false);
  static const PublicTag kGlobalDeviationProbability
      //(0024,0071)
      = const PublicTag("GlobalDeviationProbability", 0x00240071,
          "Global Deviation Probability", VR.kFL, VM.k1, false);
  static const PublicTag kLocalDeviationProbabilityNormalsFlag
      //(0024,0072)
      = const PublicTag("LocalDeviationProbabilityNormalsFlag", 0x00240072,
          "Local Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const PublicTag kLocalizedDeviationProbability
      //(0024,0073)
      = const PublicTag("LocalizedDeviationProbability", 0x00240073,
          "Localized Deviation Probability", VR.kFL, VM.k1, false);
  static const PublicTag kShortTermFluctuationCalculated
      //(0024,0074)
      = const PublicTag("ShortTermFluctuationCalculated", 0x00240074,
          "Short Term Fluctuation Calculated", VR.kCS, VM.k1, false);
  static const PublicTag kShortTermFluctuation
      //(0024,0075)
      = const PublicTag("ShortTermFluctuation", 0x00240075, "Short Term Fluctuation",
          VR.kFL, VM.k1, false);
  static const PublicTag kShortTermFluctuationProbabilityCalculated
      //(0024,0076)
      = const PublicTag("ShortTermFluctuationProbabilityCalculated", 0x00240076,
          "Short Term Fluctuation Probability Calculated", VR.kCS, VM.k1, false);
  static const PublicTag kShortTermFluctuationProbability
      //(0024,0077)
      = const PublicTag("ShortTermFluctuationProbability", 0x00240077,
          "Short Term Fluctuation Probability", VR.kFL, VM.k1, false);
  static const PublicTag kCorrectedLocalizedDeviationFromNormalCalculated
      //(0024,0078)
      = const PublicTag("CorrectedLocalizedDeviationFromNormalCalculated", 0x00240078,
          "Corrected Localized Deviation From Normal Calculated", VR.kCS, VM.k1, false);
  static const PublicTag kCorrectedLocalizedDeviationFromNormal
      //(0024,0079)
      = const PublicTag("CorrectedLocalizedDeviationFromNormal", 0x00240079,
          "Corrected Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const PublicTag kCorrectedLocalizedDeviationFromNormalProbabilityCalculated
      //(0024,0080)
      = const PublicTag(
          "CorrectedLocalizedDeviationFromNormalProbabilityCalculated",
          0x00240080,
          "Corrected Localized Deviation From Normal Probability Calculated",
          VR.kCS,
          VM.k1,
          false);
  static const PublicTag kCorrectedLocalizedDeviationFromNormalProbability
      //(0024,0081)
      = const PublicTag("CorrectedLocalizedDeviationFromNormalProbability", 0x00240081,
          "Corrected Localized Deviation From Normal Probability", VR.kFL, VM.k1, false);
  static const PublicTag kGlobalDeviationProbabilitySequence
      //(0024,0083)
      = const PublicTag("GlobalDeviationProbabilitySequence", 0x00240083,
          "Global Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLocalizedDeviationProbabilitySequence
      //(0024,0085)
      = const PublicTag("LocalizedDeviationProbabilitySequence", 0x00240085,
          "Localized Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFovealSensitivityMeasured
      //(0024,0086)
      = const PublicTag("FovealSensitivityMeasured", 0x00240086,
          "Foveal Sensitivity Measured", VR.kCS, VM.k1, false);
  static const PublicTag kFovealSensitivity
      //(0024,0087)
      = const PublicTag(
          "FovealSensitivity", 0x00240087, "Foveal Sensitivity", VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldTestDuration
      //(0024,0088)
      = const PublicTag("VisualFieldTestDuration", 0x00240088,
          "Visual Field Test Duration", VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldTestPointSequence
      //(0024,0089)
      = const PublicTag("VisualFieldTestPointSequence", 0x00240089,
          "Visual Field Test Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualFieldTestPointXCoordinate
      //(0024,0090)
      = const PublicTag("VisualFieldTestPointXCoordinate", 0x00240090,
          "Visual Field Test Point X-Coordinate", VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldTestPointYCoordinate
      //(0024,0091)
      = const PublicTag("VisualFieldTestPointYCoordinate", 0x00240091,
          "Visual Field Test Point Y-Coordinate", VR.kFL, VM.k1, false);
  static const PublicTag kAgeCorrectedSensitivityDeviationValue
      //(0024,0092)
      = const PublicTag("AgeCorrectedSensitivityDeviationValue", 0x00240092,
          "Age Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const PublicTag kStimulusResults
      //(0024,0093)
      = const PublicTag(
          "StimulusResults", 0x00240093, "Stimulus Results", VR.kCS, VM.k1, false);
  static const PublicTag kSensitivityValue
      //(0024,0094)
      = const PublicTag(
          "SensitivityValue", 0x00240094, "Sensitivity Value", VR.kFL, VM.k1, false);
  static const PublicTag kRetestStimulusSeen
      //(0024,0095)
      = const PublicTag(
          "RetestStimulusSeen", 0x00240095, "Retest Stimulus Seen", VR.kCS, VM.k1, false);
  static const PublicTag kRetestSensitivityValue
      //(0024,0096)
      = const PublicTag("RetestSensitivityValue", 0x00240096, "Retest Sensitivity Value",
          VR.kFL, VM.k1, false);
  static const PublicTag kVisualFieldTestPointNormalsSequence
      //(0024,0097)
      = const PublicTag("VisualFieldTestPointNormalsSequence", 0x00240097,
          "Visual Field Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kQuantifiedDefect
      //(0024,0098)
      = const PublicTag(
          "QuantifiedDefect", 0x00240098, "Quantified Defect", VR.kFL, VM.k1, false);
  static const PublicTag kAgeCorrectedSensitivityDeviationProbabilityValue
      //(0024,0100)
      = const PublicTag("AgeCorrectedSensitivityDeviationProbabilityValue", 0x00240100,
          "Age Corrected Sensitivity Deviation Probability Value", VR.kFL, VM.k1, false);
  static const PublicTag kGeneralizedDefectCorrectedSensitivityDeviationFlag
      //(0024,0102)
      = const PublicTag(
          "GeneralizedDefectCorrectedSensitivityDeviationFlag",
          0x00240102,
          "Generalized Defect Corrected Sensitivity Deviation Flag",
          VR.kCS,
          VM.k1,
          false);
  static const PublicTag kGeneralizedDefectCorrectedSensitivityDeviationValue
      //(0024,0103)
      = const PublicTag(
          "GeneralizedDefectCorrectedSensitivityDeviationValue",
          0x00240103,
          "Generalized Defect Corrected Sensitivity Deviation Value",
          VR.kFL,
          VM.k1,
          false);
  static const PublicTag kGeneralizedDefectCorrectedSensitivityDeviationProbabilityValue
      //(0024,0104)
      = const PublicTag(
          "GeneralizedDefectCorrectedSensitivityDeviationProbabilityValue",
          0x00240104,
          "Generalized Defect Corrected Sensitivity Deviation Probability Value",
          VR.kFL,
          VM.k1,
          false);
  static const PublicTag kMinimumSensitivityValue
      //(0024,0105)
      = const PublicTag("MinimumSensitivityValue", 0x00240105,
          "Minimum Sensitivity Value", VR.kFL, VM.k1, false);
  static const PublicTag kBlindSpotLocalized
      //(0024,0106)
      = const PublicTag(
          "BlindSpotLocalized", 0x00240106, "Blind Spot Localized", VR.kCS, VM.k1, false);
  static const PublicTag kBlindSpotXCoordinate
      //(0024,0107)
      = const PublicTag("BlindSpotXCoordinate", 0x00240107, "Blind Spot X-Coordinate",
          VR.kFL, VM.k1, false);
  static const PublicTag kBlindSpotYCoordinate
      //(0024,0108)
      = const PublicTag("BlindSpotYCoordinate", 0x00240108, "Blind Spot Y-Coordinate",
          VR.kFL, VM.k1, false);
  static const PublicTag kVisualAcuityMeasurementSequence
      //(0024,0110)
      = const PublicTag("VisualAcuityMeasurementSequence", 0x00240110,
          "Visual Acuity Measurement Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRefractiveParametersUsedOnPatientSequence
      //(0024,0112)
      = const PublicTag("RefractiveParametersUsedOnPatientSequence", 0x00240112,
          "Refractive Parameters Used on Patient Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMeasurementLaterality
      //(0024,0113)
      = const PublicTag("MeasurementLaterality", 0x00240113, "Measurement Laterality",
          VR.kCS, VM.k1, false);
  static const PublicTag kOphthalmicPatientClinicalInformationLeftEyeSequence
      //(0024,0114)
      = const PublicTag(
          "OphthalmicPatientClinicalInformationLeftEyeSequence",
          0x00240114,
          "Ophthalmic Patient Clinical Information Left Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kOphthalmicPatientClinicalInformationRightEyeSequence
      //(0024,0115)
      = const PublicTag(
          "OphthalmicPatientClinicalInformationRightEyeSequence",
          0x00240115,
          "Ophthalmic Patient Clinical Information Right Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kFovealPointNormativeDataFlag
      //(0024,0117)
      = const PublicTag("FovealPointNormativeDataFlag", 0x00240117,
          "Foveal Point Normative Data Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFovealPointProbabilityValue
      //(0024,0118)
      = const PublicTag("FovealPointProbabilityValue", 0x00240118,
          "Foveal Point Probability Value", VR.kFL, VM.k1, false);
  static const PublicTag kScreeningBaselineMeasured
      //(0024,0120)
      = const PublicTag("ScreeningBaselineMeasured", 0x00240120,
          "Screening Baseline Measured", VR.kCS, VM.k1, false);
  static const PublicTag kScreeningBaselineMeasuredSequence
      //(0024,0122)
      = const PublicTag("ScreeningBaselineMeasuredSequence", 0x00240122,
          "Screening Baseline Measured Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScreeningBaselineType
      //(0024,0124)
      = const PublicTag("ScreeningBaselineType", 0x00240124, "Screening Baseline Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kScreeningBaselineValue
      //(0024,0126)
      = const PublicTag("ScreeningBaselineValue", 0x00240126, "Screening Baseline Value",
          VR.kFL, VM.k1, false);
  static const PublicTag kAlgorithmSource
      //(0024,0202)
      = const PublicTag(
          "AlgorithmSource", 0x00240202, "Algorithm Source", VR.kLO, VM.k1, false);
  static const PublicTag kDataSetName
      //(0024,0306)
      = const PublicTag("DataSetName", 0x00240306, "Data Set Name", VR.kLO, VM.k1, false);
  static const PublicTag kDataSetVersion
      //(0024,0307)
      = const PublicTag(
          "DataSetVersion", 0x00240307, "Data Set Version", VR.kLO, VM.k1, false);
  static const PublicTag kDataSetSource
      //(0024,0308)
      = const PublicTag(
          "DataSetSource", 0x00240308, "Data Set Source", VR.kLO, VM.k1, false);
  static const PublicTag kDataSetDescription
      //(0024,0309)
      = const PublicTag(
          "DataSetDescription", 0x00240309, "Data Set Description", VR.kLO, VM.k1, false);
  static const PublicTag kVisualFieldTestReliabilityGlobalIndexSequence
      //(0024,0317)
      = const PublicTag("VisualFieldTestReliabilityGlobalIndexSequence", 0x00240317,
          "Visual Field Test Reliability Global Index Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualFieldGlobalResultsIndexSequence
      //(0024,0320)
      = const PublicTag("VisualFieldGlobalResultsIndexSequence", 0x00240320,
          "Visual Field Global Results Index Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDataObservationSequence
      //(0024,0325)
      = const PublicTag("DataObservationSequence", 0x00240325,
          "Data Observation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIndexNormalsFlag
      //(0024,0338)
      = const PublicTag(
          "IndexNormalsFlag", 0x00240338, "Index Normals Flag", VR.kCS, VM.k1, false);
  static const PublicTag kIndexProbability
      //(0024,0341)
      = const PublicTag(
          "IndexProbability", 0x00240341, "Index Probability", VR.kFL, VM.k1, false);
  static const PublicTag kIndexProbabilitySequence
      //(0024,0344)
      = const PublicTag("IndexProbabilitySequence", 0x00240344,
          "Index Probability Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSamplesPerPixel
      //(0028,0002)
      = const PublicTag(
          "SamplesPerPixel", 0x00280002, "Samples per Pixel", VR.kUS, VM.k1, false);
  static const PublicTag kSamplesPerPixelUsed
      //(0028,0003)
      = const PublicTag("SamplesPerPixelUsed", 0x00280003, "Samples per Pixel Used",
          VR.kUS, VM.k1, false);
  static const PublicTag kPhotometricInterpretation
      //(0028,0004)
      = const PublicTag("PhotometricInterpretation", 0x00280004,
          "Photometric Interpretation", VR.kCS, VM.k1, false);
  static const PublicTag kImageDimensions
      //(0028,0005)
      = const PublicTag(
          "ImageDimensions", 0x00280005, "Image Dimensions", VR.kUS, VM.k1, true);
  static const PublicTag kPlanarConfiguration
      //(0028,0006)
      = const PublicTag("PlanarConfiguration", 0x00280006, "Planar Configuration", VR.kUS,
          VM.k1, false);
  static const PublicTag kNumberOfFrames
      //(0028,0008)
      = const PublicTag(
          "NumberOfFrames", 0x00280008, "Number of Frames", VR.kIS, VM.k1, false);
  static const PublicTag kFrameIncrementPointer
      //(0028,0009)
      = const PublicTag("FrameIncrementPointer", 0x00280009, "Frame Increment Pointer",
          VR.kAT, VM.k1_n, false);
  static const PublicTag kFrameDimensionPointer
      //(0028,000A)
      = const PublicTag("FrameDimensionPointer", 0x0028000A, "Frame Dimension Pointer",
          VR.kAT, VM.k1_n, false);
  static const PublicTag kRows
      //(0028,0010)
      = const PublicTag("Rows", 0x00280010, "Rows", VR.kUS, VM.k1, false);
  static const PublicTag kColumns
      //(0028,0011)
      = const PublicTag("Columns", 0x00280011, "Columns", VR.kUS, VM.k1, false);
  static const PublicTag kPlanes
      //(0028,0012)
      = const PublicTag("Planes", 0x00280012, "Planes", VR.kUS, VM.k1, true);
  static const PublicTag kUltrasoundColorDataPresent
      //(0028,0014)
      = const PublicTag("UltrasoundColorDataPresent", 0x00280014,
          "Ultrasound Color Data Present", VR.kUS, VM.k1, false);
  static const PublicTag kNoName1
      //(0028,0020)
      = const PublicTag("NoName1", 0x00280020, "See Note 3", VR.kUnknown, VM.kNoVM, true);
  static const PublicTag kPixelSpacing
      //(0028,0030)
      =
      const PublicTag("PixelSpacing", 0x00280030, "Pixel Spacing", VR.kDS, VM.k2, false);
  static const PublicTag kZoomFactor
      //(0028,0031)
      = const PublicTag("ZoomFactor", 0x00280031, "Zoom Factor", VR.kDS, VM.k2, false);
  static const PublicTag kZoomCenter
      //(0028,0032)
      = const PublicTag("ZoomCenter", 0x00280032, "Zoom Center", VR.kDS, VM.k2, false);
  static const PublicTag kPixelAspectRatio
      //(0028,0034)
      = const PublicTag(
          "PixelAspectRatio", 0x00280034, "Pixel Aspect Ratio", VR.kIS, VM.k2, false);
  static const PublicTag kImageFormat
      //(0028,0040)
      = const PublicTag("ImageFormat", 0x00280040, "Image Format", VR.kCS, VM.k1, true);
  static const PublicTag kManipulatedImage
      //(0028,0050)
      = const PublicTag(
          "ManipulatedImage", 0x00280050, "Manipulated Image", VR.kLO, VM.k1_n, true);
  static const PublicTag kCorrectedImage
      //(0028,0051)
      = const PublicTag(
          "CorrectedImage", 0x00280051, "Corrected Image", VR.kCS, VM.k1_n, false);
  static const PublicTag kCompressionRecognitionCode
      //(0028,005F)
      = const PublicTag("CompressionRecognitionCode", 0x0028005F,
          "Compression Recognition Code", VR.kLO, VM.k1, true);
  static const PublicTag kCompressionCode
      //(0028,0060)
      = const PublicTag(
          "CompressionCode", 0x00280060, "Compression Code", VR.kCS, VM.k1, true);
  static const PublicTag kCompressionOriginator
      //(0028,0061)
      = const PublicTag("CompressionOriginator", 0x00280061, "Compression Originator",
          VR.kSH, VM.k1, true);
  static const PublicTag kCompressionLabel
      //(0028,0062)
      = const PublicTag(
          "CompressionLabel", 0x00280062, "Compression Label", VR.kLO, VM.k1, true);
  static const PublicTag kCompressionDescription
      //(0028,0063)
      = const PublicTag("CompressionDescription", 0x00280063, "Compression Description",
          VR.kSH, VM.k1, true);
  static const PublicTag kCompressionSequence
      //(0028,0065)
      = const PublicTag("CompressionSequence", 0x00280065, "Compression Sequence", VR.kCS,
          VM.k1_n, true);
  static const PublicTag kCompressionStepPointers
      //(0028,0066)
      = const PublicTag("CompressionStepPointers", 0x00280066,
          "Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const PublicTag kRepeatInterval
      //(0028,0068)
      = const PublicTag(
          "RepeatInterval", 0x00280068, "Repeat Interval", VR.kUS, VM.k1, true);
  static const PublicTag kBitsGrouped
      //(0028,0069)
      = const PublicTag("BitsGrouped", 0x00280069, "Bits Grouped", VR.kUS, VM.k1, true);
  static const PublicTag kPerimeterTable
      //(0028,0070)
      = const PublicTag(
          "PerimeterTable", 0x00280070, "Perimeter Table", VR.kUS, VM.k1_n, true);
  static const PublicTag kPerimeterValue
      //(0028,0071)
      = const PublicTag(
          "PerimeterValue", 0x00280071, "Perimeter Value", VR.kUSSS, VM.k1, true);
  static const PublicTag kPredictorRows
      //(0028,0080)
      =
      const PublicTag("PredictorRows", 0x00280080, "Predictor Rows", VR.kUS, VM.k1, true);
  static const PublicTag kPredictorColumns
      //(0028,0081)
      = const PublicTag(
          "PredictorColumns", 0x00280081, "Predictor Columns", VR.kUS, VM.k1, true);
  static const PublicTag kPredictorConstants
      //(0028,0082)
      = const PublicTag(
          "PredictorConstants", 0x00280082, "Predictor Constants", VR.kUS, VM.k1_n, true);
  static const PublicTag kBlockedPixels
      //(0028,0090)
      =
      const PublicTag("BlockedPixels", 0x00280090, "Blocked Pixels", VR.kCS, VM.k1, true);
  static const PublicTag kBlockRows
      //(0028,0091)
      = const PublicTag("BlockRows", 0x00280091, "Block Rows", VR.kUS, VM.k1, true);
  static const PublicTag kBlockColumns
      //(0028,0092)
      = const PublicTag("BlockColumns", 0x00280092, "Block Columns", VR.kUS, VM.k1, true);
  static const PublicTag kRowOverlap
      //(0028,0093)
      = const PublicTag("RowOverlap", 0x00280093, "Row Overlap", VR.kUS, VM.k1, true);
  static const PublicTag kColumnOverlap
      //(0028,0094)
      =
      const PublicTag("ColumnOverlap", 0x00280094, "Column Overlap", VR.kUS, VM.k1, true);
  static const PublicTag kBitsAllocated
      //(0028,0100)
      = const PublicTag(
          "BitsAllocated", 0x00280100, "Bits Allocated", VR.kUS, VM.k1, false);
  static const PublicTag kBitsStored
      //(0028,0101)
      = const PublicTag("BitsStored", 0x00280101, "Bits Stored", VR.kUS, VM.k1, false);
  static const PublicTag kHighBit
      //(0028,0102)
      = const PublicTag("HighBit", 0x00280102, "High Bit", VR.kUS, VM.k1, false);
  static const PublicTag kPixelRepresentation
      //(0028,0103)
      = const PublicTag("PixelRepresentation", 0x00280103, "Pixel Representation", VR.kUS,
          VM.k1, false);
  static const PublicTag kSmallestValidPixelValue
      //(0028,0104)
      = const PublicTag("SmallestValidPixelValue", 0x00280104,
          "Smallest Valid Pixel Value", VR.kUSSS, VM.k1, true);
  static const PublicTag kLargestValidPixelValue
      //(0028,0105)
      = const PublicTag("LargestValidPixelValue", 0x00280105, "Largest Valid Pixel Value",
          VR.kUSSS, VM.k1, true);
  static const PublicTag kSmallestImagePixelValue
      //(0028,0106)
      = const PublicTag("SmallestImagePixelValue", 0x00280106,
          "Smallest Image Pixel Value", VR.kUSSS, VM.k1, false);
  static const PublicTag kLargestImagePixelValue
      //(0028,0107)
      = const PublicTag("LargestImagePixelValue", 0x00280107, "Largest Image Pixel Value",
          VR.kUSSS, VM.k1, false);
  static const PublicTag kSmallestPixelValueInSeries
      //(0028,0108)
      = const PublicTag("SmallestPixelValueInSeries", 0x00280108,
          "Smallest Pixel Value in Series", VR.kUSSS, VM.k1, false);
  static const PublicTag kLargestPixelValueInSeries
      //(0028,0109)
      = const PublicTag("LargestPixelValueInSeries", 0x00280109,
          "Largest Pixel Value in Series", VR.kUSSS, VM.k1, false);
  static const PublicTag kSmallestImagePixelValueInPlane
      //(0028,0110)
      = const PublicTag("SmallestImagePixelValueInPlane", 0x00280110,
          "Smallest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const PublicTag kLargestImagePixelValueInPlane
      //(0028,0111)
      = const PublicTag("LargestImagePixelValueInPlane", 0x00280111,
          "Largest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const PublicTag kPixelPaddingValue
      //(0028,0120)
      = const PublicTag(
          "PixelPaddingValue", 0x00280120, "Pixel Padding Value", VR.kUSSS, VM.k1, false);
  static const PublicTag kPixelPaddingRangeLimit
      //(0028,0121)
      = const PublicTag("PixelPaddingRangeLimit", 0x00280121, "Pixel Padding Range Limit",
          VR.kUSSS, VM.k1, false);
  static const PublicTag kImageLocation
      //(0028,0200)
      =
      const PublicTag("ImageLocation", 0x00280200, "Image Location", VR.kUS, VM.k1, true);
  static const PublicTag kQualityControlImage
      //(0028,0300)
      = const PublicTag("QualityControlImage", 0x00280300, "Quality Control Image",
          VR.kCS, VM.k1, false);
  static const PublicTag kBurnedInAnnotation
      //(0028,0301)
      = const PublicTag(
          "BurnedInAnnotation", 0x00280301, "Burned In Annotation", VR.kCS, VM.k1, false);
  static const PublicTag kRecognizableVisualFeatures
      //(0028,0302)
      = const PublicTag("RecognizableVisualFeatures", 0x00280302,
          "Recognizable Visual Features", VR.kCS, VM.k1, false);
  static const PublicTag kLongitudinalTemporalInformationModified
      //(0028,0303)
      = const PublicTag("LongitudinalTemporalInformationModified", 0x00280303,
          "Longitudinal Temporal Information Modified", VR.kCS, VM.k1, false);
  static const PublicTag kReferencedColorPaletteInstanceUID
      //(0028,0304)
      = const PublicTag("ReferencedColorPaletteInstanceUID", 0x00280304,
          "Referenced Color Palette Instance UID", VR.kUI, VM.k1, false);
  static const PublicTag kTransformLabel
      //(0028,0400)
      = const PublicTag(
          "TransformLabel", 0x00280400, "Transform Label", VR.kLO, VM.k1, true);
  static const PublicTag kTransformVersionNumber
      //(0028,0401)
      = const PublicTag("TransformVersionNumber", 0x00280401, "Transform Version Number",
          VR.kLO, VM.k1, true);
  static const PublicTag kNumberOfTransformSteps
      //(0028,0402)
      = const PublicTag("NumberOfTransformSteps", 0x00280402, "Number of Transform Steps",
          VR.kUS, VM.k1, true);
  static const PublicTag kSequenceOfCompressedData
      //(0028,0403)
      = const PublicTag("SequenceOfCompressedData", 0x00280403,
          "Sequence of Compressed Data", VR.kLO, VM.k1_n, true);
  static const PublicTag kDetailsOfCoefficients
      //(0028,0404)
      = const PublicTag("DetailsOfCoefficients", 0x00280404, "Details of Coefficients",
          VR.kAT, VM.k1_n, true);

  // *** See below ***
  //static const Tag Element kRowsForNthOrderCoefficients
  //(0028,0400)
  //= const Element("RowsForNthOrderCoefficients", 0x00280400, "Rows For Nth Order Coefficients",
  //VR.kUS, VM.k1, true);
  // *** See below ***
  //static const Tag Element kColumnsForNthOrderCoefficients
  //(0028,0401)
  //= const Element("ColumnsForNthOrderCoefficients", 0x00280401, "Columns For Nth Order
  //Coefficients", VR.kUS, VM.k1, true);
  //static const Tag Element kCoefficientCoding
  //(0028,0402)
  //= const Element("CoefficientCoding", 0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);
  //static const Tag Element kCoefficientCodingPointers
  //(0028,0403)
  //= const Element("CoefficientCodingPointers", 0x00280403, "Coefficient Coding Pointers", VR
  //    .kAT, VM.k1_n, true);
  static const PublicTag kDCTLabel
      //(0028,0700)
      = const PublicTag("DCTLabel", 0x00280700, "DCT Label", VR.kLO, VM.k1, true);
  static const PublicTag kDataBlockDescription
      //(0028,0701)
      = const PublicTag("DataBlockDescription", 0x00280701, "Data Block Description",
          VR.kCS, VM.k1_n, true);
  static const PublicTag kDataBlock
      //(0028,0702)
      = const PublicTag("DataBlock", 0x00280702, "Data Block", VR.kAT, VM.k1_n, true);
  static const PublicTag kNormalizationFactorFormat
      //(0028,0710)
      = const PublicTag("NormalizationFactorFormat", 0x00280710,
          "Normalization Factor Format", VR.kUS, VM.k1, true);
  static const PublicTag kZonalMapNumberFormat
      //(0028,0720)
      = const PublicTag("ZonalMapNumberFormat", 0x00280720, "Zonal Map Number Format",
          VR.kUS, VM.k1, true);
  static const PublicTag kZonalMapLocation
      //(0028,0721)
      = const PublicTag(
          "ZonalMapLocation", 0x00280721, "Zonal Map Location", VR.kAT, VM.k1_n, true);
  static const PublicTag kZonalMapFormat
      //(0028,0722)
      = const PublicTag(
          "ZonalMapFormat", 0x00280722, "Zonal Map Format", VR.kUS, VM.k1, true);
  static const PublicTag kAdaptiveMapFormat
      //(0028,0730)
      = const PublicTag(
          "AdaptiveMapFormat", 0x00280730, "Adaptive Map Format", VR.kUS, VM.k1, true);
  static const PublicTag kCodeNumberFormat
      //(0028,0740)
      = const PublicTag(
          "CodeNumberFormat", 0x00280740, "Code Number Format", VR.kUS, VM.k1, true);
  static const PublicTag kCodeLabel
      //(0028,0800)
      = const PublicTag("CodeLabel", 0x00280800, "Code Label", VR.kCS, VM.k1_n, true);
  static const PublicTag kNumberOfTables
      //(0028,0802)
      = const PublicTag(
          "NumberOfTables", 0x00280802, "Number of Tables", VR.kUS, VM.k1, true);
  static const PublicTag kCodeTableLocation
      //(0028,0803)
      = const PublicTag(
          "CodeTableLocation", 0x00280803, "Code Table Location", VR.kAT, VM.k1_n, true);
  static const PublicTag kBitsForCodeWord
      //(0028,0804)
      = const PublicTag(
          "BitsForCodeWord", 0x00280804, "Bits For Code Word", VR.kUS, VM.k1, true);
  static const PublicTag kImageDataLocation
      //(0028,0808)
      = const PublicTag(
          "ImageDataLocation", 0x00280808, "Image Data Location", VR.kAT, VM.k1_n, true);
  static const PublicTag kPixelSpacingCalibrationType
      //(0028,0A02)
      = const PublicTag("PixelSpacingCalibrationType", 0x00280A02,
          "Pixel Spacing Calibration Type", VR.kCS, VM.k1, false);
  static const PublicTag kPixelSpacingCalibrationDescription
      //(0028,0A04)
      = const PublicTag("PixelSpacingCalibrationDescription", 0x00280A04,
          "Pixel Spacing Calibration Description", VR.kLO, VM.k1, false);
  static const PublicTag kPixelIntensityRelationship
      //(0028,1040)
      = const PublicTag("PixelIntensityRelationship", 0x00281040,
          "Pixel Intensity Relationship", VR.kCS, VM.k1, false);
  static const PublicTag kPixelIntensityRelationshipSign
      //(0028,1041)
      = const PublicTag("PixelIntensityRelationshipSign", 0x00281041,
          "Pixel Intensity Relationship Sign", VR.kSS, VM.k1, false);
  static const PublicTag kWindowCenter
      //(0028,1050)
      = const PublicTag(
          "WindowCenter", 0x00281050, "Window Center", VR.kDS, VM.k1_n, false);
  static const PublicTag kWindowWidth
      //(0028,1051)
      =
      const PublicTag("WindowWidth", 0x00281051, "Window Width", VR.kDS, VM.k1_n, false);
  static const PublicTag kRescaleIntercept
      //(0028,1052)
      = const PublicTag(
          "RescaleIntercept", 0x00281052, "Rescale Intercept", VR.kDS, VM.k1, false);
  static const PublicTag kRescaleSlope
      //(0028,1053)
      =
      const PublicTag("RescaleSlope", 0x00281053, "Rescale Slope", VR.kDS, VM.k1, false);
  static const PublicTag kRescaleType
      //(0028,1054)
      = const PublicTag("RescaleType", 0x00281054, "Rescale Type", VR.kLO, VM.k1, false);
  static const PublicTag kWindowCenterWidthExplanation
      //(0028,1055)
      = const PublicTag("WindowCenterWidthExplanation", 0x00281055,
          "Window Center & Width Explanation", VR.kLO, VM.k1_n, false);
  static const PublicTag kVOILUTFunction
      //(0028,1056)
      = const PublicTag(
          "VOILUTFunction", 0x00281056, "VOI LUT Function", VR.kCS, VM.k1, false);
  static const PublicTag kGrayScale
      //(0028,1080)
      = const PublicTag("GrayScale", 0x00281080, "Gray Scale", VR.kCS, VM.k1, true);
  static const PublicTag kRecommendedViewingMode
      //(0028,1090)
      = const PublicTag("RecommendedViewingMode", 0x00281090, "Recommended Viewing Mode",
          VR.kCS, VM.k1, false);
  static const PublicTag kGrayLookupTableDescriptor
      //(0028,1100)
      = const PublicTag("GrayLookupTableDescriptor", 0x00281100,
          "Gray Lookup Table Descriptor", VR.kUSSS, VM.k3, true);
  static const PublicTag kRedPaletteColorLookupTableDescriptor
      //(0028,1101)
      = const PublicTag("RedPaletteColorLookupTableDescriptor", 0x00281101,
          "Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const PublicTag kGreenPaletteColorLookupTableDescriptor
      //(0028,1102)
      = const PublicTag("GreenPaletteColorLookupTableDescriptor", 0x00281102,
          "Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const PublicTag kBluePaletteColorLookupTableDescriptor
      //(0028,1103)
      = const PublicTag("BluePaletteColorLookupTableDescriptor", 0x00281103,
          "Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const PublicTag kAlphaPaletteColorLookupTableDescriptor
      //(0028,1104)
      = const PublicTag("AlphaPaletteColorLookupTableDescriptor", 0x00281104,
          "AlphaPalette ColorLookup Table Descriptor", VR.kUS, VM.k3, false);
  static const PublicTag kLargeRedPaletteColorLookupTableDescriptor
      //(0028,1111)
      = const PublicTag("LargeRedPaletteColorLookupTableDescriptor", 0x00281111,
          "Large Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const PublicTag kLargeGreenPaletteColorLookupTableDescriptor
      //(0028,1112)
      = const PublicTag("LargeGreenPaletteColorLookupTableDescriptor", 0x00281112,
          "Large Green Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const PublicTag kLargeBluePaletteColorLookupTableDescriptor
      //(0028,1113)
      = const PublicTag("LargeBluePaletteColorLookupTableDescriptor", 0x00281113,
          "Large Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k4, true);
  static const PublicTag kPaletteColorLookupTableUID
      //(0028,1199)
      = const PublicTag("PaletteColorLookupTableUID", 0x00281199,
          "Palette Color Lookup Table UID", VR.kUI, VM.k1, false);
  static const PublicTag kGrayLookupTableData
      //(0028,1200)
      = const PublicTag("GrayLookupTableData", 0x00281200, "Gray Lookup Table Data",
          VR.kUSSSOW, VM.k1_n, true);
  static const PublicTag kRedPaletteColorLookupTableData
      //(0028,1201)
      = const PublicTag("RedPaletteColorLookupTableData", 0x00281201,
          "Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kGreenPaletteColorLookupTableData
      //(0028,1202)
      = const PublicTag("GreenPaletteColorLookupTableData", 0x00281202,
          "Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kBluePaletteColorLookupTableData
      //(0028,1203)
      = const PublicTag("BluePaletteColorLookupTableData", 0x00281203,
          "Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kAlphaPaletteColorLookupTableData
      //(0028,1204)
      = const PublicTag("AlphaPaletteColorLookupTableData", 0x00281204,
          "Alpha Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kLargeRedPaletteColorLookupTableData
      //(0028,1211)
      = const PublicTag("LargeRedPaletteColorLookupTableData", 0x00281211,
          "Large Red Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const PublicTag kLargeGreenPaletteColorLookupTableData
      //(0028,1212)
      = const PublicTag("LargeGreenPaletteColorLookupTableData", 0x00281212,
          "Large Green Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const PublicTag kLargeBluePaletteColorLookupTableData
      //(0028,1213)
      = const PublicTag("LargeBluePaletteColorLookupTableData", 0x00281213,
          "Large Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const PublicTag kLargePaletteColorLookupTableUID
      //(0028,1214)
      = const PublicTag("LargePaletteColorLookupTableUID", 0x00281214,
          "Large Palette Color Lookup Table UID", VR.kUI, VM.k1, true);
  static const PublicTag kSegmentedRedPaletteColorLookupTableData
      //(0028,1221)
      = const PublicTag("SegmentedRedPaletteColorLookupTableData", 0x00281221,
          "Segmented Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kSegmentedGreenPaletteColorLookupTableData
      //(0028,1222)
      = const PublicTag("SegmentedGreenPaletteColorLookupTableData", 0x00281222,
          "Segmented Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kSegmentedBluePaletteColorLookupTableData
      //(0028,1223)
      = const PublicTag("SegmentedBluePaletteColorLookupTableData", 0x00281223,
          "Segmented Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kBreastImplantPresent
      //(0028,1300)
      = const PublicTag("BreastImplantPresent", 0x00281300, "Breast Implant Present",
          VR.kCS, VM.k1, false);
  static const PublicTag kPartialView
      //(0028,1350)
      = const PublicTag("PartialView", 0x00281350, "Partial View", VR.kCS, VM.k1, false);
  static const PublicTag kPartialViewDescription
      //(0028,1351)
      = const PublicTag("PartialViewDescription", 0x00281351, "Partial View Description",
          VR.kST, VM.k1, false);
  static const PublicTag kPartialViewCodeSequence
      //(0028,1352)
      = const PublicTag("PartialViewCodeSequence", 0x00281352,
          "Partial View Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpatialLocationsPreserved
      //(0028,135A)
      = const PublicTag("SpatialLocationsPreserved", 0x0028135A,
          "Spatial Locations Preserved", VR.kCS, VM.k1, false);
  static const PublicTag kDataFrameAssignmentSequence
      //(0028,1401)
      = const PublicTag("DataFrameAssignmentSequence", 0x00281401,
          "Data Frame Assignment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDataPathAssignment
      //(0028,1402)
      = const PublicTag(
          "DataPathAssignment", 0x00281402, "Data Path Assignment", VR.kCS, VM.k1, false);
  static const PublicTag kBitsMappedToColorLookupTable
      //(0028,1403)
      = const PublicTag("BitsMappedToColorLookupTable", 0x00281403,
          "Bits Mapped to Color Lookup Table", VR.kUS, VM.k1, false);
  static const PublicTag kBlendingLUT1Sequence
      //(0028,1404)
      = const PublicTag("BlendingLUT1Sequence", 0x00281404, "Blending LUT 1 Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kBlendingLUT1TransferFunction
      //(0028,1405)
      = const PublicTag("BlendingLUT1TransferFunction", 0x00281405,
          "Blending LUT 1 Transfer Function", VR.kCS, VM.k1, false);
  static const PublicTag kBlendingWeightConstant
      //(0028,1406)
      = const PublicTag("BlendingWeightConstant", 0x00281406, "Blending Weight Constant",
          VR.kFD, VM.k1, false);
  static const PublicTag kBlendingLookupTableDescriptor
      //(0028,1407)
      = const PublicTag("BlendingLookupTableDescriptor", 0x00281407,
          "Blending Lookup Table Descriptor", VR.kUS, VM.k3, false);
  static const PublicTag kBlendingLookupTableData
      //(0028,1408)
      = const PublicTag("BlendingLookupTableData", 0x00281408,
          "Blending Lookup Table Data", VR.kOW, VM.k1, false);
  static const PublicTag kEnhancedPaletteColorLookupTableSequence
      //(0028,140B)
      = const PublicTag("EnhancedPaletteColorLookupTableSequence", 0x0028140B,
          "Enhanced Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBlendingLUT2Sequence
      //(0028,140C)
      = const PublicTag("BlendingLUT2Sequence", 0x0028140C, "Blending LUT 2 Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kBlendingLUT2TransferFunction
      //(0028,140D)
      = const PublicTag("BlendingLUT2TransferFunction", 0x0028140D,
          "Blending LUT 2 Transfer Function", VR.kCS, VM.k1, false);
  static const PublicTag kDataPathID
      //(0028,140E)
      = const PublicTag("DataPathID", 0x0028140E, "Data Path ID", VR.kCS, VM.k1, false);
  static const PublicTag kRGBLUTTransferFunction
      //(0028,140F)
      = const PublicTag("RGBLUTTransferFunction", 0x0028140F, "RGB LUT Transfer Function",
          VR.kCS, VM.k1, false);
  static const PublicTag kAlphaLUTTransferFunction
      //(0028,1410)
      = const PublicTag("AlphaLUTTransferFunction", 0x00281410,
          "Alpha LUT Transfer Function", VR.kCS, VM.k1, false);
  static const PublicTag kICCProfile
      //(0028,2000)
      = const PublicTag("ICCProfile", 0x00282000, "ICC Profile", VR.kOB, VM.k1, false);
  static const PublicTag kLossyImageCompression
      //(0028,2110)
      = const PublicTag("LossyImageCompression", 0x00282110, "Lossy Image Compression",
          VR.kCS, VM.k1, false);
  static const PublicTag kLossyImageCompressionRatio
      //(0028,2112)
      = const PublicTag("LossyImageCompressionRatio", 0x00282112,
          "Lossy Image Compression Ratio", VR.kDS, VM.k1_n, false);
  static const PublicTag kLossyImageCompressionMethod
      //(0028,2114)
      = const PublicTag("LossyImageCompressionMethod", 0x00282114,
          "Lossy Image Compression Method", VR.kCS, VM.k1_n, false);
  static const PublicTag kModalityLUTSequence
      //(0028,3000)
      = const PublicTag("ModalityLUTSequence", 0x00283000, "Modality LUT Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kLUTDescriptor
      //(0028,3002)
      = const PublicTag(
          "LUTDescriptor", 0x00283002, "LUT Descriptor", VR.kUSSS, VM.k3, false);
  static const PublicTag kLUTExplanation
      //(0028,3003)
      = const PublicTag(
          "LUTExplanation", 0x00283003, "LUT Explanation", VR.kLO, VM.k1, false);
  static const PublicTag kModalityLUTType
      //(0028,3004)
      = const PublicTag(
          "ModalityLUTType", 0x00283004, "Modality LUT Type", VR.kLO, VM.k1, false);
  static const PublicTag kLUTData
      //(0028,3006)
      = const PublicTag("LUTData", 0x00283006, "LUT Data", VR.kUSOW, VM.k1_n, false);
  static const PublicTag kVOILUTSequence
      //(0028,3010)
      = const PublicTag(
          "VOILUTSequence", 0x00283010, "VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSoftcopyVOILUTSequence
      //(0028,3110)
      = const PublicTag("SoftcopyVOILUTSequence", 0x00283110, "Softcopy VOI LUT Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kImagePresentationComments
      //(0028,4000)
      = const PublicTag("ImagePresentationComments", 0x00284000,
          "Image Presentation Comments", VR.kLT, VM.k1, true);
  static const PublicTag kBiPlaneAcquisitionSequence
      //(0028,5000)
      = const PublicTag("BiPlaneAcquisitionSequence", 0x00285000,
          "Bi-Plane Acquisition Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kRepresentativeFrameNumber
      //(0028,6010)
      = const PublicTag("RepresentativeFrameNumber", 0x00286010,
          "Representative Frame Number", VR.kUS, VM.k1, false);
  static const PublicTag kFrameNumbersOfInterest
      //(0028,6020)
      = const PublicTag("FrameNumbersOfInterest", 0x00286020,
          "Frame Numbers of Interest (FOI)", VR.kUS, VM.k1_n, false);
  static const PublicTag kFrameOfInterestDescription
      //(0028,6022)
      = const PublicTag("FrameOfInterestDescription", 0x00286022,
          "Frame of Interest Description", VR.kLO, VM.k1_n, false);
  static const PublicTag kFrameOfInterestType
      //(0028,6023)
      = const PublicTag("FrameOfInterestType", 0x00286023, "Frame of Interest Type",
          VR.kCS, VM.k1_n, false);
  static const PublicTag kMaskPointers
      //(0028,6030)
      = const PublicTag(
          "MaskPointers", 0x00286030, "Mask Pointer(s)", VR.kUS, VM.k1_n, true);
  static const PublicTag kRWavePointer
      //(0028,6040)
      = const PublicTag(
          "RWavePointer", 0x00286040, "R Wave Pointer", VR.kUS, VM.k1_n, false);
  static const PublicTag kMaskSubtractionSequence
      //(0028,6100)
      = const PublicTag("MaskSubtractionSequence", 0x00286100,
          "Mask Subtraction Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMaskOperation
      //(0028,6101)
      = const PublicTag(
          "MaskOperation", 0x00286101, "Mask Operation", VR.kCS, VM.k1, false);
  static const PublicTag kApplicableFrameRange
      //(0028,6102)
      = const PublicTag("ApplicableFrameRange", 0x00286102, "Applicable Frame Range",
          VR.kUS, VM.k2_2n, false);
  static const PublicTag kMaskFrameNumbers
      //(0028,6110)
      = const PublicTag(
          "MaskFrameNumbers", 0x00286110, "Mask Frame Numbers", VR.kUS, VM.k1_n, false);
  static const PublicTag kContrastFrameAveraging
      //(0028,6112)
      = const PublicTag("ContrastFrameAveraging", 0x00286112, "Contrast Frame Averaging",
          VR.kUS, VM.k1, false);
  static const PublicTag kMaskSubPixelShift
      //(0028,6114)
      = const PublicTag(
          "MaskSubPixelShift", 0x00286114, "Mask Sub-pixel Shift", VR.kFL, VM.k2, false);
  static const PublicTag kTIDOffset
      //(0028,6120)
      = const PublicTag("TIDOffset", 0x00286120, "TID Offset", VR.kSS, VM.k1, false);
  static const PublicTag kMaskOperationExplanation
      //(0028,6190)
      = const PublicTag("MaskOperationExplanation", 0x00286190,
          "Mask Operation Explanation", VR.kST, VM.k1, false);
  static const PublicTag kPixelDataProviderURL
      //(0028,7FE0)
      = const PublicTag("PixelDataProviderURL", 0x00287FE0, "Pixel Data Provider URL",
          VR.kUT, VM.k1, false);
  static const PublicTag kDataPointRows
      //(0028,9001)
      = const PublicTag(
          "DataPointRows", 0x00289001, "Data Point Rows", VR.kUL, VM.k1, false);
  static const PublicTag kDataPointColumns
      //(0028,9002)
      = const PublicTag(
          "DataPointColumns", 0x00289002, "Data Point Columns", VR.kUL, VM.k1, false);
  static const PublicTag kSignalDomainColumns
      //(0028,9003)
      = const PublicTag("SignalDomainColumns", 0x00289003, "Signal Domain Columns",
          VR.kCS, VM.k1, false);
  static const PublicTag kLargestMonochromePixelValue
      //(0028,9099)
      = const PublicTag("LargestMonochromePixelValue", 0x00289099,
          "Largest Monochrome Pixel Value", VR.kUS, VM.k1, true);
  static const PublicTag kDataRepresentation
      //(0028,9108)
      = const PublicTag(
          "DataRepresentation", 0x00289108, "Data Representation", VR.kCS, VM.k1, false);
  static const PublicTag kPixelMeasuresSequence
      //(0028,9110)
      = const PublicTag("PixelMeasuresSequence", 0x00289110, "Pixel Measures Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFrameVOILUTSequence
      //(0028,9132)
      = const PublicTag("FrameVOILUTSequence", 0x00289132, "Frame VOI LUT Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPixelValueTransformationSequence
      //(0028,9145)
      = const PublicTag("PixelValueTransformationSequence", 0x00289145,
          "Pixel Value Transformation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSignalDomainRows
      //(0028,9235)
      = const PublicTag(
          "SignalDomainRows", 0x00289235, "Signal Domain Rows", VR.kCS, VM.k1, false);
  static const PublicTag kDisplayFilterPercentage
      //(0028,9411)
      = const PublicTag("DisplayFilterPercentage", 0x00289411,
          "Display Filter Percentage", VR.kFL, VM.k1, false);
  static const PublicTag kFramePixelShiftSequence
      //(0028,9415)
      = const PublicTag("FramePixelShiftSequence", 0x00289415,
          "Frame Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSubtractionItemID
      //(0028,9416)
      = const PublicTag(
          "SubtractionItemID", 0x00289416, "Subtraction Item ID", VR.kUS, VM.k1, false);
  static const PublicTag kPixelIntensityRelationshipLUTSequence
      //(0028,9422)
      = const PublicTag("PixelIntensityRelationshipLUTSequence", 0x00289422,
          "Pixel Intensity Relationship LUT Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFramePixelDataPropertiesSequence
      //(0028,9443)
      = const PublicTag("FramePixelDataPropertiesSequence", 0x00289443,
          "Frame Pixel Data Properties Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGeometricalProperties
      //(0028,9444)
      = const PublicTag("GeometricalProperties", 0x00289444, "Geometrical Properties",
          VR.kCS, VM.k1, false);
  static const PublicTag kGeometricMaximumDistortion
      //(0028,9445)
      = const PublicTag("GeometricMaximumDistortion", 0x00289445,
          "Geometric Maximum Distortion", VR.kFL, VM.k1, false);
  static const PublicTag kImageProcessingApplied
      //(0028,9446)
      = const PublicTag("ImageProcessingApplied", 0x00289446, "Image Processing Applied",
          VR.kCS, VM.k1_n, false);
  static const PublicTag kMaskSelectionMode
      //(0028,9454)
      = const PublicTag(
          "MaskSelectionMode", 0x00289454, "Mask Selection Mode", VR.kCS, VM.k1, false);
  static const PublicTag kLUTFunction
      //(0028,9474)
      = const PublicTag("LUTFunction", 0x00289474, "LUT Function", VR.kCS, VM.k1, false);
  static const PublicTag kMaskVisibilityPercentage
      //(0028,9478)
      = const PublicTag("MaskVisibilityPercentage", 0x00289478,
          "Mask Visibility Percentage", VR.kFL, VM.k1, false);
  static const PublicTag kPixelShiftSequence
      //(0028,9501)
      = const PublicTag(
          "PixelShiftSequence", 0x00289501, "Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRegionPixelShiftSequence
      //(0028,9502)
      = const PublicTag("RegionPixelShiftSequence", 0x00289502,
          "Region Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVerticesOfTheRegion
      //(0028,9503)
      = const PublicTag("VerticesOfTheRegion", 0x00289503, "Vertices of the Region",
          VR.kSS, VM.k2_2n, false);
  static const PublicTag kMultiFramePresentationSequence
      //(0028,9505)
      = const PublicTag("MultiFramePresentationSequence", 0x00289505,
          "Multi-frame Presentation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPixelShiftFrameRange
      //(0028,9506)
      = const PublicTag("PixelShiftFrameRange", 0x00289506, "Pixel Shift Frame Range",
          VR.kUS, VM.k2_2n, false);
  static const PublicTag kLUTFrameRange
      //(0028,9507)
      = const PublicTag(
          "LUTFrameRange", 0x00289507, "LUT Frame Range", VR.kUS, VM.k2_2n, false);
  static const PublicTag kImageToEquipmentMappingMatrix
      //(0028,9520)
      = const PublicTag("ImageToEquipmentMappingMatrix", 0x00289520,
          "Image to Equipment Mapping Matrix", VR.kDS, VM.k16, false);
  static const PublicTag kEquipmentCoordinateSystemIdentification
      //(0028,9537)
      = const PublicTag("EquipmentCoordinateSystemIdentification", 0x00289537,
          "Equipment Coordinate System Identification", VR.kCS, VM.k1, false);
  static const PublicTag kStudyStatusID
      //(0032,000A)
      = const PublicTag(
          "StudyStatusID", 0x0032000A, "Study Status ID", VR.kCS, VM.k1, true);
  static const PublicTag kStudyPriorityID
      //(0032,000C)
      = const PublicTag(
          "StudyPriorityID", 0x0032000C, "Study Priority ID", VR.kCS, VM.k1, true);
  static const PublicTag kStudyIDIssuer
      //(0032,0012)
      = const PublicTag(
          "StudyIDIssuer", 0x00320012, "Study ID Issuer", VR.kLO, VM.k1, true);
  static const PublicTag kStudyVerifiedDate
      //(0032,0032)
      = const PublicTag(
          "StudyVerifiedDate", 0x00320032, "Study Verified Date", VR.kDA, VM.k1, true);
  static const PublicTag kStudyVerifiedTime
      //(0032,0033)
      = const PublicTag(
          "StudyVerifiedTime", 0x00320033, "Study Verified Time", VR.kTM, VM.k1, true);
  static const PublicTag kStudyReadDate
      //(0032,0034)
      = const PublicTag(
          "StudyReadDate", 0x00320034, "Study Read Date", VR.kDA, VM.k1, true);
  static const PublicTag kStudyReadTime
      //(0032,0035)
      = const PublicTag(
          "StudyReadTime", 0x00320035, "Study Read Time", VR.kTM, VM.k1, true);
  static const PublicTag kScheduledStudyStartDate
      //(0032,1000)
      = const PublicTag("ScheduledStudyStartDate", 0x00321000,
          "Scheduled Study Start Date", VR.kDA, VM.k1, true);
  static const PublicTag kScheduledStudyStartTime
      //(0032,1001)
      = const PublicTag("ScheduledStudyStartTime", 0x00321001,
          "Scheduled Study Start Time", VR.kTM, VM.k1, true);
  static const PublicTag kScheduledStudyStopDate
      //(0032,1010)
      = const PublicTag("ScheduledStudyStopDate", 0x00321010, "Scheduled Study Stop Date",
          VR.kDA, VM.k1, true);
  static const PublicTag kScheduledStudyStopTime
      //(0032,1011)
      = const PublicTag("ScheduledStudyStopTime", 0x00321011, "Scheduled Study Stop Time",
          VR.kTM, VM.k1, true);
  static const PublicTag kScheduledStudyLocation
      //(0032,1020)
      = const PublicTag("ScheduledStudyLocation", 0x00321020, "Scheduled Study Location",
          VR.kLO, VM.k1, true);
  static const PublicTag kScheduledStudyLocationAETitle
      //(0032,1021)
      = const PublicTag("ScheduledStudyLocationAETitle", 0x00321021,
          "Scheduled Study Location AE Title", VR.kAE, VM.k1_n, true);
  static const PublicTag kReasonForStudy
      //(0032,1030)
      = const PublicTag(
          "ReasonForStudy", 0x00321030, "Reason for Study", VR.kLO, VM.k1, true);
  static const PublicTag kRequestingPhysicianIdentificationSequence
      //(0032,1031)
      = const PublicTag("RequestingPhysicianIdentificationSequence", 0x00321031,
          "Requesting Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRequestingPhysician
      //(0032,1032)
      = const PublicTag("RequestingPhysician", 0x00321032, "Requesting Physician", VR.kPN,
          VM.k1, false);
  static const PublicTag kRequestingService
      //(0032,1033)
      = const PublicTag(
          "RequestingService", 0x00321033, "Requesting Service", VR.kLO, VM.k1, false);
  static const PublicTag kRequestingServiceCodeSequence
      //(0032,1034)
      = const PublicTag("RequestingServiceCodeSequence", 0x00321034,
          "Requesting Service Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStudyArrivalDate
      //(0032,1040)
      = const PublicTag(
          "StudyArrivalDate", 0x00321040, "Study Arrival Date", VR.kDA, VM.k1, true);
  static const PublicTag kStudyArrivalTime
      //(0032,1041)
      = const PublicTag(
          "StudyArrivalTime", 0x00321041, "Study Arrival Time", VR.kTM, VM.k1, true);
  static const PublicTag kStudyCompletionDate
      //(0032,1050)
      = const PublicTag("StudyCompletionDate", 0x00321050, "Study Completion Date",
          VR.kDA, VM.k1, true);
  static const PublicTag kStudyCompletionTime
      //(0032,1051)
      = const PublicTag("StudyCompletionTime", 0x00321051, "Study Completion Time",
          VR.kTM, VM.k1, true);
  static const PublicTag kStudyComponentStatusID
      //(0032,1055)
      = const PublicTag("StudyComponentStatusID", 0x00321055, "Study Component Status ID",
          VR.kCS, VM.k1, true);
  static const PublicTag kRequestedProcedureDescription
      //(0032,1060)
      = const PublicTag("RequestedProcedureDescription", 0x00321060,
          "Requested Procedure Description", VR.kLO, VM.k1, false);
  static const PublicTag kRequestedProcedureCodeSequence
      //(0032,1064)
      = const PublicTag("RequestedProcedureCodeSequence", 0x00321064,
          "Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRequestedContrastAgent
      //(0032,1070)
      = const PublicTag("RequestedContrastAgent", 0x00321070, "Requested Contrast Agent",
          VR.kLO, VM.k1, false);
  static const PublicTag kStudyComments
      //(0032,4000)
      =
      const PublicTag("StudyComments", 0x00324000, "Study Comments", VR.kLT, VM.k1, true);
  static const PublicTag kReferencedPatientAliasSequence
      //(0038,0004)
      = const PublicTag("ReferencedPatientAliasSequence", 0x00380004,
          "Referenced Patient Alias Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisitStatusID
      //(0038,0008)
      = const PublicTag(
          "VisitStatusID", 0x00380008, "Visit Status ID", VR.kCS, VM.k1, false);
  static const PublicTag kAdmissionID
      //(0038,0010)
      = const PublicTag("AdmissionID", 0x00380010, "Admission ID", VR.kLO, VM.k1, false);
  static const PublicTag kIssuerOfAdmissionID
      //(0038,0011)
      = const PublicTag("IssuerOfAdmissionID", 0x00380011, "Issuer of Admission ID",
          VR.kLO, VM.k1, true);
  static const PublicTag kIssuerOfAdmissionIDSequence
      //(0038,0014)
      = const PublicTag("IssuerOfAdmissionIDSequence", 0x00380014,
          "Issuer of Admission ID Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRouteOfAdmissions
      //(0038,0016)
      = const PublicTag(
          "RouteOfAdmissions", 0x00380016, "Route of Admissions", VR.kLO, VM.k1, false);
  static const PublicTag kScheduledAdmissionDate
      //(0038,001A)
      = const PublicTag("ScheduledAdmissionDate", 0x0038001A, "Scheduled Admission Date",
          VR.kDA, VM.k1, true);
  static const PublicTag kScheduledAdmissionTime
      //(0038,001B)
      = const PublicTag("ScheduledAdmissionTime", 0x0038001B, "Scheduled Admission Time",
          VR.kTM, VM.k1, true);
  static const PublicTag kScheduledDischargeDate
      //(0038,001C)
      = const PublicTag("ScheduledDischargeDate", 0x0038001C, "Scheduled Discharge Date",
          VR.kDA, VM.k1, true);
  static const PublicTag kScheduledDischargeTime
      //(0038,001D)
      = const PublicTag("ScheduledDischargeTime", 0x0038001D, "Scheduled Discharge Time",
          VR.kTM, VM.k1, true);
  static const PublicTag kScheduledPatientInstitutionResidence
      //(0038,001E)
      = const PublicTag("ScheduledPatientInstitutionResidence", 0x0038001E,
          "Scheduled Patient Institution Residence", VR.kLO, VM.k1, true);
  static const PublicTag kAdmittingDate
      //(0038,0020)
      = const PublicTag(
          "AdmittingDate", 0x00380020, "Admitting Date", VR.kDA, VM.k1, false);
  static const PublicTag kAdmittingTime
      //(0038,0021)
      = const PublicTag(
          "AdmittingTime", 0x00380021, "Admitting Time", VR.kTM, VM.k1, false);
  static const PublicTag kDischargeDate
      //(0038,0030)
      =
      const PublicTag("DischargeDate", 0x00380030, "Discharge Date", VR.kDA, VM.k1, true);
  static const PublicTag kDischargeTime
      //(0038,0032)
      =
      const PublicTag("DischargeTime", 0x00380032, "Discharge Time", VR.kTM, VM.k1, true);
  static const PublicTag kDischargeDiagnosisDescription
      //(0038,0040)
      = const PublicTag("DischargeDiagnosisDescription", 0x00380040,
          "Discharge Diagnosis Description", VR.kLO, VM.k1, true);
  static const PublicTag kDischargeDiagnosisCodeSequence
      //(0038,0044)
      = const PublicTag("DischargeDiagnosisCodeSequence", 0x00380044,
          "Discharge Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kSpecialNeeds
      //(0038,0050)
      =
      const PublicTag("SpecialNeeds", 0x00380050, "Special Needs", VR.kLO, VM.k1, false);
  static const PublicTag kServiceEpisodeID
      //(0038,0060)
      = const PublicTag(
          "ServiceEpisodeID", 0x00380060, "Service Episode ID", VR.kLO, VM.k1, false);
  static const PublicTag kIssuerOfServiceEpisodeID
      //(0038,0061)
      = const PublicTag("IssuerOfServiceEpisodeID", 0x00380061,
          "Issuer of Service Episode ID", VR.kLO, VM.k1, true);
  static const PublicTag kServiceEpisodeDescription
      //(0038,0062)
      = const PublicTag("ServiceEpisodeDescription", 0x00380062,
          "Service Episode Description", VR.kLO, VM.k1, false);
  static const PublicTag kIssuerOfServiceEpisodeIDSequence
      //(0038,0064)
      = const PublicTag("IssuerOfServiceEpisodeIDSequence", 0x00380064,
          "Issuer of Service Episode ID Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPertinentDocumentsSequence
      //(0038,0100)
      = const PublicTag("PertinentDocumentsSequence", 0x00380100,
          "Pertinent Documents Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCurrentPatientLocation
      //(0038,0300)
      = const PublicTag("CurrentPatientLocation", 0x00380300, "Current Patient Location",
          VR.kLO, VM.k1, false);
  static const PublicTag kPatientInstitutionResidence
      //(0038,0400)
      = const PublicTag("PatientInstitutionResidence", 0x00380400,
          "Patient's Institution Residence", VR.kLO, VM.k1, false);
  static const PublicTag kPatientState
      //(0038,0500)
      =
      const PublicTag("PatientState", 0x00380500, "Patient State", VR.kLO, VM.k1, false);
  static const PublicTag kPatientClinicalTrialParticipationSequence
      //(0038,0502)
      = const PublicTag("PatientClinicalTrialParticipationSequence", 0x00380502,
          "Patient Clinical Trial Participation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisitComments
      //(0038,4000)
      = const PublicTag(
          "VisitComments", 0x00384000, "Visit Comments", VR.kLT, VM.k1, false);
  static const PublicTag kWaveformOriginality
      //(003A,0004)
      = const PublicTag("WaveformOriginality", 0x003A0004, "Waveform Originality", VR.kCS,
          VM.k1, false);
  static const PublicTag kNumberOfWaveformChannels
      //(003A,0005)
      = const PublicTag("NumberOfWaveformChannels", 0x003A0005,
          "Number of Waveform Channels", VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfWaveformSamples
      //(003A,0010)
      = const PublicTag("NumberOfWaveformSamples", 0x003A0010,
          "Number of Waveform Samples", VR.kUL, VM.k1, false);
  static const PublicTag kSamplingFrequency
      //(003A,001A)
      = const PublicTag(
          "SamplingFrequency", 0x003A001A, "Sampling Frequency", VR.kDS, VM.k1, false);
  static const PublicTag kMultiplexGroupLabel
      //(003A,0020)
      = const PublicTag("MultiplexGroupLabel", 0x003A0020, "Multiplex Group Label",
          VR.kSH, VM.k1, false);
  static const PublicTag kChannelDefinitionSequence
      //(003A,0200)
      = const PublicTag("ChannelDefinitionSequence", 0x003A0200,
          "Channel Definition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kWaveformChannelNumber
      //(003A,0202)
      = const PublicTag("WaveformChannelNumber", 0x003A0202, "Waveform Channel Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kChannelLabel
      //(003A,0203)
      =
      const PublicTag("ChannelLabel", 0x003A0203, "Channel Label", VR.kSH, VM.k1, false);
  static const PublicTag kChannelStatus
      //(003A,0205)
      = const PublicTag(
          "ChannelStatus", 0x003A0205, "Channel Status", VR.kCS, VM.k1_n, false);
  static const PublicTag kChannelSourceSequence
      //(003A,0208)
      = const PublicTag("ChannelSourceSequence", 0x003A0208, "Channel Source Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kChannelSourceModifiersSequence
      //(003A,0209)
      = const PublicTag("ChannelSourceModifiersSequence", 0x003A0209,
          "Channel Source Modifiers Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceWaveformSequence
      //(003A,020A)
      = const PublicTag("SourceWaveformSequence", 0x003A020A, "Source Waveform Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kChannelDerivationDescription
      //(003A,020C)
      = const PublicTag("ChannelDerivationDescription", 0x003A020C,
          "Channel Derivation Description", VR.kLO, VM.k1, false);
  static const PublicTag kChannelSensitivity
      //(003A,0210)
      = const PublicTag(
          "ChannelSensitivity", 0x003A0210, "Channel Sensitivity", VR.kDS, VM.k1, false);
  static const PublicTag kChannelSensitivityUnitsSequence
      //(003A,0211)
      = const PublicTag("ChannelSensitivityUnitsSequence", 0x003A0211,
          "Channel Sensitivity Units Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelSensitivityCorrectionFactor
      //(003A,0212)
      = const PublicTag("ChannelSensitivityCorrectionFactor", 0x003A0212,
          "Channel Sensitivity Correction Factor", VR.kDS, VM.k1, false);
  static const PublicTag kChannelBaseline
      //(003A,0213)
      = const PublicTag(
          "ChannelBaseline", 0x003A0213, "Channel Baseline", VR.kDS, VM.k1, false);
  static const PublicTag kChannelTimeSkew
      //(003A,0214)
      = const PublicTag(
          "ChannelTimeSkew", 0x003A0214, "Channel Time Skew", VR.kDS, VM.k1, false);
  static const PublicTag kChannelSampleSkew
      //(003A,0215)
      = const PublicTag(
          "ChannelSampleSkew", 0x003A0215, "Channel Sample Skew", VR.kDS, VM.k1, false);
  static const PublicTag kChannelOffset
      //(003A,0218)
      = const PublicTag(
          "ChannelOffset", 0x003A0218, "Channel Offset", VR.kDS, VM.k1, false);
  static const PublicTag kWaveformBitsStored
      //(003A,021A)
      = const PublicTag(
          "WaveformBitsStored", 0x003A021A, "Waveform Bits Stored", VR.kUS, VM.k1, false);
  static const PublicTag kFilterLowFrequency
      //(003A,0220)
      = const PublicTag(
          "FilterLowFrequency", 0x003A0220, "Filter Low Frequency", VR.kDS, VM.k1, false);
  static const PublicTag kFilterHighFrequency
      //(003A,0221)
      = const PublicTag("FilterHighFrequency", 0x003A0221, "Filter High Frequency",
          VR.kDS, VM.k1, false);
  static const PublicTag kNotchFilterFrequency
      //(003A,0222)
      = const PublicTag("NotchFilterFrequency", 0x003A0222, "Notch Filter Frequency",
          VR.kDS, VM.k1, false);
  static const PublicTag kNotchFilterBandwidth
      //(003A,0223)
      = const PublicTag("NotchFilterBandwidth", 0x003A0223, "Notch Filter Bandwidth",
          VR.kDS, VM.k1, false);
  static const PublicTag kWaveformDataDisplayScale
      //(003A,0230)
      = const PublicTag("WaveformDataDisplayScale", 0x003A0230,
          "Waveform Data Display Scale", VR.kFL, VM.k1, false);
  static const PublicTag kWaveformDisplayBackgroundCIELabValue
      //(003A,0231)
      = const PublicTag("WaveformDisplayBackgroundCIELabValue", 0x003A0231,
          "Waveform Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kWaveformPresentationGroupSequence
      //(003A,0240)
      = const PublicTag("WaveformPresentationGroupSequence", 0x003A0240,
          "Waveform Presentation Group Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPresentationGroupNumber
      //(003A,0241)
      = const PublicTag("PresentationGroupNumber", 0x003A0241,
          "Presentation Group Number", VR.kUS, VM.k1, false);
  static const PublicTag kChannelDisplaySequence
      //(003A,0242)
      = const PublicTag("ChannelDisplaySequence", 0x003A0242, "Channel Display Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kChannelRecommendedDisplayCIELabValue
      //(003A,0244)
      = const PublicTag("ChannelRecommendedDisplayCIELabValue", 0x003A0244,
          "Channel Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kChannelPosition
      //(003A,0245)
      = const PublicTag(
          "ChannelPosition", 0x003A0245, "Channel Position", VR.kFL, VM.k1, false);
  static const PublicTag kDisplayShadingFlag
      //(003A,0246)
      = const PublicTag(
          "DisplayShadingFlag", 0x003A0246, "Display Shading Flag", VR.kCS, VM.k1, false);
  static const PublicTag kFractionalChannelDisplayScale
      //(003A,0247)
      = const PublicTag("FractionalChannelDisplayScale", 0x003A0247,
          "Fractional Channel Display Scale", VR.kFL, VM.k1, false);
  static const PublicTag kAbsoluteChannelDisplayScale
      //(003A,0248)
      = const PublicTag("AbsoluteChannelDisplayScale", 0x003A0248,
          "Absolute Channel Display Scale", VR.kFL, VM.k1, false);
  static const PublicTag kMultiplexedAudioChannelsDescriptionCodeSequence
      //(003A,0300)
      = const PublicTag("MultiplexedAudioChannelsDescriptionCodeSequence", 0x003A0300,
          "Multiplexed Audio Channels Description Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelIdentificationCode
      //(003A,0301)
      = const PublicTag("ChannelIdentificationCode", 0x003A0301,
          "Channel Identification Code", VR.kIS, VM.k1, false);
  static const PublicTag kChannelMode
      //(003A,0302)
      = const PublicTag("ChannelMode", 0x003A0302, "Channel Mode", VR.kCS, VM.k1, false);
  static const PublicTag kScheduledStationAETitle
      //(0040,0001)
      = const PublicTag("ScheduledStationAETitle", 0x00400001,
          "Scheduled Station AE Title", VR.kAE, VM.k1_n, false);
  static const PublicTag kScheduledProcedureStepStartDate
      //(0040,0002)
      = const PublicTag("ScheduledProcedureStepStartDate", 0x00400002,
          "Scheduled Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const PublicTag kScheduledProcedureStepStartTime
      //(0040,0003)
      = const PublicTag("ScheduledProcedureStepStartTime", 0x00400003,
          "Scheduled Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const PublicTag kScheduledProcedureStepEndDate
      //(0040,0004)
      = const PublicTag("ScheduledProcedureStepEndDate", 0x00400004,
          "Scheduled Procedure Step End Date", VR.kDA, VM.k1, false);
  static const PublicTag kScheduledProcedureStepEndTime
      //(0040,0005)
      = const PublicTag("ScheduledProcedureStepEndTime", 0x00400005,
          "Scheduled Procedure Step End Time", VR.kTM, VM.k1, false);
  static const PublicTag kScheduledPerformingPhysicianName
      //(0040,0006)
      = const PublicTag("ScheduledPerformingPhysicianName", 0x00400006,
          "Scheduled Performing Physician's Name", VR.kPN, VM.k1, false);
  static const PublicTag kScheduledProcedureStepDescription
      //(0040,0007)
      = const PublicTag("ScheduledProcedureStepDescription", 0x00400007,
          "Scheduled Procedure Step Description", VR.kLO, VM.k1, false);
  static const PublicTag kScheduledProtocolCodeSequence
      //(0040,0008)
      = const PublicTag("ScheduledProtocolCodeSequence", 0x00400008,
          "Scheduled Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledProcedureStepID
      //(0040,0009)
      = const PublicTag("ScheduledProcedureStepID", 0x00400009,
          "Scheduled Procedure Step ID", VR.kSH, VM.k1, false);
  static const PublicTag kStageCodeSequence
      //(0040,000A)
      = const PublicTag(
          "StageCodeSequence", 0x0040000A, "Stage Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledPerformingPhysicianIdentificationSequence
      //(0040,000B)
      = const PublicTag("ScheduledPerformingPhysicianIdentificationSequence", 0x0040000B,
          "Scheduled Performing Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledStationName
      //(0040,0010)
      = const PublicTag("ScheduledStationName", 0x00400010, "Scheduled Station Name",
          VR.kSH, VM.k1_n, false);
  static const PublicTag kScheduledProcedureStepLocation
      //(0040,0011)
      = const PublicTag("ScheduledProcedureStepLocation", 0x00400011,
          "Scheduled Procedure Step Location", VR.kSH, VM.k1, false);
  static const PublicTag kPreMedication
      //(0040,0012)
      = const PublicTag(
          "PreMedication", 0x00400012, "Pre-Medication", VR.kLO, VM.k1, false);
  static const PublicTag kScheduledProcedureStepStatus
      //(0040,0020)
      = const PublicTag("ScheduledProcedureStepStatus", 0x00400020,
          "Scheduled Procedure Step Status", VR.kCS, VM.k1, false);
  static const PublicTag kOrderPlacerIdentifierSequence
      //(0040,0026)
      = const PublicTag("OrderPlacerIdentifierSequence", 0x00400026,
          "Order Placer Identifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOrderFillerIdentifierSequence
      //(0040,0027)
      = const PublicTag("OrderFillerIdentifierSequence", 0x00400027,
          "Order Filler Identifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLocalNamespaceEntityID
      //(0040,0031)
      = const PublicTag("LocalNamespaceEntityID", 0x00400031, "Local Namespace Entity ID",
          VR.kUT, VM.k1, false);
  static const PublicTag kUniversalEntityID
      //(0040,0032)
      = const PublicTag(
          "UniversalEntityID", 0x00400032, "Universal Entity ID", VR.kUT, VM.k1, false);
  static const PublicTag kUniversalEntityIDType
      //(0040,0033)
      = const PublicTag("UniversalEntityIDType", 0x00400033, "Universal Entity ID Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kIdentifierTypeCode
      //(0040,0035)
      = const PublicTag(
          "IdentifierTypeCode", 0x00400035, "Identifier Type Code", VR.kCS, VM.k1, false);
  static const PublicTag kAssigningFacilitySequence
      //(0040,0036)
      = const PublicTag("AssigningFacilitySequence", 0x00400036,
          "Assigning Facility Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAssigningJurisdictionCodeSequence
      //(0040,0039)
      = const PublicTag("AssigningJurisdictionCodeSequence", 0x00400039,
          "Assigning Jurisdiction Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAssigningAgencyOrDepartmentCodeSequence
      //(0040,003A)
      = const PublicTag("AssigningAgencyOrDepartmentCodeSequence", 0x0040003A,
          "Assigning Agency or Department Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledProcedureStepSequence
      //(0040,0100)
      = const PublicTag("ScheduledProcedureStepSequence", 0x00400100,
          "Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedNonImageCompositeSOPInstanceSequence
      //(0040,0220)
      = const PublicTag("ReferencedNonImageCompositeSOPInstanceSequence", 0x00400220,
          "Referenced Non-Image Composite SOP Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedStationAETitle
      //(0040,0241)
      = const PublicTag("PerformedStationAETitle", 0x00400241,
          "Performed Station AE Title", VR.kAE, VM.k1, false);
  static const PublicTag kPerformedStationName
      //(0040,0242)
      = const PublicTag("PerformedStationName", 0x00400242, "Performed Station Name",
          VR.kSH, VM.k1, false);
  static const PublicTag kPerformedLocation
      //(0040,0243)
      = const PublicTag(
          "PerformedLocation", 0x00400243, "Performed Location", VR.kSH, VM.k1, false);
  static const PublicTag kPerformedProcedureStepStartDate
      //(0040,0244)
      = const PublicTag("PerformedProcedureStepStartDate", 0x00400244,
          "Performed Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const PublicTag kPerformedProcedureStepStartTime
      //(0040,0245)
      = const PublicTag("PerformedProcedureStepStartTime", 0x00400245,
          "Performed Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const PublicTag kPerformedProcedureStepEndDate
      //(0040,0250)
      = const PublicTag("PerformedProcedureStepEndDate", 0x00400250,
          "Performed Procedure Step End Date", VR.kDA, VM.k1, false);
  static const PublicTag kPerformedProcedureStepEndTime
      //(0040,0251)
      = const PublicTag("PerformedProcedureStepEndTime", 0x00400251,
          "Performed Procedure Step End Time", VR.kTM, VM.k1, false);
  static const PublicTag kPerformedProcedureStepStatus
      //(0040,0252)
      = const PublicTag("PerformedProcedureStepStatus", 0x00400252,
          "Performed Procedure Step Status", VR.kCS, VM.k1, false);
  static const PublicTag kPerformedProcedureStepID
      //(0040,0253)
      = const PublicTag("PerformedProcedureStepID", 0x00400253,
          "Performed Procedure Step ID", VR.kSH, VM.k1, false);
  static const PublicTag kPerformedProcedureStepDescription
      //(0040,0254)
      = const PublicTag("PerformedProcedureStepDescription", 0x00400254,
          "Performed Procedure Step Description", VR.kLO, VM.k1, false);
  static const PublicTag kPerformedProcedureTypeDescription
      //(0040,0255)
      = const PublicTag("PerformedProcedureTypeDescription", 0x00400255,
          "Performed Procedure Type Description", VR.kLO, VM.k1, false);
  static const PublicTag kPerformedProtocolCodeSequence
      //(0040,0260)
      = const PublicTag("PerformedProtocolCodeSequence", 0x00400260,
          "Performed Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedProtocolType
      //(0040,0261)
      = const PublicTag("PerformedProtocolType", 0x00400261, "Performed Protocol Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kScheduledStepAttributesSequence
      //(0040,0270)
      = const PublicTag("ScheduledStepAttributesSequence", 0x00400270,
          "Scheduled Step Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRequestAttributesSequence
      //(0040,0275)
      = const PublicTag("RequestAttributesSequence", 0x00400275,
          "Request Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCommentsOnThePerformedProcedureStep
      //(0040,0280)
      = const PublicTag("CommentsOnThePerformedProcedureStep", 0x00400280,
          "Comments on the Performed Procedure Step", VR.kST, VM.k1, false);
  static const PublicTag kPerformedProcedureStepDiscontinuationReasonCodeSequence
      //(0040,0281)
      = const PublicTag(
          "PerformedProcedureStepDiscontinuationReasonCodeSequence",
          0x00400281,
          "Performed Procedure Step Discontinuation Reason Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kQuantitySequence
      //(0040,0293)
      = const PublicTag(
          "QuantitySequence", 0x00400293, "Quantity Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kQuantity
      //(0040,0294)
      = const PublicTag("Quantity", 0x00400294, "Quantity", VR.kDS, VM.k1, false);
  static const PublicTag kMeasuringUnitsSequence
      //(0040,0295)
      = const PublicTag("MeasuringUnitsSequence", 0x00400295, "Measuring Units Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kBillingItemSequence
      //(0040,0296)
      = const PublicTag("BillingItemSequence", 0x00400296, "Billing Item Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTotalTimeOfFluoroscopy
      //(0040,0300)
      = const PublicTag("TotalTimeOfFluoroscopy", 0x00400300, "Total Time of Fluoroscopy",
          VR.kUS, VM.k1, false);
  static const PublicTag kTotalNumberOfExposures
      //(0040,0301)
      = const PublicTag("TotalNumberOfExposures", 0x00400301, "Total Number of Exposures",
          VR.kUS, VM.k1, false);
  static const PublicTag kEntranceDose
      //(0040,0302)
      =
      const PublicTag("EntranceDose", 0x00400302, "Entrance Dose", VR.kUS, VM.k1, false);
  static const PublicTag kExposedArea
      //(0040,0303)
      =
      const PublicTag("ExposedArea", 0x00400303, "Exposed Area", VR.kUS, VM.k1_2, false);
  static const PublicTag kDistanceSourceToEntrance
      //(0040,0306)
      = const PublicTag("DistanceSourceToEntrance", 0x00400306,
          "Distance Source to Entrance", VR.kDS, VM.k1, false);
  static const PublicTag kDistanceSourceToSupport
      //(0040,0307)
      = const PublicTag("DistanceSourceToSupport", 0x00400307,
          "Distance Source to Support", VR.kDS, VM.k1, true);
  static const PublicTag kExposureDoseSequence
      //(0040,030E)
      = const PublicTag("ExposureDoseSequence", 0x0040030E, "Exposure Dose Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCommentsOnRadiationDose
      //(0040,0310)
      = const PublicTag("CommentsOnRadiationDose", 0x00400310,
          "Comments on Radiation Dose", VR.kST, VM.k1, false);
  static const PublicTag kXRayOutput
      //(0040,0312)
      = const PublicTag("XRayOutput", 0x00400312, "X-Ray Output", VR.kDS, VM.k1, false);
  static const PublicTag kHalfValueLayer
      //(0040,0314)
      = const PublicTag(
          "HalfValueLayer", 0x00400314, "Half Value Layer", VR.kDS, VM.k1, false);
  static const PublicTag kOrganDose
      //(0040,0316)
      = const PublicTag("OrganDose", 0x00400316, "Organ Dose", VR.kDS, VM.k1, false);
  static const PublicTag kOrganExposed
      //(0040,0318)
      =
      const PublicTag("OrganExposed", 0x00400318, "Organ Exposed", VR.kCS, VM.k1, false);
  static const PublicTag kBillingProcedureStepSequence
      //(0040,0320)
      = const PublicTag("BillingProcedureStepSequence", 0x00400320,
          "Billing Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFilmConsumptionSequence
      //(0040,0321)
      = const PublicTag("FilmConsumptionSequence", 0x00400321,
          "Film Consumption Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBillingSuppliesAndDevicesSequence
      //(0040,0324)
      = const PublicTag("BillingSuppliesAndDevicesSequence", 0x00400324,
          "Billing Supplies and Devices Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedProcedureStepSequence
      //(0040,0330)
      = const PublicTag("ReferencedProcedureStepSequence", 0x00400330,
          "Referenced Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kPerformedSeriesSequence
      //(0040,0340)
      = const PublicTag("PerformedSeriesSequence", 0x00400340,
          "Performed Series Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCommentsOnTheScheduledProcedureStep
      //(0040,0400)
      = const PublicTag("CommentsOnTheScheduledProcedureStep", 0x00400400,
          "Comments on the Scheduled Procedure Step", VR.kLT, VM.k1, false);
  static const PublicTag kProtocolContextSequence
      //(0040,0440)
      = const PublicTag("ProtocolContextSequence", 0x00400440,
          "Protocol Context Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContentItemModifierSequence
      //(0040,0441)
      = const PublicTag("ContentItemModifierSequence", 0x00400441,
          "Content Item Modifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledSpecimenSequence
      //(0040,0500)
      = const PublicTag("ScheduledSpecimenSequence", 0x00400500,
          "Scheduled Specimen Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenAccessionNumber
      //(0040,050A)
      = const PublicTag("SpecimenAccessionNumber", 0x0040050A,
          "Specimen Accession Number", VR.kLO, VM.k1, true);
  static const PublicTag kContainerIdentifier
      //(0040,0512)
      = const PublicTag("ContainerIdentifier", 0x00400512, "Container Identifier", VR.kLO,
          VM.k1, false);
  static const PublicTag kIssuerOfTheContainerIdentifierSequence
      //(0040,0513)
      = const PublicTag("IssuerOfTheContainerIdentifierSequence", 0x00400513,
          "Issuer of the Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlternateContainerIdentifierSequence
      //(0040,0515)
      = const PublicTag("AlternateContainerIdentifierSequence", 0x00400515,
          "Alternate Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContainerTypeCodeSequence
      //(0040,0518)
      = const PublicTag("ContainerTypeCodeSequence", 0x00400518,
          "Container Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContainerDescription
      //(0040,051A)
      = const PublicTag("ContainerDescription", 0x0040051A, "Container Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kContainerComponentSequence
      //(0040,0520)
      = const PublicTag("ContainerComponentSequence", 0x00400520,
          "Container Component Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenSequence
      //(0040,0550)
      = const PublicTag(
          "SpecimenSequence", 0x00400550, "Specimen Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kSpecimenIdentifier
      //(0040,0551)
      = const PublicTag(
          "SpecimenIdentifier", 0x00400551, "Specimen Identifier", VR.kLO, VM.k1, false);
  static const PublicTag kSpecimenDescriptionSequenceTrial
      //(0040,0552)
      = const PublicTag("SpecimenDescriptionSequenceTrial", 0x00400552,
          "Specimen Description Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kSpecimenDescriptionTrial
      //(0040,0553)
      = const PublicTag("SpecimenDescriptionTrial", 0x00400553,
          "Specimen Description (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kSpecimenUID
      //(0040,0554)
      = const PublicTag("SpecimenUID", 0x00400554, "Specimen UID", VR.kUI, VM.k1, false);
  static const PublicTag kAcquisitionContextSequence
      //(0040,0555)
      = const PublicTag("AcquisitionContextSequence", 0x00400555,
          "Acquisition Context Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAcquisitionContextDescription
      //(0040,0556)
      = const PublicTag("AcquisitionContextDescription", 0x00400556,
          "Acquisition Context Description", VR.kST, VM.k1, false);
  static const PublicTag kSpecimenTypeCodeSequence
      //(0040,059A)
      = const PublicTag("SpecimenTypeCodeSequence", 0x0040059A,
          "Specimen Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenDescriptionSequence
      //(0040,0560)
      = const PublicTag("SpecimenDescriptionSequence", 0x00400560,
          "Specimen Description Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIssuerOfTheSpecimenIdentifierSequence
      //(0040,0562)
      = const PublicTag("IssuerOfTheSpecimenIdentifierSequence", 0x00400562,
          "Issuer of the Specimen Identifier Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenShortDescription
      //(0040,0600)
      = const PublicTag("SpecimenShortDescription", 0x00400600,
          "Specimen Short Description", VR.kLO, VM.k1, false);
  static const PublicTag kSpecimenDetailedDescription
      //(0040,0602)
      = const PublicTag("SpecimenDetailedDescription", 0x00400602,
          "Specimen Detailed Description", VR.kUT, VM.k1, false);
  static const PublicTag kSpecimenPreparationSequence
      //(0040,0610)
      = const PublicTag("SpecimenPreparationSequence", 0x00400610,
          "Specimen Preparation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenPreparationStepContentItemSequence
      //(0040,0612)
      = const PublicTag("SpecimenPreparationStepContentItemSequence", 0x00400612,
          "Specimen Preparation Step Content Item Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenLocalizationContentItemSequence
      //(0040,0620)
      = const PublicTag("SpecimenLocalizationContentItemSequence", 0x00400620,
          "Specimen Localization Content Item Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSlideIdentifier
      //(0040,06FA)
      = const PublicTag(
          "SlideIdentifier", 0x004006FA, "Slide Identifier", VR.kLO, VM.k1, true);
  static const PublicTag kImageCenterPointCoordinatesSequence
      //(0040,071A)
      = const PublicTag("ImageCenterPointCoordinatesSequence", 0x0040071A,
          "Image Center Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kXOffsetInSlideCoordinateSystem
      //(0040,072A)
      = const PublicTag("XOffsetInSlideCoordinateSystem", 0x0040072A,
          "X Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const PublicTag kYOffsetInSlideCoordinateSystem
      //(0040,073A)
      = const PublicTag("YOffsetInSlideCoordinateSystem", 0x0040073A,
          "Y Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const PublicTag kZOffsetInSlideCoordinateSystem
      //(0040,074A)
      = const PublicTag("ZOffsetInSlideCoordinateSystem", 0x0040074A,
          "Z Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const PublicTag kPixelSpacingSequence
      //(0040,08D8)
      = const PublicTag("PixelSpacingSequence", 0x004008D8, "Pixel Spacing Sequence",
          VR.kSQ, VM.k1, true);
  static const PublicTag kCoordinateSystemAxisCodeSequence
      //(0040,08DA)
      = const PublicTag("CoordinateSystemAxisCodeSequence", 0x004008DA,
          "Coordinate System Axis Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kMeasurementUnitsCodeSequence
      //(0040,08EA)
      = const PublicTag("MeasurementUnitsCodeSequence", 0x004008EA,
          "Measurement Units Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVitalStainCodeSequenceTrial
      //(0040,09F8)
      = const PublicTag("VitalStainCodeSequenceTrial", 0x004009F8,
          "Vital Stain Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kRequestedProcedureID
      //(0040,1001)
      = const PublicTag("RequestedProcedureID", 0x00401001, "Requested Procedure ID",
          VR.kSH, VM.k1, false);
  static const PublicTag kReasonForTheRequestedProcedure
      //(0040,1002)
      = const PublicTag("ReasonForTheRequestedProcedure", 0x00401002,
          "Reason for the Requested Procedure", VR.kLO, VM.k1, false);
  static const PublicTag kRequestedProcedurePriority
      //(0040,1003)
      = const PublicTag("RequestedProcedurePriority", 0x00401003,
          "Requested Procedure Priority", VR.kSH, VM.k1, false);
  static const PublicTag kPatientTransportArrangements
      //(0040,1004)
      = const PublicTag("PatientTransportArrangements", 0x00401004,
          "Patient Transport Arrangements", VR.kLO, VM.k1, false);
  static const PublicTag kRequestedProcedureLocation
      //(0040,1005)
      = const PublicTag("RequestedProcedureLocation", 0x00401005,
          "Requested Procedure Location", VR.kLO, VM.k1, false);
  static const PublicTag kPlacerOrderNumberProcedure
      //(0040,1006)
      = const PublicTag("PlacerOrderNumberProcedure", 0x00401006,
          "Placer Order Number / Procedure", VR.kSH, VM.k1, true);
  static const PublicTag kFillerOrderNumberProcedure
      //(0040,1007)
      = const PublicTag("FillerOrderNumberProcedure", 0x00401007,
          "Filler Order Number / Procedure", VR.kSH, VM.k1, true);
  static const PublicTag kConfidentialityCode
      //(0040,1008)
      = const PublicTag("ConfidentialityCode", 0x00401008, "Confidentiality Code", VR.kLO,
          VM.k1, false);
  static const PublicTag kReportingPriority
      //(0040,1009)
      = const PublicTag(
          "ReportingPriority", 0x00401009, "Reporting Priority", VR.kSH, VM.k1, false);
  static const PublicTag kReasonForRequestedProcedureCodeSequence
      //(0040,100A)
      = const PublicTag("ReasonForRequestedProcedureCodeSequence", 0x0040100A,
          "Reason for Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNamesOfIntendedRecipientsOfResults
      //(0040,1010)
      = const PublicTag("NamesOfIntendedRecipientsOfResults", 0x00401010,
          "Names of Intended Recipients of Results", VR.kPN, VM.k1_n, false);
  static const PublicTag kIntendedRecipientsOfResultsIdentificationSequence
      //(0040,1011)
      = const PublicTag("IntendedRecipientsOfResultsIdentificationSequence", 0x00401011,
          "Intended Recipients of Results Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReasonForPerformedProcedureCodeSequence
      //(0040,1012)
      = const PublicTag("ReasonForPerformedProcedureCodeSequence", 0x00401012,
          "Reason For Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRequestedProcedureDescriptionTrial
      //(0040,1060)
      = const PublicTag("RequestedProcedureDescriptionTrial", 0x00401060,
          "Requested Procedure Description (Trial)", VR.kLO, VM.k1, true);
  static const PublicTag kPersonIdentificationCodeSequence
      //(0040,1101)
      = const PublicTag("PersonIdentificationCodeSequence", 0x00401101,
          "Person Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPersonAddress
      //(0040,1102)
      = const PublicTag(
          "PersonAddress", 0x00401102, "Person's Address", VR.kST, VM.k1, false);
  static const PublicTag kPersonTelephoneNumbers
      //(0040,1103)
      = const PublicTag("PersonTelephoneNumbers", 0x00401103,
          "Person's Telephone Numbers", VR.kLO, VM.k1_n, false);
  static const PublicTag kRequestedProcedureComments
      //(0040,1400)
      = const PublicTag("RequestedProcedureComments", 0x00401400,
          "Requested Procedure Comments", VR.kLT, VM.k1, false);
  static const PublicTag kReasonForTheImagingServiceRequest
      //(0040,2001)
      = const PublicTag("ReasonForTheImagingServiceRequest", 0x00402001,
          "Reason for the Imaging Service Request", VR.kLO, VM.k1, true);
  static const PublicTag kIssueDateOfImagingServiceRequest
      //(0040,2004)
      = const PublicTag("IssueDateOfImagingServiceRequest", 0x00402004,
          "Issue Date of Imaging Service Request", VR.kDA, VM.k1, false);
  static const PublicTag kIssueTimeOfImagingServiceRequest
      //(0040,2005)
      = const PublicTag("IssueTimeOfImagingServiceRequest", 0x00402005,
          "Issue Time of Imaging Service Request", VR.kTM, VM.k1, false);
  static const PublicTag kPlacerOrderNumberImagingServiceRequestRetired
      //(0040,2006)
      = const PublicTag("PlacerOrderNumberImagingServiceRequestRetired", 0x00402006,
          "Placer Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const PublicTag kFillerOrderNumberImagingServiceRequestRetired
      //(0040,2007)
      = const PublicTag("FillerOrderNumberImagingServiceRequestRetired", 0x00402007,
          "Filler Order Number / Imaging Service Request (Retired)", VR.kSH, VM.k1, true);
  static const PublicTag kOrderEnteredBy
      //(0040,2008)
      = const PublicTag(
          "OrderEnteredBy", 0x00402008, "Order Entered By", VR.kPN, VM.k1, false);
  static const PublicTag kOrderEntererLocation
      //(0040,2009)
      = const PublicTag("OrderEntererLocation", 0x00402009, "Order Enterer's Location",
          VR.kSH, VM.k1, false);
  static const PublicTag kOrderCallbackPhoneNumber
      //(0040,2010)
      = const PublicTag("OrderCallbackPhoneNumber", 0x00402010,
          "Order Callback Phone Number", VR.kSH, VM.k1, false);
  static const PublicTag kPlacerOrderNumberImagingServiceRequest
      //(0040,2016)
      = const PublicTag("PlacerOrderNumberImagingServiceRequest", 0x00402016,
          "Placer Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const PublicTag kFillerOrderNumberImagingServiceRequest
      //(0040,2017)
      = const PublicTag("FillerOrderNumberImagingServiceRequest", 0x00402017,
          "Filler Order Number / Imaging Service Request", VR.kLO, VM.k1, false);
  static const PublicTag kImagingServiceRequestComments
      //(0040,2400)
      = const PublicTag("ImagingServiceRequestComments", 0x00402400,
          "Imaging Service Request Comments", VR.kLT, VM.k1, false);
  static const PublicTag kConfidentialityConstraintOnPatientDataDescription
      //(0040,3001)
      = const PublicTag("ConfidentialityConstraintOnPatientDataDescription", 0x00403001,
          "Confidentiality Constraint on Patient Data Description", VR.kLO, VM.k1, false);
  static const PublicTag kGeneralPurposeScheduledProcedureStepStatus
      //(0040,4001)
      = const PublicTag("GeneralPurposeScheduledProcedureStepStatus", 0x00404001,
          "General Purpose Scheduled Procedure Step Status", VR.kCS, VM.k1, true);
  static const PublicTag kGeneralPurposePerformedProcedureStepStatus
      //(0040,4002)
      = const PublicTag("GeneralPurposePerformedProcedureStepStatus", 0x00404002,
          "General Purpose Performed Procedure Step Status", VR.kCS, VM.k1, true);
  static const PublicTag kGeneralPurposeScheduledProcedureStepPriority
      //(0040,4003)
      = const PublicTag("GeneralPurposeScheduledProcedureStepPriority", 0x00404003,
          "General Purpose Scheduled Procedure Step Priority", VR.kCS, VM.k1, true);
  static const PublicTag kScheduledProcessingApplicationsCodeSequence
      //(0040,4004)
      = const PublicTag("ScheduledProcessingApplicationsCodeSequence", 0x00404004,
          "Scheduled Processing Applications Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kScheduledProcedureStepStartDateTime
      //(0040,4005)
      = const PublicTag("ScheduledProcedureStepStartDateTime", 0x00404005,
          "Scheduled Procedure Step Start DateTime", VR.kDT, VM.k1, true);
  static const PublicTag kMultipleCopiesFlag
      //(0040,4006)
      = const PublicTag(
          "MultipleCopiesFlag", 0x00404006, "Multiple Copies Flag", VR.kCS, VM.k1, true);
  static const PublicTag kPerformedProcessingApplicationsCodeSequence
      //(0040,4007)
      = const PublicTag("PerformedProcessingApplicationsCodeSequence", 0x00404007,
          "Performed Processing Applications Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHumanPerformerCodeSequence
      //(0040,4009)
      = const PublicTag("HumanPerformerCodeSequence", 0x00404009,
          "Human Performer Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledProcedureStepModificationDateTime
      //(0040,4010)
      = const PublicTag("ScheduledProcedureStepModificationDateTime", 0x00404010,
          "Scheduled Procedure Step Modification DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kExpectedCompletionDateTime
      //(0040,4011)
      = const PublicTag("ExpectedCompletionDateTime", 0x00404011,
          "Expected Completion DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kResultingGeneralPurposePerformedProcedureStepsSequence
      //(0040,4015)
      = const PublicTag(
          "ResultingGeneralPurposePerformedProcedureStepsSequence",
          0x00404015,
          "Resulting General Purpose Performed Procedure Steps Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kReferencedGeneralPurposeScheduledProcedureStepSequence
      //(0040,4016)
      = const PublicTag(
          "ReferencedGeneralPurposeScheduledProcedureStepSequence",
          0x00404016,
          "Referenced General Purpose Scheduled Procedure Step Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kScheduledWorkitemCodeSequence
      //(0040,4018)
      = const PublicTag("ScheduledWorkitemCodeSequence", 0x00404018,
          "Scheduled Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedWorkitemCodeSequence
      //(0040,4019)
      = const PublicTag("PerformedWorkitemCodeSequence", 0x00404019,
          "Performed Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInputAvailabilityFlag
      //(0040,4020)
      = const PublicTag("InputAvailabilityFlag", 0x00404020, "Input Availability Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kInputInformationSequence
      //(0040,4021)
      = const PublicTag("InputInformationSequence", 0x00404021,
          "Input Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelevantInformationSequence
      //(0040,4022)
      = const PublicTag("RelevantInformationSequence", 0x00404022,
          "Relevant Information Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedGeneralPurposeScheduledProcedureStepTransactionUID
      //(0040,4023)
      = const PublicTag(
          "ReferencedGeneralPurposeScheduledProcedureStepTransactionUID",
          0x00404023,
          "Referenced General Purpose Scheduled Procedure Step Transaction UID",
          VR.kUI,
          VM.k1,
          true);
  static const PublicTag kScheduledStationNameCodeSequence
      //(0040,4025)
      = const PublicTag("ScheduledStationNameCodeSequence", 0x00404025,
          "Scheduled Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledStationClassCodeSequence
      //(0040,4026)
      = const PublicTag("ScheduledStationClassCodeSequence", 0x00404026,
          "Scheduled Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledStationGeographicLocationCodeSequence
      //(0040,4027)
      = const PublicTag("ScheduledStationGeographicLocationCodeSequence", 0x00404027,
          "Scheduled Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedStationNameCodeSequence
      //(0040,4028)
      = const PublicTag("PerformedStationNameCodeSequence", 0x00404028,
          "Performed Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedStationClassCodeSequence
      //(0040,4029)
      = const PublicTag("PerformedStationClassCodeSequence", 0x00404029,
          "Performed Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedStationGeographicLocationCodeSequence
      //(0040,4030)
      = const PublicTag("PerformedStationGeographicLocationCodeSequence", 0x00404030,
          "Performed Station Geographic Location Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRequestedSubsequentWorkitemCodeSequence
      //(0040,4031)
      = const PublicTag("RequestedSubsequentWorkitemCodeSequence", 0x00404031,
          "Requested Subsequent Workitem Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kNonDICOMOutputCodeSequence
      //(0040,4032)
      = const PublicTag("NonDICOMOutputCodeSequence", 0x00404032,
          "Non-DICOM Output Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kOutputInformationSequence
      //(0040,4033)
      = const PublicTag("OutputInformationSequence", 0x00404033,
          "Output Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScheduledHumanPerformersSequence
      //(0040,4034)
      = const PublicTag("ScheduledHumanPerformersSequence", 0x00404034,
          "Scheduled Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kActualHumanPerformersSequence
      //(0040,4035)
      = const PublicTag("ActualHumanPerformersSequence", 0x00404035,
          "Actual Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHumanPerformerOrganization
      //(0040,4036)
      = const PublicTag("HumanPerformerOrganization", 0x00404036,
          "Human Performer's Organization", VR.kLO, VM.k1, false);
  static const PublicTag kHumanPerformerName
      //(0040,4037)
      = const PublicTag("HumanPerformerName", 0x00404037, "Human Performer's Name",
          VR.kPN, VM.k1, false);
  static const PublicTag kRawDataHandling
      //(0040,4040)
      = const PublicTag(
          "RawDataHandling", 0x00404040, "Raw Data Handling", VR.kCS, VM.k1, false);
  static const PublicTag kInputReadinessState
      //(0040,4041)
      = const PublicTag("InputReadinessState", 0x00404041, "Input Readiness State",
          VR.kCS, VM.k1, false);
  static const PublicTag kPerformedProcedureStepStartDateTime
      //(0040,4050)
      = const PublicTag("PerformedProcedureStepStartDateTime", 0x00404050,
          "Performed Procedure Step Start DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kPerformedProcedureStepEndDateTime
      //(0040,4051)
      = const PublicTag("PerformedProcedureStepEndDateTime", 0x00404051,
          "Performed Procedure Step End DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kProcedureStepCancellationDateTime
      //(0040,4052)
      = const PublicTag("ProcedureStepCancellationDateTime", 0x00404052,
          "Procedure Step Cancellation DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kEntranceDoseInmGy
      //(0040,8302)
      = const PublicTag(
          "EntranceDoseInmGy", 0x00408302, "Entrance Dose in mGy", VR.kDS, VM.k1, false);
  static const PublicTag kReferencedImageRealWorldValueMappingSequence
      //(0040,9094)
      = const PublicTag("ReferencedImageRealWorldValueMappingSequence", 0x00409094,
          "Referenced Image Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRealWorldValueMappingSequence
      //(0040,9096)
      = const PublicTag("RealWorldValueMappingSequence", 0x00409096,
          "Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPixelValueMappingCodeSequence
      //(0040,9098)
      = const PublicTag("PixelValueMappingCodeSequence", 0x00409098,
          "Pixel Value Mapping Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLUTLabel
      //(0040,9210)
      = const PublicTag("LUTLabel", 0x00409210, "LUT Label", VR.kSH, VM.k1, false);
  static const PublicTag kRealWorldValueLastValueMapped
      //(0040,9211)
      = const PublicTag("RealWorldValueLastValueMapped", 0x00409211,
          "Real World Value Last Value Mapped", VR.kUSSS, VM.k1, false);
  static const PublicTag kRealWorldValueLUTData
      //(0040,9212)
      = const PublicTag("RealWorldValueLUTData", 0x00409212, "Real World Value LUT Data",
          VR.kFD, VM.k1_n, false);
  static const PublicTag kRealWorldValueFirstValueMapped
      //(0040,9216)
      = const PublicTag("RealWorldValueFirstValueMapped", 0x00409216,
          "Real World Value First Value Mapped", VR.kUSSS, VM.k1, false);
  static const PublicTag kRealWorldValueIntercept
      //(0040,9224)
      = const PublicTag("RealWorldValueIntercept", 0x00409224,
          "Real World Value Intercept", VR.kFD, VM.k1, false);
  static const PublicTag kRealWorldValueSlope
      //(0040,9225)
      = const PublicTag("RealWorldValueSlope", 0x00409225, "Real World Value Slope",
          VR.kFD, VM.k1, false);
  static const PublicTag kFindingsFlagTrial
      //(0040,A007)
      = const PublicTag(
          "FindingsFlagTrial", 0x0040A007, "Findings Flag (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kRelationshipType
      //(0040,A010)
      = const PublicTag(
          "RelationshipType", 0x0040A010, "Relationship Type", VR.kCS, VM.k1, false);
  static const PublicTag kFindingsSequenceTrial
      //(0040,A020)
      = const PublicTag("FindingsSequenceTrial", 0x0040A020, "Findings Sequence (Trial)",
          VR.kSQ, VM.k1, true);
  static const PublicTag kFindingsGroupUIDTrial
      //(0040,A021)
      = const PublicTag("FindingsGroupUIDTrial", 0x0040A021, "Findings Group UID (Trial)",
          VR.kUI, VM.k1, true);
  static const PublicTag kReferencedFindingsGroupUIDTrial
      //(0040,A022)
      = const PublicTag("ReferencedFindingsGroupUIDTrial", 0x0040A022,
          "Referenced Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const PublicTag kFindingsGroupRecordingDateTrial
      //(0040,A023)
      = const PublicTag("FindingsGroupRecordingDateTrial", 0x0040A023,
          "Findings Group Recording Date (Trial)", VR.kDA, VM.k1, true);
  static const PublicTag kFindingsGroupRecordingTimeTrial
      //(0040,A024)
      = const PublicTag("FindingsGroupRecordingTimeTrial", 0x0040A024,
          "Findings Group Recording Time (Trial)", VR.kTM, VM.k1, true);
  static const PublicTag kFindingsSourceCategoryCodeSequenceTrial
      //(0040,A026)
      = const PublicTag("FindingsSourceCategoryCodeSequenceTrial", 0x0040A026,
          "Findings Source Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kVerifyingOrganization
      //(0040,A027)
      = const PublicTag("VerifyingOrganization", 0x0040A027, "Verifying Organization",
          VR.kLO, VM.k1, false);
  static const PublicTag kDocumentingOrganizationIdentifierCodeSequenceTrial
      //(0040,A028)
      = const PublicTag(
          "DocumentingOrganizationIdentifierCodeSequenceTrial",
          0x0040A028,
          "Documenting Organization Identifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const PublicTag kVerificationDateTime
      //(0040,A030)
      = const PublicTag("VerificationDateTime", 0x0040A030, "Verification DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kObservationDateTime
      //(0040,A032)
      = const PublicTag("ObservationDateTime", 0x0040A032, "Observation DateTime", VR.kDT,
          VM.k1, false);
  static const PublicTag kValueType
      //(0040,A040)
      = const PublicTag("ValueType", 0x0040A040, "Value Type", VR.kCS, VM.k1, false);
  static const PublicTag kConceptNameCodeSequence
      //(0040,A043)
      = const PublicTag("ConceptNameCodeSequence", 0x0040A043,
          "Concept Name Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMeasurementPrecisionDescriptionTrial
      //(0040,A047)
      = const PublicTag("MeasurementPrecisionDescriptionTrial", 0x0040A047,
          "Measurement Precision Description (Trial)", VR.kLO, VM.k1, true);
  static const PublicTag kContinuityOfContent
      //(0040,A050)
      = const PublicTag("ContinuityOfContent", 0x0040A050, "Continuity Of Content",
          VR.kCS, VM.k1, false);
  static const PublicTag kUrgencyOrPriorityAlertsTrial
      //(0040,A057)
      = const PublicTag("UrgencyOrPriorityAlertsTrial", 0x0040A057,
          "Urgency or Priority Alerts (Trial)", VR.kCS, VM.k1_n, true);
  static const PublicTag kSequencingIndicatorTrial
      //(0040,A060)
      = const PublicTag("SequencingIndicatorTrial", 0x0040A060,
          "Sequencing Indicator (Trial)", VR.kLO, VM.k1, true);
  static const PublicTag kDocumentIdentifierCodeSequenceTrial
      //(0040,A066)
      = const PublicTag("DocumentIdentifierCodeSequenceTrial", 0x0040A066,
          "Document Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kDocumentAuthorTrial
      //(0040,A067)
      = const PublicTag("DocumentAuthorTrial", 0x0040A067, "Document Author (Trial)",
          VR.kPN, VM.k1, true);
  static const PublicTag kDocumentAuthorIdentifierCodeSequenceTrial
      //(0040,A068)
      = const PublicTag("DocumentAuthorIdentifierCodeSequenceTrial", 0x0040A068,
          "Document Author Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kIdentifierCodeSequenceTrial
      //(0040,A070)
      = const PublicTag("IdentifierCodeSequenceTrial", 0x0040A070,
          "Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kVerifyingObserverSequence
      //(0040,A073)
      = const PublicTag("VerifyingObserverSequence", 0x0040A073,
          "Verifying Observer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObjectBinaryIdentifierTrial
      //(0040,A074)
      = const PublicTag("ObjectBinaryIdentifierTrial", 0x0040A074,
          "Object Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const PublicTag kVerifyingObserverName
      //(0040,A075)
      = const PublicTag("VerifyingObserverName", 0x0040A075, "Verifying Observer Name",
          VR.kPN, VM.k1, false);
  static const PublicTag kDocumentingObserverIdentifierCodeSequenceTrial
      //(0040,A076)
      = const PublicTag("DocumentingObserverIdentifierCodeSequenceTrial", 0x0040A076,
          "Documenting Observer Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kAuthorObserverSequence
      //(0040,A078)
      = const PublicTag("AuthorObserverSequence", 0x0040A078, "Author Observer Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kParticipantSequence
      //(0040,A07A)
      = const PublicTag("ParticipantSequence", 0x0040A07A, "Participant Sequence", VR.kSQ,
          VM.k1, false);
  static const PublicTag kCustodialOrganizationSequence
      //(0040,A07C)
      = const PublicTag("CustodialOrganizationSequence", 0x0040A07C,
          "Custodial Organization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kParticipationType
      //(0040,A080)
      = const PublicTag(
          "ParticipationType", 0x0040A080, "Participation Type", VR.kCS, VM.k1, false);
  static const PublicTag kParticipationDateTime
      //(0040,A082)
      = const PublicTag("ParticipationDateTime", 0x0040A082, "Participation DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kObserverType
      //(0040,A084)
      =
      const PublicTag("ObserverType", 0x0040A084, "Observer Type", VR.kCS, VM.k1, false);
  static const PublicTag kProcedureIdentifierCodeSequenceTrial
      //(0040,A085)
      = const PublicTag("ProcedureIdentifierCodeSequenceTrial", 0x0040A085,
          "Procedure Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kVerifyingObserverIdentificationCodeSequence
      //(0040,A088)
      = const PublicTag("VerifyingObserverIdentificationCodeSequence", 0x0040A088,
          "Verifying Observer Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObjectDirectoryBinaryIdentifierTrial
      //(0040,A089)
      = const PublicTag("ObjectDirectoryBinaryIdentifierTrial", 0x0040A089,
          "Object Directory Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const PublicTag kEquivalentCDADocumentSequence
      //(0040,A090)
      = const PublicTag("EquivalentCDADocumentSequence", 0x0040A090,
          "Equivalent CDA Document Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedWaveformChannels
      //(0040,A0B0)
      = const PublicTag("ReferencedWaveformChannels", 0x0040A0B0,
          "Referenced Waveform Channels", VR.kUS, VM.k2_2n, false);
  static const PublicTag kDateOfDocumentOrVerbalTransactionTrial
      //(0040,A110)
      = const PublicTag("DateOfDocumentOrVerbalTransactionTrial", 0x0040A110,
          "Date of Document or Verbal Transaction (Trial)", VR.kDA, VM.k1, true);
  static const PublicTag kTimeOfDocumentCreationOrVerbalTransactionTrial
      //(0040,A112)
      = const PublicTag("TimeOfDocumentCreationOrVerbalTransactionTrial", 0x0040A112,
          "Time of Document Creation or Verbal Transaction (Trial)", VR.kTM, VM.k1, true);
  static const PublicTag kDateTime
      //(0040,A120)
      = const PublicTag("DateTime", 0x0040A120, "DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kDate
      //(0040,A121)
      = const PublicTag("Date", 0x0040A121, "Date", VR.kDA, VM.k1, false);
  static const PublicTag kTime
      //(0040,A122)
      = const PublicTag("Time", 0x0040A122, "Time", VR.kTM, VM.k1, false);
  static const PublicTag kPersonName
      //(0040,A123)
      = const PublicTag("PersonName", 0x0040A123, "Person Name", VR.kPN, VM.k1, false);
  static const PublicTag kUID
      //(0040,A124)
      = const PublicTag("UID", 0x0040A124, "UID", VR.kUI, VM.k1, false);
  static const PublicTag kReportStatusIDTrial
      //(0040,A125)
      = const PublicTag("ReportStatusIDTrial", 0x0040A125, "Report Status ID (Trial)",
          VR.kCS, VM.k2, true);
  static const PublicTag kTemporalRangeType
      //(0040,A130)
      = const PublicTag(
          "TemporalRangeType", 0x0040A130, "Temporal Range Type", VR.kCS, VM.k1, false);
  static const PublicTag kReferencedSamplePositions
      //(0040,A132)
      = const PublicTag("ReferencedSamplePositions", 0x0040A132,
          "Referenced Sample Positions", VR.kUL, VM.k1_n, false);
  static const PublicTag kReferencedFrameNumbers
      //(0040,A136)
      = const PublicTag("ReferencedFrameNumbers", 0x0040A136, "Referenced Frame Numbers",
          VR.kUS, VM.k1_n, false);
  static const PublicTag kReferencedTimeOffsets
      //(0040,A138)
      = const PublicTag("ReferencedTimeOffsets", 0x0040A138, "Referenced Time Offsets",
          VR.kDS, VM.k1_n, false);
  static const PublicTag kReferencedDateTime
      //(0040,A13A)
      = const PublicTag("ReferencedDateTime", 0x0040A13A, "Referenced DateTime", VR.kDT,
          VM.k1_n, false);
  static const PublicTag kTextValue
      //(0040,A160)
      = const PublicTag("TextValue", 0x0040A160, "Text Value", VR.kUT, VM.k1, false);
  static const PublicTag kFloatingPointValue
      //(0040,A161)
      = const PublicTag("FloatingPointValue", 0x0040A161, "Floating Point Value", VR.kFD,
          VM.k1_n, false);
  static const PublicTag kRationalNumeratorValue
      //(0040,A162)
      = const PublicTag("RationalNumeratorValue", 0x0040A162, "Rational Numerator Value",
          VR.kSL, VM.k1_n, false);
  static const PublicTag kRationalDenominatorValue
      //(0040,A163)
      = const PublicTag("RationalDenominatorValue", 0x0040A163,
          "Rational Denominator Value", VR.kUL, VM.k1_n, false);
  static const PublicTag kObservationCategoryCodeSequenceTrial
      //(0040,A167)
      = const PublicTag("ObservationCategoryCodeSequenceTrial", 0x0040A167,
          "Observation Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kConceptCodeSequence
      //(0040,A168)
      = const PublicTag("ConceptCodeSequence", 0x0040A168, "Concept Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kBibliographicCitationTrial
      //(0040,A16A)
      = const PublicTag("BibliographicCitationTrial", 0x0040A16A,
          "Bibliographic Citation (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kPurposeOfReferenceCodeSequence
      //(0040,A170)
      = const PublicTag("PurposeOfReferenceCodeSequence", 0x0040A170,
          "Purpose of Reference Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObservationUID
      //(0040,A171)
      = const PublicTag(
          "ObservationUID", 0x0040A171, "Observation UID", VR.kUI, VM.k1, false);
  static const PublicTag kReferencedObservationUIDTrial
      //(0040,A172)
      = const PublicTag("ReferencedObservationUIDTrial", 0x0040A172,
          "Referenced Observation UID (Trial)", VR.kUI, VM.k1, true);
  static const PublicTag kReferencedObservationClassTrial
      //(0040,A173)
      = const PublicTag("ReferencedObservationClassTrial", 0x0040A173,
          "Referenced Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kReferencedObjectObservationClassTrial
      //(0040,A174)
      = const PublicTag("ReferencedObjectObservationClassTrial", 0x0040A174,
          "Referenced Object Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kAnnotationGroupNumber
      //(0040,A180)
      = const PublicTag("AnnotationGroupNumber", 0x0040A180, "Annotation Group Number",
          VR.kUS, VM.k1, false);
  static const PublicTag kObservationDateTrial
      //(0040,A192)
      = const PublicTag("ObservationDateTrial", 0x0040A192, "Observation Date (Trial)",
          VR.kDA, VM.k1, true);
  static const PublicTag kObservationTimeTrial
      //(0040,A193)
      = const PublicTag("ObservationTimeTrial", 0x0040A193, "Observation Time (Trial)",
          VR.kTM, VM.k1, true);
  static const PublicTag kMeasurementAutomationTrial
      //(0040,A194)
      = const PublicTag("MeasurementAutomationTrial", 0x0040A194,
          "Measurement Automation (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kModifierCodeSequence
      //(0040,A195)
      = const PublicTag("ModifierCodeSequence", 0x0040A195, "Modifier Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kIdentificationDescriptionTrial
      //(0040,A224)
      = const PublicTag("IdentificationDescriptionTrial", 0x0040A224,
          "Identification Description (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kCoordinatesSetGeometricTypeTrial
      //(0040,A290)
      = const PublicTag("CoordinatesSetGeometricTypeTrial", 0x0040A290,
          "Coordinates Set Geometric Type (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kAlgorithmCodeSequenceTrial
      //(0040,A296)
      = const PublicTag("AlgorithmCodeSequenceTrial", 0x0040A296,
          "Algorithm Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kAlgorithmDescriptionTrial
      //(0040,A297)
      = const PublicTag("AlgorithmDescriptionTrial", 0x0040A297,
          "Algorithm Description (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kPixelCoordinatesSetTrial
      //(0040,A29A)
      = const PublicTag("PixelCoordinatesSetTrial", 0x0040A29A,
          "Pixel Coordinates Set (Trial)", VR.kSL, VM.k2_2n, true);
  static const PublicTag kMeasuredValueSequence
      //(0040,A300)
      = const PublicTag("MeasuredValueSequence", 0x0040A300, "Measured Value Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kNumericValueQualifierCodeSequence
      //(0040,A301)
      = const PublicTag("NumericValueQualifierCodeSequence", 0x0040A301,
          "Numeric Value Qualifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCurrentObserverTrial
      //(0040,A307)
      = const PublicTag("CurrentObserverTrial", 0x0040A307, "Current Observer (Trial)",
          VR.kPN, VM.k1, true);
  static const PublicTag kNumericValue
      //(0040,A30A)
      = const PublicTag(
          "NumericValue", 0x0040A30A, "Numeric Value", VR.kDS, VM.k1_n, false);
  static const PublicTag kReferencedAccessionSequenceTrial
      //(0040,A313)
      = const PublicTag("ReferencedAccessionSequenceTrial", 0x0040A313,
          "Referenced Accession Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kReportStatusCommentTrial
      //(0040,A33A)
      = const PublicTag("ReportStatusCommentTrial", 0x0040A33A,
          "Report Status Comment (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kProcedureContextSequenceTrial
      //(0040,A340)
      = const PublicTag("ProcedureContextSequenceTrial", 0x0040A340,
          "Procedure Context Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kVerbalSourceTrial
      //(0040,A352)
      = const PublicTag(
          "VerbalSourceTrial", 0x0040A352, "Verbal Source (Trial)", VR.kPN, VM.k1, true);
  static const PublicTag kAddressTrial
      //(0040,A353)
      =
      const PublicTag("AddressTrial", 0x0040A353, "Address (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kTelephoneNumberTrial
      //(0040,A354)
      = const PublicTag("TelephoneNumberTrial", 0x0040A354, "Telephone Number (Trial)",
          VR.kLO, VM.k1, true);
  static const PublicTag kVerbalSourceIdentifierCodeSequenceTrial
      //(0040,A358)
      = const PublicTag("VerbalSourceIdentifierCodeSequenceTrial", 0x0040A358,
          "Verbal Source Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kPredecessorDocumentsSequence
      //(0040,A360)
      = const PublicTag("PredecessorDocumentsSequence", 0x0040A360,
          "Predecessor Documents Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedRequestSequence
      //(0040,A370)
      = const PublicTag("ReferencedRequestSequence", 0x0040A370,
          "Referenced Request Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedProcedureCodeSequence
      //(0040,A372)
      = const PublicTag("PerformedProcedureCodeSequence", 0x0040A372,
          "Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCurrentRequestedProcedureEvidenceSequence
      //(0040,A375)
      = const PublicTag("CurrentRequestedProcedureEvidenceSequence", 0x0040A375,
          "Current Requested Procedure Evidence Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReportDetailSequenceTrial
      //(0040,A380)
      = const PublicTag("ReportDetailSequenceTrial", 0x0040A380,
          "Report Detail Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kPertinentOtherEvidenceSequence
      //(0040,A385)
      = const PublicTag("PertinentOtherEvidenceSequence", 0x0040A385,
          "Pertinent Other Evidence Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHL7StructuredDocumentReferenceSequence
      //(0040,A390)
      = const PublicTag("HL7StructuredDocumentReferenceSequence", 0x0040A390,
          "HL7 Structured Document Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObservationSubjectUIDTrial
      //(0040,A402)
      = const PublicTag("ObservationSubjectUIDTrial", 0x0040A402,
          "Observation Subject UID (Trial)", VR.kUI, VM.k1, true);
  static const PublicTag kObservationSubjectClassTrial
      //(0040,A403)
      = const PublicTag("ObservationSubjectClassTrial", 0x0040A403,
          "Observation Subject Class (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kObservationSubjectTypeCodeSequenceTrial
      //(0040,A404)
      = const PublicTag("ObservationSubjectTypeCodeSequenceTrial", 0x0040A404,
          "Observation Subject Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kCompletionFlag
      //(0040,A491)
      = const PublicTag(
          "CompletionFlag", 0x0040A491, "Completion Flag", VR.kCS, VM.k1, false);
  static const PublicTag kCompletionFlagDescription
      //(0040,A492)
      = const PublicTag("CompletionFlagDescription", 0x0040A492,
          "Completion Flag Description", VR.kLO, VM.k1, false);
  static const PublicTag kVerificationFlag
      //(0040,A493)
      = const PublicTag(
          "VerificationFlag", 0x0040A493, "Verification Flag", VR.kCS, VM.k1, false);
  static const PublicTag kArchiveRequested
      //(0040,A494)
      = const PublicTag(
          "ArchiveRequested", 0x0040A494, "Archive Requested", VR.kCS, VM.k1, false);
  static const PublicTag kPreliminaryFlag
      //(0040,A496)
      = const PublicTag(
          "PreliminaryFlag", 0x0040A496, "Preliminary Flag", VR.kCS, VM.k1, false);
  static const PublicTag kContentTemplateSequence
      //(0040,A504)
      = const PublicTag("ContentTemplateSequence", 0x0040A504,
          "Content Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIdenticalDocumentsSequence
      //(0040,A525)
      = const PublicTag("IdenticalDocumentsSequence", 0x0040A525,
          "Identical Documents Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObservationSubjectContextFlagTrial
      //(0040,A600)
      = const PublicTag("ObservationSubjectContextFlagTrial", 0x0040A600,
          "Observation Subject Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kObserverContextFlagTrial
      //(0040,A601)
      = const PublicTag("ObserverContextFlagTrial", 0x0040A601,
          "Observer Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kProcedureContextFlagTrial
      //(0040,A603)
      = const PublicTag("ProcedureContextFlagTrial", 0x0040A603,
          "Procedure Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kContentSequence
      //(0040,A730)
      = const PublicTag(
          "ContentSequence", 0x0040A730, "Content Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelationshipSequenceTrial
      //(0040,A731)
      = const PublicTag("RelationshipSequenceTrial", 0x0040A731,
          "Relationship Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kRelationshipTypeCodeSequenceTrial
      //(0040,A732)
      = const PublicTag("RelationshipTypeCodeSequenceTrial", 0x0040A732,
          "Relationship Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kLanguageCodeSequenceTrial
      //(0040,A744)
      = const PublicTag("LanguageCodeSequenceTrial", 0x0040A744,
          "Language Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const PublicTag kUniformResourceLocatorTrial
      //(0040,A992)
      = const PublicTag("UniformResourceLocatorTrial", 0x0040A992,
          "Uniform Resource Locator (Trial)", VR.kST, VM.k1, true);
  static const PublicTag kWaveformAnnotationSequence
      //(0040,B020)
      = const PublicTag("WaveformAnnotationSequence", 0x0040B020,
          "Waveform Annotation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTemplateIdentifier
      //(0040,DB00)
      = const PublicTag(
          "TemplateIdentifier", 0x0040DB00, "Template Identifier", VR.kCS, VM.k1, false);
  static const PublicTag kTemplateVersion
      //(0040,DB06)
      = const PublicTag(
          "TemplateVersion", 0x0040DB06, "Template Version", VR.kDT, VM.k1, true);
  static const PublicTag kTemplateLocalVersion
      //(0040,DB07)
      = const PublicTag("TemplateLocalVersion", 0x0040DB07, "Template Local Version",
          VR.kDT, VM.k1, true);
  static const PublicTag kTemplateExtensionFlag
      //(0040,DB0B)
      = const PublicTag("TemplateExtensionFlag", 0x0040DB0B, "Template Extension Flag",
          VR.kCS, VM.k1, true);
  static const PublicTag kTemplateExtensionOrganizationUID
      //(0040,DB0C)
      = const PublicTag("TemplateExtensionOrganizationUID", 0x0040DB0C,
          "Template Extension Organization UID", VR.kUI, VM.k1, true);
  static const PublicTag kTemplateExtensionCreatorUID
      //(0040,DB0D)
      = const PublicTag("TemplateExtensionCreatorUID", 0x0040DB0D,
          "Template Extension Creator UID", VR.kUI, VM.k1, true);
  static const PublicTag kReferencedContentItemIdentifier
      //(0040,DB73)
      = const PublicTag("ReferencedContentItemIdentifier", 0x0040DB73,
          "Referenced Content Item Identifier", VR.kUL, VM.k1_n, false);
  static const PublicTag kHL7InstanceIdentifier
      //(0040,E001)
      = const PublicTag("HL7InstanceIdentifier", 0x0040E001, "HL7 Instance Identifier",
          VR.kST, VM.k1, false);
  static const PublicTag kHL7DocumentEffectiveTime
      //(0040,E004)
      = const PublicTag("HL7DocumentEffectiveTime", 0x0040E004,
          "HL7 Document Effective Time", VR.kDT, VM.k1, false);
  static const PublicTag kHL7DocumentTypeCodeSequence
      //(0040,E006)
      = const PublicTag("HL7DocumentTypeCodeSequence", 0x0040E006,
          "HL7 Document Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDocumentClassCodeSequence
      //(0040,E008)
      = const PublicTag("DocumentClassCodeSequence", 0x0040E008,
          "Document Class Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRetrieveURI
      //(0040,E010)
      = const PublicTag("RetrieveURI", 0x0040E010, "Retrieve URI", VR.kUT, VM.k1, false);
  static const PublicTag kRetrieveLocationUID
      //(0040,E011)
      = const PublicTag("RetrieveLocationUID", 0x0040E011, "Retrieve Location UID",
          VR.kUI, VM.k1, false);
  static const PublicTag kTypeOfInstances
      //(0040,E020)
      = const PublicTag(
          "TypeOfInstances", 0x0040E020, "Type of Instances", VR.kCS, VM.k1, false);
  static const PublicTag kDICOMRetrievalSequence
      //(0040,E021)
      = const PublicTag("DICOMRetrievalSequence", 0x0040E021, "DICOM Retrieval Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDICOMMediaRetrievalSequence
      //(0040,E022)
      = const PublicTag("DICOMMediaRetrievalSequence", 0x0040E022,
          "DICOM Media Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kWADORetrievalSequence
      //(0040,E023)
      = const PublicTag("WADORetrievalSequence", 0x0040E023, "WADO Retrieval Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kXDSRetrievalSequence
      //(0040,E024)
      = const PublicTag("XDSRetrievalSequence", 0x0040E024, "XDS Retrieval Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRepositoryUniqueID
      //(0040,E030)
      = const PublicTag(
          "RepositoryUniqueID", 0x0040E030, "Repository Unique ID", VR.kUI, VM.k1, false);
  static const PublicTag kHomeCommunityID
      //(0040,E031)
      = const PublicTag(
          "HomeCommunityID", 0x0040E031, "Home Community ID", VR.kUI, VM.k1, false);
  static const PublicTag kDocumentTitle
      //(0042,0010)
      = const PublicTag(
          "DocumentTitle", 0x00420010, "Document Title", VR.kST, VM.k1, false);
  static const PublicTag kEncapsulatedDocument
      //(0042,0011)
      = const PublicTag("EncapsulatedDocument", 0x00420011, "Encapsulated Document",
          VR.kOB, VM.k1, false);
  static const PublicTag kMIMETypeOfEncapsulatedDocument
      //(0042,0012)
      = const PublicTag("MIMETypeOfEncapsulatedDocument", 0x00420012,
          "MIME Type of Encapsulated Document", VR.kLO, VM.k1, false);
  static const PublicTag kSourceInstanceSequence
      //(0042,0013)
      = const PublicTag("SourceInstanceSequence", 0x00420013, "Source Instance Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kListOfMIMETypes
      //(0042,0014)
      = const PublicTag(
          "ListOfMIMETypes", 0x00420014, "List of MIME Types", VR.kLO, VM.k1_n, false);
  static const PublicTag kProductPackageIdentifier
      //(0044,0001)
      = const PublicTag("ProductPackageIdentifier", 0x00440001,
          "Product Package Identifier", VR.kST, VM.k1, false);
  static const PublicTag kSubstanceAdministrationApproval
      //(0044,0002)
      = const PublicTag("SubstanceAdministrationApproval", 0x00440002,
          "Substance Administration Approval", VR.kCS, VM.k1, false);
  static const PublicTag kApprovalStatusFurtherDescription
      //(0044,0003)
      = const PublicTag("ApprovalStatusFurtherDescription", 0x00440003,
          "Approval Status Further Description", VR.kLT, VM.k1, false);
  static const PublicTag kApprovalStatusDateTime
      //(0044,0004)
      = const PublicTag("ApprovalStatusDateTime", 0x00440004, "Approval Status DateTime",
          VR.kDT, VM.k1, false);
  static const PublicTag kProductTypeCodeSequence
      //(0044,0007)
      = const PublicTag("ProductTypeCodeSequence", 0x00440007,
          "Product Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kProductName
      //(0044,0008)
      =
      const PublicTag("ProductName", 0x00440008, "Product Name", VR.kLO, VM.k1_n, false);
  static const PublicTag kProductDescription
      //(0044,0009)
      = const PublicTag(
          "ProductDescription", 0x00440009, "Product Description", VR.kLT, VM.k1, false);
  static const PublicTag kProductLotIdentifier
      //(0044,000A)
      = const PublicTag("ProductLotIdentifier", 0x0044000A, "Product Lot Identifier",
          VR.kLO, VM.k1, false);
  static const PublicTag kProductExpirationDateTime
      //(0044,000B)
      = const PublicTag("ProductExpirationDateTime", 0x0044000B,
          "Product Expiration DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kSubstanceAdministrationDateTime
      //(0044,0010)
      = const PublicTag("SubstanceAdministrationDateTime", 0x00440010,
          "Substance Administration DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kSubstanceAdministrationNotes
      //(0044,0011)
      = const PublicTag("SubstanceAdministrationNotes", 0x00440011,
          "Substance Administration Notes", VR.kLO, VM.k1, false);
  static const PublicTag kSubstanceAdministrationDeviceID
      //(0044,0012)
      = const PublicTag("SubstanceAdministrationDeviceID", 0x00440012,
          "Substance Administration Device ID", VR.kLO, VM.k1, false);
  static const PublicTag kProductParameterSequence
      //(0044,0013)
      = const PublicTag("ProductParameterSequence", 0x00440013,
          "Product Parameter Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSubstanceAdministrationParameterSequence
      //(0044,0019)
      = const PublicTag("SubstanceAdministrationParameterSequence", 0x00440019,
          "Substance Administration Parameter Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLensDescription
      //(0046,0012)
      = const PublicTag(
          "LensDescription", 0x00460012, "Lens Description", VR.kLO, VM.k1, false);
  static const PublicTag kRightLensSequence
      //(0046,0014)
      = const PublicTag(
          "RightLensSequence", 0x00460014, "Right Lens Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLeftLensSequence
      //(0046,0015)
      = const PublicTag(
          "LeftLensSequence", 0x00460015, "Left Lens Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kUnspecifiedLateralityLensSequence
      //(0046,0016)
      = const PublicTag("UnspecifiedLateralityLensSequence", 0x00460016,
          "Unspecified Laterality Lens Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCylinderSequence
      //(0046,0018)
      = const PublicTag(
          "CylinderSequence", 0x00460018, "Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrismSequence
      //(0046,0028)
      = const PublicTag(
          "PrismSequence", 0x00460028, "Prism Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHorizontalPrismPower
      //(0046,0030)
      = const PublicTag("HorizontalPrismPower", 0x00460030, "Horizontal Prism Power",
          VR.kFD, VM.k1, false);
  static const PublicTag kHorizontalPrismBase
      //(0046,0032)
      = const PublicTag("HorizontalPrismBase", 0x00460032, "Horizontal Prism Base",
          VR.kCS, VM.k1, false);
  static const PublicTag kVerticalPrismPower
      //(0046,0034)
      = const PublicTag(
          "VerticalPrismPower", 0x00460034, "Vertical Prism Power", VR.kFD, VM.k1, false);
  static const PublicTag kVerticalPrismBase
      //(0046,0036)
      = const PublicTag(
          "VerticalPrismBase", 0x00460036, "Vertical Prism Base", VR.kCS, VM.k1, false);
  static const PublicTag kLensSegmentType
      //(0046,0038)
      = const PublicTag(
          "LensSegmentType", 0x00460038, "Lens Segment Type", VR.kCS, VM.k1, false);
  static const PublicTag kOpticalTransmittance
      //(0046,0040)
      = const PublicTag("OpticalTransmittance", 0x00460040, "Optical Transmittance",
          VR.kFD, VM.k1, false);
  static const PublicTag kChannelWidth
      //(0046,0042)
      =
      const PublicTag("ChannelWidth", 0x00460042, "Channel Width", VR.kFD, VM.k1, false);
  static const PublicTag kPupilSize
      //(0046,0044)
      = const PublicTag("PupilSize", 0x00460044, "Pupil Size", VR.kFD, VM.k1, false);
  static const PublicTag kCornealSize
      //(0046,0046)
      = const PublicTag("CornealSize", 0x00460046, "Corneal Size", VR.kFD, VM.k1, false);
  static const PublicTag kAutorefractionRightEyeSequence
      //(0046,0050)
      = const PublicTag("AutorefractionRightEyeSequence", 0x00460050,
          "Autorefraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAutorefractionLeftEyeSequence
      //(0046,0052)
      = const PublicTag("AutorefractionLeftEyeSequence", 0x00460052,
          "Autorefraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDistancePupillaryDistance
      //(0046,0060)
      = const PublicTag("DistancePupillaryDistance", 0x00460060,
          "Distance Pupillary Distance", VR.kFD, VM.k1, false);
  static const PublicTag kNearPupillaryDistance
      //(0046,0062)
      = const PublicTag("NearPupillaryDistance", 0x00460062, "Near Pupillary Distance",
          VR.kFD, VM.k1, false);
  static const PublicTag kIntermediatePupillaryDistance
      //(0046,0063)
      = const PublicTag("IntermediatePupillaryDistance", 0x00460063,
          "Intermediate Pupillary Distance", VR.kFD, VM.k1, false);
  static const PublicTag kOtherPupillaryDistance
      //(0046,0064)
      = const PublicTag("OtherPupillaryDistance", 0x00460064, "Other Pupillary Distance",
          VR.kFD, VM.k1, false);
  static const PublicTag kKeratometryRightEyeSequence
      //(0046,0070)
      = const PublicTag("KeratometryRightEyeSequence", 0x00460070,
          "Keratometry Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kKeratometryLeftEyeSequence
      //(0046,0071)
      = const PublicTag("KeratometryLeftEyeSequence", 0x00460071,
          "Keratometry Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSteepKeratometricAxisSequence
      //(0046,0074)
      = const PublicTag("SteepKeratometricAxisSequence", 0x00460074,
          "Steep Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRadiusOfCurvature
      //(0046,0075)
      = const PublicTag(
          "RadiusOfCurvature", 0x00460075, "Radius of Curvature", VR.kFD, VM.k1, false);
  static const PublicTag kKeratometricPower
      //(0046,0076)
      = const PublicTag(
          "KeratometricPower", 0x00460076, "Keratometric Power", VR.kFD, VM.k1, false);
  static const PublicTag kKeratometricAxis
      //(0046,0077)
      = const PublicTag(
          "KeratometricAxis", 0x00460077, "Keratometric Axis", VR.kFD, VM.k1, false);
  static const PublicTag kFlatKeratometricAxisSequence
      //(0046,0080)
      = const PublicTag("FlatKeratometricAxisSequence", 0x00460080,
          "Flat Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBackgroundColor
      //(0046,0092)
      = const PublicTag(
          "BackgroundColor", 0x00460092, "Background Color", VR.kCS, VM.k1, false);
  static const PublicTag kOptotype
      //(0046,0094)
      = const PublicTag("Optotype", 0x00460094, "Optotype", VR.kCS, VM.k1, false);
  static const PublicTag kOptotypePresentation
      //(0046,0095)
      = const PublicTag("OptotypePresentation", 0x00460095, "Optotype Presentation",
          VR.kCS, VM.k1, false);
  static const PublicTag kSubjectiveRefractionRightEyeSequence
      //(0046,0097)
      = const PublicTag("SubjectiveRefractionRightEyeSequence", 0x00460097,
          "Subjective Refraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSubjectiveRefractionLeftEyeSequence
      //(0046,0098)
      = const PublicTag("SubjectiveRefractionLeftEyeSequence", 0x00460098,
          "Subjective Refraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAddNearSequence
      //(0046,0100)
      = const PublicTag(
          "AddNearSequence", 0x00460100, "Add Near Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAddIntermediateSequence
      //(0046,0101)
      = const PublicTag("AddIntermediateSequence", 0x00460101,
          "Add Intermediate Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAddOtherSequence
      //(0046,0102)
      = const PublicTag(
          "AddOtherSequence", 0x00460102, "Add Other Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAddPower
      //(0046,0104)
      = const PublicTag("AddPower", 0x00460104, "Add Power", VR.kFD, VM.k1, false);
  static const PublicTag kViewingDistance
      //(0046,0106)
      = const PublicTag(
          "ViewingDistance", 0x00460106, "Viewing Distance", VR.kFD, VM.k1, false);
  static const PublicTag kVisualAcuityTypeCodeSequence
      //(0046,0121)
      = const PublicTag("VisualAcuityTypeCodeSequence", 0x00460121,
          "Visual Acuity Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualAcuityRightEyeSequence
      //(0046,0122)
      = const PublicTag("VisualAcuityRightEyeSequence", 0x00460122,
          "Visual Acuity Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualAcuityLeftEyeSequence
      //(0046,0123)
      = const PublicTag("VisualAcuityLeftEyeSequence", 0x00460123,
          "Visual Acuity Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVisualAcuityBothEyesOpenSequence
      //(0046,0124)
      = const PublicTag("VisualAcuityBothEyesOpenSequence", 0x00460124,
          "Visual Acuity Both Eyes Open Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kViewingDistanceType
      //(0046,0125)
      = const PublicTag("ViewingDistanceType", 0x00460125, "Viewing Distance Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kVisualAcuityModifiers
      //(0046,0135)
      = const PublicTag("VisualAcuityModifiers", 0x00460135, "Visual Acuity Modifiers",
          VR.kSS, VM.k2, false);
  static const PublicTag kDecimalVisualAcuity
      //(0046,0137)
      = const PublicTag("DecimalVisualAcuity", 0x00460137, "Decimal Visual Acuity",
          VR.kFD, VM.k1, false);
  static const PublicTag kOptotypeDetailedDefinition
      //(0046,0139)
      = const PublicTag("OptotypeDetailedDefinition", 0x00460139,
          "Optotype Detailed Definition", VR.kLO, VM.k1, false);
  static const PublicTag kReferencedRefractiveMeasurementsSequence
      //(0046,0145)
      = const PublicTag("ReferencedRefractiveMeasurementsSequence", 0x00460145,
          "Referenced Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpherePower
      //(0046,0146)
      = const PublicTag("SpherePower", 0x00460146, "Sphere Power", VR.kFD, VM.k1, false);
  static const PublicTag kCylinderPower
      //(0046,0147)
      = const PublicTag(
          "CylinderPower", 0x00460147, "Cylinder Power", VR.kFD, VM.k1, false);
  static const PublicTag kCornealTopographySurface
      //(0046,0201)
      = const PublicTag("CornealTopographySurface", 0x00460201,
          "Corneal Topography Surface", VR.kCS, VM.k1, false);
  static const PublicTag kCornealVertexLocation
      //(0046,0202)
      = const PublicTag("CornealVertexLocation", 0x00460202, "Corneal Vertex Location",
          VR.kFL, VM.k2, false);
  static const PublicTag kPupilCentroidXCoordinate
      //(0046,0203)
      = const PublicTag("PupilCentroidXCoordinate", 0x00460203,
          "Pupil Centroid X-Coordinate", VR.kFL, VM.k1, false);
  static const PublicTag kPupilCentroidYCoordinate
      //(0046,0204)
      = const PublicTag("PupilCentroidYCoordinate", 0x00460204,
          "Pupil Centroid Y-Coordinate", VR.kFL, VM.k1, false);
  static const PublicTag kEquivalentPupilRadius
      //(0046,0205)
      = const PublicTag("EquivalentPupilRadius", 0x00460205, "Equivalent Pupil Radius",
          VR.kFL, VM.k1, false);
  static const PublicTag kCornealTopographyMapTypeCodeSequence
      //(0046,0207)
      = const PublicTag("CornealTopographyMapTypeCodeSequence", 0x00460207,
          "Corneal Topography Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVerticesOfTheOutlineOfPupil
      //(0046,0208)
      = const PublicTag("VerticesOfTheOutlineOfPupil", 0x00460208,
          "Vertices of the Outline of Pupil", VR.kIS, VM.k2_2n, false);
  static const PublicTag kCornealTopographyMappingNormalsSequence
      //(0046,0210)
      = const PublicTag("CornealTopographyMappingNormalsSequence", 0x00460210,
          "Corneal Topography Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMaximumCornealCurvatureSequence
      //(0046,0211)
      = const PublicTag("MaximumCornealCurvatureSequence", 0x00460211,
          "Maximum Corneal Curvature Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMaximumCornealCurvature
      //(0046,0212)
      = const PublicTag("MaximumCornealCurvature", 0x00460212,
          "Maximum Corneal Curvature", VR.kFL, VM.k1, false);
  static const PublicTag kMaximumCornealCurvatureLocation
      //(0046,0213)
      = const PublicTag("MaximumCornealCurvatureLocation", 0x00460213,
          "Maximum Corneal Curvature Location", VR.kFL, VM.k2, false);
  static const PublicTag kMinimumKeratometricSequence
      //(0046,0215)
      = const PublicTag("MinimumKeratometricSequence", 0x00460215,
          "Minimum Keratometric Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSimulatedKeratometricCylinderSequence
      //(0046,0218)
      = const PublicTag("SimulatedKeratometricCylinderSequence", 0x00460218,
          "Simulated Keratometric Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAverageCornealPower
      //(0046,0220)
      = const PublicTag("AverageCornealPower", 0x00460220, "Average Corneal Power",
          VR.kFL, VM.k1, false);
  static const PublicTag kCornealISValue
      //(0046,0224)
      = const PublicTag(
          "CornealISValue", 0x00460224, "Corneal I-S Value", VR.kFL, VM.k1, false);
  static const PublicTag kAnalyzedArea
      //(0046,0227)
      =
      const PublicTag("AnalyzedArea", 0x00460227, "Analyzed Area", VR.kFL, VM.k1, false);
  static const PublicTag kSurfaceRegularityIndex
      //(0046,0230)
      = const PublicTag("SurfaceRegularityIndex", 0x00460230, "Surface Regularity Index",
          VR.kFL, VM.k1, false);
  static const PublicTag kSurfaceAsymmetryIndex
      //(0046,0232)
      = const PublicTag("SurfaceAsymmetryIndex", 0x00460232, "Surface Asymmetry Index",
          VR.kFL, VM.k1, false);
  static const PublicTag kCornealEccentricityIndex
      //(0046,0234)
      = const PublicTag("CornealEccentricityIndex", 0x00460234,
          "Corneal Eccentricity Index", VR.kFL, VM.k1, false);
  static const PublicTag kKeratoconusPredictionIndex
      //(0046,0236)
      = const PublicTag("KeratoconusPredictionIndex", 0x00460236,
          "Keratoconus Prediction Index", VR.kFL, VM.k1, false);
  static const PublicTag kDecimalPotentialVisualAcuity
      //(0046,0238)
      = const PublicTag("DecimalPotentialVisualAcuity", 0x00460238,
          "Decimal Potential Visual Acuity", VR.kFL, VM.k1, false);
  static const PublicTag kCornealTopographyMapQualityEvaluation
      //(0046,0242)
      = const PublicTag("CornealTopographyMapQualityEvaluation", 0x00460242,
          "Corneal Topography Map Quality Evaluation", VR.kCS, VM.k1, false);
  static const PublicTag kSourceImageCornealProcessedDataSequence
      //(0046,0244)
      = const PublicTag("SourceImageCornealProcessedDataSequence", 0x00460244,
          "Source Image Corneal Processed Data Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCornealPointLocation
      //(0046,0247)
      = const PublicTag("CornealPointLocation", 0x00460247, "Corneal Point Location",
          VR.kFL, VM.k3, false);
  static const PublicTag kCornealPointEstimated
      //(0046,0248)
      = const PublicTag("CornealPointEstimated", 0x00460248, "Corneal Point Estimated",
          VR.kCS, VM.k1, false);
  static const PublicTag kAxialPower
      //(0046,0249)
      = const PublicTag("AxialPower", 0x00460249, "Axial Power", VR.kFL, VM.k1, false);
  static const PublicTag kTangentialPower
      //(0046,0250)
      = const PublicTag(
          "TangentialPower", 0x00460250, "Tangential Power", VR.kFL, VM.k1, false);
  static const PublicTag kRefractivePower
      //(0046,0251)
      = const PublicTag(
          "RefractivePower", 0x00460251, "Refractive Power", VR.kFL, VM.k1, false);
  static const PublicTag kRelativeElevation
      //(0046,0252)
      = const PublicTag(
          "RelativeElevation", 0x00460252, "Relative Elevation", VR.kFL, VM.k1, false);
  static const PublicTag kCornealWavefront
      //(0046,0253)
      = const PublicTag(
          "CornealWavefront", 0x00460253, "Corneal Wavefront", VR.kFL, VM.k1, false);
  static const PublicTag kImagedVolumeWidth
      //(0048,0001)
      = const PublicTag(
          "ImagedVolumeWidth", 0x00480001, "Imaged Volume Width", VR.kFL, VM.k1, false);
  static const PublicTag kImagedVolumeHeight
      //(0048,0002)
      = const PublicTag(
          "ImagedVolumeHeight", 0x00480002, "Imaged Volume Height", VR.kFL, VM.k1, false);
  static const PublicTag kImagedVolumeDepth
      //(0048,0003)
      = const PublicTag(
          "ImagedVolumeDepth", 0x00480003, "Imaged Volume Depth", VR.kFL, VM.k1, false);
  static const PublicTag kTotalPixelMatrixColumns
      //(0048,0006)
      = const PublicTag("TotalPixelMatrixColumns", 0x00480006,
          "Total Pixel Matrix Columns", VR.kUL, VM.k1, false);
  static const PublicTag kTotalPixelMatrixRows
      //(0048,0007)
      = const PublicTag("TotalPixelMatrixRows", 0x00480007, "Total Pixel Matrix Rows",
          VR.kUL, VM.k1, false);
  static const PublicTag kTotalPixelMatrixOriginSequence
      //(0048,0008)
      = const PublicTag("TotalPixelMatrixOriginSequence", 0x00480008,
          "Total Pixel Matrix Origin Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenLabelInImage
      //(0048,0010)
      = const PublicTag("SpecimenLabelInImage", 0x00480010, "Specimen Label in Image",
          VR.kCS, VM.k1, false);
  static const PublicTag kFocusMethod
      //(0048,0011)
      = const PublicTag("FocusMethod", 0x00480011, "Focus Method", VR.kCS, VM.k1, false);
  static const PublicTag kExtendedDepthOfField
      //(0048,0012)
      = const PublicTag("ExtendedDepthOfField", 0x00480012, "Extended Depth of Field",
          VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfFocalPlanes
      //(0048,0013)
      = const PublicTag("NumberOfFocalPlanes", 0x00480013, "Number of Focal Planes",
          VR.kUS, VM.k1, false);
  static const PublicTag kDistanceBetweenFocalPlanes
      //(0048,0014)
      = const PublicTag("DistanceBetweenFocalPlanes", 0x00480014,
          "Distance Between Focal Planes", VR.kFL, VM.k1, false);
  static const PublicTag kRecommendedAbsentPixelCIELabValue
      //(0048,0015)
      = const PublicTag("RecommendedAbsentPixelCIELabValue", 0x00480015,
          "Recommended Absent Pixel CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kIlluminatorTypeCodeSequence
      //(0048,0100)
      = const PublicTag("IlluminatorTypeCodeSequence", 0x00480100,
          "Illuminator Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageOrientationSlide
      //(0048,0102)
      = const PublicTag("ImageOrientationSlide", 0x00480102, "Image Orientation (Slide)",
          VR.kDS, VM.k6, false);
  static const PublicTag kOpticalPathSequence
      //(0048,0105)
      = const PublicTag("OpticalPathSequence", 0x00480105, "Optical Path Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kOpticalPathIdentifier
      //(0048,0106)
      = const PublicTag("OpticalPathIdentifier", 0x00480106, "Optical Path Identifier",
          VR.kSH, VM.k1, false);
  static const PublicTag kOpticalPathDescription
      //(0048,0107)
      = const PublicTag("OpticalPathDescription", 0x00480107, "Optical Path Description",
          VR.kST, VM.k1, false);
  static const PublicTag kIlluminationColorCodeSequence
      //(0048,0108)
      = const PublicTag("IlluminationColorCodeSequence", 0x00480108,
          "Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecimenReferenceSequence
      //(0048,0110)
      = const PublicTag("SpecimenReferenceSequence", 0x00480110,
          "Specimen Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCondenserLensPower
      //(0048,0111)
      = const PublicTag(
          "CondenserLensPower", 0x00480111, "Condenser Lens Power", VR.kDS, VM.k1, false);
  static const PublicTag kObjectiveLensPower
      //(0048,0112)
      = const PublicTag(
          "ObjectiveLensPower", 0x00480112, "Objective Lens Power", VR.kDS, VM.k1, false);
  static const PublicTag kObjectiveLensNumericalAperture
      //(0048,0113)
      = const PublicTag("ObjectiveLensNumericalAperture", 0x00480113,
          "Objective Lens Numerical Aperture", VR.kDS, VM.k1, false);
  static const PublicTag kPaletteColorLookupTableSequence
      //(0048,0120)
      = const PublicTag("PaletteColorLookupTableSequence", 0x00480120,
          "Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedImageNavigationSequence
      //(0048,0200)
      = const PublicTag("ReferencedImageNavigationSequence", 0x00480200,
          "Referenced Image Navigation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTopLeftHandCornerOfLocalizerArea
      //(0048,0201)
      = const PublicTag("TopLeftHandCornerOfLocalizerArea", 0x00480201,
          "Top Left Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const PublicTag kBottomRightHandCornerOfLocalizerArea
      //(0048,0202)
      = const PublicTag("BottomRightHandCornerOfLocalizerArea", 0x00480202,
          "Bottom Right Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const PublicTag kOpticalPathIdentificationSequence
      //(0048,0207)
      = const PublicTag("OpticalPathIdentificationSequence", 0x00480207,
          "Optical Path Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlanePositionSlideSequence
      //(0048,021A)
      = const PublicTag("PlanePositionSlideSequence", 0x0048021A,
          "Plane Position (Slide) Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kColumnPositionInTotalImagePixelMatrix
      //(0048,021E)
      = const PublicTag("ColumnPositionInTotalImagePixelMatrix", 0x0048021E,
          "Column Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const PublicTag kRowPositionInTotalImagePixelMatrix
      //(0048,021F)
      = const PublicTag("RowPositionInTotalImagePixelMatrix", 0x0048021F,
          "Row Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const PublicTag kPixelOriginInterpretation
      //(0048,0301)
      = const PublicTag("PixelOriginInterpretation", 0x00480301,
          "Pixel Origin Interpretation", VR.kCS, VM.k1, false);
  static const PublicTag kCalibrationImage
      //(0050,0004)
      = const PublicTag(
          "CalibrationImage", 0x00500004, "Calibration Image", VR.kCS, VM.k1, false);
  static const PublicTag kDeviceSequence
      //(0050,0010)
      = const PublicTag(
          "DeviceSequence", 0x00500010, "Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContainerComponentTypeCodeSequence
      //(0050,0012)
      = const PublicTag("ContainerComponentTypeCodeSequence", 0x00500012,
          "Container Component Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContainerComponentThickness
      //(0050,0013)
      = const PublicTag("ContainerComponentThickness", 0x00500013,
          "Container Component Thickness", VR.kFD, VM.k1, false);
  static const PublicTag kDeviceLength
      //(0050,0014)
      =
      const PublicTag("DeviceLength", 0x00500014, "Device Length", VR.kDS, VM.k1, false);
  static const PublicTag kContainerComponentWidth
      //(0050,0015)
      = const PublicTag("ContainerComponentWidth", 0x00500015,
          "Container Component Width", VR.kFD, VM.k1, false);
  static const PublicTag kDeviceDiameter
      //(0050,0016)
      = const PublicTag(
          "DeviceDiameter", 0x00500016, "Device Diameter", VR.kDS, VM.k1, false);
  static const PublicTag kDeviceDiameterUnits
      //(0050,0017)
      = const PublicTag("DeviceDiameterUnits", 0x00500017, "Device Diameter Units",
          VR.kCS, VM.k1, false);
  static const PublicTag kDeviceVolume
      //(0050,0018)
      =
      const PublicTag("DeviceVolume", 0x00500018, "Device Volume", VR.kDS, VM.k1, false);
  static const PublicTag kInterMarkerDistance
      //(0050,0019)
      = const PublicTag("InterMarkerDistance", 0x00500019, "Inter-Marker Distance",
          VR.kDS, VM.k1, false);
  static const PublicTag kContainerComponentMaterial
      //(0050,001A)
      = const PublicTag("ContainerComponentMaterial", 0x0050001A,
          "Container Component Material", VR.kCS, VM.k1, false);
  static const PublicTag kContainerComponentID
      //(0050,001B)
      = const PublicTag("ContainerComponentID", 0x0050001B, "Container Component ID",
          VR.kLO, VM.k1, false);
  static const PublicTag kContainerComponentLength
      //(0050,001C)
      = const PublicTag("ContainerComponentLength", 0x0050001C,
          "Container Component Length", VR.kFD, VM.k1, false);
  static const PublicTag kContainerComponentDiameter
      //(0050,001D)
      = const PublicTag("ContainerComponentDiameter", 0x0050001D,
          "Container Component Diameter", VR.kFD, VM.k1, false);
  static const PublicTag kContainerComponentDescription
      //(0050,001E)
      = const PublicTag("ContainerComponentDescription", 0x0050001E,
          "Container Component Description", VR.kLO, VM.k1, false);
  static const PublicTag kDeviceDescription
      //(0050,0020)
      = const PublicTag(
          "DeviceDescription", 0x00500020, "Device Description", VR.kLO, VM.k1, false);
  static const PublicTag kContrastBolusIngredientPercentByVolume
      //(0052,0001)
      = const PublicTag("ContrastBolusIngredientPercentByVolume", 0x00520001,
          "Contrast/Bolus Ingredient Percent by Volume", VR.kFL, VM.k1, false);
  static const PublicTag kOCTFocalDistance
      //(0052,0002)
      = const PublicTag(
          "OCTFocalDistance", 0x00520002, "OCT Focal Distance", VR.kFD, VM.k1, false);
  static const PublicTag kBeamSpotSize
      //(0052,0003)
      =
      const PublicTag("BeamSpotSize", 0x00520003, "Beam Spot Size", VR.kFD, VM.k1, false);
  static const PublicTag kEffectiveRefractiveIndex
      //(0052,0004)
      = const PublicTag("EffectiveRefractiveIndex", 0x00520004,
          "Effective Refractive Index", VR.kFD, VM.k1, false);
  static const PublicTag kOCTAcquisitionDomain
      //(0052,0006)
      = const PublicTag("OCTAcquisitionDomain", 0x00520006, "OCT Acquisition Domain",
          VR.kCS, VM.k1, false);
  static const PublicTag kOCTOpticalCenterWavelength
      //(0052,0007)
      = const PublicTag("OCTOpticalCenterWavelength", 0x00520007,
          "OCT Optical Center Wavelength", VR.kFD, VM.k1, false);
  static const PublicTag kAxialResolution
      //(0052,0008)
      = const PublicTag(
          "AxialResolution", 0x00520008, "Axial Resolution", VR.kFD, VM.k1, false);
  static const PublicTag kRangingDepth
      //(0052,0009)
      =
      const PublicTag("RangingDepth", 0x00520009, "Ranging Depth", VR.kFD, VM.k1, false);
  static const PublicTag kALineRate
      //(0052,0011)
      = const PublicTag("ALineRate", 0x00520011, "A-line Rate", VR.kFD, VM.k1, false);
  static const PublicTag kALinesPerFrame
      //(0052,0012)
      = const PublicTag(
          "ALinesPerFrame", 0x00520012, "A-lines Per Frame", VR.kUS, VM.k1, false);
  static const PublicTag kCatheterRotationalRate
      //(0052,0013)
      = const PublicTag("CatheterRotationalRate", 0x00520013, "Catheter Rotational Rate",
          VR.kFD, VM.k1, false);
  static const PublicTag kALinePixelSpacing
      //(0052,0014)
      = const PublicTag(
          "ALinePixelSpacing", 0x00520014, "A-line Pixel Spacing", VR.kFD, VM.k1, false);
  static const PublicTag kModeOfPercutaneousAccessSequence
      //(0052,0016)
      = const PublicTag("ModeOfPercutaneousAccessSequence", 0x00520016,
          "Mode of Percutaneous Access Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIntravascularOCTFrameTypeSequence
      //(0052,0025)
      = const PublicTag("IntravascularOCTFrameTypeSequence", 0x00520025,
          "Intravascular OCT Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOCTZOffsetApplied
      //(0052,0026)
      = const PublicTag(
          "OCTZOffsetApplied", 0x00520026, "OCT Z Offset Applied", VR.kCS, VM.k1, false);
  static const PublicTag kIntravascularFrameContentSequence
      //(0052,0027)
      = const PublicTag("IntravascularFrameContentSequence", 0x00520027,
          "Intravascular Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIntravascularLongitudinalDistance
      //(0052,0028)
      = const PublicTag("IntravascularLongitudinalDistance", 0x00520028,
          "Intravascular Longitudinal Distance", VR.kFD, VM.k1, false);
  static const PublicTag kIntravascularOCTFrameContentSequence
      //(0052,0029)
      = const PublicTag("IntravascularOCTFrameContentSequence", 0x00520029,
          "Intravascular OCT Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOCTZOffsetCorrection
      //(0052,0030)
      = const PublicTag("OCTZOffsetCorrection", 0x00520030, "OCT Z Offset Correction",
          VR.kSS, VM.k1, false);
  static const PublicTag kCatheterDirectionOfRotation
      //(0052,0031)
      = const PublicTag("CatheterDirectionOfRotation", 0x00520031,
          "Catheter Direction of Rotation", VR.kCS, VM.k1, false);
  static const PublicTag kSeamLineLocation
      //(0052,0033)
      = const PublicTag(
          "SeamLineLocation", 0x00520033, "Seam Line Location", VR.kFD, VM.k1, false);
  static const PublicTag kFirstALineLocation
      //(0052,0034)
      = const PublicTag("FirstALineLocation", 0x00520034, "First A-line Location", VR.kFD,
          VM.k1, false);
  static const PublicTag kSeamLineIndex
      //(0052,0036)
      = const PublicTag(
          "SeamLineIndex", 0x00520036, "Seam Line Index", VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfPaddedALines
      //(0052,0038)
      = const PublicTag("NumberOfPaddedALines", 0x00520038, "Number of Padded A-lines",
          VR.kUS, VM.k1, false);
  static const PublicTag kInterpolationType
      //(0052,0039)
      = const PublicTag(
          "InterpolationType", 0x00520039, "Interpolation Type", VR.kCS, VM.k1, false);
  static const PublicTag kRefractiveIndexApplied
      //(0052,003A)
      = const PublicTag("RefractiveIndexApplied", 0x0052003A, "Refractive Index Applied",
          VR.kCS, VM.k1, false);
  static const PublicTag kEnergyWindowVector
      //(0054,0010)
      = const PublicTag("EnergyWindowVector", 0x00540010, "Energy Window Vector", VR.kUS,
          VM.k1_n, false);
  static const PublicTag kNumberOfEnergyWindows
      //(0054,0011)
      = const PublicTag("NumberOfEnergyWindows", 0x00540011, "Number of Energy Windows",
          VR.kUS, VM.k1, false);
  static const PublicTag kEnergyWindowInformationSequence
      //(0054,0012)
      = const PublicTag("EnergyWindowInformationSequence", 0x00540012,
          "Energy Window Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEnergyWindowRangeSequence
      //(0054,0013)
      = const PublicTag("EnergyWindowRangeSequence", 0x00540013,
          "Energy Window Range Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEnergyWindowLowerLimit
      //(0054,0014)
      = const PublicTag("EnergyWindowLowerLimit", 0x00540014, "Energy Window Lower Limit",
          VR.kDS, VM.k1, false);
  static const PublicTag kEnergyWindowUpperLimit
      //(0054,0015)
      = const PublicTag("EnergyWindowUpperLimit", 0x00540015, "Energy Window Upper Limit",
          VR.kDS, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalInformationSequence
      //(0054,0016)
      = const PublicTag("RadiopharmaceuticalInformationSequence", 0x00540016,
          "Radiopharmaceutical Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kResidualSyringeCounts
      //(0054,0017)
      = const PublicTag("ResidualSyringeCounts", 0x00540017, "Residual Syringe Counts",
          VR.kIS, VM.k1, false);
  static const PublicTag kEnergyWindowName
      //(0054,0018)
      = const PublicTag(
          "EnergyWindowName", 0x00540018, "Energy Window Name", VR.kSH, VM.k1, false);
  static const PublicTag kDetectorVector
      //(0054,0020)
      = const PublicTag(
          "DetectorVector", 0x00540020, "Detector Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfDetectors
      //(0054,0021)
      = const PublicTag(
          "NumberOfDetectors", 0x00540021, "Number of Detectors", VR.kUS, VM.k1, false);
  static const PublicTag kDetectorInformationSequence
      //(0054,0022)
      = const PublicTag("DetectorInformationSequence", 0x00540022,
          "Detector Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPhaseVector
      //(0054,0030)
      =
      const PublicTag("PhaseVector", 0x00540030, "Phase Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfPhases
      //(0054,0031)
      = const PublicTag(
          "NumberOfPhases", 0x00540031, "Number of Phases", VR.kUS, VM.k1, false);
  static const PublicTag kPhaseInformationSequence
      //(0054,0032)
      = const PublicTag("PhaseInformationSequence", 0x00540032,
          "Phase Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfFramesInPhase
      //(0054,0033)
      = const PublicTag("NumberOfFramesInPhase", 0x00540033, "Number of Frames in Phase",
          VR.kUS, VM.k1, false);
  static const PublicTag kPhaseDelay
      //(0054,0036)
      = const PublicTag("PhaseDelay", 0x00540036, "Phase Delay", VR.kIS, VM.k1, false);
  static const PublicTag kPauseBetweenFrames
      //(0054,0038)
      = const PublicTag(
          "PauseBetweenFrames", 0x00540038, "Pause Between Frames", VR.kIS, VM.k1, false);
  static const PublicTag kPhaseDescription
      //(0054,0039)
      = const PublicTag(
          "PhaseDescription", 0x00540039, "Phase Description", VR.kCS, VM.k1, false);
  static const PublicTag kRotationVector
      //(0054,0050)
      = const PublicTag(
          "RotationVector", 0x00540050, "Rotation Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfRotations
      //(0054,0051)
      = const PublicTag(
          "NumberOfRotations", 0x00540051, "Number of Rotations", VR.kUS, VM.k1, false);
  static const PublicTag kRotationInformationSequence
      //(0054,0052)
      = const PublicTag("RotationInformationSequence", 0x00540052,
          "Rotation Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfFramesInRotation
      //(0054,0053)
      = const PublicTag("NumberOfFramesInRotation", 0x00540053,
          "Number of Frames in Rotation", VR.kUS, VM.k1, false);
  static const PublicTag kRRIntervalVector
      //(0054,0060)
      = const PublicTag(
          "RRIntervalVector", 0x00540060, "R-R Interval Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfRRIntervals
      //(0054,0061)
      = const PublicTag("NumberOfRRIntervals", 0x00540061, "Number of R-R Intervals",
          VR.kUS, VM.k1, false);
  static const PublicTag kGatedInformationSequence
      //(0054,0062)
      = const PublicTag("GatedInformationSequence", 0x00540062,
          "Gated Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDataInformationSequence
      //(0054,0063)
      = const PublicTag("DataInformationSequence", 0x00540063,
          "Data Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTimeSlotVector
      //(0054,0070)
      = const PublicTag(
          "TimeSlotVector", 0x00540070, "Time Slot Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfTimeSlots
      //(0054,0071)
      = const PublicTag(
          "NumberOfTimeSlots", 0x00540071, "Number of Time Slots", VR.kUS, VM.k1, false);
  static const PublicTag kTimeSlotInformationSequence
      //(0054,0072)
      = const PublicTag("TimeSlotInformationSequence", 0x00540072,
          "Time Slot Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTimeSlotTime
      //(0054,0073)
      =
      const PublicTag("TimeSlotTime", 0x00540073, "Time Slot Time", VR.kDS, VM.k1, false);
  static const PublicTag kSliceVector
      //(0054,0080)
      =
      const PublicTag("SliceVector", 0x00540080, "Slice Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfSlices
      //(0054,0081)
      = const PublicTag(
          "NumberOfSlices", 0x00540081, "Number of Slices", VR.kUS, VM.k1, false);
  static const PublicTag kAngularViewVector
      //(0054,0090)
      = const PublicTag(
          "AngularViewVector", 0x00540090, "Angular View Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kTimeSliceVector
      //(0054,0100)
      = const PublicTag(
          "TimeSliceVector", 0x00540100, "Time Slice Vector", VR.kUS, VM.k1_n, false);
  static const PublicTag kNumberOfTimeSlices
      //(0054,0101)
      = const PublicTag("NumberOfTimeSlices", 0x00540101, "Number of Time Slices", VR.kUS,
          VM.k1, false);
  static const PublicTag kStartAngle
      //(0054,0200)
      = const PublicTag("StartAngle", 0x00540200, "Start Angle", VR.kDS, VM.k1, false);
  static const PublicTag kTypeOfDetectorMotion
      //(0054,0202)
      = const PublicTag("TypeOfDetectorMotion", 0x00540202, "Type of Detector Motion",
          VR.kCS, VM.k1, false);
  static const PublicTag kTriggerVector
      //(0054,0210)
      = const PublicTag(
          "TriggerVector", 0x00540210, "Trigger Vector", VR.kIS, VM.k1_n, false);
  static const PublicTag kNumberOfTriggersInPhase
      //(0054,0211)
      = const PublicTag("NumberOfTriggersInPhase", 0x00540211,
          "Number of Triggers in Phase", VR.kUS, VM.k1, false);
  static const PublicTag kViewCodeSequence
      //(0054,0220)
      = const PublicTag(
          "ViewCodeSequence", 0x00540220, "View Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kViewModifierCodeSequence
      //(0054,0222)
      = const PublicTag("ViewModifierCodeSequence", 0x00540222,
          "View Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRadionuclideCodeSequence
      //(0054,0300)
      = const PublicTag("RadionuclideCodeSequence", 0x00540300,
          "Radionuclide Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAdministrationRouteCodeSequence
      //(0054,0302)
      = const PublicTag("AdministrationRouteCodeSequence", 0x00540302,
          "Administration Route Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRadiopharmaceuticalCodeSequence
      //(0054,0304)
      = const PublicTag("RadiopharmaceuticalCodeSequence", 0x00540304,
          "Radiopharmaceutical Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCalibrationDataSequence
      //(0054,0306)
      = const PublicTag("CalibrationDataSequence", 0x00540306,
          "Calibration Data Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEnergyWindowNumber
      //(0054,0308)
      = const PublicTag(
          "EnergyWindowNumber", 0x00540308, "Energy Window Number", VR.kUS, VM.k1, false);
  static const PublicTag kImageID
      //(0054,0400)
      = const PublicTag("ImageID", 0x00540400, "Image ID", VR.kSH, VM.k1, false);
  static const PublicTag kPatientOrientationCodeSequence
      //(0054,0410)
      = const PublicTag("PatientOrientationCodeSequence", 0x00540410,
          "Patient Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientOrientationModifierCodeSequence
      //(0054,0412)
      = const PublicTag("PatientOrientationModifierCodeSequence", 0x00540412,
          "Patient Orientation Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPatientGantryRelationshipCodeSequence
      //(0054,0414)
      = const PublicTag("PatientGantryRelationshipCodeSequence", 0x00540414,
          "Patient Gantry Relationship Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSliceProgressionDirection
      //(0054,0500)
      = const PublicTag("SliceProgressionDirection", 0x00540500,
          "Slice Progression Direction", VR.kCS, VM.k1, false);
  static const PublicTag kSeriesType
      //(0054,1000)
      = const PublicTag("SeriesType", 0x00541000, "Series Type", VR.kCS, VM.k2, false);
  static const PublicTag kUnits
      //(0054,1001)
      = const PublicTag("Units", 0x00541001, "Units", VR.kCS, VM.k1, false);
  static const PublicTag kCountsSource
      //(0054,1002)
      =
      const PublicTag("CountsSource", 0x00541002, "Counts Source", VR.kCS, VM.k1, false);
  static const PublicTag kReprojectionMethod
      //(0054,1004)
      = const PublicTag(
          "ReprojectionMethod", 0x00541004, "Reprojection Method", VR.kCS, VM.k1, false);
  static const PublicTag kSUVType
      //(0054,1006)
      = const PublicTag("SUVType", 0x00541006, "SUV Type", VR.kCS, VM.k1, false);
  static const PublicTag kRandomsCorrectionMethod
      //(0054,1100)
      = const PublicTag("RandomsCorrectionMethod", 0x00541100,
          "Randoms Correction Method", VR.kCS, VM.k1, false);
  static const PublicTag kAttenuationCorrectionMethod
      //(0054,1101)
      = const PublicTag("AttenuationCorrectionMethod", 0x00541101,
          "Attenuation Correction Method", VR.kLO, VM.k1, false);
  static const PublicTag kDecayCorrection
      //(0054,1102)
      = const PublicTag(
          "DecayCorrection", 0x00541102, "Decay Correction", VR.kCS, VM.k1, false);
  static const PublicTag kReconstructionMethod
      //(0054,1103)
      = const PublicTag("ReconstructionMethod", 0x00541103, "Reconstruction Method",
          VR.kLO, VM.k1, false);
  static const PublicTag kDetectorLinesOfResponseUsed
      //(0054,1104)
      = const PublicTag("DetectorLinesOfResponseUsed", 0x00541104,
          "Detector Lines of Response Used", VR.kLO, VM.k1, false);
  static const PublicTag kScatterCorrectionMethod
      //(0054,1105)
      = const PublicTag("ScatterCorrectionMethod", 0x00541105,
          "Scatter Correction Method", VR.kLO, VM.k1, false);
  static const PublicTag kAxialAcceptance
      //(0054,1200)
      = const PublicTag(
          "AxialAcceptance", 0x00541200, "Axial Acceptance", VR.kDS, VM.k1, false);
  static const PublicTag kAxialMash
      //(0054,1201)
      = const PublicTag("AxialMash", 0x00541201, "Axial Mash", VR.kIS, VM.k2, false);
  static const PublicTag kTransverseMash
      //(0054,1202)
      = const PublicTag(
          "TransverseMash", 0x00541202, "Transverse Mash", VR.kIS, VM.k1, false);
  static const PublicTag kDetectorElementSize
      //(0054,1203)
      = const PublicTag("DetectorElementSize", 0x00541203, "Detector Element Size",
          VR.kDS, VM.k2, false);
  static const PublicTag kCoincidenceWindowWidth
      //(0054,1210)
      = const PublicTag("CoincidenceWindowWidth", 0x00541210, "Coincidence Window Width",
          VR.kDS, VM.k1, false);
  static const PublicTag kSecondaryCountsType
      //(0054,1220)
      = const PublicTag("SecondaryCountsType", 0x00541220, "Secondary Counts Type",
          VR.kCS, VM.k1_n, false);
  static const PublicTag kFrameReferenceTime
      //(0054,1300)
      = const PublicTag(
          "FrameReferenceTime", 0x00541300, "Frame Reference Time", VR.kDS, VM.k1, false);
  static const PublicTag kPrimaryPromptsCountsAccumulated
      //(0054,1310)
      = const PublicTag("PrimaryPromptsCountsAccumulated", 0x00541310,
          "Primary (Prompts) Counts Accumulated", VR.kIS, VM.k1, false);
  static const PublicTag kSecondaryCountsAccumulated
      //(0054,1311)
      = const PublicTag("SecondaryCountsAccumulated", 0x00541311,
          "Secondary Counts Accumulated", VR.kIS, VM.k1_n, false);
  static const PublicTag kSliceSensitivityFactor
      //(0054,1320)
      = const PublicTag("SliceSensitivityFactor", 0x00541320, "Slice Sensitivity Factor",
          VR.kDS, VM.k1, false);
  static const PublicTag kDecayFactor
      //(0054,1321)
      = const PublicTag("DecayFactor", 0x00541321, "Decay Factor", VR.kDS, VM.k1, false);
  static const PublicTag kDoseCalibrationFactor
      //(0054,1322)
      = const PublicTag("DoseCalibrationFactor", 0x00541322, "Dose Calibration Factor",
          VR.kDS, VM.k1, false);
  static const PublicTag kScatterFractionFactor
      //(0054,1323)
      = const PublicTag("ScatterFractionFactor", 0x00541323, "Scatter Fraction Factor",
          VR.kDS, VM.k1, false);
  static const PublicTag kDeadTimeFactor
      //(0054,1324)
      = const PublicTag(
          "DeadTimeFactor", 0x00541324, "Dead Time Factor", VR.kDS, VM.k1, false);
  static const PublicTag kImageIndex
      //(0054,1330)
      = const PublicTag("ImageIndex", 0x00541330, "Image Index", VR.kUS, VM.k1, false);
  static const PublicTag kCountsIncluded
      //(0054,1400)
      = const PublicTag(
          "CountsIncluded", 0x00541400, "Counts Included", VR.kCS, VM.k1_n, true);
  static const PublicTag kDeadTimeCorrectionFlag
      //(0054,1401)
      = const PublicTag("DeadTimeCorrectionFlag", 0x00541401, "Dead Time Correction Flag",
          VR.kCS, VM.k1, true);
  static const PublicTag kHistogramSequence
      //(0060,3000)
      = const PublicTag(
          "HistogramSequence", 0x00603000, "Histogram Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHistogramNumberOfBins
      //(0060,3002)
      = const PublicTag("HistogramNumberOfBins", 0x00603002, "Histogram Number of Bins",
          VR.kUS, VM.k1, false);
  static const PublicTag kHistogramFirstBinValue
      //(0060,3004)
      = const PublicTag("HistogramFirstBinValue", 0x00603004, "Histogram First Bin Value",
          VR.kUSSS, VM.k1, false);
  static const PublicTag kHistogramLastBinValue
      //(0060,3006)
      = const PublicTag("HistogramLastBinValue", 0x00603006, "Histogram Last Bin Value",
          VR.kUSSS, VM.k1, false);
  static const PublicTag kHistogramBinWidth
      //(0060,3008)
      = const PublicTag(
          "HistogramBinWidth", 0x00603008, "Histogram Bin Width", VR.kUS, VM.k1, false);
  static const PublicTag kHistogramExplanation
      //(0060,3010)
      = const PublicTag("HistogramExplanation", 0x00603010, "Histogram Explanation",
          VR.kLO, VM.k1, false);
  static const PublicTag kHistogramData
      //(0060,3020)
      = const PublicTag(
          "HistogramData", 0x00603020, "Histogram Data", VR.kUL, VM.k1_n, false);
  static const PublicTag kSegmentationType
      //(0062,0001)
      = const PublicTag(
          "SegmentationType", 0x00620001, "Segmentation Type", VR.kCS, VM.k1, false);
  static const PublicTag kSegmentSequence
      //(0062,0002)
      = const PublicTag(
          "SegmentSequence", 0x00620002, "Segment Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSegmentedPropertyCategoryCodeSequence
      //(0062,0003)
      = const PublicTag("SegmentedPropertyCategoryCodeSequence", 0x00620003,
          "Segmented Property Category Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSegmentNumber
      //(0062,0004)
      = const PublicTag(
          "SegmentNumber", 0x00620004, "Segment Number", VR.kUS, VM.k1, false);
  static const PublicTag kSegmentLabel
      //(0062,0005)
      =
      const PublicTag("SegmentLabel", 0x00620005, "Segment Label", VR.kLO, VM.k1, false);
  static const PublicTag kSegmentDescription
      //(0062,0006)
      = const PublicTag(
          "SegmentDescription", 0x00620006, "Segment Description", VR.kST, VM.k1, false);
  static const PublicTag kSegmentAlgorithmType
      //(0062,0008)
      = const PublicTag("SegmentAlgorithmType", 0x00620008, "Segment Algorithm Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kSegmentAlgorithmName
      //(0062,0009)
      = const PublicTag("SegmentAlgorithmName", 0x00620009, "Segment Algorithm Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kSegmentIdentificationSequence
      //(0062,000A)
      = const PublicTag("SegmentIdentificationSequence", 0x0062000A,
          "Segment Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSegmentNumber
      //(0062,000B)
      = const PublicTag("ReferencedSegmentNumber", 0x0062000B,
          "Referenced Segment Number", VR.kUS, VM.k1_n, false);
  static const PublicTag kRecommendedDisplayGrayscaleValue
      //(0062,000C)
      = const PublicTag("RecommendedDisplayGrayscaleValue", 0x0062000C,
          "Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const PublicTag kRecommendedDisplayCIELabValue
      //(0062,000D)
      = const PublicTag("RecommendedDisplayCIELabValue", 0x0062000D,
          "Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kMaximumFractionalValue
      //(0062,000E)
      = const PublicTag("MaximumFractionalValue", 0x0062000E, "Maximum Fractional Value",
          VR.kUS, VM.k1, false);
  static const PublicTag kSegmentedPropertyTypeCodeSequence
      //(0062,000F)
      = const PublicTag("SegmentedPropertyTypeCodeSequence", 0x0062000F,
          "Segmented Property Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSegmentationFractionalType
      //(0062,0010)
      = const PublicTag("SegmentationFractionalType", 0x00620010,
          "Segmentation Fractional Type", VR.kCS, VM.k1, false);
  static const PublicTag kSegmentedPropertyTypeModifierCodeSequence
      //(0062,0011)
      = const PublicTag("SegmentedPropertyTypeModifierCodeSequence", 0x00620011,
          "Segmented Property Type Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kUsedSegmentsSequence
      //(0062,0012)
      = const PublicTag("UsedSegmentsSequence", 0x00620012, "Used Segments Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDeformableRegistrationSequence
      //(0064,0002)
      = const PublicTag("DeformableRegistrationSequence", 0x00640002,
          "Deformable Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceFrameOfReferenceUID
      //(0064,0003)
      = const PublicTag("SourceFrameOfReferenceUID", 0x00640003,
          "Source Frame of Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kDeformableRegistrationGridSequence
      //(0064,0005)
      = const PublicTag("DeformableRegistrationGridSequence", 0x00640005,
          "Deformable Registration Grid Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGridDimensions
      //(0064,0007)
      = const PublicTag(
          "GridDimensions", 0x00640007, "Grid Dimensions", VR.kUL, VM.k3, false);
  static const PublicTag kGridResolution
      //(0064,0008)
      = const PublicTag(
          "GridResolution", 0x00640008, "Grid Resolution", VR.kFD, VM.k3, false);
  static const PublicTag kVectorGridData
      //(0064,0009)
      = const PublicTag(
          "VectorGridData", 0x00640009, "Vector Grid Data", VR.kOF, VM.k1, false);
  static const PublicTag kPreDeformationMatrixRegistrationSequence
      //(0064,000F)
      = const PublicTag("PreDeformationMatrixRegistrationSequence", 0x0064000F,
          "Pre Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPostDeformationMatrixRegistrationSequence
      //(0064,0010)
      = const PublicTag("PostDeformationMatrixRegistrationSequence", 0x00640010,
          "Post Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfSurfaces
      //(0066,0001)
      = const PublicTag(
          "NumberOfSurfaces", 0x00660001, "Number of Surfaces", VR.kUL, VM.k1, false);
  static const PublicTag kSurfaceSequence
      //(0066,0002)
      = const PublicTag(
          "SurfaceSequence", 0x00660002, "Surface Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurfaceNumber
      //(0066,0003)
      = const PublicTag(
          "SurfaceNumber", 0x00660003, "Surface Number", VR.kUL, VM.k1, false);
  static const PublicTag kSurfaceComments
      //(0066,0004)
      = const PublicTag(
          "SurfaceComments", 0x00660004, "Surface Comments", VR.kLT, VM.k1, false);
  static const PublicTag kSurfaceProcessing
      //(0066,0009)
      = const PublicTag(
          "SurfaceProcessing", 0x00660009, "Surface Processing", VR.kCS, VM.k1, false);
  static const PublicTag kSurfaceProcessingRatio
      //(0066,000A)
      = const PublicTag("SurfaceProcessingRatio", 0x0066000A, "Surface Processing Ratio",
          VR.kFL, VM.k1, false);
  static const PublicTag kSurfaceProcessingDescription
      //(0066,000B)
      = const PublicTag("SurfaceProcessingDescription", 0x0066000B,
          "Surface Processing Description", VR.kLO, VM.k1, false);
  static const PublicTag kRecommendedPresentationOpacity
      //(0066,000C)
      = const PublicTag("RecommendedPresentationOpacity", 0x0066000C,
          "Recommended Presentation Opacity", VR.kFL, VM.k1, false);
  static const PublicTag kRecommendedPresentationType
      //(0066,000D)
      = const PublicTag("RecommendedPresentationType", 0x0066000D,
          "Recommended Presentation Type", VR.kCS, VM.k1, false);
  static const PublicTag kFiniteVolume
      //(0066,000E)
      =
      const PublicTag("FiniteVolume", 0x0066000E, "Finite Volume", VR.kCS, VM.k1, false);
  static const PublicTag kManifold
      //(0066,0010)
      = const PublicTag("Manifold", 0x00660010, "Manifold", VR.kCS, VM.k1, false);
  static const PublicTag kSurfacePointsSequence
      //(0066,0011)
      = const PublicTag("SurfacePointsSequence", 0x00660011, "Surface Points Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kSurfacePointsNormalsSequence
      //(0066,0012)
      = const PublicTag("SurfacePointsNormalsSequence", 0x00660012,
          "Surface Points Normals Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurfaceMeshPrimitivesSequence
      //(0066,0013)
      = const PublicTag("SurfaceMeshPrimitivesSequence", 0x00660013,
          "Surface Mesh Primitives Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfSurfacePoints
      //(0066,0015)
      = const PublicTag("NumberOfSurfacePoints", 0x00660015, "Number of Surface Points",
          VR.kUL, VM.k1, false);
  static const PublicTag kPointCoordinatesData
      //(0066,0016)
      = const PublicTag("PointCoordinatesData", 0x00660016, "Point Coordinates Data",
          VR.kOF, VM.k1, false);
  static const PublicTag kPointPositionAccuracy
      //(0066,0017)
      = const PublicTag("PointPositionAccuracy", 0x00660017, "Point Position Accuracy",
          VR.kFL, VM.k3, false);
  static const PublicTag kMeanPointDistance
      //(0066,0018)
      = const PublicTag(
          "MeanPointDistance", 0x00660018, "Mean Point Distance", VR.kFL, VM.k1, false);
  static const PublicTag kMaximumPointDistance
      //(0066,0019)
      = const PublicTag("MaximumPointDistance", 0x00660019, "Maximum Point Distance",
          VR.kFL, VM.k1, false);
  static const PublicTag kPointsBoundingBoxCoordinates
      //(0066,001A)
      = const PublicTag("PointsBoundingBoxCoordinates", 0x0066001A,
          "Points Bounding Box Coordinates", VR.kFL, VM.k6, false);
  static const PublicTag kAxisOfRotation
      //(0066,001B)
      = const PublicTag(
          "AxisOfRotation", 0x0066001B, "Axis of Rotation", VR.kFL, VM.k3, false);
  static const PublicTag kCenterOfRotation
      //(0066,001C)
      = const PublicTag(
          "CenterOfRotation", 0x0066001C, "Center of Rotation", VR.kFL, VM.k3, false);
  static const PublicTag kNumberOfVectors
      //(0066,001E)
      = const PublicTag(
          "NumberOfVectors", 0x0066001E, "Number of Vectors", VR.kUL, VM.k1, false);
  static const PublicTag kVectorDimensionality
      //(0066,001F)
      = const PublicTag("VectorDimensionality", 0x0066001F, "Vector Dimensionality",
          VR.kUS, VM.k1, false);
  static const PublicTag kVectorAccuracy
      //(0066,0020)
      = const PublicTag(
          "VectorAccuracy", 0x00660020, "Vector Accuracy", VR.kFL, VM.k1_n, false);
  static const PublicTag kVectorCoordinateData
      //(0066,0021)
      = const PublicTag("VectorCoordinateData", 0x00660021, "Vector Coordinate Data",
          VR.kOF, VM.k1, false);
  static const PublicTag kTrianglePointIndexList
      //(0066,0023)
      = const PublicTag("TrianglePointIndexList", 0x00660023, "Triangle Point Index List",
          VR.kOW, VM.k1, false);
  static const PublicTag kEdgePointIndexList
      //(0066,0024)
      = const PublicTag("EdgePointIndexList", 0x00660024, "Edge Point Index List", VR.kOW,
          VM.k1, false);
  static const PublicTag kVertexPointIndexList
      //(0066,0025)
      = const PublicTag("VertexPointIndexList", 0x00660025, "Vertex Point Index List",
          VR.kOW, VM.k1, false);
  static const PublicTag kTriangleStripSequence
      //(0066,0026)
      = const PublicTag("TriangleStripSequence", 0x00660026, "Triangle Strip Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTriangleFanSequence
      //(0066,0027)
      = const PublicTag("TriangleFanSequence", 0x00660027, "Triangle Fan Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kLineSequence
      //(0066,0028)
      =
      const PublicTag("LineSequence", 0x00660028, "Line Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrimitivePointIndexList
      //(0066,0029)
      = const PublicTag("PrimitivePointIndexList", 0x00660029,
          "Primitive Point Index List", VR.kOW, VM.k1, false);
  static const PublicTag kSurfaceCount
      //(0066,002A)
      =
      const PublicTag("SurfaceCount", 0x0066002A, "Surface Count", VR.kUL, VM.k1, false);
  static const PublicTag kReferencedSurfaceSequence
      //(0066,002B)
      = const PublicTag("ReferencedSurfaceSequence", 0x0066002B,
          "Referenced Surface Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSurfaceNumber
      //(0066,002C)
      = const PublicTag("ReferencedSurfaceNumber", 0x0066002C,
          "Referenced Surface Number", VR.kUL, VM.k1, false);
  static const PublicTag kSegmentSurfaceGenerationAlgorithmIdentificationSequence
      //(0066,002D)
      = const PublicTag(
          "SegmentSurfaceGenerationAlgorithmIdentificationSequence",
          0x0066002D,
          "Segment Surface Generation Algorithm Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kSegmentSurfaceSourceInstanceSequence
      //(0066,002E)
      = const PublicTag("SegmentSurfaceSourceInstanceSequence", 0x0066002E,
          "Segment Surface Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlgorithmFamilyCodeSequence
      //(0066,002F)
      = const PublicTag("AlgorithmFamilyCodeSequence", 0x0066002F,
          "Algorithm Family Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlgorithmNameCodeSequence
      //(0066,0030)
      = const PublicTag("AlgorithmNameCodeSequence", 0x00660030,
          "Algorithm Name Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlgorithmVersion
      //(0066,0031)
      = const PublicTag(
          "AlgorithmVersion", 0x00660031, "Algorithm Version", VR.kLO, VM.k1, false);
  static const PublicTag kAlgorithmParameters
      //(0066,0032)
      = const PublicTag("AlgorithmParameters", 0x00660032, "Algorithm Parameters", VR.kLT,
          VM.k1, false);
  static const PublicTag kFacetSequence
      //(0066,0034)
      = const PublicTag(
          "FacetSequence", 0x00660034, "Facet Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurfaceProcessingAlgorithmIdentificationSequence
      //(0066,0035)
      = const PublicTag("SurfaceProcessingAlgorithmIdentificationSequence", 0x00660035,
          "Surface Processing Algorithm Identification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlgorithmName
      //(0066,0036)
      = const PublicTag(
          "AlgorithmName", 0x00660036, "Algorithm Name", VR.kLO, VM.k1, false);
  static const PublicTag kRecommendedPointRadius
      //(0066,0037)
      = const PublicTag("RecommendedPointRadius", 0x00660037, "Recommended Point Radius",
          VR.kFL, VM.k1, false);
  static const PublicTag kRecommendedLineThickness
      //(0066,0038)
      = const PublicTag("RecommendedLineThickness", 0x00660038,
          "Recommended Line Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kImplantSize
      //(0068,6210)
      = const PublicTag("ImplantSize", 0x00686210, "Implant Size", VR.kLO, VM.k1, false);
  static const PublicTag kImplantTemplateVersion
      //(0068,6221)
      = const PublicTag("ImplantTemplateVersion", 0x00686221, "Implant Template Version",
          VR.kLO, VM.k1, false);
  static const PublicTag kReplacedImplantTemplateSequence
      //(0068,6222)
      = const PublicTag("ReplacedImplantTemplateSequence", 0x00686222,
          "Replaced Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantType
      //(0068,6223)
      = const PublicTag("ImplantType", 0x00686223, "Implant Type", VR.kCS, VM.k1, false);
  static const PublicTag kDerivationImplantTemplateSequence
      //(0068,6224)
      = const PublicTag("DerivationImplantTemplateSequence", 0x00686224,
          "Derivation Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOriginalImplantTemplateSequence
      //(0068,6225)
      = const PublicTag("OriginalImplantTemplateSequence", 0x00686225,
          "Original Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEffectiveDateTime
      //(0068,6226)
      = const PublicTag(
          "EffectiveDateTime", 0x00686226, "Effective DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kImplantTargetAnatomySequence
      //(0068,6230)
      = const PublicTag("ImplantTargetAnatomySequence", 0x00686230,
          "Implant Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInformationFromManufacturerSequence
      //(0068,6260)
      = const PublicTag("InformationFromManufacturerSequence", 0x00686260,
          "Information From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNotificationFromManufacturerSequence
      //(0068,6265)
      = const PublicTag("NotificationFromManufacturerSequence", 0x00686265,
          "Notification From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInformationIssueDateTime
      //(0068,6270)
      = const PublicTag("InformationIssueDateTime", 0x00686270,
          "Information Issue DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kInformationSummary
      //(0068,6280)
      = const PublicTag(
          "InformationSummary", 0x00686280, "Information Summary", VR.kST, VM.k1, false);
  static const PublicTag kImplantRegulatoryDisapprovalCodeSequence
      //(0068,62A0)
      = const PublicTag("ImplantRegulatoryDisapprovalCodeSequence", 0x006862A0,
          "Implant Regulatory Disapproval Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOverallTemplateSpatialTolerance
      //(0068,62A5)
      = const PublicTag("OverallTemplateSpatialTolerance", 0x006862A5,
          "Overall Template Spatial Tolerance", VR.kFD, VM.k1, false);
  static const PublicTag kHPGLDocumentSequence
      //(0068,62C0)
      = const PublicTag("HPGLDocumentSequence", 0x006862C0, "HPGL Document Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kHPGLDocumentID
      //(0068,62D0)
      = const PublicTag(
          "HPGLDocumentID", 0x006862D0, "HPGL Document ID", VR.kUS, VM.k1, false);
  static const PublicTag kHPGLDocumentLabel
      //(0068,62D5)
      = const PublicTag(
          "HPGLDocumentLabel", 0x006862D5, "HPGL Document Label", VR.kLO, VM.k1, false);
  static const PublicTag kViewOrientationCodeSequence
      //(0068,62E0)
      = const PublicTag("ViewOrientationCodeSequence", 0x006862E0,
          "View Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kViewOrientationModifier
      //(0068,62F0)
      = const PublicTag("ViewOrientationModifier", 0x006862F0,
          "View Orientation Modifier", VR.kFD, VM.k9, false);
  static const PublicTag kHPGLDocumentScaling
      //(0068,62F2)
      = const PublicTag("HPGLDocumentScaling", 0x006862F2, "HPGL Document Scaling",
          VR.kFD, VM.k1, false);
  static const PublicTag kHPGLDocument
      //(0068,6300)
      =
      const PublicTag("HPGLDocument", 0x00686300, "HPGL Document", VR.kOB, VM.k1, false);
  static const PublicTag kHPGLContourPenNumber
      //(0068,6310)
      = const PublicTag("HPGLContourPenNumber", 0x00686310, "HPGL Contour Pen Number",
          VR.kUS, VM.k1, false);
  static const PublicTag kHPGLPenSequence
      //(0068,6320)
      = const PublicTag(
          "HPGLPenSequence", 0x00686320, "HPGL Pen Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHPGLPenNumber
      //(0068,6330)
      = const PublicTag(
          "HPGLPenNumber", 0x00686330, "HPGL Pen Number", VR.kUS, VM.k1, false);
  static const PublicTag kHPGLPenLabel
      //(0068,6340)
      =
      const PublicTag("HPGLPenLabel", 0x00686340, "HPGL Pen Label", VR.kLO, VM.k1, false);
  static const PublicTag kHPGLPenDescription
      //(0068,6345)
      = const PublicTag(
          "HPGLPenDescription", 0x00686345, "HPGL Pen Description", VR.kST, VM.k1, false);
  static const PublicTag kRecommendedRotationPoint
      //(0068,6346)
      = const PublicTag("RecommendedRotationPoint", 0x00686346,
          "Recommended Rotation Point", VR.kFD, VM.k2, false);
  static const PublicTag kBoundingRectangle
      //(0068,6347)
      = const PublicTag(
          "BoundingRectangle", 0x00686347, "Bounding Rectangle", VR.kFD, VM.k4, false);
  static const PublicTag kImplantTemplate3DModelSurfaceNumber
      //(0068,6350)
      = const PublicTag("ImplantTemplate3DModelSurfaceNumber", 0x00686350,
          "Implant Template 3D Model Surface Number", VR.kUS, VM.k1_n, false);
  static const PublicTag kSurfaceModelDescriptionSequence
      //(0068,6360)
      = const PublicTag("SurfaceModelDescriptionSequence", 0x00686360,
          "Surface Model Description Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurfaceModelLabel
      //(0068,6380)
      = const PublicTag(
          "SurfaceModelLabel", 0x00686380, "Surface Model Label", VR.kLO, VM.k1, false);
  static const PublicTag kSurfaceModelScalingFactor
      //(0068,6390)
      = const PublicTag("SurfaceModelScalingFactor", 0x00686390,
          "Surface Model Scaling Factor", VR.kFD, VM.k1, false);
  static const PublicTag kMaterialsCodeSequence
      //(0068,63A0)
      = const PublicTag("MaterialsCodeSequence", 0x006863A0, "Materials Code Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCoatingMaterialsCodeSequence
      //(0068,63A4)
      = const PublicTag("CoatingMaterialsCodeSequence", 0x006863A4,
          "Coating Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantTypeCodeSequence
      //(0068,63A8)
      = const PublicTag("ImplantTypeCodeSequence", 0x006863A8,
          "Implant Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFixationMethodCodeSequence
      //(0068,63AC)
      = const PublicTag("FixationMethodCodeSequence", 0x006863AC,
          "Fixation Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMatingFeatureSetsSequence
      //(0068,63B0)
      = const PublicTag("MatingFeatureSetsSequence", 0x006863B0,
          "Mating Feature Sets Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMatingFeatureSetID
      //(0068,63C0)
      = const PublicTag("MatingFeatureSetID", 0x006863C0, "Mating Feature Set ID", VR.kUS,
          VM.k1, false);
  static const PublicTag kMatingFeatureSetLabel
      //(0068,63D0)
      = const PublicTag("MatingFeatureSetLabel", 0x006863D0, "Mating Feature Set Label",
          VR.kLO, VM.k1, false);
  static const PublicTag kMatingFeatureSequence
      //(0068,63E0)
      = const PublicTag("MatingFeatureSequence", 0x006863E0, "Mating Feature Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kMatingFeatureID
      //(0068,63F0)
      = const PublicTag(
          "MatingFeatureID", 0x006863F0, "Mating Feature ID", VR.kUS, VM.k1, false);
  static const PublicTag kMatingFeatureDegreeOfFreedomSequence
      //(0068,6400)
      = const PublicTag("MatingFeatureDegreeOfFreedomSequence", 0x00686400,
          "Mating Feature Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDegreeOfFreedomID
      //(0068,6410)
      = const PublicTag(
          "DegreeOfFreedomID", 0x00686410, "Degree of Freedom ID", VR.kUS, VM.k1, false);
  static const PublicTag kDegreeOfFreedomType
      //(0068,6420)
      = const PublicTag("DegreeOfFreedomType", 0x00686420, "Degree of Freedom Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kTwoDMatingFeatureCoordinatesSequence
      //(0068,6430)
      = const PublicTag("TwoDMatingFeatureCoordinatesSequence", 0x00686430,
          "2D Mating Feature Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedHPGLDocumentID
      //(0068,6440)
      = const PublicTag("ReferencedHPGLDocumentID", 0x00686440,
          "Referenced HPGL Document ID", VR.kUS, VM.k1, false);
  static const PublicTag kTwoDMatingPoint
      //(0068,6450)
      = const PublicTag(
          "TwoDMatingPoint", 0x00686450, "2D Mating Point", VR.kFD, VM.k2, false);
  static const PublicTag kTwoDMatingAxes
      //(0068,6460)
      = const PublicTag(
          "TwoDMatingAxes", 0x00686460, "2D Mating Axes", VR.kFD, VM.k4, false);
  static const PublicTag kTwoDDegreeOfFreedomSequence
      //(0068,6470)
      = const PublicTag("TwoDDegreeOfFreedomSequence", 0x00686470,
          "2D Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kThreeDDegreeOfFreedomAxis
      //(0068,6490)
      = const PublicTag("ThreeDDegreeOfFreedomAxis", 0x00686490,
          "3D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const PublicTag kRangeOfFreedom
      //(0068,64A0)
      = const PublicTag(
          "RangeOfFreedom", 0x006864A0, "Range of Freedom", VR.kFD, VM.k2, false);
  static const PublicTag kThreeDMatingPoint
      //(0068,64C0)
      = const PublicTag(
          "ThreeDMatingPoint", 0x006864C0, "3D Mating Point", VR.kFD, VM.k3, false);
  static const PublicTag kThreeDMatingAxes
      //(0068,64D0)
      = const PublicTag(
          "ThreeDMatingAxes", 0x006864D0, "3D Mating Axes", VR.kFD, VM.k9, false);
  static const PublicTag kTwoDDegreeOfFreedomAxis
      //(0068,64F0)
      = const PublicTag("TwoDDegreeOfFreedomAxis", 0x006864F0,
          "2D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const PublicTag kPlanningLandmarkPointSequence
      //(0068,6500)
      = const PublicTag("PlanningLandmarkPointSequence", 0x00686500,
          "Planning Landmark Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlanningLandmarkLineSequence
      //(0068,6510)
      = const PublicTag("PlanningLandmarkLineSequence", 0x00686510,
          "Planning Landmark Line Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlanningLandmarkPlaneSequence
      //(0068,6520)
      = const PublicTag("PlanningLandmarkPlaneSequence", 0x00686520,
          "Planning Landmark Plane Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPlanningLandmarkID
      //(0068,6530)
      = const PublicTag(
          "PlanningLandmarkID", 0x00686530, "Planning Landmark ID", VR.kUS, VM.k1, false);
  static const PublicTag kPlanningLandmarkDescription
      //(0068,6540)
      = const PublicTag("PlanningLandmarkDescription", 0x00686540,
          "Planning Landmark Description", VR.kLO, VM.k1, false);
  static const PublicTag kPlanningLandmarkIdentificationCodeSequence
      //(0068,6545)
      = const PublicTag("PlanningLandmarkIdentificationCodeSequence", 0x00686545,
          "Planning Landmark Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTwoDPointCoordinatesSequence
      //(0068,6550)
      = const PublicTag("TwoDPointCoordinatesSequence", 0x00686550,
          "2D Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTwoDPointCoordinates
      //(0068,6560)
      = const PublicTag("TwoDPointCoordinates", 0x00686560, "2D Point Coordinates",
          VR.kFD, VM.k2, false);
  static const PublicTag kThreeDPointCoordinates
      //(0068,6590)
      = const PublicTag("ThreeDPointCoordinates", 0x00686590, "3D Point Coordinates",
          VR.kFD, VM.k3, false);
  static const PublicTag kTwoDLineCoordinatesSequence
      //(0068,65A0)
      = const PublicTag("TwoDLineCoordinatesSequence", 0x006865A0,
          "2D Line Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTwoDLineCoordinates
      //(0068,65B0)
      = const PublicTag(
          "TwoDLineCoordinates", 0x006865B0, "2D Line Coordinates", VR.kFD, VM.k4, false);
  static const PublicTag kThreeDLineCoordinates
      //(0068,65D0)
      = const PublicTag("ThreeDLineCoordinates", 0x006865D0, "3D Line Coordinates",
          VR.kFD, VM.k6, false);
  static const PublicTag kTwoDPlaneCoordinatesSequence
      //(0068,65E0)
      = const PublicTag("TwoDPlaneCoordinatesSequence", 0x006865E0,
          "2D Plane Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTwoDPlaneIntersection
      //(0068,65F0)
      = const PublicTag("TwoDPlaneIntersection", 0x006865F0, "2D Plane Intersection",
          VR.kFD, VM.k4, false);
  static const PublicTag kThreeDPlaneOrigin
      //(0068,6610)
      = const PublicTag(
          "ThreeDPlaneOrigin", 0x00686610, "3D Plane Origin", VR.kFD, VM.k3, false);
  static const PublicTag kThreeDPlaneNormal
      //(0068,6620)
      = const PublicTag(
          "ThreeDPlaneNormal", 0x00686620, "3D Plane Normal", VR.kFD, VM.k3, false);
  static const PublicTag kGraphicAnnotationSequence
      //(0070,0001)
      = const PublicTag("GraphicAnnotationSequence", 0x00700001,
          "Graphic Annotation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicLayer
      //(0070,0002)
      =
      const PublicTag("GraphicLayer", 0x00700002, "Graphic Layer", VR.kCS, VM.k1, false);
  static const PublicTag kBoundingBoxAnnotationUnits
      //(0070,0003)
      = const PublicTag("BoundingBoxAnnotationUnits", 0x00700003,
          "Bounding Box Annotation Units", VR.kCS, VM.k1, false);
  static const PublicTag kAnchorPointAnnotationUnits
      //(0070,0004)
      = const PublicTag("AnchorPointAnnotationUnits", 0x00700004,
          "Anchor Point Annotation Units", VR.kCS, VM.k1, false);
  static const PublicTag kGraphicAnnotationUnits
      //(0070,0005)
      = const PublicTag("GraphicAnnotationUnits", 0x00700005, "Graphic Annotation Units",
          VR.kCS, VM.k1, false);
  static const PublicTag kUnformattedTextValue
      //(0070,0006)
      = const PublicTag("UnformattedTextValue", 0x00700006, "Unformatted Text Value",
          VR.kST, VM.k1, false);
  static const PublicTag kTextObjectSequence
      //(0070,0008)
      = const PublicTag(
          "TextObjectSequence", 0x00700008, "Text Object Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicObjectSequence
      //(0070,0009)
      = const PublicTag("GraphicObjectSequence", 0x00700009, "Graphic Object Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kBoundingBoxTopLeftHandCorner
      //(0070,0010)
      = const PublicTag("BoundingBoxTopLeftHandCorner", 0x00700010,
          "Bounding Box Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const PublicTag kBoundingBoxBottomRightHandCorner
      //(0070,0011)
      = const PublicTag("BoundingBoxBottomRightHandCorner", 0x00700011,
          "Bounding Box Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const PublicTag kBoundingBoxTextHorizontalJustification
      //(0070,0012)
      = const PublicTag("BoundingBoxTextHorizontalJustification", 0x00700012,
          "Bounding Box Text Horizontal Justification", VR.kCS, VM.k1, false);
  static const PublicTag kAnchorPoint
      //(0070,0014)
      = const PublicTag("AnchorPoint", 0x00700014, "Anchor Point", VR.kFL, VM.k2, false);
  static const PublicTag kAnchorPointVisibility
      //(0070,0015)
      = const PublicTag("AnchorPointVisibility", 0x00700015, "Anchor Point Visibility",
          VR.kCS, VM.k1, false);
  static const PublicTag kGraphicDimensions
      //(0070,0020)
      = const PublicTag(
          "GraphicDimensions", 0x00700020, "Graphic Dimensions", VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfGraphicPoints
      //(0070,0021)
      = const PublicTag("NumberOfGraphicPoints", 0x00700021, "Number of Graphic Points",
          VR.kUS, VM.k1, false);
  static const PublicTag kGraphicData
      //(0070,0022)
      =
      const PublicTag("GraphicData", 0x00700022, "Graphic Data", VR.kFL, VM.k2_n, false);
  static const PublicTag kGraphicType
      //(0070,0023)
      = const PublicTag("GraphicType", 0x00700023, "Graphic Type", VR.kCS, VM.k1, false);
  static const PublicTag kGraphicFilled
      //(0070,0024)
      = const PublicTag(
          "GraphicFilled", 0x00700024, "Graphic Filled", VR.kCS, VM.k1, false);
  static const PublicTag kImageRotationRetired
      //(0070,0040)
      = const PublicTag("ImageRotationRetired", 0x00700040, "Image Rotation (Retired)",
          VR.kIS, VM.k1, true);
  static const PublicTag kImageHorizontalFlip
      //(0070,0041)
      = const PublicTag("ImageHorizontalFlip", 0x00700041, "Image Horizontal Flip",
          VR.kCS, VM.k1, false);
  static const PublicTag kImageRotation
      //(0070,0042)
      = const PublicTag(
          "ImageRotation", 0x00700042, "Image Rotation", VR.kUS, VM.k1, false);
  static const PublicTag kDisplayedAreaTopLeftHandCornerTrial
      //(0070,0050)
      = const PublicTag("DisplayedAreaTopLeftHandCornerTrial", 0x00700050,
          "Displayed Area Top Left Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const PublicTag kDisplayedAreaBottomRightHandCornerTrial
      //(0070,0051)
      = const PublicTag("DisplayedAreaBottomRightHandCornerTrial", 0x00700051,
          "Displayed Area Bottom Right Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const PublicTag kDisplayedAreaTopLeftHandCorner
      //(0070,0052)
      = const PublicTag("DisplayedAreaTopLeftHandCorner", 0x00700052,
          "Displayed Area Top Left Hand Corner", VR.kSL, VM.k2, false);
  static const PublicTag kDisplayedAreaBottomRightHandCorner
      //(0070,0053)
      = const PublicTag("DisplayedAreaBottomRightHandCorner", 0x00700053,
          "Displayed Area Bottom Right Hand Corner", VR.kSL, VM.k2, false);
  static const PublicTag kDisplayedAreaSelectionSequence
      //(0070,005A)
      = const PublicTag("DisplayedAreaSelectionSequence", 0x0070005A,
          "Displayed Area Selection Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicLayerSequence
      //(0070,0060)
      = const PublicTag("GraphicLayerSequence", 0x00700060, "Graphic Layer Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicLayerOrder
      //(0070,0062)
      = const PublicTag(
          "GraphicLayerOrder", 0x00700062, "Graphic Layer Order", VR.kIS, VM.k1, false);
  static const PublicTag kGraphicLayerRecommendedDisplayGrayscaleValue
      //(0070,0066)
      = const PublicTag("GraphicLayerRecommendedDisplayGrayscaleValue", 0x00700066,
          "Graphic Layer Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const PublicTag kGraphicLayerRecommendedDisplayRGBValue
      //(0070,0067)
      = const PublicTag("GraphicLayerRecommendedDisplayRGBValue", 0x00700067,
          "Graphic Layer Recommended Display RGB Value", VR.kUS, VM.k3, true);
  static const PublicTag kGraphicLayerDescription
      //(0070,0068)
      = const PublicTag("GraphicLayerDescription", 0x00700068,
          "Graphic Layer Description", VR.kLO, VM.k1, false);
  static const PublicTag kContentLabel
      //(0070,0080)
      =
      const PublicTag("ContentLabel", 0x00700080, "Content Label", VR.kCS, VM.k1, false);
  static const PublicTag kContentDescription
      //(0070,0081)
      = const PublicTag(
          "ContentDescription", 0x00700081, "Content Description", VR.kLO, VM.k1, false);
  static const PublicTag kPresentationCreationDate
      //(0070,0082)
      = const PublicTag("PresentationCreationDate", 0x00700082,
          "Presentation Creation Date", VR.kDA, VM.k1, false);
  static const PublicTag kPresentationCreationTime
      //(0070,0083)
      = const PublicTag("PresentationCreationTime", 0x00700083,
          "Presentation Creation Time", VR.kTM, VM.k1, false);
  static const PublicTag kContentCreatorName
      //(0070,0084)
      = const PublicTag("ContentCreatorName", 0x00700084, "Content Creator's Name",
          VR.kPN, VM.k1, false);
  static const PublicTag kContentCreatorIdentificationCodeSequence
      //(0070,0086)
      = const PublicTag("ContentCreatorIdentificationCodeSequence", 0x00700086,
          "Content Creator's Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAlternateContentDescriptionSequence
      //(0070,0087)
      = const PublicTag("AlternateContentDescriptionSequence", 0x00700087,
          "Alternate Content Description Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPresentationSizeMode
      //(0070,0100)
      = const PublicTag("PresentationSizeMode", 0x00700100, "Presentation Size Mode",
          VR.kCS, VM.k1, false);
  static const PublicTag kPresentationPixelSpacing
      //(0070,0101)
      = const PublicTag("PresentationPixelSpacing", 0x00700101,
          "Presentation Pixel Spacing", VR.kDS, VM.k2, false);
  static const PublicTag kPresentationPixelAspectRatio
      //(0070,0102)
      = const PublicTag("PresentationPixelAspectRatio", 0x00700102,
          "Presentation Pixel Aspect Ratio", VR.kIS, VM.k2, false);
  static const PublicTag kPresentationPixelMagnificationRatio
      //(0070,0103)
      = const PublicTag("PresentationPixelMagnificationRatio", 0x00700103,
          "Presentation Pixel Magnification Ratio", VR.kFL, VM.k1, false);
  static const PublicTag kGraphicGroupLabel
      //(0070,0207)
      = const PublicTag(
          "GraphicGroupLabel", 0x00700207, "Graphic Group Label", VR.kLO, VM.k1, false);
  static const PublicTag kGraphicGroupDescription
      //(0070,0208)
      = const PublicTag("GraphicGroupDescription", 0x00700208,
          "Graphic Group Description", VR.kST, VM.k1, false);
  static const PublicTag kCompoundGraphicSequence
      //(0070,0209)
      = const PublicTag("CompoundGraphicSequence", 0x00700209,
          "Compound Graphic Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCompoundGraphicInstanceID
      //(0070,0226)
      = const PublicTag("CompoundGraphicInstanceID", 0x00700226,
          "Compound Graphic Instance ID", VR.kUL, VM.k1, false);
  static const PublicTag kFontName
      //(0070,0227)
      = const PublicTag("FontName", 0x00700227, "Font Name", VR.kLO, VM.k1, false);
  static const PublicTag kFontNameType
      //(0070,0228)
      =
      const PublicTag("FontNameType", 0x00700228, "Font Name Type", VR.kCS, VM.k1, false);
  static const PublicTag kCSSFontName
      //(0070,0229)
      = const PublicTag("CSSFontName", 0x00700229, "CSS Font Name", VR.kLO, VM.k1, false);
  static const PublicTag kRotationAngle
      //(0070,0230)
      = const PublicTag(
          "RotationAngle", 0x00700230, "Rotation Angle", VR.kFD, VM.k1, false);
  static const PublicTag kTextStyleSequence
      //(0070,0231)
      = const PublicTag(
          "TextStyleSequence", 0x00700231, "Text Style Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLineStyleSequence
      //(0070,0232)
      = const PublicTag(
          "LineStyleSequence", 0x00700232, "Line Style Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFillStyleSequence
      //(0070,0233)
      = const PublicTag(
          "FillStyleSequence", 0x00700233, "Fill Style Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicGroupSequence
      //(0070,0234)
      = const PublicTag("GraphicGroupSequence", 0x00700234, "Graphic Group Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTextColorCIELabValue
      //(0070,0241)
      = const PublicTag("TextColorCIELabValue", 0x00700241, "Text Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const PublicTag kHorizontalAlignment
      //(0070,0242)
      = const PublicTag("HorizontalAlignment", 0x00700242, "Horizontal Alignment", VR.kCS,
          VM.k1, false);
  static const PublicTag kVerticalAlignment
      //(0070,0243)
      = const PublicTag(
          "VerticalAlignment", 0x00700243, "Vertical Alignment", VR.kCS, VM.k1, false);
  static const PublicTag kShadowStyle
      //(0070,0244)
      = const PublicTag("ShadowStyle", 0x00700244, "Shadow Style", VR.kCS, VM.k1, false);
  static const PublicTag kShadowOffsetX
      //(0070,0245)
      = const PublicTag(
          "ShadowOffsetX", 0x00700245, "Shadow Offset X", VR.kFL, VM.k1, false);
  static const PublicTag kShadowOffsetY
      //(0070,0246)
      = const PublicTag(
          "ShadowOffsetY", 0x00700246, "Shadow Offset Y", VR.kFL, VM.k1, false);
  static const PublicTag kShadowColorCIELabValue
      //(0070,0247)
      = const PublicTag("ShadowColorCIELabValue", 0x00700247, "Shadow Color CIELab Value",
          VR.kUS, VM.k3, false);
  static const PublicTag kUnderlined
      //(0070,0248)
      = const PublicTag("Underlined", 0x00700248, "Underlined", VR.kCS, VM.k1, false);
  static const PublicTag kBold
      //(0070,0249)
      = const PublicTag("Bold", 0x00700249, "Bold", VR.kCS, VM.k1, false);
  static const PublicTag kItalic
      //(0070,0250)
      = const PublicTag("Italic", 0x00700250, "Italic", VR.kCS, VM.k1, false);
  static const PublicTag kPatternOnColorCIELabValue
      //(0070,0251)
      = const PublicTag("PatternOnColorCIELabValue", 0x00700251,
          "Pattern On Color CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kPatternOffColorCIELabValue
      //(0070,0252)
      = const PublicTag("PatternOffColorCIELabValue", 0x00700252,
          "Pattern Off Color CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kLineThickness
      //(0070,0253)
      = const PublicTag(
          "LineThickness", 0x00700253, "Line Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kLineDashingStyle
      //(0070,0254)
      = const PublicTag(
          "LineDashingStyle", 0x00700254, "Line Dashing Style", VR.kCS, VM.k1, false);
  static const PublicTag kLinePattern
      //(0070,0255)
      = const PublicTag("LinePattern", 0x00700255, "Line Pattern", VR.kUL, VM.k1, false);
  static const PublicTag kFillPattern
      //(0070,0256)
      = const PublicTag("FillPattern", 0x00700256, "Fill Pattern", VR.kOB, VM.k1, false);
  static const PublicTag kFillMode
      //(0070,0257)
      = const PublicTag("FillMode", 0x00700257, "Fill Mode", VR.kCS, VM.k1, false);
  static const PublicTag kShadowOpacity
      //(0070,0258)
      = const PublicTag(
          "ShadowOpacity", 0x00700258, "Shadow Opacity", VR.kFL, VM.k1, false);
  static const PublicTag kGapLength
      //(0070,0261)
      = const PublicTag("GapLength", 0x00700261, "Gap Length", VR.kFL, VM.k1, false);
  static const PublicTag kDiameterOfVisibility
      //(0070,0262)
      = const PublicTag("DiameterOfVisibility", 0x00700262, "Diameter of Visibility",
          VR.kFL, VM.k1, false);
  static const PublicTag kRotationPoint
      //(0070,0273)
      = const PublicTag(
          "RotationPoint", 0x00700273, "Rotation Point", VR.kFL, VM.k2, false);
  static const PublicTag kTickAlignment
      //(0070,0274)
      = const PublicTag(
          "TickAlignment", 0x00700274, "Tick Alignment", VR.kCS, VM.k1, false);
  static const PublicTag kShowTickLabel
      //(0070,0278)
      = const PublicTag(
          "ShowTickLabel", 0x00700278, "Show Tick Label", VR.kCS, VM.k1, false);
  static const PublicTag kTickLabelAlignment
      //(0070,0279)
      = const PublicTag(
          "TickLabelAlignment", 0x00700279, "Tick Label Alignment", VR.kCS, VM.k1, false);
  static const PublicTag kCompoundGraphicUnits
      //(0070,0282)
      = const PublicTag("CompoundGraphicUnits", 0x00700282, "Compound Graphic Units",
          VR.kCS, VM.k1, false);
  static const PublicTag kPatternOnOpacity
      //(0070,0284)
      = const PublicTag(
          "PatternOnOpacity", 0x00700284, "Pattern On Opacity", VR.kFL, VM.k1, false);
  static const PublicTag kPatternOffOpacity
      //(0070,0285)
      = const PublicTag(
          "PatternOffOpacity", 0x00700285, "Pattern Off Opacity", VR.kFL, VM.k1, false);
  static const PublicTag kMajorTicksSequence
      //(0070,0287)
      = const PublicTag(
          "MajorTicksSequence", 0x00700287, "Major Ticks Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTickPosition
      //(0070,0288)
      =
      const PublicTag("TickPosition", 0x00700288, "Tick Position", VR.kFL, VM.k1, false);
  static const PublicTag kTickLabel
      //(0070,0289)
      = const PublicTag("TickLabel", 0x00700289, "Tick Label", VR.kSH, VM.k1, false);
  static const PublicTag kCompoundGraphicType
      //(0070,0294)
      = const PublicTag("CompoundGraphicType", 0x00700294, "Compound Graphic Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kGraphicGroupID
      //(0070,0295)
      = const PublicTag(
          "GraphicGroupID", 0x00700295, "Graphic Group ID", VR.kUL, VM.k1, false);
  static const PublicTag kShapeType
      //(0070,0306)
      = const PublicTag("ShapeType", 0x00700306, "Shape Type", VR.kCS, VM.k1, false);
  static const PublicTag kRegistrationSequence
      //(0070,0308)
      = const PublicTag("RegistrationSequence", 0x00700308, "Registration Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kMatrixRegistrationSequence
      //(0070,0309)
      = const PublicTag("MatrixRegistrationSequence", 0x00700309,
          "Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMatrixSequence
      //(0070,030A)
      = const PublicTag(
          "MatrixSequence", 0x0070030A, "Matrix Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFrameOfReferenceTransformationMatrixType
      //(0070,030C)
      = const PublicTag("FrameOfReferenceTransformationMatrixType", 0x0070030C,
          "Frame of Reference Transformation Matrix Type", VR.kCS, VM.k1, false);
  static const PublicTag kRegistrationTypeCodeSequence
      //(0070,030D)
      = const PublicTag("RegistrationTypeCodeSequence", 0x0070030D,
          "Registration Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFiducialDescription
      //(0070,030F)
      = const PublicTag("FiducialDescription", 0x0070030F, "Fiducial Description", VR.kST,
          VM.k1, false);
  static const PublicTag kFiducialIdentifier
      //(0070,0310)
      = const PublicTag(
          "FiducialIdentifier", 0x00700310, "Fiducial Identifier", VR.kSH, VM.k1, false);
  static const PublicTag kFiducialIdentifierCodeSequence
      //(0070,0311)
      = const PublicTag("FiducialIdentifierCodeSequence", 0x00700311,
          "Fiducial Identifier Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContourUncertaintyRadius
      //(0070,0312)
      = const PublicTag("ContourUncertaintyRadius", 0x00700312,
          "Contour Uncertainty Radius", VR.kFD, VM.k1, false);
  static const PublicTag kUsedFiducialsSequence
      //(0070,0314)
      = const PublicTag("UsedFiducialsSequence", 0x00700314, "Used Fiducials Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicCoordinatesDataSequence
      //(0070,0318)
      = const PublicTag("GraphicCoordinatesDataSequence", 0x00700318,
          "Graphic Coordinates Data Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFiducialUID
      //(0070,031A)
      = const PublicTag("FiducialUID", 0x0070031A, "Fiducial UID", VR.kUI, VM.k1, false);
  static const PublicTag kFiducialSetSequence
      //(0070,031C)
      = const PublicTag("FiducialSetSequence", 0x0070031C, "Fiducial Set Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFiducialSequence
      //(0070,031E)
      = const PublicTag(
          "FiducialSequence", 0x0070031E, "Fiducial Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGraphicLayerRecommendedDisplayCIELabValue
      //(0070,0401)
      = const PublicTag("GraphicLayerRecommendedDisplayCIELabValue", 0x00700401,
          "Graphic Layer Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kBlendingSequence
      //(0070,0402)
      = const PublicTag(
          "BlendingSequence", 0x00700402, "Blending Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelativeOpacity
      //(0070,0403)
      = const PublicTag(
          "RelativeOpacity", 0x00700403, "Relative Opacity", VR.kFL, VM.k1, false);
  static const PublicTag kReferencedSpatialRegistrationSequence
      //(0070,0404)
      = const PublicTag("ReferencedSpatialRegistrationSequence", 0x00700404,
          "Referenced Spatial Registration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBlendingPosition
      //(0070,0405)
      = const PublicTag(
          "BlendingPosition", 0x00700405, "Blending Position", VR.kCS, VM.k1, false);
  static const PublicTag kHangingProtocolName
      //(0072,0002)
      = const PublicTag("HangingProtocolName", 0x00720002, "Hanging Protocol Name",
          VR.kSH, VM.k1, false);
  static const PublicTag kHangingProtocolDescription
      //(0072,0004)
      = const PublicTag("HangingProtocolDescription", 0x00720004,
          "Hanging Protocol Description", VR.kLO, VM.k1, false);
  static const PublicTag kHangingProtocolLevel
      //(0072,0006)
      = const PublicTag("HangingProtocolLevel", 0x00720006, "Hanging Protocol Level",
          VR.kCS, VM.k1, false);
  static const PublicTag kHangingProtocolCreator
      //(0072,0008)
      = const PublicTag("HangingProtocolCreator", 0x00720008, "Hanging Protocol Creator",
          VR.kLO, VM.k1, false);
  static const PublicTag kHangingProtocolCreationDateTime
      //(0072,000A)
      = const PublicTag("HangingProtocolCreationDateTime", 0x0072000A,
          "Hanging Protocol Creation DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kHangingProtocolDefinitionSequence
      //(0072,000C)
      = const PublicTag("HangingProtocolDefinitionSequence", 0x0072000C,
          "Hanging Protocol Definition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHangingProtocolUserIdentificationCodeSequence
      //(0072,000E)
      = const PublicTag("HangingProtocolUserIdentificationCodeSequence", 0x0072000E,
          "Hanging Protocol User Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kHangingProtocolUserGroupName
      //(0072,0010)
      = const PublicTag("HangingProtocolUserGroupName", 0x00720010,
          "Hanging Protocol User Group Name", VR.kLO, VM.k1, false);
  static const PublicTag kSourceHangingProtocolSequence
      //(0072,0012)
      = const PublicTag("SourceHangingProtocolSequence", 0x00720012,
          "Source Hanging Protocol Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfPriorsReferenced
      //(0072,0014)
      = const PublicTag("NumberOfPriorsReferenced", 0x00720014,
          "Number of Priors Referenced", VR.kUS, VM.k1, false);
  static const PublicTag kImageSetsSequence
      //(0072,0020)
      = const PublicTag(
          "ImageSetsSequence", 0x00720020, "Image Sets Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageSetSelectorSequence
      //(0072,0022)
      = const PublicTag("ImageSetSelectorSequence", 0x00720022,
          "Image Set Selector Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageSetSelectorUsageFlag
      //(0072,0024)
      = const PublicTag("ImageSetSelectorUsageFlag", 0x00720024,
          "Image Set Selector Usage Flag", VR.kCS, VM.k1, false);
  static const PublicTag kSelectorAttribute
      //(0072,0026)
      = const PublicTag(
          "SelectorAttribute", 0x00720026, "Selector Attribute", VR.kAT, VM.k1, false);
  static const PublicTag kSelectorValueNumber
      //(0072,0028)
      = const PublicTag("SelectorValueNumber", 0x00720028, "Selector Value Number",
          VR.kUS, VM.k1, false);
  static const PublicTag kTimeBasedImageSetsSequence
      //(0072,0030)
      = const PublicTag("TimeBasedImageSetsSequence", 0x00720030,
          "Time Based Image Sets Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageSetNumber
      //(0072,0032)
      = const PublicTag(
          "ImageSetNumber", 0x00720032, "Image Set Number", VR.kUS, VM.k1, false);
  static const PublicTag kImageSetSelectorCategory
      //(0072,0034)
      = const PublicTag("ImageSetSelectorCategory", 0x00720034,
          "Image Set Selector Category", VR.kCS, VM.k1, false);
  static const PublicTag kRelativeTime
      //(0072,0038)
      =
      const PublicTag("RelativeTime", 0x00720038, "Relative Time", VR.kUS, VM.k2, false);
  static const PublicTag kRelativeTimeUnits
      //(0072,003A)
      = const PublicTag(
          "RelativeTimeUnits", 0x0072003A, "Relative Time Units", VR.kCS, VM.k1, false);
  static const PublicTag kAbstractPriorValue
      //(0072,003C)
      = const PublicTag(
          "AbstractPriorValue", 0x0072003C, "Abstract Prior Value", VR.kSS, VM.k2, false);
  static const PublicTag kAbstractPriorCodeSequence
      //(0072,003E)
      = const PublicTag("AbstractPriorCodeSequence", 0x0072003E,
          "Abstract Prior Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageSetLabel
      //(0072,0040)
      = const PublicTag(
          "ImageSetLabel", 0x00720040, "Image Set Label", VR.kLO, VM.k1, false);
  static const PublicTag kSelectorAttributeVR
      //(0072,0050)
      = const PublicTag("SelectorAttributeVR", 0x00720050, "Selector Attribute VR",
          VR.kCS, VM.k1, false);
  static const PublicTag kSelectorSequencePointer
      //(0072,0052)
      = const PublicTag("SelectorSequencePointer", 0x00720052,
          "Selector Sequence Pointer", VR.kAT, VM.k1_n, false);
  static const PublicTag kSelectorSequencePointerPrivateCreator
      //(0072,0054)
      = const PublicTag("SelectorSequencePointerPrivateCreator", 0x00720054,
          "Selector Sequence Pointer Private Creator", VR.kLO, VM.k1_n, false);
  static const PublicTag kSelectorAttributePrivateCreator
      //(0072,0056)
      = const PublicTag("SelectorAttributePrivateCreator", 0x00720056,
          "Selector Attribute Private Creator", VR.kLO, VM.k1, false);
  static const PublicTag kSelectorATValue
      //(0072,0060)
      = const PublicTag(
          "SelectorATValue", 0x00720060, "Selector AT Value", VR.kAT, VM.k1_n, false);
  static const PublicTag kSelectorCSValue
      //(0072,0062)
      = const PublicTag(
          "SelectorCSValue", 0x00720062, "Selector CS Value", VR.kCS, VM.k1_n, false);
  static const PublicTag kSelectorISValue
      //(0072,0064)
      = const PublicTag(
          "SelectorISValue", 0x00720064, "Selector IS Value", VR.kIS, VM.k1_n, false);
  static const PublicTag kSelectorLOValue
      //(0072,0066)
      = const PublicTag(
          "SelectorLOValue", 0x00720066, "Selector LO Value", VR.kLO, VM.k1_n, false);
  static const PublicTag kSelectorLTValue
      //(0072,0068)
      = const PublicTag(
          "SelectorLTValue", 0x00720068, "Selector LT Value", VR.kLT, VM.k1, false);
  static const PublicTag kSelectorPNValue
      //(0072,006A)
      = const PublicTag(
          "SelectorPNValue", 0x0072006A, "Selector PN Value", VR.kPN, VM.k1_n, false);
  static const PublicTag kSelectorSHValue
      //(0072,006C)
      = const PublicTag(
          "SelectorSHValue", 0x0072006C, "Selector SH Value", VR.kSH, VM.k1_n, false);
  static const PublicTag kSelectorSTValue
      //(0072,006E)
      = const PublicTag(
          "SelectorSTValue", 0x0072006E, "Selector ST Value", VR.kST, VM.k1, false);
  static const PublicTag kSelectorUTValue
      //(0072,0070)
      = const PublicTag(
          "SelectorUTValue", 0x00720070, "Selector UT Value", VR.kUT, VM.k1, false);
  static const PublicTag kSelectorDSValue
      //(0072,0072)
      = const PublicTag(
          "SelectorDSValue", 0x00720072, "Selector DS Value", VR.kDS, VM.k1_n, false);
  static const PublicTag kSelectorODValue
      //(0072,0073)
      = const PublicTag(
          "SelectorODValue", 0x00720073, "Selector OD Value", VR.kOD, VM.k1, false);
  static const PublicTag kSelectorFDValue
      //(0072,0074)
      = const PublicTag(
          "SelectorFDValue", 0x00720074, "Selector FD Value", VR.kFD, VM.k1_n, false);
  static const PublicTag kSelectorFLValue
      //(0072,0076)
      = const PublicTag(
          "SelectorFLValue", 0x00720076, "Selector FL Value", VR.kFL, VM.k1_n, false);
  static const PublicTag kSelectorULValue
      //(0072,0078)
      = const PublicTag(
          "SelectorULValue", 0x00720078, "Selector UL Value", VR.kUL, VM.k1_n, false);
  static const PublicTag kSelectorUSValue
      //(0072,007A)
      = const PublicTag(
          "SelectorUSValue", 0x0072007A, "Selector US Value", VR.kUS, VM.k1_n, false);
  static const PublicTag kSelectorSLValue
      //(0072,007C)
      = const PublicTag(
          "SelectorSLValue", 0x0072007C, "Selector SL Value", VR.kSL, VM.k1_n, false);
  static const PublicTag kSelectorSSValue
      //(0072,007E)
      = const PublicTag(
          "SelectorSSValue", 0x0072007E, "Selector SS Value", VR.kSS, VM.k1_n, false);
  static const PublicTag kSelectorCodeSequenceValue
      //(0072,0080)
      = const PublicTag("SelectorCodeSequenceValue", 0x00720080,
          "Selector Code Sequence Value", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfScreens
      //(0072,0100)
      = const PublicTag(
          "NumberOfScreens", 0x00720100, "Number of Screens", VR.kUS, VM.k1, false);
  static const PublicTag kNominalScreenDefinitionSequence
      //(0072,0102)
      = const PublicTag("NominalScreenDefinitionSequence", 0x00720102,
          "Nominal Screen Definition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNumberOfVerticalPixels
      //(0072,0104)
      = const PublicTag("NumberOfVerticalPixels", 0x00720104, "Number of Vertical Pixels",
          VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfHorizontalPixels
      //(0072,0106)
      = const PublicTag("NumberOfHorizontalPixels", 0x00720106,
          "Number of Horizontal Pixels", VR.kUS, VM.k1, false);
  static const PublicTag kDisplayEnvironmentSpatialPosition
      //(0072,0108)
      = const PublicTag("DisplayEnvironmentSpatialPosition", 0x00720108,
          "Display Environment Spatial Position", VR.kFD, VM.k4, false);
  static const PublicTag kScreenMinimumGrayscaleBitDepth
      //(0072,010A)
      = const PublicTag("ScreenMinimumGrayscaleBitDepth", 0x0072010A,
          "Screen Minimum Grayscale Bit Depth", VR.kUS, VM.k1, false);
  static const PublicTag kScreenMinimumColorBitDepth
      //(0072,010C)
      = const PublicTag("ScreenMinimumColorBitDepth", 0x0072010C,
          "Screen Minimum Color Bit Depth", VR.kUS, VM.k1, false);
  static const PublicTag kApplicationMaximumRepaintTime
      //(0072,010E)
      = const PublicTag("ApplicationMaximumRepaintTime", 0x0072010E,
          "Application Maximum Repaint Time", VR.kUS, VM.k1, false);
  static const PublicTag kDisplaySetsSequence
      //(0072,0200)
      = const PublicTag("DisplaySetsSequence", 0x00720200, "Display Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDisplaySetNumber
      //(0072,0202)
      = const PublicTag(
          "DisplaySetNumber", 0x00720202, "Display Set Number", VR.kUS, VM.k1, false);
  static const PublicTag kDisplaySetLabel
      //(0072,0203)
      = const PublicTag(
          "DisplaySetLabel", 0x00720203, "Display Set Label", VR.kLO, VM.k1, false);
  static const PublicTag kDisplaySetPresentationGroup
      //(0072,0204)
      = const PublicTag("DisplaySetPresentationGroup", 0x00720204,
          "Display Set Presentation Group", VR.kUS, VM.k1, false);
  static const PublicTag kDisplaySetPresentationGroupDescription
      //(0072,0206)
      = const PublicTag("DisplaySetPresentationGroupDescription", 0x00720206,
          "Display Set Presentation Group Description", VR.kLO, VM.k1, false);
  static const PublicTag kPartialDataDisplayHandling
      //(0072,0208)
      = const PublicTag("PartialDataDisplayHandling", 0x00720208,
          "Partial Data Display Handling", VR.kCS, VM.k1, false);
  static const PublicTag kSynchronizedScrollingSequence
      //(0072,0210)
      = const PublicTag("SynchronizedScrollingSequence", 0x00720210,
          "Synchronized Scrolling Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDisplaySetScrollingGroup
      //(0072,0212)
      = const PublicTag("DisplaySetScrollingGroup", 0x00720212,
          "Display Set Scrolling Group", VR.kUS, VM.k2_n, false);
  static const PublicTag kNavigationIndicatorSequence
      //(0072,0214)
      = const PublicTag("NavigationIndicatorSequence", 0x00720214,
          "Navigation Indicator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kNavigationDisplaySet
      //(0072,0216)
      = const PublicTag("NavigationDisplaySet", 0x00720216, "Navigation Display Set",
          VR.kUS, VM.k1, false);
  static const PublicTag kReferenceDisplaySets
      //(0072,0218)
      = const PublicTag("ReferenceDisplaySets", 0x00720218, "Reference Display Sets",
          VR.kUS, VM.k1_n, false);
  static const PublicTag kImageBoxesSequence
      //(0072,0300)
      = const PublicTag(
          "ImageBoxesSequence", 0x00720300, "Image Boxes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageBoxNumber
      //(0072,0302)
      = const PublicTag(
          "ImageBoxNumber", 0x00720302, "Image Box Number", VR.kUS, VM.k1, false);
  static const PublicTag kImageBoxLayoutType
      //(0072,0304)
      = const PublicTag("ImageBoxLayoutType", 0x00720304, "Image Box Layout Type", VR.kCS,
          VM.k1, false);
  static const PublicTag kImageBoxTileHorizontalDimension
      //(0072,0306)
      = const PublicTag("ImageBoxTileHorizontalDimension", 0x00720306,
          "Image Box Tile Horizontal Dimension", VR.kUS, VM.k1, false);
  static const PublicTag kImageBoxTileVerticalDimension
      //(0072,0308)
      = const PublicTag("ImageBoxTileVerticalDimension", 0x00720308,
          "Image Box Tile Vertical Dimension", VR.kUS, VM.k1, false);
  static const PublicTag kImageBoxScrollDirection
      //(0072,0310)
      = const PublicTag("ImageBoxScrollDirection", 0x00720310,
          "Image Box Scroll Direction", VR.kCS, VM.k1, false);
  static const PublicTag kImageBoxSmallScrollType
      //(0072,0312)
      = const PublicTag("ImageBoxSmallScrollType", 0x00720312,
          "Image Box Small Scroll Type", VR.kCS, VM.k1, false);
  static const PublicTag kImageBoxSmallScrollAmount
      //(0072,0314)
      = const PublicTag("ImageBoxSmallScrollAmount", 0x00720314,
          "Image Box Small Scroll Amount", VR.kUS, VM.k1, false);
  static const PublicTag kImageBoxLargeScrollType
      //(0072,0316)
      = const PublicTag("ImageBoxLargeScrollType", 0x00720316,
          "Image Box Large Scroll Type", VR.kCS, VM.k1, false);
  static const PublicTag kImageBoxLargeScrollAmount
      //(0072,0318)
      = const PublicTag("ImageBoxLargeScrollAmount", 0x00720318,
          "Image Box Large Scroll Amount", VR.kUS, VM.k1, false);
  static const PublicTag kImageBoxOverlapPriority
      //(0072,0320)
      = const PublicTag("ImageBoxOverlapPriority", 0x00720320,
          "Image Box Overlap Priority", VR.kUS, VM.k1, false);
  static const PublicTag kCineRelativeToRealTime
      //(0072,0330)
      = const PublicTag("CineRelativeToRealTime", 0x00720330,
          "Cine Relative to Real-Time", VR.kFD, VM.k1, false);
  static const PublicTag kFilterOperationsSequence
      //(0072,0400)
      = const PublicTag("FilterOperationsSequence", 0x00720400,
          "Filter Operations Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFilterByCategory
      //(0072,0402)
      = const PublicTag(
          "FilterByCategory", 0x00720402, "Filter-by Category", VR.kCS, VM.k1, false);
  static const PublicTag kFilterByAttributePresence
      //(0072,0404)
      = const PublicTag("FilterByAttributePresence", 0x00720404,
          "Filter-by Attribute Presence", VR.kCS, VM.k1, false);
  static const PublicTag kFilterByOperator
      //(0072,0406)
      = const PublicTag(
          "FilterByOperator", 0x00720406, "Filter-by Operator", VR.kCS, VM.k1, false);
  static const PublicTag kStructuredDisplayBackgroundCIELabValue
      //(0072,0420)
      = const PublicTag("StructuredDisplayBackgroundCIELabValue", 0x00720420,
          "Structured Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kEmptyImageBoxCIELabValue
      //(0072,0421)
      = const PublicTag("EmptyImageBoxCIELabValue", 0x00720421,
          "Empty Image Box CIELab Value", VR.kUS, VM.k3, false);
  static const PublicTag kStructuredDisplayImageBoxSequence
      //(0072,0422)
      = const PublicTag("StructuredDisplayImageBoxSequence", 0x00720422,
          "Structured Display Image Box Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStructuredDisplayTextBoxSequence
      //(0072,0424)
      = const PublicTag("StructuredDisplayTextBoxSequence", 0x00720424,
          "Structured Display Text Box Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedFirstFrameSequence
      //(0072,0427)
      = const PublicTag("ReferencedFirstFrameSequence", 0x00720427,
          "Referenced First Frame Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageBoxSynchronizationSequence
      //(0072,0430)
      = const PublicTag("ImageBoxSynchronizationSequence", 0x00720430,
          "Image Box Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSynchronizedImageBoxList
      //(0072,0432)
      = const PublicTag("SynchronizedImageBoxList", 0x00720432,
          "Synchronized Image Box List", VR.kUS, VM.k2_n, false);
  static const PublicTag kTypeOfSynchronization
      //(0072,0434)
      = const PublicTag("TypeOfSynchronization", 0x00720434, "Type of Synchronization",
          VR.kCS, VM.k1, false);
  static const PublicTag kBlendingOperationType
      //(0072,0500)
      = const PublicTag("BlendingOperationType", 0x00720500, "Blending Operation Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kReformattingOperationType
      //(0072,0510)
      = const PublicTag("ReformattingOperationType", 0x00720510,
          "Reformatting Operation Type", VR.kCS, VM.k1, false);
  static const PublicTag kReformattingThickness
      //(0072,0512)
      = const PublicTag("ReformattingThickness", 0x00720512, "Reformatting Thickness",
          VR.kFD, VM.k1, false);
  static const PublicTag kReformattingInterval
      //(0072,0514)
      = const PublicTag("ReformattingInterval", 0x00720514, "Reformatting Interval",
          VR.kFD, VM.k1, false);
  static const PublicTag kReformattingOperationInitialViewDirection
      //(0072,0516)
      = const PublicTag("ReformattingOperationInitialViewDirection", 0x00720516,
          "Reformatting Operation Initial View Direction", VR.kCS, VM.k1, false);
  static const PublicTag kThreeDRenderingType
      //(0072,0520)
      = const PublicTag(
          "ThreeDRenderingType", 0x00720520, "3D Rendering Type", VR.kCS, VM.k1_n, false);
  static const PublicTag kSortingOperationsSequence
      //(0072,0600)
      = const PublicTag("SortingOperationsSequence", 0x00720600,
          "Sorting Operations Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSortByCategory
      //(0072,0602)
      = const PublicTag(
          "SortByCategory", 0x00720602, "Sort-by Category", VR.kCS, VM.k1, false);
  static const PublicTag kSortingDirection
      //(0072,0604)
      = const PublicTag(
          "SortingDirection", 0x00720604, "Sorting Direction", VR.kCS, VM.k1, false);
  static const PublicTag kDisplaySetPatientOrientation
      //(0072,0700)
      = const PublicTag("DisplaySetPatientOrientation", 0x00720700,
          "Display Set Patient Orientation", VR.kCS, VM.k2, false);
  static const PublicTag kVOIType
      //(0072,0702)
      = const PublicTag("VOIType", 0x00720702, "VOI Type", VR.kCS, VM.k1, false);
  static const PublicTag kPseudoColorType
      //(0072,0704)
      = const PublicTag(
          "PseudoColorType", 0x00720704, "Pseudo-Color Type", VR.kCS, VM.k1, false);
  static const PublicTag kPseudoColorPaletteInstanceReferenceSequence
      //(0072,0705)
      = const PublicTag("PseudoColorPaletteInstanceReferenceSequence", 0x00720705,
          "Pseudo-Color Palette Instance Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kShowGrayscaleInverted
      //(0072,0706)
      = const PublicTag("ShowGrayscaleInverted", 0x00720706, "Show Grayscale Inverted",
          VR.kCS, VM.k1, false);
  static const PublicTag kShowImageTrueSizeFlag
      //(0072,0710)
      = const PublicTag("ShowImageTrueSizeFlag", 0x00720710, "Show Image True Size Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kShowGraphicAnnotationFlag
      //(0072,0712)
      = const PublicTag("ShowGraphicAnnotationFlag", 0x00720712,
          "Show Graphic Annotation Flag", VR.kCS, VM.k1, false);
  static const PublicTag kShowPatientDemographicsFlag
      //(0072,0714)
      = const PublicTag("ShowPatientDemographicsFlag", 0x00720714,
          "Show Patient Demographics Flag", VR.kCS, VM.k1, false);
  static const PublicTag kShowAcquisitionTechniquesFlag
      //(0072,0716)
      = const PublicTag("ShowAcquisitionTechniquesFlag", 0x00720716,
          "Show Acquisition Techniques Flag", VR.kCS, VM.k1, false);
  static const PublicTag kDisplaySetHorizontalJustification
      //(0072,0717)
      = const PublicTag("DisplaySetHorizontalJustification", 0x00720717,
          "Display Set Horizontal Justification", VR.kCS, VM.k1, false);
  static const PublicTag kDisplaySetVerticalJustification
      //(0072,0718)
      = const PublicTag("DisplaySetVerticalJustification", 0x00720718,
          "Display Set Vertical Justification", VR.kCS, VM.k1, false);
  static const PublicTag kContinuationStartMeterset
      //(0074,0120)
      = const PublicTag("ContinuationStartMeterset", 0x00740120,
          "Continuation Start Meterset", VR.kFD, VM.k1, false);
  static const PublicTag kContinuationEndMeterset
      //(0074,0121)
      = const PublicTag("ContinuationEndMeterset", 0x00740121,
          "Continuation End Meterset", VR.kFD, VM.k1, false);
  static const PublicTag kProcedureStepState
      //(0074,1000)
      = const PublicTag(
          "ProcedureStepState", 0x00741000, "Procedure Step State", VR.kCS, VM.k1, false);
  static const PublicTag kProcedureStepProgressInformationSequence
      //(0074,1002)
      = const PublicTag("ProcedureStepProgressInformationSequence", 0x00741002,
          "Procedure Step Progress Information Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kProcedureStepProgress
      //(0074,1004)
      = const PublicTag("ProcedureStepProgress", 0x00741004, "Procedure Step Progress",
          VR.kDS, VM.k1, false);
  static const PublicTag kProcedureStepProgressDescription
      //(0074,1006)
      = const PublicTag("ProcedureStepProgressDescription", 0x00741006,
          "Procedure Step Progress Description", VR.kST, VM.k1, false);
  static const PublicTag kProcedureStepCommunicationsURISequence
      //(0074,1008)
      = const PublicTag("ProcedureStepCommunicationsURISequence", 0x00741008,
          "Procedure Step Communications URI Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContactURI
      //(0074,100a)
      = const PublicTag("ContactURI", 0x0074100a, "Contact URI", VR.kST, VM.k1, false);
  static const PublicTag kContactDisplayName
      //(0074,100c)
      = const PublicTag(
          "ContactDisplayName", 0x0074100c, "Contact Display Name", VR.kLO, VM.k1, false);
  static const PublicTag kProcedureStepDiscontinuationReasonCodeSequence
      //(0074,100e)
      = const PublicTag("ProcedureStepDiscontinuationReasonCodeSequence", 0x0074100e,
          "Procedure Step Discontinuation Reason Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBeamTaskSequence
      //(0074,1020)
      = const PublicTag(
          "BeamTaskSequence", 0x00741020, "Beam Task Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBeamTaskType
      //(0074,1022)
      =
      const PublicTag("BeamTaskType", 0x00741022, "Beam Task Type", VR.kCS, VM.k1, false);
  static const PublicTag kBeamOrderIndexTrial
      //(0074,1024)
      = const PublicTag("BeamOrderIndexTrial", 0x00741024, "Beam Order Index (Trial)",
          VR.kIS, VM.k1, true);
  static const PublicTag kAutosequenceFlag
      //(0074,1025)
      = const PublicTag(
          "AutosequenceFlag", 0x00741025, "Autosequence Flag", VR.kCS, VM.k1, false);
  static const PublicTag kTableTopVerticalAdjustedPosition
      //(0074,1026)
      = const PublicTag("TableTopVerticalAdjustedPosition", 0x00741026,
          "Table Top Vertical Adjusted Position", VR.kFD, VM.k1, false);
  static const PublicTag kTableTopLongitudinalAdjustedPosition
      //(0074,1027)
      = const PublicTag("TableTopLongitudinalAdjustedPosition", 0x00741027,
          "Table Top Longitudinal Adjusted Position", VR.kFD, VM.k1, false);
  static const PublicTag kTableTopLateralAdjustedPosition
      //(0074,1028)
      = const PublicTag("TableTopLateralAdjustedPosition", 0x00741028,
          "Table Top Lateral Adjusted Position", VR.kFD, VM.k1, false);
  static const PublicTag kPatientSupportAdjustedAngle
      //(0074,102A)
      = const PublicTag("PatientSupportAdjustedAngle", 0x0074102A,
          "Patient Support Adjusted Angle", VR.kFD, VM.k1, false);
  static const PublicTag kTableTopEccentricAdjustedAngle
      //(0074,102B)
      = const PublicTag("TableTopEccentricAdjustedAngle", 0x0074102B,
          "Table Top Eccentric Adjusted Angle", VR.kFD, VM.k1, false);
  static const PublicTag kTableTopPitchAdjustedAngle
      //(0074,102C)
      = const PublicTag("TableTopPitchAdjustedAngle", 0x0074102C,
          "Table Top Pitch Adjusted Angle", VR.kFD, VM.k1, false);
  static const PublicTag kTableTopRollAdjustedAngle
      //(0074,102D)
      = const PublicTag("TableTopRollAdjustedAngle", 0x0074102D,
          "Table Top Roll Adjusted Angle", VR.kFD, VM.k1, false);
  static const PublicTag kDeliveryVerificationImageSequence
      //(0074,1030)
      = const PublicTag("DeliveryVerificationImageSequence", 0x00741030,
          "Delivery Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kVerificationImageTiming
      //(0074,1032)
      = const PublicTag("VerificationImageTiming", 0x00741032,
          "Verification Image Timing", VR.kCS, VM.k1, false);
  static const PublicTag kDoubleExposureFlag
      //(0074,1034)
      = const PublicTag(
          "DoubleExposureFlag", 0x00741034, "Double Exposure Flag", VR.kCS, VM.k1, false);
  static const PublicTag kDoubleExposureOrdering
      //(0074,1036)
      = const PublicTag("DoubleExposureOrdering", 0x00741036, "Double Exposure Ordering",
          VR.kCS, VM.k1, false);
  static const PublicTag kDoubleExposureMetersetTrial
      //(0074,1038)
      = const PublicTag("DoubleExposureMetersetTrial", 0x00741038,
          "Double Exposure Meterset (Trial)", VR.kDS, VM.k1, true);
  static const PublicTag kDoubleExposureFieldDeltaTrial
      //(0074,103A)
      = const PublicTag("DoubleExposureFieldDeltaTrial", 0x0074103A,
          "Double Exposure Field Delta (Trial)", VR.kDS, VM.k4, true);
  static const PublicTag kRelatedReferenceRTImageSequence
      //(0074,1040)
      = const PublicTag("RelatedReferenceRTImageSequence", 0x00741040,
          "Related Reference RT Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGeneralMachineVerificationSequence
      //(0074,1042)
      = const PublicTag("GeneralMachineVerificationSequence", 0x00741042,
          "General Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kConventionalMachineVerificationSequence
      //(0074,1044)
      = const PublicTag("ConventionalMachineVerificationSequence", 0x00741044,
          "Conventional Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonMachineVerificationSequence
      //(0074,1046)
      = const PublicTag("IonMachineVerificationSequence", 0x00741046,
          "Ion Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFailedAttributesSequence
      //(0074,1048)
      = const PublicTag("FailedAttributesSequence", 0x00741048,
          "Failed Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOverriddenAttributesSequence
      //(0074,104A)
      = const PublicTag("OverriddenAttributesSequence", 0x0074104A,
          "Overridden Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kConventionalControlPointVerificationSequence
      //(0074,104C)
      = const PublicTag("ConventionalControlPointVerificationSequence", 0x0074104C,
          "Conventional Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonControlPointVerificationSequence
      //(0074,104E)
      = const PublicTag("IonControlPointVerificationSequence", 0x0074104E,
          "Ion Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAttributeOccurrenceSequence
      //(0074,1050)
      = const PublicTag("AttributeOccurrenceSequence", 0x00741050,
          "Attribute Occurrence Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAttributeOccurrencePointer
      //(0074,1052)
      = const PublicTag("AttributeOccurrencePointer", 0x00741052,
          "Attribute Occurrence Pointer", VR.kAT, VM.k1, false);
  static const PublicTag kAttributeItemSelector
      //(0074,1054)
      = const PublicTag("AttributeItemSelector", 0x00741054, "Attribute Item Selector",
          VR.kUL, VM.k1, false);
  static const PublicTag kAttributeOccurrencePrivateCreator
      //(0074,1056)
      = const PublicTag("AttributeOccurrencePrivateCreator", 0x00741056,
          "Attribute Occurrence Private Creator", VR.kLO, VM.k1, false);
  static const PublicTag kSelectorSequencePointerItems
      //(0074,1057)
      = const PublicTag("SelectorSequencePointerItems", 0x00741057,
          "Selector Sequence Pointer Items", VR.kIS, VM.k1_n, false);
  static const PublicTag kScheduledProcedureStepPriority
      //(0074,1200)
      = const PublicTag("ScheduledProcedureStepPriority", 0x00741200,
          "Scheduled Procedure Step Priority", VR.kCS, VM.k1, false);
  static const PublicTag kWorklistLabel
      //(0074,1202)
      = const PublicTag(
          "WorklistLabel", 0x00741202, "Worklist Label", VR.kLO, VM.k1, false);
  static const PublicTag kProcedureStepLabel
      //(0074,1204)
      = const PublicTag(
          "ProcedureStepLabel", 0x00741204, "Procedure Step Label", VR.kLO, VM.k1, false);
  static const PublicTag kScheduledProcessingParametersSequence
      //(0074,1210)
      = const PublicTag("ScheduledProcessingParametersSequence", 0x00741210,
          "Scheduled Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerformedProcessingParametersSequence
      //(0074,1212)
      = const PublicTag("PerformedProcessingParametersSequence", 0x00741212,
          "Performed Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kUnifiedProcedureStepPerformedProcedureSequence
      //(0074,1216)
      = const PublicTag("UnifiedProcedureStepPerformedProcedureSequence", 0x00741216,
          "Unified Procedure Step Performed Procedure Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRelatedProcedureStepSequence
      //(0074,1220)
      = const PublicTag("RelatedProcedureStepSequence", 0x00741220,
          "Related Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kProcedureStepRelationshipType
      //(0074,1222)
      = const PublicTag("ProcedureStepRelationshipType", 0x00741222,
          "Procedure Step Relationship Type", VR.kLO, VM.k1, true);
  static const PublicTag kReplacedProcedureStepSequence
      //(0074,1224)
      = const PublicTag("ReplacedProcedureStepSequence", 0x00741224,
          "Replaced Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDeletionLock
      //(0074,1230)
      =
      const PublicTag("DeletionLock", 0x00741230, "Deletion Lock", VR.kLO, VM.k1, false);
  static const PublicTag kReceivingAE
      //(0074,1234)
      = const PublicTag("ReceivingAE", 0x00741234, "Receiving AE", VR.kAE, VM.k1, false);
  static const PublicTag kRequestingAE
      //(0074,1236)
      =
      const PublicTag("RequestingAE", 0x00741236, "Requesting AE", VR.kAE, VM.k1, false);
  static const PublicTag kReasonForCancellation
      //(0074,1238)
      = const PublicTag("ReasonForCancellation", 0x00741238, "Reason for Cancellation",
          VR.kLT, VM.k1, false);
  static const PublicTag kSCPStatus
      //(0074,1242)
      = const PublicTag("SCPStatus", 0x00741242, "SCP Status", VR.kCS, VM.k1, false);
  static const PublicTag kSubscriptionListStatus
      //(0074,1244)
      = const PublicTag("SubscriptionListStatus", 0x00741244, "Subscription List Status",
          VR.kCS, VM.k1, false);
  static const PublicTag kUnifiedProcedureStepListStatus
      //(0074,1246)
      = const PublicTag("UnifiedProcedureStepListStatus", 0x00741246,
          "Unified Procedure StepList Status", VR.kCS, VM.k1, false);
  static const PublicTag kBeamOrderIndex
      //(0074,1324)
      = const PublicTag(
          "BeamOrderIndex", 0x00741324, "Beam Order Index", VR.kUL, VM.k1, false);
  static const PublicTag kDoubleExposureMeterset
      //(0074,1338)
      = const PublicTag("DoubleExposureMeterset", 0x00741338, "Double Exposure Meterset",
          VR.kFD, VM.k1, false);
  static const PublicTag kDoubleExposureFieldDelta
      //(0074,133A)
      = const PublicTag("DoubleExposureFieldDelta", 0x0074133A,
          "Double Exposure Field Delta", VR.kFD, VM.k4, false);
  static const PublicTag kImplantAssemblyTemplateName
      //(0076,0001)
      = const PublicTag("ImplantAssemblyTemplateName", 0x00760001,
          "Implant Assembly Template Name", VR.kLO, VM.k1, false);
  static const PublicTag kImplantAssemblyTemplateIssuer
      //(0076,0003)
      = const PublicTag("ImplantAssemblyTemplateIssuer", 0x00760003,
          "Implant Assembly Template Issuer", VR.kLO, VM.k1, false);
  static const PublicTag kImplantAssemblyTemplateVersion
      //(0076,0006)
      = const PublicTag("ImplantAssemblyTemplateVersion", 0x00760006,
          "Implant Assembly Template Version", VR.kLO, VM.k1, false);
  static const PublicTag kReplacedImplantAssemblyTemplateSequence
      //(0076,0008)
      = const PublicTag("ReplacedImplantAssemblyTemplateSequence", 0x00760008,
          "Replaced Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantAssemblyTemplateType
      //(0076,000A)
      = const PublicTag("ImplantAssemblyTemplateType", 0x0076000A,
          "Implant Assembly Template Type", VR.kCS, VM.k1, false);
  static const PublicTag kOriginalImplantAssemblyTemplateSequence
      //(0076,000C)
      = const PublicTag("OriginalImplantAssemblyTemplateSequence", 0x0076000C,
          "Original Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDerivationImplantAssemblyTemplateSequence
      //(0076,000E)
      = const PublicTag("DerivationImplantAssemblyTemplateSequence", 0x0076000E,
          "Derivation Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantAssemblyTemplateTargetAnatomySequence
      //(0076,0010)
      = const PublicTag("ImplantAssemblyTemplateTargetAnatomySequence", 0x00760010,
          "Implant Assembly Template Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kProcedureTypeCodeSequence
      //(0076,0020)
      = const PublicTag("ProcedureTypeCodeSequence", 0x00760020,
          "Procedure Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurgicalTechnique
      //(0076,0030)
      = const PublicTag(
          "SurgicalTechnique", 0x00760030, "Surgical Technique", VR.kLO, VM.k1, false);
  static const PublicTag kComponentTypesSequence
      //(0076,0032)
      = const PublicTag("ComponentTypesSequence", 0x00760032, "Component Types Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kComponentTypeCodeSequence
      //(0076,0034)
      = const PublicTag("ComponentTypeCodeSequence", 0x00760034,
          "Component Type Code Sequence", VR.kCS, VM.k1, false);
  static const PublicTag kExclusiveComponentType
      //(0076,0036)
      = const PublicTag("ExclusiveComponentType", 0x00760036, "Exclusive Component Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kMandatoryComponentType
      //(0076,0038)
      = const PublicTag("MandatoryComponentType", 0x00760038, "Mandatory Component Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kComponentSequence
      //(0076,0040)
      = const PublicTag(
          "ComponentSequence", 0x00760040, "Component Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kComponentID
      //(0076,0055)
      = const PublicTag("ComponentID", 0x00760055, "Component ID", VR.kUS, VM.k1, false);
  static const PublicTag kComponentAssemblySequence
      //(0076,0060)
      = const PublicTag("ComponentAssemblySequence", 0x00760060,
          "Component Assembly Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kComponent1ReferencedID
      //(0076,0070)
      = const PublicTag("Component1ReferencedID", 0x00760070, "Component 1 Referenced ID",
          VR.kUS, VM.k1, false);
  static const PublicTag kComponent1ReferencedMatingFeatureSetID
      //(0076,0080)
      = const PublicTag("Component1ReferencedMatingFeatureSetID", 0x00760080,
          "Component 1 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const PublicTag kComponent1ReferencedMatingFeatureID
      //(0076,0090)
      = const PublicTag("Component1ReferencedMatingFeatureID", 0x00760090,
          "Component 1 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const PublicTag kComponent2ReferencedID
      //(0076,00A0)
      = const PublicTag("Component2ReferencedID", 0x007600A0, "Component 2 Referenced ID",
          VR.kUS, VM.k1, false);
  static const PublicTag kComponent2ReferencedMatingFeatureSetID
      //(0076,00B0)
      = const PublicTag("Component2ReferencedMatingFeatureSetID", 0x007600B0,
          "Component 2 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const PublicTag kComponent2ReferencedMatingFeatureID
      //(0076,00C0)
      = const PublicTag("Component2ReferencedMatingFeatureID", 0x007600C0,
          "Component 2 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const PublicTag kImplantTemplateGroupName
      //(0078,0001)
      = const PublicTag("ImplantTemplateGroupName", 0x00780001,
          "Implant Template Group Name", VR.kLO, VM.k1, false);
  static const PublicTag kImplantTemplateGroupDescription
      //(0078,0010)
      = const PublicTag("ImplantTemplateGroupDescription", 0x00780010,
          "Implant Template Group Description", VR.kST, VM.k1, false);
  static const PublicTag kImplantTemplateGroupIssuer
      //(0078,0020)
      = const PublicTag("ImplantTemplateGroupIssuer", 0x00780020,
          "Implant Template Group Issuer", VR.kLO, VM.k1, false);
  static const PublicTag kImplantTemplateGroupVersion
      //(0078,0024)
      = const PublicTag("ImplantTemplateGroupVersion", 0x00780024,
          "Implant Template Group Version", VR.kLO, VM.k1, false);
  static const PublicTag kReplacedImplantTemplateGroupSequence
      //(0078,0026)
      = const PublicTag("ReplacedImplantTemplateGroupSequence", 0x00780026,
          "Replaced Implant Template Group Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantTemplateGroupTargetAnatomySequence
      //(0078,0028)
      = const PublicTag("ImplantTemplateGroupTargetAnatomySequence", 0x00780028,
          "Implant Template Group Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantTemplateGroupMembersSequence
      //(0078,002A)
      = const PublicTag("ImplantTemplateGroupMembersSequence", 0x0078002A,
          "Implant Template Group Members Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantTemplateGroupMemberID
      //(0078,002E)
      = const PublicTag("ImplantTemplateGroupMemberID", 0x0078002E,
          "Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const PublicTag kThreeDImplantTemplateGroupMemberMatchingPoint
      //(0078,0050)
      = const PublicTag("ThreeDImplantTemplateGroupMemberMatchingPoint", 0x00780050,
          "3D Implant Template Group Member Matching Point", VR.kFD, VM.k3, false);
  static const PublicTag kThreeDImplantTemplateGroupMemberMatchingAxes
      //(0078,0060)
      = const PublicTag("ThreeDImplantTemplateGroupMemberMatchingAxes", 0x00780060,
          "3D Implant Template Group Member Matching Axes", VR.kFD, VM.k9, false);
  static const PublicTag kImplantTemplateGroupMemberMatching2DCoordinatesSequence
      //(0078,0070)
      = const PublicTag(
          "ImplantTemplateGroupMemberMatching2DCoordinatesSequence",
          0x00780070,
          "Implant Template Group Member Matching 2D Coordinates Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kTwoDImplantTemplateGroupMemberMatchingPoint
      //(0078,0090)
      = const PublicTag("TwoDImplantTemplateGroupMemberMatchingPoint", 0x00780090,
          "2D Implant Template Group Member Matching Point", VR.kFD, VM.k2, false);
  static const PublicTag kTwoDImplantTemplateGroupMemberMatchingAxes
      //(0078,00A0)
      = const PublicTag("TwoDImplantTemplateGroupMemberMatchingAxes", 0x007800A0,
          "2D Implant Template Group Member Matching Axes", VR.kFD, VM.k4, false);
  static const PublicTag kImplantTemplateGroupVariationDimensionSequence
      //(0078,00B0)
      = const PublicTag("ImplantTemplateGroupVariationDimensionSequence", 0x007800B0,
          "Implant Template Group Variation Dimension Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImplantTemplateGroupVariationDimensionName
      //(0078,00B2)
      = const PublicTag("ImplantTemplateGroupVariationDimensionName", 0x007800B2,
          "Implant Template Group Variation Dimension Name", VR.kLO, VM.k1, false);
  static const PublicTag kImplantTemplateGroupVariationDimensionRankSequence
      //(0078,00B4)
      = const PublicTag(
          "ImplantTemplateGroupVariationDimensionRankSequence",
          0x007800B4,
          "Implant Template Group Variation Dimension Rank Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const PublicTag kReferencedImplantTemplateGroupMemberID
      //(0078,00B6)
      = const PublicTag("ReferencedImplantTemplateGroupMemberID", 0x007800B6,
          "Referenced Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const PublicTag kImplantTemplateGroupVariationDimensionRank
      //(0078,00B8)
      = const PublicTag("ImplantTemplateGroupVariationDimensionRank", 0x007800B8,
          "Implant Template Group Variation Dimension Rank", VR.kUS, VM.k1, false);
  static const PublicTag kSurfaceScanAcquisitionTypeCodeSequence
      //(0080,0001)
      = const PublicTag("SurfaceScanAcquisitionTypeCodeSequence", 0x00800001,
          "Surface Scan Acquisition Type Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSurfaceScanModeCodeSequence
      //(0080,0002)
      = const PublicTag("SurfaceScanModeCodeSequence", 0x00800002,
          "Surface Scan Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRegistrationMethodCodeSequence
      //(0080,0003)
      = const PublicTag("RegistrationMethodCodeSequence", 0x00800003,
          "Registration Method Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kShotDurationTime
      //(0080,0004)
      = const PublicTag(
          "ShotDurationTime", 0x00800004, "Shot Duration Time", VR.kFD, VM.k1, false);
  static const PublicTag kShotOffsetTime
      //(0080,0005)
      = const PublicTag(
          "ShotOffsetTime", 0x00800005, "Shot Offset Time", VR.kFD, VM.k1, false);
  static const PublicTag kSurfacePointPresentationValueData
      //(0080,0006)
      = const PublicTag("SurfacePointPresentationValueData", 0x00800006,
          "Surface Point Presentation Value Data", VR.kUS, VM.k1_n, false);
  static const PublicTag kSurfacePointColorCIELabValueData
      //(0080,0007)
      = const PublicTag("SurfacePointColorCIELabValueData", 0x00800007,
          "Surface Point Color CIELab Value Data", VR.kUS, VM.k3_3n, false);
  static const PublicTag kUVMappingSequence
      //(0080,0008)
      = const PublicTag(
          "UVMappingSequence", 0x00800008, "UV Mapping Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTextureLabel
      //(0080,0009)
      =
      const PublicTag("TextureLabel", 0x00800009, "Texture Label", VR.kSH, VM.k1, false);
  static const PublicTag kUValueData
      //(0080,0010)
      = const PublicTag("UValueData", 0x00800010, "U Value Data", VR.kOF, VM.k1_n, false);
  static const PublicTag kVValueData
      //(0080,0011)
      = const PublicTag("VValueData", 0x00800011, "V Value Data", VR.kOF, VM.k1_n, false);
  static const PublicTag kReferencedTextureSequence
      //(0080,0012)
      = const PublicTag("ReferencedTextureSequence", 0x00800012,
          "Referenced Texture Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSurfaceDataSequence
      //(0080,0013)
      = const PublicTag("ReferencedSurfaceDataSequence", 0x00800013,
          "Referenced Surface Data Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStorageMediaFileSetID
      //(0088,0130)
      = const PublicTag("StorageMediaFileSetID", 0x00880130, "Storage Media File-set ID",
          VR.kSH, VM.k1, false);
  static const PublicTag kStorageMediaFileSetUID
      //(0088,0140)
      = const PublicTag("StorageMediaFileSetUID", 0x00880140,
          "Storage Media File-set UID", VR.kUI, VM.k1, false);
  static const PublicTag kIconImageSequence
      //(0088,0200)
      = const PublicTag(
          "IconImageSequence", 0x00880200, "Icon Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTopicTitle
      //(0088,0904)
      = const PublicTag("TopicTitle", 0x00880904, "Topic Title", VR.kLO, VM.k1, true);
  static const PublicTag kTopicSubject
      //(0088,0906)
      = const PublicTag("TopicSubject", 0x00880906, "Topic Subject", VR.kST, VM.k1, true);
  static const PublicTag kTopicAuthor
      //(0088,0910)
      = const PublicTag("TopicAuthor", 0x00880910, "Topic Author", VR.kLO, VM.k1, true);
  static const PublicTag kTopicKeywords
      //(0088,0912)
      = const PublicTag(
          "TopicKeywords", 0x00880912, "Topic Keywords", VR.kLO, VM.k1_32, true);
  static const PublicTag kSOPInstanceStatus
      //(0100,0410)
      = const PublicTag(
          "SOPInstanceStatus", 0x01000410, "SOP Instance Status", VR.kCS, VM.k1, false);
  static const PublicTag kSOPAuthorizationDateTime
      //(0100,0420)
      = const PublicTag("SOPAuthorizationDateTime", 0x01000420,
          "SOP Authorization DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kSOPAuthorizationComment
      //(0100,0424)
      = const PublicTag("SOPAuthorizationComment", 0x01000424,
          "SOP Authorization Comment", VR.kLT, VM.k1, false);
  static const PublicTag kAuthorizationEquipmentCertificationNumber
      //(0100,0426)
      = const PublicTag("AuthorizationEquipmentCertificationNumber", 0x01000426,
          "Authorization Equipment Certification Number", VR.kLO, VM.k1, false);
  static const PublicTag kMACIDNumber
      //(0400,0005)
      = const PublicTag("MACIDNumber", 0x04000005, "MAC ID Number", VR.kUS, VM.k1, false);
  static const PublicTag kMACCalculationTransferSyntaxUID
      //(0400,0010)
      = const PublicTag("MACCalculationTransferSyntaxUID", 0x04000010,
          "MAC Calculation Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const PublicTag kMACAlgorithm
      //(0400,0015)
      =
      const PublicTag("MACAlgorithm", 0x04000015, "MAC Algorithm", VR.kCS, VM.k1, false);
  static const PublicTag kDataElementsSigned
      //(0400,0020)
      = const PublicTag("DataElementsSigned", 0x04000020, "Data Elements Signed", VR.kAT,
          VM.k1_n, false);
  static const PublicTag kDigitalSignatureUID
      //(0400,0100)
      = const PublicTag("DigitalSignatureUID", 0x04000100, "Digital Signature UID",
          VR.kUI, VM.k1, false);
  static const PublicTag kDigitalSignatureDateTime
      //(0400,0105)
      = const PublicTag("DigitalSignatureDateTime", 0x04000105,
          "Digital Signature DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kCertificateType
      //(0400,0110)
      = const PublicTag(
          "CertificateType", 0x04000110, "Certificate Type", VR.kCS, VM.k1, false);
  static const PublicTag kCertificateOfSigner
      //(0400,0115)
      = const PublicTag("CertificateOfSigner", 0x04000115, "Certificate of Signer",
          VR.kOB, VM.k1, false);
  static const PublicTag kSignature
      //(0400,0120)
      = const PublicTag("Signature", 0x04000120, "Signature", VR.kOB, VM.k1, false);
  static const PublicTag kCertifiedTimestampType
      //(0400,0305)
      = const PublicTag("CertifiedTimestampType", 0x04000305, "Certified Timestamp Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kCertifiedTimestamp
      //(0400,0310)
      = const PublicTag(
          "CertifiedTimestamp", 0x04000310, "Certified Timestamp", VR.kOB, VM.k1, false);
  static const PublicTag kDigitalSignaturePurposeCodeSequence
      //(0400,0401)
      = const PublicTag("DigitalSignaturePurposeCodeSequence", 0x04000401,
          "Digital Signature Purpose Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedDigitalSignatureSequence
      //(0400,0402)
      = const PublicTag("ReferencedDigitalSignatureSequence", 0x04000402,
          "Referenced Digital Signature Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSOPInstanceMACSequence
      //(0400,0403)
      = const PublicTag("ReferencedSOPInstanceMACSequence", 0x04000403,
          "Referenced SOP Instance MAC Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMAC
      //(0400,0404)
      = const PublicTag("MAC", 0x04000404, "MAC", VR.kOB, VM.k1, false);
  static const PublicTag kEncryptedAttributesSequence
      //(0400,0500)
      = const PublicTag("EncryptedAttributesSequence", 0x04000500,
          "Encrypted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kEncryptedContentTransferSyntaxUID
      //(0400,0510)
      = const PublicTag("EncryptedContentTransferSyntaxUID", 0x04000510,
          "Encrypted Content Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const PublicTag kEncryptedContent
      //(0400,0520)
      = const PublicTag(
          "EncryptedContent", 0x04000520, "Encrypted Content", VR.kOB, VM.k1, false);
  static const PublicTag kModifiedAttributesSequence
      //(0400,0550)
      = const PublicTag("ModifiedAttributesSequence", 0x04000550,
          "Modified Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kOriginalAttributesSequence
      //(0400,0561)
      = const PublicTag("OriginalAttributesSequence", 0x04000561,
          "Original Attributes Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAttributeModificationDateTime
      //(0400,0562)
      = const PublicTag("AttributeModificationDateTime", 0x04000562,
          "Attribute Modification DateTime", VR.kDT, VM.k1, false);
  static const PublicTag kModifyingSystem
      //(0400,0563)
      = const PublicTag(
          "ModifyingSystem", 0x04000563, "Modifying System", VR.kLO, VM.k1, false);
  static const PublicTag kSourceOfPreviousValues
      //(0400,0564)
      = const PublicTag("SourceOfPreviousValues", 0x04000564, "Source of Previous Values",
          VR.kLO, VM.k1, false);
  static const PublicTag kReasonForTheAttributeModification
      //(0400,0565)
      = const PublicTag("ReasonForTheAttributeModification", 0x04000565,
          "Reason for the Attribute Modification", VR.kCS, VM.k1, false);
  static const PublicTag kEscapeTriplet
      //(1000,0000)
      =
      const PublicTag("EscapeTriplet", 0x10000000, "Escape Triplet", VR.kUS, VM.k3, true);
  static const PublicTag kRunLengthTriplet
      //(1000,0001)
      = const PublicTag(
          "RunLengthTriplet", 0x10000001, "Run Length Triplet", VR.kUS, VM.k3, true);
  static const PublicTag kHuffmanTableSize
      //(1000,0002)
      = const PublicTag(
          "HuffmanTableSize", 0x10000002, "Huffman Table Size", VR.kUS, VM.k1, true);
  static const PublicTag kHuffmanTableTriplet
      //(1000,0003)
      = const PublicTag("HuffmanTableTriplet", 0x10000003, "Huffman Table Triplet",
          VR.kUS, VM.k3, true);
  static const PublicTag kShiftTableSize
      //(1000,0004)
      = const PublicTag(
          "ShiftTableSize", 0x10000004, "Shift Table Size", VR.kUS, VM.k1, true);
  static const PublicTag kShiftTableTriplet
      //(1000,0005)
      = const PublicTag(
          "ShiftTableTriplet", 0x10000005, "Shift Table Triplet", VR.kUS, VM.k3, true);
  static const PublicTag kZonalMap
      //(1010,0000)
      = const PublicTag("ZonalMap", 0x10100000, "Zonal Map", VR.kUS, VM.k1_n, true);
  static const PublicTag kNumberOfCopies
      //(2000,0010)
      = const PublicTag(
          "NumberOfCopies", 0x20000010, "Number of Copies", VR.kIS, VM.k1, false);
  static const PublicTag kPrinterConfigurationSequence
      //(2000,001E)
      = const PublicTag("PrinterConfigurationSequence", 0x2000001E,
          "Printer Configuration Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrintPriority
      //(2000,0020)
      = const PublicTag(
          "PrintPriority", 0x20000020, "Print Priority", VR.kCS, VM.k1, false);
  static const PublicTag kMediumType
      //(2000,0030)
      = const PublicTag("MediumType", 0x20000030, "Medium Type", VR.kCS, VM.k1, false);
  static const PublicTag kFilmDestination
      //(2000,0040)
      = const PublicTag(
          "FilmDestination", 0x20000040, "Film Destination", VR.kCS, VM.k1, false);
  static const PublicTag kFilmSessionLabel
      //(2000,0050)
      = const PublicTag(
          "FilmSessionLabel", 0x20000050, "Film Session Label", VR.kLO, VM.k1, false);
  static const PublicTag kMemoryAllocation
      //(2000,0060)
      = const PublicTag(
          "MemoryAllocation", 0x20000060, "Memory Allocation", VR.kIS, VM.k1, false);
  static const PublicTag kMaximumMemoryAllocation
      //(2000,0061)
      = const PublicTag("MaximumMemoryAllocation", 0x20000061,
          "Maximum Memory Allocation", VR.kIS, VM.k1, false);
  static const PublicTag kColorImagePrintingFlag
      //(2000,0062)
      = const PublicTag("ColorImagePrintingFlag", 0x20000062, "Color Image Printing Flag",
          VR.kCS, VM.k1, true);
  static const PublicTag kCollationFlag
      //(2000,0063)
      =
      const PublicTag("CollationFlag", 0x20000063, "Collation Flag", VR.kCS, VM.k1, true);
  static const PublicTag kAnnotationFlag
      //(2000,0065)
      = const PublicTag(
          "AnnotationFlag", 0x20000065, "Annotation Flag", VR.kCS, VM.k1, true);
  static const PublicTag kImageOverlayFlag
      //(2000,0067)
      = const PublicTag(
          "ImageOverlayFlag", 0x20000067, "Image Overlay Flag", VR.kCS, VM.k1, true);
  static const PublicTag kPresentationLUTFlag
      //(2000,0069)
      = const PublicTag("PresentationLUTFlag", 0x20000069, "Presentation LUT Flag",
          VR.kCS, VM.k1, true);
  static const PublicTag kImageBoxPresentationLUTFlag
      //(2000,006A)
      = const PublicTag("ImageBoxPresentationLUTFlag", 0x2000006A,
          "Image Box Presentation LUT Flag", VR.kCS, VM.k1, true);
  static const PublicTag kMemoryBitDepth
      //(2000,00A0)
      = const PublicTag(
          "MemoryBitDepth", 0x200000A0, "Memory Bit Depth", VR.kUS, VM.k1, false);
  static const PublicTag kPrintingBitDepth
      //(2000,00A1)
      = const PublicTag(
          "PrintingBitDepth", 0x200000A1, "Printing Bit Depth", VR.kUS, VM.k1, false);
  static const PublicTag kMediaInstalledSequence
      //(2000,00A2)
      = const PublicTag("MediaInstalledSequence", 0x200000A2, "Media Installed Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kOtherMediaAvailableSequence
      //(2000,00A4)
      = const PublicTag("OtherMediaAvailableSequence", 0x200000A4,
          "Other Media Available Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSupportedImageDisplayFormatsSequence
      //(2000,00A8)
      = const PublicTag("SupportedImageDisplayFormatsSequence", 0x200000A8,
          "Supported Image Display Formats Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedFilmBoxSequence
      //(2000,0500)
      = const PublicTag("ReferencedFilmBoxSequence", 0x20000500,
          "Referenced Film Box Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedStoredPrintSequence
      //(2000,0510)
      = const PublicTag("ReferencedStoredPrintSequence", 0x20000510,
          "Referenced Stored Print Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kImageDisplayFormat
      //(2010,0010)
      = const PublicTag(
          "ImageDisplayFormat", 0x20100010, "Image Display Format", VR.kST, VM.k1, false);
  static const PublicTag kAnnotationDisplayFormatID
      //(2010,0030)
      = const PublicTag("AnnotationDisplayFormatID", 0x20100030,
          "Annotation Display Format ID", VR.kCS, VM.k1, false);
  static const PublicTag kFilmOrientation
      //(2010,0040)
      = const PublicTag(
          "FilmOrientation", 0x20100040, "Film Orientation", VR.kCS, VM.k1, false);
  static const PublicTag kFilmSizeID
      //(2010,0050)
      = const PublicTag("FilmSizeID", 0x20100050, "Film Size ID", VR.kCS, VM.k1, false);
  static const PublicTag kPrinterResolutionID
      //(2010,0052)
      = const PublicTag("PrinterResolutionID", 0x20100052, "Printer Resolution ID",
          VR.kCS, VM.k1, false);
  static const PublicTag kDefaultPrinterResolutionID
      //(2010,0054)
      = const PublicTag("DefaultPrinterResolutionID", 0x20100054,
          "Default Printer Resolution ID", VR.kCS, VM.k1, false);
  static const PublicTag kMagnificationType
      //(2010,0060)
      = const PublicTag(
          "MagnificationType", 0x20100060, "Magnification Type", VR.kCS, VM.k1, false);
  static const PublicTag kSmoothingType
      //(2010,0080)
      = const PublicTag(
          "SmoothingType", 0x20100080, "Smoothing Type", VR.kCS, VM.k1, false);
  static const PublicTag kDefaultMagnificationType
      //(2010,00A6)
      = const PublicTag("DefaultMagnificationType", 0x201000A6,
          "Default Magnification Type", VR.kCS, VM.k1, false);
  static const PublicTag kOtherMagnificationTypesAvailable
      //(2010,00A7)
      = const PublicTag("OtherMagnificationTypesAvailable", 0x201000A7,
          "Other Magnification Types Available", VR.kCS, VM.k1_n, false);
  static const PublicTag kDefaultSmoothingType
      //(2010,00A8)
      = const PublicTag("DefaultSmoothingType", 0x201000A8, "Default Smoothing Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kOtherSmoothingTypesAvailable
      //(2010,00A9)
      = const PublicTag("OtherSmoothingTypesAvailable", 0x201000A9,
          "Other Smoothing Types Available", VR.kCS, VM.k1_n, false);
  static const PublicTag kBorderDensity
      //(2010,0100)
      = const PublicTag(
          "BorderDensity", 0x20100100, "Border Density", VR.kCS, VM.k1, false);
  static const PublicTag kEmptyImageDensity
      //(2010,0110)
      = const PublicTag(
          "EmptyImageDensity", 0x20100110, "Empty Image Density", VR.kCS, VM.k1, false);
  static const PublicTag kMinDensity
      //(2010,0120)
      = const PublicTag("MinDensity", 0x20100120, "Min Density", VR.kUS, VM.k1, false);
  static const PublicTag kMaxDensity
      //(2010,0130)
      = const PublicTag("MaxDensity", 0x20100130, "Max Density", VR.kUS, VM.k1, false);
  static const PublicTag kTrim
      //(2010,0140)
      = const PublicTag("Trim", 0x20100140, "Trim", VR.kCS, VM.k1, false);
  static const PublicTag kConfigurationInformation
      //(2010,0150)
      = const PublicTag("ConfigurationInformation", 0x20100150,
          "Configuration Information", VR.kST, VM.k1, false);
  static const PublicTag kConfigurationInformationDescription
      //(2010,0152)
      = const PublicTag("ConfigurationInformationDescription", 0x20100152,
          "Configuration Information Description", VR.kLT, VM.k1, false);
  static const PublicTag kMaximumCollatedFilms
      //(2010,0154)
      = const PublicTag("MaximumCollatedFilms", 0x20100154, "Maximum Collated Films",
          VR.kIS, VM.k1, false);
  static const PublicTag kIllumination
      //(2010,015E)
      = const PublicTag("Illumination", 0x2010015E, "Illumination", VR.kUS, VM.k1, false);
  static const PublicTag kReflectedAmbientLight
      //(2010,0160)
      = const PublicTag("ReflectedAmbientLight", 0x20100160, "Reflected Ambient Light",
          VR.kUS, VM.k1, false);
  static const PublicTag kPrinterPixelSpacing
      //(2010,0376)
      = const PublicTag("PrinterPixelSpacing", 0x20100376, "Printer Pixel Spacing",
          VR.kDS, VM.k2, false);
  static const PublicTag kReferencedFilmSessionSequence
      //(2010,0500)
      = const PublicTag("ReferencedFilmSessionSequence", 0x20100500,
          "Referenced Film Session Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedImageBoxSequence
      //(2010,0510)
      = const PublicTag("ReferencedImageBoxSequence", 0x20100510,
          "Referenced Image Box Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedBasicAnnotationBoxSequence
      //(2010,0520)
      = const PublicTag("ReferencedBasicAnnotationBoxSequence", 0x20100520,
          "Referenced Basic Annotation Box Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImageBoxPosition
      //(2020,0010)
      = const PublicTag(
          "ImageBoxPosition", 0x20200010, "Image Box Position", VR.kUS, VM.k1, false);
  static const PublicTag kPolarity
      //(2020,0020)
      = const PublicTag("Polarity", 0x20200020, "Polarity", VR.kCS, VM.k1, false);
  static const PublicTag kRequestedImageSize
      //(2020,0030)
      = const PublicTag(
          "RequestedImageSize", 0x20200030, "Requested Image Size", VR.kDS, VM.k1, false);
  static const PublicTag kRequestedDecimateCropBehavior
      //(2020,0040)
      = const PublicTag("RequestedDecimateCropBehavior", 0x20200040,
          "Requested Decimate/Crop Behavior", VR.kCS, VM.k1, false);
  static const PublicTag kRequestedResolutionID
      //(2020,0050)
      = const PublicTag("RequestedResolutionID", 0x20200050, "Requested Resolution ID",
          VR.kCS, VM.k1, false);
  static const PublicTag kRequestedImageSizeFlag
      //(2020,00A0)
      = const PublicTag("RequestedImageSizeFlag", 0x202000A0, "Requested Image Size Flag",
          VR.kCS, VM.k1, false);
  static const PublicTag kDecimateCropResult
      //(2020,00A2)
      = const PublicTag(
          "DecimateCropResult", 0x202000A2, "Decimate/Crop Result", VR.kCS, VM.k1, false);
  static const PublicTag kBasicGrayscaleImageSequence
      //(2020,0110)
      = const PublicTag("BasicGrayscaleImageSequence", 0x20200110,
          "Basic Grayscale Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBasicColorImageSequence
      //(2020,0111)
      = const PublicTag("BasicColorImageSequence", 0x20200111,
          "Basic Color Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedImageOverlayBoxSequence
      //(2020,0130)
      = const PublicTag("ReferencedImageOverlayBoxSequence", 0x20200130,
          "Referenced Image Overlay Box Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedVOILUTBoxSequence
      //(2020,0140)
      = const PublicTag("ReferencedVOILUTBoxSequence", 0x20200140,
          "Referenced VOI LUT Box Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kAnnotationPosition
      //(2030,0010)
      = const PublicTag(
          "AnnotationPosition", 0x20300010, "Annotation Position", VR.kUS, VM.k1, false);
  static const PublicTag kTextString
      //(2030,0020)
      = const PublicTag("TextString", 0x20300020, "Text String", VR.kLO, VM.k1, false);
  static const PublicTag kReferencedOverlayPlaneSequence
      //(2040,0010)
      = const PublicTag("ReferencedOverlayPlaneSequence", 0x20400010,
          "Referenced Overlay Plane Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedOverlayPlaneGroups
      //(2040,0011)
      = const PublicTag("ReferencedOverlayPlaneGroups", 0x20400011,
          "Referenced Overlay Plane Groups", VR.kUS, VM.k1_99, true);
  static const PublicTag kOverlayPixelDataSequence
      //(2040,0020)
      = const PublicTag("OverlayPixelDataSequence", 0x20400020,
          "Overlay Pixel Data Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kOverlayMagnificationType
      //(2040,0060)
      = const PublicTag("OverlayMagnificationType", 0x20400060,
          "Overlay Magnification Type", VR.kCS, VM.k1, true);
  static const PublicTag kOverlaySmoothingType
      //(2040,0070)
      = const PublicTag("OverlaySmoothingType", 0x20400070, "Overlay Smoothing Type",
          VR.kCS, VM.k1, true);
  static const PublicTag kOverlayOrImageMagnification
      //(2040,0072)
      = const PublicTag("OverlayOrImageMagnification", 0x20400072,
          "Overlay or Image Magnification", VR.kCS, VM.k1, true);
  static const PublicTag kMagnifyToNumberOfColumns
      //(2040,0074)
      = const PublicTag("MagnifyToNumberOfColumns", 0x20400074,
          "Magnify to Number of Columns", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayForegroundDensity
      //(2040,0080)
      = const PublicTag("OverlayForegroundDensity", 0x20400080,
          "Overlay Foreground Density", VR.kCS, VM.k1, true);
  static const PublicTag kOverlayBackgroundDensity
      //(2040,0082)
      = const PublicTag("OverlayBackgroundDensity", 0x20400082,
          "Overlay Background Density", VR.kCS, VM.k1, true);
  static const PublicTag kOverlayMode
      //(2040,0090)
      = const PublicTag("OverlayMode", 0x20400090, "Overlay Mode", VR.kCS, VM.k1, true);
  static const PublicTag kThresholdDensity
      //(2040,0100)
      = const PublicTag(
          "ThresholdDensity", 0x20400100, "Threshold Density", VR.kCS, VM.k1, true);
  static const PublicTag kReferencedImageBoxSequenceRetired
      //(2040,0500)
      = const PublicTag("ReferencedImageBoxSequenceRetired", 0x20400500,
          "Referenced Image Box Sequence (Retired)", VR.kSQ, VM.k1, true);
  static const PublicTag kPresentationLUTSequence
      //(2050,0010)
      = const PublicTag("PresentationLUTSequence", 0x20500010,
          "Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPresentationLUTShape
      //(2050,0020)
      = const PublicTag("PresentationLUTShape", 0x20500020, "Presentation LUT Shape",
          VR.kCS, VM.k1, false);
  static const PublicTag kReferencedPresentationLUTSequence
      //(2050,0500)
      = const PublicTag("ReferencedPresentationLUTSequence", 0x20500500,
          "Referenced Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPrintJobID
      //(2100,0010)
      = const PublicTag("PrintJobID", 0x21000010, "Print Job ID", VR.kSH, VM.k1, true);
  static const PublicTag kExecutionStatus
      //(2100,0020)
      = const PublicTag(
          "ExecutionStatus", 0x21000020, "Execution Status", VR.kCS, VM.k1, false);
  static const PublicTag kExecutionStatusInfo
      //(2100,0030)
      = const PublicTag("ExecutionStatusInfo", 0x21000030, "Execution Status Info",
          VR.kCS, VM.k1, false);
  static const PublicTag kCreationDate
      //(2100,0040)
      =
      const PublicTag("CreationDate", 0x21000040, "Creation Date", VR.kDA, VM.k1, false);
  static const PublicTag kCreationTime
      //(2100,0050)
      =
      const PublicTag("CreationTime", 0x21000050, "Creation Time", VR.kTM, VM.k1, false);
  static const PublicTag kOriginator
      //(2100,0070)
      = const PublicTag("Originator", 0x21000070, "Originator", VR.kAE, VM.k1, false);
  static const PublicTag kDestinationAE
      //(2100,0140)
      =
      const PublicTag("DestinationAE", 0x21000140, "Destination AE", VR.kAE, VM.k1, true);
  static const PublicTag kOwnerID
      //(2100,0160)
      = const PublicTag("OwnerID", 0x21000160, "Owner ID", VR.kSH, VM.k1, false);
  static const PublicTag kNumberOfFilms
      //(2100,0170)
      = const PublicTag(
          "NumberOfFilms", 0x21000170, "Number of Films", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedPrintJobSequencePullStoredPrint
      //(2100,0500)
      = const PublicTag("ReferencedPrintJobSequencePullStoredPrint", 0x21000500,
          "Referenced Print Job Sequence (Pull Stored Print)", VR.kSQ, VM.k1, true);
  static const PublicTag kPrinterStatus
      //(2110,0010)
      = const PublicTag(
          "PrinterStatus", 0x21100010, "Printer Status", VR.kCS, VM.k1, false);
  static const PublicTag kPrinterStatusInfo
      //(2110,0020)
      = const PublicTag(
          "PrinterStatusInfo", 0x21100020, "Printer Status Info", VR.kCS, VM.k1, false);
  static const PublicTag kPrinterName
      //(2110,0030)
      = const PublicTag("PrinterName", 0x21100030, "Printer Name", VR.kLO, VM.k1, false);
  static const PublicTag kPrintQueueID
      //(2110,0099)
      =
      const PublicTag("PrintQueueID", 0x21100099, "Print Queue ID", VR.kSH, VM.k1, true);
  static const PublicTag kQueueStatus
      //(2120,0010)
      = const PublicTag("QueueStatus", 0x21200010, "Queue Status", VR.kCS, VM.k1, true);
  static const PublicTag kPrintJobDescriptionSequence
      //(2120,0050)
      = const PublicTag("PrintJobDescriptionSequence", 0x21200050,
          "Print Job Description Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReferencedPrintJobSequence
      //(2120,0070)
      = const PublicTag("ReferencedPrintJobSequence", 0x21200070,
          "Referenced Print Job Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kPrintManagementCapabilitiesSequence
      //(2130,0010)
      = const PublicTag("PrintManagementCapabilitiesSequence", 0x21300010,
          "Print Management Capabilities Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kPrinterCharacteristicsSequence
      //(2130,0015)
      = const PublicTag("PrinterCharacteristicsSequence", 0x21300015,
          "Printer Characteristics Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kFilmBoxContentSequence
      //(2130,0030)
      = const PublicTag("FilmBoxContentSequence", 0x21300030, "Film Box Content Sequence",
          VR.kSQ, VM.k1, true);
  static const PublicTag kImageBoxContentSequence
      //(2130,0040)
      = const PublicTag("ImageBoxContentSequence", 0x21300040,
          "Image Box Content Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kAnnotationContentSequence
      //(2130,0050)
      = const PublicTag("AnnotationContentSequence", 0x21300050,
          "Annotation Content Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kImageOverlayBoxContentSequence
      //(2130,0060)
      = const PublicTag("ImageOverlayBoxContentSequence", 0x21300060,
          "Image Overlay Box Content Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kPresentationLUTContentSequence
      //(2130,0080)
      = const PublicTag("PresentationLUTContentSequence", 0x21300080,
          "Presentation LUT Content Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kProposedStudySequence
      //(2130,00A0)
      = const PublicTag("ProposedStudySequence", 0x213000A0, "Proposed Study Sequence",
          VR.kSQ, VM.k1, true);
  static const PublicTag kOriginalImageSequence
      //(2130,00C0)
      = const PublicTag("OriginalImageSequence", 0x213000C0, "Original Image Sequence",
          VR.kSQ, VM.k1, true);
  static const PublicTag kLabelUsingInformationExtractedFromInstances
      //(2200,0001)
      = const PublicTag("LabelUsingInformationExtractedFromInstances", 0x22000001,
          "Label Using Information Extracted From Instances", VR.kCS, VM.k1, false);
  static const PublicTag kLabelText
      //(2200,0002)
      = const PublicTag("LabelText", 0x22000002, "Label Text", VR.kUT, VM.k1, false);
  static const PublicTag kLabelStyleSelection
      //(2200,0003)
      = const PublicTag("LabelStyleSelection", 0x22000003, "Label Style Selection",
          VR.kCS, VM.k1, false);
  static const PublicTag kMediaDisposition
      //(2200,0004)
      = const PublicTag(
          "MediaDisposition", 0x22000004, "Media Disposition", VR.kLT, VM.k1, false);
  static const PublicTag kBarcodeValue
      //(2200,0005)
      =
      const PublicTag("BarcodeValue", 0x22000005, "Barcode Value", VR.kLT, VM.k1, false);
  static const PublicTag kBarcodeSymbology
      //(2200,0006)
      = const PublicTag(
          "BarcodeSymbology", 0x22000006, "Barcode Symbology", VR.kCS, VM.k1, false);
  static const PublicTag kAllowMediaSplitting
      //(2200,0007)
      = const PublicTag("AllowMediaSplitting", 0x22000007, "Allow Media Splitting",
          VR.kCS, VM.k1, false);
  static const PublicTag kIncludeNonDICOMObjects
      //(2200,0008)
      = const PublicTag("IncludeNonDICOMObjects", 0x22000008, "Include Non-DICOM Objects",
          VR.kCS, VM.k1, false);
  static const PublicTag kIncludeDisplayApplication
      //(2200,0009)
      = const PublicTag("IncludeDisplayApplication", 0x22000009,
          "Include Display Application", VR.kCS, VM.k1, false);
  static const PublicTag kPreserveCompositeInstancesAfterMediaCreation
      //(2200,000A)
      = const PublicTag("PreserveCompositeInstancesAfterMediaCreation", 0x2200000A,
          "Preserve Composite Instances After Media Creation", VR.kCS, VM.k1, false);
  static const PublicTag kTotalNumberOfPiecesOfMediaCreated
      //(2200,000B)
      = const PublicTag("TotalNumberOfPiecesOfMediaCreated", 0x2200000B,
          "Total Number of Pieces of Media Created", VR.kUS, VM.k1, false);
  static const PublicTag kRequestedMediaApplicationProfile
      //(2200,000C)
      = const PublicTag("RequestedMediaApplicationProfile", 0x2200000C,
          "Requested Media Application Profile", VR.kLO, VM.k1, false);
  static const PublicTag kReferencedStorageMediaSequence
      //(2200,000D)
      = const PublicTag("ReferencedStorageMediaSequence", 0x2200000D,
          "Referenced Storage Media Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFailureAttributes
      //(2200,000E)
      = const PublicTag(
          "FailureAttributes", 0x2200000E, "Failure Attributes", VR.kAT, VM.k1_n, false);
  static const PublicTag kAllowLossyCompression
      //(2200,000F)
      = const PublicTag("AllowLossyCompression", 0x2200000F, "Allow Lossy Compression",
          VR.kCS, VM.k1, false);
  static const PublicTag kRequestPriority
      //(2200,0020)
      = const PublicTag(
          "RequestPriority", 0x22000020, "Request Priority", VR.kCS, VM.k1, false);
  static const PublicTag kRTImageLabel
      //(3002,0002)
      =
      const PublicTag("RTImageLabel", 0x30020002, "RT Image Label", VR.kSH, VM.k1, false);
  static const PublicTag kRTImageName
      //(3002,0003)
      = const PublicTag("RTImageName", 0x30020003, "RT Image Name", VR.kLO, VM.k1, false);
  static const PublicTag kRTImageDescription
      //(3002,0004)
      = const PublicTag(
          "RTImageDescription", 0x30020004, "RT Image Description", VR.kST, VM.k1, false);
  static const PublicTag kReportedValuesOrigin
      //(3002,000A)
      = const PublicTag("ReportedValuesOrigin", 0x3002000A, "Reported Values Origin",
          VR.kCS, VM.k1, false);
  static const PublicTag kRTImagePlane
      //(3002,000C)
      =
      const PublicTag("RTImagePlane", 0x3002000C, "RT Image Plane", VR.kCS, VM.k1, false);
  static const PublicTag kXRayImageReceptorTranslation
      //(3002,000D)
      = const PublicTag("XRayImageReceptorTranslation", 0x3002000D,
          "X-Ray Image Receptor Translation", VR.kDS, VM.k3, false);
  static const PublicTag kXRayImageReceptorAngle
      //(3002,000E)
      = const PublicTag("XRayImageReceptorAngle", 0x3002000E,
          "X-Ray Image Receptor Angle", VR.kDS, VM.k1, false);
  static const PublicTag kRTImageOrientation
      //(3002,0010)
      = const PublicTag(
          "RTImageOrientation", 0x30020010, "RT Image Orientation", VR.kDS, VM.k6, false);
  static const PublicTag kImagePlanePixelSpacing
      //(3002,0011)
      = const PublicTag("ImagePlanePixelSpacing", 0x30020011, "Image Plane Pixel Spacing",
          VR.kDS, VM.k2, false);
  static const PublicTag kRTImagePosition
      //(3002,0012)
      = const PublicTag(
          "RTImagePosition", 0x30020012, "RT Image Position", VR.kDS, VM.k2, false);
  static const PublicTag kRadiationMachineName
      //(3002,0020)
      = const PublicTag("RadiationMachineName", 0x30020020, "Radiation Machine Name",
          VR.kSH, VM.k1, false);
  static const PublicTag kRadiationMachineSAD
      //(3002,0022)
      = const PublicTag("RadiationMachineSAD", 0x30020022, "Radiation Machine SAD",
          VR.kDS, VM.k1, false);
  static const PublicTag kRadiationMachineSSD
      //(3002,0024)
      = const PublicTag("RadiationMachineSSD", 0x30020024, "Radiation Machine SSD",
          VR.kDS, VM.k1, false);
  static const PublicTag kRTImageSID
      //(3002,0026)
      = const PublicTag("RTImageSID", 0x30020026, "RT Image SID", VR.kDS, VM.k1, false);
  static const PublicTag kSourceToReferenceObjectDistance
      //(3002,0028)
      = const PublicTag("SourceToReferenceObjectDistance", 0x30020028,
          "Source to Reference Object Distance", VR.kDS, VM.k1, false);
  static const PublicTag kFractionNumber
      //(3002,0029)
      = const PublicTag(
          "FractionNumber", 0x30020029, "Fraction Number", VR.kIS, VM.k1, false);
  static const PublicTag kExposureSequence
      //(3002,0030)
      = const PublicTag(
          "ExposureSequence", 0x30020030, "Exposure Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMetersetExposure
      //(3002,0032)
      = const PublicTag(
          "MetersetExposure", 0x30020032, "Meterset Exposure", VR.kDS, VM.k1, false);
  static const PublicTag kDiaphragmPosition
      //(3002,0034)
      = const PublicTag(
          "DiaphragmPosition", 0x30020034, "Diaphragm Position", VR.kDS, VM.k4, false);
  static const PublicTag kFluenceMapSequence
      //(3002,0040)
      = const PublicTag(
          "FluenceMapSequence", 0x30020040, "Fluence Map Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFluenceDataSource
      //(3002,0041)
      = const PublicTag(
          "FluenceDataSource", 0x30020041, "Fluence Data Source", VR.kCS, VM.k1, false);
  static const PublicTag kFluenceDataScale
      //(3002,0042)
      = const PublicTag(
          "FluenceDataScale", 0x30020042, "Fluence Data Scale", VR.kDS, VM.k1, false);
  static const PublicTag kPrimaryFluenceModeSequence
      //(3002,0050)
      = const PublicTag("PrimaryFluenceModeSequence", 0x30020050,
          "Primary Fluence Mode Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kFluenceMode
      //(3002,0051)
      = const PublicTag("FluenceMode", 0x30020051, "Fluence Mode", VR.kCS, VM.k1, false);
  static const PublicTag kFluenceModeID
      //(3002,0052)
      = const PublicTag(
          "FluenceModeID", 0x30020052, "Fluence Mode ID", VR.kSH, VM.k1, false);
  static const PublicTag kDVHType
      //(3004,0001)
      = const PublicTag("DVHType", 0x30040001, "DVH Type", VR.kCS, VM.k1, false);
  static const PublicTag kDoseUnits
      //(3004,0002)
      = const PublicTag("DoseUnits", 0x30040002, "Dose Units", VR.kCS, VM.k1, false);
  static const PublicTag kDoseType
      //(3004,0004)
      = const PublicTag("DoseType", 0x30040004, "Dose Type", VR.kCS, VM.k1, false);
  static const PublicTag kSpatialTransformOfDose
      //(3004,0005)
      = const PublicTag("SpatialTransformOfDose", 0x30040005, "Spatial Transform of Dose",
          VR.kCS, VM.k1, false);
  static const PublicTag kDoseComment
      //(3004,0006)
      = const PublicTag("DoseComment", 0x30040006, "Dose Comment", VR.kLO, VM.k1, false);
  static const PublicTag kNormalizationPoint
      //(3004,0008)
      = const PublicTag(
          "NormalizationPoint", 0x30040008, "Normalization Point", VR.kDS, VM.k3, false);
  static const PublicTag kDoseSummationType
      //(3004,000A)
      = const PublicTag(
          "DoseSummationType", 0x3004000A, "Dose Summation Type", VR.kCS, VM.k1, false);
  static const PublicTag kGridFrameOffsetVector
      //(3004,000C)
      = const PublicTag("GridFrameOffsetVector", 0x3004000C, "Grid Frame Offset Vector",
          VR.kDS, VM.k2_n, false);
  static const PublicTag kDoseGridScaling
      //(3004,000E)
      = const PublicTag(
          "DoseGridScaling", 0x3004000E, "Dose Grid Scaling", VR.kDS, VM.k1, false);
  static const PublicTag kRTDoseROISequence
      //(3004,0010)
      = const PublicTag(
          "RTDoseROISequence", 0x30040010, "RT Dose ROI Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDoseValue
      //(3004,0012)
      = const PublicTag("DoseValue", 0x30040012, "Dose Value", VR.kDS, VM.k1, false);
  static const PublicTag kTissueHeterogeneityCorrection
      //(3004,0014)
      = const PublicTag("TissueHeterogeneityCorrection", 0x30040014,
          "Tissue Heterogeneity Correction", VR.kCS, VM.k1_3, false);
  static const PublicTag kDVHNormalizationPoint
      //(3004,0040)
      = const PublicTag("DVHNormalizationPoint", 0x30040040, "DVH Normalization Point",
          VR.kDS, VM.k3, false);
  static const PublicTag kDVHNormalizationDoseValue
      //(3004,0042)
      = const PublicTag("DVHNormalizationDoseValue", 0x30040042,
          "DVH Normalization Dose Value", VR.kDS, VM.k1, false);
  static const PublicTag kDVHSequence
      //(3004,0050)
      = const PublicTag("DVHSequence", 0x30040050, "DVH Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDVHDoseScaling
      //(3004,0052)
      = const PublicTag(
          "DVHDoseScaling", 0x30040052, "DVH Dose Scaling", VR.kDS, VM.k1, false);
  static const PublicTag kDVHVolumeUnits
      //(3004,0054)
      = const PublicTag(
          "DVHVolumeUnits", 0x30040054, "DVH Volume Units", VR.kCS, VM.k1, false);
  static const PublicTag kDVHNumberOfBins
      //(3004,0056)
      = const PublicTag(
          "DVHNumberOfBins", 0x30040056, "DVH Number of Bins", VR.kIS, VM.k1, false);
  static const PublicTag kDVHData
      //(3004,0058)
      = const PublicTag("DVHData", 0x30040058, "DVH Data", VR.kDS, VM.k2_2n, false);
  static const PublicTag kDVHReferencedROISequence
      //(3004,0060)
      = const PublicTag("DVHReferencedROISequence", 0x30040060,
          "DVH Referenced ROI Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDVHROIContributionType
      //(3004,0062)
      = const PublicTag("DVHROIContributionType", 0x30040062, "DVH ROI Contribution Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kDVHMinimumDose
      //(3004,0070)
      = const PublicTag(
          "DVHMinimumDose", 0x30040070, "DVH Minimum Dose", VR.kDS, VM.k1, false);
  static const PublicTag kDVHMaximumDose
      //(3004,0072)
      = const PublicTag(
          "DVHMaximumDose", 0x30040072, "DVH Maximum Dose", VR.kDS, VM.k1, false);
  static const PublicTag kDVHMeanDose
      //(3004,0074)
      = const PublicTag("DVHMeanDose", 0x30040074, "DVH Mean Dose", VR.kDS, VM.k1, false);
  static const PublicTag kStructureSetLabel
      //(3006,0002)
      = const PublicTag(
          "StructureSetLabel", 0x30060002, "Structure Set Label", VR.kSH, VM.k1, false);
  static const PublicTag kStructureSetName
      //(3006,0004)
      = const PublicTag(
          "StructureSetName", 0x30060004, "Structure Set Name", VR.kLO, VM.k1, false);
  static const PublicTag kStructureSetDescription
      //(3006,0006)
      = const PublicTag("StructureSetDescription", 0x30060006,
          "Structure Set Description", VR.kST, VM.k1, false);
  static const PublicTag kStructureSetDate
      //(3006,0008)
      = const PublicTag(
          "StructureSetDate", 0x30060008, "Structure Set Date", VR.kDA, VM.k1, false);
  static const PublicTag kStructureSetTime
      //(3006,0009)
      = const PublicTag(
          "StructureSetTime", 0x30060009, "Structure Set Time", VR.kTM, VM.k1, false);
  static const PublicTag kReferencedFrameOfReferenceSequence
      //(3006,0010)
      = const PublicTag("ReferencedFrameOfReferenceSequence", 0x30060010,
          "Referenced Frame of Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRTReferencedStudySequence
      //(3006,0012)
      = const PublicTag("RTReferencedStudySequence", 0x30060012,
          "RT Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRTReferencedSeriesSequence
      //(3006,0014)
      = const PublicTag("RTReferencedSeriesSequence", 0x30060014,
          "RT Referenced Series Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContourImageSequence
      //(3006,0016)
      = const PublicTag("ContourImageSequence", 0x30060016, "Contour Image Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPredecessorStructureSetSequence
      //(3006,0018)
      = const PublicTag("PredecessorStructureSetSequence", 0x30060018,
          "Predecessor Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kStructureSetROISequence
      //(3006,0020)
      = const PublicTag("StructureSetROISequence", 0x30060020,
          "Structure Set ROI Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kROINumber
      //(3006,0022)
      = const PublicTag("ROINumber", 0x30060022, "ROI Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedFrameOfReferenceUID
      //(3006,0024)
      = const PublicTag("ReferencedFrameOfReferenceUID", 0x30060024,
          "Referenced Frame of Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kROIName
      //(3006,0026)
      = const PublicTag("ROIName", 0x30060026, "ROI Name", VR.kLO, VM.k1, false);
  static const PublicTag kROIDescription
      //(3006,0028)
      = const PublicTag(
          "ROIDescription", 0x30060028, "ROI Description", VR.kST, VM.k1, false);
  static const PublicTag kROIDisplayColor
      //(3006,002A)
      = const PublicTag(
          "ROIDisplayColor", 0x3006002A, "ROI Display Color", VR.kIS, VM.k3, false);
  static const PublicTag kROIVolume
      //(3006,002C)
      = const PublicTag("ROIVolume", 0x3006002C, "ROI Volume", VR.kDS, VM.k1, false);
  static const PublicTag kRTRelatedROISequence
      //(3006,0030)
      = const PublicTag("RTRelatedROISequence", 0x30060030, "RT Related ROI Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRTROIRelationship
      //(3006,0033)
      = const PublicTag(
          "RTROIRelationship", 0x30060033, "RT ROI Relationship", VR.kCS, VM.k1, false);
  static const PublicTag kROIGenerationAlgorithm
      //(3006,0036)
      = const PublicTag("ROIGenerationAlgorithm", 0x30060036, "ROI Generation Algorithm",
          VR.kCS, VM.k1, false);
  static const PublicTag kROIGenerationDescription
      //(3006,0038)
      = const PublicTag("ROIGenerationDescription", 0x30060038,
          "ROI Generation Description", VR.kLO, VM.k1, false);
  static const PublicTag kROIContourSequence
      //(3006,0039)
      = const PublicTag(
          "ROIContourSequence", 0x30060039, "ROI Contour Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContourSequence
      //(3006,0040)
      = const PublicTag(
          "ContourSequence", 0x30060040, "Contour Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kContourGeometricType
      //(3006,0042)
      = const PublicTag("ContourGeometricType", 0x30060042, "Contour Geometric Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kContourSlabThickness
      //(3006,0044)
      = const PublicTag("ContourSlabThickness", 0x30060044, "Contour Slab Thickness",
          VR.kDS, VM.k1, false);
  static const PublicTag kContourOffsetVector
      //(3006,0045)
      = const PublicTag("ContourOffsetVector", 0x30060045, "Contour Offset Vector",
          VR.kDS, VM.k3, false);
  static const PublicTag kNumberOfContourPoints
      //(3006,0046)
      = const PublicTag("NumberOfContourPoints", 0x30060046, "Number of Contour Points",
          VR.kIS, VM.k1, false);
  static const PublicTag kContourNumber
      //(3006,0048)
      = const PublicTag(
          "ContourNumber", 0x30060048, "Contour Number", VR.kIS, VM.k1, false);
  static const PublicTag kAttachedContours
      //(3006,0049)
      = const PublicTag(
          "AttachedContours", 0x30060049, "Attached Contours", VR.kIS, VM.k1_n, false);
  static const PublicTag kContourData
      //(3006,0050)
      =
      const PublicTag("ContourData", 0x30060050, "Contour Data", VR.kDS, VM.k3_3n, false);
  static const PublicTag kRTROIObservationsSequence
      //(3006,0080)
      = const PublicTag("RTROIObservationsSequence", 0x30060080,
          "RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kObservationNumber
      //(3006,0082)
      = const PublicTag(
          "ObservationNumber", 0x30060082, "Observation Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedROINumber
      //(3006,0084)
      = const PublicTag("ReferencedROINumber", 0x30060084, "Referenced ROI Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kROIObservationLabel
      //(3006,0085)
      = const PublicTag("ROIObservationLabel", 0x30060085, "ROI Observation Label",
          VR.kSH, VM.k1, false);
  static const PublicTag kRTROIIdentificationCodeSequence
      //(3006,0086)
      = const PublicTag("RTROIIdentificationCodeSequence", 0x30060086,
          "RT ROI Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kROIObservationDescription
      //(3006,0088)
      = const PublicTag("ROIObservationDescription", 0x30060088,
          "ROI Observation Description", VR.kST, VM.k1, false);
  static const PublicTag kRelatedRTROIObservationsSequence
      //(3006,00A0)
      = const PublicTag("RelatedRTROIObservationsSequence", 0x300600A0,
          "Related RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRTROIInterpretedType
      //(3006,00A4)
      = const PublicTag("RTROIInterpretedType", 0x300600A4, "RT ROI Interpreted Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kROIInterpreter
      //(3006,00A6)
      = const PublicTag(
          "ROIInterpreter", 0x300600A6, "ROI Interpreter", VR.kPN, VM.k1, false);
  static const PublicTag kROIPhysicalPropertiesSequence
      //(3006,00B0)
      = const PublicTag("ROIPhysicalPropertiesSequence", 0x300600B0,
          "ROI Physical Properties Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kROIPhysicalProperty
      //(3006,00B2)
      = const PublicTag("ROIPhysicalProperty", 0x300600B2, "ROI Physical Property",
          VR.kCS, VM.k1, false);
  static const PublicTag kROIPhysicalPropertyValue
      //(3006,00B4)
      = const PublicTag("ROIPhysicalPropertyValue", 0x300600B4,
          "ROI Physical Property Value", VR.kDS, VM.k1, false);
  static const PublicTag kROIElementalCompositionSequence
      //(3006,00B6)
      = const PublicTag("ROIElementalCompositionSequence", 0x300600B6,
          "ROI Elemental Composition Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kROIElementalCompositionAtomicNumber
      //(3006,00B7)
      = const PublicTag("ROIElementalCompositionAtomicNumber", 0x300600B7,
          "ROI Elemental Composition Atomic Number", VR.kUS, VM.k1, false);
  static const PublicTag kROIElementalCompositionAtomicMassFraction
      //(3006,00B8)
      = const PublicTag("ROIElementalCompositionAtomicMassFraction", 0x300600B8,
          "ROI Elemental Composition Atomic Mass Fraction", VR.kFL, VM.k1, false);
  static const PublicTag kFrameOfReferenceRelationshipSequence
      //(3006,00C0)
      = const PublicTag("FrameOfReferenceRelationshipSequence", 0x300600C0,
          "Frame of Reference Relationship Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kRelatedFrameOfReferenceUID
      //(3006,00C2)
      = const PublicTag("RelatedFrameOfReferenceUID", 0x300600C2,
          "Related Frame of Reference UID", VR.kUI, VM.k1, true);
  static const PublicTag kFrameOfReferenceTransformationType
      //(3006,00C4)
      = const PublicTag("FrameOfReferenceTransformationType", 0x300600C4,
          "Frame of Reference Transformation Type", VR.kCS, VM.k1, true);
  static const PublicTag kFrameOfReferenceTransformationMatrix
      //(3006,00C6)
      = const PublicTag("FrameOfReferenceTransformationMatrix", 0x300600C6,
          "Frame of Reference Transformation Matrix", VR.kDS, VM.k16, false);
  static const PublicTag kFrameOfReferenceTransformationComment
      //(3006,00C8)
      = const PublicTag("FrameOfReferenceTransformationComment", 0x300600C8,
          "Frame of Reference Transformation Comment", VR.kLO, VM.k1, false);
  static const PublicTag kMeasuredDoseReferenceSequence
      //(3008,0010)
      = const PublicTag("MeasuredDoseReferenceSequence", 0x30080010,
          "Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kMeasuredDoseDescription
      //(3008,0012)
      = const PublicTag("MeasuredDoseDescription", 0x30080012,
          "Measured Dose Description", VR.kST, VM.k1, false);
  static const PublicTag kMeasuredDoseType
      //(3008,0014)
      = const PublicTag(
          "MeasuredDoseType", 0x30080014, "Measured Dose Type", VR.kCS, VM.k1, false);
  static const PublicTag kMeasuredDoseValue
      //(3008,0016)
      = const PublicTag(
          "MeasuredDoseValue", 0x30080016, "Measured Dose Value", VR.kDS, VM.k1, false);
  static const PublicTag kTreatmentSessionBeamSequence
      //(3008,0020)
      = const PublicTag("TreatmentSessionBeamSequence", 0x30080020,
          "Treatment Session Beam Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTreatmentSessionIonBeamSequence
      //(3008,0021)
      = const PublicTag("TreatmentSessionIonBeamSequence", 0x30080021,
          "Treatment Session Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCurrentFractionNumber
      //(3008,0022)
      = const PublicTag("CurrentFractionNumber", 0x30080022, "Current Fraction Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kTreatmentControlPointDate
      //(3008,0024)
      = const PublicTag("TreatmentControlPointDate", 0x30080024,
          "Treatment Control Point Date", VR.kDA, VM.k1, false);
  static const PublicTag kTreatmentControlPointTime
      //(3008,0025)
      = const PublicTag("TreatmentControlPointTime", 0x30080025,
          "Treatment Control Point Time", VR.kTM, VM.k1, false);
  static const PublicTag kTreatmentTerminationStatus
      //(3008,002A)
      = const PublicTag("TreatmentTerminationStatus", 0x3008002A,
          "Treatment Termination Status", VR.kCS, VM.k1, false);
  static const PublicTag kTreatmentTerminationCode
      //(3008,002B)
      = const PublicTag("TreatmentTerminationCode", 0x3008002B,
          "Treatment Termination Code", VR.kSH, VM.k1, false);
  static const PublicTag kTreatmentVerificationStatus
      //(3008,002C)
      = const PublicTag("TreatmentVerificationStatus", 0x3008002C,
          "Treatment Verification Status", VR.kCS, VM.k1, false);
  static const PublicTag kReferencedTreatmentRecordSequence
      //(3008,0030)
      = const PublicTag("ReferencedTreatmentRecordSequence", 0x30080030,
          "Referenced Treatment Record Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecifiedPrimaryMeterset
      //(3008,0032)
      = const PublicTag("SpecifiedPrimaryMeterset", 0x30080032,
          "Specified Primary Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kSpecifiedSecondaryMeterset
      //(3008,0033)
      = const PublicTag("SpecifiedSecondaryMeterset", 0x30080033,
          "Specified Secondary Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredPrimaryMeterset
      //(3008,0036)
      = const PublicTag("DeliveredPrimaryMeterset", 0x30080036,
          "Delivered Primary Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredSecondaryMeterset
      //(3008,0037)
      = const PublicTag("DeliveredSecondaryMeterset", 0x30080037,
          "Delivered Secondary Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kSpecifiedTreatmentTime
      //(3008,003A)
      = const PublicTag("SpecifiedTreatmentTime", 0x3008003A, "Specified Treatment Time",
          VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredTreatmentTime
      //(3008,003B)
      = const PublicTag("DeliveredTreatmentTime", 0x3008003B, "Delivered Treatment Time",
          VR.kDS, VM.k1, false);
  static const PublicTag kControlPointDeliverySequence
      //(3008,0040)
      = const PublicTag("ControlPointDeliverySequence", 0x30080040,
          "Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonControlPointDeliverySequence
      //(3008,0041)
      = const PublicTag("IonControlPointDeliverySequence", 0x30080041,
          "Ion Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecifiedMeterset
      //(3008,0042)
      = const PublicTag(
          "SpecifiedMeterset", 0x30080042, "Specified Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredMeterset
      //(3008,0044)
      = const PublicTag(
          "DeliveredMeterset", 0x30080044, "Delivered Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kMetersetRateSet
      //(3008,0045)
      = const PublicTag(
          "MetersetRateSet", 0x30080045, "Meterset Rate Set", VR.kFL, VM.k1, false);
  static const PublicTag kMetersetRateDelivered
      //(3008,0046)
      = const PublicTag("MetersetRateDelivered", 0x30080046, "Meterset Rate Delivered",
          VR.kFL, VM.k1, false);
  static const PublicTag kScanSpotMetersetsDelivered
      //(3008,0047)
      = const PublicTag("ScanSpotMetersetsDelivered", 0x30080047,
          "Scan Spot Metersets Delivered", VR.kFL, VM.k1_n, false);
  static const PublicTag kDoseRateDelivered
      //(3008,0048)
      = const PublicTag(
          "DoseRateDelivered", 0x30080048, "Dose Rate Delivered", VR.kDS, VM.k1, false);
  static const PublicTag kTreatmentSummaryCalculatedDoseReferenceSequence
      //(3008,0050)
      = const PublicTag("TreatmentSummaryCalculatedDoseReferenceSequence", 0x30080050,
          "Treatment Summary Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCumulativeDoseToDoseReference
      //(3008,0052)
      = const PublicTag("CumulativeDoseToDoseReference", 0x30080052,
          "Cumulative Dose to Dose Reference", VR.kDS, VM.k1, false);
  static const PublicTag kFirstTreatmentDate
      //(3008,0054)
      = const PublicTag(
          "FirstTreatmentDate", 0x30080054, "First Treatment Date", VR.kDA, VM.k1, false);
  static const PublicTag kMostRecentTreatmentDate
      //(3008,0056)
      = const PublicTag("MostRecentTreatmentDate", 0x30080056,
          "Most Recent Treatment Date", VR.kDA, VM.k1, false);
  static const PublicTag kNumberOfFractionsDelivered
      //(3008,005A)
      = const PublicTag("NumberOfFractionsDelivered", 0x3008005A,
          "Number of Fractions Delivered", VR.kIS, VM.k1, false);
  static const PublicTag kOverrideSequence
      //(3008,0060)
      = const PublicTag(
          "OverrideSequence", 0x30080060, "Override Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kParameterSequencePointer
      //(3008,0061)
      = const PublicTag("ParameterSequencePointer", 0x30080061,
          "Parameter Sequence Pointer", VR.kAT, VM.k1, false);
  static const PublicTag kOverrideParameterPointer
      //(3008,0062)
      = const PublicTag("OverrideParameterPointer", 0x30080062,
          "Override Parameter Pointer", VR.kAT, VM.k1, false);
  static const PublicTag kParameterItemIndex
      //(3008,0063)
      = const PublicTag(
          "ParameterItemIndex", 0x30080063, "Parameter Item Index", VR.kIS, VM.k1, false);
  static const PublicTag kMeasuredDoseReferenceNumber
      //(3008,0064)
      = const PublicTag("MeasuredDoseReferenceNumber", 0x30080064,
          "Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const PublicTag kParameterPointer
      //(3008,0065)
      = const PublicTag(
          "ParameterPointer", 0x30080065, "Parameter Pointer", VR.kAT, VM.k1, false);
  static const PublicTag kOverrideReason
      //(3008,0066)
      = const PublicTag(
          "OverrideReason", 0x30080066, "Override Reason", VR.kST, VM.k1, false);
  static const PublicTag kCorrectedParameterSequence
      //(3008,0068)
      = const PublicTag("CorrectedParameterSequence", 0x30080068,
          "Corrected Parameter Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCorrectionValue
      //(3008,006A)
      = const PublicTag(
          "CorrectionValue", 0x3008006A, "Correction Value", VR.kFL, VM.k1, false);
  static const PublicTag kCalculatedDoseReferenceSequence
      //(3008,0070)
      = const PublicTag("CalculatedDoseReferenceSequence", 0x30080070,
          "Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCalculatedDoseReferenceNumber
      //(3008,0072)
      = const PublicTag("CalculatedDoseReferenceNumber", 0x30080072,
          "Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const PublicTag kCalculatedDoseReferenceDescription
      //(3008,0074)
      = const PublicTag("CalculatedDoseReferenceDescription", 0x30080074,
          "Calculated Dose Reference Description", VR.kST, VM.k1, false);
  static const PublicTag kCalculatedDoseReferenceDoseValue
      //(3008,0076)
      = const PublicTag("CalculatedDoseReferenceDoseValue", 0x30080076,
          "Calculated Dose Reference Dose Value", VR.kDS, VM.k1, false);
  static const PublicTag kStartMeterset
      //(3008,0078)
      = const PublicTag(
          "StartMeterset", 0x30080078, "Start Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kEndMeterset
      //(3008,007A)
      = const PublicTag("EndMeterset", 0x3008007A, "End Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kReferencedMeasuredDoseReferenceSequence
      //(3008,0080)
      = const PublicTag("ReferencedMeasuredDoseReferenceSequence", 0x30080080,
          "Referenced Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedMeasuredDoseReferenceNumber
      //(3008,0082)
      = const PublicTag("ReferencedMeasuredDoseReferenceNumber", 0x30080082,
          "Referenced Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedCalculatedDoseReferenceSequence
      //(3008,0090)
      = const PublicTag("ReferencedCalculatedDoseReferenceSequence", 0x30080090,
          "Referenced Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedCalculatedDoseReferenceNumber
      //(3008,0092)
      = const PublicTag("ReferencedCalculatedDoseReferenceNumber", 0x30080092,
          "Referenced Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceLeafPairsSequence
      //(3008,00A0)
      = const PublicTag("BeamLimitingDeviceLeafPairsSequence", 0x300800A0,
          "Beam Limiting Device Leaf Pairs Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedWedgeSequence
      //(3008,00B0)
      = const PublicTag("RecordedWedgeSequence", 0x300800B0, "Recorded Wedge Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedCompensatorSequence
      //(3008,00C0)
      = const PublicTag("RecordedCompensatorSequence", 0x300800C0,
          "Recorded Compensator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedBlockSequence
      //(3008,00D0)
      = const PublicTag("RecordedBlockSequence", 0x300800D0, "Recorded Block Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTreatmentSummaryMeasuredDoseReferenceSequence
      //(3008,00E0)
      = const PublicTag("TreatmentSummaryMeasuredDoseReferenceSequence", 0x300800E0,
          "Treatment Summary Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedSnoutSequence
      //(3008,00F0)
      = const PublicTag("RecordedSnoutSequence", 0x300800F0, "Recorded Snout Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedRangeShifterSequence
      //(3008,00F2)
      = const PublicTag("RecordedRangeShifterSequence", 0x300800F2,
          "Recorded Range Shifter Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedLateralSpreadingDeviceSequence
      //(3008,00F4)
      = const PublicTag("RecordedLateralSpreadingDeviceSequence", 0x300800F4,
          "Recorded Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedRangeModulatorSequence
      //(3008,00F6)
      = const PublicTag("RecordedRangeModulatorSequence", 0x300800F6,
          "Recorded Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRecordedSourceSequence
      //(3008,0100)
      = const PublicTag("RecordedSourceSequence", 0x30080100, "Recorded Source Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kSourceSerialNumber
      //(3008,0105)
      = const PublicTag(
          "SourceSerialNumber", 0x30080105, "Source Serial Number", VR.kLO, VM.k1, false);
  static const PublicTag kTreatmentSessionApplicationSetupSequence
      //(3008,0110)
      = const PublicTag("TreatmentSessionApplicationSetupSequence", 0x30080110,
          "Treatment Session Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kApplicationSetupCheck
      //(3008,0116)
      = const PublicTag("ApplicationSetupCheck", 0x30080116, "Application Setup Check",
          VR.kCS, VM.k1, false);
  static const PublicTag kRecordedBrachyAccessoryDeviceSequence
      //(3008,0120)
      = const PublicTag("RecordedBrachyAccessoryDeviceSequence", 0x30080120,
          "Recorded Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedBrachyAccessoryDeviceNumber
      //(3008,0122)
      = const PublicTag("ReferencedBrachyAccessoryDeviceNumber", 0x30080122,
          "Referenced Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const PublicTag kRecordedChannelSequence
      //(3008,0130)
      = const PublicTag("RecordedChannelSequence", 0x30080130,
          "Recorded Channel Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSpecifiedChannelTotalTime
      //(3008,0132)
      = const PublicTag("SpecifiedChannelTotalTime", 0x30080132,
          "Specified Channel Total Time", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredChannelTotalTime
      //(3008,0134)
      = const PublicTag("DeliveredChannelTotalTime", 0x30080134,
          "Delivered Channel Total Time", VR.kDS, VM.k1, false);
  static const PublicTag kSpecifiedNumberOfPulses
      //(3008,0136)
      = const PublicTag("SpecifiedNumberOfPulses", 0x30080136,
          "Specified Number of Pulses", VR.kIS, VM.k1, false);
  static const PublicTag kDeliveredNumberOfPulses
      //(3008,0138)
      = const PublicTag("DeliveredNumberOfPulses", 0x30080138,
          "Delivered Number of Pulses", VR.kIS, VM.k1, false);
  static const PublicTag kSpecifiedPulseRepetitionInterval
      //(3008,013A)
      = const PublicTag("SpecifiedPulseRepetitionInterval", 0x3008013A,
          "Specified Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveredPulseRepetitionInterval
      //(3008,013C)
      = const PublicTag("DeliveredPulseRepetitionInterval", 0x3008013C,
          "Delivered Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const PublicTag kRecordedSourceApplicatorSequence
      //(3008,0140)
      = const PublicTag("RecordedSourceApplicatorSequence", 0x30080140,
          "Recorded Source Applicator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSourceApplicatorNumber
      //(3008,0142)
      = const PublicTag("ReferencedSourceApplicatorNumber", 0x30080142,
          "Referenced Source Applicator Number", VR.kIS, VM.k1, false);
  static const PublicTag kRecordedChannelShieldSequence
      //(3008,0150)
      = const PublicTag("RecordedChannelShieldSequence", 0x30080150,
          "Recorded Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedChannelShieldNumber
      //(3008,0152)
      = const PublicTag("ReferencedChannelShieldNumber", 0x30080152,
          "Referenced Channel Shield Number", VR.kIS, VM.k1, false);
  static const PublicTag kBrachyControlPointDeliveredSequence
      //(3008,0160)
      = const PublicTag("BrachyControlPointDeliveredSequence", 0x30080160,
          "Brachy Control Point Delivered Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSafePositionExitDate
      //(3008,0162)
      = const PublicTag("SafePositionExitDate", 0x30080162, "Safe Position Exit Date",
          VR.kDA, VM.k1, false);
  static const PublicTag kSafePositionExitTime
      //(3008,0164)
      = const PublicTag("SafePositionExitTime", 0x30080164, "Safe Position Exit Time",
          VR.kTM, VM.k1, false);
  static const PublicTag kSafePositionReturnDate
      //(3008,0166)
      = const PublicTag("SafePositionReturnDate", 0x30080166, "Safe Position Return Date",
          VR.kDA, VM.k1, false);
  static const PublicTag kSafePositionReturnTime
      //(3008,0168)
      = const PublicTag("SafePositionReturnTime", 0x30080168, "Safe Position Return Time",
          VR.kTM, VM.k1, false);
  static const PublicTag kCurrentTreatmentStatus
      //(3008,0200)
      = const PublicTag("CurrentTreatmentStatus", 0x30080200, "Current Treatment Status",
          VR.kCS, VM.k1, false);
  static const PublicTag kTreatmentStatusComment
      //(3008,0202)
      = const PublicTag("TreatmentStatusComment", 0x30080202, "Treatment Status Comment",
          VR.kST, VM.k1, false);
  static const PublicTag kFractionGroupSummarySequence
      //(3008,0220)
      = const PublicTag("FractionGroupSummarySequence", 0x30080220,
          "Fraction Group Summary Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedFractionNumber
      //(3008,0223)
      = const PublicTag("ReferencedFractionNumber", 0x30080223,
          "Referenced Fraction Number", VR.kIS, VM.k1, false);
  static const PublicTag kFractionGroupType
      //(3008,0224)
      = const PublicTag(
          "FractionGroupType", 0x30080224, "Fraction Group Type", VR.kCS, VM.k1, false);
  static const PublicTag kBeamStopperPosition
      //(3008,0230)
      = const PublicTag("BeamStopperPosition", 0x30080230, "Beam Stopper Position",
          VR.kCS, VM.k1, false);
  static const PublicTag kFractionStatusSummarySequence
      //(3008,0240)
      = const PublicTag("FractionStatusSummarySequence", 0x30080240,
          "Fraction Status Summary Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTreatmentDate
      //(3008,0250)
      = const PublicTag(
          "TreatmentDate", 0x30080250, "Treatment Date", VR.kDA, VM.k1, false);
  static const PublicTag kTreatmentTime
      //(3008,0251)
      = const PublicTag(
          "TreatmentTime", 0x30080251, "Treatment Time", VR.kTM, VM.k1, false);
  static const PublicTag kRTPlanLabel
      //(300A,0002)
      = const PublicTag("RTPlanLabel", 0x300A0002, "RT Plan Label", VR.kSH, VM.k1, false);
  static const PublicTag kRTPlanName
      //(300A,0003)
      = const PublicTag("RTPlanName", 0x300A0003, "RT Plan Name", VR.kLO, VM.k1, false);
  static const PublicTag kRTPlanDescription
      //(300A,0004)
      = const PublicTag(
          "RTPlanDescription", 0x300A0004, "RT Plan Description", VR.kST, VM.k1, false);
  static const PublicTag kRTPlanDate
      //(300A,0006)
      = const PublicTag("RTPlanDate", 0x300A0006, "RT Plan Date", VR.kDA, VM.k1, false);
  static const PublicTag kRTPlanTime
      //(300A,0007)
      = const PublicTag("RTPlanTime", 0x300A0007, "RT Plan Time", VR.kTM, VM.k1, false);
  static const PublicTag kTreatmentProtocols
      //(300A,0009)
      = const PublicTag("TreatmentProtocols", 0x300A0009, "Treatment Protocols", VR.kLO,
          VM.k1_n, false);
  static const PublicTag kPlanIntent
      //(300A,000A)
      = const PublicTag("PlanIntent", 0x300A000A, "Plan Intent", VR.kCS, VM.k1, false);
  static const PublicTag kTreatmentSites
      //(300A,000B)
      = const PublicTag(
          "TreatmentSites", 0x300A000B, "Treatment Sites", VR.kLO, VM.k1_n, false);
  static const PublicTag kRTPlanGeometry
      //(300A,000C)
      = const PublicTag(
          "RTPlanGeometry", 0x300A000C, "RT Plan Geometry", VR.kCS, VM.k1, false);
  static const PublicTag kPrescriptionDescription
      //(300A,000E)
      = const PublicTag("PrescriptionDescription", 0x300A000E, "Prescription Description",
          VR.kST, VM.k1, false);
  static const PublicTag kDoseReferenceSequence
      //(300A,0010)
      = const PublicTag("DoseReferenceSequence", 0x300A0010, "Dose Reference Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kDoseReferenceNumber
      //(300A,0012)
      = const PublicTag("DoseReferenceNumber", 0x300A0012, "Dose Reference Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kDoseReferenceUID
      //(300A,0013)
      = const PublicTag(
          "DoseReferenceUID", 0x300A0013, "Dose Reference UID", VR.kUI, VM.k1, false);
  static const PublicTag kDoseReferenceStructureType
      //(300A,0014)
      = const PublicTag("DoseReferenceStructureType", 0x300A0014,
          "Dose Reference Structure Type", VR.kCS, VM.k1, false);
  static const PublicTag kNominalBeamEnergyUnit
      //(300A,0015)
      = const PublicTag("NominalBeamEnergyUnit", 0x300A0015, "Nominal Beam Energy Unit",
          VR.kCS, VM.k1, false);
  static const PublicTag kDoseReferenceDescription
      //(300A,0016)
      = const PublicTag("DoseReferenceDescription", 0x300A0016,
          "Dose Reference Description", VR.kLO, VM.k1, false);
  static const PublicTag kDoseReferencePointCoordinates
      //(300A,0018)
      = const PublicTag("DoseReferencePointCoordinates", 0x300A0018,
          "Dose Reference Point Coordinates", VR.kDS, VM.k3, false);
  static const PublicTag kNominalPriorDose
      //(300A,001A)
      = const PublicTag(
          "NominalPriorDose", 0x300A001A, "Nominal Prior Dose", VR.kDS, VM.k1, false);
  static const PublicTag kDoseReferenceType
      //(300A,0020)
      = const PublicTag(
          "DoseReferenceType", 0x300A0020, "Dose Reference Type", VR.kCS, VM.k1, false);
  static const PublicTag kConstraintWeight
      //(300A,0021)
      = const PublicTag(
          "ConstraintWeight", 0x300A0021, "Constraint Weight", VR.kDS, VM.k1, false);
  static const PublicTag kDeliveryWarningDose
      //(300A,0022)
      = const PublicTag("DeliveryWarningDose", 0x300A0022, "Delivery Warning Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kDeliveryMaximumDose
      //(300A,0023)
      = const PublicTag("DeliveryMaximumDose", 0x300A0023, "Delivery Maximum Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kTargetMinimumDose
      //(300A,0025)
      = const PublicTag(
          "TargetMinimumDose", 0x300A0025, "Target Minimum Dose", VR.kDS, VM.k1, false);
  static const PublicTag kTargetPrescriptionDose
      //(300A,0026)
      = const PublicTag("TargetPrescriptionDose", 0x300A0026, "Target Prescription Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kTargetMaximumDose
      //(300A,0027)
      = const PublicTag(
          "TargetMaximumDose", 0x300A0027, "Target Maximum Dose", VR.kDS, VM.k1, false);
  static const PublicTag kTargetUnderdoseVolumeFraction
      //(300A,0028)
      = const PublicTag("TargetUnderdoseVolumeFraction", 0x300A0028,
          "Target Underdose Volume Fraction", VR.kDS, VM.k1, false);
  static const PublicTag kOrganAtRiskFullVolumeDose
      //(300A,002A)
      = const PublicTag("OrganAtRiskFullVolumeDose", 0x300A002A,
          "Organ at Risk Full-volume Dose", VR.kDS, VM.k1, false);
  static const PublicTag kOrganAtRiskLimitDose
      //(300A,002B)
      = const PublicTag("OrganAtRiskLimitDose", 0x300A002B, "Organ at Risk Limit Dose",
          VR.kDS, VM.k1, false);
  static const PublicTag kOrganAtRiskMaximumDose
      //(300A,002C)
      = const PublicTag("OrganAtRiskMaximumDose", 0x300A002C,
          "Organ at Risk Maximum Dose", VR.kDS, VM.k1, false);
  static const PublicTag kOrganAtRiskOverdoseVolumeFraction
      //(300A,002D)
      = const PublicTag("OrganAtRiskOverdoseVolumeFraction", 0x300A002D,
          "Organ at Risk Overdose Volume Fraction", VR.kDS, VM.k1, false);
  static const PublicTag kToleranceTableSequence
      //(300A,0040)
      = const PublicTag("ToleranceTableSequence", 0x300A0040, "Tolerance Table Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kToleranceTableNumber
      //(300A,0042)
      = const PublicTag("ToleranceTableNumber", 0x300A0042, "Tolerance Table Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kToleranceTableLabel
      //(300A,0043)
      = const PublicTag("ToleranceTableLabel", 0x300A0043, "Tolerance Table Label",
          VR.kSH, VM.k1, false);
  static const PublicTag kGantryAngleTolerance
      //(300A,0044)
      = const PublicTag("GantryAngleTolerance", 0x300A0044, "Gantry Angle Tolerance",
          VR.kDS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceAngleTolerance
      //(300A,0046)
      = const PublicTag("BeamLimitingDeviceAngleTolerance", 0x300A0046,
          "Beam Limiting Device Angle Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceToleranceSequence
      //(300A,0048)
      = const PublicTag("BeamLimitingDeviceToleranceSequence", 0x300A0048,
          "Beam Limiting Device Tolerance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBeamLimitingDevicePositionTolerance
      //(300A,004A)
      = const PublicTag("BeamLimitingDevicePositionTolerance", 0x300A004A,
          "Beam Limiting Device Position Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kSnoutPositionTolerance
      //(300A,004B)
      = const PublicTag("SnoutPositionTolerance", 0x300A004B, "Snout Position Tolerance",
          VR.kFL, VM.k1, false);
  static const PublicTag kPatientSupportAngleTolerance
      //(300A,004C)
      = const PublicTag("PatientSupportAngleTolerance", 0x300A004C,
          "Patient Support Angle Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopEccentricAngleTolerance
      //(300A,004E)
      = const PublicTag("TableTopEccentricAngleTolerance", 0x300A004E,
          "Table Top Eccentric Angle Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopPitchAngleTolerance
      //(300A,004F)
      = const PublicTag("TableTopPitchAngleTolerance", 0x300A004F,
          "Table Top Pitch Angle Tolerance", VR.kFL, VM.k1, false);
  static const PublicTag kTableTopRollAngleTolerance
      //(300A,0050)
      = const PublicTag("TableTopRollAngleTolerance", 0x300A0050,
          "Table Top Roll Angle Tolerance", VR.kFL, VM.k1, false);
  static const PublicTag kTableTopVerticalPositionTolerance
      //(300A,0051)
      = const PublicTag("TableTopVerticalPositionTolerance", 0x300A0051,
          "Table Top Vertical Position Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLongitudinalPositionTolerance
      //(300A,0052)
      = const PublicTag("TableTopLongitudinalPositionTolerance", 0x300A0052,
          "Table Top Longitudinal Position Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLateralPositionTolerance
      //(300A,0053)
      = const PublicTag("TableTopLateralPositionTolerance", 0x300A0053,
          "Table Top Lateral Position Tolerance", VR.kDS, VM.k1, false);
  static const PublicTag kRTPlanRelationship
      //(300A,0055)
      = const PublicTag(
          "RTPlanRelationship", 0x300A0055, "RT Plan Relationship", VR.kCS, VM.k1, false);
  static const PublicTag kFractionGroupSequence
      //(300A,0070)
      = const PublicTag("FractionGroupSequence", 0x300A0070, "Fraction Group Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFractionGroupNumber
      //(300A,0071)
      = const PublicTag("FractionGroupNumber", 0x300A0071, "Fraction Group Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kFractionGroupDescription
      //(300A,0072)
      = const PublicTag("FractionGroupDescription", 0x300A0072,
          "Fraction Group Description", VR.kLO, VM.k1, false);
  static const PublicTag kNumberOfFractionsPlanned
      //(300A,0078)
      = const PublicTag("NumberOfFractionsPlanned", 0x300A0078,
          "Number of Fractions Planned", VR.kIS, VM.k1, false);
  static const PublicTag kNumberOfFractionPatternDigitsPerDay
      //(300A,0079)
      = const PublicTag("NumberOfFractionPatternDigitsPerDay", 0x300A0079,
          "Number of Fraction Pattern Digits Per Day", VR.kIS, VM.k1, false);
  static const PublicTag kRepeatFractionCycleLength
      //(300A,007A)
      = const PublicTag("RepeatFractionCycleLength", 0x300A007A,
          "Repeat Fraction Cycle Length", VR.kIS, VM.k1, false);
  static const PublicTag kFractionPattern
      //(300A,007B)
      = const PublicTag(
          "FractionPattern", 0x300A007B, "Fraction Pattern", VR.kLT, VM.k1, false);
  static const PublicTag kNumberOfBeams
      //(300A,0080)
      = const PublicTag(
          "NumberOfBeams", 0x300A0080, "Number of Beams", VR.kIS, VM.k1, false);
  static const PublicTag kBeamDoseSpecificationPoint
      //(300A,0082)
      = const PublicTag("BeamDoseSpecificationPoint", 0x300A0082,
          "Beam Dose Specification Point", VR.kDS, VM.k3, false);
  static const PublicTag kBeamDose
      //(300A,0084)
      = const PublicTag("BeamDose", 0x300A0084, "Beam Dose", VR.kDS, VM.k1, false);
  static const PublicTag kBeamMeterset
      //(300A,0086)
      =
      const PublicTag("BeamMeterset", 0x300A0086, "Beam Meterset", VR.kDS, VM.k1, false);
  static const PublicTag kBeamDosePointDepth
      //(300A,0088)
      = const PublicTag(
          "BeamDosePointDepth", 0x300A0088, "Beam Dose Point Depth", VR.kFL, VM.k1, true);
  static const PublicTag kBeamDosePointEquivalentDepth
      //(300A,0089)
      = const PublicTag("BeamDosePointEquivalentDepth", 0x300A0089,
          "Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, true);
  static const PublicTag kBeamDosePointSSD
      //(300A,008A)
      = const PublicTag(
          "BeamDosePointSSD", 0x300A008A, "Beam Dose Point SSD", VR.kFL, VM.k1, true);
  static const PublicTag kBeamDoseMeaning
      //(300A,008B)
      = const PublicTag(
          "BeamDoseMeaning", 0x300A008B, "Beam Dose Meaning", VR.kCS, VM.k1, false);
  static const PublicTag kBeamDoseVerificationControlPointSequence
      //(300A,008C)
      = const PublicTag("BeamDoseVerificationControlPointSequence", 0x300A008C,
          "Beam Dose Verification Control Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAverageBeamDosePointDepth
      //(300A,008D)
      = const PublicTag("AverageBeamDosePointDepth", 0x300A008D,
          "Average Beam Dose Point Depth", VR.kFL, VM.k1, false);
  static const PublicTag kAverageBeamDosePointEquivalentDepth
      //(300A,008E)
      = const PublicTag("AverageBeamDosePointEquivalentDepth", 0x300A008E,
          "Average Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, false);
  static const PublicTag kAverageBeamDosePointSSD
      //(300A,008F)
      = const PublicTag("AverageBeamDosePointSSD", 0x300A008F,
          "Average Beam Dose Point SSD", VR.kFL, VM.k1, false);
  static const PublicTag kNumberOfBrachyApplicationSetups
      //(300A,00A0)
      = const PublicTag("NumberOfBrachyApplicationSetups", 0x300A00A0,
          "Number of Brachy Application Setups", VR.kIS, VM.k1, false);
  static const PublicTag kBrachyApplicationSetupDoseSpecificationPoint
      //(300A,00A2)
      = const PublicTag("BrachyApplicationSetupDoseSpecificationPoint", 0x300A00A2,
          "Brachy Application Setup Dose Specification Point", VR.kDS, VM.k3, false);
  static const PublicTag kBrachyApplicationSetupDose
      //(300A,00A4)
      = const PublicTag("BrachyApplicationSetupDose", 0x300A00A4,
          "Brachy Application Setup Dose", VR.kDS, VM.k1, false);
  static const PublicTag kBeamSequence
      //(300A,00B0)
      =
      const PublicTag("BeamSequence", 0x300A00B0, "Beam Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTreatmentMachineName
      //(300A,00B2)
      = const PublicTag("TreatmentMachineName", 0x300A00B2, "Treatment Machine Name",
          VR.kSH, VM.k1, false);
  static const PublicTag kPrimaryDosimeterUnit
      //(300A,00B3)
      = const PublicTag("PrimaryDosimeterUnit", 0x300A00B3, "Primary Dosimeter Unit",
          VR.kCS, VM.k1, false);
  static const PublicTag kSourceAxisDistance
      //(300A,00B4)
      = const PublicTag(
          "SourceAxisDistance", 0x300A00B4, "Source-Axis Distance", VR.kDS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceSequence
      //(300A,00B6)
      = const PublicTag("BeamLimitingDeviceSequence", 0x300A00B6,
          "Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRTBeamLimitingDeviceType
      //(300A,00B8)
      = const PublicTag("RTBeamLimitingDeviceType", 0x300A00B8,
          "RT Beam Limiting Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kSourceToBeamLimitingDeviceDistance
      //(300A,00BA)
      = const PublicTag("SourceToBeamLimitingDeviceDistance", 0x300A00BA,
          "Source to Beam Limiting Device Distance", VR.kDS, VM.k1, false);
  static const PublicTag kIsocenterToBeamLimitingDeviceDistance
      //(300A,00BB)
      = const PublicTag("IsocenterToBeamLimitingDeviceDistance", 0x300A00BB,
          "Isocenter to Beam Limiting Device Distance", VR.kFL, VM.k1, false);
  static const PublicTag kNumberOfLeafJawPairs
      //(300A,00BC)
      = const PublicTag("NumberOfLeafJawPairs", 0x300A00BC, "Number of Leaf/Jaw Pairs",
          VR.kIS, VM.k1, false);
  static const PublicTag kLeafPositionBoundaries
      //(300A,00BE)
      = const PublicTag("LeafPositionBoundaries", 0x300A00BE, "Leaf Position Boundaries",
          VR.kDS, VM.k3_n, false);
  static const PublicTag kBeamNumber
      //(300A,00C0)
      = const PublicTag("BeamNumber", 0x300A00C0, "Beam Number", VR.kIS, VM.k1, false);
  static const PublicTag kBeamName
      //(300A,00C2)
      = const PublicTag("BeamName", 0x300A00C2, "Beam Name", VR.kLO, VM.k1, false);
  static const PublicTag kBeamDescription
      //(300A,00C3)
      = const PublicTag(
          "BeamDescription", 0x300A00C3, "Beam Description", VR.kST, VM.k1, false);
  static const PublicTag kBeamType
      //(300A,00C4)
      = const PublicTag("BeamType", 0x300A00C4, "Beam Type", VR.kCS, VM.k1, false);
  static const PublicTag kRadiationType
      //(300A,00C6)
      = const PublicTag(
          "RadiationType", 0x300A00C6, "Radiation Type", VR.kCS, VM.k1, false);
  static const PublicTag kHighDoseTechniqueType
      //(300A,00C7)
      = const PublicTag("HighDoseTechniqueType", 0x300A00C7, "High-Dose Technique Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kReferenceImageNumber
      //(300A,00C8)
      = const PublicTag("ReferenceImageNumber", 0x300A00C8, "Reference Image Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kPlannedVerificationImageSequence
      //(300A,00CA)
      = const PublicTag("PlannedVerificationImageSequence", 0x300A00CA,
          "Planned Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kImagingDeviceSpecificAcquisitionParameters
      //(300A,00CC)
      = const PublicTag("ImagingDeviceSpecificAcquisitionParameters", 0x300A00CC,
          "Imaging Device-Specific Acquisition Parameters", VR.kLO, VM.k1_n, false);
  static const PublicTag kTreatmentDeliveryType
      //(300A,00CE)
      = const PublicTag("TreatmentDeliveryType", 0x300A00CE, "Treatment Delivery Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfWedges
      //(300A,00D0)
      = const PublicTag(
          "NumberOfWedges", 0x300A00D0, "Number of Wedges", VR.kIS, VM.k1, false);
  static const PublicTag kWedgeSequence
      //(300A,00D1)
      = const PublicTag(
          "WedgeSequence", 0x300A00D1, "Wedge Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kWedgeNumber
      //(300A,00D2)
      = const PublicTag("WedgeNumber", 0x300A00D2, "Wedge Number", VR.kIS, VM.k1, false);
  static const PublicTag kWedgeType
      //(300A,00D3)
      = const PublicTag("WedgeType", 0x300A00D3, "Wedge Type", VR.kCS, VM.k1, false);
  static const PublicTag kWedgeID
      //(300A,00D4)
      = const PublicTag("WedgeID", 0x300A00D4, "Wedge ID", VR.kSH, VM.k1, false);
  static const PublicTag kWedgeAngle
      //(300A,00D5)
      = const PublicTag("WedgeAngle", 0x300A00D5, "Wedge Angle", VR.kIS, VM.k1, false);
  static const PublicTag kWedgeFactor
      //(300A,00D6)
      = const PublicTag("WedgeFactor", 0x300A00D6, "Wedge Factor", VR.kDS, VM.k1, false);
  static const PublicTag kTotalWedgeTrayWaterEquivalentThickness
      //(300A,00D7)
      = const PublicTag("TotalWedgeTrayWaterEquivalentThickness", 0x300A00D7,
          "Total Wedge Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kWedgeOrientation
      //(300A,00D8)
      = const PublicTag(
          "WedgeOrientation", 0x300A00D8, "Wedge Orientation", VR.kDS, VM.k1, false);
  static const PublicTag kIsocenterToWedgeTrayDistance
      //(300A,00D9)
      = const PublicTag("IsocenterToWedgeTrayDistance", 0x300A00D9,
          "Isocenter to Wedge Tray Distance", VR.kFL, VM.k1, false);
  static const PublicTag kSourceToWedgeTrayDistance
      //(300A,00DA)
      = const PublicTag("SourceToWedgeTrayDistance", 0x300A00DA,
          "Source to Wedge Tray Distance", VR.kDS, VM.k1, false);
  static const PublicTag kWedgeThinEdgePosition
      //(300A,00DB)
      = const PublicTag("WedgeThinEdgePosition", 0x300A00DB, "Wedge Thin Edge Position",
          VR.kFL, VM.k1, false);
  static const PublicTag kBolusID
      //(300A,00DC)
      = const PublicTag("BolusID", 0x300A00DC, "Bolus ID", VR.kSH, VM.k1, false);
  static const PublicTag kBolusDescription
      //(300A,00DD)
      = const PublicTag(
          "BolusDescription", 0x300A00DD, "Bolus Description", VR.kST, VM.k1, false);
  static const PublicTag kNumberOfCompensators
      //(300A,00E0)
      = const PublicTag("NumberOfCompensators", 0x300A00E0, "Number of Compensators",
          VR.kIS, VM.k1, false);
  static const PublicTag kMaterialID
      //(300A,00E1)
      = const PublicTag("MaterialID", 0x300A00E1, "Material ID", VR.kSH, VM.k1, false);
  static const PublicTag kTotalCompensatorTrayFactor
      //(300A,00E2)
      = const PublicTag("TotalCompensatorTrayFactor", 0x300A00E2,
          "Total Compensator Tray Factor", VR.kDS, VM.k1, false);
  static const PublicTag kCompensatorSequence
      //(300A,00E3)
      = const PublicTag("CompensatorSequence", 0x300A00E3, "Compensator Sequence", VR.kSQ,
          VM.k1, false);
  static const PublicTag kCompensatorNumber
      //(300A,00E4)
      = const PublicTag(
          "CompensatorNumber", 0x300A00E4, "Compensator Number", VR.kIS, VM.k1, false);
  static const PublicTag kCompensatorID
      //(300A,00E5)
      = const PublicTag(
          "CompensatorID", 0x300A00E5, "Compensator ID", VR.kSH, VM.k1, false);
  static const PublicTag kSourceToCompensatorTrayDistance
      //(300A,00E6)
      = const PublicTag("SourceToCompensatorTrayDistance", 0x300A00E6,
          "Source to Compensator Tray Distance", VR.kDS, VM.k1, false);
  static const PublicTag kCompensatorRows
      //(300A,00E7)
      = const PublicTag(
          "CompensatorRows", 0x300A00E7, "Compensator Rows", VR.kIS, VM.k1, false);
  static const PublicTag kCompensatorColumns
      //(300A,00E8)
      = const PublicTag(
          "CompensatorColumns", 0x300A00E8, "Compensator Columns", VR.kIS, VM.k1, false);
  static const PublicTag kCompensatorPixelSpacing
      //(300A,00E9)
      = const PublicTag("CompensatorPixelSpacing", 0x300A00E9,
          "Compensator Pixel Spacing", VR.kDS, VM.k2, false);
  static const PublicTag kCompensatorPosition
      //(300A,00EA)
      = const PublicTag("CompensatorPosition", 0x300A00EA, "Compensator Position", VR.kDS,
          VM.k2, false);
  static const PublicTag kCompensatorTransmissionData
      //(300A,00EB)
      = const PublicTag("CompensatorTransmissionData", 0x300A00EB,
          "Compensator Transmission Data", VR.kDS, VM.k1_n, false);
  static const PublicTag kCompensatorThicknessData
      //(300A,00EC)
      = const PublicTag("CompensatorThicknessData", 0x300A00EC,
          "Compensator Thickness Data", VR.kDS, VM.k1_n, false);
  static const PublicTag kNumberOfBoli
      //(300A,00ED)
      =
      const PublicTag("NumberOfBoli", 0x300A00ED, "Number of Boli", VR.kIS, VM.k1, false);
  static const PublicTag kCompensatorType
      //(300A,00EE)
      = const PublicTag(
          "CompensatorType", 0x300A00EE, "Compensator Type", VR.kCS, VM.k1, false);
  static const PublicTag kCompensatorTrayID
      //(300A,00EF)
      = const PublicTag(
          "CompensatorTrayID", 0x300A00EF, "Compensator Tray ID", VR.kSH, VM.k1, false);
  static const PublicTag kNumberOfBlocks
      //(300A,00F0)
      = const PublicTag(
          "NumberOfBlocks", 0x300A00F0, "Number of Blocks", VR.kIS, VM.k1, false);
  static const PublicTag kTotalBlockTrayFactor
      //(300A,00F2)
      = const PublicTag("TotalBlockTrayFactor", 0x300A00F2, "Total Block Tray Factor",
          VR.kDS, VM.k1, false);
  static const PublicTag kTotalBlockTrayWaterEquivalentThickness
      //(300A,00F3)
      = const PublicTag("TotalBlockTrayWaterEquivalentThickness", 0x300A00F3,
          "Total Block Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kBlockSequence
      //(300A,00F4)
      = const PublicTag(
          "BlockSequence", 0x300A00F4, "Block Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBlockTrayID
      //(300A,00F5)
      = const PublicTag("BlockTrayID", 0x300A00F5, "Block Tray ID", VR.kSH, VM.k1, false);
  static const PublicTag kSourceToBlockTrayDistance
      //(300A,00F6)
      = const PublicTag("SourceToBlockTrayDistance", 0x300A00F6,
          "Source to Block Tray Distance", VR.kDS, VM.k1, false);
  static const PublicTag kIsocenterToBlockTrayDistance
      //(300A,00F7)
      = const PublicTag("IsocenterToBlockTrayDistance", 0x300A00F7,
          "Isocenter to Block Tray Distance", VR.kFL, VM.k1, false);
  static const PublicTag kBlockType
      //(300A,00F8)
      = const PublicTag("BlockType", 0x300A00F8, "Block Type", VR.kCS, VM.k1, false);
  static const PublicTag kAccessoryCode
      //(300A,00F9)
      = const PublicTag(
          "AccessoryCode", 0x300A00F9, "Accessory Code", VR.kLO, VM.k1, false);
  static const PublicTag kBlockDivergence
      //(300A,00FA)
      = const PublicTag(
          "BlockDivergence", 0x300A00FA, "Block Divergence", VR.kCS, VM.k1, false);
  static const PublicTag kBlockMountingPosition
      //(300A,00FB)
      = const PublicTag("BlockMountingPosition", 0x300A00FB, "Block Mounting Position",
          VR.kCS, VM.k1, false);
  static const PublicTag kBlockNumber
      //(300A,00FC)
      = const PublicTag("BlockNumber", 0x300A00FC, "Block Number", VR.kIS, VM.k1, false);
  static const PublicTag kBlockName
      //(300A,00FE)
      = const PublicTag("BlockName", 0x300A00FE, "Block Name", VR.kLO, VM.k1, false);
  static const PublicTag kBlockThickness
      //(300A,0100)
      = const PublicTag(
          "BlockThickness", 0x300A0100, "Block Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kBlockTransmission
      //(300A,0102)
      = const PublicTag(
          "BlockTransmission", 0x300A0102, "Block Transmission", VR.kDS, VM.k1, false);
  static const PublicTag kBlockNumberOfPoints
      //(300A,0104)
      = const PublicTag("BlockNumberOfPoints", 0x300A0104, "Block Number of Points",
          VR.kIS, VM.k1, false);
  static const PublicTag kBlockData
      //(300A,0106)
      = const PublicTag("BlockData", 0x300A0106, "Block Data", VR.kDS, VM.k2_2n, false);
  static const PublicTag kApplicatorSequence
      //(300A,0107)
      = const PublicTag(
          "ApplicatorSequence", 0x300A0107, "Applicator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kApplicatorID
      //(300A,0108)
      =
      const PublicTag("ApplicatorID", 0x300A0108, "Applicator ID", VR.kSH, VM.k1, false);
  static const PublicTag kApplicatorType
      //(300A,0109)
      = const PublicTag(
          "ApplicatorType", 0x300A0109, "Applicator Type", VR.kCS, VM.k1, false);
  static const PublicTag kApplicatorDescription
      //(300A,010A)
      = const PublicTag("ApplicatorDescription", 0x300A010A, "Applicator Description",
          VR.kLO, VM.k1, false);
  static const PublicTag kCumulativeDoseReferenceCoefficient
      //(300A,010C)
      = const PublicTag("CumulativeDoseReferenceCoefficient", 0x300A010C,
          "Cumulative Dose Reference Coefficient", VR.kDS, VM.k1, false);
  static const PublicTag kFinalCumulativeMetersetWeight
      //(300A,010E)
      = const PublicTag("FinalCumulativeMetersetWeight", 0x300A010E,
          "Final Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const PublicTag kNumberOfControlPoints
      //(300A,0110)
      = const PublicTag("NumberOfControlPoints", 0x300A0110, "Number of Control Points",
          VR.kIS, VM.k1, false);
  static const PublicTag kControlPointSequence
      //(300A,0111)
      = const PublicTag("ControlPointSequence", 0x300A0111, "Control Point Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kControlPointIndex
      //(300A,0112)
      = const PublicTag(
          "ControlPointIndex", 0x300A0112, "Control Point Index", VR.kIS, VM.k1, false);
  static const PublicTag kNominalBeamEnergy
      //(300A,0114)
      = const PublicTag(
          "NominalBeamEnergy", 0x300A0114, "Nominal Beam Energy", VR.kDS, VM.k1, false);
  static const PublicTag kDoseRateSet
      //(300A,0115)
      = const PublicTag("DoseRateSet", 0x300A0115, "Dose Rate Set", VR.kDS, VM.k1, false);
  static const PublicTag kWedgePositionSequence
      //(300A,0116)
      = const PublicTag("WedgePositionSequence", 0x300A0116, "Wedge Position Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kWedgePosition
      //(300A,0118)
      = const PublicTag(
          "WedgePosition", 0x300A0118, "Wedge Position", VR.kCS, VM.k1, false);
  static const PublicTag kBeamLimitingDevicePositionSequence
      //(300A,011A)
      = const PublicTag("BeamLimitingDevicePositionSequence", 0x300A011A,
          "Beam Limiting Device Position Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLeafJawPositions
      //(300A,011C)
      = const PublicTag(
          "LeafJawPositions", 0x300A011C, "Leaf/Jaw Positions", VR.kDS, VM.k2_2n, false);
  static const PublicTag kGantryAngle
      //(300A,011E)
      = const PublicTag("GantryAngle", 0x300A011E, "Gantry Angle", VR.kDS, VM.k1, false);
  static const PublicTag kGantryRotationDirection
      //(300A,011F)
      = const PublicTag("GantryRotationDirection", 0x300A011F,
          "Gantry Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceAngle
      //(300A,0120)
      = const PublicTag("BeamLimitingDeviceAngle", 0x300A0120,
          "Beam Limiting Device Angle", VR.kDS, VM.k1, false);
  static const PublicTag kBeamLimitingDeviceRotationDirection
      //(300A,0121)
      = const PublicTag("BeamLimitingDeviceRotationDirection", 0x300A0121,
          "Beam Limiting Device Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kPatientSupportAngle
      //(300A,0122)
      = const PublicTag("PatientSupportAngle", 0x300A0122, "Patient Support Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kPatientSupportRotationDirection
      //(300A,0123)
      = const PublicTag("PatientSupportRotationDirection", 0x300A0123,
          "Patient Support Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kTableTopEccentricAxisDistance
      //(300A,0124)
      = const PublicTag("TableTopEccentricAxisDistance", 0x300A0124,
          "Table Top Eccentric Axis Distance", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopEccentricAngle
      //(300A,0125)
      = const PublicTag("TableTopEccentricAngle", 0x300A0125, "Table Top Eccentric Angle",
          VR.kDS, VM.k1, false);
  static const PublicTag kTableTopEccentricRotationDirection
      //(300A,0126)
      = const PublicTag("TableTopEccentricRotationDirection", 0x300A0126,
          "Table Top Eccentric Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kTableTopVerticalPosition
      //(300A,0128)
      = const PublicTag("TableTopVerticalPosition", 0x300A0128,
          "Table Top Vertical Position", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLongitudinalPosition
      //(300A,0129)
      = const PublicTag("TableTopLongitudinalPosition", 0x300A0129,
          "Table Top Longitudinal Position", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLateralPosition
      //(300A,012A)
      = const PublicTag("TableTopLateralPosition", 0x300A012A,
          "Table Top Lateral Position", VR.kDS, VM.k1, false);
  static const PublicTag kIsocenterPosition
      //(300A,012C)
      = const PublicTag(
          "IsocenterPosition", 0x300A012C, "Isocenter Position", VR.kDS, VM.k3, false);
  static const PublicTag kSurfaceEntryPoint
      //(300A,012E)
      = const PublicTag(
          "SurfaceEntryPoint", 0x300A012E, "Surface Entry Point", VR.kDS, VM.k3, false);
  static const PublicTag kSourceToSurfaceDistance
      //(300A,0130)
      = const PublicTag("SourceToSurfaceDistance", 0x300A0130,
          "Source to Surface Distance", VR.kDS, VM.k1, false);
  static const PublicTag kCumulativeMetersetWeight
      //(300A,0134)
      = const PublicTag("CumulativeMetersetWeight", 0x300A0134,
          "Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopPitchAngle
      //(300A,0140)
      = const PublicTag("TableTopPitchAngle", 0x300A0140, "Table Top Pitch Angle", VR.kFL,
          VM.k1, false);
  static const PublicTag kTableTopPitchRotationDirection
      //(300A,0142)
      = const PublicTag("TableTopPitchRotationDirection", 0x300A0142,
          "Table Top Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kTableTopRollAngle
      //(300A,0144)
      = const PublicTag(
          "TableTopRollAngle", 0x300A0144, "Table Top Roll Angle", VR.kFL, VM.k1, false);
  static const PublicTag kTableTopRollRotationDirection
      //(300A,0146)
      = const PublicTag("TableTopRollRotationDirection", 0x300A0146,
          "Table Top Roll Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kHeadFixationAngle
      //(300A,0148)
      = const PublicTag(
          "HeadFixationAngle", 0x300A0148, "Head Fixation Angle", VR.kFL, VM.k1, false);
  static const PublicTag kGantryPitchAngle
      //(300A,014A)
      = const PublicTag(
          "GantryPitchAngle", 0x300A014A, "Gantry Pitch Angle", VR.kFL, VM.k1, false);
  static const PublicTag kGantryPitchRotationDirection
      //(300A,014C)
      = const PublicTag("GantryPitchRotationDirection", 0x300A014C,
          "Gantry Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const PublicTag kGantryPitchAngleTolerance
      //(300A,014E)
      = const PublicTag("GantryPitchAngleTolerance", 0x300A014E,
          "Gantry Pitch Angle Tolerance", VR.kFL, VM.k1, false);
  static const PublicTag kPatientSetupSequence
      //(300A,0180)
      = const PublicTag("PatientSetupSequence", 0x300A0180, "Patient Setup Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPatientSetupNumber
      //(300A,0182)
      = const PublicTag(
          "PatientSetupNumber", 0x300A0182, "Patient Setup Number", VR.kIS, VM.k1, false);
  static const PublicTag kPatientSetupLabel
      //(300A,0183)
      = const PublicTag(
          "PatientSetupLabel", 0x300A0183, "Patient Setup Label", VR.kLO, VM.k1, false);
  static const PublicTag kPatientAdditionalPosition
      //(300A,0184)
      = const PublicTag("PatientAdditionalPosition", 0x300A0184,
          "Patient Additional Position", VR.kLO, VM.k1, false);
  static const PublicTag kFixationDeviceSequence
      //(300A,0190)
      = const PublicTag("FixationDeviceSequence", 0x300A0190, "Fixation Device Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kFixationDeviceType
      //(300A,0192)
      = const PublicTag(
          "FixationDeviceType", 0x300A0192, "Fixation Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kFixationDeviceLabel
      //(300A,0194)
      = const PublicTag("FixationDeviceLabel", 0x300A0194, "Fixation Device Label",
          VR.kSH, VM.k1, false);
  static const PublicTag kFixationDeviceDescription
      //(300A,0196)
      = const PublicTag("FixationDeviceDescription", 0x300A0196,
          "Fixation Device Description", VR.kST, VM.k1, false);
  static const PublicTag kFixationDevicePosition
      //(300A,0198)
      = const PublicTag("FixationDevicePosition", 0x300A0198, "Fixation Device Position",
          VR.kSH, VM.k1, false);
  static const PublicTag kFixationDevicePitchAngle
      //(300A,0199)
      = const PublicTag("FixationDevicePitchAngle", 0x300A0199,
          "Fixation Device Pitch Angle", VR.kFL, VM.k1, false);
  static const PublicTag kFixationDeviceRollAngle
      //(300A,019A)
      = const PublicTag("FixationDeviceRollAngle", 0x300A019A,
          "Fixation Device Roll Angle", VR.kFL, VM.k1, false);
  static const PublicTag kShieldingDeviceSequence
      //(300A,01A0)
      = const PublicTag("ShieldingDeviceSequence", 0x300A01A0,
          "Shielding Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kShieldingDeviceType
      //(300A,01A2)
      = const PublicTag("ShieldingDeviceType", 0x300A01A2, "Shielding Device Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kShieldingDeviceLabel
      //(300A,01A4)
      = const PublicTag("ShieldingDeviceLabel", 0x300A01A4, "Shielding Device Label",
          VR.kSH, VM.k1, false);
  static const PublicTag kShieldingDeviceDescription
      //(300A,01A6)
      = const PublicTag("ShieldingDeviceDescription", 0x300A01A6,
          "Shielding Device Description", VR.kST, VM.k1, false);
  static const PublicTag kShieldingDevicePosition
      //(300A,01A8)
      = const PublicTag("ShieldingDevicePosition", 0x300A01A8,
          "Shielding Device Position", VR.kSH, VM.k1, false);
  static const PublicTag kSetupTechnique
      //(300A,01B0)
      = const PublicTag(
          "SetupTechnique", 0x300A01B0, "Setup Technique", VR.kCS, VM.k1, false);
  static const PublicTag kSetupTechniqueDescription
      //(300A,01B2)
      = const PublicTag("SetupTechniqueDescription", 0x300A01B2,
          "Setup Technique Description", VR.kST, VM.k1, false);
  static const PublicTag kSetupDeviceSequence
      //(300A,01B4)
      = const PublicTag("SetupDeviceSequence", 0x300A01B4, "Setup Device Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kSetupDeviceType
      //(300A,01B6)
      = const PublicTag(
          "SetupDeviceType", 0x300A01B6, "Setup Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kSetupDeviceLabel
      //(300A,01B8)
      = const PublicTag(
          "SetupDeviceLabel", 0x300A01B8, "Setup Device Label", VR.kSH, VM.k1, false);
  static const PublicTag kSetupDeviceDescription
      //(300A,01BA)
      = const PublicTag("SetupDeviceDescription", 0x300A01BA, "Setup Device Description",
          VR.kST, VM.k1, false);
  static const PublicTag kSetupDeviceParameter
      //(300A,01BC)
      = const PublicTag("SetupDeviceParameter", 0x300A01BC, "Setup Device Parameter",
          VR.kDS, VM.k1, false);
  static const PublicTag kSetupReferenceDescription
      //(300A,01D0)
      = const PublicTag("SetupReferenceDescription", 0x300A01D0,
          "Setup Reference Description", VR.kST, VM.k1, false);
  static const PublicTag kTableTopVerticalSetupDisplacement
      //(300A,01D2)
      = const PublicTag("TableTopVerticalSetupDisplacement", 0x300A01D2,
          "Table Top Vertical Setup Displacement", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLongitudinalSetupDisplacement
      //(300A,01D4)
      = const PublicTag("TableTopLongitudinalSetupDisplacement", 0x300A01D4,
          "Table Top Longitudinal Setup Displacement", VR.kDS, VM.k1, false);
  static const PublicTag kTableTopLateralSetupDisplacement
      //(300A,01D6)
      = const PublicTag("TableTopLateralSetupDisplacement", 0x300A01D6,
          "Table Top Lateral Setup Displacement", VR.kDS, VM.k1, false);
  static const PublicTag kBrachyTreatmentTechnique
      //(300A,0200)
      = const PublicTag("BrachyTreatmentTechnique", 0x300A0200,
          "Brachy Treatment Technique", VR.kCS, VM.k1, false);
  static const PublicTag kBrachyTreatmentType
      //(300A,0202)
      = const PublicTag("BrachyTreatmentType", 0x300A0202, "Brachy Treatment Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kTreatmentMachineSequence
      //(300A,0206)
      = const PublicTag("TreatmentMachineSequence", 0x300A0206,
          "Treatment Machine Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceSequence
      //(300A,0210)
      = const PublicTag(
          "SourceSequence", 0x300A0210, "Source Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSourceNumber
      //(300A,0212)
      =
      const PublicTag("SourceNumber", 0x300A0212, "Source Number", VR.kIS, VM.k1, false);
  static const PublicTag kSourceType
      //(300A,0214)
      = const PublicTag("SourceType", 0x300A0214, "Source Type", VR.kCS, VM.k1, false);
  static const PublicTag kSourceManufacturer
      //(300A,0216)
      = const PublicTag(
          "SourceManufacturer", 0x300A0216, "Source Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kActiveSourceDiameter
      //(300A,0218)
      = const PublicTag("ActiveSourceDiameter", 0x300A0218, "Active Source Diameter",
          VR.kDS, VM.k1, false);
  static const PublicTag kActiveSourceLength
      //(300A,021A)
      = const PublicTag(
          "ActiveSourceLength", 0x300A021A, "Active Source Length", VR.kDS, VM.k1, false);
  static const PublicTag kSourceModelID
      //(300A,021B)
      = const PublicTag(
          "SourceModelID", 0x300A021B, "Source Model ID", VR.kSH, VM.k1, false);
  static const PublicTag kSourceDescription
      //(300A,021C)
      = const PublicTag(
          "SourceDescription", 0x300A021C, "Source Description", VR.kLO, VM.k1, false);
  static const PublicTag kSourceEncapsulationNominalThickness
      //(300A,0222)
      = const PublicTag("SourceEncapsulationNominalThickness", 0x300A0222,
          "Source Encapsulation Nominal Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kSourceEncapsulationNominalTransmission
      //(300A,0224)
      = const PublicTag("SourceEncapsulationNominalTransmission", 0x300A0224,
          "Source Encapsulation Nominal Transmission", VR.kDS, VM.k1, false);
  static const PublicTag kSourceIsotopeName
      //(300A,0226)
      = const PublicTag(
          "SourceIsotopeName", 0x300A0226, "Source Isotope Name", VR.kLO, VM.k1, false);
  static const PublicTag kSourceIsotopeHalfLife
      //(300A,0228)
      = const PublicTag("SourceIsotopeHalfLife", 0x300A0228, "Source Isotope Half Life",
          VR.kDS, VM.k1, false);
  static const PublicTag kSourceStrengthUnits
      //(300A,0229)
      = const PublicTag("SourceStrengthUnits", 0x300A0229, "Source Strength Units",
          VR.kCS, VM.k1, false);
  static const PublicTag kReferenceAirKermaRate
      //(300A,022A)
      = const PublicTag("ReferenceAirKermaRate", 0x300A022A, "Reference Air Kerma Rate",
          VR.kDS, VM.k1, false);
  static const PublicTag kSourceStrength
      //(300A,022B)
      = const PublicTag(
          "SourceStrength", 0x300A022B, "Source Strength", VR.kDS, VM.k1, false);
  static const PublicTag kSourceStrengthReferenceDate
      //(300A,022C)
      = const PublicTag("SourceStrengthReferenceDate", 0x300A022C,
          "Source Strength Reference Date", VR.kDA, VM.k1, false);
  static const PublicTag kSourceStrengthReferenceTime
      //(300A,022E)
      = const PublicTag("SourceStrengthReferenceTime", 0x300A022E,
          "Source Strength Reference Time", VR.kTM, VM.k1, false);
  static const PublicTag kApplicationSetupSequence
      //(300A,0230)
      = const PublicTag("ApplicationSetupSequence", 0x300A0230,
          "Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kApplicationSetupType
      //(300A,0232)
      = const PublicTag("ApplicationSetupType", 0x300A0232, "Application Setup Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kApplicationSetupNumber
      //(300A,0234)
      = const PublicTag("ApplicationSetupNumber", 0x300A0234, "Application Setup Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kApplicationSetupName
      //(300A,0236)
      = const PublicTag("ApplicationSetupName", 0x300A0236, "Application Setup Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kApplicationSetupManufacturer
      //(300A,0238)
      = const PublicTag("ApplicationSetupManufacturer", 0x300A0238,
          "Application Setup Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kTemplateNumber
      //(300A,0240)
      = const PublicTag(
          "TemplateNumber", 0x300A0240, "Template Number", VR.kIS, VM.k1, false);
  static const PublicTag kTemplateType
      //(300A,0242)
      =
      const PublicTag("TemplateType", 0x300A0242, "Template Type", VR.kSH, VM.k1, false);
  static const PublicTag kTemplateName
      //(300A,0244)
      =
      const PublicTag("TemplateName", 0x300A0244, "Template Name", VR.kLO, VM.k1, false);
  static const PublicTag kTotalReferenceAirKerma
      //(300A,0250)
      = const PublicTag("TotalReferenceAirKerma", 0x300A0250, "Total Reference Air Kerma",
          VR.kDS, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceSequence
      //(300A,0260)
      = const PublicTag("BrachyAccessoryDeviceSequence", 0x300A0260,
          "Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceNumber
      //(300A,0262)
      = const PublicTag("BrachyAccessoryDeviceNumber", 0x300A0262,
          "Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceID
      //(300A,0263)
      = const PublicTag("BrachyAccessoryDeviceID", 0x300A0263,
          "Brachy Accessory Device ID", VR.kSH, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceType
      //(300A,0264)
      = const PublicTag("BrachyAccessoryDeviceType", 0x300A0264,
          "Brachy Accessory Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceName
      //(300A,0266)
      = const PublicTag("BrachyAccessoryDeviceName", 0x300A0266,
          "Brachy Accessory Device Name", VR.kLO, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceNominalThickness
      //(300A,026A)
      = const PublicTag("BrachyAccessoryDeviceNominalThickness", 0x300A026A,
          "Brachy Accessory Device Nominal Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kBrachyAccessoryDeviceNominalTransmission
      //(300A,026C)
      = const PublicTag("BrachyAccessoryDeviceNominalTransmission", 0x300A026C,
          "Brachy Accessory Device Nominal Transmission", VR.kDS, VM.k1, false);
  static const PublicTag kChannelSequence
      //(300A,0280)
      = const PublicTag(
          "ChannelSequence", 0x300A0280, "Channel Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelNumber
      //(300A,0282)
      = const PublicTag(
          "ChannelNumber", 0x300A0282, "Channel Number", VR.kIS, VM.k1, false);
  static const PublicTag kChannelLength
      //(300A,0284)
      = const PublicTag(
          "ChannelLength", 0x300A0284, "Channel Length", VR.kDS, VM.k1, false);
  static const PublicTag kChannelTotalTime
      //(300A,0286)
      = const PublicTag(
          "ChannelTotalTime", 0x300A0286, "Channel Total Time", VR.kDS, VM.k1, false);
  static const PublicTag kSourceMovementType
      //(300A,0288)
      = const PublicTag(
          "SourceMovementType", 0x300A0288, "Source Movement Type", VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfPulses
      //(300A,028A)
      = const PublicTag(
          "NumberOfPulses", 0x300A028A, "Number of Pulses", VR.kIS, VM.k1, false);
  static const PublicTag kPulseRepetitionInterval
      //(300A,028C)
      = const PublicTag("PulseRepetitionInterval", 0x300A028C,
          "Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const PublicTag kSourceApplicatorNumber
      //(300A,0290)
      = const PublicTag("SourceApplicatorNumber", 0x300A0290, "Source Applicator Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kSourceApplicatorID
      //(300A,0291)
      = const PublicTag(
          "SourceApplicatorID", 0x300A0291, "Source Applicator ID", VR.kSH, VM.k1, false);
  static const PublicTag kSourceApplicatorType
      //(300A,0292)
      = const PublicTag("SourceApplicatorType", 0x300A0292, "Source Applicator Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kSourceApplicatorName
      //(300A,0294)
      = const PublicTag("SourceApplicatorName", 0x300A0294, "Source Applicator Name",
          VR.kLO, VM.k1, false);
  static const PublicTag kSourceApplicatorLength
      //(300A,0296)
      = const PublicTag("SourceApplicatorLength", 0x300A0296, "Source Applicator Length",
          VR.kDS, VM.k1, false);
  static const PublicTag kSourceApplicatorManufacturer
      //(300A,0298)
      = const PublicTag("SourceApplicatorManufacturer", 0x300A0298,
          "Source Applicator Manufacturer", VR.kLO, VM.k1, false);
  static const PublicTag kSourceApplicatorWallNominalThickness
      //(300A,029C)
      = const PublicTag("SourceApplicatorWallNominalThickness", 0x300A029C,
          "Source Applicator Wall Nominal Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kSourceApplicatorWallNominalTransmission
      //(300A,029E)
      = const PublicTag("SourceApplicatorWallNominalTransmission", 0x300A029E,
          "Source Applicator Wall Nominal Transmission", VR.kDS, VM.k1, false);
  static const PublicTag kSourceApplicatorStepSize
      //(300A,02A0)
      = const PublicTag("SourceApplicatorStepSize", 0x300A02A0,
          "Source Applicator Step Size", VR.kDS, VM.k1, false);
  static const PublicTag kTransferTubeNumber
      //(300A,02A2)
      = const PublicTag(
          "TransferTubeNumber", 0x300A02A2, "Transfer Tube Number", VR.kIS, VM.k1, false);
  static const PublicTag kTransferTubeLength
      //(300A,02A4)
      = const PublicTag(
          "TransferTubeLength", 0x300A02A4, "Transfer Tube Length", VR.kDS, VM.k1, false);
  static const PublicTag kChannelShieldSequence
      //(300A,02B0)
      = const PublicTag("ChannelShieldSequence", 0x300A02B0, "Channel Shield Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kChannelShieldNumber
      //(300A,02B2)
      = const PublicTag("ChannelShieldNumber", 0x300A02B2, "Channel Shield Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kChannelShieldID
      //(300A,02B3)
      = const PublicTag(
          "ChannelShieldID", 0x300A02B3, "Channel Shield ID", VR.kSH, VM.k1, false);
  static const PublicTag kChannelShieldName
      //(300A,02B4)
      = const PublicTag(
          "ChannelShieldName", 0x300A02B4, "Channel Shield Name", VR.kLO, VM.k1, false);
  static const PublicTag kChannelShieldNominalThickness
      //(300A,02B8)
      = const PublicTag("ChannelShieldNominalThickness", 0x300A02B8,
          "Channel Shield Nominal Thickness", VR.kDS, VM.k1, false);
  static const PublicTag kChannelShieldNominalTransmission
      //(300A,02BA)
      = const PublicTag("ChannelShieldNominalTransmission", 0x300A02BA,
          "Channel Shield Nominal Transmission", VR.kDS, VM.k1, false);
  static const PublicTag kFinalCumulativeTimeWeight
      //(300A,02C8)
      = const PublicTag("FinalCumulativeTimeWeight", 0x300A02C8,
          "Final Cumulative Time Weight", VR.kDS, VM.k1, false);
  static const PublicTag kBrachyControlPointSequence
      //(300A,02D0)
      = const PublicTag("BrachyControlPointSequence", 0x300A02D0,
          "Brachy Control Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kControlPointRelativePosition
      //(300A,02D2)
      = const PublicTag("ControlPointRelativePosition", 0x300A02D2,
          "Control Point Relative Position", VR.kDS, VM.k1, false);
  static const PublicTag kControlPoint3DPosition
      //(300A,02D4)
      = const PublicTag("ControlPoint3DPosition", 0x300A02D4, "Control Point 3D Position",
          VR.kDS, VM.k3, false);
  static const PublicTag kCumulativeTimeWeight
      //(300A,02D6)
      = const PublicTag("CumulativeTimeWeight", 0x300A02D6, "Cumulative Time Weight",
          VR.kDS, VM.k1, false);
  static const PublicTag kCompensatorDivergence
      //(300A,02E0)
      = const PublicTag("CompensatorDivergence", 0x300A02E0, "Compensator Divergence",
          VR.kCS, VM.k1, false);
  static const PublicTag kCompensatorMountingPosition
      //(300A,02E1)
      = const PublicTag("CompensatorMountingPosition", 0x300A02E1,
          "Compensator Mounting Position", VR.kCS, VM.k1, false);
  static const PublicTag kSourceToCompensatorDistance
      //(300A,02E2)
      = const PublicTag("SourceToCompensatorDistance", 0x300A02E2,
          "Source to Compensator Distance", VR.kDS, VM.k1_n, false);
  static const PublicTag kTotalCompensatorTrayWaterEquivalentThickness
      //(300A,02E3)
      = const PublicTag("TotalCompensatorTrayWaterEquivalentThickness", 0x300A02E3,
          "Total Compensator Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kIsocenterToCompensatorTrayDistance
      //(300A,02E4)
      = const PublicTag("IsocenterToCompensatorTrayDistance", 0x300A02E4,
          "Isocenter to Compensator Tray Distance", VR.kFL, VM.k1, false);
  static const PublicTag kCompensatorColumnOffset
      //(300A,02E5)
      = const PublicTag("CompensatorColumnOffset", 0x300A02E5,
          "Compensator Column Offset", VR.kFL, VM.k1, false);
  static const PublicTag kIsocenterToCompensatorDistances
      //(300A,02E6)
      = const PublicTag("IsocenterToCompensatorDistances", 0x300A02E6,
          "Isocenter to Compensator Distances", VR.kFL, VM.k1_n, false);
  static const PublicTag kCompensatorRelativeStoppingPowerRatio
      //(300A,02E7)
      = const PublicTag("CompensatorRelativeStoppingPowerRatio", 0x300A02E7,
          "Compensator Relative Stopping Power Ratio", VR.kFL, VM.k1, false);
  static const PublicTag kCompensatorMillingToolDiameter
      //(300A,02E8)
      = const PublicTag("CompensatorMillingToolDiameter", 0x300A02E8,
          "Compensator Milling Tool Diameter", VR.kFL, VM.k1, false);
  static const PublicTag kIonRangeCompensatorSequence
      //(300A,02EA)
      = const PublicTag("IonRangeCompensatorSequence", 0x300A02EA,
          "Ion Range Compensator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kCompensatorDescription
      //(300A,02EB)
      = const PublicTag("CompensatorDescription", 0x300A02EB, "Compensator Description",
          VR.kLT, VM.k1, false);
  static const PublicTag kRadiationMassNumber
      //(300A,0302)
      = const PublicTag("RadiationMassNumber", 0x300A0302, "Radiation Mass Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kRadiationAtomicNumber
      //(300A,0304)
      = const PublicTag("RadiationAtomicNumber", 0x300A0304, "Radiation Atomic Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kRadiationChargeState
      //(300A,0306)
      = const PublicTag("RadiationChargeState", 0x300A0306, "Radiation Charge State",
          VR.kSS, VM.k1, false);
  static const PublicTag kScanMode
      //(300A,0308)
      = const PublicTag("ScanMode", 0x300A0308, "Scan Mode", VR.kCS, VM.k1, false);
  static const PublicTag kVirtualSourceAxisDistances
      //(300A,030A)
      = const PublicTag("VirtualSourceAxisDistances", 0x300A030A,
          "Virtual Source-Axis Distances", VR.kFL, VM.k2, false);
  static const PublicTag kSnoutSequence
      //(300A,030C)
      = const PublicTag(
          "SnoutSequence", 0x300A030C, "Snout Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSnoutPosition
      //(300A,030D)
      = const PublicTag(
          "SnoutPosition", 0x300A030D, "Snout Position", VR.kFL, VM.k1, false);
  static const PublicTag kSnoutID
      //(300A,030F)
      = const PublicTag("SnoutID", 0x300A030F, "Snout ID", VR.kSH, VM.k1, false);
  static const PublicTag kNumberOfRangeShifters
      //(300A,0312)
      = const PublicTag("NumberOfRangeShifters", 0x300A0312, "Number of Range Shifters",
          VR.kIS, VM.k1, false);
  static const PublicTag kRangeShifterSequence
      //(300A,0314)
      = const PublicTag("RangeShifterSequence", 0x300A0314, "Range Shifter Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRangeShifterNumber
      //(300A,0316)
      = const PublicTag(
          "RangeShifterNumber", 0x300A0316, "Range Shifter Number", VR.kIS, VM.k1, false);
  static const PublicTag kRangeShifterID
      //(300A,0318)
      = const PublicTag(
          "RangeShifterID", 0x300A0318, "Range Shifter ID", VR.kSH, VM.k1, false);
  static const PublicTag kRangeShifterType
      //(300A,0320)
      = const PublicTag(
          "RangeShifterType", 0x300A0320, "Range Shifter Type", VR.kCS, VM.k1, false);
  static const PublicTag kRangeShifterDescription
      //(300A,0322)
      = const PublicTag("RangeShifterDescription", 0x300A0322,
          "Range Shifter Description", VR.kLO, VM.k1, false);
  static const PublicTag kNumberOfLateralSpreadingDevices
      //(300A,0330)
      = const PublicTag("NumberOfLateralSpreadingDevices", 0x300A0330,
          "Number of Lateral Spreading Devices", VR.kIS, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceSequence
      //(300A,0332)
      = const PublicTag("LateralSpreadingDeviceSequence", 0x300A0332,
          "Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceNumber
      //(300A,0334)
      = const PublicTag("LateralSpreadingDeviceNumber", 0x300A0334,
          "Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceID
      //(300A,0336)
      = const PublicTag("LateralSpreadingDeviceID", 0x300A0336,
          "Lateral Spreading Device ID", VR.kSH, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceType
      //(300A,0338)
      = const PublicTag("LateralSpreadingDeviceType", 0x300A0338,
          "Lateral Spreading Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceDescription
      //(300A,033A)
      = const PublicTag("LateralSpreadingDeviceDescription", 0x300A033A,
          "Lateral Spreading Device Description", VR.kLO, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceWaterEquivalentThickness
      //(300A,033C)
      = const PublicTag("LateralSpreadingDeviceWaterEquivalentThickness", 0x300A033C,
          "Lateral Spreading Device Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kNumberOfRangeModulators
      //(300A,0340)
      = const PublicTag("NumberOfRangeModulators", 0x300A0340,
          "Number of Range Modulators", VR.kIS, VM.k1, false);
  static const PublicTag kRangeModulatorSequence
      //(300A,0342)
      = const PublicTag("RangeModulatorSequence", 0x300A0342, "Range Modulator Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kRangeModulatorNumber
      //(300A,0344)
      = const PublicTag("RangeModulatorNumber", 0x300A0344, "Range Modulator Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kRangeModulatorID
      //(300A,0346)
      = const PublicTag(
          "RangeModulatorID", 0x300A0346, "Range Modulator ID", VR.kSH, VM.k1, false);
  static const PublicTag kRangeModulatorType
      //(300A,0348)
      = const PublicTag(
          "RangeModulatorType", 0x300A0348, "Range Modulator Type", VR.kCS, VM.k1, false);
  static const PublicTag kRangeModulatorDescription
      //(300A,034A)
      = const PublicTag("RangeModulatorDescription", 0x300A034A,
          "Range Modulator Description", VR.kLO, VM.k1, false);
  static const PublicTag kBeamCurrentModulationID
      //(300A,034C)
      = const PublicTag("BeamCurrentModulationID", 0x300A034C,
          "Beam Current Modulation ID", VR.kSH, VM.k1, false);
  static const PublicTag kPatientSupportType
      //(300A,0350)
      = const PublicTag(
          "PatientSupportType", 0x300A0350, "Patient Support Type", VR.kCS, VM.k1, false);
  static const PublicTag kPatientSupportID
      //(300A,0352)
      = const PublicTag(
          "PatientSupportID", 0x300A0352, "Patient Support ID", VR.kSH, VM.k1, false);
  static const PublicTag kPatientSupportAccessoryCode
      //(300A,0354)
      = const PublicTag("PatientSupportAccessoryCode", 0x300A0354,
          "Patient Support Accessory Code", VR.kLO, VM.k1, false);
  static const PublicTag kFixationLightAzimuthalAngle
      //(300A,0356)
      = const PublicTag("FixationLightAzimuthalAngle", 0x300A0356,
          "Fixation Light Azimuthal Angle", VR.kFL, VM.k1, false);
  static const PublicTag kFixationLightPolarAngle
      //(300A,0358)
      = const PublicTag("FixationLightPolarAngle", 0x300A0358,
          "Fixation Light Polar Angle", VR.kFL, VM.k1, false);
  static const PublicTag kMetersetRate
      //(300A,035A)
      =
      const PublicTag("MetersetRate", 0x300A035A, "Meterset Rate", VR.kFL, VM.k1, false);
  static const PublicTag kRangeShifterSettingsSequence
      //(300A,0360)
      = const PublicTag("RangeShifterSettingsSequence", 0x300A0360,
          "Range Shifter Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRangeShifterSetting
      //(300A,0362)
      = const PublicTag("RangeShifterSetting", 0x300A0362, "Range Shifter Setting",
          VR.kLO, VM.k1, false);
  static const PublicTag kIsocenterToRangeShifterDistance
      //(300A,0364)
      = const PublicTag("IsocenterToRangeShifterDistance", 0x300A0364,
          "Isocenter to Range Shifter Distance", VR.kFL, VM.k1, false);
  static const PublicTag kRangeShifterWaterEquivalentThickness
      //(300A,0366)
      = const PublicTag("RangeShifterWaterEquivalentThickness", 0x300A0366,
          "Range Shifter Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceSettingsSequence
      //(300A,0370)
      = const PublicTag("LateralSpreadingDeviceSettingsSequence", 0x300A0370,
          "Lateral Spreading Device Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kLateralSpreadingDeviceSetting
      //(300A,0372)
      = const PublicTag("LateralSpreadingDeviceSetting", 0x300A0372,
          "Lateral Spreading Device Setting", VR.kLO, VM.k1, false);
  static const PublicTag kIsocenterToLateralSpreadingDeviceDistance
      //(300A,0374)
      = const PublicTag("IsocenterToLateralSpreadingDeviceDistance", 0x300A0374,
          "Isocenter to Lateral Spreading Device Distance", VR.kFL, VM.k1, false);
  static const PublicTag kRangeModulatorSettingsSequence
      //(300A,0380)
      = const PublicTag("RangeModulatorSettingsSequence", 0x300A0380,
          "Range Modulator Settings Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kRangeModulatorGatingStartValue
      //(300A,0382)
      = const PublicTag("RangeModulatorGatingStartValue", 0x300A0382,
          "Range Modulator Gating Start Value", VR.kFL, VM.k1, false);
  static const PublicTag kRangeModulatorGatingStopValue
      //(300A,0384)
      = const PublicTag("RangeModulatorGatingStopValue", 0x300A0384,
          "Range Modulator Gating Stop Value", VR.kFL, VM.k1, false);
  static const PublicTag kRangeModulatorGatingStartWaterEquivalentThickness
      //(300A,0386)
      = const PublicTag(
          "RangeModulatorGatingStartWaterEquivalentThickness",
          0x300A0386,
          "Range Modulator Gating Start Water Equivalent Thickness",
          VR.kFL,
          VM.k1,
          false);
  static const PublicTag kRangeModulatorGatingStopWaterEquivalentThickness
      //(300A,0388)
      = const PublicTag("RangeModulatorGatingStopWaterEquivalentThickness", 0x300A0388,
          "Range Modulator Gating Stop Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const PublicTag kIsocenterToRangeModulatorDistance
      //(300A,038A)
      = const PublicTag("IsocenterToRangeModulatorDistance", 0x300A038A,
          "Isocenter to Range Modulator Distance", VR.kFL, VM.k1, false);
  static const PublicTag kScanSpotTuneID
      //(300A,0390)
      = const PublicTag(
          "ScanSpotTuneID", 0x300A0390, "Scan Spot Tune ID", VR.kSH, VM.k1, false);
  static const PublicTag kNumberOfScanSpotPositions
      //(300A,0392)
      = const PublicTag("NumberOfScanSpotPositions", 0x300A0392,
          "Number of Scan Spot Positions", VR.kIS, VM.k1, false);
  static const PublicTag kScanSpotPositionMap
      //(300A,0394)
      = const PublicTag("ScanSpotPositionMap", 0x300A0394, "Scan Spot Position Map",
          VR.kFL, VM.k1_n, false);
  static const PublicTag kScanSpotMetersetWeights
      //(300A,0396)
      = const PublicTag("ScanSpotMetersetWeights", 0x300A0396,
          "Scan Spot Meterset Weights", VR.kFL, VM.k1_n, false);
  static const PublicTag kScanningSpotSize
      //(300A,0398)
      = const PublicTag(
          "ScanningSpotSize", 0x300A0398, "Scanning Spot Size", VR.kFL, VM.k2, false);
  static const PublicTag kNumberOfPaintings
      //(300A,039A)
      = const PublicTag(
          "NumberOfPaintings", 0x300A039A, "Number of Paintings", VR.kIS, VM.k1, false);
  static const PublicTag kIonToleranceTableSequence
      //(300A,03A0)
      = const PublicTag("IonToleranceTableSequence", 0x300A03A0,
          "Ion Tolerance Table Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonBeamSequence
      //(300A,03A2)
      = const PublicTag(
          "IonBeamSequence", 0x300A03A2, "Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonBeamLimitingDeviceSequence
      //(300A,03A4)
      = const PublicTag("IonBeamLimitingDeviceSequence", 0x300A03A4,
          "Ion Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonBlockSequence
      //(300A,03A6)
      = const PublicTag(
          "IonBlockSequence", 0x300A03A6, "Ion Block Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonControlPointSequence
      //(300A,03A8)
      = const PublicTag("IonControlPointSequence", 0x300A03A8,
          "Ion Control Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonWedgeSequence
      //(300A,03AA)
      = const PublicTag(
          "IonWedgeSequence", 0x300A03AA, "Ion Wedge Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kIonWedgePositionSequence
      //(300A,03AC)
      = const PublicTag("IonWedgePositionSequence", 0x300A03AC,
          "Ion Wedge Position Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedSetupImageSequence
      //(300A,0401)
      = const PublicTag("ReferencedSetupImageSequence", 0x300A0401,
          "Referenced Setup Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kSetupImageComment
      //(300A,0402)
      = const PublicTag(
          "SetupImageComment", 0x300A0402, "Setup Image Comment", VR.kST, VM.k1, false);
  static const PublicTag kMotionSynchronizationSequence
      //(300A,0410)
      = const PublicTag("MotionSynchronizationSequence", 0x300A0410,
          "Motion Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kControlPointOrientation
      //(300A,0412)
      = const PublicTag("ControlPointOrientation", 0x300A0412,
          "Control Point Orientation", VR.kFL, VM.k3, false);
  static const PublicTag kGeneralAccessorySequence
      //(300A,0420)
      = const PublicTag("GeneralAccessorySequence", 0x300A0420,
          "General Accessory Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kGeneralAccessoryID
      //(300A,0421)
      = const PublicTag(
          "GeneralAccessoryID", 0x300A0421, "General Accessory ID", VR.kSH, VM.k1, false);
  static const PublicTag kGeneralAccessoryDescription
      //(300A,0422)
      = const PublicTag("GeneralAccessoryDescription", 0x300A0422,
          "General Accessory Description", VR.kST, VM.k1, false);
  static const PublicTag kGeneralAccessoryType
      //(300A,0423)
      = const PublicTag("GeneralAccessoryType", 0x300A0423, "General Accessory Type",
          VR.kCS, VM.k1, false);
  static const PublicTag kGeneralAccessoryNumber
      //(300A,0424)
      = const PublicTag("GeneralAccessoryNumber", 0x300A0424, "General Accessory Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kSourceToGeneralAccessoryDistance
      //(300A,0425)
      = const PublicTag("SourceToGeneralAccessoryDistance", 0x300A0425,
          "Source to General Accessory Distance", VR.kFL, VM.k1, false);
  static const PublicTag kApplicatorGeometrySequence
      //(300A,0431)
      = const PublicTag("ApplicatorGeometrySequence", 0x300A0431,
          "Applicator Geometry Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kApplicatorApertureShape
      //(300A,0432)
      = const PublicTag("ApplicatorApertureShape", 0x300A0432,
          "Applicator Aperture Shape", VR.kCS, VM.k1, false);
  static const PublicTag kApplicatorOpening
      //(300A,0433)
      = const PublicTag(
          "ApplicatorOpening", 0x300A0433, "Applicator Opening", VR.kFL, VM.k1, false);
  static const PublicTag kApplicatorOpeningX
      //(300A,0434)
      = const PublicTag(
          "ApplicatorOpeningX", 0x300A0434, "Applicator Opening X", VR.kFL, VM.k1, false);
  static const PublicTag kApplicatorOpeningY
      //(300A,0435)
      = const PublicTag(
          "ApplicatorOpeningY", 0x300A0435, "Applicator Opening Y", VR.kFL, VM.k1, false);
  static const PublicTag kSourceToApplicatorMountingPositionDistance
      //(300A,0436)
      = const PublicTag("SourceToApplicatorMountingPositionDistance", 0x300A0436,
          "Source to Applicator Mounting Position Distance", VR.kFL, VM.k1, false);
  static const PublicTag kReferencedRTPlanSequence
      //(300C,0002)
      = const PublicTag("ReferencedRTPlanSequence", 0x300C0002,
          "Referenced RT Plan Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedBeamSequence
      //(300C,0004)
      = const PublicTag("ReferencedBeamSequence", 0x300C0004, "Referenced Beam Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedBeamNumber
      //(300C,0006)
      = const PublicTag("ReferencedBeamNumber", 0x300C0006, "Referenced Beam Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kReferencedReferenceImageNumber
      //(300C,0007)
      = const PublicTag("ReferencedReferenceImageNumber", 0x300C0007,
          "Referenced Reference Image Number", VR.kIS, VM.k1, false);
  static const PublicTag kStartCumulativeMetersetWeight
      //(300C,0008)
      = const PublicTag("StartCumulativeMetersetWeight", 0x300C0008,
          "Start Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const PublicTag kEndCumulativeMetersetWeight
      //(300C,0009)
      = const PublicTag("EndCumulativeMetersetWeight", 0x300C0009,
          "End Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const PublicTag kReferencedBrachyApplicationSetupSequence
      //(300C,000A)
      = const PublicTag("ReferencedBrachyApplicationSetupSequence", 0x300C000A,
          "Referenced Brachy Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedBrachyApplicationSetupNumber
      //(300C,000C)
      = const PublicTag("ReferencedBrachyApplicationSetupNumber", 0x300C000C,
          "Referenced Brachy Application Setup Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedSourceNumber
      //(300C,000E)
      = const PublicTag("ReferencedSourceNumber", 0x300C000E, "Referenced Source Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kReferencedFractionGroupSequence
      //(300C,0020)
      = const PublicTag("ReferencedFractionGroupSequence", 0x300C0020,
          "Referenced Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedFractionGroupNumber
      //(300C,0022)
      = const PublicTag("ReferencedFractionGroupNumber", 0x300C0022,
          "Referenced Fraction Group Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedVerificationImageSequence
      //(300C,0040)
      = const PublicTag("ReferencedVerificationImageSequence", 0x300C0040,
          "Referenced Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedReferenceImageSequence
      //(300C,0042)
      = const PublicTag("ReferencedReferenceImageSequence", 0x300C0042,
          "Referenced Reference Image Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedDoseReferenceSequence
      //(300C,0050)
      = const PublicTag("ReferencedDoseReferenceSequence", 0x300C0050,
          "Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedDoseReferenceNumber
      //(300C,0051)
      = const PublicTag("ReferencedDoseReferenceNumber", 0x300C0051,
          "Referenced Dose Reference Number", VR.kIS, VM.k1, false);
  static const PublicTag kBrachyReferencedDoseReferenceSequence
      //(300C,0055)
      = const PublicTag("BrachyReferencedDoseReferenceSequence", 0x300C0055,
          "Brachy Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedStructureSetSequence
      //(300C,0060)
      = const PublicTag("ReferencedStructureSetSequence", 0x300C0060,
          "Referenced Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedPatientSetupNumber
      //(300C,006A)
      = const PublicTag("ReferencedPatientSetupNumber", 0x300C006A,
          "Referenced Patient Setup Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedDoseSequence
      //(300C,0080)
      = const PublicTag("ReferencedDoseSequence", 0x300C0080, "Referenced Dose Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedToleranceTableNumber
      //(300C,00A0)
      = const PublicTag("ReferencedToleranceTableNumber", 0x300C00A0,
          "Referenced Tolerance Table Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedBolusSequence
      //(300C,00B0)
      = const PublicTag("ReferencedBolusSequence", 0x300C00B0,
          "Referenced Bolus Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedWedgeNumber
      //(300C,00C0)
      = const PublicTag("ReferencedWedgeNumber", 0x300C00C0, "Referenced Wedge Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kReferencedCompensatorNumber
      //(300C,00D0)
      = const PublicTag("ReferencedCompensatorNumber", 0x300C00D0,
          "Referenced Compensator Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedBlockNumber
      //(300C,00E0)
      = const PublicTag("ReferencedBlockNumber", 0x300C00E0, "Referenced Block Number",
          VR.kIS, VM.k1, false);
  static const PublicTag kReferencedControlPointIndex
      //(300C,00F0)
      = const PublicTag("ReferencedControlPointIndex", 0x300C00F0,
          "Referenced Control Point Index", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedControlPointSequence
      //(300C,00F2)
      = const PublicTag("ReferencedControlPointSequence", 0x300C00F2,
          "Referenced Control Point Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedStartControlPointIndex
      //(300C,00F4)
      = const PublicTag("ReferencedStartControlPointIndex", 0x300C00F4,
          "Referenced Start Control Point Index", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedStopControlPointIndex
      //(300C,00F6)
      = const PublicTag("ReferencedStopControlPointIndex", 0x300C00F6,
          "Referenced Stop Control Point Index", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedRangeShifterNumber
      //(300C,0100)
      = const PublicTag("ReferencedRangeShifterNumber", 0x300C0100,
          "Referenced Range Shifter Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedLateralSpreadingDeviceNumber
      //(300C,0102)
      = const PublicTag("ReferencedLateralSpreadingDeviceNumber", 0x300C0102,
          "Referenced Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const PublicTag kReferencedRangeModulatorNumber
      //(300C,0104)
      = const PublicTag("ReferencedRangeModulatorNumber", 0x300C0104,
          "Referenced Range Modulator Number", VR.kIS, VM.k1, false);
  static const PublicTag kApprovalStatus
      //(300E,0002)
      = const PublicTag(
          "ApprovalStatus", 0x300E0002, "Approval Status", VR.kCS, VM.k1, false);
  static const PublicTag kReviewDate
      //(300E,0004)
      = const PublicTag("ReviewDate", 0x300E0004, "Review Date", VR.kDA, VM.k1, false);
  static const PublicTag kReviewTime
      //(300E,0005)
      = const PublicTag("ReviewTime", 0x300E0005, "Review Time", VR.kTM, VM.k1, false);
  static const PublicTag kReviewerName
      //(300E,0008)
      =
      const PublicTag("ReviewerName", 0x300E0008, "Reviewer Name", VR.kPN, VM.k1, false);
  static const PublicTag kArbitrary
      //(4000,0010)
      = const PublicTag("Arbitrary", 0x40000010, "Arbitrary", VR.kLT, VM.k1, true);
  static const PublicTag kTextComments
      //(4000,4000)
      = const PublicTag("TextComments", 0x40004000, "Text Comments", VR.kLT, VM.k1, true);
  static const PublicTag kResultsID
      //(4008,0040)
      = const PublicTag("ResultsID", 0x40080040, "Results ID", VR.kSH, VM.k1, true);
  static const PublicTag kResultsIDIssuer
      //(4008,0042)
      = const PublicTag(
          "ResultsIDIssuer", 0x40080042, "Results ID Issuer", VR.kLO, VM.k1, true);
  static const PublicTag kReferencedInterpretationSequence
      //(4008,0050)
      = const PublicTag("ReferencedInterpretationSequence", 0x40080050,
          "Referenced Interpretation Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kReportProductionStatusTrial
      //(4008,00FF)
      = const PublicTag("ReportProductionStatusTrial", 0x400800FF,
          "Report Production Status (Trial)", VR.kCS, VM.k1, true);
  static const PublicTag kInterpretationRecordedDate
      //(4008,0100)
      = const PublicTag("InterpretationRecordedDate", 0x40080100,
          "Interpretation Recorded Date", VR.kDA, VM.k1, true);
  static const PublicTag kInterpretationRecordedTime
      //(4008,0101)
      = const PublicTag("InterpretationRecordedTime", 0x40080101,
          "Interpretation Recorded Time", VR.kTM, VM.k1, true);
  static const PublicTag kInterpretationRecorder
      //(4008,0102)
      = const PublicTag("InterpretationRecorder", 0x40080102, "Interpretation Recorder",
          VR.kPN, VM.k1, true);
  static const PublicTag kReferenceToRecordedSound
      //(4008,0103)
      = const PublicTag("ReferenceToRecordedSound", 0x40080103,
          "Reference to Recorded Sound", VR.kLO, VM.k1, true);
  static const PublicTag kInterpretationTranscriptionDate
      //(4008,0108)
      = const PublicTag("InterpretationTranscriptionDate", 0x40080108,
          "Interpretation Transcription Date", VR.kDA, VM.k1, true);
  static const PublicTag kInterpretationTranscriptionTime
      //(4008,0109)
      = const PublicTag("InterpretationTranscriptionTime", 0x40080109,
          "Interpretation Transcription Time", VR.kTM, VM.k1, true);
  static const PublicTag kInterpretationTranscriber
      //(4008,010A)
      = const PublicTag("InterpretationTranscriber", 0x4008010A,
          "Interpretation Transcriber", VR.kPN, VM.k1, true);
  static const PublicTag kInterpretationText
      //(4008,010B)
      = const PublicTag(
          "InterpretationText", 0x4008010B, "Interpretation Text", VR.kST, VM.k1, true);
  static const PublicTag kInterpretationAuthor
      //(4008,010C)
      = const PublicTag("InterpretationAuthor", 0x4008010C, "Interpretation Author",
          VR.kPN, VM.k1, true);
  static const PublicTag kInterpretationApproverSequence
      //(4008,0111)
      = const PublicTag("InterpretationApproverSequence", 0x40080111,
          "Interpretation Approver Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kInterpretationApprovalDate
      //(4008,0112)
      = const PublicTag("InterpretationApprovalDate", 0x40080112,
          "Interpretation Approval Date", VR.kDA, VM.k1, true);
  static const PublicTag kInterpretationApprovalTime
      //(4008,0113)
      = const PublicTag("InterpretationApprovalTime", 0x40080113,
          "Interpretation Approval Time", VR.kTM, VM.k1, true);
  static const PublicTag kPhysicianApprovingInterpretation
      //(4008,0114)
      = const PublicTag("PhysicianApprovingInterpretation", 0x40080114,
          "Physician Approving Interpretation", VR.kPN, VM.k1, true);
  static const PublicTag kInterpretationDiagnosisDescription
      //(4008,0115)
      = const PublicTag("InterpretationDiagnosisDescription", 0x40080115,
          "Interpretation Diagnosis Description", VR.kLT, VM.k1, true);
  static const PublicTag kInterpretationDiagnosisCodeSequence
      //(4008,0117)
      = const PublicTag("InterpretationDiagnosisCodeSequence", 0x40080117,
          "Interpretation Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kResultsDistributionListSequence
      //(4008,0118)
      = const PublicTag("ResultsDistributionListSequence", 0x40080118,
          "Results Distribution List Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kDistributionName
      //(4008,0119)
      = const PublicTag(
          "DistributionName", 0x40080119, "Distribution Name", VR.kPN, VM.k1, true);
  static const PublicTag kDistributionAddress
      //(4008,011A)
      = const PublicTag(
          "DistributionAddress", 0x4008011A, "Distribution Address", VR.kLO, VM.k1, true);
  static const PublicTag kInterpretationID
      //(4008,0200)
      = const PublicTag(
          "InterpretationID", 0x40080200, "Interpretation ID", VR.kSH, VM.k1, true);
  static const PublicTag kInterpretationIDIssuer
      //(4008,0202)
      = const PublicTag("InterpretationIDIssuer", 0x40080202, "Interpretation ID Issuer",
          VR.kLO, VM.k1, true);
  static const PublicTag kInterpretationTypeID
      //(4008,0210)
      = const PublicTag("InterpretationTypeID", 0x40080210, "Interpretation Type ID",
          VR.kCS, VM.k1, true);
  static const PublicTag kInterpretationStatusID
      //(4008,0212)
      = const PublicTag("InterpretationStatusID", 0x40080212, "Interpretation Status ID",
          VR.kCS, VM.k1, true);
  static const PublicTag kImpressions
      //(4008,0300)
      = const PublicTag("Impressions", 0x40080300, "Impressions", VR.kST, VM.k1, true);
  static const PublicTag kResultsComments
      //(4008,4000)
      = const PublicTag(
          "ResultsComments", 0x40084000, "Results Comments", VR.kST, VM.k1, true);
  static const PublicTag kLowEnergyDetectors
      //(4010,0001)
      = const PublicTag(
          "LowEnergyDetectors", 0x40100001, "Low Energy Detectors", VR.kCS, VM.k1, false);
  static const PublicTag kHighEnergyDetectors
      //(4010,0002)
      = const PublicTag("HighEnergyDetectors", 0x40100002, "High Energy Detectors",
          VR.kCS, VM.k1, false);
  static const PublicTag kDetectorGeometrySequence
      //(4010,0004)
      = const PublicTag("DetectorGeometrySequence", 0x40100004,
          "Detector Geometry Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kThreatROIVoxelSequence
      //(4010,1001)
      = const PublicTag("ThreatROIVoxelSequence", 0x40101001, "Threat ROI Voxel Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kThreatROIBase
      //(4010,1004)
      = const PublicTag(
          "ThreatROIBase", 0x40101004, "Threat ROI Base", VR.kFL, VM.k3, false);
  static const PublicTag kThreatROIExtents
      //(4010,1005)
      = const PublicTag(
          "ThreatROIExtents", 0x40101005, "Threat ROI Extents", VR.kFL, VM.k3, false);
  static const PublicTag kThreatROIBitmap
      //(4010,1006)
      = const PublicTag(
          "ThreatROIBitmap", 0x40101006, "Threat ROI Bitmap", VR.kOB, VM.k1, false);
  static const PublicTag kRouteSegmentID
      //(4010,1007)
      = const PublicTag(
          "RouteSegmentID", 0x40101007, "Route Segment ID", VR.kSH, VM.k1, false);
  static const PublicTag kGantryType
      //(4010,1008)
      = const PublicTag("GantryType", 0x40101008, "Gantry Type", VR.kCS, VM.k1, false);
  static const PublicTag kOOIOwnerType
      //(4010,1009)
      =
      const PublicTag("OOIOwnerType", 0x40101009, "OOI Owner Type", VR.kCS, VM.k1, false);
  static const PublicTag kRouteSegmentSequence
      //(4010,100A)
      = const PublicTag("RouteSegmentSequence", 0x4010100A, "Route Segment Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kPotentialThreatObjectID
      //(4010,1010)
      = const PublicTag("PotentialThreatObjectID", 0x40101010,
          "Potential Threat Object ID", VR.kUS, VM.k1, false);
  static const PublicTag kThreatSequence
      //(4010,1011)
      = const PublicTag(
          "ThreatSequence", 0x40101011, "Threat Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kThreatCategory
      //(4010,1012)
      = const PublicTag(
          "ThreatCategory", 0x40101012, "Threat Category", VR.kCS, VM.k1, false);
  static const PublicTag kThreatCategoryDescription
      //(4010,1013)
      = const PublicTag("ThreatCategoryDescription", 0x40101013,
          "Threat Category Description", VR.kLT, VM.k1, false);
  static const PublicTag kATDAbilityAssessment
      //(4010,1014)
      = const PublicTag("ATDAbilityAssessment", 0x40101014, "ATD Ability Assessment",
          VR.kCS, VM.k1, false);
  static const PublicTag kATDAssessmentFlag
      //(4010,1015)
      = const PublicTag(
          "ATDAssessmentFlag", 0x40101015, "ATD Assessment Flag", VR.kCS, VM.k1, false);
  static const PublicTag kATDAssessmentProbability
      //(4010,1016)
      = const PublicTag("ATDAssessmentProbability", 0x40101016,
          "ATD Assessment Probability", VR.kFL, VM.k1, false);
  static const PublicTag kMass
      //(4010,1017)
      = const PublicTag("Mass", 0x40101017, "Mass", VR.kFL, VM.k1, false);
  static const PublicTag kDensity
      //(4010,1018)
      = const PublicTag("Density", 0x40101018, "Density", VR.kFL, VM.k1, false);
  static const PublicTag kZEffective
      //(4010,1019)
      = const PublicTag("ZEffective", 0x40101019, "Z Effective", VR.kFL, VM.k1, false);
  static const PublicTag kBoardingPassID
      //(4010,101A)
      = const PublicTag(
          "BoardingPassID", 0x4010101A, "Boarding Pass ID", VR.kSH, VM.k1, false);
  static const PublicTag kCenterOfMass
      //(4010,101B)
      =
      const PublicTag("CenterOfMass", 0x4010101B, "Center of Mass", VR.kFL, VM.k3, false);
  static const PublicTag kCenterOfPTO
      //(4010,101C)
      = const PublicTag("CenterOfPTO", 0x4010101C, "Center of PTO", VR.kFL, VM.k3, false);
  static const PublicTag kBoundingPolygon
      //(4010,101D)
      = const PublicTag(
          "BoundingPolygon", 0x4010101D, "Bounding Polygon", VR.kFL, VM.k6_n, false);
  static const PublicTag kRouteSegmentStartLocationID
      //(4010,101E)
      = const PublicTag("RouteSegmentStartLocationID", 0x4010101E,
          "Route Segment Start Location ID", VR.kSH, VM.k1, false);
  static const PublicTag kRouteSegmentEndLocationID
      //(4010,101F)
      = const PublicTag("RouteSegmentEndLocationID", 0x4010101F,
          "Route Segment End Location ID", VR.kSH, VM.k1, false);
  static const PublicTag kRouteSegmentLocationIDType
      //(4010,1020)
      = const PublicTag("RouteSegmentLocationIDType", 0x40101020,
          "Route Segment Location ID Type", VR.kCS, VM.k1, false);
  static const PublicTag kAbortReason
      //(4010,1021)
      =
      const PublicTag("AbortReason", 0x40101021, "Abort Reason", VR.kCS, VM.k1_n, false);
  static const PublicTag kVolumeOfPTO
      //(4010,1023)
      = const PublicTag("VolumeOfPTO", 0x40101023, "Volume of PTO", VR.kFL, VM.k1, false);
  static const PublicTag kAbortFlag
      //(4010,1024)
      = const PublicTag("AbortFlag", 0x40101024, "Abort Flag", VR.kCS, VM.k1, false);
  static const PublicTag kRouteSegmentStartTime
      //(4010,1025)
      = const PublicTag("RouteSegmentStartTime", 0x40101025, "Route Segment Start Time",
          VR.kDT, VM.k1, false);
  static const PublicTag kRouteSegmentEndTime
      //(4010,1026)
      = const PublicTag("RouteSegmentEndTime", 0x40101026, "Route Segment End Time",
          VR.kDT, VM.k1, false);
  static const PublicTag kTDRType
      //(4010,1027)
      = const PublicTag("TDRType", 0x40101027, "TDR Type", VR.kCS, VM.k1, false);
  static const PublicTag kInternationalRouteSegment
      //(4010,1028)
      = const PublicTag("InternationalRouteSegment", 0x40101028,
          "International Route Segment", VR.kCS, VM.k1, false);
  static const PublicTag kThreatDetectionAlgorithmandVersion
      //(4010,1029)
      = const PublicTag("ThreatDetectionAlgorithmandVersion", 0x40101029,
          "Threat Detection Algorithm and Version", VR.kLO, VM.k1_n, false);
  static const PublicTag kAssignedLocation
      //(4010,102A)
      = const PublicTag(
          "AssignedLocation", 0x4010102A, "Assigned Location", VR.kSH, VM.k1, false);
  static const PublicTag kAlarmDecisionTime
      //(4010,102B)
      = const PublicTag(
          "AlarmDecisionTime", 0x4010102B, "Alarm Decision Time", VR.kDT, VM.k1, false);
  static const PublicTag kAlarmDecision
      //(4010,1031)
      = const PublicTag(
          "AlarmDecision", 0x40101031, "Alarm Decision", VR.kCS, VM.k1, false);
  static const PublicTag kNumberOfTotalObjects
      //(4010,1033)
      = const PublicTag("NumberOfTotalObjects", 0x40101033, "Number of Total Objects",
          VR.kUS, VM.k1, false);
  static const PublicTag kNumberOfAlarmObjects
      //(4010,1034)
      = const PublicTag("NumberOfAlarmObjects", 0x40101034, "Number of Alarm Objects",
          VR.kUS, VM.k1, false);
  static const PublicTag kPTORepresentationSequence
      //(4010,1037)
      = const PublicTag("PTORepresentationSequence", 0x40101037,
          "PTO Representation Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kATDAssessmentSequence
      //(4010,1038)
      = const PublicTag("ATDAssessmentSequence", 0x40101038, "ATD Assessment Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTIPType
      //(4010,1039)
      = const PublicTag("TIPType", 0x40101039, "TIP Type", VR.kCS, VM.k1, false);
  static const PublicTag kDICOSVersion
      //(4010,103A)
      =
      const PublicTag("DICOSVersion", 0x4010103A, "DICOS Version", VR.kCS, VM.k1, false);
  static const PublicTag kOOIOwnerCreationTime
      //(4010,1041)
      = const PublicTag("OOIOwnerCreationTime", 0x40101041, "OOI Owner Creation Time",
          VR.kDT, VM.k1, false);
  static const PublicTag kOOIType
      //(4010,1042)
      = const PublicTag("OOIType", 0x40101042, "OOI Type", VR.kCS, VM.k1, false);
  static const PublicTag kOOISize
      //(4010,1043)
      = const PublicTag("OOISize", 0x40101043, "OOI Size", VR.kFL, VM.k3, false);
  static const PublicTag kAcquisitionStatus
      //(4010,1044)
      = const PublicTag(
          "AcquisitionStatus", 0x40101044, "Acquisition Status", VR.kCS, VM.k1, false);
  static const PublicTag kBasisMaterialsCodeSequence
      //(4010,1045)
      = const PublicTag("BasisMaterialsCodeSequence", 0x40101045,
          "Basis Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPhantomType
      //(4010,1046)
      = const PublicTag("PhantomType", 0x40101046, "Phantom Type", VR.kCS, VM.k1, false);
  static const PublicTag kOOIOwnerSequence
      //(4010,1047)
      = const PublicTag(
          "OOIOwnerSequence", 0x40101047, "OOI Owner Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kScanType
      //(4010,1048)
      = const PublicTag("ScanType", 0x40101048, "Scan Type", VR.kCS, VM.k1, false);
  static const PublicTag kItineraryID
      //(4010,1051)
      = const PublicTag("ItineraryID", 0x40101051, "Itinerary ID", VR.kLO, VM.k1, false);
  static const PublicTag kItineraryIDType
      //(4010,1052)
      = const PublicTag(
          "ItineraryIDType", 0x40101052, "Itinerary ID Type", VR.kSH, VM.k1, false);
  static const PublicTag kItineraryIDAssigningAuthority
      //(4010,1053)
      = const PublicTag("ItineraryIDAssigningAuthority", 0x40101053,
          "Itinerary ID Assigning Authority", VR.kLO, VM.k1, false);
  static const PublicTag kRouteID
      //(4010,1054)
      = const PublicTag("RouteID", 0x40101054, "Route ID", VR.kSH, VM.k1, false);
  static const PublicTag kRouteIDAssigningAuthority
      //(4010,1055)
      = const PublicTag("RouteIDAssigningAuthority", 0x40101055,
          "Route ID Assigning Authority", VR.kSH, VM.k1, false);
  static const PublicTag kInboundArrivalType
      //(4010,1056)
      = const PublicTag(
          "InboundArrivalType", 0x40101056, "Inbound Arrival Type", VR.kCS, VM.k1, false);
  static const PublicTag kCarrierID
      //(4010,1058)
      = const PublicTag("CarrierID", 0x40101058, "Carrier ID", VR.kSH, VM.k1, false);
  static const PublicTag kCarrierIDAssigningAuthority
      //(4010,1059)
      = const PublicTag("CarrierIDAssigningAuthority", 0x40101059,
          "Carrier ID Assigning Authority", VR.kCS, VM.k1, false);
  static const PublicTag kSourceOrientation
      //(4010,1060)
      = const PublicTag(
          "SourceOrientation", 0x40101060, "Source Orientation", VR.kFL, VM.k3, false);
  static const PublicTag kSourcePosition
      //(4010,1061)
      = const PublicTag(
          "SourcePosition", 0x40101061, "Source Position", VR.kFL, VM.k3, false);
  static const PublicTag kBeltHeight
      //(4010,1062)
      = const PublicTag("BeltHeight", 0x40101062, "Belt Height", VR.kFL, VM.k1, false);
  static const PublicTag kAlgorithmRoutingCodeSequence
      //(4010,1064)
      = const PublicTag("AlgorithmRoutingCodeSequence", 0x40101064,
          "Algorithm Routing Code Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kTransportClassification
      //(4010,1067)
      = const PublicTag("TransportClassification", 0x40101067, "Transport Classification",
          VR.kCS, VM.k1, false);
  static const PublicTag kOOITypeDescriptor
      //(4010,1068)
      = const PublicTag(
          "OOITypeDescriptor", 0x40101068, "OOI Type Descriptor", VR.kLT, VM.k1, false);
  static const PublicTag kTotalProcessingTime
      //(4010,1069)
      = const PublicTag("TotalProcessingTime", 0x40101069, "Total Processing Time",
          VR.kFL, VM.k1, false);
  static const PublicTag kDetectorCalibrationData
      //(4010,106C)
      = const PublicTag("DetectorCalibrationData", 0x4010106C,
          "Detector Calibration Data", VR.kOB, VM.k1, false);
  static const PublicTag kAdditionalScreeningPerformed
      //(4010,106D)
      = const PublicTag("AdditionalScreeningPerformed", 0x4010106D,
          "Additional Screening Performed", VR.kCS, VM.k1, false);
  static const PublicTag kAdditionalInspectionSelectionCriteria
      //(4010,106E)
      = const PublicTag("AdditionalInspectionSelectionCriteria", 0x4010106E,
          "Additional Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const PublicTag kAdditionalInspectionMethodSequence
      //(4010,106F)
      = const PublicTag("AdditionalInspectionMethodSequence", 0x4010106F,
          "Additional Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAITDeviceType
      //(4010,1070)
      = const PublicTag(
          "AITDeviceType", 0x40101070, "AIT Device Type", VR.kCS, VM.k1, false);
  static const PublicTag kQRMeasurementsSequence
      //(4010,1071)
      = const PublicTag("QRMeasurementsSequence", 0x40101071, "QR Measurements Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kTargetMaterialSequence
      //(4010,1072)
      = const PublicTag("TargetMaterialSequence", 0x40101072, "Target Material Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kSNRThreshold
      //(4010,1073)
      =
      const PublicTag("SNRThreshold", 0x40101073, "SNR Threshold", VR.kFD, VM.k1, false);
  static const PublicTag kImageScaleRepresentation
      //(4010,1075)
      = const PublicTag("ImageScaleRepresentation", 0x40101075,
          "Image Scale Representation", VR.kDS, VM.k1, false);
  static const PublicTag kReferencedPTOSequence
      //(4010,1076)
      = const PublicTag("ReferencedPTOSequence", 0x40101076, "Referenced PTO Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kReferencedTDRInstanceSequence
      //(4010,1077)
      = const PublicTag("ReferencedTDRInstanceSequence", 0x40101077,
          "Referenced TDR Instance Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPTOLocationDescription
      //(4010,1078)
      = const PublicTag("PTOLocationDescription", 0x40101078, "PTO Location Description",
          VR.kST, VM.k1, false);
  static const PublicTag kAnomalyLocatorIndicatorSequence
      //(4010,1079)
      = const PublicTag("AnomalyLocatorIndicatorSequence", 0x40101079,
          "Anomaly Locator Indicator Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kAnomalyLocatorIndicator
      //(4010,107A)
      = const PublicTag("AnomalyLocatorIndicator", 0x4010107A,
          "Anomaly Locator Indicator", VR.kFL, VM.k3, false);
  static const PublicTag kPTORegionSequence
      //(4010,107B)
      = const PublicTag(
          "PTORegionSequence", 0x4010107B, "PTO Region Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kInspectionSelectionCriteria
      //(4010,107C)
      = const PublicTag("InspectionSelectionCriteria", 0x4010107C,
          "Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const PublicTag kSecondaryInspectionMethodSequence
      //(4010,107D)
      = const PublicTag("SecondaryInspectionMethodSequence", 0x4010107D,
          "Secondary Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPRCSToRCSOrientation
      //(4010,107E)
      = const PublicTag("PRCSToRCSOrientation", 0x4010107E, "PRCS to RCS Orientation",
          VR.kDS, VM.k6, false);
  static const PublicTag kMACParametersSequence
      //(4FFE,0001)
      = const PublicTag("MACParametersSequence", 0x4FFE0001, "MAC Parameters Sequence",
          VR.kSQ, VM.k1, false);
  static const PublicTag kCurveDimensions
      //(5000,0005)
      = const PublicTag(
          "CurveDimensions", 0x50000005, "Curve Dimensions", VR.kUS, VM.k1, true);
  static const PublicTag kNumberOfPoints
      //(5000,0010)
      = const PublicTag(
          "NumberOfPoints", 0x50000010, "Number of Points", VR.kUS, VM.k1, true);
  static const PublicTag kTypeOfData
      //(5000,0020)
      = const PublicTag("TypeOfData", 0x50000020, "Type of Data", VR.kCS, VM.k1, true);
  static const PublicTag kCurveDescription
      //(5000,0022)
      = const PublicTag(
          "CurveDescription", 0x50000022, "Curve Description", VR.kLO, VM.k1, true);
  static const PublicTag kAxisUnits
      //(5000,0030)
      = const PublicTag("AxisUnits", 0x50000030, "Axis Units", VR.kSH, VM.k1_n, true);
  static const PublicTag kAxisLabels
      //(5000,0040)
      = const PublicTag("AxisLabels", 0x50000040, "Axis Labels", VR.kSH, VM.k1_n, true);
  static const PublicTag kDataValueRepresentation
      //(5000,0103)
      = const PublicTag("DataValueRepresentation", 0x50000103,
          "Data Value Representation", VR.kUS, VM.k1, true);
  static const PublicTag kMinimumCoordinateValue
      //(5000,0104)
      = const PublicTag("MinimumCoordinateValue", 0x50000104, "Minimum Coordinate Value",
          VR.kUS, VM.k1_n, true);
  static const PublicTag kMaximumCoordinateValue
      //(5000,0105)
      = const PublicTag("MaximumCoordinateValue", 0x50000105, "Maximum Coordinate Value",
          VR.kUS, VM.k1_n, true);
  static const PublicTag kCurveRange
      //(5000,0106)
      = const PublicTag("CurveRange", 0x50000106, "Curve Range", VR.kSH, VM.k1_n, true);
  static const PublicTag kCurveDataDescriptor
      //(5000,0110)
      = const PublicTag("CurveDataDescriptor", 0x50000110, "Curve Data Descriptor",
          VR.kUS, VM.k1_n, true);
  static const PublicTag kCoordinateStartValue
      //(5000,0112)
      = const PublicTag("CoordinateStartValue", 0x50000112, "Coordinate Start Value",
          VR.kUS, VM.k1_n, true);
  static const PublicTag kCoordinateStepValue
      //(5000,0114)
      = const PublicTag("CoordinateStepValue", 0x50000114, "Coordinate Step Value",
          VR.kUS, VM.k1_n, true);
  static const PublicTag kCurveActivationLayer
      //(5000,1001)
      = const PublicTag("CurveActivationLayer", 0x50001001, "Curve Activation Layer",
          VR.kCS, VM.k1, true);
  static const PublicTag kAudioType
      //(5000,2000)
      = const PublicTag("AudioType", 0x50002000, "Audio Type", VR.kUS, VM.k1, true);
  static const PublicTag kAudioSampleFormat
      //(5000,2002)
      = const PublicTag(
          "AudioSampleFormat", 0x50002002, "Audio Sample Format", VR.kUS, VM.k1, true);
  static const PublicTag kNumberOfChannels
      //(5000,2004)
      = const PublicTag(
          "NumberOfChannels", 0x50002004, "Number of Channels", VR.kUS, VM.k1, true);
  static const PublicTag kNumberOfSamples
      //(5000,2006)
      = const PublicTag(
          "NumberOfSamples", 0x50002006, "Number of Samples", VR.kUL, VM.k1, true);
  static const PublicTag kSampleRate
      //(5000,2008)
      = const PublicTag("SampleRate", 0x50002008, "Sample Rate", VR.kUL, VM.k1, true);
  static const PublicTag kTotalTime
      //(5000,200A)
      = const PublicTag("TotalTime", 0x5000200A, "Total Time", VR.kUL, VM.k1, true);
  static const PublicTag kAudioSampleData
      //(5000,200C)
      = const PublicTag(
          "AudioSampleData", 0x5000200C, "Audio Sample Data", VR.kOBOW, VM.k1, true);
  static const PublicTag kAudioComments
      //(5000,200E)
      =
      const PublicTag("AudioComments", 0x5000200E, "Audio Comments", VR.kLT, VM.k1, true);
  static const PublicTag kCurveLabel
      //(5000,2500)
      = const PublicTag("CurveLabel", 0x50002500, "Curve Label", VR.kLO, VM.k1, true);
  static const PublicTag kCurveReferencedOverlaySequence
      //(5000,2600)
      = const PublicTag("CurveReferencedOverlaySequence", 0x50002600,
          "Curve Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const PublicTag kCurveReferencedOverlayGroup
      //(5000,2610)
      = const PublicTag("CurveReferencedOverlayGroup", 0x50002610,
          "Curve Referenced Overlay Group", VR.kUS, VM.k1, true);
  static const PublicTag kCurveData
      //(5000,3000)
      = const PublicTag("CurveData", 0x50003000, "Curve Data", VR.kOBOW, VM.k1, true);
  static const PublicTag kSharedFunctionalGroupsSequence
      //(5200,9229)
      = const PublicTag("SharedFunctionalGroupsSequence", 0x52009229,
          "Shared Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kPerFrameFunctionalGroupsSequence
      //(5200,9230)
      = const PublicTag("PerFrameFunctionalGroupsSequence", 0x52009230,
          "Per-frame Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kWaveformSequence
      //(5400,0100)
      = const PublicTag(
          "WaveformSequence", 0x54000100, "Waveform Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kChannelMinimumValue
      //(5400,0110)
      = const PublicTag("ChannelMinimumValue", 0x54000110, "Channel Minimum Value",
          VR.kOBOW, VM.k1, false);
  static const PublicTag kChannelMaximumValue
      //(5400,0112)
      = const PublicTag("ChannelMaximumValue", 0x54000112, "Channel Maximum Value",
          VR.kOBOW, VM.k1, false);
  static const PublicTag kWaveformBitsAllocated
      //(5400,1004)
      = const PublicTag("WaveformBitsAllocated", 0x54001004, "Waveform Bits Allocated",
          VR.kUS, VM.k1, false);
  static const PublicTag kWaveformSampleInterpretation
      //(5400,1006)
      = const PublicTag("WaveformSampleInterpretation", 0x54001006,
          "Waveform Sample Interpretation", VR.kCS, VM.k1, false);
  static const PublicTag kWaveformPaddingValue
      //(5400,100A)
      = const PublicTag("WaveformPaddingValue", 0x5400100A, "Waveform Padding Value",
          VR.kOBOW, VM.k1, false);
  static const PublicTag kWaveformData
      //(5400,1010)
      = const PublicTag(
          "WaveformData", 0x54001010, "Waveform Data", VR.kOBOW, VM.k1, false);
  static const PublicTag kFirstOrderPhaseCorrectionAngle
      //(5600,0010)
      = const PublicTag("FirstOrderPhaseCorrectionAngle", 0x56000010,
          "First Order Phase Correction Angle", VR.kOF, VM.k1, false);
  static const PublicTag kSpectroscopyData
      //(5600,0020)
      = const PublicTag(
          "SpectroscopyData", 0x56000020, "Spectroscopy Data", VR.kOF, VM.k1, false);
  static const PublicTag kOverlayRows
      //(6000,0010)
      = const PublicTag("OverlayRows", 0x60000010, "Overlay Rows", VR.kUS, VM.k1, false);
  static const PublicTag kOverlayColumns
      //(6000,0011)
      = const PublicTag(
          "OverlayColumns", 0x60000011, "Overlay Columns", VR.kUS, VM.k1, false);
  static const PublicTag kOverlayPlanes
      //(6000,0012)
      =
      const PublicTag("OverlayPlanes", 0x60000012, "Overlay Planes", VR.kUS, VM.k1, true);
  static const PublicTag kNumberOfFramesInOverlay
      //(6000,0015)
      = const PublicTag("NumberOfFramesInOverlay", 0x60000015,
          "Number of Frames in Overlay", VR.kIS, VM.k1, false);
  static const PublicTag kOverlayDescription
      //(6000,0022)
      = const PublicTag(
          "OverlayDescription", 0x60000022, "Overlay Description", VR.kLO, VM.k1, false);
  static const PublicTag kOverlayType
      //(6000,0040)
      = const PublicTag("OverlayType", 0x60000040, "Overlay Type", VR.kCS, VM.k1, false);
  static const PublicTag kOverlaySubtype
      //(6000,0045)
      = const PublicTag(
          "OverlaySubtype", 0x60000045, "Overlay Subtype", VR.kLO, VM.k1, false);
  static const PublicTag kOverlayOrigin
      //(6000,0050)
      = const PublicTag(
          "OverlayOrigin", 0x60000050, "Overlay Origin", VR.kSS, VM.k2, false);
  static const PublicTag kImageFrameOrigin
      //(6000,0051)
      = const PublicTag(
          "ImageFrameOrigin", 0x60000051, "Image Frame Origin", VR.kUS, VM.k1, false);
  static const PublicTag kOverlayPlaneOrigin
      //(6000,0052)
      = const PublicTag(
          "OverlayPlaneOrigin", 0x60000052, "Overlay Plane Origin", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayCompressionCode
      //(6000,0060)
      = const PublicTag("OverlayCompressionCode", 0x60000060, "Overlay Compression Code",
          VR.kCS, VM.k1, true);
  static const PublicTag kOverlayCompressionOriginator
      //(6000,0061)
      = const PublicTag("OverlayCompressionOriginator", 0x60000061,
          "Overlay Compression Originator", VR.kSH, VM.k1, true);
  static const PublicTag kOverlayCompressionLabel
      //(6000,0062)
      = const PublicTag("OverlayCompressionLabel", 0x60000062,
          "Overlay Compression Label", VR.kSH, VM.k1, true);
  static const PublicTag kOverlayCompressionDescription
      //(6000,0063)
      = const PublicTag("OverlayCompressionDescription", 0x60000063,
          "Overlay Compression Description", VR.kCS, VM.k1, true);
  static const PublicTag kOverlayCompressionStepPointers
      //(6000,0066)
      = const PublicTag("OverlayCompressionStepPointers", 0x60000066,
          "Overlay Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const PublicTag kOverlayRepeatInterval
      //(6000,0068)
      = const PublicTag("OverlayRepeatInterval", 0x60000068, "Overlay Repeat Interval",
          VR.kUS, VM.k1, true);
  static const PublicTag kOverlayBitsGrouped
      //(6000,0069)
      = const PublicTag(
          "OverlayBitsGrouped", 0x60000069, "Overlay Bits Grouped", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayBitsAllocated
      //(6000,0100)
      = const PublicTag("OverlayBitsAllocated", 0x60000100, "Overlay Bits Allocated",
          VR.kUS, VM.k1, false);
  static const PublicTag kOverlayBitPosition
      //(6000,0102)
      = const PublicTag(
          "OverlayBitPosition", 0x60000102, "Overlay Bit Position", VR.kUS, VM.k1, false);
  static const PublicTag kOverlayFormat
      //(6000,0110)
      =
      const PublicTag("OverlayFormat", 0x60000110, "Overlay Format", VR.kCS, VM.k1, true);
  static const PublicTag kOverlayLocation
      //(6000,0200)
      = const PublicTag(
          "OverlayLocation", 0x60000200, "Overlay Location", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayCodeLabel
      //(6000,0800)
      = const PublicTag(
          "OverlayCodeLabel", 0x60000800, "Overlay Code Label", VR.kCS, VM.k1_n, true);
  static const PublicTag kOverlayNumberOfTables
      //(6000,0802)
      = const PublicTag("OverlayNumberOfTables", 0x60000802, "Overlay Number of Tables",
          VR.kUS, VM.k1, true);
  static const PublicTag kOverlayCodeTableLocation
      //(6000,0803)
      = const PublicTag("OverlayCodeTableLocation", 0x60000803,
          "Overlay Code Table Location", VR.kAT, VM.k1_n, true);
  static const PublicTag kOverlayBitsForCodeWord
      //(6000,0804)
      = const PublicTag("OverlayBitsForCodeWord", 0x60000804,
          "Overlay Bits For Code Word", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayActivationLayer
      //(6000,1001)
      = const PublicTag("OverlayActivationLayer", 0x60001001, "Overlay Activation Layer",
          VR.kCS, VM.k1, false);
  static const PublicTag kOverlayDescriptorGray
      //(6000,1100)
      = const PublicTag("OverlayDescriptorGray", 0x60001100, "Overlay Descriptor - Gray",
          VR.kUS, VM.k1, true);
  static const PublicTag kOverlayDescriptorRed
      //(6000,1101)
      = const PublicTag("OverlayDescriptorRed", 0x60001101, "Overlay Descriptor - Red",
          VR.kUS, VM.k1, true);
  static const PublicTag kOverlayDescriptorGreen
      //(6000,1102)
      = const PublicTag("OverlayDescriptorGreen", 0x60001102,
          "Overlay Descriptor - Green", VR.kUS, VM.k1, true);
  static const PublicTag kOverlayDescriptorBlue
      //(6000,1103)
      = const PublicTag("OverlayDescriptorBlue", 0x60001103, "Overlay Descriptor - Blue",
          VR.kUS, VM.k1, true);
  static const PublicTag kOverlaysGray
      //(6000,1200)
      = const PublicTag(
          "OverlaysGray", 0x60001200, "Overlays - Gray", VR.kUS, VM.k1_n, true);
  static const PublicTag kOverlaysRed
      //(6000,1201)
      =
      const PublicTag("OverlaysRed", 0x60001201, "Overlays - Red", VR.kUS, VM.k1_n, true);
  static const PublicTag kOverlaysGreen
      //(6000,1202)
      = const PublicTag(
          "OverlaysGreen", 0x60001202, "Overlays - Green", VR.kUS, VM.k1_n, true);
  static const PublicTag kOverlaysBlue
      //(6000,1203)
      = const PublicTag(
          "OverlaysBlue", 0x60001203, "Overlays - Blue", VR.kUS, VM.k1_n, true);
  static const PublicTag kROIArea
      //(6000,1301)
      = const PublicTag("ROIArea", 0x60001301, "ROI Area", VR.kIS, VM.k1, false);
  static const PublicTag kROIMean
      //(6000,1302)
      = const PublicTag("ROIMean", 0x60001302, "ROI Mean", VR.kDS, VM.k1, false);
  static const PublicTag kROIStandardDeviation
      //(6000,1303)
      = const PublicTag("ROIStandardDeviation", 0x60001303, "ROI Standard Deviation",
          VR.kDS, VM.k1, false);
  static const PublicTag kOverlayLabel
      //(6000,1500)
      =
      const PublicTag("OverlayLabel", 0x60001500, "Overlay Label", VR.kLO, VM.k1, false);
  static const PublicTag kOverlayData
      //(6000,3000)
      =
      const PublicTag("OverlayData", 0x60003000, "Overlay Data", VR.kOBOW, VM.k1, false);
  static const PublicTag kOverlayComments
      //(6000,4000)
      = const PublicTag(
          "OverlayComments", 0x60004000, "Overlay Comments", VR.kLT, VM.k1, true);
  static const PublicTag kFloatPixelData = const PublicTag(
      "FloatPixelData", 0x7FE00008, "Float Pixel Data", VR.kOF, VM.k1, false);
  static const PublicTag kDoubleFloatPixelData = const PublicTag("DoubleFloatPixelData",
      0x7FE00009, "Double Float Pixel Data", VR.kOD, VM.k1, false);
  static const PublicTag kPixelData =
      const PublicTag("PixelData", 0x7FE00010, "Pixel Data", VR.kOBOW, VM.k1, false);
  static const PublicTag kCoefficientsSDVN
      //(7FE0,0020)
      = const PublicTag(
          "CoefficientsSDVN", 0x7FE00020, "Coefficients SDVN", VR.kOW, VM.k1, true);
  static const PublicTag kCoefficientsSDHN
      //(7FE0,0030)
      = const PublicTag(
          "CoefficientsSDHN", 0x7FE00030, "Coefficients SDHN", VR.kOW, VM.k1, true);
  static const PublicTag kCoefficientsSDDN
      //(7FE0,0040)
      = const PublicTag(
          "CoefficientsSDDN", 0x7FE00040, "Coefficients SDDN", VR.kOW, VM.k1, true);
  static const PublicTag kVariablePixelData
      //(7F00,0010)
      = const PublicTag(
          "VariablePixelData", 0x7F000010, "Variable Pixel Data", VR.kOBOW, VM.k1, true);
  static const PublicTag kVariableNextDataGroup
      //(7F00,0011)
      = const PublicTag("VariableNextDataGroup", 0x7F000011, "Variable Next Data Group",
          VR.kUS, VM.k1, true);
  static const PublicTag kVariableCoefficientsSDVN
      //(7F00,0020)
      = const PublicTag("VariableCoefficientsSDVN", 0x7F000020,
          "Variable Coefficients SDVN", VR.kOW, VM.k1, true);
  static const PublicTag kVariableCoefficientsSDHN
      //(7F00,0030)
      = const PublicTag("VariableCoefficientsSDHN", 0x7F000030,
          "Variable Coefficients SDHN", VR.kOW, VM.k1, true);
  static const PublicTag kVariableCoefficientsSDDN
      //(7F00,0040)
      = const PublicTag("VariableCoefficientsSDDN", 0x7F000040,
          "Variable Coefficients SDDN", VR.kOW, VM.k1, true);
  static const PublicTag kDigitalSignaturesSequence
      //(FFFA,FFFA)
      = const PublicTag("DigitalSignaturesSequence", 0xFFFAFFFA,
          "Digital Signatures Sequence", VR.kSQ, VM.k1, false);
  static const PublicTag kDataSetTrailingPadding
      //(FFFC,FFFC)
      = const PublicTag("DataSetTrailingPadding", 0xFFFCFFFC, "Data Set Trailing Padding",
          VR.kOB, VM.k1, false);
  static const PublicTag kItem
      //(FFFE,E000)
      = const PublicTag("Item", 0xFFFEE000, "Item", VR.kUnknown, VM.kNoVM, false);
  static const PublicTag kItemDelimitationItem
      //(FFFE,E00D)
      = const PublicTag("ItemDelimitationItem", 0xFFFEE00D, "Item Delimitation Item",
          VR.kUnknown, VM.kNoVM, false);
  static const PublicTag kSequenceDelimitationItem
      //(FFFE,E0DD)
      = const PublicTag("SequenceDelimitationItem", 0xFFFEE0DD,
          "Sequence Delimitation Item", VR.kUnknown, VM.kNoVM, false);

  //**** Special Elements where multiple tags map to the same dictionary

  //(0028,04X0)
  static const PublicTag kRowsForNthOrderCoefficients = const PublicTag(
      "RowsForNthOrderCoefficients",
      0x002804F0,
      "Rows For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,04X1)
  static const PublicTag kColumnsForNthOrderCoefficients = const PublicTag(
      "ColumnsForNthOrderCoefficients",
      0x00280401,
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,0402)
  static const PublicTag kCoefficientCoding = const PublicTag(
      "CoefficientCoding", 0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);

  //(0028,0403)
  static const PublicTag kCoefficientCodingPointers = const PublicTag(
      "CoefficientCodingPointers",
      0x00280403,
      "Coefficient Coding Pointers",
      VR.kAT,
      VM.k1_n,
      true);

  static const List<PublicTag> fmiTags = const <PublicTag>[
    kFileMetaInformationGroupLength,
    kFileMetaInformationVersion,
    kMediaStorageSOPClassUID,
    kMediaStorageSOPInstanceUID,
    kTransferSyntaxUID,
    kImplementationClassUID,
    kImplementationVersionName,
    kSourceApplicationEntityTitle,
    kSendingApplicationEntityTitle,
    kReceivingApplicationEntityTitle,
    kPrivateInformationCreatorUID,
    kPrivateInformation
  ];
}

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name