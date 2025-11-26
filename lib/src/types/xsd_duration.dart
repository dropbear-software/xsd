import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

/// Represents an xsd:duration value.
///
/// A duration is a period of time as defined by ISO 8601.
/// It consists of two components:
/// - A number of months (which includes years as 12 months).
/// - A number of seconds (which includes days, hours, and minutes).
///
/// This separation is necessary because the length of a month or year varies,
/// while the length of a day, hour, minute, and second is fixed in this context
/// (ignoring leap seconds, as XSD does).
///
/// See [XSD duration](https://www.w3.org/TR/xmlschema11-2/#duration).
@immutable
class XsdDuration {
  /// The number of months in this duration.
  ///
  /// This captures the year and month components.
  /// Positive for positive durations, negative for negative durations.
  final int months;

  /// The number of seconds in this duration.
  ///
  /// This captures the day, hour, minute, and second components.
  /// Positive for positive durations, negative for negative durations.
  final Decimal seconds;

  /// Constructs an [XsdDuration].
  ///
  /// [months] and [seconds] must have the same sign (both non-negative or both non-positive),
  /// unless one of them is zero.
  XsdDuration({this.months = 0, Decimal? seconds})
    : seconds = seconds ?? Decimal.zero {
    if ((months > 0 && this.seconds < Decimal.zero) ||
        (months < 0 && this.seconds > Decimal.zero)) {
      throw ArgumentError(
        'Months and seconds must have the same sign. Got months: $months, seconds: ${this.seconds}',
      );
    }
  }

  /// Returns `true` if this duration is negative.
  bool get isNegative => months < 0 || seconds < Decimal.zero;

  /// Parses a string in XSD duration format into an [XsdDuration] object.
  ///
  /// The format is `PnYnMnDTnHnMnS`, where `n` is a number.
  /// An optional leading `-` indicates a negative duration.
  ///
  /// Throws a [FormatException] if the input string is not a valid duration.
  static XsdDuration parse(String lexicalForm) {
    // Regex for Duration:
    // -?P((([0-9]+Y)?([0-9]+M)?([0-9]+D)?(T([0-9]+H)?([0-9]+M)?([0-9]+(\.[0-9]+)?S)?)?)|(T([0-9]+H)?([0-9]+M)?([0-9]+(\.[0-9]+)?S)?))
    // Simplified: -?P...
    // We will parse manually or with a simpler regex to extract parts.

    if (lexicalForm.isEmpty) {
      throw FormatException('Invalid duration format: empty string');
    }

    bool isNegative = false;
    String input = lexicalForm;
    if (input.startsWith('-')) {
      isNegative = true;
      input = input.substring(1);
    }

    if (!input.startsWith('P')) {
      throw FormatException(
        'Invalid duration format: must start with P (after optional sign)',
        lexicalForm,
      );
    }

    // Check for empty P (and potentially empty T)
    if (input == 'P') {
      throw FormatException(
        'Invalid duration format: no components specified',
        lexicalForm,
      );
    }

    // Split into Date and Time parts
    final parts = input.substring(1).split('T');
    if (parts.length > 2) {
      throw FormatException(
        'Invalid duration format: multiple T separators',
        lexicalForm,
      );
    }

    String datePart = parts[0];
    String timePart = parts.length > 1 ? parts[1] : '';

    if (parts.length > 1 && timePart.isEmpty) {
      throw FormatException(
        'Invalid duration format: T present but no time components',
        lexicalForm,
      );
    }

    // We will consume the string from left to right.

    int parsedMonths = 0;
    Decimal parsedSeconds = Decimal.zero;

    // Parse Date Part
    if (datePart.isNotEmpty) {
      // Y
      int yIndex = datePart.indexOf('Y');
      if (yIndex != -1) {
        String val = datePart.substring(0, yIndex);
        parsedMonths += int.parse(val) * 12;
        datePart = datePart.substring(yIndex + 1);
      }

      // M
      int mIndex = datePart.indexOf('M');
      if (mIndex != -1) {
        String val = datePart.substring(0, mIndex);
        parsedMonths += int.parse(val);
        datePart = datePart.substring(mIndex + 1);
      }

      // D
      int dIndex = datePart.indexOf('D');
      if (dIndex != -1) {
        String val = datePart.substring(0, dIndex);
        parsedSeconds += Decimal.parse(val) * Decimal.fromInt(86400);
        datePart = datePart.substring(dIndex + 1);
      }

      if (datePart.isNotEmpty) {
        throw FormatException(
          'Invalid duration format: unexpected characters in date part "$datePart"',
          lexicalForm,
        );
      }
    }

    // Parse Time Part
    if (timePart.isNotEmpty) {
      // H
      int hIndex = timePart.indexOf('H');
      if (hIndex != -1) {
        String val = timePart.substring(0, hIndex);
        parsedSeconds += Decimal.parse(val) * Decimal.fromInt(3600);
        timePart = timePart.substring(hIndex + 1);
      }

      // M
      int mIndex = timePart.indexOf('M');
      if (mIndex != -1) {
        String val = timePart.substring(0, mIndex);
        parsedSeconds += Decimal.parse(val) * Decimal.fromInt(60);
        timePart = timePart.substring(mIndex + 1);
      }

      // S
      int sIndex = timePart.indexOf('S');
      if (sIndex != -1) {
        String val = timePart.substring(0, sIndex);
        parsedSeconds += Decimal.parse(val);
        timePart = timePart.substring(sIndex + 1);
      }

      if (timePart.isNotEmpty) {
        throw FormatException(
          'Invalid duration format: unexpected characters in time part "$timePart"',
          lexicalForm,
        );
      }
    }

    if (isNegative) {
      parsedMonths = -parsedMonths;
      parsedSeconds = -parsedSeconds;
    }

    return XsdDuration(months: parsedMonths, seconds: parsedSeconds);
  }

