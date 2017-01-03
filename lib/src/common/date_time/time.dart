// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'dcm_date_time.dart';
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
      : time = validateTime(h, m, s, ms, us);

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
      isValidTime(h, m, s, ms, us);

  static DateTime validate(int h, [int m = 0, int s = 0, int ms = 0, int us = 0]) =>
      validateTime(h, m, s, ms, us);

  /// Parses a DICOM format [String] specified by the arguments
  /// and returns [this].
  static Time dcmParse(String t, [int start = 0, int end]) {
    if (end == null) end = t.length;
    int us = (t.length >= 13) ? readMicrosecond(t, start + 10) : 0;
    int ms = (t.length >= 10) ? readMillisecond(t, start + 7) : 0;
    int s = (t.length >= 6) ? readSecond(t, start + 4) : 0;
    int m = (t.length >= 4) ? readMinute(t, start + 2) : 0;
    int h = readHour(t, start);
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
    int us = (t.length >= 15) ? readMicrosecond(t, start + 12) : 0;
    int ms = (t.length >= 12) ? readMillisecond(t, start + 9) : 0;
    int s = (t.length >= 8) ? readSecond(t, start + 6) : 0;
    int m = (t.length >= 4) ? readMinute(t, start + 3) : 0;
    int h = readHour(t, start);
    return new Time(h, m, s, ms, us);
  }
}

/// A Time Zone Offset.
class TimeZone {
  /// The symbol for specifying a Universal Time Coordinate (UTC).
  static const String utcSymbol = "Z";

  /// The local [TimeZoneOffset] from UTC.
  static final Duration localOffset = DcmDateTime.startTime.timeZoneOffset;

  /// Returns the current time in the Local Time Zone.
  static final TimeZone local = new TimeZone(localOffset);

  /// Returns the current time as a UTC.
  static final TimeZone utc = new TimeZone(new Duration(minutes: 0));

  /// The [TimeZone].
  Duration offsetInMinutes;

  /// Creates a new [TimeZone] value;
  TimeZone(this.offsetInMinutes);

  /// Create a [TimeZone] of an offset in minutes.
  TimeZone.fromMinutes(int min) : offsetInMinutes = new Duration(minutes: min);

  /// Creates a [TimeZone] value from a Dart [DateTime].
  TimeZone.fromDateTime(DateTime dt) : offsetInMinutes = dt.timeZoneOffset;

  /// Creates a [TimeZone] with the specified offset in [hours] and [minutes].
  factory TimeZone.fromOffset(int sign, int hour, int minute) {
    assert(isValidSign(sign));
    assert(isValidHour(hour));
    assert(isValidMinute(minute));
    return new TimeZone(new Duration(minutes: (sign * (hour * 60)) + minute));
  }

  /// Returns [true] is [this] is equal to [other].
  @override
  bool operator ==(Object other) => (other is TimeZone) && (offsetInMinutes == other.offsetInMinutes);

  /// Returns [true] is [this] is greater than [other].
  bool operator <(Object other) => (other is TimeZone) && offsetInMinutes < other.offsetInMinutes;

  /// Returns [true] is [this] is less than [other].
  bool operator >(Object other) => (other is TimeZone) && offsetInMinutes > other.offsetInMinutes;

  /// Returns the [sign] of the [TimeZoneOffset].
  int get sign => (offsetInMinutes.isNegative) ? -1 : 1;

  /// Returns the [TimeZone] in hours.
  int get inHours => offsetInMinutes.inHours;

  /// Returns the absolute value of [TimeZone] hours.
  int get hours => offsetInMinutes.inHours.abs();

  /// Returns the [TimeZone] in minutes.
  int get inMinutes => offsetInMinutes.inMinutes;

  /// Returns the absolute value of [TimeZone] minutes.
  int get minutes => offsetInMinutes.inMinutes.abs() - (hours * 60);

  /// Returns [true] if the [TimeZoneOffset] is negative.
  bool get isNegative => offsetInMinutes.isNegative;

  /// Returns [true] if the [TimeZoneOffset] is zero, i.e. it is the UTC [TimeZone].
  bool get isUtc => inMinutes == 0;

  /// Returns the [TimeZone] as an offset from UTC in Internet format.
  String get offsetString => (isNegative) ? '-$hours\:$minutes' : '+$hours\:$minutes';

  /// Returns the [TimeZone] as an offset from UTC in DICOM format.
  String get dcmString => offsetString;

  /// Returns a hashCode for [this].
  @override
  int get hashCode => offsetInMinutes.hashCode;

  /// Return the UTC symbol (Z) if the [TimeZone] is UTC; otherwise,
  /// returns the offset from UTC of [this] as a [String].
  @override
  String toString() => (isUtc) ? "Z" : offsetString;

  /// Creates a [TimeZone] by parsing the specified DICOM format [String].
  static TimeZone dcmParse(String tzo, [int start = 0]) {
    if (start == tzo.length) return local;
    return readTimeZone(tzo, start);
  }

  /// Creates a [TimeZone] by parsing the specified [String].
  static TimeZone parse(String tzo, [int start = 0]) {
    if (start == tzo.length) return local;
    if (tzo[start] == 'Z' || tzo[start] == 'z') return new TimeZone.fromMinutes(0);
    if (tzo[start + 3] == ":") throw "Missing Time Separator(:)";
    return readTimeZone(tzo, start, 1);
  }

}

