import 'dart:convert';

class XsdShortEncoder extends Converter<int, String> {
  const XsdShortEncoder();

  @override
  String convert(int input) {
    if (input == 0) return "0";
    return input.toString();
  }
}
