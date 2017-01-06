// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/dicom/constants.dart';

bool _checkLength(String s, List<String> issues, int minLength, int maxLength) {
  if (s == null || s.length == 0) return null;
  if (s.length < minLength) {
    issues.add('Value has length(${s.length} less than the minimum($minLength)');
    return false;
  }
  if (s.length > maxLength) {
    issues.add('Value has length(${s.length} greater than the maximum($maxLength)');
    return false;
  }
  return true;
}

String _invalidChar(int c, int pos) => 'Value has invalid character($c) at position($pos)';

//TODO: this does not handle escape sequences
bool _checkDcmString(String s, List<String> issues, int maxLength) {
  if (! _checkLength(s, issues, 0, maxLength)) return false;
  for (int index = 0; index < maxLength; index++) {
    int c = s.codeUnitAt(index);
    if (c < kSpace || c == kBackslash || c == kDelete) issues.add(_invalidChar(c, index));
  }
  return true;
}

// DICOM Text Strings
//TODO: this does not handle escape sequences
bool _checkTextString(String s, List<String> issues, int maxLength) {
  if (! _checkLength(s, issues, 0, maxLength)) return false;
  for (int index = 0; index < s.length; index++) {
    int c = s.codeUnitAt(index);
    if (c < kSpace || c == kDelete) {
      issues.add( _invalidChar(c, index));
      return false;
    }
  }
  return true;
}

// DICOM VRs with Digits
bool _checkDigitString(String s, List<String> issues, int minLength, int maxLength,
                      [int sep]) {
  if (! _checkLength(s, issues, 0, maxLength)) return false;
  int index = 0;
  for(; index < maxLength; index++) {
    int c = s.codeUnitAt(index);
    if (c < k0 || c > k9 || (sep != null && c != sep)) {
      issues.add(_invalidChar(c, index));
      return false;
    }
  }
  if (index < minLength) {
    issues.add('The Value has fewer than the minimum($minLength) number of characters');
    return false;
  }
  return true;
}

// DICOM Strings
bool checkAEString(String s, List<String> issues) =>
    _checkDcmString(s, issues, 16);
bool checkCSString(String s, List<String> issues) =>
    _checkDcmString(s, issues, 16);
bool checkPNString(String s, List<String> issues) =>
    _checkDcmString(s, issues, 5 * 64);
bool checkSHString(String s, List<String> issues) =>
    _checkDcmString(s, issues, 16);
bool checkLOString(String s, List<String> issues) =>
    _checkDcmString(s, issues, 64);
bool checkUCString(String s, List<String> issues) =>
    _checkDcmString(s, issues, kMaxLongLengthInBytes);

// DICOM Texts
bool checkSTString(String s, List<String> issues) =>
    _checkTextString(s, issues, 1024);
bool checkLTString(String s, List<String> issues) =>
    _checkTextString(s, issues, 10240);
bool checkUTString(String s, List<String> issues) =>
    _checkTextString(s, issues, kMaxLongLengthInBytes);

// UID String
bool checkUIString(String s, List<String> issues) =>
    _checkDigitString(s, issues, 8, 64, kDot);

// UUID String
bool checkUuidString(String s, List<String> issues) =>
    _checkDigitString(s,issues, 36, 36, kDash);

/// AS - Age String
bool checkASString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 4, 4)) return false;
  if (! _checkDigitString(s, issues, 3, 3)) return false;
  if (!"DWMY".contains(s[3])) {
    issues.add('Invalid Age Unit($s[3]');
    return false;
  }
  return true;
}

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
bool checkISString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 4, 4)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (! _checkDigitString(s, issues, 0, 12 - hasSign, hasSign)) return false;
  return true;
}

/// DS -Decimal String
bool checkDSString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 0, 16)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (! _checkDigitString(s, issues, 0, 16 - hasSign, hasSign)) return false;
  return true;
}

/// DA - Date String
//_StringPredicate isDAString = _makeStringPredicate(8, 8, isDigitChar);
bool checkDAString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 8, 8)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    issues.add('Invalid Date($dt) - error at offset(${e.offset}');
    return false;
  }
  return true;
}


//TM - Time
//_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);
bool checkDTString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 4, 26)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    issues.add('Invalid DateTime($dt) - error at offset(${e.offset}');
    return false;
  }
  return true;
}

//TM - Time
//_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);
bool checkTMString(String s, List<String> issues) {
  if (! _checkLength(s, issues, 2, 14)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    issues.add('Invalid Time($dt) - error at offset(${e.offset}');
    return false;
  }
  return true;
}

//TODO: do something more efficient
//UR - Universal Resource Identifier (URI)
bool checkURString(String s, List<String> issues, [int index = 0, int end]) {
  Uri uri;
  end = (end == null) ? s.length - index : end;
  try {
    uri = Uri.parse(s, index, end);
  } on FormatException catch(e) {
    issues.add('Invalid URI($uri) - error at offset(${e.offset}');
    return false;
  }
  return true;
}

