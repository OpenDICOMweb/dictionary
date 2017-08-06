// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The base [List] of a DICOM Defined Term that contains [String]s.
class _DTBase {
  static const kPhotometricInterpretationBase = const [
    "MONOCHROME1", "MONOCHROME2", "PALETTE COLOR", "RGB", "HSV", // No reformat.
    "ARGB", "CMYK", "YBR_FULL", "YBR_FULL_422", "YBR_PARTIAL_422",
    "YBR_PARTIAL_420", "YBR_ITC", "YBR_RCT"
  ];
}

/// A class that lets implementations add their own Defined Terms.
class DefinedTerm {
  final List<String> base;
  final List<String> _others = <String>[];

  /// An internal constructor used for static const.
  /// Note: [base] must not be null, and [_others] must be non-empty.
  DefinedTerm(this.base);

  /// Adds a new [String] to the defined term.
  void add(String value) => (_isNotPresent(value)) ? _others.add(value) : null;

  /// Adds a new [List<String>] to the defined term. Any [String]s already
  /// present are not added.
  void addAll(List<String> values) {
    for (String value in values) add(value);
  }

  /// Returns true if [value] is in [this].
  bool contains(String value) =>
      base.contains(value) || _others.contains(value);

  //TODO: needs testing
  /// Returns true if [value] is in [this].
  int indexOf(String value) {
    int index = base.indexOf(value);
    if (index != -1) return index;
    index = _others.indexOf(value);
    if (index == -1) return index;
    return (base.length + index) - 1;
  }

  /// Returns true if [value] is a Defined Term in the DICOM Standard.
  bool isStandard(String value) => base.contains(value);

  /// Returns true if [value] is a Term Defined the implementation.
  bool isNonStandard(String value) => _others.contains(value);

  /// Returns [true] if [term] is NOT present in [this].
  bool _isNotPresent(String term) =>
      !(base.contains(term) || _others.contains(term));

  static final kPhotometricInterpretation =
      new DefinedTerm(_DTBase.kPhotometricInterpretationBase);
}
