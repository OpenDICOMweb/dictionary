// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:math';

const int hoursPerDay = 24;
const int minutesPerDay = hoursPerDay * minutesPerHour;
const int secondsPerDay = minutesPerDay * secondsPerMinute;
const int millisecondsPerDay = secondsPerDay * millisecondsPerSecond;
const int microsecondsPerDay = millisecondsPerDay * microsecondsPerMillisecond;
const int nanosecondsPerDay = microsecondsPerDay * nanosecondsPerMicrosecond;

const int minutesPerHour = 60;
const int secondsPerHour = minutesPerHour * secondsPerMinute;
const int millisecondsPerHour = secondsPerHour * millisecondsPerSecond;
const int microsecondsPerHour =
    millisecondsPerHour * microsecondsPerMillisecond;
const int nanosecondsPerHour = microsecondsPerHour * nanosecondsPerMicrosecond;

const int secondsPerMinute = 60;
const int millisecondsPerMinute = secondsPerMinute * millisecondsPerSecond;
const int microsecondsPerMinute =
    millisecondsPerMinute * microsecondsPerMillisecond;
const int nanosecondsPerMinute =
    microsecondsPerMinute * nanosecondsPerMicrosecond;

const int millisecondsPerSecond = 1000;
const int microsecondsPerSecond =
    millisecondsPerSecond * microsecondsPerMillisecond;
const int nanosecondsPerSecond =
    microsecondsPerSecond * nanosecondsPerMicrosecond;

const int microsecondsPerMillisecond = 1000;
const int nanosecondsPerMillisecond =
    microsecondsPerMillisecond * nanosecondsPerMicrosecond;

const int nanosecondsPerMicrosecond = 1000;

int toMicroseconds(int h, int m, int s, int ms, int us) =>
    h * microsecondsPerHour +
    m * microsecondsPerMinute +
    s * microsecondsPerSecond +
    ms * microsecondsPerMillisecond +
    us;

int toNanoseconds(int h, int m, int s, int ms, int us, int ns) =>
    toMicroseconds(h, m, s, ms, us) * ns;

void main() {
  print('microsecondsPerDay: $microsecondsPerDay');
  print('2^32: ${1 << 32}');
  print('2^37: ${1 << 37}');
  print('log10: ${log(microsecondsPerDay)}');

  print('nanosecondsPerDay: $nanosecondsPerDay');
  print('log10: ${log(nanosecondsPerDay)}');
  print('2^44: ${1 << 44}');
}
