import 'dart:convert';
import 'dart:typed_data';

/// A [Converter] that converts an [int] to an XSD `unsignedByte` string.
class XsdUnsignedByteEncoder extends Converter<int, String> {
  const XsdUnsignedByteEncoder();

  @override
  String convert(int input) {
    // Use Uint8List to validate that the value fits within 8 bits (wraps on overflow).
    final list = Uint8List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException(
        "Value '$input' is out of range for xsd:unsignedByte.",
      );
    }
    return input.toString();
  }
}
