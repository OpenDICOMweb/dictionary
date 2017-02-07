// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/enum_values/enum_value_base.dart';
import 'package:dictionary/src/terminology/term.dart';

abstract class DefinedTerm<E> extends EnumValue<E> {
  const DefinedTerm(int index, String name, E value, Term definition)
      : super(index, name, value, definition);

  @override
  bool get isExtensible => true;
}
