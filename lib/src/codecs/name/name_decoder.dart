import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:Name`.
///
/// Converts an XSD Name lexical representation to a Dart String.
/// 1. Collapses whitespace.
/// 2. Validates against the Name pattern (\i\c*).
class XsdNameDecoder extends Converter<String, String> {
  const XsdNameDecoder();

  // Defines the characters that can start an XML Name (\i).
  // Content for the character class: [:A-Z_a-z\p{L}\p{Nl}]
  static const String _iClassContent = r':A-Z_a-z\p{L}\p{Nl}';

  // Defines the characters that can appear in an XML Name after the first char (\c).
  // Content for the character class: [\i\-.0-9\p{M}\p{Lm}\p{Sk}]
  // This includes all characters from \i, plus hyphen, period, digits, and specific Unicode marks/letters/symbols.
  static const String _cClassContent =
      _iClassContent + r'\-.0-9\p{M}\p{Lm}\p{Sk}';

  // Name pattern: ^(\i)(\c*)$
  // The first capturing group ([' + _iClassContent + r']) matches one \i character.
  // The second capturing group ([' + _cClassContent + r']*) matches zero or more \c characters.
  static final RegExp _nameRegExp = RegExp(
    r'^([' + _iClassContent + r'])([' + _cClassContent + r']*)' + r'$',
    unicode: true,
  );

  @override
  String convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      throw FormatException(
        "Invalid XSD Name: input collapsed to an empty string. Original: '$input'",
      );
    }

    if (!_nameRegExp.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD Name lexical format: '$input' (collapsed to '$collapsedInput') does not match pattern /\\i\\c*/. Regex: ${_nameRegExp.pattern}",
      );
    }
    return collapsedInput;
  }
}
