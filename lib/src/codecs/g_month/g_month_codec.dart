import 'dart:convert';

import '../../types/gregorian_month.dart';

/// A codec for converting between [GregorianMonth] objects and their XSD gMonth string representations.
class GregorianMonthCodec extends Codec<GregorianMonth, String> {
  const GregorianMonthCodec();

  @override
  Converter<String, GregorianMonth> get decoder =>
      const GregorianMonthDecoder();

  @override
  Converter<GregorianMonth, String> get encoder =>
      const GregorianMonthEncoder();
}

/// Converts an XSD gMonth string to a [GregorianMonth] object.
class GregorianMonthDecoder extends Converter<String, GregorianMonth> {
  const GregorianMonthDecoder();

  @override
  GregorianMonth convert(String input) {
    try {
      return GregorianMonth.parse(input);
    } on FormatException catch (e) {
      throw FormatException('Invalid gMonth format: "$input". ${e.message}', e.source, e.offset);
    }
  }
}

/// Converts a [GregorianMonth] object to its XSD gMonth string representation.
class GregorianMonthEncoder extends Converter<GregorianMonth, String> {
  const GregorianMonthEncoder();

  @override
  String convert(GregorianMonth input) {
    return input.toString();
  }
}
