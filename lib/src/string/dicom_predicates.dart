// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:common/common.dart';
import 'package:dictionary/src/constants.dart';

//TODO: cleanup and remove unnecessary functions

/// DICOM Character Set Predicates

/// *Specific Character Set*
///
/// The VRs LO, LT, SH, ST, PN, UC and UT may have their character set modified by the
/// Attribute Specific Character Set (0008,0005) Tag.
///
/// *Backslash as Value Field Separator*
///
/// The _backslash_ '\' [$backslash] ($reverseSolidus)] character is used as a Value Field (VF)
/// separator for all [String] based VRs, except  LT, ST, UR, and UT.

/// Private validator for ISO IR-6 (Ascii) [String]s that do NOT use _backslash_ '/'
/// as a Value Field separator.
///
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR) without backspace (/);
/// otherwise [false].
/// Note: NB stands for 'No Backspace'.
bool _isDcrChar(int c) => ((c >= kSpace) && (c < kDelete));

/// Private validator for ISO IR-6 (Ascii) [String]s that use _backslash_ '/' as a VF separator.
///
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR) without backspace (/);
/// otherwise [false].
/// Note: NB stands for 'No Backslash'.
bool _isDcrNBChar(int c) =>
    ((c >= kSpace) && (c < kBackslash)) || ((c > kBackslash) && (c < kDelete));

/// Private validator used for VRs of LT, ST, UR, and UT, that is VRs include _backslash_ as a legal
/// character, and also allow the specific character Set (0008,0005) to be used to modify the contents
/// of the VF.  VFs that use this validator can only have one value.
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR); otherwise [false].
/// Note: SCS stands for .Specific Character Set'.
bool _isDcrCharSCS(int c, [bool isEscapeAllowed = false]) =>
    _isDcrChar(c) || (isEscapeAllowed && c == kEscape);

///  Used for VRs of LO, PN, SH, and UC.
///
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR) without backspace (/);
/// otherwise [false].
bool _isDcrNBCharSCS(int c, [bool isEscapeAllowed = false]) =>
    _isDcrNBChar(c) || (isEscapeAllowed && c == kEscape);

/// The four legal DICOM control characters.
/// Returns [true] if [c] is a DICOM Control character; otherwise [false].
bool _isDcmCtrlChar(int c) =>
    (c == kLinefeed) || (c == kCr) || (c == kHTab) || (c == kFormfeed);

// Public Predicates

// DICOM Strings and Texts
///Returns [true] if [c] is legal in a DICOM string VR (SH or LO) ; otherwise, [false].
CharPredicate isDcmStringChar = _isDcrNBCharSCS;

///Returns [true] if [c] is legal in a DICOM text VR (ST, LT, UC, or UT) ; otherwise, [false].
bool isDcmTextChar(int c) => _isDcrCharSCS(c) || _isDcmCtrlChar(c);

// Private Predicates

/// *Specific Character Set*
///
/// The VRs LO, LT, SH, ST, PN, UC and UT may have their character set modified by the
/// Attribute Specific Character Set (0008,0005) Tag.
///
/// *Backslash as Value Field Separator*
///
/// The _backslash_ '\' [$backslash] ($reverseSolidus)] character is used as a Value Field (VF)
/// separator for all [String] based VRs, except  LT, ST, UR, and UT.

///  Validator for DCR.  It includes all printable Ascii characters.
bool isDcrChar(int c) => ((c >= kSpace) && (c < kDelete));

/// Validator for ISO IR-6 (Ascii) [String]s that use _backslash_ '/' as a VF separator.
///
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR) without backspace (/);
/// otherwise [false].  Note: NB stands for 'No Backspace'.
bool isNBDcrNBChar(int c) =>
    ((c >= kSpace) && (c < kBackslash)) || ((c > kBackslash) && (c < kDelete));

/// Validator used for VRs of LT, ST, UR, and UT, that is VRs include _backslash_ as a legal
/// character, and also allow the specific character Set (0008,0005) to be used to modify the contents
/// of the VF.  VFs that use this validator can only have one value.
/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR); otherwise [false].
/// Note: SCS stands for .Specific Character Set'.
bool isReplaceableDcrChar(int c, [bool isEscapeAllowed = false]) =>
    isDcrChar(c) || (isEscapeAllowed && c == kEscape);

/// Returns [true] if [c] is in DICOM's Default Character Repertoire (DCR)
/// without backspace (/); otherwise [false].  VRs using this predicate
/// can have the DCR replaced with a Specific Character Set.
/// This predicate is used for VRs of LO, PN, SH, and UC.
bool isReplaceableNBDcrChar(int c, [bool isEscapeAllowed = false]) =>
    isNBDcrNBChar(c) || (isEscapeAllowed && c == kEscape);

