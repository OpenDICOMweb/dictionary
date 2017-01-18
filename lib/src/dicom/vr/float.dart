// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/dicom.dart';

import 'vr_check.dart';

class FD extends VRCheck<double> {
    const FD();

    @override
    VR get vr => VR.kFD;

    @override
    bool isValid(double n) => true;
}

class FL extends VRCheck<double> {
    const FL();

    @override
    VR get vr => VR.kFL;

    //TODO: what to check?
    @override
    bool isValid(double n) => true;


}