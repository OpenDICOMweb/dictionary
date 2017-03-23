// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/string/parse_issues.dart';

import 'date.dart';
import 'parse.dart';
import 'time.dart';

class DcmDateTime {
  static const int minLength = 4;
  static const int maxLength = 26;
  final Date date;
  final Time time;

  DcmDateTime(int year,
      [int month = 0,
        int day = 0,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0])
      : date = new Date(year, month, day),
        time = new Time(hour, minute, second, millisecond, microsecond);

  DcmDateTime.fromDateTime(DcmDateTime dt)
      : date = dt.date,
        time = dt.time;

  //Internal constructor - hidden when exported:
  DcmDateTime.fromDateAndTime(Date date, Time time)
      : date = date,
        time = time;

  int get year => date.year;

  int get month => date.month;

  int get day => date.day;

  int get hour => time.hour;

  int get minute => time.minute;

  int get second => time.second;

  int get millisecond => time.millisecond;

  int get microsecond => time.microsecond;

  int get fraction => (time.millisecond * 1000) + time.microsecond;

  String get y => digits4(year);

  String get m => digits2(month);

  String get d => digits2(day);

  String get h => digits2(hour);

  String get mm => digits2(minute);

  String get s => digits2(second);

  String get ms => digits3(millisecond);

  String get us => digits3(microsecond);

  String get f => digits6(millisecond * 1000 + microsecond);

  DcmDateTime get now {
    DateTime dt = new DateTime.now();
    Date date = new Date(dt.year, dt.month, dt.day);
    Time time =
    new Time(dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
    return new DcmDateTime.fromDateAndTime(date, time);
  }

  String get dcm => (fraction == 0) ? '$y$m$d$h$mm$s' : '$y$m$d$h$m$s.$f';

  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  /// Returns a DICOM [DcmDateTime], if [s] is a valid DT [String];
  static DcmDateTime parse(String s, [int start = 0, int end]) =>
      _parse(s, start, end, false);

  /// Returns [true] if [s] is a valid DICOM [DcmDateTime] [String] (DT).
  static bool isValidString(String s, [int start = 0, int end]) =>
      _parse(s, start, end, true);

  //Urgent: add timeZone
  static dynamic _parse(String s, int start, int end, bool isValidOnly) {
    int epochDay = parseDcmDate(s, start, end, 4, 8, isValidOnly);
    if (epochDay == null) return (isValidOnly) ? false : null;

    if (end == null) end = s.length;
    int microseconds = (start + 8 <= end)
        ? parseDcmTime(s, start + 8, end, 2, 18, isValidOnly)
        : 0;
    if (microseconds == null) return (isValidOnly) ? false : null;

    if (isValidOnly) return true;
    Date date = new Date.fromEpochDay(epochDay);
    Time time = new Time.fromMicroseconds(microseconds);
    return new DcmDateTime.fromDateAndTime(date, time);
  }

  static ParseIssues issues(String s, [int start = 0, int end]) {
    var issues = new ParseIssues("DcmDateTime", s);
    getDcmDateIssues(s, start, end, 4, 8, issues);
    if (end == null) end = s.length;
    if (start + 8 > end) getDcmTimeIssues(s, start + 8, end, 2, 18, issues);
    return issues;
  }
}
