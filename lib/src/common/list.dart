// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: Use the 'package:collection/collection.dart' ListEquality
/// Compares two [List]s of [String]s recursively and returns [true] if all
/// elements are equal; otherwise, returns [false].
bool listEquals(List e0, List e1) {
  if (e0.length != e1.length) return false;
  for (int i = 0; i < e0.length; i++)
    if (e0[i] != e1[i]) return false;
  return true;
}


//Note: only one level, NOT deep copy
List listCopy(List values) {
  List copy = new List(values.length);
  for(int i = 0; i < values.length; i++)
    copy[i] = values[i];
  return copy;
}
