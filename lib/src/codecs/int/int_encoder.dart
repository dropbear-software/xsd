import 'dart:convert';

class XsdIntEncoder extends Converter<int, String> {
  const XsdIntEncoder();

  static const int _minValue = -2147483648;
  static const int _maxValue = 2147483647;

  @override
  String convert(int input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        "Value '$input' is out of range for xsd:int. Must be between $_minValue and $_maxValue.",
      );
    }
    return input.toString();
  }
}
