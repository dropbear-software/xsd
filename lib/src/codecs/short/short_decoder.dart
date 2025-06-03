import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'short_codec.dart';

class XsdShortDecoder extends Converter<String, int> {
  const XsdShortDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final RegExp integerPattern = RegExp(r'^[\-\+]?[0-9]+$');
    if (!integerPattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD short lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD short: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:short
    if (bigIntValue < XsdShortCodec.minShortInclusive ||
        bigIntValue > XsdShortCodec.maxShortInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:short. Must be between ${XsdShortCodec.minShortInclusive} and ${XsdShortCodec.maxShortInclusive}.",
      );
    }
    return bigIntValue.toInt();
  }
}
