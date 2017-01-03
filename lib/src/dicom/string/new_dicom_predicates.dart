// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/common/string/predicates.dart';
import 'package:dictionary/src/dicom/constants.dart';
import 'package:dictionary/src/dicom/string/char_predicates.dart';

String _checkLength(String s, int minLength, int maxLength) {
  if (s == null || s.length == 0) return null;
  if (s.length < minLength)
    return 'Value has length(${s.length} less than the minimum($minLength)';
  if (s.length > maxLength)
    return 'Value has length(${s.length} greater than the maximum($maxLength)';
  return null;
}

String _invalidChar(int c, int pos) => 'Value has invalid character($c) at position($pos)';

//TODO: this does not handle escape sequences
String checkDcmString(String s, int maxLength) {
  var msg = _checkLength(s, 0, maxLength);
  if (msg != null) return msg;
  for (int i = 0; i < s.length; i++) {
    int c = s.codeUnitAt(i);
    if (c < kSpace || c == kBackslash || c == kDelete) return _invalidChar(c, i);
  }
  return null;
}

/// (AE - Application Entity Title)<http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2>
String checkAEString(String s) => checkDcmString(s, 16);
String checkPNString(String s) => checkDcmString(s, 5 * 64);
String checkSHString(String s) => checkDcmString(s, 16);
String checkLOString(String s) => checkDcmString(s, 64);
String checkUCString(String s) => checkDcmString(s, kMaxLongLengthInBytes);

// DICOM Text Strings
//TODO: thcheck does not handle escape sequences
String checkTextString(String s, int maxLength) {
  var msg = _checkLength(s, 0, maxLength);
  if (msg != null) return msg;
  for (int i = 0; i < s.length; i++) {
    int c = s.codeUnitAt(i);
    if (c < kSpace || c == kDelete) return _invalidChar(c, i);
  }
  return null;
}

String checkSTString(String s) => checkTextString(s, 1024);
String checkLTString(String s) => checkTextString(s, 10240);
String checkUTString(String s) => checkTextString(s, kMaxLongLengthInBytes);

// DICOM VRs with Digits
String checkDigitString(String s, int minLength, int maxLength, [int sep]) {
  var msg = _checkLength(s, 0, maxLength);
  if (msg != null) return msg;
  for(int i = 0; i < maxLength; i++) {
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9 || (sep != null && c != sep)) return _invalidChar(c, i);
  }
  return null;
}

String checkUidString(String s) => checkDigitString(s, 64, kDot);
String checkUuidString(String s) => checkDigitString(s, 64, kDash);

/// AS - Age String
String checkASString(String s) {
  var msg = _checkLength(s, 4, 4);
  if (msg != null) return msg;
  msg = checkDigitString(s, 3, 3);
  if (msg != null) return msg;
  if (!"DWMY".contains(s[3])) return 'Invalid Age Unit($s[3]';
  return null;
}

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
String checkISString(String s) {
  var msg = _checkLength(s, 0, 12);
  if (msg != null) return msg;
  int c = s.codeUnitAt(0);
  int i = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  msg = checkDigitString(s, i, 12);
  if (msg != null) return msg;
  return null;
}

/// DS -Decimal String
String checkDSString(String s) {
  var msg = _checkLength(s, 0, 16);
  if (msg != null) return msg;
  int c = s.codeUnitAt(0);
  int i = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  msg = checkDigitString(s, i, 16);
  if (msg != null) return msg;
  return null;
}

/// DA - Date String
//_StringPredicate isDAString = _makeStringPredicate(8, 8, isDigitChar);
String checkDAString(String s) {
  var msg = _checkLength(s, 8, 8);
  if (msg != null) return msg;
  msg = checkDigitString(s, 8, 8);
  if (msg != null) return msg;
  return null;
}

/// DT - Date Time String
_StringPredicate checkDTString = _makeStringPredicate(4, 26, isDTChar);

//TM - Time
_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);
String checkTMString(String s) {
  var msg = _checkLength(s, 2, 14);
  if (msg != null) return msg;
  msg = checkDigitString(s, 2, 14, kDot);
  if (msg != null) return msg;
  return null;
}

//Fix: this needs to be implemented
//UR - Universal Resource Identifier (URI)
bool checkURString(String s) => true;

bool isDscString(String s, int max) {
  bool test(int c) => isUppercaseChar(c) || isDigitChar(c) || (c == kSpace) || (c == kUnderscore);
  if (s.length <= 16) {
    for (int i = 0; i < s.length; i++) {
      if (!test(s.codeUnitAt(i))) return false;
    }
    return true;
  }
  return false;
}