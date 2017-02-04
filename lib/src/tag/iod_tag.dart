// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

/// A [class] for defining the elements of an [IOD].
class IodTag {
  final PublicTag tag;
  final EType _type;

  //TODO: make const
  IodTag(this.tag, this._type);

  EType get eType => _type ?? tag.type;

  int get code => tag.code;
  String get hex => tag.hex;
  int get group => tag.group;
  String get groupHex => tag.groupHex;
  int get elt => tag.elt;
  String get eltHex => tag.eltHex;

  String get keyword => tag.keyword;
  String get name => tag.name;

  VR get vr => tag.vr;
  int get minLength => tag.minLength;
  int get maxLength => tag.maxLength;
  int get width => tag.width;

  VM get vm => tag.vm;
  bool get isRetired => tag.isRetired;

  int codeGroup(int code) => code >> 16;
  int codeElt(int code) => code & 0xFFFF;
  bool codeGroupIsPrivate(int code) {
    int g = codeGroup(code);
    return g.isOdd && (g > 0x0008 && g < 0xFFFE);
  }

  bool isValidLength(int length) => tag.isValidLength(length);
  //bool isValidValue(value) => tag.isValidValue(value);
  dynamic checkValue(value, [List<String> issues]) => tag.checkValue(value);

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'IOD Element: ${tag.dcm} $keyword, $vr, $vm, $retired';
  }


}