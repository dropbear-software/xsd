import 'dart:convert';

import '../../types/gregorian_year.dart';

/// Converts an XSD gYear string representation to a [GregorianYear] object.
class GregorianYearDecoder extends Converter<String, GregorianYear> {
  const GregorianYearDecoder();

  @override
  GregorianYear convert(String input) => GregorianYear.parse(input);
}
