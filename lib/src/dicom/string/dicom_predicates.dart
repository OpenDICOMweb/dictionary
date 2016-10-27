// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/common/string/predicates.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/string/char_predicates.dart';


//Fix0 finish the following procedures
ConstStringPredicate makeStringPredicate(int minLength, int maxLength, bool pred(int c)) {
  return (String s) {
    int len = s.length;
    if ((len >= minLength) && (len <= maxLength)) {
      for (int i = 0; i < len; i++) {
        if (!pred(s.codeUnitAt(i))) return false;
      }
    } else {
      return false;
    }
  };
}

//Fix: Add URIs to all public procedures below
/// (AE - Application Entity Title)<http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2>
ConstStringPredicate isAEString = makeConstStringPredicate(0, 16, isAEChar);

/// AS - Age String
bool isASString(String s) => (s.length == 4) && isDigit(s, 0, 2) && "DWMY".contains(s[3]);

/// CS - Code String
ConstStringPredicate isCSString = makeConstStringPredicate(0, 16, isCSChar);

/// DA - Date String
ConstStringPredicate isDAString = makeConstStringPredicate(8, 8, isDigitChar);

/// DS -Decimal String
ConstStringPredicate isDSString = makeConstStringPredicate(0, 16, isDSChar);

/// DT - Date Time String
ConstStringPredicate isDTString = makeConstStringPredicate(4, 26, isDTChar);

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
ConstStringPredicate isISString = makeConstStringPredicate(0, 12, isISChar);

/// LO - Long String (0008,0005)
ConstStringPredicate isLOString = makeConstStringPredicate(0, 64, isStringChar);

/// LT - Long Text (0008,0005)
ConstStringPredicate isLTString = makeConstStringPredicate(0, 10240, isTextChar);

/// PN - Person Name (0008,0005)
ConstStringPredicate isPNString = makeConstStringPredicate(0, 5 * 64, isStringChar);

/// SH - Short Text
ConstStringPredicate isSHString = makeConstStringPredicate(0, 16, isStringChar);

// ST -Short Text (0008,0005)
ConstStringPredicate isSTString = makeConstStringPredicate(0, 1024, isTextChar);

//TM - Time
ConstStringPredicate isTMString = makeConstStringPredicate(2, 14, isTMChar);

//UI - Unique Identifier (UID)
ConstStringPredicate isUIString = makeConstStringPredicate(8, 64, isUidChar);

//Fix: this needs to be implemented
//UR - Universal Resource Identifier (URI)
bool isURString(String s) => true;

//UC - Unlimited Characters 0008,0005)
ConstStringPredicate isUCString = makeConstStringPredicate(0, kMaxLongLengthInBytes, isStringChar);

//UT - Unlimited Text (0008,0005)
ConstStringPredicate isUTString = makeConstStringPredicate(0, kMaxLongLengthInBytes, isTextChar);

