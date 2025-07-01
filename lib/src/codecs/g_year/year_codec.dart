import 'dart:convert';

import '../../types/gregorian_year.dart';
import 'year_decoder.dart';
import 'year_encoder.dart';

/// A codec for converting between [GregorianYear] objects and their XSD gYear string representations.
class GregorianYearCodec extends Codec<GregorianYear, String> {
  const GregorianYearCodec();

  @override
  Converter<String, GregorianYear> get decoder => const GregorianYearDecoder();

  @override
  Converter<GregorianYear, String> get encoder => const GregorianYearEncoder();
}
