// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
part of odw.sdk.common.reader.byte_buf;


class StringReader {
  final String buf;
  int _rIndex;
  int _wIndex;

  StringReader(this.buf, [int start = 0, int end])
      : _wIndex = checkBufferLength(buf.length, start, end);

  StringReader.fromCodeUnits(String buf, [int start = 0, int end])
      : buf = buf,
        _wIndex = checkBufferLength(buf.length, start, end);

  String operator [](int i) => (isValidRIndex(i))  ? buf[i] : null;

  String _get(int i) => buf[i];

  int get length => buf.length;

  String get peek => buf[_rIndex];

  StringReader view([int start = 0, int end]) =>
      new StringReader(buf.substring(start, end));

  String _readString(int start, int end) => buf.substring(start, end);

}
