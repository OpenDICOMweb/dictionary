// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/private_creator_map.dart';
import 'package:dictionary/src/tag/private/private_creator_definition.dart';
import 'package:dictionary/src/tag/private/private_data_tag.dart';
import 'package:dictionary/src/tag/private/private_tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

const Map<int, PrivateDataTag> emptyDataTags = const <int, PrivateDataTag>{};

class PrivateCreatorTag extends PrivateTag {
  static const VR defaultVR = VR.kLO;
  final PrivateCreatorDefinition creator;

  //TODO: fix the tag code to be the standard group with 0x0010 as elt.
  PrivateCreatorTag(String token, int code, [VR vr = VR.kLO])
      : creator = PrivateCreatorDefinition.lookup(token),
        super.creator(token, code, VR.kLO, VM.k1);

  int get index => creator.index;

  Map<int, PrivateDataTag> get dataTags => creator.dataTags;

  @override
  bool get isCreator => true;

  @override
  bool get isKnown => creator != PrivateCreatorDefinition.kUnknown;

  @override
  int get subgroup => elt & 0xFF;

  int get base => elt << 8;

  int get limit => base + 0xFF;

  @override
  String get info => '$runtimeType($creatorToken) index:$index, '
      'data ${fmtDataTagMap()}';

  /// Returns a[PrivateDataTag]. If this creator has a known [PrivateDataTag]
  /// matching [code] it returns that; otherwise, a new [PrivateDataTag]
  /// is created.
  PrivateDataTag lookupData(int code) {
    int pdTagCode = code & 0xFFFF00FF;
    //  print('pdTagCode: ${Tag.toHex(pdTagCode)}');
    PrivateDataTag pdTag = dataTags[pdTagCode];
    //  print('***** PrivateDataTag: $pdTag');
    if (pdTag == null) pdTag = new PrivateDataTag(code);
    return pdTag;
  }

  //TODO: improve formatting
  String fmtDataTagMap() {
    String out = "  {\n";
    dataTags.forEach((int code, PrivateDataTag pdTag) {
      out += '    (${pdTag.hex}): "${pdTag.name}" '
          '${pdTag.vr} ${pdTag.vm},\n';
    });
    return out += '  }';
  }

  bool isValidDataCode(int code) =>
      (group == code >> 16) &&
      (base <= code & 0xFFFF && code & 0xFFFF <= limit);

  @override
  String toString() => 'PCTag($creatorToken) $vr $vm';

  static PrivateCreatorDefinition lookup(String token) =>
      privateCreatorMap[token];

  // Flush ???
 // static const PrivateCreatorTag kUnknown =
 //     const PrivateCreatorTag(-1, "Unknown", VR.kLO, VM.k1);
}
