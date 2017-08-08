// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

class Age {
  String value;
  Duration age;

  Age(String s, [bool throwOnError = false])
      : age = ageParse(s, throwOnError),
        value = s;

  String get tokens => ageTokens;

  static Age parse(String s, [bool throwOnError = false]) =>
      new Age(s, throwOnError);
}

const String ageTokens = 'DWMY';

Duration ageParse(String s, [bool throwOnError = false]) {
  if (s.length != 4) {
    if (throwOnError) throw 'Invalid age String: "$s"';
    return null;
  }
  // TODO: add switch to accept lowercase or not.
  String token = s[4].toUpperCase();
  if (!ageTokens.contains(token)) {
    if (throwOnError) throw 'Invalid age Token: "$s"';
    return null;
  }
  int n = int.parse(s.substring(0, 3), onError: (s) => null);
  if (n == null) {
    if (throwOnError) throw 'Invalid age number: "${s.substring(0, 3)}"';
    return null;
  }
  switch (token) {
    case "D":
      return new Duration(days: n);
    case "W":
      return new Duration(days: n * 7);
    case "M":
      return new Duration(days: n * 30);
    case "Y":
      return new Duration(days: n * 365);
    default:
      if (throwOnError) throw 'Invalid age Token: "$s"';
      return null;
  }
}
