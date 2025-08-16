import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_year.dart';
import 'package:xsd/src/codecs/g_year/year_codec.dart';

void main() {
  group('YearCodec', () {
    const codec = GregorianYearCodec();

    group('decode', () {
      test('should decode valid gYear string without timezone', () {
        final result = codec.decode("2023");
        expect(result, equals(GregorianYear(2023)));
      });

      test('should decode valid gYear string with Z timezone', () {
        final result = codec.decode("1999Z");
        expect(result, equals(GregorianYear(1999, timezoneOffsetInMinutes: 0)));
      });

      test(
        'should decode valid gYear string with positive timezone offset',
        () {
          final result = codec.decode("2000+05:30");
          expect(
            result,
            equals(GregorianYear(2000, timezoneOffsetInMinutes: 330)),
          );
        },
      );

      test(
        'should decode valid gYear string with negative timezone offset',
        () {
          final result = codec.decode("0000-08:00");
          expect(
            result,
            equals(GregorianYear(0, timezoneOffsetInMinutes: -480)),
          );
        },
      );

      test('should decode valid gYear string with -14:00 timezone offset', () {
        final result = codec.decode("2021-14:00");
        expect(
          result,
          equals(GregorianYear(2021, timezoneOffsetInMinutes: -14 * 60)),
        );
      });

      test('should decode valid gYear string with +14:00 timezone offset', () {
        final result = codec.decode("-0005+14:00");
        expect(
          result,
          equals(GregorianYear(-5, timezoneOffsetInMinutes: 14 * 60)),
        );
      });

      test('should decode valid gYear string with whitespace', () {
        final result = codec.decode("  \n 2023Z \t ");
        expect(result, equals(GregorianYear(2023, timezoneOffsetInMinutes: 0)));
      });

      test('should throw FormatException for invalid format', () {
        expect(() => codec.decode("202"), throwsFormatException);
        expect(
          () => codec.decode("2023-"),
          throwsFormatException,
        ); // Invalid trailing char
        expect(
          () => codec.decode("2023+5:30"),
          throwsFormatException,
        ); // Tz hour needs 2 digits
        expect(
          () => codec.decode("2023+05:60"),
          throwsFormatException,
        ); // Tz minute > 59
        expect(
          () => codec.decode("2023-10"),
          throwsFormatException,
        ); // Cannot have month
      });

      test('should throw FormatException for invalid timezone format', () {
        expect(() => codec.decode("2023X"), throwsFormatException);
        expect(
          () => codec.decode("2023+15:00"),
          throwsFormatException,
        ); // Hour > 14
        expect(
          () => codec.decode("2023-08:AA"),
          throwsFormatException,
        ); // Non-digit minute
        expect(
          () => codec.decode("101Z"),
          throwsFormatException,
        ); // Year too short
      });
    });

    group('encode', () {
      test('should encode Year object without timezone', () {
        final result = codec.encode(GregorianYear(2023));
        expect(result, "2023");
      });

      test('should encode Year object with Z timezone', () {
        final result = codec.encode(
          GregorianYear(1999, timezoneOffsetInMinutes: 0),
        );
        expect(result, "1999Z");
      });

      test('should encode Year object with positive timezone offset', () {
        final result = codec.encode(
          GregorianYear(2000, timezoneOffsetInMinutes: 330),
        );
        expect(result, "2000+05:30");
      });

      test('should encode Year object with negative timezone offset', () {
        final result = codec.encode(
          GregorianYear(0, timezoneOffsetInMinutes: -480),
        );
        expect(result, "0000-08:00");
      });
      test('should encode Year object with long negative year', () {
        final result = codec.encode(
          GregorianYear(-12345, timezoneOffsetInMinutes: -60),
        );
        expect(result, "-12345-01:00");
      });
    });

    group('fuse', () {
      test('decode.fuse(encode) should be identity for valid Year', () {
        final original = GregorianYear(2024, timezoneOffsetInMinutes: -120);
        final transformed = codec.decode(codec.encode(original));
        expect(transformed, equals(original));
      });

      test(
        'decode.fuse(encode) should be identity for Year without timezone',
        () {
          final original = GregorianYear(2024);
          final transformed = codec.decode(codec.encode(original));
          expect(transformed, equals(original));
        },
      );

      test('decode.fuse(encode) should be identity for year 0 with Z', () {
        final original = GregorianYear(0, timezoneOffsetInMinutes: 0);
        final transformed = codec.decode(codec.encode(original));
        expect(transformed, equals(original));
      });
    });
  });
}
