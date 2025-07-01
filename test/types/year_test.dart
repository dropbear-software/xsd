import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_year.dart'; // Adjust import path as necessary

void main() {
  group('Year', () {
    group('Constructor and Properties', () {
      test('should create a valid Year object', () {
        final y = GregorianYear(2023);
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, isNull);
      });

      test('should create a valid Year object with timezone', () {
        final y = GregorianYear(2023, timezoneOffsetInMinutes: 60);
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, 60);
      });

      test('should create a Year object with year 0', () {
        final y = GregorianYear(0);
        expect(y.year, 0);
      });

      test('should create a Year object with negative year', () {
        final y = GregorianYear(-1);
        expect(y.year, -1);
      });

      test('should throw ArgumentError for invalid timezone offset', () {
        expect(
          () => GregorianYear(2023, timezoneOffsetInMinutes: -15 * 60),
          throwsArgumentError,
        );
        expect(
          () => GregorianYear(2023, timezoneOffsetInMinutes: 15 * 60),
          throwsArgumentError,
        );
        expect(
          () => GregorianYear(2023, timezoneOffsetInMinutes: -841),
          throwsArgumentError,
        );
        expect(
          () => GregorianYear(2023, timezoneOffsetInMinutes: 841),
          throwsArgumentError,
        );
      });
    });

    group('Parsing', () {
      test('should parse valid gYear string without timezone', () {
        final y = GregorianYear.parse("2023");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, isNull);
      });

      test('should parse valid gYear string with Z timezone', () {
        final y = GregorianYear.parse("2023Z");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, 0);
      });

      test('should parse valid gYear string with positive timezone offset', () {
        final y = GregorianYear.parse("2023+05:30");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, 330); // 5 * 60 + 30
      });

      test('should parse valid gYear string with negative timezone offset', () {
        final y = GregorianYear.parse("2023-08:00");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, -480); // -8 * 60
      });

      test('should parse valid gYear string with 14:00 timezone offset', () {
        final y = GregorianYear.parse("2023+14:00");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, 14 * 60);
      });

      test('should parse valid gYear string with -14:00 timezone offset', () {
        final y = GregorianYear.parse("2023-14:00");
        expect(y.year, 2023);
        expect(y.timezoneOffsetInMinutes, -14 * 60);
      });

      test('should parse year 0000 as 0 (1 BCE)', () {
        final y = GregorianYear.parse("0000");
        expect(y.year, 0);
      });

      test('should parse year 0000Z as 0 (1 BCE) with Z timezone', () {
        final y = GregorianYear.parse("0000Z");
        expect(y.year, 0);
        expect(y.timezoneOffsetInMinutes, 0);
      });

      test('should parse negative year -0001 as -1 (2 BCE)', () {
        final y = GregorianYear.parse("-0001");
        expect(y.year, -1);
      });

      test('should parse long positive year > 4 digits', () {
        final y = GregorianYear.parse("12023");
        expect(y.year, 12023);
      });
      test('should parse long positive year > 4 digits with timezone', () {
        final y = GregorianYear.parse("12023-05:00");
        expect(y.year, 12023);
        expect(y.timezoneOffsetInMinutes, -300);
      });

      test('should parse long negative year > 4 digits', () {
        final y = GregorianYear.parse("-12023");
        expect(y.year, -12023);
      });
      test('should parse long negative year > 4 digits with timezone', () {
        final y = GregorianYear.parse("-12023+02:30");
        expect(y.year, -12023);
        expect(y.timezoneOffsetInMinutes, 150);
      });

      test('should handle whitespace correctly during parsing', () {
        final y = GregorianYear.parse("  \n  2025Z \t ");
        expect(y.year, 2025);
        expect(y.timezoneOffsetInMinutes, 0);
      });

      test('should throw FormatException for invalid year format', () {
        expect(
          () => GregorianYear.parse("202"),
          throwsFormatException,
        ); // Too short
        expect(
          () => GregorianYear.parse("2023-"),
          throwsFormatException,
        ); // Dangling hyphen
        expect(
          () => GregorianYear.parse("2023+5:30"),
          throwsFormatException,
        ); // Invalid timezone (hour needs 2 digits)
        expect(
          () => GregorianYear.parse("2023+05:60"),
          throwsFormatException,
        ); // Invalid timezone (minute > 59)
        expect(
          () => GregorianYear.parse("2023+15:00"),
          throwsFormatException,
        ); // Invalid timezone (hour > 14)
        expect(
          () => GregorianYear.parse("2023-15:00"),
          throwsFormatException,
        ); // Invalid timezone (hour > 14)
        expect(
          () => GregorianYear.parse("001-01"),
          throwsFormatException,
        ); // Year too short (non-negative)
        expect(
          () => GregorianYear.parse("-001-01"),
          throwsFormatException,
        ); // Year too short (negative)
        expect(
          () => GregorianYear.parse("2023X"),
          throwsFormatException,
        ); // Invalid timezone char
        expect(
          () => GregorianYear.parse("2023+0500"),
          throwsFormatException,
        ); // Missing colon in timezone
        expect(
          () => GregorianYear.parse("Z"),
          throwsFormatException,
        ); // Only timezone
        expect(
          () => GregorianYear.parse("-Z"),
          throwsFormatException,
        ); // Invalid year with Z
        expect(
          () => GregorianYear.parse("2023+12:345"),
          throwsFormatException,
        ); // Too many minute digits
      });
    });

    group('toString()', () {
      test('should return canonical format without timezone', () {
        expect(GregorianYear(2023).toString(), "2023");
      });

      test('should return canonical format with Z timezone', () {
        expect(
          GregorianYear(2023, timezoneOffsetInMinutes: 0).toString(),
          "2023Z",
        );
      });

      test('should return canonical format with positive timezone offset', () {
        expect(
          GregorianYear(
            2023,
            timezoneOffsetInMinutes: 330,
          ).toString(), // +05:30
          "2023+05:30",
        );
      });

      test('should return canonical format with negative timezone offset', () {
        expect(
          GregorianYear(
            2023,
            timezoneOffsetInMinutes: -480,
          ).toString(), // -08:00
          "2023-08:00",
        );
      });

      test('should return canonical format for year 0 (1 BCE)', () {
        expect(GregorianYear(0).toString(), "0000");
      });
      test('should return canonical format for year 0 with Z timezone', () {
        expect(
          GregorianYear(0, timezoneOffsetInMinutes: 0).toString(),
          "0000Z",
        );
      });

      test('should return canonical format for negative year -1 (2 BCE)', () {
        expect(GregorianYear(-1).toString(), "-0001");
      });
      test('should return canonical format for negative year -12 (13 BCE)', () {
        expect(GregorianYear(-12).toString(), "-0012");
      });
      test(
        'should return canonical format for negative year -123 (124 BCE)',
        () {
          expect(GregorianYear(-123).toString(), "-0123");
        },
      );
      test(
        'should return canonical format for negative year -1234 (1235 BCE)',
        () {
          expect(GregorianYear(-1234).toString(), "-1234");
        },
      );

      test(
        'should return canonical format for long positive year > 4 digits',
        () {
          expect(GregorianYear(12023).toString(), "12023");
        },
      );
      test(
        'should return canonical format for long positive year > 4 digits with timezone',
        () {
          expect(
            GregorianYear(12023, timezoneOffsetInMinutes: 150).toString(),
            "12023+02:30",
          );
        },
      );

      test(
        'should return canonical format for long negative year > 4 digits',
        () {
          expect(GregorianYear(-12023).toString(), "-12023");
        },
      );
      test(
        'should return canonical format for long negative year > 4 digits with timezone',
        () {
          expect(
            GregorianYear(-12023, timezoneOffsetInMinutes: -60).toString(),
            "-12023-01:00",
          );
        },
      );
    });

    group('Equality and hashCode', () {
      test('should be equal for same year and timezone', () {
        final y1 = GregorianYear(2023, timezoneOffsetInMinutes: 60);
        final y2 = GregorianYear(2023, timezoneOffsetInMinutes: 60);
        expect(y1, equals(y2));
        expect(y1.hashCode, equals(y2.hashCode));
      });

      test('should be equal for same year and no timezone', () {
        final y1 = GregorianYear(2023);
        final y2 = GregorianYear(2023);
        expect(y1, equals(y2));
        expect(y1.hashCode, equals(y2.hashCode));
      });

      test('should not be equal for different year', () {
        final y1 = GregorianYear(2023);
        final y2 = GregorianYear(2022);
        expect(y1, isNot(equals(y2)));
      });

      test('should not be equal for different timezone', () {
        final y1 = GregorianYear(2023, timezoneOffsetInMinutes: 60);
        final y2 = GregorianYear(2023, timezoneOffsetInMinutes: -60);
        final y3 = GregorianYear(2023);
        expect(y1, isNot(equals(y2)));
        expect(y1, isNot(equals(y3)));
        expect(y2, isNot(equals(y3)));
      });
    });

    group('copyWith', () {
      final original = GregorianYear(2023, timezoneOffsetInMinutes: 60);
      test('should copy with new year', () {
        final copied = original.copyWith(year: 2024);
        expect(copied.year, 2024);
        expect(
          copied.timezoneOffsetInMinutes,
          original.timezoneOffsetInMinutes,
        );
      });
      test('should copy with new timezone', () {
        final copied = original.copyWith(timezoneOffsetInMinutes: -60);
        expect(copied.year, original.year);
        expect(copied.timezoneOffsetInMinutes, -60);
      });
      test('should copy and remove timezone', () {
        final copied = original.copyWith(setToNoTimezone: true);
        expect(copied.year, original.year);
        expect(copied.timezoneOffsetInMinutes, isNull);
      });
      test(
        'should copy with new timezone and ignore setToNoTimezone if timezone also provided',
        () {
          final copied = original.copyWith(
            timezoneOffsetInMinutes: 120,
            setToNoTimezone: true,
          );
          expect(copied.year, original.year);
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
