import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'non_negative_integer_codec.dart';

class XsdNonNegativeIntegerDecoder extends Converter<String, BigInt> {
  const XsdNonNegativeIntegerDecoder();

  @override
  BigInt convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final RegExp integerPattern = RegExp(r'^[0-9]+$');
    if (!integerPattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD nonNegativeInteger lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD nonNegativeInteger: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:nonNegativeInteger
    if (bigIntValue < XsdNonNegativeIntegerCodec.minInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:nonNegativeInteger. Must be >= ${XsdNonNegativeIntegerCodec.minInclusive}.",
      );
    }

    return bigIntValue;
  }
}
