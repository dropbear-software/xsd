import 'dart:convert';

import 'package:xsd/src/helpers/whitespace.dart';

/// A [Codec] that converts between XSD `anyURI` strings and [Uri] objects.
class XsdAnyUriCodec extends Codec<Uri, String> {
  const XsdAnyUriCodec();

  @override
  Converter<Uri, String> get encoder => const XsdAnyUriEncoder();

  @override
  Converter<String, Uri> get decoder => const XsdAnyUriDecoder();
}

class XsdAnyUriEncoder extends Converter<Uri, String> {
  const XsdAnyUriEncoder();

  @override
  String convert(Uri input) => input.toString();
}

class XsdAnyUriDecoder extends Converter<String, Uri> {
  const XsdAnyUriDecoder();

  @override
  Uri convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);
    return Uri.parse(trimmed);
  }
}
