import 'dart:convert';

import '../../types/year.dart';

/// Converts a [Year] object to its XSD gYear string representation.
class YearToStringEncoder extends Converter<Year, String> {
  const YearToStringEncoder();

  @override
  String convert(Year input) => input.toString();
}
