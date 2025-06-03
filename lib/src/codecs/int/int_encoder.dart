import 'dart:convert';

class XsdIntEncoder extends Converter<int, String> {
  const XsdIntEncoder();

  @override
  String convert(int input) {
    // Canonical representation for integer types
    if (input == 0) return "0";
    return input.toString();
  }
}
