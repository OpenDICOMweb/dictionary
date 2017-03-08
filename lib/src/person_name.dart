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

  /// Parses a PersonName [String] composed of up to three Component Groups,
  /// and if successful, returns it; otherwise, returns [null].
  static PersonName parse(String s) {
    if (s == null || s == "") return null;
    // Parse a PersonName
    var cGroups = splitTrim(s, '=');
    if (cGroups.length < 1 || cGroups.length > 3) return null;
    var names = <Name>[];
    for (String cg in cGroups) {
      var name = Name.parse(cg);
      if (name == null) return null;
      names.add(name);
    }
    var pn = new PersonName(names);
    return (pn == null) ? null : pn;
  }
}

/// A [Name] corresponds to a DICOM Person Name (PN) Component Group.
/// A [Components] is a list of PN component [String]s. It may have from
/// one to five components.  The list may not contain [null], so interior
/// elements that have no value are represented by the empty [String] ("").
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
  int get hashCode => Hash.list(components);

  /// Family name.
  String get family => _getComponent(0);

  /// Given or first name.
  String get given => _getComponent(1);

  /// Middle name(s) or initial(s)
  String get middle => _getComponent(2);

  /// A [prefix] such as Ms., Mr., Mrs., Dr...
  String get prefix => _getComponent(3);

  /// A [suffix] such as Ph.D., or M.D.
  String get suffix => _getComponent(4);

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

// Urgent 5 components
  /// Returns true if the [PersonName] component is valid.
  static bool isValidList(List<String> list) {
    if (list == null || list.length < 1 || list.length > 5) return false;
    for(String s in list)
      if(!_filteredTest(s, _isPNComponentGroupChar)) return false;
    return true;
  }

  /// The filter for DICOM PersonName characters.  Visible ASCII
  /// characters, except Backslash(\) and Equal Sign(=).
  static bool _isPNComponentGroupChar(int c) =>
      c >= kSpace && c < kDelete && (c != kBackslash && c != kEqual);

  static bool isValidComponentGroup(String s) {
    if(s == null || s == "" || s.length > maxGroupLength) return null;
      var groups = s.split('=');
      for (String group in groups) {
        if (group.length > 64 || !_filteredTest(s, _isPNNameChar)) return
          false;
      }
      return true;
    }

    //TODO: these are taken from VRString
  /// Returns [true] if all characters pass the filter.
  static bool _filteredTest(String s, bool filter(int c)) {
    for (int i = 0; i < s.length; i++)
      if (!filter(s.codeUnitAt(i))) return false;
    return true;
  }

  /*Flush if not used
  /// The filter for DICOM PersonName characters.
  /// Visible ASCII characters, except Backslash.
  bool _isPNComponentChar(int c) =>
      c >= kSpace && c < kDelete &&
          (c != kBackslash && c != kEqual && c != kCircumflex);
  */

  /// Returns true if the [PersonName] component is valid.
  static bool isValidString(String s) {
    assert(s != null && s != "");
    return (s.length <= maxGroupLength || _hasValidNameChars(s));
  }

  /// Parses a Component Group into a [Name]
  static Name parse(String s) {
    if (s == null || s == "" ||
  s.length > 64 || _filteredTest(s, _isPNChar)) return null;
    List<String> groups = splitTrim(s, '\\');
    for(String cg in groups)
      _isPNComponentGroup(cg);
    return new Name.fromString(s.trim());
  }

  /// Return the ith component or [null] if [i] is not a valid [List] index.
  String _getComponent(int i) =>
      (i >= 1 && i < components.length) ? components[i] : null;
}

Iterable<String> splitTrim(String s, String separator) =>
    s.split(separator).map((s) => s.trim());

/// The filter for DICOM String characters.
/// Visible ASCII characters, except Backslash.
bool _isPNChar(int c) =>
    c >= kSpace && c < kDelete && c != kBackslash && c != kEqual;

bool _isPNComponentGroup(String s) => _filteredTest(s, _isPNNameChar);

/// Returns [true] if all characters pass the filter.
bool _filteredTest(String s, bool filter(int c)) {
  if (1 <= s.length && s.length <= 64) return false;
  for (int i = 0; i < s.length; i++) {
    if (!filter(s.codeUnitAt(i))) return false;
  }
  return true;
}

bool _isPNNameChar(int c) => _isPNChar(c) && c != kEqual;

/*
/// Returns [true] if all characters pass the filter.
bool _hasValidPNChars(String s) {
  for (int i = 0; i < s.length; i++) {
    if (!_isPNNameChar(s.codeUnitAt(i))) return false;
  }
  return true;
}
*/
/// Returns [true] if all characters pass the filter.
bool _hasValidNameChars(String s) {
  for (int i = 0; i < s.length; i++) {
    if (!_isPNNameChar(s.codeUnitAt(i))) return false;
  }
  return true;
}
