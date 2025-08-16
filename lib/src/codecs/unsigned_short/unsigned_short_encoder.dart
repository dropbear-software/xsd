import 'dart:convert';

class XmlUnsignedShortEncoder extends Converter<int, String> {
  const XmlUnsignedShortEncoder();

  @override
  String convert(int input) {
    if (input < 0 || input > 65535) {
      throw FormatException(
          'The value "$input" must be between 0 and 65535.');
    }

    return input.toString();
  }
}
