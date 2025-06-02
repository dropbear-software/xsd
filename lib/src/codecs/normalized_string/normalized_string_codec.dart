import 'dart:convert';

import 'normalized_string_decoder.dart';
import 'normalized_string_encoder.dart';

const xsdNormalizedStringCodec = XsdNormalizedStringCodec();

/// Codec for the XSD 'normalizedString' datatype.
///
/// `normalizedString` represents white space normalized strings.
/// The lexical and value space do not contain carriage return (#xD),
/// line feed (#xA), nor tab (#x9) characters.
/// Derived from `xsd:string` by applying `whiteSpace="replace"`.
///
class XsdNormalizedStringCodec extends Codec<String, String> {
  const XsdNormalizedStringCodec();

  @override
  Converter<String, String> get decoder => const XsdNormalizedStringDecoder();

  @override
  Converter<String, String> get encoder => const XsdNormalizedStringEncoder();
}
