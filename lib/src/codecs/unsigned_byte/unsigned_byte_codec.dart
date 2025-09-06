import 'dart:convert';

import 'unsigned_byte_decoder.dart';
import 'unsigned_byte_encoder.dart';

const xsdUnsignedByteCodec = XsdUnsignedByteCodec();

class XsdUnsignedByteCodec extends Codec<int, String> {
  const XsdUnsignedByteCodec();

  @override
  Converter<String, int> get decoder => const XsdUnsignedByteDecoder();

  @override
  Converter<int, String> get encoder => const XsdUnsignedByteEncoder();
}
