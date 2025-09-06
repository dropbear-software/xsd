import 'package:test/test.dart';
import 'package:xsd/src/codecs/byte/byte_codec.dart';

void main() {
  group('XsdByteCodec', () {
    const codec = xsdByteCodec;

    group('decoder', () {
      test('should decode a valid byte string', () {
        expect(codec.decode('100'), 100);
        expect(codec.decode('+100'), 100);
        expect(codec.decode('-100'), -100);
        expect(codec.decode('0'), 0);
        expect(codec.decode('127'), 127);
        expect(codec.decode('-128'), -128);
      });

      test('should handle whitespace correctly', () {
        expect(codec.decode('  -42\t'), -42);
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.decode('128'), throwsFormatException);
        expect(() => codec.decode('-129'), throwsFormatException);
      });

      test('should handle leading zeros correctly', () {
        expect(codec.decode('007'), 7);
      });

      test('should throw a FormatException for invalid lexical format', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid int', () {
        expect(codec.encode(100), '100');
        expect(codec.encode(-100), '-100');
        expect(codec.encode(0), '0');
        expect(codec.encode(127), '127');
        expect(codec.encode(-128), '-128');
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.encode(128), throwsFormatException);
        expect(() => codec.encode(-129), throwsFormatException);
      });
    });
  });
}
