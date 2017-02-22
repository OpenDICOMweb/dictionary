// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

void main() {
  //UuidV4Generator generator = new UuidV4Generator();
  Uid uid = Uid.random;
  checkRandomUid(uid);
  for (int i = 0; i < 1000; i++) {
    Uuid uuid = new Uuid();
    checkUuid(uuid);
    print('$i:');
    print("  a:$uuid");
    uuid = new Uuid();
    checkUuid(uuid);
    print("  b:$uuid");
    uuid = new Uuid(isSecure: true);
    checkUuid(uuid);
    print("  c:$uuid");
  }
}

void checkUuid(Uuid uuid) {
  String s = uuid.toString();
  Uuid uuid1 = Uuid.parse(s);
  String t = uuid1.toString();
  if (s != t) print('$s != $t');
  if (!uuid1.isValid) print("**** Uuid1: $uuid");
  if (uuid != uuid1) throw "Uuid $uuid != $uuid1";
  if (s.length != 36) print("invalid length ${s.length} in $s");
  if (s[14] != "4") print("No 4 at Byte 6 (${s[14]} in Uuid: $uuid");
  if (!"89AaBb".contains(s[19]))
    print("No 8|9|A|B at Byte 8 (${s[19]} in Uuid: $uuid");
  if (!uuid.isValid) {
    print("**** Uuid: $uuid");
  }
}

void checkRandomUid(Uid uid) {
  String s = uid.asString;
  print('Uid: $s');
}
