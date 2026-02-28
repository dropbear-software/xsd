import 'package:test/test.dart';
import 'package:xsd/src/codecs/positive_integer.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdPositiveInteger', () {
    test('should allow positive integers', () {
      final value = XsdPositiveInteger(BigInt.from(100));
      expect(value, equals(BigInt.from(100)));
    });

    test('should throw ArgumentError for zero', () {
      expect(() => XsdPositiveInteger(BigInt.zero), throwsArgumentError);
    });

    test('should throw ArgumentError for negative integers', () {
      expect(() => XsdPositiveInteger(BigInt.from(-1)), throwsArgumentError);
    });

    test('unsafe constructor should not validate', () {
      final value = XsdPositiveInteger.unsafe(BigInt.from(0));
      expect(value, equals(BigInt.zero));
    });

    group('parse', () {
      test('should parse valid positive integers', () {
        expect(XsdPositiveInteger.parse('1'), equals(BigInt.one));
        expect(XsdPositiveInteger.parse('+1'), equals(BigInt.one));
        expect(XsdPositiveInteger.parse('01'), equals(BigInt.one));
        expect(
          XsdPositiveInteger.parse('12345678901234567890'),
          equals(BigInt.parse('12345678901234567890')),
        );
      });

      test('should throw FormatException for zero', () {
        expect(() => XsdPositiveInteger.parse('0'), throwsFormatException);
        expect(() => XsdPositiveInteger.parse('+0'), throwsFormatException);
        expect(() => XsdPositiveInteger.parse('-0'), throwsFormatException);
      });

      test('should throw FormatException for negative integers', () {
        expect(() => XsdPositiveInteger.parse('-1'), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical forms', () {
        expect(() => XsdPositiveInteger.parse(''), throwsFormatException);
        expect(() => XsdPositiveInteger.parse('abc'), throwsFormatException);
        expect(() => XsdPositiveInteger.parse('1.0'), throwsFormatException);
      });
    });

    group('XsdPositiveIntegerCodec', () {
      const codec = XsdPositiveIntegerCodec();

      test('decoder should parse valid strings', () {
        expect(codec.decode('1'), equals(BigInt.one));
        expect(codec.decode('123'), equals(BigInt.from(123)));
        expect(codec.decode('  456  '), equals(BigInt.from(456))); // collapse
      });

      test(
        'decoder should throw XsdValidationException for invalid strings',
        () {
          expect(
            () => codec.decode('0'),
            throwsA(isA<XsdValidationException>()),
          );
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
        expect(codec.encode(XsdPositiveInteger(BigInt.one)), equals('1'));
        expect(
          codec.encode(XsdPositiveInteger(BigInt.from(100))),
          equals('100'),
        );
      });
    });
  });
}
