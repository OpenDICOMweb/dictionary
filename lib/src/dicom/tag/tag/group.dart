// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';

/// Methods to use with a DICOM Group, a 16-bit integer.
///
/// The [Group] methods expect their argument to be a 16-bit group number.
class Group {
  static const int kGroupMask = 0xFFFF0000;
  static const shiftCount = 16;

  /// Returns the must significant 16 bits of the [tagCode]*[]:
  static int fromTag(int tagCode) => tagCode >> shiftCount;

  /// Returns [true] if [g] is Public Group (even) or a valid Private Group. fits in 16-bits.
  static bool isValid(int g) => g.isEven || isPrivate(g);

  /// Returns the Group Number is it is a valid Group Number.
  static int valid(int g) => (isValid(g)) ? g : null;

  /// Returns[true] is [g] is a valid Public Group Number.
  static bool isPublic(int g) => g.isEven && 0x0008 <= g  && g <= 0xFFFC;

  static bool isNotPublic(int g) => !isPublic(g);

  /// Returns [true] if [g] is a valid Private Group Number.
  static bool isPrivate(int g)=> g.isOdd && (0x0007 < g && g < 0xFFFF);

  static int validPrivate(int g) => (isPrivate(g)) ? g : null;

  static bool isNotPrivate(int g) => !isPrivate(g);

  /// Returns the [tagGroup] number as a hex [String].
  static String hex(int g, [String prefix = "0x"]) => Int.hex(g, 4, prefix);

//static int validateGroup(int tag) => validGroup(tag) ? tag : null;
}