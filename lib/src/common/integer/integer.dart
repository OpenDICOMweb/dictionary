// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/common/constants.dart';
import 'package:dictionary/src/dicom/constants.dart';

//TODO: decide if [view] interface should be  view(TypedData td, offsetInBytes, length)
//TODO: add oib as standard local variable name for offsetInBytes.
//TODO: add lib as standard local variable name for lengthInBytes.

/// Private error handler.
int _error(String type, int val) => throw new RangeError('$type: $val out of range');

/// The [Type] of Range checkers.
typedef bool _InRange(int val);

class Int {
  //TODO: move these to common/src/constants.dart

  /// The maximum size of Dart's small integers on 32 and 64 bit systems.
  static const smi32Mask = 0x3FFFFFFF;
  static const smi64Mask = 0x3FFFFFFFFFFFFFFF;

  static bool get isInteger => true;

  static get isSigned => true;
  static get isUnsigned => false;

  static int minValue(int lengthInBits) => (1 << (lengthInBits - 1));

  static int maxValue(int lengthInBits) => (1 << (lengthInBits - 1)) - 1;

  static bool equal(List<int> a, List<int> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  /// Returns [true] if [value] is between [min] and [max] inclusive.
  static bool inRange(int min, int value, int max) => (min <= value && value <= max);

  static bool checkValueInRange(int i, List<String> issues, int min, int max) {
    if (i < min) {
      issues.add('Value $i is less than the minimum($min) allowed value.');
      return false;
    }
    if (i > max) {
      issues.add('Value $i is greater than the maximum($min) allowed value.');
      return false;
    }
    return true;
  }

  /// _Deprecated_: Use checkList instead.
  @deprecated
  static List<int> listGuard(List<int> vList, _InRange inRange, int minLength, int maxLength) =>
      checkList(vList, inRange, minLength, maxLength);

  /// Returns a [List<int>] if all values are [int] and [inRange], otherwise [null].
  static List<int> checkList(List<int> vList, _InRange inRange, int minLength, int maxLength) {
    if (vList is! TypedData) return null;
    return _checkList(vList, inRange, minLength, maxLength);
  }

  /// Returns a [List<int>] if all values are [int] and [inRange], otherwise [null].
  static List<int> _checkList(List<int> vList, _InRange inRange, int min, int max) {
    if (vList == null || vList.length < min || max < vList.length) return null;
    for (int i = 0; i < vList.length; i++) if (!inRange(vList[i])) return null;
    return vList;
  }

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  static bool isValidList(List<int> vList, _InRange inRange, int minLength, int maxLength) {
    if (checkList(vList, inRange, minLength, maxLength) == null) return false;
    return true;
  }

  static bool isNotValidList(List<int> vList, _InRange inRange, int minLength, int maxLength) =>
      !isValidList(vList, inRange, minLength, maxLength);

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

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => i.toRadixString(16).padLeft(padding, "0");

  /// Returns [value] as a hexadecimal string of [length] with prefix [prefix].
  static hex(int i, [int padding = 0, prefix = '0x']) =>
      prefix + i.toRadixString(16).padLeft(padding, "0");

  /// Returns a [List] of hex [Strings] mapped from [list]
  static Iterable<String> listToHex(List<int> list) => list.map(hex);

  /// Returns a [String] in the form of a [List] of [hex] [String]s
  String listToHexString(List<String> list) => "[" + list.join(", ") + "]";

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

  static equal(Int8List a, Int8List b) => Int.equal(a, b);

  static bool inRange(int i) => (min <= i) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int8", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated_: Use [hex] instead.
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 2);

  /// _Deprecated: Use [checkList] instead._
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Int8.checkList] instead.
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => true;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 0;

  static int toLength(int lengthInBytes) => lengthInBytes;

  static int toLengthInBytes(int length) => length;

  /// Returns a [Int8List.view] of [bytes].
  ///
  /// Note: [Int8List]s are always aligned.
  static Int8List viewOfBytes(Uint8List bytes, [int offsetInBytes = 0, int length]) {
    int oib =
        RangeError.checkValidRange(0, bytes.offsetInBytes + offsetInBytes, bytes.lengthInBytes);
    length = RangeError.checkValidRange(0, length, bytes.lengthInBytes);
    return bytes.buffer.asInt8List(oib, length);
  }
}

