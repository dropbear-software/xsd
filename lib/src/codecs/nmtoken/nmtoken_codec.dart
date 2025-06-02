import 'dart:convert';

import 'nmtoken_decoder.dart';
import 'nmtoken_encoder.dart';

const xsdNmtokenCodec = XsdNmtokenCodec();

/// Codec for the XSD 'NMTOKEN' datatype.
///
/// NMTOKEN represents the NMTOKEN attribute type from XML 1.0.
/// The value space of NMTOKEN is the set of tokens that match the Nmtoken production
/// in XML 1.0 (Second Edition), which is one or more NameChar characters.
/// It is derived from xsd:token, so whitespace is collapsed.
class XsdNmtokenCodec extends Codec<String, String> {
  const XsdNmtokenCodec();

  @override
  Converter<String, String> get decoder => const XsdNmtokenDecoder();

  @override
  Converter<String, String> get encoder => const XsdNmtokenEncoder();
}
