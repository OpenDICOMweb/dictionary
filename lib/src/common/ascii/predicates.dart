// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'constants.dart';

//**** Predicates ****

/// Returns True if the [c] is in the class [AsciiCharClass.Control]
bool isControlChar(int c) => ((c >= 0) && (c <= kUs)) || (c == kDelete);

/// Returns True if the [c] is in the class [AsciiCharClass.DIGIT]
bool isDigitChar(int c) => ((c >= k0) && (c <= k9));

/// Returns [true] if [c] is an uppercase character.
bool isUppercaseChar(int c) => (c >= kA) && (c <= kZ);

/// Returns [true] if [c] is an lowercase character.
bool isLowercaseChar(int c) => (c >= ka && c <= kz);

/// Returns [true] if [c] is an alphabetic character.
bool isAlphabeticChar(int c) => isUppercaseChar(c) || isLowercaseChar(c);

/// Returns [true] if [c] is an alphanumeric character.
bool isAlphanumericChar(int c) => isAlphabeticChar(c) || isDigitChar(c);

/// Returns [true] if [c] is the ASCII space (' ') character.
bool isSpaceChar(int c) => c == kSpace;

/// Returns [true] if [c] is a whitespace character.
bool isWhitespaceChar(int c) => (c == kSpace) || (c == kTab); //Horizontal Tab

/// Returns [true] if [c] is a visible (printable)character.
/// These are the Ascii characters from 0x21 to 0x7E.
bool isVisibleChar(int c) => (c > kSpace) && (c < kDelete);

/// Synonym for [isVisibleChar].
bool isVChar(int c) => isVisibleChar(c);

/// Returns [true] if [c] is an Ascii Escape character; otherwise [false].
bool isEscapeChar(int c) => c == kEscape;

/// Returns [true] if [c] is sign [c] (+, -).
bool isSignChar(int c) => c == kMinus || c == kPlus;

/// Returns [true] if [c] is decimal point ".".
bool isDotChar(int c) => c == kDot;

/// Returns [true] if [c] is exponent marker "E" or "e".
bool isExponentChar(int c) => c == kE || c == ke;

/// If [c] is a lowercase character, returns the corresponding
/// Uppercase character; otherwise, returns [c] unmodified.
int toUppercaseChar(int c) => (isLowercaseChar(c)) ? c - 32 : c;

/// If [c] is an Uppercase character, returns the corresponding
/// Lowercase character; otherwise, returns [c] unmodified.
int toLowercaseChar(int c) => (isUppercaseChar(c)) ? c + 32 : c;

/// Returns the integer value of a DIGIT or [null] otherwise.
int digitToInt(int c) => (isDigitChar(c)) ? c - k0 : null;
