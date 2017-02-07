// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/tag/iod_sequence.dart';
import 'package:dictionary/src/tag/iod_tag.dart';

abstract class MacroBase {
  String get name;
  IodTag get element;
  String get description;

  List<MacroBase> get include;
  List<IodTag> get elements;
  Map<String, PublicTag> get keywords;
  Map<int, PublicTag> get tags;
}

abstract class MacroSequenceBase {
  IodTag element;
  IodSequenceBase sequence;
}

class Macro extends MacroBase {
  final String name;
  final IodTag element;
  final String description;

  Macro(this.name, this.element, this.description);

  List<MacroBase> get include => [];
  List<IodTag> get elements => [];
  Map<String, PublicTag> get keywords => {};
  Map<int, PublicTag> get tags => {};
}
