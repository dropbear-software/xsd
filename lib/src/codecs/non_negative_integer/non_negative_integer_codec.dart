import 'dart:convert';

import 'non_negative_integer_decoder.dart';
import 'non_negative_integer_encoder.dart';

const xsdNonNegativeIntegerCodec = XsdNonNegativeIntegerCodec();

class XsdNonNegativeIntegerCodec extends Codec<BigInt, String> {
  const XsdNonNegativeIntegerCodec();

  static final BigInt minInclusive = BigInt.zero;

  @override
  Converter<String, BigInt> get decoder => const XsdNonNegativeIntegerDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdNonNegativeIntegerEncoder();
}
