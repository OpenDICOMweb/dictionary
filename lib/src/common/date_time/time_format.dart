// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: complete implementing Time formats for Date, Time, and DcmDateTime
/// Time formats for [String] output.
enum TimeFormatType {
  /// local time with no [TimeZone] suffix
  local,

  /// Local Date/Time format with Time Zone suffix;
  localTZ,

  /// Coordinated Universal Time - Time Zone represented by the suffix 'Z'.
  utc,

  /// DICOM Date/Time format.
  dcm,

  /// UTC date/time in DICOM format
  utcDcm
}


//Flush
//** Not used
//bool _isDot(String s) => s == ".";

String toChars(int value, [int nChars = 2, String padding = '0']) =>
    value.toString().padLeft(nChars, padding);

class TimeFormat {
  bool has24Hours = true;
  DateTime dt;
  String separator = "T";

  String get year => toChars(dt.year, 4);
  String get month => toChars(dt.month);
  String get day => toChars(dt.day);
  String get hour => toChars(dt.hour);
  String get minute => toChars(dt.minute);
  String get second => toChars(dt.second);
  String get millisecond => toChars(dt.millisecond, 3);
  String get microsecond => toChars(dt.microsecond, 3);

  String get date => '$year-$month-$day';
  String get time => '$hour:$minute:$second';
  String get dateTime => '$date$separator$time';

  String get timeMS => '$hour:$minute:$second.$millisecond';
  String get timeUS => '$hour:$minute:$second.$millisecond$microsecond';


}

