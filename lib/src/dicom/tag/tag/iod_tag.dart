// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';
import 'package:dictionary/tag.dart';

/// A [class] for defining the elements of an [IOD].
class IodTag implements Tag {
  final Tag tag;
  final EType eType;
  const IodTag(this.tag, this.eType);

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



  bool isValidLength(int length) => tag.isValidLength(length);
  //bool isValidValue(value) => tag.isValidValue(value);
  dynamic checkValue(value, List<String> issues) => tag.checkValue(value, issues);

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'IOD Element: ${tag.dcm} $keyword, $vr, $vm, $retired';
  }


}