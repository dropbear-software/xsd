import 'dart:convert';

import 'positive_integer_decoder.dart';
import 'positive_integer_encoder.dart';

/// A codec for xsd:positiveInteger.
///
/// Converts between a string representation of a positive integer and a
/// [BigInt].
class XmlPositiveIntegerCodec extends Codec<BigInt, String> {
  const XmlPositiveIntegerCodec();

  @override
  Converter<String, BigInt> get decoder => const XmlPositiveIntegerDecoder();

  @override
  Converter<BigInt, String> get encoder => const XmlPositiveIntegerEncoder();
}
