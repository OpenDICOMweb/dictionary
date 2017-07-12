// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/number.dart';
import 'package:dictionary/tag.dart';
import 'package:dictionary/uid.dart';

class InvalidTagError extends Error {
  Object tag;

  InvalidTagError(this.tag);

  @override
  String toString() => Tag.toMsg(tag);
}

dynamic tagError(Object obj) => throw new InvalidTagError(obj);

class InvalidTagCodeError extends Error {
  int code;

  InvalidTagCodeError(this.code);

  String get _value => (code == null) ? 'null' : Tag.toDcm(code);

  @override
  String toString() => 'Error: Invalid Tag Code "$_value"';
}

dynamic tagCodeError(int code) => throw new InvalidTagCodeError(code);

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
  String toString() =>
      'Invalid DICOM Group: ${Uint16.hex(group)}';
}

dynamic groupError(Object obj) => throw new InvalidTagError(obj);

class InvalidUidError extends Error {
String error = 'Error: Invalid Uid:';
  Uid uid;
  Tag tag;
  String msg;

  InvalidUidError(this.uid, {this.tag, this.msg = ""});

  @override
  String toString() => (tag == null) ? '$error $uid $msg' : '$error $uid from '
      'Tag: '
      '$tag $msg';
}