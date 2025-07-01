import 'dart:convert';

import '../../types/year.dart';
import 'string_to_year_decoder.dart';
import 'year_to_string_encoder.dart';

/// A codec for converting between [Year] objects and their XSD gYear string representations.
class YearCodec extends Codec<Year, String> {
  const YearCodec();

  @override
  Converter<String, Year> get decoder => const StringToYearDecoder();

  @override
  Converter<Year, String> get encoder => const YearToStringEncoder();
}
