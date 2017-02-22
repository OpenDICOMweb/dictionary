// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:dictionary/src/constants.dart';
import 'package:dictionary/src/tag/constants.dart';
import 'package:dictionary/src/tag/e_type.dart';
import 'package:dictionary/src/tag/elt.dart';
import 'package:dictionary/src/tag/errors.dart';
import 'package:dictionary/src/tag/group.dart';
import 'package:dictionary/src/tag/private_creator_tag.dart';
import 'package:dictionary/src/tag/private_data_tag.dart';
import 'package:dictionary/src/tag/public_tag_code_map.dart';
import 'package:dictionary/src/tag/public_tag_keyword_map.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

bool throwOnError = true;

//TODO: is hashCode needed?
class Tag {
  final int code;
  final VR vr;
  final VM vm;
  final EType type;
  final String keyword;
  final String name;
  final bool isRetired;

  ///TODO: Tag and Tag.public are inconsistent when new Tag, PrivateTag... files
  ///      are generated make them consistent.
  const Tag(this.code,
      [this.vr = VR.kUN,
      this.vm = VM.k1_n,
      this.type = EType.kUnknown,
      this.keyword = "Unknown",
      this.name = "Unknown",
      this.isRetired = false]);

  const Tag.public(this.keyword, this.code, this.name, this.vr, this.vm,
      [this.isRetired = false, this.type = EType.kUnknown]);

  const Tag.privateData(this.code, this.vr, this.vm, this.name,
      [this.type = EType.kUnknown,
      this.keyword = "Unknown",
      this.isRetired = false]);

  bool get isWKFmi => fmiTags.contains(code);

  // **** Code Getters
  String get dcm => '(${Int.hex(group, 4, "")},${Int.hex(elt, 4, "")})';
  String get hex => Int.hex(code, 8);

  int get group => Group.check(code >> 16);
  String get groupHex => Group.hex(group);

  int get elt => code & kElementMask;
  String get eltHex => Elt.hex(elt);

  // **** VR Getters

  int get vrIndex => vr.index;
  @deprecated
  int get sizeInBytes => elementSize;

  int get elementSize => vr.elementSize;
  @deprecated
  bool get isShort => hasShortVF;

  bool get hasShortVF => vr.hasShortVF;
  bool get hasLongVF => vr.hasLongVF;

  // **** VM Getters

  int get minLength => vm.min;

  //TODO: Validate that the number of values is legal
  //TODO write unit tests to ensure this is correct
  //TODO: make this work for PrivateTags
  /// Returns the maximum number of values allowed for this [Tag].
  int get maxLength {
    if (vm.max == -1) {
      int max = (vr.hasShortVF) ? kMaxShortVFLength : kMaxLongVFLength;
      return max ~/ vr.elementSize;
    }
    return vm.max;
  }

  int get width => vm.width;

  int codeGroup(int code) => code >> 16;
  int codeElt(int code) => code & 0xFFFF;
  bool codeGroupIsPrivate(int code) {
    int g = codeGroup(code);
    return g.isOdd && (g > 0x0008 && g < 0xFFFE);
  }

  int get hashcode => code;

  /// Returns true if the Tag is defined by DICOM, false otherwise.
  /// All DICOM Public tags have group numbers that are even integers.
  /// Note: This only checks that the group number is an even.
  bool get isPublic => group.isEven;

  bool get isPrivate => Group.isPrivate(group);

  bool get isCreator => false;

  //bool get isPrivateCreator => false;
  bool get isPrivateData => false;

  int get fmiMin => kMinFmiTag;
  int get fmiMax => kMaxFmiTag;

  /// Returns [true] if the [group] is in the File Meta Information group.
  bool get isFmiGroup => group == 0x0002;

  /// Returns [true] if [code] is in the range of File Meta Information
  /// [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get inFmiRange => kMinFmiTag <= code && code <= kMaxFmiTag;

  int get dcmDirMin => kMinDcmDirTag;
  int get dcmDirMax => kMaxDcmDirTag;

  /// Returns [true] if [code] is in the range of DICOM Directory [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get isDcmDir => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  /// Returns [true] if [code] is in the range of DICOM Directory
  /// [Tag] [code]s.
  ///
  /// Note: Does not test tag validity.
  bool get inDcmDirRange => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  String get info {
    String retired = (isRetired) ? '- Retired' : '';
    return '$runtimeType$dcm $vr $vm $keyword $retired';
  }

  //TODO: Use the 'package:collection/collection.dart' ListEquality
  //TODO:  decide if this ahould be here
  /// Compares the elements of two [List]s and returns [true] if all
  /// elements are equal; otherwise, returns [false].
  /// Note: this is not recursive!
  static bool listEquals<E>(List<E> e1, List<E> e2) {
    if (identical(e1, e2)) return true;
    if (e1 == null || e2 == null) return false;
    if (e1.length != e2.length) return false;
    for (int i = 0; i < e1.length; i++) if (e1[i] != e2[i]) return false;
    return true;
  }

  /// Returns True if the [length], i.e. the number of values, is
  /// valid for this [Tag].
  ///
  /// Note: A [length] of zero is always valid.
  ///
  /// [min]: The minimum number of values.
  /// [max]: The maximum number of values. If -1 then max length of
  ///     Value Field; otherwise, must be greater than or equal to [min].
  /// [width]: The [width] of the matrix of values. If [width == 0,
  /// then singleton; otherwise must be greater than 0;

  //TODO: should be modified when EType info is available.
  bool isValidValues<E>(List<E> values) {
    // Urgent: this is very slow - needs to be fixed, maybe add field to VM.
    // Note: If VR is any of the following the length and
    // values are valid by definition
    if (vr != VR.kSQ ||
        vr != VR.kOB ||
        vr != VR.kOD ||
        vr != VR.kOF ||
        vr != VR.kOL ||
        vr != VR.kOW ||
        vr != VR.kUR ||
        vr != VR.kUN) return true;
    if (isNotValidLength(values.length)) return false;
    for (int i = 0; i < values.length; i++)
      if (vr.isNotValidValue(values[i])) return false;
    return true;
  }

  List<E> parseList<E>(List<String> sList) {
    print('parseList: $sList');
    if (isNotValidLength(sList.length)) return null;
    List<E> values = new List<E>(sList.length);
    for (int i = 0; i < values.length; i++) {
      print('sList[$i]: ${sList[i]}');
      E v = vr.parse(sList[i]);
      print('v: $v');
      if (v == null) return null;
      values[i] = v;
    }
    return values;
  }

  List<E>
      checkValues<E>(List<E> values) => (isValidValues(values)) ? values : null;

  // Placeholder until VR is integrated into TagBase
  List<E> checkValue<E>(dynamic value) => vr.isValidValue(value) ? value : null;

  bool isValidLength(int length) {
    print('isValidLength: $length');
    print('min($minLength), max($maxLength), width($width)');
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return true;
    return length % width == 0 && (minLength <= length && length <= maxLength);
  }

  bool isValidWidth(int length) => (length % width) == 0;

  bool isNotValidLength(int length) => !isValidLength(length);

  int checkLength(int length) => (isValidLength(length)) ? length : null;

  //Flush?
  String widthError(int length) => 'Invalid Width for Tag$dcm}: '
      'values length($length) is not a multiple of vmWidth($width)';

  //Flush?
  String lengthError(int length) =>
      'Invalid Length: min($minLength) <= length($length) <= max($maxLength)';

  bool isValidVFLength(int lengthInBytes) {
    int min = minLength * vr.minValueLength;
    int max = maxLength * vr.maxValueLength;
    if (min <= lengthInBytes && lengthInBytes <= max) return true;
    return false;
  }

  Uint8List checkVFLength(Uint8List bytes) =>
      (isValidVFLength(bytes.length)) ? bytes : null;

  //Fix or Flush
  Uint8List checkBytes(Uint8List bytes) => vr.checkBytes(bytes);

  E parse<E>(String s) => vr.parse(s);

  /// Converts a DICOM [keyword] to the equivalent DICOM name.
  ///
  /// Given a keyword in camelCase, returns a [String] with a
  /// space (' ') inserted before each uppercase letter.
  ///
  /// Note: This algorithm does not return the exact DICOM name string,
  /// for example some names have apostrophes ("'") in them,
  /// but they are not in the [keyword]. Also, all dashes ('-') in
  /// keywords have been converted to underscores ('_'), because
  /// dashes are illegal in Dart identifiers.
  String keywordToName(String keyword) {
    List<int> kw = keyword.codeUnits;
    List<int> name = new List<int>();
    name[0] = kw[0];
    for (int i = 0; i < kw.length; i++) {
      int char = kw[i];
      if (isUppercaseChar(char)) name.add(kSpace);
      name.add(char);
    }
    return UTF8.decode(name);
  }

  String stringToKeyword(String s) {
    s = s.replaceAll(' ', '_');
    s = s.replaceAll('-', '_');
    s = s.replaceAll('.', '_');
    return s;
  }

  @override
  String toString() {
    String retired = (isRetired == false) ? "" : ", (Retired)";
    return '$runtimeType: $dcm $keyword, $vr, $vm, $retired';
  }

/*
  static Tag lookup(int code, [VR vr = VR.kUN]) {
    Tag tag = Tag.lookupCode(code);
    if (tag != null) return tag;
    if (Tag.isPublicCode(code)) {
      return new Tag.public(
          "Unknown", code, "Unknown Public Tag", vr, VM.kUnknown);
    } else if (Tag.isPrivateCode(code)) {
      // *** This should not happen!
      if (Tag.isPrivateCreatorCode(code))
        return new PrivateCreatorTag.unknown("Unknown Creator", code, vr);
    }
    // This should never happen
    throw 'Error: Unknown Tag Code${Tag.toDcm}';
  }
*/
  static List<String> lengthChecker(
      List values, int minLength, int maxLength, int width) {
    int length = values.length;
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return null;
    List<String> msgs;
    if (length % width != 0)
      msgs = ['Invalid Length($length) not a multiple of vmWidth($width)'];
    if (length < minLength) {
      var msg = 'Invalid Length($length) less than minLength($minLength)';
      msgs = msgs ??= [];
      msgs.add(msg);
    }
    if (length > maxLength) {
      var msg = 'Invalid Length($length) greater than maxLength($maxLength)';
      msgs = msgs ??= [];
      msgs.add(msg); //TODO: test Not sure this is working
    }
    return (msgs == null) ? null : msgs;
  }

  // *** Private Tag Code methods
  static bool isPrivateCode(int tagCode) =>
      Group.isPrivate(Group.fromTag(tagCode));

  static bool isPublicCode(int tagCode) =>
      Group.isPublic(Group.fromTag(tagCode));

  /// Returns true if [code] is a valid Private Creator Code.
  static bool isPrivateCreatorCode(int tagCode) =>
      isPrivateCode(tagCode) && Elt.isPrivateCreator(Elt.fromTag(tagCode));

  static bool isPrivateDataCode(int tag) =>
      Group.isPrivate(Group.fromTag(tag)) &&
      Elt.isPrivateData(Elt.fromTag(tag));

  static int privateCreatorBase(int code) => Elt.pcBase(Elt.fromTag(code));

  static int privateCreatorLimit(int code) => Elt.pcLimit(Elt.fromTag(code));

  /// Returns true if [pd] is a valid Private Data Code for the
  /// [pc] the Private Creator Code.
  ///
  /// If the [PrivateCreatorTag ]is present, verifies that [pd] and [pc]
  /// have the same [group], and that [pd] has a valid [Elt].
  static bool isValidPrivateDataTag(int pd, int pc) {
    int pdg = Group.checkPrivate(Group.fromTag(pd));
    int pcg = Group.checkPrivate(Group.fromTag(pc));
    if (pdg == null || pcg == null || pdg != pcg) return false;
    return Elt.isValidPrivateData(Elt.fromTag(pd), Elt.fromTag(pc));
  }

  //**** Private Tag Code "Constructors" ****
  static bool isPCIndex(int pcIndex) => 0x0010 <= pcIndex && pcIndex <= 0x00FF;

  /// Returns a valid [PrivateCreatorTag], or [null].
  static int toPrivateCreator(int group, int pcIndex) {
    if (Group.isPrivate(group) && _isPCIndex(pcIndex))
      return _toPrivateCreator(group, pcIndex);
    return null;
  }

  /// Returns a valid [PrivateDataTag], or [null].
  static int toPrivateData(int group, int pcIndex, int pdIndex) {
    if (Group.isPrivate(group) &&
        _isPCIndex(pcIndex) &&
        _isPDIndex(pcIndex, pdIndex))
      return _toPrivateData(group, pcIndex, pcIndex);
    return null;
  }

  /// Returns a [PrivateCreatorTag], without checking arguments.
  static int _toPrivateCreator(int group, int pcIndex) =>
      (group << 16) + pcIndex;

  /// Returns a [PrivateDataTag], without checking arguments.
  static int _toPrivateData(int group, int pcIndex, int pdIndex) =>
      (group << 16) + (pcIndex << 8) + pdIndex;

  // **** Private Tag Code Internal Utility functions ****

  /// Return [true] if [pdCode] is a valid Private Creator Index.
  static bool _isPCIndex(int pdCode) => 0x10 <= pdCode && pdCode <= 0xFF;

  // Returns [true] if [pde] in a valid Private Data Index
  //static bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

  /// Return [true] if [pdi] is a valid Private Data Index.
  static bool _isPDIndex(int pci, int pdi) =>
      _pdBase(pci) <= pdi && pdi <= _pdLimit(pci);

  /// Returns the offset base for a Private Data Element with the
  /// Private Creator [pcIndex].
  static int _pdBase(int pcIndex) => pcIndex << 8;

  /// Returns the limit for a [PrivateDataTag] with a base of [pdBase].
  static int _pdLimit(int pdBase) => pdBase + 0x00FF;

  /// Returns [true] if [tag] is in the range of DICOM [Dataset] Tags.
  /// Note: Does not test tag validity.
  static bool inDatasetRange(int tag) =>
      (kMinDatasetTag <= tag) && (tag <= kMaxDatasetTag);

  static void checkDatasetRange(int tag) {
    if (!inDatasetRange(tag)) rangeError(tag, kMinDatasetTag, kMaxDatasetTag);
  }

  /// Returns [code] in DICOM format '(gggg,eeee)'.
  static String toHex(int code) => Int32.hex(code);

  /// Returns [code] in DICOM format '(gggg,eeee)'.
  static String toDcm(int code) => '(${Group.hex(Group.fromTag(code), "")}, '
      '${Elt.hex(Elt.fromTag(code), "")})';

  /// Returns a [List] of DICOM tag codes in '(gggg,eeee)' format
  static Iterable<String> listToDcm(List<int> tags) => tags.map(toDcm);

  /// Takes a [String] in format "(gggg,eeee)" and returns [int].
  static int toInt(String s) {
    String tmp = s.substring(1, 5) + s.substring(6, 10);
    return int.parse(tmp, radix: 16);
  }

  static bool rangeError(int tag, int min, int max) {
    String msg = 'invalid tag: $tag not in $min <= x <= $max';
    throw new RangeError(msg);
  }

  //TODO: this should become public when fully converted to Tags.
  static Tag lookupPublicCode(int code, [bool shouldThrow = true]) {
    assert(Tag.isPublicCode(code));
    Tag tag = publicTagCodeMap[code];
    if (tag != null) return tag;

    // **** Retired _special case_ codes that still must be handled
    if ((code >= 0x00283100) && (code <= 0x002031FF))
      return Tag.kSourceImageIDs;
    if ((code >= 0x00280410) && (code <= 0x002804F0))
      return Tag.kRowsForNthOrderCoefficients;
    if ((code >= 0x00280411) && (code <= 0x002804F1))
      return Tag.kColumnsForNthOrderCoefficients;
    if ((code >= 0x00280412) && (code <= 0x002804F2))
      return Tag.kCoefficientCoding;
    if ((code >= 0x00280413) && (code <= 0x002804F3))
      return Tag.kCoefficientCodingPointers;
    if ((code >= 0x00280810) && (code <= 0x002808F0)) return Tag.kCodeLabel;
    if ((code >= 0x00280812) && (code <= 0x002808F2))
      return Tag.kNumberOfTables;
    if ((code >= 0x00280813) && (code <= 0x002808F3))
      return Tag.kCodeTableLocation;
    if ((code >= 0x00280814) && (code <= 0x002808F4))
      return Tag.kBitsForCodeWord;
    if ((code >= 0x00280818) && (code <= 0x002808F8))
      return Tag.kImageDataLocation;

    //**** (1000,xxxy ****
    // (1000,04X2)
    if ((code >= 0x10000000) && (code <= 0x1000FFF0)) return Tag.kEscapeTriplet;
    // (1000,04X3)
    if ((code >= 0x10000001) && (code <= 0x1000FFF1))
      return Tag.kRunLengthTriplet;
    // (1000,08x0)
    if ((code >= 0x10000002) && (code <= 0x1000FFF2))
      return Tag.kHuffmanTableSize;
    // (1000,08x2)
    if ((code >= 0x10000003) && (code <= 0x1000FFF3))
      return Tag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((code >= 0x10000004) && (code <= 0x1000FFF4))
      return Tag.kShiftTableSize;
    // (1000,08x4)
    if ((code >= 0x10000005) && (code <= 0x1000FFF5))
      return Tag.kShiftTableTriplet;
    // (1000,08x8)
    if ((code >= 0x10100000) && (code <= 0x1010FFFF)) return Tag.kZonalMap;

    //Urgent: 0x50xx,yyyy Elements
    //Urgent: 0x60xx,yyyy Elements
    //Urgent: 0x7Fxx,yyyy Elements

    // No match return [null]
    return tagCodeError(code);
  }

  //TODO: make keyword lookup work
  /// Currently can only be used to lookup Public [Tag]s as Private [Tag]s
  /// don't have [keyword]s.
  static Tag lookupKeyword(String keyword, [bool shouldThrow = true]) {
    Tag tag = publicTagKeywordMap[keyword];
    if (tag != null) return tag;

    // Retired _special case_ keywords that still must be handled
    /* TODO: figure out what to do with this? remove?
    // (0020,31xx)
    if ((keyword >= 0x00283100) && (keyword <= 0x002031FF))
    return Tag.kSourceImageIDs;

    // (0028,04X0)
    if ((keyword >= 0x00280410) && (keyword <= 0x002804F0))
      return Tag.kRowsForNthOrderCoefficients;
    // (0028,04X1)
    if ((keyword >= 0x00280411) && (keyword <= 0x002804F1))
      return Tag.kColumnsForNthOrderCoefficients;
    // (0028,04X2)
    if ((keyword >= 0x00280412) && (keyword <= 0x002804F2))
    return Tag.kCoefficientCoding;
    // (0028,04X3)
    if ((keyword >= 0x00280413) && (keyword <= 0x002804F3))
      return Tag.kCoefficientCodingPointers;

    // (0028,08x0)
    if ((keyword >= 0x00280810) && (keyword <= 0x002808F0))
    return Tag.kCodeLabel;
    // (0028,08x2)
    if ((keyword >= 0x00280812) && (keyword <= 0x002808F2))
    return Tag.kNumberOfTables;
    // (0028,08x3)
    if ((keyword >= 0x00280813) && (keyword <= 0x002808F3))
    return Tag.kCodeTableLocation;
    // (0028,08x4)
    if ((keyword >= 0x00280814) && (keyword <= 0x002808F4))
    return Tag.kBitsForCodeWord;
    // (0028,08x8)
    if ((keyword >= 0x00280818) && (keyword <= 0x002808F8))
    return Tag.kImageDataLocation;

    // **** (1000,xxxy ****
    // (1000,04X2)
    if ((keyword >= 0x10000000) && (keyword <= 0x1000FFF0))
    return Tag.kEscapeTriplet;
    // (1000,04X3)
    if ((keyword >= 0x10000001) && (keyword <= 0x1000FFF1))
    return Tag.kRunLengthTriplet;
    // (1000,08x0)
    if ((keyword >= 0x10000002) && (keyword <= 0x1000FFF2))
    return Tag.kHuffmanTableSize;
    // (1000,08x2)
    if ((keyword >= 0x10000003) && (keyword <= 0x1000FFF3))
      return Tag.kHuffmanTableTriplet;
    // (1000,08x3)
    if ((keyword >= 0x10000004) && (keyword <= 0x1000FFF4))
    return Tag.kShiftTableSize;
    // (1000,08x4)
    if ((keyword >= 0x10000005) && (keyword <= 0x1000FFF5))
    return Tag.kShiftTableTriplet;
    // (1000,08x8)
    if ((keyword >= 0x10100000) && (keyword <= 0x1010FFFF))
    return Tag.kZonalMap;

    //TODO: 0x50xx,yyyy Elements
    //TODO: 0x60xx,yyyy Elements
    //TODO: 0x7Fxx,yyyy Elements
*/
    // No match return [null]
    return tagKeywordError(keyword);
  }

  //**** Message Data Elements begin here ****
  static const Tag kAffectedSOPInstanceUID = const Tag.public(
      "AffectedSOPInstanceUID",
      0x00001000,
      "Affected SOP Instance UID ",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kRequestedSOPInstanceUID = const Tag.public(
      "RequestedSOPInstanceUID",
      0x00001001,
      "Requested SOP Instance UID",
      VR.kUI,
      VM.k1,
      false);

  //**** File Meta Information Data Elements begin here ****
  static const Tag kFileMetaInformationGroupLength = const Tag.public(
      "FileMetaInformationGroupLength",
      0x00020000,
      "File Meta Information Group Length",
      VR.kUL,
      VM.k1,
      false);

  static const Tag kFileMetaInformationVersion = const Tag.public(
      "FileMetaInformationVersion",
      0x00020001,
      "File Meta Information Version",
      VR.kOB,
      VM.k1,
      false);

  static const Tag kMediaStorageSOPClassUID = const Tag.public(
      "MediaStorageSOPClassUID",
      0x00020002,
      "Media Storage SOP Class UID",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kMediaStorageSOPInstanceUID = const Tag.public(
      "MediaStorageSOPInstanceUID",
      0x00020003,
      "Media Storage SOP Instance UID",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kTransferSyntaxUID = const Tag.public("TransferSyntaxUID",
      0x00020010, "Transfer Syntax UID", VR.kUI, VM.k1, false);

  static const Tag kImplementationClassUID = const Tag.public(
      "ImplementationClassUID",
      0x00020012,
      "Implementation Class UID",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kImplementationVersionName = const Tag.public(
      "ImplementationVersionName",
      0x00020013,
      "Implementation Version Name",
      VR.kSH,
      VM.k1,
      false);

  static const Tag kSourceApplicationEntityTitle = const Tag.public(
      "SourceApplicationEntityTitle",
      0x00020016,
      "Source ApplicationEntity Title",
      VR.kAE,
      VM.k1,
      false);

  static const Tag kSendingApplicationEntityTitle = const Tag.public(
      "SendingApplicationEntityTitle",
      0x00020017,
      "Sending Application Entity Title",
      VR.kAE,
      VM.k1,
      false);

  static const Tag kReceivingApplicationEntityTitle = const Tag.public(
      "ReceivingApplicationEntityTitle",
      0x00020018,
      "Receiving Application Entity Title",
      VR.kAE,
      VM.k1,
      false);

  static const Tag kPrivateInformationCreatorUID = const Tag.public(
      "PrivateInformationCreatorUID",
      0x00020100,
      "Private Information Creator UID",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kPrivateInformation = const Tag.public("PrivateInformation",
      0x00020102, "Private Information", VR.kOB, VM.k1, false);

  //**** DICOM Directory Tags begin here ****
  static const Tag kFileSetID = const Tag.public(
      "FileSetID", 0x00041130, "File-set ID", VR.kCS, VM.k1, false);

  static const Tag kFileSetDescriptorFileID = const Tag.public(
      "FileSetDescriptorFileID",
      0x00041141,
      "File-set Descriptor File ID",
      VR.kCS,
      VM.k1_8,
      false);

  static const Tag kSpecificCharacterSetOfFileSetDescriptorFile =
      const Tag.public(
          "SpecificCharacterSetOfFileSetDescriptorFile",
          0x00041142,
          "Specific Character Set of File Set Descriptor File",
          VR.kCS,
          VM.k1,
          false);

  static const Tag kOffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity =
      const Tag.public(
          "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity",
          0x00041200,
          "Offset of the First Directory Record of the Root Directory Entity",
          VR.kUL,
          VM.k1,
          false);

  static const Tag kOffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity =
      const Tag.public(
          "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity",
          0x00041202,
          "Offset of the Last Directory Record of the Root Directory Entity",
          VR.kUL,
          VM.k1,
          false);

  static const Tag kFileSetConsistencyFlag = const Tag.public(
      "FileSetConsistencyFlag",
      0x00041212,
      "File-set Consistency Flag",
      VR.kUS,
      VM.k1,
      false);

  static const Tag kDirectoryRecordSequence = const Tag.public(
      "DirectoryRecordSequence",
      0x00041220,
      "Directory Record Sequence",
      VR.kSQ,
      VM.k1,
      false);

  static const Tag kOffsetOfTheNextDirectoryRecord = const Tag.public(
      "OffsetOfTheNextDirectoryRecord",
      0x00041400,
      "Offset of the Next Directory Record",
      VR.kUL,
      VM.k1,
      false);

  static const Tag kRecordInUseFlag = const Tag.public("RecordInUseFlag",
      0x00041410, "Record In-use Flag", VR.kUS, VM.k1, false);

  static const Tag kOffsetOfReferencedLowerLevelDirectoryEntity =
      const Tag.public(
          "OffsetOfReferencedLowerLevelDirectoryEntity",
          0x00041420,
          "Offset of Referenced Lower-Level Directory Entity",
          VR.kUL,
          VM.k1,
          false);

  static const Tag kDirectoryRecordType = const Tag.public(
      "DirectoryRecordType",
      0x00041430,
      "Directory​Record​Type",
      VR.kCS,
      VM.k1,
      false);

  static const Tag kPrivateRecordUID = const Tag.public("PrivateRecordUID",
      0x00041432, "Private Record UID", VR.kUI, VM.k1, false);

  static const Tag kReferencedFileID = const Tag.public("ReferencedFileID",
      0x00041500, "Referenced File ID", VR.kCS, VM.k1_8, false);

  static const Tag kMRDRDirectoryRecordOffset = const Tag.public(
      "MRDRDirectoryRecordOffset",
      0x00041504,
      "MRDR Directory Record Offset",
      VR.kUL,
      VM.k1,
      true);

  static const Tag kReferencedSOPClassUIDInFile = const Tag.public(
      "ReferencedSOPClassUIDInFile",
      0x00041510,
      "Referenced SOP Class UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kReferencedSOPInstanceUIDInFile = const Tag.public(
      "ReferencedSOPInstanceUIDInFile",
      0x00041511,
      "Referenced SOP Instance UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kReferencedTransferSyntaxUIDInFile = const Tag.public(
      "ReferencedTransferSyntaxUIDInFile",
      0x00041512,
      "Referenced Transfer Syntax UID in File",
      VR.kUI,
      VM.k1,
      false);

  static const Tag kReferencedRelatedGeneralSOPClassUIDInFile =
      const Tag.public(
          "ReferencedRelatedGeneralSOPClassUIDInFile",
          0x0004151a,
          "Referenced Related General SOP Class UID in File",
          VR.kUI,
          VM.k1_n,
          false);

  static const Tag kNumberOfReferences = const Tag.public("NumberOfReferences",
      0x00041600, "Number of References", VR.kUL, VM.k1, true);

  //**** Standard Dataset Tags begin here ****

  static const Tag kLengthToEnd
      //(0008,0001) "00080001"
      = const Tag.public(
          "LengthToEnd", 0x00080001, "Length to End", VR.kUL, VM.k1, true);
  static const Tag kSpecificCharacterSet
      //(0008,0005)
      = const Tag.public("SpecificCharacterSet", 0x00080005,
          "Specific Character Set", VR.kCS, VM.k1_n, false);
  static const Tag kLanguageCodeSequence
      //(0008,0006)
      = const Tag.public("LanguageCodeSequence", 0x00080006,
          "Language Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageType
      //(0008,0008)
      = const Tag.public(
          "ImageType", 0x00080008, "Image Type", VR.kCS, VM.k2_n, false);
  static const Tag kRecognitionCode
      //(0008,0010)
      = const Tag.public("RecognitionCode", 0x00080010, "Recognition Code",
          VR.kSH, VM.k1, true);
  static const Tag kInstanceCreationDate
      //(0008,0012)
      = const Tag.public("InstanceCreationDate", 0x00080012,
          "Instance Creation Date", VR.kDA, VM.k1, false);
  static const Tag kInstanceCreationTime
      //(0008,0013)
      = const Tag.public("InstanceCreationTime", 0x00080013,
          "Instance Creation Time", VR.kTM, VM.k1, false);
  static const Tag kInstanceCreatorUID
      //(0008,0014)
      = const Tag.public("InstanceCreatorUID", 0x00080014,
          "Instance Creator UID", VR.kUI, VM.k1, false);
  static const Tag kInstanceCoercionDateTime
      //(0008,0015)
      = const Tag.public("InstanceCoercionDateTime", 0x00080015,
          "Instance Coercion DateTime", VR.kDT, VM.k1, false);
  static const Tag kSOPClassUID
      //(0008,0016)
      = const Tag.public(
          "SOPClassUID", 0x00080016, "SOP Class UID", VR.kUI, VM.k1, false);
  static const Tag kSOPInstanceUID
      //(0008,0018)
      = const Tag.public("SOPInstanceUID", 0x00080018, "SOP Instance UID",
          VR.kUI, VM.k1, false);
  static const Tag kRelatedGeneralSOPClassUID
      //(0008,001A)
      = const Tag.public("RelatedGeneralSOPClassUID", 0x0008001A,
          "Related General SOP Class UID", VR.kUI, VM.k1_n, false);
  static const Tag kOriginalSpecializedSOPClassUID
      //(0008,001B)
      = const Tag.public("OriginalSpecializedSOPClassUID", 0x0008001B,
          "Original Specialized SOP Class UID", VR.kUI, VM.k1, false);
  static const Tag kStudyDate
      //(0008,0020)
      = const Tag.public(
          "StudyDate", 0x00080020, "Study Date", VR.kDA, VM.k1, false);
  static const Tag kSeriesDate
      //(0008,0021)
      = const Tag.public(
          "SeriesDate", 0x00080021, "Series Date", VR.kDA, VM.k1, false);
  static const Tag kAcquisitionDate
      //(0008,0022)
      = const Tag.public("AcquisitionDate", 0x00080022, "Acquisition Date",
          VR.kDA, VM.k1, false);
  static const Tag kContentDate
      //(0008,0023)
      = const Tag.public(
          "ContentDate", 0x00080023, "Content Date", VR.kDA, VM.k1, false);
  static const Tag kOverlayDate
      //(0008,0024)
      = const Tag.public(
          "OverlayDate", 0x00080024, "Overlay Date", VR.kDA, VM.k1, true);
  static const Tag kCurveDate
      //(0008,0025)
      = const Tag.public(
          "CurveDate", 0x00080025, "Curve Date", VR.kDA, VM.k1, true);
  static const Tag kAcquisitionDateTime
      //(0008,002A)
      = const Tag.public("AcquisitionDateTime", 0x0008002A,
          "Acquisition DateTime", VR.kDT, VM.k1, false);
  static const Tag kStudyTime
      //(0008,0030)
      = const Tag.public(
          "StudyTime", 0x00080030, "Study Time", VR.kTM, VM.k1, false);
  static const Tag kSeriesTime
      //(0008,0031)
      = const Tag.public(
          "SeriesTime", 0x00080031, "Series Time", VR.kTM, VM.k1, false);
  static const Tag kAcquisitionTime
      //(0008,0032)
      = const Tag.public("AcquisitionTime", 0x00080032, "Acquisition Time",
          VR.kTM, VM.k1, false);
  static const Tag kContentTime
      //(0008,0033)
      = const Tag.public(
          "ContentTime", 0x00080033, "Content Time", VR.kTM, VM.k1, false);
  static const Tag kOverlayTime
      //(0008,0034)
      = const Tag.public(
          "OverlayTime", 0x00080034, "Overlay Time", VR.kTM, VM.k1, true);
  static const Tag kCurveTime
      //(0008,0035)
      = const Tag.public(
          "CurveTime", 0x00080035, "Curve Time", VR.kTM, VM.k1, true);
  static const Tag kDataSetType
      //(0008,0040)
      = const Tag.public(
          "DataSetType", 0x00080040, "Data Set Type", VR.kUS, VM.k1, true);
  static const Tag kDataSetSubtype
      //(0008,0041)
      = const Tag.public("DataSetSubtype", 0x00080041, "Data Set Subtype",
          VR.kLO, VM.k1, true);
  static const Tag kNuclearMedicineSeriesType
      //(0008,0042)
      = const Tag.public("NuclearMedicineSeriesType", 0x00080042,
          "Nuclear Medicine Series Type", VR.kCS, VM.k1, true);
  static const Tag kAccessionNumber
      //(0008,0050)
      = const Tag.public("AccessionNumber", 0x00080050, "Accession Number",
          VR.kSH, VM.k1, false);
  static const Tag kIssuerOfAccessionNumberSequence
      //(0008,0051)
      = const Tag.public("IssuerOfAccessionNumberSequence", 0x00080051,
          "Issuer of Accession Number Sequence", VR.kSQ, VM.k1, false);
  static const Tag kQueryRetrieveLevel
      //(0008,0052)
      = const Tag.public("QueryRetrieveLevel", 0x00080052,
          "Query/Retrieve Level", VR.kCS, VM.k1, false);
  static const Tag kQueryRetrieveView
      //(0008,0053)
      = const Tag.public("QueryRetrieveView", 0x00080053, "Query/Retrieve View",
          VR.kCS, VM.k1, false);
  static const Tag kRetrieveAETitle
      //(0008,0054)
      = const Tag.public("RetrieveAETitle", 0x00080054, "Retrieve AE Title",
          VR.kAE, VM.k1_n, false);
  static const Tag kInstanceAvailability
      //(0008,0056)
      = const Tag.public("InstanceAvailability", 0x00080056,
          "Instance Availability", VR.kCS, VM.k1, false);
  static const Tag kFailedSOPInstanceUIDList
      //(0008,0058)
      = const Tag.public("FailedSOPInstanceUIDList", 0x00080058,
          "Failed SOP Instance UID List", VR.kUI, VM.k1_n, false);
  static const Tag kModality
      //(0008,0060)
      = const Tag.public(
          "Modality", 0x00080060, "Modality", VR.kCS, VM.k1, false);
  static const Tag kModalitiesInStudy
      //(0008,0061)
      = const Tag.public("ModalitiesInStudy", 0x00080061, "Modalities in Study",
          VR.kCS, VM.k1_n, false);
  static const Tag kSOPClassesInStudy
      //(0008,0062)
      = const Tag.public("SOPClassesInStudy", 0x00080062,
          "SOP Classes in Study", VR.kUI, VM.k1_n, false);
  static const Tag kConversionType
      //(0008,0064)
      = const Tag.public("ConversionType", 0x00080064, "Conversion Type",
          VR.kCS, VM.k1, false);
  static const Tag kPresentationIntentType
      //(0008,0068)
      = const Tag.public("PresentationIntentType", 0x00080068,
          "Presentation Intent Type", VR.kCS, VM.k1, false);
  static const Tag kManufacturer
      //(0008,0070)
      = const Tag.public(
          "Manufacturer", 0x00080070, "Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kInstitutionName
      //(0008,0080)
      = const Tag.public("InstitutionName", 0x00080080, "Institution Name",
          VR.kLO, VM.k1, false);
  static const Tag kInstitutionAddress
      //(0008,0081)
      = const Tag.public("InstitutionAddress", 0x00080081,
          "Institution Address", VR.kST, VM.k1, false);
  static const Tag kInstitutionCodeSequence
      //(0008,0082)
      = const Tag.public("InstitutionCodeSequence", 0x00080082,
          "Institution Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferringPhysicianName
      //(0008,0090)
      = const Tag.public("ReferringPhysicianName", 0x00080090,
          "Referring Physician's Name", VR.kPN, VM.k1, false);
  static const Tag kReferringPhysicianAddress
      //(0008,0092)
      = const Tag.public("ReferringPhysicianAddress", 0x00080092,
          "Referring Physician's Address", VR.kST, VM.k1, false);
  static const Tag kReferringPhysicianTelephoneNumbers
      //(0008,0094)
      = const Tag.public("ReferringPhysicianTelephoneNumbers", 0x00080094,
          "Referring Physician's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const Tag kReferringPhysicianIdentificationSequence
      //(0008,0096)
      = const Tag.public("ReferringPhysicianIdentificationSequence", 0x00080096,
          "Referring Physician Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCodeValue
      //(0008,0100)
      = const Tag.public(
          "CodeValue", 0x00080100, "Code Value", VR.kSH, VM.k1, false);
  static const Tag kExtendedCodeValue
      //(0008,0101)
      = const Tag.public("ExtendedCodeValue", 0x00080101, "Extended Code Value",
          VR.kLO, VM.k1, false);
  static const Tag kCodingSchemeDesignator
      //(0008,0102)
      = const Tag.public("CodingSchemeDesignator", 0x00080102,
          "Coding Scheme Designator", VR.kSH, VM.k1, false);
  static const Tag kCodingSchemeVersion
      //(0008,0103)
      = const Tag.public("CodingSchemeVersion", 0x00080103,
          "Coding Scheme Version", VR.kSH, VM.k1, false);
  static const Tag kCodeMeaning
      //(0008,0104)
      = const Tag.public(
          "CodeMeaning", 0x00080104, "Code Meaning", VR.kLO, VM.k1, false);
  static const Tag kMappingResource
      //(0008,0105)
      = const Tag.public("MappingResource", 0x00080105, "Mapping Resource",
          VR.kCS, VM.k1, false);
  static const Tag kContextGroupVersion
      //(0008,0106)
      = const Tag.public("ContextGroupVersion", 0x00080106,
          "Context Group Version", VR.kDT, VM.k1, false);
  static const Tag kContextGroupLocalVersion
      //(0008,0107)
      = const Tag.public("ContextGroupLocalVersion", 0x00080107,
          "Context Group Local Version", VR.kDT, VM.k1, false);
  static const Tag kExtendedCodeMeaning
      //(0008,0108)
      = const Tag.public("ExtendedCodeMeaning", 0x00080108,
          "Extended Code Meaning", VR.kLT, VM.k1, false);
  static const Tag kContextGroupExtensionFlag
      //(0008,010B)
      = const Tag.public("ContextGroupExtensionFlag", 0x0008010B,
          "Context Group Extension Flag", VR.kCS, VM.k1, false);
  static const Tag kCodingSchemeUID
      //(0008,010C)
      = const Tag.public("CodingSchemeUID", 0x0008010C, "Coding Scheme UID",
          VR.kUI, VM.k1, false);
  static const Tag kContextGroupExtensionCreatorUID
      //(0008,010D)
      = const Tag.public("ContextGroupExtensionCreatorUID", 0x0008010D,
          "Context Group Extension Creator UID", VR.kUI, VM.k1, false);
  static const Tag kContextIdentifier
      //(0008,010F)
      = const Tag.public("ContextIdentifier", 0x0008010F, "Context Identifier",
          VR.kCS, VM.k1, false);
  static const Tag kCodingSchemeIdentificationSequence
      //(0008,0110)
      = const Tag.public("CodingSchemeIdentificationSequence", 0x00080110,
          "Coding Scheme Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCodingSchemeRegistry
      //(0008,0112)
      = const Tag.public("CodingSchemeRegistry", 0x00080112,
          "Coding Scheme Registry", VR.kLO, VM.k1, false);
  static const Tag kCodingSchemeExternalID
      //(0008,0114)
      = const Tag.public("CodingSchemeExternalID", 0x00080114,
          "Coding Scheme External ID", VR.kST, VM.k1, false);
  static const Tag kCodingSchemeName
      //(0008,0115)
      = const Tag.public("CodingSchemeName", 0x00080115, "Coding Scheme Name",
          VR.kST, VM.k1, false);
  static const Tag kCodingSchemeResponsibleOrganization
      //(0008,0116)
      = const Tag.public("CodingSchemeResponsibleOrganization", 0x00080116,
          "Coding Scheme Responsible Organization", VR.kST, VM.k1, false);
  static const Tag kContextUID
      //(0008,0117)
      = const Tag.public(
          "ContextUID", 0x00080117, "Context UID", VR.kUI, VM.k1, false);
  static const Tag kTimezoneOffsetFromUTC
      //(0008,0201)
      = const Tag.public("TimezoneOffsetFromUTC", 0x00080201,
          "Timezone Offset From UTC", VR.kSH, VM.k1, false);

  static const Tag kPrivateDataElementCharacteristicsSequence =
      const Tag.public(
          "PrivateDataElementCharacteristicsSequence",
          0x0080300,
          "Private​Data​Element​Characteristics​Sequence",
          VR.kSQ,
          VM.k1,
          false);

  static const Tag kPrivateGroupReference = const Tag.public(
      "PrivateGroupReference",
      0x00080301,
      "Private Group Reference",
      VR.kUS,
      VM.k1,
      false);

  static const Tag kPrivateCreatorReference = const Tag.public(
      "PrivateCreatorReference",
      0x00080302,
      "Private Creator Reference",
      VR.kLO,
      VM.k1,
      false);

  static const Tag kBlockIdentifyingInformationStatus = const Tag.public(
      "BlockIdentifyingInformationStatus",
      0x00080303,
      "Block Identifying Information Status",
      VR.kCS,
      VM.k1,
      false);

  static const Tag kNonidentifyingPrivateElements = const Tag.public(
      "NonidentifyingPrivateElements",
      0x00080304,
      "Nonidentifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const Tag kDeidentificationActionSequence = const Tag.public(
      "DeidentificationActionSequence",
      0x00080305,
      "Deidentification Action Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const Tag kIdentifyingPrivateElements = const Tag.public(
      "IdentifyingPrivateElements",
      0x00080306,
      "Identifying Private Elements",
      VR.kUS,
      VM.k1_n,
      false);
  static const Tag kDeidentificationAction = const Tag.public(
      "DeidentificationAction",
      0x00080307,
      "Deidentification Action",
      VR.kCS,
      VM.k1,
      false);
  static const Tag kNetworkID
      //(0008,1000)
      = const Tag.public(
          "NetworkID", 0x00081000, "Network ID", VR.kAE, VM.k1, true);
  static const Tag kStationName
      //(0008,1010)
      = const Tag.public(
          "StationName", 0x00081010, "Station Name", VR.kSH, VM.k1, false);
  static const Tag kStudyDescription
      //(0008,1030)
      = const Tag.public("StudyDescription", 0x00081030, "Study Description",
          VR.kLO, VM.k1, false);
  static const Tag kProcedureCodeSequence
      //(0008,1032)
      = const Tag.public("ProcedureCodeSequence", 0x00081032,
          "Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSeriesDescription
      //(0008,103E)
      = const Tag.public("SeriesDescription", 0x0008103E, "Series Description",
          VR.kLO, VM.k1, false);
  static const Tag kSeriesDescriptionCodeSequence
      //(0008,103F)
      = const Tag.public("SeriesDescriptionCodeSequence", 0x0008103F,
          "Series Description Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kInstitutionalDepartmentName
      //(0008,1040)
      = const Tag.public("InstitutionalDepartmentName", 0x00081040,
          "Institutional Department Name", VR.kLO, VM.k1, false);
  static const Tag kPhysiciansOfRecord
      //(0008,1048)
      = const Tag.public("PhysiciansOfRecord", 0x00081048,
          "Physician(s) of Record", VR.kPN, VM.k1_n, false);
  static const Tag kPhysiciansOfRecordIdentificationSequence
      //(0008,1049)
      = const Tag.public(
          "PhysiciansOfRecordIdentificationSequence",
          0x00081049,
          "Physician(s) of Record Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kPerformingPhysicianName
      //(0008,1050)
      = const Tag.public("PerformingPhysicianName", 0x00081050,
          "Performing Physician's Name", VR.kPN, VM.k1_n, false);
  static const Tag kPerformingPhysicianIdentificationSequence
      //(0008,1052)
      = const Tag.public(
          "PerformingPhysicianIdentificationSequence",
          0x00081052,
          "Performing Physician Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kNameOfPhysiciansReadingStudy
      //(0008,1060)
      = const Tag.public("NameOfPhysiciansReadingStudy", 0x00081060,
          "Name of Physician(s) Reading Study", VR.kPN, VM.k1_n, false);
  static const Tag kPhysiciansReadingStudyIdentificationSequence
      //(0008,1062)
      = const Tag.public(
          "PhysiciansReadingStudyIdentificationSequence",
          0x00081062,
          "Physician(s) Reading Study Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOperatorsName
      //(0008,1070)
      = const Tag.public("OperatorsName", 0x00081070, "Operators' Name", VR.kPN,
          VM.k1_n, false);
  static const Tag kOperatorIdentificationSequence
      //(0008,1072)
      = const Tag.public("OperatorIdentificationSequence", 0x00081072,
          "Operator Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAdmittingDiagnosesDescription
      //(0008,1080)
      = const Tag.public("AdmittingDiagnosesDescription", 0x00081080,
          "Admitting Diagnoses Description", VR.kLO, VM.k1_n, false);
  static const Tag kAdmittingDiagnosesCodeSequence
      //(0008,1084)
      = const Tag.public("AdmittingDiagnosesCodeSequence", 0x00081084,
          "Admitting Diagnoses Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kManufacturerModelName
      //(0008,1090)
      = const Tag.public("ManufacturerModelName", 0x00081090,
          "Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const Tag kReferencedResultsSequence
      //(0008,1100)
      = const Tag.public("ReferencedResultsSequence", 0x00081100,
          "Referenced Results Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedStudySequence
      //(0008,1110)
      = const Tag.public("ReferencedStudySequence", 0x00081110,
          "Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedPerformedProcedureStepSequence
      //(0008,1111)
      = const Tag.public("ReferencedPerformedProcedureStepSequence", 0x00081111,
          "Referenced Performed Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSeriesSequence
      //(0008,1115)
      = const Tag.public("ReferencedSeriesSequence", 0x00081115,
          "Referenced Series Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedPatientSequence
      //(0008,1120)
      = const Tag.public("ReferencedPatientSequence", 0x00081120,
          "Referenced Patient Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedVisitSequence
      //(0008,1125)
      = const Tag.public("ReferencedVisitSequence", 0x00081125,
          "Referenced Visit Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedOverlaySequence
      //(0008,1130)
      = const Tag.public("ReferencedOverlaySequence", 0x00081130,
          "Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedStereometricInstanceSequence
      //(0008,1134)
      = const Tag.public("ReferencedStereometricInstanceSequence", 0x00081134,
          "Referenced Stereometric Instance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedWaveformSequence
      //(0008,113A)
      = const Tag.public("ReferencedWaveformSequence", 0x0008113A,
          "Referenced Waveform Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedImageSequence
      //(0008,1140)
      = const Tag.public("ReferencedImageSequence", 0x00081140,
          "Referenced Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedCurveSequence
      //(0008,1145)
      = const Tag.public("ReferencedCurveSequence", 0x00081145,
          "Referenced Curve Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedInstanceSequence
      //(0008,114A)
      = const Tag.public("ReferencedInstanceSequence", 0x0008114A,
          "Referenced Instance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedRealWorldValueMappingInstanceSequence
      //(0008,114B)
      = const Tag.public(
          "ReferencedRealWorldValueMappingInstanceSequence",
          0x0008114B,
          "Referenced Real World Value Mapping Instance Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReferencedSOPClassUID
      //(0008,1150)
      = const Tag.public("ReferencedSOPClassUID", 0x00081150,
          "Referenced SOP Class UID", VR.kUI, VM.k1, false);
  static const Tag kReferencedSOPInstanceUID
      //(0008,1155)
      = const Tag.public("ReferencedSOPInstanceUID", 0x00081155,
          "Referenced SOP Instance UID", VR.kUI, VM.k1, false);
  static const Tag kSOPClassesSupported
      //(0008,115A)
      = const Tag.public("SOPClassesSupported", 0x0008115A,
          "SOP Classes Supported", VR.kUI, VM.k1_n, false);
  static const Tag kReferencedFrameNumber
      //(0008,1160)
      = const Tag.public("ReferencedFrameNumber", 0x00081160,
          "Referenced Frame Number", VR.kIS, VM.k1_n, false);
  static const Tag kSimpleFrameList
      //(0008,1161)
      = const Tag.public("SimpleFrameList", 0x00081161, "Simple Frame List",
          VR.kUL, VM.k1_n, false);
  static const Tag kCalculatedFrameList
      //(0008,1162)
      = const Tag.public("CalculatedFrameList", 0x00081162,
          "Calculated Frame List", VR.kUL, VM.k3_3n, false);
  static const Tag kTimeRange
      //(0008,1163)
      = const Tag.public(
          "TimeRange", 0x00081163, "TimeRange", VR.kFD, VM.k2, false);
  static const Tag kFrameExtractionSequence
      //(0008,1164)
      = const Tag.public("FrameExtractionSequence", 0x00081164,
          "Frame Extraction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMultiFrameSourceSOPInstanceUID
      //(0008,1167)
      = const Tag.public("MultiFrameSourceSOPInstanceUID", 0x00081167,
          "Multi-frame Source SOP Instance UID", VR.kUI, VM.k1, false);
  static const Tag kRetrieveURL
      //(0008,1190)
      = const Tag.public(
          "RetrieveURL", 0x00081190, "Retrieve URL", VR.kUT, VM.k1, false);
  static const Tag kTransactionUID
      //(0008,1195)
      = const Tag.public("TransactionUID", 0x00081195, "Transaction UID",
          VR.kUI, VM.k1, false);
  static const Tag kWarningReason
      //(0008,1196)
      = const Tag.public(
          "WarningReason", 0x00081196, "Warning Reason", VR.kUS, VM.k1, false);
  static const Tag kFailureReason
      //(0008,1197)
      = const Tag.public(
          "FailureReason", 0x00081197, "Failure Reason", VR.kUS, VM.k1, false);
  static const Tag kFailedSOPSequence
      //(0008,1198)
      = const Tag.public("FailedSOPSequence", 0x00081198, "Failed SOP Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kReferencedSOPSequence
      //(0008,1199)
      = const Tag.public("ReferencedSOPSequence", 0x00081199,
          "Referenced SOP Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStudiesContainingOtherReferencedInstancesSequence
      //(0008,1200)
      = const Tag.public(
          "StudiesContainingOtherReferencedInstancesSequence",
          0x00081200,
          "Studies Containing Other Referenced Instances Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRelatedSeriesSequence
      //(0008,1250)
      = const Tag.public("RelatedSeriesSequence", 0x00081250,
          "Related Series Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLossyImageCompressionRetired
      //(0008,2110)
      = const Tag.public("LossyImageCompressionRetired", 0x00082110,
          "Lossy Image Compression (Retired)", VR.kCS, VM.k1, true);
  static const Tag kDerivationDescription
      //(0008,2111)
      = const Tag.public("DerivationDescription", 0x00082111,
          "Derivation Description", VR.kST, VM.k1, false);
  static const Tag kSourceImageSequence
      //(0008,2112)
      = const Tag.public("SourceImageSequence", 0x00082112,
          "Source Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStageName
      //(0008,2120)
      = const Tag.public(
          "StageName", 0x00082120, "Stage Name", VR.kSH, VM.k1, false);
  static const Tag kStageNumber
      //(0008,2122)
      = const Tag.public(
          "StageNumber", 0x00082122, "Stage Number", VR.kIS, VM.k1, false);
  static const Tag kNumberOfStages
      //(0008,2124)
      = const Tag.public("NumberOfStages", 0x00082124, "Number of Stages",
          VR.kIS, VM.k1, false);
  static const Tag kViewName
      //(0008,2127)
      = const Tag.public(
          "ViewName", 0x00082127, "View Name", VR.kSH, VM.k1, false);
  static const Tag kViewNumber
      //(0008,2128)
      = const Tag.public(
          "ViewNumber", 0x00082128, "View Number", VR.kIS, VM.k1, false);
  static const Tag kNumberOfEventTimers
      //(0008,2129)
      = const Tag.public("NumberOfEventTimers", 0x00082129,
          "Number of Event Timers", VR.kIS, VM.k1, false);
  static const Tag kNumberOfViewsInStage
      //(0008,212A)
      = const Tag.public("NumberOfViewsInStage", 0x0008212A,
          "Number of Views in Stage", VR.kIS, VM.k1, false);
  static const Tag kEventElapsedTimes
      //(0008,2130)
      = const Tag.public("EventElapsedTimes", 0x00082130,
          "Event Elapsed Time(s)", VR.kDS, VM.k1_n, false);
  static const Tag kEventTimerNames
      //(0008,2132)
      = const Tag.public("EventTimerNames", 0x00082132, "Event Timer Name(s)",
          VR.kLO, VM.k1_n, false);
  static const Tag kEventTimerSequence
      //(0008,2133)
      = const Tag.public("EventTimerSequence", 0x00082133,
          "Event Timer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEventTimeOffset
      //(0008,2134)
      = const Tag.public("EventTimeOffset", 0x00082134, "Event Time Offset",
          VR.kFD, VM.k1, false);
  static const Tag kEventCodeSequence
      //(0008,2135)
      = const Tag.public("EventCodeSequence", 0x00082135, "Event Code Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kStartTrim
      //(0008,2142)
      = const Tag.public(
          "StartTrim", 0x00082142, "Start Trim", VR.kIS, VM.k1, false);
  static const Tag kStopTrim
      //(0008,2143)
      = const Tag.public(
          "StopTrim", 0x00082143, "Stop Trim", VR.kIS, VM.k1, false);
  static const Tag kRecommendedDisplayFrameRate
      //(0008,2144)
      = const Tag.public("RecommendedDisplayFrameRate", 0x00082144,
          "Recommended Display Frame Rate", VR.kIS, VM.k1, false);
  static const Tag kTransducerPosition
      //(0008,2200)
      = const Tag.public("TransducerPosition", 0x00082200,
          "Transducer Position", VR.kCS, VM.k1, true);
  static const Tag kTransducerOrientation
      //(0008,2204)
      = const Tag.public("TransducerOrientation", 0x00082204,
          "Transducer Orientation", VR.kCS, VM.k1, true);
  static const Tag kAnatomicStructure
      //(0008,2208)
      = const Tag.public("AnatomicStructure", 0x00082208, "Anatomic Structure",
          VR.kCS, VM.k1, true);
  static const Tag kAnatomicRegionSequence
      //(0008,2218)
      = const Tag.public("AnatomicRegionSequence", 0x00082218,
          "Anatomic Region Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAnatomicRegionModifierSequence
      //(0008,2220)
      = const Tag.public("AnatomicRegionModifierSequence", 0x00082220,
          "Anatomic Region Modifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrimaryAnatomicStructureSequence
      //(0008,2228)
      = const Tag.public("PrimaryAnatomicStructureSequence", 0x00082228,
          "Primary Anatomic Structure Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAnatomicStructureSpaceOrRegionSequence
      //(0008,2229)
      = const Tag.public("AnatomicStructureSpaceOrRegionSequence", 0x00082229,
          "Anatomic Structure: Space or Region Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrimaryAnatomicStructureModifierSequence
      //(0008,2230)
      = const Tag.public("PrimaryAnatomicStructureModifierSequence", 0x00082230,
          "Primary Anatomic Structure Modifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransducerPositionSequence
      //(0008,2240)
      = const Tag.public("TransducerPositionSequence", 0x00082240,
          "Transducer Position Sequence", VR.kSQ, VM.k1, true);
  static const Tag kTransducerPositionModifierSequence
      //(0008,2242)
      = const Tag.public("TransducerPositionModifierSequence", 0x00082242,
          "Transducer Position Modifier Sequence", VR.kSQ, VM.k1, true);
  static const Tag kTransducerOrientationSequence
      //(0008,2244)
      = const Tag.public("TransducerOrientationSequence", 0x00082244,
          "Transducer Orientation Sequence", VR.kSQ, VM.k1, true);
  static const Tag kTransducerOrientationModifierSequence
      //(0008,2246)
      = const Tag.public("TransducerOrientationModifierSequence", 0x00082246,
          "Transducer Orientation Modifier Sequence", VR.kSQ, VM.k1, true);
  static const Tag kAnatomicStructureSpaceOrRegionCodeSequenceTrial
      //(0008,2251)
      = const Tag.public(
          "AnatomicStructureSpaceOrRegionCodeSequenceTrial",
          0x00082251,
          "Anatomic Structure Space Or Region Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAnatomicPortalOfEntranceCodeSequenceTrial
      //(0008,2253)
      = const Tag.public(
          "AnatomicPortalOfEntranceCodeSequenceTrial",
          0x00082253,
          "Anatomic Portal Of Entrance Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAnatomicApproachDirectionCodeSequenceTrial
      //(0008,2255)
      = const Tag.public(
          "AnatomicApproachDirectionCodeSequenceTrial",
          0x00082255,
          "Anatomic Approach Direction Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAnatomicPerspectiveDescriptionTrial
      //(0008,2256)
      = const Tag.public("AnatomicPerspectiveDescriptionTrial", 0x00082256,
          "Anatomic Perspective Description (Trial)", VR.kST, VM.k1, true);
  static const Tag kAnatomicPerspectiveCodeSequenceTrial
      //(0008,2257)
      = const Tag.public("AnatomicPerspectiveCodeSequenceTrial", 0x00082257,
          "Anatomic Perspective Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kAnatomicLocationOfExaminingInstrumentDescriptionTrial
      //(0008,2258)
      = const Tag.public(
          "AnatomicLocationOfExaminingInstrumentDescriptionTrial",
          0x00082258,
          "Anatomic Location Of Examining Instrument Description (Trial)",
          VR.kST,
          VM.k1,
          true);
  static const Tag kAnatomicLocationOfExaminingInstrumentCodeSequenceTrial
      //(0008,2259)
      = const Tag.public(
          "AnatomicLocationOfExaminingInstrumentCodeSequenceTrial",
          0x00082259,
          "Anatomic Location Of Examining Instrument Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAnatomicStructureSpaceOrRegionModifierCodeSequenceTrial
      //(0008,225A)
      = const Tag.public(
          "AnatomicStructureSpaceOrRegionModifierCodeSequenceTrial",
          0x0008225A,
          "Anatomic Structure Space Or Region Modifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kOnAxisBackgroundAnatomicStructureCodeSequenceTrial
      //(0008,225C)
      = const Tag.public(
          "OnAxisBackgroundAnatomicStructureCodeSequenceTrial",
          0x0008225C,
          "OnAxis Background Anatomic Structure Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAlternateRepresentationSequence
      //(0008,3001)
      = const Tag.public("AlternateRepresentationSequence", 0x00083001,
          "Alternate Representation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIrradiationEventUID
      //(0008,3010)
      = const Tag.public("IrradiationEventUID", 0x00083010,
          "Irradiation Event UID", VR.kUI, VM.k1_n, false);
  static const Tag kIdentifyingComments
      //(0008,4000)
      = const Tag.public("IdentifyingComments", 0x00084000,
          "Identifying Comments", VR.kLT, VM.k1, true);
  static const Tag kFrameType
      //(0008,9007)
      = const Tag.public(
          "FrameType", 0x00089007, "Frame Type", VR.kCS, VM.k4, false);
  static const Tag kReferencedImageEvidenceSequence
      //(0008,9092)
      = const Tag.public("ReferencedImageEvidenceSequence", 0x00089092,
          "Referenced Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedRawDataSequence
      //(0008,9121)
      = const Tag.public("ReferencedRawDataSequence", 0x00089121,
          "Referenced Raw Data Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCreatorVersionUID
      //(0008,9123)
      = const Tag.public("CreatorVersionUID", 0x00089123, "Creator-Version UID",
          VR.kUI, VM.k1, false);
  static const Tag kDerivationImageSequence
      //(0008,9124)
      = const Tag.public("DerivationImageSequence", 0x00089124,
          "Derivation Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceImageEvidenceSequence
      //(0008,9154)
      = const Tag.public("SourceImageEvidenceSequence", 0x00089154,
          "Source Image Evidence Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPixelPresentation
      //(0008,9205)
      = const Tag.public("PixelPresentation", 0x00089205, "Pixel Presentation",
          VR.kCS, VM.k1, false);
  static const Tag kVolumetricProperties
      //(0008,9206)
      = const Tag.public("VolumetricProperties", 0x00089206,
          "Volumetric Properties", VR.kCS, VM.k1, false);
  static const Tag kVolumeBasedCalculationTechnique
      //(0008,9207)
      = const Tag.public("VolumeBasedCalculationTechnique", 0x00089207,
          "Volume Based Calculation Technique", VR.kCS, VM.k1, false);
  static const Tag kComplexImageComponent
      //(0008,9208)
      = const Tag.public("ComplexImageComponent", 0x00089208,
          "Complex Image Component", VR.kCS, VM.k1, false);
  static const Tag kAcquisitionContrast
      //(0008,9209)
      = const Tag.public("AcquisitionContrast", 0x00089209,
          "Acquisition Contrast", VR.kCS, VM.k1, false);
  static const Tag kDerivationCodeSequence
      //(0008,9215)
      = const Tag.public("DerivationCodeSequence", 0x00089215,
          "Derivation Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedPresentationStateSequence
      //(0008,9237)
      = const Tag.public("ReferencedPresentationStateSequence", 0x00089237,
          "Referenced Presentation State Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedOtherPlaneSequence
      //(0008,9410)
      = const Tag.public("ReferencedOtherPlaneSequence", 0x00089410,
          "Referenced Other Plane Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFrameDisplaySequence
      //(0008,9458)
      = const Tag.public("FrameDisplaySequence", 0x00089458,
          "Frame Display Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecommendedDisplayFrameRateInFloat
      //(0008,9459)
      = const Tag.public("RecommendedDisplayFrameRateInFloat", 0x00089459,
          "Recommended Display Frame Rate in Float", VR.kFL, VM.k1, false);
  static const Tag kSkipFrameRangeFlag
      //(0008,9460)
      = const Tag.public("SkipFrameRangeFlag", 0x00089460,
          "Skip Frame Range Flag", VR.kCS, VM.k1, false);
  static const Tag kPatientName
      //(0010,0010)
      = const Tag.public(
          "PatientName", 0x00100010, "Patient's Name", VR.kPN, VM.k1, false);
  static const Tag kPatientID
      //(0010,0020)
      = const Tag.public(
          "PatientID", 0x00100020, "Patient ID", VR.kLO, VM.k1, false);
  static const Tag kIssuerOfPatientID
      //(0010,0021)
      = const Tag.public("IssuerOfPatientID", 0x00100021,
          "Issuer of Patient ID", VR.kLO, VM.k1, false);
  static const Tag kTypeOfPatientID
      //(0010,0022)
      = const Tag.public("TypeOfPatientID", 0x00100022, "Type of Patient ID",
          VR.kCS, VM.k1, false);
  static const Tag kIssuerOfPatientIDQualifiersSequence
      //(0010,0024)
      = const Tag.public("IssuerOfPatientIDQualifiersSequence", 0x00100024,
          "Issuer of Patient ID Qualifiers Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientBirthDate
      //(0010,0030)
      = const Tag.public("PatientBirthDate", 0x00100030, "Patient's Birth Date",
          VR.kDA, VM.k1, false);
  static const Tag kPatientBirthTime
      //(0010,0032)
      = const Tag.public("PatientBirthTime", 0x00100032, "Patient's Birth Time",
          VR.kTM, VM.k1, false);
  static const Tag kPatientSex
      //(0010,0040)
      = const Tag.public(
          "PatientSex", 0x00100040, "Patient's Sex", VR.kCS, VM.k1, false);
  static const Tag kPatientInsurancePlanCodeSequence
      //(0010,0050)
      = const Tag.public("PatientInsurancePlanCodeSequence", 0x00100050,
          "Patient's Insurance Plan Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientPrimaryLanguageCodeSequence
      //(0010,0101)
      = const Tag.public("PatientPrimaryLanguageCodeSequence", 0x00100101,
          "Patient's Primary Language Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientPrimaryLanguageModifierCodeSequence
      //(0010,0102)
      = const Tag.public(
          "PatientPrimaryLanguageModifierCodeSequence",
          0x00100102,
          "Patient's Primary Language Modifier Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kQualityControlSubject
      //(0010,0200)
      = const Tag.public("QualityControlSubject", 0x00100200,
          "Quality Control Subject", VR.kCS, VM.k1, false);
  static const Tag kQualityControlSubjectTypeCodeSequence
      //(0010,0201)
      = const Tag.public("QualityControlSubjectTypeCodeSequence", 0x00100201,
          "Quality Control Subject Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOtherPatientIDs
      //(0010,1000)
      = const Tag.public("OtherPatientIDs", 0x00101000, "Other Patient IDs",
          VR.kLO, VM.k1_n, false);
  static const Tag kOtherPatientNames
      //(0010,1001)
      = const Tag.public("OtherPatientNames", 0x00101001, "Other Patient Names",
          VR.kPN, VM.k1_n, false);
  static const Tag kOtherPatientIDsSequence
      //(0010,1002)
      = const Tag.public("OtherPatientIDsSequence", 0x00101002,
          "Other Patient IDs Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientBirthName
      //(0010,1005)
      = const Tag.public("PatientBirthName", 0x00101005, "Patient's Birth Name",
          VR.kPN, VM.k1, false);
  static const Tag kPatientAge
      //(0010,1010)
      = const Tag.public(
          "PatientAge", 0x00101010, "Patient's Age", VR.kAS, VM.k1, false);
  static const Tag kPatientSize
      //(0010,1020)
      = const Tag.public(
          "PatientSize", 0x00101020, "Patient's Size", VR.kDS, VM.k1, false);
  static const Tag kPatientSizeCodeSequence
      //(0010,1021)
      = const Tag.public("PatientSizeCodeSequence", 0x00101021,
          "Patient's Size Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientWeight
      //(0010,1030)
      = const Tag.public("PatientWeight", 0x00101030, "Patient's Weight",
          VR.kDS, VM.k1, false);
  static const Tag kPatientAddress
      //(0010,1040)
      = const Tag.public("PatientAddress", 0x00101040, "Patient's Address",
          VR.kLO, VM.k1, false);
  static const Tag kInsurancePlanIdentification
      //(0010,1050)
      = const Tag.public("InsurancePlanIdentification", 0x00101050,
          "Insurance Plan Identification", VR.kLO, VM.k1_n, true);
  static const Tag kPatientMotherBirthName
      //(0010,1060)
      = const Tag.public("PatientMotherBirthName", 0x00101060,
          "Patient's Mother's Birth Name", VR.kPN, VM.k1, false);
  static const Tag kMilitaryRank
      //(0010,1080)
      = const Tag.public(
          "MilitaryRank", 0x00101080, "Military Rank", VR.kLO, VM.k1, false);
  static const Tag kBranchOfService
      //(0010,1081)
      = const Tag.public("BranchOfService", 0x00101081, "Branch of Service",
          VR.kLO, VM.k1, false);
  static const Tag kMedicalRecordLocator
      //(0010,1090)
      = const Tag.public("MedicalRecordLocator", 0x00101090,
          "Medical Record Locator", VR.kLO, VM.k1, false);
  static const Tag kReferencedPatientPhotoSequence = const Tag.public(
      // (0010,1100)
      "ReferencedPatientPhotoSequence",
      0x00101100,
      "Referenced Patient Photo Sequence",
      VR.kSQ,
      VM.k1,
      false);
  static const Tag kMedicalAlerts
      //(0010,2000)
      = const Tag.public("MedicalAlerts", 0x00102000, "Medical Alerts", VR.kLO,
          VM.k1_n, false);
  static const Tag kAllergies
      //(0010,2110)
      = const Tag.public(
          "Allergies", 0x00102110, "Allergies", VR.kLO, VM.k1_n, false);
  static const Tag kCountryOfResidence
      //(0010,2150)
      = const Tag.public("CountryOfResidence", 0x00102150,
          "Country of Residence", VR.kLO, VM.k1, false);
  static const Tag kRegionOfResidence
      //(0010,2152)
      = const Tag.public("RegionOfResidence", 0x00102152, "Region of Residence",
          VR.kLO, VM.k1, false);
  static const Tag kPatientTelephoneNumbers
      //(0010,2154)
      = const Tag.public("PatientTelephoneNumbers", 0x00102154,
          "Patient's Telephone Numbers", VR.kSH, VM.k1_n, false);
  static const Tag kEthnicGroup
      //(0010,2160)
      = const Tag.public(
          "EthnicGroup", 0x00102160, "Ethnic Group", VR.kSH, VM.k1, false);
  static const Tag kOccupation
      //(0010,2180)
      = const Tag.public(
          "Occupation", 0x00102180, "Occupation", VR.kSH, VM.k1, false);
  static const Tag kSmokingStatus
      //(0010,21A0)
      = const Tag.public(
          "SmokingStatus", 0x001021A0, "Smoking Status", VR.kCS, VM.k1, false);
  static const Tag kAdditionalPatientHistory
      //(0010,21B0)
      = const Tag.public("AdditionalPatientHistory", 0x001021B0,
          "Additional Patient History", VR.kLT, VM.k1, false);
  static const Tag kPregnancyStatus
      //(0010,21C0)
      = const Tag.public("PregnancyStatus", 0x001021C0, "Pregnancy Status",
          VR.kUS, VM.k1, false);
  static const Tag kLastMenstrualDate
      //(0010,21D0)
      = const Tag.public("LastMenstrualDate", 0x001021D0, "Last Menstrual Date",
          VR.kDA, VM.k1, false);
  static const Tag kPatientReligiousPreference
      //(0010,21F0)
      = const Tag.public("PatientReligiousPreference", 0x001021F0,
          "Patient's Religious Preference", VR.kLO, VM.k1, false);
  static const Tag kPatientSpeciesDescription
      //(0010,2201)
      = const Tag.public("PatientSpeciesDescription", 0x00102201,
          "Patient Species Description", VR.kLO, VM.k1, false);
  static const Tag kPatientSpeciesCodeSequence
      //(0010,2202)
      = const Tag.public("PatientSpeciesCodeSequence", 0x00102202,
          "Patient Species Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientSexNeutered
      //(0010,2203)
      = const Tag.public("PatientSexNeutered", 0x00102203,
          "Patient's Sex Neutered", VR.kCS, VM.k1, false);
  static const Tag kAnatomicalOrientationType
      //(0010,2210)
      = const Tag.public("AnatomicalOrientationType", 0x00102210,
          "Anatomical Orientation Type", VR.kCS, VM.k1, false);
  static const Tag kPatientBreedDescription
      //(0010,2292)
      = const Tag.public("PatientBreedDescription", 0x00102292,
          "Patient Breed Description", VR.kLO, VM.k1, false);
  static const Tag kPatientBreedCodeSequence
      //(0010,2293)
      = const Tag.public("PatientBreedCodeSequence", 0x00102293,
          "Patient Breed Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBreedRegistrationSequence
      //(0010,2294)
      = const Tag.public("BreedRegistrationSequence", 0x00102294,
          "Breed Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBreedRegistrationNumber
      //(0010,2295)
      = const Tag.public("BreedRegistrationNumber", 0x00102295,
          "Breed Registration Number", VR.kLO, VM.k1, false);
  static const Tag kBreedRegistryCodeSequence
      //(0010,2296)
      = const Tag.public("BreedRegistryCodeSequence", 0x00102296,
          "Breed Registry Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kResponsiblePerson
      //(0010,2297)
      = const Tag.public("ResponsiblePerson", 0x00102297, "Responsible Person",
          VR.kPN, VM.k1, false);
  static const Tag kResponsiblePersonRole
      //(0010,2298)
      = const Tag.public("ResponsiblePersonRole", 0x00102298,
          "Responsible Person Role", VR.kCS, VM.k1, false);
  static const Tag kResponsibleOrganization
      //(0010,2299)
      = const Tag.public("ResponsibleOrganization", 0x00102299,
          "Responsible Organization", VR.kLO, VM.k1, false);
  static const Tag kPatientComments
      //(0010,4000)
      = const Tag.public("PatientComments", 0x00104000, "Patient Comments",
          VR.kLT, VM.k1, false);
  static const Tag kExaminedBodyThickness
      //(0010,9431)
      = const Tag.public("ExaminedBodyThickness", 0x00109431,
          "Examined Body Thickness", VR.kFL, VM.k1, false);
  static const Tag kClinicalTrialSponsorName
      //(0012,0010)
      = const Tag.public("ClinicalTrialSponsorName", 0x00120010,
          "Clinical Trial Sponsor Name", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialProtocolID
      //(0012,0020)
      = const Tag.public("ClinicalTrialProtocolID", 0x00120020,
          "Clinical Trial Protocol ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialProtocolName
      //(0012,0021)
      = const Tag.public("ClinicalTrialProtocolName", 0x00120021,
          "Clinical Trial Protocol Name", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialSiteID
      //(0012,0030)
      = const Tag.public("ClinicalTrialSiteID", 0x00120030,
          "Clinical Trial Site ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialSiteName
      //(0012,0031)
      = const Tag.public("ClinicalTrialSiteName", 0x00120031,
          "Clinical Trial Site Name", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialSubjectID
      //(0012,0040)
      = const Tag.public("ClinicalTrialSubjectID", 0x00120040,
          "Clinical Trial Subject ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialSubjectReadingID
      //(0012,0042)
      = const Tag.public("ClinicalTrialSubjectReadingID", 0x00120042,
          "Clinical Trial Subject Reading ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialTimePointID
      //(0012,0050)
      = const Tag.public("ClinicalTrialTimePointID", 0x00120050,
          "Clinical Trial Time Point ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialTimePointDescription
      //(0012,0051)
      = const Tag.public("ClinicalTrialTimePointDescription", 0x00120051,
          "Clinical Trial Time Point Description", VR.kST, VM.k1, false);
  static const Tag kClinicalTrialCoordinatingCenterName
      //(0012,0060)
      = const Tag.public("ClinicalTrialCoordinatingCenterName", 0x00120060,
          "Clinical Trial Coordinating Center Name", VR.kLO, VM.k1, false);
  static const Tag kPatientIdentityRemoved
      //(0012,0062)
      = const Tag.public("PatientIdentityRemoved", 0x00120062,
          "Patient Identity Removed", VR.kCS, VM.k1, false);
  static const Tag kDeidentificationMethod
      //(0012,0063)
      = const Tag.public("DeidentificationMethod", 0x00120063,
          "De-identification Method", VR.kLO, VM.k1_n, false);
  static const Tag kDeidentificationMethodCodeSequence
      //(0012,0064)
      = const Tag.public("DeidentificationMethodCodeSequence", 0x00120064,
          "De-identification Method Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kClinicalTrialSeriesID
      //(0012,0071)
      = const Tag.public("ClinicalTrialSeriesID", 0x00120071,
          "Clinical Trial Series ID", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialSeriesDescription
      //(0012,0072)
      = const Tag.public("ClinicalTrialSeriesDescription", 0x00120072,
          "Clinical Trial Series Description", VR.kLO, VM.k1, false);
  static const Tag kClinicalTrialProtocolEthicsCommitteeName
      //(0012,0081)
      = const Tag.public(
          "ClinicalTrialProtocolEthicsCommitteeName",
          0x00120081,
          "Clinical Trial Protocol Ethics Committee Name",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kClinicalTrialProtocolEthicsCommitteeApprovalNumber
      //(0012,0082)
      = const Tag.public(
          "ClinicalTrialProtocolEthicsCommitteeApprovalNumber",
          0x00120082,
          "Clinical Trial Protocol Ethics Committee Approval Number",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kConsentForClinicalTrialUseSequence
      //(0012,0083)
      = const Tag.public("ConsentForClinicalTrialUseSequence", 0x00120083,
          "Consent for Clinical Trial Use Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDistributionType
      //(0012,0084)
      = const Tag.public("DistributionType", 0x00120084, "Distribution Type",
          VR.kCS, VM.k1, false);
  static const Tag kConsentForDistributionFlag
      //(0012,0085)
      = const Tag.public("ConsentForDistributionFlag", 0x00120085,
          "Consent for Distribution Flag", VR.kCS, VM.k1, false);
  static const Tag kCADFileFormat
      //(0014,0023)
      = const Tag.public("CADFileFormat", 0x00140023, "CAD File Format", VR.kST,
          VM.k1_n, true);
  static const Tag kComponentReferenceSystem
      //(0014,0024)
      = const Tag.public("ComponentReferenceSystem", 0x00140024,
          "Component Reference System", VR.kST, VM.k1_n, true);
  static const Tag kComponentManufacturingProcedure
      //(0014,0025)
      = const Tag.public("ComponentManufacturingProcedure", 0x00140025,
          "Component Manufacturing Procedure", VR.kST, VM.k1_n, false);
  static const Tag kComponentManufacturer
      //(0014,0028)
      = const Tag.public("ComponentManufacturer", 0x00140028,
          "Component Manufacturer", VR.kST, VM.k1_n, false);
  static const Tag kMaterialThickness
      //(0014,0030)
      = const Tag.public("MaterialThickness", 0x00140030, "Material Thickness",
          VR.kDS, VM.k1_n, false);
  static const Tag kMaterialPipeDiameter
      //(0014,0032)
      = const Tag.public("MaterialPipeDiameter", 0x00140032,
          "Material Pipe Diameter", VR.kDS, VM.k1_n, false);
  static const Tag kMaterialIsolationDiameter
      //(0014,0034)
      = const Tag.public("MaterialIsolationDiameter", 0x00140034,
          "Material Isolation Diameter", VR.kDS, VM.k1_n, false);
  static const Tag kMaterialGrade
      //(0014,0042)
      = const Tag.public("MaterialGrade", 0x00140042, "Material Grade", VR.kST,
          VM.k1_n, false);
  static const Tag kMaterialPropertiesDescription
      //(0014,0044)
      = const Tag.public("MaterialPropertiesDescription", 0x00140044,
          "Material Properties Description", VR.kST, VM.k1_n, false);
  static const Tag kMaterialPropertiesFileFormatRetired
      //(0014,0045)
      = const Tag.public("MaterialPropertiesFileFormatRetired", 0x00140045,
          "Material Properties File Format (Retired)", VR.kST, VM.k1_n, true);
  static const Tag kMaterialNotes
      //(0014,0046)
      = const Tag.public(
          "MaterialNotes", 0x00140046, "Material Notes", VR.kLT, VM.k1, false);
  static const Tag kComponentShape
      //(0014,0050)
      = const Tag.public("ComponentShape", 0x00140050, "Component Shape",
          VR.kCS, VM.k1, false);
  static const Tag kCurvatureType
      //(0014,0052)
      = const Tag.public(
          "CurvatureType", 0x00140052, "Curvature Type", VR.kCS, VM.k1, false);
  static const Tag kOuterDiameter
      //(0014,0054)
      = const Tag.public(
          "OuterDiameter", 0x00140054, "Outer Diameter", VR.kDS, VM.k1, false);
  static const Tag kInnerDiameter
      //(0014,0056)
      = const Tag.public(
          "InnerDiameter", 0x00140056, "Inner Diameter", VR.kDS, VM.k1, false);
  static const Tag kActualEnvironmentalConditions
      //(0014,1010)
      = const Tag.public("ActualEnvironmentalConditions", 0x00141010,
          "Actual Environmental Conditions", VR.kST, VM.k1, false);
  static const Tag kExpiryDate
      //(0014,1020)
      = const Tag.public(
          "ExpiryDate", 0x00141020, "Expiry Date", VR.kDA, VM.k1, false);
  static const Tag kEnvironmentalConditions
      //(0014,1040)
      = const Tag.public("EnvironmentalConditions", 0x00141040,
          "Environmental Conditions", VR.kST, VM.k1, false);
  static const Tag kEvaluatorSequence
      //(0014,2002)
      = const Tag.public("EvaluatorSequence", 0x00142002, "Evaluator Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kEvaluatorNumber
      //(0014,2004)
      = const Tag.public("EvaluatorNumber", 0x00142004, "Evaluator Number",
          VR.kIS, VM.k1, false);
  static const Tag kEvaluatorName
      //(0014,2006)
      = const Tag.public(
          "EvaluatorName", 0x00142006, "Evaluator Name", VR.kPN, VM.k1, false);
  static const Tag kEvaluationAttempt
      //(0014,2008)
      = const Tag.public("EvaluationAttempt", 0x00142008, "Evaluation Attempt",
          VR.kIS, VM.k1, false);
  static const Tag kIndicationSequence
      //(0014,2012)
      = const Tag.public("IndicationSequence", 0x00142012,
          "Indication Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIndicationNumber
      //(0014,2014)
      = const Tag.public("IndicationNumber", 0x00142014, "Indication Number",
          VR.kIS, VM.k1, false);
  static const Tag kIndicationLabel
      //(0014,2016)
      = const Tag.public("IndicationLabel", 0x00142016, "Indication Label",
          VR.kSH, VM.k1, false);
  static const Tag kIndicationDescription
      //(0014,2018)
      = const Tag.public("IndicationDescription", 0x00142018,
          "Indication Description", VR.kST, VM.k1, false);
  static const Tag kIndicationType
      //(0014,201A)
      = const Tag.public("IndicationType", 0x0014201A, "Indication Type",
          VR.kCS, VM.k1_n, false);
  static const Tag kIndicationDisposition
      //(0014,201C)
      = const Tag.public("IndicationDisposition", 0x0014201C,
          "Indication Disposition", VR.kCS, VM.k1, false);
  static const Tag kIndicationROISequence
      //(0014,201E)
      = const Tag.public("IndicationROISequence", 0x0014201E,
          "Indication ROI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIndicationPhysicalPropertySequence
      //(0014,2030)
      = const Tag.public("IndicationPhysicalPropertySequence", 0x00142030,
          "Indication Physical Property Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPropertyLabel
      //(0014,2032)
      = const Tag.public(
          "PropertyLabel", 0x00142032, "Property Label", VR.kSH, VM.k1, false);
  static const Tag kCoordinateSystemNumberOfAxes
      //(0014,2202)
      = const Tag.public("CoordinateSystemNumberOfAxes", 0x00142202,
          "Coordinate System Number of Axes", VR.kIS, VM.k1, false);
  static const Tag kCoordinateSystemAxesSequence
      //(0014,2204)
      = const Tag.public("CoordinateSystemAxesSequence", 0x00142204,
          "Coordinate System Axes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCoordinateSystemAxisDescription
      //(0014,2206)
      = const Tag.public("CoordinateSystemAxisDescription", 0x00142206,
          "Coordinate System Axis Description", VR.kST, VM.k1, false);
  static const Tag kCoordinateSystemDataSetMapping
      //(0014,2208)
      = const Tag.public("CoordinateSystemDataSetMapping", 0x00142208,
          "Coordinate System Data Set Mapping", VR.kCS, VM.k1, false);
  static const Tag kCoordinateSystemAxisNumber
      //(0014,220A)
      = const Tag.public("CoordinateSystemAxisNumber", 0x0014220A,
          "Coordinate System Axis Number", VR.kIS, VM.k1, false);
  static const Tag kCoordinateSystemAxisType
      //(0014,220C)
      = const Tag.public("CoordinateSystemAxisType", 0x0014220C,
          "Coordinate System Axis Type", VR.kCS, VM.k1, false);
  static const Tag kCoordinateSystemAxisUnits
      //(0014,220E)
      = const Tag.public("CoordinateSystemAxisUnits", 0x0014220E,
          "Coordinate System Axis Units", VR.kCS, VM.k1, false);
  static const Tag kCoordinateSystemAxisValues
      //(0014,2210)
      = const Tag.public("CoordinateSystemAxisValues", 0x00142210,
          "Coordinate System Axis Values", VR.kOB, VM.k1, false);
  static const Tag kCoordinateSystemTransformSequence
      //(0014,2220)
      = const Tag.public("CoordinateSystemTransformSequence", 0x00142220,
          "Coordinate System Transform Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransformDescription
      //(0014,2222)
      = const Tag.public("TransformDescription", 0x00142222,
          "Transform Description", VR.kST, VM.k1, false);
  static const Tag kTransformNumberOfAxes
      //(0014,2224)
      = const Tag.public("TransformNumberOfAxes", 0x00142224,
          "Transform Number of Axes", VR.kIS, VM.k1, false);
  static const Tag kTransformOrderOfAxes
      //(0014,2226)
      = const Tag.public("TransformOrderOfAxes", 0x00142226,
          "Transform Order of Axes", VR.kIS, VM.k1_n, false);
  static const Tag kTransformedAxisUnits
      //(0014,2228)
      = const Tag.public("TransformedAxisUnits", 0x00142228,
          "Transformed Axis Units", VR.kCS, VM.k1, false);
  static const Tag kCoordinateSystemTransformRotationAndScaleMatrix
      //(0014,222A)
      = const Tag.public(
          "CoordinateSystemTransformRotationAndScaleMatrix",
          0x0014222A,
          "Coordinate System Transform Rotation and Scale Matrix",
          VR.kDS,
          VM.k1_n,
          false);
  static const Tag kCoordinateSystemTransformTranslationMatrix
      //(0014,222C)
      = const Tag.public(
          "CoordinateSystemTransformTranslationMatrix",
          0x0014222C,
          "Coordinate System Transform Translation Matrix",
          VR.kDS,
          VM.k1_n,
          false);
  static const Tag kInternalDetectorFrameTime
      //(0014,3011)
      = const Tag.public("InternalDetectorFrameTime", 0x00143011,
          "Internal Detector Frame Time", VR.kDS, VM.k1, false);
  static const Tag kNumberOfFramesIntegrated
      //(0014,3012)
      = const Tag.public("NumberOfFramesIntegrated", 0x00143012,
          "Number of Frames Integrated", VR.kDS, VM.k1, false);
  static const Tag kDetectorTemperatureSequence
      //(0014,3020)
      = const Tag.public("DetectorTemperatureSequence", 0x00143020,
          "Detector Temperature Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSensorName
      //(0014,3022)
      = const Tag.public(
          "SensorName", 0x00143022, "Sensor Name", VR.kST, VM.k1, false);
  static const Tag kHorizontalOffsetOfSensor
      //(0014,3024)
      = const Tag.public("HorizontalOffsetOfSensor", 0x00143024,
          "Horizontal Offset of Sensor", VR.kDS, VM.k1, false);
  static const Tag kVerticalOffsetOfSensor
      //(0014,3026)
      = const Tag.public("VerticalOffsetOfSensor", 0x00143026,
          "Vertical Offset of Sensor", VR.kDS, VM.k1, false);
  static const Tag kSensorTemperature
      //(0014,3028)
      = const Tag.public("SensorTemperature", 0x00143028, "Sensor Temperature",
          VR.kDS, VM.k1, false);
  static const Tag kDarkCurrentSequence
      //(0014,3040)
      = const Tag.public("DarkCurrentSequence", 0x00143040,
          "Dark Current Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDarkCurrentCounts
      //(0014,3050)
      = const Tag.public("DarkCurrentCounts", 0x00143050, "Dark Current Counts",
          VR.kOBOW, VM.k1, false);
  static const Tag kGainCorrectionReferenceSequence
      //(0014,3060)
      = const Tag.public("GainCorrectionReferenceSequence", 0x00143060,
          "Gain Correction Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAirCounts
      //(0014,3070)
      = const Tag.public(
          "AirCounts", 0x00143070, "Air Counts", VR.kOBOW, VM.k1, false);
  static const Tag kKVUsedInGainCalibration
      //(0014,3071)
      = const Tag.public("KVUsedInGainCalibration", 0x00143071,
          "KV Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const Tag kMAUsedInGainCalibration
      //(0014,3072)
      = const Tag.public("MAUsedInGainCalibration", 0x00143072,
          "MA Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const Tag kNumberOfFramesUsedForIntegration
      //(0014,3073)
      = const Tag.public("NumberOfFramesUsedForIntegration", 0x00143073,
          "Number of Frames Used for Integration", VR.kDS, VM.k1, false);
  static const Tag kFilterMaterialUsedInGainCalibration
      //(0014,3074)
      = const Tag.public("FilterMaterialUsedInGainCalibration", 0x00143074,
          "Filter Material Used in Gain Calibration", VR.kLO, VM.k1, false);
  static const Tag kFilterThicknessUsedInGainCalibration
      //(0014,3075)
      = const Tag.public("FilterThicknessUsedInGainCalibration", 0x00143075,
          "Filter Thickness Used in Gain Calibration", VR.kDS, VM.k1, false);
  static const Tag kDateOfGainCalibration
      //(0014,3076)
      = const Tag.public("DateOfGainCalibration", 0x00143076,
          "Date of Gain Calibration", VR.kDA, VM.k1, false);
  static const Tag kTimeOfGainCalibration
      //(0014,3077)
      = const Tag.public("TimeOfGainCalibration", 0x00143077,
          "Time of Gain Calibration", VR.kTM, VM.k1, false);
  static const Tag kBadPixelImage
      //(0014,3080)
      = const Tag.public(
          "BadPixelImage", 0x00143080, "Bad Pixel Image", VR.kOB, VM.k1, false);
  static const Tag kCalibrationNotes
      //(0014,3099)
      = const Tag.public("CalibrationNotes", 0x00143099, "Calibration Notes",
          VR.kLT, VM.k1, false);
  static const Tag kPulserEquipmentSequence
      //(0014,4002)
      = const Tag.public("PulserEquipmentSequence", 0x00144002,
          "Pulser Equipment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPulserType
      //(0014,4004)
      = const Tag.public(
          "PulserType", 0x00144004, "Pulser Type", VR.kCS, VM.k1, false);
  static const Tag kPulserNotes
      //(0014,4006)
      = const Tag.public(
          "PulserNotes", 0x00144006, "Pulser Notes", VR.kLT, VM.k1, false);
  static const Tag kReceiverEquipmentSequence
      //(0014,4008)
      = const Tag.public("ReceiverEquipmentSequence", 0x00144008,
          "Receiver Equipment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAmplifierType
      //(0014,400A)
      = const Tag.public(
          "AmplifierType", 0x0014400A, "Amplifier Type", VR.kCS, VM.k1, false);
  static const Tag kReceiverNotes
      //(0014,400C)
      = const Tag.public(
          "ReceiverNotes", 0x0014400C, "Receiver Notes", VR.kLT, VM.k1, false);
  static const Tag kPreAmplifierEquipmentSequence
      //(0014,400E)
      = const Tag.public("PreAmplifierEquipmentSequence", 0x0014400E,
          "Pre-Amplifier Equipment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPreAmplifierNotes
      //(0014,400F)
      = const Tag.public("PreAmplifierNotes", 0x0014400F, "Pre-Amplifier Notes",
          VR.kLT, VM.k1, false);
  static const Tag kTransmitTransducerSequence
      //(0014,4010)
      = const Tag.public("TransmitTransducerSequence", 0x00144010,
          "Transmit Transducer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReceiveTransducerSequence
      //(0014,4011)
      = const Tag.public("ReceiveTransducerSequence", 0x00144011,
          "Receive Transducer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfElements
      //(0014,4012)
      = const Tag.public("NumberOfElements", 0x00144012, "Number of Elements",
          VR.kUS, VM.k1, false);
  static const Tag kElementShape
      //(0014,4013)
      = const Tag.public(
          "ElementShape", 0x00144013, "Element Shape", VR.kCS, VM.k1, false);
  static const Tag kElementDimensionA
      //(0014,4014)
      = const Tag.public("ElementDimensionA", 0x00144014, "Element Dimension A",
          VR.kDS, VM.k1, false);
  static const Tag kElementDimensionB
      //(0014,4015)
      = const Tag.public("ElementDimensionB", 0x00144015, "Element Dimension B",
          VR.kDS, VM.k1, false);
  static const Tag kElementPitchA
      //(0014,4016)
      = const Tag.public(
          "ElementPitchA", 0x00144016, "Element Pitch A", VR.kDS, VM.k1, false);
  static const Tag kMeasuredBeamDimensionA
      //(0014,4017)
      = const Tag.public("MeasuredBeamDimensionA", 0x00144017,
          "Measured Beam Dimension A", VR.kDS, VM.k1, false);
  static const Tag kMeasuredBeamDimensionB
      //(0014,4018)
      = const Tag.public("MeasuredBeamDimensionB", 0x00144018,
          "Measured Beam Dimension B", VR.kDS, VM.k1, false);
  static const Tag kLocationOfMeasuredBeamDiameter
      //(0014,4019)
      = const Tag.public("LocationOfMeasuredBeamDiameter", 0x00144019,
          "Location of Measured Beam Diameter", VR.kDS, VM.k1, false);
  static const Tag kNominalFrequency
      //(0014,401A)
      = const Tag.public("NominalFrequency", 0x0014401A, "Nominal Frequency",
          VR.kDS, VM.k1, false);
  static const Tag kMeasuredCenterFrequency
      //(0014,401B)
      = const Tag.public("MeasuredCenterFrequency", 0x0014401B,
          "Measured Center Frequency", VR.kDS, VM.k1, false);
  static const Tag kMeasuredBandwidth
      //(0014,401C)
      = const Tag.public("MeasuredBandwidth", 0x0014401C, "Measured Bandwidth",
          VR.kDS, VM.k1, false);
  static const Tag kElementPitchB
      //(0014,401D)
      = const Tag.public(
          "ElementPitchB", 0x0014401D, "Element Pitch B", VR.kDS, VM.k1, false);
  static const Tag kPulserSettingsSequence
      //(0014,4020)
      = const Tag.public("PulserSettingsSequence", 0x00144020,
          "Pulser Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPulseWidth
      //(0014,4022)
      = const Tag.public(
          "PulseWidth", 0x00144022, "Pulse Width", VR.kDS, VM.k1, false);
  static const Tag kExcitationFrequency
      //(0014,4024)
      = const Tag.public("ExcitationFrequency", 0x00144024,
          "Excitation Frequency", VR.kDS, VM.k1, false);
  static const Tag kModulationType
      //(0014,4026)
      = const Tag.public("ModulationType", 0x00144026, "Modulation Type",
          VR.kCS, VM.k1, false);
  static const Tag kDamping
      //(0014,4028)
      =
      const Tag.public("Damping", 0x00144028, "Damping", VR.kDS, VM.k1, false);
  static const Tag kReceiverSettingsSequence
      //(0014,4030)
      = const Tag.public("ReceiverSettingsSequence", 0x00144030,
          "Receiver Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcquiredSoundpathLength
      //(0014,4031)
      = const Tag.public("AcquiredSoundpathLength", 0x00144031,
          "Acquired Soundpath Length", VR.kDS, VM.k1, false);
  static const Tag kAcquisitionCompressionType
      //(0014,4032)
      = const Tag.public("AcquisitionCompressionType", 0x00144032,
          "Acquisition Compression Type", VR.kCS, VM.k1, false);
  static const Tag kAcquisitionSampleSize
      //(0014,4033)
      = const Tag.public("AcquisitionSampleSize", 0x00144033,
          "Acquisition Sample Size", VR.kIS, VM.k1, false);
  static const Tag kRectifierSmoothing
      //(0014,4034)
      = const Tag.public("RectifierSmoothing", 0x00144034,
          "Rectifier Smoothing", VR.kDS, VM.k1, false);
  static const Tag kDACSequence
      //(0014,4035)
      = const Tag.public(
          "DACSequence", 0x00144035, "DAC Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDACType
      //(0014,4036)
      =
      const Tag.public("DACType", 0x00144036, "DAC Type", VR.kCS, VM.k1, false);
  static const Tag kDACGainPoints
      //(0014,4038)
      = const Tag.public("DACGainPoints", 0x00144038, "DAC Gain Points", VR.kDS,
          VM.k1_n, false);
  static const Tag kDACTimePoints
      //(0014,403A)
      = const Tag.public("DACTimePoints", 0x0014403A, "DAC Time Points", VR.kDS,
          VM.k1_n, false);
  static const Tag kDACAmplitude
      //(0014,403C)
      = const Tag.public(
          "DACAmplitude", 0x0014403C, "DAC Amplitude", VR.kDS, VM.k1_n, false);
  static const Tag kPreAmplifierSettingsSequence
      //(0014,4040)
      = const Tag.public("PreAmplifierSettingsSequence", 0x00144040,
          "Pre-Amplifier Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransmitTransducerSettingsSequence
      //(0014,4050)
      = const Tag.public("TransmitTransducerSettingsSequence", 0x00144050,
          "Transmit Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReceiveTransducerSettingsSequence
      //(0014,4051)
      = const Tag.public("ReceiveTransducerSettingsSequence", 0x00144051,
          "Receive Transducer Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIncidentAngle
      //(0014,4052)
      = const Tag.public(
          "IncidentAngle", 0x00144052, "Incident Angle", VR.kDS, VM.k1, false);
  static const Tag kCouplingTechnique
      //(0014,4054)
      = const Tag.public("CouplingTechnique", 0x00144054, "Coupling Technique",
          VR.kST, VM.k1, false);
  static const Tag kCouplingMedium
      //(0014,4056)
      = const Tag.public("CouplingMedium", 0x00144056, "Coupling Medium",
          VR.kST, VM.k1, false);
  static const Tag kCouplingVelocity
      //(0014,4057)
      = const Tag.public("CouplingVelocity", 0x00144057, "Coupling Velocity",
          VR.kDS, VM.k1, false);
  static const Tag kProbeCenterLocationX
      //(0014,4058)
      = const Tag.public("ProbeCenterLocationX", 0x00144058,
          "Probe Center Location X", VR.kDS, VM.k1, false);
  static const Tag kProbeCenterLocationZ
      //(0014,4059)
      = const Tag.public("ProbeCenterLocationZ", 0x00144059,
          "Probe Center Location Z", VR.kDS, VM.k1, false);
  static const Tag kSoundPathLength
      //(0014,405A)
      = const Tag.public("SoundPathLength", 0x0014405A, "Sound Path Length",
          VR.kDS, VM.k1, false);
  static const Tag kDelayLawIdentifier
      //(0014,405C)
      = const Tag.public("DelayLawIdentifier", 0x0014405C,
          "Delay Law Identifier", VR.kST, VM.k1, false);
  static const Tag kGateSettingsSequence
      //(0014,4060)
      = const Tag.public("GateSettingsSequence", 0x00144060,
          "Gate Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGateThreshold
      //(0014,4062)
      = const Tag.public(
          "GateThreshold", 0x00144062, "Gate Threshold", VR.kDS, VM.k1, false);
  static const Tag kVelocityOfSound
      //(0014,4064)
      = const Tag.public("VelocityOfSound", 0x00144064, "Velocity of Sound",
          VR.kDS, VM.k1, false);
  static const Tag kCalibrationSettingsSequence
      //(0014,4070)
      = const Tag.public("CalibrationSettingsSequence", 0x00144070,
          "Calibration Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCalibrationProcedure
      //(0014,4072)
      = const Tag.public("CalibrationProcedure", 0x00144072,
          "Calibration Procedure", VR.kST, VM.k1, false);
  static const Tag kProcedureVersion
      //(0014,4074)
      = const Tag.public("ProcedureVersion", 0x00144074, "Procedure Version",
          VR.kSH, VM.k1, false);
  static const Tag kProcedureCreationDate
      //(0014,4076)
      = const Tag.public("ProcedureCreationDate", 0x00144076,
          "Procedure Creation Date", VR.kDA, VM.k1, false);
  static const Tag kProcedureExpirationDate
      //(0014,4078)
      = const Tag.public("ProcedureExpirationDate", 0x00144078,
          "Procedure Expiration Date", VR.kDA, VM.k1, false);
  static const Tag kProcedureLastModifiedDate
      //(0014,407A)
      = const Tag.public("ProcedureLastModifiedDate", 0x0014407A,
          "Procedure Last Modified Date", VR.kDA, VM.k1, false);
  static const Tag kCalibrationTime
      //(0014,407C)
      = const Tag.public("CalibrationTime", 0x0014407C, "Calibration Time",
          VR.kTM, VM.k1_n, false);
  static const Tag kCalibrationDate
      //(0014,407E)
      = const Tag.public("CalibrationDate", 0x0014407E, "Calibration Date",
          VR.kDA, VM.k1_n, false);
  static const Tag kProbeDriveEquipmentSequence
      //(0014,4080)
      = const Tag.public("ProbeDriveEquipmentSequence", 0x00144080,
          "Probe Drive Equipment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDriveType
      //(0014,4081)
      = const Tag.public(
          "DriveType", 0x00144081, "Drive Type", VR.kCS, VM.k1, false);
  static const Tag kProbeDriveNotes
      //(0014,4082)
      = const Tag.public("ProbeDriveNotes", 0x00144082, "Probe Drive Notes",
          VR.kLT, VM.k1, false);
  static const Tag kDriveProbeSequence
      //(0014,4083)
      = const Tag.public("DriveProbeSequence", 0x00144083,
          "Drive Probe Sequence", VR.kSQ, VM.k1, false);
  static const Tag kProbeInductance
      //(0014,4084)
      = const Tag.public("ProbeInductance", 0x00144084, "Probe Inductance",
          VR.kDS, VM.k1, false);
  static const Tag kProbeResistance
      //(0014,4085)
      = const Tag.public("ProbeResistance", 0x00144085, "Probe Resistance",
          VR.kDS, VM.k1, false);
  static const Tag kReceiveProbeSequence
      //(0014,4086)
      = const Tag.public("ReceiveProbeSequence", 0x00144086,
          "Receive Probe Sequence", VR.kSQ, VM.k1, false);
  static const Tag kProbeDriveSettingsSequence
      //(0014,4087)
      = const Tag.public("ProbeDriveSettingsSequence", 0x00144087,
          "Probe Drive Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBridgeResistors
      //(0014,4088)
      = const Tag.public("BridgeResistors", 0x00144088, "Bridge Resistors",
          VR.kDS, VM.k1, false);
  static const Tag kProbeOrientationAngle
      //(0014,4089)
      = const Tag.public("ProbeOrientationAngle", 0x00144089,
          "Probe Orientation Angle", VR.kDS, VM.k1, false);
  static const Tag kUserSelectedGainY
      //(0014,408B)
      = const Tag.public("UserSelectedGainY", 0x0014408B,
          "User Selected Gain Y", VR.kDS, VM.k1, false);
  static const Tag kUserSelectedPhase
      //(0014,408C)
      = const Tag.public("UserSelectedPhase", 0x0014408C, "User Selected Phase",
          VR.kDS, VM.k1, false);
  static const Tag kUserSelectedOffsetX
      //(0014,408D)
      = const Tag.public("UserSelectedOffsetX", 0x0014408D,
          "User Selected Offset X", VR.kDS, VM.k1, false);
  static const Tag kUserSelectedOffsetY
      //(0014,408E)
      = const Tag.public("UserSelectedOffsetY", 0x0014408E,
          "User Selected Offset Y", VR.kDS, VM.k1, false);
  static const Tag kChannelSettingsSequence
      //(0014,4091)
      = const Tag.public("ChannelSettingsSequence", 0x00144091,
          "Channel Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelThreshold
      //(0014,4092)
      = const Tag.public("ChannelThreshold", 0x00144092, "Channel Threshold",
          VR.kDS, VM.k1, false);
  static const Tag kScannerSettingsSequence
      //(0014,409A)
      = const Tag.public("ScannerSettingsSequence", 0x0014409A,
          "Scanner Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScanProcedure
      //(0014,409B)
      = const Tag.public(
          "ScanProcedure", 0x0014409B, "Scan Procedure", VR.kST, VM.k1, false);
  static const Tag kTranslationRateX
      //(0014,409C)
      = const Tag.public("TranslationRateX", 0x0014409C, "Translation Rate X",
          VR.kDS, VM.k1, false);
  static const Tag kTranslationRateY
      //(0014,409D)
      = const Tag.public("TranslationRateY", 0x0014409D, "Translation Rate Y",
          VR.kDS, VM.k1, false);
  static const Tag kChannelOverlap
      //(0014,409F)
      = const Tag.public("ChannelOverlap", 0x0014409F, "Channel Overlap",
          VR.kDS, VM.k1, false);
  static const Tag kImageQualityIndicatorType
      //(0014,40A0)
      = const Tag.public("ImageQualityIndicatorType", 0x001440A0,
          "Image Quality Indicator Type", VR.kLO, VM.k1, false);
  static const Tag kImageQualityIndicatorMaterial
      //(0014,40A1)
      = const Tag.public("ImageQualityIndicatorMaterial", 0x001440A1,
          "Image Quality Indicator Material", VR.kLO, VM.k1, false);
  static const Tag kImageQualityIndicatorSize
      //(0014,40A2)
      = const Tag.public("ImageQualityIndicatorSize", 0x001440A2,
          "Image Quality Indicator Size", VR.kLO, VM.k1, false);
  static const Tag kLINACEnergy
      //(0014,5002)
      = const Tag.public(
          "LINACEnergy", 0x00145002, "LINAC Energy", VR.kIS, VM.k1, false);
  static const Tag kLINACOutput
      //(0014,5004)
      = const Tag.public(
          "LINACOutput", 0x00145004, "LINAC Output", VR.kIS, VM.k1, false);
  static const Tag kContrastBolusAgent
      //(0018,0010)
      = const Tag.public("ContrastBolusAgent", 0x00180010,
          "Contrast/Bolus Agent", VR.kLO, VM.k1, false);
  static const Tag kContrastBolusAgentSequence
      //(0018,0012)
      = const Tag.public("ContrastBolusAgentSequence", 0x00180012,
          "Contrast/Bolus Agent Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContrastBolusAdministrationRouteSequence
      //(0018,0014)
      = const Tag.public("ContrastBolusAdministrationRouteSequence", 0x00180014,
          "Contrast/Bolus Administration Route Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBodyPartExamined
      //(0018,0015)
      = const Tag.public("BodyPartExamined", 0x00180015, "Body Part Examined",
          VR.kCS, VM.k1, false);
  static const Tag kScanningSequence
      //(0018,0020)
      = const Tag.public("ScanningSequence", 0x00180020, "Scanning Sequence",
          VR.kCS, VM.k1_n, false);
  static const Tag kSequenceVariant
      //(0018,0021)
      = const Tag.public("SequenceVariant", 0x00180021, "Sequence Variant",
          VR.kCS, VM.k1_n, false);
  static const Tag kScanOptions
      //(0018,0022)
      = const Tag.public(
          "ScanOptions", 0x00180022, "Scan Options", VR.kCS, VM.k1_n, false);
  static const Tag kMRAcquisitionType
      //(0018,0023)
      = const Tag.public("MRAcquisitionType", 0x00180023, "MR Acquisition Type",
          VR.kCS, VM.k1, false);
  static const Tag kSequenceName
      //(0018,0024)
      = const Tag.public(
          "SequenceName", 0x00180024, "Sequence Name", VR.kSH, VM.k1, false);
  static const Tag kAngioFlag
      //(0018,0025)
      = const Tag.public(
          "AngioFlag", 0x00180025, "Angio Flag", VR.kCS, VM.k1, false);
  static const Tag kInterventionDrugInformationSequence
      //(0018,0026)
      = const Tag.public("InterventionDrugInformationSequence", 0x00180026,
          "Intervention Drug Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kInterventionDrugStopTime
      //(0018,0027)
      = const Tag.public("InterventionDrugStopTime", 0x00180027,
          "Intervention Drug Stop Time", VR.kTM, VM.k1, false);
  static const Tag kInterventionDrugDose
      //(0018,0028)
      = const Tag.public("InterventionDrugDose", 0x00180028,
          "Intervention Drug Dose", VR.kDS, VM.k1, false);
  static const Tag kInterventionDrugCodeSequence
      //(0018,0029)
      = const Tag.public("InterventionDrugCodeSequence", 0x00180029,
          "Intervention Drug Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAdditionalDrugSequence
      //(0018,002A)
      = const Tag.public("AdditionalDrugSequence", 0x0018002A,
          "Additional Drug Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRadionuclide
      //(0018,0030)
      = const Tag.public(
          "Radionuclide", 0x00180030, "Radionuclide", VR.kLO, VM.k1_n, true);
  static const Tag kRadiopharmaceutical
      //(0018,0031)
      = const Tag.public("Radiopharmaceutical", 0x00180031,
          "Radiopharmaceutical", VR.kLO, VM.k1, false);
  static const Tag kEnergyWindowCenterline
      //(0018,0032)
      = const Tag.public("EnergyWindowCenterline", 0x00180032,
          "Energy Window Centerline", VR.kDS, VM.k1, true);
  static const Tag kEnergyWindowTotalWidth
      //(0018,0033)
      = const Tag.public("EnergyWindowTotalWidth", 0x00180033,
          "Energy Window Total Width", VR.kDS, VM.k1_n, true);
  static const Tag kInterventionDrugName
      //(0018,0034)
      = const Tag.public("InterventionDrugName", 0x00180034,
          "Intervention Drug Name", VR.kLO, VM.k1, false);
  static const Tag kInterventionDrugStartTime
      //(0018,0035)
      = const Tag.public("InterventionDrugStartTime", 0x00180035,
          "Intervention Drug Start Time", VR.kTM, VM.k1, false);
  static const Tag kInterventionSequence
      //(0018,0036)
      = const Tag.public("InterventionSequence", 0x00180036,
          "Intervention Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTherapyType
      //(0018,0037)
      = const Tag.public(
          "TherapyType", 0x00180037, "Therapy Type", VR.kCS, VM.k1, true);
  static const Tag kInterventionStatus
      //(0018,0038)
      = const Tag.public("InterventionStatus", 0x00180038,
          "Intervention Status", VR.kCS, VM.k1, false);
  static const Tag kTherapyDescription
      //(0018,0039)
      = const Tag.public("TherapyDescription", 0x00180039,
          "Therapy Description", VR.kCS, VM.k1, true);
  static const Tag kInterventionDescription
      //(0018,003A)
      = const Tag.public("InterventionDescription", 0x0018003A,
          "Intervention Description", VR.kST, VM.k1, false);
  static const Tag kCineRate
      //(0018,0040)
      = const Tag.public(
          "CineRate", 0x00180040, "Cine Rate", VR.kIS, VM.k1, false);
  static const Tag kInitialCineRunState
      //(0018,0042)
      = const Tag.public("InitialCineRunState", 0x00180042,
          "Initial Cine Run State", VR.kCS, VM.k1, false);
  static const Tag kSliceThickness
      //(0018,0050)
      = const Tag.public("SliceThickness", 0x00180050, "Slice Thickness",
          VR.kDS, VM.k1, false);
  static const Tag kKVP
      //(0018,0060)
      = const Tag.public("KVP", 0x00180060, "KVP", VR.kDS, VM.k1, false);
  static const Tag kCountsAccumulated
      //(0018,0070)
      = const Tag.public("CountsAccumulated", 0x00180070, "Counts Accumulated",
          VR.kIS, VM.k1, false);
  static const Tag kAcquisitionTerminationCondition
      //(0018,0071)
      = const Tag.public("AcquisitionTerminationCondition", 0x00180071,
          "Acquisition Termination Condition", VR.kCS, VM.k1, false);
  static const Tag kEffectiveDuration
      //(0018,0072)
      = const Tag.public("EffectiveDuration", 0x00180072, "Effective Duration",
          VR.kDS, VM.k1, false);
  static const Tag kAcquisitionStartCondition
      //(0018,0073)
      = const Tag.public("AcquisitionStartCondition", 0x00180073,
          "Acquisition Start Condition", VR.kCS, VM.k1, false);
  static const Tag kAcquisitionStartConditionData
      //(0018,0074)
      = const Tag.public("AcquisitionStartConditionData", 0x00180074,
          "Acquisition Start Condition Data", VR.kIS, VM.k1, false);
  static const Tag kAcquisitionTerminationConditionData
      //(0018,0075)
      = const Tag.public("AcquisitionTerminationConditionData", 0x00180075,
          "Acquisition Termination Condition Data", VR.kIS, VM.k1, false);
  static const Tag kRepetitionTime
      //(0018,0080)
      = const Tag.public("RepetitionTime", 0x00180080, "Repetition Time",
          VR.kDS, VM.k1, false);
  static const Tag kEchoTime
      //(0018,0081)
      = const Tag.public(
          "EchoTime", 0x00180081, "Echo Time", VR.kDS, VM.k1, false);
  static const Tag kInversionTime
      //(0018,0082)
      = const Tag.public(
          "InversionTime", 0x00180082, "Inversion Time", VR.kDS, VM.k1, false);
  static const Tag kNumberOfAverages
      //(0018,0083)
      = const Tag.public("NumberOfAverages", 0x00180083, "Number of Averages",
          VR.kDS, VM.k1, false);
  static const Tag kImagingFrequency
      //(0018,0084)
      = const Tag.public("ImagingFrequency", 0x00180084, "Imaging Frequency",
          VR.kDS, VM.k1, false);
  static const Tag kImagedNucleus
      //(0018,0085)
      = const Tag.public(
          "ImagedNucleus", 0x00180085, "Imaged Nucleus", VR.kSH, VM.k1, false);
  static const Tag kEchoNumbers
      //(0018,0086)
      = const Tag.public(
          "EchoNumbers", 0x00180086, "Echo Number(s)", VR.kIS, VM.k1_n, false);
  static const Tag kMagneticFieldStrength
      //(0018,0087)
      = const Tag.public("MagneticFieldStrength", 0x00180087,
          "Magnetic Field Strength", VR.kDS, VM.k1, false);
  static const Tag kSpacingBetweenSlices
      //(0018,0088)
      = const Tag.public("SpacingBetweenSlices", 0x00180088,
          "Spacing Between Slices", VR.kDS, VM.k1, false);
  static const Tag kNumberOfPhaseEncodingSteps
      //(0018,0089)
      = const Tag.public("NumberOfPhaseEncodingSteps", 0x00180089,
          "Number of Phase Encoding Steps", VR.kIS, VM.k1, false);
  static const Tag kDataCollectionDiameter
      //(0018,0090)
      = const Tag.public("DataCollectionDiameter", 0x00180090,
          "Data Collection Diameter", VR.kDS, VM.k1, false);
  static const Tag kEchoTrainLength
      //(0018,0091)
      = const Tag.public("EchoTrainLength", 0x00180091, "Echo Train Length",
          VR.kIS, VM.k1, false);
  static const Tag kPercentSampling
      //(0018,0093)
      = const Tag.public("PercentSampling", 0x00180093, "Percent Sampling",
          VR.kDS, VM.k1, false);
  static const Tag kPercentPhaseFieldOfView
      //(0018,0094)
      = const Tag.public("PercentPhaseFieldOfView", 0x00180094,
          "Percent Phase Field of View", VR.kDS, VM.k1, false);
  static const Tag kPixelBandwidth
      //(0018,0095)
      = const Tag.public("PixelBandwidth", 0x00180095, "Pixel Bandwidth",
          VR.kDS, VM.k1, false);
  static const Tag kDeviceSerialNumber
      //(0018,1000)
      = const Tag.public("DeviceSerialNumber", 0x00181000,
          "Device Serial Number", VR.kLO, VM.k1, false);
  static const Tag kDeviceUID
      //(0018,1002)
      = const Tag.public(
          "DeviceUID", 0x00181002, "Device UID", VR.kUI, VM.k1, false);
  static const Tag kDeviceID
      //(0018,1003)
      = const Tag.public(
          "DeviceID", 0x00181003, "Device ID", VR.kLO, VM.k1, false);
  static const Tag kPlateID
      //(0018,1004)
      =
      const Tag.public("PlateID", 0x00181004, "Plate ID", VR.kLO, VM.k1, false);
  static const Tag kGeneratorID
      //(0018,1005)
      = const Tag.public(
          "GeneratorID", 0x00181005, "Generator ID", VR.kLO, VM.k1, false);
  static const Tag kGridID
      //(0018,1006)
      = const Tag.public("GridID", 0x00181006, "Grid ID", VR.kLO, VM.k1, false);
  static const Tag kCassetteID
      //(0018,1007)
      = const Tag.public(
          "CassetteID", 0x00181007, "Cassette ID", VR.kLO, VM.k1, false);
  static const Tag kGantryID
      //(0018,1008)
      = const Tag.public(
          "GantryID", 0x00181008, "Gantry ID", VR.kLO, VM.k1, false);
  static const Tag kSecondaryCaptureDeviceID
      //(0018,1010)
      = const Tag.public("SecondaryCaptureDeviceID", 0x00181010,
          "Secondary Capture Device ID", VR.kLO, VM.k1, false);
  static const Tag kHardcopyCreationDeviceID
      //(0018,1011)
      = const Tag.public("HardcopyCreationDeviceID", 0x00181011,
          "Hardcopy Creation Device ID", VR.kLO, VM.k1, true);
  static const Tag kDateOfSecondaryCapture
      //(0018,1012)
      = const Tag.public("DateOfSecondaryCapture", 0x00181012,
          "Date of Secondary Capture", VR.kDA, VM.k1, false);
  static const Tag kTimeOfSecondaryCapture
      //(0018,1014)
      = const Tag.public("TimeOfSecondaryCapture", 0x00181014,
          "Time of Secondary Capture", VR.kTM, VM.k1, false);
  static const Tag kSecondaryCaptureDeviceManufacturer
      //(0018,1016)
      = const Tag.public("SecondaryCaptureDeviceManufacturer", 0x00181016,
          "Secondary Capture Device Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kHardcopyDeviceManufacturer
      //(0018,1017)
      = const Tag.public("HardcopyDeviceManufacturer", 0x00181017,
          "Hardcopy Device Manufacturer", VR.kLO, VM.k1, true);
  static const Tag kSecondaryCaptureDeviceManufacturerModelName
      //(0018,1018)
      = const Tag.public(
          "SecondaryCaptureDeviceManufacturerModelName",
          0x00181018,
          "Secondary Capture Device Manufacturer's Model Name",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kSecondaryCaptureDeviceSoftwareVersions
      //(0018,1019)
      = const Tag.public("SecondaryCaptureDeviceSoftwareVersions", 0x00181019,
          "Secondary Capture Device Software Versions", VR.kLO, VM.k1_n, false);
  static const Tag kHardcopyDeviceSoftwareVersion
      //(0018,101A)
      = const Tag.public("HardcopyDeviceSoftwareVersion", 0x0018101A,
          "Hardcopy Device Software Version", VR.kLO, VM.k1_n, true);
  static const Tag kHardcopyDeviceManufacturerModelName
      //(0018,101B)
      = const Tag.public("HardcopyDeviceManufacturerModelName", 0x0018101B,
          "Hardcopy Device Manufacturer's Model Name", VR.kLO, VM.k1, true);
  static const Tag kSoftwareVersions
      //(0018,1020)
      = const Tag.public("SoftwareVersions", 0x00181020, "Software Version(s)",
          VR.kLO, VM.k1_n, false);
  static const Tag kVideoImageFormatAcquired
      //(0018,1022)
      = const Tag.public("VideoImageFormatAcquired", 0x00181022,
          "Video Image Format Acquired", VR.kSH, VM.k1, false);
  static const Tag kDigitalImageFormatAcquired
      //(0018,1023)
      = const Tag.public("DigitalImageFormatAcquired", 0x00181023,
          "Digital Image Format Acquired", VR.kLO, VM.k1, false);
  static const Tag kProtocolName
      //(0018,1030)
      = const Tag.public(
          "ProtocolName", 0x00181030, "Protocol Name", VR.kLO, VM.k1, false);
  static const Tag kContrastBolusRoute
      //(0018,1040)
      = const Tag.public("ContrastBolusRoute", 0x00181040,
          "Contrast/Bolus Route", VR.kLO, VM.k1, false);
  static const Tag kContrastBolusVolume
      //(0018,1041)
      = const Tag.public("ContrastBolusVolume", 0x00181041,
          "Contrast/Bolus Volume", VR.kDS, VM.k1, false);
  static const Tag kContrastBolusStartTime
      //(0018,1042)
      = const Tag.public("ContrastBolusStartTime", 0x00181042,
          "Contrast/Bolus Start Time", VR.kTM, VM.k1, false);
  static const Tag kContrastBolusStopTime
      //(0018,1043)
      = const Tag.public("ContrastBolusStopTime", 0x00181043,
          "Contrast/Bolus Stop Time", VR.kTM, VM.k1, false);
  static const Tag kContrastBolusTotalDose
      //(0018,1044)
      = const Tag.public("ContrastBolusTotalDose", 0x00181044,
          "Contrast/Bolus Total Dose", VR.kDS, VM.k1, false);
  static const Tag kSyringeCounts
      //(0018,1045)
      = const Tag.public(
          "SyringeCounts", 0x00181045, "Syringe Counts", VR.kIS, VM.k1, false);
  static const Tag kContrastFlowRate
      //(0018,1046)
      = const Tag.public("ContrastFlowRate", 0x00181046, "Contrast Flow Rate",
          VR.kDS, VM.k1_n, false);
  static const Tag kContrastFlowDuration
      //(0018,1047)
      = const Tag.public("ContrastFlowDuration", 0x00181047,
          "Contrast Flow Duration", VR.kDS, VM.k1_n, false);
  static const Tag kContrastBolusIngredient
      //(0018,1048)
      = const Tag.public("ContrastBolusIngredient", 0x00181048,
          "Contrast/Bolus Ingredient", VR.kCS, VM.k1, false);
  static const Tag kContrastBolusIngredientConcentration
      //(0018,1049)
      = const Tag.public("ContrastBolusIngredientConcentration", 0x00181049,
          "Contrast/Bolus Ingredient Concentration", VR.kDS, VM.k1, false);
  static const Tag kSpatialResolution
      //(0018,1050)
      = const Tag.public("SpatialResolution", 0x00181050, "Spatial Resolution",
          VR.kDS, VM.k1, false);
  static const Tag kTriggerTime
      //(0018,1060)
      = const Tag.public(
          "TriggerTime", 0x00181060, "Trigger Time", VR.kDS, VM.k1, false);
  static const Tag kTriggerSourceOrType
      //(0018,1061)
      = const Tag.public("TriggerSourceOrType", 0x00181061,
          "Trigger Source or Type", VR.kLO, VM.k1, false);
  static const Tag kNominalInterval
      //(0018,1062)
      = const Tag.public("NominalInterval", 0x00181062, "Nominal Interval",
          VR.kIS, VM.k1, false);
  static const Tag kFrameTime
      //(0018,1063)
      = const Tag.public(
          "FrameTime", 0x00181063, "Frame Time", VR.kDS, VM.k1, false);
  static const Tag kCardiacFramingType
      //(0018,1064)
      = const Tag.public("CardiacFramingType", 0x00181064,
          "Cardiac Framing Type", VR.kLO, VM.k1, false);
  static const Tag kFrameTimeVector
      //(0018,1065)
      = const Tag.public("FrameTimeVector", 0x00181065, "Frame Time Vector",
          VR.kDS, VM.k1_n, false);
  static const Tag kFrameDelay
      //(0018,1066)
      = const Tag.public(
          "FrameDelay", 0x00181066, "Frame Delay", VR.kDS, VM.k1, false);
  static const Tag kImageTriggerDelay
      //(0018,1067)
      = const Tag.public("ImageTriggerDelay", 0x00181067, "Image Trigger Delay",
          VR.kDS, VM.k1, false);
  static const Tag kMultiplexGroupTimeOffset
      //(0018,1068)
      = const Tag.public("MultiplexGroupTimeOffset", 0x00181068,
          "Multiplex Group Time Offset", VR.kDS, VM.k1, false);
  static const Tag kTriggerTimeOffset
      //(0018,1069)
      = const Tag.public("TriggerTimeOffset", 0x00181069, "Trigger Time Offset",
          VR.kDS, VM.k1, false);
  static const Tag kSynchronizationTrigger
      //(0018,106A)
      = const Tag.public("SynchronizationTrigger", 0x0018106A,
          "Synchronization Trigger", VR.kCS, VM.k1, false);
  static const Tag kSynchronizationChannel
      //(0018,106C)
      = const Tag.public("SynchronizationChannel", 0x0018106C,
          "Synchronization Channel", VR.kUS, VM.k2, false);
  static const Tag kTriggerSamplePosition
      //(0018,106E)
      = const Tag.public("TriggerSamplePosition", 0x0018106E,
          "Trigger Sample Position", VR.kUL, VM.k1, false);
  static const Tag kRadiopharmaceuticalRoute
      //(0018,1070)
      = const Tag.public("RadiopharmaceuticalRoute", 0x00181070,
          "Radiopharmaceutical Route", VR.kLO, VM.k1, false);
  static const Tag kRadiopharmaceuticalVolume
      //(0018,1071)
      = const Tag.public("RadiopharmaceuticalVolume", 0x00181071,
          "Radiopharmaceutical Volume", VR.kDS, VM.k1, false);
  static const Tag kRadiopharmaceuticalStartTime
      //(0018,1072)
      = const Tag.public("RadiopharmaceuticalStartTime", 0x00181072,
          "Radiopharmaceutical Start Time", VR.kTM, VM.k1, false);
  static const Tag kRadiopharmaceuticalStopTime
      //(0018,1073)
      = const Tag.public("RadiopharmaceuticalStopTime", 0x00181073,
          "Radiopharmaceutical Stop Time", VR.kTM, VM.k1, false);
  static const Tag kRadionuclideTotalDose
      //(0018,1074)
      = const Tag.public("RadionuclideTotalDose", 0x00181074,
          "Radionuclide Total Dose", VR.kDS, VM.k1, false);
  static const Tag kRadionuclideHalfLife
      //(0018,1075)
      = const Tag.public("RadionuclideHalfLife", 0x00181075,
          "Radionuclide Half Life", VR.kDS, VM.k1, false);
  static const Tag kRadionuclidePositronFraction
      //(0018,1076)
      = const Tag.public("RadionuclidePositronFraction", 0x00181076,
          "Radionuclide Positron Fraction", VR.kDS, VM.k1, false);
  static const Tag kRadiopharmaceuticalSpecificActivity
      //(0018,1077)
      = const Tag.public("RadiopharmaceuticalSpecificActivity", 0x00181077,
          "Radiopharmaceutical Specific Activity", VR.kDS, VM.k1, false);
  static const Tag kRadiopharmaceuticalStartDateTime
      //(0018,1078)
      = const Tag.public("RadiopharmaceuticalStartDateTime", 0x00181078,
          "Radiopharmaceutical Start DateTime", VR.kDT, VM.k1, false);
  static const Tag kRadiopharmaceuticalStopDateTime
      //(0018,1079)
      = const Tag.public("RadiopharmaceuticalStopDateTime", 0x00181079,
          "Radiopharmaceutical Stop DateTime", VR.kDT, VM.k1, false);
  static const Tag kBeatRejectionFlag
      //(0018,1080)
      = const Tag.public("BeatRejectionFlag", 0x00181080, "Beat Rejection Flag",
          VR.kCS, VM.k1, false);
  static const Tag kLowRRValue
      //(0018,1081)
      = const Tag.public(
          "LowRRValue", 0x00181081, "Low R-R Value", VR.kIS, VM.k1, false);
  static const Tag kHighRRValue
      //(0018,1082)
      = const Tag.public(
          "HighRRValue", 0x00181082, "High R-R Value", VR.kIS, VM.k1, false);
  static const Tag kIntervalsAcquired
      //(0018,1083)
      = const Tag.public("IntervalsAcquired", 0x00181083, "Intervals Acquired",
          VR.kIS, VM.k1, false);
  static const Tag kIntervalsRejected
      //(0018,1084)
      = const Tag.public("IntervalsRejected", 0x00181084, "Intervals Rejected",
          VR.kIS, VM.k1, false);
  static const Tag kPVCRejection
      //(0018,1085)
      = const Tag.public(
          "PVCRejection", 0x00181085, "PVC Rejection", VR.kLO, VM.k1, false);
  static const Tag kSkipBeats
      //(0018,1086)
      = const Tag.public(
          "SkipBeats", 0x00181086, "Skip Beats", VR.kIS, VM.k1, false);
  static const Tag kHeartRate
      //(0018,1088)
      = const Tag.public(
          "HeartRate", 0x00181088, "Heart Rate", VR.kIS, VM.k1, false);
  static const Tag kCardiacNumberOfImages
      //(0018,1090)
      = const Tag.public("CardiacNumberOfImages", 0x00181090,
          "Cardiac Number of Images", VR.kIS, VM.k1, false);
  static const Tag kTriggerWindow
      //(0018,1094)
      = const Tag.public(
          "TriggerWindow", 0x00181094, "Trigger Window", VR.kIS, VM.k1, false);
  static const Tag kReconstructionDiameter
      //(0018,1100)
      = const Tag.public("ReconstructionDiameter", 0x00181100,
          "Reconstruction Diameter", VR.kDS, VM.k1, false);
  static const Tag kDistanceSourceToDetector
      //(0018,1110)
      = const Tag.public("DistanceSourceToDetector", 0x00181110,
          "Distance Source to Detector", VR.kDS, VM.k1, false);
  static const Tag kDistanceSourceToPatient
      //(0018,1111)
      = const Tag.public("DistanceSourceToPatient", 0x00181111,
          "Distance Source to Patient", VR.kDS, VM.k1, false);
  static const Tag kEstimatedRadiographicMagnificationFactor
      //(0018,1114)
      = const Tag.public("EstimatedRadiographicMagnificationFactor", 0x00181114,
          "Estimated Radiographic Magnification Factor", VR.kDS, VM.k1, false);
  static const Tag kGantryDetectorTilt
      //(0018,1120)
      = const Tag.public("GantryDetectorTilt", 0x00181120,
          "Gantry/Detector Tilt", VR.kDS, VM.k1, false);
  static const Tag kGantryDetectorSlew
      //(0018,1121)
      = const Tag.public("GantryDetectorSlew", 0x00181121,
          "Gantry/Detector Slew", VR.kDS, VM.k1, false);
  static const Tag kTableHeight
      //(0018,1130)
      = const Tag.public(
          "TableHeight", 0x00181130, "Table Height", VR.kDS, VM.k1, false);
  static const Tag kTableTraverse
      //(0018,1131)
      = const Tag.public(
          "TableTraverse", 0x00181131, "Table Traverse", VR.kDS, VM.k1, false);
  static const Tag kTableMotion
      //(0018,1134)
      = const Tag.public(
          "TableMotion", 0x00181134, "Table Motion", VR.kCS, VM.k1, false);
  static const Tag kTableVerticalIncrement
      //(0018,1135)
      = const Tag.public("TableVerticalIncrement", 0x00181135,
          "Table Vertical Increment", VR.kDS, VM.k1_n, false);
  static const Tag kTableLateralIncrement
      //(0018,1136)
      = const Tag.public("TableLateralIncrement", 0x00181136,
          "Table Lateral Increment", VR.kDS, VM.k1_n, false);
  static const Tag kTableLongitudinalIncrement
      //(0018,1137)
      = const Tag.public("TableLongitudinalIncrement", 0x00181137,
          "Table Longitudinal Increment", VR.kDS, VM.k1_n, false);
  static const Tag kTableAngle
      //(0018,1138)
      = const Tag.public(
          "TableAngle", 0x00181138, "Table Angle", VR.kDS, VM.k1, false);
  static const Tag kTableType
      //(0018,113A)
      = const Tag.public(
          "TableType", 0x0018113A, "Table Type", VR.kCS, VM.k1, false);
  static const Tag kRotationDirection
      //(0018,1140)
      = const Tag.public("RotationDirection", 0x00181140, "Rotation Direction",
          VR.kCS, VM.k1, false);
  static const Tag kAngularPosition
      //(0018,1141)
      = const Tag.public("AngularPosition", 0x00181141, "Angular Position",
          VR.kDS, VM.k1, true);
  static const Tag kRadialPosition
      //(0018,1142)
      = const Tag.public("RadialPosition", 0x00181142, "Radial Position",
          VR.kDS, VM.k1_n, false);
  static const Tag kScanArc
      //(0018,1143)
      =
      const Tag.public("ScanArc", 0x00181143, "Scan Arc", VR.kDS, VM.k1, false);
  static const Tag kAngularStep
      //(0018,1144)
      = const Tag.public(
          "AngularStep", 0x00181144, "Angular Step", VR.kDS, VM.k1, false);
  static const Tag kCenterOfRotationOffset
      //(0018,1145)
      = const Tag.public("CenterOfRotationOffset", 0x00181145,
          "Center of Rotation Offset", VR.kDS, VM.k1, false);
  static const Tag kRotationOffset
      //(0018,1146)
      = const Tag.public("RotationOffset", 0x00181146, "Rotation Offset",
          VR.kDS, VM.k1_n, true);
  static const Tag kFieldOfViewShape
      //(0018,1147)
      = const Tag.public("FieldOfViewShape", 0x00181147, "Field of View Shape",
          VR.kCS, VM.k1, false);
  static const Tag kFieldOfViewDimensions
      //(0018,1149)
      = const Tag.public("FieldOfViewDimensions", 0x00181149,
          "Field of View Dimension(s)", VR.kIS, VM.k1_2, false);
  static const Tag kExposureTime
      //(0018,1150)
      = const Tag.public(
          "ExposureTime", 0x00181150, "Exposure Time", VR.kIS, VM.k1, false);
  static const Tag kXRayTubeCurrent
      //(0018,1151)
      = const Tag.public("XRayTubeCurrent", 0x00181151, "X-Ray Tube Current",
          VR.kIS, VM.k1, false);
  static const Tag kExposure
      //(0018,1152)
      = const Tag.public(
          "Exposure", 0x00181152, "Exposure", VR.kIS, VM.k1, false);
  static const Tag kExposureInuAs
      //(0018,1153)
      = const Tag.public(
          "ExposureInuAs", 0x00181153, "Exposure in µAs", VR.kIS, VM.k1, false);
  static const Tag kAveragePulseWidth
      //(0018,1154)
      = const Tag.public("AveragePulseWidth", 0x00181154, "Average Pulse Width",
          VR.kDS, VM.k1, false);
  static const Tag kRadiationSetting
      //(0018,1155)
      = const Tag.public("RadiationSetting", 0x00181155, "Radiation Setting",
          VR.kCS, VM.k1, false);
  static const Tag kRectificationType
      //(0018,1156)
      = const Tag.public("RectificationType", 0x00181156, "Rectification Type",
          VR.kCS, VM.k1, false);
  static const Tag kRadiationMode
      //(0018,115A)
      = const Tag.public(
          "RadiationMode", 0x0018115A, "Radiation Mode", VR.kCS, VM.k1, false);
  static const Tag kImageAndFluoroscopyAreaDoseProduct
      //(0018,115E)
      = const Tag.public("ImageAndFluoroscopyAreaDoseProduct", 0x0018115E,
          "Image and Fluoroscopy Area Dose Product", VR.kDS, VM.k1, false);
  static const Tag kFilterType
      //(0018,1160)
      = const Tag.public(
          "FilterType", 0x00181160, "Filter Type", VR.kSH, VM.k1, false);
  static const Tag kTypeOfFilters
      //(0018,1161)
      = const Tag.public("TypeOfFilters", 0x00181161, "Type of Filters", VR.kLO,
          VM.k1_n, false);
  static const Tag kIntensifierSize
      //(0018,1162)
      = const Tag.public("IntensifierSize", 0x00181162, "Intensifier Size",
          VR.kDS, VM.k1, false);
  static const Tag kImagerPixelSpacing
      //(0018,1164)
      = const Tag.public("ImagerPixelSpacing", 0x00181164,
          "Imager Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kGrid
      //(0018,1166)
      = const Tag.public("Grid", 0x00181166, "Grid", VR.kCS, VM.k1_n, false);
  static const Tag kGeneratorPower
      //(0018,1170)
      = const Tag.public("GeneratorPower", 0x00181170, "Generator Power",
          VR.kIS, VM.k1, false);
  static const Tag kCollimatorGridName
      //(0018,1180)
      = const Tag.public("CollimatorGridName", 0x00181180,
          "Collimator/grid Name", VR.kSH, VM.k1, false);
  static const Tag kCollimatorType
      //(0018,1181)
      = const Tag.public("CollimatorType", 0x00181181, "Collimator Type",
          VR.kCS, VM.k1, false);
  static const Tag kFocalDistance
      //(0018,1182)
      = const Tag.public("FocalDistance", 0x00181182, "Focal Distance", VR.kIS,
          VM.k1_2, false);
  static const Tag kXFocusCenter
      //(0018,1183)
      = const Tag.public(
          "XFocusCenter", 0x00181183, "X Focus Center", VR.kDS, VM.k1_2, false);
  static const Tag kYFocusCenter
      //(0018,1184)
      = const Tag.public(
          "YFocusCenter", 0x00181184, "Y Focus Center", VR.kDS, VM.k1_2, false);
  static const Tag kFocalSpots
      //(0018,1190)
      = const Tag.public(
          "FocalSpots", 0x00181190, "Focal Spot(s)", VR.kDS, VM.k1_n, false);
  static const Tag kAnodeTargetMaterial
      //(0018,1191)
      = const Tag.public("AnodeTargetMaterial", 0x00181191,
          "Anode Target Material", VR.kCS, VM.k1, false);
  static const Tag kBodyPartThickness
      //(0018,11A0)
      = const Tag.public("BodyPartThickness", 0x001811A0, "Body Part Thickness",
          VR.kDS, VM.k1, false);
  static const Tag kCompressionForce
      //(0018,11A2)
      = const Tag.public("CompressionForce", 0x001811A2, "Compression Force",
          VR.kDS, VM.k1, false);
  static const Tag kPaddleDescription
      //(0018,11A4)
      = const Tag.public("PaddleDescription", 0x001811A4, "Paddle Description",
          VR.kLO, VM.k1, false);
  static const Tag kDateOfLastCalibration
      //(0018,1200)
      = const Tag.public("DateOfLastCalibration", 0x00181200,
          "Date of Last Calibration", VR.kDA, VM.k1_n, false);
  static const Tag kTimeOfLastCalibration
      //(0018,1201)
      = const Tag.public("TimeOfLastCalibration", 0x00181201,
          "Time of Last Calibration", VR.kTM, VM.k1_n, false);
  static const Tag kConvolutionKernel
      //(0018,1210)
      = const Tag.public("ConvolutionKernel", 0x00181210, "Convolution Kernel",
          VR.kSH, VM.k1_n, false);
  static const Tag kUpperLowerPixelValues
      //(0018,1240)
      = const Tag.public("UpperLowerPixelValues", 0x00181240,
          "Upper/Lower Pixel Values", VR.kIS, VM.k1_n, true);
  static const Tag kActualFrameDuration
      //(0018,1242)
      = const Tag.public("ActualFrameDuration", 0x00181242,
          "Actual Frame Duration", VR.kIS, VM.k1, false);
  static const Tag kCountRate
      //(0018,1243)
      = const Tag.public(
          "CountRate", 0x00181243, "Count Rate", VR.kIS, VM.k1, false);
  static const Tag kPreferredPlaybackSequencing
      //(0018,1244)
      = const Tag.public("PreferredPlaybackSequencing", 0x00181244,
          "Preferred Playback Sequencing", VR.kUS, VM.k1, false);
  static const Tag kReceiveCoilName
      //(0018,1250)
      = const Tag.public("ReceiveCoilName", 0x00181250, "Receive Coil Name",
          VR.kSH, VM.k1, false);
  static const Tag kTransmitCoilName
      //(0018,1251)
      = const Tag.public("TransmitCoilName", 0x00181251, "Transmit Coil Name",
          VR.kSH, VM.k1, false);
  static const Tag kPlateType
      //(0018,1260)
      = const Tag.public(
          "PlateType", 0x00181260, "Plate Type", VR.kSH, VM.k1, false);
  static const Tag kPhosphorType
      //(0018,1261)
      = const Tag.public(
          "PhosphorType", 0x00181261, "Phosphor Type", VR.kLO, VM.k1, false);
  static const Tag kScanVelocity
      //(0018,1300)
      = const Tag.public(
          "ScanVelocity", 0x00181300, "Scan Velocity", VR.kDS, VM.k1, false);
  static const Tag kWholeBodyTechnique
      //(0018,1301)
      = const Tag.public("WholeBodyTechnique", 0x00181301,
          "Whole Body Technique", VR.kCS, VM.k1_n, false);
  static const Tag kScanLength
      //(0018,1302)
      = const Tag.public(
          "ScanLength", 0x00181302, "Scan Length", VR.kIS, VM.k1, false);
  static const Tag kAcquisitionMatrix
      //(0018,1310)
      = const Tag.public("AcquisitionMatrix", 0x00181310, "Acquisition Matrix",
          VR.kUS, VM.k4, false);
  static const Tag kInPlanePhaseEncodingDirection
      //(0018,1312)
      = const Tag.public("InPlanePhaseEncodingDirection", 0x00181312,
          "In-plane Phase Encoding Direction", VR.kCS, VM.k1, false);
  static const Tag kFlipAngle
      //(0018,1314)
      = const Tag.public(
          "FlipAngle", 0x00181314, "Flip Angle", VR.kDS, VM.k1, false);
  static const Tag kVariableFlipAngleFlag
      //(0018,1315)
      = const Tag.public("VariableFlipAngleFlag", 0x00181315,
          "Variable Flip Angle Flag", VR.kCS, VM.k1, false);
  static const Tag kSAR
      //(0018,1316)
      = const Tag.public("SAR", 0x00181316, "SAR", VR.kDS, VM.k1, false);
  static const Tag kdBdt
      //(0018,1318)
      = const Tag.public("dBdt", 0x00181318, "dB/dt", VR.kDS, VM.k1, false);
  static const Tag kAcquisitionDeviceProcessingDescription
      //(0018,1400)
      = const Tag.public("AcquisitionDeviceProcessingDescription", 0x00181400,
          "Acquisition Device Processing Description", VR.kLO, VM.k1, false);
  static const Tag kAcquisitionDeviceProcessingCode
      //(0018,1401)
      = const Tag.public("AcquisitionDeviceProcessingCode", 0x00181401,
          "Acquisition Device Processing Code", VR.kLO, VM.k1, false);
  static const Tag kCassetteOrientation
      //(0018,1402)
      = const Tag.public("CassetteOrientation", 0x00181402,
          "Cassette Orientation", VR.kCS, VM.k1, false);
  static const Tag kCassetteSize
      //(0018,1403)
      = const Tag.public(
          "CassetteSize", 0x00181403, "Cassette Size", VR.kCS, VM.k1, false);
  static const Tag kExposuresOnPlate
      //(0018,1404)
      = const Tag.public("ExposuresOnPlate", 0x00181404, "Exposures on Plate",
          VR.kUS, VM.k1, false);
  static const Tag kRelativeXRayExposure
      //(0018,1405)
      = const Tag.public("RelativeXRayExposure", 0x00181405,
          "Relative X-Ray Exposure", VR.kIS, VM.k1, false);
  static const Tag kExposureIndex
      //(0018,1411)
      = const Tag.public(
          "ExposureIndex", 0x00181411, "Exposure Index", VR.kDS, VM.k1, false);
  static const Tag kTargetExposureIndex
      //(0018,1412)
      = const Tag.public("TargetExposureIndex", 0x00181412,
          "Target Exposure Index", VR.kDS, VM.k1, false);
  static const Tag kDeviationIndex
      //(0018,1413)
      = const Tag.public("DeviationIndex", 0x00181413, "Deviation Index",
          VR.kDS, VM.k1, false);
  static const Tag kColumnAngulation
      //(0018,1450)
      = const Tag.public("ColumnAngulation", 0x00181450, "Column Angulation",
          VR.kDS, VM.k1, false);
  static const Tag kTomoLayerHeight
      //(0018,1460)
      = const Tag.public("TomoLayerHeight", 0x00181460, "Tomo Layer Height",
          VR.kDS, VM.k1, false);
  static const Tag kTomoAngle
      //(0018,1470)
      = const Tag.public(
          "TomoAngle", 0x00181470, "Tomo Angle", VR.kDS, VM.k1, false);
  static const Tag kTomoTime
      //(0018,1480)
      = const Tag.public(
          "TomoTime", 0x00181480, "Tomo Time", VR.kDS, VM.k1, false);
  static const Tag kTomoType
      //(0018,1490)
      = const Tag.public(
          "TomoType", 0x00181490, "Tomo Type", VR.kCS, VM.k1, false);
  static const Tag kTomoClass
      //(0018,1491)
      = const Tag.public(
          "TomoClass", 0x00181491, "Tomo Class", VR.kCS, VM.k1, false);
  static const Tag kNumberOfTomosynthesisSourceImages
      //(0018,1495)
      = const Tag.public("NumberOfTomosynthesisSourceImages", 0x00181495,
          "Number of Tomosynthesis Source Images", VR.kIS, VM.k1, false);
  static const Tag kPositionerMotion
      //(0018,1500)
      = const Tag.public("PositionerMotion", 0x00181500, "Positioner Motion",
          VR.kCS, VM.k1, false);
  static const Tag kPositionerType
      //(0018,1508)
      = const Tag.public("PositionerType", 0x00181508, "Positioner Type",
          VR.kCS, VM.k1, false);
  static const Tag kPositionerPrimaryAngle
      //(0018,1510)
      = const Tag.public("PositionerPrimaryAngle", 0x00181510,
          "Positioner Primary Angle", VR.kDS, VM.k1, false);
  static const Tag kPositionerSecondaryAngle
      //(0018,1511)
      = const Tag.public("PositionerSecondaryAngle", 0x00181511,
          "Positioner Secondary Angle", VR.kDS, VM.k1, false);
  static const Tag kPositionerPrimaryAngleIncrement
      //(0018,1520)
      = const Tag.public("PositionerPrimaryAngleIncrement", 0x00181520,
          "Positioner Primary Angle Increment", VR.kDS, VM.k1_n, false);
  static const Tag kPositionerSecondaryAngleIncrement
      //(0018,1521)
      = const Tag.public("PositionerSecondaryAngleIncrement", 0x00181521,
          "Positioner Secondary Angle Increment", VR.kDS, VM.k1_n, false);
  static const Tag kDetectorPrimaryAngle
      //(0018,1530)
      = const Tag.public("DetectorPrimaryAngle", 0x00181530,
          "Detector Primary Angle", VR.kDS, VM.k1, false);
  static const Tag kDetectorSecondaryAngle
      //(0018,1531)
      = const Tag.public("DetectorSecondaryAngle", 0x00181531,
          "Detector Secondary Angle", VR.kDS, VM.k1, false);
  static const Tag kShutterShape
      //(0018,1600)
      = const Tag.public(
          "ShutterShape", 0x00181600, "Shutter Shape", VR.kCS, VM.k1_3, false);
  static const Tag kShutterLeftVerticalEdge
      //(0018,1602)
      = const Tag.public("ShutterLeftVerticalEdge", 0x00181602,
          "Shutter Left Vertical Edge", VR.kIS, VM.k1, false);
  static const Tag kShutterRightVerticalEdge
      //(0018,1604)
      = const Tag.public("ShutterRightVerticalEdge", 0x00181604,
          "Shutter Right Vertical Edge", VR.kIS, VM.k1, false);
  static const Tag kShutterUpperHorizontalEdge
      //(0018,1606)
      = const Tag.public("ShutterUpperHorizontalEdge", 0x00181606,
          "Shutter Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const Tag kShutterLowerHorizontalEdge
      //(0018,1608)
      = const Tag.public("ShutterLowerHorizontalEdge", 0x00181608,
          "Shutter Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const Tag kCenterOfCircularShutter
      //(0018,1610)
      = const Tag.public("CenterOfCircularShutter", 0x00181610,
          "Center of Circular Shutter", VR.kIS, VM.k2, false);
  static const Tag kRadiusOfCircularShutter
      //(0018,1612)
      = const Tag.public("RadiusOfCircularShutter", 0x00181612,
          "Radius of Circular Shutter", VR.kIS, VM.k1, false);
  static const Tag kVerticesOfThePolygonalShutter
      //(0018,1620)
      = const Tag.public("VerticesOfThePolygonalShutter", 0x00181620,
          "Vertices of the Polygonal Shutter", VR.kIS, VM.k2_2n, false);
  static const Tag kShutterPresentationValue
      //(0018,1622)
      = const Tag.public("ShutterPresentationValue", 0x00181622,
          "Shutter Presentation Value", VR.kUS, VM.k1, false);
  static const Tag kShutterOverlayGroup
      //(0018,1623)
      = const Tag.public("ShutterOverlayGroup", 0x00181623,
          "Shutter Overlay Group", VR.kUS, VM.k1, false);
  static const Tag kShutterPresentationColorCIELabValue
      //(0018,1624)
      = const Tag.public("ShutterPresentationColorCIELabValue", 0x00181624,
          "Shutter Presentation Color CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kCollimatorShape
      //(0018,1700)
      = const Tag.public("CollimatorShape", 0x00181700, "Collimator Shape",
          VR.kCS, VM.k1_3, false);
  static const Tag kCollimatorLeftVerticalEdge
      //(0018,1702)
      = const Tag.public("CollimatorLeftVerticalEdge", 0x00181702,
          "Collimator Left Vertical Edge", VR.kIS, VM.k1, false);
  static const Tag kCollimatorRightVerticalEdge
      //(0018,1704)
      = const Tag.public("CollimatorRightVerticalEdge", 0x00181704,
          "Collimator Right Vertical Edge", VR.kIS, VM.k1, false);
  static const Tag kCollimatorUpperHorizontalEdge
      //(0018,1706)
      = const Tag.public("CollimatorUpperHorizontalEdge", 0x00181706,
          "Collimator Upper Horizontal Edge", VR.kIS, VM.k1, false);
  static const Tag kCollimatorLowerHorizontalEdge
      //(0018,1708)
      = const Tag.public("CollimatorLowerHorizontalEdge", 0x00181708,
          "Collimator Lower Horizontal Edge", VR.kIS, VM.k1, false);
  static const Tag kCenterOfCircularCollimator
      //(0018,1710)
      = const Tag.public("CenterOfCircularCollimator", 0x00181710,
          "Center of Circular Collimator", VR.kIS, VM.k2, false);
  static const Tag kRadiusOfCircularCollimator
      //(0018,1712)
      = const Tag.public("RadiusOfCircularCollimator", 0x00181712,
          "Radius of Circular Collimator", VR.kIS, VM.k1, false);
  static const Tag kVerticesOfThePolygonalCollimator
      //(0018,1720)
      = const Tag.public("VerticesOfThePolygonalCollimator", 0x00181720,
          "Vertices of the Polygonal Collimator", VR.kIS, VM.k2_2n, false);
  static const Tag kAcquisitionTimeSynchronized
      //(0018,1800)
      = const Tag.public("AcquisitionTimeSynchronized", 0x00181800,
          "Acquisition Time Synchronized", VR.kCS, VM.k1, false);
  static const Tag kTimeSource
      //(0018,1801)
      = const Tag.public(
          "TimeSource", 0x00181801, "Time Source", VR.kSH, VM.k1, false);
  static const Tag kTimeDistributionProtocol
      //(0018,1802)
      = const Tag.public("TimeDistributionProtocol", 0x00181802,
          "Time Distribution Protocol", VR.kCS, VM.k1, false);
  static const Tag kNTPSourceAddress
      //(0018,1803)
      = const Tag.public("NTPSourceAddress", 0x00181803, "NTP Source Address",
          VR.kLO, VM.k1, false);
  static const Tag kPageNumberVector
      //(0018,2001)
      = const Tag.public("PageNumberVector", 0x00182001, "Page Number Vector",
          VR.kIS, VM.k1_n, false);
  static const Tag kFrameLabelVector
      //(0018,2002)
      = const Tag.public("FrameLabelVector", 0x00182002, "Frame Label Vector",
          VR.kSH, VM.k1_n, false);
  static const Tag kFramePrimaryAngleVector
      //(0018,2003)
      = const Tag.public("FramePrimaryAngleVector", 0x00182003,
          "Frame Primary Angle Vector", VR.kDS, VM.k1_n, false);
  static const Tag kFrameSecondaryAngleVector
      //(0018,2004)
      = const Tag.public("FrameSecondaryAngleVector", 0x00182004,
          "Frame Secondary Angle Vector", VR.kDS, VM.k1_n, false);
  static const Tag kSliceLocationVector
      //(0018,2005)
      = const Tag.public("SliceLocationVector", 0x00182005,
          "Slice Location Vector", VR.kDS, VM.k1_n, false);
  static const Tag kDisplayWindowLabelVector
      //(0018,2006)
      = const Tag.public("DisplayWindowLabelVector", 0x00182006,
          "Display Window Label Vector", VR.kSH, VM.k1_n, false);
  static const Tag kNominalScannedPixelSpacing
      //(0018,2010)
      = const Tag.public("NominalScannedPixelSpacing", 0x00182010,
          "Nominal Scanned Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kDigitizingDeviceTransportDirection
      //(0018,2020)
      = const Tag.public("DigitizingDeviceTransportDirection", 0x00182020,
          "Digitizing Device Transport Direction", VR.kCS, VM.k1, false);
  static const Tag kRotationOfScannedFilm
      //(0018,2030)
      = const Tag.public("RotationOfScannedFilm", 0x00182030,
          "Rotation of Scanned Film", VR.kDS, VM.k1, false);
  static const Tag kBiopsyTargetSequence
      //(0018,2041)
      = const Tag.public("BiopsyTargetSequence", 0x00182041,
          "Biopsy Target Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTargetUID
      //(0018,2042)
      = const Tag.public(
          "TargetUID", 0x00182042, "Target UID", VR.kUI, VM.k1, false);
  static const Tag kLocalizingCursorPosition
      //(0018,2043)
      = const Tag.public("LocalizingCursorPosition", 0x00182043,
          "Localizing Cursor Position", VR.kFL, VM.k2, false);
  static const Tag kCalculatedTargetPosition
      //(0018,2044)
      = const Tag.public("CalculatedTargetPosition", 0x00182044,
          "Calculated Target Position", VR.kFL, VM.k3, false);
  static const Tag kTargetLabel
      //(0018,2045)
      = const Tag.public(
          "TargetLabel", 0x00182045, "Target Label", VR.kSH, VM.k1, false);
  static const Tag kDisplayedZValue
      //(0018,2046)
      = const Tag.public("DisplayedZValue", 0x00182046, "Displayed Z Value",
          VR.kFL, VM.k1, false);
  static const Tag kIVUSAcquisition
      //(0018,3100)
      = const Tag.public("IVUSAcquisition", 0x00183100, "IVUS Acquisition",
          VR.kCS, VM.k1, false);
  static const Tag kIVUSPullbackRate
      //(0018,3101)
      = const Tag.public("IVUSPullbackRate", 0x00183101, "IVUS Pullback Rate",
          VR.kDS, VM.k1, false);
  static const Tag kIVUSGatedRate
      //(0018,3102)
      = const Tag.public(
          "IVUSGatedRate", 0x00183102, "IVUS Gated Rate", VR.kDS, VM.k1, false);
  static const Tag kIVUSPullbackStartFrameNumber
      //(0018,3103)
      = const Tag.public("IVUSPullbackStartFrameNumber", 0x00183103,
          "IVUS Pullback Start Frame Number", VR.kIS, VM.k1, false);
  static const Tag kIVUSPullbackStopFrameNumber
      //(0018,3104)
      = const Tag.public("IVUSPullbackStopFrameNumber", 0x00183104,
          "IVUS Pullback Stop Frame Number", VR.kIS, VM.k1, false);
  static const Tag kLesionNumber
      //(0018,3105)
      = const Tag.public(
          "LesionNumber", 0x00183105, "Lesion Number", VR.kIS, VM.k1_n, false);
  static const Tag kAcquisitionComments
      //(0018,4000)
      = const Tag.public("AcquisitionComments", 0x00184000,
          "Acquisition Comments", VR.kLT, VM.k1, true);
  static const Tag kOutputPower
      //(0018,5000)
      = const Tag.public(
          "OutputPower", 0x00185000, "Output Power", VR.kSH, VM.k1_n, false);
  static const Tag kTransducerData
      //(0018,5010)
      = const Tag.public("TransducerData", 0x00185010, "Transducer Data",
          VR.kLO, VM.k1_n, false);
  static const Tag kFocusDepth
      //(0018,5012)
      = const Tag.public(
          "FocusDepth", 0x00185012, "Focus Depth", VR.kDS, VM.k1, false);
  static const Tag kProcessingFunction
      //(0018,5020)
      = const Tag.public("ProcessingFunction", 0x00185020,
          "Processing Function", VR.kLO, VM.k1, false);
  static const Tag kPostprocessingFunction
      //(0018,5021)
      = const Tag.public("PostprocessingFunction", 0x00185021,
          "Postprocessing Function", VR.kLO, VM.k1, true);
  static const Tag kMechanicalIndex
      //(0018,5022)
      = const Tag.public("MechanicalIndex", 0x00185022, "Mechanical Index",
          VR.kDS, VM.k1, false);
  static const Tag kBoneThermalIndex
      //(0018,5024)
      = const Tag.public("BoneThermalIndex", 0x00185024, "Bone Thermal Index",
          VR.kDS, VM.k1, false);
  static const Tag kCranialThermalIndex
      //(0018,5026)
      = const Tag.public("CranialThermalIndex", 0x00185026,
          "Cranial Thermal Index", VR.kDS, VM.k1, false);
  static const Tag kSoftTissueThermalIndex
      //(0018,5027)
      = const Tag.public("SoftTissueThermalIndex", 0x00185027,
          "Soft Tissue Thermal Index", VR.kDS, VM.k1, false);
  static const Tag kSoftTissueFocusThermalIndex
      //(0018,5028)
      = const Tag.public("SoftTissueFocusThermalIndex", 0x00185028,
          "Soft Tissue-focus Thermal Index", VR.kDS, VM.k1, false);
  static const Tag kSoftTissueSurfaceThermalIndex
      //(0018,5029)
      = const Tag.public("SoftTissueSurfaceThermalIndex", 0x00185029,
          "Soft Tissue-surface Thermal Index", VR.kDS, VM.k1, false);
  static const Tag kDynamicRange
      //(0018,5030)
      = const Tag.public(
          "DynamicRange", 0x00185030, "Dynamic Range", VR.kDS, VM.k1, true);
  static const Tag kTotalGain
      //(0018,5040)
      = const Tag.public(
          "TotalGain", 0x00185040, "Total Gain", VR.kDS, VM.k1, true);
  static const Tag kDepthOfScanField
      //(0018,5050)
      = const Tag.public("DepthOfScanField", 0x00185050, "Depth of Scan Field",
          VR.kIS, VM.k1, false);
  static const Tag kPatientPosition
      //(0018,5100)
      = const Tag.public("PatientPosition", 0x00185100, "Patient Position",
          VR.kCS, VM.k1, false);
  static const Tag kViewPosition
      //(0018,5101)
      = const Tag.public(
          "ViewPosition", 0x00185101, "View Position", VR.kCS, VM.k1, false);
  static const Tag kProjectionEponymousNameCodeSequence
      //(0018,5104)
      = const Tag.public("ProjectionEponymousNameCodeSequence", 0x00185104,
          "Projection Eponymous Name Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageTransformationMatrix
      //(0018,5210)
      = const Tag.public("ImageTransformationMatrix", 0x00185210,
          "Image Transformation Matrix", VR.kDS, VM.k6, true);
  static const Tag kImageTranslationVector
      //(0018,5212)
      = const Tag.public("ImageTranslationVector", 0x00185212,
          "Image Translation Vector", VR.kDS, VM.k3, true);
  static const Tag kSensitivity
      //(0018,6000)
      = const Tag.public(
          "Sensitivity", 0x00186000, "Sensitivity", VR.kDS, VM.k1, false);
  static const Tag kSequenceOfUltrasoundRegions
      //(0018,6011)
      = const Tag.public("SequenceOfUltrasoundRegions", 0x00186011,
          "Sequence of Ultrasound Regions", VR.kSQ, VM.k1, false);
  static const Tag kRegionSpatialFormat
      //(0018,6012)
      = const Tag.public("RegionSpatialFormat", 0x00186012,
          "Region Spatial Format", VR.kUS, VM.k1, false);
  static const Tag kRegionDataType
      //(0018,6014)
      = const Tag.public("RegionDataType", 0x00186014, "Region Data Type",
          VR.kUS, VM.k1, false);
  static const Tag kRegionFlags
      //(0018,6016)
      = const Tag.public(
          "RegionFlags", 0x00186016, "Region Flags", VR.kUL, VM.k1, false);
  static const Tag kRegionLocationMinX0
      //(0018,6018)
      = const Tag.public("RegionLocationMinX0", 0x00186018,
          "Region Location Min X0", VR.kUL, VM.k1, false);
  static const Tag kRegionLocationMinY0
      //(0018,601A)
      = const Tag.public("RegionLocationMinY0", 0x0018601A,
          "Region Location Min Y0", VR.kUL, VM.k1, false);
  static const Tag kRegionLocationMaxX1
      //(0018,601C)
      = const Tag.public("RegionLocationMaxX1", 0x0018601C,
          "Region Location Max X1", VR.kUL, VM.k1, false);
  static const Tag kRegionLocationMaxY1
      //(0018,601E)
      = const Tag.public("RegionLocationMaxY1", 0x0018601E,
          "Region Location Max Y1", VR.kUL, VM.k1, false);
  static const Tag kReferencePixelX0
      //(0018,6020)
      = const Tag.public("ReferencePixelX0", 0x00186020, "Reference Pixel X0",
          VR.kSL, VM.k1, false);
  static const Tag kReferencePixelY0
      //(0018,6022)
      = const Tag.public("ReferencePixelY0", 0x00186022, "Reference Pixel Y0",
          VR.kSL, VM.k1, false);
  static const Tag kPhysicalUnitsXDirection
      //(0018,6024)
      = const Tag.public("PhysicalUnitsXDirection", 0x00186024,
          "Physical Units X Direction", VR.kUS, VM.k1, false);
  static const Tag kPhysicalUnitsYDirection
      //(0018,6026)
      = const Tag.public("PhysicalUnitsYDirection", 0x00186026,
          "Physical Units Y Direction", VR.kUS, VM.k1, false);
  static const Tag kReferencePixelPhysicalValueX
      //(0018,6028)
      = const Tag.public("ReferencePixelPhysicalValueX", 0x00186028,
          "Reference Pixel Physical Value X", VR.kFD, VM.k1, false);
  static const Tag kReferencePixelPhysicalValueY
      //(0018,602A)
      = const Tag.public("ReferencePixelPhysicalValueY", 0x0018602A,
          "Reference Pixel Physical Value Y", VR.kFD, VM.k1, false);
  static const Tag kPhysicalDeltaX
      //(0018,602C)
      = const Tag.public("PhysicalDeltaX", 0x0018602C, "Physical Delta X",
          VR.kFD, VM.k1, false);
  static const Tag kPhysicalDeltaY
      //(0018,602E)
      = const Tag.public("PhysicalDeltaY", 0x0018602E, "Physical Delta Y",
          VR.kFD, VM.k1, false);
  static const Tag kTransducerFrequency
      //(0018,6030)
      = const Tag.public("TransducerFrequency", 0x00186030,
          "Transducer Frequency", VR.kUL, VM.k1, false);
  static const Tag kTransducerType
      //(0018,6031)
      = const Tag.public("TransducerType", 0x00186031, "Transducer Type",
          VR.kCS, VM.k1, false);
  static const Tag kPulseRepetitionFrequency
      //(0018,6032)
      = const Tag.public("PulseRepetitionFrequency", 0x00186032,
          "Pulse Repetition Frequency", VR.kUL, VM.k1, false);
  static const Tag kDopplerCorrectionAngle
      //(0018,6034)
      = const Tag.public("DopplerCorrectionAngle", 0x00186034,
          "Doppler Correction Angle", VR.kFD, VM.k1, false);
  static const Tag kSteeringAngle
      //(0018,6036)
      = const Tag.public(
          "SteeringAngle", 0x00186036, "Steering Angle", VR.kFD, VM.k1, false);
  static const Tag kDopplerSampleVolumeXPositionRetired
      //(0018,6038)
      = const Tag.public("DopplerSampleVolumeXPositionRetired", 0x00186038,
          "Doppler Sample Volume X Position (Retired)", VR.kUL, VM.k1, true);
  static const Tag kDopplerSampleVolumeXPosition
      //(0018,6039)
      = const Tag.public("DopplerSampleVolumeXPosition", 0x00186039,
          "Doppler Sample Volume X Position", VR.kSL, VM.k1, false);
  static const Tag kDopplerSampleVolumeYPositionRetired
      //(0018,603A)
      = const Tag.public("DopplerSampleVolumeYPositionRetired", 0x0018603A,
          "Doppler Sample Volume Y Position (Retired)", VR.kUL, VM.k1, true);
  static const Tag kDopplerSampleVolumeYPosition
      //(0018,603B)
      = const Tag.public("DopplerSampleVolumeYPosition", 0x0018603B,
          "Doppler Sample Volume Y Position", VR.kSL, VM.k1, false);
  static const Tag kTMLinePositionX0Retired
      //(0018,603C)
      = const Tag.public("TMLinePositionX0Retired", 0x0018603C,
          "TM-Line Position X0 (Retired)", VR.kUL, VM.k1, true);
  static const Tag kTMLinePositionX0
      //(0018,603D)
      = const Tag.public("TMLinePositionX0", 0x0018603D, "TM-Line Position X0",
          VR.kSL, VM.k1, false);
  static const Tag kTMLinePositionY0Retired
      //(0018,603E)
      = const Tag.public("TMLinePositionY0Retired", 0x0018603E,
          "TM-Line Position Y0 (Retired)", VR.kUL, VM.k1, true);
  static const Tag kTMLinePositionY0
      //(0018,603F)
      = const Tag.public("TMLinePositionY0", 0x0018603F, "TM-Line Position Y0",
          VR.kSL, VM.k1, false);
  static const Tag kTMLinePositionX1Retired
      //(0018,6040)
      = const Tag.public("TMLinePositionX1Retired", 0x00186040,
          "TM-Line Position X1 (Retired)", VR.kUL, VM.k1, true);
  static const Tag kTMLinePositionX1
      //(0018,6041)
      = const Tag.public("TMLinePositionX1", 0x00186041, "TM-Line Position X1",
          VR.kSL, VM.k1, false);
  static const Tag kTMLinePositionY1Retired
      //(0018,6042)
      = const Tag.public("TMLinePositionY1Retired", 0x00186042,
          "TM-Line Position Y1 (Retired)", VR.kUL, VM.k1, true);
  static const Tag kTMLinePositionY1
      //(0018,6043)
      = const Tag.public("TMLinePositionY1", 0x00186043, "TM-Line Position Y1",
          VR.kSL, VM.k1, false);
  static const Tag kPixelComponentOrganization
      //(0018,6044)
      = const Tag.public("PixelComponentOrganization", 0x00186044,
          "Pixel Component Organization", VR.kUS, VM.k1, false);
  static const Tag kPixelComponentMask
      //(0018,6046)
      = const Tag.public("PixelComponentMask", 0x00186046,
          "Pixel Component Mask", VR.kUL, VM.k1, false);
  static const Tag kPixelComponentRangeStart
      //(0018,6048)
      = const Tag.public("PixelComponentRangeStart", 0x00186048,
          "Pixel Component Range Start", VR.kUL, VM.k1, false);
  static const Tag kPixelComponentRangeStop
      //(0018,604A)
      = const Tag.public("PixelComponentRangeStop", 0x0018604A,
          "Pixel Component Range Stop", VR.kUL, VM.k1, false);
  static const Tag kPixelComponentPhysicalUnits
      //(0018,604C)
      = const Tag.public("PixelComponentPhysicalUnits", 0x0018604C,
          "Pixel Component Physical Units", VR.kUS, VM.k1, false);
  static const Tag kPixelComponentDataType
      //(0018,604E)
      = const Tag.public("PixelComponentDataType", 0x0018604E,
          "Pixel Component Data Type", VR.kUS, VM.k1, false);
  static const Tag kNumberOfTableBreakPoints
      //(0018,6050)
      = const Tag.public("NumberOfTableBreakPoints", 0x00186050,
          "Number of Table Break Points", VR.kUL, VM.k1, false);
  static const Tag kTableOfXBreakPoints
      //(0018,6052)
      = const Tag.public("TableOfXBreakPoints", 0x00186052,
          "Table of X Break Points", VR.kUL, VM.k1_n, false);
  static const Tag kTableOfYBreakPoints
      //(0018,6054)
      = const Tag.public("TableOfYBreakPoints", 0x00186054,
          "Table of Y Break Points", VR.kFD, VM.k1_n, false);
  static const Tag kNumberOfTableEntries
      //(0018,6056)
      = const Tag.public("NumberOfTableEntries", 0x00186056,
          "Number of Table Entries", VR.kUL, VM.k1, false);
  static const Tag kTableOfPixelValues
      //(0018,6058)
      = const Tag.public("TableOfPixelValues", 0x00186058,
          "Table of Pixel Values", VR.kUL, VM.k1_n, false);
  static const Tag kTableOfParameterValues
      //(0018,605A)
      = const Tag.public("TableOfParameterValues", 0x0018605A,
          "Table of Parameter Values", VR.kFL, VM.k1_n, false);
  static const Tag kRWaveTimeVector
      //(0018,6060)
      = const Tag.public("RWaveTimeVector", 0x00186060, "R Wave Time Vector",
          VR.kFL, VM.k1_n, false);
  static const Tag kDetectorConditionsNominalFlag
      //(0018,7000)
      = const Tag.public("DetectorConditionsNominalFlag", 0x00187000,
          "Detector Conditions Nominal Flag", VR.kCS, VM.k1, false);
  static const Tag kDetectorTemperature
      //(0018,7001)
      = const Tag.public("DetectorTemperature", 0x00187001,
          "Detector Temperature", VR.kDS, VM.k1, false);
  static const Tag kDetectorType
      //(0018,7004)
      = const Tag.public(
          "DetectorType", 0x00187004, "Detector Type", VR.kCS, VM.k1, false);
  static const Tag kDetectorConfiguration
      //(0018,7005)
      = const Tag.public("DetectorConfiguration", 0x00187005,
          "Detector Configuration", VR.kCS, VM.k1, false);
  static const Tag kDetectorDescription
      //(0018,7006)
      = const Tag.public("DetectorDescription", 0x00187006,
          "Detector Description", VR.kLT, VM.k1, false);
  static const Tag kDetectorMode
      //(0018,7008)
      = const Tag.public(
          "DetectorMode", 0x00187008, "Detector Mode", VR.kLT, VM.k1, false);
  static const Tag kDetectorID
      //(0018,700A)
      = const Tag.public(
          "DetectorID", 0x0018700A, "Detector ID", VR.kSH, VM.k1, false);
  static const Tag kDateOfLastDetectorCalibration
      //(0018,700C)
      = const Tag.public("DateOfLastDetectorCalibration", 0x0018700C,
          "Date of Last Detector Calibration", VR.kDA, VM.k1, false);
  static const Tag kTimeOfLastDetectorCalibration
      //(0018,700E)
      = const Tag.public("TimeOfLastDetectorCalibration", 0x0018700E,
          "Time of Last Detector Calibration", VR.kTM, VM.k1, false);
  static const Tag kExposuresOnDetectorSinceLastCalibration
      //(0018,7010)
      = const Tag.public("ExposuresOnDetectorSinceLastCalibration", 0x00187010,
          "Exposures on Detector Since Last Calibration", VR.kIS, VM.k1, false);
  static const Tag kExposuresOnDetectorSinceManufactured
      //(0018,7011)
      = const Tag.public("ExposuresOnDetectorSinceManufactured", 0x00187011,
          "Exposures on Detector Since Manufactured", VR.kIS, VM.k1, false);
  static const Tag kDetectorTimeSinceLastExposure
      //(0018,7012)
      = const Tag.public("DetectorTimeSinceLastExposure", 0x00187012,
          "Detector Time Since Last Exposure", VR.kDS, VM.k1, false);
  static const Tag kDetectorActiveTime
      //(0018,7014)
      = const Tag.public("DetectorActiveTime", 0x00187014,
          "Detector Active Time", VR.kDS, VM.k1, false);
  static const Tag kDetectorActivationOffsetFromExposure
      //(0018,7016)
      = const Tag.public("DetectorActivationOffsetFromExposure", 0x00187016,
          "Detector Activation Offset From Exposure", VR.kDS, VM.k1, false);
  static const Tag kDetectorBinning
      //(0018,701A)
      = const Tag.public("DetectorBinning", 0x0018701A, "Detector Binning",
          VR.kDS, VM.k2, false);
  static const Tag kDetectorElementPhysicalSize
      //(0018,7020)
      = const Tag.public("DetectorElementPhysicalSize", 0x00187020,
          "Detector Element Physical Size", VR.kDS, VM.k2, false);
  static const Tag kDetectorElementSpacing
      //(0018,7022)
      = const Tag.public("DetectorElementSpacing", 0x00187022,
          "Detector Element Spacing", VR.kDS, VM.k2, false);
  static const Tag kDetectorActiveShape
      //(0018,7024)
      = const Tag.public("DetectorActiveShape", 0x00187024,
          "Detector Active Shape", VR.kCS, VM.k1, false);
  static const Tag kDetectorActiveDimensions
      //(0018,7026)
      = const Tag.public("DetectorActiveDimensions", 0x00187026,
          "Detector Active Dimension(s)", VR.kDS, VM.k1_2, false);
  static const Tag kDetectorActiveOrigin
      //(0018,7028)
      = const Tag.public("DetectorActiveOrigin", 0x00187028,
          "Detector Active Origin", VR.kDS, VM.k2, false);
  static const Tag kDetectorManufacturerName
      //(0018,702A)
      = const Tag.public("DetectorManufacturerName", 0x0018702A,
          "Detector Manufacturer Name", VR.kLO, VM.k1, false);
  static const Tag kDetectorManufacturerModelName
      //(0018,702B)
      = const Tag.public("DetectorManufacturerModelName", 0x0018702B,
          "Detector Manufacturer's Model Name", VR.kLO, VM.k1, false);
  static const Tag kFieldOfViewOrigin
      //(0018,7030)
      = const Tag.public("FieldOfViewOrigin", 0x00187030,
          "Field of View Origin", VR.kDS, VM.k2, false);
  static const Tag kFieldOfViewRotation
      //(0018,7032)
      = const Tag.public("FieldOfViewRotation", 0x00187032,
          "Field of View Rotation", VR.kDS, VM.k1, false);
  static const Tag kFieldOfViewHorizontalFlip
      //(0018,7034)
      = const Tag.public("FieldOfViewHorizontalFlip", 0x00187034,
          "Field of View Horizontal Flip", VR.kCS, VM.k1, false);
  static const Tag kPixelDataAreaOriginRelativeToFOV
      //(0018,7036)
      = const Tag.public("PixelDataAreaOriginRelativeToFOV", 0x00187036,
          "Pixel Data Area Origin Relative To FOV", VR.kFL, VM.k2, false);
  static const Tag kPixelDataAreaRotationAngleRelativeToFOV
      //(0018,7038)
      = const Tag.public(
          "PixelDataAreaRotationAngleRelativeToFOV",
          0x00187038,
          "Pixel Data Area Rotation Angle Relative To FOV",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kGridAbsorbingMaterial
      //(0018,7040)
      = const Tag.public("GridAbsorbingMaterial", 0x00187040,
          "Grid Absorbing Material", VR.kLT, VM.k1, false);
  static const Tag kGridSpacingMaterial
      //(0018,7041)
      = const Tag.public("GridSpacingMaterial", 0x00187041,
          "Grid Spacing Material", VR.kLT, VM.k1, false);
  static const Tag kGridThickness
      //(0018,7042)
      = const Tag.public(
          "GridThickness", 0x00187042, "Grid Thickness", VR.kDS, VM.k1, false);
  static const Tag kGridPitch
      //(0018,7044)
      = const Tag.public(
          "GridPitch", 0x00187044, "Grid Pitch", VR.kDS, VM.k1, false);
  static const Tag kGridAspectRatio
      //(0018,7046)
      = const Tag.public("GridAspectRatio", 0x00187046, "Grid Aspect Ratio",
          VR.kIS, VM.k2, false);
  static const Tag kGridPeriod
      //(0018,7048)
      = const Tag.public(
          "GridPeriod", 0x00187048, "Grid Period", VR.kDS, VM.k1, false);
  static const Tag kGridFocalDistance
      //(0018,704C)
      = const Tag.public("GridFocalDistance", 0x0018704C, "Grid Focal Distance",
          VR.kDS, VM.k1, false);
  static const Tag kFilterMaterial
      //(0018,7050)
      = const Tag.public("FilterMaterial", 0x00187050, "Filter Material",
          VR.kCS, VM.k1_n, false);
  static const Tag kFilterThicknessMinimum
      //(0018,7052)
      = const Tag.public("FilterThicknessMinimum", 0x00187052,
          "Filter Thickness Minimum", VR.kDS, VM.k1_n, false);
  static const Tag kFilterThicknessMaximum
      //(0018,7054)
      = const Tag.public("FilterThicknessMaximum", 0x00187054,
          "Filter Thickness Maximum", VR.kDS, VM.k1_n, false);
  static const Tag kFilterBeamPathLengthMinimum
      //(0018,7056)
      = const Tag.public("FilterBeamPathLengthMinimum", 0x00187056,
          "Filter Beam Path Length Minimum", VR.kFL, VM.k1_n, false);
  static const Tag kFilterBeamPathLengthMaximum
      //(0018,7058)
      = const Tag.public("FilterBeamPathLengthMaximum", 0x00187058,
          "Filter Beam Path Length Maximum", VR.kFL, VM.k1_n, false);
  static const Tag kExposureControlMode
      //(0018,7060)
      = const Tag.public("ExposureControlMode", 0x00187060,
          "Exposure Control Mode", VR.kCS, VM.k1, false);
  static const Tag kExposureControlModeDescription
      //(0018,7062)
      = const Tag.public("ExposureControlModeDescription", 0x00187062,
          "Exposure Control Mode Description", VR.kLT, VM.k1, false);
  static const Tag kExposureStatus
      //(0018,7064)
      = const Tag.public("ExposureStatus", 0x00187064, "Exposure Status",
          VR.kCS, VM.k1, false);
  static const Tag kPhototimerSetting
      //(0018,7065)
      = const Tag.public("PhototimerSetting", 0x00187065, "Phototimer Setting",
          VR.kDS, VM.k1, false);
  static const Tag kExposureTimeInuS
      //(0018,8150)
      = const Tag.public("ExposureTimeInuS", 0x00188150, "Exposure Time in µS",
          VR.kDS, VM.k1, false);
  static const Tag kXRayTubeCurrentInuA
      //(0018,8151)
      = const Tag.public("XRayTubeCurrentInuA", 0x00188151,
          "X-Ray Tube Current in µA", VR.kDS, VM.k1, false);
  static const Tag kContentQualification
      //(0018,9004)
      = const Tag.public("ContentQualification", 0x00189004,
          "Content Qualification", VR.kCS, VM.k1, false);
  static const Tag kPulseSequenceName
      //(0018,9005)
      = const Tag.public("PulseSequenceName", 0x00189005, "Pulse Sequence Name",
          VR.kSH, VM.k1, false);
  static const Tag kMRImagingModifierSequence
      //(0018,9006)
      = const Tag.public("MRImagingModifierSequence", 0x00189006,
          "MR Imaging Modifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEchoPulseSequence
      //(0018,9008)
      = const Tag.public("EchoPulseSequence", 0x00189008, "Echo Pulse Sequence",
          VR.kCS, VM.k1, false);
  static const Tag kInversionRecovery
      //(0018,9009)
      = const Tag.public("InversionRecovery", 0x00189009, "Inversion Recovery",
          VR.kCS, VM.k1, false);
  static const Tag kFlowCompensation
      //(0018,9010)
      = const Tag.public("FlowCompensation", 0x00189010, "Flow Compensation",
          VR.kCS, VM.k1, false);
  static const Tag kMultipleSpinEcho
      //(0018,9011)
      = const Tag.public("MultipleSpinEcho", 0x00189011, "Multiple Spin Echo",
          VR.kCS, VM.k1, false);
  static const Tag kMultiPlanarExcitation
      //(0018,9012)
      = const Tag.public("MultiPlanarExcitation", 0x00189012,
          "Multi-planar Excitation", VR.kCS, VM.k1, false);
  static const Tag kPhaseContrast
      //(0018,9014)
      = const Tag.public(
          "PhaseContrast", 0x00189014, "Phase Contrast", VR.kCS, VM.k1, false);
  static const Tag kTimeOfFlightContrast
      //(0018,9015)
      = const Tag.public("TimeOfFlightContrast", 0x00189015,
          "Time of Flight Contrast", VR.kCS, VM.k1, false);
  static const Tag kSpoiling
      //(0018,9016)
      = const Tag.public(
          "Spoiling", 0x00189016, "Spoiling", VR.kCS, VM.k1, false);
  static const Tag kSteadyStatePulseSequence
      //(0018,9017)
      = const Tag.public("SteadyStatePulseSequence", 0x00189017,
          "Steady State Pulse Sequence", VR.kCS, VM.k1, false);
  static const Tag kEchoPlanarPulseSequence
      //(0018,9018)
      = const Tag.public("EchoPlanarPulseSequence", 0x00189018,
          "Echo Planar Pulse Sequence", VR.kCS, VM.k1, false);
  static const Tag kTagAngleFirstAxis
      //(0018,9019)
      = const Tag.public("TagAngleFirstAxis", 0x00189019,
          "Tag Angle First Axis", VR.kFD, VM.k1, false);
  static const Tag kMagnetizationTransfer
      //(0018,9020)
      = const Tag.public("MagnetizationTransfer", 0x00189020,
          "Magnetization Transfer", VR.kCS, VM.k1, false);
  static const Tag kT2Preparation
      //(0018,9021)
      = const Tag.public(
          "T2Preparation", 0x00189021, "T2 Preparation", VR.kCS, VM.k1, false);
  static const Tag kBloodSignalNulling
      //(0018,9022)
      = const Tag.public("BloodSignalNulling", 0x00189022,
          "Blood Signal Nulling", VR.kCS, VM.k1, false);
  static const Tag kSaturationRecovery
      //(0018,9024)
      = const Tag.public("SaturationRecovery", 0x00189024,
          "Saturation Recovery", VR.kCS, VM.k1, false);
  static const Tag kSpectrallySelectedSuppression
      //(0018,9025)
      = const Tag.public("SpectrallySelectedSuppression", 0x00189025,
          "Spectrally Selected Suppression", VR.kCS, VM.k1, false);
  static const Tag kSpectrallySelectedExcitation
      //(0018,9026)
      = const Tag.public("SpectrallySelectedExcitation", 0x00189026,
          "Spectrally Selected Excitation", VR.kCS, VM.k1, false);
  static const Tag kSpatialPresaturation
      //(0018,9027)
      = const Tag.public("SpatialPresaturation", 0x00189027,
          "Spatial Pre-saturation", VR.kCS, VM.k1, false);
  static const Tag kTagging
      //(0018,9028)
      =
      const Tag.public("Tagging", 0x00189028, "Tagging", VR.kCS, VM.k1, false);
  static const Tag kOversamplingPhase
      //(0018,9029)
      = const Tag.public("OversamplingPhase", 0x00189029, "Oversampling Phase",
          VR.kCS, VM.k1, false);
  static const Tag kTagSpacingFirstDimension
      //(0018,9030)
      = const Tag.public("TagSpacingFirstDimension", 0x00189030,
          "Tag Spacing First Dimension", VR.kFD, VM.k1, false);
  static const Tag kGeometryOfKSpaceTraversal
      //(0018,9032)
      = const Tag.public("GeometryOfKSpaceTraversal", 0x00189032,
          "Geometry of k-Space Traversal", VR.kCS, VM.k1, false);
  static const Tag kSegmentedKSpaceTraversal
      //(0018,9033)
      = const Tag.public("SegmentedKSpaceTraversal", 0x00189033,
          "Segmented k-Space Traversal", VR.kCS, VM.k1, false);
  static const Tag kRectilinearPhaseEncodeReordering
      //(0018,9034)
      = const Tag.public("RectilinearPhaseEncodeReordering", 0x00189034,
          "Rectilinear Phase Encode Reordering", VR.kCS, VM.k1, false);
  static const Tag kTagThickness
      //(0018,9035)
      = const Tag.public(
          "TagThickness", 0x00189035, "Tag Thickness", VR.kFD, VM.k1, false);
  static const Tag kPartialFourierDirection
      //(0018,9036)
      = const Tag.public("PartialFourierDirection", 0x00189036,
          "Partial Fourier Direction", VR.kCS, VM.k1, false);
  static const Tag kCardiacSynchronizationTechnique
      //(0018,9037)
      = const Tag.public("CardiacSynchronizationTechnique", 0x00189037,
          "Cardiac Synchronization Technique", VR.kCS, VM.k1, false);
  static const Tag kReceiveCoilManufacturerName
      //(0018,9041)
      = const Tag.public("ReceiveCoilManufacturerName", 0x00189041,
          "Receive Coil Manufacturer Name", VR.kLO, VM.k1, false);
  static const Tag kMRReceiveCoilSequence
      //(0018,9042)
      = const Tag.public("MRReceiveCoilSequence", 0x00189042,
          "MR Receive Coil Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReceiveCoilType
      //(0018,9043)
      = const Tag.public("ReceiveCoilType", 0x00189043, "Receive Coil Type",
          VR.kCS, VM.k1, false);
  static const Tag kQuadratureReceiveCoil
      //(0018,9044)
      = const Tag.public("QuadratureReceiveCoil", 0x00189044,
          "Quadrature Receive Coil", VR.kCS, VM.k1, false);
  static const Tag kMultiCoilDefinitionSequence
      //(0018,9045)
      = const Tag.public("MultiCoilDefinitionSequence", 0x00189045,
          "Multi-Coil Definition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMultiCoilConfiguration
      //(0018,9046)
      = const Tag.public("MultiCoilConfiguration", 0x00189046,
          "Multi-Coil Configuration", VR.kLO, VM.k1, false);
  static const Tag kMultiCoilElementName
      //(0018,9047)
      = const Tag.public("MultiCoilElementName", 0x00189047,
          "Multi-Coil Element Name", VR.kSH, VM.k1, false);
  static const Tag kMultiCoilElementUsed
      //(0018,9048)
      = const Tag.public("MultiCoilElementUsed", 0x00189048,
          "Multi-Coil Element Used", VR.kCS, VM.k1, false);
  static const Tag kMRTransmitCoilSequence
      //(0018,9049)
      = const Tag.public("MRTransmitCoilSequence", 0x00189049,
          "MR Transmit Coil Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransmitCoilManufacturerName
      //(0018,9050)
      = const Tag.public("TransmitCoilManufacturerName", 0x00189050,
          "Transmit Coil Manufacturer Name", VR.kLO, VM.k1, false);
  static const Tag kTransmitCoilType
      //(0018,9051)
      = const Tag.public("TransmitCoilType", 0x00189051, "Transmit Coil Type",
          VR.kCS, VM.k1, false);
  static const Tag kSpectralWidth
      //(0018,9052)
      = const Tag.public("SpectralWidth", 0x00189052, "Spectral Width", VR.kFD,
          VM.k1_2, false);
  static const Tag kChemicalShiftReference
      //(0018,9053)
      = const Tag.public("ChemicalShiftReference", 0x00189053,
          "Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const Tag kVolumeLocalizationTechnique
      //(0018,9054)
      = const Tag.public("VolumeLocalizationTechnique", 0x00189054,
          "Volume Localization Technique", VR.kCS, VM.k1, false);
  static const Tag kMRAcquisitionFrequencyEncodingSteps
      //(0018,9058)
      = const Tag.public("MRAcquisitionFrequencyEncodingSteps", 0x00189058,
          "MR Acquisition Frequency Encoding Steps", VR.kUS, VM.k1, false);
  static const Tag kDecoupling
      //(0018,9059)
      = const Tag.public(
          "Decoupling", 0x00189059, "De-coupling", VR.kCS, VM.k1, false);
  static const Tag kDecoupledNucleus
      //(0018,9060)
      = const Tag.public("DecoupledNucleus", 0x00189060, "De-coupled Nucleus",
          VR.kCS, VM.k1_2, false);
  static const Tag kDecouplingFrequency
      //(0018,9061)
      = const Tag.public("DecouplingFrequency", 0x00189061,
          "De-coupling Frequency", VR.kFD, VM.k1_2, false);
  static const Tag kDecouplingMethod
      //(0018,9062)
      = const Tag.public("DecouplingMethod", 0x00189062, "De-coupling Method",
          VR.kCS, VM.k1, false);
  static const Tag kDecouplingChemicalShiftReference
      //(0018,9063)
      = const Tag.public("DecouplingChemicalShiftReference", 0x00189063,
          "De-coupling Chemical Shift Reference", VR.kFD, VM.k1_2, false);
  static const Tag kKSpaceFiltering
      //(0018,9064)
      = const Tag.public("KSpaceFiltering", 0x00189064, "k-space Filtering",
          VR.kCS, VM.k1, false);
  static const Tag kTimeDomainFiltering
      //(0018,9065)
      = const Tag.public("TimeDomainFiltering", 0x00189065,
          "Time Domain Filtering", VR.kCS, VM.k1_2, false);
  static const Tag kNumberOfZeroFills
      //(0018,9066)
      = const Tag.public("NumberOfZeroFills", 0x00189066,
          "Number of Zero Fills", VR.kUS, VM.k1_2, false);
  static const Tag kBaselineCorrection
      //(0018,9067)
      = const Tag.public("BaselineCorrection", 0x00189067,
          "Baseline Correction", VR.kCS, VM.k1, false);
  static const Tag kParallelReductionFactorInPlane
      //(0018,9069)
      = const Tag.public("ParallelReductionFactorInPlane", 0x00189069,
          "Parallel Reduction Factor In-plane", VR.kFD, VM.k1, false);
  static const Tag kCardiacRRIntervalSpecified
      //(0018,9070)
      = const Tag.public("CardiacRRIntervalSpecified", 0x00189070,
          "Cardiac R-R Interval Specified", VR.kFD, VM.k1, false);
  static const Tag kAcquisitionDuration
      //(0018,9073)
      = const Tag.public("AcquisitionDuration", 0x00189073,
          "Acquisition Duration", VR.kFD, VM.k1, false);
  static const Tag kFrameAcquisitionDateTime
      //(0018,9074)
      = const Tag.public("FrameAcquisitionDateTime", 0x00189074,
          "Frame Acquisition DateTime", VR.kDT, VM.k1, false);
  static const Tag kDiffusionDirectionality
      //(0018,9075)
      = const Tag.public("DiffusionDirectionality", 0x00189075,
          "Diffusion Directionality", VR.kCS, VM.k1, false);
  static const Tag kDiffusionGradientDirectionSequence
      //(0018,9076)
      = const Tag.public("DiffusionGradientDirectionSequence", 0x00189076,
          "Diffusion Gradient Direction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kParallelAcquisition
      //(0018,9077)
      = const Tag.public("ParallelAcquisition", 0x00189077,
          "Parallel Acquisition", VR.kCS, VM.k1, false);
  static const Tag kParallelAcquisitionTechnique
      //(0018,9078)
      = const Tag.public("ParallelAcquisitionTechnique", 0x00189078,
          "Parallel Acquisition Technique", VR.kCS, VM.k1, false);
  static const Tag kInversionTimes
      //(0018,9079)
      = const Tag.public("InversionTimes", 0x00189079, "Inversion Times",
          VR.kFD, VM.k1_n, false);
  static const Tag kMetaboliteMapDescription
      //(0018,9080)
      = const Tag.public("MetaboliteMapDescription", 0x00189080,
          "Metabolite Map Description", VR.kST, VM.k1, false);
  static const Tag kPartialFourier
      //(0018,9081)
      = const Tag.public("PartialFourier", 0x00189081, "Partial Fourier",
          VR.kCS, VM.k1, false);
  static const Tag kEffectiveEchoTime
      //(0018,9082)
      = const Tag.public("EffectiveEchoTime", 0x00189082, "Effective Echo Time",
          VR.kFD, VM.k1, false);
  static const Tag kMetaboliteMapCodeSequence
      //(0018,9083)
      = const Tag.public("MetaboliteMapCodeSequence", 0x00189083,
          "Metabolite Map Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChemicalShiftSequence
      //(0018,9084)
      = const Tag.public("ChemicalShiftSequence", 0x00189084,
          "Chemical Shift Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCardiacSignalSource
      //(0018,9085)
      = const Tag.public("CardiacSignalSource", 0x00189085,
          "Cardiac Signal Source", VR.kCS, VM.k1, false);
  static const Tag kDiffusionBValue
      //(0018,9087)
      = const Tag.public("DiffusionBValue", 0x00189087, "Diffusion b-value",
          VR.kFD, VM.k1, false);
  static const Tag kDiffusionGradientOrientation
      //(0018,9089)
      = const Tag.public("DiffusionGradientOrientation", 0x00189089,
          "Diffusion Gradient Orientation", VR.kFD, VM.k3, false);
  static const Tag kVelocityEncodingDirection
      //(0018,9090)
      = const Tag.public("VelocityEncodingDirection", 0x00189090,
          "Velocity Encoding Direction", VR.kFD, VM.k3, false);
  static const Tag kVelocityEncodingMinimumValue
      //(0018,9091)
      = const Tag.public("VelocityEncodingMinimumValue", 0x00189091,
          "Velocity Encoding Minimum Value", VR.kFD, VM.k1, false);
  static const Tag kVelocityEncodingAcquisitionSequence
      //(0018,9092)
      = const Tag.public("VelocityEncodingAcquisitionSequence", 0x00189092,
          "Velocity Encoding Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfKSpaceTrajectories
      //(0018,9093)
      = const Tag.public("NumberOfKSpaceTrajectories", 0x00189093,
          "Number of k-Space Trajectories", VR.kUS, VM.k1, false);
  static const Tag kCoverageOfKSpace
      //(0018,9094)
      = const Tag.public("CoverageOfKSpace", 0x00189094, "Coverage of k-Space",
          VR.kCS, VM.k1, false);
  static const Tag kSpectroscopyAcquisitionPhaseRows
      //(0018,9095)
      = const Tag.public("SpectroscopyAcquisitionPhaseRows", 0x00189095,
          "Spectroscopy Acquisition Phase Rows", VR.kUL, VM.k1, false);
  static const Tag kParallelReductionFactorInPlaneRetired
      //(0018,9096)
      = const Tag.public("ParallelReductionFactorInPlaneRetired", 0x00189096,
          "Parallel Reduction Factor In-plane (Retired)", VR.kFD, VM.k1, true);
  static const Tag kTransmitterFrequency
      //(0018,9098)
      = const Tag.public("TransmitterFrequency", 0x00189098,
          "Transmitter Frequency", VR.kFD, VM.k1_2, false);
  static const Tag kResonantNucleus
      //(0018,9100)
      = const Tag.public("ResonantNucleus", 0x00189100, "Resonant Nucleus",
          VR.kCS, VM.k1_2, false);
  static const Tag kFrequencyCorrection
      //(0018,9101)
      = const Tag.public("FrequencyCorrection", 0x00189101,
          "Frequency Correction", VR.kCS, VM.k1, false);
  static const Tag kMRSpectroscopyFOVGeometrySequence
      //(0018,9103)
      = const Tag.public("MRSpectroscopyFOVGeometrySequence", 0x00189103,
          "MR Spectroscopy FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSlabThickness
      //(0018,9104)
      = const Tag.public(
          "SlabThickness", 0x00189104, "Slab Thickness", VR.kFD, VM.k1, false);
  static const Tag kSlabOrientation
      //(0018,9105)
      = const Tag.public("SlabOrientation", 0x00189105, "Slab Orientation",
          VR.kFD, VM.k3, false);
  static const Tag kMidSlabPosition
      //(0018,9106)
      = const Tag.public("MidSlabPosition", 0x00189106, "Mid Slab Position",
          VR.kFD, VM.k3, false);
  static const Tag kMRSpatialSaturationSequence
      //(0018,9107)
      = const Tag.public("MRSpatialSaturationSequence", 0x00189107,
          "MR Spatial Saturation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRTimingAndRelatedParametersSequence
      //(0018,9112)
      = const Tag.public("MRTimingAndRelatedParametersSequence", 0x00189112,
          "MR Timing and Related Parameters Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMREchoSequence
      //(0018,9114)
      = const Tag.public("MREchoSequence", 0x00189114, "MR Echo Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kMRModifierSequence
      //(0018,9115)
      = const Tag.public("MRModifierSequence", 0x00189115,
          "MR Modifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRDiffusionSequence
      //(0018,9117)
      = const Tag.public("MRDiffusionSequence", 0x00189117,
          "MR Diffusion Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCardiacSynchronizationSequence
      //(0018,9118)
      = const Tag.public("CardiacSynchronizationSequence", 0x00189118,
          "Cardiac Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRAveragesSequence
      //(0018,9119)
      = const Tag.public("MRAveragesSequence", 0x00189119,
          "MR Averages Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRFOVGeometrySequence
      //(0018,9125)
      = const Tag.public("MRFOVGeometrySequence", 0x00189125,
          "MR FOV/Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVolumeLocalizationSequence
      //(0018,9126)
      = const Tag.public("VolumeLocalizationSequence", 0x00189126,
          "Volume Localization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpectroscopyAcquisitionDataColumns
      //(0018,9127)
      = const Tag.public("SpectroscopyAcquisitionDataColumns", 0x00189127,
          "Spectroscopy Acquisition Data Columns", VR.kUL, VM.k1, false);
  static const Tag kDiffusionAnisotropyType
      //(0018,9147)
      = const Tag.public("DiffusionAnisotropyType", 0x00189147,
          "Diffusion Anisotropy Type", VR.kCS, VM.k1, false);
  static const Tag kFrameReferenceDateTime
      //(0018,9151)
      = const Tag.public("FrameReferenceDateTime", 0x00189151,
          "Frame Reference DateTime", VR.kDT, VM.k1, false);
  static const Tag kMRMetaboliteMapSequence
      //(0018,9152)
      = const Tag.public("MRMetaboliteMapSequence", 0x00189152,
          "MR Metabolite Map Sequence", VR.kSQ, VM.k1, false);
  static const Tag kParallelReductionFactorOutOfPlane
      //(0018,9155)
      = const Tag.public("ParallelReductionFactorOutOfPlane", 0x00189155,
          "Parallel Reduction Factor out-of-plane", VR.kFD, VM.k1, false);
  static const Tag kSpectroscopyAcquisitionOutOfPlanePhaseSteps
      //(0018,9159)
      = const Tag.public(
          "SpectroscopyAcquisitionOutOfPlanePhaseSteps",
          0x00189159,
          "Spectroscopy Acquisition Out-of-plane Phase Steps",
          VR.kUL,
          VM.k1,
          false);
  static const Tag kBulkMotionStatus
      //(0018,9166)
      = const Tag.public("BulkMotionStatus", 0x00189166, "Bulk Motion Status",
          VR.kCS, VM.k1, true);
  static const Tag kParallelReductionFactorSecondInPlane
      //(0018,9168)
      = const Tag.public("ParallelReductionFactorSecondInPlane", 0x00189168,
          "Parallel Reduction Factor Second In-plane", VR.kFD, VM.k1, false);
  static const Tag kCardiacBeatRejectionTechnique
      //(0018,9169)
      = const Tag.public("CardiacBeatRejectionTechnique", 0x00189169,
          "Cardiac Beat Rejection Technique", VR.kCS, VM.k1, false);
  static const Tag kRespiratoryMotionCompensationTechnique
      //(0018,9170)
      = const Tag.public("RespiratoryMotionCompensationTechnique", 0x00189170,
          "Respiratory Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const Tag kRespiratorySignalSource
      //(0018,9171)
      = const Tag.public("RespiratorySignalSource", 0x00189171,
          "Respiratory Signal Source", VR.kCS, VM.k1, false);
  static const Tag kBulkMotionCompensationTechnique
      //(0018,9172)
      = const Tag.public("BulkMotionCompensationTechnique", 0x00189172,
          "Bulk Motion Compensation Technique", VR.kCS, VM.k1, false);
  static const Tag kBulkMotionSignalSource
      //(0018,9173)
      = const Tag.public("BulkMotionSignalSource", 0x00189173,
          "Bulk Motion Signal Source", VR.kCS, VM.k1, false);
  static const Tag kApplicableSafetyStandardAgency
      //(0018,9174)
      = const Tag.public("ApplicableSafetyStandardAgency", 0x00189174,
          "Applicable Safety Standard Agency", VR.kCS, VM.k1, false);
  static const Tag kApplicableSafetyStandardDescription
      //(0018,9175)
      = const Tag.public("ApplicableSafetyStandardDescription", 0x00189175,
          "Applicable Safety Standard Description", VR.kLO, VM.k1, false);
  static const Tag kOperatingModeSequence
      //(0018,9176)
      = const Tag.public("OperatingModeSequence", 0x00189176,
          "Operating Mode Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOperatingModeType
      //(0018,9177)
      = const Tag.public("OperatingModeType", 0x00189177, "Operating Mode Type",
          VR.kCS, VM.k1, false);
  static const Tag kOperatingMode
      //(0018,9178)
      = const Tag.public(
          "OperatingMode", 0x00189178, "Operating Mode", VR.kCS, VM.k1, false);
  static const Tag kSpecificAbsorptionRateDefinition
      //(0018,9179)
      = const Tag.public("SpecificAbsorptionRateDefinition", 0x00189179,
          "Specific Absorption Rate Definition", VR.kCS, VM.k1, false);
  static const Tag kGradientOutputType
      //(0018,9180)
      = const Tag.public("GradientOutputType", 0x00189180,
          "Gradient Output Type", VR.kCS, VM.k1, false);
  static const Tag kSpecificAbsorptionRateValue
      //(0018,9181)
      = const Tag.public("SpecificAbsorptionRateValue", 0x00189181,
          "Specific Absorption Rate Value", VR.kFD, VM.k1, false);
  static const Tag kGradientOutput
      //(0018,9182)
      = const Tag.public("GradientOutput", 0x00189182, "Gradient Output",
          VR.kFD, VM.k1, false);
  static const Tag kFlowCompensationDirection
      //(0018,9183)
      = const Tag.public("FlowCompensationDirection", 0x00189183,
          "Flow Compensation Direction", VR.kCS, VM.k1, false);
  static const Tag kTaggingDelay
      //(0018,9184)
      = const Tag.public(
          "TaggingDelay", 0x00189184, "Tagging Delay", VR.kFD, VM.k1, false);
  static const Tag kRespiratoryMotionCompensationTechniqueDescription
      //(0018,9185)
      = const Tag.public(
          "RespiratoryMotionCompensationTechniqueDescription",
          0x00189185,
          "Respiratory Motion Compensation Technique Description",
          VR.kST,
          VM.k1,
          false);
  static const Tag kRespiratorySignalSourceID
      //(0018,9186)
      = const Tag.public("RespiratorySignalSourceID", 0x00189186,
          "Respiratory Signal Source ID", VR.kSH, VM.k1, false);
  static const Tag kChemicalShiftMinimumIntegrationLimitInHz
      //(0018,9195)
      = const Tag.public(
          "ChemicalShiftMinimumIntegrationLimitInHz",
          0x00189195,
          "Chemical Shift Minimum Integration Limit in Hz",
          VR.kFD,
          VM.k1,
          true);
  static const Tag kChemicalShiftMaximumIntegrationLimitInHz
      //(0018,9196)
      = const Tag.public(
          "ChemicalShiftMaximumIntegrationLimitInHz",
          0x00189196,
          "Chemical Shift Maximum Integration Limit in Hz",
          VR.kFD,
          VM.k1,
          true);
  static const Tag kMRVelocityEncodingSequence
      //(0018,9197)
      = const Tag.public("MRVelocityEncodingSequence", 0x00189197,
          "MR Velocity Encoding Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFirstOrderPhaseCorrection
      //(0018,9198)
      = const Tag.public("FirstOrderPhaseCorrection", 0x00189198,
          "First Order Phase Correction", VR.kCS, VM.k1, false);
  static const Tag kWaterReferencedPhaseCorrection
      //(0018,9199)
      = const Tag.public("WaterReferencedPhaseCorrection", 0x00189199,
          "Water Referenced Phase Correction", VR.kCS, VM.k1, false);
  static const Tag kMRSpectroscopyAcquisitionType
      //(0018,9200)
      = const Tag.public("MRSpectroscopyAcquisitionType", 0x00189200,
          "MR Spectroscopy Acquisition Type", VR.kCS, VM.k1, false);
  static const Tag kRespiratoryCyclePosition
      //(0018,9214)
      = const Tag.public("RespiratoryCyclePosition", 0x00189214,
          "Respiratory Cycle Position", VR.kCS, VM.k1, false);
  static const Tag kVelocityEncodingMaximumValue
      //(0018,9217)
      = const Tag.public("VelocityEncodingMaximumValue", 0x00189217,
          "Velocity Encoding Maximum Value", VR.kFD, VM.k1, false);
  static const Tag kTagSpacingSecondDimension
      //(0018,9218)
      = const Tag.public("TagSpacingSecondDimension", 0x00189218,
          "Tag Spacing Second Dimension", VR.kFD, VM.k1, false);
  static const Tag kTagAngleSecondAxis
      //(0018,9219)
      = const Tag.public("TagAngleSecondAxis", 0x00189219,
          "Tag Angle Second Axis", VR.kSS, VM.k1, false);
  static const Tag kFrameAcquisitionDuration
      //(0018,9220)
      = const Tag.public("FrameAcquisitionDuration", 0x00189220,
          "Frame Acquisition Duration", VR.kFD, VM.k1, false);
  static const Tag kMRImageFrameTypeSequence
      //(0018,9226)
      = const Tag.public("MRImageFrameTypeSequence", 0x00189226,
          "MR Image Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRSpectroscopyFrameTypeSequence
      //(0018,9227)
      = const Tag.public("MRSpectroscopyFrameTypeSequence", 0x00189227,
          "MR Spectroscopy Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMRAcquisitionPhaseEncodingStepsInPlane
      //(0018,9231)
      = const Tag.public("MRAcquisitionPhaseEncodingStepsInPlane", 0x00189231,
          "MR Acquisition Phase Encoding Steps in-plane", VR.kUS, VM.k1, false);
  static const Tag kMRAcquisitionPhaseEncodingStepsOutOfPlane
      //(0018,9232)
      = const Tag.public(
          "MRAcquisitionPhaseEncodingStepsOutOfPlane",
          0x00189232,
          "MR Acquisition Phase Encoding Steps out-of-plane",
          VR.kUS,
          VM.k1,
          false);
  static const Tag kSpectroscopyAcquisitionPhaseColumns
      //(0018,9234)
      = const Tag.public("SpectroscopyAcquisitionPhaseColumns", 0x00189234,
          "Spectroscopy Acquisition Phase Columns", VR.kUL, VM.k1, false);
  static const Tag kCardiacCyclePosition
      //(0018,9236)
      = const Tag.public("CardiacCyclePosition", 0x00189236,
          "Cardiac Cycle Position", VR.kCS, VM.k1, false);
  static const Tag kSpecificAbsorptionRateSequence
      //(0018,9239)
      = const Tag.public("SpecificAbsorptionRateSequence", 0x00189239,
          "Specific Absorption Rate Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRFEchoTrainLength
      //(0018,9240)
      = const Tag.public("RFEchoTrainLength", 0x00189240,
          "RF Echo Train Length", VR.kUS, VM.k1, false);
  static const Tag kGradientEchoTrainLength
      //(0018,9241)
      = const Tag.public("GradientEchoTrainLength", 0x00189241,
          "Gradient Echo Train Length", VR.kUS, VM.k1, false);
  static const Tag kArterialSpinLabelingContrast
      //(0018,9250)
      = const Tag.public("ArterialSpinLabelingContrast", 0x00189250,
          "Arterial Spin Labeling Contrast", VR.kCS, VM.k1, false);
  static const Tag kMRArterialSpinLabelingSequence
      //(0018,9251)
      = const Tag.public("MRArterialSpinLabelingSequence", 0x00189251,
          "MR Arterial Spin Labeling Sequence", VR.kSQ, VM.k1, false);
  static const Tag kASLTechniqueDescription
      //(0018,9252)
      = const Tag.public("ASLTechniqueDescription", 0x00189252,
          "ASL Technique Description", VR.kLO, VM.k1, false);
  static const Tag kASLSlabNumber
      //(0018,9253)
      = const Tag.public(
          "ASLSlabNumber", 0x00189253, "ASL Slab Number", VR.kUS, VM.k1, false);
  static const Tag kASLSlabThickness
      //(0018,9254)
      = const Tag.public("ASLSlabThickness", 0x00189254, "ASL Slab Thickness",
          VR.kFD, VM.k1, false);
  static const Tag kASLSlabOrientation
      //(0018,9255)
      = const Tag.public("ASLSlabOrientation", 0x00189255,
          "ASL Slab Orientation", VR.kFD, VM.k3, false);
  static const Tag kASLMidSlabPosition
      //(0018,9256)
      = const Tag.public("ASLMidSlabPosition", 0x00189256,
          "ASL Mid Slab Position", VR.kFD, VM.k3, false);
  static const Tag kASLContext
      //(0018,9257)
      = const Tag.public(
          "ASLContext", 0x00189257, "ASL Context", VR.kCS, VM.k1, false);
  static const Tag kASLPulseTrainDuration
      //(0018,9258)
      = const Tag.public("ASLPulseTrainDuration", 0x00189258,
          "ASL Pulse Train Duration", VR.kUL, VM.k1, false);
  static const Tag kASLCrusherFlag
      //(0018,9259)
      = const Tag.public("ASLCrusherFlag", 0x00189259, "ASL Crusher Flag",
          VR.kCS, VM.k1, false);
  static const Tag kASLCrusherFlowLimit
      //(0018,925A)
      = const Tag.public("ASLCrusherFlowLimit", 0x0018925A,
          "ASL Crusher Flow Limit", VR.kFD, VM.k1, false);
  static const Tag kASLCrusherDescription
      //(0018,925B)
      = const Tag.public("ASLCrusherDescription", 0x0018925B,
          "ASL Crusher Description", VR.kLO, VM.k1, false);
  static const Tag kASLBolusCutoffFlag
      //(0018,925C)
      = const Tag.public("ASLBolusCutoffFlag", 0x0018925C,
          "ASL Bolus Cut-off Flag", VR.kCS, VM.k1, false);
  static const Tag kASLBolusCutoffTimingSequence
      //(0018,925D)
      = const Tag.public("ASLBolusCutoffTimingSequence", 0x0018925D,
          "ASL Bolus Cut-off Timing Sequence", VR.kSQ, VM.k1, false);
  static const Tag kASLBolusCutoffTechnique
      //(0018,925E)
      = const Tag.public("ASLBolusCutoffTechnique", 0x0018925E,
          "ASL Bolus Cut-off Technique", VR.kLO, VM.k1, false);
  static const Tag kASLBolusCutoffDelayTime
      //(0018,925F)
      = const Tag.public("ASLBolusCutoffDelayTime", 0x0018925F,
          "ASL Bolus Cut-off Delay Time", VR.kUL, VM.k1, false);
  static const Tag kASLSlabSequence
      //(0018,9260)
      = const Tag.public("ASLSlabSequence", 0x00189260, "ASL Slab Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kChemicalShiftMinimumIntegrationLimitInppm
      //(0018,9295)
      = const Tag.public(
          "ChemicalShiftMinimumIntegrationLimitInppm",
          0x00189295,
          "Chemical Shift Minimum Integration Limit in ppm",
          VR.kFD,
          VM.k1,
          false);
  static const Tag kChemicalShiftMaximumIntegrationLimitInppm
      //(0018,9296)
      = const Tag.public(
          "ChemicalShiftMaximumIntegrationLimitInppm",
          0x00189296,
          "Chemical Shift Maximum Integration Limit in ppm",
          VR.kFD,
          VM.k1,
          false);
  static const Tag kCTAcquisitionTypeSequence
      //(0018,9301)
      = const Tag.public("CTAcquisitionTypeSequence", 0x00189301,
          "CT Acquisition Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcquisitionType
      //(0018,9302)
      = const Tag.public("AcquisitionType", 0x00189302, "Acquisition Type",
          VR.kCS, VM.k1, false);
  static const Tag kTubeAngle
      //(0018,9303)
      = const Tag.public(
          "TubeAngle", 0x00189303, "Tube Angle", VR.kFD, VM.k1, false);
  static const Tag kCTAcquisitionDetailsSequence
      //(0018,9304)
      = const Tag.public("CTAcquisitionDetailsSequence", 0x00189304,
          "CT Acquisition Details Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRevolutionTime
      //(0018,9305)
      = const Tag.public("RevolutionTime", 0x00189305, "Revolution Time",
          VR.kFD, VM.k1, false);
  static const Tag kSingleCollimationWidth
      //(0018,9306)
      = const Tag.public("SingleCollimationWidth", 0x00189306,
          "Single Collimation Width", VR.kFD, VM.k1, false);
  static const Tag kTotalCollimationWidth
      //(0018,9307)
      = const Tag.public("TotalCollimationWidth", 0x00189307,
          "Total Collimation Width", VR.kFD, VM.k1, false);
  static const Tag kCTTableDynamicsSequence
      //(0018,9308)
      = const Tag.public("CTTableDynamicsSequence", 0x00189308,
          "CT Table Dynamics Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTableSpeed
      //(0018,9309)
      = const Tag.public(
          "TableSpeed", 0x00189309, "Table Speed", VR.kFD, VM.k1, false);
  static const Tag kTableFeedPerRotation
      //(0018,9310)
      = const Tag.public("TableFeedPerRotation", 0x00189310,
          "Table Feed per Rotation", VR.kFD, VM.k1, false);
  static const Tag kSpiralPitchFactor
      //(0018,9311)
      = const Tag.public("SpiralPitchFactor", 0x00189311, "Spiral Pitch Factor",
          VR.kFD, VM.k1, false);
  static const Tag kCTGeometrySequence
      //(0018,9312)
      = const Tag.public("CTGeometrySequence", 0x00189312,
          "CT Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataCollectionCenterPatient
      //(0018,9313)
      = const Tag.public("DataCollectionCenterPatient", 0x00189313,
          "Data Collection Center (Patient)", VR.kFD, VM.k3, false);
  static const Tag kCTReconstructionSequence
      //(0018,9314)
      = const Tag.public("CTReconstructionSequence", 0x00189314,
          "CT Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReconstructionAlgorithm
      //(0018,9315)
      = const Tag.public("ReconstructionAlgorithm", 0x00189315,
          "Reconstruction Algorithm", VR.kCS, VM.k1, false);
  static const Tag kConvolutionKernelGroup
      //(0018,9316)
      = const Tag.public("ConvolutionKernelGroup", 0x00189316,
          "Convolution Kernel Group", VR.kCS, VM.k1, false);
  static const Tag kReconstructionFieldOfView
      //(0018,9317)
      = const Tag.public("ReconstructionFieldOfView", 0x00189317,
          "Reconstruction Field of View", VR.kFD, VM.k2, false);
  static const Tag kReconstructionTargetCenterPatient
      //(0018,9318)
      = const Tag.public("ReconstructionTargetCenterPatient", 0x00189318,
          "Reconstruction Target Center (Patient)", VR.kFD, VM.k3, false);
  static const Tag kReconstructionAngle
      //(0018,9319)
      = const Tag.public("ReconstructionAngle", 0x00189319,
          "Reconstruction Angle", VR.kFD, VM.k1, false);
  static const Tag kImageFilter
      //(0018,9320)
      = const Tag.public(
          "ImageFilter", 0x00189320, "Image Filter", VR.kSH, VM.k1, false);
  static const Tag kCTExposureSequence
      //(0018,9321)
      = const Tag.public("CTExposureSequence", 0x00189321,
          "CT Exposure Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReconstructionPixelSpacing
      //(0018,9322)
      = const Tag.public("ReconstructionPixelSpacing", 0x00189322,
          "Reconstruction Pixel Spacing", VR.kFD, VM.k2, false);
  static const Tag kExposureModulationType
      //(0018,9323)
      = const Tag.public("ExposureModulationType", 0x00189323,
          "Exposure Modulation Type", VR.kCS, VM.k1, false);
  static const Tag kEstimatedDoseSaving
      //(0018,9324)
      = const Tag.public("EstimatedDoseSaving", 0x00189324,
          "Estimated Dose Saving", VR.kFD, VM.k1, false);
  static const Tag kCTXRayDetailsSequence
      //(0018,9325)
      = const Tag.public("CTXRayDetailsSequence", 0x00189325,
          "CT X-Ray Details Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCTPositionSequence
      //(0018,9326)
      = const Tag.public("CTPositionSequence", 0x00189326,
          "CT Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTablePosition
      //(0018,9327)
      = const Tag.public(
          "TablePosition", 0x00189327, "Table Position", VR.kFD, VM.k1, false);
  static const Tag kExposureTimeInms
      //(0018,9328)
      = const Tag.public("ExposureTimeInms", 0x00189328, "Exposure Time in ms",
          VR.kFD, VM.k1, false);
  static const Tag kCTImageFrameTypeSequence
      //(0018,9329)
      = const Tag.public("CTImageFrameTypeSequence", 0x00189329,
          "CT Image Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXRayTubeCurrentInmA
      //(0018,9330)
      = const Tag.public("XRayTubeCurrentInmA", 0x00189330,
          "X-Ray Tube Current in mA", VR.kFD, VM.k1, false);
  static const Tag kExposureInmAs
      //(0018,9332)
      = const Tag.public(
          "ExposureInmAs", 0x00189332, "Exposure in mAs", VR.kFD, VM.k1, false);
  static const Tag kConstantVolumeFlag
      //(0018,9333)
      = const Tag.public("ConstantVolumeFlag", 0x00189333,
          "Constant Volume Flag", VR.kCS, VM.k1, false);
  static const Tag kFluoroscopyFlag
      //(0018,9334)
      = const Tag.public("FluoroscopyFlag", 0x00189334, "Fluoroscopy Flag",
          VR.kCS, VM.k1, false);
  static const Tag kDistanceSourceToDataCollectionCenter
      //(0018,9335)
      = const Tag.public("DistanceSourceToDataCollectionCenter", 0x00189335,
          "Distance Source to Data Collection Center", VR.kFD, VM.k1, false);
  static const Tag kContrastBolusAgentNumber
      //(0018,9337)
      = const Tag.public("ContrastBolusAgentNumber", 0x00189337,
          "Contrast/Bolus Agent Number", VR.kUS, VM.k1, false);
  static const Tag kContrastBolusIngredientCodeSequence
      //(0018,9338)
      = const Tag.public("ContrastBolusIngredientCodeSequence", 0x00189338,
          "Contrast/Bolus Ingredient Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContrastAdministrationProfileSequence
      //(0018,9340)
      = const Tag.public("ContrastAdministrationProfileSequence", 0x00189340,
          "Contrast Administration Profile Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContrastBolusUsageSequence
      //(0018,9341)
      = const Tag.public("ContrastBolusUsageSequence", 0x00189341,
          "Contrast/Bolus Usage Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContrastBolusAgentAdministered
      //(0018,9342)
      = const Tag.public("ContrastBolusAgentAdministered", 0x00189342,
          "Contrast/Bolus Agent Administered", VR.kCS, VM.k1, false);
  static const Tag kContrastBolusAgentDetected
      //(0018,9343)
      = const Tag.public("ContrastBolusAgentDetected", 0x00189343,
          "Contrast/Bolus Agent Detected", VR.kCS, VM.k1, false);
  static const Tag kContrastBolusAgentPhase
      //(0018,9344)
      = const Tag.public("ContrastBolusAgentPhase", 0x00189344,
          "Contrast/Bolus Agent Phase", VR.kCS, VM.k1, false);
  static const Tag kCTDIvol
      //(0018,9345)
      =
      const Tag.public("CTDIvol", 0x00189345, "CTDIvol", VR.kFD, VM.k1, false);
  static const Tag kCTDIPhantomTypeCodeSequence
      //(0018,9346)
      = const Tag.public("CTDIPhantomTypeCodeSequence", 0x00189346,
          "CTDI Phantom Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCalciumScoringMassFactorPatient
      //(0018,9351)
      = const Tag.public("CalciumScoringMassFactorPatient", 0x00189351,
          "Calcium Scoring Mass Factor Patient", VR.kFL, VM.k1, false);
  static const Tag kCalciumScoringMassFactorDevice
      //(0018,9352)
      = const Tag.public("CalciumScoringMassFactorDevice", 0x00189352,
          "Calcium Scoring Mass Factor Device", VR.kFL, VM.k3, false);
  static const Tag kEnergyWeightingFactor
      //(0018,9353)
      = const Tag.public("EnergyWeightingFactor", 0x00189353,
          "Energy Weighting Factor", VR.kFL, VM.k1, false);
  static const Tag kCTAdditionalXRaySourceSequence
      //(0018,9360)
      = const Tag.public("CTAdditionalXRaySourceSequence", 0x00189360,
          "CT Additional X-Ray Source Sequence", VR.kSQ, VM.k1, false);
  static const Tag kProjectionPixelCalibrationSequence
      //(0018,9401)
      = const Tag.public("ProjectionPixelCalibrationSequence", 0x00189401,
          "Projection Pixel Calibration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDistanceSourceToIsocenter
      //(0018,9402)
      = const Tag.public("DistanceSourceToIsocenter", 0x00189402,
          "Distance Source to Isocenter", VR.kFL, VM.k1, false);
  static const Tag kDistanceObjectToTableTop
      //(0018,9403)
      = const Tag.public("DistanceObjectToTableTop", 0x00189403,
          "Distance Object to Table Top", VR.kFL, VM.k1, false);
  static const Tag kObjectPixelSpacingInCenterOfBeam
      //(0018,9404)
      = const Tag.public("ObjectPixelSpacingInCenterOfBeam", 0x00189404,
          "Object Pixel Spacing in Center of Beam", VR.kFL, VM.k2, false);
  static const Tag kPositionerPositionSequence
      //(0018,9405)
      = const Tag.public("PositionerPositionSequence", 0x00189405,
          "Positioner Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTablePositionSequence
      //(0018,9406)
      = const Tag.public("TablePositionSequence", 0x00189406,
          "Table Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCollimatorShapeSequence
      //(0018,9407)
      = const Tag.public("CollimatorShapeSequence", 0x00189407,
          "Collimator Shape Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanesInAcquisition
      //(0018,9410)
      = const Tag.public("PlanesInAcquisition", 0x00189410,
          "Planes in Acquisition", VR.kCS, VM.k1, false);
  static const Tag kXAXRFFrameCharacteristicsSequence
      //(0018,9412)
      = const Tag.public("XAXRFFrameCharacteristicsSequence", 0x00189412,
          "XA/XRF Frame Characteristics Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFrameAcquisitionSequence
      //(0018,9417)
      = const Tag.public("FrameAcquisitionSequence", 0x00189417,
          "Frame Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXRayReceptorType
      //(0018,9420)
      = const Tag.public("XRayReceptorType", 0x00189420, "X-Ray Receptor Type",
          VR.kCS, VM.k1, false);
  static const Tag kAcquisitionProtocolName
      //(0018,9423)
      = const Tag.public("AcquisitionProtocolName", 0x00189423,
          "Acquisition Protocol Name", VR.kLO, VM.k1, false);
  static const Tag kAcquisitionProtocolDescription
      //(0018,9424)
      = const Tag.public("AcquisitionProtocolDescription", 0x00189424,
          "Acquisition Protocol Description", VR.kLT, VM.k1, false);
  static const Tag kContrastBolusIngredientOpaque
      //(0018,9425)
      = const Tag.public("ContrastBolusIngredientOpaque", 0x00189425,
          "Contrast/Bolus Ingredient Opaque", VR.kCS, VM.k1, false);
  static const Tag kDistanceReceptorPlaneToDetectorHousing
      //(0018,9426)
      = const Tag.public("DistanceReceptorPlaneToDetectorHousing", 0x00189426,
          "Distance Receptor Plane to Detector Housing", VR.kFL, VM.k1, false);
  static const Tag kIntensifierActiveShape
      //(0018,9427)
      = const Tag.public("IntensifierActiveShape", 0x00189427,
          "Intensifier Active Shape", VR.kCS, VM.k1, false);
  static const Tag kIntensifierActiveDimensions
      //(0018,9428)
      = const Tag.public("IntensifierActiveDimensions", 0x00189428,
          "Intensifier Active Dimension(s)", VR.kFL, VM.k1_2, false);
  static const Tag kPhysicalDetectorSize
      //(0018,9429)
      = const Tag.public("PhysicalDetectorSize", 0x00189429,
          "Physical Detector Size", VR.kFL, VM.k2, false);
  static const Tag kPositionOfIsocenterProjection
      //(0018,9430)
      = const Tag.public("PositionOfIsocenterProjection", 0x00189430,
          "Position of Isocenter Projection", VR.kFL, VM.k2, false);
  static const Tag kFieldOfViewSequence
      //(0018,9432)
      = const Tag.public("FieldOfViewSequence", 0x00189432,
          "Field of View Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFieldOfViewDescription
      //(0018,9433)
      = const Tag.public("FieldOfViewDescription", 0x00189433,
          "Field of View Description", VR.kLO, VM.k1, false);
  static const Tag kExposureControlSensingRegionsSequence
      //(0018,9434)
      = const Tag.public("ExposureControlSensingRegionsSequence", 0x00189434,
          "Exposure Control Sensing Regions Sequence", VR.kSQ, VM.k1, false);
  static const Tag kExposureControlSensingRegionShape
      //(0018,9435)
      = const Tag.public("ExposureControlSensingRegionShape", 0x00189435,
          "Exposure Control Sensing Region Shape", VR.kCS, VM.k1, false);
  static const Tag kExposureControlSensingRegionLeftVerticalEdge
      //(0018,9436)
      = const Tag.public(
          "ExposureControlSensingRegionLeftVerticalEdge",
          0x00189436,
          "Exposure Control Sensing Region Left Vertical Edge",
          VR.kSS,
          VM.k1,
          false);
  static const Tag kExposureControlSensingRegionRightVerticalEdge
      //(0018,9437)
      = const Tag.public(
          "ExposureControlSensingRegionRightVerticalEdge",
          0x00189437,
          "Exposure Control Sensing Region Right Vertical Edge",
          VR.kSS,
          VM.k1,
          false);
  static const Tag kExposureControlSensingRegionUpperHorizontalEdge
      //(0018,9438)
      = const Tag.public(
          "ExposureControlSensingRegionUpperHorizontalEdge",
          0x00189438,
          "Exposure Control Sensing Region Upper Horizontal Edge",
          VR.kSS,
          VM.k1,
          false);
  static const Tag kExposureControlSensingRegionLowerHorizontalEdge
      //(0018,9439)
      = const Tag.public(
          "ExposureControlSensingRegionLowerHorizontalEdge",
          0x00189439,
          "Exposure Control Sensing Region Lower Horizontal Edge",
          VR.kSS,
          VM.k1,
          false);
  static const Tag kCenterOfCircularExposureControlSensingRegion
      //(0018,9440)
      = const Tag.public(
          "CenterOfCircularExposureControlSensingRegion",
          0x00189440,
          "Center of Circular Exposure Control Sensing Region",
          VR.kSS,
          VM.k2,
          false);
  static const Tag kRadiusOfCircularExposureControlSensingRegion
      //(0018,9441)
      = const Tag.public(
          "RadiusOfCircularExposureControlSensingRegion",
          0x00189441,
          "Radius of Circular Exposure Control Sensing Region",
          VR.kUS,
          VM.k1,
          false);
  static const Tag kVerticesOfThePolygonalExposureControlSensingRegion
      //(0018,9442)
      = const Tag.public(
          "VerticesOfThePolygonalExposureControlSensingRegion",
          0x00189442,
          "Vertices of the Polygonal Exposure Control Sensing Region",
          VR.kSS,
          VM.k2_n,
          false);
  static const Tag kNoName0
      //(0018,9445)
      = const Tag.public(
          "NoName0", 0x00189445, "See Note 3", VR.kUnknown, VM.kNoVM, true);
  static const Tag kColumnAngulationPatient
      //(0018,9447)
      = const Tag.public("ColumnAngulationPatient", 0x00189447,
          "Column Angulation (Patient)", VR.kFL, VM.k1, false);
  static const Tag kBeamAngle
      //(0018,9449)
      = const Tag.public(
          "BeamAngle", 0x00189449, "Beam Angle", VR.kFL, VM.k1, false);
  static const Tag kFrameDetectorParametersSequence
      //(0018,9451)
      = const Tag.public("FrameDetectorParametersSequence", 0x00189451,
          "Frame Detector Parameters Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCalculatedAnatomyThickness
      //(0018,9452)
      = const Tag.public("CalculatedAnatomyThickness", 0x00189452,
          "Calculated Anatomy Thickness", VR.kFL, VM.k1, false);
  static const Tag kCalibrationSequence
      //(0018,9455)
      = const Tag.public("CalibrationSequence", 0x00189455,
          "Calibration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObjectThicknessSequence
      //(0018,9456)
      = const Tag.public("ObjectThicknessSequence", 0x00189456,
          "Object Thickness Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlaneIdentification
      //(0018,9457)
      = const Tag.public("PlaneIdentification", 0x00189457,
          "Plane Identification", VR.kCS, VM.k1, false);
  static const Tag kFieldOfViewDimensionsInFloat
      //(0018,9461)
      = const Tag.public("FieldOfViewDimensionsInFloat", 0x00189461,
          "Field of View Dimension(s) in Float", VR.kFL, VM.k1_2, false);
  static const Tag kIsocenterReferenceSystemSequence
      //(0018,9462)
      = const Tag.public("IsocenterReferenceSystemSequence", 0x00189462,
          "Isocenter Reference System Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPositionerIsocenterPrimaryAngle
      //(0018,9463)
      = const Tag.public("PositionerIsocenterPrimaryAngle", 0x00189463,
          "Positioner Isocenter Primary Angle", VR.kFL, VM.k1, false);
  static const Tag kPositionerIsocenterSecondaryAngle
      //(0018,9464)
      = const Tag.public("PositionerIsocenterSecondaryAngle", 0x00189464,
          "Positioner Isocenter Secondary Angle", VR.kFL, VM.k1, false);
  static const Tag kPositionerIsocenterDetectorRotationAngle
      //(0018,9465)
      = const Tag.public("PositionerIsocenterDetectorRotationAngle", 0x00189465,
          "Positioner Isocenter Detector Rotation Angle", VR.kFL, VM.k1, false);
  static const Tag kTableXPositionToIsocenter
      //(0018,9466)
      = const Tag.public("TableXPositionToIsocenter", 0x00189466,
          "Table X Position to Isocenter", VR.kFL, VM.k1, false);
  static const Tag kTableYPositionToIsocenter
      //(0018,9467)
      = const Tag.public("TableYPositionToIsocenter", 0x00189467,
          "Table Y Position to Isocenter", VR.kFL, VM.k1, false);
  static const Tag kTableZPositionToIsocenter
      //(0018,9468)
      = const Tag.public("TableZPositionToIsocenter", 0x00189468,
          "Table Z Position to Isocenter", VR.kFL, VM.k1, false);
  static const Tag kTableHorizontalRotationAngle
      //(0018,9469)
      = const Tag.public("TableHorizontalRotationAngle", 0x00189469,
          "Table Horizontal Rotation Angle", VR.kFL, VM.k1, false);
  static const Tag kTableHeadTiltAngle
      //(0018,9470)
      = const Tag.public("TableHeadTiltAngle", 0x00189470,
          "Table Head Tilt Angle", VR.kFL, VM.k1, false);
  static const Tag kTableCradleTiltAngle
      //(0018,9471)
      = const Tag.public("TableCradleTiltAngle", 0x00189471,
          "Table Cradle Tilt Angle", VR.kFL, VM.k1, false);
  static const Tag kFrameDisplayShutterSequence
      //(0018,9472)
      = const Tag.public("FrameDisplayShutterSequence", 0x00189472,
          "Frame Display Shutter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcquiredImageAreaDoseProduct
      //(0018,9473)
      = const Tag.public("AcquiredImageAreaDoseProduct", 0x00189473,
          "Acquired Image Area Dose Product", VR.kFL, VM.k1, false);
  static const Tag kCArmPositionerTabletopRelationship
      //(0018,9474)
      = const Tag.public("CArmPositionerTabletopRelationship", 0x00189474,
          "C-arm Positioner Tabletop Relationship", VR.kCS, VM.k1, false);
  static const Tag kXRayGeometrySequence
      //(0018,9476)
      = const Tag.public("XRayGeometrySequence", 0x00189476,
          "X-Ray Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIrradiationEventIdentificationSequence
      //(0018,9477)
      = const Tag.public("IrradiationEventIdentificationSequence", 0x00189477,
          "Irradiation Event Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXRay3DFrameTypeSequence
      //(0018,9504)
      = const Tag.public("XRay3DFrameTypeSequence", 0x00189504,
          "X-Ray 3D Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContributingSourcesSequence
      //(0018,9506)
      = const Tag.public("ContributingSourcesSequence", 0x00189506,
          "Contributing Sources Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXRay3DAcquisitionSequence
      //(0018,9507)
      = const Tag.public("XRay3DAcquisitionSequence", 0x00189507,
          "X-Ray 3D Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrimaryPositionerScanArc
      //(0018,9508)
      = const Tag.public("PrimaryPositionerScanArc", 0x00189508,
          "Primary Positioner Scan Arc", VR.kFL, VM.k1, false);
  static const Tag kSecondaryPositionerScanArc
      //(0018,9509)
      = const Tag.public("SecondaryPositionerScanArc", 0x00189509,
          "Secondary Positioner Scan Arc", VR.kFL, VM.k1, false);
  static const Tag kPrimaryPositionerScanStartAngle
      //(0018,9510)
      = const Tag.public("PrimaryPositionerScanStartAngle", 0x00189510,
          "Primary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const Tag kSecondaryPositionerScanStartAngle
      //(0018,9511)
      = const Tag.public("SecondaryPositionerScanStartAngle", 0x00189511,
          "Secondary Positioner Scan Start Angle", VR.kFL, VM.k1, false);
  static const Tag kPrimaryPositionerIncrement
      //(0018,9514)
      = const Tag.public("PrimaryPositionerIncrement", 0x00189514,
          "Primary Positioner Increment", VR.kFL, VM.k1, false);
  static const Tag kSecondaryPositionerIncrement
      //(0018,9515)
      = const Tag.public("SecondaryPositionerIncrement", 0x00189515,
          "Secondary Positioner Increment", VR.kFL, VM.k1, false);
  static const Tag kStartAcquisitionDateTime
      //(0018,9516)
      = const Tag.public("StartAcquisitionDateTime", 0x00189516,
          "Start Acquisition DateTime", VR.kDT, VM.k1, false);
  static const Tag kEndAcquisitionDateTime
      //(0018,9517)
      = const Tag.public("EndAcquisitionDateTime", 0x00189517,
          "End Acquisition DateTime", VR.kDT, VM.k1, false);
  static const Tag kApplicationName
      //(0018,9524)
      = const Tag.public("ApplicationName", 0x00189524, "Application Name",
          VR.kLO, VM.k1, false);
  static const Tag kApplicationVersion
      //(0018,9525)
      = const Tag.public("ApplicationVersion", 0x00189525,
          "Application Version", VR.kLO, VM.k1, false);
  static const Tag kApplicationManufacturer
      //(0018,9526)
      = const Tag.public("ApplicationManufacturer", 0x00189526,
          "Application Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kAlgorithmType
      //(0018,9527)
      = const Tag.public(
          "AlgorithmType", 0x00189527, "Algorithm Type", VR.kCS, VM.k1, false);
  static const Tag kAlgorithmDescription
      //(0018,9528)
      = const Tag.public("AlgorithmDescription", 0x00189528,
          "Algorithm Description", VR.kLO, VM.k1, false);
  static const Tag kXRay3DReconstructionSequence
      //(0018,9530)
      = const Tag.public("XRay3DReconstructionSequence", 0x00189530,
          "X-Ray 3D Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReconstructionDescription
      //(0018,9531)
      = const Tag.public("ReconstructionDescription", 0x00189531,
          "Reconstruction Description", VR.kLO, VM.k1, false);
  static const Tag kPerProjectionAcquisitionSequence
      //(0018,9538)
      = const Tag.public("PerProjectionAcquisitionSequence", 0x00189538,
          "Per Projection Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDiffusionBMatrixSequence
      //(0018,9601)
      = const Tag.public("DiffusionBMatrixSequence", 0x00189601,
          "Diffusion b-matrix Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDiffusionBValueXX
      //(0018,9602)
      = const Tag.public("DiffusionBValueXX", 0x00189602,
          "Diffusion b-value XX", VR.kFD, VM.k1, false);
  static const Tag kDiffusionBValueXY
      //(0018,9603)
      = const Tag.public("DiffusionBValueXY", 0x00189603,
          "Diffusion b-value XY", VR.kFD, VM.k1, false);
  static const Tag kDiffusionBValueXZ
      //(0018,9604)
      = const Tag.public("DiffusionBValueXZ", 0x00189604,
          "Diffusion b-value XZ", VR.kFD, VM.k1, false);
  static const Tag kDiffusionBValueYY
      //(0018,9605)
      = const Tag.public("DiffusionBValueYY", 0x00189605,
          "Diffusion b-value YY", VR.kFD, VM.k1, false);
  static const Tag kDiffusionBValueYZ
      //(0018,9606)
      = const Tag.public("DiffusionBValueYZ", 0x00189606,
          "Diffusion b-value YZ", VR.kFD, VM.k1, false);
  static const Tag kDiffusionBValueZZ
      //(0018,9607)
      = const Tag.public("DiffusionBValueZZ", 0x00189607,
          "Diffusion b-value ZZ", VR.kFD, VM.k1, false);
  static const Tag kDecayCorrectionDateTime
      //(0018,9701)
      = const Tag.public("DecayCorrectionDateTime", 0x00189701,
          "Decay Correction DateTime", VR.kDT, VM.k1, false);
  static const Tag kStartDensityThreshold
      //(0018,9715)
      = const Tag.public("StartDensityThreshold", 0x00189715,
          "Start Density Threshold", VR.kFD, VM.k1, false);
  static const Tag kStartRelativeDensityDifferenceThreshold
      //(0018,9716)
      = const Tag.public("StartRelativeDensityDifferenceThreshold", 0x00189716,
          "Start Relative Density Difference Threshold", VR.kFD, VM.k1, false);
  static const Tag kStartCardiacTriggerCountThreshold
      //(0018,9717)
      = const Tag.public("StartCardiacTriggerCountThreshold", 0x00189717,
          "Start Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const Tag kStartRespiratoryTriggerCountThreshold
      //(0018,9718)
      = const Tag.public("StartRespiratoryTriggerCountThreshold", 0x00189718,
          "Start Respiratory Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationCountsThreshold
      //(0018,9719)
      = const Tag.public("TerminationCountsThreshold", 0x00189719,
          "Termination Counts Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationDensityThreshold
      //(0018,9720)
      = const Tag.public("TerminationDensityThreshold", 0x00189720,
          "Termination Density Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationRelativeDensityThreshold
      //(0018,9721)
      = const Tag.public("TerminationRelativeDensityThreshold", 0x00189721,
          "Termination Relative Density Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationTimeThreshold
      //(0018,9722)
      = const Tag.public("TerminationTimeThreshold", 0x00189722,
          "Termination Time Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationCardiacTriggerCountThreshold
      //(0018,9723)
      = const Tag.public("TerminationCardiacTriggerCountThreshold", 0x00189723,
          "Termination Cardiac Trigger Count Threshold", VR.kFD, VM.k1, false);
  static const Tag kTerminationRespiratoryTriggerCountThreshold
      //(0018,9724)
      = const Tag.public(
          "TerminationRespiratoryTriggerCountThreshold",
          0x00189724,
          "Termination Respiratory Trigger Count Threshold",
          VR.kFD,
          VM.k1,
          false);
  static const Tag kDetectorGeometry
      //(0018,9725)
      = const Tag.public("DetectorGeometry", 0x00189725, "Detector Geometry",
          VR.kCS, VM.k1, false);
  static const Tag kTransverseDetectorSeparation
      //(0018,9726)
      = const Tag.public("TransverseDetectorSeparation", 0x00189726,
          "Transverse Detector Separation", VR.kFD, VM.k1, false);
  static const Tag kAxialDetectorDimension
      //(0018,9727)
      = const Tag.public("AxialDetectorDimension", 0x00189727,
          "Axial Detector Dimension", VR.kFD, VM.k1, false);
  static const Tag kRadiopharmaceuticalAgentNumber
      //(0018,9729)
      = const Tag.public("RadiopharmaceuticalAgentNumber", 0x00189729,
          "Radiopharmaceutical Agent Number", VR.kUS, VM.k1, false);
  static const Tag kPETFrameAcquisitionSequence
      //(0018,9732)
      = const Tag.public("PETFrameAcquisitionSequence", 0x00189732,
          "PET Frame Acquisition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPETDetectorMotionDetailsSequence
      //(0018,9733)
      = const Tag.public("PETDetectorMotionDetailsSequence", 0x00189733,
          "PET Detector Motion Details Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPETTableDynamicsSequence
      //(0018,9734)
      = const Tag.public("PETTableDynamicsSequence", 0x00189734,
          "PET Table Dynamics Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPETPositionSequence
      //(0018,9735)
      = const Tag.public("PETPositionSequence", 0x00189735,
          "PET Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPETFrameCorrectionFactorsSequence
      //(0018,9736)
      = const Tag.public("PETFrameCorrectionFactorsSequence", 0x00189736,
          "PET Frame Correction Factors Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRadiopharmaceuticalUsageSequence
      //(0018,9737)
      = const Tag.public("RadiopharmaceuticalUsageSequence", 0x00189737,
          "Radiopharmaceutical Usage Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAttenuationCorrectionSource
      //(0018,9738)
      = const Tag.public("AttenuationCorrectionSource", 0x00189738,
          "Attenuation Correction Source", VR.kCS, VM.k1, false);
  static const Tag kNumberOfIterations
      //(0018,9739)
      = const Tag.public("NumberOfIterations", 0x00189739,
          "Number of Iterations", VR.kUS, VM.k1, false);
  static const Tag kNumberOfSubsets
      //(0018,9740)
      = const Tag.public("NumberOfSubsets", 0x00189740, "Number of Subsets",
          VR.kUS, VM.k1, false);
  static const Tag kPETReconstructionSequence
      //(0018,9749)
      = const Tag.public("PETReconstructionSequence", 0x00189749,
          "PET Reconstruction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPETFrameTypeSequence
      //(0018,9751)
      = const Tag.public("PETFrameTypeSequence", 0x00189751,
          "PET Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTimeOfFlightInformationUsed
      //(0018,9755)
      = const Tag.public("TimeOfFlightInformationUsed", 0x00189755,
          "Time of Flight Information Used", VR.kCS, VM.k1, false);
  static const Tag kReconstructionType
      //(0018,9756)
      = const Tag.public("ReconstructionType", 0x00189756,
          "Reconstruction Type", VR.kCS, VM.k1, false);
  static const Tag kDecayCorrected
      //(0018,9758)
      = const Tag.public("DecayCorrected", 0x00189758, "Decay Corrected",
          VR.kCS, VM.k1, false);
  static const Tag kAttenuationCorrected
      //(0018,9759)
      = const Tag.public("AttenuationCorrected", 0x00189759,
          "Attenuation Corrected", VR.kCS, VM.k1, false);
  static const Tag kScatterCorrected
      //(0018,9760)
      = const Tag.public("ScatterCorrected", 0x00189760, "Scatter Corrected",
          VR.kCS, VM.k1, false);
  static const Tag kDeadTimeCorrected
      //(0018,9761)
      = const Tag.public("DeadTimeCorrected", 0x00189761, "Dead Time Corrected",
          VR.kCS, VM.k1, false);
  static const Tag kGantryMotionCorrected
      //(0018,9762)
      = const Tag.public("GantryMotionCorrected", 0x00189762,
          "Gantry Motion Corrected", VR.kCS, VM.k1, false);
  static const Tag kPatientMotionCorrected
      //(0018,9763)
      = const Tag.public("PatientMotionCorrected", 0x00189763,
          "Patient Motion Corrected", VR.kCS, VM.k1, false);
  static const Tag kCountLossNormalizationCorrected
      //(0018,9764)
      = const Tag.public("CountLossNormalizationCorrected", 0x00189764,
          "Count Loss Normalization Corrected", VR.kCS, VM.k1, false);
  static const Tag kRandomsCorrected
      //(0018,9765)
      = const Tag.public("RandomsCorrected", 0x00189765, "Randoms Corrected",
          VR.kCS, VM.k1, false);
  static const Tag kNonUniformRadialSamplingCorrected
      //(0018,9766)
      = const Tag.public("NonUniformRadialSamplingCorrected", 0x00189766,
          "Non-uniform Radial Sampling Corrected", VR.kCS, VM.k1, false);
  static const Tag kSensitivityCalibrated
      //(0018,9767)
      = const Tag.public("SensitivityCalibrated", 0x00189767,
          "Sensitivity Calibrated", VR.kCS, VM.k1, false);
  static const Tag kDetectorNormalizationCorrection
      //(0018,9768)
      = const Tag.public("DetectorNormalizationCorrection", 0x00189768,
          "Detector Normalization Correction", VR.kCS, VM.k1, false);
  static const Tag kIterativeReconstructionMethod
      //(0018,9769)
      = const Tag.public("IterativeReconstructionMethod", 0x00189769,
          "Iterative Reconstruction Method", VR.kCS, VM.k1, false);
  static const Tag kAttenuationCorrectionTemporalRelationship
      //(0018,9770)
      = const Tag.public(
          "AttenuationCorrectionTemporalRelationship",
          0x00189770,
          "Attenuation Correction Temporal Relationship",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kPatientPhysiologicalStateSequence
      //(0018,9771)
      = const Tag.public("PatientPhysiologicalStateSequence", 0x00189771,
          "Patient Physiological State Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientPhysiologicalStateCodeSequence
      //(0018,9772)
      = const Tag.public("PatientPhysiologicalStateCodeSequence", 0x00189772,
          "Patient Physiological State Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDepthsOfFocus
      //(0018,9801)
      = const Tag.public("DepthsOfFocus", 0x00189801, "Depth(s) of Focus",
          VR.kFD, VM.k1_n, false);
  static const Tag kExcludedIntervalsSequence
      //(0018,9803)
      = const Tag.public("ExcludedIntervalsSequence", 0x00189803,
          "Excluded Intervals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kExclusionStartDateTime
      //(0018,9804)
      = const Tag.public("ExclusionStartDateTime", 0x00189804,
          "Exclusion Start DateTime", VR.kDT, VM.k1, false);
  static const Tag kExclusionDuration
      //(0018,9805)
      = const Tag.public("ExclusionDuration", 0x00189805, "Exclusion Duration",
          VR.kFD, VM.k1, false);
  static const Tag kUSImageDescriptionSequence
      //(0018,9806)
      = const Tag.public("USImageDescriptionSequence", 0x00189806,
          "US Image Description Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageDataTypeSequence
      //(0018,9807)
      = const Tag.public("ImageDataTypeSequence", 0x00189807,
          "Image Data Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataType
      //(0018,9808)
      = const Tag.public(
          "DataType", 0x00189808, "Data Type", VR.kCS, VM.k1, false);
  static const Tag kTransducerScanPatternCodeSequence
      //(0018,9809)
      = const Tag.public("TransducerScanPatternCodeSequence", 0x00189809,
          "Transducer Scan Pattern Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAliasedDataType
      //(0018,980B)
      = const Tag.public("AliasedDataType", 0x0018980B, "Aliased Data Type",
          VR.kCS, VM.k1, false);
  static const Tag kPositionMeasuringDeviceUsed
      //(0018,980C)
      = const Tag.public("PositionMeasuringDeviceUsed", 0x0018980C,
          "Position Measuring Device Used", VR.kCS, VM.k1, false);
  static const Tag kTransducerGeometryCodeSequence
      //(0018,980D)
      = const Tag.public("TransducerGeometryCodeSequence", 0x0018980D,
          "Transducer Geometry Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransducerBeamSteeringCodeSequence
      //(0018,980E)
      = const Tag.public("TransducerBeamSteeringCodeSequence", 0x0018980E,
          "Transducer Beam Steering Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransducerApplicationCodeSequence
      //(0018,980F)
      = const Tag.public("TransducerApplicationCodeSequence", 0x0018980F,
          "Transducer Application Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kZeroVelocityPixelValue
      //(0018,9810)
      = const Tag.public("ZeroVelocityPixelValue", 0x00189810,
          "Zero Velocity Pixel Value", VR.kUSSS, VM.k1, false);
  static const Tag kContributingEquipmentSequence
      //(0018,A001)
      = const Tag.public("ContributingEquipmentSequence", 0x0018A001,
          "Contributing Equipment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContributionDateTime
      //(0018,A002)
      = const Tag.public("ContributionDateTime", 0x0018A002,
          "Contribution DateTime", VR.kDT, VM.k1, false);
  static const Tag kContributionDescription
      //(0018,A003)
      = const Tag.public("ContributionDescription", 0x0018A003,
          "Contribution Description", VR.kST, VM.k1, false);
  static const Tag kStudyInstanceUID
      //(0020,000D)
      = const Tag.public("StudyInstanceUID", 0x0020000D, "Study Instance UID",
          VR.kUI, VM.k1, false);
  static const Tag kSeriesInstanceUID
      //(0020,000E)
      = const Tag.public("SeriesInstanceUID", 0x0020000E, "Series Instance UID",
          VR.kUI, VM.k1, false);
  static const Tag kStudyID
      //(0020,0010)
      =
      const Tag.public("StudyID", 0x00200010, "Study ID", VR.kSH, VM.k1, false);
  static const Tag kSeriesNumber
      //(0020,0011)
      = const Tag.public(
          "SeriesNumber", 0x00200011, "Series Number", VR.kIS, VM.k1, false);
  static const Tag kAcquisitionNumber
      //(0020,0012)
      = const Tag.public("AcquisitionNumber", 0x00200012, "Acquisition Number",
          VR.kIS, VM.k1, false);
  static const Tag kInstanceNumber
      //(0020,0013)
      = const Tag.public("InstanceNumber", 0x00200013, "Instance Number",
          VR.kIS, VM.k1, false);
  static const Tag kIsotopeNumber
      //(0020,0014)
      = const Tag.public(
          "IsotopeNumber", 0x00200014, "Isotope Number", VR.kIS, VM.k1, true);
  static const Tag kPhaseNumber
      //(0020,0015)
      = const Tag.public(
          "PhaseNumber", 0x00200015, "Phase Number", VR.kIS, VM.k1, true);
  static const Tag kIntervalNumber
      //(0020,0016)
      = const Tag.public(
          "IntervalNumber", 0x00200016, "Interval Number", VR.kIS, VM.k1, true);
  static const Tag kTimeSlotNumber
      //(0020,0017)
      = const Tag.public("TimeSlotNumber", 0x00200017, "Time Slot Number",
          VR.kIS, VM.k1, true);
  static const Tag kAngleNumber
      //(0020,0018)
      = const Tag.public(
          "AngleNumber", 0x00200018, "Angle Number", VR.kIS, VM.k1, true);
  static const Tag kItemNumber
      //(0020,0019)
      = const Tag.public(
          "ItemNumber", 0x00200019, "Item Number", VR.kIS, VM.k1, false);
  static const Tag kPatientOrientation
      //(0020,0020)
      = const Tag.public("PatientOrientation", 0x00200020,
          "Patient Orientation", VR.kCS, VM.k2, false);
  static const Tag kOverlayNumber
      //(0020,0022)
      = const Tag.public(
          "OverlayNumber", 0x00200022, "Overlay Number", VR.kIS, VM.k1, true);
  static const Tag kCurveNumber
      //(0020,0024)
      = const Tag.public(
          "CurveNumber", 0x00200024, "Curve Number", VR.kIS, VM.k1, true);
  static const Tag kLUTNumber
      //(0020,0026)
      = const Tag.public(
          "LUTNumber", 0x00200026, "LUT Number", VR.kIS, VM.k1, true);
  static const Tag kImagePosition
      //(0020,0030)
      = const Tag.public(
          "ImagePosition", 0x00200030, "Image Position", VR.kDS, VM.k3, true);
  static const Tag kImagePositionPatient
      //(0020,0032)
      = const Tag.public("ImagePositionPatient", 0x00200032,
          "Image Position (Patient)", VR.kDS, VM.k3, false);
  static const Tag kImageOrientation
      //(0020,0035)
      = const Tag.public("ImageOrientation", 0x00200035, "Image Orientation",
          VR.kDS, VM.k6, true);
  static const Tag kImageOrientationPatient
      //(0020,0037)
      = const Tag.public("ImageOrientationPatient", 0x00200037,
          "Image Orientation (Patient)", VR.kDS, VM.k6, false);
  static const Tag kLocation
      //(0020,0050)
      =
      const Tag.public("Location", 0x00200050, "Location", VR.kDS, VM.k1, true);
  static const Tag kFrameOfReferenceUID
      //(0020,0052)
      = const Tag.public("FrameOfReferenceUID", 0x00200052,
          "Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kLaterality
      //(0020,0060)
      = const Tag.public(
          "Laterality", 0x00200060, "Laterality", VR.kCS, VM.k1, false);
  static const Tag kImageLaterality
      //(0020,0062)
      = const Tag.public("ImageLaterality", 0x00200062, "Image Laterality",
          VR.kCS, VM.k1, false);
  static const Tag kImageGeometryType
      //(0020,0070)
      = const Tag.public("ImageGeometryType", 0x00200070, "Image Geometry Type",
          VR.kLO, VM.k1, true);
  static const Tag kMaskingImage
      //(0020,0080)
      = const Tag.public(
          "MaskingImage", 0x00200080, "Masking Image", VR.kCS, VM.k1_n, true);
  static const Tag kReportNumber
      //(0020,00AA)
      = const Tag.public(
          "ReportNumber", 0x002000AA, "Report Number", VR.kIS, VM.k1, true);
  static const Tag kTemporalPositionIdentifier
      //(0020,0100)
      = const Tag.public("TemporalPositionIdentifier", 0x00200100,
          "Temporal Position Identifier", VR.kIS, VM.k1, false);
  static const Tag kNumberOfTemporalPositions
      //(0020,0105)
      = const Tag.public("NumberOfTemporalPositions", 0x00200105,
          "Number of Temporal Positions", VR.kIS, VM.k1, false);
  static const Tag kTemporalResolution
      //(0020,0110)
      = const Tag.public("TemporalResolution", 0x00200110,
          "Temporal Resolution", VR.kDS, VM.k1, false);
  static const Tag kSynchronizationFrameOfReferenceUID
      //(0020,0200)
      = const Tag.public("SynchronizationFrameOfReferenceUID", 0x00200200,
          "Synchronization Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kSOPInstanceUIDOfConcatenationSource
      //(0020,0242)
      = const Tag.public("SOPInstanceUIDOfConcatenationSource", 0x00200242,
          "SOP Instance UID of Concatenation Source", VR.kUI, VM.k1, false);
  static const Tag kSeriesInStudy
      //(0020,1000)
      = const Tag.public(
          "SeriesInStudy", 0x00201000, "Series in Study", VR.kIS, VM.k1, true);
  static const Tag kAcquisitionsInSeries
      //(0020,1001)
      = const Tag.public("AcquisitionsInSeries", 0x00201001,
          "Acquisitions in Series", VR.kIS, VM.k1, true);
  static const Tag kImagesInAcquisition
      //(0020,1002)
      = const Tag.public("ImagesInAcquisition", 0x00201002,
          "Images in Acquisition", VR.kIS, VM.k1, false);
  static const Tag kImagesInSeries
      //(0020,1003)
      = const Tag.public("ImagesInSeries", 0x00201003, "Images in Series",
          VR.kIS, VM.k1, true);
  static const Tag kAcquisitionsInStudy
      //(0020,1004)
      = const Tag.public("AcquisitionsInStudy", 0x00201004,
          "Acquisitions in Study", VR.kIS, VM.k1, true);
  static const Tag kImagesInStudy
      //(0020,1005)
      = const Tag.public(
          "ImagesInStudy", 0x00201005, "Images in Study", VR.kIS, VM.k1, true);
  static const Tag kReference
      //(0020,1020)
      = const Tag.public(
          "Reference", 0x00201020, "Reference", VR.kLO, VM.k1_n, true);
  static const Tag kPositionReferenceIndicator
      //(0020,1040)
      = const Tag.public("PositionReferenceIndicator", 0x00201040,
          "Position Reference Indicator", VR.kLO, VM.k1, false);
  static const Tag kSliceLocation
      //(0020,1041)
      = const Tag.public(
          "SliceLocation", 0x00201041, "Slice Location", VR.kDS, VM.k1, false);
  static const Tag kOtherStudyNumbers
      //(0020,1070)
      = const Tag.public("OtherStudyNumbers", 0x00201070, "Other Study Numbers",
          VR.kIS, VM.k1_n, true);
  static const Tag kNumberOfPatientRelatedStudies
      //(0020,1200)
      = const Tag.public("NumberOfPatientRelatedStudies", 0x00201200,
          "Number of Patient Related Studies", VR.kIS, VM.k1, false);
  static const Tag kNumberOfPatientRelatedSeries
      //(0020,1202)
      = const Tag.public("NumberOfPatientRelatedSeries", 0x00201202,
          "Number of Patient Related Series", VR.kIS, VM.k1, false);
  static const Tag kNumberOfPatientRelatedInstances
      //(0020,1204)
      = const Tag.public("NumberOfPatientRelatedInstances", 0x00201204,
          "Number of Patient Related Instances", VR.kIS, VM.k1, false);
  static const Tag kNumberOfStudyRelatedSeries
      //(0020,1206)
      = const Tag.public("NumberOfStudyRelatedSeries", 0x00201206,
          "Number of Study Related Series", VR.kIS, VM.k1, false);
  static const Tag kNumberOfStudyRelatedInstances
      //(0020,1208)
      = const Tag.public("NumberOfStudyRelatedInstances", 0x00201208,
          "Number of Study Related Instances", VR.kIS, VM.k1, false);
  static const Tag kNumberOfSeriesRelatedInstances
      //(0020,1209)
      = const Tag.public("NumberOfSeriesRelatedInstances", 0x00201209,
          "Number of Series Related Instances", VR.kIS, VM.k1, false);
  static const Tag kSourceImageIDs
      //(0020,3100)
      = const Tag.public("SourceImageIDs", 0x00203100, "Source Image IDs",
          VR.kCS, VM.k1_n, true);
  static const Tag kModifyingDeviceID
      //(0020,3401)
      = const Tag.public("ModifyingDeviceID", 0x00203401, "Modifying Device ID",
          VR.kCS, VM.k1, true);
  static const Tag kModifiedImageID
      //(0020,3402)
      = const Tag.public("ModifiedImageID", 0x00203402, "Modified Image ID",
          VR.kCS, VM.k1, true);
  static const Tag kModifiedImageDate
      //(0020,3403)
      = const Tag.public("ModifiedImageDate", 0x00203403, "Modified Image Date",
          VR.kDA, VM.k1, true);
  static const Tag kModifyingDeviceManufacturer
      //(0020,3404)
      = const Tag.public("ModifyingDeviceManufacturer", 0x00203404,
          "Modifying Device Manufacturer", VR.kLO, VM.k1, true);
  static const Tag kModifiedImageTime
      //(0020,3405)
      = const Tag.public("ModifiedImageTime", 0x00203405, "Modified Image Time",
          VR.kTM, VM.k1, true);
  static const Tag kModifiedImageDescription
      //(0020,3406)
      = const Tag.public("ModifiedImageDescription", 0x00203406,
          "Modified Image Description", VR.kLO, VM.k1, true);
  static const Tag kImageComments
      //(0020,4000)
      = const Tag.public(
          "ImageComments", 0x00204000, "Image Comments", VR.kLT, VM.k1, false);
  static const Tag kOriginalImageIdentification
      //(0020,5000)
      = const Tag.public("OriginalImageIdentification", 0x00205000,
          "Original Image Identification", VR.kAT, VM.k1_n, true);
  static const Tag kOriginalImageIdentificationNomenclature
      //(0020,5002)
      = const Tag.public("OriginalImageIdentificationNomenclature", 0x00205002,
          "Original Image Identification Nomenclature", VR.kLO, VM.k1_n, true);
  static const Tag kStackID
      //(0020,9056)
      =
      const Tag.public("StackID", 0x00209056, "Stack ID", VR.kSH, VM.k1, false);
  static const Tag kInStackPositionNumber
      //(0020,9057)
      = const Tag.public("InStackPositionNumber", 0x00209057,
          "In-Stack Position Number", VR.kUL, VM.k1, false);
  static const Tag kFrameAnatomySequence
      //(0020,9071)
      = const Tag.public("FrameAnatomySequence", 0x00209071,
          "Frame Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFrameLaterality
      //(0020,9072)
      = const Tag.public("FrameLaterality", 0x00209072, "Frame Laterality",
          VR.kCS, VM.k1, false);
  static const Tag kFrameContentSequence
      //(0020,9111)
      = const Tag.public("FrameContentSequence", 0x00209111,
          "Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanePositionSequence
      //(0020,9113)
      = const Tag.public("PlanePositionSequence", 0x00209113,
          "Plane Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlaneOrientationSequence
      //(0020,9116)
      = const Tag.public("PlaneOrientationSequence", 0x00209116,
          "Plane Orientation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTemporalPositionIndex
      //(0020,9128)
      = const Tag.public("TemporalPositionIndex", 0x00209128,
          "Temporal Position Index", VR.kUL, VM.k1, false);
  static const Tag kNominalCardiacTriggerDelayTime
      //(0020,9153)
      = const Tag.public("NominalCardiacTriggerDelayTime", 0x00209153,
          "Nominal Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const Tag kNominalCardiacTriggerTimePriorToRPeak
      //(0020,9154)
      = const Tag.public("NominalCardiacTriggerTimePriorToRPeak", 0x00209154,
          "Nominal Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const Tag kActualCardiacTriggerTimePriorToRPeak
      //(0020,9155)
      = const Tag.public("ActualCardiacTriggerTimePriorToRPeak", 0x00209155,
          "Actual Cardiac Trigger Time Prior To R-Peak", VR.kFL, VM.k1, false);
  static const Tag kFrameAcquisitionNumber
      //(0020,9156)
      = const Tag.public("FrameAcquisitionNumber", 0x00209156,
          "Frame Acquisition Number", VR.kUS, VM.k1, false);
  static const Tag kDimensionIndexValues
      //(0020,9157)
      = const Tag.public("DimensionIndexValues", 0x00209157,
          "Dimension Index Values", VR.kUL, VM.k1_n, false);
  static const Tag kFrameComments
      //(0020,9158)
      = const Tag.public(
          "FrameComments", 0x00209158, "Frame Comments", VR.kLT, VM.k1, false);
  static const Tag kConcatenationUID
      //(0020,9161)
      = const Tag.public("ConcatenationUID", 0x00209161, "Concatenation UID",
          VR.kUI, VM.k1, false);
  static const Tag kInConcatenationNumber
      //(0020,9162)
      = const Tag.public("InConcatenationNumber", 0x00209162,
          "In-concatenation Number", VR.kUS, VM.k1, false);
  static const Tag kInConcatenationTotalNumber
      //(0020,9163)
      = const Tag.public("InConcatenationTotalNumber", 0x00209163,
          "In-concatenation Total Number", VR.kUS, VM.k1, false);
  static const Tag kDimensionOrganizationUID
      //(0020,9164)
      = const Tag.public("DimensionOrganizationUID", 0x00209164,
          "Dimension Organization UID", VR.kUI, VM.k1, false);
  static const Tag kDimensionIndexPointer
      //(0020,9165)
      = const Tag.public("DimensionIndexPointer", 0x00209165,
          "Dimension Index Pointer", VR.kAT, VM.k1, false);
  static const Tag kFunctionalGroupPointer
      //(0020,9167)
      = const Tag.public("FunctionalGroupPointer", 0x00209167,
          "Functional Group Pointer", VR.kAT, VM.k1, false);
  static const Tag kUnassignedSharedConvertedAttributesSequence
      //(0020,9170)
      = const Tag.public(
          "UnassignedSharedConvertedAttributesSequence",
          0x00209170,
          "Unassigned Shared Converted Attributes Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kUnassignedPerFrameConvertedAttributesSequence
      //(0020,9171)
      = const Tag.public(
          "UnassignedPerFrameConvertedAttributesSequence",
          0x00209171,
          "Unassigned Per-Frame Converted Attributes Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kConversionSourceAttributesSequence
      //(0020,9172)
      = const Tag.public("ConversionSourceAttributesSequence", 0x00209172,
          "Conversion Source Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDimensionIndexPrivateCreator
      //(0020,9213)
      = const Tag.public("DimensionIndexPrivateCreator", 0x00209213,
          "Dimension Index Private Creator", VR.kLO, VM.k1, false);
  static const Tag kDimensionOrganizationSequence
      //(0020,9221)
      = const Tag.public("DimensionOrganizationSequence", 0x00209221,
          "Dimension Organization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDimensionIndexSequence
      //(0020,9222)
      = const Tag.public("DimensionIndexSequence", 0x00209222,
          "Dimension Index Sequence", VR.kSQ, VM.k1, false);
  static const Tag kConcatenationFrameOffsetNumber
      //(0020,9228)
      = const Tag.public("ConcatenationFrameOffsetNumber", 0x00209228,
          "Concatenation Frame Offset Number", VR.kUL, VM.k1, false);
  static const Tag kFunctionalGroupPrivateCreator
      //(0020,9238)
      = const Tag.public("FunctionalGroupPrivateCreator", 0x00209238,
          "Functional Group Private Creator", VR.kLO, VM.k1, false);
  static const Tag kNominalPercentageOfCardiacPhase
      //(0020,9241)
      = const Tag.public("NominalPercentageOfCardiacPhase", 0x00209241,
          "Nominal Percentage of Cardiac Phase", VR.kFL, VM.k1, false);
  static const Tag kNominalPercentageOfRespiratoryPhase
      //(0020,9245)
      = const Tag.public("NominalPercentageOfRespiratoryPhase", 0x00209245,
          "Nominal Percentage of Respiratory Phase", VR.kFL, VM.k1, false);
  static const Tag kStartingRespiratoryAmplitude
      //(0020,9246)
      = const Tag.public("StartingRespiratoryAmplitude", 0x00209246,
          "Starting Respiratory Amplitude", VR.kFL, VM.k1, false);
  static const Tag kStartingRespiratoryPhase
      //(0020,9247)
      = const Tag.public("StartingRespiratoryPhase", 0x00209247,
          "Starting Respiratory Phase", VR.kCS, VM.k1, false);
  static const Tag kEndingRespiratoryAmplitude
      //(0020,9248)
      = const Tag.public("EndingRespiratoryAmplitude", 0x00209248,
          "Ending Respiratory Amplitude", VR.kFL, VM.k1, false);
  static const Tag kEndingRespiratoryPhase
      //(0020,9249)
      = const Tag.public("EndingRespiratoryPhase", 0x00209249,
          "Ending Respiratory Phase", VR.kCS, VM.k1, false);
  static const Tag kRespiratoryTriggerType
      //(0020,9250)
      = const Tag.public("RespiratoryTriggerType", 0x00209250,
          "Respiratory Trigger Type", VR.kCS, VM.k1, false);
  static const Tag kRRIntervalTimeNominal
      //(0020,9251)
      = const Tag.public("RRIntervalTimeNominal", 0x00209251,
          "R-R Interval Time Nominal", VR.kFD, VM.k1, false);
  static const Tag kActualCardiacTriggerDelayTime
      //(0020,9252)
      = const Tag.public("ActualCardiacTriggerDelayTime", 0x00209252,
          "Actual Cardiac Trigger Delay Time", VR.kFD, VM.k1, false);
  static const Tag kRespiratorySynchronizationSequence
      //(0020,9253)
      = const Tag.public("RespiratorySynchronizationSequence", 0x00209253,
          "Respiratory Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRespiratoryIntervalTime
      //(0020,9254)
      = const Tag.public("RespiratoryIntervalTime", 0x00209254,
          "Respiratory Interval Time", VR.kFD, VM.k1, false);
  static const Tag kNominalRespiratoryTriggerDelayTime
      //(0020,9255)
      = const Tag.public("NominalRespiratoryTriggerDelayTime", 0x00209255,
          "Nominal Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const Tag kRespiratoryTriggerDelayThreshold
      //(0020,9256)
      = const Tag.public("RespiratoryTriggerDelayThreshold", 0x00209256,
          "Respiratory Trigger Delay Threshold", VR.kFD, VM.k1, false);
  static const Tag kActualRespiratoryTriggerDelayTime
      //(0020,9257)
      = const Tag.public("ActualRespiratoryTriggerDelayTime", 0x00209257,
          "Actual Respiratory Trigger Delay Time", VR.kFD, VM.k1, false);
  static const Tag kImagePositionVolume
      //(0020,9301)
      = const Tag.public("ImagePositionVolume", 0x00209301,
          "Image Position (Volume)", VR.kFD, VM.k3, false);
  static const Tag kImageOrientationVolume
      //(0020,9302)
      = const Tag.public("ImageOrientationVolume", 0x00209302,
          "Image Orientation (Volume)", VR.kFD, VM.k6, false);
  static const Tag kUltrasoundAcquisitionGeometry
      //(0020,9307)
      = const Tag.public("UltrasoundAcquisitionGeometry", 0x00209307,
          "Ultrasound Acquisition Geometry", VR.kCS, VM.k1, false);
  static const Tag kApexPosition
      //(0020,9308)
      = const Tag.public(
          "ApexPosition", 0x00209308, "Apex Position", VR.kFD, VM.k3, false);
  static const Tag kVolumeToTransducerMappingMatrix
      //(0020,9309)
      = const Tag.public("VolumeToTransducerMappingMatrix", 0x00209309,
          "Volume to Transducer Mapping Matrix", VR.kFD, VM.k16, false);
  static const Tag kVolumeToTableMappingMatrix
      //(0020,930A)
      = const Tag.public("VolumeToTableMappingMatrix", 0x0020930A,
          "Volume to Table Mapping Matrix", VR.kFD, VM.k16, false);
  static const Tag kPatientFrameOfReferenceSource
      //(0020,930C)
      = const Tag.public("PatientFrameOfReferenceSource", 0x0020930C,
          "Patient Frame of Reference Source", VR.kCS, VM.k1, false);
  static const Tag kTemporalPositionTimeOffset
      //(0020,930D)
      = const Tag.public("TemporalPositionTimeOffset", 0x0020930D,
          "Temporal Position Time Offset", VR.kFD, VM.k1, false);
  static const Tag kPlanePositionVolumeSequence
      //(0020,930E)
      = const Tag.public("PlanePositionVolumeSequence", 0x0020930E,
          "Plane Position (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlaneOrientationVolumeSequence
      //(0020,930F)
      = const Tag.public("PlaneOrientationVolumeSequence", 0x0020930F,
          "Plane Orientation (Volume) Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTemporalPositionSequence
      //(0020,9310)
      = const Tag.public("TemporalPositionSequence", 0x00209310,
          "Temporal Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDimensionOrganizationType
      //(0020,9311)
      = const Tag.public("DimensionOrganizationType", 0x00209311,
          "Dimension Organization Type", VR.kCS, VM.k1, false);
  static const Tag kVolumeFrameOfReferenceUID
      //(0020,9312)
      = const Tag.public("VolumeFrameOfReferenceUID", 0x00209312,
          "Volume Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kTableFrameOfReferenceUID
      //(0020,9313)
      = const Tag.public("TableFrameOfReferenceUID", 0x00209313,
          "Table Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kDimensionDescriptionLabel
      //(0020,9421)
      = const Tag.public("DimensionDescriptionLabel", 0x00209421,
          "Dimension Description Label", VR.kLO, VM.k1, false);
  static const Tag kPatientOrientationInFrameSequence
      //(0020,9450)
      = const Tag.public("PatientOrientationInFrameSequence", 0x00209450,
          "Patient Orientation in Frame Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFrameLabel
      //(0020,9453)
      = const Tag.public(
          "FrameLabel", 0x00209453, "Frame Label", VR.kLO, VM.k1, false);
  static const Tag kAcquisitionIndex
      //(0020,9518)
      = const Tag.public("AcquisitionIndex", 0x00209518, "Acquisition Index",
          VR.kUS, VM.k1_n, false);
  static const Tag kContributingSOPInstancesReferenceSequence
      //(0020,9529)
      = const Tag.public(
          "ContributingSOPInstancesReferenceSequence",
          0x00209529,
          "Contributing SOP Instances Reference Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReconstructionIndex
      //(0020,9536)
      = const Tag.public("ReconstructionIndex", 0x00209536,
          "Reconstruction Index", VR.kUS, VM.k1, false);
  static const Tag kLightPathFilterPassThroughWavelength
      //(0022,0001)
      = const Tag.public("LightPathFilterPassThroughWavelength", 0x00220001,
          "Light Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const Tag kLightPathFilterPassBand
      //(0022,0002)
      = const Tag.public("LightPathFilterPassBand", 0x00220002,
          "Light Path Filter Pass Band", VR.kUS, VM.k2, false);
  static const Tag kImagePathFilterPassThroughWavelength
      //(0022,0003)
      = const Tag.public("ImagePathFilterPassThroughWavelength", 0x00220003,
          "Image Path Filter Pass-Through Wavelength", VR.kUS, VM.k1, false);
  static const Tag kImagePathFilterPassBand
      //(0022,0004)
      = const Tag.public("ImagePathFilterPassBand", 0x00220004,
          "Image Path Filter Pass Band", VR.kUS, VM.k2, false);
  static const Tag kPatientEyeMovementCommanded
      //(0022,0005)
      = const Tag.public("PatientEyeMovementCommanded", 0x00220005,
          "Patient Eye Movement Commanded", VR.kCS, VM.k1, false);
  static const Tag kPatientEyeMovementCommandCodeSequence
      //(0022,0006)
      = const Tag.public("PatientEyeMovementCommandCodeSequence", 0x00220006,
          "Patient Eye Movement Command Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSphericalLensPower
      //(0022,0007)
      = const Tag.public("SphericalLensPower", 0x00220007,
          "Spherical Lens Power", VR.kFL, VM.k1, false);
  static const Tag kCylinderLensPower
      //(0022,0008)
      = const Tag.public("CylinderLensPower", 0x00220008, "Cylinder Lens Power",
          VR.kFL, VM.k1, false);
  static const Tag kCylinderAxis
      //(0022,0009)
      = const Tag.public(
          "CylinderAxis", 0x00220009, "Cylinder Axis", VR.kFL, VM.k1, false);
  static const Tag kEmmetropicMagnification
      //(0022,000A)
      = const Tag.public("EmmetropicMagnification", 0x0022000A,
          "Emmetropic Magnification", VR.kFL, VM.k1, false);
  static const Tag kIntraOcularPressure
      //(0022,000B)
      = const Tag.public("IntraOcularPressure", 0x0022000B,
          "Intra Ocular Pressure", VR.kFL, VM.k1, false);
  static const Tag kHorizontalFieldOfView
      //(0022,000C)
      = const Tag.public("HorizontalFieldOfView", 0x0022000C,
          "Horizontal Field of View", VR.kFL, VM.k1, false);
  static const Tag kPupilDilated
      //(0022,000D)
      = const Tag.public(
          "PupilDilated", 0x0022000D, "Pupil Dilated", VR.kCS, VM.k1, false);
  static const Tag kDegreeOfDilation
      //(0022,000E)
      = const Tag.public("DegreeOfDilation", 0x0022000E, "Degree of Dilation",
          VR.kFL, VM.k1, false);
  static const Tag kStereoBaselineAngle
      //(0022,0010)
      = const Tag.public("StereoBaselineAngle", 0x00220010,
          "Stereo Baseline Angle", VR.kFL, VM.k1, false);
  static const Tag kStereoBaselineDisplacement
      //(0022,0011)
      = const Tag.public("StereoBaselineDisplacement", 0x00220011,
          "Stereo Baseline Displacement", VR.kFL, VM.k1, false);
  static const Tag kStereoHorizontalPixelOffset
      //(0022,0012)
      = const Tag.public("StereoHorizontalPixelOffset", 0x00220012,
          "Stereo Horizontal Pixel Offset", VR.kFL, VM.k1, false);
  static const Tag kStereoVerticalPixelOffset
      //(0022,0013)
      = const Tag.public("StereoVerticalPixelOffset", 0x00220013,
          "Stereo Vertical Pixel Offset", VR.kFL, VM.k1, false);
  static const Tag kStereoRotation
      //(0022,0014)
      = const Tag.public("StereoRotation", 0x00220014, "Stereo Rotation",
          VR.kFL, VM.k1, false);
  static const Tag kAcquisitionDeviceTypeCodeSequence
      //(0022,0015)
      = const Tag.public("AcquisitionDeviceTypeCodeSequence", 0x00220015,
          "Acquisition Device Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIlluminationTypeCodeSequence
      //(0022,0016)
      = const Tag.public("IlluminationTypeCodeSequence", 0x00220016,
          "Illumination Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLightPathFilterTypeStackCodeSequence
      //(0022,0017)
      = const Tag.public("LightPathFilterTypeStackCodeSequence", 0x00220017,
          "Light Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImagePathFilterTypeStackCodeSequence
      //(0022,0018)
      = const Tag.public("ImagePathFilterTypeStackCodeSequence", 0x00220018,
          "Image Path Filter Type Stack Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLensesCodeSequence
      //(0022,0019)
      = const Tag.public("LensesCodeSequence", 0x00220019,
          "Lenses Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelDescriptionCodeSequence
      //(0022,001A)
      = const Tag.public("ChannelDescriptionCodeSequence", 0x0022001A,
          "Channel Description Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRefractiveStateSequence
      //(0022,001B)
      = const Tag.public("RefractiveStateSequence", 0x0022001B,
          "Refractive State Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMydriaticAgentCodeSequence
      //(0022,001C)
      = const Tag.public("MydriaticAgentCodeSequence", 0x0022001C,
          "Mydriatic Agent Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRelativeImagePositionCodeSequence
      //(0022,001D)
      = const Tag.public("RelativeImagePositionCodeSequence", 0x0022001D,
          "Relative Image Position Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCameraAngleOfView
      //(0022,001E)
      = const Tag.public("CameraAngleOfView", 0x0022001E,
          "Camera Angle of View", VR.kFL, VM.k1, false);
  static const Tag kStereoPairsSequence
      //(0022,0020)
      = const Tag.public("StereoPairsSequence", 0x00220020,
          "Stereo Pairs Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLeftImageSequence
      //(0022,0021)
      = const Tag.public("LeftImageSequence", 0x00220021, "Left Image Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kRightImageSequence
      //(0022,0022)
      = const Tag.public("RightImageSequence", 0x00220022,
          "Right Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAxialLengthOfTheEye
      //(0022,0030)
      = const Tag.public("AxialLengthOfTheEye", 0x00220030,
          "Axial Length of the Eye", VR.kFL, VM.k1, false);
  static const Tag kOphthalmicFrameLocationSequence
      //(0022,0031)
      = const Tag.public("OphthalmicFrameLocationSequence", 0x00220031,
          "Ophthalmic Frame Location Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferenceCoordinates
      //(0022,0032)
      = const Tag.public("ReferenceCoordinates", 0x00220032,
          "Reference Coordinates", VR.kFL, VM.k2_2n, false);
  static const Tag kDepthSpatialResolution
      //(0022,0035)
      = const Tag.public("DepthSpatialResolution", 0x00220035,
          "Depth Spatial Resolution", VR.kFL, VM.k1, false);
  static const Tag kMaximumDepthDistortion
      //(0022,0036)
      = const Tag.public("MaximumDepthDistortion", 0x00220036,
          "Maximum Depth Distortion", VR.kFL, VM.k1, false);
  static const Tag kAlongScanSpatialResolution
      //(0022,0037)
      = const Tag.public("AlongScanSpatialResolution", 0x00220037,
          "Along-scan Spatial Resolution", VR.kFL, VM.k1, false);
  static const Tag kMaximumAlongScanDistortion
      //(0022,0038)
      = const Tag.public("MaximumAlongScanDistortion", 0x00220038,
          "Maximum Along-scan Distortion", VR.kFL, VM.k1, false);
  static const Tag kOphthalmicImageOrientation
      //(0022,0039)
      = const Tag.public("OphthalmicImageOrientation", 0x00220039,
          "Ophthalmic Image Orientation", VR.kCS, VM.k1, false);
  static const Tag kDepthOfTransverseImage
      //(0022,0041)
      = const Tag.public("DepthOfTransverseImage", 0x00220041,
          "Depth of Transverse Image", VR.kFL, VM.k1, false);
  static const Tag kMydriaticAgentConcentrationUnitsSequence
      //(0022,0042)
      = const Tag.public("MydriaticAgentConcentrationUnitsSequence", 0x00220042,
          "Mydriatic Agent Concentration Units Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcrossScanSpatialResolution
      //(0022,0048)
      = const Tag.public("AcrossScanSpatialResolution", 0x00220048,
          "Across-scan Spatial Resolution", VR.kFL, VM.k1, false);
  static const Tag kMaximumAcrossScanDistortion
      //(0022,0049)
      = const Tag.public("MaximumAcrossScanDistortion", 0x00220049,
          "Maximum Across-scan Distortion", VR.kFL, VM.k1, false);
  static const Tag kMydriaticAgentConcentration
      //(0022,004E)
      = const Tag.public("MydriaticAgentConcentration", 0x0022004E,
          "Mydriatic Agent Concentration", VR.kDS, VM.k1, false);
  static const Tag kIlluminationWaveLength
      //(0022,0055)
      = const Tag.public("IlluminationWaveLength", 0x00220055,
          "Illumination Wave Length", VR.kFL, VM.k1, false);
  static const Tag kIlluminationPower
      //(0022,0056)
      = const Tag.public("IlluminationPower", 0x00220056, "Illumination Power",
          VR.kFL, VM.k1, false);
  static const Tag kIlluminationBandwidth
      //(0022,0057)
      = const Tag.public("IlluminationBandwidth", 0x00220057,
          "Illumination Bandwidth", VR.kFL, VM.k1, false);
  static const Tag kMydriaticAgentSequence
      //(0022,0058)
      = const Tag.public("MydriaticAgentSequence", 0x00220058,
          "Mydriatic Agent Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicAxialMeasurementsRightEyeSequence
      //(0022,1007)
      = const Tag.public(
          "OphthalmicAxialMeasurementsRightEyeSequence",
          0x00221007,
          "Ophthalmic Axial Measurements Right Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialMeasurementsLeftEyeSequence
      //(0022,1008)
      = const Tag.public(
          "OphthalmicAxialMeasurementsLeftEyeSequence",
          0x00221008,
          "Ophthalmic Axial Measurements Left Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialMeasurementsDeviceType
      //(0022,1009)
      = const Tag.public("OphthalmicAxialMeasurementsDeviceType", 0x00221009,
          "Ophthalmic Axial Measurements Device Type", VR.kCS, VM.k1, false);
  static const Tag kOphthalmicAxialLengthMeasurementsType
      //(0022,1010)
      = const Tag.public("OphthalmicAxialLengthMeasurementsType", 0x00221010,
          "Ophthalmic Axial Length Measurements Type", VR.kCS, VM.k1, false);
  static const Tag kOphthalmicAxialLengthSequence
      //(0022,1012)
      = const Tag.public("OphthalmicAxialLengthSequence", 0x00221012,
          "Ophthalmic Axial Length Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicAxialLength
      //(0022,1019)
      = const Tag.public("OphthalmicAxialLength", 0x00221019,
          "Ophthalmic Axial Length", VR.kFL, VM.k1, false);
  static const Tag kLensStatusCodeSequence
      //(0022,1024)
      = const Tag.public("LensStatusCodeSequence", 0x00221024,
          "Lens Status Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVitreousStatusCodeSequence
      //(0022,1025)
      = const Tag.public("VitreousStatusCodeSequence", 0x00221025,
          "Vitreous Status Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIOLFormulaCodeSequence
      //(0022,1028)
      = const Tag.public("IOLFormulaCodeSequence", 0x00221028,
          "IOL Formula Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIOLFormulaDetail
      //(0022,1029)
      = const Tag.public("IOLFormulaDetail", 0x00221029, "IOL Formula Detail",
          VR.kLO, VM.k1, false);
  static const Tag kKeratometerIndex
      //(0022,1033)
      = const Tag.public("KeratometerIndex", 0x00221033, "Keratometer Index",
          VR.kFL, VM.k1, false);
  static const Tag kSourceOfOphthalmicAxialLengthCodeSequence
      //(0022,1035)
      = const Tag.public(
          "SourceOfOphthalmicAxialLengthCodeSequence",
          0x00221035,
          "Source of Ophthalmic Axial Length Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kTargetRefraction
      //(0022,1037)
      = const Tag.public("TargetRefraction", 0x00221037, "Target Refraction",
          VR.kFL, VM.k1, false);
  static const Tag kRefractiveProcedureOccurred
      //(0022,1039)
      = const Tag.public("RefractiveProcedureOccurred", 0x00221039,
          "Refractive Procedure Occurred", VR.kCS, VM.k1, false);
  static const Tag kRefractiveSurgeryTypeCodeSequence
      //(0022,1040)
      = const Tag.public("RefractiveSurgeryTypeCodeSequence", 0x00221040,
          "Refractive Surgery Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicUltrasoundMethodCodeSequence
      //(0022,1044)
      = const Tag.public("OphthalmicUltrasoundMethodCodeSequence", 0x00221044,
          "Ophthalmic Ultrasound Method Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicAxialLengthMeasurementsSequence
      //(0022,1050)
      = const Tag.public(
          "OphthalmicAxialLengthMeasurementsSequence",
          0x00221050,
          "Ophthalmic Axial Length Measurements Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kIOLPower
      //(0022,1053)
      = const Tag.public(
          "IOLPower", 0x00221053, "IOL Power", VR.kFL, VM.k1, false);
  static const Tag kPredictedRefractiveError
      //(0022,1054)
      = const Tag.public("PredictedRefractiveError", 0x00221054,
          "Predicted Refractive Error", VR.kFL, VM.k1, false);
  static const Tag kOphthalmicAxialLengthVelocity
      //(0022,1059)
      = const Tag.public("OphthalmicAxialLengthVelocity", 0x00221059,
          "Ophthalmic Axial Length Velocity", VR.kFL, VM.k1, false);
  static const Tag kLensStatusDescription
      //(0022,1065)
      = const Tag.public("LensStatusDescription", 0x00221065,
          "Lens Status Description", VR.kLO, VM.k1, false);
  static const Tag kVitreousStatusDescription
      //(0022,1066)
      = const Tag.public("VitreousStatusDescription", 0x00221066,
          "Vitreous Status Description", VR.kLO, VM.k1, false);
  static const Tag kIOLPowerSequence
      //(0022,1090)
      = const Tag.public("IOLPowerSequence", 0x00221090, "IOL Power Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kLensConstantSequence
      //(0022,1092)
      = const Tag.public("LensConstantSequence", 0x00221092,
          "Lens Constant Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIOLManufacturer
      //(0022,1093)
      = const Tag.public("IOLManufacturer", 0x00221093, "IOL Manufacturer",
          VR.kLO, VM.k1, false);
  static const Tag kLensConstantDescription
      //(0022,1094)
      = const Tag.public("LensConstantDescription", 0x00221094,
          "Lens Constant Description", VR.kLO, VM.k1, true);
  static const Tag kImplantName
      //(0022,1095)
      = const Tag.public(
          "ImplantName", 0x00221095, "Implant Name", VR.kLO, VM.k1, false);
  static const Tag kKeratometryMeasurementTypeCodeSequence
      //(0022,1096)
      = const Tag.public("KeratometryMeasurementTypeCodeSequence", 0x00221096,
          "Keratometry Measurement Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantPartNumber
      //(0022,1097)
      = const Tag.public("ImplantPartNumber", 0x00221097, "Implant Part Number",
          VR.kLO, VM.k1, false);
  static const Tag kReferencedOphthalmicAxialMeasurementsSequence
      //(0022,1100)
      = const Tag.public(
          "ReferencedOphthalmicAxialMeasurementsSequence",
          0x00221100,
          "Referenced Ophthalmic Axial Measurements Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthMeasurementsSegmentNameCodeSequence
      //(0022,1101)
      = const Tag.public(
          "OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence",
          0x00221101,
          "Ophthalmic Axial Length Measurements Segment Name Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRefractiveErrorBeforeRefractiveSurgeryCodeSequence
      //(0022,1103)
      = const Tag.public(
          "RefractiveErrorBeforeRefractiveSurgeryCodeSequence",
          0x00221103,
          "Refractive Error Before Refractive Surgery Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kIOLPowerForExactEmmetropia
      //(0022,1121)
      = const Tag.public("IOLPowerForExactEmmetropia", 0x00221121,
          "IOL Power For Exact Emmetropia", VR.kFL, VM.k1, false);
  static const Tag kIOLPowerForExactTargetRefraction
      //(0022,1122)
      = const Tag.public("IOLPowerForExactTargetRefraction", 0x00221122,
          "IOL Power For Exact Target Refraction", VR.kFL, VM.k1, false);
  static const Tag kAnteriorChamberDepthDefinitionCodeSequence
      //(0022,1125)
      = const Tag.public(
          "AnteriorChamberDepthDefinitionCodeSequence",
          0x00221125,
          "Anterior Chamber Depth Definition Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kLensThicknessSequence
      //(0022,1127)
      = const Tag.public("LensThicknessSequence", 0x00221127,
          "Lens Thickness Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAnteriorChamberDepthSequence
      //(0022,1128)
      = const Tag.public("AnteriorChamberDepthSequence", 0x00221128,
          "Anterior Chamber Depth Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLensThickness
      //(0022,1130)
      = const Tag.public(
          "LensThickness", 0x00221130, "Lens Thickness", VR.kFL, VM.k1, false);
  static const Tag kAnteriorChamberDepth
      //(0022,1131)
      = const Tag.public("AnteriorChamberDepth", 0x00221131,
          "Anterior Chamber Depth", VR.kFL, VM.k1, false);
  static const Tag kSourceOfLensThicknessDataCodeSequence
      //(0022,1132)
      = const Tag.public("SourceOfLensThicknessDataCodeSequence", 0x00221132,
          "Source of Lens Thickness Data Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceOfAnteriorChamberDepthDataCodeSequence
      //(0022,1133)
      = const Tag.public(
          "SourceOfAnteriorChamberDepthDataCodeSequence",
          0x00221133,
          "Source of Anterior Chamber Depth Data Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kSourceOfRefractiveMeasurementsSequence
      //(0022,1134)
      = const Tag.public("SourceOfRefractiveMeasurementsSequence", 0x00221134,
          "Source of Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceOfRefractiveMeasurementsCodeSequence
      //(0022,1135)
      = const Tag.public(
          "SourceOfRefractiveMeasurementsCodeSequence",
          0x00221135,
          "Source of Refractive Measurements Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthMeasurementModified
      //(0022,1140)
      = const Tag.public("OphthalmicAxialLengthMeasurementModified", 0x00221140,
          "Ophthalmic Axial Length Measurement Modified", VR.kCS, VM.k1, false);
  static const Tag kOphthalmicAxialLengthDataSourceCodeSequence
      //(0022,1150)
      = const Tag.public(
          "OphthalmicAxialLengthDataSourceCodeSequence",
          0x00221150,
          "Ophthalmic Axial Length Data Source Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthAcquisitionMethodCodeSequence
      //(0022,1153)
      = const Tag.public(
          "OphthalmicAxialLengthAcquisitionMethodCodeSequence",
          0x00221153,
          "Ophthalmic Axial Length Acquisition Method Code Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kSignalToNoiseRatio
      //(0022,1155)
      = const Tag.public("SignalToNoiseRatio", 0x00221155,
          "Signal to Noise Ratio", VR.kFL, VM.k1, false);
  static const Tag kOphthalmicAxialLengthDataSourceDescription
      //(0022,1159)
      = const Tag.public(
          "OphthalmicAxialLengthDataSourceDescription",
          0x00221159,
          "Ophthalmic Axial Length Data Source Description",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthMeasurementsTotalLengthSequence
      //(0022,1210)
      = const Tag.public(
          "OphthalmicAxialLengthMeasurementsTotalLengthSequence",
          0x00221210,
          "Ophthalmic Axial Length Measurements Total Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthMeasurementsSegmentalLengthSequence
      //(0022,1211)
      = const Tag.public(
          "OphthalmicAxialLengthMeasurementsSegmentalLengthSequence",
          0x00221211,
          "Ophthalmic Axial Length Measurements Segmental Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthMeasurementsLengthSummationSequence
      //(0022,1212)
      = const Tag.public(
          "OphthalmicAxialLengthMeasurementsLengthSummationSequence",
          0x00221212,
          "Ophthalmic Axial Length Measurements Length Summation Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kUltrasoundOphthalmicAxialLengthMeasurementsSequence
      //(0022,1220)
      = const Tag.public(
          "UltrasoundOphthalmicAxialLengthMeasurementsSequence",
          0x00221220,
          "Ultrasound Ophthalmic Axial Length Measurements Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOpticalOphthalmicAxialLengthMeasurementsSequence
      //(0022,1225)
      = const Tag.public(
          "OpticalOphthalmicAxialLengthMeasurementsSequence",
          0x00221225,
          "Optical Ophthalmic Axial Length Measurements Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kUltrasoundSelectedOphthalmicAxialLengthSequence
      //(0022,1230)
      = const Tag.public(
          "UltrasoundSelectedOphthalmicAxialLengthSequence",
          0x00221230,
          "Ultrasound Selected Ophthalmic Axial Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthSelectionMethodCodeSequence
      //(0022,1250)
      = const Tag.public(
          "OphthalmicAxialLengthSelectionMethodCodeSequence",
          0x00221250,
          "Ophthalmic Axial Length Selection Method Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOpticalSelectedOphthalmicAxialLengthSequence
      //(0022,1255)
      = const Tag.public(
          "OpticalSelectedOphthalmicAxialLengthSequence",
          0x00221255,
          "Optical Selected Ophthalmic Axial Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kSelectedSegmentalOphthalmicAxialLengthSequence
      //(0022,1257)
      = const Tag.public(
          "SelectedSegmentalOphthalmicAxialLengthSequence",
          0x00221257,
          "Selected Segmental Ophthalmic Axial Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kSelectedTotalOphthalmicAxialLengthSequence
      //(0022,1260)
      = const Tag.public(
          "SelectedTotalOphthalmicAxialLengthSequence",
          0x00221260,
          "Selected Total Ophthalmic Axial Length Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthQualityMetricSequence
      //(0022,1262)
      = const Tag.public(
          "OphthalmicAxialLengthQualityMetricSequence",
          0x00221262,
          "Ophthalmic Axial Length Quality Metric Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicAxialLengthQualityMetricTypeCodeSequence
      //(0022,1265)
      = const Tag.public(
          "OphthalmicAxialLengthQualityMetricTypeCodeSequence",
          0x00221265,
          "Ophthalmic Axial Length Quality Metric Type Code Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kOphthalmicAxialLengthQualityMetricTypeDescription
      //(0022,1273)
      = const Tag.public(
          "OphthalmicAxialLengthQualityMetricTypeDescription",
          0x00221273,
          "Ophthalmic Axial Length Quality Metric Type Description",
          VR.kLO,
          VM.k1,
          true);
  static const Tag kIntraocularLensCalculationsRightEyeSequence
      //(0022,1300)
      = const Tag.public(
          "IntraocularLensCalculationsRightEyeSequence",
          0x00221300,
          "Intraocular Lens Calculations Right Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kIntraocularLensCalculationsLeftEyeSequence
      //(0022,1310)
      = const Tag.public(
          "IntraocularLensCalculationsLeftEyeSequence",
          0x00221310,
          "Intraocular Lens Calculations Left Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReferencedOphthalmicAxialLengthMeasurementQCImageSequence
      //(0022,1330)
      = const Tag.public(
          "ReferencedOphthalmicAxialLengthMeasurementQCImageSequence",
          0x00221330,
          "Referenced Ophthalmic Axial Length Measurement QC Image Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicMappingDeviceType
      //(0022,1415)
      = const Tag.public("OphthalmicMappingDeviceType", 0x00221415,
          "Ophthalmic Mapping Device Type", VR.kCS, VM.k1, false);
  static const Tag kAcquisitionMethodCodeSequence
      //(0022,1420)
      = const Tag.public("AcquisitionMethodCodeSequence", 0x00221420,
          "Acquisition Method Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcquisitionMethodAlgorithmSequence
      //(0022,1423)
      = const Tag.public("AcquisitionMethodAlgorithmSequence", 0x00221423,
          "Acquisition Method Algorithm Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicThicknessMapTypeCodeSequence
      //(0022,1436)
      = const Tag.public("OphthalmicThicknessMapTypeCodeSequence", 0x00221436,
          "Ophthalmic Thickness Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOphthalmicThicknessMappingNormalsSequence
      //(0022,1443)
      = const Tag.public(
          "OphthalmicThicknessMappingNormalsSequence",
          0x00221443,
          "Ophthalmic Thickness Mapping Normals Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRetinalThicknessDefinitionCodeSequence
      //(0022,1445)
      = const Tag.public("RetinalThicknessDefinitionCodeSequence", 0x00221445,
          "Retinal Thickness Definition Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPixelValueMappingToCodedConceptSequence
      //(0022,1450)
      = const Tag.public(
          "PixelValueMappingToCodedConceptSequence",
          0x00221450,
          "Pixel Value Mapping to Coded Concept Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kMappedPixelValue
      //(0022,1452)
      = const Tag.public("MappedPixelValue", 0x00221452, "Mapped Pixel Value",
          VR.kUSSS, VM.k1, false);
  static const Tag kPixelValueMappingExplanation
      //(0022,1454)
      = const Tag.public("PixelValueMappingExplanation", 0x00221454,
          "Pixel Value Mapping Explanation", VR.kLO, VM.k1, false);
  static const Tag kOphthalmicThicknessMapQualityThresholdSequence
      //(0022,1458)
      = const Tag.public(
          "OphthalmicThicknessMapQualityThresholdSequence",
          0x00221458,
          "Ophthalmic Thickness Map Quality Threshold Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicThicknessMapThresholdQualityRating
      //(0022,1460)
      = const Tag.public(
          "OphthalmicThicknessMapThresholdQualityRating",
          0x00221460,
          "Ophthalmic Thickness Map Threshold Quality Rating",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kAnatomicStructureReferencePoint
      //(0022,1463)
      = const Tag.public("AnatomicStructureReferencePoint", 0x00221463,
          "Anatomic Structure Reference Point", VR.kFL, VM.k2, false);
  static const Tag kRegistrationToLocalizerSequence
      //(0022,1465)
      = const Tag.public("RegistrationToLocalizerSequence", 0x00221465,
          "Registration to Localizer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRegisteredLocalizerUnits
      //(0022,1466)
      = const Tag.public("RegisteredLocalizerUnits", 0x00221466,
          "Registered Localizer Units", VR.kCS, VM.k1, false);
  static const Tag kRegisteredLocalizerTopLeftHandCorner
      //(0022,1467)
      = const Tag.public("RegisteredLocalizerTopLeftHandCorner", 0x00221467,
          "Registered Localizer Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const Tag kRegisteredLocalizerBottomRightHandCorner
      //(0022,1468)
      = const Tag.public(
          "RegisteredLocalizerBottomRightHandCorner",
          0x00221468,
          "Registered Localizer Bottom Right Hand Corner",
          VR.kFL,
          VM.k2,
          false);
  static const Tag kOphthalmicThicknessMapQualityRatingSequence
      //(0022,1470)
      = const Tag.public(
          "OphthalmicThicknessMapQualityRatingSequence",
          0x00221470,
          "Ophthalmic Thickness Map Quality Rating Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRelevantOPTAttributesSequence
      //(0022,1472)
      = const Tag.public("RelevantOPTAttributesSequence", 0x00221472,
          "Relevant OPT Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualFieldHorizontalExtent
      //(0024,0010)
      = const Tag.public("VisualFieldHorizontalExtent", 0x00240010,
          "Visual Field Horizontal Extent", VR.kFL, VM.k1, false);
  static const Tag kVisualFieldVerticalExtent
      //(0024,0011)
      = const Tag.public("VisualFieldVerticalExtent", 0x00240011,
          "Visual Field Vertical Extent", VR.kFL, VM.k1, false);
  static const Tag kVisualFieldShape
      //(0024,0012)
      = const Tag.public("VisualFieldShape", 0x00240012, "Visual Field Shape",
          VR.kCS, VM.k1, false);
  static const Tag kScreeningTestModeCodeSequence
      //(0024,0016)
      = const Tag.public("ScreeningTestModeCodeSequence", 0x00240016,
          "Screening Test Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMaximumStimulusLuminance
      //(0024,0018)
      = const Tag.public("MaximumStimulusLuminance", 0x00240018,
          "Maximum Stimulus Luminance", VR.kFL, VM.k1, false);
  static const Tag kBackgroundLuminance
      //(0024,0020)
      = const Tag.public("BackgroundLuminance", 0x00240020,
          "Background Luminance", VR.kFL, VM.k1, false);
  static const Tag kStimulusColorCodeSequence
      //(0024,0021)
      = const Tag.public("StimulusColorCodeSequence", 0x00240021,
          "Stimulus Color Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBackgroundIlluminationColorCodeSequence
      //(0024,0024)
      = const Tag.public("BackgroundIlluminationColorCodeSequence", 0x00240024,
          "Background Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStimulusArea
      //(0024,0025)
      = const Tag.public(
          "StimulusArea", 0x00240025, "Stimulus Area", VR.kFL, VM.k1, false);
  static const Tag kStimulusPresentationTime
      //(0024,0028)
      = const Tag.public("StimulusPresentationTime", 0x00240028,
          "Stimulus Presentation Time", VR.kFL, VM.k1, false);
  static const Tag kFixationSequence
      //(0024,0032)
      = const Tag.public("FixationSequence", 0x00240032, "Fixation Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kFixationMonitoringCodeSequence
      //(0024,0033)
      = const Tag.public("FixationMonitoringCodeSequence", 0x00240033,
          "Fixation Monitoring Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualFieldCatchTrialSequence
      //(0024,0034)
      = const Tag.public("VisualFieldCatchTrialSequence", 0x00240034,
          "Visual Field Catch Trial Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFixationCheckedQuantity
      //(0024,0035)
      = const Tag.public("FixationCheckedQuantity", 0x00240035,
          "Fixation Checked Quantity", VR.kUS, VM.k1, false);
  static const Tag kPatientNotProperlyFixatedQuantity
      //(0024,0036)
      = const Tag.public("PatientNotProperlyFixatedQuantity", 0x00240036,
          "Patient Not Properly Fixated Quantity", VR.kUS, VM.k1, false);
  static const Tag kPresentedVisualStimuliDataFlag
      //(0024,0037)
      = const Tag.public("PresentedVisualStimuliDataFlag", 0x00240037,
          "Presented Visual Stimuli Data Flag", VR.kCS, VM.k1, false);
  static const Tag kNumberOfVisualStimuli
      //(0024,0038)
      = const Tag.public("NumberOfVisualStimuli", 0x00240038,
          "Number of Visual Stimuli", VR.kUS, VM.k1, false);
  static const Tag kExcessiveFixationLossesDataFlag
      //(0024,0039)
      = const Tag.public("ExcessiveFixationLossesDataFlag", 0x00240039,
          "Excessive Fixation Losses Data Flag", VR.kCS, VM.k1, false);
  static const Tag kExcessiveFixationLosses
      //(0024,0040)
      = const Tag.public("ExcessiveFixationLosses", 0x00240040,
          "Excessive Fixation Losses", VR.kCS, VM.k1, false);
  static const Tag kStimuliRetestingQuantity
      //(0024,0042)
      = const Tag.public("StimuliRetestingQuantity", 0x00240042,
          "Stimuli Retesting Quantity", VR.kUS, VM.k1, false);
  static const Tag kCommentsOnPatientPerformanceOfVisualField
      //(0024,0044)
      = const Tag.public(
          "CommentsOnPatientPerformanceOfVisualField",
          0x00240044,
          "Comments on Patient's Performance of Visual Field",
          VR.kLT,
          VM.k1,
          false);
  static const Tag kFalseNegativesEstimateFlag
      //(0024,0045)
      = const Tag.public("FalseNegativesEstimateFlag", 0x00240045,
          "False Negatives Estimate Flag", VR.kCS, VM.k1, false);
  static const Tag kFalseNegativesEstimate
      //(0024,0046)
      = const Tag.public("FalseNegativesEstimate", 0x00240046,
          "False Negatives Estimate", VR.kFL, VM.k1, false);
  static const Tag kNegativeCatchTrialsQuantity
      //(0024,0048)
      = const Tag.public("NegativeCatchTrialsQuantity", 0x00240048,
          "Negative Catch Trials Quantity", VR.kUS, VM.k1, false);
  static const Tag kFalseNegativesQuantity
      //(0024,0050)
      = const Tag.public("FalseNegativesQuantity", 0x00240050,
          "False Negatives Quantity", VR.kUS, VM.k1, false);
  static const Tag kExcessiveFalseNegativesDataFlag
      //(0024,0051)
      = const Tag.public("ExcessiveFalseNegativesDataFlag", 0x00240051,
          "Excessive False Negatives Data Flag", VR.kCS, VM.k1, false);
  static const Tag kExcessiveFalseNegatives
      //(0024,0052)
      = const Tag.public("ExcessiveFalseNegatives", 0x00240052,
          "Excessive False Negatives", VR.kCS, VM.k1, false);
  static const Tag kFalsePositivesEstimateFlag
      //(0024,0053)
      = const Tag.public("FalsePositivesEstimateFlag", 0x00240053,
          "False Positives Estimate Flag", VR.kCS, VM.k1, false);
  static const Tag kFalsePositivesEstimate
      //(0024,0054)
      = const Tag.public("FalsePositivesEstimate", 0x00240054,
          "False Positives Estimate", VR.kFL, VM.k1, false);
  static const Tag kCatchTrialsDataFlag
      //(0024,0055)
      = const Tag.public("CatchTrialsDataFlag", 0x00240055,
          "Catch Trials Data Flag", VR.kCS, VM.k1, false);
  static const Tag kPositiveCatchTrialsQuantity
      //(0024,0056)
      = const Tag.public("PositiveCatchTrialsQuantity", 0x00240056,
          "Positive Catch Trials Quantity", VR.kUS, VM.k1, false);
  static const Tag kTestPointNormalsDataFlag
      //(0024,0057)
      = const Tag.public("TestPointNormalsDataFlag", 0x00240057,
          "Test Point Normals Data Flag", VR.kCS, VM.k1, false);
  static const Tag kTestPointNormalsSequence
      //(0024,0058)
      = const Tag.public("TestPointNormalsSequence", 0x00240058,
          "Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGlobalDeviationProbabilityNormalsFlag
      //(0024,0059)
      = const Tag.public("GlobalDeviationProbabilityNormalsFlag", 0x00240059,
          "Global Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const Tag kFalsePositivesQuantity
      //(0024,0060)
      = const Tag.public("FalsePositivesQuantity", 0x00240060,
          "False Positives Quantity", VR.kUS, VM.k1, false);
  static const Tag kExcessiveFalsePositivesDataFlag
      //(0024,0061)
      = const Tag.public("ExcessiveFalsePositivesDataFlag", 0x00240061,
          "Excessive False Positives Data Flag", VR.kCS, VM.k1, false);
  static const Tag kExcessiveFalsePositives
      //(0024,0062)
      = const Tag.public("ExcessiveFalsePositives", 0x00240062,
          "Excessive False Positives", VR.kCS, VM.k1, false);
  static const Tag kVisualFieldTestNormalsFlag
      //(0024,0063)
      = const Tag.public("VisualFieldTestNormalsFlag", 0x00240063,
          "Visual Field Test Normals Flag", VR.kCS, VM.k1, false);
  static const Tag kResultsNormalsSequence
      //(0024,0064)
      = const Tag.public("ResultsNormalsSequence", 0x00240064,
          "Results Normals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAgeCorrectedSensitivityDeviationAlgorithmSequence
      //(0024,0065)
      = const Tag.public(
          "AgeCorrectedSensitivityDeviationAlgorithmSequence",
          0x00240065,
          "Age Corrected Sensitivity Deviation Algorithm Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kGlobalDeviationFromNormal
      //(0024,0066)
      = const Tag.public("GlobalDeviationFromNormal", 0x00240066,
          "Global Deviation From Normal", VR.kFL, VM.k1, false);
  static const Tag kGeneralizedDefectSensitivityDeviationAlgorithmSequence
      //(0024,0067)
      = const Tag.public(
          "GeneralizedDefectSensitivityDeviationAlgorithmSequence",
          0x00240067,
          "Generalized Defect Sensitivity Deviation Algorithm Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kLocalizedDeviationFromNormal
      //(0024,0068)
      = const Tag.public("LocalizedDeviationFromNormal", 0x00240068,
          "Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const Tag kPatientReliabilityIndicator
      //(0024,0069)
      = const Tag.public("PatientReliabilityIndicator", 0x00240069,
          "Patient Reliability Indicator", VR.kLO, VM.k1, false);
  static const Tag kVisualFieldMeanSensitivity
      //(0024,0070)
      = const Tag.public("VisualFieldMeanSensitivity", 0x00240070,
          "Visual Field Mean Sensitivity", VR.kFL, VM.k1, false);
  static const Tag kGlobalDeviationProbability
      //(0024,0071)
      = const Tag.public("GlobalDeviationProbability", 0x00240071,
          "Global Deviation Probability", VR.kFL, VM.k1, false);
  static const Tag kLocalDeviationProbabilityNormalsFlag
      //(0024,0072)
      = const Tag.public("LocalDeviationProbabilityNormalsFlag", 0x00240072,
          "Local Deviation Probability Normals Flag", VR.kCS, VM.k1, false);
  static const Tag kLocalizedDeviationProbability
      //(0024,0073)
      = const Tag.public("LocalizedDeviationProbability", 0x00240073,
          "Localized Deviation Probability", VR.kFL, VM.k1, false);
  static const Tag kShortTermFluctuationCalculated
      //(0024,0074)
      = const Tag.public("ShortTermFluctuationCalculated", 0x00240074,
          "Short Term Fluctuation Calculated", VR.kCS, VM.k1, false);
  static const Tag kShortTermFluctuation
      //(0024,0075)
      = const Tag.public("ShortTermFluctuation", 0x00240075,
          "Short Term Fluctuation", VR.kFL, VM.k1, false);
  static const Tag kShortTermFluctuationProbabilityCalculated
      //(0024,0076)
      = const Tag.public(
          "ShortTermFluctuationProbabilityCalculated",
          0x00240076,
          "Short Term Fluctuation Probability Calculated",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kShortTermFluctuationProbability
      //(0024,0077)
      = const Tag.public("ShortTermFluctuationProbability", 0x00240077,
          "Short Term Fluctuation Probability", VR.kFL, VM.k1, false);
  static const Tag kCorrectedLocalizedDeviationFromNormalCalculated
      //(0024,0078)
      = const Tag.public(
          "CorrectedLocalizedDeviationFromNormalCalculated",
          0x00240078,
          "Corrected Localized Deviation From Normal Calculated",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kCorrectedLocalizedDeviationFromNormal
      //(0024,0079)
      = const Tag.public("CorrectedLocalizedDeviationFromNormal", 0x00240079,
          "Corrected Localized Deviation From Normal", VR.kFL, VM.k1, false);
  static const Tag kCorrectedLocalizedDeviationFromNormalProbabilityCalculated
      //(0024,0080)
      = const Tag.public(
          "CorrectedLocalizedDeviationFromNormalProbabilityCalculated",
          0x00240080,
          "Corrected Localized Deviation From Normal Probability Calculated",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kCorrectedLocalizedDeviationFromNormalProbability
      //(0024,0081)
      = const Tag.public(
          "CorrectedLocalizedDeviationFromNormalProbability",
          0x00240081,
          "Corrected Localized Deviation From Normal Probability",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kGlobalDeviationProbabilitySequence
      //(0024,0083)
      = const Tag.public("GlobalDeviationProbabilitySequence", 0x00240083,
          "Global Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLocalizedDeviationProbabilitySequence
      //(0024,0085)
      = const Tag.public("LocalizedDeviationProbabilitySequence", 0x00240085,
          "Localized Deviation Probability Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFovealSensitivityMeasured
      //(0024,0086)
      = const Tag.public("FovealSensitivityMeasured", 0x00240086,
          "Foveal Sensitivity Measured", VR.kCS, VM.k1, false);
  static const Tag kFovealSensitivity
      //(0024,0087)
      = const Tag.public("FovealSensitivity", 0x00240087, "Foveal Sensitivity",
          VR.kFL, VM.k1, false);
  static const Tag kVisualFieldTestDuration
      //(0024,0088)
      = const Tag.public("VisualFieldTestDuration", 0x00240088,
          "Visual Field Test Duration", VR.kFL, VM.k1, false);
  static const Tag kVisualFieldTestPointSequence
      //(0024,0089)
      = const Tag.public("VisualFieldTestPointSequence", 0x00240089,
          "Visual Field Test Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualFieldTestPointXCoordinate
      //(0024,0090)
      = const Tag.public("VisualFieldTestPointXCoordinate", 0x00240090,
          "Visual Field Test Point X-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kVisualFieldTestPointYCoordinate
      //(0024,0091)
      = const Tag.public("VisualFieldTestPointYCoordinate", 0x00240091,
          "Visual Field Test Point Y-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kAgeCorrectedSensitivityDeviationValue
      //(0024,0092)
      = const Tag.public("AgeCorrectedSensitivityDeviationValue", 0x00240092,
          "Age Corrected Sensitivity Deviation Value", VR.kFL, VM.k1, false);
  static const Tag kStimulusResults
      //(0024,0093)
      = const Tag.public("StimulusResults", 0x00240093, "Stimulus Results",
          VR.kCS, VM.k1, false);
  static const Tag kSensitivityValue
      //(0024,0094)
      = const Tag.public("SensitivityValue", 0x00240094, "Sensitivity Value",
          VR.kFL, VM.k1, false);
  static const Tag kRetestStimulusSeen
      //(0024,0095)
      = const Tag.public("RetestStimulusSeen", 0x00240095,
          "Retest Stimulus Seen", VR.kCS, VM.k1, false);
  static const Tag kRetestSensitivityValue
      //(0024,0096)
      = const Tag.public("RetestSensitivityValue", 0x00240096,
          "Retest Sensitivity Value", VR.kFL, VM.k1, false);
  static const Tag kVisualFieldTestPointNormalsSequence
      //(0024,0097)
      = const Tag.public("VisualFieldTestPointNormalsSequence", 0x00240097,
          "Visual Field Test Point Normals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kQuantifiedDefect
      //(0024,0098)
      = const Tag.public("QuantifiedDefect", 0x00240098, "Quantified Defect",
          VR.kFL, VM.k1, false);
  static const Tag kAgeCorrectedSensitivityDeviationProbabilityValue
      //(0024,0100)
      = const Tag.public(
          "AgeCorrectedSensitivityDeviationProbabilityValue",
          0x00240100,
          "Age Corrected Sensitivity Deviation Probability Value",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kGeneralizedDefectCorrectedSensitivityDeviationFlag
      //(0024,0102)
      = const Tag.public(
          "GeneralizedDefectCorrectedSensitivityDeviationFlag",
          0x00240102,
          "Generalized Defect Corrected Sensitivity Deviation Flag",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kGeneralizedDefectCorrectedSensitivityDeviationValue
      //(0024,0103)
      = const Tag.public(
          "GeneralizedDefectCorrectedSensitivityDeviationValue",
          0x00240103,
          "Generalized Defect Corrected Sensitivity Deviation Value",
          VR.kFL,
          VM.k1,
          false);
  static const Tag
      kGeneralizedDefectCorrectedSensitivityDeviationProbabilityValue
      //(0024,0104)
      = const Tag.public(
          "GeneralizedDefectCorrectedSensitivityDeviationProbabilityValue",
          0x00240104,
          "Generalized Defect Corrected Sensitivity Deviation Probability Value",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kMinimumSensitivityValue
      //(0024,0105)
      = const Tag.public("MinimumSensitivityValue", 0x00240105,
          "Minimum Sensitivity Value", VR.kFL, VM.k1, false);
  static const Tag kBlindSpotLocalized
      //(0024,0106)
      = const Tag.public("BlindSpotLocalized", 0x00240106,
          "Blind Spot Localized", VR.kCS, VM.k1, false);
  static const Tag kBlindSpotXCoordinate
      //(0024,0107)
      = const Tag.public("BlindSpotXCoordinate", 0x00240107,
          "Blind Spot X-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kBlindSpotYCoordinate
      //(0024,0108)
      = const Tag.public("BlindSpotYCoordinate", 0x00240108,
          "Blind Spot Y-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kVisualAcuityMeasurementSequence
      //(0024,0110)
      = const Tag.public("VisualAcuityMeasurementSequence", 0x00240110,
          "Visual Acuity Measurement Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRefractiveParametersUsedOnPatientSequence
      //(0024,0112)
      = const Tag.public(
          "RefractiveParametersUsedOnPatientSequence",
          0x00240112,
          "Refractive Parameters Used on Patient Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kMeasurementLaterality
      //(0024,0113)
      = const Tag.public("MeasurementLaterality", 0x00240113,
          "Measurement Laterality", VR.kCS, VM.k1, false);
  static const Tag kOphthalmicPatientClinicalInformationLeftEyeSequence
      //(0024,0114)
      = const Tag.public(
          "OphthalmicPatientClinicalInformationLeftEyeSequence",
          0x00240114,
          "Ophthalmic Patient Clinical Information Left Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kOphthalmicPatientClinicalInformationRightEyeSequence
      //(0024,0115)
      = const Tag.public(
          "OphthalmicPatientClinicalInformationRightEyeSequence",
          0x00240115,
          "Ophthalmic Patient Clinical Information Right Eye Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kFovealPointNormativeDataFlag
      //(0024,0117)
      = const Tag.public("FovealPointNormativeDataFlag", 0x00240117,
          "Foveal Point Normative Data Flag", VR.kCS, VM.k1, false);
  static const Tag kFovealPointProbabilityValue
      //(0024,0118)
      = const Tag.public("FovealPointProbabilityValue", 0x00240118,
          "Foveal Point Probability Value", VR.kFL, VM.k1, false);
  static const Tag kScreeningBaselineMeasured
      //(0024,0120)
      = const Tag.public("ScreeningBaselineMeasured", 0x00240120,
          "Screening Baseline Measured", VR.kCS, VM.k1, false);
  static const Tag kScreeningBaselineMeasuredSequence
      //(0024,0122)
      = const Tag.public("ScreeningBaselineMeasuredSequence", 0x00240122,
          "Screening Baseline Measured Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScreeningBaselineType
      //(0024,0124)
      = const Tag.public("ScreeningBaselineType", 0x00240124,
          "Screening Baseline Type", VR.kCS, VM.k1, false);
  static const Tag kScreeningBaselineValue
      //(0024,0126)
      = const Tag.public("ScreeningBaselineValue", 0x00240126,
          "Screening Baseline Value", VR.kFL, VM.k1, false);
  static const Tag kAlgorithmSource
      //(0024,0202)
      = const Tag.public("AlgorithmSource", 0x00240202, "Algorithm Source",
          VR.kLO, VM.k1, false);
  static const Tag kDataSetName
      //(0024,0306)
      = const Tag.public(
          "DataSetName", 0x00240306, "Data Set Name", VR.kLO, VM.k1, false);
  static const Tag kDataSetVersion
      //(0024,0307)
      = const Tag.public("DataSetVersion", 0x00240307, "Data Set Version",
          VR.kLO, VM.k1, false);
  static const Tag kDataSetSource
      //(0024,0308)
      = const Tag.public(
          "DataSetSource", 0x00240308, "Data Set Source", VR.kLO, VM.k1, false);
  static const Tag kDataSetDescription
      //(0024,0309)
      = const Tag.public("DataSetDescription", 0x00240309,
          "Data Set Description", VR.kLO, VM.k1, false);
  static const Tag kVisualFieldTestReliabilityGlobalIndexSequence
      //(0024,0317)
      = const Tag.public(
          "VisualFieldTestReliabilityGlobalIndexSequence",
          0x00240317,
          "Visual Field Test Reliability Global Index Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kVisualFieldGlobalResultsIndexSequence
      //(0024,0320)
      = const Tag.public("VisualFieldGlobalResultsIndexSequence", 0x00240320,
          "Visual Field Global Results Index Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataObservationSequence
      //(0024,0325)
      = const Tag.public("DataObservationSequence", 0x00240325,
          "Data Observation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIndexNormalsFlag
      //(0024,0338)
      = const Tag.public("IndexNormalsFlag", 0x00240338, "Index Normals Flag",
          VR.kCS, VM.k1, false);
  static const Tag kIndexProbability
      //(0024,0341)
      = const Tag.public("IndexProbability", 0x00240341, "Index Probability",
          VR.kFL, VM.k1, false);
  static const Tag kIndexProbabilitySequence
      //(0024,0344)
      = const Tag.public("IndexProbabilitySequence", 0x00240344,
          "Index Probability Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSamplesPerPixel
      //(0028,0002)
      = const Tag.public("SamplesPerPixel", 0x00280002, "Samples per Pixel",
          VR.kUS, VM.k1, false);
  static const Tag kSamplesPerPixelUsed
      //(0028,0003)
      = const Tag.public("SamplesPerPixelUsed", 0x00280003,
          "Samples per Pixel Used", VR.kUS, VM.k1, false);
  static const Tag kPhotometricInterpretation
      //(0028,0004)
      = const Tag.public("PhotometricInterpretation", 0x00280004,
          "Photometric Interpretation", VR.kCS, VM.k1, false);
  static const Tag kImageDimensions
      //(0028,0005)
      = const Tag.public("ImageDimensions", 0x00280005, "Image Dimensions",
          VR.kUS, VM.k1, true);
  static const Tag kPlanarConfiguration
      //(0028,0006)
      = const Tag.public("PlanarConfiguration", 0x00280006,
          "Planar Configuration", VR.kUS, VM.k1, false);
  static const Tag kNumberOfFrames
      //(0028,0008)
      = const Tag.public("NumberOfFrames", 0x00280008, "Number of Frames",
          VR.kIS, VM.k1, false);
  static const Tag kFrameIncrementPointer
      //(0028,0009)
      = const Tag.public("FrameIncrementPointer", 0x00280009,
          "Frame Increment Pointer", VR.kAT, VM.k1_n, false);
  static const Tag kFrameDimensionPointer
      //(0028,000A)
      = const Tag.public("FrameDimensionPointer", 0x0028000A,
          "Frame Dimension Pointer", VR.kAT, VM.k1_n, false);
  static const Tag kRows
      //(0028,0010)
      = const Tag.public("Rows", 0x00280010, "Rows", VR.kUS, VM.k1, false);
  static const Tag kColumns
      //(0028,0011)
      =
      const Tag.public("Columns", 0x00280011, "Columns", VR.kUS, VM.k1, false);
  static const Tag kPlanes
      //(0028,0012)
      = const Tag.public("Planes", 0x00280012, "Planes", VR.kUS, VM.k1, true);
  static const Tag kUltrasoundColorDataPresent
      //(0028,0014)
      = const Tag.public("UltrasoundColorDataPresent", 0x00280014,
          "Ultrasound Color Data Present", VR.kUS, VM.k1, false);
  static const Tag kNoName1
      //(0028,0020)
      = const Tag.public(
          "NoName1", 0x00280020, "See Note 3", VR.kUnknown, VM.kNoVM, true);
  static const Tag kPixelSpacing
      //(0028,0030)
      = const Tag.public(
          "PixelSpacing", 0x00280030, "Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kZoomFactor
      //(0028,0031)
      = const Tag.public(
          "ZoomFactor", 0x00280031, "Zoom Factor", VR.kDS, VM.k2, false);
  static const Tag kZoomCenter
      //(0028,0032)
      = const Tag.public(
          "ZoomCenter", 0x00280032, "Zoom Center", VR.kDS, VM.k2, false);
  static const Tag kPixelAspectRatio
      //(0028,0034)
      = const Tag.public("PixelAspectRatio", 0x00280034, "Pixel Aspect Ratio",
          VR.kIS, VM.k2, false);
  static const Tag kImageFormat
      //(0028,0040)
      = const Tag.public(
          "ImageFormat", 0x00280040, "Image Format", VR.kCS, VM.k1, true);
  static const Tag kManipulatedImage
      //(0028,0050)
      = const Tag.public("ManipulatedImage", 0x00280050, "Manipulated Image",
          VR.kLO, VM.k1_n, true);
  static const Tag kCorrectedImage
      //(0028,0051)
      = const Tag.public("CorrectedImage", 0x00280051, "Corrected Image",
          VR.kCS, VM.k1_n, false);
  static const Tag kCompressionRecognitionCode
      //(0028,005F)
      = const Tag.public("CompressionRecognitionCode", 0x0028005F,
          "Compression Recognition Code", VR.kLO, VM.k1, true);
  static const Tag kCompressionCode
      //(0028,0060)
      = const Tag.public("CompressionCode", 0x00280060, "Compression Code",
          VR.kCS, VM.k1, true);
  static const Tag kCompressionOriginator
      //(0028,0061)
      = const Tag.public("CompressionOriginator", 0x00280061,
          "Compression Originator", VR.kSH, VM.k1, true);
  static const Tag kCompressionLabel
      //(0028,0062)
      = const Tag.public("CompressionLabel", 0x00280062, "Compression Label",
          VR.kLO, VM.k1, true);
  static const Tag kCompressionDescription
      //(0028,0063)
      = const Tag.public("CompressionDescription", 0x00280063,
          "Compression Description", VR.kSH, VM.k1, true);
  static const Tag kCompressionSequence
      //(0028,0065)
      = const Tag.public("CompressionSequence", 0x00280065,
          "Compression Sequence", VR.kCS, VM.k1_n, true);
  static const Tag kCompressionStepPointers
      //(0028,0066)
      = const Tag.public("CompressionStepPointers", 0x00280066,
          "Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const Tag kRepeatInterval
      //(0028,0068)
      = const Tag.public(
          "RepeatInterval", 0x00280068, "Repeat Interval", VR.kUS, VM.k1, true);
  static const Tag kBitsGrouped
      //(0028,0069)
      = const Tag.public(
          "BitsGrouped", 0x00280069, "Bits Grouped", VR.kUS, VM.k1, true);
  static const Tag kPerimeterTable
      //(0028,0070)
      = const Tag.public("PerimeterTable", 0x00280070, "Perimeter Table",
          VR.kUS, VM.k1_n, true);
  static const Tag kPerimeterValue
      //(0028,0071)
      = const Tag.public("PerimeterValue", 0x00280071, "Perimeter Value",
          VR.kUSSS, VM.k1, true);
  static const Tag kPredictorRows
      //(0028,0080)
      = const Tag.public(
          "PredictorRows", 0x00280080, "Predictor Rows", VR.kUS, VM.k1, true);
  static const Tag kPredictorColumns
      //(0028,0081)
      = const Tag.public("PredictorColumns", 0x00280081, "Predictor Columns",
          VR.kUS, VM.k1, true);
  static const Tag kPredictorConstants
      //(0028,0082)
      = const Tag.public("PredictorConstants", 0x00280082,
          "Predictor Constants", VR.kUS, VM.k1_n, true);
  static const Tag kBlockedPixels
      //(0028,0090)
      = const Tag.public(
          "BlockedPixels", 0x00280090, "Blocked Pixels", VR.kCS, VM.k1, true);
  static const Tag kBlockRows
      //(0028,0091)
      = const Tag.public(
          "BlockRows", 0x00280091, "Block Rows", VR.kUS, VM.k1, true);
  static const Tag kBlockColumns
      //(0028,0092)
      = const Tag.public(
          "BlockColumns", 0x00280092, "Block Columns", VR.kUS, VM.k1, true);
  static const Tag kRowOverlap
      //(0028,0093)
      = const Tag.public(
          "RowOverlap", 0x00280093, "Row Overlap", VR.kUS, VM.k1, true);
  static const Tag kColumnOverlap
      //(0028,0094)
      = const Tag.public(
          "ColumnOverlap", 0x00280094, "Column Overlap", VR.kUS, VM.k1, true);
  static const Tag kBitsAllocated
      //(0028,0100)
      = const Tag.public(
          "BitsAllocated", 0x00280100, "Bits Allocated", VR.kUS, VM.k1, false);
  static const Tag kBitsStored
      //(0028,0101)
      = const Tag.public(
          "BitsStored", 0x00280101, "Bits Stored", VR.kUS, VM.k1, false);
  static const Tag kHighBit
      //(0028,0102)
      =
      const Tag.public("HighBit", 0x00280102, "High Bit", VR.kUS, VM.k1, false);
  static const Tag kPixelRepresentation
      //(0028,0103)
      = const Tag.public("PixelRepresentation", 0x00280103,
          "Pixel Representation", VR.kUS, VM.k1, false);
  static const Tag kSmallestValidPixelValue
      //(0028,0104)
      = const Tag.public("SmallestValidPixelValue", 0x00280104,
          "Smallest Valid Pixel Value", VR.kUSSS, VM.k1, true);
  static const Tag kLargestValidPixelValue
      //(0028,0105)
      = const Tag.public("LargestValidPixelValue", 0x00280105,
          "Largest Valid Pixel Value", VR.kUSSS, VM.k1, true);
  static const Tag kSmallestImagePixelValue
      //(0028,0106)
      = const Tag.public("SmallestImagePixelValue", 0x00280106,
          "Smallest Image Pixel Value", VR.kUSSS, VM.k1, false);
  static const Tag kLargestImagePixelValue
      //(0028,0107)
      = const Tag.public("LargestImagePixelValue", 0x00280107,
          "Largest Image Pixel Value", VR.kUSSS, VM.k1, false);
  static const Tag kSmallestPixelValueInSeries
      //(0028,0108)
      = const Tag.public("SmallestPixelValueInSeries", 0x00280108,
          "Smallest Pixel Value in Series", VR.kUSSS, VM.k1, false);
  static const Tag kLargestPixelValueInSeries
      //(0028,0109)
      = const Tag.public("LargestPixelValueInSeries", 0x00280109,
          "Largest Pixel Value in Series", VR.kUSSS, VM.k1, false);
  static const Tag kSmallestImagePixelValueInPlane
      //(0028,0110)
      = const Tag.public("SmallestImagePixelValueInPlane", 0x00280110,
          "Smallest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const Tag kLargestImagePixelValueInPlane
      //(0028,0111)
      = const Tag.public("LargestImagePixelValueInPlane", 0x00280111,
          "Largest Image Pixel Value in Plane", VR.kUSSS, VM.k1, true);
  static const Tag kPixelPaddingValue
      //(0028,0120)
      = const Tag.public("PixelPaddingValue", 0x00280120, "Pixel Padding Value",
          VR.kUSSS, VM.k1, false);
  static const Tag kPixelPaddingRangeLimit
      //(0028,0121)
      = const Tag.public("PixelPaddingRangeLimit", 0x00280121,
          "Pixel Padding Range Limit", VR.kUSSS, VM.k1, false);
  static const Tag kImageLocation
      //(0028,0200)
      = const Tag.public(
          "ImageLocation", 0x00280200, "Image Location", VR.kUS, VM.k1, true);
  static const Tag kQualityControlImage
      //(0028,0300)
      = const Tag.public("QualityControlImage", 0x00280300,
          "Quality Control Image", VR.kCS, VM.k1, false);
  static const Tag kBurnedInAnnotation
      //(0028,0301)
      = const Tag.public("BurnedInAnnotation", 0x00280301,
          "Burned In Annotation", VR.kCS, VM.k1, false);
  static const Tag kRecognizableVisualFeatures
      //(0028,0302)
      = const Tag.public("RecognizableVisualFeatures", 0x00280302,
          "Recognizable Visual Features", VR.kCS, VM.k1, false);
  static const Tag kLongitudinalTemporalInformationModified
      //(0028,0303)
      = const Tag.public("LongitudinalTemporalInformationModified", 0x00280303,
          "Longitudinal Temporal Information Modified", VR.kCS, VM.k1, false);
  static const Tag kReferencedColorPaletteInstanceUID
      //(0028,0304)
      = const Tag.public("ReferencedColorPaletteInstanceUID", 0x00280304,
          "Referenced Color Palette Instance UID", VR.kUI, VM.k1, false);
  static const Tag kTransformLabel
      //(0028,0400)
      = const Tag.public(
          "TransformLabel", 0x00280400, "Transform Label", VR.kLO, VM.k1, true);
  static const Tag kTransformVersionNumber
      //(0028,0401)
      = const Tag.public("TransformVersionNumber", 0x00280401,
          "Transform Version Number", VR.kLO, VM.k1, true);
  static const Tag kNumberOfTransformSteps
      //(0028,0402)
      = const Tag.public("NumberOfTransformSteps", 0x00280402,
          "Number of Transform Steps", VR.kUS, VM.k1, true);
  static const Tag kSequenceOfCompressedData
      //(0028,0403)
      = const Tag.public("SequenceOfCompressedData", 0x00280403,
          "Sequence of Compressed Data", VR.kLO, VM.k1_n, true);
  static const Tag kDetailsOfCoefficients
      //(0028,0404)
      = const Tag.public("DetailsOfCoefficients", 0x00280404,
          "Details of Coefficients", VR.kAT, VM.k1_n, true);

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
  static const Tag kDCTLabel
      //(0028,0700)
      = const Tag.public(
          "DCTLabel", 0x00280700, "DCT Label", VR.kLO, VM.k1, true);
  static const Tag kDataBlockDescription
      //(0028,0701)
      = const Tag.public("DataBlockDescription", 0x00280701,
          "Data Block Description", VR.kCS, VM.k1_n, true);
  static const Tag kDataBlock
      //(0028,0702)
      = const Tag.public(
          "DataBlock", 0x00280702, "Data Block", VR.kAT, VM.k1_n, true);
  static const Tag kNormalizationFactorFormat
      //(0028,0710)
      = const Tag.public("NormalizationFactorFormat", 0x00280710,
          "Normalization Factor Format", VR.kUS, VM.k1, true);
  static const Tag kZonalMapNumberFormat
      //(0028,0720)
      = const Tag.public("ZonalMapNumberFormat", 0x00280720,
          "Zonal Map Number Format", VR.kUS, VM.k1, true);
  static const Tag kZonalMapLocation
      //(0028,0721)
      = const Tag.public("ZonalMapLocation", 0x00280721, "Zonal Map Location",
          VR.kAT, VM.k1_n, true);
  static const Tag kZonalMapFormat
      //(0028,0722)
      = const Tag.public("ZonalMapFormat", 0x00280722, "Zonal Map Format",
          VR.kUS, VM.k1, true);
  static const Tag kAdaptiveMapFormat
      //(0028,0730)
      = const Tag.public("AdaptiveMapFormat", 0x00280730, "Adaptive Map Format",
          VR.kUS, VM.k1, true);
  static const Tag kCodeNumberFormat
      //(0028,0740)
      = const Tag.public("CodeNumberFormat", 0x00280740, "Code Number Format",
          VR.kUS, VM.k1, true);
  static const Tag kCodeLabel
      //(0028,0800)
      = const Tag.public(
          "CodeLabel", 0x00280800, "Code Label", VR.kCS, VM.k1_n, true);
  static const Tag kNumberOfTables
      //(0028,0802)
      = const Tag.public("NumberOfTables", 0x00280802, "Number of Tables",
          VR.kUS, VM.k1, true);
  static const Tag kCodeTableLocation
      //(0028,0803)
      = const Tag.public("CodeTableLocation", 0x00280803, "Code Table Location",
          VR.kAT, VM.k1_n, true);
  static const Tag kBitsForCodeWord
      //(0028,0804)
      = const Tag.public("BitsForCodeWord", 0x00280804, "Bits For Code Word",
          VR.kUS, VM.k1, true);
  static const Tag kImageDataLocation
      //(0028,0808)
      = const Tag.public("ImageDataLocation", 0x00280808, "Image Data Location",
          VR.kAT, VM.k1_n, true);
  static const Tag kPixelSpacingCalibrationType
      //(0028,0A02)
      = const Tag.public("PixelSpacingCalibrationType", 0x00280A02,
          "Pixel Spacing Calibration Type", VR.kCS, VM.k1, false);
  static const Tag kPixelSpacingCalibrationDescription
      //(0028,0A04)
      = const Tag.public("PixelSpacingCalibrationDescription", 0x00280A04,
          "Pixel Spacing Calibration Description", VR.kLO, VM.k1, false);
  static const Tag kPixelIntensityRelationship
      //(0028,1040)
      = const Tag.public("PixelIntensityRelationship", 0x00281040,
          "Pixel Intensity Relationship", VR.kCS, VM.k1, false);
  static const Tag kPixelIntensityRelationshipSign
      //(0028,1041)
      = const Tag.public("PixelIntensityRelationshipSign", 0x00281041,
          "Pixel Intensity Relationship Sign", VR.kSS, VM.k1, false);
  static const Tag kWindowCenter
      //(0028,1050)
      = const Tag.public(
          "WindowCenter", 0x00281050, "Window Center", VR.kDS, VM.k1_n, false);
  static const Tag kWindowWidth
      //(0028,1051)
      = const Tag.public(
          "WindowWidth", 0x00281051, "Window Width", VR.kDS, VM.k1_n, false);
  static const Tag kRescaleIntercept
      //(0028,1052)
      = const Tag.public("RescaleIntercept", 0x00281052, "Rescale Intercept",
          VR.kDS, VM.k1, false);
  static const Tag kRescaleSlope
      //(0028,1053)
      = const Tag.public(
          "RescaleSlope", 0x00281053, "Rescale Slope", VR.kDS, VM.k1, false);
  static const Tag kRescaleType
      //(0028,1054)
      = const Tag.public(
          "RescaleType", 0x00281054, "Rescale Type", VR.kLO, VM.k1, false);
  static const Tag kWindowCenterWidthExplanation
      //(0028,1055)
      = const Tag.public("WindowCenterWidthExplanation", 0x00281055,
          "Window Center & Width Explanation", VR.kLO, VM.k1_n, false);
  static const Tag kVOILUTFunction
      //(0028,1056)
      = const Tag.public("VOILUTFunction", 0x00281056, "VOI LUT Function",
          VR.kCS, VM.k1, false);
  static const Tag kGrayScale
      //(0028,1080)
      = const Tag.public(
          "GrayScale", 0x00281080, "Gray Scale", VR.kCS, VM.k1, true);
  static const Tag kRecommendedViewingMode
      //(0028,1090)
      = const Tag.public("RecommendedViewingMode", 0x00281090,
          "Recommended Viewing Mode", VR.kCS, VM.k1, false);
  static const Tag kGrayLookupTableDescriptor
      //(0028,1100)
      = const Tag.public("GrayLookupTableDescriptor", 0x00281100,
          "Gray Lookup Table Descriptor", VR.kUSSS, VM.k3, true);
  static const Tag kRedPaletteColorLookupTableDescriptor
      //(0028,1101)
      = const Tag.public("RedPaletteColorLookupTableDescriptor", 0x00281101,
          "Red Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const Tag kGreenPaletteColorLookupTableDescriptor
      //(0028,1102)
      = const Tag.public(
          "GreenPaletteColorLookupTableDescriptor",
          0x00281102,
          "Green Palette Color Lookup Table Descriptor",
          VR.kUSSS,
          VM.k3,
          false);
  static const Tag kBluePaletteColorLookupTableDescriptor
      //(0028,1103)
      = const Tag.public("BluePaletteColorLookupTableDescriptor", 0x00281103,
          "Blue Palette Color Lookup Table Descriptor", VR.kUSSS, VM.k3, false);
  static const Tag kAlphaPaletteColorLookupTableDescriptor
      //(0028,1104)
      = const Tag.public("AlphaPaletteColorLookupTableDescriptor", 0x00281104,
          "AlphaPalette ColorLookup Table Descriptor", VR.kUS, VM.k3, false);
  static const Tag kLargeRedPaletteColorLookupTableDescriptor
      //(0028,1111)
      = const Tag.public(
          "LargeRedPaletteColorLookupTableDescriptor",
          0x00281111,
          "Large Red Palette Color Lookup Table Descriptor",
          VR.kUSSS,
          VM.k4,
          true);
  static const Tag kLargeGreenPaletteColorLookupTableDescriptor
      //(0028,1112)
      = const Tag.public(
          "LargeGreenPaletteColorLookupTableDescriptor",
          0x00281112,
          "Large Green Palette Color Lookup Table Descriptor",
          VR.kUSSS,
          VM.k4,
          true);
  static const Tag kLargeBluePaletteColorLookupTableDescriptor
      //(0028,1113)
      = const Tag.public(
          "LargeBluePaletteColorLookupTableDescriptor",
          0x00281113,
          "Large Blue Palette Color Lookup Table Descriptor",
          VR.kUSSS,
          VM.k4,
          true);
  static const Tag kPaletteColorLookupTableUID
      //(0028,1199)
      = const Tag.public("PaletteColorLookupTableUID", 0x00281199,
          "Palette Color Lookup Table UID", VR.kUI, VM.k1, false);
  static const Tag kGrayLookupTableData
      //(0028,1200)
      = const Tag.public("GrayLookupTableData", 0x00281200,
          "Gray Lookup Table Data", VR.kUSSSOW, VM.k1_n, true);
  static const Tag kRedPaletteColorLookupTableData
      //(0028,1201)
      = const Tag.public("RedPaletteColorLookupTableData", 0x00281201,
          "Red Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const Tag kGreenPaletteColorLookupTableData
      //(0028,1202)
      = const Tag.public("GreenPaletteColorLookupTableData", 0x00281202,
          "Green Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const Tag kBluePaletteColorLookupTableData
      //(0028,1203)
      = const Tag.public("BluePaletteColorLookupTableData", 0x00281203,
          "Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const Tag kAlphaPaletteColorLookupTableData
      //(0028,1204)
      = const Tag.public("AlphaPaletteColorLookupTableData", 0x00281204,
          "Alpha Palette Color Lookup Table Data", VR.kOW, VM.k1, false);
  static const Tag kLargeRedPaletteColorLookupTableData
      //(0028,1211)
      = const Tag.public("LargeRedPaletteColorLookupTableData", 0x00281211,
          "Large Red Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const Tag kLargeGreenPaletteColorLookupTableData
      //(0028,1212)
      = const Tag.public("LargeGreenPaletteColorLookupTableData", 0x00281212,
          "Large Green Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const Tag kLargeBluePaletteColorLookupTableData
      //(0028,1213)
      = const Tag.public("LargeBluePaletteColorLookupTableData", 0x00281213,
          "Large Blue Palette Color Lookup Table Data", VR.kOW, VM.k1, true);
  static const Tag kLargePaletteColorLookupTableUID
      //(0028,1214)
      = const Tag.public("LargePaletteColorLookupTableUID", 0x00281214,
          "Large Palette Color Lookup Table UID", VR.kUI, VM.k1, true);
  static const Tag kSegmentedRedPaletteColorLookupTableData
      //(0028,1221)
      = const Tag.public(
          "SegmentedRedPaletteColorLookupTableData",
          0x00281221,
          "Segmented Red Palette Color Lookup Table Data",
          VR.kOW,
          VM.k1,
          false);
  static const Tag kSegmentedGreenPaletteColorLookupTableData
      //(0028,1222)
      = const Tag.public(
          "SegmentedGreenPaletteColorLookupTableData",
          0x00281222,
          "Segmented Green Palette Color Lookup Table Data",
          VR.kOW,
          VM.k1,
          false);
  static const Tag kSegmentedBluePaletteColorLookupTableData
      //(0028,1223)
      = const Tag.public(
          "SegmentedBluePaletteColorLookupTableData",
          0x00281223,
          "Segmented Blue Palette Color Lookup Table Data",
          VR.kOW,
          VM.k1,
          false);
  static const Tag kBreastImplantPresent
      //(0028,1300)
      = const Tag.public("BreastImplantPresent", 0x00281300,
          "Breast Implant Present", VR.kCS, VM.k1, false);
  static const Tag kPartialView
      //(0028,1350)
      = const Tag.public(
          "PartialView", 0x00281350, "Partial View", VR.kCS, VM.k1, false);
  static const Tag kPartialViewDescription
      //(0028,1351)
      = const Tag.public("PartialViewDescription", 0x00281351,
          "Partial View Description", VR.kST, VM.k1, false);
  static const Tag kPartialViewCodeSequence
      //(0028,1352)
      = const Tag.public("PartialViewCodeSequence", 0x00281352,
          "Partial View Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpatialLocationsPreserved
      //(0028,135A)
      = const Tag.public("SpatialLocationsPreserved", 0x0028135A,
          "Spatial Locations Preserved", VR.kCS, VM.k1, false);
  static const Tag kDataFrameAssignmentSequence
      //(0028,1401)
      = const Tag.public("DataFrameAssignmentSequence", 0x00281401,
          "Data Frame Assignment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataPathAssignment
      //(0028,1402)
      = const Tag.public("DataPathAssignment", 0x00281402,
          "Data Path Assignment", VR.kCS, VM.k1, false);
  static const Tag kBitsMappedToColorLookupTable
      //(0028,1403)
      = const Tag.public("BitsMappedToColorLookupTable", 0x00281403,
          "Bits Mapped to Color Lookup Table", VR.kUS, VM.k1, false);
  static const Tag kBlendingLUT1Sequence
      //(0028,1404)
      = const Tag.public("BlendingLUT1Sequence", 0x00281404,
          "Blending LUT 1 Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBlendingLUT1TransferFunction
      //(0028,1405)
      = const Tag.public("BlendingLUT1TransferFunction", 0x00281405,
          "Blending LUT 1 Transfer Function", VR.kCS, VM.k1, false);
  static const Tag kBlendingWeightConstant
      //(0028,1406)
      = const Tag.public("BlendingWeightConstant", 0x00281406,
          "Blending Weight Constant", VR.kFD, VM.k1, false);
  static const Tag kBlendingLookupTableDescriptor
      //(0028,1407)
      = const Tag.public("BlendingLookupTableDescriptor", 0x00281407,
          "Blending Lookup Table Descriptor", VR.kUS, VM.k3, false);
  static const Tag kBlendingLookupTableData
      //(0028,1408)
      = const Tag.public("BlendingLookupTableData", 0x00281408,
          "Blending Lookup Table Data", VR.kOW, VM.k1, false);
  static const Tag kEnhancedPaletteColorLookupTableSequence
      //(0028,140B)
      = const Tag.public("EnhancedPaletteColorLookupTableSequence", 0x0028140B,
          "Enhanced Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBlendingLUT2Sequence
      //(0028,140C)
      = const Tag.public("BlendingLUT2Sequence", 0x0028140C,
          "Blending LUT 2 Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBlendingLUT2TransferFunction
      //(0028,140D)
      = const Tag.public("BlendingLUT2TransferFunction", 0x0028140D,
          "Blending LUT 2 Transfer Function", VR.kCS, VM.k1, false);
  static const Tag kDataPathID
      //(0028,140E)
      = const Tag.public(
          "DataPathID", 0x0028140E, "Data Path ID", VR.kCS, VM.k1, false);
  static const Tag kRGBLUTTransferFunction
      //(0028,140F)
      = const Tag.public("RGBLUTTransferFunction", 0x0028140F,
          "RGB LUT Transfer Function", VR.kCS, VM.k1, false);
  static const Tag kAlphaLUTTransferFunction
      //(0028,1410)
      = const Tag.public("AlphaLUTTransferFunction", 0x00281410,
          "Alpha LUT Transfer Function", VR.kCS, VM.k1, false);
  static const Tag kICCProfile
      //(0028,2000)
      = const Tag.public(
          "ICCProfile", 0x00282000, "ICC Profile", VR.kOB, VM.k1, false);
  static const Tag kLossyImageCompression
      //(0028,2110)
      = const Tag.public("LossyImageCompression", 0x00282110,
          "Lossy Image Compression", VR.kCS, VM.k1, false);
  static const Tag kLossyImageCompressionRatio
      //(0028,2112)
      = const Tag.public("LossyImageCompressionRatio", 0x00282112,
          "Lossy Image Compression Ratio", VR.kDS, VM.k1_n, false);
  static const Tag kLossyImageCompressionMethod
      //(0028,2114)
      = const Tag.public("LossyImageCompressionMethod", 0x00282114,
          "Lossy Image Compression Method", VR.kCS, VM.k1_n, false);
  static const Tag kModalityLUTSequence
      //(0028,3000)
      = const Tag.public("ModalityLUTSequence", 0x00283000,
          "Modality LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLUTDescriptor
      //(0028,3002)
      = const Tag.public("LUTDescriptor", 0x00283002, "LUT Descriptor",
          VR.kUSSS, VM.k3, false);
  static const Tag kLUTExplanation
      //(0028,3003)
      = const Tag.public("LUTExplanation", 0x00283003, "LUT Explanation",
          VR.kLO, VM.k1, false);
  static const Tag kModalityLUTType
      //(0028,3004)
      = const Tag.public("ModalityLUTType", 0x00283004, "Modality LUT Type",
          VR.kLO, VM.k1, false);
  static const Tag kLUTData
      //(0028,3006)
      = const Tag.public(
          "LUTData", 0x00283006, "LUT Data", VR.kUSOW, VM.k1_n, false);
  static const Tag kVOILUTSequence
      //(0028,3010)
      = const Tag.public("VOILUTSequence", 0x00283010, "VOI LUT Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kSoftcopyVOILUTSequence
      //(0028,3110)
      = const Tag.public("SoftcopyVOILUTSequence", 0x00283110,
          "Softcopy VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImagePresentationComments
      //(0028,4000)
      = const Tag.public("ImagePresentationComments", 0x00284000,
          "Image Presentation Comments", VR.kLT, VM.k1, true);
  static const Tag kBiPlaneAcquisitionSequence
      //(0028,5000)
      = const Tag.public("BiPlaneAcquisitionSequence", 0x00285000,
          "Bi-Plane Acquisition Sequence", VR.kSQ, VM.k1, true);
  static const Tag kRepresentativeFrameNumber
      //(0028,6010)
      = const Tag.public("RepresentativeFrameNumber", 0x00286010,
          "Representative Frame Number", VR.kUS, VM.k1, false);
  static const Tag kFrameNumbersOfInterest
      //(0028,6020)
      = const Tag.public("FrameNumbersOfInterest", 0x00286020,
          "Frame Numbers of Interest (FOI)", VR.kUS, VM.k1_n, false);
  static const Tag kFrameOfInterestDescription
      //(0028,6022)
      = const Tag.public("FrameOfInterestDescription", 0x00286022,
          "Frame of Interest Description", VR.kLO, VM.k1_n, false);
  static const Tag kFrameOfInterestType
      //(0028,6023)
      = const Tag.public("FrameOfInterestType", 0x00286023,
          "Frame of Interest Type", VR.kCS, VM.k1_n, false);
  static const Tag kMaskPointers
      //(0028,6030)
      = const Tag.public(
          "MaskPointers", 0x00286030, "Mask Pointer(s)", VR.kUS, VM.k1_n, true);
  static const Tag kRWavePointer
      //(0028,6040)
      = const Tag.public(
          "RWavePointer", 0x00286040, "R Wave Pointer", VR.kUS, VM.k1_n, false);
  static const Tag kMaskSubtractionSequence
      //(0028,6100)
      = const Tag.public("MaskSubtractionSequence", 0x00286100,
          "Mask Subtraction Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMaskOperation
      //(0028,6101)
      = const Tag.public(
          "MaskOperation", 0x00286101, "Mask Operation", VR.kCS, VM.k1, false);
  static const Tag kApplicableFrameRange
      //(0028,6102)
      = const Tag.public("ApplicableFrameRange", 0x00286102,
          "Applicable Frame Range", VR.kUS, VM.k2_2n, false);
  static const Tag kMaskFrameNumbers
      //(0028,6110)
      = const Tag.public("MaskFrameNumbers", 0x00286110, "Mask Frame Numbers",
          VR.kUS, VM.k1_n, false);
  static const Tag kContrastFrameAveraging
      //(0028,6112)
      = const Tag.public("ContrastFrameAveraging", 0x00286112,
          "Contrast Frame Averaging", VR.kUS, VM.k1, false);
  static const Tag kMaskSubPixelShift
      //(0028,6114)
      = const Tag.public("MaskSubPixelShift", 0x00286114,
          "Mask Sub-pixel Shift", VR.kFL, VM.k2, false);
  static const Tag kTIDOffset
      //(0028,6120)
      = const Tag.public(
          "TIDOffset", 0x00286120, "TID Offset", VR.kSS, VM.k1, false);
  static const Tag kMaskOperationExplanation
      //(0028,6190)
      = const Tag.public("MaskOperationExplanation", 0x00286190,
          "Mask Operation Explanation", VR.kST, VM.k1, false);
  static const Tag kPixelDataProviderURL
      //(0028,7FE0)
      = const Tag.public("PixelDataProviderURL", 0x00287FE0,
          "Pixel Data Provider URL", VR.kUT, VM.k1, false);
  static const Tag kDataPointRows
      //(0028,9001)
      = const Tag.public(
          "DataPointRows", 0x00289001, "Data Point Rows", VR.kUL, VM.k1, false);
  static const Tag kDataPointColumns
      //(0028,9002)
      = const Tag.public("DataPointColumns", 0x00289002, "Data Point Columns",
          VR.kUL, VM.k1, false);
  static const Tag kSignalDomainColumns
      //(0028,9003)
      = const Tag.public("SignalDomainColumns", 0x00289003,
          "Signal Domain Columns", VR.kCS, VM.k1, false);
  static const Tag kLargestMonochromePixelValue
      //(0028,9099)
      = const Tag.public("LargestMonochromePixelValue", 0x00289099,
          "Largest Monochrome Pixel Value", VR.kUS, VM.k1, true);
  static const Tag kDataRepresentation
      //(0028,9108)
      = const Tag.public("DataRepresentation", 0x00289108,
          "Data Representation", VR.kCS, VM.k1, false);
  static const Tag kPixelMeasuresSequence
      //(0028,9110)
      = const Tag.public("PixelMeasuresSequence", 0x00289110,
          "Pixel Measures Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFrameVOILUTSequence
      //(0028,9132)
      = const Tag.public("FrameVOILUTSequence", 0x00289132,
          "Frame VOI LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPixelValueTransformationSequence
      //(0028,9145)
      = const Tag.public("PixelValueTransformationSequence", 0x00289145,
          "Pixel Value Transformation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSignalDomainRows
      //(0028,9235)
      = const Tag.public("SignalDomainRows", 0x00289235, "Signal Domain Rows",
          VR.kCS, VM.k1, false);
  static const Tag kDisplayFilterPercentage
      //(0028,9411)
      = const Tag.public("DisplayFilterPercentage", 0x00289411,
          "Display Filter Percentage", VR.kFL, VM.k1, false);
  static const Tag kFramePixelShiftSequence
      //(0028,9415)
      = const Tag.public("FramePixelShiftSequence", 0x00289415,
          "Frame Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSubtractionItemID
      //(0028,9416)
      = const Tag.public("SubtractionItemID", 0x00289416, "Subtraction Item ID",
          VR.kUS, VM.k1, false);
  static const Tag kPixelIntensityRelationshipLUTSequence
      //(0028,9422)
      = const Tag.public("PixelIntensityRelationshipLUTSequence", 0x00289422,
          "Pixel Intensity Relationship LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFramePixelDataPropertiesSequence
      //(0028,9443)
      = const Tag.public("FramePixelDataPropertiesSequence", 0x00289443,
          "Frame Pixel Data Properties Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGeometricalProperties
      //(0028,9444)
      = const Tag.public("GeometricalProperties", 0x00289444,
          "Geometrical Properties", VR.kCS, VM.k1, false);
  static const Tag kGeometricMaximumDistortion
      //(0028,9445)
      = const Tag.public("GeometricMaximumDistortion", 0x00289445,
          "Geometric Maximum Distortion", VR.kFL, VM.k1, false);
  static const Tag kImageProcessingApplied
      //(0028,9446)
      = const Tag.public("ImageProcessingApplied", 0x00289446,
          "Image Processing Applied", VR.kCS, VM.k1_n, false);
  static const Tag kMaskSelectionMode
      //(0028,9454)
      = const Tag.public("MaskSelectionMode", 0x00289454, "Mask Selection Mode",
          VR.kCS, VM.k1, false);
  static const Tag kLUTFunction
      //(0028,9474)
      = const Tag.public(
          "LUTFunction", 0x00289474, "LUT Function", VR.kCS, VM.k1, false);
  static const Tag kMaskVisibilityPercentage
      //(0028,9478)
      = const Tag.public("MaskVisibilityPercentage", 0x00289478,
          "Mask Visibility Percentage", VR.kFL, VM.k1, false);
  static const Tag kPixelShiftSequence
      //(0028,9501)
      = const Tag.public("PixelShiftSequence", 0x00289501,
          "Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRegionPixelShiftSequence
      //(0028,9502)
      = const Tag.public("RegionPixelShiftSequence", 0x00289502,
          "Region Pixel Shift Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVerticesOfTheRegion
      //(0028,9503)
      = const Tag.public("VerticesOfTheRegion", 0x00289503,
          "Vertices of the Region", VR.kSS, VM.k2_2n, false);
  static const Tag kMultiFramePresentationSequence
      //(0028,9505)
      = const Tag.public("MultiFramePresentationSequence", 0x00289505,
          "Multi-frame Presentation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPixelShiftFrameRange
      //(0028,9506)
      = const Tag.public("PixelShiftFrameRange", 0x00289506,
          "Pixel Shift Frame Range", VR.kUS, VM.k2_2n, false);
  static const Tag kLUTFrameRange
      //(0028,9507)
      = const Tag.public("LUTFrameRange", 0x00289507, "LUT Frame Range", VR.kUS,
          VM.k2_2n, false);
  static const Tag kImageToEquipmentMappingMatrix
      //(0028,9520)
      = const Tag.public("ImageToEquipmentMappingMatrix", 0x00289520,
          "Image to Equipment Mapping Matrix", VR.kDS, VM.k16, false);
  static const Tag kEquipmentCoordinateSystemIdentification
      //(0028,9537)
      = const Tag.public("EquipmentCoordinateSystemIdentification", 0x00289537,
          "Equipment Coordinate System Identification", VR.kCS, VM.k1, false);
  static const Tag kStudyStatusID
      //(0032,000A)
      = const Tag.public(
          "StudyStatusID", 0x0032000A, "Study Status ID", VR.kCS, VM.k1, true);
  static const Tag kStudyPriorityID
      //(0032,000C)
      = const Tag.public("StudyPriorityID", 0x0032000C, "Study Priority ID",
          VR.kCS, VM.k1, true);
  static const Tag kStudyIDIssuer
      //(0032,0012)
      = const Tag.public(
          "StudyIDIssuer", 0x00320012, "Study ID Issuer", VR.kLO, VM.k1, true);
  static const Tag kStudyVerifiedDate
      //(0032,0032)
      = const Tag.public("StudyVerifiedDate", 0x00320032, "Study Verified Date",
          VR.kDA, VM.k1, true);
  static const Tag kStudyVerifiedTime
      //(0032,0033)
      = const Tag.public("StudyVerifiedTime", 0x00320033, "Study Verified Time",
          VR.kTM, VM.k1, true);
  static const Tag kStudyReadDate
      //(0032,0034)
      = const Tag.public(
          "StudyReadDate", 0x00320034, "Study Read Date", VR.kDA, VM.k1, true);
  static const Tag kStudyReadTime
      //(0032,0035)
      = const Tag.public(
          "StudyReadTime", 0x00320035, "Study Read Time", VR.kTM, VM.k1, true);
  static const Tag kScheduledStudyStartDate
      //(0032,1000)
      = const Tag.public("ScheduledStudyStartDate", 0x00321000,
          "Scheduled Study Start Date", VR.kDA, VM.k1, true);
  static const Tag kScheduledStudyStartTime
      //(0032,1001)
      = const Tag.public("ScheduledStudyStartTime", 0x00321001,
          "Scheduled Study Start Time", VR.kTM, VM.k1, true);
  static const Tag kScheduledStudyStopDate
      //(0032,1010)
      = const Tag.public("ScheduledStudyStopDate", 0x00321010,
          "Scheduled Study Stop Date", VR.kDA, VM.k1, true);
  static const Tag kScheduledStudyStopTime
      //(0032,1011)
      = const Tag.public("ScheduledStudyStopTime", 0x00321011,
          "Scheduled Study Stop Time", VR.kTM, VM.k1, true);
  static const Tag kScheduledStudyLocation
      //(0032,1020)
      = const Tag.public("ScheduledStudyLocation", 0x00321020,
          "Scheduled Study Location", VR.kLO, VM.k1, true);
  static const Tag kScheduledStudyLocationAETitle
      //(0032,1021)
      = const Tag.public("ScheduledStudyLocationAETitle", 0x00321021,
          "Scheduled Study Location AE Title", VR.kAE, VM.k1_n, true);
  static const Tag kReasonForStudy
      //(0032,1030)
      = const Tag.public("ReasonForStudy", 0x00321030, "Reason for Study",
          VR.kLO, VM.k1, true);
  static const Tag kRequestingPhysicianIdentificationSequence
      //(0032,1031)
      = const Tag.public(
          "RequestingPhysicianIdentificationSequence",
          0x00321031,
          "Requesting Physician Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRequestingPhysician
      //(0032,1032)
      = const Tag.public("RequestingPhysician", 0x00321032,
          "Requesting Physician", VR.kPN, VM.k1, false);
  static const Tag kRequestingService
      //(0032,1033)
      = const Tag.public("RequestingService", 0x00321033, "Requesting Service",
          VR.kLO, VM.k1, false);
  static const Tag kRequestingServiceCodeSequence
      //(0032,1034)
      = const Tag.public("RequestingServiceCodeSequence", 0x00321034,
          "Requesting Service Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStudyArrivalDate
      //(0032,1040)
      = const Tag.public("StudyArrivalDate", 0x00321040, "Study Arrival Date",
          VR.kDA, VM.k1, true);
  static const Tag kStudyArrivalTime
      //(0032,1041)
      = const Tag.public("StudyArrivalTime", 0x00321041, "Study Arrival Time",
          VR.kTM, VM.k1, true);
  static const Tag kStudyCompletionDate
      //(0032,1050)
      = const Tag.public("StudyCompletionDate", 0x00321050,
          "Study Completion Date", VR.kDA, VM.k1, true);
  static const Tag kStudyCompletionTime
      //(0032,1051)
      = const Tag.public("StudyCompletionTime", 0x00321051,
          "Study Completion Time", VR.kTM, VM.k1, true);
  static const Tag kStudyComponentStatusID
      //(0032,1055)
      = const Tag.public("StudyComponentStatusID", 0x00321055,
          "Study Component Status ID", VR.kCS, VM.k1, true);
  static const Tag kRequestedProcedureDescription
      //(0032,1060)
      = const Tag.public("RequestedProcedureDescription", 0x00321060,
          "Requested Procedure Description", VR.kLO, VM.k1, false);
  static const Tag kRequestedProcedureCodeSequence
      //(0032,1064)
      = const Tag.public("RequestedProcedureCodeSequence", 0x00321064,
          "Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRequestedContrastAgent
      //(0032,1070)
      = const Tag.public("RequestedContrastAgent", 0x00321070,
          "Requested Contrast Agent", VR.kLO, VM.k1, false);
  static const Tag kStudyComments
      //(0032,4000)
      = const Tag.public(
          "StudyComments", 0x00324000, "Study Comments", VR.kLT, VM.k1, true);
  static const Tag kReferencedPatientAliasSequence
      //(0038,0004)
      = const Tag.public("ReferencedPatientAliasSequence", 0x00380004,
          "Referenced Patient Alias Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisitStatusID
      //(0038,0008)
      = const Tag.public(
          "VisitStatusID", 0x00380008, "Visit Status ID", VR.kCS, VM.k1, false);
  static const Tag kAdmissionID
      //(0038,0010)
      = const Tag.public(
          "AdmissionID", 0x00380010, "Admission ID", VR.kLO, VM.k1, false);
  static const Tag kIssuerOfAdmissionID
      //(0038,0011)
      = const Tag.public("IssuerOfAdmissionID", 0x00380011,
          "Issuer of Admission ID", VR.kLO, VM.k1, true);
  static const Tag kIssuerOfAdmissionIDSequence
      //(0038,0014)
      = const Tag.public("IssuerOfAdmissionIDSequence", 0x00380014,
          "Issuer of Admission ID Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRouteOfAdmissions
      //(0038,0016)
      = const Tag.public("RouteOfAdmissions", 0x00380016, "Route of Admissions",
          VR.kLO, VM.k1, false);
  static const Tag kScheduledAdmissionDate
      //(0038,001A)
      = const Tag.public("ScheduledAdmissionDate", 0x0038001A,
          "Scheduled Admission Date", VR.kDA, VM.k1, true);
  static const Tag kScheduledAdmissionTime
      //(0038,001B)
      = const Tag.public("ScheduledAdmissionTime", 0x0038001B,
          "Scheduled Admission Time", VR.kTM, VM.k1, true);
  static const Tag kScheduledDischargeDate
      //(0038,001C)
      = const Tag.public("ScheduledDischargeDate", 0x0038001C,
          "Scheduled Discharge Date", VR.kDA, VM.k1, true);
  static const Tag kScheduledDischargeTime
      //(0038,001D)
      = const Tag.public("ScheduledDischargeTime", 0x0038001D,
          "Scheduled Discharge Time", VR.kTM, VM.k1, true);
  static const Tag kScheduledPatientInstitutionResidence
      //(0038,001E)
      = const Tag.public("ScheduledPatientInstitutionResidence", 0x0038001E,
          "Scheduled Patient Institution Residence", VR.kLO, VM.k1, true);
  static const Tag kAdmittingDate
      //(0038,0020)
      = const Tag.public(
          "AdmittingDate", 0x00380020, "Admitting Date", VR.kDA, VM.k1, false);
  static const Tag kAdmittingTime
      //(0038,0021)
      = const Tag.public(
          "AdmittingTime", 0x00380021, "Admitting Time", VR.kTM, VM.k1, false);
  static const Tag kDischargeDate
      //(0038,0030)
      = const Tag.public(
          "DischargeDate", 0x00380030, "Discharge Date", VR.kDA, VM.k1, true);
  static const Tag kDischargeTime
      //(0038,0032)
      = const Tag.public(
          "DischargeTime", 0x00380032, "Discharge Time", VR.kTM, VM.k1, true);
  static const Tag kDischargeDiagnosisDescription
      //(0038,0040)
      = const Tag.public("DischargeDiagnosisDescription", 0x00380040,
          "Discharge Diagnosis Description", VR.kLO, VM.k1, true);
  static const Tag kDischargeDiagnosisCodeSequence
      //(0038,0044)
      = const Tag.public("DischargeDiagnosisCodeSequence", 0x00380044,
          "Discharge Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const Tag kSpecialNeeds
      //(0038,0050)
      = const Tag.public(
          "SpecialNeeds", 0x00380050, "Special Needs", VR.kLO, VM.k1, false);
  static const Tag kServiceEpisodeID
      //(0038,0060)
      = const Tag.public("ServiceEpisodeID", 0x00380060, "Service Episode ID",
          VR.kLO, VM.k1, false);
  static const Tag kIssuerOfServiceEpisodeID
      //(0038,0061)
      = const Tag.public("IssuerOfServiceEpisodeID", 0x00380061,
          "Issuer of Service Episode ID", VR.kLO, VM.k1, true);
  static const Tag kServiceEpisodeDescription
      //(0038,0062)
      = const Tag.public("ServiceEpisodeDescription", 0x00380062,
          "Service Episode Description", VR.kLO, VM.k1, false);
  static const Tag kIssuerOfServiceEpisodeIDSequence
      //(0038,0064)
      = const Tag.public("IssuerOfServiceEpisodeIDSequence", 0x00380064,
          "Issuer of Service Episode ID Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPertinentDocumentsSequence
      //(0038,0100)
      = const Tag.public("PertinentDocumentsSequence", 0x00380100,
          "Pertinent Documents Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCurrentPatientLocation
      //(0038,0300)
      = const Tag.public("CurrentPatientLocation", 0x00380300,
          "Current Patient Location", VR.kLO, VM.k1, false);
  static const Tag kPatientInstitutionResidence
      //(0038,0400)
      = const Tag.public("PatientInstitutionResidence", 0x00380400,
          "Patient's Institution Residence", VR.kLO, VM.k1, false);
  static const Tag kPatientState
      //(0038,0500)
      = const Tag.public(
          "PatientState", 0x00380500, "Patient State", VR.kLO, VM.k1, false);
  static const Tag kPatientClinicalTrialParticipationSequence
      //(0038,0502)
      = const Tag.public(
          "PatientClinicalTrialParticipationSequence",
          0x00380502,
          "Patient Clinical Trial Participation Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kVisitComments
      //(0038,4000)
      = const Tag.public(
          "VisitComments", 0x00384000, "Visit Comments", VR.kLT, VM.k1, false);
  static const Tag kWaveformOriginality
      //(003A,0004)
      = const Tag.public("WaveformOriginality", 0x003A0004,
          "Waveform Originality", VR.kCS, VM.k1, false);
  static const Tag kNumberOfWaveformChannels
      //(003A,0005)
      = const Tag.public("NumberOfWaveformChannels", 0x003A0005,
          "Number of Waveform Channels", VR.kUS, VM.k1, false);
  static const Tag kNumberOfWaveformSamples
      //(003A,0010)
      = const Tag.public("NumberOfWaveformSamples", 0x003A0010,
          "Number of Waveform Samples", VR.kUL, VM.k1, false);
  static const Tag kSamplingFrequency
      //(003A,001A)
      = const Tag.public("SamplingFrequency", 0x003A001A, "Sampling Frequency",
          VR.kDS, VM.k1, false);
  static const Tag kMultiplexGroupLabel
      //(003A,0020)
      = const Tag.public("MultiplexGroupLabel", 0x003A0020,
          "Multiplex Group Label", VR.kSH, VM.k1, false);
  static const Tag kChannelDefinitionSequence
      //(003A,0200)
      = const Tag.public("ChannelDefinitionSequence", 0x003A0200,
          "Channel Definition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kWaveformChannelNumber
      //(003A,0202)
      = const Tag.public("WaveformChannelNumber", 0x003A0202,
          "Waveform Channel Number", VR.kIS, VM.k1, false);
  static const Tag kChannelLabel
      //(003A,0203)
      = const Tag.public(
          "ChannelLabel", 0x003A0203, "Channel Label", VR.kSH, VM.k1, false);
  static const Tag kChannelStatus
      //(003A,0205)
      = const Tag.public("ChannelStatus", 0x003A0205, "Channel Status", VR.kCS,
          VM.k1_n, false);
  static const Tag kChannelSourceSequence
      //(003A,0208)
      = const Tag.public("ChannelSourceSequence", 0x003A0208,
          "Channel Source Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelSourceModifiersSequence
      //(003A,0209)
      = const Tag.public("ChannelSourceModifiersSequence", 0x003A0209,
          "Channel Source Modifiers Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceWaveformSequence
      //(003A,020A)
      = const Tag.public("SourceWaveformSequence", 0x003A020A,
          "Source Waveform Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelDerivationDescription
      //(003A,020C)
      = const Tag.public("ChannelDerivationDescription", 0x003A020C,
          "Channel Derivation Description", VR.kLO, VM.k1, false);
  static const Tag kChannelSensitivity
      //(003A,0210)
      = const Tag.public("ChannelSensitivity", 0x003A0210,
          "Channel Sensitivity", VR.kDS, VM.k1, false);
  static const Tag kChannelSensitivityUnitsSequence
      //(003A,0211)
      = const Tag.public("ChannelSensitivityUnitsSequence", 0x003A0211,
          "Channel Sensitivity Units Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelSensitivityCorrectionFactor
      //(003A,0212)
      = const Tag.public("ChannelSensitivityCorrectionFactor", 0x003A0212,
          "Channel Sensitivity Correction Factor", VR.kDS, VM.k1, false);
  static const Tag kChannelBaseline
      //(003A,0213)
      = const Tag.public("ChannelBaseline", 0x003A0213, "Channel Baseline",
          VR.kDS, VM.k1, false);
  static const Tag kChannelTimeSkew
      //(003A,0214)
      = const Tag.public("ChannelTimeSkew", 0x003A0214, "Channel Time Skew",
          VR.kDS, VM.k1, false);
  static const Tag kChannelSampleSkew
      //(003A,0215)
      = const Tag.public("ChannelSampleSkew", 0x003A0215, "Channel Sample Skew",
          VR.kDS, VM.k1, false);
  static const Tag kChannelOffset
      //(003A,0218)
      = const Tag.public(
          "ChannelOffset", 0x003A0218, "Channel Offset", VR.kDS, VM.k1, false);
  static const Tag kWaveformBitsStored
      //(003A,021A)
      = const Tag.public("WaveformBitsStored", 0x003A021A,
          "Waveform Bits Stored", VR.kUS, VM.k1, false);
  static const Tag kFilterLowFrequency
      //(003A,0220)
      = const Tag.public("FilterLowFrequency", 0x003A0220,
          "Filter Low Frequency", VR.kDS, VM.k1, false);
  static const Tag kFilterHighFrequency
      //(003A,0221)
      = const Tag.public("FilterHighFrequency", 0x003A0221,
          "Filter High Frequency", VR.kDS, VM.k1, false);
  static const Tag kNotchFilterFrequency
      //(003A,0222)
      = const Tag.public("NotchFilterFrequency", 0x003A0222,
          "Notch Filter Frequency", VR.kDS, VM.k1, false);
  static const Tag kNotchFilterBandwidth
      //(003A,0223)
      = const Tag.public("NotchFilterBandwidth", 0x003A0223,
          "Notch Filter Bandwidth", VR.kDS, VM.k1, false);
  static const Tag kWaveformDataDisplayScale
      //(003A,0230)
      = const Tag.public("WaveformDataDisplayScale", 0x003A0230,
          "Waveform Data Display Scale", VR.kFL, VM.k1, false);
  static const Tag kWaveformDisplayBackgroundCIELabValue
      //(003A,0231)
      = const Tag.public("WaveformDisplayBackgroundCIELabValue", 0x003A0231,
          "Waveform Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kWaveformPresentationGroupSequence
      //(003A,0240)
      = const Tag.public("WaveformPresentationGroupSequence", 0x003A0240,
          "Waveform Presentation Group Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPresentationGroupNumber
      //(003A,0241)
      = const Tag.public("PresentationGroupNumber", 0x003A0241,
          "Presentation Group Number", VR.kUS, VM.k1, false);
  static const Tag kChannelDisplaySequence
      //(003A,0242)
      = const Tag.public("ChannelDisplaySequence", 0x003A0242,
          "Channel Display Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelRecommendedDisplayCIELabValue
      //(003A,0244)
      = const Tag.public("ChannelRecommendedDisplayCIELabValue", 0x003A0244,
          "Channel Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kChannelPosition
      //(003A,0245)
      = const Tag.public("ChannelPosition", 0x003A0245, "Channel Position",
          VR.kFL, VM.k1, false);
  static const Tag kDisplayShadingFlag
      //(003A,0246)
      = const Tag.public("DisplayShadingFlag", 0x003A0246,
          "Display Shading Flag", VR.kCS, VM.k1, false);
  static const Tag kFractionalChannelDisplayScale
      //(003A,0247)
      = const Tag.public("FractionalChannelDisplayScale", 0x003A0247,
          "Fractional Channel Display Scale", VR.kFL, VM.k1, false);
  static const Tag kAbsoluteChannelDisplayScale
      //(003A,0248)
      = const Tag.public("AbsoluteChannelDisplayScale", 0x003A0248,
          "Absolute Channel Display Scale", VR.kFL, VM.k1, false);
  static const Tag kMultiplexedAudioChannelsDescriptionCodeSequence
      //(003A,0300)
      = const Tag.public(
          "MultiplexedAudioChannelsDescriptionCodeSequence",
          0x003A0300,
          "Multiplexed Audio Channels Description Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kChannelIdentificationCode
      //(003A,0301)
      = const Tag.public("ChannelIdentificationCode", 0x003A0301,
          "Channel Identification Code", VR.kIS, VM.k1, false);
  static const Tag kChannelMode
      //(003A,0302)
      = const Tag.public(
          "ChannelMode", 0x003A0302, "Channel Mode", VR.kCS, VM.k1, false);
  static const Tag kScheduledStationAETitle
      //(0040,0001)
      = const Tag.public("ScheduledStationAETitle", 0x00400001,
          "Scheduled Station AE Title", VR.kAE, VM.k1_n, false);
  static const Tag kScheduledProcedureStepStartDate
      //(0040,0002)
      = const Tag.public("ScheduledProcedureStepStartDate", 0x00400002,
          "Scheduled Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const Tag kScheduledProcedureStepStartTime
      //(0040,0003)
      = const Tag.public("ScheduledProcedureStepStartTime", 0x00400003,
          "Scheduled Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const Tag kScheduledProcedureStepEndDate
      //(0040,0004)
      = const Tag.public("ScheduledProcedureStepEndDate", 0x00400004,
          "Scheduled Procedure Step End Date", VR.kDA, VM.k1, false);
  static const Tag kScheduledProcedureStepEndTime
      //(0040,0005)
      = const Tag.public("ScheduledProcedureStepEndTime", 0x00400005,
          "Scheduled Procedure Step End Time", VR.kTM, VM.k1, false);
  static const Tag kScheduledPerformingPhysicianName
      //(0040,0006)
      = const Tag.public("ScheduledPerformingPhysicianName", 0x00400006,
          "Scheduled Performing Physician's Name", VR.kPN, VM.k1, false);
  static const Tag kScheduledProcedureStepDescription
      //(0040,0007)
      = const Tag.public("ScheduledProcedureStepDescription", 0x00400007,
          "Scheduled Procedure Step Description", VR.kLO, VM.k1, false);
  static const Tag kScheduledProtocolCodeSequence
      //(0040,0008)
      = const Tag.public("ScheduledProtocolCodeSequence", 0x00400008,
          "Scheduled Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledProcedureStepID
      //(0040,0009)
      = const Tag.public("ScheduledProcedureStepID", 0x00400009,
          "Scheduled Procedure Step ID", VR.kSH, VM.k1, false);
  static const Tag kStageCodeSequence
      //(0040,000A)
      = const Tag.public("StageCodeSequence", 0x0040000A, "Stage Code Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kScheduledPerformingPhysicianIdentificationSequence
      //(0040,000B)
      = const Tag.public(
          "ScheduledPerformingPhysicianIdentificationSequence",
          0x0040000B,
          "Scheduled Performing Physician Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kScheduledStationName
      //(0040,0010)
      = const Tag.public("ScheduledStationName", 0x00400010,
          "Scheduled Station Name", VR.kSH, VM.k1_n, false);
  static const Tag kScheduledProcedureStepLocation
      //(0040,0011)
      = const Tag.public("ScheduledProcedureStepLocation", 0x00400011,
          "Scheduled Procedure Step Location", VR.kSH, VM.k1, false);
  static const Tag kPreMedication
      //(0040,0012)
      = const Tag.public(
          "PreMedication", 0x00400012, "Pre-Medication", VR.kLO, VM.k1, false);
  static const Tag kScheduledProcedureStepStatus
      //(0040,0020)
      = const Tag.public("ScheduledProcedureStepStatus", 0x00400020,
          "Scheduled Procedure Step Status", VR.kCS, VM.k1, false);
  static const Tag kOrderPlacerIdentifierSequence
      //(0040,0026)
      = const Tag.public("OrderPlacerIdentifierSequence", 0x00400026,
          "Order Placer Identifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOrderFillerIdentifierSequence
      //(0040,0027)
      = const Tag.public("OrderFillerIdentifierSequence", 0x00400027,
          "Order Filler Identifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLocalNamespaceEntityID
      //(0040,0031)
      = const Tag.public("LocalNamespaceEntityID", 0x00400031,
          "Local Namespace Entity ID", VR.kUT, VM.k1, false);
  static const Tag kUniversalEntityID
      //(0040,0032)
      = const Tag.public("UniversalEntityID", 0x00400032, "Universal Entity ID",
          VR.kUT, VM.k1, false);
  static const Tag kUniversalEntityIDType
      //(0040,0033)
      = const Tag.public("UniversalEntityIDType", 0x00400033,
          "Universal Entity ID Type", VR.kCS, VM.k1, false);
  static const Tag kIdentifierTypeCode
      //(0040,0035)
      = const Tag.public("IdentifierTypeCode", 0x00400035,
          "Identifier Type Code", VR.kCS, VM.k1, false);
  static const Tag kAssigningFacilitySequence
      //(0040,0036)
      = const Tag.public("AssigningFacilitySequence", 0x00400036,
          "Assigning Facility Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAssigningJurisdictionCodeSequence
      //(0040,0039)
      = const Tag.public("AssigningJurisdictionCodeSequence", 0x00400039,
          "Assigning Jurisdiction Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAssigningAgencyOrDepartmentCodeSequence
      //(0040,003A)
      = const Tag.public("AssigningAgencyOrDepartmentCodeSequence", 0x0040003A,
          "Assigning Agency or Department Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledProcedureStepSequence
      //(0040,0100)
      = const Tag.public("ScheduledProcedureStepSequence", 0x00400100,
          "Scheduled Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedNonImageCompositeSOPInstanceSequence
      //(0040,0220)
      = const Tag.public(
          "ReferencedNonImageCompositeSOPInstanceSequence",
          0x00400220,
          "Referenced Non-Image Composite SOP Instance Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kPerformedStationAETitle
      //(0040,0241)
      = const Tag.public("PerformedStationAETitle", 0x00400241,
          "Performed Station AE Title", VR.kAE, VM.k1, false);
  static const Tag kPerformedStationName
      //(0040,0242)
      = const Tag.public("PerformedStationName", 0x00400242,
          "Performed Station Name", VR.kSH, VM.k1, false);
  static const Tag kPerformedLocation
      //(0040,0243)
      = const Tag.public("PerformedLocation", 0x00400243, "Performed Location",
          VR.kSH, VM.k1, false);
  static const Tag kPerformedProcedureStepStartDate
      //(0040,0244)
      = const Tag.public("PerformedProcedureStepStartDate", 0x00400244,
          "Performed Procedure Step Start Date", VR.kDA, VM.k1, false);
  static const Tag kPerformedProcedureStepStartTime
      //(0040,0245)
      = const Tag.public("PerformedProcedureStepStartTime", 0x00400245,
          "Performed Procedure Step Start Time", VR.kTM, VM.k1, false);
  static const Tag kPerformedProcedureStepEndDate
      //(0040,0250)
      = const Tag.public("PerformedProcedureStepEndDate", 0x00400250,
          "Performed Procedure Step End Date", VR.kDA, VM.k1, false);
  static const Tag kPerformedProcedureStepEndTime
      //(0040,0251)
      = const Tag.public("PerformedProcedureStepEndTime", 0x00400251,
          "Performed Procedure Step End Time", VR.kTM, VM.k1, false);
  static const Tag kPerformedProcedureStepStatus
      //(0040,0252)
      = const Tag.public("PerformedProcedureStepStatus", 0x00400252,
          "Performed Procedure Step Status", VR.kCS, VM.k1, false);
  static const Tag kPerformedProcedureStepID
      //(0040,0253)
      = const Tag.public("PerformedProcedureStepID", 0x00400253,
          "Performed Procedure Step ID", VR.kSH, VM.k1, false);
  static const Tag kPerformedProcedureStepDescription
      //(0040,0254)
      = const Tag.public("PerformedProcedureStepDescription", 0x00400254,
          "Performed Procedure Step Description", VR.kLO, VM.k1, false);
  static const Tag kPerformedProcedureTypeDescription
      //(0040,0255)
      = const Tag.public("PerformedProcedureTypeDescription", 0x00400255,
          "Performed Procedure Type Description", VR.kLO, VM.k1, false);
  static const Tag kPerformedProtocolCodeSequence
      //(0040,0260)
      = const Tag.public("PerformedProtocolCodeSequence", 0x00400260,
          "Performed Protocol Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedProtocolType
      //(0040,0261)
      = const Tag.public("PerformedProtocolType", 0x00400261,
          "Performed Protocol Type", VR.kCS, VM.k1, false);
  static const Tag kScheduledStepAttributesSequence
      //(0040,0270)
      = const Tag.public("ScheduledStepAttributesSequence", 0x00400270,
          "Scheduled Step Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRequestAttributesSequence
      //(0040,0275)
      = const Tag.public("RequestAttributesSequence", 0x00400275,
          "Request Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCommentsOnThePerformedProcedureStep
      //(0040,0280)
      = const Tag.public("CommentsOnThePerformedProcedureStep", 0x00400280,
          "Comments on the Performed Procedure Step", VR.kST, VM.k1, false);
  static const Tag kPerformedProcedureStepDiscontinuationReasonCodeSequence
      //(0040,0281)
      = const Tag.public(
          "PerformedProcedureStepDiscontinuationReasonCodeSequence",
          0x00400281,
          "Performed Procedure Step Discontinuation Reason Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kQuantitySequence
      //(0040,0293)
      = const Tag.public("QuantitySequence", 0x00400293, "Quantity Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kQuantity
      //(0040,0294)
      = const Tag.public(
          "Quantity", 0x00400294, "Quantity", VR.kDS, VM.k1, false);
  static const Tag kMeasuringUnitsSequence
      //(0040,0295)
      = const Tag.public("MeasuringUnitsSequence", 0x00400295,
          "Measuring Units Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBillingItemSequence
      //(0040,0296)
      = const Tag.public("BillingItemSequence", 0x00400296,
          "Billing Item Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTotalTimeOfFluoroscopy
      //(0040,0300)
      = const Tag.public("TotalTimeOfFluoroscopy", 0x00400300,
          "Total Time of Fluoroscopy", VR.kUS, VM.k1, false);
  static const Tag kTotalNumberOfExposures
      //(0040,0301)
      = const Tag.public("TotalNumberOfExposures", 0x00400301,
          "Total Number of Exposures", VR.kUS, VM.k1, false);
  static const Tag kEntranceDose
      //(0040,0302)
      = const Tag.public(
          "EntranceDose", 0x00400302, "Entrance Dose", VR.kUS, VM.k1, false);
  static const Tag kExposedArea
      //(0040,0303)
      = const Tag.public(
          "ExposedArea", 0x00400303, "Exposed Area", VR.kUS, VM.k1_2, false);
  static const Tag kDistanceSourceToEntrance
      //(0040,0306)
      = const Tag.public("DistanceSourceToEntrance", 0x00400306,
          "Distance Source to Entrance", VR.kDS, VM.k1, false);
  static const Tag kDistanceSourceToSupport
      //(0040,0307)
      = const Tag.public("DistanceSourceToSupport", 0x00400307,
          "Distance Source to Support", VR.kDS, VM.k1, true);
  static const Tag kExposureDoseSequence
      //(0040,030E)
      = const Tag.public("ExposureDoseSequence", 0x0040030E,
          "Exposure Dose Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCommentsOnRadiationDose
      //(0040,0310)
      = const Tag.public("CommentsOnRadiationDose", 0x00400310,
          "Comments on Radiation Dose", VR.kST, VM.k1, false);
  static const Tag kXRayOutput
      //(0040,0312)
      = const Tag.public(
          "XRayOutput", 0x00400312, "X-Ray Output", VR.kDS, VM.k1, false);
  static const Tag kHalfValueLayer
      //(0040,0314)
      = const Tag.public("HalfValueLayer", 0x00400314, "Half Value Layer",
          VR.kDS, VM.k1, false);
  static const Tag kOrganDose
      //(0040,0316)
      = const Tag.public(
          "OrganDose", 0x00400316, "Organ Dose", VR.kDS, VM.k1, false);
  static const Tag kOrganExposed
      //(0040,0318)
      = const Tag.public(
          "OrganExposed", 0x00400318, "Organ Exposed", VR.kCS, VM.k1, false);
  static const Tag kBillingProcedureStepSequence
      //(0040,0320)
      = const Tag.public("BillingProcedureStepSequence", 0x00400320,
          "Billing Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFilmConsumptionSequence
      //(0040,0321)
      = const Tag.public("FilmConsumptionSequence", 0x00400321,
          "Film Consumption Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBillingSuppliesAndDevicesSequence
      //(0040,0324)
      = const Tag.public("BillingSuppliesAndDevicesSequence", 0x00400324,
          "Billing Supplies and Devices Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedProcedureStepSequence
      //(0040,0330)
      = const Tag.public("ReferencedProcedureStepSequence", 0x00400330,
          "Referenced Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const Tag kPerformedSeriesSequence
      //(0040,0340)
      = const Tag.public("PerformedSeriesSequence", 0x00400340,
          "Performed Series Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCommentsOnTheScheduledProcedureStep
      //(0040,0400)
      = const Tag.public("CommentsOnTheScheduledProcedureStep", 0x00400400,
          "Comments on the Scheduled Procedure Step", VR.kLT, VM.k1, false);
  static const Tag kProtocolContextSequence
      //(0040,0440)
      = const Tag.public("ProtocolContextSequence", 0x00400440,
          "Protocol Context Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContentItemModifierSequence
      //(0040,0441)
      = const Tag.public("ContentItemModifierSequence", 0x00400441,
          "Content Item Modifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledSpecimenSequence
      //(0040,0500)
      = const Tag.public("ScheduledSpecimenSequence", 0x00400500,
          "Scheduled Specimen Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenAccessionNumber
      //(0040,050A)
      = const Tag.public("SpecimenAccessionNumber", 0x0040050A,
          "Specimen Accession Number", VR.kLO, VM.k1, true);
  static const Tag kContainerIdentifier
      //(0040,0512)
      = const Tag.public("ContainerIdentifier", 0x00400512,
          "Container Identifier", VR.kLO, VM.k1, false);
  static const Tag kIssuerOfTheContainerIdentifierSequence
      //(0040,0513)
      = const Tag.public("IssuerOfTheContainerIdentifierSequence", 0x00400513,
          "Issuer of the Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAlternateContainerIdentifierSequence
      //(0040,0515)
      = const Tag.public("AlternateContainerIdentifierSequence", 0x00400515,
          "Alternate Container Identifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContainerTypeCodeSequence
      //(0040,0518)
      = const Tag.public("ContainerTypeCodeSequence", 0x00400518,
          "Container Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContainerDescription
      //(0040,051A)
      = const Tag.public("ContainerDescription", 0x0040051A,
          "Container Description", VR.kLO, VM.k1, false);
  static const Tag kContainerComponentSequence
      //(0040,0520)
      = const Tag.public("ContainerComponentSequence", 0x00400520,
          "Container Component Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenSequence
      //(0040,0550)
      = const Tag.public("SpecimenSequence", 0x00400550, "Specimen Sequence",
          VR.kSQ, VM.k1, true);
  static const Tag kSpecimenIdentifier
      //(0040,0551)
      = const Tag.public("SpecimenIdentifier", 0x00400551,
          "Specimen Identifier", VR.kLO, VM.k1, false);
  static const Tag kSpecimenDescriptionSequenceTrial
      //(0040,0552)
      = const Tag.public("SpecimenDescriptionSequenceTrial", 0x00400552,
          "Specimen Description Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kSpecimenDescriptionTrial
      //(0040,0553)
      = const Tag.public("SpecimenDescriptionTrial", 0x00400553,
          "Specimen Description (Trial)", VR.kST, VM.k1, true);
  static const Tag kSpecimenUID
      //(0040,0554)
      = const Tag.public(
          "SpecimenUID", 0x00400554, "Specimen UID", VR.kUI, VM.k1, false);
  static const Tag kAcquisitionContextSequence
      //(0040,0555)
      = const Tag.public("AcquisitionContextSequence", 0x00400555,
          "Acquisition Context Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAcquisitionContextDescription
      //(0040,0556)
      = const Tag.public("AcquisitionContextDescription", 0x00400556,
          "Acquisition Context Description", VR.kST, VM.k1, false);
  static const Tag kSpecimenTypeCodeSequence
      //(0040,059A)
      = const Tag.public("SpecimenTypeCodeSequence", 0x0040059A,
          "Specimen Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenDescriptionSequence
      //(0040,0560)
      = const Tag.public("SpecimenDescriptionSequence", 0x00400560,
          "Specimen Description Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIssuerOfTheSpecimenIdentifierSequence
      //(0040,0562)
      = const Tag.public("IssuerOfTheSpecimenIdentifierSequence", 0x00400562,
          "Issuer of the Specimen Identifier Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenShortDescription
      //(0040,0600)
      = const Tag.public("SpecimenShortDescription", 0x00400600,
          "Specimen Short Description", VR.kLO, VM.k1, false);
  static const Tag kSpecimenDetailedDescription
      //(0040,0602)
      = const Tag.public("SpecimenDetailedDescription", 0x00400602,
          "Specimen Detailed Description", VR.kUT, VM.k1, false);
  static const Tag kSpecimenPreparationSequence
      //(0040,0610)
      = const Tag.public("SpecimenPreparationSequence", 0x00400610,
          "Specimen Preparation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenPreparationStepContentItemSequence
      //(0040,0612)
      = const Tag.public(
          "SpecimenPreparationStepContentItemSequence",
          0x00400612,
          "Specimen Preparation Step Content Item Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kSpecimenLocalizationContentItemSequence
      //(0040,0620)
      = const Tag.public("SpecimenLocalizationContentItemSequence", 0x00400620,
          "Specimen Localization Content Item Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSlideIdentifier
      //(0040,06FA)
      = const Tag.public("SlideIdentifier", 0x004006FA, "Slide Identifier",
          VR.kLO, VM.k1, true);
  static const Tag kImageCenterPointCoordinatesSequence
      //(0040,071A)
      = const Tag.public("ImageCenterPointCoordinatesSequence", 0x0040071A,
          "Image Center Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXOffsetInSlideCoordinateSystem
      //(0040,072A)
      = const Tag.public("XOffsetInSlideCoordinateSystem", 0x0040072A,
          "X Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const Tag kYOffsetInSlideCoordinateSystem
      //(0040,073A)
      = const Tag.public("YOffsetInSlideCoordinateSystem", 0x0040073A,
          "Y Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const Tag kZOffsetInSlideCoordinateSystem
      //(0040,074A)
      = const Tag.public("ZOffsetInSlideCoordinateSystem", 0x0040074A,
          "Z Offset in Slide Coordinate System", VR.kDS, VM.k1, false);
  static const Tag kPixelSpacingSequence
      //(0040,08D8)
      = const Tag.public("PixelSpacingSequence", 0x004008D8,
          "Pixel Spacing Sequence", VR.kSQ, VM.k1, true);
  static const Tag kCoordinateSystemAxisCodeSequence
      //(0040,08DA)
      = const Tag.public("CoordinateSystemAxisCodeSequence", 0x004008DA,
          "Coordinate System Axis Code Sequence", VR.kSQ, VM.k1, true);
  static const Tag kMeasurementUnitsCodeSequence
      //(0040,08EA)
      = const Tag.public("MeasurementUnitsCodeSequence", 0x004008EA,
          "Measurement Units Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVitalStainCodeSequenceTrial
      //(0040,09F8)
      = const Tag.public("VitalStainCodeSequenceTrial", 0x004009F8,
          "Vital Stain Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kRequestedProcedureID
      //(0040,1001)
      = const Tag.public("RequestedProcedureID", 0x00401001,
          "Requested Procedure ID", VR.kSH, VM.k1, false);
  static const Tag kReasonForTheRequestedProcedure
      //(0040,1002)
      = const Tag.public("ReasonForTheRequestedProcedure", 0x00401002,
          "Reason for the Requested Procedure", VR.kLO, VM.k1, false);
  static const Tag kRequestedProcedurePriority
      //(0040,1003)
      = const Tag.public("RequestedProcedurePriority", 0x00401003,
          "Requested Procedure Priority", VR.kSH, VM.k1, false);
  static const Tag kPatientTransportArrangements
      //(0040,1004)
      = const Tag.public("PatientTransportArrangements", 0x00401004,
          "Patient Transport Arrangements", VR.kLO, VM.k1, false);
  static const Tag kRequestedProcedureLocation
      //(0040,1005)
      = const Tag.public("RequestedProcedureLocation", 0x00401005,
          "Requested Procedure Location", VR.kLO, VM.k1, false);
  static const Tag kPlacerOrderNumberProcedure
      //(0040,1006)
      = const Tag.public("PlacerOrderNumberProcedure", 0x00401006,
          "Placer Order Number / Procedure", VR.kSH, VM.k1, true);
  static const Tag kFillerOrderNumberProcedure
      //(0040,1007)
      = const Tag.public("FillerOrderNumberProcedure", 0x00401007,
          "Filler Order Number / Procedure", VR.kSH, VM.k1, true);
  static const Tag kConfidentialityCode
      //(0040,1008)
      = const Tag.public("ConfidentialityCode", 0x00401008,
          "Confidentiality Code", VR.kLO, VM.k1, false);
  static const Tag kReportingPriority
      //(0040,1009)
      = const Tag.public("ReportingPriority", 0x00401009, "Reporting Priority",
          VR.kSH, VM.k1, false);
  static const Tag kReasonForRequestedProcedureCodeSequence
      //(0040,100A)
      = const Tag.public("ReasonForRequestedProcedureCodeSequence", 0x0040100A,
          "Reason for Requested Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNamesOfIntendedRecipientsOfResults
      //(0040,1010)
      = const Tag.public("NamesOfIntendedRecipientsOfResults", 0x00401010,
          "Names of Intended Recipients of Results", VR.kPN, VM.k1_n, false);
  static const Tag kIntendedRecipientsOfResultsIdentificationSequence
      //(0040,1011)
      = const Tag.public(
          "IntendedRecipientsOfResultsIdentificationSequence",
          0x00401011,
          "Intended Recipients of Results Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReasonForPerformedProcedureCodeSequence
      //(0040,1012)
      = const Tag.public("ReasonForPerformedProcedureCodeSequence", 0x00401012,
          "Reason For Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRequestedProcedureDescriptionTrial
      //(0040,1060)
      = const Tag.public("RequestedProcedureDescriptionTrial", 0x00401060,
          "Requested Procedure Description (Trial)", VR.kLO, VM.k1, true);
  static const Tag kPersonIdentificationCodeSequence
      //(0040,1101)
      = const Tag.public("PersonIdentificationCodeSequence", 0x00401101,
          "Person Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPersonAddress
      //(0040,1102)
      = const Tag.public("PersonAddress", 0x00401102, "Person's Address",
          VR.kST, VM.k1, false);
  static const Tag kPersonTelephoneNumbers
      //(0040,1103)
      = const Tag.public("PersonTelephoneNumbers", 0x00401103,
          "Person's Telephone Numbers", VR.kLO, VM.k1_n, false);
  static const Tag kRequestedProcedureComments
      //(0040,1400)
      = const Tag.public("RequestedProcedureComments", 0x00401400,
          "Requested Procedure Comments", VR.kLT, VM.k1, false);
  static const Tag kReasonForTheImagingServiceRequest
      //(0040,2001)
      = const Tag.public("ReasonForTheImagingServiceRequest", 0x00402001,
          "Reason for the Imaging Service Request", VR.kLO, VM.k1, true);
  static const Tag kIssueDateOfImagingServiceRequest
      //(0040,2004)
      = const Tag.public("IssueDateOfImagingServiceRequest", 0x00402004,
          "Issue Date of Imaging Service Request", VR.kDA, VM.k1, false);
  static const Tag kIssueTimeOfImagingServiceRequest
      //(0040,2005)
      = const Tag.public("IssueTimeOfImagingServiceRequest", 0x00402005,
          "Issue Time of Imaging Service Request", VR.kTM, VM.k1, false);
  static const Tag kPlacerOrderNumberImagingServiceRequestRetired
      //(0040,2006)
      = const Tag.public(
          "PlacerOrderNumberImagingServiceRequestRetired",
          0x00402006,
          "Placer Order Number / Imaging Service Request (Retired)",
          VR.kSH,
          VM.k1,
          true);
  static const Tag kFillerOrderNumberImagingServiceRequestRetired
      //(0040,2007)
      = const Tag.public(
          "FillerOrderNumberImagingServiceRequestRetired",
          0x00402007,
          "Filler Order Number / Imaging Service Request (Retired)",
          VR.kSH,
          VM.k1,
          true);
  static const Tag kOrderEnteredBy
      //(0040,2008)
      = const Tag.public("OrderEnteredBy", 0x00402008, "Order Entered By",
          VR.kPN, VM.k1, false);
  static const Tag kOrderEntererLocation
      //(0040,2009)
      = const Tag.public("OrderEntererLocation", 0x00402009,
          "Order Enterer's Location", VR.kSH, VM.k1, false);
  static const Tag kOrderCallbackPhoneNumber
      //(0040,2010)
      = const Tag.public("OrderCallbackPhoneNumber", 0x00402010,
          "Order Callback Phone Number", VR.kSH, VM.k1, false);
  static const Tag kPlacerOrderNumberImagingServiceRequest
      //(0040,2016)
      = const Tag.public(
          "PlacerOrderNumberImagingServiceRequest",
          0x00402016,
          "Placer Order Number / Imaging Service Request",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kFillerOrderNumberImagingServiceRequest
      //(0040,2017)
      = const Tag.public(
          "FillerOrderNumberImagingServiceRequest",
          0x00402017,
          "Filler Order Number / Imaging Service Request",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kImagingServiceRequestComments
      //(0040,2400)
      = const Tag.public("ImagingServiceRequestComments", 0x00402400,
          "Imaging Service Request Comments", VR.kLT, VM.k1, false);
  static const Tag kConfidentialityConstraintOnPatientDataDescription
      //(0040,3001)
      = const Tag.public(
          "ConfidentialityConstraintOnPatientDataDescription",
          0x00403001,
          "Confidentiality Constraint on Patient Data Description",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kGeneralPurposeScheduledProcedureStepStatus
      //(0040,4001)
      = const Tag.public(
          "GeneralPurposeScheduledProcedureStepStatus",
          0x00404001,
          "General Purpose Scheduled Procedure Step Status",
          VR.kCS,
          VM.k1,
          true);
  static const Tag kGeneralPurposePerformedProcedureStepStatus
      //(0040,4002)
      = const Tag.public(
          "GeneralPurposePerformedProcedureStepStatus",
          0x00404002,
          "General Purpose Performed Procedure Step Status",
          VR.kCS,
          VM.k1,
          true);
  static const Tag kGeneralPurposeScheduledProcedureStepPriority
      //(0040,4003)
      = const Tag.public(
          "GeneralPurposeScheduledProcedureStepPriority",
          0x00404003,
          "General Purpose Scheduled Procedure Step Priority",
          VR.kCS,
          VM.k1,
          true);
  static const Tag kScheduledProcessingApplicationsCodeSequence
      //(0040,4004)
      = const Tag.public(
          "ScheduledProcessingApplicationsCodeSequence",
          0x00404004,
          "Scheduled Processing Applications Code Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kScheduledProcedureStepStartDateTime
      //(0040,4005)
      = const Tag.public("ScheduledProcedureStepStartDateTime", 0x00404005,
          "Scheduled Procedure Step Start DateTime", VR.kDT, VM.k1, true);
  static const Tag kMultipleCopiesFlag
      //(0040,4006)
      = const Tag.public("MultipleCopiesFlag", 0x00404006,
          "Multiple Copies Flag", VR.kCS, VM.k1, true);
  static const Tag kPerformedProcessingApplicationsCodeSequence
      //(0040,4007)
      = const Tag.public(
          "PerformedProcessingApplicationsCodeSequence",
          0x00404007,
          "Performed Processing Applications Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kHumanPerformerCodeSequence
      //(0040,4009)
      = const Tag.public("HumanPerformerCodeSequence", 0x00404009,
          "Human Performer Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledProcedureStepModificationDateTime
      //(0040,4010)
      = const Tag.public(
          "ScheduledProcedureStepModificationDateTime",
          0x00404010,
          "Scheduled Procedure Step Modification DateTime",
          VR.kDT,
          VM.k1,
          false);
  static const Tag kExpectedCompletionDateTime
      //(0040,4011)
      = const Tag.public("ExpectedCompletionDateTime", 0x00404011,
          "Expected Completion DateTime", VR.kDT, VM.k1, false);
  static const Tag kResultingGeneralPurposePerformedProcedureStepsSequence
      //(0040,4015)
      = const Tag.public(
          "ResultingGeneralPurposePerformedProcedureStepsSequence",
          0x00404015,
          "Resulting General Purpose Performed Procedure Steps Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kReferencedGeneralPurposeScheduledProcedureStepSequence
      //(0040,4016)
      = const Tag.public(
          "ReferencedGeneralPurposeScheduledProcedureStepSequence",
          0x00404016,
          "Referenced General Purpose Scheduled Procedure Step Sequence",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kScheduledWorkitemCodeSequence
      //(0040,4018)
      = const Tag.public("ScheduledWorkitemCodeSequence", 0x00404018,
          "Scheduled Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedWorkitemCodeSequence
      //(0040,4019)
      = const Tag.public("PerformedWorkitemCodeSequence", 0x00404019,
          "Performed Workitem Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kInputAvailabilityFlag
      //(0040,4020)
      = const Tag.public("InputAvailabilityFlag", 0x00404020,
          "Input Availability Flag", VR.kCS, VM.k1, false);
  static const Tag kInputInformationSequence
      //(0040,4021)
      = const Tag.public("InputInformationSequence", 0x00404021,
          "Input Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRelevantInformationSequence
      //(0040,4022)
      = const Tag.public("RelevantInformationSequence", 0x00404022,
          "Relevant Information Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedGeneralPurposeScheduledProcedureStepTransactionUID
      //(0040,4023)
      = const Tag.public(
          "ReferencedGeneralPurposeScheduledProcedureStepTransactionUID",
          0x00404023,
          "Referenced General Purpose Scheduled Procedure Step Transaction UID",
          VR.kUI,
          VM.k1,
          true);
  static const Tag kScheduledStationNameCodeSequence
      //(0040,4025)
      = const Tag.public("ScheduledStationNameCodeSequence", 0x00404025,
          "Scheduled Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledStationClassCodeSequence
      //(0040,4026)
      = const Tag.public("ScheduledStationClassCodeSequence", 0x00404026,
          "Scheduled Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledStationGeographicLocationCodeSequence
      //(0040,4027)
      = const Tag.public(
          "ScheduledStationGeographicLocationCodeSequence",
          0x00404027,
          "Scheduled Station Geographic Location Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kPerformedStationNameCodeSequence
      //(0040,4028)
      = const Tag.public("PerformedStationNameCodeSequence", 0x00404028,
          "Performed Station Name Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedStationClassCodeSequence
      //(0040,4029)
      = const Tag.public("PerformedStationClassCodeSequence", 0x00404029,
          "Performed Station Class Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedStationGeographicLocationCodeSequence
      //(0040,4030)
      = const Tag.public(
          "PerformedStationGeographicLocationCodeSequence",
          0x00404030,
          "Performed Station Geographic Location Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRequestedSubsequentWorkitemCodeSequence
      //(0040,4031)
      = const Tag.public("RequestedSubsequentWorkitemCodeSequence", 0x00404031,
          "Requested Subsequent Workitem Code Sequence", VR.kSQ, VM.k1, true);
  static const Tag kNonDICOMOutputCodeSequence
      //(0040,4032)
      = const Tag.public("NonDICOMOutputCodeSequence", 0x00404032,
          "Non-DICOM Output Code Sequence", VR.kSQ, VM.k1, true);
  static const Tag kOutputInformationSequence
      //(0040,4033)
      = const Tag.public("OutputInformationSequence", 0x00404033,
          "Output Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kScheduledHumanPerformersSequence
      //(0040,4034)
      = const Tag.public("ScheduledHumanPerformersSequence", 0x00404034,
          "Scheduled Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const Tag kActualHumanPerformersSequence
      //(0040,4035)
      = const Tag.public("ActualHumanPerformersSequence", 0x00404035,
          "Actual Human Performers Sequence", VR.kSQ, VM.k1, false);
  static const Tag kHumanPerformerOrganization
      //(0040,4036)
      = const Tag.public("HumanPerformerOrganization", 0x00404036,
          "Human Performer's Organization", VR.kLO, VM.k1, false);
  static const Tag kHumanPerformerName
      //(0040,4037)
      = const Tag.public("HumanPerformerName", 0x00404037,
          "Human Performer's Name", VR.kPN, VM.k1, false);
  static const Tag kRawDataHandling
      //(0040,4040)
      = const Tag.public("RawDataHandling", 0x00404040, "Raw Data Handling",
          VR.kCS, VM.k1, false);
  static const Tag kInputReadinessState
      //(0040,4041)
      = const Tag.public("InputReadinessState", 0x00404041,
          "Input Readiness State", VR.kCS, VM.k1, false);
  static const Tag kPerformedProcedureStepStartDateTime
      //(0040,4050)
      = const Tag.public("PerformedProcedureStepStartDateTime", 0x00404050,
          "Performed Procedure Step Start DateTime", VR.kDT, VM.k1, false);
  static const Tag kPerformedProcedureStepEndDateTime
      //(0040,4051)
      = const Tag.public("PerformedProcedureStepEndDateTime", 0x00404051,
          "Performed Procedure Step End DateTime", VR.kDT, VM.k1, false);
  static const Tag kProcedureStepCancellationDateTime
      //(0040,4052)
      = const Tag.public("ProcedureStepCancellationDateTime", 0x00404052,
          "Procedure Step Cancellation DateTime", VR.kDT, VM.k1, false);
  static const Tag kEntranceDoseInmGy
      //(0040,8302)
      = const Tag.public("EntranceDoseInmGy", 0x00408302,
          "Entrance Dose in mGy", VR.kDS, VM.k1, false);
  static const Tag kReferencedImageRealWorldValueMappingSequence
      //(0040,9094)
      = const Tag.public(
          "ReferencedImageRealWorldValueMappingSequence",
          0x00409094,
          "Referenced Image Real World Value Mapping Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRealWorldValueMappingSequence
      //(0040,9096)
      = const Tag.public("RealWorldValueMappingSequence", 0x00409096,
          "Real World Value Mapping Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPixelValueMappingCodeSequence
      //(0040,9098)
      = const Tag.public("PixelValueMappingCodeSequence", 0x00409098,
          "Pixel Value Mapping Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLUTLabel
      //(0040,9210)
      = const Tag.public(
          "LUTLabel", 0x00409210, "LUT Label", VR.kSH, VM.k1, false);
  static const Tag kRealWorldValueLastValueMapped
      //(0040,9211)
      = const Tag.public("RealWorldValueLastValueMapped", 0x00409211,
          "Real World Value Last Value Mapped", VR.kUSSS, VM.k1, false);
  static const Tag kRealWorldValueLUTData
      //(0040,9212)
      = const Tag.public("RealWorldValueLUTData", 0x00409212,
          "Real World Value LUT Data", VR.kFD, VM.k1_n, false);
  static const Tag kRealWorldValueFirstValueMapped
      //(0040,9216)
      = const Tag.public("RealWorldValueFirstValueMapped", 0x00409216,
          "Real World Value First Value Mapped", VR.kUSSS, VM.k1, false);
  static const Tag kRealWorldValueIntercept
      //(0040,9224)
      = const Tag.public("RealWorldValueIntercept", 0x00409224,
          "Real World Value Intercept", VR.kFD, VM.k1, false);
  static const Tag kRealWorldValueSlope
      //(0040,9225)
      = const Tag.public("RealWorldValueSlope", 0x00409225,
          "Real World Value Slope", VR.kFD, VM.k1, false);
  static const Tag kFindingsFlagTrial
      //(0040,A007)
      = const Tag.public("FindingsFlagTrial", 0x0040A007,
          "Findings Flag (Trial)", VR.kCS, VM.k1, true);
  static const Tag kRelationshipType
      //(0040,A010)
      = const Tag.public("RelationshipType", 0x0040A010, "Relationship Type",
          VR.kCS, VM.k1, false);
  static const Tag kFindingsSequenceTrial
      //(0040,A020)
      = const Tag.public("FindingsSequenceTrial", 0x0040A020,
          "Findings Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kFindingsGroupUIDTrial
      //(0040,A021)
      = const Tag.public("FindingsGroupUIDTrial", 0x0040A021,
          "Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const Tag kReferencedFindingsGroupUIDTrial
      //(0040,A022)
      = const Tag.public("ReferencedFindingsGroupUIDTrial", 0x0040A022,
          "Referenced Findings Group UID (Trial)", VR.kUI, VM.k1, true);
  static const Tag kFindingsGroupRecordingDateTrial
      //(0040,A023)
      = const Tag.public("FindingsGroupRecordingDateTrial", 0x0040A023,
          "Findings Group Recording Date (Trial)", VR.kDA, VM.k1, true);
  static const Tag kFindingsGroupRecordingTimeTrial
      //(0040,A024)
      = const Tag.public("FindingsGroupRecordingTimeTrial", 0x0040A024,
          "Findings Group Recording Time (Trial)", VR.kTM, VM.k1, true);
  static const Tag kFindingsSourceCategoryCodeSequenceTrial
      //(0040,A026)
      = const Tag.public(
          "FindingsSourceCategoryCodeSequenceTrial",
          0x0040A026,
          "Findings Source Category Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kVerifyingOrganization
      //(0040,A027)
      = const Tag.public("VerifyingOrganization", 0x0040A027,
          "Verifying Organization", VR.kLO, VM.k1, false);
  static const Tag kDocumentingOrganizationIdentifierCodeSequenceTrial
      //(0040,A028)
      = const Tag.public(
          "DocumentingOrganizationIdentifierCodeSequenceTrial",
          0x0040A028,
          "Documenting Organization Identifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kVerificationDateTime
      //(0040,A030)
      = const Tag.public("VerificationDateTime", 0x0040A030,
          "Verification DateTime", VR.kDT, VM.k1, false);
  static const Tag kObservationDateTime
      //(0040,A032)
      = const Tag.public("ObservationDateTime", 0x0040A032,
          "Observation DateTime", VR.kDT, VM.k1, false);
  static const Tag kValueType
      //(0040,A040)
      = const Tag.public(
          "ValueType", 0x0040A040, "Value Type", VR.kCS, VM.k1, false);
  static const Tag kConceptNameCodeSequence
      //(0040,A043)
      = const Tag.public("ConceptNameCodeSequence", 0x0040A043,
          "Concept Name Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMeasurementPrecisionDescriptionTrial
      //(0040,A047)
      = const Tag.public("MeasurementPrecisionDescriptionTrial", 0x0040A047,
          "Measurement Precision Description (Trial)", VR.kLO, VM.k1, true);
  static const Tag kContinuityOfContent
      //(0040,A050)
      = const Tag.public("ContinuityOfContent", 0x0040A050,
          "Continuity Of Content", VR.kCS, VM.k1, false);
  static const Tag kUrgencyOrPriorityAlertsTrial
      //(0040,A057)
      = const Tag.public("UrgencyOrPriorityAlertsTrial", 0x0040A057,
          "Urgency or Priority Alerts (Trial)", VR.kCS, VM.k1_n, true);
  static const Tag kSequencingIndicatorTrial
      //(0040,A060)
      = const Tag.public("SequencingIndicatorTrial", 0x0040A060,
          "Sequencing Indicator (Trial)", VR.kLO, VM.k1, true);
  static const Tag kDocumentIdentifierCodeSequenceTrial
      //(0040,A066)
      = const Tag.public("DocumentIdentifierCodeSequenceTrial", 0x0040A066,
          "Document Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kDocumentAuthorTrial
      //(0040,A067)
      = const Tag.public("DocumentAuthorTrial", 0x0040A067,
          "Document Author (Trial)", VR.kPN, VM.k1, true);
  static const Tag kDocumentAuthorIdentifierCodeSequenceTrial
      //(0040,A068)
      = const Tag.public(
          "DocumentAuthorIdentifierCodeSequenceTrial",
          0x0040A068,
          "Document Author Identifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kIdentifierCodeSequenceTrial
      //(0040,A070)
      = const Tag.public("IdentifierCodeSequenceTrial", 0x0040A070,
          "Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kVerifyingObserverSequence
      //(0040,A073)
      = const Tag.public("VerifyingObserverSequence", 0x0040A073,
          "Verifying Observer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObjectBinaryIdentifierTrial
      //(0040,A074)
      = const Tag.public("ObjectBinaryIdentifierTrial", 0x0040A074,
          "Object Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const Tag kVerifyingObserverName
      //(0040,A075)
      = const Tag.public("VerifyingObserverName", 0x0040A075,
          "Verifying Observer Name", VR.kPN, VM.k1, false);
  static const Tag kDocumentingObserverIdentifierCodeSequenceTrial
      //(0040,A076)
      = const Tag.public(
          "DocumentingObserverIdentifierCodeSequenceTrial",
          0x0040A076,
          "Documenting Observer Identifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kAuthorObserverSequence
      //(0040,A078)
      = const Tag.public("AuthorObserverSequence", 0x0040A078,
          "Author Observer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kParticipantSequence
      //(0040,A07A)
      = const Tag.public("ParticipantSequence", 0x0040A07A,
          "Participant Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCustodialOrganizationSequence
      //(0040,A07C)
      = const Tag.public("CustodialOrganizationSequence", 0x0040A07C,
          "Custodial Organization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kParticipationType
      //(0040,A080)
      = const Tag.public("ParticipationType", 0x0040A080, "Participation Type",
          VR.kCS, VM.k1, false);
  static const Tag kParticipationDateTime
      //(0040,A082)
      = const Tag.public("ParticipationDateTime", 0x0040A082,
          "Participation DateTime", VR.kDT, VM.k1, false);
  static const Tag kObserverType
      //(0040,A084)
      = const Tag.public(
          "ObserverType", 0x0040A084, "Observer Type", VR.kCS, VM.k1, false);
  static const Tag kProcedureIdentifierCodeSequenceTrial
      //(0040,A085)
      = const Tag.public("ProcedureIdentifierCodeSequenceTrial", 0x0040A085,
          "Procedure Identifier Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kVerifyingObserverIdentificationCodeSequence
      //(0040,A088)
      = const Tag.public(
          "VerifyingObserverIdentificationCodeSequence",
          0x0040A088,
          "Verifying Observer Identification Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kObjectDirectoryBinaryIdentifierTrial
      //(0040,A089)
      = const Tag.public("ObjectDirectoryBinaryIdentifierTrial", 0x0040A089,
          "Object Directory Binary Identifier (Trial)", VR.kOB, VM.k1, true);
  static const Tag kEquivalentCDADocumentSequence
      //(0040,A090)
      = const Tag.public("EquivalentCDADocumentSequence", 0x0040A090,
          "Equivalent CDA Document Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedWaveformChannels
      //(0040,A0B0)
      = const Tag.public("ReferencedWaveformChannels", 0x0040A0B0,
          "Referenced Waveform Channels", VR.kUS, VM.k2_2n, false);
  static const Tag kDateOfDocumentOrVerbalTransactionTrial
      //(0040,A110)
      = const Tag.public(
          "DateOfDocumentOrVerbalTransactionTrial",
          0x0040A110,
          "Date of Document or Verbal Transaction (Trial)",
          VR.kDA,
          VM.k1,
          true);
  static const Tag kTimeOfDocumentCreationOrVerbalTransactionTrial
      //(0040,A112)
      = const Tag.public(
          "TimeOfDocumentCreationOrVerbalTransactionTrial",
          0x0040A112,
          "Time of Document Creation or Verbal Transaction (Trial)",
          VR.kTM,
          VM.k1,
          true);
  static const Tag kDateTime
      //(0040,A120)
      = const Tag.public(
          "DateTime", 0x0040A120, "DateTime", VR.kDT, VM.k1, false);
  static const Tag kDate
      //(0040,A121)
      = const Tag.public("Date", 0x0040A121, "Date", VR.kDA, VM.k1, false);
  static const Tag kTime
      //(0040,A122)
      = const Tag.public("Time", 0x0040A122, "Time", VR.kTM, VM.k1, false);
  static const Tag kPersonName
      //(0040,A123)
      = const Tag.public(
          "PersonName", 0x0040A123, "Person Name", VR.kPN, VM.k1, false);
  static const Tag kUID
      //(0040,A124)
      = const Tag.public("UID", 0x0040A124, "UID", VR.kUI, VM.k1, false);
  static const Tag kReportStatusIDTrial
      //(0040,A125)
      = const Tag.public("ReportStatusIDTrial", 0x0040A125,
          "Report Status ID (Trial)", VR.kCS, VM.k2, true);
  static const Tag kTemporalRangeType
      //(0040,A130)
      = const Tag.public("TemporalRangeType", 0x0040A130, "Temporal Range Type",
          VR.kCS, VM.k1, false);
  static const Tag kReferencedSamplePositions
      //(0040,A132)
      = const Tag.public("ReferencedSamplePositions", 0x0040A132,
          "Referenced Sample Positions", VR.kUL, VM.k1_n, false);
  static const Tag kReferencedFrameNumbers
      //(0040,A136)
      = const Tag.public("ReferencedFrameNumbers", 0x0040A136,
          "Referenced Frame Numbers", VR.kUS, VM.k1_n, false);
  static const Tag kReferencedTimeOffsets
      //(0040,A138)
      = const Tag.public("ReferencedTimeOffsets", 0x0040A138,
          "Referenced Time Offsets", VR.kDS, VM.k1_n, false);
  static const Tag kReferencedDateTime
      //(0040,A13A)
      = const Tag.public("ReferencedDateTime", 0x0040A13A,
          "Referenced DateTime", VR.kDT, VM.k1_n, false);
  static const Tag kTextValue
      //(0040,A160)
      = const Tag.public(
          "TextValue", 0x0040A160, "Text Value", VR.kUT, VM.k1, false);
  static const Tag kFloatingPointValue
      //(0040,A161)
      = const Tag.public("FloatingPointValue", 0x0040A161,
          "Floating Point Value", VR.kFD, VM.k1_n, false);
  static const Tag kRationalNumeratorValue
      //(0040,A162)
      = const Tag.public("RationalNumeratorValue", 0x0040A162,
          "Rational Numerator Value", VR.kSL, VM.k1_n, false);
  static const Tag kRationalDenominatorValue
      //(0040,A163)
      = const Tag.public("RationalDenominatorValue", 0x0040A163,
          "Rational Denominator Value", VR.kUL, VM.k1_n, false);
  static const Tag kObservationCategoryCodeSequenceTrial
      //(0040,A167)
      = const Tag.public("ObservationCategoryCodeSequenceTrial", 0x0040A167,
          "Observation Category Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kConceptCodeSequence
      //(0040,A168)
      = const Tag.public("ConceptCodeSequence", 0x0040A168,
          "Concept Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBibliographicCitationTrial
      //(0040,A16A)
      = const Tag.public("BibliographicCitationTrial", 0x0040A16A,
          "Bibliographic Citation (Trial)", VR.kST, VM.k1, true);
  static const Tag kPurposeOfReferenceCodeSequence
      //(0040,A170)
      = const Tag.public("PurposeOfReferenceCodeSequence", 0x0040A170,
          "Purpose of Reference Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObservationUID
      //(0040,A171)
      = const Tag.public("ObservationUID", 0x0040A171, "Observation UID",
          VR.kUI, VM.k1, false);
  static const Tag kReferencedObservationUIDTrial
      //(0040,A172)
      = const Tag.public("ReferencedObservationUIDTrial", 0x0040A172,
          "Referenced Observation UID (Trial)", VR.kUI, VM.k1, true);
  static const Tag kReferencedObservationClassTrial
      //(0040,A173)
      = const Tag.public("ReferencedObservationClassTrial", 0x0040A173,
          "Referenced Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const Tag kReferencedObjectObservationClassTrial
      //(0040,A174)
      = const Tag.public("ReferencedObjectObservationClassTrial", 0x0040A174,
          "Referenced Object Observation Class (Trial)", VR.kCS, VM.k1, true);
  static const Tag kAnnotationGroupNumber
      //(0040,A180)
      = const Tag.public("AnnotationGroupNumber", 0x0040A180,
          "Annotation Group Number", VR.kUS, VM.k1, false);
  static const Tag kObservationDateTrial
      //(0040,A192)
      = const Tag.public("ObservationDateTrial", 0x0040A192,
          "Observation Date (Trial)", VR.kDA, VM.k1, true);
  static const Tag kObservationTimeTrial
      //(0040,A193)
      = const Tag.public("ObservationTimeTrial", 0x0040A193,
          "Observation Time (Trial)", VR.kTM, VM.k1, true);
  static const Tag kMeasurementAutomationTrial
      //(0040,A194)
      = const Tag.public("MeasurementAutomationTrial", 0x0040A194,
          "Measurement Automation (Trial)", VR.kCS, VM.k1, true);
  static const Tag kModifierCodeSequence
      //(0040,A195)
      = const Tag.public("ModifierCodeSequence", 0x0040A195,
          "Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIdentificationDescriptionTrial
      //(0040,A224)
      = const Tag.public("IdentificationDescriptionTrial", 0x0040A224,
          "Identification Description (Trial)", VR.kST, VM.k1, true);
  static const Tag kCoordinatesSetGeometricTypeTrial
      //(0040,A290)
      = const Tag.public("CoordinatesSetGeometricTypeTrial", 0x0040A290,
          "Coordinates Set Geometric Type (Trial)", VR.kCS, VM.k1, true);
  static const Tag kAlgorithmCodeSequenceTrial
      //(0040,A296)
      = const Tag.public("AlgorithmCodeSequenceTrial", 0x0040A296,
          "Algorithm Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kAlgorithmDescriptionTrial
      //(0040,A297)
      = const Tag.public("AlgorithmDescriptionTrial", 0x0040A297,
          "Algorithm Description (Trial)", VR.kST, VM.k1, true);
  static const Tag kPixelCoordinatesSetTrial
      //(0040,A29A)
      = const Tag.public("PixelCoordinatesSetTrial", 0x0040A29A,
          "Pixel Coordinates Set (Trial)", VR.kSL, VM.k2_2n, true);
  static const Tag kMeasuredValueSequence
      //(0040,A300)
      = const Tag.public("MeasuredValueSequence", 0x0040A300,
          "Measured Value Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumericValueQualifierCodeSequence
      //(0040,A301)
      = const Tag.public("NumericValueQualifierCodeSequence", 0x0040A301,
          "Numeric Value Qualifier Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCurrentObserverTrial
      //(0040,A307)
      = const Tag.public("CurrentObserverTrial", 0x0040A307,
          "Current Observer (Trial)", VR.kPN, VM.k1, true);
  static const Tag kNumericValue
      //(0040,A30A)
      = const Tag.public(
          "NumericValue", 0x0040A30A, "Numeric Value", VR.kDS, VM.k1_n, false);
  static const Tag kReferencedAccessionSequenceTrial
      //(0040,A313)
      = const Tag.public("ReferencedAccessionSequenceTrial", 0x0040A313,
          "Referenced Accession Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kReportStatusCommentTrial
      //(0040,A33A)
      = const Tag.public("ReportStatusCommentTrial", 0x0040A33A,
          "Report Status Comment (Trial)", VR.kST, VM.k1, true);
  static const Tag kProcedureContextSequenceTrial
      //(0040,A340)
      = const Tag.public("ProcedureContextSequenceTrial", 0x0040A340,
          "Procedure Context Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kVerbalSourceTrial
      //(0040,A352)
      = const Tag.public("VerbalSourceTrial", 0x0040A352,
          "Verbal Source (Trial)", VR.kPN, VM.k1, true);
  static const Tag kAddressTrial
      //(0040,A353)
      = const Tag.public(
          "AddressTrial", 0x0040A353, "Address (Trial)", VR.kST, VM.k1, true);
  static const Tag kTelephoneNumberTrial
      //(0040,A354)
      = const Tag.public("TelephoneNumberTrial", 0x0040A354,
          "Telephone Number (Trial)", VR.kLO, VM.k1, true);
  static const Tag kVerbalSourceIdentifierCodeSequenceTrial
      //(0040,A358)
      = const Tag.public(
          "VerbalSourceIdentifierCodeSequenceTrial",
          0x0040A358,
          "Verbal Source Identifier Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kPredecessorDocumentsSequence
      //(0040,A360)
      = const Tag.public("PredecessorDocumentsSequence", 0x0040A360,
          "Predecessor Documents Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedRequestSequence
      //(0040,A370)
      = const Tag.public("ReferencedRequestSequence", 0x0040A370,
          "Referenced Request Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedProcedureCodeSequence
      //(0040,A372)
      = const Tag.public("PerformedProcedureCodeSequence", 0x0040A372,
          "Performed Procedure Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCurrentRequestedProcedureEvidenceSequence
      //(0040,A375)
      = const Tag.public(
          "CurrentRequestedProcedureEvidenceSequence",
          0x0040A375,
          "Current Requested Procedure Evidence Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReportDetailSequenceTrial
      //(0040,A380)
      = const Tag.public("ReportDetailSequenceTrial", 0x0040A380,
          "Report Detail Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kPertinentOtherEvidenceSequence
      //(0040,A385)
      = const Tag.public("PertinentOtherEvidenceSequence", 0x0040A385,
          "Pertinent Other Evidence Sequence", VR.kSQ, VM.k1, false);
  static const Tag kHL7StructuredDocumentReferenceSequence
      //(0040,A390)
      = const Tag.public("HL7StructuredDocumentReferenceSequence", 0x0040A390,
          "HL7 Structured Document Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObservationSubjectUIDTrial
      //(0040,A402)
      = const Tag.public("ObservationSubjectUIDTrial", 0x0040A402,
          "Observation Subject UID (Trial)", VR.kUI, VM.k1, true);
  static const Tag kObservationSubjectClassTrial
      //(0040,A403)
      = const Tag.public("ObservationSubjectClassTrial", 0x0040A403,
          "Observation Subject Class (Trial)", VR.kCS, VM.k1, true);
  static const Tag kObservationSubjectTypeCodeSequenceTrial
      //(0040,A404)
      = const Tag.public(
          "ObservationSubjectTypeCodeSequenceTrial",
          0x0040A404,
          "Observation Subject Type Code Sequence (Trial)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kCompletionFlag
      //(0040,A491)
      = const Tag.public("CompletionFlag", 0x0040A491, "Completion Flag",
          VR.kCS, VM.k1, false);
  static const Tag kCompletionFlagDescription
      //(0040,A492)
      = const Tag.public("CompletionFlagDescription", 0x0040A492,
          "Completion Flag Description", VR.kLO, VM.k1, false);
  static const Tag kVerificationFlag
      //(0040,A493)
      = const Tag.public("VerificationFlag", 0x0040A493, "Verification Flag",
          VR.kCS, VM.k1, false);
  static const Tag kArchiveRequested
      //(0040,A494)
      = const Tag.public("ArchiveRequested", 0x0040A494, "Archive Requested",
          VR.kCS, VM.k1, false);
  static const Tag kPreliminaryFlag
      //(0040,A496)
      = const Tag.public("PreliminaryFlag", 0x0040A496, "Preliminary Flag",
          VR.kCS, VM.k1, false);
  static const Tag kContentTemplateSequence
      //(0040,A504)
      = const Tag.public("ContentTemplateSequence", 0x0040A504,
          "Content Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIdenticalDocumentsSequence
      //(0040,A525)
      = const Tag.public("IdenticalDocumentsSequence", 0x0040A525,
          "Identical Documents Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObservationSubjectContextFlagTrial
      //(0040,A600)
      = const Tag.public("ObservationSubjectContextFlagTrial", 0x0040A600,
          "Observation Subject Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const Tag kObserverContextFlagTrial
      //(0040,A601)
      = const Tag.public("ObserverContextFlagTrial", 0x0040A601,
          "Observer Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const Tag kProcedureContextFlagTrial
      //(0040,A603)
      = const Tag.public("ProcedureContextFlagTrial", 0x0040A603,
          "Procedure Context Flag (Trial)", VR.kCS, VM.k1, true);
  static const Tag kContentSequence
      //(0040,A730)
      = const Tag.public("ContentSequence", 0x0040A730, "Content Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kRelationshipSequenceTrial
      //(0040,A731)
      = const Tag.public("RelationshipSequenceTrial", 0x0040A731,
          "Relationship Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kRelationshipTypeCodeSequenceTrial
      //(0040,A732)
      = const Tag.public("RelationshipTypeCodeSequenceTrial", 0x0040A732,
          "Relationship Type Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kLanguageCodeSequenceTrial
      //(0040,A744)
      = const Tag.public("LanguageCodeSequenceTrial", 0x0040A744,
          "Language Code Sequence (Trial)", VR.kSQ, VM.k1, true);
  static const Tag kUniformResourceLocatorTrial
      //(0040,A992)
      = const Tag.public("UniformResourceLocatorTrial", 0x0040A992,
          "Uniform Resource Locator (Trial)", VR.kST, VM.k1, true);
  static const Tag kWaveformAnnotationSequence
      //(0040,B020)
      = const Tag.public("WaveformAnnotationSequence", 0x0040B020,
          "Waveform Annotation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTemplateIdentifier
      //(0040,DB00)
      = const Tag.public("TemplateIdentifier", 0x0040DB00,
          "Template Identifier", VR.kCS, VM.k1, false);
  static const Tag kTemplateVersion
      //(0040,DB06)
      = const Tag.public("TemplateVersion", 0x0040DB06, "Template Version",
          VR.kDT, VM.k1, true);
  static const Tag kTemplateLocalVersion
      //(0040,DB07)
      = const Tag.public("TemplateLocalVersion", 0x0040DB07,
          "Template Local Version", VR.kDT, VM.k1, true);
  static const Tag kTemplateExtensionFlag
      //(0040,DB0B)
      = const Tag.public("TemplateExtensionFlag", 0x0040DB0B,
          "Template Extension Flag", VR.kCS, VM.k1, true);
  static const Tag kTemplateExtensionOrganizationUID
      //(0040,DB0C)
      = const Tag.public("TemplateExtensionOrganizationUID", 0x0040DB0C,
          "Template Extension Organization UID", VR.kUI, VM.k1, true);
  static const Tag kTemplateExtensionCreatorUID
      //(0040,DB0D)
      = const Tag.public("TemplateExtensionCreatorUID", 0x0040DB0D,
          "Template Extension Creator UID", VR.kUI, VM.k1, true);
  static const Tag kReferencedContentItemIdentifier
      //(0040,DB73)
      = const Tag.public("ReferencedContentItemIdentifier", 0x0040DB73,
          "Referenced Content Item Identifier", VR.kUL, VM.k1_n, false);
  static const Tag kHL7InstanceIdentifier
      //(0040,E001)
      = const Tag.public("HL7InstanceIdentifier", 0x0040E001,
          "HL7 Instance Identifier", VR.kST, VM.k1, false);
  static const Tag kHL7DocumentEffectiveTime
      //(0040,E004)
      = const Tag.public("HL7DocumentEffectiveTime", 0x0040E004,
          "HL7 Document Effective Time", VR.kDT, VM.k1, false);
  static const Tag kHL7DocumentTypeCodeSequence
      //(0040,E006)
      = const Tag.public("HL7DocumentTypeCodeSequence", 0x0040E006,
          "HL7 Document Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDocumentClassCodeSequence
      //(0040,E008)
      = const Tag.public("DocumentClassCodeSequence", 0x0040E008,
          "Document Class Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRetrieveURI
      //(0040,E010)
      = const Tag.public(
          "RetrieveURI", 0x0040E010, "Retrieve URI", VR.kUT, VM.k1, false);
  static const Tag kRetrieveLocationUID
      //(0040,E011)
      = const Tag.public("RetrieveLocationUID", 0x0040E011,
          "Retrieve Location UID", VR.kUI, VM.k1, false);
  static const Tag kTypeOfInstances
      //(0040,E020)
      = const Tag.public("TypeOfInstances", 0x0040E020, "Type of Instances",
          VR.kCS, VM.k1, false);
  static const Tag kDICOMRetrievalSequence
      //(0040,E021)
      = const Tag.public("DICOMRetrievalSequence", 0x0040E021,
          "DICOM Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDICOMMediaRetrievalSequence
      //(0040,E022)
      = const Tag.public("DICOMMediaRetrievalSequence", 0x0040E022,
          "DICOM Media Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const Tag kWADORetrievalSequence
      //(0040,E023)
      = const Tag.public("WADORetrievalSequence", 0x0040E023,
          "WADO Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const Tag kXDSRetrievalSequence
      //(0040,E024)
      = const Tag.public("XDSRetrievalSequence", 0x0040E024,
          "XDS Retrieval Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRepositoryUniqueID
      //(0040,E030)
      = const Tag.public("RepositoryUniqueID", 0x0040E030,
          "Repository Unique ID", VR.kUI, VM.k1, false);
  static const Tag kHomeCommunityID
      //(0040,E031)
      = const Tag.public("HomeCommunityID", 0x0040E031, "Home Community ID",
          VR.kUI, VM.k1, false);
  static const Tag kDocumentTitle
      //(0042,0010)
      = const Tag.public(
          "DocumentTitle", 0x00420010, "Document Title", VR.kST, VM.k1, false);
  static const Tag kEncapsulatedDocument
      //(0042,0011)
      = const Tag.public("EncapsulatedDocument", 0x00420011,
          "Encapsulated Document", VR.kOB, VM.k1, false);
  static const Tag kMIMETypeOfEncapsulatedDocument
      //(0042,0012)
      = const Tag.public("MIMETypeOfEncapsulatedDocument", 0x00420012,
          "MIME Type of Encapsulated Document", VR.kLO, VM.k1, false);
  static const Tag kSourceInstanceSequence
      //(0042,0013)
      = const Tag.public("SourceInstanceSequence", 0x00420013,
          "Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kListOfMIMETypes
      //(0042,0014)
      = const Tag.public("ListOfMIMETypes", 0x00420014, "List of MIME Types",
          VR.kLO, VM.k1_n, false);
  static const Tag kProductPackageIdentifier
      //(0044,0001)
      = const Tag.public("ProductPackageIdentifier", 0x00440001,
          "Product Package Identifier", VR.kST, VM.k1, false);
  static const Tag kSubstanceAdministrationApproval
      //(0044,0002)
      = const Tag.public("SubstanceAdministrationApproval", 0x00440002,
          "Substance Administration Approval", VR.kCS, VM.k1, false);
  static const Tag kApprovalStatusFurtherDescription
      //(0044,0003)
      = const Tag.public("ApprovalStatusFurtherDescription", 0x00440003,
          "Approval Status Further Description", VR.kLT, VM.k1, false);
  static const Tag kApprovalStatusDateTime
      //(0044,0004)
      = const Tag.public("ApprovalStatusDateTime", 0x00440004,
          "Approval Status DateTime", VR.kDT, VM.k1, false);
  static const Tag kProductTypeCodeSequence
      //(0044,0007)
      = const Tag.public("ProductTypeCodeSequence", 0x00440007,
          "Product Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kProductName
      //(0044,0008)
      = const Tag.public(
          "ProductName", 0x00440008, "Product Name", VR.kLO, VM.k1_n, false);
  static const Tag kProductDescription
      //(0044,0009)
      = const Tag.public("ProductDescription", 0x00440009,
          "Product Description", VR.kLT, VM.k1, false);
  static const Tag kProductLotIdentifier
      //(0044,000A)
      = const Tag.public("ProductLotIdentifier", 0x0044000A,
          "Product Lot Identifier", VR.kLO, VM.k1, false);
  static const Tag kProductExpirationDateTime
      //(0044,000B)
      = const Tag.public("ProductExpirationDateTime", 0x0044000B,
          "Product Expiration DateTime", VR.kDT, VM.k1, false);
  static const Tag kSubstanceAdministrationDateTime
      //(0044,0010)
      = const Tag.public("SubstanceAdministrationDateTime", 0x00440010,
          "Substance Administration DateTime", VR.kDT, VM.k1, false);
  static const Tag kSubstanceAdministrationNotes
      //(0044,0011)
      = const Tag.public("SubstanceAdministrationNotes", 0x00440011,
          "Substance Administration Notes", VR.kLO, VM.k1, false);
  static const Tag kSubstanceAdministrationDeviceID
      //(0044,0012)
      = const Tag.public("SubstanceAdministrationDeviceID", 0x00440012,
          "Substance Administration Device ID", VR.kLO, VM.k1, false);
  static const Tag kProductParameterSequence
      //(0044,0013)
      = const Tag.public("ProductParameterSequence", 0x00440013,
          "Product Parameter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSubstanceAdministrationParameterSequence
      //(0044,0019)
      = const Tag.public("SubstanceAdministrationParameterSequence", 0x00440019,
          "Substance Administration Parameter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLensDescription
      //(0046,0012)
      = const Tag.public("LensDescription", 0x00460012, "Lens Description",
          VR.kLO, VM.k1, false);
  static const Tag kRightLensSequence
      //(0046,0014)
      = const Tag.public("RightLensSequence", 0x00460014, "Right Lens Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kLeftLensSequence
      //(0046,0015)
      = const Tag.public("LeftLensSequence", 0x00460015, "Left Lens Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kUnspecifiedLateralityLensSequence
      //(0046,0016)
      = const Tag.public("UnspecifiedLateralityLensSequence", 0x00460016,
          "Unspecified Laterality Lens Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCylinderSequence
      //(0046,0018)
      = const Tag.public("CylinderSequence", 0x00460018, "Cylinder Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kPrismSequence
      //(0046,0028)
      = const Tag.public(
          "PrismSequence", 0x00460028, "Prism Sequence", VR.kSQ, VM.k1, false);
  static const Tag kHorizontalPrismPower
      //(0046,0030)
      = const Tag.public("HorizontalPrismPower", 0x00460030,
          "Horizontal Prism Power", VR.kFD, VM.k1, false);
  static const Tag kHorizontalPrismBase
      //(0046,0032)
      = const Tag.public("HorizontalPrismBase", 0x00460032,
          "Horizontal Prism Base", VR.kCS, VM.k1, false);
  static const Tag kVerticalPrismPower
      //(0046,0034)
      = const Tag.public("VerticalPrismPower", 0x00460034,
          "Vertical Prism Power", VR.kFD, VM.k1, false);
  static const Tag kVerticalPrismBase
      //(0046,0036)
      = const Tag.public("VerticalPrismBase", 0x00460036, "Vertical Prism Base",
          VR.kCS, VM.k1, false);
  static const Tag kLensSegmentType
      //(0046,0038)
      = const Tag.public("LensSegmentType", 0x00460038, "Lens Segment Type",
          VR.kCS, VM.k1, false);
  static const Tag kOpticalTransmittance
      //(0046,0040)
      = const Tag.public("OpticalTransmittance", 0x00460040,
          "Optical Transmittance", VR.kFD, VM.k1, false);
  static const Tag kChannelWidth
      //(0046,0042)
      = const Tag.public(
          "ChannelWidth", 0x00460042, "Channel Width", VR.kFD, VM.k1, false);
  static const Tag kPupilSize
      //(0046,0044)
      = const Tag.public(
          "PupilSize", 0x00460044, "Pupil Size", VR.kFD, VM.k1, false);
  static const Tag kCornealSize
      //(0046,0046)
      = const Tag.public(
          "CornealSize", 0x00460046, "Corneal Size", VR.kFD, VM.k1, false);
  static const Tag kAutorefractionRightEyeSequence
      //(0046,0050)
      = const Tag.public("AutorefractionRightEyeSequence", 0x00460050,
          "Autorefraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAutorefractionLeftEyeSequence
      //(0046,0052)
      = const Tag.public("AutorefractionLeftEyeSequence", 0x00460052,
          "Autorefraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDistancePupillaryDistance
      //(0046,0060)
      = const Tag.public("DistancePupillaryDistance", 0x00460060,
          "Distance Pupillary Distance", VR.kFD, VM.k1, false);
  static const Tag kNearPupillaryDistance
      //(0046,0062)
      = const Tag.public("NearPupillaryDistance", 0x00460062,
          "Near Pupillary Distance", VR.kFD, VM.k1, false);
  static const Tag kIntermediatePupillaryDistance
      //(0046,0063)
      = const Tag.public("IntermediatePupillaryDistance", 0x00460063,
          "Intermediate Pupillary Distance", VR.kFD, VM.k1, false);
  static const Tag kOtherPupillaryDistance
      //(0046,0064)
      = const Tag.public("OtherPupillaryDistance", 0x00460064,
          "Other Pupillary Distance", VR.kFD, VM.k1, false);
  static const Tag kKeratometryRightEyeSequence
      //(0046,0070)
      = const Tag.public("KeratometryRightEyeSequence", 0x00460070,
          "Keratometry Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kKeratometryLeftEyeSequence
      //(0046,0071)
      = const Tag.public("KeratometryLeftEyeSequence", 0x00460071,
          "Keratometry Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSteepKeratometricAxisSequence
      //(0046,0074)
      = const Tag.public("SteepKeratometricAxisSequence", 0x00460074,
          "Steep Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRadiusOfCurvature
      //(0046,0075)
      = const Tag.public("RadiusOfCurvature", 0x00460075, "Radius of Curvature",
          VR.kFD, VM.k1, false);
  static const Tag kKeratometricPower
      //(0046,0076)
      = const Tag.public("KeratometricPower", 0x00460076, "Keratometric Power",
          VR.kFD, VM.k1, false);
  static const Tag kKeratometricAxis
      //(0046,0077)
      = const Tag.public("KeratometricAxis", 0x00460077, "Keratometric Axis",
          VR.kFD, VM.k1, false);
  static const Tag kFlatKeratometricAxisSequence
      //(0046,0080)
      = const Tag.public("FlatKeratometricAxisSequence", 0x00460080,
          "Flat Keratometric Axis Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBackgroundColor
      //(0046,0092)
      = const Tag.public("BackgroundColor", 0x00460092, "Background Color",
          VR.kCS, VM.k1, false);
  static const Tag kOptotype
      //(0046,0094)
      = const Tag.public(
          "Optotype", 0x00460094, "Optotype", VR.kCS, VM.k1, false);
  static const Tag kOptotypePresentation
      //(0046,0095)
      = const Tag.public("OptotypePresentation", 0x00460095,
          "Optotype Presentation", VR.kCS, VM.k1, false);
  static const Tag kSubjectiveRefractionRightEyeSequence
      //(0046,0097)
      = const Tag.public("SubjectiveRefractionRightEyeSequence", 0x00460097,
          "Subjective Refraction Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSubjectiveRefractionLeftEyeSequence
      //(0046,0098)
      = const Tag.public("SubjectiveRefractionLeftEyeSequence", 0x00460098,
          "Subjective Refraction Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAddNearSequence
      //(0046,0100)
      = const Tag.public("AddNearSequence", 0x00460100, "Add Near Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kAddIntermediateSequence
      //(0046,0101)
      = const Tag.public("AddIntermediateSequence", 0x00460101,
          "Add Intermediate Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAddOtherSequence
      //(0046,0102)
      = const Tag.public("AddOtherSequence", 0x00460102, "Add Other Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kAddPower
      //(0046,0104)
      = const Tag.public(
          "AddPower", 0x00460104, "Add Power", VR.kFD, VM.k1, false);
  static const Tag kViewingDistance
      //(0046,0106)
      = const Tag.public("ViewingDistance", 0x00460106, "Viewing Distance",
          VR.kFD, VM.k1, false);
  static const Tag kVisualAcuityTypeCodeSequence
      //(0046,0121)
      = const Tag.public("VisualAcuityTypeCodeSequence", 0x00460121,
          "Visual Acuity Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualAcuityRightEyeSequence
      //(0046,0122)
      = const Tag.public("VisualAcuityRightEyeSequence", 0x00460122,
          "Visual Acuity Right Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualAcuityLeftEyeSequence
      //(0046,0123)
      = const Tag.public("VisualAcuityLeftEyeSequence", 0x00460123,
          "Visual Acuity Left Eye Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVisualAcuityBothEyesOpenSequence
      //(0046,0124)
      = const Tag.public("VisualAcuityBothEyesOpenSequence", 0x00460124,
          "Visual Acuity Both Eyes Open Sequence", VR.kSQ, VM.k1, false);
  static const Tag kViewingDistanceType
      //(0046,0125)
      = const Tag.public("ViewingDistanceType", 0x00460125,
          "Viewing Distance Type", VR.kCS, VM.k1, false);
  static const Tag kVisualAcuityModifiers
      //(0046,0135)
      = const Tag.public("VisualAcuityModifiers", 0x00460135,
          "Visual Acuity Modifiers", VR.kSS, VM.k2, false);
  static const Tag kDecimalVisualAcuity
      //(0046,0137)
      = const Tag.public("DecimalVisualAcuity", 0x00460137,
          "Decimal Visual Acuity", VR.kFD, VM.k1, false);
  static const Tag kOptotypeDetailedDefinition
      //(0046,0139)
      = const Tag.public("OptotypeDetailedDefinition", 0x00460139,
          "Optotype Detailed Definition", VR.kLO, VM.k1, false);
  static const Tag kReferencedRefractiveMeasurementsSequence
      //(0046,0145)
      = const Tag.public("ReferencedRefractiveMeasurementsSequence", 0x00460145,
          "Referenced Refractive Measurements Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpherePower
      //(0046,0146)
      = const Tag.public(
          "SpherePower", 0x00460146, "Sphere Power", VR.kFD, VM.k1, false);
  static const Tag kCylinderPower
      //(0046,0147)
      = const Tag.public(
          "CylinderPower", 0x00460147, "Cylinder Power", VR.kFD, VM.k1, false);
  static const Tag kCornealTopographySurface
      //(0046,0201)
      = const Tag.public("CornealTopographySurface", 0x00460201,
          "Corneal Topography Surface", VR.kCS, VM.k1, false);
  static const Tag kCornealVertexLocation
      //(0046,0202)
      = const Tag.public("CornealVertexLocation", 0x00460202,
          "Corneal Vertex Location", VR.kFL, VM.k2, false);
  static const Tag kPupilCentroidXCoordinate
      //(0046,0203)
      = const Tag.public("PupilCentroidXCoordinate", 0x00460203,
          "Pupil Centroid X-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kPupilCentroidYCoordinate
      //(0046,0204)
      = const Tag.public("PupilCentroidYCoordinate", 0x00460204,
          "Pupil Centroid Y-Coordinate", VR.kFL, VM.k1, false);
  static const Tag kEquivalentPupilRadius
      //(0046,0205)
      = const Tag.public("EquivalentPupilRadius", 0x00460205,
          "Equivalent Pupil Radius", VR.kFL, VM.k1, false);
  static const Tag kCornealTopographyMapTypeCodeSequence
      //(0046,0207)
      = const Tag.public("CornealTopographyMapTypeCodeSequence", 0x00460207,
          "Corneal Topography Map Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVerticesOfTheOutlineOfPupil
      //(0046,0208)
      = const Tag.public("VerticesOfTheOutlineOfPupil", 0x00460208,
          "Vertices of the Outline of Pupil", VR.kIS, VM.k2_2n, false);
  static const Tag kCornealTopographyMappingNormalsSequence
      //(0046,0210)
      = const Tag.public("CornealTopographyMappingNormalsSequence", 0x00460210,
          "Corneal Topography Mapping Normals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMaximumCornealCurvatureSequence
      //(0046,0211)
      = const Tag.public("MaximumCornealCurvatureSequence", 0x00460211,
          "Maximum Corneal Curvature Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMaximumCornealCurvature
      //(0046,0212)
      = const Tag.public("MaximumCornealCurvature", 0x00460212,
          "Maximum Corneal Curvature", VR.kFL, VM.k1, false);
  static const Tag kMaximumCornealCurvatureLocation
      //(0046,0213)
      = const Tag.public("MaximumCornealCurvatureLocation", 0x00460213,
          "Maximum Corneal Curvature Location", VR.kFL, VM.k2, false);
  static const Tag kMinimumKeratometricSequence
      //(0046,0215)
      = const Tag.public("MinimumKeratometricSequence", 0x00460215,
          "Minimum Keratometric Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSimulatedKeratometricCylinderSequence
      //(0046,0218)
      = const Tag.public("SimulatedKeratometricCylinderSequence", 0x00460218,
          "Simulated Keratometric Cylinder Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAverageCornealPower
      //(0046,0220)
      = const Tag.public("AverageCornealPower", 0x00460220,
          "Average Corneal Power", VR.kFL, VM.k1, false);
  static const Tag kCornealISValue
      //(0046,0224)
      = const Tag.public("CornealISValue", 0x00460224, "Corneal I-S Value",
          VR.kFL, VM.k1, false);
  static const Tag kAnalyzedArea
      //(0046,0227)
      = const Tag.public(
          "AnalyzedArea", 0x00460227, "Analyzed Area", VR.kFL, VM.k1, false);
  static const Tag kSurfaceRegularityIndex
      //(0046,0230)
      = const Tag.public("SurfaceRegularityIndex", 0x00460230,
          "Surface Regularity Index", VR.kFL, VM.k1, false);
  static const Tag kSurfaceAsymmetryIndex
      //(0046,0232)
      = const Tag.public("SurfaceAsymmetryIndex", 0x00460232,
          "Surface Asymmetry Index", VR.kFL, VM.k1, false);
  static const Tag kCornealEccentricityIndex
      //(0046,0234)
      = const Tag.public("CornealEccentricityIndex", 0x00460234,
          "Corneal Eccentricity Index", VR.kFL, VM.k1, false);
  static const Tag kKeratoconusPredictionIndex
      //(0046,0236)
      = const Tag.public("KeratoconusPredictionIndex", 0x00460236,
          "Keratoconus Prediction Index", VR.kFL, VM.k1, false);
  static const Tag kDecimalPotentialVisualAcuity
      //(0046,0238)
      = const Tag.public("DecimalPotentialVisualAcuity", 0x00460238,
          "Decimal Potential Visual Acuity", VR.kFL, VM.k1, false);
  static const Tag kCornealTopographyMapQualityEvaluation
      //(0046,0242)
      = const Tag.public("CornealTopographyMapQualityEvaluation", 0x00460242,
          "Corneal Topography Map Quality Evaluation", VR.kCS, VM.k1, false);
  static const Tag kSourceImageCornealProcessedDataSequence
      //(0046,0244)
      = const Tag.public("SourceImageCornealProcessedDataSequence", 0x00460244,
          "Source Image Corneal Processed Data Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCornealPointLocation
      //(0046,0247)
      = const Tag.public("CornealPointLocation", 0x00460247,
          "Corneal Point Location", VR.kFL, VM.k3, false);
  static const Tag kCornealPointEstimated
      //(0046,0248)
      = const Tag.public("CornealPointEstimated", 0x00460248,
          "Corneal Point Estimated", VR.kCS, VM.k1, false);
  static const Tag kAxialPower
      //(0046,0249)
      = const Tag.public(
          "AxialPower", 0x00460249, "Axial Power", VR.kFL, VM.k1, false);
  static const Tag kTangentialPower
      //(0046,0250)
      = const Tag.public("TangentialPower", 0x00460250, "Tangential Power",
          VR.kFL, VM.k1, false);
  static const Tag kRefractivePower
      //(0046,0251)
      = const Tag.public("RefractivePower", 0x00460251, "Refractive Power",
          VR.kFL, VM.k1, false);
  static const Tag kRelativeElevation
      //(0046,0252)
      = const Tag.public("RelativeElevation", 0x00460252, "Relative Elevation",
          VR.kFL, VM.k1, false);
  static const Tag kCornealWavefront
      //(0046,0253)
      = const Tag.public("CornealWavefront", 0x00460253, "Corneal Wavefront",
          VR.kFL, VM.k1, false);
  static const Tag kImagedVolumeWidth
      //(0048,0001)
      = const Tag.public("ImagedVolumeWidth", 0x00480001, "Imaged Volume Width",
          VR.kFL, VM.k1, false);
  static const Tag kImagedVolumeHeight
      //(0048,0002)
      = const Tag.public("ImagedVolumeHeight", 0x00480002,
          "Imaged Volume Height", VR.kFL, VM.k1, false);
  static const Tag kImagedVolumeDepth
      //(0048,0003)
      = const Tag.public("ImagedVolumeDepth", 0x00480003, "Imaged Volume Depth",
          VR.kFL, VM.k1, false);
  static const Tag kTotalPixelMatrixColumns
      //(0048,0006)
      = const Tag.public("TotalPixelMatrixColumns", 0x00480006,
          "Total Pixel Matrix Columns", VR.kUL, VM.k1, false);
  static const Tag kTotalPixelMatrixRows
      //(0048,0007)
      = const Tag.public("TotalPixelMatrixRows", 0x00480007,
          "Total Pixel Matrix Rows", VR.kUL, VM.k1, false);
  static const Tag kTotalPixelMatrixOriginSequence
      //(0048,0008)
      = const Tag.public("TotalPixelMatrixOriginSequence", 0x00480008,
          "Total Pixel Matrix Origin Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenLabelInImage
      //(0048,0010)
      = const Tag.public("SpecimenLabelInImage", 0x00480010,
          "Specimen Label in Image", VR.kCS, VM.k1, false);
  static const Tag kFocusMethod
      //(0048,0011)
      = const Tag.public(
          "FocusMethod", 0x00480011, "Focus Method", VR.kCS, VM.k1, false);
  static const Tag kExtendedDepthOfField
      //(0048,0012)
      = const Tag.public("ExtendedDepthOfField", 0x00480012,
          "Extended Depth of Field", VR.kCS, VM.k1, false);
  static const Tag kNumberOfFocalPlanes
      //(0048,0013)
      = const Tag.public("NumberOfFocalPlanes", 0x00480013,
          "Number of Focal Planes", VR.kUS, VM.k1, false);
  static const Tag kDistanceBetweenFocalPlanes
      //(0048,0014)
      = const Tag.public("DistanceBetweenFocalPlanes", 0x00480014,
          "Distance Between Focal Planes", VR.kFL, VM.k1, false);
  static const Tag kRecommendedAbsentPixelCIELabValue
      //(0048,0015)
      = const Tag.public("RecommendedAbsentPixelCIELabValue", 0x00480015,
          "Recommended Absent Pixel CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kIlluminatorTypeCodeSequence
      //(0048,0100)
      = const Tag.public("IlluminatorTypeCodeSequence", 0x00480100,
          "Illuminator Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageOrientationSlide
      //(0048,0102)
      = const Tag.public("ImageOrientationSlide", 0x00480102,
          "Image Orientation (Slide)", VR.kDS, VM.k6, false);
  static const Tag kOpticalPathSequence
      //(0048,0105)
      = const Tag.public("OpticalPathSequence", 0x00480105,
          "Optical Path Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOpticalPathIdentifier
      //(0048,0106)
      = const Tag.public("OpticalPathIdentifier", 0x00480106,
          "Optical Path Identifier", VR.kSH, VM.k1, false);
  static const Tag kOpticalPathDescription
      //(0048,0107)
      = const Tag.public("OpticalPathDescription", 0x00480107,
          "Optical Path Description", VR.kST, VM.k1, false);
  static const Tag kIlluminationColorCodeSequence
      //(0048,0108)
      = const Tag.public("IlluminationColorCodeSequence", 0x00480108,
          "Illumination Color Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecimenReferenceSequence
      //(0048,0110)
      = const Tag.public("SpecimenReferenceSequence", 0x00480110,
          "Specimen Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCondenserLensPower
      //(0048,0111)
      = const Tag.public("CondenserLensPower", 0x00480111,
          "Condenser Lens Power", VR.kDS, VM.k1, false);
  static const Tag kObjectiveLensPower
      //(0048,0112)
      = const Tag.public("ObjectiveLensPower", 0x00480112,
          "Objective Lens Power", VR.kDS, VM.k1, false);
  static const Tag kObjectiveLensNumericalAperture
      //(0048,0113)
      = const Tag.public("ObjectiveLensNumericalAperture", 0x00480113,
          "Objective Lens Numerical Aperture", VR.kDS, VM.k1, false);
  static const Tag kPaletteColorLookupTableSequence
      //(0048,0120)
      = const Tag.public("PaletteColorLookupTableSequence", 0x00480120,
          "Palette Color Lookup Table Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedImageNavigationSequence
      //(0048,0200)
      = const Tag.public("ReferencedImageNavigationSequence", 0x00480200,
          "Referenced Image Navigation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTopLeftHandCornerOfLocalizerArea
      //(0048,0201)
      = const Tag.public("TopLeftHandCornerOfLocalizerArea", 0x00480201,
          "Top Left Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const Tag kBottomRightHandCornerOfLocalizerArea
      //(0048,0202)
      = const Tag.public("BottomRightHandCornerOfLocalizerArea", 0x00480202,
          "Bottom Right Hand Corner of Localizer Area", VR.kUS, VM.k2, false);
  static const Tag kOpticalPathIdentificationSequence
      //(0048,0207)
      = const Tag.public("OpticalPathIdentificationSequence", 0x00480207,
          "Optical Path Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanePositionSlideSequence
      //(0048,021A)
      = const Tag.public("PlanePositionSlideSequence", 0x0048021A,
          "Plane Position (Slide) Sequence", VR.kSQ, VM.k1, false);
  static const Tag kColumnPositionInTotalImagePixelMatrix
      //(0048,021E)
      = const Tag.public("ColumnPositionInTotalImagePixelMatrix", 0x0048021E,
          "Column Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const Tag kRowPositionInTotalImagePixelMatrix
      //(0048,021F)
      = const Tag.public("RowPositionInTotalImagePixelMatrix", 0x0048021F,
          "Row Position In Total Image Pixel Matrix", VR.kSL, VM.k1, false);
  static const Tag kPixelOriginInterpretation
      //(0048,0301)
      = const Tag.public("PixelOriginInterpretation", 0x00480301,
          "Pixel Origin Interpretation", VR.kCS, VM.k1, false);
  static const Tag kCalibrationImage
      //(0050,0004)
      = const Tag.public("CalibrationImage", 0x00500004, "Calibration Image",
          VR.kCS, VM.k1, false);
  static const Tag kDeviceSequence
      //(0050,0010)
      = const Tag.public("DeviceSequence", 0x00500010, "Device Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kContainerComponentTypeCodeSequence
      //(0050,0012)
      = const Tag.public("ContainerComponentTypeCodeSequence", 0x00500012,
          "Container Component Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContainerComponentThickness
      //(0050,0013)
      = const Tag.public("ContainerComponentThickness", 0x00500013,
          "Container Component Thickness", VR.kFD, VM.k1, false);
  static const Tag kDeviceLength
      //(0050,0014)
      = const Tag.public(
          "DeviceLength", 0x00500014, "Device Length", VR.kDS, VM.k1, false);
  static const Tag kContainerComponentWidth
      //(0050,0015)
      = const Tag.public("ContainerComponentWidth", 0x00500015,
          "Container Component Width", VR.kFD, VM.k1, false);
  static const Tag kDeviceDiameter
      //(0050,0016)
      = const Tag.public("DeviceDiameter", 0x00500016, "Device Diameter",
          VR.kDS, VM.k1, false);
  static const Tag kDeviceDiameterUnits
      //(0050,0017)
      = const Tag.public("DeviceDiameterUnits", 0x00500017,
          "Device Diameter Units", VR.kCS, VM.k1, false);
  static const Tag kDeviceVolume
      //(0050,0018)
      = const Tag.public(
          "DeviceVolume", 0x00500018, "Device Volume", VR.kDS, VM.k1, false);
  static const Tag kInterMarkerDistance
      //(0050,0019)
      = const Tag.public("InterMarkerDistance", 0x00500019,
          "Inter-Marker Distance", VR.kDS, VM.k1, false);
  static const Tag kContainerComponentMaterial
      //(0050,001A)
      = const Tag.public("ContainerComponentMaterial", 0x0050001A,
          "Container Component Material", VR.kCS, VM.k1, false);
  static const Tag kContainerComponentID
      //(0050,001B)
      = const Tag.public("ContainerComponentID", 0x0050001B,
          "Container Component ID", VR.kLO, VM.k1, false);
  static const Tag kContainerComponentLength
      //(0050,001C)
      = const Tag.public("ContainerComponentLength", 0x0050001C,
          "Container Component Length", VR.kFD, VM.k1, false);
  static const Tag kContainerComponentDiameter
      //(0050,001D)
      = const Tag.public("ContainerComponentDiameter", 0x0050001D,
          "Container Component Diameter", VR.kFD, VM.k1, false);
  static const Tag kContainerComponentDescription
      //(0050,001E)
      = const Tag.public("ContainerComponentDescription", 0x0050001E,
          "Container Component Description", VR.kLO, VM.k1, false);
  static const Tag kDeviceDescription
      //(0050,0020)
      = const Tag.public("DeviceDescription", 0x00500020, "Device Description",
          VR.kLO, VM.k1, false);
  static const Tag kContrastBolusIngredientPercentByVolume
      //(0052,0001)
      = const Tag.public("ContrastBolusIngredientPercentByVolume", 0x00520001,
          "Contrast/Bolus Ingredient Percent by Volume", VR.kFL, VM.k1, false);
  static const Tag kOCTFocalDistance
      //(0052,0002)
      = const Tag.public("OCTFocalDistance", 0x00520002, "OCT Focal Distance",
          VR.kFD, VM.k1, false);
  static const Tag kBeamSpotSize
      //(0052,0003)
      = const Tag.public(
          "BeamSpotSize", 0x00520003, "Beam Spot Size", VR.kFD, VM.k1, false);
  static const Tag kEffectiveRefractiveIndex
      //(0052,0004)
      = const Tag.public("EffectiveRefractiveIndex", 0x00520004,
          "Effective Refractive Index", VR.kFD, VM.k1, false);
  static const Tag kOCTAcquisitionDomain
      //(0052,0006)
      = const Tag.public("OCTAcquisitionDomain", 0x00520006,
          "OCT Acquisition Domain", VR.kCS, VM.k1, false);
  static const Tag kOCTOpticalCenterWavelength
      //(0052,0007)
      = const Tag.public("OCTOpticalCenterWavelength", 0x00520007,
          "OCT Optical Center Wavelength", VR.kFD, VM.k1, false);
  static const Tag kAxialResolution
      //(0052,0008)
      = const Tag.public("AxialResolution", 0x00520008, "Axial Resolution",
          VR.kFD, VM.k1, false);
  static const Tag kRangingDepth
      //(0052,0009)
      = const Tag.public(
          "RangingDepth", 0x00520009, "Ranging Depth", VR.kFD, VM.k1, false);
  static const Tag kALineRate
      //(0052,0011)
      = const Tag.public(
          "ALineRate", 0x00520011, "A-line Rate", VR.kFD, VM.k1, false);
  static const Tag kALinesPerFrame
      //(0052,0012)
      = const Tag.public("ALinesPerFrame", 0x00520012, "A-lines Per Frame",
          VR.kUS, VM.k1, false);
  static const Tag kCatheterRotationalRate
      //(0052,0013)
      = const Tag.public("CatheterRotationalRate", 0x00520013,
          "Catheter Rotational Rate", VR.kFD, VM.k1, false);
  static const Tag kALinePixelSpacing
      //(0052,0014)
      = const Tag.public("ALinePixelSpacing", 0x00520014,
          "A-line Pixel Spacing", VR.kFD, VM.k1, false);
  static const Tag kModeOfPercutaneousAccessSequence
      //(0052,0016)
      = const Tag.public("ModeOfPercutaneousAccessSequence", 0x00520016,
          "Mode of Percutaneous Access Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIntravascularOCTFrameTypeSequence
      //(0052,0025)
      = const Tag.public("IntravascularOCTFrameTypeSequence", 0x00520025,
          "Intravascular OCT Frame Type Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOCTZOffsetApplied
      //(0052,0026)
      = const Tag.public("OCTZOffsetApplied", 0x00520026,
          "OCT Z Offset Applied", VR.kCS, VM.k1, false);
  static const Tag kIntravascularFrameContentSequence
      //(0052,0027)
      = const Tag.public("IntravascularFrameContentSequence", 0x00520027,
          "Intravascular Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIntravascularLongitudinalDistance
      //(0052,0028)
      = const Tag.public("IntravascularLongitudinalDistance", 0x00520028,
          "Intravascular Longitudinal Distance", VR.kFD, VM.k1, false);
  static const Tag kIntravascularOCTFrameContentSequence
      //(0052,0029)
      = const Tag.public("IntravascularOCTFrameContentSequence", 0x00520029,
          "Intravascular OCT Frame Content Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOCTZOffsetCorrection
      //(0052,0030)
      = const Tag.public("OCTZOffsetCorrection", 0x00520030,
          "OCT Z Offset Correction", VR.kSS, VM.k1, false);
  static const Tag kCatheterDirectionOfRotation
      //(0052,0031)
      = const Tag.public("CatheterDirectionOfRotation", 0x00520031,
          "Catheter Direction of Rotation", VR.kCS, VM.k1, false);
  static const Tag kSeamLineLocation
      //(0052,0033)
      = const Tag.public("SeamLineLocation", 0x00520033, "Seam Line Location",
          VR.kFD, VM.k1, false);
  static const Tag kFirstALineLocation
      //(0052,0034)
      = const Tag.public("FirstALineLocation", 0x00520034,
          "First A-line Location", VR.kFD, VM.k1, false);
  static const Tag kSeamLineIndex
      //(0052,0036)
      = const Tag.public(
          "SeamLineIndex", 0x00520036, "Seam Line Index", VR.kUS, VM.k1, false);
  static const Tag kNumberOfPaddedALines
      //(0052,0038)
      = const Tag.public("NumberOfPaddedALines", 0x00520038,
          "Number of Padded A-lines", VR.kUS, VM.k1, false);
  static const Tag kInterpolationType
      //(0052,0039)
      = const Tag.public("InterpolationType", 0x00520039, "Interpolation Type",
          VR.kCS, VM.k1, false);
  static const Tag kRefractiveIndexApplied
      //(0052,003A)
      = const Tag.public("RefractiveIndexApplied", 0x0052003A,
          "Refractive Index Applied", VR.kCS, VM.k1, false);
  static const Tag kEnergyWindowVector
      //(0054,0010)
      = const Tag.public("EnergyWindowVector", 0x00540010,
          "Energy Window Vector", VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfEnergyWindows
      //(0054,0011)
      = const Tag.public("NumberOfEnergyWindows", 0x00540011,
          "Number of Energy Windows", VR.kUS, VM.k1, false);
  static const Tag kEnergyWindowInformationSequence
      //(0054,0012)
      = const Tag.public("EnergyWindowInformationSequence", 0x00540012,
          "Energy Window Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEnergyWindowRangeSequence
      //(0054,0013)
      = const Tag.public("EnergyWindowRangeSequence", 0x00540013,
          "Energy Window Range Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEnergyWindowLowerLimit
      //(0054,0014)
      = const Tag.public("EnergyWindowLowerLimit", 0x00540014,
          "Energy Window Lower Limit", VR.kDS, VM.k1, false);
  static const Tag kEnergyWindowUpperLimit
      //(0054,0015)
      = const Tag.public("EnergyWindowUpperLimit", 0x00540015,
          "Energy Window Upper Limit", VR.kDS, VM.k1, false);
  static const Tag kRadiopharmaceuticalInformationSequence
      //(0054,0016)
      = const Tag.public("RadiopharmaceuticalInformationSequence", 0x00540016,
          "Radiopharmaceutical Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kResidualSyringeCounts
      //(0054,0017)
      = const Tag.public("ResidualSyringeCounts", 0x00540017,
          "Residual Syringe Counts", VR.kIS, VM.k1, false);
  static const Tag kEnergyWindowName
      //(0054,0018)
      = const Tag.public("EnergyWindowName", 0x00540018, "Energy Window Name",
          VR.kSH, VM.k1, false);
  static const Tag kDetectorVector
      //(0054,0020)
      = const Tag.public("DetectorVector", 0x00540020, "Detector Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfDetectors
      //(0054,0021)
      = const Tag.public("NumberOfDetectors", 0x00540021, "Number of Detectors",
          VR.kUS, VM.k1, false);
  static const Tag kDetectorInformationSequence
      //(0054,0022)
      = const Tag.public("DetectorInformationSequence", 0x00540022,
          "Detector Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPhaseVector
      //(0054,0030)
      = const Tag.public(
          "PhaseVector", 0x00540030, "Phase Vector", VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfPhases
      //(0054,0031)
      = const Tag.public("NumberOfPhases", 0x00540031, "Number of Phases",
          VR.kUS, VM.k1, false);
  static const Tag kPhaseInformationSequence
      //(0054,0032)
      = const Tag.public("PhaseInformationSequence", 0x00540032,
          "Phase Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfFramesInPhase
      //(0054,0033)
      = const Tag.public("NumberOfFramesInPhase", 0x00540033,
          "Number of Frames in Phase", VR.kUS, VM.k1, false);
  static const Tag kPhaseDelay
      //(0054,0036)
      = const Tag.public(
          "PhaseDelay", 0x00540036, "Phase Delay", VR.kIS, VM.k1, false);
  static const Tag kPauseBetweenFrames
      //(0054,0038)
      = const Tag.public("PauseBetweenFrames", 0x00540038,
          "Pause Between Frames", VR.kIS, VM.k1, false);
  static const Tag kPhaseDescription
      //(0054,0039)
      = const Tag.public("PhaseDescription", 0x00540039, "Phase Description",
          VR.kCS, VM.k1, false);
  static const Tag kRotationVector
      //(0054,0050)
      = const Tag.public("RotationVector", 0x00540050, "Rotation Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfRotations
      //(0054,0051)
      = const Tag.public("NumberOfRotations", 0x00540051, "Number of Rotations",
          VR.kUS, VM.k1, false);
  static const Tag kRotationInformationSequence
      //(0054,0052)
      = const Tag.public("RotationInformationSequence", 0x00540052,
          "Rotation Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfFramesInRotation
      //(0054,0053)
      = const Tag.public("NumberOfFramesInRotation", 0x00540053,
          "Number of Frames in Rotation", VR.kUS, VM.k1, false);
  static const Tag kRRIntervalVector
      //(0054,0060)
      = const Tag.public("RRIntervalVector", 0x00540060, "R-R Interval Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfRRIntervals
      //(0054,0061)
      = const Tag.public("NumberOfRRIntervals", 0x00540061,
          "Number of R-R Intervals", VR.kUS, VM.k1, false);
  static const Tag kGatedInformationSequence
      //(0054,0062)
      = const Tag.public("GatedInformationSequence", 0x00540062,
          "Gated Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataInformationSequence
      //(0054,0063)
      = const Tag.public("DataInformationSequence", 0x00540063,
          "Data Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTimeSlotVector
      //(0054,0070)
      = const Tag.public("TimeSlotVector", 0x00540070, "Time Slot Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfTimeSlots
      //(0054,0071)
      = const Tag.public("NumberOfTimeSlots", 0x00540071,
          "Number of Time Slots", VR.kUS, VM.k1, false);
  static const Tag kTimeSlotInformationSequence
      //(0054,0072)
      = const Tag.public("TimeSlotInformationSequence", 0x00540072,
          "Time Slot Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTimeSlotTime
      //(0054,0073)
      = const Tag.public(
          "TimeSlotTime", 0x00540073, "Time Slot Time", VR.kDS, VM.k1, false);
  static const Tag kSliceVector
      //(0054,0080)
      = const Tag.public(
          "SliceVector", 0x00540080, "Slice Vector", VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfSlices
      //(0054,0081)
      = const Tag.public("NumberOfSlices", 0x00540081, "Number of Slices",
          VR.kUS, VM.k1, false);
  static const Tag kAngularViewVector
      //(0054,0090)
      = const Tag.public("AngularViewVector", 0x00540090, "Angular View Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kTimeSliceVector
      //(0054,0100)
      = const Tag.public("TimeSliceVector", 0x00540100, "Time Slice Vector",
          VR.kUS, VM.k1_n, false);
  static const Tag kNumberOfTimeSlices
      //(0054,0101)
      = const Tag.public("NumberOfTimeSlices", 0x00540101,
          "Number of Time Slices", VR.kUS, VM.k1, false);
  static const Tag kStartAngle
      //(0054,0200)
      = const Tag.public(
          "StartAngle", 0x00540200, "Start Angle", VR.kDS, VM.k1, false);
  static const Tag kTypeOfDetectorMotion
      //(0054,0202)
      = const Tag.public("TypeOfDetectorMotion", 0x00540202,
          "Type of Detector Motion", VR.kCS, VM.k1, false);
  static const Tag kTriggerVector
      //(0054,0210)
      = const Tag.public("TriggerVector", 0x00540210, "Trigger Vector", VR.kIS,
          VM.k1_n, false);
  static const Tag kNumberOfTriggersInPhase
      //(0054,0211)
      = const Tag.public("NumberOfTriggersInPhase", 0x00540211,
          "Number of Triggers in Phase", VR.kUS, VM.k1, false);
  static const Tag kViewCodeSequence
      //(0054,0220)
      = const Tag.public("ViewCodeSequence", 0x00540220, "View Code Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kViewModifierCodeSequence
      //(0054,0222)
      = const Tag.public("ViewModifierCodeSequence", 0x00540222,
          "View Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRadionuclideCodeSequence
      //(0054,0300)
      = const Tag.public("RadionuclideCodeSequence", 0x00540300,
          "Radionuclide Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAdministrationRouteCodeSequence
      //(0054,0302)
      = const Tag.public("AdministrationRouteCodeSequence", 0x00540302,
          "Administration Route Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRadiopharmaceuticalCodeSequence
      //(0054,0304)
      = const Tag.public("RadiopharmaceuticalCodeSequence", 0x00540304,
          "Radiopharmaceutical Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCalibrationDataSequence
      //(0054,0306)
      = const Tag.public("CalibrationDataSequence", 0x00540306,
          "Calibration Data Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEnergyWindowNumber
      //(0054,0308)
      = const Tag.public("EnergyWindowNumber", 0x00540308,
          "Energy Window Number", VR.kUS, VM.k1, false);
  static const Tag kImageID
      //(0054,0400)
      =
      const Tag.public("ImageID", 0x00540400, "Image ID", VR.kSH, VM.k1, false);
  static const Tag kPatientOrientationCodeSequence
      //(0054,0410)
      = const Tag.public("PatientOrientationCodeSequence", 0x00540410,
          "Patient Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientOrientationModifierCodeSequence
      //(0054,0412)
      = const Tag.public("PatientOrientationModifierCodeSequence", 0x00540412,
          "Patient Orientation Modifier Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientGantryRelationshipCodeSequence
      //(0054,0414)
      = const Tag.public("PatientGantryRelationshipCodeSequence", 0x00540414,
          "Patient Gantry Relationship Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSliceProgressionDirection
      //(0054,0500)
      = const Tag.public("SliceProgressionDirection", 0x00540500,
          "Slice Progression Direction", VR.kCS, VM.k1, false);
  static const Tag kSeriesType
      //(0054,1000)
      = const Tag.public(
          "SeriesType", 0x00541000, "Series Type", VR.kCS, VM.k2, false);
  static const Tag kUnits
      //(0054,1001)
      = const Tag.public("Units", 0x00541001, "Units", VR.kCS, VM.k1, false);
  static const Tag kCountsSource
      //(0054,1002)
      = const Tag.public(
          "CountsSource", 0x00541002, "Counts Source", VR.kCS, VM.k1, false);
  static const Tag kReprojectionMethod
      //(0054,1004)
      = const Tag.public("ReprojectionMethod", 0x00541004,
          "Reprojection Method", VR.kCS, VM.k1, false);
  static const Tag kSUVType
      //(0054,1006)
      =
      const Tag.public("SUVType", 0x00541006, "SUV Type", VR.kCS, VM.k1, false);
  static const Tag kRandomsCorrectionMethod
      //(0054,1100)
      = const Tag.public("RandomsCorrectionMethod", 0x00541100,
          "Randoms Correction Method", VR.kCS, VM.k1, false);
  static const Tag kAttenuationCorrectionMethod
      //(0054,1101)
      = const Tag.public("AttenuationCorrectionMethod", 0x00541101,
          "Attenuation Correction Method", VR.kLO, VM.k1, false);
  static const Tag kDecayCorrection
      //(0054,1102)
      = const Tag.public("DecayCorrection", 0x00541102, "Decay Correction",
          VR.kCS, VM.k1, false);
  static const Tag kReconstructionMethod
      //(0054,1103)
      = const Tag.public("ReconstructionMethod", 0x00541103,
          "Reconstruction Method", VR.kLO, VM.k1, false);
  static const Tag kDetectorLinesOfResponseUsed
      //(0054,1104)
      = const Tag.public("DetectorLinesOfResponseUsed", 0x00541104,
          "Detector Lines of Response Used", VR.kLO, VM.k1, false);
  static const Tag kScatterCorrectionMethod
      //(0054,1105)
      = const Tag.public("ScatterCorrectionMethod", 0x00541105,
          "Scatter Correction Method", VR.kLO, VM.k1, false);
  static const Tag kAxialAcceptance
      //(0054,1200)
      = const Tag.public("AxialAcceptance", 0x00541200, "Axial Acceptance",
          VR.kDS, VM.k1, false);
  static const Tag kAxialMash
      //(0054,1201)
      = const Tag.public(
          "AxialMash", 0x00541201, "Axial Mash", VR.kIS, VM.k2, false);
  static const Tag kTransverseMash
      //(0054,1202)
      = const Tag.public("TransverseMash", 0x00541202, "Transverse Mash",
          VR.kIS, VM.k1, false);
  static const Tag kDetectorElementSize
      //(0054,1203)
      = const Tag.public("DetectorElementSize", 0x00541203,
          "Detector Element Size", VR.kDS, VM.k2, false);
  static const Tag kCoincidenceWindowWidth
      //(0054,1210)
      = const Tag.public("CoincidenceWindowWidth", 0x00541210,
          "Coincidence Window Width", VR.kDS, VM.k1, false);
  static const Tag kSecondaryCountsType
      //(0054,1220)
      = const Tag.public("SecondaryCountsType", 0x00541220,
          "Secondary Counts Type", VR.kCS, VM.k1_n, false);
  static const Tag kFrameReferenceTime
      //(0054,1300)
      = const Tag.public("FrameReferenceTime", 0x00541300,
          "Frame Reference Time", VR.kDS, VM.k1, false);
  static const Tag kPrimaryPromptsCountsAccumulated
      //(0054,1310)
      = const Tag.public("PrimaryPromptsCountsAccumulated", 0x00541310,
          "Primary (Prompts) Counts Accumulated", VR.kIS, VM.k1, false);
  static const Tag kSecondaryCountsAccumulated
      //(0054,1311)
      = const Tag.public("SecondaryCountsAccumulated", 0x00541311,
          "Secondary Counts Accumulated", VR.kIS, VM.k1_n, false);
  static const Tag kSliceSensitivityFactor
      //(0054,1320)
      = const Tag.public("SliceSensitivityFactor", 0x00541320,
          "Slice Sensitivity Factor", VR.kDS, VM.k1, false);
  static const Tag kDecayFactor
      //(0054,1321)
      = const Tag.public(
          "DecayFactor", 0x00541321, "Decay Factor", VR.kDS, VM.k1, false);
  static const Tag kDoseCalibrationFactor
      //(0054,1322)
      = const Tag.public("DoseCalibrationFactor", 0x00541322,
          "Dose Calibration Factor", VR.kDS, VM.k1, false);
  static const Tag kScatterFractionFactor
      //(0054,1323)
      = const Tag.public("ScatterFractionFactor", 0x00541323,
          "Scatter Fraction Factor", VR.kDS, VM.k1, false);
  static const Tag kDeadTimeFactor
      //(0054,1324)
      = const Tag.public("DeadTimeFactor", 0x00541324, "Dead Time Factor",
          VR.kDS, VM.k1, false);
  static const Tag kImageIndex
      //(0054,1330)
      = const Tag.public(
          "ImageIndex", 0x00541330, "Image Index", VR.kUS, VM.k1, false);
  static const Tag kCountsIncluded
      //(0054,1400)
      = const Tag.public("CountsIncluded", 0x00541400, "Counts Included",
          VR.kCS, VM.k1_n, true);
  static const Tag kDeadTimeCorrectionFlag
      //(0054,1401)
      = const Tag.public("DeadTimeCorrectionFlag", 0x00541401,
          "Dead Time Correction Flag", VR.kCS, VM.k1, true);
  static const Tag kHistogramSequence
      //(0060,3000)
      = const Tag.public("HistogramSequence", 0x00603000, "Histogram Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kHistogramNumberOfBins
      //(0060,3002)
      = const Tag.public("HistogramNumberOfBins", 0x00603002,
          "Histogram Number of Bins", VR.kUS, VM.k1, false);
  static const Tag kHistogramFirstBinValue
      //(0060,3004)
      = const Tag.public("HistogramFirstBinValue", 0x00603004,
          "Histogram First Bin Value", VR.kUSSS, VM.k1, false);
  static const Tag kHistogramLastBinValue
      //(0060,3006)
      = const Tag.public("HistogramLastBinValue", 0x00603006,
          "Histogram Last Bin Value", VR.kUSSS, VM.k1, false);
  static const Tag kHistogramBinWidth
      //(0060,3008)
      = const Tag.public("HistogramBinWidth", 0x00603008, "Histogram Bin Width",
          VR.kUS, VM.k1, false);
  static const Tag kHistogramExplanation
      //(0060,3010)
      = const Tag.public("HistogramExplanation", 0x00603010,
          "Histogram Explanation", VR.kLO, VM.k1, false);
  static const Tag kHistogramData
      //(0060,3020)
      = const Tag.public("HistogramData", 0x00603020, "Histogram Data", VR.kUL,
          VM.k1_n, false);
  static const Tag kSegmentationType
      //(0062,0001)
      = const Tag.public("SegmentationType", 0x00620001, "Segmentation Type",
          VR.kCS, VM.k1, false);
  static const Tag kSegmentSequence
      //(0062,0002)
      = const Tag.public("SegmentSequence", 0x00620002, "Segment Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kSegmentedPropertyCategoryCodeSequence
      //(0062,0003)
      = const Tag.public("SegmentedPropertyCategoryCodeSequence", 0x00620003,
          "Segmented Property Category Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSegmentNumber
      //(0062,0004)
      = const Tag.public(
          "SegmentNumber", 0x00620004, "Segment Number", VR.kUS, VM.k1, false);
  static const Tag kSegmentLabel
      //(0062,0005)
      = const Tag.public(
          "SegmentLabel", 0x00620005, "Segment Label", VR.kLO, VM.k1, false);
  static const Tag kSegmentDescription
      //(0062,0006)
      = const Tag.public("SegmentDescription", 0x00620006,
          "Segment Description", VR.kST, VM.k1, false);
  static const Tag kSegmentAlgorithmType
      //(0062,0008)
      = const Tag.public("SegmentAlgorithmType", 0x00620008,
          "Segment Algorithm Type", VR.kCS, VM.k1, false);
  static const Tag kSegmentAlgorithmName
      //(0062,0009)
      = const Tag.public("SegmentAlgorithmName", 0x00620009,
          "Segment Algorithm Name", VR.kLO, VM.k1, false);
  static const Tag kSegmentIdentificationSequence
      //(0062,000A)
      = const Tag.public("SegmentIdentificationSequence", 0x0062000A,
          "Segment Identification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSegmentNumber
      //(0062,000B)
      = const Tag.public("ReferencedSegmentNumber", 0x0062000B,
          "Referenced Segment Number", VR.kUS, VM.k1_n, false);
  static const Tag kRecommendedDisplayGrayscaleValue
      //(0062,000C)
      = const Tag.public("RecommendedDisplayGrayscaleValue", 0x0062000C,
          "Recommended Display Grayscale Value", VR.kUS, VM.k1, false);
  static const Tag kRecommendedDisplayCIELabValue
      //(0062,000D)
      = const Tag.public("RecommendedDisplayCIELabValue", 0x0062000D,
          "Recommended Display CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kMaximumFractionalValue
      //(0062,000E)
      = const Tag.public("MaximumFractionalValue", 0x0062000E,
          "Maximum Fractional Value", VR.kUS, VM.k1, false);
  static const Tag kSegmentedPropertyTypeCodeSequence
      //(0062,000F)
      = const Tag.public("SegmentedPropertyTypeCodeSequence", 0x0062000F,
          "Segmented Property Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSegmentationFractionalType
      //(0062,0010)
      = const Tag.public("SegmentationFractionalType", 0x00620010,
          "Segmentation Fractional Type", VR.kCS, VM.k1, false);
  static const Tag kSegmentedPropertyTypeModifierCodeSequence
      //(0062,0011)
      = const Tag.public(
          "SegmentedPropertyTypeModifierCodeSequence",
          0x00620011,
          "Segmented Property Type Modifier Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kUsedSegmentsSequence
      //(0062,0012)
      = const Tag.public("UsedSegmentsSequence", 0x00620012,
          "Used Segments Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDeformableRegistrationSequence
      //(0064,0002)
      = const Tag.public("DeformableRegistrationSequence", 0x00640002,
          "Deformable Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceFrameOfReferenceUID
      //(0064,0003)
      = const Tag.public("SourceFrameOfReferenceUID", 0x00640003,
          "Source Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kDeformableRegistrationGridSequence
      //(0064,0005)
      = const Tag.public("DeformableRegistrationGridSequence", 0x00640005,
          "Deformable Registration Grid Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGridDimensions
      //(0064,0007)
      = const Tag.public("GridDimensions", 0x00640007, "Grid Dimensions",
          VR.kUL, VM.k3, false);
  static const Tag kGridResolution
      //(0064,0008)
      = const Tag.public("GridResolution", 0x00640008, "Grid Resolution",
          VR.kFD, VM.k3, false);
  static const Tag kVectorGridData
      //(0064,0009)
      = const Tag.public("VectorGridData", 0x00640009, "Vector Grid Data",
          VR.kOF, VM.k1, false);
  static const Tag kPreDeformationMatrixRegistrationSequence
      //(0064,000F)
      = const Tag.public("PreDeformationMatrixRegistrationSequence", 0x0064000F,
          "Pre Deformation Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPostDeformationMatrixRegistrationSequence
      //(0064,0010)
      = const Tag.public(
          "PostDeformationMatrixRegistrationSequence",
          0x00640010,
          "Post Deformation Matrix Registration Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kNumberOfSurfaces
      //(0066,0001)
      = const Tag.public("NumberOfSurfaces", 0x00660001, "Number of Surfaces",
          VR.kUL, VM.k1, false);
  static const Tag kSurfaceSequence
      //(0066,0002)
      = const Tag.public("SurfaceSequence", 0x00660002, "Surface Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kSurfaceNumber
      //(0066,0003)
      = const Tag.public(
          "SurfaceNumber", 0x00660003, "Surface Number", VR.kUL, VM.k1, false);
  static const Tag kSurfaceComments
      //(0066,0004)
      = const Tag.public("SurfaceComments", 0x00660004, "Surface Comments",
          VR.kLT, VM.k1, false);
  static const Tag kSurfaceProcessing
      //(0066,0009)
      = const Tag.public("SurfaceProcessing", 0x00660009, "Surface Processing",
          VR.kCS, VM.k1, false);
  static const Tag kSurfaceProcessingRatio
      //(0066,000A)
      = const Tag.public("SurfaceProcessingRatio", 0x0066000A,
          "Surface Processing Ratio", VR.kFL, VM.k1, false);
  static const Tag kSurfaceProcessingDescription
      //(0066,000B)
      = const Tag.public("SurfaceProcessingDescription", 0x0066000B,
          "Surface Processing Description", VR.kLO, VM.k1, false);
  static const Tag kRecommendedPresentationOpacity
      //(0066,000C)
      = const Tag.public("RecommendedPresentationOpacity", 0x0066000C,
          "Recommended Presentation Opacity", VR.kFL, VM.k1, false);
  static const Tag kRecommendedPresentationType
      //(0066,000D)
      = const Tag.public("RecommendedPresentationType", 0x0066000D,
          "Recommended Presentation Type", VR.kCS, VM.k1, false);
  static const Tag kFiniteVolume
      //(0066,000E)
      = const Tag.public(
          "FiniteVolume", 0x0066000E, "Finite Volume", VR.kCS, VM.k1, false);
  static const Tag kManifold
      //(0066,0010)
      = const Tag.public(
          "Manifold", 0x00660010, "Manifold", VR.kCS, VM.k1, false);
  static const Tag kSurfacePointsSequence
      //(0066,0011)
      = const Tag.public("SurfacePointsSequence", 0x00660011,
          "Surface Points Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurfacePointsNormalsSequence
      //(0066,0012)
      = const Tag.public("SurfacePointsNormalsSequence", 0x00660012,
          "Surface Points Normals Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurfaceMeshPrimitivesSequence
      //(0066,0013)
      = const Tag.public("SurfaceMeshPrimitivesSequence", 0x00660013,
          "Surface Mesh Primitives Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfSurfacePoints
      //(0066,0015)
      = const Tag.public("NumberOfSurfacePoints", 0x00660015,
          "Number of Surface Points", VR.kUL, VM.k1, false);
  static const Tag kPointCoordinatesData
      //(0066,0016)
      = const Tag.public("PointCoordinatesData", 0x00660016,
          "Point Coordinates Data", VR.kOF, VM.k1, false);
  static const Tag kPointPositionAccuracy
      //(0066,0017)
      = const Tag.public("PointPositionAccuracy", 0x00660017,
          "Point Position Accuracy", VR.kFL, VM.k3, false);
  static const Tag kMeanPointDistance
      //(0066,0018)
      = const Tag.public("MeanPointDistance", 0x00660018, "Mean Point Distance",
          VR.kFL, VM.k1, false);
  static const Tag kMaximumPointDistance
      //(0066,0019)
      = const Tag.public("MaximumPointDistance", 0x00660019,
          "Maximum Point Distance", VR.kFL, VM.k1, false);
  static const Tag kPointsBoundingBoxCoordinates
      //(0066,001A)
      = const Tag.public("PointsBoundingBoxCoordinates", 0x0066001A,
          "Points Bounding Box Coordinates", VR.kFL, VM.k6, false);
  static const Tag kAxisOfRotation
      //(0066,001B)
      = const Tag.public("AxisOfRotation", 0x0066001B, "Axis of Rotation",
          VR.kFL, VM.k3, false);
  static const Tag kCenterOfRotation
      //(0066,001C)
      = const Tag.public("CenterOfRotation", 0x0066001C, "Center of Rotation",
          VR.kFL, VM.k3, false);
  static const Tag kNumberOfVectors
      //(0066,001E)
      = const Tag.public("NumberOfVectors", 0x0066001E, "Number of Vectors",
          VR.kUL, VM.k1, false);
  static const Tag kVectorDimensionality
      //(0066,001F)
      = const Tag.public("VectorDimensionality", 0x0066001F,
          "Vector Dimensionality", VR.kUS, VM.k1, false);
  static const Tag kVectorAccuracy
      //(0066,0020)
      = const Tag.public("VectorAccuracy", 0x00660020, "Vector Accuracy",
          VR.kFL, VM.k1_n, false);
  static const Tag kVectorCoordinateData
      //(0066,0021)
      = const Tag.public("VectorCoordinateData", 0x00660021,
          "Vector Coordinate Data", VR.kOF, VM.k1, false);
  static const Tag kTrianglePointIndexList
      //(0066,0023)
      = const Tag.public("TrianglePointIndexList", 0x00660023,
          "Triangle Point Index List", VR.kOW, VM.k1, false);
  static const Tag kEdgePointIndexList
      //(0066,0024)
      = const Tag.public("EdgePointIndexList", 0x00660024,
          "Edge Point Index List", VR.kOW, VM.k1, false);
  static const Tag kVertexPointIndexList
      //(0066,0025)
      = const Tag.public("VertexPointIndexList", 0x00660025,
          "Vertex Point Index List", VR.kOW, VM.k1, false);
  static const Tag kTriangleStripSequence
      //(0066,0026)
      = const Tag.public("TriangleStripSequence", 0x00660026,
          "Triangle Strip Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTriangleFanSequence
      //(0066,0027)
      = const Tag.public("TriangleFanSequence", 0x00660027,
          "Triangle Fan Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLineSequence
      //(0066,0028)
      = const Tag.public(
          "LineSequence", 0x00660028, "Line Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrimitivePointIndexList
      //(0066,0029)
      = const Tag.public("PrimitivePointIndexList", 0x00660029,
          "Primitive Point Index List", VR.kOW, VM.k1, false);
  static const Tag kSurfaceCount
      //(0066,002A)
      = const Tag.public(
          "SurfaceCount", 0x0066002A, "Surface Count", VR.kUL, VM.k1, false);
  static const Tag kReferencedSurfaceSequence
      //(0066,002B)
      = const Tag.public("ReferencedSurfaceSequence", 0x0066002B,
          "Referenced Surface Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSurfaceNumber
      //(0066,002C)
      = const Tag.public("ReferencedSurfaceNumber", 0x0066002C,
          "Referenced Surface Number", VR.kUL, VM.k1, false);
  static const Tag kSegmentSurfaceGenerationAlgorithmIdentificationSequence
      //(0066,002D)
      = const Tag.public(
          "SegmentSurfaceGenerationAlgorithmIdentificationSequence",
          0x0066002D,
          "Segment Surface Generation Algorithm Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kSegmentSurfaceSourceInstanceSequence
      //(0066,002E)
      = const Tag.public("SegmentSurfaceSourceInstanceSequence", 0x0066002E,
          "Segment Surface Source Instance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAlgorithmFamilyCodeSequence
      //(0066,002F)
      = const Tag.public("AlgorithmFamilyCodeSequence", 0x0066002F,
          "Algorithm Family Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAlgorithmNameCodeSequence
      //(0066,0030)
      = const Tag.public("AlgorithmNameCodeSequence", 0x00660030,
          "Algorithm Name Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAlgorithmVersion
      //(0066,0031)
      = const Tag.public("AlgorithmVersion", 0x00660031, "Algorithm Version",
          VR.kLO, VM.k1, false);
  static const Tag kAlgorithmParameters
      //(0066,0032)
      = const Tag.public("AlgorithmParameters", 0x00660032,
          "Algorithm Parameters", VR.kLT, VM.k1, false);
  static const Tag kFacetSequence
      //(0066,0034)
      = const Tag.public(
          "FacetSequence", 0x00660034, "Facet Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurfaceProcessingAlgorithmIdentificationSequence
      //(0066,0035)
      = const Tag.public(
          "SurfaceProcessingAlgorithmIdentificationSequence",
          0x00660035,
          "Surface Processing Algorithm Identification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kAlgorithmName
      //(0066,0036)
      = const Tag.public(
          "AlgorithmName", 0x00660036, "Algorithm Name", VR.kLO, VM.k1, false);
  static const Tag kRecommendedPointRadius
      //(0066,0037)
      = const Tag.public("RecommendedPointRadius", 0x00660037,
          "Recommended Point Radius", VR.kFL, VM.k1, false);
  static const Tag kRecommendedLineThickness
      //(0066,0038)
      = const Tag.public("RecommendedLineThickness", 0x00660038,
          "Recommended Line Thickness", VR.kFL, VM.k1, false);
  static const Tag kImplantSize
      //(0068,6210)
      = const Tag.public(
          "ImplantSize", 0x00686210, "Implant Size", VR.kLO, VM.k1, false);
  static const Tag kImplantTemplateVersion
      //(0068,6221)
      = const Tag.public("ImplantTemplateVersion", 0x00686221,
          "Implant Template Version", VR.kLO, VM.k1, false);
  static const Tag kReplacedImplantTemplateSequence
      //(0068,6222)
      = const Tag.public("ReplacedImplantTemplateSequence", 0x00686222,
          "Replaced Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantType
      //(0068,6223)
      = const Tag.public(
          "ImplantType", 0x00686223, "Implant Type", VR.kCS, VM.k1, false);
  static const Tag kDerivationImplantTemplateSequence
      //(0068,6224)
      = const Tag.public("DerivationImplantTemplateSequence", 0x00686224,
          "Derivation Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOriginalImplantTemplateSequence
      //(0068,6225)
      = const Tag.public("OriginalImplantTemplateSequence", 0x00686225,
          "Original Implant Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEffectiveDateTime
      //(0068,6226)
      = const Tag.public("EffectiveDateTime", 0x00686226, "Effective DateTime",
          VR.kDT, VM.k1, false);
  static const Tag kImplantTargetAnatomySequence
      //(0068,6230)
      = const Tag.public("ImplantTargetAnatomySequence", 0x00686230,
          "Implant Target Anatomy Sequence", VR.kSQ, VM.k1, false);
  static const Tag kInformationFromManufacturerSequence
      //(0068,6260)
      = const Tag.public("InformationFromManufacturerSequence", 0x00686260,
          "Information From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNotificationFromManufacturerSequence
      //(0068,6265)
      = const Tag.public("NotificationFromManufacturerSequence", 0x00686265,
          "Notification From Manufacturer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kInformationIssueDateTime
      //(0068,6270)
      = const Tag.public("InformationIssueDateTime", 0x00686270,
          "Information Issue DateTime", VR.kDT, VM.k1, false);
  static const Tag kInformationSummary
      //(0068,6280)
      = const Tag.public("InformationSummary", 0x00686280,
          "Information Summary", VR.kST, VM.k1, false);
  static const Tag kImplantRegulatoryDisapprovalCodeSequence
      //(0068,62A0)
      = const Tag.public("ImplantRegulatoryDisapprovalCodeSequence", 0x006862A0,
          "Implant Regulatory Disapproval Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOverallTemplateSpatialTolerance
      //(0068,62A5)
      = const Tag.public("OverallTemplateSpatialTolerance", 0x006862A5,
          "Overall Template Spatial Tolerance", VR.kFD, VM.k1, false);
  static const Tag kHPGLDocumentSequence
      //(0068,62C0)
      = const Tag.public("HPGLDocumentSequence", 0x006862C0,
          "HPGL Document Sequence", VR.kSQ, VM.k1, false);
  static const Tag kHPGLDocumentID
      //(0068,62D0)
      = const Tag.public("HPGLDocumentID", 0x006862D0, "HPGL Document ID",
          VR.kUS, VM.k1, false);
  static const Tag kHPGLDocumentLabel
      //(0068,62D5)
      = const Tag.public("HPGLDocumentLabel", 0x006862D5, "HPGL Document Label",
          VR.kLO, VM.k1, false);
  static const Tag kViewOrientationCodeSequence
      //(0068,62E0)
      = const Tag.public("ViewOrientationCodeSequence", 0x006862E0,
          "View Orientation Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kViewOrientationModifier
      //(0068,62F0)
      = const Tag.public("ViewOrientationModifier", 0x006862F0,
          "View Orientation Modifier", VR.kFD, VM.k9, false);
  static const Tag kHPGLDocumentScaling
      //(0068,62F2)
      = const Tag.public("HPGLDocumentScaling", 0x006862F2,
          "HPGL Document Scaling", VR.kFD, VM.k1, false);
  static const Tag kHPGLDocument
      //(0068,6300)
      = const Tag.public(
          "HPGLDocument", 0x00686300, "HPGL Document", VR.kOB, VM.k1, false);
  static const Tag kHPGLContourPenNumber
      //(0068,6310)
      = const Tag.public("HPGLContourPenNumber", 0x00686310,
          "HPGL Contour Pen Number", VR.kUS, VM.k1, false);
  static const Tag kHPGLPenSequence
      //(0068,6320)
      = const Tag.public("HPGLPenSequence", 0x00686320, "HPGL Pen Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kHPGLPenNumber
      //(0068,6330)
      = const Tag.public(
          "HPGLPenNumber", 0x00686330, "HPGL Pen Number", VR.kUS, VM.k1, false);
  static const Tag kHPGLPenLabel
      //(0068,6340)
      = const Tag.public(
          "HPGLPenLabel", 0x00686340, "HPGL Pen Label", VR.kLO, VM.k1, false);
  static const Tag kHPGLPenDescription
      //(0068,6345)
      = const Tag.public("HPGLPenDescription", 0x00686345,
          "HPGL Pen Description", VR.kST, VM.k1, false);
  static const Tag kRecommendedRotationPoint
      //(0068,6346)
      = const Tag.public("RecommendedRotationPoint", 0x00686346,
          "Recommended Rotation Point", VR.kFD, VM.k2, false);
  static const Tag kBoundingRectangle
      //(0068,6347)
      = const Tag.public("BoundingRectangle", 0x00686347, "Bounding Rectangle",
          VR.kFD, VM.k4, false);
  static const Tag kImplantTemplate3DModelSurfaceNumber
      //(0068,6350)
      = const Tag.public("ImplantTemplate3DModelSurfaceNumber", 0x00686350,
          "Implant Template 3D Model Surface Number", VR.kUS, VM.k1_n, false);
  static const Tag kSurfaceModelDescriptionSequence
      //(0068,6360)
      = const Tag.public("SurfaceModelDescriptionSequence", 0x00686360,
          "Surface Model Description Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurfaceModelLabel
      //(0068,6380)
      = const Tag.public("SurfaceModelLabel", 0x00686380, "Surface Model Label",
          VR.kLO, VM.k1, false);
  static const Tag kSurfaceModelScalingFactor
      //(0068,6390)
      = const Tag.public("SurfaceModelScalingFactor", 0x00686390,
          "Surface Model Scaling Factor", VR.kFD, VM.k1, false);
  static const Tag kMaterialsCodeSequence
      //(0068,63A0)
      = const Tag.public("MaterialsCodeSequence", 0x006863A0,
          "Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCoatingMaterialsCodeSequence
      //(0068,63A4)
      = const Tag.public("CoatingMaterialsCodeSequence", 0x006863A4,
          "Coating Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantTypeCodeSequence
      //(0068,63A8)
      = const Tag.public("ImplantTypeCodeSequence", 0x006863A8,
          "Implant Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFixationMethodCodeSequence
      //(0068,63AC)
      = const Tag.public("FixationMethodCodeSequence", 0x006863AC,
          "Fixation Method Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMatingFeatureSetsSequence
      //(0068,63B0)
      = const Tag.public("MatingFeatureSetsSequence", 0x006863B0,
          "Mating Feature Sets Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMatingFeatureSetID
      //(0068,63C0)
      = const Tag.public("MatingFeatureSetID", 0x006863C0,
          "Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const Tag kMatingFeatureSetLabel
      //(0068,63D0)
      = const Tag.public("MatingFeatureSetLabel", 0x006863D0,
          "Mating Feature Set Label", VR.kLO, VM.k1, false);
  static const Tag kMatingFeatureSequence
      //(0068,63E0)
      = const Tag.public("MatingFeatureSequence", 0x006863E0,
          "Mating Feature Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMatingFeatureID
      //(0068,63F0)
      = const Tag.public("MatingFeatureID", 0x006863F0, "Mating Feature ID",
          VR.kUS, VM.k1, false);
  static const Tag kMatingFeatureDegreeOfFreedomSequence
      //(0068,6400)
      = const Tag.public("MatingFeatureDegreeOfFreedomSequence", 0x00686400,
          "Mating Feature Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDegreeOfFreedomID
      //(0068,6410)
      = const Tag.public("DegreeOfFreedomID", 0x00686410,
          "Degree of Freedom ID", VR.kUS, VM.k1, false);
  static const Tag kDegreeOfFreedomType
      //(0068,6420)
      = const Tag.public("DegreeOfFreedomType", 0x00686420,
          "Degree of Freedom Type", VR.kCS, VM.k1, false);
  static const Tag kTwoDMatingFeatureCoordinatesSequence
      //(0068,6430)
      = const Tag.public("TwoDMatingFeatureCoordinatesSequence", 0x00686430,
          "2D Mating Feature Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedHPGLDocumentID
      //(0068,6440)
      = const Tag.public("ReferencedHPGLDocumentID", 0x00686440,
          "Referenced HPGL Document ID", VR.kUS, VM.k1, false);
  static const Tag kTwoDMatingPoint
      //(0068,6450)
      = const Tag.public("TwoDMatingPoint", 0x00686450, "2D Mating Point",
          VR.kFD, VM.k2, false);
  static const Tag kTwoDMatingAxes
      //(0068,6460)
      = const Tag.public(
          "TwoDMatingAxes", 0x00686460, "2D Mating Axes", VR.kFD, VM.k4, false);
  static const Tag kTwoDDegreeOfFreedomSequence
      //(0068,6470)
      = const Tag.public("TwoDDegreeOfFreedomSequence", 0x00686470,
          "2D Degree of Freedom Sequence", VR.kSQ, VM.k1, false);
  static const Tag kThreeDDegreeOfFreedomAxis
      //(0068,6490)
      = const Tag.public("ThreeDDegreeOfFreedomAxis", 0x00686490,
          "3D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const Tag kRangeOfFreedom
      //(0068,64A0)
      = const Tag.public("RangeOfFreedom", 0x006864A0, "Range of Freedom",
          VR.kFD, VM.k2, false);
  static const Tag kThreeDMatingPoint
      //(0068,64C0)
      = const Tag.public("ThreeDMatingPoint", 0x006864C0, "3D Mating Point",
          VR.kFD, VM.k3, false);
  static const Tag kThreeDMatingAxes
      //(0068,64D0)
      = const Tag.public("ThreeDMatingAxes", 0x006864D0, "3D Mating Axes",
          VR.kFD, VM.k9, false);
  static const Tag kTwoDDegreeOfFreedomAxis
      //(0068,64F0)
      = const Tag.public("TwoDDegreeOfFreedomAxis", 0x006864F0,
          "2D Degree of Freedom Axis", VR.kFD, VM.k3, false);
  static const Tag kPlanningLandmarkPointSequence
      //(0068,6500)
      = const Tag.public("PlanningLandmarkPointSequence", 0x00686500,
          "Planning Landmark Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanningLandmarkLineSequence
      //(0068,6510)
      = const Tag.public("PlanningLandmarkLineSequence", 0x00686510,
          "Planning Landmark Line Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanningLandmarkPlaneSequence
      //(0068,6520)
      = const Tag.public("PlanningLandmarkPlaneSequence", 0x00686520,
          "Planning Landmark Plane Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPlanningLandmarkID
      //(0068,6530)
      = const Tag.public("PlanningLandmarkID", 0x00686530,
          "Planning Landmark ID", VR.kUS, VM.k1, false);
  static const Tag kPlanningLandmarkDescription
      //(0068,6540)
      = const Tag.public("PlanningLandmarkDescription", 0x00686540,
          "Planning Landmark Description", VR.kLO, VM.k1, false);
  static const Tag kPlanningLandmarkIdentificationCodeSequence
      //(0068,6545)
      = const Tag.public(
          "PlanningLandmarkIdentificationCodeSequence",
          0x00686545,
          "Planning Landmark Identification Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kTwoDPointCoordinatesSequence
      //(0068,6550)
      = const Tag.public("TwoDPointCoordinatesSequence", 0x00686550,
          "2D Point Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTwoDPointCoordinates
      //(0068,6560)
      = const Tag.public("TwoDPointCoordinates", 0x00686560,
          "2D Point Coordinates", VR.kFD, VM.k2, false);
  static const Tag kThreeDPointCoordinates
      //(0068,6590)
      = const Tag.public("ThreeDPointCoordinates", 0x00686590,
          "3D Point Coordinates", VR.kFD, VM.k3, false);
  static const Tag kTwoDLineCoordinatesSequence
      //(0068,65A0)
      = const Tag.public("TwoDLineCoordinatesSequence", 0x006865A0,
          "2D Line Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTwoDLineCoordinates
      //(0068,65B0)
      = const Tag.public("TwoDLineCoordinates", 0x006865B0,
          "2D Line Coordinates", VR.kFD, VM.k4, false);
  static const Tag kThreeDLineCoordinates
      //(0068,65D0)
      = const Tag.public("ThreeDLineCoordinates", 0x006865D0,
          "3D Line Coordinates", VR.kFD, VM.k6, false);
  static const Tag kTwoDPlaneCoordinatesSequence
      //(0068,65E0)
      = const Tag.public("TwoDPlaneCoordinatesSequence", 0x006865E0,
          "2D Plane Coordinates Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTwoDPlaneIntersection
      //(0068,65F0)
      = const Tag.public("TwoDPlaneIntersection", 0x006865F0,
          "2D Plane Intersection", VR.kFD, VM.k4, false);
  static const Tag kThreeDPlaneOrigin
      //(0068,6610)
      = const Tag.public("ThreeDPlaneOrigin", 0x00686610, "3D Plane Origin",
          VR.kFD, VM.k3, false);
  static const Tag kThreeDPlaneNormal
      //(0068,6620)
      = const Tag.public("ThreeDPlaneNormal", 0x00686620, "3D Plane Normal",
          VR.kFD, VM.k3, false);
  static const Tag kGraphicAnnotationSequence
      //(0070,0001)
      = const Tag.public("GraphicAnnotationSequence", 0x00700001,
          "Graphic Annotation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGraphicLayer
      //(0070,0002)
      = const Tag.public(
          "GraphicLayer", 0x00700002, "Graphic Layer", VR.kCS, VM.k1, false);
  static const Tag kBoundingBoxAnnotationUnits
      //(0070,0003)
      = const Tag.public("BoundingBoxAnnotationUnits", 0x00700003,
          "Bounding Box Annotation Units", VR.kCS, VM.k1, false);
  static const Tag kAnchorPointAnnotationUnits
      //(0070,0004)
      = const Tag.public("AnchorPointAnnotationUnits", 0x00700004,
          "Anchor Point Annotation Units", VR.kCS, VM.k1, false);
  static const Tag kGraphicAnnotationUnits
      //(0070,0005)
      = const Tag.public("GraphicAnnotationUnits", 0x00700005,
          "Graphic Annotation Units", VR.kCS, VM.k1, false);
  static const Tag kUnformattedTextValue
      //(0070,0006)
      = const Tag.public("UnformattedTextValue", 0x00700006,
          "Unformatted Text Value", VR.kST, VM.k1, false);
  static const Tag kTextObjectSequence
      //(0070,0008)
      = const Tag.public("TextObjectSequence", 0x00700008,
          "Text Object Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGraphicObjectSequence
      //(0070,0009)
      = const Tag.public("GraphicObjectSequence", 0x00700009,
          "Graphic Object Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBoundingBoxTopLeftHandCorner
      //(0070,0010)
      = const Tag.public("BoundingBoxTopLeftHandCorner", 0x00700010,
          "Bounding Box Top Left Hand Corner", VR.kFL, VM.k2, false);
  static const Tag kBoundingBoxBottomRightHandCorner
      //(0070,0011)
      = const Tag.public("BoundingBoxBottomRightHandCorner", 0x00700011,
          "Bounding Box Bottom Right Hand Corner", VR.kFL, VM.k2, false);
  static const Tag kBoundingBoxTextHorizontalJustification
      //(0070,0012)
      = const Tag.public("BoundingBoxTextHorizontalJustification", 0x00700012,
          "Bounding Box Text Horizontal Justification", VR.kCS, VM.k1, false);
  static const Tag kAnchorPoint
      //(0070,0014)
      = const Tag.public(
          "AnchorPoint", 0x00700014, "Anchor Point", VR.kFL, VM.k2, false);
  static const Tag kAnchorPointVisibility
      //(0070,0015)
      = const Tag.public("AnchorPointVisibility", 0x00700015,
          "Anchor Point Visibility", VR.kCS, VM.k1, false);
  static const Tag kGraphicDimensions
      //(0070,0020)
      = const Tag.public("GraphicDimensions", 0x00700020, "Graphic Dimensions",
          VR.kUS, VM.k1, false);
  static const Tag kNumberOfGraphicPoints
      //(0070,0021)
      = const Tag.public("NumberOfGraphicPoints", 0x00700021,
          "Number of Graphic Points", VR.kUS, VM.k1, false);
  static const Tag kGraphicData
      //(0070,0022)
      = const Tag.public(
          "GraphicData", 0x00700022, "Graphic Data", VR.kFL, VM.k2_n, false);
  static const Tag kGraphicType
      //(0070,0023)
      = const Tag.public(
          "GraphicType", 0x00700023, "Graphic Type", VR.kCS, VM.k1, false);
  static const Tag kGraphicFilled
      //(0070,0024)
      = const Tag.public(
          "GraphicFilled", 0x00700024, "Graphic Filled", VR.kCS, VM.k1, false);
  static const Tag kImageRotationRetired
      //(0070,0040)
      = const Tag.public("ImageRotationRetired", 0x00700040,
          "Image Rotation (Retired)", VR.kIS, VM.k1, true);
  static const Tag kImageHorizontalFlip
      //(0070,0041)
      = const Tag.public("ImageHorizontalFlip", 0x00700041,
          "Image Horizontal Flip", VR.kCS, VM.k1, false);
  static const Tag kImageRotation
      //(0070,0042)
      = const Tag.public(
          "ImageRotation", 0x00700042, "Image Rotation", VR.kUS, VM.k1, false);
  static const Tag kDisplayedAreaTopLeftHandCornerTrial
      //(0070,0050)
      = const Tag.public("DisplayedAreaTopLeftHandCornerTrial", 0x00700050,
          "Displayed Area Top Left Hand Corner (Trial)", VR.kUS, VM.k2, true);
  static const Tag kDisplayedAreaBottomRightHandCornerTrial
      //(0070,0051)
      = const Tag.public(
          "DisplayedAreaBottomRightHandCornerTrial",
          0x00700051,
          "Displayed Area Bottom Right Hand Corner (Trial)",
          VR.kUS,
          VM.k2,
          true);
  static const Tag kDisplayedAreaTopLeftHandCorner
      //(0070,0052)
      = const Tag.public("DisplayedAreaTopLeftHandCorner", 0x00700052,
          "Displayed Area Top Left Hand Corner", VR.kSL, VM.k2, false);
  static const Tag kDisplayedAreaBottomRightHandCorner
      //(0070,0053)
      = const Tag.public("DisplayedAreaBottomRightHandCorner", 0x00700053,
          "Displayed Area Bottom Right Hand Corner", VR.kSL, VM.k2, false);
  static const Tag kDisplayedAreaSelectionSequence
      //(0070,005A)
      = const Tag.public("DisplayedAreaSelectionSequence", 0x0070005A,
          "Displayed Area Selection Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGraphicLayerSequence
      //(0070,0060)
      = const Tag.public("GraphicLayerSequence", 0x00700060,
          "Graphic Layer Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGraphicLayerOrder
      //(0070,0062)
      = const Tag.public("GraphicLayerOrder", 0x00700062, "Graphic Layer Order",
          VR.kIS, VM.k1, false);
  static const Tag kGraphicLayerRecommendedDisplayGrayscaleValue
      //(0070,0066)
      = const Tag.public(
          "GraphicLayerRecommendedDisplayGrayscaleValue",
          0x00700066,
          "Graphic Layer Recommended Display Grayscale Value",
          VR.kUS,
          VM.k1,
          false);
  static const Tag kGraphicLayerRecommendedDisplayRGBValue
      //(0070,0067)
      = const Tag.public("GraphicLayerRecommendedDisplayRGBValue", 0x00700067,
          "Graphic Layer Recommended Display RGB Value", VR.kUS, VM.k3, true);
  static const Tag kGraphicLayerDescription
      //(0070,0068)
      = const Tag.public("GraphicLayerDescription", 0x00700068,
          "Graphic Layer Description", VR.kLO, VM.k1, false);
  static const Tag kContentLabel
      //(0070,0080)
      = const Tag.public(
          "ContentLabel", 0x00700080, "Content Label", VR.kCS, VM.k1, false);
  static const Tag kContentDescription
      //(0070,0081)
      = const Tag.public("ContentDescription", 0x00700081,
          "Content Description", VR.kLO, VM.k1, false);
  static const Tag kPresentationCreationDate
      //(0070,0082)
      = const Tag.public("PresentationCreationDate", 0x00700082,
          "Presentation Creation Date", VR.kDA, VM.k1, false);
  static const Tag kPresentationCreationTime
      //(0070,0083)
      = const Tag.public("PresentationCreationTime", 0x00700083,
          "Presentation Creation Time", VR.kTM, VM.k1, false);
  static const Tag kContentCreatorName
      //(0070,0084)
      = const Tag.public("ContentCreatorName", 0x00700084,
          "Content Creator's Name", VR.kPN, VM.k1, false);
  static const Tag kContentCreatorIdentificationCodeSequence
      //(0070,0086)
      = const Tag.public(
          "ContentCreatorIdentificationCodeSequence",
          0x00700086,
          "Content Creator's Identification Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kAlternateContentDescriptionSequence
      //(0070,0087)
      = const Tag.public("AlternateContentDescriptionSequence", 0x00700087,
          "Alternate Content Description Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPresentationSizeMode
      //(0070,0100)
      = const Tag.public("PresentationSizeMode", 0x00700100,
          "Presentation Size Mode", VR.kCS, VM.k1, false);
  static const Tag kPresentationPixelSpacing
      //(0070,0101)
      = const Tag.public("PresentationPixelSpacing", 0x00700101,
          "Presentation Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kPresentationPixelAspectRatio
      //(0070,0102)
      = const Tag.public("PresentationPixelAspectRatio", 0x00700102,
          "Presentation Pixel Aspect Ratio", VR.kIS, VM.k2, false);
  static const Tag kPresentationPixelMagnificationRatio
      //(0070,0103)
      = const Tag.public("PresentationPixelMagnificationRatio", 0x00700103,
          "Presentation Pixel Magnification Ratio", VR.kFL, VM.k1, false);
  static const Tag kGraphicGroupLabel
      //(0070,0207)
      = const Tag.public("GraphicGroupLabel", 0x00700207, "Graphic Group Label",
          VR.kLO, VM.k1, false);
  static const Tag kGraphicGroupDescription
      //(0070,0208)
      = const Tag.public("GraphicGroupDescription", 0x00700208,
          "Graphic Group Description", VR.kST, VM.k1, false);
  static const Tag kCompoundGraphicSequence
      //(0070,0209)
      = const Tag.public("CompoundGraphicSequence", 0x00700209,
          "Compound Graphic Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCompoundGraphicInstanceID
      //(0070,0226)
      = const Tag.public("CompoundGraphicInstanceID", 0x00700226,
          "Compound Graphic Instance ID", VR.kUL, VM.k1, false);
  static const Tag kFontName
      //(0070,0227)
      = const Tag.public(
          "FontName", 0x00700227, "Font Name", VR.kLO, VM.k1, false);
  static const Tag kFontNameType
      //(0070,0228)
      = const Tag.public(
          "FontNameType", 0x00700228, "Font Name Type", VR.kCS, VM.k1, false);
  static const Tag kCSSFontName
      //(0070,0229)
      = const Tag.public(
          "CSSFontName", 0x00700229, "CSS Font Name", VR.kLO, VM.k1, false);
  static const Tag kRotationAngle
      //(0070,0230)
      = const Tag.public(
          "RotationAngle", 0x00700230, "Rotation Angle", VR.kFD, VM.k1, false);
  static const Tag kTextStyleSequence
      //(0070,0231)
      = const Tag.public("TextStyleSequence", 0x00700231, "Text Style Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kLineStyleSequence
      //(0070,0232)
      = const Tag.public("LineStyleSequence", 0x00700232, "Line Style Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kFillStyleSequence
      //(0070,0233)
      = const Tag.public("FillStyleSequence", 0x00700233, "Fill Style Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kGraphicGroupSequence
      //(0070,0234)
      = const Tag.public("GraphicGroupSequence", 0x00700234,
          "Graphic Group Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTextColorCIELabValue
      //(0070,0241)
      = const Tag.public("TextColorCIELabValue", 0x00700241,
          "Text Color CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kHorizontalAlignment
      //(0070,0242)
      = const Tag.public("HorizontalAlignment", 0x00700242,
          "Horizontal Alignment", VR.kCS, VM.k1, false);
  static const Tag kVerticalAlignment
      //(0070,0243)
      = const Tag.public("VerticalAlignment", 0x00700243, "Vertical Alignment",
          VR.kCS, VM.k1, false);
  static const Tag kShadowStyle
      //(0070,0244)
      = const Tag.public(
          "ShadowStyle", 0x00700244, "Shadow Style", VR.kCS, VM.k1, false);
  static const Tag kShadowOffsetX
      //(0070,0245)
      = const Tag.public(
          "ShadowOffsetX", 0x00700245, "Shadow Offset X", VR.kFL, VM.k1, false);
  static const Tag kShadowOffsetY
      //(0070,0246)
      = const Tag.public(
          "ShadowOffsetY", 0x00700246, "Shadow Offset Y", VR.kFL, VM.k1, false);
  static const Tag kShadowColorCIELabValue
      //(0070,0247)
      = const Tag.public("ShadowColorCIELabValue", 0x00700247,
          "Shadow Color CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kUnderlined
      //(0070,0248)
      = const Tag.public(
          "Underlined", 0x00700248, "Underlined", VR.kCS, VM.k1, false);
  static const Tag kBold
      //(0070,0249)
      = const Tag.public("Bold", 0x00700249, "Bold", VR.kCS, VM.k1, false);
  static const Tag kItalic
      //(0070,0250)
      = const Tag.public("Italic", 0x00700250, "Italic", VR.kCS, VM.k1, false);
  static const Tag kPatternOnColorCIELabValue
      //(0070,0251)
      = const Tag.public("PatternOnColorCIELabValue", 0x00700251,
          "Pattern On Color CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kPatternOffColorCIELabValue
      //(0070,0252)
      = const Tag.public("PatternOffColorCIELabValue", 0x00700252,
          "Pattern Off Color CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kLineThickness
      //(0070,0253)
      = const Tag.public(
          "LineThickness", 0x00700253, "Line Thickness", VR.kFL, VM.k1, false);
  static const Tag kLineDashingStyle
      //(0070,0254)
      = const Tag.public("LineDashingStyle", 0x00700254, "Line Dashing Style",
          VR.kCS, VM.k1, false);
  static const Tag kLinePattern
      //(0070,0255)
      = const Tag.public(
          "LinePattern", 0x00700255, "Line Pattern", VR.kUL, VM.k1, false);
  static const Tag kFillPattern
      //(0070,0256)
      = const Tag.public(
          "FillPattern", 0x00700256, "Fill Pattern", VR.kOB, VM.k1, false);
  static const Tag kFillMode
      //(0070,0257)
      = const Tag.public(
          "FillMode", 0x00700257, "Fill Mode", VR.kCS, VM.k1, false);
  static const Tag kShadowOpacity
      //(0070,0258)
      = const Tag.public(
          "ShadowOpacity", 0x00700258, "Shadow Opacity", VR.kFL, VM.k1, false);
  static const Tag kGapLength
      //(0070,0261)
      = const Tag.public(
          "GapLength", 0x00700261, "Gap Length", VR.kFL, VM.k1, false);
  static const Tag kDiameterOfVisibility
      //(0070,0262)
      = const Tag.public("DiameterOfVisibility", 0x00700262,
          "Diameter of Visibility", VR.kFL, VM.k1, false);
  static const Tag kRotationPoint
      //(0070,0273)
      = const Tag.public(
          "RotationPoint", 0x00700273, "Rotation Point", VR.kFL, VM.k2, false);
  static const Tag kTickAlignment
      //(0070,0274)
      = const Tag.public(
          "TickAlignment", 0x00700274, "Tick Alignment", VR.kCS, VM.k1, false);
  static const Tag kShowTickLabel
      //(0070,0278)
      = const Tag.public(
          "ShowTickLabel", 0x00700278, "Show Tick Label", VR.kCS, VM.k1, false);
  static const Tag kTickLabelAlignment
      //(0070,0279)
      = const Tag.public("TickLabelAlignment", 0x00700279,
          "Tick Label Alignment", VR.kCS, VM.k1, false);
  static const Tag kCompoundGraphicUnits
      //(0070,0282)
      = const Tag.public("CompoundGraphicUnits", 0x00700282,
          "Compound Graphic Units", VR.kCS, VM.k1, false);
  static const Tag kPatternOnOpacity
      //(0070,0284)
      = const Tag.public("PatternOnOpacity", 0x00700284, "Pattern On Opacity",
          VR.kFL, VM.k1, false);
  static const Tag kPatternOffOpacity
      //(0070,0285)
      = const Tag.public("PatternOffOpacity", 0x00700285, "Pattern Off Opacity",
          VR.kFL, VM.k1, false);
  static const Tag kMajorTicksSequence
      //(0070,0287)
      = const Tag.public("MajorTicksSequence", 0x00700287,
          "Major Ticks Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTickPosition
      //(0070,0288)
      = const Tag.public(
          "TickPosition", 0x00700288, "Tick Position", VR.kFL, VM.k1, false);
  static const Tag kTickLabel
      //(0070,0289)
      = const Tag.public(
          "TickLabel", 0x00700289, "Tick Label", VR.kSH, VM.k1, false);
  static const Tag kCompoundGraphicType
      //(0070,0294)
      = const Tag.public("CompoundGraphicType", 0x00700294,
          "Compound Graphic Type", VR.kCS, VM.k1, false);
  static const Tag kGraphicGroupID
      //(0070,0295)
      = const Tag.public("GraphicGroupID", 0x00700295, "Graphic Group ID",
          VR.kUL, VM.k1, false);
  static const Tag kShapeType
      //(0070,0306)
      = const Tag.public(
          "ShapeType", 0x00700306, "Shape Type", VR.kCS, VM.k1, false);
  static const Tag kRegistrationSequence
      //(0070,0308)
      = const Tag.public("RegistrationSequence", 0x00700308,
          "Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMatrixRegistrationSequence
      //(0070,0309)
      = const Tag.public("MatrixRegistrationSequence", 0x00700309,
          "Matrix Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMatrixSequence
      //(0070,030A)
      = const Tag.public("MatrixSequence", 0x0070030A, "Matrix Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kFrameOfReferenceTransformationMatrixType
      //(0070,030C)
      = const Tag.public(
          "FrameOfReferenceTransformationMatrixType",
          0x0070030C,
          "Frame of Reference Transformation Matrix Type",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kRegistrationTypeCodeSequence
      //(0070,030D)
      = const Tag.public("RegistrationTypeCodeSequence", 0x0070030D,
          "Registration Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFiducialDescription
      //(0070,030F)
      = const Tag.public("FiducialDescription", 0x0070030F,
          "Fiducial Description", VR.kST, VM.k1, false);
  static const Tag kFiducialIdentifier
      //(0070,0310)
      = const Tag.public("FiducialIdentifier", 0x00700310,
          "Fiducial Identifier", VR.kSH, VM.k1, false);
  static const Tag kFiducialIdentifierCodeSequence
      //(0070,0311)
      = const Tag.public("FiducialIdentifierCodeSequence", 0x00700311,
          "Fiducial Identifier Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContourUncertaintyRadius
      //(0070,0312)
      = const Tag.public("ContourUncertaintyRadius", 0x00700312,
          "Contour Uncertainty Radius", VR.kFD, VM.k1, false);
  static const Tag kUsedFiducialsSequence
      //(0070,0314)
      = const Tag.public("UsedFiducialsSequence", 0x00700314,
          "Used Fiducials Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGraphicCoordinatesDataSequence
      //(0070,0318)
      = const Tag.public("GraphicCoordinatesDataSequence", 0x00700318,
          "Graphic Coordinates Data Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFiducialUID
      //(0070,031A)
      = const Tag.public(
          "FiducialUID", 0x0070031A, "Fiducial UID", VR.kUI, VM.k1, false);
  static const Tag kFiducialSetSequence
      //(0070,031C)
      = const Tag.public("FiducialSetSequence", 0x0070031C,
          "Fiducial Set Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFiducialSequence
      //(0070,031E)
      = const Tag.public("FiducialSequence", 0x0070031E, "Fiducial Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kGraphicLayerRecommendedDisplayCIELabValue
      //(0070,0401)
      = const Tag.public(
          "GraphicLayerRecommendedDisplayCIELabValue",
          0x00700401,
          "Graphic Layer Recommended Display CIELab Value",
          VR.kUS,
          VM.k3,
          false);
  static const Tag kBlendingSequence
      //(0070,0402)
      = const Tag.public("BlendingSequence", 0x00700402, "Blending Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kRelativeOpacity
      //(0070,0403)
      = const Tag.public("RelativeOpacity", 0x00700403, "Relative Opacity",
          VR.kFL, VM.k1, false);
  static const Tag kReferencedSpatialRegistrationSequence
      //(0070,0404)
      = const Tag.public("ReferencedSpatialRegistrationSequence", 0x00700404,
          "Referenced Spatial Registration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBlendingPosition
      //(0070,0405)
      = const Tag.public("BlendingPosition", 0x00700405, "Blending Position",
          VR.kCS, VM.k1, false);
  static const Tag kHangingProtocolName
      //(0072,0002)
      = const Tag.public("HangingProtocolName", 0x00720002,
          "Hanging Protocol Name", VR.kSH, VM.k1, false);
  static const Tag kHangingProtocolDescription
      //(0072,0004)
      = const Tag.public("HangingProtocolDescription", 0x00720004,
          "Hanging Protocol Description", VR.kLO, VM.k1, false);
  static const Tag kHangingProtocolLevel
      //(0072,0006)
      = const Tag.public("HangingProtocolLevel", 0x00720006,
          "Hanging Protocol Level", VR.kCS, VM.k1, false);
  static const Tag kHangingProtocolCreator
      //(0072,0008)
      = const Tag.public("HangingProtocolCreator", 0x00720008,
          "Hanging Protocol Creator", VR.kLO, VM.k1, false);
  static const Tag kHangingProtocolCreationDateTime
      //(0072,000A)
      = const Tag.public("HangingProtocolCreationDateTime", 0x0072000A,
          "Hanging Protocol Creation DateTime", VR.kDT, VM.k1, false);
  static const Tag kHangingProtocolDefinitionSequence
      //(0072,000C)
      = const Tag.public("HangingProtocolDefinitionSequence", 0x0072000C,
          "Hanging Protocol Definition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kHangingProtocolUserIdentificationCodeSequence
      //(0072,000E)
      = const Tag.public(
          "HangingProtocolUserIdentificationCodeSequence",
          0x0072000E,
          "Hanging Protocol User Identification Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kHangingProtocolUserGroupName
      //(0072,0010)
      = const Tag.public("HangingProtocolUserGroupName", 0x00720010,
          "Hanging Protocol User Group Name", VR.kLO, VM.k1, false);
  static const Tag kSourceHangingProtocolSequence
      //(0072,0012)
      = const Tag.public("SourceHangingProtocolSequence", 0x00720012,
          "Source Hanging Protocol Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfPriorsReferenced
      //(0072,0014)
      = const Tag.public("NumberOfPriorsReferenced", 0x00720014,
          "Number of Priors Referenced", VR.kUS, VM.k1, false);
  static const Tag kImageSetsSequence
      //(0072,0020)
      = const Tag.public("ImageSetsSequence", 0x00720020, "Image Sets Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kImageSetSelectorSequence
      //(0072,0022)
      = const Tag.public("ImageSetSelectorSequence", 0x00720022,
          "Image Set Selector Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageSetSelectorUsageFlag
      //(0072,0024)
      = const Tag.public("ImageSetSelectorUsageFlag", 0x00720024,
          "Image Set Selector Usage Flag", VR.kCS, VM.k1, false);
  static const Tag kSelectorAttribute
      //(0072,0026)
      = const Tag.public("SelectorAttribute", 0x00720026, "Selector Attribute",
          VR.kAT, VM.k1, false);
  static const Tag kSelectorValueNumber
      //(0072,0028)
      = const Tag.public("SelectorValueNumber", 0x00720028,
          "Selector Value Number", VR.kUS, VM.k1, false);
  static const Tag kTimeBasedImageSetsSequence
      //(0072,0030)
      = const Tag.public("TimeBasedImageSetsSequence", 0x00720030,
          "Time Based Image Sets Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageSetNumber
      //(0072,0032)
      = const Tag.public("ImageSetNumber", 0x00720032, "Image Set Number",
          VR.kUS, VM.k1, false);
  static const Tag kImageSetSelectorCategory
      //(0072,0034)
      = const Tag.public("ImageSetSelectorCategory", 0x00720034,
          "Image Set Selector Category", VR.kCS, VM.k1, false);
  static const Tag kRelativeTime
      //(0072,0038)
      = const Tag.public(
          "RelativeTime", 0x00720038, "Relative Time", VR.kUS, VM.k2, false);
  static const Tag kRelativeTimeUnits
      //(0072,003A)
      = const Tag.public("RelativeTimeUnits", 0x0072003A, "Relative Time Units",
          VR.kCS, VM.k1, false);
  static const Tag kAbstractPriorValue
      //(0072,003C)
      = const Tag.public("AbstractPriorValue", 0x0072003C,
          "Abstract Prior Value", VR.kSS, VM.k2, false);
  static const Tag kAbstractPriorCodeSequence
      //(0072,003E)
      = const Tag.public("AbstractPriorCodeSequence", 0x0072003E,
          "Abstract Prior Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageSetLabel
      //(0072,0040)
      = const Tag.public(
          "ImageSetLabel", 0x00720040, "Image Set Label", VR.kLO, VM.k1, false);
  static const Tag kSelectorAttributeVR
      //(0072,0050)
      = const Tag.public("SelectorAttributeVR", 0x00720050,
          "Selector Attribute VR", VR.kCS, VM.k1, false);
  static const Tag kSelectorSequencePointer
      //(0072,0052)
      = const Tag.public("SelectorSequencePointer", 0x00720052,
          "Selector Sequence Pointer", VR.kAT, VM.k1_n, false);
  static const Tag kSelectorSequencePointerPrivateCreator
      //(0072,0054)
      = const Tag.public("SelectorSequencePointerPrivateCreator", 0x00720054,
          "Selector Sequence Pointer Private Creator", VR.kLO, VM.k1_n, false);
  static const Tag kSelectorAttributePrivateCreator
      //(0072,0056)
      = const Tag.public("SelectorAttributePrivateCreator", 0x00720056,
          "Selector Attribute Private Creator", VR.kLO, VM.k1, false);
  static const Tag kSelectorATValue
      //(0072,0060)
      = const Tag.public("SelectorATValue", 0x00720060, "Selector AT Value",
          VR.kAT, VM.k1_n, false);
  static const Tag kSelectorCSValue
      //(0072,0062)
      = const Tag.public("SelectorCSValue", 0x00720062, "Selector CS Value",
          VR.kCS, VM.k1_n, false);
  static const Tag kSelectorISValue
      //(0072,0064)
      = const Tag.public("SelectorISValue", 0x00720064, "Selector IS Value",
          VR.kIS, VM.k1_n, false);
  static const Tag kSelectorLOValue
      //(0072,0066)
      = const Tag.public("SelectorLOValue", 0x00720066, "Selector LO Value",
          VR.kLO, VM.k1_n, false);
  static const Tag kSelectorLTValue
      //(0072,0068)
      = const Tag.public("SelectorLTValue", 0x00720068, "Selector LT Value",
          VR.kLT, VM.k1, false);
  static const Tag kSelectorPNValue
      //(0072,006A)
      = const Tag.public("SelectorPNValue", 0x0072006A, "Selector PN Value",
          VR.kPN, VM.k1_n, false);
  static const Tag kSelectorSHValue
      //(0072,006C)
      = const Tag.public("SelectorSHValue", 0x0072006C, "Selector SH Value",
          VR.kSH, VM.k1_n, false);
  static const Tag kSelectorSTValue
      //(0072,006E)
      = const Tag.public("SelectorSTValue", 0x0072006E, "Selector ST Value",
          VR.kST, VM.k1, false);
  static const Tag kSelectorUTValue
      //(0072,0070)
      = const Tag.public("SelectorUTValue", 0x00720070, "Selector UT Value",
          VR.kUT, VM.k1, false);
  static const Tag kSelectorDSValue
      //(0072,0072)
      = const Tag.public("SelectorDSValue", 0x00720072, "Selector DS Value",
          VR.kDS, VM.k1_n, false);
  static const Tag kSelectorODValue
      //(0072,0073)
      = const Tag.public("SelectorODValue", 0x00720073, "Selector OD Value",
          VR.kOD, VM.k1, false);
  static const Tag kSelectorFDValue
      //(0072,0074)
      = const Tag.public("SelectorFDValue", 0x00720074, "Selector FD Value",
          VR.kFD, VM.k1_n, false);
  static const Tag kSelectorFLValue
      //(0072,0076)
      = const Tag.public("SelectorFLValue", 0x00720076, "Selector FL Value",
          VR.kFL, VM.k1_n, false);
  static const Tag kSelectorULValue
      //(0072,0078)
      = const Tag.public("SelectorULValue", 0x00720078, "Selector UL Value",
          VR.kUL, VM.k1_n, false);
  static const Tag kSelectorUSValue
      //(0072,007A)
      = const Tag.public("SelectorUSValue", 0x0072007A, "Selector US Value",
          VR.kUS, VM.k1_n, false);
  static const Tag kSelectorSLValue
      //(0072,007C)
      = const Tag.public("SelectorSLValue", 0x0072007C, "Selector SL Value",
          VR.kSL, VM.k1_n, false);
  static const Tag kSelectorSSValue
      //(0072,007E)
      = const Tag.public("SelectorSSValue", 0x0072007E, "Selector SS Value",
          VR.kSS, VM.k1_n, false);
  static const Tag kSelectorCodeSequenceValue
      //(0072,0080)
      = const Tag.public("SelectorCodeSequenceValue", 0x00720080,
          "Selector Code Sequence Value", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfScreens
      //(0072,0100)
      = const Tag.public("NumberOfScreens", 0x00720100, "Number of Screens",
          VR.kUS, VM.k1, false);
  static const Tag kNominalScreenDefinitionSequence
      //(0072,0102)
      = const Tag.public("NominalScreenDefinitionSequence", 0x00720102,
          "Nominal Screen Definition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNumberOfVerticalPixels
      //(0072,0104)
      = const Tag.public("NumberOfVerticalPixels", 0x00720104,
          "Number of Vertical Pixels", VR.kUS, VM.k1, false);
  static const Tag kNumberOfHorizontalPixels
      //(0072,0106)
      = const Tag.public("NumberOfHorizontalPixels", 0x00720106,
          "Number of Horizontal Pixels", VR.kUS, VM.k1, false);
  static const Tag kDisplayEnvironmentSpatialPosition
      //(0072,0108)
      = const Tag.public("DisplayEnvironmentSpatialPosition", 0x00720108,
          "Display Environment Spatial Position", VR.kFD, VM.k4, false);
  static const Tag kScreenMinimumGrayscaleBitDepth
      //(0072,010A)
      = const Tag.public("ScreenMinimumGrayscaleBitDepth", 0x0072010A,
          "Screen Minimum Grayscale Bit Depth", VR.kUS, VM.k1, false);
  static const Tag kScreenMinimumColorBitDepth
      //(0072,010C)
      = const Tag.public("ScreenMinimumColorBitDepth", 0x0072010C,
          "Screen Minimum Color Bit Depth", VR.kUS, VM.k1, false);
  static const Tag kApplicationMaximumRepaintTime
      //(0072,010E)
      = const Tag.public("ApplicationMaximumRepaintTime", 0x0072010E,
          "Application Maximum Repaint Time", VR.kUS, VM.k1, false);
  static const Tag kDisplaySetsSequence
      //(0072,0200)
      = const Tag.public("DisplaySetsSequence", 0x00720200,
          "Display Sets Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDisplaySetNumber
      //(0072,0202)
      = const Tag.public("DisplaySetNumber", 0x00720202, "Display Set Number",
          VR.kUS, VM.k1, false);
  static const Tag kDisplaySetLabel
      //(0072,0203)
      = const Tag.public("DisplaySetLabel", 0x00720203, "Display Set Label",
          VR.kLO, VM.k1, false);
  static const Tag kDisplaySetPresentationGroup
      //(0072,0204)
      = const Tag.public("DisplaySetPresentationGroup", 0x00720204,
          "Display Set Presentation Group", VR.kUS, VM.k1, false);
  static const Tag kDisplaySetPresentationGroupDescription
      //(0072,0206)
      = const Tag.public("DisplaySetPresentationGroupDescription", 0x00720206,
          "Display Set Presentation Group Description", VR.kLO, VM.k1, false);
  static const Tag kPartialDataDisplayHandling
      //(0072,0208)
      = const Tag.public("PartialDataDisplayHandling", 0x00720208,
          "Partial Data Display Handling", VR.kCS, VM.k1, false);
  static const Tag kSynchronizedScrollingSequence
      //(0072,0210)
      = const Tag.public("SynchronizedScrollingSequence", 0x00720210,
          "Synchronized Scrolling Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDisplaySetScrollingGroup
      //(0072,0212)
      = const Tag.public("DisplaySetScrollingGroup", 0x00720212,
          "Display Set Scrolling Group", VR.kUS, VM.k2_n, false);
  static const Tag kNavigationIndicatorSequence
      //(0072,0214)
      = const Tag.public("NavigationIndicatorSequence", 0x00720214,
          "Navigation Indicator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kNavigationDisplaySet
      //(0072,0216)
      = const Tag.public("NavigationDisplaySet", 0x00720216,
          "Navigation Display Set", VR.kUS, VM.k1, false);
  static const Tag kReferenceDisplaySets
      //(0072,0218)
      = const Tag.public("ReferenceDisplaySets", 0x00720218,
          "Reference Display Sets", VR.kUS, VM.k1_n, false);
  static const Tag kImageBoxesSequence
      //(0072,0300)
      = const Tag.public("ImageBoxesSequence", 0x00720300,
          "Image Boxes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageBoxNumber
      //(0072,0302)
      = const Tag.public("ImageBoxNumber", 0x00720302, "Image Box Number",
          VR.kUS, VM.k1, false);
  static const Tag kImageBoxLayoutType
      //(0072,0304)
      = const Tag.public("ImageBoxLayoutType", 0x00720304,
          "Image Box Layout Type", VR.kCS, VM.k1, false);
  static const Tag kImageBoxTileHorizontalDimension
      //(0072,0306)
      = const Tag.public("ImageBoxTileHorizontalDimension", 0x00720306,
          "Image Box Tile Horizontal Dimension", VR.kUS, VM.k1, false);
  static const Tag kImageBoxTileVerticalDimension
      //(0072,0308)
      = const Tag.public("ImageBoxTileVerticalDimension", 0x00720308,
          "Image Box Tile Vertical Dimension", VR.kUS, VM.k1, false);
  static const Tag kImageBoxScrollDirection
      //(0072,0310)
      = const Tag.public("ImageBoxScrollDirection", 0x00720310,
          "Image Box Scroll Direction", VR.kCS, VM.k1, false);
  static const Tag kImageBoxSmallScrollType
      //(0072,0312)
      = const Tag.public("ImageBoxSmallScrollType", 0x00720312,
          "Image Box Small Scroll Type", VR.kCS, VM.k1, false);
  static const Tag kImageBoxSmallScrollAmount
      //(0072,0314)
      = const Tag.public("ImageBoxSmallScrollAmount", 0x00720314,
          "Image Box Small Scroll Amount", VR.kUS, VM.k1, false);
  static const Tag kImageBoxLargeScrollType
      //(0072,0316)
      = const Tag.public("ImageBoxLargeScrollType", 0x00720316,
          "Image Box Large Scroll Type", VR.kCS, VM.k1, false);
  static const Tag kImageBoxLargeScrollAmount
      //(0072,0318)
      = const Tag.public("ImageBoxLargeScrollAmount", 0x00720318,
          "Image Box Large Scroll Amount", VR.kUS, VM.k1, false);
  static const Tag kImageBoxOverlapPriority
      //(0072,0320)
      = const Tag.public("ImageBoxOverlapPriority", 0x00720320,
          "Image Box Overlap Priority", VR.kUS, VM.k1, false);
  static const Tag kCineRelativeToRealTime
      //(0072,0330)
      = const Tag.public("CineRelativeToRealTime", 0x00720330,
          "Cine Relative to Real-Time", VR.kFD, VM.k1, false);
  static const Tag kFilterOperationsSequence
      //(0072,0400)
      = const Tag.public("FilterOperationsSequence", 0x00720400,
          "Filter Operations Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFilterByCategory
      //(0072,0402)
      = const Tag.public("FilterByCategory", 0x00720402, "Filter-by Category",
          VR.kCS, VM.k1, false);
  static const Tag kFilterByAttributePresence
      //(0072,0404)
      = const Tag.public("FilterByAttributePresence", 0x00720404,
          "Filter-by Attribute Presence", VR.kCS, VM.k1, false);
  static const Tag kFilterByOperator
      //(0072,0406)
      = const Tag.public("FilterByOperator", 0x00720406, "Filter-by Operator",
          VR.kCS, VM.k1, false);
  static const Tag kStructuredDisplayBackgroundCIELabValue
      //(0072,0420)
      = const Tag.public("StructuredDisplayBackgroundCIELabValue", 0x00720420,
          "Structured Display Background CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kEmptyImageBoxCIELabValue
      //(0072,0421)
      = const Tag.public("EmptyImageBoxCIELabValue", 0x00720421,
          "Empty Image Box CIELab Value", VR.kUS, VM.k3, false);
  static const Tag kStructuredDisplayImageBoxSequence
      //(0072,0422)
      = const Tag.public("StructuredDisplayImageBoxSequence", 0x00720422,
          "Structured Display Image Box Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStructuredDisplayTextBoxSequence
      //(0072,0424)
      = const Tag.public("StructuredDisplayTextBoxSequence", 0x00720424,
          "Structured Display Text Box Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedFirstFrameSequence
      //(0072,0427)
      = const Tag.public("ReferencedFirstFrameSequence", 0x00720427,
          "Referenced First Frame Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageBoxSynchronizationSequence
      //(0072,0430)
      = const Tag.public("ImageBoxSynchronizationSequence", 0x00720430,
          "Image Box Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSynchronizedImageBoxList
      //(0072,0432)
      = const Tag.public("SynchronizedImageBoxList", 0x00720432,
          "Synchronized Image Box List", VR.kUS, VM.k2_n, false);
  static const Tag kTypeOfSynchronization
      //(0072,0434)
      = const Tag.public("TypeOfSynchronization", 0x00720434,
          "Type of Synchronization", VR.kCS, VM.k1, false);
  static const Tag kBlendingOperationType
      //(0072,0500)
      = const Tag.public("BlendingOperationType", 0x00720500,
          "Blending Operation Type", VR.kCS, VM.k1, false);
  static const Tag kReformattingOperationType
      //(0072,0510)
      = const Tag.public("ReformattingOperationType", 0x00720510,
          "Reformatting Operation Type", VR.kCS, VM.k1, false);
  static const Tag kReformattingThickness
      //(0072,0512)
      = const Tag.public("ReformattingThickness", 0x00720512,
          "Reformatting Thickness", VR.kFD, VM.k1, false);
  static const Tag kReformattingInterval
      //(0072,0514)
      = const Tag.public("ReformattingInterval", 0x00720514,
          "Reformatting Interval", VR.kFD, VM.k1, false);
  static const Tag kReformattingOperationInitialViewDirection
      //(0072,0516)
      = const Tag.public(
          "ReformattingOperationInitialViewDirection",
          0x00720516,
          "Reformatting Operation Initial View Direction",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kThreeDRenderingType
      //(0072,0520)
      = const Tag.public("ThreeDRenderingType", 0x00720520, "3D Rendering Type",
          VR.kCS, VM.k1_n, false);
  static const Tag kSortingOperationsSequence
      //(0072,0600)
      = const Tag.public("SortingOperationsSequence", 0x00720600,
          "Sorting Operations Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSortByCategory
      //(0072,0602)
      = const Tag.public("SortByCategory", 0x00720602, "Sort-by Category",
          VR.kCS, VM.k1, false);
  static const Tag kSortingDirection
      //(0072,0604)
      = const Tag.public("SortingDirection", 0x00720604, "Sorting Direction",
          VR.kCS, VM.k1, false);
  static const Tag kDisplaySetPatientOrientation
      //(0072,0700)
      = const Tag.public("DisplaySetPatientOrientation", 0x00720700,
          "Display Set Patient Orientation", VR.kCS, VM.k2, false);
  static const Tag kVOIType
      //(0072,0702)
      =
      const Tag.public("VOIType", 0x00720702, "VOI Type", VR.kCS, VM.k1, false);
  static const Tag kPseudoColorType
      //(0072,0704)
      = const Tag.public("PseudoColorType", 0x00720704, "Pseudo-Color Type",
          VR.kCS, VM.k1, false);
  static const Tag kPseudoColorPaletteInstanceReferenceSequence
      //(0072,0705)
      = const Tag.public(
          "PseudoColorPaletteInstanceReferenceSequence",
          0x00720705,
          "Pseudo-Color Palette Instance Reference Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kShowGrayscaleInverted
      //(0072,0706)
      = const Tag.public("ShowGrayscaleInverted", 0x00720706,
          "Show Grayscale Inverted", VR.kCS, VM.k1, false);
  static const Tag kShowImageTrueSizeFlag
      //(0072,0710)
      = const Tag.public("ShowImageTrueSizeFlag", 0x00720710,
          "Show Image True Size Flag", VR.kCS, VM.k1, false);
  static const Tag kShowGraphicAnnotationFlag
      //(0072,0712)
      = const Tag.public("ShowGraphicAnnotationFlag", 0x00720712,
          "Show Graphic Annotation Flag", VR.kCS, VM.k1, false);
  static const Tag kShowPatientDemographicsFlag
      //(0072,0714)
      = const Tag.public("ShowPatientDemographicsFlag", 0x00720714,
          "Show Patient Demographics Flag", VR.kCS, VM.k1, false);
  static const Tag kShowAcquisitionTechniquesFlag
      //(0072,0716)
      = const Tag.public("ShowAcquisitionTechniquesFlag", 0x00720716,
          "Show Acquisition Techniques Flag", VR.kCS, VM.k1, false);
  static const Tag kDisplaySetHorizontalJustification
      //(0072,0717)
      = const Tag.public("DisplaySetHorizontalJustification", 0x00720717,
          "Display Set Horizontal Justification", VR.kCS, VM.k1, false);
  static const Tag kDisplaySetVerticalJustification
      //(0072,0718)
      = const Tag.public("DisplaySetVerticalJustification", 0x00720718,
          "Display Set Vertical Justification", VR.kCS, VM.k1, false);
  static const Tag kContinuationStartMeterset
      //(0074,0120)
      = const Tag.public("ContinuationStartMeterset", 0x00740120,
          "Continuation Start Meterset", VR.kFD, VM.k1, false);
  static const Tag kContinuationEndMeterset
      //(0074,0121)
      = const Tag.public("ContinuationEndMeterset", 0x00740121,
          "Continuation End Meterset", VR.kFD, VM.k1, false);
  static const Tag kProcedureStepState
      //(0074,1000)
      = const Tag.public("ProcedureStepState", 0x00741000,
          "Procedure Step State", VR.kCS, VM.k1, false);
  static const Tag kProcedureStepProgressInformationSequence
      //(0074,1002)
      = const Tag.public("ProcedureStepProgressInformationSequence", 0x00741002,
          "Procedure Step Progress Information Sequence", VR.kSQ, VM.k1, false);
  static const Tag kProcedureStepProgress
      //(0074,1004)
      = const Tag.public("ProcedureStepProgress", 0x00741004,
          "Procedure Step Progress", VR.kDS, VM.k1, false);
  static const Tag kProcedureStepProgressDescription
      //(0074,1006)
      = const Tag.public("ProcedureStepProgressDescription", 0x00741006,
          "Procedure Step Progress Description", VR.kST, VM.k1, false);
  static const Tag kProcedureStepCommunicationsURISequence
      //(0074,1008)
      = const Tag.public("ProcedureStepCommunicationsURISequence", 0x00741008,
          "Procedure Step Communications URI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContactURI
      //(0074,100a)
      = const Tag.public(
          "ContactURI", 0x0074100a, "Contact URI", VR.kST, VM.k1, false);
  static const Tag kContactDisplayName
      //(0074,100c)
      = const Tag.public("ContactDisplayName", 0x0074100c,
          "Contact Display Name", VR.kLO, VM.k1, false);
  static const Tag kProcedureStepDiscontinuationReasonCodeSequence
      //(0074,100e)
      = const Tag.public(
          "ProcedureStepDiscontinuationReasonCodeSequence",
          0x0074100e,
          "Procedure Step Discontinuation Reason Code Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kBeamTaskSequence
      //(0074,1020)
      = const Tag.public("BeamTaskSequence", 0x00741020, "Beam Task Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kBeamTaskType
      //(0074,1022)
      = const Tag.public(
          "BeamTaskType", 0x00741022, "Beam Task Type", VR.kCS, VM.k1, false);
  static const Tag kBeamOrderIndexTrial
      //(0074,1024)
      = const Tag.public("BeamOrderIndexTrial", 0x00741024,
          "Beam Order Index (Trial)", VR.kIS, VM.k1, true);
  static const Tag kAutosequenceFlag
      //(0074,1025)
      = const Tag.public("AutosequenceFlag", 0x00741025, "Autosequence Flag",
          VR.kCS, VM.k1, false);
  static const Tag kTableTopVerticalAdjustedPosition
      //(0074,1026)
      = const Tag.public("TableTopVerticalAdjustedPosition", 0x00741026,
          "Table Top Vertical Adjusted Position", VR.kFD, VM.k1, false);
  static const Tag kTableTopLongitudinalAdjustedPosition
      //(0074,1027)
      = const Tag.public("TableTopLongitudinalAdjustedPosition", 0x00741027,
          "Table Top Longitudinal Adjusted Position", VR.kFD, VM.k1, false);
  static const Tag kTableTopLateralAdjustedPosition
      //(0074,1028)
      = const Tag.public("TableTopLateralAdjustedPosition", 0x00741028,
          "Table Top Lateral Adjusted Position", VR.kFD, VM.k1, false);
  static const Tag kPatientSupportAdjustedAngle
      //(0074,102A)
      = const Tag.public("PatientSupportAdjustedAngle", 0x0074102A,
          "Patient Support Adjusted Angle", VR.kFD, VM.k1, false);
  static const Tag kTableTopEccentricAdjustedAngle
      //(0074,102B)
      = const Tag.public("TableTopEccentricAdjustedAngle", 0x0074102B,
          "Table Top Eccentric Adjusted Angle", VR.kFD, VM.k1, false);
  static const Tag kTableTopPitchAdjustedAngle
      //(0074,102C)
      = const Tag.public("TableTopPitchAdjustedAngle", 0x0074102C,
          "Table Top Pitch Adjusted Angle", VR.kFD, VM.k1, false);
  static const Tag kTableTopRollAdjustedAngle
      //(0074,102D)
      = const Tag.public("TableTopRollAdjustedAngle", 0x0074102D,
          "Table Top Roll Adjusted Angle", VR.kFD, VM.k1, false);
  static const Tag kDeliveryVerificationImageSequence
      //(0074,1030)
      = const Tag.public("DeliveryVerificationImageSequence", 0x00741030,
          "Delivery Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kVerificationImageTiming
      //(0074,1032)
      = const Tag.public("VerificationImageTiming", 0x00741032,
          "Verification Image Timing", VR.kCS, VM.k1, false);
  static const Tag kDoubleExposureFlag
      //(0074,1034)
      = const Tag.public("DoubleExposureFlag", 0x00741034,
          "Double Exposure Flag", VR.kCS, VM.k1, false);
  static const Tag kDoubleExposureOrdering
      //(0074,1036)
      = const Tag.public("DoubleExposureOrdering", 0x00741036,
          "Double Exposure Ordering", VR.kCS, VM.k1, false);
  static const Tag kDoubleExposureMetersetTrial
      //(0074,1038)
      = const Tag.public("DoubleExposureMetersetTrial", 0x00741038,
          "Double Exposure Meterset (Trial)", VR.kDS, VM.k1, true);
  static const Tag kDoubleExposureFieldDeltaTrial
      //(0074,103A)
      = const Tag.public("DoubleExposureFieldDeltaTrial", 0x0074103A,
          "Double Exposure Field Delta (Trial)", VR.kDS, VM.k4, true);
  static const Tag kRelatedReferenceRTImageSequence
      //(0074,1040)
      = const Tag.public("RelatedReferenceRTImageSequence", 0x00741040,
          "Related Reference RT Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGeneralMachineVerificationSequence
      //(0074,1042)
      = const Tag.public("GeneralMachineVerificationSequence", 0x00741042,
          "General Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kConventionalMachineVerificationSequence
      //(0074,1044)
      = const Tag.public("ConventionalMachineVerificationSequence", 0x00741044,
          "Conventional Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIonMachineVerificationSequence
      //(0074,1046)
      = const Tag.public("IonMachineVerificationSequence", 0x00741046,
          "Ion Machine Verification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFailedAttributesSequence
      //(0074,1048)
      = const Tag.public("FailedAttributesSequence", 0x00741048,
          "Failed Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOverriddenAttributesSequence
      //(0074,104A)
      = const Tag.public("OverriddenAttributesSequence", 0x0074104A,
          "Overridden Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kConventionalControlPointVerificationSequence
      //(0074,104C)
      = const Tag.public(
          "ConventionalControlPointVerificationSequence",
          0x0074104C,
          "Conventional Control Point Verification Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kIonControlPointVerificationSequence
      //(0074,104E)
      = const Tag.public("IonControlPointVerificationSequence", 0x0074104E,
          "Ion Control Point Verification Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAttributeOccurrenceSequence
      //(0074,1050)
      = const Tag.public("AttributeOccurrenceSequence", 0x00741050,
          "Attribute Occurrence Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAttributeOccurrencePointer
      //(0074,1052)
      = const Tag.public("AttributeOccurrencePointer", 0x00741052,
          "Attribute Occurrence Pointer", VR.kAT, VM.k1, false);
  static const Tag kAttributeItemSelector
      //(0074,1054)
      = const Tag.public("AttributeItemSelector", 0x00741054,
          "Attribute Item Selector", VR.kUL, VM.k1, false);
  static const Tag kAttributeOccurrencePrivateCreator
      //(0074,1056)
      = const Tag.public("AttributeOccurrencePrivateCreator", 0x00741056,
          "Attribute Occurrence Private Creator", VR.kLO, VM.k1, false);
  static const Tag kSelectorSequencePointerItems
      //(0074,1057)
      = const Tag.public("SelectorSequencePointerItems", 0x00741057,
          "Selector Sequence Pointer Items", VR.kIS, VM.k1_n, false);
  static const Tag kScheduledProcedureStepPriority
      //(0074,1200)
      = const Tag.public("ScheduledProcedureStepPriority", 0x00741200,
          "Scheduled Procedure Step Priority", VR.kCS, VM.k1, false);
  static const Tag kWorklistLabel
      //(0074,1202)
      = const Tag.public(
          "WorklistLabel", 0x00741202, "Worklist Label", VR.kLO, VM.k1, false);
  static const Tag kProcedureStepLabel
      //(0074,1204)
      = const Tag.public("ProcedureStepLabel", 0x00741204,
          "Procedure Step Label", VR.kLO, VM.k1, false);
  static const Tag kScheduledProcessingParametersSequence
      //(0074,1210)
      = const Tag.public("ScheduledProcessingParametersSequence", 0x00741210,
          "Scheduled Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerformedProcessingParametersSequence
      //(0074,1212)
      = const Tag.public("PerformedProcessingParametersSequence", 0x00741212,
          "Performed Processing Parameters Sequence", VR.kSQ, VM.k1, false);
  static const Tag kUnifiedProcedureStepPerformedProcedureSequence
      //(0074,1216)
      = const Tag.public(
          "UnifiedProcedureStepPerformedProcedureSequence",
          0x00741216,
          "Unified Procedure Step Performed Procedure Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRelatedProcedureStepSequence
      //(0074,1220)
      = const Tag.public("RelatedProcedureStepSequence", 0x00741220,
          "Related Procedure Step Sequence", VR.kSQ, VM.k1, true);
  static const Tag kProcedureStepRelationshipType
      //(0074,1222)
      = const Tag.public("ProcedureStepRelationshipType", 0x00741222,
          "Procedure Step Relationship Type", VR.kLO, VM.k1, true);
  static const Tag kReplacedProcedureStepSequence
      //(0074,1224)
      = const Tag.public("ReplacedProcedureStepSequence", 0x00741224,
          "Replaced Procedure Step Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDeletionLock
      //(0074,1230)
      = const Tag.public(
          "DeletionLock", 0x00741230, "Deletion Lock", VR.kLO, VM.k1, false);
  static const Tag kReceivingAE
      //(0074,1234)
      = const Tag.public(
          "ReceivingAE", 0x00741234, "Receiving AE", VR.kAE, VM.k1, false);
  static const Tag kRequestingAE
      //(0074,1236)
      = const Tag.public(
          "RequestingAE", 0x00741236, "Requesting AE", VR.kAE, VM.k1, false);
  static const Tag kReasonForCancellation
      //(0074,1238)
      = const Tag.public("ReasonForCancellation", 0x00741238,
          "Reason for Cancellation", VR.kLT, VM.k1, false);
  static const Tag kSCPStatus
      //(0074,1242)
      = const Tag.public(
          "SCPStatus", 0x00741242, "SCP Status", VR.kCS, VM.k1, false);
  static const Tag kSubscriptionListStatus
      //(0074,1244)
      = const Tag.public("SubscriptionListStatus", 0x00741244,
          "Subscription List Status", VR.kCS, VM.k1, false);
  static const Tag kUnifiedProcedureStepListStatus
      //(0074,1246)
      = const Tag.public("UnifiedProcedureStepListStatus", 0x00741246,
          "Unified Procedure StepList Status", VR.kCS, VM.k1, false);
  static const Tag kBeamOrderIndex
      //(0074,1324)
      = const Tag.public("BeamOrderIndex", 0x00741324, "Beam Order Index",
          VR.kUL, VM.k1, false);
  static const Tag kDoubleExposureMeterset
      //(0074,1338)
      = const Tag.public("DoubleExposureMeterset", 0x00741338,
          "Double Exposure Meterset", VR.kFD, VM.k1, false);
  static const Tag kDoubleExposureFieldDelta
      //(0074,133A)
      = const Tag.public("DoubleExposureFieldDelta", 0x0074133A,
          "Double Exposure Field Delta", VR.kFD, VM.k4, false);
  static const Tag kImplantAssemblyTemplateName
      //(0076,0001)
      = const Tag.public("ImplantAssemblyTemplateName", 0x00760001,
          "Implant Assembly Template Name", VR.kLO, VM.k1, false);
  static const Tag kImplantAssemblyTemplateIssuer
      //(0076,0003)
      = const Tag.public("ImplantAssemblyTemplateIssuer", 0x00760003,
          "Implant Assembly Template Issuer", VR.kLO, VM.k1, false);
  static const Tag kImplantAssemblyTemplateVersion
      //(0076,0006)
      = const Tag.public("ImplantAssemblyTemplateVersion", 0x00760006,
          "Implant Assembly Template Version", VR.kLO, VM.k1, false);
  static const Tag kReplacedImplantAssemblyTemplateSequence
      //(0076,0008)
      = const Tag.public("ReplacedImplantAssemblyTemplateSequence", 0x00760008,
          "Replaced Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantAssemblyTemplateType
      //(0076,000A)
      = const Tag.public("ImplantAssemblyTemplateType", 0x0076000A,
          "Implant Assembly Template Type", VR.kCS, VM.k1, false);
  static const Tag kOriginalImplantAssemblyTemplateSequence
      //(0076,000C)
      = const Tag.public("OriginalImplantAssemblyTemplateSequence", 0x0076000C,
          "Original Implant Assembly Template Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDerivationImplantAssemblyTemplateSequence
      //(0076,000E)
      = const Tag.public(
          "DerivationImplantAssemblyTemplateSequence",
          0x0076000E,
          "Derivation Implant Assembly Template Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kImplantAssemblyTemplateTargetAnatomySequence
      //(0076,0010)
      = const Tag.public(
          "ImplantAssemblyTemplateTargetAnatomySequence",
          0x00760010,
          "Implant Assembly Template Target Anatomy Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kProcedureTypeCodeSequence
      //(0076,0020)
      = const Tag.public("ProcedureTypeCodeSequence", 0x00760020,
          "Procedure Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurgicalTechnique
      //(0076,0030)
      = const Tag.public("SurgicalTechnique", 0x00760030, "Surgical Technique",
          VR.kLO, VM.k1, false);
  static const Tag kComponentTypesSequence
      //(0076,0032)
      = const Tag.public("ComponentTypesSequence", 0x00760032,
          "Component Types Sequence", VR.kSQ, VM.k1, false);
  static const Tag kComponentTypeCodeSequence
      //(0076,0034)
      = const Tag.public("ComponentTypeCodeSequence", 0x00760034,
          "Component Type Code Sequence", VR.kCS, VM.k1, false);
  static const Tag kExclusiveComponentType
      //(0076,0036)
      = const Tag.public("ExclusiveComponentType", 0x00760036,
          "Exclusive Component Type", VR.kCS, VM.k1, false);
  static const Tag kMandatoryComponentType
      //(0076,0038)
      = const Tag.public("MandatoryComponentType", 0x00760038,
          "Mandatory Component Type", VR.kCS, VM.k1, false);
  static const Tag kComponentSequence
      //(0076,0040)
      = const Tag.public("ComponentSequence", 0x00760040, "Component Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kComponentID
      //(0076,0055)
      = const Tag.public(
          "ComponentID", 0x00760055, "Component ID", VR.kUS, VM.k1, false);
  static const Tag kComponentAssemblySequence
      //(0076,0060)
      = const Tag.public("ComponentAssemblySequence", 0x00760060,
          "Component Assembly Sequence", VR.kSQ, VM.k1, false);
  static const Tag kComponent1ReferencedID
      //(0076,0070)
      = const Tag.public("Component1ReferencedID", 0x00760070,
          "Component 1 Referenced ID", VR.kUS, VM.k1, false);
  static const Tag kComponent1ReferencedMatingFeatureSetID
      //(0076,0080)
      = const Tag.public("Component1ReferencedMatingFeatureSetID", 0x00760080,
          "Component 1 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const Tag kComponent1ReferencedMatingFeatureID
      //(0076,0090)
      = const Tag.public("Component1ReferencedMatingFeatureID", 0x00760090,
          "Component 1 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const Tag kComponent2ReferencedID
      //(0076,00A0)
      = const Tag.public("Component2ReferencedID", 0x007600A0,
          "Component 2 Referenced ID", VR.kUS, VM.k1, false);
  static const Tag kComponent2ReferencedMatingFeatureSetID
      //(0076,00B0)
      = const Tag.public("Component2ReferencedMatingFeatureSetID", 0x007600B0,
          "Component 2 Referenced Mating Feature Set ID", VR.kUS, VM.k1, false);
  static const Tag kComponent2ReferencedMatingFeatureID
      //(0076,00C0)
      = const Tag.public("Component2ReferencedMatingFeatureID", 0x007600C0,
          "Component 2 Referenced Mating Feature ID", VR.kUS, VM.k1, false);
  static const Tag kImplantTemplateGroupName
      //(0078,0001)
      = const Tag.public("ImplantTemplateGroupName", 0x00780001,
          "Implant Template Group Name", VR.kLO, VM.k1, false);
  static const Tag kImplantTemplateGroupDescription
      //(0078,0010)
      = const Tag.public("ImplantTemplateGroupDescription", 0x00780010,
          "Implant Template Group Description", VR.kST, VM.k1, false);
  static const Tag kImplantTemplateGroupIssuer
      //(0078,0020)
      = const Tag.public("ImplantTemplateGroupIssuer", 0x00780020,
          "Implant Template Group Issuer", VR.kLO, VM.k1, false);
  static const Tag kImplantTemplateGroupVersion
      //(0078,0024)
      = const Tag.public("ImplantTemplateGroupVersion", 0x00780024,
          "Implant Template Group Version", VR.kLO, VM.k1, false);
  static const Tag kReplacedImplantTemplateGroupSequence
      //(0078,0026)
      = const Tag.public("ReplacedImplantTemplateGroupSequence", 0x00780026,
          "Replaced Implant Template Group Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantTemplateGroupTargetAnatomySequence
      //(0078,0028)
      = const Tag.public(
          "ImplantTemplateGroupTargetAnatomySequence",
          0x00780028,
          "Implant Template Group Target Anatomy Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kImplantTemplateGroupMembersSequence
      //(0078,002A)
      = const Tag.public("ImplantTemplateGroupMembersSequence", 0x0078002A,
          "Implant Template Group Members Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImplantTemplateGroupMemberID
      //(0078,002E)
      = const Tag.public("ImplantTemplateGroupMemberID", 0x0078002E,
          "Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const Tag kThreeDImplantTemplateGroupMemberMatchingPoint
      //(0078,0050)
      = const Tag.public(
          "ThreeDImplantTemplateGroupMemberMatchingPoint",
          0x00780050,
          "3D Implant Template Group Member Matching Point",
          VR.kFD,
          VM.k3,
          false);
  static const Tag kThreeDImplantTemplateGroupMemberMatchingAxes
      //(0078,0060)
      = const Tag.public(
          "ThreeDImplantTemplateGroupMemberMatchingAxes",
          0x00780060,
          "3D Implant Template Group Member Matching Axes",
          VR.kFD,
          VM.k9,
          false);
  static const Tag kImplantTemplateGroupMemberMatching2DCoordinatesSequence
      //(0078,0070)
      = const Tag.public(
          "ImplantTemplateGroupMemberMatching2DCoordinatesSequence",
          0x00780070,
          "Implant Template Group Member Matching 2D Coordinates Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kTwoDImplantTemplateGroupMemberMatchingPoint
      //(0078,0090)
      = const Tag.public(
          "TwoDImplantTemplateGroupMemberMatchingPoint",
          0x00780090,
          "2D Implant Template Group Member Matching Point",
          VR.kFD,
          VM.k2,
          false);
  static const Tag kTwoDImplantTemplateGroupMemberMatchingAxes
      //(0078,00A0)
      = const Tag.public(
          "TwoDImplantTemplateGroupMemberMatchingAxes",
          0x007800A0,
          "2D Implant Template Group Member Matching Axes",
          VR.kFD,
          VM.k4,
          false);
  static const Tag kImplantTemplateGroupVariationDimensionSequence
      //(0078,00B0)
      = const Tag.public(
          "ImplantTemplateGroupVariationDimensionSequence",
          0x007800B0,
          "Implant Template Group Variation Dimension Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kImplantTemplateGroupVariationDimensionName
      //(0078,00B2)
      = const Tag.public(
          "ImplantTemplateGroupVariationDimensionName",
          0x007800B2,
          "Implant Template Group Variation Dimension Name",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kImplantTemplateGroupVariationDimensionRankSequence
      //(0078,00B4)
      = const Tag.public(
          "ImplantTemplateGroupVariationDimensionRankSequence",
          0x007800B4,
          "Implant Template Group Variation Dimension Rank Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReferencedImplantTemplateGroupMemberID
      //(0078,00B6)
      = const Tag.public("ReferencedImplantTemplateGroupMemberID", 0x007800B6,
          "Referenced Implant Template Group Member ID", VR.kUS, VM.k1, false);
  static const Tag kImplantTemplateGroupVariationDimensionRank
      //(0078,00B8)
      = const Tag.public(
          "ImplantTemplateGroupVariationDimensionRank",
          0x007800B8,
          "Implant Template Group Variation Dimension Rank",
          VR.kUS,
          VM.k1,
          false);
  static const Tag kSurfaceScanAcquisitionTypeCodeSequence
      //(0080,0001)
      = const Tag.public("SurfaceScanAcquisitionTypeCodeSequence", 0x00800001,
          "Surface Scan Acquisition Type Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSurfaceScanModeCodeSequence
      //(0080,0002)
      = const Tag.public("SurfaceScanModeCodeSequence", 0x00800002,
          "Surface Scan Mode Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRegistrationMethodCodeSequence
      //(0080,0003)
      = const Tag.public("RegistrationMethodCodeSequence", 0x00800003,
          "Registration Method Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kShotDurationTime
      //(0080,0004)
      = const Tag.public("ShotDurationTime", 0x00800004, "Shot Duration Time",
          VR.kFD, VM.k1, false);
  static const Tag kShotOffsetTime
      //(0080,0005)
      = const Tag.public("ShotOffsetTime", 0x00800005, "Shot Offset Time",
          VR.kFD, VM.k1, false);
  static const Tag kSurfacePointPresentationValueData
      //(0080,0006)
      = const Tag.public("SurfacePointPresentationValueData", 0x00800006,
          "Surface Point Presentation Value Data", VR.kUS, VM.k1_n, false);
  static const Tag kSurfacePointColorCIELabValueData
      //(0080,0007)
      = const Tag.public("SurfacePointColorCIELabValueData", 0x00800007,
          "Surface Point Color CIELab Value Data", VR.kUS, VM.k3_3n, false);
  static const Tag kUVMappingSequence
      //(0080,0008)
      = const Tag.public("UVMappingSequence", 0x00800008, "UV Mapping Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kTextureLabel
      //(0080,0009)
      = const Tag.public(
          "TextureLabel", 0x00800009, "Texture Label", VR.kSH, VM.k1, false);
  static const Tag kUValueData
      //(0080,0010)
      = const Tag.public(
          "UValueData", 0x00800010, "U Value Data", VR.kOF, VM.k1_n, false);
  static const Tag kVValueData
      //(0080,0011)
      = const Tag.public(
          "VValueData", 0x00800011, "V Value Data", VR.kOF, VM.k1_n, false);
  static const Tag kReferencedTextureSequence
      //(0080,0012)
      = const Tag.public("ReferencedTextureSequence", 0x00800012,
          "Referenced Texture Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSurfaceDataSequence
      //(0080,0013)
      = const Tag.public("ReferencedSurfaceDataSequence", 0x00800013,
          "Referenced Surface Data Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStorageMediaFileSetID
      //(0088,0130)
      = const Tag.public("StorageMediaFileSetID", 0x00880130,
          "Storage Media File-set ID", VR.kSH, VM.k1, false);
  static const Tag kStorageMediaFileSetUID
      //(0088,0140)
      = const Tag.public("StorageMediaFileSetUID", 0x00880140,
          "Storage Media File-set UID", VR.kUI, VM.k1, false);
  static const Tag kIconImageSequence
      //(0088,0200)
      = const Tag.public("IconImageSequence", 0x00880200, "Icon Image Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kTopicTitle
      //(0088,0904)
      = const Tag.public(
          "TopicTitle", 0x00880904, "Topic Title", VR.kLO, VM.k1, true);
  static const Tag kTopicSubject
      //(0088,0906)
      = const Tag.public(
          "TopicSubject", 0x00880906, "Topic Subject", VR.kST, VM.k1, true);
  static const Tag kTopicAuthor
      //(0088,0910)
      = const Tag.public(
          "TopicAuthor", 0x00880910, "Topic Author", VR.kLO, VM.k1, true);
  static const Tag kTopicKeywords
      //(0088,0912)
      = const Tag.public("TopicKeywords", 0x00880912, "Topic Keywords", VR.kLO,
          VM.k1_32, true);
  static const Tag kSOPInstanceStatus
      //(0100,0410)
      = const Tag.public("SOPInstanceStatus", 0x01000410, "SOP Instance Status",
          VR.kCS, VM.k1, false);
  static const Tag kSOPAuthorizationDateTime
      //(0100,0420)
      = const Tag.public("SOPAuthorizationDateTime", 0x01000420,
          "SOP Authorization DateTime", VR.kDT, VM.k1, false);
  static const Tag kSOPAuthorizationComment
      //(0100,0424)
      = const Tag.public("SOPAuthorizationComment", 0x01000424,
          "SOP Authorization Comment", VR.kLT, VM.k1, false);
  static const Tag kAuthorizationEquipmentCertificationNumber
      //(0100,0426)
      = const Tag.public(
          "AuthorizationEquipmentCertificationNumber",
          0x01000426,
          "Authorization Equipment Certification Number",
          VR.kLO,
          VM.k1,
          false);
  static const Tag kMACIDNumber
      //(0400,0005)
      = const Tag.public(
          "MACIDNumber", 0x04000005, "MAC ID Number", VR.kUS, VM.k1, false);
  static const Tag kMACCalculationTransferSyntaxUID
      //(0400,0010)
      = const Tag.public("MACCalculationTransferSyntaxUID", 0x04000010,
          "MAC Calculation Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const Tag kMACAlgorithm
      //(0400,0015)
      = const Tag.public(
          "MACAlgorithm", 0x04000015, "MAC Algorithm", VR.kCS, VM.k1, false);
  static const Tag kDataElementsSigned
      //(0400,0020)
      = const Tag.public("DataElementsSigned", 0x04000020,
          "Data Elements Signed", VR.kAT, VM.k1_n, false);
  static const Tag kDigitalSignatureUID
      //(0400,0100)
      = const Tag.public("DigitalSignatureUID", 0x04000100,
          "Digital Signature UID", VR.kUI, VM.k1, false);
  static const Tag kDigitalSignatureDateTime
      //(0400,0105)
      = const Tag.public("DigitalSignatureDateTime", 0x04000105,
          "Digital Signature DateTime", VR.kDT, VM.k1, false);
  static const Tag kCertificateType
      //(0400,0110)
      = const Tag.public("CertificateType", 0x04000110, "Certificate Type",
          VR.kCS, VM.k1, false);
  static const Tag kCertificateOfSigner
      //(0400,0115)
      = const Tag.public("CertificateOfSigner", 0x04000115,
          "Certificate of Signer", VR.kOB, VM.k1, false);
  static const Tag kSignature
      //(0400,0120)
      = const Tag.public(
          "Signature", 0x04000120, "Signature", VR.kOB, VM.k1, false);
  static const Tag kCertifiedTimestampType
      //(0400,0305)
      = const Tag.public("CertifiedTimestampType", 0x04000305,
          "Certified Timestamp Type", VR.kCS, VM.k1, false);
  static const Tag kCertifiedTimestamp
      //(0400,0310)
      = const Tag.public("CertifiedTimestamp", 0x04000310,
          "Certified Timestamp", VR.kOB, VM.k1, false);
  static const Tag kDigitalSignaturePurposeCodeSequence
      //(0400,0401)
      = const Tag.public("DigitalSignaturePurposeCodeSequence", 0x04000401,
          "Digital Signature Purpose Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedDigitalSignatureSequence
      //(0400,0402)
      = const Tag.public("ReferencedDigitalSignatureSequence", 0x04000402,
          "Referenced Digital Signature Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSOPInstanceMACSequence
      //(0400,0403)
      = const Tag.public("ReferencedSOPInstanceMACSequence", 0x04000403,
          "Referenced SOP Instance MAC Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMAC
      //(0400,0404)
      = const Tag.public("MAC", 0x04000404, "MAC", VR.kOB, VM.k1, false);
  static const Tag kEncryptedAttributesSequence
      //(0400,0500)
      = const Tag.public("EncryptedAttributesSequence", 0x04000500,
          "Encrypted Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kEncryptedContentTransferSyntaxUID
      //(0400,0510)
      = const Tag.public("EncryptedContentTransferSyntaxUID", 0x04000510,
          "Encrypted Content Transfer Syntax UID", VR.kUI, VM.k1, false);
  static const Tag kEncryptedContent
      //(0400,0520)
      = const Tag.public("EncryptedContent", 0x04000520, "Encrypted Content",
          VR.kOB, VM.k1, false);
  static const Tag kModifiedAttributesSequence
      //(0400,0550)
      = const Tag.public("ModifiedAttributesSequence", 0x04000550,
          "Modified Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOriginalAttributesSequence
      //(0400,0561)
      = const Tag.public("OriginalAttributesSequence", 0x04000561,
          "Original Attributes Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAttributeModificationDateTime
      //(0400,0562)
      = const Tag.public("AttributeModificationDateTime", 0x04000562,
          "Attribute Modification DateTime", VR.kDT, VM.k1, false);
  static const Tag kModifyingSystem
      //(0400,0563)
      = const Tag.public("ModifyingSystem", 0x04000563, "Modifying System",
          VR.kLO, VM.k1, false);
  static const Tag kSourceOfPreviousValues
      //(0400,0564)
      = const Tag.public("SourceOfPreviousValues", 0x04000564,
          "Source of Previous Values", VR.kLO, VM.k1, false);
  static const Tag kReasonForTheAttributeModification
      //(0400,0565)
      = const Tag.public("ReasonForTheAttributeModification", 0x04000565,
          "Reason for the Attribute Modification", VR.kCS, VM.k1, false);
  static const Tag kEscapeTriplet
      //(1000,0000)
      = const Tag.public(
          "EscapeTriplet", 0x10000000, "Escape Triplet", VR.kUS, VM.k3, true);
  static const Tag kRunLengthTriplet
      //(1000,0001)
      = const Tag.public("RunLengthTriplet", 0x10000001, "Run Length Triplet",
          VR.kUS, VM.k3, true);
  static const Tag kHuffmanTableSize
      //(1000,0002)
      = const Tag.public("HuffmanTableSize", 0x10000002, "Huffman Table Size",
          VR.kUS, VM.k1, true);
  static const Tag kHuffmanTableTriplet
      //(1000,0003)
      = const Tag.public("HuffmanTableTriplet", 0x10000003,
          "Huffman Table Triplet", VR.kUS, VM.k3, true);
  static const Tag kShiftTableSize
      //(1000,0004)
      = const Tag.public("ShiftTableSize", 0x10000004, "Shift Table Size",
          VR.kUS, VM.k1, true);
  static const Tag kShiftTableTriplet
      //(1000,0005)
      = const Tag.public("ShiftTableTriplet", 0x10000005, "Shift Table Triplet",
          VR.kUS, VM.k3, true);
  static const Tag kZonalMap
      //(1010,0000)
      = const Tag.public(
          "ZonalMap", 0x10100000, "Zonal Map", VR.kUS, VM.k1_n, true);
  static const Tag kNumberOfCopies
      //(2000,0010)
      = const Tag.public("NumberOfCopies", 0x20000010, "Number of Copies",
          VR.kIS, VM.k1, false);
  static const Tag kPrinterConfigurationSequence
      //(2000,001E)
      = const Tag.public("PrinterConfigurationSequence", 0x2000001E,
          "Printer Configuration Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrintPriority
      //(2000,0020)
      = const Tag.public(
          "PrintPriority", 0x20000020, "Print Priority", VR.kCS, VM.k1, false);
  static const Tag kMediumType
      //(2000,0030)
      = const Tag.public(
          "MediumType", 0x20000030, "Medium Type", VR.kCS, VM.k1, false);
  static const Tag kFilmDestination
      //(2000,0040)
      = const Tag.public("FilmDestination", 0x20000040, "Film Destination",
          VR.kCS, VM.k1, false);
  static const Tag kFilmSessionLabel
      //(2000,0050)
      = const Tag.public("FilmSessionLabel", 0x20000050, "Film Session Label",
          VR.kLO, VM.k1, false);
  static const Tag kMemoryAllocation
      //(2000,0060)
      = const Tag.public("MemoryAllocation", 0x20000060, "Memory Allocation",
          VR.kIS, VM.k1, false);
  static const Tag kMaximumMemoryAllocation
      //(2000,0061)
      = const Tag.public("MaximumMemoryAllocation", 0x20000061,
          "Maximum Memory Allocation", VR.kIS, VM.k1, false);
  static const Tag kColorImagePrintingFlag
      //(2000,0062)
      = const Tag.public("ColorImagePrintingFlag", 0x20000062,
          "Color Image Printing Flag", VR.kCS, VM.k1, true);
  static const Tag kCollationFlag
      //(2000,0063)
      = const Tag.public(
          "CollationFlag", 0x20000063, "Collation Flag", VR.kCS, VM.k1, true);
  static const Tag kAnnotationFlag
      //(2000,0065)
      = const Tag.public(
          "AnnotationFlag", 0x20000065, "Annotation Flag", VR.kCS, VM.k1, true);
  static const Tag kImageOverlayFlag
      //(2000,0067)
      = const Tag.public("ImageOverlayFlag", 0x20000067, "Image Overlay Flag",
          VR.kCS, VM.k1, true);
  static const Tag kPresentationLUTFlag
      //(2000,0069)
      = const Tag.public("PresentationLUTFlag", 0x20000069,
          "Presentation LUT Flag", VR.kCS, VM.k1, true);
  static const Tag kImageBoxPresentationLUTFlag
      //(2000,006A)
      = const Tag.public("ImageBoxPresentationLUTFlag", 0x2000006A,
          "Image Box Presentation LUT Flag", VR.kCS, VM.k1, true);
  static const Tag kMemoryBitDepth
      //(2000,00A0)
      = const Tag.public("MemoryBitDepth", 0x200000A0, "Memory Bit Depth",
          VR.kUS, VM.k1, false);
  static const Tag kPrintingBitDepth
      //(2000,00A1)
      = const Tag.public("PrintingBitDepth", 0x200000A1, "Printing Bit Depth",
          VR.kUS, VM.k1, false);
  static const Tag kMediaInstalledSequence
      //(2000,00A2)
      = const Tag.public("MediaInstalledSequence", 0x200000A2,
          "Media Installed Sequence", VR.kSQ, VM.k1, false);
  static const Tag kOtherMediaAvailableSequence
      //(2000,00A4)
      = const Tag.public("OtherMediaAvailableSequence", 0x200000A4,
          "Other Media Available Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSupportedImageDisplayFormatsSequence
      //(2000,00A8)
      = const Tag.public("SupportedImageDisplayFormatsSequence", 0x200000A8,
          "Supported Image Display Formats Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedFilmBoxSequence
      //(2000,0500)
      = const Tag.public("ReferencedFilmBoxSequence", 0x20000500,
          "Referenced Film Box Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedStoredPrintSequence
      //(2000,0510)
      = const Tag.public("ReferencedStoredPrintSequence", 0x20000510,
          "Referenced Stored Print Sequence", VR.kSQ, VM.k1, true);
  static const Tag kImageDisplayFormat
      //(2010,0010)
      = const Tag.public("ImageDisplayFormat", 0x20100010,
          "Image Display Format", VR.kST, VM.k1, false);
  static const Tag kAnnotationDisplayFormatID
      //(2010,0030)
      = const Tag.public("AnnotationDisplayFormatID", 0x20100030,
          "Annotation Display Format ID", VR.kCS, VM.k1, false);
  static const Tag kFilmOrientation
      //(2010,0040)
      = const Tag.public("FilmOrientation", 0x20100040, "Film Orientation",
          VR.kCS, VM.k1, false);
  static const Tag kFilmSizeID
      //(2010,0050)
      = const Tag.public(
          "FilmSizeID", 0x20100050, "Film Size ID", VR.kCS, VM.k1, false);
  static const Tag kPrinterResolutionID
      //(2010,0052)
      = const Tag.public("PrinterResolutionID", 0x20100052,
          "Printer Resolution ID", VR.kCS, VM.k1, false);
  static const Tag kDefaultPrinterResolutionID
      //(2010,0054)
      = const Tag.public("DefaultPrinterResolutionID", 0x20100054,
          "Default Printer Resolution ID", VR.kCS, VM.k1, false);
  static const Tag kMagnificationType
      //(2010,0060)
      = const Tag.public("MagnificationType", 0x20100060, "Magnification Type",
          VR.kCS, VM.k1, false);
  static const Tag kSmoothingType
      //(2010,0080)
      = const Tag.public(
          "SmoothingType", 0x20100080, "Smoothing Type", VR.kCS, VM.k1, false);
  static const Tag kDefaultMagnificationType
      //(2010,00A6)
      = const Tag.public("DefaultMagnificationType", 0x201000A6,
          "Default Magnification Type", VR.kCS, VM.k1, false);
  static const Tag kOtherMagnificationTypesAvailable
      //(2010,00A7)
      = const Tag.public("OtherMagnificationTypesAvailable", 0x201000A7,
          "Other Magnification Types Available", VR.kCS, VM.k1_n, false);
  static const Tag kDefaultSmoothingType
      //(2010,00A8)
      = const Tag.public("DefaultSmoothingType", 0x201000A8,
          "Default Smoothing Type", VR.kCS, VM.k1, false);
  static const Tag kOtherSmoothingTypesAvailable
      //(2010,00A9)
      = const Tag.public("OtherSmoothingTypesAvailable", 0x201000A9,
          "Other Smoothing Types Available", VR.kCS, VM.k1_n, false);
  static const Tag kBorderDensity
      //(2010,0100)
      = const Tag.public(
          "BorderDensity", 0x20100100, "Border Density", VR.kCS, VM.k1, false);
  static const Tag kEmptyImageDensity
      //(2010,0110)
      = const Tag.public("EmptyImageDensity", 0x20100110, "Empty Image Density",
          VR.kCS, VM.k1, false);
  static const Tag kMinDensity
      //(2010,0120)
      = const Tag.public(
          "MinDensity", 0x20100120, "Min Density", VR.kUS, VM.k1, false);
  static const Tag kMaxDensity
      //(2010,0130)
      = const Tag.public(
          "MaxDensity", 0x20100130, "Max Density", VR.kUS, VM.k1, false);
  static const Tag kTrim
      //(2010,0140)
      = const Tag.public("Trim", 0x20100140, "Trim", VR.kCS, VM.k1, false);
  static const Tag kConfigurationInformation
      //(2010,0150)
      = const Tag.public("ConfigurationInformation", 0x20100150,
          "Configuration Information", VR.kST, VM.k1, false);
  static const Tag kConfigurationInformationDescription
      //(2010,0152)
      = const Tag.public("ConfigurationInformationDescription", 0x20100152,
          "Configuration Information Description", VR.kLT, VM.k1, false);
  static const Tag kMaximumCollatedFilms
      //(2010,0154)
      = const Tag.public("MaximumCollatedFilms", 0x20100154,
          "Maximum Collated Films", VR.kIS, VM.k1, false);
  static const Tag kIllumination
      //(2010,015E)
      = const Tag.public(
          "Illumination", 0x2010015E, "Illumination", VR.kUS, VM.k1, false);
  static const Tag kReflectedAmbientLight
      //(2010,0160)
      = const Tag.public("ReflectedAmbientLight", 0x20100160,
          "Reflected Ambient Light", VR.kUS, VM.k1, false);
  static const Tag kPrinterPixelSpacing
      //(2010,0376)
      = const Tag.public("PrinterPixelSpacing", 0x20100376,
          "Printer Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kReferencedFilmSessionSequence
      //(2010,0500)
      = const Tag.public("ReferencedFilmSessionSequence", 0x20100500,
          "Referenced Film Session Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedImageBoxSequence
      //(2010,0510)
      = const Tag.public("ReferencedImageBoxSequence", 0x20100510,
          "Referenced Image Box Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedBasicAnnotationBoxSequence
      //(2010,0520)
      = const Tag.public("ReferencedBasicAnnotationBoxSequence", 0x20100520,
          "Referenced Basic Annotation Box Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImageBoxPosition
      //(2020,0010)
      = const Tag.public("ImageBoxPosition", 0x20200010, "Image Box Position",
          VR.kUS, VM.k1, false);
  static const Tag kPolarity
      //(2020,0020)
      = const Tag.public(
          "Polarity", 0x20200020, "Polarity", VR.kCS, VM.k1, false);
  static const Tag kRequestedImageSize
      //(2020,0030)
      = const Tag.public("RequestedImageSize", 0x20200030,
          "Requested Image Size", VR.kDS, VM.k1, false);
  static const Tag kRequestedDecimateCropBehavior
      //(2020,0040)
      = const Tag.public("RequestedDecimateCropBehavior", 0x20200040,
          "Requested Decimate/Crop Behavior", VR.kCS, VM.k1, false);
  static const Tag kRequestedResolutionID
      //(2020,0050)
      = const Tag.public("RequestedResolutionID", 0x20200050,
          "Requested Resolution ID", VR.kCS, VM.k1, false);
  static const Tag kRequestedImageSizeFlag
      //(2020,00A0)
      = const Tag.public("RequestedImageSizeFlag", 0x202000A0,
          "Requested Image Size Flag", VR.kCS, VM.k1, false);
  static const Tag kDecimateCropResult
      //(2020,00A2)
      = const Tag.public("DecimateCropResult", 0x202000A2,
          "Decimate/Crop Result", VR.kCS, VM.k1, false);
  static const Tag kBasicGrayscaleImageSequence
      //(2020,0110)
      = const Tag.public("BasicGrayscaleImageSequence", 0x20200110,
          "Basic Grayscale Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBasicColorImageSequence
      //(2020,0111)
      = const Tag.public("BasicColorImageSequence", 0x20200111,
          "Basic Color Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedImageOverlayBoxSequence
      //(2020,0130)
      = const Tag.public("ReferencedImageOverlayBoxSequence", 0x20200130,
          "Referenced Image Overlay Box Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedVOILUTBoxSequence
      //(2020,0140)
      = const Tag.public("ReferencedVOILUTBoxSequence", 0x20200140,
          "Referenced VOI LUT Box Sequence", VR.kSQ, VM.k1, true);
  static const Tag kAnnotationPosition
      //(2030,0010)
      = const Tag.public("AnnotationPosition", 0x20300010,
          "Annotation Position", VR.kUS, VM.k1, false);
  static const Tag kTextString
      //(2030,0020)
      = const Tag.public(
          "TextString", 0x20300020, "Text String", VR.kLO, VM.k1, false);
  static const Tag kReferencedOverlayPlaneSequence
      //(2040,0010)
      = const Tag.public("ReferencedOverlayPlaneSequence", 0x20400010,
          "Referenced Overlay Plane Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedOverlayPlaneGroups
      //(2040,0011)
      = const Tag.public("ReferencedOverlayPlaneGroups", 0x20400011,
          "Referenced Overlay Plane Groups", VR.kUS, VM.k1_99, true);
  static const Tag kOverlayPixelDataSequence
      //(2040,0020)
      = const Tag.public("OverlayPixelDataSequence", 0x20400020,
          "Overlay Pixel Data Sequence", VR.kSQ, VM.k1, true);
  static const Tag kOverlayMagnificationType
      //(2040,0060)
      = const Tag.public("OverlayMagnificationType", 0x20400060,
          "Overlay Magnification Type", VR.kCS, VM.k1, true);
  static const Tag kOverlaySmoothingType
      //(2040,0070)
      = const Tag.public("OverlaySmoothingType", 0x20400070,
          "Overlay Smoothing Type", VR.kCS, VM.k1, true);
  static const Tag kOverlayOrImageMagnification
      //(2040,0072)
      = const Tag.public("OverlayOrImageMagnification", 0x20400072,
          "Overlay or Image Magnification", VR.kCS, VM.k1, true);
  static const Tag kMagnifyToNumberOfColumns
      //(2040,0074)
      = const Tag.public("MagnifyToNumberOfColumns", 0x20400074,
          "Magnify to Number of Columns", VR.kUS, VM.k1, true);
  static const Tag kOverlayForegroundDensity
      //(2040,0080)
      = const Tag.public("OverlayForegroundDensity", 0x20400080,
          "Overlay Foreground Density", VR.kCS, VM.k1, true);
  static const Tag kOverlayBackgroundDensity
      //(2040,0082)
      = const Tag.public("OverlayBackgroundDensity", 0x20400082,
          "Overlay Background Density", VR.kCS, VM.k1, true);
  static const Tag kOverlayMode
      //(2040,0090)
      = const Tag.public(
          "OverlayMode", 0x20400090, "Overlay Mode", VR.kCS, VM.k1, true);
  static const Tag kThresholdDensity
      //(2040,0100)
      = const Tag.public("ThresholdDensity", 0x20400100, "Threshold Density",
          VR.kCS, VM.k1, true);
  static const Tag kReferencedImageBoxSequenceRetired
      //(2040,0500)
      = const Tag.public("ReferencedImageBoxSequenceRetired", 0x20400500,
          "Referenced Image Box Sequence (Retired)", VR.kSQ, VM.k1, true);
  static const Tag kPresentationLUTSequence
      //(2050,0010)
      = const Tag.public("PresentationLUTSequence", 0x20500010,
          "Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPresentationLUTShape
      //(2050,0020)
      = const Tag.public("PresentationLUTShape", 0x20500020,
          "Presentation LUT Shape", VR.kCS, VM.k1, false);
  static const Tag kReferencedPresentationLUTSequence
      //(2050,0500)
      = const Tag.public("ReferencedPresentationLUTSequence", 0x20500500,
          "Referenced Presentation LUT Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPrintJobID
      //(2100,0010)
      = const Tag.public(
          "PrintJobID", 0x21000010, "Print Job ID", VR.kSH, VM.k1, true);
  static const Tag kExecutionStatus
      //(2100,0020)
      = const Tag.public("ExecutionStatus", 0x21000020, "Execution Status",
          VR.kCS, VM.k1, false);
  static const Tag kExecutionStatusInfo
      //(2100,0030)
      = const Tag.public("ExecutionStatusInfo", 0x21000030,
          "Execution Status Info", VR.kCS, VM.k1, false);
  static const Tag kCreationDate
      //(2100,0040)
      = const Tag.public(
          "CreationDate", 0x21000040, "Creation Date", VR.kDA, VM.k1, false);
  static const Tag kCreationTime
      //(2100,0050)
      = const Tag.public(
          "CreationTime", 0x21000050, "Creation Time", VR.kTM, VM.k1, false);
  static const Tag kOriginator
      //(2100,0070)
      = const Tag.public(
          "Originator", 0x21000070, "Originator", VR.kAE, VM.k1, false);
  static const Tag kDestinationAE
      //(2100,0140)
      = const Tag.public(
          "DestinationAE", 0x21000140, "Destination AE", VR.kAE, VM.k1, true);
  static const Tag kOwnerID
      //(2100,0160)
      =
      const Tag.public("OwnerID", 0x21000160, "Owner ID", VR.kSH, VM.k1, false);
  static const Tag kNumberOfFilms
      //(2100,0170)
      = const Tag.public(
          "NumberOfFilms", 0x21000170, "Number of Films", VR.kIS, VM.k1, false);
  static const Tag kReferencedPrintJobSequencePullStoredPrint
      //(2100,0500)
      = const Tag.public(
          "ReferencedPrintJobSequencePullStoredPrint",
          0x21000500,
          "Referenced Print Job Sequence (Pull Stored Print)",
          VR.kSQ,
          VM.k1,
          true);
  static const Tag kPrinterStatus
      //(2110,0010)
      = const Tag.public(
          "PrinterStatus", 0x21100010, "Printer Status", VR.kCS, VM.k1, false);
  static const Tag kPrinterStatusInfo
      //(2110,0020)
      = const Tag.public("PrinterStatusInfo", 0x21100020, "Printer Status Info",
          VR.kCS, VM.k1, false);
  static const Tag kPrinterName
      //(2110,0030)
      = const Tag.public(
          "PrinterName", 0x21100030, "Printer Name", VR.kLO, VM.k1, false);
  static const Tag kPrintQueueID
      //(2110,0099)
      = const Tag.public(
          "PrintQueueID", 0x21100099, "Print Queue ID", VR.kSH, VM.k1, true);
  static const Tag kQueueStatus
      //(2120,0010)
      = const Tag.public(
          "QueueStatus", 0x21200010, "Queue Status", VR.kCS, VM.k1, true);
  static const Tag kPrintJobDescriptionSequence
      //(2120,0050)
      = const Tag.public("PrintJobDescriptionSequence", 0x21200050,
          "Print Job Description Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReferencedPrintJobSequence
      //(2120,0070)
      = const Tag.public("ReferencedPrintJobSequence", 0x21200070,
          "Referenced Print Job Sequence", VR.kSQ, VM.k1, true);
  static const Tag kPrintManagementCapabilitiesSequence
      //(2130,0010)
      = const Tag.public("PrintManagementCapabilitiesSequence", 0x21300010,
          "Print Management Capabilities Sequence", VR.kSQ, VM.k1, true);
  static const Tag kPrinterCharacteristicsSequence
      //(2130,0015)
      = const Tag.public("PrinterCharacteristicsSequence", 0x21300015,
          "Printer Characteristics Sequence", VR.kSQ, VM.k1, true);
  static const Tag kFilmBoxContentSequence
      //(2130,0030)
      = const Tag.public("FilmBoxContentSequence", 0x21300030,
          "Film Box Content Sequence", VR.kSQ, VM.k1, true);
  static const Tag kImageBoxContentSequence
      //(2130,0040)
      = const Tag.public("ImageBoxContentSequence", 0x21300040,
          "Image Box Content Sequence", VR.kSQ, VM.k1, true);
  static const Tag kAnnotationContentSequence
      //(2130,0050)
      = const Tag.public("AnnotationContentSequence", 0x21300050,
          "Annotation Content Sequence", VR.kSQ, VM.k1, true);
  static const Tag kImageOverlayBoxContentSequence
      //(2130,0060)
      = const Tag.public("ImageOverlayBoxContentSequence", 0x21300060,
          "Image Overlay Box Content Sequence", VR.kSQ, VM.k1, true);
  static const Tag kPresentationLUTContentSequence
      //(2130,0080)
      = const Tag.public("PresentationLUTContentSequence", 0x21300080,
          "Presentation LUT Content Sequence", VR.kSQ, VM.k1, true);
  static const Tag kProposedStudySequence
      //(2130,00A0)
      = const Tag.public("ProposedStudySequence", 0x213000A0,
          "Proposed Study Sequence", VR.kSQ, VM.k1, true);
  static const Tag kOriginalImageSequence
      //(2130,00C0)
      = const Tag.public("OriginalImageSequence", 0x213000C0,
          "Original Image Sequence", VR.kSQ, VM.k1, true);
  static const Tag kLabelUsingInformationExtractedFromInstances
      //(2200,0001)
      = const Tag.public(
          "LabelUsingInformationExtractedFromInstances",
          0x22000001,
          "Label Using Information Extracted From Instances",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kLabelText
      //(2200,0002)
      = const Tag.public(
          "LabelText", 0x22000002, "Label Text", VR.kUT, VM.k1, false);
  static const Tag kLabelStyleSelection
      //(2200,0003)
      = const Tag.public("LabelStyleSelection", 0x22000003,
          "Label Style Selection", VR.kCS, VM.k1, false);
  static const Tag kMediaDisposition
      //(2200,0004)
      = const Tag.public("MediaDisposition", 0x22000004, "Media Disposition",
          VR.kLT, VM.k1, false);
  static const Tag kBarcodeValue
      //(2200,0005)
      = const Tag.public(
          "BarcodeValue", 0x22000005, "Barcode Value", VR.kLT, VM.k1, false);
  static const Tag kBarcodeSymbology
      //(2200,0006)
      = const Tag.public("BarcodeSymbology", 0x22000006, "Barcode Symbology",
          VR.kCS, VM.k1, false);
  static const Tag kAllowMediaSplitting
      //(2200,0007)
      = const Tag.public("AllowMediaSplitting", 0x22000007,
          "Allow Media Splitting", VR.kCS, VM.k1, false);
  static const Tag kIncludeNonDICOMObjects
      //(2200,0008)
      = const Tag.public("IncludeNonDICOMObjects", 0x22000008,
          "Include Non-DICOM Objects", VR.kCS, VM.k1, false);
  static const Tag kIncludeDisplayApplication
      //(2200,0009)
      = const Tag.public("IncludeDisplayApplication", 0x22000009,
          "Include Display Application", VR.kCS, VM.k1, false);
  static const Tag kPreserveCompositeInstancesAfterMediaCreation
      //(2200,000A)
      = const Tag.public(
          "PreserveCompositeInstancesAfterMediaCreation",
          0x2200000A,
          "Preserve Composite Instances After Media Creation",
          VR.kCS,
          VM.k1,
          false);
  static const Tag kTotalNumberOfPiecesOfMediaCreated
      //(2200,000B)
      = const Tag.public("TotalNumberOfPiecesOfMediaCreated", 0x2200000B,
          "Total Number of Pieces of Media Created", VR.kUS, VM.k1, false);
  static const Tag kRequestedMediaApplicationProfile
      //(2200,000C)
      = const Tag.public("RequestedMediaApplicationProfile", 0x2200000C,
          "Requested Media Application Profile", VR.kLO, VM.k1, false);
  static const Tag kReferencedStorageMediaSequence
      //(2200,000D)
      = const Tag.public("ReferencedStorageMediaSequence", 0x2200000D,
          "Referenced Storage Media Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFailureAttributes
      //(2200,000E)
      = const Tag.public("FailureAttributes", 0x2200000E, "Failure Attributes",
          VR.kAT, VM.k1_n, false);
  static const Tag kAllowLossyCompression
      //(2200,000F)
      = const Tag.public("AllowLossyCompression", 0x2200000F,
          "Allow Lossy Compression", VR.kCS, VM.k1, false);
  static const Tag kRequestPriority
      //(2200,0020)
      = const Tag.public("RequestPriority", 0x22000020, "Request Priority",
          VR.kCS, VM.k1, false);
  static const Tag kRTImageLabel
      //(3002,0002)
      = const Tag.public(
          "RTImageLabel", 0x30020002, "RT Image Label", VR.kSH, VM.k1, false);
  static const Tag kRTImageName
      //(3002,0003)
      = const Tag.public(
          "RTImageName", 0x30020003, "RT Image Name", VR.kLO, VM.k1, false);
  static const Tag kRTImageDescription
      //(3002,0004)
      = const Tag.public("RTImageDescription", 0x30020004,
          "RT Image Description", VR.kST, VM.k1, false);
  static const Tag kReportedValuesOrigin
      //(3002,000A)
      = const Tag.public("ReportedValuesOrigin", 0x3002000A,
          "Reported Values Origin", VR.kCS, VM.k1, false);
  static const Tag kRTImagePlane
      //(3002,000C)
      = const Tag.public(
          "RTImagePlane", 0x3002000C, "RT Image Plane", VR.kCS, VM.k1, false);
  static const Tag kXRayImageReceptorTranslation
      //(3002,000D)
      = const Tag.public("XRayImageReceptorTranslation", 0x3002000D,
          "X-Ray Image Receptor Translation", VR.kDS, VM.k3, false);
  static const Tag kXRayImageReceptorAngle
      //(3002,000E)
      = const Tag.public("XRayImageReceptorAngle", 0x3002000E,
          "X-Ray Image Receptor Angle", VR.kDS, VM.k1, false);
  static const Tag kRTImageOrientation
      //(3002,0010)
      = const Tag.public("RTImageOrientation", 0x30020010,
          "RT Image Orientation", VR.kDS, VM.k6, false);
  static const Tag kImagePlanePixelSpacing
      //(3002,0011)
      = const Tag.public("ImagePlanePixelSpacing", 0x30020011,
          "Image Plane Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kRTImagePosition
      //(3002,0012)
      = const Tag.public("RTImagePosition", 0x30020012, "RT Image Position",
          VR.kDS, VM.k2, false);
  static const Tag kRadiationMachineName
      //(3002,0020)
      = const Tag.public("RadiationMachineName", 0x30020020,
          "Radiation Machine Name", VR.kSH, VM.k1, false);
  static const Tag kRadiationMachineSAD
      //(3002,0022)
      = const Tag.public("RadiationMachineSAD", 0x30020022,
          "Radiation Machine SAD", VR.kDS, VM.k1, false);
  static const Tag kRadiationMachineSSD
      //(3002,0024)
      = const Tag.public("RadiationMachineSSD", 0x30020024,
          "Radiation Machine SSD", VR.kDS, VM.k1, false);
  static const Tag kRTImageSID
      //(3002,0026)
      = const Tag.public(
          "RTImageSID", 0x30020026, "RT Image SID", VR.kDS, VM.k1, false);
  static const Tag kSourceToReferenceObjectDistance
      //(3002,0028)
      = const Tag.public("SourceToReferenceObjectDistance", 0x30020028,
          "Source to Reference Object Distance", VR.kDS, VM.k1, false);
  static const Tag kFractionNumber
      //(3002,0029)
      = const Tag.public("FractionNumber", 0x30020029, "Fraction Number",
          VR.kIS, VM.k1, false);
  static const Tag kExposureSequence
      //(3002,0030)
      = const Tag.public("ExposureSequence", 0x30020030, "Exposure Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kMetersetExposure
      //(3002,0032)
      = const Tag.public("MetersetExposure", 0x30020032, "Meterset Exposure",
          VR.kDS, VM.k1, false);
  static const Tag kDiaphragmPosition
      //(3002,0034)
      = const Tag.public("DiaphragmPosition", 0x30020034, "Diaphragm Position",
          VR.kDS, VM.k4, false);
  static const Tag kFluenceMapSequence
      //(3002,0040)
      = const Tag.public("FluenceMapSequence", 0x30020040,
          "Fluence Map Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFluenceDataSource
      //(3002,0041)
      = const Tag.public("FluenceDataSource", 0x30020041, "Fluence Data Source",
          VR.kCS, VM.k1, false);
  static const Tag kFluenceDataScale
      //(3002,0042)
      = const Tag.public("FluenceDataScale", 0x30020042, "Fluence Data Scale",
          VR.kDS, VM.k1, false);
  static const Tag kPrimaryFluenceModeSequence
      //(3002,0050)
      = const Tag.public("PrimaryFluenceModeSequence", 0x30020050,
          "Primary Fluence Mode Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFluenceMode
      //(3002,0051)
      = const Tag.public(
          "FluenceMode", 0x30020051, "Fluence Mode", VR.kCS, VM.k1, false);
  static const Tag kFluenceModeID
      //(3002,0052)
      = const Tag.public(
          "FluenceModeID", 0x30020052, "Fluence Mode ID", VR.kSH, VM.k1, false);
  static const Tag kDVHType
      //(3004,0001)
      =
      const Tag.public("DVHType", 0x30040001, "DVH Type", VR.kCS, VM.k1, false);
  static const Tag kDoseUnits
      //(3004,0002)
      = const Tag.public(
          "DoseUnits", 0x30040002, "Dose Units", VR.kCS, VM.k1, false);
  static const Tag kDoseType
      //(3004,0004)
      = const Tag.public(
          "DoseType", 0x30040004, "Dose Type", VR.kCS, VM.k1, false);
  static const Tag kSpatialTransformOfDose
      //(3004,0005)
      = const Tag.public("SpatialTransformOfDose", 0x30040005,
          "Spatial Transform of Dose", VR.kCS, VM.k1, false);
  static const Tag kDoseComment
      //(3004,0006)
      = const Tag.public(
          "DoseComment", 0x30040006, "Dose Comment", VR.kLO, VM.k1, false);
  static const Tag kNormalizationPoint
      //(3004,0008)
      = const Tag.public("NormalizationPoint", 0x30040008,
          "Normalization Point", VR.kDS, VM.k3, false);
  static const Tag kDoseSummationType
      //(3004,000A)
      = const Tag.public("DoseSummationType", 0x3004000A, "Dose Summation Type",
          VR.kCS, VM.k1, false);
  static const Tag kGridFrameOffsetVector
      //(3004,000C)
      = const Tag.public("GridFrameOffsetVector", 0x3004000C,
          "Grid Frame Offset Vector", VR.kDS, VM.k2_n, false);
  static const Tag kDoseGridScaling
      //(3004,000E)
      = const Tag.public("DoseGridScaling", 0x3004000E, "Dose Grid Scaling",
          VR.kDS, VM.k1, false);
  static const Tag kRTDoseROISequence
      //(3004,0010)
      = const Tag.public("RTDoseROISequence", 0x30040010,
          "RT Dose ROI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDoseValue
      //(3004,0012)
      = const Tag.public(
          "DoseValue", 0x30040012, "Dose Value", VR.kDS, VM.k1, false);
  static const Tag kTissueHeterogeneityCorrection
      //(3004,0014)
      = const Tag.public("TissueHeterogeneityCorrection", 0x30040014,
          "Tissue Heterogeneity Correction", VR.kCS, VM.k1_3, false);
  static const Tag kDVHNormalizationPoint
      //(3004,0040)
      = const Tag.public("DVHNormalizationPoint", 0x30040040,
          "DVH Normalization Point", VR.kDS, VM.k3, false);
  static const Tag kDVHNormalizationDoseValue
      //(3004,0042)
      = const Tag.public("DVHNormalizationDoseValue", 0x30040042,
          "DVH Normalization Dose Value", VR.kDS, VM.k1, false);
  static const Tag kDVHSequence
      //(3004,0050)
      = const Tag.public(
          "DVHSequence", 0x30040050, "DVH Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDVHDoseScaling
      //(3004,0052)
      = const Tag.public("DVHDoseScaling", 0x30040052, "DVH Dose Scaling",
          VR.kDS, VM.k1, false);
  static const Tag kDVHVolumeUnits
      //(3004,0054)
      = const Tag.public("DVHVolumeUnits", 0x30040054, "DVH Volume Units",
          VR.kCS, VM.k1, false);
  static const Tag kDVHNumberOfBins
      //(3004,0056)
      = const Tag.public("DVHNumberOfBins", 0x30040056, "DVH Number of Bins",
          VR.kIS, VM.k1, false);
  static const Tag kDVHData
      //(3004,0058)
      = const Tag.public(
          "DVHData", 0x30040058, "DVH Data", VR.kDS, VM.k2_2n, false);
  static const Tag kDVHReferencedROISequence
      //(3004,0060)
      = const Tag.public("DVHReferencedROISequence", 0x30040060,
          "DVH Referenced ROI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDVHROIContributionType
      //(3004,0062)
      = const Tag.public("DVHROIContributionType", 0x30040062,
          "DVH ROI Contribution Type", VR.kCS, VM.k1, false);
  static const Tag kDVHMinimumDose
      //(3004,0070)
      = const Tag.public("DVHMinimumDose", 0x30040070, "DVH Minimum Dose",
          VR.kDS, VM.k1, false);
  static const Tag kDVHMaximumDose
      //(3004,0072)
      = const Tag.public("DVHMaximumDose", 0x30040072, "DVH Maximum Dose",
          VR.kDS, VM.k1, false);
  static const Tag kDVHMeanDose
      //(3004,0074)
      = const Tag.public(
          "DVHMeanDose", 0x30040074, "DVH Mean Dose", VR.kDS, VM.k1, false);
  static const Tag kStructureSetLabel
      //(3006,0002)
      = const Tag.public("StructureSetLabel", 0x30060002, "Structure Set Label",
          VR.kSH, VM.k1, false);
  static const Tag kStructureSetName
      //(3006,0004)
      = const Tag.public("StructureSetName", 0x30060004, "Structure Set Name",
          VR.kLO, VM.k1, false);
  static const Tag kStructureSetDescription
      //(3006,0006)
      = const Tag.public("StructureSetDescription", 0x30060006,
          "Structure Set Description", VR.kST, VM.k1, false);
  static const Tag kStructureSetDate
      //(3006,0008)
      = const Tag.public("StructureSetDate", 0x30060008, "Structure Set Date",
          VR.kDA, VM.k1, false);
  static const Tag kStructureSetTime
      //(3006,0009)
      = const Tag.public("StructureSetTime", 0x30060009, "Structure Set Time",
          VR.kTM, VM.k1, false);
  static const Tag kReferencedFrameOfReferenceSequence
      //(3006,0010)
      = const Tag.public("ReferencedFrameOfReferenceSequence", 0x30060010,
          "Referenced Frame of Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRTReferencedStudySequence
      //(3006,0012)
      = const Tag.public("RTReferencedStudySequence", 0x30060012,
          "RT Referenced Study Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRTReferencedSeriesSequence
      //(3006,0014)
      = const Tag.public("RTReferencedSeriesSequence", 0x30060014,
          "RT Referenced Series Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContourImageSequence
      //(3006,0016)
      = const Tag.public("ContourImageSequence", 0x30060016,
          "Contour Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPredecessorStructureSetSequence
      //(3006,0018)
      = const Tag.public("PredecessorStructureSetSequence", 0x30060018,
          "Predecessor Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const Tag kStructureSetROISequence
      //(3006,0020)
      = const Tag.public("StructureSetROISequence", 0x30060020,
          "Structure Set ROI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kROINumber
      //(3006,0022)
      = const Tag.public(
          "ROINumber", 0x30060022, "ROI Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedFrameOfReferenceUID
      //(3006,0024)
      = const Tag.public("ReferencedFrameOfReferenceUID", 0x30060024,
          "Referenced Frame of Reference UID", VR.kUI, VM.k1, false);
  static const Tag kROIName
      //(3006,0026)
      =
      const Tag.public("ROIName", 0x30060026, "ROI Name", VR.kLO, VM.k1, false);
  static const Tag kROIDescription
      //(3006,0028)
      = const Tag.public("ROIDescription", 0x30060028, "ROI Description",
          VR.kST, VM.k1, false);
  static const Tag kROIDisplayColor
      //(3006,002A)
      = const Tag.public("ROIDisplayColor", 0x3006002A, "ROI Display Color",
          VR.kIS, VM.k3, false);
  static const Tag kROIVolume
      //(3006,002C)
      = const Tag.public(
          "ROIVolume", 0x3006002C, "ROI Volume", VR.kDS, VM.k1, false);
  static const Tag kRTRelatedROISequence
      //(3006,0030)
      = const Tag.public("RTRelatedROISequence", 0x30060030,
          "RT Related ROI Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRTROIRelationship
      //(3006,0033)
      = const Tag.public("RTROIRelationship", 0x30060033, "RT ROI Relationship",
          VR.kCS, VM.k1, false);
  static const Tag kROIGenerationAlgorithm
      //(3006,0036)
      = const Tag.public("ROIGenerationAlgorithm", 0x30060036,
          "ROI Generation Algorithm", VR.kCS, VM.k1, false);
  static const Tag kROIGenerationDescription
      //(3006,0038)
      = const Tag.public("ROIGenerationDescription", 0x30060038,
          "ROI Generation Description", VR.kLO, VM.k1, false);
  static const Tag kROIContourSequence
      //(3006,0039)
      = const Tag.public("ROIContourSequence", 0x30060039,
          "ROI Contour Sequence", VR.kSQ, VM.k1, false);
  static const Tag kContourSequence
      //(3006,0040)
      = const Tag.public("ContourSequence", 0x30060040, "Contour Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kContourGeometricType
      //(3006,0042)
      = const Tag.public("ContourGeometricType", 0x30060042,
          "Contour Geometric Type", VR.kCS, VM.k1, false);
  static const Tag kContourSlabThickness
      //(3006,0044)
      = const Tag.public("ContourSlabThickness", 0x30060044,
          "Contour Slab Thickness", VR.kDS, VM.k1, false);
  static const Tag kContourOffsetVector
      //(3006,0045)
      = const Tag.public("ContourOffsetVector", 0x30060045,
          "Contour Offset Vector", VR.kDS, VM.k3, false);
  static const Tag kNumberOfContourPoints
      //(3006,0046)
      = const Tag.public("NumberOfContourPoints", 0x30060046,
          "Number of Contour Points", VR.kIS, VM.k1, false);
  static const Tag kContourNumber
      //(3006,0048)
      = const Tag.public(
          "ContourNumber", 0x30060048, "Contour Number", VR.kIS, VM.k1, false);
  static const Tag kAttachedContours
      //(3006,0049)
      = const Tag.public("AttachedContours", 0x30060049, "Attached Contours",
          VR.kIS, VM.k1_n, false);
  static const Tag kContourData
      //(3006,0050)
      = const Tag.public(
          "ContourData", 0x30060050, "Contour Data", VR.kDS, VM.k3_3n, false);
  static const Tag kRTROIObservationsSequence
      //(3006,0080)
      = const Tag.public("RTROIObservationsSequence", 0x30060080,
          "RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const Tag kObservationNumber
      //(3006,0082)
      = const Tag.public("ObservationNumber", 0x30060082, "Observation Number",
          VR.kIS, VM.k1, false);
  static const Tag kReferencedROINumber
      //(3006,0084)
      = const Tag.public("ReferencedROINumber", 0x30060084,
          "Referenced ROI Number", VR.kIS, VM.k1, false);
  static const Tag kROIObservationLabel
      //(3006,0085)
      = const Tag.public("ROIObservationLabel", 0x30060085,
          "ROI Observation Label", VR.kSH, VM.k1, false);
  static const Tag kRTROIIdentificationCodeSequence
      //(3006,0086)
      = const Tag.public("RTROIIdentificationCodeSequence", 0x30060086,
          "RT ROI Identification Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kROIObservationDescription
      //(3006,0088)
      = const Tag.public("ROIObservationDescription", 0x30060088,
          "ROI Observation Description", VR.kST, VM.k1, false);
  static const Tag kRelatedRTROIObservationsSequence
      //(3006,00A0)
      = const Tag.public("RelatedRTROIObservationsSequence", 0x300600A0,
          "Related RT ROI Observations Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRTROIInterpretedType
      //(3006,00A4)
      = const Tag.public("RTROIInterpretedType", 0x300600A4,
          "RT ROI Interpreted Type", VR.kCS, VM.k1, false);
  static const Tag kROIInterpreter
      //(3006,00A6)
      = const Tag.public("ROIInterpreter", 0x300600A6, "ROI Interpreter",
          VR.kPN, VM.k1, false);
  static const Tag kROIPhysicalPropertiesSequence
      //(3006,00B0)
      = const Tag.public("ROIPhysicalPropertiesSequence", 0x300600B0,
          "ROI Physical Properties Sequence", VR.kSQ, VM.k1, false);
  static const Tag kROIPhysicalProperty
      //(3006,00B2)
      = const Tag.public("ROIPhysicalProperty", 0x300600B2,
          "ROI Physical Property", VR.kCS, VM.k1, false);
  static const Tag kROIPhysicalPropertyValue
      //(3006,00B4)
      = const Tag.public("ROIPhysicalPropertyValue", 0x300600B4,
          "ROI Physical Property Value", VR.kDS, VM.k1, false);
  static const Tag kROIElementalCompositionSequence
      //(3006,00B6)
      = const Tag.public("ROIElementalCompositionSequence", 0x300600B6,
          "ROI Elemental Composition Sequence", VR.kSQ, VM.k1, false);
  static const Tag kROIElementalCompositionAtomicNumber
      //(3006,00B7)
      = const Tag.public("ROIElementalCompositionAtomicNumber", 0x300600B7,
          "ROI Elemental Composition Atomic Number", VR.kUS, VM.k1, false);
  static const Tag kROIElementalCompositionAtomicMassFraction
      //(3006,00B8)
      = const Tag.public(
          "ROIElementalCompositionAtomicMassFraction",
          0x300600B8,
          "ROI Elemental Composition Atomic Mass Fraction",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kFrameOfReferenceRelationshipSequence
      //(3006,00C0)
      = const Tag.public("FrameOfReferenceRelationshipSequence", 0x300600C0,
          "Frame of Reference Relationship Sequence", VR.kSQ, VM.k1, true);
  static const Tag kRelatedFrameOfReferenceUID
      //(3006,00C2)
      = const Tag.public("RelatedFrameOfReferenceUID", 0x300600C2,
          "Related Frame of Reference UID", VR.kUI, VM.k1, true);
  static const Tag kFrameOfReferenceTransformationType
      //(3006,00C4)
      = const Tag.public("FrameOfReferenceTransformationType", 0x300600C4,
          "Frame of Reference Transformation Type", VR.kCS, VM.k1, true);
  static const Tag kFrameOfReferenceTransformationMatrix
      //(3006,00C6)
      = const Tag.public("FrameOfReferenceTransformationMatrix", 0x300600C6,
          "Frame of Reference Transformation Matrix", VR.kDS, VM.k16, false);
  static const Tag kFrameOfReferenceTransformationComment
      //(3006,00C8)
      = const Tag.public("FrameOfReferenceTransformationComment", 0x300600C8,
          "Frame of Reference Transformation Comment", VR.kLO, VM.k1, false);
  static const Tag kMeasuredDoseReferenceSequence
      //(3008,0010)
      = const Tag.public("MeasuredDoseReferenceSequence", 0x30080010,
          "Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kMeasuredDoseDescription
      //(3008,0012)
      = const Tag.public("MeasuredDoseDescription", 0x30080012,
          "Measured Dose Description", VR.kST, VM.k1, false);
  static const Tag kMeasuredDoseType
      //(3008,0014)
      = const Tag.public("MeasuredDoseType", 0x30080014, "Measured Dose Type",
          VR.kCS, VM.k1, false);
  static const Tag kMeasuredDoseValue
      //(3008,0016)
      = const Tag.public("MeasuredDoseValue", 0x30080016, "Measured Dose Value",
          VR.kDS, VM.k1, false);
  static const Tag kTreatmentSessionBeamSequence
      //(3008,0020)
      = const Tag.public("TreatmentSessionBeamSequence", 0x30080020,
          "Treatment Session Beam Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTreatmentSessionIonBeamSequence
      //(3008,0021)
      = const Tag.public("TreatmentSessionIonBeamSequence", 0x30080021,
          "Treatment Session Ion Beam Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCurrentFractionNumber
      //(3008,0022)
      = const Tag.public("CurrentFractionNumber", 0x30080022,
          "Current Fraction Number", VR.kIS, VM.k1, false);
  static const Tag kTreatmentControlPointDate
      //(3008,0024)
      = const Tag.public("TreatmentControlPointDate", 0x30080024,
          "Treatment Control Point Date", VR.kDA, VM.k1, false);
  static const Tag kTreatmentControlPointTime
      //(3008,0025)
      = const Tag.public("TreatmentControlPointTime", 0x30080025,
          "Treatment Control Point Time", VR.kTM, VM.k1, false);
  static const Tag kTreatmentTerminationStatus
      //(3008,002A)
      = const Tag.public("TreatmentTerminationStatus", 0x3008002A,
          "Treatment Termination Status", VR.kCS, VM.k1, false);
  static const Tag kTreatmentTerminationCode
      //(3008,002B)
      = const Tag.public("TreatmentTerminationCode", 0x3008002B,
          "Treatment Termination Code", VR.kSH, VM.k1, false);
  static const Tag kTreatmentVerificationStatus
      //(3008,002C)
      = const Tag.public("TreatmentVerificationStatus", 0x3008002C,
          "Treatment Verification Status", VR.kCS, VM.k1, false);
  static const Tag kReferencedTreatmentRecordSequence
      //(3008,0030)
      = const Tag.public("ReferencedTreatmentRecordSequence", 0x30080030,
          "Referenced Treatment Record Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecifiedPrimaryMeterset
      //(3008,0032)
      = const Tag.public("SpecifiedPrimaryMeterset", 0x30080032,
          "Specified Primary Meterset", VR.kDS, VM.k1, false);
  static const Tag kSpecifiedSecondaryMeterset
      //(3008,0033)
      = const Tag.public("SpecifiedSecondaryMeterset", 0x30080033,
          "Specified Secondary Meterset", VR.kDS, VM.k1, false);
  static const Tag kDeliveredPrimaryMeterset
      //(3008,0036)
      = const Tag.public("DeliveredPrimaryMeterset", 0x30080036,
          "Delivered Primary Meterset", VR.kDS, VM.k1, false);
  static const Tag kDeliveredSecondaryMeterset
      //(3008,0037)
      = const Tag.public("DeliveredSecondaryMeterset", 0x30080037,
          "Delivered Secondary Meterset", VR.kDS, VM.k1, false);
  static const Tag kSpecifiedTreatmentTime
      //(3008,003A)
      = const Tag.public("SpecifiedTreatmentTime", 0x3008003A,
          "Specified Treatment Time", VR.kDS, VM.k1, false);
  static const Tag kDeliveredTreatmentTime
      //(3008,003B)
      = const Tag.public("DeliveredTreatmentTime", 0x3008003B,
          "Delivered Treatment Time", VR.kDS, VM.k1, false);
  static const Tag kControlPointDeliverySequence
      //(3008,0040)
      = const Tag.public("ControlPointDeliverySequence", 0x30080040,
          "Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIonControlPointDeliverySequence
      //(3008,0041)
      = const Tag.public("IonControlPointDeliverySequence", 0x30080041,
          "Ion Control Point Delivery Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecifiedMeterset
      //(3008,0042)
      = const Tag.public("SpecifiedMeterset", 0x30080042, "Specified Meterset",
          VR.kDS, VM.k1, false);
  static const Tag kDeliveredMeterset
      //(3008,0044)
      = const Tag.public("DeliveredMeterset", 0x30080044, "Delivered Meterset",
          VR.kDS, VM.k1, false);
  static const Tag kMetersetRateSet
      //(3008,0045)
      = const Tag.public("MetersetRateSet", 0x30080045, "Meterset Rate Set",
          VR.kFL, VM.k1, false);
  static const Tag kMetersetRateDelivered
      //(3008,0046)
      = const Tag.public("MetersetRateDelivered", 0x30080046,
          "Meterset Rate Delivered", VR.kFL, VM.k1, false);
  static const Tag kScanSpotMetersetsDelivered
      //(3008,0047)
      = const Tag.public("ScanSpotMetersetsDelivered", 0x30080047,
          "Scan Spot Metersets Delivered", VR.kFL, VM.k1_n, false);
  static const Tag kDoseRateDelivered
      //(3008,0048)
      = const Tag.public("DoseRateDelivered", 0x30080048, "Dose Rate Delivered",
          VR.kDS, VM.k1, false);
  static const Tag kTreatmentSummaryCalculatedDoseReferenceSequence
      //(3008,0050)
      = const Tag.public(
          "TreatmentSummaryCalculatedDoseReferenceSequence",
          0x30080050,
          "Treatment Summary Calculated Dose Reference Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kCumulativeDoseToDoseReference
      //(3008,0052)
      = const Tag.public("CumulativeDoseToDoseReference", 0x30080052,
          "Cumulative Dose to Dose Reference", VR.kDS, VM.k1, false);
  static const Tag kFirstTreatmentDate
      //(3008,0054)
      = const Tag.public("FirstTreatmentDate", 0x30080054,
          "First Treatment Date", VR.kDA, VM.k1, false);
  static const Tag kMostRecentTreatmentDate
      //(3008,0056)
      = const Tag.public("MostRecentTreatmentDate", 0x30080056,
          "Most Recent Treatment Date", VR.kDA, VM.k1, false);
  static const Tag kNumberOfFractionsDelivered
      //(3008,005A)
      = const Tag.public("NumberOfFractionsDelivered", 0x3008005A,
          "Number of Fractions Delivered", VR.kIS, VM.k1, false);
  static const Tag kOverrideSequence
      //(3008,0060)
      = const Tag.public("OverrideSequence", 0x30080060, "Override Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kParameterSequencePointer
      //(3008,0061)
      = const Tag.public("ParameterSequencePointer", 0x30080061,
          "Parameter Sequence Pointer", VR.kAT, VM.k1, false);
  static const Tag kOverrideParameterPointer
      //(3008,0062)
      = const Tag.public("OverrideParameterPointer", 0x30080062,
          "Override Parameter Pointer", VR.kAT, VM.k1, false);
  static const Tag kParameterItemIndex
      //(3008,0063)
      = const Tag.public("ParameterItemIndex", 0x30080063,
          "Parameter Item Index", VR.kIS, VM.k1, false);
  static const Tag kMeasuredDoseReferenceNumber
      //(3008,0064)
      = const Tag.public("MeasuredDoseReferenceNumber", 0x30080064,
          "Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kParameterPointer
      //(3008,0065)
      = const Tag.public("ParameterPointer", 0x30080065, "Parameter Pointer",
          VR.kAT, VM.k1, false);
  static const Tag kOverrideReason
      //(3008,0066)
      = const Tag.public("OverrideReason", 0x30080066, "Override Reason",
          VR.kST, VM.k1, false);
  static const Tag kCorrectedParameterSequence
      //(3008,0068)
      = const Tag.public("CorrectedParameterSequence", 0x30080068,
          "Corrected Parameter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCorrectionValue
      //(3008,006A)
      = const Tag.public("CorrectionValue", 0x3008006A, "Correction Value",
          VR.kFL, VM.k1, false);
  static const Tag kCalculatedDoseReferenceSequence
      //(3008,0070)
      = const Tag.public("CalculatedDoseReferenceSequence", 0x30080070,
          "Calculated Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCalculatedDoseReferenceNumber
      //(3008,0072)
      = const Tag.public("CalculatedDoseReferenceNumber", 0x30080072,
          "Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kCalculatedDoseReferenceDescription
      //(3008,0074)
      = const Tag.public("CalculatedDoseReferenceDescription", 0x30080074,
          "Calculated Dose Reference Description", VR.kST, VM.k1, false);
  static const Tag kCalculatedDoseReferenceDoseValue
      //(3008,0076)
      = const Tag.public("CalculatedDoseReferenceDoseValue", 0x30080076,
          "Calculated Dose Reference Dose Value", VR.kDS, VM.k1, false);
  static const Tag kStartMeterset
      //(3008,0078)
      = const Tag.public(
          "StartMeterset", 0x30080078, "Start Meterset", VR.kDS, VM.k1, false);
  static const Tag kEndMeterset
      //(3008,007A)
      = const Tag.public(
          "EndMeterset", 0x3008007A, "End Meterset", VR.kDS, VM.k1, false);
  static const Tag kReferencedMeasuredDoseReferenceSequence
      //(3008,0080)
      = const Tag.public("ReferencedMeasuredDoseReferenceSequence", 0x30080080,
          "Referenced Measured Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedMeasuredDoseReferenceNumber
      //(3008,0082)
      = const Tag.public("ReferencedMeasuredDoseReferenceNumber", 0x30080082,
          "Referenced Measured Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedCalculatedDoseReferenceSequence
      //(3008,0090)
      = const Tag.public(
          "ReferencedCalculatedDoseReferenceSequence",
          0x30080090,
          "Referenced Calculated Dose Reference Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kReferencedCalculatedDoseReferenceNumber
      //(3008,0092)
      = const Tag.public("ReferencedCalculatedDoseReferenceNumber", 0x30080092,
          "Referenced Calculated Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kBeamLimitingDeviceLeafPairsSequence
      //(3008,00A0)
      = const Tag.public("BeamLimitingDeviceLeafPairsSequence", 0x300800A0,
          "Beam Limiting Device Leaf Pairs Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedWedgeSequence
      //(3008,00B0)
      = const Tag.public("RecordedWedgeSequence", 0x300800B0,
          "Recorded Wedge Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedCompensatorSequence
      //(3008,00C0)
      = const Tag.public("RecordedCompensatorSequence", 0x300800C0,
          "Recorded Compensator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedBlockSequence
      //(3008,00D0)
      = const Tag.public("RecordedBlockSequence", 0x300800D0,
          "Recorded Block Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTreatmentSummaryMeasuredDoseReferenceSequence
      //(3008,00E0)
      = const Tag.public(
          "TreatmentSummaryMeasuredDoseReferenceSequence",
          0x300800E0,
          "Treatment Summary Measured Dose Reference Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kRecordedSnoutSequence
      //(3008,00F0)
      = const Tag.public("RecordedSnoutSequence", 0x300800F0,
          "Recorded Snout Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedRangeShifterSequence
      //(3008,00F2)
      = const Tag.public("RecordedRangeShifterSequence", 0x300800F2,
          "Recorded Range Shifter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedLateralSpreadingDeviceSequence
      //(3008,00F4)
      = const Tag.public("RecordedLateralSpreadingDeviceSequence", 0x300800F4,
          "Recorded Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedRangeModulatorSequence
      //(3008,00F6)
      = const Tag.public("RecordedRangeModulatorSequence", 0x300800F6,
          "Recorded Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRecordedSourceSequence
      //(3008,0100)
      = const Tag.public("RecordedSourceSequence", 0x30080100,
          "Recorded Source Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceSerialNumber
      //(3008,0105)
      = const Tag.public("SourceSerialNumber", 0x30080105,
          "Source Serial Number", VR.kLO, VM.k1, false);
  static const Tag kTreatmentSessionApplicationSetupSequence
      //(3008,0110)
      = const Tag.public("TreatmentSessionApplicationSetupSequence", 0x30080110,
          "Treatment Session Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const Tag kApplicationSetupCheck
      //(3008,0116)
      = const Tag.public("ApplicationSetupCheck", 0x30080116,
          "Application Setup Check", VR.kCS, VM.k1, false);
  static const Tag kRecordedBrachyAccessoryDeviceSequence
      //(3008,0120)
      = const Tag.public("RecordedBrachyAccessoryDeviceSequence", 0x30080120,
          "Recorded Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedBrachyAccessoryDeviceNumber
      //(3008,0122)
      = const Tag.public("ReferencedBrachyAccessoryDeviceNumber", 0x30080122,
          "Referenced Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const Tag kRecordedChannelSequence
      //(3008,0130)
      = const Tag.public("RecordedChannelSequence", 0x30080130,
          "Recorded Channel Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSpecifiedChannelTotalTime
      //(3008,0132)
      = const Tag.public("SpecifiedChannelTotalTime", 0x30080132,
          "Specified Channel Total Time", VR.kDS, VM.k1, false);
  static const Tag kDeliveredChannelTotalTime
      //(3008,0134)
      = const Tag.public("DeliveredChannelTotalTime", 0x30080134,
          "Delivered Channel Total Time", VR.kDS, VM.k1, false);
  static const Tag kSpecifiedNumberOfPulses
      //(3008,0136)
      = const Tag.public("SpecifiedNumberOfPulses", 0x30080136,
          "Specified Number of Pulses", VR.kIS, VM.k1, false);
  static const Tag kDeliveredNumberOfPulses
      //(3008,0138)
      = const Tag.public("DeliveredNumberOfPulses", 0x30080138,
          "Delivered Number of Pulses", VR.kIS, VM.k1, false);
  static const Tag kSpecifiedPulseRepetitionInterval
      //(3008,013A)
      = const Tag.public("SpecifiedPulseRepetitionInterval", 0x3008013A,
          "Specified Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const Tag kDeliveredPulseRepetitionInterval
      //(3008,013C)
      = const Tag.public("DeliveredPulseRepetitionInterval", 0x3008013C,
          "Delivered Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const Tag kRecordedSourceApplicatorSequence
      //(3008,0140)
      = const Tag.public("RecordedSourceApplicatorSequence", 0x30080140,
          "Recorded Source Applicator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSourceApplicatorNumber
      //(3008,0142)
      = const Tag.public("ReferencedSourceApplicatorNumber", 0x30080142,
          "Referenced Source Applicator Number", VR.kIS, VM.k1, false);
  static const Tag kRecordedChannelShieldSequence
      //(3008,0150)
      = const Tag.public("RecordedChannelShieldSequence", 0x30080150,
          "Recorded Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedChannelShieldNumber
      //(3008,0152)
      = const Tag.public("ReferencedChannelShieldNumber", 0x30080152,
          "Referenced Channel Shield Number", VR.kIS, VM.k1, false);
  static const Tag kBrachyControlPointDeliveredSequence
      //(3008,0160)
      = const Tag.public("BrachyControlPointDeliveredSequence", 0x30080160,
          "Brachy Control Point Delivered Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSafePositionExitDate
      //(3008,0162)
      = const Tag.public("SafePositionExitDate", 0x30080162,
          "Safe Position Exit Date", VR.kDA, VM.k1, false);
  static const Tag kSafePositionExitTime
      //(3008,0164)
      = const Tag.public("SafePositionExitTime", 0x30080164,
          "Safe Position Exit Time", VR.kTM, VM.k1, false);
  static const Tag kSafePositionReturnDate
      //(3008,0166)
      = const Tag.public("SafePositionReturnDate", 0x30080166,
          "Safe Position Return Date", VR.kDA, VM.k1, false);
  static const Tag kSafePositionReturnTime
      //(3008,0168)
      = const Tag.public("SafePositionReturnTime", 0x30080168,
          "Safe Position Return Time", VR.kTM, VM.k1, false);
  static const Tag kCurrentTreatmentStatus
      //(3008,0200)
      = const Tag.public("CurrentTreatmentStatus", 0x30080200,
          "Current Treatment Status", VR.kCS, VM.k1, false);
  static const Tag kTreatmentStatusComment
      //(3008,0202)
      = const Tag.public("TreatmentStatusComment", 0x30080202,
          "Treatment Status Comment", VR.kST, VM.k1, false);
  static const Tag kFractionGroupSummarySequence
      //(3008,0220)
      = const Tag.public("FractionGroupSummarySequence", 0x30080220,
          "Fraction Group Summary Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedFractionNumber
      //(3008,0223)
      = const Tag.public("ReferencedFractionNumber", 0x30080223,
          "Referenced Fraction Number", VR.kIS, VM.k1, false);
  static const Tag kFractionGroupType
      //(3008,0224)
      = const Tag.public("FractionGroupType", 0x30080224, "Fraction Group Type",
          VR.kCS, VM.k1, false);
  static const Tag kBeamStopperPosition
      //(3008,0230)
      = const Tag.public("BeamStopperPosition", 0x30080230,
          "Beam Stopper Position", VR.kCS, VM.k1, false);
  static const Tag kFractionStatusSummarySequence
      //(3008,0240)
      = const Tag.public("FractionStatusSummarySequence", 0x30080240,
          "Fraction Status Summary Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTreatmentDate
      //(3008,0250)
      = const Tag.public(
          "TreatmentDate", 0x30080250, "Treatment Date", VR.kDA, VM.k1, false);
  static const Tag kTreatmentTime
      //(3008,0251)
      = const Tag.public(
          "TreatmentTime", 0x30080251, "Treatment Time", VR.kTM, VM.k1, false);
  static const Tag kRTPlanLabel
      //(300A,0002)
      = const Tag.public(
          "RTPlanLabel", 0x300A0002, "RT Plan Label", VR.kSH, VM.k1, false);
  static const Tag kRTPlanName
      //(300A,0003)
      = const Tag.public(
          "RTPlanName", 0x300A0003, "RT Plan Name", VR.kLO, VM.k1, false);
  static const Tag kRTPlanDescription
      //(300A,0004)
      = const Tag.public("RTPlanDescription", 0x300A0004, "RT Plan Description",
          VR.kST, VM.k1, false);
  static const Tag kRTPlanDate
      //(300A,0006)
      = const Tag.public(
          "RTPlanDate", 0x300A0006, "RT Plan Date", VR.kDA, VM.k1, false);
  static const Tag kRTPlanTime
      //(300A,0007)
      = const Tag.public(
          "RTPlanTime", 0x300A0007, "RT Plan Time", VR.kTM, VM.k1, false);
  static const Tag kTreatmentProtocols
      //(300A,0009)
      = const Tag.public("TreatmentProtocols", 0x300A0009,
          "Treatment Protocols", VR.kLO, VM.k1_n, false);
  static const Tag kPlanIntent
      //(300A,000A)
      = const Tag.public(
          "PlanIntent", 0x300A000A, "Plan Intent", VR.kCS, VM.k1, false);
  static const Tag kTreatmentSites
      //(300A,000B)
      = const Tag.public("TreatmentSites", 0x300A000B, "Treatment Sites",
          VR.kLO, VM.k1_n, false);
  static const Tag kRTPlanGeometry
      //(300A,000C)
      = const Tag.public("RTPlanGeometry", 0x300A000C, "RT Plan Geometry",
          VR.kCS, VM.k1, false);
  static const Tag kPrescriptionDescription
      //(300A,000E)
      = const Tag.public("PrescriptionDescription", 0x300A000E,
          "Prescription Description", VR.kST, VM.k1, false);
  static const Tag kDoseReferenceSequence
      //(300A,0010)
      = const Tag.public("DoseReferenceSequence", 0x300A0010,
          "Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDoseReferenceNumber
      //(300A,0012)
      = const Tag.public("DoseReferenceNumber", 0x300A0012,
          "Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kDoseReferenceUID
      //(300A,0013)
      = const Tag.public("DoseReferenceUID", 0x300A0013, "Dose Reference UID",
          VR.kUI, VM.k1, false);
  static const Tag kDoseReferenceStructureType
      //(300A,0014)
      = const Tag.public("DoseReferenceStructureType", 0x300A0014,
          "Dose Reference Structure Type", VR.kCS, VM.k1, false);
  static const Tag kNominalBeamEnergyUnit
      //(300A,0015)
      = const Tag.public("NominalBeamEnergyUnit", 0x300A0015,
          "Nominal Beam Energy Unit", VR.kCS, VM.k1, false);
  static const Tag kDoseReferenceDescription
      //(300A,0016)
      = const Tag.public("DoseReferenceDescription", 0x300A0016,
          "Dose Reference Description", VR.kLO, VM.k1, false);
  static const Tag kDoseReferencePointCoordinates
      //(300A,0018)
      = const Tag.public("DoseReferencePointCoordinates", 0x300A0018,
          "Dose Reference Point Coordinates", VR.kDS, VM.k3, false);
  static const Tag kNominalPriorDose
      //(300A,001A)
      = const Tag.public("NominalPriorDose", 0x300A001A, "Nominal Prior Dose",
          VR.kDS, VM.k1, false);
  static const Tag kDoseReferenceType
      //(300A,0020)
      = const Tag.public("DoseReferenceType", 0x300A0020, "Dose Reference Type",
          VR.kCS, VM.k1, false);
  static const Tag kConstraintWeight
      //(300A,0021)
      = const Tag.public("ConstraintWeight", 0x300A0021, "Constraint Weight",
          VR.kDS, VM.k1, false);
  static const Tag kDeliveryWarningDose
      //(300A,0022)
      = const Tag.public("DeliveryWarningDose", 0x300A0022,
          "Delivery Warning Dose", VR.kDS, VM.k1, false);
  static const Tag kDeliveryMaximumDose
      //(300A,0023)
      = const Tag.public("DeliveryMaximumDose", 0x300A0023,
          "Delivery Maximum Dose", VR.kDS, VM.k1, false);
  static const Tag kTargetMinimumDose
      //(300A,0025)
      = const Tag.public("TargetMinimumDose", 0x300A0025, "Target Minimum Dose",
          VR.kDS, VM.k1, false);
  static const Tag kTargetPrescriptionDose
      //(300A,0026)
      = const Tag.public("TargetPrescriptionDose", 0x300A0026,
          "Target Prescription Dose", VR.kDS, VM.k1, false);
  static const Tag kTargetMaximumDose
      //(300A,0027)
      = const Tag.public("TargetMaximumDose", 0x300A0027, "Target Maximum Dose",
          VR.kDS, VM.k1, false);
  static const Tag kTargetUnderdoseVolumeFraction
      //(300A,0028)
      = const Tag.public("TargetUnderdoseVolumeFraction", 0x300A0028,
          "Target Underdose Volume Fraction", VR.kDS, VM.k1, false);
  static const Tag kOrganAtRiskFullVolumeDose
      //(300A,002A)
      = const Tag.public("OrganAtRiskFullVolumeDose", 0x300A002A,
          "Organ at Risk Full-volume Dose", VR.kDS, VM.k1, false);
  static const Tag kOrganAtRiskLimitDose
      //(300A,002B)
      = const Tag.public("OrganAtRiskLimitDose", 0x300A002B,
          "Organ at Risk Limit Dose", VR.kDS, VM.k1, false);
  static const Tag kOrganAtRiskMaximumDose
      //(300A,002C)
      = const Tag.public("OrganAtRiskMaximumDose", 0x300A002C,
          "Organ at Risk Maximum Dose", VR.kDS, VM.k1, false);
  static const Tag kOrganAtRiskOverdoseVolumeFraction
      //(300A,002D)
      = const Tag.public("OrganAtRiskOverdoseVolumeFraction", 0x300A002D,
          "Organ at Risk Overdose Volume Fraction", VR.kDS, VM.k1, false);
  static const Tag kToleranceTableSequence
      //(300A,0040)
      = const Tag.public("ToleranceTableSequence", 0x300A0040,
          "Tolerance Table Sequence", VR.kSQ, VM.k1, false);
  static const Tag kToleranceTableNumber
      //(300A,0042)
      = const Tag.public("ToleranceTableNumber", 0x300A0042,
          "Tolerance Table Number", VR.kIS, VM.k1, false);
  static const Tag kToleranceTableLabel
      //(300A,0043)
      = const Tag.public("ToleranceTableLabel", 0x300A0043,
          "Tolerance Table Label", VR.kSH, VM.k1, false);
  static const Tag kGantryAngleTolerance
      //(300A,0044)
      = const Tag.public("GantryAngleTolerance", 0x300A0044,
          "Gantry Angle Tolerance", VR.kDS, VM.k1, false);
  static const Tag kBeamLimitingDeviceAngleTolerance
      //(300A,0046)
      = const Tag.public("BeamLimitingDeviceAngleTolerance", 0x300A0046,
          "Beam Limiting Device Angle Tolerance", VR.kDS, VM.k1, false);
  static const Tag kBeamLimitingDeviceToleranceSequence
      //(300A,0048)
      = const Tag.public("BeamLimitingDeviceToleranceSequence", 0x300A0048,
          "Beam Limiting Device Tolerance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBeamLimitingDevicePositionTolerance
      //(300A,004A)
      = const Tag.public("BeamLimitingDevicePositionTolerance", 0x300A004A,
          "Beam Limiting Device Position Tolerance", VR.kDS, VM.k1, false);
  static const Tag kSnoutPositionTolerance
      //(300A,004B)
      = const Tag.public("SnoutPositionTolerance", 0x300A004B,
          "Snout Position Tolerance", VR.kFL, VM.k1, false);
  static const Tag kPatientSupportAngleTolerance
      //(300A,004C)
      = const Tag.public("PatientSupportAngleTolerance", 0x300A004C,
          "Patient Support Angle Tolerance", VR.kDS, VM.k1, false);
  static const Tag kTableTopEccentricAngleTolerance
      //(300A,004E)
      = const Tag.public("TableTopEccentricAngleTolerance", 0x300A004E,
          "Table Top Eccentric Angle Tolerance", VR.kDS, VM.k1, false);
  static const Tag kTableTopPitchAngleTolerance
      //(300A,004F)
      = const Tag.public("TableTopPitchAngleTolerance", 0x300A004F,
          "Table Top Pitch Angle Tolerance", VR.kFL, VM.k1, false);
  static const Tag kTableTopRollAngleTolerance
      //(300A,0050)
      = const Tag.public("TableTopRollAngleTolerance", 0x300A0050,
          "Table Top Roll Angle Tolerance", VR.kFL, VM.k1, false);
  static const Tag kTableTopVerticalPositionTolerance
      //(300A,0051)
      = const Tag.public("TableTopVerticalPositionTolerance", 0x300A0051,
          "Table Top Vertical Position Tolerance", VR.kDS, VM.k1, false);
  static const Tag kTableTopLongitudinalPositionTolerance
      //(300A,0052)
      = const Tag.public("TableTopLongitudinalPositionTolerance", 0x300A0052,
          "Table Top Longitudinal Position Tolerance", VR.kDS, VM.k1, false);
  static const Tag kTableTopLateralPositionTolerance
      //(300A,0053)
      = const Tag.public("TableTopLateralPositionTolerance", 0x300A0053,
          "Table Top Lateral Position Tolerance", VR.kDS, VM.k1, false);
  static const Tag kRTPlanRelationship
      //(300A,0055)
      = const Tag.public("RTPlanRelationship", 0x300A0055,
          "RT Plan Relationship", VR.kCS, VM.k1, false);
  static const Tag kFractionGroupSequence
      //(300A,0070)
      = const Tag.public("FractionGroupSequence", 0x300A0070,
          "Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFractionGroupNumber
      //(300A,0071)
      = const Tag.public("FractionGroupNumber", 0x300A0071,
          "Fraction Group Number", VR.kIS, VM.k1, false);
  static const Tag kFractionGroupDescription
      //(300A,0072)
      = const Tag.public("FractionGroupDescription", 0x300A0072,
          "Fraction Group Description", VR.kLO, VM.k1, false);
  static const Tag kNumberOfFractionsPlanned
      //(300A,0078)
      = const Tag.public("NumberOfFractionsPlanned", 0x300A0078,
          "Number of Fractions Planned", VR.kIS, VM.k1, false);
  static const Tag kNumberOfFractionPatternDigitsPerDay
      //(300A,0079)
      = const Tag.public("NumberOfFractionPatternDigitsPerDay", 0x300A0079,
          "Number of Fraction Pattern Digits Per Day", VR.kIS, VM.k1, false);
  static const Tag kRepeatFractionCycleLength
      //(300A,007A)
      = const Tag.public("RepeatFractionCycleLength", 0x300A007A,
          "Repeat Fraction Cycle Length", VR.kIS, VM.k1, false);
  static const Tag kFractionPattern
      //(300A,007B)
      = const Tag.public("FractionPattern", 0x300A007B, "Fraction Pattern",
          VR.kLT, VM.k1, false);
  static const Tag kNumberOfBeams
      //(300A,0080)
      = const Tag.public(
          "NumberOfBeams", 0x300A0080, "Number of Beams", VR.kIS, VM.k1, false);
  static const Tag kBeamDoseSpecificationPoint
      //(300A,0082)
      = const Tag.public("BeamDoseSpecificationPoint", 0x300A0082,
          "Beam Dose Specification Point", VR.kDS, VM.k3, false);
  static const Tag kBeamDose
      //(300A,0084)
      = const Tag.public(
          "BeamDose", 0x300A0084, "Beam Dose", VR.kDS, VM.k1, false);
  static const Tag kBeamMeterset
      //(300A,0086)
      = const Tag.public(
          "BeamMeterset", 0x300A0086, "Beam Meterset", VR.kDS, VM.k1, false);
  static const Tag kBeamDosePointDepth
      //(300A,0088)
      = const Tag.public("BeamDosePointDepth", 0x300A0088,
          "Beam Dose Point Depth", VR.kFL, VM.k1, true);
  static const Tag kBeamDosePointEquivalentDepth
      //(300A,0089)
      = const Tag.public("BeamDosePointEquivalentDepth", 0x300A0089,
          "Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, true);
  static const Tag kBeamDosePointSSD
      //(300A,008A)
      = const Tag.public("BeamDosePointSSD", 0x300A008A, "Beam Dose Point SSD",
          VR.kFL, VM.k1, true);
  static const Tag kBeamDoseMeaning
      //(300A,008B)
      = const Tag.public("BeamDoseMeaning", 0x300A008B, "Beam Dose Meaning",
          VR.kCS, VM.k1, false);
  static const Tag kBeamDoseVerificationControlPointSequence
      //(300A,008C)
      = const Tag.public(
          "BeamDoseVerificationControlPointSequence",
          0x300A008C,
          "Beam Dose Verification Control Point Sequence",
          VR.kSQ,
          VM.k1,
          false);
  static const Tag kAverageBeamDosePointDepth
      //(300A,008D)
      = const Tag.public("AverageBeamDosePointDepth", 0x300A008D,
          "Average Beam Dose Point Depth", VR.kFL, VM.k1, false);
  static const Tag kAverageBeamDosePointEquivalentDepth
      //(300A,008E)
      = const Tag.public("AverageBeamDosePointEquivalentDepth", 0x300A008E,
          "Average Beam Dose Point Equivalent Depth", VR.kFL, VM.k1, false);
  static const Tag kAverageBeamDosePointSSD
      //(300A,008F)
      = const Tag.public("AverageBeamDosePointSSD", 0x300A008F,
          "Average Beam Dose Point SSD", VR.kFL, VM.k1, false);
  static const Tag kNumberOfBrachyApplicationSetups
      //(300A,00A0)
      = const Tag.public("NumberOfBrachyApplicationSetups", 0x300A00A0,
          "Number of Brachy Application Setups", VR.kIS, VM.k1, false);
  static const Tag kBrachyApplicationSetupDoseSpecificationPoint
      //(300A,00A2)
      = const Tag.public(
          "BrachyApplicationSetupDoseSpecificationPoint",
          0x300A00A2,
          "Brachy Application Setup Dose Specification Point",
          VR.kDS,
          VM.k3,
          false);
  static const Tag kBrachyApplicationSetupDose
      //(300A,00A4)
      = const Tag.public("BrachyApplicationSetupDose", 0x300A00A4,
          "Brachy Application Setup Dose", VR.kDS, VM.k1, false);
  static const Tag kBeamSequence
      //(300A,00B0)
      = const Tag.public(
          "BeamSequence", 0x300A00B0, "Beam Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTreatmentMachineName
      //(300A,00B2)
      = const Tag.public("TreatmentMachineName", 0x300A00B2,
          "Treatment Machine Name", VR.kSH, VM.k1, false);
  static const Tag kPrimaryDosimeterUnit
      //(300A,00B3)
      = const Tag.public("PrimaryDosimeterUnit", 0x300A00B3,
          "Primary Dosimeter Unit", VR.kCS, VM.k1, false);
  static const Tag kSourceAxisDistance
      //(300A,00B4)
      = const Tag.public("SourceAxisDistance", 0x300A00B4,
          "Source-Axis Distance", VR.kDS, VM.k1, false);
  static const Tag kBeamLimitingDeviceSequence
      //(300A,00B6)
      = const Tag.public("BeamLimitingDeviceSequence", 0x300A00B6,
          "Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRTBeamLimitingDeviceType
      //(300A,00B8)
      = const Tag.public("RTBeamLimitingDeviceType", 0x300A00B8,
          "RT Beam Limiting Device Type", VR.kCS, VM.k1, false);
  static const Tag kSourceToBeamLimitingDeviceDistance
      //(300A,00BA)
      = const Tag.public("SourceToBeamLimitingDeviceDistance", 0x300A00BA,
          "Source to Beam Limiting Device Distance", VR.kDS, VM.k1, false);
  static const Tag kIsocenterToBeamLimitingDeviceDistance
      //(300A,00BB)
      = const Tag.public("IsocenterToBeamLimitingDeviceDistance", 0x300A00BB,
          "Isocenter to Beam Limiting Device Distance", VR.kFL, VM.k1, false);
  static const Tag kNumberOfLeafJawPairs
      //(300A,00BC)
      = const Tag.public("NumberOfLeafJawPairs", 0x300A00BC,
          "Number of Leaf/Jaw Pairs", VR.kIS, VM.k1, false);
  static const Tag kLeafPositionBoundaries
      //(300A,00BE)
      = const Tag.public("LeafPositionBoundaries", 0x300A00BE,
          "Leaf Position Boundaries", VR.kDS, VM.k3_n, false);
  static const Tag kBeamNumber
      //(300A,00C0)
      = const Tag.public(
          "BeamNumber", 0x300A00C0, "Beam Number", VR.kIS, VM.k1, false);
  static const Tag kBeamName
      //(300A,00C2)
      = const Tag.public(
          "BeamName", 0x300A00C2, "Beam Name", VR.kLO, VM.k1, false);
  static const Tag kBeamDescription
      //(300A,00C3)
      = const Tag.public("BeamDescription", 0x300A00C3, "Beam Description",
          VR.kST, VM.k1, false);
  static const Tag kBeamType
      //(300A,00C4)
      = const Tag.public(
          "BeamType", 0x300A00C4, "Beam Type", VR.kCS, VM.k1, false);
  static const Tag kRadiationType
      //(300A,00C6)
      = const Tag.public(
          "RadiationType", 0x300A00C6, "Radiation Type", VR.kCS, VM.k1, false);
  static const Tag kHighDoseTechniqueType
      //(300A,00C7)
      = const Tag.public("HighDoseTechniqueType", 0x300A00C7,
          "High-Dose Technique Type", VR.kCS, VM.k1, false);
  static const Tag kReferenceImageNumber
      //(300A,00C8)
      = const Tag.public("ReferenceImageNumber", 0x300A00C8,
          "Reference Image Number", VR.kIS, VM.k1, false);
  static const Tag kPlannedVerificationImageSequence
      //(300A,00CA)
      = const Tag.public("PlannedVerificationImageSequence", 0x300A00CA,
          "Planned Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kImagingDeviceSpecificAcquisitionParameters
      //(300A,00CC)
      = const Tag.public(
          "ImagingDeviceSpecificAcquisitionParameters",
          0x300A00CC,
          "Imaging Device-Specific Acquisition Parameters",
          VR.kLO,
          VM.k1_n,
          false);
  static const Tag kTreatmentDeliveryType
      //(300A,00CE)
      = const Tag.public("TreatmentDeliveryType", 0x300A00CE,
          "Treatment Delivery Type", VR.kCS, VM.k1, false);
  static const Tag kNumberOfWedges
      //(300A,00D0)
      = const Tag.public("NumberOfWedges", 0x300A00D0, "Number of Wedges",
          VR.kIS, VM.k1, false);
  static const Tag kWedgeSequence
      //(300A,00D1)
      = const Tag.public(
          "WedgeSequence", 0x300A00D1, "Wedge Sequence", VR.kSQ, VM.k1, false);
  static const Tag kWedgeNumber
      //(300A,00D2)
      = const Tag.public(
          "WedgeNumber", 0x300A00D2, "Wedge Number", VR.kIS, VM.k1, false);
  static const Tag kWedgeType
      //(300A,00D3)
      = const Tag.public(
          "WedgeType", 0x300A00D3, "Wedge Type", VR.kCS, VM.k1, false);
  static const Tag kWedgeID
      //(300A,00D4)
      =
      const Tag.public("WedgeID", 0x300A00D4, "Wedge ID", VR.kSH, VM.k1, false);
  static const Tag kWedgeAngle
      //(300A,00D5)
      = const Tag.public(
          "WedgeAngle", 0x300A00D5, "Wedge Angle", VR.kIS, VM.k1, false);
  static const Tag kWedgeFactor
      //(300A,00D6)
      = const Tag.public(
          "WedgeFactor", 0x300A00D6, "Wedge Factor", VR.kDS, VM.k1, false);
  static const Tag kTotalWedgeTrayWaterEquivalentThickness
      //(300A,00D7)
      = const Tag.public("TotalWedgeTrayWaterEquivalentThickness", 0x300A00D7,
          "Total Wedge Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const Tag kWedgeOrientation
      //(300A,00D8)
      = const Tag.public("WedgeOrientation", 0x300A00D8, "Wedge Orientation",
          VR.kDS, VM.k1, false);
  static const Tag kIsocenterToWedgeTrayDistance
      //(300A,00D9)
      = const Tag.public("IsocenterToWedgeTrayDistance", 0x300A00D9,
          "Isocenter to Wedge Tray Distance", VR.kFL, VM.k1, false);
  static const Tag kSourceToWedgeTrayDistance
      //(300A,00DA)
      = const Tag.public("SourceToWedgeTrayDistance", 0x300A00DA,
          "Source to Wedge Tray Distance", VR.kDS, VM.k1, false);
  static const Tag kWedgeThinEdgePosition
      //(300A,00DB)
      = const Tag.public("WedgeThinEdgePosition", 0x300A00DB,
          "Wedge Thin Edge Position", VR.kFL, VM.k1, false);
  static const Tag kBolusID
      //(300A,00DC)
      =
      const Tag.public("BolusID", 0x300A00DC, "Bolus ID", VR.kSH, VM.k1, false);
  static const Tag kBolusDescription
      //(300A,00DD)
      = const Tag.public("BolusDescription", 0x300A00DD, "Bolus Description",
          VR.kST, VM.k1, false);
  static const Tag kNumberOfCompensators
      //(300A,00E0)
      = const Tag.public("NumberOfCompensators", 0x300A00E0,
          "Number of Compensators", VR.kIS, VM.k1, false);
  static const Tag kMaterialID
      //(300A,00E1)
      = const Tag.public(
          "MaterialID", 0x300A00E1, "Material ID", VR.kSH, VM.k1, false);
  static const Tag kTotalCompensatorTrayFactor
      //(300A,00E2)
      = const Tag.public("TotalCompensatorTrayFactor", 0x300A00E2,
          "Total Compensator Tray Factor", VR.kDS, VM.k1, false);
  static const Tag kCompensatorSequence
      //(300A,00E3)
      = const Tag.public("CompensatorSequence", 0x300A00E3,
          "Compensator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCompensatorNumber
      //(300A,00E4)
      = const Tag.public("CompensatorNumber", 0x300A00E4, "Compensator Number",
          VR.kIS, VM.k1, false);
  static const Tag kCompensatorID
      //(300A,00E5)
      = const Tag.public(
          "CompensatorID", 0x300A00E5, "Compensator ID", VR.kSH, VM.k1, false);
  static const Tag kSourceToCompensatorTrayDistance
      //(300A,00E6)
      = const Tag.public("SourceToCompensatorTrayDistance", 0x300A00E6,
          "Source to Compensator Tray Distance", VR.kDS, VM.k1, false);
  static const Tag kCompensatorRows
      //(300A,00E7)
      = const Tag.public("CompensatorRows", 0x300A00E7, "Compensator Rows",
          VR.kIS, VM.k1, false);
  static const Tag kCompensatorColumns
      //(300A,00E8)
      = const Tag.public("CompensatorColumns", 0x300A00E8,
          "Compensator Columns", VR.kIS, VM.k1, false);
  static const Tag kCompensatorPixelSpacing
      //(300A,00E9)
      = const Tag.public("CompensatorPixelSpacing", 0x300A00E9,
          "Compensator Pixel Spacing", VR.kDS, VM.k2, false);
  static const Tag kCompensatorPosition
      //(300A,00EA)
      = const Tag.public("CompensatorPosition", 0x300A00EA,
          "Compensator Position", VR.kDS, VM.k2, false);
  static const Tag kCompensatorTransmissionData
      //(300A,00EB)
      = const Tag.public("CompensatorTransmissionData", 0x300A00EB,
          "Compensator Transmission Data", VR.kDS, VM.k1_n, false);
  static const Tag kCompensatorThicknessData
      //(300A,00EC)
      = const Tag.public("CompensatorThicknessData", 0x300A00EC,
          "Compensator Thickness Data", VR.kDS, VM.k1_n, false);
  static const Tag kNumberOfBoli
      //(300A,00ED)
      = const Tag.public(
          "NumberOfBoli", 0x300A00ED, "Number of Boli", VR.kIS, VM.k1, false);
  static const Tag kCompensatorType
      //(300A,00EE)
      = const Tag.public("CompensatorType", 0x300A00EE, "Compensator Type",
          VR.kCS, VM.k1, false);
  static const Tag kCompensatorTrayID
      //(300A,00EF)
      = const Tag.public("CompensatorTrayID", 0x300A00EF, "Compensator Tray ID",
          VR.kSH, VM.k1, false);
  static const Tag kNumberOfBlocks
      //(300A,00F0)
      = const Tag.public("NumberOfBlocks", 0x300A00F0, "Number of Blocks",
          VR.kIS, VM.k1, false);
  static const Tag kTotalBlockTrayFactor
      //(300A,00F2)
      = const Tag.public("TotalBlockTrayFactor", 0x300A00F2,
          "Total Block Tray Factor", VR.kDS, VM.k1, false);
  static const Tag kTotalBlockTrayWaterEquivalentThickness
      //(300A,00F3)
      = const Tag.public("TotalBlockTrayWaterEquivalentThickness", 0x300A00F3,
          "Total Block Tray Water-Equivalent Thickness", VR.kFL, VM.k1, false);
  static const Tag kBlockSequence
      //(300A,00F4)
      = const Tag.public(
          "BlockSequence", 0x300A00F4, "Block Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBlockTrayID
      //(300A,00F5)
      = const Tag.public(
          "BlockTrayID", 0x300A00F5, "Block Tray ID", VR.kSH, VM.k1, false);
  static const Tag kSourceToBlockTrayDistance
      //(300A,00F6)
      = const Tag.public("SourceToBlockTrayDistance", 0x300A00F6,
          "Source to Block Tray Distance", VR.kDS, VM.k1, false);
  static const Tag kIsocenterToBlockTrayDistance
      //(300A,00F7)
      = const Tag.public("IsocenterToBlockTrayDistance", 0x300A00F7,
          "Isocenter to Block Tray Distance", VR.kFL, VM.k1, false);
  static const Tag kBlockType
      //(300A,00F8)
      = const Tag.public(
          "BlockType", 0x300A00F8, "Block Type", VR.kCS, VM.k1, false);
  static const Tag kAccessoryCode
      //(300A,00F9)
      = const Tag.public(
          "AccessoryCode", 0x300A00F9, "Accessory Code", VR.kLO, VM.k1, false);
  static const Tag kBlockDivergence
      //(300A,00FA)
      = const Tag.public("BlockDivergence", 0x300A00FA, "Block Divergence",
          VR.kCS, VM.k1, false);
  static const Tag kBlockMountingPosition
      //(300A,00FB)
      = const Tag.public("BlockMountingPosition", 0x300A00FB,
          "Block Mounting Position", VR.kCS, VM.k1, false);
  static const Tag kBlockNumber
      //(300A,00FC)
      = const Tag.public(
          "BlockNumber", 0x300A00FC, "Block Number", VR.kIS, VM.k1, false);
  static const Tag kBlockName
      //(300A,00FE)
      = const Tag.public(
          "BlockName", 0x300A00FE, "Block Name", VR.kLO, VM.k1, false);
  static const Tag kBlockThickness
      //(300A,0100)
      = const Tag.public("BlockThickness", 0x300A0100, "Block Thickness",
          VR.kDS, VM.k1, false);
  static const Tag kBlockTransmission
      //(300A,0102)
      = const Tag.public("BlockTransmission", 0x300A0102, "Block Transmission",
          VR.kDS, VM.k1, false);
  static const Tag kBlockNumberOfPoints
      //(300A,0104)
      = const Tag.public("BlockNumberOfPoints", 0x300A0104,
          "Block Number of Points", VR.kIS, VM.k1, false);
  static const Tag kBlockData
      //(300A,0106)
      = const Tag.public(
          "BlockData", 0x300A0106, "Block Data", VR.kDS, VM.k2_2n, false);
  static const Tag kApplicatorSequence
      //(300A,0107)
      = const Tag.public("ApplicatorSequence", 0x300A0107,
          "Applicator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kApplicatorID
      //(300A,0108)
      = const Tag.public(
          "ApplicatorID", 0x300A0108, "Applicator ID", VR.kSH, VM.k1, false);
  static const Tag kApplicatorType
      //(300A,0109)
      = const Tag.public("ApplicatorType", 0x300A0109, "Applicator Type",
          VR.kCS, VM.k1, false);
  static const Tag kApplicatorDescription
      //(300A,010A)
      = const Tag.public("ApplicatorDescription", 0x300A010A,
          "Applicator Description", VR.kLO, VM.k1, false);
  static const Tag kCumulativeDoseReferenceCoefficient
      //(300A,010C)
      = const Tag.public("CumulativeDoseReferenceCoefficient", 0x300A010C,
          "Cumulative Dose Reference Coefficient", VR.kDS, VM.k1, false);
  static const Tag kFinalCumulativeMetersetWeight
      //(300A,010E)
      = const Tag.public("FinalCumulativeMetersetWeight", 0x300A010E,
          "Final Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const Tag kNumberOfControlPoints
      //(300A,0110)
      = const Tag.public("NumberOfControlPoints", 0x300A0110,
          "Number of Control Points", VR.kIS, VM.k1, false);
  static const Tag kControlPointSequence
      //(300A,0111)
      = const Tag.public("ControlPointSequence", 0x300A0111,
          "Control Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kControlPointIndex
      //(300A,0112)
      = const Tag.public("ControlPointIndex", 0x300A0112, "Control Point Index",
          VR.kIS, VM.k1, false);
  static const Tag kNominalBeamEnergy
      //(300A,0114)
      = const Tag.public("NominalBeamEnergy", 0x300A0114, "Nominal Beam Energy",
          VR.kDS, VM.k1, false);
  static const Tag kDoseRateSet
      //(300A,0115)
      = const Tag.public(
          "DoseRateSet", 0x300A0115, "Dose Rate Set", VR.kDS, VM.k1, false);
  static const Tag kWedgePositionSequence
      //(300A,0116)
      = const Tag.public("WedgePositionSequence", 0x300A0116,
          "Wedge Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kWedgePosition
      //(300A,0118)
      = const Tag.public(
          "WedgePosition", 0x300A0118, "Wedge Position", VR.kCS, VM.k1, false);
  static const Tag kBeamLimitingDevicePositionSequence
      //(300A,011A)
      = const Tag.public("BeamLimitingDevicePositionSequence", 0x300A011A,
          "Beam Limiting Device Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLeafJawPositions
      //(300A,011C)
      = const Tag.public("LeafJawPositions", 0x300A011C, "Leaf/Jaw Positions",
          VR.kDS, VM.k2_2n, false);
  static const Tag kGantryAngle
      //(300A,011E)
      = const Tag.public(
          "GantryAngle", 0x300A011E, "Gantry Angle", VR.kDS, VM.k1, false);
  static const Tag kGantryRotationDirection
      //(300A,011F)
      = const Tag.public("GantryRotationDirection", 0x300A011F,
          "Gantry Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kBeamLimitingDeviceAngle
      //(300A,0120)
      = const Tag.public("BeamLimitingDeviceAngle", 0x300A0120,
          "Beam Limiting Device Angle", VR.kDS, VM.k1, false);
  static const Tag kBeamLimitingDeviceRotationDirection
      //(300A,0121)
      = const Tag.public("BeamLimitingDeviceRotationDirection", 0x300A0121,
          "Beam Limiting Device Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kPatientSupportAngle
      //(300A,0122)
      = const Tag.public("PatientSupportAngle", 0x300A0122,
          "Patient Support Angle", VR.kDS, VM.k1, false);
  static const Tag kPatientSupportRotationDirection
      //(300A,0123)
      = const Tag.public("PatientSupportRotationDirection", 0x300A0123,
          "Patient Support Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kTableTopEccentricAxisDistance
      //(300A,0124)
      = const Tag.public("TableTopEccentricAxisDistance", 0x300A0124,
          "Table Top Eccentric Axis Distance", VR.kDS, VM.k1, false);
  static const Tag kTableTopEccentricAngle
      //(300A,0125)
      = const Tag.public("TableTopEccentricAngle", 0x300A0125,
          "Table Top Eccentric Angle", VR.kDS, VM.k1, false);
  static const Tag kTableTopEccentricRotationDirection
      //(300A,0126)
      = const Tag.public("TableTopEccentricRotationDirection", 0x300A0126,
          "Table Top Eccentric Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kTableTopVerticalPosition
      //(300A,0128)
      = const Tag.public("TableTopVerticalPosition", 0x300A0128,
          "Table Top Vertical Position", VR.kDS, VM.k1, false);
  static const Tag kTableTopLongitudinalPosition
      //(300A,0129)
      = const Tag.public("TableTopLongitudinalPosition", 0x300A0129,
          "Table Top Longitudinal Position", VR.kDS, VM.k1, false);
  static const Tag kTableTopLateralPosition
      //(300A,012A)
      = const Tag.public("TableTopLateralPosition", 0x300A012A,
          "Table Top Lateral Position", VR.kDS, VM.k1, false);
  static const Tag kIsocenterPosition
      //(300A,012C)
      = const Tag.public("IsocenterPosition", 0x300A012C, "Isocenter Position",
          VR.kDS, VM.k3, false);
  static const Tag kSurfaceEntryPoint
      //(300A,012E)
      = const Tag.public("SurfaceEntryPoint", 0x300A012E, "Surface Entry Point",
          VR.kDS, VM.k3, false);
  static const Tag kSourceToSurfaceDistance
      //(300A,0130)
      = const Tag.public("SourceToSurfaceDistance", 0x300A0130,
          "Source to Surface Distance", VR.kDS, VM.k1, false);
  static const Tag kCumulativeMetersetWeight
      //(300A,0134)
      = const Tag.public("CumulativeMetersetWeight", 0x300A0134,
          "Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const Tag kTableTopPitchAngle
      //(300A,0140)
      = const Tag.public("TableTopPitchAngle", 0x300A0140,
          "Table Top Pitch Angle", VR.kFL, VM.k1, false);
  static const Tag kTableTopPitchRotationDirection
      //(300A,0142)
      = const Tag.public("TableTopPitchRotationDirection", 0x300A0142,
          "Table Top Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kTableTopRollAngle
      //(300A,0144)
      = const Tag.public("TableTopRollAngle", 0x300A0144,
          "Table Top Roll Angle", VR.kFL, VM.k1, false);
  static const Tag kTableTopRollRotationDirection
      //(300A,0146)
      = const Tag.public("TableTopRollRotationDirection", 0x300A0146,
          "Table Top Roll Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kHeadFixationAngle
      //(300A,0148)
      = const Tag.public("HeadFixationAngle", 0x300A0148, "Head Fixation Angle",
          VR.kFL, VM.k1, false);
  static const Tag kGantryPitchAngle
      //(300A,014A)
      = const Tag.public("GantryPitchAngle", 0x300A014A, "Gantry Pitch Angle",
          VR.kFL, VM.k1, false);
  static const Tag kGantryPitchRotationDirection
      //(300A,014C)
      = const Tag.public("GantryPitchRotationDirection", 0x300A014C,
          "Gantry Pitch Rotation Direction", VR.kCS, VM.k1, false);
  static const Tag kGantryPitchAngleTolerance
      //(300A,014E)
      = const Tag.public("GantryPitchAngleTolerance", 0x300A014E,
          "Gantry Pitch Angle Tolerance", VR.kFL, VM.k1, false);
  static const Tag kPatientSetupSequence
      //(300A,0180)
      = const Tag.public("PatientSetupSequence", 0x300A0180,
          "Patient Setup Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPatientSetupNumber
      //(300A,0182)
      = const Tag.public("PatientSetupNumber", 0x300A0182,
          "Patient Setup Number", VR.kIS, VM.k1, false);
  static const Tag kPatientSetupLabel
      //(300A,0183)
      = const Tag.public("PatientSetupLabel", 0x300A0183, "Patient Setup Label",
          VR.kLO, VM.k1, false);
  static const Tag kPatientAdditionalPosition
      //(300A,0184)
      = const Tag.public("PatientAdditionalPosition", 0x300A0184,
          "Patient Additional Position", VR.kLO, VM.k1, false);
  static const Tag kFixationDeviceSequence
      //(300A,0190)
      = const Tag.public("FixationDeviceSequence", 0x300A0190,
          "Fixation Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kFixationDeviceType
      //(300A,0192)
      = const Tag.public("FixationDeviceType", 0x300A0192,
          "Fixation Device Type", VR.kCS, VM.k1, false);
  static const Tag kFixationDeviceLabel
      //(300A,0194)
      = const Tag.public("FixationDeviceLabel", 0x300A0194,
          "Fixation Device Label", VR.kSH, VM.k1, false);
  static const Tag kFixationDeviceDescription
      //(300A,0196)
      = const Tag.public("FixationDeviceDescription", 0x300A0196,
          "Fixation Device Description", VR.kST, VM.k1, false);
  static const Tag kFixationDevicePosition
      //(300A,0198)
      = const Tag.public("FixationDevicePosition", 0x300A0198,
          "Fixation Device Position", VR.kSH, VM.k1, false);
  static const Tag kFixationDevicePitchAngle
      //(300A,0199)
      = const Tag.public("FixationDevicePitchAngle", 0x300A0199,
          "Fixation Device Pitch Angle", VR.kFL, VM.k1, false);
  static const Tag kFixationDeviceRollAngle
      //(300A,019A)
      = const Tag.public("FixationDeviceRollAngle", 0x300A019A,
          "Fixation Device Roll Angle", VR.kFL, VM.k1, false);
  static const Tag kShieldingDeviceSequence
      //(300A,01A0)
      = const Tag.public("ShieldingDeviceSequence", 0x300A01A0,
          "Shielding Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kShieldingDeviceType
      //(300A,01A2)
      = const Tag.public("ShieldingDeviceType", 0x300A01A2,
          "Shielding Device Type", VR.kCS, VM.k1, false);
  static const Tag kShieldingDeviceLabel
      //(300A,01A4)
      = const Tag.public("ShieldingDeviceLabel", 0x300A01A4,
          "Shielding Device Label", VR.kSH, VM.k1, false);
  static const Tag kShieldingDeviceDescription
      //(300A,01A6)
      = const Tag.public("ShieldingDeviceDescription", 0x300A01A6,
          "Shielding Device Description", VR.kST, VM.k1, false);
  static const Tag kShieldingDevicePosition
      //(300A,01A8)
      = const Tag.public("ShieldingDevicePosition", 0x300A01A8,
          "Shielding Device Position", VR.kSH, VM.k1, false);
  static const Tag kSetupTechnique
      //(300A,01B0)
      = const Tag.public("SetupTechnique", 0x300A01B0, "Setup Technique",
          VR.kCS, VM.k1, false);
  static const Tag kSetupTechniqueDescription
      //(300A,01B2)
      = const Tag.public("SetupTechniqueDescription", 0x300A01B2,
          "Setup Technique Description", VR.kST, VM.k1, false);
  static const Tag kSetupDeviceSequence
      //(300A,01B4)
      = const Tag.public("SetupDeviceSequence", 0x300A01B4,
          "Setup Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSetupDeviceType
      //(300A,01B6)
      = const Tag.public("SetupDeviceType", 0x300A01B6, "Setup Device Type",
          VR.kCS, VM.k1, false);
  static const Tag kSetupDeviceLabel
      //(300A,01B8)
      = const Tag.public("SetupDeviceLabel", 0x300A01B8, "Setup Device Label",
          VR.kSH, VM.k1, false);
  static const Tag kSetupDeviceDescription
      //(300A,01BA)
      = const Tag.public("SetupDeviceDescription", 0x300A01BA,
          "Setup Device Description", VR.kST, VM.k1, false);
  static const Tag kSetupDeviceParameter
      //(300A,01BC)
      = const Tag.public("SetupDeviceParameter", 0x300A01BC,
          "Setup Device Parameter", VR.kDS, VM.k1, false);
  static const Tag kSetupReferenceDescription
      //(300A,01D0)
      = const Tag.public("SetupReferenceDescription", 0x300A01D0,
          "Setup Reference Description", VR.kST, VM.k1, false);
  static const Tag kTableTopVerticalSetupDisplacement
      //(300A,01D2)
      = const Tag.public("TableTopVerticalSetupDisplacement", 0x300A01D2,
          "Table Top Vertical Setup Displacement", VR.kDS, VM.k1, false);
  static const Tag kTableTopLongitudinalSetupDisplacement
      //(300A,01D4)
      = const Tag.public("TableTopLongitudinalSetupDisplacement", 0x300A01D4,
          "Table Top Longitudinal Setup Displacement", VR.kDS, VM.k1, false);
  static const Tag kTableTopLateralSetupDisplacement
      //(300A,01D6)
      = const Tag.public("TableTopLateralSetupDisplacement", 0x300A01D6,
          "Table Top Lateral Setup Displacement", VR.kDS, VM.k1, false);
  static const Tag kBrachyTreatmentTechnique
      //(300A,0200)
      = const Tag.public("BrachyTreatmentTechnique", 0x300A0200,
          "Brachy Treatment Technique", VR.kCS, VM.k1, false);
  static const Tag kBrachyTreatmentType
      //(300A,0202)
      = const Tag.public("BrachyTreatmentType", 0x300A0202,
          "Brachy Treatment Type", VR.kCS, VM.k1, false);
  static const Tag kTreatmentMachineSequence
      //(300A,0206)
      = const Tag.public("TreatmentMachineSequence", 0x300A0206,
          "Treatment Machine Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSourceSequence
      //(300A,0210)
      = const Tag.public("SourceSequence", 0x300A0210, "Source Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kSourceNumber
      //(300A,0212)
      = const Tag.public(
          "SourceNumber", 0x300A0212, "Source Number", VR.kIS, VM.k1, false);
  static const Tag kSourceType
      //(300A,0214)
      = const Tag.public(
          "SourceType", 0x300A0214, "Source Type", VR.kCS, VM.k1, false);
  static const Tag kSourceManufacturer
      //(300A,0216)
      = const Tag.public("SourceManufacturer", 0x300A0216,
          "Source Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kActiveSourceDiameter
      //(300A,0218)
      = const Tag.public("ActiveSourceDiameter", 0x300A0218,
          "Active Source Diameter", VR.kDS, VM.k1, false);
  static const Tag kActiveSourceLength
      //(300A,021A)
      = const Tag.public("ActiveSourceLength", 0x300A021A,
          "Active Source Length", VR.kDS, VM.k1, false);
  static const Tag kSourceModelID
      //(300A,021B)
      = const Tag.public(
          "SourceModelID", 0x300A021B, "Source Model ID", VR.kSH, VM.k1, false);
  static const Tag kSourceDescription
      //(300A,021C)
      = const Tag.public("SourceDescription", 0x300A021C, "Source Description",
          VR.kLO, VM.k1, false);
  static const Tag kSourceEncapsulationNominalThickness
      //(300A,0222)
      = const Tag.public("SourceEncapsulationNominalThickness", 0x300A0222,
          "Source Encapsulation Nominal Thickness", VR.kDS, VM.k1, false);
  static const Tag kSourceEncapsulationNominalTransmission
      //(300A,0224)
      = const Tag.public("SourceEncapsulationNominalTransmission", 0x300A0224,
          "Source Encapsulation Nominal Transmission", VR.kDS, VM.k1, false);
  static const Tag kSourceIsotopeName
      //(300A,0226)
      = const Tag.public("SourceIsotopeName", 0x300A0226, "Source Isotope Name",
          VR.kLO, VM.k1, false);
  static const Tag kSourceIsotopeHalfLife
      //(300A,0228)
      = const Tag.public("SourceIsotopeHalfLife", 0x300A0228,
          "Source Isotope Half Life", VR.kDS, VM.k1, false);
  static const Tag kSourceStrengthUnits
      //(300A,0229)
      = const Tag.public("SourceStrengthUnits", 0x300A0229,
          "Source Strength Units", VR.kCS, VM.k1, false);
  static const Tag kReferenceAirKermaRate
      //(300A,022A)
      = const Tag.public("ReferenceAirKermaRate", 0x300A022A,
          "Reference Air Kerma Rate", VR.kDS, VM.k1, false);
  static const Tag kSourceStrength
      //(300A,022B)
      = const Tag.public("SourceStrength", 0x300A022B, "Source Strength",
          VR.kDS, VM.k1, false);
  static const Tag kSourceStrengthReferenceDate
      //(300A,022C)
      = const Tag.public("SourceStrengthReferenceDate", 0x300A022C,
          "Source Strength Reference Date", VR.kDA, VM.k1, false);
  static const Tag kSourceStrengthReferenceTime
      //(300A,022E)
      = const Tag.public("SourceStrengthReferenceTime", 0x300A022E,
          "Source Strength Reference Time", VR.kTM, VM.k1, false);
  static const Tag kApplicationSetupSequence
      //(300A,0230)
      = const Tag.public("ApplicationSetupSequence", 0x300A0230,
          "Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const Tag kApplicationSetupType
      //(300A,0232)
      = const Tag.public("ApplicationSetupType", 0x300A0232,
          "Application Setup Type", VR.kCS, VM.k1, false);
  static const Tag kApplicationSetupNumber
      //(300A,0234)
      = const Tag.public("ApplicationSetupNumber", 0x300A0234,
          "Application Setup Number", VR.kIS, VM.k1, false);
  static const Tag kApplicationSetupName
      //(300A,0236)
      = const Tag.public("ApplicationSetupName", 0x300A0236,
          "Application Setup Name", VR.kLO, VM.k1, false);
  static const Tag kApplicationSetupManufacturer
      //(300A,0238)
      = const Tag.public("ApplicationSetupManufacturer", 0x300A0238,
          "Application Setup Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kTemplateNumber
      //(300A,0240)
      = const Tag.public("TemplateNumber", 0x300A0240, "Template Number",
          VR.kIS, VM.k1, false);
  static const Tag kTemplateType
      //(300A,0242)
      = const Tag.public(
          "TemplateType", 0x300A0242, "Template Type", VR.kSH, VM.k1, false);
  static const Tag kTemplateName
      //(300A,0244)
      = const Tag.public(
          "TemplateName", 0x300A0244, "Template Name", VR.kLO, VM.k1, false);
  static const Tag kTotalReferenceAirKerma
      //(300A,0250)
      = const Tag.public("TotalReferenceAirKerma", 0x300A0250,
          "Total Reference Air Kerma", VR.kDS, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceSequence
      //(300A,0260)
      = const Tag.public("BrachyAccessoryDeviceSequence", 0x300A0260,
          "Brachy Accessory Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceNumber
      //(300A,0262)
      = const Tag.public("BrachyAccessoryDeviceNumber", 0x300A0262,
          "Brachy Accessory Device Number", VR.kIS, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceID
      //(300A,0263)
      = const Tag.public("BrachyAccessoryDeviceID", 0x300A0263,
          "Brachy Accessory Device ID", VR.kSH, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceType
      //(300A,0264)
      = const Tag.public("BrachyAccessoryDeviceType", 0x300A0264,
          "Brachy Accessory Device Type", VR.kCS, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceName
      //(300A,0266)
      = const Tag.public("BrachyAccessoryDeviceName", 0x300A0266,
          "Brachy Accessory Device Name", VR.kLO, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceNominalThickness
      //(300A,026A)
      = const Tag.public("BrachyAccessoryDeviceNominalThickness", 0x300A026A,
          "Brachy Accessory Device Nominal Thickness", VR.kDS, VM.k1, false);
  static const Tag kBrachyAccessoryDeviceNominalTransmission
      //(300A,026C)
      = const Tag.public("BrachyAccessoryDeviceNominalTransmission", 0x300A026C,
          "Brachy Accessory Device Nominal Transmission", VR.kDS, VM.k1, false);
  static const Tag kChannelSequence
      //(300A,0280)
      = const Tag.public("ChannelSequence", 0x300A0280, "Channel Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kChannelNumber
      //(300A,0282)
      = const Tag.public(
          "ChannelNumber", 0x300A0282, "Channel Number", VR.kIS, VM.k1, false);
  static const Tag kChannelLength
      //(300A,0284)
      = const Tag.public(
          "ChannelLength", 0x300A0284, "Channel Length", VR.kDS, VM.k1, false);
  static const Tag kChannelTotalTime
      //(300A,0286)
      = const Tag.public("ChannelTotalTime", 0x300A0286, "Channel Total Time",
          VR.kDS, VM.k1, false);
  static const Tag kSourceMovementType
      //(300A,0288)
      = const Tag.public("SourceMovementType", 0x300A0288,
          "Source Movement Type", VR.kCS, VM.k1, false);
  static const Tag kNumberOfPulses
      //(300A,028A)
      = const Tag.public("NumberOfPulses", 0x300A028A, "Number of Pulses",
          VR.kIS, VM.k1, false);
  static const Tag kPulseRepetitionInterval
      //(300A,028C)
      = const Tag.public("PulseRepetitionInterval", 0x300A028C,
          "Pulse Repetition Interval", VR.kDS, VM.k1, false);
  static const Tag kSourceApplicatorNumber
      //(300A,0290)
      = const Tag.public("SourceApplicatorNumber", 0x300A0290,
          "Source Applicator Number", VR.kIS, VM.k1, false);
  static const Tag kSourceApplicatorID
      //(300A,0291)
      = const Tag.public("SourceApplicatorID", 0x300A0291,
          "Source Applicator ID", VR.kSH, VM.k1, false);
  static const Tag kSourceApplicatorType
      //(300A,0292)
      = const Tag.public("SourceApplicatorType", 0x300A0292,
          "Source Applicator Type", VR.kCS, VM.k1, false);
  static const Tag kSourceApplicatorName
      //(300A,0294)
      = const Tag.public("SourceApplicatorName", 0x300A0294,
          "Source Applicator Name", VR.kLO, VM.k1, false);
  static const Tag kSourceApplicatorLength
      //(300A,0296)
      = const Tag.public("SourceApplicatorLength", 0x300A0296,
          "Source Applicator Length", VR.kDS, VM.k1, false);
  static const Tag kSourceApplicatorManufacturer
      //(300A,0298)
      = const Tag.public("SourceApplicatorManufacturer", 0x300A0298,
          "Source Applicator Manufacturer", VR.kLO, VM.k1, false);
  static const Tag kSourceApplicatorWallNominalThickness
      //(300A,029C)
      = const Tag.public("SourceApplicatorWallNominalThickness", 0x300A029C,
          "Source Applicator Wall Nominal Thickness", VR.kDS, VM.k1, false);
  static const Tag kSourceApplicatorWallNominalTransmission
      //(300A,029E)
      = const Tag.public("SourceApplicatorWallNominalTransmission", 0x300A029E,
          "Source Applicator Wall Nominal Transmission", VR.kDS, VM.k1, false);
  static const Tag kSourceApplicatorStepSize
      //(300A,02A0)
      = const Tag.public("SourceApplicatorStepSize", 0x300A02A0,
          "Source Applicator Step Size", VR.kDS, VM.k1, false);
  static const Tag kTransferTubeNumber
      //(300A,02A2)
      = const Tag.public("TransferTubeNumber", 0x300A02A2,
          "Transfer Tube Number", VR.kIS, VM.k1, false);
  static const Tag kTransferTubeLength
      //(300A,02A4)
      = const Tag.public("TransferTubeLength", 0x300A02A4,
          "Transfer Tube Length", VR.kDS, VM.k1, false);
  static const Tag kChannelShieldSequence
      //(300A,02B0)
      = const Tag.public("ChannelShieldSequence", 0x300A02B0,
          "Channel Shield Sequence", VR.kSQ, VM.k1, false);
  static const Tag kChannelShieldNumber
      //(300A,02B2)
      = const Tag.public("ChannelShieldNumber", 0x300A02B2,
          "Channel Shield Number", VR.kIS, VM.k1, false);
  static const Tag kChannelShieldID
      //(300A,02B3)
      = const Tag.public("ChannelShieldID", 0x300A02B3, "Channel Shield ID",
          VR.kSH, VM.k1, false);
  static const Tag kChannelShieldName
      //(300A,02B4)
      = const Tag.public("ChannelShieldName", 0x300A02B4, "Channel Shield Name",
          VR.kLO, VM.k1, false);
  static const Tag kChannelShieldNominalThickness
      //(300A,02B8)
      = const Tag.public("ChannelShieldNominalThickness", 0x300A02B8,
          "Channel Shield Nominal Thickness", VR.kDS, VM.k1, false);
  static const Tag kChannelShieldNominalTransmission
      //(300A,02BA)
      = const Tag.public("ChannelShieldNominalTransmission", 0x300A02BA,
          "Channel Shield Nominal Transmission", VR.kDS, VM.k1, false);
  static const Tag kFinalCumulativeTimeWeight
      //(300A,02C8)
      = const Tag.public("FinalCumulativeTimeWeight", 0x300A02C8,
          "Final Cumulative Time Weight", VR.kDS, VM.k1, false);
  static const Tag kBrachyControlPointSequence
      //(300A,02D0)
      = const Tag.public("BrachyControlPointSequence", 0x300A02D0,
          "Brachy Control Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kControlPointRelativePosition
      //(300A,02D2)
      = const Tag.public("ControlPointRelativePosition", 0x300A02D2,
          "Control Point Relative Position", VR.kDS, VM.k1, false);
  static const Tag kControlPoint3DPosition
      //(300A,02D4)
      = const Tag.public("ControlPoint3DPosition", 0x300A02D4,
          "Control Point 3D Position", VR.kDS, VM.k3, false);
  static const Tag kCumulativeTimeWeight
      //(300A,02D6)
      = const Tag.public("CumulativeTimeWeight", 0x300A02D6,
          "Cumulative Time Weight", VR.kDS, VM.k1, false);
  static const Tag kCompensatorDivergence
      //(300A,02E0)
      = const Tag.public("CompensatorDivergence", 0x300A02E0,
          "Compensator Divergence", VR.kCS, VM.k1, false);
  static const Tag kCompensatorMountingPosition
      //(300A,02E1)
      = const Tag.public("CompensatorMountingPosition", 0x300A02E1,
          "Compensator Mounting Position", VR.kCS, VM.k1, false);
  static const Tag kSourceToCompensatorDistance
      //(300A,02E2)
      = const Tag.public("SourceToCompensatorDistance", 0x300A02E2,
          "Source to Compensator Distance", VR.kDS, VM.k1_n, false);
  static const Tag kTotalCompensatorTrayWaterEquivalentThickness
      //(300A,02E3)
      = const Tag.public(
          "TotalCompensatorTrayWaterEquivalentThickness",
          0x300A02E3,
          "Total Compensator Tray Water-Equivalent Thickness",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kIsocenterToCompensatorTrayDistance
      //(300A,02E4)
      = const Tag.public("IsocenterToCompensatorTrayDistance", 0x300A02E4,
          "Isocenter to Compensator Tray Distance", VR.kFL, VM.k1, false);
  static const Tag kCompensatorColumnOffset
      //(300A,02E5)
      = const Tag.public("CompensatorColumnOffset", 0x300A02E5,
          "Compensator Column Offset", VR.kFL, VM.k1, false);
  static const Tag kIsocenterToCompensatorDistances
      //(300A,02E6)
      = const Tag.public("IsocenterToCompensatorDistances", 0x300A02E6,
          "Isocenter to Compensator Distances", VR.kFL, VM.k1_n, false);
  static const Tag kCompensatorRelativeStoppingPowerRatio
      //(300A,02E7)
      = const Tag.public("CompensatorRelativeStoppingPowerRatio", 0x300A02E7,
          "Compensator Relative Stopping Power Ratio", VR.kFL, VM.k1, false);
  static const Tag kCompensatorMillingToolDiameter
      //(300A,02E8)
      = const Tag.public("CompensatorMillingToolDiameter", 0x300A02E8,
          "Compensator Milling Tool Diameter", VR.kFL, VM.k1, false);
  static const Tag kIonRangeCompensatorSequence
      //(300A,02EA)
      = const Tag.public("IonRangeCompensatorSequence", 0x300A02EA,
          "Ion Range Compensator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCompensatorDescription
      //(300A,02EB)
      = const Tag.public("CompensatorDescription", 0x300A02EB,
          "Compensator Description", VR.kLT, VM.k1, false);
  static const Tag kRadiationMassNumber
      //(300A,0302)
      = const Tag.public("RadiationMassNumber", 0x300A0302,
          "Radiation Mass Number", VR.kIS, VM.k1, false);
  static const Tag kRadiationAtomicNumber
      //(300A,0304)
      = const Tag.public("RadiationAtomicNumber", 0x300A0304,
          "Radiation Atomic Number", VR.kIS, VM.k1, false);
  static const Tag kRadiationChargeState
      //(300A,0306)
      = const Tag.public("RadiationChargeState", 0x300A0306,
          "Radiation Charge State", VR.kSS, VM.k1, false);
  static const Tag kScanMode
      //(300A,0308)
      = const Tag.public(
          "ScanMode", 0x300A0308, "Scan Mode", VR.kCS, VM.k1, false);
  static const Tag kVirtualSourceAxisDistances
      //(300A,030A)
      = const Tag.public("VirtualSourceAxisDistances", 0x300A030A,
          "Virtual Source-Axis Distances", VR.kFL, VM.k2, false);
  static const Tag kSnoutSequence
      //(300A,030C)
      = const Tag.public(
          "SnoutSequence", 0x300A030C, "Snout Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSnoutPosition
      //(300A,030D)
      = const Tag.public(
          "SnoutPosition", 0x300A030D, "Snout Position", VR.kFL, VM.k1, false);
  static const Tag kSnoutID
      //(300A,030F)
      =
      const Tag.public("SnoutID", 0x300A030F, "Snout ID", VR.kSH, VM.k1, false);
  static const Tag kNumberOfRangeShifters
      //(300A,0312)
      = const Tag.public("NumberOfRangeShifters", 0x300A0312,
          "Number of Range Shifters", VR.kIS, VM.k1, false);
  static const Tag kRangeShifterSequence
      //(300A,0314)
      = const Tag.public("RangeShifterSequence", 0x300A0314,
          "Range Shifter Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRangeShifterNumber
      //(300A,0316)
      = const Tag.public("RangeShifterNumber", 0x300A0316,
          "Range Shifter Number", VR.kIS, VM.k1, false);
  static const Tag kRangeShifterID
      //(300A,0318)
      = const Tag.public("RangeShifterID", 0x300A0318, "Range Shifter ID",
          VR.kSH, VM.k1, false);
  static const Tag kRangeShifterType
      //(300A,0320)
      = const Tag.public("RangeShifterType", 0x300A0320, "Range Shifter Type",
          VR.kCS, VM.k1, false);
  static const Tag kRangeShifterDescription
      //(300A,0322)
      = const Tag.public("RangeShifterDescription", 0x300A0322,
          "Range Shifter Description", VR.kLO, VM.k1, false);
  static const Tag kNumberOfLateralSpreadingDevices
      //(300A,0330)
      = const Tag.public("NumberOfLateralSpreadingDevices", 0x300A0330,
          "Number of Lateral Spreading Devices", VR.kIS, VM.k1, false);
  static const Tag kLateralSpreadingDeviceSequence
      //(300A,0332)
      = const Tag.public("LateralSpreadingDeviceSequence", 0x300A0332,
          "Lateral Spreading Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLateralSpreadingDeviceNumber
      //(300A,0334)
      = const Tag.public("LateralSpreadingDeviceNumber", 0x300A0334,
          "Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const Tag kLateralSpreadingDeviceID
      //(300A,0336)
      = const Tag.public("LateralSpreadingDeviceID", 0x300A0336,
          "Lateral Spreading Device ID", VR.kSH, VM.k1, false);
  static const Tag kLateralSpreadingDeviceType
      //(300A,0338)
      = const Tag.public("LateralSpreadingDeviceType", 0x300A0338,
          "Lateral Spreading Device Type", VR.kCS, VM.k1, false);
  static const Tag kLateralSpreadingDeviceDescription
      //(300A,033A)
      = const Tag.public("LateralSpreadingDeviceDescription", 0x300A033A,
          "Lateral Spreading Device Description", VR.kLO, VM.k1, false);
  static const Tag kLateralSpreadingDeviceWaterEquivalentThickness
      //(300A,033C)
      = const Tag.public(
          "LateralSpreadingDeviceWaterEquivalentThickness",
          0x300A033C,
          "Lateral Spreading Device Water Equivalent Thickness",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kNumberOfRangeModulators
      //(300A,0340)
      = const Tag.public("NumberOfRangeModulators", 0x300A0340,
          "Number of Range Modulators", VR.kIS, VM.k1, false);
  static const Tag kRangeModulatorSequence
      //(300A,0342)
      = const Tag.public("RangeModulatorSequence", 0x300A0342,
          "Range Modulator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRangeModulatorNumber
      //(300A,0344)
      = const Tag.public("RangeModulatorNumber", 0x300A0344,
          "Range Modulator Number", VR.kIS, VM.k1, false);
  static const Tag kRangeModulatorID
      //(300A,0346)
      = const Tag.public("RangeModulatorID", 0x300A0346, "Range Modulator ID",
          VR.kSH, VM.k1, false);
  static const Tag kRangeModulatorType
      //(300A,0348)
      = const Tag.public("RangeModulatorType", 0x300A0348,
          "Range Modulator Type", VR.kCS, VM.k1, false);
  static const Tag kRangeModulatorDescription
      //(300A,034A)
      = const Tag.public("RangeModulatorDescription", 0x300A034A,
          "Range Modulator Description", VR.kLO, VM.k1, false);
  static const Tag kBeamCurrentModulationID
      //(300A,034C)
      = const Tag.public("BeamCurrentModulationID", 0x300A034C,
          "Beam Current Modulation ID", VR.kSH, VM.k1, false);
  static const Tag kPatientSupportType
      //(300A,0350)
      = const Tag.public("PatientSupportType", 0x300A0350,
          "Patient Support Type", VR.kCS, VM.k1, false);
  static const Tag kPatientSupportID
      //(300A,0352)
      = const Tag.public("PatientSupportID", 0x300A0352, "Patient Support ID",
          VR.kSH, VM.k1, false);
  static const Tag kPatientSupportAccessoryCode
      //(300A,0354)
      = const Tag.public("PatientSupportAccessoryCode", 0x300A0354,
          "Patient Support Accessory Code", VR.kLO, VM.k1, false);
  static const Tag kFixationLightAzimuthalAngle
      //(300A,0356)
      = const Tag.public("FixationLightAzimuthalAngle", 0x300A0356,
          "Fixation Light Azimuthal Angle", VR.kFL, VM.k1, false);
  static const Tag kFixationLightPolarAngle
      //(300A,0358)
      = const Tag.public("FixationLightPolarAngle", 0x300A0358,
          "Fixation Light Polar Angle", VR.kFL, VM.k1, false);
  static const Tag kMetersetRate
      //(300A,035A)
      = const Tag.public(
          "MetersetRate", 0x300A035A, "Meterset Rate", VR.kFL, VM.k1, false);
  static const Tag kRangeShifterSettingsSequence
      //(300A,0360)
      = const Tag.public("RangeShifterSettingsSequence", 0x300A0360,
          "Range Shifter Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRangeShifterSetting
      //(300A,0362)
      = const Tag.public("RangeShifterSetting", 0x300A0362,
          "Range Shifter Setting", VR.kLO, VM.k1, false);
  static const Tag kIsocenterToRangeShifterDistance
      //(300A,0364)
      = const Tag.public("IsocenterToRangeShifterDistance", 0x300A0364,
          "Isocenter to Range Shifter Distance", VR.kFL, VM.k1, false);
  static const Tag kRangeShifterWaterEquivalentThickness
      //(300A,0366)
      = const Tag.public("RangeShifterWaterEquivalentThickness", 0x300A0366,
          "Range Shifter Water Equivalent Thickness", VR.kFL, VM.k1, false);
  static const Tag kLateralSpreadingDeviceSettingsSequence
      //(300A,0370)
      = const Tag.public("LateralSpreadingDeviceSettingsSequence", 0x300A0370,
          "Lateral Spreading Device Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kLateralSpreadingDeviceSetting
      //(300A,0372)
      = const Tag.public("LateralSpreadingDeviceSetting", 0x300A0372,
          "Lateral Spreading Device Setting", VR.kLO, VM.k1, false);
  static const Tag kIsocenterToLateralSpreadingDeviceDistance
      //(300A,0374)
      = const Tag.public(
          "IsocenterToLateralSpreadingDeviceDistance",
          0x300A0374,
          "Isocenter to Lateral Spreading Device Distance",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kRangeModulatorSettingsSequence
      //(300A,0380)
      = const Tag.public("RangeModulatorSettingsSequence", 0x300A0380,
          "Range Modulator Settings Sequence", VR.kSQ, VM.k1, false);
  static const Tag kRangeModulatorGatingStartValue
      //(300A,0382)
      = const Tag.public("RangeModulatorGatingStartValue", 0x300A0382,
          "Range Modulator Gating Start Value", VR.kFL, VM.k1, false);
  static const Tag kRangeModulatorGatingStopValue
      //(300A,0384)
      = const Tag.public("RangeModulatorGatingStopValue", 0x300A0384,
          "Range Modulator Gating Stop Value", VR.kFL, VM.k1, false);
  static const Tag kRangeModulatorGatingStartWaterEquivalentThickness
      //(300A,0386)
      = const Tag.public(
          "RangeModulatorGatingStartWaterEquivalentThickness",
          0x300A0386,
          "Range Modulator Gating Start Water Equivalent Thickness",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kRangeModulatorGatingStopWaterEquivalentThickness
      //(300A,0388)
      = const Tag.public(
          "RangeModulatorGatingStopWaterEquivalentThickness",
          0x300A0388,
          "Range Modulator Gating Stop Water Equivalent Thickness",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kIsocenterToRangeModulatorDistance
      //(300A,038A)
      = const Tag.public("IsocenterToRangeModulatorDistance", 0x300A038A,
          "Isocenter to Range Modulator Distance", VR.kFL, VM.k1, false);
  static const Tag kScanSpotTuneID
      //(300A,0390)
      = const Tag.public("ScanSpotTuneID", 0x300A0390, "Scan Spot Tune ID",
          VR.kSH, VM.k1, false);
  static const Tag kNumberOfScanSpotPositions
      //(300A,0392)
      = const Tag.public("NumberOfScanSpotPositions", 0x300A0392,
          "Number of Scan Spot Positions", VR.kIS, VM.k1, false);
  static const Tag kScanSpotPositionMap
      //(300A,0394)
      = const Tag.public("ScanSpotPositionMap", 0x300A0394,
          "Scan Spot Position Map", VR.kFL, VM.k1_n, false);
  static const Tag kScanSpotMetersetWeights
      //(300A,0396)
      = const Tag.public("ScanSpotMetersetWeights", 0x300A0396,
          "Scan Spot Meterset Weights", VR.kFL, VM.k1_n, false);
  static const Tag kScanningSpotSize
      //(300A,0398)
      = const Tag.public("ScanningSpotSize", 0x300A0398, "Scanning Spot Size",
          VR.kFL, VM.k2, false);
  static const Tag kNumberOfPaintings
      //(300A,039A)
      = const Tag.public("NumberOfPaintings", 0x300A039A, "Number of Paintings",
          VR.kIS, VM.k1, false);
  static const Tag kIonToleranceTableSequence
      //(300A,03A0)
      = const Tag.public("IonToleranceTableSequence", 0x300A03A0,
          "Ion Tolerance Table Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIonBeamSequence
      //(300A,03A2)
      = const Tag.public("IonBeamSequence", 0x300A03A2, "Ion Beam Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kIonBeamLimitingDeviceSequence
      //(300A,03A4)
      = const Tag.public("IonBeamLimitingDeviceSequence", 0x300A03A4,
          "Ion Beam Limiting Device Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIonBlockSequence
      //(300A,03A6)
      = const Tag.public("IonBlockSequence", 0x300A03A6, "Ion Block Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kIonControlPointSequence
      //(300A,03A8)
      = const Tag.public("IonControlPointSequence", 0x300A03A8,
          "Ion Control Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kIonWedgeSequence
      //(300A,03AA)
      = const Tag.public("IonWedgeSequence", 0x300A03AA, "Ion Wedge Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kIonWedgePositionSequence
      //(300A,03AC)
      = const Tag.public("IonWedgePositionSequence", 0x300A03AC,
          "Ion Wedge Position Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedSetupImageSequence
      //(300A,0401)
      = const Tag.public("ReferencedSetupImageSequence", 0x300A0401,
          "Referenced Setup Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSetupImageComment
      //(300A,0402)
      = const Tag.public("SetupImageComment", 0x300A0402, "Setup Image Comment",
          VR.kST, VM.k1, false);
  static const Tag kMotionSynchronizationSequence
      //(300A,0410)
      = const Tag.public("MotionSynchronizationSequence", 0x300A0410,
          "Motion Synchronization Sequence", VR.kSQ, VM.k1, false);
  static const Tag kControlPointOrientation
      //(300A,0412)
      = const Tag.public("ControlPointOrientation", 0x300A0412,
          "Control Point Orientation", VR.kFL, VM.k3, false);
  static const Tag kGeneralAccessorySequence
      //(300A,0420)
      = const Tag.public("GeneralAccessorySequence", 0x300A0420,
          "General Accessory Sequence", VR.kSQ, VM.k1, false);
  static const Tag kGeneralAccessoryID
      //(300A,0421)
      = const Tag.public("GeneralAccessoryID", 0x300A0421,
          "General Accessory ID", VR.kSH, VM.k1, false);
  static const Tag kGeneralAccessoryDescription
      //(300A,0422)
      = const Tag.public("GeneralAccessoryDescription", 0x300A0422,
          "General Accessory Description", VR.kST, VM.k1, false);
  static const Tag kGeneralAccessoryType
      //(300A,0423)
      = const Tag.public("GeneralAccessoryType", 0x300A0423,
          "General Accessory Type", VR.kCS, VM.k1, false);
  static const Tag kGeneralAccessoryNumber
      //(300A,0424)
      = const Tag.public("GeneralAccessoryNumber", 0x300A0424,
          "General Accessory Number", VR.kIS, VM.k1, false);
  static const Tag kSourceToGeneralAccessoryDistance
      //(300A,0425)
      = const Tag.public("SourceToGeneralAccessoryDistance", 0x300A0425,
          "Source to General Accessory Distance", VR.kFL, VM.k1, false);
  static const Tag kApplicatorGeometrySequence
      //(300A,0431)
      = const Tag.public("ApplicatorGeometrySequence", 0x300A0431,
          "Applicator Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kApplicatorApertureShape
      //(300A,0432)
      = const Tag.public("ApplicatorApertureShape", 0x300A0432,
          "Applicator Aperture Shape", VR.kCS, VM.k1, false);
  static const Tag kApplicatorOpening
      //(300A,0433)
      = const Tag.public("ApplicatorOpening", 0x300A0433, "Applicator Opening",
          VR.kFL, VM.k1, false);
  static const Tag kApplicatorOpeningX
      //(300A,0434)
      = const Tag.public("ApplicatorOpeningX", 0x300A0434,
          "Applicator Opening X", VR.kFL, VM.k1, false);
  static const Tag kApplicatorOpeningY
      //(300A,0435)
      = const Tag.public("ApplicatorOpeningY", 0x300A0435,
          "Applicator Opening Y", VR.kFL, VM.k1, false);
  static const Tag kSourceToApplicatorMountingPositionDistance
      //(300A,0436)
      = const Tag.public(
          "SourceToApplicatorMountingPositionDistance",
          0x300A0436,
          "Source to Applicator Mounting Position Distance",
          VR.kFL,
          VM.k1,
          false);
  static const Tag kReferencedRTPlanSequence
      //(300C,0002)
      = const Tag.public("ReferencedRTPlanSequence", 0x300C0002,
          "Referenced RT Plan Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedBeamSequence
      //(300C,0004)
      = const Tag.public("ReferencedBeamSequence", 0x300C0004,
          "Referenced Beam Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedBeamNumber
      //(300C,0006)
      = const Tag.public("ReferencedBeamNumber", 0x300C0006,
          "Referenced Beam Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedReferenceImageNumber
      //(300C,0007)
      = const Tag.public("ReferencedReferenceImageNumber", 0x300C0007,
          "Referenced Reference Image Number", VR.kIS, VM.k1, false);
  static const Tag kStartCumulativeMetersetWeight
      //(300C,0008)
      = const Tag.public("StartCumulativeMetersetWeight", 0x300C0008,
          "Start Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const Tag kEndCumulativeMetersetWeight
      //(300C,0009)
      = const Tag.public("EndCumulativeMetersetWeight", 0x300C0009,
          "End Cumulative Meterset Weight", VR.kDS, VM.k1, false);
  static const Tag kReferencedBrachyApplicationSetupSequence
      //(300C,000A)
      = const Tag.public("ReferencedBrachyApplicationSetupSequence", 0x300C000A,
          "Referenced Brachy Application Setup Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedBrachyApplicationSetupNumber
      //(300C,000C)
      = const Tag.public("ReferencedBrachyApplicationSetupNumber", 0x300C000C,
          "Referenced Brachy Application Setup Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedSourceNumber
      //(300C,000E)
      = const Tag.public("ReferencedSourceNumber", 0x300C000E,
          "Referenced Source Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedFractionGroupSequence
      //(300C,0020)
      = const Tag.public("ReferencedFractionGroupSequence", 0x300C0020,
          "Referenced Fraction Group Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedFractionGroupNumber
      //(300C,0022)
      = const Tag.public("ReferencedFractionGroupNumber", 0x300C0022,
          "Referenced Fraction Group Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedVerificationImageSequence
      //(300C,0040)
      = const Tag.public("ReferencedVerificationImageSequence", 0x300C0040,
          "Referenced Verification Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedReferenceImageSequence
      //(300C,0042)
      = const Tag.public("ReferencedReferenceImageSequence", 0x300C0042,
          "Referenced Reference Image Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedDoseReferenceSequence
      //(300C,0050)
      = const Tag.public("ReferencedDoseReferenceSequence", 0x300C0050,
          "Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedDoseReferenceNumber
      //(300C,0051)
      = const Tag.public("ReferencedDoseReferenceNumber", 0x300C0051,
          "Referenced Dose Reference Number", VR.kIS, VM.k1, false);
  static const Tag kBrachyReferencedDoseReferenceSequence
      //(300C,0055)
      = const Tag.public("BrachyReferencedDoseReferenceSequence", 0x300C0055,
          "Brachy Referenced Dose Reference Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedStructureSetSequence
      //(300C,0060)
      = const Tag.public("ReferencedStructureSetSequence", 0x300C0060,
          "Referenced Structure Set Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedPatientSetupNumber
      //(300C,006A)
      = const Tag.public("ReferencedPatientSetupNumber", 0x300C006A,
          "Referenced Patient Setup Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedDoseSequence
      //(300C,0080)
      = const Tag.public("ReferencedDoseSequence", 0x300C0080,
          "Referenced Dose Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedToleranceTableNumber
      //(300C,00A0)
      = const Tag.public("ReferencedToleranceTableNumber", 0x300C00A0,
          "Referenced Tolerance Table Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedBolusSequence
      //(300C,00B0)
      = const Tag.public("ReferencedBolusSequence", 0x300C00B0,
          "Referenced Bolus Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedWedgeNumber
      //(300C,00C0)
      = const Tag.public("ReferencedWedgeNumber", 0x300C00C0,
          "Referenced Wedge Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedCompensatorNumber
      //(300C,00D0)
      = const Tag.public("ReferencedCompensatorNumber", 0x300C00D0,
          "Referenced Compensator Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedBlockNumber
      //(300C,00E0)
      = const Tag.public("ReferencedBlockNumber", 0x300C00E0,
          "Referenced Block Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedControlPointIndex
      //(300C,00F0)
      = const Tag.public("ReferencedControlPointIndex", 0x300C00F0,
          "Referenced Control Point Index", VR.kIS, VM.k1, false);
  static const Tag kReferencedControlPointSequence
      //(300C,00F2)
      = const Tag.public("ReferencedControlPointSequence", 0x300C00F2,
          "Referenced Control Point Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedStartControlPointIndex
      //(300C,00F4)
      = const Tag.public("ReferencedStartControlPointIndex", 0x300C00F4,
          "Referenced Start Control Point Index", VR.kIS, VM.k1, false);
  static const Tag kReferencedStopControlPointIndex
      //(300C,00F6)
      = const Tag.public("ReferencedStopControlPointIndex", 0x300C00F6,
          "Referenced Stop Control Point Index", VR.kIS, VM.k1, false);
  static const Tag kReferencedRangeShifterNumber
      //(300C,0100)
      = const Tag.public("ReferencedRangeShifterNumber", 0x300C0100,
          "Referenced Range Shifter Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedLateralSpreadingDeviceNumber
      //(300C,0102)
      = const Tag.public("ReferencedLateralSpreadingDeviceNumber", 0x300C0102,
          "Referenced Lateral Spreading Device Number", VR.kIS, VM.k1, false);
  static const Tag kReferencedRangeModulatorNumber
      //(300C,0104)
      = const Tag.public("ReferencedRangeModulatorNumber", 0x300C0104,
          "Referenced Range Modulator Number", VR.kIS, VM.k1, false);
  static const Tag kApprovalStatus
      //(300E,0002)
      = const Tag.public("ApprovalStatus", 0x300E0002, "Approval Status",
          VR.kCS, VM.k1, false);
  static const Tag kReviewDate
      //(300E,0004)
      = const Tag.public(
          "ReviewDate", 0x300E0004, "Review Date", VR.kDA, VM.k1, false);
  static const Tag kReviewTime
      //(300E,0005)
      = const Tag.public(
          "ReviewTime", 0x300E0005, "Review Time", VR.kTM, VM.k1, false);
  static const Tag kReviewerName
      //(300E,0008)
      = const Tag.public(
          "ReviewerName", 0x300E0008, "Reviewer Name", VR.kPN, VM.k1, false);
  static const Tag kArbitrary
      //(4000,0010)
      = const Tag.public(
          "Arbitrary", 0x40000010, "Arbitrary", VR.kLT, VM.k1, true);
  static const Tag kTextComments
      //(4000,4000)
      = const Tag.public(
          "TextComments", 0x40004000, "Text Comments", VR.kLT, VM.k1, true);
  static const Tag kResultsID
      //(4008,0040)
      = const Tag.public(
          "ResultsID", 0x40080040, "Results ID", VR.kSH, VM.k1, true);
  static const Tag kResultsIDIssuer
      //(4008,0042)
      = const Tag.public("ResultsIDIssuer", 0x40080042, "Results ID Issuer",
          VR.kLO, VM.k1, true);
  static const Tag kReferencedInterpretationSequence
      //(4008,0050)
      = const Tag.public("ReferencedInterpretationSequence", 0x40080050,
          "Referenced Interpretation Sequence", VR.kSQ, VM.k1, true);
  static const Tag kReportProductionStatusTrial
      //(4008,00FF)
      = const Tag.public("ReportProductionStatusTrial", 0x400800FF,
          "Report Production Status (Trial)", VR.kCS, VM.k1, true);
  static const Tag kInterpretationRecordedDate
      //(4008,0100)
      = const Tag.public("InterpretationRecordedDate", 0x40080100,
          "Interpretation Recorded Date", VR.kDA, VM.k1, true);
  static const Tag kInterpretationRecordedTime
      //(4008,0101)
      = const Tag.public("InterpretationRecordedTime", 0x40080101,
          "Interpretation Recorded Time", VR.kTM, VM.k1, true);
  static const Tag kInterpretationRecorder
      //(4008,0102)
      = const Tag.public("InterpretationRecorder", 0x40080102,
          "Interpretation Recorder", VR.kPN, VM.k1, true);
  static const Tag kReferenceToRecordedSound
      //(4008,0103)
      = const Tag.public("ReferenceToRecordedSound", 0x40080103,
          "Reference to Recorded Sound", VR.kLO, VM.k1, true);
  static const Tag kInterpretationTranscriptionDate
      //(4008,0108)
      = const Tag.public("InterpretationTranscriptionDate", 0x40080108,
          "Interpretation Transcription Date", VR.kDA, VM.k1, true);
  static const Tag kInterpretationTranscriptionTime
      //(4008,0109)
      = const Tag.public("InterpretationTranscriptionTime", 0x40080109,
          "Interpretation Transcription Time", VR.kTM, VM.k1, true);
  static const Tag kInterpretationTranscriber
      //(4008,010A)
      = const Tag.public("InterpretationTranscriber", 0x4008010A,
          "Interpretation Transcriber", VR.kPN, VM.k1, true);
  static const Tag kInterpretationText
      //(4008,010B)
      = const Tag.public("InterpretationText", 0x4008010B,
          "Interpretation Text", VR.kST, VM.k1, true);
  static const Tag kInterpretationAuthor
      //(4008,010C)
      = const Tag.public("InterpretationAuthor", 0x4008010C,
          "Interpretation Author", VR.kPN, VM.k1, true);
  static const Tag kInterpretationApproverSequence
      //(4008,0111)
      = const Tag.public("InterpretationApproverSequence", 0x40080111,
          "Interpretation Approver Sequence", VR.kSQ, VM.k1, true);
  static const Tag kInterpretationApprovalDate
      //(4008,0112)
      = const Tag.public("InterpretationApprovalDate", 0x40080112,
          "Interpretation Approval Date", VR.kDA, VM.k1, true);
  static const Tag kInterpretationApprovalTime
      //(4008,0113)
      = const Tag.public("InterpretationApprovalTime", 0x40080113,
          "Interpretation Approval Time", VR.kTM, VM.k1, true);
  static const Tag kPhysicianApprovingInterpretation
      //(4008,0114)
      = const Tag.public("PhysicianApprovingInterpretation", 0x40080114,
          "Physician Approving Interpretation", VR.kPN, VM.k1, true);
  static const Tag kInterpretationDiagnosisDescription
      //(4008,0115)
      = const Tag.public("InterpretationDiagnosisDescription", 0x40080115,
          "Interpretation Diagnosis Description", VR.kLT, VM.k1, true);
  static const Tag kInterpretationDiagnosisCodeSequence
      //(4008,0117)
      = const Tag.public("InterpretationDiagnosisCodeSequence", 0x40080117,
          "Interpretation Diagnosis Code Sequence", VR.kSQ, VM.k1, true);
  static const Tag kResultsDistributionListSequence
      //(4008,0118)
      = const Tag.public("ResultsDistributionListSequence", 0x40080118,
          "Results Distribution List Sequence", VR.kSQ, VM.k1, true);
  static const Tag kDistributionName
      //(4008,0119)
      = const Tag.public("DistributionName", 0x40080119, "Distribution Name",
          VR.kPN, VM.k1, true);
  static const Tag kDistributionAddress
      //(4008,011A)
      = const Tag.public("DistributionAddress", 0x4008011A,
          "Distribution Address", VR.kLO, VM.k1, true);
  static const Tag kInterpretationID
      //(4008,0200)
      = const Tag.public("InterpretationID", 0x40080200, "Interpretation ID",
          VR.kSH, VM.k1, true);
  static const Tag kInterpretationIDIssuer
      //(4008,0202)
      = const Tag.public("InterpretationIDIssuer", 0x40080202,
          "Interpretation ID Issuer", VR.kLO, VM.k1, true);
  static const Tag kInterpretationTypeID
      //(4008,0210)
      = const Tag.public("InterpretationTypeID", 0x40080210,
          "Interpretation Type ID", VR.kCS, VM.k1, true);
  static const Tag kInterpretationStatusID
      //(4008,0212)
      = const Tag.public("InterpretationStatusID", 0x40080212,
          "Interpretation Status ID", VR.kCS, VM.k1, true);
  static const Tag kImpressions
      //(4008,0300)
      = const Tag.public(
          "Impressions", 0x40080300, "Impressions", VR.kST, VM.k1, true);
  static const Tag kResultsComments
      //(4008,4000)
      = const Tag.public("ResultsComments", 0x40084000, "Results Comments",
          VR.kST, VM.k1, true);
  static const Tag kLowEnergyDetectors
      //(4010,0001)
      = const Tag.public("LowEnergyDetectors", 0x40100001,
          "Low Energy Detectors", VR.kCS, VM.k1, false);
  static const Tag kHighEnergyDetectors
      //(4010,0002)
      = const Tag.public("HighEnergyDetectors", 0x40100002,
          "High Energy Detectors", VR.kCS, VM.k1, false);
  static const Tag kDetectorGeometrySequence
      //(4010,0004)
      = const Tag.public("DetectorGeometrySequence", 0x40100004,
          "Detector Geometry Sequence", VR.kSQ, VM.k1, false);
  static const Tag kThreatROIVoxelSequence
      //(4010,1001)
      = const Tag.public("ThreatROIVoxelSequence", 0x40101001,
          "Threat ROI Voxel Sequence", VR.kSQ, VM.k1, false);
  static const Tag kThreatROIBase
      //(4010,1004)
      = const Tag.public(
          "ThreatROIBase", 0x40101004, "Threat ROI Base", VR.kFL, VM.k3, false);
  static const Tag kThreatROIExtents
      //(4010,1005)
      = const Tag.public("ThreatROIExtents", 0x40101005, "Threat ROI Extents",
          VR.kFL, VM.k3, false);
  static const Tag kThreatROIBitmap
      //(4010,1006)
      = const Tag.public("ThreatROIBitmap", 0x40101006, "Threat ROI Bitmap",
          VR.kOB, VM.k1, false);
  static const Tag kRouteSegmentID
      //(4010,1007)
      = const Tag.public("RouteSegmentID", 0x40101007, "Route Segment ID",
          VR.kSH, VM.k1, false);
  static const Tag kGantryType
      //(4010,1008)
      = const Tag.public(
          "GantryType", 0x40101008, "Gantry Type", VR.kCS, VM.k1, false);
  static const Tag kOOIOwnerType
      //(4010,1009)
      = const Tag.public(
          "OOIOwnerType", 0x40101009, "OOI Owner Type", VR.kCS, VM.k1, false);
  static const Tag kRouteSegmentSequence
      //(4010,100A)
      = const Tag.public("RouteSegmentSequence", 0x4010100A,
          "Route Segment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPotentialThreatObjectID
      //(4010,1010)
      = const Tag.public("PotentialThreatObjectID", 0x40101010,
          "Potential Threat Object ID", VR.kUS, VM.k1, false);
  static const Tag kThreatSequence
      //(4010,1011)
      = const Tag.public("ThreatSequence", 0x40101011, "Threat Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kThreatCategory
      //(4010,1012)
      = const Tag.public("ThreatCategory", 0x40101012, "Threat Category",
          VR.kCS, VM.k1, false);
  static const Tag kThreatCategoryDescription
      //(4010,1013)
      = const Tag.public("ThreatCategoryDescription", 0x40101013,
          "Threat Category Description", VR.kLT, VM.k1, false);
  static const Tag kATDAbilityAssessment
      //(4010,1014)
      = const Tag.public("ATDAbilityAssessment", 0x40101014,
          "ATD Ability Assessment", VR.kCS, VM.k1, false);
  static const Tag kATDAssessmentFlag
      //(4010,1015)
      = const Tag.public("ATDAssessmentFlag", 0x40101015, "ATD Assessment Flag",
          VR.kCS, VM.k1, false);
  static const Tag kATDAssessmentProbability
      //(4010,1016)
      = const Tag.public("ATDAssessmentProbability", 0x40101016,
          "ATD Assessment Probability", VR.kFL, VM.k1, false);
  static const Tag kMass
      //(4010,1017)
      = const Tag.public("Mass", 0x40101017, "Mass", VR.kFL, VM.k1, false);
  static const Tag kDensity
      //(4010,1018)
      =
      const Tag.public("Density", 0x40101018, "Density", VR.kFL, VM.k1, false);
  static const Tag kZEffective
      //(4010,1019)
      = const Tag.public(
          "ZEffective", 0x40101019, "Z Effective", VR.kFL, VM.k1, false);
  static const Tag kBoardingPassID
      //(4010,101A)
      = const Tag.public("BoardingPassID", 0x4010101A, "Boarding Pass ID",
          VR.kSH, VM.k1, false);
  static const Tag kCenterOfMass
      //(4010,101B)
      = const Tag.public(
          "CenterOfMass", 0x4010101B, "Center of Mass", VR.kFL, VM.k3, false);
  static const Tag kCenterOfPTO
      //(4010,101C)
      = const Tag.public(
          "CenterOfPTO", 0x4010101C, "Center of PTO", VR.kFL, VM.k3, false);
  static const Tag kBoundingPolygon
      //(4010,101D)
      = const Tag.public("BoundingPolygon", 0x4010101D, "Bounding Polygon",
          VR.kFL, VM.k6_n, false);
  static const Tag kRouteSegmentStartLocationID
      //(4010,101E)
      = const Tag.public("RouteSegmentStartLocationID", 0x4010101E,
          "Route Segment Start Location ID", VR.kSH, VM.k1, false);
  static const Tag kRouteSegmentEndLocationID
      //(4010,101F)
      = const Tag.public("RouteSegmentEndLocationID", 0x4010101F,
          "Route Segment End Location ID", VR.kSH, VM.k1, false);
  static const Tag kRouteSegmentLocationIDType
      //(4010,1020)
      = const Tag.public("RouteSegmentLocationIDType", 0x40101020,
          "Route Segment Location ID Type", VR.kCS, VM.k1, false);
  static const Tag kAbortReason
      //(4010,1021)
      = const Tag.public(
          "AbortReason", 0x40101021, "Abort Reason", VR.kCS, VM.k1_n, false);
  static const Tag kVolumeOfPTO
      //(4010,1023)
      = const Tag.public(
          "VolumeOfPTO", 0x40101023, "Volume of PTO", VR.kFL, VM.k1, false);
  static const Tag kAbortFlag
      //(4010,1024)
      = const Tag.public(
          "AbortFlag", 0x40101024, "Abort Flag", VR.kCS, VM.k1, false);
  static const Tag kRouteSegmentStartTime
      //(4010,1025)
      = const Tag.public("RouteSegmentStartTime", 0x40101025,
          "Route Segment Start Time", VR.kDT, VM.k1, false);
  static const Tag kRouteSegmentEndTime
      //(4010,1026)
      = const Tag.public("RouteSegmentEndTime", 0x40101026,
          "Route Segment End Time", VR.kDT, VM.k1, false);
  static const Tag kTDRType
      //(4010,1027)
      =
      const Tag.public("TDRType", 0x40101027, "TDR Type", VR.kCS, VM.k1, false);
  static const Tag kInternationalRouteSegment
      //(4010,1028)
      = const Tag.public("InternationalRouteSegment", 0x40101028,
          "International Route Segment", VR.kCS, VM.k1, false);
  static const Tag kThreatDetectionAlgorithmandVersion
      //(4010,1029)
      = const Tag.public("ThreatDetectionAlgorithmandVersion", 0x40101029,
          "Threat Detection Algorithm and Version", VR.kLO, VM.k1_n, false);
  static const Tag kAssignedLocation
      //(4010,102A)
      = const Tag.public("AssignedLocation", 0x4010102A, "Assigned Location",
          VR.kSH, VM.k1, false);
  static const Tag kAlarmDecisionTime
      //(4010,102B)
      = const Tag.public("AlarmDecisionTime", 0x4010102B, "Alarm Decision Time",
          VR.kDT, VM.k1, false);
  static const Tag kAlarmDecision
      //(4010,1031)
      = const Tag.public(
          "AlarmDecision", 0x40101031, "Alarm Decision", VR.kCS, VM.k1, false);
  static const Tag kNumberOfTotalObjects
      //(4010,1033)
      = const Tag.public("NumberOfTotalObjects", 0x40101033,
          "Number of Total Objects", VR.kUS, VM.k1, false);
  static const Tag kNumberOfAlarmObjects
      //(4010,1034)
      = const Tag.public("NumberOfAlarmObjects", 0x40101034,
          "Number of Alarm Objects", VR.kUS, VM.k1, false);
  static const Tag kPTORepresentationSequence
      //(4010,1037)
      = const Tag.public("PTORepresentationSequence", 0x40101037,
          "PTO Representation Sequence", VR.kSQ, VM.k1, false);
  static const Tag kATDAssessmentSequence
      //(4010,1038)
      = const Tag.public("ATDAssessmentSequence", 0x40101038,
          "ATD Assessment Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTIPType
      //(4010,1039)
      =
      const Tag.public("TIPType", 0x40101039, "TIP Type", VR.kCS, VM.k1, false);
  static const Tag kDICOSVersion
      //(4010,103A)
      = const Tag.public(
          "DICOSVersion", 0x4010103A, "DICOS Version", VR.kCS, VM.k1, false);
  static const Tag kOOIOwnerCreationTime
      //(4010,1041)
      = const Tag.public("OOIOwnerCreationTime", 0x40101041,
          "OOI Owner Creation Time", VR.kDT, VM.k1, false);
  static const Tag kOOIType
      //(4010,1042)
      =
      const Tag.public("OOIType", 0x40101042, "OOI Type", VR.kCS, VM.k1, false);
  static const Tag kOOISize
      //(4010,1043)
      =
      const Tag.public("OOISize", 0x40101043, "OOI Size", VR.kFL, VM.k3, false);
  static const Tag kAcquisitionStatus
      //(4010,1044)
      = const Tag.public("AcquisitionStatus", 0x40101044, "Acquisition Status",
          VR.kCS, VM.k1, false);
  static const Tag kBasisMaterialsCodeSequence
      //(4010,1045)
      = const Tag.public("BasisMaterialsCodeSequence", 0x40101045,
          "Basis Materials Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPhantomType
      //(4010,1046)
      = const Tag.public(
          "PhantomType", 0x40101046, "Phantom Type", VR.kCS, VM.k1, false);
  static const Tag kOOIOwnerSequence
      //(4010,1047)
      = const Tag.public("OOIOwnerSequence", 0x40101047, "OOI Owner Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kScanType
      //(4010,1048)
      = const Tag.public(
          "ScanType", 0x40101048, "Scan Type", VR.kCS, VM.k1, false);
  static const Tag kItineraryID
      //(4010,1051)
      = const Tag.public(
          "ItineraryID", 0x40101051, "Itinerary ID", VR.kLO, VM.k1, false);
  static const Tag kItineraryIDType
      //(4010,1052)
      = const Tag.public("ItineraryIDType", 0x40101052, "Itinerary ID Type",
          VR.kSH, VM.k1, false);
  static const Tag kItineraryIDAssigningAuthority
      //(4010,1053)
      = const Tag.public("ItineraryIDAssigningAuthority", 0x40101053,
          "Itinerary ID Assigning Authority", VR.kLO, VM.k1, false);
  static const Tag kRouteID
      //(4010,1054)
      =
      const Tag.public("RouteID", 0x40101054, "Route ID", VR.kSH, VM.k1, false);
  static const Tag kRouteIDAssigningAuthority
      //(4010,1055)
      = const Tag.public("RouteIDAssigningAuthority", 0x40101055,
          "Route ID Assigning Authority", VR.kSH, VM.k1, false);
  static const Tag kInboundArrivalType
      //(4010,1056)
      = const Tag.public("InboundArrivalType", 0x40101056,
          "Inbound Arrival Type", VR.kCS, VM.k1, false);
  static const Tag kCarrierID
      //(4010,1058)
      = const Tag.public(
          "CarrierID", 0x40101058, "Carrier ID", VR.kSH, VM.k1, false);
  static const Tag kCarrierIDAssigningAuthority
      //(4010,1059)
      = const Tag.public("CarrierIDAssigningAuthority", 0x40101059,
          "Carrier ID Assigning Authority", VR.kCS, VM.k1, false);
  static const Tag kSourceOrientation
      //(4010,1060)
      = const Tag.public("SourceOrientation", 0x40101060, "Source Orientation",
          VR.kFL, VM.k3, false);
  static const Tag kSourcePosition
      //(4010,1061)
      = const Tag.public("SourcePosition", 0x40101061, "Source Position",
          VR.kFL, VM.k3, false);
  static const Tag kBeltHeight
      //(4010,1062)
      = const Tag.public(
          "BeltHeight", 0x40101062, "Belt Height", VR.kFL, VM.k1, false);
  static const Tag kAlgorithmRoutingCodeSequence
      //(4010,1064)
      = const Tag.public("AlgorithmRoutingCodeSequence", 0x40101064,
          "Algorithm Routing Code Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTransportClassification
      //(4010,1067)
      = const Tag.public("TransportClassification", 0x40101067,
          "Transport Classification", VR.kCS, VM.k1, false);
  static const Tag kOOITypeDescriptor
      //(4010,1068)
      = const Tag.public("OOITypeDescriptor", 0x40101068, "OOI Type Descriptor",
          VR.kLT, VM.k1, false);
  static const Tag kTotalProcessingTime
      //(4010,1069)
      = const Tag.public("TotalProcessingTime", 0x40101069,
          "Total Processing Time", VR.kFL, VM.k1, false);
  static const Tag kDetectorCalibrationData
      //(4010,106C)
      = const Tag.public("DetectorCalibrationData", 0x4010106C,
          "Detector Calibration Data", VR.kOB, VM.k1, false);
  static const Tag kAdditionalScreeningPerformed
      //(4010,106D)
      = const Tag.public("AdditionalScreeningPerformed", 0x4010106D,
          "Additional Screening Performed", VR.kCS, VM.k1, false);
  static const Tag kAdditionalInspectionSelectionCriteria
      //(4010,106E)
      = const Tag.public("AdditionalInspectionSelectionCriteria", 0x4010106E,
          "Additional Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const Tag kAdditionalInspectionMethodSequence
      //(4010,106F)
      = const Tag.public("AdditionalInspectionMethodSequence", 0x4010106F,
          "Additional Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAITDeviceType
      //(4010,1070)
      = const Tag.public(
          "AITDeviceType", 0x40101070, "AIT Device Type", VR.kCS, VM.k1, false);
  static const Tag kQRMeasurementsSequence
      //(4010,1071)
      = const Tag.public("QRMeasurementsSequence", 0x40101071,
          "QR Measurements Sequence", VR.kSQ, VM.k1, false);
  static const Tag kTargetMaterialSequence
      //(4010,1072)
      = const Tag.public("TargetMaterialSequence", 0x40101072,
          "Target Material Sequence", VR.kSQ, VM.k1, false);
  static const Tag kSNRThreshold
      //(4010,1073)
      = const Tag.public(
          "SNRThreshold", 0x40101073, "SNR Threshold", VR.kFD, VM.k1, false);
  static const Tag kImageScaleRepresentation
      //(4010,1075)
      = const Tag.public("ImageScaleRepresentation", 0x40101075,
          "Image Scale Representation", VR.kDS, VM.k1, false);
  static const Tag kReferencedPTOSequence
      //(4010,1076)
      = const Tag.public("ReferencedPTOSequence", 0x40101076,
          "Referenced PTO Sequence", VR.kSQ, VM.k1, false);
  static const Tag kReferencedTDRInstanceSequence
      //(4010,1077)
      = const Tag.public("ReferencedTDRInstanceSequence", 0x40101077,
          "Referenced TDR Instance Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPTOLocationDescription
      //(4010,1078)
      = const Tag.public("PTOLocationDescription", 0x40101078,
          "PTO Location Description", VR.kST, VM.k1, false);
  static const Tag kAnomalyLocatorIndicatorSequence
      //(4010,1079)
      = const Tag.public("AnomalyLocatorIndicatorSequence", 0x40101079,
          "Anomaly Locator Indicator Sequence", VR.kSQ, VM.k1, false);
  static const Tag kAnomalyLocatorIndicator
      //(4010,107A)
      = const Tag.public("AnomalyLocatorIndicator", 0x4010107A,
          "Anomaly Locator Indicator", VR.kFL, VM.k3, false);
  static const Tag kPTORegionSequence
      //(4010,107B)
      = const Tag.public("PTORegionSequence", 0x4010107B, "PTO Region Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kInspectionSelectionCriteria
      //(4010,107C)
      = const Tag.public("InspectionSelectionCriteria", 0x4010107C,
          "Inspection Selection Criteria", VR.kCS, VM.k1, false);
  static const Tag kSecondaryInspectionMethodSequence
      //(4010,107D)
      = const Tag.public("SecondaryInspectionMethodSequence", 0x4010107D,
          "Secondary Inspection Method Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPRCSToRCSOrientation
      //(4010,107E)
      = const Tag.public("PRCSToRCSOrientation", 0x4010107E,
          "PRCS to RCS Orientation", VR.kDS, VM.k6, false);
  static const Tag kMACParametersSequence
      //(4FFE,0001)
      = const Tag.public("MACParametersSequence", 0x4FFE0001,
          "MAC Parameters Sequence", VR.kSQ, VM.k1, false);
  static const Tag kCurveDimensions
      //(5000,0005)
      = const Tag.public("CurveDimensions", 0x50000005, "Curve Dimensions",
          VR.kUS, VM.k1, true);
  static const Tag kNumberOfPoints
      //(5000,0010)
      = const Tag.public("NumberOfPoints", 0x50000010, "Number of Points",
          VR.kUS, VM.k1, true);
  static const Tag kTypeOfData
      //(5000,0020)
      = const Tag.public(
          "TypeOfData", 0x50000020, "Type of Data", VR.kCS, VM.k1, true);
  static const Tag kCurveDescription
      //(5000,0022)
      = const Tag.public("CurveDescription", 0x50000022, "Curve Description",
          VR.kLO, VM.k1, true);
  static const Tag kAxisUnits
      //(5000,0030)
      = const Tag.public(
          "AxisUnits", 0x50000030, "Axis Units", VR.kSH, VM.k1_n, true);
  static const Tag kAxisLabels
      //(5000,0040)
      = const Tag.public(
          "AxisLabels", 0x50000040, "Axis Labels", VR.kSH, VM.k1_n, true);
  static const Tag kDataValueRepresentation
      //(5000,0103)
      = const Tag.public("DataValueRepresentation", 0x50000103,
          "Data Value Representation", VR.kUS, VM.k1, true);
  static const Tag kMinimumCoordinateValue
      //(5000,0104)
      = const Tag.public("MinimumCoordinateValue", 0x50000104,
          "Minimum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const Tag kMaximumCoordinateValue
      //(5000,0105)
      = const Tag.public("MaximumCoordinateValue", 0x50000105,
          "Maximum Coordinate Value", VR.kUS, VM.k1_n, true);
  static const Tag kCurveRange
      //(5000,0106)
      = const Tag.public(
          "CurveRange", 0x50000106, "Curve Range", VR.kSH, VM.k1_n, true);
  static const Tag kCurveDataDescriptor
      //(5000,0110)
      = const Tag.public("CurveDataDescriptor", 0x50000110,
          "Curve Data Descriptor", VR.kUS, VM.k1_n, true);
  static const Tag kCoordinateStartValue
      //(5000,0112)
      = const Tag.public("CoordinateStartValue", 0x50000112,
          "Coordinate Start Value", VR.kUS, VM.k1_n, true);
  static const Tag kCoordinateStepValue
      //(5000,0114)
      = const Tag.public("CoordinateStepValue", 0x50000114,
          "Coordinate Step Value", VR.kUS, VM.k1_n, true);
  static const Tag kCurveActivationLayer
      //(5000,1001)
      = const Tag.public("CurveActivationLayer", 0x50001001,
          "Curve Activation Layer", VR.kCS, VM.k1, true);
  static const Tag kAudioType
      //(5000,2000)
      = const Tag.public(
          "AudioType", 0x50002000, "Audio Type", VR.kUS, VM.k1, true);
  static const Tag kAudioSampleFormat
      //(5000,2002)
      = const Tag.public("AudioSampleFormat", 0x50002002, "Audio Sample Format",
          VR.kUS, VM.k1, true);
  static const Tag kNumberOfChannels
      //(5000,2004)
      = const Tag.public("NumberOfChannels", 0x50002004, "Number of Channels",
          VR.kUS, VM.k1, true);
  static const Tag kNumberOfSamples
      //(5000,2006)
      = const Tag.public("NumberOfSamples", 0x50002006, "Number of Samples",
          VR.kUL, VM.k1, true);
  static const Tag kSampleRate
      //(5000,2008)
      = const Tag.public(
          "SampleRate", 0x50002008, "Sample Rate", VR.kUL, VM.k1, true);
  static const Tag kTotalTime
      //(5000,200A)
      = const Tag.public(
          "TotalTime", 0x5000200A, "Total Time", VR.kUL, VM.k1, true);
  static const Tag kAudioSampleData
      //(5000,200C)
      = const Tag.public("AudioSampleData", 0x5000200C, "Audio Sample Data",
          VR.kOBOW, VM.k1, true);
  static const Tag kAudioComments
      //(5000,200E)
      = const Tag.public(
          "AudioComments", 0x5000200E, "Audio Comments", VR.kLT, VM.k1, true);
  static const Tag kCurveLabel
      //(5000,2500)
      = const Tag.public(
          "CurveLabel", 0x50002500, "Curve Label", VR.kLO, VM.k1, true);
  static const Tag kCurveReferencedOverlaySequence
      //(5000,2600)
      = const Tag.public("CurveReferencedOverlaySequence", 0x50002600,
          "Curve Referenced Overlay Sequence", VR.kSQ, VM.k1, true);
  static const Tag kCurveReferencedOverlayGroup
      //(5000,2610)
      = const Tag.public("CurveReferencedOverlayGroup", 0x50002610,
          "Curve Referenced Overlay Group", VR.kUS, VM.k1, true);
  static const Tag kCurveData
      //(5000,3000)
      = const Tag.public(
          "CurveData", 0x50003000, "Curve Data", VR.kOBOW, VM.k1, true);
  static const Tag kSharedFunctionalGroupsSequence
      //(5200,9229)
      = const Tag.public("SharedFunctionalGroupsSequence", 0x52009229,
          "Shared Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const Tag kPerFrameFunctionalGroupsSequence
      //(5200,9230)
      = const Tag.public("PerFrameFunctionalGroupsSequence", 0x52009230,
          "Per-frame Functional Groups Sequence", VR.kSQ, VM.k1, false);
  static const Tag kWaveformSequence
      //(5400,0100)
      = const Tag.public("WaveformSequence", 0x54000100, "Waveform Sequence",
          VR.kSQ, VM.k1, false);
  static const Tag kChannelMinimumValue
      //(5400,0110)
      = const Tag.public("ChannelMinimumValue", 0x54000110,
          "Channel Minimum Value", VR.kOBOW, VM.k1, false);
  static const Tag kChannelMaximumValue
      //(5400,0112)
      = const Tag.public("ChannelMaximumValue", 0x54000112,
          "Channel Maximum Value", VR.kOBOW, VM.k1, false);
  static const Tag kWaveformBitsAllocated
      //(5400,1004)
      = const Tag.public("WaveformBitsAllocated", 0x54001004,
          "Waveform Bits Allocated", VR.kUS, VM.k1, false);
  static const Tag kWaveformSampleInterpretation
      //(5400,1006)
      = const Tag.public("WaveformSampleInterpretation", 0x54001006,
          "Waveform Sample Interpretation", VR.kCS, VM.k1, false);
  static const Tag kWaveformPaddingValue
      //(5400,100A)
      = const Tag.public("WaveformPaddingValue", 0x5400100A,
          "Waveform Padding Value", VR.kOBOW, VM.k1, false);
  static const Tag kWaveformData
      //(5400,1010)
      = const Tag.public(
          "WaveformData", 0x54001010, "Waveform Data", VR.kOBOW, VM.k1, false);
  static const Tag kFirstOrderPhaseCorrectionAngle
      //(5600,0010)
      = const Tag.public("FirstOrderPhaseCorrectionAngle", 0x56000010,
          "First Order Phase Correction Angle", VR.kOF, VM.k1, false);
  static const Tag kSpectroscopyData
      //(5600,0020)
      = const Tag.public("SpectroscopyData", 0x56000020, "Spectroscopy Data",
          VR.kOF, VM.k1, false);
  static const Tag kOverlayRows
      //(6000,0010)
      = const Tag.public(
          "OverlayRows", 0x60000010, "Overlay Rows", VR.kUS, VM.k1, false);
  static const Tag kOverlayColumns
      //(6000,0011)
      = const Tag.public("OverlayColumns", 0x60000011, "Overlay Columns",
          VR.kUS, VM.k1, false);
  static const Tag kOverlayPlanes
      //(6000,0012)
      = const Tag.public(
          "OverlayPlanes", 0x60000012, "Overlay Planes", VR.kUS, VM.k1, true);
  static const Tag kNumberOfFramesInOverlay
      //(6000,0015)
      = const Tag.public("NumberOfFramesInOverlay", 0x60000015,
          "Number of Frames in Overlay", VR.kIS, VM.k1, false);
  static const Tag kOverlayDescription
      //(6000,0022)
      = const Tag.public("OverlayDescription", 0x60000022,
          "Overlay Description", VR.kLO, VM.k1, false);
  static const Tag kOverlayType
      //(6000,0040)
      = const Tag.public(
          "OverlayType", 0x60000040, "Overlay Type", VR.kCS, VM.k1, false);
  static const Tag kOverlaySubtype
      //(6000,0045)
      = const Tag.public("OverlaySubtype", 0x60000045, "Overlay Subtype",
          VR.kLO, VM.k1, false);
  static const Tag kOverlayOrigin
      //(6000,0050)
      = const Tag.public(
          "OverlayOrigin", 0x60000050, "Overlay Origin", VR.kSS, VM.k2, false);
  static const Tag kImageFrameOrigin
      //(6000,0051)
      = const Tag.public("ImageFrameOrigin", 0x60000051, "Image Frame Origin",
          VR.kUS, VM.k1, false);
  static const Tag kOverlayPlaneOrigin
      //(6000,0052)
      = const Tag.public("OverlayPlaneOrigin", 0x60000052,
          "Overlay Plane Origin", VR.kUS, VM.k1, true);
  static const Tag kOverlayCompressionCode
      //(6000,0060)
      = const Tag.public("OverlayCompressionCode", 0x60000060,
          "Overlay Compression Code", VR.kCS, VM.k1, true);
  static const Tag kOverlayCompressionOriginator
      //(6000,0061)
      = const Tag.public("OverlayCompressionOriginator", 0x60000061,
          "Overlay Compression Originator", VR.kSH, VM.k1, true);
  static const Tag kOverlayCompressionLabel
      //(6000,0062)
      = const Tag.public("OverlayCompressionLabel", 0x60000062,
          "Overlay Compression Label", VR.kSH, VM.k1, true);
  static const Tag kOverlayCompressionDescription
      //(6000,0063)
      = const Tag.public("OverlayCompressionDescription", 0x60000063,
          "Overlay Compression Description", VR.kCS, VM.k1, true);
  static const Tag kOverlayCompressionStepPointers
      //(6000,0066)
      = const Tag.public("OverlayCompressionStepPointers", 0x60000066,
          "Overlay Compression Step Pointers", VR.kAT, VM.k1_n, true);
  static const Tag kOverlayRepeatInterval
      //(6000,0068)
      = const Tag.public("OverlayRepeatInterval", 0x60000068,
          "Overlay Repeat Interval", VR.kUS, VM.k1, true);
  static const Tag kOverlayBitsGrouped
      //(6000,0069)
      = const Tag.public("OverlayBitsGrouped", 0x60000069,
          "Overlay Bits Grouped", VR.kUS, VM.k1, true);
  static const Tag kOverlayBitsAllocated
      //(6000,0100)
      = const Tag.public("OverlayBitsAllocated", 0x60000100,
          "Overlay Bits Allocated", VR.kUS, VM.k1, false);
  static const Tag kOverlayBitPosition
      //(6000,0102)
      = const Tag.public("OverlayBitPosition", 0x60000102,
          "Overlay Bit Position", VR.kUS, VM.k1, false);
  static const Tag kOverlayFormat
      //(6000,0110)
      = const Tag.public(
          "OverlayFormat", 0x60000110, "Overlay Format", VR.kCS, VM.k1, true);
  static const Tag kOverlayLocation
      //(6000,0200)
      = const Tag.public("OverlayLocation", 0x60000200, "Overlay Location",
          VR.kUS, VM.k1, true);
  static const Tag kOverlayCodeLabel
      //(6000,0800)
      = const Tag.public("OverlayCodeLabel", 0x60000800, "Overlay Code Label",
          VR.kCS, VM.k1_n, true);
  static const Tag kOverlayNumberOfTables
      //(6000,0802)
      = const Tag.public("OverlayNumberOfTables", 0x60000802,
          "Overlay Number of Tables", VR.kUS, VM.k1, true);
  static const Tag kOverlayCodeTableLocation
      //(6000,0803)
      = const Tag.public("OverlayCodeTableLocation", 0x60000803,
          "Overlay Code Table Location", VR.kAT, VM.k1_n, true);
  static const Tag kOverlayBitsForCodeWord
      //(6000,0804)
      = const Tag.public("OverlayBitsForCodeWord", 0x60000804,
          "Overlay Bits For Code Word", VR.kUS, VM.k1, true);
  static const Tag kOverlayActivationLayer
      //(6000,1001)
      = const Tag.public("OverlayActivationLayer", 0x60001001,
          "Overlay Activation Layer", VR.kCS, VM.k1, false);
  static const Tag kOverlayDescriptorGray
      //(6000,1100)
      = const Tag.public("OverlayDescriptorGray", 0x60001100,
          "Overlay Descriptor - Gray", VR.kUS, VM.k1, true);
  static const Tag kOverlayDescriptorRed
      //(6000,1101)
      = const Tag.public("OverlayDescriptorRed", 0x60001101,
          "Overlay Descriptor - Red", VR.kUS, VM.k1, true);
  static const Tag kOverlayDescriptorGreen
      //(6000,1102)
      = const Tag.public("OverlayDescriptorGreen", 0x60001102,
          "Overlay Descriptor - Green", VR.kUS, VM.k1, true);
  static const Tag kOverlayDescriptorBlue
      //(6000,1103)
      = const Tag.public("OverlayDescriptorBlue", 0x60001103,
          "Overlay Descriptor - Blue", VR.kUS, VM.k1, true);
  static const Tag kOverlaysGray
      //(6000,1200)
      = const Tag.public(
          "OverlaysGray", 0x60001200, "Overlays - Gray", VR.kUS, VM.k1_n, true);
  static const Tag kOverlaysRed
      //(6000,1201)
      = const Tag.public(
          "OverlaysRed", 0x60001201, "Overlays - Red", VR.kUS, VM.k1_n, true);
  static const Tag kOverlaysGreen
      //(6000,1202)
      = const Tag.public("OverlaysGreen", 0x60001202, "Overlays - Green",
          VR.kUS, VM.k1_n, true);
  static const Tag kOverlaysBlue
      //(6000,1203)
      = const Tag.public(
          "OverlaysBlue", 0x60001203, "Overlays - Blue", VR.kUS, VM.k1_n, true);
  static const Tag kROIArea
      //(6000,1301)
      =
      const Tag.public("ROIArea", 0x60001301, "ROI Area", VR.kIS, VM.k1, false);
  static const Tag kROIMean
      //(6000,1302)
      =
      const Tag.public("ROIMean", 0x60001302, "ROI Mean", VR.kDS, VM.k1, false);
  static const Tag kROIStandardDeviation
      //(6000,1303)
      = const Tag.public("ROIStandardDeviation", 0x60001303,
          "ROI Standard Deviation", VR.kDS, VM.k1, false);
  static const Tag kOverlayLabel
      //(6000,1500)
      = const Tag.public(
          "OverlayLabel", 0x60001500, "Overlay Label", VR.kLO, VM.k1, false);
  static const Tag kOverlayData
      //(6000,3000)
      = const Tag.public(
          "OverlayData", 0x60003000, "Overlay Data", VR.kOBOW, VM.k1, false);
  static const Tag kOverlayComments
      //(6000,4000)
      = const Tag.public("OverlayComments", 0x60004000, "Overlay Comments",
          VR.kLT, VM.k1, true);
  static const Tag kFloatPixelData = const Tag.public(
      "FloatPixelData", 0x7FE00008, "Float Pixel Data", VR.kOF, VM.k1, false);
  static const Tag kDoubleFloatPixelData = const Tag.public(
      "DoubleFloatPixelData",
      0x7FE00009,
      "Double Float Pixel Data",
      VR.kOD,
      VM.k1,
      false);
  static const Tag kPixelData = const Tag.public(
      "PixelData", 0x7FE00010, "Pixel Data", VR.kOBOW, VM.k1, false);
  static const Tag kCoefficientsSDVN
      //(7FE0,0020)
      = const Tag.public("CoefficientsSDVN", 0x7FE00020, "Coefficients SDVN",
          VR.kOW, VM.k1, true);
  static const Tag kCoefficientsSDHN
      //(7FE0,0030)
      = const Tag.public("CoefficientsSDHN", 0x7FE00030, "Coefficients SDHN",
          VR.kOW, VM.k1, true);
  static const Tag kCoefficientsSDDN
      //(7FE0,0040)
      = const Tag.public("CoefficientsSDDN", 0x7FE00040, "Coefficients SDDN",
          VR.kOW, VM.k1, true);
  static const Tag kVariablePixelData
      //(7F00,0010)
      = const Tag.public("VariablePixelData", 0x7F000010, "Variable Pixel Data",
          VR.kOBOW, VM.k1, true);
  static const Tag kVariableNextDataGroup
      //(7F00,0011)
      = const Tag.public("VariableNextDataGroup", 0x7F000011,
          "Variable Next Data Group", VR.kUS, VM.k1, true);
  static const Tag kVariableCoefficientsSDVN
      //(7F00,0020)
      = const Tag.public("VariableCoefficientsSDVN", 0x7F000020,
          "Variable Coefficients SDVN", VR.kOW, VM.k1, true);
  static const Tag kVariableCoefficientsSDHN
      //(7F00,0030)
      = const Tag.public("VariableCoefficientsSDHN", 0x7F000030,
          "Variable Coefficients SDHN", VR.kOW, VM.k1, true);
  static const Tag kVariableCoefficientsSDDN
      //(7F00,0040)
      = const Tag.public("VariableCoefficientsSDDN", 0x7F000040,
          "Variable Coefficients SDDN", VR.kOW, VM.k1, true);
  static const Tag kDigitalSignaturesSequence
      //(FFFA,FFFA)
      = const Tag.public("DigitalSignaturesSequence", 0xFFFAFFFA,
          "Digital Signatures Sequence", VR.kSQ, VM.k1, false);
  static const Tag kDataSetTrailingPadding
      //(FFFC,FFFC)
      = const Tag.public("DataSetTrailingPadding", 0xFFFCFFFC,
          "Data Set Trailing Padding", VR.kOB, VM.k1, false);
  static const Tag kItem
      //(FFFE,E000)
      = const Tag.public(
          "Item", 0xFFFEE000, "Item", VR.kUnknown, VM.kNoVM, false);
  static const Tag kItemDelimitationItem
      //(FFFE,E00D)
      = const Tag.public("ItemDelimitationItem", 0xFFFEE00D,
          "Item Delimitation Item", VR.kUnknown, VM.kNoVM, false);
  static const Tag kSequenceDelimitationItem
      //(FFFE,E0DD)
      = const Tag.public("SequenceDelimitationItem", 0xFFFEE0DD,
          "Sequence Delimitation Item", VR.kUnknown, VM.kNoVM, false);

  //**** Special Elements where multiple tags map to the same dictionary

  //(0028,04X0)
  static const Tag kRowsForNthOrderCoefficients = const Tag.public(
      "RowsForNthOrderCoefficients",
      0x002804F0,
      "Rows For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,04X1)
  static const Tag kColumnsForNthOrderCoefficients = const Tag.public(
      "ColumnsForNthOrderCoefficients",
      0x00280401,
      "Columns For Nth Order Coefficients",
      VR.kUS,
      VM.k1,
      true);

  //(0028,0402)
  static const Tag kCoefficientCoding = const Tag.public("CoefficientCoding",
      0x00280402, "Coefficient Coding", VR.kLO, VM.k1_n, true);

  //(0028,0403)
  static const Tag kCoefficientCodingPointers = const Tag.public(
      "CoefficientCodingPointers",
      0x00280403,
      "Coefficient Coding Pointers",
      VR.kAT,
      VM.k1_n,
      true);

  static const List<Tag> fmiTags = const <Tag>[
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

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name

}
