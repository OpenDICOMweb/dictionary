// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/terminology/term.dart';

/// Specifies the intended interpretation of the pixel data.
/// See [PS3.3 Section C.8.2.1.1.3]
/// (http://dicom.nema.org/medical/dicom/current/output/html/part03.html#sect_C.8.2.1.1.3)
/// for details.
class PhotometricInterpretation {
  final String id;
  final Term term;

  const PhotometricInterpretation(this.id, this.term,
      [bool isRetired = false]);

  static PhotometricInterpretation lookup(String id) => map[id];

  Iterable<String> get keys => map.keys;

  static const PhotometricInterpretation kMonochrome1 =
      const PhotometricInterpretation(
          "MONOCHROME1", Term.kMonochrome1);

  static const PhotometricInterpretation kMonochrome2 =
      const PhotometricInterpretation(
           "MONOCHROME2", Term.kMonochrome2);

  static const PhotometricInterpretation kMonochrome3 =
      const PhotometricInterpretation(
           "MONOCHROME3", Term.kMonochrome3);

  static const PhotometricInterpretation kRGB =
      const PhotometricInterpretation( "RGB", Term.kRGB);

  static const PhotometricInterpretation kHSV =
      const PhotometricInterpretation( "HSV", Term.kHSV, true);

  static const PhotometricInterpretation kARGB =
      const PhotometricInterpretation( "ARGB", Term.kARGB, true);

  static const PhotometricInterpretation kCMYK =
      const PhotometricInterpretation( "CMYK", Term.kCMYK, true);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_FULL =
      const PhotometricInterpretation( "YBR_FULL", Term.kYBR_FULL);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_FULL_422 =
      const PhotometricInterpretation(
         "YBR_FULL_422", Term.kYBR_FULL_422);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_PARTIAL_422 =
      const PhotometricInterpretation(
           "YBR_PARTIAL_422", Term.kYBR_PARTIAL_422);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_PARTIAL_420 =
      const PhotometricInterpretation(
          "YBR_PARTIAL_420", Term.kYBR_PARTIAL_420, true);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_ICT =
      const PhotometricInterpretation("YBR_ICT", Term.kYBR_ICT);

  // ignore: constant_identifier_names
  static const PhotometricInterpretation kYBR_RCT =
      const PhotometricInterpretation("YBR_RCT", Term.kYBR_RCT);

  static const Map<String, XPhotometricInterpretation> map = const {
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

  bool contains(String id) => map.keys.contains(id);

  Term meaning(String id) => map[id].term;
}

class XPhotometricInterpretation extends PhotometricInterpretation {
  final PhotometricInterpretation base;
  final List<String> others;
  const XPhotometricInterpretation(this.base, this.others);

}
