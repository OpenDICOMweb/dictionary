// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

/// A DICOM Information Object Definition
class IOD {
  final int tag;
  final int keywordIndex;
  final int nameIndex;
  final int vrIndex;
  final int vmIndex;
  final int _vmMin;
  final int _vmMax;
  final int _vmWidth;
  final int aTypeIndex;
  final bool isRetired;

  const IOD(this.tag, this.keywordIndex, this.nameIndex, this.vrIndex, this.vmIndex,
            this._vmMin, this._vmMax, this._vmWidth, this.aTypeIndex, this.isRetired);

  VR get vr => VR.vrs[vrIndex];

  VM get vm => VM.vms[vmIndex];

  bool get isVM1 => (_vmMin == 1) && (_vmMax == 1) && (_vmWidth == 1);

  int get vmMin => _vmMin * _vmWidth;

  int get vmMax => _vmMax * _vmWidth;

  bool vmInRange(int vfLength) => (vmMin <= vfLength) && (vfLength <= vmMax);

  static const IOD foo = const IOD(1, 1, 1, 1, 1, 1, 1, 1, 1, false);


}

const List<int> vrTable = const [0, 1, 2];

const List<int> aTypeTable = const [1, 2, 3];