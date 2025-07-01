import 'dart:convert';

import 'package:intl/locale.dart';

import 'language_decoder.dart';
import 'language_encoder.dart';

const xsdLanguageCodec = XsdLanguageCodec();

/// Codec for the XSD 'language' datatype.
///
/// `language` represents natural language identifiers as defined by BCP 47.
/// The Dart representation is a `Locale` object from the `package:intl`.
class XsdLanguageCodec extends Codec<Locale, String> {
  const XsdLanguageCodec();

  @override
  Converter<String, Locale> get decoder => const XsdLanguageDecoder();

  @override
  Converter<Locale, String> get encoder => const XsdLanguageEncoder();
}
