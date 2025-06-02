[![pub package](https://img.shields.io/pub/v/xsd.svg)](https://pub.dev/packages/xsd)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Open in Firebase Studio](https://cdn.firebasestudio.dev/btn/open_light_20.svg)](https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Fdropbear-software%xsd)
# XSD - A Dart XML Schema Datatypes Interop Library

A Dart library for working with XML Schema Datatypes (XSD) as defined by the W3C. This library provides Dart representations for XSD types and codecs to convert between their lexical (string) forms and their Dart object representations.

The primary goal is to offer a robust and idiomatic way to handle XSD typed data within Dart applications, particularly (but not exclusively) in the context of RDF data processing.

## Purpose

This library aims to:

* Provide faithful Dart representations for common XSD built-in datatypes.
* Offer `dart:convert` style `Codec` instances for each supported XSD type, allowing for easy encoding (Dart object to XSD string) and decoding (XSD string to Dart object).
* Handle XSD whitespace processing rules (`preserve`, `replace`, `collapse`) correctly.
* Validate lexical forms against the rules of the specific XSD datatype.
* Implement the value space constraints (e.g., ranges for numeric types) defined for each built-in XSD type.

## Supported XSD Datatypes (Planned)

This library aims to support the following XSD 1.1 built-in datatypes that are commonly used in RDF and general XML processing:

**String Types:**
* `xsd:string`
* `xsd:normalizedString`
* `xsd:token`
* `xsd:language`
* `xsd:NMTOKEN`
* `xsd:Name`
* `xsd:NCName`

**Boolean Type:**
* `xsd:boolean`

**Numeric Types:**
* `xsd:decimal`
* `xsd:double`
* `xsd:float`
* `xsd:integer`
    * `xsd:nonPositiveInteger`
    * `xsd:negativeInteger`
    * `xsd:long`
        * `xsd:int`
            * `xsd:short`
                * `xsd:byte`
    * `xsd:nonNegativeInteger`
        * `xsd:positiveInteger`
        * `xsd:unsignedLong`
            * `xsd:unsignedInt`
                * `xsd:unsignedShort`
                    * `xsd:unsignedByte`

**URI Type:**
* `xsd:anyURI`

**Binary Types:**
* `xsd:hexBinary`
* `xsd:base64Binary`

**Date/Time and Duration Types:**
* `xsd:duration`
    * `xsd:yearMonthDuration`
    * `xsd:dayTimeDuration`
* `xsd:dateTime`
* `xsd:dateTimeStamp`
* `xsd:date`
* `xsd:time`
* `xsd:gYearMonth`
* `xsd:gYear`
* `xsd:gMonthDay`
* `xsd:gDay`
* `xsd:gMonth`

## Unsupported XSD Datatypes

For clarity and to focus on the most common use cases, especially within RDF contexts, the following XSD 1.1 built-in datatypes are **currently not planned for support**:

* `xsd:QName`
* `xsd:NOTATION`
* `xsd:ID`
* `xsd:IDREF`
* `xsd:IDREFS`
* `xsd:ENTITY`
* `xsd:ENTITIES`
* `xsd:NMTOKENS` (the list type; `xsd:NMTOKEN` itself *is* planned).

These types often have semantics deeply tied to the overall structure and validation of an XML document instance, which is beyond the scope of just datatype representation and lexical/value space conversion.

## Current Implementation Status

The following XSD datatypes and their corresponding codecs are **already implemented and tested**:

* **Boolean:**
    * `xsd:boolean` (`XsdBooleanCodec` using Dart `bool`)
* **String & Token Types:**
    * `xsd:string` (`XsdStringCodec` using Dart `String`)
    * `xsd:NMTOKEN` (`XsdNmTokenCodec` using Dart `String`)

## Limitations

* **Facets on Built-in Types**: This library focuses on implementing the XSD built-in datatypes as they are defined in the "XML Schema Part 2: Datatypes" specification. This includes their inherent properties, lexical spaces, value spaces, and any *fixed* facets that define them (e.g., the range of `xsd:byte` or the `whiteSpace` behavior of `xsd:token`).
    * The library currently **does not** provide a mechanism to dynamically apply arbitrary constraining facets (like `minLength`, `maxLength`, `pattern`, `enumeration`, `totalDigits`, `fractionDigits` beyond what defines a base type) to create new, user-defined derived simple types *at runtime through the codec*. For instance, while `xsd:string` is supported, you cannot pass `maxLength="5"` to the `XsdStringCodec` to validate against this specific restriction dynamically. Such validation would typically be handled by a higher-level XSD schema processor that uses this library for the base datatype conversions.

## Usage

_(This section will be filled out with examples as more types are completed and the API stabilizes. Basic usage involves selecting the appropriate codec and using its `encode` or `decode` methods.)_

```dart
import 'package:xsd/xsd.dart';

final boolCodec = XsdBooleanCodec();
bool myBool = boolCodec.decode('1'); // true
String boolStr = boolCodec.encode(false); // "false"

final intCodec = XsdIntCodec();
int myInt = intCodec.decode('  -123  '); // -123
String intStr = intCodec.encode(456); // "456"
```