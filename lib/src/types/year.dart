import 'package:meta/meta.dart';

import '../helpers/whitespace.dart';

/// Represents an xsd:gYear value.
///
/// A gYear is a specific Gregorian year.
///
/// See [XSD gYear](https://www.w3.org/TR/xmlschema11-2/#gYear).
@immutable
class Year {
  /// The year component of this gYear.
  ///
  /// Can be negative (representing BCE years) or positive.
  /// Year 0 represents 1 BCE. Year -1 represents 2 BCE, etc.
  final int year;

  /// Optional timezone offset in minutes from UTC.
  ///
  /// A positive value indicates a timezone east of UTC, negative for west.
  /// `null` means no timezone is specified.
  final int? timezoneOffsetInMinutes;

  /// Constructs a [Year] instance.
  ///
  /// The [year] can be any integer.
  /// The [timezoneOffsetInMinutes], if provided, must be between -840 and 840.
  Year(this.year, {this.timezoneOffsetInMinutes}) {
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

  /// Parses a string in XSD gYear format into a [Year] object.
  ///
  /// The expected format is `CCYY` with an optional timezone suffix
  /// (e.g., "2023", "2023Z", "2023+05:30", "-0001" for 2 BCE).
  ///
  /// Throws a [FormatException] if the input string is not a valid gYear.
  static Year parse(String lexicalForm) {
    final String collapsedInput = processWhiteSpace(
      lexicalForm,
      Whitespace.collapse,
    );

    // Regular expression for gYear: CCYY(Z|(+|-)HH:MM)?
    // Year part: -?([1-9][0-9]{3,}|0[0-9]{3})
    // Timezone part: (Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
    final RegExp gYearPattern = RegExp(
      r'^(-?(?:[1-9][0-9]{3,}|0[0-9]{3}))(Z|(?:\+|-)(?:(?:0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$',
    );

    final Match? match = gYearPattern.firstMatch(collapsedInput);

    if (match == null) {
      throw FormatException(
        "Invalid gYear format: '$lexicalForm' (collapsed to '$collapsedInput')",
      );
    }

    final String yearStr = match.group(1)!;
    final String? timezoneStr = match.group(2); // This group is optional

    final int year;
    try {
      year = int.parse(yearStr);
    } catch (e) {
      throw FormatException(
        "Invalid year component in gYear: '$yearStr'",
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

    return Year(
      year,
      timezoneOffsetInMinutes: timezoneOffsetMinutes,
    );
  }

  /// Returns the canonical lexical representation of this [Year].
  ///
  /// Format is "CCYY" e.g., "2023".
  /// If a timezone is present, it's appended (e.g., "2023Z", "2023+05:30").
  @override
  String toString() {
    String yearString;
    if (year >= 0) {
      yearString = year.toString().padLeft(4, '0');
    } else {
      // For negative years, XSD spec requires a leading '-' and then
      // the absolute value of the year, padded if necessary.
      // e.g., year -1 (2 BCE) is "-0001", year -12345 is "-12345"
      yearString = '-${year.abs().toString().padLeft(4, '0')}';
    }

    String result = yearString;

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

  /// Creates a new [Year] instance with the given fields updated.
  Year copyWith({
    int? year,
    int? timezoneOffsetInMinutes,
    bool setToNoTimezone = false, // Special flag to remove timezone
  }) {
    return Year(
      year ?? this.year,
      timezoneOffsetInMinutes:
          timezoneOffsetInMinutes ??
          (setToNoTimezone ? null : this.timezoneOffsetInMinutes),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Year &&
        other.year == year &&
        other.timezoneOffsetInMinutes == timezoneOffsetInMinutes;
  }

  @override
  int get hashCode => Object.hash(year, timezoneOffsetInMinutes);
}
