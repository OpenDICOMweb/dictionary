// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: add UTF8 and ASCII converters
import 'dart:convert';

import 'dart:math';
import 'dart:typed_data';

import 'package:dictionary/src/common/ascii/constants.dart';
import 'package:dictionary/src/common/ascii/predicates.dart';
import 'package:dictionary/src/common/date_time/date.dart';
import 'package:dictionary/src/common/date_time/time.dart';
import 'package:dictionary/src/common/date_time/utils.dart';
import 'package:dictionary/string.dart';

//TODO: Add a way to retrieve error messages
//TODO: Add the ability to read object (Uid, Uuid, Uri, etc.)

// names with char or Char(suffix) return [int]s.
// names with string or String(suffix) return [String]s.
// If a Readers returns [null], the [index] is not changed.

typedef bool _CharTest(code);

int checkBufferLength(int bufferLength, int start, int end) {
  if (end == null) end = bufferLength;
  if (end < 0 || bufferLength < end)
    throw new ArgumentError("Invalid end($end) for buffer with length($bufferLength)");
  if (start < 0 || end < start)
    throw new ArgumentError("Invalid start($start) for buffer with end($end)");
  return end;
}

/// Reader Interface
///
/// _start = 0
/// _start <= _rIndex <= _wIndex <= _end
/// _rRemaining = _wIndex - _rIndex
/// _wRemaining = _end - _wIndex
/// isReadable = _rRemaining > 0;
/// isWritable = _wRemaining > 0;
///
abstract class BufferBase<E> {
  /// The 0th position in [buf].
  static const int _start = 0;

  // **** Constants
  E kMinusSign;
  E kPlusSign;
  E k0;
  E k9;
  E kA;
  E kF;
  E ka;
  E kb;
  E kD;
  E kW;
  E kM;
  E kY;

  /// The [buf] always [start]s at _rIndex = 0.
  dynamic buf;

  /// The current read position in the [buf]. Must be between [start] and [end].
  int _rIndex;

  /// The current write position in the [buf]. Must be between [_rIndex] and [emd].
  int _wIndex;

  /// Returns the element at index [i] if [i] [isValidRIndex]; otherwise, returns [null].
  operator [](int i);

  _get(int i);


  /// Returns [true] if [c] represents a digit character
  bool _isDigit(E c);

  bool _isHex(E c);

  int _toDigit(E c);

  int _toHex(E c);

  /// Returns the number of elements [E] contained in [buf].
  int get length;

  /// **** Getters and Methods related to [_rIndex] and [buf].[length].

  /// The 0Th position in the [buf].
  int get start => _start;

  /// Synonym for [length]
  int get end => length;

  /// The current read position in the [buf]. Starts at [start].
  int get readIndex => _rIndex;

  /// Returns an [true] if [n] is a valid [_rIndex] in [buf].
  bool isValidRIndex(int n) => (0 <= n && n <= _wIndex);

  /// The current write position in the [buf]. Ends at [end].
  int get writeIndex => _wIndex;

  /// Returns an [true] if [n] is a valid [_rIndex] in [buf].
  bool isValidWIndex(int n) => (_wIndex <= n && n <= end);

  /// Returns [true] if all characters have been read, i.e. [index] [==] [_wIndex].
  int get rRemaining => _wIndex - _rIndex;
  bool get isReadable => rRemaining > 0;
  /// Returns [true] if [buf] has at least [count] code units remaining.
  bool hasReadable(int n) => rRemaining >= n;


  // bool get isEmpty =>
  // bool get isNotEmpty => !isEmpty;

  int get wRemaining => end - _wIndex;
  bool get isWritable => wRemaining > 0;
  bool hasWritable(int n) => wRemaining >= n;

  //bool get isFull => _wIndex == end;
  //bool get isNotFull => !isFull;

  // For readers == rRemaining, for writers = wRemaining
  // int get remaining => _wIndex - _rIndex;

  int get readReset {
    _wIndex = end;
    return _rIndex = 0;
  }

  int get writeReset {
    _rIndex = 0;
    return _wIndex = 0;
  }

  /// Returns a valid limit, which might be less than [n],
  /// or [null] if no valid limit exists.
  int _getRLimit(int n) {
    int v = ((_rIndex + n) > _wIndex) ? _wIndex - _rIndex : _rIndex + n;
    return (v > 0) ? v : null;
  }

  /// Moves [_rIndex] forward or backward.
  ///
  /// If [index] [+] [count] is valid, moves the [_rIndex] to that value and
  /// returns [true]; otherwise, the [_rIndex] is not moved and returns [false].
  /// Returns [true] if [index + count] is a valid [_rIndex].
  bool skip(int count) {
    int pos = _rIndex + count;
    if (isValidRIndex(pos)) {
      _rIndex = pos;
      return true;
    }
    return false;
  }
}
