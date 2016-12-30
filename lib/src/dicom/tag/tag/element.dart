// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';
import 'tag.dart';

class ElementBase {
  final Tag tag;
  Uint8List bytes;
  List values;

  ElementBase(this.tag, this.values);

  dynamic operator [](int i) => values[i];

  static checkValues(Tag tag, List values) {
    List<String> issues = [];
    tag.isValidLength(values.length);
  }

  String get keyword => tag.keyword;

  int get code => tag.code;
  int get group => tag.group;
  int get elt => tag.elt;
  String get dcm => tag.dcm;
  String get hex => tag.hex;

  String get name => tag.name;

  VR get vr => tag.vr;
  int get vrIndex => vr.index;
  bool get isShort => vr.isShort;
  bool get isLong => !isShort;

  VM get vm => tag.vm;
  int get minLength => tag.minLength;
  int get maxLength => tag.maxLength;
  int get width => tag.width;

  bool get isRetired => tag.isRetired;
  bool get isPublic => tag.isPublic;
  bool get isWKPrivate => tag.isWKPrivate;

  bool isValidLength(int length) => tag.isValidLength(length);
}

/*
/// Dataset add
void add(int tagCode, List values) {
  Tag tag = Tag.lookup(tagCode);
  List<BadValues> badValues = tag.checkValues(values);
  if (badValues != null) badValues.add(tag, badValues);
  Element e = Tag.element(tag, values);
  map[tagCode] = e;
}
*/
