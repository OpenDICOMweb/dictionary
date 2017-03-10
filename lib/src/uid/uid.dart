// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';

import 'uid_type.dart';
import 'uid_utils.dart' as util;

//TODO: document class
//TODO: test for performance

/// A UID constructed from a [String] or from a [root] and [leaf].  This
/// class is the super class for all Well Known UIDs.
abstract class Uid {
  static const int kMinLength = 6;
  static const int kMaxLength = 64;
  static const int maxRootLength = 24;
  static const String dicomRoot = "1.2.840.10008";

  factory Uid([String s]) => (s == null) ? random : parse(s);

  factory Uid.fromString(String s) => parse(s);

  factory Uid.withRoot(String root, String leaf) =>
      new UidString.withRoot(root, leaf);

  const Uid._();

  @override
  bool operator ==(Object other) =>
      (other is Uid) && (asString == other.asString);

  @override
  int get hashCode => asString.hashCode;

  /// Returns the [Uid] [String].
  String get asString;

  /// Returns the [UidType].
  UidType get type => UidType.kConstructed;

  /// Return true if this [UidBase] identifies an
  /// encapsulated [Transfer Syntax].
  bool get isEncapsulated => false;

  /// Returns [true] if [this] is a [UidBase] defined by the DICOM Standard.
  bool get isWellKnown => false;

  /// Returns a [String] containing a random UID as per the
  /// See Dart sdk/math/Random.
  static Uid get random => new UidRandom._(isSecure: false);

  /// Returns a [String] containing a _secure_ random UID.
  /// See Dart sdk/math/Random.
  static Uid get secure => new UidRandom._(isSecure: true);

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.generator.string;
    return uList;
  }

  /// Return a [String] that includes the [runtimeType].
  String get info => '$runtimeType: $asString';

  /// Returns the [Uid] [String].
  @override
  String toString() => asString;

  static WKUid lookup(dynamic uid) {
    var s;
    if (uid is Uid) s = uid.asString;
    if (uid is String) s = uid;
    return wellKnownUids[s];
  }

  static bool isValidString(String uidString) =>
      util.isValidUidString(uidString);

  // static bool _isValidLength(int length) =>
  //     kMinLength <= length && length <= kMaxLength;

  /// ASCII constants for '0', '1', and '2'. No other roots are valid.
  static const List<int> uidRoots = util.uidRoots;

  /// Returns [s] if it is a valid [Uid] [String]; otherwise, [null].
  static String check(String s) => isValidString(s) ? s : null;

  static String test(String s) =>
      isValidString(s) ? s : throw "Invalid Uid String: $s";

  /// Returns a [String] containing the name of the organization associated
  /// with the root.
  static String rootType(String uidString) => util.uidRootType(uidString);

  static final RegExp uidPattern = new RegExp(r"[012]((\.0)|(\.[1-9]\d*))+");

  static bool validateStrings(List<String> sList) {
    for (String s in sList) if (!isValidString(s)) return false;
    return true;
  }

  static Uid parse(String uidString) {
    // Remove leading & trailing spaces - defensive programming
    String s = uidString.trim();
    if (!isValidString(s)) return null;
    WKUid uid = wellKnownUids[s];
    return (uid != null) ? uid : new UidString(s);
  }
}

class UidString extends Uid {
  @override
  final String asString;

  factory UidString(String asString) {
    WKUid wk = (wellKnownUids[asString]);
    return (wk == null) ? new UidString._(asString) : wk;
  }

  factory UidString.withRoot(String root, String leaf) {
    var s = root + leaf;
    return new UidString(s);
  }

  UidString._(this.asString) : super._();

  const UidString.wellKnown(this.asString) : super._();
}

class UidRandom extends Uid {
  /// The UID Root for UIDs created from random (V4) UUIDs.
  static const String uidRoot = "2.25.";
  final Uuid uuid;

  UidRandom._({bool isSecure = false})
      : uuid = new Uuid(isSecure: isSecure),
        super._();

  @override
  String get asString => uidRoot + uuid.toString();

  @override
  UidType get type => UidType.kUidRandom;

  @override
  String toString() => asString;
}

const Map<String, String> oidRoots = const <String, String>{
  "1.2.840": "United States of America",
  "1.16.840": "United States of America",
  "1.2.840.": "United States of America",
  '1.2.840.10008': "DICOM Standard",
  "1.3.6.1": "Internet",
  "1.3.6.1.4.1": "IANA assigned company OIDs",
  "2.25": "itu-iso UUID"
};
