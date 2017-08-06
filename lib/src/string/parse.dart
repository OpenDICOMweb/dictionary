// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/ascii.dart';
import 'package:core/system.dart';
import 'package:dictionary/src/errors.dart';
import 'package:dictionary/src/issues/parse_issues.dart';

// TODO: remove logging before version 0.9.0
//Flush final Logger _log = new Logger('date_time/utils_old.dart', Level.info);

/// General Parse methodology
///
/// There are two types of parser signatures:
/// - Fixed size fields:
///
///     parse(String s, [int start = 0, ParseIssues issues, bool isValidOnly])
///
/// - Variable size fields:
///
///     parse(String s,
///         [int start = 0, int end, int min = 0, int max,
///         ParseIssues issues, bool isValidOnly)
///
/// For both signatures:
///
/// - `s`: is the String to be parsed. `s` must have length greater than or
/// equal to `end`
///
/// - `start` is the index of the first character, `start` defaults to `0`.
///
/// - `end`: is the index of the last character. `end` defaults to `s.length`.
/// It is an error if `end` is greater than `s.length`.
///
/// - `issues`: is an object that contains descriptions of any errors or
/// warnings that have occurred while parsing `s`. If `issues` is `null`,
/// then the parser will `throw` a `ParseError`. If `issues` is not `null`,
/// an error message will be appended to it.
///
/// - `isValidOnly`: is a boolean value indicating whether the function should
/// return true or value on success, and false or null on failure.
///
/// `start` and `end` must exactly delimit the characters to be parsed.
///
/// For the variable signature:
///
/// - `min`: is the minimum number of characters that must be parsed to succeed.
/// `s` must have a minimum length of `start` + `min`. `min` defaults to `0`.
///
/// - `max`: is the maximum number of characters that can be parsed. `s` must
/// have a maximum length of `start` + `max`. `max` defaults to `s.length`.
///
/// Variable length parsers will parse as many characters as possible.
///
/// Top level parsers must wrap internal parsers in:
///
///     try {
///     ...
///     } on ParseError {
///       return (isValidOnly) ? false : null;
///     }
///     return (isValidOnly) ? true : value;
///
/// When an internal parser encounters an error, it will either `throw` a
/// `ParseError` if `issues` is non-`null` or append an error message to
/// `issues` and continue parsing if it can.  Error messages are accumulated
/// in `issues`.
///

/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int parseUint(String s,
    {int start = 0, int end, int min = 0, int max, ParseIssues issues}) {
  int value;
  if (end == null) end = s.length;
  try {
    if (!checkArgs(s, start, end, min, max, issues)) return null;
    log.debug2('parseUint: s($s), start($start), end($end)');
    log.debug2('parseUint s: ${s.substring(start, end)}');
    value = _parseUint(s, start, end, issues);
    log.debug2('Uint: $value');
  } on ParseError {
    return null;
  }
  return value;
}

// Note: for internal use only - doesn't catch
int uintParser(String s, int start, int end, ParseIssues issues,
    {int min = 0, int max}) {
  if (end == null) end = s.length;
  if (!checkArgs(s, start, end, min, max, issues)) return null;
  log.debug('uintParser: s("${s.substring(start, end)}"), '
      'start($start), end($end), issues: $issues');
  int value = _parseUint(s, start, end, issues);
  log.debug('uintParser: value: $value');
  return value;
}

//TODO: rewrite doc
/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. If an error is encountered throws an
/// [ParseError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int _parseUint(String s, int start, int end, ParseIssues issues) {
  int value = 0;
  for (int i = start; i < end; i++) {
    value *= 10;
    log.debug('    i: $i, _pUint: $value, issues: $issues');
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) {
      log.debug('Invalid Char: "${s[i]}"($c)');
      var msg = invalidChar(s, i, "_parseUint");
      if (issues == null) {
        throw new ParseError(msg);
      } else {
        issues += msg;
        log.debug('Issues: ${issues.info}');
        return null;
      }
    }
    int v = c - k0;
    value += v;
    log.debug2('    v: $v, value: $value');
  }
  return value;
}

