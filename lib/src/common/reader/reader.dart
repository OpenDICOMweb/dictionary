// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: add UTF8 and ASCII converters
part of odw.sdk.dictionary.common.reader.byte_buf;

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

abstract class Reader extends ByteBuf {
  List<int> buf;
  int _rIndex;
  int _wIndex;

  int operator[](int i) => buf[i];

  int get length => buf.length;

  String toSubString(int start, int end);

  /// Returns a valid read limit, which might be less than [n],
  /// or [null] if no valid limit exists. [n] can be positive or negative.
  int _getRLimit(int n) {
    int v = ((_rIndex + n) > _wIndex) ? _wIndex - _rIndex : _rIndex + n;
    return (v > 0) ? v : null;
  }

  // **** Peek, read, or unread at [index].

  /// Returns the code unit at [_rIndex], but does not increment [_rIndex].
  int get peek => (isReadable) ? null : _get(_rIndex);

  /// Returns the code unit at [_rIndex] and increments [_rIndex], or [null] if
  /// the [buf] [isReadable].
  int get read => (isReadable) ? _read : null;

  /// _Internal_: Must only be called when [isEmpty] is false.
  int get _read {
    int c = _get(_rIndex);
    _rIndex++;
    return c;
  }

  /// Decrements the [_rIndex] by 1 and returns [true]; however, if decrementing
  /// the [_rIndex] would result in a negative [_rIndex] returns [false]
  bool get unread {
    if ((_rIndex - 1) >= 0) {
      _rIndex--;
      return true;
    }
    return false;
  }

  _rGuard(Function f) {
    int start = _rIndex;
    var value;
    try {
      value = f();
    } catch (e) {
      _rIndex = start;
      //TODO: add this
      //   log.info(e);
      print(e);
      return null;
    }
    return value;
  }

  /// Returns a [String] with a minimum length of [min] and a maximum length of [max],
  /// or [null] if a [String] of [min] length is not available.
  String readString([int min = 0, int max]) {
    int limit = _getRLimit((max == null) ? _wIndex : max);
    if (limit == null || limit < min) return null;
    var s = toSubString(_rIndex, limit);
    _rIndex = limit;
    return s;
  }

  /// Reads a [String] checking each code unit to verify it is valid.
  /// If all code units pass [test] returns a [String] of [min] to [max] length;
  /// otherwise, returns null;
  String readChecked(int min, int max, _CharTest test) {
    int limit = _getRLimit(max);
    if (limit == null || limit < min) return null;
    int start = _rIndex;
    try {
      for (; _rIndex < limit; _rIndex++) {
        if (!test(read)) {
          _rIndex = start;
          throw 'Failed predicate test($test) at index($_rIndex)';
        }
      }
    } catch(e) {
      _rIndex = start;
      return null;
    }
    return toSubString(start, limit);
  }

  // **** Simple Matchers ****

  /// Reads the
  bool matchString(String s) {
    if (s.length > rRemaining) return false;
    int start = _rIndex;
    for (int i = 0; i < s.length; i++) {
      int c = s.codeUnitAt(0);
      if (c != _read) {
        _rIndex == start;
        return false;
      }
    }
    return true;
  }

  bool nextMatches(int code) => peek == code;
  bool nthMatches(int offset, int code) => (hasReadable(offset)) ? _get(offset) == code : null;

  /// Reads the next code unit and returns [true] if it matches [code].
  bool readMatchingCode(int code) {
    if (code == peek) {
      _rIndex++;
      return true;
    }
    return false;
  }

  // **** Read numbers ****

  bool get nextIsDigit {
    print('@$_rIndex nextIsDigit');
    if (isReadable) {
      int c = peek;
      print('@$_rIndex nextIsDigit: "$c"');
      return _isDigit(c);
    }
    return false;
  }

  bool get _nextIsNotDigit => !nextIsDigit;

  int get _digit; // => _read - k0;

  /// Reads and returns the integer value of a code point between "0" and "9".
  int get digit => (nextIsDigit) ? _digit : null;

  /// Reads an unsigned [int] from [length] code units, which must be between
  /// "0" and "9" and returns the corresponding integer value. If [buf] does
  /// not have [length] code units remaining, or if the code units corresponding
  /// to [length] do not contain digits, returns [null].
  int readUintOfLength(int length) {
    print('readUint: count($length)');
    int limit = _getRLimit(length);
    print('limit($limit), index($_rIndex)');
    if (limit == null || (_nextIsNotDigit)) return null;
    return _readUint(limit);
  }

  int _readUint(int limit) {
    print('_readUint: limit($limit), @$_rIndex');
    int n = 0;
    int start = _rIndex;
    for (; _rIndex < limit; _rIndex++) {
      print('i:$_rIndex, $peek');
      int v = _digit;
      print('v: $v');
      if (v == null) {
        _rIndex = start;
        return null;
      }
      n = (n * 10) + v;
      print('N: $n');
    }
    return n;
  }

