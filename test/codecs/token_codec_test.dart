import 'package:test/test.dart';
import 'package:xsd/src/codecs/token/token_codec.dart';

void main() {
  group('XsdTokenCodec', () {
    const codec = XsdTokenCodec();

    group('decoder (whiteSpace="collapse")', () {
      test('should replace tab, LF, CR and collapse multiple spaces', () {
        expect(codec.decode('hello\t\n \rworld'), 'hello world');
      });

      test('should remove leading and trailing spaces', () {
        expect(codec.decode('  hello world  '), 'hello world');
      });

      test(
        'should remove leading/trailing and collapse internal whitespace characters',
        () {
          expect(codec.decode('\t  hello   \n \r world  \t'), 'hello world');
        },
      );

      test('should collapse multiple internal spaces to one', () {
        expect(codec.decode('hello    world'), 'hello world');
      });

      test('empty string should remain empty string', () {
        expect(codec.decode(''), '');
      });

      test('string of only whitespace should become empty string', () {
        expect(codec.decode('  \t\n\r  '), '');
      });

      test(
        'a string that is already a valid token should remain unchanged',
        () {
          const value = 'This-is-a-valid-token_123';
          expect(codec.decode(value), value);
        },
      );

      test('single word with surrounding mixed whitespace', () {
        expect(codec.decode('\n\t  TOKEN  \r'), 'TOKEN');
      });
    });

    group('encoder', () {
      // For token, the encoder typically assumes the input Dart string
      // already conforms to the value space (no tab, LF, CR, no leading/trailing/multiple spaces).
      // We'll assume identity for now.
      test('should encode a typical token string as itself', () {
        const value = 'ActualToken';
        expect(codec.encode(value), value);
      });

      test('should encode empty string as itself', () {
        expect(codec.encode(''), '');
      });

      test('should encode a string with single internal spaces as itself', () {
        const value = 'token with spaces';
        expect(codec.encode(value), value);
      });
    });

    group('codec (encode/decode)', () {
      test(
        'encode then decode should be identity for already tokenized strings',
        () {
          const original = 'this-is-a-token';
          expect(codec.decode(codec.encode(original)), original);
        },
      );

      test('decode should normalize and collapse input', () {
        const inputWithMixedWhitespace =
            '\t  leading space   internal\n\rfinal\t';
        const expectedAfterDecode = 'leading space internal final';
        expect(codec.decode(inputWithMixedWhitespace), expectedAfterDecode);
      });

      test('decode then encode should reflect the collapsed form', () {
        const inputWithMixedWhitespace =
            '\t  leading space   internal\n\rfinal\t';
        const expectedTokenForm = 'leading space internal final';
        expect(
          codec.encode(codec.decode(inputWithMixedWhitespace)),
          expectedTokenForm,
        );
      });

      test('decode an empty string from only whitespace', () {
        const inputOnlyWhitespace = '  \n\t \r ';
        const expectedAfterDecode = '';
        expect(codec.decode(inputOnlyWhitespace), expectedAfterDecode);
        expect(
          codec.encode(codec.decode(inputOnlyWhitespace)),
          expectedAfterDecode,
        );
      });
    });
  });
}
