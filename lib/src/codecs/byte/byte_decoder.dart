import 'dart:convert';
import 'dart:typed_data';

import '../../helpers/whitespace.dart';

class XsdByteDecoder extends Converter<String, int> {
  const XsdByteDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid xsd:byte lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Use Int8List to validate that the value fits within 8 bits (wraps on overflow).
    final list = Int8List(1);
    list[0] = value;

    if (list[0] != value) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:byte.",
      );
    }

    return value;
  }
}
