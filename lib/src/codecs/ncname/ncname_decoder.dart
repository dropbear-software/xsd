import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:NCName`.
///
/// Converts an XSD NCName lexical representation to a Dart String.
/// 1. Collapses whitespace.
/// 2. Validates against the NCName pattern (an Name that does not contain colons).
class XsdNcnameDecoder extends Converter<String, String> {
  const XsdNcnameDecoder();

  // Content for the initial character class for NCName (\i without ':').
  // Original \i: [:A-Z_a-z\p{L}\p{Nl}]
  static const String _iNcClassContent =
      r'A-Z_a-z\p{L}\p{Nl}_'; // Colon removed

  // Content for the subsequent character class for NCName (\c without ':').
  // Original \c included \i. So we use _iNcClassContent here.
  static const String _cNcClassContent =
      _iNcClassContent +
      r'\-.0-9\p{M}\p{Lm}\p{Sk}'; // Colon implicitly excluded

  // NCName pattern: ^([\i-[:]])([\c-[:]]*)$
  // First group is one char from _iNcClassContent.
  // Second group is zero or more chars from _cNcClassContent.
  static final RegExp _ncNameRegExp = RegExp(
    r'^([' + _iNcClassContent + r'])([' + _cNcClassContent + r']*)' + r'$',
    unicode: true,
  );

  @override
  String convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      throw FormatException(
        "Invalid XSD NCName: input collapsed to an empty string. Original: '$input'",
      );
    }

    // Although the regex is designed to not match colons, an explicit check
    // after ensuring it's generally well-formed (or instead of a complex regex)
    // can sometimes be clearer or a good safeguard.
    // However, the XSD spec uses a pattern facet for this, so a regex is the direct interpretation.
    // The constructed _ncNameRegExp should inherently prevent colons.

    if (!_ncNameRegExp.hasMatch(collapsedInput)) {
      // Check if it would have been a valid Name but contained a colon
      // This helps make error messages more specific.
      // For simplicity here, we rely on the _ncNameRegExp.
      // A more robust error might try matching Name and then check for colon.
      throw FormatException(
        "Invalid XSD NCName lexical format: '$input' (collapsed to '$collapsedInput'). Must be a valid XML Name without colons. Pattern: ${_ncNameRegExp.pattern}",
      );
    }
    // An additional belt-and-suspenders check, though the regex should cover it.
    if (collapsedInput.contains(':')) {
      throw FormatException(
        "Invalid XSD NCName: '$collapsedInput' contains a colon, which is not allowed.",
      );
    }

    return collapsedInput;
  }
}
