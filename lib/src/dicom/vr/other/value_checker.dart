// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:dictionary/src/dicom/issue.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

typedef bool _VRIsValidValues(List values);
typedef List _VRCheckValues(List values);
typedef Issue _VRGetIssue(List values);

abstract class VRChecks {

    _VRIsValidValues _isValid;
    _VRCheckValues _checkValues;
    _VRGetIssue _getIssues;



    //VRCheckers(VR vr, );

    bool validValues(List values);

    Issue getIssue(List values);
}

class AEChecks {
  static const VR vr = VR.kAE;

  /// Returns [true] if all values are valid.
  static bool validValues(List<String> values) {

  }

  /// Returns [values], if valid; otherwise null.
  static List<String> checkValues(List<String> values) {

  }

  /// Returns an [Issue] if the values are incorrect, or not best practices
  static Issue getIssue(List<String> values) {

  }

  /// Returns [true] if [bytes] contains valid values.
  static bool validBytes(Uint8List bytes) {

  }

  /// Returns [bytes], if valid; otherwise null.
  static List<String> checkBytes(Uint8List bytes) {

  }

  /// Returns [true] if [bytes] contains valid values.
  static Issue getBytesIssue(Uint8List bytes) {

  }

  /// Returns a list of valid [values] converted from [bytes].
  static List<String> bytesToValues(Uint8List bytes) {

  }
}