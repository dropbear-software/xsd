import 'dart:convert';

import 'long_decoder.dart';
import 'long_encoder.dart';

const xsdLongCodec = XsdLongCodec();

class XsdLongCodec extends Codec<int, String> {
  const XsdLongCodec();

  @override
  Converter<String, int> get decoder => const XsdLongDecoder();

  @override
  Converter<int, String> get encoder => const XsdLongEncoder();
}
