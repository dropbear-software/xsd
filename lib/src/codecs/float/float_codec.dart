import 'dart:convert';
import 'dart:typed_data';

import 'package:xsd/src/helpers/whitespace.dart';

/// A [Codec] that converts between XSD `float` strings and [double] values.
///
/// Note: Dart uses 64-bit doubles for floating point numbers. This codec
/// uses [double] to represent XSD `float` values, which are 32-bit. It will
/// throw an error if a value cannot be represented as a 32-bit float.
class XsdFloatCodec extends Codec<double, String> {
  const XsdFloatCodec();

  @override
  Converter<double, String> get encoder => const XsdFloatEncoder();

  @override
  Converter<String, double> get decoder => const XsdFloatDecoder();
}

class XsdFloatEncoder extends Converter<double, String> {
  const XsdFloatEncoder();

  @override
  String convert(double input) {
    // Validate that the double can be represented as a 32-bit float.
    if (input.isFinite) {
      final f32 = Float32List(1);
      f32[0] = input;
      // An overflow results in INFINITY, which changes the meaning of the value.
      if (f32[0].isInfinite) {
        throw ArgumentError(
          'Value $input overflows the 32-bit float range and cannot be encoded.',
        );
      }

      // An underflow to 0 also changes the meaning of the value.
      if (input != 0.0 && f32[0] == 0.0) {
        throw ArgumentError(
          'Value $input underflows the 32-bit float range and cannot be encoded.',
        );
      }
    }

    if (input.isNaN) return 'NaN';
    if (input == double.infinity) return 'INF';
    if (input == double.negativeInfinity) return '-INF';
    // XSD canonical form uses 'E'.
    return input.toString().toUpperCase();
  }
}

class XsdFloatDecoder extends Converter<String, double> {
  const XsdFloatDecoder();

  @override
  double convert(String input) {
    final trimmed = processWhiteSpace(input, Whitespace.collapse);
    if (trimmed == 'INF') return double.infinity;
    if (trimmed == '-INF') return double.negativeInfinity;
    if (trimmed == 'NaN') return double.nan;

    final value = double.tryParse(trimmed);

    if (value == null) {
      throw FormatException('Invalid XSD float value: "$input"');
    }

    // Dart's double is 64-bit. We need to validate that the value
    // fits within the 32-bit float value space as defined by XSD.
    if (value.isFinite) {
      // Use Float32List to check for overflow.
      final f32 = Float32List(1);
      f32[0] = value;
      final floatValue = f32[0];

      // If the conversion results in infinity, but the original was not, it's an overflow.
      if (floatValue.isInfinite) {
        throw FormatException(
          'The literal "$input" is outside the value range of float (overflow).',
        );
      }

      // If the conversion results in 0, but the original was not, it's an underflow.
      if (value != 0.0 && floatValue == 0.0) {
        throw FormatException(
          'The literal "$input" is outside the value range of float (underflow).',
        );
      }
    }

    return value;
  }
}
