// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/string/predicates.dart';
import 'package:dictionary/src/common/uid/uid_type.dart';
import 'package:dictionary/src/dicom/uid/wk_uids_map.dart';
import 'package:dictionary/uuid.dart';

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// [Rec. ITU-T X.667 | ISO/IEC 9834-8](http://www.oid-info.com/get/2.25).
///
/// [Uid]s are immutable.  They can be created [Uid]s:
///   1. as compile time constants,
///   2. from [Strings], or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///
abstract class UidBase {
  static const int maxLength = 64;

  const UidBase();

  @deprecated
  String get value;

  String get string;

  bool get isEncapsulated => false;

  bool get isWellKnown => false;

  UidType get type;

}

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// Rec. ITU-T X.667 | ISO/IEC 9834-8. See <http://www.oid-info.com/get/2.25>
///
/// [Uid]s are immutable.  They can be created [Uid]s:
///   1. as compile time constants,
///   2. from [Strings], or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///
class Uid extends UidBase {
  static const int kMin = 6;
  static const int kMax = 64;
  static const int maxRootLength = 24;
  static CharPredicate kPred = isUidChar;
  //TODO: this should be true by default.
  static bool checkWellKnown = true;
  final String _string;

  /// Returns a [Uid] how value is [String], if present and valid;
  /// otherwise, returns a random [Uid] created from a random [Uuid].
  ///
  /// Note: Random [Uid]s have a root of "2.25" as defined by the OID
  /// Standard (see http://www.oid-info.com/get/2.25).
  // Remove leading & trailing spaces - defensive programming
  Uid([String s]) : _string = (s == null) ? Uuid.randomUid : validate(s.trim());


  /// Creates a constant [Uid].  Used to create 'Well Known' DICOM [Uid]s.
  const Uid.constant(this._string);

  @override
  bool operator ==(Object other) => (other is Uid) && (_string == other.string);

  /// Returns the [Uid] [String].
  @deprecated
  @override
  String get value => _string;

  /// Returns the [Uid] [String].
  String get string => _string;

  UidType get type => UidType.kGenerated;

  @override
  int get hashCode => _string.hashCode;

  /// Return true is this [Uid] identifies an encapsulated [Transfer Syntax].
  bool get isEncapsulated => false;

  /// Returns [true] if [this] is a [Uid] defined by the DICOM Standard.
  bool get isWellKnown => false;

  String get info => 'Uid: $_string';

  /// Returns the [Uid] [String].
  @override
  String toString() => '$_string';


  static String validRoot(String root) {
    if (root.length > maxRootLength) throw new ArgumentError("root length > $maxRootLength");
    if ((checkString(root, kMin, kMax, kPred) == null))
      throw new ArgumentError('invalid UID root: $root');
    return root;
  }

  static bool isValid(uid) => (checkString(uid.s, kMin, kMax, kPred) == null) ? false : true;

  /*
  //TODO: need better validation - either use RegExp below or do it by hand.
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

  static Uid parse(String s) {
    // Remove leading & trailing spaces - defensive programming
    s = s.trim();
    if (validate(s) == null) return null;
    if (checkWellKnown) {
      Uid uid = wellKnownUids[s];
      if (uid != null) return uid;
    }
    return new Uid.constant(s);
  }

  static String get random => Uuid.randomUid;

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.randomUid;
    return uList;
  }
}
