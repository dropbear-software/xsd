import 'package:test/test.dart';
import 'package:xsd/src/codecs/unsigned_byte/unsigned_byte_codec.dart';

void main() {
  group('XsdUnsignedByteCodec', () {
    const codec = XsdUnsignedByteCodec();
    const minVal = 0;
    const maxVal = 255;

    group('decoder (xsd:unsignedByte)', () {
      test('should decode "0" to 0', () {
        expect(codec.decode('0'), minVal);
      });

      test('should decode minimum value "0"', () {
        expect(codec.decode(minVal.toString()), minVal);
      });

      test('should decode maximum value "255"', () {
        expect(codec.decode(maxVal.toString()), maxVal);
      });

      test('should decode "127" to 127', () {
        expect(codec.decode('127'), 127);
      });

      test('whitespace handling', () {
        expect(codec.decode('  $maxVal  '), maxVal);
        expect(codec.decode('\t$minVal\n'), minVal);
        expect(codec.decode(' 128 '), 128);
      });

      test(
        'leading zeros (lexically valid for parsing, canonical form is different)',
        () {
          expect(codec.decode('007'), 7);
          expect(codec.decode('000'), 0);
        },
      );

      group('out of range values', () {
        test(
          'should throw FormatException for value greater than max (256)',
          () {
            expect(() => codec.decode('256'), throwsA(isA<FormatException>()));
          },
        );

        test(
          'should throw FormatException for negative value "-1" (lexically invalid first)',
          () {
            expect(() => codec.decode('-1'), throwsA(isA<FormatException>()));
          },
        );
      });

      group('invalid lexical values', () {
        test('should throw FormatException for "+127" (sign not allowed)', () {
          expect(() => codec.decode('+127'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "12.0"', () {
          expect(() => codec.decode('12.0'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "abc"', () {
          expect(() => codec.decode('abc'), throwsA(isA<FormatException>()));
        });
      });
    });

    group('encoder (xsd:unsignedByte)', () {
      test('should encode 0 to "0"', () {
        expect(codec.encode(0), '0');
      });
      test('should encode maxVal (255) to "255"', () {
        expect(codec.encode(maxVal), '255');
      });
      test('should encode 42 to "42"', () {
        expect(codec.encode(42), '42');
      });
    });
  });
}
