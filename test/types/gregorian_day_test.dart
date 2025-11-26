import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_day.dart';

void main() {
  group('GregorianDay', () {
    group('Constructor and Properties', () {
      test('should create a valid GregorianDay object', () {
        final gd = GregorianDay(10);
        expect(gd.day, 10);
        expect(gd.timezoneOffsetInMinutes, isNull);
      });

      test('should create a valid GregorianDay object with timezone', () {
        final gd = GregorianDay(10, timezoneOffsetInMinutes: 60);
        expect(gd.day, 10);
        expect(gd.timezoneOffsetInMinutes, 60);
      });

      test('should throw ArgumentError for invalid day', () {
        expect(() => GregorianDay(0), throwsArgumentError);
        expect(() => GregorianDay(32), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid timezone offset', () {
        expect(
          () => GregorianDay(10, timezoneOffsetInMinutes: -15 * 60),
          throwsArgumentError,
        );
        expect(
          () => GregorianDay(10, timezoneOffsetInMinutes: 15 * 60),
          throwsArgumentError,
        );
      });
    });

    group('Parsing', () {
      test('should parse valid gDay string without timezone', () {
        final gd = GregorianDay.parse("---10");
        expect(gd.day, 10);
        expect(gd.timezoneOffsetInMinutes, isNull);
      });

      test('should parse valid gDay string with Z timezone', () {
        final gd = GregorianDay.parse("---05Z");
        expect(gd.day, 5);
        expect(gd.timezoneOffsetInMinutes, 0);
      });

      test('should parse valid gDay string with positive timezone offset', () {
        final gd = GregorianDay.parse("---12+05:30");
        expect(gd.day, 12);
        expect(gd.timezoneOffsetInMinutes, 330);
      });

      test('should parse valid gDay string with negative timezone offset', () {
        final gd = GregorianDay.parse("---03-08:00");
        expect(gd.day, 3);
        expect(gd.timezoneOffsetInMinutes, -480);
      });

      test('should throw FormatException for invalid format', () {
        expect(() => GregorianDay.parse("10"), throwsFormatException);
        expect(
          () => GregorianDay.parse("--10"),
          throwsFormatException,
        ); // Missing hyphen
        expect(() => GregorianDay.parse("---0"), throwsFormatException);
        expect(() => GregorianDay.parse("---32"), throwsFormatException);
        expect(() => GregorianDay.parse("---10+5:30"), throwsFormatException);
      });
    });

    group('toString()', () {
      test('should return canonical format without timezone', () {
        expect(GregorianDay(9).toString(), "---09");
        expect(GregorianDay(12).toString(), "---12");
      });

      test('should return canonical format with Z timezone', () {
        expect(
          GregorianDay(9, timezoneOffsetInMinutes: 0).toString(),
          "---09Z",
        );
      });

      test('should return canonical format with positive timezone offset', () {
        expect(
          GregorianDay(9, timezoneOffsetInMinutes: 330).toString(),
          "---09+05:30",
        );
      });
    });

    group('Equality and hashCode', () {
      test('should be equal for same day and timezone', () {
        final gd1 = GregorianDay(10, timezoneOffsetInMinutes: 60);
        final gd2 = GregorianDay(10, timezoneOffsetInMinutes: 60);
        expect(gd1, equals(gd2));
        expect(gd1.hashCode, equals(gd2.hashCode));
      });

      test('should not be equal for different day', () {
        final gd1 = GregorianDay(10);
        final gd2 = GregorianDay(9);
        expect(gd1, isNot(equals(gd2)));
      });
    });
  });
}
