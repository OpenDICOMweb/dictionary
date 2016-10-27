// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


/// The common of UIDs
class UidType {
  final int index;
  final String name;

  const UidType(this.index, this.name);

  String get keyword => name.replaceAll(" ", "");

  String toString() => name;

  // This happens when it is passed in and not "well known"
  static const kUnknown = const UidType(-1, "Unknown");

  // Random 2.25. + V4 Uuid
  static const kGenerated = const UidType(0, "Generated");

  // Constructed from Root + leaf
  static const kConstructed = const UidType(1, "Constructed");

  // Well Known Types
  static const kSopClass                = const UidType(2, "SOP Class");
  static const kTransferSyntax          = const UidType(3, "Transfer Syntax");
  static const kFrameOfReference        = const UidType(4, "Frame Of Reference");
  static const kSopInstance             = const UidType(5, "SOP Instance");
  static const kDicomCodingScheme       = const UidType(6, "Dicom Coding Scheme");
  static const kMetaSopClass            = const UidType(7, "Meta SOP Class");
  static const kServiceClass            = const UidType(8, "Service Class");
  static const kCodingScheme            = const UidType(9, "Coding Scheme");
  static const kApplicationContextName  = const UidType(10, "Application Context Name");
  static const kPrinterSopInstance      = const UidType(11, "Printer SOP Instance");
  static const kPrintQueueSopInstance   = const UidType(12, "Print Queue SOP Instance");
  static const kQueryRetrieve           = const UidType(13, "Query Retrieve");
  static const kApplicationHostingModel = const UidType(14, "Application Hosting Model");
  static const kLdapOid                 = const UidType(15, "LDAP OID");
  static const kMappingResource         = const UidType(16, "Mapping Resource");
  static const kColorPalette            = const UidType(17, "Color Palette");
  static const kTransfer                = const UidType(18, "Transfer");
  static const kSynchronizationFrameOfReference =
      const UidType(19, "Synchronization Frame Of Reference");
}
