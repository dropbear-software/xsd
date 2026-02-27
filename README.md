# XSD for Dart

Strict, lossless, and platform-consistent implementations of W3C XSD 1.1 Datatypes for Dart.

[![Pub Version](https://img.shields.io/pub/v/xsd)](https://pub.dev/packages/xsd)
[![Dart SDK Version](https://img.shields.io/static/v1?label=sdk&message=%5E3.10.0&color=blue)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

`xsd` aims to be the standard library for high-fidelity XSD 1.1 datatype handling in Dart. It eliminates the "impedance mismatch" between Dart's pragmatic types and XSD's strict lexical requirements, ensuring that data remains consistent and uncorrupted across all Dart platforms, including the Web.

## Key Features

- **Unified Codec System:** A global `xsd` namespace providing `decode()` (lexical to Dart) and `encode()` (Dart to canonical lexical form) for every supported type.
- **Platform-Safe Numeric Types:** Built to handle 64-bit and unbounded integers (using `BigInt`) and arbitrary precision decimals to prevent data loss on the Web.
- **Strict Lexical Fidelity:** Guaranteed generation of W3C Canonical Lexical Forms.
- **Strict Whitespace Normalization:** Dedicated infrastructure for `preserve`, `replace`, and `collapse` strategies, strictly following W3C XSD 1.1 rules.
- **RDF 1.2 Compatibility:** Focused support for the subset of XSD types recommended for RDF systems.

## Getting started

Add `xsd` to your `pubspec.yaml`:

```yaml
dependencies:
  xsd: ^0.1.0
```

## Usage

The library provides a global `xsd` facade to access all codecs in a consistent way.

```dart
import 'package:xsd/xsd.dart';

void main() {
  // Decoding xsd:boolean
  // Supports 'true', 'false', '1', '0' and handles whitespace collapse
  final isEnabled = xsd.boolean.decode(' 1 '); // returns true
  
  // Encoding to Canonical Lexical Form ('true' or 'false')
  final lexical = xsd.boolean.encode(false);   // returns 'false'

  // Handling Validation Errors
  try {
    xsd.boolean.decode('not-a-boolean');
  } on XsdValidationException catch (e) {
    print('Validation failed: ${e.message}');
  }
}
```

## Supported Datatypes

We are incrementally implementing the RDF-compatible subset of XSD 1.1 types:

| Category | Type | Status | Dart Type |
| :--- | :--- | :--- | :--- |
| **Core types** | `xsd:string` | 🏗️ | `String` |
| | `xsd:boolean` | ✅ | `bool` |
| | `xsd:decimal` | ✅ | `XsdDecimal` |
| | `xsd:integer` | 🏗️ | `BigInt` |
| **IEEE Floating-Point** | `xsd:double` | ✅ | `double` |
| | `xsd:float` | 🏗️ | `double` |
| **Time and Date** | `xsd:date` | 🏗️ | `XsdDate` |
| | `xsd:time` | 🏗️ | `XsdTime` |
| | `xsd:dateTime` | 🏗️ | `DateTime` |
| | `xsd:dateTimeStamp` | 🏗️ | `DateTime` |
| **Partial Dates** | `xsd:gYear` | 🏗️ | `int` |
| | `xsd:gMonth` | 🏗️ | `int` |
| | `xsd:gDay` | 🏗️ | `int` |
| | `xsd:gYearMonth` | 🏗️ | `XsdYearMonth` |
| | `xsd:gMonthDay` | 🏗️ | `XsdMonthDay` |
| **Durations** | `xsd:duration` | 🏗️ | `XsdDuration` |
| | `xsd:yearMonthDuration` | 🏗️ | `XsdDuration` |
| | `xsd:dayTimeDuration` | 🏗️ | `XsdDuration` |
| **Limited-range Integers** | `xsd:byte` | ✅ | `XsdByte` |
| | `xsd:short` | 🏗️ | `int` |
| | `xsd:int` | 🏗️ | `int` |
| | `xsd:long` | 🏗️ | `int` / `BigInt` |
| | `xsd:unsignedByte` | 🏗️ | `int` |
| | `xsd:unsignedShort` | 🏗️ | `int` |
| | `xsd:unsignedInt` | 🏗️ | `int` |
| | `xsd:unsignedLong` | 🏗️ | `BigInt` |
| | `xsd:positiveInteger` | 🏗️ | `BigInt` |
| | `xsd:nonNegativeInteger` | 🏗️ | `BigInt` |
| | `xsd:negativeInteger` | 🏗️ | `BigInt` |
| | `xsd:nonPositiveInteger` | 🏗️ | `BigInt` |
| **Encoded Binary** | `xsd:hexBinary` | 🏗️ | `Uint8List` |
| | `xsd:base64Binary` | 🏗️ | `Uint8List` |
| **Miscellaneous** | `xsd:anyURI` | 🏗️ | `Uri` |
| | `xsd:language` | 🏗️ | `String` |
| | `xsd:token` | 🏗️ | `String` |
| | `xsd:NMTOKEN` | 🏗️ | `String` |
| | `xsd:Name` | 🏗️ | `String` |
| | `xsd:NCName` | 🏗️ | `String` |
| | `xsd:normalizedString` | 🏗️ | `String` |

## Compliance

`xsd` targets a **100% pass rate** against the W3C XSD 1.1 Test Suite for lexical-to-value and value-to-lexical mappings of all supported types. We guarantee platform parity, ensuring identical behavior between the Dart VM and JavaScript (Web).
