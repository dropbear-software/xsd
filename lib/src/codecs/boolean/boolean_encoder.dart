import 'dart:convert';

class XsdBooleanEncoder extends Converter<bool, String> {
  const XsdBooleanEncoder();

  @override
  String convert(bool input) {
    return input ? 'true' : 'false';
  }
}
