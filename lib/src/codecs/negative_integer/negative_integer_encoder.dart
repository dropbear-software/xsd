import 'dart:convert';

class XsdNegativeIntegerEncoder extends Converter<BigInt, String> {
  const XsdNegativeIntegerEncoder();

  static final BigInt _maxValue = BigInt.from(-1);

  @override
  String convert(BigInt input) {
    if (input > _maxValue) {
      throw FormatException(
        'The value "$input" must be less than or equal to $_maxValue.',
      );
    }

    return input.toString();
  }
}
