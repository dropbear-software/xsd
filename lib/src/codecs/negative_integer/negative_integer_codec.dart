import 'dart:convert';

import 'package:xsd/src/codecs/negative_integer/negative_integer_decoder.dart';
import 'package:xsd/src/codecs/negative_integer/negative_integer_encoder.dart';

/// A codec for xsd:negativeInteger.
///
/// Converts between a string representation of a negative integer and a
/// [BigInt].
class XsdNegativeIntegerCodec extends Codec<BigInt, String> {
  const XsdNegativeIntegerCodec();

  @override
  Converter<String, BigInt> get decoder => const XsdNegativeIntegerDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdNegativeIntegerEncoder();
}
