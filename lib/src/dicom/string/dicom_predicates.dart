// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/common/string/predicates.dart';
import 'package:dictionary/src/dicom/string/dcm_predicates.dart';

// TODO: Move to DICOM constants
const int kMaxLongLength = (2 ^ 32) - 2;

typedef bool StringVRPredicate(String s);
typedef bool VRStringTester(int maxLength, bool pred(int c));

//Fix0 finish the following procedures
StringVRPredicate makeVRStringTester(int minLength, int maxLength, bool pred(int c)) {
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
StringVRPredicate isAEString = makeVRStringTester(0, 16, isAEChar);

/// AS - Age String
bool isASString(String s) => (s.length == 4) && isDigit(s, 0, 2) && "DWMY".contains(s[3]);

/// CS - Code String
StringVRPredicate isCSString = makeVRStringTester(0, 16, isCSChar);

/// DA - Date String
StringVRPredicate isDAString = makeVRStringTester(8, 8, isDigitChar);

/// DS -Decimal String
StringVRPredicate isDSString = makeVRStringTester(0, 16, isDSChar);

/// DT - Date Time String
StringVRPredicate isDTString = makeVRStringTester(4, 26, isDTChar);

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
StringVRPredicate isISString = makeVRStringTester(0, 12, isISChar);

/// LO - Long String (0008,0005)
StringVRPredicate isLOString = makeVRStringTester(0, 64, isStringChar);

/// LT - Long Text (0008,0005)
StringVRPredicate isLTString = makeVRStringTester(0, 10240, isTextChar);

/// PN - Person Name (0008,0005)
StringVRPredicate isPNString = makeVRStringTester(0, 5 * 64, isStringChar);

/// SH - Short Text
StringVRPredicate isSHString = makeVRStringTester(0, 16, isStringChar);

// ST -Short Text (0008,0005)
StringVRPredicate isSTString = makeVRStringTester(0, 1024, isTextChar);

//TM - Time
StringVRPredicate isTMString = makeVRStringTester(2, 14, isTMChar);

//UI - Unique Identifier (UID)
StringVRPredicate isUIString = makeVRStringTester(8, 64, isUidChar);

//Fix: this needs to be implemented
//UR - Universal Resource Identifier (URI)
bool isURString(String s) => true;

//UC - Unlimited Characters 0008,0005)
StringVRPredicate isUCString = makeVRStringTester(0, kMaxLongLength, isStringChar);

//UT - Unlimited Text (0008,0005)
StringVRPredicate isUTString = makeVRStringTester(0, kMaxLongLength, isTextChar);

