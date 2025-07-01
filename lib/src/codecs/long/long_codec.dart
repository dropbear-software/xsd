import 'dart:convert';

import 'long_decoder.dart';
import 'long_encoder.dart';

const xsdLongCodec = XsdLongCodec();

class XsdLongCodec extends Codec<BigInt, String> {
  const XsdLongCodec();

  static final BigInt minInclusive = BigInt.parse('-9223372036854775808');
  static final BigInt maxInclusive = BigInt.parse('9223372036854775807');

  @override
  Converter<String, BigInt> get decoder => const XsdLongDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdLongEncoder();
}
