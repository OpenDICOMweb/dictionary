// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// A DICOM Data Element Type.  See PS3.5, Section 7.4.
class DEType {
  final int value;
  final bool isConditional;
  final String name;

  const DEType(this.value, this.isConditional, this.name);

  static const k1 = const DEType(1, false, "1");
  static const k1c = const DEType(1, true, "1C");
  static const k2 = const DEType(2, false, "2");
  static const k2c = const DEType(2, true, "2C");
  static const k3 = const DEType(3, false, "3");
}