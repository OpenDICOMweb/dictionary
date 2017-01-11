// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'date.dart';
import 'time.dart';
import 'time_format.dart';
import 'time_zone.dart';
import 'utils.dart';

/// A DICOM DateTime class, which handles DICOM DateTime [DT] Value Representations.
class DcmDateTime {
  static const Time noTime = const Time.empty();

  /// The current [DateTime].
  static final DateTime startTime = new DateTime.now();

  /// The [localTimeZone]
  static final TimeZone localTimeZone = new TimeZone(startTime.timeZoneOffset);

  /// The [DateTime] value of [this].
  final DateTime dateTime;

  /// The [TimeZone] value of [this].
  final TimeZone timeZone;

  /// Creates a [DcmDateTime] in the local time zone.
  DcmDateTime(int y,
              [int mm = 0, int d = 0, int h = 0, int m = 0, int s = 0, int ms = 0, int u = 0, TimeZone tz])
      : dateTime = new DateTime(y, mm, d, h, m, s, ms, u),
        timeZone = (tz == null) ? localTimeZone : tz;

  const DcmDateTime.empty()
      : dateTime = null,
        timeZone = null;

  // Creates a [DcmDateTime] from a [Date], [Time], and [TimeZone].
  DcmDateTime.fromDateAndTime_(Date d, Time t, TimeZone tz)
      : dateTime = new DateTime(
      d.year, d.month, d.day, t.hour, t.minute, t.second, t.millisecond, t.microsecond),
        timeZone = tz;

  /// Create a [DcmDateTime] from a [DateTime} and [TimeZone].
  DcmDateTime._(this.dateTime, [this.timeZone]);

  /// Returns [true] if [this] is equal to [other].
  @override
  bool operator ==(Object other) => (other is DcmDateTime) && (dateTime == other.dateTime);

  /// Returns [true] if [this] is greater than [other].
  bool operator >(Object other) =>
      (other is DcmDateTime) &&
      dateTime.millisecondsSinceEpoch > other.dateTime.millisecondsSinceEpoch;

  /// Returns [true] if [this] is less than [other].
  bool operator <(Object other) =>
      (other is DcmDateTime) &&
      dateTime.millisecondsSinceEpoch > other.dateTime.millisecondsSinceEpoch;

  /// Returns the current [DateTime] as a [DcmDateTime].
  static DcmDateTime get now => new DcmDateTime._(new DateTime.now());

  /// Returns the [year].
  int get year => dateTime.year;

  /// Returns the [month].
  int get month => dateTime.month;

  /// Returns the [day].
  int get day => dateTime.day;

  /// Returns the [hour].
  int get hour => dateTime.hour;

  /// Returns the [minute].
  int get minute => dateTime.minute;

  /// Returns the [second].
  int get second => dateTime.second;

  /// Returns the [millisecond].
  int get millisecond => dateTime.millisecond;

  /// Returns the [microsecond].
  int get microsecond => dateTime.microsecond;

  /// Returns the [fraction]al part of [this] [second].
  int get fraction => ((millisecond * 1000) + microsecond) * 1000000;

  /// Returns a [Date] that corresponds to the date part of [this].
  Date get date => new Date(year, month, day);

  /// Returns a [Time] that corresponds to the time part of [this].
  Time get time => new Time(hour, minute, second, millisecond, microsecond);

  /// Returns a [hashCode] for [this].
  @override
  int get hashCode => dateTime.hashCode;

  String _toDTString([TimeFormatType fmt = TimeFormatType.dcm]) {
    var y = dtString(year, 4);
    var mm = dtString(month, 2);
    var d = dtString(day, 2);
    var h = dtString(hour, 2);
    var m = dtString(minute, 2);
    var s = dtString(second, 2);
    var ms = dtString(millisecond, 3);
    var u = dtString(microsecond, 3);
    var f = '$ms$u';
    f = (f.length == 0) ? "" : '.$f';
    switch (fmt) {
      case TimeFormatType.local:
        return '$y-$mm-$d\T$h:$m:$s$f';
      case TimeFormatType.localTZ:
        var tzo = localTimeZone.toString();
        return '$y-$mm-$d\T$h:$m:$s$f$tzo';
      case TimeFormatType.utc:
        DateTime utc = dateTime.toUtc();
        return utc.toString();
      case TimeFormatType.dcm:
        return '$y$mm$d$h$m$s$f';
      case TimeFormatType.utcDcm:
      //TODO: finish
        return 'TimeFormatType.utcDcm is unimplemented';
      default:
        throw "Invalid Time Format: $fmt";
    }
  }

