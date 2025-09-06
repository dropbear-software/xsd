import 'dart:convert';

class XsdUnsignedByteEncoder extends Converter<int, String> {
  const XsdUnsignedByteEncoder();

  static const int _minValue = 0;
  static const int _maxValue = 255;

  @override
  String convert(int input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        "Value '$input' is out of range for xsd:unsignedByte. Must be between $_minValue and $_maxValue.",
      );
    }
    return input.toString();
  }
}
