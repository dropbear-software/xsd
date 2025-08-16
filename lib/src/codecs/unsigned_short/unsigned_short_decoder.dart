import 'dart:convert';

import '../../helpers/whitespace.dart';

class XmlUnsignedShortDecoder extends Converter<String, int> {
  const XmlUnsignedShortDecoder();

  static const int _minValue = 0;
  static const int _maxValue = 65535;

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

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
          'The value "$value" must be between $_minValue and $_maxValue.');
    }

    return value;
  }
}