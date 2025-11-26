import 'package:meta/meta.dart';

/// A wrapper around [DateTime] that provides XSD-compliant handling of
/// `xsd:dateTime` values, specifically regarding "floating" (timezone-less)
/// values.
///
/// In XSD, a `dateTime` without a timezone is considered "floating" and is
/// partially ordered (incomparable) with zoned times. However, for pragmatic
/// usage in Dart, this class treats floating times as if they were in UTC
/// for comparison purposes (`compareTo`).
///
/// This class preserves the original timezone offset if one was present in the
/// input string, allowing for round-tripping.
@immutable
class XsdDateTime implements Comparable<XsdDateTime> {
  /// The underlying [DateTime] value, always in UTC.
  final DateTime value;

  /// Whether the original input had no timezone (floating).
  final bool isFloating;

  /// The original timezone offset, if one was present.
  ///
  /// If [isFloating] is true, this will be null.
  final Duration? originalOffset;

  XsdDateTime(DateTime value, {this.isFloating = false, this.originalOffset})
      : value = value.toUtc();

  // Regex to detect timezone presence.
  // Matches Z or +/-HH:MM at the end.
  static final _timezoneRegex = RegExp(r'(Z|[+-]\d{2}:\d{2})$');

  // Format is +/-HH:MM
  static final _offsetRegex = RegExp(r'([+-])(\d{2}):(\d{2})$');

  /// Parses an XSD dateTime string.
  ///
  /// Throws a [FormatException] if the [input] is not a valid representation.
  ///
  /// Handles formats like:
  /// - `2002-10-10T12:00:00` (Floating)
  /// - `2002-10-10T12:00:00Z` (UTC)
  /// - `2002-10-10T12:00:00-05:00` (Offset)
  static XsdDateTime parse(String input) {
    final hasTimezone = _timezoneRegex.hasMatch(input);

    if (!hasTimezone) {
      // Floating time. Parse as if it were UTC to avoid local timezone interference.
      // We append 'Z' to force DateTime.parse to treat it as UTC, then strip it conceptually.
      // Actually, DateTime.parse handles '2002-10-10T12:00:00' as local.
      // To ensure we store the exact values provided without local conversion,
      // we can append 'Z' to the input string before parsing.
      final utcInput = '${input}Z';
      final dt = DateTime.parse(utcInput);
      return XsdDateTime(dt, isFloating: true);
    } else {
      final dt = DateTime.parse(input);
      Duration? offset;

      if (input.endsWith('Z')) {
        offset = Duration.zero;
      } else {
        // Extract offset manually because DateTime doesn't expose the original offset
        // if it converts to UTC/Local.
        final match = _offsetRegex.firstMatch(input);
        if (match != null) {
          final sign = match.group(1) == '+' ? 1 : -1;
          final hours = int.parse(match.group(2)!);
          final minutes = int.parse(match.group(3)!);
          offset = Duration(hours: hours, minutes: minutes) * sign;
        }
      }

      return XsdDateTime(dt, isFloating: false, originalOffset: offset);
    }
  }

  /// Formats the [DateTime] into a string, omitting fractional seconds if they are zero.
  String _formatDateTime(DateTime dt) {
    // Manually build the string to control fractional seconds.
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');

    var result = '$y-$m-${d}T$h:$min:$s';

    // Add fractional seconds only if they are not zero.
    if (dt.millisecond > 0 || dt.microsecond > 0) {
      final ms = dt.millisecond.toString().padLeft(3, '0');
      final us = (dt.microsecond > 0)
          ? (dt.microsecond % 1000).toString().padLeft(3, '0')
          : '';
      result = '$result.$ms$us';
    }

    return result;
  }

  /// Returns the ISO 8601 string representation.
  ///
  /// If [isFloating] is true, the result will have no timezone.
  /// If [originalOffset] is present, the result will use that offset.
  /// Otherwise, it returns the UTC representation ('Z').
  @override
  String toString() {
    if (isFloating) {
      return _formatDateTime(value);
    }

    if (originalOffset != null && originalOffset != Duration.zero) {
      final localTime = value.add(originalOffset!);
      final bareIso = _formatDateTime(localTime);

      final sign = originalOffset!.isNegative ? '-' : '+';
      final absOffset = originalOffset!.abs();
      final hours = absOffset.inHours.toString().padLeft(2, '0');
      final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');

      return '$bareIso$sign$hours:$minutes';
    }

    return '${_formatDateTime(value)}Z';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XsdDateTime &&
        other.value == value &&
        other.isFloating == isFloating &&
        other.originalOffset == originalOffset;
  }

  @override
  int get hashCode => Object.hash(value, isFloating, originalOffset);

  /// Compares this [XsdDateTime] to [other].
  ///
  /// **Note**: This comparison treats "floating" (timezone-less) values as if
  /// they were in UTC. This deviates from the strict XSD specification which
  /// defines a partial ordering for floating vs zoned times. This choice was
  /// made to provide a consistent total ordering for Dart collections.
  @override
  int compareTo(XsdDateTime other) {
    return value.compareTo(other.value);
  }
}
