// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dcm_date_time.dart';
import 'utils.dart';

/// A Time Zone Offset.
class TimeZone {
    /// The symbol for specifying a Universal Time Coordinate (UTC).
    static const String utcSymbol = "Z";

    /// The local [TimeZoneOffset] from UTC.
    static final Duration localOffset = DcmDateTime.startTime.timeZoneOffset;

    /// Returns the current time in the Local Time Zone.
    static final TimeZone local = new TimeZone(localOffset);

    /// Returns the current time as a UTC.
    static final TimeZone utc = new TimeZone(new Duration(minutes: 0));

    /// The [TimeZone].
    Duration offsetInMinutes;

    /// Creates a new [TimeZone] value;
    TimeZone(this.offsetInMinutes);

    /// Create a [TimeZone] of an offset in minutes.
    TimeZone.fromMinutes(int min) : offsetInMinutes = new Duration(minutes: min);

    /// Creates a [TimeZone] value from a Dart [DateTime].
    TimeZone.fromDateTime(DateTime dt) : offsetInMinutes = dt.timeZoneOffset;

    /// Creates a [TimeZone] with the specified offset in [hours] and [minutes].
    factory TimeZone.fromOffset(int sign, int hour, int minute) {
        assert(isSign(sign));
        assert(isHour(hour));
        assert(isMinute(minute));
        return new TimeZone(new Duration(minutes: (sign * (hour * 60)) + minute));
    }

    /// Returns [true] is [this] is equal to [other].
    @override
    bool operator ==(Object other) => (other is TimeZone) && (offsetInMinutes == other.offsetInMinutes);

    /// Returns [true] is [this] is greater than [other].
    bool operator <(Object other) => (other is TimeZone) && offsetInMinutes < other.offsetInMinutes;

    /// Returns [true] is [this] is less than [other].
    bool operator >(Object other) => (other is TimeZone) && offsetInMinutes > other.offsetInMinutes;

    /// Returns the [sign] of the [TimeZoneOffset].
    int get sign => (offsetInMinutes.isNegative) ? -1 : 1;

    /// Returns the [TimeZone] in hours.
    int get inHours => offsetInMinutes.inHours;

    /// Returns the absolute value of [TimeZone] hours.
    int get hours => offsetInMinutes.inHours.abs();

    /// Returns the [TimeZone] in minutes.
    int get inMinutes => offsetInMinutes.inMinutes;

    /// Returns the absolute value of [TimeZone] minutes.
    int get minutes => offsetInMinutes.inMinutes.abs() - (hours * 60);

    /// Returns [true] if the [TimeZoneOffset] is negative.
    bool get isNegative => offsetInMinutes.isNegative;

    /// Returns [true] if the [TimeZoneOffset] is zero, i.e. it is the UTC [TimeZone].
    bool get isUtc => inMinutes == 0;

    /// Returns the [TimeZone] as an offset from UTC in Internet format.
    String get offsetString => (isNegative) ? '-$hours\:$minutes' : '+$hours\:$minutes';

    /// Returns the [TimeZone] as an offset from UTC in DICOM format.
    String get dcmString => offsetString;

    /// Returns a hashCode for [this].
    @override
    int get hashCode => offsetInMinutes.hashCode;

    /// Return the UTC symbol (Z) if the [TimeZone] is UTC; otherwise,
    /// returns the offset from UTC of [this] as a [String].
    @override
    String toString() => (isUtc) ? "Z" : offsetString;

    /// Creates a [TimeZone] by parsing the specified DICOM format [String].
    static TimeZone dcmParse(String tzo, [int start = 0]) {
        if (start == tzo.length) return local;
        return parseTimeZone(tzo, start);
    }

    /// Creates a [TimeZone] by parsing the specified [String].
    static TimeZone parse(String tzo, [int start = 0]) {
        if (start == tzo.length) return local;
        if (tzo[start] == 'Z' || tzo[start] == 'z') return new TimeZone.fromMinutes(0);
        if (tzo[start + 3] == ":") throw "Missing Time Separator(:)";
        return parseTimeZone(tzo, start, 1);
    }

}
