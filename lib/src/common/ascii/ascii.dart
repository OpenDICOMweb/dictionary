// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// Defines a set of ASCII character classes.
///
/// The Ascii [tag]s are separated in to the following classes:
/// * control
/// * uppercase
/// * lowercase
/// * digit
/// * whitespace
/// * punctuation
///
class AsciiType {
  final int value;
  final String name;

  const AsciiType(this.value, this.name);

  /// Control characters with codes from Nul=0 to xxx=31, plus Del=127. Whitespace characters,
  /// such as CR = carriage return and LF = linefeed are included in the Control class.
  static const AsciiType control = const AsciiType(0, "Control");

  /// Uppercase characters 'A' - 'Z'.
  static const AsciiType uppercase = const AsciiType(1, "Uppercase");

  /// Lowercase characters 'a' - 'z'.
  static const AsciiType lowercase = const AsciiType(2, "Lowercase");

  /// Characters representing digits (numbers) '0' - '9'
  static const AsciiType digit = const AsciiType(3, "Number");

  /// Characters that represent whitespace in documents.
  static const AsciiType whitespace = const AsciiType(4, "Whitespace");

  /// Punctuation characters
  static const AsciiType punctuation = const AsciiType(5, "Punctuation");
}

/// A constant class with a richer set of definitions of US-ASCII codes.
///
/// Each Table entry includes:
///   * The [int] value of the [code]
///   * The [String] name for that [code]
///   * A short [String] describing the [code]
///   * The Character Class of the [code].
///
/// The table also defines some common synonyms for the [code] [name]s.
class Ascii {
  ///The integer code.
  final int code;
  /// The [String] name associated with the [code].
  final String name;
  /// A short description of the meaning of the [code]
  final String description;
  /// The character class [type] of the code.
  ///
  /// Note: This member is called [type] because [class] is a
  /// reserved identifier in [Dart].
  final AsciiType type;

  const Ascii(this.code, this.name, this.description, this.type);

  bool get isControl => type == AsciiType.control;
  bool get isUppercase => type == AsciiType.uppercase;
  bool get isLowercase => type == AsciiType.lowercase;
  bool get isDigit => type == AsciiType.digit;
  bool get isWhitespace => type == AsciiType.whitespace;
  bool get isPunctuation => type == AsciiType.punctuation;

  bool get isVisable => type != AsciiType.control && type != AsciiType.whitespace;
  bool get isPrintable => type != AsciiType.control;
  bool get isAlphabetic => type == AsciiType.lowercase || type == AsciiType.uppercase;
  bool get isNumeric => isDigit;
  bool get isAlphaNumeric => isAlphabetic || isDigit;

  String toBinaryString() => code.toRadixString(2);
  String toDecimalString() => code.toRadixString(10);
  String toHexString() => '0x${code.toRadixString(16)}';

  @override
  String toString() => 'Ascii.$name=$code';

  static const kNUL = const Ascii(0, 'NUL', 'Null Character', AsciiType.control);
  static const kSOH = const Ascii(1, 'SOH', 'Start of Heading', AsciiType.control);
  static const kSTX = const Ascii(2, 'STX', 'Start of Text', AsciiType.control);
  static const kETX = const Ascii(3, 'ETX', 'End of Text', AsciiType.control);
  static const kEOT = const Ascii(4, 'EOT', 'End of Transmission', AsciiType.control);
  static const kENQ = const Ascii(5, 'ENQ', 'Enquiry', AsciiType.control);
  static const kACK = const Ascii(6, 'ACK', 'Acknowledgment', AsciiType.control);
  static const kBEL = const Ascii(7, 'BEL', 'Bell', AsciiType.control);
  static const kBS = const Ascii(8, 'BS', 'Backspace', AsciiType.control);
  static const kHT = const Ascii(9, 'HT', 'Horizontal Tab', AsciiType.control);
  static const kLF = const Ascii(10, 'LF', 'Line Feed', AsciiType.control);
  static const kVT = const Ascii(11, 'VT', 'Vertical Tab', AsciiType.control);
  static const kFF = const Ascii(12, 'FF', 'Form Feed', AsciiType.control);
  static const kCR = const Ascii(13, 'CR', 'Carriage Return', AsciiType.control);
  static const kSO = const Ascii(14, 'SO', 'Shift Out', AsciiType.control);
  static const kSI = const Ascii(15, 'SI', 'Shift In', AsciiType.control);
  static const kDLE = const Ascii(16, 'DLE', 'Data Link Escape', AsciiType.control);
  static const kDC1 = const Ascii(17, 'DC1', 'Device Control 1 (XON)', AsciiType.control);
  static const kDC2 = const Ascii(18, 'DC2', 'Device Control 2', AsciiType.control);
  static const kDC3 = const Ascii(19, 'DC3', 'Device Control 3 (XOFF)', AsciiType.control);
  static const kDC4 = const Ascii(20, 'DC4', 'Device Control 4', AsciiType.control);
  static const kNAK = const Ascii(21, 'NAK', 'Negative Acknowledgment', AsciiType.control);
  static const kSYN = const Ascii(22, 'SYN', 'Synchronous Idle', AsciiType.control);
  static const kETB = const Ascii(23, 'ETB', 'End of Transmission Block', AsciiType.control);
  static const kCAN = const Ascii(24, 'CAN', 'Cancel', AsciiType.control);
  static const kEM = const Ascii(25, 'EM', 'End of Medium', AsciiType.control);
  static const kSUB = const Ascii(26, 'SUB', 'Substitute', AsciiType.control);
  static const kSS = kSUB;
  static const kESC = const Ascii(27, 'ESC', 'Escape', AsciiType.control);
  static const kFS = const Ascii(28, 'FS', 'File Separator', AsciiType.control);
  static const kGS = const Ascii(29, 'GS', 'Group Separator', AsciiType.control);
  static const kRS = const Ascii(30, 'RS', 'Record Separator', AsciiType.control);
  static const kUS = const Ascii(31, 'US', 'Unit Separator', AsciiType.control);

