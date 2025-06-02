import 'dart:convert';

/// Encoder for `xsd:Name`.
///
/// Assumes the input Dart string is already a valid Name.
/// The canonical representation is the value itself.
class XsdNameEncoder extends Converter<String, String> {
  const XsdNameEncoder();

  @override
  String convert(String input) {
    // Canonical form is the value itself.
    return input;
  }
}
