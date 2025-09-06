import 'dart:convert';

class XsdUnsignedLongEncoder extends Converter<BigInt, String> {
  const XsdUnsignedLongEncoder();

  static final BigInt _minValue = BigInt.zero;
  // Calculates the maximum value for an unsigned 64-bit integer (2^64 - 1) programmatically.
  static final BigInt _maxValue = (BigInt.one << 64) - BigInt.one;

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
