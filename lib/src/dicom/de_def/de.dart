// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';
import 'package:dictionary/dictionary.dart';

class DE {
  final ByteData bd;

  const DE(List<int> def);// : const ByteData(def);

  int get tag => bd.getUint32(0);
  int get group => bd.getUint16(0)
  int get elt => bd.elt(0);
  ...
}