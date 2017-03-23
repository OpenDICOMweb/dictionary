// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/string/parse.dart';
import 'package:dictionary/src/string/parse_issues.dart';

import 'parse.dart';

//TODO: add implements Comparable
class Time {
  /// Internally [Time] is stored in microseconds.
  final int _microseconds;

  Time(int hour,
      [int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : _microseconds =
            toMicroseconds(hour, minute, second, millisecond, microsecond);

  //Internal constructor - hidden when exported:
  const Time.fromMicroseconds(this._microseconds);

  Time.fromInt(
      {int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0})
      : _microseconds =
            toMicroseconds(hours, minutes, seconds, milliseconds, microseconds);

  /// Returns `true` if this Duration is the same object as [other].
  @override
  bool operator ==(Object other) =>
      (other is Time) ? _microseconds == other._microseconds : false;

  @override
  int get hashCode => _microseconds.hashCode;

  int get inMicroseconds => _microseconds;

  int get inMilliseconds => _microseconds ~/ microsecondsPerMillisecond;

  int get inSeconds => _microseconds ~/ microsecondsPerSecond;

  int get inMinutes => _microseconds ~/ microsecondsPerMinute;

  int get inHours => _microseconds ~/ microsecondsPerHour;

  int get hour => inHours;

  int get minute => _microseconds % microsecondsPerHour;

  int get second => _microseconds % microsecondsPerMinute;

  int get millisecond => _microseconds % microsecondsPerSecond;

  int get microsecond => _microseconds % microsecondsPerMillisecond;

  int get fraction => millisecond * microsecondsPerSecond + microsecond;

  String get h => digits2(hour);

  String get m => digits2(minute);

  String get s => digits2(second);

  String get ms => digits3(millisecond);

  String get us => digits3(_microseconds);

  String get f => digits6(millisecond * 1000 + _microseconds);

  String get dcm => (fraction == 0) ? '$h$m$s' : '$h$m$s.$f';

  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  static const int minLength = 2;
  static const int maxLength = 14;

  static const int microsecondsPerMillisecond = 1000;
  static const int millisecondsPerSecond = 1000;
  static const int secondsPerMinute = 60;
  static const int minutesPerHour = 60;
  static const int hoursPerDay = 24;

  static const int microsecondsPerSecond =
      millisecondsPerSecond * microsecondsPerMillisecond;
  static const int microsecondsPerMinute =
      millisecondsPerMinute * microsecondsPerMillisecond;
  static const int microsecondsPerHour =
      millisecondsPerHour * microsecondsPerMillisecond;
  static const int microsecondsPerDay =
      millisecondsPerDay * microsecondsPerMillisecond;

  static const int millisecondsPerMinute =
      secondsPerMinute * millisecondsPerSecond;
  static const int millisecondsPerHour = secondsPerHour * millisecondsPerSecond;
  static const int millisecondsPerDay = secondsPerDay * millisecondsPerSecond;

  static const int secondsPerHour = minutesPerHour * secondsPerMinute;
  static const int secondsPerDay = minutesPerDay * secondsPerMinute;

  static const int minutesPerDay = hoursPerDay * minutesPerHour;

  static const Time midnight = const Time.fromMicroseconds(0);
  static const Time zero = midnight;

  static int toMicroseconds(int h, int m, int s, int ms, int us) =>
      microsecondsPerHour * checkHour(h, null) +
      microsecondsPerMinute * checkMinute(m, null) +
      microsecondsPerSecond * checkSecond(s, null) +
      microsecondsPerMillisecond * checkMilliSecond(ms, null) +
      us;

  static bool isValidString(String s, [int start = 0, int end]) =>
      parseDcmTime(s, start, end, 2, 14, true);

  static Time parse(String s, [int start = 0, int end]) {
    int us = parseDcmTime(s, start, end, 2, 14, false);
    return (us == null) ? null : new Time.fromMicroseconds(us);
  }

  static ParseIssues issues(String s, [int start = 0, int end]) =>
      getDcmTimeIssues(s, start, end, 2, 14, new ParseIssues('Time', s));

  // Fix
  static String fix(String s, [int start = 0, int end]) {
    var s0 = s.substring(start, end);
    s0 = s.trimRight();
    //TODO: truncate on error, what other fixes? if separator (:) present -
    // remove. if time zone marker present??
    return s0;
  }
}
