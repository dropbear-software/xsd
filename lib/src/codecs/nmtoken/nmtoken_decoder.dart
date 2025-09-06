import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:NMTOKEN`.
///
/// Converts an XSD NMTOKEN lexical representation to a Dart String.
/// 1. Collapses whitespace as per the `xsd:token` derivation.
/// 2. Validates that the result contains no spaces.
/// 3. Validates the result against the `Nmtoken` production from XML 1.0.
class XsdNmtokenDecoder extends Converter<String, String> {
  const XsdNmtokenDecoder();

  // This regex is built to match the `Nmtoken` production from XML 1.0,
  // which is defined as one or more `NameChar` characters.
  // The character classes are based on the definitions in Appendix F of the
  // W3C XML Schema Definition Language (XSD) 1.1 Part 2: Datatypes spec.
  //
  // To treat '-' and '.' as literals inside [], '-' is placed at the end,
  // and '.' is escaped.
  static final RegExp _nmtokenRegExp = RegExp(
    r'^[A-Z_a-z:\.\p{L}\p{Nl}\p{Nd}\p{M}\p{Lm}\p{Sk}-]+$',
    unicode: true,
  );

  @override
  String convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      throw FormatException(
        "Invalid xsd:NMTOKEN: input collapsed to an empty string. Original: '$input'",
      );
    }

    // Although the regex below would fail on a space, this check is faster
    // and provides a clearer error message. A valid NMTOKEN cannot contain spaces.
    if (collapsedInput.contains(' ')) {
      throw FormatException(
        "Invalid xsd:NMTOKEN: The value cannot contain spaces. Collapsed value: '$collapsedInput'",
      );
    }

    if (!_nmtokenRegExp.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid xsd:NMTOKEN lexical format: '$collapsedInput' contains invalid characters.",
      );
    }
    return collapsedInput;
  }
}
