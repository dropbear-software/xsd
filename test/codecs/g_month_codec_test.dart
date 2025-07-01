import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_month.dart';
import 'package:xsd/src/codecs/g_month/g_month_codec.dart';

void main() {
  group('GregorianMonthCodec', () {
    const codec = GregorianMonthCodec();

    group('decode', () {
      test('should decode valid gMonth string without timezone', () {
        final result = codec.decode("--10");
        expect(result, equals(GregorianMonth(10)));
      });

      test('should decode valid gMonth string with Z timezone', () {
        final result = codec.decode("--05Z");
        expect(result, equals(GregorianMonth(5, timezoneOffsetInMinutes: 0)));
      });

      test(
        'should decode valid gMonth string with positive timezone offset',
        () {
          final result = codec.decode("--02+05:30");
          expect(
            result,
            equals(GregorianMonth(2, timezoneOffsetInMinutes: 330)),
          );
        },
      );

      test(
        'should decode valid gMonth string with negative timezone offset',
        () {
          final result = codec.decode("--01-08:00");
          expect(
            result,
            equals(GregorianMonth(1, timezoneOffsetInMinutes: -480)),
          );
        },
      );

      test('should decode valid gMonth string with whitespace', () {
        final result = codec.decode("  \n --07Z \t ");
        expect(result, equals(GregorianMonth(7, timezoneOffsetInMinutes: 0)));
      });

      test('should throw FormatException for invalid format', () {
        expect(() => codec.decode("10"), throwsFormatException);
        expect(() => codec.decode("--1"), throwsFormatException);
        expect(() => codec.decode("--13Z"), throwsFormatException);
        expect(() => codec.decode("---01"), throwsFormatException);
        expect(() => codec.decode("--10+5:30"), throwsFormatException);
        expect(() => codec.decode("--10+05:60"), throwsFormatException);
      });
      test('should throw FormatException for invalid timezone format', () {
        expect(() => codec.decode("--10X"), throwsFormatException);
        expect(() => codec.decode("--10+15:00"), throwsFormatException);
        expect(() => codec.decode("--10-08:AA"), throwsFormatException);
      });
    });

    group('encode', () {
      test('should encode GregorianMonth object without timezone', () {
        final result = codec.encode(GregorianMonth(10));
        expect(result, "--10");
      });

      test('should encode GregorianMonth object with Z timezone', () {
        final result = codec.encode(
          GregorianMonth(5, timezoneOffsetInMinutes: 0),
        );
        expect(result, "--05Z");
      });

      test(
        'should encode GregorianMonth object with positive timezone offset',
        () {
          final result = codec.encode(
            GregorianMonth(2, timezoneOffsetInMinutes: 330),
          );
          expect(result, "--02+05:30");
        },
      );

      test(
        'should encode GregorianMonth object with negative timezone offset',
        () {
          final result = codec.encode(
            GregorianMonth(1, timezoneOffsetInMinutes: -480),
          );
          expect(result, "--01-08:00");
        },
      );
    });

    group('fuse', () {
      test(
        'decode.fuse(encode) should be identity for valid GregorianMonth',
        () {
          final original = GregorianMonth(3, timezoneOffsetInMinutes: -120);
          final transformed = codec.decode(codec.encode(original));
          expect(transformed, equals(original));
        },
      );

      test(
        'decode.fuse(encode) should be identity for GregorianMonth without timezone',
        () {
          final original = GregorianMonth(3);
          final transformed = codec.decode(codec.encode(original));
          expect(transformed, equals(original));
        },
      );
    });
  });
}
