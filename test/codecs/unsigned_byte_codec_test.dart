import 'package:test/test.dart';
import 'package:xsd/src/codecs/unsigned_byte/unsigned_byte_codec.dart';

void main() {
  group('XsdUnsignedByteCodec', () {
    const codec = xsdUnsignedByteCodec;

    group('decoder', () {
      test('should decode a valid unsignedByte string', () {
        expect(codec.decode('123'), 123);
        expect(codec.decode('+123'), 123);
        expect(codec.decode('0'), 0);
        expect(codec.decode('255'), 255);
      });

      test('should handle whitespace correctly', () {
        expect(codec.decode('  123  '), 123);
        expect(codec.decode('\n42\t'), 42);
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.decode('256'), throwsFormatException);
        expect(() => codec.decode('-1'), throwsFormatException);
      });

      test('should throw a FormatException for invalid lexical format', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
        expect(() => codec.decode('--1'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid int', () {
        expect(codec.encode(123), '123');
        expect(codec.encode(0), '0');
        expect(codec.encode(255), '255');
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.encode(256), throwsFormatException);
        expect(() => codec.encode(-1), throwsFormatException);
      });
    });
  });
}
