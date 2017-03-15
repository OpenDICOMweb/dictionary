// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/private_data_tag.dart';
import 'package:test/test.dart';

void main() {
  privateDataTag();
}

void privateDataTag() {
  test("PrivatedataTag Test", () {
    int code = 0x00190010;
    PrivateDataTag pdt = new PrivateDataTag(code);
    expect((pdt.isPrivate), true);
    expect((pdt.isCreator), false);
    print(pdt.toString());
  });
}