// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/date_time/time_zone.dart';
import 'package:test/test.dart';

void main() {
  group("Test for TimeZone", () {
    test("isValidString", () {
      String validtz = "-1200";
      var tz = TimeZone.isValidString(validtz, start: 0, end: validtz.length);
      expect(tz, true);

      validtz = "+1400";
      tz = TimeZone.isValidString(validtz, start: 0, end: validtz.length);
      expect(tz, true);

      validtz = "-1134";
      tz = TimeZone.isValidString(validtz, start: 0, end: validtz.length);
      expect(tz, true);

      validtz = "+1245";
      tz = TimeZone.isValidString(validtz, start: 0, end: validtz.length);
      expect(tz, true);

      String invalidtz = "-1345";
      tz = TimeZone.isValidString(invalidtz, start: 0, end: invalidtz.length);
      expect(tz, false);

      invalidtz = "1500";
      tz = TimeZone.isValidString(invalidtz, start: 0, end: invalidtz.length);
      expect(tz, false);
    });

    test("parse", () {
      String goodtimezone = "-1200";
      var tz = TimeZone.parse(goodtimezone, start: 0, end: goodtimezone.length);
      expect(tz, isNotNull);

      goodtimezone = "+0500";
      tz = TimeZone.parse(goodtimezone, start: 0, end: goodtimezone.length);
      expect(tz, isNotNull);

      String badtimezone = "+1600";
      tz = TimeZone.parse(badtimezone, start: 0, end: badtimezone.length);
      expect(tz, null);
    });

    test("toTimeZoneMinutes", () {
      var tz = TimeZone.toTimeZoneMinutes(1, -12, 0);
      expect(tz, isNotNull);

      tz = TimeZone.toTimeZoneMinutes(-1, 11, 30);
      expect(tz, isNotNull);

      tz = TimeZone.toTimeZoneMinutes(1, 5, 45);
      expect(tz, isNotNull);

      tz = TimeZone.toTimeZoneMinutes(-1, 11, 12);
      expect(tz, null);

      tz = TimeZone.toTimeZoneMinutes(1, -12, 50);
      expect(tz, null);
    });

    test("issue", () {
      String goodtimezone = "+1045";
      var issues = TimeZone.issues(goodtimezone, start: 0);
      expect(issues.isEmpty, true);

      String badtimezone = "1600";
      issues = TimeZone.issues(badtimezone, start: 0);
      expect(issues.isEmpty, false);
    });
  });
}
