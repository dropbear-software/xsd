import 'dart:convert';

import '../../types/year.dart';

/// Converts an XSD gYear string representation to a [Year] object.
class StringToYearDecoder extends Converter<String, Year> {
  const StringToYearDecoder();

  @override
  Year convert(String input) => Year.parse(input);
}
