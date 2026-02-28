import 'package:test/test.dart';
import 'package:xsd/src/codecs/negative_integer.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdNegativeInteger', () {
    test('should allow negative integers', () {
      final value = XsdNegativeInteger(BigInt.from(-100));
      expect(value, equals(BigInt.from(-100)));
    });

    test('should throw ArgumentError for zero', () {
      expect(() => XsdNegativeInteger(BigInt.zero), throwsArgumentError);
    });

    test('should throw ArgumentError for positive integers', () {
      expect(() => XsdNegativeInteger(BigInt.from(1)), throwsArgumentError);
    });

    test('unsafe constructor should not validate', () {
      final value = XsdNegativeInteger.unsafe(BigInt.from(0));
      expect(value, equals(BigInt.zero));
    });

    group('parse', () {
      test('should parse valid negative integers', () {
        expect(XsdNegativeInteger.parse('-1'), equals(BigInt.from(-1)));
        expect(XsdNegativeInteger.parse('-01'), equals(BigInt.from(-1)));
        expect(
          XsdNegativeInteger.parse('-12345678901234567890'),
          equals(BigInt.parse('-12345678901234567890')),
        );
      });

      test('should throw FormatException for zero', () {
        expect(() => XsdNegativeInteger.parse('0'), throwsFormatException);
        expect(() => XsdNegativeInteger.parse('+0'), throwsFormatException);
        expect(() => XsdNegativeInteger.parse('-0'), throwsFormatException);
      });

      test('should throw FormatException for positive integers', () {
        expect(() => XsdNegativeInteger.parse('1'), throwsFormatException);
        expect(() => XsdNegativeInteger.parse('+1'), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical forms', () {
        expect(() => XsdNegativeInteger.parse(''), throwsFormatException);
        expect(() => XsdNegativeInteger.parse('abc'), throwsFormatException);
        expect(() => XsdNegativeInteger.parse('-1.0'), throwsFormatException);
      });
    });

    group('XsdNegativeIntegerCodec', () {
      const codec = XsdNegativeIntegerCodec();

      test('decoder should parse valid strings', () {
        expect(codec.decode('-1'), equals(BigInt.from(-1)));
        expect(codec.decode('-123'), equals(BigInt.from(-123)));
        expect(codec.decode('  -456  '), equals(BigInt.from(-456))); // collapse
      });

      test(
        'decoder should throw XsdValidationException for invalid strings',
        () {
          expect(
            () => codec.decode('0'),
            throwsA(isA<XsdValidationException>()),
          );
          expect(
            () => codec.decode('1'),
            throwsA(isA<XsdValidationException>()),
          );
          expect(
            () => codec.decode('abc'),
            throwsA(isA<XsdValidationException>()),
          );
        },
      );

      test('encoder should produce canonical strings', () {
        expect(codec.encode(XsdNegativeInteger(BigInt.from(-1))), equals('-1'));
        expect(
          codec.encode(XsdNegativeInteger(BigInt.from(-100))),
          equals('-100'),
        );
      });
    });
  });
}
