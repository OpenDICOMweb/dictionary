// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'integer.dart';
/// Hash functions for creating [hashCode]s.

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
    final int seed;
    final int multiplier;
    final int mask;

    const Hash._(this.seed, this.multiplier, this.mask);

    static const hash32 = const Hash._(Int.kHashSeed, Int.kHashMultiplier, Int.k32BitHashMask);
    static const hash64 = const Hash._(Int.kHashSeed, Int.kHashMultiplier, Int.k64BitHashMask);
    static const hash = hash64;

    int _hash(Object o, int result) => (multiplier * result + o.hashCode) & mask;

    /// Returns a [hashCode] for 1 object.
    call(Object o) => _hash(o, seed);

    //TODO: delete if call is sufficient
    //int arg1(Object o1) => _hash(o1, seed);

    /// Returns a [hashCode] for 2 objects.
    int arg2(Object o1, o2) => _hash(o1, _hash(o2, seed));

    /// Returns a [hashCode] for 2 objects.
    int arg3(Object o1, o2, o3) => _hash(o1, _hash(o2, _hash(o3, seed)));

    /// Returns a [hashCode] for 2 objects.
    int arg4(Object o1, o2, o3, o4) => _hash(o1, _hash(o2, _hash(o3, _hash(o4, seed))));

    /// Returns a [hashCode] for 2 objects.
    int arg5(Object o1, o2, o3, o4, o5) =>
        _hash(o1, _hash(o2, _hash(o3, _hash(o4, _hash(o5, seed)))));

    /// Returns a [hashCode] for a [List] of objects.
    int list(List<Object> list) {
        int value = Int.kHashSeed;
        for (int i = 0; i < list.length; i++) value = _hash(list[i], value);
        return value;
    }

    /// Returns a [hashCode] for 1 object using the default method.
    static int n1(Object o1) => hash64(o1);

    /// Returns a [hashCode] for 2 objects using the default method.
    static int n2(Object o1, o2) => hash64(o1, hash64(o2));

    /// Returns a [hashCode] for 3 objects using the default method.
    static int n3(Object o1, o2, o3) => hash64(o1, hash64(o2, hash64(o3)));

    /// Returns a [hashCode] for 4 objects using the default method.
    static int n4(Object o1, o2, o3, o4) => hash64(o1, hash64(o2, hash64(o3, hash64(o4))));

    /// Returns a [hashCode] for 5 objects using the default method.
    static int n5(Object o1, o2, o3, o4, o5) =>
        hash64(o1, hash64(o2, hash64(o3, hash64(o4, hash64(o5)))));

    /// Returns a [hashCode] for a [List] of objects using the default method.
    ///
    /// Note: This should only be used when hashing more than 5 objects.
    static int nList(List<Object> list) {
        int value = Int.kHashSeed;
        for (int i = 0; i < list.length; i++) value = hash64(list[i], value);
        return value;
    }
}
