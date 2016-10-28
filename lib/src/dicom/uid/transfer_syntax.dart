// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.



import 'package:dictionary/src/common/uid/uid.dart';

import 'wk_uid.dart';
import 'wk_uid_type.dart';

class TransferSyntax extends WKUid {
  static const WKUidType _type = WKUidType.kSopClass;
  static const String classLink = 'TODO link';
  final String mediaType;
  final bool isEncapsulated;

  const TransferSyntax(String uid, String name, this.mediaType,
      [this.isEncapsulated = true, String link = "PS3.5", bool isRetired = false])
      : super(uid, _type, isRetired, name, link);

  WKUidType get type => _type;

  /// Returns [true] if the [TransferSyntax] exists and has not been retired.
  bool get isTransferSyntax => true;

  /// Returns [true] if the [TransferSyntax] exists, but has been retired.
  bool get isRetiredTransferSyntax => isRetired;

  bool get isValidForRS =>
      (isNotRetired) ||
      (name != kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM &&
          name != kExplicitVRBigEndian_Retired);

  /// Returns the TransferSyntax corresponding to the [String] or [Uid].
  static lookup(ts) {
    if (ts is TransferSyntax) return ts;
    if (ts is Uid) ts = map[ts.value];
    if (ts is String) return map[ts];
    return null;
  }

  @override
  String toString() => 'TransferSyntax($value): $name';

  //TODO we need add the keyword to the to the class.
  //*****   Constant Values   *****

  static const kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM = const TransferSyntax(
      "1.2.840.10008.1.2",
      "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
      "image/???",
      false);

  static const kExplicitVRLittleEndian = const TransferSyntax(
      "1.2.840.10008.1.2.1", "Explicit VR Little Endian", "image/uncompressed??", false);

  static const kDeflatedExplicitVRLittleEndian = const TransferSyntax(
      "1.2.840.10008.1.2.1.99", "Deflated Explicit VR Little Endian", "image/deflate??", false);

  static const kExplicitVRBigEndian_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.2", "Explicit VR Big Endian (Retired)", "image/???", false, "PS3.5", true);

  static const kJPEGBaseline_1DefaultTransferSyntaxforLossyJPEG8BitImageCompression =
      const TransferSyntax(
          "1.2.840.10008.1.2.4.50",
          "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy JPEG 8 Bit Image Compression",
          "image/jpeg");

  static const kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4 =
      const TransferSyntax(
          "1.2.840.10008.1.2.4.51",
          "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for Lossy JPEG 12 Bit Image Compression (Process 4 only)",
          "image/jpeg",
          false,
          "PS3.5");

  static const kJPEGExtended_3_5_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.52", "JPEG Extended (Process 3 & 5) (Retired)", "image/jpeg", true);

