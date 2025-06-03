import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:xsd/src/codecs/base64_binary/base64_binary_codec.dart';

void main() {
  group('XsdBase64BinaryCodec', () {
    const codec = XsdBase64BinaryCodec();

    group('decoder (xsd:base64Binary)', () {
      test('should decode valid base64 strings', () {
        expect(
          codec.decode('AQID'),
          Uint8List.fromList([1, 2, 3]),
        ); // "AQID" -> [1,2,3]
        expect(
          codec.decode('Zm9vYmFy'),
          Uint8List.fromList('foobar'.codeUnits),
        ); // "foobar"
        expect(codec.decode('Zg=='), Uint8List.fromList('f'.codeUnits)); // "f"
        expect(
          codec.decode('Zm8='),
          Uint8List.fromList('fo'.codeUnits),
        ); // "fo"
        expect(
          codec.decode('Zm9v'),
          Uint8List.fromList('foo'.codeUnits),
        ); // "foo"
      });

      test('should decode empty string to empty Uint8List', () {
        expect(codec.decode(''), Uint8List(0));
      });

      test('whitespace handling (collapse and then remove all spaces)', () {
        // XSD: whiteSpace="collapse" first, then decoder removes remaining spaces
        expect(codec.decode('  AQID  '), Uint8List.fromList([1, 2, 3]));
        expect(codec.decode('\tAQID\n'), Uint8List.fromList([1, 2, 3]));
        expect(
          codec.decode('A Q I D'),
          Uint8List.fromList([1, 2, 3]),
        ); // Spaces between chars
        expect(codec.decode('A  Q\r\nI D '), Uint8List.fromList([1, 2, 3]));
        expect(
          codec.decode(' Zm9 v YmFy '),
          Uint8List.fromList('foobar'.codeUnits),
        );
      });

      group('invalid lexical values for base64Binary', () {
        test('should throw FormatException for invalid characters', () {
          expect(
            () => codec.decode('AQI!'),
            throwsA(isA<FormatException>()),
          ); // '!' is invalid
          expect(
            () => codec.decode('AQI~D'),
            throwsA(isA<FormatException>()),
          ); // '~' is invalid
        });

        test('should throw FormatException for incorrect padding', () {
          expect(
            () => codec.decode('Zm9vY'),
            throwsA(isA<FormatException>()),
          ); // Length not mult of 4
          expect(
            () => codec.decode('Zm9v='),
            throwsA(isA<FormatException>()),
          ); // Incorrect padding
          expect(
            () => codec.decode('Zg=A'),
            throwsA(isA<FormatException>()),
          ); // Padding char not at end
        });
        test(
          'should throw FormatException for only whitespace if it does not become empty',
          () {
            // This case is tricky. processWhiteSpace(' ', Whitespace.collapse) is ''.
            // processWhiteSpace('  ', Whitespace.collapse) is ''.
            // An input of just spaces effectively becomes an empty string for base64, which is valid.
            // The test should be for non-base64 characters mixed with ignorable whitespace.
            expect(() => codec.decode('  * '), throwsA(isA<FormatException>()));
          },
        );
      });
    });

    group('encoder (xsd:base64Binary)', () {
      test('should encode Uint8List to base64 string', () {
        expect(
          codec.encode(Uint8List.fromList('foobar'.codeUnits)),
          'Zm9vYmFy',
        );
        expect(codec.encode(Uint8List.fromList([1, 2, 3])), 'AQID');
      });

      test('should encode empty Uint8List to empty string', () {
        expect(codec.encode(Uint8List(0)), '');
      });
      test('padding examples for encoder', () {
        expect(codec.encode(Uint8List.fromList('f'.codeUnits)), 'Zg==');
        expect(codec.encode(Uint8List.fromList('fo'.codeUnits)), 'Zm8=');
        expect(codec.encode(Uint8List.fromList('foo'.codeUnits)), 'Zm9v');
      });
    });

    group('codec (round trip)', () {
      test('round trip for valid base64Binary', () {
        final data = Uint8List.fromList([
          10,
          20,
          30,
          40,
          50,
        ]); // arbitrary bytes
        final encoded = codec.encode(data);
        expect(codec.decode(encoded), data);
      });

      test('round trip for string "Man"', () {
        // "Man" is "TWFu" in base64
        final data = Uint8List.fromList('Man'.codeUnits);
        final encoded = codec.encode(data);
        expect(encoded, 'TWFu');
        expect(codec.decode(encoded), data);
      });

      test('round trip for empty data', () {
        final data = Uint8List(0);
        final encoded = codec.encode(data);
        expect(encoded, '');
        expect(codec.decode(encoded), data);
      });

      test(
        'round trip with initial/internal/trailing whitespace in input string',
        () {
          const lexicalInput = '  TW  F \t u\n'; // Represents "Man"
          final expectedData = Uint8List.fromList('Man'.codeUnits);
          final decoded = codec.decode(lexicalInput);
          expect(decoded, expectedData);
          expect(codec.encode(decoded), 'TWFu');
        },
      );
    });
  });
}
