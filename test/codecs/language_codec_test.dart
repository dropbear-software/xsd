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

      // Source: https://github.com/w3c/xsdtests/tree/master/nistData/atomic/language
      test('should decode NIST provided examples', () {
        expect(codec.decode('AF'), Locale.parse('AF'));
        expect(codec.decode('AM'), Locale.parse('AM'));
        expect(codec.decode('AR'), Locale.parse('AR'));
        expect(codec.decode('AS'), Locale.parse('AS'));
        expect(codec.decode('AY'), Locale.parse('AY'));
        expect(codec.decode('AZ'), Locale.parse('AZ'));
        expect(codec.decode('BA'), Locale.parse('BA'));
        expect(codec.decode('BE'), Locale.parse('BE'));
        expect(codec.decode('SL'), Locale.parse('SL'));
        expect(codec.decode('SM'), Locale.parse('SM'));
        expect(codec.decode('SN'), Locale.parse('SN'));
        expect(codec.decode('SO'), Locale.parse('SO'));
        expect(codec.decode('SQ'), Locale.parse('SQ'));
        expect(codec.decode('SR'), Locale.parse('SR'));
        expect(codec.decode('SS'), Locale.parse('SS'));
        expect(codec.decode('BG'), Locale.parse('BG'));
        expect(codec.decode('BH'), Locale.parse('BH'));
        expect(codec.decode('BI'), Locale.parse('BI'));
        expect(codec.decode('BN'), Locale.parse('BN'));
        expect(codec.decode('BO'), Locale.parse('BO'));
        expect(codec.decode('BR'), Locale.parse('BR'));
        expect(codec.decode('CA'), Locale.parse('CA'));
        expect(codec.decode('CO'), Locale.parse('CO'));
        expect(codec.decode('CS'), Locale.parse('CS'));
        expect(codec.decode('CY'), Locale.parse('CY'));
        expect(codec.decode('OM-a'), Locale.parse('OM-a'));
        expect(codec.decode('PL-UK'), Locale.parse('PL-UK'));
        // expect(codec.decode('MO-USA'), Locale.parse('MO-USA'));
        expect(codec.decode('NL-LANG'), Locale.parse('NL-LANG'));
        expect(codec.decode('BE-Thailand'), Locale.parse('BE-Thailand'));
        // expect(codec.decode('ZH-USA'), Locale.parse('ZH-USA'));
        expect(codec.decode('KL-CHINA'), Locale.parse('KL-CHINA'));
        expect(codec.decode('YO-Indian'), Locale.parse('YO-Indian'));
        expect(codec.decode('VO-Thailand'), Locale.parse('VO-Thailand'));
        expect(codec.decode('CA-Thailand'), Locale.parse('CA-Thailand'));
        expect(codec.decode('CS-Ebonics'), Locale.parse('CS-Ebonics'));
        expect(codec.decode('TO-Thailand'), Locale.parse('TO-Thailand'));
        expect(codec.decode('ZH-Ebonics'), Locale.parse('ZH-Ebonics'));
        expect(codec.decode('ES-CHINA'), Locale.parse('ES-CHINA'));
        expect(codec.decode('FJ-Indian'), Locale.parse('FJ-Indian'));
        expect(codec.decode('ML-Ebonics'), Locale.parse('ML-Ebonics'));
        expect(codec.decode('IA-CHINA'), Locale.parse('IA-CHINA'));
        expect(codec.decode('AF-Indian'), Locale.parse('AF-Indian'));
        expect(codec.decode('KM-Ebonics'), Locale.parse('KM-Ebonics'));
        expect(codec.decode('AA-Thailand'), Locale.parse('AA-Thailand'));
        expect(codec.decode('HR-Indian'), Locale.parse('HR-Indian'));
        expect(codec.decode('OM-Ebonics'), Locale.parse('OM-Ebonics'));
        expect(codec.decode('CY-a'), Locale.parse('CY-a'));
        expect(codec.decode('BA-a'), Locale.parse('BA-a'));
        expect(codec.decode('TW-UK'), Locale.parse('TW-UK'));
        expect(codec.decode('MY'), Locale.parse('MY'));
        expect(codec.decode('FJ'), Locale.parse('FJ'));
        expect(codec.decode('HR-a'), Locale.parse('HR-a'));
        expect(codec.decode('XH-a'), Locale.parse('XH-a'));
        expect(codec.decode('LT-UK'), Locale.parse('LT-UK'));
        expect(codec.decode('MK'), Locale.parse('MK'));
        expect(codec.decode('MR'), Locale.parse('MR'));
        expect(codec.decode('YO-a'), Locale.parse('YO-a'));
        expect(codec.decode('TE-a'), Locale.parse('TE-a'));
        expect(codec.decode('SG-UK'), Locale.parse('SG-UK'));
        expect(codec.decode('TO-CHINA'), Locale.parse('TO-CHINA'));
        expect(codec.decode('UK'), Locale.parse('UK'));
        expect(codec.decode('IN'), Locale.parse('IN'));
        expect(codec.decode('IK'), Locale.parse('IK'));
        expect(codec.decode('PL-a'), Locale.parse('PL-a'));
        // expect(codec.decode('EN-USA'), Locale.parse('EN-USA'));
        expect(codec.decode('BE-CHINA'), Locale.parse('BE-CHINA'));
        expect(codec.decode('SD-Ebonics'), Locale.parse('SD-Ebonics'));
        expect(codec.decode('EU'), Locale.parse('EU'));
        expect(codec.decode('IS'), Locale.parse('IS'));
        expect(codec.decode('PT'), Locale.parse('PT'));
        expect(codec.decode('BO-LANG'), Locale.parse('BO-LANG'));
        expect(codec.decode('SD-LANG'), Locale.parse('SD-LANG'));
        expect(codec.decode('TI-LANG'), Locale.parse('TI-LANG'));
        expect(codec.decode('BI-LANG'), Locale.parse('BI-LANG'));
        expect(codec.decode('PL-LANG'), Locale.parse('PL-LANG'));
        expect(codec.decode('HU-Ebonics'), Locale.parse('HU-Ebonics'));
        expect(codec.decode('MR-Ebonics'), Locale.parse('MR-Ebonics'));
        expect(codec.decode('TT-Ebonics'), Locale.parse('TT-Ebonics'));
        expect(codec.decode('TR-Ebonics'), Locale.parse('TR-Ebonics'));
        expect(codec.decode('GN-Ebonics'), Locale.parse('GN-Ebonics'));
        expect(codec.decode('FI-UK'), Locale.parse('FI-UK'));
        expect(codec.decode('TN-UK'), Locale.parse('TN-UK'));
        expect(codec.decode('HU-UK'), Locale.parse('HU-UK'));
        expect(codec.decode('ZH-Thailand'), Locale.parse('ZH-Thailand'));
        expect(codec.decode('TN-Thailand'), Locale.parse('TN-Thailand'));
        expect(codec.decode('ML-Thailand'), Locale.parse('ML-Thailand'));
        expect(codec.decode('FY-Thailand'), Locale.parse('FY-Thailand'));
        expect(codec.decode('IS-Thailand'), Locale.parse('IS-Thailand'));
        expect(codec.decode('BA-LANG'), Locale.parse('BA-LANG'));
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
