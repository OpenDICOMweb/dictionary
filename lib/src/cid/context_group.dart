// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: get tables from dicom


/// This is a template for how CID Constant Classes should be created
class ContextGroup {
  final String number;
  final String name;
  final CGDesignator designator;
  final String code;
  final String meaning;

  const ContextGroup(this.number, this.name, this.designator, this.code, this.meaning);

  String toString() => "CID" + number;

  static const keyword =
      const ContextGroup("7050",
                             "De-Idenfification Method",
                             CGDesignator.dcm,
                             "1234",
                             "some meaning string");
  // ...

}


class CGDesignator {
  final String type;
  final String name;

  const CGDesignator(this.type, this.name);

  static const dcm = const CGDesignator("DCM", "DICOM");
  static const srt = const CGDesignator("SRT", "SNOMED-RT");
  //TODO: finish


  static const Map<String, CGDesignator> designators = const {
    "DCM": CGDesignator.dcm,
    "SRT": CGDesignator.srt
  };
}


