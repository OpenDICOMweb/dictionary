// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The DICOM Information Entity Level for Datasets.
class IELevel {
  final int level;
  final String name;

  const IELevel(this.level, this.name);

  /// The Patient level.
  static const IELevel patient = const IELevel(0, "Patient");

  /// The Patient level.
  static const IELevel subject = const IELevel(0, "Subject");

  /// The Studies level.
  static const IELevel studies = const IELevel(1, "Studies");

  /// The Study level.
  static const IELevel study = const IELevel(2, "Study");

  /// The Series level.
  static const IELevel series = const IELevel(3, "Series");

  /// The Instance level.
  static const IELevel instance = const IELevel(4, "Instance");

  /// The Dataset Level.  Note: this is currently not used
  static const IELevel dataset = const IELevel(5, "Dataset");

  /// The Item level.
  static const IELevel item = const IELevel(6, "Item");

  /// The PS3.10 File Meta Information of a topLevel or studies Dataset.
  static const IELevel fileMetaInfo = const IELevel(7, "File Meta Information");

  bool get isPatient => name == "Patient";

  bool get isSubject => name == "Subject";

  bool get isStudy => name == "Study";

  bool get isSeries => name == "Series";

  bool get isInstance => name == "Instance";

  bool get isDataset => name == "Dataset";
}
