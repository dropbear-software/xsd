import 'dart:convert';

import '../../types/xsd_datetime.dart';

/// A [Codec] that converts between [XsdDateTime] objects and their XSD string representations.
class XsdDateTimeCodec extends Codec<XsdDateTime, String> {
  const XsdDateTimeCodec();

  @override
  Converter<XsdDateTime, String> get encoder => const XsdDateTimeEncoder();

  @override
  Converter<String, XsdDateTime> get decoder => const XsdDateTimeDecoder();
}

/// Encoder for [XsdDateTimeCodec].
class XsdDateTimeEncoder extends Converter<XsdDateTime, String> {
  const XsdDateTimeEncoder();

  @override
  String convert(XsdDateTime input) {
    return input.toString();
  }
}

/// Decoder for [XsdDateTimeCodec].
class XsdDateTimeDecoder extends Converter<String, XsdDateTime> {
  const XsdDateTimeDecoder();

  @override
  XsdDateTime convert(String input) {
    return XsdDateTime.parse(input);
  }
}
