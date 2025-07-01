import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'long_codec.dart';

class XsdLongDecoder extends Converter<String, BigInt> {
  const XsdLongDecoder();

  @override
  BigInt convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final RegExp integerPattern = RegExp(r'^[\-\+]?[0-9]+$');
    if (!integerPattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD long lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD long: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:long
    if (bigIntValue < XsdLongCodec.minInclusive ||
        bigIntValue > XsdLongCodec.maxInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:long. Must be between ${XsdLongCodec.minInclusive} and ${XsdLongCodec.maxInclusive}.",
      );
    }

    return bigIntValue;
  }
}
