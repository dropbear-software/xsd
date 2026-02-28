import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:negativeInteger` value space.
///
/// Value space: Integers strictly less than zero ({..., -2, -1}).
///
/// This type ensures arbitrary precision and platform consistency by leveraging [BigInt].
extension type const XsdNegativeInteger._(BigInt value) implements BigInt {
  static final _regex = RegExp(r'^[-+]?[0-9]+$');

  /// Validates and creates an [XsdNegativeInteger].
  ///
  /// Throws an [ArgumentError] if the [value] is greater than or equal to zero.
  factory XsdNegativeInteger(BigInt value) {
    if (value >= BigInt.zero) {
      throw ArgumentError(
        'Value out of range for XsdNegativeInteger: $value. '
        'Must be strictly less than 0.',
      );
    }
    return XsdNegativeInteger._(value);
  }

  /// Creates an [XsdNegativeInteger] without validation.
  const XsdNegativeInteger.unsafe(this.value);

  /// Parses an [input] string into an [XsdNegativeInteger].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation:
  /// `[\-+]?[0-9]+`
  ///
  /// Throws a [FormatException] if the [input] is not a valid negative integer.
  factory XsdNegativeInteger.parse(String input) {
    if (!_regex.hasMatch(input)) {
      throw FormatException('Invalid xsd:negativeInteger lexical form: $input');
    }

    final value = BigInt.parse(input);

    if (value >= BigInt.zero) {
      throw FormatException(
        'Value out of range for xsd:negativeInteger: $value',
      );
    }

    return XsdNegativeInteger._(value);
  }
}

/// Codec for `xsd:negativeInteger`.
///
/// According to XSD 1.1:
/// - Value space: Integers < 0.
/// - Base type: `xsd:nonPositiveInteger`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdNegativeIntegerCodec extends XsdCodec<XsdNegativeInteger> {
  /// Creates a new [XsdNegativeIntegerCodec].
  const XsdNegativeIntegerCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdNegativeInteger, String> get encoder =>
      const XsdNegativeIntegerEncoder();

  @override
  XsdConverter<String, XsdNegativeInteger> get decoder =>
      const XsdNegativeIntegerDecoder();
}

/// Encoder for `xsd:negativeInteger`.
class XsdNegativeIntegerEncoder
    extends XsdConverter<XsdNegativeInteger, String> {
  /// Creates a new [XsdNegativeIntegerEncoder].
  const XsdNegativeIntegerEncoder();

  @override
  String convert(XsdNegativeInteger input) => input.toString();
}

/// Decoder for `xsd:negativeInteger`.
class XsdNegativeIntegerDecoder
    extends XsdConverter<String, XsdNegativeInteger> {
  /// Creates a new [XsdNegativeIntegerDecoder].
  const XsdNegativeIntegerDecoder();

  @override
  XsdNegativeInteger convert(String input) {
    try {
      return XsdNegativeInteger.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:negativeInteger',
      );
    }
  }
}
