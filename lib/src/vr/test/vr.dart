// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

abstract class VR<T> {
  VR();

 // bool foo<T>(T value);
}

class VRInt extends VR<int> {
  VRInt();

//  bool foo<int>(int n) => n > 0; // Thinks n is Object
}

class VRString extends VR<String> {
  VRString();

  //bool foo(String s) => s.length > 0; // Thinks s is Object
}