  /// Read an unsigned integer with length at least 1 and no more than [max].
  int readUint(int max) {
    int limit = _getRLimit(max);
    if (limit == null || !nextIsDigit) return null;
    return _readVUint(limit);
  }

  /// Reads one or more unsigned digits and returns there value.
  /// Note: The next code point must be a digit.
  int _readVUint(int limit) {
    int n = 0;
    for (; _rIndex < limit; _rIndex++) {
      int v = _digit;
      if (v == null) return v;
      n = (n * 10) + v;
    }
    return n;
  }

  bool get _isHex {
    int c = peek;
    return (k0 <= c && c <= k9) || (kA <= c && c <= kF) || (ka <= c && c <= kf);
  }

  int get hex => (isReadable) ? _toHex(read) : null;

  /// Reads and returns the integer value of a code point between "0" and "9",
  /// "A" and "F", and "a" and "f".
  int _toHex(int c) {
   // print('@$_rIndex hex: c= "$c" "${c - k0}"');
    if (k0 <= c && c <= k9) return c - k0;
    if (kA <= c && c <= kF) return c - kA + 10;
    if (ka <= c && c <= kf) return c - ka + 10;
    unread;
    return null;
  }

  /// Reads [count] code units, which must be hexadecimal code points (0-9, A-F, a-f),
  /// and returns the corresponding integer value. If [buf] does not have [count]
  /// code units remaining, or if the code units corresponding to [count] do not contain digits,
  /// returns [null].
  int readHex(int count) {
    if (count <= 0 || rRemaining < count) return null;
    return _readHex(count, count);
  }

  int _readHex(int min, int max) {
    print('min($min), max($max)');
    int limit = _rIndex + max;
    int start = _rIndex;
    int n = 0;
    print('@${_rIndex} start n: $n');
    for (; _rIndex < limit; _rIndex++) {
      int v = _toHex(_get(_rIndex));
      print('@${_rIndex} v: $v');
      if (v == null) return v;
      n = (n * 16) + v;
      print('@${_rIndex} n: $n');
    }
    if ((_rIndex - start) < min) {
      _rIndex = start;
      return null;
    }
    return n;
  }

  /// Returns an [int] by reading
  int readVHex(int max) {
    int width = (_rIndex + max > _wIndex) ? _wIndex - _rIndex : max;
    if (width <= 0) return null;
    return _readHex(1, width);
  }

  // **** Signed Integers ****

  //TODO: edit.
  /// Reads a sign code unit (+, -) and returns +1 or -1.
  /// If the next code unit is a digit then return 1, but does not
  /// advance the [_rIndex].
  int get readSign {
    int c = read;
    if (c == kMinusSign) return -1;
    if (c == kPlusSign) return 1;
    unread;
    print('@$_rIndex');
    return (nextIsDigit) ? 1 : null;
  }

  /// Reads an signed [int] from [count] code units, which must be between
  /// "0" and "9" and returns the corresponding integer value. If [buf] does
  /// not have [count] code units remaining, or if the code units corresponding
  /// to [count] do not contain digits, returns [null].
  int readInt(int count) {
    if (!isReadable) return null;
    int sign = readSign;
    print('sign: $sign');
    if (sign == null) return null;
    int n = readUintOfLength(count);
    return (n == null) ? null : sign * n;
  }

  /// Read an integer, possibly signed, with length at least 1 and no more than [max].
  int readVInt(int max) {
    int limit = _getRLimit(max);
    if (limit == null) return null;
    return _readVUint(limit);
  }

  /// Must Read at least one digit
  int _readVInt(int limit) {
    int sign = readSign;
    if (_nextIsNotDigit) return null;
    int n = _readVUint(limit);
    return (n == null) ? null : sign * n;
  }

  //DICOM max length
  int maxDecimalLength = 16;

  num get decimal => readDecimal(maxDecimalLength);

  //TODO: validate
  num readDecimal(int max) {
    int limit = _getRLimit(max);
    if (limit == null) return null;
    int n = readVInt(max);
    if (_rIndex >= limit) return n;
    double f = _readFraction(limit);
    if (_rIndex >= limit) return n + f;
    int e = _readExponent(limit);
    return pow(n + f, e);
  }

  int kDecimalMark = kDot;

  /// Reads a fraction starting with a [kDecimalMark].
  double _readFraction(int limit) {
    int p = peek;
    //TODO: what should this do if it reads only a decimal mark, but no digit?
    // currently returns null.
    if (p != kDecimalMark || _isDigit(_get(_rIndex + 2))) return null;
    _rIndex++;
    return 1 / _readVUint(limit);
  }

  int _readExponent(int limit) {
    int c = peek;
    if (c != kE || c != ke) return null;
    _rIndex++;
    return _readVUint(limit);
  }

  // **** Read dates, times, dateTimes, and durations. ****

  DateTime today = new DateTime.now();

  bool allowVariableWidthDateTimeValues = false;

  int get year => checkYear(readUintOfLength(4));
  int get month => checkMonth(readUintOfLength(2));
  int get vMonth => checkMonth(readUint(2));

