import 'dart:convert';

import '../../types/gregorian_month_day.dart';

/// A converter that parses XSD gMonthDay strings into [GregorianMonthDay] objects.
class GregorianMonthDayDecoder extends Converter<String, GregorianMonthDay> {
  const GregorianMonthDayDecoder();

  @override
  GregorianMonthDay convert(String input) {
    return GregorianMonthDay.parse(input);
  }
}
