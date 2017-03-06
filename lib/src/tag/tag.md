**OpenDICOM<em>web</em> SDK**
# Tag - The Semantic Identifier for an Element

Tags define:

- **code**:* a 32-bit integer
- **keyword**: an unique string that satisfies the regular expression ^\[A-Za-z\]{1}\w*$
- **name**: a short description of the meaning of the Tag.
- **value representation(VR)**: The data type of the Tag.
- **value multiplicity(VM)**: The number and shape of the value(s) of the Tag.
- **isRetired**: A boolean value indicating whether the Tag has been retired.
- **presence**: The default presence requirement for the Tag.

## Types of Tags

- Public (DICOM) Tags
    - Known (DICOM Defined)
        - Retired (DICOM Defined, but retired
        - Group Length (gggg,0000)
    - Unknown
- Private Tags
    - Known
        - Private Creator
        - Private Data
    - Unknown
        - Private Creator
        - Private Data
    - Other
        - Private Group Length (pppp,0000)
        - Private Illegal (pppp,0001 - pppp,000F)
        - Private Data W/O Creator
## Public Tags

- Defined by [the DICOM Standard][DICOM]
- Identified by a _code_ (a 32-bit integer) or a _keyword_
- The _code_ is always an even integer.



# Issues with Data Elements

| Keyword | Type | Description
- Retired
- Invalid Public Tag


[DICOM]:http://dicom.nema.org/standard.html
