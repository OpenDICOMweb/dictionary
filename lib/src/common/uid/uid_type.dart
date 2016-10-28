// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


/// The common of UIDs
class UidType {
  final int index;
  final String name;

  const UidType(this.index, this.name);

  String get keyword => name.replaceAll(" ", "");

  String toString() => name;

  // This happens when it is passed in and not "well known"
  static const kUnknown = const UidType(-1, "Unknown");

  // Random 2.25. + V4 Uuid
  static const kGenerated = const UidType(0, "Generated");

  // Constructed from Root + leaf
  static const kConstructed = const UidType(1, "Constructed");
}