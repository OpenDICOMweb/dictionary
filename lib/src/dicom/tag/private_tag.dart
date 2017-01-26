// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dictionary/src/dicom/vm.dart';
import 'package:dictionary/src/dicom/vr/vr.dart';

import 'tag_base.dart';
import 'creators_map.dart';

//TODO: rewrite
/// Private Tags extends the [TagBase] class.
///
/// Definitions:
///
///   Private Group: includes all the Private Creator and Private Data Tag with the
///     same Private Group Number.  All [PrivateGroup] numbers are odd numbers.
///   Private Creator: A tag with the form GGGG00CC, where GGGG is the Private Group Number,
///       and CC is a Private Creator Index.
///   Private Creator Index: A 16-bit value between 0x0010 and 0x00FF.
///   Private Data: A tag with the form GGGGCCDD, where GGGG is the Private Group Number,
///       CC is the Private Creator Index, and DD is the Private Data Index.
///   Private Data Index: A 16-bit value between 0xCC00 and 0xCCFF, where CC is the Private
///       Creator Index for the Private Data Element.
///
/// Note: A Private Creator identifier may be used only once within a Group;
/// reserving multiple blocks of Elements in the same Group with the same
/// identifier is not allowed. See PS3.5 Section 7.8.1.

// Note: the following conventions are used for function arguments in this library:
//   t or tag -  a 32-bit DICOM Tag
//   pc - a 32-bit Private Creator Tag
//   pd - a 32-bit Private Data Tag
//   g -  a 16-bit Private Group Number
//   e - a 16-bit Element Number
//   pce - a 16-bit Private Creator Element
//   pde - a 16-bit Private Data Element
//   pci - an 8-bit Private Creator Index
//   pdi - an 8-bit Private Data Index


//TODO: flush when working
//bool _isPrivateCreator(Tag tag) => 0x0010 <= tag.elt && tag.elt <= 0x00FF;
//bool _isPrivateData(Tag tag) => 0x1000 <= tag.elt && tag.elt <= 0xFFFF;





