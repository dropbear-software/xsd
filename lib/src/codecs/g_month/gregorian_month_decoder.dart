import 'dart:convert';

import '../../types/gregorian_month.dart';

/// Converts an XSD gMonth string to a [GregorianMonth] object.
class GregorianMonthDecoder extends Converter<String, GregorianMonth> {
  const GregorianMonthDecoder();

  @override
  GregorianMonth convert(String input) {
    try {
      return GregorianMonth.parse(input);
    } on FormatException catch (e) {
      throw FormatException(
        'Invalid gMonth format: "$input". ${e.message}',
        e.source,
        e.offset,
      );
    }
  }
}
