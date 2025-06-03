import 'dart:convert' as dart_convert;
import 'dart:typed_data';

/// Encoder for `xsd:base64Binary`.
///
/// Converts a Uint8List to its XSD base64Binary canonical string representation.
class XsdBase64BinaryEncoder extends dart_convert.Converter<Uint8List, String> {
  const XsdBase64BinaryEncoder();

  @override
  String convert(Uint8List input) {
    // dart:convert.base64Encode produces the canonical form (no line breaks/whitespace)
    return dart_convert.base64Encode(input);
  }
}
