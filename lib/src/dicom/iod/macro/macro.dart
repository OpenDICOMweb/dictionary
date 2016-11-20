// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/dicom/de_def/iod_element.dart';
import 'package:dictionary/src/dicom/de_def/iod_sequence.dart';

abstract class MacroBase {
  String name;
  IodElement element;
  String description;

  List<MacroBase> get include;
  List<IodElement> get elements;
  Map<String, ElementDef> get keywords;
  Map<int, ElementDef> get tags;

}

abstract class MacroSequenceBase {
  IodElement element;
  IodSequenceBase sequence;

}

class Macro extends MacroBase {
  String name;
  IodElement element;
  String description;


  Macro(this.name, this.element, this.description);

  List<MacroBase> get include => [];
  List<IodElement> get elements => [];
  Map<String, ElementDef> get keywords => {};
  Map<int, ElementDef> get tags => {};

}