  static const kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.53",
      "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.54",
      "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGFullProgressionNon_Hierarchical_10_12_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.55",
      "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGFullProgressionNon_Hierarchical_11_13_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.56",
      "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGLosslessNon_Hierarchical_14 = const TransferSyntax(
      "1.2.840.10008.1.2.4.57", "JPEG Lossless, Non-Hierarchical (Process 14)", "image/jpeg???");

  static const kJPEGLosslessNon_Hierarchical_15_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.58",
      "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGExtendedHierarchical_16_18_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.59",
      "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGExtendedHierarchical_17_19_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.60",
      "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGSpectralSelectionHierarchical_20_22_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.61",
      "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGSpectralSelectionHierarchical_21_23_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.62",
      "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGFullProgressionHierarchical_24_26_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.63",
      "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGFullProgressionHierarchical_25_27_Retired = const TransferSyntax(
      "1.2.840.10008.1.2.4.64",
      "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
      "image/jpeg",
      true);

  static const kJPEGLosslessHierarchical_28_Retired = const TransferSyntax("1.2.840.10008.1.2.4.65",
      "JPEG Lossless, Hierarchical (Process 28) (Retired)", "image/jpeg", true);

  static const kJPEGLosslessHierarchical_29_Retired = const TransferSyntax("1.2.840.10008.1.2.4.66",
      "JPEG Lossless, Hierarchical (Process 29) (Retired)", "image/jpeg", true);

  static const kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression =
      const TransferSyntax(
          "1.2.840.10008.1.2.4.70",
          "JPEG Lossless, Non-Hierarchical, First-Order Prediction (Process 14 [Selection Value 1]) : Default Transfer Syntax for Lossless JPEG Image Compression",
          "image/jpeg");

  static const kJPEG_LSLosslessImageCompression = const TransferSyntax(
      "1.2.840.10008.1.2.4.80", "JPEG-LS Lossless Image Compression", "image/jpeg-ls");
  static const kJPEG_LSLossyImageCompression = const TransferSyntax(
      "1.2.840.10008.1.2.4.81", "JPEG-LS Lossy (Near-Lossless) Image Compression", "image/jpeg-ls");

  static const kJPEG2000ImageCompressionLosslessOnly = const TransferSyntax(
      "1.2.840.10008.1.2.4.90", "JPEG 2000 Image Compression Lossless Only", "image/jp2");

  static const kJPEG2000ImageCompression =
      const TransferSyntax("1.2.840.10008.1.2.4.91", "JPEG 2000 Image Compression", "image/jp2");

  static const kJPEG2000Part2Multi_componentImageCompressionLosslessOnly = const TransferSyntax(
      "1.2.840.10008.1.2.4.92",
      "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
      "image/jp2");

  static const kJPEG2000Part2Multi_componentImageCompression = const TransferSyntax(
      "1.2.840.10008.1.2.4.93", "JPEG 2000 Part 2 Multi-component Image Compression", "image/jp2");

  static const kJPIPReferenced =
      const TransferSyntax("1.2.840.10008.1.2.4.94", "JPIP Referenced", "image/jpip???");

  static const kJPIPReferencedDeflate =
      const TransferSyntax("1.2.840.10008.1.2.4.95", "JPIP Referenced Deflate", "image/jpip???");

  static const kMPEG2MainProfile_MainLevel = const TransferSyntax(
      "1.2.840.10008.1.2.4.100", "MPEG2 Main Profile @ Main Level", "image/mpeg");

  static const kMPEG2MainProfile_HighLevel = const TransferSyntax(
      "1.2.840.10008.1.2.4.101", "MPEG2 Main Profile @ High Level", "image/mpeg???");

  static const kMPEG_4AVC_H264HighProfile_Level41 = const TransferSyntax(
      "1.2.840.10008.1.2.4.102", "MPEG-4 AVC/H.264 High Profile / Level 4.1", "image/mpeg4", false);

  static const kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 = const TransferSyntax(
      "1.2.840.10008.1.2.4.103",
      "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
      "image/mpeg4???",
      false);

  static const kRLELossless =
      const TransferSyntax("1.2.840.10008.1.2.5", "RLE Lossless", "image/rle???", false);

  static const kRFC2557MIMEencapsulation = const TransferSyntax(
      "1.2.840.10008.1.2.6.1", "RFC 2557 MIME encapsulation", "image/????", false, "PS3.10");

  static const kXMLEncoding =
      const TransferSyntax("1.2.840.10008.1.2.6.2", "XML Encoding", "text/xml???", false, "PS3.10");

  static const Map<String, Uid> map = const {
    "1.2.840.10008.1.2": kImplicitVRLittleEndianDefaultTransferSyntaxforDICOM,
    "1.2.840.10008.1.2.1": kExplicitVRLittleEndian,
    "1.2.840.10008.1.2.1.99": kDeflatedExplicitVRLittleEndian,
    "1.2.840.10008.1.2.2": kExplicitVRBigEndian_Retired,
    "1.2.840.10008.1.2.4.50": kJPEGBaseline_1DefaultTransferSyntaxforLossyJPEG8BitImageCompression,
    "1.2.840.10008.1.2.4.51":
        kJPEGExtended_2_4DefaultTransferSyntaxforLossyJPEG12BitImageCompression_4,
    "1.2.840.10008.1.2.4.52": kJPEGExtended_3_5_Retired,
    "1.2.840.10008.1.2.4.53": kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired,
    "1.2.840.10008.1.2.4.54": kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired,
    "1.2.840.10008.1.2.4.55": kJPEGFullProgressionNon_Hierarchical_10_12_Retired,
    "1.2.840.10008.1.2.4.56": kJPEGFullProgressionNon_Hierarchical_11_13_Retired,
    "1.2.840.10008.1.2.4.57": kJPEGLosslessNon_Hierarchical_14,
    "1.2.840.10008.1.2.4.58": kJPEGLosslessNon_Hierarchical_15_Retired,
    "1.2.840.10008.1.2.4.59": kJPEGExtendedHierarchical_16_18_Retired,
    "1.2.840.10008.1.2.4.60": kJPEGExtendedHierarchical_17_19_Retired,
    "1.2.840.10008.1.2.4.61": kJPEGSpectralSelectionHierarchical_20_22_Retired,
    "1.2.840.10008.1.2.4.62": kJPEGSpectralSelectionHierarchical_21_23_Retired,
    "1.2.840.10008.1.2.4.63": kJPEGFullProgressionHierarchical_24_26_Retired,
    "1.2.840.10008.1.2.4.64": kJPEGFullProgressionHierarchical_25_27_Retired,
    "1.2.840.10008.1.2.4.65": kJPEGLosslessHierarchical_28_Retired,
    "1.2.840.10008.1.2.4.66": kJPEGLosslessHierarchical_29_Retired,
    "1.2.840.10008.1.2.4.70":
        kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1DefaultTransferSyntaxforLosslessJPEGImageCompression,
    "1.2.840.10008.1.2.4.80": kJPEG_LSLosslessImageCompression,
    "1.2.840.10008.1.2.4.81": kJPEG_LSLossyImageCompression,
    "1.2.840.10008.1.2.4.90": kJPEG2000ImageCompressionLosslessOnly,
    "1.2.840.10008.1.2.4.91": kJPEG2000ImageCompression,
    "1.2.840.10008.1.2.4.92": kJPEG2000Part2Multi_componentImageCompressionLosslessOnly,
    "1.2.840.10008.1.2.4.93": kJPEG2000Part2Multi_componentImageCompression,
    "1.2.840.10008.1.2.4.94": kJPIPReferenced,
    "1.2.840.10008.1.2.4.95": kJPIPReferencedDeflate,
    "1.2.840.10008.1.2.4.100": kMPEG2MainProfile_MainLevel,
    "1.2.840.10008.1.2.4.101": kMPEG2MainProfile_HighLevel,
    "1.2.840.10008.1.2.4.102": kMPEG_4AVC_H264HighProfile_Level41,
    "1.2.840.10008.1.2.4.103": kMPEG_4AVC_H264BD_compatibleHighProfile_Level41,
    "1.2.840.10008.1.2.5": kRLELossless,
    "1.2.840.10008.1.2.6.1": kRFC2557MIMEencapsulation,
    "1.2.840.10008.1.2.6.2": kXMLEncoding
  };
}
