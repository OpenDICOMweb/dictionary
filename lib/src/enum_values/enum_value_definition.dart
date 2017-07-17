// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/terminology/term.dart';

///
abstract class EnumValueDefinition<T> {
  final String name;
  final T value;
    final Term term;
    final bool isRetired;

    const EnumValueDefinition(this.name, this.value, this.term,
        [this.isRetired = false]);

    String get definition => term.definition;
}

class YesNo extends EnumValueDefinition<String> {
  const YesNo(String name, String value, Term term, [bool isRetired])
      : super(name, value, term, isRetired);

  static const YesNo kNO = const YesNo("NO", "NO", Term.kNO);
  static const YesNo kYES = const YesNo("YES", "YES", Term.kYES);

  //Fix: in order for ignoreCase to work we must pick a canonical case.
  static YesNo lookup(String key, {bool ignoreCase = false}) => map[key];

  static const Map<String, YesNo> map = const {"NO": kNO, "YES": kYES};
}