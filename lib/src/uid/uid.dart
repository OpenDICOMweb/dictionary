// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.dictionary.uid;

import 'package:common/common.dart';
import 'package:dictionary/dictionary.dart';

import 'uid_type.dart';

part 'color_palettes.dart';
part 'sop_class.dart';
part 'transfer_syntax.dart';
part 'uid_string.dart';
part 'uuid.dart';
part 'wk_uid.dart';

//TODO: cleanup documentation

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// [Rec. ITU-T X.667 | ISO/IEC 9834-8](http://www.oid-info.com/get/2.25).
///
/// [Uid]s are immutable.  They can be created:
///   1. as compile time constants,
///   2. from Strings, or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///


/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// Rec. ITU-T X.667 | ISO/IEC 9834-8. See <http://www.oid-info.com/get/2.25>
///
/// [Uid]s are immutable.  They can be created [Uid]s:
///   1. as compile time constants,
///   2. from Strings, or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///
abstract class Uid {

  /// Returns a [Uid] how value is [String], if present and valid;
  /// otherwise, returns a random [Uid] created from a random [Uuid].
  ///
  /// Note: Random [Uid]s have a root of "2.25" as defined by the OID
  /// Standard (see http://www.oid-info.com/get/2.25).
  // Remove leading & trailing spaces - defensive programming
  //factory Uid([String s]) => (s != null) ? new UidString(s) : new UidUuid();

  /// Creates a constant [Uid].  Used to create 'Well Known' DICOM [Uid]s.
  const Uid._();

  factory Uid() => new UidUuid();
  @override
  bool operator ==(Object other) => (other is Uid) && (string == other.string);

  /// Returns the [Uid] [String].
  String get string;

  UidType get type;

  /// Returns the [Uid] [String].
  @deprecated
  String get value => string;

  @override
  int get hashCode => string.hashCode;

  /// Return true is this [Uid] identifies an encapsulated [Transfer Syntax].
  bool get isEncapsulated => false;

  /// Returns [true] if [this] is a [Uid] defined by the DICOM Standard.
  bool get isWellKnown => false;

  String get info => '$runtimeType: $string';

  /// Returns the [Uid] [String].
  @override
  String toString() => string;

  static String get random => Uuid.generator.string;

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.generator.string;
    return uList;
  }

  //TODO improve parser
  static Uid parse(String uidString) {
    // Remove leading & trailing spaces - defensive programming
    String s = uidString.trim();
    if (UidString.validate(s) == null) return null;
    WKUid uid = wellKnownUids[s];
    if (uid != null) return uid;
    return new UidString._(s);
  }
}
