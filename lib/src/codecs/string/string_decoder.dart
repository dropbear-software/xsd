import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:string`.
///
/// Converts an XSD string lexical representation to a Dart String.
/// Applies `whiteSpace="preserve"` facet by default.
class XsdStringDecoder extends Converter<String, String> {
  const XsdStringDecoder();

  @override
  String convert(String input) {
    final String processedInput = processWhiteSpace(input, Whitespace.preserve);

    return processedInput;
  }
}
