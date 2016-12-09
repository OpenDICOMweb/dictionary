// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'private_creator.dart';

//TODO: generate a file like this one for each Private Creator String.
class PrivateGroup {
    final String id;
    final List<PrivateCreator> creators;

    const PrivateGroup(this.id, this.creators);
}
