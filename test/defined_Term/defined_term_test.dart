// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:common/ascii.dart';
import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/enum/photometric_interpretation.dart';
import 'package:dictionary/src/enum/universal_entity_id_type.dart';
import 'package:dictionary/src/terminology/term.dart';
import 'package:dictionary/src/uid/well_known/color_palette.dart';
import 'package:test/test.dart';

void main() {
  create();
  show();
  show1();
}

//Fix: update this to reflect the new definitions
void create() {
  test('photoem', () {
    PhotometricInterpretation photometricInterpretation1 =
        const PhotometricInterpretation("binayak", const Term("abc", "hjgh"));
    expect(
        photometricInterpretation1,
        equals(const PhotometricInterpretation(
            "binayak", const Term("abc", "hjgh"))));
    expect(PhotometricInterpretation.lookup("gghhg"), equals(null));
    expect(PhotometricInterpretation.lookup("RGB"),
        equals(PhotometricInterpretation.kRGB));
    expect(PhotometricInterpretation.lookup("MONOCHROME1"),
        equals(PhotometricInterpretation.kMonochrome1));
    expect(PhotometricInterpretation.lookup("MONOCHROME2"),
        equals(PhotometricInterpretation.kMonochrome2));
    expect(PhotometricInterpretation.lookup("MONOCHROME3"),
        equals(PhotometricInterpretation.kMonochrome3));
    expect(PhotometricInterpretation.lookup("HSV"),
        equals(PhotometricInterpretation.kHSV));
    expect(PhotometricInterpretation.lookup("ARGB"),
        equals(PhotometricInterpretation.kARGB));
    expect(PhotometricInterpretation.lookup("CMYK"),
        equals(PhotometricInterpretation.kCMYK));
    expect(PhotometricInterpretation.lookup("YBR_FULL"),
        equals(PhotometricInterpretation.kYBR_FULL));
    expect(PhotometricInterpretation.lookup("YBR_FULL_422"),
        equals(PhotometricInterpretation.kYBR_FULL_422));
    expect(PhotometricInterpretation.lookup("YBR_PARTIAL_422"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(PhotometricInterpretation.lookup("YBR_PARTIAL_420"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(PhotometricInterpretation.lookup("YBR_ICT"),
        equals(PhotometricInterpretation.kYBR_ICT));
    expect(PhotometricInterpretation.lookup("YBR_RCT"),
        equals(PhotometricInterpretation.kYBR_RCT));
  });

  test("universal", () {
    var universalEntityType1 =
        const UniversalEntityIDType("binayak", "45", const Term("xya", "abc"));
    expect(
        universalEntityType1,
        equals(const UniversalEntityIDType(
            "binayak", "45", const Term("xya", "abc"))));
    expect(
        UniversalEntityIDType.kDNS,
        equals(const UniversalEntityIDType(
            "DNS", "Domain Name System", Term.kDNS)));
    expect(
        universalEntityType1.lookup("DNS"), equals(UniversalEntityIDType.kDNS));
    expect(universalEntityType1.lookup("EUI64"),
        equals(UniversalEntityIDType.kEUI64));
    expect(
        universalEntityType1.lookup("ISO"), equals(UniversalEntityIDType.kISO));
    expect(
        universalEntityType1.lookup("URI"), equals(UniversalEntityIDType.kURI));
    expect(universalEntityType1.lookup("UUID"),
        equals(UniversalEntityIDType.kUUID));
    expect(universalEntityType1.lookup("X400"),
        equals(UniversalEntityIDType.kX400));
    expect(universalEntityType1.lookup("X500"),
        equals(UniversalEntityIDType.kX500));
  });
}

void show1() {
  test("s", () {
    var modalityclass = const Modality(
        "AR", "Autorefraction", ModalityType.kACQUISITION, false, null);

    expect(
        modalityclass,
        equals(const Modality(
            "AR", "Autorefraction", ModalityType.kACQUISITION, false, null)));
    expect(
        modalityclass,
        isNot(const Modality(
            "AU", "Audio", ModalityType.kACQUISITION, false, null)));
//    expect(ModalityType.lookup("AR"),equals(ModalityType.AR));
//    expect(ModalityType.lookup("AU"),equals(ModalityType.AU));
  });
}

void show() {
  test("d", () {
//   var modalitytypes=const ModalityType(23,"binayak",const MClass(34),true,));
    var modelclass = const ModalityType(0);
    expect(modelclass, equals(const ModalityType(0)));
    expect(modelclass, isNot(const ModalityType(1)));
    expect(modelclass, isNot(ModalityType.kDERIVED));
    expect(modelclass, isNot(ModalityType.kDOCUMENT));
    expect(modelclass, isNot(ModalityType.kMEASUREMENT));
    expect(modelclass, isNot(ModalityType.kPLANNING));
    expect(modelclass, isNot(ModalityType.kPOST_PROCESSING));
    expect(modelclass, isNot(ModalityType.kOTHER));
  });

  test("ascii", () {
    var asciis = const Ascii(
        0, "NUL", "null character", const CharType(0, "null character"));
    expect(
        asciis,
        equals(const Ascii(
            0, "NUL", "null character", const CharType(0, "null character"))));
  });

  test("colors", () {
    var color = const ColorPalette("uid1", "label1", "dart language");
    expect(
        color, equals(const ColorPalette("uid1", "label1", "dart language")));
  });
}
