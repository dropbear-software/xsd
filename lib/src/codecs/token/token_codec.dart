import 'dart:convert';

import 'token_decoder.dart';
import 'token_encoder.dart';

const xsdTokenCodec = XsdTokenCodec();

/// Codec for the XSD 'token' datatype.
///
/// `token` represents tokenized strings.
/// The value space has no carriage return (#xD), line feed (#xA), nor tab (#x9),
/// no leading or trailing spaces (#x20), and no internal sequences of two or more spaces.
/// Derived from `xsd:normalizedString` by applying `whiteSpace="collapse"`.
///
class XsdTokenCodec extends Codec<String, String> {
  const XsdTokenCodec();

  @override
  Converter<String, String> get decoder => const XsdTokenDecoder();

  @override
  Converter<String, String> get encoder => const XsdTokenEncoder();
}
