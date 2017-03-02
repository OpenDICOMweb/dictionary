// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';
import 'package:common/ascii.dart';
import 'package:common/integer.dart';

//TODO: create unit test
//TODO: maybe merge Name into PersonName

/// The DICOM PersonName Types
enum PersonNameType { alphabetic, ideographic, phonetic }

/// An equality function for lists.
const ListEquality eq = const ListEquality();

//TODO: rewrite for correctness
/// A DICOM Person Name (VR = PN)
///
/// A [PersonName] is a String containing three [Name]s, which are
/// separated by the "=" character.
/// There are potentially three different Component Groups, which are
/// called [Name]s in a [PersonName]: [alphabetic], [ideographic],
/// and [phonetic].
///
/// Each Part can have up to five components: familyName, givenName,
/// middleName, prefix, and suffix.
///
/// Each Component Group of the PersonName has a maximum of 64 characters,
/// including delimiters ('=', '^'), which cannot include the US-ASCII
/// backslash ("\").  Each component after the first is separated from
/// the next component by the character "^".
///
/// PersonNames as [String] has a canonical form in DICOM, which is:
///     "family^given^middle^prefix^suffix".
///
/// [See PS3.5](http://dicom.nema.org/medical/dicom/
/// current/output/html/part05.html).
///
class PersonName {
  final List<Name> groups;

  /// Create a new DICOM [PersonName].
  PersonName(this.groups);

  /// Create a PersonName from an ordered [List] of name components.
  factory PersonName.fromString(String s) {
    var list = splitTrim(s, '=');
    Iterable<Name> groups = list.map((e) => new Name.fromString(e));
    print(groups);
    return new PersonName(groups.toList());
  }

  /// Checks the Equality (deep) of two [PersonName]s.
  @override
  bool operator ==(Object pn) =>
      pn is PersonName && eq.equals(groups, pn.groups);

  @override
  int get hashCode => Hash.list(groups);

  Name get alphabetic => groups[0];

  Name get ideographic => groups[1];

  Name get phonetic => groups[2];

  /// Returns a DICOM formatted [PersonName].
  String get dcm => groups.map((e) => e.dcm).join('=');

  String get initials => alphabetic.initials;

  //TODO: is this ok for ACR
  // It does not exactly follow the ACR's algorithm.
  String toHashCode(int maxLength) {
    String s = alphabetic.hashCode.toRadixString(10);
    return s.substring(0, maxLength);
  }

  @override
  String toString() => dcm;

  //**** Static Methods *****

  /// Returns true if the [PersonName] component is valid.
  static bool isValidList(List<String> list) {
    assert(list != null && list.length == 3);
    return list.fold(false, (t, e) => t && Name.isValidString(e));
  }

  /// Returns true if the [PersonName] component is valid.
  static bool isValidString(String s) {
    assert(s != null && s != "");
    return isValidList(s.split("="));
  }

  /// Parses a DICOM format string into a [PersonName] and, if successful,
  /// returns it; otherwise, returns [null].
  static PersonName parse(String s) {
    List<String> groups = s.split("=");
    if (groups.length > 3) return null;
    if ((groups.length == 1) && (groups[0] == "")) return null;
    for (String group in groups)
      if (group.length > 64 || !_hasValidPNChars(s)) return null;
    return new PersonName(groups.map(Name.parse));
  }
}

/// A Name corresponds to a DICOM Person Name (PN) Component Group.
class Name {
  static const int maxComponents = 5;
  static const int maxSeparators = 4;
  static const int maxGroupLength = 64;
  final List<String> components;

  Name(this.components);

  factory Name.fromString(String s) => new Name._(splitTrim(s, '^').toList());

  const Name._(this.components);

  static const Name empty = const Name._(const <String>[]);

  @override
  bool operator ==(Object name) =>
      (name is Name) && eq.equals(components, name.components);

  @override
  int get hashCode => Hash.hash(components);

  /// Family name.
  String get family => components[0];

  /// Given or first name.
  String get given => components[1];

  /// Middle name(s) or initial(s)
  String get middle => components[2];

  /// A [prefix] such as Ms., Mr., Mrs., Dr...
  String get prefix => components[3];

  /// A [suffix] such as Ph.D., or M.D.
  String get suffix => components[4];

  String _initial(String s) => (s == "") ? s : s[0];
  String get initials =>
      '${_initial(given)}${_initial(middle)}${_initial(family)}'.toUpperCase();

  String get dcm => '${components.join('^')}';

  /// Returns an informational [String] for this [Name].
  String get info => '$runtimeType: "$dcm"';

  //TODO: is this the right format?
  /// Returns a [Name] (PN Component Group) in DICOM order.
  @override
  String toString() => '$components';

  /// Returns true if the [PersonName] component is valid.
  static bool isValidList(List<String> list) {
    assert(list != null && list.length == 5);
    return isValidString(list.join('^'));
  }

  /// Returns true if the [PersonName] component is valid.
  static bool isValidString(String s) {
    assert(s != null && s != "");
    return (s.length > maxGroupLength || _hasValidNameChars(s));
  }

  /// Parses a Component Group into a [Name]
  static Name parse(String s) {
    assert(s != null && s != "");
    if (!isValidString(s)) return null;
    return new Name.fromString(s.trim());
  }
}

Iterable<String> splitTrim(String s, String separator) =>
    s.split(separator).map((s) => s.trim());

/// The filter for DICOM String characters.
/// Visible ASCII characters, except Backslash.
bool _isPNChar(int c) =>
    (c >= kSpace && c < kBackslash || c > kBackslash && c < kDelete);

bool _isPNNameChar(int c) => _isPNChar(c) && c != kEQual;

/// Returns [true] if all characters pass the filter.
bool _hasValidPNChars(String s) {
  for (int i = 0; i < s.length; i++) {
    if (!_isPNNameChar(s.codeUnitAt(i))) return false;
  }
  return true;
}

/// Returns [true] if all characters pass the filter.
bool _hasValidNameChars(String s) {
  for (int i = 0; i < s.length; i++) {
    if (!_isPNNameChar(s.codeUnitAt(i))) return false;
  }
  return true;
}
