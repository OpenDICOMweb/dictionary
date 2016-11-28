// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.


enum _Support {kDefault, kRequired, kOptional}

class RenderedMediaType {
  /// The media Type.
  final String type;
  /// The media subtype.
  final String subtype;
  /// The support
  final _Support support;
  /// Are multi-frame images supported?
  final bool isMultiFrame;

  const RenderedMediaType(this.type, this.subtype, 
                          [this.support, this.isMultiFrame = false]);

  String get name => '$type/$subtype';

  String toString() => name;

  bool get isDefault => support == _Support.kDefault;
  bool get isRequired => support == _Support.kRequired;
  bool get isOptional => support == _Support.kOptional;
  
  bool get isImage => type == "image";
  bool get isVideo => type == "video";
  bool get isText => type == "text" || this == pdf;
  
  RenderedMediaType get imageDefault => jpeg;
  RenderedMediaType get videoDefault => null;
  RenderedMediaType get textDefault => html;
  
  static const jpeg = const RenderedMediaType("image", "jpeg", _Support.kDefault, false);
  static const gif = const RenderedMediaType("image", "gif", _Support.kRequired, true);
  static const png = const RenderedMediaType("image", "png", _Support.kRequired, false);
  static const jp2 = const RenderedMediaType("image", "jp2", _Support.kDefault, false);

  static const mpeg = const RenderedMediaType("video", "mpeg", _Support.kOptional, true);
  static const mp4 = const RenderedMediaType("video", "mp4", _Support.kOptional, true);
  static const H256 = const RenderedMediaType("video", "H256", _Support.kOptional, true);


  static const html = const RenderedMediaType("text", "html", _Support.kDefault, false);
  static const plain = const RenderedMediaType("text", "plain", _Support.kRequired, false);
  static const xml = const RenderedMediaType("text", "xml", _Support.kOptional, false);
  static const rtf = const RenderedMediaType("text", "plain", _Support.kOptional, false);
  static const pdf = const RenderedMediaType("application", "pdf", _Support.kOptional, false);

}