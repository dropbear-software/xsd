import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdDecimalCodec', () {
    const codec = XsdDecimalCodec();

    test('should encode valid decimal', () {
      expect(codec.encode(Decimal.parse('123.45')), '123.45');
      expect(codec.encode(Decimal.parse('-123.45')), '-123.45');
    });

    test('should decode valid decimal', () {
      expect(codec.decode('123.45'), Decimal.parse('123.45'));
      expect(codec.decode('-123.45'), Decimal.parse('-123.45'));
      expect(codec.decode('  +123.45  '), Decimal.parse('123.45'));
      expect(codec.decode('.45'), Decimal.parse('0.45'));
    });

    test('should throw on invalid decimal', () {
      expect(() => codec.decode('12.3.4'), throwsFormatException);
      expect(() => codec.decode('abc'), throwsFormatException);
      expect(
        () => codec.decode('1E4'),
        throwsFormatException,
      ); // Scientific notation not allowed in decimal
    });
  });
}
