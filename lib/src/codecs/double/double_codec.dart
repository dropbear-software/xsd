import 'dart:convert';

import 'package:xsd/src/helpers/whitespace.dart';

/// A [Codec] that converts between XSD `double` strings and [double] values.
class XsdDoubleCodec extends Codec<double, String> {
  const XsdDoubleCodec();

  @override
  Converter<double, String> get encoder => const XsdDoubleEncoder();

  @override
  Converter<String, double> get decoder => const XsdDoubleDecoder();
}

class XsdDoubleEncoder extends Converter<double, String> {
  const XsdDoubleEncoder();

  @override
  String convert(double input) {
    if (input.isNaN) return 'NaN';
    if (input == double.infinity) return 'INF';
    if (input == double.negativeInfinity) return '-INF';
    // Dart's toString() might produce scientific notation 1.2e+3, XSD accepts 1.2E3 or 1.2e3.
    // XSD canonical form uses 'E'.
    return input.toString().toUpperCase();
  }
}

class XsdDoubleDecoder extends Converter<String, double> {
  const XsdDoubleDecoder();

  @override
  double convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);
    if (trimmed == 'INF') return double.infinity;
    if (trimmed == '-INF') return double.negativeInfinity;
    if (trimmed == 'NaN') return double.nan;

    return double.parse(trimmed);
  }
}
