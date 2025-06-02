import 'package:test/test.dart';
import 'package:xsd/src/codecs/name/name_codec.dart';

void main() {
  group('XsdNameCodec', () {
    const codec = XsdNameCodec();

    group('decoder (xsd:Name)', () {
      // Valid Names
      test('should decode valid Names', () {
        expect(codec.decode('name'), 'name');
        expect(codec.decode('_name'), '_name');
        expect(codec.decode(':name'), ':name');
        expect(codec.decode('name123'), 'name123');
        expect(codec.decode('name.with.dots'), 'name.with.dots');
        expect(codec.decode('name-with-hyphens'), 'name-with-hyphens');
        expect(codec.decode('name:with:colons'), 'name:with:colons');
        expect(codec.decode('a_b-c:d.e1'), 'a_b-c:d.e1');
        // Unicode examples
        expect(codec.decode('écran'), 'écran'); // Starts with \p{L}
        expect(codec.decode('Österreich'), 'Österreich'); // Starts with \p{L}
        expect(
          codec.decode('నామము'),
          'నామము',
        ); // Telugu example, starts with \p{L}
        expect(
          codec.decode('ⅢName'),
          'ⅢName',
        ); // Starts with \p{Nl} (Roman numeral three)
        expect(codec.decode('nameⅢ'), 'nameⅢ'); // Ends with \p{Nl}
        expect(
          codec.decode('name\u0300'),
          'name\u0300',
        ); // Ends with combining mark \p{M}
        expect(
          codec.decode('name\u02B0'),
          'name\u02B0',
        ); // Ends with modifier letter \p{Lm}
        expect(codec.decode(' name'), 'name');
      });

      test('whitespace handling (collapse)', () {
        expect(codec.decode('  validName  '), 'validName');
        expect(codec.decode('\t_val:id.Name-\n'), '_val:id.Name-');
      });

      group('invalid lexical values for Name', () {
        test(
          'should throw FormatException for empty string after collapse',
          () {
            expect(() => codec.decode(''), throwsA(isA<FormatException>()));
            expect(() => codec.decode('   '), throwsA(isA<FormatException>()));
          },
        );

        test(
          'should throw FormatException for names starting with invalid characters',
          () {
            expect(
              () => codec.decode('1name'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('-name'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('.name'),
              throwsA(isA<FormatException>()),
            );
          },
        );

        test(
          'should throw FormatException for names with invalid subsequent characters',
          () {
            expect(
              () => codec.decode('name!'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('name@email'),
              throwsA(isA<FormatException>()),
            );
            expect(
              () => codec.decode('name withspace'),
              throwsA(isA<FormatException>()),
            );
          },
        );
      });
    });

    group('encoder (xsd:Name)', () {
      test('should encode a valid Name string as itself', () {
        expect(codec.encode('ValidName'), 'ValidName');
        expect(
          codec.encode('_Another-Valid.Name:123'),
          '_Another-Valid.Name:123',
        );
      });
    });

    group('codec (round trip)', () {
      test('round trip for valid Name', () {
        const value = 'My_Name:Is.Valid-123';
        expect(codec.decode(value), value);
        expect(codec.encode(codec.decode(value)), value);
      });

      test('round trip with initial whitespace (decode normalizes)', () {
        const valueWithWhitespace = '  _A_ValidName  ';
        const normalizedValue = '_A_ValidName';
        expect(codec.decode(valueWithWhitespace), normalizedValue);
        expect(
          codec.encode(codec.decode(valueWithWhitespace)),
          normalizedValue,
        );
      });
    });
  });
}
