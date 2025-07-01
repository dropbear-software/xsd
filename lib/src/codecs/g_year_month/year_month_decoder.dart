import 'dart:convert';

import '../../year_month.dart';

/// Decodes a string in XSD gYearMonth format into a [YearMonth] object.
class YearMonthDecoder extends Converter<String, YearMonth> {
  const YearMonthDecoder();

  @override
  YearMonth convert(String input) {
    try {
      return YearMonth.parse(input);
    } on FormatException catch (e) {
      // Rethrow with a more specific message if desired, or just let it propagate.
      // For consistency with other decoders, we might want to ensure the
      // message clearly indicates it's an XSD gYearMonth decoding issue.
      throw FormatException('Invalid XSD gYearMonth: ${e.message}', e.source, e.offset);
    }
  }
}
