import 'dart:convert';

import 'byte_decoder.dart';
import 'byte_encoder.dart';

const xsdByteCodec = XsdByteCodec();

class XsdByteCodec extends Codec<int, String> {
  const XsdByteCodec();

  @override
  Converter<String, int> get decoder => const XsdByteDecoder();

  @override
  Converter<int, String> get encoder => const XsdByteEncoder();
}
