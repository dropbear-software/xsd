import 'package:intl/locale.dart';
import 'package:test/test.dart';
import 'package:xsd/src/codecs/language/language_codec.dart';

void main() {
  group('XsdLanguageCodec', () {
    const codec = XsdLanguageCodec();

    group('decoder', () {
      test('should decode valid language tags', () {
        expect(codec.decode('en'), Locale.parse('en'));
        expect(codec.decode('en-US'), Locale.parse('en-US'));
        expect(codec.decode('fr-CA'), Locale.parse('fr-CA'));
        expect(codec.decode('zh-Hans'), Locale.parse('zh-Hans'));
        expect(
          codec.decode('de-Latn-DE-1996'),
          Locale.parse('de-Latn-DE-1996'),
        );
        expect(codec.decode('de-DE-x-goethe'), Locale.parse('de-DE-x-goethe'));
        expect(codec.decode('de-Latf-DE'), Locale.parse('de-Latf-DE'));
        expect(codec.decode('es-013'), Locale.parse('es-013'));
        expect(codec.decode('ru-Cyrl-BY'), Locale.parse('ru-Cyrl-BY'));
      });

      test('whitespace handling (collapse)', () {
        expect(codec.decode('  en-US  '), Locale.parse('en-US'));
        expect(codec.decode('\tde\n'), Locale.parse('de'));
      });

      group('invalid lexical values', () {
        test('should throw FormatException for empty string', () {
          expect(() => codec.decode(''), throwsA(isA<FormatException>()));
          expect(() => codec.decode('   '), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for invalid tags', () {
          expect(() => codec.decode('en_'), throwsA(isA<FormatException>()));
          expect(() => codec.decode('123'), throwsA(isA<FormatException>()));
        });
      });
    });

    group('encoder', () {
      test('should encode Locale to string', () {
        expect(codec.encode(Locale.parse('en-US')), 'en-US');
        expect(codec.encode(Locale.parse('de')), 'de');
      });
    });

    group('codec (round trip)', () {
      test('round trip for valid language tag', () {
        final locale = Locale.parse('en-GB');
        final encoded = codec.encode(locale);
        expect(encoded, 'en-GB');
        expect(codec.decode(encoded), locale);
      });
    });
  });
}
