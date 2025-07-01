import 'package:meta/meta.dart';

import '../helpers/whitespace.dart';

/// Represents an xsd:gMonth value.
///
/// A gMonth is a specific month of a year, independent of the year itself.
/// It has a month and an optional timezone.
///
/// See [XSD gMonth](https://www.w3.org/TR/xmlschema11-2/#gMonth).
@immutable
class GregorianMonth {
  /// The month component of this gMonth, from 1 (January) to 12 (December).
  final int month;

  /// Optional timezone offset in minutes from UTC.
  ///
  /// A positive value indicates a timezone east of UTC, negative for west.
  /// `null` means no timezone is specified.
  final int? timezoneOffsetInMinutes;

  /// Constructs a [GregorianMonth] instance.
  ///
  /// The [month] must be between 1 and 12.
  /// The [timezoneOffsetInMinutes], if provided, must be between -840 and 840.
  GregorianMonth(this.month, {this.timezoneOffsetInMinutes}) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(
        month,
        'month',
        'Month must be between 1 and 12',
      );
    }
    const minOffset = -14 * 60;
    const maxOffset = 14 * 60;
    if (timezoneOffsetInMinutes != null) {
      if (timezoneOffsetInMinutes! < minOffset ||
          timezoneOffsetInMinutes! > maxOffset) {
        throw ArgumentError.value(
          timezoneOffsetInMinutes,
          'timezoneOffsetInMinutes',
          'Timezone offset must be between -PT14H and PT14H ($minOffset and $maxOffset minutes)',
        );
      }
    }
  }

  /// Parses a string in XSD gMonth format into a [GregorianMonth] object.
  ///
  /// The expected format is `--MM` with an optional timezone suffix
  /// (e.g., "--10", "--05Z", "--12+05:30").
  ///
  /// Throws a [FormatException] if the input string is not a valid gMonth.
  static GregorianMonth parse(String lexicalForm) {
    final String collapsedInput = processWhiteSpace(
      lexicalForm,
      Whitespace.collapse,
    );

    // Regular expression for gMonth: --MM(Z|(+|-)HH:MM)?
    // Month part: (0[1-9]|1[0-2])
    // Timezone part: (Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
    final RegExp gMonthPattern = RegExp(
      r'^--(0[1-9]|1[0-2])(Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$',
    );

    final Match? match = gMonthPattern.firstMatch(collapsedInput);

    if (match == null) {
      throw FormatException(
        "Invalid gMonth format: '$lexicalForm' (collapsed to '$collapsedInput')",
      );
    }

    final String monthStr = match.group(1)!;
    final String? timezoneStr = match.group(2); // This group is optional

    final int month;
    try {
      month = int.parse(monthStr);
    } catch (e) {
      throw FormatException(
        "Invalid month component in gMonth: '$monthStr'",
        collapsedInput,
      );
    }

    // Redundant check as regex should ensure this, but good for safety.
    if (month < 1 || month > 12) {
      throw FormatException(
        "Month value '$monthStr' is out of range (1-12).",
        collapsedInput,
      );
    }

    int? timezoneOffsetMinutes;
    if (timezoneStr != null) {
      if (timezoneStr == 'Z') {
        timezoneOffsetMinutes = 0;
      } else {
        final int sign = timezoneStr.startsWith('+') ? 1 : -1;
        final parts = timezoneStr.substring(1).split(':');
        final int hours = int.parse(parts[0]);
        final int minutes = int.parse(parts[1]);
        timezoneOffsetMinutes = sign * (hours * 60 + minutes);
      }
    }

    return GregorianMonth(
      month,
      timezoneOffsetInMinutes: timezoneOffsetMinutes,
    );
  }

  /// Returns the canonical lexical representation of this [GregorianMonth].
  ///
  /// Format is "--MM" e.g., "--10".
  /// If a timezone is present, it's appended (e.g., "--05Z", "--12+05:30").
  @override
  String toString() {
    final String monthString = month.toString().padLeft(2, '0');
    String result = '--$monthString';

    if (timezoneOffsetInMinutes != null) {
      if (timezoneOffsetInMinutes == 0) {
        result += 'Z';
      } else {
        final int offset = timezoneOffsetInMinutes!;
        final String sign = offset.isNegative ? '-' : '+';
        final int absOffset = offset.abs();
        final String hours = (absOffset ~/ 60).toString().padLeft(2, '0');
        final String minutes = (absOffset % 60).toString().padLeft(2, '0');
        result += '$sign$hours:$minutes';
      }
    }
    return result;
  }

  /// Creates a new [GregorianMonth] instance with the given fields updated.
  GregorianMonth copyWith({
    int? month,
    int? timezoneOffsetInMinutes,
    bool setToNoTimezone = false, // Special flag to remove timezone
  }) {
    return GregorianMonth(
      month ?? this.month,
      timezoneOffsetInMinutes:
          timezoneOffsetInMinutes ??
          (setToNoTimezone ? null : this.timezoneOffsetInMinutes),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GregorianMonth &&
        other.month == month &&
        other.timezoneOffsetInMinutes == timezoneOffsetInMinutes;
  }

  @override
  int get hashCode => Object.hash(month, timezoneOffsetInMinutes);
}
