import 'dart:convert';

import '../../types/gregorian_month.dart';
import 'gregorian_month_decoder.dart';
import 'gregorian_month_encoder.dart';

/// A codec for converting between [GregorianMonth] objects and their XSD gMonth string representations.
class GregorianMonthCodec extends Codec<GregorianMonth, String> {
  const GregorianMonthCodec();

  @override
  Converter<String, GregorianMonth> get decoder =>
      const GregorianMonthDecoder();

  @override
  Converter<GregorianMonth, String> get encoder =>
      const GregorianMonthEncoder();
}
