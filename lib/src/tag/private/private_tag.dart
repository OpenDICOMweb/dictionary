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

typedef Tag TagMaker<E>(int code, VR<E> vr, [name]);

class PrivateTag extends Tag {

  const PrivateTag(int code, VR vr)
      : super(code, vr);

  /* flush
  const PrivateTag.creator(this.creatorToken, int code, VR vr,
      [VM vm = VM.k1_n])
      : super(code, vr, vm);
*/
  /* flush
  const PrivateTag.unknownCreator(int code, [VR vr = VR.kUN, VM vm = VM.k1_n])
      :  creatorToken = "Unknown Creator",
        super(code, vr, vm);

  const PrivateTag.data(int code, VR vr, VM vm, this.name, String name)
      : super.privateData(code, vr, vm, name);

   flush
  PrivateTag.unknownData(int code, [VR vr = VR.kUN, VM vm = VM.k1_n])
      : creatorToken = "Unknown Data",
        super(code, vr, vm);
  */

  PrivateTag.illegal(int code, [VR vr = VR.kUN]) : super(code, vr);

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
  String get info =>
    '$runtimeType$dcm $groupHex, "$name", $eltHex $vr, $vm';

  @override
  String toString() => '$runtimeType$dcm subgroup($subgroup)';

  static PrivateTag maker(int code, VR vr, String name) =>
      new PrivateTag.illegal(code, vr);
}

class PrivateGroupLengthTag extends PrivateTag {
  static const int kUnknownIndex = -1;

  PrivateGroupLengthTag(int code, VR vr)
      : super(code, vr);

  VR get expectedVR => VR.kUL;

  @override
  VM get vm => VM.k1;

  @override
  String get name => "Private Group Length Tag";

  static PrivateGroupLengthTag maker(int code, VR vr, [_]) =>
      new PrivateGroupLengthTag(code, vr);
}
