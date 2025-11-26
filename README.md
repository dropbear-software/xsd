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

## Supported XSD Datatypes

This library aims to support the following XSD 1.1 built-in datatypes that are commonly used in RDF and general XML processing:

| **XSD Data Type**          | **Planned** | **Implemented** | **Dart Data Type** | **Implementation Source** |
|------------------------|-------------|-----------------|----------------|------------|
|          `xsd:boolean` |      ✅      |        ✅        |     `bool`     |     `dart:core`    |
|           `xsd:string` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
| `xsd:normalizedString` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
|            `xsd:token` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
|          `xsd:NMTOKEN` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
|             `xsd:Name` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
|         `xsd:language` |      ✅      |        ✅        |    `Locale`    |     `package:intl`    |
|           `xsd:NCName` |      ✅      |        ✅        |    `String`    |     `dart:core`    |
|          `xsd:decimal` |      ✅      |        ❌        |    `Decimal`    |     `package:decimal`    |
|           `xsd:double` |      ✅      |        ❌        |    `double`    |     `dart:core`    |
|            `xsd:float` |      ✅      |        ❌        |    `double`    |     `dart:core`    |
|          `xsd:integer` |      ✅      |        ❌        |    `BigInt`    |     `dart:core`    |
| `xsd:nonPositiveInteger` |      ✅      |        ✅        |    `BigInt`    |     `dart:core`    |
| `xsd:negativeInteger` |      ✅      |        ❌        |    `BigInt`    |     `dart:core`    |
| `xsd:long` |      ✅      |        ✅        |    `BigInt`    |     `dart:core`    |
| `xsd:int` |      ✅      |        ✅        |    `int`    |     `dart:core`    |
| `xsd:short` |      ✅      |        ✅        |    `int`    |     `dart:core`    |
| `xsd:byte` |      ✅      |        ✅        |    `int`    |     `dart:core`    |
| `xsd:nonNegativeInteger` |      ✅      |        ✅        |    `BigInt`    |     `dart:core`    |
| `xsd:positiveInteger` |      ✅      |        ✅        |    `BigInt`    |     `dart:core`    |
| `xsd:unsignedLong` |      ✅      |        ✅        |    `BigInt`    |     `dart:core`    |
| `xsd:unsignedInt` |      ✅      |        ❌        |    `int`    |     `dart:core`    |
| `xsd:unsignedShort` |      ✅      |        ✅        |    `int`    |     `dart:core`    |
| `xsd:unsignedByte` |      ✅      |        ✅        |    `int`    |     `dart:core`    |
| `xsd:anyURI` |      ✅      |        ❌        |    `Uri`    |     `dart:core`    |
| `xsd:hexBinary` |      ✅      |        ✅        |    `Uint8List`    |     `dart:typed_data`    |
| `xsd:base64Binary` |      ✅      |        ✅        |    `Uint8List`    |     `dart:typed_data`    |
| `xsd:duration` |      ✅      |        ✅        |    `XsdDuration`[1]    |     `package:xsd`    |
| `xsd:yearMonthDuration` |      ✅      |        ❌        |    ???    |     ???    |
| `xsd:dayTimeDuration` |      ✅      |        ❌        |    ???    |     ???    |
| `xsd:dateTime` |      ✅      |        ✅        |    `XsdDateTime`[2]    |     `package:xsd`    |
| `xsd:dateTimeStamp` |      ✅      |        ❌        |    ???    |     ???    |
| `xsd:date` |      ✅      |        ❌        |    ???    |     ???    |
| `xsd:time` |      ✅      |        ❌        |    ???    |     ???    |
| `xsd:gYearMonth` |      ✅      |        ✅        |    `YearMonth`    |     `package:xsd`    |
| `xsd:gYear` |      ✅      |        ✅        |    `GregorianYear`    |     `package:xsd`    |
| `xsd:gMonthDay` |      ✅      |        ✅        |    `GregorianMonthDay`    |     `package:xsd`    |
| `xsd:gDay` |      ✅      |        ✅        |    `GregorianDay`    |     `package:xsd`    |
| `xsd:gMonth` |      ✅      |        ✅        |    `GregorianMonth`    |     `package:xsd`    |
| `xsd:QName` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:NOTATION` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:ID` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:IDREF` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:ENTITY` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:ENTITIES` |      ❌      |        ❌        |    ❌    |     ❌    |
| `xsd:NMTOKENS` |      ❌      |        ❌        |    ❌    |     ❌    |

[1] **Note:** Although Dart already has a `Duration` class it actually represents an entirely different concept to the ISO8600 / XSD idea of a duration which `XsdDuration` implements.

[2] **Note:** Dart's native `DateTime` class doesn't preserve the original timezone offset from a parsed string, which is important for round-tripping `xsd:dateTime` values. This wrapper class stores the original offset to address this.

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
