// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

//TODO: Move all definitions from

class WellKnownFrameOfReference extends WKUid {
  const WellKnownFrameOfReference(
      String uid, UidType type, bool isRetired, String name, String link)
      : super._(uid, type, isRetired, name);

  String toString() => '$runtimeType($asString)';

  // Add all constant WK Frame of Reference definitions from wk_uid.dart
  static const kVerificationSOPClass = const SopClassUid(
      "1.2.840.10008.1.1", UidType.kSOPClass, false, "Verification SOP Class", "PS3.4");

  //TODO: Modify to use [members] below
  static WKUid lookup(v) {
    WKUid wk = WKUid.lookup(v);
    return ((wk != null) && (wk.type == UidType.kSOPClass)) ? wk : null;
  }

  //TODO: add all members to this map
  static const Map<String, WellKnownFrameOfReference> members =
      const <String, WellKnownFrameOfReference>{
    "1.2.840.10008.1.1": kVerificationSOPClass
  };
}
