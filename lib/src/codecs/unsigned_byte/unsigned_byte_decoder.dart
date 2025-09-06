import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdUnsignedByteDecoder extends Converter<String, int> {
  const XsdUnsignedByteDecoder();

  static const int _minValue = 0;
  static const int _maxValue = 255;

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid XSD unsignedByte lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:unsignedByte. Must be between $_minValue and $_maxValue.",
      );
    }
    return value;
  }
}
