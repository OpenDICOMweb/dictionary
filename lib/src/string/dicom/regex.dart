// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.toolkit.string.regex;

// General Components
const String emptyStringCmpt = r"";
const String start = r"^";
const String end   = r"$";
const String letter = r"[A-Za-z]";
const String letters = '$letter+';
const String digit = r"\d";
const String digits = r"\d+";
const String hexDigit = r"[\da-fA-F]";
const String hexDigits = '$hexDigit+';

//*****Identifiers
// Identifier Components
const String keywordCmpt = r"(\w)";
const String upperCamelCaseCmpt = r"([A-Z][\w ])";
const String lowerCamelCaseCmpt = r"^[a-z][\w ]*$";
const String dcmKeywordCmpt = r"([A-Z][\w]*)";
const String dcmNameCmpt = r"([A-Z][\w\s]*)";

// Identifier patterns
const String keyword = '^$keywordCmpt\$';
const String upperCamelCase = '^$upperCamelCaseCmpt\$';
const String lowerCamelCase = '^$lowerCamelCaseCmpt\$';
const String dcmKeyword = '^$dcmKeywordCmpt\$';
const String dcmName = '^$dcmNameCmpt\$';

//*****  Numbers
// Number components
const String unsignedIntegerCmpt = r"(\d+)";
//const String positiveIntegerCmpt = unsignedIntegerCmpt;        //groups: 1. int
//const String unsignedIntegerOrEmpty = '($unsignedInteger|$emptyString)';
const String sign = r"([-+])";
const String signOpt = r"([-+]?)";
const String signedIntegerCmpt = '$signOpt$unsignedIntegerCmpt';
const String fraction = r"(\.\d+)";
const String fractionOpt = '$fraction?';
//const String fractionOrEmpty = '$fraction|$emptyString';
const String expMark = r"([Ee])";
const String exponent = '$expMark$signedInteger';
const String exponentOpt = '$exponent?';

// Number patterns
// Integers
const String unsignedInteger = '^($unsignedIntegerCmpt)\$';
const String positiveInteger = '$unsignedInteger';
const String signedInteger = '^($signedIntegerCmpt)\$';
const String hexInt = r"^(0x[\dabcdefABCDEF]+)";
const String dcmTag = r"^(0x[\dabcdefABCDEF]+)";
const String decimalWithCommas = r"^(\d{1,3}(?:\d{3})*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$";
// Decimal
const String simpleFloat = '^($signedInteger$fractionOpt)\$';
const String float = '^($signedInteger$fractionOpt$exponentOpt)\$';
const String dcmDecimal = float;
const String real = '^([-+]?\d+(\.\d+)?)\$';
//TODO fix
//const String scientific = "^([-+]?[0-9]+([.]?[0-9]*([eE][-+]?[0-9]+)?$";


//*****  Dates  *****

// Date Pattern Components
const String year        = r"(([01]\d\d\d) | (20[01]\d))";  // 0000 - 2019

const String monthName    = r"(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)";
const String monthNumber  = r"([012]\d|3[01])";
const String monthName31  = r"(Jan|Mar|May|Jul|Aug|Oct|Dec)";

const String month31      = r"((0[13578])|(1[02])[\-\/\s]?([0-2][0-9])|(3[01]))";
const String month31Opt   = '$month31?';
const String day31       = r"([0-2][0-9])|(3[01]))";
const String day31Opt    = '$day31?';

const String monthName30 = r"(Apr|Jun|Sep|Nov)";
const String month30     = r"(((0[469])|(11))[\-\/\s]?(([0-2][0-9])|(30)))";
const String month30Opt  = '$month30?';
const String day30      = r"(([0-2][0-9])|(30))";
const String day30Opt   = '$day30?';

const String monthName29 = r"Feb";
const String month29    = r"(02)";
const String month29Opt = '($month29?)';
const String day29      = r"([0-2][0-9])";
const String day29Opt   = '$day29?';

const String date8601BasicCmpt       = '($year(($month31$day31)|($month30$day30)|$month29$day29))';
const String dateDicomCmpt           = date8601BasicCmpt;
const String date8601BasicOptCmpt    = '($year(($month31$day31)?|($month30$day30)?|($month29$day29)?))';
const String date8601EnhancedCmpt    = '($year-(($month31-$day31)|($month30-$day30)|($month29-$day29)))';
const String date8601EnhancedOptCmpt = '($year-(($month31-$day31)?|($month30-$day30)?|($month29-$day29)?)?)';

// Date Patterns
const String date8601Basic       = '^$date8601BasicCmpt\$';
const String dateDicom           = date8601Basic;
const String date8601BasicOpt    = '^date8601BasicOptCmpt\$';
const String date8601Enhanced    = '^date8601EnhancedCmpt\$';
const String date8601EnhancedOpt = '^date8601EnhancedOptCmpt\$';

