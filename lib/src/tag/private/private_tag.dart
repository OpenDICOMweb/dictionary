// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/number.dart';
import 'package:dictionary/src/e_type.dart';
import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

typedef Tag TagMaker<E>(int code, VR<E> vr, [dynamic name]);

class PrivateTag extends Tag {
  const PrivateTag(int code, VR vr) : super(code, vr);

  PrivateTag._(int code, [VR vr = VR.kUN]) : super(code, vr);

  @override
  bool get isPrivate => true;

  @override
  VM get vm => VM.k1_n;

  @override
  String get name => "Illegal Private Tag";

  int get index => -1;

  /// The Private Subgroup for this Tag.
  // Note: MUST be overridden in all subclasses.
  int get subgroup => (isCreator) ? code & 0xFF : (code & 0xFF00) >> 8;

  @override
  EType get type => EType.k3;

  String get subgroupHex => Uint8.hex(subgroup);

  String get asString => toString();

  @override
  String get info => '$runtimeType$dcm $groupHex, "$name", $eltHex $vr, $vm';

  @override
  String toString() => '$runtimeType$dcm subgroup($subgroup)';

/*  static PrivateTag maker(int code, VR vr, String name) =>
      new PrivateTag._(code, vr);*/
}

/// Private Group Length Tags have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is zero.  For example (0009,0000).
class PrivateGroupLengthTag extends PrivateTag {
  static const int kUnknownIndex = -1;

  PrivateGroupLengthTag(int code, VR vr) : super(code, vr);

  @override
  VR get vr => VR.kUL;

  @override
  VM get vm => VM.k1;

  @override
  String get name => "Private Group Length Tag";

  //Flush at V0.9.0 if not used.
  static PrivateGroupLengthTag maker(int code, VR vr, [_]) =>
      new PrivateGroupLengthTag(code, vr);
}

/// Private Illegal Tags have have codes that are (gggg,eeee),
/// where gggg is odd, and eeee is between 01 and 09 hexadecimal.
/// For example (0009,0005).
// Flush at v0.9.0 if not used by then
class PrivateIllegalTag extends PrivateTag {
  static const int kUnknownIndex = -1;

  PrivateIllegalTag(int code, VR vr) : super(code, vr);

  @override
  String get name => "Private Illegal Tag";

  static PrivateIllegalTag maker(int code, VR vr, String name) =>
      new PrivateIllegalTag(code, vr);
}
