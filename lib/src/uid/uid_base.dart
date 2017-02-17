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
part 'uid.dart';
part 'uuid.dart';
part 'well_known_frame_of_reference.dart';
part 'wk_uid.dart';

//TODO: cleanup documentation

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// [Rec. ITU-T X.667 | ISO/IEC 9834-8](http://www.oid-info.com/get/2.25).
///
/// [UidBase]s are immutable.  They can be created:
///   1. as compile time constants,
///   2. from Strings, or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///

/// A class that implements *DICOM Unique Identifiers* (UID) <*add link*>,
/// also known as OSI *Object Identifiers* (OID), in accordance with
/// Rec. ITU-T X.667 | ISO/IEC 9834-8. See <http://www.oid-info.com/get/2.25>
///
/// [UidBase]s are immutable.  They can be created [UidBase]s:
///   1. as compile time constants,
///   2. from Strings, or
///   3. generated from random [Uuid]s. See <http://www.oid-info.com/get/2.25>
///
abstract class UidBase {
  /// Returns a [UidBase] how value is [String], if present and valid;
  /// otherwise, returns a random [UidBase] created from a random [Uuid].
  ///
  /// Note: Random [UidBase]s have a root of "2.25" as defined by the OID
  /// Standard (see http://www.oid-info.com/get/2.25).
  // Remove leading & trailing spaces - defensive programming
  //factory Uid([String s]) => (s != null) ? new UidString(s) : new UidUuid();

  /// Creates a constant [UidBase].  Used to create 'Well Known' DICOM [UidBase]s.
  const UidBase._();

  factory UidBase() => new UidUuid();
  @override
  bool operator ==(Object other) => (other is UidBase) && (asString == other.asString);

  /// Returns the [Uid] [String].
  String get asString;

  UidType get type;

  /// Returns the [Uid] [String].
  @deprecated
  String get value => asString;

  @override
  int get hashCode => asString.hashCode;

  /// Return true is this [UidBase] identifies an encapsulated [Transfer Syntax].
  bool get isEncapsulated => false;

  /// Returns [true] if [this] is a [UidBase] defined by the DICOM Standard.
  bool get isWellKnown => false;

  String get info => '$runtimeType: $asString';

  /// Returns the [Uid] [String].
  @override
  String toString() => asString;

  static String get random => Uuid.generator.string;

  static List<String> randomList(int length) {
    List<String> uList = new List(length);
    for (int i = 0; i < length; i++) uList[i] = Uuid.generator.string;
    return uList;
  }

  //TODO improve parser
  static UidBase parse(String uidString) {
    // Remove leading & trailing spaces - defensive programming
    String s = uidString.trim();
    if (Uid.validate(s) == null) return null;
    WKUid uid = wellKnownUids[s];
    if (uid != null) return uid;
    return new Uid._(s);
  }
}
