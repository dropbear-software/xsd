import 'dart:convert' as dart_convert;
import 'dart:typed_data';

import 'package:convert/convert.dart' as package_convert;

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:hexBinary`.
///
/// Converts an XSD hexBinary lexical string representation to a Uint8List,
/// using package:convert's HexDecoder.
/// 1. Collapses whitespace (XSD rule).
/// 2. Decodes using package:convert's hex decoder.
class XsdHexbinaryDecoder extends dart_convert.Converter<String, Uint8List> {
  const XsdHexbinaryDecoder();

  @override
  Uint8List convert(String input) {
    final String collapsedInput = processWhiteSpace(input, Whitespace.collapse);

    if (collapsedInput.isEmpty) {
      // The hex.decode in package:convert might handle this,
      // but XSD spec implies empty lexical form is valid for an empty octet sequence.
      return Uint8List(0);
    }

    try {
      return Uint8List.fromList(package_convert.hex.decode(collapsedInput));
    } on FormatException catch (e) {
      // Re-throw with a more XSD-specific context if desired.
      throw FormatException(
        "Invalid XSD hexBinary lexical format for '$input' (collapsed to '$collapsedInput'). Error from hex decoder: ${e.message}",
      );
    }
  }
}
