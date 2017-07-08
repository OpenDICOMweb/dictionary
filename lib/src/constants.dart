// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:common/common.dart';

/// The maximum value of an unsigned 16-bit integer (2^32).
const int kUint16Max = 0xFFFF;

/// The maximum value of an unsigned 32-bit integer (2^32).
const int kUint32Max = 0xFFFFFFFF;

//**** DICOM Constants ****

/// The maximum length, in bytes, of a "short" (16-bit) Value Field.
///
/// Notes:
///     1. Short Value Fields may not have an Undefined Length
///     2. All Value Fields must contain an even number of bytes.
///     Thus, while the Value Field is 16-bits, the maximum length
///     is 1 less then 2^16, which is an odd number.
const int kMaxShortVF = kUint16Max - 1;

/// The maximum length, in bytes, of a "long" (32-bit) Value Field.
///
/// Note: the values is `[kUint32Max] - 1` because the maximum value
/// (0xFFFFFFFF) is used to denote a Value Field with Undefined Length.
const int kMaxLongVF = kUint32Max - 1;

/// This is the value of a DICOM Undefined Length from a 32-bit
/// Value Field Length.
const int kUndefinedLength = 0xFFFFFFFF;

bool hasUndefinedLength(int i) => i == kUndefinedLength;

// Special Tag Related constants

/// This corresponds to the first 16-bits of kSequenceDelimitationItem,
/// kItem, and kItemDelimitationItem which are the same value.
const int kDelimiterFirst16Bits = 0xFFFE;

/// This corresponds to the last 16-bits of kSequenceDelimitationItem.
const int kSequenceDelimiterLast16Bits = 0xE0DD;

/// This corresponds to the last 16-bits of kItemDelimitationItem.
const int kItemLast16bits = 0xE000;

/// This corresponds to the last 16-bits of kItemDelimitationItem.
const int kItemDelimiterLast16bits = 0xE00D;

// Next 3 values are 2x16bit little Endian values as one 32bitLE value.
// This allows fast access and comparison

// kItem as 2x16Bit LE == 0xfffee000
const int kItem32BitLE = 0xe000fffe;

// [kItemDelimitationItem] as 2x16-bit LE == 0xfffee00d;
const int kItemDelimitationItem32BitLE = 0xe00dfffe;

// [kSequenceDelimitationItem] as 2x16bit LE == 0xfffee0dd;
const int kSequenceDelimitationItem32BitLE = 0xe0ddfffe;


/// The value appended to odd length UID Value Fields to make them even length.
const int kUidPaddingChar = kNull;

/// The value appended to odd length [String] Value Fields to make them
/// even length.
const int kStringPaddingChar = kSpace;

/// The value appended to odd length Uint8 Value Fields (OB, UN) to make
/// them even length.
const int kUint8PaddingValue = 0;

/// Fix: move to constants in Dictionary
const int kSQCode = 0x5153;
const int kOBCode = 0x424f;
const int kOWCode = 0x574f;
const int kUNCode = 0x4e55;

const List<int> kUndefinedLengthElements = const <int>[
  kOBCode,
  kOWCode,
  kUNCode
];



