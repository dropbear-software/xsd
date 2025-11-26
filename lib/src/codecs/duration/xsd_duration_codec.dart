import 'dart:convert';

import '../../types/xsd_duration.dart';

/// A [Codec] that converts between [XsdDuration] objects and their XSD string representations.
class XsdDurationCodec extends Codec<XsdDuration, String> {
  const XsdDurationCodec();

  @override
  Converter<XsdDuration, String> get encoder => const XsdDurationEncoder();

  @override
  Converter<String, XsdDuration> get decoder => const XsdDurationDecoder();
}

/// Encoder for [XsdDurationCodec].
class XsdDurationEncoder extends Converter<XsdDuration, String> {
  const XsdDurationEncoder();

  @override
  String convert(XsdDuration input) {
    return input.toString();
  }
}

/// Decoder for [XsdDurationCodec].
class XsdDurationDecoder extends Converter<String, XsdDuration> {
  const XsdDurationDecoder();

  @override
  XsdDuration convert(String input) {
    return XsdDuration.parse(input);
  }
}
