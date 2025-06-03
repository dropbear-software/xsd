import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart' as package_convert;

class XsdHexbinaryEncoder extends Converter<Uint8List, String> {
  const XsdHexbinaryEncoder();

  @override
  String convert(Uint8List input) {
    if (input.isEmpty) {
      return '';
    }
    return package_convert.hex.encode(input).toUpperCase();
  }
}
