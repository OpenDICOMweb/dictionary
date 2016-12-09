// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

import 'tag.dart';
import 'tag_type.dart';


class TagPrivate extends Tag {

  /// Create a [const] [TagPrivate] definition.
  const TagPrivate(int index, int tag, String keyword, String name,
                  VR vr, VM vm, TagType type, bool isRetired)
      : super(index, tag, keyword, name, vr, vm, type, false, isRetired);
}