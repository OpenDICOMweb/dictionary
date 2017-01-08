// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: add UTF8 and ASCII converters
library odw.sdk.dictionary.common.reader.byte_buf;

//import 'dart:convert';

import 'dart:math';
import 'dart:typed_data';

import 'package:dictionary/src/common/ascii/constants.dart';
import 'package:dictionary/src/common/date_time/date.dart';
import 'package:dictionary/src/common/date_time/time.dart';
import 'package:dictionary/src/common/date_time/utils.dart';
import 'package:dictionary/string.dart';

part 'reader.dart';

//TODO: Add a way to retrieve error messages
//TODO: Add the ability to read object (Uid, Uuid, Uri, etc.)

// names with char or Char(suffix) return [int]s.
// names with string or String(suffix) return [String]s.
// If a Readers returns [null], the [index] is not changed.

//typedef bool _CharTest(code);

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
abstract class ByteBuf {
  /// The [buf] always [start]s at _rIndex = 0.
  List<int> buf;

  /// The current read position in the [buf]. Must be between [start] and [end].
  int _rIndex;

  /// The current write position in the [buf]. Must be between [_rIndex] and [emd].
  int _wIndex;

  /// Returns the element at index [i] if [i] [_isValidRIndex]; otherwise, returns [null].
  int operator [](int i) => buf[i];

  /// **** Getters and Methods related to [_rIndex] and [buf].[length].

  /// The 0Th position in the [buf].
  int get start => 0;

  /// Returns the number of elements [E] contained in [buf].
  int get length => buf.length;

  /// Synonym for [length]
  int get end => length;

  /// The current read position in the [buf]. Starts at [start].
  int get readIndex => _rIndex;

  /// Returns an [true] if [n] is a valid [_rIndex] in [buf].
  bool _isValidRIndex(int n) => (0 <= n && n <= _wIndex);

  /// Returns [true] if all characters have been read, i.e. [index] [==] [_wIndex].
  int get _rRemaining => _wIndex - _rIndex;
  int get rRemaining => _rRemaining;
  bool get isReadable => _rRemaining > 0;

  /// Returns [true] if [buf] has at least [count] code units remaining.
  bool hasReadable(int n) => _rRemaining >= n;

  int get readReset {
    _wIndex = end;
    return _rIndex = 0;
  }

  /// Returns a valid limit, which might be less than [n],
  /// or [null] if no valid limit exists.
  int _getRLimit(int n) {
    int v = ((_rIndex + n) > _wIndex) ? _wIndex - _rIndex : _rIndex + n;
    return (v > 0) ? v : null;
  }

  /// The current write position in the [buf]. Ends at [end].
  int get writeIndex => _wIndex;

  /// Returns an [true] if [n] is a valid [_rIndex] in [buf].
  bool _isValidWIndex(int n) => (_wIndex <= n && n <= end);

  int get _wRemaining => end - _wIndex;
  int get wRemaining => _wRemaining;
  bool get isWritable => _wRemaining > 0;
  bool hasWritable(int n) => _wRemaining >= n;

  int get writeReset {
    _rIndex = 0;
    return _wIndex = 0;
  }
}
