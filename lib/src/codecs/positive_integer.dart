import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:positiveInteger` value space.
///
/// Value space: Integers strictly greater than zero ({1, 2, 3, ...}).
///
/// This type ensures arbitrary precision and platform consistency by leveraging [BigInt].
extension type const XsdPositiveInteger._(BigInt value) implements BigInt {
  static final _regex = RegExp(r'^[\-+]?[0-9]+$');

  /// Validates and creates an [XsdPositiveInteger].
  ///
  /// Throws an [ArgumentError] if the [value] is less than or equal to zero.
  factory XsdPositiveInteger(BigInt value) {
    if (value <= BigInt.zero) {
      throw ArgumentError(
        'Value out of range for XsdPositiveInteger: $value. '
        'Must be strictly greater than 0.',
      );
    }
    return XsdPositiveInteger._(value);
  }

  /// Creates an [XsdPositiveInteger] without validation.
  const XsdPositiveInteger.unsafe(this.value);

  /// Parses an [input] string into an [XsdPositiveInteger].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation:
  /// `[\-+]?[0-9]+`
  ///
  /// Throws a [FormatException] if the [input] is not a valid positive integer.
  factory XsdPositiveInteger.parse(String input) {
    if (!_regex.hasMatch(input)) {
      throw FormatException('Invalid xsd:positiveInteger lexical form: $input');
    }

    final value = BigInt.parse(input);

    if (value <= BigInt.zero) {
      throw FormatException(
        'Value out of range for xsd:positiveInteger: $value',
      );
    }

    return XsdPositiveInteger._(value);
  }
}

/// Codec for `xsd:positiveInteger`.
///
/// According to XSD 1.1:
/// - Value space: Integers > 0.
/// - Base type: `xsd:nonNegativeInteger`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdPositiveIntegerCodec extends XsdCodec<XsdPositiveInteger> {
  /// Creates a new [XsdPositiveIntegerCodec].
  const XsdPositiveIntegerCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdPositiveInteger, String> get encoder =>
      const XsdPositiveIntegerEncoder();

  @override
  XsdConverter<String, XsdPositiveInteger> get decoder =>
      const XsdPositiveIntegerDecoder();
}

/// Encoder for `xsd:positiveInteger`.
class XsdPositiveIntegerEncoder
    extends XsdConverter<XsdPositiveInteger, String> {
  /// Creates a new [XsdPositiveIntegerEncoder].
  const XsdPositiveIntegerEncoder();

  @override
  String convert(XsdPositiveInteger input) => input.toString();
}

/// Decoder for `xsd:positiveInteger`.
class XsdPositiveIntegerDecoder
    extends XsdConverter<String, XsdPositiveInteger> {
  /// Creates a new [XsdPositiveIntegerDecoder].
  const XsdPositiveIntegerDecoder();

  @override
  XsdPositiveInteger convert(String input) {
    try {
      return XsdPositiveInteger.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:positiveInteger',
      );
    }
  }
}
