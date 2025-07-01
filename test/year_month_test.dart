import 'package:test/test.dart';
import 'package:xsd/src/year_month.dart'; // Adjust import path as necessary

void main() {
  group('YearMonth', () {
    group('Constructor and Properties', () {
      test('should create a valid YearMonth object', () {
        final ym = YearMonth(2023, 10);
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, isNull);
      });

      test('should create a valid YearMonth object with timezone', () {
        final ym = YearMonth(2023, 10, timezoneOffsetInMinutes: 60);
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, 60);
      });

      test('should throw ArgumentError for invalid month', () {
        expect(() => YearMonth(2023, 0), throwsArgumentError);
        expect(() => YearMonth(2023, 13), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid timezone offset', () {
        expect(() => YearMonth(2023, 10, timezoneOffsetInMinutes: -15 * 60),
            throwsArgumentError);
        expect(() => YearMonth(2023, 10, timezoneOffsetInMinutes: 15 * 60),
            throwsArgumentError);
      });
    });

    group('Parsing', () {
      test('should parse valid gYearMonth string without timezone', () {
        final ym = YearMonth.parse("2023-10");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, isNull);
      });

      test('should parse valid gYearMonth string with Z timezone', () {
        final ym = YearMonth.parse("2023-10Z");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, 0);
      });

      test('should parse valid gYearMonth string with positive timezone offset',
          () {
        final ym = YearMonth.parse("2023-10+05:30");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, 330); // 5 * 60 + 30
      });

      test('should parse valid gYearMonth string with negative timezone offset',
          () {
        final ym = YearMonth.parse("2023-10-08:00");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, -480); // -8 * 60
      });

      test('should parse valid gYearMonth string with 14:00 timezone offset',
          () {
        final ym = YearMonth.parse("2023-10+14:00");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, 14 * 60);
      });

      test('should parse valid gYearMonth string with -14:00 timezone offset',
          () {
        final ym = YearMonth.parse("2023-10-14:00");
        expect(ym.year, 2023);
        expect(ym.month, 10);
        expect(ym.timezoneOffsetInMinutes, -14 * 60);
      });


      test('should parse year 0000 as 0 (1 BCE)', () {
        final ym = YearMonth.parse("0000-01");
        expect(ym.year, 0);
        expect(ym.month, 1);
      });

      test('should parse negative year -0001 as -1 (2 BCE)', () {
        final ym = YearMonth.parse("-0001-12");
        expect(ym.year, -1);
        expect(ym.month, 12);
      });

      test('should parse long positive year', () {
        final ym = YearMonth.parse("12023-03");
        expect(ym.year, 12023);
        expect(ym.month, 3);
      });

      test('should parse long negative year', () {
        final ym = YearMonth.parse("-12023-03");
        expect(ym.year, -12023);
        expect(ym.month, 3);
      });


      test('should throw FormatException for invalid format', () {
        expect(() => YearMonth.parse("202310"), throwsFormatException);
        expect(() => YearMonth.parse("2023-1"), throwsFormatException);
        expect(() => YearMonth.parse("2023-13"), throwsFormatException);
        expect(() => YearMonth.parse("23-10"), throwsFormatException);
        expect(() => YearMonth.parse("2023-10+5:30"), throwsFormatException);
        expect(() => YearMonth.parse("2023-10+05:60"), throwsFormatException);
        expect(() => YearMonth.parse("2023-10+15:00"), throwsFormatException);
        expect(() => YearMonth.parse("2023-10-15:00"), throwsFormatException);
      });
    });

    group('toString()', () {
      test('should return canonical format without timezone', () {
        expect(YearMonth(2023, 9).toString(), "2023-09");
        expect(YearMonth(2023, 12).toString(), "2023-12");
      });

      test('should return canonical format with Z timezone', () {
        expect(YearMonth(2023, 9, timezoneOffsetInMinutes: 0).toString(),
            "2023-09Z");
      });

      test('should return canonical format with positive timezone offset', () {
        expect(
            YearMonth(2023, 9, timezoneOffsetInMinutes: 330).toString(), // +05:30
            "2023-09+05:30");
      });

      test('should return canonical format with negative timezone offset', () {
        expect(
            YearMonth(2023, 9, timezoneOffsetInMinutes: -480).toString(), // -08:00
            "2023-09-08:00");
      });

      test('should return canonical format for year 0', () {
        expect(YearMonth(0, 1).toString(), "0000-01");
      });

      test('should return canonical format for negative year', () {
        expect(YearMonth(-1, 12).toString(), "-0001-12");
      });

      test('should return canonical format for long year', () {
        expect(YearMonth(12023, 3).toString(), "12023-03");
      });

      test('should return canonical format for long negative year', () {
        expect(YearMonth(-12023, 3).toString(), "-12023-03");
      });
    });

    group('Equality and hashCode', () {
      test('should be equal for same year, month, and timezone', () {
        final ym1 = YearMonth(2023, 10, timezoneOffsetInMinutes: 60);
        final ym2 = YearMonth(2023, 10, timezoneOffsetInMinutes: 60);
        expect(ym1, equals(ym2));
        expect(ym1.hashCode, equals(ym2.hashCode));
      });

      test('should not be equal for different year', () {
        final ym1 = YearMonth(2023, 10);
        final ym2 = YearMonth(2022, 10);
        expect(ym1, isNot(equals(ym2)));
      });

      test('should not be equal for different month', () {
        final ym1 = YearMonth(2023, 10);
        final ym2 = YearMonth(2023, 9);
        expect(ym1, isNot(equals(ym2)));
      });

      test('should not be equal for different timezone', () {
        final ym1 = YearMonth(2023, 10, timezoneOffsetInMinutes: 60);
        final ym2 = YearMonth(2023, 10, timezoneOffsetInMinutes: -60);
        final ym3 = YearMonth(2023, 10);
        expect(ym1, isNot(equals(ym2)));
        expect(ym1, isNot(equals(ym3)));
        expect(ym2, isNot(equals(ym3)));
      });
    });

    group('copyWith', () {
      final original = YearMonth(2023, 10, timezoneOffsetInMinutes: 60);
      test('should copy with new year', () {
        final copied = original.copyWith(year: 2024);
        expect(copied.year, 2024);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, original.timezoneOffsetInMinutes);
      });
      test('should copy with new month', () {
        final copied = original.copyWith(month: 11);
        expect(copied.year, original.year);
        expect(copied.month, 11);
        expect(copied.timezoneOffsetInMinutes, original.timezoneOffsetInMinutes);
      });
      test('should copy with new timezone', () {
        final copied = original.copyWith(timezoneOffsetInMinutes: -60);
        expect(copied.year, original.year);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, -60);
      });
       test('should copy and remove timezone', () {
        final copied = original.copyWith(setToNoTimezone: true);
        expect(copied.year, original.year);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, isNull);
      });
      test('should copy with new timezone and ignore setToNoTimezone if timezone also provided', () {
        final copied = original.copyWith(timezoneOffsetInMinutes: 120, setToNoTimezone: true);
        expect(copied.year, original.year);
        expect(copied.month, original.month);
        expect(copied.timezoneOffsetInMinutes, 120);
      });
       test('should copy with no changes if no args provided', () {
        final copied = original.copyWith();
        expect(copied, equals(original));
      });
    });
  });
}
