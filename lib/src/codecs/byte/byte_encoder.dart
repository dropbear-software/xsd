import 'dart:convert';

class XsdByteEncoder extends Converter<int, String> {
  const XsdByteEncoder();

  static const int _minValue = -128;
  static const int _maxValue = 127;

  @override
  String convert(int input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        "Value '$input' is out of range for xsd:byte. Must be between $_minValue and $_maxValue.",
      );
    }
    return input.toString();
  }
}
