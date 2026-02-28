import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [int] representing the `xsd:byte` value space.
///
/// Value space: Integers in the range `[-128, 127]`.
extension type const XsdByte._(int value) implements int {
  /// The minimum value for an `xsd:byte`, equal to -128.
  static const int min = -128;

  /// The maximum value for an `xsd:byte`, equal to 127.
  static const int max = 127;

  /// Validates and creates an [XsdByte].
  ///
  /// Throws a [RangeError] if the value is outside the range `[-128, 127]`.
  factory XsdByte(int value) {
    if (value < min || value > max) {
      throw RangeError.range(value, min, max, 'XsdByte');
    }
    return XsdByte._(value);
  }

  /// Creates an [XsdByte] without validation.
  const XsdByte.unsafe(this.value);
}

/// Codec for `xsd:byte`.
///
/// According to XSD 1.1:
/// - Value space: Integers in the range `[-128, 127]`.
/// - Base type: `xsd:short`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdByteCodec extends XsdCodec<XsdByte> {
  /// Creates a new [XsdByteCodec].
  const XsdByteCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdByte, String> get encoder => const XsdByteEncoder();

  @override
  XsdConverter<String, XsdByte> get decoder => const XsdByteDecoder();
}

/// Encoder for `xsd:byte`.
class XsdByteEncoder extends XsdConverter<XsdByte, String> {
  /// Creates a new [XsdByteEncoder].
  const XsdByteEncoder();

  @override
  String convert(XsdByte input) => input.toString();
}

/// Decoder for `xsd:byte`.
class XsdByteDecoder extends XsdConverter<String, XsdByte> {
  /// Creates a new [XsdByteDecoder].
  const XsdByteDecoder();

  static final RegExp _pattern = RegExp(r'^[\-+]?[0-9]+$');

  @override
  XsdByte convert(String input) {
    if (!_pattern.hasMatch(input)) {
      throw XsdValidationException(
        'Invalid xsd:byte lexical representation.',
        input: input,
        type: 'xsd:byte',
      );
    }

    final value = BigInt.parse(input);

    if (value < BigInt.from(XsdByte.min) || value > BigInt.from(XsdByte.max)) {
      throw XsdValidationException(
        'Value out of range for xsd:byte: $value',
        input: input,
        type: 'xsd:byte',
      );
    }
    return XsdByte.unsafe(value.toInt());
  }
}
