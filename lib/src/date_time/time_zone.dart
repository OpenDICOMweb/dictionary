// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/issues/parse_issues.dart';

import 'parse.dart';

class TimeZone {
  static const int minHour = -12;
  static const int maxHour = 14;
  static const int minMinutes = minHour * 60;
  static const int maxMinutes = maxHour * 60;
  final int minutes;

  TimeZone(int sign, int hour, int minute)
      : minutes = toTimeZoneMinutes(sign, hour, minute);

  factory TimeZone.fromMinutes(int minutes) =>
      new TimeZone._(checkRange(minutes, minMinutes, maxMinutes));

  const TimeZone._(this.minutes);

  int get sign => minutes.sign;

  int get hour => minutes ~/ 60;

  int get minute => minutes.remainder(60);

  static int toTimeZoneMinutes(int sign, int hour, int minute) {
    if (!inRange(hour, minHour, maxHour) ||
        (minute != 0 && minute != 30 && minute != 45)) return null;
    return sign * ((hour * 60) + minute);
  }

  static bool isValidString(String s, {int start = 0, int end}) =>
      isValidTimeZone(s, start);

  static TimeZone parse(String s, {int start = 0, int end}) {
    int tzm = parseTimeZone(s, start);
    return (tzm == null) ? null : new TimeZone._(tzm);
  }

  static ParseIssues issues(String s, {int start = 0, ParseIssues issues}) {
    ParseIssues issues = new ParseIssues('TimeZone', s);
    getTimeZoneIssues(s, start, issues);
    return issues;
  }

  static const TimeZone utc = const TimeZone._(0);
  static const TimeZone usEast = const TimeZone._(kUSEastTZO);
  static const TimeZone usCentral = const TimeZone._(kUSCentralTZO);
  static const TimeZone usMountain = const TimeZone._(kUSMountainTZO);
  static const TimeZone usPacific = const TimeZone._(kUSPacificTZO);
}
