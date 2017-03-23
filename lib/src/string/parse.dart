// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/ascii.dart';
import 'package:common/logger.dart';

import 'parse_error.dart';
import 'parse_issues.dart';

// TODO: remove logging before version 0.9.0
final Logger _log =
    new Logger('date_time/utils_old.dart', watermark: Severity.debug2);

/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int parseUint(String s, int start, int end,
    {ParseIssues issues, int minLength = 0, int maxLength}) {
  if (end == null) end = s.length;
  try {
    checkArgs(s, start, end, minLength, maxLength, issues);
    _log.debug2('parseUint: s($s), start($start), end($end)');
    _log.debug2('parseUint s: ${s.substring(start, end)}');
    int value = _parseUint(s, start, end, issues);
    _log.debug2('Uint: $value');
    return value;
  } on ParseError catch (e) {
    _log.debug(e);
    return null;
  }
}

// Note: for internal use only - doesn't catch
int uintParser(String s, int start, int end, ParseIssues issues,
    {int minLength = 0, int maxLength}) {
  if (end == null) end = s.length;
  checkArgs(s, start, end, minLength, maxLength, issues);
  _log.debug2('uintParser: s($s), start($start), end($end)');
  _log.debug2('uintParser s: ${s.substring(start, end)}');
  int value = _parseUint(s, start, end, issues);
  _log.debug2('Uint: $value');
  return value;
}

//TODO: rewrite doc
/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int _parseUint(String s, int start, int end, ParseIssues issues) {
  int value = 0;
  for (int i = start; i < end; i++) {
    value *= 10;
    _log.debug2('    i: $i, _pUint: $value');
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9) {
      if (issues == null) {
        throw new ParseError('Invalid char "${s[i]}"($c) at index($i) '
            'in String(${s.length}): "$s"');
      } else {
        return null;
      }
    }
    int v = c - k0;
    value += v;
    _log.debug2('    v: $v, value: $value');
  }
  return value;
}

int parseUintRadix(String s, int start, int end,
    [int minLength = 0, int maxLength, int radix]) {
  if (end == null) end = s.length;
  checkArgs(s, start, end, minLength, maxLength);
  if (s == null || s == "") return null;
  _log.debug2('_parseUint: s($s), start($start), end($end)');
  _log.debug2('_parseUint s: ${s.substring(start, end)}');
  try {
    int value = _parseUintRadix(s, start, end, minLength, maxLength, radix);
    _log.debug2('Uint: $value');
    return value;
  } on ParseError catch (e) {
    _log.debug(e);
    return null;
  }
}

//TODO: This must be tested before using.
int _parseUintRadix(String s, int start, int end, int min, int max, int radix,
    [bool throwOnError = true]) {
  _log.debug1(
      '_parseUintRadix s(${end - start}): "${s.substring(start, end)}"');
  int value = 0;

  int maxChar = kA + radix - 1;
  for (int i = start; i < end; i++) {
    value *= radix;
    int c = s.codeUnitAt(i);
    _log.debug2(
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
    _log.debug2('  _parseUintRadix: value($value)');
  }
  _log.debug1('_parseUintRadix: $value');
  return value;
}

//TODO: doesn't handle radix
int parseInt(String s, [int start, int end, int minLength, int maxLength]) {
  checkArgs(s, start, end, minLength, maxLength);
  int c = s.codeUnitAt(start);
  if (!isDigitChar(c) || c != kMinusSign || c != kPlusSign)
    throw 'Invalid Character: :${s[start]}:';
  int sign = (c == kMinusSign) ? -1 : 1;
  start = (c == kMinusSign || c == kPlusSign) ? start++ : start;
  if (c != kDot) throw 'Missing decimal point (".")';
  if (end == null) end = s.length;
  int value = _parseUint(s, start + 1, end, null);
  return value * sign;
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
ParseIssues checkArgs(String s, int start, int end, int min, int max,
    [ParseIssues issues]) {
  _log.debug1('checkArgs: (${s.length})"$s"\n'
      '    start: $start, end: $end, min: $min, max: $max, issues: $issues');
  String problem = "";
  if (s == null) {
    problem += 'Invalid null String';
    if (issues == null) throw new ParseError(problem);
    _log.debug2('issues 2: "$problem"');
    issues += problem;
  }
  if (s == "") {
    problem += 'Invalid empty String';
    if (issues == null) throw new ParseError(problem);
    _log.debug2('issues 2: "$problem"');
    issues += problem;
  }
  if (end == null) {
    end = s.length;
  } else {
    if (s.length < end) {
      problem += 'end($end)is greater than the length of s(${s.length})"$s".\n';
      _log.debug2('issues 3: "$problem"');
      if (issues == null) throw new ParseError(problem);
      issues += problem;
    }
  }
  if (end < start + min) {
    problem += 'The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"';
    _log.debug2('issues 4: "$problem"');
    if (issues == null) throw new ParseError(problem);
    issues += problem;
  }
  if (max == null) max = s.length;
  if (end > start + max) {
    problem += 'The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"';
    _log.debug2('issues 5: "$problem"');
    if (issues == null) throw new ParseError(problem);
    issues += problem;
  }
  _log.debug2('checkArgs issues: $issues');
  return (issues == null || issues.isEmpty) ? null : issues;
}

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
