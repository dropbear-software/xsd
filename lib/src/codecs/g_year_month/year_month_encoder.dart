import 'dart:convert';

import '../../types/year_month.dart';

/// Encodes a [YearMonth] object into its XSD gYearMonth string representation.
class YearMonthEncoder extends Converter<YearMonth, String> {
  const YearMonthEncoder();

  @override
  String convert(YearMonth input) {
    return input.toString();
  }
}