int parseUintRadix(String s,
    {int radix = 16,
    int start = 0,
    int end,
    int min = 0,
    int max,
    ParseIssues issues}) {
  if (end == null) end = s.length;
  if (!checkArgs(s, start, end, min, max, issues)) return null;
  if (s == null || s == "") return null;
  log.debug2('_parseUint: s($s), start($start), end($end)');
  log.debug2('_parseUint s: ${s.substring(start, end)}');
  try {
    int value = _parseUintRadix(s, start, end, min, max, radix);
    log.debug2('Uint: $value');
    return value;
  } on ParseError catch (e) {
    log.debug(e);
    return null;
  }
}

//TODO: This must be tested before using.
int _parseUintRadix(String s, int start, int end, int min, int max, int radix,
    [bool throwOnError = true]) {
  log.debug1(
      '_parseUintRadix s(${end - start}): "${s.substring(start, end)}"');
  int value = 0;

  int maxChar = kA + radix - 1;
  for (int i = start; i < end; i++) {
    value *= radix;
    int c = s.codeUnitAt(i);
    log.debug2(
        '  $i:  _parseUintRadix: value($value), next-char($c):"${s[i]}"');
    // Make all alphabetic chars uppercase.
    c = (c >= ka) ? kA : c;
    if (c >= kA && c < maxChar) {
      value += c - kA + 10;
    } else if (c >= k0 || c < maxChar) {
      value += c - k0;
    } else {
      if (throwOnError) {
        throw new ParseError('Invalid char $c in String(${s.length}): "$s"');
      }
      return null;
    }
    log.debug2('  _parseUintRadix: value($value)');
  }
  log.debug1('_parseUintRadix: $value');
  return value;
}

int parseFixedInt(String s,
        [int start = 0, int end, ParseIssues issues, bool isValidOnly]) =>
    parseInt(s, start, end, issues, isValidOnly, 0, s.length);

//TODO: doesn't handle radix
int parseInt(String s,
    [int start,
    int end,
    ParseIssues issues,
    bool isValidOnly,
    int min,
    int max]) {
  int sign, value, index = start;
  if (!checkArgs(s, start, end, min, max, issues)) return null;
  sign = parseSign(s, start, issues);
  index += (sign < 0) ? 1 : sign;
  value = _parseUint(s, index, end, issues);
  return (sign == null || value == null) ? null : value * sign;
}

/*
//TODO: move to string parse
String _invalidSign(String s, int index) =>
    'Invalid sign char "${s[index]} at pos($index).';
*/

/// Parses a '+' or '-' character immediately preceeding an integer.
/// Returns 1 for '+'. -1 for '-', or 0 if the character is a digit (0-9);
/// otherwise, either throws a [ParseError] appends a message to [issues].
int parseSign(String s, [int start = 0, ParseIssues issues]) {
  int c = s.codeUnitAt(start);
  if (c == kMinusSign) return -1;
  if (c == kPlusSign) return 1;
  if (isDigitChar(c)) return 0;
  var msg = invalidChar(s, start, "sign");
  if (issues == null) throw new ParseError(msg);
  issues += msg;
  return null;
}

bool parseDecimalPoint(String s, [int start = 0, ParseIssues issues]) {
  if (s.codeUnitAt(start) != kDot) {
    var msg = 'Missing decimal point (".")';
    if (issues == null) throw new ParseError(msg);
    issues += msg;
    return false;
  }
  return true;
}

/// Returns a valid fraction of a second or [null].  The fractoin must be
/// at least 2 characters (a decimal point, followed by a digit, and can be
/// no more than 7 characters.
int parseFraction(String s,
    {int start = 0, int end, int min: 0, int max, ParseIssues issues}) {
  int f;
  try {
    if (end == null) end = s.length;
    log.debug2('s: ${s.substring(start, end)}, start: $start, end: $end');
    if (!checkArgs(s, start, end, min, max, issues)) return null;
    if (!parseDecimalPoint(s, start, issues)) return null;
    f = uintParser(s, start + 1, end, issues);
  } on ParseError {
    return null;
  }
  return f;
}