  /// Reads and returns a [int] between 1 and 31, or [null]. Note: does not
  /// validate months with 28, 29, or 30 days.
  int get day => checkSimpleDay(readUintOfLength(2));
  int get vDay => checkSimpleDay(readUint(2));

  /// Reads and returns a valid day, given the month [m] and year [y]; otherwise, returns [null].
  int readDay(int y, int m, int d) => checkDay(y, m, readUintOfLength(2));
  int readVDay(int y, int m, int d) => checkDay(y, m, readUint(2));

  /// Reads and returns a date in fixed format yyyymmdd.
  Date get date {
    if (rRemaining < 8) return null;
    int y = year;
    int m = month;
    if (y == null || m == null) return null;
    int d = readDay(y, m, readUintOfLength(2));
    if (d == null) return null;
    return new Date(y, m, d);
  }

  /// Reads and returns a date in fixed format yyyymmdd.
  Date get vDate {
    if (rRemaining < 8) return null;
    int y = year;
    int m = vMonth;
    if (y == null || m == null) return null;
    int d = readDay(y, m, readUint(2));
    if (d == null) return null;
    return new Date(y, m, d);
  }

  int maxFractionDigits = 6;

  // Times
  int get hour => checkHour(readUintOfLength(2));
  int get vHour => checkHour(readUint(2));

  int get minute => checkMinute(readUintOfLength(2));
  int get vMinute => checkMinute(readUint(2));

  int get second => checkSecond(readUintOfLength(2));
  int get vSecond => checkSecond(readUint(2));

  int get fraction => checkFraction(readUint(maxFractionDigits));

  ///
  Time get time {
    int h = hour;
    int m = minute;
    int s = second;
    return new Time(h, m, s);
  }

  ///
  Time get vTime {
    int h = vHour;
    int m = vMinute;
    int s = vSecond;
    return new Time(h, m, s);
  }

  // Time Zone

  /// Reads the next [char] and returns -1 if it is "-",
  /// 0 if it is "Z" or "z", or 1 if it is "+"; otherwise,
  /// [unread]s and returns [null].
  int get tzOffset {
    int c = read;
    if (c == kMinus) return -1;
    if (c == kPlus) return 1;
    if (c == kZ || c == kz) return 0;
    unread;
    return null;
  }

  int get tzHour => checkHour(readInt(2));
  int get tzMinute => checkMinute(readInt(2));

  // **** UID

  //TODO: this should have the option to do a complete check.
  String get uid => readChecked(0, 64, isUidChar);

  String readUri([int start = 0, int end] ) {
    //TODO: do something more efficient
    //UR - Universal Resource Identifier (URI)
    return null;
  }

  static const List<int> ageUnits = const [kD, kW, kM, kY];

  String get age {
    int start = _rIndex;
    int n = readUintOfLength(3);
    if (n == null) return null;
    int unit = peek;
    if (ageUnits.indexOf(unit) == null) return null;
    return toSubString(start, _rIndex);
  }
}


class StringReader extends Reader {
  final Uint16List buf;
  int _rIndex;
  int _wIndex;

  StringReader(String s, [int start = 0, int end])
      : _wIndex = checkBufferLength(s.length, start, end),
        buf = new Uint16List.fromList(s.codeUnits);

  StringReader.fromCodeUnits(Uint16List buf, [int start = 0, int end])
      : buf = buf,
        _wIndex = checkBufferLength(buf.length, start, end);

  ByteBuffer get buffer => buf.buffer;

  int get elementSizeInBytes => 2;

  int get lengthInBytes => buf.lengthInBytes;

  int get offsetInBytes => buf.offsetInBytes;

  String toSubString(int start, int end) => buf.buffer.asUint8List(start, end).toString();

  StringReader view([int start = 0, int end]) {
    _wIndex = checkBufferLength(this._wIndex, start, end);
    buf = buf.buffer.asUint16List(start, end);
    return new StringReader.fromCodeUnits(buf);
  }

  String toSubString(int start, int end) => new String.fromCharCodes(buf, start, end);

}

class BytesReader extends Reader {
  final Uint8List buf;
  int _rIndex;
  int _wIndex;

  BytesReader(Uint8List buf, [int start = 0, int end])
      : buf = buf,
        _rIndex = checkBufferLength(buf.length, start, end);

  BytesReader view([int start = 0, int end]) {
    end = checkBufferLength(this._wIndex, start, end);
    return new BytesReader(buf.buffer.asUint8List(start, end));
  }

  ByteBuffer get buffer => buf.buffer;

  int get elementSizeInBytes => 1;

  int get lengthInBytes => buf.lengthInBytes;

  int get offsetInBytes => buf.offsetInBytes;

  String toSubString(int start, int end) => buf.buffer.asUint8List(start, end).toString();

}

void main() {
  String s = '0123';
  StringReader buf = new StringReader(s);

  print('peek(0): ${buf.peek}');

  print('int 0123: ${buf.readUintOfLength(4)}');
}
