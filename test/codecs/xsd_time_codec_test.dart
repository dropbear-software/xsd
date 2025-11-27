import 'package:test/test.dart';
import 'package:xsd/src/types/xsd_time.dart';
import 'package:xsd/src/codecs/time/xsd_time_codec.dart';

void main() {
  group('XsdTimeCodec', () {
    const codec = XsdTimeCodec();

    test('encodes', () {
      final t = XsdTime.parse('12:00:00');
      expect(codec.encode(t), '12:00:00');
    });

    test('decodes', () {
      final t = codec.decode('12:00:00');
      expect(t.value.hour, 12);
      expect(t.isFloating, isTrue);
    });
  });
}