/*
/// Returns [true] if [c] is a DICOM Control character; otherwise [false].
bool isControlChar(int c) => (c == kLinefeed) || (c == kReturn) || (c == kHTab) || (c == kFormfeed);

/// Returns [true] if [c] is a DICOM Control character; otherwise [false].
bool _isUppercase(int c) => (c >= kA) && (c <= kZ);

/// Returns [true] if [c] is a DICOM whitespace character; otherwise [false].
bool isWhiteSpaceChar(int c) => (c == kSpace) || (c == kHTab);
*/
///Returns [true] if [c] is legal in a DICOM string VR (SH, LO, UC) ; otherwise, [false].
CharPredicate isStringChar = isReplaceableNBDcrChar;

///Returns [true] if [c] is legal in a DICOM text VR (ST, LT, or UT) ; otherwise, [false].
bool isTextChar(int c) => isReplaceableDcrChar(c) || isControlChar(c);

/// Returns [true] if [c] is legal in an AE Title; otherwise, [false],
CharPredicate isAEChar = isNBDcrNBChar;

/// Returns [true] if [c] is legal in Code String; otherwise, [false],
bool isCSChar(int c) =>
    isUppercaseChar(c) || isDigitChar(c) || (c == kSpace) || (c == kUnderscore);

///Returns [true] if [c] is legal in a DICOM Date VR (DA) ; otherwise, [false].
CharPredicate isDAChar = isDigitChar;

///Returns [true] if [c] is legal in a DICOM Date VR (DA) ; otherwise, [false].
bool isDSChar(int c) =>
    isDigitChar(c) || isSignChar(c) || isDotChar(c) || isExponentChar(c);

///Returns [true] if [c] is legal in a DICOM DateTime VR (DT) ; otherwise, [false].
bool isDTChar(int c) => isTMChar(c) || isSignChar(c);

///Returns [true] if [c] is legal in a DICOM Integer VR (IS) ; otherwise, [false].
bool isISChar(int c) => isDigitChar(c) || isSignChar(c);

///Returns [true] if [c] is legal in a DICOM Person Name VR (PN) ; otherwise, [false].
const CharPredicate isPNChar = isReplaceableNBDcrChar;

///Returns [true] if [c] is legal in a DICOM Time VR (TM) ; otherwise, [false].
bool isTMChar(int c) => isDigitChar(c) || (c == kDot);

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
  return Int.inRange(s.length, min, max);
}

String _invalidChar(int c, int pos) =>
    'Value has invalid character($c) at position($pos)';

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

// DICOM Strings
bool isAEString(String s) => _isDcmString(s, 16);
bool isCSString(String s) => _isDcmString(s, 16);
bool isPNString(String s) => _isDcmString(s, 5 * 64);
bool isSHString(String s) => _isDcmString(s, 16);
bool isLOString(String s) => _isDcmString(s, 64);
bool isUCString(String s) => _isDcmString(s, kMaxLongVFLength);

// DICOM Texts
bool isSTString(String s) => _isTextString(s, 1024);
bool isLTString(String s) => _isTextString(s, 10240);
bool isUTString(String s) => _isTextString(s, kMaxLongVFLength);

// UID String
bool isUIString(String s) => _isDigitString(s, 8, 64, kDot);

// UUID String
bool isUuidString(String s) => _isDigitString(s, 36, 36, kDash);

/// AS - Age String
bool isASString(String s) {
  if (!_isValidLength(s, 4, 4)) return false;
  if (!_isDigitString(s, 3, 3)) return false;
  if (!"DWMY".contains(s[3])) {
    throw 'Invalid Age Unit($s[3]';
    //return false;
  }
  return true;
}

String ASError(String s) {
  if (!_isValidLength(s, 4, 4)) if (!_isDigitString(s, 3, 3))
    return 'Non-digits in age(AS) String: $s';
  if (!"DWMY".contains(s[3])) 'Invalid Age Unit($s[3]';
  return "";
}

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)
bool isISString(String s) {
  if (!_isValidLength(s, 4, 4)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (!_isDigitString(s, 0, 12 - hasSign, hasSign)) return false;
  return true;
}

/// DS -Decimal String
bool isDSString(String s) {
  if (!_isValidLength(s, 0, 16)) return false;
  int c = s.codeUnitAt(0);
  int hasSign = (c == kMinusSign || c == kPlusSign) ? 1 : 0;
  if (!_isDigitString(s, 0, 16 - hasSign, hasSign)) return false;
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

// DICOM VRs with Digits
bool _isDigitString(String s, int minLength, int maxLength, [int sep]) {
  if (!_isValidLength(s, 0, maxLength)) return false;
  int index = 0;
  for (; index < maxLength; index++) {
    int c = s.codeUnitAt(index);
    if (c < k0 || c > k9 || (sep != null && c != sep)) return false;
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

/* TODO: move elsewhere or flush
bool _digitFilter(int c) => c >= k0 && c <= k9;
bool _hexFilter(int c) => (c >= k0 && c <= k9) || (c >= ka && c <= kf) || (c >= kA && c <= kF);


*/
