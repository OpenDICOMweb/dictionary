// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dictionary/common.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/issue.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'package:dictionary/src/dicom/tag/constants.dart';
import 'package:dictionary/src/dicom/tag/elt.dart';
import 'package:dictionary/src/dicom/tag/group.dart';
import 'package:dictionary/src/dicom/tag/tag.dart';

const int kGroupMask = 0xFFFF0000;
const int kElementMask = 0x0000FFFF;

bool throwOnError = true;

//TODO: is hashCode needed?
abstract class TagBase {
  final int code;
  final VR vr;
  final VM vm;

  const TagBase(this.code, [this.vr = VR.kUN, this.vm = VM.k1_n]);

  String get keyword => "Unknown Tag Keyword";
  String get name => "Unknown Tag Name";
  bool get isRetired => false;

  // **** Code Getters
  String get dcm => '(${Int.hex(group, 4, "")},${Int.hex(elt, 4, "")})';
  String get hex => Int.hex(code, 8);

  int get group => Group.valid(code >> 16);
  String get groupHex => Group.hex(group);

  int get elt => code & kElementMask;
  String get eltHex => Elt.hex(elt);

  // **** VR Getters

  int get vrIndex => vr.index;
  int get sizeInBytes => vr.sizeInBytes;
  bool get isShort => vr.isShort;

  // **** VR Getters

  int get minLength => vm.min;

  /// Returns the maximum number of values allowed for this [Tag].
  int get maxLength {
    int max = (vr.isShort) ? kMaxShortLengthInBytes : kMaxLongLengthInBytes;
    return max ~/ vr.sizeInBytes;
  }

  int get width => vm.width;

  int codeGroup(int code) => code >> 16;
  int codeElt(int code) => code & 0xFFFF;
  bool codeGroupIsPrivate(int code) {
    int g = codeGroup(code);
    return g.isOdd && (g > 0x0008 && g < 0xFFFE);
  }

  //TODO: sort out the naming between Attribute, Data Element, tag, etc.
  // DICOM Attribute Definitions

  //TODO: add index field
  // final String keyword;

  //final int index
  /// The DICOM Tag from PS3.6, Table 6-1.
  //final int code;
  // final VR vr;
  //final int vrIndex;
  //final bool isShort;

  // final VM vm;
  //final int vmMin;
  //final int vmMax;
  //final int vmWidth;
  // final EType eType; // Predicate Type
  //final Predicate condition
  //TODO: remove name and make an indexed list of names.
  // final String name;

  //final bool isRetired;

  int get hashcode => code;

  /// Returns true if the TagBase is defined by DICOM, false otherwise.
  /// All DICOM Public tags have group numbers that are even integers.
  /// Note: This only checks that the group number is an even.
  bool get isPublic => group.isEven;

  bool get isPrivate => Group.isPrivate(group);

  bool get isCreator => false;

  //bool get isPrivateCreator => false;
  bool get isPrivateData => false;

  int get fmiMin => kMinFmiTag;
  int get fmiMax => kMaxFmiTag;

  /// Returns [true] if [Tag] group [group] is in the File Meta Information group; otherwise false.
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

  String get info => '$runtimeType$dcm $vr $vm';

  //**** DICOM Dataset Utilities ****

  /// Returns True if the [length], i.e. the number of values, is valid for this [Tag].
  ///
  /// Note: A [length] of zero is always valid.
  ///
  /// [min]: The minimum number of values.
  /// [max]: The maximum number of values. If -1 then max length of Value Field; otherwise, must
  ///     be greater than or equal to [min].
  /// [width]: The [width] of the matrix of values. If [width == 0 then singleton;
  ///     otherwise must be greater than 0;
  //TODO: should be modified when DEType info is available.
  bool isValidLength(int length) {
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return true;
    return (length % width == 0 && minLength <= length && length <= maxLength);
  }

  Issue checkLength(TagBase tag, List values) => _checkLength(tag, values.length);

  Issue _checkLength(TagBase tag, int length) {
    List<String> msgs;
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return null;
    if (width != 0 && length % width != 0) msgs.add(
        'Invalid Length($length) not a multiple of vmWidth($width)');
    if (length < minLength) msgs.add('Invalid Length($length) less than minLength($minLength)');
    if (length > maxLength) msgs.add('Invalid Length($length) greater than maxLength($maxLength)');
    return (msgs.length != 0) ? new Issue.withLength(tag, length, msgs) : null;
  }

  // Placeholder until VR is integrated into TagBase
  dynamic checkValue(dynamic value, List<String> issues) => vr.checkValue(value);

  Issue checkValues(TagBase tag, List values) {
    Issue issue = checkLength(tag, values);
    for (int i = 0; i < values.length; i++) {
      var msg = vr.checkValue(values[i]);
      Issue.createIfAbsent(issue, tag, i, msg);
    }
    return (issue == null) ? null : issue;
  }

  Issue checkBytesLength(TagBase tag, Uint8List bytes) => _checkBytesLength(tag, bytes.lengthInBytes);

  //TODO: debug - no debugging done.
  Issue _checkBytesLength(TagBase tag, int length) {
    List<String> msgs;
    // These are the most common cases.
    if (length == 0 || (length == 1 && width == 0)) return null;
    if (width != 0 && length % width != 0) msgs.add(
        'Invalid Length($length) not a multiple of vmWidth($width)');
    if (length < minLength) msgs.add('Invalid Length($length) less than minLength($minLength)');
    if (length > maxLength) msgs.add('Invalid Length($length) greater than maxLength($maxLength)');
    return (msgs.length != 0) ? new Issue.withLength(tag, length, msgs) : null;
  }

  //Fix or Flush
  Uint8List checkBytes(TagBase tag, Uint8List bytes) => vr.checkBytes(bytes);

  @override
  String toString() => 'Tag: $dcm $vr, $vm';
}

/// Converts a DICOM [keyword] to the equivalent DICOM name.
///
/// Given a keyword in camelCase, returns a [String] with a
/// space (' ') inserted before each uppercase letter.
///
/// Note: This algorithm does not return the exact [name] string,
/// for example some [name]s have apostrophes ("'") in them,
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

class InvalidTagError extends Error {
  Object tag;

  InvalidTagError(tag);

  @override
  String toString() {
    var msg = (tag is int) ? Int.hex(tag, 8) : '${tag.runtimeType}: $tag';
    return 'Error: Invalid Tag($msg)';
  }
}

dynamic tagError(Object obj) => throw new InvalidTagError(obj);