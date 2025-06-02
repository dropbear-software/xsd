import 'package:test/test.dart';
import 'package:xsd/src/codecs/nmtoken/nmtoken_codec.dart';

void main() {
  group('XsdNmtokenCodec', () {
    const codec = XsdNmtokenCodec();

    group('decoder (xsd:NMTOKEN)', () {
      // Valid NMTOKENs (based on XML 1.0 NameChar)
      test('should decode valid NMTOKENs', () {
        expect(codec.decode('token1'), 'token1');
        expect(codec.decode('with-hyphen'), 'with-hyphen');
        expect(codec.decode('with.dot'), 'with.dot');
        expect(codec.decode('with_underscore'), 'with_underscore');
        expect(codec.decode('with:colon'), 'with:colon');
        expect(codec.decode('A123'), 'A123');
        expect(codec.decode('123'), '123'); // Digits are NameChars
        expect(codec.decode('.'), '.'); // Single NameChars
        expect(codec.decode('-'), '-');
        expect(codec.decode('_'), '_');
        expect(codec.decode(':'), ':');
        expect(codec.decode('a_b-c:d.e1'), 'a_b-c:d.e1');
        // Unicode examples (if \p{L}, \p{Nl}, \p{M}, \p{Lm}, \p{Sk} are correctly handled)
        expect(codec.decode('écran'), 'écran'); // \p{L} and \p{M}
        expect(codec.decode('ماسح'), 'ماسح'); // Arabic letters (\p{L})
        expect(codec.decode('価格'), '価格'); // Japanese characters (\p{L})
        expect(codec.decode('Ⅲ'), 'Ⅲ'); // Roman numeral three (\p{Nl})
        // Modifier letter example (U+02B0 MODIFIER LETTER SMALL H)
        expect(codec.decode('h\u02B0'), 'h\u02B0');
      });

      test(
        'whitespace handling (collapse)',
        () {
          expect(codec.decode('  token1  '), 'token1');
          expect(codec.decode('\ttoken1\n'), 'token1');
          expect(
            codec.decode(' leading space'),
            'leading space',
          ); // Invalid, space not NameChar
        },
        skip:
            'Collapsed string "leading space" is invalid due to space, covered by invalid tests',
      );

      group('invalid lexical values', () {
        test(
          'should throw FormatException for empty string after collapse',
          () {
            expect(() => codec.decode(''), throwsA(isA<FormatException>()));
            expect(() => codec.decode('   '), throwsA(isA<FormatException>()));
          },
        );

        test(
          'should throw FormatException for strings with spaces (after collapse)',
          () {
            expect(
              () => codec.decode('token with space'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('  token with space  '),
              throwsA(isA<FormatException>()),
            );
          },
        );

        test(
          'should throw FormatException for strings with invalid characters',
          () {
            expect(
              () => codec.decode('token!'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('token@'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('<tag>'),
              throwsA(isA<FormatException>()),
            );
            expect(() => codec.decode('('), throwsA(isA<FormatException>()));
          },
        );
      });
    });

    group('encoder (xsd:NMTOKEN)', () {
      test('should encode a valid NMTOKEN string as itself', () {
        expect(codec.encode('token1'), 'token1');
        expect(
          codec.encode('with-hyphen.and_colon:123'),
          'with-hyphen.and_colon:123',
        );
      });
    });

    group('codec (round trip)', () {
      test('round trip for valid NMTOKEN', () {
        const value = 'Simple-NMTOKEN_1.2:3';
        expect(codec.decode(value), value);
        expect(codec.encode(codec.decode(value)), value);
      });

      test('round trip with initial whitespace (decode normalizes)', () {
        const valueWithWhitespace = '  ValidNMTOKEN  ';
        const normalizedValue = 'ValidNMTOKEN';
        expect(codec.decode(valueWithWhitespace), normalizedValue);
        expect(
          codec.encode(codec.decode(valueWithWhitespace)),
          normalizedValue,
        );
      });
    });
  });
}
