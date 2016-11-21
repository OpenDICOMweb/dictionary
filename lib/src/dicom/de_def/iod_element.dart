// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dicom.dart';

/// A [class] for defining the elements of an [IOD].
class IodElement implements ElementDef {
  final ElementDef element;
  final DEType type;

  const IodElement(this.element, this.type);

  int get code => element.code;
  String get keyword => element.keyword;
  String get name => element.name;
  VR get vr => element.vr;
  VM get vm => element.vm;
  bool get isRetired => element.isRetired;

  String get hex => element.hex;

  int get group => Tag.group(code);

  String get groupHex => Tag.groupHex(code);

  int get elt => Tag.elt(code);

  String get eltHex => Tag.eltHex(code);

  String toString() {
    var retired = (isRetired == false) ? "" : ", (Retired)";
    return 'IOD Element: ${Tag.dcm(code)} $keyword, $vr, $vm, $retired';
  }


}