import 'package:test/test.dart';
import 'package:xsd/src/types/year_month.dart';
import 'package:xsd/src/codecs/g_year_month/year_month_codec.dart';

void main() {
  group('YearMonthCodec', () {
    const codec = YearMonthCodec();

    group('decode', () {
      test('should decode valid gYearMonth string without timezone', () {
        final result = codec.decode("2023-10");
        expect(result, equals(YearMonth(2023, 10)));
      });

      test('should decode valid gYearMonth string with Z timezone', () {
        final result = codec.decode("1999-05Z");
        expect(result, equals(YearMonth(1999, 5, timezoneOffsetInMinutes: 0)));
      });

      test(
        'should decode valid gYearMonth string with positive timezone offset',
        () {
          final result = codec.decode("2000-02+05:30");
          expect(
            result,
            equals(YearMonth(2000, 2, timezoneOffsetInMinutes: 330)),
          );
        },
      );

      test(
        'should decode valid gYearMonth string with negative timezone offset',
        () {
          final result = codec.decode("0000-01-08:00");
          expect(
            result,
            equals(YearMonth(0, 1, timezoneOffsetInMinutes: -480)),
          );
        },
      );

      test('should decode valid gYearMonth string with whitespace', () {
        final result = codec.decode("  \n 2023-07Z \t ");
        expect(result, equals(YearMonth(2023, 7, timezoneOffsetInMinutes: 0)));
      });

      test('should throw FormatException for invalid format', () {
        expect(() => codec.decode("202310"), throwsFormatException);
        expect(() => codec.decode("2023-1"), throwsFormatException);
        expect(() => codec.decode("2023-13Z"), throwsFormatException);
        expect(() => codec.decode("23-10"), throwsFormatException);
        expect(
          () => codec.decode("2023-10+5:30"),
          throwsFormatException,
        ); // missing 0 in hour
        expect(() => codec.decode("2023-10+05:60"), throwsFormatException);
      });
      test('should throw FormatException for invalid timezone format', () {
        expect(() => codec.decode("2023-10X"), throwsFormatException);
        expect(() => codec.decode("2023-10+15:00"), throwsFormatException);
        expect(() => codec.decode("2023-10-08:AA"), throwsFormatException);
      });
    });

    group('encode', () {
      test('should encode YearMonth object without timezone', () {
        final result = codec.encode(YearMonth(2023, 10));
        expect(result, "2023-10");
      });

      test('should encode YearMonth object with Z timezone', () {
        final result = codec.encode(
          YearMonth(1999, 5, timezoneOffsetInMinutes: 0),
        );
        expect(result, "1999-05Z");
      });

      test('should encode YearMonth object with positive timezone offset', () {
        final result = codec.encode(
          YearMonth(2000, 2, timezoneOffsetInMinutes: 330),
        );
        expect(result, "2000-02+05:30");
      });

      test('should encode YearMonth object with negative timezone offset', () {
        final result = codec.encode(
          YearMonth(0, 1, timezoneOffsetInMinutes: -480),
        );
        expect(result, "0000-01-08:00");
      });
    });

    group('fuse', () {
      test('decode.fuse(encode) should be identity for valid YearMonth', () {
        final original = YearMonth(2024, 3, timezoneOffsetInMinutes: -120);
        final transformed = codec.decode(codec.encode(original));
        expect(transformed, equals(original));
      });

      test(
        'decode.fuse(encode) should be identity for YearMonth without timezone',
        () {
          final original = YearMonth(2024, 3);
          final transformed = codec.decode(codec.encode(original));
          expect(transformed, equals(original));
        },
      );
    });
  });
}
