// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/tag/private/private_creator_definition.dart';
import 'package:dictionary/src/tag/private/private_data_tag.dart';
import 'package:dictionary/src/tag/private/private_tag.dart';
import 'package:dictionary/src/vm.dart';
import 'package:dictionary/src/vr/vr.dart';

const Map<int, PrivateDataTag> emptyDataTags = const <int, PrivateDataTag>{};

class PrivateCreatorTag extends PrivateTag {
  static const VR defaultVR = VR.kLO;
  final KnownPrivateCreators definition;

  //TODO: fix the tag code to be the standard group with 0x0010 as elt.
  PrivateCreatorTag(int code, VR vr, String token)
      : definition = KnownPrivateCreators.lookup(token),
        super(code, VR.kLO, VM.k1, token);

  const PrivateCreatorTag._(int code, VR vr, String token,
      KnownPrivateCreators def)
      : definition = def,
        super(code, VR.kLO, VM.k1, token);
/*
  const PrivateCreatorTag(String token, int code,
      [VR vr = VR.kLO, this.definition = PrivateCreatorDefinition.kUnknown])
      : super(token, code, VR.kLO, VM.k1);
*/
  int get index => definition.index;

  Map<int, PrivateDataTag> get dataTags => definition.dataTags;

  @override
  bool get isCreator => true;

  @override
  bool get isKnown => definition != KnownPrivateCreators.kUnknown;

  @override
  int get subgroup => elt & 0xFF;

  int get base => elt << 8;

  int get limit => base + 0xFF;

  @override
  String get info => '$runtimeType($token) index:$index, '
      'data ${fmtDataTagMap()}';

  /// Returns a[PrivateDataTag]. If this creator has a known [PrivateDataTag]
  /// matching [code] it returns that; otherwise, a new [PrivateDataTag]
  /// is created.
  PrivateDataTag lookupData(int code, VR vr) {
    int pdTagCode = code & 0xFFFF00FF;
    //  print('pdTagCode: ${Tag.toHex(pdTagCode)}');
    PrivateDataTag pdTag = dataTags[pdTagCode];
    //  print('***** PrivateDataTag: $pdTag');
    if (pdTag == null)
      pdTag = new PrivateDataTag.unknown(code, vr, token);
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
  String toString() => 'PCTag($token) $vr $vm';

  static const PrivateCreatorTag kNonExtantCreator =
      const PrivateCreatorTag._(0, VR.kUN, "NonExtantCreator",
          KnownPrivateCreators.kUnknown);
}
