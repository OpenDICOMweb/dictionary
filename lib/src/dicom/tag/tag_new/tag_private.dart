// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'tag.dart';
import 'tag_type.dart';
import 'wk_private_tags.dart';

//TODO: flush when working
//bool _isPrivateCreator(Tag tag) => 0x0010 <= tag.elt && tag.elt <= 0x00FF;
//bool _isPrivateData(Tag tag) => 0x1000 <= tag.elt && tag.elt <= 0xFFFF;

/// The superclass for Private Tags.
///
/// It cannot be created because it has no public constructors.
class PrivateTag extends Tag {
  final String keyword = "Unknown";
  final VR vr = VR.kUN;
  final VM vm = VM.kUnknown;
  final EType type = EType.kUnknown;
  final bool isPublic = false;
  final bool isPrivateCreator = false;

  /// Internal constructor called by superclass.
  const PrivateTag._(int tag) : super(tag, VR.kUN);

  /// Internal constructor used to create Private Tags with Implicit VRs.
  /// Only called by superclasses.
  PrivateTag._implicit(int tag) : super(tag, VR.kUN);

  String get name => keyword;

  bool get isPrivateData => !isPrivateCreator;
}

class PrivateCreatorTag extends PrivateTag {
  @override
  final bool isPrivateCreator = true;

  /// The [String] used as the Value of this Private Creator.
  @override
  final String keyword;

  /// All Private Creators have a [VR] of [VR.kLO].
  @override
  final VR vr = VR.kLO;

  /// All Private Creators have a [VM] of [VM.k1].
  @override
  final VM vm = VM.k1;

  const PrivateCreatorTag(int tag, this.keyword) : super._(tag);

  //TODO: needed
  //static isValid(TagBase tag) => Tag.isPrivateCreator(tag.tag);

  /// Returns the Well Known [PrivateCreatorTag] that corresponds to [tag].
  static wellKnown(int tag) {
    var v = wellKnownPrivateTags[tag];
    return (v == null || v.isPrivateData) ? null : v;
  }
}

class PrivateDataTag extends PrivateTag {
  @override
  final keyword;
  @override
  final VR vr;
  @override
  final VM vm;
  /// The [String] used by the [PrivateCreator] of this Private Data.
  final String creator;

  const PrivateDataTag(int tag, this.keyword, this.vr, this.vm, this.creator) : super._(tag);

  PrivateDataTag.implicit(int tag, this.creator)
      : keyword = "Unkknown Private Data",
        vr = VR.kUN,
        vm = VM.kUnknown,
        super._(tag);

  //TODO: needed
  //static isValid(int tag) => Tag.isPrivateData(tag);

  /// Returns the Well Known [PrivateDataTag] that corresponds to [tag].
  static wellKnown(int tag) {
    var v = wellKnownPrivateTags[tag];
    return (v == null || v.isPrivateCreator) ? null : v;
  }
}
