import 'package:test/test.dart';
import 'package:xsd/src/codecs/short.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdShort', () {
    test('XsdShort() allows values in range [-32768, 32767]', () {
      expect(XsdShort(-32768).value, equals(-32768));
      expect(XsdShort(0).value, equals(0));
      expect(XsdShort(32767).value, equals(32767));
    });

    test('XsdShort() throws RangeError for values out of range', () {
      expect(() => XsdShort(-32769), throwsRangeError);
      expect(() => XsdShort(32768), throwsRangeError);
    });

    test('XsdShort.unsafe() bypasses validation', () {
      expect(XsdShort.unsafe(32768).value, equals(32768));
    });
  });

  group('XsdShortCodec', () {
    const codec = XsdShortCodec();

    group('decode', () {
      test('successfully decodes valid lexical forms', () {
        expect(codec.decode('123'), equals(XsdShort(123)));
        expect(codec.decode('+123'), equals(XsdShort(123)));
        expect(codec.decode('-123'), equals(XsdShort(-123)));
        expect(codec.decode('0'), equals(XsdShort(0)));
        expect(codec.decode('000123'), equals(XsdShort(123)));
        expect(
          codec.decode(' 123 '),
          equals(XsdShort(123)),
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
          () => codec.decode('32768'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('-32769'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('999999999999999999999'),
          throwsA(isA<XsdValidationException>()),
        );
      });
    });

    group('encode', () {
      test('successfully encodes to canonical form', () {
        expect(codec.encode(XsdShort(123)), equals('123'));
        expect(codec.encode(XsdShort(-123)), equals('-123'));
        expect(codec.encode(XsdShort(0)), equals('0'));
      });
    });
  });
}
