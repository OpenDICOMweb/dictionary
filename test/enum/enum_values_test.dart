// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/enum/enum_value.dart';
import 'package:test/test.dart';

void main() {
  test("yesorno", () {
    expect(EV.kYesNo.contains('YES'), true);
    expect(EV.kYesNo.contains('Yes'), false);
    expect(EV.kYesNo.contains('Foo'), false);
    expect(EV.kYesNo.indexOf('YES') == 0, true);
    expect(EV.kYesNo.indexOf('Yes') == 1, false);
    expect(EV.kYesNo.indexOf('Foo') == 0, false);

    expect(EV.kYesNo.contains('NO'), true);
    expect(EV.kYesNo.contains('No'), false);
    expect(EV.kYesNo.contains('Bar'), false);
    expect(EV.kYesNo.indexOf('NO') == 1, true);
    expect(EV.kYesNo.indexOf('N0') == 1, false);
    expect(EV.kYesNo.indexOf('No') == 1, false);
  });
}
