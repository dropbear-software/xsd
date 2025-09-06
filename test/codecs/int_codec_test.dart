import 'package:test/test.dart';
import 'package:xsd/src/codecs/int/int_codec.dart';

void main() {
  group('XsdIntCodec', () {
    const codec = xsdIntCodec;
    const minInt = -2147483648;
    const maxInt = 2147483647;

    group('decoder', () {
      test('should decode valid int strings', () {
        expect(codec.decode('12345'), 12345);
        expect(codec.decode('+12345'), 12345);
        expect(codec.decode('-12345'), -12345);
        expect(codec.decode('0'), 0);
        expect(codec.decode(maxInt.toString()), maxInt);
        expect(codec.decode(minInt.toString()), minInt);
      });

      test('should handle whitespace correctly', () {
        expect(codec.decode('  -100  '), -100);
        expect(codec.decode('\n-456\t'), -456);
      });

      test('should handle leading zeros correctly', () {
        expect(codec.decode('007'), 7);
      });

      test('should throw FormatException for out-of-range values', () {
        final overMax = BigInt.from(maxInt) + BigInt.one;
        expect(() => codec.decode(overMax.toString()), throwsFormatException);

        final underMin = BigInt.from(minInt) - BigInt.one;
        expect(() => codec.decode(underMin.toString()), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical formats', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode valid int values', () {
        expect(codec.encode(12345), '12345');
        expect(codec.encode(-12345), '-12345');
        expect(codec.encode(0), '0');
        expect(codec.encode(maxInt), maxInt.toString());
        expect(codec.encode(minInt), minInt.toString());
      });

      test('should throw FormatException for out-of-range values', () {
        // Values are tested as BigInts to avoid overflow on native platforms
        // when creating the test value itself.
        final overMax = maxInt + 1;
        expect(() => codec.encode(overMax), throwsFormatException);

        final underMin = minInt - 1;
        expect(() => codec.encode(underMin), throwsFormatException);
      });
    });
  });
}
