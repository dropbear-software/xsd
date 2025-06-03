import 'package:test/test.dart';
import 'package:xsd/src/codecs/ncname/ncname_codec.dart';

void main() {
  group('XsdNcnameCodec', () {
    const codec = XsdNcnameCodec();

    group('decoder (xsd:NCName)', () {
      // Valid NCNames (must be valid Names and not contain colons)
      test('should decode valid NCNames', () {
        expect(codec.decode('name'), 'name');
        expect(codec.decode('_name'), '_name');
        // expect(codec.decode(':name'), ':name'); // Invalid for NCName
        expect(codec.decode('name123'), 'name123');
        expect(codec.decode('name.with.dots'), 'name.with.dots');
        expect(codec.decode('name-with-hyphens'), 'name-with-hyphens');
        // expect(codec.decode('name:with:colons'), 'name:with:colons'); // Invalid
        expect(codec.decode('a_b-c.d1e'), 'a_b-c.d1e'); // No colons
        expect(codec.decode('écran'), 'écran');
        expect(codec.decode('Österreich'), 'Österreich');
        expect(codec.decode('నామము'), 'నామము');
        expect(codec.decode('ⅢName'), 'ⅢName');
      });

      test('whitespace handling (collapse)', () {
        expect(codec.decode('  validNCName  '), 'validNCName');
        expect(codec.decode('\t_val.id-Name\n'), '_val.id-Name');
      });

      group('invalid lexical values for NCName', () {
        test(
          'should throw FormatException for empty string after collapse',
          () {
            expect(() => codec.decode(''), throwsA(isA<FormatException>()));
            expect(() => codec.decode('   '), throwsA(isA<FormatException>()));
          },
        );

        test(
          'should throw FormatException for NCNames starting with invalid characters (same as Name)',
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
          'should throw FormatException for NCNames with invalid subsequent characters (same as Name)',
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

        test('should throw FormatException for Names containing colons', () {
          expect(() => codec.decode(':name'), throwsA(isA<FormatException>()));
          expect(
            () => codec.decode('name:subpart'),
            throwsA(isA<FormatException>()),
          );
          expect(
            () => codec.decode('prefix:local'),
            throwsA(isA<FormatException>()),
          );
        });
      });
    });

    group('encoder (xsd:NCName)', () {
      test('should encode a valid NCName string as itself', () {
        expect(codec.encode('ValidNCName'), 'ValidNCName');
        expect(
          codec.encode('_Another-Valid.NCName123'),
          '_Another-Valid.NCName123',
        );
      });
      // Test 'should throw if encoding a string with colon' could be added if encoder did validation
    });

    group('codec (round trip)', () {
      test('round trip for valid NCName', () {
        const value = 'My_NCName.IsValid-123';
        expect(codec.decode(value), value);
        expect(codec.encode(codec.decode(value)), value);
      });

      test('round trip with initial whitespace (decode normalizes)', () {
        const valueWithWhitespace = '  _A_Valid_NCName  ';
        const normalizedValue = '_A_Valid_NCName';
        expect(codec.decode(valueWithWhitespace), normalizedValue);
        expect(
          codec.encode(codec.decode(valueWithWhitespace)),
          normalizedValue,
        );
      });
    });
  });
}
