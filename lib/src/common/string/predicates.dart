// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/ascii/constants.dart';

/// The type of a character predicate
typedef bool CharPredicate(int c);

typedef bool StringPredicate(String s, [int start, int end]);

typedef bool ConstStringPredicate(String);

//typedef bool _Predicate(String value);

//typedef String _Guard(String value);

//TODO: should the empty string "" be considered valid?
/// Checks that the [String] [s] is valid given the other arguments.
/// Returns [s] if valid, otherwise [null].
String validateString(String s, int min, int max, CharPredicate pred) {
  if ((s == null) || (s.length < min) || (s.length > max)) return null;
  for (int i = 0; i < s.length; i++) {
    int char = s.codeUnitAt(i);
    if (!pred(char)) return null;
  }
  return s;
}

/// Returns [true] if [String] [s] is valid given the other arguments.
bool testString(String s, int min, int max, CharPredicate pred) {
  if (validateString(s, min, max, pred) == null) return false;
  return true;
}

/// Returns [true] if all characters from [start] to [end] are digits; otherwise, [false].
StringPredicate makeStringPredicate(CharPredicate pred) =>
        (String s, [int start = 0, int end]) {
          int stop = (end == null) ? s.length : end;
          for (int i = start; i < stop; i++) {
            if (!pred(s.codeUnitAt(i))) return false;
          }
          return true;
        };

//Fix0 finish the following procedures
ConstStringPredicate makeConstStringPredicate(int minLength, int maxLength, bool pred(int c)) {
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


/// Returns [true] if all characters from [start] to [end] are digits; otherwise, [false].
StringPredicate isDigit = makeStringPredicate(isDigitChar);
StringPredicate isUppercase = makeStringPredicate(isUppercaseChar);
StringPredicate isLowercase = makeStringPredicate(isLowercaseChar);
StringPredicate isAlphabetic = makeStringPredicate(isAlphabeticChar);
StringPredicate isAlphanumeric = makeStringPredicate(isAlphanumericChar);
StringPredicate isSpace = makeStringPredicate(isSpaceChar);
StringPredicate isWhitespace = makeStringPredicate(isWhitespaceChar);
StringPredicate isVisible = makeStringPredicate(isVisibleChar);


/// Returns [true] if [c] is legal in a DICOM [Uid]; otherwise, [false].
bool isUidChar(int c) => isDigitChar(c) || (c == kDot) || (c == kSpace) || (c == kNull);

/// Returns [true] if [s] is [null] or empty [""].
bool isEmpty(String s) => (s == null) || (s == "");


