import 'dart:convert';

import '../../types/gregorian_day.dart';

/// A [Codec] that converts between [GregorianDay] objects and their XSD string representations.
class XsdGDayCodec extends Codec<GregorianDay, String> {
  const XsdGDayCodec();

  @override
  Converter<GregorianDay, String> get encoder => const XsdGDayEncoder();

  @override
  Converter<String, GregorianDay> get decoder => const XsdGDayDecoder();
}

/// Encoder for [XsdGDayCodec].
class XsdGDayEncoder extends Converter<GregorianDay, String> {
  const XsdGDayEncoder();

  @override
  String convert(GregorianDay input) {
    return input.toString();
  }
}

/// Decoder for [XsdGDayCodec].
class XsdGDayDecoder extends Converter<String, GregorianDay> {
  const XsdGDayDecoder();

  @override
  GregorianDay convert(String input) {
    return GregorianDay.parse(input);
  }
}
