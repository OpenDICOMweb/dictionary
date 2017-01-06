// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'tag_public_bytes.dart';
import 'e_type.dart';

//TODO: flush when working
//bool _isPrivateCreator(Tag tag) => 0x0010 <= tag.elt && tag.elt <= 0x00FF;
//bool _isPrivateData(Tag tag) => 0x1000 <= tag.elt && tag.elt <= 0xFFFF;

/// The superclass for Private Tags.
///
/// It cannot be created because it has no public constructors.
class PrivateTag extends Tag {
  static const bool public = false;
  static const bool privateCreator = false;

  /// Internal constructor called by superclass.
  const PrivateTag.bd(ByteData bd) : super.bd(bd);

  /// Internal constructor used to create Private Tags with Implicit VRs.
  /// Only called by superclasses.
  //PrivateTag._implicit(int tag) : super(tag);

  String get keyword => privateTagKeywords[bd.getUint8(kIndexOffset)];
  String get name => privateTagKeywords[bd.getUint8(kIndexOffset)];
  VR get vr => privateVRs[bd.getUint8(kVRIndexOffset)];
  VM get vm => privateVMs[bd.getUint8(kVMIndexOffset)];
  TagType get type => privateTagTypes[bd.getUint16(kTypeOffset)];

  @override
  bool get isPublic => public;

  bool get isPrivateCreator => false;
  bool get isPrivateData => !isPrivateCreator;

  static final k0008GroupLength = new Tag.bd(new ByteData.view(PublicTagData[1]));
  static final kSpecificCharacterSet = new Tag.bd(new ByteData.view(PublicTagData[2]));

  //**** can't be constant
  static Map<int, Tag> privateTags = {
    0x00080000: k0008GroupLength,
    0x00080008: kSpecificCharacterSet
  };

  static const List<String> privateTagKeywords = const ["Unknown", "foo", "bar"];
  static const List<String> privateTagNames = const ["Unknown", "foo", "bar"];
  static const List<VR> privateVRs = const [VR.kUnknown, VR.kCS, VR.kOB];
  static const List<VM> privateVMs = const [VM.kUnknown, VM.k1, VM.k2];
  static const List<TagType> privateTagTypes = const [VM.kUnknown, TagType.k1, VM.k2];
}

class PrivateCreatorTag extends PrivateTag {
  factory PrivateCreatorTag(int tag, [int vrIndex]) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new PrivateCreatorTag.bd(bd);
  }

  const PrivateCreatorTag.bd(ByteData bd) : super.bd(bd);

  factory PrivateCreatorTag.implicit(int tag) {
    PrivateCreatorTag v = wellKnown[tag];
    if (v != null) return v;
    return new PrivateCreatorTag(tag, VR.kUnknown.index);
  }

  @override
  bool get isPrivateCreator => true;

  /// Returns the Well Known [PrivateCreatorTag] that corresponds to [tag].
  static lookup(int tag) {
    var v = PrivateTag.privateTags[tag];
    return (v == null || v.isPrivateData) ? null : v;
  }

  static const Map<int, PrivateCreatorTag> wellKnown = const {};
}

class InvalidPrivateCreatorTag extends PrivateCreatorTag {
  factory InvalidPrivateCreatorTag(int tag, int vrIndex) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new InvalidPrivateCreatorTag.bd(bd);
  }

  InvalidPrivateCreatorTag.bd(ByteData bd) : super.bd(bd);
}

class PrivateDataTag extends PrivateTag {
  /// The [String] used by the [PrivateCreator] of this Private Data.
  final String creator;

  factory PrivateDataTag(int tag, [int vrIndex, String creator]) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new PrivateDataTag.bd(bd, creator);
  }

  const PrivateDataTag.bd(ByteData bd, this.creator) : super.bd(bd);

  factory PrivateDataTag.implicit(int tag, String creator) {
    PrivateDataTag v = wellKnown[tag];
    if (v != null) return v;
    return new PrivateDataTag(tag, VR.kUnknown.index, creator);
  }

  @override
  bool get isPrivateCreator => false;

  /// Returns the Well Known [PrivateCreatorTag] that corresponds to [tag].
  static lookup(int tag) {
    var v = PrivateTag.privateTags[tag];
    return (v == null || v.isPrivateCreator) ? null : v;
  }

  static const Map<int, PrivateDataTag> wellKnown = const {
    //TODO: generate
  };
}

//TODO: flush there is no need for this.
class InvalidPrivateDataTag extends PrivateDataTag {
  factory InvalidPrivateDataTag(int tag, [int vrIndex = 0, String creator]) {
    ByteData bd = new ByteData(16);
    bd.setUint32(0, kTagOffset);
    bd.setInt16(4, -1);
    bd.setUint8(kVRIndexOffset, vrIndex);
    return new InvalidPrivateDataTag.bd(bd, creator);
  }

  InvalidPrivateDataTag.bd(ByteData bd, [String creator = "Unknown Private Creator"])
      : super.bd(bd, creator);
}
