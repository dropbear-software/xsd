import 'dart:convert';

class XsdIntegerEncoder extends Converter<BigInt, String> {
  const XsdIntegerEncoder();

  @override
  String convert(BigInt input) => input.toString();
}
