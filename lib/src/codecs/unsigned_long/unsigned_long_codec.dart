import 'dart:convert';

import 'unsigned_long_decoder.dart';
import 'unsigned_long_encoder.dart';

/// A codec for xsd:unsignedLong.
///
/// Converts between a string representation of an unsigned 64-bit integer
/// and a [BigInt].
class XsdUnsignedLongCodec extends Codec<BigInt, String> {
  const XsdUnsignedLongCodec();

  @override
  Converter<String, BigInt> get decoder => const XsdUnsignedLongDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdUnsignedLongEncoder();
}
