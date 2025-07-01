import 'dart:convert';

import 'non_negative_integer_codec.dart';

class XsdNonNegativeIntegerEncoder extends Converter<BigInt, String> {
  const XsdNonNegativeIntegerEncoder();

  @override
  String convert(BigInt input) {
    // Canonical representation for integer types
    if (input < XsdNonNegativeIntegerCodec.minInclusive) {
      throw FormatException(
        "Value '$input' is out of range for xsd:nonNegativeInteger. Must be >= ${XsdNonNegativeIntegerCodec.minInclusive}.",
      );
    }
    return input.toString();
  }
}
