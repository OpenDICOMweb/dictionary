// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// See the AUTHORS file for contributors.

/// A class that defined Value Multiplicities and their validators.
///
/// The Value Multiplicity (VM) of an Attribute defines the minimum,
/// maximum and width of an array of values in an Attribute's Value Field.
class VM {
  /// The name of this [VM].
  final String name;

  /// THe minimum number of values that must be present, if any values
  /// are present. [min] [%] [width] must equal 0.
  final int min;

  /// The maximum number of values that are allowed. [max] [%] [width]
  /// must equal 0. If [max] is -1 than as many values as will fit in the
  /// Value Field are allowed.
  final int max;

  /// The [width] of the array of values. Both [min] and [max] must be
  /// evenly divisible by [width]. That is [min] [%] [width] == [man] [%]
  /// [width] == 0 must be [true].
  final int width;

  // Constructor
  const VM(this.name, this.min, this.max, this.width);

  String get id {
    var s = name.replaceAll("-", "_");
    return 'k$s';
  }

  bool get isFixed => min == max;
  bool get isSingleton => width == 0;

  @override
  String toString() => 'VM.$id';

  // Members
  // Special case optimization [k1] [width == 0]
  //                           name min max width
  static const VM k1 = const VM("1", 1, 1, 0);
  static const VM k1_2 = const VM("1_2", 1, 2, 1);
  static const VM k1_3 = const VM("1-3", 1, 3, 1);
  static const VM k1_8 = const VM("1-8", 1, 8, 1);
  // Note: added for Private Tags
  static const VM k1_16 = const VM("1-16", 1, 16, 1);
  static const VM k1_32 = const VM("1-32", 1, 32, 1);
  static const VM k1_99 = const VM("1-99", 1, 99, 1);
  // Note: added for Private Tags
  static const VM k1_143 = const VM("1-143", 1, 143, 1);
  // Note: added for Private Tags
  static const VM k1_256 = const VM("1-256", 1, 256, 1);
  static const VM k1_n = const VM("1-n", 1, -1, 1);
  static const VM k2 = const VM("2", 2, 2, 1);
  // Note: added for Private Tags
  static const VM k2_3 = const VM("2-3", 2, 6, 1);
  static const VM k2_2n = const VM("2-2n", 2, -1, 2);
  static const VM k2_n = const VM("2-n", 2, -1, 1);
  static const VM k3 = const VM("3", 3, 3, 1);
  static const VM k3_3n = const VM("3-3n", 3, -1, 3);
  static const VM k3_n = const VM("3-n", 3, -1, 1);
  static const VM k4 = const VM("4", 4, 4, 1);
  // Note: added for Private Tags
  static const VM k5 = const VM("5", 5, 5, 1);
  static const VM k6 = const VM("6", 6, 6, 1);
  static const VM k6_n = const VM("6_n", 6, -1, 1);
  // Note: added for Private Tags
  static const VM k7_n = const VM("7-n", 7, -1, 1);
  // Note: added for Private Tags
  static const VM k8 = const VM("8", 8, 8, 1);
  static const VM k9 = const VM("9", 9, 9, 1);
  static const VM k16 = const VM("16", 16, 16, 1);
  // Note: added for Private Tags
  static const VM k24 = const VM("24", 24, 24, 1);
  static const VM kNoVM = const VM("NoVM", 0, 0, 0);
  static const VM kUnknown = const VM("Unknown", 1, -1, 1);

  //Private Tag VMs
  static const VM k7 = const VM("7", 7, 7, 1);
  static const VM k256 = const VM("256", 256, 256, 1);
  static const VM k4_n = const VM("4-n", 4, -1, 1);
  static const VM k4_4n = const VM("4-4n", 4, -1, 4);
  static const VM k6_6n = const VM("6-6n", 6, -1, 6);

  static const VM k0_n = const VM("0-n", 0, -1, 1);
  static const VM k12 = const VM("12", 12, 12, 1);
  static const VM k12_n = const VM("12-n", 12, -1, 1);
  static const VM k18 = const VM("18", 18, 18, 1);
  static const VM k28 = const VM("28", 28, 28, 1);
  static const VM k30_30n = const VM("30-30n", 30, -1, 30);
  static const VM k32 = const VM("32", 32, 32, 1);
  static const VM k35 = const VM("35", 35, 35, 1);
  static const VM k47_47n = const VM("47-47n", 47, -1, 47);

  //???
  static const VM kN = const VM("40923", 40923, 40923, 1);
  static const VM k40909 = const VM("40909", 40909, 40909, 1);
  static const VM k40910 = const VM("40910", 40910, 40910, 1);
  static const VM k40915 = const VM("40915", 40915, 40915, 1);
  static const VM k40923 = const VM("40923", 40923, 40923, 1);

  //TODO: add all VM const definitions to this List.
  // Lookup Map
  static const List<VM> vms = const [
    VM.k1,
    VM.k1_2,
    VM.k1_32,
    VM.k1_99,
    VM.k16,
    VM.k1_n,
    VM.k2,
    VM.k2_2n,
    VM.k2_n,
    VM.k3,
    VM.k3_3n,
    VM.k3_n,
    VM.k4,
    VM.k6,
    VM.k6_n,
    VM.k9
  ];

  // Lookup Map
  static const Map<String, VM> keywordMap = const {
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

  // Lookup Map
  static const Map<String, VM> map = const {
    "1": VM.k1,
    "1_2": VM.k1_2,
    "1_32": VM.k1_32,
    "1_99": VM.k1_99,
    "16": VM.k16,
    "1_n": VM.k1_n,
    "2": VM.k2,
    "2_2n": VM.k2_2n,
    "2_n": VM.k2_n,
    "3": VM.k3,
    "3_3n": VM.k3_3n,
    "3_n": VM.k3_n,
    "4": VM.k4,
    "6": VM.k6,
    "6_n": VM.k6_n,
    "9": VM.k9
  };

  /// lookup VM using name
  static VM lookup(String name) => map[name];
/*
  static const int nColumns = 4;
  //TODO: why can't this be constant
  static const int nRows = vms.length;
  //Used to write in gen_table_format
  //TODO: add index to constant values.
  final int index = 0;

  String tableEntry() => 'className=VM, nRows=$nRows, nCols=$nColumns';
  String fieldNames() => 'index, id, name, min, max, width, fixed';
  String fieldTypes() => 'int, String, String, int, int, int, bool';
  String toLogEntry() => 'VM: $index: $id, name=$name, min=$min, '
      'max=$max, width=$width, fixed=$isFixed';
 */
}
