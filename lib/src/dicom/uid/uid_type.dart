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
  static const kUnknown = const UidType._(-1, "Unknown");

  // Random 2.25. + V4 Uuid
  static const kRandomUuid = const UidType._(0, "RandomUuid");

  // Constructed from Root + leaf
  static const kConstructed = const UidType._(1, "Constructed");

  // DICOM Well Known Types
  static const kSOPClass = const UidType._(2, "SOP Class");
  static const kTransferSyntax = const UidType._(3, "Transfer Syntax");
  static const kWellKnownFrameOfReference = const UidType._(4, "Frame Of Reference");
  static const kWellKnownSOPInstance = const UidType._(5, "SOP Instance");
  static const kDicomUidCodingScheme = const UidType._(6, "DICOM UIDs as a Coding Scheme");
  static const kMetaSOPClass = const UidType._(7, "Meta SOP Class");
  static const kServiceClass = const UidType._(8, "Service Class");
  static const kCodingScheme = const UidType._(9, "Coding Scheme");
  static const kApplicationContextName = const UidType._(10, "Application Context Name");
  static const kWellKnownPrinterSOPInstance = const UidType._(11, "Printer SOP Instance");
  static const kWellKnownPrintQueueSOPInstance = const UidType._(12, "Print Queue SOP Instance");
  static const kQueryRetrieve = const UidType._(13, "Query Retrieve");
  static const kApplicationHostingModel = const UidType._(14, "Application Hosting Model");
  static const kLdapOid = const UidType._(15, "LDAP OID");
  static const kMappingResource = const UidType._(16, "Mapping Resource");
  static const kColorPalette = const UidType._(17, "Color Palette");
  static const kTransfer = const UidType._(18, "Transfer");
  static const kSynchronizationFrameOfReference =
      const UidType._(19, "Synchronization Frame Of Reference");
}
