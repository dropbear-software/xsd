import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdNegativeIntegerDecoder extends Converter<String, BigInt> {
  const XsdNegativeIntegerDecoder();

  static final BigInt _maxValue = BigInt.from(-1);

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

    if (value > _maxValue) {
      throw FormatException(
        'The value "$value" must be less than or equal to $_maxValue.',
      );
    }

    return value;
  }
}
