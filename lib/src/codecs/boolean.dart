import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Codec for `xsd:boolean`.
///
/// According to XSD 1.1:
/// - Lexical space: {true, false, 1, 0}
/// - Canonical space: {true, false}
/// - whiteSpace facet: collapse
class XsdBooleanCodec extends XsdCodec<bool> {
  /// Creates a new [XsdBooleanCodec].
  const XsdBooleanCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<bool, String> get encoder => const XsdBooleanEncoder();

  @override
  XsdConverter<String, bool> get decoder => const XsdBooleanDecoder();
}

/// Encoder for `xsd:boolean`.
class XsdBooleanEncoder extends XsdConverter<bool, String> {
  /// Creates a new [XsdBooleanEncoder].
  const XsdBooleanEncoder();

  @override
  String convert(bool input) => input ? 'true' : 'false';
}

/// Decoder for `xsd:boolean`.
class XsdBooleanDecoder extends XsdConverter<String, bool> {
  /// Creates a new [XsdBooleanDecoder].
  const XsdBooleanDecoder();

  @override
  bool convert(String input) {
    switch (input) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
      default:
        throw XsdValidationException(
          'Invalid boolean lexical representation.',
          input: input,
          type: 'xsd:boolean',
        );
    }
  }
}
