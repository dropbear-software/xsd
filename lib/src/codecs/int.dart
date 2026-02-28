import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [int] representing the `xsd:int` value space.
///
/// Value space: Integers in the range `[-2147483648, 2147483647]`.
extension type const XsdInt._(int value) implements int {
  /// The minimum value for an `xsd:int`, equal to -2^31.
  static const int min = -2147483648;

  /// The maximum value for an `xsd:int`, equal to 2^31 - 1.
  static const int max = 2147483647;

  /// Validates and creates an [XsdInt].
  ///
  /// Throws a [RangeError] if the value is outside the range
  /// `[-2147483648, 2147483647]`.
  factory XsdInt(int value) {
    if (value < min || value > max) {
      throw RangeError.range(value, min, max, 'XsdInt');
    }
    return XsdInt._(value);
  }

  /// Creates an [XsdInt] without validation.
  const XsdInt.unsafe(this.value);
}

/// Codec for `xsd:int`.
///
/// According to XSD 1.1:
/// - Value space: Integers in the range `[-2147483648, 2147483647]`.
/// - Base type: `xsd:long`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdIntCodec extends XsdCodec<XsdInt> {
  /// Creates a new [XsdIntCodec].
  const XsdIntCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdInt, String> get encoder => const XsdIntEncoder();

  @override
  XsdConverter<String, XsdInt> get decoder => const XsdIntDecoder();
}

/// Encoder for `xsd:int`.
class XsdIntEncoder extends XsdConverter<XsdInt, String> {
  /// Creates a new [XsdIntEncoder].
  const XsdIntEncoder();

  @override
  String convert(XsdInt input) => input.toString();
}

/// Decoder for `xsd:int`.
class XsdIntDecoder extends XsdConverter<String, XsdInt> {
  /// Creates a new [XsdIntDecoder].
  const XsdIntDecoder();

  static final RegExp _pattern = RegExp(r'^[\-+]?[0-9]+$');

  @override
  XsdInt convert(String input) {
    if (!_pattern.hasMatch(input)) {
      throw XsdValidationException(
        'Invalid xsd:int lexical representation.',
        input: input,
        type: 'xsd:int',
      );
    }

    final value = BigInt.parse(input);

    if (value < BigInt.from(XsdInt.min) || value > BigInt.from(XsdInt.max)) {
      throw XsdValidationException(
        'Value out of range for xsd:int: $value',
        input: input,
        type: 'xsd:int',
      );
    }
    return XsdInt.unsafe(value.toInt());
  }
}
