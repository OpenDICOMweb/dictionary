// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dcm_predicates.dart';
import 'package:dictionary/src/uuid_v4.dart';

import 'uid_type.dart';
import 'wk_uids_map.dart';

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

  String get value;

  bool get isEncapsulated => false;

  bool get isWellKnown => false;

  UidType get type => UidType.kUnknown;
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
  static bool checkWellKnown = false;
  static const _type = UidType.kGenerated;

  final String _value;

  UidType get type => _type;

  /// Returns a [Uid] how value is [String], if present and valid;
  /// otherwise, returns a random [Uid] created from a random [Uuid].
  ///
  /// Note: Random [Uid]s have a root of "2.25" as defined by the OID
  /// Standard (see http://www.oid-info.com/get/2.25).
  Uid([String s]) : _value = (s == null) ? Uuid.randomUid : _validator(s);

  /// Creates a constant [Uid].  Used to create 'Well Known' DICOM [Uid]s.
  const Uid.constant(this._value);

  @override
  bool operator ==(Object other) => (other is Uid) && (_value == other.value);

  @override
  int get hashCode => _value.hashCode;

  /// Return true is this [Uid] identifies an encapsulated [Transfer Syntax].
  bool get isEncapsulated => false;

  /// Returns [true] if [this] is a [Uid] defined by the DICOM Standard.
  bool get isWellKnown => false;

  /// Returns the [Uid] [String].
  @override
  String get value => _value;

  /// Returns the [Uid] [String].
  @override
  String toString() => '$_value';

  static String checkRoot(String root) {
    if (root.length > maxRootLength) throw new ArgumentError("root length > $maxRootLength");
    if ((validateString(root, kMin, kMax, kPred) == null))
      throw new ArgumentError('invalid UID root: $root');
    return root;
  }

  static bool isValid(Uid uid) => (validate(uid) == null) ? false : true;

  static Uid validate(Uid uid) => (_validator(uid._value) == null) ? null : uid;

  static final RegExp uidPattern = new RegExp(r"[012]((\.0)|(\.[1-9]\d*))+");

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

  static Uid parse(String s) {
    if (_validator(s) == null) return null;
    if (checkWellKnown) {
      Uid wellKnownUid = wellKnownUids[s];
      if (wellKnownUid != null) return wellKnownUid;
    }
    return new Uid.constant(s);
  }

  static String _validator(String s) => validateString(s, kMin, kMax, kPred);

  static String get random => Uuid.randomUid;

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.randomUid;
    return uList;
  }
}
