import 'dart:convert';
import 'dart:typed_data';

import '../../helpers/whitespace.dart';

class XsdUnsignedShortDecoder extends Converter<String, int> {
  const XsdUnsignedShortDecoder();

  @override
  int convert(String input) {
    final str = processWhiteSpace(input, Whitespace.collapse);

    if (str.isEmpty) {
      throw const FormatException('The input string cannot be empty.');
    }

    final value = int.tryParse(str);

    if (value == null) {
      throw FormatException('The input "$str" is not a valid integer.');
    }

    // Use Uint16List to validate that the value fits within 16 bits (wraps on overflow).
    final list = Uint16List(1);
    list[0] = value;

    if (list[0] != value) {
      throw FormatException(
        'The value "$value" is out of range for xsd:unsignedShort.',
      );
    }

    return value;
  }
}
