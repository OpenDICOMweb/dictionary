// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

class ParseError extends Error {
    String issues;

    ParseError(this.issues) {
        print('"$issues"');
    }

    @override
    String toString() => 'ParseError: $issues';
}