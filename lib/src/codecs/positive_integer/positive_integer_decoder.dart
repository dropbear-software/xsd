import 'dart:convert';

import '../../helpers/whitespace.dart';

class XmlPositiveIntegerDecoder extends Converter<String, BigInt> {
  const XmlPositiveIntegerDecoder();

  static final BigInt _minInclusiveValue = BigInt.one;

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

    if (value < _minInclusiveValue) {
      throw FormatException(
        'The value "$value" must be greater than or equal to $_minInclusiveValue.',
      );
    }

    return value;
  }
}
