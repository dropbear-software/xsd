import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdShortDecoder extends Converter<String, int> {
  const XsdShortDecoder();

  static const int _minValue = -32768;
  static const int _maxValue = 32767;

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid XSD short lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:short
    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:short. Must be between $_minValue and $_maxValue.",
      );
    }
    return value;
  }
}
