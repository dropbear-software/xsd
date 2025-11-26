import 'dart:convert';

import '../../types/gregorian_month_day.dart';
import 'gregorian_month_day_decoder.dart';
import 'gregorian_month_day_encoder.dart';

/// A codec for converting between [GregorianMonthDay] objects and their XSD gMonthDay string representations.
class GregorianMonthDayCodec extends Codec<GregorianMonthDay, String> {
  const GregorianMonthDayCodec();

  @override
  Converter<String, GregorianMonthDay> get decoder =>
      const GregorianMonthDayDecoder();

  @override
  Converter<GregorianMonthDay, String> get encoder =>
      const GregorianMonthDayEncoder();
}
