import 'dart:convert';

class XsdByteEncoder extends Converter<int, String> {
  const XsdByteEncoder();

  @override
  String convert(int input) {
    if (input == 0) return "0";
    return input.toString();
  }
}
