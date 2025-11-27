import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdIntegerDecoder extends Converter<String, BigInt> {
  const XsdIntegerDecoder();

  @override
  BigInt convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);

    if (trimmed.isEmpty) {
      throw const FormatException('The input string cannot be empty.');
    }

    return BigInt.parse(trimmed);
  }
}
