import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Extension type on [BigInt] representing the `xsd:integer` value space.
///
/// Value space: Infinite set of integers ({..., -2, -1, 0, 1, 2, ...}).
///
/// This type ensures arbitrary precision and platform consistency by leveraging [BigInt].
extension type const XsdInteger._(BigInt value) implements BigInt {
  /// Creates an [XsdInteger].
  const XsdInteger(this.value);

  /// Creates an [XsdInteger] without validation (same as the main constructor).
  const XsdInteger.unsafe(this.value);

  /// Parses an [input] string into an [XsdInteger].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation:
  /// `(\+|-)?([0-9]+)`
  ///
  /// Throws a [FormatException] if the [input] is not a valid integer.
  factory XsdInteger.parse(String input) {
    final regex = RegExp(r'^(\+|-)?([0-9]+)$');
    if (!regex.hasMatch(input)) {
      throw FormatException('Invalid xsd:integer lexical form: $input');
    }

    try {
      return XsdInteger(BigInt.parse(input));
    } on FormatException {
      throw FormatException('Invalid xsd:integer lexical form: $input');
    }
  }
}

/// Codec for `xsd:integer`.
///
/// According to XSD 1.1:
/// - Value space: Infinite set of integers.
/// - Lexical representation: (\+|-)?([0-9]+)
/// - whiteSpace facet: collapse (fixed)
class XsdIntegerCodec extends XsdCodec<XsdInteger> {
  /// Creates a new [XsdIntegerCodec].
  const XsdIntegerCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdInteger, String> get encoder => const XsdIntegerEncoder();

  @override
  XsdConverter<String, XsdInteger> get decoder => const XsdIntegerDecoder();
}

/// Encoder for `xsd:integer`.
class XsdIntegerEncoder extends XsdConverter<XsdInteger, String> {
  /// Creates a new [XsdIntegerEncoder].
  const XsdIntegerEncoder();

  @override
  String convert(XsdInteger input) {
    return input.toString();
  }
}

/// Decoder for `xsd:integer`.
class XsdIntegerDecoder extends XsdConverter<String, XsdInteger> {
  /// Creates a new [XsdIntegerDecoder].
  const XsdIntegerDecoder();

  @override
  XsdInteger convert(String input) {
    try {
      return XsdInteger.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:integer',
      );
    }
  }
}
