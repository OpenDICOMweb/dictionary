// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

/// General [String] utility functions.

/// Returns a [String] that corresponds to 'name' of the [Symbol]. */
String symbolToString(Symbol symbol) {
  String s = symbol.toString(); // Symbol("foo")
  return s.substring(8, s.length - 2);
}

int checkStringLength(String s, int min, int max) {
  var length = s.length;
  if ((length < min) || (length > max))
    throw 'Invalid length: min= $min, max=$max, "$s" has length ${s.length}';
  return length;
}


List<String> checkStringList(List<String> sList, int min, int max, bool pred(int)) {
  for (int i = 0; i < sList.length; i++) {
    var s = sList[i];
    if (max != null) checkStringLength(s, min, max);
    sList[i] = s.trim();
  }
  return sList;
}

bool isValidList(List<String> vList, int min, int max, bool pred(int)) {
  for (String s in vList) {
    if (s.length == 0) continue;
    checkStringLength(s, min, max);
    for (int i = 0; i < s.length; i++) {
      int c = s.codeUnitAt(i);
      if (!pred(c)) throw 'String $s contains invalid character $c';
    }
  }
  return true;
}

const int _kSpace = 0x20;

String bytesToString(Uint8List bytes, [int start = 0, int end]) {
  end = (end == null) ? bytes.length : end;
  assert((end - start).isOdd);
  if (bytes[end - 1] == _kSpace) end = end - 1;
  return bytes.sublist(start, end).toString();
}

/// Returns a [String] in the form of a [List] ("[
String listToString(List<String>list) => '[${list.join(", ")}]';
