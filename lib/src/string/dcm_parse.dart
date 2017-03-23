// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
library odw.sdk.dictionary.string.parse;

import 'package:common/ascii.dart';
import 'package:common/logger.dart';
import 'package:dictionary/src/string/parse_error.dart';
import 'package:dictionary/src/string/parse_issues.dart';

//part 'package:dictionary/src/string/parse/issues.dart';
//part 'package:dictionary/src/string/parse/parse_date_time.dart';
//part 'package:dictionary/src/string/parse/parse_number.dart';
part 'package:dictionary/src/string/parse/parse_utils.dart';

// TODO: remove logging before version 0.9.0
final Logger log =
    new Logger('date_time/utils_old.dart', watermark: Severity.debug1);

//Urgent: needed.
/// These determine the error value returned
///
/// - [ParseType.value] returns a value (int for Dates and Times).
/// - [ParseType.isValid] returns a [bool] value.
/// - [ParseType.issue] returns a [String] containing issues.
enum ParseType {value, boolean, issue}

//Urgent: needed?
DateTime dateTimeValue(int y, int m, int d) => new DateTime(y, m, d);
bool dateBoolean(int y, int m, int d) => !(y == null || m == null || d == null);
String dateIssuesValue(int y, int m, int d) => null;
