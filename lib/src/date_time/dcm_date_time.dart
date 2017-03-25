// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:common/logger.dart';
import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/string/parse_issues.dart';

import 'date.dart';
import 'parse.dart';
import 'time.dart';
import 'time_zone.dart';

final Logger _log = new Logger('uint_test.dart', watermark: Severity.debug);

class DcmDateTime {
  static const int minLength = 4;
  static const int maxLength = 26;
  static final DateTime start = new DateTime.now();
  static final String localTimeZoneName = start.timeZoneName;
  static final int localTZOinMinutes = start.timeZoneOffset.inMinutes;
  static final TimeZone localTimeZone =
      new TimeZone.fromMinutes(localTZOinMinutes);
  final Date date;
  final Time time;
  TimeZone _timeZone;

  DcmDateTime(int year,
      [int month = 0,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : date = new Date(year, month, day),
        time = new Time(hour, minute, second, millisecond, microsecond),
        _timeZone = new TimeZone.fromMinutes(localTZOinMinutes);

  DcmDateTime.utc(int year,
      [int month = 0,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : date = new Date(year, month, day),
        time = new Time(hour, minute, second, millisecond, microsecond),
        _timeZone = TimeZone.utc;

  DcmDateTime.fromDateTime(this.date, this.time, [TimeZone tz])
      : _timeZone = (tz == null) ? localTimeZone : tz;

  factory DcmDateTime.fromDart(DateTime dt) {
    int day = epochDay(dt.year, dt.month, dt.day);
    int us = toMicroseconds(
        dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
    int tzm = dt.timeZoneOffset.inMinutes;
    return new DcmDateTime._(day, us, tzm);
  }
  //Internal constructor - hidden when exported:
  DcmDateTime._(int epochDay, int uSeconds, int tzMinutes)
      : date = new Date.fromEpochDay(epochDay),
        time = new Time.fromMicroseconds(uSeconds),
        _timeZone = new TimeZone.fromMinutes(tzMinutes);

  TimeZone get timeZone => _timeZone;

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

  DcmDateTime get now => new DcmDateTime.fromDart(new DateTime.now());

  String get dcm => (fraction == 0) ? '$y$m$d$h$mm$s' : '$y$m$d$h$m$s.$f';

  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  /// Returns [true] if [s] is a valid DICOM [DcmDateTime] [String] (DT).
  static bool isValidString(String s, [int start = 0, int end]) =>
      isValidDcmDateTime(s,
          start: start, end: end, min: minLength, max: maxLength);

  /// Returns a DICOM [DcmDateTime], if [s] is a valid DT [String];
  static DcmDateTime parse(String s, [int start = 0, int end]) {
    List<int> dt = parseDcmDateTime(s,
        start: start, end: end, min: minLength, max: maxLength);
    _log.debug('DcmDateTime.parse: $dt');
    return (dt == null) ? null : new DcmDateTime._(dt[0], dt[1], dt[2]);
  }

  static ParseIssues issues(String s, [int start = 0, int end]) {
    var issues = new ParseIssues("DcmDateTime", s);
    getDcmDateTimeIssues(s,
        start: start, end: end, min: minLength, max: maxLength, issues: issues);
    return issues;
  }
}
