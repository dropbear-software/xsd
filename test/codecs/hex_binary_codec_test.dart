import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:xsd/src/codecs/hex_binary/hex_binary_codec.dart';

void main() {
  group('XsdHexbinaryCodec', () {
    const codec = XsdHexbinaryCodec();

    group('decoder (xsd:hexBinary)', () {
      test('should decode valid hex strings', () {
        expect(codec.decode('0FB7'), Uint8List.fromList([0x0F, 0xB7]));
        expect(
          codec.decode('0fb7'),
          Uint8List.fromList([0x0F, 0xB7]),
        ); // case-insensitive decode
        expect(
          codec.decode('DEADBEEF'),
          Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]),
        );
        expect(
          codec.decode('abcdef0123456789ABCDEF'),
          Uint8List.fromList([
            0xAB,
            0xCD,
            0xEF,
            0x01,
            0x23,
            0x45,
            0x67,
            0x89,
            0xAB,
            0xCD,
            0xEF,
          ]),
        );
      });

      test('should decode empty string to empty Uint8List', () {
        expect(codec.decode(''), Uint8List(0));
      });

      test('whitespace handling (collapse)', () {
        expect(codec.decode('  0FB7  '), Uint8List.fromList([0x0F, 0xB7]));
        expect(
          codec.decode('\tdeadbeef\n'),
          Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF]),
        );
        // Test with internal whitespace that would make it invalid
        expect(
          () => codec.decode('0F B7'),
          throwsA(isA<FormatException>()),
          reason: 'Space is not a valid hex char, caught by regex',
        );
      });

      group('invalid lexical values for hexBinary', () {
        test('should throw FormatException for odd length string', () {
          expect(() => codec.decode('0FB'), throwsA(isA<FormatException>()));
        });

        test('should throw FormatException for non-hex characters', () {
          expect(
            () => codec.decode('0FX7'),
            throwsA(isA<FormatException>()),
          ); // X is not hex
          expect(() => codec.decode('PQRS'), throwsA(isA<FormatException>()));
        });

        test(
          'should throw FormatException for string with only whitespace that is not empty',
          () {
            // processWhiteSpace collapses '  ' to '', which is valid.
            // test for '  G ' (G is not hex)
            expect(() => codec.decode('  G '), throwsA(isA<FormatException>()));
          },
        );
      });
    });

    group('encoder (xsd:hexBinary)', () {
      test('should encode Uint8List to uppercase hex string', () {
        expect(codec.encode(Uint8List.fromList([0x0F, 0xB7])), '0FB7');
        expect(
          codec.encode(Uint8List.fromList([0xDE, 0xAD, 0xBE, 0xEF])),
          'DEADBEEF',
        );
        expect(codec.encode(Uint8List.fromList([0xab, 0xcd, 0xef])), 'ABCDEF');
      });

      test('should encode empty Uint8List to empty string', () {
        expect(codec.encode(Uint8List(0)), '');
      });

      test('should encode single byte correctly', () {
        expect(codec.encode(Uint8List.fromList([0x05])), '05');
        expect(codec.encode(Uint8List.fromList([0xA0])), 'A0');
      });
    });

    group('codec (round trip)', () {
      test('round trip for valid hexBinary', () {
        final data = Uint8List.fromList([
          0x01,
          0x23,
          0x45,
          0x67,
          0x89,
          0xAB,
          0xCD,
          0xEF,
        ]);
        final encoded = codec.encode(data);
        expect(encoded, '0123456789ABCDEF');
        expect(codec.decode(encoded), data);
      });

      test('round trip for lowercase hex input (encodes to uppercase)', () {
        const lexicalInput = '0123abcdef';
        final decoded = codec.decode(lexicalInput);
        expect(decoded, Uint8List.fromList([0x01, 0x23, 0xAB, 0xCD, 0xEF]));
        expect(codec.encode(decoded), '0123ABCDEF');
      });

      test('round trip for empty data', () {
        final data = Uint8List(0);
        final encoded = codec.encode(data);
        expect(encoded, '');
        expect(codec.decode(encoded), data);
      });

      test('round trip with initial/trailing whitespace', () {
        const lexicalInput = '  01AB  ';
        final expectedData = Uint8List.fromList([0x01, 0xAB]);
        final decoded = codec.decode(lexicalInput);
        expect(decoded, expectedData);
        expect(codec.encode(decoded), '01AB');
      });
    });
  });
}
