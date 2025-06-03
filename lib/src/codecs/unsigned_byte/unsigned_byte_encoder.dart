import 'dart:convert';

class XsdUnsignedByteEncoder extends Converter<int, String> {
  const XsdUnsignedByteEncoder();

  @override
  String convert(int input) {
    // Canonical representation for integer types: no plus sign, no leading zeros (except for "0")
    if (input == 0) return "0";
    return input.toString();
  }
}