String dateWithSeparator(String separators) =>
    '^($year[$separators]?(($month31[$separators]?$day31)|($month30[$separators]?$day30)|($month29[$separators]?$day29\$';

//***** Times
// Time Pattern Components
const String hour = r"(([01]\d)|(2[0-3]))";
const String minute = r"([0-5]\d)";
const String optMinute = '$minute?';
const String second = r"([0-5]\d|60)"; // Leap seconds
const String optSecond = optMinute;
const String optFraction = r"(.\d{1-7)?";
const String time8601BasicCmpt       = '((T?)$hour$minute$second$optFraction)';
const String time8601BasicOptCmpt   = '((T?)$hour$optMinute$optSecond$optFraction)';
const String timeDicomCmpt          = '($hour$optMinute$optSecond$optFraction';
const String time8601EnhancedCmpt   = '((T?)$hour:$minute:$second$optFraction)';
const String time8601EnhancedOptCmpt = '((T?)$hour:$optMinute:$optSecond$optFraction)';

// Time Patterns
const String time8601Basic      = '^$time8601BasicCmpt\$';
const String time8601BasicOpt   = '^$time8601BasicOptCmpt\$';
const String timeDicom          = '^$timeDicomCmpt\$';
const String time8601Enhanced   = '^$time8601EnhancedCmpt\$';
const String time8601EnhanceOpt = '^$time8601EnhancedOptCmpt\$';

//***** DateTimes
const String dateTime8601Basic       = '^$date8601BasicCmpt$time8601BasicCmpt\$';
const String dateTime8601BasicOpt    = '^$date8601BasicOpt\$';
const String dateTimeDicom           = dateTime8601BasicOpt;
const String dateTime8601Enhanced    = '^$date8601EnhancedCmpt$time8601EnhancedCmpt\$';
const String dateTime8601EnhancedOpt = '^$date8601EnhancedOptCmpt$time8601EnhancedOptCmpt\$';

// HTTP DateTime and Internet Message Format [RFC5322]
// e.g. 'Sun, 06 Nov 1994 08:49:37 GMT'
const String dateTimeHttp = imfFixdate;
const String imfFixdate  = '$dayName, $date1 $timeOfDay GMT';
const String dayName     = r"Mon|Tue|Wed|Thu|Fri|Sat|Sun";
const String date1        = '$dayMonthName\s$year';

const String timeOfDay = '$hour:$minute:$second';

const String dayMonthName = '($dayMonth31|$dayMonth30|$dayMonth29';
const String dayMonth31   = '$day31\s$monthName31';
const String dayMonth30   = '$day30\s$monthName30';
const String dayMonth29 = r"(02)\s(Feb)\s";

// Time Zones
const String timeZone    = r"($sign$hour(:$minute)?))|([Zz])";
const String timeZoneDcm = r"($sign$hour:$minute)|([Zz])";

// DICOM
//Finish:
const String dcrBase = r"";

// Person Name
const String last = r"[A-Za-Z][A-Za-Z-]+";
const String first = last;
const String middle = last;
const String prefix = r"[A-Za-Z][A-Za-Z-\.]";
const String suffix = r"[A-Za-Z][A-Za-Z-\.]";
const String personName = '^\^($last)\^($first)\^($middle)\^($prefix)\^($suffix)\^\$';

// UID/OID
const String uidRootCmpt = r"([012](\.0|\.[1-9]\d*))";
const String uidRoot = '^($uidRootCmpt)\$';
const String uidRest = r"(\.0|\.[1-9a-fA-F][0-9a-fA-F]*)*";
const String uid = '^($uidRoot$uidRest\$)';



// UUID/GUID
// It tests UUIDs or GUIDs, which are alphanumeric characters grouped 8-4-4-4-12
// (with the dashes). Make sure they don't have the brackets around them before
// you check them and have fun!
const String uuidUpperCase = r"^([A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12})$";
const String uuidlowerCase = r"^([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$";
// Allows mixed case
const String uuidMixedCmpt = r"([A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12})";
const String uuidWoBrackets = '^$uuidMixedCmpt\$';
const String uuidWithBrackets = '^\{$uuidMixedCmpt\}\$';
const String uuid             = '^\{?$uuidMixedCmpt\}?\$';

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

bool isEscape(String char) {
  int c = char.codeUnitAt(0);
  return c == $esc;
}


bool isDigit(String char) {
  int c = char.codeUnitAt(0);
  return (c >= $0) && (c <= $9);
}

bool isUppercase(String char) {
  int c = char.codeUnitAt(0);
  return (c >= $A) && (c <= $Z);
}

bool isLowercase(String char) {
  int c = char.codeUnitAt(0);
  return (c >= $a) && (c <= $z);
}

bool isLetter(String char) => isUppercase(char) || isLowercase(char);
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

