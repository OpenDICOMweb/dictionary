// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/common/string/predicates.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/string/char_predicates.dart';

typedef bool _StringPredicate(String s);
//Fix0 finish the following procedures
_StringPredicate _makeStringPredicate(int minLength, int maxLength, bool pred(int c)) {
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
const _StringPredicate isAEString = _makeStringPredicate(0, 16, isAEChar);

/// AS - Age String
bool isASString(String s) => (s.length == 4) && isDigit(s, 0, 2) && "DWMY".contains(s[3]);

/// CS - Code String
_StringPredicate isCSString = _makeStringPredicate(0, 16, isCSChar);

/// DA - Date String
_StringPredicate isDAString = _makeStringPredicate(8, 8, isDigitChar);

/// DS -Decimal String
_StringPredicate isDSString = _makeStringPredicate(0, 16, isDSChar);

/// DT - Date Time String
_StringPredicate isDTString = _makeStringPredicate(4, 26, isDTChar);

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
_StringPredicate isISString = _makeStringPredicate(0, 12, isISChar);

/// LO - Long String (0008,0005)
_StringPredicate isLOString = _makeStringPredicate(0, 64, isStringChar);

/// LT - Long Text (0008,0005)
_StringPredicate isLTString = _makeStringPredicate(0, 10240, isTextChar);

/// PN - Person Name (0008,0005)
_StringPredicate isPNString = _makeStringPredicate(0, 5 * 64, isStringChar);

/// SH - Short Text
_StringPredicate isSHString = _makeStringPredicate(0, 16, isStringChar);

// ST -Short Text (0008,0005)
_StringPredicate isSTString = _makeStringPredicate(0, 1024, isTextChar);

//TM - Time
_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);

//UI - Unique Identifier (UID)
_StringPredicate isUIString = _makeStringPredicate(8, 64, isUidChar);

//Fix: this needs to be implemented
//UR - Universal Resource Identifier (URI)
bool isURString(String s) => true;

//UC - Unlimited Characters 0008,0005)
_StringPredicate isUCString = _makeStringPredicate(0, kMaxLongLengthInBytes, isStringChar);

//UT - Unlimited Text (0008,0005)
_StringPredicate isUTString = _makeStringPredicate(0, kMaxLongLengthInBytes, isTextChar);

