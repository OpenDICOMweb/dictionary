// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The DICOM Information Entity Level for Datasets.
class IELevel {
  final int level;
  final String name;
  final IELevel parent;
  final IELevel child;

  const IELevel(this.level, this.name, this.parent, this.child);

  String get info => '$this: parent($parent), child($child)';

  /// The Patient level.
  static const IELevel subject = const IELevel(0, "Subject", null, study);

  /// The Study level.
  static const IELevel study = const IELevel(2, "Study", subject, series);

  /// The Series level.
  static const IELevel series = const IELevel(3, "Series", study, instance);

  /// The Instance level.
  static const IELevel instance = const IELevel(4, "Instance", series, dataset);

  /// The Dataset Level.  Note: this is currently not used
  static const IELevel dataset = const IELevel(5, "Dataset", instance, item);

  /// The Item level.
  static const IELevel item = const IELevel(6, "Item", dataset, null);

  /// The PS3.10 File Meta Information of a topLevel or studies Dataset.
  static const IELevel fileMetaInfo = const IELevel(
      7,
      "File Meta "
      "Information",
      study,
      null);

  String toString() => '$runtimeType($level) $name';
}
