import 'package:test/test.dart';
import 'package:xsd/src/codecs/boolean/boolean_codec.dart';

void main() {
  group('XsdBooleanCodec', () {
    const codec = XsdBooleanCodec();

    group('decoder', () {
      test('should decode "true" to true', () {
        expect(codec.decode('true'), isTrue);
      });

      test('should decode "1" to true', () {
        expect(codec.decode('1'), isTrue);
      });

      test('should decode "false" to false', () {
        expect(codec.decode('false'), isFalse);
      });

      test('should decode "0" to false', () {
        expect(codec.decode('0'), isFalse);
      });

      group('whitespace handling (collapse)', () {
        test('should decode " true " to true', () {
          expect(codec.decode(' true '), isTrue);
        });

        test('should decode "  1  " to true', () {
          expect(codec.decode('  1  '), isTrue);
        });

        test('should decode "false    " to false', () {
          expect(codec.decode('false    '), isFalse);
        });

        test('should decode "    0" to false', () {
          expect(codec.decode('    0'), isFalse);
        });

        test('should decode "  true     " to true', () {
          expect(codec.decode('  true     '), isTrue);
        });

        test('should decode "\\ttrue\\n" to true', () {
          expect(codec.decode('\ttrue\n'), isTrue);
        });

        test('should decode "false\\r\\n" to false', () {
          expect(codec.decode('false\r\n'), isFalse);
        });

        test('should decode "  \\t 1 \\n \\r " to true', () {
          expect(codec.decode('  \t 1 \n \r '), isTrue);
        });
      });

      group('invalid values', () {
        test('should throw FormatException for " TRUE "', () {
          // Whitespace collapse turns " TRUE " into "TRUE"
          expect(() => codec.decode(' TRUE '), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for "yes"', () {
          expect(() => codec.decode('yes'), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for "01"', () {
          expect(() => codec.decode('01'), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for "" (empty string)', () {
          expect(() => codec.decode(''), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for "  " (only whitespace)', () {
          expect(() => codec.decode('  '), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "true false"', () {
          expect(
            () => codec.decode('true false'),
            throwsA(isA<FormatException>()),
          );
        });
        test('should throw FormatException for "1 0"', () {
          expect(() => codec.decode('1 0'), throwsA(isA<FormatException>()));
        });
      });
    });

    group('encoder', () {
      test('should encode true to "true"', () {
        expect(codec.encode(true), 'true');
      });

      test('should encode false to "false"', () {
        expect(codec.encode(false), 'false');
      });
    });
  });
}
