// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/uid/uid.dart';
import 'package:dictionary/src/uid/uid_type.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';

//TODO: document
class TransferSyntaxUid extends WKUid {
  static const UidType uidType = UidType.kTransferSyntax;
  final String mediaType;

  @override
  final bool isEncapsulated;

  final bool mayHaveFragments;

  const TransferSyntaxUid(String uid, keyword, String name, this.mediaType,
      [bool isRetired = false,
      this.isEncapsulated = true,
      this.mayHaveFragments = true])
      : super(uid, keyword, UidType.kTransferSyntax, isRetired, name);

  /// Returns [true] if the [TransferSyntaxUid] exists and has not been retired.
  @override
  bool get isTransferSyntax => true;

  bool get isNativeFormat => !isEncapsulated;

  bool get isImplicitLittleEndian => this == kImplicitVRLittleEndian;

  bool get isBigEndian => this == kExplicitVRBigEndian;

  bool get isValidForDICOMweb => !(isImplicitLittleEndian || isBigEndian);

  /// Returns [true] if the [TransferSyntaxUid] exists, but has been retired.
  bool get isRetiredTransferSyntax => isRetired;

  bool get isValidForRS =>
      (isNotRetired) ||
      (asString != kImplicitVRLittleEndian.asString &&
          asString != kExplicitVRBigEndian.asString);

  /// Returns the TransferSyntax corresponding to the [String] or [Uid].
  static TransferSyntaxUid lookup(dynamic ts) {
    if (ts is TransferSyntaxUid) return ts;
    if (ts is Uid) return map[ts.asString];
    if (ts is String) return map[ts];
    return null;
  }

  @override
  String toString() => 'TransferSyntax($asString): $name';

  //*****   Constant Values   *****

  static const TransferSyntaxUid kImplicitVRLittleEndian = const TransferSyntaxUid(
    "1.2.840.10008.1.2",
    "ImplicitVRLittleEndian",
    "Implicit VR Little Endian: Default Transfer Syntax for DICOM",
    "image/???",
    false,
    false,
  );

  static const TransferSyntaxUid kDefaultForDIMSE = kImplicitVRLittleEndian;

  static const TransferSyntaxUid kExplicitVRLittleEndian = const TransferSyntaxUid(
      "1.2.840.10008.1.2.1",
      "ExplicitVRLittleEndian",
      "Explicit VR Little Endian",
      "image/uncompressed??",
      false,
      false);

  static const TransferSyntaxUid kDefaultForDicomWeb = kExplicitVRLittleEndian;

