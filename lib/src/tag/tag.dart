// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:common/common.dart';
import 'package:dictionary/src/constants.dart';
import 'package:dictionary/src/issue.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

import 'package:dictionary/src/tag/constants.dart';
import 'package:dictionary/src/tag/elt.dart';
import 'package:dictionary/src/tag/e_type.dart';
import 'package:dictionary/src/tag/group.dart';
import 'package:dictionary/src/tag/private_data_tag.dart';
import 'package:dictionary/src/tag/public_tag.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

bool throwOnError = true;

//TODO: is hashCode needed?
abstract class Tag {
  final int code;
  final VR vr;
  final VM vm;
  final EType type;

  const Tag(this.code, [this.vr = VR.kUN, this.vm = VM.k1_n, this.type = EType.kUnknown]);

  String get keyword => "Unknown Tag Keyword";
  String get name => "Unknown Tag Name";
  bool get isRetired => false;

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
  /// Returns the maximum number of values allowed for this [PublicTag].
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

  /// Returns [true] if [PublicTag] group [group] is in the File Meta Information group; otherwise false.
  bool get isFmiGroup => group == 0x0002;

  /// Returns [true] if [code] is in the range of DICOM Directory [Tag] [code]s..
  /// Note: Does not test tag validity.
  bool get inFmiRange => kMinFmiTag <= code && code <= kMaxFmiTag;

  int get dcmDirMin => kMinDcmDirTag;
  int get dcmDirMax => kMaxDcmDirTag;

  /// Returns [true] if [code] is in the range of DICOM Directory [Tag] [code]s.
  /// Note: Does not test tag validity.
  bool get isDcmDir => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  /// Returns [true] if [code] is in the range of DICOM Directory [Tag] [code]s..
  /// Note: Does not test tag validity.
  bool get inDcmDirRange => kMinDcmDirTag <= code && code <= kMaxDcmDirTag;

  String get info => '$runtimeType$dcm, $vr, $vm, $type';

  /// Returns True if the [length], i.e. the number of values, is valid for this [PublicTag].
  ///
  /// Note: A [length] of zero is always valid.
  ///
  /// [min]: The minimum number of values.
  /// [max]: The maximum number of values. If -1 then max length of Value Field; otherwise, must
  ///     be greater than or equal to [min].
  /// [width]: The [width] of the matrix of values. If [width == 0 then singleton;
  ///     otherwise must be greater than 0;

  //TODO: should be modified when EType info is available.
  bool isValidValues<E>(List<E> values) {
    if (isNotValidLength(values.length)) return false;
    for (int i = 0; i < values.length; i++)
      if (vr.isNotValidValue(values[i])) return false;
    return true;
  }

  List<E> checkValues<E>(List<E> values) => (isValidValues(values)) ? values : null;

  // Placeholder until VR is integrated into TagBase
  checkValue(dynamic value) => vr.isValidValue(value) ? value : null;

  /// Returns an issues for these values.  This method should be called
  /// after [isValidValues] returns [false].
  Issue getIssue(List values) {
    Issue issue = new Issue(this, values);
    getLengthIssue(values.length, issue);
    for (int i = 0; i < values.length; i++) {
      String msg = vr.getValueError(values[i]);
      if (msg != null) issue.badValue(i, msg);
    }
    return (issue.isNotEmpty) ? null : issue;
  }

  bool isValidLength(int length) {
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return true;
    return (length % width == 0 && minLength <= length && length <= maxLength);
  }

  bool isNotValidLength(int length) => !isValidLength(length);

  int checkLength(int length) => (isValidLength(length)) ? length : null;

  Issue getLengthIssue(int length, Issue issue) {
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return null;
    if (width != 0 && length % width != 0) issue.badWidth();
    if (length < minLength || length > maxLength) issue.badLength();
    return issue;
  }

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
  String toString() => 'Tag$dcm $vr, $vm';

  static lookupCode(int code) {
    PublicTag pTag = PublicTag.lookupCode(code);
    if (pTag != null) return pTag;
    PrivateDataTag pdTag = PrivateDataTag.lookupCode(code);
    if (pdTag != null) return pdTag;
  }

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
  static bool isPrivateCode(int tagCode) => Group.isPrivate(Group.fromTag(tagCode));

  static bool isPublicCode(int tagCode) => Group.isPublic(Group.fromTag(tagCode));

  /// Returns true if [code] is a valid Private Creator Code.
  static bool isPrivateCreatorCode(int tagCode) =>
      isPrivateCode(tagCode) && Elt.isPrivateCreator(Elt.fromTag(tagCode));

  static bool isPrivateDataCode(int tag) =>
      Group.isPrivate(Group.fromTag(tag)) && Elt.isPrivateData(Elt.fromTag(tag));

  static int privateCreatorBase(int code) => Elt.pcBase(Elt.fromTag(code));

  static int privateCreatorLimit(int code) => Elt.pcLimit(Elt.fromTag(code));

  /// Returns true if [pd] is a valid Private Data Code for the [pc] the Private Creator Code.
  ///
  /// If the [PrivateCreatorTag ]is present, verifies that [pd] and [pc] have the
  /// same [group], and that [pd] has a valid [Elt].
  static bool isValidPrivateDataTag(int pd, int pc) {
    int pdg = Group.checkPrivate(Group.fromTag(pd));
    int pcg = Group.checkPrivate(Group.fromTag(pc));
    if (pdg == null || pcg == null || pdg != pcg) return null;
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
    if (Group.isPrivate(group) && _isPCIndex(pcIndex) && _isPDIndex(pcIndex, pdIndex))
      return _toPrivateData(group, pcIndex, pcIndex);
    return null;
  }

  /// Returns a [PrivateCreatorTag], without checking arguments.
  static int _toPrivateCreator(int group, int pcIndex) => (group << 16) + pcIndex;

  /// Returns a [PrivateDataTag], without checking arguments.
  static int _toPrivateData(int group, int pcIndex, int pdIndex) =>
      (group << 16) + (pcIndex << 8) + pdIndex;

  // **** Private Tag Code Internal Utility functions ****

  /// Return [true] if [pdCode] is a valid Private Creator Index.
  static bool _isPCIndex(int pdCode) => 0x10 <= pdCode && pdCode <= 0xFF;

  // Returns [true] if [pde] in a valid Private Data Index
  //static bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

  /// Return [true] if [pdi] is a valid Private Data Index.
  static bool _isPDIndex(int pci, int pdi) => _pdBase(pci) <= pdi && pdi <= _pdLimit(pci);

  /// Returns the offset base for a Private Data Element with the Private Creator [pcIndex].
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
  static String toDcm(int code) =>
      '(${Group.hex(Group.fromTag(code), "")},${Elt.hex(Elt.fromTag(code), "")})';

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
}
