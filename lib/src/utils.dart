// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

// TODO: reorganize and move predicates, errorMsg and parsers into
// Common (Int, Float, String...)
// TODO: these functions don't handle Escape sequences.

// *** Length Utilities

/// Returns [true] if [min] <= [length] <= [max].
bool _isValidLength(int length, int min, int max) {
  if (length == null || length == 0) return null;
  return (min <= length && length <= max);
}

/// Returns [true] if length is NOT valid.
bool _isNotValidLength(int length, int min, int max) =>
    !_isValidLength(length, min, max);

/// Returns a [String] containing an invalid length error message,
/// or [null] if there are no errors.
String _getLengthError(int length, int min, int max) {
  if (length == null) return 'Invalid length(Null)';
  if (length == 0) return 'Invalid length(0)';
  return (length < min || max < length)
      ? 'Length Error: min($min) <= Value($length) <= max($max)'
      : null;
}

/// Returns [true] if all characters pass the filter.
bool _filteredTest(String s, int min, int max, bool filter(int c)) {
  if (_isNotValidLength(s.length, min, max)) return false;
  for (int i = 0; i < s.length; i++) {
    if (!filter(s.codeUnitAt(i))) return false;
  }
  return true;
}

//TODO: this currently returns only the first error - Should it return all errors?
/// Returns an error [String] if some character in [s] does not pass the filter;
/// otherwise, returns the empty [String]("").
String _getFilteredError(String s, int min, int max, bool filter(int c)) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
  for (int i = 0; i < s.length; i++)
    if (filter(s.codeUnitAt(i))) _invalidChar(s, i);
  return "";
}

/// Returns a [String] containing an invalid character error message.
String _invalidChar(String s, int pos) =>
    'Invalid character(${s.codeUnitAt(pos)}) at position($pos) in: $s';

// *** DICOM DCR Strings -  AE, LO, SH, UC.

/// The filter for DICOM String characters.
/// Visible ASCII characters, except Backslash.
bool _isDcmChar(int c) =>
    (c >= kSpace && c < kBackslash || c > kBackslash && c < kDelete);

/// Returns [true] if [s] is a valid DICOM String.
bool _isDcmString(String s, int min, int max) =>
    _filteredTest(s, min, max, _isDcmChar);

String _checkDcmString(String s, int min, int max) =>
    (_isDcmString(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _dcmStringError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isDcmChar);

// *** DICOM Text Strings - LT, ST, UT

/// The filter for DICOM Text characters.
/// All visible ASCII characters including Backslash.  These [VR]s
/// must have a VM of VM.k1, i.e. only one value.
bool _isTextChar(int c) => !(c < kSpace || c == kDelete);

/// Returns [true] if [s] is a valid DICOM String.
bool _isDcmText(String s, int min, int max) =>
    _filteredTest(s, min, max, _isTextChar);

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _dcmTextError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isTextChar);

// **** DICOM Code Strings(CS).

/// The filter for DICOM Code String(CS) characters.
/// Visible ASCII characters, except Backslash.
bool _isDcmCodeStringChar(int c) =>
    isUppercaseChar(c) || isDigitChar(c) || c == kSpace || c == kUnderscore;

/// Returns [true] if [s] is a valid DICOM Code String.
bool _isDcmCodeString(String s, int min, int max) =>
    _filteredTest(s, min, max, _isDcmCodeStringChar);

/// Returns [true] if [s] is a valid DICOM Code String.
String _checkDcmCodeString(String s, int min, int max) =>
    (_isDcmCodeString(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _dcmCodeStringError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isDcmCodeStringChar);


// **** Date, DateTime, and Time

// **** Date

bool _isDcmDateString(String s, int min, int max) {
  int start = 0;
  if (s.length < 8) return false;
  int y = parseYear(s, start);
  if (y == null) return false;
  int m = parseMonth(s, start + 4);
  if (m == null) return false;
  int d = parseDay(y, m, s, start + 6);
  return (d == null) ? false : true;
}

/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
String _dcmDateError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
  int start = 0;
  int y = parseYear(s, start);
  if (y == null) return 'Invalid year(${s.substring(start, start + 4)})';
  int m = parseMonth(s, start + 4);
  if (m == null) return 'Invalid month(${s.substring(start + 4, start + 6)})';
  int d = parseDay(y, m, s, start + 6);
  if (d == null) return 'Invalid day(${s.substring(start + 6, start + 8)})';
  return "";
}

Date _parseDcmDate(String s, int min, int max) => Date.dcmParse(s);

// **** DateTime
//TODO: fix
bool _isDcmDateTimeString(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return false;

  int h, m, ss, f;
  int index = 0;
  int limit = s.length;

  if (limit < index + 2) return false;
  h = parseHour(s, index);
  if (h == null) return false;
  index += 2;
  if (limit >= index + 2) {
    m = parseMinute(s, index);
    if (m == null) return false;
  }
  index += 2;
  if (limit >= index + 2) {
    ss = parseSecond(s, index);
    if (ss == null) return false;
  }
  index += 2;
  if (limit >= index + 2) {
    f = parseFraction(s, index);
    if (f == null) return false;
  }
  return true;
}

String _dcmDateTimeError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg != null) return msg;
  //Urgent: this is not specific enough
  return 'Error in DcmDateTime String: $s';
}

DcmDateTime _parseDcmDateTime(String s, int min, int max) =>
    DcmDateTime.dcmParse(s);

// **** Time

bool _isDcmTimeString(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return false;
  return isDcmTimeString(s, min, max);
}

