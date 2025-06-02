import 'dart:convert';

import 'name_decoder.dart';
import 'name_encoder.dart';

const xsdNameCodec = XsdNameCodec();

/// Codec for the XSD 'Name' datatype.
///
/// Name represents XML Names. It is derived from xsd:token.
/// The lexical space matches the Name production of XML 1.0,
/// which is captured by the pattern \i\c*
/// where \i is the set of initial name characters and \c is the set of other name characters.
/// Whitespace is collapsed.
class XsdNameCodec extends Codec<String, String> {
  const XsdNameCodec();

  @override
  Converter<String, String> get decoder => const XsdNameDecoder();

  @override
  Converter<String, String> get encoder => const XsdNameEncoder();
}
