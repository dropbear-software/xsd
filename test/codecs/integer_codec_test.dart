import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdIntegerCodec', () {
    const codec = XsdIntegerCodec();

    test('should encode valid integer', () {
      expect(codec.encode(BigInt.from(123)), '123');
      expect(codec.encode(BigInt.from(-123)), '-123');
      expect(codec.encode(BigInt.zero), '0');
    });

    test('should decode valid integer', () {
      expect(codec.decode('123'), BigInt.from(123));
      expect(codec.decode('-123'), BigInt.from(-123));
      expect(codec.decode('0'), BigInt.zero);
      expect(codec.decode('  +123  '), BigInt.from(123));
    });

    test('should throw on invalid integer', () {
      expect(() => codec.decode('12.3'), throwsFormatException);
      expect(() => codec.decode('abc'), throwsFormatException);
    });
  });
}
