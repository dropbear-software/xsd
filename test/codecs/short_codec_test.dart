import 'package:test/test.dart';
import 'package:xsd/src/codecs/short/short_codec.dart';

void main() {
  group('XsdShortCodec', () {
    const codec = xsdShortCodec;

    group('decoder', () {
      test('should decode a valid short string', () {
        expect(codec.decode('123'), 123);
        expect(codec.decode('+123'), 123);
        expect(codec.decode('-123'), -123);
        expect(codec.decode('0'), 0);
        expect(codec.decode('32767'), 32767);
        expect(codec.decode('-32768'), -32768);
      });

      test('should handle whitespace correctly', () {
        expect(codec.decode('  123  '), 123);
        expect(codec.decode('\n-123\t'), -123);
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.decode('32768'), throwsFormatException);
        expect(() => codec.decode('-32769'), throwsFormatException);
      });

      test('should throw a FormatException for invalid lexical format', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
        expect(() => codec.decode('+-1'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid int', () {
        expect(codec.encode(123), '123');
        expect(codec.encode(-123), '-123');
        expect(codec.encode(0), '0');
        expect(codec.encode(32767), '32767');
        expect(codec.encode(-32768), '-32768');
      });

      test('should throw a FormatException for out-of-range values', () {
        expect(() => codec.encode(32768), throwsFormatException);
        expect(() => codec.encode(-32769), throwsFormatException);
      });
    });
  });
}
