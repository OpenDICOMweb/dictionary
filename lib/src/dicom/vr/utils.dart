// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.vr;

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
  if (length == null)
    return 'Invalid length(Null)';
  if (length == 0)
    return 'Invalid length(0)';
  return (length < min || max < length)
         ? 'Length Error: min($min) <= Value($length) <= max($max)'
         : null;
}

/// Returns [true] if all characters pass the filter.
bool _filteredTest(String s, int min, int max, bool filter(int c)) {
  if (_isNotValidLength(s.length, min, max)) return false;
  for (int i = 0; i < max; i++)
    if (!filter(s.codeUnitAt(i))) return false;
  return true;
}

/// Returns [s] if all characters pass the filter; otherwise, [null]
String _filteredCheck(String s, int min, int max, bool filter(int c)) =>
    (_filteredTest(s, min, max, filter)) ? s : null;

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

// *** DICOM DCR Strings -  AE, CS, LO, SH, UC.

/// The filter for DICOM String characters.
/// Visible ASCII characters, except Backslash.
bool _isDcmChar(int c) =>
    (c >= kSpace && c < kBackslash || c > kBackslash && c < kDelete);

/// Returns [true] if [s] is a valid DICOM String.
bool _isDcmString(String s, int min, int max) =>
    _filteredTest(s, min, max, _isDcmChar);

/// Returns [s] if [s] is a valid DICOM String; otherwise, null.
String _checkDcmString(String s, int min, int max)  =>
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

/// Returns [s] if [s] is a valid DICOM String; otherwise, null.
String _checkDcmText(String s, int min, int max)  =>
    (_isDcmText(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _dcmTextError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isTextChar);

// **** Date, DateTime, and Time

// **** Date

bool _isDcmDateString(String s, int min, int max) {
  int start = 0;
  if (s.length < 8) return false;
  int y = parseYear(s, start);
  if (y == null) return false;
  int m = parseMonth(s, start+ 4);
  if (m == null) return false;
  int d = parseDay(y, m, s, start + 6);
  return (d == null) ? false : true;
}

/// Returns [s], if [s] is a valid date in DICOM format; otherwise, [null].
String _checkDcmDate(String s, int min, int max) =>
    (_isDcmDateString(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is not a valid DICOM date; otherwise, "".
String _dcmDateError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
  int start = 0;
  int y = parseYear(s, start);
  if (y == null)
    return 'Invalid year(${s.substring(start, start + 4)})';
  int m = parseMonth(s, start+ 4);
  if (m == null)
    return 'Invalid month(${s.substring(start + 4, start + 6)})';
  int d = parseDay(y, m, s, start + 6);
  if (d == null)
    return 'Invalid day(${s.substring(start + 6, start + 8)})';
  return "";
}



// **** DateTime

bool _isDcmDateTime(String s, int min, int max) {
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
    int f = parseFraction(s, index);
    if (f == null) return false;
  }
  return true;
}


String _checkDcmDateTime(String s, int min, int max) =>
    (_isDcmDate(s, min, max)) ? s : null;

String _dcmDateTimeError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
}

// **** Time

bool _isDcmTime(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return false;

}

String _checkDcmTime(String s, int min, int max) =>
    (_isDcmDate(s, min, max)) ? s : null;

String _dcmTimeError(String s, int min, int max) {
  String msg = _getLengthError(s.length, min, max);
  if (msg == null) return msg;
}

// **** UID String - UI

/// The filter for DICOM Text characters.
/// All visible ASCII characters including Backslash.  These [VR]s
/// must have a VM of VM.k1, i.e. only one value.
bool _isUidChar(int c) => !(isHexChar(c) || c == kDot);

//TODO: fix - this isn't good enough
/// Returns [true] if [s] is a valid DICOM String.
bool _isUid(String s, int min, int max) =>
    _filteredTest(s, min, max, _isUidChar);

/// Returns [s] if [s] is a valid DICOM String; otherwise, null.
String _checkUid(String s, int min, int max)  =>
    (_isUid(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is invalid; otherwise, "".
String _uidError(String s, int min, int max) =>
    _getFilteredError(s, min, max, _isUidChar);

//TODO: do something more efficient
//UR - Universal Resource Identifier (URI)
bool _isUri(String s, int min, int max) {
  if (_getLengthError(s.length, min, max) == null) return false;
  Uri uri;
  try {
    uri = Uri.parse(s);
  } on FormatException catch (e) {
    return false;
  }
  // Success
  return true;
}

String _checkUri(String s, int min, int max) =>
    (_isUri(s, min, max)) ? s : null;

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
  for (int i = 0; i < 3; i++)
    if (!isDigitChar(s.codeUnitAt(i))) return false;
  return _isAgeMarker(s.codeUnitAt(3)) ? true : false;
}

/// Returns [s] if [s] is a valid DICOM String; otherwise, null.
String _checkDcmAge(String s, int min, int max)  =>
    (_isDcmAge(s, min, max)) ? s : null;

/// Returns an error [String] if [s] is invalid; otherwise, "".
/// Note: [min] and [max] are here for the sake of the interface.
String _dcmAgeError(String s, int min, int max) {
  String error = _getLengthError(s.length, min, max);
  if (s != null) return error;
  for (int i = 0; i < 3; i++)
    if (!isDigitChar(s.codeUnitAt(i))) _invalidChar(s, i);
  return (!_isAgeMarker(s.codeUnitAt(3))) ? _invalidChar(s, 3) : "";
}


/// [IS - Integer String](http://dicom.nema.org/medical/dicom/current/output/html/part05.html#sect_6.2)

int _parseIS(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return null;
  return int.parse(s, onError: (String s) => null);
}

bool _isISString(String s, int min, int max) =>
    (_parseIS(s, min, max) == null) ? false : true;

String _dcmISError(String s, int min, int max) =>
    (_isISString(s, min, max)) ? "" : 'Invalid Integer(IS) String: $s';

/// DS -Decimal String

num _parseDS(String s, int min, int max) {
  if (_isNotValidLength(s.length, min, max)) return null;
  return num.parse(s, (String s) => null);
}

bool _isDSString(String s, int min, int max) =>
    (_parseDS(s, min, max) == null) ? false : true;

String _dcmDSError(String s, int min, int max) =>
    (_isDSString(s, min, max)) ? "" : 'Invalid Decimal(DS) String: $s';


// *** UID Strings - UI


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
  if (_isNotValidLength(s)) return false;
  int pos = 0;
  for (; pos < maxLength; pos++) {
    int c = s.codeUnitAt(pos);
    if (c < k0 || c > k9 || (seperator != null && c != seperator)) return false;
  }
  if (pos < minLength) return false;
  return true;
}
*/
String _digitStringError(String s, int min, int max, [int separator]) {
  String errMsg =  _getLengthError(s.length, min, max);
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
