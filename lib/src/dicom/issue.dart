// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/tag.dart';

class Issue {
  final Tag tag;
  int badLength;
  Map<int, List<String>> _issues;

  Issue(this.tag, int index, String msg) : _issues = {index: [msg]};

  Issue.withLength(this.tag, this.badLength, List<String> msgs) : _issues = {0: msgs};

  add(int index, String msg) {
    if (_issues == null) {
      _issues = {index: [msg]};
    } else if (_issues[index] == null) {
      _issues[index] = [msg];
    } else {
      var msgs = _issues[index];
      if (msgs == null) throw "Invalid message $index: $msg";
      msgs.add(msg);
    }
  }

  String get lengthError => tag.vm.lengthError(badLength);

  String toString() {
    var out = "Issues with $tag\n\t";
    if (badLength != null) out += lengthError;
    _issues.forEach((int index, List<String> value) {
      out += '\n\t$index: $value';
    });
    return out;
  }
}

