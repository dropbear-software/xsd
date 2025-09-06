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

      // Source: https://github.com/w3c/xsdtests/blob/master/nistData/atomic/hexBinary/
      test('should handle values defined in the NIST test suite', () {
        // Here we just want to confirm that we have a valid type for simplicity
        expect(codec.decode('696b70746c7777656b6b686b786961737561746a6a666262646161666e617376626b6d70796c6f72786d66786d70657267706971746966636f'), isA<Uint8List>());
        expect(codec.decode('70796171746777756779647270757175746f6177636a77647766786e6e626a6c6474796c656f666874'), isA<Uint8List>());
        expect(codec.decode('6e'), isA<Uint8List>());
        expect(codec.decode('687873626a6373726f7171677270677771676c6566746b687268797867736d62716763736d6b746474686b696a7772686167676671766a6a676e6869667670796a667078726368'), isA<Uint8List>());
        expect(codec.decode('71746474'), isA<Uint8List>());
        expect(codec.decode('78787167726d70666773646363637167666a76716c746d65746265786f68666e706b6972696f7071776e626975656c767661636e756a6a6962617261'), isA<Uint8List>());
        expect(codec.decode('6b68796c66626a647371616e797170636e636d6973736677706272676a746b'), isA<Uint8List>());
        expect(codec.decode('776a6b6e6c796261626e627468767771716577787967636c706c6166'), isA<Uint8List>());
        expect(codec.decode('727172736a736b646368616575787074747667686c72746869626667767662746a76636d64786b62646a646e797068617567697063706a776674796b'), isA<Uint8List>());
        expect(codec.decode('696a66756d766e'), isA<Uint8List>());
        expect(codec.decode('786c6c716971787963'), isA<Uint8List>());
        expect(codec.decode('7772796b687870626e75736e68796966656372706b6373657064726e65706170766177716e61746263727777747361706577'), isA<Uint8List>());
        expect(codec.decode('7871646d6161686f6a747877697365686c67616d616171'), isA<Uint8List>());
        expect(codec.decode('6762736c6268707277727578686b75736d6b6873656e736970687664776d786576786d62637465716d79'), isA<Uint8List>());
        expect(codec.decode('747879637369666c796970646e6b6e616c65777064646d687967716d6e726c6e7064676b6e6871686f65616f6c676b7379696c6e7578766b646c7678756e62'), isA<Uint8List>());
        expect(codec.decode('636b6b686471656b6d656166616975717369656464636571786969636f6a747765617364706f7667666164727071766e67717771796b647274796f7771716f7373666e'), isA<Uint8List>());
        expect(codec.decode('6e74696b776161'), isA<Uint8List>());
        expect(codec.decode('66656a78736c737670696577636f6f7374736e666f716b6b6d70706372636670756376717174637271636f766174716877676c7677616b6b616b66686b796e6e'), isA<Uint8List>());
        expect(codec.decode('716f6a676d716c6a7962627064746c6d6f6b'), isA<Uint8List>());
        expect(codec.decode('7869716779776174636276726362707274646f6672636874796c77716f796d67776463706664686d79727972696a6768686c746a706d776d67757266756373777278616d616d6a74'), isA<Uint8List>());
        expect(codec.decode('687976636d666667656c66736a716c766d736a65786174746472716a6c6d6f6d7062746e756c6f70676f72696475716f716e676c6f6b6e646a72756e677662636a6c616a6e756c76'), isA<Uint8List>());
        expect(codec.decode('6f6d6861766564716d69696172637775646c7068616c767770636963697972766d696e746c69796a70796e6479706e786d71736569616f65727377776e736c65676e6f70727567'), isA<Uint8List>());
        expect(codec.decode('6b6a64797669616f6e68637177706f666a696a6464696c6864716d726b646461706d686b70747279666f70676d796d70736f6b62746d72746f75'), isA<Uint8List>());
        expect(codec.decode('697869686d6d726979716e736d6d6c716e61756f626c72656a6a6176696772737564787364757971736a7470617074766b797074736b6b6c7869656e656968616f6b63736778656975'), isA<Uint8List>());
        expect(codec.decode('676365686b6f746a'), isA<Uint8List>());
        expect(codec.decode('736967716f73666c706f79716e68676764696378'), isA<Uint8List>());
        expect(codec.decode('6a75666c716d666b72696c706e6173787067617568747268616a6166637973716a716e72766a62616864706a73616f6e686873666465716d726f64'), isA<Uint8List>());
        expect(codec.decode('64756572756677727068687376727365796679757174776b6c67686b656f67657570797976'), isA<Uint8List>());
        expect(codec.decode('656b6472646f6a6163776e71'), isA<Uint8List>());
        expect(codec.decode('6b64636963626276647477686f706770756a7068776870696c62746a63786f6b6e6a746672626c63637376776c6b73786e6b7372616266616875646175646f6167656f636e63697274'), isA<Uint8List>());
        expect(codec.decode('64616c6a716d72626b76796479706871726c7461716f67767362667264776f67'), isA<Uint8List>());
        expect(codec.decode('6873616774666a696269777162716f78766863727777797765656f74'), isA<Uint8List>());
        expect(codec.decode('63696877766e6a636270666f696c72686a'), isA<Uint8List>());
        expect(codec.decode('7561656b6979666475666e726d737662746c626d776a77766978676563646c6a6c6b6a7977716b686c7062616a6b716367'), isA<Uint8List>());
        expect(codec.decode('6b70686a6c6f676e626a61626565697378796d6d70756c7274627270776e6f7272776f646c'), isA<Uint8List>());
        expect(codec.decode('6d6f63686e7463706a67747172716b75656966746273697579687666706c6c72726e69706f6b67716d766f626b6c757171777363796b646e666468736f6f6b696464'), isA<Uint8List>());
        expect(codec.decode('666a6272766176786b6c69636d76686e6d68697968746a6264796c74656c6f78796c616973'), isA<Uint8List>());
        expect(codec.decode('6761737571766c716873746d72'), isA<Uint8List>());
        expect(codec.decode('657575657662737270776a626a70716d6878796e77627878647167786c6862657867796576686d6c63696567787261666d'), isA<Uint8List>());
        expect(codec.decode('6f6b66687469687477677775706a61'), isA<Uint8List>());
        expect(codec.decode('646f76676367746c6e6d636663696670796a6f616e6862676b656c786275666975616472687463706d77'), isA<Uint8List>());
        expect(codec.decode('6b696767676c64707177726b77777865796d63656b6b6369626a66646d6d72676877707162786765757471706c75796c6b75676b6561756b6579706c647269696c766e'), isA<Uint8List>());
        expect(codec.decode('776f64796e716c686d78776666626c6f'), isA<Uint8List>());
        expect(codec.decode('726565637367796b6d77696d66716c6e6a63757375716d6568676179667674757561766a686e6c7161756664676271676c626f63656c626c7261767168796c747265786b'), isA<Uint8List>());
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
