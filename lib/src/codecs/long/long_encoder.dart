import 'dart:convert';

import 'long_codec.dart';

class XsdLongEncoder extends Converter<BigInt, String> {
  const XsdLongEncoder();

  @override
  String convert(BigInt input) {
    // Canonical representation for integer types
    if (input < XsdLongCodec.minInclusive ||
        input > XsdLongCodec.maxInclusive) {
      throw FormatException(
        "Value '$input' is out of range for xsd:long. Must be between ${XsdLongCodec.minInclusive} and ${XsdLongCodec.maxInclusive}.",
      );
    }
    return input.toString();
  }
}
