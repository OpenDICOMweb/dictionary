// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.string.parse;

/// Returns a [String] containing issues with the Date part of the [String],
/// if any; otherwise, the empty string.
ParseIssues dateIssues(String s, int start, int end, [ParseIssues issues]) {
  issues = (issues == null)
  ? new ParseIssues('Date', s.substring(start, end))
  : issues;
  issues.checkLength(s.length, 8, 8);
  int index = start;
  try {
    yearIssues(s, index, index + 4, issues);
    if ((index += 4) < end) {
      monthIssues(s, index, index + 2, issues);
      if ((index += 2) < end) {
        dayIssues(s, index, index + 2, issues);
      }
    }
  } on ParseError {
    return issues;
  }
  return issues;
}

ParseIssues timeIssues(String s, int start, int end, [ParseIssues issues]) {
  issues = (issues == null)
      ? new ParseIssues('Time', s.substring(start, end))
  : issues;
  issues.checkLength(s.length, 2, 14);
  int index = start;
  try {
    hourIssues(s, index, index + 2, issues);
    if ((index += 2) < end) {
      minuteIssues(s, index, index + 2, issues);
      if ((index += 2) < end) secondIssues(s, index, index + 2, issues);
    }
  } on ParseError {
    return issues;
  }
  return issues;
}

ParseIssues dateTimeIssues(String s, int start, int end) {
  ParseIssues issues = new ParseIssues('DcmDateTime', s.substring(start, end));
  issues.checkLength(s.length, 4, 26);
  int length = end - start;
  int index = start;
  try {
    int end0 = (length < 8) ? end : 8;
    dateIssues(s, index, end0, issues);
    if (length > 8) timeIssues(s, index += 8, length, issues);
  } on ParseError {
    return issues;
  }
  return issues;
}

// **** Functions below this line should become private at Version 0.8.0 for
// **** performance reasons.

ParseIssues yearIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 4, 4, issues, 'year');

ParseIssues monthIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'month');

ParseIssues dayIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'day');

ParseIssues hourIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'hour');

ParseIssues minuteIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'minute');

ParseIssues secondIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'second');

ParseIssues fractionIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 6, issues, 'fraction');

void tzSign(String s, int start, ParseIssues issues) {
  int c = s.codeUnitAt(start);
  if (c != kMinusSign || c != kPlusSign)
    issues.add('TZ Offset: Invalid TZ Sign char: "${s[start]}", code($c). '
        'The TZSign must be "+" or "-".');
}

ParseIssues tzHourIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 2, issues, 'TZHour');

ParseIssues tzMinuteIssues(String s, int start, int end, ParseIssues issues) =>
    _dateTimeIssues(s, start, end, 2, 6, issues, 'TZMinutes');

ParseIssues timeZoneIssues(String s, int start, int end, ParseIssues issues) {
  issues.checkLength(end - start, 5, 5, 'TZ Offset');
  int index = start;
  tzSign(s, index, issues);
  tzHourIssues(s, index++, index + 2, issues);
  tzMinuteIssues(s, index++, index + 2, issues);
  return issues;
}

String _checkLengthIssue(int length, int min, int max, ParseIssues issues,
        [String type = ""]) =>
    (length < min || length > max)
        ? '$type: Invalid length: min($min) <= length($length) <= max($max)'
        : "";

ParseIssues _dateTimeIssues(String s, int start, int end, int min, int max,
    ParseIssues issues, String subtype) {
  issues.checkLength(end - start, min, max, subtype);
  _checkIssueArgs(s, start, end, min, max);
  for (int i = start; i < end; i++) {
    //Issue: return first bad char or all bad characters?
    int c = s.codeUnitAt(i);
    //  print('c: $c');
    if (!isDigitChar(c)) {
      issues.add('$subtype: Invalid char "${s[i]}" code($c) at index $i.');
    }
  }
  return issues;
}

/// Checks that [start], [end], [min], and [max] are all valid for
/// the [String] [s].  If any of the values are not valid and [throwOnError]
/// is [true] it throws an error message; otherwise, is returns
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
String _checkIssueArgs(String s, int start, int end, int min, int max,
    [throwOnError = true]) {
  log.debug1('_checkArgs($throwOnError): (${s.length})"$s"\n'
      '    start: $start, end: $end, min: $min, max: $max');
  String issues = "";
  if (s == null) {
    issues += 'Invalid null String';
    if (throwOnError) throw new ParseError(issues);
    log.debug2('issues 2: "$issues"');
    return issues;
  }
  if (end == null) {
    end = s.length;
  } else {
    if (s.length < end) {
      issues += 'end($end)is greater than the length of s(${s.length})"$s".\n';
      log.debug2('issues 3: "$issues"');
      if (throwOnError) throw new ParseError(issues);
    }
  }
  if (end < start + min) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the minimum length($min) of s(${s.length})"$s"';
    log.debug2('issues 4: "$issues"');
    if (throwOnError) throw new ParseError(issues);
  }
  if (end > start + max) {
    issues += 'The argument "end($end)" is less than start($start) plus '
        'the maximum length($max) of s(${s.length})"$s"';
    log.debug2('issues 5: "$issues"');
    if (throwOnError) throw new ParseError(issues);
  }
  log.debug2('_checkArgs issues: $issues');
  return issues;
}
