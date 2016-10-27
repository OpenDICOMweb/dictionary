// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/uid/uid_type.dart';
import 'package:dictionary/src/dicom/uid/wk_uid.dart';


//TODO: fix this class

class SopClassUid extends WKUid {
  static const String classLink = 'TODO link';

  const SopClassUid(String uid, UidType type, bool isRetired, String name, String link)
      : super(uid, type, isRetired, name, link);

  //TODO: create UidType class
  bool get isSopClass => true;

  //TODO: Make this print SOP Class
  String toString() => '$runtimeType($value)';

  static SopClassUid lookup(v) {
    WKUid wk = WKUid.lookup(v);
    return ((wk != null) && (wk.type == UidType.kSopClass)) ? wk : null;
  }

  static const kVerificationSOPClass = const SopClassUid(
      "1.2.840.10008.1.1", UidType.kSopClass, false, "Verification SOP Class", "PS3.4");

//TODO: finish adding classes
}
