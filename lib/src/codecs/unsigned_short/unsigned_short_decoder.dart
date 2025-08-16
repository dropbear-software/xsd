import 'dart:convert';

import '../../helpers/whitespace.dart';

class XmlUnsignedShortDecoder extends Converter<String, int> {
  const XmlUnsignedShortDecoder();

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

    if (value < 0 || value > 65535) {
      throw FormatException(
          'The value "$value" must be between 0 and 65535.');
    }

    return value;
  }
}
