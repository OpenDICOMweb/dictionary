// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// Hash functions for creating [hashCode]s.


///  Thomas Wang
int hash32(int a) {
  a = (a + 0x7ed55d16) + (a << 12);
  a = (a ^ 0xc761c23c) ^ (a >> 19);
  a = (a + 0x165667b1) + (a << 5);
  a = (a + 0xd3a2646c) ^ (a << 9);
  a = (a + 0xfd7046c5) + (a << 3);
  a = (a ^ 0xb55a4f09) ^ (a >> 16);
  return a;
}

int hash64(int key) {
  key = (~key) + (key << 21);
  key = (key << 21) - key - 1;
  key = key ^ (key >> 24);
  key = (key + (key << 3)) + (key << 8);
  key * 265;
  key = key ^ (key >> 14);
  key = (key + (key << 2)) + (key << 4);
  key * 21;
  key = key ^ (key >> 28);
  key = key + (key << 31);
  return key;
}

//TODO: improve usage documentation
/// A Standard [hash] functions.
///
/// THe [Hash] class used to create Hash functions that return [hashCode]s.
///
/// Uses strategy from Effective Java, Chapter 11.
///
/// Example:
///     int get hashCode => hash(part3, hash(part2, hash(part1)));
/// The static methods all use [kHashSeed] and [kHashMultiplier]
class Hash {
  /// The default hash seed. The number used is the 8th Mersenne prime.
  /// See https://en.wikipedia.org/wiki/2147483647_(number).
  static const int kHashSeed = 17;

  /// The default hash multiplier
  static const int kHashMultiplier = 37;

  /// The 32-bit hash mask.
  static const int k32BitHashMask = 0x3FFFFFFF;

  /// The 64-bit hash mask.
  static const int k64BitHashMask = 0x3FFFFFFFFFFFFFFF;

  /// The [mask] used to make the result fit into a 32 or 64 bit SMI.
  final int mask;

  const Hash._(this.mask);

  /// A hasher returning 30-bit integer [hashCode]s.
  static const Hash hash32 = const Hash._(k32BitHashMask);

  /// A hasher returning 62-bit integer [hashCode]s.
  static const Hash hash64 = const Hash._(k64BitHashMask);

  /// The default hasher.
  static const Hash hash = hash64;

  int _hash(int o, int result) => (kHashMultiplier * result + o.hashCode) & mask;

  /// Returns a [hashCode] for 1 object.
  int call(Object o) => _hash(o.hashCode, kHashSeed);

  /// Returns a [hashCode] for [Object] [o].
  int n1(Object o) => _hash(o.hashCode, kHashSeed);

  /// Returns a [hashCode] for 2 objects.
  int n2(Object o1, Object o2) => _hash(o1.hashCode, _hash(o2.hashCode, kHashSeed));

  /// Returns a [hashCode] for 3 objects.
  int n3(Object o1, Object o2, Object o3) => _hash(o1.hashCode, _hash(o2.hashCode, _hash(o3.hashCode, kHashSeed)));

  /// Returns a [hashCode] for 4 objects.
  int n4(Object o1, Object o2, Object o3, Object o4) =>
      _hash(o1.hashCode, _hash(o2.hashCode, _hash(o3.hashCode, _hash(o4.hashCode, kHashSeed))));

  /// Returns a [hashCode] for 5 objects.
  int n5(Object o1, Object o2, Object o3, Object o4, Object o5) =>
      _hash(o1.hashCode, _hash(o2.hashCode, _hash(o3.hashCode, _hash(o4.hashCode, _hash(o5.hashCode, kHashSeed)))));

  /// Returns a [hashCode] for a [List] of [Object]s.
  int list(List<Object> list) {
    int value = kHashSeed;
    for (int i = 0; i < list.length; i++) value = _hash(list[i], value);
    return value;
  }

  /* Flush at 0.6.0
  /// Returns a [hashCode] for 1 object using the default method.
  static int n1(o1) => hash64(o1);

  /// Returns a [hashCode] for 2 objects using the default method.
  static int n2(o1, o2) => hash64.arg2(o1.hashCode, hash64(o2));

  /// Returns a [hashCode] for 3 objects using the default method.
  static int n3(o1, o2, o3) => hash64.arg3(o1.hashCode, o2, o3);

  /// Returns a [hashCode] for 4 objects using the default method.
  static int n4(o1, o2, o3, o4) => hash64.arg4(o1, o2, o3, o4);

  /// Returns a [hashCode] for 5 objects using the default method.
  static int n5(o1, o2, o3, o4, o5) => hash64.arg5(o1, o2, o3, o4, o5);

  /// Returns a [hashCode] for a [List] of objects using the default method.
  ///
  /// Note: This should only be used when hashing more than 5 objects.
  static int nList(List<Object> list) => hash64.list(list);
  */
}