String _dcmTimeError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg != null) return msg;
  //Urgent: this is not specific enough
  return 'Error in DcmDateTime String: $s';
}

Time _parseDcmTime(String s, int min, int max) => Time.dcmParse(s);

// **** UID String - UI

/// The filter for DICOM Text characters.
/// All visible ASCII characters including Backslash.  These [VR]s
/// must have a VM of VM.k1, i.e. only one value.
bool _isUidChar(int c) => !(isHexChar(c) || c == kDot);

//Urgent fix - this isn't good enough
/// Returns [true] if [s] is a valid DICOM String.
bool _isUid(String s, int min, int max) =>
    _filteredTest(s, min, max, _isUidChar);

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _uidError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isUidChar);

//Urgent do something more efficient
//UR - Universal Resource Identifier (URI)
bool _isUri(String s, int min, int max) {
  if (_getLengthError(s.length, min, max) == null) return false;
  try {
    Uri.parse(s);
  } on FormatException {
    return false;
  }
  // Success
  return true;
}

String _uriError(String s, int min, int max) {
  String error = _getLengthError(s.length, min, max);
  if (error != null) return error;
  Uri uri;
  try {
    uri = Uri.parse(s);
  } on FormatException catch (e) {
    return 'Invalid URI($uri) - error at offset(${e.offset}';
  }
  // Success
  return "";
}

// *** DICOM Age Strings - AS

bool _isAgeMarker(int c) =>
    (c == kD || c == kW || c == kM || c == kY) ? true : false;

/// Returns [true] if [s] is a valid DICOM String.
bool _isDcmAge(String s, int min, int max) {
  if (s.length != 4) return false;
  for (int i = 0; i < 3; i++) if (!isDigitChar(s.codeUnitAt(i))) return false;
  return _isAgeMarker(s.codeUnitAt(3)) ? true : false;
}

/// Returns an error [String] if [s] is invalid; otherwise, "".
/// Note: [min] and [max] are here for the sake of the interface.
String _dcmAgeError(String s, int min, int max) {
  String error = _getLengthError(s.length, min, max);
  if (s != null) return error;
  for (int i = 0; i < 3; i++)
    if (!isDigitChar(s.codeUnitAt(i))) _invalidChar(s, i);
  return (!_isAgeMarker(s.codeUnitAt(3))) ? _invalidChar(s, 3) : "";
}

Duration _dcmAgeParse(String s, int min, int max) {
  int n = readUint(s, 0, 3, 3);
  int nDays;
  switch (s[4]) {
    case "D":
      nDays = 1;
      break;
    case "W":
      nDays = 7;
      break;
    case "M":
      nDays = 30;
      break;
    case "Y":
      nDays = 365;
      break;
    default:
      return null;
  }
  return new Duration(days: n * nDays);
}

/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)

bool _isIntegerString(String s, int min, int max) =>
    (_parseIntegerString(s, min, max) == null) ? false : true;

String _integerStringError(String s, int min, int max) =>
    (_isIntegerString(s, min, max)) ? "" : 'Invalid Integer(IS) String: $s';

int _parseIntegerString(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return null;
  return int.parse(s, onError: (String s) => null);
}

/// DS -Decimal String

bool _isDecimalString(String s, int min, int max) =>
    (_parseDecimalString(s, min, max) == null) ? false : true;

String _decimalStringError(String s, int min, int max) =>
    (_isDecimalString(s, min, max)) ? "" : 'Invalid Decimal(DS) String: $s';

num _parseDecimalString(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return null;
  return num.parse(s, (String s) => null);
}

// *** Unsigned Integer
/// Return the limit, which is [max] or [end].
int _getLimit(int offset, int min, int max, int end) {
  int limit = offset + max;
  if (limit > end) {
    if (offset + min > end) {
      return null;
    } else {
      return end - offset;
    }
  } else {
    return limit;
  }
}

int readUint(String s, [int offset = 0, int min = 0, int max]) {
  if (s == null || s == "") return null;
  int limit = _getLimit(offset, min, max, s.length);
  if (limit == null || limit < min) return null;
  return _readUint(s, offset, limit);
}

/// Parses a base 10 [int] from [offset] to [limit], and returns its corresponding value.
/// If an error is encountered returns [null].
int _readUint(String s, int offset, int limit) {
  print('_readUint s: $s');
  int n = 0;
  for (int i = offset; i < limit; i++) {
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) return null;
    int v = c - k0;
    n = (n * 10) + v;
  }
  return n;
}

/*

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

bool _isDigitString(String s, int minLength, int maxLength, [int seperator]) {
  if (_isNotValidLength(s)) return false;
  int pos = 0;
  for (; pos < maxLength; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (seperator != null && c != seperator)) return false;
  }
  if (pos < minLength) return false;
  return true;
}

String _digitStringError(String s, int min, int max, [int separator]) {
  String errMsg = _getLengthError(s.length, min, max);
  int pos = 0;
  for (; pos < max; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (separator != null && c != separator))
      return '$errMsg\n${_invalidChar(s, pos)}';
  }
  return "";
}

String _isDigitError(String s, int minLength, int maxLength, [int separator = kDot]) {
  String error = _getLengthError(s.length, minLength, maxLength);
  if (error != null) return error;
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
*/

/// Replaces pad char [kSpace] with [kNull]
String _csFixer(String value, int min, int max) {
  if (_isNotValidLength(value.length, min, max)) return null;
  return value.toUpperCase();
}
