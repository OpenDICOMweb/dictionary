// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: this class might disappear when all the types are implemented as classes.
/// Uid Types
class UidType {
  final int index;
  final String name;

  const UidType._(this.index, this.name);

  String get keyword => 'k${name.replaceAll(" ", "")}';

  @override
  String toString() => name;

  // This happens when it is passed in and not "well known"
  static const UidType kUnknown = const UidType._(-1, "Unknown");

  // Random 2.25. + V4 Uuid
  static const UidType kUidRandom = const UidType._(0, "RandomUuid");

  // Constructed from Root + leaf
  static const UidType kConstructed = const UidType._(1, "Constructed");

  // DICOM Well Known Types
  static const UidType kSOPClass = const UidType._(2, "SOP Class");
  static const UidType kTransferSyntax = const UidType._(3, "Transfer Syntax");
  static const UidType kWellKnownFrameOfReference =
      const UidType._(4, "Frame Of Reference");
  static const UidType kWellKnownSOPInstance =
      const UidType._(5, "SOP Instance");
  static const UidType kDicomUidCodingScheme =
      const UidType._(6, "DICOM UIDs as a Coding Scheme");
  static const UidType kMetaSOPClass = const UidType._(7, "Meta SOP Class");
  static const UidType kServiceClass = const UidType._(8, "Service Class");
  static const UidType kCodingScheme = const UidType._(9, "Coding Scheme");
  static const UidType kApplicationContextName =
      const UidType._(10, "Application Context Name");
  static const UidType kWellKnownPrinterSOPInstance =
      const UidType._(11, "Printer SOP Instance");
  static const UidType kWellKnownPrintQueueSOPInstance =
      const UidType._(12, "Print Queue SOP Instance");
  static const UidType kQueryRetrieve = const UidType._(13, "Query Retrieve");
  static const UidType kApplicationHostingModel =
      const UidType._(14, "Application Hosting Model");
  static const UidType kLdapOid = const UidType._(15, "LDAP OID");
  static const UidType kMappingResource =
      const UidType._(16, "Mapping Resource");
  static const UidType kColorPalette = const UidType._(17, "Color Palette");
  static const UidType kTransfer = const UidType._(18, "Transfer");
  static const UidType kSynchronizationFrameOfReference =
      const UidType._(19, "Synchronization Frame Of Reference");
}
