// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dicom.dart';
import 'package:dictionary/src/dicom/vr.dart';

import 'wk_uid.dart';
import 'wk_uid_type.dart';

//TODO: finish
class ColorPalette extends WKUid {
  static const WKUidType _type = WKUidType.kColorPalette;
  static const String refLink = 'http://dicom.nema.org/medical/dicom/current/output/html/part06.html#table_B.1-1';
  static const List<VR> vrs = const [VR.kSS, VR.kUS];
  final String description;

  const ColorPalette(String uid, String label, this.description, String link)
      : super(uid, WKUidType.kColorPalette, false, "HOT_IRON", link);

  static const hotIron =
  const ColorPalette("1.2.840.10008.1.​5.​1", "HOT_IRON", "Hot Iron",
                         "ftp://medical.nema.org/Medical/Dicom/Palettes/hotiron.dcm");

  static const pet =
  const ColorPalette("1.2.840.10008.1.​5.​1", "PET", "PET",
                         "ftp://medical.nema.org/Medical/Dicom/Palettes/pet.dcm");

  static const hotMetalBlue =
  const ColorPalette("1.2.840.10008.1.​5.​1", "HOT_METAL_BLUE", "Hot Metal Blue",
                         "ftp://medical.nema.org/Medical/Dicom/Palettes/hotmetalblue.dcm");

  static const pet20Step =
  const ColorPalette("1.2.840.10008.1.​5.​1", "PET_@)_STEP", "PET 20 Step",
                         "ftp://medical.nema.org/Medical/Dicom/Palettes/pet20step.dcm");
}
