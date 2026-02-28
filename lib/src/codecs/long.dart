import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:long` value space.
///
/// Value space: Integers in the range `[-9223372036854775808, 9223372036854775807]`.
extension type const XsdLong._(BigInt value) implements BigInt {
  /// The minimum value for an [XsdLong].
  static final BigInt min = BigInt.parse('-9223372036854775808');

  /// The maximum value for an [XsdLong].
  static final BigInt max = BigInt.parse('9223372036854775807');

  /// Validates and creates an [XsdLong].
  ///
  /// Throws an [ArgumentError] if the value is outside the range
  /// `[-9223372036854775808, 9223372036854775807]`.
  factory XsdLong(BigInt value) {
    if (value < min || value > max) {
      throw ArgumentError(
        'Value out of range for XsdLong: $value. '
        'Must be between $min and $max.',
      );
    }
    return XsdLong._(value);
  }

  /// Creates an [XsdLong] without validation.
  const XsdLong.unsafe(this.value);
}

/// Codec for `xsd:long`.
///
/// According to XSD 1.1:
/// - Value space: Integers in the range `[-9223372036854775808, 9223372036854775807]`.
/// - Base type: `xsd:integer`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdLongCodec extends XsdCodec<XsdLong> {
  /// Creates a new [XsdLongCodec].
  const XsdLongCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdLong, String> get encoder => const XsdLongEncoder();

  @override
  XsdConverter<String, XsdLong> get decoder => const XsdLongDecoder();
}

/// Encoder for `xsd:long`.
class XsdLongEncoder extends XsdConverter<XsdLong, String> {
  /// Creates a new [XsdLongEncoder].
  const XsdLongEncoder();

  @override
  String convert(XsdLong input) => input.toString();
}

/// Decoder for `xsd:long`.
class XsdLongDecoder extends XsdConverter<String, XsdLong> {
  /// Creates a new [XsdLongDecoder].
  const XsdLongDecoder();

  static final RegExp _pattern = RegExp(r'^[\-+]?[0-9]+$');

  @override
  XsdLong convert(String input) {
    if (!_pattern.hasMatch(input)) {
      throw XsdValidationException(
        'Invalid xsd:long lexical representation.',
        input: input,
        type: 'xsd:long',
      );
    }

    final value = BigInt.parse(input);

    if (value < XsdLong.min || value > XsdLong.max) {
      throw XsdValidationException(
        'Value out of range for xsd:long: $value',
        input: input,
        type: 'xsd:long',
      );
    }

    return XsdLong.unsafe(value);
  }
}
