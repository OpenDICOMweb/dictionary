// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/constants.dart';

/// Private error handler.
int _error(String type, int val)  {
  throw new RangeError('$type: $val out of range');
}

/// The [Type] of Range checkers.
typedef bool _InRange(int val);

class Int {
  //**** General Constants ****
  static const kKB = 1024;
  static const kMB = kKB * 1024;
  static const kGB = kMB * 1024;
  static const kTB = kGB * 1024;

  /// The maximum size of Dart's small integers on 32 and 64 bit systems.
  static const smi32Mask = 0x3FFFFFFF;
  static const smi64Mask = 0x3FFFFFFFFFFFFFFF;

  static int minValue(int lengthInBits) => (1 << (lengthInBits - 1));

  static int maxValue(int lengthInBits) => (1 << (lengthInBits - 1)) - 1;

  /// Returns [value] as a hexadecimal string of [length] with prefix [prefix].
  static toHex(int i, [int padding = 0]) => i.toRadixString(16).padLeft(padding, "0");

  /// Returns a [List<int>] if all values are [int], otherwise null.
  static List<int> validate(List<int> vList, _InRange inRange) {
    print('vList: $vList');
    for (int i = 0; i < vList.length; i++)
      if ((vList[i] is int) && inRange(vList[i])) {
        return null;
      }
    print('vList: $vList');
    return vList;
  }

  /// Converts an [int] into a [String] of hexadecimal digits.
  ///
  /// Returns a hexadecimal [String] of length [nDigits] with [padLeft] padding,
  /// and a leading [prefix], which defaults to "0x".
  static String format(int i,
                       {int radix: 16,
                       int nDigits: -1,
                       String padding: '0',
                       String prefix: '0x'}) {
    String s = i.toRadixString(16);
    s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
    return prefix + s;
  }

  /// Returns a [List] of hex [Strings] mapped from [list]
  static Iterable<String> listToHex(List<int> list) => list.map(toHex);
}

class Int8 extends Int {
  static const sizeInBits = 8;
  static const sizeInBytes = 1;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (min <= i) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int8", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  /// Returns a [vList] if all values are valid Uint32, otherwise null.
  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}


class Int16 extends Int {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = -(2 << (sizeInBits - 1));
  static const max = (2 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int16", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}

class Int32 extends Int {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int32", i);

  static String toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static Int32List validate(List<int> vList) => Int.validate(vList, inRange);
}

class Int64 extends Int {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = - (1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int64", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}


class Uint extends Int {
  static const min = 0;

  static int max(int sizeInBits) => (1 << sizeInBits) - 1;

  static String toHex(int i) => Int.toHex(i);
}

class Uint8 extends Uint {
  static const sizeInBits = 8;
  static const sizeInBytes = 1;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint8", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}

class Uint16 extends Uint {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint16", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}

class Uint32 extends Uint {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint32", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static Uint32List validate(Uint32List vList) => Int.validate(vList, inRange);
}

class Uint64 extends Uint {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = 0;
  static const max = (1 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint64", i);

  static toHex(int i, [int padding = 0]) => Int.toHex(i, padding);

  static List<int> validate(List<int> vList) => Int.validate(vList, inRange);
}

/// General [int] utility functions.

/// Converts an [int] into a [String] of hexadecimal digits.
///
/// Returns a hexadecimal [String] of length [nDigits] with [padLeft] padding,
/// and a leading [prefix], which defaults to "0x".
String intToHex(int i, [int nDigits = -1, String padding = '0', String prefix = '0x']) {
  String s = i.toRadixString(16);
  s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
  return prefix + s;
}

/// Returns a [List] of hex [Strings] mapped from [list]
Iterable<String> intListToHex(List<int> list) => list.map(intToHex);

/// Returns a [String] in the form of a [List] ("[
String hexListToString(List<String> list) => "[" + list.join(", ") + "]";

/// Returns [true] if [value] is between [min] and [max] inclusive.
bool inRange(int min, int value, int max) => ((min <= value) && (value <= max));

class Range {
  final min;
  final max;

  const Range(this.min, this.max);

  bool call(int i) => ((i >= min) && (i <= max));

  static const uint8Min = 0;
  static const uint8Max = 255;
  static const isUint8 = const Range(uint8Min, uint8Max);

  static const int8Min = -128;
  static const int8Max = 127;
  static const isInt8 = const Range(int8Min, int8Max);

  static const uint16Min = 0;
  static const uint16Max = (1 << 16) - 1;
  static const isUint16 = const Range(uint16Min, uint16Max);

  static const int16Min = -(1 << 15);
  static const int16Max = (1 << 15) - 1;
  static const isInt16 = const Range(int16Min, int16Max);

  static const uint32Min = 0;
  static const uint32Max = (1 << 32) - 1;
  static const isUint32 = const Range(uint32Min, uint32Max);

  static const int32Min = -(1 << 31);
  static const int32Max = (1 << 31) - 1;
  static const isInt32 = const Range(int32Min, int32Max);

  static const uint64Min = 0;
  static const uint64Max = (1 << 64) - 1;
  static const isUint64 = const Range(uint64Min, uint64Max);

  static const int64Min = -(1 << 63);
  static const int64Max = (1 << 63) - 1;
  static const isInt64 = const Range(int64Min, int64Max);
}


