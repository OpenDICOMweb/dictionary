// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/tag.dart';

class Issue {
  final Tag tag;
  final List values;
  bool _hasBadLength = false;
  bool _hasBadWidth = false;
  Map<int, String> _valueErrors = <int, String>{};

  Issue(this.tag, this.values);

  bool badLength() => _hasBadLength = true;

  bool badWidth() => _hasBadWidth = true;

  String badValue(int index, message) => _valueErrors[index] = message;


  bool get isNotEmpty =>
    _hasBadLength || _hasBadWidth || _valueErrors.length != 0;

  bool get isEmpty => ! isNotEmpty;

  String get widthMsg => (_hasBadWidth == true)
      ? 'Invalid Width for${tag.dcm}: values length(${values.length}) '
          'is not a multiple of vmWidth(${tag.width}'
      : "";

  String get lengthMsg => (_hasBadLength == true)
      ? 'Invalid Length: min(${tag.minLength}) <= length(${values.length}) '
          '<= max(${tag.maxLength})'
      : "";

  @override
  String toString() {
    var out = "Issues with $tag\n";
    out += lengthMsg;
    out += widthMsg;
    _valueErrors.forEach((int index, String value) {
      out += '\n\t$index: $value';
    });
    return out;
  }
}
