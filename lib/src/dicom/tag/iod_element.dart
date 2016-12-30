// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/new_dicom.dart';

/// A [class] for defining the elements of an [IOD].
class IodTag implements Tag {
  final Tag tag;
  final EType type;

  const IodTag(this.tag, this.type);

  int get code => tag.code;
  String get keyword => tag.keyword;
  String get name => tag.name;
  VR get vr => tag.vr;
  VM get vm => tag.vm;
  bool get isRetired => tag.isRetired;

  String get hex => tag.hex;

  int get group => tag.group;

  String get groupHex => tag.groupHex;

  int get elt => tag.elt;

  String get eltHex => tag.eltHex;

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'IOD Element: ${tag.dcm} $keyword, $vr, $vm, $retired';
  }


}