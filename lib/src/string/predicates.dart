// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/ascii.dart';
import 'package:dictionary/src/dcm_predicates.dart';

typedef bool StringPredicate(String s, [int start, int end]);

/// Returns [true] if all characters from [start] to [end] are digits; otherwise, [false].
StringPredicate makeStringPredicate(CharPredicate pred) =>
        (String s, [int start = 0, int end]) {
          int stop = (end == null) ? s.length : end;
          for (int i = start; i < stop; i++) {
            if (!pred(s.codeUnitAt(i))) return false;
          }
          return true;
        };

/// Returns [true] if all characters from [start] to [end] are digits; otherwise, [false].
StringPredicate isDigit = makeStringPredicate(isDigitChar);
StringPredicate isUppercase = makeStringPredicate(isUppercaseChar);
StringPredicate isLowercase = makeStringPredicate(isLowercaseChar);
StringPredicate isAlphabetic = makeStringPredicate(isAlphabeticChar);
StringPredicate isAlphanumeric = makeStringPredicate(isAlphanumericChar);
StringPredicate isSpace = makeStringPredicate(isSpaceChar);
StringPredicate isWhitespace = makeStringPredicate(isWhitespaceChar);
StringPredicate isVisible = makeStringPredicate(isVisibleChar);

/// Returns [true] if [s] is [null] or empty [""].
bool isEmpty(String s) => (s == null) || (s == "");


