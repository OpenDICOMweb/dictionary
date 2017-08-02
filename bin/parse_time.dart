// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:dictionary/src/date_time/parse.dart';

final Logger log = new Logger('time_test.dart', Level.debug);


List<List<int>> goodTimeValuesWOFractions = <List<int>>[
   [12, 34, 56, 0], //no reformat
   [00, 00, 00, 0], [01, 01, 01, 0], [09, 09, 09, 0], [10, 10, 10, 0],
   [11, 11, 11, 0], [11, 11, 11, 0], [19, 49, 49, 0], [20, 55, 55, 0],
   [21, 56, 56, 0], [22, 57, 57, 0], [23, 58, 58, 0], [23, 59, 59, 0]
];

const List<String> goodTimeStringsWOFractions  = const <String>[
  '123456', //no reformat
  '000000', '010101', '090909', '101010',
  '111111', '111111', '194949', '205555',
  '215656', '225757', '235858', '235959'
];

const List<String> badTimeStringsWOFractions  = const <String>[
  'abcdef',
'-00000', '0**101', '09**09', '101**1', '1111**', '11111*',
'a00000', '0b0101', '09c909', '101d10', '1111e1', '11111f',
'244949', '206055', '215660', '255757', '236158', '235961' //no reformat
];

int  listToUSeconds(List<int> v) =>
    v[0] * kMicrosecondsPerHour + v[1] * kMicrosecondsPerMinute + v[2] *
        kMicrosecondsPerSecond + v[3];

void main() {

  if (goodTimeStringsWOFractions.length != goodTimeValuesWOFractions.length)
    throw 'Unequal lengths';
  log.debug('Parse Good Times W/O Fractions:');
  for (int i = 0; i < goodTimeStringsWOFractions.length; i++) {
    var s = goodTimeStringsWOFractions[i];
    log.debug('  Parse Good Fraction: "$s"');
    int us = parseDcmTime(s);
    log.debug('                   $us');
    var v = goodTimeValuesWOFractions[i];
    var usv = listToUSeconds(v);
    log.debug('                   $usv');
    if (us != usv) throw '    Unequal Values: us: $us, usv: $usv';
  }

  log.debug('Parse Bad badTimeStringsWOFractions:');
  for (int i = 0; i < badTimeStringsWOFractions.length; i++) {
    var s = badTimeStringsWOFractions[i];
    log.debug('  Parse Bad Fraction: "$s"');
    int f = parseDcmTime(s);
    log.debug('                       $f');
    if (f != null) throw '    Non-Null Value: f: $f';
  }

  log.debug('Parse Good Time Fractions:');
  log.debug('Good Time Fractions:');
  for (int i = 0; i < goodTimeStringsWOFractions.length; i++) {
    var s = goodTimeStringsWOFractions[i];
    log.debug('  Parse Good Time Fraction: "$s"');
    Time time = Time.parse(s);
    int us = time.inMicroseconds;
    log.debug('  Time Fraction: $time: us: $us');
    var v = goodTimeValuesWOFractions[i];
    var usv = listToUSeconds(v);
    log.debug('                          usv: $usv');
    if (us != usv) throw '    Unequal Values: us: $us, usv: $usv';
  }

  log.debug('Parse Bad Time Fractions:');
  for (int i = 0; i < badTimeStringsWOFractions.length; i++) {
    var s = badTimeStringsWOFractions[i];
    log.debug('  Parse Bad Time Fraction: "$s"');
    var issues = new ParseIssues('Bad Time Fraction', s);
    getDcmTimeIssues(s, issues: issues);
    log.debug('  $issues');
    if (issues.isEmpty)
      throw '  Issues is empty: ${issues.isEmpty}, issues: "$issues"';
  }
}
