// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// Defines a set of ASCII character classes.
///
/// The Ascii [code]s are separated in to the following classes:
/// * control
/// * uppercase
/// * lowercase
/// * digit
/// * whitespace
/// * punctuation
///
class Ascii {
  final int value;
  final String name;

  const Ascii(this.value, this.name);

  /// Control characters with codes from Nul=0 to xxx=31, plus Del=127. Whitespace characters,
  /// such as CR = carriage return and LF = linefeed are included in the Control class.
  static const Ascii control = const Ascii(0, "Control");

  /// Uppercase characters 'A' - 'Z'.
  static const Ascii uppercase = const Ascii(1, "Uppercase");

  /// Lowercase characters 'a' - 'z'.
  static const Ascii lowercase = const Ascii(2, "Lowercase");

  /// Characters representing digits (numbers) '0' - '9'
  static const Ascii digit = const Ascii(3, "Number");

  /// Characters that represent whitespace in documents.
  static const Ascii whitespace = const Ascii(4, "Whitespace");

  /// Punctuation characters
  static const Ascii punctuation = const Ascii(5, "Punctuation");
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
class AsciiTable {
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
  final Ascii type;

  const AsciiTable(this.code, this.name, this.description, this.type);

  static const kNUL = const AsciiTable(0, 'NUL', 'Null Character', Ascii.control);
  static const kSOH = const AsciiTable(1, 'SOH', 'Start of Heading', Ascii.control);
  static const kSTX = const AsciiTable(2, 'STX', 'Start of Text', Ascii.control);
  static const kETX = const AsciiTable(3, 'ETX', 'End of Text', Ascii.control);
  static const kEOT = const AsciiTable(4, 'EOT', 'End of Transmission', Ascii.control);
  static const kENQ = const AsciiTable(5, 'ENQ', 'Enquiry', Ascii.control);
  static const kACK = const AsciiTable(6, 'ACK', 'Acknowledgment', Ascii.control);
  static const kBEL = const AsciiTable(7, 'BEL', 'Bell', Ascii.control);
  static const kBS = const AsciiTable(8, 'BS', 'Backspace', Ascii.control);
  static const kHT = const AsciiTable(9, 'HT', 'Horizontal Tab', Ascii.control);
  static const kLF = const AsciiTable(10, 'LF', 'Line Feed', Ascii.control);
  static const kVT = const AsciiTable(11, 'VT', 'Vertical Tab', Ascii.control);
  static const kFF = const AsciiTable(12, 'FF', 'Form Feed', Ascii.control);
  static const kCR = const AsciiTable(13, 'CR', 'Carriage Return', Ascii.control);
  static const kSO = const AsciiTable(14, 'SO', 'Shift Out', Ascii.control);
  static const kSI = const AsciiTable(15, 'SI', 'Shift In', Ascii.control);
  static const kDLE = const AsciiTable(16, 'DLE', 'Data Link Escape', Ascii.control);
  static const kDC1 = const AsciiTable(17, 'DC1', 'Device Control 1 (XON)', Ascii.control);
  static const kDC2 = const AsciiTable(18, 'DC2', 'Device Control 2', Ascii.control);
  static const kDC3 = const AsciiTable(19, 'DC3', 'Device Control 3 (XOFF)', Ascii.control);
  static const kDC4 = const AsciiTable(20, 'DC4', 'Device Control 4', Ascii.control);
  static const kNAK = const AsciiTable(21, 'NAK', 'Negative Acknowledgment', Ascii.control);
  static const kSYN = const AsciiTable(22, 'SYN', 'Synchronous Idle', Ascii.control);
  static const kETB = const AsciiTable(23, 'ETB', 'End of Transmission Block', Ascii.control);
  static const kCAN = const AsciiTable(24, 'CAN', 'Cancel', Ascii.control);
  static const kEM = const AsciiTable(25, 'EM', 'End of Medium', Ascii.control);
  static const kSUB = const AsciiTable(26, 'SUB', 'Substitute', Ascii.control);
  static const kSS = kSUB;
  static const kESC = const AsciiTable(27, 'ESC', 'Escape', Ascii.control);
  static const kFS = const AsciiTable(28, 'FS', 'File Separator', Ascii.control);
  static const kGS = const AsciiTable(29, 'GS', 'Group Separator', Ascii.control);
  static const kRS = const AsciiTable(30, 'RS', 'Record Separator', Ascii.control);
  static const kUS = const AsciiTable(31, 'US', 'Unit Separator', Ascii.control);

