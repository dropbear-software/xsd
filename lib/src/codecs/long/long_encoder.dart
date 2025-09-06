import 'dart:convert';

class XsdLongEncoder extends Converter<BigInt, String> {
  const XsdLongEncoder();

  static final BigInt _minValue = BigInt.parse('-9223372036854775808');
  static final BigInt _maxValue = BigInt.parse('9223372036854775807');

  @override
  String convert(BigInt input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        "Value '$input' is out of range for xsd:long. Must be between $_minValue and $_maxValue.",
      );
    }
    return input.toString();
  }
}
