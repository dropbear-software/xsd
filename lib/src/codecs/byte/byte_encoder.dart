import 'dart:convert';
import 'dart:typed_data';

/// A [Converter] that converts an [int] to an XSD `byte` compatable string.
class XsdByteEncoder extends Converter<int, String> {
  const XsdByteEncoder();

  @override
  String convert(int input) {
    // Use Int8List to validate that the value fits within 8 bits (wraps on overflow).
    final list = Int8List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException("Value '$input' is out of range for xsd:byte.");
    }
    return input.toString();
  }
}
