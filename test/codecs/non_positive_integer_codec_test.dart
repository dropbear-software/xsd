import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdNonPositiveIntegerCodec', () {
    const codec = XsdNonPositiveIntegerCodec();

    group('decoder', () {
      test('should decode a valid non-positive integer string', () {
        expect(codec.decode('0'), BigInt.zero);
        expect(codec.decode('-1'), BigInt.from(-1));
        expect(codec.decode('-123'), BigInt.from(-123));
        expect(
          codec.decode(
            '-9999999999999999999999999999999999999999999999999999999999',
          ),
          BigInt.parse(
            '-9999999999999999999999999999999999999999999999999999999999',
          ),
        );
      });

      test('should throw a FormatException for a positive integer', () {
        expect(() => codec.decode('1'), throwsFormatException);
      });

      test('should throw a FormatException for an empty string', () {
        expect(() => codec.decode(''), throwsFormatException);
      });

      test('should throw a FormatException for a non-integer string', () {
        expect(() => codec.decode('abc'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid non-positive integer', () {
        expect(codec.encode(BigInt.zero), '0');
        expect(codec.encode(BigInt.from(-1)), '-1');
        expect(codec.encode(BigInt.from(-123)), '-123');
        expect(
          codec.encode(
            BigInt.parse(
              '-9999999999999999999999999999999999999999999999999999999999',
            ),
          ),
          '-9999999999999999999999999999999999999999999999999999999999',
        );
      });

      test('should throw a FormatException for a positive integer', () {
        expect(() => codec.encode(BigInt.one), throwsFormatException);
      });
    });
  });
}
