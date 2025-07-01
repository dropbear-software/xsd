import 'dart:convert';

import 'package:intl/locale.dart';
import '../../helpers/whitespace.dart';

/// Decoder for `xsd:language`.
///
/// Converts an XSD language lexical representation to a Dart `Locale` object.
/// 1. Collapses whitespace.
/// 2. Validates against the BCP 47 pattern for language tags via the Locale.parse method.
class XsdLanguageDecoder extends Converter<String, Locale> {
  const XsdLanguageDecoder();

  @override
  Locale convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      throw FormatException(
        "Invalid XSD language: input collapsed to an empty string. Original: '$input'",
      );
    }

    try {
      final parsedLocale = Locale.parse(collapsedInput);
      return parsedLocale;
    } catch (e) {
      throw FormatException(
        "Invalid XSD language lexical format: '$collapsedInput' does not match the required pattern.",
      );
    }
  }
}
