import 'dart:convert';

import 'package:intl/locale.dart';

/// Encoder for `xsd:language`.
///
/// Converts a Dart `Locale` object to its XSD language string representation.
class XsdLanguageEncoder extends Converter<Locale, String> {
  const XsdLanguageEncoder();

  @override
  String convert(Locale input) {
    return input.toLanguageTag();
  }
}
