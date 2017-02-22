// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/terminology/term.dart';
import 'package:test/test.dart';

import 'package:dictionary/src/uid/well_known/color_palette.dart';

void main() {
  create();
  show();
  show1();
}

void create() {
  test('photoem', () {
    PhotometricInterpretation photometricInterpretation1 =
        const PhotometricInterpretation(
            1, "binayak", "42", const Term("abc", "hjgh"));
    expect(
        photometricInterpretation1,
        equals(const PhotometricInterpretation(
            1, "binayak", "42", const Term("abc", "hjgh"))));
    expect(photometricInterpretation1.lookup("gghhg"), equals(null));
    expect(photometricInterpretation1.lookup("RGB"),
        equals(PhotometricInterpretation.kRGB));
    expect(photometricInterpretation1.lookup("MONOCHROME1"),
        equals(PhotometricInterpretation.kMonochrome1));
    expect(photometricInterpretation1.lookup("MONOCHROME2"),
        equals(PhotometricInterpretation.kMonochrome2));
    expect(photometricInterpretation1.lookup("MONOCHROME3"),
        equals(PhotometricInterpretation.kMonochrome3));
    expect(photometricInterpretation1.lookup("HSV"),
        equals(PhotometricInterpretation.kHSV));
    expect(photometricInterpretation1.lookup("ARGB"),
        equals(PhotometricInterpretation.kARGB));
    expect(photometricInterpretation1.lookup("CMYK"),
        equals(PhotometricInterpretation.kCMYK));
    expect(photometricInterpretation1.lookup("YBR_FULL"),
        equals(PhotometricInterpretation.kYBR_FULL));
    expect(photometricInterpretation1.lookup("YBR_FULL_422"),
        equals(PhotometricInterpretation.kYBR_FULL_422));
    expect(photometricInterpretation1.lookup("YBR_PARTIAL_422"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(photometricInterpretation1.lookup("YBR_PARTIAL_420"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(photometricInterpretation1.lookup("YBR_ICT"),
        equals(PhotometricInterpretation.kYBR_ICT));
    expect(photometricInterpretation1.lookup("YBR_RCT"),
        equals(PhotometricInterpretation.kYBR_RCT));
  });
  test("universal", () {
    var universalEntityType1 = const UniversalEntityIDType(
        2, "binayak", "45", const Term("xya", "abc"));
    expect(
        universalEntityType1,
        equals(const UniversalEntityIDType(
            2, "binayak", "45", const Term("xya", "abc"))));
    expect(
        UniversalEntityIDType.kDNS,
        equals(const UniversalEntityIDType(
            0, "DNS", "Domain Name System", Term.kDNS)));
    expect(universalEntityType1.lookup("DNS"),
        equals(UniversalEntityIDType.kDNS));
    expect(universalEntityType1.lookup("EUI64"),
        equals(UniversalEntityIDType.kEUI64));
    expect(universalEntityType1.lookup("ISO"),
        equals(UniversalEntityIDType.kISO));
    expect(universalEntityType1.lookup("URI"),
        equals(UniversalEntityIDType.kURI));
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
    var modalityclass = const ModalityType(
        "AR", "Autorefraction", MClass.kACQUISITION, false, null);

    expect(
        modalityclass,
        equals(const ModalityType(
            "AR", "Autorefraction", MClass.kACQUISITION, false, null)));
    expect(
        modalityclass,
        isNot(const ModalityType(
            "AU", "Audio", MClass.kACQUISITION, false, null)));
//    expect(ModalityType.lookup("AR"),equals(ModalityType.AR));
//    expect(ModalityType.lookup("AU"),equals(ModalityType.AU));
  });
}

void show() {
  test("d", () {
//   var modalitytypes=const ModalityType(23,"binayak",const MClass(34),true,));
    var modelclass = const MClass(0);
    expect(modelclass, equals(const MClass(0)));
    expect(modelclass, isNot(const MClass(1)));
    expect(modelclass, isNot(MClass.kDERIVED));
    expect(modelclass, isNot(MClass.kDOCUMENT));
    expect(modelclass, isNot(MClass.kMEASUREMENT));
    expect(modelclass, isNot(MClass.kPLANNING));
    expect(modelclass, isNot(MClass.kPOST_PROCESSING));
    expect(modelclass, isNot(MClass.kOTHER));
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
  test("yesorno", () {
    var yesnos = const YesNo(1, "yes", "Yes", const Term("abc", "abc"));
    expect(
        yesnos, equals(const YesNo(1, "yes", "Yes", const Term("abc", "abc"))));
    expect(yesnos.lookup("NO"), equals(YesNo.kNO));
    expect(yesnos.lookup("YES"), equals(YesNo.kYES));
  });
}
