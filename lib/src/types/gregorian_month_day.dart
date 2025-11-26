import 'package:meta/meta.dart';

import '../helpers/whitespace.dart';

/// Represents an xsd:gMonthDay value.
///
/// A gMonthDay is a specific day of a specific month, independent of the year.
/// It has a month, a day, and an optional timezone.
///
/// See [XSD gMonthDay](https://www.w3.org/TR/xmlschema11-2/#gMonthDay).
@immutable
class GregorianMonthDay {
  /// The month component of this gMonthDay, from 1 (January) to 12 (December).
  final int month;

  /// The day component of this gMonthDay, from 1 to 31.
  final int day;

  /// Optional timezone offset in minutes from UTC.
  ///
  /// A positive value indicates a timezone east of UTC, negative for west.
  /// `null` means no timezone is specified.
  final int? timezoneOffsetInMinutes;

  /// Constructs a [GregorianMonthDay] instance.
  ///
  /// The [month] must be between 1 and 12.
  /// The [day] must be valid for the given [month] (e.g., 30 for April, 31 for January).
  /// February 29 is allowed.
  /// The [timezoneOffsetInMinutes], if provided, must be between -840 and 840.
  GregorianMonthDay(this.month, this.day, {this.timezoneOffsetInMinutes}) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(
        month,
        'month',
        'Month must be between 1 and 12',
      );
    }
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'Day must be between 1 and 31');
    }
    // Validate day against month
    final maxDays = _daysInMonth(month);
    if (day > maxDays) {
      throw ArgumentError.value(
        day,
        'day',
        'Day must be between 1 and $maxDays for month $month',
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

  static int _daysInMonth(int month) {
    switch (month) {
      case 2:
        return 29; // gMonthDay allows Feb 29
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  /// Parses a string in XSD gMonthDay format into a [GregorianMonthDay] object.
  ///
  /// The expected format is `--MM-DD` with an optional timezone suffix
  /// (e.g., "--10-25", "--02-29Z", "--12-31+05:30").
  ///
  /// Throws a [FormatException] if the input string is not a valid gMonthDay.
  static GregorianMonthDay parse(String lexicalForm) {
    final String collapsedInput = processWhiteSpace(
      lexicalForm,
      Whitespace.collapse,
    );

    // Regular expression for gMonthDay: --MM-DD(Z|(+|-)HH:MM)?
    // Month part: (0[1-9]|1[0-2])
    // Day part: (0[1-9]|[12][0-9]|3[01])
    // Timezone part: (Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
    final RegExp gMonthDayPattern = RegExp(
      r'^--(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])(Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$',
    );

    final Match? match = gMonthDayPattern.firstMatch(collapsedInput);

    if (match == null) {
      throw FormatException(
        "Invalid gMonthDay format: '$lexicalForm' (collapsed to '$collapsedInput')",
      );
    }

    final String monthStr = match.group(1)!;
    final String dayStr = match.group(2)!;
    final String? timezoneStr = match.group(3); // This group is optional

    final int month;
    try {
      month = int.parse(monthStr);
    } catch (e) {
      throw FormatException(
        "Invalid month component in gMonthDay: '$monthStr'",
        collapsedInput,
      );
    }

    final int day;
    try {
      day = int.parse(dayStr);
    } catch (e) {
      throw FormatException(
        "Invalid day component in gMonthDay: '$dayStr'",
        collapsedInput,
      );
    }

    // Validate day against month logic (regex is loose on 30/31 days for some months)
    final maxDays = _daysInMonth(month);
    if (day > maxDays) {
      throw FormatException(
        "Day value '$dayStr' is invalid for month '$monthStr' (max $maxDays).",
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

    return GregorianMonthDay(
      month,
      day,
      timezoneOffsetInMinutes: timezoneOffsetMinutes,
    );
  }

  /// Returns the canonical lexical representation of this [GregorianMonthDay].
  ///
  /// Format is "--MM-DD" e.g., "--10-25".
  /// If a timezone is present, it's appended (e.g., "--05-20Z", "--12-01+05:30").
  @override
  String toString() {
    final monthString = month.toString().padLeft(2, '0');
    final dayString = day.toString().padLeft(2, '0');
    final buffer = StringBuffer('--$monthString-$dayString');

    if (timezoneOffsetInMinutes != null) {
      if (timezoneOffsetInMinutes == 0) {
        buffer.write('Z');
      } else {
        final int offset = timezoneOffsetInMinutes!;
        final String sign = offset.isNegative ? '-' : '+';
        final int absOffset = offset.abs();
        final String hours = (absOffset ~/ 60).toString().padLeft(2, '0');
        final String minutes = (absOffset % 60).toString().padLeft(2, '0');
        buffer.write('$sign$hours:$minutes');
      }
    }
    return buffer.toString();
  }

  /// Creates a new [GregorianMonthDay] instance with the given fields updated.
  GregorianMonthDay copyWith({
    int? month,
    int? day,
    int? timezoneOffsetInMinutes,
    bool setToNoTimezone = false, // Special flag to remove timezone
  }) {
    return GregorianMonthDay(
      month ?? this.month,
      day ?? this.day,
      timezoneOffsetInMinutes:
          timezoneOffsetInMinutes ??
          (setToNoTimezone ? null : this.timezoneOffsetInMinutes),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GregorianMonthDay &&
        other.month == month &&
        other.day == day &&
        other.timezoneOffsetInMinutes == timezoneOffsetInMinutes;
  }

  @override
  int get hashCode => Object.hash(month, day, timezoneOffsetInMinutes);
}
