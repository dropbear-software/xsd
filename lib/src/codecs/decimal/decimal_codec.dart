import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:xsd/src/helpers/whitespace.dart';

/// A [Codec] that converts between XSD `decimal` strings and [Decimal] objects.
class XsdDecimalCodec extends Codec<Decimal, String> {
  const XsdDecimalCodec();

  @override
  Converter<Decimal, String> get encoder => const XsdDecimalEncoder();

  @override
  Converter<String, Decimal> get decoder => const XsdDecimalDecoder();
}

class XsdDecimalEncoder extends Converter<Decimal, String> {
  const XsdDecimalEncoder();

  @override
  String convert(Decimal input) => input.toString();
}

class XsdDecimalDecoder extends Converter<String, Decimal> {
  const XsdDecimalDecoder();

  static final _validationRegex = RegExp(
    r'^(\+|-)?([0-9]+(\.[0-9]*)?|\.[0-9]+)$',
  );

  @override
  Decimal convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);

    if (!_validationRegex.hasMatch(trimmed)) {
      throw FormatException('Invalid XSD decimal format', input);
    }

    return Decimal.parse(trimmed);
  }
}
