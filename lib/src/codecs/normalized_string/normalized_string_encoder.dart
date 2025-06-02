import 'dart:convert';

/// Encoder for `xsd:normalizedString`.
///
/// The input Dart string is assumed to already conform to the value space
/// of normalizedString (i.e., no tabs, CR, LF).
/// The canonical representation is the value itself.
class XsdNormalizedStringEncoder extends Converter<String, String> {
  const XsdNormalizedStringEncoder();

  @override
  String convert(String input) {
    // TODO: Optionally, validate that the input string is indeed a valid normalizedString value space representation.
    // For now, assume valid input. Canonical form is the value.
    return input;
  }
}
