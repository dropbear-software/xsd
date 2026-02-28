import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:nonNegativeInteger` value space.
///
/// Value space: Integers greater than or equal to zero ({0, 1, 2, ...}).
///
/// This type ensures arbitrary precision and platform consistency by leveraging [BigInt].
extension type const XsdNonNegativeInteger._(BigInt value) implements BigInt {
  static final _regex = RegExp(r'^[\-+]?[0-9]+$');

  /// Validates and creates an [XsdNonNegativeInteger].
  ///
  /// Throws an [ArgumentError] if the [value] is negative.
  factory XsdNonNegativeInteger(BigInt value) {
    if (value < BigInt.zero) {
      throw ArgumentError(
        'Value out of range for XsdNonNegativeInteger: $value. '
        'Must be greater than or equal to 0.',
      );
    }
    return XsdNonNegativeInteger._(value);
  }

  /// Creates an [XsdNonNegativeInteger] without validation.
  const XsdNonNegativeInteger.unsafe(this.value);

  /// Parses an [input] string into an [XsdNonNegativeInteger].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation:
  /// `[\-+]?[0-9]+`
  ///
  /// For zero, the sign can be '+', '-', or omitted.
  /// For all other values, the negative sign ('-') is prohibited.
  ///
  /// Throws a [FormatException] if the [input] is not a valid non-negative integer.
  factory XsdNonNegativeInteger.parse(String input) {
    if (!_regex.hasMatch(input)) {
      throw FormatException(
        'Invalid xsd:nonNegativeInteger lexical form: $input',
      );
    }

    final value = BigInt.parse(input);

    if (value < BigInt.zero) {
      throw FormatException(
        'Value out of range for xsd:nonNegativeInteger: $value',
      );
    }

    if (value > BigInt.zero && input.startsWith('-')) {
      throw FormatException(
        'Positive values must not have a negative sign: $input',
      );
    }

    return XsdNonNegativeInteger._(value);
  }
}

/// Codec for `xsd:nonNegativeInteger`.
///
/// According to XSD 1.1:
/// - Value space: Integers >= 0.
/// - Base type: `xsd:integer`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdNonNegativeIntegerCodec extends XsdCodec<XsdNonNegativeInteger> {
  /// Creates a new [XsdNonNegativeIntegerCodec].
  const XsdNonNegativeIntegerCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdNonNegativeInteger, String> get encoder =>
      const XsdNonNegativeIntegerEncoder();

  @override
  XsdConverter<String, XsdNonNegativeInteger> get decoder =>
      const XsdNonNegativeIntegerDecoder();
}

/// Encoder for `xsd:nonNegativeInteger`.
class XsdNonNegativeIntegerEncoder
    extends XsdConverter<XsdNonNegativeInteger, String> {
  /// Creates a new [XsdNonNegativeIntegerEncoder].
  const XsdNonNegativeIntegerEncoder();

  @override
  String convert(XsdNonNegativeInteger input) => input.toString();
}

/// Decoder for `xsd:nonNegativeInteger`.
class XsdNonNegativeIntegerDecoder
    extends XsdConverter<String, XsdNonNegativeInteger> {
  /// Creates a new [XsdNonNegativeIntegerDecoder].
  const XsdNonNegativeIntegerDecoder();

  @override
  XsdNonNegativeInteger convert(String input) {
    try {
      return XsdNonNegativeInteger.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:nonNegativeInteger',
      );
    }
  }
}
