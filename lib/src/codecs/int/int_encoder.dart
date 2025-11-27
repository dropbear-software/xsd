import 'dart:convert';
import 'dart:typed_data';

class XsdIntEncoder extends Converter<int, String> {
  const XsdIntEncoder();

  @override
  String convert(int input) {
    // Use Int32List to validate that the value fits within 32 bits (wraps on overflow).
    final list = Int32List(1);
    list[0] = input;
    if (list[0] != input) {
      throw FormatException("Value '$input' is out of range for xsd:int.");
    }
    return input.toString();
  }
}
