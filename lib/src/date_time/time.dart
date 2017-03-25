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

  //TODO: unit test to verify
  /// Returns `true` if this Duration is the same object as [other].
  @override
  Time operator +(Object other) => (other is! Time)
      ? null
      : new Time.fromMicroseconds(_microseconds + other.microseconds);

  //TODO: unit test to verify
  /// Returns `true` if this Duration is the same object as [other].
  @override
  Time operator -(Object other) =>(other is! Time)
      ? null
      : new Time.fromMicroseconds(_microseconds - other.microseconds);

  @override
  int get hashCode => _microseconds.hashCode;

  // These Getters return the total quantity
  int get inMicroseconds => _microseconds;

  int get inMilliseconds => _microseconds ~/ microsecondsPerMillisecond;

  int get inSeconds => _microseconds ~/ microsecondsPerSecond;

  int get inMinutes => _microseconds ~/ microsecondsPerMinute;

  int get inHours => _microseconds ~/ microsecondsPerHour;

  int get hour => inHours;

  int get minute =>
      (_microseconds - (inHours * microsecondsPerHour)) ~/
      microsecondsPerMinute;

  int get second =>
      (_microseconds - (inMinutes * microsecondsPerMinute)) ~/
      microsecondsPerSecond;

  int get millisecond =>
      (_microseconds - (inSeconds * microsecondsPerSecond)) ~/
      microsecondsPerMillisecond;

  int get microsecond =>
      _microseconds - (inMilliseconds * microsecondsPerMillisecond);

  int get fraction => _microseconds - (inSeconds * microsecondsPerSecond);

  String get h => digits2(hour);

  String get m => digits2(minute);

  String get s => digits2(second);

  String get ms => digits3(millisecond);

  String get us => digits3(microsecond);

  String get f => digits6(millisecond * 1000 + microsecond);

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

  static const int microsecondsPerSecond = kMicrosecondsPerSecond;
  static const int microsecondsPerMinute = kMicrosecondsPerMinute;
  static const int microsecondsPerHour = kMicrosecondsPerHour;
  static const int microsecondsPerDay = kMicrosecondsPerDay;
  static const int millisecondsPerMinute = kMillisecondsPerMinute;
  static const int millisecondsPerHour = kMillisecondsPerHour;
  static const int millisecondsPerDay = kMillisecondsPerDay;
  static const int secondsPerHour = kSecondsPerHour;
  static const int secondsPerDay = kSecondsPerDay;
  static const int minutesPerDay = kMinutesPerDay;
  static const Time midnight = const Time.fromMicroseconds(0);
  static const Time zero = midnight;

  static bool isValidString(String s, {int start = 0, int end}) =>
      isValidDcmTime(s, start: start, end: end, min: 2, max: 14);

  static Time parse(String s, {int start = 0, int end}) {
    int us = parseDcmTime(s, start: start, end: end, min: 2, max: 14);
    return (us == null) ? null : new Time.fromMicroseconds(us);
  }

  static ParseIssues issues(
    String s, {
    int start = 0,
    int end,
  }) {
    ParseIssues issues = new ParseIssues('Time', s);
    getDcmTimeIssues(s, min: 2, max: 14, issues: issues);
    return issues;
  }

  // Fix
  static String fix(String s, [int start = 0, int end]) {
    var s0 = s.substring(start, end);
    s0 = s.trimRight();
    //TODO: truncate on error, what other fixes? if separator (:) present -
    // remove. if time zone marker present??
    return s0;
  }
}
