import 'dart:convert';

import 'int_decoder.dart';
import 'int_encoder.dart';

class XsdIntCodec extends Codec<int, String> {
  const XsdIntCodec();

  static final BigInt minIntInclusive = BigInt.parse('-2147483648');
  static final BigInt maxIntInclusive = BigInt.parse('2147483647');

  @override
  Converter<String, int> get decoder => const XsdIntDecoder();

  @override
  Converter<int, String> get encoder => const XsdIntEncoder();
}
