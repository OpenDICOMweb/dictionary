// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';

final Logger log = new Logger('Uid2_Test', watermark: Severity.info);

void main() {
  //UuidV4Generator generator = new UuidV4Generator();
  Uid uid = Uid.random;
  checkRandomUid(uid);
  for (int i = 0; i < 1000; i++) {
    Uuid uuid = new Uuid();
    checkUuid(uuid);
    log.debug('$i:');
    log.debug("  a:$uuid");
    uuid = new Uuid();
    checkUuid(uuid);
    log.debug("  b:$uuid");
    uuid = new Uuid(isSecure: true);
    checkUuid(uuid);
    log.debug("  c:$uuid");
  }
}

void checkUuid(Uuid uuid) {
  String s = uuid.toString();
  Uuid uuid1 = Uuid.parse(s);
  String t = uuid1.toString();
  if (s != t) log.debug('$s != $t');
  if (!uuid1.isValid) log.debug("**** Uuid1: $uuid");
  if (uuid != uuid1) throw "Uuid $uuid != $uuid1";
  if (s.length != 36) log.debug("invalid length ${s.length} in $s");
  if (s[14] != "4") log.debug("No 4 at Byte 6 (${s[14]} in Uuid: $uuid");
  if (!"89AaBb".contains(s[19]))
    log.debug("No 8|9|A|B at Byte 8 (${s[19]} in Uuid: $uuid");
  if (!uuid.isValid) {
    log.debug("**** Uuid: $uuid");
  }
}

void checkRandomUid(Uid uid) {
  String s = uid.asString;
  log.debug('Uid: $s');
}
