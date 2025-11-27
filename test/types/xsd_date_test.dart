import 'package:test/test.dart';
import 'package:xsd/src/types/xsd_date.dart';

void main() {
  group('XsdDate', () {
    test('parses floating date', () {
      final d = XsdDate.parse('2002-10-10');
      expect(d.isFloating, isTrue);
      expect(d.value.isUtc, isTrue);
      expect(d.value.year, 2002);
      expect(d.value.month, 10);
      expect(d.value.day, 10);
      expect(d.value.hour, 0);
      expect(d.value.minute, 0);
      expect(d.value.second, 0);
      expect(d.originalOffset, isNull);
      expect(d.toString(), '2002-10-10');
    });

    test('parses UTC date', () {
      final d = XsdDate.parse('2002-10-10Z');
      expect(d.isFloating, isFalse);
      expect(d.value.isUtc, isTrue);
      expect(d.originalOffset, Duration.zero);
      expect(d.toString(), '2002-10-10Z');
    });

    test('parses offset date', () {
      final d = XsdDate.parse('2002-10-10-05:00');
      expect(d.isFloating, isFalse);
      expect(d.value.isUtc, isTrue);
      expect(d.originalOffset, const Duration(hours: -5));
      expect(d.toString(), '2002-10-10-05:00');
    });

    test('parses positive offset date', () {
      final d = XsdDate.parse('2002-10-10+05:30');
      expect(d.isFloating, isFalse);
      expect(d.value.isUtc, isTrue);
      expect(d.originalOffset, const Duration(hours: 5, minutes: 30));
      expect(d.toString(), '2002-10-10+05:30');
    });

    test('throws FormatException on invalid format', () {
      expect(
        () => XsdDate.parse('2002-10-10T12:00:00'),
        throwsFormatException,
      ); // dateTime format
      expect(
        () => XsdDate.parse('2002-10'),
        throwsFormatException,
      ); // gYearMonth format
      expect(
        () => XsdDate.parse('2002-13-10'),
        throwsFormatException,
      ); // Invalid month
      expect(
        () => XsdDate.parse('2002-02-30'),
        throwsFormatException,
      ); // Invalid day
      expect(
        () => XsdDate.parse('2002-10-10+15:00'), // Hour > 14
        throwsFormatException,
      );
      expect(
        () => XsdDate.parse('2002-10-10-14:01'), // Minute > 00 when hour is 14
        throwsFormatException,
      );
    });

    test('equality', () {
      final d1 = XsdDate.parse('2002-10-10');
      final d2 = XsdDate.parse('2002-10-10');
      final d3 = XsdDate.parse('2002-10-10Z');

      expect(d1, equals(d2));
      expect(d1.hashCode, equals(d2.hashCode));
      expect(d1, isNot(equals(d3))); // Floating != Zoned
    });

    test('compareTo', () {
      final d1 = XsdDate.parse('2002-10-10'); // Floating (treated as UTC)
      final d2 = XsdDate.parse('2002-10-11Z'); // UTC

      expect(d1.compareTo(d2), lessThan(0));
    });
  });
}
