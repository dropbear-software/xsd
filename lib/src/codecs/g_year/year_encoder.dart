import 'dart:convert';

import '../../types/gregorian_year.dart';

/// Converts a [GregorianYear] object to its XSD gYear string representation.
class GregorianYearEncoder extends Converter<GregorianYear, String> {
  const GregorianYearEncoder();

  @override
  String convert(GregorianYear input) => input.toString();
}
