// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: decide if this is useful.
/// The [Type] of Range checkers.
typedef bool _InRange(String val);

/// Private error handler.
int _error(String type, String val) {
  throw new RangeError('$type: $val out of range');
}

class DcmString {
  static const bool isString = true;

    /// Returns [true] if [length] is between [min] and [max] inclusive.
    static bool inRange(int min, int length, int max) => (min <= length && length <= max);

    /// Returns a [List<String>] if all values are [int], otherwise [null].
    static List<String> listGuard(List<String> sList, _InRange inRange) {
        print('vList: $sList');
        for (int i = 0; i < sList.length; i++)
            if ((sList[i] is int) && inRange(sList[i])) {
                return null;
            }
        print('vList: $sList');
        return sList;
    }

    /// Returns a [List<String>] if all values are [int], otherwise [null].
    static bool isValidList(List<String> sList, _InRange inRange) {
        if (listGuard(sList, inRange) == null) return false;
        return true;
    }

    static bool isNotValidList(List<String> vList, _InRange inRange) =>
        !isValidList(vList, inRange);
}

class DcmString16 extends DcmString {

}

class DcmString32 extends DcmString {

}

class DcmText extends DcmString {
  static const int min = 0;
  static const int max = 0xFFFF;


  static bool inRange(String s) => (min <= s.length) && (s.length <= max);

  static int guard(String s) => inRange(s) ? s : _error("DcmShort", s);


}

class DcmLong extends DcmString {
  static const int min = 0;
  static const int max = 0xFFFF;


  static bool inRange(String s) => (min <= s.length) && (s.length <= max);

  static int guard(String s) => inRange(s) ? s : _error("DcmShort", s);


}

class DcmStringInt extends DcmString {
  static const int min = 0;
  static const int max = 999999999999;
  static const int minLength = 0;
  static const int maxLength = 12;

  static bool get isInteger => true;

  static bool inRange(int i) => (min <= i) && (i <= maxLength);

  static bool validLength(String s) => (minLength <= s.length) && (s.length <= maxLength);

  static int guard(String s) => validLength(s) ? s : _error("DcmShort", s);

  static int parse(String s) {
    if (!validLength(s)) return null;
    return int.parse(s,radix: 10, onError: (s) => null);
  }

}

class DcmStringFloat extends DcmString {
  static const int min = 0;
 // static const int max = 999999999999;
  static const int minLength = 0;
  static const int maxLength = 12;

  static bool get isInteger => true;

  static bool inRange(int i) => (min <= i) && (i <= maxLength);

  static bool validLength(String s) => (minLength <= s.length) && (s.length <= maxLength);

  static int guard(String s) => validLength(s) ? s : _error("DcmShort", s);

  static int parse(String s) {
    if (!validLength(s)) return null;
    return int.parse(s,radix: 10, onError: (s) => null);
  }

}