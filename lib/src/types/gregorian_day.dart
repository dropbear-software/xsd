import 'package:meta/meta.dart';

import '../helpers/whitespace.dart';

/// Represents an xsd:gDay value.
///
/// A gDay is a specific day of the month, independent of the month or year.
/// It has a day and an optional timezone.
///
/// See [XSD gDay](https://www.w3.org/TR/xmlschema11-2/#gDay).
@immutable
class GregorianDay {
  /// The day component of this gDay, from 1 to 31.
  final int day;

  /// Optional timezone offset in minutes from UTC.
  ///
  /// A positive value indicates a timezone east of UTC, negative for west.
  /// `null` means no timezone is specified.
  final int? timezoneOffsetInMinutes;

  /// Constructs a [GregorianDay] instance.
  ///
  /// The [day] must be between 1 and 31.
  /// The [timezoneOffsetInMinutes], if provided, must be between -840 and 840.
  GregorianDay(this.day, {this.timezoneOffsetInMinutes}) {
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'Day must be between 1 and 31');
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

  /// Parses a string in XSD gDay format into a [GregorianDay] object.
  ///
  /// The expected format is `---DD` with an optional timezone suffix
  /// (e.g., "---10", "---05Z", "---12+05:30").
  ///
  /// Throws a [FormatException] if the input string is not a valid gDay.
  static GregorianDay parse(String lexicalForm) {
    final String collapsedInput = processWhiteSpace(
      lexicalForm,
      Whitespace.collapse,
    );

    // Regular expression for gDay: ---DD(Z|(+|-)HH:MM)?
    // Day part: (0[1-9]|[12][0-9]|3[01])
    // Timezone part: (Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
    final RegExp gDayPattern = RegExp(
      r'^---(0[1-9]|[12][0-9]|3[01])(Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$',
    );

    final Match? match = gDayPattern.firstMatch(collapsedInput);

    if (match == null) {
      throw FormatException(
        "Invalid gDay format: '$lexicalForm' (collapsed to '$collapsedInput')",
      );
    }

    final String dayStr = match.group(1)!;
    final String? timezoneStr = match.group(2); // This group is optional

    final int day;
    try {
      day = int.parse(dayStr);
    } catch (e) {
      throw FormatException(
        "Invalid day component in gDay: '$dayStr'",
        collapsedInput,
      );
    }

    // Redundant check as regex should ensure this, but good for safety.
    if (day < 1 || day > 31) {
      throw FormatException(
        "Day value '$dayStr' is out of range (1-31).",
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

    return GregorianDay(day, timezoneOffsetInMinutes: timezoneOffsetMinutes);
  }

  /// Returns the canonical lexical representation of this [GregorianDay].
  ///
  /// Format is "---DD" e.g., "---10".
  /// If a timezone is present, it's appended (e.g., "---05Z", "---12+05:30").
  @override
  String toString() {
    final dayString = day.toString().padLeft(2, '0');
    final buffer = StringBuffer('---$dayString');

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

  /// Creates a new [GregorianDay] instance with the given fields updated.
  GregorianDay copyWith({
    int? day,
    int? timezoneOffsetInMinutes,
    bool setToNoTimezone = false, // Special flag to remove timezone
  }) {
    return GregorianDay(
      day ?? this.day,
      timezoneOffsetInMinutes:
          timezoneOffsetInMinutes ??
          (setToNoTimezone ? null : this.timezoneOffsetInMinutes),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GregorianDay &&
        other.day == day &&
        other.timezoneOffsetInMinutes == timezoneOffsetInMinutes;
  }

  @override
  int get hashCode => Object.hash(day, timezoneOffsetInMinutes);
}
