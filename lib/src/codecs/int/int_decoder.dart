import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'int_codec.dart';

class XsdIntDecoder extends Converter<String, int> {
  const XsdIntDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final RegExp integerPattern = RegExp(r'^[\-\+]?[0-9]+$');
    if (!integerPattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD int lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD int: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:int
    if (bigIntValue < XsdIntCodec.minIntInclusive ||
        bigIntValue > XsdIntCodec.maxIntInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:int. Must be between ${XsdIntCodec.minIntInclusive} and ${XsdIntCodec.maxIntInclusive}.",
      );
    }

    // BigInt.toInt() will throw if it doesn't fit, but our bounds check should catch it first.
    return bigIntValue.toInt();
  }
}
