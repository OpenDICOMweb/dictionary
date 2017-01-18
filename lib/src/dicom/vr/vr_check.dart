// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'vr.dart';

//TODO document
abstract class VRCheck<E> {

  const VRCheck();

  VR get vr;

  bool isValid(E value);

  bool isNotValid(E value) => ! isValid(value);

  bool areValid(List<E> values)  {
    for (E v in values)if (isNotValid(v)) return false;
    return true;
  }

  E check(E value) => (isValid(value)) ? value : null;

  List<E> checkList(List<E> values) => (areValid(values)) ? values : null;

  String hasError(E value) => (isValid(value)) ? null : 'Invalid Value: $value';
}