import 'dart:convert';
import 'whitespace.dart';

/// Base class for all XSD datatypes.
///
/// Provides a unified interface for converting between XSD lexical
/// representations (Strings) and Dart types [T].
abstract class XsdCodec<T> extends Codec<T, String> {
  /// Creates a new [XsdCodec].
  const XsdCodec();

  /// The whitespace normalization strategy for this datatype.
  XsdWhitespace get whiteSpace;

  @override
  T decode(String encoded) {
    final normalized = normalizeWhitespace(encoded, whiteSpace);
    return decoder.convert(normalized);
  }

  @override
  String encode(T input) => encoder.convert(input);

  @override
  XsdConverter<T, String> get encoder;

  @override
  XsdConverter<String, T> get decoder;
}

/// Base class for XSD encoders and decoders.
abstract class XsdConverter<S, T> extends Converter<S, T> {
  /// Creates a new [XsdConverter].
  const XsdConverter();
}
