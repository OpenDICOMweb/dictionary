// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

const a = const ['YES', 'NO'];
const b = const [#YES, #NO];

void main() {
 // const c = const ["YES", "NO"];
 // final d = const [#YES, #NO];

  print('a.constains: ${a.contains('YES')}');
  print('a.indexOf: ${a.indexOf('YES')}');

  print('b.constains: ${a.contains('YES')}');
  print('b.indexOf: ${a.indexOf('YES')}');

  print('c.constains: ${a.contains('YES')}');
  print('c.indexOf: ${a.indexOf('YES')}');

  print('d.constains: ${a.contains('YES')}');
  print('d.indexOf: ${a.indexOf('YES')}');
}
