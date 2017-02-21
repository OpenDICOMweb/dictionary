// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.dictionary.uid;

import 'package:common/common.dart';
import 'package:dictionary/dictionary.dart';

import 'uid_base.dart';
import 'uid_type.dart';

part 'color_palettes.dart';
part 'sop_class.dart';
part 'transfer_syntax.dart';
part 'uuid.dart';
part 'well_known_frame_of_reference.dart';
part 'wk_uid.dart';

//TODO: need stronger validation.
//TODO: document class
//TODO: test for performance

/// A UID constructed from a [String] or from a [root] and [leaf].  This
/// class is the super class for all Well Known UIDs.
class Uid extends UidBase {
  static const int kMin = 6;
  static const int kMax = 64;
  static const int maxRootLength = 24;
  static CharPredicate kPred = isUidChar;
  @override
  final String asString;

  factory Uid([String s]) => (s == null) ? new UidUuid() : parse(s);

  Uid.withRoot(String root, String leaf)
      : asString = check(root + leaf);
     //   super._();

  const Uid._(this.asString);// : super._();

  @override
  UidType get type => UidType.kConstructed;

  //TODO: Needed?
  // String get root;

  static UidBase get random => new UidUuid();

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.generator.string;
    return uList;
  }

  /// Returns a [String] containing a random UID as per the
  /// OID Standard.  See TODO: add reference.
  static String get uidString => uidRoot + new Uuid().asString;

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
  static String check(String s) => isValid(s) ? s : null;

  static String test(String s) =>
      isValid(s) ? s : throw "Invalid Uid String: $s";

  static String validRoot(String root) {
    if (root.length > maxRootLength)
      throw new ArgumentError("root length > $maxRootLength");
    if ((checkString(root, kMin, kMax, kPred) == null))
      throw new ArgumentError('invalid UID root: $root');
    return root;
  }

  // TODO: this test is not good enough. needs to check root is [0,1,2], etc.
  static bool isValid(String s) => testString(s, kMin, kMax, kPred);

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
  static String validate(String s) =>
      (testString(s, kMin, kMax, kPred)) ? s : null;

  static final RegExp uidPattern = new RegExp(r"[012]((\.0)|(\.[1-9]\d*))+");

  static bool validateStrings(List<String> sList) {
    for (String s in sList) if (!isValid(s)) return false;
    return true;
  }

  //TODO improve parser
  static Uid parse(String uidString) {
    // Remove leading & trailing spaces - defensive programming
    String s = uidString.trim();
    if (validate(s) == null) return null;
    WKUid uid = wellKnownUids[s];
    if (uid != null) return uid;
    return new Uid._(s);
  }
}
