// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/integer/hash.dart';
import 'package:test/test.dart';

main() {

  print('32: ${hash(32)}');
  print('33: ${hash(33)}');
  print('hash2(32, 32) = ${hash2(32, 32)}');
  print('hash(32) = ${Hash.hash(32)}');
  print('hash(33) = ${Hash.hash(33)}');
  print('hash(3.2) = ${Hash.hash(3.2)}');
  print('hash(3.4) = ${Hash.hash(3.4)}');
  print('hash("32") = ${Hash.hash("32")}');
  print('hash("33") = ${Hash.hash("33")}');
  //hash64Test();
  // hash32Test();
}

hash64Test() {

  test("Hash64.n1", () {

  });


}

hash32Test() {

  test("Hash32.n1", () {

  });


}