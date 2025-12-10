import 'package:meta/meta.dart';

/// A wrapper around [DateTime] that provides XSD-compliant handling of
/// `xsd:time` values.
///
/// `xsd:time` represents a time of day (HH:MM:SS). Like `xsd:dateTime`,
/// it can be "floating" (timezone-less) or zoned.
///
/// This class ensures that the date components of the underlying [DateTime]
/// are always set to 1970-01-01.
@immutable
class XsdTime implements Comparable<XsdTime> {
  /// The underlying [DateTime] value, always in UTC, with date components set to 1970-01-01.
  final DateTime value;

  /// Whether the original input had no timezone (floating).
  final bool isFloating;

  /// The original timezone offset, if one was present.
  ///
  /// If [isFloating] is true, this will be null.
  final Duration? originalOffset;

  XsdTime(DateTime value, {this.isFloating = false, this.originalOffset})
    : value = DateTime.utc(
        1970,
        1,
        1,
        value.hour,
        value.minute,
        value.second,
        value.millisecond,
        value.microsecond,
      ) {
    if (originalOffset != null) {
      if (originalOffset!.inMinutes.abs() > 14 * 60) {
        throw ArgumentError('Timezone offset must be within +/- 14 hours');
      }
    }
  }

  // Regex for xsd:time
  // (([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\.[0-9]+)?|(24:00:00(\.0+)?))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?
  // Simplified capture groups:
  // Group 1: Hour
  // Group 2: Minute
  // Group 3: Second
  // Group 4: Fractional seconds (optional)
  // Group 5: Timezone (optional)
  static final _timeRegex = RegExp(
    r'^(\d{2}):(\d{2}):(\d{2})(\.\d+)?(Z|[+-](?:(?:0\d|1[0-3]):[0-5]\d|14:00))?$',
  );

  static final _offsetRegex = RegExp(r'([+-])(\d{2}):(\d{2})$');

  /// Parses an XSD time string.
  ///
  /// Throws a [FormatException] if the [input] is not a valid representation.
  static XsdTime parse(String input) {
    // Special case for 24:00:00 which is valid in XSD but not in DateTime
    if (input.startsWith('24:00:00')) {
      // Check if it has fractional seconds that are all zero
      final fractionalMatch = RegExp(r'^24:00:00(\.0+)?').firstMatch(input);
      if (fractionalMatch != null) {
        final rest = input.substring(fractionalMatch.end);
        // If rest is empty or just timezone, it's midnight of the next day,
        // but for xsd:time it's just 00:00:00.
        // We'll treat it as 00:00:00.
        // We need to handle the timezone part if present.
        String effectiveInput = '00:00:00$rest';
        return parse(effectiveInput);
      }
    }

    final match = _timeRegex.firstMatch(input);
    if (match == null) {
      throw FormatException('Invalid xsd:time format', input);
    }

    final hourStr = match.group(1)!;
    final minuteStr = match.group(2)!;
    final secondStr = match.group(3)!;
    final fractionStr = match.group(4);
    final tzStr = match.group(5);

    final hour = int.parse(hourStr);
    final minute = int.parse(minuteStr);
    final second = int.parse(secondStr);

    int millisecond = 0;
    int microsecond = 0;

    if (fractionStr != null) {
      // fractionStr includes the dot, e.g. ".123"
      final fractionalPart = double.parse(fractionStr);
      final ms = (fractionalPart * 1000).round();
      millisecond = ms % 1000;
      microsecond = ((fractionalPart * 1000000).round()) % 1000;
    }

    // Validate time components
    if (hour > 24 ||
        (hour == 24 &&
            (minute > 0 || second > 0 || millisecond > 0 || microsecond > 0))) {
      throw FormatException('Invalid time components', input);
    }
    if (minute > 59) {
      throw FormatException('Invalid minute component', input);
    }
    if (second > 59) {
      throw FormatException('Invalid second component', input);
    }

    // We use 1970-01-01 as the base date
    final dt = DateTime.utc(
      1970,
      1,
      1,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );

    if (tzStr == null) {
      return XsdTime(dt, isFloating: true);
    } else {
      Duration? offset;
      if (tzStr == 'Z') {
        offset = Duration.zero;
      } else {
        final tzMatch = _offsetRegex.firstMatch(tzStr);
        if (tzMatch != null) {
          final sign = tzMatch.group(1) == '+' ? 1 : -1;
          final hours = int.parse(tzMatch.group(2)!);
          final minutes = int.parse(tzMatch.group(3)!);
          offset = Duration(hours: hours, minutes: minutes) * sign;
        }
      }
      return XsdTime(dt, isFloating: false, originalOffset: offset);
    }
  }

  /// Returns the ISO 8601 string representation (HH:MM:SS).
  @override
  String toString() {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    final s = value.second.toString().padLeft(2, '0');

    var timePart = '$h:$m:$s';

    if (value.millisecond > 0 || value.microsecond > 0) {
      final ms = value.millisecond.toString().padLeft(3, '0');
      final us = (value.microsecond > 0)
          ? value.microsecond.toString().padLeft(3, '0')
          : '';
      // Remove trailing zeros if any? XSD doesn't strictly require it but canonical usually does.
      // For now let's keep it simple and consistent with XsdDateTime
      timePart = '$timePart.$ms$us';
      // Strip trailing zeros from fraction
      timePart = timePart.replaceAll(RegExp(r'0+$'), '');
      if (timePart.endsWith('.')) {
        timePart = timePart.substring(0, timePart.length - 1);
      }
    }

    if (isFloating) {
      return timePart;
    }

    if (originalOffset != null && originalOffset != Duration.zero) {
      final sign = originalOffset!.isNegative ? '-' : '+';
      final absOffset = originalOffset!.abs();
      final hours = absOffset.inHours.toString().padLeft(2, '0');
      final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');
      return '$timePart$sign$hours:$minutes';
    }

    return '${timePart}Z';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XsdTime &&
        other.value == value &&
        other.isFloating == isFloating &&
        other.originalOffset == originalOffset;
  }

  @override
  int get hashCode => Object.hash(value, isFloating, originalOffset);

  /// Compares this [XsdTime] to [other].
  ///
  /// **Note**: This comparison treats "floating" (timezone-less) values as if
  /// they were in UTC.
  @override
  int compareTo(XsdTime other) {
    return value.compareTo(other.value);
  }
}
