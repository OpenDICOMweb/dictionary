// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


class VRDcmDate extends VRString {
  const VRDcmDate._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
      minValueLength, maxValueLength);

  @override
  bool isValid(String s) => parse(s) != null;

  @override
  ParseIssues issues(String s) => Date.issues(s);

  @override
  Date parse(String s) => Date.parse(s.trimRight());

  /// Fix
  @override
  String fix(String s) {
    var t = s.trimRight();
    //TODO: trucate on error what other fixes?
    return t;
  }

  static const VRDcmDate kDA =
  const VRDcmDate._(6, 0x4144, "DA", 2, kMaxShortVF, "DateString", 8, 8);
}

class VRDcmDateTime extends VRString {
  const VRDcmDateTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
      minValueLength, maxValueLength);

  @override
  bool isValid(String s) => DcmDateTime.isValidString(s.trimRight());

  @override
  ParseIssues issues(String s) => DcmDateTime.issues(s);

  @override
  DcmDateTime parse(String s) => DcmDateTime.parse(s.trimRight());

  /// Fix
  @override
  String fix(String s) {
    var t = s.trimRight();
    //TODO: truncate on error? what other fixes?
    return t;
  }

  static const VRDcmDateTime kDT = const VRDcmDateTime._(
      8, 0x5444, "DT", 2, kMaxShortVF, "DateTimeString", 4, 26);
}



class VRDcmTime extends VRString {

  const VRDcmTime._(int index, int code, String id, int vfLengthSize,
      int maxVFLength, String keyword, int minValueLength, int maxValueLength)
      : super._(index, code, id, vfLengthSize, maxVFLength, keyword,
      minValueLength, maxValueLength);

  @override
  bool isValidString(String timeString) => Time.isValidString(timeString) !=
      null;

  @override
  ParseIssues issues(String timeString) => Time.issues(timeString);

  /// Parse DICOM Time and if valid return a [Duration]; otherwise, [null].
  @override
  Time parse(String timeString) => Time.parse(timeString.trimRight());


  /// Fix
  @override
  String fix(String timeString) {
    var t = timeString.trimRight();
    //TODO:
    // truncate on error, what other fixes? if separator (:) present - remove.
    // if time zone marker present??
    return t;
  }

  static const VRDcmTime kTM =
  const VRDcmTime._(25, 0x4d54, "TM", 2, kMaxShortVF, "TimeString", 2, 14);
}

