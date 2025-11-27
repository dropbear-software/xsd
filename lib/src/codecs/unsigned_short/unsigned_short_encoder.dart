import 'dart:convert';

class XsdUnsignedShortEncoder extends Converter<int, String> {
  const XsdUnsignedShortEncoder();

  static const int _minValue = 0;
  static const int _maxValue = 65535;

  @override
  String convert(int input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        'The value "$input" must be between $_minValue and $_maxValue.',
      );
    }

    return input.toString();
  }
}
