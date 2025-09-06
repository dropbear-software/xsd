import 'package:test/test.dart';
import 'package:xsd/src/codecs/long/long_codec.dart';

void main() {
  group('XsdLongCodec', () {
    const codec = xsdLongCodec;
    final minLongStr = '-9223372036854775808';
    final maxLongStr = '9223372036854775807';
    final minLong = BigInt.parse(minLongStr);
    final maxLong = BigInt.parse(maxLongStr);

    group('decoder', () {
      test('should decode valid long strings', () {
        expect(codec.decode('0'), BigInt.zero);
        expect(codec.decode('12345'), BigInt.from(12345));
        expect(codec.decode('-12345'), BigInt.from(-12345));
        expect(codec.decode('007'), BigInt.from(7));
        expect(codec.decode(maxLongStr), maxLong);
        expect(codec.decode(minLongStr), minLong);
      });

      test('should handle whitespace', () {
        expect(codec.decode('  100  '), BigInt.from(100));
        expect(codec.decode('\n-456\t'), BigInt.from(-456));
      });

      test('should throw FormatException for out-of-range values', () {
        final overMax = maxLong + BigInt.one;
        expect(() => codec.decode(overMax.toString()), throwsFormatException);

        final underMin = minLong - BigInt.one;
        expect(() => codec.decode(underMin.toString()), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical formats', () {
        expect(() => codec.decode(''), throwsFormatException);
        expect(() => codec.decode('abc'), throwsFormatException);
        expect(() => codec.decode('1.0'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode valid BigInt values', () {
        expect(codec.encode(BigInt.zero), '0');
        expect(codec.encode(BigInt.from(12345)), '12345');
        expect(codec.encode(BigInt.from(-12345)), '-12345');
        expect(codec.encode(maxLong), maxLongStr);
        expect(codec.encode(minLong), minLongStr);
      });

      test('should throw FormatException for out-of-range values', () {
        final overMax = maxLong + BigInt.one;
        expect(() => codec.encode(overMax), throwsFormatException);

        final underMin = minLong - BigInt.one;
        expect(() => codec.encode(underMin), throwsFormatException);
      });
    });
  });
}
