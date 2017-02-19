// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

//TODO: replace this with sop_class_new.dart when that is complete and unit tested.

class SopClassUid extends WKUid {
  static const String classLink = 'TODO link';

  const SopClassUid(
      String uid, UidType type, bool isRetired, String name, String link)
      : super._(uid, type, isRetired, name);

  //TODO: create UidType class
  bool get isSopClass => true;

  @override
  String toString() => '$runtimeType($asString)';

  //TODO: make the return type SopClassUid a subtype of WKUid
  static WKUid lookup(String v) {
    WKUid wk = WKUid.lookup(v);
    return ((wk != null) && (wk.type == UidType.kSOPClass)) ? wk : null;
  }

  static const SopClassUid kVerificationSOPClass = const SopClassUid(
      "1.2.840.10008.1.1",
      UidType.kSOPClass,
      false,
      "Verification SOP Class",
      "PS3.4");
}
