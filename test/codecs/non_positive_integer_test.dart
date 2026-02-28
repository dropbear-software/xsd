import 'package:test/test.dart';
import 'package:xsd/src/codecs/non_positive_integer.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdNonPositiveInteger', () {
    test('should allow zero', () {
      final value = XsdNonPositiveInteger(BigInt.zero);
      expect(value, equals(BigInt.zero));
    });

    test('should allow negative integers', () {
      final value = XsdNonPositiveInteger(BigInt.from(-100));
      expect(value, equals(BigInt.from(-100)));
    });

    test('should throw ArgumentError for positive integers', () {
      expect(() => XsdNonPositiveInteger(BigInt.one), throwsArgumentError);
      expect(
        () => XsdNonPositiveInteger(BigInt.from(123)),
        throwsArgumentError,
      );
    });

    test('unsafe constructor should not validate', () {
      final value = XsdNonPositiveInteger.unsafe(BigInt.one);
      expect(value, equals(BigInt.one));
    });

    group('parse', () {
      test('should parse valid zero strings', () {
        expect(XsdNonPositiveInteger.parse('0'), equals(BigInt.zero));
        expect(XsdNonPositiveInteger.parse('+0'), equals(BigInt.zero));
        expect(XsdNonPositiveInteger.parse('-0'), equals(BigInt.zero));
        expect(XsdNonPositiveInteger.parse('000'), equals(BigInt.zero));
        expect(XsdNonPositiveInteger.parse('+00'), equals(BigInt.zero));
      });

      test('should parse valid negative integers', () {
        expect(XsdNonPositiveInteger.parse('-1'), equals(BigInt.from(-1)));
        expect(XsdNonPositiveInteger.parse('-01'), equals(BigInt.from(-1)));
        expect(
          XsdNonPositiveInteger.parse('-12345678901234567890'),
          equals(BigInt.parse('-12345678901234567890')),
        );
      });

      test('should throw FormatException for positive integers', () {
        expect(() => XsdNonPositiveInteger.parse('1'), throwsFormatException);
        expect(() => XsdNonPositiveInteger.parse('+1'), throwsFormatException);
      });

      test('should throw FormatException for invalid lexical forms', () {
        expect(() => XsdNonPositiveInteger.parse(''), throwsFormatException);
        expect(() => XsdNonPositiveInteger.parse('abc'), throwsFormatException);
        expect(() => XsdNonPositiveInteger.parse('1.0'), throwsFormatException);
        expect(() => XsdNonPositiveInteger.parse('1E0'), throwsFormatException);
      });

      test('should throw FormatException for non-zero without negative sign', () {
        // According to XSD spec: "the negative sign ('-') must be present" for non-zero values.
        // Actually, the spec says: "The sign may be '+' or may be omitted only for lexical forms denoting zero;
        // in all other lexical forms, the negative sign ('-') must be present."
        expect(() => XsdNonPositiveInteger.parse('1'), throwsFormatException);
        expect(() => XsdNonPositiveInteger.parse('+1'), throwsFormatException);
      });
    });

    group('XsdNonPositiveIntegerCodec', () {
      const codec = XsdNonPositiveIntegerCodec();

      test('decoder should parse valid strings', () {
        expect(codec.decode('0'), equals(BigInt.zero));
        expect(codec.decode('-123'), equals(BigInt.from(-123)));
      });

      test(
        'decoder should throw XsdValidationException for invalid strings',
        () {
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
        expect(codec.encode(XsdNonPositiveInteger(BigInt.zero)), equals('0'));
        expect(
          codec.encode(XsdNonPositiveInteger(BigInt.from(-1))),
          equals('-1'),
        );
        expect(
          codec.encode(XsdNonPositiveInteger(BigInt.from(-100))),
          equals('-100'),
        );
        expect(
          codec.encode(
            XsdNonPositiveInteger(BigInt.parse('-12345678901234567890')),
          ),
          equals('-12345678901234567890'),
        );
      });
    });
  });
}
