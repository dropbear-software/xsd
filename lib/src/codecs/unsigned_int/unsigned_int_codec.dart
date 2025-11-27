import 'dart:convert';

import 'package:xsd/src/codecs/unsigned_int/unsigned_int_decoder.dart';
import 'package:xsd/src/codecs/unsigned_int/unsigned_int_encoder.dart';

/// A codec for xsd:unsignedInt.
///
/// Converts between a string representation of an unsigned integer and an
/// [int].
class XsdUnsignedIntCodec extends Codec<int, String> {
  const XsdUnsignedIntCodec();

  @override
  Converter<String, int> get decoder => const XsdUnsignedIntDecoder();

  @override
  Converter<int, String> get encoder => const XsdUnsignedIntEncoder();
}
