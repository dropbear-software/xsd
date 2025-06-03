import 'package:test/test.dart';
import 'package:xsd/src/codecs/byte/byte_codec.dart';

void main() {
  group('XsdByteCodec', () {
    const codec = XsdByteCodec();
    const minByte = -128;
    const maxByte = 127;

    group('decoder (xsd:byte)', () {
      test('should decode "0" to 0', () {
        expect(codec.decode('0'), 0);
      });

      test('should decode minimum byte value', () {
        expect(codec.decode(minByte.toString()), minByte);
      });

      test('should decode maximum byte value', () {
        expect(codec.decode(maxByte.toString()), maxByte);
      });

      test('should decode "+127" to 127', () {
        expect(codec.decode('+127'), 127);
      });

      test('should decode "42" to 42', () {
        expect(codec.decode('42'), 42);
      });

      test('whitespace handling', () {
        expect(codec.decode('  $maxByte  '), maxByte);
        expect(codec.decode('\t$minByte\n'), minByte);
      });

      test('leading zeros', () {
        expect(codec.decode('007'), 7);
        expect(codec.decode('-01'), -1);
      });

      group('out of range values', () {
        test(
          'should throw FormatException for value greater than maxByte (128)',
          () {
            expect(() => codec.decode('128'), throwsA(isA<FormatException>()));
          },
        );

        test(
          'should throw FormatException for value less than minByte (-129)',
          () {
            expect(() => codec.decode('-129'), throwsA(isA<FormatException>()));
          },
        );
      });

      group('invalid lexical values', () {
        test('should throw FormatException for "64.0"', () {
          expect(() => codec.decode('64.0'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "xyz"', () {
          expect(() => codec.decode('xyz'), throwsA(isA<FormatException>()));
        });
      });
    });

    group('encoder (xsd:byte)', () {
      test('should encode 0 to "0"', () {
        expect(codec.encode(0), '0');
      });
      test('should encode maxByte to its string', () {
        expect(codec.encode(maxByte), maxByte.toString());
      });
      test('should encode minByte to its string', () {
        expect(codec.encode(minByte), minByte.toString());
      });
      test('should encode 42 to "42"', () {
        expect(codec.encode(42), '42');
      });
    });
  });
}
