// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/constants.dart';

/// Private error handler.
int _error(String type, int val) {
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

  static bool get isInteger => true;

  static get isSigned => true;
  static get isUnsigned => false;

  static int minValue(int lengthInBits) => (1 << (lengthInBits - 1));

  static int maxValue(int lengthInBits) => (1 << (lengthInBits - 1)) - 1;

  /// Returns [true] if [value] is between [min] and [max] inclusive.
  static bool inRange(int min, int value, int max) => (min <= value && value <= max);

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  @deprecated
  static List<int> validate(List<int> vList, _InRange inRange) => listGuard(vList, inRange);

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  static List<int> listGuard(List<int> vList, _InRange inRange) {
    print('vList: $vList');
    for (int i = 0; i < vList.length; i++)
      if ((vList[i] is int) && inRange(vList[i])) {
        return null;
      }
    print('vList: $vList');
    return vList;
  }

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  static bool isValidList(List<int> vList, _InRange inRange) {
    if (listGuard(vList, inRange) == null) return false;
    return true;
  }

  static bool isNotValidList(List<int> vList, _InRange inRange) => !isValidList(vList, inRange);

  //**** hashing support ****
  /// The default hash seed.
  static const int kHashSeed = 17;

  /// The default hash multiplier
  static const int kHashMultiplier = 37;

  // TODO: customize this so it is different on 32 and 64 bit systems
  /// Returns a 64-bit [hashCode] for [Object] [o].
  static int hash(Object o, [int result = kHashSeed]) => hash64(o, kHashSeed);

  /// The 32-bit hash mask.
  static const int k32BitHashMask = 0x3FFFFFFF;

  /// Returns a 32-bit [hashCode] for [Object] [o].
  ///
  /// The sum is truncated to 30 bits to make sure it fits into Dart's small integer type([smi]).
  /// See https://www.dartlang.org/articles/dart-vm/numeric-computation.
  static int hash32(Object o, [int result = kHashSeed]) =>
      (kHashMultiplier * result + o.hashCode) & k32BitHashMask;

  /// The 64-bit hash mask.
  static const int k64BitHashMask = 0x3FFFFFFFFFFFFFFF;

  /// Returns a 64-bit [hashCode] for [Object] [o].
  ///
  /// The sum is truncated to 62 bits to make sure it fits into Dart's small integer type([smi]).
  /// See https://www.dartlang.org/articles/dart-vm/numeric-computation.
  static int hash64(Object o, [int result = kHashSeed]) =>
      (kHashMultiplier * result + o.hashCode) & k64BitHashMask;

  //**** String Utilities ****

  /// Returns [value] as a hexadecimal string of [length] with prefix [prefix].
  @deprecated
  static toHex(int i, [int padding = 0]) => i.toRadixString(16).padLeft(padding, "0");

  /// Returns [value] as a hexadecimal string of [length] with prefix [prefix].
  static hex(int i, [int padding = 0]) => i.toRadixString(16).padLeft(padding, "0");

  /// Returns a [String] in the form of a [List] ("[
  String listToHexString(List<String> list) => "[" + list.join(", ") + "]";

  /// Returns a [List] of hex [Strings] mapped from [list]
  static Iterable<String> listToHex(List<int> list) => list.map(hex);

  /// Returns [value] in kilobytes (KB).
  static toKB(int i) => '${i / kKB}KB';

  /// Returns [value] in megabytes (MB).
  static toMB(int i) => '${i / kMB}MB';

  /// Returns [value] in megabytes (MB).
  static toGB(int i) => '${i / kGB}GB';

  /// Converts an [int] into a [String] of hexadecimal digits.
  ///
  /// Returns a hexadecimal [String] of length [nDigits] with [padLeft] padding,
  /// and a leading [prefix], which defaults to "0x".
  static String format(int i,
      {int radix: 16, int nDigits: -1, String padding: '0', String prefix: '0x'}) {
    String s = i.toRadixString(16);
    s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
    return prefix + s;
  }
}

class Int8 extends Int {
  static const sizeInBits = 8;
  static const sizeInBytes = 1;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int8List emptyList = new Int8List(0);

  static bool inRange(int i) => (min <= i) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int8", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Int16 extends Int {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = -(2 << (sizeInBits - 1));
  static const max = (2 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int16List emptyList = new Int16List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int16", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Int32 extends Int {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int32List emptyList = new Int32List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int32", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Int64 extends Int {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int64List emptyList = new Int64List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int64", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Uint extends Int {
  static const min = 0;

  static get isSigned => false;
  static get isUnsigned => true;

  static int max(int sizeInBits) => (1 << sizeInBits) - 1;

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);
}

class Uint8 extends Uint {
  static const sizeInBits = 8;
  static const sizeInBytes = 1;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint8List emptyList = new Uint8List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint8", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Uint16 extends Uint {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint16List emptyList = new Uint16List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint16", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Uint32 extends Uint {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint32List emptyList = new Uint32List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint32", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

class Uint64 extends Uint {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = 0;
  static const max = (1 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint64List emptyList = new Uint64List(0);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint64", i);

  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i, [int padding = 0]) => Int.hex(i, padding);

  @deprecated
  static List<int> validate(List<int> vList) => Int.listGuard(vList, inRange);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> listGuard(List<int> vList) {
    if (vList == null || vList.length == 0) return emptyList;
    return Int.listGuard(vList, inRange);
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);
}

/// General [int] utility functions.

/// Converts an [int] into a [String] of hexadecimal digits.
///
/// Returns a hexadecimal [String] of length [nDigits] with [padLeft] padding,
/// and a leading [prefix], which defaults to "0x".
@deprecated
String intToHex(int i, [int nDigits = -1, String padding = '0', String prefix = '0x']) {
  String s = i.toRadixString(16);
  s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
  return prefix + s;
}

/// Returns a [List] of hex [Strings] mapped from [list]
@deprecated
Iterable<String> intListToHex(List<int> list) => list.map(intToHex);

@deprecated

/// Returns a [String] in the form of a [List] ("[
String hexListToString(List<String> list) => "[" + list.join(", ") + "]";

/// Returns [true] if [value] is between [min] and [max] inclusive.
@deprecated
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
