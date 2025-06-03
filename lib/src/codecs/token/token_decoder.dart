import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:token`.
///
/// Converts an XSD string lexical representation to a Dart String,
/// applying `whiteSpace="collapse"` normalization.
class XsdTokenDecoder extends Converter<String, String> {
  const XsdTokenDecoder();

  @override
  String convert(String input) {
    // whiteSpace for xsd:token is 'collapse'.
    final String processedInput = processWhiteSpace(input, Whitespace.collapse);

    return processedInput;
  }
}
