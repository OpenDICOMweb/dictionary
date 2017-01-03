// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/src/dicom/issue.dart';
import 'package:dictionary/src/dicom/string/char_predicates.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';
import 'package:dictionary/tag.dart';

typedef bool _Predicate(value);

Issue noVRValueChecker(values) => throw 'Invalid vrIndex';

Issue dontCheckSequenceValues(value) => throw 'There is no Sequence checker';

/// Returns a [List<int>] if all values are [int], otherwise [null].
Issue _intValuesChecker(Tag tag, List<int> vList, _Predicate inRange) {
  if (vList == null || vList.length == 0) return null;
  ValueIssue vi = tag.checkLength(vList);
  List<ValueIssue> viList = (vi == null) ? [] : [vi];
  for (int i = 0; i < vList.length; i++)
    if (!inRange(vList[i])) {
      var msg = 'Value(${vList[i]} out of range ${inRange.runtimeType}';
      if (viList == null) viList = [];
      viList.add(new ValueIssue(i, tag, msg, false));
    }
  return new Issue(tag, viList);
}

Issue int16ValuesChecker(Tag tag, List<int> values) =>
    _intValuesChecker(tag, values, Int16.inRange);

Issue int32ValuesChecker(Tag tag, List<int> values) =>
    _intValuesChecker(tag, values, Int32.inRange);

Issue uint8ValuesChecker(Tag tag, List<int> values) =>
    _intValuesChecker(tag, values, Uint8.inRange);

Issue uint16ValuesChecker(Tag tag, List<int> values) =>
    _intValuesChecker(tag, values, Uint16.inRange);

Issue uint32ValuesChecker(Tag tag, List<int> values) =>
    _intValuesChecker(tag, values, Uint32.inRange);

Issue checkFloatValuesLength(Tag tag, List<double> values) {
  ValueIssue issues = tag.checkLength(values);
  return (issues == null) ? null : new Issue(tag, [issues]);
}


const List<VRValueChecker> valueCheckers = const [
  //kNoVR,
  noVRValueChecker,
  // Sequence
  dontCheckSequenceValues, //kSQ,
  // Integers
  //kSS,
  int16ValuesChecker,
  // kSL,
  int32ValuesChecker,
  // kOB,
  uint8ValuesChecker,
  // kUN,
  uint8ValuesChecker,
  // kOW,
  uint16ValuesChecker,
  // kUS,
  uint16ValuesChecker,
  // kUL,
  uint32ValuesChecker,
  // kAT,
  uint32ValuesChecker,
  // kOL,
  uint32ValuesChecker,

  // Floats
  // kFD,
  checkFloatValuesLength,
  // kFL,
  checkFloatValuesLength,
  // kOD,
  checkFloatValuesLength,
  // kOF,
  checkFloatValuesLength,

  // kIS - Integer & String.integer
  //kIS,
  checkISValues,

  // kDS - Float & String.float
  checkISValues,
  // String.array
  // kAE,
  checkAEValues,
  // kCS,
  checkCSValues,
  // kLO,
  checkLOValues,
  // kSH,
  checkSHValues,
  // kUC,
  checkUCValues,

  // String.Text
  // kST - Short Text
  checkSTValue,
  // kLT - Long Text
  checkLTValue,
  // kUT - Unlimited Text
  checkUTValue,

  // String.DateTime
  // kDA,
  checkDateValues,
  // kDT,
  checkDataTimeValues,
  // kTM,
  checkTimeValues,

  // String.Other
  // kPN,
  checkPNValues,
  // kUI,
  checkUIValues,
  // kUR,
  checkURValue,
  // kAS,
  checkASValue,
  //Bulkdata Reference
  kBR
];