  /// Returns [this] in UTC format.
  /// Note: UTC does not print with a "T" as a separator
  String toUtc() => _toDTString(TimeFormatType.utc);

  /// Returns [this] in DICOM format.
  String toDcm() => _toDTString(TimeFormatType.dcm);

  /// Returns [this] in DICOM UTC format.
  String toUtcDcm() => _toDTString(TimeFormatType.utcDcm);

  /// Returns the [LocalTimeZone] for [this].
  String toLocalTZ() => _toDTString(TimeFormatType.localTZ);

  @override
  String toString() => _toDTString(TimeFormatType.local);

  /// Returns [true] if the arguments form a valid [DcmDateTime].
  static bool isValid(int y,
                      [int mm = 1, int d = 1, int h = 0, int m = 0, int s = 0, int ms = 0, int us = 0]) =>
      isDateTime(y, mm, d, h, m, s, ms, us);

  /// Parses the [String] specified by the arguments as a DICOM format
  /// DateTime [String]  (yyyyMMddhhmmss.ffffffMhhmm), and
  /// returns the corresponding [DcmDateTime].
  //TODO: Make sure TimeZone(s) are being handled correctly
  // in particulate when parseing a DT with a tzOffset convert it to local time.
  static DcmDateTime dcmParse(String ddt, [int start = 0]) {
    Date.dcmParse(ddt, start);
    Time.dcmParse(ddt, start + 8);
    TimeZone tz = (ddt.length == 26) ? TimeZone.parse(ddt, 21) : null;
    int us = (ddt.length >= 21) ? parseMicrosecond(ddt, 18) : null;
    int ms = (ddt.length >= 10) ? parseMillisecond(ddt, 15) : null;
    // if (parseDot(ddt.substring(14, 15)) throw "Invalid decimal point";
    int s = (ddt.length >= 6) ? parseSecond(ddt, 12) : null;
    int m = (ddt.length >= 4) ? parseMinute(ddt, 10) : null;
    int h = (ddt.length >= 10) ? parseHour(ddt, 8) : null;
    int mm = (ddt.length >= 6) ? parseMonth(ddt, 4) : null;
    int y = parseYear(ddt);
    int d = (ddt.length >= 6) ? parseDay(y, mm, ddt, 6) : null;
    DateTime dt = new DateTime(y, mm, d, h, m, s, ms, us);
    return new DcmDateTime._(dt.add(tz.offsetInMinutes), tz);
  }

  static final RegExp tzMarks = new RegExp('[\-+Zz]');

  /// Parses the [String] specified by the arguments as a DICOM format
  /// DateTime [String], and returns the corresponding [DcmDateTime].
  //TODO: Make sure TimeZone(s) are being handled correctly
  // in particulate when reading a DT with a tzOffset convert it to local time.
  static DcmDateTime parse(String ddt, [int start = 0, int end]) {
    if (end == null) end = ddt.length;
    if (end > 26) return null;
    int tzStart = ddt.lastIndexOf(tzMarks);

    TimeZone tz = (ddt.length == 26) ? TimeZone.parse(ddt, tzStart) : null;
    int us = (ddt.length >= 21) ? parseMicrosecond(ddt, 18) : null;
    int ms = (ddt.length >= 10) ? parseMillisecond(ddt, 15) : null;
    // if (parseDot(ddt.substring(14, 15)) throw "Invalid decimal point";
    int s = (ddt.length >= 6) ? parseSecond(ddt, 12) : null;
    int m = (ddt.length >= 4) ? parseMinute(ddt, 10) : null;
    int y = parseYear(ddt);
    int mm = parseMonth(ddt, 4);
    int d = parseDay(y, mm, ddt, 6);
    int h = parseHour(ddt, 8);
    DateTime dt = new DateTime(y, mm, d, h, m, s, ms, us);
    return new DcmDateTime._(dt.add(tz.offsetInMinutes), tz);
  }
}
