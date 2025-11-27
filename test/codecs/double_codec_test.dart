import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdDoubleCodec', () {
    const codec = XsdDoubleCodec();

    test('should encode valid double', () {
      expect(codec.encode(123.45), '123.45');
      expect(codec.encode(-123.45), '-123.45');
      expect(codec.encode(double.infinity), 'INF');
      expect(codec.encode(double.negativeInfinity), '-INF');
      expect(codec.encode(double.nan), 'NaN');
      expect(codec.encode(double.nan), 'NaN');
    });

    test('should decode valid double', () {
      expect(codec.decode('123.45'), 123.45);
      expect(codec.decode('-123.45'), -123.45);
      expect(codec.decode('INF'), double.infinity);
      expect(codec.decode('-INF'), double.negativeInfinity);
      expect(codec.decode('NaN').isNaN, isTrue);
      expect(codec.decode('1.2E3'), 1200.0);
      expect(codec.decode('1.2e3'), 1200.0);
    });

    test('should handle whitespace collapsing', () {
      expect(codec.decode('  123.45  '), 123.45);
      expect(codec.decode('\n-123.45\t'), -123.45);
    });

    test('should throw FormatException for invalid input', () {
      expect(() => codec.decode('invalid'), throwsFormatException);
      expect(() => codec.decode('1.2.3'), throwsFormatException);
    });
  });
}
