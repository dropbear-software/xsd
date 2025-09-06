import 'dart:convert';

class XsdLongEncoder extends Converter<int, String> {
  const XsdLongEncoder();

  @override
  String convert(int input) {
    // Dart's `int` is a 64-bit signed integer, which is the exact definition of
    // xsd:long. Therefore, any `int` value is valid and no range checking is
    // required.
    return input.toString();
  }
}
