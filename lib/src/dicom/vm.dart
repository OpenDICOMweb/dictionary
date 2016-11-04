// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// A class that defined Value Multiplicities and their validators.
///
/// The Value Multiplicity (VM) of an Attribute defines the minimum, maximum and width
/// of an array of values in an Attribute's Value Field.
class VM {
  //Used to write in gen_table_format
  static final int nRows = 16;
  static final int nCols = 7;
  // Member fields
  final String id;
  final int min; // min number of values
  final int max; // max number of values, where -1 means any number of values
  final int width; // width of Value Field
  final bool fixed; // are there a fixed number of values

  // Constructor
  const VM(this.id, this.min, this.max, this.width, this.fixed);

  /// Validate that the number of values is legal
  //TODO write unit tests to ensure this is correct
  bool validate(List values) {
    int len = values.length;
    int max = (this.max == -1) ? 0x3FFFFFFF : this.max;
    if ((len >= this.min) && (len <= (max * this.width)) && (len % this.width == 0)) {
      return true;
    } else {
      return false;
    }
  }

  bool get isSingleton => ((min == 1) && (max == 1) && (width == 1));

  bool _inRange(int length) => (min <= length) && (length <= max);

  bool isValidVM(List list) {
    var length = list.length;
    if ((width == 1) && _inRange(length)) {
        return true;
    } else if (((length % width) == 0) && _inRange(length * width)) {
      return true;
    }
    return false;
  }

  String toString() => 'VM.$id';

  // Members
  static const VM k1 = const VM("k1", 1, 1, 1, true);
  static const VM k1_2 = const VM("k1_2", 1, 2, 1, false);
  static const VM k1_3 = const VM("k1_3", 1, 3, 1, false);
  static const VM k1_8 = const VM("k1_8", 1, 8, 1, false);
  static const VM k1_32 = const VM("k1_32", 1, 32, 1, false);
  static const VM k1_99 = const VM("k1_99", 1, 99, 1, false);
  static const VM k16 = const VM("k16", 16, 16, 1, true);
  static const VM k1_n = const VM("k1_n", 1, -1, 1, false);
  static const VM k2 = const VM("k2", 2, 2, 1, true);
  static const VM k2_2n = const VM("k2_2n", 2, -1, 2, false);
  static const VM k2_n = const VM("k2_n", 2, -1, 2, false);
  static const VM k3 = const VM("k3", 3, 3, 1, true);
  static const VM k3_3n = const VM("k3_3n", 3, -1, 3, false);
  static const VM k3_n = const VM("k3_n", 3, -1, 3, false);
  static const VM k4 = const VM("k4", 4, 4, 1, true);
  static const VM k6 = const VM("k6", 6, 6, 1, true);
  static const VM k6_n = const VM("k6_n", 6, -1, 1, false);
  static const VM k9 = const VM("k9", 9, 9, 1, true);
  static const VM kNoVM = const VM("kNoVM", 0, 0, 0, true);
  static const VM kUnknown = const VM("kUnknown", 1, -1, 1, true);

  // Lookup Map
  static const List<VM> vector = const [
    VM.k1, VM.k1_2,VM.k1_32,VM.k1_99, VM.k16, VM.k1_n, VM.k2, VM.k2_2n, VM.k2_n,
    VM.k3, VM.k3_3n, VM.k3_n, VM.k4, VM.k6, VM.k6_n, VM.k9];

  // Lookup Map
  static const Map<String, VM> map = const {
    "k1": VM.k1,
    "k1_2": VM.k1_2,
    "k1_32": VM.k1_32,
    "k1_99": VM.k1_99,
    "k16": VM.k16,
    "k1_n": VM.k1_n,
    "k2": VM.k2,
    "k2_2n": VM.k2_2n,
    "k2_n": VM.k2_n,
    "k3": VM.k3,
    "k3_3n": VM.k3_3n,
    "k3_n": VM.k3_n,
    "k4": VM.k4,
    "k6": VM.k6,
    "k6_n": VM.k6_n,
    "k9": VM.k9
  };

  /// lookup VM using name
  static VM lookup(String name) => map[name];


  //TODO add the other VM definitions
  // Write the class out in gen_table_format
 // static void writeToFile(String filename) {
 //   int nRows = _map.length;
 //   int nCols = VM.nCols;
 // }

  String tableEntry() => 'className=VM, nRows=$nRows, nCols=$nCols';
  String fieldNames() => 'id, name, min, max, width, fixed';
  String fieldTypes() => 'Symbol, String, int, int, int, bool';
  String toLogEntry() => 'VM: $id, min=$min, max=$max, width=$width, fixed=$fixed';


}
