import 'dart:convert';

import 'unsigned_short_decoder.dart';
import 'unsigned_short_encoder.dart';

class XsdUnsignedShortCodec extends Codec<int, String> {
  const XsdUnsignedShortCodec();

  @override
  Converter<String, int> get decoder => const XsdUnsignedShortDecoder();

  @override
  Converter<int, String> get encoder => const XsdUnsignedShortEncoder();
}
