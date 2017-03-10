// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/ascii.dart';

const int uidMinLength = 6;
const int uidMaxLength = 64;
const int uidMaxRootLength = 24;

/// ASCII constants for '0', '1', and '2'. No other roots are valid.
const List<int> uidRoots = const [k0, k1, k2];

final RegExp uidRegex = new RegExp(r"[012]((\.0)|(\.[1-9]+\d*))+");

/// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
bool isValidUidString(String uidString) {
  if (uidString == null ||
      !_isValidLength(uidString.length) ||
      !uidRoots.contains(uidString.codeUnitAt(0))) return false;
  for (int i = 1; i < uidString.length - 1; i++) {
  //  print('  $i: ${uidString[i]}, ${i+1}: ${uidString[i+1]}');
    int char0 = uidString.codeUnitAt(i);
    if (char0 == kDot) {
      if (uidString.codeUnitAt(i + 1) == k0 &&
          uidString.codeUnitAt(i + 2) != kDot) return false;
    } else {
      if (!isDigitChar(char0)) return false;
    }
  }
  if (!isHexChar(uidString.codeUnitAt(uidString.length - 1))) return false;
  return true;
}

bool _isValidLength(int length) =>
    uidMinLength <= length && length <= uidMaxLength;

/// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
String checkUid(String s) => (isValidUidString(s)) ? s : null;

String uidRootType(String uidString) => _rootType[uidString.codeUnitAt(0)];

const Map<int, String> _rootType = const <int, String>{
  0: "ITU-T",
  1: "ISO",
  2: "joint-iso-itu-t"
};
