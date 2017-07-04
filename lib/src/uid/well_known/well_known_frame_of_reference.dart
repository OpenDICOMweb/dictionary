// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/uid/uid_type.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';

//TODO: Move all definitions from PS3.6 Table A-2 Well Known Frames of Reference

class WellKnownFrameOfReference extends WKUid {
  const WellKnownFrameOfReference(
      String uid, UidType type, bool isRetired, String name, String link)
      : super(uid, type, isRetired, name);

  @override
  String toString() => '$runtimeType($asString)';

  // Add all constant WK Frame of Reference definitions from wk_uid.dart
  static const WellKnownFrameOfReference kTal = const WellKnownFrameOfReference(
      "1.2.840.",
      UidType.kWellKnownFrameOfReference,
      false,
      "Verification SOP Class",
      "PS3.4");

  //TODO: Modify to use [members] below
  static WKUid lookup(String v) {
    WKUid wk = WKUid.lookup(v);
    return ((wk != null) && (wk.type == UidType.kSOPClass)) ? wk : null;
  }

  //TODO: add all members to this map
  static const Map<String, WellKnownFrameOfReference> members = const {};
}
