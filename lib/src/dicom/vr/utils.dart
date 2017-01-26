// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

String _defaultParser(String s) => s;


/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)

int _parseIS(String s) {
  if (_isNotValidLength(s, 0, 12)) return null;
  return int.parse(s, onError: (String s) => null);
}

bool _isISString(String s) => (_parseIS(s) == null) ? false : true;

String _getISErrors(String s) =>
    (_isISString(s)) ? "" : 'Invalid Integer(IS) String: $s';

/// DS -Decimal String

num _parseDS(String s) {
  if (!_isValidLength(s, 0, 16)) return null;
  return num.parse(s, (String s) => null);
}

bool _isDSString(String s) => (_parseDS(s) == null) ? false : true;

String _getDSErrors(String s) =>
    (_isDSString(s)) ? "" : 'Invalid Decimal(DS) String: $s';

// *** DICOM DCR Strings - no Backslashes.

bool _isDcmChar(int c) => !(c < kSpace || c == kBackslash || c == kDelete);
String _parseDcmString(String s) => _filteredParse(s, _isDcmChar);
String _getDcmErrors(String s) => _getFilteredError(s, _isDcmChar);
bool _isDcmString(String s, int max) =>
    (_parseDcmString(s) == null) ? false : true;


// *** Text Strings

bool _isTextChar(int c) => !(c < kSpace || c == kDelete);
String _parseTextString(String s) => _filteredParse(s, _isTextChar);
String _getTextError(String s) => _getFilteredError(s, _isTextChar);

// **** Utilities
String _filteredParse(String s, bool filter(int c)) {
  for (int i = 0; i < s.length; i++)
    if (filter(s.codeUnitAt(i))) return null;
  return s;
}

String _getFilteredError(String s, bool filter(int c)) {
  for (int i = 0; i < s.length; i++)
    if (filter(s.codeUnitAt(i))) _invalidChar(s, i);
  return "";
}

String checkDcmString(String s, int max)  => (_isDcmString(s, max)) ? s : null;

bool _filterString(String s, int min, int max, bool filter(int c)) {
  if (!_isValidLength(s, min, max)) return false;
  for (int i = 0; i < max; i++) {
    if (filter(s.codeUnitAt(i)))
      throw new ArgumentError(_invalidChar(s, i));
  }
  return true;
}

bool _isValidLength(String s, int min, int max) {
  if (s == null || s.length == 0) return null;
  return Int.inRange(s.length, 0, max);
}

bool _isNotValidLength(String s, int min, int max) => !_isValidLength(s, min, max);

String _hasLengthError(int length, int min, int max) =>
    (length < min || length > max)
    ? 'Length Error: min($min) <= Value($length) <= max($max)'
    : null;

String _invalidChar(String s, int pos) =>
    'Value has invalid character(${s.codeUnitAt(pos)}) at position($pos) in: $s';

int _getSign(String s, int start) {
  int c = s.codeUnitAt(0);
  if (c == kMinusSign) return -1;
  if (c == kPlusSign) return 1;
  return 1;
}


bool _isDigitString(String s, int start, int min, int max, [int separator]) {
  int pos = 0;
  for (; pos < max; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (separator != null && c != separator)) return false;
  }
  if (pos < min) return false;
  return true;
}

/*
bool _isDigitString(String s, int minLength, int maxLength, [int seperator]) {
  if (!_isValidLength(s)) return false;
  int pos = 0;
  for (; pos < maxLength; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (seperator != null && c != seperator)) return false;
  }
  if (pos < minLength) return false;
  return true;
}
*/
String _digitStringErrors(String s, int min, int max, [int separator]) {
  String errMsg =  _hasLengthError(s.length, min, max);
  int pos = 0;
  for (; pos < max; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (separator != null && c != separator))
      return '$errMsg\n${_invalidChar(s, pos)}';
  }
  return "";
}

String _isDigitErrors(String s, int minLength, int maxLength, [int separator = kDot]) {
  String errors = _hasLengthError(s.length, minLength, maxLength);
  int pos = 0;
  for (; pos < maxLength; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (separator != null && c != separator)) {
      return _invalidChar(s, pos);
      // return false;
    }
  }
  if (pos < minLength) {
    throw new ArgumentError('The Value has fewer than the '
        'minimum($minLength) number of characters');
    // return false;
  }
  return "";
}

//TODO: this does not handle escape sequences
String errorMsg(String s, int min, int max, Test test) {
  String errMsg = _hasLengthError(s.length, min, max);
  for (int i = 0; i < max; i++) {
    if (!test(s.codeUnitAt(i))) return '$errMsg\n${_invalidChar(s, i)}';
  }
  return errMsg;
}