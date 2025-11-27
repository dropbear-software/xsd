import 'dart:convert';
import 'dart:typed_data';

/// A [Converter] that converts an [int] to an XSD `unsignedInt` string.
class XsdUnsignedIntEncoder extends Converter<int, String> {
  const XsdUnsignedIntEncoder();

  @override
  String convert(int input) {
    // Use Uint32List to validate that the value fits within 32 bits (wraps on overflow).
    final list = Uint32List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException(
        'The value "$input" is out of range for xsd:unsignedInt.',
      );
    }

    return input.toString();
  }
}
