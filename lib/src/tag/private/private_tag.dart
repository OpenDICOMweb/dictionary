// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

class PrivateTag extends Tag {
  static const int kUnknownIndex = -1;
  final String token;

  const PrivateTag(this.token, int code, VR vr, [VM vm = VM.k1_n])
      : super(code, vr, vm);

  /* flush
  const PrivateTag.creator(this.creatorToken, int code, VR vr,
      [VM vm = VM.k1_n])
      : super(code, vr, vm);
*/
  /* flush
  const PrivateTag.unknownCreator(int code, [VR vr = VR.kUN, VM vm = VM.k1_n])
      :  creatorToken = "Unknown Creator",
        super(code, vr, vm);
   */
  const PrivateTag.data(this.token, int code, VR vr, VM vm, String name)
      : super.privateData(code, vr, vm, name);

  /* flush
  PrivateTag.unknownData(int code, [VR vr = VR.kUN, VM vm = VM.k1_n])
      : creatorToken = "Unknown Data",
        super(code, vr, vm);
  */
  PrivateTag.groupLength(int code)
      : token = "Private Group Length",
        super(code, VR.kUL, VM.k1);

  PrivateTag.illegal(int code, [VR vr = VR.kUN])
      : token = "Illegal Private Tag",
        super(code, vr, VM.k1_n);

  PrivateTag.dataNoCreator(int code, VR vr, [VM vm = VM.k1_n])
      : token = "Private Data W/O Creator",
        super(code, vr, vm);

  /// The Private Subgroup for this Tag.
  // Note: MUST be overridden in all subclasses.
  int get subgroup => -1;

  @override
  bool get isPrivate => true;
  @override
  bool get isPublic => false;
  @override
  bool get isCreator => false;

  @override
  bool get isKnown => false;

  String get asString => toString();

  @override
  String get info =>
      '$dcm $groupHex, "$token", $eltHex $vr, $vm, "$name"';

  @override
  String toString() => '$runtimeType$dcm subgroup($subgroup)';
}
