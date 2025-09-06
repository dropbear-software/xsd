import 'dart:convert';

class XmlPositiveIntegerEncoder extends Converter<BigInt, String> {
  const XmlPositiveIntegerEncoder();

  static final BigInt _minInclusiveValue = BigInt.one;

  @override
  String convert(BigInt input) {
    if (input < _minInclusiveValue) {
      throw FormatException(
        'The value "$input" must be greater than or equal to $_minInclusiveValue.',
      );
    }

    return input.toString();
  }
}
