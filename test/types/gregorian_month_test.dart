import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_month.dart';

void main() {
  group('GregorianMonth', () {
    group('Constructor and Properties', () {
      test('should create a valid GregorianMonth object', () {
        final gm = GregorianMonth(10);
        expect(gm.month, 10);
        expect(gm.timezoneOffsetInMinutes, isNull);
      });

      test('should create a valid GregorianMonth object with timezone', () {
        final gm = GregorianMonth(10, timezoneOffsetInMinutes: 60);
        expect(gm.month, 10);
        expect(gm.timezoneOffsetInMinutes, 60);
      });

      test('should throw ArgumentError for invalid month', () {
        expect(() => GregorianMonth(0), throwsArgumentError);
        expect(() => GregorianMonth(13), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid timezone offset', () {
        expect(
          () => GregorianMonth(10, timezoneOffsetInMinutes: -15 * 60),
          throwsArgumentError,
        ); // -900
        expect(
          () => GregorianMonth(10, timezoneOffsetInMinutes: 15 * 60),
          throwsArgumentError,
        ); // 900
        expect(
          () => GregorianMonth(10, timezoneOffsetInMinutes: -841),
          throwsArgumentError,
        );
        expect(
          () => GregorianMonth(10, timezoneOffsetInMinutes: 841),
          throwsArgumentError,
        );
      });

      test('should allow valid timezone boundaries', () {
        expect(
          GregorianMonth(
            1,
            timezoneOffsetInMinutes: -14 * 60,
          ).timezoneOffsetInMinutes,
          -840,
        );
        expect(
          GregorianMonth(
            1,
            timezoneOffsetInMinutes: 14 * 60,
          ).timezoneOffsetInMinutes,
          840,
        );
      });
    });

    group('Parsing', () {
      test('should parse valid gMonth string without timezone', () {
        final gm = GregorianMonth.parse("--10");
        expect(gm.month, 10);
        expect(gm.timezoneOffsetInMinutes, isNull);

        final gm2 = GregorianMonth.parse("--01");
        expect(gm2.month, 1);
        expect(gm2.timezoneOffsetInMinutes, isNull);
      });

      test('should parse valid gMonth string with Z timezone', () {
        final gm = GregorianMonth.parse("--05Z");
        expect(gm.month, 5);
        expect(gm.timezoneOffsetInMinutes, 0);
      });

      test(
        'should parse valid gMonth string with positive timezone offset',
        () {
          final gm = GregorianMonth.parse("--12+05:30");
          expect(gm.month, 12);
          expect(gm.timezoneOffsetInMinutes, 330); // 5 * 60 + 30
        },
      );

      test(
        'should parse valid gMonth string with negative timezone offset',
        () {
          final gm = GregorianMonth.parse("--03-08:00");
          expect(gm.month, 3);
          expect(gm.timezoneOffsetInMinutes, -480); // -8 * 60
        },
      );

      test('should parse valid gMonth string with +14:00 timezone offset', () {
        final gm = GregorianMonth.parse("--07+14:00");
        expect(gm.month, 7);
        expect(gm.timezoneOffsetInMinutes, 14 * 60);
      });

      test('should parse valid gMonth string with -14:00 timezone offset', () {
        final gm = GregorianMonth.parse("--02-14:00");
        expect(gm.month, 2);
        expect(gm.timezoneOffsetInMinutes, -14 * 60);
      });

      test('should handle whitespace correctly during parsing', () {
        final gm = GregorianMonth.parse("  --04Z  ");
        expect(gm.month, 4);
        expect(gm.timezoneOffsetInMinutes, 0);
      });

      test('should throw FormatException for invalid format', () {
        expect(() => GregorianMonth.parse("10"), throwsFormatException);
        expect(() => GregorianMonth.parse("--1"), throwsFormatException);
        expect(() => GregorianMonth.parse("--13Z"), throwsFormatException);
        expect(() => GregorianMonth.parse("---10"), throwsFormatException);
        expect(() => GregorianMonth.parse("--10+5:30"), throwsFormatException);
        expect(() => GregorianMonth.parse("--10+05:60"), throwsFormatException);
        expect(() => GregorianMonth.parse("--10+15:00"), throwsFormatException);
        expect(() => GregorianMonth.parse("--10-15:00"), throwsFormatException);
        expect(() => GregorianMonth.parse("--00"), throwsFormatException);
        expect(() => GregorianMonth.parse("--1Z"), throwsFormatException);
      });
    });

    group('toString()', () {
      test('should return canonical format without timezone', () {
        expect(GregorianMonth(9).toString(), "--09");
        expect(GregorianMonth(12).toString(), "--12");
      });

      test('should return canonical format with Z timezone', () {
        expect(
          GregorianMonth(9, timezoneOffsetInMinutes: 0).toString(),
          "--09Z",
        );
      });

      test('should return canonical format with positive timezone offset', () {
        expect(
          GregorianMonth(9, timezoneOffsetInMinutes: 330).toString(), // +05:30
          "--09+05:30",
        );
      });

      test('should return canonical format with negative timezone offset', () {
        expect(
          GregorianMonth(9, timezoneOffsetInMinutes: -480).toString(), // -08:00
          "--09-08:00",
        );
      });
    });

    group('Equality and hashCode', () {
      test('should be equal for same month and timezone', () {
        final gm1 = GregorianMonth(10, timezoneOffsetInMinutes: 60);
        final gm2 = GregorianMonth(10, timezoneOffsetInMinutes: 60);
        expect(gm1, equals(gm2));
        expect(gm1.hashCode, equals(gm2.hashCode));
      });

      test('should not be equal for different month', () {
        final gm1 = GregorianMonth(10);
        final gm2 = GregorianMonth(9);
        expect(gm1, isNot(equals(gm2)));
      });

      test('should not be equal for different timezone', () {
        final gm1 = GregorianMonth(10, timezoneOffsetInMinutes: 60);
        final gm2 = GregorianMonth(10, timezoneOffsetInMinutes: -60);
        final gm3 = GregorianMonth(10);
        expect(gm1, isNot(equals(gm2)));
        expect(gm1, isNot(equals(gm3)));
        expect(gm2, isNot(equals(gm3)));
      });
    });

    group('copyWith', () {
      final original = GregorianMonth(10, timezoneOffsetInMinutes: 60);
      test('should copy with new month', () {
        final copied = original.copyWith(month: 11);
        expect(copied.month, 11);
        expect(
          copied.timezoneOffsetInMinutes,
          original.timezoneOffsetInMinutes,
        );
      });
      test('should copy with new timezone', () {
        final copied = original.copyWith(timezoneOffsetInMinutes: -60);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, -60);
      });
      test('should copy and remove timezone', () {
        final copied = original.copyWith(setToNoTimezone: true);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, isNull);
      });
      test(
        'should copy with new timezone and ignore setToNoTimezone if timezone also provided',
        () {
          final copied = original.copyWith(
            timezoneOffsetInMinutes: 120,
            setToNoTimezone: true,
          );
          expect(copied.month, original.month);
          expect(copied.timezoneOffsetInMinutes, 120);
        },
      );
      test('should copy with no changes if no args provided', () {
        final copied = original.copyWith();
        expect(copied, equals(original));
      });
    });
  });
}