class Int16 extends Int {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = -(2 << (sizeInBits - 1));
  static const max = (2 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int16List emptyList = new Int16List(0);

  static equal(Int16List a, Int16List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int16", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 4);

  /// _Deprecated_: Use [Int.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Int16.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 1;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns an [Int16List.view] of [list].
  static Int16List view(Int16List list, [int offsetInBytes = 0, int length]) =>
      viewOfBytes(list.buffer.asUint8List());

  /// Returns a [Int16List] created from the [Uint8List] [bytes]. If [offsetInBytes]
  /// is aligned on an 2-byte boundary, then a [Int16List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Int16List].
  static Int16List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = toLength(bytes.lengthInBytes);
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Int16List nList = new Int16List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getInt16(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...oib: ${bytes.offsetInBytes}, length: $length');
    return bytes.buffer.asInt16List(bytes.offsetInBytes, length);
  }

  static toInt16List(List<int> list) => (list is Int16List) ? list : new Int16List.fromList(list);
}

class Int32 extends Int {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int32List emptyList = new Int32List(0);

  static equal(Int32List a, Int32List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int32", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 8);

  /// _Deprecated_: Use [Int32.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Int32.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 2;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns an [Int32List.view] of [list].
  static Int32List view(Int32List list, [int offsetInBytes = 0, int length]) =>
      viewOfBytes(list.buffer.asUint8List());

  /// Returns a [Int32List] created from [bytes]. If [offsetInBytes] is aligned
  /// on an 2-byte boundary, then a [Int32List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Int32List].
  static Int32List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Int32List nList = new Int32List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getInt32(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asInt32List(bytes.offsetInBytes, length);
  }

  static toInt32List(List<int> list) => (list is Int32List) ? list : new Int32List.fromList(list);
}

class Int64 extends Int {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = -(1 << (sizeInBits - 1));
  static const max = (1 << (sizeInBits - 1)) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Int64List emptyList = new Int64List(0);

  static equal(Int64List a, Int64List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Int64", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 16);

  /// _Deprecated_: Use [Int64.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 3;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns an [Int64List.view] of [list].
  static Int64List view(Int64List list, [int offsetInBytes = 0, int length]) =>
      viewOfBytes(list.buffer.asUint8List());

  /// Returns a [Int64List] created from the [Uint8List] [bytes]. If [offsetInBytes]
  /// is aligned on an 2-byte boundary, then a [Int64List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Int64List].
  static Int64List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Int64List nList = new Int64List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getInt64(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asInt64List(bytes.offsetInBytes, length);
  }

  static toInt64List(List<int> list) => (list is Int64List) ? list : new Int64List.fromList(list);
}

class Uint extends Int {
  static const min = 0;

  static get isSigned => false;
  static get isUnsigned => true;

  static int max(int sizeInBits) => (1 << sizeInBits) - 1;

  /// _Deprecated: Use [Int.hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  /// _Deprecated: Use [Int.hex] instead._
  @deprecated
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

  static equal(Uint8List a, Uint8List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint8", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 2);

  /// _Deprecated_: Use [Uint8.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Uint8.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint8, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => true;

  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 0;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns a [Uint8List] view of [bytes].
  ///
  /// Note: [Uint8List] are always aligned.
  static Uint8List viewOfBytes(Uint8List bytes, [int offsetInBytes = 0, int length]) {
    int lIB = bytes.lengthInBytes;
    int oIB = RangeError.checkValidRange(0,  bytes.offsetInBytes + offsetInBytes, lIB);
    length = RangeError.checkValidRange(0, length, lIB);
    return bytes.buffer.asUint8List(oIB, length);
  }
}

class Uint16 extends Uint {
  static const sizeInBits = 16;
  static const sizeInBytes = 2;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint16List emptyList = new Uint16List(0);

  static equal(Uint16List a, Uint16List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint16", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 4);

  /// _Deprecated_: Use [Uint16.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Uint16.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 1;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns an [Uint16List.view] of [list].
  static Uint16List view(Uint16List list, [int offsetInBytes = 0, int length]) =>
      viewOfBytes(list.buffer.asUint8List());

  /// Returns a [Uint16List] created from the [Uint8List] [bytes]. If [offsetInBytes]
  /// is aligned on an 2-byte boundary, then a [Uint16List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Uint16List].
  static Uint16List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Uint16List nList = new Uint16List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getUint16(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asUint16List(bytes.offsetInBytes, length);
  }

  static toUint16List(List<int> list) =>
      (list is Uint16List) ? list : new Uint16List.fromList(list);
}

class Uint32 extends Uint {
  static const sizeInBits = 32;
  static const sizeInBytes = 4;
  static const min = 0;
  static const max = (2 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint32List emptyList = new Uint32List(0);

  static equal(Uint32List a, Uint32List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint32", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 8);

  /// _Deprecated_: Use [Uint32.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Uint32.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 2;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns an [Uint32List.view] of [list].
  static Uint32List view(Uint32List list, [int offsetInBytes = 0, int length]) =>
      viewOfBytes(list.buffer.asUint8List());

  /// Returns a [Uint32List] created from the [Uint8List] [bytes]. If [offsetInBytes]
  /// is aligned on an 2-byte boundary, then a [Uint32List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Uint32List].
  static Uint32List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Uint32List nList = new Uint32List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getUint32(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asUint32List(bytes.offsetInBytes, length);
  }

  static toUint32List(List<int> list) =>
      (list is Uint32List) ? list : new Uint32List.fromList(list);
}

class Uint64 extends Uint {
  static const sizeInBits = 64;
  static const sizeInBytes = 8;
  static const min = 0;
  static const max = (1 << sizeInBits) - 1;
  static const maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Uint64List emptyList = new Uint64List(0);

  static equal(Uint64List a, Uint64List b) => Int.equal(a, b);

  static bool inRange(int i) => (i >= min) && (i <= max);

  static int guard(int i) => inRange(i) ? i : _error("Uint64", i);

  static bool check(int v, List<String> issues) => Int.checkValueInRange(v, issues, min, max);

  /// _Deprecated: Use [hex] instead._
  @deprecated
  static toHex(int i, [int padding = 0]) => Int.hex(i, padding);

  static hex(int i) => Int.hex(i, 16);

  /// _Deprecated_: Use [Uint64.checkList] instead.
  @deprecated
  static List<int> validate(List<int> vList,
          [int minLength = min, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// _Deprecated_: Use [Uint64.checkList] instead.
  @deprecated
  static List<int> listGuard(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      checkList(vList, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<int> checkList(List<int> vList, [int minLength = 0, int maxLength = maxLongLength]) =>
      Int._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<int> vList) => (checkList(vList) == null) ? false : true;

  static bool isNotValidList(List<int> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const shiftValue = 3;

  static int toOffsetInBytes(Uint64List bytes, offset) =>
      bytes.offsetInBytes + toLengthInBytes(offset);
  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  /// Returns a [Uint64List.view] created from the [Uint64List] [list].
  static Uint64List view(Uint64List list) =>
      viewOfBytes(list.buffer.asUint8List(list.offsetInBytes));

  /// Returns a [Uint64List] created from the [Uint8List] [bytes]. If [offsetInBytes]
  /// is aligned on an 2-byte boundary, then a [Uint64List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Uint64List].
  static Uint64List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    length = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(length);
      Uint64List nList = new Uint64List(length);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < length; i++, oib += sizeInBytes)
        nList[i] = bd.getUint64(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asUint64List(bytes.offsetInBytes, length);
  }

  static toUint64List(List<int> list) =>
      (list is Uint64List) ? list : new Uint64List.fromList(list);
}

/// _Deprecated: Use [Int.hex] instead.
@deprecated
String intToHex(int i, [int nDigits = -1, String padding = '0', String prefix = '0x']) {
  String s = i.toRadixString(16);
  s = (nDigits == -1) ? s : s.padLeft(nDigits, padding);
  return prefix + s;
}

/// _Deprecated: Use [Int.listToHex] instead.
@deprecated
Iterable<String> intListToHex(List<int> list) => list.map(intToHex);

/// _Deprecated: Use [Int.listToHexString] instead.
@deprecated
String hexListToString(List<String> list) => "[" + list.join(", ") + "]";

/// _Deprecated: Use [Int.inRange] instead.
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
