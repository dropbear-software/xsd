import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_month_day.dart';

void main() {
  group('GregorianMonthDay', () {
    test('constructor validates month', () {
      expect(() => GregorianMonthDay(0, 1), throwsArgumentError);
      expect(() => GregorianMonthDay(13, 1), throwsArgumentError);
      expect(GregorianMonthDay(1, 1).month, 1);
      expect(GregorianMonthDay(12, 1).month, 12);
    });

    test('constructor validates day', () {
      expect(() => GregorianMonthDay(1, 0), throwsArgumentError);
      expect(() => GregorianMonthDay(1, 32), throwsArgumentError);
      expect(GregorianMonthDay(1, 1).day, 1);
      expect(GregorianMonthDay(1, 31).day, 31);
    });

    test('constructor validates day against month', () {
      expect(
        () => GregorianMonthDay(4, 31),
        throwsArgumentError,
      ); // April has 30 days
      expect(GregorianMonthDay(4, 30).day, 30);
      expect(GregorianMonthDay(2, 29).day, 29); // Feb 29 is allowed
      expect(() => GregorianMonthDay(2, 30), throwsArgumentError);
    });

    test('constructor validates timezone', () {
      expect(
        () => GregorianMonthDay(1, 1, timezoneOffsetInMinutes: -841),
        throwsArgumentError,
      );
      expect(
        () => GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 841),
        throwsArgumentError,
      );
      expect(
        GregorianMonthDay(
          1,
          1,
          timezoneOffsetInMinutes: -840,
        ).timezoneOffsetInMinutes,
        -840,
      );
      expect(
        GregorianMonthDay(
          1,
          1,
          timezoneOffsetInMinutes: 840,
        ).timezoneOffsetInMinutes,
        840,
      );
    });

    test('parse valid strings', () {
      expect(GregorianMonthDay.parse('--01-01'), GregorianMonthDay(1, 1));
      expect(GregorianMonthDay.parse('--12-31'), GregorianMonthDay(12, 31));
      expect(GregorianMonthDay.parse('--02-29'), GregorianMonthDay(2, 29));
      expect(
        GregorianMonthDay.parse('--01-01Z'),
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 0),
      );
      expect(
        GregorianMonthDay.parse('--01-01+05:30'),
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 330),
      );
      expect(
        GregorianMonthDay.parse('--01-01-05:00'),
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: -300),
      );
      expect(
        GregorianMonthDay.parse('--01-01+14:00'),
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 840),
      );
    });

    test('parse invalid strings', () {
      expect(() => GregorianMonthDay.parse('01-01'), throwsFormatException);
      expect(() => GregorianMonthDay.parse('--1-1'), throwsFormatException);
      expect(() => GregorianMonthDay.parse('--13-01'), throwsFormatException);
      expect(() => GregorianMonthDay.parse('--01-32'), throwsFormatException);
      expect(
        () => GregorianMonthDay.parse('--04-31'),
        throwsFormatException,
      ); // April 31
      expect(() => GregorianMonthDay.parse('--02-30'), throwsFormatException);
      expect(
        () => GregorianMonthDay.parse('--01-01+14:01'),
        throwsFormatException,
      ); // Invalid timezone
    });

    test('toString returns canonical format', () {
      expect(GregorianMonthDay(1, 1).toString(), '--01-01');
      expect(GregorianMonthDay(12, 31).toString(), '--12-31');
      expect(
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 0).toString(),
        '--01-01Z',
      );
      expect(
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 330).toString(),
        '--01-01+05:30',
      );
      expect(
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: -300).toString(),
        '--01-01-05:00',
      );
    });

    test('equality and hashCode', () {
      final md1 = GregorianMonthDay(1, 1);
      final md2 = GregorianMonthDay(1, 1);
      final md3 = GregorianMonthDay(1, 2);
      final md4 = GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 0);

      expect(md1, md2);
      expect(md1.hashCode, md2.hashCode);
      expect(md1, isNot(md3));
      expect(md1, isNot(md4));
    });

    test('copyWith', () {
      final md = GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 0);
      expect(
        md.copyWith(month: 2),
        GregorianMonthDay(2, 1, timezoneOffsetInMinutes: 0),
      );
      expect(
        md.copyWith(day: 2),
        GregorianMonthDay(1, 2, timezoneOffsetInMinutes: 0),
      );
      expect(
        md.copyWith(timezoneOffsetInMinutes: 60),
        GregorianMonthDay(1, 1, timezoneOffsetInMinutes: 60),
      );
      expect(md.copyWith(setToNoTimezone: true), GregorianMonthDay(1, 1));
    });
  });
}
