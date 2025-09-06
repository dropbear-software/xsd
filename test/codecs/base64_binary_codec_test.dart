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

      // Source: https://github.com/w3c/xsdtests/blob/master/nistData/atomic/base64Binary/
      test('should handle values defined in the NIST test suite', () {
        // Here we just want to confirm that we have a valid type for simplicity
        expect(codec.decode('ZmFyaml5Zm1i'), isA<Uint8List>());
        expect(codec.decode('dHJhZWJmc3Zhcg=='), isA<Uint8List>());
        expect(
          codec.decode(
            'Y29zaXB5amtvZnhwb2lpanhvZnRrcHVxa3BybnByZGhjeHR3c2dqcGRrdmFqbm9seXhyeHZzYnFjZm10',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('b250Z21mb2x5bGluYmduandpbnBwb3V1YWhqd2NidA=='),
          isA<Uint8List>(),
        );
        expect(codec.decode('c3Rjb2xycnd2bWpza29wdmdjbnk='), isA<Uint8List>());
        expect(
          codec.decode('dmxpbXRpbnJ3aWlwamp3ZXhiZXJ0cXBx'),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'd2xnbmNkZWN4ZWZleHNqYXZkc2xlcXRidnZ1aXV0aGhzdmZ0ZWxwbndiZmln',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('ZGdqbG5hc2tzeWN2bW5qcHdhcnhucnFndXZicXF5cmRj'),
          isA<Uint8List>(),
        );
        expect(codec.decode('ZHFzbWxnbWVw'), isA<Uint8List>());
        expect(
          codec.decode(
            'dGVmd3BsbWRmY3htcG1kd2JoaWZtcnhobXZlYWVnYXRlYWxwbm1meW14dXU=',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('cWFoYnd1dGZleWV3d3Rra3NpbnFiZGNqamdrcWF4YXZ5Y3Ri'),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'c2dmc2ZhZXBuZGZnY214Z2Rsd2N4am1hbXl3ZGRuY3hpcHZscHlzeWpkZHNwcGdwbGlpZXJzaHRqaw==',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'dXZiZ3RkcGxwZ3hkc3FqeGZtcmVsbHNqaW5qeHlma2Z5bXZiYmVrZmZ2Z2xxdHB4bW5ycHZ0anZ2amtvd2N1aWh2dWdiZGltdw==',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('d3N5cHJoZ250aWtmYml2ZGN2bGZ4cnZk'),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'eGJjeXJjbHVjcXJlbHZhbmRzamthcmprbXZydGV4Z3hoZXZtcXZ0bmx0dnh4dGRvd2ZxcmtqY2s=',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('cXNraWVxYWN1ZXh5b3F0dmRnZ2ZnbGl2eGRsdGk='),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'cnVia21pZ3d3cWF5dHlvZGtrY2tvZXF4dmRkZmthZmNwamp1ZGRvcGRrdndnZnJmdGttdnVoZ3I=',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('cnVmZGRucWV5c3ZsZ2ZzdGVyZHlyb2VtaGFtb211cG50eHN3'),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'YnVuanVxZnh0aXhzYmpjeHFmcXNxd3lrYmtjdnRrd2lqbXh3aG9xdmphdnVnampkeWdndGx1dXBzYmlnanY=',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'YnZ0cGVzYXlwZ2lvc3NoYWZodWNxb3B1cGt5Y2NudGpueXlhd29wdXFhY25qZXl1dm5ydGFn',
          ),
          isA<Uint8List>(),
        );
        expect(codec.decode('aGo='), isA<Uint8List>());
        expect(
          codec.decode(
            'YWZkcWd2a2ZzcHN5cnNjbWF3eGR2Z3Nwa2xkdWd4YXBlcHludGFvcmd3eWJsbHlz',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'dW15anlkeWxuZHhkaXF1ZWl0bHNma2pleXRhd3ViYmlxeG9reXNlZXV5c2NiY3l5aWtlc21xdHNpaWdvbA==',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('c3RmdHZoeGFmdHF3aWJmYW9wdmliY3JiZA=='),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('ZXJueG91cG9zYmtwcXZleGhmeHljc3RsdWdqcXA='),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'dHJna3FscXJ1aHVwZ2h5dGx5bXV1d2xpdGxxYnBqaWJwcHdmZGxhZ25tdnN2ZHFtdGJhaXlicnZqdGViaWthYWV3',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('YmZ1c21md3R2bmd3bnZ4cnRubG15cHJhamFsb2Rscg=='),
          isA<Uint8List>(),
        );
        expect(
          codec.decode('ZWNkbmVkcnJhZG9mYmpwb3Jwc25ic3c='),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'ZmJkZ3FtY2h0dXd5eGRnb2VzZmFoc25sYWZteHZ4cWNncWRzaWxwZWNkYmptbXRiZnc=',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'dWtyamFvdGtjbW93bXBpZWhxcGFxbHB1a2ZrZW95eHN1b2pvaXVyamVreG9zY2p2bmdybW10aHV5a2lscW1tY2thbw==',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'dGdmY2dlbmZudm14bHF5ZnlieXBreG9kZXV4cmxhanVjdGdvbXFqeGlidXNreW1ucGJiaGtkbnB5YWpscw==',
          ),
          isA<Uint8List>(),
        );
        expect(codec.decode('eHRhdnFkaXNxZQ=='), isA<Uint8List>());
        expect(
          codec.decode(
            'anV0YnBvY2JueXB0YXBtcHFycnFybWxvanFkeXdtY3llb3N0bmdtbmRxYQ==',
          ),
          isA<Uint8List>(),
        );
        expect(
          codec.decode(
            'cGJ1bGhkeGZwc2hoa3B3aWtmYWpqaW5nbGxkaGlwanh0aHliaW9qaWNpdmJpdm54cQ==',
          ),
          isA<Uint8List>(),
        );
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
