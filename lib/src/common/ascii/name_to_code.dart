// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// Given the [name] of an Ascii code, returns the Ascii [int] code. [name] is a
/// single character [String], for letters or numbers, or the name of a punctuation
/// or control character. If [name] is not a valid name returns [null].
int codeFromName(String name) => nameToCode[name.toUpperCase()];

/// A map from Ascii name ([String]) to [int].
const Map<String, int> nameToCode = const <String, int>{
  // NUL:  Null
  "NUL": 0,
  "NULL": 0,
  // SOH:  Start of Header
  "SOH": 1,
  // STX:  Start of Text
  "STX": 2,
  // ETX:  End of Text
  "ETX": 3,
  // EOT:  End of Transmission
  "EOT": 4,
  // ENQ:  Enquiry
  "ENQ": 5,
  // ACK:  Acknowledge
  "ACK": 6,
  // BEL:  Bell (beep)
  "BEL": 7,
  // SO:  Shift Out
  "SO": 14,
  // SI:  Shift In
  "SI": 15,
  // DLE:  Data Link Escape
  "DLE": 16,
  // DC1:  Device Control 1 (XON)
  "DC1": 17,
  // DC2:  Device Control 2
  "DC2": 18,
  // DC3:  Device Control 3 (XOFF)
  "DC3": 19,
  // DC4:  Device Control 4
  "DC4": 20,
  // NAK:  Negative Acknowledge
  "NAK": 21,
  // SYN:  Synchronous Idle
  "SYN": 22,
  // ETB:  End of Transmission Block
  "ETB": 23,
  // CAN:  Cancel
  "CAN": 24,
  // EM:  End of Medium
  "EM": 25,
  // SUB:  Substitute
  "SUB": 26,
  // ESC:  Escape
  "ESC": 27,
  // FS:  File Separator
  "FS": 28,
  // GS:  Group Separator
  "GS": 29,
  // RS:  Record Separator
  "RS": 30,
  // US:  Unit Separator
  "US": 31,
  // DEL:  Delete
  "DEL": 127,
  // DEL - synonyms
  "DELETE": 127,
  // BS:  Backspace
  "BS": 8,
  // BS - synonyms
  "BACKSPACE": 8,
  // HT:  Horizontal Tab
  "HT": 9,
  // HT - synonyms
  "HTAB": 9,
  "TAB": 9,
  // LF:  Line Feed
  "LF": 10,
  // LF - synonyms
  "LINEFEED": 10,
  "NEWLINE": 10,
  // VT:  Vertical Tab
  "VT": 11,
  // VT - synonyms
  "VTAB": 11,
  // FF:  Form Feed
  "FF": 12,
  // FF - synonyms
  "FORMFEED": 12,
  // CR:  Carriage Return
  "CR": 13,
  // CR - synonyms
  "RETURN": 13,
  // SP:  Space
  "SP": 32,
  // SP - synonyms
  "SPACE": 32,
  // DIGIT_0:  Digit Zero
  "DIGIT_0": 48,
  // DIGIT_0 - synonyms
  "0": 48,
  // DIGIT_1:  Digit One
  "DIGIT_1": 49,
  // DIGIT_1 - synonyms
  "1": 49,
  // DIGIT_2:  Digit Two
  "DIGIT_2": 50,
  // DIGIT_2 - synonyms
  "2": 50,
  // DIGIT_3:  Digit Three
  "DIGIT_3": 51,
  // DIGIT_3 - synonyms
  "3": 51,
  // DIGIT_4:  Digit Four
  "DIGIT_4": 52,
  // DIGIT_4 - synonyms
  "4": 52,
  // DIGIT_5:  Digit Five
  "DIGIT_5": 53,
  // DIGIT_5 - synonyms
  "5": 53,
  // DIGIT_6:  Digit Six
  "DIGIT_6": 54,
  // DIGIT_6 - synonyms
  "6": 54,
  // DIGIT_7:  Digit Seven
  "DIGIT_7": 55,
  // DIGIT_7 - synonyms
  "7": 55,
  // DIGIT_8:  Digit Eight
  "DIGIT_8": 56,
  // DIGIT_8 - synonyms
  "8": 56,
  // DIGIT_9:  Digit Nine
  "DIGIT_9": 57,
  // DIGIT_9 - synonyms
  "9": 57,
  // A:  Capital Letter A
  "A": 65,
  // B:  Capital Letter B
  "B": 66,
  // C:  Capital Letter C
  "C": 67,
  // D:  Capital Letter D
  "D": 68,
  // E:  Capital Letter E
  "E": 69,
  // F:  Capital Letter F
  "F": 70,
  // G:  Capital Letter G
  "G": 71,
  // H:  Capital Letter H
  "H": 72,
  // I:  Capital Letter I
  "I": 73,
  // J:  Capital Letter J
  "J": 74,
  // K:  Capital Letter K
  "K": 75,
  // L:  Capital Letter L
  "L": 76,
  // M:  Capital Letter M
  "M": 77,
  // N:  Capital Letter N
  "N": 78,
  // O:  Capital Letter O
  "O": 79,
  // P:  Capital Letter P
  "P": 80,
  // Q:  Capital Letter Q
  "Q": 81,
  // R:  Capital Letter R
  "R": 82,
  // S:  Capital Letter S
  "S": 83,
  // T:  Capital Letter T
  "T": 84,
  // U:  Capital Letter U
  "U": 85,
  // V:  Capital Letter V
  "V": 86,
  // W:  Capital Letter W
  "W": 87,
  // X:  Capital Letter X
  "X": 88,
  // Y:  Capital Letter Y
  "Y": 89,
  // Z:  Capital Letter Z
  "Z": 90,
  // a:  Small Letter a
  "a": 97,
  // b:  Small Letter b
  "b": 98,
  // c:  Small Letter c
  "c": 99,
  // d:  Small Letter d
  "d": 100,
  // e:  Small Letter e
  "e": 101,
  // f:  Small Letter f
  "f": 102,
  // g:  Small Letter g
  "g": 103,
  // h:  Small Letter h
  "h": 104,
  // i:  Small Letter i
  "i": 105,
  // j:  Small Letter j
  "j": 106,
  // k:  Small Letter k
  "k": 107,
  // l:  Small Letter l
  "l": 108,
  // m:  Small Letter m
  "m": 109,
  // n:  Small Letter n
  "n": 110,
  // o:  Small Letter o
  "o": 111,
  // p:  Small Letter p
  "p": 112,
  // q:  Small Letter q
  "q": 113,
  // r:  Small Letter r
  "r": 114,
  // s:  Small Letter s
  "s": 115,
  // t:  Small Letter t
  "t": 116,
  // u:  Small Letter u
  "u": 117,
  // v:  Small Letter v
  "v": 118,
  // w:  Small Letter w
  "w": 119,
  // x:  Small Letter x
  "x": 120,
  // y:  Small Letter y
  "y": 121,
  // z:  Small Letter z
  "z": 122,
  // EXCLAM:  Exclamation Mark
  "EXCLAM": 33,
  // EXCLAM - synonyms
  "EXCLAMATION_MARK": 33,
  "EXCLAMATION": 33,
  // QUOTE:  Quotation Mark
  "QUOTE": 34,
  // QUOTE - synonyms
  "QUOTATION_MARK": 34,
  "QUOTATION": 34,
  "DOUBLE_QUOTE": 34,
  // NUMBER:  Number Sign
  "NUMBER": 35,
  // NUMBER - synonyms
  "NUMBER_SIGN": 35,
  // DOLLAR:  Dollar Sign
  "DOLLAR": 36,
  // DOLLAR - synonyms
  "DOLLAR_SIGN": 36,
  // PERCENT:  Percent Sign
  "PERCENT": 37,
  // PERCENT - synonyms
  "PERCENT_SIGN": 37,
  // AMPER:  Ampersand
  "AMPER": 38,
  // AMPER - synonyms
  "AMPERSAND": 38,
  // APOSTR:  Apostrophe
  "APOSTR": 39,
  // APOSTR - synonyms
  "APOSTROPHE": 39,
  "SINGLE_QUOTE": 39,
  // LParen:  Left Parentheses
  "LParen": 40,
  // LParen - synonyms
  "LEFT_PARENTHESES": 40,
  // RPAREN:  Rigth Parentheses
  "RPAREN": 41,
  // RPAREN - synonyms
  "RIGHT_PARENTHESES": 41,
  // STAR:  Asterisk
  "STAR": 42,
  // STAR - synonyms
  "ASTERISK": 42,
  // PLUS:  Plus Sign
  "PLUS": 43,
  // PLUS - synonyms
  "PLUS_SIGN": 43,
  // COMMA:  Comma
  "COMMA": 44,
  // MINUS:  Hyphen, Minus Sign
  "MINUS": 45,
  // MINUS - synonyms
  "MINUS_SIGN": 45,
  "HYPHEN": 45,
  // PERIOD:  Period, Full Stop
  "PERIOD": 46,
  // PERIOD - synonyms
  "FULL_STOP": 46,
  // SLASH:  Solidus, Slash
  "SLASH": 47,
  // SLASH - synonyms
  "SOLIDUS": 47,
  // COLON:  Colon
  "COLON": 58,
  // SEMI:  Semicolon
  "SEMI": 59,
  // SEMI - synonyms
  "SEMICOLON": 59,
  // LESS:  Less-Than Sign, Left Angle Bracket
  "LESS": 60,
  // LESS - synonyms
  "LESS_THAN_SIGN": 60,
  "LESS_THAN": 60,
  "LEFT_ANGLE": 60,
  // EQUAL:  Equals Sign
  "EQUAL": 61,
  // EQUAL - synonyms
  "EQUALS_SIGN": 61,
  // GREATER:  Greater-Than Sign, Rigth Angle Bracket
  "GREATER": 62,
  // GREATER - synonyms
  "GREATER_THAN_SIGN": 62,
  "GREATER_THAN": 62,
  "RIGHT_ANGLE": 62,
  // QUESTION:  Question Mark
  "QUESTION": 63,
  // QUESTION - synonyms
  "QUESTION_MARK": 63,
  // AT_SIGN:  Commeration At Sign
  "AT_SIGN": 64,
  // AT_SIGN - synonyms
  "COMMERCIAL_AT_SIGN": 64,
  "AT": 64,
  // LSQUARE:  Left Square Bracket
  "LSQUARE": 91,
  // LSQUARE - synonyms
  "LEFT_SQUARE_BRACKET": 91,
  // BACKSLASH:  Reverse Solidus (Backslash)
  "BACKSLASH": 92,
  // BACKSLASH - synonyms
  "REVERSE_SOLIDUS": 92,
  // RSQUARE:  Right Square Bracket
  "RSQUARE": 93,
  // RSQUARE - synonyms
  "RIGHT_SQUARE_BRACKET": 93,
  // CIRCOMFLEX:  Circumflex Accent
  "CIRCOMFLEX": 94,
  // CIRCOMFLEX - synonyms
  "CIRCOMFLEX_ACCENT": 94,
  // LOW_LINE:  Low Line, Underline, Underscore
  "LOW_LINE": 95,
  // LOW_LINE - synonyms
  "_": 95,
  "UNDERLINE": 95,
  "UNDERSCORE": 95,
  // GRAVE:  Grave Accent
  "GRAVE": 96,
  // GRAVE - synonyms
  "GRAVE_ACCENT": 96,
  // LBRACE:  Left Curly Bracket, Left Brace
  "LBRACE": 123,
  // LBRACE - synonyms
  "LEFT_CURLY_BRACKET": 123,
  "LCURLY": 123,
  // VBAR:  Vertical Line, Vertical Bar
  "VBAR": 124,
  // VBAR - synonyms
  "VERTICAL_LINE": 124,
  "VLINE": 124,
  "VERTICAL_BAR": 124,
  // RBRACE:  Right Curly Bracket, Right Brace
  "RBRACE": 125,
  // RBRACE - synonyms
  "RIGHT_CURLY_BRACKET": 125,
  "RCURLY": 125,
  // TILDE:  Tilde
  "TILDE": 126
};