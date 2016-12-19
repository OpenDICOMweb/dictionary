// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/uid/wk_uid.dart';
import 'package:dictionary/src/dicom/uid/wk_uid_type.dart';

//TODO: fix this class

class SopClassUid extends WKUid {
  static const String classLink = 'TODO link';

  const SopClassUid(String uid, WKUidType type, bool isRetired, String name, String link)
      : super(uid, type, isRetired, name);

  //TODO: create UidType class
  bool get isSopClass => true;

  String toString() => '$runtimeType($string)';

  //TODO: make the return type SopClassUid a subtype of WKUid
  static WKUid lookup(v) {
    WKUid wk = WKUid.lookup(v);
    return ((wk != null) && (wk.type == WKUidType.kSopClass)) ? wk : null;
  }

  static const kVerificationSOPClass = const SopClassUid(
      "1.2.840.10008.1.1", WKUidType.kSopClass, false, "Verification SOP Class", "PS3.4");

}
