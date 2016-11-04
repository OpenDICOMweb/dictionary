// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/ded/private/action.dart';
import 'package:dictionary/src/dicom/ded/private/private_data.dart';
import 'package:dictionary/src/dicom/modality.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

class PrivateGroup {
  /// The [VR] of [this], which is always [VR.kLO].
  final VR vr = VR.kLO;

  /// The [VM] for this element, which is always [VM.k1].
  final VM vm = VM.k1;

  /// The de-identification action for this [PrivateCreator], which is always [keep].
  final Action action = Action.keep;

  /// The [PrivateCreator] identifier.
  final String creatorID;

  /// The manufacturer that defined this private group.
  ///
  /// This field corresponds to the [kManufacturer] tag. it has a [VR] of [VR.kLO]. Its [VM] is
  /// [VM.k1]. Its Max length is 64.
  final String manufacturer;

  /// The [Modality] that uses this group.
  ///
  /// This field corresponds to the [kModality] tag. it has a [VR] of [VR.kCS]. Its [VM] is
  /// [VM.k1]. Its Max length is 16.
  final Modality modality;

  /// The [description] of this [PrivateCreator].
  final String description;

  /// The *default* [Group] number used by this group, if available.
  final int group;

  /// The default creator [element] number of [this], which is usually 0x0010.
  final int element;

  /// Create a Private Group
  const PrivateGroup._(this.creatorID, this.manufacturer, this.modality, this.description,
                       [this.group = 0x0009, this.element = 0x0010]);

  bool get isPublic => false;
  bool get isPrivate => true;
  bool get isPrivateCreator => true;
  bool get isPrivateData => false;


/*
  /// [True] if [v] is a valid private data element for this creator.
  bool inPrivateGroup(Private) => _hasSameGroup(tag) && isPrivateData(tag);

  bool _hasSameGroup(int v) => tagGroup(v) == group;

  /// Returns [true] if [data] is in [creators] private tag group.
  static bool contains (int tag) {
    int element = tagElement(tag);
    for (int i = 0; i < data.length; i++) {
      if
      if (!creators[i].isPrivateData(data)) return false;
    }
    return true;
  }
*/
  static const kName = const PrivateGroup._("name", "dummy", Modality.CT, "dummy",);

/// The [PrivateData] definitions for [this].
  static const Map<int, PrivateData> _privateData = const {
    0x1002: PrivateData.k1002,
    0x1004: PrivateData.k1004,
    0x1006: PrivateData.k1006,
    0x1008: PrivateData.k1008
  };

  static PrivateData lookup(int element) => _privateData[element];

}
