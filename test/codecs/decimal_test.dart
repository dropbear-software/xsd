import 'package:test/test.dart';
import 'package:xsd/src/codecs/decimal.dart';

void main() {
  group('XsdDecimal Core', () {
    test('Internal normalization strips trailing fractional zeros', () {
      final d1 = XsdDecimal(BigInt.from(12300), 2); // 123.00
      expect(d1.unscaledValue, equals(BigInt.from(123)));
      expect(d1.scale, equals(0));

      final d2 = XsdDecimal(BigInt.from(12345), 3); // 12.345
      expect(d2.unscaledValue, equals(BigInt.from(12345)));
      expect(d2.scale, equals(3));

      final d3 = XsdDecimal(BigInt.zero, 5); // 0.00000
      expect(d3.unscaledValue, equals(BigInt.zero));
      expect(d3.scale, equals(0));
    });

    test('Equality and hashCode', () {
      final d1 = XsdDecimal(BigInt.from(123), 0); // 123
      final d2 = XsdDecimal(BigInt.from(1230), 1); // 123.0
      final d3 = XsdDecimal(BigInt.from(12300), 2); // 123.00

      expect(d1, equals(d2));
      expect(d1, equals(d3));
      expect(d1.hashCode, equals(d2.hashCode));
      expect(d1.hashCode, equals(d3.hashCode));
    });

    test('Comparable implementation', () {
      final d1 = XsdDecimal(BigInt.from(10), 0); // 10
      final d2 = XsdDecimal(BigInt.from(20), 0); // 20
      final d3 = XsdDecimal(BigInt.from(15), 0); // 15

      final list = [d2, d1, d3];
      list.sort();

      expect(list, equals([d1, d3, d2]));
    });
  });

  group('XsdDecimal Parsing', () {
    test('Valid lexical representations', () {
      expect(XsdDecimal.parse('123'), equals(XsdDecimal(BigInt.from(123), 0)));
      expect(
        XsdDecimal.parse('123.456'),
        equals(XsdDecimal(BigInt.from(123456), 3)),
      );
      expect(
        XsdDecimal.parse('+123.456'),
        equals(XsdDecimal(BigInt.from(123456), 3)),
      );
      expect(
        XsdDecimal.parse('-123.456'),
        equals(XsdDecimal(BigInt.from(-123456), 3)),
      );
      expect(XsdDecimal.parse('.5'), equals(XsdDecimal(BigInt.from(5), 1)));
      expect(XsdDecimal.parse('-.5'), equals(XsdDecimal(BigInt.from(-5), 1)));
      expect(XsdDecimal.parse('+.5'), equals(XsdDecimal(BigInt.from(5), 1)));
      expect(XsdDecimal.parse('1.'), equals(XsdDecimal(BigInt.one, 0)));
      expect(XsdDecimal.parse('0.0'), equals(XsdDecimal(BigInt.zero, 0)));
      expect(XsdDecimal.parse('-0.0'), equals(XsdDecimal(BigInt.zero, 0)));
      expect(
        XsdDecimal.parse('007.50'),
        equals(XsdDecimal(BigInt.from(75), 1)),
      );
    });

    test('Invalid lexical representations', () {
      expect(() => XsdDecimal.parse('1E2'), throwsFormatException);
      expect(() => XsdDecimal.parse('NaN'), throwsFormatException);
      expect(() => XsdDecimal.parse('INF'), throwsFormatException);
      expect(() => XsdDecimal.parse('-INF'), throwsFormatException);
      expect(() => XsdDecimal.parse('123.456.789'), throwsFormatException);
      expect(() => XsdDecimal.parse('abc'), throwsFormatException);
      expect(() => XsdDecimal.parse(''), throwsFormatException);
      expect(() => XsdDecimal.parse('.'), throwsFormatException);
    });
  });

  group('XsdDecimalCodec', () {
    const codec = XsdDecimalCodec();

    test('encode (Canonical Lexical Mapping)', () {
      expect(codec.encode(XsdDecimal(BigInt.from(123), 0)), equals('123'));
      expect(codec.encode(XsdDecimal(BigInt.from(1230), 1)), equals('123'));
      expect(
        codec.encode(XsdDecimal(BigInt.from(-123456), 3)),
        equals('-123.456'),
      );
      expect(codec.encode(XsdDecimal(BigInt.from(5), 1)), equals('0.5'));
      expect(codec.encode(XsdDecimal(BigInt.from(-5), 1)), equals('-0.5'));
      expect(codec.encode(XsdDecimal(BigInt.from(75), 1)), equals('7.5'));
      expect(codec.encode(XsdDecimal(BigInt.zero, 0)), equals('0'));
      expect(codec.encode(XsdDecimal(BigInt.zero, 5)), equals('0'));
    });

    test('decode', () {
      expect(
        codec.decode('123.456'),
        equals(XsdDecimal(BigInt.from(123456), 3)),
      );
      expect(
        codec.decode('  123.456  '),
        equals(XsdDecimal(BigInt.from(123456), 3)),
      );
    });
  });
}
