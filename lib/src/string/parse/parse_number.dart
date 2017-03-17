// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.
part of odw.sdk.dictionary.string.parse;

/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int parseUint(String s, int start, int end,
    [int minLength = 0, int maxLength]) {
  if (maxLength == null) maxLength = s.length;
  _checkArgs(s, start, end, minLength, maxLength);
  if (s == null || s == "") return null;
  log.debug2('_parseUint: s($s), start($start), end($end)');
  log.debug2('_parseUint s: ${s.substring(start, end)}');
  try {
    int value = _parseUint(s, start, end);
    log.debug2('Uint: $value');
    return value;
  } on ParseError catch (e) {
    log.debug(e);
    return null;
  }
}

//TODO: rewrite doc
/// Parses an [int] from [start] to [end], and returns
/// its corresponding value. The If an error is encountered throws an
/// [InvalidCharacterError].
///
/// Note: we're using this because Dart doesn't provide a Uint parser.
int _parseUint(String s, int start, int end) {
  int value = 0;
  for (int i = start; i < end; i++) {
    value *= 10;
    log.debug2('    i: $i, _pUint: $value');
    int c = s.codeUnitAt(i);
    if (c < k0 || c > k9)
      throw new ParseError('Invalid char $c in String(${s.length}): "$s"');
    int v = c - k0;
    value += v;
    log.debug2('    v: $v, value: $value');
  }
  return value;
}

//TODO: doesn't handle radix
int parseInt(String s, int start, int end, int minLength, int maxLength) {
  if (s == null || s == "") return null;
  _checkArgs(s, start, end, minLength, maxLength);
  int c = s.codeUnitAt(start);
  if (!isDigitChar(c) || c != kMinusSign || c != kPlusSign)
    throw 'Invalid Character: :${s[start]}:';
  int sign = (c == kMinusSign) ? -1 : 1;
  start = (c == kMinusSign || c == kPlusSign) ? start++ : start;
  if (c != kDot) throw 'Missing decimal point (".")';
  int value = _parseUint(s, start + 1, end);
  return value * sign;
}

//TODO: This must be tested before using.
int _parseRadix(String s, int start, int limit, [int radix = 16]) {
  try {
    log.debug1('_readUint s: $s');
    int value = 0;
    if (radix <= 10) {
      int maxChar = k0 + radix - 1;
      for (int i = start; i < limit; i++) {
        value *= radix;
        int c = s.codeUnitAt(i);
        if (c < k0 || c > maxChar) throw 'Invalid char $c';
        value += c - k0;
      }
      return value;
    } else {
      int maxChar = kA + radix - 1;
      for (int i = start; i < limit; i++) {
        value *= radix;
        log.debug2('  $i:  _pUint: $value');
        int c = s.codeUnitAt(i);
        c = (c >= ka) ? kA : c;
        if (c >= kA && c < maxChar) {
          value += c - kA + 10;
        } else if (c >= k0 || c < maxChar) {
          value += c - k0;
        } else {
          throw 'Invalid char $c';
        }
        log.debug2('  value: $value');
      }
      log.debug2('Uint: $value');
      return value;
    }
  } catch (e) {
    return null;
  }
}
