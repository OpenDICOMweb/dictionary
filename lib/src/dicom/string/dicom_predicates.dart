// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/dicom/constants.dart';

/// Naming
///   bool isSomething(x)
///   bool inRange(T v, T min, T max)
///   T checkSomething(T x, {onError: (T x) => T) - returns x or throws if invalid.
///   List<String> testSomething(T x) - returns a list of errors or null
///   X parse(String s, {onError = f}
///
///
bool _isValidLength(String s, int min, int max) {
  if (s == null || s.length == 0) return null;
  return _intInRange(s.length, min, max);
}

bool _checkStringLength(String s, int min, int max) {
  if (s == null || s.length == 0) return null;
  return _intInRange(s.length, min, max);
}

bool _intInRange(int v, int min, int max) => (v < min || v > max) ? false : true;

int _checkRange(int v, int min, int max) {
  if (v < min || v > max) throw 'RangeError: min($min) <= Value($v) <= max($max)';
  return v;
}

String _invalidChar(int c, int pos) => 'Value has invalid character($c) at position($pos)';

//TODO: this does not handle escape sequences
bool _isFilteredString(String s, int min, int max, bool filter(int c)) {
  if (!_isValidLength(s, min, max)) return false;
  for (int index = 0; index < max; index++) {
    int c = s.codeUnitAt(index);
    if (filter(c)) throw _invalidChar(c, index);
  }
  return true;
}

//bool _checkFilteredString()

/*
//TODO: this does not handle escape sequences
bool _checkDcmString(String s, int maxLength) {
  if (!_checkStringLength(s, 0, maxLength)) return false;
  for (int index = 0; index < maxLength; index++) {
    int c = s.codeUnitAt(index);
    if (c < kSpace || c == kBackslash || c == kDelete) throw _invalidChar(c, index);
  }
  return true;
}
*/
bool _dcmStringFilter(int c) => !(c < kSpace || c == kBackslash || c == kDelete);

bool _isDcmString(String s, int max) => _isFilteredString(s, 0, max, _dcmStringFilter);

String checkDcmString(String s, int max) => (_isDcmString(s, max)) ? s : null;

// DICOM Text Strings
//TODO: this does not handle escape sequences
/*
bool _checkTextString(String s, int maxLength) {
  if (!_checkStringLength(s, 0, maxLength)) return false;
  for (int index = 0; index < s.length; index++) {
    int c = s.codeUnitAt(index);
    if (c < kSpace || c == kDelete) {
      throw _invalidChar(c, index);
    }
  }
  return true;
}
*/
bool _textFilter(int c) => !(c < kSpace || c == kDelete);

bool _isTextString(String s, int max) => _isFilteredString(s, 0, max, _textFilter);

String _checkTextString(String s, int max) => (_isTextString(s, max)) ? s : null;
bool _digitFilter(int c) => c >= k0 && c <= k9;
bool _hexFilter(int c) => (c >= k0 && c <= k9) || (c >= ka && c <= kf) || (c >= kA && c <= kF);
// DICOM VRs with Digits
bool _checkDigitString(String s, int minLength, int maxLength, [int sep]) {
  if (!_isValidLength(s, 0, maxLength)) return false;
  int index = 0;
  for (; index < maxLength; index++) {
    int c = s.codeUnitAt(index);
    if (c < k0 || c > k9 || (sep != null && c != sep)) {
      throw _invalidChar(c, index);
      // return false;
    }
  }
  if (index < minLength) {
    throw 'The Value has fewer than the minimum($minLength) number of characters';
    // return false;
  }
  return true;
}

// DICOM Strings
bool isAEString(String s) => _isDcmString(s, 16);
bool isCSString(String s) => _isDcmString(s, 16);
bool isPNString(String s) => _isDcmString(s, 5 * 64);
bool isSHString(String s) => _isDcmString(s, 16);
bool isLOString(String s) => _isDcmString(s, 64);
bool isUCString(String s) => _isDcmString(s, kMaxLongLengthInBytes);

// DICOM Texts
bool isSTString(String s) => _isTextString(s, 1024);
bool isLTString(String s) => _isTextString(s, 10240);
bool isUTString(String s) => _isTextString(s, kMaxLongLengthInBytes);

// UID String
bool isUIString(String s) => _checkDigitString(s, 8, 64, kDot);

// UUID String
bool isUuidString(String s) => _checkDigitString(s, 36, 36, kDash);

/// AS - Age String
bool isASString(String s) {
  if (!_isValidLength(s, 4, 4)) return false;
  if (!_checkDigitString(s, 3, 3)) return false;
  if (!"DWMY".contains(s[3])) {
    throw 'Invalid Age Unit($s[3]';
    //return false;
  }
  return true;
}

String ASError(String s) {
  if (!_isValidLength(s, 4, 4)) if (!_checkDigitString(s, 3, 3))
    return 'Non-digits in age(AS) String: $s';
  if (!"DWMY".contains(s[3])) 'Invalid Age Unit($s[3]';
  return "";
}

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
bool isISString(String s) {
  if (!_isValidLength(s, 4, 4)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (!_checkDigitString(s, 0, 12 - hasSign, hasSign)) return false;
  return true;
}

/// DS -Decimal String
bool isDSString(String s) {
  if (!_isValidLength(s, 0, 16)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (!_checkDigitString(s, 0, 16 - hasSign, hasSign)) return false;
  return true;
}

/// DA - Date String
//_StringPredicate isDAString = _makeStringPredicate(8, 8, isDigitChar);
bool isDAString(String s) {
  if (!_isValidLength(s, 8, 8)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    throw 'Invalid Date($dt) - error at offset(${e.offset}';
    //return false;
  }
  return true;
}

//TM - Time
//_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);
bool isDTString(String s) {
  if (!_isValidLength(s, 4, 26)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    throw 'Invalid DateTime($dt) - error at offset(${e.offset}';
    //return false;
  }
  return true;
}

//TM - Time
//_StringPredicate isTMString = _makeStringPredicate(2, 14, isTMChar);
bool isTMString(String s) {
  if (!_isValidLength(s, 2, 14)) return false;
  DateTime dt;
  try {
    dt = DateTime.parse(s);
  } on FormatException catch (e) {
    throw 'Invalid Time($dt) - error at offset(${e.offset}';
    //return false;
  }
  return true;
}

//TODO: do something more efficient
//UR - Universal Resource Identifier (URI)
bool isURString(String s, [int index = 0, int end]) {
  Uri uri;
  end = (end == null) ? s.length - index : end;
  try {
    uri = Uri.parse(s, index, end);
  } on FormatException catch (e) {
    throw 'Invalid URI($uri) - error at offset(${e.offset}';
    //return false;
  }
  return true;
}
