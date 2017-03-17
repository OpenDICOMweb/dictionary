// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

void main() {
  int max16BitUint = 0xFFFF;
  int maxShortVF = max16BitUint - 1;
  print('0xFFFF    =             $max16BitUint');
  print('0xFFFF isOdd?:          ${max16BitUint.isOdd}');
  print('0xFFFF - 1 =            $maxShortVF');
  print('0xFFFF isOdd?:          ${maxShortVF.isOdd}');
  int max32BitUint = 0xFFFFFFFF;
  int maxLongVF = max32BitUint - 1;
  print('0xFFFFFFFF =            $max32BitUint');
  print('0xFFFFFFFF isOdd?:      ${max32BitUint.isOdd}');
  print('0xFFFFFFFF - 1 =        $maxLongVF');
  print('0xFFFFFFFF - 1 isOdd?:  ${maxLongVF.isOdd}');
}
