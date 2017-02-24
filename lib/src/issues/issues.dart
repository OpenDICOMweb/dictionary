// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

typedef String _Msg(object);

String unknownIssueTypeMsg(dynamic obj) => "Unknown Issue Type with $obj";

String invalidPadCharMsg(String char) =>
    "Invalid padding character $char in String";

String privateGroupLengthPresentMsg(int code) =>
    'Retired Private Group Length tag ${Tag.toDcm(code)} present';

class IssueType {
  /// A unique number (used as an index) identifying this [issue].
  final int id;
  final String keyword;
  final _Msg msg;

  const IssueType (this.id, this.keyword, this.msg);

  // Unknown IssueType
  static const IssueType unknown =
  const IssueType(0, 'UnknownIssueType', unknownIssueTypeMsg);

  // Public Elements
  static const IssueType invalidPadChar =
  const IssueType(0, 'invalidPaddingChar', invalidPadCharMsg);

  static const IssueType publicGroupLengthPresent =
    const IssueType(1, 'invalidPaddingChar', privateGroupLengthPresentMsg);

  // **** Private Elements

  static const IssueType privateGroupLengthPresent =
      const IssueType(1000, 'PrivateGroupLengthPresent',
          privateGroupLengthPresentMsg);
}

class Issue {
  /// The [Type] of [Issue].
  final IssueType type;
  /// The [Object] with the [Issue].
  final Object obj;

  Issue(this.type, this.obj);

  @override
  String toString() => '$runtimeType: ${type.msg(obj)}';
}

class UnknownIssue extends Issue {
  UnknownIssue(String name, dynamic obj) : super(IssueType.unknown, obj);
}

class IssueExample {
  static const String rootPath = 'C:/odw/sdk/issue/example/';
  final IssueType issue;
  final List<String> paths;

  const IssueExample(this.issue, this.paths);

  static const IssueExample invalidPaddingCharacter =
      const IssueExample(IssueType.invalidPadChar, const []);
}
