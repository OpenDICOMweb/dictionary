// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:test/test.dart';

void main() {
  var v = VR.kTM.isValid("070907.0705");
  print('v: $v');
  vrTest();
}

void vrTest() {
  group('VR Tests', () {
    test('TM Test', () {});
  });
}
