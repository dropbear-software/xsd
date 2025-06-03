import 'dart:convert' as dart_convert;
import 'dart:typed_data';

import '../../helpers/whitespace.dart';

/// Decoder for `xsd:base64Binary`.
///
/// Converts an XSD base64Binary lexical string representation to a Uint8List.
/// 1. Collapses XML whitespace (XSD rule).
/// 2. Removes any remaining spaces from the collapsed string to form a pure Base64 sequence.
/// 3. Decodes using dart:convert's base64Decode.
class XsdBase64BinaryDecoder extends dart_convert.Converter<String, Uint8List> {
  const XsdBase64BinaryDecoder();

  // Regex to remove all spaces, used after initial whitespace collapse.
  static final RegExp _removeSpacesRegExp = RegExp(r'\s+');

  @override
  Uint8List convert(String input) {
    // Step 1: Apply XSD whitespace="collapse" rule.
    String processedString = processWhiteSpace(input, Whitespace.collapse);

    // Step 2: Remove ALL spaces from the collapsed string.
    // The XSD grammar allows for optional single spaces between Base64 characters
    // after collapse, but the dart:convert.base64Decode expects a pure Base64 string.
    processedString = processedString.replaceAll(_removeSpacesRegExp, '');

    if (processedString.isEmpty) {
      return Uint8List(0);
    }

    try {
      // Step 3: Decode using dart:convert's base64 decoder.
      // This will handle validation of Base64 characters, padding, and length.
      return dart_convert.base64Decode(processedString);
    } on FormatException catch (e) {
      throw FormatException(
        "Invalid XSD base64Binary: Error decoding '$processedString' (derived from input '$input'). Dart decoder error: ${e.message}",
      );
    }
  }
}
