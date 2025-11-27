import 'dart:convert';
import 'dart:typed_data';

/// A [Converter] that converts an [int] to an XSD `short` string.
class XsdShortEncoder extends Converter<int, String> {
  const XsdShortEncoder();

  @override
  String convert(int input) {
    // Use Int16List to validate that the value fits within 16 bits (wraps on overflow).
    final list = Int16List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException(
        'The value "$input" is out of range for xsd:short.',
      );
    }

    return input.toString();
  }
}
