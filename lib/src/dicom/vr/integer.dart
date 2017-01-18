// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/dicom.dart';

import 'vr_check.dart';

class SS extends VRCheck<int> {
    const SS();

    @override
    VR get vr => VR.kSS;

    @override
    bool isValid(int i) => Int16.inRange(i);
}
