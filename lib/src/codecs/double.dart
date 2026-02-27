import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Codec for `xsd:double`.
///
/// According to XSD 1.1:
/// - Value space: IEEE double-precision 64-bit floating point.
/// - whiteSpace facet: collapse (fixed).
class XsdDoubleCodec extends XsdCodec<double> {
  /// Creates a new [XsdDoubleCodec].
  const XsdDoubleCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<double, String> get encoder => const XsdDoubleEncoder();

  @override
  XsdConverter<String, double> get decoder => const XsdDoubleDecoder();
}

/// Encoder for `xsd:double`.
class XsdDoubleEncoder extends XsdConverter<double, String> {
  /// Creates a new [XsdDoubleEncoder].
  const XsdDoubleEncoder();

  @override
  String convert(double input) {
    if (input.isNaN) return 'NaN';
    if (input == double.infinity) return 'INF';
    if (input == double.negativeInfinity) return '-INF';

    // Handle zero variants
    if (input == 0.0) {
      return input.isNegative ? '-0.0E0' : '0.0E0';
    }

    // Canonical form: mantissa has exactly one non-zero digit before decimal point.
    // Example: 1.2345E2
    // Dart's toStringAsExponential(decimalPlaces) provides scientific notation.
    // However, toStringAsExponential does not specify a fixed number of digits
    // unless we provide one, but XSD canonical form says "the mantissa MUST have
    // exactly one non-zero digit before the decimal point" AND "the fractional part
    // MUST be represented as a decimal number...".

    // Actually, the simplest way is to use toStringAsExponential() and then
    // clean it up if necessary (e.g. 'e' -> 'E', remove unnecessary '+' in exponent).

    // W3C Canonical Mapping for double:
    // "the mantissa is a decimal number... with one non-zero digit to the left of
    // the decimal point... The exponent is an integer... with no leading zeroes."

    var result = input.toStringAsExponential();

    // Normalize exponent: replace 'e' with 'E' and remove '+'
    result = result.replaceFirst('e', 'E').replaceFirst('E+', 'E');

    // Ensure decimal point exists in mantissa even for integers like 1.0E0
    // Dart's toStringAsExponential() usually includes it if needed, but let's check.
    // e.g. 1.toStringAsExponential() -> '1e+0' (on some platforms) or '1.0e+0'
    final eIndex = result.indexOf('E');
    final mantissa = result.substring(0, eIndex);
    final exponent = result.substring(eIndex);

    if (!mantissa.contains('.')) {
      result = '$mantissa.0$exponent';
    }

    return result;
  }
}

/// Decoder for `xsd:double`.
class XsdDoubleDecoder extends XsdConverter<String, double> {
  /// Creates a new [XsdDoubleDecoder].
  const XsdDoubleDecoder();

  @override
  double convert(String input) {
    // Special literals
    switch (input) {
      case 'INF':
      case '+INF':
        return double.infinity;
      case '-INF':
        return double.negativeInfinity;
      case 'NaN':
        return double.nan;
    }

    // XSD 1.1 doubleRep regex: (\+|-)?([0-9]+(\.[0-9]*)?|\.[0-9]+)([Ee](\+|-)?[0-9]+)?
    // Note: Dart's double.parse is fairly compatible but we must ensure it doesn't
    // accept strings that XSD prohibits (like 'Infinity').

    // We explicitly reject literals that double.parse might accept but XSD doesn't.
    // 1. 'Infinity' variants
    // 2. Case-variants of 'NaN' (Dart's double.parse is case-insensitive for 'NaN')
    if (input.contains('Infinity') ||
        (input.toLowerCase().contains('nan') && input != 'NaN')) {
      throw XsdValidationException(
        'Invalid xsd:double lexical form: $input',
        input: input,
        type: 'xsd:double',
      );
    }

    try {
      return double.parse(input);
    } on FormatException {
      throw XsdValidationException(
        'Invalid xsd:double lexical form: $input',
        input: input,
        type: 'xsd:double',
      );
    }
  }
}
