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

  PhotometricInterpretation lookup(String name) => map[name];

  Iterable<String> get keys => map.keys;

  Iterable<PhotometricInterpretation> get values => map.values;

  static const kMonochrome1 =
      const PhotometricInterpretation(0, "Monochrome1", "MONOCHROME1", Term.Monochrome1);

  static const kMonochrome2 =
      const PhotometricInterpretation(0, "Monochrome2", "MONOCHROME2", Term.Monochrome2);

  static const kMonochrome3 =
      const PhotometricInterpretation(0, "Monochrome3", "MONOCHROME3", Term.Monochrome3);

  static const kRGB = const PhotometricInterpretation(0, "RGB", "RGB", Term.RGB);

  static const kHSV = const PhotometricInterpretation(0, "HSV", "HSV", Term.HSV, true);

  static const kARGB =
      const PhotometricInterpretation(0, "ARGB", "ARGB", Term.ARGB, true);

  static const kCMYK =
      const PhotometricInterpretation(0, "CMYK", "CMYK", Term.CMYK, true);

  static const kYBR_FULL =
      const PhotometricInterpretation(0, "YBR_FULL", "YBR_FULL", Term.YBR_FULL);

  static const kYBR_FULL_422 = const PhotometricInterpretation(
      0, "YBR_FULL_422", "YBR_FULL_422", Term.YBR_FULL_422);

  static const kYBR_PARTIAL_422 = const PhotometricInterpretation(
      0, "YBR_PARTIAL_422", "YBR_PARTIAL_422", Term.YBR_PARTIAL_422);

  static const kYBR_PARTIAL_420 = const PhotometricInterpretation(
      0, "YBR_PARTIAL_420", "YBR_PARTIAL_420", Term.YBR_PARTIAL_420, true);

  static const kYBR_ICT =
      const PhotometricInterpretation(0, "YBR_ICT", "YBR_ICT", Term.YBR_ICT);

  static const kYBR_RCT =
      const PhotometricInterpretation(0, "YBR_RCT", "YBR_RCT", Term.YBR_RCT);

  static const map = const {
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
