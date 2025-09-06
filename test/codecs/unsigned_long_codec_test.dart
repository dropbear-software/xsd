import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdUnsignedLongCodec', () {
    const codec = XsdUnsignedLongCodec();
    final maxValue = BigInt.parse('18446744073709551615');

    group('decoder', () {
      test('should decode a valid unsigned long string', () {
        expect(codec.decode('0'), BigInt.zero);
        expect(codec.decode('123'), BigInt.from(123));
        expect(codec.decode('+123'), BigInt.from(123));
        expect(codec.decode('18446744073709551615'), maxValue);
      });

      test('should throw a FormatException for a negative integer', () {
        expect(() => codec.decode('-1'), throwsFormatException);
      });

      test(
        'should throw a FormatException for a value greater than the max',
        () {
          final tooLarge = maxValue + BigInt.one;
          expect(
            () => codec.decode(tooLarge.toString()),
            throwsFormatException,
          );
        },
      );

      test('should throw a FormatException for an empty string', () {
        expect(() => codec.decode(''), throwsFormatException);
      });

      test('should throw a FormatException for a non-integer string', () {
        expect(() => codec.decode('abc'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid unsigned long', () {
        expect(codec.encode(BigInt.zero), '0');
        expect(codec.encode(BigInt.from(123)), '123');
        expect(codec.encode(maxValue), '18446744073709551615');
      });

      test('should throw a FormatException for a negative integer', () {
        expect(() => codec.encode(BigInt.from(-1)), throwsFormatException);
      });

      test(
        'should throw a FormatException for a value greater than the max',
        () {
          final tooLarge = maxValue + BigInt.one;
          expect(() => codec.encode(tooLarge), throwsFormatException);
        },
      );
    });
  });
}