  // SP and SPACE are the same!
  static const kSpace = const AsciiTable(32, 'SP', 'Space', Ascii.punctuation);
  static const kExclamationMark= const AsciiTable(33, 'ExclamationMark', 'Exclamation Mark', Ascii.punctuation);
  static const kQuotationMark = const AsciiTable(34, 'QuotationMark', 'Quotation Mark', Ascii.punctuation);
  static const kNumberSign = const AsciiTable(35, 'NumberSign', 'Number sign', Ascii.punctuation);
  static const kDollarSign = const AsciiTable(36, 'DollarSign', 'Dollar sign', Ascii.punctuation);
  static const kPercentSign = const AsciiTable(37, 'PercentSign', 'Percent sign', Ascii.punctuation);
  static const kAmpersand = const AsciiTable(38, 'Ampersand', 'Ampersand', Ascii.punctuation);
  static const kApostrophe = const AsciiTable(39, 'Apostrophe', 'Apostrophe', Ascii.punctuation);
  static const kLeftParentheses = const AsciiTable(40, 'LeftParentheses', 'Left parentheses', Ascii.punctuation);
  static const kRightParentheses = const AsciiTable(41, 'RightParentheses', 'Rigth ''parentheses', Ascii.punctuation);
  static const kAsterisk = const AsciiTable(42, 'Asterisk', 'Asterisk', Ascii.punctuation);
  static const kPlusSign = const AsciiTable(43, 'PlusSign', 'Plus sign', Ascii.punctuation);
  static const kComma= const AsciiTable(44, 'Comma', 'Comma', Ascii.punctuation);
  static const kMinsuSign = const AsciiTable(45, 'MinsuSign', 'Minus sign', Ascii.punctuation);
  static const kPeriod = const AsciiTable(46, 'Period', 'Period', Ascii.punctuation);
  static const kSlash = const AsciiTable(47, 'Slash', 'Slash', Ascii.punctuation);
  static const kSolidus = kSlash;

  static const k0 = const AsciiTable(48, 'Digit0', 'Number 0', Ascii.digit);
  static const kDigit0 = k0;
  static const k1 = const AsciiTable(49, 'Digit1', 'Number 1', Ascii.digit);
  static const kDigit1 = k1;
  static const k2 = const AsciiTable(50, 'Digit2', 'Number 2', Ascii.digit);
  static const kDigit2 = k2;
  static const k3 = const AsciiTable(51, 'Digit3', 'Number 3', Ascii.digit);
  static const kDigit3 = k3;
  static const k4 = const AsciiTable(52, 'Digit4', 'Number 4', Ascii.digit);
  static const kDigit4 = k4;
  static const k5 = const AsciiTable(53, 'Digit5', 'Number 5', Ascii.digit);
  static const kDigit5 = k5;
  static const k6 = const AsciiTable(54, 'Digit6', 'Number 6', Ascii.digit);
  static const kDigit6 = k6;
  static const k7 = const AsciiTable(55, 'Digit7', 'Number 7', Ascii.digit);
  static const kDigit7 = k7;
  static const k8 = const AsciiTable(56, 'Digit8', 'Number 8', Ascii.digit);
  static const kDigit8 = k8;
  static const k9 = const AsciiTable(57, 'Digit9', 'Number 9', Ascii.digit);
  static const kDigit9 =k9;

