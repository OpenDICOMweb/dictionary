// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

import 'tag.dart';
import 'tag_type.dart';

//TODO: sort out the naming between Attribute, Data Element, tag, etc.
// DICOM Attribute Definitions
class TagPublic extends Tag {
  /// Create a [const] [TagPublic] definition.
  const TagPublic(
      int index, int tag, String keyword, String name, VR vr, VM vm, TagType type, bool isRetired)
      : super(index, tag, keyword, name, vr, vm, type, true, isRetired);



  //**** Message Data Elements begin here ****
  static const kAffectedSOPInstanceUID = const TagPublic(1, 0x00001000, "AffectedSOPInstanceUID",
      "Affected SOP Instance UID ", VR.kUI, VM.k1, TagType.k1, false);
}

//TODO: Move 0x002831xx elements down to here and change name
//TODO: Move 0x002804xY elements down to here and change name
//TODO: Move 0x002808xY elements down to here and change name
//TODO: Move 0x1000xxxY elements down to here and change name
//TODO: Move 0x50xx,yyyy elements down to here and change name
//TODO: Move 0x60xx,yyyy elements down to here and change name
//TODO: Move 0x7Fxx,yyyy elements down to here and change name
