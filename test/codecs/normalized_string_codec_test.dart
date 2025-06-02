import 'package:test/test.dart';
import 'package:xsd/src/codecs/normalized_string/normalized_string_codec.dart';

void main() {
  group('XsdNormalizedStringCodec', () {
    const codec = XsdNormalizedStringCodec();

    group('decoder (whiteSpace="replace")', () {
      test('should replace tab with space', () {
        expect(codec.decode('hello\tworld'), 'hello world');
      });

      test('should replace newline with space', () {
        expect(codec.decode('hello\nworld'), 'hello world');
      });

      test('should replace carriage return with space', () {
        expect(codec.decode('hello\rworld'), 'hello world');
      });

      test(
        'should replace multiple mixed whitespace characters with spaces',
        () {
          expect(codec.decode('hello\t\n\rworld'), 'hello   world');
        },
      );

      test('should preserve leading and trailing spaces after replacement', () {
        expect(codec.decode('  hello\tworld  '), '  hello world  ');
      });

      test('should preserve multiple spaces if not tab, LF, or CR', () {
        expect(codec.decode('hello   world'), 'hello   world');
      });

      test('should handle empty string', () {
        expect(codec.decode(''), '');
      });

      test('should handle string with only spaces', () {
        expect(codec.decode('   '), '   ');
      });

      test('should handle string with only tabs, newlines, CRs', () {
        expect(codec.decode('\t\n\r'), '   ');
      });

      test('decode a typical string that needs no replacement', () {
        const value = 'This is a normalized string.';
        expect(codec.decode(value), value);
      });
    });

    group('encoder', () {
      // For normalizedString, the encoder typically assumes the input Dart string
      // already conforms to the value space (no tab, LF, CR).
      // If the goal is to take any Dart string and make it a valid XSD normalizedString,
      // the encoder might also apply 'replace', but typically encoding is about
      // representing an already-valid value. We'll assume identity for now.
      test('should encode a typical string as itself', () {
        const value = 'This is a normalized string.';
        expect(codec.encode(value), value);
      });

      test('should encode a string with spaces as itself', () {
        const value = '  leading and trailing spaces  ';
        expect(codec.encode(value), value);
      });

      test('should encode empty string as itself', () {
        expect(codec.encode(''), '');
      });
    });

    group('codec (encode/decode)', () {
      test(
        'encode then decode should be identity for already normalized strings',
        () {
          const original = 'this string has no forbidden whitespace';
          expect(codec.decode(codec.encode(original)), original);
        },
      );

      test('decode should normalize input', () {
        const inputWithTabs = 'decode\tme\nplease\r';
        const expectedAfterDecode = 'decode me please ';
        expect(codec.decode(inputWithTabs), expectedAfterDecode);
      });

      test('decode then encode should reflect the normalized form', () {
        const inputWithTabs = 'decode\tme\nplease\r';
        const normalized = 'decode me please ';
        expect(codec.encode(codec.decode(inputWithTabs)), normalized);
      });
    });
  });
}
