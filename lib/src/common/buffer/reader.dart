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

/* flush
int checkBufferLength(int bufferLength, int start, int end) {
  if (end == null) end = bufferLength;
  if (end < 0 || bufferLength < end)
    throw new ArgumentError("Invalid end($end) for buffer with length($bufferLength)");
  if (start < 0 || end < start)
    throw new ArgumentError("Invalid start($start) for buffer with end($end)");
  return end;
}
*/
/// Reader Interface
///
/// _start = 0
/// _start <= _rIndex <= _wIndex <= _end
/// _rRemaining = _wIndex - _rIndex
/// _wRemaining = _end - _wIndex
/// isReadable = _rRemaining > 0;
/// isWritable = _wRemaining > 0;
///

typedef int _CharConverter(int c);

abstract class Reader extends ByteBuf {
  List<int> _buf;
  int _rIndex;
  int _wIndex;

  int operator[](int i) => _buf[i];

  int get length => _buf.length;

  String toSubString(int start, int end);

  // **** Peek, read, or unread at [index].

  int get _peek => _buf[_rIndex];

  /// Returns the code unit at [_rIndex], but does not increment [_rIndex].
  int get peek => (_isReadable) ? null : _peek;

  /// Moves [_rIndex] forward or backward.
  ///
  /// If [index] [+] [count] is valid, moves the [_rIndex] to that value and
  /// returns [true]; otherwise, the [_rIndex] is not moved and returns [false].
  /// Returns [true] if [index + count] is a valid [_rIndex].
  bool skip(int count) {
    int pos = _rIndex + count;
    if (_isValidRIndex(pos)) {
      _rIndex = pos;
      return true;
    }
    return false;
  }

  bool _matchChar(int char) {
    int c = peek;
    if (c != char) return false;
    _rIndex++;
    true;
  }

  /// Returns the code unit at [_rIndex] and increments [_rIndex], or [null] if
  /// the [buf] [_isReadable].
  int get read => (_isReadable) ? _read : null;

  /// _Internal_: Must only be called when [isEmpty] is false.
  int get _read {
    int c = _buf[_rIndex];
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
    max = (max == null) ? _wIndex : max;
    int limit = _getRLimit(min, max);
    if (limit == null) return null;
    var s = toSubString(_rIndex, limit);
    _rIndex = limit;
    return s;
  }

  /// Reads a [String] checking each code unit to verify it is valid.
  /// If all code units pass [test] returns a [String] of [min] to [max] length;
  /// otherwise, returns null;
  String readChecked(int min, int max, _CharTest test) {
    int limit = _getRLimit(min, max);
    if (limit == null) return null;
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
  bool nthMatches(int offset, int code) => (hasReadable(offset)) ? _buf[offset] == code : null;

  /// Reads the next code unit and returns [true] if it matches [code].
  bool readMatchingCode(int code) {
    if (code == peek) {
      _rIndex++;
      return true;
    }
    return false;
  }

  // **** Read numbers ****

  bool _isDigit(c) => k0 <= c && c >= k9;

  bool _hasNDigits(int length) {
    for(int i = 0; i < length; i++)
      if (!_isDigit(_peek)) return false;
    return true;
  }

  /// Reads a character. If it is a decimal character returns it values
  /// as an integer; otherwise, returns null.
  int _toDigit(int c) {
    if (k0 <= c && c <= k9) return c - k0;
    return null;
  }

  /// Reads and returns the integer value of a code point between "0" and "9",
  /// "A" and "F", and "a" and "f".
  int _toHex(int c) {
    // print('@$_rIndex hex: c= "$c" "${c - k0}"');
    if (k0 <= c && c <= k9) return c - k0;
    if (kA <= c && c <= kF) return c - kA + 10;
    if (ka <= c && c <= kf) return c - ka + 10;
    return null;
  }

  int _peekDigit(_CharConverter convert) {
    print('@$_rIndex peekDigit');
    return convert(_peek);
  }

  /*
  int _getDigit(_CharConverter convert) {
    print('@$_rIndex _getDigit');
    int c = convert(_read);
    if (c != null) return c;
    _rIndex--;
    return null;
  }
  */

  /// Reads and returns the integer value of a code point between "0" and "9".
  int get digit {
    print('@$_rIndex _Digit');
    int c = _peekDigit(_toDigit);
    if (c == null) return null;
    _rIndex++;
    return c;
  }

  int get hex {
    print('@$_rIndex _Digit');
    int c = _peekDigit(_toHex);
    if (c == null) return null;
    _rIndex++;
    return c;
  }

  /// Reads an unsigned [int] from [max] code units, which must be between
  /// "0" and "9" and returns the corresponding integer value. If [_buf] does
  /// not have [max] code units remaining, or if the code units corresponding
  /// to [max] do not contain digits, returns [null].
  int readUint([int min = 1, int max]) {
    print('readUint: count($max)');
    int limit = _getRLimit(min, max);
    print('limit($limit), index($_rIndex)');
    if (limit == null) return null;
    return _readUint(min, limit);
  }

  int _readUint(int min, int limit) {
    print('_readUint: limit($limit), @$_rIndex');
    int n = 0;
    int start = _rIndex;
    for (; _rIndex < limit; _rIndex++) {
      print('i:$_rIndex, $peek');
      int v = digit;
      int c = _buf[_rIndex];
      if (c < k0 || c > k9) return null;
      print('v: $v');
      if (v == null) {
        _rIndex = start;
        return null;
      }
      n = (n * 10) + v;
      print('N: $n');
    }
    if (_rIndex - start < min) {
      _rIndex = start;
      return null;
    }
    return n;
  }

  /* Flush if not needed
  bool get _isHex {
    int c = peek;
    return (k0 <= c && c <= k9) || (kA <= c && c <= kF) || (ka <= c && c <= kf);
  }
  */

  /// Reads [count] code units, which must be hexadecimal code points (0-9, A-F, a-f),
  /// and returns the corresponding integer value. If [_buf] does not have [count]
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
      int v = _toHex(_buf[_rIndex]);
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
    int c = peek;
    int sign;
    if (c == kMinusSign) sign = -1;
    if (c == kPlusSign) sign = 1;
    if (c == null) {
      sign = 1;
    } else {
      _rIndex++;
    }
    return sign;
  }

