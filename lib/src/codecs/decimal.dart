import 'package:meta/meta.dart';
import '../core/exceptions.dart';
import '../core/whitespace.dart';
import '../core/xsd_codec.dart';

/// Represents an arbitrary-precision decimal number as defined by W3C XSD 1.1.
///
/// It is backed by an unscaled value (BigInt) and a scale (int).
/// For example, 12.34 is represented as unscaledValue: 1234, scale: 2.
@immutable
final class XsdDecimal implements Comparable<XsdDecimal> {
  /// The digits of the number ignoring the decimal point.
  final BigInt unscaledValue;

  /// The number of digits to the right of the decimal point.
  final int scale;

  /// Creates an [XsdDecimal] with the given [unscaledValue] and [scale].
  ///
  /// The value is mathematically normalized by stripping trailing fractional zeros.
  /// For example, [XsdDecimal(BigInt.from(12300), 2)] becomes unscaled: 123, scale: 0.
  factory XsdDecimal(BigInt unscaledValue, int scale) {
    var currentUnscaled = unscaledValue;
    var currentScale = scale;

    if (currentUnscaled == BigInt.zero) {
      currentScale = 0;
    } else {
      while (currentScale > 0 &&
          currentUnscaled % BigInt.from(10) == BigInt.zero) {
        currentUnscaled ~/= BigInt.from(10);
        currentScale -= 1;
      }
    }

    return XsdDecimal._(currentUnscaled, currentScale);
  }

  const XsdDecimal._(this.unscaledValue, this.scale);

  /// Parses an [input] string into an [XsdDecimal].
  ///
  /// The [input] must conform to the XSD 1.1 lexical representation for decimal:
  /// `(\+|-)?([0-9]+(\.[0-9]*)?|\.[0-9]+)`
  ///
  /// Scientific notation (e.g., '1E2') and special values (NaN, INF) are not supported.
  factory XsdDecimal.parse(String input) {
    final regex = RegExp(r'^(\+|-)?([0-9]+(\.[0-9]*)?|\.[0-9]+)$');
    final match = regex.firstMatch(input);

    if (match == null) {
      throw FormatException('Invalid XSD decimal: $input');
    }

    final sign = match.group(1) == '-' ? -1 : 1;
    final magnitude = match.group(2)!;

    final dotIndex = magnitude.indexOf('.');
    if (dotIndex == -1) {
      return XsdDecimal(BigInt.parse(magnitude) * BigInt.from(sign), 0);
    } else {
      final beforeDot = magnitude.substring(0, dotIndex);
      final afterDot = magnitude.substring(dotIndex + 1);
      final unscaledString = '$beforeDot$afterDot';
      final scale = afterDot.length;

      // Handle case like ".5" where unscaledString might be empty if beforeDot is empty
      // but BigInt.parse handles leading dot if we combine them correctly.
      // Actually if beforeDot is empty, it's like "0" + afterDot.
      final unscaledValue = BigInt.parse(
        unscaledString.isEmpty ? '0' : unscaledString,
      );
      return XsdDecimal(unscaledValue * BigInt.from(sign), scale);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XsdDecimal &&
          unscaledValue == other.unscaledValue &&
          scale == other.scale;

  @override
  int get hashCode => unscaledValue.hashCode ^ scale.hashCode;

  @override
  int compareTo(XsdDecimal other) {
    if (scale == other.scale) {
      return unscaledValue.compareTo(other.unscaledValue);
    }

    // To compare, we bring both to the same scale (the larger one)
    if (scale > other.scale) {
      final factor = BigInt.from(10).pow(scale - other.scale);
      return unscaledValue.compareTo(other.unscaledValue * factor);
    } else {
      final factor = BigInt.from(10).pow(other.scale - scale);
      return (unscaledValue * factor).compareTo(other.unscaledValue);
    }
  }

  @override
  String toString() {
    if (scale == 0) {
      return unscaledValue.toString();
    }

    final isNegative = unscaledValue < BigInt.zero;
    var absUnscaled = unscaledValue.abs().toString();

    if (absUnscaled.length <= scale) {
      absUnscaled = absUnscaled.padLeft(scale + 1, '0');
    }

    final dotPosition = absUnscaled.length - scale;
    final result =
        '${absUnscaled.substring(0, dotPosition)}.${absUnscaled.substring(dotPosition)}';

    return isNegative ? '-$result' : result;
  }
}

/// Codec for `xsd:decimal`.
///
/// According to XSD 1.1:
/// - Value space: subset of real numbers expressible as i / 10^n (n >= 0).
/// - Lexical representation: (\+|-)?([0-9]+(\.[0-9]*)?|\.[0-9]+)
/// - whiteSpace facet: collapse (fixed)
/// - Canonical representation:
///   - If integer: no decimal point.
///   - If not integer: decimal point required, leading zero required if < 1.
///   - Leading/trailing zeros prohibited (except for one leading zero before .).
///   - Sign: '-' preserved, '+' omitted.
class XsdDecimalCodec extends XsdCodec<XsdDecimal> {
  /// Creates a new [XsdDecimalCodec].
  const XsdDecimalCodec();

  @override
  XsdWhitespace get whiteSpace => XsdWhitespace.collapse;

  @override
  XsdConverter<XsdDecimal, String> get encoder => const XsdDecimalEncoder();

  @override
  XsdConverter<String, XsdDecimal> get decoder => const XsdDecimalDecoder();
}

/// Encoder for `xsd:decimal`.
class XsdDecimalEncoder extends XsdConverter<XsdDecimal, String> {
  /// Creates a new [XsdDecimalEncoder].
  const XsdDecimalEncoder();

  @override
  String convert(XsdDecimal input) => input.toString();
}

/// Decoder for `xsd:decimal`.
class XsdDecimalDecoder extends XsdConverter<String, XsdDecimal> {
  /// Creates a new [XsdDecimalDecoder].
  const XsdDecimalDecoder();

  @override
  XsdDecimal convert(String input) {
    try {
      return XsdDecimal.parse(input);
    } on FormatException catch (e) {
      throw XsdValidationException(
        e.message,
        input: input,
        type: 'xsd:decimal',
      );
    }
  }
}
