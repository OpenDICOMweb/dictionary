// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

class Issue {
  /// A unique number (used as an index) identifying this [issue].
  final int id;

  /// The [Type] of [Object] that detects this [Issue].
  final Type type;
  final String name;
  final String msg;

  const Issue(this.id, this.type, this.name, this.msg);

  static const Issue badPadChar = const Issue(
      0, VR, 'invalidPaddingChar', "Invalid padding character in String");
}

class UnknownIssue extends Issue {

  UnknownIssue(Type type, String name, String msg) : super(-1, type, name, msg);
}

class IssueExample {
  static const String rootPath = 'C:/odw/sdk/issue/example/';
  final Issue issue;
  final List<String> paths;

  const IssueExample(this.issue, this.paths);

  static const IssueExample invalidPaddingCharacter =
      const IssueExample(Issue.badPadChar, const []);
}
