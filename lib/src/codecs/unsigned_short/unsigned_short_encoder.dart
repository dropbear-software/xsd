import 'dart:convert';
import 'dart:typed_data';

class XsdUnsignedShortEncoder extends Converter<int, String> {
  const XsdUnsignedShortEncoder();

  @override
  String convert(int input) {
    // Use Uint16List to validate that the value fits within 16 bits (wraps on overflow).
    final list = Uint16List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException(
        'The value "$input" is out of range for xsd:unsignedShort.',
      );
    }

    return input.toString();
  }
}
