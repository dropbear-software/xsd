import 'package:meta/meta.dart';

/// A wrapper around [DateTime] that provides XSD-compliant handling of
/// `xsd:date` values.
///
/// `xsd:date` represents a calendar date (YYYY-MM-DD). Like `xsd:dateTime`,
/// it can be "floating" (timezone-less) or zoned.
///
/// This class ensures that the time components of the underlying [DateTime]
/// are always zero (00:00:00.000).
@immutable
class XsdDate implements Comparable<XsdDate> {
  /// The underlying [DateTime] value, always in UTC, with time components set to zero.
  final DateTime value;

  /// Whether the original input had no timezone (floating).
  final bool isFloating;

  /// The original timezone offset, if one was present.
  ///
  /// If [isFloating] is true, this will be null.
  final Duration? originalOffset;

  XsdDate(DateTime value, {this.isFloating = false, this.originalOffset})
    : value = DateTime.utc(value.year, value.month, value.day);

  // Regex for xsd:date
  // -?([1-9][0-9]{3,}|0[0-9]{3})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
  // Simplified for capture groups:
  // Group 1: Year
  // Group 2: Month
  // Group 3: Day
  // Group 4: Timezone (optional)
  static final _dateRegex = RegExp(
    r'^(-?\d{4,})-(\d{2})-(\d{2})(Z|[+-]\d{2}:\d{2})?$',
  );

  static final _offsetRegex = RegExp(r'([+-])(\d{2}):(\d{2})$');

  /// Parses an XSD date string.
  ///
  /// Throws a [FormatException] if the [input] is not a valid representation.
  static XsdDate parse(String input) {
    final match = _dateRegex.firstMatch(input);
    if (match == null) {
      throw FormatException('Invalid xsd:date format', input);
    }

    final yearStr = match.group(1)!;
    final monthStr = match.group(2)!;
    final dayStr = match.group(3)!;
    final tzStr = match.group(4);

    final year = int.parse(yearStr);
    final month = int.parse(monthStr);
    final day = int.parse(dayStr);

    // Validate day/month (basic check, DateTime handles leap years etc usually, but we might want strict XSD checks?)
    // XSD requires strict validation. DateTime.utc will wrap invalid days (e.g. April 31 -> May 1).
    // We should check if the created DateTime matches the input components.
    final dt = DateTime.utc(year, month, day);

    if (dt.month != month || dt.day != day) {
      throw FormatException('Invalid date components', input);
    }

    if (tzStr == null) {
      return XsdDate(dt, isFloating: true);
    } else {
      final Duration offset;
      if (tzStr == 'Z') {
        offset = Duration.zero;
      } else {
        // _dateRegex ensures tzStr is in [+-]HH:mm format, so a match is guaranteed.
        final tzMatch = _offsetRegex.firstMatch(tzStr)!;
        final sign = tzMatch.group(1) == '+' ? 1 : -1;
        final hours = int.parse(tzMatch.group(2)!);
        final minutes = int.parse(tzMatch.group(3)!);
        if (hours > 14 || minutes > 59 || (hours == 14 && minutes != 0)) {
          throw FormatException('Invalid timezone offset range', input);
        }
        offset = Duration(hours: hours, minutes: minutes) * sign;
      }
      return XsdDate(dt, isFloating: false, originalOffset: offset);
    }
  }

  /// Returns the ISO 8601 string representation (YYYY-MM-DD).
  @override
  String toString() {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final datePart = '$y-$m-$d';

    if (isFloating) {
      return datePart;
    }

    if (originalOffset != null && originalOffset != Duration.zero) {
      final sign = originalOffset!.isNegative ? '-' : '+';
      final absOffset = originalOffset!.abs();
      final hours = absOffset.inHours.toString().padLeft(2, '0');
      final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');
      return '$datePart$sign$hours:$minutes';
    }

    return '${datePart}Z';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XsdDate &&
        other.value == value &&
        other.isFloating == isFloating &&
        other.originalOffset == originalOffset;
  }

  @override
  int get hashCode => Object.hash(value, isFloating, originalOffset);

  /// Compares this [XsdDate] to [other].
  ///
  /// **Note**: This comparison treats "floating" (timezone-less) values as if
  /// they were in UTC. This deviates from the strict XSD specification which
  /// defines a partial ordering for floating vs zoned times. This choice was
  /// made to provide a consistent total ordering for Dart collections.
  @override
  int compareTo(XsdDate other) {
    return value.compareTo(other.value);
  }
}
