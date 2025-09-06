import 'dart:convert';

import 'int_decoder.dart';
import 'int_encoder.dart';

const xsdIntCodec = XsdIntCodec();

class XsdIntCodec extends Codec<int, String> {
  const XsdIntCodec();

  @override
  Converter<String, int> get decoder => const XsdIntDecoder();

  @override
  Converter<int, String> get encoder => const XsdIntEncoder();
}
