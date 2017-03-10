// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'package:dictionary/src/string/utils.dart';
import 'package:test/test.dart';

void main() {
  print('baseAsString: $prefixYear');
  print('baseDate: $baseDate');
  timeTest();
}

const String baseYear = '19700101';
const String prefixYear = baseYear + 'T';
final DateTime baseDate = new DateTime(1970, 01, 01);

bool isValid(String s) => parse(s) != null;

Duration parse(String s) {
  var t = s;
  var length = t.length;
  if (length < 6) {
    if (length == 0 || length.isOdd) return null;
    if (length == 2) t += '0000';
    if (length == 4) t += '00';
  }
  var dts = prefixYear + t;
  DateTime dt;
  Duration time;
  try {
    dt = DateTime.parse(dts);
  } on FormatException catch (e) {
    print('Format Error($dts): $e');
    return null;
  }
  time = dt.difference(baseDate);
  return time;
}

void timeTest() {
  List<String> goodTimes = [
    "12",
    "1212",
    "121212",
    "010101.99",
    "121212.999",
    "101010.9999"
  ];

  group('Good Times', () {
    test("Good Time Strings", () {
      for (int i = 0; i < goodTimes.length; i++) {
        var t = goodTimes[i];
        var time = parse(t);
        expect(time is Duration, true);
      }
    });
  });

  List<String> badTimes = [
    "",
    "1",
    "123",
    "12345",
    "10101.99",
    "a21212.999",
    "101010.b999"
  ];

  group('Bad Times', () {
    test("Bad Time Strings", () {
      for (int i = 0; i < badTimes.length; i++) {
        var t = badTimes[i];
        print('t: "$t"');
        var time = parse(t);
        print('Time: $time');
        expect(time == null, true);
      }
    });
  });
}
