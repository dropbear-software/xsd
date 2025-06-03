import 'dart:convert' as dart_convert;
import 'dart:typed_data';

import 'base64_binary_decoder.dart';
import 'base64_binary_encoder.dart';

const xsdBase64BinaryCodec = XsdBase64BinaryCodec();

/// Codec for the XSD 'base64Binary' datatype.
///
/// base64Binary represents Base64-encoded arbitrary binary data.
/// The Dart representation is Uint8List.
/// This implementation uses the base64 codec from 'dart:convert'.
class XsdBase64BinaryCodec extends dart_convert.Codec<Uint8List, String> {
  const XsdBase64BinaryCodec();

  @override
  dart_convert.Converter<String, Uint8List> get decoder =>
      const XsdBase64BinaryDecoder();

  @override
  dart_convert.Converter<Uint8List, String> get encoder =>
      const XsdBase64BinaryEncoder();
}
