import 'dart:convert';

import '../../helpers/whitespace.dart';

/// Encoder for `xsd:NMTOKEN`.
///
/// Validates that the input Dart String is a valid `NMTOKEN` and returns it.
/// A valid NMTOKEN must not contain any whitespace.
class XsdNmtokenEncoder extends Converter<String, String> {
  const XsdNmtokenEncoder();

  // Re-using the same robust regex from the decoder for consistency.
  static final RegExp _nmtokenRegExp = RegExp(
    r'^[A-Z_a-z:\.\p{L}\p{Nl}\p{Nd}\p{M}\p{Lm}\p{Sk}-]+$',
    unicode: true,
  );

  @override
  String convert(String input) {
    // Per the value space of NMTOKEN, the string cannot be empty and cannot
    // contain any whitespace characters. We don't collapse whitespace on encode,
    // we require the input to be in the correct form.
    if (input.isEmpty) {
      throw const FormatException(
        'Invalid xsd:NMTOKEN: The input string cannot be empty.',
      );
    }

    if (processWhiteSpace(input, Whitespace.collapse) != input) {
      throw FormatException(
        "Invalid xsd:NMTOKEN: The value '$input' cannot contain whitespace characters.",
      );
    }

    if (!_nmtokenRegExp.hasMatch(input)) {
      throw FormatException(
        "Invalid xsd:NMTOKEN lexical format: '$input' contains invalid characters.",
      );
    }

    return input;
  }
}
