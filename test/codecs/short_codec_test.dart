import 'package:test/test.dart';
import 'package:xsd/src/codecs/short/short_codec.dart';

void main() {
  group('XsdShortCodec', () {
    const codec = XsdShortCodec();
    const minShort = -32768;
    const maxShort = 32767;

    group('decoder (xsd:short)', () {
      test('should decode "0" to 0', () {
        expect(codec.decode('0'), 0);
      });

      test('should decode minimum short value', () {
        expect(codec.decode(minShort.toString()), minShort);
      });

      test('should decode maximum short value', () {
        expect(codec.decode(maxShort.toString()), maxShort);
      });

      test('should decode "+123" to 123', () {
        expect(codec.decode('+123'), 123);
      });

      test('whitespace handling', () {
        expect(codec.decode('  $maxShort  '), maxShort);
        expect(codec.decode('\t$minShort\n'), minShort);
      });

      test('leading zeros', () {
        expect(codec.decode('007'), 7);
      });

      group('out of range values', () {
        test(
          'should throw FormatException for value greater than maxShort',
          () {
            final justOverMax = maxShort + 1;
            expect(
              () => codec.decode(justOverMax.toString()),
              throwsA(isA<FormatException>()),
            );
          },
        );

        test('should throw FormatException for value less than minShort', () {
          final justUnderMin = minShort - 1;
          expect(
            () => codec.decode(justUnderMin.toString()),
            throwsA(isA<FormatException>()),
          );
        });
      });

      group('invalid lexical values', () {
        test('should throw FormatException for "123.0"', () {
          expect(() => codec.decode('123.0'), throwsA(isA<FormatException>()));
        });
        test('should throw FormatException for "abc"', () {
          expect(() => codec.decode('abc'), throwsA(isA<FormatException>()));
        });
      });
    });

    group('encoder (xsd:short)', () {
      test('should encode 0 to "0"', () {
        expect(codec.encode(0), '0');
      });
      test('should encode maxShort to its string', () {
        expect(codec.encode(maxShort), maxShort.toString());
      });
      test('should encode minShort to its string', () {
        expect(codec.encode(minShort), minShort.toString());
      });
    });
  });
}
