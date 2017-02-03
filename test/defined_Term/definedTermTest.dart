import 'package:dictionary/dictionary.dart';
import 'package:test/test.dart';
import 'package:dictionary/src/terminology/term.dart';

void main() {
  create();
  show();
  show1();
}

void create() {
  test('photoem', () {
    var PhotometricInterpretation1 = const PhotometricInterpretation(
        1, "binayak", "42", const Term("abc", "hjgh"));
    expect(
        PhotometricInterpretation1,
        equals(const PhotometricInterpretation(
            1, "binayak", "42", const Term("abc", "hjgh"))));
    expect(PhotometricInterpretation1.lookup("gghhg"), equals(null));
    expect(PhotometricInterpretation1.lookup("RGB"),
        equals(PhotometricInterpretation.kRGB));
    expect(PhotometricInterpretation1.lookup("MONOCHROME1"),
        equals(PhotometricInterpretation.kMonochrome1));
    expect(PhotometricInterpretation1.lookup("MONOCHROME2"),
        equals(PhotometricInterpretation.kMonochrome2));
    expect(PhotometricInterpretation1.lookup("MONOCHROME3"),
        equals(PhotometricInterpretation.kMonochrome3));
    expect(PhotometricInterpretation1.lookup("HSV"),
        equals(PhotometricInterpretation.kHSV));
    expect(PhotometricInterpretation1.lookup("ARGB"),
        equals(PhotometricInterpretation.kARGB));
    expect(PhotometricInterpretation1.lookup("CMYK"),
        equals(PhotometricInterpretation.kCMYK));
    expect(PhotometricInterpretation1.lookup("YBR_FULL"),
        equals(PhotometricInterpretation.kYBR_FULL));
    expect(PhotometricInterpretation1.lookup("YBR_FULL_422"),
        equals(PhotometricInterpretation.kYBR_FULL_422));
    expect(PhotometricInterpretation1.lookup("YBR_PARTIAL_422"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(PhotometricInterpretation1.lookup("YBR_PARTIAL_420"),
        equals(PhotometricInterpretation.kYBR_PARTIAL_420));
    expect(PhotometricInterpretation1.lookup("YBR_ICT"),
        equals(PhotometricInterpretation.kYBR_ICT));
    expect(PhotometricInterpretation1.lookup("YBR_RCT"),
        equals(PhotometricInterpretation.kYBR_RCT));
  });
  test("universal", () {
    var universal_entitytype1 = const UniversalEntityIDType(
        2, "binayak", "45", const Term("xya", "abc"));
    expect(
        universal_entitytype1,
        equals(const UniversalEntityIDType(
            2, "binayak", "45", const Term("xya", "abc"))));
    expect(
        UniversalEntityIDType.DNS,
        equals(const UniversalEntityIDType(
            0, "DNS", "Domain Name System", Term.DNS)));
    expect(
        universal_entitytype1.lookup("DNS"), equals(UniversalEntityIDType.DNS));
    expect(universal_entitytype1.lookup("EUI64"),
        equals(UniversalEntityIDType.EUI64));
    expect(
        universal_entitytype1.lookup("ISO"), equals(UniversalEntityIDType.ISO));
    expect(
        universal_entitytype1.lookup("URI"), equals(UniversalEntityIDType.URI));
    expect(universal_entitytype1.lookup("UUID"),
        equals(UniversalEntityIDType.UUID));
    expect(universal_entitytype1.lookup("X400"),
        equals(UniversalEntityIDType.X400));
    expect(universal_entitytype1.lookup("X500"),
        equals(UniversalEntityIDType.X500));
  });
}

void show1() {
  test("s", () {
    var modalityclass = const ModalityType(
        "AR", "Autorefraction", MClass.ACQUISITION, false, null);

    expect(
        modalityclass,
        equals(const ModalityType(
            "AR", "Autorefraction", MClass.ACQUISITION, false, null)));
    expect(
        modalityclass,
        isNot(const ModalityType(
            "AU", "Audio", MClass.ACQUISITION, false, null)));
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
    expect(modelclass, isNot(MClass.DERIVED));
    expect(modelclass, isNot(MClass.DOCUMENT));
    expect(modelclass, isNot(MClass.MEASUREMENT));
    expect(modelclass, isNot(MClass.PLANNING));
    expect(modelclass, isNot(MClass.POST_PROCESSING));
    expect(modelclass, isNot(MClass.OTHER));
  });
  test("ascii", () {
    var asciis = const Ascii(
        0, "NUL", "null character", const AsciiType(0, "null character"));
    expect(
        asciis,
        equals(const Ascii(
            0, "NUL", "null character", const AsciiType(0, "null character"))));
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

