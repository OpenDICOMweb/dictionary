// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/constants.dart';

/// Floating Point Data Types

/// The [Type] of Range checkers.
typedef bool _InRange(double val);

double _floatError(String type, double min, double val, double max) {
  throw new RangeError('$type: out of range (min <= val <= max');
}

//TODO: merge hash stuff with hash.dart
/// The 32-bit hash mask.
const int k32BitHashMask = 0x1fffffff;

// Jenkins hash functions - from quiver package on Pub.
int _combine32(int hash, int value) {
  int h = k32BitHashMask & (hash + value);
  h = k32BitHashMask & (h + ((0x0007ffff & h) << 10));
  return h ^ (h >> 6);
}

int _finish32(int hash) {
  int h = k32BitHashMask & (hash + ((0x03ffffff & hash) << 3));
  h = h ^ (h >> 11);
  return k32BitHashMask & (h + ((0x00003fff & h) << 15));
}

int hashList(List<double> vList) {
  int hash = 0;
  for (int i = 0; i < vList.length; i++) {
    _combine32(hash, vList[i].hashCode);
  }
  return _finish32(hash);
}


class Float {
  static String get type => "Float";

  static bool get isFloat => true;

  static bool equal(List<double> a, List<double> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  static bool inRange(double min, double val, double max) => (min <= val && val <= max);

  static double guard(double min, double val, double max) =>
      inRange(min, val, max) ? val : _floatError(type, min, val, max);

  static String checkRange(double n, double min, double max) =>
      (inRange(n, min, max)) ? null : 'RangeError: min($min) <= Value($n) <= max($max)';

  /// Returns a [List<double>] if all values are [double] and [inRange], otherwise [null].
  static List<double> checkList(
      List<double> vList, _InRange inRange, int minLength, int maxLength) {
    if (vList is! TypedData) return null;
    return _checkList(vList, inRange, minLength, maxLength);
  }

  /// Returns a [List<int>] if all values are [int] and [inRange], otherwise [null].
  static List<double> _checkList(List<double> vList, _InRange inRange, int min, int max) {
    if (vList == null || vList.length < min || max < vList.length) return null;
    for (int i = 0; i < vList.length; i++) if (!inRange(vList[i])) return null;
    return vList;
  }

  /// Returns a [List<int>] if all values are [int], otherwise [null].
  static bool isValidList(List<double> vList, _InRange inRange, int minLength, int maxLength) {
    if (checkList(vList, inRange, minLength, maxLength) == null) return false;
    return true;
  }

  static bool isNotValidList(List<double> vList, _InRange inRange, int minLength, int maxLength) =>
      !isValidList(vList, inRange, minLength, maxLength);
}

class Float32 extends Float {
  static const String name = "Float32";
  static const int sizeInBits = 32;
  static const int sizeInBytes = 4;

  //TODO: test
  static const int min = 0x80800000;
  //TODO: test
  static const int max = 0x7F7FFFFF;
  //TODO: test
  static const int pZero = 0x00000000;
  //TODO: test
  static const int mZero = 0x80000000;
  //TODO
  static const int pInfinity = 0x7F800000;
  //TODO
  static const int nInfinity = 0xFF800000;
  //TODO
  static const int qNaN = 0x7FC00000;
  //TODO
  static const int sNaN = 0x7FC00000;
  static const int maxShortLength = kMaxShortLengthInBytes ~/ sizeInBytes;
  static const int maxLongLength = kMaxLongLengthInBytes ~/ sizeInBytes;
  static final Float32List emptyList = new Float32List(0);

  static bool equal(Float32List a, Float32List b) => Float.equal(a, b);

  static bool inRange(double val) => (val >= min) && (val <= max);

  //TODO: verify that min range an max range are correct.
  static double checkRange(double v) => (inRange(v)) ? v : null;

  static List<String> hasError(double v) =>
      (inRange(v)) ? null : ['RangeError: min($min) <= Value($v) <= max($max)'];

  static double guard(double min, double val, double max) =>
      inRange(val) ? val : _floatError("Float32", min, val, max);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<double> checkList(List<double> vList,
          [int minLength = 0, int maxLength = maxLongLength]) =>
      (vList is Float32List) ? vList : Float._checkList(vList, inRange, minLength, maxLength);

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<double> listGuard(List<double> vList) {
    if (vList == null || vList.length == 0) throw "invalid Float32: $vList";
    //return Float.listGuard(vList, inRange);
    return vList;
  }

