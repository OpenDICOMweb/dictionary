// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'time_format.dart';
import 'utils.dart';

/// A Date class, which handles DICOM Date [DA] Value Representations.
class Date {
  static const Date noTime = const Date.empty();

  //TODO: what should the default values be
  static int _minYear = 0;
  static int _maxYear = 3000;

  /// A Dart SDK [DateTime]
  final DateTime date;

  /// Creates a new Date.
  Date(int year, int month, int day) : date = checkDate(year, month, day);

  const Date.empty() : date = null;

  /// Returns the [year]
  int get year => date.year;

  /// Returns the [month].
  int get month => date.month;

  /// Returns the [day].
  int get day => date.day;

  /// Returns [true] if [this] is equal to [other]; otherwise false.
  @override
  bool operator ==(Object other) => (other is Date) && (date == other.date);

  /// Returns [true] if [this] is greater than [other]; otherwise false.
  bool operator >(Object other) =>
      (other is Date) && date.millisecondsSinceEpoch > other.date.millisecondsSinceEpoch;

  /// Returns [true] if [this] is less than [other]; otherwise false.
  bool operator <(Object other) =>
      (other is Date) && date.millisecondsSinceEpoch > other.date.millisecondsSinceEpoch;

  /// Returns a [hashCode] for [this].
  @override
  int get hashCode => date.hashCode;

  String _toDateString([TimeFormatType fmt = TimeFormatType.dcm]) {
    var y = dtString(year, 4);
    var mm = dtString(month, 2);
    var d = dtString(day, 2);
    switch (fmt) {
      case TimeFormatType.dcm:
        return '$y$mm$d';
      case TimeFormatType.local:
      case TimeFormatType.utc:
        return '$y-$mm-$d';
      default:
        throw "Invalid Date Format: $fmt";
    }
  }

  /// Returns [this] as a [String] in DICOM format.
  String toDcmString() => '${dtString(year, 4)}${dtString(month, 2)}${dtString(day, 2)}';

  /// Returns [this] as a [Uint8List] containing the [codeUnits] in DICOM format.
  Uint8List toDcmBytes() => _toDateString(TimeFormatType.dcm).codeUnits;

  /// Returns [this] as a [String].
  @override
  String toString() => _toDateString(TimeFormatType.local);

  //**** Static Methods ****

  Date get now {
    DateTime dt = new DateTime.now();
    return new Date(dt.year, dt.month, dt.day);
  }

  static String today([String separator = ""]) {
    String s = separator;
    DateTime dt = new DateTime.now();
    return '${dt.year}$s${dt.month}$s${dt.day}';
  }

  static bool isDate(int y, int m, int d) =>
      isYear(y) && isMonth(m) && isDay(y, m, d);

  static check(int y, int m, int d) => checkDate(y, m, d);

  /// Returns a [Date] parsed from a [Uint8List] in DICOM format.
  static Date dcmParseBytes(Uint8List bytes, [int start = 0, int end]) {
    if (end == null) end = bytes.length;
    String s = bytes.sublist(start, end).toString();
    return dcmParse(s);
  }

  /// Returns a [Date] parsed from a [String] in DICOM format.
  static Date dcmParse(String s, [int start = 0]) {
    if ((s != null) && (s.length >= start + 8)) {
      return  parseDate(s, start);
    }
    return null;
  }

  /// Return a [Date] by parsing a [String] in Internet format. See [RFC3339].
  static Date parse(String s, [int start = 0]) {
    if (s.length < start + 10) throw "Invalid Date String(${s.substring(start)}";
    int y = parseYear(s, 0);
    if (s[start+4] != '-') return null;
    int m = parseMonth(s, 5);
    if (s[start+6] == "-") return null;
    int d = parseDay(y, m, s, start+8);
    return new Date(y, m, d);
  }

  /// The minimum valid year.
  static get minYear => _minYear;

  /// The maximum valid year.
  static get maxYear => _maxYear;

  /// Sets the valid year range.
  //TODO: add max upper and lower bound
  static bool setYearRange(int minYear, int maxYear) {
    _minYear = minYear;
    _maxYear = maxYear;
    return true;
  }
}

