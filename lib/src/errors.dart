// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/number.dart';
import 'package:core/system.dart';
import 'package:dictionary/dictionary.dart';

class InvalidTagError extends Error {
  Object tag;

  InvalidTagError(this.tag);

  @override
  String toString() => Tag.toMsg(tag);
}

dynamic tagError(Object obj) => throw new InvalidTagError(obj);

//TODO: convert this to handle both int and String and remove next two Errors
class InvalidTagKeyError extends Error {
  dynamic key;

  InvalidTagKeyError(this.key, [VR vr, String creator]);

  String get _value {
    if (key == null) return 'null';
    if (key is String) return key;
    if (key is int) return Tag.toDcm(key);
    return key;
  }

  @override
  String toString() => 'Error: Invalid Tag Key "$_value"';
}

//Flush when replaced with InvalidTagKeyError
class InvalidTagCodeError extends Error {
  int code;

  InvalidTagCodeError(this.code);

  String get _value => (code == null) ? 'null' : Tag.toDcm(code);

  @override
  String toString() => 'Error: Invalid Tag Code "$_value"';
}

dynamic tagCodeError(int code) => throw new InvalidTagCodeError(code);

//Flush when replaced with InvalidTagKeyError
class InvalidTagKeywordError extends Error {
  String keyword;

  InvalidTagKeywordError(this.keyword);

  @override
  String toString() => 'Error: Invalid Tag Keyword: "$keyword"';
}

dynamic tagKeywordError(String keyword) =>
    throw new InvalidTagKeywordError(keyword);

class ParseError extends Error {
  String issues;

  ParseError(this.issues);

  @override
  String toString() => 'ParseError: $issues';
}

class InvalidGroupError extends Error {
  Object group;

  InvalidGroupError(this.group);

  @override
  String toString() => 'Invalid DICOM Group: ${Uint16.hex(group)}';
}

class InvalidValuesError extends Error {
  final Tag tag;
  final List values;

  InvalidValuesError(this.tag, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => '$runtimeType:\n  Tag(${tag.info})'
      '\n  values: ${values}';
}

class InvalidValuesTypeError extends Error {
  final Tag tag;
  final List values;

  InvalidValuesTypeError(this.tag, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => '$runtimeType:\n  Tag(${tag.info})'
      '\n  values: $values';
}

class InvalidValuesLengthError extends Error {
  final Tag tag;
  final List values;

  InvalidValuesLengthError(this.tag, this.values) {
    if (log != null) log.error(toString());
  }

  @override
  String toString() => '$runtimeType:\n  Tag(${tag.info})'
      '\n  values: $values';
}

dynamic groupError(Object obj) => throw new InvalidTagError(obj);

class InvalidUidError extends Error {
  String error = 'Error: Invalid Uid:';
  Uid uid;
  Tag tag;
  String msg;

  InvalidUidError(this.uid, {this.tag, this.msg = ""});

  @override
  String toString() => (tag == null)
      ? '$error $uid $msg'
      : '$error $uid from '
      'Tag: '
      '$tag $msg';
}
