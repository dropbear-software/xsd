import 'dart:convert';

import 'boolean_decoder.dart';
import 'boolean_encoder.dart';

const xsdBooleanCodec = XsdBooleanCodec();

class XsdBooleanCodec extends Codec<bool, String> {
  const XsdBooleanCodec();

  @override
  Converter<String, bool> get decoder => const XsdBooleanDecoder();

  @override
  Converter<bool, String> get encoder => const XsdBooleanEncoder();
}
