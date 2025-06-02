import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:NMTOKEN`.
///
/// Converts an XSD NMTOKEN lexical representation to a Dart String.
/// 1. Collapses whitespace.
/// 2. Validates against the NMTOKEN pattern (\c+).
class XsdNmtokenDecoder extends Converter<String, String> {
  const XsdNmtokenDecoder();

  // Pattern for \i (initial name characters for xsd:Name, part of \c)
  // According to XSD Part 2 Appendix F: \i ::= [:A-Z_a-z\p{L}\p{Nl}]
  // Note: Dart's \p{L} includes Lu, Ll, Lt, Lm, Lo. \p{Nl} is Number, letter.
  static const String _iChars = r':A-Z_a-z\p{L}\p{Nl}';

  // Pattern for \c (name characters for xsd:NMTOKEN)
  // According to XSD Part 2 Appendix F: \c ::= [\i\-.0-9\p{M}\p{Lm}\p{Sk}]
  // \p{M} is Mark, \p{Lm} is Letter, modifier, \p{Sk} is Symbol, modifier.
  static const String _cCharPattern =
      r'[' + _iChars + r'\-.0-9\p{M}\p{Lm}\p{Sk}]';

  // NMTOKEN pattern: one or more \c characters. Anchored.
  static final RegExp _nmtokenRegExp = RegExp(
    r'^(' + _cCharPattern + r')+$',
    unicode: true,
  );

  @override
  String convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      throw FormatException(
        "Invalid XSD NMTOKEN: input collapsed to an empty string. Original: '$input'",
      );
    }

    if (!_nmtokenRegExp.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD NMTOKEN lexical format: '$input' (collapsed to '$collapsedInput') does not match pattern /\\c+/",
      );
    }
    return collapsedInput;
  }
}
