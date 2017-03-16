// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

import 'package:dictionary/src/string/dcm_parse.dart';

class DcmDateTime {
  static const int minLength = 4;
  static const int maxLength = 26;
  final DateTime dt;

  DcmDateTime(int year,
      [int month = 0,
      int day = 0,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : dt = new DateTime(
            year, month, day, hour, minute, second, millisecond, microsecond);

  DcmDateTime.fromDateTime(this.dt);
  DcmDateTime.now() : dt = new DateTime.now();
  DcmDateTime.today() : dt = new DateTime.now();

  int get year => dt.year;
  int get month => dt.month;
  int get day => dt.day;

  int get hour => dt.hour;
  int get minute => dt.minute;
  int get second => dt.second;
  int get millisecond => dt.millisecond;
  int get microsecond => dt.microsecond;
  int get fraction => (dt.millisecond * 1000) + dt.microsecond;

  String get y => digits4(year);
  String get m => digits2(month);
  String get d => digits2(day);

  String get h => digits2(hour);
  String get mm => digits2(minute);
  String get s => digits2(second);
  String get ms => digits3(millisecond);
  String get us => digits3(microsecond);
  String get f => digits6(millisecond * 1000 + microsecond);

  String get dcm => (fraction == 0) ? '$y$m$d$h$mm$s' : '$y$m$d$h$m$s.$f';

  bool isValid(String s) => isValidDcmDateTimeString(s, 0, s.length);

  String issues(String s) => getDcmDateTimeIssues(s, 0, s.length);

  @override
  String toString() => (fraction == 0) ? '$h:$m:$s' : '$h:$m:$s.$f';

  //Note: uses the DateTime of 1BCE
  static final DateTime isValidDateTimeValue = new DateTime(-1);

  static DcmDateTime parse(String timeString) {
    var dt = parseDcmDateTimeString(timeString, 0, timeString.length);
    return (dt == null) ? null : new DcmDateTime.fromDateTime(dt);
  }
}