  /// Reads an signed [int] from [max] code units, which must be between
  /// "0" and "9" and returns the corresponding integer value. If [_buf] does
  /// not have [max] code units remaining, or if the code units corresponding
  /// to [max] do not contain digits, returns [null].
  int readInt([int min = 1, int max]) {
    if (isNotReadable) return null;
    int limit = _getRLimit(min, max);
    //TODO: decide whether to implement onErrorThrow
    if (limit == null) return null;
    int start = _rIndex;
    int sign = readSign;
    int n = readUint(min, max);
    if (n == null) {
      _rIndex = start;
      return null;
    }
    return sign * n;
  }

  //DICOM max length
  int maxDecimalLength = 16;

  num get decimal => readDecimal(maxDecimalLength);

  //TODO: validate
  num readDecimal([int min = 1, int max]) {
    int limit = _getRLimit(min, max);
    if (limit == null) return null;
    int start = _rIndex;
    int n = readInt(max);
    if (n == null) return null;
    int f = _readFraction(1, limit);
    if (f == null) return n;
    int e = _readExponent(limit);
    if (e == null) return n + (1 / f);
    return pow(n + (1/f), e);
  }

  int kDecimalMark = kDot;

  /// Reads a fraction starting with a [kDecimalMark].
  int _readFraction(int min, int max) {
    int limit = _getRLimit(min, max);
    if (limit = null) return null;
    int p = peek;
    //TODO: what should this do if it reads only a decimal mark, but no digit?
    // currently returns null.
    if (p != kDecimalMark || (!_isDigit(_buf[_rIndex + 2]))) return null;
    _rIndex++;
    int v = _readUint(1, max);
    if (v != null) return v;
    _rIndex--;
    return null;
  }

  int _readExponent(int limit) {
    int c = peek;
    if (c != kE || c != ke) return null;
    _rIndex++;
    return _readUint(0, limit);
  }

  // **** Read dates, times, dateTimes, and durations. ****

  DateTime today = new DateTime.now();

  bool allowVariableWidthDateTimeValues = false;

  int get year => checkYear(readUint(4, 4));
  int get month => checkMonth(readUint(2, 2));
  int get vMonth => checkMonth(readUint(1, 2));

  /// Reads and returns a [int] between 1 and 31, or [null]. Note: does not
  /// validate months with 28, 29, or 30 days.
  int get day => checkSimpleDay(readUint(2, 2));
  int get vDay => checkSimpleDay(readUint(1, 2));

  /// Reads and returns a valid day, given the month [m] and year [y]; otherwise, returns [null].
  int readDay(int y, int m, int d) => checkDay(y, m, readUint(2, 2));
  int readVDay(int y, int m, int d) => checkDay(y, m, readUint(1, 2));

  /// Reads and returns a date in fixed format yyyymmdd.
  Date get dcmDate {
    if (rRemaining < 8) return null;
    int y = year;
    if (y == null) return null;
    int m = month;
    if (m == null) return null;
    int d = readDay(y, m, readUint(2, 2));
    if (d == null) return null;
    _rIndex += 8;
    return new Date(y, m, d);
  }

