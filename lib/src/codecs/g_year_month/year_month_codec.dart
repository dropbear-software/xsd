import 'dart:convert';

import '../../year_month.dart';
import 'year_month_decoder.dart';
import 'year_month_encoder.dart';

/// A codec for XSD gYearMonth values.
///
/// Converts between [YearMonth] objects and their lexical string representation.
class YearMonthCodec extends Codec<YearMonth, String> {
  const YearMonthCodec();

  @override
  Converter<String, YearMonth> get decoder => const YearMonthDecoder();

  @override
  Converter<YearMonth, String> get encoder => const YearMonthEncoder();
}
