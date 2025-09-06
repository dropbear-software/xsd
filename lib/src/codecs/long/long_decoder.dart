import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdLongDecoder extends Converter<String, BigInt> {
  const XsdLongDecoder();

  static final BigInt _minValue = BigInt.parse('-9223372036854775808');
  static final BigInt _maxValue = BigInt.parse('9223372036854775807');

  @override
  BigInt convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final BigInt? value = BigInt.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid XSD long lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:long. Must be between $_minValue and $_maxValue.",
      );
    }

    return value;
  }
}
