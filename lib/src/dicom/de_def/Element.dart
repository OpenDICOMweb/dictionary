// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'tag/tag.dart';

class Element {
    Tag tag;
    List values;

    Element(this.tag, this.values);

    static checkValues(Tag tag, List values) {
      List<String> issues = [];
      tag.checkLength(values);
    }
}