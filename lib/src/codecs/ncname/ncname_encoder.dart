import 'dart:convert';

/// Encoder for `xsd:NCName`.
///
/// Assumes the input Dart string is already a valid NCName.
/// The canonical representation is the value itself.
class XsdNcnameEncoder extends Converter<String, String> {
  const XsdNcnameEncoder();

  @override
  String convert(String input) {
    // Canonical form is the value itself.
    // Consider adding validation that input does not contain ':'
    return input;
  }
}
