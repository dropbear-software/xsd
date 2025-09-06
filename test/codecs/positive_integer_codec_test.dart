import 'package:test/test.dart';
import 'package:xsd/src/codecs/positive_integer/positive_integer_codec.dart';

void main() {
  group('XmlPositiveIntegerCodec', () {
    const codec = XmlPositiveIntegerCodec();

    group('decoder', () {
      test('should decode a valid positive integer string', () {
        expect(codec.decode('1'), BigInt.one);
        expect(codec.decode('123'), BigInt.from(123));
        expect(codec.decode('+123'), BigInt.from(123));
        expect(
          codec.decode(
            '9999999999999999999999999999999999999999999999999999999999',
          ),
          BigInt.parse(
            '9999999999999999999999999999999999999999999999999999999999',
          ),
        );
      });

      test('should handle whitespace during decoding', () {
        expect(codec.decode('  123  '), BigInt.from(123));
        expect(codec.decode('\n\t+123  '), BigInt.from(123));
      });

      test('should throw a FormatException for zero', () {
        expect(() => codec.decode('0'), throwsFormatException);
      });

      test('should throw a FormatException for a negative integer', () {
        expect(() => codec.decode('-1'), throwsFormatException);
      });

      test('should throw a FormatException for an empty string', () {
        expect(() => codec.decode(''), throwsFormatException);
      });

      test('should throw a FormatException for a non-integer string', () {
        expect(() => codec.decode('abc'), throwsFormatException);
      });

      test(
        'should throw a FormatException for a string with only a plus sign',
        () {
          expect(() => codec.decode('+'), throwsFormatException);
        },
      );
    });

    group('encoder', () {
      test('should encode a valid positive integer', () {
        expect(codec.encode(BigInt.one), '1');
        expect(codec.encode(BigInt.from(123)), '123');
        expect(
          codec.encode(
            BigInt.parse(
              '9999999999999999999999999999999999999999999999999999999999',
            ),
          ),
          '9999999999999999999999999999999999999999999999999999999999',
        );
      });

      test('should throw a FormatException for zero', () {
        expect(() => codec.encode(BigInt.zero), throwsFormatException);
      });

      test('should throw a FormatException for a negative integer', () {
        expect(() => codec.encode(BigInt.from(-1)), throwsFormatException);
      });
    });
  });
}
