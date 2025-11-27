import 'dart:convert';

import '../../types/xsd_time.dart';

/// A [Codec] that converts between [XsdTime] objects and their XSD string representations.
class XsdTimeCodec extends Codec<XsdTime, String> {
  const XsdTimeCodec();

  @override
  Converter<XsdTime, String> get encoder => const XsdTimeEncoder();

  @override
  Converter<String, XsdTime> get decoder => const XsdTimeDecoder();
}

/// Encoder for [XsdTimeCodec].
class XsdTimeEncoder extends Converter<XsdTime, String> {
  const XsdTimeEncoder();

  @override
  String convert(XsdTime input) {
    return input.toString();
  }
}

/// Decoder for [XsdTimeCodec].
class XsdTimeDecoder extends Converter<String, XsdTime> {
  const XsdTimeDecoder();

  @override
  XsdTime convert(String input) {
    return XsdTime.parse(input);
  }
}
