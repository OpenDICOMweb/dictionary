// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/tag.dart';

class ValueIssue {
  /// The [index] of this value in the [List] of [values].
  /// If [index] == -1, then the problem is with the entire list.
  int index;

  /// The [value] with a problem
  Object value;
  List<String> msgs;
  bool isFixed;

  ValueIssue(this.index, this.value, info, [this.isFixed = false])
      : msgs = (info is String) ? [info] : info;
}

class Issue {
  Tag tag;
  List<ValueIssue> issues;

  Issue(this.tag, this.issues);
}