  // SP and SPACE are the same!
  static const kSpace = const Ascii(32, 'SP', 'Space', AsciiType.punctuation);
  static const kExclamationMark= const Ascii(33, 'ExclamationMark', 'Exclamation Mark', AsciiType.punctuation);
  static const kQuotationMark = const Ascii(34, 'QuotationMark', 'Quotation Mark', AsciiType.punctuation);
  static const kNumberSign = const Ascii(35, 'NumberSign', 'Number sign', AsciiType.punctuation);
  static const kDollarSign = const Ascii(36, 'DollarSign', 'Dollar sign', AsciiType.punctuation);
  static const kPercentSign = const Ascii(37, 'PercentSign', 'Percent sign', AsciiType.punctuation);
  static const kAmpersand = const Ascii(38, 'Ampersand', 'Ampersand', AsciiType.punctuation);
  static const kApostrophe = const Ascii(39, 'Apostrophe', 'Apostrophe', AsciiType.punctuation);
  static const kLeftParentheses = const Ascii(40, 'LeftParentheses', 'Left parentheses', AsciiType.punctuation);
  static const kRightParentheses = const Ascii(41, 'RightParentheses', 'Rigth ''parentheses', AsciiType.punctuation);
  static const kAsterisk = const Ascii(42, 'Asterisk', 'Asterisk', AsciiType.punctuation);
  static const kPlusSign = const Ascii(43, 'PlusSign', 'Plus sign', AsciiType.punctuation);
  static const kComma= const Ascii(44, 'Comma', 'Comma', AsciiType.punctuation);
  static const kMinsuSign = const Ascii(45, 'MinsuSign', 'Minus sign', AsciiType.punctuation);
  static const kPeriod = const Ascii(46, 'Period', 'Period', AsciiType.punctuation);
  static const kSlash = const Ascii(47, 'Slash', 'Slash', AsciiType.punctuation);
  static const kSolidus = kSlash;

  static const k0 = const Ascii(48, 'Digit0', 'Number 0', AsciiType.digit);
  static const kDigit0 = k0;
  static const k1 = const Ascii(49, 'Digit1', 'Number 1', AsciiType.digit);
  static const kDigit1 = k1;
  static const k2 = const Ascii(50, 'Digit2', 'Number 2', AsciiType.digit);
  static const kDigit2 = k2;
  static const k3 = const Ascii(51, 'Digit3', 'Number 3', AsciiType.digit);
  static const kDigit3 = k3;
  static const k4 = const Ascii(52, 'Digit4', 'Number 4', AsciiType.digit);
  static const kDigit4 = k4;
  static const k5 = const Ascii(53, 'Digit5', 'Number 5', AsciiType.digit);
  static const kDigit5 = k5;
  static const k6 = const Ascii(54, 'Digit6', 'Number 6', AsciiType.digit);
  static const kDigit6 = k6;
  static const k7 = const Ascii(55, 'Digit7', 'Number 7', AsciiType.digit);
  static const kDigit7 = k7;
  static const k8 = const Ascii(56, 'Digit8', 'Number 8', AsciiType.digit);
  static const kDigit8 = k8;
  static const k9 = const Ascii(57, 'Digit9', 'Number 9', AsciiType.digit);
  static const kDigit9 =k9;

