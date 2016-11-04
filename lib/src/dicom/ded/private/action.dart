// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: finish adding the actions
/// An enumeration of valid de-identification [Action]s.
class Action {
  /// An identifier for [this].
  final String keyword;

  /// An [abbreviation] for [this].
  final String abbreviation;

  /// A [description] of [this].
  final String description;

  /// Creates a constant definition of an [Action].
  const Action(this.keyword, this.abbreviation, this.description);

  /// [keep] the data element.
  static const keep = const Action('keep', 'K', "Keep this Private Data Element");

  //TODO: find out what 'KB' means
  /// [keep****] the data element.
  static const keepB____ = const Action('keep____', 'KB', "Keep ____ this Private Data Element");

  /// [replace] the data element.
  static const replace =
      const Action('replace', 'R', "Replace the value of this Private Data Element");

  /// [remove] the data element.
  static const remove = const Action('remove', 'X', "Remove this Private Data Element");
}
