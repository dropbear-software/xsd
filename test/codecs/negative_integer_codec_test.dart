import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdNegativeIntegerCodec', () {
    const codec = XsdNegativeIntegerCodec();

    test('should encode valid negative integer', () {
      expect(codec.encode(BigInt.from(-1)), '-1');
      expect(codec.encode(BigInt.from(-123)), '-123');
    });

    test('should decode valid negative integer', () {
      expect(codec.decode('-1'), BigInt.from(-1));
      expect(codec.decode('-123'), BigInt.from(-123));
      expect(codec.decode('  -123  '), BigInt.from(-123));
    });

    test('should throw on invalid negative integer', () {
      expect(() => codec.decode('0'), throwsFormatException);
      expect(() => codec.decode('1'), throwsFormatException);
      expect(() => codec.decode('abc'), throwsFormatException);
      expect(() => codec.decode(''), throwsFormatException);
      expect(() => codec.decode('   '), throwsFormatException);
      expect(() => codec.encode(BigInt.zero), throwsFormatException);
      expect(() => codec.encode(BigInt.one), throwsFormatException);
    });
  });
}