  static const kColon= const Ascii(58, 'Colon', 'Colon', AsciiType.punctuation);
  static const kSemicolon = const Ascii(59, 'Semicolon', 'Semicolon', AsciiType.punctuation);
  static const kLessThanSign = const Ascii(60, 'LessThanSign', 'Less-than sign', AsciiType.punctuation);
  static const kEqualsSign = const Ascii(61, 'EqualsSign', 'Equals sign', AsciiType.punctuation);
  static const kGreaterThanSign = const Ascii(62, 'GreaterThanSign', 'Greater-than sign', AsciiType.punctuation);
  static const kQuestionMark = const Ascii(63, 'QuestionMark', 'Question mark', AsciiType.punctuation);
  static const kAtSign = const Ascii(64, 'AtSign', 'At sign', AsciiType.punctuation);

  static const kA = const Ascii(65, 'A', 'Letter A', AsciiType.uppercase);
  static const kB = const Ascii(66, 'B', 'Letter B', AsciiType.uppercase);
  static const kC = const Ascii(67, 'C', 'Letter C', AsciiType.uppercase);
  static const kD = const Ascii(68, 'D', 'Letter D', AsciiType.uppercase);
  static const kE = const Ascii(69, 'E', 'Letter E', AsciiType.uppercase);
  static const kF = const Ascii(70, 'F', 'Letter F', AsciiType.uppercase);
  static const kG = const Ascii(71, 'G', 'Letter G', AsciiType.uppercase);
  static const kH = const Ascii(72, 'H', 'Letter H', AsciiType.uppercase);
  static const kI = const Ascii(73, 'I', 'Letter I', AsciiType.uppercase);
  static const kJ = const Ascii(74, 'J', 'Letter J', AsciiType.uppercase);
  static const kK = const Ascii(75, 'K', 'Letter K', AsciiType.uppercase);
  static const kL = const Ascii(76, 'L', 'Letter L', AsciiType.uppercase);
  static const kM = const Ascii(77, 'M', 'Letter M', AsciiType.uppercase);
  static const kN = const Ascii(78, 'N', 'Letter N', AsciiType.uppercase);
  static const kO = const Ascii(79, 'O', 'Letter O', AsciiType.uppercase);
  static const kP = const Ascii(80, 'P', 'Letter P', AsciiType.uppercase);
  static const kQ = const Ascii(81, 'Q', 'Letter Q', AsciiType.uppercase);
  static const kR = const Ascii(82, 'R', 'Letter R', AsciiType.uppercase);
  static const kS = const Ascii(83, 'S', 'Letter S', AsciiType.uppercase);
  static const kT = const Ascii(84, 'T', 'Letter T', AsciiType.uppercase);
  static const kU = const Ascii(85, 'U', 'Letter U', AsciiType.uppercase);
  static const kV = const Ascii(86, 'V', 'Letter V', AsciiType.uppercase);
  static const kW = const Ascii(87, 'W', 'Letter W', AsciiType.uppercase);
  static const kX = const Ascii(88, 'X', 'Letter X', AsciiType.uppercase);
  static const kY = const Ascii(89, 'Y', 'Letter Y', AsciiType.uppercase);
  static const kZ = const Ascii(90, 'Z', 'Letter Z', AsciiType.uppercase);

  static const kLeftSquareBracket = const Ascii(91, 'kLeftSquareBracket', 'Left square bracket', AsciiType.punctuation);
  static const kBackslash = const Ascii(92, 'Backslash', 'Backslash', AsciiType.punctuation);
  static const kReverseSolidus = kBackslash;
  static const kRightSquareBracket = const Ascii(93, 'RightSquareBracket', 'Right square bracket', AsciiType.punctuation);
  static const kCaret = const Ascii(94, 'Caret', 'Caret', AsciiType.punctuation);
  static const kUnderscore = const Ascii(95, 'Underscore', 'Underscore', AsciiType.punctuation);
  static const kGraveAccent = const Ascii(96, 'GraveAccent', 'Grave Accent', AsciiType.punctuation);

