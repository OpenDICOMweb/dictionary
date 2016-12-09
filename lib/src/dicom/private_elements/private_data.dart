// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/dicom.dart';


class PrivateData {
  /// The [name] of [creator] for [this].
  final String creator;
  /// The [name] of this private data if known
  final String name;
  /// 16-bit group number - must be odd.
  final int group;
  /// 16-bit combination of creator.elt << 8 + elt
  final int elt;
  /// The [VR] for [this].
  final VR vr;
  /// The [VM] for [this].
  final VM vm;

   /// The [id] is a Tag created by group|creatorElt|element
  int get id => group << 16 + elt;

  //TODO: validate creator and creatorId when generating.

  const PrivateData(this.creator, this.name, this.group, this.elt, this.vr, this.vm,);

  static const k00091000
    = const PrivateData("GEMS_ACQU_01", "Unknown", 0x009, 0x11, VR.kOB, VM.k1_n);
}