// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'vr.dart';

/// Floating Point [VR]s.
//TODO: doc
class VRParsable extends VR<String> {
    const VRParsable._(int index, int code, String id, int elementSize,
    int vfLengthFieldSize, int maxVFLength, String keyword)
        : super(index, code, id, elementSize, vfLengthFieldSize, maxVFLength,
    keyword);



    }