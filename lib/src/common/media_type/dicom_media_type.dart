// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

enum _Support {kDefault, kRequired, kOptional}

class DicomMediaType {
    static const _type = "application";
    /// The media Type.
    final String type = _type;
    /// The media subtype.
    final String subtype;
 //   final TransferSyntax transferSyntax;
    /// The support
    final _Support support;

    const DicomMediaType(this.subtype, this.support);

    String get name => '$type/$subtype';

    String toString() => name;

    bool get isDefault => support == _Support.kDefault;
    bool get isRequired => support == _Support.kRequired;
    bool get isOptional => support == _Support.kOptional;

    static const part10 = const DicomMediaType("dicom", _Support.kDefault);
    static const dicom = part10;
    static const json = const DicomMediaType("json", _Support.kRequired);
    static const xml = const DicomMediaType("dicom+xml", _Support.kOptional);
}