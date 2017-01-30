// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

//TODO: document class
/// A UID constructed from a [String] or from a [root] and [leaf].  This
/// class is the super class for all Well Known UIDs.
class UidString extends Uid {
  static const int kMin = 6;
  static const int kMax = 64;
  static const int maxRootLength = 24;
  static CharPredicate kPred = isUidChar;
  @override
  final String string;

  UidString(String s)
      : string = check(s),
        super._();

  UidString.withRoot(String root, String leaf)
      : string = check(root + leaf),
        super._();

  const UidString._(this.string) : super._();

  @override
  UidType get type => UidType.kConstructed;

  //TODO: Needed.
 // String get root;

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
  static String check(String s) => isValid(s) ? s : null;

  static String test(String s) => isValid(s) ? s : throw "Invalid Uid String: $s";

  static String validRoot(String root) {
    if (root.length > maxRootLength) throw new ArgumentError("root length > $maxRootLength");
    if ((checkString(root, kMin, kMax, kPred) == null))
      throw new ArgumentError('invalid UID root: $root');
    return root;
  }

  static bool isValid(String s) =>
      (checkString(s, kMin, kMax, kPred) == null) ? false : true;

  /*
  //TODO: need better validation - create a parser for UIDs in buffer.
  /// Returns [v] if it is either a valid [Uid] or a valid [Uid][String].
  static String validate(v) {
    if (v is Uid) v = v._string;
    if (v is! String) return null;
    if (checkString(v) == null) return null;
    return v;
  }
  */

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
  static String validate(String s) => (testString(s, kMin, kMax, kPred)) ? s: null;

  static final RegExp uidPattern = new RegExp(r"[012]((\.0)|(\.[1-9]\d*))+");

  //TODO: test for performance
  /*
  static String validateStringWithRegExp(String s) {
    print('Uid String: $s');
    if ((s.length < kMin) || (s.length > kMax)) return null;
    Match match = uidPattern.firstMatch(s);
    if (match != null) {
      // print('Uid: ${match.groups([0, 1, 2])}');
      print('match[0]: "${match.group(0)}"');
      return s;
    }
    return null;
  }
  */

  //TODO improve parser
  static Uid parse(String uidString) {
    // Remove leading & trailing spaces - defensive programming
    String s = uidString.trim();
    if (validate(s) == null) return null;
    WKUid uid = wellKnownUids[s];
    if (uid != null) return uid;
    return new UidString._(s);
  }
}
