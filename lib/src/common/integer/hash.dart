// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

/// The 32-bit hash mask.
const int k32BitHashMask = 0x1fffffff;

int combine32(int hash, int value) => _combine32(hash, value);

int finish32(int hash) =>  _finish32(hash);

// Jenkins hash functions - from quiver package on Pub.
int _combine32(int hash, int value) {
  int h = k32BitHashMask & (hash + value);
  h = k32BitHashMask & (h + ((0x0007ffff & h) << 10));
  return h ^ (h >> 6);
}

int _finish32(int hash) {
  int h = k32BitHashMask & (hash + ((0x03ffffff & hash) << 3));
  h = h ^ (h >> 11);
  return k32BitHashMask & (h + ((0x00003fff & h) << 15));
}

/// Generates a hash code for one object.
int hash(Object o) => _finish32(_combine32(0, o.hashCode));

/// Generates a hash code for two objects.
int hash2(Object o0, Object o1) => _finish32(_combine32(_combine32(0, o0.hashCode), o1.hashCode));

/// Generates a hash code for three objects.
int hash3(Object o0, Object o1, Object o2) =>
    _finish32(_combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode));

/// Generates a hash code for four objects.
int hash4(Object o0, Object o1, Object o2, Object o3) => _finish32(_combine32(
    _combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode), o3.hashCode));

/// Generates a hash code for multiple [objects].
int hashList(Iterable<Object> objects) =>
    _finish32(objects.fold(0, (int h, Object o) => _combine32(h, o.hashCode)));

/*TODO 64-bit
/// The 64-bit hash mask.
const int k64BitHashMask = 0x1fffffffffffffff;

// Jenkins hash functions - from quiver package on Pub.
int _combine64(int hash, int value) {
  int h = k64BitHashMask & (hash + value);
  h = k64BitHashMask & (h + ((0x0007ffff & h) << 10));
  return h ^ (h >> 6);
}

int _finish64(int hash) {
  int h = 0x1fffffff & (hash + ((0x03ffffffffffffff & hash) << 3));
  h = h ^ (h >> 11);
  return 0x1fffffff & (h + ((0x00003fffffffffff & h) << 15));
}
*/

/// A class implementing a 32-bit Jenkins hash
class Hash {
  /// An untested hash seed.
  static const int kHashSeed = 17;
  /// The hash seed for any newly created [Hash] [Object]s.
  final int seed;

  /// Creates a new [Hash] object.
  const Hash(this.seed);

  /// A constant hash function.
  static const Hash hash = const Hash(kHashSeed);

  int _hash(int hash, Object o) => _finish32(_combine32(kHashSeed, o.hashCode));

  /// Returns a [hashCode] for 1 object.
  int call(Object o) => _hash(kHashSeed, o.hashCode);

  /// Generates a hash code for two objects.
  int n2(Object o0, Object o1) => _finish32(_combine32(_combine32(0, o0.hashCode), 01.hashCode));

  /// Generates a hash code for three objects.
  int n3(Object o0, Object o1, Object o2) =>
      _finish32(_combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode));

  /// Generates a hash code for four objects.
  int n4(Object o0, Object o1, Object o2, Object o3) => _finish32(_combine32(
      _combine32(_combine32(_combine32(0, o0.hashCode), o1.hashCode), o2.hashCode), o3.hashCode));

  /// Generates a hash code for four objects.
  int n5(Object o0, Object o1, Object o2, Object o3, Object o4) =>
  _finish32(_combine32(_combine32(_combine32(_combine32(
  _combine32(0, o0.hashCode), o1.hashCode), o2.hashCode), o3.hashCode), o4.hashCode));

  /// Generates a hash code for multiple [objects].
  int list(Iterable<Object> objects) =>
      _finish32(objects.fold(0, (int h, Object o) => _combine32(h, o.hashCode)));
}
