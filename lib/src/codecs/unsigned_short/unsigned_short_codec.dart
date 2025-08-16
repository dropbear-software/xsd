import 'dart:convert';

import 'unsigned_short_decoder.dart';
import 'unsigned_short_encoder.dart';

class XmlUnsignedShortCodec extends Codec<int, String> {
  const XmlUnsignedShortCodec();

  @override
  Converter<String, int> get decoder => const XmlUnsignedShortDecoder();

  @override
  Converter<int, String> get encoder => const XmlUnsignedShortEncoder();
}
