import 'package:test/test.dart';
import 'package:xsd/src/codecs/boolean.dart';
import 'package:xsd/src/core/exceptions.dart';

void main() {
  group('XsdBooleanCodec', () {
    const codec = XsdBooleanCodec();

    group('decode', () {
      test('accepts "true"', () {
        expect(codec.decode('true'), isTrue);
      });

      test('accepts "false"', () {
        expect(codec.decode('false'), isFalse);
      });

      test('accepts "1"', () {
        expect(codec.decode('1'), isTrue);
      });

      test('accepts "0"', () {
        expect(codec.decode('0'), isFalse);
      });

      test('accepts whitespace variations (collapse)', () {
        expect(codec.decode(' true'), isTrue);
        expect(codec.decode('false '), isFalse);
        expect(codec.decode('\n1'), isTrue);
        expect(codec.decode('0\t'), isFalse);
        expect(codec.decode('  true  '), isTrue);
      });

      test('throws XsdValidationException for invalid input', () {
        expect(
          () => codec.decode('True'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('FALSE'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('yes'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(
          () => codec.decode('no'),
          throwsA(isA<XsdValidationException>()),
        );
        expect(() => codec.decode('2'), throwsA(isA<XsdValidationException>()));
        expect(() => codec.decode(''), throwsA(isA<XsdValidationException>()));
      });
    });

    group('encode', () {
      test('encodes true to "true"', () {
        expect(codec.encode(true), 'true');
      });

      test('encodes false to "false"', () {
        expect(codec.encode(false), 'false');
      });
    });
  });
}
