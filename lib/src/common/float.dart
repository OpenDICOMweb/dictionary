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
  static List<double> validate(List<double> vList, _InRange inRange) {
    print('vList: $vList');
    for (int i = 0; i < vList.length; i++)
      if ((vList[i] is double) && inRange(vList[i])) {
        print('vList: $vList');
        return vList;
      }
    return null;
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
      inRange(min, val, max) ? val : _floatError("Float32", min, val, max);

  /// Returns a [vList] if all values are valid Uint32, otherwise null.
  static Float32List validate(Float32List vList) =>
      Float.validate(vList,   inRange);
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
      inRange(min, val, max) ? val : _floatError("Float64", min, val, max);
}
