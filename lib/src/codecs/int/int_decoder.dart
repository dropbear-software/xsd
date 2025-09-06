import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdIntDecoder extends Converter<String, int> {
  const XsdIntDecoder();

  static const int _minValue = -2147483648;
  static const int _maxValue = 2147483647;

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      // If int.tryParse fails, it could be a lexical error or a number too large
      // for a platform int. We use BigInt.tryParse to differentiate.
      if (BigInt.tryParse(collapsedInput) != null) {
        // The string is a valid integer, but it's too large to be parsed as a
        // platform int, so it's definitely out of range for xsd:int.
        throw FormatException(
          "Value '$collapsedInput' is out of range for xsd:int. Must be between $_minValue and $_maxValue.",
        );
      }
      throw FormatException(
        "Invalid XSD int lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:int. Must be between $_minValue and $_maxValue.",
      );
    }
    return value;
  }
}
