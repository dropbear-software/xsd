import 'dart:convert';

import 'package:xsd/src/codecs/integer/integer_decoder.dart';
import 'package:xsd/src/codecs/integer/integer_encoder.dart';

/// A [Codec] that converts between XSD `integer` strings and [BigInt] objects.
class XsdIntegerCodec extends Codec<BigInt, String> {
  const XsdIntegerCodec();

  @override
  Converter<BigInt, String> get encoder => const XsdIntegerEncoder();

  @override
  Converter<String, BigInt> get decoder => const XsdIntegerDecoder();
}
