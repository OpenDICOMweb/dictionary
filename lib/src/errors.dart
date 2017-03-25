// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/tag.dart';

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