import 'dart:convert';
import 'dart:typed_data';

import 'hex_binary_decoder.dart';
import 'hex_binary_encoder.dart';

const xsdHexbinaryCodec = XsdHexbinaryCodec();

class XsdHexbinaryCodec extends Codec<Uint8List, String> {
  const XsdHexbinaryCodec();

  @override
  Converter<String, Uint8List> get decoder => const XsdHexbinaryDecoder();

  @override
  Converter<Uint8List, String> get encoder => const XsdHexbinaryEncoder();
}
