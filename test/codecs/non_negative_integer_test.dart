import 'package:test/test.dart';
import 'package:xsd/src/codecs/non_negative_integer.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdNonNegativeInteger', () {
    test('should allow zero', () {
      final value = XsdNonNegativeInteger(BigInt.zero);
      expect(value, equals(BigInt.zero));
    });

    test('should allow positive integers', () {
      final value = XsdNonNegativeInteger(BigInt.from(100));
      expect(value, equals(BigInt.from(100)));
    });

    test('should throw ArgumentError for negative integers', () {
      expect(() => XsdNonNegativeInteger(BigInt.from(-1)), throwsArgumentError);
    });

    test('unsafe constructor should not validate', () {
      final value = XsdNonNegativeInteger.unsafe(BigInt.from(-1));
      expect(value, equals(BigInt.from(-1)));
    });

    group('parse', () {
      test('should parse valid zero strings', () {
        expect(XsdNonNegativeInteger.parse('0'), equals(BigInt.zero));
        expect(XsdNonNegativeInteger.parse('+0'), equals(BigInt.zero));
        expect(XsdNonNegativeInteger.parse('-0'), equals(BigInt.zero));
        expect(XsdNonNegativeInteger.parse('000'), equals(BigInt.zero));
        expect(XsdNonNegativeInteger.parse('+00'), equals(BigInt.zero));
      });

      test('should parse valid positive integers', () {
        expect(XsdNonNegativeInteger.parse('1'), equals(BigInt.one));
        expect(XsdNonNegativeInteger.parse('+1'), equals(BigInt.one));
        expect(XsdNonNegativeInteger.parse('01'), equals(BigInt.one));
        expect(
          XsdNonNegativeInteger.parse('12345678901234567890'),
          equals(BigInt.parse('12345678901234567890')),
        );
      });

      test('should throw FormatException for negative integers', () {
        expect(() => XsdNonNegativeInteger.parse('-1'), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical forms', () {
        expect(() => XsdNonNegativeInteger.parse(''), throwsFormatException);
        expect(() => XsdNonNegativeInteger.parse('abc'), throwsFormatException);
        expect(() => XsdNonNegativeInteger.parse('1.0'), throwsFormatException);
        expect(() => XsdNonNegativeInteger.parse('1E0'), throwsFormatException);
      });
    });

    group('XsdNonNegativeIntegerCodec', () {
      const codec = XsdNonNegativeIntegerCodec();

      test('decoder should parse valid strings', () {
        expect(codec.decode('0'), equals(BigInt.zero));
        expect(codec.decode('123'), equals(BigInt.from(123)));
      });

      test(
        'decoder should throw XsdValidationException for invalid strings',
        () {
          expect(
            () => codec.decode('-1'),
            throwsA(isA<XsdValidationException>()),
          );
          expect(
            () => codec.decode('abc'),
            throwsA(isA<XsdValidationException>()),
          );
        },
      );

      test('encoder should produce canonical strings', () {
        expect(codec.encode(XsdNonNegativeInteger(BigInt.zero)), equals('0'));
        expect(codec.encode(XsdNonNegativeInteger(BigInt.one)), equals('1'));
        expect(
          codec.encode(XsdNonNegativeInteger(BigInt.from(100))),
          equals('100'),
        );
        expect(
          codec.encode(
            XsdNonNegativeInteger(BigInt.parse('12345678901234567890')),
          ),
          equals('12345678901234567890'),
        );
      });
    });
  });
}
