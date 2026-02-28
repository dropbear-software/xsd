import 'package:test/test.dart';
import 'package:xsd/src/codecs/long.dart';
import 'package:xsd/src/core/exceptions.dart';
import 'package:xsd/src/core/whitespace.dart';

void main() {
  group('XsdLong', () {
    test(
      'XsdLong() allows values in range [-9223372036854775808, 9223372036854775807]',
      () {
        final min = BigInt.parse('-9223372036854775808');
        final max = BigInt.parse('9223372036854775807');

        expect(XsdLong(min).value, equals(min));
        expect(XsdLong(BigInt.zero).value, equals(BigInt.zero));
        expect(XsdLong(max).value, equals(max));
      },
    );

    test('XsdLong() throws ArgumentError for values out of range', () {
      final belowMin = BigInt.parse('-9223372036854775809');
      final aboveMax = BigInt.parse('9223372036854775808');

      expect(() => XsdLong(belowMin), throwsArgumentError);
      expect(() => XsdLong(aboveMax), throwsArgumentError);
    });

    test('XsdLong.unsafe() bypasses validation', () {
      final aboveMax = BigInt.parse('9223372036854775808');
      expect(XsdLong.unsafe(aboveMax).value, equals(aboveMax));
    });
  });

  group('XsdLongEncoder', () {
    const encoder = XsdLongEncoder();

    test('successfully encodes to canonical form', () {
      expect(encoder.convert(XsdLong(BigInt.from(123))), equals('123'));
      expect(encoder.convert(XsdLong(BigInt.from(-123))), equals('-123'));
      expect(encoder.convert(XsdLong(BigInt.zero)), equals('0'));
      expect(
        encoder.convert(XsdLong(BigInt.parse('9223372036854775807'))),
        equals('9223372036854775807'),
      );
    });
  });

  group('XsdLongDecoder', () {
    const decoder = XsdLongDecoder();

    test('successfully decodes valid lexical forms', () {
      expect(decoder.convert('123'), equals(XsdLong(BigInt.from(123))));
      expect(decoder.convert('+123'), equals(XsdLong(BigInt.from(123))));
      expect(decoder.convert('-123'), equals(XsdLong(BigInt.from(-123))));
      expect(decoder.convert('0'), equals(XsdLong(BigInt.zero)));
      expect(decoder.convert('000123'), equals(XsdLong(BigInt.from(123))));
    });

    test('throws XsdValidationException for invalid lexical forms', () {
      expect(() => decoder.convert(''), throwsA(isA<XsdValidationException>()));
      expect(
        () => decoder.convert('abc'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('12.3'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('++123'),
        throwsA(isA<XsdValidationException>()),
      );
    });

    test('throws XsdValidationException for out of range values', () {
      expect(
        () => decoder.convert('9223372036854775808'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('-9223372036854775809'),
        throwsA(isA<XsdValidationException>()),
      );
    });
  });

  group('XsdLongCodec', () {
    const codec = XsdLongCodec();

    test('has correct whiteSpace facet', () {
      expect(codec.whiteSpace, equals(XsdWhitespace.collapse));
    });

    test('decode collapses whitespace', () {
      expect(codec.decode(' 123 '), equals(XsdLong(BigInt.from(123))));
    });

    test('encode/decode symmetry', () {
      final value = XsdLong(BigInt.from(123456));
      expect(codec.decode(codec.encode(value)), equals(value));
    });
  });
}
