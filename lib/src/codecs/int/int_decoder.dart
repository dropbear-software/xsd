import 'dart:convert';
import 'dart:typed_data';

import '../../helpers/whitespace.dart';

class XsdIntDecoder extends Converter<String, int> {
  const XsdIntDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid XSD int lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Use Int32List to validate that the value fits within 32 bits (wraps on overflow).
    final list = Int32List(1);
    list[0] = value;

    if (list[0] != value) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:int.",
      );
    }
    return value;
  }
}
