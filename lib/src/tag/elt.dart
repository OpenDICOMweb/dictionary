// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/group.dart';

/// Methods to use with a DICOM Elt (aka element), a 16-bit integer.
///
/// The [Group] methods expect their argument to be a 16-bit group number.
class Elt {

  static const int kElementMask = 0x0000FFFF;

  ///
  static int fromTag(int tagCode) => tagCode & kElementMask;

  /// Returns the [Elt] [int] as a hex [String].
  static String hex(int elt) => Group.hex(elt);

  /// Returns [true] if [v] fits in 16-bits.
  static bool isValid(int v) => (0 <= v && v <= 0xFFFF) ? true : false;

  static int valid(int v) => isValid(v) ? v : null;

  static bool isPrivateCreator(int elt) => 0x10 <= elt && elt <= 0xFF;

  static int pcBase(int pcElt) => (isPrivateCreator(pcElt)) ? pcElt << 8 : null;

  static int pcLimit(int pcElt) {
    int base = pcBase(pcElt);
    return (base == null) ? null : pcElt + 0xFF;
  }

  static bool isPrivateData(int elt) => 0x1000 <= elt && elt <= 0xFFFF;

  static bool isValidPrivateData(int pdElt, int pcElt) =>
      pcBase(pcElt) <= pdElt && pdElt <= pcLimit(pcElt);
}
