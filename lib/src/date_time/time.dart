// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/string/dcm_parse.dart';

class Time {
  static const int minLength = 2;
  static const int maxLength = 14;
  final Duration time;

  Time(
      {int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0})
      : time = new Duration(
            days: 0,
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            milliseconds: milliseconds,
            microseconds: microseconds);

  Time.fromDuration(this.time);

  int get hours => time.inHours;
  int get minutes => time.inMinutes.remainder(Duration.MINUTES_PER_HOUR);
  int get seconds => time.inSeconds.remainder(Duration.SECONDS_PER_MINUTE);
  int get milliseconds =>
      time.inMilliseconds.remainder(Duration.MILLISECONDS_PER_SECOND);
  int get microseconds =>
      time.inMicroseconds.remainder(Duration.MICROSECONDS_PER_MILLISECOND);
  int get fraction =>
      time.inMicroseconds.remainder(Duration.MICROSECONDS_PER_SECOND);

  String get h => digits2(hours);
  String get m => digits2(minutes);
  String get s => digits2(seconds);
  String get ms => digits3(milliseconds);
  String get us => digits3(microseconds);
  String get f => digits6(milliseconds * 1000 + microseconds);

  String get dcm => (fraction == 0) ? '$h$m$s' : '$h$m$s.$f';

  bool isValid(String s) => isValidDcmTimeString(s, 0, s.length);

  String issues(String s) => getDcmTimeStringIssues(s, 0, s.length);

  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  //to 3 BCE.
  static final Duration isValidTimeValue = Duration.ZERO;

  static bool isValidTimeString(String s) =>
      isValidDcmTimeString(s, 0, s.length);

  static Time parse(String s) {
    Duration t = parseDcmTimeString(s, 0, s.length);
    return (t == null) ? null : new Time.fromDuration(t);
  }
}
