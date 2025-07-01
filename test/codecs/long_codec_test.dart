import 'package:test/test.dart';
import 'package:xsd/src/codecs/long/long_codec.dart';

void main() {
  group('XsdLongCodec', () {
    const codec = XsdLongCodec();

    group('encode', () {
      test('should encode a long integer to its string representation', () {
        expect(codec.encode(BigInt.from(0)), '0');
        expect(codec.encode(BigInt.from(123)), '123');
        expect(codec.encode(BigInt.from(-123)), '-123');
        expect(codec.encode(XsdLongCodec.minInclusive), '-9223372036854775808');
        expect(codec.encode(XsdLongCodec.maxInclusive), '9223372036854775807');
      });

      test('should throw FormatException for out of range values', () {
        expect(
          () => codec.encode(XsdLongCodec.minInclusive - BigInt.one),
          throwsA(isA<FormatException>()),
        );
        expect(
          () => codec.encode(XsdLongCodec.maxInclusive + BigInt.one),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('decode', () {
      test('should decode a valid long integer string to a BigInt', () {
        expect(codec.decode('0'), BigInt.from(0));
        expect(codec.decode('123'), BigInt.from(123));
        expect(codec.decode('-123'), BigInt.from(-123));
        expect(
          codec.decode('+123'),
          BigInt.from(123),
        ); // XSD long allows explicit positive sign
        expect(codec.decode('007'), BigInt.from(7)); // Leading zeros
        expect(
          codec.decode('9223372036854775807'),
          BigInt.parse('9223372036854775807'),
        );
        expect(
          codec.decode('-9223372036854775808'),
          BigInt.parse('-9223372036854775808'),
        );
      });

      test('should handle whitespace', () {
        expect(codec.decode(' 123 '), BigInt.from(123));
        expect(codec.decode('\n -456'), BigInt.from(-456));
      });

      group('out of range values', () {
        test(
          'should throw FormatException for value greater than maxInclusive',
          () {
            expect(
              () => codec.decode('9223372036854775808'),
              throwsA(isA<FormatException>()),
            );
          },
        );
        test(
          'should throw FormatException for value less than minInclusive',
          () {
            expect(
              () => codec.decode('-9223372036854775809'),
              throwsA(isA<FormatException>()),
            );
          },
        );
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
