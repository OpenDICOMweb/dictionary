// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/string/regex.dart';

//TODO: cleanup and document if used

const String dcmKeywordCmpt = r"([A-Z][\w]*)";
const String dcmNameCmpt = r"([A-Z][\w\s]*)";

// Identifier patterns
const String dcmKeyword = '^$dcmKeywordCmpt\$';
const String dcmName = '^$dcmNameCmpt\$';

const String dcmTag = r"^(0x[\dabcdefABCDEF]+)";
const String dcmDecimal = float;

// DICOM

const String dcrBase = r"";

// Person Name
const String last = r"[A-Za-Z][A-Za-Z-]+";
const String first = last;
const String middle = last;
const String prefix = r"[A-Za-Z][A-Za-Z-\.]";
const String suffix = r"[A-Za-Z][A-Za-Z-\.]";
const String personName = '^\^($last)\^($first)\^($middle)\^($prefix)\^($suffix)\^\$';

/// DICOM Default Character Repitoire (DCR)
//const String dcrPunctuation = r" !\\"\#\$\%&\'";
const String dcrUppercase = r"[A-Z]";
const String dcrLowercase = r"[a-z]";
const String dcrDigits    = r"[0-9]";
//const String dcrG0 = r"!\"#$%&\'()*+,";

//TODO test - these should be equialent - which is faster?
// !\#$%&\'()*+,-./:;<=>?@[\]^_`{|}~
const String punc = """ !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~""";
const String punc1 =  " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
const String punc2 = r" !#$%&'()*+,-./:;<=>?@[\]^_`{|}~";

// G0 subset of US-ASCII
final int g0Start = " ".codeUnitAt(0);
final int g0End   = "~".codeUnitAt(0) + 1;

/*TODO delete
bool inDcrG0(String char) {
  int c = char.codeUnitAt(0);
  return (G0Start <= c) && (c <= G0End);
}

bool inAECharset(String char) => inDcrG0(char);

bool validVR_ASCharset(String s) {
  if (s.length != 4) return false;
  for(int i = 0; i < 3; i++) {
    if (! isDigit(s[i])) return false;
  }
  if (! "DWMY".contains(s[3])) return false;
  return true;
}

//BR
bool validBDString(String s) {

  return null;
}

//CS
bool validBRString(String s) {

  return null;
}

//DA
bool validDAString(String s) {

  return null;
}

//DS
bool validDSString(String s) {

  return null;
}

//DT
bool validDTString(String s) {

  return null;
}

//IS
bool validISString(String s) {

  return null;
}

//LO
bool validLOString(String s) {

  return null;
}

//LT
bool validLTString(String s) {

  return null;
}

//PN
bool validPNString(String s) {

  return null;
}

//SH
bool validSHString(String s) {

  return null;
}

//ST
bool validSTString(String s) {

  return null;
}

//TM
bool validTMString(String s) {

  return null;
}

//UI
bool validUIString(String s) {

  return null;
}

//UR
bool validURString(String s) {

  return null;
}

//UT
bool validUTString(String s) {

  return null;
}
*/