  static const kColon= const AsciiTable(58, 'Colon', 'Colon', Ascii.punctuation);
  static const kSemicolon = const AsciiTable(59, 'Semicolon', 'Semicolon', Ascii.punctuation);
  static const kLessThanSign = const AsciiTable(60, 'LessThanSign', 'Less-than sign', Ascii.punctuation);
  static const kEqualsSign = const AsciiTable(61, 'EqualsSign', 'Equals sign', Ascii.punctuation);
  static const kGreaterThanSign = const AsciiTable(62, 'GreaterThanSign', 'Greater-than sign', Ascii.punctuation);
  static const kQuestionMark = const AsciiTable(63, 'QuestionMark', 'Question mark', Ascii.punctuation);
  static const kAtSign = const AsciiTable(64, 'AtSign', 'At sign', Ascii.punctuation);

  static const kA = const AsciiTable(65, 'A', 'Letter A', Ascii.uppercase);
  static const kB = const AsciiTable(66, 'B', 'Letter B', Ascii.uppercase);
  static const kC = const AsciiTable(67, 'C', 'Letter C', Ascii.uppercase);
  static const kD = const AsciiTable(68, 'D', 'Letter D', Ascii.uppercase);
  static const kE = const AsciiTable(69, 'E', 'Letter E', Ascii.uppercase);
  static const kF = const AsciiTable(70, 'F', 'Letter F', Ascii.uppercase);
  static const kG = const AsciiTable(71, 'G', 'Letter G', Ascii.uppercase);
  static const kH = const AsciiTable(72, 'H', 'Letter H', Ascii.uppercase);
  static const kI = const AsciiTable(73, 'I', 'Letter I', Ascii.uppercase);
  static const kJ = const AsciiTable(74, 'J', 'Letter J', Ascii.uppercase);
  static const kK = const AsciiTable(75, 'K', 'Letter K', Ascii.uppercase);
  static const kL = const AsciiTable(76, 'L', 'Letter L', Ascii.uppercase);
  static const kM = const AsciiTable(77, 'M', 'Letter M', Ascii.uppercase);
  static const kN = const AsciiTable(78, 'N', 'Letter N', Ascii.uppercase);
  static const kO = const AsciiTable(79, 'O', 'Letter O', Ascii.uppercase);
  static const kP = const AsciiTable(80, 'P', 'Letter P', Ascii.uppercase);
  static const kQ = const AsciiTable(81, 'Q', 'Letter Q', Ascii.uppercase);
  static const kR = const AsciiTable(82, 'R', 'Letter R', Ascii.uppercase);
  static const kS = const AsciiTable(83, 'S', 'Letter S', Ascii.uppercase);
  static const kT = const AsciiTable(84, 'T', 'Letter T', Ascii.uppercase);
  static const kU = const AsciiTable(85, 'U', 'Letter U', Ascii.uppercase);
  static const kV = const AsciiTable(86, 'V', 'Letter V', Ascii.uppercase);
  static const kW = const AsciiTable(87, 'W', 'Letter W', Ascii.uppercase);
  static const kX = const AsciiTable(88, 'X', 'Letter X', Ascii.uppercase);
  static const kY = const AsciiTable(89, 'Y', 'Letter Y', Ascii.uppercase);
  static const kZ = const AsciiTable(90, 'Z', 'Letter Z', Ascii.uppercase);

  static const kLeftSquareBracket = const AsciiTable(91, 'kLeftSquareBracket', 'Left square bracket', Ascii.punctuation);
  static const kBackslash = const AsciiTable(92, 'Backslash', 'Backslash', Ascii.punctuation);
  static const kReverseSolidus = kBackslash;
  static const kRightSquareBracket = const AsciiTable(93, 'RightSquareBracket', 'Right square bracket', Ascii.punctuation);
  static const kCaret = const AsciiTable(94, 'Caret', 'Caret', Ascii.punctuation);
  static const kUnderscore = const AsciiTable(95, 'Underscore', 'Underscore', Ascii.punctuation);
  static const kGraveAccent = const AsciiTable(96, 'GraveAccent', 'Grave Accent', Ascii.punctuation);

