// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'time_format.dart';
import 'utils.dart';

// ** Time **

/// A Time class, which handles DICOM Time [TM] Value Representations.
class Time {
  static const Time noTime = const Time.empty();

  /// The value of [this] as a Dart DateTime object.
  final DateTime time;

  /// Creates a DICOM [Time], that can be used in Attributes with a [VR] of[TM]
  Time(int h, [int m = 0, int s = 0, int ms = 0, int us = 0])
      : time = checkTime(h, m, s, ms, us);

  const Time.empty() : time = null;

  /// Returns the [hour].
  int get hour => time.hour;

  /// Returns the [minute].
  int get minute => time.minute;

  /// Returns the [second].
  int get second => time.second;

  /// Returns the [millisecond].
  int get millisecond => time.millisecond;

  /// Returns the [microsecond].
  int get microsecond => time.microsecond;

  /// Returns [true] if [this] represents the same time as [other].
  @override
  bool operator ==(Object other) => (other is Time) && (time == other.time);

  /// Returns [true] if [this] is greater than [other].
  bool operator >(Time t) => time.millisecondsSinceEpoch > t.time.millisecondsSinceEpoch;

  /// Returns [true] if [this] is less than [other].
  bool operator <(Time t) => time.millisecondsSinceEpoch > t.time.millisecondsSinceEpoch;

  /// Returns a [hashCode] for [this].
  @override
  int get hashCode => time.hashCode;

  String _toTimeString([TimeFormatType fmt = TimeFormatType.dcm]) {
    var u = dtString(microsecond, 3);
    var ms = dtString(millisecond, 3);
    var s = dtString(second, 2);
    var m = dtString(minute, 2);
    var h = dtString(hour, 2);
    var f = '$ms$u';
    f = (f.length == 0) ? "" : '.$f';
    switch (fmt) {
      case TimeFormatType.dcm:
        return '$h$m$s$f';
      case TimeFormatType.local:
        return '$h:$m:$s$f';
    //TODO: finish if needed
    //case TimeFormatType.utc:
    //  return utcDateTime(time);
      default:
        throw "Invalid Time Format: $fmt";
    }
  }

  //TODO: decide if these are needed?
  String get hh => pad(hour, 2);

  String get mm => pad(minute, 2);

  String get ss => pad(second, 2);

  String get ms => pad(millisecond, 3);

  String get us => pad(microsecond, 3);

  /// Returns [this] as a [String] in local time.
  @override
  String toString() => _toTimeString(TimeFormatType.local);

  static Time get now {
    DateTime dt = new DateTime.now();
    return new Time(dt.hour, dt.minute, dt.second, dt.millisecond, dt.millisecond);
  }

  static bool isValid(int h, [int m = 0, int s = 0, int ms = 0, int us = 0]) =>
      isTime(h, m, s, ms, us);

  /// Parses a DICOM format [String] specified by the arguments
  /// and returns [this].
  static Time dcmParse(String t, [int start = 0, int end]) {
    if (end == null) end = t.length;
    int us = (t.length >= 13) ? parseMicrosecond(t, start + 10) : 0;
    int ms = (t.length >= 10) ? parseMillisecond(t, start + 7) : 0;
    int s = (t.length >= 6) ? parseSecond(t, start + 4) : 0;
    int m = (t.length >= 4) ? parseMinute(t, start + 2) : 0;
    int h = parseHour(t, start);
    return new Time(h, m, s, ms, us);
  }

  /// Parses a [Uint8List] containing the DICOM format [String] specified by the arguments
  /// and returns [this].
  static Time dcmParseBytes(Uint8List bytes, [int start = 0, int end]) {
    if (end == null) end == bytes.length;
    String s = bytes.sublist(start, end).toString();
    return dcmParse(s);
  }

  static final dateTimeMarks = new RegExp('[\-:T\s]');
  static String removeMarks(String s) {
    return s.replaceAll(dateTimeMarks, "");
  }

  /// Parses an Internet format [String] specified by the arguments
  /// and returns [this].
  static Time parse(String t, [int start = 0]) {
    int us = (t.length >= 15) ? parseMicrosecond(t, start + 12) : 0;
    int ms = (t.length >= 12) ? parseMillisecond(t, start + 9) : 0;
    int s = (t.length >= 8) ? parseSecond(t, start + 6) : 0;
    int m = (t.length >= 4) ? parseMinute(t, start + 3) : 0;
    int h = parseHour(t, start);
    return new Time(h, m, s, ms, us);
  }
}

