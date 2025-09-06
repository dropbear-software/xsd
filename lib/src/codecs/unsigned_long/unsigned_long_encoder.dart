import 'dart:convert';

class XsdUnsignedLongEncoder extends Converter<BigInt, String> {
  const XsdUnsignedLongEncoder();

  static final BigInt _minValue = BigInt.zero;
  static final BigInt _maxValue = BigInt.parse('18446744073709551615');

  @override
  String convert(BigInt input) {
    if (input < _minValue || input > _maxValue) {
      throw FormatException(
        'The value "$input" must be between $_minValue and $_maxValue.',
      );
    }

    return input.toString();
  }
}
