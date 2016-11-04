// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dictionary/common.dart';
import 'package:dictionary/src/dicom/ded/private/action.dart';
import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr.dart';

/// DICOM Private Data Elements
class PrivateData {
  /// The [PrivateCreator] for this [PrivateData] element.
  final String creator = "name";

  /// The [element] number of [this].
  final int element;

  /// The [VM] of [this].
  final VM vm;

  /// The [VR] of [this].
  final VR vr;

  /// The de-identification [Action] for [this].
  final Action action;

  /// A [description] of [this].
  final String description;

  /// Creates a [PrivateData] element.
  const PrivateData._(this.element, this.vr, this.action,
                      this.description, [this.vm = VM.kUnknown]);

  String get name => Int.toHex(element);
  bool get isPublic => false;
  bool get isPrivate => true;
  bool get isPrivateCreator => false;
  bool get isPrivateData => true;

  /// The dictionary value of the minimum  private data tag
  int get _lowerBound => element << 8;

  /// The dictionary value of the maximum private data tag
  int get _upperBound => _lowerBound + 0xFF;


  /// Returns true if this is a valid [PrivateData] tag.
  /// Note: it does not confirm that it is in the correct group
  bool isValid(int tag) =>
      ((tagElement(tag) >= _lowerBound) && (tagElement(tag) <= _upperBound));

  static const k1002 = const PrivateData._(0x1002, VR.kLO, Action.keep, "This description");
  static const k1004 = const PrivateData._(0x1004, VR.kLO, Action.keep, "This description");
  static const k1006 = const PrivateData._(0x1006, VR.kLO, Action.keep, "This description");
  static const k1008 = const PrivateData._(0x1008, VR.kLO, Action.keep, "This description");

}
