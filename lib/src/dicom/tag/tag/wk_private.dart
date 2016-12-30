// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'group.dart';
import 'elt.dart';
import 'tag.dart';
// import 'e_type.dart';


//TODO: flush when working
//bool _isPrivateCreator(Tag tag) => 0x0010 <= tag.elt && tag.elt <= 0x00FF;
//bool _isPrivateData(Tag tag) => 0x1000 <= tag.elt && tag.elt <= 0xFFFF;

/// The superclass for Private Tags.
///
/// It cannot be created because it has no public constructors.
class WKPrivateTag extends Tag {
  final String keyword;
  final int code;
  final VR vr;
  final VM vm;
 // final EType type;
  final String name;
  final bool isRetired;
  final bool isCreator;

  /// Creates a Well Known Private Tag.
  const WKPrivateTag(this.keyword, this.code, this.name,
                     this.vr, this.vm, this.isRetired, this.isCreator)
      : super(keyword, code, name, vr, vm, isRetired);

  bool get isPublic => false;
  bool get isValidPublic => false;
  bool get isPrivate => true;
  bool get isValid => true;
  bool get isData => !isCreator;

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

  /// Returns [true] if [tag] is a valid DICOM Private Tag.
 // static bool isPrivate(int tag) => Group.isPrivate(group(tag));

  /// Returns true if [tag] is a valid [PrivateCreator] tag.
  static bool isPrivateCreator(int tag) =>
      Group.isPrivate(Group.fromTag(tag)) && Elt.isPrivateCreator(Elt.fromTag(tag));

  static int privateCreatorBase(int tag) => Elt.pcBase(Elt.fromTag(tag));

  static int privateCreatorLimit(int tag) => Elt.pcLimit(Elt.fromTag(tag));

  static bool isPrivateData(int tag) =>
      Group.isPrivate(Group.fromTag(tag)) && Elt.isPrivateData(Elt.fromTag(tag));

  /// Returns true if this is a valid [PrivateData] tag.
  ///
  /// If the Private Creator Tag is present, verifies that [pd] and [pc] have the
  /// same [group], and that [pc] has a valid [pcIndex].
  static bool isValidPrivateData(int pd, int pc) {
    int pdg = Group.validPrivate(Group.fromTag(pd));
    int pcg = Group.validPrivate(Group.fromTag(pc));
    if (pdg == null || pcg == null || pdg != pcg) return null;
    return Elt.isValidPrivateData(Elt.fromTag(pd), Elt.fromTag(pc));
  }

  /// Returns [true] if the Private Data Element [pde] is valid for one of the [pcs] Private
  /// Creator Tags.
  /*
  static bool inPrivateGroup(List<int> pcs, int pde) {
    for (int i = 0; i < pcs.length; i++) {
      if (!isPrivateData(pde, pcs[i])) return false;
    }
    return true;
  }
  */
  //**** Private Tag Constructors ****

  /// Returns a valid Private Creator Tag ([pce]), or [null].
  static int toPrivateCreator(int group, int pcIndex) {
    if (Group.isPrivate(group) && _isPCIndex(pcIndex)) return _toPrivateCreator(group, pcIndex);
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

  /// Return [true] if [pde] is a valid Private Creator Index.
  static bool _isPCIndex(int pde) => 0x10 <= pde && pde <= 0xFF;

  /// Returns [true] if [pde] in a valid Private Data Index
  //static bool _isSimplePDIndex(int pde) => 0x1000 >= pde && pde <= 0xFFFF;

  /// Return [true] if [e] is a valid Private Data Index.
  static bool _isPDIndex(int pce, int pde) => _pdBase(pce) <= pde && pde <= _pdLimit(pce);

  /// Returns the offset base  for a Private Data Element with the Private Creator [pc].
  static int _pdBase(int pcIndex) => pcIndex << 8;

  /// Returns the offset limit for a Private Data Element with the Private Creator [pc].
  static int _pdLimit(int pdBase) => pdBase + 0x00FF;

  static const Map<int, WKPrivateTag> tags = const {};


}

