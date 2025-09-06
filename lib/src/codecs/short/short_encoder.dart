import 'dart:convert';

class XsdShortEncoder extends Converter<int, String> {
  const XsdShortEncoder();

  static const int _minValue = -32768;
  static const int _maxValue = 32767;

  @override
  String convert(int input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        "Value '$input' is out of range for xsd:short. Must be between $_minValue and $_maxValue.",
      );
    }
    return input.toString();
  }
}
