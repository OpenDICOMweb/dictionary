### Open DICOMweb
# Naming Conventions

### Standard Types used in the Data Dictionary


#### Standard Identifiers and their Types

Often when only one object is involved and the Type identifier is
short, the identifier for an object of that Type will use the Type
identifier in lowercase.  For example:

    Tag tag = new Tag(...);

Table X contains common identifiers used in Open DICOM_web_ code.

**<center>Table X: Common Identifiers and Their Types</center>**

<center>

|  Identifier |  Type  | Meaning|
|:-----------|:------|:--------|
code |int | A 32-bit Data Element Tag code.|
| e | Element | A DICOM Data Element containing a Tag and a List of values.|
|id | int | A locally unique identifier, where locally means in the context of ODW SDK.|
|keyword | String | A field that contains a keyword for the object that contains it.|
|'k'keyword | String | An identifier for a constant object.|
|tag | Tag | A semantic identifier for a DICOM concept.|
|uid | Uid | A DICOM Unique Identifier(UID).|
|uuid | Uuid | A Universally Unique Identifier (aka GUID).|
|values | List | A List of zero or more values of a Data Element|
|value | V | The value of a single valued (i.e. VM = 1) Data Element.|
|vm | VM | The Value Multiplicity of a Data Element|
|vr | VR | The Value Representation of a Data Element|

</center>

#### DICOM Terms and Types

The following DICOM Data Element terms almost always have
the corresponding type:


    Tag: int
    Keyword: String
    Name: String
    Value Multiplicity: VM
    Value Representation: VR
    Retired: boolean

#### File and Library names

The ODW project follows the
[Dart naming conventions](https://www.dartlang.org/effective-dart/style/).
In general filepaths and library names should correspond to each other.
The directory part of the filepath should qualify the type of
code contained in the file.  For example:

    odw/sdk/uid/well_known/constants.dart

Should have a library name

    library odw.sdk.uid.well_known.constants;

and should contain constant definitions of "Well Known", i.e.
defined in PS3.6, DICOM UIDs of the form:

    const kVerificationSOPClass = "1.2.840.10008.1.1";

#### Identifiers

Classes and types use UpperCamelCase

Method and field use lowerCamelCase.

Identifiers are Dart field or method identifiers.
  * "Id" for identifiers in code
  * "id" for filename components

#### Simple Identifier/Value Constants

Dart source with a filename of "constants.dart" have definitions
of the form:

    const <id> = <value>

Where <id> is a Dart identifier and <value> is a simple value,
such as an int, double, string, etc.  It should not be a class
instance.  For example:

    const kVerificationSOPClass = "1.2.840.10008.1.1";
    const int kFileSetID = 0x00041130;

The directory part of the filepath should qualify the type of
constant definitions contained in the file.  For example:

        odw/sdk/uid/well_known/constants.dart

contains "Well Known" DICOM UID constant definitions.

#### Maps

Files containing _Map_s from one constant to another have file names
of the form:

    <thing>_to_<thing>.dart

and class names of the form:

    <thing>To<thing>


#### Constan