  /// Returns the canonical lexical representation of this [XsdDuration].
  ///
  /// The format is `PnYnMnDTnHnMnS`.
  /// Zero components are omitted, except if the whole duration is zero, which is `PT0S`.
  @override
  String toString() {
    if (months == 0 && seconds == Decimal.zero) {
      return 'PT0S';
    }

    final sb = StringBuffer();
    if (isNegative) {
      sb.write('-');
    }
    sb.write('P');

    final absMonths = months.abs();
    final years = absMonths ~/ 12;
    final monthPart = absMonths % 12;

    if (years > 0) {
      sb.write('${years}Y');
    }
    if (monthPart > 0) {
      sb.write('${monthPart}M');
    }

    Decimal absSeconds = seconds.abs();
    final days = (absSeconds / Decimal.fromInt(86400)).floor();
    absSeconds -= Decimal.fromBigInt(days) * Decimal.fromInt(86400);

    if (days > BigInt.zero) {
      sb.write('${days}D');
    }

    if (absSeconds > Decimal.zero) {
      sb.write('T');

      final hours = (absSeconds / Decimal.fromInt(3600)).floor();
      absSeconds -= Decimal.fromBigInt(hours) * Decimal.fromInt(3600);

      final minutes = (absSeconds / Decimal.fromInt(60)).floor();
      absSeconds -= Decimal.fromBigInt(minutes) * Decimal.fromInt(60);

      if (hours > BigInt.zero) {
        sb.write('${hours}H');
      }
      if (minutes > BigInt.zero) {
        sb.write('${minutes}M');
      }
      if (absSeconds > Decimal.zero) {
        // Remove trailing zeros and decimal point if integer
        String s = absSeconds.toString();
        if (s.contains('.') && s.endsWith('0')) {
          // Decimal package toString handles this well usually, but let's be safe if needed.
          // Actually Decimal.toString() is usually good.
        }
        sb.write('${s}S');
      }
    } else if (years == 0 && monthPart == 0 && days == BigInt.zero) {
      // Should have been handled by the zero check at start, but if we have 0 seconds but non-zero months/days, we don't write T.
      // If we are here, it means we had some months/days, so we don't need T part.
    }

    return sb.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XsdDuration &&
        other.months == months &&
        other.seconds == seconds;
  }

  @override
  int get hashCode => Object.hash(months, seconds);
}
