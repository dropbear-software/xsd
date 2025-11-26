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

  /// Parses an XSD dateTime string.
  ///
  /// Handles formats like:
  /// - `2002-10-10T12:00:00` (Floating)
  /// - `2002-10-10T12:00:00Z` (UTC)
  /// - `2002-10-10T12:00:00-05:00` (Offset)
  static XsdDateTime parse(String input) {
    // Regex to detect timezone presence.
    // Matches Z or +/-HH:MM at the end.
    final hasTimezone = RegExp(r'(Z|[+-]\d{2}:\d{2})$').hasMatch(input);

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
        // Format is +/-HH:MM
        final match = RegExp(r'([+-])(\d{2}):(\d{2})$').firstMatch(input);
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

  /// Returns the ISO 8601 string representation.
  ///
  /// If [isFloating] is true, the result will have no timezone.
  /// If [originalOffset] is present, the result will use that offset.
  /// Otherwise, it returns the UTC representation ('Z').
  @override
  String toString() {
    if (isFloating) {
      // Return ISO string without 'Z' or offset.
      // value is UTC, so toIso8601String() returns ...Z
      return value.toIso8601String().replaceAll('Z', '');
    }

    if (originalOffset != null && originalOffset != Duration.zero) {
      // We need to shift the UTC value back to the original offset for display.
      final localTime = value.add(originalOffset!);
      // iso is ...Z or ... depending on how it was created, but since we added offset manually
      // to a UTC date, the result is technically "what the time would be in that zone".
      // However, DateTime.toIso8601String() always ends in Z if isUtc is true,
      // or nothing if isUtc is false.
      // Since 'value' is UTC, 'localTime' is also UTC (just shifted).
      // We want to strip the Z and append the offset.

      // Remember that DateTime.add returns a DateTime with the same isUtc property.
      // So localTime is still UTC.
      // Example: 12:00Z + 5 hours = 17:00Z.
      // We want to print 17:00+05:00.
      final bareIso = localTime.toIso8601String().replaceAll('Z', '');

      final sign = originalOffset!.isNegative ? '-' : '+';
      final absOffset = originalOffset!.abs();
      final hours = absOffset.inHours.toString().padLeft(2, '0');
      final minutes = (absOffset.inMinutes % 60).toString().padLeft(2, '0');

      return '$bareIso$sign$hours:$minutes';
    }

    return value.toIso8601String();
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
