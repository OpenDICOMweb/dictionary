// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/common/uid/uid_type.dart';

/// Well Known UIDs
class WKUidType extends UidType {

  const WKUidType(int index, String name) : super(index, name);

  String get keyword => name.replaceAll(" ", "");

  String toString() => name;


  // Well Known Types
  static const kSopClass                = const WKUidType(2, "SOP Class");
  static const kTransferSyntax          = const WKUidType(3, "Transfer Syntax");
  static const kFrameOfReference        = const WKUidType(4, "Frame Of Reference");
  static const kSopInstance             = const WKUidType(5, "SOP Instance");
  static const kDicomCodingScheme       = const WKUidType(6, "Dicom Coding Scheme");
  static const kMetaSopClass            = const WKUidType(7, "Meta SOP Class");
  static const kServiceClass            = const WKUidType(8, "Service Class");
  static const kCodingScheme            = const WKUidType(9, "Coding Scheme");
  static const kApplicationContextName  = const WKUidType(10, "Application Context Name");
  static const kPrinterSopInstance      = const WKUidType(11, "Printer SOP Instance");
  static const kPrintQueueSopInstance   = const WKUidType(12, "Print Queue SOP Instance");
  static const kQueryRetrieve           = const WKUidType(13, "Query Retrieve");
  static const kApplicationHostingModel = const WKUidType(14, "Application Hosting Model");
  static const kLdapOid                 = const WKUidType(15, "LDAP OID");
  static const kMappingResource         = const WKUidType(16, "Mapping Resource");
  static const kColorPalette            = const WKUidType(17, "Color Palette");
  static const kTransfer                = const WKUidType(18, "Transfer");
  static const kSynchronizationFrameOfReference =
      const WKUidType(19, "Synchronization Frame Of Reference");
}
