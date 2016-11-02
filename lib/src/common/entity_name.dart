// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/uid.dart';

//TODO: unit test

class EntityName {
  //TODO: add patient later
  //String patient;
  String study;
  String series;
  String instance;

  EntityName(this.study, [this.series, this.instance]);

  bool get isValid {
    //TODO: this logic can be simplified
    bool ins = Uid.isValid(instance);
    bool ser = Uid.isValid(series);
    bool std = Uid.isValid(study);
    if ((ins && ser && std) || (ser && std) || std) return true;
    return false;
  }

  //TODO: can null-aware operators make this cleaner
  String get path {
    if (series == null) return '/$study';
    if (instance == null) return '/$study/$series';
    return '/$study/$series/$instance';
  }
}
