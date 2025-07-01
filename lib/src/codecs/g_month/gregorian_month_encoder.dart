import 'dart:convert';

import '../../types/gregorian_month.dart';

/// Converts a [GregorianMonth] object to its XSD gMonth string representation.
class GregorianMonthEncoder extends Converter<GregorianMonth, String> {
  const GregorianMonthEncoder();

  @override
  String convert(GregorianMonth input) {
    return input.toString();
  }
}
