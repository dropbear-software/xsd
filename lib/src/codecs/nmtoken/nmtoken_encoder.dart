import 'dart:convert';

/// Encoder for `xsd:NMTOKEN`.
///
/// Assumes the input Dart string is already a valid NMTOKEN.
/// The canonical representation is the value itself.
class XsdNmtokenEncoder extends Converter<String, String> {
  const XsdNmtokenEncoder();

  @override
  String convert(String input) {
    // Canonical form is the value itself.
    // Optionally, add validation here to ensure 'input' is a valid NMTOKEN value space representation.
    return input;
  }
}
