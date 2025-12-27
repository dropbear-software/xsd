import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdFloatCodec', () {
    const codec = XsdFloatCodec();

    group('encoder', () {
      test('should encode valid float values', () {
        expect(codec.encode(123.45), '123.45');
        expect(codec.encode(-123.45), '-123.45');
        expect(codec.encode(0.0), '0.0');
        expect(codec.encode(-0.0), '-0.0');
        expect(codec.encode(1.23e4), '12300.0');
        expect(codec.encode(double.infinity), 'INF');
        expect(codec.encode(double.negativeInfinity), '-INF');
        expect(codec.encode(double.nan), 'NaN');
      });

      test('should throw on values that overflow the float range', () {
        // double.maxFinite is much larger than what a 32-bit float can hold.
        expect(
          () => codec.encode(double.maxFinite),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('overflows the 32-bit float range'),
            ),
          ),
        );
      });

      test('should throw on values that underflow the float range', () {
        // A value that underflows to 0 in 32-bit float.
        expect(
          () => codec.encode(1.0e-46),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('underflows the 32-bit float range'),
            ),
          ),
        );
      });
    });

    group('decoder', () {
      test('should decode valid float strings', () {
        double toFloat32(double value) => (Float32List(1)..[0] = value)[0];

        expect(codec.decode('123.45'), toFloat32(123.45));
        expect(codec.decode(' -123.45 '), toFloat32(-123.45));
        expect(codec.decode('INF'), double.infinity);
        expect(codec.decode(' -INF '), double.negativeInfinity);
        expect(codec.decode('NaN').isNaN, isTrue);
        expect(codec.decode('1.2E3'), 1200.0);
        expect(codec.decode('0'), 0.0);
        expect(codec.decode('-0'), -0.0);
      });

      test('should throw FormatException for invalid string formats', () {
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.2.3'), throwsFormatException);
        expect(() => codec.decode('INFinity'), throwsFormatException);
        expect(() => codec.decode('inf'), throwsFormatException);
        expect(() => codec.decode('-inf'), throwsFormatException);
      });

      test(
        'should throw FormatException on values that overflow the float range',
        () {
          // A value larger than the max float value (~3.4e38)
          expect(
            () => codec.decode('3.5e38'),
            throwsA(
              isA<FormatException>().having(
                (e) => e.message,
                'message',
                contains('outside the value range of float (overflow)'),
              ),
            ),
          );
        },
      );

      test(
        'should throw FormatException on values that underflow the float range',
        () {
          // A value smaller than the min float value (~1.4e-45)
          expect(
            () => codec.decode('1.0e-46'),
            throwsA(
              isA<FormatException>().having(
                (e) => e.message,
                'message',
                contains('outside the value range of float (underflow)'),
              ),
            ),
          );
        },
      );
    });
  });
}
