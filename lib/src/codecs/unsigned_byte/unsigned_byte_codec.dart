import 'dart:convert';

import 'unsigned_byte_decoder.dart';
import 'unsigned_byte_encoder.dart';

const xsdUnsignedByteCodec = XsdUnsignedByteCodec();

class XsdUnsignedByteCodec extends Codec<int, String> {
  const XsdUnsignedByteCodec();

  static final BigInt minUnsignedByteInclusive = BigInt.zero;
  static final BigInt maxUnsignedByteInclusive = BigInt.from(255);

  @override
  Converter<String, int> get decoder => const XsdUnsignedByteDecoder();

  @override
  Converter<int, String> get encoder => const XsdUnsignedByteEncoder();
}
