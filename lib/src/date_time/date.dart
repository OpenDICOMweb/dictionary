// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.


import 'package:dictionary/src/string/dcm_parse.dart';

import 'dcm_date_time.dart';
import 'time.dart';

class Date {
  final DateTime date;

  Date(int year, [int month = 0, int day = 0])
      : date = new DateTime(year, month, day);

  Date.fromDateTime(this.date);

  int get year => date.year;
  int get month => date.month;
  int get day => date.day;

  String get y => digits4(year);
  String get m => digits2(month);
  String get d => digits2(day);
  String get dcm => '$y$m$d';

  DcmDateTime add(Time time) =>
      new DcmDateTime.fromDateTime(date.add(time.time));

  DcmDateTime subtract(Time time) =>
      new DcmDateTime.fromDateTime(date.subtract(time.time));

  bool isValid(String s) => isValidDcmDateString(s, 0, s.length);

  String issues(String s) => getDcmDateIssues(s, 0, s.length);

  @override
  String toString() => '$y-$m-$d';

  static bool isValidDateString(String dateString) =>
    isValidDcmDateString(dateString, 0, dateString.length);

  static Date parse(String dateString) {
    DateTime dt = parseDcmDateString(dateString, 0, dateString.length);
    return (dt == null) ? null : new Date.fromDateTime(dt);
  }
}