  /// Returns a [true] if all values are valid Uint32, otherwise [false].
  static bool isValidList(List<double> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<double> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static const int shiftValue = 2;

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  static int hash(Float32List vList) => hashList(vList);

  static Float32List viewOfBytes(Uint8List bytes, [int length]) {
    print('isAligned: ${isAligned(bytes)}, length: $length');
    int maxLength = toLength(bytes.lengthInBytes);
    int len = RangeError.checkValidRange(0, length, maxLength);
    print('isAligned: ${isAligned(bytes)}, length: $len');
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = toLengthInBytes(len);
      Float32List nList = new Float32List(len);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < len; i++, oib += sizeInBytes)
        nList[i] = bd.getFloat32(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...oib: ${bytes.offsetInBytes}, length: $len');
    return bytes.buffer.asFloat32List(bytes.offsetInBytes, len);
  }

  static Float32List toFloat32List(List<double> list) =>
      (list is Float32List) ? list : new Float32List.fromList(list);
}

class Float64 extends Float {
  static const String name = "Float64";
  static const int sizeInBits = 64;
  static const int sizeInBytes = 8;
  static const int shiftValue = 3;

  //TODO: test
  static const int min = 0x8010000000000000;

  //TODO: test
  static const int max = 0x7FEFFFFFFFFFFFFF;

  //TODO: test
  static const int pZero = 0x0000000000000000;

  //TODO: test
  static const int mZero = 0x8000000000000000;

  //TODO
  static const int pInfinity = 0x7FF0000000000000;

  //TODO
  static const int nInfinity = 0xFFF0000000000000;

  //TODO
  static const int qNaNmin = 0x7FF8FFFFFFFFFFFF;

  //TODO
  static const int qNaNmax = 0x7FFFC00000000000;

  //FIX wrong
  static const int sNaNmin = 0x7FFF800000000001;

  //FIX wrong
  static const int sNaNmax = 0x7FFFBFFFFFFFFFFF;
  static const int maxShortLength = kMaxShortLengthInBytes - sizeInBytes;
  static const int maxLongLength = kMaxLongLengthInBytes - sizeInBytes;
  static final Float64List emptyList = new Float64List(0);

  static bool equal(Float64List a, Float64List b) => Float.equal(a, b);

  //TODO: is this needed - when used
  //TODO: correct?
  static bool inRange(double val) => (val >= min) && (val <= max);

  // A no-op except for type check
  static double checkRange(double v) => v;

  //TODO: is this needed - when used
  //TODO: correct?
  static double guard(double min, double val, double max) =>
      inRange(val) ? val : _floatError("Float64", min, val, max);

  //TODO: is this needed - when can a Float64List be invalid? it can't
  /// Returns a [values] if all values are valid [Float64List], otherwise null.
  @deprecated
  static Float64List validate(Float64List values) => listGuard(values);

  /// Returns it argument [values] if valid; otherwise, returns [null].
  static List<double> listGuard(List<double> values) {
    if (values == null || values.length == 0) throw "invalid Float64: $values";
    //return Float.listGuard(vList, inRange);
    return values;
  }

  /// Returns it argument [vList] if valid; otherwise, returns [null].
  static List<double> checkList(List<double> vList,
          [int minLength = 0, int maxLength = maxLongLength]) =>
      (vList is Float64List) ? vList : Float._checkList(vList, inRange, minLength, maxLength);

  /// Returns a [true] if all values are valid [Float64List], otherwise [false].
  static bool isValidList(List<double> vList) => (listGuard(vList) == null) ? false : true;

  static bool isNotValidList(List<double> vList) => !isValidList(vList);

  static bool isAligned(TypedData list) => list.offsetInBytes % sizeInBytes == 0;
  static bool isNotAligned(TypedData list) => !isAligned(list);

  static int toLength(int lengthInBytes) => lengthInBytes >> shiftValue;

  static int toLengthInBytes(int length) => length << shiftValue;

  static int hash(Float32List vList) => hashList(vList);

  /// Returns a [Float64List] created from [bytes]. if [bytes].offsetInBytes is aligned
  /// on an 8-byte boundary, then a [Float64List.view] is returned; otherwise,
  /// the [bytes] are copied to a [new] [Float64List].
  static Float64List viewOfBytes(Uint8List bytes, [int length]) {
    int maxLength = bytes.lengthInBytes >> shiftValue;
    int len = RangeError.checkValidRange(0, length, maxLength);
    if (isNotAligned(bytes)) {
      print('Copying...');
      int lengthInBytes = len << shiftValue;
      Float64List nList = new Float64List(len);
      ByteData bd = bytes.buffer.asByteData(bytes.offsetInBytes, lengthInBytes);
      for (int i = 0, oib = 0; i < len; i++, oib += sizeInBytes)
        nList[i] = bd.getFloat64(oib, Endianness.LITTLE_ENDIAN);
      return nList;
    }
    print('View ...');
    return bytes.buffer.asFloat64List(bytes.offsetInBytes, len);
  }

  static Float64List toFloat64List(List<double> list) =>
      (list is Float64List) ? list : new Float64List.fromList(list);
}
