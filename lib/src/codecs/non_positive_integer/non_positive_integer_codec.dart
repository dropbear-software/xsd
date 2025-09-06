import 'dart:convert';

import 'package:xsd/src/codecs/non_positive_integer/non_positive_integer_decoder.dart';
import 'package:xsd/src/codecs/non_positive_integer/non_positive_integer_encoder.dart';

/// A codec for xsd:nonPositiveInteger.
///
/// Converts between a string representation of a non-positive integer and a
/// [BigInt].
class XsdNonPositiveIntegerCodec extends Codec<BigInt, String> {
  const XsdNonPositiveIntegerCodec();

  @override
  Converter<String, BigInt> get decoder => const XsdNonPositiveIntegerDecoder();

  @override
  Converter<BigInt, String> get encoder => const XsdNonPositiveIntegerEncoder();
}
