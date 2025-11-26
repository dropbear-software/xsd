import 'dart:convert';

import '../../types/gregorian_month_day.dart';

/// A converter that converts [GregorianMonthDay] objects to their XSD gMonthDay string representation.
class GregorianMonthDayEncoder extends Converter<GregorianMonthDay, String> {
  const GregorianMonthDayEncoder();

  @override
  String convert(GregorianMonthDay input) {
    return input.toString();
  }
}
