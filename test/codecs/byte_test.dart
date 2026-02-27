import 'package:test/test.dart';
import 'package:xsd/src/codecs/byte.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdByte', () {
    test('XsdByte() factory validates range', () {
      expect(XsdByte(127).value, 127);
      expect(XsdByte(-128).value, -128);
      expect(() => XsdByte(128), throwsRangeError);
      expect(() => XsdByte(-129), throwsRangeError);
    });

    test('XsdByte.unsafe() bypasses validation', () {
      const b = XsdByte.unsafe(1000); // Should not throw
      expect(b.value, 1000);
    });
  });

  group('XsdByteCodec', () {
    const codec = XsdByteCodec();

    group('decode', () {
      test('accepts valid bytes', () {
        expect(codec.decode('127'), const XsdByte.unsafe(127));
        expect(codec.decode('-128'), const XsdByte.unsafe(-128));
        expect(codec.decode('0'), const XsdByte.unsafe(0));
        expect(codec.decode('100'), const XsdByte.unsafe(100));
        expect(codec.decode('-100'), const XsdByte.unsafe(-100));
      });

      test('accepts valid lexical variations', () {
        expect(codec.decode('+127'), const XsdByte.unsafe(127));
        expect(codec.decode('+0'), const XsdByte.unsafe(0));
        expect(codec.decode('007'), const XsdByte.unsafe(7));
        expect(codec.decode('-007'), const XsdByte.unsafe(-7));
      });

      test('accepts whitespace variations (collapse)', () {
        expect(codec.decode(' 127'), const XsdByte.unsafe(127));
        expect(codec.decode('0 '), const XsdByte.unsafe(0));
        expect(codec.decode('\n-128'), const XsdByte.unsafe(-128));
        expect(codec.decode('\r\n 100 \t'), const XsdByte.unsafe(100));
        expect(codec.decode('  -50  '), const XsdByte.unsafe(-50));
        expect(
          () => codec.decode(' + 10 '),
          throwsA(isA<XsdValidationException>()),
          reason:
              'Internal whitespace in "+ 10" collapses to "+ 10" '
              'which is invalid for xsd:byte pattern',
        );
      });

      test('throws XsdValidationException for out of range values', () {
        expect(
          () => codec.decode('128'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('-129'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('1000'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('-1000'),
          throwsA(isA<XsdValidationException>()),
        );
      });

      test('throws XsdValidationException for invalid formats', () {
        expect(
          () => codec.decode('1.0'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('abc'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(() => codec.decode(''), throwsA(isA<XsdValidationException>()));
        expect(
          () => codec.decode('+-1'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('-+1'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('1-'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('1+'),
          throwsA(isA<XsdValidationException>()),
        );
      });
    });

    group('encode', () {
      test('encodes values to canonical lexical representation', () {
        expect(codec.encode(const XsdByte.unsafe(127)), '127');
        expect(codec.encode(const XsdByte.unsafe(-128)), '-128');
        expect(codec.encode(const XsdByte.unsafe(0)), '0');
        expect(codec.encode(const XsdByte.unsafe(7)), '7');
        expect(codec.encode(const XsdByte.unsafe(-7)), '-7');
      });
    });
  });
}
