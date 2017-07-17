// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


abstract class EnumValues<V> {
  final List<V> values;

  const EnumValues(this.values);

  int indexOf(V value) => values.indexOf(value);

  bool contains(V value) => values.contains(values);
}

abstract class DefinedTermsBaseList<V> {
  final List<V> values;

  const DefinedTermsBaseList(this.values);

  int indexOf(V value) => values.indexOf(value);

  bool contains(V value) => values.contains(values);
}

abstract class EnumValuesMap<K, V> {
  final Map<K, V> map;

  const EnumValuesMap(this.map);

  Iterable<K> get keys => map.keys;

  Iterable<V> get values => map.values;

  V value(K key) => map[key];

  bool isValid(K key) => map.keys.contains(key);
}




