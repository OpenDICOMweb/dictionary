// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

const _PhotometricInterpretationReleatedTerms = const [
  Term.Monochrome1,
  Term.Monochrome2,
  Term.Monochrome3,
  Term.RGB,
  Term.YBR_FULL,
  Term.YBR_FULL_422,
  Term.YBR_PARTIAL_422,
  Term.YBR_PARTIAL_420,
  Term.YBR_ICT,
  Term.YBR_RCT
];

//const _PhotometricInterpretation = const [Term.PhotometricInterpretation];

class RelatedTerms {
  final Term term;
  final List<Term> related;

  const RelatedTerms(this.term, this.related);

  static const PhotometricInterpretation =
      const RelatedTerms(Term.PhotometricInterpretation, const [
    Term.Monochrome1,
    Term.Monochrome2,
    Term.Monochrome3,
    Term.RGB,
    Term.YBR_FULL,
    Term.YBR_FULL_422,
    Term.YBR_PARTIAL_422,
    Term.YBR_PARTIAL_420,
    Term.YBR_ICT,
    Term.YBR_RCT
  ]);
}

class Term {
  final String name;
  final String definition;

  const Term(this.name, this.definition);

  static const YES = const Term("YES", "True or in agreement");
  static const NO = const Term("NO", "False or NOT in agreement");

  static const PhotometricInterpretation = const Term(
      "Photometric Interpretation",
      "The value of Photometric Interpretation (0028,0004) specifies the intended "
      "interpretation of the image pixel data. See PS3.5 for restrictions imposed by "
      "compressed Transfer Syntaxes. The following values are defined. Other values "
      "are permitted but the meaning is "
      "not defined by this Standard.");

  static const Monochrome1 = const Term(
      "MONOCHROME1",
      'Pixel data represent a single monochrome image plane. The minimum '
      'sample value is intended to be displayed as white after any VOI '
      'gray scale transformations have been performed. See PS3.4. '
      'This value may be used only when Samples per Pixel '
      '(0028,0002) has a value of 1.');
  static const Monochrome2 = const Term(
      "MONOCHROME2",
      'Pixel data represent a single monochrome image plane. The minimum '
      'sample value is intended to be displayed as black after any VOI '
      'gray scale transformations have been performed. See PS3.4. This '
      'value may be used only when Samples per Pixel (0028,0002) has a '
      'value of 1.');
  static const Monochrome3 = const Term(
    "MONOCHROME3",
    'Pixel data describe a color image with a single sample per pixel (single '
        'image plane). The pixel value is used as an index into each of the Red, '
        'Blue, and Green Palette Color Lookup Tables (0028,1101-1103&1201-1203). '
        'This value may be used only when Samples per Pixel (0028,0002) has a '
        'value of 1. When the Photometric Interpretation is Palette Color; Red, '
        'Blue, and Green Palette Color Lookup Tables shall be present.',
  );
  static const RGB = const Term(
    "RGB",
    'Pixel data represent a color image described by red, green, and blue '
        'image planes. The minimum sample value for each color plane represents minimum '
        'intensity of the color. This value may be used only when Samples per Pixel '
        '(0028,0002) has a value of 3.',
  );

  static const HSV = const Term("HSV", "Retired.");

  static const ARGB = const Term("ARGB", "Retired.");

  static const CMYK = const Term("CMYK", "Retired.");

  static const YBR_FULL = const Term(
    "YBR_FULL",
    'Pixel data represent a color image described by one luminance (Y) '
        'and two chrominance planes (CB and CR). This photometric interpretation may be used '
        'only when Samples per Pixel (0028,0002) has a value of 3. Black is represented by Y '
        'equal to zero. The absence of color is represented by both CB and CR values equal to '
        'half full scale.'
        '\n    Note: In the case where Bits Allocated (0028,0100) has value of 8 half full scale is '
        '128.'
        '\nIn the case where Bits Allocated (0028,0100) has a value of 8 then the following equations '
        'convert between RGB and YCBCR Photometric Interpretation.'
        '\n  Y = + .2990R + .5870G + .1140B'
        '\n  CB= - .1687R - .3313G + .5000B + 128'
        '\n  CR= + .5000R - .4187G - .0813B + 128'
        '\n    Note: The above is based on CCIR Recommendation 601-2 dated 1990.',
  );

  //TODO: finish
  static const YBR_FULL_422 = const Term(
    "YBR_FULL_422",
    'The same as YBR_FULL except that the CB and CR values are '
        'sampled horizontally at half the Y rate and as a result there are half as '
        'many CB and CR values as Y values...',
  );

  //TODO: finish
  static const YBR_PARTIAL_422 =
      const Term("YBR_PARTIAL_422", 'The same as YBR_FULL_422 except that:...');

  //TODO: finish
  static const YBR_PARTIAL_420 = const Term(
    "YBR_PARTIAL_420",
    'The same as YBR_PARTIAL_422 except that the CB and CR values are sampled '
        'horizontally and vertically at half the Y rate and as a result there '
        'are four times less CB and CR values than Y values, versus twice '
        'less for YBR_PARTIAL_422...',
  );

  //TODO: finish
  static const YBR_ICT = const Term("YBR_ICT", 'Irreversible Color Transformation:...');

  //TODO: finish
  static const YBR_RCT = const Term("YBR_RCT", 'Reversible Color Transformation:...');
}
