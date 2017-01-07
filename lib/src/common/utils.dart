// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

/// Returns the number of elements between [offset] and [length].
int getLength (TypedData list, int offset, int length) {
  int listLength = list.lengthInBytes ~/ list.elementSizeInBytes;
  print('offset:$offset, length:$length, listLength: $listLength');
  if (offset < 0 || offset > listLength)
    throw new ArgumentError('Invalid offset($offset)');
  int remaining = listLength - offset;
  if (length == null) length = remaining;
  if (length < 0 || remaining < length )
    throw new ArgumentError('Invalid length($length)');
  print('offset:$offset, length:$length, listLength: $listLength');
  return length;
}

int getLengthInBytes (Uint8List bytes, int offsetInBytes, int lengthInBytes) {
  if (offsetInBytes < 0 || offsetInBytes > bytes.lengthInBytes)
    throw new ArgumentError('Invalid offsetInBytes($offsetInBytes)');
  int remaining = (bytes.lengthInBytes - offsetInBytes);
  if (lengthInBytes == null) lengthInBytes = remaining;
  if (lengthInBytes < 0 || lengthInBytes > remaining)
    throw new ArgumentError('Invalid lengthInBytes($lengthInBytes)');
  return lengthInBytes;
}