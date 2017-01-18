// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dicom.dart';

import 'vr_check.dart';

class AE extends VRCheck<String> {
  const AE();

  @override
  VR get vr => VR.kAE;

  @override
  bool isValid(String s) => isAEString(s);

  String hasError(String s);
}

class AS extends VRCheck<String> {
  const AS();

  @override
  VR get vr => VR.kAS;

  @override
  bool isValid(String s) => isASString(s);
}

class CS extends VRCheck<String> {
  const CS();

  @override
  VR get vr => VR.kCS;

  @override
  bool isValid(String s) => isCSString(s);
}

class DA extends VRCheck<String> {
  const DA();

  @override
  VR get vr => VR.kDA;

  @override
  bool isValid(String s) => isDAString(s);
}

class DS extends VRCheck<String> {
  const DS();

  @override
  VR get vr => VR.kDS;

  @override
  bool isValid(String s) => isDSString(s);
}

class DT extends VRCheck<String> {
  const DT();

  @override
  VR get vr => VR.kDT;

  @override
  bool isValid(String s) => isDTString(s);
}

class IS extends VRCheck<String> {
  const IS();

  @override
  VR get vr => VR.kIS;

  @override
  bool isValid(String s) => isISString(s);
}

class LO extends VRCheck<String> {
  const LO();

  @override
  VR get vr => VR.kLO;

  @override
  bool isValid(String s) => isLOString(s);
}

class LT extends VRCheck<String> {
  const LT();

  @override
  VR get vr => VR.kLT;

  @override
  bool isValid(String s) => isLTString(s);
}

class PN extends VRCheck<String> {
  const PN();

  @override
  VR get vr => VR.kPN;

  @override
  bool isValid(String s) => isPNString(s);
}

class SH extends VRCheck<String> {
  const SH();

  @override
  VR get vr => VR.kSH;

  @override
  bool isValid(String s) => isSHString(s);
}

class ST extends VRCheck<String> {
  const ST();

  @override
  VR get vr => VR.kST;

  @override
  bool isValid(String s) => isSTString(s);
}

class TM extends VRCheck<String> {
  const TM();

  @override
  VR get vr => VR.kTM;

  @override
  bool isValid(String s) => isTMString(s);
}

class UC extends VRCheck<String> {
  const UC();

  @override
  VR get vr => VR.kUC;

  @override
  bool isValid(String s) => isUCString(s);
}

class UI extends VRCheck<String> {
  const UI();

  @override
  VR get vr => VR.kUI;

  @override
  bool isValid(String s) => isUIString(s);
}

class UR extends VRCheck<String> {
  const UR();

  @override
  VR get vr => VR.kUR;

  @override
  bool isValid(String s) => isURString(s);
}

class UT extends VRCheck<String> {
  const UT();

  @override
  VR get vr => VR.kUT;

  @override
  bool isValid(String s) => isUTString(s);
}
