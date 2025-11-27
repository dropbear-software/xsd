import 'dart:convert';

import '../../helpers/whitespace.dart';
import '../../types/xsd_date.dart';

/// A [Codec] that converts between [XsdDate] objects and their XSD string representations.
class XsdDateCodec extends Codec<XsdDate, String> {
  const XsdDateCodec();

  @override
  Converter<XsdDate, String> get encoder => const XsdDateEncoder();

  @override
  Converter<String, XsdDate> get decoder => const XsdDateDecoder();
}

/// Encoder for [XsdDateCodec].
class XsdDateEncoder extends Converter<XsdDate, String> {
  const XsdDateEncoder();

  @override
  String convert(XsdDate input) {
    return input.toString();
  }
}

/// Decoder for [XsdDateCodec].
class XsdDateDecoder extends Converter<String, XsdDate> {
  const XsdDateDecoder();

  @override
  XsdDate convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);

    if (trimmed.isEmpty) {
      throw const FormatException('The input string cannot be empty.');
    }

    return XsdDate.parse(trimmed);
  }
}