  static const TransferSyntaxUid kDeflatedExplicitVRLittleEndian =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.1.99",
          "DeflatedExplicitVRLittleEndian",
          "Deflated Explicit VR Little Endian",
          "image/deflate??",
          false,
          false,
          false);

  static const TransferSyntaxUid kExplicitVRBigEndian = const TransferSyntaxUid(
      "1.2.840.10008.1.2.2",
      "ExplicitVRBigEndian",
      "Explicit VR Big Endian (Retired)",
      "image/bigEndian",
      true,
      false,
      false);

  static const TransferSyntaxUid kJPEGBaseline_1 = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.50",
      "JPEGBaseline_1",
      "JPEG Baseline (Process 1) : Default Transfer Syntax for Lossy "
      "JPEG 8 Bit Image Compression",
      "image/jpeg");

  static const TransferSyntaxUid kJPEGLossy8BitDefault = kJPEGBaseline_1;

  static const TransferSyntaxUid kJPEGExtended_2_4 = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.51",
      "JPEGExtended_2_4",
      "JPEG Extended (Process 2 & 4) : Default Transfer Syntax for "
      "Lossy JPEG 12 Bit Image Compression (Process 4 only)",
      "image/jpeg",
      false);

  static const TransferSyntaxUid kJPEGLossy12BitDefault = kJPEGExtended_2_4;

  static const TransferSyntaxUid kJPEGExtended_3_5_Retired = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.52",
      "JPEGExtended_3_5_Retired",
      "JPEG Extended (Process 3 & 5) (Retired)",
      "image/jpeg",
      true);

  static const TransferSyntaxUid
      kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired = const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.53",
          "JPEGSpectralSelectionNon_Hierarchical_6_8_Retired",
          "JPEG Spectral Selection, Non-Hierarchical (Process 6 & 8) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid
      kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired = const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.54",
          "JPEGSpectralSelectionNon_Hierarchical_7_9_Retired",
          "JPEG Spectral Selection, Non-Hierarchical (Process 7 & 9) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid
      kJPEGFullProgressionNon_Hierarchical_10_12_Retired = const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.55",
          "JPEGFullProgressionNon_Hierarchical_10_12_Retired",
          "JPEG Full Progression, Non-Hierarchical (Process 10 & 12) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid
      kJPEGFullProgressionNon_Hierarchical_11_13_Retired = const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.56",
          "JPEGFullProgressionNon_Hierarchical_11_13_Retired",
          "JPEG Full Progression, Non-Hierarchical (Process 11 & 13) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGLosslessNon_Hierarchical_14 =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.57",
          "JPEGLosslessNon_Hierarchical_14",
          "JPEG Lossless, Non-Hierarchical (Process 14)",
          "image/jpeg???");

  static const TransferSyntaxUid kJPEGLosslessNon_Hierarchical_15_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.58",
          "JPEGLosslessNon_Hierarchical_15_Retired",
          "JPEG Lossless, Non-Hierarchical (Process 15) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGExtendedHierarchical_16_18_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.59",
          "JPEGExtendedHierarchical_16_18_Retired",
          "JPEG Extended, Hierarchical (Process 16 & 18) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGExtendedHierarchical_17_19_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.60",
          "JPEGExtendedHierarchical_17_19_Retired",
          "JPEG Extended, Hierarchical (Process 17 & 19) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGSpectralSelectionHierarchical_20_22_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.61",
          "JPEGSpectralSelectionHierarchical_20_22_Retired",
          "JPEG Spectral Selection, Hierarchical (Process 20 & 22) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGSpectralSelectionHierarchical_21_23_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.62",
          "JPEGSpectralSelectionHierarchical_21_23_Retired",
          "JPEG Spectral Selection, Hierarchical (Process 21 & 23) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGFullProgressionHierarchical_24_26_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.63",
          "JPEGFullProgressionHierarchical_24_26_Retired",
          "JPEG Full Progression, Hierarchical (Process 24 & 26) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGFullProgressionHierarchical_25_27_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.64",
          "JPEGFullProgressionHierarchical_25_27_Retired",
          "JPEG Full Progression, Hierarchical (Process 25 & 27) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGLosslessHierarchical_28_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.65",
          "JPEGLosslessHierarchical_28_Retired",
          "JPEG Lossless, Hierarchical (Process 28) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid kJPEGLosslessHierarchical_29_Retired =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.66",
          "JPEGLosslessHierarchical_29_Retired",
          "JPEG Lossless, Hierarchical (Process 29) (Retired)",
          "image/jpeg",
          true);

  static const TransferSyntaxUid
      kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1 =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.70",
          "JPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1",
          "JPEG Lossless, Non-Hierarchical, First-Order Prediction "
          "(Process 14 [Selection Value 1]) : Default Transfer Syntax "
          "for Lossless JPEG Image Compression",
          "image/jpeg");

  static const TransferSyntaxUid kJPEGLosslessDefault =
      kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1;

  static const TransferSyntaxUid kJPEG_LSLosslessImageCompression =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.80",
          "JPEG_LSLosslessImageCompression",
          "JPEG-LS Lossless Image Compression",
          "image/jpeg-ls");
  static const TransferSyntaxUid kJPEG_LSLossyImageCompression =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.81",
          "JPEG_LSLossyImageCompression",
          "JPEG-LS Lossy (Near-Lossless) Image Compression",
          "image/jpeg-ls");

  static const TransferSyntaxUid kJPEG2000ImageCompressionLosslessOnly =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.90",
          "JPEG2000ImageCompressionLosslessOnly",
          "JPEG 2000 Image Compression Lossless Only",
          "image/jp2");

  static const TransferSyntaxUid kJPEG2000ImageCompression = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.91",
      "JPEG2000ImageCompression",
      "JPEG 2000 Image Compression",
      "image/jp2");

  static const TransferSyntaxUid
      kJPEG2000Part2Multi_componentImageCompressionLosslessOnly =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.92",
          "JPEG2000Part2Multi_componentImageCompressionLosslessOnly",
          "JPEG 2000 Part 2 Multi-component Image Compression Lossless Only",
          "image/jp2");

  static const TransferSyntaxUid kJPEG2000Part2Multi_componentImageCompression =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.93",
          "JPEG2000Part2Multi_componentImageCompression",
          "JPEG 2000 Part 2 Multi-component Image Compression",
          "image/jp2");

  static const TransferSyntaxUid kJPIPReferenced = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.94",
      "JPIPReferenced",
      "JPIP Referenced",
      "image/jpip???");

  static const TransferSyntaxUid kJPIPReferencedDeflate = const TransferSyntaxUid(
      "1.2.840.10008.1.2.4.95",
      "JPIPReferencedDeflate",
      "JPIP Referenced Deflate",
      "image/jpip???");

  static const TransferSyntaxUid kMPEG2MainProfile_MainLevel =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.100",
          "MPEG2MainProfile_MainLevel",
          "MPEG2 Main Profile @ Main Level",
          "image/mpeg");

  static const TransferSyntaxUid kMPEG2MainProfile_HighLevel =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.101",
          "MPEG2MainProfile_HighLevel",
          "MPEG2 Main Profile @ High Level",
          "image/mpeg???");

  static const TransferSyntaxUid kMPEG_4AVC_H264HighProfile_Level41 =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.102",
          "MPEG_4AVC_H264HighProfile_Level41",
          "MPEG-4 AVC/H.264 High Profile / Level 4.1",
          "image/mpeg4",
          false);

  static const TransferSyntaxUid kMPEG_4AVC_H264BD_compatibleHighProfile_Level41 =
      const TransferSyntaxUid(
          "1.2.840.10008.1.2.4.103",
          "MPEG_4AVC_H264BD_compatibleHighProfile_Level41",
          "MPEG-4 AVC/H.264 BD-compatible High Profile / Level 4.1",
          "image/mpeg4???",
          false);

  static const TransferSyntaxUid kRLELossless = const TransferSyntaxUid(
      "1.2.840.10008.1.2.5",
      "RLELossless",
      "RLE Lossless",
      "image/rle???",
      false);

  static const TransferSyntaxUid kRFC2557MIMEncapsulation = const TransferSyntaxUid(
      "1.2.840.10008.1.2.6.1",
      "RFC2557MIMEncapsulation",
      "RFC 2557 MIME encapsulation",
      "image/????",
      false);

  static const TransferSyntaxUid kXMLEncoding = const TransferSyntaxUid(
      "1.2.840.10008.1.2.6.2",
      "XMLEncoding",
      "XML Encoding",
      "text/xml???",
      false);

  static const Map<String, Uid> map = const {
    "1.2.840.10008.1.2": kImplicitVRLittleEndian,
    "1.2.840.10008.1.2.1": kExplicitVRLittleEndian,
    "1.2.840.10008.1.2.1.99": kDeflatedExplicitVRLittleEndian,
    "1.2.840.10008.1.2.2": kExplicitVRBigEndian,
    "1.2.840.10008.1.2.4.50": kJPEGBaseline_1,
    "1.2.840.10008.1.2.4.51": kJPEGExtended_2_4,
    "1.2.840.10008.1.2.4.52": kJPEGExtended_3_5_Retired,
    "1.2.840.10008.1.2.4.53":
        kJPEGSpectralSelectionNon_Hierarchical_6_8_Retired,
    "1.2.840.10008.1.2.4.54":
        kJPEGSpectralSelectionNon_Hierarchical_7_9_Retired,
    "1.2.840.10008.1.2.4.55":
        kJPEGFullProgressionNon_Hierarchical_10_12_Retired,
    "1.2.840.10008.1.2.4.56":
        kJPEGFullProgressionNon_Hierarchical_11_13_Retired,
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
        kJPEGLosslessNon_HierarchicalFirst_OrderPrediction_14_1,
    "1.2.840.10008.1.2.4.80": kJPEG_LSLosslessImageCompression,
    "1.2.840.10008.1.2.4.81": kJPEG_LSLossyImageCompression,
    "1.2.840.10008.1.2.4.90": kJPEG2000ImageCompressionLosslessOnly,
    "1.2.840.10008.1.2.4.91": kJPEG2000ImageCompression,
    "1.2.840.10008.1.2.4.92":
        kJPEG2000Part2Multi_componentImageCompressionLosslessOnly,
    "1.2.840.10008.1.2.4.93": kJPEG2000Part2Multi_componentImageCompression,
    "1.2.840.10008.1.2.4.94": kJPIPReferenced,
    "1.2.840.10008.1.2.4.95": kJPIPReferencedDeflate,
    "1.2.840.10008.1.2.4.100": kMPEG2MainProfile_MainLevel,
    "1.2.840.10008.1.2.4.101": kMPEG2MainProfile_HighLevel,
    "1.2.840.10008.1.2.4.102": kMPEG_4AVC_H264HighProfile_Level41,
    "1.2.840.10008.1.2.4.103": kMPEG_4AVC_H264BD_compatibleHighProfile_Level41,
    "1.2.840.10008.1.2.5": kRLELossless,
    "1.2.840.10008.1.2.6.1": kRFC2557MIMEncapsulation,
    "1.2.840.10008.1.2.6.2": kXMLEncoding
  };
}