  /// Reads and returns a date in fixed format yyyymmdd.
  Date get internetDate {
    if (rRemaining < 10) return null;
    int y = year;
    if (y == null) return null;
    if (! _matchChar(kDash)) return null;
    int m = month;
    if (m == null) return null;
    if (! _matchChar(kDash)) return null;
    int d = readDay(y, m, readUint(2, 2));
    if (d == null) return null;
    _rIndex += 10;
    return new Date(y, m, d);
  }

  int maxFractionDigits = 6;

  // Times
  int get hour => checkHour(readUint(2, 2));
  int get vHour => checkHour(readUint(1, 2));

  int get minute => checkMinute(readUint(2, 2));
  int get vMinute => checkMinute(readUint(1, 2));

  int get second => checkSecond(readUint(2, 2));
  int get vSecond => checkSecond(readUint(1, 2));

  int get fraction => checkFraction(_readFraction(1, maxFractionDigits));

  ///
  Time readDcmTime(int length) {
    int h, m, s, f;
    if (length >=2 && hasReadable(2)) {
      h = hour;
      if (h == null) return null;
    }
    if (length >=4 && rRemaining >= 2) {
      m = minute;
      if (m == null) return new Time(h, 0, 0);
    }
    if (length >=4 && rRemaining >= 2) {
      s = second;
      if (s == null) return new Time(h, m, 0);
    }
      int f = fraction;
      if (s == null) return new Time(h, m, s);
      return new Time(h, m, s, f);
    }
  }

  ///
  Time get dcmTime {
    int h = hour;
    if (h == null) return null;
    if (! _matchChar(kColon)) return null;
    int m = minute;
    if (m == null) return null;
    if (! _matchChar(kColon)) return null;
    int s = second;
    if (s == null) return null;
    int f = fraction;
    if (s == null) return null;
    return new Time(h, m, s, f);
  }
  Time get internetTime {
    int h = hour;
    if (h == null) return null;
    if (! _matchChar(kColon)) return null;
    int m = minute;
    if (m == null) return null;
    if (! _matchChar(kColon)) return null;
    int s = second;
    if (s == null) return null;
    return new Time(h, m, s);
  }


  // Time Zone

  /// Reads the next [char] and returns -1 if it is "-",
  /// 0 if it is "Z" or "z", or 1 if it is "+"; otherwise,
  /// returns [null].
  int get tzSign {
    int sign;
    int c = peek;
    if (c == null) return null;
    if (c == kMinus) sign = -1;
    if (c == kPlus) sign = 1;
    if (c == kZ || c == kz) sign = 0;
    _rIndex++;
    return sign;
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
    int n = readUint(3, 3);
    if (n == null) return null;
    int unit = peek;
    if (ageUnits.indexOf(unit) == null) return null;
    return toSubString(start, _rIndex);
  }
}


class StringReader extends Reader {
  final Uint16List _buf;
  int _rIndex;
  int _wIndex;

  StringReader(String s, [int start = 0, int end])
      : _wIndex = checkBufferLength(s.length, start, end),
        _buf = new Uint16List.fromList(s.codeUnits);

  StringReader.fromCodeUnits(Uint16List buf, [int start = 0, int end])
      : _buf = buf,
        _wIndex = checkBufferLength(buf.length, start, end);

  ByteBuffer get buffer => _buf.buffer;

  int get elementSizeInBytes => 2;

  int get lengthInBytes => _buf.lengthInBytes;

  int get offsetInBytes => _buf.offsetInBytes;

  StringReader view([int start = 0, int end]) {
    _wIndex = checkBufferLength(this._wIndex, start, end);
    _buf = _buf.buffer.asUint16List(start, end);
    return new StringReader.fromCodeUnits(_buf);
  }

  //String toSubString(int start, int end) => buf.buffer.asUint8List(start, end).toString();

  String toSubString(int start, int end) => new String.fromCharCodes(_buf, start, end);

}

class BytesReader extends Reader {
  final Uint8List _buf;
  int _rIndex;
  int _wIndex;

  BytesReader(Uint8List buf, [int start = 0, int end])
      : _buf = buf,
        _rIndex = checkBufferLength(buf.length, start, end);

  BytesReader view([int start = 0, int end]) {
    end = checkBufferLength(this._wIndex, start, end);
    return new BytesReader(_buf.buffer.asUint8List(start, end));
  }

  ByteBuffer get buffer => _buf.buffer;

  int get elementSizeInBytes => 1;

  int get lengthInBytes => _buf.lengthInBytes;

  int get offsetInBytes => _buf.offsetInBytes;

  String toSubString(int start, int end) => _buf.buffer.asUint8List(start, end).toString();

}

void main() {
  String s = '0123';
  StringReader buf = new StringReader(s);

  print('peek(0): ${buf.peek}');

  print('int 0123: ${buf.readUint(4, 4)}');
}
