import 'dart:convert';

class XsdNonPositiveIntegerEncoder extends Converter<BigInt, String> {
  const XsdNonPositiveIntegerEncoder();

  static final BigInt _maxValue = BigInt.zero;

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
