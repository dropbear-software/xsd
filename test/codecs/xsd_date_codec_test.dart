import 'package:test/test.dart';
import 'package:xsd/src/codecs/date/xsd_date_codec.dart';
import 'package:xsd/src/types/xsd_date.dart';

void main() {
  group('XsdDateCodec', () {
    const codec = XsdDateCodec();

    test('decodes string to XsdDate', () {
      final d = codec.decode('2002-10-10');
      expect(d.isFloating, isTrue);
      expect(d.value.year, 2002);
      expect(d.value.month, 10);
      expect(d.value.day, 10);
    });

    test('correctly handles whitespace', () {
      final d = codec.decode('  2002-10-10  ');
      expect(d.isFloating, isTrue);
      expect(d.value.year, 2002);
      expect(d.value.month, 10);
      expect(d.value.day, 10);
    });

    test('correctly handles tabs and newline characters', () {
      final d = codec.decode('\n\t2002-10-10');
      expect(d.isFloating, isTrue);
      expect(d.value.year, 2002);
      expect(d.value.month, 10);
      expect(d.value.day, 10);
    });

    test('encodes XsdDate to string', () {
      final d = XsdDate.parse('2002-10-10');
      expect(codec.encode(d), '2002-10-10');
    });

    test('round-trip floating', () {
      const input = '2002-10-10';
      final decoded = codec.decode(input);
      final encoded = codec.encode(decoded);
      expect(encoded, input);
    });

    test('round-trip UTC', () {
      const input = '2002-10-10Z';
      final decoded = codec.decode(input);
      final encoded = codec.encode(decoded);
      expect(encoded, input);
    });

    test('round-trip offset', () {
      const input = '2002-10-10-05:00';
      final decoded = codec.decode(input);
      final encoded = codec.encode(decoded);
      expect(encoded, input);
    });
  });
}
