// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/terminology/term.dart';

import 'defined_terms_base.dart';

class PhotometricInterpretation extends DefinedTerm<String> {
  const PhotometricInterpretation(int index, String name, String value, Term definition,
      [bool isRetired = false])
      : super(index, name, value, definition);

  @override
  PhotometricInterpretation lookup(String name) => map[name];

  Iterable<String> get keys => map.keys;

  Iterable<PhotometricInterpretation> get values => map.values;

  static const PhotometricInterpretation kMonochrome1 =
      const PhotometricInterpretation(0, "Monochrome1", "MONOCHROME1", Term.kMonochrome1);

  static const PhotometricInterpretation kMonochrome2 =
      const PhotometricInterpretation(0, "Monochrome2", "MONOCHROME2", Term.kMonochrome2);

  static const PhotometricInterpretation kMonochrome3 =
      const PhotometricInterpretation(0, "Monochrome3", "MONOCHROME3", Term.kMonochrome3);

  static const PhotometricInterpretation kRGB = const PhotometricInterpretation(0, "RGB", "RGB", Term.kRGB);

  static const PhotometricInterpretation kHSV = const PhotometricInterpretation(0, "HSV", "HSV", Term.kHSV, true);

  static const PhotometricInterpretation kARGB =
      const PhotometricInterpretation(0, "ARGB", "ARGB", Term.kARGB, true);

  static const PhotometricInterpretation kCMYK =
      const PhotometricInterpretation(0, "CMYK", "CMYK", Term.kCMYK, true);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_FULL =
      const PhotometricInterpretation(0, "YBR_FULL", "YBR_FULL", Term.kYBR_FULL);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_FULL_422 = const PhotometricInterpretation(
      0, "YBR_FULL_422", "YBR_FULL_422", Term.kYBR_FULL_422);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_PARTIAL_422 = const PhotometricInterpretation(
      0, "YBR_PARTIAL_422", "YBR_PARTIAL_422", Term.kYBR_PARTIAL_422);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_PARTIAL_420 = const PhotometricInterpretation(
      0, "YBR_PARTIAL_420", "YBR_PARTIAL_420", Term.kYBR_PARTIAL_420, true);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_ICT =
      const PhotometricInterpretation(0, "YBR_ICT", "YBR_ICT", Term.kYBR_ICT);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_RCT =
      const PhotometricInterpretation(0, "YBR_RCT", "YBR_RCT", Term.kYBR_RCT);

  static const Map<String, PhotometricInterpretation>map = const {
    "MONOCHROME1": kMonochrome1,
    "MONOCHROME2": kMonochrome2,
    "MONOCHROME3": kMonochrome3,
    "RGB": kRGB,
    "HSV": kHSV,
    "ARGB": kARGB,
    "CMYK": kCMYK,
    "YBR_FULL": kYBR_FULL,
    "YBR_FULL_422": kYBR_FULL_422,
    "YBR_PARTIAL_422": kYBR_PARTIAL_420,
    "YBR_PARTIAL_420": kYBR_PARTIAL_420,
    "YBR_ICT": kYBR_ICT,
    "YBR_RCT": kYBR_RCT
  };
}
