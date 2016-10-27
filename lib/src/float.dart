// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/constants.dart';

/// Floating Point Data Types
///
//TODO: need serious work.

double floatError(String type, double min, double val, double max) {
  throw new RangeError('$type: out of range (min <= val <= max');
}

class Float {
  static String get type => "Float";

  static bool inRange(double min, double val, double max) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(min, val, max) ? val : floatError(type, min, val, max);

  //TODO:
  static toHex(int i, [int padding = 0]) => throw "unimplemented";

  /// Converts an [int] into a [String] of hexadecimal digits.
  ///
  /// Returns a hexadecimal [String] of length [nDigits] with [padLeft] padding,
  /// and a leading [prefix], which defaults to "0x".
  //TODO:
  static String format(int i,
      {int radix: 16, int nDigits: -1, String padding: '0', String prefix: '0x'}) {
    String s = i.toRadixString(16);
    s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
    return prefix + s;
  }
}

class Float32 extends Float {
  static const int sizeInBits = 32;
  static const int sizeInBytes = 4;
  //TODO: test
  static const min = 0xFFFFFFFF;
  //TODO: test
  static const max = 0x7FFFFFFF;
  static const int maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const int maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(double min, double val, double max) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(min, val, max) ? val : floatError("Float32", min, val, max);
}

class Float64 extends Float {
  static const name = "Float64";
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  //TODO: test
  static const min = 0xFFFFFFFFFFFFFFFF;
  //TODO: test
  static const max = 0x7FFFFFFFFFFFFFFF;
  static const maxShortLength = kMaxShortLengthInBytes - sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes - sizeInBytes;

  static bool inRange(double min, double val, double max) => (val >= min) && (val <= max);

  static double guard(double min, double val, double max) =>
      inRange(min, val, max) ? val : floatError("Float64", min, val, max);
}
