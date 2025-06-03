import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'byte_codec.dart';

class XsdByteDecoder extends Converter<String, int> {
  const XsdByteDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    final RegExp integerPattern = RegExp(r'^[\-\+]?[0-9]+$');
    if (!integerPattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD byte lexical format: '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD byte: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:byte
    if (bigIntValue < XsdByteCodec.minByteInclusive ||
        bigIntValue > XsdByteCodec.maxByteInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:byte. Must be between ${XsdByteCodec.minByteInclusive} and ${XsdByteCodec.maxByteInclusive}.",
      );
    }
    return bigIntValue.toInt();
  }
}
