import 'dart:convert';

import 'short_decoder.dart';
import 'short_encoder.dart';

const xsdShortCodec = XsdShortCodec();

class XsdShortCodec extends Codec<int, String> {
  const XsdShortCodec();

  static final BigInt minShortInclusive = BigInt.parse('-32768');
  static final BigInt maxShortInclusive = BigInt.parse('32767');

  @override
  Converter<String, int> get decoder => const XsdShortDecoder();

  @override
  Converter<int, String> get encoder => const XsdShortEncoder();
}
