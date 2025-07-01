import 'package:meta/meta.dart';

import '../helpers/whitespace.dart';

/// Represents an xsd:gYearMonth value.
///
/// A gYearMonth is a specific month in a specific year.
/// It has a year and a month.
///
/// See [XSD gYearMonth](https://www.w3.org/TR/xmlschema11-2/#gYearMonth).
@immutable
class YearMonth {
  /// The year component of this gYearMonth.
  ///
  /// Can be negative (representing BCE years) or positive.
  /// Year 0 represents 1 BCE. Year -1 represents 2 BCE, etc.
  final int year;

  /// The month component of this gYearMonth, from 1 (January) to 12 (December).
  final int month;

  /// Optional timezone offset in minutes from UTC.
  ///
  /// A positive value indicates a timezone east of UTC, negative for west.
  /// `null` means no timezone is specified.
  final int? timezoneOffsetInMinutes;

  /// Constructs a [YearMonth] instance.
  ///
  /// The [year] can be any integer.
  /// The [month] must be between 1 and 12.
  /// The [timezoneOffsetInMinutes], if provided, must be between -840 and 840.
  YearMonth(this.year, this.month, {this.timezoneOffsetInMinutes}) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(
        month,
        'month',
        'Month must be between 1 and 12',
      );
    }
    if (timezoneOffsetInMinutes != null) {
      if (timezoneOffsetInMinutes! < -14 * 60 ||
          timezoneOffsetInMinutes! > 14 * 60) {
        throw ArgumentError.value(
          timezoneOffsetInMinutes,
          'timezoneOffsetInMinutes',
          'Timezone offset must be between -PT14H and PT14H',
        );
      }
    }
  }

  /// Parses a string in XSD gYearMonth format into a [YearMonth] object.
  ///
  /// The expected format is `CCYY-MM` with an optional timezone suffix
  /// (e.g., "2023-10", "2023-10Z", "2023-10+05:30", "-0001-01" for 2 BCE, January).
  ///
  /// Throws a [FormatException] if the input string is not a valid gYearMonth.
  static YearMonth parse(String lexicalForm) {
    final String collapsedInput = processWhiteSpace(
      lexicalForm,
      Whitespace.collapse,
    );

    // Regular expression for gYearMonth: CCYY-MM(Z|(+|-)HH:MM)?
    // Year part: -?([1-9][0-9]{3,}|0[0-9]{3})
    // Month part: (0[1-9]|1[0-2])
    // Timezone part: (Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
    // Original Regex with named groups for reference:
    // r'^(?<year>-?(?:[1-9][0-9]{3,}|0[0-9]{3}))-(?<month>0[1-9]|1[0-2])(?<timezone>Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$');
    // Regex without named groups (groups accessed by index):
    // Group 1: year
    // Group 2: month
    // Group 3: timezone (optional, includes Z or +/-HH:MM)
    final RegExp gYearMonthPattern = RegExp(
      r'^(-?(?:[1-9][0-9]{3,}|0[0-9]{3}))-(0[1-9]|1[0-2])(Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$',
    );

    final Match? match = gYearMonthPattern.firstMatch(collapsedInput);

    if (match == null) {
      throw FormatException(
        "Invalid gYearMonth format: '$lexicalForm' (collapsed to '$collapsedInput')",
      );
    }

    final String yearStr = match.group(1)!;
    final String monthStr = match.group(2)!;
    final String? timezoneStr = match.group(3); // This group is optional

    final int year;
    try {
      year = int.parse(yearStr);
    } catch (e) {
      throw FormatException(
        "Invalid year component in gYearMonth: '$yearStr'",
        collapsedInput,
      );
    }

    final int month;
    try {
      month = int.parse(monthStr);
    } catch (e) {
      throw FormatException(
        "Invalid month component in gYearMonth: '$monthStr'",
        collapsedInput,
      );
    }

    if (month < 1 || month > 12) {
      // This should be caught by the regex, but as a safeguard:
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

    return YearMonth(
      year,
      month,
      timezoneOffsetInMinutes: timezoneOffsetMinutes,
    );
  }

  /// Returns the canonical lexical representation of this [YearMonth].
  ///
  /// Format is "CCYY-MM" e.g., "2023-10".
  /// If a timezone is present, it's appended (e.g., "2023-10Z", "2023-10+05:30").
  @override
  String toString() {
    String yearString;
    if (year < -9999 || year > 9999) {
      // Years outside -9999 to 9999 require more than 4 digits or a sign
      yearString =
          (year < 0 ? '-' : '') + year.abs().toString().padLeft(4, '0');
    } else if (year >= 0 && year <= 9999) {
      yearString = year.toString().padLeft(4, '0');
    } else {
      // year < 0 and year >= -9999
      yearString = '-${year.abs().toString().padLeft(4, '0')}';
    }

    final String monthString = month.toString().padLeft(2, '0');
    String result = '$yearString-$monthString';

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

  /// Creates a new [YearMonth] instance with the given fields updated.
  YearMonth copyWith({
    int? year,
    int? month,
    int? timezoneOffsetInMinutes,
    bool setToNoTimezone = false, // Special flag to remove timezone
  }) {
    return YearMonth(
      year ?? this.year,
      month ?? this.month,
      timezoneOffsetInMinutes:
          timezoneOffsetInMinutes ??
          (setToNoTimezone ? null : this.timezoneOffsetInMinutes),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YearMonth &&
        other.year == year &&
        other.month == month &&
        other.timezoneOffsetInMinutes == timezoneOffsetInMinutes;
  }

  @override
  int get hashCode => Object.hash(year, month, timezoneOffsetInMinutes);
}
