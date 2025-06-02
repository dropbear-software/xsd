import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:normalizedString`.
///
/// Converts an XSD string lexical representation to a Dart String,
/// applying `whiteSpace="replace"` normalization.
class XsdNormalizedStringDecoder extends Converter<String, String> {
  const XsdNormalizedStringDecoder();

  @override
  String convert(String input) {
    // whiteSpace for xsd:normalizedString is 'replace'.
    final String processedInput = processWhiteSpace(input, Whitespace.replace);

    return processedInput;
  }
}
