import 'package:test/test.dart';
import 'package:xsd/src/codecs/double.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdDoubleDecoder', () {
    const decoder = XsdDoubleDecoder();

    test('parses normal decimals', () {
      expect(decoder.convert('123.45'), equals(123.45));
      expect(decoder.convert('0.0'), equals(0.0));
      expect(decoder.convert('.5'), equals(0.5));
      expect(decoder.convert('1.'), equals(1.0));
      expect(decoder.convert('+123.45'), equals(123.45));

      // Check for negative zero explicitly
      final negZero = decoder.convert('-0.0');
      expect(negZero, equals(0.0));
      expect(negZero.isNegative, isTrue);
    });

    test('parses scientific notation', () {
      expect(decoder.convert('1.2345E2'), equals(123.45));
      expect(decoder.convert('1.2345e2'), equals(123.45));
      expect(decoder.convert('12.345E1'), equals(123.45));
      expect(decoder.convert('1.2E-2'), equals(0.012));
      expect(decoder.convert('0.0E0'), equals(0.0));

      // Check for negative zero explicitly
      final negZeroExp = decoder.convert('-0.0E0');
      expect(negZeroExp, equals(0.0));
      expect(negZeroExp.isNegative, isTrue);
    });

    test('parses special literals', () {
      expect(decoder.convert('INF'), equals(double.infinity));
      expect(decoder.convert('+INF'), equals(double.infinity));
      expect(decoder.convert('-INF'), equals(double.negativeInfinity));
      expect(decoder.convert('NaN'), isNaN);
    });

    test('throws XsdValidationException for invalid input', () {
      expect(
        () => decoder.convert('abc'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('1.2.3'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('++1'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('Infinity'), // XSD uses INF
        throwsA(isA<XsdValidationException>()),
      );

      // Case sensitivity checks (Dart double.parse might accept these natively)
      expect(
        () => decoder.convert('nan'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('NAN'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('inf'),
        throwsA(isA<XsdValidationException>()),
      );
    });
  });

  group('XsdDoubleEncoder', () {
    const encoder = XsdDoubleEncoder();

    test('encodes special values', () {
      expect(encoder.convert(double.infinity), equals('INF'));
      expect(encoder.convert(double.negativeInfinity), equals('-INF'));
      expect(encoder.convert(double.nan), equals('NaN'));
    });

    test('encodes zeros in canonical form', () {
      expect(encoder.convert(0.0), equals('0.0E0'));
      expect(encoder.convert(-0.0), equals('-0.0E0'));
    });

    test('encodes normal values in canonical scientific notation', () {
      expect(encoder.convert(123.45), equals('1.2345E2'));
      expect(encoder.convert(0.012), equals('1.2E-2'));
      expect(encoder.convert(1.0), equals('1.0E0'));
      expect(encoder.convert(-1.0), equals('-1.0E0'));
      expect(encoder.convert(10.0), equals('1.0E1'));
      expect(encoder.convert(0.1), equals('1.0E-1'));
    });
  });
}
