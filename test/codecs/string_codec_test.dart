import 'package:test/test.dart';
import 'package:xsd/src/codecs/string/string_codec.dart';

void main() {
  group('XsdStringCodec', () {
    const codec = XsdStringCodec();

    group('decoder (XsdStringDecoder - preserve whitespace)', () {
      test('should preserve leading and trailing spaces', () {
        const value = '  hello world  ';
        expect(codec.decode(value), value);
      });

      test('should preserve internal spaces, tabs, and newlines', () {
        const value = 'hello  \t  world\nnext\rline';
        expect(codec.decode(value), value);
      });

      test('should handle empty string', () {
        const value = '';
        expect(codec.decode(value), value);
      });

      test('should handle string with only whitespace', () {
        const value = '  \t\n\r  ';
        expect(codec.decode(value), value);
      });

      test('should decode a typical string', () {
        const value = 'Hello World! 123 \$%^';
        expect(codec.decode(value), value);
      });
    });

    group('encoder (XsdStringEncoder)', () {
      test('should encode a typical string as itself', () {
        const value = 'Hello World! 123 \$%^';
        expect(codec.encode(value), value);
      });

      test(
        'should encode string with leading/trailing whitespace as itself',
        () {
          const value = '  indented  ';
          expect(codec.encode(value), value);
        },
      );

      test('should encode string with internal whitespace as itself', () {
        const value = 'multiple  \twords\nlines';
        expect(codec.encode(value), value);
      });

      test('should encode empty string as itself', () {
        const value = '';
        expect(codec.encode(value), value);
      });
    });

    group('codec (encode/decode)', () {
      test('encode followed by decode should return original string', () {
        const original = '  Test \t string \n with \r whitespace  ';
        final encoded = codec.encode(original);
        final decoded = codec.decode(encoded);
        expect(decoded, original);
      });

      test(
        'decode followed by encode should return original string (after preserve)',
        () {
          const original = '  Test \t string \n with \r whitespace  ';
          // For string with preserve, decode(original) is original
          final decoded = codec.decode(original);
          final encoded = codec.encode(decoded);
          expect(encoded, original);
        },
      );
    });
  });
}
