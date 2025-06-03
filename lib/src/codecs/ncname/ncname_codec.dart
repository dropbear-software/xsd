import 'dart:convert';

import 'ncname_decoder.dart';
import 'ncname_encoder.dart';

const xsdNcnameCodec = XsdNcnameCodec();

/// Codec for the XSD 'NCName' (Non-Colonized Name) datatype.
///
/// NCName represents XML "non-colonized" Names. It is derived from xsd:Name.
/// The lexical space matches the NCName production of "Namespaces in XML",
/// which is a Name that does not contain colons.
/// The XSD specification pattern is [\i-[:]][\c-[:]]*.
/// Whitespace is collapsed.
class XsdNcnameCodec extends Codec<String, String> {
  const XsdNcnameCodec();

  @override
  Converter<String, String> get decoder => const XsdNcnameDecoder();

  @override
  Converter<String, String> get encoder => const XsdNcnameEncoder();
}
