// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/issue.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'elt.dart';
import 'group.dart';
import 'tag.dart';

class PrivateTag extends Tag {

  const PrivateTag(String keyword, int code, VR vr,
                   [VM vm = VM.k1_n, bool isRetired = false])
      : super(keyword, code, "", vr, vm, isRetired);

  bool get isPublic => false;
  bool get isPrivate => !isPublic;

  bool get isCreator => false;
  bool get isData => false;

  /// Utilities for working with private Tags
  ///
  /// This library is designed to be imported using 'as pTag'.
  ///
  /// Definitions:
  ///   Private Group Number: A Tag Group Number that is odd and is greater than 0x0007
  ///       and less than 0xFFFF.
  ///   Private Group: includes all the Private Creator and Private Data Tag with the
  ///     same Private Group Number
  ///   Private Creator: A tag with the form GGGG00CC, where GGGG is the Private Group Number,
  ///       and CC is a Private Creator Index.
  ///   Private Creator Index: A 16-bit value between 0x0010 and 0x00FF.
  ///   Private Data: A tag with the form GGGGCCDD, where GGGG is the Private Group Number,
  ///       CC is the Private Creator Index, and DD is the Private Data Index.
  ///   Private Data Index: A 16-bit value between 0xCC00 and 0xCCFF, where CC is the Private
  ///       Creator Index for the Private Data Element.

  // Note: the following conventions are used function arguments in this library:
  //   t -  a 32-bit DICOM Tag
  //   pc - a 32-bit Private Creator Tag
  //   pd - a 32-bit Private Data Tag

  //   g -  a 16-bit Private Group Number

  //   e - a 16-bit Element Number
  //   pce - a 16-bit Private Creator Element
  //   pde - a 16-bit Private Data Element
  //   pci - an 8-bit Private Creator Index
  //   pdi - an 8-bit Private Data Index

  /// Groups that shall not be used in Private [Attributes].
  static const List<int> invalidPrivateGroups = const [0x0001, 0x0003, 0x0005, 0x0007, 0xFFFF];

  //TODO: move all static code related methods to TagBase.
  //static bool isPrivateGroup(int code) => codeGroup(code).isOdd && code

  /// Returns true if [code] is a valid [PrivateDataTag] tag.
  //static bool isPrivateCreatorCode(int code) =>
  //    group.isPrivate(codeGroup(code)) && Elt.isPrivateCreator(Elt.fromTag(code));

  static int privateCreatorBase(int code) => Elt.pcBase(Elt.fromTag(code));

  static int privateCreatorLimit(int code) => Elt.pcLimit(Elt.fromTag(code));

  static bool isPrivateDataCode(int tag) =>
      Group.isPrivate(Group.fromTag(tag)) && Elt.isPrivateData(Elt.fromTag(tag));

  /// Returns true if this is a valid [PrivateDataTag] tag.
  ///
  /// If the Private Creator Tag is present, verifies that [pd] and [pc] have the
  /// same [group], and that [pc] has a valid [pcIndex].
  static bool isValidPrivateData(int pd, int pc) {
    int pdg = Group.validPrivate(Group.fromTag(pd));
    int pcg = Group.validPrivate(Group.fromTag(pc));
    if (pdg == null || pcg == null || pdg != pcg) return null;
    return Elt.isValidPrivateData(Elt.fromTag(pd), Elt.fromTag(pc));
  }

  //**** Private Tag Constructors ****

  /// Returns a valid Private Creator Tag ([pce]), or [null].
  static int toPrivateCreator(int group, int pcIndex) {
    if (Group.isPrivate(group) && _isPCIndex(pcIndex))
      return _toPrivateCreator(group, pcIndex);
    return null;
  }

  /// Returns a valid Private Data Tag ([pde]), or [null].
  static int toPrivateData(int group, int pcIndex, int pdIndex) {
    if (Group.isPrivate(group) && _isPCIndex(pcIndex) && _isPDIndex(pcIndex, pdIndex))
      return _toPrivateData(group, pcIndex, pcIndex);
    return null;
  }

  /// Returns a Private Creator Tag ([pce]), without checking arguments.
  static int _toPrivateCreator(int group, int pcIndex) => (group << 16) + pcIndex;

  /// Returns a Private Data Tag ([pde]), without checking argumnents.
  static int _toPrivateData(int group, pcIndex, pdIndex) =>
      (group << 16) + (pcIndex << 8) + pdIndex;

