// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/enum_values/enum_strings.dart';

/// The base [List] of a DICOM Defined Term that contains [String]s.
class DefinedStrings extends EnumStrings {
  const DefinedStrings._(List<String> values) : super(values);

  static const kPhotometricInterpretation = const DefinedStrings._(const [
    "MONOCHROME1", "MONOCHROME2", "PALETTE COLOR", "RGB", "HSV", // No reformat.
    "ARGB", "CMYK", "YBR_FULL", "YBR_FULL_422", "YBR_PARTIAL_422",
    "YBR_PARTIAL_420", "YBR_ITC", "YBR_RCT"
  ]);
}

/// A class that lets implementations add their own Defined Terms.
class XDefinedStrings {
  final DefinedStrings base;
  final List<String> others;

  /// An internal constructor used for static const.
  /// Note: [base] must not be null, and [others] must be non-empty.
  const XDefinedStrings._(this.base, this.others) ;

  /// An internal constructor used for static const.
  XDefinedStrings(this.base, this.others) {
    if (others == null || others.length == 0) throw "Others must not be empty";
  }

  void add(String value) => (_isNotPresent(value)) ? others.add(value) : null;
  void addAll(List<String> values) =>
      (_areNotPresent(values)) ? others.addAll(values) : null;

  /// Returns true if [value] is in [this].
  @override
  bool contains(String value) =>
      base.contains(value) || others.contains(value);

  /// Returns true if [value] is a Defined Term in the DICOM Standard.
  bool isStandard(String value) => base.contains(value);

  /// Returns true if [value] is a Term Defined the implementation.
  bool isNonStandard(String value) => others.contains(value);

  /// Returns [true] if [term] is NOT present in [this].
  bool _isNotPresent(String term) =>
      !(base.contains(term) || others.contains(term));

  /// Returns [true] if all [terms] are NOT present in [this].
  bool _areNotPresent(List<String> terms) {
    for (String value in terms) if (!_isNotPresent(value)) return false;
    return true;
  }
}
