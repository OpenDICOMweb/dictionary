// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/date_time/utils.dart';

void main() {
  var date = "19520102";
  var time = "010203.000004";
  var dateTime = "19520102010203.000004+0530";
  print('isValidDateString: ${isValidDateString(date)}');
  print('isValidTimeString: ${isValidTimeString(time)}');
  print('year: ${readYear(date)}');
  print('month: ${readMonth(date, 4)}');
  print('day: ${readDay(1952, 1, date, 6)}');
  print('date: ${readDate(date)}');

  print('hour:  ${readHour(time, 0)}');
  print('minute: ${readMinute(time, 2)}');
  print('second: ${readSecond(time, 4)}');
  print('millisecond: ${readMillisecond(time, 7)}');
  print('microsecond: ${readMicrosecond(time, 10)}');
  print('TZSign: ${readTZSign(time, 13)}');
  print('TZHour: ${readTZHour(time, 14)}');
  print('TZMinute: ${readTZMinute(time, 16)}');


  var fractionNoTZO = [".123456", ".12345", ".1234", ".123", ".12", ".1"];
  for (int i = 0; i < fractionNoTZO.length; i++) {
    print('Fraction: ${fractionNoTZO[i]}');
    print('Fraction: ${readFraction(fractionNoTZO[i], 0)}');
  }

  var fractionTZO = [
    ".123456+0000",
    ".12345-1215",
    ".1234+1230",
    ".123-1245",
    ".12+1200",
    ".1-0015"
  ];
  for (int i = 0; i < fractionTZO.length; i++) {
    print('Fraction: ${fractionTZO[i]}');
    print('Fraction: ${readFraction(fractionTZO[i], 0)}');
  }

  var tzo = [
    "+0000",
    "-1215",
    "+1230",
    "-1245",
    "+1200",
    "-0015"
  ];
  for (int i = 0; i < fractionTZO.length; i++) {
    print('TZO: ${tzo[i]}');
    print('TZ: ${readTimeZone(tzo[i], 0)}');
  }
}
