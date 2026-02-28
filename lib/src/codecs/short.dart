import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [int] representing the `xsd:short` value space.
///
/// Value space: Integers in the range `[-32768, 32767]`.
extension type const XsdShort._(int value) implements int {
  /// The minimum value for an `xsd:short`, equal to -2^15.
  static const int min = -32768;

  /// The maximum value for an `xsd:short`, equal to 2^15 - 1.
  static const int max = 32767;

  /// Validates and creates an [XsdShort].
  ///
  /// Throws a [RangeError] if the value is outside the range `[-32768, 32767]`.
  factory XsdShort(int value) {
    if (value < min || value > max) {
      throw RangeError.range(value, min, max, 'XsdShort');
    }
    return XsdShort._(value);
  }

  /// Creates an [XsdShort] without validation.
  const XsdShort.unsafe(this.value);
}

/// Codec for `xsd:short`.
///
/// According to XSD 1.1:
/// - Value space: Integers in the range `[-32768, 32767]`.
/// - Base type: `xsd:int`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdShortCodec extends XsdCodec<XsdShort> {
  /// Creates a new [XsdShortCodec].
  const XsdShortCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdShort, String> get encoder => const XsdShortEncoder();

  @override
  XsdConverter<String, XsdShort> get decoder => const XsdShortDecoder();
}

/// Encoder for `xsd:short`.
class XsdShortEncoder extends XsdConverter<XsdShort, String> {
  /// Creates a new [XsdShortEncoder].
  const XsdShortEncoder();

  @override
  String convert(XsdShort input) => input.toString();
}

/// Decoder for `xsd:short`.
class XsdShortDecoder extends XsdConverter<String, XsdShort> {
  /// Creates a new [XsdShortDecoder].
  const XsdShortDecoder();

  static final RegExp _pattern = RegExp(r'^[\-+]?[0-9]+$');

  @override
  XsdShort convert(String input) {
    if (!_pattern.hasMatch(input)) {
      throw XsdValidationException(
        'Invalid xsd:short lexical representation.',
        input: input,
        type: 'xsd:short',
      );
    }

    final value = BigInt.parse(input);

    if (value < BigInt.from(XsdShort.min) ||
        value > BigInt.from(XsdShort.max)) {
      throw XsdValidationException(
        'Value out of range for xsd:short: $value',
        input: input,
        type: 'xsd:short',
      );
    }

    return XsdShort.unsafe(value.toInt());
  }
}
