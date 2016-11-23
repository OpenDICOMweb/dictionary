// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/constants.dart';

/// Floating Point Data Types

//TODO: need work.

/// The [Type] of Range checkers.
typedef bool _InRange(double val);

double _floatError(String type, double min, double val, double max) {
  throw new RangeError('$type: out of range (min <= val <= max');
}

class Float {
  static String get type => "Float";

  static bool inRange(double min, double val, double max) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(min, val, max) ? val : _floatError(type, min, val, max);


  /// Returns a [List<int>] if all values are [int], otherwise null.
  @deprecated
  static List<double> validate(List<double> values, _InRange inRange) =>
      listGuard(values, inRange);

  /// Returns a [List<int>] if all values are [int], otherwise null.
  static List<double> listGuard(List<double> values, _InRange inRange) {
    print('values: $values');
    for (int i = 0; i < values.length; i++)
      if ((values[i] is double) && inRange(values[i])) {
        print('values: $values');
        return values;
      }
    return null;
  }

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  static bool isValidList(List<double> vList, _InRange inRange) {
    if (listGuard(vList, inRange) == null) return false;
    return true;
  }

  static bool isNotValidList(List<double> vList, _InRange inRange) =>
      !isValidList(vList, inRange);
}

class Float32 extends Float {
  static const int sizeInBits = 32;
  static const int sizeInBytes = 4;
  //TODO: test
  static const min = 0x80800000;
  //TODO: test
  static const max = 0x7F7FFFFF;
  //TODO: test
  static const pZero = 0x00000000;
  //TODO: test
  static const mZero = 0x80000000;
  //TODO
  static const pInfinity = 0x7F800000;
  //TODO
  static const nInfinity = 0xFF800000;
  //TODO
  static const qNaN = 0x7FC00000;
  //TODO
  static const sNaN = 0x7FC00000;
  static const int maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const int maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Float32List emptyList = new Float32List(0);

  static bool inRange(double val) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(val) ? val : _floatError("Float32", min, val, max);

  /// Returns a [values] if all values are valid Uint32, otherwise null.
  @deprecated
  static Float32List validate(Float32List values) {
    if ((values == null) || (values.length == 0)) return emptyList;
    return Float.listGuard(values, inRange);
  }

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<double> listGuard(List<double> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Float.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<double> vList) =>
      (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<double> vList) =>
      !isValidList(vList);
}

class Float64 extends Float {
  static const name = "Float64";
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  //TODO: test
  static const min = 0x8010000000000000;
  //TODO: test
  static const max = 0x7FEFFFFFFFFFFFFF;
  //TODO: test
  static const pZero = 0x0000000000000000;
  //TODO: test
  static const mZero = 0x8000000000000000;
  //TODO
  static const pInfinity = 0x7FF0000000000000;
  //TODO
  static const nInfinity = 0xFFF0000000000000;
  //TODO
  static const qNaNmin   = 0x7FF8FFFFFFFFFFFF;
  //TODO
  static const qNaNmax = 0x7FFFC00000000000;
  //FIX wrong
  static const sNaNmin = 0x7FFF800000000001;
  //FIX wrong
  static const sNaNmax = 0x7FFFBFFFFFFFFFFF;
  static const maxShortLength = kMaxShortLengthInBytes - sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes - sizeInBytes;
  static final Float64List emptyList = new Float64List(0);

  static bool inRange(double val) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(val) ? val : _floatError("Float64", min, val, max);


  /// Returns a [values] if all values are valid Uint32, otherwise null.
  @deprecated
  static Float64List validate(Float64List values) {
    if ((values == null) || (values.length == 0)) return emptyList;
    return Float.listGuard(values, inRange);
  }

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<double> listGuard(List<double> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Float.listGuard(vList, inRange);
  }
  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<double> vList) =>
      (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<double> vList) =>
      !isValidList(vList);

}
