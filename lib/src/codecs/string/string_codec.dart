import 'dart:convert';

import 'string_decoder.dart';
import 'string_encoder.dart';

const xsdStringCodec = XsdStringCodec();

/// Codec for the XSD 'string' datatype.
///
/// The `string` datatype represents character strings in XML.
/// Its lexical space allows any valid XML characters.
/// The default whitespace processing for `xsd:string` is `preserve`.
///
class XsdStringCodec extends Codec<String, String> {
  const XsdStringCodec();

  @override
  Converter<String, String> get decoder => const XsdStringDecoder();

  @override
  Converter<String, String> get encoder => const XsdStringEncoder();
}