  // **** Internal Utility functions ****

  /// Return [true] if [pdCode] is a valid Private Creator Index.
  static bool _isPCIndex(int pdCode) => 0x10 <= pdCode && pdCode <= 0xFF;

  /// Returns [true] if [pde] in a valid Private Data Index
  //static bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

  /// Return [true] if [e] is a valid Private Data Index.
  static bool _isPDIndex(int pce, int pde) => _pdBase(pce) <= pde && pde <= _pdLimit(pce);

  /// Returns the offset base  for a Private Data Element with the Private Creator [pc].
  static int _pdBase(int pcIndex) => pcIndex << 8;

  /// Returns the offset limit for a Private Data Element with the Private Creator [pc].
  static int _pdLimit(int pdBase) => pdBase + 0x00FF;
}


//TODO: flush when working
//bool _isPrivateCreator(Tag tag) => 0x0010 <= tag.elt && tag.elt <= 0x00FF;
//bool _isPrivateData(Tag tag) => 0x1000 <= tag.elt && tag.elt <= 0xFFFF;

/// The superclass for Private Tags.
///
/// It cannot be created because it has no public constructors.
class PrivateCreatorTag extends PrivateTag {
  final String company;
  final String name;

  //TODO: fix two uses of name below.
  /// Creates a Well Known Private Tag.
  const PrivateCreatorTag._(this.company, this.name,
      int code, [VR vr, VM vm = VM.k1, bool isRetired = false])
      : super(name, code, vr, vm, isRetired);

  bool get isCreator => true;

  int get base => elt << 8;

  int get limit => base + 0xFF;

  bool isValidDataCode(int code) =>
      group == codeGroup(code) && (base <= codeElt(code) && codeElt(code) <= limit);

  static PrivateCreatorTag lookup(int code) {
    PrivateCreatorTag tag = pcTags[code];
  }

  static const kFoo =
      const PrivateCreatorTag._("Acme", "Creator Id", 0x00090010);

  static const Map<int, PrivateCreatorTag> pcTags = const {};
}

class UnknownPrivateCreatorTag extends PrivateCreatorTag {
  UnknownPrivateCreatorTag(int code, String name, [VR vr = VR.kUN, VM vm = VM.k1, bool isRetired =
  false])
      : super._("Unknown Company", name, code, vr, vm, isRetired);

  static UnknownPrivateCreatorTag lookup(int code) {
    PrivateTag tag = PrivateCreatorTag.lookup(code);
    if (tag != null) return tag;
    return UnknownPrivateCreatorTag.lookup(code);
  }

  static bool isValidPDataCode(UnknownPrivateCreatorTag c, int code) => c.isValidDataCode(code);

  static final unknown = new UnknownPrivateCreatorTag(0, "UnknownName");
  //TODO: figure this out
  static final Map<int, UnknownPrivateCreatorTag> unknownPCTags = {};
}

class PrivateDataTag extends PrivateTag {
  final PrivateCreatorTag creator;
  final String name;

  /// Creates a Well Known Private Tag.
  const PrivateDataTag._(this.creator, this.name,
      int code, [VR vr, VM vm = VM.k1, bool isRetired = false])
      : super(name, code, vr, vm, isRetired);


  static lookup(int code) => pdTags[code];

  static const kFooData =
  const PrivateDataTag._(PrivateCreatorTag.kFoo, "Data name", 0x00091000);

  static const Map<int, PrivateDataTag> pdTags = const {};
}

class UnknownPrivateDataTag extends PrivateTag {
  final PrivateCreatorTag creator;

  //TODO: fix empty string "" in constructors below.
  UnknownPrivateDataTag._(this.creator, int code,
                          [VR vr = VR.kUN, VM vm = VM.k1, bool isRetired = false])
      : super("UnKnownPrivateData", code, vr, vm, isRetired);

  UnknownPrivateDataTag(PrivateCreatorTag creator, int code,
                        [VR vr = VR.kUN, VM vm = VM.k1, bool isRetired = false])
      : creator = (creator.isValidDataCode(code)) ? creator : throw "Invalid Creator",
        super("UnKnownPrivateData", code, vr, vm, isRetired);

  bool get isCreator => false;

  bool get isPublic => !isPrivate;

  static PrivateTag lookup(int code) => unknownPrivateTags[code];

}

final Map<int, PrivateTag> unknownPrivateTags = {};





