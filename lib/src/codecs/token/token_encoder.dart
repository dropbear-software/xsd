import 'dart:convert';

/// Encoder for `xsd:token`.
///
/// The input Dart string is assumed to already conform to the value space
/// of token. The canonical representation is the value itself.
class XsdTokenEncoder extends Converter<String, String> {
  const XsdTokenEncoder();

  @override
  String convert(String input) {
    // TODO: Optionally, validate that the input string is indeed a valid token value space representation.
    // For now, assume valid input. Canonical form is the value.
    return input;
  }
}
