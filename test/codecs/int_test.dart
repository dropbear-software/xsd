import 'package:test/test.dart';
import 'package:xsd/src/codecs/int.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdInt', () {
    test('XsdInt() allows values in range [-2147483648, 2147483647]', () {
      expect(XsdInt(-2147483648).value, equals(-2147483648));
      expect(XsdInt(0).value, equals(0));
      expect(XsdInt(2147483647).value, equals(2147483647));
    });

    test('XsdInt() throws RangeError for values out of range', () {
      expect(() => XsdInt(-2147483649), throwsRangeError);
      expect(() => XsdInt(2147483648), throwsRangeError);
    });

    test('XsdInt.unsafe() bypasses validation', () {
      expect(XsdInt.unsafe(2147483648).value, equals(2147483648));
    });

    test('static min/max methods', () {
      expect(XsdInt.min, -2147483648);
      expect(XsdInt.max, 2147483647);
    });
  });

  group('XsdIntCodec', () {
    const codec = XsdIntCodec();

    group('decode', () {
      test('successfully decodes valid lexical forms', () {
        expect(codec.decode('123'), equals(XsdInt(123)));
        expect(codec.decode('+123'), equals(XsdInt(123)));
        expect(codec.decode('-123'), equals(XsdInt(-123)));
        expect(codec.decode('0'), equals(XsdInt(0)));
        expect(codec.decode('000123'), equals(XsdInt(123)));
        expect(
          codec.decode(' 123 '),
          equals(XsdInt(123)),
        ); // Whitespace collapse
      });

      test('throws XsdValidationException for invalid lexical forms', () {
        expect(() => codec.decode(''), throwsA(isA<XsdValidationException>()));
        expect(
          () => codec.decode('abc'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('12.3'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('++123'),
          throwsA(isA<XsdValidationException>()),
        );
      });

      test('throws XsdValidationException for out of range values', () {
        expect(
          () => codec.decode('2147483648'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('-2147483649'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('999999999999999999999'), // Exceeds 64-bit int
          throwsA(isA<XsdValidationException>()),
        );
      });
    });

    group('encode', () {
      test('successfully encodes to canonical form', () {
        expect(codec.encode(XsdInt(123)), equals('123'));
        expect(codec.encode(XsdInt(-123)), equals('-123'));
        expect(codec.encode(XsdInt(0)), equals('0'));
      });
    });
  });
}
