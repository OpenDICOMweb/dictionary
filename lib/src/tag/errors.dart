// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'tag.dart';

class InvalidTagError extends Error {
  Object tag;
  List values;

  InvalidTagError(this.tag, [this.values]);

  @override
  String toString() {
    String msg;
    if (tag is int) {
      msg = 'Code ${Tag.toDcm(tag)}';
    } else if (tag is String) {
      msg = 'Keyword "$tag"';
    } else {
      msg = '${tag.runtimeType}: $tag';
    }
    return 'Error: Invalid Tag $msg with values $values';
  }
}

dynamic tagError(Object obj, [List values]) =>
    throw new InvalidTagError(obj, values);

class InvalidTagCodeError extends Error {
  int code;
  List values;

  InvalidTagCodeError(this.code, [this.values]);

  @override
  String toString() =>
      'Error: Invalid Tag Code ${Tag.toDcm(code)} with values $values';
}

dynamic tagCodeError(int code, [List values]) =>
    throw new InvalidTagCodeError(code, values);

class InvalidTagKeywordError extends Error {
  String keyword;
  List values;
  InvalidTagKeywordError(this.keyword, [this.values]);

  @override
  String toString() => 'Error: Invalid Tag Keyword: "$keyword"';
}

dynamic tagKeywordError(String keyword, [List values]) =>
    throw new InvalidTagKeywordError(keyword, values);
