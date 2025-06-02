import 'dart:convert';

/// Encoder for `xsd:string`.
///
/// Converts a Dart String to its XSD string lexical representation.
/// For `xsd:string` with `whiteSpace="preserve"`, this is an identity transformation
/// as the Dart string is assumed to be the desired value.
class XsdStringEncoder extends Converter<String, String> {
  const XsdStringEncoder();

  @override
  String convert(String input) {
    // Canonical representation is the value itself after whitespace facet application.
    // For preserve, the value is not changed.
    return input;
  }
}