  static const ka = const AsciiTable(97, 'a', 'Letter a', Ascii.lowercase);
  static const kb = const AsciiTable(98, 'b', 'Letter b', Ascii.lowercase);
  static const kc = const AsciiTable(99, 'c', 'Letter c', Ascii.lowercase);
  static const kd = const AsciiTable(100, 'd', 'Letter d', Ascii.lowercase);
  static const ke = const AsciiTable(101, 'e', 'Letter e', Ascii.lowercase);
  static const kf = const AsciiTable(102, 'f', 'Letter f', Ascii.lowercase);
  static const kg = const AsciiTable(103, 'g', 'Letter g', Ascii.lowercase);
  static const kh = const AsciiTable(104, 'h', 'Letter h', Ascii.lowercase);
  static const ki = const AsciiTable(105, 'i', 'Letter i', Ascii.lowercase);
  static const kj = const AsciiTable(106, 'j', 'Letter j', Ascii.lowercase);
  static const kk = const AsciiTable(107, 'k', 'Letter k', Ascii.lowercase);
  static const kl = const AsciiTable(108, 'l', 'Letter l', Ascii.lowercase);
  static const km = const AsciiTable(109, 'm', 'Letter m', Ascii.lowercase);
  static const kn = const AsciiTable(110, 'n', 'Letter n', Ascii.lowercase);
  static const ko = const AsciiTable(111, 'o', 'Letter o', Ascii.lowercase);
  static const kp = const AsciiTable(112, 'p', 'Letter p', Ascii.lowercase);
  static const kq = const AsciiTable(113, 'q', 'Letter q', Ascii.lowercase);
  static const kr = const AsciiTable(114, 'r', 'Letter r', Ascii.lowercase);
  static const ks = const AsciiTable(115, 's', 'Letter s', Ascii.lowercase);
  static const kt = const AsciiTable(116, 't', 'Letter t', Ascii.lowercase);
  static const ku = const AsciiTable(117, 'u', 'Letter u', Ascii.lowercase);
  static const kv = const AsciiTable(118, 'v', 'Letter v', Ascii.lowercase);
  static const kw = const AsciiTable(119, 'w', 'Letter w', Ascii.lowercase);
  static const kx = const AsciiTable(120, 'x', 'Letter x', Ascii.lowercase);
  static const ky = const AsciiTable(121, 'y', 'Letter y', Ascii.lowercase);
  static const kz = const AsciiTable(122, 'z', 'Letter z', Ascii.lowercase);

  static const kLeftCurlyBracket = const AsciiTable(123, 'LeftCurlyBracket', 'Left curly bracket', Ascii.punctuation);
  static const kVerticalBar = const AsciiTable(124, 'VerticalBar', 'Vertical bar', Ascii.punctuation);
  static const kRigntCurlyBracket = const AsciiTable(125, 'RigntCurlyBracket', 'Right curly bracket', Ascii.punctuation);
  static const kTilde = const AsciiTable(126, 'Tilde', 'Tilde', Ascii.punctuation);
  static const kDEL = const AsciiTable(127, 'Delete', 'Delete', Ascii.control);

  // Synonyms
  static const kBackspace = kBS;
  static const kTab = kHT;
  static const kLineFeed = kLF;
  static const kFormFeed = kFF;
  static const kReturn = kCR;
  static const kEscape = kESC;
  static const kDelete = kDEL;

  static AsciiTable lookup(int code) => kLookup[code];
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

  String toBinaryString() => code.toRadixString(2);
  String toDecimalString() => code.toRadixString(10);
  String toHexString() => '0x${code.toRadixString(16)}';

  @override
  String toString() => 'Ascii.$name=$code';
}
