import 'package:test/test.dart';
import 'package:xsd/src/codecs/long/long_codec.dart';

void main() {
  group('XsdLongCodec', () {
    const codec = xsdLongCodec;
    const minLongStr = '-9223372036854775808';
    const maxLongStr = '9223372036854775807';
    final minLongInt = int.parse(minLongStr);
    final maxLongInt = int.parse(maxLongStr);

    group('decoder', () {
      test('should decode valid long strings', () {
        expect(codec.decode('0'), 0);
        expect(codec.decode('12345'), 12345);
        expect(codec.decode('-12345'), -12345);
        expect(codec.decode(maxLongStr), maxLongInt);
        expect(codec.decode(minLongStr), minLongInt);
      });

      test('should handle whitespace', () {
        expect(codec.decode('  100  '), 100);
      });

      test('should throw FormatException for out-of-range values', () {
        // One more than max
        final overMax = BigInt.parse(maxLongStr) + BigInt.one;
        expect(() => codec.decode(overMax.toString()), throwsFormatException);

        // One less than min
        final underMin = BigInt.parse(minLongStr) - BigInt.one;
        expect(() => codec.decode(underMin.toString()), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical formats', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode valid int values', () {
        expect(codec.encode(0), '0');
        expect(codec.encode(12345), '12345');
        expect(codec.encode(-12345), '-12345');
        expect(codec.encode(maxLongInt), maxLongStr);
        expect(codec.encode(minLongInt), minLongStr);
      });
    });
  });
}
