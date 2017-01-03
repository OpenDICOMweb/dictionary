// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/src/common/reader/string_reader.dart';
import 'package:dictionary/src/dicom/issue.dart';
import 'package:dictionary/src/dicom/string/char_predicates.dart';
import 'package:dictionary/src/dicom/tag/tag/tag.dart';

typedef String _StringPredicate(String s);

/// Returns a [List<int>] if all values are [int], otherwise [null].
Issue _StringValuesChecker(Tag tag, List<String> sList, _StringPredicate pred) {
  if (sList == null || sList.length == 0) return null;
  ValueIssue vi = tag.checkLength(sList);
  List<ValueIssue> viList = (vi == null) ? [] : [vi];
  for (int i = 0; i < sList.length; i++) {
    var msg = pred(sList[i]);
    if (msg != null) viList.add(new ValueIssue(i, sList[i], msg));
  }
  return new Issue(tag, viList);
}

String _checkLength(String s, int min, int max) {
  //TODO: verify this is correct
  if (s.length == 0) return null;
  if (s.length < min)
    return 'Invalid String("$s"): Length(${s.length}) is less than minLength($min)';
  if (s.length > max)
    return 'Invalid String("$s"): Length(${s.length}) is greater than maxLength($max)';
  return null;
}

_StringPredicate _makeCharSetChecker(CharPredicate pred) => 
        (String s) {
          for (int i = 0; i < s.length; i++) {
            int c = s.codeUnitAt(i);
            if (!pred(c)) return 'Illegal Char("${s[i]}" = $c) at position($i) in "$s"';
          }
          return null;
        };

Issue checkISValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isAEChar));

// kAE,
Issue checkAEValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isAEChar));

// kCS,
Issue checkCSValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isCSChar));
// kLO,
Issue checkLOValues(Tag tag, List<String> values)=>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isStringChar));
// kSH,
Issue checkSHValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isStringChar));
// kUC,
Issue checkUCValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isStringChar));

// String.Text
// kST - Short Text
Issue checkSTValue(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

// kLT,
Issue checkLTValue(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

// kUT,
Issue checkUTValue(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

// String.DateTime
// kDA,
Issue checkDateValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isDigitChar));
// kDT,
Issue checkDateTimeValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));
// kTM,
Issue checkTimeValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

// String.Other
// kPN,
Issue checkPNValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

// Unique Identifiers ([Uid]s) [kUI]
Issue checkUIValues(Tag tag, List<String> values) =>
    _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));

/// [Uri] [String] [kUR]
Issue checkURValue(Tag tag, List<String> values) {
  if (values == null || values.length == 0) return null;

  ValueIssue vi = tag.checkLength(values);
  _StringValuesChecker(tag, values, _makeCharSetChecker(isTextChar));
}


// Age [String] [kAS]
Issue checkASValue(Tag tag, List<String> values) {
  if (values == null || values.length == 0) return null;
  ValueIssue vi = tag.checkLength(values);
  if (values.length == 1) {
    StringReader buf = new StringReader(values[0]);
    if (buf.age == null) vi.msgs.add('Invalid AS - Age String(${values[1]})');
  }
  return new Issue(tag, [vi]);
}
