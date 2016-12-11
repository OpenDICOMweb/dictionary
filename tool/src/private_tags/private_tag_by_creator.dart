// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'private_tags.dart';

void main(List<String> args) {
  Map<String, List> map = {};
  for (int i = 1; i < privateTagArray.length; i++) {
    List v = privateTagArray[i];
    String creator = v[1];

    List entry = map[creator];
    if (entry == null) {
      map[creator] = [v];
    } else {
      entry.add(v);
    }
  }

  print('map has ${map.length} creators');

  map.forEach((key, values) {
    print('$key: ${values.length}');
  });


}
