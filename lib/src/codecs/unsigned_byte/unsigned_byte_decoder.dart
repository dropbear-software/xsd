import 'dart:convert';

import '../../helpers/whitespace.dart';
import 'unsigned_byte_codec.dart';

class XsdUnsignedByteDecoder extends Converter<String, int> {
  const XsdUnsignedByteDecoder();

  @override
  int convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    // XSD unsignedByte lexical representation: "finite-length sequence of decimal digits (#x30-#x39)"
    // No sign allowed.
    final RegExp unsignedBytePattern = RegExp(r'^[0-9]+$');
    if (!unsignedBytePattern.hasMatch(collapsedInput)) {
      throw FormatException(
        "Invalid XSD unsignedByte lexical format (must be digits only, no sign): '$input' (collapsed to '$collapsedInput')",
      );
    }

    final BigInt? bigIntValue = BigInt.tryParse(collapsedInput);
    if (bigIntValue == null) {
      throw FormatException(
        "Failed to parse XSD unsignedByte: '$input' (collapsed to '$collapsedInput')",
      );
    }

    // Check bounds for xsd:unsignedByte
    if (bigIntValue < XsdUnsignedByteCodec.minUnsignedByteInclusive ||
        bigIntValue > XsdUnsignedByteCodec.maxUnsignedByteInclusive) {
      throw FormatException(
        "Value '$collapsedInput' is out of range for xsd:unsignedByte. Must be between ${XsdUnsignedByteCodec.minUnsignedByteInclusive} and ${XsdUnsignedByteCodec.maxUnsignedByteInclusive}.",
      );
    }
    return bigIntValue.toInt();
  }
}
