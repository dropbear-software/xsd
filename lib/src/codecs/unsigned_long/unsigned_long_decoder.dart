import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdUnsignedLongDecoder extends Converter<String, BigInt> {
  const XsdUnsignedLongDecoder();

  static final BigInt _minValue = BigInt.zero;
  static final BigInt _maxValue = BigInt.parse('18446744073709551615');

  @override
  BigInt convert(String input) {
    final str = processWhiteSpace(input, Whitespace.collapse);

    if (str.isEmpty) {
      throw const FormatException('The input string cannot be empty.');
    }

    final value = BigInt.tryParse(str);

    if (value == null) {
      throw FormatException('The input "$str" is not a valid integer.');
    }

    if (value < _minValue || value > _maxValue) {
      throw FormatException(
        'The value "$value" must be between $_minValue and $_maxValue.',
      );
    }

    return value;
  }
}