  static const ka = const Ascii(97, 'a', 'Letter a', AsciiType.lowercase);
  static const kb = const Ascii(98, 'b', 'Letter b', AsciiType.lowercase);
  static const kc = const Ascii(99, 'c', 'Letter c', AsciiType.lowercase);
  static const kd = const Ascii(100, 'd', 'Letter d', AsciiType.lowercase);
  static const ke = const Ascii(101, 'e', 'Letter e', AsciiType.lowercase);
  static const kf = const Ascii(102, 'f', 'Letter f', AsciiType.lowercase);
  static const kg = const Ascii(103, 'g', 'Letter g', AsciiType.lowercase);
  static const kh = const Ascii(104, 'h', 'Letter h', AsciiType.lowercase);
  static const ki = const Ascii(105, 'i', 'Letter i', AsciiType.lowercase);
  static const kj = const Ascii(106, 'j', 'Letter j', AsciiType.lowercase);
  static const kk = const Ascii(107, 'k', 'Letter k', AsciiType.lowercase);
  static const kl = const Ascii(108, 'l', 'Letter l', AsciiType.lowercase);
  static const km = const Ascii(109, 'm', 'Letter m', AsciiType.lowercase);
  static const kn = const Ascii(110, 'n', 'Letter n', AsciiType.lowercase);
  static const ko = const Ascii(111, 'o', 'Letter o', AsciiType.lowercase);
  static const kp = const Ascii(112, 'p', 'Letter p', AsciiType.lowercase);
  static const kq = const Ascii(113, 'q', 'Letter q', AsciiType.lowercase);
  static const kr = const Ascii(114, 'r', 'Letter r', AsciiType.lowercase);
  static const ks = const Ascii(115, 's', 'Letter s', AsciiType.lowercase);
  static const kt = const Ascii(116, 't', 'Letter t', AsciiType.lowercase);
  static const ku = const Ascii(117, 'u', 'Letter u', AsciiType.lowercase);
  static const kv = const Ascii(118, 'v', 'Letter v', AsciiType.lowercase);
  static const kw = const Ascii(119, 'w', 'Letter w', AsciiType.lowercase);
  static const kx = const Ascii(120, 'x', 'Letter x', AsciiType.lowercase);
  static const ky = const Ascii(121, 'y', 'Letter y', AsciiType.lowercase);
  static const kz = const Ascii(122, 'z', 'Letter z', AsciiType.lowercase);

  static const kLeftCurlyBracket = const Ascii(123, 'LeftCurlyBracket', 'Left curly bracket', AsciiType.punctuation);
  static const kVerticalBar = const Ascii(124, 'VerticalBar', 'Vertical bar', AsciiType.punctuation);
  static const kRigntCurlyBracket = const Ascii(125, 'RigntCurlyBracket', 'Right curly bracket', AsciiType.punctuation);
  static const kTilde = const Ascii(126, 'Tilde', 'Tilde', AsciiType.punctuation);
  static const kDEL = const Ascii(127, 'Delete', 'Delete', AsciiType.control);

  // Synonyms
  static const kBackspace = kBS;
  static const kTab = kHT;
  static const kLineFeed = kLF;
  static const kFormFeed = kFF;
  static const kReturn = kCR;
  static const kEscape = kESC;
  static const kDelete = kDEL;

  static Ascii lookup(int code) => kLookup[code];

  static const kLookup = const [
    kNUL, kSOH, kSTX, kETX, kEOT, kENQ, kACK, kBEL, kBS, kHT, kLF, kVT,
    kFF, kCR, kSO, kSI, kDLE, kDC1, kDC2, kDC3, kDC4, kNAK, kSYN, kETB, kCAN,
    kEM, kSUB, kESC, kFS,
    kGS, kRS, kUS,

    //SP , (32,   'SP',  'Space',      AsciiType.Control); //SP or SPACE?
    kSpace, kExclamationMark, kQuotationMark, kNumberSign, kDollarSign,
    kPercentSign, kAmpersand, kApostrophe, kLeftParentheses, kRightParentheses,
    kAsterisk, kPlusSign, kComma, kMinsuSign, kPeriod, kSlash,

    k0, k1, k2, k3, k4, k5, k6, k7, k8, k9,

    kColon, kSemicolon, kLessThanSign, kEqualsSign, kGreaterThanSign,
    kQuestionMark,
    kAtSign,

    kA, kB, kC, kD, kE, kF, kG, kH, kI, kJ, kK, kL, kM, kN, kO, kP, kQ, kR, kS,
    kT, kU, kV, kW, kX, kY, kZ,

    kLeftSquareBracket, kBackslash, kRightSquareBracket, kCaret, kUnderscore,
    kGraveAccent,

    ka, kb, kc, kd, ke, kf, kg, kh, ki, kj, kk, kl, km, kn, ko, kp, kq, kr, ks,
    kt, ku, kv, kw, kx, ky, kz,

    kLeftCurlyBracket, kVerticalBar, kRigntCurlyBracket, kTilde, kDEL
  ];

}