//Note: the following do no error checking.
String digits2(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String digits3(int n) {
  if (n >= 100) return "$n";
  if (n >= 10) return "$n";
  return "$n";
}

String digits4(int n) {
  if (n >= 1000) return "$n";
  if (n >= 100) return "0$n";
  if (n >= 10) return "00$n";
  return "000$n";
}

String digits6(int n) {
  if (n >= 100000) return "$n";
  if (n >= 10000) return "0$n";
  if (n >= 1000) return "00$n";
  if (n >= 100) return "000$n";
  if (n >= 10) return "0000$n";
  return "00000$n";
}

/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid and [ParseIssues]
/// is not [null] it throws an error message; otherwise, is returns
/// a [String] describing any errors encountered.
///
/// For the arguments to be valid:
///   1. end >= start + min && end <= start + max
///   2. end < s.length
///
///                | end < length
///     0  start  min   max
///     |....|. ...|.....|....|
///
/// Assumption: non of the arguments are null.
bool checkArgs(String s, int start, int end, int min, int max,
    [ParseIssues issues]) {
  log.debug1('    checkArgs: (${s.length})"$s"\n'
      '    start: $start, end: $end, min: $min, max: $max, issues: $issues');
  bool value = true;
  String problem = "";
  if (s == null) {
    problem += invalidArgument("s", "null");
    if (issues == null) throw new ParseError(problem);
    log.debug2('issues 2: "$problem"');
    issues += problem;
    value = false;
  }
  if (s == "") {
    problem +=
        invalidArgument('s', '$s', 'start($start) >= s.length(${s.length})');
    if (issues == null) throw new ParseError(problem);
    log.debug2('issues 2: "$problem"');
    issues += problem;
    value = false;
  }
  if (start >= s.length) {
    problem += invalidArgument('s', '""');
    if (issues == null) throw new ParseError(problem);
    log.debug2('issues 2: "$problem"');
    issues += problem;
    value = false;
  }
  if (end == null) {
    end = s.length;
  } else {
    if (s.length < end) {
      problem += 'end($end) => s.length(${s.length})"$s"';
      log.debug2('issues 3: "$problem"');
      if (issues == null) throw new ParseError(problem);
      issues += problem;
      value = false;
    }
  }
  if (end < start + min) {
    problem += 'The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"';
    log.debug2('issues 4: "$problem"');
    if (issues == null) throw new ParseError(problem);
    issues += problem;
    value = false;
  }
  if (max == null) max = s.length;
  if (end > start + max) {
    problem += 'The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"';
    log.debug2('issues 5: "$problem"');
    if (issues == null) throw new ParseError(problem);
    issues += problem;
    value = false;
  }
  log.debug2('    checkArgs: value: $value, issues: $issues');
  return value;
}

/*
bool inRange(int v, int min, int max, [ParseIssues issues]) =>
    _inRange(v, min, max, issues);

int checkRange(int v, int min, int max, [ParseIssues issues]) =>
    _checkRange(v, min, max, issues);

// Note: _checkRange throws so all the other _check* might also throw.
bool _inRange(int v, int min, int max, ParseIssues issues) {
  if (v == null && issues != null) return false;
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (issues == null) throw new ParseError(msg);
    issues += msg;
    log.debug2('_inRange: ${issues.info}');
    return false;
  }
  return true;
}

int _checkRange(int v, int min, int max, ParseIssues issues) =>
    (_inRange(v, min, max, issues)) ? v : null;


// Note: _checkRange throws so all the other _check* might also throw.
bool inRange(int v, int min, int max, [bool throwOnError = true]) {
  if (v < min || v > max) {
    var msg = 'Invalid value: min($min) <= value($v) <= max($max)';
    if (throwOnError) throw new ParseError(msg);
    return false;
  }
  return true;
}

int checkRange(int v, int min, int max, [bool throwOnError = true]) =>
    (inRange(v, min, max, throwOnError)) ? v : null;
*/
/// Returns an invalid value string.
String invalidArgument(String arg, String value, [String msg = ""]) =>
    'Invalid argument($arg == $value) $msg';

/// Returns an invalid value string.
String invalidValue(int v, [int index, String name = ""]) {
  var pos = (index == null) ? "" : ' at pos($index)';
  var msg = (name == null) ? 'Invalid Value($v)' : 'Invalid $name Value($v)';
  return '$msg$pos';
}

/// Returns an invalid character string.
String invalidChar(String s, int index, [String name = ""]) =>
    'Invalid $name character "${s[index]}"(${s.codeUnitAt(index)}'
    ' at pos($index) in String:"$s" with length: ${s.length})';
