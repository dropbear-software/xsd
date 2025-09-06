import 'dart:convert';

import 'long_decoder.dart';
import 'long_encoder.dart';

const xsdLongCodec = XsdLongCodec();

class XsdLongCodec extends Codec<BigInt, String> {
  const XsdLongCodec();

  @override
  Converter<String, BigInt> get decoder => const XsdLongDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdLongEncoder();
}
