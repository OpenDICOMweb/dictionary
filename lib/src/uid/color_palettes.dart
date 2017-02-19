// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

//TODO: finish
class ColorPalette extends WKUid {
  static const UidType uidType = UidType.kColorPalette;
  static const String refLink =
      'http://dicom.nema.org/medical/dicom/current/output/html/part06.html#table_B.1-1';
  static const List<VR> vrs = const [VR.kSS, VR.kUS];
  final String description;

  const ColorPalette(String uid, String label, this.description)
      : super._(uid, UidType.kColorPalette, false, "HOT_IRON");

  static const ColorPalette kHotIron =
      const ColorPalette("1.2.840.10008.1.​5.​1", "HOT_IRON", "Hot Iron");

  static const ColorPalette kPet =
      const ColorPalette("1.2.840.10008.1.​5.​1", "PET", "PET");

  static const ColorPalette kHotMetalBlue = const ColorPalette(
      "1.2.840.10008.1.​5.​1", "HOT_METAL_BLUE", "Hot Metal Blue");

  static const ColorPalette kPet20Step =
      const ColorPalette("1.2.840.10008.1.​5.​1", "PET_@)_STEP", "PET 20 Step");
}
