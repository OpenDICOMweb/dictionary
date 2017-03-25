// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


import 'package:common/logger.dart';
import 'package:dictionary/date_time.dart';
import 'package:test/test.dart';

final Logger log = new Logger('DateTimeTests', watermark: Severity.debug);

void main() {
  var s = "+0000";

  for (int i = 0; i < goodTimeZones.length; i++) {
    var s = goodTimeZones[i];
    int tzm = parseTimeZone(s);
    log.debug('Good parseTimeZone: "$s"');
    log.debug('  tzm: $tzm, ${goodTimeZonesValues[i]}');
    bool valid = isValidTimeZone(s);
    log.debug("  isValid: $valid");
    var issues = new ParseIssues('parseTimeZone', s);
    getTimeZoneIssues(s, 0, issues);
    log.debug('  Issues: "$issues"');
  }

  for (int i = 0; i < badTimeZones.length; i++) {
    var s = badTimeZones[i];
    int tzm = parseTimeZone(s);
    log.debug('Bad parseTimeZone: "$s"');
    log.debug('  tzm: $tzm');
    bool valid = isValidTimeZone(s);
    log.debug("  isValid: $valid, valid==$valid");
    var issues = new ParseIssues('parseTimeZone', s);
    getTimeZoneIssues(s, 0, issues);
    log.debug('  Issues: "$issues"');
  }
  // timeZoneTest();
}

const List<String> goodTimeZones = const <String>[
  "+0000", "+0100", "-0100", "+0130", "-0145", "-1200", "+1400" // no fmt
];

const List<int> goodTimeZonesValues = const <int>[
  0, 60, -60, 90, -105, -12 * 60, 14 * 60// no fmt
];

const List<String> badTimeZones = const <String>[
  "-0000", // not valid UTC
  "-1300", // hour out of range
  "+1500", // hour out of range
  "-a000", // bad char
  "-0b00", // bad char
  "-00C0", // bad char
  "-000*", // bad char
  "*0a00", // bad char
  "+0131", // bad minute
  "-0115" // bad minute
];

void timeZoneTest() {
  
  group('DCM Time Zone tests', () {


    test('Good parseTimeZone', () {
      for(String s in goodTimeZones) {
        int tzm = parseTimeZone(s);
        log.debug('Good parseTimeZone: "$s", tzm: $tzm');
        expect(tzm, isNotNull);
        expect(isValidTimeZone(s), true);
        var issues = new ParseIssues('parseTimeZone', s);
        getTimeZoneIssues(s, 0, issues);
        log.debug('Issues: $issues');
        expect(issues, equals(""));
      }
      
    });


    
  });

}