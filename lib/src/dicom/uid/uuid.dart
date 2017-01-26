// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
part of odw.sdk.dictionary.uid;

class UidUuid extends Uid {
    /// The UID Root for UIDs created from random (V4) UUIDs.
    static const String uidRoot = "2.25.";
    final Uuid uuid;

    UidUuid({bool isSecure = false})
        : uuid = new Uuid(isSecure:isSecure),
          super._();

    @override
    String get string => uidRoot + uuid.toString();

    @override
    UidType get type => UidType.kRandomUuid;

    @override
    String toString() => string;

    /// Returns a [String] containing a random UID as per the
    /// OID Standard.  See TODO: add reference.
    static String get random => Uuid.generator.string;
}