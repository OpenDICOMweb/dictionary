// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:dictionary/ascii.dart';
import 'package:dictionary/src/common/string/predicates.dart';

//TODO: have to files general predicates and dicom_predicates
//TODO: once it is cleaned up move ascii to odw.sdk.ascii again.

/// The type of a character predicate
//typedef bool CharPredicate(int c);

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
bool _isDcmCtrlChar(int c) => (c == kLinefeed) || (c == kCr) || (c == kHTab) || (c == kFormfeed);

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
bool isCSChar(int c) => isUppercaseChar(c) || isDigitChar(c) || (c == kSpace) || (c == kUnderscore);

///Returns [true] if [c] is legal in a DICOM Date VR (DA) ; otherwise, [false].
CharPredicate isDAChar = isDigitChar;

///Returns [true] if [c] is legal in a DICOM Date VR (DA) ; otherwise, [false].
bool isDSChar(int c) => isDigitChar(c) || isSignChar(c) || isDotChar(c) || isExponentChar(c);

///Returns [true] if [c] is legal in a DICOM DateTime VR (DT) ; otherwise, [false].
bool isDTChar(int c) => isTMChar(c) || isSignChar(c);

///Returns [true] if [c] is legal in a DICOM Integer VR (IS) ; otherwise, [false].
bool isISChar(int c) => isDigitChar(c) || isSignChar(c);

///Returns [true] if [c] is legal in a DICOM Person Name VR (PN) ; otherwise, [false].
const CharPredicate isPNChar = isReplaceableNBDcrChar;

///Returns [true] if [c] is legal in a DICOM Time VR (TM) ; otherwise, [false].
bool isTMChar(int c) => isDigitChar(c) || (c == kDot);



