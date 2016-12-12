// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/terminology/term.dart';

abstract class EnumValue<E> {
  final int index;
  final String name;
  final E value;
  final Term term;
  final bool isRetired;

  const EnumValue(this.index, this.name, this.value, this.term, [this.isRetired = false]);

  bool get isExtensible => false;

  //List<EnumeratedValueBase> get values;

  String get definition => term.definition;

  EnumValue lookup(String name);
}

class YesNo extends EnumValue<String> {

  const YesNo(int index, String name, String value, Term term)
      : super(index, name, value, term);

  static const kNO = const YesNo(0, "NO", "NO", Term.NO);
  static const kYES = const YesNo(1, "YES", "YES", Term.YES);

  YesNo lookup(String key) => map[key];

  static const map = const {
    "NO": kNO,
    "YES": kYES
  };
}
