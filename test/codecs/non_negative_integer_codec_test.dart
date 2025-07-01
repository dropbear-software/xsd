import 'package:test/test.dart';
import 'package:xsd/src/codecs/non_negative_integer/non_negative_integer_codec.dart';

void main() {
  group('XsdNonNegativeIntegerCodec', () {
    const codec = XsdNonNegativeIntegerCodec();

    group('encode', () {
      test(
        'should encode a non-negative integer to its string representation',
        () {
          expect(codec.encode(BigInt.zero), '0');
          expect(codec.encode(BigInt.from(123)), '123');
          expect(
            codec.encode(BigInt.parse('98765432109876543210')),
            '98765432109876543210',
          );
        },
      );

      test('should throw FormatException for negative values', () {
        expect(
          () => codec.encode(BigInt.from(-1)),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => codec.encode(BigInt.from(-100)),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('decode', () {
      test('should decode a valid non-negative integer string to a BigInt', () {
        expect(codec.decode('0'), BigInt.zero);
        expect(codec.decode('123'), BigInt.from(123));
        expect(codec.decode('007'), BigInt.from(7)); // Leading zeros
        expect(
          codec.decode('98765432109876543210'),
          BigInt.parse('98765432109876543210'),
        );
        expect(
          codec.decode('+123'),
          BigInt.from(123),
        ); // XSD nonNegativeInteger allows explicit positive sign
      });

      test('should handle whitespace', () {
        expect(codec.decode(' 123 '), BigInt.from(123));
        expect(codec.decode('	\n 0'), BigInt.zero);
      });

      group('out of range values', () {
        test('should throw FormatException for negative value "-1"', () {
          expect(() => codec.decode('-1'), throwsA(isA<FormatException>()));
        });
      });

      group('invalid lexical values', () {
        test('should throw FormatException for "123.0"', () {
          expect(() => codec.decode('123.0'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "xyz"', () {
          expect(() => codec.decode('xyz'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for empty string', () {
          expect(() => codec.decode(''), throwsA(isA<FormatException>()));
        });
      });
    });
  });
}
