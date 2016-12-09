// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: document
/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
class TagType {
  final int value;
  final bool isConditional;
  final String name;

  const TagType(this.value, this.isConditional, this.name);

  static const kUnknown = const TagType(0, false, "0");

  static const k1 = const TagType(1, false, "1");
  static const k1c = const TagType(1, true, "1C");
  static const k2 = const TagType(2, false, "2");
  static const k2c = const TagType(2, true, "2C");
  static const k3 = const TagType(3, false, "3");

}