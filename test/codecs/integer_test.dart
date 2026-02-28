import 'package:test/test.dart';
import 'package:xsd/src/codecs/integer.dart';
import 'package:xsd/src/core/exceptions.dart';
import 'package:xsd/src/core/whitespace.dart';

void main() {
  group('XsdIntegerCodec', () {
    const codec = XsdIntegerCodec();

    test('metadata', () {
      expect(codec.whiteSpace, equals(XsdWhitespace.collapse));
      expect(codec.encoder, isA<XsdIntegerEncoder>());
      expect(codec.decoder, isA<XsdIntegerDecoder>());
    });

    test('decode', () {
      expect(codec.decode(' 123 '), equals(XsdInteger(BigInt.from(123))));
    });

    test('encode', () {
      expect(codec.encode(XsdInteger(BigInt.from(123))), equals('123'));
    });
  });

  group('XsdIntegerDecoder', () {
    const decoder = XsdIntegerDecoder();

    test('Valid lexical representations', () {
      expect(decoder.convert('123'), equals(XsdInteger(BigInt.from(123))));
      expect(decoder.convert('+123'), equals(XsdInteger(BigInt.from(123))));
      expect(decoder.convert('-123'), equals(XsdInteger(BigInt.from(-123))));
      expect(decoder.convert('0'), equals(XsdInteger(BigInt.zero)));
      expect(decoder.convert('+0'), equals(XsdInteger(BigInt.zero)));
      expect(decoder.convert('-0'), equals(XsdInteger(BigInt.zero)));
      expect(decoder.convert('007'), equals(XsdInteger(BigInt.from(7))));
      expect(
        decoder.convert('123456789012345678901234567890'),
        equals(XsdInteger(BigInt.parse('123456789012345678901234567890'))),
      );
    });

    test('Invalid lexical representations', () {
      expect(
        () => decoder.convert('123.456'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('1E2'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('abc'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(() => decoder.convert(''), throwsA(isA<XsdValidationException>()));
      expect(
        () => decoder.convert('++1'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert('+-1'),
        throwsA(isA<XsdValidationException>()),
      );
      expect(
        () => decoder.convert(' '),
        throwsA(isA<XsdValidationException>()),
      );
    });
  });

  group('XsdIntegerEncoder', () {
    const encoder = XsdIntegerEncoder();

    test('Canonical lexical mapping', () {
      expect(encoder.convert(XsdInteger(BigInt.from(123))), equals('123'));
      expect(encoder.convert(XsdInteger(BigInt.from(-123))), equals('-123'));
      expect(encoder.convert(XsdInteger(BigInt.zero)), equals('0'));
      expect(
        encoder.convert(
          XsdInteger(BigInt.parse('123456789012345678901234567890')),
        ),
        equals('123456789012345678901234567890'),
      );
    });
  });
}
