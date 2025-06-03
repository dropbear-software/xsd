import 'package:test/test.dart';
import 'package:xsd/src/codecs/int/int_codec.dart';

void main() {
  group('XsdIntCodec', () {
    const codec = XsdIntCodec();
    final minInt = -2147483648;
    final maxInt = 2147483647;

    group('decoder (xsd:int)', () {
      test('should decode "0" to 0', () {
        expect(codec.decode('0'), 0);
      });

      test('should decode minimum int value', () {
        expect(codec.decode(minInt.toString()), minInt);
      });

      test('should decode maximum int value', () {
        expect(codec.decode(maxInt.toString()), maxInt);
      });

      test('should decode "+123" to 123', () {
        expect(codec.decode('+123'), 123);
      });

      test('whitespace handling', () {
        expect(codec.decode('  $maxInt  '), maxInt);
        expect(codec.decode('\t$minInt\n'), minInt);
      });

      test('leading zeros', () {
        expect(codec.decode('007'), 7);
      });

      group('out of range values', () {
        test('should throw FormatException for value greater than maxInt', () {
          final justOverMax = BigInt.from(maxInt) + BigInt.one;
          expect(
            () => codec.decode(justOverMax.toString()),
            throwsA(isA<FormatException>()),
          );
        });

        test('should throw FormatException for value less than minInt', () {
          final justUnderMin = BigInt.from(minInt) - BigInt.one;
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
      });
    });

    group('encoder (xsd:int)', () {
      test('should encode 0 to "0"', () {
        expect(codec.encode(0), '0');
      });
      test('should encode maxInt to its string', () {
        expect(codec.encode(maxInt), maxInt.toString());
      });
      test('should encode minInt to its string', () {
        expect(codec.encode(minInt), minInt.toString());
      });
    });
  });
}
