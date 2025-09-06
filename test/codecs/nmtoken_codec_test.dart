import 'package:test/test.dart';
import 'package:xsd/src/codecs/nmtoken/nmtoken_codec.dart';

void main() {
  group('XsdNmtokenCodec', () {
    const codec = xsdNmtokenCodec;

    group('decoder', () {
      test('should decode a valid NMTOKEN string', () {
        expect(codec.decode('valid-nmtoken_1.2:3'), 'valid-nmtoken_1.2:3');
        expect(codec.decode('12345'), '12345');
        expect(codec.decode('.start'), '.start');
        expect(codec.decode('עם-שלום'), 'עם-שלום'); // Unicode example
      });

      test('should collapse whitespace before validation', () {
        expect(codec.decode('  \n valid-nmtoken\t  '), 'valid-nmtoken');
      });

      test('should throw FormatException for strings with internal spaces', () {
        expect(() => codec.decode('invalid nmtoken'), throwsFormatException);
      });

      test(
        'should throw FormatException for empty or whitespace-only strings',
        () {
          expect(() => codec.decode(''), throwsFormatException);
          expect(() => codec.decode('   \t\n '), throwsFormatException);
        },
      );

      test('should throw FormatException for invalid characters', () {
        expect(() => codec.decode('invalid!'), throwsFormatException);
        expect(() => codec.decode('in/valid'), throwsFormatException);
        expect(() => codec.decode('in,valid'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid NMTOKEN string', () {
        expect(codec.encode('valid-nmtoken_1.2:3'), 'valid-nmtoken_1.2:3');
        expect(codec.encode('עם-שלום'), 'עם-שלום');
      });

      test('should throw FormatException for strings with any whitespace', () {
        expect(() => codec.encode('invalid nmtoken'), throwsFormatException);
        expect(() => codec.encode(' leading-space'), throwsFormatException);
        expect(() => codec.encode('trailing-space '), throwsFormatException);
      });

      test('should throw FormatException for empty strings', () {
        expect(() => codec.encode(''), throwsFormatException);
      });

      test('should throw FormatException for invalid characters', () {
        expect(() => codec.encode('invalid!'), throwsFormatException);
        expect(() => codec.encode('in/valid'), throwsFormatException);
        expect(() => codec.encode('in,valid'), throwsFormatException);
      });
    });
  });
}
