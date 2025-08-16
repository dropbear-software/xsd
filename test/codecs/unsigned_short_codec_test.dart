import 'package:test/test.dart';
import 'package:xsd/src/codecs/unsigned_short/unsigned_short_codec.dart';

void main() {
  test('XML Unsigned Short Codec -> Decode', () {
    const codec = XmlUnsignedShortCodec();
    final decoder = codec.decoder;

    expect(decoder.convert('12345'), equals(12345));
    expect(decoder.convert('0'), equals(0));
    expect(decoder.convert('65535'), equals(65535));
    expect(() => decoder.convert('-1'), throwsFormatException);
    expect(() => decoder.convert('65536'), throwsFormatException);
    expect(() => decoder.convert('abc'), throwsFormatException);
    expect(() => decoder.convert(''), throwsFormatException);
  });

  test('XML Unsigned Short Codec -> Encode', () {
    const codec = XmlUnsignedShortCodec();
    final encoder = codec.encoder;

    expect(encoder.convert(12345), equals('12345'));
    expect(encoder.convert(0), equals('0'));
    expect(encoder.convert(65535), equals('65535'));
    expect(() => encoder.convert(-1), throwsFormatException);
    expect(() => encoder.convert(65536), throwsFormatException);
  });
}
