import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:nonPositiveInteger` value space.
///
/// Value space: Integers less than or equal to zero ({..., -2, -1, 0}).
///
/// This type ensures arbitrary precision and platform consistency by leveraging [BigInt].
extension type const XsdNonPositiveInteger._(BigInt value) implements BigInt {
  static final _regex = RegExp(r'^[\-+]?[0-9]+$');

  /// Validates and creates an [XsdNonPositiveInteger].
  ///
  /// Throws an [ArgumentError] if the [value] is positive.
  factory XsdNonPositiveInteger(BigInt value) {
    if (value > BigInt.zero) {
      throw ArgumentError(
        'Value out of range for XsdNonPositiveInteger: $value. '
        'Must be less than or equal to 0.',
      );
    }
    return XsdNonPositiveInteger._(value);
  }

  /// Creates an [XsdNonPositiveInteger] without validation.
  const XsdNonPositiveInteger.unsafe(this.value);

  /// Parses an [input] string into an [XsdNonPositiveInteger].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation:
  /// `[\-+]?[0-9]+`
  ///
  /// For zero, the sign can be '+' or omitted.
  /// For all other values, the negative sign ('-') must be present.
  ///
  /// Throws a [FormatException] if the [input] is not a valid non-positive integer.
  factory XsdNonPositiveInteger.parse(String input) {
    if (!_regex.hasMatch(input)) {
      throw FormatException(
        'Invalid xsd:nonPositiveInteger lexical form: $input',
      );
    }

    final value = BigInt.parse(input);

    if (value > BigInt.zero) {
      throw FormatException(
        'Value out of range for xsd:nonPositiveInteger: $value',
      );
    }

    if (value < BigInt.zero && !input.startsWith('-')) {
      throw FormatException(
        'Non-zero negative values must have a negative sign: $input',
      );
    }

    return XsdNonPositiveInteger._(value);
  }
}

/// Codec for `xsd:nonPositiveInteger`.
///
/// According to XSD 1.1:
/// - Value space: Integers <= 0.
/// - Base type: `xsd:integer`.
/// - whiteSpace facet: collapse (fixed)
/// - pattern: [\-+]?[0-9]+
class XsdNonPositiveIntegerCodec extends XsdCodec<XsdNonPositiveInteger> {
  /// Creates a new [XsdNonPositiveIntegerCodec].
  const XsdNonPositiveIntegerCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdNonPositiveInteger, String> get encoder =>
      const XsdNonPositiveIntegerEncoder();

  @override
  XsdConverter<String, XsdNonPositiveInteger> get decoder =>
      const XsdNonPositiveIntegerDecoder();
}

/// Encoder for `xsd:nonPositiveInteger`.
class XsdNonPositiveIntegerEncoder
    extends XsdConverter<XsdNonPositiveInteger, String> {
  /// Creates a new [XsdNonPositiveIntegerEncoder].
  const XsdNonPositiveIntegerEncoder();

  @override
  String convert(XsdNonPositiveInteger input) => input.toString();
}

/// Decoder for `xsd:nonPositiveInteger`.
class XsdNonPositiveIntegerDecoder
    extends XsdConverter<String, XsdNonPositiveInteger> {
  /// Creates a new [XsdNonPositiveIntegerDecoder].
  const XsdNonPositiveIntegerDecoder();

  @override
  XsdNonPositiveInteger convert(String input) {
    try {
      return XsdNonPositiveInteger.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:nonPositiveInteger',
      );
    }
  }
}
