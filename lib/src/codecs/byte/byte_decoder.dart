import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdByteDecoder extends Converter<String, int> {
  const XsdByteDecoder();

  static const int _minValue = -128;
  static const int _maxValue = 127;

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      // If int.tryParse fails, it could be a lexical error or a number too large
      // for a platform int. We use BigInt.tryParse to differentiate.
      if (BigInt.tryParse(collapsedInput) != null) {
        // The string is a valid integer, but it's too large to be parsed as a
        // platform int, so it's definitely out of range for xsd:byte.
        throw FormatException(
          "Value '$collapsedInput' is out of range for xsd:byte. Must be between $_minValue and $_maxValue.",
        );
      }
      throw FormatException(
        "Invalid xsd:byte lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:byte. Must be between $_minValue and $_maxValue.",
      );
    }

    return value;
  }
}
