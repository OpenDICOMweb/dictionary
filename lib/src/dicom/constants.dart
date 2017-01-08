// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/constants.dart';
//**** DICOM Constants ****

/// Used to pad string value fields to an even length.
const int kStringPaddingChar = kAsciiSpace;

/// Used to pad Uid value fields to an even length.
const int kUidPaddingChar = 0;

/// The maximum length, in bytes, of a "short" (16-bit) Value Field.
const int kMaxShortLengthInBytes = 0xFFFF;

/// The maximum length, in bytes, of a "long" (32-bit) Value Field.
const int kMaxLongLengthInBytes = (1 << 32) - 1;

/// This is the value of a DICOM Undefined Length from a 32-bit Value Field Length.
const kUndefinedLength = 0xFFFFFFFF;

bool hasUndefinedLength(int i) => i == kUndefinedLength;

// Transfer Syntax
const int transferSyntaxTag = 0x00020010;

