import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdLongDecoder extends Converter<String, int> {
  const XsdLongDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final int? value = int.tryParse(collapsedInput);
    if (value == null) {
      throw FormatException(
        "Invalid XSD long lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Since Dart's `int` is a 64-bit signed integer, `int.tryParse` will have
    // already handled the overflow for values outside the 64-bit range.
    // Therefore, no explicit min/max check is required here as it's implicitly
    // handled by the Dart runtime.

    return value;
  }
}
